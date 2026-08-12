import unittest

from twelve_step_compiler import (
    Action,
    RecursiveCompiler,
    first_step_exceeding_hours_to_years,
    independent_macro_control,
)


class TwelveStepCompilerTests(unittest.TestCase):
    def test_twelve_steps_are_a_causal_chain(self):
        compiler = RecursiveCompiler(3)
        trace = compiler.run(12)
        self.assertEqual(trace[0].parent, "successor")
        for before, after in zip(trace, trace[1:]):
            self.assertEqual(after.parent, before.installed)
            self.assertEqual(after.base_equivalent_work, 3 * before.base_equivalent_work)
        self.assertEqual(trace[-1].base_equivalent_work, 3**12)

    def test_recursive_certificate_has_exact_semantics(self):
        compiler = RecursiveCompiler(3)
        final = compiler.run(12)[-1]
        self.assertEqual(compiler.expand(final.installed), final.base_equivalent_work)
        self.assertEqual(compiler.replay_proof_cache(), 3 * 12)
        self.assertEqual(len(compiler.actions), 13)

    def test_false_certificate_is_rejected(self):
        compiler = RecursiveCompiler(3)
        with self.assertRaisesRegex(ValueError, "false translation"):
            compiler._check(Action("table-claim", 4, "successor", 3))

    def test_independent_improvements_do_not_compound(self):
        self.assertEqual(independent_macro_control(12, 3), 25)
        self.assertLess(independent_macro_control(12, 3), 3**12)

    def test_calendar_ratio_is_crossed_at_nine_not_twelve(self):
        self.assertEqual(first_step_exceeding_hours_to_years(), 9)
        self.assertLess(3**8 * 12, 12 * 365 * 24)
        self.assertGreaterEqual(3**9 * 12, 12 * 365 * 24)


if __name__ == "__main__":
    unittest.main()
