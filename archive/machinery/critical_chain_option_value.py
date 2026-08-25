"""Exact finite helpers for the critical-chain option-value example."""


def valuation(n: int, p: int) -> int:
    if n <= 0 or p < 2:
        raise ValueError("require n>0 and p>=2")
    value = 0
    while n % p == 0:
        n //= p
        value += 1
    return value


def critical_representative(a: int, b: int, p: int) -> int:
    depth = valuation(a + b, p)
    modulus = p ** (depth + 1)
    residue = (-a) % modulus
    return residue or modulus


def one_step_outputs(cache: set[int]) -> set[int]:
    return {x + y for x in cache for y in cache}


def replay(chain: tuple[int, ...]) -> set[int]:
    cache = {chain[0]}
    for target in chain[1:]:
        if target not in one_step_outputs(cache):
            raise ValueError(f"illegal addition-chain target {target}")
        cache.add(target)
    return cache

