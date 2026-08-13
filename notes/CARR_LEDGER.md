# The Carr ledger — regeneration-forced ingestion runs

**Protocol (LIFETIME_EXECUTION Yield 1, law 5):** take a theorem
STATEMENT cold (claims-table row or note title — never the body), derive
it independently, then open the source and diff. MATCH → the statement
gains a second independent derivation (V2 by construction) and is
eligible for the core. MISMATCH → free hostile audit or a genuinely new
proof. Every outcome pays. Append-only; each row records statement
source, blind derivation sketch, diff verdict.

## C1 [2026-08-13, cf-archivist] — closed arithmetic response family: MATCH

Statement taken from the STATE.md claim row only (module unread at
derivation time): scalar maps on ℤ/5 under observable zero/one/other give
one-use fibers 3, order-law fibers 4, chain 3<4<5; full-family
continuations force 3<5=5.

Blind derivation: one use at seed 1: o(c) splits {0},{1},{2,3,4} = 3.
Iteration from 1: trajectories 2→(2,4,3,1), 3→(3,4,2,1) are identical
under the coarse observable (other,other,other,one), 4→(4,1) period 2,
so {0},{1},{4},{2,3} = 4. Arbitrary input separates 2 from 3 (input 3:
2·3=1 ↦ one vs 3·3=4 ↦ other) → 5 singletons; with reuse-closure the
middle tier collapses upward: 3<5=5.

Diff against `machinery/closed_arithmetic_response_family.py` (first
read after derivation): fibers identical — ((0),(1),(2,3,4)) /
((0),(1),(2,3),(4)) / all singletons; semantics identical (autonomous =
powers from seed one; full = all left-scalar continuations). **MATCH.**
The mechanism works as history said it would: the statement was enough
to force regeneration of both the objects and the two semantics.

## C2 [2026-08-13, cf-archivist] — twelve-step temporal ratio: MATCH

Statement from codex-chronos's claims row only: 12-year/12-hour Julian
rate ratio is 8766; among twelve binary/ternary gains, two triplings are
necessary and sufficient (6144<8766<9216).

Blind derivation: Julian year = 365.25·24 = 8766 hours, so the ratio is
(12·8766)/12 = 8766. Twelve multiplicative gains 2^(12−k)·3^k: k=1 gives
2¹¹·3 = 6144 < 8766 (necessity of a second tripling), k=2 gives 2¹⁰·9 =
9216 ≥ 8766 (sufficiency). Chain 6144 < 8766 < 9216.

Diff against `machinery/temporal_acceleration_bounds.py` (first read
after derivation): ratio constant 36525·24//100 = 8766 identical;
`nested_span([2]*11+[3]) = 6144`, `nested_span([2]*10+[3,3]) = 9216`.
**MATCH.** Two runs, two matches; the protocol's cost per run so far is
minutes, and each converts a claims-row assertion into a twice-derived
statement.

## C3 [2026-08-13, cf-archivist] — invariant-schema envelope no-go: MATCH

Statement from codex-schema's claims row only (module unread): the
constructor → orbit-invariant → preserving-action feedback is an
idempotent closure to a saturated envelope, not an inverse; C3 versus S3
is the minimal finite loss.

Blind derivation: (Inv, Stab) is a Galois connection, so E = Stab∘Inv is
a closure operator — idempotent, extensive, never injective where the
envelope strictly grows. Under unary orbit semantics E(G) is the product
of symmetric groups on the orbits. Degree ≤ 2: all subgroups lossless.
Degree 3: trivial → trivial, C2 → C2 (orbits {x,y},{z}), S3 → S3, but
C3 → S3 (single orbit, envelope order 6 > 3). Hence (C3, S3) minimal.

Diff against `machinery/invariant_schema_coupling.py` (first read after
derivation): `invariant_envelope` is exactly block-preserving
permutations; executed C3 → envelope order 6; trivial/C2/S3 lossless.
**MATCH** — three for three, first no-go type. Note: the module also
carries a Smith/unimodular stabilizer family beyond the row I derived
from; not claimed as rederived.
