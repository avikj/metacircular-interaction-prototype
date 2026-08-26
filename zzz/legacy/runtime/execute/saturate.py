"""L3 -- task-bounded equality saturation.

Run a rule set over an e-graph until nothing new is derivable (**fixpoint**) or
a declared budget is spent (**budget exhaustion**), and *say which*.

CRYSTAL.md's cardinal sin is silent subsetting -- returning a partial answer
dressed as a total one.  So ``SaturationResult.status`` is one of

    "fixpoint"              nothing changed in a full pass; the answer is total
    "budget:iterations"     the pass limit was reached with work outstanding
    "budget:applications"   the application limit was reached
    "budget:nodes"          the e-graph node limit was reached
    "budget:ematch"         e-matching hit its own bound (see ematch.py)

and ``is_fixpoint`` is true for exactly one of them.  Callers that need
completeness must test it.  ``report()`` prints the status either way.

Every equality that enters the e-graph is checked first
-------------------------------------------------------
For each match, saturation builds ``lhs[sigma]`` and ``rhs[sigma]``, assembles
the ``Instantiate`` step that justifies them, and hands it to
``kernel/check.py``.  Only if the checker accepts is ``EGraph.merge`` called.
A rule whose justification the checker rejects contributes **zero merges**, and
``rejected`` counts them.  (``runtime/tests/test_execute.py`` plants such a rule
and asserts the merge count is zero.)

Chords
------
``Budget.keep_chords`` controls whether a merge is recorded when the two sides
are *already* equal.  The kernel retains such records as chords -- extra,
independent routes -- which is the automorphism-preservation requirement of
CRYSTAL.md Sec.2 L1, and which is what makes ``EGraph.explanations`` able to
return more than one route.  It defaults to **True** because that content is the
point of the layer.  Turning it off is a scale escape hatch and it is a real
loss: the justification graph becomes a forest and every pair of terms has
exactly one route.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Sequence, Tuple

from ..kernel import check as C
from ..kernel import term as T
from ..kernel.egraph import EGraph, EGraphError
from .ematch import EMatchBudget, EMatchResult, ematch_rule
from .rewrite import Rule

__all__ = ["Budget", "Application", "SaturationResult", "saturate", "COUNTERS"]

COUNTERS = T.Counters()


@dataclass(frozen=True)
class Budget:
    """The declared task bound.  Every field is an exact integer."""

    max_iterations: int = 12
    max_applications: int = 20000
    max_nodes: int = 20000
    ematch: EMatchBudget = field(default_factory=EMatchBudget)
    keep_chords: bool = True

    def render(self) -> str:
        return ("iters<=%d apps<=%d nodes<=%d chords=%s [%s]"
                % (self.max_iterations, self.max_applications, self.max_nodes,
                   "kept" if self.keep_chords else "dropped",
                   self.ematch.render()))


@dataclass(frozen=True)
class Application:
    """One checked rule application that entered the e-graph."""

    rule: str
    direction: str
    src: str
    dst: str
    subst: Tuple[Tuple[str, T.Term], ...]
    edge_id: str
    united: bool


@dataclass(frozen=True)
class SaturationResult:
    status: str
    iterations: int
    applications: int
    unions: int
    chords: int
    rejected: int
    nodes: int
    classes: int
    records: int
    ematch_visits: int
    ematch_partial: bool
    applied: Tuple[Application, ...] = ()

    @property
    def is_fixpoint(self) -> bool:
        return self.status == "fixpoint"

    def render(self) -> str:
        return ("status=%-22s iters=%-3d apps=%-5d unions=%-5d chords=%-5d "
                "rejected=%-3d nodes=%-5d classes=%-4d records=%-5d "
                "ematch_visits=%d%s"
                % (self.status, self.iterations, self.applications, self.unions,
                   self.chords, self.rejected, self.nodes, self.classes,
                   self.records, self.ematch_visits,
                   "  EMATCH PARTIAL" if self.ematch_partial else ""))


def _node_count(g: EGraph) -> int:
    return len(g.terms())


def saturate(g: EGraph, rules: Sequence[Rule], ctx: C.CheckContext,
             budget: Budget = Budget(), tag: str = "sat") -> SaturationResult:
    """Saturate ``g`` under ``rules``, checking every equality before it enters.

    ``tag`` prefixes the generated edge ids so several saturations over one
    graph do not collide.
    """
    applications = 0
    unions = 0
    chords = 0
    rejected = 0
    visits = 0
    partial = False
    status = "fixpoint"
    iterations = 0
    applied: List[Application] = []
    serial = 0
    # One rule instance is one fact.  Re-deriving it on a later pass adds
    # nothing but a duplicate record, so instances are applied at most once.
    # This is *not* chord suppression: two different instances that happen to
    # prove the same equality are both kept (see Budget.keep_chords).
    seen: Dict[Tuple, None] = {}
    if budget.max_iterations < 1:
        status = "budget:iterations"

    for iterations in range(1, budget.max_iterations + 1):
        COUNTERS.bump("saturate.iteration")
        changed = False
        # --- read phase: match everything against the graph as it stands ---
        matches: List[Tuple[Rule, str, Tuple]] = []
        for rule in rules:
            for direction in rule.directions():
                res: EMatchResult = ematch_rule(g, rule, direction, budget.ematch)
                visits += res.visits
                if res.exhausted:
                    partial = True
                for m in res.matches:
                    key = (rule.name, direction,
                           tuple((k, v.addr) for k, v in m.subst))
                    if key in seen:
                        COUNTERS.bump("saturate.instance_seen")
                        continue
                    seen[key] = None
                    matches.append((rule, direction, m.subst))
        # --- write phase: check, then merge ---
        for rule, direction, subst in matches:
            if applications >= budget.max_applications:
                status = "budget:applications"
                break
            pat, out = rule.sides(direction)
            sigma = dict(subst)
            try:
                src = T.subst_consts(pat, sigma)
                dst = T.subst_consts(out, sigma)
            except T.SortError:
                rejected += 1
                COUNTERS.bump("saturate.illsorted")
                continue
            if src is dst:
                continue
            if _node_count(g) >= budget.max_nodes:
                status = "budget:nodes"
                break
            g.add(src)
            g.add(dst)
            step = C.Step(src.recompute_addr(), dst.recompute_addr(),
                          "assumption", C.Instantiate(rule.name, subst), None)
            COUNTERS.bump("saturate.check")
            if not C.check_step(step, ctx):
                rejected += 1
                COUNTERS.bump("saturate.rejected")
                continue
            already = g.equal(src, dst)
            if already and not budget.keep_chords:
                continue
            serial += 1
            edge_id = "%s%06d" % (tag, serial)
            try:
                g.merge(src, dst, C.Instantiate(rule.name, subst), edge_id=edge_id)
            except (EGraphError, T.SortError):
                rejected += 1
                COUNTERS.bump("saturate.merge_refused")
                continue
            applications += 1
            COUNTERS.bump("saturate.application")
            if already:
                chords += 1
            else:
                unions += 1
                changed = True
            applied.append(Application(rule=rule.name, direction=direction,
                                       src=src.addr, dst=dst.addr, subst=subst,
                                       edge_id=edge_id, united=not already))
        if status != "fixpoint":
            break
        if not changed:
            status = "fixpoint"
            break
        if iterations == budget.max_iterations:
            status = "budget:iterations"
            break

    if status == "fixpoint" and partial:
        # e-matching was itself incomplete, so "no change" is not a proof that
        # nothing more is derivable.  Say so rather than claim a fixpoint.
        status = "budget:ematch"

    return SaturationResult(
        status=status, iterations=iterations, applications=applications,
        unions=unions, chords=chords, rejected=rejected,
        nodes=_node_count(g), classes=len(g.classes()),
        records=len(g.records()), ematch_visits=visits,
        ematch_partial=partial, applied=tuple(applied))
