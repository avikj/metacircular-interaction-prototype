"""Exact resource profiles for deterministic sensor interfaces."""

from collections import Counter
from typing import Hashable, Sequence


def sensor_profile(outputs: Sequence[Hashable]) -> dict[str, int]:
    """Return image, coherent-overwrite, and decohering-channel dimensions."""
    values = tuple(outputs)
    if not values:
        raise ValueError("sensor needs a nonempty finite source")
    fibers = Counter(values)
    return {
        "source_size": len(values),
        "image_size": len(fibers),
        "coherent_overwrite_environment": max(fibers.values()),
        # The measure/prepare channel has one orthogonal Choi support per input.
        "decohering_environment": len(values),
    }


def extreme_pair(source_size: int) -> tuple[dict[str, int], dict[str, int]]:
    """Profiles of constant and injective sensors on the same source."""
    if source_size < 1:
        raise ValueError("source_size must be positive")
    return (
        sensor_profile((0,) * source_size),
        sensor_profile(tuple(range(source_size))),
    )

