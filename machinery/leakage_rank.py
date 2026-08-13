"""Leakage rank of a lens pair equals summed incidence rank defect.

Independent exact implementation supporting `notes/LEAKAGE_RANK_IS_INCIDENCE_RANK.md`.

The object joins two lanes that currently do not cite each other:

  * `LENS_ORDER_COMMUTATION` (claude_ananta): two fiberwise-averaging
    projections commute iff  |B cap D| * |E| == |B| * |D|  for blocks inside
    each join block E.
  * `REPRESENTATION_REOPENING_CYCLE` (codex-vajra / codex-madhavi): an
    installed projector P stays sound for an admitted action A exactly while
    (I - P) A P == 0, and when it fails, rank((I - P) A P) is the exact
    dimension of the complementary correction channel that must be paid per
    application.

Theorem (this file's subject).  For partitions pi, sigma of a finite set with
counting measure, and P, Q the fiberwise-averaging projections,

    rank((I - P) Q P) = sum over E in pi join sigma of ( rank N_E - 1 ),

where N_E[B, D] = |B cap D| ranges over the pi-blocks and sigma-blocks
contained in the join block E.

Everything below is exact rational arithmetic.  Nothing here is a measurement.

Run:
    python3 machinery/leakage_rank.py
    python3 machinery/leakage_rank.py --extend 6
"""

from __future__ import annotations

import argparse
import itertools
from fractions import Fraction
from typing import Iterator, Sequence

Partition = tuple[tuple[int, ...], ...]
Matrix = list[list[Fraction]]


# ---------------------------------------------------------------- partitions


def partitions(points: Sequence[int]) -> Iterator[Partition]:
    """Every set partition of `points`, blocks sorted, canonical order."""
    if not points:
        yield ()
        return
    first, rest = points[0], points[1:]
    for sub in partitions(rest):
        for i in range(len(sub)):
            yield tuple(
                sorted(
                    (tuple(sorted(block + (first,))) if j == i else block)
                    for j, block in enumerate(sub)
                )
            )
        yield tuple(sorted(sub + ((first,),)))


def block_of(part: Partition, x: int) -> tuple[int, ...]:
    for block in part:
        if x in block:
            return block
    raise KeyError(x)


def join(pi: Partition, sigma: Partition, n: int) -> Partition:
    """Finest common coarsening: connected components of the block incidence."""
    parent = list(range(n))

    def find(a: int) -> int:
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a: int, b: int) -> None:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    for part in (pi, sigma):
        for block in part:
            for x in block[1:]:
                union(block[0], x)
    groups: dict[int, list[int]] = {}
    for x in range(n):
        groups.setdefault(find(x), []).append(x)
    return tuple(sorted(tuple(sorted(g)) for g in groups.values()))


# ------------------------------------------------------------ exact linear algebra


def rank(matrix: Matrix) -> int:
    """Exact rank over Q by fraction-free-safe Gaussian elimination."""
    rows = [list(r) for r in matrix]
    if not rows or not rows[0]:
        return 0
    n_rows, n_cols = len(rows), len(rows[0])
    r = 0
    for c in range(n_cols):
        pivot = next((i for i in range(r, n_rows) if rows[i][c] != 0), None)
        if pivot is None:
            continue
        rows[r], rows[pivot] = rows[pivot], rows[r]
        inv = Fraction(1) / rows[r][c]
        rows[r] = [v * inv for v in rows[r]]
        for i in range(n_rows):
            if i != r and rows[i][c] != 0:
                factor = rows[i][c]
                rows[i] = [a - factor * b for a, b in zip(rows[i], rows[r])]
        r += 1
        if r == n_rows:
            break
    return r


def averaging_projection(part: Partition, n: int) -> Matrix:
    """(P f)(x) = mean of f over the block containing x.  Self-adjoint idempotent."""
    mat = [[Fraction(0) for _ in range(n)] for _ in range(n)]
    for block in part:
        weight = Fraction(1, len(block))
        for x in block:
            for y in block:
                mat[x][y] = weight
    return mat


def mat_mul(a: Matrix, b: Matrix) -> Matrix:
    n, k, m = len(a), len(b), len(b[0])
    return [
        [sum((a[i][t] * b[t][j] for t in range(k)), Fraction(0)) for j in range(m)]
        for i in range(n)
    ]


def mat_sub(a: Matrix, b: Matrix) -> Matrix:
    return [[x - y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def identity(n: int) -> Matrix:
    return [[Fraction(1 if i == j else 0) for j in range(n)] for i in range(n)]


# ------------------------------------------------------------------ the two sides


def leakage_rank_direct(pi: Partition, sigma: Partition, n: int) -> int:
    """rank((I - P_pi) P_sigma P_pi) computed by literal matrix products."""
    p = averaging_projection(pi, n)
    q = averaging_projection(sigma, n)
    return rank(mat_mul(mat_sub(identity(n), p), mat_mul(q, p)))


def incidence_matrices(pi: Partition, sigma: Partition, n: int) -> list[Matrix]:
    """N_E[B, D] = |B cap D|, one matrix per join block."""
    out: list[Matrix] = []
    for e in join(pi, sigma, n):
        members = set(e)
        b_blocks = [b for b in pi if set(b) <= members]
        d_blocks = [d for d in sigma if set(d) <= members]
        out.append(
            [
                [Fraction(len(set(b) & set(d))) for d in d_blocks]
                for b in b_blocks
            ]
        )
    return out


def leakage_rank_closed_form(pi: Partition, sigma: Partition, n: int) -> int:
    """sum over join blocks of (rank N_E - 1)."""
    return sum(rank(mat) - 1 for mat in incidence_matrices(pi, sigma, n))


def integrality_violating_blocks(pi: Partition, sigma: Partition, n: int) -> int:
    """Count join blocks where |E| does not divide |B| * |D| for some pair.

    Corollary of the theorem (claude_ananta's obstruction, made quantitative):
    such a block has rank N_E >= 2, hence contributes at least 1 to leakage.
    """
    count = 0
    for e in join(pi, sigma, n):
        members = set(e)
        b_blocks = [b for b in pi if set(b) <= members]
        d_blocks = [d for d in sigma if set(d) <= members]
        if any(
            (len(b) * len(d)) % len(e) != 0 for b in b_blocks for d in d_blocks
        ):
            count += 1
    return count


# ------------------------------------------------------------------- verification


def check_exhaustive(n: int, verbose: bool = False) -> dict[str, int]:
    points = tuple(range(n))
    parts = list(partitions(points))
    stats = {
        "pairs": 0,
        "commuting": 0,
        "max_leakage": 0,
        "integrality_witnessed": 0,
    }
    for pi, sigma in itertools.product(parts, repeat=2):
        direct = leakage_rank_direct(pi, sigma, n)
        closed = leakage_rank_closed_form(pi, sigma, n)
        assert direct == closed, (pi, sigma, direct, closed)

        # Symmetry: leakage of sigma against pi is the same number.
        mirrored = leakage_rank_direct(sigma, pi, n)
        assert mirrored == direct, (pi, sigma, direct, mirrored)

        # Commutation criterion is the leakage-zero case.
        p = averaging_projection(pi, n)
        q = averaging_projection(sigma, n)
        commutes = mat_mul(p, q) == mat_mul(q, p)
        assert commutes == (direct == 0), (pi, sigma, commutes, direct)

        # Block-count upper bound.
        bound = min(len(pi), len(sigma)) - len(join(pi, sigma, n))
        assert direct <= bound, (pi, sigma, direct, bound)

        # Integrality corollary is a genuine lower bound.
        bad = integrality_violating_blocks(pi, sigma, n)
        assert direct >= bad, (pi, sigma, direct, bad)

        stats["pairs"] += 1
        stats["commuting"] += int(direct == 0)
        stats["max_leakage"] = max(stats["max_leakage"], direct)
        stats["integrality_witnessed"] += int(bad > 0)
        if verbose and direct:
            print(f"  {pi} x {sigma}: leakage {direct}, bound {bound}, bad {bad}")
    return stats


def known_false_controls(n: int = 4) -> None:
    """Two planted-false formulas must disagree with the direct computation."""
    points = tuple(range(n))
    parts = list(partitions(points))
    false_a_fired = False  # sum(rank N_E) without the -1
    false_b_fired = False  # |pi| + |sigma| - 2*|join|, a plausible Euler-type guess
    for pi, sigma in itertools.product(parts, repeat=2):
        direct = leakage_rank_direct(pi, sigma, n)
        false_a = sum(rank(m) for m in incidence_matrices(pi, sigma, n))
        false_b = len(pi) + len(sigma) - 2 * len(join(pi, sigma, n))
        false_a_fired |= false_a != direct
        false_b_fired |= false_b != direct
    assert false_a_fired, "control A never disagreed -- the test is vacuous"
    assert false_b_fired, "control B never disagreed -- the test is vacuous"
    print(f"  known-false controls both fired at n={n}")


def bridge_to_reopening_cycle(n: int = 5) -> int:
    """Confirm the interface identification against the reopening cycle's own code.

    Deliberately NOT an independent check: it imports
    `machinery.leakage_cost_vector.leakage`, the exact function the
    representation-reopening cycle consults.  Its job is to show that the
    matrix this theorem computes in closed form is the same matrix that lane
    already prices, not to re-verify the theorem.
    """
    try:
        from machinery.leakage_cost_vector import leakage as their_leakage
    except ImportError:  # direct-script invocation
        from leakage_cost_vector import leakage as their_leakage  # type: ignore

    checked = 0
    for pi, sigma in itertools.product(list(partitions(tuple(range(n)))), repeat=2):
        p = tuple(tuple(row) for row in averaging_projection(pi, n))
        q = tuple(tuple(row) for row in averaging_projection(sigma, n))
        theirs = rank([list(row) for row in their_leakage(p, q)])
        assert theirs == leakage_rank_closed_form(pi, sigma, n), (pi, sigma)
        checked += 1
    return checked


def worked_example() -> None:
    """The smallest strictly-positive leakage, printed in full."""
    n = 4
    pi = ((0, 1), (2, 3))
    sigma = ((0, 2), (1,), (3,))
    direct = leakage_rank_direct(pi, sigma, n)
    closed = leakage_rank_closed_form(pi, sigma, n)
    blocks = join(pi, sigma, n)
    print(f"  pi     = {pi}")
    print(f"  sigma  = {sigma}")
    print(f"  join   = {blocks}")
    for e, mat in zip(blocks, incidence_matrices(pi, sigma, n)):
        printable = [[int(v) for v in row] for row in mat]
        print(f"    E={e}: N_E={printable}, rank {rank(mat)}")
    print(f"  leakage rank: direct {direct}, closed form {closed}")
    print(
        "  reading: sector-only execution needs "
        f"{direct} correction scalar(s) per application"
    )


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--extend", type=int, default=5, help="exhaustive up to n")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    print("worked example (smallest positive leakage):")
    worked_example()

    print("\nknown-false controls:")
    known_false_controls()

    print("\nbridge to the reopening cycle's own leakage function:")
    print(f"  {bridge_to_reopening_cycle()} lens pairs agree with "
          "machinery.leakage_cost_vector.leakage (interface check, not independent)")

    print("\nexhaustive verification (all ordered partition pairs):")
    total = 0
    for n in range(1, args.extend + 1):
        stats = check_exhaustive(n, verbose=args.verbose)
        total += stats["pairs"]
        print(
            f"  n={n}: {stats['pairs']:6d} pairs, "
            f"{stats['commuting']:6d} commuting, "
            f"max leakage {stats['max_leakage']}, "
            f"{stats['integrality_witnessed']:5d} with an integrality witness"
        )
    print(f"\nALL EXACT CHECKS PASS ({total} ordered pairs)")


if __name__ == "__main__":
    main()
