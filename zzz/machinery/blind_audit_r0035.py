"""Blind hostile audit of registry claim R0035 (fleet-blind-r0035).

Independent implementation, derived ONLY from the claim statement.  The
owner's files (total_smith_replay_payload.*, diagonal_smith_congruence_torsor.*)
were NOT read.

Claim under attack
------------------
M nonsingular 2x2 integer matrix, elementary divisors (e1, e2), m = e2/e1.
Normalization events (U, V, D): U, V in GL_2(Z), U M V = D = diag(e1, e2)
normalized.  Claimed:

  (a) every event has the same D;
  (b) the event set is a regular Gamma_0(m)-torsor (Gamma_0(m) in GL_2(Z))
      under H.(U, V) = (H U, V D^{-1} H^{-1} D);
  (c) for a fixed base event (U0, V0), pi(U, V) = U U0^{-1} is a bijection
      onto Gamma_0(m), inverse H -> (H U0, V0 D^{-1} H^{-1} D);
  (d) det U = det(pi) det(U0) is payload data;
  (e) changing the section right-translates all payloads by one fixed
      Gamma_0(m) element, so payload differences are section-independent.

Independent derivation used here (from scratch)
-----------------------------------------------
If U M V = D and U' M V' = D then, with H = U' U^{-1} and K = V^{-1} V',
H D K = D, so K = D^{-1} H^{-1} D exactly.  Since (D^{-1} X D)_{ij}
= x_{ij} d_j / d_i, integrality of K is equivalent to m | (H^{-1})_{21},
i.e. m | H_{21} (the adjugate only flips the sign of the off-diagonal
entry).  Hence the structure group is exactly

    Gamma_0(m) = { H in GL_2(Z) : m | H_{21} }        (both determinants),

and V is a *function* of U:  V = M^{-1} U^{-1} D.

Determinant law:  det U . det M . det V = det D = e1 e2 = |det M|, hence

    det U . det V = sign(det M).

The pair of determinants is constrained; det U alone is not, because
diag(1, -1) lies in Gamma_0(m) for every m.

Sign probe: diag(-1,1) U M V = diag(-e1, e2), and (-e1) | e2 as integers,
so the divisibility reading of "normalized" does NOT pin D; positivity of
the diagonal is load-bearing for (a).

Section change: if the new base is U0' = H0 U0 (H0 in Gamma_0(m)), then
pi' = U U0'^{-1} = pi H0^{-1}: a RIGHT translation, per M.  Right
translation is what preserves the left quotients pi_i pi_j^{-1}
(payload differences).

Exact integers only throughout; no floats anywhere.
"""

from math import gcd

I2 = ((1, 0), (0, 1))


# ----------------------------------------------------------------------
# exact 2x2 integer linear algebra
# ----------------------------------------------------------------------

def det2(A):
    return A[0][0] * A[1][1] - A[0][1] * A[1][0]


def mul(A, B):
    return (
        (A[0][0] * B[0][0] + A[0][1] * B[1][0],
         A[0][0] * B[0][1] + A[0][1] * B[1][1]),
        (A[1][0] * B[0][0] + A[1][1] * B[1][0],
         A[1][0] * B[0][1] + A[1][1] * B[1][1]),
    )


def adj(A):
    """Adjugate: A . adj(A) = det(A) I."""
    return ((A[1][1], -A[0][1]), (-A[1][0], A[0][0]))


def inv_unimodular(U):
    d = det2(U)
    assert d in (1, -1), "inv_unimodular needs det +-1"
    a = adj(U)
    if d == 1:
        return a
    return ((-a[0][0], -a[0][1]), (-a[1][0], -a[1][1]))


def is_unimodular(U):
    return det2(U) in (1, -1)


def freeze(A):
    return (tuple(A[0]), tuple(A[1]))


# ----------------------------------------------------------------------
# elementary divisors (2x2 exact)
# ----------------------------------------------------------------------

def smith_divisors(M):
    """(e1, e2) with e1 | e2, e1 = gcd of entries, e1 e2 = |det M|."""
    d = det2(M)
    assert d != 0, "M must be nonsingular"
    e1 = gcd(gcd(abs(M[0][0]), abs(M[0][1])),
             gcd(abs(M[1][0]), abs(M[1][1])))
    e2 = abs(d) // e1
    assert e1 * e2 == abs(d)
    assert e2 % e1 == 0, "2x2 Smith divisibility e1 | e2 failed"
    return e1, e2


# ----------------------------------------------------------------------
# deterministic Euclidean normalizer (an explicit computable section)
# ----------------------------------------------------------------------

def euclidean_normalizer(M):
    """Deterministic Smith normalization: returns (U, V, D) with
    U M V = D = diag(e1, e2), e1 | e2, e1, e2 > 0, U, V unimodular."""
    A = [list(M[0]), list(M[1])]
    U = [[1, 0], [0, 1]]
    V = [[1, 0], [0, 1]]

    def row_sub(i, j, q):          # row_i -= q * row_j  (left mult)
        for k in range(2):
            A[i][k] -= q * A[j][k]
            U[i][k] -= q * U[j][k]

    def row_swap():
        A[0], A[1] = A[1], A[0]
        U[0], U[1] = U[1], U[0]

    def row_neg(i):
        for k in range(2):
            A[i][k] = -A[i][k]
            U[i][k] = -U[i][k]

    def col_sub(j, i, q):          # col_j -= q * col_i  (right mult)
        for k in range(2):
            A[k][j] -= q * A[k][i]
            V[k][j] -= q * V[k][i]

    def col_swap():
        for k in range(2):
            A[k][0], A[k][1] = A[k][1], A[k][0]
            V[k][0], V[k][1] = V[k][1], V[k][0]

    for _ in range(10000):
        if A[0][0] == 0:
            if A[1][0] != 0:
                row_swap()
            elif A[0][1] != 0:
                col_swap()
            else:
                row_swap()
                col_swap()
        # clear first column by Euclid
        while A[1][0] != 0:
            q = A[1][0] // A[0][0]
            row_sub(1, 0, q)
            if A[1][0] != 0:
                row_swap()
        # clear first row by Euclid (may re-dirty the column -> outer loop)
        while A[0][1] != 0:
            q = A[0][1] // A[0][0]
            col_sub(1, 0, q)
            if A[0][1] != 0:
                col_swap()
        if A[1][0] != 0:
            continue
        # divisibility fix
        if A[1][1] % A[0][0] != 0:
            col_sub(0, 1, -1)      # col0 += col1: puts A[1][1] into A[1][0]
            continue
        break
    else:                          # pragma: no cover
        raise RuntimeError("normalizer failed to terminate")

    if A[0][0] < 0:
        row_neg(0)
    if A[1][1] < 0:
        row_neg(1)

    Uf, Vf, Df = freeze(U), freeze(V), freeze(A)
    e1, e2 = smith_divisors(M)
    assert Df == ((e1, 0), (0, e2)), (Df, e1, e2)
    assert is_unimodular(Uf) and is_unimodular(Vf)
    assert mul(mul(Uf, M), Vf) == Df
    return Uf, Vf, Df


# ----------------------------------------------------------------------
# event set, structurally: V is a function of U
# ----------------------------------------------------------------------

def solve_V(M, U, D):
    """Unique rational solution V = M^{-1} U^{-1} D of U M V = D;
    returned iff integral (then automatically unimodular), else None."""
    d = det2(M)
    N = mul(mul(adj(M), inv_unimodular(U)), D)   # = d * V
    if any(N[i][j] % d != 0 for i in range(2) for j in range(2)):
        return None
    V = ((N[0][0] // d, N[0][1] // d), (N[1][0] // d, N[1][1] // d))
    # det V = det(M^{-1}) det(U^{-1}) det(D) = sign(det M) det U in {+-1}
    assert is_unimodular(V)
    assert mul(mul(U, M), V) == D
    return V


def is_event_U(M, U, D):
    return is_unimodular(U) and solve_V(M, U, D) is not None


def unimodular_window(B):
    """All U in GL_2(Z) with entries in [-B, B]."""
    rng = range(-B, B + 1)
    out = []
    for a in rng:
        for b in rng:
            for c in rng:
                for d in rng:
                    if a * d - b * c in (1, -1):
                        out.append(((a, b), (c, d)))
    return out


def enumerate_events(M, B, D=None):
    """All events (U, V) with U entries in [-B, B] (exhaustive, exact)."""
    if D is None:
        e1, e2 = smith_divisors(M)
        D = ((e1, 0), (0, e2))
    evts = []
    for U in unimodular_window(B):
        V = solve_V(M, U, D)
        if V is not None:
            evts.append((U, V))
    return evts


def minimal_window_bound(M, Bmax=20):
    """Smallest B such that some event has all |U entries| <= B.
    Exhaustive check certifies windows below it are empty."""
    e1, e2 = smith_divisors(M)
    D = ((e1, 0), (0, e2))
    for B in range(0, Bmax + 1):
        if any(solve_V(M, U, D) is not None for U in unimodular_window(B)):
            return B
    return None


# ----------------------------------------------------------------------
# Gamma_0(m) in GL_2(Z), the claimed action, payloads
# ----------------------------------------------------------------------

def in_gamma0(H, m):
    return is_unimodular(H) and H[1][0] % m == 0


def conj_Dinv(X, e1, e2):
    """D^{-1} X D for D = diag(e1, e2); None if not integral."""
    m = e2 // e1
    num = X[1][0] * e1
    if num % e2 != 0:
        return None
    return ((X[0][0], X[0][1] * m), (num // e2, X[1][1]))


def act(H, event, e1, e2):
    """Claimed action H.(U, V) = (H U, V D^{-1} H^{-1} D); None if the
    conjugate is not integral (i.e. H outside Gamma_0(m))."""
    U, V = event
    C = conj_Dinv(inv_unimodular(H), e1, e2)
    if C is None:
        return None
    return (mul(H, U), mul(V, C))


def payload(event, base_event):
    """pi(U, V) = U U0^{-1}."""
    return mul(event[0], inv_unimodular(base_event[0]))


def payload_inverse(H, base_event, e1, e2):
    """Claimed inverse of pi: H -> (H U0, V0 D^{-1} H^{-1} D)."""
    return act(H, base_event, e1, e2)


def sample_gamma0(m, depth=3):
    """Deterministic finite sample of Gamma_0(m) in GL_2(Z): all products
    of <= depth generators (both determinant classes included)."""
    gens = [((1, 1), (0, 1)), ((1, -1), (0, 1)),
            ((1, 0), (m, 1)), ((1, 0), (-m, 1)),
            ((-1, 0), (0, 1)), ((1, 0), (0, -1))]
    seen = {I2}
    frontier = [I2]
    for _ in range(depth):
        nxt = []
        for X in frontier:
            for g in gens:
                Y = mul(X, g)
                if Y not in seen:
                    seen.add(Y)
                    nxt.append(Y)
        frontier = nxt
    for H in seen:
        assert in_gamma0(H, m)
    return sorted(seen)


# ----------------------------------------------------------------------
# two independent deterministic sections (for joint 3)
# ----------------------------------------------------------------------

def section_euclid(M):
    U, V, _D = euclidean_normalizer(M)
    return U, V


def section_lexmin(M, Bmax=20):
    """Lexicographically least-U event inside the minimal nonempty window.
    A second, genuinely different computable section."""
    e1, e2 = smith_divisors(M)
    D = ((e1, 0), (0, e2))
    B = minimal_window_bound(M, Bmax)
    assert B is not None
    best = None
    for U in unimodular_window(B):
        if solve_V(M, U, D) is not None:
            if best is None or U < best:
                best = U
    return best, solve_V(M, best, D)
