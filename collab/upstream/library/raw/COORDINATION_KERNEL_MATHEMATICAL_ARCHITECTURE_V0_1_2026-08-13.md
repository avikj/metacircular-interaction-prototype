# Coordination Kernel v0.1
## Mathematical architecture for certified open computation

**Date:** 2026-08-13
**Status:** mathematical design artifact for a technology. Standard ingredients are not claimed novel. The synthesis is a candidate formal architecture: primitives, invariants, composition laws, obstruction structure, information boundaries, and coordination geometry.


## Epistemic framing

This document is **not** a conventional software engineering specification. Its primary object is a mathematical design space.

The code-shaped schemas, APIs, and repository sketches are boundary witnesses: they test whether the abstractions can descend into realizable systems without contradiction. They are subordinate to the deeper program.

The actual research questions are:

- what is the correct primitive object for open computation;
- what data are semantic and what data are merely provenance;
- which global structures reconstruct from local interfaces;
- where local compatibility fails to glue;
- which couplings force information transfer, ordering, or shared adjudication;
- what quotient gives the minimal sufficient public interface;
- what invariants survive composition and coarse-graining;
- what obstruction classes certify impossibility;
- how proof, capability, value, information, and causal structure coexist in one compositional theory.

The technology is therefore being designed mathematically before it is being engineered operationally.

## 0. Deliverable

This develops the Coordination Internet research program into a mathematical kernel: a proposed ontology and compositional theory for open certified computation.

Persistent primitives are **Type, Relation, Artifact, Invocation, Claim, Capability, ResourceDomain**. Execution itself is deliberately not a consensus primitive. A solver may be a human, agent swarm, theorem prover, GPU job, market, or unknown future system. What enters the network is a portable boundary claim.

The kernel enforces five separations: extensional semantics vs provenance; causal dependence vs arbitrary temporal order; verification vs search; hard feasibility/capability vs incentives; global composition vs local conflict settlement.

The intended invariant is: **coordinate exactly where composition creates a real coupling**.

A technological realization would succeed if two mutually untrusted agents can publish a typed task, independently branch into subtasks, produce proof-carrying artifacts, merge them without a global sequencer, privately retain irrelevant state, locally settle a genuinely scarce capability, and let a third agent verify/reuse the result without trusting either solver or replaying search histories.

# 1. Typed boundary universe

Let T be canonical type identifiers. A type A contains a schema, canonical representation procedure, and decoder. For a valid value x:A,

    vid(x) = H("value" || A || canon_A(x)).

The type identifier is inside the hash: identical bytes under different semantic schemas are not the same value. A boundary is a finite typed tuple A1 x ... x Am; the empty boundary is the unit.

Canonicalization is not universally required. Where semantic equality is expensive or undecidable, the kernel exposes representation identity and permits later certified equivalence claims. This prevents program equivalence from becoming a prerequisite for networking.

**Invariant T1 — hash stability.** If canonical semantic equality is claimed, x =_A y implies vid(x)=vid(y). Unequal canonical representations share an ID only by hash collision.

**Invariant T2 — immutable interpretation.** A type ID commits to decoding/canonicalization semantics. Updating a schema creates a new type and an explicit migration relation; it never silently changes old artifact meaning.

# 2. Relation: the contract primitive

A relation R:A->B denotes an admissible subset [[R]] of [[A]] x [[B]]. Its descriptor is

    R = (A, B, V_R, C_R, K_R, D_R, M_R)

where V_R names accepted certificate systems, C_R capability requirements, K_R resource effects/conflict domains, D_R disclosure constraints, and M_R optional mechanism metadata.

A certificate system v exposes V_v(a,b,pi) in {0,1}. Soundness is non-negotiable:

    V_v(a,b,pi)=1  =>  R(a,b).

Completeness may differ by certificate system. A relation can accept a native checker, Lean proof, SNARK, STARK, signature threshold, probabilistic certificate, or adjudicated claim without pretending those evidence models are equivalent.

The representation ID

    rid(R)=H("relation" || A || B || V_R || C_R || K_R || D_R || M_R)

commits to the contract representation. Mathematical extensional equality is a separate proposition EquivalentRelation(R,S,pi).

**Engineering rule:** relation addressing names what must be realized, not who runs it.

# 3. Artifact: semantic identity and provenance identity

An artifact contains typed payload commitment, dependency references, invocation reference, and optional producer/metadata commitments.

Semantic identity:

    sid(A)=H("semantic" || type(A) || canonicalPayload(A)).

Provenance identity:

    pid(A)=H("provenance" || type(A) || payloadCommitment(A)
             || deps(A) || iid(A) || producer? || metadata?).

Two independently discovered results can have sid(A)=sid(B) while pid(A)!=pid(B).

This is required for simultaneously doing deduplication and attribution. A system with only pid cannot recognize extensional reuse; a system with only sid erases independent derivation.

Dependencies are canonicalized as a typed set or typed ordered tuple according to the relation. If argument position matters, order is committed; if dependencies are mathematically a set, arbitrary insertion order must not leak into identity.

# 4. Invocation and independent proof obligations

An invocation is

    J=(R, inputs, outputs, certificates, capabilities, resourceDelta, provenance).

Acceptance factors:

    Accept(J) =
      SemValid(J)
      AND CapValid(J)
      AND ResourceValid(J)
      AND DependencyValid(J).

These predicates remain separately inspectable. A mathematically correct output may be unauthorized. An authorized transition may double-spend. A conserved transition may prove the wrong theorem. Collapsing them into one opaque transaction-valid bit destroys compositional structure.

The invocation ID commits to the complete boundary event. Search history is not part of semantic acceptance unless the relation explicitly requires it.

# 5. Claim DAG

A Claim is an immutable proposition:

    Claim = (predicateId, subjects, evidence, dependencies).

Core predicates include ValidInvocation, EquivalentArtifact, RefinesRelation, Authorized, Conserves, EntitledToPayment, Supersedes, and Refutes.

Claims never mutate prior claims. Correction is an appended object referencing the corrected object. Durable epistemic state is therefore a DAG, while "currently accepted truth" is a view function over that DAG parameterized by verifier/trust policy.

Two communities can disagree about an adjudicated claim while sharing the same immutable mathematical/provenance substrate.

A deterministic verifier result is cacheable when its claim ID commits to verifier version, statement, proof, and dependency IDs.

# 6. Composition law

For R:A->B and S:B->C,

    (S o R)(a,c) iff exists b: R(a,b) AND S(b,c).

If certificates establish R(a,b) and S(b,c), b witnesses the composite.

**Proposition K1 — local proof composition.** Sound local certificates for a shared intermediate establish the composite relation.

Proof. The accepted intermediate witnesses the existential in relational composition. QED.

The composite may expose local certificates directly or replace them with recursively aggregated/succinct evidence. Proof aggregation is an optimization layer, not a semantic change.

Parallel composition is componentwise conjunction. When branches share no noncommuting state, capability, resource, or required information edge, their relative execution order is absent from semantics.

# 7. Causal DAG instead of ledger time

The provenance graph induces precedence x<y iff a dependency path x->...->y exists.

Each invocation also declares conflict keys K(J): an unspent capability, unique namespace cell, mutable object version, auction instance, exclusive lease, or governance choice.

Two invocations require a conflict mechanism only if they touch a common key and cannot prove commutation.

**Proposition K2 — local serialization theorem.** Assume every noncommuting pair shares a conflict key; each conflict-key domain supplies a consistent local order; and disjoint-key incomparable events commute. Then every global linearization respecting dependency edges and local conflict orders has the same extensional result.

Proof. Any two linear extensions are connected by swaps of adjacent incomparable events. An unordered adjacent pair cannot be a noncommuting shared-key pair, so it commutes. Each swap preserves semantics. QED.

Concrete replacement for one blockchain ordering everything:

    Merkle dependency DAG + consensus only per actual conflict domain.

An antichain remains an antichain.

# 8. Resource and capability kernel

A fungible resource lives in an abelian group or commutative monoid Q. Invocation J publishes boundary delta Delta_J. For a closed certified region,

    sum_J Delta_J = 0.

Nonfungible rights use capabilities. A capability kappa is an unforgeable typed reference specifying relation pattern, resource scope, attenuation/delegation policy, and optional identity/expiry conditions.

Delegation is a relation Delegate(kappa,kappa',pi) whose verifier proves

    Rights(kappa') subset Rights(kappa).

A spend consumes an input capability lineage and emits output capabilities according to a resource equation. The consumed capability PID is automatically a conflict key. Hence the contention domain of an asset is its own lineage, not the network.

Bearer capabilities are first-class. Civil identity is introduced only when the relation needs it.

# 9. Disclosure contract and minimal public semantics

Let hidden state be X, receiver side information Y, required target C, transcript M. Exactness requires H(C|Y,M)=0. The ideal leakage objective is

    minimize I(X;M | Y,C).

When target-only disclosure is perfect,

    I(X;M | Y)=H(C|Y).

For external task family F={f_alpha}, define x~x' iff every f_alpha agrees. The quotient Q_F=X/~ is the minimal deterministic public API.

**Proposition K3 — API minimality.** Every deterministic exact interface T supporting all tasks refines Q_F.

Proof. Equal T-values imply equal outputs for every task computed from T, hence equal task-equivalence class. QED.

Practical API design is therefore: enumerate permitted downstream tasks; identify observational equivalence; expose quotient; commit to hidden provenance; refine later explicitly if the task family expands.

# 10. Dynamic semantic identity

Static equality is insufficient for processes. Two states can expose the same current output and react differently to future calls.

For allowed context family C, define contextual equivalence:

    p ==_C q iff Obs(context[p]) = Obs(context[q]) for every allowed context.

The correct process semantic identity is the quotient by allowed contextual observations, not raw memory and not merely current output.

Capabilities alter this quotient: restricting interactions an observer may perform can coarsen contextual semantics. Information hiding is therefore partly cryptographic and partly capability-theoretic.

For deterministic finite protocols this specializes to Myhill-Nerode minimization. A production kernel should initially permit domain-specific EquivalentProcess claims rather than attempting universal program equivalence.

# 11. Conflict discovery as proof-driven scalability

A relation exposes an effect signature:

    Eff(R)=(reads,writes,consumes,produces,reveals).

A conservative independence test marks invocations independent if write/consume sets are disjoint from the other's read/write/consume sets and no declared higher-order invariant couples outputs.

This is sufficient, not necessary. A stronger certificate may prove

    Commutes(J1,J2,pi)

meaning T_J1 o T_J2 = T_J2 o T_J1 on the declared shared state domain.

The system can start conservatively serialized where effects overlap. Agents can then publish reusable commutation theorems that remove synchronization forever.

**Proof itself becomes a scalability primitive.**


# 12. Endogenous task decomposition

A task is itself an artifact containing relation R, input artifacts, certificate policy, constraints, and optional bounty.

A solver may publish child tasks R1,...,Rk plus a decomposition relation D such that certified child solutions and D imply a parent solution:

    AND_i R_i(a_i,b_i) AND D(b_1,...,b_k,b) => R(a,b).

The parent author does not predict the decomposition. Any solver can invent one. Decomposition itself is knowledge work and becomes reusable.

This is not a workflow DAG. A workflow DAG is prescribed before execution. Here the DAG is discovered by search and becomes durable provenance afterward.

A failed parent attempt may still leave valuable child artifacts. This is essential for mathematics: a lemma can be useful even when the conjecture that motivated it dies.

# 13. Bounties and settlement

A bounty is capability-backed escrow:

    B=(relationInstance, acceptPolicy, rewardRule, budgetCapability).

Settlement consumes bounty capability, accepted claims, and possibly a provenance DAG slice, then produces payment capabilities.

The mechanism is swappable without changing mathematical result semantics.

For a terminal success bounty B, risk-neutral solver i with success probability p_i, intrinsic value s_i, and expected cost c_i enters iff

    B*p_i + s_i >= c_i.

Open publication therefore decentralizes production-method selection without the network knowing private solver technologies.

First-valid-witness payment is intentionally not universal. It ignores reusable intermediate work and induces races. Initial kernel mechanisms should be only:
1. first-valid terminal bounty;
2. fixed split declared by author;
3. recursive budget-conserving child bounties.

Information/Shapley/provenance markets remain experimental because exact attribution and coalition stability are different objectives.

# 14. Semantic routing

A task request addresses a relation instance, not a host.

A solver advertisement contains relation patterns, capabilities, certificate systems, price model, latency model, privacy domain, and signed performance claims.

Routing is constrained matching:
- relation/type unification;
- capability compatibility;
- disclosure compatibility;
- accepted certificate output;
- budget/latency objective.

No global solver registry is mathematically necessary. Advertisements can be discovered by DHT, gossip, federated indexes, marketplaces, or local policy. Routing semantics are independent of discovery transport.

A router may recursively choose:
- local execution;
- known provider;
- open bounty;
- decomposition into child relations;
- specialized proof network;
- private MPC;
- local scarce-resource consensus.

This is "relation addressing": location-independent identity generalized from nouns to admissible transformations.

# 15. Wire format v0

The following is deliberately boring. It is the point where the mathematics becomes code.

```text
TypeDescriptor {
  version
  type_id
  schema_commitment
  canonicalizer_commitment?
  decoder_commitment?
}

RelationDescriptor {
  version
  relation_id
  input_types[]
  output_types[]
  verifier_specs[]
  capability_predicate
  effect_signature
  resource_schema
  disclosure_policy
  mechanism_metadata?
}

Artifact {
  version
  type_id
  payload | payload_commitment
  semantic_id?
  provenance_id
  dependencies[]
  invocation_id?
  producer_key?
  metadata_commitment?
}

Invocation {
  version
  relation_id
  inputs[]
  outputs[]
  certificate_bundle[]
  capability_evidence[]
  resource_delta[]
  dependency_roots[]
  conflict_keys[]
}

Claim {
  version
  predicate_id
  subjects[]
  evidence[]
  dependencies[]
  issuer?
}

Task {
  version
  relation_id
  inputs[]
  accepted_certificate_systems[]
  disclosure_constraints
  capability_constraints
  deadline?
  bounty_ref?
}
```

Every structure has a canonical encoding before hashing. Unknown extension fields must be either committed but ignored according to version semantics or rejected; silently reinterpreting them is forbidden.

# 16. Verification API

Minimal verifier API:

```text
verifyType(value, typeDescriptor) -> VerificationResult
verifyRelationInvocation(invocation, relationDescriptor) -> VerificationResult
verifyCapability(invocation, capabilityEvidence) -> VerificationResult
verifyResources(invocation, resourceContext) -> VerificationResult
verifyClaim(claim) -> VerificationResult
```

A `VerificationResult` contains:
- accepted boolean;
- verifier identity/version;
- dependency claim IDs;
- public outputs;
- optional privacy/security metadata;
- deterministic cache key.

The runtime must allow partial verification. A node can say "semantic proof valid; resource proof unknown" rather than forcing one global boolean.

This lets specialized verifiers compose.

# 17. Local state modules

The global substrate is append-only, but some relations need mutable scarce state. These are isolated as **StateModules**.

A StateModule exposes:

    StateModule {
      state_type
      transition_relation
      conflict_key_derivation
      finality_rule
      proof_rule
    }

Examples:
- UTXO/capability spend set;
- unique-name registry;
- auction;
- lease;
- rate-limited quota;
- governance decision;
- bridge escrow.

A module may internally use a blockchain, BFT committee, single trusted server, CRDT, hardware enclave, or legal custodian. The kernel does not universalize its mechanism. It requires only portable boundary claims.

This is the architectural inversion: blockchain becomes one implementation of a local state module, not the substrate ontology.

# 18. CRDT / monotone state fast path

Some shared states have join-semilattice structure. Let state L have join operation `vee`. If updates are inflationary and merge by join, replicas can converge without ordering concurrent updates.

The kernel can declare:

    MergeMode = JoinSemilattice(joinVerifier)

and omit conflict ordering for join-compatible updates.

Hard invariants must be join-closed. If invariant P is not preserved under joining independently valid states, the CRDT fast path is unsound for that invariant and a stronger coordination module is required.

This gives a compile-time question:

    Is the invariant join-closed?

If yes, coordination-free merge is available.
If no, find the minimal conflict/resource summary that restores safety.

# 19. Open-system gluing

A process can be modeled structurally as an open system with typed boundary. Composition identifies shared boundary through a pushout-like structural gluing, while compatible state assignments form pullback-like constraints over the shared interface.

The engineering translation is simple:

- structural composition merges shared artifact/type/capability references;
- state composition checks equality/compatibility of their exposed interface values;
- hidden interiors remain separate unless the relation explicitly joins them.

A process descriptor should therefore distinguish:
1. boundary carrier identity;
2. boundary value;
3. interior provenance.

This avoids a common bug: treating "these two components refer to the same interface object" and "these two current interface values are compatible" as the same proposition.

# 20. Sheaf-style local-to-global validation

For a large composite task, local verifiers operate on regions. Regions overlap on shared artifacts/interfaces.

Let each region i produce local section s_i. Pairwise compatibility requires equal restriction on overlaps. Three outcomes exist for the restriction map from global realizations to local observations:

- empty fiber: local data do not globally realize — obstruction;
- singleton fiber: exact reconstruction;
- larger fiber: hidden global implementation freedom.

The runtime can expose this explicitly as a `GluingClaim`.

```text
GluingClaim {
  cover_regions[]
  local_claims[]
  overlap_claims[]
  global_artifact?
  obstruction_certificate?
  ambiguity_descriptor?
}
```

This is useful immediately for distributed theorem proving. Multiple agents prove local lemmas. A merge agent must not merely check that every lemma is valid; it checks that assumptions, definitions, universes, versions, and shared objects agree on overlaps.

# 21. Cohomological obstruction hook

The kernel does not need cohomology to run. But it should make obstruction objects first-class because some local-to-global failures are not "one bad local proof."

For additive overlap data, a cocycle may be locally closed yet not globally exact. A nonzero cohomology class is a canonical obstruction invariant under local gauge/representation changes.

Engineering interface:

```text
ObstructionClaim {
  complex_or_cover_id
  degree
  coefficient_type
  cocycle_commitment
  class_certificate
  vanishing: bool
}
```

A vanishing certificate may permit global gluing. A nonvanishing certificate is a reusable impossibility result that prunes search.

This is directly relevant to the Prime-Pair finite-place testbed: if scale-truncated local arithmetic observations are organized as a presheaf, the missing factorization/parity charge can be tested as an actual lifting/gluing defect rather than spoken about metaphorically.

# 22. Research-agent deployment: first real application

The first application should be our own mathematical agent swarm.

A `MathStatement` type contains formal or semi-formal statement, ambient theory/environment, assumptions, and normalization.

A relation `Prove` is:

    Prove : MathStatement -> ProofArtifact

with accepted verifiers such as Lean kernel, Agda kernel, executable finite checker, or a human-review status relation for informal arguments.

A relation `Refute` outputs a counterexample artifact plus checker.

A relation `Strengthen` maps theorem to stronger theorem with proof and implication certificate.

A relation `Equivalent` proves two formulations equivalent.

A relation `Compute` maps a finite experiment specification to reproducible result plus code/environment hash.

A relation `LiteratureMatch` maps claim to prior-art evidence; unlike proof relations, this is evidential and source-sensitive.

Every agent output becomes one of these typed artifacts rather than prose dumped into a chat log.

# 23. Mathematical research DAG

For a target conjecture C, the live research state is a graph whose nodes are:
- definitions;
- lemmas;
- conjectures;
- counterexamples;
- computations;
- equivalences;
- literature matches;
- obstruction results;
- decomposition tasks.

Edges are typed:
- `depends_on`;
- `proves`;
- `refutes`;
- `generalizes`;
- `specializes`;
- `equivalent_to`;
- `computed_by`;
- `motivated_by` (nonlogical provenance);
- `supersedes`.

Logical dependency and motivational provenance must not be the same edge type.

An agent can safely reuse a theorem only through logical/certificate edges. Motivational links remain useful for attribution/search but cannot satisfy proof obligations.

# 24. Example: a theorem bounty

Suppose task T asks for a proof of finite theorem C with a Lean statement hash.

Task artifact:
- relation: `LeanProve`;
- input: theorem statement artifact;
- accepted verifier: Lean kernel version K;
- disclosure: proof term public;
- bounty: 1000 units;
- deadline: none.

Agent A decomposes C into lemmas L1,L2 and publishes child tasks. Agent B proves L1. Agent C proves L2. Agent D notices L2 is already semantically equivalent to a library theorem and publishes an equivalence certificate rather than a new proof. Agent A constructs C proof.

The final proof PID depends on the exact derivation; SID may identify the same theorem/proof-normal-form semantics as another derivation. Settlement can pay the terminal solver only, or use declared child bounties. No global order is needed among B and C. Only a bounty spend capability needs conflict settlement if multiple terminal proofs race to claim a first-winner bounty.

This is already a nontrivial end-to-end demonstration of the architecture.


# 25. Example: private solver with public proof

Task relation R asks for y satisfying a predicate over private input x. The solver commits to x and emits y plus zero-knowledge proof pi that R(x,y) holds and that x matches the commitment.

The public artifact need contain only:
- commitment to x;
- y;
- proof pi;
- relation ID;
- dependency commitments.

The network need not receive x or solver memory.

If the proof is zero knowledge in the relevant model, the observer's transcript can reveal essentially the truth of the predicate/output without the witness. This is the exact architecture for "large private computation, tiny public semantics."

The solver may use arbitrary compute, including proprietary models. Verification cost is decoupled from search cost.

# 26. Example: two independent branches and one scarce resource

Task P splits into branches A and B. They share no data and commute. A later merge M consumes both results. Separately, each branch may buy GPU time using different payment capabilities.

Dependency order:
A -> M
B -> M

There is no A/B order.

If both attempt to consume the same one-use capability kappa, that spend lineage becomes a local conflict domain. Only those spend events need ordering/selection. The mathematical computations A and B remain causally incomparable.

This is the smallest demonstration of the principle:

    shared scarce right => local consensus
    shared proof dependency => causal edge
    mere coexistence => nothing.

# 27. Example: semantic dedup with provenance retention

Two agents independently prove theorem T.

Artifact A:
    sid = H(canonical theorem/proof semantics)
    pid = H(derivation A)

Artifact B:
    same sid
    different pid.

A theorem index stores one semantic node with two provenance realizations. Downstream proof search can avoid re-solving T, while attribution can credit both independent discoveries according to policy.

If canonical proof semantics is unavailable, both retain distinct representation SIDs until an `EquivalentArtifact(A,B)` certificate is added. Equivalence is therefore incremental rather than magical.

# 28. Example: relation refinement

Let R mean "output is a valid numerical solution within error 1e-3." Let S mean "within error 1e-6."

A refinement certificate proves

    S subset R.

Any S-artifact can therefore satisfy a consumer requiring R without rerunning computation.

The type checker/routing layer should exploit refinement automatically. A solver advertising S can serve R requests. A task requiring S cannot accept an R-only result.

This turns mathematical implication into network substitutability.

# 29. Example: safe agent action fiber

An agent operates in state x. A safety relation exposes maximal certified action set A*(x). The planner may optimize arbitrary utility inside A*(x).

The verifier does not prescribe a policy. It only rejects actions outside the certified safe fiber.

This gives a clean architecture for agent systems:
- safety kernel defines admissible relation;
- planner/model searches inside relation;
- proof/certificate establishes membership;
- preference/reward chooses among safe outputs.

Where exact maximal safety is unavailable, relation explicitly records the conservative approximation used. This makes safety incompleteness visible rather than hidden in system prompts.

# 30. Prime-Pair integration as a test case

The Prime-Pair project is a mathematically useful stress test because it already has:
- compressed observable maps;
- ambiguity fibers;
- finite local prime data;
- a residual factorization-charge/parity question;
- explicit local annihilation phenomena;
- reconstruction/obstruction targets.

Define an arithmetic experiment artifact:

```text
ArithmeticObservableExperiment {
  domain
  scale
  prime_set
  observable_family
  target_charge
  distribution
}
```

Relations:
- `ComputeFiber`: observable value -> exact finite ambiguity fiber;
- `MinimalSupplement`: observable family -> minimum extra statistic restoring target;
- `ObstructionClass`: local compatible data -> certified obstruction/vanishing;
- `ConditionalInformation`: experiment -> exact/rational mutual-information value where finite;
- `ScaleMap`: experiment at z -> experiment at z';
- `StableCharge`: family of scale maps -> surviving charge certificate.

The finite parity theorem becomes executable: visible valuations V_S plus one tail Liouville bit recover total Liouville charge, while V_S alone does not.

The sheaf/cohomology branch becomes falsifiable:
construct a concrete finite cover/presheaf from prime-local observables; compute restriction maps; enumerate compatible families; calculate gluing fibers; then calculate H^1 or the appropriate relative obstruction. If the missing parity bit is merely an ordinary two-element fiber with no nontrivial cohomological class, the cohomology story is killed at that model. If a canonical nonzero class appears and behaves functorially under scale refinement, the branch survives.

This is exactly how the Coordination Kernel should improve mathematics: it turns vague analogies into typed relations with killable outputs.

# 31. One possible realization architecture

A prototype can be six services/libraries, though they can run in one process initially.

**CAS / object store.** Immutable blobs keyed by cryptographic digest.

**Descriptor registry.** Type and relation descriptors, also content-addressed. Registry is a discovery cache, not source of identity.

**Verifier runtime.** Sandboxed adapters for deterministic verifiers. Inputs are immutable refs. Output is a signed/cacheable VerificationResult.

**DAG index.** Indexes dependency/provenance/claim edges. Reconstructible from objects; not consensus-critical if objects are available.

**Conflict modules.** Pluggable state modules keyed by conflict domain. First prototype can use a single SQL transaction/compare-and-swap service while preserving the API that later permits BFT/UTXO/etc.

**Router/market.** Finds solver advertisements or publishes bounties. Entirely optional for local execution.

The first implementation should not build a token, blockchain, custom VM, universal proof system, or global P2P network. Those would optimize the wrong layer before semantics are proven.

# 32. Core interfaces in pseudocode

```ts
type Hash = string;
type TypeId = Hash;
type RelationId = Hash;
type ArtifactId = Hash;
type ClaimId = Hash;
type ConflictKey = Hash;

interface ArtifactRef {
  semanticId?: Hash;
  provenanceId: Hash;
  typeId: TypeId;
}

interface RelationDescriptor {
  id: RelationId;
  inputs: TypeId[];
  outputs: TypeId[];
  verifiers: VerifierSpec[];
  effects: EffectSignature;
  capabilityPredicate?: Hash;
  resourceSchema?: Hash;
  disclosurePolicy?: Hash;
}

interface Invocation {
  relation: RelationId;
  inputs: ArtifactRef[];
  outputs: ArtifactRef[];
  certificates: CertificateRef[];
  capabilities: ArtifactRef[];
  resourceDelta: ResourceDelta[];
  conflictKeys: ConflictKey[];
  dependencies: Hash[];
}

interface VerificationResult {
  accepted: boolean;
  predicate: Hash;
  subjects: Hash[];
  verifier: Hash;
  dependencies: ClaimId[];
  publicOutput?: Uint8Array;
}

interface Claim {
  id: ClaimId;
  predicate: Hash;
  subjects: Hash[];
  evidence: Hash[];
  dependencies: ClaimId[];
}
```

No `globalSequenceNumber`. No `blockHeight`. No mandatory `owner`. No mandatory `token`.

# 33. Kernel state transition

The append-only kernel operation is:

    publish(object) -> objectId

followed by optional:

    verify(objectId, verifierPolicy) -> ClaimId

and for scarce state only:

    settle(conflictDomain, invocation, evidence) -> SettlementClaim.

Everything else is derived indexing.

An artifact is usable when the consumer's policy can derive the required predicates from claims and accepted verifiers.

Thus "state" is observer-relative in a precise systems sense: the immutable object graph is shared evidence; acceptance view is a policy-dependent projection.

# 34. Security boundary

The trusted computing base for a deterministic proof-carrying relation is:
- canonical parser/decoder for involved types;
- hash implementation;
- verifier implementation/version;
- capability/resource verifier for required effects;
- policy selecting acceptable verifier IDs.

The solver, router, index, market, and provenance producer need not be trusted for semantic correctness.

Availability is separate. A malicious object store can withhold dependencies. Replication/erasure coding addresses availability without changing semantic validity.

Privacy is separate. A valid public proof may leak too much unless disclosure policy/proof system controls the observer view.

Specification adequacy is separate. A perfectly sound verifier for a bad relation proves the wrong thing perfectly.

# 35. Threat model table

**False result:** blocked by sound semantic verifier.

**Malformed type confusion:** blocked by typed canonical decoding and type-bound hashes.

**Dependency substitution:** blocked by content-addressed dependency commitments.

**Double spend:** blocked by local conflict module on capability lineage.

**Global replay:** invocation identity plus state-module spend semantics; harmless for pure immutable computations.

**Sybil solver identities:** semantic validity unaffected; reward mechanisms must avoid per-identity subsidies unless identity uniqueness is intentional.

**Provenance spam:** not solved by hashing; indexing/reward policies need semantic dedup and cost/reputation mechanisms.

**Verifier compromise:** catastrophic for relations trusting that verifier; mitigated by versioned verifier IDs, multiple certificate systems, proof replication, formal verification where feasible.

**Bad specification:** not cryptographically solvable; relation refinement, audits, adversarial tests, and governance.

**Privacy leakage:** controlled by disclosure policy and proof protocol; provenance may itself be sensitive and can be committed/encrypted rather than public.

**Deadlock across multiple scarce modules:** possible. Requires explicit transaction/composition protocol or avoidance; the kernel does not pretend local consensus automatically solves distributed atomicity.

# 36. Atomicity across conflict domains

Suppose one invocation must atomically consume capabilities from two independent state modules A and B. Local ordering alone is insufficient if partial settlement is unacceptable.

This is a genuine coupling. The kernel must expose it, not hide it.

Options are relation-specific:
- escrow/prepare-commit protocol;
- hash/time-locked conditional capabilities;
- one module delegated temporary authority over the composite;
- a higher-level joint conflict domain;
- compensating transaction if semantics permits.

The important theorem-level engineering rule is:

    if validity is not product-closed across modules, composition creates a new conflict hyperedge.

This is where global-ish coordination legitimately reappears, but only over the participating domains.

# 37. Conflict hypergraph

Pairwise keys are not universal. Define a conflict hypergraph H whose vertices are invocations/resources and hyperedges represent minimal jointly incompatible sets.

Example: capacity K=2 can allow each pair of three unit claims while forbidding all three together. No pairwise conflict edge captures the minimal obstruction.

A ResourceDomain therefore may expose:
- scalar capacity constraint;
- matroid independence oracle;
- matching constraint;
- linear conservation law;
- arbitrary certified feasibility relation.

This is a major improvement over "locks." The general primitive is a verifiable feasibility relation over a set of claims.

For matroid feasibility, greedy local augmentation is globally optimal for weights. For matching, augmenting paths certify improvability. The kernel can exploit domain structure without baking it into the universal layer.

# 38. Coordination compiler

A useful compiler can consume relation descriptors and produce a conservative coordination plan.

Input:
- effect signatures;
- resource domains;
- information dependencies;
- capability requirements;
- verifier dependencies;
- declared commutation/refinement claims.

Output:
- causal dependency DAG;
- conflict hyperedges;
- parallelizable components;
- required information channels;
- verifier schedule;
- settlement modules;
- privacy boundaries.

Pseudo-algorithm:

```text
for each invocation pair:
    add causal edge for explicit data dependency
    if effects provably commute:
        no order edge
    else if shared resource/feasibility domain:
        attach both to that domain
    else if overlap uncertain:
        conservatively create conflict obligation

for each consumer target:
    compute required exposed task quotient / declared interface
    reject undeclared leakage if disclosure policy forbids it

topologically schedule dependency DAG
run incomparable components in parallel
invoke state modules only for their incident conflicts
```

The compiler's conservative conflicts can later be removed by proof.

# 39. Coordination cost vector

Do not collapse cost to one "gas" scalar.

For protocol P expose at least:

    K(P) = (work, causalDepth, communication,
            targetInformation, leakage,
            verificationWork, scarceContention,
            monetaryTransfer).

Sequential and parallel composition use different operations by coordinate. Work adds in parallel; depth takes max. Information can be redundant or synergistic. Monetary transfers need not equal social value. Scarce contention is domain-specific.

Routing can scalarize this vector according to user policy, but the substrate retains the vector.

A universal gas number would destroy exactly the structure the project is trying to recover.

# 40. Proof-carrying optimization

Many useful relations are optimization problems. A solver can return primal object plus dual certificate.

For convex programs with strong duality, primal feasibility + dual feasibility + equal objective values certifies optimality.

For bipartite matching, a matching plus feasible vertex prices with equal primal/dual value certifies maximum weight.

For shortest paths, distance potentials can certify no shorter path under appropriate inequalities.

Therefore the relation library should include certificate schemas that expose mathematical duality rather than replaying search.

This is a direct engineering principle:

    whenever search is expensive, look for a dual witness whose verification is local.

# 41. Reusable impossibility artifacts

A `Refutation` or `Obstruction` artifact is not failure garbage.

If theorem proves no candidate in subset U can satisfy R, future search can quotient the domain to X\U without losing valid witnesses.

If a Hall deficiency proves a matching impossible, the deficient coalition is a compact obstruction certificate.

If a cohomology class proves local data cannot glue, that class is a reusable obstruction.

If an information cut proves at least k bits must cross an interface, architectures claiming less can be killed without implementation.

The research machine should route negative results as first-class artifacts because they reduce future search space.

# 42. Versioning and refinement

Nothing mutates semantically.

A new relation R2 can claim:
- `Refines(R2,R1)` meaning R2 subset R1;
- `Equivalent(R2,R1)`;
- `Migrates(type1,type2)`;
- `SupersedesPolicy(P2,P1)`.

Consumers state what they accept. A proof for a stronger relation can satisfy a weaker consumer through a verified refinement edge.

This makes backward compatibility mathematical rather than conventional.

# 43. Minimal trust and verifier plurality

A relation may accept multiple verifier roots. Consumer policy might require:
- any one accepted verifier;
- k-of-n independent verifiers;
- one formal kernel plus one runtime checker;
- proof system plus audit;
- hardware attestation plus semantic proof.

The kernel represents this as a Boolean/threshold relation over Claim IDs.

Verifier plurality is not global consensus. It is evidence composition for a particular predicate.

A verifier can itself be an artifact with source/build proof. Updating it creates a new ID. Cached old claims retain the old verifier reference forever.

# 44. Availability layer

Semantic identity is useless if artifacts disappear. Availability should be orthogonal.

An artifact can have availability claims:
- replicated at providers P1...Pk;
- erasure-coded with parameters (n,k);
- pinned until deadline;
- retrievable under payment/capability.

Erasure coding can reconstruct immutable data without ordering storage nodes. Authentication can convert corrupt shards into erasures, reducing redundancy requirements.

The availability market can therefore operate over content IDs without entering semantic proof logic.

# 45. Discovery and anti-spam

Content addressing prevents accidental duplication, not semantic spam.

Indexes should rank:
- verified downstream reuse;
- semantic uniqueness/equivalence classes;
- verifier strength;
- provenance reputation;
- cost;
- freshness where relevant;
- dependency centrality;
- refutation history.

None of these rankings belong in identity.

A malicious actor can generate infinitely many syntactically different artifacts. Semantic equivalence claims and economic costs help, but universal semantic canonicalization is impossible in general. The architecture must tolerate imperfect indexing rather than pretending hashing solves relevance.

# 46. Realization experiment 1: local single-machine kernel

Build no networking.

Implement:
- canonical CBOR or deterministic protobuf encoding;
- BLAKE3/SHA-256 IDs;
- SQLite/Postgres object/edge index;
- filesystem/CAS blobs;
- TypeDescriptor and RelationDescriptor;
- Artifact/Invocation/Claim;
- deterministic verifier adapter;
- semantic/provenance dual IDs;
- dependency DAG;
- conflict-key compare-and-swap module.

Demonstration: two subprocess solvers independently produce artifacts; verifier accepts; merge artifact composes them; unrelated invocations remain unordered; one local capability can be spent exactly once.

Success criterion is inspectable graph state proving there is no hidden global sequence dependency.

# 47. Realization experiment 2: mathematical agent swarm

Connect frontier coding/reasoning agents as untrusted solvers.

Every agent receives:
- task relation;
- typed dependencies;
- accepted verifier specs;
- budget/capability;
- allowed disclosure.

Every agent must return typed artifact(s), not free-form terminal chat.

A supervisor may still use prose internally, but persistence happens through relations:
`Prove`, `Refute`, `Compute`, `LiteratureMatch`, `Decompose`, `Equivalence`, `Obstruction`.

Run on one concrete finite Prime-Pair subproblem where verification is executable.

Measure:
- duplicate work avoided by SID/equivalence;
- proof cache reuse;
- parallel branch depth vs total work;
- number of global synchronization points;
- reusable artifacts surviving failed branches.

# 48. Realization experiment 3: open two-node execution

Run kernel on two machines under different administrative domains.

Node A publishes relation/task.
Node B discovers it, solves it, returns artifact/certificate.
Node C (or A) verifies from immutable dependencies.

No shared database is allowed for semantic correctness. The only shared primitives are content retrieval and portable descriptors/claims.

Then introduce one capability-spend state module and demonstrate that only that lineage requires settlement.

# 49. Realization experiment 4: privacy

Choose a relation with large private witness and small public predicate.

Implement commitment + zero-knowledge proof or a simpler cryptographic proof system suitable to the relation.

Record:
- public transcript bytes;
- target information;
- witness size;
- verifier time;
- prover time;
- disclosed metadata.

The point is not benchmark theater. It tests the central claim that semantic coordination can be much smaller than state replication.

# 50. Realization experiment 5: endogenous decomposition market

Publish a hard relation with bounty.
Allow agents to create child tasks and reserve portions of budget.
Require child-budget conservation.
Permit child artifacts to be reused by unrelated parent tasks.
Compare terminal-winner and recursive-child settlement.

The research question is whether useful decomposition emerges without a central workflow author.

This is the first point where mechanism design becomes experimentally substantive.

# 51. Concrete finite arithmetic experiment for milestone 2

Use a finite universe where every claim is exactly checkable. Fix integer range N, finite prime set S, and target charge lambda(n)=(-1)^Omega(n). Define visible observation O_S(n)=(v_p(n)) for p in S, or a deliberately coarser divisibility vector.

`Fiber` takes observation o and returns the exact set {n<=N: O_S(n)=o}. `ChargeAmbiguity` returns whether lambda is constant on the fiber. `MinimalChargeSupplement` searches a declared finite statistic family Z and returns the smallest statistic making lambda deterministic from (O_S,Z), with exhaustive truth table and minimality witnesses. `InformationProfile` computes exact finite distributions and H(lambda|O_S), H(lambda|O_S,Z), and I(lambda;Z|O_S).

This is an executable instance of minimal public semantics.

Then define overlapping local prime regions S_i. Each region publishes its observable section. Build the compatibility cover and enumerate global integer realizations. The gluing fiber can be empty, singleton, or multiple.

The cohomology branch gets one precise test: construct additive transition/cocycle data only where justified, compute finite cochain matrices, and ask whether a nonzero class tracks parity ambiguity. If not, emit a machine-checkable `NoBridgeAtModel` artifact. We stop protecting the analogy.

# 52. Coordination-RG experiment

Start with a fine process graph G whose nodes have semantic quotient, effect signature, conflict domains, information channels, and verifier obligations. Partition nodes into macro-components. For each block compute exposed task quotient, aggregate resource delta, external conflict keys, external information requirements, and composite certificate relation.

Internal edges disappear. Cross-block edges survive or combine.

Measure causal edge count, width, critical path, conflict-domain rank/count, cross-cut information lower bounds, verifier work, and hidden implementation entropy.

A coarse-graining is coordination-faithful for task family F when external F-behavior of G equals that of C(G), and every coarse behavior lifts to a fine behavior. This is a full-abstraction/bisimulation condition, not graph clustering.

A renormalization fixed point would be a family whose coarse coordination descriptor has the same form under repeated composition.

# 53. Coordination descriptor

For open process P define

    Coord(P) = (Sem, Causal, Info, Resource, Capability, Verify, Strategy).

Sem is contextual/relational boundary semantics. Causal is partial-order/event semantics. Info assigns observer-relative information requirements and leakage. Resource is conserved/feasibility relations. Capability is authorization. Verify is accepted proof relation. Strategy is optional utility/game semantics.

Composition is not one operation identically applied to every coordinate. Relations compose existentially; causal structures glue dependencies; information obeys chain rules with synergy/redundancy; resources add or intersect feasibility; capabilities attenuate; proofs conjoin/aggregate; utilities add only under independence.

This is evidence that one ordinary hom-set annotation may be too weak. The wire kernel can stay stable while the math decides whether the best abstraction is a double category, decorated cospan, operad, equipment, or something richer.

# 54. Kernel composition obligations

For P:A->B and Q:B->C, composition must discharge:
- type compatibility;
- actual boundary value compatibility;
- capability transfer/non-escalation;
- resource feasibility;
- disclosure compatibility;
- verifier trust/refinement compatibility.

Strategic compatibility is required only when claiming an equilibrium property for the composite. Functional correctness does not wait for game theory.

This is the engineering form of the recurring theorem: local correctness in one coordinate does not imply global correctness in another.

# 55. Restricted composition theorem to formalize

Define `IndependentCertifiedProcess` with deterministic typed boundary relation, sound-complete deterministic verifier, additive resource group, capability attenuation without shared mutable authority, no strategic cross-terms, explicit effects, and composition-closed disclosure policy.

Formalize:

**Kernel Composition Theorem.** Sequential and tensor composition preserve type safety, semantic validity, resource conservation, capability non-escalation, verifier soundness, and dependency acyclicity under a freshness condition. Tensor-composed processes with disjoint effect supports require no ordering relation.

This is small enough for Lean/Agda and strong enough to anchor the runtime.

# 56. Lean-shaped nucleus

```lean
structure CType where
  Carrier : Type
  canon : Carrier -> ByteArray

structure Rel (A B : CType) where
  holds : A.Carrier -> B.Carrier -> Prop

structure CertifiedRel (A B : CType) extends Rel A B where
  Cert : A.Carrier -> B.Carrier -> Type
  verify : (a : A.Carrier) -> (b : B.Carrier) -> Cert a b -> Bool
  sound : forall a b c, verify a b c = true -> holds a b

def Rel.comp (R : Rel A B) (S : Rel B C) : Rel A C :=
  { holds := fun a c => Exists fun b => R.holds a b ∧ S.holds b c }
```

Then prove associativity, identity, tensor interchange, and certificate composition.

Effects begin syntactically as finite read/write/consume sets; later semantic `Commutes` proofs can replace conservative overlap.

# 57. Runtime property tests

Generate random finite relations and check:
- composition associativity;
- tensor associativity/interchange;
- semantic projection ignores provenance;
- changing dependency changes PID;
- canonical equivalent payload preserves SID;
- disjoint-effect invocations commute in reference model;
- double-spend conflict admits at most one settlement;
- refinement substitutes into weaker relation;
- identical committed verifier input hits cache.

Generate malformed encodings and cross-type substitutions.

The harness should emit its own test artifacts and claims into the kernel.

# 58. Storage schema

A disposable index can contain objects(id,kind,bytes_location,created_at_local), edges(src,dst,edge_type), semantic_alias(semantic_id,provenance_id), claims, and conflict_membership.

`created_at_local` is index metadata, not consensus time, and never enters identity unless a relation explicitly requires timestamp semantics.

The authoritative object is the content-addressed blob. SQL is reconstructible indexing.

# 59. Network surface

The network needs only object get/put, relation query, solver advertisement, task publication, claim publication, invocation submission, and conflict-domain settlement. HTTP is enough initially.

Do not build transport novelty until semantic composition demonstrates value.

# 60. Bootstrap relation library

Ship Identity, SignatureValid, ArtifactEquals, RelationRefinement, CapabilityAttenuation, ResourceConservation, SchemaValid, CommandExecution, LeanProofValid, FiniteComputationValid, MerkleInclusion, BountySettlement, JoinMerge, and ConflictSettlement.

Anyone can publish new relations. Standardization only makes common composition cheap.

# 61. Refinement graph

Relations form a preorder under implication: S<=R iff S(a,b)=>R(a,b). Store certified refinement edges. A router may satisfy requested R using an S-certified artifact plus a trusted refinement path.

This is proof-carrying subtype coercion at network scale.

Cache transitive closure. An artifact can retain a minimal antichain of strongest known certificates rather than every implied weaker claim.

# 62. Proof-system refinement

Evidence systems also imply different predicates. A Lean proof can imply a mathematical theorem under a kernel trust assumption. A unit test implies only tested cases. A SNARK proves execution of verifier V. An attestation proves code identity, not truth.

Represent separate predicates and implication edges. Never collapse them to `verified=true`.

# 63. Observer-relative views

Given immutable graph G and policy P, define View_P(G) as closure of claims accepted by P under trusted implication/refinement rules.

Observers can share G but derive different views because they trust different verifier roots, hold different decryption capabilities, or permit different contexts.

Consensus is required only where the relation demands one shared external state.

# 64. Knowledge compounding metric

Let A_t be verified artifacts at time t. For target family T define marginal structural value

    V(a;A_t)=reachableTargets(A_t union {a})-reachableTargets(A_t).

Value is state-dependent and complementary. A bridge lemma can be useless alone and transformative after another lemma; an obstruction can be valuable by pruning huge search.

Schedulers should estimate target reachability, reuse, obstruction value, proof cost, and complementarity—not token output.

# 65. Agent spawning

Given target relation R and artifact graph K, candidate actions are solve directly, literature search, prove lemma, finite compute, counterexample search, equivalence bridge, formalize proof, improve verifier, decompose, or post bounty.

Every action names an expected relation-valued output.

Spawn in parallel when there is no causal prerequisite or scarce shared resource. Kill a branch when target is semantically solved, obstruction kills it, marginal value falls, duplicate SID appears, or prerequisite is refuted.

This is a concrete Darwin/Godel-machine substrate: proposal machinery mutates freely while durable acceptance remains proof-bounded.


# 66. From theorem corpus to compiler

The immediate mathematical target is no longer another list of coordination facts. It is a compiler theorem.

Given a finite composite specification, construct:
- a dependency partial order;
- a conflict hypergraph;
- required information interfaces;
- proof obligations;
- local settlement domains.

**Soundness target.** Every execution satisfying the generated obligations realizes the original composite relation.

**Minimality target.** Every obligation is either provably necessary for the declared semantics or removable with a proof of equivalence.

Conservative soundness is implementable now. Minimality is the frontier.

This makes the research output operational: compute where coordination is required.

# 67. Information-edge compiler

If consumer Q depends on producer hidden state X only through statistic T(X), the boundary should carry T or a proof about T, not X.

A `SufficientInterface(X,T,F,proof)` claim certifies every task in family F factors through T.

The compiler substitutes T for X across the boundary. For finite probabilistic models it can attach a lower-bound claim H(C|Y). For worst-case deterministic tasks it must use communication complexity instead of pretending Shannon entropy is a worst-case bound.

Distribution/model assumptions are content-addressed artifacts. Information claims reference them exactly.

# 68. Conflict hypergraph

Locks are too weak as a universal abstraction. Minimal incompatible sets can be higher-order: a capacity-two domain accepts every pair among three unit claims but rejects the triple.

A resource domain therefore exposes a feasibility relation over claim sets. Specialized domains may be:
- scalar capacity;
- matroid independence;
- matching;
- linear conservation;
- UTXO/capability lineage;
- arbitrary certified feasibility.

Pairwise conflict keys are merely a fast path.

# 69. Atomicity across domains

If one invocation must atomically consume capabilities from independent modules A and B, local settlement alone is insufficient when partial success is invalid.

Formal rule:

    if validity is not product-closed across modules,
    composition creates a new conflict hyperedge.

Possible implementations include escrow/prepare-commit, conditional capabilities, temporary delegated authority, a joint state module, or compensation when semantics permits.

This is genuine broader coordination, surfaced rather than hidden.

# 70. Coordination cost vector

Do not reduce everything to gas.

Expose at least

    K(P)=(work, causalDepth, communication,
          targetInformation, leakage, verificationWork,
          scarceContention, monetaryTransfer).

Parallel work adds while depth takes max. Information can be redundant or synergistic. Money is not social value. Contention is domain-specific.

Routing policy may scalarize K, but the substrate retains the vector.

# 71. Proof-carrying optimization

Whenever search is expensive, seek a dual witness.

Convex optimization: primal feasible + dual feasible + equal values.
Matching: matching + feasible vertex prices + equal objective.
Shortest path: path + feasible distance potentials.

The relation library should encode dual certificates rather than replaying search.

# 72. Impossibility artifacts

A proof that no candidate in U satisfies R lets future search remove U without losing a witness.

Hall deficiency, a nonzero obstruction class, a communication lower bound, or a concrete counterexample is durable knowledge.

Negative results should be first-class because they prune future search.

# 73. Verifier plurality

A consumer may require any-one verifier, k-of-n, formal-kernel-plus-runtime, proof-plus-audit, or attestation-plus-semantic-proof.

These are evidence policies for a predicate, not global consensus.

Verifier source/build can itself be content-addressed. Updating verifier creates a new ID; old claims permanently name the old verifier.

# 74. Availability is orthogonal

Artifacts can have replication, erasure-code, pinning, or paid-retrieval claims. Erasure coding reconstructs immutable data without temporal ordering of storage nodes.

Availability markets operate over content IDs without entering semantic proof logic.

# 75. Prototype build order

1. Canonical object formats, hashes, CAS, relation/artifact/invocation/claim.
2. Deterministic verifier adapter and proof cache.
3. Dependency DAG and conservative effect analysis.
4. Capability spend conflict module.
5. Mathematical relation library and agent adapters.
6. Finite arithmetic observability/gluing experiment.
7. Two-node transport.
8. Private-witness/public-proof demo.
9. Endogenous decomposition bounty.

Do not build tokenomics, a custom VM, a global chain, or generalized P2P transport before these tests.

# 76. Acceptance tests

A. Independent invocations have no shared sequence number and replay in either order with identical semantics.

B. Conflicting spends cannot both settle.

C. A third party verifies an artifact from immutable dependencies without contacting producer.

D. Equivalent independent artifacts deduplicate semantically while retaining distinct provenance.

E. Stronger relation certificate satisfies weaker requested relation through refinement proof.

F. Private witness can yield public accepted claim without raw witness disclosure.

G. Failed parent research branch leaves reusable child artifacts.

H. Replacing solver implementation leaves verifier semantics unchanged.

I. Rebuilding mutable index from object store preserves semantic graph.

J. No component outside declared conflict domains needs global consensus.

# 77. Falsification conditions

Demote the architecture if implementation shows:
- independent certified processes repeatedly require global total order;
- relation descriptors cannot interoperate across implementations;
- verifier/specification overhead destroys utility outside narrow domains;
- dual semantic/provenance identity creates more ambiguity than value;
- local conflict domains compose into ubiquitous global atomicity;
- useful workloads cannot reduce boundary semantics below replicated state;
- endogenous decomposition yields mostly spam and no reusable artifacts.

These are engineering/math failure conditions.

# 78. Strong architectural conjecture

For a large class of open computational systems, the minimal coordination substrate is generated by

    typed relational boundaries
    + immutable content/provenance commitments
    + proof-carrying claims
    + partial-order dependencies
    + capability/resource feasibility domains
    + observer-relative disclosure
    + optional strategic settlement.

Global consensus is required only where a composite relation introduces non-product shared-state feasibility or one common-choice requirement.

If true, the main scalability problem is not making one serialized replicated machine faster. It is compiling computation into the smallest places where serialization, information transfer, or adjudication is unavoidable.

# 79. Compiler optimization problem

Given composite specification P, seek coordination plan Q minimizing Pareto cost K(Q) subject to contextual equivalence:

    Sem(Q) == Sem(P)

for the declared external task/context family.

Decision variables include quotient boundaries, hidden/public variables, causal edges, conflict hyperedges, proof systems, state modules, routing/decomposition, and settlement.

Constraints include semantic correctness, safety, resource conservation, capability non-escalation, disclosure, availability target, and optional equilibrium properties.

This is a concrete mathematical compiler problem.

# 80. Lower bounds paired with achievability

Information: cut lower bounds versus secure computation/zero-knowledge.

Causality: noncommutation/dependency lower bounds versus trace-parallel schedules.

Resources: cut/matching/matroid/feasibility lower bounds versus local settlement.

Verification: proof complexity versus succinct certificates.

Incentives: participation/IC constraints versus mechanisms.

An optimal protocol approaches the relevant lower bounds under a declared multiobjective policy.

# 81. Repository work packages

`kernel-types`: canonical encoding, IDs, descriptors.

`kernel-rel`: relation composition/tensor/refinement and finite evaluator.

`kernel-proof`: verifier adapters, claim cache, proof DAG.

`kernel-effects`: effect signatures, conservative independence, conflict hypergraph.

`kernel-cap`: bearer capability attenuation/spend and settlement.

`kernel-math`: MathStatement/Proof/Counterexample/Computation and Lean adapter.

`kernel-arithmetic-demo`: finite Prime-Pair observability/gluing experiment.

`kernel-router`: solver advertisements, relation matching, bounty interface.

Each package has a typed boundary and can be built independently.

# 82. Arithmetic demo exact output

Inputs: finite N, prime set S, local cover {S_i}, exact target charge, observable family.

Outputs:
- partition of [1,N] into observable fibers;
- target distribution per fiber;
- residual entropy;
- minimum supplement among candidate statistics;
- overlap compatibility table;
- global gluing fibers;
- finite cochain matrices when a cocycle model is declared;
- Betti/cohomology dimensions;
- explicit witness relating charge ambiguity to obstruction, or explicit failure.

Everything is deterministic and exhaustively re-verifiable.

# 83. Three-valued effect analysis

Given two invocation effects, return:

    ProvenIndependent
    ProvenConflict(domain)
    Unknown

Never infer independence from absence of known conflict.

`ProvenIndependent` requires syntactic disjointness or trusted commutation proof. `Unknown` is conservatively coordinated until proof improves it.

This is essential: ignorance is not independence.

# 84. Verifier purity

A verifier adapter is

    verify(verifierId, statementId, certificateId, dependencyIds)
      -> VerificationResult.

Its semantic result must depend only on committed inputs. Wall-clock time, mutable network state, and ambient environment must be explicit typed inputs if relevant.

Otherwise caching and provenance are unsound.

# 85. Capability linearity

Consumable capabilities are linear by default: one input lineage settles at most once.

Attenuation can create narrower authority but cannot duplicate consumable quantity unless a declared split relation conserves quantity.

Delegation of duplicable permission is a distinct capability type.

This prevents conflating copyable authority with copyable resource.

# 86. Router output is a Pareto frontier

A route plan contains solver, expected cost vector, disclosure, certificate system, capabilities, dependency retrieval, estimated completion, and trust assumptions.

Router returns nondominated plans. Caller selects policy.

The same task may intentionally route to multiple independent solvers when diversity has discovery value.

# 87. Research feedback loop

Every unnecessary compiler conflict becomes a `FalseConflict` artifact plus a commutation/substitutability proof. Generalize these into static compiler rules.

Every missed conflict becomes a minimal counterexample artifact identifying a missing coupling dimension.

Implementation therefore generates conjectures and counterexamples for the formal theory.

# 88. Prime-Pair bridge

The arithmetic project has the same shape:

    hidden arithmetic state
      -> observable quotient
      -> ambiguity fiber
      -> minimal supplement
      -> lifting/gluing obstruction
      -> scale refinement.

The Coordination Kernel asks these questions of distributed computation. This is not a claim that the domains are identical; it identifies reconstruction under restricted observability as a reusable problem class.

The finite arithmetic demo forces the abstraction to survive exact calculations rather than systems rhetoric.

# 89. Autonomous theorem proving bridge

Current swarms coordinate through text histories/filesystem state. Durable state should instead be typed claims:
- statement;
- proof/refutation;
- dependencies;
- verifier;
- equivalence;
- unresolved obligations.

Conversation remains search interface. Persistence becomes mathematics.

This is the substrate needed for a research machine that outlives one context window.

# 90. Statebox-facing constraint

The Statebox direction is valuable precisely because it begins with compositional process structure rather than account mutation. Preserve that.

Petri/process semantics fit consumption/production. Relations fit extensional contracts. Cospans fit open boundaries. Event structures fit concurrency. Cryptographic claims fit portable trust. Information quotients fit disclosure. Open games/mechanisms fit strategic modules.

Do not prematurely force one of these to impersonate all the others.

# 91. Why this is not blockchain plus AI

A chain can implement a scarce shared-state module. It is excellent there.

But theorem proofs, independent model outputs, private computations, semantic equivalence claims, and content-addressed derivations do not inherently require everyone to replay one total history.

The kernel subsumes chain-like modules without inheriting global serialization as ontology.

# 92. Why this is not merely an agent framework

An agent framework usually assumes one administrative runtime. Here artifacts must remain usable when producer is gone, model provider changes, router changes, and consumer never trusted the producer.

The invariant lives in typed portable objects and boundary proofs.

# 93. Mathematical kernel diagram

    arbitrary hidden search
             |
             v
       typed relation
             |
        certificate
             v
    accepted artifact
      /      |      \
 semantics provenance effects
      \      |      /
        composition
             |
      genuine coupling?
        /          \
      no            yes
   parallel      local module

There is deliberately no edge "exists on network -> global consensus."

# 94. v0.1 invariants

K0 immutable content-addressed objects.
K1 accepted semantic claim names verifier/dependencies.
K2 SID does not silently include provenance.
K3 PID commits to dependencies.
K4 no mandatory total-order field.
K5 consumable capability cannot settle twice.
K6 attenuation cannot increase rights.
K7 resource conservation checked separately from semantic truth.
K8 refinement explicit/proof-carrying.
K9 Unknown independence is not independence.
K10 disclosure policy explicit.
K11 mutable index is not semantic identity.
K12 solver identity optional.
K13 refuted claims remain addressable.
K14 composition exposes unresolved obligations.
K15 consensus invoked only for declared conflict/shared-choice semantics.

# 95. Immediate formal theorem

Formalize the restricted Kernel Composition Theorem before expanding abstraction.

The theorem should be executable against the same descriptor structures used by the runtime, not a disconnected category-theory toy.

If the formal model cannot express the prototype's actual conflict/capability/resource rules, the formal model loses.

# 96. Immediate implementation experiment

The first demo should be the math swarm itself.

Publish a finite arithmetic target relation. Spawn at least three independent solvers:
- exhaustive computation;
- symbolic derivation;
- adversarial counterexample search.

Persist every output as typed artifact. Deduplicate by semantic ID where possible. Require deterministic checker. Merge only verified results. Record no global order among independent branches. Introduce exactly one bounty capability to force one local settlement domain.

This single experiment exercises almost the whole thesis.

# 97. Expected failure that would be productive

The likely first failure is not cryptography. It is specification: deciding exactly what a relation descriptor must commit to so independent implementations agree on meaning.

That is useful. Every ambiguity becomes a type/relation design bug with a reproducible counterexample.

The second likely failure is effect inference: static read/write sets will over-coordinate. That creates demand for semantic commutation certificates.

The third is equivalence: universal SID canonicalization will fail. The correct response is incremental equivalence claims, not forcing canonicalization.

# 98. Minimality principle

The kernel itself should obey its own theorem:

Expose only distinctions required by its task family.

Do not put price, identity, timestamp, chain, model provider, geographic location, or execution engine into universal identity unless semantic correctness requires them.

Every extra universal field reduces implementation freedom and creates accidental coupling.

# 99. The object we are actually building

Not a ledger.

Not a VM.

Not a marketplace.

Not an agent orchestrator.

The object is a **portable algebra of certified boundaries** from which ledgers, markets, schedulers, theorem swarms, private computation, and resource systems can compose.

The engineering hypothesis is that heterogeneous autonomous processes need a common language for:
- what they consume;
- what they may produce;
- what counts as proof;
- what may remain hidden;
- what rights/resources move;
- what actually conflicts;
- what provenance persists.

# 100. Mathematical realization criterion

A technological realization of the v0.1 mathematical architecture should satisfy:

> Given a content-addressed relation instance and immutable input artifacts, an unknown solver can produce output artifacts and evidence; an independent verifier can establish exactly the declared semantic/capability/resource predicates; unrelated accepted invocations remain unordered; conflicting scarce transitions are settled only in their local domains; downstream consumers can reuse results through typed relation/refinement edges; and none of this requires trusting solver internals or replicating their hidden state.

That is concrete enough to code, falsify, benchmark, and formalize.

It is also strong enough that, if it works, the whitepaper stops being a metaphor.


# 101. Reference execution algorithm

The following reference algorithm is intentionally conservative.

```text
execute(task):
    R := fetch(task.relation_id)
    inputs := fetch_and_verify_types(task.inputs)

    plans := route(R, inputs, task.constraints)
    choose one or more nondominated plans

    for plan in plans that are mutually independent:
        launch concurrently

    for each returned invocation J:
        check canonical encoding
        check input/output type bindings
        verify semantic certificate
        verify dependency commitments
        verify capability predicate
        classify effects
        if J touches scarce feasibility domain:
            submit only its resource claim to that domain
        if all required predicates accepted:
            publish ValidInvocation(J)

    when parent composition prerequisites exist:
        construct merge invocation
        verify composition certificate
        publish parent artifact

    settlement:
        evaluate reward rule over accepted claim/provenance graph
        settle only required payment capability domains
```

The important negative statement is that `execute` contains no operation "append invocation to global log."

# 102. Reference verification dependency closure

A consumer asks for predicate P on artifact A. The resolver searches claim DAG backward for a derivation accepted under consumer policy.

This is theorem proving at the trust layer:

    required claim
       <- implication/refinement claims
       <- verifier results
       <- immutable evidence/dependencies.

A cached claim is reusable only if every transitive dependency ID is immutable and verifier semantics are version-bound.

If a dependency is later refuted, the old claim remains historically valid as "verifier V accepted proof under dependencies D"; a higher-level current-truth policy may withdraw reliance. This distinction prevents retrospective mutation of history.

# 103. Exact boundary between semantic and epistemic claims

`LeanKernelAccepts(statement, proof, kernelVersion)` is a deterministic semantic claim relative to kernel semantics.

`TheoremIsTrueInIntendedMathematics(statement)` is a stronger epistemic interpretation requiring trust that formalization and kernel capture intended mathematics.

The system should store the former directly and derive the latter only through policy.

Likewise `SNARKVerifies` is not identical to `ComputationWasCorrect` until the circuit/verifier relation is linked.

This layered claim graph is not bureaucracy. It prevents silent premise shifts.

# 104. Artifact lifecycle

An artifact can progress through states in an observer view without mutating:

    published
    -> type-valid
    -> semantically certified
    -> resource-settled
    -> equivalence-linked
    -> reused
    -> superseded/refuted.

These are derived labels from claims.

A second observer may stop at type-valid or reject the verifier. The artifact bytes remain identical.

# 105. Minimal conflict-domain interface

A conflict module need only implement:

```text
propose(domain, claimSet, proof) -> proposalId
status(proposalId) -> Pending | Accepted | Rejected
proveStatus(proposalId) -> Claim
```

Its internal consensus algorithm is opaque to the kernel.

The domain descriptor commits to the feasibility relation it enforces. A consumer trusts the module only for that relation.

This makes it possible to replace a centralized SQL lock with a BFT committee later without changing parent relation semantics, provided both implement the same conflict-domain contract.

# 106. Local finality is relation-specific

Some domains need irreversible finality; others allow compensating updates; others are monotone joins.

Therefore `finality` is not universal.

A payment spend may require strong non-reversal. A theorem claim can be superseded without deleting history. A cache index can be eventually consistent. A reputation score may be recomputed.

Forcing all of these through one finality model is accidental coupling.

# 107. Time is typed, not ambient

Wall-clock time enters semantics only through an explicit trusted time relation/certificate.

Deadlines, leases, expirations, and timeouts reference a clock oracle/domain. Pure mathematical artifacts do not.

This avoids smuggling machine-local timestamps into global meaning.

# 108. Randomness is typed, not ambient

A probabilistic relation that needs public randomness references a randomness artifact/beacon commitment. Private randomness stays inside implementation unless proof semantics requires commitment.

Reproducible randomized computation records seed as explicit input when exact replay is required.

Again: ambient process state is not semantic state unless declared.

# 109. Failure is an output relation

A solver crash is not a semantic result. A certified impossibility, timeout certificate under a resource budget, or "no witness found in finite domain D" can be.

Relations may explicitly include failure outputs:
- `Unsat` with proof;
- `Unknown`;
- `BudgetExhausted` with accounting;
- `Counterexample`.

This lets schedulers reason about failure without treating absence of a message as mathematics.

# 110. Search budgets as capabilities

Compute budget can itself be a capability consumed by solver invocations. Recursive decomposition splits budget capabilities under conservation.

This creates auditable resource accounting without requiring computation semantics to be deterministic.

A solver may spend budget and fail; the resource transition is still valid even when no theorem is produced.

# 111. Data locality

A relation may require private data that cannot leave a domain. Routing then sends solver capability/code to data or invokes a local solver, returning only proof/public quotient.

The task descriptor references data capability, not raw data.

This naturally supports federated/private computation without making all nodes share storage.

# 112. Capability-aware semantic routing

A solver that can prove R but lacks required data/resource capability is not an executable route.

Thus routing feasibility is an intersection:

    semantic competence
    AND authorization
    AND resource availability
    AND disclosure compatibility
    AND certificate compatibility.

Price optimization occurs only after feasibility.

# 113. Dependency minimization

Before shipping dependencies to a solver, compute the transitive subset actually required by its relation/interface.

If solver only needs semantic SID of theorem T and not its derivation, do not send provenance DAG.

If it needs a proof term for composition, send that artifact.

This is task-quotient thinking applied to dependency transport.

# 114. Provenance privacy

PID need not imply public plaintext provenance. Dependencies can be commitments; selective disclosure can reveal a path only to authorized auditors.

Semantic artifact may therefore be globally reusable while detailed derivation remains private.

Attribution mechanisms that require provenance must specify who can inspect it and under what proof system.

# 115. Semantic identity under partial canonicalization

For difficult domains use layered identity:

    representation_id
    normalized_id?
    theorem_statement_id?
    certified_equivalence_class?

An artifact may accumulate equivalence edges over time.

Indexes can union equivalence classes only under trusted equivalence claims. Different observers may have different semantic clusters.

This is more honest than pretending universal canonical semantics.

# 116. Refinement as interoperability

Suppose provider emits high-precision result S while consumer asks low-precision R. A refinement proof S<=R lets them interoperate without provider knowing consumer implementation.

This is the fundamental network effect: agreement on implication at the boundary substitutes for agreement on internal software.

The Internet standardized packets. This substrate would standardize certified transformations.

# 117. Commutation as interoperability

Similarly, two implementations need not coordinate schedules if they can prove their effects commute.

A reusable commutation theorem is therefore analogous to a concurrency protocol optimization.

Over time the network can accumulate a library of algebraic facts that make more execution parallel.

# 118. Proof cache as shared capital

A verified artifact reused k times saves repeated verification/search according to its certificate model. Cache entries are keyed by immutable semantic inputs.

The research swarm should report:
- verifier cache hit rate;
- semantic duplicate rate;
- average downstream reuse count;
- saved estimated prover work;
- critical-path reduction.

These are better metrics than number of generated tokens.

# 119. Obstruction cache as shared capital

Likewise cache impossibility:
- unsatisfiable assumption combinations;
- incompatible interfaces;
- failed refinement;
- lower-bound cuts;
- nonzero obstruction classes;
- known counterexamples.

Before spawning search, query obstruction cache.

A mature knowledge network should become faster partly because it knows where not to look.

# 120. Endogenous abstraction

When many artifacts repeat the same derivation fragment, an agent may publish an abstraction/lemma relation and refactor downstream proofs to reference it.

This can reduce corpus description length without proving a new extensional theorem.

The kernel can measure abstraction value by reuse and proof-size/work reduction.

Concept invention becomes an observable engineering operation.

# 121. Endogenous verifier improvement

If a verifier is a bottleneck, agents can produce:
- faster equivalent verifier;
- batch verifier;
- recursive proof aggregator;
- formal proof of verifier equivalence;
- specialized verifier for a refinement.

A new verifier becomes trusted only through policy/evidence, but once accepted it can increase network throughput globally for all matching artifacts.

This is tool value compounding.

# 122. Scheduling objective for research swarm

A practical scheduler can estimate expected utility of task t as:

    E[value if solved]
    + E[reuse value]
    + E[obstruction value]
    + E[tool/bridge value]
    - compute cost
    - verification bottleneck cost
    - scarce contention cost.

No claim that this estimate is canonical. It is simply richer than parent-task probability.

Diversity bonuses can reward low-correlation approaches when independent search increases discovery probability.

# 123. Why theorem count is not the objective

The previous theorem corpus built vocabulary. A production system should now prefer a single reusable compiler lemma, verifier, or bridge over dozens of isolated elementary statements when downstream reachability is larger.

The artifact graph lets that preference be quantified by reuse and dependency centrality rather than vibes.

# 124. A first serious benchmark

Target: one finite but nontrivial theorem where:
- exhaustive search is expensive enough to split;
- verification is cheap;
- multiple decompositions exist;
- counterexamples are possible;
- formal checker is deterministic.

Run four conditions:
1. monolithic single agent;
2. centrally prescribed workflow;
3. free decomposition without semantic dedup;
4. Coordination Kernel with typed relations, proof cache, dedup, obstruction cache, and parallel branches.

Measure wall-clock critical path, total compute, duplicate work, verified reusable artifacts, and coordination operations.

The architecture earns itself only if condition 4 produces durable or throughput value.

# 125. A second benchmark: resource contention

Generate many independent theorem tasks plus a small number of shared scarce GPU/payment capabilities.

Compare:
- global serialized queue;
- per-resource conflict domains with independent math DAG.

The expected result is not merely higher throughput; it should exactly demonstrate that ordering relation size tracks real contention rather than total event count.

# 126. A third benchmark: privacy

Have a solver possess a large private witness/data set and prove a small predicate. Compare:
- replicate raw state;
- send minimal public output;
- commitment + proof.

Measure bytes, leakage model, prover work, verifier work.

This directly tests the replication-gap thesis.

# 127. A fourth benchmark: semantic equivalence

Have multiple agents independently derive the same result using different methods.

Measure whether semantic dedup avoids downstream repeated work while provenance retains attribution and independent-confirmation value.

The hard part will be equivalence certification, which is exactly why it should be benchmarked early.

# 128. A fifth benchmark: dynamic process equivalence

Construct two different finite state machines implementing the same external protocol. Prove bisimulation/minimize them to the same contextual semantics.

Then swap implementations under a composed consumer and verify unchanged behavior.

This tests whether process identity can genuinely be boundary-semantic rather than implementation identity.

# 129. Formal open problems created by v0.1

1. Characterize the weakest effect/commutation certificate language making compiler conflict inference complete for useful finite process classes.

2. Define coordination-faithful coarse-graining and classify fixed points/invariants.

3. Derive compositional cut lower bounds that combine information, causal, and resource constraints without illegitimate scalarization.

4. Characterize when local conflict-domain settlement composes without new atomicity hyperedges.

5. Find the correct categorical packaging of relation semantics + event structure + information channels + capabilities + proofs + games.

6. Define provenance attribution mechanisms robust to semantic duplicates, sybils, complementarity, and empty-core cases.

7. Build the finite arithmetic presheaf and determine whether parity ambiguity has a genuine cohomological carrier.

8. Formalize the restricted Kernel Composition Theorem in Lean.

These are now generated by an implementation object rather than by free association.

# 130. Final engineering thesis

The core primitive is not a transaction. It is a **certified typed relation instance**.

The core history is not a chain. It is an **immutable causal/provenance claim DAG**.

The core privacy object is not "encrypted state." It is an **observer-relative semantic quotient plus proof**.

The core concurrency object is not block throughput. It is a **partial order with local feasibility domains**.

The core economic object is not a universal token. It is a **mechanism consuming verified claims and capabilities**.

The core intelligence object is not an agent identity. It is an **open population of interchangeable search processes whose durable outputs are portable certified artifacts**.

That is enough structure to start coding.


# Appendix A — Minimal JSON example

A theorem task might serialize conceptually as:

```json
{
  "kind": "Task",
  "relation": "rid:LeanProve:v1",
  "inputs": [{"type":"MathStatement","pid":"..."}],
  "accept": [{"verifier":"lean-kernel-4.x","policy":"one"}],
  "disclosure": {"proof_term":"public"},
  "bounty": {"capability":"cap:...","rule":"first-valid"}
}
```

A result:

```json
{
  "kind": "Invocation",
  "relation": "rid:LeanProve:v1",
  "inputs": [{"pid":"statement..."}],
  "outputs": [{"sid":"theorem...","pid":"proof-derivation..."}],
  "certificates": [{"type":"LeanProof","pid":"..."}],
  "conflictKeys": []
}
```

Only settlement of the first-valid bounty touches the bounty capability conflict key. Proof production itself remains unordered.

# Appendix B — Minimal object dependency rules

1. Every PID edge points to an already content-addressed object or to a Merkle commitment whose eventual reveal is verifiable.
2. An invocation cannot depend on itself.
3. A claim about an invocation may depend on the invocation but the invocation must not include that claim ID, avoiding a hash cycle.
4. Recursive proof aggregation uses a new parent claim referencing child claims.
5. Cyclic logical definitions are represented by named relation/type descriptors and fixed-point semantics where explicitly supported, not by cyclic content hashes.

# Appendix C — What belongs outside the kernel

Outside:
- UI;
- social reputation ranking;
- model prompting;
- discovery transport;
- fiat/crypto choice;
- chain choice;
- cloud provider;
- human organization;
- ontology of all tasks;
- universal theorem equivalence;
- universal identity.

Inside:
- immutable typed commitments;
- relation descriptors;
- evidence/claims;
- dependency/provenance;
- capability/resource interfaces;
- explicit conflict obligations;
- compositional semantics.

The kernel should be aggressively small.

# Appendix D — A concrete first commit

Repository skeleton:

```text
coord-kernel/
  packages/
    types/
    rel/
    objects/
    claims/
    verifier/
    effects/
    capabilities/
    router/
  demos/
    arithmetic-observability/
    theorem-bounty/
  formal/
    lean/
      Rel.lean
      CertifiedRel.lean
      Effects.lean
      Composition.lean
```

First executable command:

```text
coord task publish task.json
coord solve --solver ./solver-a task:<id>
coord verify invocation:<id>
coord graph artifact:<id>
```

`coord graph` should visibly show an unordered DAG, not fabricate a linear transaction history.

# Appendix E — Definition of done for the first 48-hour spike

A local demo is done when:

- two solver processes receive the same or decomposed tasks;
- each produces immutable artifacts;
- a verifier process independently accepts/rejects;
- artifacts and claims survive process restart;
- merge composes verified child relations;
- one intentionally conflicting capability spend is locally rejected;
- an unrelated invocation is unaffected by that conflict;
- semantic/provenance IDs behave as specified;
- all graph state can be rebuilt from CAS objects;
- there is no hidden global sequence dependency in correctness logic.

At that point the project has crossed from architecture prose into a mathematical systems artifact.

# Appendix F — One sentence

**Coordinate semantics, not machines; order conflicts, not existence; verify boundaries, not search histories.**
