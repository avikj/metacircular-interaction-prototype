# P/NP as an output of lossless interaction geometry

Working theorem ledger — 2026-09-16

This file records the live reduction so the argument is persistent and can later be transcribed into Cubical Agda. It is deliberately not a claim of P=NP or P≠NP. The rule is: do not target either conclusion; keep composing exact results until the standard complexity statement becomes a corollary of the intrinsic interaction geometry.

## 0. Fixed substrate already established in the repository

For every visible map `f : A → B`, the canonical lossless presentation is

    A ≃ Σ (b : B), fiber f b.

`Fibre.Trace` proves more than existence of this presentation: any conservative presentation of the same visible map has residual family fibrewise equivalent to `fiber f`. The residual is therefore forced by the visible interaction, not chosen by an implementation.

`Fibre.Visvarupa` identifies arbitrary dependent families as pullbacks of the universal family

    π : Σ (X : U), X → U

and finite towers flatten to one dependent family. Iterated dependence does not require an expanding ontology.

The coinductive interaction calculus (`Prasna` / `Prashna` / `Niyati`) has the primitive shape

    Q : X → Type
    δ : (x : X) → Q x → X.

A state asks a dependent question, an answer is supplied, and the interaction continues. Histories are equivalent to answer streams. When every question is contractible, the answer/history space contracts: silence of questions is determinism.

The Bend2/HVM4-full lane keeps cubical objects, paths, types, transport, composition, partial knowledge and superposition alive at runtime. Cost claims must ultimately be tied to executed interaction, not to an externally stipulated schedule.

## 1. The algorithmic locus is the propositional-but-not-known-inhabited fibre

Repository source: `Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork.agda`.

For `f : A → B`, `b : B`, there are three relevant grades:

    isContr (fiber f b)   : exists and is determined; no search.
    isProp  (fiber f b)   : unique if it exists; existence is the work.
    ¬isProp (fiber f b)   : genuine multiplicity remains.

Checked theorem: under `isProp (fiber f b)`, any two hits are equal (`प्रथम-एव-पर्याप्तम्`), hence their source projections are equal (`लब्धि-निर्धारिता`). Search owes no comparison among successful hits. The only unresolved content is inhabitation.

Important correction also proved there: fibre cardinality/h-level does not by itself measure undoability or computational difficulty. Multiple fibre points may differ only by path witness while sharing one source. A loop is not a collision.

**Reduction 1.** For decision problems, candidate count is not the intrinsic lower-bound quantity. The clean algorithmic locus is production/determination of inhabitation of an appropriate propositional fibre.

## 2. Reachability/existence shadows are strictly coarser than full fibre geometry

Repository source: `AvaranaMoksa_TheDebtScalarIsTheReachabilityShadowAndIsStrictlyCoarserThanTheFibre.agda`.

The map `Bool → Unit` is surjective while its fibre over `tt` is not a proposition. Thus a scalar/set-level reachability observable can say “settled” while exact residual distinction remains.

**Reduction 2.** Neither output entropy, number of missed outputs, nor bare reachability is the native information/cost invariant. Full dependent fibre structure is strictly finer.

## 3. Normal form for an NP verifier

Let an NP relation be represented by a verifier

    V : (x : X) → W x → Type

with `V x w` propositional (or replace it by its propositional reflection when discussing language membership). Define the successful-witness type

    S x = Σ (w : W x), V x w.

The language observation is only the propositional existence shadow

    L x = ‖ S x ‖.

Verification is interaction after a point `(w , proof) : S x` has already been supplied. Deterministic decision begins with `x` and must determine `L x` without being handed that point.

Do NOT infer complexity from `|W x|` or `|S x|`; `SubsetSumCostLocus` correctly proves an exponential mask census but explicitly does not thereby prove an exponential optimal decider lower bound.

## 4. Nondeterminism is supplied dependent interaction, not free physical parallelism

Under the coinductive interaction calculus, a nondeterministic choice at state `x` is naturally a noncontractible question type `Q x`. A branch is an answer-conditioned history. A complete accepting branch is a dependent answer stream whose supplied coordinates lead to acceptance.

The standard NTM time convention charges the depth of one accepting answer-conditioned history but does not charge for producing the answer stream that selects it.

**Theorem target A (formalization target, expected direct specialization of `Prasna`).** Encode an NTM as an interaction `(X,Q,δ)` so that:

1. branch histories are `IExec` histories / answer streams;
2. deterministic machines are the contractible-question specialization;
3. an accepting NTM computation is an inhabitant of the dependent type of accepting answer streams of polynomial depth.

This makes precise the informal statement “NTM is cheating”: the branch coordinate is supplied as interaction input.

## 5. The find/check distinction

Given `x`, verification consumes an inhabitant of `S x`. Finding/deciding must produce enough structure to settle whether `S x` is inhabited.

At the `isProp` grade, uniqueness contributes no search work. Therefore the find/check distinction is not “choosing the best among many answers”; it is the distinction between:

    supplied inhabitant  vs.  production/determination of inhabitation.

**Theorem target B.** Express verifier execution as continuation after supplying the relevant fibre point, and express deterministic solution as the interaction that constructs/settles that missing dependent coordinate. Prove the two differ exactly by the production of that coordinate/residual, not by the subsequent verifier continuation.

## 6. Native cost must be carried by the execution being priced

Repository source: `CountedDigitsEdge.agda`.

That module closes an earlier cost bug: scheduled ticks were not native work because a tick hid state-dependent recursive carry propagation. The repair threads the counter through the SAME recursion and proves exact identities for native work.

**Constraint C.** Any P/NP lower-bound statement here must use a cost/depth projection carried by the universal interaction execution itself. No stipulated “one high-level step = one unit” model may hide work.

For parallel interaction, distinguish at least:

    work  = irreducible interactions performed;
    depth = longest irreducible dependency chain after quotienting serializations of independent interactions.

The standard deterministic time comparison should ultimately attach to the appropriate native depth/work observable with a proved simulation relation, not an assumed one.

## 7. Computational irreducibility = geodesicity

Fix the universal primitive interaction calculus and its native cost semantics. For exact interaction objects `a,b`, define intrinsic distance by minimum native factorization cost:

    d(a,b) = min { cost p | p : a ↝ b }.

For a rule-generated execution `p_R : a ↝ b`, exact Wolfram-style computational irreducibility is

    cost(p_R) = d(a,b).

A “faster predictor” is nothing additional: it is precisely a cheaper path/factorization with the same exact endpoints. Thus irreducibility means the rule itself realizes a geodesic.

This replaces the presentation-level phrase “prove every possible program slower” with the intrinsic theorem “prove this exact interaction distance.” Programs/algorithms are presentations/factorizations of paths in the universal interaction object; optimization is reduction of redundant factorization.

**Theorem target D.** Internalize `PathCost`, composition, identity, parallel/interchange quotient, and `Geodesic p := ∀ q same-endpoints, cost p ≤ cost q` for the native calculus. Prove invariance under the already-established lossless/univalent presentation equivalences.

## 8. The exact P/NP object after reduction

For instance `x`, let `I_x` denote the exact unresolved interaction object containing the dependent witness/existence question, and `D_x` its exact settled determination (not merely the Boolean output bit).

The quantity of interest is

    d(I_x, D_x).

Not:

- output Shannon information;
- witness-space cardinality;
- number of syntactic programs;
- one chosen algorithm's running time;
- a sequential schedule that serializes independent interactions.

**Theorem target E.** Construct `I_x` and `D_x` canonically from `V`, the fibre law, and the coinductive interaction calculus. Show that every deterministic exact solver induces a path `I_x ↝ D_x`, and conversely that native paths compile/simulate into the standard deterministic model with the required complexity-preserving overhead. This is the bridge needed before an intrinsic distance theorem implies a standard TM lower bound.

## 9. Complexity conclusion must be an output

Do not target either equality or separation.

Once target E is established, study the exact native geometry for an NP-complete family. There are only mathematical possibilities:

1. Exact lossless sharing/factorization produces polynomial geodesics. Then identify the reduction responsible; do not call it P=NP until the standard simulation bridge proves that conclusion.
2. Some family has superpolynomial intrinsic distance/depth. Then, through the standard-model bridge, this yields the corresponding deterministic lower bound and hence P≠NP for an NP-complete language.
3. The current observable is still a lossy shadow. Then retain its residual and continue reduction rather than forcing an asymptotic conclusion.

The program is deterministic mathematical progress: every step must be an equivalence, exact factorization, obstruction/residual, cost identity, or simulation theorem.

## 10. Immediate next theorem chain

Work in this order, continuously consulting the existing corpus before inventing machinery:

1. `Anveshana` × `Prasna`: identify propositional existence as a dependent question and the supplied witness as the answer coordinate.
2. Fibre composition (`SamyogaSesa` and related modules): compute exactly how the residual of witness production composes with verifier execution.
3. Coinductive composition: extend the previous result from one answer to dependent answer streams / branch histories.
4. Parallel/interchange structure: quotient mere serialization and isolate intrinsic dependency depth.
5. Native-cost instrumentation: use the `CountedDigitsEdge` discipline—cost is generated by the same recursion/reduction being measured.
6. Geodesic theorem: define and classify irreducible paths in the universal interaction calculus.
7. Only then instantiate an NP-complete relation and read off asymptotics.

## 11. Guardrails / corrections already learned

- The repository files named `P=NP...` do NOT establish standard complexity-theoretic P=NP. Their `Gap` predicate is a different information-loss/noninjectivity statement. Do not use them as the desired conclusion.
- `SubsetSumCostLocus` proves a 2^n witness census, not an optimal deterministic lower bound.
- A fibre with many path witnesses need not have many distinct sources; never equate fibre cardinality with collision count or search complexity.
- A scalar reachability/debt observable can be settled while nontrivial fibre geometry remains.
- Do not erase cubical/residual structure before pricing computation; that can manufacture artificial shortcuts or hide native work.
- Do not count arbitrary sequential orderings of independent interactions as intrinsic depth.

## 12. Central thesis of this lane

The P/NP question is a special case of the more primitive identity:

    computation cost = irreducible interaction geometry.

The verifier is cheap because the decisive dependent coordinate is supplied. The deterministic solver must produce the missing determination. The mathematical task is to compute the exact geodesic cost of that production in the already-constructed universal lossless interaction calculus. P=NP or P≠NP is whatever theorem that geometry transports back to the standard deterministic/nondeterministic models.
