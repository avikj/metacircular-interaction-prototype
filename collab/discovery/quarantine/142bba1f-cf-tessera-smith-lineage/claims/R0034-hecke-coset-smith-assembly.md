---
id: R0034
title: Smith strata assemble the index-m sublattice space as Gamma_0 coset spaces
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-DIAGONAL_SMITH_CONGRUENCE_TORSOR
dependencies: R0033
statement_hash: cbf0857a2c07deb8b1f3ffb784d9541439122c9d2fd05467861ac03184754de8
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/HECKE_COSET_SMITH_ASSEMBLY.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0033 pinned the path fiber of one diagonal Smith normalization as a local
Gamma_0(m)-torsor.  Its Hecke seed asks how endpoint fibers over one source
organize globally: whether the classical degree-m coset space is built from
exactly these congruence groups, and what plays the stratum label.

# Rosetta bridge

The common object is the set of index-m sublattices of Z^2 under the ambient
SL_2(Z) action.  Hermite bases enumerate it; Smith invariants stratify it;
orbit-stabilizer identifies each cyclic-type stratum with a Gamma_0 coset
space; counting the two enumerations against each other yields an exact
divisor identity.

# Exact statement

Fix m>=1 and the column convention L=MZ^2 with ambient action gamma.L=gamma L. Every index-m sublattice has a unique Hermite basis ((a,0),(b,d)) (columns (a,b),(0,d)) with ad=m and 0<=b<d, so there are sigma_1(m) sublattices. The quotient Z^2/L is Z/e1 x Z/e2 with e1=gcd(a,b,d), and it is cyclic iff gcd(a,b,d)=1; the cyclic stratum has psi(m)=m prod_{p|m}(1+1/p) points. SL_2(Z) acts transitively on the cyclic stratum and the stabilizer of L0=Z+mZ is exactly Gamma_0(m)={gamma in SL_2(Z): m divides gamma_21}, so the stratum is SL_2(Z)/Gamma_0(m) and [SL_2(Z):Gamma_0(m)]=psi(m). Every index-m sublattice is c L' for a unique c with c^2|m and unique cyclic L' of index m/c^2, giving sigma_1(m)=sum over c^2|m of psi(m/c^2). The stratum label c is the first Smith invariant, recoverable endpoint data; the position inside a stratum is a Gamma_0 coset datum.

# Preservation ledger

- Preserves R0033's local torsor unchanged; adds the global assembly over
  one source lattice.
- Preserves the classical Hecke facts as classical: novelty is disclaimed
  and prior art named.
- Introduces a convention choice (column lattices, left action); the
  transpose exchanges it with the row convention and Gamma^0(m); tests pin
  the column convention.
- Forgets the Bezout-level path data inside each coset point; that fiber is
  exactly R0033's object.

# Proof obligations

1. Hermite existence/uniqueness and the sigma_1 count.
2. Cyclicity iff content one; psi count by multiplicativity plus the
   prime-power computation.
3. Stabilizer via conjugation integrality; transitivity via Smith
   normalization with a determinant repair inside the stabilizer.
4. The stratification bijection L=cL' and the boxed divisor identity.

# Falsification

- Exhibit two distinct Hermite data giving one lattice, or a lattice
  missing from the enumeration.
- Exhibit a content-one Hermite basis with noncyclic quotient.
- Exhibit gamma in SL_2(Z) stabilizing L0 with gamma_21 not divisible by m,
  or a cyclic lattice not reached from L0 by determinant-one action.
- Exhibit m with sigma_1(m) different from the stratified psi sum.

# Evidence

Proof: notes/HECKE_COSET_SMITH_ASSEMBLY.md.  Exact replay:
machinery/hecke_coset_smith_assembly.py and
machinery/test_hecke_coset_smith_assembly.py (eight tests: counts to m=40,
identity to m=400, pairwise-distinct lattices to m=12, stabilizer iff over
unimodular windows for four levels, Smith normalization over a full window
sweep, and explicit transitivity witnesses to m=15).

# Independent audit

Unclaimed.  Preferred audit: attack the uniqueness argument's three
projection invariants, the multiplicativity step in the psi count, and the
claim that the determinant repair diag(1,-1) suffices for every cyclic
basis; verify the convention pinning (column vs row) is consistent across
note, module, and R0033.

# Prior art

All four theorems are classical Hecke theory: sublattice counts sigma_1(m),
the index [SL_2(Z):Gamma_0(m)]=psi(m), and the cyclic-quotient coset
description are standard.  No novelty is claimed.  The content is the exact
assembly statement in this repository's objects: the global coset space is
built from the same congruence groups R0033 found as local path-fiber
stabilizers, with the first Smith invariant as stratum label.

# Successor seeds

- Push the assembly through the trace program: a full normalization run on
  a rank-two input is a point of one stratum's Gamma_0 coset space plus an
  R0033 path coordinate; formalize the pair as the total replay payload.
- Identify the Hecke operator T_m action on the stratified space and what
  the Smith label does under composition of degrees (T_m T_n for
  gcd(m,n)=1 versus p-power recursion).
- Extend the stratification identity to Z^n: sigma-like counts against
  block congruence stabilizers of flag type.

# Event log

- 2026-08-12: seeded and proved from R0033's Hecke seed; the boxed identity
  sigma_1(m) = sum_{c^2|m} psi(m/c^2) verified exactly to m=400.
