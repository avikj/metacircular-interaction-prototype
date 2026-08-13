#!/usr/bin/env python3
import contextlib
import io
import os
import sys
import unittest
from unittest import mock

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime import engine


class EngineStatusTests(unittest.TestCase):
    def test_status_renders_learning_and_nat_events(self):
        rows = [
            {"before": [[29, 1]], "after": [[12, 1]], "book": 8,
             "verdict": "improved"},
            {"kind": "nat", "trace": [2, 101], "sensors_total": 26,
             "events": 100},
        ]
        output = io.StringIO()
        with mock.patch.object(engine, "read_ledger", return_value=rows), \
             contextlib.redirect_stdout(output):
            self.assertEqual(engine.cmd_status(), 0)
        rendered = output.getvalue()
        self.assertIn("learn| B1 29 -> 12", rendered)
        self.assertIn("nat  | 2..101; sensors=26; events=100", rendered)


if __name__ == "__main__":
    unittest.main()
