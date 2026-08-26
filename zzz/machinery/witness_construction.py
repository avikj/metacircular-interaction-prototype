from dataclasses import dataclass


@dataclass(frozen=True)
class AdditionEvent:
    left: int
    right: int
    result: int


def binary_addition_chain(target: int) -> tuple[AdditionEvent, ...]:
    if target < 1:
        raise ValueError("target must be positive")
    current = 1
    events = []
    for bit in bin(target)[3:]:
        events.append(AdditionEvent(current, current, current + current))
        current += current
        if bit == "1":
            events.append(AdditionEvent(current, 1, current + 1))
            current += 1
    assert current == target
    return tuple(events)


def critical_representative(a: int, b: int, p: int) -> tuple[int, int, int]:
    if min(a, b) < 1 or p < 2:
        raise ValueError("positive pair and prime-like modulus base required")
    total = a + b
    v = 0
    while total % p == 0:
        total //= p
        v += 1
    modulus = p ** (v + 1)
    residue = (-a) % modulus
    target = residue if residue else modulus
    return v, modulus, target


def construct_critical_witness(a: int, b: int, p: int):
    v, modulus, target = critical_representative(a, b, p)
    events = binary_addition_chain(target)
    formed = {1}
    for event in events:
        if event.left not in formed or event.right not in formed:
            raise AssertionError("addition event used an unformed operand")
        if event.result != event.left + event.right:
            raise AssertionError("invalid addition event")
        formed.add(event.result)
    if (a + target) % modulus:
        raise AssertionError("constructed integer misses critical class")
    return v, modulus, target, events
