"""L4 -- apply the verdict: recompute only what must be recomputed.

Two claims live here, and both are measured rather than asserted.

**Incrementality.**  ``apply`` re-executes exactly the derivations whose cached
value was invalidated, in dependency order, and reuses everything else *by
object identity*.  The exact cost is compared against ``graph.total_cost()``,
the price of rebuilding the world.  The ratio is the claim; the demo prints it.

**Locality.**  Every cache entry outside the cone is the *same object*
afterwards, not an equal one.  ``verify_untouched`` asserts ``is``.  Equal
values would prove nothing: a full rebuild also produces equal values, which is
precisely the failure this layer exists to avoid.

**Routes.**  A route to a consequence is a homotopy class of its justification;
its length is the class's axiom count.  Retracting a fact can only delete
classes, so routes lengthen or vanish; asserting a fact (a crystallised lemma,
CRYSTAL Sec.3.1) can add a shorter class, so routes shorten.  ``route_table``
and ``route_delta`` handle both directions with one comparison.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, Sequence, Set, Tuple

from ..kernel.egraph import IncompleteEnumeration
from .cone import CacheEntry, DependencyGraph, PropagateError
from .invalidate import DIES, Invalidation, justification_classes

__all__ = [
    "RecomputeReport",
    "intact_cache_ids",
    "apply",
    "verify_untouched",
    "verify_no_stale_reuse",
    "Route",
    "route_table",
    "route_delta",
    "RouteDelta",
]


# ---------------------------------------------------------------------------
# recomputation
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class RecomputeReport:
    retracted: str
    recomputed: Tuple[str, ...]
    dropped: Tuple[str, ...]
    reused: int          # facts outside the cone: untouched, by construction
    cost: int
    full_cost: int
    steps: int

    @property
    def saved(self) -> int:
        return self.full_cost - self.cost

    def render(self) -> str:
        pct = "0" if self.full_cost == 0 else str((self.cost * 100) // self.full_cost)
        return ("recompute after %s: %d re-executed, %d dropped, %d reused | "
                "cost %d vs full rebuild %d (%s%%)"
                % (self.retracted, len(self.recomputed), len(self.dropped),
                   self.reused, self.cost, self.full_cost, pct))


def apply(graph: DependencyGraph, plan: Invalidation) -> RecomputeReport:
    """Perform the retraction described by ``plan`` and repair the cache.

    Order of operations matters and is deliberate:

    1. the survival verdict was computed *before* the mutation, off the complete
       class inventory -- so nothing here has to guess;
    2. the fact is marked retracted, which kills every derivation using it;
    3. dead facts lose their cache entries outright;
    4. surviving-but-stale facts are re-evaluated in dependency order, each
       through its cheapest *live* derivation;
    5. everything outside the cone is not looked at.

    An ``UNDECIDED`` survival aborts: applying a plan built on a partial
    enumeration is exactly the failure this layer exists to prevent.
    """
    if plan.undecided:
        raise IncompleteEnumeration(
            "cannot apply a plan with UNDECIDED survivals: %s"
            % (", ".join(plan.undecided),))
    before = graph.steps.snapshot()
    cone_facts = list(plan.cone.facts)
    in_cone = set(cone_facts)

    graph.mark_retracted(plan.retracted)

    dropped: List[str] = []
    for f in cone_facts:
        if plan.survivals[f].status == DIES:
            graph.drop_cache(f)
            dropped.append(f)

    # Topological order *inside the cone only*.  Premises outside the cone are
    # by definition unaffected, so they count as already placed.  Nothing here
    # iterates the library; the null control measures that it does not.
    todo = [f for f in cone_facts if plan.survivals[f].status != DIES]
    placed: Set[str] = set()
    live_cone: List[str] = []
    progress = True
    while todo and progress:
        progress = False
        rest: List[str] = []
        for f in todo:
            did = graph.chosen_derivation(f)
            prem = () if did is None else graph.derivation(did).premises
            if all((p not in in_cone) or (p in placed) for p in prem):
                live_cone.append(f)
                placed.add(f)
                progress = True
            else:
                rest.append(f)
        todo = rest
    if todo:
        raise PropagateError("dependency cycle inside the cone: %s" % (sorted(todo),))

    recomputed: List[str] = []
    cost = 0
    for f in live_cone:
        did = graph.chosen_derivation(f)
        if did is None:
            # a primitive inside the cone: its value is its own, nothing to do
            continue
        cost += graph._evaluate(f)
        recomputed.append(f)

    steps = sum(n for _, n in graph.steps.delta(before))
    # Reporting only, and deliberately measured *after* the step delta: pricing
    # the full rebuild is an O(library) question, and paying for it inside the
    # incremental path would falsify the very number it is there to contextualise.
    full = graph.total_cost()
    return RecomputeReport(retracted=plan.retracted, recomputed=tuple(recomputed),
                           dropped=tuple(dropped),
                           reused=plan.cone.total_facts - plan.cone.size,
                           cost=cost, full_cost=full, steps=steps)


# ---------------------------------------------------------------------------
# verification
# ---------------------------------------------------------------------------

def intact_cache_ids(graph: DependencyGraph, plan: Invalidation) -> Tuple[str, ...]:
    """Every fact outside the cone.  **Verification only.**

    This is an O(library) scan -- exactly what L4 exists to avoid -- and it is
    never called by ``apply``.  It is here so the demo and the tests can assert
    object identity over the untouched part of the graph.
    """
    inside = set(plan.cone.facts)
    return tuple(f for f in graph.facts() if f not in inside)


def verify_untouched(before: Dict[str, CacheEntry], graph: DependencyGraph,
                     outside: Sequence[str]) -> Tuple[bool, Tuple[str, ...]]:
    """Every cache entry outside the cone must be the *same object*.

    Returns ``(ok, offenders)``.  ``is``, not ``==``.
    """
    bad: List[str] = []
    for f in outside:
        old = before.get(f)
        new = graph.cache_entry(f)
        if old is None and new is None:
            continue
        if old is not new:
            bad.append(f)
    return (not bad), tuple(bad)


def verify_no_stale_reuse(graph: DependencyGraph, plan: Invalidation,
                          before: Dict[str, CacheEntry]) -> Tuple[bool, Tuple[str, ...]]:
    """Detect a "clean" recomputation that silently kept an invalidated cache.

    A fact that survived but whose old cache rested on the retracted fact must
    have a *new* entry object.  If the old object is still installed, the
    runtime is serving a value derived from something it has retracted -- true
    theorem, garbage number.
    """
    bad: List[str] = []
    for f in plan.stale_caches:
        old = before.get(f)
        new = graph.cache_entry(f)
        if old is None:
            continue
        if plan.retracted not in old.support:
            continue                       # was not actually resting on it
        if new is None or new is old:
            bad.append(f)
    return (not bad), tuple(bad)


# ---------------------------------------------------------------------------
# routes
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Route:
    fid: str
    classes: int
    shortest: Optional[int]
    shortest_multiset: Tuple

    def render(self) -> str:
        return "%-10s classes=%d shortest=%s" % (
            self.fid, self.classes,
            "-" if self.shortest is None else self.shortest)


def route_table(graph: DependencyGraph, targets: Sequence[str],
                **bounds) -> Dict[str, Route]:
    """Class count and shortest class per target.  Refuses to guess: an
    incomplete enumeration raises rather than reporting a wrong minimum."""
    out: Dict[str, Route] = {}
    for f in targets:
        enum = justification_classes(graph, f, **bounds)
        cs = enum.classes                      # raises if incomplete -- by design
        if not cs:
            out[f] = Route(f, 0, None, ())
        else:
            best = min(cs, key=lambda c: (c.size, c.multiset))
            out[f] = Route(f, len(cs), best.size, best.multiset)
    return out


SHORTENED = "shortened"
LENGTHENED = "lengthened"
VANISHED = "vanished"
APPEARED = "appeared"
NARROWED = "narrowed"    # same shortest route, strictly fewer distinct routes
WIDENED = "widened"      # same shortest route, strictly more distinct routes
SAME = "unchanged"


@dataclass(frozen=True)
class RouteDelta:
    fid: str
    status: str
    before: Optional[int]
    after: Optional[int]
    classes_before: int
    classes_after: int

    def render(self) -> str:
        return "%-10s %-10s len %s -> %s   classes %d -> %d" % (
            self.fid, self.status,
            "-" if self.before is None else self.before,
            "-" if self.after is None else self.after,
            self.classes_before, self.classes_after)


def route_delta(before: Dict[str, Route], after: Dict[str, Route]
                ) -> Tuple[RouteDelta, ...]:
    out: List[RouteDelta] = []
    for fid in sorted(set(before) | set(after)):
        b = before.get(fid)
        a = after.get(fid)
        bl = b.shortest if b else None
        al = a.shortest if a else None
        if bl is not None and al is None:
            status = VANISHED
        elif bl is None and al is not None:
            status = APPEARED
        elif bl is None and al is None:
            status = VANISHED if (b and b.classes) or (a and a.classes) else SAME
        elif al < bl:
            status = SHORTENED
        elif al > bl:
            status = LENGTHENED
        elif (a.classes if a else 0) < (b.classes if b else 0):
            status = NARROWED
        elif (a.classes if a else 0) > (b.classes if b else 0):
            status = WIDENED
        else:
            status = SAME
        out.append(RouteDelta(fid, status, bl, al,
                              b.classes if b else 0, a.classes if a else 0))
    return tuple(out)
