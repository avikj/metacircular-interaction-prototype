# Constellation Network technical archeology

**Status: public-source design audit, not endorsement.** Sources were checked
2026-08-12. Statements below distinguish primary-source fact, direct code
inspection, mathematical audit, and inference.

## 1. Compressed verdict

Constellation's founding technical architect was co-founder and CTO **Wyatt
Meldman-Floch**, not Mathias Goldmann. The 2017 founding paper proposed an
asynchronous DAG, gossip, per-account histories, concurrent checkpointing,
typed JVM microservices, and reputation-weighted delegate selection. Its
research vocabulary was unusually broad: recursion schemes, tensor products of
reputation feature spaces, temporal PageRank, protocol complexes, homology,
sheaves, and homotopy type theory.

The sober finding is two-sided.

1. This was not merely a later marketing story. Public papers, talks, and code
   contain real implementations of several ideas: typed functional Scala,
   concurrent snapshot consensus, EigenTrust, directed transitive trust, and
   self-avoiding-walk scoring.
2. The highest mathematical claims were aspirational or invalid as written,
   and the grand unification did not become the production protocol's verified
   mathematical substrate. Current code says trust scores have only one
   remaining live consumer, recovery-download peer selection; current public
   docs describe stake/slashing and deterministic facilitator selection, while
   PRO remains partly future-facing.

The evidence therefore supports **technical narrowing**, but not the causal
claim that greed caused it. Commercial and token-economic emphasis is plainly
larger now; public evidence does not establish why.

## 2. Chronology from primary sources

### 2017: a blockchain microservice operating system

The earliest located whitepaper, dated 25 November 2017, calls Constellation a
"blockchain microservice operating system." It proposes:

- horizontal scaling by concurrent DAG computation and gossip;
- an ExtendedTrustChain with basic nodes, checkpoint processes, and validators;
- JVM/Scala smart contracts as composable, variance-aware typed microservices;
- HyloChain, described through anamorphism/catamorphism;
- Proof-of-Meme delegate selection.

Proof-of-Meme begins with a node-level **feature vector** described as a tensor
product of feature spaces, inspired by REGRET. But it is then explicitly mapped
by a deterministic model to **one reputation score**, which determines a
selection probability. Temporal PageRank, GURU, clustering, and model training
are written prospectively: “will first replicate,” “to-be-trained,” and “will
probably be implemented.” The vector is not shown to be functorially preserved
through DAG composition.

Primary source: [2017 whitepaper PDF](https://api-new.whitepaper.io/documents/pdf?id=SJkBN964X),
especially pp. 1–5 and 10–12.

### 2018–2019: protocol topology as a research pillar

Meldman-Floch's 2018 *Blockchain Cohomology* represents executions by
simplicial/protocol complexes and attempts to connect chain homology,
cohomology, incidence algebras, sheaves, recursion schemes, and HoTT. A revised
paper appeared in the 2019 MACSPro proceedings.

Primary sources: [arXiv v1 and source](https://arxiv.org/abs/1805.07047),
[2019 proceedings paper](https://ceur-ws.org/Vol-2478/paper2.pdf).

An August 2019 CTO update calls cohomology, an economic information measure,
and MEME the protocol's three pillars. MEME is described as an ensemble of
EigenTrust, self-avoiding-walk node influence, and GURU; the stated vision is a
queryable, interoperable distributed database whose data streams can be mixed
through developer-defined algebra/coalgebra.

Primary source: [Meldman-Floch technical update](https://constellationnetwork.io/blog/2022-08-16-constellation-technical-update/)
(the page itself dates the post 26 August 2019 despite the present URL slug).

### 2020 onward: Hypergraph, metagraphs, snapshots, applications

The surviving production line is recognizable: parallel local validation,
snapshots, a Global L0, application-specific subnetworks formerly called state
channels and now metagraphs, and Scala/JVM software. The product vocabulary is
now “verifying the world's data,” metagraph business logic, custom tokens,
snapshot fees, validator staking, and enterprise/federal/AI data products.

Primary sources: [current consensus docs](https://docs.constellationnetwork.io/network-fundamentals/consensus),
[HGTP economy](https://docs.constellationnetwork.io/network-intro/white-papers/the-hgtp-economy),
[current public positioning](https://constellationnetwork.io/hypergraph/).

## 3. What the mathematics actually supports

### 3.1 Reputation: useful graph mathematics, deliberately scalarized

The current `develop` branch contains three explicit algorithms:

- EigenTrust: iteration of a normalized nonnegative trust matrix toward a
  global score vector;
- DATT: positive transitive propagation from each node's subjective trust map,
  with path products and weighted merging;
- self-avoiding random walks: Monte Carlo propagation on positive trust edges,
  with negative-edge feedback;
- `TrustModel`: the unweighted arithmetic mean of the three scalar outputs.

Source: [trust implementation directory](https://github.com/Constellation-Labs/tessellation/tree/develop/modules/dag-l0/src/main/scala/io/constellationnetwork/dag/l0/infrastructure/trust).
Git history dates the compound model to 9 December 2021.

This is substantive graph computation. It is **not** a preserved graded defect,
a proof object, or an epistemic authority. Heterogeneous observations are
compressed to `Double` scores, and the three algorithm outputs are averaged.

More decisively, the current updater's source comment says that the only
remaining live consumer of trust scores is recovery-download peer selection;
the cadence was reduced from one minute to one hour after an audit found the
trust rumor consumed about 20% of gossip traffic. Source:
[TrustStorageUpdater.scala](https://github.com/Constellation-Labs/tessellation/blob/develop/modules/dag-l0/src/main/scala/io/constellationnetwork/dag/l0/infrastructure/trust/TrustStorageUpdater.scala).

### 3.2 Cohomology: the perception was stronger than the reconstruction

The core perception is legitimate and important: distributed task protocols
can be represented by simplicial complexes, and homological obstructions can
encode impossibility of distributed agreement. That is established prior art
which the paper cites.

The 2018 paper's own deductions are not load-bearing. Direct inspection of its
TeX source finds, among other defects:

- the simplicial boundary coefficient is printed `(-i)^(i-1)` rather than
  `(-1)^(i-1)`;
- the asserted chain complexes are not supplied with maps whose composite is
  proved zero; instead vanishing is repeatedly inferred from the desired
  terminology;
- a homotopy equation is replaced by a composition of differentials without a
  typed equality justifying the replacement;
- Poincaré duality is declared “clearly” from vanishing differentials, without
  the manifold, orientation, cap product, dimension, or nondegenerate pairing
  required by the theorem;
- “liquidity” is only the existence of a functorial vertex map and its
  applications are explicitly left to the reader.

Thus the paper is best treated as a research sketch importing a fertile
language, not as a theorem establishing security, scalability,
interoperability, or fork prevention. Conference publication establishes
provenance, not correctness of those claims.

*Follow-up (2026-08-12):* `notes/ARXIV_1805_07047_SOURCE_AUDIT.md` grounds
each bullet above at its source line in both the arXiv v1 and proceedings
TeX, extends the catalog to twenty defects in four classes, and adds the
revision record — including that the `(-i)^{i-1}` coefficient is a v1 defect
corrected in the 2019 proceedings version, and that the project's own
internal reviewer flagged the well-formedness problems in August 2018.

## 4. Did finance displace the founding vision?

### Sourced facts

- The 2017 paper was already aimed at consumer applications and enterprise
  adoption; commercialization was present at the founding, not a later
  intrusion.
- In 2019, the CTO still publicly presented cohomology and reputation research
  as protocol pillars.
- The current code retains the reputation algorithms but documents their narrow
  live role.
- Current consensus docs foreground stake, slashing, deterministic selection,
  layered snapshots, and metagraph business logic. They describe PRO as a trust
  layer and also place further PRO behavior in future releases.
- Current economy documents explicitly make `averagePROScore`, staked DAG,
  resource demand, and fees inputs to incentives.

### Inference, with confidence

**High confidence:** the mathematical research program was operationally
narrowed. Its cohomological/type-theoretic unification is absent from the
current protocol specification, while reputation moved from the claimed core
of consensus toward a small operational role plus future roadmap.

**Moderate confidence:** product and token-economic priorities displaced some
research attention. The public artifact mix shifted markedly toward fees,
staking, metagraph tokens, enterprise data, wallets, and products.

**Unsupported:** that founders were “distracted by money,” or that commercial
motives caused the narrowing. Engineering difficulty, invalid mathematics,
security requirements, performance costs, personnel changes, and market
survival are live alternative explanations. Public artifacts do not identify
the cause.

Forecast resolution: mostly the registered `0.55` branch, corrected by the
important continuity that the original paper was commercial from page one.

## 5. Reusable mathematics for a distributed discovery engine

### Borrow

1. **Subjective trust remains local.** Constellation's strongest design choice
   is that peers may maintain different trust views. For research, a builder,
   breaker, formal checker, and literature auditor should have typed,
   role-specific reliability views rather than one global reputation.
2. **Evidence graph before score.** Record signed observations and causal edges;
   derive routing weights as revocable views. Never let the score replace the
   evidence.
3. **Transitive trust with decay and path provenance.** DATT's path products
   suggest a useful routing prior: confidence transferred through independent
   audits should decay and retain its path. Merge by an explicit rule, not an
   opaque model.
4. **Random-walk centrality as a routing experiment only.** Self-avoiding walks
   can expose isolated or overly self-confirming clusters. They may prioritize
   review, never certify a claim.
5. **Concurrent local consensus, global snapshots.** Independent claim domains
   can validate locally and periodically emit deterministic, content-addressed
   snapshots into a global research graph.
6. **Typed composition.** The 2017 microservice/type-signature intuition is
   valuable when strengthened: compose theorem transports only when hypotheses,
   structures preserved, checker policy, and output type match.

### Do not borrow

1. averaging heterogeneous evidence into one scalar authority;
2. reputation as a substitute for proof or adversarial replay;
3. “cohomology,” “fractal,” “entropy,” or “Poincaré” without a defined complex,
   differential, invariant, and proved interface to the implementation;
4. stochastic, locally divergent values inside consensus-critical signed bytes;
5. token reward as the definition of epistemic value.

The reusable synthesis is therefore not Proof-of-Reputable Observation. It is
**proof-relevant observation**: keep observations typed and signed, preserve
their dependency paths and disagreements, derive multiple local routing views,
and reserve truth promotion for replayable certificates.

## 6. Rigor boundary

- **Cited:** public documents, papers, and current source-code statements.
- **Directly inspected:** `tessellation` `develop` at commit
  `481d80872fbf4226112861b75a6b8af057fe53eb` (2026-08-11), its trust sources,
  and the complete arXiv v1 TeX source.
- **Not performed:** deployment telemetry, private roadmap review, security
  audit, interviews, or historical checkout/build of every release.
- **Inference only:** causes of technical narrowing and organizational intent.
