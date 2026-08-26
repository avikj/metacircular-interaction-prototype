import unittest

from critical_chain_option_value import (
    critical_representative,
    one_step_outputs,
    replay,
)


class CriticalChainOptionValueTests(unittest.TestCase):
    def test_both_chains_legally_reach_first_critical_witness(self):
        self.assertEqual(critical_representative(2, 2, 2), 6)
        self.assertEqual(replay((1, 2, 3, 6)), {1, 2, 3, 6})
        self.assertEqual(replay((1, 2, 4, 6)), {1, 2, 4, 6})

    def test_next_critical_witness_has_cost_one_versus_two(self):
        target = critical_representative(7, 1, 2)
        self.assertEqual(target, 9)
        cache_a = replay((1, 2, 3, 6))
        cache_b = replay((1, 2, 4, 6))
        self.assertIn(target, one_step_outputs(cache_a))
        self.assertNotIn(target, one_step_outputs(cache_b))
        cache_b.add(8)
        self.assertIn(target, one_step_outputs(cache_b))

    def test_garbage_collection_erases_separation(self):
        endpoint_cache = {1, 6}
        self.assertNotIn(9, one_step_outputs(endpoint_cache))


if __name__ == "__main__":
    unittest.main()

