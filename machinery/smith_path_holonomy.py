#!/usr/bin/env python3
"""Exact path-holonomy witness for adjacent diagonal Smith reduction."""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd

Matrix = tuple[tuple[int, ...], ...]


def identity(n: int) -> Matrix:
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def multiply(a: Matrix, b: Matrix) -> Matrix:
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0]))) for i in range(len(a)))


def diagonal(entries: tuple[int, ...]) -> Matrix:
    return tuple(tuple(entries[i] if i == j else 0
                       for j in range(len(entries))) for i in range(len(entries)))


def determinant3(a: Matrix) -> int:
    return (a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
            - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
            + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0]))


def extended_gcd(a: int, b: int) -> tuple[int, int, int]:
    if b == 0:
        return 1, 0, a
    x, y, g = extended_gcd(b, a % b)
    return y, x - (a // b) * y, g


def inverse_unimodular3(a: Matrix) -> Matrix:
    det = determinant3(a)
    if abs(det) != 1:
        raise ValueError("matrix is not unimodular")
    cof = []
    for i in range(3):
        row = []
        for j in range(3):
            rows = [r for r in range(3) if r != i]
            cols = [c for c in range(3) if c != j]
            minor = (a[rows[0]][cols[0]] * a[rows[1]][cols[1]]
                     - a[rows[0]][cols[1]] * a[rows[1]][cols[0]])
            row.append(((-1) ** (i + j)) * minor)
        cof.append(row)
    inverse = tuple(tuple(cof[j][i] // det for j in range(3)) for i in range(3))
    assert multiply(a, inverse) == multiply(inverse, a) == identity(3)
    return inverse


@dataclass(frozen=True)
class LocalStep:
    before: tuple[int, ...]
    after: tuple[int, ...]
    left: Matrix
    right: Matrix


def local_step(entries: tuple[int, ...], position: int) -> LocalStep:
    a, b = entries[position:position + 2]
    g = gcd(a, b)
    if g <= 0 or b % a == 0:
        raise ValueError("not a legal positive diagonal reduction")
    ap, bp = a // g, b // g
    x, y, unit = extended_gcd(ap, bp)
    assert unit == 1 and x * ap + y * bp == 1
    block_l = ((x, y), (-bp, ap))
    block_r = ((1, -y * bp), (1, x * ap))
    n = len(entries)
    left = [list(row) for row in identity(n)]
    right = [list(row) for row in identity(n)]
    for i in range(2):
        for j in range(2):
            left[position + i][position + j] = block_l[i][j]
            right[position + i][position + j] = block_r[i][j]
    left_m, right_m = tuple(map(tuple, left)), tuple(map(tuple, right))
    after = entries[:position] + (g, a * b // g) + entries[position + 2:]
    assert multiply(multiply(left_m, diagonal(entries)), right_m) == diagonal(after)
    assert abs(determinant3(left_m)) == abs(determinant3(right_m)) == 1
    return LocalStep(entries, after, left_m, right_m)


def follow(source: tuple[int, ...], schedule: tuple[int, ...]):
    current = source
    left = right = identity(len(source))
    for position in schedule:
        step = local_step(current, position)
        current = step.after
        left = multiply(step.left, left)
        right = multiply(right, step.right)
    assert multiply(multiply(left, diagonal(source)), right) == diagonal(current)
    return current, left, right


def reduce_cokernel(v: tuple[int, ...], d: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(0 if modulus == 1 else x % modulus for x, modulus in zip(v, d))


def act(h: Matrix, value: tuple[int, ...], d=(1, 2, 6)) -> tuple[int, ...]:
    image = tuple(sum(h[i][j] * value[j] for j in range(3)) for i in range(3))
    return reduce_cokernel(image, d)


def witness():
    source = (2, 3, 2)
    p = follow(source, (0, 1))
    q = follow(source, (1, 0))
    target = (1, 2, 6)
    assert p[0] == q[0] == target
    h = multiply(q[1], inverse_unimodular3(p[1]))
    k = multiply(inverse_unimodular3(q[2]), p[2])
    assert multiply(h, diagonal(target)) == multiply(diagonal(target), k)
    before = (0, 0, 1)
    after = act(h, before, target)
    carrier = tuple((0, a, b) for a in range(2) for b in range(6))
    fixed = tuple(z for z in carrier if act(h, z, target) == z)
    assert before != after == (0, 1, 4)
    assert fixed == ((0, 0, 0), (0, 0, 2), (0, 0, 4))
    assert all(act(h, act(h, act(h, z, target), target), target) == z
               for z in carrier)
    return source, target, p, q, h, before, after, fixed


def main() -> None:
    source, target, p, q, h, before, after, fixed = witness()
    print({"source": source, "target": target, "left_p": p[1], "left_q": q[1],
           "holonomy": h, "moved": (before, after), "fixed": fixed})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

