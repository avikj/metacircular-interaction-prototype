#!/usr/bin/env python3
"""Formation as the descent theorem, running (cf-tessera).

A carrier is a partition of a finite state universe.  Offering an
observable f either DESCENDS (f constant on every fiber: absorbed, no new
distinction) or FORMS (some fiber splits: the carrier becomes the joint
refinement, the coarsest carrier determining both).  This is the whole
machine — no hardcoded formation branches; the encounter engine's two
scripted returns are instances, and the R0041 discrimination lattice is an
execution trace of successive offers.

The equivariance obstruction runs too: an observable invariant under a
declared symmetry of the universe can never split inside a symmetry orbit
contained in a fiber; `offer` checks and reports this exactly.
"""


class DescentMachine:
    def __init__(self, universe):
        self.universe = list(universe)
        self.carrier = {x: 0 for x in self.universe}  # one fiber: no
        # distinctions yet — the verifier's carrier
        self.history = []

    def fibers(self):
        out = {}
        for x, label in self.carrier.items():
            out.setdefault(label, []).append(x)
        return out

    def descends(self, f):
        """f constant on every fiber?"""
        seen = {}
        for x in self.universe:
            label = self.carrier[x]
            value = f(x)
            if label in seen and seen[label] != value:
                return False
            seen[label] = value
        return True

    def offer(self, name, f, symmetry=None):
        """Offer an observable.  Returns an exact event record.

        symmetry: optional list of bijections of the universe under which
        f is claimed invariant; the obstruction check verifies that no
        split separates two points of one symmetry orbit (the R0046
        equivariant corollary, enforced at runtime).
        """
        if self.descends(f):
            event = {"observable": name, "kind": "descends",
                     "fibers": len(self.fibers())}
            self.history.append(event)
            return event
        old = self.fibers()
        new_carrier = {}
        relabel = {}
        for x in self.universe:
            key = (self.carrier[x], f(x))
            if key not in relabel:
                relabel[key] = len(relabel)
            new_carrier[x] = relabel[key]
        split_report = {}
        for label, members in old.items():
            parts = {new_carrier[x] for x in members}
            if len(parts) > 1:
                split_report[label] = len(parts)
        if symmetry is not None:
            for g in symmetry:
                for x in self.universe:
                    if new_carrier[x] != new_carrier[g(x)]:
                        raise AssertionError(
                            f"equivariance violated: {name} split a "
                            f"symmetry orbit — the offered invariance "
                            f"claim is false"
                        )
        self.carrier = new_carrier
        event = {"observable": name, "kind": "forms",
                 "splits": split_report, "fibers": len(self.fibers())}
        self.history.append(event)
        return event

    def factors_through(self, f, g):
        """Does f factor through g on the universe (descent test between
        observables, carrier-independent)?"""
        seen = {}
        for x in self.universe:
            key = g(x)
            if key in seen and seen[key] != f(x):
                return False
            seen[key] = f(x)
        return True
