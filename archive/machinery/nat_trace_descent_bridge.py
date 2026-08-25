#!/usr/bin/env python3
"""The nat-trace organism as an incremental descent machine — exact bridge.

Main's engine (commit bd1c465) walks N in successor order and lets
``machinery/arithmetic_life.py`` force its own mod-p sensors.  This
branch's ``descent_formation_machine.py`` runs the descent law: an offered
observable DESCENDS (constant on every carrier fiber) or FORMS (splits a
fiber).  This module makes the identification exact and runnable, and
makes the exact point of DIVERGENCE a first-class object instead of a
hand-wave.

The identification (proved in notes/NAT_TRACE_DESCENT_BRIDGE.md):

  * The life's implicit carrier on the arrived universe {2..n} is the
    partition by least certified origin: fiber-0 = states no installed
    sensor p with p*p <= k fires on (the certified primes), fiber-p =
    composites with least prime factor p.  It is NOT the joint residue
    profile.
  * A life ``form-sensor``/``certify-sensor`` q event IS a descent
    formation: at n = q*q the state q*q arrives in fiber-0 and collides
    with the certified primes there — the sensor-extended classifier
    disagrees on the pair (q, q*q) (and on (2, q*q)); offering the
    sqrt-gated flag of q splits fiber-0.  Formation is collision-forced:
    q*q is the FIRST arrival that puts a composite into fiber-0.
  * A life ``skip-derived`` (m, p) event is descent in the IDEAL lattice,
    not function descent: skip iff mZ is contained in pZ for an installed
    p, iff the POINT m lies outside fiber-0 of the current carrier (the
    observable family and the universe are the same N, and redundancy of
    the observable mod-m equals the carrier evaluated at its own index m),
    iff the extended classifier equals the current one on every state.

The divergence (both directions carry a smallest witness, computed here):

  * life-skip is NOT function-descent: mod-4 does not factor through the
    joint of mod-2, mod-3 on {2..16} — witness pair (2, 8) — so a pure
    function-descent machine FORMS mod-4 where the life skips it.
    Smallest witness: m = 4 at n = 16.
  * life-install is NOT function-formation on the fine carrier: the joint
    residue profile of {2,3,5,7} is injective on {2..121} (210 > 119), the
    carrier is discrete, mod-11 descends vacuously, and a pure
    function-descent machine on residue profiles freezes with sensors
    within {2,3,5,7} — reproducing exactly the engine's recorded defect
    ("froze sensors at {2,3,5,7} and misclassified 121").  Smallest
    witness: q = 11 at n = 121.

Everything below is exact integer computation; runs are finite exhaustive
verifications of derived statements (see the note for the one-page proofs).
"""

from __future__ import annotations

import os
import sys
from math import isqrt

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

from arithmetic_life import ArithmeticLife            # noqa: E402
from descent_formation_machine import DescentMachine  # noqa: E402  (batch law)

__all__ = [
    "IncrementalDescentMachine", "NatBridge", "life_ground_truth",
    "function_descent_verdict", "pure_function_descent_walk",
    "candidate_verdict_table", "smallest_divergences", "DescentMachine",
]


def _lcm_list(xs):
    from math import lcm
    out = 1
    for x in xs:
        out = lcm(out, x)
    return out


# -------------------------------------------------------------------------
# the incremental descent machine: same law, universe arrives over time
# -------------------------------------------------------------------------

class IncrementalDescentMachine:
    """DescentMachine for a universe that arrives one state at a time.

    The carrier is stored as a key per state: the tuple of installed
    (genome) observable values.  ``arrive`` extends the carrier by
    evaluating the genome at the new state; ``offer`` applies the descent
    law on the states arrived so far.  Agreement with the batch
    ``DescentMachine`` on any fixed arrival prefix is exact (tested).
    """

    def __init__(self):
        self.universe = []
        self.genome = []            # list of (name, f)
        self.key = {}               # state -> tuple of genome values
        self.history = []

    def arrive(self, x):
        if x in self.key:
            raise ValueError(f"state {x} already arrived")
        self.universe.append(x)
        self.key[x] = tuple(f(x) for _name, f in self.genome)

    def fibers(self):
        out = {}
        for x in self.universe:
            out.setdefault(self.key[x], []).append(x)
        return out

    def collision(self, f):
        """First pair (a, b) in arrival order lying in one fiber with
        f(a) != f(b); None iff f descends.  (Before the first mismatch a
        fiber holds a single f-value, so one representative per fiber
        suffices and the returned pair is the canonical earliest one.)"""
        rep = {}
        for x in self.universe:
            k = self.key[x]
            v = f(x)
            if k in rep:
                a, va = rep[k]
                if va != v:
                    return (a, x)
            else:
                rep[k] = (x, v)
        return None

    def offer(self, name, f):
        pair = self.collision(f)
        if pair is None:
            event = {"observable": name, "kind": "descends",
                     "fibers": len(self.fibers())}
        else:
            self.genome.append((name, f))
            for x in self.universe:
                self.key[x] = self.key[x] + (f(x),)
            event = {"observable": name, "kind": "forms",
                     "collision": pair, "fibers": len(self.fibers())}
        self.history.append(event)
        return event


# -------------------------------------------------------------------------
# the bridge: arithmetic_life's nat walk AS an incremental descent machine
# -------------------------------------------------------------------------

def _flag(p):
    """The sqrt-gated divisibility sensor: what the life's classifier
    actually consumes from mod-p (residue-0 hits of sensors <= sqrt(k))."""
    return lambda k: p if (k % p == 0 and p * p <= k) else 0


class NatBridge:
    """Run the descent machine ON the nat world, successor order.

    States 2, 3, 4, ... arrive one at a time.  The genome is the installed
    sensor flags; the carrier is their joint (fiber-0 = all-zero key = the
    certified primes; least nonzero key entry = least prime origin).  When
    the frontier isqrt(n) reaches a fresh candidate m, the life's law runs
    as descent:

      SKIP  — the point m lies outside fiber-0 (some installed p divides
              it): ideal descent mZ <= pZ; certified on the arrived
              universe by checking the extended classifier changes nothing.
      INSTALL — the point m lies in fiber-0: the arrival n = m*m has just
              put a composite into fiber-0; the classifier collision
              (2, m*m) (equally (m, m*m)) forces formation, and offering
              flag-m to the machine FORMS (splits fiber-0).
    """

    def __init__(self):
        self.machine = IncrementalDescentMachine()
        self.sensors = []       # installed moduli in installation order
        self.frontier = 1       # candidates examined through here
        self.position = 1
        self.events = []        # ("install", m, trigger_n, pair) |
        #                         ("skip", m, p, trigger_n)
        self.classifications = {}   # n -> ("prime", None) | ("composite", lpf)

    # -- the classifier the carrier realises --------------------------------

    def _verdict(self, k, extra=None):
        """Prime/least-origin verdict of the sensor set (optionally
        extended by one more modulus)."""
        mods = self.sensors + ([extra] if extra is not None else [])
        hits = [p for p in mods if k % p == 0 and p * p <= k]
        return ("composite", min(hits)) if hits else ("prime", None)

    def _classifier_collision(self, m):
        """Two arrived states with equal current verdict on which the
        m-extended classifier disagrees; None if extending by m changes
        no verdict (m adds no prime test)."""
        changed = [k for k in self.machine.universe
                   if self._verdict(k, extra=m) != self._verdict(k)]
        if not changed:
            return None
        b = min(changed)
        a = min(k for k in self.machine.universe
                if self._verdict(k) == self._verdict(b) and k not in changed)
        return (a, b)

    # -- the walk -----------------------------------------------------------

    def step(self):
        n = self.position + 1
        self.position = n
        self.machine.arrive(n)
        bound = isqrt(n)
        for m in range(self.frontier + 1, bound + 1):
            # The life's redundancy test, read as carrier evaluation at the
            # observable's own index: least installed p <= sqrt(m) dividing
            # the POINT m (exactly arithmetic_life's skip criterion).
            w = next((p for p in self.sensors
                      if p <= isqrt(m) and m % p == 0), None)
            if w is not None:
                # ideal descent mZ <= wZ; certify: no classifier collision.
                if self._classifier_collision(m) is not None:
                    raise AssertionError(
                        f"skip of {m} would lose a prime test")
                self.events.append(("skip", m, w, n))
                continue
            pair = self._classifier_collision(m)
            if pair is None:
                raise AssertionError(
                    f"install of {m} not forced by any collision")
            event = self.machine.offer(f"flag-{m}", _flag(m))
            if event["kind"] != "forms":
                raise AssertionError(
                    f"flag-{m} descended although a collision exists")
            self.sensors.append(m)
            self.events.append(("install", m, n, pair))
        self.frontier = max(self.frontier, bound)
        verdict = self._verdict(n)
        # cross-check: the carrier key says the same thing as the verdict
        key = self.machine.key[n]
        hits = [v for v in key if v]
        assert verdict == (("composite", min(hits)) if hits
                           else ("prime", None))
        self.classifications[n] = verdict
        return verdict

    def walk_to(self, n_max):
        while self.position < n_max:
            self.step()
        return self

    def fiber_zero(self):
        return sorted(k for k in self.machine.universe
                      if not any(self.machine.key[k]))


# -------------------------------------------------------------------------
# ground truth: arithmetic_life's own machinery on the successor walk
# -------------------------------------------------------------------------

def life_ground_truth(n_max):
    """Run the imported ArithmeticLife over 2..n_max in successor order
    (exactly what main's ``engine.py nat`` does) and extract:

      events: interleaved [("install", q, trigger_n), ("skip", m, p,
              trigger_n)] in event order (trigger recorded per factor call),
      moduli: installed sensors in order,
      classifications: n -> ("prime", None) | ("composite", lpf).
    """
    life = ArithmeticLife()
    events = []
    classifications = {}
    for n in range(2, n_max + 1):
        watermark = len(life.events)
        pair = life.factor(n)
        for ev in life.events[watermark:]:
            if ev.kind == "form-sensor":
                # subject = (encounter, candidate, modulus)
                events.append(("install", ev.subject[1], ev.subject[0]))
            elif ev.kind == "skip-derived":
                events.append(("skip", ev.subject[0], ev.subject[1], n))
        classifications[n] = (("composite", pair[0]) if pair is not None
                              else ("prime", None))
    return events, list(life.moduli), classifications


# -------------------------------------------------------------------------
# function descent, for the exact divergence
# -------------------------------------------------------------------------

def function_descent_verdict(m, sensors, n_max):
    """Verdict of the raw descent law for the observable k -> k mod m on
    the fine carrier (joint residue profile of ``sensors``) over the
    universe {2..n_max}.

    Returns ("forms", (a, b)) with the earliest witness pair, or
    ("descends", "genuine") when mod-m factors through the joint as a
    function everywhere (m | lcm(sensors)), or ("descends", "vacuous")
    when it descends only because the finite universe carries no witness
    pair (the carrier is too fine — for spans below lcm(sensors) it is
    discrete).
    """
    rep = {}
    witness = None
    for k in range(2, n_max + 1):
        key = tuple(k % p for p in sensors)
        v = k % m
        if key in rep:
            a, va = rep[key]
            if va != v:
                witness = (a, k)
                break
        else:
            rep[key] = (k, v)
    if witness is not None:
        return ("forms", witness)
    genuine = _lcm_list(sensors) % m == 0 if sensors else False
    return ("descends", "genuine" if genuine else "vacuous")


def pure_function_descent_walk(n_max):
    """The replacement organism: successor walk, offering mod-m at each
    frontier crossing, installing iff the raw descent law FORMS on the
    fine carrier of everything installed so far.  Returns (installed,
    events) with events ("forms", m, n, pair) | ("descends", m, n, reason).

    This machine is NOT the life: run to 300 it installs [2, 3, 4, 5, 8,
    13] — it forms the non-squarefree 4 and 8 and vacuously absorbs the
    primes 7, 11, 17.
    """
    installed = []
    events = []
    frontier = 1
    for n in range(2, n_max + 1):
        bound = isqrt(n)
        for m in range(frontier + 1, bound + 1):
            verdict = function_descent_verdict(m, installed, n)
            if verdict[0] == "forms":
                installed.append(m)
                events.append(("forms", m, n, verdict[1]))
            else:
                events.append(("descends", m, n, verdict[1]))
        frontier = max(frontier, bound)
    return installed, events


def candidate_verdict_table(n_max):
    """For every candidate m examined during the walk to n_max (trigger
    n = m*m), with S = the life's sensors at trigger time (primes < m):
    the life's verdict versus the raw function-descent verdict.

    Rows: (m, trigger_n, life_verdict, fd_verdict) where life_verdict is
    ("install",) or ("skip", p) and fd_verdict is from
    ``function_descent_verdict(m, S, m*m)``.
    """
    events, moduli, _ = life_ground_truth(n_max)
    rows = []
    sensors = []
    for ev in events:
        if ev[0] == "install":
            m, trig = ev[1], ev[2]
            life_v = ("install",)
        else:
            m, trig = ev[1], ev[3]
            life_v = ("skip", ev[2])
        rows.append((m, trig, life_v,
                     function_descent_verdict(m, list(sensors), trig)))
        if ev[0] == "install":
            sensors.append(m)
    return rows


def smallest_divergences(n_max):
    """The two smallest witnesses where the life's law and the raw
    function-descent law disagree, from the exact verdict table.

    direction 1 (life skips, descent forms): the skip is an ideal-lattice
    absorption, not a function factorization.
    direction 2 (life installs, descent absorbs): the fine carrier is
    discrete on the short universe; descent is vacuous.
    """
    rows = candidate_verdict_table(n_max)
    d1 = [r for r in rows if r[2][0] == "skip" and r[3][0] == "forms"]
    d2 = [r for r in rows if r[2][0] == "install" and r[3][0] == "descends"]
    return (d1[0] if d1 else None), (d2[0] if d2 else None)


# -------------------------------------------------------------------------
# demonstration
# -------------------------------------------------------------------------

def main(n_max=300):
    events, moduli, life_cls = life_ground_truth(n_max)
    bridge = NatBridge().walk_to(n_max)
    print(f"successor walk 2..{n_max}")
    print(f"life moduli          : {moduli}")
    print(f"bridge sensors       : {bridge.sensors}")
    stripped = [ev[:3] if ev[0] == "install" else ev for ev in bridge.events]
    lifed = [ev if ev[0] == "install" else ev for ev in events]
    print(f"event sequences equal: {stripped == lifed}")
    same_cls = all(bridge.classifications[n] == life_cls[n]
                   for n in range(2, n_max + 1))
    print(f"classifications equal: {same_cls} "
          f"({sum(1 for v in life_cls.values() if v[0] == 'prime')} primes)")
    print("\ninstall collisions (all at n = q*q, pair = (2, q*q)):")
    for ev in bridge.events:
        if ev[0] == "install":
            print(f"  install {ev[1]:>2} at n={ev[2]:>3}  collision {ev[3]}")
    print("\ncandidate verdicts, life vs raw function-descent "
          "(S = primes < m, universe {2..m*m}):")
    for m, trig, lv, fv in candidate_verdict_table(n_max):
        mark = "" if (lv[0] == "install") == (fv[0] == "forms") \
            else "   <-- DIVERGENCE"
        print(f"  m={m:>2} at n={trig:>3}  life={lv}  descent={fv}{mark}")
    d1, d2 = smallest_divergences(n_max)
    print(f"\nsmallest divergence, life-skip vs descent-forms : {d1}")
    print(f"smallest divergence, life-install vs descent-absorbs: {d2}")
    installed, _ = pure_function_descent_walk(n_max)
    print(f"\npure function-descent organism installs: {installed}")
    print("(forms non-squarefree 4 and 8; vacuously absorbs primes "
          "7, 11, 17 — the frozen-carrier defect of engine commit "
          "bd1c465, rederived)")


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 300)
