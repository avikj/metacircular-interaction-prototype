"""Replay the subtractive center chain of adaptive valuation sensing."""

from adaptive_valuation_identification import tau


def center_chain(r: int, p: int, k: int):
    modulus = p**k
    prefix = 0
    centers = []
    dependencies = []
    previous = None
    for ell in range(k):
        step = p**ell
        for digit in range(p - 1):
            center = modulus - prefix - digit * step
            centers.append(center)
            if previous is not None and center != previous:
                dependencies.append((previous, previous - center, center))
            previous = center
            if tau(r + center, p, k) >= ell + 1:
                prefix += digit * step
                break
        else:
            prefix += (p - 1) * step
    return centers, dependencies, prefix
