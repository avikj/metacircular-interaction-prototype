#!/usr/bin/env python3
"""Fail-closed git synchronization and append-only collaboration messages."""

from __future__ import annotations

import argparse
import os
import secrets
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path


class SyncError(RuntimeError):
    pass


def git(root: Path, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ("git", *args), cwd=root, text=True, capture_output=True, check=check
    )


def clean(root: Path) -> bool:
    return not git(root, "status", "--porcelain=v1", "--untracked-files=all").stdout


def safe_atom(value: str) -> str:
    if not value or value in {".", ".."} or any(c not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_" for c in value):
        raise SyncError(f"unsafe mailbox atom: {value!r}")
    return value


def append_message(root: Path, author: str, recipient: str, kind: str,
                   subject: str, body: str) -> Path:
    """Create a collision-resistant message without overwriting any byte."""
    author, recipient, kind = map(safe_atom, (author, recipient, kind))
    box = root / "collab" / "mailboxes" / author
    box.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    while True:
        path = box / f"{stamp}-{secrets.token_hex(6)}.md"
        try:
            fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o644)
            break
        except FileExistsError:
            continue
    payload = (
        "---\n"
        f"from: {author}\n"
        f"to: {recipient}\n"
        f"type: {kind}\n"
        f"date: {datetime.now(timezone.utc).isoformat()}\n"
        f"subject: {subject!r}\n"
        "---\n\n"
        f"{body.rstrip()}\n"
    )
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
        stream.write(payload)
        stream.flush()
        os.fsync(stream.fileno())
    return path.relative_to(root)


def emit_incident(root: Path, author: str, subject: str, body: str) -> Path:
    return append_message(root, author, "all", "sync-incident", subject, body)


def sync(root: Path, author: str, remote: str, branch: str) -> None:
    """Fetch always; rebase only clean; abort and record every conflict."""
    git(root, "fetch", "--prune", remote, branch)
    if not clean(root):
        status = git(root, "status", "--short").stdout
        path = emit_incident(root, author, "sync blocked by dirty tree",
                             "Fetch succeeded; rebase was not attempted.\n\n```\n" + status + "```")
        raise SyncError(f"dirty tree; incident written to {path}")
    result = git(root, "rebase", f"{remote}/{branch}", check=False)
    if result.returncode:
        conflicts = git(root, "diff", "--name-only", "--diff-filter=U", check=False).stdout
        git(root, "rebase", "--abort", check=False)
        path = emit_incident(
            root, author, "rebase conflict (aborted)",
            "The rebase was aborted; pre-rebase bytes were restored.\n\n"
            f"Conflicted paths:\n```\n{conflicts}```\n\nGit output:\n```\n{result.stderr}{result.stdout}```",
        )
        raise SyncError(f"rebase conflict; incident written to {path}")


def publish(root: Path, author: str, remote: str, branch: str,
            mirror_main: bool) -> None:
    """Publish already committed work; never infer a commit or stage files."""
    if not clean(root):
        raise SyncError("publish requires a clean, explicitly committed tree")
    sync(root, author, remote, branch)
    git(root, "push", remote, f"HEAD:{branch}")
    if mirror_main:
        git(root, "push", remote, f"HEAD:main")  # fast-forward by default


def cycle(root: Path, author: str, remote: str, branch: str,
          mirror_main: bool) -> None:
    sync(root, author, remote, branch)
    git(root, "push", remote, f"HEAD:{branch}")
    if mirror_main:
        git(root, "push", remote, "HEAD:main")


def heartbeat(root: Path, author: str, session: str, journal: str,
              state: str) -> Path:
    """Append a resume pointer; never launch, stop, or replace an agent."""
    safe_atom(session)
    journal_path = Path(journal)
    if journal_path.is_absolute() or ".." in journal_path.parts:
        raise SyncError("journal must be a repository-relative path")
    return append_message(
        root, author, "all", "heartbeat", f"session {session}",
        f"session_id: `{session}`\n\njournal: `{journal_path.as_posix()}`\n\nstate: {state}",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    sub = parser.add_subparsers(dest="command", required=True)
    msg = sub.add_parser("message")
    for flag in ("from", "to", "type", "subject"):
        msg.add_argument(f"--{flag}", required=True)
    msg.add_argument("--body-file", type=Path, required=True)
    beat = sub.add_parser("heartbeat")
    beat.add_argument("--author", required=True)
    beat.add_argument("--session", required=True)
    beat.add_argument("--journal", required=True)
    beat.add_argument("--state", required=True)
    for name in ("sync", "cycle", "publish"):
        p = sub.add_parser(name)
        p.add_argument("--author", required=True)
        p.add_argument("--remote", default="origin")
        p.add_argument("--branch", required=True)
        if name in {"cycle", "publish"}:
            p.add_argument("--mirror-main", action="store_true")
    loop = sub.add_parser("loop")
    loop.add_argument("--author", required=True)
    loop.add_argument("--remote", default="origin")
    loop.add_argument("--branch", required=True)
    loop.add_argument("--interval", type=int, default=30)
    loop.add_argument("--mirror-main", action="store_true")
    args = parser.parse_args()
    root = args.repo.resolve()
    try:
        if args.command == "message":
            body = args.body_file.read_text(encoding="utf-8")
            print(append_message(root, getattr(args, "from"), args.to, args.type, args.subject, body))
        elif args.command == "heartbeat":
            print(heartbeat(root, args.author, args.session, args.journal, args.state))
        elif args.command == "sync":
            sync(root, args.author, args.remote, args.branch)
        elif args.command == "cycle":
            cycle(root, args.author, args.remote, args.branch, args.mirror_main)
        elif args.command == "publish":
            publish(root, args.author, args.remote, args.branch, args.mirror_main)
        else:
            if args.interval < 5:
                raise SyncError("interval must be at least 5 seconds")
            while True:
                try:
                    cycle(root, args.author, args.remote, args.branch, args.mirror_main)
                except SyncError as exc:
                    print(f"BLOCKED: {exc}", flush=True)
                time.sleep(args.interval)
    except (SyncError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}")
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
