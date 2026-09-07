"""cf-delta independent replay of DECOHERING_SENSOR_BLINDNESS.

Independent of machinery/decohering_sensor_blindness.py, which merely returns
len(values) for the decohering environment (asserting the theorem).  Here I
actually BUILD the Choi matrix

    J(Phi_q) = sum_i |i><i| (x) |q(i)><q(i)|

as a dense (|X||Y|) x (|X||Y|) rational matrix and compute its exact rank by
Gaussian elimination over Q.  The claim is Choi rank == |X| for every
deterministic q; Choi rank == min Stinespring/Kraus environment dimension.

Exact throughout.
"""

from fractions import Fraction


def rank_Q(rows):
    """Exact rank over Q by fraction Gaussian elimination (own implementation)."""
    M = [[Fraction(x) for x in row] for row in rows]
    n = len(M)
    if n == 0:
        return 0
    w = len(M[0])
    rank = 0
    for col in range(w):
        piv = next((r for r in range(rank, n) if M[r][col] != 0), None)
        if piv is None:
            continue
        M[rank], M[piv] = M[piv], M[rank]
        inv = M[rank][col]
        M[rank] = [v / inv for v in M[rank]]
        for r in range(n):
            if r != rank and M[r][col] != 0:
                f = M[r][col]
                M[r] = [M[r][t] - f * M[rank][t] for t in range(w)]
        rank += 1
        if rank == n:
            break
    return rank


def choi_matrix(q_values):
    """Build J = sum_i E_{ii} (x) E_{q(i)q(i)} as a dense rational matrix.

    q_values[i] = q(i), an index into Y = {0,...,|Y|-1}.
    Basis order: (x, y) -> x*|Y| + y.
    """
    X = len(q_values)
    Y = max(q_values) + 1 if q_values else 0
    dim = X * Y
    J = [[0 for _ in range(dim)] for _ in range(dim)]
    for i in range(X):
        yi = q_values[i]
        row = i * Y + yi
        # |i><i| (x) |yi><yi| contributes a single 1 at (row, row)
        J[row][row] += 1
    return J


def choi_rank(q_values):
    return rank_Q(choi_matrix(q_values))


def check(q_values, label):
    X = len(q_values)
    image = len(set(q_values))
    # coherent-overwrite environment = max fiber, computed from scratch
    fibers = {}
    for v in q_values:
        fibers[v] = fibers.get(v, 0) + 1
    coherent = max(fibers.values())
    cr = choi_rank(q_values)
    print(f"{label}: |X|={X} image={image} coherent(max fiber)={coherent} "
          f"Choi rank={cr}")
    assert cr == X, f"{label}: Choi rank {cr} != |X| {X}"
    return {"X": X, "image": image, "coherent": coherent, "choi_rank": cr}


def main():
    N = 8
    constant = check((0,) * N, "constant")
    injective = check(tuple(range(N)), "injective")
    residue = check(tuple(v % 3 for v in range(N)), "residue mod 3")
    # an asymmetric surjection as an extra control
    weird = check((0, 0, 0, 1, 2, 2, 3, 3), "asymmetric surjection")

    # DECISIVE CONTROL: constant learns nothing, injective preserves all,
    # yet both have Choi rank |X|.
    assert constant["choi_rank"] == injective["choi_rank"] == N
    assert constant["coherent"] == N and injective["coherent"] == 1
    assert constant["image"] == 1 and injective["image"] == N

    # sanity: the built Choi matrix is diagonal 0/1 with exactly |X| ones.
    for qv, lab in [((0,) * N, "constant"), (tuple(range(N)), "injective")]:
        J = choi_matrix(qv)
        ones = sum(J[i][i] for i in range(len(J)))
        offdiag = sum(J[i][j] for i in range(len(J)) for j in range(len(J)) if i != j)
        assert ones == len(qv) and offdiag == 0

    print("CONFIRMED: Choi rank == |X| for every deterministic sensor; "
          "constant and injective cost the same.")


if __name__ == "__main__":
    main()
