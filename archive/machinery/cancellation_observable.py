#!/usr/bin/env python3
"""Form the p-adic cancellation observable from valuation and addition."""

from __future__ import annotations

from dataclasses import dataclass

from adaptive_valuation_addition import (
    ValuationCertificate,
    adaptive_sum_valuation,
    verify_certificate as verify_sum_certificate,
)


def valuation_nonzero(n: int, prime: int) -> int:
    """Return v_p(n), requiring a nonzero integer and a validated prime."""
    if n == 0:
        raise ValueError("valuation_nonzero requires a nonzero integer")
    # The imported routine performs the prime check before its zero branch.
    adaptive_sum_valuation(1, 0, prime)
    value = 0
    n = abs(n)
    while n % prime == 0:
        value += 1
        n //= prime
    return value


@dataclass(frozen=True)
class CancellationCertificate:
    prime: int
    common_depth: int
    cancellation: int | None
    is_zero_sum: bool
    normalized_left: int
    normalized_right: int
    refinement: ValuationCertificate


def form_cancellation_observable(
    a: int, b: int, prime: int
) -> CancellationCertificate:
    """Return kappa_p(a,b) and its normalized adaptive certificate.

    ``cancellation=None`` is the separately typed infinite value at ``a+b=0``.
    Inputs are required to be nonzero so their common valuation depth is finite.
    """
    left_depth = valuation_nonzero(a, prime)
    right_depth = valuation_nonzero(b, prime)
    common = min(left_depth, right_depth)
    scale = prime**common
    normalized_left = a // scale
    normalized_right = b // scale
    refinement = adaptive_sum_valuation(normalized_left, normalized_right, prime)
    return CancellationCertificate(
        prime=prime,
        common_depth=common,
        cancellation=refinement.valuation,
        is_zero_sum=refinement.is_zero,
        normalized_left=normalized_left,
        normalized_right=normalized_right,
        refinement=refinement,
    )


def verify_cancellation_certificate(
    a: int, b: int, certificate: CancellationCertificate
) -> bool:
    """Replay normalization, the transport equation, and adaptive evidence."""
    if a == 0 or b == 0:
        return False
    try:
        left_depth = valuation_nonzero(a, certificate.prime)
        right_depth = valuation_nonzero(b, certificate.prime)
    except ValueError:
        return False
    common = min(left_depth, right_depth)
    scale = certificate.prime**common
    if (
        certificate.common_depth != common
        or certificate.normalized_left != a // scale
        or certificate.normalized_right != b // scale
        or certificate.cancellation != certificate.refinement.valuation
        or certificate.is_zero_sum != certificate.refinement.is_zero
    ):
        return False
    return verify_sum_certificate(
        certificate.normalized_left,
        certificate.normalized_right,
        certificate.refinement,
    )


if __name__ == "__main__":
    formed = form_cancellation_observable(45, 198, 3)
    print(formed)
    print("certificate valid:", verify_cancellation_certificate(45, 198, formed))
