# भावनाध्रुव — the conserved observable is a monoid map, and the product formula is an analogy

2026-08-23. Written against README movement 65. Two Agda modules landed with it; this note
carries only what the modules do not, and marks the boundary they are for.

**Sources, first.** भावना — Brahmagupta, ब्राह्मस्फुटसिद्धान्त, अध्याय १८ (कुट्टकाध्याय), 628 CE:
the composition of two solutions of the वर्गप्रकृति `x² − D y² = k`, in the समास and अन्तर
forms. ध्रुव / ध्रुवराशि — Āryabhaṭa, आर्यभटीयम्, 499 CE, the constant term of a computation.
अपवर्तन — Āryabhaṭa, आर्यभटीयम्, गणितपाद ११–१२, the reduction by the common measure. The
cyclic method that consumes the bhāvanā is the चक्रवाल: Jayadeva ~950, Bhāskara II,
बीजगणित, 1150. No European name for `x² − D y² = 1` appears in this note or in either module.

---

## 1 · What was made a term

`formal/cubical/BhavanaDhruva_TheNormIsTheConservedObservableAndTheConservingFlowsAreExactlyTheNormOneElements.agda`

`Dhruva_….agda` had the frame — an observable `f`, a flow `Φ`, and `संरक्षणम् = (a) → f (Φ a) ≡ f a`
— and one arithmetic instance, `YogaDhruva`, at addition on `ℤ × ℤ`. The multiplicative
instance was missing, and it is the one the tradition actually supplies:

- observable `नियम (a , b) = N D a b = a² − D b²`, Brahmagupta's norm;
- flow `प्रवाह u` = समासभावना with a fixed `u` on the right;
- **§१ + §२, a biconditional:** `संरक्षणम् नियम (प्रवाह u)` holds **iff** `नियम u ≡ 1`.

Forward is `bhavana` read backwards plus `·IdR`. Backward is conservation evaluated at the
unit pair `(1,0)`, where `bhA-idL`/`bhB-idL` collapse the composite to `u` and
`N D 1 0 ≡ 1`. Both directions over an arbitrary `CommRing`, no solver, no postulates.

§३: the norm-one elements are closed under bhāvanā and contain `(1,0)` — a submonoid.
**Not a group**: inverses need the अन्तरभावना with `(u₁ , −u₂)` and are not proved.

§४: `तन्तु-गति` is `संरक्षणम्-यदि` handed to Dhruva's `ध्रुव-तन्तौ`. A norm-one element
carries `fiber नियम k` — the solution set of `x² − D y² = k` — into itself, for every `k` at
once, in one line and with no new argument. That is the single step the चक्रवाल uses over
and over, isolated as pure conservation: **the orbits of the unit action are the fibres of
the norm.** Existence of a nontrivial norm-one element is the cakravāla's theorem and is not
touched here.

## 2 · The strike verified, and made a term

`formal/cubical/Apavartana_TheDropDivisorCountsHowManyAndTheCokernelNeedsHowMuchSoTheStruckIdentityIsFalse.agda`

Movement 65 struck, on 2026-08-22, the identity
`∑_p #{i : p ∣ dᵢ}·log p = ∑_i log dᵢ = log|coker(T)_tors|`. I re-derived it rather than
trusting it.

`D = diag(2,12)`: already diagonal with `2 ∣ 12`, so the invariant factors are `(2,12)`;
`det = 24`, `coker = ℤ/2 ⊕ ℤ/12`, order 24. Drop counts: `p=2` divides both `dᵢ` → 2;
`p=3` divides one → 1. Drop side `= 2·log 2 + log 3 = log 12`. Against `log 24`.
**The strike is correct.** The repaired identity, with `∑_i v_p(dᵢ)` in place of the count,
gives `3·log 2 + log 3 = log 24` and holds on the same datum.

The strike's strengthening is also correct and is the more interesting half: `diag(2,6)` has
invariant factors `(2,6)`, drop counts `2` at `p=2` and `1` at `p=3` — **identical** — and
determinant 12. Same drop divisor, different determinant. The drop divisor is strictly
lossier than the determinant, and `det` is the separating query.

The module checks the multiplicative form of all of this (`∏_p p^…` in place of `∑_p …log p`,
to stay in ℕ), invariant factors carried as exponent vectors over `{2,3}` whose values are
verified by `refl` so nothing is asserted by hand. Everything is `refl` except one `subst`
producing `¬ (12 ≡ 24)`. **Not claimed there:** the cokernel group (that is the Lean lane's
`cok_card`), the Smith normal form computation, and any general theorem — a counterexample
refutes and does not establish.

The strike is not over-broad either: it removes a *value* identity and leaves the drop
divisor `D(T)` a legitimate object, which is what the movement's second-law paragraph
actually uses.

## 3 · The fence — what in movement 65 is theorem and what is analogy

**Theorem, and cited as such in the movement:** the product formula `∏_v |x|_v = 1` for
`x ∈ ℚˣ`; Dirichlet's class number formula, 1839; the definition of Ш as
`ker(H¹(K,E) → ∏_v H¹(K_v,E))`; Atiyah–Singer. These are real and none of them is proved,
or provable, in this corpus. They are quoted mathematics.

**Checked here:** §१–§४ above, and §२'s refutation. That is all.

**Analogy, and it is worth having, and it is not structure:**

1. *The bhāvanā result is not the product formula.* It says: a conserved observable is the
   value of a monoid map, and the flows conserving it are exactly its unit set. The product
   formula is about places, completions, normalized absolute values and an archimedean term.
   None of those exist in `formal/cubical`. The shared shape — "the zero-locus of a
   multiplicative invariant is the free motion" — is a resemblance between a one-line ring
   identity and a theorem of global class field theory, and calling the resemblance an
   instance would be exactly the move this repository forbids.
2. *"Physics kept single-entry books at v = ∞."* A reading. No physics is formalised here.
3. *The parity barrier as the product formula.* A reading of a heuristic obstruction
   through a theorem about `ℚˣ`. Suggestive; not derived anywhere.
4. *The second law as monotonicity of the drop divisor.* Uses a legitimate object, and §२
   shows that object is lossier than it looked. The monotonicity claim itself is unproved.
5. *Ш as "the fibre of observe-at-every-place."* This one is nearly a tautology — a kernel
   IS a fibre over the identity — which is why it is safe, and also why it is not a result.

The failure mode this section exists against: a resonant sentence standing where a proof
belongs. Movement 65's prose is unusually good and that is precisely the hazard.

## 4 · A further false sentence, struck in the README today

> ~~Road one — the zero-locus of the price — is not a design goal; it is `ℚˣ`, the null cone
> of the adelic valuation, sitting inside the ideles with total valuation zero since before
> anyone asked.~~

`ℚˣ` is **not** the null cone. The product formula gives `ℚˣ ⊆ 𝔸¹` and nothing more, and the
containment is proper.

*Counterexample.* Let `x` be the idele with `x₂ = 3` and `x_v = 1` at every other place.
`3` is a 2-adic unit, so `|x|₂ = |3|₂ = 1`; every other component is `1`. Hence
`∏_v |x|_v = 1`, and `x` lies on the null cone. `x` is not principal: a principal idele
carries the same rational at every place, and `|3|₃ = 1/3 ≠ 1 = |x|₃`. So the null cone
contains ideles that are not rational numbers at all.

*And the gap is the movement's own next paragraph.* `𝔸¹/ℚˣ` is the norm-one idele class
group — compact, and for `ℚ` isomorphic to `ℤ̂ˣ` (standard; **not** checked in this corpus,
and I am citing it, not proving it). And the precise link to the next paragraph is not a
metaphor: **the volume of `C_K¹ = 𝔸¹_K/Kˣ` is exactly the class number formula's constant,**
`2^{r₁}(2π)^{r₂}·h·R / (w√|d_K|)` — the same expression the movement quotes from Dirichlet
1839. The size of the gap between road one and the rationals IS `hR` up to the explicit
factors. (Standard; cited, not proved here.) Movement 65 says two paragraphs later that ζ sees
`hR` and cannot split it, while asserting here that the thing `h` and `R` measure is
trivial. The two sentences contradict each other, and the second one is the true one.

Read correctly the movement is stronger: **road one is the null cone, `ℚˣ` is its principal
part, and `h` and `R` are the price of the difference.** The zero-cost locus is strictly
bigger than the rationals, and how much bigger is the class number formula. Third time in
this movement that a strike improved it, which is the pattern worth noticing: every false
sentence here was false by collapsing a fibre to a point, and the fibre it collapsed was the
interesting object each time — count for magnitude, `ℚˣ` for `𝔸¹`.

---

**Toolchain.** Agda 2.6.3 with the container's `cubical` library, `--cubical --safe`, no
postulates, no holes. This is NOT the repository's pin; `solve!` is not in scope here and
both modules are written solver-free for that reason, following `Bhavana.agda`.

**Open (`PROVE`).** (i) The norm-one elements form a GROUP, via अन्तरभावना — needs
`N D u₁ (- u₂) ≡ N D u₁ u₂` (already in `Bhavana` as `normNegB`) plus the coordinate
identity that `(u₁, −u₂)` inverts `(u₁, u₂)` under समासभावना. Close and not done.
(ii) Over `ℤ` with `D` non-square, EVERY endomorphism of `ℤ × ℤ` conserving `N D` is a
bhāvanā flow. True; the module fences it out explicitly and it would upgrade §१–§२ from a
biconditional about bhāvanā flows to a classification.
