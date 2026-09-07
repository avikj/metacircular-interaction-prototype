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
    def test_last_learning_entry_ignores_nat_events(self):
        learn = {"verdict": "plateau"}
        rows = [learn, {"kind": "nat", "trace": [2, 10]}]
        self.assertIs(engine.last_learning_entry(rows), learn)

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

    def test_loop_alternates_and_stops_at_declared_cycle_count(self):
        calls = []
        with mock.patch.object(engine, "cmd_step",
                               side_effect=lambda rounds, quick: calls.append(("learn", rounds, quick)) or 0), \
             mock.patch.object(engine, "cmd_nat",
                               side_effect=lambda span: calls.append(("nat", span)) or 0):
            self.assertEqual(engine.cmd_loop(4, 25, True, 0, 2), 0)
        self.assertEqual(calls, [
            ("learn", 4, True), ("nat", 25),
            ("learn", 4, True), ("nat", 25),
        ])


if __name__ == "__main__":
    unittest.main()
