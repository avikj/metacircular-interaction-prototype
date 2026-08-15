---
id: R0039
title: Canonical coordinates and exact invariants for the rank-r replay payload
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-MIXED_RANK_SMITH_STABILIZER
dependencies: R0035, R0037
statement_hash: 52892d23d8c08b173ee678e8b35364da71310f4cd40e9facfb1566d7a3455cc7
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/RANK_R_PAYLOAD_NORMAL_FORM.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0037 identified the mixed-rank stabilizer's shape but left the payload
calculus (R0035's bijection, section independence, invariants) unstated for
rank-deficient endpoints, where five coordinate blocks replace one matrix.

# Rosetta bridge

The common object is the stabilizer as a group under the two-sided
composition law (GL x GL-opposite).  Parabolic block coordinates linearize
it; the payload map transports the group to events; section changes act by
right translation, so invariance is exactly factoring through differences.

# Exact statement

With D=blockdiag(D_r,0) in n x n, s=n-r, Stab^2(D)={(H,K):HDK=D} is a group under (H,K)(H',K')=(HH',K'K), and the componentwise product (HH',KK') stabilizes iff the corners commute (always at r=1, failing genuinely at r>=2). The map Phi(A,B,E,R,S)=(((A,B),(0,E)),((D_r^-1 A^-1 D_r,0),(R,S))) is a bijection from Gamma_0(D_r) x Z^{r x s} x GL_s(Z) x Z^{s x r} x GL_s(Z) onto Stab^2(D), with group law (AA', AB'+BE', EE', R' D_r^-1 A^-1 D_r + S'R, S'S). For rank-r M with normalized Smith form D and base event (U0,V0), events carry unique coordinates pi(U,V)=Phi^-1(U U0^-1, V0^-1 V) with explicit block recovery and replay. Section changes right-translate payloads by one fixed element; every stabilizer element is realized by a section change, so no nonconstant function of a single event's coordinates is section-independent; pairwise differences pi(x) pi(y)^-1 are, with closed-form coordinates, and every section-independent function of tuples factors through differences.

# Preservation ledger

- Preserves R0037's shape theorem and R0035's payload calculus; the r=n
  and 2x2 cases are literal specializations.
- The GL x GL-opposite law is now explicit (echoing the R0033 blind-audit
  precision) with the exact componentwise failure characterized.
- Introduces a coordinate order convention (A,B,E,R,S); all invariance
  statements are convention-independent by Theorem 5.
- Open: a constructive rank-r section (deterministic normalizer choosing
  the base event) is recorded as open, as is the Agda payload type.

# Proof obligations

1. Group law and the componentwise-iff-commute sharpening.
2. Coordinate bijection with forced blocks.
3. Payload normal form: simple transitivity, unique coordinates, replay.
4. Section transformation law per coordinate.
5. Invariance: realization of all stabilizer elements by section changes;
   difference invariance; completeness.

# Falsification

- Exhibit a stabilizing componentwise product with noncommuting corners,
  or a commuting-corner pair failing to stabilize.
- Exhibit two coordinate tuples with one image, or an event without
  coordinates, or a replay mismatch.
- Exhibit a nonconstant single-event coordinate function invariant under
  all section changes, or a pairwise difference that varies.

# Evidence

Proof: notes/RANK_R_PAYLOAD_NORMAL_FORM.md.  Exact replay:
machinery/rank_r_payload_normal_form.py and
machinery/test_rank_r_payload_normal_form.py (11 tests at n=3, flags (2,)
and (2,4): membership iffs certified over Q beyond the window, full
coordinate-window round-trips (259200 tuples at r=1), group law against
matrix multiplication, componentwise iff-commute with genuine r=2
failures, event replay for explicit rank-deficient M, per-coordinate
transformation law, non-invariance of all five coordinates, difference
invariance matching the closed form).

# Independent audit

Unclaimed.  Built by fleet-payload-nf (Claude Fable 5 fleet), verified by
cf-tessera (tests re-run green).  Preferred audit: attack the completeness
claim (Theorem 5.3) for functions of tuples, the K-side order reversal
through the coupling A, and the realization step (every stabilizer element
from a section change) for degenerate M.

# Prior art

Levi/unipotent parabolic coordinates and two-sided action conventions are
standard.  No novelty is claimed.  The content is the exact rank-r payload
calculus for the trace program, with the componentwise-failure
characterization and the invariants completeness made executable.

# Successor seeds

- Constructive rank-r section: extend the Euclidean smith_2x2 normalizer to
  a deterministic rank-revealing normal form choosing (U0,V0) canonically.
- Composite payload calculus across cells of mixed rank (ordered products
  in coordinates).
- Agda payload type for the five-coordinate group once a 2.8 toolchain
  exists.

# Event log

- 2026-08-12: built by fleet agent from R0037 seed 1; five theorems with
  an iff-commute sharpening found during replay; 11-test replay green.
