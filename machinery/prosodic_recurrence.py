#!/usr/bin/env python3
"""One-shot prosodic recurrence: rhythms of duration n from weights 1 and 2."""
from __future__ import annotations

from math import comb

Rhythm = tuple[int, ...]


def rhythms(duration: int) -> tuple[Rhythm, ...]:
    """All ordered light/heavy rhythms, encoded by durations 1 and 2."""
    if duration < 0:
        return ()
    if duration == 0:
        return ((),)
    return tuple((first,) + tail for first in (1, 2)
                 for tail in rhythms(duration - first))


def split_first(duration: int) -> tuple[tuple[Rhythm, ...], tuple[Rhythm, ...]]:
    """Delete the first syllable, separating light-first and heavy-first rhythms."""
    if duration < 2:
        raise ValueError("duration must be at least 2")
    all_rhythms = rhythms(duration)
    return (tuple(r[1:] for r in all_rhythms if r[0] == 1),
            tuple(r[1:] for r in all_rhythms if r[0] == 2))


def count(duration: int) -> int:
    """Count by the recurrence M(n)=M(n-1)+M(n-2), M(0)=M(1)=1."""
    if duration < 0:
        return 0
    previous, current = 1, 1
    for _ in range(duration):
        previous, current = current, previous + current
    return previous


def count_by_heavy(duration: int) -> tuple[tuple[int, int], ...]:
    """For k heavy syllables, choose their k positions among n-k syllables."""
    if duration < 0:
        raise ValueError("duration must be nonnegative")
    return tuple((k, comb(duration - k, k))
                 for k in range(duration // 2 + 1))


def certificate(duration: int) -> dict[str, object]:
    """Return the recurrence and binomial-sum checks as an exact certificate."""
    if duration < 2:
        raise ValueError("duration must be at least 2")
    light, heavy = split_first(duration)
    expected_light, expected_heavy = rhythms(duration - 1), rhythms(duration - 2)
    distribution = count_by_heavy(duration)
    return {
        "duration": duration,
        "count": count(duration),
        "light_first_bijection": light == expected_light,
        "heavy_first_bijection": heavy == expected_heavy,
        "recurrence": count(duration) == count(duration - 1) + count(duration - 2),
        "heavy_distribution": distribution,
        "binomial_sum": sum(value for _, value in distribution),
    }


if __name__ == "__main__":
    result = certificate(12)
    for key, value in result.items():
        print(f"{key}: {value}")
