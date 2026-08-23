# Research system: current architecture and direction

**Status: canonical system description.**  This document describes what is
implemented, what is only partially mechanized, and what remains a design
target.  Speculative search mechanisms do not define the system.

`PYTHAGOREAN_EUCLIDEAN_MACHINE.md` records the current human-direction and
routing constitution: frontier/interior co-generation, reachable charts and
their completions, polyglot assimilation, duality crystals, synthetic
synesthetic access, and mathematics-induced metric change.  That note governs
direction; this file remains authoritative about implementation status.

## 1. Purpose

The repository is a private, adversarial, multi-agent research laboratory.  It
exists to convert human direction and parallel machine reasoning into
compressed, replayable mathematical progress without confusing generation,
evaluation, and epistemic authority.

Today's implemented value is a rigorous parallel builder/breaker/replay
process, not a novel decentralized-intelligence system.  The unproven
architectural hypothesis is that proof-relevant equivalence and theorem
transport, combined with reverse-dependency value routing while truth authority
stays separate from allocation, can outperform ordinary research
organization.  No end-to-end demonstration exists yet.

The system has three layers:

1. **Research graph:** claims, definitions, dependencies, evidence,
   counterexamples, programs, proofs, equivalence proposals, reviews, and
   historical events.
2. **Research loop:** orient, decompose, attempt, compute, prove, break,
   independently replay, integrate, and harvest consequences.
3. **Control plane:** task scopes, permissions, private-release policy,
   resource allocation, trusted validation, synchronization, and final
   integration.

The *research graph* is authored across Markdown, JSON events, scripts, and
Git. A deterministic read-only compiler/query layer now exists in
`code/natural.py`: it projects claims, obligations, evidence, artifacts,
events, dependency/supersession edges, coordination messages, and journal
anchors into one content-addressed `natural-research-graph-v1` view. Authoring
and authority remain in the source files; the runtime is not a second database
and does not infer discharge, equivalence, or promotion.
Integration is centralized by protocol and social coordination: a high-context
root coordinates specialists and normally decides what enters authoritative
state.  This is not enforced by repository access control—multiple trusted
agents can push—and current validators enforce record shape and legal event
transitions rather than privileged-root approval.  Execution is distributed;
epistemic promotion is procedurally centralized.

## 2. Current operational flow

```text
human direction
      |
high-context integrator
      |
parallel scoped work
  |-- mathematical builders
  |-- computational experimenters
  |-- hostile breakers
  `-- independent auditors
      |
claims + evidence + exact artifacts
      |
validation + replay + contradiction checks
      |
integrate / reject / quarantine
      |
path harvest + successor tasks
      |
private synchronized repository
```

The working culture is adversarial toward claims and cooperative toward
researchers.  Refutations, repaired statements, and independently reproduced
certificates are first-class outputs.

### Current operational map

| concern | current location |
|---|---|
| portfolio and status | `collab/STATE.md` |
| claim packets and authority events | `collab/discovery/` |
| coordination history | `collab/messages/` and `collab/journals/` |
| recorded failed routes | `collab/FAILURES.md` |
| executable evidence and kernels | `code/` and `machinery/` |
| canonical operating policy | `collab/PROTOCOL.md` plus validators |
| live collaboration state | `README.md` (who is awake, what they hold) |
| human-facing mathematics | `notes/MATHEMATICS_THAT_LEARNS.md`, `notes/REPORT.md`, and `site/` |

## 3. Authority boundary

The following distinctions are load-bearing:

- An agent may propose a claim; it cannot promote that claim by assertion.
- An experiment may influence search; it cannot establish a theorem unless a
  declared certificate or proof closes the relevant obligation.
- A passing check is evidence; acceptance is a separate authority event.
- A content hash establishes identity of declared content, not mathematical
  equivalence.
- Similar behavior nominates an equivalence search; it does not merge objects.
- A later revocation changes current authority without rewriting historical
  records.
- Nothing leaves the private repository without explicit human authorization.

The trusted surface should remain small: validators, exact kernels, accepted
equivalence policies, event-transition rules, and the privileged integrator.
Generated scaffolds, model outputs, experimental evaluators, and candidate
translations remain untrusted inputs.

## 4. Implementation status

| capability | status | evidence or boundary |
|---|---|---|
| parallel scoped research | operating | shared worktree, task claims, agent messages, persistent artifacts |
| adversarial review | operating | designated breakers, cross-lineage audits, independent implementations |
| exact computational replay | operating for selected results | certificate scripts, hashes, fail-closed checks, durable ledgers |
| claim/event history | operating but limited | `collab/discovery/`, append-only status events, validators |
| compiled research-graph queries | operating, read-only v1 | `code/natural.py`: deterministic summary/show/impact/frontier/resume/validate/snapshot; exact-source projection only |
| private synchronization | operating | private Git remote and explicit release policy |
| path harvesting | operating but partly manual | proof-route generalization and successor extraction |
| content-addressed candidate/evaluation records | narrow kernel implemented | `machinery/evolution/`; no runner or autonomous adoption |
| exact presentation identity | specified; partly reused from existing kernels | versioned hashes and dependency closure |
| witnessed mathematical equivalence | designed, not implemented as a general engine | morphism, verification, acceptance, and revocation contract |
| theorem transport | designed, not implemented generally | requires a checked morphism and a property-specific transport proof |
| proof-obligation graph | queryable prose nodes, semantic discharge still manual | `natural` compiles packet obligations and reverse dependencies; obligations are not yet typed as individual checked nodes |
| causal contribution credit | not implemented | reuse and dependency cuts are assessed by integrator judgment |
| automatic resource allocation | not implemented | parent/task selection remains human/integrator controlled |
| decentralized federation | not implemented | Git synchronization is not a federated authority or value protocol |
| executable history of mathematical languages | not implemented | current Rosetta and proof-diff work is agent-mediated |

## 5. Direction

The target is a **proof-carrying research network**, not a population metaphor.
Its central state is a versioned theory and obligation graph:

- exact presentations remain stable;
- translations are typed, witnessed morphisms;
- equivalence is indexed by the structure it preserves;
- theorem reuse across presentations requires checked transport;
- failed transports record the missing structure;
- reverse dependencies reveal the global effect of a local result;
- resource decisions use those effects without controlling mathematical truth.

The control plane should eventually support recursive delegation of goals,
capabilities, permissions, evaluation responsibility, and resources.  Local
research groups should be able to form around subgoals while preserving a
globally legible dependency and authority structure.  A public coordination
protocol may supply useful mechanisms for this layer, but it must not be
treated as an epistemic oracle.  `TORUS_CONTROL_PLANE.md` records a public-source
audit of one concrete recursive permission and resource-routing substrate.

## 6. Optimization target

Hard constraints come before performance:

1. no false automatic promotion;
2. no unauthorized egress;
3. replayable provenance and explicit assumptions;
4. revocable authority without historical erasure;
5. preservation of strategically distinct evidence and witnesses.

Within that feasible set, allocation should prefer Pareto improvements in:

- verified downstream proof obligations discharged;
- certified transports and reusable exact kernels;
- sharp obstruction and strategy-class elimination;
- transfer across problems, representations, and agent lineages;
- future option value retained;
- verification debt, compute, latency, and representation lock-in avoided.

No permanent scalar score represents scientific value.  Any scalarization
is a frozen experimental policy, not the definition of truth or progress.

## 7. Design-admission rule

A mechanism becomes part of the canonical architecture only after it has:

1. a precise interface and state transition;
2. an implementation or independently checkable formal model;
3. an explicit trust and privacy boundary;
4. a frozen baseline and controlled comparison;
5. evidence of improvement on live research work;
6. documented failure modes and a rollback path.

Until then it is prior art, a proposal, or an experiment.  Metaphors do not
grant architectural status.

## 8. Search-policy quarantine

Darwin Gödel Machine work is retained as a bounded prior-art and pilot-design
study.  The repository currently has no evolutionary runner, mutator, parent
selector, recombination engine, or self-adoption mechanism.  Biological terms
such as *genome*, *fitness*, *ecology*, and *evolution* are non-canonical
aliases for candidate configuration, evaluation vector, concurrent research
portfolio, and iterative search.  Core system documentation should use the
operational terms.

Search over agent configurations may later be tested as one replaceable policy
inside the control plane.  It has no privileged relationship to the research
graph, proof authority, or final architecture.

## 9. Shortest build path

1. Keep the live mathematical builder/breaker/replay loop running.
2. Make claims, obligations, evidence, and dependencies queryable as one
   research graph. **Narrow v1 landed:** `natural` compiles and queries the
   exact-source graph; the next increment is typed obligation/evidence edges
   and checked discharge, not another dashboard.
3. Implement one small witnessed-equivalence theory and one checked theorem
   transport end to end.
4. Compute reverse-dependency impact and use it as a visible, non-authoritative
   allocation signal.
5. Add recursive, revocable delegation for tasks, capabilities, evaluation,
   and budgets while keeping promotion authority separate.
6. Compare routing policies on preregistered live workloads; retain only those
   that improve verified research yield.
7. Federate only after local authority, replay, and privacy semantics are
   explicit and independently reproducible.

This is the only active system build order.  Orders in quarantined historical
design notes are non-operative.
