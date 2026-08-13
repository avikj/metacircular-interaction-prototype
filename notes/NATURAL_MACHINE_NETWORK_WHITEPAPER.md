# Natural Machine Network

## A proof-carrying research protocol beyond scalar currency

**Whitepaper draft 0.1 — 2026-08-13**

**Status.** This paper composes results, protocols, and implementation work
already present in this repository with established mathematics and computer
science. It is not a claim that the complete network described here has been
built. Section 16 separates operating components, proved finite results,
specified interfaces, and open engineering. “Rosetta” names the practice of
recording exact translations between languages; it does not rename the
mathematics being translated.

## Abstract

Many cryptocurrency systems compress exchange value to a scalar balance and
use a replicated ledger to agree who controls how much of it. Mathematical research
has a different state space. A proof, counterexample, formal translation,
dataset, instrument, cache, permission, and theorem-prover environment are not
fungible units. Their future value depends on the task, admissible language,
trust policy, dependency graph, and available transformations. Equal present
cost can leave incomparable future capabilities. A scalar balance therefore
cannot be the primary state without destroying information.

We specify a target content-addressed, proof-carrying research network whose
proposed durable state is a versioned graph of mathematical presentations,
claims, obligations, evidence, theory morphisms, verification events,
permissions, and provenance. Hashes establish byte identity, and establish
presentation-record identity only under a pinned schema and identity
projection. Mathematical equivalence requires a typed witness checked under a
pinned theory and verifier. Theorem transport requires a checked morphism path
and target proof replay. Authority history is designed to be append-only;
scope and revocation are policy-controlled and separate from verification.
Resource
allocation consumes plural, task-relative signals; it cannot promote a theorem.

The economic object is not a universal coin. Resources and capabilities form
typed vectors with partial orders and composition laws. A scalar price is an
optional, local decision rule declared for one allocation problem. Settlement
may use ordinary money, mutual credit, escrow, or no transferable asset at all.
The protocol’s hard objectives are no false automatic promotion, replayable
provenance, visibility of dissenting witnesses, and preservation of future
option value. A protocol cannot itself preserve truth independently of its
formal semantics, checkers, evidence, and authority assumptions.

## 1. The problem with one-dimensional value

Let a retained cache `K` support a declared family of future tasks `F`. Its
future-cost profile is

\[
V_F(K)=\bigl(\operatorname{cost}_K(f)\bigr)_{f\in F}. \tag{1}
\]

The repository contains the following exact counterexample. Under the same
deterministic binary construction policy, the traces

\[
1,2,4,5 \qquad\text{and}\qquad 1,2,3,6
\]

have equal construction cost and retain equal numbers of intermediates. Yet
the first cache forms `4` at zero additional cost and `3` at cost one, while
the second reverses those costs. Their future profiles on `F={3,4}` are
incomparable. No scalar function of present cost and cache size recovers both.

This is not peculiar to arithmetic caches. Related failures of scalar
compression appear when:

- two proofs discharge different downstream obligation sets;
- two experiments distinguish different hypothesis pairs;
- two process POVMs have identical statistics but different implementations;
- two derivations reach the same visible term with different inherited state;
- two mathematical presentations are equivalent through different morphisms;
- one negative result eliminates a strategy class while another builds a tool.

Consequently, a fungible token may settle an external debt, but it cannot be
the semantic representation of mathematical value.

### 1.1 Standard economic structure

For a fixed interface, composable resource bundles may be modeled by a
commutative monoid `R`, or by a partially defined monoidal operation when not
all bundles compose. Feasibility and a declared preference or
resource-convertibility relation may add a preorder `≤`. Multiple resource
coordinates are familiar from resource theories and multiobjective
optimization. Task-relative evaluation is a map

\[
e_T:R\longrightarrow C_T,                             \tag{2}
\]

where `C_T` may itself be partially ordered. When the preorder means
no-less-desirable or no-less-capable, a compatible price or utility may be
chosen monotone. Such a functional `p:R→ℝ` belongs to a declared market or
decision problem; it is not intrinsic to `R`, and different tasks need not
admit the same useful scalarization.

The proposed allocation representation therefore retains resource vectors and
may compute Pareto frontiers. It scalarizes only at an explicit decision
boundary, with the policy, task, and information loss recorded.

## 2. System thesis

The network is a proof-carrying, content-addressed theory graph with four
separate planes:

1. **Semantic plane:** presentations, theories, sentences, models, claims,
   obligations, morphisms, proofs, counterexamples, and transports.
2. **Verification plane:** pinned kernels, environments, replay logs, verifier
   policies, independent audits, and formal certificates.
3. **Authority plane:** acceptance, quarantine, revocation, permissions,
   privacy, release, and governance events.
4. **Allocation plane:** tasks, budgets, compute, attention, deadlines,
   prospective funding, and retrospective contribution attribution.

No plane may impersonate another:

- a hash is not a proof of equivalence;
- a proof check is not an acceptance event;
- acceptance is not irreversible truth;
- stake or payment is not epistemic authority;
- prediction is not permission to install or execute;
- high reuse is not proof of correctness;
- consensus over ledger state is not consensus over mathematics.

## 3. State model

The specified durable state is a versioned directed graph with append-only
authority/history events. The current repository approximates it through
mutable, Git-versioned source records plus partial append-only logs. Its
principal node types use standard names:

- content-addressed artifacts;
- normalized mathematical presentations;
- signatures, theories, sentences, and models;
- claims and proof obligations;
- evidence and falsifiers;
- theory morphisms and proof objects;
- verification results;
- acceptance, quarantine, and revocation events;
- tasks, capabilities, permissions, and resource commitments;
- provenance and dependency edges.

Human-readable names are not by themselves stable semantic identifiers. A
versioned manifest or identity projection may nevertheless include a path or
name when the declared presentation semantics require it.

The present repository only approximates event sourcing. Claim events are
intended to reconstruct current status, but interrupted multi-file updates can
leave source records inconsistent until validation catches them. Transactional
event append and complete replay are design requirements, not operating facts.

Git branching and manual merge are not a conflict-free replicated data type.
CRDT convergence requires a specified state or operation algebra under delivery
assumptions. Mathematical claims may contradict without a lawful join, and
authority events do not currently commute. Git is the content-addressed
synchronization transport; semantic integration remains an explicit judgment.

### 3.1 Four identity levels

The implementation must state which equality it asserts.

| level | equality asserted | mechanism or target interface |
|---|---|---|
| artifact | exact stored bytes | domain-separated hash plus byte replay; collision or unequal resolution is fatal |
| presentation | same admitted canonical representation and dependencies | versioned canonicalizer and schema |
| witnessed equivalence | a supplied equivalence or isomorphism has passed its checker | proposed generic typed morphism/verification/policy record; selected artifacts already instantiate the pattern |
| class at a ledger head | connected under one declared equivalence theory and ambient structure by currently accepted invertible morphisms | proposed immutable graph snapshot at one authority head |

A later proof can join two earlier classes without changing either
presentation. Class snapshots are therefore head-relative views, not eternal
semantic identifiers.

### 3.2 Content addressing

For record type `T`, an identifier has the form

\[
\operatorname{id}_T(r)=
\operatorname{SHA256}(d_T\,\|\,\operatorname{CJSON}(P_T(r))), \tag{3}
\]

where `d_T` is a versioned domain separator, `CJSON` is a pinned canonical JSON
encoding, and `P_T` is the documented identity projection. Floats, unknown
fields, ambiguous encodings, dependency cycles in version 1, and digest/object
mismatches fail closed.

The hash commits to syntax, dependencies, schemas, environments, and policies
only when those fields are in the preimage. It never proves extensional program
equality, isomorphism, observational equivalence, or theoremhood.

## 4. Proof-carrying morphisms

The Rosetta layer records exact correspondences using established morphism
notions: definitional equality, homomorphism, isomorphism, equivalence of
categories, chain homotopy equivalence, conjugacy, interpretation, institution
morphism, simulation, reduction, kernel quotient, or behavioral-equivalence
quotient. These relations are context-specific and not interchangeable.

A candidate morphism contains:

```text
(equivalence theory,
 source presentation,
 target presentation,
 witness artifact).
```

An independent verification binds the exact subject, checker, environment,
axiom profile, inputs, outputs, and replay log. An append-only acceptance event
then states whether that verified edge is currently admitted. Inverses,
composition, associativity, unit laws, and coherence require their own checked
operations before the accepted graph may be called a groupoid.

This follows the trust separation of proof-carrying code: an untrusted producer
supplies a proof or certificate that a consumer checks against a fixed policy.
Selected Agda, Lean, and exact certificate artifacts instantiate this contract.
The generic research registry does not yet; many obligations remain prose and
certification transitions are disabled. “Proof-carrying research network” is
the design target, not the present implementation grade.
This is an analogy to proof-carrying code's producer/proof/fixed-consumer-policy
separation, not an implementation of proof-carrying code for arbitrary
mathematics. A proof term alone is not proof-carrying code unless the consumer
policy and checker contract are fixed and bound.

### 4.1 Theorem transport

Sharing an equivalence class does not copy theorem status. A transport record
must cite:

- the accepted morphism path at a specific graph head;
- the source theorem and its authority head;
- the property-specific transport construction;
- the target statement and proof artifact;
- an ordinary target verification.

Distinct paths remain distinct until a coherence witness proves their equality.
This preserves automorphisms, proof routes, computational costs, and higher
structure that union-find would erase.

### 4.2 Univalence boundary

Univalence and the Structure Identity Principle explain when an appropriate
equivalence can support identity-like transport inside a specified univalent
foundation. They do not discover equivalences, decide arbitrary isomorphism,
erase the chosen structure signature, or turn a Lean isomorphism into a Cubical
Agda path without an explicit bridge.

## 5. Institution-theoretic language change

The network treats changes of mathematical language using institution theory:
signatures form a category, sentences vary covariantly, models vary
contravariantly, and satisfaction is invariant under signature morphisms.

For deterministic probes, an atomic formula is `(q,y)` with

\[
x\models(q,y)\iff r_q(x)=y.
\]

A probe translation `τ:Q→Q'` and model reduction `s:X'→X` preserve all old
atomic truths exactly when

\[
r'_{\tau(q)}(x')=r_q(s(x'))                          \tag{4}
\]

for every `q,x'`. This is a Rosetta entry only after the probe and state maps
are components of the required sentence and model functors for declared
institutions and a supplied signature morphism. Under that typing, equation
(4) is the standard satisfaction condition specialized to atomic formulas. A
bare commuting square of response functions does not itself construct an
institution or institution morphism.

Institution theory audits a supplied language morphism. It does not choose the
new signature. Indeed, a two-element algebra can have two expansions of the
same old reduct in which a new unary operation is respectively identity and
swap. No transcript expressed only in the old language determines which
extension was intended.

## 6. Claims, obligations, and epistemic state

A claim is not a balance update. It is a versioned statement with:

- definitions and ambient theory;
- assumptions and axiom profile;
- proof obligations;
- planned falsifiers and controls;
- evidence artifacts;
- dependency and supersession edges;
- independent review state;
- append-only authority events;
- successor questions and known boundaries.

The network distinguishes generation, verification, and acceptance. Numerical
work may falsify or replay a declared exact quantity; it cannot establish an
unrelated theorem. Refutations remain first-class graph objects. Corrections
append or strike through rather than silently rewriting history.

### 6.1 Forecasts and hostile review

Before attempting a claim, a worker records an outcome space and credences.
Load-bearing claims require independent rederivation or replay, false-model
controls, and explicit suspect joints. These mechanisms do not make prediction
a source of truth; they make surprise and confirmation bias inspectable.

### 6.2 Current compiler

The repository already operates a deterministic read-only compiler over claims,
obligations, evidence, events, artifacts, dependencies, messages, journals, and
Git state. It produces a content-addressed snapshot and supports summary,
claim inspection, reverse-impact queries, frontier queries, validation, and
session resumption. It cannot promote, refute, merge, allocate, or mutate.

## 7. Capability security and delegation

The proposed operational authority layer uses object-capability security and
the principle of least authority. Capabilities would be scoped and attenuable
rights to perform specific actions on specific resources. Expiry and revocation
are not intrinsic to capability possession; the design must supply explicit
indirection, revocation proxies, epoch/key rotation, or expiry. Examples
include:

- read a private artifact class;
- execute a pinned checker under a budget;
- propose but not accept a morphism;
- review a specified obligation;
- allocate a bounded child budget;
- publish an explicitly approved compressed result;
- pause an unsafe execution path.

A delegation record would bind parent capability, child scope, budget, expiry,
manager, executor, reviewer, and revocation conditions. Recursive budgets could
form local research groups without giving them theorem authority. Current Git
credentials and social protocol do not implement this object-capability layer.

Prediction remains separate from installation authority. A model may recommend
an action; only a provenance-bearing authorized event installs it. Repeating a
forecast cannot manufacture permission.

## 8. Allocation without epistemic markets

The allocation plane may use markets, auctions, grants, streams, schedulers, or
manual judgment. None determines claim status.

### 8.1 Prospective allocation

Prospective contracts fund an obligation before it is solved. A task contract
should specify:

- exact statement or residual obligation;
- allowed assumptions and prohibited shortcuts;
- expected artifact and certificate types;
- checker and replay environment;
- privacy class and release boundary;
- budget, deadline, and stopping rule;
- reviewer-independence and acceptance policy.

Funds may be escrowed and released on policy-compliant acceptance events. The
payment condition is the event, not an oracle claim that the mathematics is
true. A defective policy remains defective even if every signature is valid.

### 8.2 Retrospective contribution attribution

Retrospective attribution follows recorded reuse and dependency discharge. A lemma,
counterexample, translation, source correction, or checker may later affect
many claims. Credit attaches to content-addressed contributions and witnessed
dependency paths, not only to persistent agent identities.

This is provenance and contribution attribution, not identified
counterfactual causation. Shared contribution, substitutable proofs, delayed
reuse, and counterfactual dependence can produce several defensible
allocations. The system retains the underlying graph and may display Shapley
values only after a characteristic function is declared; dependency paths do
not supply one. Marginal contributions, dependency cuts, or causal estimates
likewise require their own explicit model and assumptions.

### 8.3 No permanent scientific score

Within hard safety constraints, useful allocation coordinates include:

- verified obligations discharged;
- certified transports and reusable kernels;
- strategy classes eliminated by sharp counterexamples;
- transfer across problems, representations, and proof systems;
- verification debt and representation lock-in avoided;
- compute, latency, energy, money, and human attention consumed;
- future option value retained.

These coordinates remain Pareto-visible. A scalar objective is a versioned
policy for a preregistered decision, never the definition of scientific value.

## 9. Optional settlement mechanisms

The semantic protocol does not require a native cryptocurrency. Compatible
settlement choices include:

1. ordinary fiat payment through external rails;
2. nontransferable budget units issued by an institution;
3. bilateral or multilateral mutual credit;
4. escrowed grants released by threshold authorization;
5. transferable tokens representing a sharply specified resource claim;
6. no payment, with only provenance and attribution recorded.

If a transferable token is introduced, it must name what claim it represents:
compute time, storage, verifier service, access, governance power, or settlement
credit. These token classes must not be silently interchangeable.

### 9.1 Why “proof of work” is insufficient

Proof of work proves possession of a nonce satisfying a difficulty predicate.
Under hash-function and hardware assumptions it implies expected search work,
not a receipt for exact compute or energy consumption. It does not prove
mathematical usefulness or truth. Proof-of-stake signatures prove
control of stake and agreement under a protocol; they do not make a theorem
valid. Verifiable computation can certify that a program ran on committed
inputs, but the program specification and theorem interpretation remain
separate obligations.

### 9.2 When scalar currency is safe

A scalar settlement asset is appropriate when participants have already agreed
to exchange a fungible resource under a fixed contract. It is unsafe as the
canonical representation of:

- theorem equivalence;
- proof strength;
- future research capability;
- epistemic independence;
- cultural or historical authority;
- permission to release private work;
- physical realizability of an abstract operation.

## 10. Consensus, federation, and privacy

The present repository uses private Git synchronization and procedural
integration. It is not a decentralized consensus network. A federated version
would need to choose separately:

- data availability and replication;
- ordering/finality of authority events;
- membership and Sybil resistance;
- verifier discovery and trust roots;
- fork choice and recovery;
- confidential computation and selective disclosure;
- legal responsibility and release authority.

Any consensus protocol must declare membership/admission, adversary and fault
thresholds, safety, liveness, availability, finality, and fork assumptions. Its
scope is shared operational state; no consensus protocol can vote a theorem
true. Different communities may retain different accepted
edge heads, axiom profiles, or authority policies while sharing artifacts and
candidate morphisms.

Private material is never sent to an external chain merely to timestamp it.
Commitments may be published only under an explicit release policy, with the
risk of metadata leakage assessed. Zero-knowledge proofs, secure multiparty
computation, or trusted execution environments may later prove selected facts
about private work, but none is assumed by the current system.

### 10.1 Current security grades

| property | present grade | boundary |
|---|---|---|
| content integrity | implemented, narrow | when trusted expected hashes/bytes exist and verification runs, hashes and validators detect mismatch; they do not prove authorship, truth, availability, or semantic equality |
| authorship/authentication | not established as a protocol property | Git-host credentials and commit metadata are operational mechanisms; no mandatory signature scheme, key binding, rotation, revocation, or compromise-recovery protocol is specified |
| mathematical verification | implemented for selected artifacts | Agda, Lean, and exact certificate checkers establish specified judgments, not novelty, authorization, or economic value |
| claim/history validation | implemented, limited | schemas and legal transitions are checked; historical artifact gaps remain visible |
| access and release control | procedural | private Git and explicit human policy; no end-to-end cryptographic access-control protocol is specified |
| epistemic authority | procedurally centralized | parallel work is integrated by a high-context human/root process; privileged approval is not enforced by repository access control |
| resource allocation | manual or proposed | no automatic allocator, market, token, or causal-credit engine is operating |
| Byzantine consensus and finality | not implemented | Git workflow is not a Byzantine-fault-tolerant consensus protocol |
| Sybil resistance | not implemented | handles, branches, and model lineages are not costly or externally authenticated identities |
| adversarial data availability | not established | ordinary clones and a private remote provide redundancy, not a retrievability or availability theorem |
| economic security | not implemented | no issuance, fees, stake, slashing, or incentive-compatibility analysis governs the repository |
| quantum cryptographic security | not claimed | there is no QKD or device-independent protocol, post-quantum signature profile, quantum adversary model, or composable security definition |

The current controls address accidental corruption, malformed records, illegal
status transitions, unsupported promotion, and replay failures. For compiled
graph artifact reads, repository-root confinement rejects absolute paths,
parent traversal, and symlink escape; this is not general filesystem hardening.
The controls do not establish protection against a malicious host,
compromised credentials, colluding writers, censorship, denial of service,
supply-chain compromise, metadata leakage, or quantum cryptanalysis.

## 11. Experiments, learning, and instrument choice

For a fixed finite hypothesis class, target, labels, and teaching protocol, the standard teaching-dimension theorem
characterizes the minimum labeled examples that identify one target: the
selected queries must hit every rival disagreement set. Separating every pair
is the minimum test cover problem for binary tests. For finite-valued probes,
the corresponding established objects are a categorical generalized test
collection or a minimum point-separating family of functions/partitions.
Atomizing one grouped categorical probe into independently selectable binary
outcome fibers changes the feasible selections and can change the optimum.

These results optimize inside a supplied hypothesis class and query language.
They do not form the class or language. Benevolent teaching, adaptive
membership queries, and equivalence queries have different information and
cost models; there is no protocol-independent minimum interaction.

### 11.1 Physical experiments

For a convex finite-dimensional class `C` of quantum combs, old affine outcome
responses `f_i` of physically admissible testers, and a proposed tester outcome
response `g`, the new response distinguishes an unresolved feasible direction
exactly when (process POVMs are the one-slot channel-measurement case)

\[
\exists\Delta\in\operatorname{span}(C-C):
f_i(\Delta)=0\ \forall i,
\quad g(\Delta)\ne0.                                  \tag{5}
\]

In this finite-dimensional setting, equivalently, the restriction of `g` lies
outside the linear span of the old restricted responses. This is the standard
linear-span/annihilator criterion for refinement of a statistical experiment.

Physical admissibility, statistical informativeness, task utility, calibration,
implementation cost, and authority to add an instrument are separate. Equality
of tester statistics—process-POVM statistics in the one-slot case—is the kernel
quotient of the restriction map. If the outcome representatives form an
operator system `S` whose order unit is the deterministic effect, and
evaluation on compact `C` is the associated unital positive map into a
commutative function system, then the matrix-ordered carrier is the
Archimedean quotient operator system `S/ker(q_C)`. This conditional refinement
does not follow from the bare vector quotient. Blackwell equivalence is coarser
when outcome garbling is free. Identical statistics need not imply identical
realization cost.

Allocation for physical deployment must retain implementation feasibility and
resource vectors; quotient statistics alone suffice only for decision problems
declared invariant under implementation.

For an actual multi-time comb, coherent memory is the ancillary system retained
between teeth in a sequential realization. With free classical side
information, its memory cost is a global positive-decomposition/rank
optimization in the quantum-comb literature; independently minimizing each cut
can be incompatible. Ordinary matrix rank or a list of cutwise minima is not
comb memory cost.

Logical memory and matrix rank are not thermodynamic work. Applying a Landauer
bound requires specified logically irreversible erasure/reset in a
thermodynamic model with reservoir temperature, error tolerance, and control
protocol. None is inferred from a Git event, proof step, quotient, or abstract
memory coordinate.

## 12. Rosetta practice

A Rosetta entry records:

- the source and target objects in their established vocabularies;
- the exact map, adjunction, quotient, equivalence, interpretation, or
  obstruction connecting them;
- hypotheses and ambient theories;
- preserved invariants;
- kernels, fibers, lost structure, and failed converses;
- source provenance and novelty boundary;
- proof or checker status.

Rosetta work does not assert that everything is isomorphic. It locates the
category in which a comparison is valid and computes the residual when it is
not. Established terminology remains attached to the mathematics. When no
standard common object has been established, the network records an
untranslated residual rather than inventing a name.

Cross-cultural work obeys the same rigor with an additional constraint:
traditions are engaged through their native problems, texts, disputes, and
technical terms. A modern formal record must not be attributed to Nyāya,
Buddhist pramāṇa, Pāṇinian grammar, or another tradition merely because an
analogy is suggestive. Source uncertainty and commentary layers remain part of
provenance.

## 13. Threat model

### 13.1 Semantic attacks

- **Hash/equivalence confusion:** equal hashes or similar text are promoted to
  mathematical equivalence.
- **Relation confusion:** embedding, reduction, simulation, or observer
  equality is treated as isomorphism.
- **Unchecked transport:** theorem status is copied across a bridge without
  translating hypotheses.
- **Axiom laundering:** classical, unsafe, or environment-specific assumptions
  disappear from the record.
- **Canonicalizer overreach:** a heuristic normal form silently merges objects.
- **Semantic merge mistaken for text merge:** Git merges without textual
  conflict while two claims disagree mathematically, or conflicts textually
  while their theorems are equivalent. Mitigation requires explicit semantic
  comparison; neither Git nor a CRDT label settles it.
- **Torn event update:** an authority event and its source record diverge after
  interruption. Mitigation requires transactional append or deterministic
  replay plus fail-closed validation.
- **Proof-policy mismatch:** a certificate checks against the wrong statement,
  axioms, toolchain, environment, or safety policy.
- **Unwitnessed schema migration:** a canonicalizer or identity projection
  changes and silently changes presentation identity.

Mitigation: typed relations, pinned schemas and axiom profiles, checked
morphisms, target proof replay, migration witnesses, transactional or replayed
authority state, and fail-closed canonicalizers.

### 13.2 Epistemic and economic attacks

- **Evaluator capture:** reviewers reward visibility, allies, or easily
  measured output.
- **Sybil review:** nominally independent audits share an operator, model,
  training lineage, or code path.
- **Goodharting:** agents maximize document count, token emission, benchmark
  score, or shallow check passes.
- **Negative-result suppression:** counterexamples and stopped routes receive
  no credit.
- **Option-value destruction:** caches or witnesses are compressed to scalar
  totals and later become unusable.
- **Self-dealing:** a proposer chooses its own checker, acceptance policy, and
  reward.
- **Stale read model:** a cached materialized view is treated as current
  authority.
- **Authority laundering:** evidence, prediction, payment, or reputation is
  treated as permission to install, accept, or publish.
- **Empty-version-space arbitrariness:** inconsistency triggers an unrecorded
  enlargement of the hypothesis class.
- **Categorical-probe atomization:** a grouped experiment is split into
  independently selectable outcome tests, falsifying its cost model.
- **Revocation as erasure:** withdrawal deletes prior evidence or scholarly
  history rather than changing current authority.

Mitigation: separated roles, disclosed dependencies, plural audits, frozen
controls, graph-based provenance, retained negative results, vector-valued
allocation signals, and no self-approval.

### 13.3 Operational attacks

- key compromise and unauthorized delegation;
- replay or equivocation in authority events;
- artifact withholding and data unavailability;
- dependency substitution and environment drift;
- denial of verification through costly witnesses;
- privacy leakage through public metadata;
- governance capture of budgets or release authority;
- hidden equivocation between forked authority heads.

Operating mitigations are content-addressed dependencies, selected reproducible
environments, private-by-default release policy, and limited validators.
Proposed mitigations are scoped capabilities, explicit expiry/revocation,
threshold controls, availability rules, resource limits, authenticated
checkpoints, and specified fork choice and recovery.

## 14. Governance constitution

Governance controls operation, not mathematical truth.

1. Verification policies and trusted kernels are versioned and replaceable.
2. The target authority model uses append-only acceptance, quarantine, and
   revocation events; current repository enforcement is incomplete.
3. Budget allocation cannot alter claim status.
4. Stake, reputation, seniority, or model confidence cannot waive a proof
   obligation.
5. Private release requires explicit human or institutional authority.
6. For each consequential live input, policy must identify authorized
   principals, consent or objection rules, conflicts, appeals, and emergency
   powers; prediction cannot silently substitute for an authorized response.
7. Policy changes create new heads; they do not rewrite old history.
8. Forks should preserve evidence when communities disagree about axioms,
   policies, or governance, subject to availability, privacy, legal, and safety
   constraints.

The protocol permits plural evaluators and communities while keeping every
accepted statement relative to a visible theory, verifier policy, environment,
and authority head.

### 14.1 Authentication, testimony, procedure, and property

The design requires separate records for authentication, verification,
authorization, governance procedure, custody/ownership, allocation, and
valuation. The current repository implements only some of them. Neither
cryptography nor historical analogy licenses their merger.

A source-grounded Indian audit sharpens the separation without proposing an
Indian cryptocurrency or governance algorithm:

- In Annambhaṭṭa's `Tarkasaṅgraha` §§35–41 and 59–63, a digitally authenticated
  utterance is not thereby `āptavākya` or `śabda-pramāṇa`; competence,
  truthfulness, sentence conditions, and truth-apt cognition are additional
  questions. Conversely, this Nyāya text supplies no digital signature or
  key-management scheme.
- The Theravāda Pāli `Mahāvagga` IX.3–4, for the specified monks'
  `saṅghakamma`, distinguishes presence, procedural eligibility, quorum,
  motion (`ñatti`), proclamation (`anussāvana`), effective protest
  (`paṭikkosanā`), and conformity to governing norms. A threshold-signature
  verifier establishes its specified statement only under the declared scheme,
  keys, and security assumptions; it does not by itself prove human identity,
  procedural eligibility, legitimacy, or truth.
- For the enumerated monastic property in the cited Theravāda `Cullavagga`
  VI.16 passage, `saṅgha` property is described as `avissajjiya` and
  `avebhaṅgiya`—not to be transferred or divided. This defeats the general
  equation “collective property equals freely divisible balances of current
  members.” It does not itself specify a modern trust, corporation, token, or
  smart contract.

The historical gender, affiliation, territorial, monastic, and institutional
exclusions in the cited `Mahāvagga` transaction passage are provenance boundaries, not design
recommendations. No common formal object uniting these traditions with the
modern protocol has been established. The full source audit and untranslated
residuals are recorded in `WHITEPAPER_INDIAN_AUTHORITY_PROPERTY_AUDIT.md`.

## 15. The mathematical payload

The network is not proposed around an empty ledger. Its present corpus contains
checked terms, exact finite theorems, prior-art translations, counterexamples,
and open joints across several mathematical lives.

### 15.1 Generation and behavioral quotients

The common standard construction behind several implemented examples is the
Myhill–Nerode/future-behavior equivalence: two states are identified when every
admitted continuation produces the same observation. This yields:

- remainder automata for positional divisibility;
- substring-recognition automata;
- quotient dynamics and finite process discrimination;
- unobservable-subspace quotients for finite linear systems.

On finite systems, a separate pair-graph breadth-first search supplies shortest
distinguishing experiments. A further set-cover optimization over the admitted
probe family supplies a minimum test collection. Neither extra optimization is
part of the Myhill–Nerode theorem itself.

The Lean development checks that complete-future equality is an equivalence,
is preserved by actions, supports quotient actions and observations, and is the
compatible with execution before and after quotienting. By definition it is
equality of the complete behavior functions; this prose fact is not presented
as an additional kernel-checked universal-property theorem. Domain-specific
calculations then identify its arithmetic, linguistic, or control-theoretic
form.

### 15.2 Arithmetic and construction

For binary divisibility by `m=2^a q` with `q` odd, the exact minimal state count
is the established `q+a` result. The repository adds an exact dynamical
reconstruction of its coordinates: `q` is the stable image size of repeated
multiplication by two modulo `m`, and `a` is the number of strict image
contractions. General-radix divisibility notes give explicitly bounded finite
signatures under their stated base/modulus hypotheses; compiled action words
retain their expansion.

The formal corpus also contains Lean-checked `2×2` Smith certificate theorems,
Cubical-Agda checked Smith interfaces, and separately executable exact replay
certificates, together with counted executions, residue transports, addition-chain and
valuation witnesses, and precise no-gos showing where coefficients, histories,
or action carriers cannot be replaced by their cardinalities.

### 15.3 Charts, univalence, and symmetry

The Cubical Agda development is accepted under `--cubical --safe`, with no user
postulates or holes. It proves:

- loop spaces of finite types correspond to their symmetric groups;
- the natural-number algebra is rigid although its bare carrier has
  nontrivial permutations;
- tally and canonical digit presentations are equivalent to `ℕ`;
- transport of addition along univalence computes as native ripple-carry
  addition on canonical words;
- reversal and complement are chart symmetries with different compatibility
  with truncation and value maps;
- cardinality is a truncation that forgets the permutation loop space;
- explicit most-significant- and least-significant-digit inverse limits are
  equivalent under reversal, while canonical group-diagram structure and carry
  expose what the bare type equivalence forgets.

This is the formal center of the system's identity discipline: equivalence can
transport a particular structure only after the structure and morphism type are
named.

### 15.4 Gluing, observers, and residuals

For residue views modulo `m` and `n`, compatibility is equality modulo
`gcd(m,n)` and each compatible pair retains a fiber of that size; coprime views
reconstruct exactly. For averaging projections, commutation is controlled by
incidence geometry, and leakage measures the failure of one observation space
to remain invariant under another action. In contextual quantum examples,
operator phase, cover, local system, and downstream obstruction class remain
separate objects.

Across these cases the network stores the standard kernel, fiber, cokernel,
cocycle, commutator, obstruction, or missing hypothesis—not a generic
“mystery residual.” A Rosetta entry is complete only when the native residual
has been identified or honestly left open.

### 15.5 Analytic and spectral research

The larger corpus includes exact and corrected work on prime-pair spectral
expansions, positivity criteria, arithmetic regularity, Mellin/Fourier
translations, rigidity and homometry, operator algebras, eigenmeasures, and
finite optimization certificates. These results carry individual hypotheses,
correction ledgers, and evidence grades. This whitepaper does not flatten them
into one tokenizable claim or restate their hundreds of pages; the research
graph compiler provides a typed, partial index whose omissions and dangling
artifacts remain visible. It is not a lossless semantic index of every note.

### 15.6 Open typed joints

The specified capability graph records missing maps rather than inferring them
from imports. Some closed edges are actual Lean or Agda terms; some open joints
are checked interface types; others are explicitly prose-level boundaries.
Current examples include an observational-class carrier for a declared complete
response relation and an adapter from a classical response oracle to a coherent
phase oracle with explicit compute–phase–uncompute cost. “No checked inhabitant”
is asserted only for an interface that actually elaborates as a type; an open
prose joint merely says no implementation is recorded, not that impossibility
has been proved.

## 16. What exists now

### 16.1 Operating

- private Git synchronization and isolated worktrees;
- builder, breaker, auditor, and integrator collaboration;
- Git-versioned claim source records plus conventionally append-only event
  fragments with limited validators; transactional replay is not implemented;
- exact proof and certificate work in Cubical Agda and Lean;
- adversarial reviews, corrections, and provenance messages;
- deterministic read-only compilation of the research graph;
- content-addressed snapshots of existing source state;
- explicit privacy and release policy.

### 16.2 Proved or exactly checked in scoped models

- task-relative cache option value is not determined by scalar present cost;
- finite teaching sets are disagreement-hypergraph hitting sets;
- all-pairs binary separation is minimum test cover;
- old-language reducts cannot determine a new operation;
- observer response-square preservation is the satisfaction condition for
  atomic formulas once the required institution/signature typing is supplied;
- process-POVM refinement has the affine annihilator/span criterion;
- equality of tester statistics is a kernel quotient and can erase realization
  cost;
- levelwise digit reversal induces a checked equivalence of explicit inverse
  limits, while group structure and carry expose residuals;
- numerous domain-specific theorems, no-gos, and formal capabilities recorded
  elsewhere in the repository.

### 16.3 Specified but not generally implemented

- versioned presentation and equivalence-theory records;
- a general verified morphism/groupoid kernel;
- theorem transport across accepted paths;
- deterministic class snapshots at authority heads;
- recursive capability and budget delegation;
- dependency/reuse-based contribution attribution;
- equivalence-assisted evaluation caches.

### 16.4 Not built

- a native cryptocurrency or public chain;
- decentralized consensus or Sybil-resistant federation;
- autonomous theorem promotion;
- autonomous formation of mathematical languages or physical instruments;
- general cross-foundation proof translation;
- automatic scientific-value scalarization;
- end-to-end empirical evidence that the proposed allocation layer outperforms
  expert integration.

## 17. Minimal implementation path

1. **Preserve the operating research loop.** Do not replace working social and
   formal checks with a protocol simulation.
2. **Finish typed obligation/evidence edges.** Extend the read-only compiler
   without creating a second authority database.
3. **Implement one finite equivalence theory.** Require checked identities,
   inverses, composition, laws, coherence, acceptance, and revocation.
4. **Implement one theorem transport.** Replay the target proof through a
   pinned operator and ordinary checker.
5. **Add capability delegation locally.** Test scopes, budgets, expiry,
   revocation, and threshold circuit breakers without a token.
6. **Expose vector-valued allocation signals.** Show reverse dependency cuts,
   costs, debt, and option value without automatic control.
7. **Run preregistered policy comparisons.** Compare expert routing, fixed
   portfolios, and evidence-derived scheduling on live workloads.
8. **Add settlement only for a demonstrated need.** Choose an existing payment
   rail or narrowly typed token; never make it epistemic authority.
9. **Federate last.** Specify privacy, availability, finality, membership,
   verifier trust, and fork recovery before public replication.

Before making any decentralized-security claim, the implementation must also
specify principals and keys, admission and Sybil assumptions, rotation and
compromise recovery, authenticated checkpoints, rollback/equivocation
detection, fault thresholds, and explicit safety and liveness properties.

## 18. Evaluation

Any pilot reports a vector, not one headline score:

- false promotions and false equivalence merges;
- accepted results surviving independent replay;
- verified obligations discharged;
- certified theorem transports;
- compute and verification work saved;
- counterexamples and strategy classes retained;
- delayed and negative-result support;
- reviewer/evaluator concentration;
- privacy or authority violations;
- latency, compute, money, energy, and human attention;
- representation lock-in and rollback cost;
- diversity of surviving proof routes and presentations.

Baselines, workloads, policies, and stopping rules are preregistered. Allocation
gains cannot excuse semantic or privacy failures.

## 19. Conclusion

The protocol's durable machine-readable unit is not a coin. It is a typed,
content-addressed contribution situated in a graph of dependencies, proofs,
permissions, and possible future uses. This does not exhaust mathematical
coordination: oral and tacit knowledge, care and maintenance, anonymous or
collective work, and restricted knowledge may remain outside such records.
Cryptographic hashes, signatures, commitments, encryption, and consensus
protocols can support specific integrity, authentication, confidentiality, or
ordering properties under explicit security and fault assumptions; none is
implemented merely by content addressing. Formal methods can verify specified
witnesses and transports. Economic mechanisms can allocate scarce resources.
None alone determines mathematical truth or scientific value.

The network therefore keeps the rich object and treats currency as an optional
projection. It uses Rosetta entries to connect mature mathematical languages
and proposes checked morphism/transport records, append-only authority history,
and task-relative partial orders to preserve incomparable forms of value.
Selected artifacts instantiate pieces of this design; the general engine is
unbuilt. The intended result is not money for mathematics. It is
mathematics whose exact relations, provenance, capabilities, and transformations
remain alive enough to coordinate their own further development.

## References and repository basis

Established external foundations used by the repository include content-
addressed programming (Unison), OMDoc/MMT theory graphs and Math-in-the-Middle,
institutions (Goguen and Burstall), univalence and the Structure Identity
Principle, capability-based security, event sourcing and Merkle DAGs,
multiobjective optimization and resource theories, teaching dimension and
minimum test cover, Blackwell comparison of statistical experiments, process
POVMs/quantum testers, and quotient operator systems. Exact source pins and
scope boundaries are recorded in the repository notes cited below.

Primary repository basis:

- `RESEARCH_SYSTEM.md`
- `CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md`
- `NATURAL_RUNTIME.md`
- `ROSETTA_ENGINE.md`
- `FORMAL_CAPABILITY_GRAPH.md`
- `TORUS_CONTROL_PLANE.md`
- `CACHE_OPTION_VALUE_NO_GO.md`
- `CRITICAL_CHAIN_OPTION_VALUE.md`
- `MINIMAL_SIGNAL_FOR_A_FINITE_LANGUAGE_EXTENSION.md`
- `FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md`
- `OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md`
- `QUANTUM_COMB_MEMORY_ROSETTA.md`
- `QUANTUM_TESTER_FORMATION_BOUNDARY.md`
- `TESTER_OPERATIONAL_QUOTIENT.md`
- `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`
- `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md`
- `WHITEPAPER_INDIAN_AUTHORITY_PROPERTY_AUDIT.md`
- `NON_SCALAR_KNOWLEDGE_CAPABILITY_SYSTEM.md`
- `PROTOCOL.md`
