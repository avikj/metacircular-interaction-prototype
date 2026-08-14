# Incremental CRT update of a certified Ramanujan wheel

Status: exact executable use of classical multiplicativity. No novelty claim.

Let `p` be prime and coprime to a wheel `W`. For every divisor `q|W`, the
Chinese remainder theorem separates primitive characters and gives

    c_(qp)(h) = c_q(h)c_p(h).

Therefore a certified cache containing every row `c_q(0),...,c_q(q-1)` for
`q|W` extends without recompiling any old row. Compile the one prime row and
form each new `qp` row pointwise using the two residue coordinates.

The wheel correlation ingested from exp39 is

    C_W(h) = sum_(q|W) mu(q)^2 / phi(q)^2 c_q(h).

Using multiplicativity of `mu`, `phi`, and `c_q` gives the constant-size update

    C_(Wp)(h) = C_W(h) [1 + c_p(h)/(p-1)^2].

Thus after the prime row is available, one cached correlation value updates by
one lookup and rational multiplication instead of a new divisor sum.

## Exact 30 to 210 control

At `h=6`,

    C_30(6) = 45/16,
    c_7(6) = -1,
    local factor = 1 - 1/36 = 35/36,
    C_210(6) = 175/64.

An independent rebuild of every cyclotomic row for every divisor of 210 gives
the same result, and every CRT-formed row is compared cellwise with its
independently compiled primitive trace row.

## Exact cache accounting

Let `S(W)=sum_(q|W)q`, the number of stored row cells. Since `p` is new,

    S(Wp) = (p+1)S(W).

The update reuses `S(W)` cells and forms `pS(W)` new cells; a scratch cache
forms all `(p+1)S(W)`. For `30 -> 210`, this is 72 reused, 504 formed, and 576
total versus 576 formed from scratch. This is cell accounting, not a claim
about asymptotic wall-clock complexity. The larger gain is per cached shift:
the correlation itself updates in constant size rather than summing all
`2 tau(W)` divisors.

False controls reject a repeated prime and a composite extension: the displayed
two-way divisor splitting and primitive-character tensor factorization require
a genuinely new coprime prime.

Replay:

    python3 machinery/ramanujan_crt_update.py
    python3 -m unittest machinery/test_ramanujan_crt_update.py -v

Signed: codex-vajra, 2026-08-12.
