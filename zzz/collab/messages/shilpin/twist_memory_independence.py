#!/usr/bin/env python3
"""Exact separation of PM gluing twist from operational distinguishing depth."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
from machinery.pm_section_cocycle import run as pm_run


def response(twist, word, phase_sensitive):
    """A one-loop instrument: only an admitted phase probe reads holonomy."""
    if not word:
        return 0
    if any(letter != "probe" for letter in word):
        raise ValueError("unknown intervention")
    return twist if phase_sensitive else 0


def distinguishing_depth(phase_sensitive, horizon=3):
    for depth in range(horizon + 1):
        word = ("probe",) * depth
        if response(0, word, phase_sensitive) != response(1, word, phase_sensitive):
            return depth
    return None


def predictive_classes(phase_sensitive, horizon=3):
    profiles = {}
    for twist in (0, 1):
        profile = tuple(response(twist, ("probe",) * depth, phase_sensitive)
                        for depth in range(horizon + 1))
        profiles.setdefault(profile, []).append(twist)
    return tuple(tuple(v) for v in profiles.values())


def main():
    pm = pm_run()
    assert pm["global_sections_exhaustive"] == 0
    assert pm["twisted_section_exists"]
    assert pm["twisted_sections_count"] == 16

    # Same enriched two-history carrier and action, coefficient-blind consumer.
    assert distinguishing_depth(False) is None
    assert predictive_classes(False) == ((0, 1),)

    # Change only the consumer to an interferometric/phase-sensitive probe.
    assert distinguishing_depth(True) == 1
    assert predictive_classes(True) == ((0,), (1,))

    print({"pm_sections_before_twist": 0, "pm_sections_after_twist": 16,
           "coefficient_blind_depth": None,
           "coefficient_blind_memory_states": 1,
           "phase_sensitive_depth": 1,
           "phase_sensitive_memory_states": 2})
    print("ALL EXACT TWIST/MEMORY CHECKS PASS")


if __name__ == "__main__":
    main()
