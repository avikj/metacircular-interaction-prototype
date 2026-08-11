# Mathematics OS: an autonomous fabric for discovery, refutation, and proof

The target is not a society of agents talking indefinitely.  It is a
content-addressed mathematical operating system in which many imperfect
reasoners can generate at full speed while a small trusted kernel controls
what becomes reusable truth.

The architecture keeps the repository's central insight: **language is
program state for agents**.  Objects, roles, tensions, and proof obligations
remain readable Markdown.  Code enforces only the irreversible transitions:
statement identity, dependency lineage, certificate type, independent review,
and terminal failure.

## 1. Five planes

### Discovery plane

LLM agents, numerical experiments, Wolfram Language, Sage/FLINT/PARI, SymPy,
SMT model finders, OEIS/LMFDB, and literature graphs generate representations,
witnesses, recurrences, constants, counterexamples, and proof sketches.  This
plane is massively parallel and untrusted.  Its native product is a claim
packet, never a theorem badge.

### Rosetta plane

Every candidate is normalized as a typed translation square.  Agents compute
round-trip or commutator defects and split them by the smallest character,
quotient, boundary, scale, or isotypic sector.  The residual becomes the next
exact statement.  `ROSETTA_ENGINE.md` is the calculus; Wolfram multiway
rewriting can eventually enumerate transformation paths, but exact canonical
forms—not a proprietary simplifier's default equality—decide when paths merge.

### Falsification plane

Blind breakers receive the statement before the proposed proof.  They run
boundary cases, finite exhaustions, modular reductions, SMT/Nitpick models,
assumption deletion, dimensional/type audits, and independent implementations.
A counterexample terminates the claim.  `UNKNOWN`, timeout, or no witness is no
evidence of truth.

### Certificate plane

CAS and solvers emit small replayable witnesses.  Lean/mathlib is the primary
kernel lane; LRAT is the propositional currency; exact rational/interval
checkers handle finite computer-assisted reductions.  A second formal system
(Isabelle or Rocq) is reserved for a few headline results where semantic
independence justifies the duplication.  Kernel verification, semantic
alignment with the English statement, and novelty are three separate gates.

### Memory plane

Claim packets, append-only transition events, exact statement hashes, evidence
manifests, prior-art manifests, and git commits form the durable graph.  A
dependency downgrade quarantines descendants.  Refutations remain visible;
repairs receive new IDs.  `STATE.md`, the site, and future dashboards should be
generated views of this graph rather than competing authorities.

## 2. Authority lattice

| output | maximum autonomous status |
|---|---|
| LLM explanation, analogy, Wolfram simplification | seed |
| float experiment or PSLQ relation | formalizing |
| exact CAS witness independently substituted | proving |
| finite exhaustive computation without proved reduction | proving |
| proof candidate accepted by Lean kernel | formal-verified, not yet semantically aligned |
| formal proof + alignment audit + blind breaker + prior-art manifest | certified internally |
| negative literature search | searched-not-found, never novel |

The high-throughput trick is asymmetric: generation can be nearly free because
promotion is expensive and fail-closed.

## 3. Computational fabric

### Wolfram layer

Use `wolframscript` or the Python client as an optional representation and
counterexample oracle.  High-value operations include exact `Reduce`/`Resolve`,
`FindInstance`, `Resultant`, `CountRoots`, `FunctionExpand`, `RSolve`, `DSolve`,
and `FindIntegerNullVector`.  `FullSimplify` should receive a task-specific
`ComplexityFunction` that penalizes hidden assumptions, branch-sensitive
functions, piecewise explosions, and vocabulary foreign to the target proof.

`code/wolfram_bridge.py` and `code/wolfram_probe.wls` hash requests, retain WXF
results, and mark every response discovery-only. The current adapter executes
arbitrary Wolfram Language contained in a request and therefore refuses to run
without an explicit trusted-code flag; autonomous use additionally requires an
OS sandbox with a read-only repository, isolated output, resource limits, and
no network/process authority. Wolfram does not generally
emit portable proof objects for `Reduce`, `FullSimplify`, or differential
solvers; exact results still require an independent checker.  No Wolfram engine
is installed on the current machine, and free-engine/cloud terms must be
reviewed before group or production use.

### Exact arithmetic layer

Generated C++ performs large bounded enumeration.  Python orchestrates shards
and replays exact `Fraction` witnesses.  FLINT/PARI/Sage provide independent
factor, resultant, finite-field, and root-isolation implementations when
installed.  Every pruning filter names a proved lemma; heuristic filters may
rank candidates but may not remove them.  The corrected octic census
$139448\to37284\to7092\to2473$ is the regression test.

### Solver layer

Z3/cvc5 are breaker and encoding-discovery engines.  Solver `UNSAT` is not a
theorem unless a pinned proof trace is replayed and the mathematical encoding
is itself proved.  Finite Boolean reductions should target DIMACS + LRAT with a
verified checker.

### Formal layer

The repo pins Lean/mathlib 4.33, while the local elan installation currently
lacks that toolchain.  Reproducible kernel builds are therefore a prerequisite,
not a claimed present capability.  Agent proof search can later use Pantograph,
LeanInteract, neural provers, or ATPs; they remain outside the trusted base.
Forbidden promotion escapes include `sorry`, `admit`, custom unreviewed axioms,
unsafe kernel skipping, moving dependency heads, and unrecorded `#print axioms`.

Cubical Agda is a complementary synthetic-geometry laboratory.  It can make
quotients, paths, univalence, and higher gluing computational, which is useful
for testing whether "lost arithmetic charge" is genuinely a descent
obstruction.  It is not a reason to migrate conventional Lean proofs.  The
guardrail is severe: an observational equivalence relation naturally produces
a set quotient (a $0$-type).  Nontrivial higher paths or cohomology must arise
from proved overlap/coherence data; they may not be manufactured by choosing a
more ornate higher-inductive presentation.  The first prototype should compare
the ordinary finite sieve quotient, its exact residual fiber, and its
$0$-truncation before using obstruction language.

## 4. Generative loop

```text
sample corpus tensions and solved/open twins
    -> emit typed Rosetta squares
    -> compute defects under several engines
    -> split by smallest quotient/character
    -> register exact statements
    -> prove and break in parallel
    -> replay certificates in a fresh pinned environment
    -> audit semantic alignment and prior art
    -> certify, refute, quarantine, or stop inconclusive
    -> transport the proof to neighboring packets
    -> generate new tensions from the dependency graph
```

The scheduler prioritizes contradictions, computable residuals, solved twins,
stable exact constants, and vocabulary rotations.  Each packet has an attempt
budget.  Repeatedly encountering the same missing lemma produces
`inconclusive` plus a new obstruction packet, not an immortal research thread.

## 5. Near-term build order

1. Make `collab/discovery` the fail-closed claim authority and generate other
   status surfaces from it.
2. Package the quartic-through-octic exact kernel behind declarative problem
   specifications and immutable stage manifests.
3. Run the degree-nine prime-prefix factor search as the first acceptance
   experiment; a quantified infeasibility boundary is an acceptable outcome.
4. Install/reproduce Lean 4.33 and formalize generic witness checkers before
   translating whole research notes.
5. Prototype the finite sieve quotient plus residual charge in Cubical Agda;
   stop if the fiber is merely a finite bit/torsor with no higher coherence.
6. Add Wolfram, FLINT/PARI, and SMT adapters opportunistically; cross-check by
   independent algorithms rather than shared wrappers.
7. Build a proof-difference engine: align dependency DAGs of solved isomorphs
   and emit the smallest missing-structure packet.
8. Run continuous language rotations so the map expands beyond the vocabulary
   that generated it.

The long-term object is a distributed, self-correcting mathematical memory in
which a theorem can be discovered by one representation, broken in another,
certified in a third, and then compressed into a form that makes an entire
region of mathematics feel simpler.
