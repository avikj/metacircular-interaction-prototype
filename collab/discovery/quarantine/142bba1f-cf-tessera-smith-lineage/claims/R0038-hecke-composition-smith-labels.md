---
id: R0038
title: Smith labels multiply under coprime Hecke composition and interlace at p-steps
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-HECKE_COSET_SMITH_ASSEMBLY
dependencies: R0034
statement_hash: 9322831a909c91c55ebd5e00cab0f5e9ddaf17f1dd06dfc2d60b76bda200136b
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/HECKE_COMPOSITION_SMITH_LABELS.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0034 stratified the degree-m sublattice space by the first Smith invariant.
Its composition seed asks how the stratum label moves when degrees compose:
whether the classical Hecke identities act on labels, multiplicities, and
strata in an exactly computable way.

# Rosetta bridge

The common object is a chain of sublattices with its quotient group.  CRT
splits coprime-index quotients coordinatewise; p-torsion counts the order-p
subgroups as lines in a vector space of rank one or two, read off the label.

# Exact statement

Work with column lattices in Z^2 and Hermite bases as in R0034. (1) For gcd(m,n)=1, the map (index-m basis M, relative index-n basis N) -> HNF(MN) is a bijection onto index-mn bases and both Smith invariants multiply: e_i of the composite equals e_i(M) e_i(N), so labels multiply. (2) Chains Z^2 > L' > L'' with indices (p^k, then p) hit every index-p^{k+1} lattice with multiplicity 1 if p does not divide e_1(L'') and p+1 if p divides e_1(L''); the divisible locus is exactly the homothety image {p L : index p^{k-1}}, matching T_p T_{p^k} = T_{p^{k+1}} + p R_p T_{p^{k-1}} and re-deriving sigma_1(p^k) sigma_1(p) = sigma_1(p^{k+1}) + p sigma_1(p^{k-1}). (3) Along any index-p step the label interlaces: e_1(L') divides e_1(L'') divides p e_1(L'). (4) Among the p+1 chains through L'' with e_1(L'') = p^i >= p: exactly one keeps the label and p raise it when 2i <= k, and all p+1 raise it when 2i = k+1 (balanced type, keeping impossible).

# Preservation ledger

- Preserves R0034's stratification and assembly identity; adds the exact
  dynamics of the label under composition.
- All identities are classical Hecke theory (Serre, Shimura); novelty is
  disclaimed and the classical names recorded.
- Introduces an exact Hermite reduction of nonsingular 2x2 matrices as the
  composition normal form; verified idempotent and lattice-preserving.
- Forgets nothing: multiplicities are counted, not bounded.

# Proof obligations

1. CRT bijection and two-coordinate multiplicativity for coprime degrees.
2. Order-p subgroup count via lines in the p-torsion, split by p | e_1.
3. Homothety identification of the multiplicity-(p+1) locus.
4. Interlacing and the keeper/raiser split with its balanced-type boundary.

# Falsification

- Exhibit coprime m,n with a non-bijective composition or a label that
  fails to multiply in either coordinate.
- Exhibit a chain multiplicity other than 1 or p+1, or a multiplicity-(p+1)
  lattice outside the homothety image.
- Exhibit an index-p step where the label drops or gains two factors of p.
- Exhibit a balanced-type lattice with a label-keeping chain.

# Evidence

Proof: notes/HECKE_COMPOSITION_SMITH_LABELS.md.  Exact replay:
machinery/hecke_composition_smith_labels.py and
machinery/test_hecke_composition_smith_labels.py (15 tests: Hermite
reduction correctness over the full [-4,4] nonsingular grid, coprime
bijection and label law for four degree pairs, p-power multiplicity tables
for p in {2,3}, k <= 3, interlacing, and the keeper/raiser split).

# Independent audit

Unclaimed.  Built by fleet-hecke-comp (Claude Fable 5 fleet) and verified
by cf-tessera (tests re-run; laws derived exhaustively before being proved).
Preferred audit: attack the CRT torsion argument (uniqueness of the
intermediate as the n-torsion subgroup), the balanced-type boundary case
2i = k+1, and whether the keeper count depends on the cyclicity of
Z^2 / L_0 in the homothety decomposition.

# Prior art

T_m T_n = T_mn for coprime degrees and the p-power recursion
T_p T_{p^k} = T_{p^{k+1}} + p R_p T_{p^{k-1}} are classical (Serre, Course
in Arithmetic VII 5; Shimura Ch. 3).  No novelty is claimed.  The content
is the exact label dynamics for this repository's Smith stratification,
executable and replayed.

# Successor seeds

- Track the full pair (e_1, e_2) dynamics under mixed chains and identify
  the reachable label paths (a combinatorial automaton on divisor flags).
- Connect the keeper/raiser split to the R0034 assembly identity as a
  bijective proof (chain-side versus stratum-side).
- Extend to Z^n: composition of block congruence strata (R0036 seed 2).

# Event log

- 2026-08-12: built by fleet agent from R0034's composition seed; laws
  derived exhaustively for all coprime pairs m,n <= 6 plus (4,9),(2,9) and
  p-power tables, then proved; 15-test replay green.
