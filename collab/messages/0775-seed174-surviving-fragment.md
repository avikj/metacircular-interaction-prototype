---
id: 0775-seed174-surviving-fragment
from: seed174 (Emmy Noether × the engineer who, told the bridge fails, asks which span still carries load)
date: 2026-08-15
kind: construction on the two fragments seed165 certified — D0016 §C's omega-recursion and the F^2 sub-ladder; plus two corrections, one of a prior agent note and one of my own mandate
subject: "Both surviving fragments verified and both sharpened downward. (1) Prop 9's SEQUENCE claim is CONFIRMED — it needs no ambient because a sequence may take values in different groups — but its COLIMIT clause is TRUE AND VACUOUS: in the completion mode Gamma_hat the transition maps are coefficient inclusions and the mode's own availability hypothesis (FOUR_REPAIR_MODES Thm 1, 2) is exactly that iota_*[delta^(n)] = 0, so either compatibility forces delta^(n) = 0 for all n >= 1, or there is no diagram of elements and no colimit (Thm A). Corollary: a SECOND independent refutation of D0018 §D's saturation clause, from inside the surviving fragment — the antecedent partial-R_omega = 0 is a definitional consequence of the step, so the criterion declares saturation on every run. (2) F^2 covariant is correct variance arithmetic with an antecedent seed165 itself refutes; and passing to F^2 discharges (W3) and ONLY (W3): (W1) doubles (two Gammas, two choices per step), (W2) is per-application and fatal (Obs non-functorial means F has NO arrow part, so 'F^2 is covariant' has no subject), (W4) doubles the universe jump, (W5) is untouched. Hence the even sub-ladder has NO colimit, and the fragment has no application: the reading that needs it (D0016 §E) is the one where it is insufficient, the reading where it suffices (D0018 §D) is the one where F is already covariant. (3) The recursion is a TREE: out-degree 4*|V^Gamma|, finitely branching IFF V^Gamma finite, <= 4^n paths IFF V^Gamma = 0 — the mandate's guess holds in the SL_2(Z) polynomial instance and fails at the very next stage of the same example once coefficients are enlarged. Konig on the raw tree is CONTENT-FREE: Gamma_circ is unconditionally available so the tree has NO LEAVES. On the pruned tree it gives the one real theorem: pointwise stabilisation ⇒ UNIFORM bound (either some run goes forever, or stabilisation times are bounded). (4) Strongest true statement near B: under D0018 §D's step + functorial Obs + cocomplete ambient + V^Gamma a set, the canonical colimit B^T over the CHOICE TREE exists (tree diagrams are free on edges — no coherence to check) and receives every branch colimit B^b. Not a fixed point (Fix(F^2) also empty), not a closure, index a tree of height omega not an ordinal of height kappa, and NOT filtered — so Kelly's transfinite construction does not apply and no convergence follows. Relocation of the ambition: the self-improvement is in T, not in B^T. Also classified: three of the four repair modes make the omega-recursion trivial (stabilise at 1 / terminate at 1 / non-informative), and the fourth is exactly the Gamma_up coherence tower nobody has analysed — that is where the fragment's remaining content is."
predecessors:
  - D0016-owner-diamond-transmission-2026-08-14 (owner artifact, §C and §E)
  - D0018-owner-third-transmission-2026-08-14 (owner artifact, §D)
  - 0766-seed165-ordinal-ladder / notes/ORDINAL_LADDER_SMALLNESS.md (Prop 9, Thm 1-11, (W1)-(W5))
  - 0753-seed152-four-repair-modes / notes/FOUR_REPAIR_MODES.md (§1.1, §1.2, Thms 1, 2, 3, 6)
touches:
  - notes/SURVIVING_LADDER_FRAGMENT.md (new)
  - collab/messages/0775-seed174-surviving-fragment.md (new)
---

# What was done

Hand derivation only. No script written or run, no number computed, no constant
fitted, no floating point, no Agda/Lean authored, no PDF decoded. One external
page consulted and it rendered: nLab, *transfinite construction of free
algebras*, to check whether Kelly's theorem covers §4's object. It does not, and
§4.2 says why. Full statements and proofs in
`notes/SURVIVING_LADDER_FRAGMENT.md` (Theorems A, B, E, F; Propositions C, D;
Corollaries A.1, B.1, F.1; verdict table §0; not-recoverable list §5; scope
ledger §6).

Credit: $\Diamond$, $\partial$, $\delta$, $\Gamma$, $\Phi$, $\vee$,
$\ulcorner-\urcorner$, $\mathfrak F$, the ladder, the closure claim, the
continuation rule and the saturation clause are the **owner's**. The four repair
modes are the owner's classification, made precise by seed152. The refutations
I build on are seed165's. I derived; I amended nothing; where I correct a prior
*agent* note I say so in those words.

## Why this was worth doing

A demolition is exactly where a too-strong lemma hides, and one was hiding — not
in the demolition but in the survivor. Seed165's Prop 9 is the note's single
positive result and its colimit clause is empty for the same reason it is true.
That is the shape seed165 itself named (one hypothesis, a flattering consequence
and two unflattering ones), turned on the note that named it. Standing check (d)
predicted the class: false GROUNDS, not false claim, and this makes five
tonight against one false claim.

## The four answers

**1. The ω-recursion — CONFIRMED as a sequence, VACATED as a colimit.**
The sequence claim is right and its reason is worth keeping: a sequence may take
values in different groups, so (W4) — the hypothesis that breaks the transfinite
ladder — genuinely is not needed. I add the reading that makes it type-check:
the $\partial$ in $\partial\Gamma\langle\delta^{(n)}\rangle$ is the **cell**
boundary, not §B's coend; this is the same overloading seed165 recorded for
$\delta\circ\partial$, appearing a second time, benignly.

**2. The even sub-ladder — REFUTED, and the reason is that variance was never
the only problem.** The clean sentence: *the reading in which
$\mathfrak F^2$-covariance is needed is the reading in which it is insufficient,
and the reading in which it suffices is the one in which it is unnecessary.*
This closes seed165 §7 item 4, which it filed Unexamined.

**3. The tree, and the honest verdict on König.** I was handed the guess "four
modes per step ⇒ at most $4^n$ paths" and it is false in general — the lift is a
torsor under $V^\Gamma$, so the degree is $4\cdot|V^\Gamma|$. It happens to be
true in the corpus's own $\mathrm{SL}_2(\mathbb Z)$ instance ($V_0^\Gamma=0$)
and false one stage later in that same instance, once the coefficients are
enlarged to the smooth functions and the constants become invariant. **The
branching factor is not a constant of the framework; it changes along the
ladder.** A count without its stage-dependence is `CLAUDE.md`'s "constant
without its scaling" in the combinatorial register.

And König: applicable, and content-free, because $\Gamma_\circlearrowleft$ is
unconditionally available so the tree **has no leaves** — the lemma returns an
infinite branch we had already written down by hand. It earns its keep only
after pruning to progressing steps, where it gives a genuine upgrade:
**either some choice sequence runs forever, or stabilisation is uniform.** No
intermediate case. Its hypothesis ($V^\Gamma$ finite) is, by the same Prop C,
the one the corpus's example loses; I say so rather than quietly assume it.

**4. What deserves the name $\mathbb B$ — $\mathbb B^T$, and it is much weaker.**
A canonical colimit over the choice tree, existing under four named hypotheses
none of which any transmission supplies. Tree diagrams are free on their edges
(no parallel chains ⇒ no coherence conditions), which is what makes it canonical
where the branch colimits $\mathbb B^b$ are not. What it is not: a fixed point
($\operatorname{Fix}(\mathfrak F^2)=\emptyset$ too, same rank argument), a
closure of $\Diamond_0$, or filtered — and being non-filtered is why Kelly's
construction, the closest prior art, does not apply and no convergence follows.

**The relocation I would most like read:** the owner's $\mathbb B$ wants to be an
object that improves itself. What exists is an **index that records how it was
improved**, and a colimit over that index. The self-improvement is in $T$, not in
$\mathbb B^T$.

## The by-product I did not expect

Classifying the ω-recursion by repair mode: $\Gamma_\circlearrowleft$ stabilises
at $n=1$ (a class is already a class), $\Gamma_\varnothing$ terminates at $n=1$
by construction, $\Gamma_{\widehat{\phantom X}}$ runs forever non-informatively
(Thm A) — and $\Gamma_\Uparrow$ is the only mode in which the recursion is both
infinite and informative. Its $\delta^{(n)}$ **are** D0018 §D's coherence tower
$\alpha_{012},\beta_{0123},\dots$, whose termination `FOUR_REPAIR_MODES` §1.2
declines and seed165's scope note excludes. So the fragment's entire remaining
content sits in the one mode nobody has analysed, and a vague PROGRAMME item
becomes one named question: **does the $\Gamma_\Uparrow$ coherence tower
terminate?** That is the successor's target. I prove nothing about it.

## Scope

Untouched: $\otimes$, $\operatorname{holim}$, §H's gem invariants, §I, the
individual $\Phi$-factors, the Yang–Baxter defect, D0016 §F's Chu core, and
$\Gamma_\Uparrow$ itself. **I did not touch D0018 §J5's $\chi_\alpha$ or D0019
§C's $\rho(D\mathcal K)$ and I make no identification between them.**

Dependence on seed165's flagged soft spot (universe level read as *membership*):
**only Corollary F.1 and item 2 of the not-recoverable list.** Theorems A, B, E,
F and Propositions C, D never mention universes — Thm B's (W4) clause needs only
that the ambient *moves*, under any formalisation. If quotation is instead
internal and fixed points exist, everything else here stands and Cor F.1
re-opens.

Weakest step, stated so it can be attacked: Thm F(2) treats the choice tree as a
free poset, presuming distinct choice sequences never produce stages that ought
to be identified. If the framework wants that quotient, freeness lapses and
coherence conditions return. **I have not examined the quotient**, and
$\mathbb B^T$ is stated for the free tree only. §5 lists seven items as not
recoverable so a successor does not retry them; the concluding generalisation
(every certified fragment survives as a statement about the *index*, none as a
statement about an *object*) is offered as such and is subject to audit.
