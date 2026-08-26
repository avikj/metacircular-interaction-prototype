import unittest

from compositional_crystal import Operation, crystallize_algebra, factor_map


class CompositionalCrystalTests(unittest.TestCase):
    def test_equal_now_but_context_separates(self):
        elements = (0, 1, 2)
        add = Operation("add", 2, {(x, y): (x + y) % 3
                                   for x in elements for y in elements})
        observation = {0: 0, 1: 1, 2: 1}
        crystal = crystallize_algebra(elements, (add,), observation)
        self.assertEqual(len(crystal.fibers), 3)
        self.assertFalse(crystal.equations)
        witness = next(item for item in crystal.distinctions
                       if item[0:2] == (1, 2))
        self.assertEqual(len(witness[2]), 1)
        self.assertNotEqual(witness[3], witness[4])

    def test_parity_is_compositional_for_addition_mod_four(self):
        elements = (0, 1, 2, 3)
        add = Operation("add", 2, {(x, y): (x + y) % 4
                                   for x in elements for y in elements})
        observation = {x: x % 2 for x in elements}
        crystal = crystallize_algebra(elements, (add,), observation)
        self.assertEqual(set(map(frozenset, crystal.fibers)),
                         {frozenset({0, 2}), frozenset({1, 3})})
        self.assertEqual(set(map(frozenset, crystal.equations)),
                         {frozenset({0, 2}), frozenset({1, 3})})

    def test_quotient_operation_is_well_defined(self):
        elements = (0, 1, 2, 3)
        add = Operation("add", 2, {(x, y): (x + y) % 4
                                   for x in elements for y in elements})
        crystal = crystallize_algebra(elements, (add,), {x: x % 2 for x in elements})
        name, arity, table = crystal.operations[0]
        self.assertEqual((name, arity), ("add", 2))
        self.assertEqual(len(table), 4)

    def test_factorization_is_unique_when_equations_are_respected(self):
        elements = (0, 1, 2, 3)
        add = Operation("add", 2, {(x, y): (x + y) % 4
                                   for x in elements for y in elements})
        crystal = crystallize_algebra(elements, (add,), {x: x % 2 for x in elements})
        self.assertEqual(set(factor_map(crystal, {0: "e", 2: "e", 1: "o", 3: "o"})),
                         {"e", "o"})
        with self.assertRaises(ValueError):
            factor_map(crystal, {0: "zero", 2: "two", 1: "o", 3: "o"})

    def test_multistep_context_is_synthesized(self):
        elements = (0, 1, 2, 3)
        step = Operation("step", 1, {(x,): min(x + 1, 3) for x in elements})
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        crystal = crystallize_algebra(elements, (step,), observation)
        witness = next(item for item in crystal.distinctions
                       if item[0:2] == (0, 1))
        self.assertEqual(len(witness[2]), 2)
        self.assertEqual((witness[3], witness[4]), (0, 1))
        self.assertEqual(len(crystal.separating_contexts), 3)


if __name__ == "__main__":
    unittest.main()
