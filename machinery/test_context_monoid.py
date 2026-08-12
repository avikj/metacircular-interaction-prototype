import unittest

from compositional_crystal import Operation
from context_monoid import build_context_monoid


class ContextMonoidTests(unittest.TestCase):
    def test_addition_mod_four_parity_has_two_effective_actions(self):
        elements = tuple(range(4))
        add = Operation("add", 2, {(x, y): (x + y) % 4
                                   for x in elements for y in elements})
        result = build_context_monoid(
            elements, (add,), {x: x % 2 for x in elements}
        )
        self.assertEqual(set(map(frozenset, result.fibers)),
                         {frozenset({0, 2}), frozenset({1, 3})})
        self.assertEqual(set(result.transformations), {(0, 1), (1, 0)})
        self.assertEqual(result.witnesses, ((0, 1, ()),))

    def test_context_separation_is_returned_as_shortest_word(self):
        elements = tuple(range(3))
        add = Operation("add", 2, {(x, y): (x + y) % 3
                                   for x in elements for y in elements})
        result = build_context_monoid(
            elements, (add,), {0: 0, 1: 1, 2: 1}
        )
        self.assertEqual(len(result.fibers), 3)
        self.assertEqual(len(result.transformations), 3)
        for left, right, word in result.witnesses:
            target_left = result.apply_word(left, word)
            target_right = result.apply_word(right, word)
            self.assertNotEqual(result.observations[target_left],
                                result.observations[target_right])
        hidden_now = [item for item in result.witnesses
                      if result.observations[item[0]] == result.observations[item[1]]]
        self.assertEqual(len(hidden_now), 1)
        self.assertEqual(len(hidden_now[0][2]), 1)

    def test_duplicate_generators_do_not_duplicate_effective_actions(self):
        elements = (0, 1)
        identity_a = Operation("identity-a", 1, {(x,): x for x in elements})
        identity_b = Operation("identity-b", 1, {(x,): x for x in elements})
        result = build_context_monoid(
            elements, (identity_a, identity_b), {0: 0, 1: 1}
        )
        self.assertEqual(result.transformations, ((0, 1),))
        self.assertEqual(len(result.generators), 1)

    def test_malformed_operation_fails_through_crystal_validator(self):
        bad = Operation("bad", 1, {(0,): 1})
        with self.assertRaises(ValueError):
            build_context_monoid((0, 1), (bad,), {0: 0, 1: 1})


if __name__ == "__main__":
    unittest.main()
