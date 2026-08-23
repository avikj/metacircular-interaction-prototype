import itertools
import unittest

from ported_twelve_step_compiler import PortedCompiler, erased_port_control


class PortedCompilerTests(unittest.TestCase):
    def test_twelve_ports_are_injective(self):
        compiler = PortedCompiler()
        compiler.run(12)
        histories = tuple(itertools.product((0, 1), repeat=12))
        endpoints = [compiler.respond(history) for history in histories]
        self.assertEqual(len(set(endpoints)), 2**12)
        self.assertEqual([compiler.decode(x) for x in endpoints], list(histories))

    def test_span_exceeds_twelve_year_hours(self):
        compiler = PortedCompiler()
        compiler.run(12)
        self.assertEqual(compiler.maximum_span, (3**12 - 1) // 2)
        self.assertGreater(compiler.maximum_span, 12 * 365.25 * 24)

    def test_each_step_doubles_responsive_family(self):
        compiler = PortedCompiler()
        steps = compiler.run(12)
        self.assertTrue(all(s.choices_after == 2 * s.choices_before for s in steps))
        self.assertEqual(steps[-1].choices_after, 4096)

    def test_erasure_keeps_reach_but_kills_choice(self):
        compiler = PortedCompiler()
        compiler.run(12)
        endpoint, responses = erased_port_control(12)
        self.assertEqual(endpoint, compiler.maximum_span)
        self.assertEqual(responses, 1)
        self.assertGreater(compiler.response_count, responses)

    def test_digit_reaching_radix_creates_carry_collision(self):
        compiler = PortedCompiler(radix=2)
        compiler.run(2)
        endpoint_from_large_low_digit = 2 * compiler.weights[0]
        endpoint_from_high_port = compiler.respond((0, 1))
        self.assertEqual(endpoint_from_large_low_digit, endpoint_from_high_port)


if __name__ == "__main__":
    unittest.main()
