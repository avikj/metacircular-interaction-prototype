#!/usr/bin/env python3
"""Hostile-audit tests for R0027, breaker cf-tessera. Exact and exhaustive
within declared finite scope. Replays notes/INVARIANT_SCHEMA_ENVELOPE_AUDIT.md."""

from __future__ import annotations

import unittest
from itertools import permutations

from tessera_audit_r0027 import (
    A_SOURCE,
    D_TARGET,
    all_partitions,
    all_subgroups,
    classified_transporter,
    close,
    det,
    matmul,
    orbit_partition_of_group,
    orbits_union_find,
    partition_preservers,
    refines,
    transporter_box,
    young_subgroup,
)


class GaloisConnectionTests(unittest.TestCase):
    def test_adjunction_exhaustive_n_le_3(self):
        # G <= K(P) iff E_G <= P, over the full subgroup x partition lattices.
        for n in (1, 2, 3):
            partitions = all_partitions(n)
            for group in all_subgroups(n):
                e_g = orbit_partition_of_group(n, group)
                for p in partitions:
                    left = group <= young_subgroup(n, p)
                    right = refines(e_g, p)
                    self.assertEqual(left, right, (n, sorted(group), p))

    def test_envelope_identities_follow_exhaustively(self):
        for n in (1, 2, 3):
            for group in all_subgroups(n):
                e_g = orbit_partition_of_group(n, group)
                envelope = young_subgroup(n, e_g)
                self.assertTrue(group <= envelope)
                e_env = orbit_partition_of_group(n, envelope)
                self.assertEqual(e_env, e_g)
                self.assertEqual(young_subgroup(n, e_env), envelope)

    def test_alternative_return_map_is_not_lawful(self):
        # Block-permuting K~ fails identity (2) on two points with trivial group.
        n = 2
        trivial = close(n, frozenset({tuple(range(n))}))
        e_g = orbit_partition_of_group(n, trivial)  # ((0,),(1,))
        alt = partition_preservers(n, e_g)
        self.assertEqual(len(alt), 2)
        e_alt = orbit_partition_of_group(n, alt)
        self.assertNotEqual(e_alt, e_g)
        self.assertFalse(refines(e_alt, e_g))


class MinimalityTests(unittest.TestCase):
    def test_no_collision_below_three_points(self):
        for n in (1, 2):
            seen: dict[tuple, frozenset] = {}
            for group in all_subgroups(n):
                e_g = orbit_partition_of_group(n, group)
                self.assertNotIn(e_g, seen, f"collision on {n} points")
                seen[e_g] = group

    def test_unique_collision_on_three_points(self):
        n = 3
        by_partition: dict[tuple, list[frozenset]] = {}
        for group in all_subgroups(n):
            by_partition.setdefault(orbit_partition_of_group(n, group), []).append(group)
        collisions = {p: gs for p, gs in by_partition.items() if len(gs) > 1}
        self.assertEqual(len(collisions), 1)
        ((partition, groups),) = collisions.items()
        self.assertEqual(partition, ((0, 1, 2),))
        self.assertEqual(sorted(len(g) for g in groups), [3, 6])
        self.assertEqual(len(all_subgroups(3)), 6)


class TransporterTests(unittest.TestCase):
    BOUND = 25

    def test_transporter_is_exactly_two_lines(self):
        self.assertEqual(set(transporter_box(self.BOUND)),
                         set(classified_transporter(self.BOUND)))
        self.assertGreater(len(transporter_box(self.BOUND)), 20)

    def test_determinant_is_minus_c_and_both_signs_occur(self):
        dets = set()
        for u in transporter_box(self.BOUND):
            c = u[1][0]
            self.assertIn(c, (1, -1))
            self.assertEqual(det(u), -c)
            dets.add(det(u))
        self.assertEqual(dets, {1, -1})

    def test_builders_family_is_the_c_equals_1_component(self):
        for k in range(-self.BOUND // 2, self.BOUND // 2 + 1):
            u = ((k, 1 - 2 * k), (1, -2))
            self.assertEqual(matmul(u, A_SOURCE), D_TARGET)
            self.assertEqual(det(u), -1)

    def test_second_component_witness(self):
        v = ((0, 1), (-1, 2))
        self.assertEqual(det(v), 1)
        self.assertEqual(matmul(v, A_SOURCE), D_TARGET)

    def test_stabilizer_of_target_has_two_components(self):
        found = set()
        rng = range(-6, 7)
        for p in rng:
            for q in rng:
                for r in rng:
                    for s in rng:
                        v = ((p, q), (r, s))
                        if abs(det(v)) == 1 and matmul(v, D_TARGET) == D_TARGET:
                            found.add(v)
        expected = {((1, q), (0, s)) for q in range(-6, 7) for s in (1, -1)}
        self.assertEqual(found, expected)

    def test_false_control_determinant_two_map_rejected(self):
        w = ((0, 1), (2, -4))
        self.assertEqual(matmul(w, A_SOURCE), D_TARGET)
        self.assertEqual(abs(det(w)), 2)
        self.assertNotIn(w, transporter_box(6))


class BuilderReplayTests(unittest.TestCase):
    def test_union_find_orbits_match_group_orbits(self):
        for n in (2, 3):
            for group in all_subgroups(n):
                self.assertEqual(orbits_union_find(n, tuple(group)),
                                 orbit_partition_of_group(n, group))

    def test_young_subgroup_matches_filtering_definition(self):
        for n in (2, 3):
            for p in all_partitions(n):
                block_of = {x: i for i, b in enumerate(p) for x in b}
                filtered = frozenset(
                    perm for perm in permutations(range(n))
                    if all(block_of[x] == block_of[perm[x]] for x in range(n))
                )
                self.assertEqual(young_subgroup(n, p), filtered)


if __name__ == "__main__":
    unittest.main()
