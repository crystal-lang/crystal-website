---
title: "LLVM opaque pointer support has landed"
author: HertzDevil
summary: Updates to the LLVM bindings bring support for LLVM 15+ and significant improvements in codegen performance in the next release.
comment_href: https://disqus.com/home/discussion/crystal-lang/llvm_opaque_pointer_support_has_landed_99/
---

Crystal 1.8, the upcoming minor release, will support LLVM's opaque pointers for the first time, allowing the compiler to be built with LLVM 15 or above. Additionally, this update brings a significant improvement to compilation times.

## Pointers in LLVM

To understand the significance of opaque pointers, let's take a look at a small sample program:

```crystal
# test.cr
class Foo
  def initialize(@x : Int32)
  end
end

Foo.new(1)
```

Build the above program with `crystal build --prelude=empty --no-debug --emit=llvm-ir test.cr`. The compiler will create a file `test.ll` containing our program's LLVM IR, the platform-independent intermediate representation used by LLVM to emit LLVM bytecode and eventually machine code. The following is the LLVM function corresponding to `Foo#initialize`:

```llvm
; Function Attrs: uwtable
define internal i32 @"*Foo#initialize<Int32>:Int32"(%Foo* %self, i32 %x) #0 {
entry:
  %0 = getelementptr inbounds %Foo, %Foo* %self, i32 0, i32 1
  store i32 %x, i32* %0, align 4
  ret i32 %x
}
```

Without going into the details of how exactly Crystal compiles the method into this LLVM function (although we did actually have a [write-up](https://crystal-lang.org/2015/03/04/internals/) on this in the past), we know that it:

* Takes as arguments a `%self` parameter, the `Foo` object being constructed, and the `%x` parameter coming from `Foo#initialize`;
* Assigns the address of the `Foo` object's `@x` instance variable into the local variable `%0`;
* Stores the `%x` parameter into `@x` via `%0`;
* Returns `%x` to the caller. (This caller is normally `Foo.new`, so it goes unused most of the time.)

We can see that the types of `%self` and `%0` are `%Foo*` and `i32*` respectively. These are _typed pointers_, which LLVM has been using for a long time. In LLVM, typed pointers of different pointee types must be explicitly converted using the `bitcast` LLVM instruction, otherwise the resulting LLVM IR is ill-formed. As more and more LLVM frontends came into existence, it was soon realized that typed pointers do not offer many useful semantics, and instead add an unnecessary layer of complexity over IR generation and analysis.

## Opaque Pointers

The _opaque pointer_ was first suggested back in [February 2015](https://lists.llvm.org/pipermail/llvm-dev/2015-February/081822.html), where all pointer types would be represented by a single `ptr` in LLVM IR. Then in September 2022, [LLVM 15 now uses opaque pointers by default](https://releases.llvm.org/15.0.0/docs/OpaquePointers.html#version-support), and typed pointers will be removed shortly afterwards. If we compile the program above again, but this time with a Crystal compiler built using LLVM 15, we can see the opaque pointers in action:

```llvm
; Function Attrs: uwtable(sync)
define internal i32 @"*Foo#initialize<Int32>:Int32"(ptr %self, i32 %x) #0 {
entry:
  %0 = getelementptr inbounds %Foo, ptr %self, i32 0, i32 1
  store i32 %x, ptr %0, align 4
  ret i32 %x
}
```

To get to there, a few LLVM instructions have to be built differently depending on whether typed or opaque pointers are used, and the `getelementptr` instruction is one such example. The object type used to be inferred from the given pointer, but now that opaque pointers do not carry that information, the IR generator — our Crystal compiler — needs to supply this object type separately. In this case, the `@x` instance variable and the `#initialize` method both belong to `Foo`, so Crystal knows to pass `Foo` to `getelementptr`. But this instruction is also used in a few dozen other places in the compiler, for which no universal migration is applicable.

## Crystal compiler update

Work on the migration to opaque pointers started in October 2022, a month after LLVM 15's release, and after countless segfaults and spec failures, [Crystal now supports LLVM 15 on the master branch](https://github.com/crystal-lang/crystal/pull/13173). As it was a rather huge effort, surely we want the opaque pointers to deliver the performance benefits that LLVM promises. So here are some numbers collected from re-building the compiler itself on an Apple M2, first with an LLVM 14 compiler, then with an LLVM 15 one:

* Non-release build:
  * Codegen (crystal): 2.65s → 2.84s
  * Codegen (bc+obj): 5.91s → 5.20s
  * Codegen (linking): 0.76s → 0.34s
  * dsymutil: 0.35s → 0.39s
* Release build:
  * Codegen (bc+obj): 247.86s → 184.37s
  * Codegen (linking): 0.45s → 0.33s
  * dsymutil: 0.63s → 0.52s

If we consider only the last 3 stages, which are fully in LLVM's control, that's a 18% speed-up for non-release builds and 34% speed-up for release builds! Similar figures were reported by developers who were eager enough to re-build Crystal with LLVM 15. Although it takes 0.2 second more on average to generate the LLVM IR for a program as large as Crystal itself, LLVM's improvement outweighs it by a large margin. That migration effort has certainly paid off.

## How does this affect me?

Crystal's [nightly builds](https://crystal-lang.org/install/nightlies) are already using a compiler built with LLVM 15 and are ready to try it out. 1.8 will be the first stable release built with LLVM 15. These compilers use opaque pointers and show improvements in codegen time.
Compilers built with LLVM 14 and below will continue to use typed pointers.

If your Crystal project uses the stdlib's LLVM API directly, there are some deprecations to note. Otherwise this change does not affect Crystal programs in any way. It just speeds up the compiler.

On the other hand, if you do use Crystal to build other LLVM frontends using Crystal's `LLVM` APIs, please note that Crystal will stop supporting LLVM versions below 8.0 as part of the migration, because 8.0 is the first version where LLVM accepts a separate type for the instructions affected by opaque pointers, like the `getelementptr` above. [All features that depend on typed pointers are deprecated](https://github.com/crystal-lang/crystal/pull/13172), regardless of whether LLVM 15 is actually used. The following is the full list of affected methods:

* `LLVM::Type#element_type`:  
  On LLVM 15 or above, calling this method on a pointer type raises an exception.
* `LLVM::Function#function_type`, `#return_type`, `#varargs?`  
  There is no quick migration for these methods. However, if the function was constructed via `LLVM::FunctionCollection#add`, that method now has additional overloads that can take an LLVM function type directly. This allows you to use `LLVM::Type.function` and store the type somewhere else before constructing the function.
* `LLVM::Builder#call(func : LLVM::Function, ...)`, `#invoke(fn : LLVM::Function, ...)`  
  They are equivalent to `call(func.function_type, func, ...)` and `invoke(fn.function_type, fn, ...)` respectively. Note that `#function_type` is deprecated and does not work on LLVM 15+.
* `LLVM::Builder#load(ptr, ...)`  
  This is equivalent to `load(ptr.type.element_type, ptr, ...)`. Note that `#element_type` will raise on LLVM 15+.
* `LLVM::Builder#gep(value, ...)`, `LLVM::Builder#inbounds_gep(value, ...)`  
  They are equivalent to `gep(value.type, value, ...)` and `inbounds_gep(value.type, value, ...)` respectively. Note that `#type` is simply the opaque pointer type on LLVM 15+.

Additionally, even though LLVM 15 provides an opt-in flag to enable typed pointer support, Crystal does not use this flag at all, which makes upgrading to LLVM 16 and above much easier, as LLVM will eventually remove this flag.
