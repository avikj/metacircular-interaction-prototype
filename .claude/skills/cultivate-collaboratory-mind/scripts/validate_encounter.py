#!/usr/bin/env python3
"""Fail-closed structural validator for collaboratory encounter packets."""

from __future__ import annotations

import json
import sys
from pathlib import Path


REQUIRED = {
    "encounter_id", "object", "sender_before", "received_from",
    "received_difference", "prasanga", "sender_after", "recipient",
    "recipient_conditioning", "transmission", "replay", "return",
    "future_change", "uncertainty",
}
PRASANGA = {"conditioning", "opposite_witness", "reconstruction"}


def validate(packet: dict) -> list[str]:
    errors = []
    missing = REQUIRED - packet.keys()
    if missing:
        errors.append("missing fields: " + ", ".join(sorted(missing)))
    extra = packet.keys() - REQUIRED
    if extra:
        errors.append("unknown fields: " + ", ".join(sorted(extra)))
    for key in REQUIRED - {"return", "prasanga", "received_from", "replay"}:
        if key in packet and (not isinstance(packet[key], str) or not packet[key].strip()):
            errors.append(f"{key} must be a nonempty string")
    for key in ("received_from", "replay"):
        if key in packet and (not isinstance(packet[key], list) or not packet[key]):
            errors.append(f"{key} must be a nonempty list")
    p = packet.get("prasanga")
    if not isinstance(p, dict):
        errors.append("prasanga must be an object")
    else:
        if set(p) != PRASANGA:
            errors.append("prasanga requires exactly: " + ", ".join(sorted(PRASANGA)))
        for key in PRASANGA:
            if key in p and (not isinstance(p[key], str) or not p[key].strip()):
                errors.append(f"prasanga.{key} must be a nonempty string")
    if packet.get("return") is not None and not isinstance(packet.get("return"), str):
        errors.append("return must be a string or null")
    if packet.get("sender_before") == packet.get("sender_after"):
        errors.append("sender_after must record an actual change")
    if packet.get("transmission") == packet.get("future_change"):
        errors.append("delivery is not evidence of future change")
    return errors


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate_encounter.py PACKET.json", file=sys.stderr)
        return 2
    path = Path(sys.argv[1])
    try:
        packet = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        print(f"ERROR {error}", file=sys.stderr)
        return 1
    errors = validate(packet)
    if errors:
        for error in errors:
            print("ERROR", error)
        return 1
    print("PASS", path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
