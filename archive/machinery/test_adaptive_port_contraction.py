import unittest

from adaptive_port_contraction import (
    erased_port_preservable,
    retained_port_memory_dimension,
)


class AdaptivePortContractionTests(unittest.TestCase):
    def test_responsive_port_cannot_be_erased(self):
        endpoint = (0, 0)
        responses = ((0, 1), (0, 1))
        self.assertFalse(erased_port_preservable(endpoint, responses))
        self.assertEqual(retained_port_memory_dimension(endpoint, responses), 1)

    def test_null_port_can_be_erased_when_endpoint_sufficient(self):
        endpoint = (0, 1, 1)
        responses = ((7, 7), (8, 8), (8, 8))
        self.assertTrue(erased_port_preservable(endpoint, responses))

    def test_null_port_still_fails_endpoint_factorization(self):
        endpoint = (0, 0)
        responses = ((7, 7), (8, 8))
        self.assertFalse(erased_port_preservable(endpoint, responses))
        self.assertEqual(retained_port_memory_dimension(endpoint, responses), 2)

    def test_three_response_laws_need_qutrit_side_memory(self):
        endpoint = (0, 0, 0, 1)
        responses = ((0, 1), (1, 0), (1, 1), (0, 1))
        self.assertEqual(retained_port_memory_dimension(endpoint, responses), 3)


if __name__ == "__main__":
    unittest.main()
