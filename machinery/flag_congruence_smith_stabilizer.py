"""Exact replay for notes/FLAG_CONGRUENCE_SMITH_STABILIZER.md (cf-tessera).

For nonsingular diagonal D = diag(d_1..d_n) with d_i | d_j (i <= j), the
flag congruence group Gamma_0(D) = GL_n(Z) meet D GL_n(Z) D^-1 equals
{H : (d_i/d_j) | H_ij for i > j}, and is the two-sided stabilizer of D via
H -> (H, D^-1 H^-1 D).  Exact integers; n arbitrary, tests use n = 3.
"""

from fractions import Fraction


def mat_mul(p, q):
    n = len(p)
    return tuple(
        tuple(sum(p[i][k] * q[k][j] for k in range(n)) for j in range(n))
        for i in range(n)
    )


def det(m):
    n = len(m)
    if n == 0:
        return 1  # empty matrix: the 1x1 cofactor expansion needs this
    if n == 1:
        return m[0][0]
    total = 0
    for j in range(n):
        minor = tuple(row[:j] + row[j + 1:] for row in m[1:])
        total += (-1) ** j * m[0][j] * det(minor)
    return total


def diag(entries):
    n = len(entries)
    return tuple(
        tuple(entries[i] if i == j else 0 for j in range(n)) for i in range(n)
    )


def conjugate_by_diag(h, entries):
    """D^-1 H D as exact fractions; returns (matrix of Fractions)."""
    n = len(entries)
    return tuple(
        tuple(Fraction(h[i][j] * entries[j], entries[i]) for j in range(n))
        for i in range(n)
    )


def is_integral(m):
    return all(x.denominator == 1 for row in m for x in row)


def to_int(m):
    return tuple(tuple(int(x) for x in row) for row in m)


def in_flag_gamma0_congruence(h, entries):
    """The congruence description: (d_i/d_j) | h_ij for i > j."""
    if abs(det(h)) != 1:
        return False
    n = len(entries)
    for i in range(n):
        for j in range(i):
            ratio = entries[i] // entries[j]
            if entries[j] * ratio != entries[i]:
                raise ValueError("entries must form a divisor flag")
            if h[i][j] % ratio:
                return False
    return True


def in_flag_gamma0_conjugation(h, entries):
    """The conjugation description: D^-1 H D integral (and H unimodular)."""
    return abs(det(h)) == 1 and is_integral(conjugate_by_diag(h, entries))


def inverse_unimodular(m):
    """Exact inverse of a unimodular integer matrix via fractions."""
    n = len(m)
    d = det(m)
    assert abs(d) == 1
    cof = tuple(
        tuple(
            (-1) ** (i + j) * det(tuple(
                tuple(m[r][c] for c in range(n) if c != j)
                for r in range(n) if r != i
            ))
            for j in range(n)
        )
        for i in range(n)
    )
    # adjugate = transpose of cofactor matrix; inverse = adj / det
    return tuple(
        tuple(cof[j][i] * d for j in range(n)) for i in range(n)
    )


def stabilizer_partner(h, entries):
    """K = D^-1 H^-1 D, exact; requires membership."""
    k = conjugate_by_diag(inverse_unimodular(h), entries)
    assert is_integral(k)
    return to_int(k)


def two_sided_stabilizes(h, k, entries):
    d = diag(entries)
    return mat_mul(mat_mul(h, d), k) == d


def torsor_act(h, u, v, entries):
    return mat_mul(h, u), mat_mul(v, stabilizer_partner(h, entries))
