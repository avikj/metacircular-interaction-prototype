#!/usr/bin/env python3
"""A proof-carrying recursive compiler whose learned actions cause later ones.

The model is deliberately elementary.  An action ``T_d`` translates every
integer by ``d``.  From an already checked ``T_d`` the compiler may prove and
install its ``arity``-fold composite ``T_(arity*d)`` as a one-access derived
action.  The policy is required to use the widest checked action as the parent
of the next proposal.  Consequently the capability formed at step k is an
input, rather than merely an output, of step k+1.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Action:
    name: str
    displacement: int
    parent: str | None
    arity: int


@dataclass(frozen=True)
class Step:
    index: int
    parent: str
    installed: str
    requested_displacement: int
    base_equivalent_work: int
    access_cost: int
    new_validation_work: int
    cached_validation_work: int


class RecursiveCompiler:
    """Closed finite state transition with a small trusted proof check."""

    def __init__(self, arity: int = 3) -> None:
        if arity < 2:
            raise ValueError("arity must be at least two")
        self.arity = arity
        self.actions: dict[str, Action] = {
            "successor": Action("successor", 1, None, 1)
        }
        self.proof_cache = {"successor"}
        self.trace: list[Step] = []

    def policy(self) -> Action:
        """Choose the largest proved capability; ties are deterministic."""
        checked = (self.actions[name] for name in self.proof_cache)
        return max(checked, key=lambda action: (action.displacement, action.name))

    def _check(self, candidate: Action) -> None:
        """Symbolically verify T_d^arity(x) = x + arity*d for every integer x."""
        if candidate.parent not in self.proof_cache:
            raise ValueError("a derived action requires a checked parent")
        parent = self.actions[candidate.parent]
        if candidate.arity != self.arity:
            raise ValueError("certificate has the wrong composition arity")
        if candidate.displacement != candidate.arity * parent.displacement:
            raise ValueError("false translation-composition certificate")

    def learn_once(self) -> Step:
        parent = self.policy()
        requested = self.arity * parent.displacement
        name = f"translate-{requested}"
        candidate = Action(name, requested, parent.name, self.arity)
        self._check(candidate)
        self.actions[name] = candidate
        self.proof_cache.add(name)
        step = Step(
            index=len(self.trace) + 1,
            parent=parent.name,
            installed=name,
            requested_displacement=requested,
            base_equivalent_work=requested,
            access_cost=1,
            new_validation_work=self.arity,
            cached_validation_work=self.arity * (len(self.trace) + 1),
        )
        self.trace.append(step)
        return step

    def run(self, steps: int = 12) -> tuple[Step, ...]:
        if steps < 0:
            raise ValueError("steps must be nonnegative")
        return tuple(self.learn_once() for _ in range(steps))

    def replay_proof_cache(self) -> int:
        """Check every DAG node once and return charged local composition work."""
        for action in sorted(self.actions.values(), key=lambda a: a.displacement):
            if action.parent is not None:
                self._check(action)
        return self.arity * (len(self.actions) - 1)

    def expand(self, name: str) -> int:
        """Return base-action count from the recursive certificate, without a table."""
        action = self.actions[name]
        if action.parent is None:
            return 1
        return action.arity * self.expand(action.parent)


def independent_macro_control(steps: int, arity: int = 3) -> int:
    """Known-false control: noncomposing improvements cover only O(steps)."""
    return 1 + steps * (arity - 1)


def first_step_exceeding_hours_to_years(
    arity: int = 3, hours: int = 12, years: int = 12, days_per_year: int = 365
) -> int:
    """Least recursive depth whose access factor exceeds the calendar ratio."""
    ratio_numerator = years * days_per_year * 24
    ratio_denominator = hours
    depth = 0
    factor = 1
    while factor * ratio_denominator < ratio_numerator:
        factor *= arity
        depth += 1
    return depth


def main() -> None:
    compiler = RecursiveCompiler(arity=3)
    trace = compiler.run(12)
    for step in trace:
        print(
            f"{step.index:2d}: {step.parent} -> {step.installed}; "
            f"one access = {step.base_equivalent_work} successors"
        )
    final = trace[-1]
    print("proof DAG nodes:", len(compiler.actions))
    print("full cached proof replay work:", compiler.replay_proof_cache())
    print("12-step access factor:", final.base_equivalent_work)
    print("independent-macro control:", independent_macro_control(12))
    print("first step exceeding 12 years / 12 hours:",
          first_step_exceeding_hours_to_years())


if __name__ == "__main__":
    main()
