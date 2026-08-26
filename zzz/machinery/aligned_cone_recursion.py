"""Recursive p-adic aligned-cone splitting and certification."""


def split_low_digit(mu, p):
    return [list(mu[d::p]) for d in range(p)]


def interleave(children):
    p = len(children)
    size = len(children[0])
    return [children[x % p][x // p] for x in range(p * size)]


def recursive_certificate(mu, p, k):
    if k == 0:
        return bool(len(mu) == 1 and mu[0] >= 0), (mu[0],)
    if len(mu) != p**k or any(x < 0 for x in mu):
        return False, None
    children = split_low_digit(mu, p)
    totals = tuple(sum(child) for child in children)
    ordered = all(a >= b for a, b in zip(totals, totals[1:]))
    certificates = [recursive_certificate(child, p, k - 1) for child in children]
    valid = ordered and all(ok for ok, _ in certificates)
    return valid, (totals, tuple(cert for _, cert in certificates))

