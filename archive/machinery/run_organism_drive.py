#!/usr/bin/env python3
"""RUN the organism, don't just test it (cf-tessera, run 0001).

Feeds the coupled encounter engine an open exact stream far beyond its
scripted demo, exercises the full constructor port cycle, attaches the
R0043 multiplicative-weights learner to a live event window, and prints an
exact execution transcript.  Every event is exact arithmetic; this is an
execution log, not a measurement.
"""

from fractions import Fraction
from itertools import product

from coupled_encounter_engine import EncounterEngine
from format_conserved_learning_geometry import (
    conditionals,
    marginals,
    mwu,
    partition_from_format,
    uniform_policy,
)
from smith_residual_machine import smith_reduce
from total_smith_replay_payload import payload, section
from verifier_blind_fiber_reward import det_format


def stream_matrices(bound):
    for a, b, c, d in product(range(-bound, bound + 1), repeat=4):
        yield ((a, b), (c, d))


def run():
    log = []
    engine = EncounterEngine.inherited()

    # Phase 1: open Smith stream (the demo fed 3 matrices; feed 2400).
    fed = returns = rank_one = exceptions = 0
    for mat in stream_matrices(3):
        if mat == ((0, 0), (0, 0)):
            continue
        fed += 1
        det = mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0]
        if det == 0:
            rank_one += 1
        try:
            r = engine.meet_smith(mat)
            if r is not None:
                returns += 1
                log.append(f"RETURN at matrix #{fed} {mat}: {r.result}; "
                           f"formed {r.formed_sensor}")
        except Exception as e:  # noqa: BLE001 - transcript wants everything
            exceptions += 1
            log.append(f"EXCEPTION at {mat}: {type(e).__name__}: {e}")
    log.append(f"phase1: fed={fed} (rank_one={rank_one}) returns={returns} "
               f"exceptions={exceptions}")
    log.append(f"phase1 sensors: {sorted(engine.sensors)}")
    log.append(f"phase1 fibers held: "
               f"{ {k: len(v) for k, v in sorted(engine.smith_fibers.items())} }")

    # Phase 2: two-adic stream beyond the demo.
    for gens in ((3,), (5,), (7,), (3, 5), (3, 7), (5, 7), (3, 5, 7),
                 (9,), (11,), (13,), (7, 9), (11, 13)):
        r = engine.meet_two_adic(gens, 8)
        if r is not None:
            log.append(f"RETURN two-adic {gens}: {r.result}")
    log.append(f"phase2 two-adic fibers: "
               f"{ {k: len(v) for k, v in sorted(engine.two_adic_fibers.items())} }")

    # Phase 3: full constructor life cycle, repeated with opposition.
    forecast = engine.forecast_port_from_smith(((2, 1), (0, 7)))
    cert1 = engine.couple_constructor_port(2, "live-run-0001")
    trace1 = engine.constructor_future(0)
    engine.withdraw_constructor_port()
    cert2 = engine.couple_constructor_port(0, "live-run-0001-opposed")
    trace2 = engine.constructor_future(0)
    engine.withdraw_constructor_port()
    log.append(f"phase3: forecast={forecast.response} then ports 2,0 "
               f"installed traces {trace1} vs {trace2}; both withdrawn; "
               f"history={len(engine.constructor_history)} certificates kept")

    # Phase 4: live learning on a real event window (R0043 running, not
    # tested): det-format reward on M=((2,0),(0,-3)).
    mat = ((2, 0), (0, -3))
    u0, v0, d = section(mat)
    from test_verifier_blind_fiber_reward import window_events
    carrier = [payload(u, u0) for u, v in window_events(mat, d)]
    part = partition_from_format(carrier, det_format)
    reward = {h: (2 if det_format(h) == 1 else 0) for h in carrier}
    pi = uniform_policy(carrier)
    conds0 = conditionals(pi, part)
    marg_path = [marginals(pi, part)[1]]
    for _ in range(12):
        pi = mwu(pi, reward, Fraction(3, 2))
        marg_path.append(marginals(pi, part)[1])
    conserved = conditionals(pi, part) == conds0
    log.append(f"phase4: carrier={len(carrier)} events; det=+1 marginal ran "
               f"{marg_path[0]} -> {marg_path[-1]} over 12 live steps; "
               f"within-class conditionals conserved: {conserved}")

    # Phase 5: what the run itself now demands (engine's own successors).
    for r in engine.returns:
        log.append(f"successor demanded by run: {r.successor}")

    print("\n".join(log))


if __name__ == "__main__":
    run()
