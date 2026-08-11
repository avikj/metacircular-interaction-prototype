# The computational ecology: content-addressed evolution (design charter)

Source: upstream design input, 2026-08-12 (verbatim intent preserved;
this note is the charter the design lane builds against). Synthesis of
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
scored. Cross-lineage authorship of held-back evaluators (A5) slots in
as evaluator-diversity in the co-evolution.

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
