# Online Smith certificates separate transcript from private memory

The Smith quotient no-go showed that the coarse record
`(kind,pivot,remainder)` cannot determine the next exact constructor.  It did
not show that every quotient must remain in persistent private workspace.

For

`A_q=((2,0),(2q+1,7))`,

the first certified operation subtracts `q` times the first row from the
second and swaps the rows.  Every source therefore reaches the same post-state

`B=((1,7),(2,0))`,

while emitting the row coefficient `-q`.

## Exact finite theorem

On `q=0,...,N-1`:

1. the state-update map `A_q -> B` has one image point and maximum fiber `N`;
2. any coherent implementation which erases the source and emits no record
   needs an environment of Hilbert dimension at least `N`;
3. the recorded update `A_q -> (B,-q)` is injective, so it is an isometry on
   the input basis and needs no additional garbage environment;
4. the output register still needs `N` mutually distinguishable values;
5. if the source is retained, `A_q -> (A_q,-q)` is likewise injective, and a
   reversible compute-copy-uncompute schedule can return its private work
   register to blank after copying `-q` to the append-only output.

The fiber bound is elementary.  Basis inputs with the same declared output
must be distinguished by orthogonal environment states.  Conversely, label
the environment by the input's position inside its output fiber.  Hence the
minimum environment dimension of a finite classical basis map is its maximum
fiber cardinality.  Applied to the two maps above, the dimensions are `N` and
`1` respectively.

The clean retained-input schedule does not assert constant circuit width in
bits: representing and arithmetically computing an unbounded quotient still
uses a register whose value range grows with `q`.  It says something narrower
and operationally important: after emission, that workspace need not persist
as hidden process memory.  The transcript carries the information required to
reverse or audit the destructive state update.

## Exact correspondence

This is the process-theoretic form of a replayable proof certificate:

- **post-state alone** is a many-to-one semantic quotient;
- **certificate output** is the complementary record that restores an
  injective causal history;
- **private workspace** may be uncomputed once that record has crossed the
  output boundary;
- **discarded environment** is forced only by whatever ambiguity remains in
  `(post-state,record)`.

Thus output dimension, persistent private memory, and discarded-environment
dimension are three different resources.  The previous `N` lower bound still
applies if the controller must answer later while neither source nor emitted
record is available.  It must not be relabeled as an unavoidable persistent
workspace bound when an append-only certificate port is part of the process.

## Change to organism motion

Compile exact arithmetic steps as streaming certified transitions.  For every
candidate macro report the pair map

`source -> (new state, emitted certificate)`

and its maximum fiber.  Retain private history only for the residual fiber;
do not duplicate information already present in the output transcript.  The
next useful problem is compositional: when several clean certified steps are
streamed, determine which prefix of the transcript is needed for reverse
replay and which parts can be compressed by the live state.

## Scope

This is a finite basis-state/isometry theorem and an exact statement about the
installed two-by-two Smith transition.  It is not a gate-count, time, energy,
fault-tolerance, indefinite-causal-order, or general quantum process-tensor
claim.  It does not say the unbounded quotient alphabet has constant storage
size; it separates transient/output storage from persistent hidden memory.
