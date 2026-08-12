# Recursive reach with the ports left alive

The endpoint compiler installs one large translation and contracts away every
intermediate choice. Its opposite is not to abandon compilation, but to retain
one environmental port at each compiled scale.

At level `k=0,...,11`, form the weight `3^k` and accept a live bit `a_k`. The
response is

`R(a_0,...,a_11) = sum_k a_k 3^k`.

**Theorem.** The response map is injective, so twelve ports retain exactly
`2^12=4096` possible environmental histories. Its maximum primitive span is

`1+3+...+3^11 = (3^12-1)/2 = 265720`,

which exceeds `105192`, the hours in twelve Julian years.

**Proof.** If two bit strings first differ at largest index `j`, their weighted
difference has magnitude at least

`3^j - sum_(k<j)3^k = (3^j+1)/2 > 0`.

Thus endpoints are distinct. The geometric sum gives the span. ∎

Each formation therefore changes two capacities at once: primitive reach grows
by the next ternary scale, while the response family doubles. Choosing every
bit to be one and contracting the ports preserves the maximum endpoint but
reduces the response family from 4096 functions to one. It is faster only in
the sense that it has ceased accepting those future inputs.

This is the exact reconciliation of `TWELVE_STEP_COMPILER` with
`ADAPTIVE_PORT_CONTRACTION`: recursive compilation need not erase openness.
The cost is an exposed twelve-bit interface and the causal opportunity for the
environment to intervene.

## Rigor boundary

The result concerns a finite deterministic positional response family. It does
not show that all 4096 responses are useful, that binary intervention is an
adequate model of agency, or that physical execution of the chosen translation
is unit time. Ternary weights are sufficient for unique binary histories;
binary weights are also unique for binary digits, so ternary is inherited from
the existing compiler rather than proved minimal. If intervention digits reach
the radix, carries destroy the displayed decoding.
