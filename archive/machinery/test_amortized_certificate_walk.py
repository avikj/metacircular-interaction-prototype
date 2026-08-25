import unittest

from machinery.amortized_certificate_walk import (
    CostCertificate,
    choose_route,
    indistinguishable_prefix_no_go,
    wheel30_certificate,
)


class AmortizedCertificateWalkTests(unittest.TestCase):
    def test_wheel30_threshold_and_route_change(self):
        certificate = wheel30_certificate()
        self.assertEqual(certificate.least_profitable_queries(), 4)
        self.assertEqual(choose_route(certificate, 3).route, "old")
        self.assertEqual(choose_route(certificate, 4).route, "compile")

    def test_strict_boundary_when_divisible(self):
        certificate = CostCertificate(10, 7, 2)
        self.assertFalse(certificate.strict_gain(2))  # equality is not gain
        self.assertEqual(certificate.least_profitable_queries(), 3)

    def test_no_gain_when_new_route_not_cheaper_per_query(self):
        self.assertIsNone(CostCertificate(0, 8, 8).least_profitable_queries())
        self.assertIsNone(CostCertificate(1, 8, 9).least_profitable_queries())

    def test_horizon_free_optimum_is_impossible_at_boundary(self):
        short, long = indistinguishable_prefix_no_go(wheel30_certificate())
        self.assertNotEqual(short.route, long.route)

    def test_invalid_costs_and_horizons_fail_closed(self):
        with self.assertRaisesRegex(ValueError, "nonnegative"):
            CostCertificate(-1, 2, 1).least_profitable_queries()
        with self.assertRaisesRegex(ValueError, "nonnegative"):
            choose_route(CostCertificate(1, 2, 1), -1)


if __name__ == "__main__":
    unittest.main()
