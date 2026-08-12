# Endpoint macro contraction and temporal interfaces

Let a finite deterministic action word act on `X`. Write `w:X->Y` for its
endpoint transformation and `t:X->T` for the complete tuple of declared
intermediate observation outcomes.

**Theorem 1 (port-forgetting criterion).** An atomic endpoint macro can
reproduce the fixed trace from its endpoint alone exactly iff `t` factors
through `w`; equivalently, `w(x)=w(x')` implies `t(x)=t(x')`.

**Proof.** A decoder `d:Y->T` with `t=d w` makes reproduction immediate.
Conversely any endpoint-only reproduction rule is such a decoder, so equal
endpoints must have equal traces. QED.

**Theorem 2 (minimum side record).** If a side record `r:X->R` is retained and
the pair `(w(x),r(x))` must determine `t(x)`, the minimum possible alphabet
size is

`max_y |{t(x): w(x)=y}|`.

**Proof.** Inside a fixed endpoint fiber, distinct trace values require
distinct records, proving the lower bound. Label the distinct trace values
inside each fiber from `1` up to the displayed maximum; labels may be reused
between fibers, attaining it. QED.

If the record is quantum and the trace must be read with zero error, records
for distinct trace values in a common endpoint fiber have orthogonal supports.
The same number is therefore the exact minimum Hilbert-space dimension. This
is perfect distinguishability, not a claim of quantum advantage.

On `Z/6`, take successor followed by reset-to-zero, observing parity after the
successor. The endpoint is constant but the trace has two values, so an atomic
reset macro needs a retained bit to preserve this temporal interface. Replacing
parity by residue mod 3 requires a qutrit. By contrast, two successors have a
bijective endpoint, so every fixed intermediate trace is reconstructible from
the endpoint and requires no side record.

## Consequence for formed shortcuts

A certified macro equal to its expansion as an endpoint transformation
preserves the syntactic monoid and can shorten its access metric. It does not
thereby preserve the expansion as a multi-time process. Before multiplying
nested shortcut spans, declare which interface is promised:

- endpoint-only execution: transformation equality suffices;
- fixed intermediate transcript: apply the factorization test and retain the
  exact side-record dimension above;
- freely chosen intermediate interventions: the macro must expose equivalent
  ports or supply a decoder/realization of them; the fixed-trace theorem alone
  does not apply.

Thus temporal acceleration and process equivalence are separate coordinates.
The product span law may be exact in the endpoint access metric while failing
as a contraction of the intervention-bearing process.

## Rigor boundary

The two finite deterministic theorems and zero-error orthogonality statement
are proved. The machinery exhaustively evaluates the maps; its tests are
falsifiers, not the proof. No stochastic or quantum-comb equivalence, physical
clock acceleration, indefinite causal order, thermodynamic erasure cost, or
spacetime realization is inferred.
