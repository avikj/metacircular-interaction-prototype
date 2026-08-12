# Lantern encounter: the last three digits of `3^2026`

The seed word **lantern** selects nothing mathematical; it only breaks the
previous semantic orbit. The exact question is:

```text
What is 3^2026 mod 1000?
```

## Act once

Since `gcd(3,1000)=1` and `phi(1000)=400`, Euler's theorem gives

```text
3^400 = 1 mod 1000,
2026 = 5*400 + 26,
3^2026 = 3^26 mod 1000.
```

The residual is now explicit: the exponent is small, but computing `3^26`
modulo 1000 directly still hides why the decimal answer has its shape.

## Change representation immediately

Use `1000=8*125`. Modulo 8,

```text
3^2=1, so 3^26=1 mod 8.
```

Modulo 125, square with reductions:

```text
3^5  = 243 = -7 mod 125,
3^10 = 49 mod 125,
3^20 = 49^2 = 2401 = 26 mod 125,
3^6  = 729 = 104 mod 125,
3^26 = 3^20*3^6 = 26*104 = 2704 = 79 mod 125.
```

Now reconstruct `x=79+125k`. Modulo 8 this is

```text
7+5k=1 mod 8,
5k=2 mod 8,
k=2 mod 8.
```

Therefore

```text
3^2026 = 329 mod 1000.
```

So the last three digits are **329**.

## Operation acquired

The encounter compiles a reusable power operation. For every `a` coprime to
1000, compute powers independently in the much shorter unit groups modulo 8
and 125, then reconstruct with the already derived idempotents:

```text
a^n mod 1000
 = 625*(a^n mod 8) + 376*(a^n mod 125) mod 1000.
```

The exponent periods divide `2` and `100`, respectively, so the combined
period divides `lcm(2,100)=100`. Euler's first reduction to period 400 was
valid but nonminimal; the representation change exposes the sharper fact

```text
3^(n+100)=3^n mod 1000.
```

Indeed `2026 mod 100=26`. The residual did not merely get solved: it revealed
that the first operation had left a factor-four redundancy in the exponent.

Exact check: Python's integer `pow(3,2026,1000)` returns `329`, but no step of
the derivation depends on that check.

— **Vajra**, 2026-08-12
