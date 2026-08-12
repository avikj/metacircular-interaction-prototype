#!/usr/bin/env python3
"""Worst-case invalidation: polynomial at depth one, hard at depth two.

Answers the open question codex-ananta closed 0248 with. Both of the errors
I made building it are pinned as tests rather than deleted.
"""

import random
import unittest

from withdrawal_robustness import (
    NO_INSTANCE,
    YES_INSTANCE,
    build_bundled,
    build_star,
    has_equal_sum_grouping,
    is_depth_one,
    loads,
    optimum_bruteforce,
    optimum_depth_one,
    roots,
    satisfies_side_condition,
    worst_case,
)


class SemanticsTests(unittest.TestCase):
    def test_root_follows_the_pointer_chain(self):
        nodes, seeds = ["z", "a", "b"], {"z": "n0"}
        choice = {"a": "z", "b": "a"}
        self.assertEqual(roots(nodes, seeds, choice), {"z": "n0", "a": "n0", "b": "n0"})
        self.assertEqual(loads(nodes, seeds, choice), {"n0": 3})

    def test_one_pointer_moves_the_whole_star(self):
        """The bundling that makes the problem hard."""
        nodes, seeds, _ = build_star([3], 2)
        left = {"h0": "z0", "l0_0": "h0", "l0_1": "h0"}
        right = {"h0": "z1", "l0_0": "h0", "l0_1": "h0"}
        self.assertEqual(worst_case(nodes, seeds, left), 4)
        self.assertEqual(worst_case(nodes, seeds, right), 4)


class DepthOneIsPolynomialTests(unittest.TestCase):
    NODES = ["z0", "z1", "z2", "a", "b", "c", "d"]
    SEEDS = {"z0": "n0", "z1": "n1", "z2": "n2"}
    CANDS = {"a": ["z0", "z1"], "b": ["z0"], "c": ["z1", "z2"], "d": ["z0", "z2"]}

    def test_the_instance_is_depth_one(self):
        self.assertTrue(is_depth_one(self.SEEDS, self.CANDS))

    def test_flow_matches_brute_force(self):
        self.assertEqual(
            optimum_depth_one(self.NODES, self.SEEDS, self.CANDS),
            optimum_bruteforce(self.NODES, self.SEEDS, self.CANDS),
        )

    def test_flow_matches_brute_force_on_random_instances(self):
        rng = random.Random(5)
        for _ in range(300):
            nseed = rng.randrange(2, 4)
            seeds = {f"z{j}": f"n{j}" for j in range(nseed)}
            nodes, cands = list(seeds), {}
            for i in range(rng.randrange(1, 6)):
                v = f"a{i}"
                nodes.append(v)
                cands[v] = rng.sample(list(seeds), rng.randrange(1, nseed + 1))
            self.assertEqual(
                optimum_depth_one(nodes, seeds, cands),
                optimum_bruteforce(nodes, seeds, cands),
                (nodes, cands),
            )


class DepthExactlyTwoIsAlreadyHardTests(unittest.TestCase):
    """Error 1, pinned: my first gadget used chains of unbounded depth, so it
    proved hardness at *some* depth while I wrote the boundary as depth two."""

    def test_the_star_has_depth_exactly_two(self):
        sizes, _ = YES_INSTANCE
        _, seeds, cands = build_star(sizes, len(sizes) // 3)
        for v, cs in cands.items():
            for c in cs:
                self.assertTrue(c in seeds or c in cands, (v, c))
                if c in cands:                      # a leaf pointing at a head
                    self.assertTrue(all(x in seeds for x in cands[c]))

    def test_reduction_yes_instance(self):
        sizes, B = YES_INSTANCE
        m = len(sizes) // 3
        self.assertTrue(has_equal_sum_grouping(sizes, m, B))
        self.assertLessEqual(optimum_bruteforce(*build_star(sizes, m)), B + 1)

    def test_reduction_no_instance(self):
        sizes, B = NO_INSTANCE
        m = len(sizes) // 3
        self.assertFalse(has_equal_sum_grouping(sizes, m, B))
        self.assertGreater(optimum_bruteforce(*build_star(sizes, m)), B + 1)

    def test_star_and_chain_agree(self):
        """Depth was never what carried the reduction — only bundling was."""
        for sizes, _ in (YES_INSTANCE, NO_INSTANCE):
            m = len(sizes) // 3
            self.assertEqual(
                optimum_bruteforce(*build_star(sizes, m)),
                optimum_bruteforce(*build_bundled(sizes, m)),
                sizes,
            )


class SideConditionTests(unittest.TestCase):
    """Error 2, pinned: without `B/4 < a_i < B/2` the gadget decides equal-sum
    grouping, not 3-PARTITION — my first check used bad inputs and blamed the
    reduction."""

    def test_both_instances_satisfy_it(self):
        for sizes, B in (YES_INSTANCE, NO_INSTANCE):
            self.assertTrue(satisfies_side_condition(sizes, B), (sizes, B))

    def test_dropping_it_changes_the_question(self):
        sizes, B, m = [5, 3, 2, 2, 2, 2], 8, 2
        self.assertFalse(satisfies_side_condition(sizes, B))
        self.assertTrue(has_equal_sum_grouping(sizes, m, B))
        self.assertLessEqual(optimum_bruteforce(*build_star(sizes, m)), B + 1)


if __name__ == "__main__":
    unittest.main()
