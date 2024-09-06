---
title: "Digging into struct initialization performance"
author: ysbaddaden
summary: "How a quick test of BLAKE3 vs SHA256 in Crystal unveiled a performance issue that stems from the Ruby syntax."
categories: technical
tags: [language,performance]
---

I toyed with BLAKE3 some months ago. I wanted to verify how much faster was BLAKE3 versus SHA256 in Crystal, and see if it would bring some free improvement. Luckily there is [a shard](https://github.com/didactic-drunk/blake3.cr) wrapping the [official library](https://github.com/BLAKE3-team/BLAKE3) that is highly optimized with custom assembly for different CPU features (SSE, AVX2, NEON …).

To my surprise, performance was pretty bad. This post is the written legacy of the quest to understand why. Be prepared to dig into technical details and how language design can impact performance.

## Let’s benchmark

One of the points for BLAKE3 is that it’s magnitudes faster than alternative hash digests; the authors claim almost 14 times faster than SHA256 for example. I wrote a quick benchmark, comparing `Digest::Blake3` to `Digest::SHA256` (backed by OpenSSL) that is usually my default choice for my use cases, for example to hash a session id made of 32 bytes.

```crystal
require "benchmark"
require "blake3"
require "digest/sha256"

class Digest::Blake3 < ::Digest
  # inject the class methods because the shard doesn't
  extend ::Digest::ClassMethods
end

Benchmark.ips do |x|
  bytes = Random::Secure.random_bytes(32)
  x.report("SHA256") { Digest::SHA256.hexdigest(bytes) }
  x.report("Blake3") { Digest::Blake3.hexdigest(bytes) }
end
```

```text
SHA256   1.33M (753.33ns) (± 0.91%)    224B/op        fastest
Blake3   1.21M (827.21ns) (± 0.79%)  2.13kB/op   1.10× slower
```

And the winner is… SHA256! What?

## Let’s investigate

The benchmark shows that `Digest::Blake3` allocates 2.13KB of memory in the HEAP for each iteration. Looking into the BLAKE3 algorithm, this is by design: the algorithm needs almost 2KB of state to compute the hash digest. That’s a lot of memory, and such a benchmark allocates memory just to throw it away immediately. Repeated HEAP allocations slow things down, as it puts pressure on the GC (it needs to regularly mark/sweep the memory which is a slow and blocking operation).

We only need the hexstring to be allocated in the HEAP. The 2KB are allocated and thrown away, so maybe we can try to put them on the stack and call the C functions directly? Let’s verify if it improves the situation.

```crystal
require "benchmark"
require "blake3"
require "digest/sha256"

def blake3_hexstring(data)
  hasher = uninitialized UInt8[1912]
  hashsum = uninitialized UInt8[32]
  Digest::Blake3::Lib.init pointerof(hasher)
  Digest::Blake3::Lib.update pointerof(hasher), data, data.bytesize
  Digest::Blake3::Lib.final pointerof(hasher), hashsum.to_slice, hashsum.size
  hashsum.to_slice.hexstring
end

Benchmark.ips do |x|
  bytes = Random::Secure.random_bytes(32)
  x.report("SHA256") { Digest::SHA256.hexstring(bytes) }
  x.report("Blake3") { blake3_hexstring(bytes) }
end
```

```text
SHA256   1.33M (754.01ns) (± 1.09%)   225B/op   3.40× slower
Blake3   4.51M (221.76ns) (± 2.57%)  80.0B/op        fastest
```

We now only allocate 80 bytes for each digest (for the hexstring) and BLAKE3 is much faster! We’re far from the 14× claim, but the data to hash is small, and the C library chose the SSE4.1 assembly for my CPU; the AVX512 assembly could be faster, but my CPU doesn’t support it.

## Let’s refactor as idiomatic Crystal

With the performance back, I went on with refactoring the shard, wrapping the C functions inside a `struct` so we get a nice, idiomatic and optimized Crystal. At best we can use the struct directly, for example in the one time uses of `Digest::Blake3.hexdigest`. At worst I’ll embed it in the class for the yielding and streaming cases that will need to allocate 2KB in the HEAP, but the longer the message to hash, the less impactful the initial HEAP allocation is.

```crystal
require "benchmark"
require "blake3"
require "digest/sha256"

struct Blake3Hasher
  def initialize
    @hasher = uninitialized UInt8[1912]
    Digest::Blake3::Lib.init(self)
  end

  def update(data)
    Digest::Blake3::Lib.update(self, data.to_slice, data.bytesize)
  end

  def final(hashsum)
    Digest::Blake3::Lib.final(self, hashsum, hashsum.size)
  end

  def to_unsafe
    pointerof(@hasher)
  end
end

def blake3_hexstring(data)
  hasher = Blake3Hasher.new
  hashsum = uninitialized UInt8[32]
  hasher.update(data)
  hasher.final(hashsum.to_slice)
  hashsum.to_slice.hexstring
end

Benchmark.ips do |x|
  bytes = Random::Secure.random_bytes(32)
  x.report("SHA256") { Digest::SHA256.hexdigest(bytes) }
  x.report("Blake3") { blake3_hexstring(bytes) }
end
```

```text
SHA256   1.34M (744.61ns) (± 0.52%)   225B/op   1.38× slower
Blake3   1.85M (539.81ns) (± 1.22%)  80.0B/op        fastest
```

And… performance is crashing down.

## What is going on?

We still only allocate 80B in the HEAP because structs are allocated on the stack, so what’s going on? Aren’t wrapping structs supposed to be free abstractions in Crystal? Because this is clearly not the case here. Is LLVM failing to inline the struct and method calls, and is BLAKE3 so fast that any overhead degrades performance?

There are no more hints to understand what’s happening here. We must dig into the generated code to do any further investigation. I generated the LLVM IR for the above benchmark: 

```console
$ crystal build --release --emit llvm-ir --no-debug bench.cr
```

The above command will generate a `bench.ll` file in the current directory. We build in release mode so that LLVM will optimize the code, and tell Crystal to not generate debug information to improve the readability. Sadly, I couldn't find anything weird there.

> **NOTE:**
> While I’m writing this blog post I notice that the LLVM IR does exhibit the exact same issue as the disassembly below. I have no idea how I didn’t notice it… maybe I forgot `--release` 🤦

Let’s go deeper and inspect the generated assembly for my CPU. We can disassemble the executable with `objdump -d` for example, and this time I immediately noticed something weird: the function calls `Blake3::Hasher.new` followed by pages of MOV instructions, while the disassembly of the direct C function calls are just a few instructions and function calls.

Here is the disassembly for the slow `struct` case. Looking into the rest of the disassembly, the same is happening inside `Blake3Hasher.new` when initializing `@hasher`: too many repeated MOV instructions to count.

```text
000000000003cf70 <~procProc(Nil)@bench.cr:35>:
   (... snip...)
   3cfa0:       e8 0b 1d 00 00          callq  3ecb0 <*Blake3Hasher::new:Blake3Hasher>
   3cfa5:       48 8b 84 24 10 16 00    mov    0x1610(%rsp),%rax
   3cfac:       00
   3cfad:       48 89 84 24 00 07 00    mov    %rax,0x700(%rsp)
   3cfb4:       00
   3cfb5:       48 8b 84 24 08 16 00    mov    0x1608(%rsp),%rax
   3cfbc:       00
   (... snip: the above 2 MOV are repeated with a different index ...)
   3ec3b:       4c 8d bc 24 28 07 00    lea    0x728(%rsp),%r15
   3ec42:       00
   3ec43:       4c 89 ff                mov    %r15,%rdi
   3ec46:       48 8b b4 24 10 07 00    mov    0x710(%rsp),%rsi
   3ec4d:       00
   3ec4e:       48 8b 94 24 08 07 00    mov    0x708(%rsp),%rdx
   3ec55:       00
   3ec56:       e8 e5 32 01 00          callq  51f40 <blake3_hasher_update>
   (... snip ...)
```

Here is the disassembly for a release build (LLVM inlined the C calls). It’s so small that I don’t need to snip anything. It's quite readable, even if you don’t know assembly (I don’t know much myself): it reserves space on the stack (0x7b0), saves/restores callee-saved registers and calls the functions:

```text
000000000003cfb0 <~procProc(Nil)@bench.cr:44>:
   3cfb0:       41 57                   push   %r15
   3cfb2:       41 56                   push   %r14
   3cfb4:       53                      push   %rbx
   3cfb5:       48 81 ec b0 07 00 00    sub    $0x7b0,%rsp
   3cfbc:       48 8b 5f 08             mov    0x8(%rdi),%rbx
   3cfc0:       4c 63 37                movslq (%rdi),%r14
   3cfc3:       4c 8d 7c 24 38          lea    0x38(%rsp),%r15
   3cfc8:       4c 89 ff                mov    %r15,%rdi
   3cfcb:       e8 20 16 01 00          callq  4e5f0 <blake3_hasher_init>
   3cfd0:       4c 89 ff                mov    %r15,%rdi
   3cfd3:       48 89 de                mov    %rbx,%rsi
   3cfd6:       4c 89 f2                mov    %r14,%rdx
   3cfd9:       e8 02 17 01 00          callq  4e6e0 <blake3_hasher_update>
   3cfde:       48 8d 5c 24 18          lea    0x18(%rsp),%rbx
   3cfe3:       ba 20 00 00 00          mov    $0x20,%edx
   3cfe8:       4c 89 ff                mov    %r15,%rdi
   3cfeb:       48 89 de                mov    %rbx,%rsi
   3cfee:       e8 3d 1f 01 00          callq  4ef30 <blake3_hasher_finalize>
   3cff3:       c7 44 24 08 20 00 00    movl   $0x20,0x8(%rsp)
   3cffa:       00
   3cffb:       c6 44 24 0c 00          movb   $0x0,0xc(%rsp)
   3d000:       48 89 5c 24 10          mov    %rbx,0x10(%rsp)
   3d005:       48 8d 7c 24 08          lea    0x8(%rsp),%rdi
   3d00a:       e8 41 fd ff ff          callq  3cd50 <*Slice(UInt8)@Slice(T)#hexstring:String>
   3d00f:       48 81 c4 b0 07 00 00    add    $0x7b0,%rsp
   3d016:       5b                      pop    %rbx
   3d017:       41 5e                   pop    %r14
   3d019:       41 5f                   pop    %r15
   3d01b:       c3                      retq
   3d01c:       0f 1f 40 00             nopl   0x0(%rax)
```

All the MOV instructions look like we are… copying the struct?

I tried to allocate the struct on the stack and call an `init` method on it —it merely calls `#initialize` but we can’t call it directly because `#initialize` methods are protected in Crystal. The only change in the `blake3_hexstring` method is:

```crystal
hasher = uninitialized Blake3Hasher
hasher.init
```

```text
SHA256 944.38k (  1.06µs) (± 0.97%)   225B/op   3.50× slower
Blake3   3.30M (302.91ns) (± 2.24%)  80.0B/op        fastest
```

Performance is finally on par with calling the C functions directly. It means that LLVM is now doing its job at optimizing the abstraction away. Looking at the disassembly, the generated block is *identical* to the direct C function calls that I listed above. LLVM did a perfect job at optimizing the struct away!

## What’s happening

The struct is first initialized, then the 2KB are *copied* using too many assembly instructions to count them. Sure, it all happens on the stack, but it takes an awful lot of CPU time to copy all that, and it appears to do so *twice*? No wonder performance gets destroyed.

Structs are initialized exactly like classes are: through constructor methods. While classes return a reference (one pointer) structs return the value itself that must be copied which can be an expensive operation. This is the origin of the problem. The Crystal codegen always generates a constructor method that looks like that:

```crystal
struct Blake3Hasher
  def self.new(*args, **kwargs) : self
    value = uninitialized self
    value.initialize(*args, **kwargs)
    value
  end
end
```

> [!TIP]
> We can say that the problem originates from the Ruby syntax. The `.new` constructor is very nice and applies well to classes, but the design applies poorly to Crystal structs as it encourages copies that won’t be optimized by LLVM. Other languages, such as C, Go or Rust don’t have this problem because they’re not object-oriented languages: you declare a variable (undefined) then call a function to initialize it (with a pointer to the struct).

So here is the crux of the issue: when we initialize a struct, the struct is copied on the stack. It's barely noticeable when it's a few bytes but it’s painful once the struct goes bigger. LLVM inlines everything into a single method in release mode, and it does optimize the struct & its methods away, but it won’t optimize the copy away, which is surprising.

## Can we fix it?

Instead of generating a constructor for structs, the Crystal codegen could declare the variable on the stack then call `#initialize` as I did above. Still, that may be easier said than done; if you have any custom constructors on your structs, the issue will come back for example, but maybe [Ameba](https://github.com/crystal-ameba/ameba) could warn about it?

## Bonus

We saw that LLVM sometimes optimizes the copy away and sometimes doesn’t. But what's the threshold? I ran some tests and reading the disassembly or release builds I found out that:

* When the ivar is a `Pointer` (64-bit), the struct is fully abstracted away;
* When the ivar is an `UInt64` or `UInt64[1]` (64-bit) the assembly changes slightly (a few MOV and LEA instructions more) despite the struct being exactly the same size than the pointer with the same alignment;
* When the ivar is a `UInt64[2]` or two pointers (128-bit), the assembly starts to involve some XMM registers to copy the struct.

> **NOTE:** Tip
> The struct is a free abstraction (in terms of runtime) when it wraps one pointer. It involves some overhead as soon as it wraps anything else or more data.
