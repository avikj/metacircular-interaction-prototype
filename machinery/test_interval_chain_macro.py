import unittest

from machinery.interval_chain_macro import (
    compile_interval_chain_macro, is_chain_map,
)


class IntervalChainMacroTests(unittest.TestCase):
    def test_two_level_expansion_equals_target(self):
        result = compile_interval_chain_macro()
        self.assertEqual(result.expansion, result.target)
        self.assertTrue(is_chain_map(result.ambient_differential,
                                     result.ambient_differential, result.target))
        self.assertEqual(result.carrier_total_dimension, 2)

    def test_one_level_definition_breaks_boundary_preservation(self):
        result = compile_interval_chain_macro()
        self.assertFalse(is_chain_map(result.ambient_differential,
                                      result.ambient_differential,
                                      result.one_level_false_control))

    def test_base_and_macro_have_same_homology_denotation(self):
        result = compile_interval_chain_macro()
        self.assertEqual(result.induced_h0_rank, 0)
        self.assertEqual(result.base.degree_one, [[0]])
        # Explicit chain homotopy target = d h + h d (one term per degree).
        from machinery.qap_informative_macro import mul
        self.assertEqual(mul(result.null_homotopy, result.ambient_differential),
                         result.target.degree_one)
        self.assertEqual(mul(result.ambient_differential, result.null_homotopy),
                         result.target.degree_zero)

    def test_carrier_maps_are_chain_maps(self):
        result = compile_interval_chain_macro()
        self.assertTrue(is_chain_map(result.carrier_differential,
                                     result.ambient_differential, result.include))
        self.assertTrue(is_chain_map(result.ambient_differential,
                                     result.carrier_differential,
                                     result.coordinates))


if __name__ == "__main__":
    unittest.main()
