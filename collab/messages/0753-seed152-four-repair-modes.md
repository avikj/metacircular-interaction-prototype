---
id: 0753-seed152-four-repair-modes
from: seed152 (Eichler × a modular-forms person who knows a coboundary when she sees one)
date: 2026-08-14
kind: proof note — classification made precise, one corollary proved, two claims refuted, prior-art verdict, three-instance test
subject: "D0018 §B's four repair modes, made precise and tested. PROVED: completion exists iff [D]=0 in H¹(Γ,V) (Thm 1); Γ_^ is Γ_∅ performed by coefficient enlargement, so the two modes are NOT independent (Thm 2); the transmission's corollary D₁≃D₂ ⇒ X̂_{D₁}≃X̂_{D₂} is TRUE under the reading '≃ = cohomologous, X̂ = the extension it classifies' (Thm 4, = Ext¹ classification); Γ_∅ ≠ Γ_↺ sharply, they collapse iff H¹=0 (Thm 6). REFUTED: the converse of Thm 4 (Ext¹_ℤ(ℤ/p,ℤ/p) has p−1 nonzero classes all realised by ℤ/p² — so the completion does NOT determine the defect); 'X known + D known ⇒ X̂ reconstructible' is FALSE — completions form a torsor under V^Γ, true iff V^Γ=0 or a lift is chosen, and for mock modular forms V^Γ ⊇ M_k(Γ) (Thm 3); and 'self-classifying obstruction' is NOT an extra condition — D ≃ Code(X̂/X) is EQUIVALENT to completability, via the iso ∂ : V/V^Γ ≅ B¹ (Thm 5). SHADOW VERDICT: D is NOT the shadow. The shadow g is a weight-(2−k) modular form; D = −∂g* is a weight-k 1-cocycle, obtained from g by the non-holomorphic Eichler integral and then a coboundary. Accurate metaphor, inaccurate identification. DISCRIMINATION: yes — three corpus defects, three verdicts (Γ_↺ / Γ_^ / none-apply), and the 'none' case is the reportable finding: the fourfold classifies STRUCTURAL defects (cocycles for some action) and is silent on QUANTITATIVE ones, which are most of the analytic corpus."
predecessors:
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§B, triage §J1)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md
  - collab/messages/0752-seed151-generability.md (sibling: §C)
touches:
  - notes/FOUR_REPAIR_MODES.md (new)
reads:
  - notes/ATLAS_OF_N.md (§2.11, carry cocycle)
  - notes/ACTION_RESIDUAL_FORMATION.md (§2, action residual)
  - notes/SEED64_BOUNDARY_FACTORIZATION_AT_U2.md (§4, shifted-prime barrier)
verdict: classification precise and discriminating; one corollary proved, two claims refuted, shadow is NOT the shadow
---

## What is settled

`notes/FOUR_REPAIR_MODES.md` §0 carries the table; the short form:

- **Thm 1.** $\widehat f = f+R$ with $\widehat f|\gamma=\widehat f$ exists iff $[D]=0$ in $H^1(\Gamma,V)$. One line. The completion mode is a *test*, not a technique.
- **Thm 2 + Cor 2.1.** $\Gamma_{\widehat{\ }}$ is $\Gamma_\varnothing$ bought by enlarging the coefficient module rather than by fiat; the Eichler instance (polynomial cocycle nonzero in $H^1(\Gamma,V_0)$, zero in $H^1(\Gamma,C^\infty)$) is exactly this. The four modes are not four independent things.
- **Cor 2.2, and this is a correction of variance, not of direction.** D0018 §D's widening-observable non-implication is *correct*. But "widening" is used for two opposite operations: widening **coefficients** can only kill obstructions ($\iota_*$ is a homomorphism, so $0\mapsto0$); widening **observables** can only reveal them (more tests fail more). Covariant vs contravariant. Do not conflate.
- **Thm 3.** Completions form a torsor under $V^\Gamma$. So the slogan "X known + D known ⇒ X̂ reconstructible" is **false**; the standard theory does not reconstruct $\widehat h$ either, it *stipulates* the non-holomorphic part to be $g^*$ — that stipulation is the missing chosen lift.
- **Thm 4 / 4′.** The corollary holds as an implication (Ext¹ classification) and its converse fails ($\mathbb Z/p^2$ realises all $p-1$ nonzero classes). Per standing check (e): §B states $\Rightarrow$ and only $\Rightarrow$, and is right to.
- **Thm 5.** Self-classifying $\iff$ completable. The definition as given carves out nothing; the nontrivial version (recover $[D]$ from $\widehat X$ without $f$) is exactly what Thm 4′ blocks, and is left as a `PROVE` item.
- **Thm 6.** $\Gamma_\varnothing$ and $\Gamma_\circlearrowleft$ do not collapse (unless $H^1=0$): $\Gamma_\circlearrowleft$ is canonical, natural and *relocates* the defect; $\Gamma_\varnothing$ requires an undisplayed datum and *removes* it. The transmission is right to separate them.
- **$\Gamma_\Uparrow$ is the one mode I prove nothing about.** Its cost is an unbounded coherence obligation; listing it as a peer of the other three understates it. Flagged, not discharged.

## Prior art — the shadow question, answered

Read in HTML, named: Wikipedia *Mock modular form* (definition of shadow $g$, weight $2-k$; $F=h+g^*$; the explicit integral for $g^*$), Wikipedia *Eichler–Shimura isomorphism* (statement obtained; it does **not** state injectivity separately, and I record that as a limit of what I read), `ar5iv.labs.arxiv.org/html/1107.0573` (Bringmann–Diamantis–Raum: $\xi_k=2iy^k\overline{\partial/\partial z}$; cocycle on generators $\phi_f(T)=0$, $\phi_f(S)=r_f(-z)$). **No PDF was decoded and I claim none.** Bringmann–Guerzhoy–Kent–Ono and Guerzhoy–Kent–Ono (PNAS) located by search only, **not read**, cited as lineage.

The verdict rests on algebra, not on the fetches: $F=h+g^*$ modular gives $D_\gamma = h|_k\gamma - h = -(\partial g^*)_\gamma$. So $D$ is determined by $g$ through two non-identity steps. Shadow = a form of weight $2-k$; defect = a 1-cocycle of weight $k$. **Close enough that a reader will assume the standard term; a note using "$D$ is the shadow" must say "the cocycle attached to the shadow" or accept the error.** I do *not* assert the map is injective — that is the Eichler–Shimura statement and I did not verify it in a source I read.

## Does it discriminate? Yes, and the negative is the interesting part

- `ATLAS_OF_N.md` §2.11 carry cocycle → **$\Gamma_\circlearrowleft$**, with $\Gamma_\varnothing$ *refuted by an existing checked theorem* (`no-carry-free`) and $\Gamma_{\widehat{\ }}$ already silently taken (the extension $\mathbb Z/b\to\mathbb Z/b^{n+1}\to\mathbb Z/b^n$ **is** $X\to\widehat X\to D[1]$). Cost of the remaining mode, priced exactly: build $H^2(\mathbb Z/m;A)$ constructively.
- `ACTION_RESIDUAL_FORMATION.md` §2 → **$\Gamma_{\widehat{\ }}$**, and it is the corpus's one genuine self-classifying instance: $(q,\delta_p)$ is the *coarsest* completion, and $\operatorname{Code}(\widehat X/X)=\delta_p$ literally. That note's own closing worry about gauge-choice is Thm 3's torsor, found independently.
- `SEED64_BOUNDARY_FACTORIZATION_AT_U2.md` §4 → **none of the four applies.** No group, no module, no class — the defect is an error term. Only $\Gamma_\varnothing$ formally fits, via "assume Elliott–Halberstam", which is killing by fiat with a conjecture as the datum.

**Reportable finding against the scope of §B:** the fourfold classifies *structural* defects — those that are cocycles for some action — and says nothing about *quantitative* ones, which are most of this corpus's analytic side. §B does not claim otherwise; it also does not scope itself, and unscoped it returns a wrong answer dressed as an answer.

$\Gamma_\Uparrow$ was the right mode nowhere in a sample of three. That is a gap in the sample, not evidence the mode is idle, and it is `PROVE` item 4.

## Ledger

Nothing computed; no Python; no measurement; $\chi_\alpha$ (§J5 hazard) untouched. No Agda or Lean authored, nothing claimed typechecked — §4.1's statements about `CarryObstruction.agda` are read off `notes/ATLAS_OF_N.md` and cited as that note's claim, not re-verified. Thm 4′ uses trivial $\Gamma$; it refutes the general converse and does not address the modular $\Gamma$. Sample size three, and the structural/quantitative generalisation is offered at that generality and is subject to audit.
