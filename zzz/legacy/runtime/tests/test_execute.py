#!/usr/bin/env python3
"""Adversarial tests for L3 execution (rewriting, e-matching, saturation,
cost-vector extraction).

Run standalone:   python3 runtime/tests/test_execute.py
or under pytest:  pytest runtime/tests/test_execute.py

Per `collab/PROTOCOL.md` Sec.7, every capability is paired with a planted
control that must fail.  The four the brief names explicitly are:

* a rewrite whose justification the checker rejects
  -> ``test_planted_false_rule_is_never_applied``
     ``test_forged_rule_contributes_nothing_to_the_egraph``
* an e-match that must not match modulo an equality that was never merged
  -> ``test_ematch_does_not_match_across_an_unmerged_equality``
* an extraction claiming a dominated route is Pareto-optimal
  -> ``test_dominated_route_is_refused_by_the_frontier``
* a saturation that must report budget exhaustion rather than a fixpoint
  -> ``test_saturation_reports_budget_exhaustion_not_a_fixpoint``
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.kernel import check as C                                  # noqa: E402
from runtime.kernel import edges as E                                  # noqa: E402
from runtime.kernel import term as T                                   # noqa: E402
from runtime.kernel.egraph import EGraph                               # noqa: E402
from runtime.execute import (Budget, ClassExtractor, CostVector,       # noqa: E402
                             EMatchBudget,
                             Route, RouteFinder, Rule, RewriteError,
                             Scalarization, apply_rule, arith_width,
                             compile_pattern, count_steps, dominates,
                             ematch, expand_path, extract_class_frontier,
                             extract_routes, frontier_diff, install_theorem,
                             is_nondominated, literal_value, match,
                             measure_route, pareto, positions, reverse_path,
                             rewrite_all, rule_from_axiom, rule_from_edge,
                             saturate, scalarize, substitute_path, subterm_at,
                             term_size)

# --------------------------------------------------------------------------
# a small shared signature
# --------------------------------------------------------------------------

Z = T.base_sort("Z")
W = T.base_sort("W")
ZZ = T.arrow(Z, Z)
ZZZ = T.arrow(Z, ZZ)

MUL = T.Const("mul", ZZZ)
SQR = T.Const("sqr", ZZ)
F = T.Const("f", ZZ)
G2 = T.Const("g", ZZZ)


def mul(a, b):
    return T.App(T.App(MUL, a), b)


def sqr(a):
    return T.App(SQR, a)


def lit(n):
    return T.Const("#%d" % n, Z)


VA, VB, VC = (T.Const(s, Z) for s in ("?a", "?b", "?c"))
VU = T.Const("?u", Z)
VP = T.Const("?p", Z)
VW = T.Const("?w", W)

A, B, D = (T.Const(s, Z) for s in ("a", "b", "d"))


def book(exp=4):
    """assoc + sqr_def + exact folds, and the left-nested task ``3^exp``."""
    ctx = C.CheckContext()
    ctx.declare_axiom("assoc", mul(mul(VA, VB), VC), mul(VA, mul(VB, VC)))
    ctx.declare_axiom("sqr_def", sqr(VU), mul(VU, VU))
    rules = [rule_from_axiom(ctx, "assoc", ("?a", "?b", "?c")),
             rule_from_axiom(ctx, "sqr_def", ("?u",))]
    for i in range(1, exp):
        for j in range(1, exp):
            if i + j <= exp:
                n = "fold.%d.%d" % (i, j)
                ctx.declare_axiom(n, mul(lit(3 ** i), lit(3 ** j)),
                                  lit(3 ** (i + j)))
                rules.append(rule_from_axiom(ctx, n))
        if 2 * i <= exp:
            n = "sqfold.%d" % i
            ctx.declare_axiom(n, sqr(lit(3 ** i)), lit(3 ** (2 * i)))
            rules.append(rule_from_axiom(ctx, n))
    task = lit(3)
    for _ in range(exp - 1):
        task = mul(task, lit(3))
    return ctx, rules, task


def copyctx(ctx):
    return C.CheckContext(axioms=dict(ctx.axioms),
                          certificates=dict(ctx.certificates), fuel=ctx.fuel)


def saturated(exp=4, budget=None):
    ctx, rules, task = book(exp)
    g = EGraph()
    g.add(task)
    sat = saturate(g, rules, ctx, budget or Budget(max_iterations=12))
    return ctx, rules, task, g, sat


# ==========================================================================
# 1. rewriting: an accepted equality becomes a checked rewrite
# ==========================================================================

def test_axiom_becomes_a_rule_usable_in_both_directions():
    ctx, rules, _ = book()
    assoc = rules[0]
    assert assoc.name == "assoc"
    assert assoc.directions() == ("fwd", "bwd")
    assert assoc.arity() == 3


def test_application_emits_a_justification_the_checker_accepts():
    ctx, rules, task = book()
    assoc = rules[0]
    hits = [p for p in positions(task)
            if match(assoc.lhs, subterm_at(task, p), assoc.variables) is not None]
    assert hits, "assoc must match somewhere in the task"
    r = apply_rule(task, assoc, "fwd", hits[0], ctx)
    assert r is not None
    assert C.check_path(r.path, task.addr, r.dst.addr, ctx)
    assert r.dst is not task


def test_backward_application_is_checked_by_the_same_witness():
    ctx, rules, task = book()
    sqrd = rules[1]
    inner = mul(lit(3), lit(3))
    hits = [p for p in positions(task)
            if subterm_at(task, p) is inner]
    assert hits
    r = apply_rule(task, sqrd, "bwd", hits[0], ctx)
    assert r is not None and r.direction == "bwd"
    assert C.check_path(r.path, task.addr, r.dst.addr, ctx)
    assert sqr(lit(3)) in T.subterms(r.dst)


def test_rewrite_all_returns_only_checked_rewrites():
    ctx, rules, task = book()
    got = rewrite_all(task, rules[:2], ctx)
    assert got
    for r in got:
        assert C.check_path(r.path, r.src.addr, r.dst.addr, ctx)


# -- planted controls ------------------------------------------------------

def test_planted_false_rule_is_never_applied():
    """A rule that matches, builds a term, and lies about the axiom's right
    side.  The checker rejects the step, so ``apply_rule`` must return None."""
    ctx, rules, task = book()
    assoc = rules[0]
    # mul(mul(a,c),b) can never coincide with the axiom's mul(a,mul(b,c)):
    # that would need a = mul(a,c).  So the forgery is false at every instance,
    # not merely at most of them.
    forged = Rule(name="assoc", lhs=assoc.lhs, rhs=mul(mul(VA, VC), VB),
                  variables=assoc.variables)
    hits = [p for p in positions(task)
            if match(forged.lhs, subterm_at(task, p), forged.variables) is not None]
    assert hits, "the forged rule must still MATCH -- otherwise nothing is tested"
    before = len(ctx.errors)
    assert apply_rule(task, forged, "fwd", hits[0], ctx) is None
    assert len(ctx.errors) > before
    assert "witness sides" in ctx.errors[-1]


def test_rule_from_an_undeclared_axiom_is_refused():
    ctx, _, _ = book()
    try:
        rule_from_axiom(ctx, "no_such_axiom")
        assert False, "an undeclared axiom must not become a rule"
    except RewriteError:
        pass


def test_rule_with_variables_that_do_not_occur_is_refused():
    ctx, _, _ = book()
    try:
        rule_from_axiom(ctx, "assoc", ("?a", "?zzz"))
        assert False, "a variable that occurs nowhere must be refused"
    except RewriteError:
        pass


def test_conjecture_edge_never_becomes_a_rewrite():
    ctx, _, _ = book()
    e = E.Edge(kind="Conjecture", src=mul(A, B).addr, dst=mul(B, A).addr)
    assert not C.check_edge(e, ctx)
    try:
        rule_from_edge(e, ctx, "conj")
        assert False, "a Conjecture edge must never become a rewrite rule"
    except RewriteError:
        pass


def test_eq_edge_with_an_unchecked_proof_is_refused():
    ctx, _, _ = book()
    bogus = (C.Step(A.addr, B.addr, "assumption", C.Axiom("nope")),)
    e = E.Edge(kind="Eq", src=A.addr, dst=B.addr, witness=bogus)
    try:
        rule_from_edge(e, copyctx(ctx), "bad", ())
        assert False, "an Eq edge whose path does not check must be refused"
    except RewriteError:
        pass


def test_bare_variable_pattern_is_not_a_usable_direction():
    ctx = C.CheckContext()
    ctx.declare_axiom("id", VU, sqr(VU))
    r = rule_from_axiom(ctx, "id", ("?u",))
    assert "fwd" not in r.directions()      # lhs is a bare variable
    assert "bwd" in r.directions()


def test_matching_refuses_to_bind_an_open_term():
    """``subst_consts`` does not shift de Bruijn indices, so binding an open
    term could be captured under a binder.  Matching must refuse it."""
    open_body = T.App(F, T.Var(0, Z))
    assert match(T.App(F, VU), open_body, {"?u"}) is None
    assert match(T.App(F, VU), T.App(F, A), {"?u"}) is not None


def test_matching_respects_sorts_and_repeated_variables():
    assert match(mul(VU, VU), mul(A, A), {"?u"}) is not None
    assert match(mul(VU, VU), mul(A, B), {"?u"}) is None
    assert match(T.App(F, VU), T.App(F, A), {"?w"}) is None   # ?w is sort W


# ==========================================================================
# 2. theorems: proved, installed, and expandable back to primitives
# ==========================================================================

def _pow2_theorem(ctx, rules):
    """``(p*p) = sqr p`` is an axiom; prove the honest ``((p*p)*p)*p = sqr(sqr p)``."""
    lhs = mul(mul(mul(VP, VP), VP), VP)
    rhs = sqr(sqr(VP))
    g = EGraph()
    g.add(lhs)
    g.add(rhs)
    saturate(g, [r for r in rules if r.name in ("assoc", "sqr_def")], ctx,
             Budget(max_iterations=8), tag="pf")
    assert g.equal(lhs, rhs)
    path = RouteFinder(g).route(lhs.addr, rhs.addr)
    return lhs, rhs, path


def test_theorem_is_proved_checked_and_installed():
    ctx, rules, _ = book()
    lhs, rhs, path = _pow2_theorem(ctx, rules)
    assert C.check_path(path, lhs.addr, rhs.addr, ctx)
    after = copyctx(ctx)
    rule = rule_from_edge(E.Edge(kind="Eq", src=lhs.addr, dst=rhs.addr,
                                 witness=path), after, "pow4", ("?p",))
    assert rule.origin == "theorem"
    assert count_steps(rule.expansion) == count_steps(path)
    assert "pow4" in after.axioms and "pow4" not in ctx.axioms


def test_theorem_proof_must_check_against_the_book_before_it_exists():
    ctx, rules, _ = book()
    lhs, rhs, _ = _pow2_theorem(ctx, rules)
    junk = (C.Step(lhs.addr, rhs.addr, "assumption", C.Axiom("pow4")),)
    try:
        install_theorem(copyctx(ctx), "pow4", lhs, rhs, junk, ("?p",))
        assert False, "a theorem may not be its own justification"
    except RewriteError:
        pass


def test_theorem_whose_parameter_occurs_in_an_axiom_is_refused():
    """The schematic reading is sound only when the parameter is opaque to the
    whole book.  ``?u`` occurs in ``sqr_def``, so generalising over it is not."""
    ctx, rules, _ = book()
    lhs = mul(mul(mul(VU, VU), VU), VU)
    rhs = sqr(sqr(VU))
    g = EGraph()
    g.add(lhs)
    g.add(rhs)
    saturate(g, [r for r in rules if r.name in ("assoc", "sqr_def")], ctx,
             Budget(max_iterations=8), tag="pf2")
    path = RouteFinder(g).route(lhs.addr, rhs.addr)
    assert path is not None
    try:
        install_theorem(copyctx(ctx), "pow4u", lhs, rhs, path, ("?u",))
        assert False, "a parameter that occurs in an axiom must be refused"
    except RewriteError as exc:
        assert "unsound" in str(exc)


def test_theorem_use_expands_to_primitives_and_rechecks_without_the_theorem():
    ctx, rules, task = book()
    lhs, rhs, path = _pow2_theorem(ctx, rules)
    after = copyctx(ctx)
    pow4 = install_theorem(after, "pow4", lhs, rhs, path, ("?p",))
    hits = [p for p in positions(task)
            if match(lhs, subterm_at(task, p), {"?p"}) is not None]
    assert hits
    r = apply_rule(task, pow4, "fwd", hits[0], after)
    assert r is not None
    prim = expand_path(r.path, rules + [pow4])
    assert count_steps(prim) > count_steps(r.path), "the theorem must compress"
    theorem_free = copyctx(ctx)
    assert "pow4" not in theorem_free.axioms
    assert C.check_path(prim, task.addr, r.dst.addr, theorem_free)


def test_expansion_of_a_forged_theorem_does_not_check():
    """Planted control: a rule labelled ``theorem`` whose retained proof proves
    something else.  Expansion must produce a path the checker rejects."""
    ctx, rules, _ = book()
    lhs, rhs, path = _pow2_theorem(ctx, rules)
    other = sqr(sqr(sqr(VP)))
    after = copyctx(ctx)
    after.declare_axiom("liar", lhs, other)
    forged = Rule(name="liar", lhs=lhs, rhs=other, variables=frozenset({"?p"}),
                  origin="theorem", expansion=path)     # proof of lhs = rhs, not other
    step = C.Step(lhs.addr, other.addr, "assumption",
                  C.Instantiate("liar", ()))
    assert C.check_step(step, after), "the axiom itself is trusted (T3)"
    prim = expand_path((step,), [forged])
    probe = copyctx(ctx)
    assert not C.check_path(prim, lhs.addr, other.addr, probe), \
        "the expansion must not check -- the retained proof proves something else"


def test_substitute_path_and_reverse_path_preserve_checkability():
    ctx, rules, _ = book()
    lhs, rhs, path = _pow2_theorem(ctx, rules)
    back = reverse_path(path)
    assert C.check_path(back, rhs.addr, lhs.addr, ctx)
    sigma = {"?p": lit(3)}
    inst = substitute_path(path, sigma)
    l2 = T.subst_consts(lhs, sigma)
    r2 = T.subst_consts(rhs, sigma)
    assert C.check_path(inst, l2.addr, r2.addr, ctx)


# ==========================================================================
# 3. e-matching against e-classes
# ==========================================================================

def test_ematch_finds_a_shape_that_is_in_no_stored_term():
    ctx, rules, task, g, sat = saturated(8)
    pat = mul(mul(mul(VP, VP), VP), VP)
    res = ematch(g, pat, {"?p"})
    assert res.complete
    known = set(g.terms())
    unstored = [m for m in res.matches
                if T.subst_consts(pat, dict(m.subst)).addr not in known]
    assert unstored, "e-matching must see shapes that are not stored anywhere"
    for m in unstored:
        # every position of the claimed match really is in the right class
        inst = T.subst_consts(pat, dict(m.subst))
        g.add(inst)
        assert g.equal(inst, m.matched)


def test_ematch_does_not_match_across_an_unmerged_equality():
    """The planted control for e-matching: ``g(?u,?u)`` must NOT match
    ``g(a,b)`` while ``a = b`` is unproved, and must match the moment it is."""
    ga = T.App(T.App(G2, A), B)
    g = EGraph()
    g.add(ga)
    pat = T.App(T.App(G2, VU), VU)
    before = ematch(g, pat, {"?u"})
    assert before.complete
    assert not [m for m in before.matches if m.matched == ga.addr], \
        "matching modulo an equality that was never merged is unsound"
    ctx = C.CheckContext()
    ctx.declare_axiom("ab", A, B)
    g.merge(A, B, C.Axiom("ab"), edge_id="AB")
    after = ematch(g, pat, {"?u"})
    assert [m for m in after.matches if m.matched == ga.addr], \
        "once a = b is merged the pattern must match"


def test_ematch_reports_its_bound_instead_of_truncating_silently():
    _, _, _, g, _ = saturated(8)
    pat = mul(mul(mul(VP, VP), VP), VP)
    tight = ematch(g, pat, {"?p"}, EMatchBudget(max_visits=50))
    assert tight.exhausted and not tight.complete
    assert tight.reason == "max_visits"
    loose = ematch(g, pat, {"?p"}, EMatchBudget(max_visits=5000000))
    assert loose.complete
    assert len(loose.matches) >= len(tight.matches)


def test_ematch_reports_a_representative_bound_too():
    _, _, _, g, _ = saturated(8)
    res = ematch(g, sqr(VU), {"?u"}, EMatchBudget(max_representatives=2))
    assert res.exhausted and res.reason == "max_representatives"


def test_ematch_refuses_a_bare_variable_pattern():
    g = EGraph()
    g.add(mul(A, B))
    try:
        ematch(g, VU, {"?u"})
        assert False, "a bare variable pattern must be refused"
    except ValueError:
        pass


def test_ematch_respects_sorts_across_classes():
    """A variable of sort W may only ever be bound to a W-class, even when a
    Z-class sits at the same position in some other stored term."""
    h = T.Const("h", T.arrow(W, Z))
    w = T.Const("w", W)
    g = EGraph()
    g.add(T.App(h, w))
    g.add(mul(A, B))                       # Z-sorted material in the same graph
    res = ematch(g, T.App(h, VW), {"?w"})
    assert res.matches
    for m in res.matches:
        for _, v in m.subst:
            assert v.sort is W
    # and the kernel refuses even to *build* the ill-sorted pattern
    try:
        T.App(h, VU)
        assert False, "an ill-sorted pattern must not be constructible"
    except T.SortError:
        pass


def test_ematch_is_deterministic():
    _, _, _, g, _ = saturated(6)
    pat = mul(mul(VA, VB), VC)
    a = ematch(g, pat, {"?a", "?b", "?c"})
    b = ematch(g, pat, {"?a", "?b", "?c"})
    assert [m.key() for m in a.matches] == [m.key() for m in b.matches]
    assert a.visits == b.visits


def _differential_patterns():
    """Patterns exercising every instruction the compiler can emit."""
    return [
        (mul(mul(mul(VP, VP), VP), VP), {"?p"}),          # repeated variable
        (mul(mul(VA, VB), VC), {"?a", "?b", "?c"}),       # distinct variables
        (mul(mul(VA, VB), mul(VB, VA)), {"?a", "?b"}),    # late compares
        (mul(VA, VA), {"?a"}),                            # shallow
        (sqr(VU), {"?u"}),                                # unary spine
        (mul(lit(9), VA), {"?a"}),                        # a ground argument
        (mul(mul(lit(3), lit(3)), VA), {"?a"}),           # ground subterm
        (mul(mul(mul(VA, VB), VC), mul(VA, VB)),          # deep + repeats
         {"?a", "?b", "?c"}),
    ]


def test_ematch_automaton_agrees_with_the_recursive_matcher():
    """The differential test that licenses replacing the search.

    The compiled automaton and the memoised recursive matcher must return the
    *same matches in the same order* -- not the same count, and not the same
    set: the same sequence of keys.  If a future optimisation reorders or drops
    a match, this fails, and the two engines can be bisected against each other
    without editing the module.
    """
    for size in (6, 8):
        _, _, _, g, _ = saturated(size)
        for pat, vs in _differential_patterns():
            a = ematch(g, pat, vs, engine="automaton")
            r = ematch(g, pat, vs, engine="recursive")
            assert a.complete and r.complete, (pat.pretty(), a.reason, r.reason)
            assert [m.key() for m in a.matches] == [m.key() for m in r.matches], \
                ("engines disagree on %s" % pat.pretty())


def test_ematch_automaton_agrees_on_binder_patterns():
    """The ``lam`` instruction: no demo pattern reaches it, so it is tested here.

    ``h (lam x. f a)`` and ``h (lam x. f x)`` sit in one graph with ``a = b``
    merged, so the pattern ``lam x. f ?u`` must bind ``?u`` to the class of
    ``a`` and materialise both members -- under both engines, identically.
    """
    h = T.Const("h", T.arrow(ZZ, Z))
    lam_open = T.Lam(Z, T.App(F, T.Var(0, Z)))
    lam_const = T.Lam(Z, T.App(F, A))
    g = EGraph()
    g.add(T.App(h, lam_open))
    g.add(T.App(h, lam_const))
    g.add(B)
    ctx = C.CheckContext()
    ctx.declare_axiom("ab", A, B)
    g.merge(A, B, C.Axiom("ab"), edge_id="E1")
    for pat in (T.Lam(Z, T.App(F, VU)), T.App(h, T.Lam(Z, T.App(F, VU)))):
        a = ematch(g, pat, {"?u"}, engine="automaton")
        r = ematch(g, pat, {"?u"}, engine="recursive")
        assert a.complete and r.complete
        assert [m.key() for m in a.matches] == [m.key() for m in r.matches], \
            pat.pretty()
        assert len(a.matches) == 2, [m.key() for m in a.matches]


def test_ematch_automaton_honours_the_same_budget_discipline():
    _, _, _, g, _ = saturated(8)
    pat = mul(mul(mul(VP, VP), VP), VP)
    tight = ematch(g, pat, {"?p"}, EMatchBudget(max_visits=20), engine="automaton")
    assert tight.exhausted and not tight.complete and tight.reason == "max_visits"
    loose = ematch(g, pat, {"?p"}, EMatchBudget(max_visits=5000000),
                   engine="automaton")
    assert loose.complete and len(loose.matches) >= len(tight.matches)


def test_ematch_program_is_compiled_once_and_reused():
    _, _, _, g, _ = saturated(6)
    pat = mul(mul(VA, VB), VC)
    p1 = compile_pattern(pat, frozenset({"?a", "?b", "?c"}))
    p2 = compile_pattern(pat, frozenset({"?a", "?b", "?c"}))
    assert p1 is p2, "the program cache must return the same object"
    # a different variable set is a different pattern, not a cache hit
    p3 = compile_pattern(pat, frozenset({"?a", "?b"}))
    assert p3 is not p1
    # the instruction sequence really is a sequence over registers
    kinds = [i[0] for i in p1.instrs]
    assert "app" in kinds and "const" in kinds and "vbind" in kinds, kinds
    assert p1.nregs >= len(p1.var_regs)
    # and a bare variable pattern is refused at compile time, as at match time
    try:
        compile_pattern(VA, frozenset({"?a"}))
        assert False, "a bare variable pattern must be refused"
    except ValueError:
        pass


def test_ematch_engine_name_is_checked():
    g = EGraph()
    g.add(mul(A, B))
    try:
        ematch(g, mul(VA, VB), {"?a", "?b"}, engine="clairvoyance")
        assert False, "an unknown engine must be refused"
    except ValueError:
        pass


# ==========================================================================
# 4. saturation: fixpoint or a named budget, never a silent subset
# ==========================================================================

def test_saturation_reaches_a_fixpoint_and_says_so():
    _, _, _, g, sat = saturated(4)
    assert sat.status == "fixpoint" and sat.is_fixpoint
    assert sat.rejected == 0
    assert not sat.ematch_partial


def test_saturation_reports_budget_exhaustion_not_a_fixpoint():
    """Three different bounds, three different statuses, no fixpoint claimed."""
    ctx, rules, task = book(8)
    seen = set()
    for b in (Budget(max_iterations=2),
              Budget(max_iterations=12, max_applications=20),
              Budget(max_iterations=12,
                     ematch=EMatchBudget(max_visits=200))):
        g = EGraph()
        g.add(task)
        s = saturate(g, rules, copyctx(ctx), b)
        assert not s.is_fixpoint, "a bounded run must not claim a fixpoint"
        assert s.status.startswith("budget:"), s.status
        seen.add(s.status)
    assert seen == {"budget:iterations", "budget:applications", "budget:ematch"}


def test_saturation_checks_every_equality_before_merging():
    ctx, rules, task = book(4)
    g = EGraph()
    g.add(task)
    s = saturate(g, rules, ctx, Budget(max_iterations=12), tag="q")
    mine = [r for r in g.records()
            if r.edge_id and r.edge_id.startswith("q")]
    assert len(mine) == s.applications
    for rec in mine:
        step = C.Step(rec.a, rec.b, "assumption", rec.witness, rec.edge_id)
        assert C.check_step(step, ctx), "every merged equality must recheck"


def test_forged_rule_contributes_nothing_to_the_egraph():
    """The planted control for saturation: a rule that matches everywhere and
    whose justification never checks must produce zero merges."""
    ctx, rules, task = book(4)
    # a false arithmetic fold: it cites the declared axiom mul(#3,#3) = #9 but
    # claims #10.  It matches the task, builds a term, and must die at the door.
    forged = Rule(name="fold.1.1", lhs=mul(lit(3), lit(3)), rhs=lit(10))
    g = EGraph()
    g.add(task)
    before = len(g.records())
    s = saturate(g, [forged], copyctx(ctx), Budget(max_iterations=3), tag="z")
    assert s.applications == 0 and s.unions == 0
    assert s.rejected > 0, "the rejections must be counted, not swallowed"
    assert len(g.records()) == before


def test_chords_are_kept_by_default_and_can_be_dropped():
    ctx, rules, task = book(4)
    g1 = EGraph()
    g1.add(task)
    kept = saturate(g1, rules, copyctx(ctx), Budget(max_iterations=12))
    g2 = EGraph()
    g2.add(task)
    dropped = saturate(g2, rules, copyctx(ctx),
                       Budget(max_iterations=12, keep_chords=False))
    assert kept.chords > 0
    assert dropped.chords == 0
    assert kept.unions == dropped.unions, "dropping chords must not lose equalities"
    assert len(g1.records()) > len(g2.records())


def test_saturation_is_deterministic():
    ctx, rules, task = book(6)
    outs = []
    for _ in range(2):
        g = EGraph()
        g.add(task)
        s = saturate(g, rules, copyctx(ctx), Budget(max_iterations=12))
        outs.append((s.render(), tuple(a.edge_id + a.rule for a in s.applied)))
    assert outs[0] == outs[1]


# ==========================================================================
# 5. extraction: cost vectors and the Pareto frontier
# ==========================================================================

def _routes(*costs):
    return tuple(Route(target="%032x" % i, path=(), cost=CostVector(*c),
                       variant=0)
                 for i, c in enumerate(costs))


def test_domination_is_exact_and_not_a_total_order():
    a = CostVector(1, 1, 1, 1)
    b = CostVector(2, 2, 2, 2)
    c = CostVector(1, 5, 1, 1)
    assert dominates(a, b) and not dominates(b, a)
    assert not dominates(a, a)
    assert dominates(a, c)
    assert not dominates(c, CostVector(5, 1, 1, 1))
    assert not dominates(CostVector(5, 1, 1, 1), c)     # incomparable


def test_dominated_route_is_refused_by_the_frontier():
    """The planted control for extraction: a route beaten on every component
    is not Pareto-optimal, and claiming it is must fail."""
    good, bad, other = _routes((1, 5, 1, 1), (6, 6, 6, 6), (5, 1, 1, 1))
    front = pareto((good, bad, other))
    assert bad not in front, "a dominated route must not be on the frontier"
    assert good in front and other in front
    assert not is_nondominated(bad, (good, bad, other))
    assert is_nondominated(good, (good, bad, other))


def test_pareto_keeps_routes_of_equal_cost():
    a, b = _routes((3, 3, 3, 3), (3, 3, 3, 3))
    front = pareto((a, b))
    assert len(front) == 2, "equal cost is not domination; both routes survive"


def test_scalarization_is_explicit_named_and_recorded():
    rs = _routes((1, 9, 9, 9), (9, 1, 9, 9))
    s1 = Scalarization("steps-only", (1, 0, 0, 0))
    s2 = Scalarization("size-only", (0, 1, 0, 0))
    c1, c2 = scalarize(rs, s1), scalarize(rs, s2)
    assert c1.route is not c2.route
    assert c1.scalarization.name == "steps-only"
    assert c1.value == 1 and c2.value == 1
    try:
        Scalarization("short", (1, 0))
        assert False, "a scalarization needs one weight per component"
    except ValueError:
        pass


def test_scalarize_never_returns_a_dominated_route():
    rs = _routes((1, 1, 1, 1), (2, 2, 2, 2), (0, 9, 9, 9))
    front = pareto(rs)
    for w in ((1, 1, 1, 1), (3, 1, 0, 0), (0, 0, 1, 2), (1, 0, 0, 0)):
        ch = scalarize(rs, Scalarization("w", w))
        assert ch.route in front


def test_measure_route_refuses_an_unverifiable_path():
    ctx, _, _ = book()
    bogus = (C.Step(A.addr, B.addr, "assumption", C.Axiom("undeclared")),)
    assert measure_route(ctx, A, B, bogus) is None


def test_extraction_returns_only_verified_routes():
    ctx, rules, task, g, sat = saturated(4)
    ex = extract_routes(g, ctx, task)
    assert ex.routes and ex.rejected == 0
    for r in ex.routes:
        assert C.check_path(r.path, task.addr, r.target, ctx)
        assert g.equal(task, r.target)
    assert set(r.target for r in ex.frontier) <= set(r.target for r in ex.routes)


def test_extraction_refuses_to_truncate_a_class():
    ctx, rules, task, g, sat = saturated(4)
    n = len(g.class_of(task))
    try:
        extract_routes(g, ctx, task, max_targets=n - 1)
        assert False, "quietly extracting from part of a class is forbidden"
    except ValueError:
        pass
    assert extract_routes(g, ctx, task, max_targets=n).routes


def test_cost_components_are_exact_integers():
    ctx, rules, task, g, sat = saturated(4)
    ex = extract_routes(g, ctx, task)
    for r in ex.routes:
        for v in r.cost.as_tuple():
            assert isinstance(v, int) and not isinstance(v, bool)
    assert arith_width(lit(81)) == 7 and arith_width(sqr(lit(3))) == 2
    assert arith_width(A) == 0
    assert literal_value(lit(81)) == 81 and literal_value(A) is None
    assert term_size(mul(A, B)) == 5      # a, b, mul, (mul a), (mul a b)


def test_geodesic_is_never_longer_than_the_canonical_route():
    ctx, rules, task, g, sat = saturated(6)
    geo = extract_routes(g, ctx, task, mode="geodesic")
    can = extract_routes(g, ctx, task, mode="canonical")
    gs = {r.target: r.cost.steps for r in geo.routes}
    cs = {r.target: r.cost.steps for r in can.routes}
    assert set(gs) == set(cs)
    assert all(gs[k] <= cs[k] for k in gs)
    assert any(gs[k] < cs[k] for k in gs), \
        "on a graph with chords the geodesic must beat the forest route somewhere"


def test_route_finder_finds_the_short_way_round_a_chord():
    ctx = C.CheckContext()
    for n, (x, y) in (("ab", (A, B)), ("bd", (B, D)), ("ad", (A, D))):
        ctx.declare_axiom(n, x, y)
    g = EGraph()
    for t in (A, B, D):
        g.add(t)
    g.merge(A, B, C.Axiom("ab"), edge_id="E1")
    g.merge(B, D, C.Axiom("bd"), edge_id="E2")
    g.merge(A, D, C.Axiom("ad"), edge_id="E3")      # a chord: a shorter way
    canonical = g.explain(A, D)
    geodesic = RouteFinder(g).route(A.addr, D.addr)
    assert count_steps(canonical) == 2
    assert count_steps(geodesic) == 1
    assert C.check_path(geodesic, A.addr, D.addr, ctx)


def test_frontier_diff_names_what_moved():
    a, b, c = _routes((5, 5, 5, 5), (9, 9, 9, 9), (1, 1, 1, 1))
    same_target_cheaper = Route(target=a.target, path=(),
                                cost=CostVector(3, 5, 5, 5))
    d = frontier_diff((a, b), (same_target_cheaper, c))
    assert [r.target for r in d.vanished] == [b.target]
    assert [r.target for r in d.appeared] == [c.target]
    assert len(d.shortened) == 1
    assert d.moved


def test_frontier_diff_can_report_a_shape_change_with_no_shortening():
    a, = _routes((5, 5, 5, 5))
    b = Route(target="%032x" % 77, path=(), cost=CostVector(5, 4, 6, 5))
    d = frontier_diff((a,), (a, b))
    assert d.appeared and not d.shortened
    assert d.shape_changed_without_shortening


# --------------------------------------------------------------------------
# 5b. Pareto extraction over the class DAG -- the materialisation cliff
# --------------------------------------------------------------------------

def test_class_dag_extraction_finds_a_route_to_a_term_nobody_built():
    """The capability: the frontier stops being a subset of the stored terms.

    ``max_exhaustive_vars = 1`` means a multi-variable rule builds its right
    side at one representative per class, so most combinations of realisations
    are never materialised.  Extraction over stored terms cannot see them at
    all; extraction over the class DAG assembles them.
    """
    ctx, rules, task, g, sat = saturated(8)
    finder = RouteFinder(g)
    old = extract_routes(g, ctx, task, mode="geodesic", finder=finder)
    new = extract_class_frontier(g, ctx, task, finder=finder)
    built = set(g.terms())
    unbuilt = [r for r in new.frontier if r.target not in built]
    assert unbuilt, "the class-DAG frontier must contain a term the e-graph never built"
    # and those are genuinely new points, not restatements of stored ones
    old_costs = {r.cost.as_tuple() for r in old.frontier}
    assert any(r.cost.as_tuple() not in old_costs for r in unbuilt)
    # every one of them is a *checked* route to a term provably equal to the task
    for r in unbuilt:
        assert C.check_path(r.path, task.addr, r.target, ctx)
        assert T.lookup(r.target) is not None
    assert new.rejected == 0


def test_class_dag_frontier_is_at_least_as_good_as_the_stored_term_frontier():
    """The cliff, quantified: no stored-term frontier point survives unbeaten."""
    ctx, rules, task, g, sat = saturated(8)
    finder = RouteFinder(g)
    old = extract_routes(g, ctx, task, mode="geodesic", finder=finder)
    new = extract_class_frontier(g, ctx, task, finder=finder)
    assert len(new.frontier) > len(old.frontier)
    for r in old.frontier:
        assert any(o.cost.as_tuple() == r.cost.as_tuple()
                   or dominates(o.cost, r.cost) for o in new.frontier), \
            "a stored-term frontier point must be matched or beaten: %s" % r.render()
    # and the class-DAG route to a stored target is never worse than the geodesic
    best_old = {}
    for r in old.routes:
        best_old[r.target] = min(best_old.get(r.target, r.cost.steps), r.cost.steps)
    for r in new.routes:
        if r.target in best_old:
            assert r.cost.steps <= best_old[r.target], r.render()


def test_class_fixpoint_converges_and_says_so():
    ctx, rules, task, g, sat = saturated(6)
    sol = ClassExtractor(g, finder=RouteFinder(g)).solve()
    assert sol.complete and not sol.reason, sol.render()
    assert sol.rounds >= 1 and sol.assembled > 0
    root = g.find(task.addr)
    best = sol.best_per_component(root)
    assert set(best) == {"steps", "size", "width"}
    # the per-component champions really are champions inside the class
    for name, opt in best.items():
        i = ("steps", "size", "width").index(name)
        assert all(opt.triple()[i] <= o.triple()[i] for o in sol.options[root])


def test_class_fixpoint_reports_its_bound_instead_of_truncating_silently():
    """CONTROL: a bounded fixpoint must not present itself as converged."""
    ctx, rules, task, g, sat = saturated(6)
    finder = RouteFinder(g)
    tight = ClassExtractor(g, finder=finder, bounds={"max_rounds": 1}).solve()
    assert not tight.complete and "max_rounds" in tight.reason, tight.render()
    capped = ClassExtractor(g, finder=finder, bounds={"max_options": 1}).solve()
    assert not capped.complete and "max_options" in capped.reason, capped.render()
    small = ClassExtractor(g, finder=finder, bounds={"max_terms": 5}).solve()
    assert not small.complete and "max_terms" in small.reason, small.render()
    # and the bound is propagated into the extraction result, not swallowed
    ex = extract_class_frontier(g, ctx, task, finder=finder,
                                bounds={"max_rounds": 1})
    assert not ex.complete and ex.partial_targets and ex.reasons
    try:
        ClassExtractor(g, bounds={"no_such_bound": 3})
        assert False, "an unknown bound must be refused, not ignored"
    except ValueError:
        pass


def test_class_dag_extraction_never_returns_an_unchecked_route():
    """CONTROL: assembled terms are not trusted -- every route goes to the checker."""
    ctx, rules, task, g, sat = saturated(6)
    ex = extract_class_frontier(g, ctx, task)
    assert ex.routes and ex.rejected == 0
    built = set(g.terms())
    for r in ex.routes:
        # an assembled target is deliberately NOT a node of the e-graph, so the
        # e-graph cannot be asked to vouch for it.  The checker can, and does.
        assert C.check_path(r.path, task.addr, r.target, ctx)
        if r.target in built:
            assert g.equal(task, r.target)
    # a route measured against a *different* book must be refused, which is the
    # planted falsehood: "it was assembled by our own fixpoint, so it is fine"
    empty = C.CheckContext()
    assembled = [r for r in ex.routes if r.cost.steps > 0]
    assert assembled
    assert all(not C.check_path(r.path, task.addr, r.target, empty)
               for r in assembled[:3])


def test_class_dag_extraction_is_deterministic():
    ctx, rules, task, g, sat = saturated(6)
    a = extract_class_frontier(g, ctx, task)
    b = extract_class_frontier(g, ctx, task)
    assert [(r.target, r.cost.as_tuple()) for r in a.frontier] == \
           [(r.target, r.cost.as_tuple()) for r in b.frontier]


def test_class_dag_extraction_does_not_mutate_the_egraph():
    ctx, rules, task, g, sat = saturated(6)
    before = (len(g.terms()), len(g.records()), len(g.classes()))
    extract_class_frontier(g, ctx, task)
    after = (len(g.terms()), len(g.records()), len(g.classes()))
    assert before == after, (before, after)


# ==========================================================================
# 6. the whole loop, and the demo
# ==========================================================================

def test_theorem_moves_the_frontier_and_the_null_control_does_not():
    ctx, rules, task = book(8)
    lhs, rhs, path = _pow2_theorem(ctx, rules)

    g0 = EGraph()
    g0.add(task)
    saturate(g0, rules, ctx, Budget(max_iterations=12))
    f0 = RouteFinder(g0)
    ex0 = extract_routes(g0, ctx, task, finder=f0)

    after = copyctx(ctx)
    pow4 = install_theorem(after, "pow4", lhs, rhs, path, ("?p",))
    g1 = EGraph()
    g1.add(task)
    saturate(g1, rules + [pow4], after, Budget(max_iterations=12))
    f1 = RouteFinder(g1)
    ex1 = extract_routes(g1, after, task, finder=f1)

    tower = sqr(sqr(sqr(lit(3))))
    b = count_steps(f0.route(task.addr, tower.addr))
    a = count_steps(f1.route(task.addr, tower.addr))
    assert a < b, "the theorem must shorten the geodesic (%d -> %d)" % (b, a)
    assert frontier_diff(ex0.frontier, ex1.frontier).moved

    # null control: a real theorem about an operator the task never mentions
    nctx = copyctx(ctx)
    NP = T.Const("plus", ZZZ)
    ND = T.Const("dbl", ZZ)
    VQ = T.Const("?q", Z)
    VX, VY, VZ2 = (T.Const(s, Z) for s in ("?x", "?y", "?z2"))

    def pl(x, y):
        return T.App(T.App(NP, x), y)

    nctx.declare_axiom("assoc_plus", pl(pl(VX, VY), VZ2), pl(VX, pl(VY, VZ2)))
    nctx.declare_axiom("dbl_def", T.App(ND, VU), pl(VU, VU))
    nrules = [rule_from_axiom(nctx, "assoc_plus", ("?x", "?y", "?z2")),
              rule_from_axiom(nctx, "dbl_def", ("?u",))]
    nl = pl(pl(pl(VQ, VQ), VQ), VQ)
    nr = T.App(ND, T.App(ND, VQ))
    gp = EGraph()
    gp.add(nl)
    gp.add(nr)
    saturate(gp, nrules, nctx, Budget(max_iterations=8), tag="np")
    assert gp.equal(nl, nr)
    npath = RouteFinder(gp).route(nl.addr, nr.addr)
    null = install_theorem(nctx, "pow4_plus", nl, nr, npath, ("?q",))

    g2 = EGraph()
    g2.add(task)
    s2 = saturate(g2, rules + [null], nctx, Budget(max_iterations=12))
    ex2 = extract_routes(g2, nctx, task)
    assert not [x for x in s2.applied if x.rule == "pow4_plus"]
    assert ([(r.target, r.cost.as_tuple()) for r in ex2.frontier] ==
            [(r.target, r.cost.as_tuple()) for r in ex0.frontier]), \
        "an irrelevant theorem must leave the frontier bit-identical"


def test_demo_is_deterministic_and_passes():
    import contextlib
    import io
    from runtime.demo.geodesic_demo import main
    outs = []
    for _ in range(2):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = main()
        assert rc == 0, "the demo reported failure"
        outs.append(buf.getvalue())
    assert outs[0] == outs[1], "the demo is not deterministic"


def test_no_float_anywhere_in_the_package():
    import runtime.execute as X
    root = os.path.dirname(os.path.abspath(X.__file__))
    for name in sorted(os.listdir(root)):
        if not name.endswith(".py"):
            continue
        with open(os.path.join(root, name)) as fh:
            for i, line in enumerate(fh, 1):
                code = line.split("#")[0]
                for bad in ("float(", "math.", "/ 2", "1.0", "0.5"):
                    assert bad not in code, "%s:%d uses %r" % (name, i, bad)


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
