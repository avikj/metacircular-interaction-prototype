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
    MULTI_WITNESS,
    floor_slack_census,
    memory_floor,
    multi_census,
    multi_transition,
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


class MultiPointTests(unittest.TestCase):
    """The sign law is the `k=1` case of a quantitative `k`-bound.

    I handed this question back and took it when the field stayed quiet.
    """

    def test_the_forbidden_cell_really_opens_at_k_two(self):
        """`(+1,+1)` is impossible for one point and possible for two."""
        p, S, Y = MULTI_WITNESS
        before, after = multi_transition(S, Y, p)
        self.assertEqual(before, (0, 2))
        self.assertEqual(after, (1, 3))
        self.assertGreater(after[0], before[0])
        self.assertGreater(after[1], before[1])

    def test_no_single_point_of_that_witness_does_it_alone(self):
        """Neither half raises both coordinates — the pair is essential."""
        p, S, Y = MULTI_WITNESS
        for y in Y:
            (d0, m0), (d1, m1) = multi_transition(S, [y], p)
            self.assertFalse(d1 > d0 and m1 > m0, y)

    def test_memory_rise_is_bounded_by_k_minus_one_when_depth_rises(self):
        """(3_k): the exact degradation of exclusion (3)."""
        rng = random.Random(17)
        checked = 0
        for _ in range(6000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 200) for _ in range(rng.randrange(2, 6))})
            k = rng.randrange(1, 5)
            Y = sorted({rng.randrange(1, 400) for _ in range(k)} - set(S))
            if not Y:
                continue
            (d0, m0), (d1, m1) = multi_transition(S, Y, p)
            if d1 <= d0:
                continue
            checked += 1
            self.assertLessEqual(m1 - m0, len(Y) - 1, (p, S, Y))
        self.assertGreater(checked, 300)

    def test_the_bound_is_attained_at_every_size(self):
        worst = multi_census(20000)
        for k in (1, 2, 3, 4):
            self.assertEqual(worst[k], k - 1, k)

    def test_the_other_two_laws_survive_multi_point(self):
        """(1) and (2) are insensitive to `k` — only (3) needed weakening."""
        rng = random.Random(29)
        for _ in range(3000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 200) for _ in range(rng.randrange(2, 6))})
            Y = sorted({rng.randrange(1, 400) for _ in range(3)} - set(S))
            if not Y:
                continue
            (d0, m0), (d1, m1) = multi_transition(S, Y, p)
            self.assertGreaterEqual(d1, d0)
            if d1 == d0:
                self.assertGreaterEqual(m1, m0)


class FloorTests(unittest.TestCase):
    """`M' >= ceil(M / p^dD)` — the bound on a memory DROP, and the statement
    that subsumes law (2)."""

    def test_the_floor_holds_on_the_depth_rises_branch(self):
        rng = random.Random(7)
        checked = 0
        for _ in range(8000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 8))})
            Y = sorted({rng.randrange(1, 600) for _ in range(rng.randrange(1, 4))}
                       - set(S))
            if not Y:
                continue
            (d0, m0), (d1, m1) = multi_transition(S, Y, p)
            if d1 <= d0:
                continue
            checked += 1
            self.assertGreaterEqual(m1, memory_floor(m0, p, d1 - d0), (p, S, Y))
        self.assertGreater(checked, 500)

    def test_the_floor_is_attained(self):
        """Their own example sits exactly on it: `M=4`, `dD=2`, `p=5`."""
        self.assertEqual(memory_floor(4, 5, 2), 1)
        self.assertEqual(profile([5, 10, 15, 20, 25], 5)[1], 1)
        slack = floor_slack_census(20000)
        self.assertGreater(slack.get(0, 0), 100)
        self.assertFalse([d for d in slack if d < 0])

    def test_the_floor_subsumes_law_two(self):
        """At `dD = 0` the floor is exactly `M`, which IS law (2)."""
        for p in (2, 3, 5):
            for M in range(1, 12):
                self.assertEqual(memory_floor(M, p, 0), M)

    def test_the_floor_is_k_independent_but_the_ceiling_is_not(self):
        """The two sides of the inequality have different characters: the
        floor never mentions the encounter size."""
        rng = random.Random(13)
        for _ in range(2000):
            p = rng.choice([2, 3, 5])
            S = sorted({rng.randrange(1, 300) for _ in range(rng.randrange(2, 7))})
            for k in (1, 2, 3):
                Y = sorted({rng.randrange(1, 600) for _ in range(k)} - set(S))
                if not Y:
                    continue
                (d0, m0), (d1, m1) = multi_transition(S, Y, p)
                if d1 <= d0:
                    continue
                # one floor, computed without k, bounds every batch size
                self.assertGreaterEqual(m1, memory_floor(m0, p, d1 - d0))
