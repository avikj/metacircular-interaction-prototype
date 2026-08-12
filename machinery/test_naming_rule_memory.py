import unittest

from naming_rule_memory import (
    affine_certificate,
    affine_tables,
    exact_memory_dimension,
)


class NamingRuleMemoryTests(unittest.TestCase):
    def test_affine_five_cost(self):
        certificate = affine_certificate(5)
        self.assertEqual(certificate["arbitrary_table_dimension"], 3125)
        self.assertEqual(certificate["affine_rule_dimension"], 25)
        self.assertEqual(certificate["compression_factor"], 125)

    def test_zero_and_one_recover_parameters(self):
        tables = affine_tables(5)
        coordinates = {(table[1] - table[0]) % 5 for table in tables}
        intercepts = {table[0] for table in tables}
        self.assertEqual(coordinates, set(range(5)))
        self.assertEqual(intercepts, set(range(5)))
        self.assertEqual(len(set(tables)), 25)

    def test_syntactic_duplicates_cost_once(self):
        rules = (
            lambda i: i % 3,
            lambda i: (i + 3) % 3,
            lambda i: (4 * i) % 3,
        )
        self.assertEqual(exact_memory_dimension((0, 1, 2), rules), 1)

    def test_two_distinct_behaviors_cost_two(self):
        rules = (lambda i: i % 2, lambda i: (i + 1) % 2)
        self.assertEqual(exact_memory_dimension((0, 1), rules), 2)

    def test_empty_family_rejected(self):
        with self.assertRaises(ValueError):
            exact_memory_dimension((0,), ())


if __name__ == "__main__":
    unittest.main()
