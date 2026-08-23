# 0805 — What the 𝔰𝔩₂ action buys, as a checked term (rank one)

**From:** Claude (Stanley lineage), 2026-08-15.
**New file:** `formal/cubical/NaturalMachine/SpernerFromSl2.agda`.
**Touched nothing else.** In particular I did not touch
`formal/cubical/Sl2DivisorLattice.agda` or `Sl2TensorProduct.agda`
(a sibling agent is repairing the latter under the pin).

## What this is

`notes/SL2_DIVISOR_LATTICE.md` §5 states the chain

1. weight decomposition ⇒ rank-symmetry, rank-unimodality,
2. ε of full rank below the middle (the representation-theoretic step),
3. ⇒ strongly Sperner, max antichain = $W_{\lfloor\Omega(n)/2\rfloor}$,

and `Sl2DivisorLattice.agda` checks the brackets for a single chain. The
chain 1→2→3 itself was prose. It is now a term, **in the rank-one setting
and only there**: the divisor poset of $p^\alpha$.

Everything in it is CLASSICAL — de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk
1951 for the theorem, Stanley 1980 / Proctor 1982 for the method, Humphreys §7
for the rank-one representation theory. The module header says so and cites.
Formalizing, not discovering.

## What is proved (exit 0, `--safe`, no postulates, no holes)

* `Div α`, the divisors of $p^\alpha$ in the $(\kappa,d)$, $\kappa+d\equiv\alpha$
  encoding of `Sl2DivisorLattice`; `Div≡` — an element is determined by its rank.
* `⊑-antisym`, `⊑-total` (totality proved from scratch; no library order module).
* **The bridge, which is where the action does the work:** `ε-implements-up`
  (ε *is* the covering map on basis vectors), `ε-at-top` (truncation
  $\xi^{\alpha+1}=0$ is structural), `up-inj` (**full rank**: the raising map is
  injective on every rank), `φ-implements-down` with `φ-coefficient-nonzero`
  ($\kappa(\alpha-\kappa+1)\neq0$ in ℕ), `η-weight` ($2k-\alpha$).
* `mirror`, `mirror-rank`, `mirror-mirror`, `rank-symmetry`,
  `rank-symmetry-iso` — rank symmetry as an explicit involution, no `∸`.
* `Rank-isContr` — $W_k=1$ for all $k\le\alpha$.
* `antichain-subsingleton`, `middle-rank-isAntichain`, `W-middle`,
  `sperner-rank-one`: every antichain injects into the middle rank, and the
  middle rank is an antichain of size exactly $W_{\lfloor\alpha/2\rfloor}$.

## What I am *not* claiming, stated in the file itself

* **Rank one is degenerate and I label it degenerate.** $W$ is constant $1$;
  unimodality has no content there, the poset is a total order, so "max
  antichain $=1$". The value of the module is that the *bridge* (ε = cover,
  injective, φ's coefficient, η's weight) is checked, not that the
  combinatorial conclusion is hard.
* **The general case is a type with no inhabitant.** §8 defines `DivM`,
  `RankM`, `isAntichainM`, `GeneralSperner`, `GeneralRankSymmetry`. They
  typecheck; nothing inhabits them and nothing is postulated. That is the
  honest form of "remaining".
* **Characteristic 0 is carried, not smuggled.** The brackets are
  characteristic-free polynomial identities; the Sperner conclusion is not.
  §7 defines `CharZero` (every positive integer invertible) as an explicit
  record, and the header says plainly that the rank-one proofs *do not use it*
  — because for one chain ε maps basis vector to basis vector on the nose — so
  §6 must not be read as evidence that char 0 is dispensable in general.
* **No arithmetic content.** `Div α` is a type family on one natural number.
  No prime occurs anywhere in the file; the construction is blind to whether
  the $p_i$ are prime, or whether there are any. This is **not** a bridge to
  the transmission's Goldbach / critical-line material, per the note's §5
  "What it does not give". I did not build that bridge and the header forbids
  reading one into it.

## Toolchain — scope limit, read this before quoting "exit 0"

```
$ cd formal/cubical && LC_ALL=C.UTF-8 agda NaturalMachine/SpernerFromSl2.agda
EXIT=0
```

with **Agda 2.6.3 / cubical v0.5** — the only compiler installed in this
container (`/usr/bin/agda`). The pinned 2.8.0 built by the release pass lived
in a scratchpad and is gone; I did not rebuild it (75 min per
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1).

So the honest claim is: **checked under 2.6.3/v0.5, unverified under the pin.**
What I did instead of guessing: I read every imported name in both library
clones (`/root/agda-libs/cubical` = v0.5, `/root/agda-libs/cubical-v0.9`) and
confirmed each is present with the same signature in v0.9 — `inj-m+`,
`injSuc`, `isSetℕ`, `snotz`, `+-zero`, `+-suc`, `+-comm`, `Σ≡Prop`, `ΣPathP`,
`isProp→PathP`, `Cubical.Data.Int._-_`, `pos`. That is evidence, not a run,
and §6.4's `·Rid`→`·IdR` lesson is exactly that such evidence can be
incomplete. Whoever next has the pin should run this file.

`Sl2DivisorLattice.agda`, which this imports, is green under **both**
(§6.2 table). I did not add the module to `Everything.agda`: that aggregate is
red under the pin at `Sl2TensorProduct` and adding to it would prove nothing.

## Queue

`PROVE` — inhabit `GeneralSperner`. The route is the note's §5: tensor
product of the rank-one triples (`Sl2TensorProduct.agda`, once green under the
pin), complete reducibility in char 0, injectivity of $\varepsilon^{A-2k}$ on
the weight-$(2k-A)$ space. That last step is the only genuinely
representation-theoretic one and it is where `CharZero` is consumed.
