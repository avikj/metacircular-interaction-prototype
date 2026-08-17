---
id: 0764-seed163-centre-yb
from: seed163 (Drinfeld × a referee who checks the hexagons before believing the braiding — and here could not get as far as the hexagons)
date: 2026-08-15
kind: adjudication of an owner transmission (D0016 §D, the Φ_ctr bullet), with one classical identification, two refutations by counterexample/one-line proof, one ambiguity found in the repair clause, and one correction to a prior ledger entry
subject: "Φ_ctr's Z(U) IS the Drinfeld centre in intent — but the displayed end ∫_{x∈U} HalfBraid_U(x) DOES NOT EXIST: HalfBraid_U(−) is not a functor of x (a morphism f: x→x' transports half-braidings in NEITHER direction unless f is invertible, so at best a functor on core(U)), and the charitable Grothendieck-construction reading fails for the same reason. The end that does exist binds the OTHER variable: HalfBraid_U(x) = ∫_{y∈U} Iso(x⊗y, y⊗x), and its wedge condition IS naturality in y — so moving the integral one variable inward supplies for free the axiom the transmission omits. NATURALITY IS OMITTED AND NOT IMPLIED, refuted by counterexample: in the full monoidal subcategory of Vect_k on V^{⊗n} with x the unit and γ_{V^{⊗n}} = A^{⊗n}, the transmission's ⊗-axiom holds for EVERY invertible A, while naturality forces A central hence scalar; take A upper-unitriangular. Without naturality b = Ψ_X is not a braiding at all, so the hexagons are not yet statable — a referee cannot begin. ORDER AND VARIANCE ARE CORRECT: γ_{y⊗z} = (1_y⊗γ_z)(γ_y⊗1_z) agrees verbatim with nLab's Φ_{Y⊗Z} = (id_Y⊗Φ_Z)∘(Φ_Y⊗id_Z), and it is the only order that types. YB_δ(R) is UNDEFINED without the omitted hypothesis R ∈ Aut(V⊗V); under it, YB_δ = 1 iff the braid relation, and the ⇔ is real but is carried by CANCELLATION IN A GROUP, not by definition alone; for non-invertible R (idempotent/set-theoretic solutions are routine) the clause is vacuous and the honest defect is a parallel pair. LEDGER §1.10 CORRECTED, not overturned: 'carries no content beyond notation' is wrong in one respect — YB_δ is NOT well defined as an element, only up to conjugacy (gauge R ↦ (g⊗g)R(g⊗g)^{-1} conjugates it by g^{⊗3}), so only its class, hence only its vanishing, is invariant; that is exactly FOUR_REPAIR_MODES Thm 6(i)'s Γ_↺ situation. Obstruction is COMPLETE: three strands suffice for B_n at all n. Γ⟨YB_δ(R)⟩ IS AMBIGUOUS BETWEEN TWO OF THE FOUR MODES — §C's own typing Γ_α: O_α → Cell makes it Γ_⇑ (the one mode FOUR_REPAIR_MODES §1.2 declines to certify), while ⟨−⟩ read as 'normal subgroup generated' makes it Γ_∅-by-quotient (Thm 6(ii) verbatim); the clause does not determine which repair is proposed. Γ_completion REFUTED for this defect in one line: enlargement of a group along an injective hom cannot kill a nonidentity element — the structural reason being that YB_δ has no H¹ beneath it, unlike FOUR_REPAIR_MODES Thm 2's coefficient enlargement. So this is a structural defect with the good mode provably unavailable."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§D Φ_ctr, §C the Γ typing)
touches:
  - notes/CENTRE_AND_YANG_BAXTER_DEFECT.md (new)
reads:
  - notes/FOUR_REPAIR_MODES.md (in full)
  - notes/OWNER_TRANSMISSIONS_LEDGER.md (§1.9–§1.12, §1.10 in full)
  - CLAUDE.md (in full)
  - nLab: Drinfeld center / center of a monoidal category, Yang-Baxter equation, braided monoidal 2-category (HTML, decoded); Wikipedia: Braided monoidal category (HTML, decoded). nLab half-braiding = 404, not read. NO PDF decoded and none claimed. Majid, Joyal–Street's own paper, Kapranov–Voevodsky: NOT read, named as lineage only.
verdict: identification CLASSICAL / end REFUTED as written and relocated; axiom order PROVED correct, naturality omission REFUTED as implied; YB_δ PROVED an obstruction under the omitted invertibility hypothesis but REFUTED as a well-defined element; repair clause PARTIAL — ambiguous between Γ_⇑ and Γ_∅, with Γ_completion refuted
---

# Verdicts, one line each

1. **Z(U) = Drinfeld centre?** **PARTIAL, split named.** *Intended object:* **CLASSICAL** —
   the pairs (object, half-braiding, ⊗-compatible) are verbatim nLab's Z(𝒞), and the displayed
   γ_{y⊗z} equation is verbatim its axiom. *Displayed end:* **REFUTED** — no functoriality in
   x, so neither an end, a coend, nor a category of elements (Thm 1, Prop 1.2). *Correct form:*
   Z(U) = ∐_{x∈U} ∫_{y∈U} Iso(x⊗y, y⊗x) on objects, morphisms imposed separately (Thm 2).
   It is neither "the centre of a single object" nor an end — it is a disjoint union of fibres,
   each fibre being an end over the *other* variable.

2. **Axiom correct?** **PARTIAL, split named.** Order and variance **PROVED correct** (§2.1) —
   γ_y⊗1_z must act first and does. Naturality in y **not stated**, and **REFUTED as implied**
   by counterexample (Thm 3). Consequence: the braiding b = Ψ_X is not yet a natural family, so
   the hexagon axioms are not yet statable about it.

3. **YB_δ a genuine obstruction?** **PROVED with hypothesis** (I): R ∈ Aut(V⊗V), which the
   transmission omits. Then YB_δ ∈ Aut(V^{⊗3}), a group, "≠1" is meaningful, and YB_δ = 1 ⇔
   braid relation (Thm 4, by cancellation — the hypothesis is doing the work, not the
   definition). **REFUTED as a well-defined element** (Thm 5): gauge-conjugacy only.
   **PROVED complete** (Thm 6): no new obstruction at n ≥ 4.

4. **Γ⟨YB_δ⟩ a repair?** **PARTIAL, split named.** Γ_↺ available and mandatory (Thm 5).
   Γ_∅ available, and is the literature's move (restrict to R-matrices). Γ_completion
   **REFUTED** (Thm 7). Γ_⇑ available in principle, **unpriced** — its first coherence rung is
   the located Kapranov–Voevodsky lineage, which I did not read. And the clause as written does
   not say which of Γ_⇑ and Γ_∅ it means.

5. **Prior art.** Named and read in §1.1, §3.4, §4.2 of the note; the false-ground guard is
   exercised twice — Wikipedia gives the hexagons only as diagrams (so I quote none and use
   none), and nLab's Yang–Baxter page explicitly does *not* impose invertibility (so hypothesis
   (I) is mine, not attributed to it).

# The two things worth carrying out of this

**(a) One edit fixes two defects.** Binding the end over y instead of x both makes the formula
well-formed and *supplies* the missing naturality as the wedge condition. That is why the
correction is worth preferring to appending the word "natural": the transmission's own notation,
used correctly, already contains the axiom it forgot.

**(b) A structural defect with the good mode removed.** FOUR_REPAIR_MODES Thm 2 shows completion
works because ι_*: H¹(Γ,V₀) → H¹(Γ,V) need not be injective. YB_δ is an element of a group, not
a class in a cohomology group, and enlargement along an injective hom is injective on elements.
So Γ_completion — the mode that note argues is "the good way to perform" Γ_∅ — is provably
unavailable here, and the transmission's clause offers, ambiguously, one of the two remaining.
This generalisation rests on one defect plus a one-line proof and is flagged for audit in §6.

# Scope limits

Monoidal category, single invertible R on V^{⊗2}. Nothing here touches Φ_tr, Φ_refl, Φ_cut, or
the composite Φ_α = Φ_tr ∘ Φ_ctr ∘ Φ_refl ∘ Φ_cut, and nothing here says whether Φ_ctr belongs
in that composite. Thm 3's counterexample takes x to be the unit; Thm 5(2)'s left/right
non-equality is argued, not exhibited, and is flagged at that lower strength in the note's §6.
Nothing computed, no Python, no Agda or Lean authored, nothing claimed typechecked.
