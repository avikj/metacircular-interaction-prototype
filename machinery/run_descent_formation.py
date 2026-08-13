#!/usr/bin/env python3
"""RUN the descent-formation machine on the repository's real objects.

Two runs:
1. The Smith event torsor of M = ((2,0),(0,-3)): starting from the
   verifier carrier (one fiber), offer endpoint observables (must all
   descend — Theorem A live), then det, then Bezout recording, then word
   cost: the R0041 discrimination lattice appears as an execution trace of
   formation events, with exact split counts.
2. The encounter engine's first hardcoded return, re-derived generically:
   universe = matrices in one scalar-residual fiber; carrier = residual;
   offer the certified step kind: the machine forms exactly the sensor the
   engine hardcodes — formation as law, not script.
"""

from descent_formation_machine import DescentMachine
from smith_residual_machine import smith_reduce
from total_smith_replay_payload import payload, section
from verifier_blind_fiber_reward import (
    bezout_format,
    det_format,
    verifier_observables,
    word_cost,
)


def run_torsor():
    mat = ((2, 0), (0, -3))
    u0, v0, d = section(mat)
    from test_verifier_blind_fiber_reward import window_events
    events = list(window_events(mat, d))
    machine = DescentMachine(range(len(events)))
    payloads = [payload(u, u0) for u, v in events]

    print(f"universe: {len(events)} events of {mat}")
    e = machine.offer("endpoint+invariants",
                      lambda i: verifier_observables(mat, *events[i]))
    print(f"  offer verifier data -> {e['kind']} (fibers {e['fibers']})")
    e = machine.offer("det", lambda i: det_format(payloads[i]))
    print(f"  offer det -> {e['kind']}, splits {e['splits']} "
          f"(fibers {e['fibers']})")
    e = machine.offer("bezout", lambda i: bezout_format(payloads[i]))
    print(f"  offer bezout -> {e['kind']}, "
          f"{len(e.get('splits', {}))} fibers split (fibers {e['fibers']})")
    e = machine.offer("word-cost",
                      lambda i: word_cost(payloads[i], 6, radius=3))
    print(f"  offer word-cost -> {e['kind']} (fibers {e['fibers']})")
    print(f"  trace: {[h['kind'] for h in machine.history]}")


def run_engine_formation():
    matrices = [((a, b), (c, dd))
                for a in range(-3, 4) for b in range(-3, 4)
                for c in range(-3, 4) for dd in range(-3, 4)
                if (a, b, c, dd) != (0, 0, 0, 0)]
    with_steps = [m for m in matrices if smith_reduce(m).steps]
    fiber1 = [m for m in with_steps
              if smith_reduce(m).steps[0].residual == 1]
    machine = DescentMachine(fiber1)
    print(f"universe: {len(fiber1)} matrices in scalar-residual fiber 1")
    e = machine.offer("residual", lambda m: smith_reduce(m).steps[0].residual)
    print(f"  offer scalar residual -> {e['kind']} (the engine's old "
          f"carrier: one fiber, no distinction)")
    e = machine.offer("step-kind", lambda m: smith_reduce(m).steps[0].kind)
    print(f"  offer certified step kind -> {e['kind']}, splits into "
          f"{e['fibers']} fibers — the engine's hardcoded "
          f"'typed-residual-origin' sensor, formed by the general law")


if __name__ == "__main__":
    run_torsor()
    print()
    run_engine_formation()
