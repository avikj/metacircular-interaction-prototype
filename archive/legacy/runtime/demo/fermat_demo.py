#!/usr/bin/env python3
"""Fermat's principle and proof extraction, run through one machine.

Run:  python3 runtime/demo/fermat_demo.py         (exit 0 iff every claim holds)

The question, in the form CRYSTAL.md Sec.0 demands of a claim:

    is the runtime's route extraction -- which finds *proof* geodesics -- the
    same machinery that finds *light* geodesics, or merely something that
    rhymes with it?  And where, exactly, does the identification fail?

Everything printed is an exact integer, an exact rational, or an exact sum of
rational multiples of square roots.  No float is constructed anywhere; no
square root is ever evaluated numerically; the decimal-looking figures are
rendered from exact rational brackets by integer division and no decision is
taken from them.  Two runs are byte-identical, including under a different
PYTHONHASHSEED.

WHAT IS DEMONSTRATED
  1  a dimensionally-inconsistent statement cannot be constructed -- twice
     over, by this package and by the kernel's own sort checker
  2  Snell's law *derived*: the runtime routes over a discretised family of
     interface crossings, minimising exact optical path length and knowing
     nothing about angles, and the crossing it lands on satisfies
     n1 sin(t1) = n2 sin(t2) as an exact rational identity
  3  the same, with three media, giving the exact invariant n sin(t) = 24/25
  4  what "exactly" means when the true crossing is irrational: an exact,
     checked bracket, refined on the lattice
  5  L3's Pareto frontier code, unmodified, ranking light rays
  6  the unification measured: one Dijkstra, run on L3's own justification
     graph and on the optics graph, reproducing L3's routes exactly
  7  THE DISANALOGY: a concave mirror whose physical ray is a path-length
     MAXIMUM, which this machinery structurally cannot return
  8  a Realize edge: declared, dimensioned, and explicitly not verified physics
"""

from __future__ import annotations

import os
import sys
from fractions import Fraction

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.kernel import check as C                                  # noqa: E402
from runtime.kernel import term as T                                   # noqa: E402
from runtime.execute.extract import (Scalarization, dominates,          # noqa: E402
                                     is_nondominated, scalarize)
from runtime.physics import dimension as DIM                           # noqa: E402
from runtime.physics import optics as OPT                              # noqa: E402
from runtime.physics import geodesic as GEO                            # noqa: E402
from runtime.physics.dimension import (AREA, DimensionError, LENGTH,   # noqa: E402
                                       SPEED, TIME, quantity)
from runtime.physics.optics import (InterfaceStack, Medium, MirrorArc,  # noqa: E402
                                    Vec, circle_tangent, critical_points,
                                    lattice, reflection_residual,
                                    snell_invariant, snell_residual)
from runtime.physics.geodesic import (SOURCE, TARGET, MirrorRouteProblem,  # noqa: E402
                                      OpticsRouteProblem, ProofRouteProblem,
                                      Realization, TrustBoundaryError,
                                      convexity_certificate, geodesic,
                                      mirror_routes, optical_frontier,
                                      optical_routes, realize, snell_bracket,
                                      NOT_SHARED, SHARED_CODE)

BAR = "=" * 78


def hdr(s: str) -> None:
    print("\n" + BAR + "\n" + s + "\n" + BAR)


def frac(f: Fraction) -> str:
    return str(f.numerator) if f.denominator == 1 else "%d/%d" % (f.numerator,
                                                                  f.denominator)


# --------------------------------------------------------------------------
# the optical set-ups, all exact, all rational
# --------------------------------------------------------------------------

GLASS = Medium.of("glass", Fraction(8, 5))       # n = 8/5
WATER = Medium.of("water", Fraction(6, 5))       # n = 6/5
OIL = Medium.of("oil", Fraction(26, 25))         # n = 26/25
AIR = Medium.of("air", Fraction(1))
VACUUM = Medium.of("vacuum", Fraction(1))


def two_medium() -> InterfaceStack:
    """Source (0,4) in n=8/5, target (11,-6) in n=6/5, interface y=0.

    Chosen so that the *true* Fermat crossing is a lattice point and both legs
    are Pythagorean: 3-4-5 above and 8-6-10 below.  That is what makes the
    Snell identity come out exactly rational rather than bracketed, and it is a
    property of the geometry, not an input to the search.
    """
    return InterfaceStack(source=Vec.of(0, 4), target=Vec.of(11, -6),
                          media=(GLASS, WATER), boundaries=(Fraction(0),),
                          lattices=(lattice(-5, 16, 1),))


def three_medium() -> InterfaceStack:
    """A stack: n=8/5 above y=8, n=6/5 between, n=26/25 below y=0."""
    return InterfaceStack(source=Vec.of(0, 16), target=Vec.of(Fraction(86, 3), -5),
                          media=(GLASS, WATER, OIL),
                          boundaries=(Fraction(8), Fraction(0)),
                          lattices=(lattice(0, 12, Fraction(1, 3)),
                                    lattice(8, 24, Fraction(1, 3))))


def generic_two_medium(step: Fraction) -> InterfaceStack:
    """Deliberately *not* Pythagorean: the true crossing is irrational."""
    return InterfaceStack(source=Vec.of(0, 3), target=Vec.of(7, -4),
                          media=(Medium.of("glass", Fraction(3, 2)), AIR),
                          boundaries=(Fraction(0),),
                          lattices=(lattice(0, 7, step),))


def main() -> int:                                                  # noqa: C901
    failures = []

    def want(cond, msg):
        if not cond:
            failures.append(msg)
            print("  ** FAILED: %s" % msg)
        return bool(cond)

    OPT.reset_caches()
    for _ctr in (DIM.COUNTERS, OPT.COUNTERS, GEO.COUNTERS):
        _ctr.reset()

    print(BAR)
    print("FERMAT DEMO -- geodesics of mathematics and of light, in one engine")
    print(BAR)
    print("exact arithmetic only: int, fractions.Fraction, and exact sums of")
    print("rational multiples of square roots.  no float, no sqrt evaluation.")

    # ----------------------------------------------------------------------
    hdr("1.  DIMENSIONAL SOUNDNESS AS A KERNEL-STYLE GUARANTEE")
    # ----------------------------------------------------------------------
    metre = quantity(1, LENGTH)
    second = quantity(1, TIME)
    print("  1 metre                 addr %s  dim [%s]" % (metre.addr, metre.dim.render()))
    print("  1 second                addr %s  dim [%s]" % (second.addr, second.dim.render()))
    want(metre.addr != second.addr,
         "equal magnitude, different dimension must give different addresses")
    print("  equal magnitude, different dimension -> different address: %s"
          % (metre.addr != second.addr))

    refused = None
    try:
        metre + second                                   # noqa: B018
    except DimensionError as exc:
        refused = str(exc)
    want(refused is not None, "metres + seconds must be a construction-time error")
    print("  PLANTED FALSE  metre + second ->  %s" % refused)

    print("  the same refusal from the kernel, which this package does not own:")
    tm, ts = DIM.term_of(metre), DIM.term_of(second)
    print("    term_of(1 m) : %s   kernel addr %s" % (tm.sort.pretty(), tm.addr))
    print("    term_of(1 s) : %s   kernel addr %s" % (ts.sort.pretty(), ts.addr))
    want(tm.addr != ts.addr, "the kernel address must carry the dimension too")
    kernel_refused = None
    try:
        DIM.add_terms(LENGTH, tm, ts)
    except T.SortError as exc:
        kernel_refused = str(exc)
    want(kernel_refused is not None, "T.App must refuse a time-sorted argument")
    print("    PLANTED FALSE  App(App(plus_L, 1m), 1s) ->  T.SortError: %s"
          % kernel_refused)
    ok_sum = DIM.add_terms(LENGTH, tm, tm)
    print("    the well-dimensioned sum builds fine: %s : %s"
          % (ok_sum.pretty(), ok_sum.sort.pretty()))

    speed = metre.over(second)
    print("  derived: (1 m)/(1 s) = %s   dim is SPEED: %s"
          % (speed.render(), speed.dim is SPEED))
    half = AREA.power(Fraction(1, 2))
    print("  rational exponents:  AREA^(1/2) = [%s]" % half.render())
    want(speed.dim is SPEED and half is LENGTH, "derived dimensions must be exact")
    float_refused = None
    try:
        quantity(1.5, LENGTH)   # EXACT-CONTROL: planted float, must be refused
    except DimensionError as exc:
        float_refused = str(exc)
    want(float_refused is not None, "a float magnitude must be refused")
    print("  PLANTED FALSE  quantity(1.5, LENGTH) -> %s" % float_refused)

    # ----------------------------------------------------------------------
    hdr("2.  SNELL'S LAW, DERIVED BY ROUTING -- NOT ASSUMED ANYWHERE")
    # ----------------------------------------------------------------------
    st = two_medium()
    print("  media   above y=0: %s        below y=0: %s"
          % (st.media[0].render(), st.media[1].render()))
    print("  source  %s        target  %s" % (st.source.render(), st.target.render()))
    print("  family  %d crossings, integer lattice x in [-5, 16]" % st.size())
    print("  the router is told: source, target, indices, candidate crossings.")
    print("  it is NOT told: angles, sines, Snell, or which crossing to prefer.")

    prob = OpticsRouteProblem(st)
    res = geodesic(prob, SOURCE, TARGET)
    xs = prob.crossings(res)
    want(res.found, "the optics geodesic must be found")
    print("\n  geodesic():  %s" % res.render())
    print("  crossing found      x = %s" % frac(xs[0]))
    opl = st.opl(xs)
    print("  optical path length %s   (exactly rational: %s)"
          % (opl.render(), opl.as_fraction() is not None))

    print("\n  now MEASURE the found route against Snell -- after the fact:")
    ray = st.ray(xs)
    leg1 = ray.points[1].minus(ray.points[0])
    leg2 = ray.points[2].minus(ray.points[1])
    h1 = OPT.integer_sqrt(leg1.norm2().numerator)
    h2 = OPT.integer_sqrt(leg2.norm2().numerator)
    print("    leg 1  d=(%s, %s)  |d|^2=%s  |d|=%d exactly (perfect square: %s)"
          % (frac(leg1.x), frac(leg1.y), frac(leg1.norm2()), h1,
             OPT.is_perfect_square(leg1.norm2().numerator)))
    print("    leg 2  d=(%s, %s)  |d|^2=%s  |d|=%d exactly (perfect square: %s)"
          % (frac(leg2.x), frac(leg2.y), frac(leg2.norm2()), h2,
             OPT.is_perfect_square(leg2.norm2().numerator)))
    inv = snell_invariant(st, xs)
    print("    n1 sin(t1) = %s        n2 sin(t2) = %s"
          % (inv[0].render(), inv[1].render()))
    resid = snell_residual(st, xs)
    print("    residual n1 sin(t1) - n2 sin(t2) = %s      is exactly zero: %s"
          % (resid.render(), resid.is_zero()))
    want(resid.is_zero(), "Snell must hold exactly at the discrete optimum here")
    want(inv[0].as_fraction() == Fraction(24, 25),
         "the invariant must be the exact rational 24/25")
    print("\n  WHAT 'EXACTLY' MEANS HERE, precisely:")
    print("    both legs are Pythagorean, so both sines are exact rationals")
    print("    (3/5 and 4/5); the residual is a canonical Surd with no terms,")
    print("    i.e. the integer 0, not a small number.  Zero is decided")
    print("    syntactically, never by a tolerance.")

    print("\n  PLANTED FALSE  a claimed Snell solution that is not the optimum:")
    for bogus in (Fraction(2), Fraction(4), Fraction(0)):
        b_opl = st.opl((bogus,))
        b_res = snell_residual(st, (bogus,))
        beaten = b_opl.compare(opl) > 0
        print("    x=%-3s opl=%-9s > optimum: %-5s   residual=%-12s zero: %s"
              % (frac(bogus), b_opl.render_approx(4), beaten,
                 b_res.render_approx(6), b_res.is_zero()))
        want(beaten and not b_res.is_zero(),
             "a non-optimal crossing must be both costlier and non-Snell")

    # ----------------------------------------------------------------------
    hdr("3.  THREE MEDIA: THE INVARIANT n sin(t), FOUND THE SAME WAY")
    # ----------------------------------------------------------------------
    st3 = three_medium()
    prob3 = OpticsRouteProblem(st3)
    res3 = geodesic(prob3, SOURCE, TARGET)
    xs3 = prob3.crossings(res3)
    print("  media  %s | %s | %s" % tuple(m.render() for m in st3.media))
    print("  family %d rays;  the layered graph reaches them with %d arc"
          " evaluations" % (st3.size(), res3.relaxed))
    print("  %s" % res3.render())
    print("  crossings  x0 = %s   x1 = %s" % (frac(xs3[0]), frac(xs3[1])))
    o3 = st3.opl(xs3)
    print("  optical path length %s  (rational: %s)"
          % (o3.render(), o3.as_fraction()))
    inv3 = snell_invariant(st3, xs3)
    print("  n sin(t) in each medium:  %s" % ", ".join(s.render() for s in inv3))
    r0 = snell_residual(st3, xs3, 0)
    r1 = snell_residual(st3, xs3, 1)
    print("  residual at interface 0: %s     at interface 1: %s"
          % (r0.render(), r1.render()))
    want(r0.is_zero() and r1.is_zero(), "Snell must hold at both interfaces")
    want(len({s.as_fraction() for s in inv3}) == 1,
         "n sin(t) must be one exact rational in all three media")
    print("  the invariant is ONE exact rational across all three media: %s"
          % inv3[0].as_fraction())

    # ----------------------------------------------------------------------
    hdr("4.  WHEN THE TRUE CROSSING IS IRRATIONAL: THE EXACT BRACKET")
    # ----------------------------------------------------------------------
    print("  source (0,3) in n=3/2, target (7,-4) in air.  The true Fermat")
    print("  crossing is irrational, so it is in the family's OMITTED LOCUS and")
    print("  no lattice can contain it.  The runtime therefore does not claim a")
    print("  zero residual; it computes an exact bracket and checks the sign")
    print("  change, because g(x) = n1 sin(t1) - n2 sin(t2) is d(OPL)/dx and is")
    print("  strictly increasing.  OPL(xhat) <= OPL(xhat+-h)  =>")
    print("      g(xhat - h) <= 0 <= g(xhat + h)   and   x* in [xhat-h, xhat+h].")
    print()
    print("  %-8s %-10s %-14s %-14s %-8s %s"
          % ("step h", "xhat", "residual", "bound", "brackets", "convexity"))
    print("  " + "-" * 74)
    prev_bound = None
    for step in (Fraction(1), Fraction(1, 4), Fraction(1, 16), Fraction(1, 64)):
        stg = generic_two_medium(step)
        pg = OpticsRouteProblem(stg)
        rg = geodesic(pg, SOURCE, TARGET)
        xg = pg.crossings(rg)[0]
        br = snell_bracket(stg, xg, step)
        width = br.high - br.low
        vals = tuple(stg.opl((x,)) for x in stg.lattices[0])
        cert = convexity_certificate(vals, "refraction h=%s" % frac(step))
        print("  %-8s %-10s %-14s %-14s %-8s %s"
              % (frac(step), frac(xg), br.residual.render_approx(9),
                 width.render_approx(9), br.brackets_zero,
                 "licensed" if cert.licensed else "REFUSED"))
        want(br.brackets_zero, "the Snell bracket must contain zero at h=%s" % step)
        want(cert.licensed, "the refraction family must be strictly convex")
        want(not br.exact_hit, "this geometry must NOT hit the optimum exactly")
        if prev_bound is not None:
            want((width - prev_bound).sign() < 0,
                 "the certified bound must shrink as the lattice refines")
        prev_bound = width
    print()
    print("  So: 'exactly' means two different things and both are stated.")
    print("    (a) on a geometry whose optimum is a lattice point, the residual")
    print("        is the exact integer 0 (section 2);")
    print("    (b) otherwise, the residual is a nonzero exact algebraic number")
    print("        with an exact, checked, monotonically shrinking bound, and")
    print("        the runtime says 'cheapest member of the family', not")
    print("        'the physical ray'.")

    # ----------------------------------------------------------------------
    hdr("5.  L3'S PARETO FRONTIER CODE, UNMODIFIED, RANKING LIGHT")
    # ----------------------------------------------------------------------
    routes = optical_routes(st)
    front = optical_frontier(routes)
    print("  %d certified light routes -> frontier of %d" % (len(routes), len(front)))
    print("  %-14s %-13s %-6s %-7s %s" % ("crossing", "opl", "hops", "width", "verify"))
    print("  " + "-" * 60)
    for r in front:
        c = r.cost
        print("  %-14s %-13s %-6d %-7d %d"
              % (r.label, c.opl.render_approx(6), c.hops, c.width, c.verify))
    want(len(front) >= 2, "the light frontier must be genuinely multi-objective")
    want(front[0].label == "(3, 0)", "the OPL-optimal crossing must be on the frontier")
    print("  opl and width trade against each other exactly as `size` and")
    print("  `width` do in L3: the physical optimum x=3 costs more bits of")
    print("  exact coordinate than the arithmetically cheap x=0.")
    for scal in (Scalarization("least-action", (1, 0, 0, 0)),
                 Scalarization("cheap-coordinates", (0, 0, 1, 0))):
        ch = scalarize(routes, scal)
        print("  scalarization %-20s -> %s" % (scal.name, ch.route.label))
    want(scalarize(routes, Scalarization("least-action", (1, 0, 0, 0))).route.label
         == "(3, 0)", "least-action must pick the Fermat crossing")
    print("  PLANTED FALSE  a dominated route claimed nondominated:")
    dom = [r for r in routes if not is_nondominated(r, routes)]
    print("    %d dominated routes; is_nondominated refuses every one: %s"
          % (len(dom), all(not is_nondominated(r, routes) for r in dom)))
    want(dom and all(dominates(front[0].cost, r.cost) or
                     any(dominates(o.cost, r.cost) for o in routes) for r in dom),
         "every dominated route must actually be dominated")

    # ----------------------------------------------------------------------
    hdr("6.  THE UNIFICATION, MEASURED")
    # ----------------------------------------------------------------------
    from runtime.demo import geodesic_demo as GD
    ctx, folds = GD.base_context()
    rules = GD.base_rules(ctx, folds)
    task = GD.left_nested(8)
    g, sat, ex, finder = GD.run(task, rules, ctx, "physics-probe")
    members = g.class_of(task)
    print("  L3's own problem: evaluate 3^8, saturated to %s" % sat.status)
    print("  justification graph: %d records, e-class of %d members"
          % (len(g.records()), len(members)))
    pp = ProofRouteProblem(g)
    agree = 0
    for m in members:
        ok, _, _ = pp.matches_l3(task.addr, m)
        agree += 1 if ok else 0
    print("  runs of geodesic() on L3's adjacency + L3's _step_for that")
    print("  reproduce RouteFinder.route STEP FOR STEP: %d / %d"
          % (agree, len(members)))
    want(agree == len(members),
         "the shared driver must reproduce every one of L3's routes exactly")

    pr = geodesic(pp, task.addr, members[0])
    print("\n  the shared interface, in both instantiations:")
    print("  %-16s | %-28s | %s" % ("", "proof routing (L3)", "light routing (here)"))
    print("  " + "-" * 74)
    rows = (("node", "e-graph address (str)", "SOURCE / interface point / TARGET"),
            ("arc", "a retained MergeRecord", "a straight segment in one medium"),
            ("weight", "kernel proof steps (int)", "n*sqrt(dx^2+dy^2)  (Surd)"),
            ("zero", "0", "Surd.zero()"),
            ("route", "a checkable proof path", "a piecewise-linear ray"),
            ("cost[0]", "steps", "opl"),
            ("cost[1]", "size (term DAG nodes)", "hops (segments)"),
            ("cost[2]", "width (literal bits)", "width (coordinate bits)"),
            ("cost[3]", "verify (checker counters)", "verify (certifier counters)"))
    for a, b, c in rows:
        print("  %-16s | %-28s | %s" % (a, b, c))
    print("\n  literally the same code object in both:")
    for name, obj in SHARED_CODE:
        print("    %-18s from %s" % (name, obj.__module__))
        want(obj.__module__ == "runtime.execute.extract",
             "%s must still be L3's own definition" % name)
    print("\n  NOT shared, and why (no faked reuse):")
    for name, why in NOT_SHARED:
        print("    %-26s %s" % (name, why.split(".")[0] + "."))
    print("\n  search counters:  proof route settled=%d relaxed=%d ; "
          "light route settled=%d relaxed=%d"
          % (pr.settled, pr.relaxed, res.settled, res.relaxed))

    # ----------------------------------------------------------------------
    hdr("7.  THE DISANALOGY: STATIONARY IS NOT MINIMAL")
    # ----------------------------------------------------------------------
    print("  Fermat is  delta(OPL) = 0.  Extraction is  min(OPL).  Minimal")
    print("  implies stationary; the converse is false, and here is a case.")
    print()
    print("  A concave circular mirror x^2+y^2=16, source (-3,0), target (3,0).")
    print("  Those are the foci of the ellipse a=5,b=4 through (0,4), and the")
    print("  mirror's radius 4 is smaller than the ellipse's radius of")
    print("  curvature 25/4 there -- so the mirror lies INSIDE the ellipse near")
    print("  (0,4) and the reflection at (0,4) is a path-length MAXIMUM.")
    arc = MirrorArc.of(4, [Fraction(k, 4) for k in range(-16, 17)])
    pts = arc.points()
    want(all(arc.on_circle(p) for p in pts),
         "every generated mirror point must lie exactly on the circle")
    print("\n  generated locus: %d exact rational points from the chart" % len(pts))
    print("  t |-> (R(1-t^2)/(1+t^2), 2Rt/(1+t^2)), plus the chart's omitted")
    print("  point (-R,0).  omitted locus: %s" % arc.omitted_locus())
    A, B = Vec.of(-3, 0), Vec.of(3, 0)
    mprob = MirrorRouteProblem(A, B, pts, VACUUM)
    vals = mprob.values()
    crits = critical_points(vals, cyclic=True)
    print("\n  stationary points of the exact OPL over the family:")
    print("  %-6s %-12s %-8s %-14s %s"
          % ("index", "point", "opl", "kind", "reflection law residual"))
    print("  " + "-" * 70)
    physical = 0
    for c in crits:
        rr = reflection_residual(A, pts[c.index], B, circle_tangent(pts[c.index]))
        if rr.is_zero():
            physical += 1
        print("  %-6d %-12s %-8s %-14s %s  (exactly zero: %s)"
              % (c.index, pts[c.index].render(), c.value.render(), c.kind,
                 rr.render(), rr.is_zero()))
    want(len(crits) == 4, "this mirror must have exactly four stationary points")
    want(physical == 4,
         "every stationary point must satisfy the law of reflection exactly")
    maxima = tuple(c for c in crits if c.kind == "maximum")
    minima = tuple(c for c in crits if c.kind == "minimum")
    want(len(maxima) == 2 and len(minima) == 2, "two maxima and two minima")

    mres = geodesic(mprob, SOURCE, TARGET)
    got = mprob.index_of(mres)
    mroutes = mirror_routes(mprob)
    mfront = optical_frontier(mroutes)
    print("\n  WHAT THE MACHINERY DID:")
    print("    geodesic()  returned index %d, %s, opl=%s -- a minimum"
          % (got, pts[got].render(), mres.weight.render()))
    print("    pareto()    returned %d route(s): %s"
          % (len(mfront), ", ".join(r.label for r in mfront)))
    print("      (both tied minima survive: equal cost is not domination, so")
    print("       the plurality the spec protects is preserved -- but it is")
    print("       plurality among *minima* only.)")
    print("    the two MAXIMA at %s and %s are equally physical rays -- their"
          % (pts[maxima[0].index].render(), pts[maxima[1].index].render()))
    print("    reflection-law residual is exactly 0 -- and they are")
    print("    structurally unreachable by this machinery.")
    want(all(r.label not in (pts[maxima[0].index].render(),
                             pts[maxima[1].index].render()) for r in mfront),
         "the maxima must indeed be absent from the frontier -- that is the bug")
    print("    THE FRONTIER MISSES 2 OF THE 4 PHYSICAL RAYS.  Not a rounding")
    print("    error: Dijkstra's optimal substructure is a statement about")
    print("    minima, and 'longest path' is NP-hard on a general graph, so")
    print("    this is not repaired by searching harder.")

    cert = convexity_certificate(vals, "concave mirror", cyclic=True)
    print("\n  WHAT THE MACHINERY SAID ABOUT ITSELF:")
    print("    %s" % cert.render())
    print("    %s" % cert.note)
    want(not cert.licensed,
         "the convexity certificate must REFUSE to issue on the mirror family")
    st_cert = convexity_certificate(tuple(st.opl((x,)) for x in st.lattices[0]),
                                    "plane refraction")
    print("    %s" % st_cert.render())
    want(st_cert.licensed,
         "the refraction family must get its certificate")
    print("\n  So the precise scope of the unification is:")
    print("    cost-minimal route == physical ray  EXACTLY WHEN the OPL over")
    print("    the family is strictly convex, and the runtime checks that with")
    print("    exact second differences instead of assuming it.  Refraction")
    print("    through a plane interface: licensed.  Concave mirror: refused.")

    # ----------------------------------------------------------------------
    hdr("8.  THE REALIZE EDGE -- DECLARED, DIMENSIONED, NOT VERIFIED")
    # ----------------------------------------------------------------------
    math_term = DIM.term_of(quantity(opl.as_fraction(), DIM.DIMENSIONLESS))
    rz = realize("fermat-two-medium-opl", math_term, opl.as_fraction(), LENGTH,
                 ("media are homogeneous, isotropic and non-dispersive",
                  "geometric-optics limit: wavelength << all lengths here",
                  "indices 8/5 and 6/5 are stipulated, not measured",
                  "the interface is a plane and is exactly at y=0",
                  "coordinates are in metres by declaration"))
    print("  %s" % rz.render())
    print("  dimensional signature  [%s]" % rz.dimension_signature)
    print("  assumptions:")
    for a in rz.assumptions:
        print("    - %s" % a)
    rctx = C.CheckContext()
    before = rz.check(rctx)
    print("  kernel check BEFORE declaring the certificate: %s" % before)
    want(not before, "an undeclared Realize edge must not check")
    rz.declare(rctx)
    after = rz.check(rctx)
    print("  kernel check AFTER  declaring the certificate: %s" % after)
    want(after, "a declared Realize edge must check as declared")
    print("  %s" % rz.trust_note())
    print("  STATUS.md trust boundary: `Interp` is on the declared-only side.")
    print("  What was checked: a certificate of kind Interp with these exact")
    print("  endpoints exists.  What was NOT checked: any physics whatsoever.")
    claimed = None
    try:
        Realization("forged", math_term.addr, quantity(1, LENGTH), ("x",),
                    machine_verified=True)
    except TrustBoundaryError as exc:
        claimed = str(exc)
    want(claimed is not None,
         "a Realize edge claiming machine verification must be refused")
    print("  PLANTED FALSE  Realization(..., machine_verified=True) ->")
    print("    TrustBoundaryError: %s" % " ".join(claimed.split())[:96])
    bare = None
    try:
        Realization("bare", math_term.addr, quantity(1, LENGTH), ())
    except TrustBoundaryError as exc:
        bare = str(exc)
    want(bare is not None, "a Realize edge with no assumptions must be refused")
    print("  PLANTED FALSE  a Realize edge with no stated assumptions -> refused")

    # ----------------------------------------------------------------------
    hdr("9.  EXACT COUNTERS")
    # ----------------------------------------------------------------------
    print("  Intern-table bookkeeping (`*.hash`, `*.intern_*`) is omitted: the")
    print("  intern tables are permanent by design -- kernel/README.md L0")
    print("  guarantee 4 -- so those counts depend on what else ran in the")
    print("  process, and printing them would make this demo non-reproducible.")
    print("  Everything else is reproduced from a cold cache (`reset_caches`).")
    print()
    for name, ctr in (("dimension", DIM.COUNTERS), ("optics", OPT.COUNTERS),
                      ("geodesic", GEO.COUNTERS)):
        stable = " ".join("%s=%d" % (k, v) for k, v in ctr.snapshot()
                          if "intern" not in k and not k.endswith(".hash"))
        print("  %-10s %s" % (name, stable))

    # ----------------------------------------------------------------------
    hdr("VERDICT")
    # ----------------------------------------------------------------------
    if failures:
        print("  %d CLAIM(S) FAILED" % len(failures))
        for f in failures:
            print("    - %s" % f)
        return 1
    print("  every claim above held.")
    print()
    print("  EARNED:  one Dijkstra reproduces L3's proof geodesics exactly and")
    print("           finds Fermat's ray; L3's Pareto code ranks light with no")
    print("           modification; Snell emerges from routing as an exact")
    print("           rational identity and was never written down.")
    print("  KILLED:  'geodesics of mathematics and of light' is one mechanism")
    print("           only on families where the action is convex.  Fermat is")
    print("           stationarity; extraction is minimisation; on a concave")
    print("           mirror this engine returns 2 of 4 physical rays and the")
    print("           2 it drops are the ones an optical designer cares about.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
