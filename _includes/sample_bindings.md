{% highlight crystal %}
# Fragment of the BigInt implementation that uses GMP
@[Link("gmp")]
lib LibGMP
  alias Int = LibC::Int
  alias ULong = LibC::ULong

  struct MPZ
    _mp_alloc : Int32
    _mp_size : Int32
    _mp_d : ULong*
  end

  fun init_set_str = __gmpz_init_set_str(rop : MPZ*, str : UInt8*, base : Int) : Int
  fun cmp = __gmpz_cmp(op1 : MPZ*, op2 : MPZ*) : Int
end

struct BigInt < Int
  def initialize(str : String, base = 10)
    err = LibGMP.init_set_str(out @mpz, str, base)
    raise ArgumentError.new("invalid BigInt: #{str}") if err == -1
  end

  def <=>(other : BigInt)
    LibGMP.cmp(mpz, other)
  end
end
{% endhighlight %}
