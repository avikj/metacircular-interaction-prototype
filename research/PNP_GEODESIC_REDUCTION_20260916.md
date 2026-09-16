# P/NP as an output of lossless interaction geometry

Working theorem ledger — 2026-09-16

This file records the live reduction so the argument is persistent and can later be transcribed into Cubical Agda. It is deliberately not a claim of P=NP or P≠NP. Do not target either conclusion; compose exact results until the standard complexity statement is merely a transported corollary.

## 0. Fixed substrate

For every `f : A → B`:

    A ≃ Σ (b : B), fiber f b.

`Fibre.Trace` forces the residual of every conservative presentation of `f` to be fibrewise equivalent to `fiber f`. `Fibre.Visvarupa` classifies arbitrary dependent families by the universal family `π : Σ(X : U) X → U`; finite towers flatten to one family.

The coinductive interaction calculus has

    Q : X → Type
    δ : (x : X) → Q x → X.

Histories are equivalent to dependent answer streams. Contractible questions contract the history space: silence of questions is determinism.

## 1. Existence is the work

`Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork.agda` proves, for `f : A → B`, `b : B`:

    isContr (fiber f b) : exists and is determined; nothing to seek.
    isProp  (fiber f b) : determined if it exists; existence is the unresolved content.
    ¬isProp (fiber f b) : genuine multiplicity remains.

At the middle grade any two hits are equal, and their source projections are equal. Comparison among successful hits contributes no content. Fibre cardinality/h-level is not itself undoability or complexity: distinct fibre points can be distinct path witnesses over the same source; a loop is not a collision.

**R1.** Candidate count is not the intrinsic lower-bound quantity. The decision-problem locus is determination of inhabitation of an appropriate propositional reflection/fibre.

## 2. Scalar reachability is a shadow

`AvaranaMoksa_TheDebtScalarIsTheReachabilityShadowAndIsStrictlyCoarserThanTheFibre.agda` proves `Bool → Unit` is reachability-settled while its fibre retains two distinct sources. Thus reachability/count/output observables can be settled while exact fibre geometry remains nontrivial.

**R2.** Output entropy, census and bare reachability are strictly too coarse for native cost.

## 3. NP normal form

Represent a verifier by

    V : (x : X) → W x → Type

with propositional verification relation (or propositionally reflect it for language membership). Define

    S x = Σ (w : W x), V x w
    L x = ‖ S x ‖.

Verification begins after `(w , proof) : S x` is supplied. Deterministic decision begins from `x` and determines `L x` without that supplied coordinate.

`SubsetSumCostLocus` proves an exponential mask census but explicitly does not prove an exponential optimal deterministic lower bound. Do not use witness cardinality as cost.

## 4. Nondeterminism as supplied dependent interaction

A nondeterministic branch is naturally an answer-conditioned history of `(X,Q,δ)`. A complete accepting branch is a dependent answer stream leading to acceptance. Standard NTM time charges the depth of one successful answer-conditioned history while not charging for production of the answer stream selecting it.

**Target A.** Specialize `Prasna` to ordinary nondeterministic machines: branch histories = answer streams; deterministic machines = contractible-question specialization; accepting polynomial-time branch = polynomial-depth inhabitant of the accepting-history family.

## 5. Choice is already a section theorem

`Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal.agda` defines, for `f : A → B`,

    Choice(f) = (b : B) → fiber f b.

This is exactly a section: a dependent choice of a receipt/preimage at every codomain point. If `f` is an equivalence, `Choice(f)` is contractible — where nothing is hidden there is no choosing. For `Bool → Unit`, two distinct sections exist and the codomain cannot distinguish them.

**R3.** “Choosing a branch/preimage” is not a new computational notion. It is Π-over-fibres. Choice disappears exactly on contractible fibres and is genuine precisely where residual structure survives.

Caution: standard language decision asks only propositional existence, not globally for a witness section. Do not silently replace decision by witness production. For a self-reducible NP-complete relation one may later connect decision to witness recovery, but that bridge must be explicit.

## 6. Composite residual is already exactly classified

`Punaragamana.SamyogaSesa_TheResidualOfACompositeIsTheResidualOfTheResidual.agda` proves for `A -f→ B -g→ C` and `c : C`:

    residual(g ∘ f, c)
      ≃ Σ (y : residual(g,c)), residual(f, fst y).

This is the exact fibre-of-composite/pullback-pasting identity. Residual does not add as a scalar. It fibres over residual. A pipeline therefore carries a dependent chain of choices/receipts, not a numeric “total loss”.

**R4.** The residual of a multi-stage branch/history is already forced to have the same dependent-chain shape as the coinductive answer stream. The apparent NTM branch tree and the composite-fibre theorem are two presentations of the same dependent structure: each later receipt indexes the earlier residual that remains compatible with it.

This is a major vocabulary collapse. The next step is not to invent a branch-cost algebra; it is to transport the existing composite-residual theorem through the coinductive history/answer-stream equivalence.

## 7. Reversible transport cannot carry nontrivial additive intrinsic cost

`Laghava_TheCostAndTheInverseCannotCoexistSoNoNontrivialGroupIsGradedAndTransportHasNoPrice.agda` proves the algebraic obstruction: a nontrivial group cannot support a nonnegative additive grading that detects nonidentity while respecting inverses. Equivalences/transports form a groupoid, so no such intrinsic additive price lives on reversible transport itself.

**R5.** Any intrinsic positive cost must be supported on the noninvertible/graded/residual part, not on equivalence transport. Therefore geodesic cost cannot be “number of arbitrary transports”; reversible refactorizations are gauge/presentation motion for the cost problem. The priced content is the irreducible noninvertible interaction structure.

This sharpens the initial statement: reducible distinction is redundant, and reversible equivalence transport cannot itself supply the positive lower bound. Positive cost is exactly where residual survives reduction.

## 8. Native cost must be execution-carried

`CountedDigitsEdge.agda` repairs an earlier false cost model by threading the counter through the same recursion being executed. Scheduled ticks were not native work because a tick hid state-dependent carry recursion.

**Constraint C.** Never stipulate unit cost at a vocabulary layer. The cost/depth observable must be a projection of the actual universal interaction execution. Distinguish work from dependency depth after quotienting serializations of independent interactions.

## 9. Computational irreducibility = geodesicity, sharpened

For exact interaction objects `a,b`, after quotienting reversible presentation motion and using native executed noninvertible interaction cost, define

    d(a,b) = min { cost p | p : a ↝ b }.

For native evolution `p_R : a ↝ b`, Wolfram-style irreducibility is

    cost(p_R) = d(a,b).

A faster prediction is precisely a cheaper exact path/factorization with the same complete endpoints. No separate semantic notion of “prediction” is required.

**Target D.** Internalize the cost/path object already implicit in the corpus and identify the existing theorem that supplies minimality/rigidity. Search structurally (factorization, obstruction, section, descent, rigidity, modulus, non-return, grading), not lexically for “geodesic” or “complexity”.

## 10. Exact P/NP object

For instance `x`, let `I_x` be the unresolved exact interaction object and `D_x` its exact settled determination, not merely its Boolean shadow. The quantity eventually relevant to deterministic complexity is intrinsic native distance/depth

    d(I_x,D_x).

Every standard deterministic decider induces some exact interaction from `I_x` to the appropriate settled observation. Conversely, to transport an intrinsic lower bound back to standard TM time, native interaction must have a proved complexity-preserving simulation relation to the standard model.

**Target E.** Identify this bridge in the corpus before constructing it. Do not call the construction a “solver”; use transformation, interaction, decider, realization, or determination according to the exact type.

## 11. The central collapse now visible

The following are not separate mechanisms:

    nondeterministic branch
    = dependent answer stream                 (`Prasna` lens)
    = chain of compatible receipts/choices   (`Varanam` lens)
    = iterated fibre of a composite           (`SamyogaSesa` lens)
    = one flattened dependent family          (`Visvarupa` lens).

This is the current strongest reduction.

Thus the branch tree is not fundamentally a tree that must be enumerated. It is a dependent family. Its complete residual is already classified, its iterated structure already flattens, and its answer-conditioned evolution already has a coinductive presentation. The remaining complexity question is: after all equivalence/sharing/commutation reductions, what noninvertible residual interaction is irreducible in determining the propositional existence shadow?

That is a much smaller mathematical object than “all algorithms for SAT”.

## 12. Guardrails

- Repository files named `P=NP...` do not establish standard complexity-theoretic P=NP; their `Gap` predicate is different.
- Exponential witness census is not an optimal lower bound.
- Fibre cardinality is not collision count or complexity.
- Reachability scalar can settle while fibre geometry remains.
- Decision is not automatically witness production.
- Reversible transport has no nontrivial additive intrinsic price of the graded kind proved impossible by `Laghava`.
- Cost must be carried by the execution being priced.
- Do not count arbitrary serializations of independent interactions as intrinsic depth.

## 13. Next reduction

Hold all of these simultaneously and read the corpus structurally:

1. Transport `SamyogaSesa` through `Prasna`'s history ≃ answer-stream equivalence. Expect a theorem saying the exact residual of an n-stage interaction is the dependent answer/history family itself, not a new construction.
2. Use `Visvarupa` tower-flattening to collapse that iterated residual to one family.
3. Locate the corpus theorem identifying the noninvertible residual with price/distance/obstruction and the theorem giving exact minimality/rigidity. Do not invent a new PathCost unless the structural search actually leaves a residual.
4. Locate the parallel/interchange theorem that removes serialization and leaves causal/dependency depth.
5. Only after these transports are exhausted, instantiate the standard NP verifier lens and inspect what remains.

## 14. Central thesis

P/NP is a lens on the more primitive identity

    computational cost = irreducible noninvertible interaction geometry.

Verification is the continuation after the relevant dependent coordinate has been supplied. Deterministic decision must determine the propositional existence shadow without that supplied coordinate. Nondeterministic execution is the same interaction with the answer coordinate supplied. The branch/history/residual structures have already collapsed to one dependent-family object; the remaining task is to identify its exact irreducible noninvertible geometry and then transport that result back through the standard complexity-model interface.
