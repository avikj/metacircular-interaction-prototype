---
id: 0752-seed151-generability
from: seed151 (Kan × a categorist who reaches for the density comonad first)
date: 2026-08-14
kind: proof note — identification, finite exhaustive separation, prior-art verdict
subject: "D0018 §C's δ_◁/δ_▷ ARE the density comonad counit and the codensity monad unit (Theorem 1), the transmission's boxed claim generability ≢ reconstructibility is TRUE and CLASSICAL, and the separation now has explicit witnesses: all four combinations of (δ_◁≡0?, δ_▷≡0?) are realised by four subsets of the three-element chain {0<1<2} — a twelve-case finite exhaustive verification, hence proof by CLAUDE.md. Second witness pair in Ab: ℤ generates and does not cogenerate, ℚ/ℤ cogenerates and does not generate. The forcing hypothesis is self-duality of the PAIR (C,G), not of C: the chain is self-dual and the separation survives because {0,1} is not. Prior art: Isbell 1960 (as 'left adequate'), Ulmer, Kock/Appelgate–Tierney, Kennison–Gildenhuys 1971 (FinSet↪Set gives the ultrafilter monad); read directly: nLab 'codensity monad', nLab 'dense functor', Leinster TAC 2013 abstract+history in HTML. NO PDF was opened. Novelty in the transmission's framing: bookkeeping only (the two-leg 𝔐_i packages both comma slices; the fib/cofib phrasing adds content only in the abelian reading, where it becomes generator/cogenerator — also classical). Corpus link: NO — 'codensity' appears only in D0018; two tangential Kan-extension mentions checked and dismissed."
predecessors:
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§C, triage §J2)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - collab/upstream/raw/D0017-owner-hieroglyphics-transmission-2026-08-14.md
touches:
  - notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md (new)
verdict: separated (with witnesses) AND classical (with sources)
---

## What was done

1. **Identification (Theorem 1).** With G : J → C, the transmission's "J_X" is two comma
   categories, not one: G/X for the colimit side, X/G for the limit side. That is forced by
   the domain/codomain of the two canonical maps, and it is exactly what the two-leg datum
   𝔐_i = (Map(−,i), Map(i,−), ⟨−,−⟩_i) of §D supplies. Then
   δ_◁(X) = cofib(counit of Lan_G G) and δ_▷(X) = fib(unit of Ran_G G): the **density
   comonad** and the **codensity monad**. The presheaf-level reading (nerve–realization
   adjunction) gives the same maps. The pairing ⟨−,−⟩_i is left uninterpreted and I say so.

2. **The "= 0" fork, stated rather than chosen.** In a stable setting fib = 0 ⟺ cofib = 0 ⟺
   equivalence, so δ_◁ ≡ 0 ⟺ dense and δ_▷ ≡ 0 ⟺ codense. In an abelian setting fib = ker,
   cofib = coker, so δ_◁ = 0 ⟺ ε epi (**generating** family) and δ_▷ = 0 ⟺ η mono
   (**cogenerating** family). The abelian reading matches the transmission's *words* better
   than its symbols do. Both are worked; they are not equivalent and I claim no implication.

3. **Separation, by finite exhaustive verification.** P = {0<1<2}; for S ⊆ P,
   Lan(x) = sup(S∩↓x), Ran(x) = inf(S∩↑x), sup∅ = 0, inf∅ = 2. Twelve checks give:
   S=P both zero; S={1,2} dense not codense; S={0,1} codense not dense; S={1} neither.
   So generability ≢ reconstructibility, and they do not jointly exhaust the failure modes.
   Second, non-finite witness pair in Ab (Theorem 2′): ℤ vs ℚ/ℤ, using torsion-freeness of ℤ
   and injectivity of ℚ/ℤ (Baer).

4. **The forcing hypothesis (Theorem 3).** A duality D : C^op ≃ C under which the *family* is
   self-dual exchanges δ_◁ and δ_▷ and forces dense ⟺ codense. Sharpness: P itself is
   self-dual (x ↦ 2−x) and the separation still holds, because {0,1} is not self-dual — its
   image is {1,2}, which is precisely the other witness. Self-duality of the ambient category
   alone is insufficient.

5. **Prior art searched BEFORE the write-up**, per CLAUDE.md. The claim is classical.

## Standing checks

- (a) I stayed inside §C and did not treat hints elsewhere as scope.
- (b) No prior edit was claimed on trust: I read D0018 and verified the line numbers I cite
  (§C at 83, §D at 106, 𝔐_i at 109) by grep, and I read the two corpus files I dismiss.
- (c) The §2.1 summary table was checked against its own twelve-case proof body, row by row.
- (d) Grounds are stated at the generality I can defend: the reading in §1.1 is grounded in
  forced variance bookkeeping plus §D line 109 and nothing stronger; the Isbell/Ulmer/Kock/
  Appelgate–Tierney/Kennison–Gildenhuys attributions are explicitly labelled **second-hand**
  from Leinster's HTML, since I did not open those papers.
- (e) My concluding generalisation is exactly: *density and codensity are logically
  independent conditions on a functor, with all four combinations realisable in a
  three-object poset, and no hypothesis on C alone forces either from the other.* Audit it.
- (f) Scope limits: J small and Kan extensions pointwise throughout; enrichment matters and
  is unresolved ({k} ⊂ Vect_k is Vect-enriched-dense but not Set-dense). Nothing here is
  numerical, so no number of mine is comparable to any other pass's; there was no prior pass
  on this material in the corpus.

## Not proved, and not upgraded

§D's ordinal defect ladder / 𝔯_ω / saturation; 𝔉_♦; 𝔅_∞ = ∫^α; the MDL functional §A. All
remain as D0018 §J7 left them. χ_α (§J5 hazard) was not measured, defined, or used. Per §J8
no existing corpus result was relabelled in this vocabulary.

## Verdict

**Separated, with witnesses — and classical.** The owner's boxed claim in D0018 §C is true.
It is not new mathematics; it is a correct reading of the standard definitions of the density
comonad and the codensity monad. Credit for raising it as this corpus's first D0018 `PROVE`
item: the repository owner, D0018 §C, triage §J2.
