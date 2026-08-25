"""Exact replay for notes/SMITH_PATH_COORDINATE_TORSOR.md (cf-tessera).

The R0027 cell A=((2,0),(1,0)), D=diag(1,0): the target stabilizer is the
infinite dihedral group D_inf = {S_{b,e}}, the transporter is a regular
D_inf-torsor with chart c(U) = (U_00, det U), and (k, s) is the minimal
retained path coordinate.  All functions are exact integer computations.
"""

A_MATRIX = ((2, 0), (1, 0))
D_MATRIX = ((1, 0), (0, 0))


def mat_mul(p, q):
    return tuple(
        tuple(sum(p[i][k] * q[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


def stab(b, e):
    """S_{b,e} = [[1,b],[0,e]], e in {+1,-1}: the full stabilizer of D."""
    assert e in (1, -1)
    return ((1, b), (0, e))


def stab_law(b, e, b2, e2):
    """Group law: S_{b,e} S_{b2,e2} = S_{b2 + b e2, e e2}."""
    return (b2 + b * e2, e * e2)


def chart_inverse(k, s):
    """U_{(k,s)} = [[k, 1-2k], [-s, 2s]]: the torsor chart inverse."""
    assert s in (1, -1)
    return ((k, 1 - 2 * k), (-s, 2 * s))


def chart(u):
    """c(U) = (U_00, det U); defined on the transporter."""
    return (u[0][0], det2(u))


def in_transporter(u):
    return abs(det2(u)) == 1 and mat_mul(u, A_MATRIX) == D_MATRIX


def intertwining(b, e, k, s):
    """Law (1): S_{b,e} . U_{(k,s)} = U_{(k - b s, e s)}."""
    return (k - b * s, e * s)


def torsor_solution(k, s, k2, s2):
    """The unique (b, e) with S_{b,e} . U_{(k,s)} = U_{(k2,s2)}."""
    e = s2 * s  # s2/s with s in {+-1}
    b = (k - k2) * s  # (k - k2)/s
    return (b, e)
