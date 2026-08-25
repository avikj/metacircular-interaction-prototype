import unittest

from witness_construction import binary_addition_chain, construct_critical_witness


class WitnessConstructionTests(unittest.TestCase):
    def test_binary_length_and_dependencies(self):
        for target in range(1, 1000):
            events = binary_addition_chain(target)
            expected = target.bit_length() - 1 + target.bit_count() - 1
            self.assertEqual(len(events), expected)
            formed = {1}
            for event in events:
                self.assertIn(event.left, formed)
                self.assertIn(event.right, formed)
                self.assertEqual(event.result, event.left + event.right)
                formed.add(event.result)
            self.assertIn(target, formed)

    def test_exact_successor_comparison(self):
        ties = []
        for target in range(1, 1000):
            length = len(binary_addition_chain(target))
            self.assertLessEqual(length, target - 1)
            if length == target - 1:
                ties.append(target)
        self.assertEqual(ties, [1, 2, 3])

    def test_composed_critical_certificate(self):
        for p in (2, 3, 5, 7):
            for a in range(1, 35):
                for b in range(1, 35):
                    v, modulus, target, events = construct_critical_witness(a, b, p)
                    self.assertEqual(modulus, p ** (v + 1))
                    self.assertEqual((a + target) % modulus, 0)
                    self.assertLessEqual(target, modulus)
                    self.assertLessEqual(len(events), 2 * (modulus.bit_length() - 1))


if __name__ == "__main__":
    unittest.main()
