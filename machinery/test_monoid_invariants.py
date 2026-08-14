#!/usr/bin/env python3
"""Exact tests: kernel and idempotent invariants cannot decide hitting.

The decisive test is `test_the_hitting_map_has_maximal_rank_while_the_kernel_is_minimal`
— the mechanism, on the worked example.
"""

import unittest

from affine_emergence import generated_monoid
from hitting_decidable import hits
from monoid_invariants import (
    WORKED,
    census,
    hits_by_orbit,
    idempotent_image_says_hits,
    idempotents,
    image,
    kernel,
    kernel_image_says_hits,
    orbit,
    rank,
)


class OrbitIsTheTruthTests(unittest.TestCase):
    def test_orbit_membership_matches_the_model(self):
        """`0` in the orbit is exactly the hitting verdict."""
        for p, e in ((2, 1), (2, 2)):
            mod = p ** (e + 1)
            pool = [(g, c) for g in range(mod) for c in range(mod)]
            for i, a in enumerate(pool):
                for b in pool[i + 1:]:
                    self.assertEqual(
                        hits_by_orbit((a, b), p, e), hits(p, e, [a, b]), (a, b)
                    )


class WorkedExampleTests(unittest.TestCase):
    def test_the_hitting_map_has_maximal_rank_while_the_kernel_is_minimal(self):
        """`A : y -> 1` (rank 1) and `B : y -> 3y+2` (rank 4) mod 4, from 2.
        The kernel is the constant map; the map that reaches `0` is the
        bijection."""
        mod, s = 4, 2
        A, B = WORKED
        M = generated_monoid([A, B], mod)
        self.assertEqual(sorted(M), [(0, 1), (1, 0), (3, 2)])

        K = kernel(M, mod)
        self.assertEqual(sorted(K), [(0, 1)])
        self.assertEqual({rank(m, mod) for m in K}, {1})
        self.assertEqual(sorted(orbit(set(K), s, mod)), [1])

        hitters = [m for m in M if (m[0] * s + m[1]) % mod == 0]
        self.assertEqual(hitters, [(3, 2)])
        self.assertEqual(rank((3, 2), mod), mod)  # a bijection

    def test_the_criterion_misreports_on_it(self):
        self.assertTrue(hits_by_orbit(WORKED, 2, 1))
        self.assertFalse(kernel_image_says_hits(WORKED, 2, 1))

    def test_kernel_elements_have_minimal_rank(self):
        """Why kernel invariants describe eventual behaviour: the minimal
        ideal of a transformation monoid is its minimal-rank part."""
        mod = 4
        for a in [(0, 1), (2, 2), (1, 1), (3, 0)]:
            for b in [(3, 2), (0, 3), (2, 1)]:
                M = generated_monoid([a, b], mod)
                K = kernel(M, mod)
                least = min(rank(m, mod) for m in M)
                self.assertEqual({rank(m, mod) for m in K}, {least}, (a, b))


class CensusTests(unittest.TestCase):
    def test_mod_four_full_sweep_counts(self):
        """Pinned so a later change cannot quietly soften the no-go."""
        self.assertEqual(
            census(2, 1),
            {"pairs": 120, "kernel_wrong": 8, "idempotent_wrong": 33},
        )

    def test_both_invariants_fail_at_every_modulus(self):
        for p, e in ((2, 1), (2, 2), (3, 1)):
            c = census(p, e, 300)
            self.assertGreater(c["kernel_wrong"], 0, (p, e))
            self.assertGreater(c["idempotent_wrong"], 0, (p, e))

    def test_idempotents_are_worse_than_the_kernel(self):
        c = census(2, 1)
        self.assertGreater(c["idempotent_wrong"], c["kernel_wrong"])


class SanityTests(unittest.TestCase):
    def test_image_and_rank(self):
        self.assertEqual(image((1, 0), 4), {0, 1, 2, 3})
        self.assertEqual(rank((0, 1), 4), 1)
        self.assertEqual(rank((2, 0), 4), 2)

    def test_idempotents_are_idempotent(self):
        mod = 4
        M = generated_monoid([(0, 1), (3, 2)], mod)
        for m in idempotents(M, mod):
            self.assertEqual(((m[0] * (m[0] * 1 + m[1]) + m[1]) % mod),
                             ((m[0] * 1 + m[1]) % mod))


if __name__ == "__main__":
    unittest.main()
