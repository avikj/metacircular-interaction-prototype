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


if __name__ == "__main__":
    unittest.main()
