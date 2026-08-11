# Torus control-plane mapping for research coordination

**Status: public-source architecture audit, not an integration commitment.**
No Torus integration, account, token mechanism, chain dependency, or adoption
decision exists.  Torus is one substitutable source of permission and routing
mechanisms.  This note records mechanisms visible in the public Torus
documentation and the `renlabs-dev/torus-substrate` runtime at commit
`0466be6` (2026-07-07).  It
does not treat stake, governance, or economic allocation as mathematical
authority, and it discloses no private research content to Torus.

## 1. The useful separation

Torus supplies a concrete model of a recursive **control and resource graph**.
This repository is building a **proof-carrying epistemic graph**.  The clean
composition is directional:

\[
\text{claims, evidence, dependencies, and replay}
\xrightarrow{\text{plural, revisable value signals}}
\text{permissions, tasks, capabilities, and resources}.
\]

The allocation plane may choose what receives attention or budget.  It may not
promote a theorem, accept an equivalence, or alter a proof checker.

## 2. Public mechanisms

| mechanism | public implementation | research-system lesson | boundary |
|---|---|---|---|
| agents and admission | on-chain identities, metadata, stake, application/whitelist and registration burn | explicit worker/service identity and admission | identity is not competence or epistemic independence |
| allocator weights | stake-backed normalized weights feed linear emission | subjective attention and resource allocation | current runtime restricts weight setting to governance-designated allocators; this is not an open evaluator field |
| emission | epochal miner incentives and validator dividends from stake and weight matrices | continuous prospective research funding | the mechanism optimizes whatever allocators reward, including possible cartels or visibility |
| stream permissions | fixed or percentage streams, weighted recipients, separate managers, triggers, pause and force-execute | prospective subcontracting of budgets to solvers, auditors, or infrastructure | payment provenance does not establish causal intellectual value |
| recursive routing | received streams can be redistributed in later blocks | local groups can fund subgroups without global micromanagement | reciprocal routes can obscure responsibility or game rewards |
| namespace permissions | scoped paths, parent-child limits, inherited constraints and cascade cleanup | least-authority access to tools, data, compute and release operations | operational namespaces are not semantic identities |
| curator delegation | subsets of admission, whitelist and penalty control with limits/cooldowns | delegated operational review and quarantine | curators must never acquire theorem authority |
| enforcement authorities | threshold controllers can pause or force stream execution using off-chain judgments | circuit breakers and milestone release | signatures prove agreement, not truth of the off-chain judgment |
| governance | stake-weighted proposals and automatically executed parameter changes | explicit policy and budget change process | stake legitimacy is not mathematical validity |
| root agents and signals | documented goal leaders and demand advertisements | portfolio owners and typed residual-obligation requests | current public source does not expose every documented concept as a first-class runtime primitive |

The public source also shows an honest staged-centralization boundary: allocator
and root powers remain substantially governance/SUDO mediated.  This is a real
programmable routing substrate, not evidence that global self-optimization has
already emerged.

## 3. What to borrow first

Borrow the permission algebra before token economics:

- scopes and subscopes;
- parent-child constraints;
- expiration and revocation;
- instance and child limits;
- separate owners, managers, evaluators, and executors;
- threshold circuit breakers;
- recursively delegated budgets.

A research signal should be a typed contract containing at least:

- residual proof or computation obligation;
- allowed assumptions and forbidden shortcuts;
- desired artifact and certificate types;
- replay command and environment;
- privacy class;
- budget and deadline;
- acceptance policy and reviewer independence requirements.

No blockchain is needed to test this locally.

## 4. Missing value layer

Research needs two distinct accounting systems:

1. **Prospective allocation:** commit resources to a dependency before it is
   solved.
2. **Retrospective causal credit:** recognize that a lemma, counterexample,
   translation, audit, or kernel later discharged many obligations.

Continuous visible-output rewards systematically underprice delayed,
negative, and option value.  Credit should attach to content-addressed
contributions and recorded downstream reuse rather than only to whole-agent
reputation.  Evaluators are conflicted actors and require plurality,
calibration history, disclosed dependencies, adversarial review, and frozen
controls.

## 5. Adoption gate

Before importing a global allocator, run a private local simulator comparing:

- the current high-context manual integrator;
- simple fixed portfolio rules;
- recursive evidence-derived routing.

Use preregistered workloads and separately report verified dependency cuts,
redundancy, latency, missed synthesis, delayed/negative-result support,
capture resistance, and verification debt.  Allocation gains never alter
claim status.

## 6. Primary public sources

- [Torus runtime](https://github.com/renlabs-dev/torus-substrate)
- [Permission0 recursive delegation](https://github.com/renlabs-dev/torus-substrate/blob/main/docs/permission0.md)
- [Linear emission algorithm](https://github.com/renlabs-dev/torus-substrate/blob/main/docs/linear-emission.md)
- [Torus concepts](https://docs.torus.network/explanations/concepts-terminology/)
- [Root agents](https://docs.torus.network/explanations/goal-leaders/root-agents/)
