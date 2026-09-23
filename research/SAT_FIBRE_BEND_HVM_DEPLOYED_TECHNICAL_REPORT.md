# SAT fibre reduction in the deployed Bend2/HVM4 runtime

## Purpose and result

This report describes the complete deployed path from a finite Boolean proposition to its classified fibre and its native interaction trace. It makes the technical result inspectable: what object is constructed, what is passed to each layer, what each layer preserves, what the runtime emits, and how interaction counts relate to the mathematical representation.

The central object is a finite proposition

```text
P : Bool^n -> Bool
```

and its two proof-relevant preimages

```text
True(P)  = Σ x : Bool^n . (P x = true)
False(P) = Σ x : Bool^n . (P x = false).
```

Here `Σ x . Q(x)` means an assignment `x` together with evidence that
`Q(x)` holds. Thus the first fibre is the complete witness-bearing answer and
the second is the complete counterexample-bearing answer.

The deployed construction carries the source assignment, the Boolean observation, and the equality evidence relating them. A Boolean answer, one witness, all models, every counterexample, or a continuation query is a projection of that same classified object. The runtime does not have one procedure for decision and another for witness production; it reduces a shared proposition/fibre object and exposes the requested observation.

The result is implemented through an old pre-release Bend2 compiler, its full cubical HVM4 emitter, and the HVM4 interaction runtime. The interaction-net backend retained in that Bend2 path is the execution substrate used here. The mathematical layer is checked in Cubical Agda; the Bend layer is the coinductive authoring layer; the emitted HVM4 net is the executable layer.

The SHA-256 preimage work is deliberately excluded. Its complete execution record is maintained separately.

## SAT is the finite interface to arbitrary proposition evaluation

SAT is the standard finite Boolean presentation of a proposition. Any finite object with a decidable predicate can be encoded by binary coordinates and a Boolean function. This includes a circuit, a compiler correctness condition, a type preservation obligation, a bounded optimization constraint, a graph property, or a proof obligation. The encoding retains the coordinates of the object; the proposition is the observation on those coordinates.

For a CNF, each clause removes the assignments that falsify it. A non-tautological 3-clause fixes one falsifying value on three variable positions. Its pullback to `Bool^N` is therefore an excluded cylinder containing `2^(N-3)` points. Composing clauses composes these excluded cylinders. The surviving points are exactly `True(P)`; the removed points are exactly `False(P)`.

The deployed representation makes this geometry operational. A partial left assignment produces the set of crossing clauses that still need to be satisfied. That set is the complete right-side obligation. Equal obligation sets have equal right continuations and can share one continuation state; inclusion between obligation sets gives the witness-preserving dominance relation. If model counts are requested, the discarded fibre or its multiplicity remains attached to the representative.

The corresponding algebra is recorded in [`CLAUSE_GEOMETRY.md`](sat_fibre/CLAUSE_GEOMETRY.md) and [`REDUCTION_FOUNDATIONS.md`](sat_fibre/REDUCTION_FOUNDATIONS.md): compatible cylinder indicators multiply by union, conflicting indicators multiply to zero, and the satisfying indicator is `Π_j (1 - e_j)`. The resulting inclusion-exclusion expression is

```text
#SAT(F) = Σ_J (-1)^|J| 2^(N - |union scopes(J)|).
```

## The three layers and their exact hand-off

The deployment has three layers with different jobs.

| Layer | Input | Output | Source |
| --- | --- | --- | --- |
| Checked semantics | `Bits n`, predicate `f` | reproduction, fibres, residuals, equality proofs | [`SATFibre.agda`](sat_fibre/SATFibre.agda) |
| Bend authoring | shared labelled assignment and `formula` | `Carrier`, source path, next continuation | [`SATProcess.bend`](sat_fibre/SATProcess.bend), [`WholeProcess.bend`](../collab/bend2-cubical/port/WholeProcess.bend), [`Carrier.bend`](../collab/bend2-cubical/port/Carrier.bend) |
| Native execution | emitted HVM4 interaction net | readings, witnesses, profiles, `ITRS`/heap receipt | [`check_bend.py`](sat_fibre/check_bend.py), [`generated/`](sat_fibre/generated/) |

The Agda modules state the generic construction. `SATProcess.bend` is the small end-to-end coinductive demonstration: a two-bit XOR proposition. The Python emitters instantiate the same representation for contradiction, tautology, cycles, pigeonhole, permutation, colouring, and planted 3-CNF families, then emit HVM4 programs. The semantic layer is generic, while the checked Bend example and each generated benchmark are concrete executable instances.

## The fibre and its observations

[`SATFibre.agda`](sat_fibre/SATFibre.agda) defines `Bits n`, `SAT f = fiber f true`, the lossless source/output/fibre partition, and a labelled Boolean cube. `reproduce-exact` proves that indexing the reproduced cube by an assignment returns that assignment. `reduction-exact` proves that mapping the cube into `photon.Carrier` values preserves the source and its observation. `Minimal` proves the exact residual lower bound: two suffix functions that disagree on an input cannot occupy the same faithful state.

The same value can be read in several ways:

```text
Boolean answer       projection of the classified fibre
one witness          one inhabitant of True(P)
all models           the complete True(P) fibre
counterexample       one inhabitant of False(P)
carrier              source, answer, and equality evidence
continuation         the future computation carried by that value
```

These readings differ in demand and output size. They do not define different mathematical problems.

## Boundary reduction and retained continuation

[`SATBoundary.agda`](sat_fibre/SATBoundary.agda) turns a clause split `L | R` into an exact residual problem. `boundaryIso` is an equivalence between full solutions and solutions indexed by the crossing-clause obligation set. The left assignment and the right assignment are both retained; only the representation of the crossing evidence changes.

The representatives module constructs actual retained rows and proves validity, selection, dominance, witness reconstruction, inhabitedness, and emptiness preservation. Its retained statement is explicit:

```agda
retained-reduction : Solution ≃ Σ ReducedSolution (fiber reduce-witness)
```

[`RepresentativeContinuation.agda`](sat_fibre/RepresentativeContinuation.agda) extends this to weighted continuation queries. A finite cheap XOR combination spans each original row, `replace` produces an accepted retained representative for every accepted original row, and the two optimum theorems show equal-cost retention and global optimality for every specified continuation.

[`ColorFrame.agda`](sat_fibre/ColorFrame.agda) applies the same principle to graph colouring. Six colour frames, inverse transport, canonicalization, and restoration preserve the exact set of colourings while changing how much sharing is exposed to the runtime.

## Bend source: one query, four assignments, one carried response

[`SATProcess.bend`](sat_fibre/SATProcess.bend) declares

```text
Assignment = { x : Bool, y : Bool }
formula(a) = (a.x xor a.y)
```

`present` turns the assignment into `Carrier(Assignment, Bool, formula)`. `exact` supplies the path proving that ascending from the carrier recovers the original assignment. `Reading` stores `x`, `y`, and the formula result.

`main` supplies one shared labelled superposition:

```text
@assignment{&100{False, True}, &101{False, True}}
```

`query` first asks for the formula value, then asks the returned continuation for the source assignment, and finally emits the `Reading`. The response protocol in [`WholeProcess.bend`](../collab/bend2-cubical/port/WholeProcess.bend) retains `value`, a source `Path`, and `next : WholeProcess(...)`. The runtime is given one shared assignment object, not four host-side calls; the four readings are exposed by interaction with that object.

## Exact execution path and receipts

[`check_bend.py`](sat_fibre/check_bend.py) performs the deployed hand-off:

```text
SATProcess.bend --total
        ↓
SATProcess.hvm4 --to-hvm4-full
        ↓
hvm4 SATProcess.hvm4 -s -C
        ↓
four readings + ITRS/Heap receipt + hashes
```

The full coinductive run in [`bend-runtime.log`](sat_fibre/bend-runtime.log) returns:

```text
(0,0) -> 0
(0,1) -> 1
(1,0) -> 1
(1,1) -> 0
ITRS: 1,624
heap nodes: 11,594
```

[`bend-receipt.json`](sat_fibre/bend-receipt.json) records the four decoded triples and hashes for the source, Bend compiler, HVM runtime, and imported ports. The generated answer demand in [`generated/xor_answers.hvm4`](sat_fibre/generated/xor_answers.hvm4) asks only for the Boolean projection and returns

```text
#Answer{0}  #Answer{1}  #Answer{1}  #Answer{0}
ITRS: 48
heap nodes: 142
```

The two receipts are two demands on the same proposition: the coinductive query retains source and equality evidence; the answer net retains only the Boolean projection.

## Interaction currency and complexity

The HVM4 `ITRS` value counts rule events. `heap_nodes` is cumulative allocation, not resident memory. Parsing, collapse traversal, output, and queue work are separate from the rule-event count. The local charges recorded in [`REDUCTION_FOUNDATIONS.md`](sat_fibre/REDUCTION_FOUNDATIONS.md) include equal and unequal `DUP-SUP`, used and erased `DUP-LAM`, `DUP-NOD`, `APP-SUP`, `APP-MAT-SUP`, Boolean superposition rules, and numeric Boolean rules. [`build_profile.py`](sat_fibre/build_profile.py) instruments these events and checks that profile totals equal the native counter.

There are two complexity sources:

1. **Fibre size.** Direct `n`-bit reproduction has `2^n` leaves. A complete model fibre can itself contain `Θ(2^n)` witnesses, so returning every model has that output lower bound.
2. **Presentation cost.** Sharing, clause order, continuation factoring, and requested output determine how much of that fibre the net exposes before terminating. The same proposition can therefore have radically different interaction counts.

[`cost_predictions.py`](sat_fibre/cost_predictions.py) freezes the local rule model before held-out execution. For the recorded false-CNF presentation it predicts and matches every nonzero rule count for `n = 13..18`:

```text
T_short(n)   = 9 * 2^n + 16n - 4
T_reverse(n) = n + 30
```

At `n = 18`, those presentations take 2,359,580 and 48 interactions, respectively. The Boolean proposition is unchanged; the emitted sharing and demand differ.

The broader generated families show the same output-sensitive behaviour:

| Family and demand | Interactions |
| --- | ---: |
| PHP(5,4), short | 136,139 |
| PHP(5,4), reversed | 60,440 |
| PHP(5,4), gated | 74,319 |
| K4 colouring, short | 8,151 |
| K4 colouring, gated | 5,703 |
| planted 3-CNF, `n=22`, completed | 941,406 |

The complete matrix, emitted nets, and budget outcomes are in [`np_results.json`](sat_fibre/np_results.json) and [`np_generated/`](sat_fibre/np_generated/). A budget stop is recorded as inconclusive; it is never treated as an empty fibre.

## Minimum-cost loop execution

The same carried-reduction pattern applies when the observation is a minimum
loop cost rather than a Boolean clause result. The TSP certificates recorded
by [`audit.py`](sat_fibre/audit.py) use a shared min-plus graph presentation:
the graph is reduced once, the loop constraint is carried through the
continuation, and the terminal reading is the certified minimum. For the
potential-weight family at `n=10`, the optimum is `220` at `187,641`
interactions. The analogous reference-expanding presentation exceeds five
million interactions without completing. The distinction is representation
and sharing: the objective is unchanged while the reduction exposes a
different amount of repeated substructure.

## The minimum-step statement

[`InteractionGeodesic.agda`](sat_fibre/InteractionGeodesic.agda) defines a generic `Step` relation, assumes its exact one-step diamond, and proves that all terminating traces from the same initial object to the same normal form have equal length. Consequently any such trace is minimum length for that declared object, demand, and interaction currency. This is the formal geodesic result used to interpret the interaction traces.

The fibre, boundary, representative, and continuation modules establish what the reduction preserves; the geodesic module establishes why a trace with the declared local interaction law cannot be shortened by choosing another reduction order. The mathematical object, its retained evidence, its representation, and its cost currency must be named together: changing the presentation changes the trace without changing the proposition.

## Evidence index

[`experiment.py`](sat_fibre/experiment.py) emits and validates the elementary suite: XOR, contradiction, tautology, unique assignments, cycles, late contradictions, and variable-order variants. [`np_experiment.py`](sat_fibre/np_experiment.py) emits pigeonhole, permutation, graph-colouring, and planted 3-CNF families; every returned witness is checked against the generated CNF.

[`audit.py`](sat_fibre/audit.py) validates stored dataset cardinalities, profile totals, prediction equality, TSP certificates, Bend receipts, source hashes, runtime hashes, proof-verification records, and the source-hash inventory. The resulting [`verification.json`](sat_fibre/verification.json) is the provenance index. Generated HVM files are executable artifacts, Bend files are the authoring layer, Agda files are the checked semantic layer, and Python files generate, profile, validate, and index the runs.

## Deployed conclusion

The deployed result is a deterministic fibre reduction for finite Boolean propositions. SAT supplies the universal binary interface: arbitrary finite proposition evaluation becomes classification of `True(P)` and `False(P)`; the fibre calculus retains witnesses, counterexamples, source paths, and continuations; Bend2 compiles that construction to a full cubical HVM4 net; and HVM4 executes the requested reading with a native interaction receipt.

The exact Agda equalities explain what is preserved. The boundary and continuation results explain how sharing and factoring retain the relevant fibre. The geodesic result explains minimum length for the declared reduction relation. The held-out cost formulas and native receipts show how that result appears in actual execution: deterministic reduction of a shared, proof-relevant proposition object.
