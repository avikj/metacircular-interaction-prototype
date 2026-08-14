import unittest

from machinery.task_generated_projector import (
    compile_task_projector, cyclic_autocorrelation, wheel_unit_projector,
)


class TaskGeneratedProjectorTests(unittest.TestCase):
    def test_w30_unit_task_requires_every_cyclotomic_sector(self):
        result = wheel_unit_projector(30)
        self.assertEqual(result.supported_orders, (1, 2, 3, 5, 6, 10, 15, 30))
        self.assertEqual(result.predicted_rank, 30)
        self.assertEqual(result.orbit_matrix_rank, 30)
        self.assertEqual(result.sector_dimensions[-1], 8)

    def test_primitive_only_assumption_false_control(self):
        full = wheel_unit_projector(30)
        # The primitive-order-30 Ramanujan row is not the unit indicator and
        # its correlation cannot answer the same all-shift task.
        from machinery.ramanujan_trace import compile_ramanujan_trace
        primitive = compile_ramanujan_trace(30).spectral_traces
        self.assertNotEqual(cyclic_autocorrelation(primitive), full.correlation)

    def test_constant_task_needs_only_trivial_sector(self):
        result = compile_task_projector((1,) * 30)
        self.assertEqual(result.supported_orders, (1,))
        self.assertEqual(result.orbit_matrix_rank, 1)

    def test_single_frequency_rational_sector(self):
        # Alternating signal is the order-2 rational character.
        result = compile_task_projector(tuple((-1) ** x for x in range(30)))
        self.assertEqual(result.supported_orders, (2,))
        self.assertEqual(result.orbit_matrix_rank, 1)


if __name__ == "__main__":
    unittest.main()
