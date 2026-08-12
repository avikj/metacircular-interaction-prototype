import unittest

from ported_tower_quantum_encoder import (
    coherent_environment_dimension,
    endpoints,
    fixed_all_ones_domain_size,
    is_injective,
    zero_error_endpoint_dimension,
)


class PortedTowerQuantumEncoderTests(unittest.TestCase):
    def test_twelve_port_encoder_is_clean_and_exact(self):
        self.assertTrue(is_injective(12, 3))
        self.assertEqual(coherent_environment_dimension(12, 3), 1)
        self.assertEqual(zero_error_endpoint_dimension(12, 3), 4096)

    def test_endpoint_basis_need_not_fill_ambient_ternary_register(self):
        image = set(endpoints(3, 3).values())
        self.assertEqual(len(image), 8)
        self.assertEqual(max(image), 13)
        self.assertNotEqual(len(image), max(image) + 1)

    def test_radix_two_is_also_injective_for_bits(self):
        self.assertTrue(is_injective(8, 2))
        self.assertEqual(zero_error_endpoint_dimension(8, 2), 256)

    def test_fixing_ports_is_domain_restriction(self):
        self.assertEqual(len(endpoints(12, 3)), 4096)
        self.assertEqual(fixed_all_ones_domain_size(12), 1)


if __name__ == "__main__":
    unittest.main()
