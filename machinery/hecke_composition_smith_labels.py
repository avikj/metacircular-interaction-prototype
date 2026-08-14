"""Exact replay for notes/HECKE_COMPOSITION_SMITH_LABELS.md (fleet-hecke-comp).

Successor seed 2 of R0034: the Smith stratum label under composition of
sublattice degrees (Hecke composition).  Column-lattice convention of
machinery/hecke_coset_smith_assembly.py throughout: L = M Z^2, Hermite
basis ((a,0),(b,d)) means columns (a,b),(0,d), ad = index, 0 <= b < d.

Composition: if L = M Z^2 has index m in Z^2 and L'' has index n in L,
then in M-coordinates L'' = M N Z^2 for an index-n Hermite basis N, and
[Z^2 : L''] = mn (determinants multiply).  ``compose`` Hermite-reduces
the product M N back to the canonical basis of the composite lattice.

Laws replayed here (proofs in the note; all classical Hecke theory):

* Coprime multiplicativity.  For gcd(m,n) = 1 the composition map
  (index-m basis) x (relative index-n basis) -> (index-mn basis) is a
  bijection, and BOTH Smith invariants multiply:
  e_i(composite) = e_i(M) * e_i(N), i = 1, 2.  This is the lattice-level
  form of T_m T_n = T_{mn}.

* p-power multiplicity.  Chains Z^2 > L' > L'' with [Z^2:L'] = p^k and
  [L':L''] = p hit every index-p^{k+1} lattice L''; the number of chains
  through a fixed L'' is 1 if p does not divide e1(L'') and p+1 if it
  does — the lattice-level form of T_p T_{p^k} = T_{p^{k+1}} + p R_p
  T_{p^{k-1}} (R_p the homothety L -> pL).

* Label motion along one index-p step: e1(L') | e1(L'') | p e1(L''),
  i.e. the Smith label stays or is multiplied by p; for e1(L'') = p^i,
  i >= 1, exactly 1 of the p+1 intermediates keeps the label (p raise
  it) when 2i <= k, and all p+1 raise it when 2i = k+1 (L'' = p^i Z^2).

All computations are exact integers.
"""

from math import gcd

from hecke_coset_smith_assembly import (
    det2,
    hnf_bases,
    mat_mul,
    sigma1,
    smith_invariants,
)

__all__ = [
    "hermite_reduce",
    "compose",
    "compose_all",
    "coprime_composition_table",
    "chain_multiplicities",
    "predicted_multiplicity",
    "label_step_split",
]


def hermite_reduce(mat):
    """Exact Hermite reduction of a nonsingular integer 2x2 matrix by
    column operations (right GL_2(Z) action, which fixes the column
    lattice): returns the unique ((a,0),(b,d)) with a,d >= 1, 0 <= b < d,
    and mat Z^2 == result Z^2.  Matrices are row tuples, so ((a,0),(b,d))
    has columns (a,b) and (0,d) — the repo's Hermite-basis format."""
    if det2(mat) == 0:
        raise ValueError("hermite_reduce needs a nonsingular matrix")
    m = [list(mat[0]), list(mat[1])]

    def col_op(i, j, q):  # column i -= q * column j
        for r in range(2):
            m[r][i] -= q * m[r][j]

    def col_swap():
        for r in range(2):
            m[r][0], m[r][1] = m[r][1], m[r][0]

    # Euclid on the first row until m[0][1] == 0.
    while m[0][1] != 0:
        if m[0][0] == 0 or abs(m[0][1]) < abs(m[0][0]):
            col_swap()
        else:
            col_op(1, 0, m[0][1] // m[0][0])
    # Positive diagonal (negating a column fixes the lattice).
    if m[0][0] < 0:
        for r in range(2):
            m[r][0] = -m[r][0]
    if m[1][1] < 0:
        for r in range(2):
            m[r][1] = -m[r][1]
    # Reduce the corner: column 1 -= q * column 2 changes b by -q*d only.
    col_op(0, 1, m[1][0] // m[1][1])
    a, d, b = m[0][0], m[1][1], m[1][0]
    assert a >= 1 and d >= 1 and 0 <= b < d and m[0][1] == 0
    return ((a, 0), (b, d))


def compose(basis_m, basis_n):
    """Canonical Hermite basis of the composite lattice M N Z^2: basis_m
    is an index-m basis of L in Z^2, basis_n an index-n basis of L'' in
    L's own coordinates; the result has index m*n in Z^2."""
    return hermite_reduce(mat_mul(basis_m, basis_n))


def compose_all(m, n):
    """Dict: composite index-mn Hermite basis -> list of (basis_m,
    basis_n) pairs producing it.  Total pairs = sigma1(m) * sigma1(n)."""
    table = {}
    for bm in hnf_bases(m):
        for bn in hnf_bases(n):
            table.setdefault(compose(bm, bn), []).append((bm, bn))
    return table


def coprime_composition_table(m, n):
    """For gcd(m,n) = 1: the composition table, after checking the
    bijection and the Smith label product law on every pair.  Raises
    AssertionError if either law fails (it never does; see the note)."""
    if gcd(m, n) != 1:
        raise ValueError("coprime_composition_table needs gcd(m,n)=1")
    table = compose_all(m, n)
    assert set(table) == set(hnf_bases(m * n))
    for comp, pairs in table.items():
        assert len(pairs) == 1, (comp, pairs)
        (bm, bn), = pairs
        sm, sn, sc = (smith_invariants(bm), smith_invariants(bn),
                      smith_invariants(comp))
        assert sc == (sm[0] * sn[0], sm[1] * sn[1]), (bm, bn, comp)
    return table


def chain_multiplicities(p, k):
    """Multiplicity table for T_p T_{p^k}: composite index-p^{k+1} basis
    -> list of e1(L') over all chains Z^2 > L' > L'' with [Z^2:L'] = p^k
    and [L':L''] = p reaching it.  len(list) is the chain multiplicity."""
    table = {}
    for bm in hnf_bases(p ** k):
        e1m = smith_invariants(bm)[0]
        for bn in hnf_bases(p):
            table.setdefault(compose(bm, bn), []).append(e1m)
    return table


def predicted_multiplicity(basis, p):
    """The proved multiplicity pattern: 1 on the cyclic-at-p stratum,
    p+1 on lattices contained in p Z^2 (i.e. p | e1) — the coefficients
    of T_{p^{k+1}} + p R_p T_{p^{k-1}}."""
    return 1 if smith_invariants(basis)[0] % p != 0 else p + 1


def label_step_split(p, k):
    """For each composite L'' with e1(L'') = p^i, i >= 1: the pair
    (#chains whose intermediate keeps the label e1(L') = p^i,
     #chains whose intermediate had e1(L') = p^{i-1}).
    Proved pattern: (1, p) when 2i <= k, and (0, p+1) when 2i = k+1."""
    out = {}
    for comp, e1s in chain_multiplicities(p, k).items():
        e1c = smith_invariants(comp)[0]
        if e1c % p != 0:
            continue
        keep = sum(1 for e in e1s if e == e1c)
        raise_ = sum(1 for e in e1s if p * e == e1c)
        assert keep + raise_ == len(e1s)  # interlacing: no other labels
        out[comp] = (keep, raise_)
    return out


def _demo():
    for m, n in [(2, 3), (3, 4), (4, 9), (2, 9)]:
        table = coprime_composition_table(m, n)
        print(f"gcd({m},{n})=1: bijection onto {len(table)} = "
              f"sigma1({m * n}) lattices; both Smith invariants multiply")
    for p in (2, 3):
        for k in (1, 2, 3):
            table = chain_multiplicities(p, k)
            mults = {}
            for comp, e1s in table.items():
                lab = smith_invariants(comp)[0]
                mults.setdefault(lab, set()).add(len(e1s))
            print(f"p={p} k={k}: multiplicity by composite label "
                  f"{ {l: sorted(s) for l, s in sorted(mults.items())} }; "
                  f"total {sum(len(v) for v in table.values())} = "
                  f"sigma1({p ** (k + 1)}) + {p}*sigma1({p ** (k - 1)})")


if __name__ == "__main__":
    _demo()
