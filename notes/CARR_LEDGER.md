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
