"""Required-object sets for the explicit valuation compiler."""


def required_objects(p: int, k: int):
    powers = {p**ell for ell in range(2, k + 1)}
    centers = []
    for ell in range(k):
        prefix = p**ell - 1
        for digit in range(p - 1):
            centers.append(p**k - prefix - digit * p**ell)
    return powers, centers


def lower_bound(p: int, k: int) -> int:
    powers, centers = required_objects(p, k)
    new_centers = set(centers) - powers - {p, 1}
    return len(powers | new_centers)

