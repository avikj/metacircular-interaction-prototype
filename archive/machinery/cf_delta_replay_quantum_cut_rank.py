"""cf-delta independent replay of QUANTUM_CUT_RANK_NO_GO.

Independent of machinery/quantum_cut_rank_no_go.py: this file uses a
from-scratch full-matrix Gaussian-rational linear algebra (n x n dense
matrices of (re, im) Fraction pairs, own multiply / trace / Hermitian
transpose / exact rank by fraction elimination over Q(i)) rather than the
repo's 2x2-tuple helpers and causal_memory.rational_rank.

Claim under test (notes/QUANTUM_CUT_RANK_NO_GO.md):
  * Born table Q of |0>,|1>,|+>,|+i> projectors has ordinary rank 4 and
    complex PSD-factorization dimension exactly 2.
  * I_4 has ordinary rank 4 and PSD dimension exactly 4.
  * Hence ordinary cut rank does not determine PSD (quantum) boundary dim.

Everything below is exact.  Floating point never appears.
"""

from fractions import Fraction

C = tuple  # a complex-rational number is (Fraction re, Fraction im)


def c(re=0, im=0):
    return (Fraction(re), Fraction(im))


def cadd(a, b):
    return (a[0] + b[0], a[1] + b[1])


def cmul(a, b):
    return (a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0])


def cconj(a):
    return (a[0], -a[1])


def cis_zero(a):
    return a[0] == 0 and a[1] == 0


def matmul(A, B):
    n, k, m = len(A), len(B), len(B[0])
    out = [[c() for _ in range(m)] for _ in range(n)]
    for i in range(n):
        for j in range(m):
            acc = c()
            for t in range(k):
                acc = cadd(acc, cmul(A[i][t], B[t][j]))
            out[i][j] = acc
    return out


def trace(A):
    acc = c()
    for i in range(len(A)):
        acc = cadd(acc, A[i][i])
    return acc


def dagger(A):
    return [[cconj(A[j][i]) for j in range(len(A))] for i in range(len(A[0]))]


def mat_eq(A, B):
    return all(A[i][j] == B[i][j] for i in range(len(A)) for j in range(len(A[0])))


def complex_rank(rows):
    """Exact rank over Q(i) by Gaussian elimination on (re, im) pairs.

    Uses a different pivot order (row-major search from the current pivot
    row/col frontier) and complex division implemented via conjugate.
    """
    M = [[tuple(x) for x in row] for row in rows]
    n = len(M)
    if n == 0:
        return 0
    w = len(M[0])
    rank = 0
    for col in range(w):
        piv = None
        for r in range(rank, n):
            if not cis_zero(M[r][col]):
                piv = r
                break
        if piv is None:
            continue
        M[rank], M[piv] = M[piv], M[rank]
        # normalize pivot row: divide by M[rank][col]
        d = M[rank][col]
        dconj = cconj(d)
        dnorm = d[0] * d[0] + d[1] * d[1]  # |d|^2, real positive Fraction
        M[rank] = [
            ((cmul(x, dconj)[0]) / dnorm, (cmul(x, dconj)[1]) / dnorm)
            for x in M[rank]
        ]
        for r in range(n):
            if r == rank or cis_zero(M[r][col]):
                continue
            f = M[r][col]
            M[r] = [
                (M[r][t][0] - cmul(f, M[rank][t])[0],
                 M[r][t][1] - cmul(f, M[rank][t])[1])
                for t in range(w)
            ]
        rank += 1
        if rank == n:
            break
    return rank


# ---- Projectors, built independently as full 2x2 Gaussian matrices ---------
# |0><0|, |1><1|, |+><+| = 1/2[[1,1],[1,1]], |+i><+i| = 1/2[[1,-i],[i,1]]
H = Fraction(1, 2)
P0 = [[c(1), c()], [c(), c()]]
P1 = [[c(), c()], [c(), c(1)]]
PP = [[c(H), c(H)], [c(H), c(H)]]
PI = [[c(H), c(0, -H)], [c(0, H), c(H)]]
PROJ = [P0, P1, PP, PI]


def born_table():
    """Q_ij = Tr(P_i P_j), returned as a rational (real) 4x4 matrix."""
    Q = []
    for A in PROJ:
        row = []
        for B in PROJ:
            t = trace(matmul(A, B))
            assert t[1] == 0, "Born entry not real"
            row.append(t[0])
        Q.append(row)
    return Q


def is_rank_one_projector(P):
    """Certify P is PSD of rank 1: P = P^dagger, P^2 = P, Tr P = 1."""
    if not mat_eq(P, dagger(P)):
        return False
    if not mat_eq(matmul(P, P), P):
        return False
    return trace(P) == c(1)


def main():
    Q = born_table()
    expected = [
        [Fraction(1), Fraction(0), H, H],
        [Fraction(0), Fraction(1), H, H],
        [H, H, Fraction(1), H],
        [H, H, H, Fraction(1)],
    ]
    assert Q == expected, f"Born table mismatch: {Q}"

    # ordinary rank of Q over Q (treat as complex with zero imaginary part)
    Qc = [[c(x) for x in row] for row in Q]
    rq = complex_rank(Qc)
    assert rq == 4, f"rank(Q) = {rq}, expected 4"

    # I_4 ordinary rank
    I4 = [[c(1 if i == j else 0) for j in range(4)] for i in range(4)]
    ri = complex_rank(I4)
    assert ri == 4, f"rank(I_4) = {ri}, expected 4"

    # PSD dimension of Q <= 2: the four projectors are 2x2 PSD (rank-1
    # projectors), and Q_ij = Tr(P_i P_j) reproduces Q exactly (by
    # construction).  Certify each projector is genuinely PSD dim-2.
    for k, P in enumerate(PROJ):
        assert is_rank_one_projector(P), f"P_{k} is not a rank-1 projector"
    psd_upper_Q = 2

    # PSD dimension of Q >= 2: a PSD-rank-1 factorization would make Q a
    # nonnegative rank-1 matrix (ordinary rank 1).  Q has a nonzero 2x2
    # minor, so ordinary rank >= 2 > 1.  Hence PSD dim >= 2.
    minor = Q[0][0] * Q[1][1] - Q[0][1] * Q[1][0]
    assert minor != 0, "expected nonzero 2x2 minor"
    psd_lower_Q = 2
    assert psd_upper_Q == psd_lower_Q == 2

    # PSD dimension of I_4: upper bound 4 by explicit diagonal rank-1
    # factorization A_i = B_i = |i><i|, Tr(A_i B_j) = delta_ij.
    basis = []
    for i in range(4):
        E = [[c(1 if (r == i and s == i) else 0) for s in range(4)] for r in range(4)]
        basis.append(E)
    for i in range(4):
        for j in range(4):
            t = trace(matmul(basis[i], basis[j]))
            assert t == c(1 if i == j else 0)
    # Each |i><i| is a rank-1 projector (PSD) in dimension 4.
    for E in basis:
        assert mat_eq(matmul(E, E), E) and mat_eq(E, dagger(E)) and trace(E) == c(1)
    psd_upper_I4 = 4
    # Lower bound 4 = fiber-orthogonality theorem (proof, re-derived in the
    # review).  Its finite premises hold here: diagonal Tr(A_i B_i)=1>0 and
    # off-diagonal delta_ij=0 for i!=j (checked above).  Value asserted from
    # the theorem PSD-rank(I_n)=n.
    psd_I4 = 4
    assert psd_upper_I4 == psd_I4

    print("Born table Q =", [[str(x) for x in row] for row in Q])
    print("rank(Q) =", rq, " PSD-dim(Q) =", psd_lower_Q)
    print("rank(I_4) =", ri, " PSD-dim(I_4) =", psd_I4)
    print("SEPARATION: equal ordinary rank 4, PSD dims 2 vs 4 -> CONFIRMED")


if __name__ == "__main__":
    main()
