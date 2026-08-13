import unittest

from machinery.chain_payload_closure import (
    compile_chain_payload, interval_edge, loop_edge, qmatrix, qvector,
)


class ChainPayloadClosureTests(unittest.TestCase):
    def test_interval_boundary_forces_second_carrier_dimension(self):
        result = interval_edge()
        self.assertEqual(result.forced_boundaries, (qvector((-1, 1)),))
        self.assertEqual(result.ungraded_payload_rank, 1)
        self.assertEqual((result.degree_one_rank, result.degree_zero_rank), (1, 1))
        self.assertEqual(result.chain_carrier_dimension, 2)
        self.assertFalse(result.candidate_is_subcomplex(()))
        self.assertTrue(result.candidate_is_subcomplex((qvector((-1, 1)),)))

    def test_loop_control_needs_no_boundary_channel(self):
        result = loop_edge()
        self.assertEqual(result.ungraded_payload_rank, 1)
        self.assertEqual(result.chain_carrier_dimension, 1)

    def test_two_edges_shared_boundary_can_compress_degree_zero(self):
        differential = qmatrix(((-1, -1), (1, 1)))
        result = compile_chain_payload(
            differential, (qvector((1, 0)), qvector((0, 1)))
        )
        self.assertEqual(result.degree_one_rank, 2)
        self.assertEqual(result.degree_zero_rank, 1)
        self.assertEqual(result.chain_carrier_dimension, 3)

    def test_shape_mismatch_rejected(self):
        with self.assertRaisesRegex(ValueError, "wrong dimension"):
            compile_chain_payload(qmatrix(((-1,), (1,))), (qvector((1, 0)),))


if __name__ == "__main__":
    unittest.main()
