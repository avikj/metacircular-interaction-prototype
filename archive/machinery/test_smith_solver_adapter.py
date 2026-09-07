import unittest
from dataclasses import replace

from exponent_world import ExponentWorld, WitnessedSmithSolution
from smith_residual_machine import smith_reduce
from smith_solver_adapter import solve_from_smith_certificate


class SmithSolverAdapterTests(unittest.TestCase):
    def test_reducer_certificate_drives_existing_affine_solver(self):
        certificate = smith_reduce(((2, 4), (6, 8)))
        world = ExponentWorld()
        result = solve_from_smith_certificate(world, certificate, (14, 18), 30)
        self.assertIsInstance(result, WitnessedSmithSolution)
        self.assertEqual(result.representative, (25, 6))
        self.assertEqual(result.kernel_generators, ((15, 0), (0, 15)))
        self.assertEqual(result.generator_orders, (2, 2))
        self.assertEqual(world.life.events[-1].kind, "form-operation")

    def test_adapter_preserves_coordinate_local_obstruction(self):
        certificate = smith_reduce(((2, 4), (6, 8)))
        result = solve_from_smith_certificate(
            ExponentWorld(), certificate, (14, 17), 30
        )
        self.assertEqual(result.coordinate, 1)
        self.assertEqual(result.obstruction.overlap, 2)

    def test_tampered_proof_object_fails_before_consumption(self):
        certificate = smith_reduce(((2, 4), (6, 8)))
        tampered = replace(certificate, left=((1, 0), (2, -1)))
        world = ExponentWorld()
        events_before = tuple(world.life.events)
        with self.assertRaisesRegex(ValueError, "invalid residual Smith"):
            solve_from_smith_certificate(world, tampered, (14, 18), 30)
        self.assertEqual(tuple(world.life.events), events_before)

    def test_rank_one_certificate_forms_free_coordinate(self):
        certificate = smith_reduce(((6, 0), (9, 0)))
        result = solve_from_smith_certificate(
            ExponentWorld(), certificate, (12, 18), 30
        )
        self.assertIsInstance(result, WitnessedSmithSolution)
        self.assertEqual(result.diagonal, (3, 0))
        self.assertEqual(result.diagonal_solution.kernel_size, 90)
        self.assertEqual(result.generator_orders, (3, 30))
        self.assertEqual(result.representative, (2, 0))
        self.assertEqual(result.kernel_generators, ((10, 0), (0, 1)))

    def test_rank_one_zero_coordinate_refuses_nonzero_target(self):
        certificate = smith_reduce(((6, 0), (9, 0)))
        result = solve_from_smith_certificate(
            ExponentWorld(), certificate, (13, 19), 30
        )
        self.assertEqual(result.coordinate, 1)
        self.assertEqual(result.obstruction.coefficient, 0)
        self.assertEqual(result.obstruction.overlap, 30)

    def test_zero_certificate_forms_full_free_module(self):
        certificate = smith_reduce(((0, 0), (0, 0)))
        result = solve_from_smith_certificate(
            ExponentWorld(), certificate, (0, 0), 7
        )
        self.assertIsInstance(result, WitnessedSmithSolution)
        self.assertEqual(result.diagonal_solution.kernel_size, 49)
        self.assertEqual(result.representative, (0, 0))
        self.assertEqual(result.kernel_generators, ((1, 0), (0, 1)))
        self.assertEqual(result.generator_orders, (7, 7))

    def test_zero_certificate_refuses_any_nonzero_target(self):
        certificate = smith_reduce(((0, 0), (0, 0)))
        result = solve_from_smith_certificate(
            ExponentWorld(), certificate, (0, 1), 7
        )
        self.assertEqual(result.coordinate, 1)
        self.assertEqual(result.obstruction, result.obstruction.__class__(0, 1, 7, 7))


if __name__ == "__main__":
    unittest.main()
