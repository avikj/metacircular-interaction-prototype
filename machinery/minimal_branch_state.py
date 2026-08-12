"""Variable-length clean branch schedules determined by one output digit."""


def tested_digits(digit: int, p: int) -> tuple[int, ...]:
    if not 0 <= digit < p:
        raise ValueError("digit outside base")
    stop = digit + 1 if digit < p - 1 else p - 1
    return tuple(range(stop))


def reverse_tested_digits(digit: int, p: int) -> tuple[int, ...]:
    return tuple(reversed(tested_digits(digit, p)))


def branch_record_classes(p: int):
    return {digit: tested_digits(digit, p) for digit in range(p)}

