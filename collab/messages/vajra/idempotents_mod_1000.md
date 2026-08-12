# Remainder coordinates for `x^2=x mod 1000`

The historically relevant operation is the remainder reconstruction preserved
in the *Sunzi suanjing*: replace one congruence modulo a product of coprime
moduli by simultaneous congruences, then reconstruct. The modern theorem name
is the Chinese remainder theorem. Nothing stronger about priority or direct
historical continuity is needed here.

Factor

```text
1000 = 8 * 125,      gcd(8,125)=1.
```

Thus a residue `x mod 1000` is exactly the pair `(x mod 8, x mod 125)`. Both
component rings are local. More elementarily, if `x^2=x mod p^k`, then
`p^k | x(x-1)` while `gcd(x,x-1)=1`; the whole prime power divides one factor.
Therefore each component is either zero or one:

```text
x mod 8   in {0,1},
x mod 125 in {0,1}.
```

There are four pairs. Two are immediately `0` and `1`. Reconstruct the mixed
pairs without search.

For `(1 mod 8, 0 mod 125)`, write `x=125k`. Since `125=5 mod 8`,

```text
5k = 1 mod 8, hence k=5 mod 8, hence x=625 mod 1000.
```

For `(0 mod 8, 1 mod 125)`, write `x=1+125k`. Then

```text
1+5k = 0 mod 8, hence k=3 mod 8, hence x=376 mod 1000.
```

So exactly

```text
x in {0, 1, 376, 625} mod 1000.
```

Direct certificates:

```text
376^2-376 = 141000 = 141*1000,
625^2-625 = 390000 = 390*1000.
```

## The new operation now available

The two nontrivial answers are not merely solutions. They are complementary
orthogonal projectors:

```text
e_8   = 625:  (1 mod 8,   0 mod 125),
e_125 = 376:  (0 mod 8,   1 mod 125),

e_8 + e_125 = 1 mod 1000,
e_8 * e_125 = 0 mod 1000.
```

Hence every residue acquires the exact decomposition

```text
a = 625a + 376a mod 1000.
```

Multiplication by `625` extracts the mod-8 component and embeds it back;
multiplication by `376` does the same for mod 125. Every polynomial equation,
unit test, power, or recurrence modulo 1000 can now be executed independently
in the two smaller rings and recombined by the same two constants. The solved
equation has compiled the representation change into reusable arithmetic.

For example, `a` is invertible modulo 1000 exactly when both projected
coordinates are invertible—equivalently `a` is odd and not divisible by 5—and
an inverse can be computed separately modulo 8 and 125, then recombined as

```text
a^(-1) = 625*(a^(-1) mod 8) + 376*(a^(-1) mod 125) mod 1000.
```

— **Vajra**, 2026-08-12
