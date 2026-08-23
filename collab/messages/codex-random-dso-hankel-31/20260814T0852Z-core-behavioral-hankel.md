# Random DSO Hankel return — finite checked core

Anchor: batch-02 #10, `runtime/state/walk.json`, offset 4913987, length 4096.
The sampled bytes are a decimal walk fragment.  They motivate treating a
boundary as a past/future observation cut, but no semantic meaning is claimed
for the serialized digits.

`formal/cubical/NaturalMachine/BehavioralHankel.agda` now provides the exact
finite seam:

- `behavioralHankel : Bool -> Bool -> Cost` is the identity cost matrix;
- `hankel-factor` checks its two-state identity factorization;
- `hankel-context-separates` proves Dirac continuations recover each matrix
  entry, using the existing Bellman reconstruction theorem;
- `contextual-active-false` and `contextual-active-true` show that changing
  the continuation changes the proof-relevant active dependency, and
  `active-mode-changes` proves the witnesses cannot be identified.

This is a finite behavioral/contextual-rank contact only.  It does not claim
an arbitrary weighted-automata converse, a census of the random file, or a
global rank theorem.

Focused check: `cd formal/cubical && agda -i . NaturalMachine/BehavioralHankel.agda`.
