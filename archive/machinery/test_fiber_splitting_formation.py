#!/usr/bin/env python3

import unittest

from fiber_splitting_formation import (
    descends,
    fibers,
    joint_fibers,
    square_cube_reconstruct,
)


class FiberSplittingFormationTests(unittest.TestCase):
    def test_cube_splits_every_nonzero_square_fiber(self):
        chart = tuple(range(-20, 21))
        square = lambda x: x * x
        cube = lambda x: x * x * x
        self.assertFalse(descends(chart, square, cube))
        square_blocks = fibers(chart, square)
        joint_blocks = joint_fibers(chart, square, cube)
        self.assertEqual(len(square_blocks), 21)
        self.assertEqual(len(joint_blocks), 41)
        self.assertTrue(all(len(block) == 1 for block in joint_blocks.values()))

    def test_exact_integer_reconstruction(self):
        for x in range(-100, 101):
            self.assertEqual(square_cube_reconstruct(x * x, x * x * x), x)

    def test_sign_equivariance(self):
        for x in range(-100, 101):
            self.assertEqual((-x) ** 2, x ** 2)
            self.assertEqual((-x) ** 3, -(x ** 3))

    def test_postprocessing_cannot_split_a_fiber(self):
        chart = tuple(range(-5, 6))
        square = lambda x: x * x
        for post in (lambda y: y, lambda y: 7 * y, lambda y: y % 3,
                     lambda y: (y, y * y)):
            self.assertTrue(descends(chart, square, lambda x, p=post: p(square(x))))

    def test_joint_refines_each_input_observable(self):
        chart = tuple(range(-8, 9))
        square = lambda x: x * x
        parity = lambda x: x % 2
        for block in joint_fibers(chart, square, parity).values():
            self.assertEqual(len({square(x) for x in block}), 1)
            self.assertEqual(len({parity(x) for x in block}), 1)

    def test_reconstruction_fails_closed_off_image(self):
        for pair in ((0, 1), (4, 9), (4, 12), (-1, -1)):
            with self.assertRaises(ValueError):
                square_cube_reconstruct(*pair)


if __name__ == "__main__":
    unittest.main()
