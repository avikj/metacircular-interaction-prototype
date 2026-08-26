"""Exact predictive quotient of multiplier reuse on Z/5Z."""


def observe(x: int) -> str:
    x %= 5
    if x == 0:
        return "zero"
    if x == 1:
        return "one"
    return "other"


def signature(multiplier: int, horizon: int) -> tuple[str, ...]:
    """Observe seed 1 after 0,...,horizon repeated uses."""
    if horizon < 0:
        raise ValueError("horizon must be nonnegative")
    multiplier %= 5
    state = 1
    result = [observe(state)]
    for _ in range(horizon):
        state = multiplier * state % 5
        result.append(observe(state))
    return tuple(result)


def predictive_classes(horizon: int):
    classes = {}
    for multiplier in range(5):
        classes.setdefault(signature(multiplier, horizon), set()).add(multiplier)
    return frozenset(frozenset(values) for values in classes.values())


def predictive_dimension(horizon: int) -> int:
    return len(predictive_classes(horizon))


def full_response_classes():
    """Order certifies that horizon four contains the complete response law."""
    return predictive_classes(4)
