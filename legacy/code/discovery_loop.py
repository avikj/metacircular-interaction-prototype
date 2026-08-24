#!/usr/bin/env python3
"""Validate and route the agent-native mathematical discovery loop.

The durable state is Markdown, not a hidden database.  This script provides a
small epistemic type checker and emits role-specific prompts.  It deliberately
does not mutate packets: agents use normal reviewed file edits, leaving git as
the provenance log.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CLAIMS = ROOT / "collab" / "discovery" / "claims"
CERTIFICATION_ENABLED = False

STATUSES = {
    "seed",
    "formalizing",
    "proving",
    "breaking",
    "certified",
    "refuted",
    "known",
    "blocked",
    "inconclusive",
    "quarantined",
    "superseded",
}
KINDS = {"tension", "transport", "measurement", "obstruction", "synthesis"}
CERTIFICATES = {
    "unset",
    "exact-symbolic",
    "exact-finite",
    "formal",
    "asymptotic",
    "literature",
    "counterexample",
    "mixed",
}
BASE_FIELDS = {
    "id",
    "title",
    "status",
    "kind",
    "certificate",
    "load_bearing",
    "novelty",
    "generator",
    "dependencies",
    "statement_hash",
    "cycle",
    "max_cycles",
    "owner",
    "breaker",
    "source",
    "supersedes",
    "updated",
}
BASE_SECTIONS = {
    "tension",
    "rosetta bridge",
    "exact statement",
    "preservation ledger",
    "proof obligations",
    "falsification",
    "evidence",
    "independent audit",
    "prior art",
    "successor seeds",
    "event log",
}
PLACEHOLDERS = {"", "pending", "none", "unclaimed", "tbd", "n/a"}
NOVELTY = {
    "unsearched",
    "searched-not-found",
    "known",
    "possibly-new",
    "external-review-required",
}
ACTIVE = {"seed", "formalizing", "proving", "breaking"}
LEGAL_TRANSITIONS = {
    "unregistered": {"seed"},
    "seed": {"formalizing", "refuted", "known", "blocked", "inconclusive"},
    "formalizing": {"proving", "breaking", "refuted", "known", "blocked", "inconclusive"},
    "proving": {"breaking", "refuted", "known", "blocked", "inconclusive", "quarantined"},
    "breaking": {"proving", "certified", "refuted", "known", "blocked", "inconclusive", "quarantined"},
    "certified": {"superseded", "quarantined"},
    "refuted": {"superseded"},
    "known": {"superseded"},
    "blocked": {"formalizing", "inconclusive", "superseded"},
    "inconclusive": {"superseded"},
    "quarantined": {"formalizing", "refuted", "superseded"},
    "superseded": set(),
}


@dataclass
class Packet:
    path: Path
    meta: dict[str, str]
    sections: dict[str, str]

    @property
    def ident(self) -> str:
        return self.meta.get("id", self.path.stem)

    @property
    def statement_hash(self) -> str:
        statement = " ".join(self.sections.get("exact statement", "").split())
        return hashlib.sha256(statement.encode("utf-8")).hexdigest()

    @property
    def event_dir(self) -> Path:
        return ROOT / "collab" / "discovery" / "events" / self.ident

    def events(self) -> list[dict[str, object]]:
        result: list[dict[str, object]] = []
        for path in sorted(self.event_dir.glob("*.json")):
            event = json.loads(path.read_text(encoding="utf-8"))
            event["_path"] = str(path.relative_to(ROOT))
            result.append(event)
        return result


def parse_packet(path: Path) -> Packet:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return Packet(path, {}, {})
    try:
        _, front, body = text.split("---\n", 2)
    except ValueError:
        return Packet(path, {}, {})
    meta: dict[str, str] = {}
    duplicate_meta: set[str] = set()
    for line in front.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        normalized = key.strip().lower()
        if normalized in meta:
            duplicate_meta.add(normalized)
        meta[normalized] = value.strip()
    matches = list(re.finditer(r"(?m)^# (.+?)\s*$", body))
    sections: dict[str, str] = {}
    duplicate_sections: set[str] = set()
    for index, match in enumerate(matches):
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(body)
        name = match.group(1).strip().lower()
        if name in sections:
            duplicate_sections.add(name)
        sections[name] = body[start:end].strip()
    if duplicate_meta:
        meta["__duplicate_meta__"] = ",".join(sorted(duplicate_meta))
    if duplicate_sections:
        meta["__duplicate_sections__"] = ",".join(sorted(duplicate_sections))
    return Packet(path, meta, sections)


def packets() -> list[Packet]:
    return [parse_packet(path) for path in sorted(CLAIMS.glob("R*.md"))]


def substantive(value: str | None) -> bool:
    if value is None:
        return False
    normalized = value.strip().lower().rstrip(".")
    return normalized not in PLACEHOLDERS and len(normalized) >= 12


def validate(packet: Packet) -> list[str]:
    errors: list[str] = []
    missing_fields = sorted(BASE_FIELDS - packet.meta.keys())
    missing_sections = sorted(BASE_SECTIONS - packet.sections.keys())
    if missing_fields:
        errors.append("missing fields: " + ", ".join(missing_fields))
    if missing_sections:
        errors.append("missing sections: " + ", ".join(missing_sections))
    if packet.meta.get("__duplicate_meta__"):
        errors.append("duplicate front-matter keys: " + packet.meta["__duplicate_meta__"])
    if packet.meta.get("__duplicate_sections__"):
        errors.append("duplicate level-one sections: " + packet.meta["__duplicate_sections__"])
    if not re.fullmatch(r"R\d{4}", packet.ident):
        errors.append("claim id must match RNNNN")
    if not packet.path.name.startswith(packet.ident + "-"):
        errors.append("filename must begin with claim id")
    status = packet.meta.get("status", "")
    if status not in STATUSES:
        errors.append(f"invalid status: {status!r}")
    if packet.meta.get("kind", "") not in KINDS:
        errors.append(f"invalid kind: {packet.meta.get('kind', '')!r}")
    if packet.meta.get("certificate", "") not in CERTIFICATES:
        errors.append(f"invalid certificate: {packet.meta.get('certificate', '')!r}")
    if packet.meta.get("load_bearing", "") not in {"true", "false"}:
        errors.append("load_bearing must be true or false")
    if packet.meta.get("novelty", "") not in NOVELTY:
        errors.append(f"invalid novelty status: {packet.meta.get('novelty', '')!r}")
    if packet.meta.get("novelty", "") == "novel":
        errors.append("autonomous agents may never assign novelty status 'novel'")
    if packet.meta.get("statement_hash", "") != packet.statement_hash:
        errors.append("statement_hash does not match the normalized Exact statement")
    try:
        cycle = int(packet.meta.get("cycle", ""))
        max_cycles = int(packet.meta.get("max_cycles", ""))
        if cycle < 0 or max_cycles <= 0:
            raise ValueError
        if status in ACTIVE and cycle >= max_cycles:
            errors.append("active packet exhausted max_cycles; transition to inconclusive or a terminal state")
    except ValueError:
        errors.append("cycle and max_cycles must be nonnegative/positive integers")

    dependencies = [item.strip() for item in packet.meta.get("dependencies", "").split(",")]
    known_ids = {candidate.ident for candidate in packets()}
    for dependency in dependencies:
        if dependency != "none" and dependency not in known_ids:
            errors.append(f"unknown dependency claim id: {dependency}")

    events = packet.events()
    breaker_lineages: set[str] = set()
    checker_lineages: set[str] = set()
    if not events:
        errors.append("no append-only transition events")
    else:
        previous_to: str | None = None
        for index, event in enumerate(events):
            event_from = str(event.get("from", ""))
            event_to = str(event.get("to", ""))
            if index == 0 and event_from not in {"unregistered", "seed"}:
                errors.append("first event must begin at unregistered or seed")
            for key in ("claim_id", "from", "to", "actor", "role", "lineage", "at", "statement_hash", "reason", "artifacts"):
                if key not in event:
                    errors.append(f"event missing {key}: {event.get('_path')}")
            if event.get("claim_id") != packet.ident:
                errors.append(f"event claim_id mismatch: {event.get('_path')}")
            for key in ("actor", "role", "lineage", "at", "reason"):
                if not str(event.get(key, "")).strip():
                    errors.append(f"event has blank {key}: {event.get('_path')}")
            if previous_to is not None and event_from != previous_to:
                errors.append(f"broken event chain at {event.get('_path')}: {event_from} != {previous_to}")
            if event_to not in LEGAL_TRANSITIONS.get(event_from, set()):
                errors.append(f"illegal transition at {event.get('_path')}: {event_from} -> {event_to}")
            if event.get("statement_hash") != packet.statement_hash:
                errors.append(f"stale statement hash in event: {event.get('_path')}")
            if event.get("role") == "blind-breaker" and event_to in {"breaking", "certified"}:
                breaker_lineages.add(str(event.get("lineage", "")))
            if event.get("role") == "proof-checker" and event_to in {"breaking", "certified"}:
                checker_lineages.add(str(event.get("lineage", "")))
            previous_to = event_to
        if previous_to != status:
            errors.append(f"front-matter status {status!r} disagrees with last event {previous_to!r}")
        if int(packet.meta.get("cycle", "-1")) != len(events):
            errors.append("cycle must equal the validated event count")
    if status in {"proving", "breaking", "certified", "refuted", "known"}:
        for name in ("exact statement", "preservation ledger", "falsification"):
            if not substantive(packet.sections.get(name)):
                errors.append(f"status {status} requires substantive section: {name}")
    if status == "certified":
        if not CERTIFICATION_ENABLED:
            errors.append("certification is disabled until manifests and lineage are cryptographically validated")
        for name in ("evidence", "independent audit", "prior art"):
            if not substantive(packet.sections.get(name)):
                errors.append(f"certified packet lacks {name}")
        if packet.meta.get("breaker", "").lower() in PLACEHOLDERS:
            errors.append("certified packet requires a named independent breaker")
        if packet.meta.get("load_bearing") != "true":
            errors.append("certified packet must explicitly set load_bearing: true")
        evidence = sorted((ROOT / "collab" / "discovery" / "manifests" / "evidence").glob(packet.ident + "-*.json"))
        prior_art = ROOT / "collab" / "discovery" / "manifests" / "prior-art" / (packet.ident + ".json")
        if not evidence:
            errors.append("certified packet requires at least one evidence manifest")
        if not prior_art.exists():
            errors.append("certified packet requires a prior-art manifest")
        lineages = breaker_lineages | checker_lineages
        if not breaker_lineages or not checker_lineages or len(lineages) < 2:
            errors.append("certified packet requires blind-breaker and proof-checker events from distinct lineages")
    if status == "refuted" and "refut" not in packet.sections.get("evidence", "").lower() \
            and "counterexample" not in packet.sections.get("evidence", "").lower():
        errors.append("refuted packet must record a refutation or counterexample in Evidence")
    if status == "known" and not substantive(packet.sections.get("prior art")):
        errors.append("known packet requires a checked prior-art identification")
    if packet.meta.get("load_bearing") == "true" and status != "certified":
        errors.append("noncertified packets may not declare themselves load-bearing")
    return errors


def role_candidates(items: list[Packet], role: str) -> list[Packet]:
    routes = {
        "builder": {"seed", "formalizing", "proving"},
        "breaker": {"proving", "breaking", "certified"},
        "transporter": {"seed", "formalizing", "certified", "known"},
        "librarian": {"formalizing", "proving", "certified", "known"},
    }
    statuses = routes[role]
    selected = [p for p in items if not validate(p)
                and p.meta.get("status") in statuses
                and int(p.meta.get("cycle", "0")) < int(p.meta.get("max_cycles", "1"))]
    order = {"breaking": 0, "proving": 1, "formalizing": 2, "seed": 3,
             "certified": 4, "known": 5}
    return sorted(selected, key=lambda p: (
        p.meta.get("load_bearing") != "true",
        order.get(p.meta.get("status", ""), 99),
        p.ident,
    ))


def prompt(packet: Packet, role: str) -> str:
    core = (
        f"Work packet {packet.ident}: {packet.meta.get('title', '')}.\n"
        f"Current status: {packet.meta.get('status', '')}. "
        f"Declared certificate: {packet.meta.get('certificate', '')}.\n"
        "Read the entire packet and every referenced source before acting. "
        "Preserve the packet's exact quantifiers and preservation ledger. "
    )
    instructions = {
        "builder": (
            "Minimize the statement to the strongest version actually supported; prove it "
            "or reduce it to named lemmas. Attack your own proof before changing status. "
            "Do not call computation exact unless every load-bearing operation is exact."
        ),
        "breaker": (
            "Assume the claim is false. Check definitions, degenerate and boundary cases, "
            "hidden regularity assumptions, sign/normalization conventions, finite-search "
            "completeness, and the stated certificate type. Re-derive or re-implement by an "
            "independent method. A refutation is the preferred successful outcome."
        ),
        "transporter": (
            "Find a genuinely solved isomorph. Express both problems over a common object, "
            "type every map, and diff the proof dependency DAGs. Emit the smallest missing "
            "structure as a new exact statement; analogies may generate packets but not claims."
        ),
        "librarian": (
            "Search primary literature for the exact statement and each load-bearing lemma. "
            "Separate classical machinery from the repo-specific specialization. If known, "
            "change the status to known and preserve the useful proof transport."
        ),
    }
    return core + instructions[role] + f"\nPacket: {packet.path.relative_to(ROOT)}"


def command_validate(args: argparse.Namespace) -> int:
    chosen = [parse_packet(Path(args.path))] if args.path else packets()
    failures = 0
    for packet in chosen:
        errors = validate(packet)
        if errors:
            failures += 1
            print(f"FAIL {packet.ident} ({packet.path.relative_to(ROOT)})")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"PASS {packet.ident} [{packet.meta['status']}; {packet.meta['certificate']}]")
    return int(bool(failures))


def command_list(_: argparse.Namespace) -> int:
    for packet in packets():
        marker = "!" if validate(packet) else " "
        print(f"{marker} {packet.ident:6} {packet.meta.get('status', '?'):11} "
              f"{packet.meta.get('kind', '?'):11} {packet.meta.get('title', '')}")
    return 0


def command_next(args: argparse.Namespace) -> int:
    chosen = role_candidates(packets(), args.role)
    if not chosen:
        print(f"No packet currently routed to role {args.role}.")
        return 1
    packet = chosen[0]
    print(prompt(packet, args.role))
    return 0


def command_prompt(args: argparse.Namespace) -> int:
    index = {packet.ident: packet for packet in packets()}
    if args.ident not in index:
        print(f"Unknown packet: {args.ident}", file=sys.stderr)
        return 2
    print(prompt(index[args.ident], args.role))
    return 0


def replace_front_value(text: str, key: str, value: str) -> str:
    pattern = re.compile(rf"(?m)^({re.escape(key)}:)\s*.*$")
    if not pattern.search(text):
        raise ValueError(f"front matter lacks {key}")
    return pattern.sub(rf"\1 {value}", text, count=1)


def command_transition(args: argparse.Namespace) -> int:
    index = {packet.ident: packet for packet in packets()}
    if args.ident not in index:
        print(f"Unknown packet: {args.ident}", file=sys.stderr)
        return 2
    packet = index[args.ident]
    current_errors = validate(packet)
    if current_errors:
        print("Current packet is invalid; transition refused:", file=sys.stderr)
        for error in current_errors:
            print(f"  - {error}", file=sys.stderr)
        return 2
    current = packet.meta.get("status", "")
    if args.to not in LEGAL_TRANSITIONS.get(current, set()):
        print(f"Illegal transition: {current} -> {args.to}", file=sys.stderr)
        return 2
    cycle = int(packet.meta["cycle"])
    max_cycles = int(packet.meta["max_cycles"])
    if args.to in ACTIVE and cycle + 1 >= max_cycles:
        print("Cycle budget exhausted; use inconclusive or a terminal state.", file=sys.stderr)
        return 2
    if args.to in {"certified", "refuted", "known"} and not CERTIFICATION_ENABLED:
        print(f"Transition to {args.to} is disabled until certificate manifests are fully validated.", file=sys.stderr)
        return 2
    if not all(value.strip() for value in (args.actor, args.role, args.lineage, args.reason)):
        print("actor, role, lineage, and reason must be nonblank", file=sys.stderr)
        return 2
    if args.to == "certified":
        evidence = sorted((ROOT / "collab" / "discovery" / "manifests" / "evidence").glob(packet.ident + "-*.json"))
        prior_art = ROOT / "collab" / "discovery" / "manifests" / "prior-art" / (packet.ident + ".json")
        roles = {(event.get("role"), event.get("lineage")) for event in packet.events()}
        roles.add((args.role, args.lineage))
        breakers = {lineage for role, lineage in roles if role == "blind-breaker"}
        checkers = {lineage for role, lineage in roles if role == "proof-checker"}
        if not evidence or not prior_art.exists() or not breakers or not checkers \
                or len(breakers | checkers) < 2:
            print("Certification gate failed: manifests and two independent review lineages required.", file=sys.stderr)
            return 2
    now = datetime.now(timezone.utc).replace(microsecond=0)
    stamp = now.strftime("%Y%m%dT%H%M%SZ")
    event_dir = packet.event_dir
    event_dir.mkdir(parents=True, exist_ok=True)
    event_path = event_dir / f"{stamp}-{args.role}.json"
    if event_path.exists():
        print(f"Refusing to overwrite event: {event_path}", file=sys.stderr)
        return 2
    event = {
        "claim_id": packet.ident,
        "from": current,
        "to": args.to,
        "actor": args.actor,
        "role": args.role,
        "lineage": args.lineage,
        "at": now.isoformat().replace("+00:00", "Z"),
        "statement_hash": packet.statement_hash,
        "reason": args.reason,
        "artifacts": args.artifact,
    }
    event_path.write_text(json.dumps(event, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    text = packet.path.read_text(encoding="utf-8")
    text = replace_front_value(text, "status", args.to)
    text = replace_front_value(text, "cycle", str(cycle + 1))
    text = replace_front_value(text, "updated", now.date().isoformat())
    packet.path.write_text(text, encoding="utf-8")
    print(f"Recorded {packet.ident}: {current} -> {args.to}")
    print(event_path.relative_to(ROOT))
    return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    sub = result.add_subparsers(dest="command", required=True)
    check = sub.add_parser("validate")
    check.add_argument("path", nargs="?")
    check.set_defaults(func=command_validate)
    listing = sub.add_parser("list")
    listing.set_defaults(func=command_list)
    for name, function in (("next", command_next), ("prompt", command_prompt)):
        item = sub.add_parser(name)
        if name == "prompt":
            item.add_argument("ident")
        item.add_argument("--role", required=True,
                          choices=("builder", "breaker", "transporter", "librarian"))
        item.set_defaults(func=function)
    transition = sub.add_parser("transition")
    transition.add_argument("ident")
    transition.add_argument("--to", required=True, choices=sorted(STATUSES))
    transition.add_argument("--actor", required=True)
    transition.add_argument("--role", required=True,
                            choices=("builder", "blind-breaker", "proof-checker", "transporter", "librarian"))
    transition.add_argument("--lineage", required=True,
                            help="model/session/context lineage, not merely a role name")
    transition.add_argument("--reason", required=True)
    transition.add_argument("--artifact", action="append", default=[])
    transition.set_defaults(func=command_transition)
    return result


def main() -> int:
    args = parser().parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
