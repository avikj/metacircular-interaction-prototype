# 0953 — भावना is a commutative monoid on norm-one rows (closure, identity, comm — checked)

New module over `Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt`:

`punaragamana/src/Punaragamana/VargaPrakrtiVarga_TheNormOneSolutionsAreAMonoidUnderBhavanaSoTheFundamentalUnitGeneratesTheLadder.agda`

Source: Brahmagupta, *Brāhmasphuṭasiddhānta* 18 (628 CE), भावना. The monoid
reading is a modern packaging of भावना-क्षेपः, not attributed to
Brahmagupta/Jayadeva/Bhāskara II as their stated theorem.

Landed, all `--cubical --safe`, no postulates, no holes:

- **भावना-संवृतिः** (closure): क्षेपः D (a,b) ≡ 1 and क्षेपः D (p,q) ≡ 1
  ⇒ क्षेपः D (भावना D p q (a,b)) ≡ 1. Immediate from भावना-क्षेपः + cong₂ _·_.
- **एकत्व-क्षेपः**: क्षेपः D (1,0) ≡ 1.
- **भावना-एकत्व-वाम** / **भावना-एकत्व-दक्षिण**: भावना D 1 0 (a,b) ≡ (a,b)
  and भावना D a b (1,0) ≡ (a,b) — two-sided identity, both directions
  proved by hand from `·Rid`, `·Comm`, `pos0+` (no ring solver, matching
  the cited module's solver-free discipline).
- **भावना-क्रमविनिमयः** (commutativity of भावना as rows): भावना D p q (a,b)
  ≡ भावना D a b (p,q).

**Not proved — explicit open goal, stated not faked**: full associativity.
भावना's curried "fixed row acting on a base pair" shape has no term yet for
"two fixed rows composed INTO one row" (that would need भावना itself lifted
to combine (p,q) and (r,s) into a third row before three-fold associativity
even types against भावना(a,b)) — building that is exactly the scope the
cited module's "SECOND DEFECT" leaves out. Left as a commented-out
statement in the header, not postulated, not faked with a fake proof.

`./check.sh` tail:

```
 Checking Punaragamana.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt (...)
 Checking Punaragamana.VargaPrakrtiVarga_TheNormOneSolutionsAreAMonoidUnderBhavanaSoTheFundamentalUnitGeneratesTheLadder (...)
 Checking Punaragamana.Sthanivadbhava_... 
 Checking Punaragamana.BhittiSthanivat_...
 Checking Punaragamana.SthanivatSankhya_...
==> OK: all modules check under --cubical --safe
```

Agda 2.6.3 + cubical v0.5, via `check.sh`'s own bootstrap.

Branch: `claude/varga-monoid-c287529` (new branch, not main, not
`claude/punaragamana-gwmtzh`). Commit `c287529e`.
