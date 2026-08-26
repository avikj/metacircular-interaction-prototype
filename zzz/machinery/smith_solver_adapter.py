"""Consume the residual Smith reducer's proof object in ExponentWorld."""

from exponent_world import ExponentWorld
from smith_residual_machine import SmithCertificate


def solve_from_smith_certificate(
    world: ExponentWorld,
    certificate: SmithCertificate,
    target: tuple[int, int],
    modulus: int,
):
    """Verify and transport one produced Smith certificate into the solver."""
    if not certificate.verify():
        raise ValueError("invalid residual Smith certificate")
    diagonal = certificate.diagonal
    if diagonal[0][1] != 0 or diagonal[1][0] != 0:
        raise ValueError("Smith certificate output is not diagonal")
    return world.solve_witnessed_smith_system(
        certificate.source, target, modulus, certificate.left,
        (diagonal[0][0], diagonal[1][1]), certificate.right,
    )
