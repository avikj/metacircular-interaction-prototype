# Wolfram adoption map: use the computational paradigm, do not clone it

This note records a source-level technology decision for the research program.
Wolfram Research has spent decades building a unified symbolic language,
algorithm-selection machinery, computational knowledge, exact algebra and
logic, theorem-search tools, parallel symbolic evaluation, and—more
recently—multiway/metamathematical exploration. We should interface with that
stack, not reproduce a weaker version of it.

The sources below are official Wolfram documentation and writings unless a
corrective research article is explicitly named. Product output remains a
discovery artifact unless independently certified.

## 1. The adopted stack

### Official agent interface

Wolfram now publishes the
[Wolfram Foundation Tool MCP](https://www.wolfram.com/artificial-intelligence/mcp/).
The Cloud MCP is a stateless, one-shot route to basic Wolfram Cloud,
Wolfram|Alpha, the Wolfram Language, and the knowledgebase. The Local MCP,
included with appropriate Wolfram products, supplies persistent sessions,
local files, and notebook access. The documented Cloud endpoint is

```text
https://agenttools.wolfram.com/mcp
```

The remote endpoint is **not configured for this project**.  Even a nominally
private computation would transmit an unpublished expression outside the
repository boundary.  Until the human owner explicitly releases material,
the adopted route is a locally licensed Wolfram kernel/Local MCP in a sandbox,
with network disabled and content-addressed inputs and outputs.  Public
documentation and already-public examples may still be studied normally.

The repository's `wolfram_bridge.py` remains a sandbox/provenance prototype,
not a parallel product implementation.  It must not invoke a cloud endpoint or
an unsandboxed kernel on agent-authored expressions.

### Symbolic theorem and counterexample tools

Use the built-in [theorem-proving
suite](https://reference.wolfram.com/language/guide/TheoremProving.html):

- `Reduce` and `Resolve` for exact quantified semialgebraic and logical
  problems;
- `FindInstance` for counterexample/witness generation;
- `FullSimplify` and `FunctionExpand` for representation search under explicit
  assumptions;
- [`FindEquationalProof`](https://reference.wolfram.com/language/ref/FindEquationalProof.html)
  for Knuth--Bendix-based equational search with an inspectable `ProofObject`.

The boundary matters. `FindInstance` returning no witness is not a portable
impossibility certificate. `Reduce`/`Resolve` output is exact solver output but
does not currently provide a proof object that our Lean kernel can replay.
`FindEquationalProof` has proof objects, but arithmetic operators require their
axioms to be supplied. Load-bearing results therefore need exact substitution,
an independent CAS derivation, or formal replay.

### Structure recognition

Use Wolfram's mature recognition engines before inventing bespoke PSLQ or
sequence heuristics:

- [`FindSequenceFunction`](https://reference.wolfram.com/language/ref/FindSequenceFunction.html),
  `FindLinearRecurrence`, and `FindGeneratingFunction`;
- [`FindFormula`](https://reference.wolfram.com/language/ref/FindFormula.html)
  for ranked symbolic models;
- `RootApproximant`, `IntegerRelations`, and exact `Root` objects;
- `MathematicalFunctionData` and the curated knowledgebase.

Recognition proposes a formula; held-out exact values and a proof obligation
decide it. Search multiplicity, target-function choice, and numerical precision
must be recorded.

### Multiway proof and representation exploration

The Function Repository's
[`MultiwaySystem`](https://resources.wolframcloud.com/FunctionRepository/resources/MultiwaySystem)
already exposes states, events, branch pairs, critical-pair resolutions,
Knuth--Bendix completion, path weights, causal graphs, and custom state
equivalence. Stephen Wolfram's
[physicalization of metamathematics](https://writings.stephenwolfram.com/2022/03/the-physicalization-of-metamathematics-and-its-implications-for-the-foundations-of-mathematics/)
identifies proofs with paths/subgraphs in such entailment spaces; his
[empirical metamathematics](https://writings.stephenwolfram.com/2020/09/the-empirical-metamathematics-of-euclid-and-beyond/)
studies theorem-dependency geography; and
[observer theory](https://writings.stephenwolfram.com/2023/12/observer-theory/)
models observation as equivalencing many external states into a reduced
internal state.

This is the natural execution engine for the Rosetta program:

1. states are typed mathematical expressions with assumption records;
2. events are allowed exact translations;
3. state equivalence is a domain-specific canonical form or proved equality;
4. unresolved branch pairs are defect/theorem seeds;
5. a target-specific complexity function ranks compressed representations.

Finite-depth agreement is evidence, not a global confluence theorem. The
Wolfram corpus itself contains important corrective work: Piskunov's
[Confluence and Causal
Invariance](https://bulletins.wolframphysics.org/2020/11/confluence-and-causal-invariance/)
exhibits counterexamples to naive equivalences between confluence and causal
graph isomorphism. We therefore use multiway exploration as a generator of
critical pairs and paths, never as metaphysical proof.

### Parallel and compiled computation

The Wolfram Language already supplies
[distributed symbolic kernels](https://reference.wolfram.com/language/Parallel/tutorial/Introduction.html?view=all),
virtual shared state, failure recovery, cluster integration, and WSTP transport
of arbitrary symbolic expressions. Compiled listable functions can run in
parallel and target C, as documented in the
[compiler parallelization guide](https://reference.wolfram.com/language/Compile/tutorial/Parallel.html.en).
WSTP is the high-level symbolic interprocess protocol.

Therefore:

- use Wolfram parallel kernels for symbolic scans, exact transformations, and
  expression-space exploration;
- use generated C++/FLINT for very large bounded integer enumeration;
- use local WSTP/MCP/WXF to cross the symbolic boundary without flattening
  exact objects;
- use our CPU ledger only for immutable sharding, artifact hashing, and
  independent replay—not as a replacement for Wolfram's scheduler or language.

## 2. The division of intelligence

The intended loop is

```text
frontier agents
    -> choose a tension, representation and theorem target
Wolfram / CAS / SMT discovery engines
    -> simplify, recognize, search paths, generate witnesses and counterexamples
compiled exact kernels on many CPUs
    -> exhaust the proved finite reduction and emit content-addressed witnesses
Lean / Cubical Agda / independent exact checkers
    -> certify the precise surviving claim
frontier agents
    -> interpret anomalies, change language, and choose the next theorem
```

Agents remain the research intelligence. Traditional programs are distilled
kernels of already-discovered mathematical understanding: cheap to replicate,
fast to run, and incapable of silently changing the question.

## 3. What remains ours

We should build only the interfaces Wolfram does not solve for this project:

1. exact typed preservation ledgers connecting an English research target to
   each transformed formula;
2. proof-labeled pruning rules and dependency invalidation;
3. cross-engine artifact manifests and independent replay;
4. arithmetic-specific reductions, tail lemmas, and formal statement alignment;
5. a scheduler that chooses the next *research tension*, not the next CPU task.

The octic/nonic Graeffe orientation failure is the canonical test. Wolfram can
expand the polynomial, derive bounds, and parallelize the scan. Our additional
obligation is to bind every coefficient index to the exact majorant it uses and
have a differently encoded checker reject a reversed list before any census is
promoted.

## 4. Immediate experiments after a local kernel is installed

1. Send the nonic `E(y)^2-y O(y)^2` identity and both coefficient-bound
   orientations to Wolfram; demand exact coefficient association, not a bare
   vector, then compare with SymPy and direct convolution.
2. Encode the Rosetta transform vocabulary as a finite `MultiwaySystem`; use
   exact canonical forms as state equivalence and harvest unresolved critical
   pairs as claim seeds.
3. Run `FindSequenceFunction`, `FindGeneratingFunction`, `RootApproximant`, and
   `FindFormula` against the repository's unexplained coefficient/cutoff
   ledgers, with held-out terms unavailable during discovery.
4. Use `Reduce`/`FindInstance` as breaker lanes for coefficient boxes and
   proposed universal inequalities.
5. Compare Wolfram exact resultants/root counts with FLINT/SymPy and the
   independently written certificate kernels.

These experiments adopt Wolfram's wheel while retaining a smaller trusted
core than any one proprietary system.
