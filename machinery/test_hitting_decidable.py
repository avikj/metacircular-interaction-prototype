#!/usr/bin/env python3
"""Exact tests for the finite decision procedure for hitting.

The decisive test is `test_finite_model_agrees_with_unbounded_search`: the
`Z/p^{e+1}` model must reproduce the verdicts of the genuinely unbounded
breadth-first search over `Z` from `hitting_time.py`.
"""

import itertools
import unittest

from hitting_decidable import (
    EMERGENT_P2,
    acts_trivially,
    additive,
    additive_hits,
    hits,
    multiplicative,
    multiplicative_hits,
    v_p,
    witness_path,
)
from hitting_time import INF, combined, hitting_time, multiplier, successor


class FiniteModelTests(unittest.TestCase):
    def test_finite_model_agrees_with_unbounded_search(self):
        cases = (
            ("succ", additive([1]), successor()),
            ("x2", multiplicative([2]), multiplier(2)),
            ("succ+x2", additive([1]) + multiplicative([2]),
             combined(successor(), multiplier(2))),
        )
        for p in (3, 5):
            for e in (1, 2):
                for name, aff, rule in cases:
                    finite = hits(p, e, aff)
                    unbounded = hitting_time(
                        p**e, p, rule, max_steps=60, bound=10**14
                    )
                    self.assertEqual(
                        finite, unbounded != INF, (p, e, name, unbounded)
                    )

    def test_the_witness_set_is_the_multiples_of_p_to_the_e_plus_one(self):
        """Why the model is `Z/p^{e+1}`: `y = p^e(1+t)` shares the depth-`e`
        chart, and `v_p(y) != e` iff `p | 1+t`, i.e. `p^{e+1} | y`."""
        for p in (2, 3, 5):
            for e in (1, 2):
                x = p**e
                for t in range(-6, 7):
                    y = x * (1 + t)
                    same_chart = (y - x) % p**e == 0
                    self.assertTrue(same_chart)
                    if y == 0:
                        self.assertEqual((1 + t) % p, 0)
                        continue
                    differs = v_p(y, p) != e
                    self.assertEqual(differs, (1 + t) % p == 0)


class PureFamilyTests(unittest.TestCase):
    def test_multiplicative_classification(self):
        for p in (3, 5, 7):
            for e in (1, 2):
                for gs in ((2,), (3,), (2, 3), (p,), (2, p), (4, 9), (p * 2,)):
                    self.assertEqual(
                        hits(p, e, multiplicative(gs)),
                        multiplicative_hits(p, gs),
                        (p, e, gs),
                    )

    def test_additive_classification(self):
        for p in (3, 5):
            for e in (1, 2, 3):
                for cs in ((1,), (p,), (p**2,), (p**3,), (p, 2), (p**2, p**3)):
                    self.assertEqual(
                        hits(p, e, additive(cs)),
                        additive_hits(p, e, cs),
                        (p, e, cs),
                    )


class NoEmergenceInNaturalFamiliesTests(unittest.TestCase):
    def test_a_never_hitting_additive_rule_is_the_identity(self):
        """The structural reason: `v_p(gcd) >= e+1` means every step is
        `0 mod p^{e+1}`, so the rule is invisible in the finite model."""
        for p in (2, 3, 5):
            for e in (1, 2):
                mv = additive([p ** (e + 1), 2 * p ** (e + 1)])
                self.assertFalse(hits(p, e, mv))
                self.assertTrue(acts_trivially(p, e, mv))

    def test_no_emergence_among_multiplicative_and_additive(self):
        """Exhaustive over small generators: no pair of individually
        never-hitting rules, one multiplicative and one additive, hits."""
        checked = 0
        for p in (3, 5, 7):
            for e in (1, 2):
                mults = [(g, 0) for g in range(2, 12) if g % p != 0]
                adds = [
                    (1, s * p ** (e + 1) * k)
                    for k in range(1, 4)
                    for s in (1, -1)
                ]
                for m in mults:
                    if hits(p, e, [m]):
                        continue
                    for a in adds:
                        if hits(p, e, [a]):
                            continue
                        checked += 1
                        self.assertFalse(hits(p, e, [m, a]), (p, e, m, a))
        self.assertGreater(checked, 100)


class EmergenceIsRealTests(unittest.TestCase):
    def test_the_minimal_emergent_pair(self):
        """`p = 2`, `e = 1`, in `Z/4`: `y -> 1` and `y -> 2y+2` each never
        reach `0` from `2`; together they do."""
        m1, m2 = EMERGENT_P2
        self.assertFalse(hits(2, 1, [m1]))
        self.assertFalse(hits(2, 1, [m2]))
        self.assertTrue(hits(2, 1, [m1, m2]))
        self.assertEqual(witness_path(2, 1, [m1, m2]), [2, 1, 0])

    def test_the_path_arithmetic(self):
        """`2 -> 1` by `y -> 1`; `1 -> 2*1+2 = 4 = 0 mod 4`."""
        self.assertEqual((0 * 2 + 1) % 4, 1)
        self.assertEqual((2 * 1 + 2) % 4, 0)
        # and each alone is stuck
        self.assertEqual((0 * 1 + 1) % 4, 1)  # y->1 fixes 1, never 0
        self.assertEqual((2 * 2 + 2) % 4, 2)  # y->2y+2 fixes 2, never 0

    def test_emergence_exists_at_several_primes(self):
        found = []
        for p in (2, 3, 5):
            M = p**2
            pool = [(g, c) for g in range(M) for c in range(M)]
            singles = [m for m in pool if not hits(p, 1, [m])]
            for m1, m2 in itertools.combinations(singles, 2):
                if hits(p, 1, [m1, m2]):
                    found.append((p, m1, m2))
                    break
        self.assertEqual(len(found), 3, found)


if __name__ == "__main__":
    unittest.main()
