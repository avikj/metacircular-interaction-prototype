#!/usr/bin/env python3
"""Exact q=6 falsifier for rational pair character blocks.

The coefficient ring is Q(i, zeta_6), represented in the basis
1, i, zeta_6, i*zeta_6 with zeta_6^2 = zeta_6 - 1.  No floating-point
root of unity, logarithm, or numerical tolerance is used.

The von Mangoldt logarithm is replaced by an integer prime-power tag times
a Gaussian coefficient.  This preserves exactly the algebra under test:
support on prime powers, primitive/imprimitive deletion, the p|q restoration,
and holomorphic versus Hermitian pair orientation.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import gcd


def require(condition: bool, message: object) -> None:
    if not condition:
        raise RuntimeError(message)


def _gadd(x: tuple[Fraction, Fraction],
          y: tuple[Fraction, Fraction]) -> tuple[Fraction, Fraction]:
    return x[0] + y[0], x[1] + y[1]


def _gmul(x: tuple[Fraction, Fraction],
          y: tuple[Fraction, Fraction]) -> tuple[Fraction, Fraction]:
    return x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0]


@dataclass(frozen=True)
class QIZ6:
    """(a+bi)+(c+di)zeta_6 in Q(i,zeta_6)."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)
    c: Fraction = Fraction(0)
    d: Fraction = Fraction(0)

    def __post_init__(self) -> None:
        for name in ("a", "b", "c", "d"):
            object.__setattr__(self, name, Fraction(getattr(self, name)))

    @staticmethod
    def coerce(value: object) -> "QIZ6":
        if isinstance(value, QIZ6):
            return value
        if isinstance(value, (int, Fraction)):
            return QIZ6(Fraction(value))
        return NotImplemented

    def __add__(self, other: object) -> "QIZ6":
        rhs = self.coerce(other)
        if rhs is NotImplemented:
            return NotImplemented
        return QIZ6(self.a + rhs.a, self.b + rhs.b,
                    self.c + rhs.c, self.d + rhs.d)

    __radd__ = __add__

    def __neg__(self) -> "QIZ6":
        return QIZ6(-self.a, -self.b, -self.c, -self.d)

    def __sub__(self, other: object) -> "QIZ6":
        rhs = self.coerce(other)
        if rhs is NotImplemented:
            return NotImplemented
        return self + (-rhs)

    def __rsub__(self, other: object) -> "QIZ6":
        lhs = self.coerce(other)
        if lhs is NotImplemented:
            return NotImplemented
        return lhs - self

    def __mul__(self, other: object) -> "QIZ6":
        rhs = self.coerce(other)
        if rhs is NotImplemented:
            return NotImplemented
        p0, p1 = (self.a, self.b), (self.c, self.d)
        q0, q1 = (rhs.a, rhs.b), (rhs.c, rhs.d)
        # z^2=z-1:
        # (p0+p1*z)(q0+q1*z)
        # = (p0*q0-p1*q1)+(p0*q1+p1*q0+p1*q1)*z.
        r0 = _gadd(_gmul(p0, q0), tuple(-x for x in _gmul(p1, q1)))
        r1 = _gadd(_gadd(_gmul(p0, q1), _gmul(p1, q0)), _gmul(p1, q1))
        return QIZ6(r0[0], r0[1], r1[0], r1[1])

    __rmul__ = __mul__

    def __truediv__(self, scalar: int | Fraction) -> "QIZ6":
        divisor = Fraction(scalar)
        return QIZ6(self.a / divisor, self.b / divisor,
                    self.c / divisor, self.d / divisor)

    def conjugate(self) -> "QIZ6":
        # conjugate(i)=-i and conjugate(z)=1-z.
        return QIZ6(self.a + self.c, -self.b - self.d, -self.c, self.d)

    def is_zero(self) -> bool:
        return self == ZERO


ZERO = QIZ6()
ONE = QIZ6(1)
I = QIZ6(0, 1)
ZETA = QIZ6(0, 0, 1)


def zeta_power(exponent: int) -> QIZ6:
    result = ONE
    for _ in range(exponent % 6):
        result *= ZETA
    return result


def prime_power_base(n: int) -> int:
    """Return p when n is a positive power of the prime p, otherwise 0."""
    if n < 2:
        return 0
    candidate = 2
    while candidate * candidate <= n and n % candidate:
        candidate += 1
    if n % candidate:
        return n  # n is prime.
    residue = n
    while residue % candidate == 0:
        residue //= candidate
    return candidate if residue == 1 else 0


def tagged_weight(n: int) -> QIZ6:
    """A prime-power-supported Gaussian test coefficient."""
    p = prime_power_base(n)
    if not p:
        return ZERO
    real = (3 * n + 1) % 11 - 5
    imag = (n * n + 2) % 7 - 3
    return QIZ6(p * real, p * imag)


def chi0_6(n: int) -> int:
    return int(gcd(n, 6) == 1)


def chi1_6(n: int) -> int:
    residue = n % 6
    return 1 if residue == 1 else (-1 if residue == 5 else 0)


def chi3(n: int) -> int:
    residue = n % 3
    return 1 if residue == 1 else (-1 if residue == 2 else 0)


def polynomial(limit: int, coefficient) -> list[QIZ6]:
    return [coefficient(n) for n in range(limit + 1)]


def padd(left: list[QIZ6], right: list[QIZ6]) -> list[QIZ6]:
    require(len(left) == len(right), "polynomial length mismatch")
    return [x + y for x, y in zip(left, right)]


def psub(left: list[QIZ6], right: list[QIZ6]) -> list[QIZ6]:
    require(len(left) == len(right), "polynomial length mismatch")
    return [x - y for x, y in zip(left, right)]


def pscale(scalar: QIZ6, values: list[QIZ6]) -> list[QIZ6]:
    return [scalar * value for value in values]


def convolution(left: list[QIZ6], right: list[QIZ6]) -> list[QIZ6]:
    result = [ZERO for _ in range(len(left) + len(right) - 1)]
    for m, x in enumerate(left):
        if x.is_zero():
            continue
        for n, y in enumerate(right):
            if not y.is_zero():
                result[m + n] = result[m + n] + x * y
    return result


def correlation(left: list[QIZ6], right: list[QIZ6], h: int) -> QIZ6:
    return sum(
        (left[n + h] * right[n].conjugate()
         for n in range(1, min(len(right), len(left) - h))),
        ZERO,
    )


def scalar_signal(values: list[QIZ6], frequency: int) -> QIZ6:
    return sum(
        (value * zeta_power(frequency * n)
         for n, value in enumerate(values) if n),
        ZERO,
    )


def main() -> None:
    if not __debug__:
        raise RuntimeError("do not run exact checks under python -O")

    limit = 36
    values = polynomial(limit, tagged_weight)
    trivial_primitive = values
    chi3_primitive = polynomial(limit, lambda n: values[n] * chi3(n))
    b0 = polynomial(limit, lambda n: values[n] * chi0_6(n))
    b1 = polynomial(limit, lambda n: values[n] * chi1_6(n))

    # Deleted Euler blocks: chi0 mod 6 is induced by conductor 1 and deletes
    # p=2,3; chi1 mod 6 is induced by chi3 and deletes p=2.
    e0 = polynomial(
        limit,
        lambda n: values[n]
        if prime_power_base(n) in (2, 3) else ZERO,
    )
    e1 = polynomial(
        limit,
        lambda n: values[n] * chi3(n)
        if prime_power_base(n) == 2 else ZERO,
    )
    require(b0 == psub(trivial_primitive, e0), "principal imprimitive sign")
    require(b1 == psub(chi3_primitive, e1), "odd imprimitive sign")

    # tau(chi0 mod 6)=1 and tau(chi1 mod 6)=zeta-zeta^5=2*zeta-1.
    tau0 = ONE
    tau1 = 2 * ZETA - ONE
    require(tau0 == ZETA + zeta_power(5), "principal Gauss sum")
    require(tau1 == ZETA - zeta_power(5), "odd Gauss sum")
    require(tau1.conjugate() == -tau1, "odd Gauss conjugation")

    character_checks = 0
    goldbach_checks = 0
    gap_checks = 0
    wrong_orientation_detected = False
    wrong_alpha_conjugation_detected = False

    for a in (1, 5):
        alpha0 = tau0 / 2
        alpha1 = (chi1_6(a) * tau1) / 2
        local = polynomial(
            limit,
            lambda n: values[n] * zeta_power(a * n)
            if prime_power_base(n) in (2, 3) else ZERO,
        )
        character_part = padd(pscale(alpha0, b0), pscale(alpha1, b1))
        reconstructed = padd(character_part, local)
        direct = polynomial(
            limit, lambda n: values[n] * zeta_power(a * n)
        )
        require(reconstructed == direct, ("one-body decomposition", a))
        character_checks += limit

        # Expand every ordered holomorphic character pair, then the local
        # cross terms, instead of merely squaring the reconstructed signal.
        holomorphic = [ZERO for _ in range(2 * limit + 1)]
        for alpha_left, left in ((alpha0, b0), (alpha1, b1)):
            for alpha_right, right in ((alpha0, b0), (alpha1, b1)):
                holomorphic = padd(
                    holomorphic,
                    pscale(alpha_left * alpha_right,
                           convolution(left, right)),
                )
        local_cross = padd(
            pscale(QIZ6(2), convolution(character_part, local)),
            convolution(local, local),
        )
        holomorphic = padd(holomorphic, local_cross)
        direct_square = convolution(direct, direct)
        require(holomorphic == direct_square, ("holomorphic block", a))

        untwisted_square = convolution(values, values)
        for total in range(2, 2 * limit + 1):
            expected = untwisted_square[total] * zeta_power(a * total)
            require(direct_square[total] == expected,
                    ("Goldbach grade", a, total))
            goldbach_checks += 1

        for h in range(0, 13):
            # Full alpha_chi * conjugate(alpha_psi) block.
            hermitian = ZERO
            wrong_alpha_block = ZERO
            blocks = ((alpha0, b0), (alpha1, b1))
            for alpha_left, left in blocks:
                for alpha_right, right in blocks:
                    block_correlation = correlation(left, right, h)
                    hermitian += (
                        alpha_left * alpha_right.conjugate()
                        * block_correlation
                    )
                    wrong_alpha_block += (
                        alpha_left * alpha_right * block_correlation
                    )
            wrong_alpha_conjugation_detected |= (
                wrong_alpha_block
                != correlation(character_part, character_part, h)
            )
            hermitian += correlation(character_part, local, h)
            hermitian += correlation(local, character_part, h)
            hermitian += correlation(local, local, h)
            direct_gap = correlation(direct, direct, h)
            require(hermitian == direct_gap, ("Hermitian block", a, h))

            expected_gap = zeta_power(a * h) * correlation(values, values, h)
            require(direct_gap == expected_gap, ("gap orientation", a, h))
            gap_checks += 1

            wrong = sum(
                (direct[n + h].conjugate() * direct[n]
                 for n in range(1, len(direct) - h)),
                ZERO,
            )
            wrong_orientation_detected |= wrong != direct_gap

    require(wrong_orientation_detected,
            "complex weights failed to distinguish wrong conjugation")
    require(wrong_alpha_conjugation_detected,
            "complex weights failed to distinguish alpha*alpha from "
            "alpha*conjugate(alpha)")

    # Exact Z/6Z projectors. These select congruences, not integer equality.
    signals = [scalar_signal(values, b) for b in range(6)]
    projector_checks = 0
    for residue in range(6):
        goldbach_projector = sum(
            (zeta_power(-b * residue) * signals[b] * signals[b]
             for b in range(6)),
            ZERO,
        ) / 6
        goldbach_direct = sum(
            (values[m] * values[n]
             for m in range(1, limit + 1)
             for n in range(1, limit + 1)
             if (m + n - residue) % 6 == 0),
            ZERO,
        )
        require(goldbach_projector == goldbach_direct,
                ("Goldbach residue projector", residue))

        gap_projector = sum(
            (zeta_power(-b * residue)
             * signals[b] * signals[b].conjugate()
             for b in range(6)),
            ZERO,
        ) / 6
        gap_direct = sum(
            (values[m] * values[n].conjugate()
             for m in range(1, limit + 1)
             for n in range(1, limit + 1)
             if (m - n - residue) % 6 == 0),
            ZERO,
        )
        require(gap_projector == gap_direct,
                ("gap residue projector", residue))
        projector_checks += 2

    print(f"primitive/imprimitive/local coefficient checks: {character_checks}")
    print(f"holomorphic Goldbach-grade checks: {goldbach_checks}")
    print(f"Hermitian gap-orientation checks: {gap_checks}")
    print(f"exact residue-projector checks: {projector_checks}")
    print("wrong conjugation orientation: detected")
    print("wrong alpha conjugation: detected")
    print("PASS")


if __name__ == "__main__":
    main()
