import unittest

from machinery.ramanujan_composed_certificate import (
    compose_certificates, wheel30_to_210,
)
from machinery.ramanujan_sieve_ingestion import certified_ramanujan_rows
from machinery.ramanujan_trace import compile_ramanujan_trace


class RamanujanComposedCertificateTests(unittest.TestCase):
    def test_30_to_210_composes_without_composite_field_rebuild(self):
        result = wheel30_to_210()
        self.assertEqual(result.cost.old_cells_reused, 72)
        self.assertEqual(result.cost.new_cells_formed, 504)
        self.assertEqual(result.cost.scratch_cells, 576)
        self.assertEqual(result.cost.full_cache_lookups_per_shift, 16)
        self.assertEqual(result.cost.factor_route_lookups_per_shift, 9)
        self.assertEqual(result.cost.cached_old_factor_lookups_per_shift, 1)
        self.assertEqual(result.full_cache_break_even, 3)
        self.assertEqual(result.factor_route_break_even, 1)
        self.assertEqual(result.cached_old_factor_break_even, 1)

    def test_corrupt_old_certificate_rejected(self):
        rows = certified_ramanujan_rows(30)
        rows[6] = rows[6][:-1] + (999,)
        with self.assertRaisesRegex(ValueError, "old row"):
            compose_certificates(30, rows, compile_ramanujan_trace(7))

    def test_corrupt_prime_certificate_rejected(self):
        cert = compile_ramanujan_trace(7)
        corrupt = cert.__class__(cert.modulus, cert.cyclotomic, cert.values,
                                 cert.spectral_traces[:-1] + (999,),
                                 cert.full_group_algebra_traces)
        with self.assertRaisesRegex(ValueError, "prime row"):
            compose_certificates(30, certified_ramanujan_rows(30), corrupt)


if __name__ == "__main__":
    unittest.main()
