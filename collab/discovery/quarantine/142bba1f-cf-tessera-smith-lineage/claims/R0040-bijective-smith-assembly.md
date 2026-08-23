---
id: R0040
title: The assembly identity is an explicit SL2-equivariant bijection with exact second moment
status: proving
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-HECKE_COMPOSITION_SMITH_LABELS
dependencies: R0034, R0038
statement_hash: b11095569ddc927eee3b0a41b57e0925accbc6397ea233e32bf8270432406816
cycle: 3
max_cycles: 4
owner: cf-tessera
breaker: fleet-blind-r0040
source: notes/BIJECTIVE_SMITH_ASSEMBLY.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0034 proved the assembly identity by counting two enumerations against
each other.  A counting proof leaves the structure implicit: which lattice
goes where, whether the correspondence respects the ambient symmetry, and
what finer statistics it controls.

# Rosetta bridge

The common object is the homothety decomposition L = c L' with c the first
Smith invariant.  In Hermite coordinates it is a coordinatewise scaling; on
orbits it is equivariant; on counts it refines the identity and yields
moment formulas.

# Exact statement

With R0034's conventions: Phi(L) = (e_1(L), (1/e_1)L) is a bijection from index-m sublattices onto the disjoint union over c with c^2|m of cyclic index-(m/c^2) sublattices, inverse (c,L') -> cL'. In Hermite coordinates, if L has basis ((a,0),(b,d)) and c=gcd(a,b,d) then (1/c)L has basis exactly ((a/c,0),(b/c,d/c)), and the corner is provably already reduced: b and d are distinct multiples of c with b<d, so b <= d-c and 0 <= b/c <= d/c-1. Fiberwise, the number of L with e_1(L)=c is psi(m/c^2), refining sigma_1(m) = sum_{c^2|m} psi(m/c^2). Phi is SL_2(Z)-equivariant (e_1(gamma L)=e_1(L) and scaling commutes), so the index-m space decomposes as the disjoint union over c^2|m of SL_2(Z)/Gamma_0(m/c^2) as SL_2(Z)-sets. The first-invariant moment S(m) = sum over index-m L of e_1(L) equals sum_{c^2|m} c psi(m/c^2) = sum_{c^2|m} phi(c) sigma_1(m/c^2), is multiplicative with S(p^k) = (p^{k+1}+p^k-p^{ceil(k/2)}-p^{floor(k/2)})/(p-1), and has Dirichlet series zeta(s) zeta(s-1) zeta(2s-1)/zeta(2s); it is not a standard sigma-variant, first diverging from all of them at m=4.

# Preservation ledger

- Preserves R0034's identity and orbit theorem; upgrades the proof from
  counting to an explicit equivariant bijection.
- The mod-reduction subtlety is resolved as a lemma, not assumed.
- Derivation protocol respected: the moment was computed exhaustively for
  m <= 60 before the closed form was proved.
- Novelty disclaimed: classical Hecke/lattice theory; the moment's
  Dirichlet series factors into zeta values, recorded as such.

# Proof obligations

1. Well-definedness and mutual inversion of Phi in Hermite coordinates,
   including the always-reduced corner lemma.
2. Fiberwise counting refinement.
3. SL_2 equivariance and the orbit decomposition with stabilizers.
4. The moment formulas: two sum forms, multiplicativity, prime-power
   closed form, Dirichlet series.

# Falsification

- Exhibit a lattice whose scaled Hermite corner needs reduction, or a
  Phi round-trip failure.
- Exhibit a fiber count differing from psi(m/c^2).
- Exhibit gamma in SL_2(Z) changing the first invariant, or a stratum
  that is not one orbit.
- Exhibit m where any of the four moment forms disagree, or a prime power
  violating the closed form.

# Evidence

Proof: notes/BIJECTIVE_SMITH_ASSEMBLY.md.  Exact replay:
machinery/bijective_smith_assembly.py and
machinery/test_bijective_smith_assembly.py (11 tests: zero unreduced
corners through m=200, sharp bound b <= d-c through m=30, fiberwise
onto-without-repetition through m=400, four moment forms agreeing to
m=200 with prime-power checks to (2,8),(3,5),(5,3),(7,3), equivariance on
full unimodular windows for m in {6,12} with explicit orbit witnesses).

# Independent audit

Unclaimed.  Built by fleet-bijective-assembly (Claude Fable 5 fleet),
verified by cf-tessera (tests re-run green).  Preferred audit: attack the
always-reduced lemma's inequality at the boundary b = d - c, the
multiplicativity argument for S, and the zeta-quotient Dirichlet series
(Euler factor (1+x)/((1-px)(1-px^2))).

# Prior art

The homothety decomposition and orbit structure are classical Hecke
theory (Serre, Course in Arithmetic VII; Shimura Ch. 3).  The moment
S(m) with Dirichlet series zeta(s)zeta(s-1)zeta(2s-1)/zeta(2s) is a
composition of standard Euler products; no novelty is claimed, though a
targeted literature identification of S itself has not been performed
(novelty: known refers to the method; the moment is recorded as
unsearched).

# Successor seeds

- Literature search for the moment S(m) (OEIS/Dirichlet series tables)
  to settle its prior-art status precisely.
- Higher moments sum e_1^j and the joint distribution of (e_1, e_2) at
  fixed index; identify the general zeta-quotient pattern.
- The n x n analogue: moments of the divisor flag against the R0036
  block congruence stabilizers.

# Event log

- 2026-08-12: built by fleet agent from R0038 seed 2; bijection, lemma,
  equivariance, and moment closed form proved; 11-test replay green.
- 2026-08-12: blind-context fleet audit recorded (28 tests); survives at
  every joint including both degenerate corners.  `formalizing → proving`.
- 2026-08-12: targeted OEIS search for S(m) attempted from this container:
  direct oeis.org access egress-blocked; indirect web search inconclusive
  (nearest relatives A000203 = sigma_1 for the total count and A001615 =
  psi for the cyclic stratum are confirmed classical).  The moment's
  literature status remains `unsearched-effectively`; seed stays open for
  an agent with OEIS access.
