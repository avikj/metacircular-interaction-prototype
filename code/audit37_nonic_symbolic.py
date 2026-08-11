#!/usr/bin/env python3
"""Independent SymPy/Z3 audit of exp37's nonic Graeffe indexing.

This intentionally imports no production polynomial code. It checks the exact
coefficient-to-degree association and asks Z3 to find a counterexample to each
algebraic elimination implication. UNSAT here audits the integer formulas only;
it does not certify the root-geometry coefficient box or the full census.
"""

from __future__ import annotations

import sympy as sp
from z3 import Abs, Int, Solver, sat


def check_coefficients() -> None:
    a, b, c, d, e, f, h, j, y = sp.symbols("a b c d e f h j y")
    even = 1 + h * y + e * y**2 + c * y**3 + a * y**4
    odd = j + f * y + d * y**2 + b * y**3 + y**4
    polynomial = sp.Poly(sp.expand(even**2 - y * odd**2), y)
    actual = [sp.expand(polynomial.coeff_monomial(y**degree)) for degree in range(10)]
    expected = [
        1,
        2 * h - j**2,
        2 * e + h**2 - 2 * j * f,
        2 * c + 2 * h * e - 2 * j * d - f**2,
        2 * a + 2 * h * c + e**2 - 2 * j * b - 2 * f * d,
        2 * h * a + 2 * e * c - 2 * j - 2 * f * b - d**2,
        2 * e * a + c**2 - 2 * f - 2 * d * b,
        2 * c * a - 2 * d - b**2,
        a**2 - 2 * b,
        -1,
    ]
    assert actual == expected
    print("SymPy coefficient association: PASS")
    for degree, coefficient in enumerate(actual):
        print(f"  y^{degree}: {coefficient}")


def prove_elimination_implications() -> None:
    a, b, c, d, e, f, h, j = [Int(name) for name in "a b c d e f h j".split()]
    g2 = 2 * e + h * h - 2 * j * f
    g3 = 2 * c + 2 * h * e - 2 * j * d - f * f
    g6 = 2 * e * a + c * c - 2 * f - 2 * d * b
    eliminated_g3 = -f * f + 2 * h * j * f + 2 * c - 2 * j * d - h * h * h
    eliminated_g6 = 2 * a * j * f - a * h * h + c * c - 2 * f - 2 * d * b

    implications = [
        (
            "g3 elimination",
            [Abs(g2) <= 85, Abs(g3) <= 270],
            Abs(eliminated_g3) > 270 + 85 * Abs(h),
        ),
        (
            "g6 elimination",
            [Abs(g2) <= 85, Abs(g6) <= 300],
            Abs(eliminated_g6) > 300 + 85 * Abs(a),
        ),
    ]
    for name, premises, negated_conclusion in implications:
        solver = Solver()
        solver.add(*premises, negated_conclusion)
        result = solver.check()
        print(f"Z3 {name}: {result}")
        assert result != sat


if __name__ == "__main__":
    check_coefficients()
    prove_elimination_implications()
    print("nonic symbolic audit: PASS")
