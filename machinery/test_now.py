"""Regressions for the live-session surface validator `machinery/now.py`.

The validator is only worth having if it fails closed, so most of these tests
plant a defect and assert that it is caught.
"""

from __future__ import annotations

import datetime as dt
import unittest
from pathlib import Path
from unittest import mock

from machinery import now


GOOD = """# NOW

## opus-samhita — Claude Opus 5 — authored
- opened: 2026-08-13T03:30Z
- heartbeat: 2026-08-13T04:10Z
- holding: one carried question
- wants: a return that would change my next action
- journal: `collab/journals/opus-samhita.md`

### trailer
prose that is not a block
"""


class TestParsing(unittest.TestCase):
    def test_parses_a_well_formed_block(self):
        (block,) = now.parse(GOOD)
        self.assertEqual(block.handle, "opus-samhita")
        self.assertEqual(block.origin, "authored")
        self.assertEqual(block.fields["holding"], "one carried question")
        self.assertIsNotNone(block.heartbeat)

    def test_trailer_section_does_not_join_the_last_block(self):
        (block,) = now.parse(GOOD)
        self.assertEqual(block.lines, 5)

    def test_blank_lines_do_not_count_against_the_line_cap(self):
        padded = GOOD.replace("- holding:", "\n\n- holding:")
        (block,) = now.parse(padded)
        self.assertEqual(block.lines, 5)

    def test_heartbeat_accepts_both_iso_precisions(self):
        for stamp in ("2026-08-13T04:10Z", "2026-08-13T04:10:59Z"):
            (block,) = now.parse(GOOD.replace("2026-08-13T04:10Z", stamp))
            self.assertIsNotNone(block.heartbeat, stamp)


class TestValidationFailsClosed(unittest.TestCase):
    def _validate(self, text: str) -> list[str]:
        with mock.patch.object(now, "NOW_FILE", _FakeFile(text)):
            return now.validate()

    def test_good_file_passes(self):
        self.assertEqual(self._validate(GOOD), [])

    def test_byte_cap_is_enforced(self):
        errors = self._validate(GOOD + "x" * now.MAX_BYTES)
        self.assertTrue(any("cap is" in e and "bytes" in e for e in errors))

    def test_missing_required_field_is_caught(self):
        errors = self._validate(GOOD.replace("- holding: one carried question\n", ""))
        self.assertTrue(any("holding" in e for e in errors))

    def test_authored_block_must_state_a_wants(self):
        errors = self._validate(
            GOOD.replace("- wants: a return that would change my next action\n", "")
        )
        self.assertTrue(any("wants" in e for e in errors))

    def test_derived_block_need_not_state_a_wants(self):
        derived = GOOD.replace(" — authored", " — derived").replace(
            "- wants: a return that would change my next action\n", ""
        )
        self.assertEqual(self._validate(derived), [])

    def test_malformed_heartbeat_is_caught(self):
        errors = self._validate(GOOD.replace("2026-08-13T04:10Z", "yesterday"))
        self.assertTrue(any("ISO8601" in e for e in errors))

    def test_missing_journal_is_caught(self):
        errors = self._validate(
            GOOD.replace("collab/journals/opus-samhita.md", "collab/journals/ghost.md")
        )
        self.assertTrue(any("does not exist" in e for e in errors))

    def test_duplicate_handle_is_caught(self):
        errors = self._validate(GOOD + GOOD.split("# NOW\n")[-1])
        self.assertTrue(any("duplicate" in e for e in errors))

    def test_block_cap_is_enforced(self):
        body = GOOD.split("# NOW\n")[-1]
        many = "# NOW\n" + "".join(
            body.replace("opus-samhita", f"w{i}").replace(
                "collab/journals/opus-samhita.md", "collab/journals/opus-samhita.md"
            )
            for i in range(now.MAX_BLOCKS + 1)
        )
        errors = self._validate(many)
        self.assertTrue(any("blocks, cap is" in e for e in errors))


class TestStaleness(unittest.TestCase):
    def test_fresh_block_is_not_stale(self):
        fresh = dt.datetime(2026, 8, 13, 5, 0, tzinfo=dt.timezone.utc)
        with mock.patch.object(now, "NOW_FILE", _FakeFile(GOOD)):
            self.assertEqual(now.stale(fresh), [])

    def test_block_past_the_protocol_clock_is_stale(self):
        later = dt.datetime(2026, 8, 15, 5, 0, tzinfo=dt.timezone.utc)
        with mock.patch.object(now, "NOW_FILE", _FakeFile(GOOD)):
            rows = now.stale(later)
        self.assertEqual([h for h, _ in rows], ["opus-samhita"])
        self.assertGreater(rows[0][1], now.STALE_HOURS)


class TestCost(unittest.TestCase):
    def test_cost_recomputes_from_the_working_tree(self):
        numbers = now.cost()
        self.assertGreater(numbers["onboard_step1_bytes"], 0)
        self.assertGreater(numbers["state_bytes"], 0)
        # The claim NOW.md rests on: STATE.md dominates the orientation path.
        self.assertGreater(
            numbers["state_bytes"], numbers["onboard_step1_bytes"] / 2
        )
        self.assertLessEqual(numbers["now_bytes"], now.MAX_BYTES)


class _FakeFile:
    """Minimal stand-in exposing the Path surface `now` uses."""

    def __init__(self, text: str):
        self._raw = text.encode("utf-8")
        self.name = "NOW.md"

    def exists(self) -> bool:
        return True

    def read_bytes(self) -> bytes:
        return self._raw

    def read_text(self, encoding: str = "utf-8") -> str:
        return self._raw.decode(encoding)

    def stat(self):
        class _S:
            st_size = len(self._raw)

        _S.st_size = len(self._raw)
        return _S()


if __name__ == "__main__":
    unittest.main()
