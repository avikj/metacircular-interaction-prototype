"""Exact replay for notes/DIVISOR_FLAG_LABEL_AUTOMATON.md (fleet-flag-automaton).

Successor seed 1 of R0038 (notes/HECKE_COMPOSITION_SMITH_LABELS.md): the
full Smith pair (e1, e2) = (p^i, p^{k-i}) of an index-p^k sublattice of
Z^2 as an automaton state along chains of index-p steps.  Column-lattice
conventions of machinery/hecke_coset_smith_assembly.py; composition of
Hermite bases via machinery/hecke_composition_smith_labels.py.

This is classical local Hecke combinatorics: the automaton is the radial
projection of the walk on the Bruhat-Tits tree of GL_2(Q_p) (Serre,
Trees, II.1) — the (p+1)-regular tree on homothety classes of lattices.
Laws replayed here (proofs in the note; no novelty claimed):

* Forward transitions (Theorem 1).  From a lattice of level k (index
  p^k) and label i (e1 = p^i):
    - 2i < k: exactly p of the p+1 index-p sublattices keep label i and
      exactly 1 raises it to i+1;
    - 2i = k (balanced, L = p^i Z^2): all p+1 keep label i.
  This is the time reversal of R0038's backward (1 keeper, p raisers)
  pattern into a fixed child.

* Path counting (Theorems 2-3).  The number of chains
  Z^2 = L_0 > L_1 > ... > L_k (each step index p) ending at a FIXED
  lattice of label i depends only on (i, k) and equals

      C_p(i,k) = sum_{j=0}^{i} (binom(k,j) - binom(k,j-1)) p^j,

  the ballot-sum closed form; equivalently the number of maximal
  subgroup chains of Z/p^i x Z/p^{k-i}, and the number of length-k walks
  from the root to a fixed vertex at distance k-2i in the tree.

* Tree dictionary (Theorem 4).  Chains of length k are exactly walks of
  length k from the root; dist([L]) = v_p(e2) - v_p(e1) = k - 2i, so
  label i = (k - dist)/2; keep steps move away from the root, raise
  steps toward it; the sphere of radius k has (p+1)p^{k-1} = psi(p^k)
  vertices, the classes of the cyclic stratum.

All computations are exact integers.
"""

from math import comb, gcd

from hecke_composition_smith_labels import compose
from hecke_coset_smith_assembly import hnf_bases, smith_invariants

__all__ = [
    "IDENTITY",
    "vp",
    "level_label",
    "index_p_sublattices",
    "predicted_forward_split",
    "observed_forward_split",
    "chain_count_dp",
    "ballot",
    "chain_count_closed",
    "enumerate_chains",
    "primitive_rep",
    "tree_ball",
]

IDENTITY = ((1, 0), (0, 1))


def vp(n, p):
    """Exact p-adic valuation of a positive integer."""
    if n <= 0:
        raise ValueError("vp needs a positive integer")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def level_label(basis, p):
    """(label i, level k) of a Hermite basis whose index is a power of p:
    index = p^k and e1 = p^i, so the Smith pair is (p^i, p^{k-i})."""
    (a, _), (b, d) = basis
    index = a * d
    k = vp(index, p)
    if p ** k != index:
        raise ValueError("index is not a power of p")
    return vp(smith_invariants(basis)[0], p), k


def index_p_sublattices(basis, p):
    """The p+1 index-p sublattices of L = basis Z^2 as Hermite bases in
    ambient coordinates: lines in L/pL correspond to hnf_bases(p) in L's
    own coordinates, composed back to Z^2-coordinates."""
    return [compose(basis, bn) for bn in hnf_bases(p)]


def predicted_forward_split(i, k, p):
    """Theorem 1: (keep, raise) transition multiplicities out of the
    state (i, k-i): (p, 1) when 2i < k, and (p+1, 0) when 2i = k (the
    balanced state p^i Z^2 cannot raise: 2(i+1) > k+1)."""
    if not 0 <= 2 * i <= k:
        raise ValueError("not a state: need 0 <= 2i <= k")
    return (p + 1, 0) if 2 * i == k else (p, 1)


def observed_forward_split(basis, p):
    """(keep, raise) counted by brute-force composition of Hermite
    bases; checks that the p+1 children are distinct lattices with
    labels in {i, i+1} only (R0038 interlacing)."""
    i, _ = level_label(basis, p)
    kids = index_p_sublattices(basis, p)
    assert len(set(kids)) == p + 1
    labels = [level_label(kid, p)[0] for kid in kids]
    assert set(labels) <= {i, i + 1}
    return labels.count(i), labels.count(i + 1)


def chain_count_dp(p, i, k):
    """C_p(i,k) by the proved backward recurrence (Theorem 2):
    C(0,0) = 1; C(0,k) = C(0,k-1); for i >= 1:
    C(i,k) = C(i,k-1) + p C(i-1,k-1) when 2i < k, and
    C(i,k) = (p+1) C(i-1,k-1) when 2i = k."""
    if not 0 <= 2 * i <= k:
        raise ValueError("not a state: need 0 <= 2i <= k")
    table = {(0, 0): 1}
    for level in range(1, k + 1):
        for lab in range(level // 2 + 1):
            if lab == 0:
                table[(lab, level)] = table[(0, level - 1)]
            elif 2 * lab == level:
                table[(lab, level)] = (p + 1) * table[(lab - 1, level - 1)]
            else:
                table[(lab, level)] = (table[(lab, level - 1)]
                                       + p * table[(lab - 1, level - 1)])
    return table[(i, k)]


def ballot(k, j):
    """binom(k,j) - binom(k,j-1): the number of +-1 paths of length k
    from 0 to k-2j never going below 0 (reflection principle)."""
    def b(n, r):
        return comb(n, r) if 0 <= r <= n else 0
    return b(k, j) - b(k, j - 1)


def chain_count_closed(p, i, k):
    """Theorem 3: C_p(i,k) = sum_{j<=i} (binom(k,j)-binom(k,j-1)) p^j."""
    if not 0 <= 2 * i <= k:
        raise ValueError("not a state: need 0 <= 2i <= k")
    return sum(ballot(k, j) * p ** j for j in range(i + 1))


def enumerate_chains(p, k):
    """All (p+1)^k chains Z^2 = L_0 > L_1 > ... > L_k with every step of
    index p, as tuples of Hermite bases in ambient coordinates."""
    chains = [(IDENTITY,)]
    for _ in range(k):
        chains = [chain + (kid,)
                  for chain in chains
                  for kid in index_p_sublattices(chain[-1], p)]
    return chains


def primitive_rep(basis):
    """The unique primitive (e1 = 1, cyclic) lattice in the homothety
    class {p^t L}: divide the Hermite basis by its content."""
    (a, _), (b, d) = basis
    c = gcd(gcd(a, b), d)
    return ((a // c, 0), (b // c, d // c))


def tree_ball(p, radius):
    """BFS ball of the Bruhat-Tits tree T_p from the root [Z^2]:
    dict {primitive Hermite basis (canonical class representative) ->
    graph distance <= radius}.  Neighbors of a class are the classes of
    the p+1 index-p sublattices of its primitive representative."""
    dist = {IDENTITY: 0}
    frontier = [IDENTITY]
    for r in range(1, radius + 1):
        nxt = []
        for v in frontier:
            for kid in index_p_sublattices(v, p):
                w = primitive_rep(kid)
                if w not in dist:
                    dist[w] = r
                    nxt.append(w)
        frontier = nxt
    return dist


def _demo():
    from collections import Counter
    for p in (2, 3):
        print(f"p = {p}: forward (keep, raise) by state, levels k <= 4")
        for k in range(5):
            row = {}
            for basis in hnf_bases(p ** k):
                i, _ = level_label(basis, p)
                split = observed_forward_split(basis, p)
                assert split == predicted_forward_split(i, k, p)
                row[i] = split
            print(f"  k={k}: " + ", ".join(
                f"i={i}:{row[i]}" for i in sorted(row)))
        chains = enumerate_chains(p, 4)
        counts = Counter(chain[-1] for chain in chains)
        print(f"  chains to level 4: {len(chains)} = (p+1)^4; per endpoint "
              f"C_p(i,4): " + ", ".join(
                  f"i={i}:{chain_count_closed(p, i, 4)}" for i in range(3)))
        dist = tree_ball(p, 4)
        spheres = Counter(dist.values())
        print(f"  tree ball spheres: {dict(sorted(spheres.items()))} "
              f"(= 1, then (p+1)p^(r-1))")


if __name__ == "__main__":
    _demo()
