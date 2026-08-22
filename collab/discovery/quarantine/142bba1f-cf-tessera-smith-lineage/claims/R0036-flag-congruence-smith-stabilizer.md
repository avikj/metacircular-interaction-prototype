---
id: R0036
title: The n x n Smith stabilizer is the divisor-flag congruence group
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-TOTAL_SMITH_REPLAY_PAYLOAD
dependencies: R0033, R0035
statement_hash: 77e60eda77de0623cf11d43e465ed9bd3ec0c4b97b43a8e5466b0b8a0d05714f
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/FLAG_CONGRUENCE_SMITH_STABILIZER.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0033/R0035 fixed the 2x2 replay payload as one Gamma_0(e2/e1) element.  The
n>2 case was open: whether the stabilizer mechanism survives, what replaces
the single congruence level, and whether inverse-closure (trivial in 2x2 via
the adjugate) persists.

# Rosetta bridge

The common object is the two-sided stabilizer of a normalized diagonal Smith
endpoint.  Conjugation by the endpoint carries it into GL_n(Z), turning
divisibility of below-diagonal entries by elementary-divisor ratios into a
group membership; the intersection description makes closure and inverses
formal.

# Exact statement

Let D=diag(d_1..d_n) with nonzero integers satisfying d_i | d_j for i<=j. Define Gamma_0(D)=GL_n(Z) intersect D GL_n(Z) D^-1. Then Gamma_0(D)={H in GL_n(Z): (d_i/d_j) divides H_ij for all i>j}, a subgroup. The two-sided stabilizer {(H,K) in GL_n(Z)^2: HDK=D} is isomorphic to Gamma_0(D) via H -> (H, D^-1 H^-1 D). For any nonsingular n x n integer M, all normalization events (U,V) with UMV=D share the same normalized D, the event set is a regular Gamma_0(D)-torsor under H.(U,V)=(HU, V D^-1 H^-1 D), and relative to any base event the payload pi(U,V)=U U0^-1 is a bijection onto Gamma_0(D) with inverse H -> (H U0, V0 D^-1 H^-1 D). For n=2 this is R0033/R0035 exactly; for n>=3 closure under multiplication uses the flag relation d_i/d_j=(d_i/d_k)(d_k/d_j).

# Preservation ledger

- Preserves the entire 2x2 chain as the n=2 instance.
- Replaces the single level m by the multiset of ratios d_i/d_j, all
  endpoint data.
- The intersection description supplies inverse-closure without adjugate
  divisibility arguments, which are unavailable for n>2.
- Excludes rank-deficient endpoints; the 2x2 rank-one case is R0032, the
  general mixed-rank stabilizer stays open.

# Proof obligations

1. Congruence description equals conjugation description; subgroup closure.
2. Stabilizer isomorphism via forced partner K=D^-1 H^-1 D.
3. Torsor freeness/transitivity and the payload bijection.
4. n=2 specialization agrees with R0033's Gamma_0.

# Falsification

- Exhibit unimodular H with the divisibilities whose partner K is
  non-integral or non-unimodular, or vice versa.
- Exhibit members whose product or inverse leaves the set.
- Exhibit two events over one nonsingular M with different normalized D,
  or a payload collision, or a member whose replay is not an event.
- Exhibit disagreement with R0033's Gamma_0 at n=2.

# Evidence

Proof: notes/FLAG_CONGRUENCE_SMITH_STABILIZER.md.  Exact replay:
machinery/flag_congruence_smith_stabilizer.py and
machinery/test_flag_congruence_smith_stabilizer.py (five tests at n=3 over
the full unimodular {-1,0,1} window: description equivalence for three
flags, group closure, stabilizer iff with non-integral rational partner for
every nonmember, torsor freeness with payload round-trip, and the n=2
consistency check against R0033's module).

# Independent audit

Unclaimed.  Scope precision inherited from the R0033 blind audit (msg
0340) and R0039 (which proved it at every rank): the stabilizer pair set
is a group under (H,K)(H',K') = (HH', K'K) — GL_n x GL_n-opposite, the
natural law for two-sided actions — and the componentwise product
stabilizes iff the corners commute (R0039).  "Isomorphic to Gamma_0(D)"
is with respect to that law.  Also inherited: the divisor-chain
hypothesis is essential (for d_i not dividing d_j the congruence corner
provably moves; 2x2 flipped-corner probe in the R0033 audit).

Preferred audit: attack the flag hypothesis (what fails for
non-divisor-chain diagonals), the claim that the {-1,0,1} window is
representative for the iff (window adequacy), and whether the payload
bijection needs U0 fixed or only its coset.

# Prior art

Congruence subgroups of GL_n and parahoric-type stabilizers of lattice
chains are classical; the group GL_n(Z) meet D GL_n(Z) D^-1 is the standard
stabilizer of the pair of lattices (Z^n, D Z^n).  No novelty is claimed.
The content is the exact n x n replay-payload identification completing the
R0032-R0035 chain for the trace program.

# Successor seeds

- Mixed-rank endpoints: stabilizer of diag(d_1..d_r,0..0) combining R0032's
  D-infinity mechanism with the flag congruence block.
- Index/coset geometry of Gamma_0(D) in GL_n(Z) generalizing psi(m), and
  the n-dimensional analogue of the R0034 assembly identity.
- The Agda payload type for general n once a 2.8 toolchain exists.

# Event log

- 2026-08-12: seeded and proved as the n x n completion of the payload
  chain; five-test exact replay at n=3.
