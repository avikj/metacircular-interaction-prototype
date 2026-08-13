"""Exact verification of `notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md`.

Theorem 1: for an orthogonal projection P and a self-adjoint A,

    rank((I - P) A P) == rank([P, A]) / 2.

Everything is exact `Fraction` arithmetic — this is certified symbolic
computation and a finite exhaustive verification, which `CLAUDE.md` admits as
proof-grade. No floating point appears anywhere, and nothing here is fitted,
correlated, or measured.

Anchored falsification (PROTOCOL §4): two planted-false formulas must fire,
and a non-self-adjoint witness must show the hypothesis is not removable. A
run in which the controls do not fire is a failed run, not a clean one.

    python3 machinery/leakage_commutator.py
"""
from __future__ import annotations

from fractions import Fraction
from itertools import product
from typing import Iterator, Sequence

Matrix = list[list[Fraction]]


# ---------------------------------------------------------------- linear algebra

def zeros(n: int, m: int | None = None) -> Matrix:
    m = n if m is None else m
    return [[Fraction(0) for _ in range(m)] for _ in range(n)]


def identity(n: int) -> Matrix:
    out = zeros(n)
    for i in range(n):
        out[i][i] = Fraction(1)
    return out


def matmul(a: Matrix, b: Matrix) -> Matrix:
    n, k, m = len(a), len(b), len(b[0])
    out = zeros(n, m)
    for i in range(n):
        row = a[i]
        for t in range(k):
            if row[t]:
                bt = b[t]
                oi = out[i]
                for j in range(m):
                    if bt[j]:
                        oi[j] += row[t] * bt[j]
    return out


def sub(a: Matrix, b: Matrix) -> Matrix:
    return [[x - y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def transpose(a: Matrix) -> Matrix:
    return [list(col) for col in zip(*a)]


def rank(a: Matrix) -> int:
    """Exact rank over Q by fraction-free-enough Gaussian elimination."""
    m = [row[:] for row in a]
    rows, cols = len(m), len(m[0])
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if m[i][c]), None)
        if pivot is None:
            continue
        m[r], m[pivot] = m[pivot], m[r]
        pv = m[r][c]
        for i in range(r + 1, rows):
            if m[i][c]:
                f = m[i][c] / pv
                for j in range(c, cols):
                    m[i][j] -= f * m[r][j]
        r += 1
        if r == rows:
            break
    return r


def is_self_adjoint(a: Matrix) -> bool:
    return a == transpose(a)


# ---------------------------------------------------------------- lenses

def partitions(elements: Sequence[int]) -> Iterator[list[list[int]]]:
    """All set partitions of `elements`."""
    if not elements:
        yield []
        return
    first, rest = elements[0], elements[1:]
    for smaller in partitions(rest):
        for i in range(len(smaller)):
            yield smaller[:i] + [[first] + smaller[i]] + smaller[i + 1 :]
        yield [[first]] + smaller


def lens(part: list[list[int]], n: int) -> Matrix:
    """Fiberwise-averaging orthogonal projection of a partition."""
    p = zeros(n)
    for block in part:
        w = Fraction(1, len(block))
        for x in block:
            for y in block:
                p[x][y] = w
    return p


def leakage_rank(p: Matrix, a: Matrix) -> int:
    n = len(p)
    return rank(matmul(sub(identity(n), p), matmul(a, p)))


def commutator(p: Matrix, a: Matrix) -> Matrix:
    return sub(matmul(p, a), matmul(a, p))


# ---------------------------------------------------------------- the checks

def check_pair(p: Matrix, a: Matrix) -> tuple[int, int]:
    return leakage_rank(p, a), rank(commutator(p, a))


def exhaustive_lens_pairs(max_n: int = 5) -> tuple[int, int]:
    """Every ordered pair of partition lenses through max_n points."""
    checked = failures = 0
    for n in range(1, max_n + 1):
        parts = list(partitions(list(range(n))))
        mats = [lens(q, n) for q in parts]
        for p, q in product(mats, repeat=2):
            lr, cr = check_pair(p, q)
            checked += 1
            if 2 * lr != cr:
                failures += 1
    return checked, failures


def exhaustive_diagonal_actions(max_n: int = 4, values: int = 3) -> tuple[int, int]:
    """Every small integer-diagonal (hence self-adjoint) action vs every lens."""
    checked = failures = 0
    for n in range(1, max_n + 1):
        mats = [lens(q, n) for q in partitions(list(range(n)))]
        for diag in product(range(values), repeat=n):
            a = zeros(n)
            for i, v in enumerate(diag):
                a[i][i] = Fraction(v)
            for p in mats:
                lr, cr = check_pair(p, a)
                checked += 1
                if 2 * lr != cr:
                    failures += 1
    return checked, failures


def deterministic_symmetric(n: int, seed: int) -> Matrix:
    """A reproducible integer symmetric matrix (no RNG: exact and replayable)."""
    a = zeros(n)
    for i in range(n):
        for j in range(i, n):
            v = Fraction(((seed * (i + 1) * (j + 2) + 7 * i + 3 * j) % 11) - 5)
            a[i][j] = v
            a[j][i] = v
    return a


def symmetric_actions(max_n: int = 5, seeds: int = 40) -> tuple[int, int]:
    checked = failures = 0
    for n in range(1, max_n + 1):
        mats = [lens(q, n) for q in partitions(list(range(n)))]
        for seed in range(seeds):
            a = deterministic_symmetric(n, seed)
            assert is_self_adjoint(a)
            for p in mats:
                lr, cr = check_pair(p, a)
                checked += 1
                if 2 * lr != cr:
                    failures += 1
    return checked, failures


# ---------------------------------------------------------------- controls

def control_no_half(max_n: int = 4) -> int:
    """Planted-false: rank[P,A] without the 1/2. Must fire."""
    fired = 0
    for n in range(2, max_n + 1):
        mats = [lens(q, n) for q in partitions(list(range(n)))]
        for p, q in product(mats, repeat=2):
            lr, cr = check_pair(p, q)
            if lr != cr:
                fired += 1
    return fired


def control_min_rank(max_n: int = 4) -> int:
    """Planted-false: min(rank A, rank P). Must fire."""
    fired = 0
    for n in range(2, max_n + 1):
        mats = [lens(q, n) for q in partitions(list(range(n)))]
        for p, q in product(mats, repeat=2):
            lr, _ = check_pair(p, q)
            if lr != min(rank(q), rank(p)):
                fired += 1
    return fired


def control_non_self_adjoint() -> tuple[int, int, int]:
    """A non-self-adjoint witness: the hypothesis is not removable.

    A is a single off-diagonal unit, so one block is rank 1 and its transpose
    block is 0. Then rank[P,A] = 1, which is odd — Corollary 2.3 fails, and
    2*leakage != rank of the commutator.
    """
    n = 2
    p = zeros(n)
    p[0][0] = Fraction(1)  # projection onto coordinate 0
    a = zeros(n)
    a[1][0] = Fraction(1)  # maps ran(P) into ran(I-P), nothing back
    assert not is_self_adjoint(a)
    lr, cr = check_pair(p, a)
    return lr, cr, 2 * lr


def main() -> int:
    print("Theorem 1:  rank((I-P) A P) == rank([P,A]) / 2")
    print("            P an orthogonal projection, A self-adjoint. Exact Fractions.\n")

    c1, f1 = exhaustive_lens_pairs(5)
    print(f"  lens pairs, n<=5              : {c1:>6} checked, {f1} failures")
    c2, f2 = exhaustive_diagonal_actions(4, 3)
    print(f"  integer-diagonal actions, n<=4: {c2:>6} checked, {f2} failures")
    c3, f3 = symmetric_actions(5, 40)
    print(f"  symmetric actions, n<=5       : {c3:>6} checked, {f3} failures")

    total_fail = f1 + f2 + f3
    print()
    print("  controls (each MUST fire):")
    k1 = control_no_half(4)
    k2 = control_min_rank(4)
    print(f"    planted-false 'rank[P,A]' (no 1/2)      : fired on {k1} cases")
    print(f"    planted-false 'min(rank A, rank P)'     : fired on {k2} cases")
    lr, cr, twice = control_non_self_adjoint()
    print(f"    non-self-adjoint witness                : leakage {lr}, "
          f"rank[P,A] {cr} (odd -> Cor 2.3 needs the hypothesis), 2*leakage {twice}")

    ok = (
        total_fail == 0
        and k1 > 0
        and k2 > 0
        and cr % 2 == 1
        and twice != cr
    )
    print()
    print("VERDICT:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
