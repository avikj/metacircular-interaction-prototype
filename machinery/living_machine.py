#!/usr/bin/env python3
"""The living machine: generic formation, native constructors, running.

One process, running an unbounded exact stream.  Each shell of matrices
is a universe; installed observables (the machine's sensors) are applied
first; every candidate observable from an open-ended frontier is offered
to the descent law — it descends (absorbed) or forms (fibers split, the
sensor installs permanently).  The kuttaka pulverizer supplies native
constructors and valli traces.  State persists across restarts; the run
log is append-only and exact.  No floats, no verdicts, no ceremony.

Run:  python3 living_machine.py [max_shells]     (default: run forever)
State: ../runtime/LIVING_STATE.json    Log: ../runtime/LIVING_RUN.log
"""

import json
import os
import sys
from itertools import product
from math import gcd

from descent_formation_machine import DescentMachine
from kuttaka_pulverizer import pulverize
from smith_residual_machine import smith_reduce

HERE = os.path.dirname(os.path.abspath(__file__))
STATE = os.path.join(HERE, "..", "runtime", "LIVING_STATE.json")
LOG = os.path.join(HERE, "..", "runtime", "LIVING_RUN.log")


def shell(bound):
    """Matrices with max-norm exactly `bound` (the new frontier)."""
    for entries in product(range(-bound, bound + 1), repeat=4):
        if max(abs(e) for e in entries) != bound:
            continue
        m = ((entries[0], entries[1]), (entries[2], entries[3]))
        if m != ((0, 0), (0, 0)):
            yield m


def elementary(m):
    e1 = gcd(gcd(m[0][0], m[0][1]), gcd(m[1][0], m[1][1]))
    det = m[0][0] * m[1][1] - m[0][1] * m[1][0]
    return e1, abs(det) // e1 if e1 else 0, det


# ---- the observable frontier: named, exact, open-ended -------------------

def base_observables():
    def endpoint(m):
        e1, q, det = elementary(m)
        return (e1, q)

    def det_sign(m):
        det = m[0][0] * m[1][1] - m[0][1] * m[1][0]
        return 0 if det == 0 else (1 if det > 0 else -1)

    def first_kind(m):
        steps = smith_reduce(m).steps
        return steps[0].kind if steps else "none"

    def first_residual(m):
        steps = smith_reduce(m).steps
        return steps[0].residual if steps else None

    def content(m):
        return elementary(m)[0]

    def valli_length(m):
        a, c = m[0][0], m[1][0]
        if a == 0 and c == 0:
            return -1
        return len(pulverize(a, c)[0])

    return [("endpoint", endpoint), ("det-sign", det_sign),
            ("first-kind", first_kind), ("first-residual", first_residual),
            ("content", content), ("valli-length", valli_length)]


def mod_observable(p):
    def f(m):
        return tuple(x % p for row in m for x in row)
    return (f"entries-mod-{p}", f)


def primes():
    n, found = 2, []
    while True:
        if all(n % q for q in found):
            found.append(n)
            yield n
        n += 1


# ---- persistence ---------------------------------------------------------

def load_state():
    if os.path.exists(STATE):
        with open(STATE) as fh:
            return json.load(fh)
    return {"shell": 1, "installed": [], "events": 0}


def save_state(state):
    os.makedirs(os.path.dirname(STATE), exist_ok=True)
    with open(STATE, "w") as fh:
        json.dump(state, fh, indent=1)


def log(line):
    os.makedirs(os.path.dirname(LOG), exist_ok=True)
    with open(LOG, "a") as fh:
        fh.write(line + "\n")


# ---- the life ------------------------------------------------------------

def live(max_shells=None):
    state = load_state()
    prime_gen = primes()
    prime_list = []
    while len(prime_list) < 2 + state["shell"]:
        prime_list.append(next(prime_gen))

    while max_shells is None or state["shell"] <= max_shells:
        bound = state["shell"]
        universe = list(shell(bound))
        machine = DescentMachine(universe)
        candidates = base_observables() + [mod_observable(p)
                                           for p in prime_list]
        formed = absorbed = 0
        # installed sensors first: the machine's accumulated power
        ordered = ([c for c in candidates if c[0] in state["installed"]]
                   + [c for c in candidates
                      if c[0] not in state["installed"]])
        for name, f in ordered:
            event = machine.offer(name, f)
            state["events"] += 1
            if event["kind"] == "forms":
                formed += 1
                if name not in state["installed"]:
                    state["installed"].append(name)
                log(f"shell={bound} FORMS {name}: "
                    f"splits={event.get('splits', {})} "
                    f"fibers={event['fibers']}")
            else:
                absorbed += 1
        log(f"shell={bound} summary: universe={len(universe)} "
            f"formed={formed} absorbed={absorbed} "
            f"carrier-fibers={len(machine.fibers())} "
            f"installed={len(state['installed'])}")
        state["shell"] += 1
        prime_list.append(next(prime_gen))
        save_state(state)


if __name__ == "__main__":
    limit = int(sys.argv[1]) if len(sys.argv) > 1 else None
    live(limit)
