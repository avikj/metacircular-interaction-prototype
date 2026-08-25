"""The bridge: proof geodesics and light geodesics as **one** routing problem.

The thesis, stated so it can be killed
--------------------------------------
L3's route extraction finds the cost-minimal proof route through the
justification graph.  Fermat's principle says light takes the stationary-time
path.  The claim under test is that these are *one mechanism*, not two things
that rhyme.

What is actually true, after building it, in three parts:

**(a) The search is literally one algorithm.**  ``geodesic()`` below is a
single Dijkstra over a string-keyed weighted digraph whose weights need only be
a monoid with a total order compatible with addition.  Instantiated with L3's
own adjacency and L3's own edge-weight function it reproduces
``execute.extract.RouteFinder.route`` **step for step** -- the test asserts the
returned proof paths are identical objects-by-value on the full ``3^8`` graph
from ``demo/geodesic_demo.py``, not merely the same length.  Instantiated with
optical path lengths it returns Fermat's ray.  The two instantiations differ in
one thing: the weight type, ``int`` versus ``Surd``.

**(b) The frontier is literally one piece of code.**  ``dominates``,
``is_nondominated``, ``pareto``, ``scalarize`` and ``frontier_diff`` are
*imported from* ``runtime.execute.extract`` and called on optical routes with
no wrapper and no copy.  ``SHARED_CODE`` names them and the test asserts each
one's ``__module__`` is still ``runtime.execute.extract``.  They work because
``CostVector`` is consumed only through ``as_tuple()`` and componentwise ``<=``
-- ``OpticalCost`` supplies a ``Surd`` in the leading slot and the exact same
domination code runs.

**(c) What is NOT literally reused, said plainly.**
``RouteFinder._dijkstra`` itself is not called on the optics problem, and
cannot be: its weights are Python ``int``s accumulated as ``d + w``, and an
optical path length is not an integer.  Rewriting L3 to be weight-generic is a
small change to a BUILT, mutation-tested layer and this lane does not have the
mandate to make it.  So the honest statement is: **the shared abstraction
is implemented here and L3's extractor is shown to be an instance of it, by
running L3's adjacency and weights through it and asserting equality.**  That
is a checked claim, not a metaphor and not a copy-paste.

**(d) The disanalogy that survives all of the above.**  Fermat is a
*stationarity* principle, ``delta OPL = 0``; extraction is *minimisation*.
Minimal implies stationary; the converse is false, and the failure is not
exotic -- a concave mirror's focusing ray is a path-length **maximum**.
``MirrorRouteProblem`` builds one exactly, and this module's routing machinery gets
it wrong, on purpose, in the open.  The precise repair is not "search harder":
it is ``convexity_certificate``, which states the exact condition under which
the identification is licensed and refuses to issue when it is not.

Everything is exact.  Weights are ``int`` or ``Surd``; there is no float in
this module, no division operator in its source, and no square root is ever
evaluated numerically.
"""

from __future__ import annotations

import heapq
from dataclasses import dataclass
from fractions import Fraction
from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple

from ..kernel import check as C
from ..kernel import edges as E
from ..kernel import term as T
from ..kernel.egraph import EGraph
from ..execute.extract import (RouteFinder, dominates, frontier_diff,
                               is_nondominated, pareto, scalarize,
                               Route, Scalarization)
from . import optics as O
from .dimension import Dimension, Quantity, exact, quantity
from .optics import Surd, Vec

__all__ = [
    "GeodesicError", "TrustBoundaryError",
    "Arc", "RouteProblem", "GeodesicResult", "geodesic",
    "ProofRouteProblem", "OpticsRouteProblem", "MirrorRouteProblem",
    "OpticalCost", "optical_routes", "optical_frontier",
    "certify_optical_length",
    "ConvexityCertificate", "convexity_certificate",
    "SnellBracket", "snell_bracket",
    "Realization", "realize",
    "mirror_routes",
    "SHARED_CODE", "NOT_SHARED",
    "COUNTERS",
]

COUNTERS = T.Counters()


class GeodesicError(Exception):
    pass


class TrustBoundaryError(Exception):
    """Raised when a declared certificate claims machine verification it lacks."""


# --------------------------------------------------------------------------
# THE SHARED ABSTRACTION
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Arc:
    """One relaxable edge.

    ``order`` gives the deterministic scan order out of a node (L3 uses the
    merge-record id; optics uses the lattice index).  ``weight`` may be any type
    supporting ``+`` with the problem's ``zero`` and a total order; ``payload``
    is whatever the caller needs to reconstruct the route -- a ``check.Step``
    for proofs, an optical segment for light.
    """

    order: int
    dst: str
    weight: Any
    payload: Any = None


class RouteProblem:
    """A weighted digraph over string nodes, with an additive ordered weight.

    Three requirements, and they are exactly the requirements of Dijkstra:

    1. ``zero`` is the additive identity of the weight type;
    2. every arc weight is ``>= zero`` (no negative optical lengths, no
       negative proof steps);
    3. the order is total and ``a <= b  =>  a + w <= b + w``.

    Both instantiations satisfy all three exactly: ``int`` trivially, and
    ``Surd`` because its order is the order of the reals it denotes and its
    ``sign`` is exact.
    """

    name = "abstract"
    zero: Any = 0

    def arcs(self, node: str) -> Sequence[Arc]:
        raise NotImplementedError

    def describe(self, node: str) -> str:
        return node


@dataclass(frozen=True)
class GeodesicResult:
    """The route, its total weight, and exact counters for the search itself."""

    src: str
    dst: str
    found: bool
    weight: Any
    arcs: Tuple[Arc, ...]
    settled: int
    relaxed: int
    problem: str

    def nodes(self) -> Tuple[str, ...]:
        return (self.src,) + tuple(a.dst for a in self.arcs)

    def payloads(self) -> Tuple[Any, ...]:
        return tuple(a.payload for a in self.arcs)

    def render(self) -> str:
        w = self.weight
        return ("%s: %s -> %s  weight=%s  settled=%d relaxed=%d"
                % (self.problem, self.src[:10], self.dst[:10],
                   w.render() if isinstance(w, Surd) else str(w),
                   self.settled, self.relaxed))


def geodesic(problem: RouteProblem, src: str, dst: str) -> GeodesicResult:
    """Dijkstra.  One implementation, two physics.

    Deterministic: the frontier is ordered by ``(weight, node)`` with node names
    as the tie-break, and arcs out of a node are scanned in ``Arc.order``.  This
    is the *same* tie-break discipline ``RouteFinder._dijkstra`` uses, which is
    why the proof instantiation reproduces its routes exactly rather than merely
    matching their length.
    """
    COUNTERS.bump("geodesic.search")
    zero = problem.zero
    dist: Dict[str, Any] = {src: zero}
    prev: Dict[str, Tuple[str, Arc]] = {}
    heap: List[Tuple[Any, str]] = [(zero, src)]
    done: Dict[str, None] = {}
    settled = 0
    relaxed = 0
    while heap:
        d, node = heapq.heappop(heap)
        if node in done:
            continue
        done[node] = None
        settled += 1
        COUNTERS.bump("geodesic.settle")
        if node == dst:
            break
        for arc in problem.arcs(node):
            if arc.dst in done:
                continue
            nd = d + arc.weight
            relaxed += 1
            COUNTERS.bump("geodesic.relax")
            cur = dist.get(arc.dst)
            if cur is None or nd < cur:
                dist[arc.dst] = nd
                prev[arc.dst] = (node, arc)
                heapq.heappush(heap, (nd, arc.dst))
    if dst not in dist:
        return GeodesicResult(src=src, dst=dst, found=False, weight=zero, arcs=(),
                              settled=settled, relaxed=relaxed, problem=problem.name)
    chain: List[Arc] = []
    cur = dst
    while cur != src:
        p, arc = prev[cur]
        chain.append(arc)
        cur = p
    chain.reverse()
    return GeodesicResult(src=src, dst=dst, found=True, weight=dist[dst],
                          arcs=tuple(chain), settled=settled, relaxed=relaxed,
                          problem=problem.name)


# --------------------------------------------------------------------------
# INSTANTIATION 1 -- proof routes.  L3's own adjacency and L3's own weights.
# --------------------------------------------------------------------------

class ProofRouteProblem(RouteProblem):
    """L3's justification graph, presented as a ``RouteProblem``.

    This does not reimplement anything.  It holds an ``execute.extract.
    RouteFinder`` and reads its ``adj`` table and calls its ``_step_for`` for
    every weight -- including the recursive congruence weighting, where the cost
    of a congruence edge is ``1 + sum of the geodesics between the arguments``
    and that inner recursion is L3's, memoised in L3's memo table.

    Reaching for a leading-underscore method is deliberate and is the point: if
    L3 changes how a proof step is weighted, this bridge changes with it,
    because there is no second copy of that logic.  A bridge that had copied it
    would keep working and would have stopped being a bridge.
    """

    name = "proof"
    zero = 0

    def __init__(self, g: EGraph) -> None:
        self.g = g
        self.finder = RouteFinder(g)

    def arcs(self, node: str) -> Sequence[Arc]:
        out: List[Arc] = []
        for mid, nxt, rec in self.finder.adj.get(node, ()):
            got = self.finder._step_for(rec, node, nxt, 0)
            if got is None:
                continue
            step, w = got
            out.append(Arc(order=mid, dst=nxt, weight=w, payload=step))
        return tuple(out)

    def describe(self, node: str) -> str:
        t = T.lookup(node)
        return t.pretty() if t is not None else node[:10]

    # -- the claim, made checkable ---------------------------------------
    def matches_l3(self, src: str, dst: str) -> Tuple[bool, Optional[Tuple[C.Step, ...]],
                                                      Optional[Tuple[C.Step, ...]]]:
        """Run both and compare.  ``(agree, mine, l3's)``."""
        mine = geodesic(self, src, dst)
        theirs = RouteFinder(self.g).route(src, dst)
        got = mine.payloads() if mine.found else None
        return (got == (None if theirs is None else tuple(theirs)), got,
                None if theirs is None else tuple(theirs))


# --------------------------------------------------------------------------
# INSTANTIATION 2 -- light routes through a stack of media
# --------------------------------------------------------------------------

def _node(level: int, i: int) -> str:
    return "x%d:%d" % (level, i)


SOURCE = "SOURCE"
TARGET = "TARGET"


class OpticsRouteProblem(RouteProblem):
    """An ``InterfaceStack`` presented as a ``RouteProblem``.

    Nodes: ``SOURCE``, one per (interface, lattice point), ``TARGET``.  Arcs run
    strictly downward through the stack, so the graph is a layered DAG and
    Dijkstra's answer is the exact minimum over the whole discrete family --
    over ``prod_i |lattice_i|`` rays, with ``sum_i |lattice_i| * |lattice_{i+1}|``
    arc evaluations rather than that product.  (On the demo's three-medium
    stack: 1813 rays, reached by 1849 arcs.)

    Arc weight = the exact optical length of that segment = ``n * sqrt(dx^2+dy^2)``
    as a ``Surd``.  **Nothing here knows Snell's law.**  The only physics in the
    weight is "optical length of a straight segment in a homogeneous medium",
    which is the definition of the OPL functional, not a solution of it.
    """

    name = "light"

    def __init__(self, stack: O.InterfaceStack) -> None:
        self.stack = stack
        self.zero = Surd.zero()
        self._pts: List[Tuple[Vec, ...]] = [
            tuple(stack.crossing(i, x) for x in lat)
            for i, lat in enumerate(stack.lattices)]

    # -- graph ------------------------------------------------------------
    def _seg(self, medium: O.Medium, p: Vec, q: Vec) -> Surd:
        COUNTERS.bump("light.segment")
        return Surd.scaled_sqrt(medium.index, q.minus(p).norm2())

    def arcs(self, node: str) -> Sequence[Arc]:
        st = self.stack
        if node == TARGET:
            return ()
        if node == SOURCE:
            return tuple(Arc(order=i, dst=_node(0, i),
                             weight=self._seg(st.media[0], st.source, p))
                         for i, p in enumerate(self._pts[0]))
        level, idx = (int(v) for v in node[1:].split(":"))
        here = self._pts[level][idx]
        if level == st.depth - 1:
            return (Arc(order=0, dst=TARGET,
                        weight=self._seg(st.media[-1], here, st.target)),)
        return tuple(Arc(order=j, dst=_node(level + 1, j),
                         weight=self._seg(st.media[level + 1], here, q))
                     for j, q in enumerate(self._pts[level + 1]))

    def describe(self, node: str) -> str:
        if node in (SOURCE, TARGET):
            return node
        level, idx = (int(v) for v in node[1:].split(":"))
        return "interface%d@%s" % (level, self._pts[level][idx].render())

    # -- reading the answer back as physics -------------------------------
    def crossings(self, result: GeodesicResult) -> Tuple[Fraction, ...]:
        out: List[Fraction] = []
        for n in result.nodes():
            if n in (SOURCE, TARGET):
                continue
            level, idx = (int(v) for v in n[1:].split(":"))
            out.append(self._pts[level][idx].x)
        return tuple(out)


class MirrorRouteProblem(RouteProblem):
    """Reflection off a discrete family of mirror points: ``SOURCE -> p_i -> TARGET``.

    Structurally identical to ``OpticsRouteProblem`` with one interior layer.
    It exists to make the disanalogy concrete: on this problem the cost-minimal
    route is a physical ray, and so is the cost-*maximal* one, and the
    machinery can only ever return the former.
    """

    name = "mirror"

    def __init__(self, source: Vec, target: Vec, points: Sequence[Vec],
                 medium: O.Medium) -> None:
        self.source = source
        self.target = target
        self.points = tuple(points)
        self.medium = medium
        self.zero = Surd.zero()

    def _seg(self, p: Vec, q: Vec) -> Surd:
        COUNTERS.bump("mirror.segment")
        return Surd.scaled_sqrt(self.medium.index, q.minus(p).norm2())

    def arcs(self, node: str) -> Sequence[Arc]:
        if node == TARGET:
            return ()
        if node == SOURCE:
            return tuple(Arc(order=i, dst=_node(0, i),
                             weight=self._seg(self.source, p))
                         for i, p in enumerate(self.points))
        idx = int(node[1:].split(":")[1])
        return (Arc(order=0, dst=TARGET,
                    weight=self._seg(self.points[idx], self.target)),)

    def values(self) -> Tuple[Surd, ...]:
        """The OPL of reflecting at each point, in the family's cyclic order."""
        return tuple(self._seg(self.source, p) + self._seg(p, self.target)
                     for p in self.points)

    def describe(self, node: str) -> str:
        if node in (SOURCE, TARGET):
            return node
        return self.points[int(node[1:].split(":")[1])].render()

    def index_of(self, result: GeodesicResult) -> Optional[int]:
        for n in result.nodes():
            if n not in (SOURCE, TARGET):
                return int(n[1:].split(":")[1])
        return None


# --------------------------------------------------------------------------
# THE COST VECTOR -- same shape, same domination code, different units
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class OpticalCost:
    """Four exact components, in bijection with L3's ``CostVector``.

    | L3 (proof)                       | here (light)                          |
    |----------------------------------|---------------------------------------|
    | ``steps``  kernel proof steps    | ``opl``    exact optical path length  |
    | ``size``   nodes in the term DAG | ``hops``   segments in the ray        |
    | ``width``  bits in the literals  | ``width``  bits in the crossing coords|
    | ``verify`` checker counter delta | ``verify`` certifier counter delta    |

    In both cases the first component is the *action being minimised*, the
    middle two describe the object landed on, and the last is the measured cost
    of checking the claim -- run and read, never modelled.  ``as_tuple`` is the
    entire interface ``execute.extract.dominates`` consumes, which is why that
    function needs no modification to rank light against light.
    """

    opl: Surd
    hops: int
    width: int
    verify: int

    def as_tuple(self) -> Tuple[Any, int, int, int]:
        return (self.opl, self.hops, self.width, self.verify)

    def render(self) -> str:
        return "opl=%-11s hops=%-2d width=%-3d verify=%-4d" % (
            self.opl.render_approx(4), self.hops, self.width, self.verify)


def certify_optical_length(ray: O.Ray, claimed: Surd) -> Tuple[bool, int]:
    """Recompute the OPL from the ray and compare exactly; return ``(ok, cost)``.

    ``cost`` is the delta of ``optics.COUNTERS`` across the recomputation --
    the certifier's own counters, measured the way L3 measures ``verify`` by
    reading ``check.py``'s counters rather than estimating them.
    """
    before = O.COUNTERS.snapshot()
    recomputed = O.optical_path_length(ray)
    ok = recomputed.compare(claimed) == 0 and (recomputed - claimed).is_zero()
    cost = sum(v for _, v in O.COUNTERS.delta(before))
    COUNTERS.bump("light.certify")
    return (ok, cost)


def optical_routes(stack: O.InterfaceStack,
                   crossings: Optional[Sequence[Sequence[Fraction]]] = None,
                   certifier: Optional[Callable[[O.Ray, Surd],
                                                Tuple[bool, int]]] = None
                   ) -> Tuple[Route, ...]:
    """Every candidate ray as an ``execute.extract.Route``, certified first.

    A ray whose optical length fails independent recomputation is dropped, in
    the same place and for the same reason L3 drops a route the checker
    rejects: the frontier contains only certified routes.  ``certifier`` is
    injectable so the test suite can plant a refusing certifier and check that
    the gate is really load-bearing rather than decorative.
    """
    certify = certifier or certify_optical_length
    out: List[Route] = []
    xs_list = list(crossings) if crossings is not None else list(stack.paths())
    for xs in xs_list:
        ray = stack.ray(xs)
        opl = O.optical_path_length(ray)
        ok, verify = certify(ray, opl)
        if not ok:
            COUNTERS.bump("light.route_rejected")
            continue
        cost = OpticalCost(opl=opl, hops=len(ray.media), width=ray.width(),
                           verify=verify)
        label = ",".join(p.render() for p in ray.points[1:-1])
        out.append(Route(target=label, path=(), cost=cost, label=label))
    out.sort(key=lambda r: r.key())
    return tuple(out)


def mirror_routes(problem: "MirrorRouteProblem") -> Tuple[Route, ...]:
    """Every reflection as an ``execute.extract.Route``.

    Used to make the disanalogy sharp: the Pareto frontier over this family
    keeps *tied* minima (equal cost is not domination) and therefore returns
    both grazing rays -- and still cannot return either of the two maxima,
    which are equally physical.
    """
    out: List[Route] = []
    for i, p in enumerate(problem.points):
        ray = O.Ray((problem.source, p, problem.target),
                    (problem.medium, problem.medium))
        opl = O.optical_path_length(ray)
        ok, verify = certify_optical_length(ray, opl)
        if not ok:                                   # pragma: no cover - control
            continue
        out.append(Route(target="m%d" % i, path=(),
                         cost=OpticalCost(opl=opl, hops=2, width=ray.width(),
                                          verify=verify),
                         label=p.render(), variant=i))
    out.sort(key=lambda r: r.key())
    return tuple(out)


def optical_frontier(routes: Sequence[Route]) -> Tuple[Route, ...]:
    """L3's ``pareto``, called on light.  Not a wrapper -- the same function."""
    return pareto(routes)


# --------------------------------------------------------------------------
# WHERE THE IDENTIFICATION IS LICENSED -- and where it is not
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class ConvexityCertificate:
    """Exact statement of when "cost-minimal route" == "physical ray".

    Fermat gives ``delta OPL = 0``.  Extraction gives ``min OPL``.  These agree
    exactly when the OPL restricted to the path family has no stationary point
    that is not its minimum.  On a one-parameter family that is implied by
    *strict discrete convexity*: ``v[i+1] - 2 v[i] + v[i-1] > 0`` at every
    interior ``i``, checked here with exact ``Surd`` signs at every point of the
    lattice, not argued from a picture.

    When it issues (``licensed`` true) the runtime may say "the extracted route
    is the physical ray, up to the lattice".  When it does not issue, the
    runtime must say only "the extracted route is the cheapest member of the
    family", and the demo makes it say exactly that.
    """

    family: str
    samples: int
    licensed: bool
    violations: Tuple[int, ...]
    minimum_index: int
    note: str

    def render(self) -> str:
        return ("%s: %d samples, strict discrete convexity %s%s"
                % (self.family, self.samples,
                   "HOLDS -- minimisation == stationarity here" if self.licensed
                   else "FAILS",
                   "" if self.licensed
                   else " at %d interior point(s) %s"
                   % (len(self.violations), self.violations[:6])))


def convexity_certificate(values: Sequence[Surd], family: str,
                          cyclic: bool = False) -> ConvexityCertificate:
    """Check strict discrete convexity exactly.  Never assumes; always checks."""
    n = len(values)
    if n < 3:
        raise GeodesicError("a convexity certificate needs at least 3 samples")
    violations: List[int] = []
    rng = range(n) if cyclic else range(1, n - 1)
    for i in rng:
        a = values[(i - 1) % n]
        b = values[i]
        c = values[(i + 1) % n]
        second = (a + c) - b.scale(2)
        if second.sign() <= 0:
            violations.append(i)
    best = 0
    for i in range(1, n):
        if values[i] < values[best]:
            best = i
    COUNTERS.bump("light.convexity")
    licensed = not violations
    note = ("strict convexity on the sampled family: the unique discrete "
            "minimum is the only stationary point, so the extractor's answer "
            "is the physical ray up to the lattice"
            if licensed else
            "NOT convex: the family has stationary points that are not minima, "
            "so a minimiser may return a physical ray while silently dropping "
            "other, equally physical, stationary rays")
    return ConvexityCertificate(family=family, samples=n, licensed=licensed,
                                violations=tuple(violations), minimum_index=best,
                                note=note)


@dataclass(frozen=True)
class SnellBracket:
    """The exact discretization statement for a discrete Fermat optimum.

    ``g(x) = n1 sin(theta1(x)) - n2 sin(theta2(x))`` is the exact derivative of
    the optical path length in the crossing abscissa, and it is strictly
    increasing (the OPL is strictly convex).  If ``xhat`` is the minimiser over
    a lattice of spacing ``h`` then ``OPL(xhat) <= OPL(xhat +- h)``, so by the
    mean value theorem ``g`` changes sign on ``[xhat-h, xhat+h]``, hence

        g(xhat - h) <= 0 <= g(xhat + h)

    and the *true* Fermat crossing lies in ``[xhat - h, xhat + h]``.  Both
    endpoint values are exact ``Surd``s and both inequalities are checked, not
    assumed.  ``residual`` is ``g(xhat)`` itself: **zero exactly** when the true
    crossing happens to be on the lattice, and otherwise a bounded nonzero
    number whose bound is ``low``/``high``.
    """

    x: Fraction
    step: Fraction
    residual: Surd
    low: Surd
    high: Surd
    brackets_zero: bool
    exact_hit: bool

    def render(self) -> str:
        return ("x=%s h=%s residual=%s  bracket [%s, %s]  %s"
                % (self.x, self.step, self.residual.render_approx(9),
                   self.low.render_approx(9), self.high.render_approx(9),
                   "EXACT (residual is exactly 0)" if self.exact_hit
                   else "brackets 0" if self.brackets_zero else "DOES NOT bracket 0"))


def snell_bracket(stack: O.InterfaceStack, x: Fraction, step: Fraction,
                  interface: int = 0) -> SnellBracket:
    """Evaluate the exact Snell residual at ``x`` and bracket it at ``x +- step``."""
    if stack.depth != 1:
        raise GeodesicError("snell_bracket is stated for a single interface")
    x, step = exact(x), exact(step)
    r = O.snell_residual(stack, (x,), interface)
    lo = O.snell_residual(stack, (x - step,), interface)
    hi = O.snell_residual(stack, (x + step,), interface)
    COUNTERS.bump("light.snell_bracket")
    return SnellBracket(x=x, step=step, residual=r, low=lo, high=hi,
                        brackets_zero=(lo.sign() <= 0 and hi.sign() >= 0),
                        exact_hit=r.is_zero())


# --------------------------------------------------------------------------
# THE REALIZE EDGE -- a declared certificate, and nothing more
# --------------------------------------------------------------------------

@dataclass(frozen=True)
class Realization:
    """A ``Realize`` edge: a mathematical construction read as a physical one.

    It is an L1 ``Interp`` edge -- "theory-to-theory semantics", which is
    precisely what a physical interpretation of a mathematical object is -- with
    a declared ``Certificate`` witness, a dimensional signature, and its
    modelling assumptions written down.

    **Trust boundary, in ``STATUS.md``'s own terms.**  ``STATUS.md`` says:

        Only ``Eq`` (proof paths), ``Iso`` (round-trip normalization), and beta
        are genuinely machine-checked.  For ``Quotient``, ``Embed``, ``Implies``,
        ``Approx``, ``Refine``, ``Interp``, ``Dual`` the checker verifies that a
        matching certificate was *declared* -- not that the mathematics holds.

    ``Interp`` is on the declared-only side of that line.  So what
    ``check_edge`` accepts about a ``Realization`` is: a certificate of kind
    ``Interp`` with these exact endpoints was declared by the caller.  It does
    **not** check that light obeys Fermat's principle, that the medium is
    homogeneous and isotropic, that the wavelength is short compared to the
    geometry, or that the index is really 8/5.  Those are in ``assumptions``,
    unverified, by construction.

    ``machine_verified`` is not a settable claim: constructing a ``Realization``
    that asserts it raises ``TrustBoundaryError``, because there is no code path
    in this runtime that could make it true for an ``Interp`` edge.  The planted
    control in the test suite is exactly that constructor call.
    """

    name: str
    math_addr: str
    reading: Quantity
    assumptions: Tuple[str, ...]
    machine_verified: bool = False

    def __post_init__(self) -> None:
        if self.machine_verified:
            raise TrustBoundaryError(
                "a Realize edge is an L1 `Interp` edge; per runtime/STATUS.md only "
                "Eq, Iso and beta are machine-checked, so `machine_verified=True` "
                "is a claim this runtime cannot make. Physics is not proved here.")
        if not self.assumptions:
            raise TrustBoundaryError(
                "a Realize edge with no stated modelling assumptions is not a "
                "certificate, it is an assertion")
        if not isinstance(self.reading, Quantity):
            raise TrustBoundaryError("a Realize edge must carry a dimensioned reading")

    @property
    def dimension_signature(self) -> str:
        return self.reading.dim.render()

    def edge(self) -> E.Edge:
        return E.Edge("Interp", self.math_addr, self.reading.addr,
                      witness=C.Certificate(self.name),
                      label="Realize/%s" % self.name,
                      provenance=self.assumptions)

    def declare(self, ctx: C.CheckContext) -> None:
        ctx.declare_certificate(self.name, "Interp", self.math_addr,
                                self.reading.addr)

    def check(self, ctx: C.CheckContext) -> bool:
        """What the kernel will say.  True means *declared*, not *verified*."""
        return C.check_edge(self.edge(), ctx)

    def trust_note(self) -> str:
        return ("DECLARED, NOT VERIFIED. kind=Interp; the kernel confirms a "
                "matching certificate exists and nothing about the physics. "
                "Dimensional signature [%s]. Assumptions: %s"
                % (self.dimension_signature, "; ".join(self.assumptions)))

    def render(self) -> str:
        return ("Realize/%s : %s -> %s   %s"
                % (self.name, self.math_addr[:10], self.reading.render(),
                   "declared certificate (NOT machine-verified physics)"))


def realize(name: str, math: T.Term, value, dim: Dimension,
            assumptions: Sequence[str]) -> Realization:
    """Build a ``Realize`` edge from a kernel term to a dimensioned reading."""
    return Realization(name=name, math_addr=math.addr,
                       reading=quantity(value, dim),
                       assumptions=tuple(assumptions))


# --------------------------------------------------------------------------
# the manifest of literally shared code (asserted by the test suite)
# --------------------------------------------------------------------------

SHARED_CODE: Tuple[Tuple[str, Any], ...] = (
    ("dominates", dominates),
    ("is_nondominated", is_nondominated),
    ("pareto", pareto),
    ("scalarize", scalarize),
    ("frontier_diff", frontier_diff),
    ("Route", Route),
    ("Scalarization", Scalarization),
)

NOT_SHARED: Tuple[Tuple[str, str], ...] = (
    ("RouteFinder._dijkstra",
     "int-weighted; an optical path length is not an int, so the optics problem "
     "cannot call it. geodesic() is the weight-generic form, and "
     "ProofRouteProblem.matches_l3 asserts L3's routes are reproduced by it "
     "exactly on L3's own graph."),
    ("extract.measure_route",
     "costs a route by running kernel/check.py; there is no proof object to "
     "check for a light ray, so certify_optical_length plays that role and "
     "measures its own counters the same way."),
    ("extract.extract_routes",
     "enumerates an e-class; the optics family is a lattice, not an e-class. "
     "The Pareto half of it (pareto/dominates) IS reused verbatim."),
)
