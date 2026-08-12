#!/usr/bin/env python3
"""The head of a cyclotomic sensor is logarithmic in ramification, not linear.

`notes/CYCLOTOMIC_SENSOR.md` Theorem 4 identifies the head length with the
torsion threshold of the unit filtration and records, explicitly untested, the
local-field prediction

    |H| = floor(e_K / (p - 1)) + 1.

That prediction is false as soon as the threshold `theta = e_K/(p-1)` exceeds
`p` times the starting depth.  The formula counts the integers `k` in
`[1, theta]`, i.e. it assumes the chain of filtration depths visits every
level.  It does not: below the threshold the depth is *multiplied* by `p`.  The
error is invisible over `Q_p`, where `e_K = 1` and `[1, theta]` holds at most
one integer -- which is exactly why the corpus's `Q_p` results are unaffected.

Everything here is exact integer arithmetic in the Eisenstein ring
`Z_p[pi]/(pi^m - p)`, a totally ramified degree-`m` extension of `Z_p` with
`e_K = m` and `v(pi) = 1`, `v(p) = m`.  No floating point enters a claim.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import log


@dataclass(frozen=True)
class Eisenstein:
    """Z_p[pi]/(pi^m - p), coefficients truncated at p^precision.

    Represents each element as `m` integers: sum_i c_i pi^i.  Since pi^m = p,
    an integer coefficient `c` at position `i` carries valuation
    `m * v_p(c) + i`, and those valuations are pairwise distinct modulo `m`,
    so the valuation of a sum is the minimum with no cancellation.
    """

    prime: int
    ramification: int
    precision: int

    @property
    def modulus(self) -> int:
        return self.prime ** self.precision

    @property
    def horizon(self) -> int:
        """Valuations at or above this are indistinguishable from zero."""
        return self.ramification * self.precision

    def reduce(self, coefficients: list[int]) -> list[int]:
        out = list(coefficients)
        while len(out) > self.ramification:
            top = out.pop()
            out[len(out) - self.ramification] += self.prime * top
        out += [0] * (self.ramification - len(out))
        return [c % self.modulus for c in out]

    def multiply(self, left: list[int], right: list[int]) -> list[int]:
        product = [0] * (len(left) + len(right) - 1)
        for i, x in enumerate(left):
            if x:
                for j, y in enumerate(right):
                    product[i + j] += x * y
        return self.reduce(product)

    def power(self, base: list[int], exponent: int) -> list[int]:
        result, square = self.reduce([1]), list(base)
        while exponent:
            if exponent & 1:
                result = self.multiply(result, square)
            square = self.multiply(square, square)
            exponent >>= 1
        return result

    def subtract(self, left: list[int], right: list[int]) -> list[int]:
        return self.reduce([x - y for x, y in zip(left, right)])

    def valuation(self, element: list[int]) -> int:
        best = self.horizon
        for position, coefficient in enumerate(element):
            if coefficient % self.modulus == 0:
                continue
            residue, height = coefficient, 0
            while residue % self.prime == 0:
                residue //= self.prime
                height += 1
            best = min(best, self.ramification * height + position)
        return best

    def unit_at_depth(self, depth: int, coefficient: int = 1) -> list[int]:
        """The unit 1 + c*pi^depth, which lies in U_depth \\ U_{depth+1}."""
        if not 1 <= depth < self.horizon:
            raise ValueError("depth outside the exact horizon")
        if coefficient % self.prime == 0:
            raise ValueError("coefficient must be a unit to fix the depth")
        return self.reduce([1] + [0] * (depth - 1) + [coefficient])


def shift_law(field: Eisenstein, depth: int) -> int:
    """The predicted exact depth of `x^p - 1` for `x` at `depth`.

    Lemma (min law).  Let `x = 1 + t` with `v(t) = k >= 1`.  Then
    `x^p - 1 = sum_{j=1}^{p} C(p,j) t^j`.  For `1 <= j <= p-1` the prime
    divides `C(p,j)`, so that term has valuation `>= e_K + jk >= e_K + k`,
    with equality only at `j = 1`; the last term has valuation `pk`.  Hence

        v(x^p - 1) >= min(e_K + k, p*k),

    with equality whenever the two are distinct.  They coincide exactly at
    `k = theta = e_K/(p-1)`, which is the only depth where torsion can live --
    over `Q_p` that is `p = 2, k = 1`, where the element is `-1`.
    """
    return min(field.ramification + depth, field.prime * depth)


def is_ambiguous(field: Eisenstein, depth: int) -> bool:
    """Is this the single depth where the two binomial terms tie?"""
    return field.ramification + depth == field.prime * depth


def depth_chain(field: Eisenstein, start_depth: int, steps: int,
                coefficient: int = 1) -> list[int]:
    """Exact `v(x^(p^s) - 1)` for `s = 0..steps`, `x` a unit at `start_depth`."""
    unit = field.unit_at_depth(start_depth, coefficient)
    one = field.reduce([1])
    chain = []
    for step in range(steps + 1):
        raised = field.power(unit, field.prime ** step)
        chain.append(field.valuation(field.subtract(raised, one)))
    return chain


def predicted_head_length(field: Eisenstein) -> int:
    """`CYCLOTOMIC_SENSOR.md` Theorem 4's untested local-field formula."""
    return field.ramification // (field.prime - 1) + 1


def true_head_length(field: Eisenstein, start_depth: int = 1) -> int:
    """Number of chain increments before they settle at the generic `e_K`.

    Theorem H.  Away from the ambiguous depth, the chain obeys
    `k_{s+1} = min(e_K + k_s, p*k_s)`, so `k_s = p^s * k_0` while
    `k_s < theta` and `k_{s+1} = k_s + e_K` once `k_s > theta`.  Therefore

        |H| = 1                                if k_0 > theta,
        |H| = floor(log_p(theta/k_0)) + 2      if k_0 < theta,

    and `|H|` is decided by the tie when some chain depth equals `theta`.
    In particular `|H| = O(log e_K)`, against the predicted `Theta(e_K)`.
    """
    threshold_numerator = field.ramification          # theta = e_K/(p-1)
    threshold_denominator = field.prime - 1
    if start_depth * threshold_denominator > threshold_numerator:
        return 1
    if start_depth * threshold_denominator == threshold_numerator:
        raise ValueError("start depth is the ambiguous depth; head is not forced")
    ratio = threshold_numerator / (threshold_denominator * start_depth)
    steps = int(log(ratio, field.prime))
    while field.prime ** (steps + 1) * start_depth * threshold_denominator < threshold_numerator:
        steps += 1                                    # integer-exact correction
    while field.prime ** steps * start_depth * threshold_denominator > threshold_numerator:
        steps -= 1
    if field.prime ** steps * start_depth * threshold_denominator == threshold_numerator:
        raise ValueError("chain meets the ambiguous depth; head is not forced")
    return steps + 2


def observed_head_length(field: Eisenstein, start_depth: int = 1,
                         steps: int = 5, coefficient: int = 1) -> int:
    """Read the head length off the exact chain, with no formula assumed."""
    chain = depth_chain(field, start_depth, steps, coefficient)
    increments = [chain[i + 1] - chain[i] for i in range(len(chain) - 1)]
    generic = field.ramification
    length = 1
    for position, increment in enumerate(increments):
        if increment != generic:
            length = position + 2
    return length


def head_depth_without_forming(base: int, order: int, prime: int) -> int:
    """`v_p(a^d - 1)` computed without ever forming the integer `a^d - 1`.

    `cyclotomic_sensor.form_sensor` evaluates `pow(base, order) - 1` in full.
    That integer has `order * log2(base)` bits, which is exponential in the bit
    size of `prime` (the order can be as large as `prime - 1`); the note's own
    trace calls it "a 110-digit integer" at the Wieferich prime 1093.

    It is never needed.  If `a^d mod p^(k+1) != 1` then `v_p(a^d - 1) <= k` and
    equals `v_p((a^d mod p^(k+1)) - 1)`, because the two agree modulo
    `p^(k+1)` and the valuation is below that.  Doubling `k` finds the depth in
    `O(log e)` modular exponentiations at modulus `p^(e+1)`, so the sensor is
    formed in `poly(log a, log p, e)` -- never in `d`.

    This strengthens the note's headline: the encounter does not merely buy an
    unbounded family from one member, it buys the family without forming any
    member at all.
    """
    if order < 1 or prime < 2:
        raise ValueError("need a positive order and a prime modulus")
    reach = 1
    while True:
        residue = pow(base, order, prime ** (reach + 1))
        if residue != 1:
            depth, remainder = 0, residue - 1
            while remainder % prime == 0:
                remainder //= prime
                depth += 1
            return depth
        reach *= 2


def counterexample_table() -> list[tuple[int, int, int, int, list[int]]]:
    """(p, e_K, predicted, observed, chain) over a spread of ramifications."""
    rows = []
    for prime, ramification, precision, steps in (
        (3, 1, 9, 4), (2, 1, 10, 4), (5, 2, 7, 3),
        (3, 4, 7, 4), (2, 3, 9, 4), (3, 16, 4, 4), (2, 8, 6, 4),
    ):
        field = Eisenstein(prime, ramification, precision)
        rows.append((prime, ramification, predicted_head_length(field),
                     observed_head_length(field, 1, steps),
                     depth_chain(field, 1, steps)))
    return rows


def main() -> None:
    print("p  e_K  theta   predicted  observed   chain v(x^(p^s)-1), x=1+pi")
    for prime, ram, predicted, observed, chain in counterexample_table():
        theta = ram / (prime - 1)
        flag = "" if predicted == observed else "   <-- REFUTES the prediction"
        print(f"{prime}  {ram:>3}  {theta:>5.2f}   {predicted:^9}  {observed:^8}   "
              f"{chain}{flag}")
    print("\nthe predicted length grows like e_K/(p-1); the true one like "
          "log_p(e_K/(p-1))")


if __name__ == "__main__":
    main()
