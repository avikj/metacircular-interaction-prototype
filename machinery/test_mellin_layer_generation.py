import unittest
from fractions import Fraction

from machinery.mellin_layer_generation import (
    generate_all, shape_projection, s_zero_layers,
)


class MellinLayerGenerationTests(unittest.TestCase):
    def test_finite_generation_strictly_decreases_deficit(self):
        states = generate_all(3, Fraction(-2))
        self.assertEqual(tuple(state.deficit for state in states), (3, 2, 1, 0))
        self.assertEqual(tuple(len(state.layers) for state in states), (1, 2, 3, 4))

    def test_u1_leading_coefficient(self):
        layers = s_zero_layers(3, Fraction(-2))
        self.assertEqual(layers[1].coefficient, -6)  # k D_mu(0)
        self.assertEqual(layers[1].decay_half_powers, 1)
        self.assertEqual(layers[1].wave_arity, 2)

    def test_coefficient_payload_no_go(self):
        mu = generate_all(3, Fraction(-2))[-1]
        divisor = generate_all(3, Fraction(1, 4))[-1]
        self.assertEqual(shape_projection(mu), shape_projection(divisor))
        self.assertNotEqual(mu.layers, divisor.layers)
        self.assertEqual(mu.layers[1].coefficient, -6)
        self.assertEqual(divisor.layers[1].coefficient, Fraction(3, 4))

    def test_no_missing_layer_when_arity_zero(self):
        states = generate_all(0, Fraction(7))
        self.assertEqual(len(states), 1)
        self.assertEqual(states[0].deficit, 0)


if __name__ == "__main__":
    unittest.main()
