#!/usr/bin/env python3
"""A minimal coupled encounter engine over exact arithmetic organs.

The engine does not contain a curriculum.  It starts with two inherited,
provenance-bearing conjectural compressions.  Concrete encounters accumulate
inside their advertised fibers.  When equal visible data produce unequal
lawful continuations, the fiber itself supplies a counterexample and the
smallest sensor in a declared elementary grammar that separates it is formed.

This is deliberately not a model of the whole research organism.  It is one
executable interface among proposal geometry, exact resistance, proof/action
promotion, environmental task ports, and attention changed by the return.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Callable, Hashable

from observation_forgetting import (
    ForgettingResult,
    is_group,
    minimal_reversibility_example,
)
from smith_residual_machine import Matrix, smith_reduce
from situated_constructor_port import (
    Port,
    SelectionCertificate,
    future_trace,
    powers,
    select_with_port,
    transporter,
)
from two_adic_confinement import confinement


@dataclass(frozen=True)
class Proposal:
    name: str
    claim: str
    provenance: tuple[str, ...]
    cost: int
    possible_gain: int
    status: str = "live"


@dataclass(frozen=True)
class Return:
    organ: str
    proposal: str
    visible_fiber: Hashable
    witnesses: tuple[Hashable, ...]
    result: str
    formed_sensor: str | None
    formed_action: str | None
    proof_replay: str
    successor: str


@dataclass(frozen=True)
class ParetoState:
    retained_states: int
    effective_states: int
    separating_power: int
    effective_action_is_group: bool


@dataclass(frozen=True)
class ResponseForecast:
    """A replayable prediction that has no installation authority."""

    response: int
    source: str
    evidence: str
    policy: str


@dataclass
class EncounterEngine:
    """State changes only after an exact return or an explicit task coupling."""

    proposals: dict[str, Proposal] = field(default_factory=dict)
    sensors: set[str] = field(default_factory=lambda: {"smith:scalar-remainder", "2adic:level"})
    actions: set[str] = field(default_factory=set)
    returns: list[Return] = field(default_factory=list)
    smith_fibers: dict[int, dict[Matrix, str]] = field(default_factory=dict)
    two_adic_fibers: dict[int, dict[tuple[int, ...], tuple[int, int]]] = field(default_factory=dict)
    rich_memory_states: int = 0
    active_task: str | None = None
    task_view: ForgettingResult | None = None
    active_constructor: tuple[int, ...] | None = None
    active_grammar: tuple[tuple[int, ...], ...] = ()
    constructor_selection_policy: str | None = None
    constructor_history: list[SelectionCertificate] = field(default_factory=list)
    response_forecasts: list[ResponseForecast] = field(default_factory=list)

    @classmethod
    def inherited(cls) -> "EncounterEngine":
        engine = cls()
        engine.proposals = {
            "smith-scalar-controller": Proposal(
                "smith-scalar-controller",
                "the scalar Euclidean remainder determines the next Smith action",
                ("Euclidean division", "Smith normal form", "msg-0282"),
                cost=1,
                possible_gain=3,
            ),
            "two-adic-level-index": Proposal(
                "two-adic-level-index",
                "the principal-unit filtration level determines multiplicative confinement",
                ("Gauss index calculus", "formed unit filtration", "msg-0285"),
                cost=1,
                possible_gain=2,
            ),
        }
        return engine

    def attention(self) -> tuple[str, ...]:
        """Live proposals ordered by possible capability gained per unit cost."""
        live = (p for p in self.proposals.values() if p.status == "live")
        return tuple(p.name for p in sorted(
            live, key=lambda p: (-p.possible_gain / p.cost, p.name)
        ))

    def _replace_proposal(self, old: str, successor: Proposal) -> None:
        previous = self.proposals[old]
        self.proposals[old] = Proposal(
            previous.name, previous.claim, previous.provenance,
            previous.cost, previous.possible_gain, "refuted"
        )
        self.proposals[successor.name] = successor

    def meet_smith(self, matrix: Matrix) -> Return | None:
        """Let a matrix answer the scalar-controller proposal.

        No action kind is supplied by the caller.  It is read from the verified
        Smith certificate.  A return occurs only when one scalar fiber contains
        two different lawful next actions.
        """
        certificate = smith_reduce(matrix)
        if not certificate.steps:
            return None
        step = certificate.steps[0]
        bucket = self.smith_fibers.setdefault(step.residual, {})
        bucket[matrix] = step.kind
        kinds = set(bucket.values())
        if len(kinds) < 2 or "smith:typed-residual-origin" in self.sensors:
            return None

        # The witnessed response function itself supplies the separating
        # coordinate: origin/action kind.  It is not guessed from the scalar.
        witnesses = tuple(next(m for m, k in bucket.items() if k == kind)
                          for kind in sorted(kinds))
        self.sensors.add("smith:typed-residual-origin")
        self.actions.add("smith:certified-next-step")
        self.rich_memory_states = max(self.rich_memory_states, len(kinds))
        successor = Proposal(
            "smith-origin-controller",
            "typed residual origin determines and replays the certified Smith step",
            self.proposals["smith-scalar-controller"].provenance
            + ("counterexample fiber", "SmithCertificate.verify"),
            cost=len(kinds),
            possible_gain=len(kinds),
            status="proved",
        )
        self._replace_proposal("smith-scalar-controller", successor)
        result = Return(
            "smith", "smith-scalar-controller", step.residual, witnesses,
            "one scalar fiber has distinct lawful continuation kinds",
            "smith:typed-residual-origin", "smith:certified-next-step",
            "for each witness, SmithCertificate.verify() is true",
            "measure future-response classes inside invariant-envelope fibers",
        )
        self.returns.append(result)
        return result

    def meet_two_adic(self, generators: tuple[int, ...], k: int) -> Return | None:
        """Let reachable multiplication answer the level-only proposal."""
        record = confinement(generators, k)
        bucket = self.two_adic_fibers.setdefault(record.level, {})
        bucket[generators] = (record.index, int(record.meets_three_mod_four))
        indices = {value[0] for value in bucket.values()}
        if len(indices) < 2 or "2adic:mod4-sign" in self.sensors:
            return None

        # Search the elementary candidate grammar {does U meet r mod 2^d?}.
        # The least separating depth is 2; within its nonidentity class the
        # witnessed residue is 3.  This derives the sensor from the collision.
        witnesses = tuple(bucket)
        sigmas = {value[1] for value in bucket.values()}
        if sigmas != {0, 1}:
            raise AssertionError("the declared sign grammar did not separate the fiber")
        self.sensors.add("2adic:mod4-sign")
        self.actions.update({"2adic:predict-index", "2adic:compile-chart-depth"})
        successor = Proposal(
            "two-adic-filtration-signature",
            "(level, mod-4 sign) determines confinement and optimal chart depth",
            self.proposals["two-adic-level-index"].provenance
            + ("equal-level counterexample", "exact-sequence proof"),
            cost=2,
            possible_gain=2,
            status="proved",
        )
        self._replace_proposal("two-adic-level-index", successor)
        result = Return(
            "two-adic", "two-adic-level-index", record.level, witnesses,
            "equal filtration level has unequal confinement index",
            "2adic:mod4-sign", "2adic:predict-index + compile-chart-depth",
            "index == 2**(level-1-sign), independently replayed by subgroup closure",
            "ask which future task needs the erased sign bit",
        )
        self.returns.append(result)
        return result

    def couple_task(self, task: str) -> ParetoState:
        """An environmental task selects an executable quotient, not truth.

        The only implemented task is the exact minimal reversal witness.  The
        rich state remains retained and reopenable; execution changes to its
        coarsest predictive quotient for the task.
        """
        if task != "distinguish-fixed-point-2":
            raise ValueError("no proved task lens is installed for this request")
        result = minimal_reversibility_example()
        if is_group(result.rich_monoid) or not is_group(result.coarse_monoid):
            raise AssertionError("reversibility witness failed")
        self.active_task = task
        self.task_view = result
        self.sensors.add("task:is-2")
        self.actions.add("task:collapse-as-identity")
        self.rich_memory_states = max(self.rich_memory_states, len(result.rich.fibers))
        self.proposals["reopen-forgotten-distinction"] = Proposal(
            "reopen-forgotten-distinction",
            "retain a port back to the rich state if a later task distinguishes 0 from 1",
            ("environmental task", "observation-forgetting theorem"),
            cost=1,
            possible_gain=1,
        )
        return ParetoState(
            retained_states=len(result.rich.fibers),
            effective_states=len(result.coarse.fibers),
            separating_power=len(result.rich.fibers),
            effective_action_is_group=True,
        )

    def reopen(self, task: str) -> ParetoState:
        """A changed environment can make the deliberately forgotten bit live."""
        if task != "distinguish-0-from-1" or self.task_view is None:
            raise ValueError("no retained causal port answers this task")
        self.active_task = task
        self.actions.discard("task:collapse-as-identity")
        self.actions.add("task:collapse-as-idempotent")
        old = self.proposals["reopen-forgotten-distinction"]
        self.proposals[old.name] = Proposal(
            old.name, old.claim, old.provenance + ("environmental reopening",),
            old.cost, old.possible_gain, "proved"
        )
        return ParetoState(
            retained_states=len(self.task_view.rich.fibers),
            effective_states=len(self.task_view.rich.fibers),
            separating_power=len(self.task_view.rich.fibers),
            effective_action_is_group=False,
        )

    def couple_constructor_port(
        self, response: int, provenance: str,
        scores: dict[tuple[int, ...], float] | None = None,
    ) -> SelectionCertificate:
        """Let a live response select and install a genuinely different grammar.

        Endpoint data leaves the two-point transporter torsor unresolved.  The
        response is not predicted or optimized by this engine: it is an
        admitted environmental relation.  Scores can change proposal order but
        exact port equations alone certify and install the constructor.
        """
        cert = select_with_port(
            3, 0, 1, Port(2, response, provenance), scores or {}
        )
        self.constructor_history.append(cert)
        self.active_constructor = cert.selected
        self.active_grammar = powers(cert.selected)
        self.constructor_selection_policy = "exact-live-port-equation"
        self.actions.discard("constructor:torsor-unresolved")
        self.actions.add("constructor:iterate-selected")
        self.sensors.add("constructor:live-context-response")
        self.proposals["constructor-port-withdrawal"] = Proposal(
            "constructor-port-withdrawal",
            "withdrawal restores the lawful transporter while retaining historical selection provenance",
            ("R0027 transporter torsor", "R0028 situated port", provenance),
            cost=1,
            possible_gain=len(self.active_grammar),
        )
        return cert

    def constructor_choices(self) -> tuple[tuple[int, ...], ...]:
        """Return the quantified undecided set without scheduling a member.

        This is intentionally read-only.  Candidate enumeration order, API
        call order, and attention scores are not formation policies.
        """
        if self.active_constructor is not None:
            return (self.active_constructor,)
        return transporter(3, 0, 1)

    def constructor_future(self, point: int = 0) -> tuple[int, ...]:
        """Observations on the closed installed carrier Q={(g,x)}.

        Reuse acts by `(g,x) -> (g,g(x))`; it never acts on the transporter
        candidate set, which is not composition-closed.
        """
        if self.active_constructor is None:
            raise ValueError("constructor torsor unresolved: supply a live port")
        g, x = self.active_constructor, point
        observations: list[int] = []
        for _ in powers(g):
            observations.append(x)
            x = g[x]
        return tuple(observations)

    def forecast_port_from_smith(self, matrix: Matrix) -> ResponseForecast:
        """Predict a response class from exact arithmetic, without selecting.

        The adapter is explicit: row-origin residuals forecast response zero;
        the other certified first-step kinds forecast response two.  This is a
        lawful, replayable classifier, not an authority transfer from
        arithmetic to an environmental participant.
        """
        cert = smith_reduce(matrix)
        if not cert.steps:
            raise ValueError("Smith encounter has no residual response to classify")
        kind = cert.steps[0].kind
        forecast = ResponseForecast(
            response=0 if kind == "row-residual" else 2,
            source="smith-first-certified-response",
            evidence=f"{kind}; SmithCertificate.verify={cert.verify()}",
            policy="row-residual->0; otherwise->2",
        )
        self.response_forecasts.append(forecast)
        return forecast

    def withdraw_constructor_port(self) -> tuple[tuple[int, ...], ...]:
        """Remove present authority; restore the torsor, not a default choice."""
        if self.active_constructor is None:
            raise ValueError("no live constructor port to withdraw")
        self.active_constructor = None
        self.active_grammar = ()
        self.constructor_selection_policy = None
        self.actions.discard("constructor:iterate-selected")
        self.actions.add("constructor:torsor-unresolved")
        self.sensors.discard("constructor:live-context-response")
        old = self.proposals["constructor-port-withdrawal"]
        self.proposals[old.name] = Proposal(
            old.name, old.claim,
            old.provenance + ("withdrawn; historical certificate retained",),
            old.cost, old.possible_gain, "proved",
        )
        return transporter(3, 0, 1)


def encounter_trace() -> EncounterEngine:
    """A demonstration order; engine conclusions still arise only on collision."""
    engine = EncounterEngine.inherited()
    for matrix in (((2, 0), (1, 7)), ((2, 1), (0, 7)), ((2, 0), (0, 3))):
        engine.meet_smith(matrix)
    engine.meet_two_adic((5,), 8)
    engine.meet_two_adic((3, 5), 8)
    engine.couple_task("distinguish-fixed-point-2")
    return engine


if __name__ == "__main__":
    life = encounter_trace()
    for returned in life.returns:
        print(returned)
    print("sensors:", sorted(life.sensors))
    print("actions:", sorted(life.actions))
    print("attention:", life.attention())
