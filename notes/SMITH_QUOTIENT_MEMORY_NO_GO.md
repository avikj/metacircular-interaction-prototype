# Unbounded controller memory behind a typed Smith remainder

The Smith process qutrit proved that scalar remainder alone forgets the phase
of the next constructor. A natural attempted repair is the coarser typed record

`(kind, pivot, remainder)`.

It is still not sufficient for exact replay of the proved Euclidean descent.

For every integer `q>=0`, consider

`A_q=((2,0),(2q+1,7))`.

The first lower-left Euclidean division is

`2q+1 = q*2 + 1`.

Thus every `A_q` exposes exactly the same coarse record

`(column-residual, 2, 1)`.

But the next constructor first applies row addition with coefficient `-q` and
then swaps rows. Distinct `q` require distinct exact constructor parameters.

## Theorem

On the finite witness family `{A_0,...,A_(N-1)}`, any controller which sees
only `(kind,pivot,remainder)` at the cut and must replay the existing Smith
constructor exactly requires at least `N` hidden classical states. A zero-error
quantum controller requires Hilbert dimension at least `N`. The bound is
attained by retaining the quotient `q`.

**Proof.** All histories share one visible coarse record. Their required next
outputs—the row coefficients `0,-1,...,-(N-1)`—are distinct deterministic
responses. Exact classical records must therefore be distinct; exact quantum
records must have orthogonal supports. A basis register labeled by `q` attains
the bound. QED.

Since `N` is arbitrary, no finite-dimensional memory based only on this coarse
cut controls the full unbounded integer family. In logarithmic units the first
`N` witnesses require `ceil(log_2 N)` bits; in state/Hilbert dimension they
require `N`.

## Interface and no-go boundary

The response is not an arbitrary implementation detail. The live Smith machine
returns a replayable certificate of elementary unimodular row/column operations;
the coefficient is part of that certificate and changes the exact next matrix.
If the task is weakened to “eventually output some Smith normal form by any
method,” a different controller may be allowed and this theorem does not price
it. The no-go is for exact continuation of the installed residual-directed
constructor schema.

The smallest sufficient local record for this family is therefore

`(kind,pivot,quotient,remainder)`,

or the full state from which it is recomputed. The qutrit phase result and this
unbounded quotient result are independent coordinates: `kind` chooses which
constructor family; `quotient` selects an unbounded parameter within it.

## Change to organism motion

Do not compile scalar or partially typed obstructions as finite controller
states merely because their residual alphabet is finite. First compute the
future constructor-response classes inside each visible fiber. A finite
residual alphabet can hide an unbounded action parameter and hence unbounded
exact process memory.

The next useful quotient question is task-relative: if only the final Smith
form and transformation certificate are required, can quotient digits be
streamed and immediately uncomputed, bounding *persistent* memory by the input
register rather than storing the whole action parameter history?

## Scope

This is an exact deterministic controller and zero-error dimension theorem.
It does not assert a lower bound for every Smith-normal-form algorithm, circuit
time, thermodynamic work, a physical quantum process tensor, indefinite causal
order, or spacetime.

## Formal preservation certificate

`formal/pairfield/Pairfield/SmithMemory.lean` defines the repository side on
`Fin N`: `smithCoarse` is constantly `(column-residual,2,1)`, while
`smithResponse(q)=-q` is the required next coefficient. Exact decoding first
instantiates `FiniteInformation.targetFiber_injects_side`. Injectivity of the
response then makes the side-memory map injective, and Mathlib's
`Fintype.card_le_of_injective` transports this to `N <= Fintype.card C`.

The quotient register `C=Fin N` attains equality. A known-false control
replaces `-q` by a constant response and constructs a one-state decoder; the
bound therefore depends on distinct exact continuations, not merely on the
constant visible record.

Replay: `cd formal/pairfield && lake build Pairfield.SmithMemory`.
