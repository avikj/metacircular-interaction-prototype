# Proof-Carrying Relations — Delta 04: Composition, Existential Hiding, and Verification Cost

Date: 2026-08-13
Status: foundational exact definitions/theorems + live complexity frontier

## 0. Motivation

The sufficient-interface theory treats semantic validity as a relation R⊆A×B. The executable-math system needs more: outputs are accepted because evidence is checkable.

Define a proof-carrying relation by a polynomial-time verifier
    V_R(a,b,π)∈{0,1}
with semantic relation
    R(a,b) ⇔ ∃π V_R(a,b,π)=1.

The certificate π is not the semantic output b. This distinction is essential:
- b is what the next process consumes;
- π establishes admissibility;
- zero knowledge may hide π or intermediate b;
- recursive proofs may compress a long derivation into a short externally verified object.

## 1. Sequential composition

Given V_R for R:A↝B and V_S for S:B↝C, define the raw composite verifier
    V_{S∘R}(a,c,(b,π_R,π_S))
      = V_R(a,b,π_R) ∧ V_S(b,c,π_S).

THEOREM 1 (soundness/completeness of raw certificate composition).
The semantic relation recognized by V_{S∘R} is exactly relational composition:
    ∃(b,π_R,π_S) V_{S∘R}=1
iff
    ∃b [R(a,b)∧S(b,c)].

Proof. Expand definitions. QED.

Thus NP-style proof-carrying relations are closed under sequential relational composition.

## 2. Associativity

For R:A↝B, S:B↝C, T:C↝D, raw certificates for either parenthesization contain the same semantic data:
    (b,c,π_R,π_S,π_T),
up to tuple reassociation.

THEOREM 2.
Raw proof-carrying composition is associative up to canonical certificate isomorphism.

This is enough to form a category after quotienting certificate encodings by the canonical reassociation, with identity relation carrying trivial equality certificate.

## 3. Parallel composition

For R1:A1↝B1 and R2:A2↝B2 define
    V_{R1⊗R2}((a1,a2),(b1,b2),(π1,π2))
      =V1(a1,b1,π1)∧V2(a2,b2,π2).

Semantic tensor is Cartesian product relation.

Raw proof length is additive up to encoding overhead:
    |π1,π2|=|π1|+|π2|+O(log lengths)
for self-delimiting encodings.

Verifier time is additive up to tuple/dispatch overhead.

This supplies a baseline against which recursive/aggregated proof systems can be measured.

## 4. Existential hiding of intermediate states

Extensional composition only exposes (a,c), while the raw witness includes b.

Define public statement
    x=(a,c)
and private witness
    w=(b,π_R,π_S).

Any proof system for the NP relation
    L_{R,S}={(a,c):∃b,π_R,π_S V_R∧V_S}
can certify the composite without exposing b.

Thus "hide the intermediate state" is not metaphorically zero knowledge; it is exactly existential quantification followed by a ZK proof for the composite NP relation, assuming an appropriate ZK proof system.

Cryptographic assumptions enter only in the implementation/security theorem, not in the semantic closure result.

## 5. Materialization versus hidden composition

Delta 01 defined a materialization gap: intermediate b may require distinctions irrelevant to final c.

Proof-carrying composition yields a second distinction:
- internal witness b must exist;
- public interface need not reveal b.

Hence architecture can preserve correctness of a path while exposing only a proof of existence of a valid path.

For a chain
    A0↝A1↝...↝An,
the public claim can be only (a0,an), while all intermediate ai and local certificates are existential witness data.

This is the exact formal skeleton of private provenance compression.

## 6. Provenance and proof compression are different

A recursive proof that a chain is valid may compress external verification, but if the system discards the internal provenance DAG it loses the ability to inspect/reuse intermediate discoveries.

Therefore maintain two objects:
1. provenance object P: content-addressed DAG of transformations/evidence;
2. external certificate C(P): succinct proof of selected predicates about P.

A certificate is an observable quotient of provenance, not a replacement for provenance.

This directly matches the reconstruction theme: many provenance histories may map to one externally identical certificate.

## 7. Certificate observation map

Let Hist(x,y) be valid derivation histories from x to y.
Let Cert:Hist→C be a certificate compiler.

Define h~h' iff Cert(h)=Cert(h').

Then Cert induces an ambiguity fiber over derivations. A downstream consumer requiring only validity may safely operate on this quotient. A downstream consumer requiring attribution, novelty tracing, debugging, or branch reuse may not.

Thus "what must a proof reveal?" is again a task-relative sufficient-interface problem.

## 8. Theorem: certificate sufficiency is downstream-relative

Let D be a relation from derivation histories H to downstream actions A.
A certificate map q:H→C is sufficient for D iff every certificate fiber has a common valid downstream action:
    ∀c, ⋂_{h:q(h)=c} D(h) ≠ ∅.

Proof. Apply Delta 01 selector theorem. QED.

Consequently no globally "minimal proof representation" exists independently of what future processes need to do with the derivation.

## 9. Verification grades as dependent types / predicates

The library's V1/V2/V2.5/V3 ladder can be represented as predicates on evidence objects:
    Grade_g(statement,evidence).

A transformation may require an input at grade ≥g and produce output at grade h.

This suggests typing process edges not merely by mathematical object type but by epistemic contract:
    (Statement × Evidence_{≥g}) ↝ (Statement' × Evidence_{≥h}).

A failed proof/counterexample is not bottom/garbage; it inhabits a different certified result type such as
    Refutation(conjecture)
or
    NoGo(branch,premises).

This preserves the existing number-theory research discipline at the type level.

## 10. Monotonicity of evidence strength

Suppose evidence grades form a preorder g≤h meaning h entails all guarantees of g.
There are forgetful coercions
    Evidence_h → Evidence_g.

These are quotient/forgetful maps. Downstream tasks requiring only g should be invariant under details distinguishing h-evidence objects that coerce to the same g-view.

This is another exact place for sufficient-interface analysis.

## 11. Self-improvement as certified endomorphism

Let M denote an agent/research-machine state including code, policies, theorem libraries, evaluators, and provenance.

A self-modification is a relation
    U:M↝M.

A certified self-modification carries π establishing invariant I:
    V_U(M,M',π)=1 ⇒ I(M,M').

Sequential self-improvement is iteration U^n. If certificates compose, one can prove selected invariants across the trajectory without requiring the external verifier to replay every internal reasoning step.

The nontrivial problem is choosing I. Formal certification proves the specified predicate, not that the predicate captures "improvement."

## 12. Improvement relation is inherently multi-objective

Let evaluators e_i assign partially ordered evidence about capabilities/cost/correctness. Define Pareto improvement relation:
    M ≺ M' iff all required invariants hold and e_i(M')≥e_i(M) for all protected coordinates, with strict gain somewhere.

This relation may be incomplete: many modifications are incomparable.

Therefore a Darwinian population of machine states naturally fits relational rather than scalar optimization semantics.

## 13. Branching provenance as a multiway proof process

From state M, multiple certified transformations may exist:
    M ↝ {M1,M2,...}.

The full research process is a DAG/multiway system, but quotienting by observational equivalence can merge states whose future-relevant behavior is equivalent.

Critical question:
what equivalence is congruent under future composition?

Define behavioral equivalence relative to a class C of future contexts:
    M ~_C N iff every context K∈C admits the same observable outcomes from M and N.

This is process-calculus/contextual-equivalence territory and should be connected to bisimulation/logical relations rather than reinvented.

LIVE FRONTIER: choose the context class appropriate for executable mathematical research and find a tractable proof principle for equivalence.

## 14. Relation to Statebox/process calculi

Statebox's appeal in the existing program is compositional process semantics: valid global processes generated from typed local transitions.

The present proof-carrying relation category is deliberately weaker and more elementary. Its purpose is to establish a minimal substrate:
    typed relation + existential witness + verifier + composition.

Petri nets, symmetric monoidal categories, operads, event structures, and process calculi should enter only when they add:
- concurrency/independence;
- resource sensitivity;
- causal partial order;
- behavioral equivalence;
- compositional proof rules.

This prevents premature selection of a fashionable categorical language.

## 15. Information and causality separate

A chain R;S has causal order by construction.
But public information need not reveal the intermediate b.

Conversely two parallel processes may be causally independent but require shared information to choose jointly valid witnesses.

Hence the library's split
    G_coord=G_noncommute ∪ G_information
survives this formalization.

Proof systems add a third annotation, not necessarily a third dependency graph:
    G_certificate
records which claims depend logically on which evidence.

Whether G_certificate is derivable from causal/provenance structure depends on proof aggregation and should not be assumed.

## 16. Computational gap

Semantic interface complexity C∞ ignores the cost of finding witnesses.

Define a family R_n with polynomial-time verifier. Let semantic rate be C∞(R_n).
Define efficient realization cost by restricting selectors/encoders to polynomial time.

If finding any valid b∈R_n(a) solves an NP-hard search problem, then under P≠NP no polynomial-time semantic selector exists even if C∞ is tiny.

Example schema:
A contains satisfiable CNF formulas φ; B contains satisfying assignments; R(φ,b)=1 iff b satisfies φ.
For a domain restricted to satisfiable formulas, every input has a witness. The output alphabet is enormous and semantic cover structure alone says nothing about efficient witness generation.

Thus:
    semantic compressibility ≠ computational realizability.

This separation is central for frontier AI: model intelligence/search power lives in the gap.

## 17. Oracle/agent decomposition

Treat a frontier model as a heuristic witness generator G and a formal verifier V as the soundness boundary.

The composed system:
    x --G--> candidate (y,π?) --V--> accept/reject
can exploit untrusted generative power while retaining formally checkable outputs where V is decisive.

For theorem proving, π is a proof term checked by Lean/Agda/etc.
For numerical claims, π may be exact arithmetic/interval certificates.
For literature novelty, no comparably complete verifier exists; the evidence type must encode weaker epistemic status.

This matches the library's insistence that evidence grades are heterogeneous.

## 18. Next exact targets

A. Formal category PCRel of finite/encoded proof-carrying relations and certificate morphisms.
B. Add symmetric monoidal tensor and prove coherence.
C. Define leakage observation on certificates and compose via information bounds.
D. Add event structures for concurrency and identify when certificate dependencies can be parallelized.
E. Formalize context/bisimulation equivalence for research-machine states.
F. Encode V1/V2/V2.5/V3 evidence contracts in Lean or Cubical Agda.
G. Connect recursive SNARK/IVC proof aggregation as a concrete implementation of existentially hidden sequential composition.
H. Study proof complexity: lower bounds on certificate size under composition.
I. Define provenance-preserving proof aggregation: succinct root certificate + retrievable content-addressed derivation DAG.
