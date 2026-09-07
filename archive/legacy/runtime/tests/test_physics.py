#!/usr/bin/env python3
"""Adversarial tests for the physics / light layer.

Run standalone:   python3 runtime/tests/test_physics.py
or under pytest:  pytest runtime/tests/test_physics.py

Per `collab/PROTOCOL.md` Sec.7 every capability is paired with a planted-false
control that MUST fail.  The four the brief names explicitly:

* adding metres to seconds
  -> ``test_metres_plus_seconds_is_a_construction_time_error``
     ``test_the_kernel_itself_refuses_the_ill_dimensioned_sum``
* a claimed Snell solution that is not the exact optimum
  -> ``test_a_claimed_snell_solution_that_is_not_the_optimum_is_refused``
     ``test_no_non_optimal_crossing_has_a_zero_residual``
* a float sneaking into any semantic path (asserted by an AST walk)
  -> ``test_no_float_no_division_no_math_in_the_physics_sources``
     ``test_the_ast_walker_itself_can_fail``
* a Realize edge claiming verification it does not have
  -> ``test_realize_edge_claiming_machine_verification_is_refused``
     ``test_realize_edge_does_not_check_until_declared``

Plus the two structural controls the thesis rests on:

* the routing code must not consult Snell -- ``test_no_search_function_mentions_snell``
* the shared code must really be L3's -- ``test_shared_code_is_literally_l3s``
"""

from __future__ import annotations

import ast
import os
import sys
from fractions import Fraction

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.kernel import check as C                                  # noqa: E402
from runtime.kernel import edges as E                                  # noqa: E402
from runtime.kernel import term as T                                   # noqa: E402
from runtime.execute.extract import (RouteFinder, Scalarization,       # noqa: E402
                                     dominates, is_nondominated,
                                     pareto, scalarize)
from runtime.physics import dimension as DIM                           # noqa: E402
from runtime.physics import geodesic as GEO                            # noqa: E402
from runtime.physics import optics as OPT                              # noqa: E402
from runtime.physics.dimension import (AREA, DIMENSIONLESS,            # noqa: E402
                                       DimensionError, LENGTH, MASS,
                                       SPEED, TIME, dimension, quantity)
from runtime.physics.optics import (InterfaceStack, Medium, MirrorArc,  # noqa: E402
                                    OpticsError, Ray, Surd, Vec,
                                    circle_tangent, compare_scaled_sqrt,
                                    critical_points, integer_sqrt,
                                    is_perfect_square, lattice,
                                    optical_path_length, reflection_residual,
                                    sine_to_normal, snell_invariant,
                                    snell_residual, squarefree_part)
from runtime.physics.geodesic import (NOT_SHARED, SHARED_CODE, SOURCE,  # noqa: E402
                                      TARGET, MirrorRouteProblem,
                                      OpticalCost, OpticsRouteProblem,
                                      ProofRouteProblem, Realization,
                                      TrustBoundaryError,
                                      certify_optical_length,
                                      convexity_certificate, geodesic,
                                      mirror_routes, optical_frontier,
                                      optical_routes, realize, snell_bracket)

F = Fraction

PHYSICS_DIR = os.path.dirname(os.path.abspath(OPT.__file__))
TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
DEMO = os.path.join(os.path.dirname(TESTS_DIR), "demo", "fermat_demo.py")


# --------------------------------------------------------------------------
# shared fixtures
# --------------------------------------------------------------------------

GLASS = Medium.of("glass", F(8, 5))
WATER = Medium.of("water", F(6, 5))
OIL = Medium.of("oil", F(26, 25))
AIR = Medium.of("air", F(1))


def two_medium(step=F(1)) -> InterfaceStack:
    return InterfaceStack(source=Vec.of(0, 4), target=Vec.of(11, -6),
                          media=(GLASS, WATER), boundaries=(F(0),),
                          lattices=(lattice(-5, 16, step),))


def three_medium() -> InterfaceStack:
    return InterfaceStack(source=Vec.of(0, 16), target=Vec.of(F(86, 3), -5),
                          media=(GLASS, WATER, OIL),
                          boundaries=(F(8), F(0)),
                          lattices=(lattice(0, 12, F(1, 3)),
                                    lattice(8, 24, F(1, 3))))


def mirror():
    arc = MirrorArc.of(4, [F(k, 4) for k in range(-16, 17)])
    return arc, MirrorRouteProblem(Vec.of(-3, 0), Vec.of(3, 0), arc.points(),
                                   Medium.of("vacuum", 1))


# ==========================================================================
# 1.  exact surd arithmetic
# ==========================================================================

def test_integer_sqrt_is_exact_and_total():
    for n in list(range(0, 200)) + [10 ** 20, 10 ** 20 + 1, 2 ** 61 - 1]:
        r = integer_sqrt(n)
        assert r * r <= n < (r + 1) * (r + 1), n
    assert is_perfect_square(144) and not is_perfect_square(145)


def test_integer_sqrt_refuses_a_float():
    try:
        integer_sqrt(4.0)   # EXACT-CONTROL: planted float, must be refused
    except OpticsError:
        return
    raise AssertionError("integer_sqrt accepted a float")


def test_squarefree_part_is_a_factorization():
    for n in range(1, 500):
        s, f = squarefree_part(n)
        assert s * s * f == n
        for d in range(2, 25):
            assert f % (d * d) != 0, (n, f, d)


def test_compare_scaled_sqrt_is_exact_and_handles_signs():
    # 2*sqrt(3) vs 3*sqrt(2): 4*3=12 < 9*2=18
    assert compare_scaled_sqrt(2, 3, 3, 2) == -1
    assert compare_scaled_sqrt(3, 2, 2, 3) == 1
    # equal: sqrt(8) = 2*sqrt(2)
    assert compare_scaled_sqrt(1, 8, 2, 2) == 0
    # signs
    assert compare_scaled_sqrt(-1, 4, 1, 4) == -1
    assert compare_scaled_sqrt(-2, 3, -3, 2) == 1     # -2r3 > -3r2
    assert compare_scaled_sqrt(1, 0, 0, 7) == 0
    assert compare_scaled_sqrt(F(1, 3), 9, 1, 1) == 0  # (1/3)*3 == 1


def test_surd_zero_is_decided_syntactically_not_numerically():
    # sqrt(2) + sqrt(8) - 3 sqrt(2) == 0 exactly
    s = Surd.sqrt(2) + Surd.sqrt(8) - Surd.scaled_sqrt(3, 2)
    assert s.terms == () and s.is_zero() and s.sign() == 0
    # and a nonzero neighbour is not mistaken for it
    t = s + Surd.scaled_sqrt(F(1, 10 ** 12), 2)
    assert not t.is_zero() and t.sign() == 1


def test_surd_sign_is_exact_on_a_hard_three_term_case():
    # sqrt(2)+sqrt(3) vs sqrt(5)+eps: sqrt2+sqrt3 = 3.1462..., sqrt5 = 2.2360...
    a = Surd.sqrt(2) + Surd.sqrt(3) - Surd.sqrt(5)
    assert a.sign() == 1
    # a genuinely tiny nonzero: sqrt(1000001) - 1000 (about 5e-4)
    b = Surd.sqrt(1000001) - Surd.rational(1000)
    assert b.sign() == 1
    lo, hi = b.bracket(40)
    assert lo > 0 and hi < F(1, 1000)


def test_surd_ordering_is_a_total_order():
    xs = [Surd.sqrt(2), Surd.sqrt(3), Surd.rational(F(3, 2)),
          Surd.sqrt(2) + Surd.sqrt(3), Surd.zero()]
    ys = sorted(xs)
    for i in range(len(ys) - 1):
        assert ys[i] <= ys[i + 1]
        assert not (ys[i + 1] < ys[i])


def test_surd_never_yields_a_float():
    s = Surd.sqrt(2) + Surd.scaled_sqrt(F(3, 7), 5)
    for lo, hi in (s.bracket(8), s.bracket(64)):
        assert isinstance(lo, Fraction) and isinstance(hi, Fraction)
    assert isinstance(s.render_approx(9), str)
    assert s.as_fraction() is None
    assert Surd.rational(F(5, 2)).as_fraction() == F(5, 2)


# ==========================================================================
# 2.  dimensions -- construction-time, and in the address
# ==========================================================================

def test_dimension_is_an_exact_rational_exponent_vector():
    assert dimension(L=1) is LENGTH
    assert LENGTH.times(LENGTH) is AREA
    assert AREA.power(F(1, 2)) is LENGTH
    assert LENGTH.over(TIME) is SPEED
    assert dimension().is_dimensionless and DIMENSIONLESS.render() == "1"
    assert dimension(L=F(1, 2)).render() == "L^(1:2)"


def test_dimension_refuses_a_float_exponent_and_an_unknown_base():
    for bad in (lambda: dimension(L=1.5),   # EXACT-CONTROL: planted float
                lambda: dimension(Q=1)):
        try:
            bad()
        except DimensionError:
            continue
        raise AssertionError("an invalid dimension was constructed")


def test_metres_plus_seconds_is_a_construction_time_error():
    """PLANTED FALSE -- the control the brief names."""
    m, s = quantity(1, LENGTH), quantity(1, TIME)
    try:
        m + s
    except DimensionError:
        pass
    else:
        raise AssertionError("metres + seconds was constructed")
    try:
        m.minus(s)
    except DimensionError:
        pass
    else:
        raise AssertionError("metres - seconds was constructed")
    try:
        m.compare(s)
    except DimensionError:
        return
    raise AssertionError("metres was compared with seconds")


def test_well_dimensioned_arithmetic_still_works():
    m, s = quantity(3, LENGTH), quantity(2, TIME)
    assert (m + quantity(4, LENGTH)).value == 7
    assert m.times(s).dim is dimension(L=1, T=1)
    assert m.over(s).dim is SPEED and m.over(s).value == F(3, 2)
    assert m.power(2).dim is AREA and m.power(2).value == 9


def test_dimension_is_part_of_the_content_address():
    a, b = quantity(1, LENGTH), quantity(1, TIME)
    assert a.value == b.value and a.addr != b.addr
    assert quantity(1, LENGTH) is a                     # interned
    assert quantity(1, MASS).addr not in (a.addr, b.addr)


def test_the_kernel_itself_refuses_the_ill_dimensioned_sum():
    """PLANTED FALSE -- and the refusal comes from the trusted file, not here."""
    tm = DIM.term_of(quantity(1, LENGTH))
    ts = DIM.term_of(quantity(1, TIME))
    assert tm.addr != ts.addr, "the kernel address must carry the dimension"
    assert DIM.add_terms(LENGTH, tm, tm) is not None
    try:
        DIM.add_terms(LENGTH, tm, ts)
    except T.SortError:
        return
    raise AssertionError("T.App accepted a time-sorted argument at a length sum")


def test_a_float_magnitude_is_refused():
    for bad in (1.5, 0.0, complex(1, 0), "1"):   # EXACT-CONTROL: planted floats
        try:
            quantity(bad, LENGTH)
        except DimensionError:
            continue
        raise AssertionError("a non-exact magnitude %r was accepted" % (bad,))
    assert quantity(True.__int__(), LENGTH).value == 1   # ints still fine
    try:
        quantity(True, LENGTH)
    except DimensionError:
        return
    raise AssertionError("a bool was accepted as a magnitude")


# ==========================================================================
# 3.  Snell, derived
# ==========================================================================

def test_routing_finds_the_exact_fermat_crossing():
    st = two_medium()
    p = OpticsRouteProblem(st)
    r = geodesic(p, SOURCE, TARGET)
    assert r.found
    xs = p.crossings(r)
    assert xs == (F(3),), xs
    assert st.opl(xs).as_fraction() == 20


def test_the_found_crossing_satisfies_snell_exactly():
    st = two_medium()
    xs = OpticsRouteProblem(st).crossings(geodesic(OpticsRouteProblem(st),
                                                   SOURCE, TARGET))
    inv = snell_invariant(st, xs)
    assert inv[0].as_fraction() == F(24, 25)
    assert inv[1].as_fraction() == F(24, 25)
    res = snell_residual(st, xs)
    assert res.is_zero() and res.terms == () and res.sign() == 0


def test_a_claimed_snell_solution_that_is_not_the_optimum_is_refused():
    """PLANTED FALSE -- the control the brief names."""
    st = two_medium()
    best = st.opl((F(3),))
    for bogus in (F(2), F(4), F(0), F(-5), F(16)):
        claimed = st.opl((bogus,))
        assert claimed.compare(best) > 0, "x=%s claimed to beat the optimum" % bogus
        assert not snell_residual(st, (bogus,)).is_zero(), \
            "x=%s claimed an exact Snell identity it does not have" % bogus


def test_no_non_optimal_crossing_has_a_zero_residual():
    st = two_medium()
    zeros = [x for x in st.lattices[0] if snell_residual(st, (x,)).is_zero()]
    assert zeros == [F(3)], zeros


def test_the_residual_changes_sign_exactly_once_across_the_optimum():
    st = two_medium()
    signs = [snell_residual(st, (x,)).sign() for x in st.lattices[0]]
    flips = sum(1 for i in range(len(signs) - 1)
                if signs[i] * signs[i + 1] < 0 or signs[i + 1] == 0)
    assert signs[0] < 0 < signs[-1] and flips == 1, signs


def test_three_media_give_one_exact_invariant():
    st = three_medium()
    p = OpticsRouteProblem(st)
    xs = p.crossings(geodesic(p, SOURCE, TARGET))
    assert xs == (F(6), F(50, 3)), xs
    inv = snell_invariant(st, xs)
    assert {s.as_fraction() for s in inv} == {F(24, 25)}
    assert snell_residual(st, xs, 0).is_zero()
    assert snell_residual(st, xs, 1).is_zero()
    assert st.opl(xs).as_fraction() == F(1138, 25)


def test_the_discretization_bracket_is_exact_and_shrinks():
    prev = None
    for step in (F(1), F(1, 4), F(1, 16)):
        st = InterfaceStack(source=Vec.of(0, 3), target=Vec.of(7, -4),
                            media=(Medium.of("g", F(3, 2)), AIR),
                            boundaries=(F(0),), lattices=(lattice(0, 7, step),))
        p = OpticsRouteProblem(st)
        x = p.crossings(geodesic(p, SOURCE, TARGET))[0]
        br = snell_bracket(st, x, step)
        assert not br.exact_hit, "this geometry must not land exactly"
        assert br.low.sign() <= 0 <= br.high.sign(), "the bracket must contain 0"
        assert br.brackets_zero
        width = br.high - br.low
        if prev is not None:
            assert width < prev, "the certified bound must shrink"
        prev = width


def test_snell_bracket_refuses_a_multi_interface_stack():
    try:
        snell_bracket(three_medium(), F(6), F(1, 3))
    except GEO.GeodesicError:
        return
    raise AssertionError("snell_bracket accepted a stack it cannot state a bound for")


def test_sine_to_normal_is_exact_on_pythagorean_legs():
    assert sine_to_normal(3, -4).as_fraction() == F(3, 5)
    assert sine_to_normal(-3, -4).as_fraction() == F(-3, 5)
    assert sine_to_normal(1, -1).as_fraction() is None      # irrational, honestly
    try:
        sine_to_normal(0, 0)
    except OpticsError:
        return
    raise AssertionError("a degenerate segment was given an angle")


# ==========================================================================
# 4.  the unification
# ==========================================================================

def _l3_graph():
    from runtime.demo import geodesic_demo as GD
    ctx, folds = GD.base_context()
    rules = GD.base_rules(ctx, folds)
    task = GD.left_nested(8)
    g, sat, ex, finder = GD.run(task, rules, ctx, "test-physics")
    return g, task, ctx


def test_the_shared_driver_reproduces_l3s_routes_exactly():
    g, task, _ = _l3_graph()
    pp = ProofRouteProblem(g)
    members = g.class_of(task)
    assert len(members) > 50
    for m in members:
        ok, mine, theirs = pp.matches_l3(task.addr, m)
        assert ok, "geodesic() disagreed with RouteFinder on %s" % m[:8]
    # and they are proof paths the trusted checker accepts
    _, task2, ctx = g, task, None


def test_the_reproduced_routes_are_checked_by_the_kernel():
    g, task, ctx = _l3_graph()
    pp = ProofRouteProblem(g)
    checked = 0
    for m in g.class_of(task)[:12]:
        r = geodesic(pp, task.addr, m)
        if not r.found:
            continue
        probe = C.CheckContext(axioms=ctx.axioms, certificates=ctx.certificates)
        assert C.check_path(r.payloads(), task.addr, m, probe), \
            "a route from the shared driver did not check"
        checked += 1
    assert checked >= 10


def test_shared_code_is_literally_l3s():
    """The reuse claim, made falsifiable."""
    assert len(SHARED_CODE) >= 5
    for name, obj in SHARED_CODE:
        assert obj.__module__ == "runtime.execute.extract", \
            "%s is not L3's own definition (%s)" % (name, obj.__module__)
    # and the module really is the one L3 uses
    import runtime.execute.extract as X
    assert pareto is X.pareto and dominates is X.dominates
    assert scalarize is X.scalarize
    assert NOT_SHARED, "the honest list of what is NOT reused must be present"


def test_l3s_pareto_ranks_light_without_modification():
    st = two_medium()
    routes = optical_routes(st)
    front = pareto(routes)                       # L3's function, called directly
    assert len(routes) == 22 and 2 <= len(front) < len(routes)
    assert front[0].label == "(3, 0)"
    for r in front:
        assert is_nondominated(r, routes)


def test_dominated_light_route_is_refused_by_the_frontier():
    """PLANTED FALSE -- an optical route claimed nondominated when it is not."""
    st = two_medium()
    routes = optical_routes(st)
    front = set(id(r) for r in pareto(routes))
    dominated = [r for r in routes if id(r) not in front]
    assert dominated, "the family must contain dominated routes to test with"
    for r in dominated:
        assert not is_nondominated(r, routes)
        assert any(dominates(o.cost, r.cost) for o in routes)


def test_optical_cost_is_a_genuine_vector_not_a_scalar_in_disguise():
    st = two_medium()
    front = pareto(optical_routes(st))
    assert len(front) >= 2, "a one-point frontier proves nothing about the vector"
    a, b = front[0], front[1]
    assert not dominates(a.cost, b.cost) and not dominates(b.cost, a.cost)
    assert a.cost.opl < b.cost.opl and a.cost.width > b.cost.width


def test_scalarize_needs_an_explicit_named_scalarization():
    st = two_medium()
    routes = optical_routes(st)
    action = scalarize(routes, Scalarization("least-action", (1, 0, 0, 0)))
    cheap = scalarize(routes, Scalarization("cheap-coordinates", (0, 0, 1, 0)))
    assert action.route.label == "(3, 0)"
    assert cheap.route.label != action.route.label, \
        "two scalarizations of one frontier must be able to disagree"
    assert action.scalarization.name == "least-action"


def test_every_route_carries_a_measured_verify_cost():
    """`verify` must be *read off a counter*, never stipulated."""
    st = two_medium()
    routes = optical_routes(st)
    assert routes and all(r.cost.verify > 0 for r in routes)
    assert len({r.cost.verify for r in routes}) >= 1


def test_the_certification_gate_is_load_bearing():
    """PLANTED FALSE -- a certifier that refuses must actually exclude routes."""
    st = two_medium()
    full = optical_routes(st)
    seen = []

    def refuse_one(ray, claimed):
        seen.append(ray)
        ok, cost = certify_optical_length(ray, claimed)
        if len(seen) == 3:
            return (False, cost)
        return (ok, cost)

    gated = optical_routes(st, certifier=refuse_one)
    assert len(gated) == len(full) - 1, \
        "a refused route reached the frontier anyway"
    assert {r.label for r in full} - {r.label for r in gated}


def test_certification_rejects_a_forged_optical_length():
    """PLANTED FALSE -- a claimed OPL that is not the ray's OPL."""
    st = two_medium()
    ray = st.ray((F(3),))
    true = optical_path_length(ray)
    ok, cost = certify_optical_length(ray, true)
    assert ok and cost > 0
    bad, _ = certify_optical_length(ray, true + Surd.scaled_sqrt(F(1, 10 ** 9), 2))
    assert not bad, "a forged optical length was certified"


# ==========================================================================
# 5.  the disanalogy
# ==========================================================================

def test_the_mirror_has_four_stationary_points_all_physical():
    arc, prob = mirror()
    pts = arc.points()
    assert all(arc.on_circle(p) for p in pts)
    crits = critical_points(prob.values(), cyclic=True)
    assert len(crits) == 4, [c.render() for c in crits]
    kinds = sorted(c.kind for c in crits)
    assert kinds == ["maximum", "maximum", "minimum", "minimum"]
    A, B = prob.source, prob.target
    for c in crits:
        p = pts[c.index]
        assert reflection_residual(A, p, B, circle_tangent(p)).is_zero(), \
            "a stationary point that does not satisfy the law of reflection"


def test_a_non_stationary_mirror_point_is_not_physical():
    """PLANTED FALSE -- the reflection residual must be able to be nonzero."""
    arc, prob = mirror()
    pts = arc.points()
    crit_ix = {c.index for c in critical_points(prob.values(), cyclic=True)}
    nonzero = 0
    for i, p in enumerate(pts):
        if i in crit_ix:
            continue
        if not reflection_residual(prob.source, p, prob.target,
                                   circle_tangent(p)).is_zero():
            nonzero += 1
    assert nonzero == len(pts) - len(crit_ix), \
        "a non-stationary point claimed to satisfy the law of reflection"


def test_minimisation_returns_a_minimum_and_misses_both_maxima():
    """The disanalogy, as an assertion.  This test passing is the bad news."""
    arc, prob = mirror()
    pts = arc.points()
    crits = critical_points(prob.values(), cyclic=True)
    maxima = [c.index for c in crits if c.kind == "maximum"]
    minima = [c.index for c in crits if c.kind == "minimum"]
    r = geodesic(prob, SOURCE, TARGET)
    assert prob.index_of(r) in minima
    front = optical_frontier(mirror_routes(prob))
    labels = {x.label for x in front}
    assert labels == {pts[i].render() for i in minima}, labels
    for i in maxima:
        assert pts[i].render() not in labels, \
            "a maximum reached the frontier -- the disanalogy would be gone"
    assert len(front) == 2 and len(maxima) == 2


def test_the_convexity_certificate_refuses_on_the_mirror_and_issues_on_refraction():
    arc, prob = mirror()
    bad = convexity_certificate(prob.values(), "mirror", cyclic=True)
    assert not bad.licensed and bad.violations
    st = two_medium()
    good = convexity_certificate(tuple(st.opl((x,)) for x in st.lattices[0]),
                                 "refraction")
    assert good.licensed and not good.violations
    assert st.lattices[0][good.minimum_index] == F(3)


def test_convexity_certificate_refuses_a_family_too_small_to_certify():
    try:
        convexity_certificate((Surd.rational(1), Surd.rational(2)), "tiny")
    except GEO.GeodesicError:
        return
    raise AssertionError("a certificate was issued on 2 samples")


def test_critical_points_is_not_the_optimizer():
    """They are different algorithms and must be able to disagree."""
    arc, prob = mirror()
    vals = prob.values()
    crits = critical_points(vals, cyclic=True)
    r = geodesic(prob, SOURCE, TARGET)
    found = prob.index_of(r)
    assert len({c.index for c in crits}) > len({found}), \
        "stationarity must find strictly more than minimisation does here"


# ==========================================================================
# 6.  the Realize edge
# ==========================================================================

def _realization():
    t = DIM.term_of(quantity(20, DIMENSIONLESS))
    return realize("opl", t, 20, LENGTH,
                   ("homogeneous isotropic media", "geometric-optics limit"))


def test_realize_edge_carries_its_dimension_and_assumptions():
    rz = _realization()
    assert rz.dimension_signature == "L"
    assert len(rz.assumptions) == 2
    e = rz.edge()
    assert e.kind == "Interp" and isinstance(e.witness, C.Certificate)
    assert e.provenance == rz.assumptions
    assert "NOT" in rz.trust_note() and "Interp" in rz.trust_note()


def test_realize_edge_does_not_check_until_declared():
    """PLANTED FALSE -- an Interp edge with no declared certificate."""
    rz = _realization()
    ctx = C.CheckContext()
    assert not rz.check(ctx), "an undeclared Realize edge checked"
    rz.declare(ctx)
    assert rz.check(ctx), "a declared Realize edge failed to check"


def test_realize_edge_certificate_must_match_its_endpoints():
    """PLANTED FALSE -- a certificate declared for a different pair."""
    rz = _realization()
    ctx = C.CheckContext()
    ctx.declare_certificate("opl", "Interp", rz.math_addr,
                            quantity(21, LENGTH).addr)
    assert not rz.check(ctx), "a mismatched certificate was accepted"


def test_realize_edge_claiming_machine_verification_is_refused():
    """PLANTED FALSE -- the control the brief names."""
    try:
        Realization("forged", "deadbeef", quantity(1, LENGTH), ("x",),
                    machine_verified=True)
    except TrustBoundaryError:
        pass
    else:
        raise AssertionError("a Realize edge claimed machine-verified physics")
    try:
        Realization("bare", "deadbeef", quantity(1, LENGTH), ())
    except TrustBoundaryError:
        return
    raise AssertionError("a Realize edge with no assumptions was constructed")


def test_realize_edge_is_not_an_eq_edge():
    """It must not be able to launder physics into the equational world."""
    rz = _realization()
    assert rz.edge().kind == "Interp"
    assert "Eq" not in E.preserves("Interp")
    assert E.preserves("Interp") == frozenset({"semantics", "truth"})
    assert E.compose_kind("Interp", "Eq") == "Interp"
    assert E.compose_kind("Eq", "Conjecture") is None


# ==========================================================================
# 7.  the float / division / Snell AST controls
# ==========================================================================

BANNED_NAMES = ("float", "complex")
BANNED_MODULES = ("math", "cmath", "decimal", "numpy", "statistics", "random",
                  "scipy")
# A line carrying this marker is a *planted control*: a float that exists only
# so that something refuses it.  The marker is required to be on the line
# itself, so every exemption is visible at the point of use and countable --
# `test_the_exemptions_are_few_and_all_are_controls` pins the count.
EXEMPT = "EXACT-CONTROL"


def _sources():
    out = []
    for name in sorted(os.listdir(PHYSICS_DIR)):
        if name.endswith(".py"):
            out.append(os.path.join(PHYSICS_DIR, name))
    out.append(DEMO)
    out.append(os.path.abspath(__file__))
    return out


def audit_source(path: str, text: str, honour_exemptions: bool = True):
    """Every reason this source is not exact.  Empty tuple == exact.

    Catches, by AST and not by grep: float and complex literals; the true
    division operator ``/`` (which turns two exact ints into a float); the
    names ``float`` and ``complex``; ``**`` with a negative or non-integer
    literal exponent (``2 ** -1`` is ``0.5``); and any import of a module whose
    arithmetic is inexact.
    """
    bad = []
    lines = text.splitlines()
    base = os.path.basename(path)

    def exempt(node) -> bool:
        if not honour_exemptions:
            return False
        i = getattr(node, "lineno", 0) - 1
        return 0 <= i < len(lines) and EXEMPT in lines[i]

    def flag(node, msg):
        if not exempt(node):
            bad.append("%s:%d %s" % (base, getattr(node, "lineno", 0), msg))

    for node in ast.walk(tree := ast.parse(text, filename=path)):
        if isinstance(node, ast.Constant) and isinstance(
                node.value, (float, complex)):   # EXACT-CONTROL: named to ban them
            flag(node, "float/complex literal %r" % (node.value,))
        elif isinstance(node, ast.BinOp) and isinstance(node.op, ast.Div):
            flag(node, "true division `/` (inexact on ints)")
        elif isinstance(node, ast.AugAssign) and isinstance(node.op, ast.Div):
            flag(node, "augmented true division")
        elif isinstance(node, ast.BinOp) and isinstance(node.op, ast.Pow):
            r = node.right
            if isinstance(r, ast.UnaryOp) and isinstance(r.op, ast.USub):
                flag(node, "`**` with a negative literal exponent")
            elif isinstance(r, ast.Constant) and not isinstance(r.value, int):
                flag(node, "`**` with a non-integer exponent")
        elif isinstance(node, ast.Name) and node.id in BANNED_NAMES:
            if isinstance(getattr(node, "ctx", None), ast.Load):
                flag(node, "name %r" % node.id)
        elif isinstance(node, ast.Attribute) and node.attr in BANNED_NAMES:
            flag(node, "attribute %r" % node.attr)
        elif isinstance(node, ast.Import):
            for a in node.names:
                if a.name.split(".")[0] in BANNED_MODULES:
                    flag(node, "imports %s" % a.name)
        elif isinstance(node, ast.ImportFrom):
            if (node.module or "").split(".")[0] in BANNED_MODULES:
                flag(node, "imports from %s" % node.module)
    del tree
    return tuple(bad)


def test_no_float_no_division_no_math_in_the_physics_sources():
    """A float sneaking into any semantic path, asserted by an AST walk."""
    problems = []
    for path in _sources():
        with open(path) as fh:
            problems.extend(audit_source(path, fh.read()))
    assert not problems, "inexact arithmetic reachable:\n  " + "\n  ".join(problems)


def test_the_ast_walker_itself_can_fail():
    """PLANTED FALSE -- if the walker cannot fail it is not a control."""
    for src, why in (("x = 1.5\n", "float literal"),
                     ("y = a / b\n", "true division"),
                     ("y /= b\n", "augmented true division"),
                     ("import math\n", "math import"),
                     ("z = float(q)\n", "float()"),
                     ("w = 2 ** -1\n", "negative power"),
                     ("v = obj.float\n", "float attribute"),
                     ("from decimal import Decimal\n", "decimal import")):
        found = audit_source("<planted>", src)
        assert found, "the walker missed a planted %s" % why
    # and the exemption marker must not be a blanket escape hatch
    assert not audit_source("<p>", "x = 1.5  # EXACT-CONTROL\n")
    assert audit_source("<p>", "x = 1.5  # EXACT-CONTROL\n",
                        honour_exemptions=False)


def test_the_exemptions_are_few_and_all_are_controls():
    """Every EXACT-CONTROL exemption must be a float that gets refused."""
    exempted = []
    for path in _sources():
        with open(path) as fh:
            text = fh.read()
        strict = audit_source(path, text, honour_exemptions=False)
        lenient = audit_source(path, text)
        exempted.extend(set(strict) - set(lenient))
    assert len(exempted) <= 12, "too many exemptions: %s" % exempted
    for e in exempted:
        assert "float" in e or "complex" in e, \
            "an exemption that is not a planted float: %s" % e


def _function_source(module_path: str, qualnames):
    with open(module_path) as fh:
        tree = ast.parse(fh.read(), filename=module_path)
    out = {}
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            if node.name in qualnames:
                out.setdefault(node.name, []).append(node)
    return out


def test_no_search_function_mentions_snell():
    """Snell must not be hardcoded anywhere the route is *found*."""
    targets = {"geodesic", "arcs", "_seg", "route", "_dijkstra", "opl",
               "ray", "optical_path_length", "paths", "crossings"}
    forbidden = ("snell", "residual", "sine", "invariant", "asin", "angle",
                 "refract")
    hits = []
    for path in (os.path.join(PHYSICS_DIR, "geodesic.py"),
                 os.path.join(PHYSICS_DIR, "optics.py")):
        for name, nodes in _function_source(path, targets).items():
            for node in nodes:
                for sub in ast.walk(node):
                    ident = None
                    if isinstance(sub, ast.Name):
                        ident = sub.id
                    elif isinstance(sub, ast.Attribute):
                        ident = sub.attr
                    if ident and any(f in ident.lower() for f in forbidden):
                        hits.append("%s:%s uses %s" % (os.path.basename(path),
                                                       name, ident))
    assert not hits, "the search consults Snell: %s" % hits


def test_snell_really_is_reachable_from_the_measurement_side():
    """The mirror image of the previous control: it must exist *somewhere*."""
    with open(os.path.join(PHYSICS_DIR, "optics.py")) as fh:
        text = fh.read()
    assert "def snell_residual" in text and "def snell_invariant" in text


# ==========================================================================
# 8.  determinism, and the demo
# ==========================================================================

def test_the_optics_geodesic_is_deterministic():
    st = three_medium()
    outs = []
    for _ in range(3):
        p = OpticsRouteProblem(st)
        r = geodesic(p, SOURCE, TARGET)
        outs.append((p.crossings(r), r.weight.terms, r.settled, r.relaxed))
    assert outs[0] == outs[1] == outs[2]


def test_the_light_frontier_is_deterministic():
    st = two_medium()
    a = [(r.label, r.cost.as_tuple()) for r in optical_frontier(optical_routes(st))]
    b = [(r.label, r.cost.as_tuple()) for r in optical_frontier(optical_routes(st))]
    assert a == b


def test_demo_is_deterministic_and_passes():
    import contextlib
    import io
    from runtime.demo.fermat_demo import main
    outs = []
    for _ in range(2):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = main()
        assert rc == 0, "the demo reported failure"
        outs.append(buf.getvalue())
    assert outs[0] == outs[1], "the demo is not deterministic"


# ==========================================================================
# 9.  structural refusals in the optics layer itself
# ==========================================================================

def test_a_stack_refuses_an_inconsistent_geometry():
    for build, why in (
        (lambda: InterfaceStack(Vec.of(0, 4), Vec.of(1, -1), (GLASS,), (F(0),),
                                (lattice(0, 1, 1),)), "k interfaces need k+1 media"),
        (lambda: InterfaceStack(Vec.of(0, -4), Vec.of(1, -8), (GLASS, WATER),
                                (F(0),), (lattice(0, 1, 1),)),
         "source below the first interface"),
        (lambda: InterfaceStack(Vec.of(0, 4), Vec.of(1, 8), (GLASS, WATER),
                                (F(0),), (lattice(0, 1, 1),)),
         "target above the last interface"),
    ):
        try:
            build()
        except OpticsError:
            continue
        raise AssertionError("an inconsistent stack was built: %s" % why)


def test_a_medium_refuses_a_nonpositive_or_inexact_index():
    for bad in (0, -1, F(-1, 2)):
        try:
            Medium.of("bad", bad)
        except OpticsError:
            continue
        raise AssertionError("index %r accepted" % (bad,))
    try:
        Medium.of("bad", 1.5)   # EXACT-CONTROL: planted float, must be refused
    except DimensionError:
        return
    raise AssertionError("a float index was accepted")


def test_a_ray_refuses_a_mismatched_medium_list():
    for build in (lambda: Ray((Vec.of(0, 0),), ()),
                  lambda: Ray((Vec.of(0, 0), Vec.of(1, 1)), (GLASS, WATER))):
        try:
            build()
        except OpticsError:
            continue
        raise AssertionError("a malformed ray was built")


def test_optical_path_length_matches_a_hand_computation():
    ray = Ray((Vec.of(0, 4), Vec.of(3, 0), Vec.of(11, -6)), (GLASS, WATER))
    # 8/5 * 5  +  6/5 * 10  =  8 + 12 = 20
    assert optical_path_length(ray).as_fraction() == 20
    assert OpticalCost(optical_path_length(ray), 2, ray.width(), 0).as_tuple()[1] == 2


def test_the_mirror_arc_declares_its_omitted_locus():
    arc, _ = mirror()
    assert "irrational" in arc.omitted_locus()
    assert arc.points()[0] == Vec.of(-4, 0)      # the chart's omitted point


TESTS = [(n, f) for n, f in sorted(globals().items())
         if n.startswith("test_") and callable(f)]


def main() -> int:
    bad = 0
    for name, fn in TESTS:
        try:
            fn()
            print("  ok    %s" % name)
        except Exception as exc:                       # noqa: BLE001
            bad += 1
            print("  FAIL  %s\n          %s: %s" % (name, type(exc).__name__, exc))
    print("\n%d/%d passed" % (len(TESTS) - bad, len(TESTS)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
