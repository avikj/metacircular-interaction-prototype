---
id: R0028
title: A three-point environmental port trivializes a constructor torsor and changes the installed action grammar
status: proving
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-INVARIANT_SCHEMA_COUPLING
dependencies: R0027
statement_hash: e0df4fbe64aeab06c93a933ba131d5931f6ebe2c904556a5221eb786246993a4
cycle: 3
max_cycles: 4
owner: codex-schema
breaker: codex-residual (independent derivation; survived, 2026-08-12)
source: notes/SITUATED_CONSTRUCTOR_PORT.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0027 proves that endpoint and invariant data leave a transporter torsor and
cannot canonically recover a constructor.  The open question is whether a real
environmental coupling can select a point without pretending the selection was
already intrinsic, and whether that selection alters later mathematics.

# Rosetta bridge

The common object is the evaluation map from a transporter to a live response
port.  Its domain is the residual path torsor; its codomain is the response
frame supplied by the current coupling.  Installing the selected transporter
point turns it from a path into a generator of future actions.

# Exact statement

Let X={0,1,2}, source s=0, target t=1, context c=2, and T={g in S_3:g(0)=1}. Then T has two elements tau=(0 1) and rho=(0 1 2), and is a torsor under H=Stab(1) by left multiplication. Three points are minimal for a transporter between distinct points to have more than one element. Evaluation ev_c:T->{0,2}, g maps to g(2), is an H-equivariant bijection. Therefore a supplied response r in {0,2} uniquely selects the constructor satisfying g(0)=1 and g(2)=r, while withdrawal of r restores the noncanonical torsor. Installing the selected constructor yields cyclic action grammars of different orders: <tau> has order 2 and <rho> has order 3; their second future actions distinguish them since tau^2(0)=0 while rho^2(0)=2.

# Preservation ledger

- Preserves both lawful constructors until a live response is supplied.
- Records response provenance and verifies endpoint plus port equations.
- A one-use endpoint quotient may forget the choice; repeated-use workloads
  cannot.
- Learned scores order proposals but are outside the exact certificate.
- No claim is made that group theory determines which human or environmental
  response ought to govern installation.

# Proof obligations

1. Enumerate the transporter and target stabilizer and prove the action free
   and transitive.
2. Prove three-point minimality and the evaluation bijection.
3. Prove equivariance under the target stabilizer.
4. Compute both installed cyclic grammars and a separating continuation.

# Falsification

- Find a third transporter element or a collision under evaluation at 2.
- Find a nonidentity stabilizer element fixing a transporter point.
- Produce a two-point example with a nontrivial transporter torsor.
- Show the two installed generators have equal order or equal second action on
  the source.
- Allow a high proposal score to override an exact mismatching port and require
  the certificate verifier to reject it.

# Evidence

Direct proof: `notes/SITUATED_CONSTRUCTOR_PORT.md`.  Exact replay:
`machinery/situated_constructor_port.py` and
`machinery/test_situated_constructor_port.py` (seven tests).

# Independent audit

`codex-residual` independently derived the torsor action, evaluation
equivariance and minimality, checked the implementation convention, and ran all
seven tests.  Verdict: survives as scoped.  It additionally verified that the
installed groups have different conjugacy-invariant cardinalities, so the
developmental difference is not a labeling artifact.  Scope condition: the
port selects the constructor but does not force the separate installation
policy; the source note states this explicitly.

# Prior art

Transporters as stabilizer torsors and permutation-group calculations are
standard.  No mathematical novelty is claimed.  The packet records an exact
integration at the repository's developmental-port boundary.

# Successor seeds

- Derive a port from an endogenous arithmetic continuation rather than naming
  the third-point response externally.
- Generalize evaluation to n points, where one port leaves a residual torsor
  of size (n-2)!, and classify the minimum response frame that trivializes it.
- Replace hard finite scores by a trained proposal geometry and measure search
  savings while retaining exact certification and provenance.

# Event log

- 2026-08-12: exact construction and seven-test replay completed; independent
  audit invited.
