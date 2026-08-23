#!/usr/bin/env python3

import itertools
import unittest

from proof_support_complementarity import (
    addition_three_event,
    first_submodularity_violation,
    minimal_supports,
    replayable,
    submodular_iff_singleton,
)


class ProofSupportComplementarityTests(unittest.TestCase):
    def test_minimal_addition_formation_event(self):
        support = ({"r2", "r3"},)
        self.assertEqual(addition_three_event(set()), frozenset({1}))
        self.assertEqual(addition_three_event({"r2"}), frozenset({1, 2}))
        self.assertEqual(addition_three_event({"r3"}), frozenset({1}))
        self.assertEqual(addition_three_event({"r2", "r3"}), frozenset({1, 2, 3}))
        self.assertEqual(first_submodularity_violation(support),
                         (frozenset({"r2"}), frozenset({"r3"})))

    def test_alternative_singleton_proofs_are_submodular(self):
        supports = ({"direct"}, {"detour1", "detour2"})
        self.assertEqual(minimal_supports(supports),
                         frozenset({frozenset({"direct"}),
                                    frozenset({"detour1", "detour2"})}))
        self.assertFalse(submodular_iff_singleton(supports))
        self.assertIsNotNone(first_submodularity_violation(supports))
        singleton_only = ({"left"}, {"right"})
        self.assertTrue(submodular_iff_singleton(singleton_only))
        self.assertIsNone(first_submodularity_violation(singleton_only))

    def test_classification_exhaustively_on_small_antichains(self):
        universe = ("a", "b", "c")
        nonempty = [frozenset(c) for n in range(1, 4)
                    for c in itertools.combinations(universe, n)]
        for mask in itertools.product((0, 1), repeat=len(nonempty)):
            family = [s for s, bit in zip(nonempty, mask) if bit]
            antichain = minimal_supports(family)
            if not antichain:
                continue
            predicted = submodular_iff_singleton(antichain)
            observed = first_submodularity_violation(antichain) is None
            self.assertEqual(predicted, observed, antichain)

    def test_nonminimal_supersets_do_not_change_observable(self):
        supports = ({"a"}, {"a", "b"}, {"c"})
        reduced = ({"a"}, {"c"})
        for retained in (set(), {"a"}, {"b"}, {"c"}, {"a", "b", "c"}):
            self.assertEqual(replayable(retained, supports), replayable(retained, reduced))

    def test_fail_closed_on_seed_or_underviable_fact(self):
        with self.assertRaises(ValueError):
            submodular_iff_singleton((set(),))
        with self.assertRaises(ValueError):
            submodular_iff_singleton(())


if __name__ == "__main__":
    unittest.main()
