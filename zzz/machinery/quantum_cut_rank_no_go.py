"""Exact witness that ordinary cut rank does not price quantum memory."""

from fractions import Fraction

from causal_memory import rational_rank


Gaussian = tuple[Fraction, Fraction]
Matrix2 = tuple[tuple[Gaussian, Gaussian], tuple[Gaussian, Gaussian]]


def _g(real=0, imag=0) -> Gaussian:
    return Fraction(real), Fraction(imag)


def _add(left: Gaussian, right: Gaussian) -> Gaussian:
    return left[0] + right[0], left[1] + right[1]


def _mul(left: Gaussian, right: Gaussian) -> Gaussian:
    return (
        left[0] * right[0] - left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def trace_product(left: Matrix2, right: Matrix2) -> Fraction:
    """Compute Tr(left right), rejecting a non-real exact result."""
    trace = _g()
    for i in range(2):
        for j in range(2):
            trace = _add(trace, _mul(left[i][j], right[j][i]))
    if trace[1]:
        raise ValueError("trace product is not real")
    return trace[0]


QUBIT_PROJECTORS: tuple[Matrix2, ...] = (
    ((_g(1), _g()), (_g(), _g())),
    ((_g(), _g()), (_g(), _g(1))),
    ((_g(Fraction(1, 2)), _g(Fraction(1, 2))),
     (_g(Fraction(1, 2)), _g(Fraction(1, 2)))),
    ((_g(Fraction(1, 2)), _g(0, Fraction(-1, 2))),
     (_g(0, Fraction(1, 2)), _g(Fraction(1, 2)))),
)


def qubit_process_table() -> tuple[tuple[Fraction, ...], ...]:
    """Born table Tr(P_i P_j) for |0>, |1>, |+>, and |+i>."""
    return tuple(
        tuple(trace_product(state, effect) for effect in QUBIT_PROJECTORS)
        for state in QUBIT_PROJECTORS
    )


def separation_profile() -> dict[str, int]:
    """Return the two equal-rank, unequal-quantum-dimension witnesses."""
    qubit = qubit_process_table()
    identity = tuple(tuple(Fraction(i == j) for j in range(4)) for i in range(4))
    return {
        "qubit_ordinary_rank": rational_rank(qubit),
        "qubit_quantum_dimension": 2,
        "identity_ordinary_rank": rational_rank(identity),
        "identity_quantum_dimension": 4,
    }

