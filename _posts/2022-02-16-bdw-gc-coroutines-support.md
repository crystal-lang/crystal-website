---
title: bdw-gc coroutines support
summary: The support for multi-thread coroutines was gained by allowing the user to control the stack bottom of each thread.
thumbnail: +
author: bcardiff
---

[Crystal](https://crystal-lang.org) uses bdw-gc and supports coroutines. Fibers is how coroutines are called here. For many years Crystal has been single-thread with fibers. Single-thread is still the default alternative. Sometime ago we added muti-thread support where each thread can run concurrently multiple fibers. This required some patches and eventual contributions to bdw-gc in order to achieve this since there was no built-in support for coroutines in the library.

The support for multi-thread coroutines was gained by allowing the user to control the stack bottom of each thread. Changing the stack bottom and the instruction pointer is what effectively gives life to the coroutines. This is, letting the program choose what portion of the program to execute next without needing to tell the OS about it. Telling the OS would be equivalent to using threads and that would be more expensive.

So Crystal, and other languages, could benefit from having a mutli-thread program where in each thread multiple coroutines can be executed concurrently.

When implementing coroutines the runtime will likely have some sort of book-keeping of the existing coroutines that still need to keep executing. The record of these will involve their stack, instruction pointer and persistence of registers among other information that is specific to the runtime.

The following describes how Crystal uses bdw-gc in single-thread and in multi-thread mode to achieve the coroutines support. We will not focus on the details of the Crystal runtime and its book-keeping, this is mostly focused on the interface with bdw-gc.

The topic aspects to cover in both scenarios are:

1. What should happen when the current coroutine needs to be switched to another one?
2. How is the bdw-gc set up so it’s aware of all the coroutines, even the ones that are not running and hence are not accessible from the current stack.

## single-thread coroutines

When the current coroutine `C_0` needs to be switched another one `C_1`,

1. We set the global variable `GC_stackbottom` to `stack_bottom(C_1)`
2. We do context-switch between `C_0` and `C_1`

The value of `stack_bottom(C_1)` is known when the coroutine is allocated. Allocating a coroutine means most of the time reserving some heap space that will be used as the stack of that coroutine. Hence, the stack bottom is known at that time.

The edge case is what happens with the first coroutine, the one that belongs to the main thread of the program. Well, by using the global variable `GC_stackbottom` at the beginning of the program we can get the stack bottom of the very first fiber.

Since we are in a single-thread, all coroutines are either created by the runtime or is the main thread seen as a coroutine.

How do we do the context-switch? `C_0` will make a regular function call to a routine that preserves all the sensible context (this is arch specific), then from the saved context of `C_1` the stack pointer is restored and a return is made. Effectively we are hanging `C_0` and resuming `C_1`. There are some further details of this process in [src/fiber/context.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/fiber/context.cr) but this does not depend on the GC.

Addressing the bdw-gc set up part, we use `GC_set_push_other_roots` to hook before the GC attempts a collect. In this procedure we push all the stacks of the coroutines that are not the current one, i.e.: that are not running.

The current coroutine stack is already known by the GC via the `GC_stackbottom` and all the rest are known via the `GC_set_push_other_roots`. Since the GC will pause the main thread to perform the collect we have a good picture of all the memory we need to care about. Great!

## multi-thread coroutines

Now that the simpler single-thread is covered we can discuss the multi-thread one.

So far we didn’t need to disable the GC for the single-thread, and it’s better to keep it that way for performance reasons. But for the muti-thread environment we are going to need some lock around the switching fibers routine. We use a global [Read/Write Lock](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock).

When the current coroutine `C_0` needs to be switched another one `C_1`,

1. Mark that `C_1` is going to be executed in the current thread
2. Add a reader to the global lock
3. We do context-switch between `C_0` and `C_1`
4. Remove a reader from the global lock

It’s worth noticing that we are not accessing `GC_stackbottom` as in the single-thread case. Also, the context switch is exactly the same as before.

Since the last step is not the context switch, this means that we need to remove a reader from the global lock at the beginning of the execution of the fibers. Only in the fibers that are created by the runtime.

A way to think about this is that after the context switch, the next step is executed in `C_1`, not `C_0`. If `C_1` was previously removed by the coroutine switch the code is in place, but for the very first time it is executed it will need to perform that last step before the instructions indicated by the programmer.

Addressing the bdw-gc set up part, we still use `GC_set_push_other_roots` to hook before the GC attempts a collect. In this procedure we push all the stacks of the coroutines that are not running. We also need to deal with the running coroutines, that in this case there is one per application thread (Let’s call it application thread since there are also threads of the GC we can omit).

So, as part of this procedure we also inform the GC the stack bottom of all running fibers. For this we iterate all application threads and call `GC_set_stackbottom` with the running fiber’s stack bottom of the iterated thread.

As the final step of the procedure we remove a writer from the global lock.

So to recap the procedure registered in `GC_set_push_other_roots` do:

1. Push all stacks of fibers that are not running
2. Inform via `GC_set_stackbottom` the stack bottom of each running fiber (one per application thread)
3. Remove a writer from the global lock

The analogous to the single thread would have been calling the `GC_set_stackbottom` for each context-switch, but calling `GC_set_stackbottom` acquires a GC lock so it’s better doing it only when necessary. Maybe the single-thread case could mimic this, but for historical reasons we ended up with this difference.

We are missing where the writers are added to the global lock. This is done in a registered callback at `GC_set_start_callback`.

The effect of the global lock is to allow simultaneous context switches, unless there is a collect in progress.

As in the single-thread case there are two kind of coroutines, a) the ones manually created by the runtime that have a stack that lives in the heap of the program, and b) the ones that correspond to the threads initial stack. Knowing the stack bottom of the first one is as before, the memory is known. For the latter we use `GC_get_my_stackbottom` when the fibers are registered in the runtime.

So this is how `GC_get_my_stackbottom` and `GC_set_stackbottom` are used to enable coroutines in multi-thread environment! There are a lot of pieces coming together to make this possible so we hope this clarifies how they can be used.

## The source code

There are couple of details not covered but these are about the Crystal runtime: how to keep a pool of fibers’ stack memory so they are reused, the list of running fibers and threads in a thread-safe linked list, etc. If you are interested in the details for further motivation the relevant files are:

- [src/gc/boehm.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/gc/boehm.cr)
- [src/fiber.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/fiber.cr)
- [src/crystal/scheduler.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/crystal/scheduler.cr)
- [src/fiber/context/x86_64-sysv.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/fiber/context/x86_64-sysv.cr)
- [src/fiber/context.cr](https://github.com/crystal-lang/crystal/blob/1.3.2/src/fiber/context.cr)
