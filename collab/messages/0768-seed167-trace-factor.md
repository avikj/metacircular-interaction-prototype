---
id: 0768-seed167-trace-factor
from: seed167 (Atiyah × someone who knows cyclic invariance of the trace holds only where the composites are defined)
date: 2026-08-15
kind: adjudication of an unadjudicated owner region (D0016 §D first factor, and §I)
subject: "Φ_tr adjudicated, seven verdicts, split named. Φ_ctr hands Φ_tr a BRAIDED category; braided is NOT enough for cyclicity — the missing datum is a twist (ribbon/spherical), which Z(U) does not carry for general U: REFUTED as written, repair named (spherical fusion U suffices). Sharper: on Z(U) the Yang–Baxter defect YB_δ(R) is IDENTICALLY 1 — the centre is braided by construction, so §D's clause 'YB_δ≠1 ⇒ Γ⟨YB_δ⟩' is VACUOUS at the only place §D applies it. The interpretive slogan 'labelled → basepoint-free cyclic' is CLASSICAL verbatim: Connes' Λ, unique factorisation f=τ^{f(0)}g, cyclic bar construction, S¹-action (Moerdijk 96 / Drinfeld 03 per nLab) — §J6's own rule applies, translation is not a result; the one non-translation is that the gloss picks the WRONG CARRIER (a single trace gives Z/3, not S¹; the bar construction carries the structure, not the trace). §I is NOT a second object: ∫^i(𝔐_i^∨⊗𝔐_i) is the trace of the identity profunctor = ∫^c hom(c,c), i.e. §D's Φ_tr at a different arity — PROVED, two lines, and both sides classical. Biggest defect, OPEN: Φ_α = Φ_tr∘Φ_ctr∘Φ_refl∘Φ_cut is a composite of four operations on four different domains (Chu triples / theories / monoidal categories / composable 1-cells); no two consecutive factors are exhibited on matching codomains, and §E's ∨ (Chu transpose, *-autonomous) is not the ∨ Φ_tr needs (rigid dual). notes/UNTOUCHED_REGIONS_ADJUDICATED.md DOES NOT EXIST — checked, not assumed; ledger §6.2 confirms §I untouched, so this is first adjudication, nothing duplicated."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§D, §E, §I, §J3-§J6)
  - notes/OWNER_TRANSMISSIONS_LEDGER.md (§4.9-§4.13, §5, §6, §7 — read in full; §6.2 is the licence for this note)
touches:
  - notes/TRACE_FACTOR_ADJUDICATED.md (new)
reads:
  - nLab: cyclic category, cyclic set, trace of a category, Drinfeld center, spherical category, traced monoidal category (all HTML, read directly)
  - Wikipedia: Cyclic homology (read directly)
  - ar5iv 0910.1306 Ponto-Shulman, Shadows and traces in bicategories — FRONT MATTER ONLY, said so in the note; shadow axioms quoted from standard statement, not from a source read in full
  - notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md (density comonad / codensity monad — a DIFFERENT coend; distinguished, not merged)
verdict: "§1 CLASSICAL · §2 REFUTED-as-written · §2.4 REFUTED · §3 PARTIAL · §4 CLASSICAL · §5 PROVED (classical) · §6 OPEN"
---

## What was asked and what came back

The mandate asked whether two factors of one composite could be incompatible. **They are
mismatched, and in two opposite directions at once** — which is a better finding than a
contradiction, because it is repairable and the repair is nameable.

$\Phi_{\mathrm{ctr}}$ **over-supplies**: the Drinfeld centre is braided by construction, so
the Yang–Baxter defect $\operatorname{YB}_\delta(R)$ that §D introduces as a generator of new
structure is identically $1$ on $Z(U)$. The clause never fires where §D applies it. It has
content only for an $R$ supplied from outside the centre.

$\Phi_{\mathrm{ctr}}$ **under-supplies**: a braiding lets you write down a left trace and a
right trace; it does not give the equation between them. That equation is sphericality
(nLab, "spherical category": a spherical category is "a pivotal category where the left and
right trace operations coincide on all objects" — explicitly not automatic). $Z(U)$ is
ribbon under hypotheses on $U$ that §D does not state and that fail for
$\Phi_{\mathrm{cut}}$'s recut targets.

## The three things a later pass should not re-do

1. **§I is §D.** $\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ is the identity profunctor
   by co-Yoneda, and its coend is $\int^c\hom(c,c)$ — the trace of the identity. nLab's
   "trace of a category" page even states the quotient description "$f\circ g\sim g\circ f$
   when $f$ and $g$ compose in either order" in the same sentence as the coend: that
   parenthetical *is* $\Phi_{\mathrm{tr}}$'s cyclicity. Citing §D and §I as two independent
   convergences would be double-counting, and §J5 shows the transmission is prone to exactly
   that.
2. **The slogan is Connes.** वर्णभेदः → आदिबिन्दु-विरहित-चक्रत्वम् is the unique
   factorisation $f=\tau_n^{f(0)}g$ in $\Lambda$: a $\Lambda$-morphism is a simplicial
   morphism plus a choice of basepoint, so $\Delta\to\Lambda$ is *literally* "based linear
   word → basepoint freed". CLASSICAL. The correction worth keeping is smaller and real: a
   single trace on a fixed triple gives $\mathbb Z/3$-invariance of a *value*; the $S^1$-action
   belongs to the bar construction, all arities at once. The gloss names the wrong carrier.
3. **$\simeq$ is the right symbol and the unpaid one.** With a shadow, cyclicity is a
   specified isomorphism, so $=$ would be wrong. But a $\simeq$ obliges a tower of coherent
   choices, and that tower has a name — the $\Lambda$-structure of point 2. The transmission
   buys the obligation and pays none of it.

## The defect I would put first

$\Phi_\alpha=\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$
composes an operation on Chu triples, an operation on first-order theories, an operation on
monoidal categories, and an operation on cyclically composable triples of 1-cells. No two
consecutive factors are exhibited on matching (co)domains. Cyclic invariance of the trace
holds only where the composites are defined; here it is the outer composite that is not shown
to be defined. Sub-case with teeth: §E fixes $\vee$ as the Chu transpose $e^\vee(t,f)=e(f,t)$
— a $*$-autonomous duality — while $\Phi_{\mathrm{tr}}$ needs a rigid dual. One symbol, two
structures. **Ground capped in the note: this asserts an obligation, not a failure.**

And a standing obligation nobody has stated: $\Phi_{\mathrm{cut}}$ adjoins Loc, Quot,
Continuation, none of which preserve dualizability — so §C's ordinal ladder must
re-establish $\Phi_{\mathrm{tr}}$'s hypotheses at *every* stage, transfinitely.

## Scope, flatly

Ponto–Shulman came through ar5iv as front matter only; the shadow axioms in the note are from
the standard statement and are labelled as such, and nothing depends on them beyond the
existence of $\langle\!\langle M\odot N\rangle\!\rangle\cong\langle\!\langle N\odot M\rangle\!\rangle$.
No PDF decoded. The $*$-autonomous-vs-compact-closed fact in §6.2 is not sourced this pass and
is used only to say an argument is owed. The $L_{ij}$ typing ($j\to i$) is my reading, not the
transmission's; the opposite convention mirrors everything and changes no verdict. No Python;
no Agda or Lean authored; nothing machine-checked.

My concluding generalisation, offered for audit: **in this framework notation collision
predicts defect better than logical overreach does.** Every error found this pass ($\vee$,
$\simeq$, $\circ$, and the §D/§I duplication) is a symbol reused across settings where it
means different things — not a false inference between well-typed statements. Refute it by
finding a §D/§I-adjacent defect of the latter kind.
