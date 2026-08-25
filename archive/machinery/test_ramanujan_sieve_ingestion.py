import ast
from pathlib import Path
import types
import unittest

from machinery.ramanujan_sieve_ingestion import (
    certified_ramanujan_rows, compile_sieve_ingestion,
)


def load_exp39():
    path = Path(__file__).resolve().parents[1] / "code" / "exp39_rational_fiber_normalization.py"
    tree = ast.parse(path.read_text(), filename=str(path))
    wanted = {"prime_factors", "mobius", "phi", "divisors", "ramanujan_sum",
              "local_correlation_spectral", "local_correlation_direct"}
    exact_nodes = [node for node in tree.body
                   if isinstance(node, ast.FunctionDef) and node.name in wanted]
    namespace = {"Fraction": __import__("fractions").Fraction,
                 "gcd": __import__("math").gcd}
    exec(compile(ast.Module(body=exact_nodes, type_ignores=[]), str(path), "exec"),
         namespace)
    return types.SimpleNamespace(**namespace)


class RamanujanSieveIngestionTests(unittest.TestCase):
    def test_cyclotomic_rows_recompute_legacy_ramanujan_sum(self):
        legacy = load_exp39()
        rows = certified_ramanujan_rows(30)
        for q, row in rows.items():
            for h, value in enumerate(row):
                self.assertEqual(value, legacy.ramanujan_sum(q, h))

    def test_exp39_local_correlation_recomputed(self):
        legacy = load_exp39()
        for shift in (1, 2, 6, 10):
            result = compile_sieve_ingestion(30, shift)
            self.assertEqual(result.spectral_value,
                             legacy.local_correlation_spectral(30, shift))
            self.assertEqual(result.direct_value,
                             legacy.local_correlation_direct(30, shift))

    def test_changed_repeated_query_route(self):
        result = compile_sieve_ingestion(30, 6)
        self.assertEqual(result.spectral_terms, 8)
        self.assertEqual(result.direct_residue_checks, 30)
        # One-time cache: sum(q for q|30)=72 cells. Thereafter each shift uses
        # 8 divisor lookups instead of scanning 30 residues.
        self.assertEqual(result.compiled_trace_cells, 72)


if __name__ == "__main__":
    unittest.main()
