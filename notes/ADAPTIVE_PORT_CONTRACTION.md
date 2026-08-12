# Contracting an intervention port

Let `X` be finite initial states, `A` admitted interventions at an intermediate
port, and `O` final outcomes. A deterministic one-port process is its response
table `R:X x A -> O`. Let `w:X->Y` be the endpoint macro obtained by contracting
the underlying action word.

**Erased-port theorem.** A portless endpoint macro with decoder `d:Y->O`
reproduces `R(x,a)` for every `x,a` iff:

1. every response function `R_x:a |-> R(x,a)` is constant; and
2. that constant factors through `w`.

This is immediate: a portless decoder has no argument at which `a` could
enter, so `R(x,a)=d(w(x))`. The converse uses that formula. Thus memory cannot
repair erasure of a later freely chosen intervention input. A responsive port
must remain a port or be replaced by an operationally equivalent interface.

**Retained-port memory theorem.** Suppose the macro continues to receive `a`
and may retain a side record `r(x)`. The least alphabet size allowing a decoder
`D(w(x),r(x),a)=R(x,a)` is

`max_y |{R_x : w(x)=y}|`.

Distinct response functions within one endpoint fiber require distinct record
values; indexing those functions fiberwise attains the bound. Under zero-error
quantum readout the corresponding program supports must be orthogonal, so the
same number is the minimum Hilbert-space dimension. This is the naming-memory
theorem localized to endpoint fibers.

The distinction is sharp. If two states share an endpoint and the same
response function `(0,1)`, the port cannot be erased, yet no side memory is
needed once the intervention input remains exposed. Conversely, three distinct
response functions in one endpoint fiber require a qutrit side record.

## Change to the live compiler

The twelve-stage translation compiler proves a recursive endpoint action with
span `3^12`. Its current interface has no intermediate intervention ports.
Therefore it is exactly an endpoint-access accelerator. It represents the
expanded word as a process only relative to intervention families whose erased
ports are null by the theorem. For a responsive family, the next construction
must expose the ports or compile their response functions and pay the displayed
side-memory dimension; no amount of endpoint verification supplies the absent
causal input.

## Rigor boundary

Proved: the finite deterministic one-port criteria and zero-error dimension
bound. Multiple adaptive ports can be folded into a strategy-valued response
function only after the allowed causal strategies are declared; this note does
not claim a general quantum-comb compression theorem. It says nothing about
physical duration, thermodynamic cost, indefinite causal order, or spacetime.
