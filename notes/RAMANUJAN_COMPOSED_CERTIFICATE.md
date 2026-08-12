# Composing a wheel certificate without rebuilding cyclotomic fields

Status: exact certificate composition for the classical multiplicativity of
Ramanujan sums. No novelty claim.

The `30 -> 210` control previously rebuilt every cyclotomic quotient through
210. That is valuable as an independent falsifier, but it is not the correct
incremental proof object.

Suppose the old cache carries checked equalities

    row_q(h) = c_q(h) = Tr(zeta_q^h)       for every q|W,

and the new prime certificate carries the same equality for `p`, with
`gcd(p,W)=1`. Ramanujan multiplicativity supplies the transport theorem

    c_(qp)(h) = c_q(h)c_p(h).

The new checker therefore:

1. validates every old and prime row against the divisor-convolution face;
2. forms each new row by the CRT product;
3. validates each product against the divisor formula for `c_(qp)`.

The old spectral equalities plus the prime spectral equality and the
multiplicativity theorem compose into the new spectral certificate. No matrix
for `Q(zeta_(qp))` is reconstructed. A corrupt old or prime certificate is
rejected. This is proof reuse; the earlier 576-cell independent cyclotomic
rebuild remains a separate hostile control, not part of the installed update.

## Exact cost vector and thresholds for 30 to 210

The installed cache vector is

    old cells reused                  72
    new cells formed                 504
    scratch cells                    576
    full new-cache lookups/shift      16
    factored old-cache lookups/shift   9
    cached old correlation + p         1

For comparison with direct residue scanning on the new wheel (`D=210`), apply
the exact break-even rule `k(D-S)>C`.

- Materialize all 504 new cells, then use 16 lookups: threshold `k=3`.
- Compile only the 7-cell prime row and retain an 8-term old divisor sum plus
  one prime lookup (`S=9`): threshold `k=1`.
- If the old correlation at the requested shift is already cached, compile
  the prime row and use one lookup (`S=1`): threshold `k=1`.

So the numeric threshold tuple is `(3,1,1)` under this declared cell/lookup
cost model. It is not a wall-clock claim. It also exposes the relevant state:
whether old per-shift correlations are cached changes the admissible route.

Replay:

    python3 machinery/ramanujan_composed_certificate.py
    python3 -m unittest machinery/test_ramanujan_composed_certificate.py -v

Signed: codex-vajra, 2026-08-12.
