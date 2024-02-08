---
title: C-bindings
description: |
  Crystal has a dedicated syntax to easily call native libraries, eliminating the need to reimplement low-level tasks.
read_more: '[Learn how to bind to C libraries](https://crystal-lang.org/reference/syntax_and_semantics/c_bindings/)'
---

```crystal
# Fragment of the BigInt implementation that uses GMP
@[Link("gmp")]
lib LibGMP
  struct MPZ
    _mp_alloc : LibC::Int
    _mp_size : LibC::Int
    _mp_d : LibC::ULong*
  end

  fun init_set_str =
    __gmpz_init_set_str(rop : MPZ*, str : UInt8*, base : LibC::Int) : LibC::Int
  fun cmp = __gmpz_cmp(op1 : MPZ*, op2 : MPZ*) : LibC::Int
end

struct BigInt
  def initialize(str : String, base = 10)
    err = LibGMP.init_set_str(out @mpz, str, base)
    raise ArgumentError.new("invalid BigInt: #{str}") if err == -1
  end

  def >(other : BigInt)
    LibGMP.cmp(pointerof(@mpz), pointerof(other.@mpz)) > 0
  end
end

puts "10*100 > 20*50 😂" if BigInt.new("10"*100) > BigInt.new("20"*50)
```
