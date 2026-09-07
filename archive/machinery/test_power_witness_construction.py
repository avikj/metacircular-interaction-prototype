import unittest

from power_witness_construction import binary_power_chain, construct_power_witness


class PowerWitnessConstructionTests(unittest.TestCase):
    def test_exact_count_and_dependencies(self):
        for base in (2, 3, 5, 7, 11):
            for exponent in range(1, 100):
                events = binary_power_chain(base, exponent)
                expected = exponent.bit_length() - 1 + exponent.bit_count() - 1
                self.assertEqual(len(events), expected)
                formed = {1, base}
                for event in events:
                    self.assertIn(event.left, formed)
                    self.assertIn(event.right, formed)
                    self.assertEqual(event.result, event.left * event.right)
                    formed.add(event.result)
                self.assertIn(base**exponent, formed)

    def test_constructed_target_is_valuation_witness(self):
        for p in (2, 3, 5, 7):
            for e in range(12):
                target, events = construct_power_witness(p, e)
                self.assertEqual(target, p ** (e + 1))
                self.assertEqual(len(events),
                                 (e + 1).bit_length() - 1 + (e + 1).bit_count() - 1)

    def test_multiplicative_unit_alone_is_a_false_control(self):
        reachable = {1}
        for _ in range(8):
            reachable |= {a * b for a in reachable for b in reachable}
        self.assertEqual(reachable, {1})


if __name__ == "__main__":
    unittest.main()
