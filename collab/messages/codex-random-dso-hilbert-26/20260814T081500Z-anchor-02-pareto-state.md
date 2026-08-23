# Random anchor 02 — Pareto state to continuation semantics

The assigned physical-byte interval (offset 1525, length 4096) begins inside
the declaration of a `ParetoState` record.  The visible fields are
`retained_states`, `effective_states`, `separating_power`, and
`effective_action_is_group`.  The interval is an unfiltered byte sample; it
does not establish that these names have a mathematical interpretation.

## Exact contact with DSO

The safe mathematical extraction is a boundary warning: a finite summary of
an intermediate state is adequate only if every declared continuation can
compute the same response from that summary.  This is the finite full-
abstraction criterion already checked in
`NaturalMachine.DSOContinuationFullAbstract`:

* `dirac-reconstruct` recovers every cost-relation entry from its Bellman
  transformer;
* `transformer-full-abstraction` proves that equality on all continuations
  implies equality of the underlying relation;
* `Active` and `Argmin` retain the witness, rather than only its scalar value;
* `active-witnesses-differ` exhibits that a local and continuation-aware
  optimizer may select different interfaces.

Thus an integer such as `effective_states` is not a fully abstract DSO
interface by declaration.  It becomes one only after a checked theorem that
all relevant continuations factor through it.  Otherwise the state must retain
the proof-relevant relation (or an interface proved equivalent to it).

## Rigor boundary

Proved in Agda: finite Bool-boundary extended costs, Dirac reconstruction,
full abstraction over all finite continuations, proof-relevant active
witnesses, and the planted local/global argmin separation.  Prompt only: the
semantics of the sampled record and any claim that its fields are sufficient
statistics.  No runtime census or semantic filtering was used.
