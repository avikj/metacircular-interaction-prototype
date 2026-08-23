"""Full Smith transformation certificates reconstruct deterministic traces."""

from smith_residual_machine import Matrix, determinant, multiply, smith_reduce


def unimodular_inverse(matrix: Matrix) -> Matrix:
    det = determinant(matrix)
    if det not in (-1, 1):
        raise ValueError("matrix is not unimodular")
    a, b = matrix[0]
    c, d = matrix[1]
    return ((d // det, -b // det), (-c // det, a // det))


def reconstruct_source(left: Matrix, diagonal: Matrix, right: Matrix) -> Matrix:
    return multiply(multiply(unimodular_inverse(left), diagonal), unimodular_inverse(right))


def replay_trace(left: Matrix, diagonal: Matrix, right: Matrix):
    source = reconstruct_source(left, diagonal, right)
    certificate = smith_reduce(source)
    if (certificate.left, certificate.diagonal, certificate.right) != (
        left,
        diagonal,
        right,
    ):
        raise ValueError("triple is valid algebraically but not canonical for installed reducer")
    return certificate.steps


def certificate_round_trip(source: Matrix) -> bool:
    certificate = smith_reduce(source)
    recovered = reconstruct_source(
        certificate.left, certificate.diagonal, certificate.right
    )
    replayed = replay_trace(
        certificate.left, certificate.diagonal, certificate.right
    )
    return recovered == source and replayed == certificate.steps
