"""Predictive quantum-memory jump caused by a new addition arity."""

from itertools import combinations


def valuation(number: int, prime: int) -> int:
    if number == 0:
        raise ValueError("zero valuation is separately typed")
    number = abs(number)
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def witness(prime: int, arity: int, exponent: int) -> tuple[int, ...]:
    if prime < 2 or arity < 2 or exponent < 1:
        raise ValueError("prime, arity, and exponent are outside the witness domain")
    return (1,) * (arity - 1) + (prime ** exponent - (arity - 1),)


def residual(values: tuple[int, ...], prime: int) -> int:
    return valuation(sum(values), prime) - min(valuation(value, prime) for value in values)


def proper_context_profile(values: tuple[int, ...], prime: int) -> tuple[int, ...]:
    """All labeled nonempty proper-subset cancellation residuals."""
    result = []
    for size in range(1, len(values)):
        for indices in combinations(range(len(values)), size):
            result.append(residual(tuple(values[index] for index in indices), prime))
    return tuple(result)


def threshold(prime: int, arity: int) -> int:
    """Least safe strict lower bound from the arity theorem."""
    return max(valuation(k, prime) for k in range(1, arity))


def memory_jump(prime: int, arity: int, class_count: int) -> dict[str, int]:
    """Construct class_count histories merged below arity and split at arity."""
    if class_count < 1:
        raise ValueError("class_count must be positive")
    start = threshold(prime, arity) + 1
    histories = tuple(witness(prime, arity, start + index) for index in range(class_count))
    profiles = {proper_context_profile(history, prime) for history in histories}
    full = {residual(history, prime) for history in histories}
    if len(profiles) != 1 or len(full) != class_count:
        raise AssertionError("strict arity witness failed")
    return {
        "histories": class_count,
        "lower_arity_predictive_dimension": 1,
        "full_arity_predictive_dimension": class_count,
    }

