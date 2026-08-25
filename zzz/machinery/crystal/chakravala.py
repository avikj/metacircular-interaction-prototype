"""The cyclic method: a residual generates the next attempt.

Principle: an incomplete result is not discarded; its defect selects the
next move. Named after Bhaskara II's chakravala for Pell's equation, where
a near-solution's error is precisely what picks the next intermediate --
and after Kepler, who kept eight arcminutes of discrepancy in Mars's orbit
rather than rounding them away, because Tycho's data was better than the
error. Both are the same discipline: the leftover is the instrument.

`obstruction.py` records why a transport failed and stops. That leaves the
most useful part on the table: each verdict does not merely *describe* a
failure, it *determines* the next move. Bhaskara's cyclic method is the
model: a near-solution is not discarded, its defect selects the next
intermediate, and the loop closes on an answer rather than restarting.

This is not retry-with-more. Blind retry is what `EXHAUSTED` alone would
license; three of the five verdicts license a move that a bigger budget
would never find:

    FATAL         terminal. The theorem IS the yield; there is no successor
                  and proposing one would be a category error.
    EXTENDS       adopt T ∪ Obs as the target and re-run. The failure named
                  the theory the map actually goes into.
    OUT_OF_SCOPE  widen the declared signature by the unmapped symbols and
                  re-run. The failure named the missing part of the map.
    UNORIENTABLE  re-orient: the residual is invisible to THIS precedence,
                  so try the others. If no precedence in the signature
                  orients it, that is itself a result -- the equation is
                  permanently beyond LPO and the requirement (completion
                  modulo AC) is named rather than guessed at.
    EXHAUSTED     and only here: spend more.

**Termination.** Each move strictly decreases a component of the lexicographic
measure (unmapped symbols, unadopted residuals, untried precedences,
remaining doublings), and none increases an earlier one, so the pursuit
cannot cycle. This is stated as a theorem in `notes/RUNTIME.md` §9 rather
than hoped for: a self-directing loop that can spin is worse than one that
stops.

Every step of the trace carries its own reason, cost and residual, because
a loop whose steps are not individually accountable is a loop moving blind.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from itertools import permutations
from typing import Optional

from machinery.crystal.kernel import LPO, Completion, Term
from machinery.crystal.obstruction import (
    Obstruction, Verdict, _symbols, obstruction_of,
)
from machinery.crystal.transport import Interpretation


class Outcome:
    SUCCEEDED = "SUCCEEDED"
    """The transport checks -- possibly in a theory the pursuit constructed."""
    IMPOSSIBLE = "IMPOSSIBLE"
    """Proved impossible, with the collapse witness as the yield."""
    BEYOND_LPO = "BEYOND_LPO"
    """No precedence orients the residual. The requirement is named."""
    SPENT = "SPENT"
    """Moves exhausted. Reports what remained, and claims nothing."""


@dataclass
class Step:
    """One turn of the cycle, individually accountable."""

    n: int
    verdict: Optional[str]
    move: str
    """What this step DID, and why the residual selected it."""
    residual: Optional[tuple] = None
    cost: int = 0

    def __repr__(self) -> str:
        v = self.verdict or "—"
        return f"  [{self.n}] {v:<13} → {self.move}"


@dataclass
class Pursuit:
    trace: list[Step] = field(default_factory=list)
    outcome: Optional[str] = None
    target_axioms: list = field(default_factory=list)
    signature: set = field(default_factory=set)
    order: Optional[LPO] = None
    yield_: Optional[object] = None
    """The thing the pursuit produced: a theorem (FATAL), the adopted
    theory (EXTENDS), or the named requirement (BEYOND_LPO)."""

    @property
    def cost(self) -> int:
        return sum(s.cost for s in self.trace)

    def report(self) -> str:
        out = [f"pursuit — {self.outcome}  ({len(self.trace)} steps, "
               f"{self.cost} rewrite steps)"]
        out += [repr(s) for s in self.trace]
        if self.yield_ is not None:
            out.append(f"  yield: {self.yield_}")
        return "\n".join(out)


def _orientable_under_some_precedence(l: Term, r: Term, symbols: list) -> Optional[list]:
    """Is the residual orientable by ANY precedence on this signature?

    Finite and exact for a small signature. A negative answer is a real
    result: the equation is beyond LPO entirely, and no amount of reordering
    or budget will help.
    """
    for perm in permutations(symbols):
        o = LPO(list(perm))
        if o.gt(l, r) or o.gt(r, l):
            return list(perm)
    return None


def pursue(interp_factory, target_axioms: list, order: LPO,
           signature: set, max_steps: int = 12,
           budget: tuple = (60, 400)) -> Pursuit:
    """Run the cycle until it closes.

    `interp_factory(target_completion)` builds a fresh Interpretation against
    a given compiled target, so the pursuit can change the target under it.
    """
    p = Pursuit(target_axioms=list(target_axioms), signature=set(signature),
                order=order)
    tried_precedences = {tuple(sorted(signature))}
    rules_cap, rounds_cap = budget
    doublings = 0

    for n in range(1, max_steps + 1):
        target = Completion(p.order)
        target.run(p.target_axioms)
        interp = interp_factory(target)

        if interp.check():
            p.trace.append(Step(n, None, "the transport CHECKS — cycle closes"))
            p.outcome = Outcome.SUCCEEDED
            p.yield_ = p.target_axioms
            return p

        # The budget goes IN. Re-classifying an already-classified record
        # would silently destroy a verdict that classify() does not compute
        # -- OUT_OF_SCOPE is decided before the mathematics, so a second
        # classify() overwrites it with a meaningless EXTENDS. This is the
        # same contamination bug as stale fields, wearing a different hat.
        obs = obstruction_of(interp, p.target_axioms, p.order, p.signature,
                             max_rules=rules_cap, max_rounds=rounds_cap)
        v = obs.verdict

        # ---- each verdict selects its own successor -------------------
        if v is Verdict.FATAL:
            l, r, _ = obs.collapse_witness
            p.trace.append(Step(n, v.value,
                                "terminal — the impossibility IS the result; "
                                "no successor exists", (l, r), obs.cost))
            p.outcome = Outcome.IMPOSSIBLE
            p.yield_ = f"{l!r} = {r!r} — the theories share only the trivial model"
            return p

        if v is Verdict.OUT_OF_SCOPE:
            gained = list(obs.unmapped)
            p.signature |= set(gained)
            p.trace.append(Step(n, v.value,
                                f"widen the declared signature by {gained} "
                                "and re-run", None, obs.cost))
            continue

        if v is Verdict.EXTENDS:
            adopted = [(f"adopted:{r.axiom}", *r.as_equation())
                       for r in obs.residuals]
            p.target_axioms = p.target_axioms + adopted
            for _, l, r in adopted:
                p.signature |= _symbols(l) | _symbols(r)
            p.trace.append(Step(n, v.value,
                                f"adopt {len(adopted)} residual equation(s) "
                                "into the target and re-run", None, obs.cost))
            continue

        if v is Verdict.UNORIENTABLE:
            l, r, _ = obs.surviving_residual
            syms = sorted({s for s, _ in p.signature})
            perm = _orientable_under_some_precedence(l, r, syms)
            if perm is None:
                p.trace.append(Step(n, v.value,
                                    "no precedence on this signature orients "
                                    "the residual — beyond LPO", (l, r), obs.cost))
                p.outcome = Outcome.BEYOND_LPO
                p.yield_ = (f"{l!r} = {r!r} requires completion modulo AC "
                            "(ordered/unfailing completion); NOT attempted")
                return p
            if tuple(perm) in tried_precedences:
                p.trace.append(Step(n, v.value,
                                    "the orienting precedence was already "
                                    "tried — no move left", (l, r), obs.cost))
                p.outcome = Outcome.SPENT
                return p
            tried_precedences.add(tuple(perm))
            p.order = LPO(perm)
            p.trace.append(Step(n, v.value,
                                f"re-orient: precedence → {perm}", (l, r),
                                obs.cost))
            continue

        if v is Verdict.EXHAUSTED:
            if doublings >= 3:
                p.trace.append(Step(n, v.value,
                                    "budget doubled three times without "
                                    "closing — stopping, claiming nothing",
                                    None, obs.cost))
                p.outcome = Outcome.SPENT
                return p
            doublings += 1
            rules_cap, rounds_cap = rules_cap * 2, rounds_cap * 2
            p.trace.append(Step(n, v.value,
                                f"spend more: budget → "
                                f"{rules_cap}/{rounds_cap}", None, obs.cost))
            continue

    p.trace.append(Step(max_steps + 1, None, "step limit reached"))
    p.outcome = Outcome.SPENT
    return p
