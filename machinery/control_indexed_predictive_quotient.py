"""Predictive quotients indexed by declared continuation semantics on Z/5Z."""

from mod5_predictive_quantum_profile import full_response_classes


def observe(x: int) -> str:
    x %= 5
    return "zero" if x == 0 else "one" if x == 1 else "other"


def autonomous_classes():
    """One installed multiplier evolves only by self-application."""
    return full_response_classes()


def intervention_signature(installed: int) -> tuple[str, ...]:
    """Every left multiplier b is an admitted one-step intervention."""
    return tuple(observe(b * installed) for b in range(5))


def full_intervention_classes():
    by_signature = {}
    for installed in range(5):
        by_signature.setdefault(intervention_signature(installed), set()).add(installed)
    return frozenset(frozenset(values) for values in by_signature.values())


def refines(finer, coarser) -> bool:
    return all(any(fine <= coarse for coarse in coarser) for fine in finer)


def zero_error_dimension(classes) -> int:
    return len(classes)
