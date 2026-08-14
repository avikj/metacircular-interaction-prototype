"""Exact replay for notes/HECKE_COSET_SMITH_ASSEMBLY.md (cf-tessera).

Column-lattice convention: L = M Z^2, ambient action gamma . L = gamma L.
Index-m sublattices are enumerated by lower-triangular Hermite bases
((a,0),(b,d)) with ad=m, 0<=b<d; the first Smith invariant is gcd(a,b,d);
the cyclic stratum has psi(m) points, is one SL_2(Z)-orbit, and the
stabilizer of Z + mZ is Gamma_0(m).  All computations are exact integers.
"""

from math import gcd


def divisors(m):
    return [d for d in range(1, m + 1) if m % d == 0]


def sigma1(m):
    return sum(divisors(m))


def psi(m):
    """m * prod_{p | m} (1 + 1/p), exactly."""
    result = m
    n, p = m, 2
    while p * p <= n:
        if n % p == 0:
            result = result // p * (p + 1)
            while n % p == 0:
                n //= p
        p += 1
    if n > 1:
        result = result // n * (n + 1)
    return result


def hnf_bases(m):
    """All Hermite bases ((a,0),(b,d)) of index-m sublattices (columns)."""
    out = []
    for a in divisors(m):
        d = m // a
        for b in range(d):
            out.append(((a, 0), (b, d)))
    return out


def content(basis):
    (a, _), (b, d) = basis
    return gcd(gcd(a, b), d)


def cyclic_bases(m):
    return [basis for basis in hnf_bases(m) if content(basis) == 1]


def smith_invariants(basis):
    (a, _), (b, d) = basis
    e1 = gcd(gcd(a, b), d)
    m = a * d
    return (e1, m // e1)


def mat_mul(p, q):
    return tuple(
        tuple(sum(p[i][k] * q[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


def basis_matrix(basis):
    """Columns (a,b) and (0,d) as a matrix ((a,0),(b,d))."""
    (a, _), (b, d) = basis
    return ((a, 0), (b, d))


def same_lattice(m1, m2):
    """M1 Z^2 == M2 Z^2 iff M1^-1 M2 and M2^-1 M1 are integral: test via
    adjugate divisibility, exactly."""
    def divides(p, q):
        dp = det2(p)
        adj = ((p[1][1], -p[0][1]), (-p[1][0], p[0][0]))
        prod = mat_mul(adj, q)
        return all(prod[i][j] % dp == 0 for i in range(2) for j in range(2))
    return divides(m1, m2) and divides(m2, m1)


def stabilizes(gamma, m):
    """gamma . (Z + mZ) == Z + mZ."""
    d = ((1, 0), (0, m))
    return same_lattice(mat_mul(gamma, d), d)


def in_gamma0(gamma, m):
    return det2(gamma) == 1 and gamma[1][0] % m == 0


def transitivity_witness(basis):
    """A determinant-one gamma with gamma . L0 = L, for cyclic L: from
    U M V = diag(1, m), L = M Z^2 = U^-1 diag(1,m) Z^2 = U^-1 . L0, and a
    determinant -1 is repaired by the L0-stabilizing flip diag(1,-1)."""
    mat = basis_matrix(basis)
    u, _ = smith_2x2(mat)
    ui = inv_unimodular(u)
    if det2(ui) == -1:
        flip = ((1, 0), (0, -1))
        ui = mat_mul(ui, flip)  # flip stabilizes L0
    return ui


def inv_unimodular(m):
    d = det2(m)
    assert abs(d) == 1
    return ((m[1][1] * d, -m[0][1] * d), (-m[1][0] * d, m[0][0] * d))


def smith_2x2(mat):
    """Unimodular (U, V) with U mat V = diag(e1, e2), e1 | e2, via exact
    row/column Euclidean reduction."""
    a = [list(mat[0]), list(mat[1])]
    u = [[1, 0], [0, 1]]
    v = [[1, 0], [0, 1]]

    def row_op(i, j, q):  # row i -= q * row j
        for k in range(2):
            a[i][k] -= q * a[j][k]
            u[i][k] -= q * u[j][k]

    def col_op(i, j, q):  # col i -= q * col j
        for r in range(2):
            a[r][i] -= q * a[r][j]
            v[r][i] -= q * v[r][j]

    def row_swap():
        a[0], a[1] = a[1], a[0]
        u[0], u[1] = u[1], u[0]

    def col_swap():
        for r in range(2):
            a[r][0], a[r][1] = a[r][1], a[r][0]
            v[r][0], v[r][1] = v[r][1], v[r][0]

    for _ in range(200):
        if a[1][0] == 0 and a[0][1] == 0:
            break
        if a[0][0] == 0:
            if a[1][0] != 0:
                row_swap()
            else:
                col_swap()
            continue
        if a[1][0] % a[0][0] == 0 and a[0][1] % a[0][0] == 0:
            row_op(1, 0, a[1][0] // a[0][0])
            col_op(1, 0, a[0][1] // a[0][0])
            break
        if a[1][0] != 0 and abs(a[1][0]) < abs(a[0][0]):
            row_swap()
            continue
        if a[1][0] != 0:
            row_op(1, 0, a[1][0] // a[0][0])
            continue
        if a[0][1] != 0 and abs(a[0][1]) < abs(a[0][0]):
            col_swap()
            continue
        if a[0][1] != 0:
            col_op(1, 0, a[0][1] // a[0][0])
            continue
    # ensure divisibility e1 | e2 and positivity
    if a[1][1] % a[0][0] != 0:
        col_op(0, 1, -1)  # bring second diagonal into first column
        # now first column is (a00, a11); redo euclid
        while a[1][0] != 0:
            if abs(a[1][0]) < abs(a[0][0]):
                row_swap()
            else:
                row_op(1, 0, a[1][0] // a[0][0])
        col_op(1, 0, a[0][1] // a[0][0])
    if a[0][0] < 0:
        for r in range(2):
            a[r][0] = -a[r][0]
            v[r][0] = -v[r][0]
    if a[1][1] < 0:
        for r in range(2):
            a[r][1] = -a[r][1]
            v[r][1] = -v[r][1]
    assert a[0][1] == 0 and a[1][0] == 0, a
    assert a[1][1] % a[0][0] == 0, a
    uu = (tuple(u[0]), tuple(u[1]))
    vv = (tuple(v[0]), tuple(v[1]))
    return uu, vv
