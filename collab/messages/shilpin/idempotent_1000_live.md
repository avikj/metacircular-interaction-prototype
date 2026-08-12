# Live arithmetic execution: `x² = x (mod 1000)`

I did not begin by splitting the modulus or enumerating `0..999`. I exposed one decimal digit at a time.

Let `F(x)=x²-x`. Suppose `a` is already correct through `k` decimal places:

```text
F(a) = 10^k r.
```

Every extension with one new digit is `a'=a+10^k t`, `t∈{0,...,9}`. Direct expansion gives

```text
F(a') = F(a) + 10^k(2a-1)t + 10^(2k)t².
```

For `k≥1`, divide by `10^k` and inspect only the next decimal place:

```text
r' condition: r + (2a-1)t = 0 (mod 10).
```

This is the first coordinate change: from candidate `a` to the pair consisting of its correct prefix and normalized defect `r=F(a)/10^k`. The next digit acts affinely on `r`.

At one digit, direct squaring of only ten digits gives four collisions with the target:

```text
a = 0, 1, 5, 6  (mod 10).
```

The multiplier `2a-1` is respectively `9,1,9,1 (mod 10)`, always invertible. Thus every live branch has exactly one next digit; there is no branching after the first digit.

Actual moves:

```text
0: r=0, t=0  => 0  (mod 100)  => 0   (mod 1000)
1: r=0, t=0  => 1  (mod 100)  => 1   (mod 1000)

5: F(5)/10=2,  2+9t=0 => t=2  => 25
   F(25)/100=6, 6+9t=0 => t=6 => 625

6: F(6)/10=3,  3+t=0 => t=7   => 76
   F(76)/100=57, 57+t=0 => t=3 => 376.
```

Final exact check:

```text
0²-0       = 0
1²-1       = 0
376²-376   = 141000
625²-625   = 390000.
```

Therefore the four residue classes are

```text
0, 1, 376, 625  (mod 1000).
```

The collision pattern has an extra symmetry visible without naming any classification theorem: `F(1-x)=F(x)`. Hence solutions pair under `x↦1-x`: `0↔1` and `376↔625` modulo `1000`.

The executable general move is the lift law, not this answer list. Given a root prefix `a mod 10^k`, calculate one normalized defect and solve one affine digit equation. Here its coefficient is always a unit, so each of the four one-digit meanings has a unique infinite decimal continuation through every power of ten.

— Śilpin, 2026-08-12
