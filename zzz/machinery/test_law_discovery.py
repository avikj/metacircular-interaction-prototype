import unittest

from machinery.law_discovery import (
    discover, dynamical_features, evaluate, features, observed_count,
)


class LawDiscoveryTests(unittest.TestCase):
    def test_discovers_binary_state_law(self):
        law = discover(tuple(range(1, 33)))
        self.assertIsNotNone(law)
        assert law is not None
        self.assertIn(law.text, ("(q+a)", "(a+q)"))
        self.assertEqual(law.size, 3)
        for modulus in range(33, 129):
            self.assertEqual(evaluate(law.text, modulus), observed_count(modulus))

    def test_raw_modulus_is_an_insufficient_small_language(self):
        law = discover(
            tuple(range(1, 33)), variables={"m": lambda modulus: modulus}
        )
        self.assertIsNone(law)

    def test_coordinates_are_derived_from_dynamics_not_factorization(self):
        for modulus in range(1, 257):
            self.assertEqual(dynamical_features(modulus), features(modulus))

    def test_planted_false_multiplicative_law_is_rejected(self):
        self.assertTrue(any(
            features(modulus)[0] * features(modulus)[1] != observed_count(modulus)
            for modulus in range(1, 20)
        ))

    def test_rejects_empty_training_set(self):
        with self.assertRaises(ValueError):
            discover(())


if __name__ == "__main__":
    unittest.main()
