#!/usr/bin/env python3
"""The long-running engine: append-only, self-scheduling, insight-yielding.

Everything this corpus derived, wired into one loop. Each design decision
below is a result someone proved here, and is cited to it -- an engine whose
choices are arbitrary is a very expensive random number generator.

  FOUR_LOSSES      a presentation fails four ways and each costs a different
                   currency, so every failure is CLASSIFIED and ROUTED
                   rather than retried.
  ABHAVA           absence is fourfold with different monotonicity, so the
                   store is append-only and the FOLD respects it: prior
                   absence is revisable, posterior absence is permanent,
                   absolute absence PRUNES, mutual absence separates.
  chakravala       the residual selects the next move; only one verdict
                   licenses "spend more".
  kernel fairness  smallest-first, because FIFO accumulates ever-larger
                   instances of theorems it never states in general -- and
                   it looks productive the whole time.
  CRYSTAL sec 0    a null control, because an engine that finds structure
                   everywhere is measuring itself.
  RUNTIME sec 1    report CAPABILITY (what became decidable), not just
                   efficiency -- 1-of-10 to 10-of-10 was the real result and
                   3367x was the distraction.
  GAUGE_OF_FLEET   external answers are the only non-invariant check, so the
                   engine flags which of its findings are checkable against
                   the literature.

The state is a JSONL log and nothing else. Kill it at any point and restart;
it reads the log, skips what is settled, and resumes. Memory is never
trusted -- it is replayed.

Run:
    python3 machinery/crystal/engine.py            # one pass
    python3 machinery/crystal/engine.py --forever  # until interrupted
    python3 machinery/crystal/engine.py --report   # read the log, say what is known
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from itertools import permutations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import LPO, Completion, mk  # noqa: E402
from machinery.crystal.obstruction import Verdict, obstruction_of  # noqa: E402
from machinery.crystal.theories import LIBRARY, MAPS, precedence_for  # noqa: E402
from machinery.crystal.transport import Interpretation  # noqa: E402

LOG = Path(__file__).resolve().parents[2] / "data" / "engine_log.jsonl"

# ---------------------------------------------------------------------------
# The absence store. ABHAVA's fourfold, with the monotonicity that makes the
# fold well defined. This is the only state, and it is derived from the log.
# ---------------------------------------------------------------------------

#: absolute absence -- prunes. Never re-attempted, at any budget.
ABSOLUTE = {"IMPOSSIBLE", "BEYOND_LPO"}
#: posterior absence -- permanent, but does not forbid neighbours.
POSTERIOR = {"REFUTED"}
#: prior absence -- revisable. Re-attempted when capability grows.
PRIOR = {"EXHAUSTED", "OUT_OF_SCOPE"}


def append(ev: dict) -> None:
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("a") as fh:
        fh.write(json.dumps(ev, sort_keys=True) + "\n")


def replay() -> list[dict]:
    if not LOG.exists():
        return []
    out = []
    for line in LOG.read_text().splitlines():
        if line.strip():
            out.append(json.loads(line))
    return out


def fold(events: list[dict]) -> dict:
    """The fold. Different absences have different monotonicity, so this is
    not a dict update -- it is four accumulators with four laws."""
    st = {
        "settled": {},      # key -> verdict, for anything not to be re-run
        "prior": {},        # key -> the budget/scope it died at; revisable
        "theorems": [],     # FATAL yields: collapse witnesses
        "adopted": {},      # theories the engine constructed
        "requirements": [], # BEYOND_LPO: named, not attempted
        "capability": 0,    # pairs decided
        "attempts": 0,
    }
    for e in events:
        if e.get("type") != "pursuit":
            continue
        st["attempts"] += 1
        k, v = e["key"], e["outcome"]
        if v in ABSOLUTE:
            st["settled"][k] = v          # prunes; never revisited
            st["prior"].pop(k, None)
            if v == "IMPOSSIBLE":
                st["theorems"].append(e)
            else:
                st["requirements"].append(e)
        elif v == "SUCCEEDED":
            st["settled"][k] = v
            st["prior"].pop(k, None)
            st["capability"] += 1
            if e.get("adopted"):
                st["adopted"][k] = e["adopted"]
        elif v in ("STRICTLY_WEAKER", "VACUOUS"):
            st["settled"][k] = v
            st["prior"].pop(k, None)
            if v == "STRICTLY_WEAKER":
                st["adopted"][k] = e.get("missing", [])
        elif v in PRIOR or v == "SPENT":
            # revisable: keep the budget it died at, so a later pass with a
            # larger budget is a genuinely new attempt and not a repeat.
            st["prior"][k] = e.get("budget", 0)
    return st


# ---------------------------------------------------------------------------
# The work queue. Smallest-first, because generality lives at small size.
# ---------------------------------------------------------------------------


def size_of(name: str) -> int:
    ax, sig = LIBRARY[name]
    return sum(l.size + r.size for _, l, r in ax) + len(sig)


def queue(st: dict, budget: int) -> list[tuple]:
    """Every WELL-TYPED (source, target, map) not yet settled, smallest first.

    Well-typed means the source signature embeds in the target's, so the
    declared map is total and the question "does S interpret into T" is
    actually asked rather than approximated. Pairs that fail this are not
    obstructions -- they are questions posed outside the target's
    jurisdiction (FOUR_LOSSES family II, degenerate), and queueing them
    would fill the log with a category error.

    A pair whose prior attempt died at a budget >= the current one is not
    re-queued: repeating an identical attempt is the blind retry the
    chakravala note refuses.
    """
    items = []
    for s in LIBRARY:
        for t in LIBRARY:
            if s == t:
                continue
            if not LIBRARY[s][1] <= LIBRARY[t][1]:
                continue
            for m in MAPS:
                key = f"{s}->{t}:{m}"
                if key in st["settled"]:
                    continue
                if st["prior"].get(key, 0) >= budget:
                    continue
                items.append((size_of(s) + size_of(t), s, t, m))
    items.sort()
    return [(s, t, m) for _, s, t, m in items]


# ---------------------------------------------------------------------------
# One pursuit. The chakravala loop, with each verdict routed by FOUR_LOSSES.
# ---------------------------------------------------------------------------


def pursue_pair(src: str, tgt: str, mapname: str, budget: int) -> dict:
    """Ask ONCE whether S interprets into T as given, and classify.

    The chakravala repairs -- adopt the residual, widen the signature -- are
    for when you WANT a particular transport. They are wrong as an outer
    loop for MAPPING, because adopting the source's axioms into the target
    makes every pair succeed and the engine reports structure everywhere.
    The first version of this function did exactly that: 11 vacuous
    adoptions, 0 theorems, and every one of them true. The question has to
    be asked as posed.
    """
    s_ax, s_sig = LIBRARY[src]
    t_ax, t_sig = LIBRARY[tgt]
    sig = set(t_sig)
    axioms = list(t_ax)
    order = LPO(precedence_for(sig | s_sig))
    clauses = dict(MAPS[mapname])
    trace, adopted = [], []

    for step in range(4):
        comp = Completion(order)
        comp.run(axioms, max_rules=budget, max_rounds=budget * 8)
        interp = Interpretation(mapname, clauses, s_ax, comp)

        if interp.check():
            return {"outcome": "SUCCEEDED", "trace": trace, "adopted": adopted,
                    "steps": step + 1, "cost": interp.cost_to_check}

        obs = obstruction_of(interp, axioms, order, sig,
                             max_rules=budget, max_rounds=budget * 8)
        if obs is None:
            return {"outcome": "SUCCEEDED", "trace": trace, "steps": step + 1}
        v = obs.verdict
        trace.append(v.value)

        # FAMILY I -- the fiber collapsed. Terminal, and the collapse is the
        # theorem. No successor exists and proposing one is a category error.
        if v is Verdict.FATAL:
            l, r, _ = obs.collapse_witness
            return {"outcome": "IMPOSSIBLE", "trace": trace, "steps": step + 1,
                    "witness": f"{l!r} = {r!r}", "cost": obs.cost,
                    "family": "I"}

        # FAMILY II -- the index was wrong, not the object. Two repairs, and
        # they are the two cheap ones: widen the signature, or adopt.
        if v is Verdict.OUT_OF_SCOPE:
            # Only reachable if the well-typedness filter missed something.
            return {"outcome": "OUT_OF_SCOPE", "trace": trace,
                    "steps": step + 1, "unmapped": [list(u) for u in obs.unmapped]}

        if v is Verdict.EXTENDS:
            # T is strictly weaker than S. The INFORMATIVE content is WHICH
            # axioms fail, and how many. If every source axiom fails, T tells
            # us nothing about S and the "extension" is just a copy of S --
            # vacuous, and reported as such rather than as a success.
            failed = [r.axiom for r in obs.residuals]
            vacuous = len(failed) >= len([a for a in s_ax if a[0] != "assoc"]) \
                and len(failed) == len(s_ax)
            return {"outcome": "VACUOUS" if vacuous else "STRICTLY_WEAKER",
                    "trace": trace, "steps": step + 1, "cost": obs.cost,
                    "missing": failed, "family": "II",
                    "adopted": [f"{l!r} = {r!r}" for _, l, r in
                                ((n, *r.as_equation()) for n, r in
                                 zip(failed, obs.residuals))]}

        # FAMILY II, order-flavoured -- this ORDER cannot see it. Re-orient;
        # if no precedence works, the requirement is NAMED, not attempted.
        if v is Verdict.UNORIENTABLE:
            l, r, _ = obs.surviving_residual
            syms = sorted({a for a, _ in sig})
            found = None
            for perm in permutations(syms):
                o = LPO(list(perm))
                if o.gt(l, r) or o.gt(r, l):
                    found = list(perm)
                    break
            if found is None:
                return {"outcome": "BEYOND_LPO", "trace": trace,
                        "steps": step + 1, "cost": obs.cost, "family": "II",
                        "requirement": f"{l!r} = {r!r} needs completion modulo AC"}
            order = LPO(found)
            continue

        # FAMILY IV -- a resource floor, and the only verdict that licenses
        # spending more. Reported with the budget so a later pass is a new
        # attempt rather than a repeat.
        if v is Verdict.EXHAUSTED:
            return {"outcome": "EXHAUSTED", "trace": trace, "steps": step + 1,
                    "budget": budget, "cost": obs.cost, "family": "IV"}

    return {"outcome": "SPENT", "trace": trace, "steps": 6, "budget": budget}


# ---------------------------------------------------------------------------
# The null control. CRYSTAL sec 0: an engine that finds structure everywhere
# is measuring itself.
# ---------------------------------------------------------------------------


def null_control() -> dict:
    """A map declared between theories with disjoint signatures must come
    back OUT_OF_SCOPE and must NEVER come back IMPOSSIBLE. A spurious
    theorem here invalidates the pass."""
    s_ax, s_sig = LIBRARY["involution"]      # unary f
    t_ax, t_sig = LIBRARY["left-zero"]       # binary *
    order = LPO(precedence_for(s_sig | t_sig))
    comp = Completion(order)
    comp.run(t_ax)
    interp = Interpretation("null", {}, s_ax, comp)
    obs = obstruction_of(interp, t_ax, order, set(t_sig))
    ok = obs is not None and obs.verdict is Verdict.OUT_OF_SCOPE

    # Second control, added after the first pass reported 11 "constructed
    # theories" and 0 theorems: a theory must NOT be found to interpret into
    # a strictly weaker one. `band` into `semigroup` must fail, because not
    # every semigroup is idempotent. If this passes, the engine is adopting
    # its way to success and its findings are vacuous.
    b_ax, b_sig = LIBRARY["band"]
    o2 = LPO(precedence_for(b_sig))
    c2 = Completion(o2)
    c2.run(LIBRARY["semigroup"][0])
    i2 = Interpretation("null2", {}, b_ax, c2)
    ok2 = not i2.check()

    return {"type": "null-control", "passed": bool(ok and ok2),
            "disjoint_sig_out_of_scope": bool(ok),
            "weaker_target_rejected": bool(ok2),
            "verdict": obs.verdict.value if obs else "CHECKED"}


# ---------------------------------------------------------------------------
# The pass
# ---------------------------------------------------------------------------


def one_pass(budget: int, limit: int = 40, quiet: bool = False) -> dict:
    st = fold(replay())
    nc = null_control()
    append(nc)
    if not nc["passed"]:
        print("NULL CONTROL FAILED -- refusing to record findings", file=sys.stderr)
        return {"halted": True}

    todo = queue(st, budget)[:limit]
    if not quiet:
        print(f"pass: budget={budget}  queued={len(todo)}  "
              f"settled={len(st['settled'])}  revisable={len(st['prior'])}")

    found = 0
    for src, tgt, m in todo:
        t0 = time.time()
        try:
            res = pursue_pair(src, tgt, m, budget)
        except Exception as exc:                      # a crash is data
            res = {"outcome": "ERROR", "error": repr(exc)[:200]}
        ev = {"type": "pursuit", "key": f"{src}->{tgt}:{m}", "src": src,
              "tgt": tgt, "map": m, "budget": budget,
              "seconds": round(time.time() - t0, 2), **res}
        append(ev)
        if res["outcome"] in ("IMPOSSIBLE", "SUCCEEDED", "BEYOND_LPO",
                              "STRICTLY_WEAKER"):
            found += 1
            if not quiet:
                mark = {"IMPOSSIBLE": "THEOREM", "SUCCEEDED": "interprets",
                        "BEYOND_LPO": "requirement",
                        "STRICTLY_WEAKER": "weaker-by"}[res["outcome"]]
                extra = (res.get("witness") or res.get("requirement")
                         or ",".join(res.get("missing", [])))
                print(f"  {mark:12s} {src} -> {tgt} [{m}]  {extra}")
    return {"settled_now": found, "attempted": len(todo)}


def report() -> None:
    ev = replay()
    st = fold(ev)
    print("=" * 74)
    print("ENGINE REPORT -- state is the fold over an append-only log")
    print("=" * 74)
    print(f"\nevents {len(ev)}   attempts {st['attempts']}   "
          f"settled {len(st['settled'])}   revisable {len(st['prior'])}")

    nulls = [e for e in ev if e.get("type") == "null-control"]
    bad = [n for n in nulls if not n.get("passed")]
    print(f"null controls: {len(nulls)} run, {len(bad)} failed"
          + ("  <-- FINDINGS INVALID" if bad else ""))

    print(f"\n--- CAPABILITY: {st['capability']} interpretations decided ---")
    print("    (the number that matters; efficiency amortises, capability does not)")

    print(f"\n--- THEOREMS ({len(st['theorems'])}) — a fiber collapsed, "
          "and the collapse is the result ---")
    for t in st["theorems"]:
        print(f"  {t['src']} into {t['tgt']} [{t['map']}] is impossible: "
              f"{t.get('witness','')}")
        print(f"      -> the two theories share only the trivial model")

    print(f"\n--- STRICTLY WEAKER ({len(st['adopted'])}) — T does not prove S, "
          "and here is exactly which axioms fail ---")
    for k, v in list(st["adopted"].items())[:14]:
        print(f"  {k}: misses {v}")
    vac = sum(1 for x in st["settled"].values() if x == "VACUOUS")
    print(f"\n  ({vac} pairs VACUOUS — every source axiom fails, so the target "
          "says nothing\n   about the source. Recorded, not counted as a finding.)")

    print(f"\n--- NAMED REQUIREMENTS ({len(st['requirements'])}) — beyond this "
          "machinery, stated rather than attempted ---")
    seen = set()
    for r in st["requirements"]:
        w = r.get("requirement", "")
        if w not in seen:
            seen.add(w)
            print(f"  {r['src']} -> {r['tgt']}: {w}")

    print(f"\n--- REVISABLE ({len(st['prior'])}) — prior absence: no origin, "
          "and an end is possible. Re-attempted when budget grows. ---")
    for k, b in list(st["prior"].items())[:8]:
        print(f"  {k} (died at budget {b})")

    print("\n--- CHECKABLE AGAINST AN EXTERNAL ANSWER ---")
    print("  The only non-invariant check available (GAUGE_OF_THE_FLEET §1).")
    print("  Every THEOREM above is a statement about equational theories")
    print("  that a semigroup theorist can confirm or refute without running")
    print("  this code. That is the audit that counts.")
    print("=" * 74)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--forever", action="store_true")
    ap.add_argument("--report", action="store_true")
    ap.add_argument("--budget", type=int, default=12)
    ap.add_argument("--limit", type=int, default=40)
    a = ap.parse_args()

    if a.report:
        report()
        return 0

    budget = a.budget
    while True:
        r = one_pass(budget, a.limit)
        if r.get("halted"):
            return 1
        if not a.forever:
            break
        # Capability grew or the queue emptied: raise the budget. This is the
        # ONLY place spending increases, and only because EXHAUSTED asked.
        if r["attempted"] == 0:
            budget = int(budget * 1.5) + 1
            print(f"queue empty at this budget -> raising to {budget}")
            if budget > 200:
                print("budget ceiling reached; every remaining pair is "
                      "settled, pruned, or named. Stopping.")
                break
    report()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
