import unittest

from invariant_schema_breaker_audit import (
    all_subgroups,
    block_permuting_counterexample,
    determinant_unrecoverable,
    envelope_identities_hold,
    false_control_rejected,
    galois_adjunction_holds,
    generated_group,
    orbit_collisions,
    orbit_partition,
    stabilizer_is_complete,
    torsor_bijection_holds,
    transporter_is_complete,
)


class GaloisEnvelopeTest(unittest.TestCase):
    def test_adjunction_exhaustive_n_le_3(self):
        for n in (1, 2, 3):
            self.assertTrue(galois_adjunction_holds(n))

    def test_envelope_identities_all_generating_sets_n3(self):
        from itertools import combinations, permutations
        elements = list(permutations(range(3)))
        for r in range(len(elements) + 1):
            for gens in combinations(elements, min(r, 3)):
                self.assertTrue(envelope_identities_hold(3, gens))
            if r > 3:
                break

    def test_block_permuting_return_map_fails(self):
        witness = block_permuting_counterexample()
        self.assertEqual(witness["K_perm_order"], 2)
        self.assertFalse(witness["identity2_holds"])


class OrbitCollisionCensusTest(unittest.TestCase):
    def test_subgroup_counts(self):
        self.assertEqual(len(all_subgroups(1)), 1)
        self.assertEqual(len(all_subgroups(2)), 2)
        self.assertEqual(len(all_subgroups(3)), 6)

    def test_only_collision_is_c3_s3(self):
        self.assertEqual(orbit_collisions(1), [])
        self.assertEqual(orbit_collisions(2), [])
        pairs = orbit_collisions(3)
        self.assertEqual(len(pairs), 1)
        g, h = pairs[0]
        self.assertEqual({len(g), len(h)}, {3, 6})
        c3 = generated_group(3, [(1, 2, 0)])
        s3 = generated_group(3, [(1, 2, 0), (1, 0, 2)])
        self.assertEqual({g, h}, {c3, s3})
        self.assertEqual(orbit_partition(3, c3),
                         frozenset({frozenset({0, 1, 2})}))


class SmithTransporterTest(unittest.TestCase):
    def test_transporter_complete_two_components(self):
        self.assertTrue(transporter_is_complete(6))

    def test_stabilizer_complete(self):
        self.assertTrue(stabilizer_is_complete(6))

    def test_torsor_bijection(self):
        self.assertTrue(torsor_bijection_holds(5))

    def test_determinant_unrecoverable(self):
        self.assertTrue(determinant_unrecoverable())

    def test_false_control(self):
        self.assertTrue(false_control_rejected())


if __name__ == "__main__":
    unittest.main()
