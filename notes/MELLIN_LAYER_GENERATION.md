# The error term can generate layers, but only with coefficient payloads

Status: exact finite symbolic residue bookkeeping. It instantiates one part of
the generative-loop pattern but makes no analytic remainder or convergence
claim beyond `BARRIER_ERROR_WINDOW`.

`BARRIER_ERROR_WINDOW` proves that the first omitted non-pole stratum in the
normalized k-fold Mellin expansion is

    k D_a(0) e^(-u/2) Z_(k-1)(u).

This is structured residual, not noise. If one restricts attention to the
finite family obtained by placing exactly `r` of the `k` Mellin variables at
the Gamma pole `s=0`, the complete symbolic stratum is

    binomial(k,r) D_a(0)^r e^(-ru/2) Z_(k-r)(u),   0 <= r <= k.

The identity is direct residue bookkeeping: choose the `r` variables, each
contributes `D_a(0)`, and normalization loses one half-power per chosen slot.
It includes U1 at `r=1`.

## Exact finite generation

Install strata in increasing `r`. For installed depth `m`, define

    deficit = k-m.

Promoting the next omitted stratum changes `m` to `m+1`, hence strictly lowers
the deficit by one and terminates after at most `k` promotions. At `k=3` the
deficit sequence is exactly `(3,2,1,0)`.

This is a faithful finite instance of obstruction-indexed generation:

    observed residual at decay 1/2
      -> install the lower-arity wave stratum
      -> expose the next decay stratum
      -> decrease a target-specific finite measure.

It does not establish a decreasing norm of the analytic remainder, select a
window, control the shifted contour, or settle the `Smooth` bucket. The measure
counts unresolved s=0 strata only.

## Coefficient payload no-go

Head-only vocabulary is insufficient. At `k=3`, the Möbius dressing has
`D_mu(0)=-2`, so its first promoted coefficient is `-6`; the divisor dressing
has `D_d(0)=1/4`, so the same layer shape has coefficient `3/4`. Both have the
identical shape chain

    (r,k-r) = (0,3),(1,2),(2,1),(3,0),

but every nonleading coefficient differs. Therefore a `GenerativeLoop` state
containing only layer names and coverage can prove that the required shapes
were installed, but cannot reconstruct the Mellin expansion.

The minimal earned interface is exactly the one exposed by the preceding
arithmetic boundary: an obstruction must carry the native payload

    (decay exponent, wave arity, exact coefficient, provenance theorem),

and unfolding must preserve the symbolic expansion. In this finite truncation
that payload is executable. A general analytic organism would additionally
need the convergence and remainder obligations already stated in the barrier
note; they cannot be inferred from termination of layer enumeration.

Replay:

    python3 machinery/mellin_layer_generation.py
    python3 -m unittest machinery/test_mellin_layer_generation.py -v

Signed: codex-vajra, 2026-08-13.
