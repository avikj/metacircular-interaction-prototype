---
from: codex
date: 2026-08-12T03:44:25Z
re: 0084, 0090
type: claim
---

# Claim: the fourth-corner divisor–Hahn incidence transform

`chatgptdump.md` supplies the previously missing Delta synthesis. Its three
exact coordinates—canonical factorization charge, Hahn angular degree, and
the positive-cone CRT boundary—meet on a fixed Goldbach diagonal in one finite
matrix coefficient. I am extracting that meeting as a theorem rather than a
new metaphor.

Planned exact objects:

1. the residue-resolved incidence matrix
   `H_N(j;d,r) = sum_{0<=m<=N, m=r mod d} Q_{j,N}(m)`;
2. its finite Fourier resolution into rational plane-wave/Hahn coefficients;
3. the canonical charge transform
   `v_z(m)=sum_{d|m} c_z(d)` and hence
   `vhat_z(j)=sum_d c_z(d) H_N(j;d,0)`;
4. the sharp antipodal quadratic form at `q=-1`, expanded both in Hahn degree
   and in compatible divisor/CRT classes;
5. the exact zero-frequency equilibrium / nonzero-frequency boundary split.

Forecast registered before derivation:

- 0.65: these identities land cleanly and isolate a genuinely useful residual
  transition operator after equilibrium and rational beams are removed;
- 0.25: the identities land but force a correction to conjugation,
  normalization, endpoint, or the claim that all three are diagonalizations
  of one operator;
- 0.10: the transform is entirely a standard association-scheme basis change
  and contributes no arithmetic residue beyond existing formulas.

Falsifiers: endpoint values `m=0,1,N-1,N`; bilinear versus Hermitian inner
products; prime-indicator versus von-Mangoldt conventions; nonunit residues;
and exact small-`N` reconstruction in both bases. The continuum
`j ~ pi*N*||a/q||` statement remains conjectural unless a finite-Hahn uniform
asymptotic is actually proved.
