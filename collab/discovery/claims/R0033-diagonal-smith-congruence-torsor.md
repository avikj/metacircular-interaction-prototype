---
id: R0033
title: The diagonal Smith step's path fiber is a regular Gamma_0(AB) congruence torsor
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-SMITH_PATH_COORDINATE_TORSOR
dependencies: R0032
statement_hash: fb928bdf354df6d5d0158072bbb81b86d2f565631bf882d21533c9a9acbe8cef
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0032 fixed the one-sided rank-one payload; its seeds asked for the general
diagonal stratum and the relation to the Bezout ambiguity of the classical
two-sided cell U diag(a,b) V = diag(g, ab/g).  The classical presentation
suggests the ambiguity is one Bezout integer; the torsor viewpoint predicts
a larger fiber.

# Rosetta bridge

The common object is the two-sided transporter as a torsor under the
two-sided stabilizer of the diagonal endpoint.  Conjugation by the endpoint
turns the stabilizer into a congruence condition; the Bezout shift embeds as
a one-parameter unipotent subgroup.

# Exact statement

Let D=diag(d1,d2) with nonzero integers d1,d2 and integer m=d2/d1. The two-sided stabilizer {(H,K) in GL_2(Z)^2 : HDK=D} is isomorphic to Gamma_0(m)={M in GL_2(Z): m divides M_21} via H -> (H, D^-1 H^-1 D). For any M with U0 M V0 = D for some unimodular pair, the action H.(U,V)=(HU, V D^-1 H^-1 D) of Gamma_0(m) on the set of unimodular pairs with UMV=D is free and transitive. For the classical cell g=gcd(a,b), A=a/g, B=b/g, xA+yB=1, U=((x,y),(-B,A)), V=((1,-yB),(1,xA)), U diag(a,b) V=diag(g,ab/g), the level is m=AB, and the Bezout ambiguity (x,y)->(x+tB,y-tA) is exactly the unipotent subgroup ((1,-t),(0,1)) of Gamma_0(AB): U_t=H_t U_0 and V_t=V_0 D^-1 H_t^-1 D. Hence a replayable trace of the diagonal Smith step must retain a Gamma_0(AB)-coordinate; the Bezout integer alone under-parametrizes the fiber, e.g. diag(1,-1) reaches a fiber point no Bezout shift reaches. One-sided stabilizers of nonsingular D are trivial; the two-sided stabilizer is never trivial, with level m=1 giving all of GL_2(Z).

# Preservation ledger

- Preserves R0032's rank-one answer as the degenerate d2=0 boundary case.
- Preserves the classical cell identity exactly; adds only the group of all
  its lawful rewritings.
- Introduces a base-point choice (U0,V0); freeness makes every claim
  base-point independent.
- Forgets nothing: the congruence level m=d2/d1 is itself Smith data.

# Proof obligations

1. Derive the two-sided stabilizer via conjugation scaling and prove the
   Gamma_0(m) characterization.
2. Prove freeness and transitivity of the two-sided action.
3. Verify the classical cell identity and compute H_t=U_t U_0^-1 as the
   unipotent, with the V-side law from torsor uniqueness.
4. Exhibit the gap witness diag(1,-1) beyond every Bezout shift.

# Falsification

- Exhibit H outside Gamma_0(m) with some unimodular K satisfying HDK=D.
- Exhibit two distinct congruence elements acting identically on a fiber
  point, or a fiber point outside one orbit.
- Exhibit a Bezout shift whose H_t is not ((1,-t),(0,1)).
- Exhibit a nonsingular D with nontrivial one-sided stabilizer.

# Evidence

Proof: notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md.  Exact replay:
machinery/diagonal_smith_congruence_torsor.py and
machinery/test_diagonal_smith_congruence_torsor.py (seven tests: the iff
characterization over full unimodular windows for three endpoints, one-sided
triviality, six classical cells, unipotent identification, gap witness,
freeness, transitivity).

# Independent audit

Unclaimed.  Preferred audit: attack the integrality step ((H^-1)_21 = ±H_21)
for both determinant signs, the claim that torsor-completion uniqueness
proves the V-side law without direct computation, and whether negative or
mixed-sign (a,b) change the level formula m=AB.

# Prior art

Congruence subgroups Gamma_0(m), Smith normal form, and torsors are
classical.  The two-sided stabilizer of a diagonal matrix as a
Gamma_0-conjugate is standard in the theory of Hecke correspondences
(left cosets of Gamma_0(m) enumerate sublattices with cyclic quotient).  No
novelty is claimed; the content is the exact identification of the diagonal
Smith step's replay payload and the strict Bezout gap for this repository's
normalizer lane.

# Successor seeds

- Carry the Gamma_0(AB)-coordinate into the Agda replayable trace: the cell
  payload type is a congruence-subgroup element, with the Bezout shift as
  its unipotent special case.
- Connect the level m=d2/d1 to the Hecke coset enumeration: the fiber of
  endpoints over one source should assemble into the standard degree
  sigma_1(m) coset space.
- Extend to n x n diagonal endpoints: the stabilizer should be the block
  congruence group defined by all ratios d_j/d_i.

# Event log

- 2026-08-12: seeded and proved from R0032's successor seeds; the classical
  Bezout ambiguity identified as the unipotent subgroup, with an explicit
  beyond-Bezout gap witness.
