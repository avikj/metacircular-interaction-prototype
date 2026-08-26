import unittest

from machinery.twisted_fixed_orbits import (
    compile_twisted_fixed_orbits,
    cyclic_multiplier_certificate,
    smallest_failure,
)


class TwistedFixedOrbitTests(unittest.TestCase):
    def test_smallest_comparison_failure(self):
        result = smallest_failure()
        self.assertEqual(result.fixed_orbit_count, 1)
        self.assertEqual(result.ordinary_fixed_orbits, 0)

    def test_mod15_gcd_sectors(self):
        result, arithmetic = cyclic_multiplier_certificate(15, 2, 4, 4)
        self.assertEqual(arithmetic, (3, 1, 15, 1))
        self.assertEqual(sum(arithmetic) // 4, result.fixed_orbit_count)
        self.assertEqual((result.ordinary_fixed_orbits,
                          result.fixed_orbit_count), (2, 5))

    def test_nonequivariant_endomap_rejected(self):
        states = (0, 1, 2)
        identity = {0: 0, 1: 1, 2: 2}
        swap = {0: 1, 1: 0, 2: 2}
        bad = {0: 0, 1: 2, 2: 1}
        with self.assertRaisesRegex(ValueError, "not equivariant"):
            compile_twisted_fixed_orbits(states, (identity, swap), bad)

    def test_nonclosed_action_family_rejected(self):
        states = (0, 1, 2)
        identity = {0: 0, 1: 1, 2: 2}
        cycle = {0: 1, 1: 2, 2: 0}
        with self.assertRaisesRegex(ValueError, "not closed"):
            compile_twisted_fixed_orbits(states, (identity, cycle), identity)


if __name__ == "__main__":
    unittest.main()
