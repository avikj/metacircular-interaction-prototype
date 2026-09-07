import unittest

from online_smith_certificate_reversibility import (
    clean_retained_input_map,
    first_smith_transition,
    maximum_fiber_dimension,
    smith_online_profile,
)


class OnlineSmithCertificateReversibilityTests(unittest.TestCase):
    def test_all_sources_coalesce_after_first_step(self):
        self.assertEqual(
            {first_smith_transition(q)[1] for q in range(20)},
            {((1, 7), (2, 0))},
        )

    def test_certificate_restores_injectivity(self):
        profile = smith_online_profile(20)
        self.assertEqual(profile["post_image_size"], 1)
        self.assertEqual(profile["record_image_size"], 20)
        self.assertEqual(profile["post_environment_dimension"], 20)
        self.assertEqual(profile["joint_environment_dimension"], 1)
        self.assertTrue(profile["joint_is_injective"])

    def test_output_dimension_does_not_become_private_garbage(self):
        for count in (0, 1, 2, 9):
            self.assertTrue(clean_retained_input_map(count))
            self.assertEqual(
                smith_online_profile(count)["record_image_size"], count
            )

    def test_general_fiber_cost(self):
        self.assertEqual(maximum_fiber_dimension([]), 0)
        self.assertEqual(maximum_fiber_dimension(["a", "a", "b"]), 2)


if __name__ == "__main__":
    unittest.main()
