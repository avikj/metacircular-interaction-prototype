"""L3 -- extraction under a cost **vector**, and the Pareto frontier of routes.

CRYSTAL.md Sec.2 L3:

    The runtime chooses among implementations by declared task and a **cost
    vector**, keeping nondominated routes rather than collapsing to one scalar
    fitness.

CRYSTAL.md Sec.6, on what is deliberately absent:

    No scalar fitness.

So this module never returns "the best route".  It returns the **Pareto
frontier**: every route that no other route beats on all four components at
once.  ``scalarize`` exists for the caller who genuinely must pick one, and it
requires an explicit, named ``Scalarization``, which is recorded in the result.
There is no default scalarization and there is no implicit tie-break that
amounts to one.

A route
-------
A *route* is a checked proof path from the task's term to some term equal to
it, together with the term it lands on.  Two routes may end at the same term by
different transports (the e-graph's chords), and both are kept -- that is the
automorphism-preservation requirement of CRYSTAL.md Sec.2 L1 restated at the
level of execution.

The four components, and why each is a genuinely different axis
---------------------------------------------------------------
``steps``    exact number of kernel proof steps in the route, counting
             congruence subproofs.  This is the number of ``check_step`` calls
             the checker will make: a *count of kernel work*, not a summary.
``size``     nodes in the extracted term's DAG -- what the runtime must store
             and what every later match must traverse.
``width``    exact-arithmetic width: the sum of the bit lengths of the integer
             literals in the extracted term.  A route that folds ``3^8`` to a
             literal is cheap in ``size`` and expensive here; a route that keeps
             the tower symbolic is the reverse.  Exact integers only.
``verify``   the checker's own counter delta from actually verifying the route.
             Not modelled, *measured*: the trusted heart is run and its counters
             are read.

They are not redundant.  ``steps`` counts the route; ``verify`` counts what
verifying it costs (a short path through a deeply nested congruence is cheap in
``steps`` and dear in ``verify``); ``size`` and ``width`` describe the
destination, and trade against each other directly.

Domination
----------
``a`` dominates ``b`` iff ``a[i] <= b[i]`` for every component and ``a[i] <
b[i]`` for some.  The frontier is the set of routes dominated by nothing.  The
adversarial control in the test suite plants a dominated route and asserts it
is excluded, and asserts ``is_nondominated`` refuses the claim directly.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import term as T
from ..kernel.egraph import EGraph
from .rewrite import Rule, count_steps, expand_path, term_size

__all__ = [
    "COST_NAMES",
    "CostVector",
    "Route",
    "ExtractionResult",
    "Scalarization",
    "ScalarChoice",
    "FrontierDiff",
    "literal_value",
    "arith_width",
    "measure_route", "RouteFinder",
    "extract_routes",
    "dominates",
    "is_nondominated",
    "pareto",
    "scalarize",
    "frontier_diff",
    "COUNTERS",
]

COUNTERS = T.Counters()

COST_NAMES: Tuple[str, ...] = ("steps", "size", "width", "verify")

LITERAL_PREFIX = "#"


def literal_value(t: T.Term) -> Optional[int]:
    """The exact integer a literal constant denotes, or ``None``.

    Literals are ``Const`` symbols of the form ``#<digits>`` (optionally signed).
    Nothing here parses a float; there is no float to parse.
    """
    if t.head != T.CONST or not t.symbol.startswith(LITERAL_PREFIX):
        return None
    body = t.symbol[len(LITERAL_PREFIX):]
    neg = body.startswith("-")
    if neg:
        body = body[1:]
    if not body or not body.isdigit():
        return None
    n = int(body)
    return -n if neg else n


def arith_width(t: T.Term) -> int:
    """Exact-arithmetic width: total bit length of the literals in ``t``."""
    total = 0
    for u in T.subterms(t):
        v = literal_value(u)
        if v is not None:
            total += abs(v).bit_length()
    return total


@dataclass(frozen=True, order=True)
class CostVector:
    """Four exact integers.  No floats, no weights baked in, no total order."""

    steps: int
    size: int
    width: int
    verify: int

    def as_tuple(self) -> Tuple[int, int, int, int]:
        return (self.steps, self.size, self.width, self.verify)

    def render(self) -> str:
        return "steps=%-4d size=%-3d width=%-3d verify=%-5d" % self.as_tuple()


def dominates(a: CostVector, b: CostVector) -> bool:
    """``a`` is at least as good everywhere and strictly better somewhere."""
    x, y = a.as_tuple(), b.as_tuple()
    return all(i <= j for i, j in zip(x, y)) and any(i < j for i, j in zip(x, y))


@dataclass(frozen=True)
class Route:
    """A checked route: where it lands, how it got there, what it cost."""

    target: str
    path: Tuple[C.Step, ...]
    cost: CostVector
    label: str = ""
    variant: int = 0

    def term(self) -> Optional[T.Term]:
        return T.lookup(self.target)

    def pretty(self) -> str:
        t = self.term()
        return t.pretty() if t is not None else self.target[:8]

    def key(self) -> Tuple:
        return (self.cost.as_tuple(), self.target, self.variant)

    def render(self) -> str:
        return "%-30s %s" % (self.pretty(), self.cost.render())


def measure_route(ctx: C.CheckContext, src: T.Term, target: T.Term,
                  path: Sequence[C.Step]) -> Optional[CostVector]:
    """Cost a route, **after** verifying it.  ``None`` if it does not check.

    ``verify`` is the sum of the trusted checker's own counter deltas over the
    verification, which is why it is measured on a fresh probe context: the
    number must describe this route and nothing else.
    """
    path = tuple(path)
    probe = C.CheckContext(axioms=ctx.axioms, certificates=ctx.certificates,
                           fuel=ctx.fuel)
    COUNTERS.bump("extract.verify")
    ok = C.check_path(path, src.recompute_addr(), target.recompute_addr(), probe)
    if not ok:
        COUNTERS.bump("extract.route_rejected")
        return None
    verify = sum(v for _, v in probe.counters.snapshot())
    return CostVector(steps=count_steps(path), size=term_size(target),
                      width=arith_width(target), verify=verify)


# --------------------------------------------------------------------------
# the geodesic: shortest checkable route through the retained justifications
# --------------------------------------------------------------------------

class RouteFinder:
    """Exact shortest proof routes over an e-graph's retained justifications.

    Why this exists.  ``EGraph.explain`` returns the *proof-forest* route, whose
    length depends on the order the merges happened in, not on the mathematics.
    That is fine for "give me a checkable proof" and wrong for "how far apart are
    these two terms", which is the question a geodesic engine is asking.  Adding
    a theorem can make a forest route *longer* purely by changing merge order,
    and a measurement with that artifact in it is not a measurement.

    So: Dijkstra over the justification graph (nodes = addresses, edges = every
    retained ``MergeRecord``, including the chords), with the step count of the
    resulting proof as the distance.  An assumption record costs 1 step.  A
    congruence record costs ``1 + sum of the geodesics between the corresponding
    arguments``, computed recursively -- children are strictly smaller terms, so
    the recursion is well founded, and it is memoised so the subproblems are
    solved once for the whole graph.

    Exactness.  The weight of an edge does not depend on the path taken to reach
    it, so Dijkstra returns a true minimum over the routes expressible in the
    retained justifications.  It is *not* a minimum over all conceivable proofs:
    a proof the e-graph never recorded cannot be found, by construction.

    Uses only the public e-graph API (``records``, ``find``, ``explain``).
    """

    MAX_DEPTH = 24

    def __init__(self, g: EGraph) -> None:
        self.g = g
        self.adj: Dict[str, List[Tuple[int, str, object]]] = {}
        for rec in g.records():
            self.adj.setdefault(rec.a, []).append((rec.mid, rec.b, rec))
            self.adj.setdefault(rec.b, []).append((rec.mid, rec.a, rec))
        for k in self.adj:
            self.adj[k].sort(key=lambda z: z[0])
        self._memo: Dict[Tuple[str, str], Optional[Tuple[C.Step, ...]]] = {}
        self._busy: Dict[Tuple[str, str], None] = {}
        self.expansions = 0
        self.settled = 0

    # -- edges ------------------------------------------------------------
    def _step_for(self, rec, u: str, v: str,
                  depth: int) -> Optional[Tuple[C.Step, int]]:
        if rec.kind == "assumption":
            return (C.Step(u, v, "assumption", rec.witness, rec.edge_id), 1)
        tu, tv = T.lookup(u), T.lookup(v)
        if tu is None or tv is None or len(tu.children) != len(tv.children):
            return None
        subs: List[Tuple[C.Step, ...]] = []
        cost = 1
        for cu, cv in zip(tu.children, tv.children):
            sub = self.route(cu.addr, cv.addr, depth + 1)
            if sub is None:
                return None
            subs.append(sub)
            cost += count_steps(sub)
        return (C.Step(u, v, "congruence", None, rec.edge_id, tuple(subs)), cost)

    # -- the search -------------------------------------------------------
    def route(self, src: str, dst: str, depth: int = 0) -> Optional[Tuple[C.Step, ...]]:
        """The shortest retained proof route ``src = dst``, or ``None``."""
        if src == dst:
            return ()
        key = (src, dst)
        got = self._memo.get(key)
        if got is not None or key in self._memo:
            return got
        if depth > self.MAX_DEPTH or key in self._busy:
            # Depth guard / re-entrancy: fall back to the e-graph's own route,
            # which is always available and always checkable.  Never invent one.
            fb = self.g.explain(src, dst)
            out = None if fb is None else tuple(fb)
            self._memo[key] = out
            return out
        if self.g.find(src) != self.g.find(dst):
            self._memo[key] = None
            return None
        self._busy[key] = None
        try:
            out = self._dijkstra(src, dst, depth)
        finally:
            del self._busy[key]
        self._memo[key] = out
        return out

    def _dijkstra(self, src: str, dst: str, depth: int) -> Optional[Tuple[C.Step, ...]]:
        import heapq
        dist: Dict[str, int] = {src: 0}
        prev: Dict[str, Tuple[str, C.Step]] = {}
        heap: List[Tuple[int, str]] = [(0, src)]
        done: Dict[str, None] = {}
        while heap:
            d, node = heapq.heappop(heap)
            if node in done:
                continue
            done[node] = None
            self.settled += 1
            COUNTERS.bump("extract.settle")
            if node == dst:
                break
            for _, nxt, rec in self.adj.get(node, ()):
                if nxt in done:
                    continue
                got = self._step_for(rec, node, nxt, depth)
                if got is None:
                    continue
                step, w = got
                nd = d + w
                if nd < dist.get(nxt, nd + 1):
                    dist[nxt] = nd
                    prev[nxt] = (node, step)
                    heapq.heappush(heap, (nd, nxt))
        if dst not in dist:
            return None
        chain: List[C.Step] = []
        cur = dst
        while cur != src:
            p, step = prev[cur]
            chain.append(step)
            cur = p
        chain.reverse()
        COUNTERS.bump("extract.geodesic")
        return tuple(chain)


@dataclass(frozen=True)
class ExtractionResult:
    """Every checked route, the frontier, and the exact bookkeeping.

    ``partial_targets`` names the targets where the kernel's homotopy-class
    enumeration stopped on a bound, so a partial enumeration is never mistaken
    for a total one.  ``mode`` records how routes were obtained:

    ``"geodesic"``    the shortest retained route to each target (``RouteFinder``).
                      This is the default and the one the curvature measurement
                      uses: it is a function of the justification graph, not of
                      the order the merges happened in.
    ``"canonical"``   one route per target -- the e-graph's proof-forest route.
                      Complete *as a statement about targets*: every member of
                      the class is reached.  It makes no claim of minimality.
    ``"homotopy"``    one route per homotopy class of proofs per target, from
                      ``EGraph.explanation_classes``.  Complete only where the
                      enumeration said so.
    """

    routes: Tuple[Route, ...]
    frontier: Tuple[Route, ...]
    considered: int
    rejected: int
    partial_targets: Tuple[str, ...]
    mode: str
    reasons: Tuple[str, ...] = ()

    @property
    def complete(self) -> bool:
        return not self.partial_targets

    def render(self) -> str:
        return ("%d route(s) over %d target(s) [%s], %d rejected, frontier %d, %s"
                % (len(self.routes),
                   len({r.target for r in self.routes}), self.mode, self.rejected,
                   len(self.frontier),
                   "complete" if self.complete else
                   "PARTIAL (%d target(s) hit an enumeration bound)"
                   % len(self.partial_targets)))


def extract_routes(g: EGraph, ctx: C.CheckContext, src: T.Term,
                   mode: str = "geodesic",
                   bounds: Optional[Dict[str, int]] = None,
                   targets: Optional[Sequence[str]] = None,
                   max_targets: Optional[int] = None,
                   finder: Optional[RouteFinder] = None) -> ExtractionResult:
    """Enumerate checked routes out of ``src``'s e-class and keep the frontier.

    Every route is verified with ``check_path`` **before** it is costed; one
    that fails is counted in ``rejected`` and never returned.  So the frontier
    contains only routes the trusted checker has accepted.

    With ``mode="homotopy"`` the kernel enumerates one representative per
    *homotopy class* of proofs -- genuinely distinct transports, not a truncated
    list of simple paths -- and this function propagates the enumeration's
    ``complete`` flag into ``partial_targets`` rather than swallowing it.

    ``max_targets`` refuses rather than truncates: passing a value below the
    class size raises, because quietly extracting from part of a class is the
    silent subsetting the spec forbids.
    """
    if mode not in ("geodesic", "canonical", "homotopy"):
        raise ValueError("mode must be geodesic, canonical or homotopy")
    members = tuple(targets) if targets is not None else g.class_of(src)
    if max_targets is not None and len(members) > max_targets:
        raise ValueError("class has %d members, max_targets=%d; raise the bound "
                         "rather than truncate the answer"
                         % (len(members), max_targets))
    if mode == "geodesic" and finder is None:
        finder = RouteFinder(g)
    routes: List[Route] = []
    partial: List[str] = []
    reasons: List[str] = []
    considered = 0
    rejected = 0
    for addr in members:
        target = T.lookup(addr)
        if target is None:
            continue
        if mode == "geodesic":
            one = finder.route(src.addr, addr)
            paths: Tuple[Tuple[C.Step, ...], ...] = () if one is None else (tuple(one),)
        elif mode == "canonical":
            one = g.explain(src, addr)
            paths = () if one is None else (tuple(one),)
        else:
            enum = g.explanation_classes(src, addr, **(bounds or {}))
            if enum.complete:
                classes = enum.classes
            else:
                classes = enum.partial()
                partial.append(addr)
                reasons.append(enum.reason)
            paths = tuple(tuple(c.representative) for c in classes)
        for i, p in enumerate(paths):
            considered += 1
            cost = measure_route(ctx, src, target, p)
            if cost is None:
                rejected += 1
                continue
            routes.append(Route(target=addr, path=tuple(p), cost=cost, variant=i))
    routes.sort(key=lambda r: r.key())
    return ExtractionResult(routes=tuple(routes), frontier=pareto(routes),
                            considered=considered, rejected=rejected,
                            partial_targets=tuple(sorted(partial)),
                            mode=mode, reasons=tuple(sorted(set(reasons))))


# --------------------------------------------------------------------------
# the frontier
# --------------------------------------------------------------------------

def is_nondominated(route: Route, routes: Sequence[Route]) -> bool:
    """Is ``route`` Pareto-optimal within ``routes``?  Adversarial claims that
    a dominated route is optimal are refused here, by construction."""
    return not any(dominates(o.cost, route.cost) for o in routes)


def pareto(routes: Sequence[Route]) -> Tuple[Route, ...]:
    """The nondominated routes, deterministically ordered.

    ``O(n^2)`` comparisons, exact integers only.  Routes with identical cost
    vectors are all kept: equal cost is not domination, and two equally cheap
    but different transports are exactly the plurality the spec protects.
    """
    rs = sorted(routes, key=lambda r: r.key())
    out = [r for r in rs if is_nondominated(r, rs)]
    COUNTERS.bump("extract.pareto")
    return tuple(out)


@dataclass(frozen=True)
class Scalarization:
    """An explicit, named collapse of the cost vector to one exact integer."""

    name: str
    weights: Tuple[int, ...]

    def __post_init__(self) -> None:
        if len(self.weights) != len(COST_NAMES):
            raise ValueError("a scalarization needs %d weights" % len(COST_NAMES))
        for w in self.weights:
            if isinstance(w, float):
                raise ValueError("weights must be exact integers")

    def value(self, cost: CostVector) -> int:
        return sum(w * c for w, c in zip(self.weights, cost.as_tuple()))

    def render(self) -> str:
        return "%s(%s)" % (self.name, ", ".join(
            "%s*%d" % (n, w) for n, w in zip(COST_NAMES, self.weights)))


@dataclass(frozen=True)
class ScalarChoice:
    """The result of a collapse -- and a record of *which* collapse was used."""

    route: Route
    scalarization: Scalarization
    value: int

    def render(self) -> str:
        return ("%s  ->  %s  [value %d under %s]"
                % (self.route.pretty(), self.route.cost.render(), self.value,
                   self.scalarization.render()))


def scalarize(routes: Sequence[Route], scal: Scalarization) -> ScalarChoice:
    """Collapse to one route -- only ever with an explicit scalarization.

    The chosen route is always on the Pareto frontier (a nonnegatively weighted
    sum cannot prefer a dominated point when the weights are nonnegative), and
    the choice records the scalarization so a later reader can tell *why* this
    route won.
    """
    if not routes:
        raise ValueError("no routes to collapse")
    best = min(routes, key=lambda r: (scal.value(r.cost), r.key()))
    COUNTERS.bump("extract.scalarize")
    return ScalarChoice(route=best, scalarization=scal, value=scal.value(best.cost))


# --------------------------------------------------------------------------
# curvature: how the frontier moved
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class FrontierDiff:
    """What a new edge did to the *set* of nondominated routes.

    A theorem can change which routes are Pareto-optimal without shortening the
    best one.  That case is more interesting than a length drop and it is
    reported separately: ``appeared``/``vanished`` nonempty with ``shortened``
    empty is exactly it.
    """

    appeared: Tuple[Route, ...]
    vanished: Tuple[Route, ...]
    shortened: Tuple[Tuple[Route, Route], ...]
    unchanged: Tuple[Route, ...]
    best_steps_before: int
    best_steps_after: int

    @property
    def moved(self) -> bool:
        return bool(self.appeared or self.vanished or self.shortened)

    @property
    def shape_changed_without_shortening(self) -> bool:
        return bool(self.appeared or self.vanished) and not self.shortened

    def render(self) -> str:
        return ("appeared=%d vanished=%d shortened=%d unchanged=%d "
                "best_steps %d->%d"
                % (len(self.appeared), len(self.vanished), len(self.shortened),
                   len(self.unchanged), self.best_steps_before,
                   self.best_steps_after))


def frontier_diff(before: Sequence[Route],
                  after: Sequence[Route]) -> FrontierDiff:
    """Compare two frontiers by destination term.

    A target present in both whose cost strictly improved is *shortened*; one
    present only afterwards *appeared*; one present only before *vanished*
    (which happens when a cheaper route to a different term now dominates it).
    """
    b: Dict[str, Route] = {}
    for r in sorted(before, key=lambda r: r.key()):
        b.setdefault(r.target, r)
    a: Dict[str, Route] = {}
    for r in sorted(after, key=lambda r: r.key()):
        a.setdefault(r.target, r)
    appeared = tuple(a[k] for k in sorted(a) if k not in b)
    vanished = tuple(b[k] for k in sorted(b) if k not in a)
    shortened: List[Tuple[Route, Route]] = []
    unchanged: List[Route] = []
    for k in sorted(set(a) & set(b)):
        if dominates(a[k].cost, b[k].cost):
            shortened.append((b[k], a[k]))
        else:
            unchanged.append(a[k])
    # The empty route to the presentation itself is on every frontier and is
    # not a route in any interesting sense, so the "best" figure excludes it.
    bs = min((r.cost.steps for r in before if r.cost.steps > 0), default=-1)
    as_ = min((r.cost.steps for r in after if r.cost.steps > 0), default=-1)
    return FrontierDiff(appeared=appeared, vanished=vanished,
                        shortened=tuple(shortened), unchanged=tuple(unchanged),
                        best_steps_before=bs, best_steps_after=as_)
