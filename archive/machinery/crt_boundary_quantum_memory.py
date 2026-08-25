"""Exact memory cost of a coherent generalized-CRT boundary cut."""

from dataclasses import dataclass
from math import gcd, lcm, prod
from typing import Sequence


Record = tuple[int, ...]


@dataclass(frozen=True)
class CRTBoundaryProfile:
    moduli: tuple[int, ...]
    source_dimension: int
    compatible_record_count: int
    hidden_memory_dimension: int


def _validate(moduli: Sequence[int]) -> tuple[int, ...]:
    result = tuple(moduli)
    if not result or any(modulus < 1 for modulus in result):
        raise ValueError("moduli must be a nonempty positive family")
    return result


def compatible(record: Sequence[int], moduli: Sequence[int]) -> bool:
    """Return whether a local residue record satisfies generalized CRT descent."""
    ms = _validate(moduli)
    values = tuple(record)
    if len(values) != len(ms):
        return False
    if any(not 0 <= value < modulus for value, modulus in zip(values, ms)):
        return False
    return all(
        values[i] % gcd(ms[i], ms[j]) == values[j] % gcd(ms[i], ms[j])
        for i in range(len(ms))
        for j in range(i + 1, len(ms))
    )


def boundary_profile(moduli: Sequence[int]) -> CRTBoundaryProfile:
    """Price visible records and the exact hidden fiber of the CRT cut."""
    ms = _validate(moduli)
    source = prod(ms)
    records = lcm(*ms)
    return CRTBoundaryProfile(ms, source, records, source // records)


def coherent_lift(value: int, moduli: Sequence[int]) -> tuple[Record, int]:
    """Map a source basis label to (boundary record, hidden fiber label)."""
    profile = boundary_profile(moduli)
    if not 0 <= value < profile.source_dimension:
        raise ValueError("value must label the declared source basis")
    record = tuple(value % modulus for modulus in profile.moduli)
    hidden = value // profile.compatible_record_count
    return record, hidden


def coherent_replay(record: Sequence[int], hidden: int, moduli: Sequence[int]) -> int:
    """Invert ``coherent_lift`` on compatible records."""
    profile = boundary_profile(moduli)
    values = tuple(record)
    if not compatible(values, profile.moduli):
        raise ValueError("record is not a compatible generalized-CRT boundary")
    if not 0 <= hidden < profile.hidden_memory_dimension:
        raise ValueError("hidden label is outside the residual fiber")

    # The compatible record determines one residue modulo lcm(moduli).
    base = next(
        candidate
        for candidate in range(profile.compatible_record_count)
        if all(candidate % modulus == residue
               for residue, modulus in zip(values, profile.moduli))
    )
    return base + hidden * profile.compatible_record_count

