"""worktree_guard — refuse to let a session work in the shared checkout.

Human owner directive, 2026-08-13 (msg 0371): no two sessions may work in the
same checkout. This script is that norm made checkable, so it does not depend
on an agent having read a paragraph.

It answers three questions, all by exact Git queries — no heuristics, no
measurement (`CLAUDE.md`):

1. **Am I isolated?** The shared checkout is the worktree whose HEAD is the
   collaboration branch `claude/prime-pair-field-research-18tq7b` and which is
   the repository's primary worktree. A session whose cwd resolves there is
   sharing a tree with every other session and must stop.

2. **Is anyone's finished work stranded?** Untracked files in *any* worktree
   are one `git clean` from deletion and carry no history. The guard lists
   them so a session sees the risk it is standing in. It never touches them:
   PROTOCOL §5 forbids committing another identity's uncommitted files.

3. **Have I declared myself?** A worker branch with no `NOW.md` block and no
   journal is an identity nobody can route around.

Exit codes: 0 = OK to work, 1 = must not work here, 2 = usable but undeclared.

    python3 machinery/worktree_guard.py            # check cwd
    python3 machinery/worktree_guard.py --strict    # undeclared is also fatal
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys

SHARED_BRANCH = "claude/prime-pair-field-research-18tq7b"
WORKER_PREFIX = "worker/"


def git(*args: str) -> str:
    """Run a git command, returning stripped stdout ('' on failure)."""
    try:
        out = subprocess.run(
            ["git", *args], capture_output=True, text=True, check=False
        )
        return out.stdout.strip()
    except OSError:
        return ""


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--strict",
        action="store_true",
        help="treat an undeclared identity as fatal, not advisory",
    )
    args = ap.parse_args()

    toplevel = git("rev-parse", "--show-toplevel")
    if not toplevel:
        print("FAIL  not inside a Git repository")
        return 1

    branch = git("rev-parse", "--abbrev-ref", "HEAD")
    # The primary worktree is the first line of `git worktree list`.
    listing = git("worktree", "list", "--porcelain").splitlines()
    primary = ""
    for line in listing:
        if line.startswith("worktree "):
            primary = line[len("worktree ") :]
            break

    is_primary = os.path.realpath(toplevel) == os.path.realpath(primary)
    problems: list[str] = []

    if is_primary or branch == SHARED_BRANCH:
        print("FAIL  this is the SHARED checkout — do not work here.")
        print(f"      path   {toplevel}")
        print(f"      branch {branch}")
        print()
        print("      Take your own worktree first (AGENTS.md, PROTOCOL §5):")
        print()
        print("        git worktree add -b worker/<handle> \\")
        print("            ../avikj-math-readme-workers/<handle> \\")
        print(f"            {SHARED_BRANCH}")
        print("        cd ../avikj-math-readme-workers/<handle>")
        print()
        problems.append("shared")

    # Stranded work: untracked, non-ignored files anywhere in this tree.
    untracked = [
        line
        for line in git(
            "status", "--porcelain", "--untracked-files=all"
        ).splitlines()
        if line.startswith("??")
    ]
    if untracked:
        print(f"WARN  {len(untracked)} untracked file(s) in this tree —")
        print("      untracked work in a shared tree is work that does not exist.")
        for line in untracked[:20]:
            print(f"        {line[3:]}")
        if len(untracked) > 20:
            print(f"        ... and {len(untracked) - 20} more")
        print("      Commit YOUR OWN now. Never commit another identity's files")
        print("      (PROTOCOL §5) — message the author instead.")
        print()

    # Declaration: a worker branch should have a journal and a NOW.md block.
    if branch.startswith(WORKER_PREFIX):
        handle = branch[len(WORKER_PREFIX) :]
        candidates = {handle, handle.replace("_", "-")}
        journal = any(
            os.path.exists(os.path.join(toplevel, "collab", "journals", f"{h}.md"))
            for h in candidates
        )
        now_path = os.path.join(toplevel, "NOW.md")
        declared = False
        if os.path.exists(now_path):
            with open(now_path, encoding="utf-8") as fh:
                now_text = fh.read()
            declared = any(f"## {h} " in now_text for h in candidates)
        if not journal:
            print(f"WARN  no journal at collab/journals/{handle}.md — you have no")
            print("      memory anchor; a future instance of you starts blind.")
            problems.append("undeclared")
        if not declared:
            print(f"WARN  no NOW.md block for '{handle}' — nobody can see what you")
            print("      are carrying, so nobody can avoid duplicating it.")
            problems.append("undeclared")

    if "shared" in problems:
        return 1
    if "undeclared" in problems:
        if args.strict:
            return 1
        print("OK    isolated worktree (declaration incomplete — see WARN above)")
        return 2

    print(f"OK    isolated worktree: {toplevel}")
    print(f"      branch {branch}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
