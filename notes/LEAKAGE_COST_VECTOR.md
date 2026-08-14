# Sector leakage is an exact correction channel, not a scalar penalty

Let `P` be a projector, `Q=I-P`, and let an input lie in the selected sector
`im(P)`. For a future linear operator `A`,

```text
A P = P A P + Q A P.                                      (1)
```

Sector-only execution retains the first term. It is an exact replacement for
the full output exactly when the leakage map

```text
L = Q A P
```

vanishes.

## Minimal correction theorem

If an exact correction is encoded through an `r`-dimensional linear channel,
then `L` factors as

```text
im(P) --encode--> K^r --decode--> im(Q).
```

Therefore `rank(L)<=r`. Conversely, taking the intermediate space to be
`im(L)` gives a factorization of dimension `rank(L)`. Hence

```text
minimal exact correction-channel dimension = rank(QAP).   (2)
```

This is only rank factorization: the lower bound follows from
`rank(decode encode)<=r`, and the image factorization attains it.
`machinery/leakage_cost_vector.py` constructs exact rational matrices `B,C`
with `L=BC` and inner dimension `rank(L)`.

## The `q=6` boundary

~~Take the primitive-character projector on `Q[C_6]`.~~
Take the `Phi_6`-isotypic projector on `Q[C_6]`.

> **Correction (seed121 audit, 2026-08-14).** "Primitive-character projector"
> is not a well-defined object at modulus 6: there are **no primitive
> Dirichlet characters mod 6**. There are only two characters mod 6, and the
> nontrivial one has conductor 3 (it is induced from the quadratic character
> mod 3). The rank-2 projector actually used — and the one for which the
> numbers below are correct — is the isotypic projector onto the
> `Phi_6(x) = x^2-x+1` component of `Q[C_6] = Q[x]/(x^6-1)`, i.e. the
> primitive-*sixth-root-of-unity* component. Renamed above; nothing else in
> the section changes.

- For translation `T`, `QTP=0`; the primitive sector is invariant and the
  correction rank is zero.
- For position multiplication `M|x>=x|x>`, exact rational elimination gives
  `rank(QMP)=2`. The Frobenius value `||QMP||_F^2=31/6` from the preceding
  leakage certificate proves nonvanishing; rank sharpens it into the minimal
  number of correction scalars.

Thus restricted position execution without a correction channel is invalid,
not merely approximate or costly. Carrying two scalar coordinates per query
is sufficient and necessary for reconstructing the leaked component.

## Break-even as a vector

For the declared `W30` cost certificate `(C,D,S)=(72,30,8)` and four future
queries, the translation-preserving case remains

```text
old       = (120 baseline operations, 0 correction scalars, exact),
compiled  = (104 baseline operations, 0 correction scalars, exact).
```

For the `q=6` position operator:

```text
old                 = (120, 0, exact),
restricted compiled = (104, 0, inexact),
corrected compiled  = (104, 8, exact).
```

The corrected route transmits `4*rank(QMP)=8` correction scalars. It saves
sixteen operations but uses a nonzero second resource. Without a declared
exchange rate between operations and correction bandwidth, neither exact
route dominates the other: `(104,8)` and `(120,0)` are Pareto-incomparable.
No scalarization is silently installed.

This crossing is an abstract resource example: the leakage matrix is the
`q=6` character-sector calculation, while `(72,30,8)` is the independently
declared `W=30` query-cost model. It does not assert that they are one modulus
or one benchmark; it shows how any certified leakage rank extends an existing
plural break-even record.

If a caller later declares a correction cost in the same unit, it may add
that coordinate explicitly and recompute the threshold. Until then, leakage
is a hard validity boundary plus a separate resource coordinate.

Replay:

```text
python3 machinery/leakage_cost_vector.py
python3 -m unittest machinery.test_leakage_cost_vector
```
