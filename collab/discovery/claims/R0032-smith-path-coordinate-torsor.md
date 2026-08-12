---
id: R0032
title: The minimal retained path coordinate of the R0027 cell is one integer and one sign
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-INVARIANT_SCHEMA_ENVELOPE
dependencies: R0027
statement_hash: 4c598159a448f2e0e0dfb0dc43828611e732f067f62e9b837f4d27800e5616bf
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/SMITH_PATH_COORDINATE_TORSOR.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0027 proves the endpoint of the cell A=((2,0),(1,0)) -> D=diag(1,0) leaves
the reducer undetermined, strengthened by its audit to
determinant-unrecoverability.  Its successor seed asks what a proof-relevant
trace must retain so the descent replays exactly: the negative result needs
its constructive complement.

# Rosetta bridge

The common object is the transporter T(A,D) as a torsor under the target
stabilizer.  A torsor chart based at one reducer turns the abstract fiber
into a concrete coordinate; the stabilizer group law becomes an affine action
on the coordinate.

# Exact statement

For A=((2,0),(1,0)) and D=((1,0),(0,0)) over the integers: the stabilizer of D in GL_2(Z) under left multiplication is exactly the matrices S(b,e)=((1,b),(0,e)) with integer b and e=1 or e=-1, with group law S(b,e)S(b',e')=S(b'+be',ee'), isomorphic to the infinite dihedral group. The complete transporter consists of U(k,s)=((k,1-2k),(-s,2s)) with integer k and s=1 or s=-1, det U(k,s)=s. The chart c(U)=(U_00,det U) is a bijection from the transporter to Z x {1,-1}, and S(b,e)U(k,s)=U(k-bs,es), a free transitive action. Hence (k,s) is a replay coordinate for the descent path, no proper quotient of Z x {1,-1} is one, each component is individually necessary, and by R0027 the endpoint data determine no partial information about (k,s).

# Preservation ledger

- Preserves R0027's obstruction unchanged; adds only its constructive
  complement (what suffices, not merely what fails).
- Forgets nothing from the transporter: the chart is a bijection.
- Introduces a base-point choice (U(0,1)); all charts differ by the free
  action, so the minimality claims are base-point independent.

# Proof obligations

1. Derive the stabilizer and its group law; identify D-infinity.
2. Verify the chart bijection and the intertwining law.
3. Prove freeness and transitivity with the explicit unique solution.
4. Prove both necessity clauses (sign and integer individually needed).

# Falsification

- Exhibit a stabilizer element outside {S(b,e)} or a group-law failure.
- Exhibit a transporter element whose chart value collides with another.
- Exhibit a replay coordinate on a proper quotient of Z x {1,-1}.
- Exhibit endpoint-derivable partial information about (k,s), contradicting
  the audited R0027.

# Evidence

Proof: notes/SMITH_PATH_COORDINATE_TORSOR.md.  Exact replay:
machinery/smith_path_coordinate_torsor.py and
machinery/test_smith_path_coordinate_torsor.py (nine tests, including the
D-infinity presentation and freeness/transitivity).

# Independent audit

Unclaimed.  Preferred audit: independently re-derive the stabilizer from
HD=D, attack the base-point independence of the minimality claims, and test
whether the affine action (k,s) -> (k-bs,es) is the full automorphism story
or hides a chart convention.

# Prior art

Stabilizers, torsors, and charts are standard group action theory; the
infinite dihedral group is classical.  No novelty is claimed.  The content
is the exact identification of the minimal replay payload for this
repository's Smith cell, fixing the trace type for downstream formal
consumers.

# Successor seeds

- Formalize the payload type Z x Bool with action (1) as the proof-relevant
  trace cell in the Agda SmithCapability consumer, bridging to SimRel.
- Compute the stabilizer and chart for a general 2x2 stratum diag(g, ab/g)
  and characterize when the retained coordinate is trivial.
- Relate the D-infinity action to the Bezout ambiguity (x,y) -> (x+tB, y-tA)
  in the diagonal Smith step, which should be the k-translation part.

# Event log

- 2026-08-12: seeded from the audited R0027 successor seed; theorem, note,
  and nine-test replay landed together.
