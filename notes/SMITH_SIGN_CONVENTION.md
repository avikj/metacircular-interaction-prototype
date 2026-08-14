# The two lanes hold different Smith normal forms

**Status: checked in Agda under the pinned toolchain.** Author `claude-euclid`,
2026-08-14. Evidence is two modules in `formal/cubical/NaturalMachine/`; no
Python, no measurement.

## The claim that was not true

`NaturalMachine/SmithCapability.agda` says of the cubical library's `smith`:

> The native Cubical construction already is the proof-carrying executable
> package sought by the repository. Its output contains the normal matrix,
> invertible left/right transformations, their replay equation, and a proof of
> Smith normality. Nothing needs to be reconstructed in Python.

That is right about content and wrong about convention. The Lean lane's
acceptance predicate `Pairfield.SmithCertificate2.Valid` requires

```
0 ≤ d₁  ∧  0 ≤ d₂  ∧  (d₁ = 0 → d₂ = 0)  ∧  d₁ ∣ d₂,
```

and the native cubical output does not satisfy the first two.

```agda
d23 : Mat 2 2
d23 = mk2 (pos 2) (pos 0) (pos 0) (pos 3)

d23-second : normalMatrix d23 (suc zero) (suc zero) ≡ negsuc 5
d23-second = refl
```

`diag(2,3)` normalizes to `diag(1, -6)`. The refutation is machine-checked:

```agda
d23-not-nonneg : ¬ (normalMatrix d23 (suc zero) (suc zero) ≡ pos 6)
```

The library's `isSmithNormal` asks only that the invariant list be
consecutively divisible and end in a nonzero entry (`NormalForm.agda`,
`isConsDivs`/`∣all`). Nothing there pins a sign, and nothing should: Smith
invariants are defined up to units. The Lean lane silently chose the
nonnegative representative; the Agda lane never chose. Same theorem, two
conventions, one name.

## Why it went unnoticed

Because the capability was consumed only through its types.

Every other concrete Smith fact in the Agda corpus verifies a **supplied**
certificate. `SmithPathCountedExecution` transcribes `Up`, `Uq` and their
inverses and checks `mat≡ refl` against `diag(2,3,2)` — excellent practice, and
structurally incapable of exposing this: a checker cannot report a convention
that the producer chose, because the producer never spoke. The certificate
came from a note.

The distinguishing experiment is one line — apply `normalizeSmith` to a closed
matrix and normalize the result — and it had never been run. This is the
`natural_crystal` question asked of the repository's own capability graph: two
producers agreeing on every type still differ, and the witness separating them
has length one.

## The repair

`NaturalMachine/SmithSignNormal.agda`, at the level where the ambiguity lives —
the invariant list, not the matrix.

- `sgn : ℤ → ℤ` with `sgn x · x ≡ absℤ x` and `sgn x · sgn x ≡ 1`.
- Divisibility over ℤ is sign-blind (`∣→∣ℕ`, `∣ℕ→∣`), and
  `abs (absℤ x)` is `abs x` definitionally, so the whole chain
  `isConsDivs` transports with no arithmetic at all: `absConsDivs`.
- `signMat`, the diagonal matrix of those units, built by the same recursion as
  `smithMat`, hence involutive — `signMat ⋆ signMat ≡ 𝟙` from `⊕-⋆` and
  `sgn·sgn` — hence unimodular, and its own inverse witness.
- `signMat ⋆ smithMat xs ≡ absSmithMat xs`, which spends `sgn·` once per
  invariant and does nothing else.
- Therefore `signSim`, a `Sim` from the normal matrix to its sign-normalized
  form with `transMatR = 𝟙`, and `isSmithNormalAbs`, so `smithSignNormal`
  returns a `Smith` again.

Sign normalization is thus a change of presentation, not of content: exactly
one unimodular matrix, no arithmetic on the invariants beyond `abs`.
Idempotence (`absℤ-idem`, `absList-idem`, `absSmithMat-idem`) confirms `absℤ`
picks representatives rather than shuffling signs.

The one transport in the development is `absSmith≡`, which reconciles
`length (map absℤ xs)` with `length xs`. Everything else is index-free by
construction, because `absSmithMat` is indexed by the *original* length.

## Two facts about executability, in opposite directions

**The Agda lane evaluates.** `normalMatrix d23 zero zero ≡ pos 1` is `refl`:
the cubical `smith` reduces on closed input despite being built from
`<-wellfounded` accessibility and `subst`. Every equation in
`SmithSignControl` is checked by normalization.

**The Lean lane does not**, at the corresponding point.
`notes/RANK_ONE_SMITH_PRODUCER.md`: `Int.gcdA`/`Int.gcdB` go through
`Nat.strongRec`, so `decide` cannot evaluate `Int.gcdA 2 3`, and a producer
built on them can never have a single instance pass its own gate. That is why
that module carries a fuel-structural Euclid instead.

So the two lanes differ in the *opposite* direction from what the substrate
decision would suggest, and both differences were invisible from the types.
The general lesson has now appeared three times in this corpus in one form:
**a checked term and an evaluated term are different properties, and the
record shows only the first.**

Where the conventions do agree, the lanes agree exactly: `[[2,4],[4,8]]`
normalizes to `diag(2,0)` in Agda (`r24-first`, `r24-second`), and the Lean
producer returns `h = 2` for the same matrix.

## Rigor boundary

Both modules check with `--cubical --safe --no-import-sorts`, exit 0, **zero
warnings**, no postulates, no holes, under the toolchain
`formal/cubical/BUILD.md` pins (Agda 2.6.3, cubical v0.5).

`SmithSignControl` raises no `UnsupportedIndexedMatch` warning, unlike the
`mk3` of `SmithPathCountedExecution`, because its `mk2` is built from the
library eliminator `FinData.rec`, which is parametric in the bound and so never
unifies `suc` with an index. This independently confirms
`notes/VEC_INDEX_IS_THE_WARNING.md` on a new module: the warning is a property
of the presentation.

What is **not** claimed: the bridge from an arbitrary `M : Mat m n` to its
sign-normalized `Smith M`. `smithSignNormal` normalizes a matrix already
presented as `smithMat xs m n`; composing it with `smith M` requires
transporting `signSim` along `isSmithNormal`'s `matEq` PathP. That is the
remaining arrow, and it is bookkeeping rather than mathematics — but it is not
done, so it is not claimed.

## The state of the Agda root gate

Not part of the result above, but found while replaying it, and load-bearing
for anyone who repeats this work.

`agda NaturalMachine.agda` **does not check** under the toolchain `BUILD.md`
pins, at HEAD. The corpus is written against a newer cubical than v0.5, in at
least four independent places:

| site | corpus uses | cubical v0.5 has |
|---|---|---|
| `PathIsSymmetry`, `Decategorification` | `SymGroup` | `Symmetric-Group` |
| `SymmetryCardinality` | bare `factorial` | `Cubical.Data.Fin.LehmerCode.factorial` |
| `ConeOrder`, `DigitTowerLimit`, `Transport`, `TransportMul` | `solveℕ!` on the intro'd goal | `solve` on the quantified goal |
| `PayloadMorphism`, `ExcursionReturn`, `LeakageCommutator`, `HolonomyDescent`, … | `·IdR`, `·IdL`, `+IdR`, `+IdL`, `+InvR`, `+InvL` | `·Rid`, `·Lid`, `+Rid`, `+Lid`, `+Rinv`, `+Linv` |

`BUILD.md` describes reconciling the first three *toward* v0.5 and records the
tree as verified green on 2026-08-13 and again on 2026-08-14; commit `a6074e8`
("Connect executable corpus to current Cubical Agda") moves it the other way.
Both directions have been applied at different times and the tree currently
sits in the newer one while the documentation pins the older.

The last row is the decisive one: it is the standard cubical rename generation
and it touches many modules, so the two directions are **not** symmetric in
cost. Choosing between them (migrate the corpus to v0.5, or repin `BUILD.md` to
Agda ≥ 2.6.4 and a newer cubical — apt's Agda is 2.6.3, which cannot load it)
is a decision for the collaboration. I made the first three repairs while
diagnosing and then reverted all of them: half a migration is worse than none,
and the table above reproduces them in minutes.

This is `collab/FAILURES.md` F39 \[08-13] recurring verbatim — "treating a past
formal-check claim as current evidence without replaying the pinned gate" —
which is also the entry `BUILD.md` mis-cites for the `UnsupportedIndexedMatch`
boundary (that boundary is `notes/VEC_INDEX_IS_THE_WARNING.md`; F39 \[08-12] is
about subset-sum polynomials).

The two modules of this note were checked individually and do not depend on the
root gate.
