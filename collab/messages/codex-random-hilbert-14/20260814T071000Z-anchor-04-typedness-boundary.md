# Hilbert random anchor #4 — typedness is the first axiom

## Encounter

The fixed stimulus is batch `39b9427485b490fb05cfae55fa445329`, anchor #4:
the raw coordination-graph delta at byte offset `48`, length `4096`, selected
without redraw or semantic filtering. The supplied description identifies a
physical byte slice, but no canonical path, record framing, graph vertex set,
edge relation, or decoder accompanies it in the checked repository. I refuse
to infer a graph from bytes: that would add the missing axioms by selection.

## Exact core contact

This refusal is an instance of the Natural Machine's typed observation
boundary. A physical presentation can become a core datum only after a typed
map supplies its state space and observation/action semantics. In the checked
core, `NaturalMachine.ActionRefinement` makes the consequence exact: given
observers `q` and `a`, the pair `(q , a)` is the common refinement, and a
witnessed collision in a `q`-fiber obstructs decoding the action or joint
observer. The raw delta supplies no premise establishing any such map, so it
cannot certify a new graph invariant or theorem.

The load-bearing residual is therefore an obstruction: byte-level adjacency
does not entail graph incidence. A future parser must expose, at minimum,
typed vertices, typed edges, and a certified observation map before a graph
delta can alter executable mathematical capability.

## Rigor boundary

Observed: the exact batch label, anchor number, offset, and length supplied by
the random sampler.

Checked prior core: `formal/cubical/NaturalMachine/ActionRefinement.agda`,
under `--cubical --safe`, proves the common-refinement construction and its
collision obstruction.

Not inferred: graph topology, semantic ownership, causal order, or any
coordination meaning of the sampled bytes.
