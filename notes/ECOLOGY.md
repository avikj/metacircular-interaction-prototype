# Computational-ecology analogy (archived design input)

**Status: non-canonical metaphor and historical design input.**  The operating
architecture is `RESEARCH_SYSTEM.md`.  Content addressing and provenance are
concrete mechanisms; environment-indexed evaluation and recursive delegation
are retained as specific design candidates.  Biological ontology does not.
No population dynamics,
co-evolution loop, or demonstrated evolutionary advantage is implemented.
The vocabulary below is retained so its proposals and failure modes remain
auditable, not because the repository is presently an ecology.

Headings and imperative language such as `mandatory` and `Build order` below
are preserved historical text, not current instructions.  The only active
build order is `RESEARCH_SYSTEM.md` §9.

Source: upstream design input, 2026-08-12 (verbatim intent preserved).  This
was originally written as a charter and is now superseded.  Synthesis of
three components: **Unison-style content addressing** (ontology of
immutable computation), **DGM** (open-ended hereditary search),
**agents** (semantic mutation operators). Post-cutoff pins required:
Hyperagents 2026 (editable meta-agent) and Red Queen Gödel Machine
(co-evolved evaluators) [prior-art check].

## The principle (boxed, verbatim)

**Everything that can evolve should inhabit the same content-addressed
universe.** Agents, mutations, prompts, tools, evaluators,
environments, memories, task generators, selection policies, inference
policies, and the evolutionary operators themselves: immutable
content-addressed objects connected by provenance. The swarm is not a
swarm; it is a self-extending computational ecology whose state is a
Merkle-DAG — the DAG is not an implementation convenience, it IS the
evolutionary state space.

## The ontology table (the evolutionary unit is NOT the agent)

| biology | ecology object |
|---|---|
| organism | agent (root hash + component set) |
| organ | planner / verifier / memory subsystem |
| gene | individual content-addressed function/module |
| allele | alternative implementation of the same interface |
| genome | dependency DAG: A = {h₁,…,hₙ} + entrypoint |
| mutation | sparse graph rewrite: A′ = A − {h_k} + {h′_k} |
| inheritance | hash reuse (deduplication intrinsic) |
| recombination | compose subgraphs from different ancestors |
| phenotype | runtime behavior under an environment |
| fitness | empirical evaluations (separate, see below) |
| phylogeny | provenance DAG |

Payoffs over repo-level DGM heredity: lineage nearly free; useful
innovations NOT entangled with their branch (crude heredity is DGM's
weakness); recombination without an LLM "merging repositories" (a
child references A's context-compressor hash AND B's patch-selector
hash); and population genetics becomes computable: "#84ab appeared in
lineage 381, survived 37 descendant architectures, correlates +11% on
long-horizon tasks" — gene-level fitness attribution.

## The one early design decision (mandatory)

**Genotype ≠ phenotype.** Content hash identifies the artifact;
evaluations are separate append-only observations:

Evaluation = (H_agent, H_environment, H_model, H_tasks, H_evaluator, result)

Performance must never contaminate identity: every empirical claim
reproducible; old genotypes continuously reinterpretable under new
environments without rewriting.

## What this repo already got right (retrofit map)

The claims registry IS this pattern for theorems: statement_hash =
genotype identity; append-only event chains = phenotype observations;
Codex's bound-contracts and CPU work units are content-addressed;
FAILURES.md yields are fitness observations on ideas. The generalization:
extend the same separation from claims to the agent layer. DGM_APPLICATION
A1's sequential genome ids are hereby superseded: genome id := content
hash (canonical bytes), parentage recorded as provenance edges, and the
A3 evaluation suite emits Evaluation tuples in the schema above.

## Red Queen and Hyperagents integration

Evaluators and the mutation-generating meta-agent are themselves
objects in the DAG — evolvable, with the same genotype/phenotype
separation. Anti-objective-hacking guardrail becomes structural: an
evaluation cites H_evaluator, so a gamed evaluator is identifiable and
its observations quarantinable WITHOUT touching the genotypes it
scored. Cross-lineage authorship of never-queried final evaluators (A5)
slots in as evaluator-diversity in the co-evolution.

This is a between-epoch design possibility, not permission for an evaluator
to rewrite itself during a run.  The pilot controller and evaluator remain
frozen; a proposed replacement is a new content-addressed object, passes an
external review and anti-gaming gate, and starts a new epoch.  It never
retroactively changes an observation or self-adopts.

## Isomorphism as identity: the univalent substrate (upstream, 2026-08-12)

Byte-hashing is the 0-truncated approximation. The opportunity: address
up to EQUIVALENCE — a hierarchy of decidable quotients, each a design
choice about what "the same gene" means:

h₀ (bytes) → h_α (AST, names abstracted — Unison's move) → h_norm
(normalized/optimized form) → h_obs(H_tests) (observational equivalence
UNDER A HASHED TEST ENVIRONMENT — decidable, environment-indexed).

Consequences:
1. **Gene vs allele becomes precise**: gene = equivalence class under
   the chosen quotient; allele = member. Distinct h₀, same interface +
   h_obs(E) ⇒ alleles of one gene.
2. **Convergent evolution is detectable and IS a fitness signal**: two
   lineages independently reaching the same h_obs class = independent
   replication — the strongest evidence class our norms recognize.
3. **Transport of fitness along witnesses** (the univalent move):
   store the isomorphism WITNESS, not just the quotient; evaluations of
   A transport to A′ along the witness with an explicit discount. Data
   efficiency: every observation informs a whole equivalence class.
4. **Multi-resolution is mandatory, not optional**: quotient too coarse
   collapses alleles and kills neutral variation (evolution needs it);
   too fine loses attribution. Keep ALL levels; queries pick their
   resolution. Population genetics runs at gene level; selection
   preserves allele diversity.
5. **The corpus is the theory of this substrate**: full semantic
   equivalence is undecidable (Rice), so every usable quotient forgets
   something — and "what a quotient forgets" is UNIFICATION's exact
   subject. Homometry is the canonical counterexample (same
   observations, different objects) warning that h_obs is
   environment-relative, never absolute; Codex's CUBICAL_QUOTIENT_AUDIT
   ("a charge descends iff it respects observational equivalence") is
   the descent criterion for which properties survive each quotient;
   univalence is the type theory in which isomorphism-as-identity is
   not a hack but an axiom. The mathematics and the infrastructure have
   converged on one subject.

### Trust correction: observation is not isomorphism

The hierarchy above is a search view, not a hierarchy of equally authoritative
identities.  Equality of bytes or of a certified canonical presentation is an
exact content claim.  Equality on a finite hashed test environment is only an
environment-indexed behavioral fingerprint: it may nominate an equivalence
witness search, but it does not merge objects, certify an isomorphism, or count
as independent mathematical replication by itself.  Homometric examples are
the reason, not an edge case.

Likewise, fitness does not automatically transport with a numerical discount.
Reuse across distinct presentations requires a checked equivalence under an
explicit structure theory plus a theorem or verified operator showing that the
evaluation is invariant (or specifying exactly how it transforms).  Multiple
witnesses and automorphisms remain data; a connected-component/class hash is a
head-scoped view, never the durable identity of an object.  The complete
fail-closed contract is `notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md`.
Univalence motivates witness-indexed transport inside a specified structural
universe; it is not an infrastructure axiom that makes arbitrary observations
or records equal.

## Build order (design lane)

1. Object store convention: sha256 of canonical content; objects under
   `collab/ecology/objects/` (or content-addressed via git blobs —
   decide; git already IS a content-addressed store, exploit it).
2. `EVALUATIONS.jsonl` append-only, the 6-tuple schema, first entries:
   retrofit the A3 suite runs and the R0015 verification (an Evaluation
   of the zeta-23 genotype under our environment).
3. Migrate genomes: G0001 → its content hash; brief headers carry
   component hashes (prompt, tool list, evaluator).
4. Gene-level attribution queries over the provenance DAG (the
   population-genetics layer) — first analysis target: which brief
   components correlate with yield-rich walks across our 60+ launches.
5. Co-evolution loop last, gated by A3 + cross-lineage evaluators.
