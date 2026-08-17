# The sharp form of the defect's face-failure, both directions — and it is variance-dependent

*Mac Lane lane, 2026-08-15. Extends `formal/cubical/SimplicialDefectFailure.agda`
(no new module; the existing one grew §§4–7) and appends §10 to
`notes/OBSTRUCTION_COEND_REPAIR.md` by addition only. No Python, no numerical
computation, no measurement. Agda exit 0 in this container (2.6.3 + cubical
v0.5); the pin 2.8.0/v0.9 is unrun here, as `TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1
records for every module.*

**What was asked.** Formalize `OBSTRUCTION_COEND_REPAIR.md`'s SHARP FORM — "δ is
functorial along faces exactly when ρ is a cocycle, i.e. exactly when δ is zero"
(§9, with §7.4 explicitly declining the converse).

**What is true.** The slogan is a theorem in one variance and false in the other.

- **Theorem A (simplicial / covariant).** If δ_σ ⊆ δ_{d₀σ} for every σ — only
  d₀, weaker than simpliciality — then δ_σ = ∅ for every σ; with separating
  tests 𝔥 ≡ id, and under the corpus reading that is exactly the cocycle
  condition ρ_jk ρ_ij = ρ_ik. Mechanism: iterating d₀ walks any simplex down to
  a 0-simplex, whose holonomy is cap(ρ_ii)·e = e. The only hypothesis on the
  long-edge cap is cap e ≡ e, true of **both** readings of §0.3, so this half is
  archive-agnostic in the same sense §3 was.
  (`covariant⇒trivial`, `covariant⇒holonomy-trivial`,
  `CocycleExtraction.Corpus.trivial⇒cocycle`.)

- **Theorem B (cosimplicial / contravariant) — the slogan FAILS.** Chart:
  X = ℤ, ρ_ij = translation by 1 for i ≠ j and by 0 for i = j, I = {0,1},
  separating tests. ρ is **not** a cocycle, δ_{(0,1,0)} ≠ ∅, and yet
  δ_{d_jσ} ⊆ δ_σ for **every** σ and **every** j. Reason: with t(σ) the number
  of consecutive-vertex changes and ε(σ) ∈ {0,1} the long-edge indicator,
  𝔥_σ = −ε + t (corpus) or ε + t (archive); the good locus is the **block**
  simplices i…i j…j (corpus) or the **constant** simplices (archive), and both
  are closed under deleting a vertex.
  (`Cosimplicial-sharp-fails-corpus`, `Cosimplicial-sharp-fails-archive`.)

**Why Theorem B matters and what it does not rescue.** Q_α = (𝒫(X),⊆) is
**thin**, so an assignment satisfying all the inequalities *is* a functor — every
diagram in a thin category commutes. So the face half of the note's (O6) is
**satisfiable off the cocycle locus**, and the note's "faces act in neither
variance" is a statement about §3.2's chart, not about all charts. This does
**not** revive the realization repair: §2.2's objection (the copower forces δ_n
to be σ-blind, hence ρ-independent) is untouched by any functoriality result, and
§2.1's variance correction stands. The note's §7.4 classification is now
half-answered — simplicial variance: only cocycles; cosimplicial variance:
non-cocycle solutions exist, full classification still open.

**The archive/corpus discrepancy is preserved, not settled.** Per the mandate I
did not choose. §2's ℤ/2 counterexample keeps its property (both readings
coincide there) unchanged; Theorem A needs only cap e ≡ e, common to both;
Theorem B is proved for both readings **on the same chart**, with different good
loci; and what trivial holonomy yields is now a pair of theorems —
corpus ⇒ cocycle, archive ⇒ ρ_ij² = e **and** ρ_ik ρ_jk ρ_ij = e
(`CocycleExtraction.Archive.trivial⇒involutive`, `…trivial⇒closed`). That last
is the note's "under the archive's form a 1-simplex carries ρ²", now a checked
term rather than a remark. Which reading D0016 §B intends remains the owner's.

**The scalar shadow is now a checked term** (`shadow-support-infinite`, note
Cor. 5.3): one simplex with nonempty defect forces an ℕ-indexed family of
pairwise distinct simplices — its iterated degeneracies, distinguished by vertex
count — all carrying the *same* defect. So ‖𝒪(S)‖ ∈ {0, ∞}: a two-valued
predicate, not a count. That kills a quantity that looked like a measurement,
and it kills it by equality, not by estimate.

**Scope limits.** (i) Theorem B's chart is infinite (X = ℤ); no claim that a
finite chart with the property exists. (ii) Theorem A assumes only
d₀-functoriality plus reflexivity and transitivity of ⊆. (iii) I did not
re-audit note §6's containment table, and nothing in §§B–C of the transmission
was rewritten. (iv) All of it is Agda; exit 0 here, unrun under the pin.
