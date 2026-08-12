# The Smith accumulator already is the replay record

The online-certificate theorem separated the reduced matrix from an emitted
quotient record.  The installed Smith reducer, however, carries more live
mathematical state than the reduced matrix: it accumulates unimodular matrices
`L,R` satisfying

`L A R = D`.

That distinction changes the transcript question exactly.

For `A_q=((2,0),(2q+1,7))`, direct symbolic execution gives

`L_q=((-q,1),(-(2q+1),2))`,

`D=((1,0),(0,14))`,

`R=((1,-7),(0,1))`.

These identities are checked for arbitrary `q` by multiplying
`L_q A_q R=D`; the executable falsifier checks the installed reducer on the
first thirty values.  In particular,

`q = -(L_q)[0][0]`.

## Exact resource statement

On `q=0,...,N-1`:

- `D` alone has maximum fiber `N`;
- `(D,R)` still has maximum fiber `N`;
- `(L,D,R)` is injective and has maximum fiber one;
- therefore an additional quotient transcript carries no new information for
  exact reverse replay when the final transformation certificate is retained.

The output register holding `L` still ranges over at least `N` distinguishable
values.  Nothing has made the information free or finite-dimensional on the
unbounded family.  The no-go is against *duplicating* that information in a
second append-only quotient stream and calling the duplicate necessary process
memory.

## Quantum/process correspondence

The final transformation accumulator is a deferred coherent record of the
elementary-operation history.  On basis states, the map

`|A_q> -> |L_q,D,R>`

is injective on this family.  Copying `q=-L_q[0][0]` into a separate classical
output is permitted because the relevant values occupy an orthogonal basis,
but that copy is redundant for reversibility.  If `L` is discarded and only
`D,R` remain, an environment of dimension `N` is again forced.

Thus a process record can live extensionally in the accumulated mathematical
transformation rather than intensionally as an operation log.  This is the
same distinction as proof term versus replay trace: either may certify the
result, and retaining both is not automatically useful.

## Change to organism motion

Do not launch transcript-prefix minimization on the reduced state while
ignoring transformation accumulators already required by the mathematical
output.  First compute whether each proposed log symbol factors through the
final certified object.  Emit or retain only the residual symbols that do not.

For Smith reduction the next question is therefore broader than this witness:
does the full pair `(L,R)` determine the installed reducer's entire quotient
trace on arbitrary two-by-two inputs, or can two distinct traces yield the same
final `(L,D,R)`?  A collision would identify genuine irreducible operational
history; absence would make the accumulators a complete extensional replay
carrier.

## Scope

This is exact for the displayed family and the installed deterministic Smith
reducer.  It is not a uniqueness theorem for Smith decompositions, a claim that
all operation logs are redundant, or a bound on circuit time, energy, or
fault-tolerant quantum storage.
