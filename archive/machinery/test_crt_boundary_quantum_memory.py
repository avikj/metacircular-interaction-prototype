import unittest

from crt_boundary_quantum_memory import (
    boundary_profile,
    coherent_lift,
    coherent_replay,
    compatible,
)


class CRTBoundaryQuantumMemoryTests(unittest.TestCase):
    def test_non_coprime_cover_has_six_dimensional_hidden_register(self):
        profile = boundary_profile((4, 6, 9))
        self.assertEqual(
            (profile.source_dimension, profile.compatible_record_count,
             profile.hidden_memory_dimension),
            (216, 36, 6),
        )
        images = [coherent_lift(value, profile.moduli) for value in range(216)]
        self.assertEqual(len(set(images)), 216)
        self.assertEqual({hidden for _record, hidden in images}, set(range(6)))

    def test_coherent_replay_is_exact(self):
        for moduli in ((4, 6, 9), (3, 4, 5), (2, 2), (1, 7)):
            profile = boundary_profile(moduli)
            for value in range(profile.source_dimension):
                record, hidden = coherent_lift(value, moduli)
                self.assertTrue(compatible(record, moduli))
                self.assertEqual(coherent_replay(record, hidden, moduli), value)

    def test_pairwise_coprime_cover_needs_no_hidden_register(self):
        profile = boundary_profile((3, 4, 5))
        self.assertEqual(
            (profile.source_dimension, profile.compatible_record_count,
             profile.hidden_memory_dimension),
            (60, 60, 1),
        )

    def test_rejects_bad_boundary_data(self):
        with self.assertRaises(ValueError):
            boundary_profile(())
        self.assertFalse(compatible((0, 0), (4, 6, 9)))
        with self.assertRaises(ValueError):
            coherent_replay((0, 1), 0, (4, 6))


if __name__ == "__main__":
    unittest.main()
