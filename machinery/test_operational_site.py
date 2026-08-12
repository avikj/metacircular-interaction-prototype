import unittest

from machinery.operational_site import (
    density_certificate,
    descent_equalizer,
    minimum_separating_family,
    observation_partition,
)


class OperationalSiteTests(unittest.TestCase):
    def test_density_requires_every_singleton(self):
        omega = frozenset(range(4))
        dense = [frozenset({x}) for x in omega]
        self.assertEqual(density_certificate(omega, dense)["faithful"], True)
        certificate = density_certificate(omega, dense[:-1])
        self.assertEqual(certificate["faithful"], False)
        self.assertEqual(certificate["missing_singletons"], (3,))

    def test_contextual_crystal_and_minimum_separator(self):
        states = list(range(12))
        mod3 = {x: x % 3 for x in states}
        mod4 = {x: x % 4 for x in states}
        parity = {x: x % 2 for x in states}
        self.assertEqual(len(observation_partition(states, [mod3, mod4])), 12)
        self.assertEqual(minimum_separating_family(states, [parity, mod3, mod4]), (1, 2))

    def test_descent_for_overlapping_subsets(self):
        # A global word (a,b,c) restricts to (a,b) and (b,c).
        bits = (0, 1)
        globals_ = [(a, b, c) for a in bits for b in bits for c in bits]
        locals_ = (
            [(a, b) for a in bits for b in bits],
            [(b, c) for b in bits for c in bits],
        )
        result = descent_equalizer(
            globals_,
            locals_,
            lambda word: (word[:2], word[1:]),
            lambda pair: pair[0][1] == pair[1][0],
        )
        self.assertTrue(result["effective_descent"])
        self.assertEqual(result["matching_count"], 8)

    def test_separated_but_not_effective(self):
        result = descent_equalizer(
            [(0, 0), (1, 1)],
            [(0, 1), (0, 1)],
            lambda word: word,
            lambda pair: True,
        )
        self.assertTrue(result["separated"])
        self.assertFalse(result["effective_descent"])
        self.assertEqual(result["image_count"], 2)
        self.assertEqual(result["matching_count"], 4)


if __name__ == "__main__":
    unittest.main()
