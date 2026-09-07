#!/usr/bin/env python3
"""Exact certificate for notes/RESULTANT_OBSERVER_DEFECT.md.

The script uses only Python integers.  It checks the multiplication-matrix
determinant, modular collision dimensions, the q1 local defect decomposition,
and an equal-determinant control showing that a determinant does not determine
the cokernel module.
"""

from __future__ import annotations

import json
import sys


if not __debug__:
    raise SystemExit("refusing to run with assertions disabled")


def trim(a: list[int]) -> list[int]:
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def divmod_mod(a: list[int], b: list[int], p: int) -> tuple[list[int], list[int]]:
    a = trim([x % p for x in a])
    b = trim([x % p for x in b])
    if b == [0]:
        raise ZeroDivisionError
    q = [0] * max(1, len(a) - len(b) + 1)
    inv = pow(b[-1], -1, p)
    while a != [0] and len(a) >= len(b):
        shift = len(a) - len(b)
        coeff = a[-1] * inv % p
        q[shift] = coeff
        for i, value in enumerate(b):
            a[i + shift] = (a[i + shift] - coeff * value) % p
        trim(a)
    return trim(q), trim(a)


def gcd_mod(a: list[int], b: list[int], p: int) -> list[int]:
    a = trim([x % p for x in a])
    b = trim([x % p for x in b])
    while b != [0]:
        _, r = divmod_mod(a, b, p)
        a, b = b, r
    inv = pow(a[-1], -1, p)
    return [(x * inv) % p for x in a]


def reduce_mod_monic(poly: list[int], f: list[int]) -> list[int]:
    """Return poly modulo monic f; coefficients are ascending."""
    out = poly[:]
    n = len(f) - 1
    assert f[-1] == 1
    while len(out) > n:
        coeff = out[-1]
        shift = len(out) - len(f)
        for i in range(n):
            out[i + shift] -= coeff * f[i]
        out.pop()
    return out + [0] * (n - len(out))


def multiplication_matrix(f: list[int], g: list[int]) -> list[list[int]]:
    """Columns are g*x^j in Z[x]/(f), ascending basis."""
    n = len(f) - 1
    columns = []
    for j in range(n):
        columns.append(reduce_mod_monic(([0] * j) + g, f))
    return [[columns[j][i] for j in range(n)] for i in range(n)]


def bareiss_det(matrix: list[list[int]]) -> int:
    a = [row[:] for row in matrix]
    n = len(a)
    sign = 1
    previous = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot = next((i for i in range(k + 1, n) if a[i][k]), None)
            if pivot is None:
                return 0
            a[k], a[pivot] = a[pivot], a[k]
            sign *= -1
        pivot_value = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = a[i][j] * pivot_value - a[i][k] * a[k][j]
                assert numerator % previous == 0
                a[i][j] = numerator // previous
        previous = pivot_value
    return sign * a[-1][-1]


def valuation(n: int, p: int) -> int:
    n = abs(n)
    out = 0
    while n % p == 0:
        n //= p
        out += 1
    return out


def rank_mod(matrix: list[list[int]], p: int) -> int:
    a = [[x % p for x in row] for row in matrix]
    rows = len(a)
    cols = len(a[0]) if rows else 0
    rank = 0
    for col in range(cols):
        pivot = next((i for i in range(rank, rows) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], -1, p)
        a[rank] = [(x * inv) % p for x in a[rank]]
        for i in range(rows):
            if i != rank and a[i][col]:
                c = a[i][col]
                a[i] = [(x - c * y) % p for x, y in zip(a[i], a[rank])]
        rank += 1
    return rank


def main() -> None:
    # Ascending coefficients.
    q1 = [1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1]
    q1_star = list(reversed(q1))
    matrix = multiplication_matrix(q1, q1_star)
    determinant = bareiss_det(matrix)
    assert determinant == 735

    expected = {
        3: [1, 1],
        5: [4, 1],
        7: [1, 4, 1],
    }
    local = {}
    for p, expected_gcd in expected.items():
        gcd = gcd_mod(q1, q1_star, p)
        assert gcd == expected_gcd
        degree = len(gcd) - 1
        nullity = len(matrix) - rank_mod(matrix, p)
        assert degree == nullity
        assert valuation(determinant, p) >= degree
        assert valuation(determinant, p) == degree
        local[str(p)] = {
            "gcd_ascending": gcd,
            "defect_dimension": degree,
            "defect_order": p**degree,
            "resultant_valuation": valuation(determinant, p),
        }

    # At p=7 the quotient by h7 has basis (1,beta).  beta^8=1 and beta,
    # beta^3 are independent, so the syndrome really has two coordinates.
    h7 = expected[7]
    beta_powers = []
    current = [1]
    for _ in range(9):
        reduced = reduce_mod_monic(current, h7)
        beta_powers.append(tuple(x % 7 for x in reduced))
        current = [0] + current
    assert beta_powers[8] == beta_powers[0]
    b1, b3 = beta_powers[1], beta_powers[3]
    assert (b1[0] * b3[1] - b1[1] * b3[0]) % 7 == 3

    # Equal determinant does not determine the cokernel module:
    # diag(1,4) has local mod-2 defect dimension 1; diag(2,2) has dimension 2.
    control_a = [[1, 0], [0, 4]]
    control_b = [[2, 0], [0, 2]]
    assert bareiss_det(control_a) == bareiss_det(control_b) == 4
    defects = [2 - rank_mod(m, 2) for m in (control_a, control_b)]
    assert defects == [1, 2]

    report = {
        "schema": "exp62-resultant-observer-defect/v1",
        "q1_resultant": determinant,
        "factorization": {"3": 1, "5": 1, "7": 2},
        "local_defects": local,
        "mod7_beta_powers_0_through_8": beta_powers,
        "equal_determinant_control": {
            "determinant": 4,
            "mod2_defect_dimensions": defects,
            "interpretation": ["cokernel Z/4", "cokernel (Z/2)^2"],
        },
    }
    print(json.dumps(report, sort_keys=True, separators=(",", ":")))
    print("ALL EXACT CHECKS PASS", file=sys.stderr)


if __name__ == "__main__":
    main()
