#!/usr/bin/env python3

import unittest

from odd_tail_certificate import verify


def certificate(**changes):
    data = {
        "schema": "odd-negative-root-tail-v1",
        "subject_id": "test-polynomial-001",
        "prefix_id": "prefix-q5",
        "resultant_abs": 100,
        "negative_root_upper": {"num": "1", "den": "2"},
        "pair_radius_uppers": [{"num": "1", "den": "1"}],
        "prefix_exponents": [0, 1, 3],
        "first_tail_exponent": 5,
        "tail_model": {"exponent_stride": 2, "coefficient_abs_bound": 1},
    }
    data.update(changes)
    return data


class OddTailCertificateTests(unittest.TestCase):
    def test_strict_exclusion_is_exact(self) -> None:
        result = verify(certificate())
        self.assertTrue(result["excluded"])
        self.assertEqual(result["degree"], 3)
        self.assertEqual(result["left_lower"], {"num": "75", "den": "1"})
        self.assertEqual(result["right_upper"], {"num": "9", "den": "32"})
        self.assertEqual(result["strict_margin"], {"num": "2391", "den": "32"})
        self.assertEqual(len(result["certificate_input_sha256"]), 64)

    def test_nonpositive_margin_fails_without_rounding(self) -> None:
        result = verify(certificate(
            resultant_abs=1,
            negative_root_upper={"num": "9", "den": "10"},
            pair_radius_uppers=[{"num": "2", "den": "1"}],
        ))
        self.assertFalse(result["excluded"])
        self.assertTrue(result["strict_margin"]["num"].startswith("-"))

    def test_exact_zero_margin_is_not_excluded(self) -> None:
        result = verify(certificate(
            resultant_abs=6,
            negative_root_upper={"num": "1", "den": "2"},
            pair_radius_uppers=[{"num": "6", "den": "1"}],
            prefix_exponents=[1],
            first_tail_exponent=3,
        ))
        self.assertFalse(result["excluded"])
        self.assertEqual(result["strict_margin"], {"num": "0", "den": "1"})

    def test_degree_tracks_any_number_of_pairs(self) -> None:
        result = verify(certificate(pair_radius_uppers=[
            {"num": "1", "den": "1"},
            {"num": "3", "den": "2"},
            {"num": "2", "den": "1"},
        ]))
        self.assertEqual(result["complex_pair_count"], 3)
        self.assertEqual(result["degree"], 7)

    def test_rejects_invalid_hypotheses(self) -> None:
        bad = [
            (certificate(negative_root_upper={"num": "1", "den": "1"}), "strictly between"),
            (certificate(negative_root_upper={"num": "2", "den": "4"}), "canonical reduced"),
            (certificate(prefix_exponents=[0, 3, 1]), "strictly increasing"),
            (certificate(first_tail_exponent=3), "after the prefix"),
            (certificate(first_tail_exponent=6), "must be odd"),
            (certificate(resultant_abs=0), "must be positive"),
            (certificate(pair_radius_uppers=[{"num": "0", "den": "1"}]),
             "radii must be positive"),
            (certificate(tail_model={"exponent_stride": 1, "coefficient_abs_bound": 1}),
             "tail_model must be exactly"),
            (certificate(schema="wrong"), "schema must be"),
        ]
        for data, pattern in bad:
            with self.subTest(data=data):
                with self.assertRaisesRegex(ValueError, pattern):
                    verify(data)


if __name__ == "__main__":
    unittest.main()
