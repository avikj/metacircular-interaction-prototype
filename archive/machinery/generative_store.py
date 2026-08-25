"""Exact finite realization of the binary naming-rule store."""


def named_interval(depth: int) -> tuple[int, ...]:
    if depth < 0:
        raise ValueError("depth must be nonnegative")
    values = (0,)
    for _ in range(depth):
        values = tuple(2 * x + bit for x in values for bit in (0, 1))
    return values


def encode(value: int, depth: int) -> tuple[int, ...]:
    if depth < 0 or not 0 <= value < 2**depth:
        raise ValueError("value is outside the named interval")
    return tuple((value >> shift) & 1 for shift in reversed(range(depth)))


def decode(bits: tuple[int, ...]) -> int:
    value = 0
    for bit in bits:
        if bit not in (0, 1):
            raise ValueError("digits must be binary")
        value = 2 * value + bit
    return value


def hybrid_store(depth: int, prime: int, tower_height: int) -> set[int]:
    if prime < 2 or tower_height < 0:
        raise ValueError("invalid tower")
    return set(named_interval(depth)) | {prime**e for e in range(tower_height + 1)}
