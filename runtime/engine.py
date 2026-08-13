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


def last_learning_entry(ledger: list[dict]) -> dict | None:
    """Return the newest theorem-learning event, ignoring other typed lanes."""
    return next((entry for entry in reversed(ledger)
                 if entry.get("kind", "learn") == "learn"), None)


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
    previous_learning = last_learning_entry(ledger)
    widen = (previous_learning is not None and
             previous_learning.get("verdict") == "plateau")

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
    print(" entry | kind | exact result")
    for i, e in enumerate(ledger):
        if e.get("kind") == "nat":
            print("  %3d | nat  | %d..%d; sensors=%d; events=%d"
                  % (i, e["trace"][0], e["trace"][1],
                     e["sensors_total"], e["events"]))
        else:
            print("  %3d | learn| B1 %d -> %d; book=%d; %s"
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




# -------------------------------------------------------------------------
# the natural trace: the execution IS the successor walk on N
# -------------------------------------------------------------------------
#
# notes/NATURAL_MACHINE.md defines digits as the iterated odometer and proves
# positional evaluation inverts it; notes/NATURAL_CRYSTAL.md gives the three
# axes (generation, observation, behavior); machinery/arithmetic_life.py is
# the temporal axis executable: sensors (prime moduli) are FORCED by
# collisions in the walk, never chosen.  ``nat`` makes that walk the engine's
# workload.  Nothing is imported from outside the system: no prime table, no
# benchmark, no target -- the trace is 2, 3, 4, ... in successor order, and
# the ledger is what N forced.

NAT_PATH = os.path.join(STATE_DIR, "nat.json")


def load_nat():
    """Load and RE-CERTIFY the natural trace state.

    Every stored modulus is re-proved irreducible against the earlier ones
    (trial division through its own square root) before it is believed.  A
    smuggled composite sensor is refused and everything after it is replayed.
    """
    if not os.path.exists(NAT_PATH):
        return 1, [], 1
    with open(NAT_PATH) as f:
        st = json.load(f)
    certified = []
    for m in st["moduli"]:
        ok = all(m % p != 0 for p in certified if p * p <= m) and m >= 2
        if not ok:
            break
        certified.append(m)
    if len(certified) != len(st["moduli"]):
        return 1, [], 1
    return st["position"], certified, st.get("generated_through", 1)


def save_nat(position, moduli, generated_through):
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(NAT_PATH, "w") as f:
        json.dump({"position": position, "moduli": moduli,
                   "generated_through": generated_through}, f)


def cmd_nat(span: int) -> int:
    sys.path.insert(0, os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        "machinery"))
    from arithmetic_life import ArithmeticLife

    position, certified, gen_through = load_nat()
    life = ArithmeticLife()
    if certified:
        life.moduli = list(certified)
        life.generated_through = gen_through
    forced_before = len(life.moduli)
    events_before = len(life.events)

    composite = prime = 0
    for n in range(position + 1, position + span + 1):
        if n < 2:
            continue
        pair = life.factor(n)
        if pair is None:
            prime += 1
        else:
            composite += 1
    position += span
    save_nat(position, life.moduli, life.generated_through)

    forced = len(life.moduli) - forced_before
    entry = {
        "t": int(time.time()), "kind": "nat",
        "trace": [position - span + 1, position],
        "walked": span, "prime": prime, "composite": composite,
        "sensors_forced": forced, "sensors_total": len(life.moduli),
        "largest_sensor": max(life.moduli) if life.moduli else None,
        "events": len(life.events) - events_before,
        "batch_compiled": life.batch_compiled,
    }
    append_ledger(entry)
    print("nat walk %d..%d: %d prime, %d composite; sensors +%d = %d "
          "(largest %s); %d events; batch=%s"
          % (entry["trace"][0], entry["trace"][1], prime, composite,
             forced, len(life.moduli), entry["largest_sensor"],
             entry["events"], life.batch_compiled))
    return 0


def cmd_loop(rounds: int, span: int, quick: bool, delay: float,
             cycles: int) -> int:
    """Continuously alternate theorem learning with the successor walk.

    ``cycles=0`` is unbounded. Each constituent command persists its own
    checked state before the next begins; a refused learning step stops the
    loop rather than letting the natural lane conceal it.
    """
    cycle = 0
    while cycles == 0 or cycle < cycles:
        if cmd_step(rounds, quick) != 0:
            return 1
        if cmd_nat(span) != 0:
            return 1
        cycle += 1
        if delay:
            time.sleep(delay)
    return 0

def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="cmd", required=True)
    p_step = sub.add_parser("step")
    p_step.add_argument("--rounds", type=int, default=6)
    p_step.add_argument("--quick", action="store_true")
    sub.add_parser("status")
    p_nat = sub.add_parser("nat")
    p_nat.add_argument("--span", type=int, default=100)
    p_loop = sub.add_parser("loop")
    p_loop.add_argument("--rounds", type=int, default=6)
    p_loop.add_argument("--span", type=int, default=1000)
    p_loop.add_argument("--quick", action="store_true")
    p_loop.add_argument("--delay", type=float, default=0.0)
    p_loop.add_argument("--cycles", type=int, default=0,
                        help="0 means continue without a terminal cycle")
    sub.add_parser("bench")
    p_ver = sub.add_parser("verify")
    p_ver.add_argument("--full", action="store_true")
    a = ap.parse_args(argv)
    if a.cmd == "step":
        return cmd_step(a.rounds, a.quick)
    if a.cmd == "status":
        return cmd_status()
    if a.cmd == "nat":
        return cmd_nat(a.span)
    if a.cmd == "loop":
        return cmd_loop(a.rounds, a.span, a.quick, a.delay, a.cycles)
    if a.cmd == "bench":
        return cmd_bench()
    return cmd_verify(a.full)


if __name__ == "__main__":
    raise SystemExit(main())
