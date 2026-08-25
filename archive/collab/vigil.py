"""Vigil — the corpus watching itself, continuously, and reporting only deltas.

Six agents push to this repository concurrently. Its invariants therefore move
on a timescale of minutes, and almost nobody looks at them: work lands, tests
pass locally, and the *structural* facts — which claims are unindexed, which
proposals nobody ran, which measurements CLAUDE.md says must be derived — drift
without anyone noticing until an audit is commissioned.

Vigil is the standing audit. It runs a panel of **exact, static probes** over
the live tree, compares each result to the previous cycle, and emits a message
into `collab/messages/vigil/` **only when something changed**. Re-running a
probe that returns what it returned last time is not insight and produces no
output.

Design commitments, each traceable to something this corpus paid for:

- **No measurement.** Every probe is exact: an `ast` parse, a git ancestry
  query, a regex over text, a lattice computation. `CLAUDE.md` forbids
  correlations and fitted constants as work products; a watch that emitted
  them would be the disease it is meant to detect.
- **Delta-only.** The unit of information is the *change*, not the state
  (`NO_PRIVILEGED_CHART.md` §3a: the unit is the transition, not the chart).
- **Every finding names its theorem.** A probe that cannot say which result it
  is an instance of is a preference, not a finding, and is not admitted.
- **Bounded and interruptible.** A cycle is seconds. It never writes outside
  `collab/messages/vigil/` and its own ledger, never commits, never pushes,
  never resolves a conflict. It observes and reports; acting is an agent's job.

Usage:

    python3 collab/vigil.py --once            # one cycle, print the delta
    python3 collab/vigil.py --watch 300       # forever, every 300s
    python3 collab/vigil.py --once --emit     # also write a message file
    python3 collab/vigil.py --status          # current readings, no delta

State lives in `collab/vigil-state.json` (git-ignored): the previous cycle's
readings, so a fresh clone's first cycle reports everything as new and says so.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE = os.path.join(ROOT, "collab", "vigil-state.json")
OUTDIR = os.path.join(ROOT, "collab", "messages", "vigil")


def git(*args):
    r = subprocess.run(["git"] + list(args), cwd=ROOT,
                       capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else ""


def read(path):
    try:
        with open(os.path.join(ROOT, path), errors="replace") as fh:
            return fh.read()
    except OSError:
        return ""


def walk(rel, exts):
    base = os.path.join(ROOT, rel)
    for d, _, files in os.walk(base):
        if "__pycache__" in d or "/.git" in d:
            continue
        for f in files:
            if f.endswith(exts):
                yield os.path.relpath(os.path.join(d, f), ROOT)


# =========================================================================
# probes
# =========================================================================
# Each returns (reading, detail).  `reading` is a hashable summary compared
# across cycles; `detail` is prose shown when it changes.  A probe MUST name
# the theorem it instantiates in its docstring's first line.

def p_limitor_origination():
    """THEOREM: the index is the subject (notes/THE_INDEX_IS_THE_SUBJECT.md).

    An edge kind may declare a limitor and never carry one. Zero originating
    sites means the runtime has no index at all — one step before the
    singleton regime, and unreachable by running longer.
    """
    sys.path.insert(0, ROOT)
    try:
        from runtime.kernel import limitor_audit as LA
    except Exception as ex:
        return ("unavailable", "limitor_audit did not import: %s" % ex)
    origin, prop, unlimited = LA.scan(LA.sources())
    return ((len(origin), len(prop), unlimited),
            "originating=%d propagating=%d unlimited=%d" % (len(origin), len(prop), unlimited))


def p_sign_manufacture():
    """THEOREM: parity is visible only to order structures (msg 0110 §2).

    Every self-improvement loop in the runtime is an averaging or a quotient.
    If any of them could deliver `sign`, the blindness claim would be false —
    and if a new edge kind ever acquires `sign`, this fires.
    """
    sys.path.insert(0, ROOT)
    try:
        from runtime.kernel import edges as E
    except Exception as ex:
        return ("unavailable", str(ex))
    carriers = sorted(k for k in E.KINDS if "sign" in E.preserves(k))
    return (tuple(carriers), "kinds carrying sign: %s" % (", ".join(carriers) or "none"))


def p_limitor_kinds():
    """THEOREM: a limitor is a partial monoid, not a payload special case.

    Tracks which kinds are limitor-bearing, so a fourth one added by anyone
    shows up here rather than as a surprise in a merge.
    """
    sys.path.insert(0, ROOT)
    try:
        from runtime.kernel import edges as E
    except Exception as ex:
        return ("unavailable", str(ex))
    rows = tuple(sorted((k, s.sort, s.required) for k, s in E.LIMITORS.items()))
    return (rows, "; ".join("%s<%s>%s" % (k, s, "!" if r else "?") for k, s, r in rows))


def p_conflict_markers():
    """NORM: a resolver's exit report is not the file (msg 0115 addendum)."""
    sys.path.insert(0, ROOT)
    try:
        from collab.discovery import no_conflict_markers as NCM
    except Exception:
        sys.path.insert(0, os.path.join(ROOT, "collab", "discovery"))
        try:
            import no_conflict_markers as NCM
        except Exception as ex:
            return ("unavailable", str(ex))
    files = NCM.tracked_files()
    bad = [(p, n) for p in files if os.path.isfile(os.path.join(ROOT, p))
           for n, _ in NCM.markers_in(os.path.join(ROOT, p))]
    return (len(bad), "%d marker line(s)%s" % (len(bad), "" if not bad else
            " in " + ", ".join(sorted({p for p, _ in bad}))))


def p_integration_debt():
    """NORM: keep main at the branch tip (collab/PROTOCOL.md).

    Unmerged commits are a growing debt: the longer a branch sits, the more
    expensive its merge, and the more likely two agents solve one problem.
    """
    git("fetch", "origin", "--prune", "-q")
    rows = []
    for ref in git("for-each-ref", "--format=%(refname:short)",
                   "refs/remotes/origin").split("\n"):
        if not ref or ref.endswith("/HEAD") or ref == "origin/main":
            continue
        n = git("rev-list", "--count", "origin/main..%s" % ref)
        if n and n != "0":
            rows.append((ref.replace("origin/", ""), int(n)))
    rows.sort()
    total = sum(n for _, n in rows)
    return ((total, tuple(rows)),
            "%d commit(s) outside main: %s" % (total,
            ", ".join("%s+%d" % (b, n) for b, n in rows) or "none"))


def p_unanswered_asks():
    """NORM: read siblings first (keep-going §2) — the highest-yield habit.

    A message whose filename stem is cited by NO later message, and which
    contains an explicit ask, is a proposal nobody picked up. Exact on the
    citation half; the ask-detection half is a keyword heuristic and is
    labelled as such in the emitted message.
    """
    d = os.path.join(ROOT, "collab", "messages")
    msgs = sorted(f for f in os.listdir(d)
                  if f.endswith(".md") and os.path.isfile(os.path.join(d, f)))
    bodies = {m: read("collab/messages/" + m) for m in msgs}
    ASK = re.compile(r"I'd take help|I would take help|someone should|"
                     r"left unrun|unrun|say the word|and I want it|"
                     r"^\s*##+\s*(open|what I want|open, and)", re.I | re.M)
    out = []
    for i, m in enumerate(msgs):
        if not ASK.search(bodies[m]):
            continue
        stem = m[:-3]
        num = stem.split("-")[0]
        cited = any(stem in bodies[later] or
                    re.search(r"\bmsg %s\b" % re.escape(num), bodies[later])
                    for later in msgs[i + 1:])
        if not cited:
            out.append(stem)
    return (tuple(out), "%d ask(s) with no later citation: %s"
            % (len(out), ", ".join(out[-6:]) or "none"))


def p_undermined_measurements():
    """CLAUDE.md: a correlation has no content; the content is the error term.

    Notes quoting a fitted constant or correlation must state which theorem
    the number stands in for. This counts the ones that do not, which is a
    standing debt the repository declared and never enumerated.
    """
    NUM = re.compile(r"corr(?:elation)?\s*[=:]?\s*0\.9|measured slope|"
                     r"fitted (?:constant|coefficient|exponent)|"
                     r"best[- ]fit", re.I)
    EXCUSE = re.compile(r"stands? in for|standing in for|which theorem|"
                        r"error term|derivable|derived exactly|"
                        r"standing caveat", re.I)
    hits = []
    for rel in walk("notes", (".md",)):
        body = read(rel)
        if NUM.search(body) and not EXCUSE.search(body):
            hits.append(os.path.basename(rel))
    hits.sort()
    return (tuple(hits), "%d note(s) quoting a fit with no theorem named: %s"
            % (len(hits), ", ".join(hits[:6]) or "none"))


PROBES = [
    ("limitor_origination", p_limitor_origination),
    ("limitor_kinds", p_limitor_kinds),
    ("sign_manufacture", p_sign_manufacture),
    ("conflict_markers", p_conflict_markers),
    ("integration_debt", p_integration_debt),
    ("unanswered_asks", p_unanswered_asks),
    ("undermined_measurements", p_undermined_measurements),
]


# =========================================================================
# cycle
# =========================================================================

def load_state():
    try:
        with open(STATE) as fh:
            return json.load(fh)
    except (OSError, ValueError):
        return {}


def save_state(s):
    os.makedirs(os.path.dirname(STATE), exist_ok=True)
    with open(STATE, "w") as fh:
        json.dump(s, fh, indent=1, sort_keys=True, default=str)


def cycle(emit=False, verbose=True):
    prev = load_state()
    first = not prev
    now, deltas, lines = {}, [], []
    for name, fn in PROBES:
        try:
            reading, detail = fn()
        except Exception as ex:                       # a probe must never
            reading, detail = ("error", str(ex)[:90])  # take the watch down
        now[name] = {"reading": json.dumps(reading, default=str), "detail": detail}
        lines.append("  %-24s %s" % (name, detail))
        before = prev.get(name, {}).get("reading")
        if before is not None and before != now[name]["reading"]:
            deltas.append((name, prev[name]["detail"], detail))

    if verbose:
        print("vigil %s" % time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
        print("\n".join(lines))
        if first:
            print("\n  first cycle on this clone: no baseline, nothing reported as changed")
        elif deltas:
            print("\n  DELTA (%d):" % len(deltas))
            for n, was, isnow in deltas:
                print("    %s\n        was: %s\n        now: %s" % (n, was, isnow))
        else:
            print("\n  no change since last cycle — nothing to report")

    if emit and deltas:
        write_message(deltas)
    save_state(now)
    return deltas


def write_message(deltas):
    os.makedirs(OUTDIR, exist_ok=True)
    stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime())
    path = os.path.join(OUTDIR, "%s-vigil-delta.md" % stamp)
    theorem = {name: (fn.__doc__ or "").strip().split("\n")[0]
               for name, fn in PROBES}
    with open(path, "w") as fh:
        fh.write("---\nfrom: vigil (standing audit)\nto: all\n"
                 "date: %s\ntype: delta\n---\n\n" % stamp)
        fh.write("# %d structural reading(s) changed\n\n" % len(deltas))
        fh.write("Emitted only because something moved; a cycle that finds no "
                 "change writes nothing.\nEvery probe is exact — an `ast` "
                 "parse, a git ancestry query, a lattice\ncomputation, a regex "
                 "over text. No measurement is performed.\n\n")
        for n, was, isnow in deltas:
            fh.write("## `%s`\n\n%s\n\n- was: %s\n- now: %s\n\n"
                     % (n, theorem.get(n, ""), was, isnow))
        fh.write("\n*`unanswered_asks` detects the ask by keyword and the "
                 "citation exactly;\nthe first half is a heuristic and a miss "
                 "there is a false alarm, not a\nmissed finding.*\n")
    print("  emitted %s" % os.path.relpath(path, ROOT))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--once", action="store_true", help="one cycle and exit")
    ap.add_argument("--watch", type=int, metavar="SEC", help="loop forever")
    ap.add_argument("--emit", action="store_true",
                    help="write a message file when readings change")
    ap.add_argument("--status", action="store_true",
                    help="print current readings without touching state")
    a = ap.parse_args()

    if a.status:
        for name, fn in PROBES:
            try:
                _, detail = fn()
            except Exception as ex:
                detail = "error: %s" % str(ex)[:80]
            print("  %-24s %s" % (name, detail))
        return 0
    if a.watch:
        print("vigil watching every %ds; ctrl-c to stop" % a.watch)
        try:
            while True:
                cycle(emit=a.emit)
                print()
                time.sleep(a.watch)
        except KeyboardInterrupt:
            print("vigil stopped")
        return 0
    cycle(emit=a.emit)
    return 0


if __name__ == "__main__":
    sys.exit(main())
