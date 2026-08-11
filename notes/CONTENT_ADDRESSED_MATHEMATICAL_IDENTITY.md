# Content-addressed mathematical identity

Status: architecture proposal. No record type, canonicalizer, equivalence
checker, class merger, or transport engine described here is implemented by
this note. The legacy candidate/evaluation validator is authoritative only for
its own narrow v1 record syntax; it does not implement or authorize the
equivalence layer proposed here.

## 1. The design in one sentence

Do not ask one hash to mean both "these bytes are the same" and "these
mathematical structures are the same." Give every exact presentation an
immutable content address, then represent mathematical sameness by a
content-addressed, proof-relevant graph of checker-verified equivalence
witnesses. A theory earns the stronger word *groupoid* only after its hashed
identity, inverse, composition, and law checkers pass.

This takes the operational lesson of Unison without crossing its semantic
boundary. Unison makes user-assigned definition and binder names into mutable
metadata and identifies a definition by a hash of normalized syntax and hashed
dependencies; semantic tokens such as builtins remain represented. That supplies
stable references, exact dependency tracking, and exact caches. It does **not**
identify all extensionally equal programs, let alone all isomorphic
mathematical structures. Our corresponding split is:

```text
human names  ──mutable pointers──>  immutable presentations
                                        │
                                        │ checked equivalence witnesses
                                        ▼
                          proof-relevant equivalence graph
                                        │
                                        │ finite view at an event head
                                        ▼
                                  class snapshots
```

The graph, not a magical semantic digest, is what respects algebraic identity.
It can grow when a new isomorphism is proved without changing any old object,
proof, cache entry, or lineage record.

## 2. Primary-source pins and the boundary they establish

The Unison observations in this note are pinned to
[`unisonweb/unison@db60ce2`](https://github.com/unisonweb/unison/tree/db60ce2faa4649f97746873f7d186a6d3ebd3bb8),
not to an inferred description of the current language.

- The official [hash reference](https://www.unison-lang.org/docs/language-reference/hashes/)
  says that terms and types receive 512-bit SHA3 hashes of internal structure,
  excluding user-assigned definition and binder names, and that mutually
  recursive definitions share a component hash with a member index. The official
  [big-idea overview](https://www.unison-lang.org/docs/the-big-idea/)
  explains why immutable definitions and hash-addressed dependencies permit
  persistent compilation and test caches. These pages were retrieved
  2026-08-11; the source pin above is the reproducibility anchor.
- At that pin, [`Unison.Hashing.V2.ABT`](https://github.com/unisonweb/unison/blob/db60ce2faa4649f97746873f7d186a6d3ebd3bb8/unison-hashing-v2/src/Unison/Hashing/V2/ABT.hs)
  removes binder names through an abstract-binding-tree environment, hashes
  strongly connected components, attempts deterministic member ordering, and
  assigns indices when that ordering succeeds. Crucially, it also exposes
  `IncompleteElementOrderingError`: sufficiently symmetric mutually recursive
  members may not be completely ordered. We therefore borrow the content
  addressing pattern, not an assumption that cyclic canonicalization is
  solved.
- The [Cubical Agda 2.9.0 manual](https://agda.readthedocs.io/en/latest/language/cubical.html)
  gives the computationally relevant fact behind the univalence analogy: an
  equivalence can be turned into a path, and transport along that path can
  compute. It does not say that equivalences can always be discovered or that
  equivalence is decidable.
- Ahrens, North, Shulman, and Tsementzis,
  [*A Higher Structure Identity Principle*, arXiv v3](https://arxiv.org/abs/2004.06572v3),
  makes precise, for a broad specified class of structures in univalent
  foundations, when identifications coincide with the appropriate notion of
  equivalence. The hypotheses and the chosen signature are part of the
  theorem; "isomorphic things are literally the same hash" is not.
- One optional search-policy client is informed by Zhang, Hu, Lu, Lange, and
  Clune,
  [*Darwin Gödel Machine*, arXiv v3](https://arxiv.org/abs/2505.22954v3),
  but that experiment is not a source of the identity architecture.  If run,
  evaluation scores may select candidate configurations while exact checkers
  and proof kernels alone determine mathematical status.

- Rabe and Kohlhase's
  [MMT module system](https://arxiv.org/abs/1105.0548) already represents
  foundation-independent mathematical theories and theory morphisms at web
  scale. Rabe, Kohlhase, and Sacerdoti Coen's
  [foundational account of system integration](https://arxiv.org/abs/1105.2725)
  studies safe and unsafe transport of problems and solutions through partial
  theory morphisms. The OpenDreamKit
  [Math-in-the-Middle architecture](https://arxiv.org/abs/1603.06424) adds a
  central ontology and system alignments so computer algebra, databases, and
  proof systems can communicate through a shared semantic pivot. These are the
  closest mature answers to the "fragmented Rosetta stone" problem; this note
  should reuse their theory-graph and transport semantics rather than invent a
  private synonym.

These sources motivate the architecture. They do not certify the proposed wire
formats or implementations below.

### 2.1 The reconstructed Rosetta stone

The public fragments solve different projections of one problem:

| language | mature contribution | missing for this private system |
|---|---|---|
| Unison/content-addressed programming | stable normalized references, hashed dependencies, causal code history | mathematical equivalence and proof transport |
| OMDoc/MMT and Math-in-the-Middle | theory graphs, foundation-independent morphisms, shared semantic pivots, safe-integration analysis | content-addressed immutable witness/evaluation history and this repo's fail-closed authority policy |
| univalence/SIP | the exact condition under which equivalence supports identity-like transport for a specified structure | discovery, decidability, cross-kernel checking, provenance |
| proof assistants/exact checkers | small trusted verification of terms and finite certificates | cross-language theory alignment and open-ended search |
| event-sourced/Merkle archives | immutable causal history and replay | mathematical semantics of an edge |

Their common object is a **versioned theory graph with proof-carrying
morphisms**. Content hashes address presentations and events; MMT-style theory
morphisms express translations; univalence explains when a translation can be
treated as identity-like transport; a pinned kernel decides whether the
witness is accepted. No single layer may impersonate the others.

This changes the implementation question. We are not designing a universal
semantic hash. We are reconstructing a small, private, content-addressed
front-end to an already mature theory-graph idea, then adding the missing
proof-relevant acceptance, causal snapshots, resource accounting, and an
optional search-client boundary. Before defining any new transport record,
compare it against MMT's theory-morphism semantics and safe-integration
conditions. The local record is justified only when it binds evidence or trust
data that the existing semantic language does not.

### 2.2 What the architecture should optimize

No single benchmark score is the objective. The ordering is lexicographic:

1. **Hard invariants:** zero false theorem promotion, zero unauthorized egress,
   replayable provenance, explicit axiom/environment boundaries, and no loss of
   dissenting witnesses or revocation history.
2. **Verified dependency cuts:** prefer one checked morphism, invariant, or
   transport theorem that discharges many downstream obligations over many
   isolated local successes.
3. **Reusable exact work per scarce cost:** increase certified theorem
   transports, replayable kernels, and sharply excluded regions per agent
   token, dollar, CPU-second, and verification byte.
4. **Option value:** preserve low-scoring but valid presentations, distinct
   automorphisms, counterexamples, and killed routes when they can alter a
   future brief. Never preserve unsafe executable authority merely for
   diversity.
5. **Low lock-in:** prefer theory morphisms and small checked interfaces that
   allow representations, provers, and execution engines to be replaced
   independently.

A useful non-authoritative engineering ratio is

\[
 \frac{\text{verified dependency cuts}+\text{certified transports}
       +\text{reusable kernels}+\text{sharp obstructions}}
      {\text{agent cost}+\text{compute cost}+\text{verification debt}
       +\text{representation lock-in}}.
\]

It is a dashboard, not a truth oracle. Numerator terms stay separately typed
and Pareto-visible; a scalarization is frozen only for a preregistered
experiment. The world-simplifying outcome is a small morphism or invariant
whose proof removes an entire repeated search surface. The system should learn
to hunt those cuts, not to maximize document count or CPU utilization.

## 3. Four identity strata

The system must always report which stratum an identity claim inhabits.

| stratum | statement justified by equality of IDs | decidability | use |
|---|---|---|---|
| **I0 artifact** | the stored byte string is the one whose domain-separated digest was recorded | decidable by hashing and byte replay | source, proof, certificate, and log storage; executable meaning lives at I1 |
| **I1 presentation** | the exact versioned mathematical presentation and its dependency presentations coincide after the declared canonicalizer | decidable for admitted records | exact build and evaluation caches |
| **I2 accepted witnessed equivalence** | the cited morphism, passing verification, and acceptance event pin one checked edge under one equivalence theory | decidable once the finite witness is supplied and checked; witness discovery need not be | theorem transport and semantic deduplication |
| **I3 class snapshot** | at one append-only edge head, the presentations lie in the same connected component of accepted invertible morphisms | decidable from that finite snapshot | search, lineage diversity, and user navigation |

I3 is deliberately called a *snapshot*, not a universal semantic ID or a
durable object identity. Two different I3 classes may later merge when a new
equivalence is proved. Existing snapshot IDs remain valid descriptions of what
was known at their recorded edge head, but must not be substituted for an I1
cache key. Conversely, a rejected witness never separates two I1 objects that
were already identical.

Human-readable names are not a fifth authority stratum. They are mutable,
many-to-many pointers to any of these records. Renaming changes a view, never
an I0--I3 identifier. Labels such as `group`, `prime-sieve-state`, `champion`,
or `best-proof` must not enter cache keys or identity preimages.

An I2 edge is therefore not the equality of two `morphism_id` values. A
morphism ID pins a candidate directional witness; the accepted I2 object is the
typed triple `(morphism_id, verification_id, event_id)`. Removing
any member removes authority but does not erase the candidate or its history.

## 4. Versioned hash preimages

The initial implementation should reuse the repository's existing SHA-256 and
canonical JSON discipline rather than invent a second serializer. For record
type `T`, define

\[
 \operatorname{id}_T(r)=\texttt{"sha256:"}\,\|\,
 \operatorname{hex}\!\left(
   \operatorname{SHA256}(d_T\,\|\,\operatorname{CJSON}(P_T(r)))
 \right),
\]

where:

- `d_T` is the UTF-8, NUL-terminated domain
  `distinction-math-identity/<T>/v1\0`;
- `CJSON` is bound by a `serializer_presentation_id` in the record-format
  specification.  V1 requires UTF-8 without BOM; unique object keys sorted by
  Unicode code-point sequence; minimal JSON separators; JSON escaping fixed by
  golden byte fixtures; integers in canonical base-ten with no leading zero or
  negative zero; strings preserved as their exact Unicode scalar sequence with
  no implicit NFC/NFD folding; and no floats, nonfinite numbers, or lone
  surrogates. A
  committed source/blob hash and cross-implementation fixtures pin the actual
  serializer rather than relying on an uncommitted function name;
- `P_T` is the documented identity projection, excluding the ID field itself
  and nonsemantic envelope data such as creation time, aliases, comments, UI
  order, and filesystem location;
- all set-valued ID lists are duplicate-free and bytewise sorted before
  hashing; sequence-valued fields such as a path remain ordered;
- every behavior-bearing schema interpreter, canonicalizer, kernel, verifier,
  composition/coherence checker, transport operator, and execution environment
  is an I1 presentation binding executable bytes, dependencies, configuration,
  and specification. Inert proof/source/log bytes may be I0 artifacts; a bare
  artifact digest never names executable semantics.

Changing the hash algorithm, canonical JSON implementation, field projection,
or normalization rule creates a new domain/version. It never silently changes
the meaning of an old ID. A migration emits new records and explicit
cross-version morphisms. Digest collision or a digest resolving to unequal
bytes is a fatal integrity error; no "pick one" recovery is permitted.

I0 has its own exact boundary. For raw byte string `b`,
`artifact_id(b) = "artifact-sha256:" || hex(SHA256(UTF8("distinction-math-artifact/v1\0") || b))`.
It hashes the domain and then the raw bytes exactly. Byte length and media type
are descriptive metadata unless included in a separately addressed artifact
descriptor. A digest resolving to absent or unequal bytes is a fatal integrity
error.

### 4.1 Presentation

The required record shape is below. In every display only the record's own
self-ID (`presentation_id` here, `morphism_id` in a morphism, and so on) is
excluded from `P_T`; all foreign-key `*_id` fields remain in the preimage unless
explicitly stated otherwise.

```text
presentation(
  format,
  presentation_id,
  ambient_theory_id,
  representation_schema_id,
  canonicalizer_id,
  payload_artifact_id,
  dependency_presentation_ids
)
```

`payload_artifact_id` addresses the canonical payload bytes, not the user's source
file. The raw source is preserved separately as provenance. The
`ambient_theory_id` binds such facts as the foundation, universe/size policy,
characteristic, coefficient ring, theorem-prover and kernel version, and
admitted axioms. The `representation_schema_id` says what the payload bytes
mean. The `canonicalizer_id` includes the executable, its specification, and
its normalization version. `dependency_presentation_ids` is always a
duplicate-free bytewise-sorted set in v1. Any semantically ordered dependency
structure lives inside the typed payload instead. Dependencies must form a
finite DAG.

A separate record binds normalization evidence:

```text
normalization_attestation(
  format,
  normalization_attestation_id,
  raw_source_artifact_id,
  presentation_id,
  canonicalizer_id,
  admitted_domain_id,
  mapping_certificate_artifact_id,
  verification_id
)
```

The verification checks the raw source, canonical payload reached through the
presentation, canonicalizer, mapping certificate, and admitted domain. Merely
naming a canonicalizer beside a payload does not establish that the source
normalized to it.

This makes alpha-renaming, whitespace, source ordering, or a relabeling
invisible **only** when the declared canonicalizer soundly removes it. An
unversioned pretty-printer is not a canonicalizer.

### 4.2 Equivalence theory

```text
equivalence_theory(
  format,
  equivalence_theory_id,
  relation_kind,
  object_signature_id,
  kernel_id,
  axiom_profile_id,
  witness_schema_id,
  normalization_version,
  verifier_policy_id,
  invertibility_mode,
  identity_operator_id,
  inverse_operator_id,
  composition_operator_id,
  law_checker_id,
  coherence_checker_id
)
```

`relation_kind` is typed and narrow: examples include definitional equality,
ring isomorphism over a fixed base, equivalence of categories, chain homotopy
equivalence, conjugacy, or equality under a declared observer. These relations
are not interchangeable. `object_signature_id` determines endpoint
admissibility. The kernel and axiom profile make the trust cost explicit, while
`verifier_policy_id` binds the allowed verifier set. `invertibility_mode`
declares whether inverses are constructed, certified, or not applicable. The
identity/inverse/composition operators and law/coherence checkers bind the
algebraic semantics needed before the accepted subgraph may be called a
groupoid. Explicit hashed nulls occupy nonapplicable fields; omission is not a
default.

### 4.3 Proof-relevant morphism and verification

```text
morphism(
  format,
  morphism_id,
  equivalence_theory_id,
  source_presentation_id,
  target_presentation_id,
  witness_artifact_id
)

verification(
  format,
  verification_id,
  subject_kind,
  subject_id,
  verifier_id,
  verifier_policy_id,
  environment_presentation_id,
  outcome,
  checked_input_ids,
  result_artifact_ids,
  log_artifact_ids
)
```

`subject_kind` is a closed, versioned tag such as `morphism`, `coherence`,
`target_theorem`, or `revocation`; `subject_id` points to that candidate. The
checked inputs must include the candidate witness, endpoints, theory, and any
subject-specific statement/environment data. A verifier cannot validate a
different subject kind merely because its bytes parse.

Here `source_presentation_id` and `target_presentation_id` are presentation
IDs, `equivalence_theory_id` selects the relation, and `witness_artifact_id` is
an I0 address. Direction is retained even for an equivalence. Distinct
witnesses with the same endpoints remain distinct morphisms: an automorphism
group, two proof routes, or two computationally different transports are
mathematical data, not duplicate noise.

Only a verification with `outcome = pass`, produced by an allowed verifier and
replayable from every checked input/result address, is eligible for acceptance;
it is not yet an accepted edge.
Missing artifacts, timeout, crash, unknown fields, unsupported axioms, or
verifier disagreement fail closed. An LLM statement that two objects are
isomorphic may create a candidate morphism task; it cannot create an accepted
edge.

Composition and inverse are derived records whose witnesses are checked under
the same theory. They are not graph operations that manufacture proof. Path
equality is also explicit:

```text
coherence(
  format,
  coherence_id,
  equivalence_theory_id,
  left_path_morphism_ids,
  right_path_morphism_ids,
  witness_artifact_id
)
```

`left_path_morphism_ids` and `right_path_morphism_ids` are ordered lists of
composable morphism IDs with the same endpoints. `witness_artifact_id` purports
to witness the declared higher equality; the coherence is only a candidate
until a separate passing verification under the theory's pinned coherence
checker and policy is accepted. This keeps multiple transports visible rather
than reducing the structure to union-find.

Acceptance is a separate append-only authority record:

```text
acceptance_event(
  format,
  event_id,
  previous_event_id,
  event_index,
  equivalence_theory_id,
  action,
  subject_kind,
  subject_id,
  verification_id,
  verifier_policy_id,
  prior_acceptance_event_id,
  action_evidence_artifact_id
)
```

`action` is `accept`, `revoke`, or `quarantine`. Acceptance requires a passing
verification under the hashed policy with matching theory, subject, inputs,
and environment; its prior/action-evidence fields are explicit nulls. The
genesis event has `previous_event_id = null`. Revocation or quarantine must
identify the prior active acceptance and a reviewed reason artifact, with a
subject-kind-compatible passing policy verification of that action evidence.
A subject is active at a head exactly when its latest
applicable event in that theory-local prefix is `accept`. Crash, timeout, or
verifier disagreement blocks current admission; a later discovered defect
appends revocation or quarantine for future heads. Old snapshots remain
immutable historical records but are not current authority after revocation.

### 4.4 Class snapshot

```text
class_snapshot(
  format,
  class_snapshot_id,
  equivalence_theory_id,
  accepted_edge_head,
  snapshot_algorithm_id,
  member_presentation_ids,
  supporting_acceptance_event_ids,
  supporting_verification_ids
)
```

`accepted_edge_head` is an `event_id` in the theory-local acceptance chain.
`member_presentation_ids` is the bytewise-sorted connected component containing
the queried presentation, computed using only active accepted invertible edges
at that head. The query seed is external to the snapshot; two seeds in the same
component produce the same record. `snapshot_algorithm_id` pins the component
and support algorithm. In v1 the support is the Kruskal-style spanning tree
obtained by sorting active `accept` events whose subjects are invertible
morphisms by event ID and adding an event exactly when it connects two
previously disconnected members. The support tree proves connectivity; the
complete theory-local event prefix through `accepted_edge_head` is additionally
required to prove maximality, so no connected member was omitted. The
supporting events and corresponding verifications replay the positive
connections. The validator recomputes every field; clients cannot assert them.
The full proof-relevant graph remains stored even though one deterministic tree
certifies this snapshot.

Only theories declaring checked invertibility induce equivalence classes.
Implications, embeddings, reductions, simulations, observer projections, and
analogies remain directed graphs and never enter this union. A class snapshot
does not choose a timeless canonical representative. A deterministic display
representative may be selected inside a view, but it has no mathematical
authority and may change without changing the class ID.

### 4.5 Transport

```text
transport(
  format,
  transport_id,
  equivalence_theory_id,
  accepted_edge_head,
  source_claim_event_id,
  source_claim_head_id,
  target_statement_id,
  path_morphism_ids,
  transport_operator_id,
  proof_artifact_id
)

transport_certification(
  format,
  transport_certification_id,
  transport_id,
  target_theorem_verification_id,
  verifier_policy_id,
  environment_presentation_id
)
```

`path_morphism_ids` is an ordered, composable list of morphism IDs active at
`accepted_edge_head`.
`transport_operator_id` is a versioned checked program or formal construction;
`proof_artifact_id` purports to show that the target statement is the
path-transport of the theorem certified at `source_claim_event_id`. The
transport is a candidate and contains no verification ID, avoiding a hash
cycle. `target_theorem_verification_id` independently verifies the target
statement/proof artifact under the ordinary checker without hashing the
transport record; `transport_certification` then links that pass to the
candidate under a hashed policy and environment. A certification is valid only
when that verification has `outcome = pass`, `subject_kind = target_theorem`,
and its checked target statement and proof artifact exactly match the
transport's `target_statement_id` and `proof_artifact_id`.
`source_claim_event_id` must be a valid proving/certification event under its
own claim-chain policy, and `source_claim_head_id` binds the claim head at which
any revocation-sensitive status is read. Every morphism in the path must be
active at the separate theory-local `accepted_edge_head` under the cited
policy/environment. A source theorem's status is never copied
merely because its presentations share an I3 class. If two paths
are expected to give the same result, cite an accepted coherence plus a
separately checked transport-congruence rule; otherwise the path distinction is
preserved.

## 5. The univalence and Structure Identity Principle fence

Univalence gives an equivalence-to-path map inside an appropriate univalent
universe. A Structure Identity Principle can then identify the correct notion
of isomorphism with identity for structures described by an appropriate
signature. This architecture should exploit the resulting *transport*, but it
must not overread the principle.

In particular:

1. Neither univalence nor SIP is a decision procedure for finding an
   equivalence.
2. The ambient universe, structure signature, laws, and notion of morphism are
   part of the claim. A bare carrier equivalence need not preserve structure.
3. Equality of I1 hashes is presentation equality relative to a specified
   canonicalizer. With the identity canonicalizer this is intensional; with a
   separately proved complete quotient canonicalizer it may decide the exact
   bounded relation declared by that canonicalizer. I2 is the general location
   of proved extensional or structural sameness.
4. Higher paths and automorphisms are retained through morphism and coherence
   records. Reducing everything to one class hash would destroy precisely the
   information a univalent treatment makes visible.
5. The production trust kernel need not itself be Cubical Agda. A Cubical Agda
   proof can be one witness language if its toolchain and axiom profile are
   pinned; Lean, another proof assistant, or an exact finite checker may verify
   other theories. Cross-kernel transport requires an explicit bridge, not a
   shared label.

Thus "univalently identify isomorphic structures" becomes an implementable
policy: store presentations separately, accept a checked equivalence morphism
under a declared structural theory, and make every transported result cite that
morphism chain. Call such a chain an *identity path* only when a pinned
univalent foundation actually constructs it. A Lean or exact-checker
isomorphism does not become a type-theoretic path without an explicit bridge.

## 6. Finite canonicalizers: the only safe fast path

Canonicalization is valuable when the relation is decidable on a sharply
bounded class. It is dangerous when a convenient normal form is mistaken for
universal mathematical identity.

Every canonicalizer must declare one of three modes:

- **complete canonical form:** a checker establishes, on the admitted domain,
  `canon(a) = canon(b)` if and only if `a` and `b` are related; only this mode
  may replace a payload before I1 hashing;
- **sound fingerprint:** equality of outputs constructs a checked relation,
  but related inputs may have different outputs; this creates an I2 edge, not
  an I1 merge;
- **heuristic candidate key:** collisions only nominate an I2 witness search
  and never merge I1 IDs, cache entries, or classes.

The v1 allowlist should contain only finite, resource-bounded domains with an
independent replay checker, for example matrices over a pinned finite field
under a specified row-operation relation, finite sets with a sorted canonical
encoding, or finite graphs below a declared size when a pinned canonical
labeler also emits a relabeling certificate. Each domain binds coefficient
objects, ordering conventions, size bounds, and the exact relation. For
polynomials, "normalized" must say whether variables may permute, units may be
removed, the base ring may change, or factors may reorder.

An authoritative complete canonicalizer must emit both canonical bytes and a
certificate mapping the input to them. Independent verification checks the
certificate and admitted domain. The map certificate proves only that this
input reaches this output; I1 quotient merging additionally requires a formal
proof, or an exhaustive independent check over the **entire declared finite
domain**, that `canon(a) = canon(b)` exactly when `a` and `b` are related. A
graph relabeling certificate without that completeness result is a sound
fingerprint/I2 witness, not a complete I1 canonicalizer. Performance bugs may
cause false negatives in a sound fingerprint;
they must never cause an unverified merge. General program equivalence,
unrestricted theorem equivalence, arbitrary group/ring/category isomorphism,
and open-ended diagram equivalence are outside the canonicalizer API.

V1 is DAG-only. Recursive or mutually dependent mathematical presentations are
stored as a single opaque, explicitly ordered bundle if they cannot be broken
apart. We do not copy Unison's SCC/member-index algorithm yet: Unison's own
pinned implementation reports an incomplete-ordering warning on sufficiently
symmetric cyclic components. A future SCC v2 needs a published canonical
ordering specification, symmetry fixtures, implementation-independent replay,
and a migration morphism from any v1 bundle. Until then, dependency cycles are
rejected.

## 7. Evaluation reuse, lineage, and optional search clients

This layer can make repeated research evaluation cheaper without allowing a
score to become truth.

### Exact reuse

The ordinary evaluation cache remains keyed by exact inputs:

```text
(candidate_configuration_presentation_id,
 evaluator_presentation_id,
 task_set_presentation_id,
 environment_presentation_id,
 sorted_seed_artifact_ids,
 resource_policy_id)
```

If this key is unchanged, deterministic pure work may be reused. Observed
clock time, aliases, creation time, and branch names do not enter it. Any
mutable external state, model/API snapshot, randomness, solver version, CPU
semantics relevant to the result, or network response must be frozen into an
input presentation or make the computation noncacheable.

### Equivalence-assisted reuse

An I3 class match alone is insufficient. Reusing a result across distinct I1
presentations requires a valid `transport_certification_id`, not merely a
candidate `transport`. The derived cache key includes the transport candidate,
certification, accepted-edge head, transport-congruence/execution-contract,
environment, and resource-policy IDs. This makes a cheap exact cache and a
more expensive proof-carrying transport cache, rather than one unsound
"semantic" cache.

### Lineage and novelty

Parent-child ancestry always uses immutable candidate-configuration
presentation IDs; later
class mergers never rewrite lineage. Novelty scoring may use a class snapshot
at a recorded edge head:

- an exact I1 duplicate receives zero presentation novelty;
- a scaffold certified equivalent under the selected relation receives zero
  configuration/presentation novelty, while a new morphism, automorphism, proof
  compression, faster transport, or stronger verifier may receive a separate
  proof-artifact novelty score—never scaffold novelty;
- a heuristic resemblance changes neither identity nor novelty unless the
  scoring system explicitly records it as an uncertain feature;
- historical scores retain their original snapshot ID, preventing newly
  discovered equivalences from retroactively changing an experiment.

An experimental archive may therefore keep semantically duplicate descendants
for provenance while avoiding repeated expensive evaluation when exact replay
or certified transport is available. Search processes may propose canonicalizers,
morphisms, coherences, and transports, but cannot approve their own verifier,
equivalence theory, class membership, or theorem status.

## 8. Failure modes and fail-closed responses

| failure | danger | required response |
|---|---|---|
| name included in an ID | renaming invalidates proofs and caches | reject schema; names live in views |
| under-versioned theory or normalizer | same digest changes meaning after upgrade | new domain/version and explicit migration |
| hash of pretty-printed mathematics | formatting accidents masquerade as identity | hash typed canonical payload and schema |
| heuristic normalizer used as authority | false merge corrupts lineage and theorem transport | candidate edge only |
| witness accepted by endpoint similarity | fabricated isomorphism | replay exact witness with pinned verifier |
| passing verification treated as acceptance | bypasses authority policy and revocation history | require a subject-compatible acceptance event |
| relation-kind confusion | embedding or observation quotient becomes "equality" | typed theories; classes only for invertible edges |
| union-find without paths | loses automorphisms, proof routes, and transport evidence | retain morphism graph and spanning verification set |
| class ID treated as eternal | new proof forces destructive rewrite | head-bounded immutable snapshots |
| proof-irrelevant deduplication | distinct automorphisms or algorithms disappear | morphism IDs include witness artifact |
| unchecked transport | theorem status copied across an invalid bridge | target proof replay through pinned operator/kernel |
| transport/verification hash cycle | candidate and certificate cannot be constructed independently | separate transport candidate from target verification and certification link |
| cyclic dependency canonicalization | symmetric SCC receives unstable member indices | reject cycles in v1 |
| canonicalizer disagreement | platform-dependent identities | quarantine outputs; no ID or class merge |
| digest collision or object mismatch | address aliases unequal bytes | fatal integrity stop and algorithm migration |
| axiom-profile erasure | classical or unsafe result appears constructive | bind axiom profile in theory and verification |
| class-wide evaluation-cache reuse | equivalent object may require nontrivial result transport | exact cache or proof-carrying derived cache only |
| adaptive discovery controls authority | a high evaluation score promotes its own semantics | immutable verifier/class-acceptance controller |

## 9. Staged implementation

### Stage A — presentations, no semantic merging

Add versioned presentation and equivalence-theory schemas; reuse canonical
JSON, digest validation, dependency-closure validation, append-only prefix
checks, and strict unknown-field rejection from `machinery/evolution/`.
Implement the mutable alias view separately. Admit only DAG dependencies and
the identity canonicalizer plus a tiny allowlist of checked finite
canonicalizers.

Exit criterion: two implementations reproduce every I0/I1 fixture byte for
byte and every mutation of an identity field changes the expected ID.

### Stage B — verified equivalence-graph kernel

Add morphism, verification, acceptance, inverse/composition, and coherence
schemas. Begin
with one finite relation whose witness checker is small enough to audit
completely. Maintain an append-only accepted-edge event chain. No theorem
transport and no class-wide cache reuse yet.

Exit criterion: the graph can independently reconstruct endpoints, identities,
inverses, composites, unit/associativity/inverse laws, and coherence fixtures;
only then may an invertible theory call its accepted graph a groupoid. Invalid,
timed-out, cyclic, or wrong-theory records fail closed.

### Stage C — snapshots and transport

Build deterministic I3 snapshots from a specified edge head and minimal sorted
supporting verifications. Add one transport operator for a finite theorem
language and require ordinary target-proof replay. Expose class membership as
a view with its theory and head visible in every UI response.

Exit criterion: an independent implementation reproduces snapshots and target
proofs, and adding an edge creates a new snapshot without changing old IDs.

### Stage D — MathDGM integration

Split exact and equivalence-assisted caches, add snapshot-pinned novelty
features, and let descendants propose but never approve witnesses. Run a
private, preregistered pilot comparing compute saved, false-merge count, replay
rate, proof-transport cost, and lineage diversity against exact-hash-only
caching.

Exit criterion: zero authority violations and zero false merges in adversarial
fixtures; savings are reported separately from mathematical yield.

### Stage E — higher and cyclic structure

Only after A--D survive cross-lineage review should the system consider
Cubical Agda-backed higher witnesses, richer coherence, or SCC records. This
stage starts a new format version. It does not mutate the v1 trust base.

## 10. Exact regression and adversarial tests

The first implementation is not complete until all of the following are
executable fixtures with expected IDs or expected failures.

### Hash-preimage tests

1. Golden bytes and IDs for every record type; Python and a second
   implementation agree.
2. JSON object key order, whitespace, path, timestamp, display name, and alias
   changes do not change IDs when excluded by the identity projection.
3. Every included field changes the ID: ambient theory, representation schema,
   canonicalizer, normalization version, payload, dependency, kernel, axiom
   profile, witness schema, verifier, endpoint, path order, and edge head.
4. Duplicate set members, unknown fields, noncanonical JSONL, floats, NaN,
   invalid UTF-8, malformed hashes, and self IDs fail closed.
5. Dependency set permutations agree; ordered path permutations disagree.
6. A transitive dependency change changes its presentation closure and every
   dependent presentation; an alias change does not.
7. Old golden IDs continue to resolve after a schema upgrade; v1 and v2 domains
   never collide.

### Presentation/canonicalizer tests

8. Alpha-renamed or relabeled fixtures agree only under the canonicalizer that
   declares that invariance; identity-canonicalized payloads remain distinct.
9. Each complete finite canonicalizer is proved complete or exhaustively
   checked over its entire declared finite domain against the relation and
   emits a replayable normalization map; smaller fixtures are regression only.
10. Sound-fingerprint fuzzing establishes `same output => accepted witness`;
    completeness is not inferred.
11. A heuristic collision creates two I1 presentations and a candidate edge,
    never one presentation.
12. Cross-characteristic, cross-base-ring, cross-universe, and cross-axiom
    fixtures remain distinct even when their printed expressions match.
13. Direct cycles, longer dependency cycles, and Unison-style symmetric SCC
    fixtures are rejected in DAG v1.
14. Two independent canonicalizer builds on supported platforms emit identical
    bytes; disagreement quarantines the record.

### Morphism, groupoid, and snapshot tests

15. A valid witness passes; a one-byte-corrupt witness, wrong endpoint,
    wrong theory, wrong subject-kind tag, wrong verifier, missing artifact,
    timeout, and crash fail. A passing verification without a compatible
    acceptance event is not an active edge.
16. Two different valid witnesses with the same endpoints get different
    morphism IDs and remain visible.
17. Identity, inverse, and composition witnesses replay; endpoint and theory
    mismatches are rejected.
18. A commuting triangle passes its coherence checker; a noncommuting
    automorphism fixture does not get collapsed by endpoint equality.
19. Class construction ignores unverified, pass-but-unaccepted, rejected,
    directed noninvertible, and post-head edges. A later revocation removes its
    subject from future heads without changing an earlier snapshot.
20. Given the identical acceptance-event prefix and head, traversal or map
    iteration order does not change a snapshot ID. Reordering the causal event
    chain correctly changes IDs. Adding an accepted bridge produces a new
    merged snapshot while all old snapshots still replay.
21. The listed supporting acceptance events and verifications are sufficient
    and deterministic;
    removing one breaks replay. Irrelevant accepted events leave the member set
    and minimal support unchanged, but a snapshot at the new head has a new ID;
    the old snapshot ID remains replayable. Omitting any member connected in
    the full head prefix fails maximality even when the submitted tree is
    internally connected.

### Transport and evaluation-cache tests

22. Transport along identity reproduces the source theorem; transport along a
    verified relabeling produces a target theorem accepted by the ordinary
    checker.
23. A path with one unaccepted edge, a wrong transport operator, an altered
    target statement, or a failed target-proof verification fails. A single
    accepted path needs no coherence claim. Candidate transport and independent
    target verification construct without a hash cycle; certification rejects
    a mismatched pair.
24. Distinct paths remain distinct cache keys. Consolidation occurs only after
    an accepted coherence, a separately checked transport-congruence operator,
    and ordinary replay of the target proof; coherence alone does not rewrite
    immutable path-keyed entries.
25. Exact evaluation-cache hits require identical semantic input IDs and seeds;
    timestamps, aliases, and resource observations do not affect the key.
26. Same-class/different-presentation evaluations miss the exact cache and hit
    an equivalence-assisted cache only with a valid transport certification.
27. A later class merge does not rewrite parent IDs, old evaluation values, or
    old novelty features; it affects only evaluations explicitly pinned to the
    new snapshot.
28. A descendant cannot modify its equivalence theory, verifier allowlist,
    accepted-edge head, class computation, or theorem-status rules.
29. Prompt claims, embedding similarity, matching names, identical benchmark
    scores, and LLM votes never create an accepted edge.
30. An end-to-end adversarial archive containing every failure above validates
    to exactly zero retained false merges and zero unverified theorem
    transports.

## 11. Rigor boundary

Established by the cited primary sources: Unison content-addresses syntax with
user-assigned binder/definition names abstracted and dependencies hashed; its
implementation has explicit SCC/member-index
machinery and an incomplete-ordering warning; Cubical Agda computes transport
from equivalences via univalence; SIP theorems require specified structural
hypotheses; OMDoc/MMT represents foundation-independent theory graphs and uses
theory morphisms for safe cross-system translation; Math-in-the-Middle uses a
shared ontology as a semantic pivot. Darwin Gödel Machine work is optional
empirical search-policy prior art rather than an identity source or proof
authority.

Specified here, not yet established: the four-stratum record system, exact
preimages, finite canonicalizer allowlist, proof-relevant graph, snapshot
algorithm, transport records, candidate/evaluation cache integration, and
their regression suite. In particular, this note makes no claim that arbitrary mathematical
isomorphism, equivalence, theorem equivalence, or program equivalence is
decidable. The design is valuable precisely because it remains sound when
those questions are open.
