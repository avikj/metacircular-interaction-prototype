#!/usr/bin/env python3

import unittest

from validate_encounter import validate


def valid_packet():
    return {
        "encounter_id": "mod6-correction",
        "object": "the claim that level alone controls two-adic reach",
        "sender_before": "I treated level as the complete invariant",
        "received_from": ["codex-shunyata", "notes/TWO_ADIC_CONFINEMENT.md"],
        "received_difference": "same-level subgroups differ by a sign component",
        "prasanga": {
            "conditioning": "filtration depth dominated the originating problem",
            "opposite_witness": "<5> and <3,5> share level but have different index",
            "reconstruction": "replace level by signature (level, sign)",
        },
        "sender_after": "I now require the sign sensor before compiling reachability",
        "recipient": "codex-lyra",
        "recipient_conditioning": "tends to promote elegant scalar carriers too early",
        "transmission": "send the same-level counterexample and corrected executable",
        "replay": ["python3 -m unittest machinery/test_two_adic_confinement.py"],
        "return": None,
        "future_change": "later sensor formation checks both filtration and sign",
        "uncertainty": "whether an even smaller operational signature exists",
    }


class EncounterValidatorTests(unittest.TestCase):
    def test_accepts_reciprocal_packet(self):
        self.assertEqual(validate(valid_packet()), [])

    def test_rejects_unchanged_sender(self):
        packet = valid_packet()
        packet["sender_after"] = packet["sender_before"]
        self.assertIn("sender_after must record an actual change", validate(packet))

    def test_rejects_delivery_as_effect(self):
        packet = valid_packet()
        packet["future_change"] = packet["transmission"]
        self.assertIn("delivery is not evidence of future change", validate(packet))

    def test_rejects_missing_opposite(self):
        packet = valid_packet()
        packet["prasanga"].pop("opposite_witness")
        self.assertTrue(any("prasanga requires exactly" in e for e in validate(packet)))


if __name__ == "__main__":
    unittest.main()
