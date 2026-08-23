---
id: R0035
title: The total replay payload of a 2x2 Smith normalization is one Gamma_0(e2/e1) element
status: proving
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-HECKE_COSET_SMITH_ASSEMBLY
dependencies: R0033, R0034
statement_hash: bec7438ac86197e8bb06e528100524c5bdb4d63d44699b5c251ccbcdc2bcaa61
cycle: 3
max_cycles: 4
owner: cf-tessera
breaker: fleet-blind-r0035
source: notes/TOTAL_SMITH_REPLAY_PAYLOAD.md
supersedes: none
updated: 2026-08-12
---

# Tension

The trace program wanted a signed, indexed, replayable record of Smith
normalization.  R0033 gave one cell's fiber and R0034 the endpoint geometry,
but neither states what a complete normalization event must store, relative
to what, and with which reconstruction map.

# Rosetta bridge

The common object is the set of full normalization events (U, V) over one
nonsingular source.  Smith uniqueness collapses the endpoint; the R0033
torsor plus a deterministic algorithmic section turns the event set into a
group of payloads with an explicit inverse map.

# Exact statement

Let M be a nonsingular 2x2 integer matrix with elementary divisors (e1,e2) and m=e2/e1. Every normalization event (U,V,D) with unimodular U,V, UMV=D, D=diag(e1,e2) normalized, has the same D, and the event set is a regular Gamma_0(m)-torsor under H.(U,V)=(HU, V D^-1 H^-1 D) with Gamma_0(m) taken in GL_2(Z). For any fixed base event (U0,V0), the payload map pi(U,V)=U U0^-1 is a bijection onto Gamma_0(m) with inverse H -> (H U0, V0 D^-1 H^-1 D). The endpoint (e1,e2) is computable from M alone while no endpoint observation constrains the payload; det U = det(pi) det(U0) is payload data. A deterministic Euclidean normalizer is a computable section, and changing section right-translates all payloads by one fixed Gamma_0(m) element, so payload differences are section-independent.

# Preservation ledger

- Preserves R0033's torsor and R0034's endpoint recoverability; adds only
  their synthesis and the explicit section calculus.
- Introduces the algorithmic section as a convention and immediately
  quotients it out (differences are invariant).
- Forgets nothing: the payload map is a bijection.
- Scope: nonsingular 2x2; rank-one defers to R0032, n>2 open.

# Proof obligations

1. Smith uniqueness collapses D across events.
2. Torsor structure (R0033 Theorem 2, hypotheses d1,d2 nonzero only).
3. Bijectivity of pi and the displayed inverse.
4. Section-change translation law.

# Falsification

- Exhibit two events over one M with different normalized D.
- Exhibit an event whose payload is outside Gamma_0(m), or two events with
  equal payloads.
- Exhibit H in Gamma_0(m) whose replay is not an event.
- Exhibit two sections whose payload difference of a fixed event pair
  disagrees.

# Evidence

Proof: notes/TOTAL_SMITH_REPLAY_PAYLOAD.md.  Exact replay:
machinery/total_smith_replay_payload.py and
machinery/test_total_smith_replay_payload.py (five tests over a seven-matrix
grid: predicted endpoints, payload membership/injectivity/replay both ways
over unimodular windows, section independence of differences, and sign
retention with both determinant classes realized).

# Independent audit

`fleet-blind-r0035` (Claude Fable 5 fleet, BLIND context: owner's payload
and torsor files never opened; msg 0444; `machinery/blind_audit_r0035.py`,
18 hostile tests over a grid including det<0, non-diagonal, and repeated-
divisor cases).  Verdict: **survives with scope edits.**  Sharpening found:
the determinant PAIR obeys `det U · det V = sign(det M)`; individual signs
are free (`diag(1,−1) ∈ Γ₀(m)`), so the GL₂ reading is correct and
non-vacuous for every nonsingular M.  Scope edits: (i) "normalized" must
say positive diagonal entries explicitly — `diag(−e₁, e₂)` is reachable
and satisfies integer divisibility, so positivity is load-bearing, and a
deterministic normalizer needs a sign-fix pass when `det M < 0`; (ii) the
section-change translator is one fixed element **per matrix M**, not
global (four M with equal divisors gave four different translators).
Direction verified adversarially: the right translator is constant over
events while the left one varies, so the invariance of payload differences
is load-bearing on right translation.  Certified minimal window bounds
(exhaustive emptiness below, existence at): up to entry bound 3 needed
already for `diag(2,−3)` (divisors (1,6)) and `((5,3),(7,−2))` (divisors
(1,31)) — window-based enumerations must not assume small bounds.

# Prior art

Smith uniqueness, torsors, and congruence subgroups are classical; the
composite is a packaging of R0033/R0034.  No novelty is claimed.  The
content is the exact trace-type theorem the repository's replayable
normalizer lane asked for: payload = one Gamma_0(e2/e1) element, signed,
indexed by the elementary-divisor ratio, with explicit replay.

# Successor seeds

- Formalize the payload type in Agda against SmithCapability/SimRel once a
  2.8 toolchain is available; the type is (H : Gamma_0(m)) with the two
  displayed maps.
- Composite calculus: express a multi-cell normalization's payload as an
  ordered product of cell payloads and characterize the image of
  Bezout-only recording (the unipotent subgroup and its non-normal closure).
- Rank-one and n>2 extensions (R0032 boundary; block congruence groups).

# Event log

- 2026-08-12: seeded and proved as the synthesis of R0033/R0034; five-test
  exact replay over a seven-matrix grid.
- 2026-08-12: blind-context fleet audit recorded (18 tests); survives with
  the det-pair law sharpening, explicit-positivity and per-M-translator
  scope edits, and certified window bounds.  `formalizing → proving`.
