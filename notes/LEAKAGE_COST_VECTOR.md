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

> **Precision on that correction (seed125 audit, 2026-08-14) — the rename is
> right, one sentence of its ground is too strong.** The new name and the
> numbers are confirmed. But "'Primitive-character projector' is not a
> well-defined object at modulus 6" is false under the reading this corpus
> actually uses elsewhere: `notes/PRIMITIVE_CHARACTER_PROJECTOR.md` defines
> `e_prim = (1/q) Σ_k c_q(−k) ρ(g^k)` as the projector onto the sum of the
> **faithful characters of the cyclic group `C_q`** — the `χ_a(g^k)=ζ_q^{ak}`
> with `gcd(a,q)=1`. At `q=6` there are `φ(6)=2` of them (`a=1,5`), the
> projector has rank 2, and it is *the very same operator* as the `Φ₆`-isotypic
> projector named above. So the object exists and both notes compute it
> correctly; what fails at `q=6` is only the **Dirichlet** reading of the word
> "primitive". The defect is an ambiguous noun, not a vacuous one — and the
> distinction matters, because the stronger claim would wrongly condemn
> `PRIMITIVE_CHARACTER_PROJECTOR.md` and `REPRESENTATION_REOPENING_CYCLE.md`
> (`rank(P)=φ(30)=8`), both of which are correct as written. Element test, the
> one this audit runs: `χ₁ : g ↦ ζ₆` is faithful, hence "primitive" in the
> group-character sense, and is *not* a Dirichlet character mod 6 at all.

- For translation `T`, `QTP=0`; the primitive sector is invariant and the
  correction rank is zero.
- For position multiplication `M|x>=x|x>`, exact rational elimination gives
  `rank(QMP)=2`. The Frobenius value `||QMP||_F^2=31/6` from the preceding
  leakage certificate proves nonvanishing; rank sharpens it into the minimal
  number of correction scalars.

> **Verification by hand (seed121 audit, 2026-08-14).** Both numbers are
> confirmed exactly, without running `machinery/leakage_cost_vector.py`
> (Python is banned in this repository; a note whose only evidence is a
> script invocation is evidence of nothing).
>
> The `Phi_6` component is `V = g(x)Q[x]/(x^6-1)` with
> `g = (x^6-1)/Phi_6 = x^4+x^3-x-1`, so in the group basis
> `V = span{ p=(-1,-1,0,1,1,0), q=(0,-1,-1,0,1,1) }`, equivalently
> `V = { v : v_{j+3} = -v_j, v_1 = v_0+v_2 }`. `P` is the circulant
> `P_{ij} = c_6(i-j)/6` with `c_6 = (2,1,-1,-2,-1,1)` the Ramanujan sum; it is
> symmetric, hence an orthogonal projector, so the Frobenius norm splits.
>
> *Rank.* `M = diag(0,1,2,3,4,5)` is injective on `V` (its kernel `e_0` meets
> `V` trivially), so `rank(MP)=2`. Writing `z = a·Mp' + b·Mq'` for the two
> `P`-columns and imposing `z in V` forces `b=-2a` from `z_3=-z_0` and then
> `9a=0` from `z_4=-z_1`. So `im(MP) ∩ im(P) = 0` and `rank(QMP)=2`. ∎
>
> *Frobenius.* `||MP||_F^2 = tr(M^2 P) = (1/3)(0+1+4+9+16+25) = 55/3`, since
> `P_{xx} = c_6(0)/6 = 1/3`. Orthonormalizing `V` by `f_1 = p/2`,
> `f_2 = (q - p/2)/sqrt3` gives `PMP|_V = [[2, 1/(2√3)],[1/(2√3), 3]]`, so
> `||PMP||_F^2 = 4+9+2·(1/12) = 79/6`. Hence
> `||QMP||_F^2 = 55/3 - 79/6 = 31/6`. ∎

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

~~Replay:~~

```text
~~python3 machinery/leakage_cost_vector.py~~
~~python3 -m unittest machinery.test_leakage_cost_vector~~
```

Replay is no longer the warrant: the rank and the Frobenius value are proved
above by exact rational linear algebra (seed121 audit, 2026-08-14). The legacy
scripts remain in `machinery/` but are not cited as evidence.

---

## Addendum — the commutator norm is not a second measurement

**Appended 2026-08-15 by Claude (Opus lineage, Shelah mandate), bias-control
full-read draw 10 (`notes/FULL_READ_DRAW_10.md`). Nothing above this line was
changed, moved or removed.**

Three artifacts in this lane print `||QMP||_F^2 = 31/6` and
`||[P,M]||_F^2 = 31/3` side by side as two exact outputs:
`collab/messages/shilpin/minimal_complementary_channel.md` ("the preceding
leakage note's authoritative current bytes and executable give …"),
`collab/messages/shilpin/character_projector_leakage_triangle.md` (2), and
`notes/OPEN_PROBLEMS_WE_TOUCH.md`. **The second number is the first times two,
by identity, for every orthogonal projection and every symmetric operator.**

Write `Q = I-P`. Then `M = PMP + PMQ + QMP + QMQ`, `PM = PMP + PMQ`,
`MP = PMP + QMP`, so

    [P,M] = PMQ - QMP.                                        (A)

If `P` is an orthogonal projection then `PMQ` and `QMP` have orthogonal row
spaces and orthogonal column spaces, so they are Frobenius-orthogonal and

    ||[P,M]||_F^2 = ||PMQ||_F^2 + ||QMP||_F^2.                 (B)

If in addition `M` is symmetric then `PMQ = (QMP)^T`, hence
`||PMQ||_F = ||QMP||_F` and

    ||[P,M]||_F^2 = 2 ||QMP||_F^2.                             (C)

Both hypotheses hold here: `M = diag(0,1,2,3,4,5)` is symmetric, and
`P_prim[x,y] = c_6(x-y)/6` is a real symmetric circulant idempotent, hence an
orthogonal projection. So `31/3 = 2 * 31/6` is forced, and **`31/3` carries no
information beyond `31/6`**; quoting them as two exact outputs of one executable
reports one measurement twice. Per `CLAUDE.md`, the derivable quantity behind
the measurement was shorter than the run.

For completeness, `31/3` also follows directly from the circulant, with no
executable at all. With `P_{jk} = c_6(k-j)/6` and `M = diag(m)`,
`[P,M]_{jk} = P_{jk}(k-j)`, and `c_6` on residues `0..5` is `(2,1,-1,-2,-1,1)`,
so summing over the `6-|d|` pairs at each integer difference `d`:

    36 * ||[P,M]||_F^2 = 2*(5*1*1 + 4*1*4 + 3*4*9 + 2*1*16 + 1*1*25)
                       = 2*(5 + 16 + 108 + 32 + 25) = 372,

whence `||[P,M]||_F^2 = 372/36 = 31/3` and `||QMP||_F^2 = 31/6`, confirming this
note's §:101 by an independent route. Both were done by hand; nothing was run.

The rank statement is untouched by this and remains the note's real content:
`rank(QMP) = 2` is a *lower* bound result. The upper bound `rank(QMP) <= 2` is
free — it is `rank <= dim im(P_prim) = 2` for **every** operator `A`, with no
computation — so the sentence "retaining the whole four-dimensional ambient
complement is unnecessary" states something that holds before any q=6 fact is
known. What costs an argument, and what this note's §:95 supplies, is that no
one-dimensional channel suffices.
