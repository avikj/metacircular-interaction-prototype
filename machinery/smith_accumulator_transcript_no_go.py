"""The final Smith transformation accumulator already records the quotient."""

from collections import Counter

from smith_quotient_memory_no_go import witness_matrix
from smith_residual_machine import smith_reduce


def final_certificate_view(quotient: int):
    certificate = smith_reduce(witness_matrix(quotient))
    return certificate.left, certificate.diagonal, certificate.right


def recover_quotient_from_left(left) -> int:
    return -left[0][0]


def maximum_fiber(values) -> int:
    counts = Counter(values)
    return max(counts.values(), default=0)


def accumulator_profile(count: int):
    if count < 0:
        raise ValueError("count must be nonnegative")
    views = [final_certificate_view(q) for q in range(count)]
    diagonals = [view[1] for view in views]
    right_diagonal = [(view[1], view[2]) for view in views]
    return {
        "diagonal_image_size": len(set(diagonals)),
        "diagonal_fiber": maximum_fiber(diagonals),
        "right_diagonal_image_size": len(set(right_diagonal)),
        "full_view_image_size": len(set(views)),
        "full_view_fiber": maximum_fiber(views),
        "recovered": tuple(recover_quotient_from_left(view[0]) for view in views),
    }
