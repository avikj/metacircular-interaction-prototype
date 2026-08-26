import unittest

from addition_chain_process_memory import (
    available,
    endpoint_partition,
    execute_chain,
    predictive_partition,
    separating_values,
)


class AdditionChainProcessMemoryTests(unittest.TestCase):
    def setUp(self):
        self.via_three = execute_chain(((1, 1), (1, 2), (3, 3)))
        self.via_four = execute_chain(((1, 1), (2, 2), (2, 4)))

    def test_same_endpoint_different_persistent_cache(self):
        self.assertEqual(self.via_three.endpoint, 6)
        self.assertEqual(self.via_four.endpoint, 6)
        self.assertEqual(self.via_three.formed, frozenset((1, 2, 3, 6)))
        self.assertEqual(self.via_four.formed, frozenset((1, 2, 4, 6)))

    def test_one_step_future_queries_separate_histories(self):
        self.assertTrue(available(self.via_three, 3))
        self.assertFalse(available(self.via_four, 3))
        self.assertEqual(separating_values(self.via_three, self.via_four), (3, 4))

    def test_endpoint_quotient_is_not_predictively_sufficient(self):
        states = (self.via_three, self.via_four)
        self.assertEqual(endpoint_partition(states), ((0, 1),))
        self.assertEqual(predictive_partition(states, (3, 4)), ((0,), (1,)))

    def test_without_persistence_the_separation_is_erased(self):
        endpoint_only = tuple(
            state.__class__(state.endpoint, frozenset((state.endpoint,)), state.events)
            for state in (self.via_three, self.via_four)
        )
        self.assertEqual(predictive_partition(endpoint_only, (3, 4)), ((0, 1),))

    def test_unformed_operand_fails_closed(self):
        with self.assertRaises(ValueError):
            execute_chain(((1, 2),))


if __name__ == "__main__":
    unittest.main()
