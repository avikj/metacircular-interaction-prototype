#!/usr/bin/env python3
"""The scaled-jet tower has unbounded depth, and its bottom is a power residue.

`notes/SCALED_JET_DEPTH.md` leaves one branch of its lemma unresolved: when the
scaled initial form `I_k` vanishes *as a function* on `F_p^n` while
`mu_k < e`, "the next scaled jet must be exposed", and the exact object is
called "a finite recursive jet tower".

This module exhibits the family that measures how deep that tower goes.  For
every prime `p` and every `m >= 1`, with `g(X) = X^p - p^(p-1) X`,

    f(X) = p^(m(p+1)) * u + g(X)^m,     x = 0,

has `e = m(p+1)`, `mu_1 = pm = e - m`, and initial form `(H^p - H)^m`, which is
identically zero as a function on `F_p`.  Depth 1 determines the valuation
**iff `-u` is not an m-th power modulo p**.  So the branch genuinely occurs,
the gap `e - mu_1 = m` is unbounded, and the decision at the bottom is a closed
power-residue condition rather than a recursion.

The sharp obstruction: the deciding datum is `s(h) = (h^p - h)/p mod p`, and
`s(h + p) = s(h) - 1`, so `s` is *not* a function of `h mod p`.  No criterion
phrased as the value-set of a form on `F_p^n` can decide this family.

Everything is exact integer arithmetic.
"""

from __future__ import annotations

from itertools import product


def valuation(number: int, prime: int) -> int:
    """v_p, with v_p(0) reported as a sentinel above any depth in use."""
    if number == 0:
        return 1 << 30
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def determines(polynomial, point: tuple[int, ...], prime: int, depth: int,
               order: int, arity: int) -> bool:
    """Exactly: does `x mod p^depth` determine `v_p(f(x)) = order`?

    `f(x + p^depth h) mod p^(order+1)` depends only on `h mod p^(order+1-depth)`
    because `f` has integer coefficients, so this finite sweep is complete --
    it is a decision procedure, not a sample.
    """
    reach = max(order + 1 - depth, 1)
    for shift in product(range(prime ** reach), repeat=arity):
        moved = tuple(point[i] + prime ** depth * shift[i] for i in range(arity))
        if valuation(polynomial(moved), prime) != order:
            return False
    return True


def minimal_depth(polynomial, point: tuple[int, ...], prime: int,
                  arity: int) -> tuple[int, int]:
    """The least chart depth determining the valuation, and that valuation.

    Determination is monotone in depth (the depth-(k+1) fibre is contained in
    the depth-k fibre), and depth `e+1` always determines, so the search
    terminates at `e+1`.
    """
    order = valuation(polynomial(point), prime)
    for depth in range(order + 2):
        if determines(polynomial, point, prime, depth, order, arity):
            return depth, order
    raise AssertionError("depth e+1 must determine")


def _multiply(left: list[int], right: list[int]) -> list[int]:
    out = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        if x:
            for j, y in enumerate(right):
                out[i + j] += x * y
    return out


def tower_family(prime: int, power: int, unit: int) -> tuple[list[int], int]:
    """Coefficients of `p^(m(p+1)) u + (X^p - p^(p-1) X)^m`, and its `e`."""
    if power < 1 or not 1 <= unit < prime:
        raise ValueError("need m >= 1 and a unit residue")
    generator = [0] * (prime + 1)
    generator[1] = -prime ** (prime - 1)
    generator[prime] = 1
    coefficients = [1]
    for _ in range(power):
        coefficients = _multiply(coefficients, generator)
    order = power * (prime + 1)
    coefficients[0] += prime ** order * unit
    return coefficients, order


def evaluate(coefficients: list[int], value: int) -> int:
    total = 0
    for coefficient in reversed(coefficients):
        total = total * value + coefficient
    return total


def initial_form_depth(coefficients: list[int], prime: int, depth: int) -> int:
    """`mu_k = min over nonzero alpha of v_p(c_alpha) + k|alpha|`."""
    return min(valuation(c, prime) + depth * d
               for d, c in enumerate(coefficients) if d > 0 and c != 0)


def initial_form_values(coefficients: list[int], prime: int,
                        depth: int) -> list[int]:
    """The scaled initial form `I_k` evaluated on all of `F_p`."""
    level = initial_form_depth(coefficients, prime, depth)
    values = []
    for point in range(prime):
        total = 0
        for degree, coefficient in enumerate(coefficients):
            if degree == 0 or coefficient == 0:
                continue
            if valuation(coefficient, prime) + depth * degree == level:
                # c_alpha * p^(k|alpha| - mu_k), an integer in either direction:
                # p^(mu_k - k|alpha|) divides c_alpha by the level condition.
                gap = depth * degree - level
                scaled = (coefficient * prime ** gap if gap >= 0
                          else coefficient // prime ** (-gap))
                total += scaled * point ** degree
        values.append(total % prime)
    return values


def fermat_shift(point: int, prime: int) -> int:
    """`s(h) = (h^p - h)/p mod p`, the datum the tower actually decides on.

    Lemma.  `s(h + p) = s(h) - 1 (mod p)`, hence `s` is surjective onto `F_p`
    and is not a function of `h mod p`.

    Proof.  Modulo `p^2`, `(h+p)^p = h^p + p * p * h^(p-1) + ... = h^p`, while
    `(h+p) = h + p`.  So `(h+p)^p - (h+p) = (h^p - h) - p (mod p^2)`; divide by
    `p`.  []
    """
    return ((point ** prime - point) // prime) % prime


def power_residues(prime: int, power: int) -> set[int]:
    """`{t^m : t in F_p}` -- the value set of `s^m`, since `s` is onto."""
    return {pow(residue, power, prime) for residue in range(prime)}


def predicts_determination(prime: int, power: int, unit: int) -> bool:
    """Theorem J: depth 1 determines iff `-u` is not an m-th power mod p."""
    return (-unit) % prime not in power_residues(prime, power)


def main() -> None:
    print("Theorem J:  f(X) = p^(m(p+1)) u + (X^p - p^(p-1) X)^m,  x = 0, k = 1")
    print("  p   m     e   mu_1  gap   -u   m-th powers      depth 1?  predicted")
    for prime in (3, 5, 7):
        for power in (1, 2, 3, 4):
            unit = 1
            coefficients, order = tower_family(prime, power, unit)
            level = initial_form_depth(coefficients, prime, 1)
            silent = set(initial_form_values(coefficients, prime, 1)) == {0}
            observed = all(
                valuation(evaluate(coefficients, prime * h), prime) == order
                for h in range(-4 * prime * prime, 4 * prime * prime + 1))
            print(f"  {prime}   {power}   {order:3}   {level:3}   {order-level:2}"
                  f"   {(-unit) % prime:2}   "
                  f"{str(sorted(power_residues(prime, power))):16} "
                  f"{str(observed):7}  {predicts_determination(prime, power, unit)}"
                  f"{'' if silent else '   (form not silent)'}")
    print("\n  every initial form above is the zero function on F_p, yet the answer"
          "\n  varies -- so mu_k and I_k alone cannot decide.  the gap e - mu_1 = m"
          "\n  is unbounded, and s(h+p) = s(h) - 1 puts the deciding datum outside"
          "\n  every value-set criterion on F_p^n.")


if __name__ == "__main__":
    main()
