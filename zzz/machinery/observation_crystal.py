#!/usr/bin/env python3
"""Finite Chu-style observation crystal and exact separating probes."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from typing import Hashable, Mapping, Sequence

Point = Hashable
Probe = Hashable
Value = Hashable


@dataclass(frozen=True)
class ObservationCrystal:
    point_fibers: tuple[tuple[Point, ...], ...]
    probe_fibers: tuple[tuple[Probe, ...], ...]
    matrix: tuple[tuple[Value, ...], ...]
    separating_probes: tuple[Probe, ...]
    separating_points: tuple[Point, ...]
    unresolved_point_pairs: tuple[tuple[Point, Point], ...]
    unresolved_probe_pairs: tuple[tuple[Probe, Probe], ...]

    def transpose(self) -> "ObservationCrystal":
        return build_crystal(
            tuple(fiber[0] for fiber in self.probe_fibers),
            tuple(fiber[0] for fiber in self.point_fibers),
            {(self.probe_fibers[j][0], self.point_fibers[i][0]): value
             for i, row in enumerate(self.matrix)
             for j, value in enumerate(row)},
        )


def _profiles(left: Sequence[Hashable], right: Sequence[Hashable],
              values: Mapping[tuple[Hashable, Hashable], Value]) -> dict[Hashable, tuple[Value, ...]]:
    return {item: tuple(values[item, other] for other in right) for item in left}


def _fibers(items: Sequence[Hashable], profiles: Mapping[Hashable, tuple[Value, ...]]) -> tuple[tuple[Hashable, ...], ...]:
    unique = sorted(set(profiles.values()), key=repr)
    return tuple(tuple(item for item in items if profiles[item] == profile)
                 for profile in unique)


def _minimum_separator(rows: Sequence[Hashable], columns: Sequence[Hashable],
                       values: Mapping[tuple[Hashable, Hashable], Value]) -> tuple[Hashable, ...]:
    distinguishable = [
        (x, y) for index, x in enumerate(rows) for y in rows[index + 1:]
        if any(values[x, column] != values[y, column] for column in columns)
    ]
    for size in range(len(columns) + 1):
        for chosen in combinations(columns, size):
            if all(any(values[x, column] != values[y, column]
                       for column in chosen) for x, y in distinguishable):
                return tuple(chosen)
    raise AssertionError("all distinguishable pairs are separated by all columns")


def build_crystal(points: Sequence[Point], probes: Sequence[Probe],
                  values: Mapping[tuple[Point, Probe], Value]) -> ObservationCrystal:
    """Biextensional collapse plus exact minimum separating faces."""
    pts, obs = tuple(points), tuple(probes)
    if len(set(pts)) != len(pts) or len(set(obs)) != len(obs):
        raise ValueError("points and probes must be unique")
    if any((point, probe) not in values for point in pts for probe in obs):
        raise ValueError("observation matrix must be total")
    point_profiles = _profiles(pts, obs, values)
    probe_profiles = {probe: tuple(values[point, probe] for point in pts)
                      for probe in obs}
    point_fibers = _fibers(pts, point_profiles)
    probe_fibers = _fibers(obs, probe_profiles)
    point_reps = tuple(fiber[0] for fiber in point_fibers)
    probe_reps = tuple(fiber[0] for fiber in probe_fibers)
    collapsed = tuple(tuple(values[point, probe] for probe in probe_reps)
                      for point in point_reps)
    separating_probes = _minimum_separator(point_reps, probe_reps, values)
    transposed = {(probe, point): values[point, probe]
                  for point in point_reps for probe in probe_reps}
    separating_points = _minimum_separator(probe_reps, point_reps, transposed)
    unresolved_points = tuple((x, y) for fiber in point_fibers
                              for i, x in enumerate(fiber) for y in fiber[i + 1:])
    unresolved_probes = tuple((x, y) for fiber in probe_fibers
                              for i, x in enumerate(fiber) for y in fiber[i + 1:])
    return ObservationCrystal(point_fibers, probe_fibers, collapsed,
                              separating_probes, separating_points,
                              unresolved_points, unresolved_probes)


def binary_closure(points: Sequence[Point], probes: Sequence[Probe],
                   values: Mapping[tuple[Point, Probe], bool],
                   selected_points: Sequence[Point]) -> tuple[tuple[Point, ...], tuple[Probe, ...]]:
    """Formal-concept double-prime closure B -> (B', B'')."""
    pts, obs = tuple(points), tuple(probes)
    chosen = tuple(selected_points)
    intent = tuple(probe for probe in obs
                   if all(values[point, probe] for point in chosen))
    extent = tuple(point for point in pts
                   if all(values[point, probe] for probe in intent))
    return extent, intent
