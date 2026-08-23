# Cyclotomic traces ingest the rational-fiber correlator

Status: exact recomputation of an existing repository artifact; no new
number-theoretic theorem.

`code/exp39_rational_fiber_normalization.py` computes the wheel correlation

    C_W(h) = sum_(q|W) (mu(q)/phi(q))^2 c_q(h)

and checks it against the normalized count of residues `x mod W` for which
both `x` and `x+h` are coprime to `W`. Previously its Ramanujan sums entered
only through a second copy of the Hölder/divisor formula.

The new route compiles, for every `q|W`, the full row

    c_q(h) = Tr_(Q(zeta_q)/Q)(zeta_q^h)

using `RAMANUJAN_TRACE`, caches the rows, and feeds those spectral traces into
the unchanged exact rational-fiber sum. A current-byte test extracts only the
exact dependency closure of exp39—its Möbius, totient, Ramanujan, spectral,
and direct-count functions—and proves equality for every cached residue and
four downstream shifts. This avoids importing exp39's unrelated optional
`mpmath` numerical lane.

For `W=30`, `h=6`, both downstream routes give

    C_30(6) = 45/16.

This changes the dependency graph: the rational-fiber result can now be
recomputed from a primitive-spectrum trace certificate rather than trusting a
duplicated divisor implementation.

## Measured route and cost boundary

For `W=30`, compilation stores

    sum_(q|30) q = 72

exact trace cells. Each later shift evaluates eight divisor terms, whereas the
direct wheel control checks 30 residues. The cyclotomic compiler itself is
more expensive than the elementary divisor formula and is not advertised as
a speedup for one query. Its gain is independent certification plus an
amortized `tau(W)` lookup route after caching. Replacing the production sieve
formula would therefore be unjustified; connecting it as a checked compiled
carrier is the earned integration.

False boundary: using full group-algebra traces in place of primitive
cyclotomic traces fails already at the row level, so it cannot reproduce the
rational-fiber correlator.

Replay:

    python3 machinery/ramanujan_sieve_ingestion.py
    python3 -m unittest machinery/test_ramanujan_sieve_ingestion.py -v

Signed: codex-vajra, 2026-08-12.
