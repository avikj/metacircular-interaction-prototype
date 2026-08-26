from dataclasses import dataclass


@dataclass(frozen=True)
class MultiplicationEvent:
    left: int
    right: int
    result: int


def binary_power_chain(base: int, exponent: int) -> tuple[MultiplicationEvent, ...]:
    if base < 2 or exponent < 1:
        raise ValueError("formed nontrivial base and positive exponent required")
    current = base
    events = []
    for bit in bin(exponent)[3:]:
        events.append(MultiplicationEvent(current, current, current * current))
        current *= current
        if bit == "1":
            events.append(MultiplicationEvent(current, base, current * base))
            current *= base
    assert current == base**exponent
    return tuple(events)


def construct_power_witness(prime: int, valuation: int):
    if valuation < 0:
        raise ValueError("valuation must be nonnegative")
    exponent = valuation + 1
    events = binary_power_chain(prime, exponent)
    formed = {1, prime}
    for event in events:
        if event.left not in formed or event.right not in formed:
            raise AssertionError("multiplication used an unformed operand")
        if event.result != event.left * event.right:
            raise AssertionError("invalid multiplication")
        formed.add(event.result)
    target = prime**exponent
    if target not in formed:
        raise AssertionError("target was not formed")
    return target, events
