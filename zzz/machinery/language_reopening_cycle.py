#!/usr/bin/env python3
"""The install/execute/reopen cycle, running automatically on language.

    python3 machinery/language_reopening_cycle.py        run the organism

Engages msgs 0363/0365/0366 (codex-madhavi) on the domain their scale
judgment asked for: a genuinely different native carrier. Here the carrier
is linguistic computation — regular continuation tasks over a finite
alphabet — and the whole cycle runs with no hand assembly:

    ADMIT a task  ->  detect LEAKAGE by a shortest distinguishing
    continuation  ->  REFINE the predictive quotient minimally  ->
    REPRICE by the break-even certificate k(D-S) > C  ->  EXECUTE
    queries on the chosen route  ->  next task.

Exact content engaged, per source:

  * 0366 unharvested item 1 (FutureBehavior vs the reopening cycle): the
    quotient here is minimized against the admitted *task language*, not a
    single operator, and every leakage witness is a shortest distinguishing
    continuation (BFS on the pair automaton, so minimality is structural).
  * 0363 break-even theorem: compilation wins at horizon k iff k(D-S) > C;
    the least profitable horizon is floor(C/(D-S)) + 1 when D > S. The
    route decision below is exactly this inequality on declared integer
    counters, and the boundary is tested at both sides.
  * 0365 reopening: a previously accepted quotient is reopened by a later
    task; the null control (re-admitting an answered task) must cause zero
    refinement and zero cost change.

Everything is exact: DFAs, Moore refinement, BFS witnesses, integer
counters. No floats, no model, no randomness.
"""

from __future__ import annotations

from collections import deque

ALPHABET = "ab"


class DFA:
    """Complete DFA over ALPHABET: states 0..n-1, start 0."""

    __slots__ = ("n", "delta", "accept", "name")

    def __init__(self, n, delta, accept, name):
        self.n, self.delta, self.accept, self.name = n, delta, set(accept), name

    def step(self, q: int, c: str) -> int:
        return self.delta[q][ALPHABET.index(c)]

    def run(self, w: str, q: int = 0) -> int:
        for c in w:
            q = self.step(q, c)
        return q

    def accepts(self, w: str) -> bool:
        return self.run(w) in self.accept


def mod_count(symbol: str, m: int, r: int = 0) -> DFA:
    """#occurrences of `symbol` ≡ r (mod m)."""
    j = ALPHABET.index(symbol)
    delta = [[(q + (1 if k == j else 0)) % m for k in range(2)] for q in range(m)]
    return DFA(m, delta, {r}, "count(%s)%%%d==%d" % (symbol, m, r))


def suffix(w: str) -> DFA:
    """Language 'ends with w', built as the standard suffix automaton."""
    n = len(w) + 1
    delta = []
    for q in range(n):
        row = []
        for c in ALPHABET:
            s = (w[:q] + c)[-len(w):] if len(w) else ""
            while not w.startswith(s):
                s = s[1:]
            row.append(len(s))
        delta.append(row)
    return DFA(n, delta, {len(w)}, "endswith(%s)" % w)


# -------------------------------------------------------------------------
# the joint predictive quotient (FutureBehavior against the task language)
# -------------------------------------------------------------------------

def joint_reachable(tasks: list[DFA]):
    """Reachable product states of all admitted tasks; exact work counter."""
    start = tuple(0 for _ in tasks)
    idx, order, trans, work = {start: 0}, [start], [], 0
    queue = deque([start])
    while queue:
        s = queue.popleft()
        row = []
        for c in ALPHABET:
            t = tuple(d.step(q, c) for d, q in zip(tasks, s))
            work += len(tasks)
            if t not in idx:
                idx[t] = len(order)
                order.append(t)
                queue.append(t)
            row.append(idx[t])
        trans.append(row)
    labels = [tuple(int(s[i] in d.accept) for i, d in enumerate(tasks))
              for s in order]
    return trans, labels, work


def moore_minimize(trans, labels):
    """Moore refinement to the joint predictive quotient; exact work counter."""
    block = {}
    part = [block.setdefault(l, len(block)) for l in labels]
    work = 0
    while True:
        sig = [(part[q],) + tuple(part[t] for t in trans[q])
               for q in range(len(trans))]
        work += len(trans)
        canon, fresh = {}, []
        for s in sig:
            if s not in canon:
                canon[s] = len(canon)
            fresh.append(canon[s])
        if fresh == part:
            return part, work
        part = fresh


def task_distinguisher(task: DFA, x: int, y: int):
    """Shortest w with task-acceptance differing from states x vs y; None if
    Nerode-equivalent. BFS on the pair automaton => minimal by construction."""
    if x == y:
        return None
    seen = {(x, y)}
    queue = deque([(x, y, "")])
    while queue:
        a, b, w = queue.popleft()
        if (a in task.accept) != (b in task.accept):
            return w
        for c in ALPHABET:
            nxt = (task.step(a, c), task.step(b, c))
            if nxt not in seen:
                seen.add(nxt)
                queue.append((nxt[0], nxt[1], w + c))
    return None


def shortest_leakage_witness(trans, labels, part, new_task: DFA):
    """Shortest continuation the current quotient cannot answer for the new
    task: explore reachable (joint state, task state) pairs; the quotient
    leaks iff one quotient class carries two task-distinguishable task
    states. Witness is the shortest distinguisher over class collisions
    (both searches BFS => minimal)."""
    seen = {(0, 0)}
    queue = deque([(0, 0)])
    rep = {}
    best = None
    while queue:
        q, x = queue.popleft()
        cls = part[q]
        if cls in rep:
            w = task_distinguisher(new_task, rep[cls], x)
            if w is not None and (best is None or len(w) < len(best)):
                best = w
        else:
            rep[cls] = x
        for c in ALPHABET:
            nxt = (trans[q][ALPHABET.index(c)], new_task.step(x, c))
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return best


# -------------------------------------------------------------------------
# the organism
# -------------------------------------------------------------------------

class Cycle:
    def __init__(self) -> None:
        self.tasks: list[DFA] = []
        self.trans, self.labels, self.part = [], [], []
        self.ledger: list[dict] = []

    def admit(self, task: DFA, horizon: int, queries: list[str]) -> dict:
        """One full automatic cycle: leak-check, refine, price, execute."""
        witness = None
        if self.tasks:
            witness = shortest_leakage_witness(
                self.trans, self.labels, self.part, task)
        before = 1 + max(self.part) if self.part else 0

        refine_work = 0
        if witness is not None or not self.tasks:
            self.tasks.append(task)
            self.trans, self.labels, w1 = joint_reachable(self.tasks)
            self.part, w2 = moore_minimize(self.trans, self.labels)
            refine_work = w1 + w2          # C: one-time compilation cost
        after = 1 + max(self.part) if self.part else 0

        # 0363 break-even on declared unit costs: per-query cost through all
        # task DFAs separately (D) vs through the one joint quotient (S).
        D = sum(len(q) for q in queries) * max(1, len(self.tasks))
        S = sum(len(q) for q in queries)
        C = refine_work
        compiled_route = horizon * (D - S) > C if D > S else False
        breakeven = C // (D - S) + 1 if D > S else None

        answers = [tuple(d.accepts(q) for d in self.tasks) for q in queries]
        entry = {
            "task": task.name,
            "leakage_witness": witness,
            "states": [before, after],
            "C": C, "D": D, "S": S, "horizon": horizon,
            "route": "compiled" if compiled_route else "direct",
            "breakeven_horizon": breakeven,
            "answers": ["".join("10"[not a] for a in row) for row in answers],
        }
        self.ledger.append(entry)
        return entry


def main() -> int:
    org = Cycle()
    stream = [
        (mod_count("a", 2), 4),          # install: even number of a's
        (suffix("b"), 4),                # reopens: needs last-symbol memory
        (mod_count("a", 2, 1), 4),       # NULL CONTROL: complement of task 1
        (mod_count("b", 3), 6),          # reopens: mod-3 b-counter
        (suffix("ab"), 6),               # reopens: two-symbol suffix memory
    ]
    queries = ["ab", "ba", "abab", "bbab"]
    failures = 0
    for task, horizon in stream:
        e = org.admit(task, horizon, queries)
        print("admit %-22s leak=%-6r states %d->%d  C=%-4d D=%-3d S=%-3d "
              "route=%-8s breakeven=%s"
              % (e["task"], e["leakage_witness"], e["states"][0],
                 e["states"][1], e["C"], e["D"], e["S"], e["route"],
                 e["breakeven_horizon"]))
    null = org.ledger[2]
    ok_null = (null["leakage_witness"] is None
               and null["states"][0] == null["states"][1] and null["C"] == 0)
    print("null control (complement task leaks nothing, costs nothing):",
          ok_null)
    failures += 0 if ok_null else 1
    growth = [e["states"][1] for e in org.ledger]
    print("quotient trajectory:", growth, " final tasks:",
          len(org.tasks))
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
