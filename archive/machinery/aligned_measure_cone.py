"""Exact predicate and operations for p-adic scheduler-aligned measures."""


def child_masses(mu, p, k, ell, prefix):
    modulus = p ** (ell + 1)
    return [
        sum(weight for x, weight in enumerate(mu)
            if x % modulus == prefix + d * (p**ell))
        for d in range(p)
    ]


def is_aligned(mu, p, k):
    if len(mu) != p**k or any(weight < 0 for weight in mu):
        return False
    for ell in range(k):
        for prefix in range(p**ell):
            masses = child_masses(mu, p, k, ell, prefix)
            if any(a < b for a, b in zip(masses, masses[1:])):
                return False
    return True


def dilate(mu, p):
    out = [0] * (p * len(mu))
    for x, weight in enumerate(mu):
        out[p * x] = weight
    return out

