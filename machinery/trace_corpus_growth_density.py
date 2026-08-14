"""Exact replay for notes/TRACE_CORPUS_GROWTH_DENSITY.md (fleet-growth-density).

Successor seed 1 of R0041 (notes/VERIFIER_BLIND_FIBER_REWARD.md): the exact
incompressible density of the Smith trace corpus via free-subgroup growth.

For k >= 2 the matrices A_k = [[1,k],[0,1]] and B_k = [[1,0],[k,1]] generate
a free subgroup of rank 2 in SL_2(Z) (Sanov's theorem for k = 2, proved by
ping-pong in the note).  The sphere of word length exactly n in the alphabet
{A_k, B_k, A_k^-1, B_k^-1} therefore has exactly 4 * 3^(n-1) elements
(n >= 1), growth series (1+x)/(1-3x); the upper-unipotent elements of each
sphere are exactly A_k^{+-n}, i.e. 2 per sphere.  Everything here is exact
integer computation; the BFS over actual matrices simultaneously
machine-verifies freeness (no collisions) up to the explored radius.
"""

from fractions import Fraction

IDENT = ((1, 0), (0, 1))


def mat_mul(a, b):
    return (
        (a[0][0] * b[0][0] + a[0][1] * b[1][0],
         a[0][0] * b[0][1] + a[0][1] * b[1][1]),
        (a[1][0] * b[0][0] + a[1][1] * b[1][0],
         a[1][0] * b[0][1] + a[1][1] * b[1][1]),
    )


def det2(a):
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


def inv_sl2(a):
    """Inverse of a determinant-one integer matrix, exactly."""
    assert det2(a) == 1
    return ((a[1][1], -a[0][1]), (-a[1][0], a[0][0]))


def gen_a(k):
    """A_k = [[1,k],[0,1]] — upper unipotent, in Gamma_0(m) for every m."""
    return ((1, k), (0, 1))


def gen_b(k):
    """B_k = [[1,0],[k,1]] — lower unipotent, in Gamma_0(m) iff m | k."""
    return ((1, 0), (k, 1))


def alphabet(k):
    """The four-letter alphabet {A_k, B_k, A_k^-1, B_k^-1}."""
    a, b = gen_a(k), gen_b(k)
    return [a, b, inv_sl2(a), inv_sl2(b)]


def in_gamma0(mat, m):
    """mat in Gamma_0(m): integer, det 1, lower-left entry divisible by m."""
    return det2(mat) == 1 and mat[1][0] % m == 0


def in_gamma_principal(mat, m):
    """mat in Gamma(m): det 1 and mat congruent to the identity mod m."""
    return det2(mat) == 1 and all(
        (mat[i][j] - IDENT[i][j]) % m == 0 for i in range(2) for j in range(2)
    )


def is_upper_unipotent(mat):
    """mat = [[1,t],[0,1]] for some integer t (t = 0 allowed)."""
    return mat[0][0] == 1 and mat[1][1] == 1 and mat[1][0] == 0


def is_lower_unipotent(mat):
    return mat[0][0] == 1 and mat[1][1] == 1 and mat[0][1] == 0


def bfs_spheres(k, n_max):
    """Spheres of the Cayley graph of <A_k, B_k> in the 4-letter alphabet,
    computed on ACTUAL matrices (not abstract words).

    Returns a list [S_0, S_1, ..., S_{n_max}] of sets of matrices, where
    S_n is the set of group elements at word length exactly n.  If the
    group is free on {A_k, B_k}, then |S_n| = 4 * 3^(n-1) for n >= 1;
    conversely, |S_n| = 4 * 3^(n-1) for all n <= n_max certifies that no
    two distinct reduced words of length <= n_max collide (hence no
    nontrivial relation of length <= 2 * n_max).
    """
    letters = alphabet(k)
    seen = {IDENT}
    spheres = [{IDENT}]
    frontier = [IDENT]
    for _ in range(n_max):
        nxt = set()
        for g in frontier:
            for s in letters:
                h = mat_mul(g, s)
                if h not in seen:
                    nxt.add(h)
        seen |= nxt
        spheres.append(nxt)
        frontier = list(nxt)
    return spheres


def sphere_size_free(n):
    """Number of elements of word length exactly n in the free group of
    rank 2 with its 4-letter alphabet: 1 for n = 0, else 4 * 3^(n-1)."""
    return 1 if n == 0 else 4 * 3 ** (n - 1)


def growth_series_coeffs(n_max):
    """Coefficients of (1+x)/(1-3x) up to degree n_max, exactly: the
    series expansion is 1 + sum_{n>=1} 4*3^(n-1) x^n."""
    coeffs = [1]
    # (1+x)/(1-3x) = (1+x) * sum 3^n x^n; coefficient n>=1 is 3^n + 3^(n-1).
    for n in range(1, n_max + 1):
        coeffs.append(3 ** n + 3 ** (n - 1))
    return coeffs


def strings_up_to(b, length):
    """Exact number of strings over a b-letter alphabet of length <= length:
    (b^(length+1) - 1) // (b - 1) for b >= 2."""
    assert b >= 2 and length >= 0
    return (b ** (length + 1) - 1) // (b - 1)


def pigeonhole_conflates(n, b, length):
    """True iff ANY trace format whose records are strings of length
    <= length over a b-letter alphabet must conflate two distinct length-n
    payloads of the free sub-corpus: 4 * 3^(n-1) > #strings."""
    return sphere_size_free(n) > strings_up_to(b, length)


def min_fixed_record_length(n, b):
    """Smallest L with b^L >= 4 * 3^(n-1): the exact fixed-length record
    size (in b-ary symbols) that a lossless format needs at length n."""
    need = sphere_size_free(n)
    length, power = 0, 1
    while power < need:
        power *= b
        length += 1
    return length


def bezout_recordable_fraction(n):
    """Exact fraction of the length-n free sub-corpus that is upper
    unipotent (Bezout-recordable in the R0033 sense): 2 / (4 * 3^(n-1))."""
    assert n >= 1
    return Fraction(2, sphere_size_free(n))


def count_upper_unipotent(sphere):
    return sum(1 for g in sphere if is_upper_unipotent(g))


def count_lower_unipotent(sphere):
    return sum(1 for g in sphere if is_lower_unipotent(g))
