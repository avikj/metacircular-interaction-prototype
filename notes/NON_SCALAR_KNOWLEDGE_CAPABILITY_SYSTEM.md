# A non-scalar knowledge and capability system

**Status.** Whitepaper architecture contribution reconstructed from current
repository results.  It distinguishes implemented mechanisms, proved finite
results, and proposed controls.  It does not claim an autonomous knowledge
organism, decentralized authority, empirical pedagogy, or a new distributed
systems primitive.

## 1. Design invariant

The system state is not a score attached to an agent or document.  It is a
versioned graph whose nodes have different types:

\[
  G=(C,O,E,A,L,R),
\]

where `C` are exact claims, `O` proof obligations, `E` evidence artifacts, `A`
authority events, `L` language/signature declarations and translations, and
`R` dependency, supersession, discharge, audit, and provenance relations.
No canonical map `G→R` is proposed.  Truth, novelty, utility, permission,
verification cost, and pedagogical value are separate coordinates.

This is ordinary provenance-graph and build-graph discipline applied to
mathematical work.  The repository-specific contribution is the exact set of
boundaries below, not a new name for the pattern.

## 2. Architecture and established vocabulary

### 2.1 Authoritative store: Git commit DAG plus typed source records

Git supplies content-addressed blob/tree/commit identity and a commit DAG.
Claim packets, proof notes, formal terms, event records, source files, and
journals remain authoritative at their committed bytes.  A hash answers
“which bytes?”; it does not answer “same theorem?”, “true?”, “authorized?”, or
“equivalent presentation?”.

The append-only claim-event convention resembles **event sourcing**: current
claim status is intended to be reconstructed from status events.  It is not a
complete event-sourced store today.  The repository records that an event can
be written before packet front matter, so interruption may leave inconsistent
state which validation detects rather than transactionally prevents.

Git branching and manual merge are also not a **conflict-free replicated data
type (CRDT)**.  A CRDT supplies operations/state whose replicas converge under
specified delivery assumptions.  Here, text conflicts require judgment,
mathematical claims can contradict without a lawful join, and authority events
are not defined by a commutative merge algebra.  Git is the synchronization
transport; the protocol, not a CRDT theorem, governs integration.

### 2.2 Read model: deterministic materialized projection

`natural-research-graph-v1` is a deterministic, content-addressed **read
model/materialized view** over the source records.  It compiles claims,
obligations, evidence, artifacts, events, dependencies, messages, and journal
anchors; it supports summary, impact, frontier, validation, and resume queries.
This is close to the read side of CQRS/event-sourced systems, but only the read
projection is implemented.  It cannot promote, refute, repair, rank, or mutate
claims.  A generated snapshot is a cache, never a new source of authority.

### 2.3 Semantic interoperability: institutions after a supplied language map

For a signature `Σ`, models and sentences are related by satisfaction.  For a
supplied signature morphism `σ:Σ→Σ'`, Goguen--Burstall **institution theory**
requires the satisfaction condition

\[
  M'\models_{\Sigma'}\operatorname{Sen}(\sigma)(\varphi)
  \quad\Longleftrightarrow\quad
  \operatorname{Mod}(\sigma)(M')\models_\Sigma\varphi .
\]

That is the correct contract for transporting judgments across declared
languages.  A plain content hash cannot provide it.  Nor does the institution
choose `Σ'` or `σ`: two incompatible expansions can have the same reduct.  A
language-extension event must therefore name the new signature or constructor,
its interpretation, the authorized source of that interpretation, and a
satisfaction/transport audit where applicable.

### 2.4 Proof-carrying artifacts, with a deliberately small checker

Necula's **proof-carrying code** separates an untrusted producer from a consumer
that checks a proof against a previously fixed safety policy.  The analogous
research contract is:

```text
(exact statement, assumptions, dependency identities, certificate, checker)
        -> independently replayed acceptance or explicit rejection.
```

Selected Agda (`--cubical --safe`) and Lean terms, exact certificates, and
source/hash manifests instantiate parts of this contract.  The generic claim
registry does not yet: certification transitions are disabled, many proof
obligations remain prose, and no universal checker establishes theorem
semantics.  “Proof-carrying research network” is therefore proposed scope, not
an implemented-system claim.

The checker policy is part of the trusted computing base.  A successful build
must retain toolchain, dependency closure, axioms/trust assumptions, exact
command, outputs, and artifact hashes.  Otherwise “green” can mean only that an
unknown environment accepted an unknown target.

### 2.5 Formal identification: version spaces, test cover, and teaching sets

For a fixed finite hypothesis class `H`, query set `Q`, and observed labeled
sample `S`, the **version space** is

\[
  V(S)=\{h\in H: h(q)=y\text{ for every }(q,y)\in S\}.
\]

A target is identified exactly when `V(S)={h_*}`.  The minimum benevolent
target-specific sample is its **teaching dimension**.  The minimum binary
probe family separating every pair of hypotheses is the classical **minimum
test cover** (also minimum test collection/test set).  For categorical probes,
the exact object is a minimum point-separating family of functions/partitions,
or categorical generalized test collection; atomizing outcomes into separately
selectable binary tests can change the optimization problem.

These objects can choose informative tests inside supplied `H,Q` and response
semantics.  They do not form a new hypothesis language, certify a teacher's
authority, or measure human difficulty.  An empty version space detects model
misspecification; it does not select a unique model-class revision.

### 2.6 Capability security for intervention and promotion

The appropriate security vocabulary is **capability-based security** and
**least authority**, not agent reputation.  A future control plane should use
unforgeable, attenuable capabilities scoped separately to:

- read private artifacts;
- execute a declared checker or experiment;
- propose a claim or language extension;
- append an audit event;
- promote, quarantine, supersede, or withdraw present authority;
- publish outside the private repository.

Possession of evidence must not imply possession of promotion or publication
authority.  Delegation should attenuate rights and scope, and revocation should
remove future authority without deleting the historical event.  This is a
design requirement.  Current Git credentials and social protocol do not yet
enforce object capabilities or a privileged-root policy.

### 2.7 Governance is a separate state machine

Epistemic state and governance state meet through typed events but are not the
same graph relation.  A proof can discharge an obligation; only an authorized
transition can make the corpus depend on it.  A withdrawal can revoke current
permission without making the prior proof false.  Learned scores may order
proposals, but cannot install a constructor, promote a theorem, impersonate a
participant's response, or authorize release.

The current builder/breaker/independent-audit protocol is implemented socially
and partly validated structurally.  Reviewer independence, extraordinary-claim
gates, and private-release authority are policies; they are not derived from
the mathematical dependency graph.

## 3. Minimum typed record

An interoperable artifact should carry at least:

| field | established role |
|---|---|
| immutable content identifier + media type | content addressing |
| exact statement and declared language/signature | specification |
| assumptions and dependency identifiers | build/proof DAG |
| artifact kind and verification procedure | proof/certificate contract |
| toolchain, trusted axioms, environment, raw outputs | reproducible build |
| producer, auditor, lineage, timestamps | provenance |
| authority event and capability scope | access/control plane |
| supersedes/withdraws relations | event-sourced history |
| preservation/forgetting statement for translations | institutional semantics |
| counterexamples and failed obligations | falsification record |

This is not one universal semantic hash.  Different presentations can express
the same theorem without sharing bytes, and identical bytes can be deployed
under different authority or threat contexts.  Equivalence requires a checked
map or proof indexed by the structure preserved.

## 4. Failure and threat cases

1. **Hash laundering.** A digest is presented as proof, semantic equivalence,
   or authorship.  Mitigation: type hashes only as byte identity and require a
   separate checker, translation witness, and provenance claim.
2. **Torn event update.** Event and packet status diverge after interruption.
   Mitigation: transactional append or deterministic event replay plus
   fail-closed validation; never silently rewrite history.
3. **Stale or poisoned read model.** A derived snapshot is treated as current
   authority.  Mitigation: bind it to complete source identities, recompile,
   and keep all mutation outside the projector.
4. **Semantic merge mistaken for text merge.** Two branches merge cleanly while
   their claims conflict, or conflict textually while their theorems agree.
   Mitigation: explicit dependency/contradiction checks and witnessed semantic
   transport; do not advertise CRDT convergence.
5. **Authority laundering.** Prediction accuracy, citation count, reputation,
   or proof possession becomes permission to install or publish.  Mitigation:
   least-authority capabilities and distinct promotion/release events.
6. **Grammar closure mistaken for learning.** CEGIS, free syntax, or a version
   space searches a supplied language and is advertised as forming the next
   language.  Mitigation: record the source of every new constructor/signature
   and the non-old-language signal selecting it.
7. **Empty-version-space arbitrariness.** Inconsistency triggers an unrecorded
   enlargement of `H`.  Mitigation: preserve the failure and require an
   explicit grammar, preference, teacher, counterexample policy, or source rule.
8. **Probe-cost distortion.** A categorical experiment is atomized into
   independently selectable binary outcomes.  Mitigation: preserve grouped
   experiment identity and cost; use generalized test collection, not ordinary
   test cover, when outputs are categorical.
9. **Proof-policy mismatch.** A certificate checks, but against the wrong
   statement, axioms, compiler, or safety policy.  Mitigation: bind statement,
   policy, dependency closure, toolchain, and checker result in the artifact.
10. **Revocation as erasure.** Removing present authority deletes causal or
    scholarly history.  Mitigation: append withdrawal/supersession events and
    recompute present views without mutating earlier facts.
11. **Reviewer pseudo-independence.** Several agents replay the same derivation,
    hidden cache, prompt, or implementation.  Mitigation: record lineage and
    require disjoint-joint or from-scratch audits for headline claims.
12. **Scalar Goodhart failure.** One score merges truth, utility, novelty,
    pedagogy, and power, then becomes the allocation target.  Mitigation: retain
    the typed graph and expose any scalarization as a revocable policy query.
13. **Privacy capability leak.** A read-only external query discloses private
    problem text.  Mitigation: explicit egress capability, data minimization,
    and local/offline verification by default.

## 5. Status ledger

| component | grade | exact boundary |
|---|---|---|
| Git content-addressed commit DAG and private synchronization | **implemented** | identity/version transport, not semantic truth |
| claim packets, notes, event files, messages, journals | **implemented records** | heterogeneous authority; events are conventionally append-only |
| deterministic research-graph read model | **implemented, read-only** | queries and warns; no promotion or mutation |
| packet/event shape validators | **implemented, partial** | structural consistency, not theorem certification |
| selected Agda/Lean proofs and exact replay certificates | **implemented per artifact** | no universal proof-object format or checker |
| old-language extension underdetermination | **proved, elementary** | old reduct cannot choose a new operation |
| target teaching-set/disagreement hitting theorem | **proved; standard identification** | finite fixed `H,Q`, truthful labels |
| binary minimum test-cover dictionary | **established prior art + exact reduction** | categorical grouped probes require the generalized problem |
| institution satisfaction transport | **established prior art** | begins after signature morphism is supplied |
| builder/breaker/audit and release policy | **operating governance** | socially enforced; reviewer independence partly recorded |
| transactional event-sourced claim authority | **proposed** | current updates can tear; certification transitions disabled |
| object-capability control plane | **proposed** | current Git access is coarser and not least-authority |
| CRDT replication of epistemic state | **not implemented and not currently specified** | no lawful commutative merge for claims/authority |
| general proof-carrying research network | **proposed** | typed obligations, checker policies, and promotion gates incomplete |
| automated language/model-class formation | **open** | enumeration and selection do not justify a new grammar |
| empirical pedagogy or human concept learning | **not claimed** | formal teaching dimension is not human learning difficulty |

## 6. Prior systems and terminology boundary

- Git's object model is a content-addressable key/value store organized into
  blobs, trees, and commits; this grounds content identity and the commit DAG.
- Martin Fowler's *Event Sourcing* records all application-state changes as a
  sequence of replayable events; the repository currently approximates, but
  does not transactionally realize, this pattern.
- Shapiro, Preguiça, Baquero, and Zawirski's CRDT theory supplies sufficient
  conditions for strong eventual consistency; those conditions have not been
  established for this research state.
- Dennis--Van Horn and later object-capability work, including Miller's
  *Robust Composition*, ground least-authority, delegable access by possession
  of scoped capabilities.
- Necula's *Proof-Carrying Code* (POPL 1997) grounds producer-supplied proofs
  checked against a consumer's fixed policy.
- Goguen--Burstall institutions (JACM 39, 1992) ground satisfaction-preserving
  transport across supplied signature morphisms.
- Mitchell's version spaces/candidate elimination, Goldman--Kearns teaching
  dimension, and the minimum test cover/test collection literature ground the
  finite identification layer.

No architectural novelty is claimed for these components.  The deliverable is
their typed composition and, equally, the refusal to identify content,
semantics, proof, learning, authority, replication, and value.
