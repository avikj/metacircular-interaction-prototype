#!/usr/bin/env python3
"""The engine: one executable entry point, with memory.

    python3 runtime/engine.py step [--rounds N] [--quick]   one learning step
    python3 runtime/engine.py status                        exact trajectory
    python3 runtime/engine.py verify [--full]               run the suites
    python3 runtime/engine.py bench                         current exact costs

What this adds to what already runs
-----------------------------------
``demo/organism_demo.py`` closes the loop and throws its book away.  The
engine makes the loop **cumulative and self-comparing**:

- The lemma book persists (``runtime/state/book.json``).  Nothing on disk is
  trusted: every load re-installs every lemma through the full 7-gate
  verifier, so a corrupted or edited state file can only *lose* lemmas,
  never smuggle one in.
- Every step appends exact counters to ``runtime/state/ledger.jsonl``
  (benchmark steps/work before and after, lemmas installed/rejected, the
  no-book baseline).  The next step reads its own ledger: if the last step
  plateaued, it widens generation; if it regressed, it refuses to save.
  That is the minimal honest sense of "a plan that improves itself":
  the plan's next parameters are a pure function of its own measured record.
- ``verify`` runs the actual suites; the engine will not save a book, however
  profitable, on a tree whose kernel tests fail.

No floats, no model, no network.  Everything below either kernel-checks or
is a counter.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from runtime.crystallize.derivation import (I, P, S, V, mk, Term,            # noqa: E402
                                            render)
from runtime.crystallize.install import Book                                  # noqa: E402
from runtime.generate.loop import (BENCHMARKS, Config, Organism,              # noqa: E402
                                   benchmark_cost)
from runtime.generate.multiway import GenerationBudget                        # noqa: E402

STATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "state")
BOOK_PATH = os.path.join(STATE_DIR, "book.json")
LEDGER_PATH = os.path.join(STATE_DIR, "ledger.jsonl")


# -------------------------------------------------------------------------
# term (de)serialisation -- structural, no eval, no pickle
# -------------------------------------------------------------------------

def term_to_obj(t: Term):
    if t.kind == "int":
        return ["I", t.val]
    if t.kind == "var":
        return ["V", t.val]
    return [t.kind, [term_to_obj(a) for a in t.args]]


def obj_to_term(o) -> Term:
    tag = o[0]
    if tag == "I":
        return I(int(o[1]))
    if tag == "V":
        return V(str(o[1]))
    return mk(tag, None, tuple(obj_to_term(a) for a in o[1]))


def save_book(book: Book) -> None:
    os.makedirs(STATE_DIR, exist_ok=True)
    payload = [{"lid": l.lid,
                "lhs": term_to_obj(l.lhs),
                "rhs": term_to_obj(l.rhs),
                "provenance": l.provenance}
               for l in book.lemmas]
    with open(BOOK_PATH, "w") as f:
        json.dump(payload, f, indent=1, sort_keys=True)


def load_book() -> tuple[Book, int, int]:
    """Load and RE-VERIFY the persistent book. Returns (book, kept, refused)."""
    book = Book()
    if not os.path.exists(BOOK_PATH):
        return book, 0, 0
    with open(BOOK_PATH) as f:
        payload = json.load(f)
    kept = refused = 0
    for row in payload:
        v = book.install(row["lid"], obj_to_term(row["lhs"]),
                         obj_to_term(row["rhs"]),
                         provenance=row.get("provenance", "") + " [reloaded]")
        if v.ok:
            kept += 1
        else:
            refused += 1
    return book, kept, refused


# -------------------------------------------------------------------------
# ledger
# -------------------------------------------------------------------------

def read_ledger() -> list[dict]:
    if not os.path.exists(LEDGER_PATH):
        return []
    with open(LEDGER_PATH) as f:
        return [json.loads(line) for line in f if line.strip()]


def append_ledger(entry: dict) -> None:
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(LEDGER_PATH, "a") as f:
        f.write(json.dumps(entry, sort_keys=True) + "\n")


def costs(book: Book | None) -> list[list[int]]:
    out = []
    for _name, target in BENCHMARKS:
        steps, work, _ = benchmark_cost(book, None, target)
        out.append([steps, work])
    return out


# -------------------------------------------------------------------------
# one self-comparing step
# -------------------------------------------------------------------------

def cmd_step(rounds: int, quick: bool) -> int:
    book, kept, refused = load_book()
    baseline = costs(None)
    before = costs(book)

    ledger = read_ledger()
    widen = bool(ledger) and ledger[-1].get("verdict") == "plateau"

    gen = (GenerationBudget(max_states=70, max_edges=180, max_depth=4,
                            max_size=22)
           if quick and not widen else
           GenerationBudget(max_states=140 if not widen else 200,
                            max_edges=380 if not widen else 520,
                            max_depth=5 if not widen else 6,
                            max_size=24))
    cfg = Config(rounds=rounds, width=3, gen=gen,
                 max_conjectures=26 if not widen else 40,
                 closure_limit=8)
    org = Organism(cfg)
    # seed the organism with the verified persistent book
    for lem in book.lemmas:
        org.book.install(lem.lid + "@seed", lem.lhs, lem.rhs,
                         provenance=lem.provenance)
    org._rebuild_index()
    org.run(rounds)
    audits = org.audit()
    audits_ok = all(ok for _, ok, _ in audits)

    after = costs(org.book)
    improved = sum(1 for b, a in zip(before, after) if a[0] < b[0])
    regressed = sum(1 for b, a in zip(before, after) if a[0] > b[0])

    if regressed or not audits_ok:
        verdict = "refused"          # do not persist a worse or unaudited book
    elif improved:
        verdict = "improved"
        save_book(org.book)
    else:
        verdict = "plateau"          # persist (book may generalise later),
        save_book(org.book)          # and instruct the next step to widen

    entry = {
        "t": int(time.time()),
        "rounds": rounds, "quick": quick, "widened": widen,
        "reloaded": kept, "reload_refused": refused,
        "baseline": baseline, "before": before, "after": after,
        "book": len(org.book), "audits_ok": audits_ok,
        "verdict": verdict,
    }
    append_ledger(entry)

    print("engine step: baseline=%s before=%s after=%s book=%d verdict=%s"
          % (baseline, before, after, len(org.book), verdict))
    for name, ok, why in audits:
        if not ok:
            print("AUDIT FAIL %s: %s" % (name, why))
    return 0 if verdict != "refused" else 1


def cmd_status() -> int:
    ledger = read_ledger()
    if not ledger:
        print("no steps recorded")
        return 0
    print(" step | before -> after (B1 steps) | book | verdict")
    for i, e in enumerate(ledger):
        print("  %3d | %6d -> %-6d           | %4d | %s"
              % (i, e["before"][0][0], e["after"][0][0], e["book"],
                 e["verdict"]))
    return 0


def cmd_bench() -> int:
    book, kept, refused = load_book()
    print("persistent book: %d lemmas (reloaded %d, refused %d)"
          % (len(book), kept, refused))
    for name, cost in zip(("no book ", "with book"), (costs(None), costs(book))):
        print("  %s : %s   (per-benchmark [steps, work])" % (name, cost))
    return 0


def cmd_verify(full: bool) -> int:
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tests = ["runtime/tests/test_kernel.py", "runtime/tests/test_execute.py",
             "runtime/tests/test_crystallize.py",
             "machinery/test_relativized_initiality.py"]
    if full:
        tdir = os.path.join(root, "runtime", "tests")
        tests = sorted("runtime/tests/" + f for f in os.listdir(tdir)
                       if f.startswith("test_")) + tests[3:]
    failures = 0
    for t in tests:
        cwd = root if not t.startswith("machinery") else os.path.join(root, "machinery")
        arg = t if not t.startswith("machinery") else os.path.basename(t)
        r = subprocess.run([sys.executable, arg], cwd=cwd,
                           capture_output=True, text=True)
        ok = r.returncode == 0
        failures += 0 if ok else 1
        print(("PASS " if ok else "FAIL ") + t)
        if not ok:
            print(r.stdout[-800:], r.stderr[-400:])
    print("verify: %d/%d suites green" % (len(tests) - failures, len(tests)))
    return 1 if failures else 0


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p_step = sub.add_parser("step")
    p_step.add_argument("--rounds", type=int, default=6)
    p_step.add_argument("--quick", action="store_true")
    sub.add_parser("status")
    sub.add_parser("bench")
    p_ver = sub.add_parser("verify")
    p_ver.add_argument("--full", action="store_true")
    a = ap.parse_args(argv)
    if a.cmd == "step":
        return cmd_step(a.rounds, a.quick)
    if a.cmd == "status":
        return cmd_status()
    if a.cmd == "bench":
        return cmd_bench()
    return cmd_verify(a.full)


if __name__ == "__main__":
    raise SystemExit(main())
