#!/usr/bin/env python3
"""Compile and query the repository's authoritative research state.

``natural`` is deliberately a read-only projection, not a second database.
Claim packets, append-only events, source files, messages, journals, and Git
remain authoritative.  The runtime makes their current graph deterministic,
queryable, content-addressed, and continuously resumable.

Examples:

    python3 code/natural.py summary
    python3 code/natural.py show R0021
    python3 code/natural.py impact R0005
    python3 code/natural.py frontier --json
    python3 code/natural.py resume --agent codex
    python3 code/natural.py validate
    python3 code/natural.py snapshot --output /tmp/research-graph.json
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict, deque
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from typing import Any, Iterable

import discovery_loop


ROOT = Path(__file__).resolve().parents[1]
SCHEMA_VERSION = "natural-research-graph-v1"
ACTIVE = discovery_loop.ACTIVE
TERMINAL_RISK = {"refuted", "quarantined", "superseded", "inconclusive"}
CLAIM_ID = re.compile(r"R\d{4}")


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def canonical_bytes(value: Any) -> bytes:
    return (json.dumps(value, sort_keys=True, separators=(",", ":"),
                       ensure_ascii=False) + "\n").encode("utf-8")


def relative(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def file_record(path_text: str) -> dict[str, Any]:
    candidate = Path(path_text)
    if candidate.is_absolute():
        return {"path": path_text, "exists": False, "sha256": None,
                "bytes": None, "unsafe": True}
    path = (ROOT / candidate).resolve()
    if not path.is_relative_to(ROOT.resolve()):
        return {"path": path_text, "exists": False, "sha256": None,
                "bytes": None, "unsafe": True}
    if not path.is_file():
        return {"path": path_text, "exists": False, "sha256": None,
                "bytes": None, "unsafe": False}
    data = path.read_bytes()
    return {
        "path": path_text,
        "exists": True,
        "sha256": sha256_bytes(data),
        "bytes": len(data),
        "unsafe": False,
    }


def parse_front_matter(path: Path) -> tuple[dict[str, str], str]:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return {}, text
    try:
        _, front, body = text.split("---\n", 2)
    except ValueError:
        return {}, text
    metadata: dict[str, str] = {}
    for line in front.splitlines():
        if ":" not in line or line.lstrip().startswith("#"):
            continue
        key, value = line.split(":", 1)
        metadata[key.strip().lower()] = value.strip()
    return metadata, body


def first_heading(body: str) -> str:
    match = re.search(r"(?m)^#\s+(.+?)\s*$", body)
    return match.group(1) if match else ""


def latest_journal_entry(path: Path) -> dict[str, Any] | None:
    text = path.read_text(encoding="utf-8")
    matches = list(re.finditer(r"(?m)^##\s+(.+?)\s*$", text))
    if not matches:
        return None
    match = matches[-1]
    body = text[match.end():].strip()
    return {
        "path": relative(path),
        "heading": match.group(1),
        "body": body,
        "sha256": sha256_bytes((match.group(1) + "\n" + body).encode("utf-8")),
    }


def latest_messages(limit: int = 12) -> list[dict[str, Any]]:
    if limit < 0:
        raise ValueError("message limit must be nonnegative")
    paths = sorted((ROOT / "collab" / "messages").glob("*.md"))
    paths = paths[-limit:] if limit else []
    result = []
    for path in reversed(paths):
        metadata, body = parse_front_matter(path)
        result.append({
            "path": relative(path),
            "title": first_heading(body),
            "from": metadata.get("from", ""),
            "date": metadata.get("date", ""),
            "type": metadata.get("type", ""),
            "re": metadata.get("re", ""),
            "sha256": sha256_bytes(path.read_bytes()),
        })
    return result


def directed_cycle(nodes: Iterable[str], adjacency: dict[str, list[str]]) -> list[str] | None:
    color: dict[str, int] = {node: 0 for node in nodes}
    stack: list[str] = []

    def visit(node: str) -> list[str] | None:
        color[node] = 1
        stack.append(node)
        for neighbor in adjacency.get(node, []):
            if color.get(neighbor, 0) == 0:
                found = visit(neighbor)
                if found:
                    return found
            elif color.get(neighbor) == 1:
                index = stack.index(neighbor)
                return stack[index:] + [neighbor]
        stack.pop()
        color[node] = 2
        return None

    for node in sorted(color):
        if color[node] == 0:
            found = visit(node)
            if found:
                return found
    return None


@dataclass(frozen=True)
class ResearchGraph:
    snapshot: dict[str, Any]

    @property
    def claims(self) -> dict[str, dict[str, Any]]:
        return self.snapshot["claims"]

    @property
    def issues(self) -> list[dict[str, str]]:
        return self.snapshot["issues"]

    def claim(self, ident: str) -> dict[str, Any]:
        try:
            return self.claims[ident]
        except KeyError as error:
            raise KeyError(f"unknown claim {ident}") from error

    def relation(self, relation: str) -> list[dict[str, str]]:
        return [edge for edge in self.snapshot["edges"]
                if edge["relation"] == relation]

    def impact(self, ident: str) -> dict[str, Any]:
        self.claim(ident)
        dependencies = defaultdict(list)
        dependents = defaultdict(list)
        supersedes = defaultdict(list)
        superseded_by = defaultdict(list)
        for edge in self.snapshot["edges"]:
            if edge["relation"] == "depends_on":
                dependencies[edge["from"]].append(edge["to"])
                dependents[edge["to"]].append(edge["from"])
            elif edge["relation"] == "supersedes":
                supersedes[edge["from"]].append(edge["to"])
                superseded_by[edge["to"]].append(edge["from"])

        def closure(start: str, adjacency: dict[str, list[str]]) -> list[str]:
            seen: set[str] = set()
            queue = deque(adjacency.get(start, []))
            while queue:
                item = queue.popleft()
                if item in seen:
                    continue
                seen.add(item)
                queue.extend(adjacency.get(item, []))
            return sorted(seen)

        return {
            "claim": ident,
            "direct_dependencies": sorted(dependencies[ident]),
            "transitive_dependencies": closure(ident, dependencies),
            "direct_dependents": sorted(dependents[ident]),
            "transitive_dependents": closure(ident, dependents),
            "supersedes": sorted(supersedes[ident]),
            "superseded_by": sorted(superseded_by[ident]),
            "artifacts": self.claim(ident)["artifacts"],
        }


def build_graph(message_limit: int = 12) -> ResearchGraph:
    parsed = discovery_loop.packets()
    known = {packet.ident for packet in parsed}
    claims: dict[str, dict[str, Any]] = {}
    edges: list[dict[str, str]] = []
    artifact_claims: dict[str, set[str]] = defaultdict(set)
    artifact_relations: dict[str, set[str]] = defaultdict(set)
    issues: list[dict[str, str]] = []
    dependency_adjacency: dict[str, list[str]] = defaultdict(list)

    for packet in parsed:
        for error in discovery_loop.validate(packet):
            issues.append({
                "severity": "error",
                "code": "packet-invalid",
                "claim": packet.ident,
                "detail": error,
            })

        dependencies = sorted({
            item.strip() for item in packet.meta.get("dependencies", "").split(",")
            if item.strip() and item.strip().lower() != "none"
        })
        supersedes = sorted(set(CLAIM_ID.findall(packet.meta.get("supersedes", ""))))
        events = []
        artifacts: set[str] = set()
        for event in packet.events():
            cleaned = {key: value for key, value in event.items() if key != "_path"}
            cleaned["path"] = event["_path"]
            events.append(cleaned)
            for artifact in event.get("artifacts", []):
                if not isinstance(artifact, str):
                    continue
                artifacts.add(artifact)
                artifact_claims[artifact].add(packet.ident)
                artifact_relations[artifact].add("event_artifact")

        source = packet.meta.get("source", "")
        if source:
            artifacts.add(source)
            artifact_claims[source].add(packet.ident)
            artifact_relations[source].add("source")

        for dependency in dependencies:
            edges.append({"from": packet.ident, "to": dependency,
                          "relation": "depends_on"})
            dependency_adjacency[packet.ident].append(dependency)
            if dependency in known and claims.get(dependency, {}).get("status") in TERMINAL_RISK:
                # A second pass below handles forward IDs as well.
                pass
        for target in supersedes:
            edges.append({"from": packet.ident, "to": target,
                          "relation": "supersedes"})

        claims[packet.ident] = {
            "id": packet.ident,
            "title": packet.meta.get("title", ""),
            "status": packet.meta.get("status", ""),
            "kind": packet.meta.get("kind", ""),
            "certificate": packet.meta.get("certificate", ""),
            "load_bearing": packet.meta.get("load_bearing", ""),
            "novelty": packet.meta.get("novelty", ""),
            "generator": packet.meta.get("generator", ""),
            "owner": packet.meta.get("owner", ""),
            "breaker": packet.meta.get("breaker", ""),
            "source": source,
            "dependencies": dependencies,
            "supersedes": supersedes,
            "supersedes_raw": packet.meta.get("supersedes", ""),
            "statement_hash": packet.meta.get("statement_hash", ""),
            "cycle": int(packet.meta.get("cycle", "0")),
            "max_cycles": int(packet.meta.get("max_cycles", "0")),
            "updated": packet.meta.get("updated", ""),
            "packet_path": relative(packet.path),
            "packet_sha256": sha256_bytes(packet.path.read_bytes()),
            "exact_statement": packet.sections.get("exact statement", ""),
            "proof_obligations": packet.sections.get("proof obligations", ""),
            "falsification": packet.sections.get("falsification", ""),
            "evidence": packet.sections.get("evidence", ""),
            "independent_audit": packet.sections.get("independent audit", ""),
            "successor_seeds": packet.sections.get("successor seeds", ""),
            "events": events,
            "artifacts": sorted(artifacts),
        }

    artifact_records: dict[str, dict[str, Any]] = {}
    for path_text in sorted(artifact_claims):
        record = file_record(path_text)
        record["claims"] = sorted(artifact_claims[path_text])
        record["relations"] = sorted(artifact_relations[path_text])
        artifact_records[path_text] = record
        if record["unsafe"]:
            issues.append({
                "severity": "error",
                "code": "unsafe-artifact-path",
                "claim": ",".join(record["claims"]),
                "detail": path_text,
            })
        elif not record["exists"]:
            severity = "error" if "source" in record["relations"] else "warning"
            issues.append({
                "severity": severity,
                "code": "missing-artifact",
                "claim": ",".join(record["claims"]),
                "detail": path_text,
            })

    for claim in claims.values():
        for dependency in claim["dependencies"]:
            if dependency not in claims:
                continue  # packet validation already reports this as an error
            status = claims[dependency]["status"]
            if claim["status"] in ACTIVE and status in TERMINAL_RISK:
                issues.append({
                    "severity": "warning",
                    "code": "active-depends-on-terminal",
                    "claim": claim["id"],
                    "detail": f"{dependency} is {status}",
                })
        for target in claim["supersedes"]:
            if target not in claims:
                issues.append({
                    "severity": "error",
                    "code": "unknown-supersedes-target",
                    "claim": claim["id"],
                    "detail": target,
                })

    cycle = directed_cycle(claims, dependency_adjacency)
    if cycle:
        issues.append({
            "severity": "error",
            "code": "dependency-cycle",
            "claim": cycle[0],
            "detail": " -> ".join(cycle),
        })

    journals = {}
    journal_dir = ROOT / "collab" / "journals"
    for path in sorted(journal_dir.glob("*.md")):
        if path.name == "README.md":
            continue
        entry = latest_journal_entry(path)
        if entry:
            journals[path.stem] = entry

    core = {
        "schema_version": SCHEMA_VERSION,
        "claims": {key: claims[key] for key in sorted(claims)},
        "edges": sorted(edges, key=lambda edge: (
            edge["relation"], edge["from"], edge["to"])),
        "artifacts": artifact_records,
        "coordination": {
            "latest_messages": latest_messages(message_limit),
            "journal_heads": journals,
        },
        "issues": sorted(issues, key=lambda issue: (
            issue["severity"], issue["code"], issue["claim"], issue["detail"])),
    }
    snapshot = dict(core)
    snapshot["graph_sha256"] = sha256_bytes(canonical_bytes(core))
    return ResearchGraph(snapshot)


def git_context() -> dict[str, Any]:
    def run(*args: str) -> str:
        completed = subprocess.run(
            ["git", *args], cwd=ROOT, check=True, text=True,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        )
        return completed.stdout.strip()

    return {
        "branch": run("branch", "--show-current"),
        "head": run("rev-parse", "HEAD"),
        "worktree": run("status", "--short"),
        "recent_commits": run("log", "-5", "--format=%h %s").splitlines(),
    }


def summary(graph: ResearchGraph) -> dict[str, Any]:
    counts = Counter(claim["status"] for claim in graph.claims.values())
    active = [
        {
            "id": claim["id"], "status": claim["status"],
            "title": claim["title"], "owner": claim["owner"],
            "cycle": f"{claim['cycle']}/{claim['max_cycles']}",
        }
        for claim in graph.claims.values() if claim["status"] in ACTIVE
    ]
    return {
        "schema_version": SCHEMA_VERSION,
        "graph_sha256": graph.snapshot["graph_sha256"],
        "claims": len(graph.claims),
        "status_counts": dict(sorted(counts.items())),
        "active": active,
        "issues": dict(sorted(Counter(
            issue["severity"] for issue in graph.issues).items())),
    }


def frontier(graph: ResearchGraph) -> dict[str, Any]:
    active = []
    breaker_queue = []
    for claim in graph.claims.values():
        if claim["status"] not in ACTIVE:
            continue
        active.append({
            "id": claim["id"],
            "title": claim["title"],
            "status": claim["status"],
            "owner": claim["owner"],
            "dependencies": claim["dependencies"],
            "proof_obligations": claim["proof_obligations"],
            "successor_seeds": claim["successor_seeds"],
        })
        breaker = claim["breaker"].lower()
        if "invited" in breaker or "open" in breaker:
            breaker_queue.append({
                "id": claim["id"], "status": claim["status"],
                "title": claim["title"], "breaker": claim["breaker"],
            })
    return {"active_claims": active, "open_breaker_queue": breaker_queue}


def resume(graph: ResearchGraph, agent: str) -> dict[str, Any]:
    needle = agent.casefold()
    owned = []
    reviews = []
    for claim in graph.claims.values():
        if claim["status"] not in ACTIVE:
            continue
        if needle in claim["owner"].casefold():
            owned.append({"id": claim["id"], "status": claim["status"],
                          "title": claim["title"], "source": claim["source"]})
        if needle in claim["breaker"].casefold():
            reviews.append({"id": claim["id"], "status": claim["status"],
                            "title": claim["title"], "breaker": claim["breaker"]})
    journal = graph.snapshot["coordination"]["journal_heads"].get(agent)
    return {
        "agent": agent,
        "git": git_context(),
        "journal_head": journal,
        "active_owned_claims": owned,
        "active_review_assignments": reviews,
        "latest_messages": graph.snapshot["coordination"]["latest_messages"][:8],
        "graph_issues": graph.issues,
        "graph_sha256": graph.snapshot["graph_sha256"],
    }


def emit_json(value: Any) -> None:
    print(json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False))


def print_summary(value: dict[str, Any]) -> None:
    print(f"natural {value['schema_version']} {value['graph_sha256']}")
    print(f"claims: {value['claims']}  statuses: " + ", ".join(
        f"{key}={count}" for key, count in value["status_counts"].items()))
    print("issues: " + (", ".join(
        f"{key}={count}" for key, count in value["issues"].items()) or "none"))
    print("active:")
    for claim in value["active"]:
        print(f"  {claim['id']} [{claim['status']} {claim['cycle']}] "
              f"{claim['title']} — {claim['owner']}")


def print_show(claim: dict[str, Any]) -> None:
    print(f"{claim['id']} [{claim['status']}] {claim['title']}")
    print(f"owner: {claim['owner']}")
    print(f"source: {claim['source']}")
    print(f"statement hash: {claim['statement_hash']}")
    print(f"dependencies: {', '.join(claim['dependencies']) or 'none'}")
    print(f"supersedes: {', '.join(claim['supersedes']) or 'none'}")
    for label, key in (
        ("EXACT STATEMENT", "exact_statement"),
        ("PROOF OBLIGATIONS", "proof_obligations"),
        ("FALSIFICATION", "falsification"),
        ("EVIDENCE", "evidence"),
        ("INDEPENDENT AUDIT", "independent_audit"),
        ("SUCCESSOR SEEDS", "successor_seeds"),
    ):
        print(f"\n{label}\n{claim[key]}")


def print_impact(value: dict[str, Any]) -> None:
    print(f"impact {value['claim']}")
    for key in (
        "direct_dependencies", "transitive_dependencies",
        "direct_dependents", "transitive_dependents",
        "supersedes", "superseded_by", "artifacts",
    ):
        print(f"  {key}: {', '.join(value[key]) or 'none'}")


def print_frontier(value: dict[str, Any]) -> None:
    print("active claims:")
    for claim in value["active_claims"]:
        print(f"  {claim['id']} [{claim['status']}] {claim['title']}")
        print(f"    owner: {claim['owner']}")
        print(f"    dependencies: {', '.join(claim['dependencies']) or 'none'}")
        obligations = " ".join(claim["proof_obligations"].split())
        print(f"    obligations: {obligations[:240]}" +
              ("…" if len(obligations) > 240 else ""))
    print("open breaker queue:")
    for claim in value["open_breaker_queue"]:
        print(f"  {claim['id']} [{claim['status']}] {claim['title']}")


def print_resume(value: dict[str, Any]) -> None:
    git = value["git"]
    print(f"resume {value['agent']} @ {git['branch']} {git['head'][:12]}")
    print("worktree: " + (git["worktree"] or "clean"))
    journal = value["journal_head"]
    if journal:
        print(f"\njournal: {journal['heading']}\n{journal['body']}")
    print("\nactive owned claims:")
    for claim in value["active_owned_claims"]:
        print(f"  {claim['id']} [{claim['status']}] {claim['title']}")
    print("active review assignments:")
    for claim in value["active_review_assignments"]:
        print(f"  {claim['id']} [{claim['status']}] {claim['title']}")
    print("latest messages:")
    for message in value["latest_messages"]:
        print(f"  {message['path']} — {message['title']}")
    if value["graph_issues"]:
        print("graph issues:")
        for issue in value["graph_issues"]:
            print(f"  {issue['severity'].upper()} {issue['code']} "
                  f"{issue['claim']}: {issue['detail']}")


def command(args: argparse.Namespace) -> int:
    graph = build_graph(message_limit=getattr(args, "message_limit", 12))
    if args.command == "summary":
        value = summary(graph)
        emit_json(value) if args.json else print_summary(value)
        return 0
    if args.command == "show":
        try:
            value = graph.claim(args.ident)
        except KeyError as error:
            print(str(error), file=sys.stderr)
            return 2
        emit_json(value) if args.json else print_show(value)
        return 0
    if args.command == "impact":
        try:
            value = graph.impact(args.ident)
        except KeyError as error:
            print(str(error), file=sys.stderr)
            return 2
        emit_json(value) if args.json else print_impact(value)
        return 0
    if args.command == "frontier":
        value = frontier(graph)
        emit_json(value) if args.json else print_frontier(value)
        return 0
    if args.command == "resume":
        value = resume(graph, args.agent)
        emit_json(value) if args.json else print_resume(value)
        return 0
    if args.command == "snapshot":
        data = json.dumps(graph.snapshot, indent=2, sort_keys=True,
                          ensure_ascii=False) + "\n"
        if args.output:
            output = Path(args.output).resolve()
            output.write_text(data, encoding="utf-8")
            print(f"wrote {output} {graph.snapshot['graph_sha256']}")
        else:
            print(data, end="")
        return 0
    if args.command == "validate":
        for issue in graph.issues:
            print(f"{issue['severity'].upper()} {issue['code']} "
                  f"{issue['claim']}: {issue['detail']}")
        errors = [issue for issue in graph.issues if issue["severity"] == "error"]
        warnings = [issue for issue in graph.issues if issue["severity"] == "warning"]
        print(f"natural graph {graph.snapshot['graph_sha256']}: "
              f"{len(errors)} error(s), {len(warnings)} warning(s)")
        if errors or (args.strict_artifacts and warnings):
            return 1
        return 0
    raise AssertionError(args.command)


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    sub = result.add_subparsers(dest="command", required=True)

    for name in ("summary", "frontier"):
        item = sub.add_parser(name)
        item.add_argument("--json", action="store_true")

    show = sub.add_parser("show")
    show.add_argument("ident")
    show.add_argument("--json", action="store_true")

    impact_parser = sub.add_parser("impact")
    impact_parser.add_argument("ident")
    impact_parser.add_argument("--json", action="store_true")

    resume_parser = sub.add_parser("resume")
    resume_parser.add_argument("--agent", default="codex")
    resume_parser.add_argument("--message-limit", type=int, default=12)
    resume_parser.add_argument("--json", action="store_true")

    snapshot_parser = sub.add_parser("snapshot")
    snapshot_parser.add_argument("--output")
    snapshot_parser.add_argument("--message-limit", type=int, default=12)

    validate_parser = sub.add_parser("validate")
    validate_parser.add_argument("--strict-artifacts", action="store_true")
    return result


if __name__ == "__main__":
    raise SystemExit(command(parser().parse_args()))
