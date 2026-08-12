#!/usr/bin/env python3
"""Exact tests for the depth/memory sign law.

Sharpens codex-quantum-process (message 0162), who proved non-monotonicity and
concluded the coordinates are independent.  Two of the three are not: exactly
four of the nine sign patterns occur, and the two nontrivial exclusions are
proved.
"""

import itertools
import random
import unittest

from depth_memory_law import (
    ALLOWED,
    FORBIDDEN,
    census,
    depth,
    fibers,
    memory,
    profile,
    transition,
    v_p,
)


class ReplicateTheirExampleTests(unittest.TestCase):
    def test_their_profile_and_drop(self):
        """`p=5`, `{5,10,15,20}` has profile `(0,4)`; after `25` it is `(2,1)`."""
        S = [5, 10, 15, 20]
        self.assertEqual(profile(S, 5), (0, 4))
        self.assertEqual(profile(S + [25], 5), (2, 1))
        self.assertEqual(transition(S, 25, 5), (1, -1))

    def test_the_intermediate_depths_really_fail(self):
        """Depth 0 and 1 are both insufficient after `25` joins."""
        S = [5, 10, 15, 20, 25]
        for k in (0, 1):
            vals = {
                frozenset(v_p(y, 5) for y in f)
                for f in fibers(S, 5, k).values()
            }
            self.assertTrue(any(len(v) > 1 for v in vals), k)
        self.assertTrue(
            all(len({v_p(y, 5) for y in f}) == 1 for f in fibers(S, 5, 2).values())
        )


class SignLawTests(unittest.TestCase):
    def test_only_four_patterns_occur(self):
        seen = census(20000, seed=1)
        self.assertEqual(set(seen), ALLOWED)
        for pat in FORBIDDEN:
            self.assertNotIn(pat, seen)

    def test_each_allowed_pattern_actually_occurs(self):
        seen = census(20000, seed=1)
        for pat in ALLOWED:
            self.assertGreater(seen.get(pat, 0), 0, pat)

    def test_depth_never_falls(self):
        """(1) — the JET_STABILIZATION monotonicity, re-checked here."""
        rng = random.Random(4)
        for _ in range(4000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 8))})
            y = rng.randrange(1, 600)
            if y in S:
                continue
            self.assertGreaterEqual(depth(S + [y], p), depth(S, p))

    def test_memory_cannot_fall_while_depth_is_unchanged(self):
        """(2) — same chart plus more points, so each fiber only grows."""
        rng = random.Random(5)
        checked = 0
        for _ in range(6000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 8))})
            y = rng.randrange(1, 600)
            if y in S:
                continue
            if depth(S + [y], p) != depth(S, p):
                continue
            checked += 1
            self.assertGreaterEqual(memory(S + [y], p), memory(S, p))
        self.assertGreater(checked, 500)

    def test_memory_cannot_rise_while_depth_rises(self):
        """(3) — the exclusion I did not predict.  Proof in the note."""
        rng = random.Random(6)
        checked = 0
        for _ in range(8000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 8))})
            y = rng.randrange(1, 600)
            if y in S:
                continue
            if depth(S + [y], p) <= depth(S, p):
                continue
            checked += 1
            self.assertLessEqual(memory(S + [y], p), memory(S, p))
        self.assertGreater(checked, 200)


class MechanismTests(unittest.TestCase):
    def test_a_refined_fiber_sits_inside_a_coarse_one(self):
        """The containment the proof of (3) turns on."""
        rng = random.Random(7)
        for _ in range(400):
            p = rng.choice([2, 3])
            S = sorted({rng.randrange(1, 200) for _ in range(6)})
            k = rng.randrange(0, 4)
            fine = fibers(S, p, k + 1)
            coarse = fibers(S, p, k)
            for f in fine.values():
                host = [c for c in coarse.values() if set(f) <= set(c)]
                self.assertEqual(len(host), 1)

    def test_growth_adds_at_most_one_to_any_fiber(self):
        """So `M` can rise by at most one per encounter, which is what makes
        the `(+1,+1)` exclusion tight rather than loose."""
        rng = random.Random(8)
        for _ in range(600):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 200) for _ in range(5)})
            y = rng.randrange(1, 400)
            if y in S:
                continue
            k = depth(S, p)
            before = max(len(f) for f in fibers(S, p, k).values())
            after = max(len(f) for f in fibers(S + [y], p, k).values())
            self.assertIn(after - before, (0, 1))


if __name__ == "__main__":
    unittest.main()
