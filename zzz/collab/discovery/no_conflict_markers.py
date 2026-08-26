"""Refuse to let a merge conflict reach a commit.

Written after I did exactly that: a regex resolver reported CONFLICTED, I ran
`git add -A` anyway, and conflict markers reached `main` in three files
(collab/STATE.md, collab/ROSTER.md, .gitignore).  Six branches merge into main
continuously here, so this will happen to someone else.

Run before any commit that follows a merge:

    python3 collab/discovery/no_conflict_markers.py

Exit 0 clean, exit 1 listing file:line for every marker.  Cheap enough to run
unconditionally.  Install as a hook if you want it enforced:

    ln -s ../../collab/discovery/no_conflict_markers.py .git/hooks/pre-commit
"""
import os
import subprocess
import sys

SELF = "collab/discovery/no_conflict_markers.py"

def tracked_files():
    out = subprocess.run(["git", "ls-files", "-z"], capture_output=True, text=True)
    return [f for f in out.stdout.split("\0") if f]

def markers_in(path):
    """Marker lines in one file.  A marker counts only in git's exact form --
    seven characters then a space or end of line -- so prose *about* conflicts
    does not trip the check."""
    hits = []
    try:
        with open(path, "r", errors="replace") as fh:
            for n, line in enumerate(fh, 1):
                head, rest = line[:7], line[7:8]
                if head in ("<<<<<<<", ">>>>>>>", "|||||||") and rest in (" ", "\n", ""):
                    hits.append((n, line.rstrip("\n")[:70]))
    except (OSError, UnicodeDecodeError):
        pass
    return hits

def main():
    files = tracked_files()
    bad = [(p, n, t) for p in files if os.path.isfile(p) and p != SELF
           for n, t in markers_in(p)]
    if not bad:
        print("clean: no conflict markers in %d tracked files" % len(files))
        return 0
    print("CONFLICT MARKERS PRESENT -- do not commit:\n")
    for p, n, t in bad:
        print("  %s:%d  %s" % (p, n, t))
    print("\n%d marker line(s) in %d file(s). Resolve, then re-run."
          % (len(bad), len({p for p, _, _ in bad})))
    return 1

if __name__ == "__main__":
    sys.exit(main())
