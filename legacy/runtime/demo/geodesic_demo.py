#!/usr/bin/env python3
"""The measured demonstration of L3 execution -- the geodesic engine.

Run:  python3 runtime/demo/geodesic_demo.py        (exit 0 iff every claim holds)

It answers one question, in the form CRYSTAL.md Sec.0 demands:

    does a *proved theorem* entering the runtime change the geometry of routes
    -- shortening geodesics and moving the Pareto frontier of nondominated
    routes -- while an equally-well-proved but irrelevant theorem changes
    nothing, and while every route's answer stays identical and kernel-checked?

Everything printed is an exact integer from a counter.  No floats, no
randomness, no network, no model.  Two runs are byte-identical, including
under a different PYTHONHASHSEED.

THE TASK
    Evaluate  3^8  presented as a left-nested product of eight 3s.

THE AXIOM BOOK
    associativity of mul, the definition of sqr, and exact integer folds for
    products and squares of powers of three.  Each fold is computed in Python's
    exact integer arithmetic at declaration time, so the axiom book contains no
    arithmetic claim that is not exactly true by construction.

THE THEOREM THAT ENTERS
    pow4 :  ((p*p)*p)*p  =  sqr(sqr p)
    It is *proved by this runtime* from associativity and the definition of
    sqr, over an opaque constant, in a separate e-graph.  The proof is checked
    by kernel/check.py, wrapped in an L1 `Eq` edge, the edge is checked again,
    and only then does the edge become a rewrite rule.

THE NULL CONTROL
    pow4_plus :  ((q+q)+q)+q  =  dbl(dbl q)
    The same theorem about a different operator, proved by the same machinery
    and checked by the same checker.  The task contains no `plus` and no `dbl`,
    so it must leave the frontier bit-identical.
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
from runtime.execute import (Budget, ClassExtractor, EMatchBudget,     # noqa: E402
                             RouteFinder,
                             Scalarization, apply_rule, count_steps,
                             ematch, expand_path, extract_class_frontier,
                             extract_routes, frontier_diff, install_theorem,
                             match, positions, rule_from_axiom,
                             rule_from_edge, saturate, subterm_at)

BAR = "=" * 78


def hdr(s: str) -> None:
    print("\n" + BAR + "\n" + s + "\n" + BAR)


# --------------------------------------------------------------------------
# the signature
# --------------------------------------------------------------------------

Z = T.base_sort("Z")
ZZ = T.arrow(Z, Z)
ZZZ = T.arrow(Z, ZZ)

MUL = T.Const("mul", ZZZ)
SQR = T.Const("sqr", ZZ)
PLUS = T.Const("plus", ZZZ)
DBL = T.Const("dbl", ZZ)

BASE = 3
EXP = 8


def mul(a: T.Term, b: T.Term) -> T.Term:
    return T.App(T.App(MUL, a), b)


def sqr(a: T.Term) -> T.Term:
    return T.App(SQR, a)


def plus(a: T.Term, b: T.Term) -> T.Term:
    return T.App(T.App(PLUS, a), b)


def dbl(a: T.Term) -> T.Term:
    return T.App(DBL, a)


def lit(n: int) -> T.Term:
    return T.Const("#%d" % n, Z)


# schematic constants.  Distinct namespaces on purpose: install_theorem refuses
# a theorem whose schematic symbols occur in any axiom, and that refusal is the
# side condition that makes the schematic reading sound.
VA, VB, VC = (T.Const(s, Z) for s in ("?a", "?b", "?c"))
VU = T.Const("?u", Z)
VX, VY, VW = (T.Const(s, Z) for s in ("?x", "?y", "?w"))
VV = T.Const("?v", Z)
VP = T.Const("?p", Z)          # the theorem's parameter
VQ = T.Const("?q", Z)          # the null theorem's parameter


def left_nested(n: int) -> T.Term:
    t = lit(BASE)
    for _ in range(n - 1):
        t = mul(t, lit(BASE))
    return t


# --------------------------------------------------------------------------
# an independent semantics, structurally unrelated to the rewriter
# --------------------------------------------------------------------------

def value_of(t: T.Term):
    """Exact integer denotation, computed by a separate recursive evaluator.

    Nothing here consults the e-graph, the checker or the rule set.  It is the
    demo's independent answer to "did every route compute the same thing".
    """
    if t.head == T.CONST:
        s = t.symbol
        if s.startswith("#") and s[1:].isdigit():
            return int(s[1:])
        return None
    if t.head != T.APP:
        return None
    fn, arg = t.children
    if fn is SQR:
        v = value_of(arg)
        return None if v is None else v * v
    if fn is DBL:
        v = value_of(arg)
        return None if v is None else 2 * v
    if fn.head == T.APP:
        op, left = fn.children
        a, b = value_of(left), value_of(arg)
        if a is None or b is None:
            return None
        if op is MUL:
            return a * b
        if op is PLUS:
            return a + b
    return None


# --------------------------------------------------------------------------
# the axiom book
# --------------------------------------------------------------------------

def base_context():
    """The primitive axiom book, and the names of the rules built from it."""
    ctx = C.CheckContext()
    ctx.declare_axiom("assoc", mul(mul(VA, VB), VC), mul(VA, mul(VB, VC)))
    ctx.declare_axiom("sqr_def", sqr(VU), mul(VU, VU))
    # the null control's own primitives, present in both books so that the only
    # difference between the runs is which *theorem* was installed
    ctx.declare_axiom("assoc_plus", plus(plus(VX, VY), VW), plus(VX, plus(VY, VW)))
    ctx.declare_axiom("dbl_def", dbl(VV), plus(VV, VV))
    folds = []
    for i in range(1, EXP):
        for j in range(1, EXP):
            if i + j <= EXP:
                a, b = BASE ** i, BASE ** j
                name = "fold.%d.%d" % (i, j)
                ctx.declare_axiom(name, mul(lit(a), lit(b)), lit(a * b))
                folds.append(name)
        if 2 * i <= EXP:
            a = BASE ** i
            name = "sqfold.%d" % i
            ctx.declare_axiom(name, sqr(lit(a)), lit(a * a))
            folds.append(name)
    return ctx, folds


def base_rules(ctx, folds):
    out = [rule_from_axiom(ctx, "assoc", ("?a", "?b", "?c")),
           rule_from_axiom(ctx, "sqr_def", ("?u",))]
    out.extend(rule_from_axiom(ctx, n) for n in folds)
    return out


def copy_context(ctx):
    return C.CheckContext(axioms=dict(ctx.axioms),
                          certificates=dict(ctx.certificates), fuel=ctx.fuel)


SAT = Budget(max_iterations=12, ematch=EMatchBudget(max_visits=5000000))


def run(task, rules, ctx, tag):
    g = EGraph()
    g.add(task)
    sat = saturate(g, rules, ctx, SAT, tag=tag)
    finder = RouteFinder(g)
    ex = extract_routes(g, ctx, task, mode="geodesic", finder=finder)
    return g, sat, ex, finder


def show_frontier(ex, indent="    "):
    print("%s%-52s %5s %4s %5s %6s" % (indent, "extracted term", "steps",
                                       "size", "width", "verify"))
    print(indent + "-" * 76)
    for r in ex.frontier:
        c = r.cost
        print("%s%-52s %5d %4d %5d %6d"
              % (indent, r.pretty()[:52], c.steps, c.size, c.width, c.verify))


def prove(lhs, rhs, rules, ctx, tag):
    """Prove ``lhs = rhs`` by saturating a scratch e-graph, and check the proof."""
    g = EGraph()
    g.add(lhs)
    g.add(rhs)
    sat = saturate(g, rules, ctx, Budget(max_iterations=8), tag=tag)
    if not g.equal(lhs, rhs):
        return None, sat, None
    path = RouteFinder(g).route(lhs.addr, rhs.addr)
    return path, sat, g


def main() -> int:
    failures = []

    def want(cond, msg):
        if not cond:
            failures.append(msg)
        return bool(cond)

    task = left_nested(EXP)
    ctx_before, folds = base_context()
    rules_before = base_rules(ctx_before, folds)

    # ---------------------------------------------------------------- 1
    hdr("1. THE TASK, AND THE BOOK IT IS ROUTED IN")
    print("  task   : %s" % task.pretty())
    print("  address: %s   (size %d nodes, denotation %d)"
          % (task.addr[:16], len(T.subterms(task)), value_of(task)))
    print("  book   : %d axioms -- assoc, sqr_def, %d exact integer folds,"
          % (len(ctx_before.axioms), len(folds)))
    print("           plus the null control's own two primitives (assoc_plus,")
    print("           dbl_def), so the only difference between the runs below")
    print("           is which THEOREM was installed.")
    print("  every fold was computed in exact Python integer arithmetic when it")
    print("  was declared, so no arithmetic claim in the book is unverified.")
    want(value_of(task) == BASE ** EXP, "task denotation must be 3^8")

    # ---------------------------------------------------------------- 2
    hdr("2. SATURATE, BEFORE THE THEOREM  (fixpoint or budget -- it says which)")
    g0, sat0, ex0, finder0 = run(task, rules_before, ctx_before, "b")
    print("  %s" % sat0.render())
    print("  budget declared: %s" % SAT.render())
    print("  status is '%s'; is_fixpoint = %s" % (sat0.status, sat0.is_fixpoint))
    print("  every one of the %d applications was handed to kernel/check.py as an"
          % sat0.applications)
    print("  Instantiate step BEFORE the merge; %d were rejected." % sat0.rejected)
    want(sat0.is_fixpoint, "the before-run must reach a genuine fixpoint")
    want(sat0.rejected == 0, "no primitive rule should be rejected")

    # ---------------------------------------------------------------- 3
    hdr("3. E-MATCHING MODULO EQUALITY  (where the e-graph earns its keep)")
    pat = mul(mul(mul(VP, VP), VP), VP)
    print("  pattern : %s" % pat.pretty())

    fresh = EGraph()
    fresh.add(task)
    res_fresh = ematch(fresh, pat, {"?p"})
    print("\n  (a) against the task alone, before any equality is proved:")
    print("      %s" % res_fresh.render())

    print("  (b) syntactically, at every position of the task term:")
    syn_task = [p for p in positions(task)
                if match(pat, subterm_at(task, p), {"?p"}) is not None]
    print("      %d position(s); the whole task itself is a match: %s"
          % (len(syn_task), match(pat, task, {"?p"}) is not None))

    res = ematch(g0, pat, {"?p"})
    print("  (c) against the saturated e-graph, modulo the proved equalities:")
    print("      %s" % res.render())
    print("      bound: %s" % res.budget.render())
    stored = 0
    unstored = []
    known = set(g0.terms())
    for mm in res.matches:
        inst = T.subst_consts(pat, dict(mm.subst))
        if inst.addr in known:
            stored += 1
        else:
            unstored.append(mm)
    print("      of those, %d have a stored realisation and %d do NOT --"
          % (stored, len(unstored)))
    print("      they exist only modulo the equalities already merged.")
    if unstored:
        print("      e.g. ?p = %s, whose instance %s"
              % (dict(unstored[0].subst)["?p"].pretty(),
                 T.subst_consts(pat, dict(unstored[0].subst)).pretty()[:44]))
        print("           is not a node of this e-graph at all.")
    hits = [m for m in res.matches if g0.find(m.root) == g0.find(task)]
    print("      matches inside the TASK's own class : %d" % len(hits))
    print("\n  (a) is the control: with no equalities proved the pattern finds")
    print("  exactly the one thing that is syntactically there.  (c) is the")
    print("  capability: the same pattern finds the fourth power of a *square*,")
    print("  which no stored term exhibits.  That is what an e-graph buys, and")
    print("  it is the match that produces sqr(sqr(sqr #3)) in section 6.")
    want(len(res_fresh.matches) <= 1,
         "before saturation the pattern must match only what is syntactically there")
    want(len(unstored) > 0,
         "e-matching must find instances with no stored realisation")
    want(len(hits) > 0, "the pattern must e-match the task class")
    want(res.complete, "this e-match must be complete, not budget-bounded")
    want(match(pat, task, {"?p"}) is None,
         "the task must not be an instance of the theorem's left side")

    # ---------------------------------------------------------------- 4
    hdr("4. THE PARETO FRONTIER BEFORE  (nondominated routes, cost VECTOR)")
    print("  %s" % ex0.render())
    print("  routes are geodesics: shortest checkable route through the retained")
    print("  justifications (Dijkstra), not whatever order the merges happened in.\n")
    show_frontier(ex0)
    print("\n  %d of %d routes are nondominated.  There is no best one: the"
          % (len(ex0.frontier), len(ex0.routes)))
    print("  16-node presentation costs 0 steps, the literal #6561 costs 1 node")
    print("  and 13 bits of exact arithmetic, and sqr(sqr(sqr #3)) costs neither.")

    # ---------------------------------------------------------------- 5
    hdr("5. A THEOREM ENTERS  (proved here, checked, then made into an edge)")
    L4 = mul(mul(mul(VP, VP), VP), VP)
    R4 = sqr(sqr(VP))
    prover_rules = [r for r in rules_before if r.name in ("assoc", "sqr_def")]
    proof, psat, _ = prove(L4, R4, prover_rules, ctx_before, "pf")
    print("  statement : %s = %s" % (L4.pretty(), R4.pretty()))
    print("  proved over an OPAQUE constant ?p, from assoc and sqr_def only:")
    print("    %s" % psat.render())
    want(proof is not None, "the theorem must be provable from the primitives")
    print("  proof     : %d kernel steps" % count_steps(proof or ()))
    ok = C.check_path(proof or (), L4.addr, R4.addr, ctx_before)
    print("  checked   : %s (by kernel/check.py, which never saw the e-graph)" % ok)
    want(ok, "the theorem's proof must check")

    edge = E.Edge(kind="Eq", src=L4.addr, dst=R4.addr, witness=proof,
                  label="pow4", provenance=("saturation",))
    probe = copy_context(ctx_before)
    print("  as an L1 Eq edge : check_edge -> %s" % C.check_edge(edge, probe))
    conj = E.Edge(kind="Conjecture", src=L4.addr, dst=R4.addr, label="pow4?")
    cprobe = copy_context(ctx_before)
    print("  the same statement as a Conjecture edge : check_edge -> %s"
          % C.check_edge(conj, cprobe))
    want(not C.check_edge(conj, copy_context(ctx_before)),
         "a Conjecture edge must never be accepted")
    try:
        rule_from_edge(conj, copy_context(ctx_before), "bad", ("?p",))
        want(False, "a Conjecture edge must not become a rewrite rule")
    except Exception as exc:                                   # noqa: BLE001
        print("  the same statement as a rewrite rule    : refused (%s)"
              % type(exc).__name__)

    ctx_after = copy_context(ctx_before)
    pow4 = rule_from_edge(edge, ctx_after, "pow4", ("?p",))
    print("\n  installed : %s" % pow4.render())
    print("  origin    : %s, carrying its %d-step primitive proof for expansion"
          % (pow4.origin, count_steps(pow4.expansion)))
    print("  usable in : %s  (an Eq edge is symmetric, so both)"
          % (list(pow4.directions()),))

    # ---------------------------------------------------------------- 6
    hdr("6. SATURATE AND EXTRACT, AFTER")
    rules_after = base_rules(ctx_after, folds) + [pow4]
    g1, sat1, ex1, finder1 = run(task, rules_after, ctx_after, "a")
    print("  %s" % sat1.render())
    want(sat1.is_fixpoint, "the after-run must reach a genuine fixpoint")
    print("  %s\n" % ex1.render())
    show_frontier(ex1)

    # ---------------------------------------------------------------- 7
    hdr("7. CURVATURE: WHAT THE THEOREM DID TO THE GEOMETRY")
    diff = frontier_diff(ex0.frontier, ex1.frontier)
    print("  %s\n" % diff.render())
    for r in diff.appeared:
        print("    APPEARED   %-44s %s" % (r.pretty()[:44], r.cost.render()))
    for r in diff.vanished:
        print("    VANISHED   %-44s %s" % (r.pretty()[:44], r.cost.render()))
    for b, a in diff.shortened:
        print("    SHORTENED  %-44s %d -> %d steps"
              % (a.pretty()[:44], b.cost.steps, a.cost.steps))
    for r in diff.unchanged:
        print("    unchanged  %-44s %s" % (r.pretty()[:44], r.cost.render()))

    named = [sqr(sqr(sqr(lit(BASE)))), lit(BASE ** EXP), sqr(lit(BASE ** 4))]
    print("\n  geodesic length to three named destinations:")
    print("    %-30s %8s %8s %8s" % ("destination", "before", "after", "change"))
    print("    " + "-" * 58)
    lengths = []
    for t in named:
        b = finder0.route(task.addr, t.addr)
        a = finder1.route(task.addr, t.addr)
        nb = count_steps(b) if b is not None else -1
        na = count_steps(a) if a is not None else -1
        lengths.append((t, nb, na))
        print("    %-30s %8d %8d %+8d" % (t.pretty(), nb, na, na - nb))
    tower_before, tower_after = lengths[0][1], lengths[0][2]
    want(tower_after < tower_before,
         "the theorem must shorten the geodesic to sqr(sqr(sqr #3))")
    want(all(a <= b for _, b, a in lengths),
         "no named geodesic may get longer")
    print("\n  the theorem was proved about a FOURTH power and is used here on an")
    print("  EIGHTH power.  The task is NOT an instance of it (section 3(b): the")
    print("  theorem's left side does not match the task term), and the uses that")
    print("  do the work bind ?p to the class of 3^2 -- whose instantiated left")
    print("  side is stored nowhere (section 3(c): %d such instances)."
          % len(unstored))
    if diff.shape_changed_without_shortening:
        print("\n  NOTE: the frontier changed SHAPE without any geodesic getting")
        print("  shorter -- routes appeared or vanished while the best route")
        print("  stayed put.  That is the more interesting case and it happened.")

    # ---------------------------------------------------------------- 8
    hdr("8. NULL CONTROL  (an equally valid theorem that must change nothing)")
    L4p = plus(plus(plus(VQ, VQ), VQ), VQ)
    R4p = dbl(dbl(VQ))
    null_prover = [rule_from_axiom(ctx_before, "assoc_plus", ("?x", "?y", "?w")),
                   rule_from_axiom(ctx_before, "dbl_def", ("?v",))]
    nproof, nsat, _ = prove(L4p, R4p, null_prover, ctx_before, "np")
    print("  statement : %s = %s" % (L4p.pretty(), R4p.pretty()))
    print("  proved    : %s" % nsat.render())
    want(nproof is not None, "the null theorem must be provable")
    print("  proof     : %d kernel steps, checked -> %s"
          % (count_steps(nproof or ()),
             C.check_path(nproof or (), L4p.addr, R4p.addr, ctx_before)))
    ctx_null = copy_context(ctx_before)
    pow4p = install_theorem(ctx_null, "pow4_plus", L4p, R4p, nproof, ("?q",))
    rules_null = base_rules(ctx_null, folds) + [pow4p]
    g2, sat2, ex2, finder2 = run(task, rules_null, ctx_null, "n")
    print("\n  %s" % sat2.render())
    print("  %s" % ex2.render())
    same_targets = ([r.target for r in ex2.frontier] ==
                    [r.target for r in ex0.frontier])
    same_costs = ([r.cost.as_tuple() for r in ex2.frontier] ==
                  [r.cost.as_tuple() for r in ex0.frontier])
    print("\n  frontier identical to the before-run : targets %s, costs %s"
          % ("yes" if same_targets else "NO", "yes" if same_costs else "NO"))
    print("  applications of the null theorem     : %d"
          % sum(1 for a in sat2.applied if a.rule == "pow4_plus"))
    print("  e-match work it cost anyway          : %d visits (%+d vs before)"
          % (sat2.ematch_visits, sat2.ematch_visits - sat0.ematch_visits))
    print("\n  A true, checked, irrelevant theorem costs search work and buys")
    print("  nothing.  That gap between section 7 and section 8 is the claim.")
    want(same_targets and same_costs,
         "the null theorem must leave the frontier bit-identical")

    # ---------------------------------------------------------------- 9
    hdr("9. CORRECTNESS CONTROLS")
    vals = sorted({value_of(T.lookup(r.target)) for r in ex1.routes})
    print("  every extracted route's destination, evaluated by an independent")
    print("  exact-integer evaluator that never touches the e-graph:")
    print("    %d routes, %d distinct value(s): %s"
          % (len(ex1.routes), len(vals), vals))
    want(vals == [BASE ** EXP], "every route must compute exactly 3^8")

    allsame = all(g1.equal(task, r.target) for r in ex1.routes)
    print("  every destination in the task's e-class : %s" % allsame)
    want(allsame, "every extracted target must be provably equal to the task")

    print("  every route re-verified by kernel/check.py : %d checked, %d rejected"
          % (len(ex1.routes), ex1.rejected))
    want(ex1.rejected == 0, "no extracted route may fail verification")

    print("\n  theorem expansion -- the trusted base did NOT grow:")
    theorem_free = copy_context(ctx_before)          # pow4 is NOT declared here
    print("    'pow4' declared in the checking context : %s"
          % ("pow4" in theorem_free.axioms))
    expanded_ok = 0
    growth = []
    for r in ex1.frontier:
        prim = expand_path(r.path, rules_after)
        good = C.check_path(prim, task.addr, r.target, theorem_free)
        expanded_ok += 1 if good else 0
        growth.append((count_steps(r.path), count_steps(prim)))
    print("    frontier routes expanded to primitives and re-checked in a")
    print("    context where no theorem exists : %d/%d accepted"
          % (expanded_ok, len(ex1.frontier)))
    comp = [(a, b) for a, b in growth if b > a]
    if comp:
        print("    compression: %s"
              % ", ".join("%d<-%d" % (a, b) for a, b in comp))
    want(expanded_ok == len(ex1.frontier),
         "every route must expand to primitives and re-check without the theorem")

    # ---------------------------------------------------------------- 10
    hdr("10. WHY THE FRONTIER IS NOT COLLAPSED  (one frontier, four verdicts)")
    scals = [Scalarization("cheap-to-prove", (1, 0, 0, 0)),
             Scalarization("compact-term", (0, 4, 1, 0)),
             Scalarization("narrow-arithmetic", (0, 1, 4, 0)),
             Scalarization("balanced", (1, 2, 1, 0))]
    winners = []
    from runtime.execute import scalarize
    for s in scals:
        ch = scalarize(ex1.frontier, s)
        winners.append(ch.route.target)
        print("  %-19s value %-5d -> %s"
              % (s.name, ch.value, ch.route.pretty()[:44]))
        print("  %-19s %s   [%s]" % ("", ch.route.cost.render(), s.render()))
    print("\n  %d distinct winners over %d scalarizations of the SAME frontier."
          % (len(set(winners)), len(scals)))
    print("  A runtime that had collapsed to one scalar fitness would have")
    print("  discarded the other answers before the caller ever said which")
    print("  question they were asking.  Every collapse here is named, and the")
    print("  name is carried in the result.")
    want(len(set(winners)) >= 3,
         "different scalarizations must pick genuinely different routes")

    # ---------------------------------------------------------------- 11
    hdr("11. BUDGET DISCIPLINE  (a saturation that cannot finish must say so)")
    print("  the same task and the same rules as section 2, under three")
    print("  deliberately insufficient budgets.  None of them may report a")
    print("  fixpoint, and each must name the bound it hit.\n")
    tight = [("iterations", Budget(max_iterations=2)),
             ("applications", Budget(max_iterations=12, max_applications=25)),
             ("e-matching", Budget(max_iterations=12,
                                   ematch=EMatchBudget(max_visits=500)))]
    starved = []
    for label, b in tight:
        gt = EGraph()
        gt.add(task)
        st = saturate(gt, rules_before, copy_context(ctx_before), b,
                      tag="t" + label[:1])
        starved.append(st)
        print("  starve %-13s -> status=%-22s is_fixpoint=%s"
              % (label, st.status, st.is_fixpoint))
    print("\n  for comparison, section 2's full budget -> status=%s" % sat0.status)
    print("  A partial saturation that returned quietly would be indistinguishable")
    print("  from a complete one.  It is not allowed to be.")
    want(all(not s.is_fixpoint and s.status.startswith("budget:")
             for s in starved),
         "a budget-exhausted saturation must not claim a fixpoint")
    want(len({s.status for s in starved}) == 3,
         "each starved run must name the bound it actually hit")

    # ---------------------------------------------------------------- 12
    hdr("12. PLANTED-FALSE CONTROL  (a rewrite the checker rejects)")
    where = [p for p in positions(task)
             if match(L4, subterm_at(task, p), {"?p"}) is not None]
    pos = where[0]
    print("  position    : %s, where %s"
          % (list(pos), subterm_at(task, pos).pretty()))
    good = apply_rule(task, pow4, "fwd", pos, ctx_after)
    print("  the GENUINE rule there : %s"
          % (good.dst.pretty()[:52] if good else "REFUSED"))
    want(good is not None, "the genuine theorem must apply at a matching position")

    forged = pow4.__class__(name="pow4", lhs=L4, rhs=sqr(sqr(sqr(VP))),
                            variables=frozenset({"?p"}))
    print("\n  forged rule : cites axiom 'pow4' but claims  %s = %s"
          % (forged.lhs.pretty(), forged.rhs.pretty()))
    probe2 = copy_context(ctx_after)
    got = apply_rule(task, forged, "fwd", pos, probe2)
    print("  it MATCHES  : %s" % (match(forged.lhs, subterm_at(task, pos),
                                        {"?p"}) is not None))
    print("  apply_rule  : %s" % got)
    print("  checker said: %s" % (probe2.errors[-1] if probe2.errors else "-"))
    gf = EGraph()
    gf.add(task)
    sf = saturate(gf, [forged], copy_context(ctx_after), Budget(max_iterations=3),
                  tag="f")
    print("  saturation with the forged rule alone: applications=%d unions=%d "
          "rejected=%d" % (sf.applications, sf.unions, sf.rejected))
    print("\n  The forged rule matches, builds a term, and is then destroyed by")
    print("  the checker.  Nothing it produced reaches the e-graph, so no later")
    print("  extraction can route through it.")
    want(got is None, "a rewrite the checker rejects must never be applied")
    want(sf.unions == 0 and sf.applications == 0,
         "a forged rule must contribute nothing to the e-graph")
    want(sf.rejected > 0, "the forged rule's applications must be counted as rejected")

    # ---------------------------------------------------------------- 13
    hdr("13. THE MATERIALISATION CLIFF  (extraction over classes, not terms)")
    print("  Sections 2-12 extract from the terms the e-graph *stores*, so the")
    print("  frontier can only ever contain a term somebody materialised.  With")
    print("  Budget.max_exhaustive_vars = 1 a multi-variable rule fires at one")
    print("  representative per class, so most combinations are never built, and")
    print("  a better route to an unbuilt term is invisible.  extract_class_frontier")
    print("  runs a Pareto fixpoint over the CLASS DAG instead: a class carries a")
    print("  Pareto set of realisations, a realisation is a node with its children")
    print("  replaced by any realisation of their classes, and the resulting term")
    print("  need never have been built.  Every route is still checked by")
    print("  kernel/check.py before it is costed.\n")

    cx0 = ClassExtractor(g0, finder=finder0)
    cd0 = extract_class_frontier(g0, ctx_before, task, finder=finder0, extractor=cx0)
    cx1 = ClassExtractor(g1, finder=finder1)
    cd1 = extract_class_frontier(g1, ctx_after, task, finder=finder1, extractor=cx1)
    sol0, sol1 = cx0.solve(), cx1.solve()
    known0, known1 = set(g0.terms()), set(g1.terms())
    print("  class fixpoint before : %s" % sol0.render())
    print("  class fixpoint after  : %s" % sol1.render())
    want(sol0.complete and sol1.complete,
         "the class fixpoint must converge rather than hit a bound here")

    def show_dag(tag, ex, known):
        new = [r for r in ex.frontier if r.target not in known]
        print("\n  %s -- %s" % (tag, ex.render()))
        print("    %-52s %5s %4s %5s %6s  built?" % ("extracted term", "steps",
                                                     "size", "width", "verify"))
        print("    " + "-" * 84)
        for r in ex.frontier:
            c = r.cost
            print("    %-52s %5d %4d %5d %6d  %s"
                  % (r.pretty()[:52], c.steps, c.size, c.width, c.verify,
                     "yes" if r.target in known else "NEVER BUILT"))
        return new

    new0 = show_dag("BEFORE the theorem", cd0, known0)
    new1 = show_dag("AFTER the theorem", cd1, known1)
    print("\n  stored-term frontier   : %d before, %d after"
          % (len(ex0.frontier), len(ex1.frontier)))
    print("  class-DAG frontier     : %d before, %d after"
          % (len(cd0.frontier), len(cd1.frontier)))
    print("  frontier routes to terms that were NEVER BUILT: %d before, %d after"
          % (len(new0), len(new1)))
    want(len(new0) > 0, "the class-DAG frontier must contain an unbuilt term")
    want(len(cd0.frontier) > len(ex0.frontier),
         "extraction over classes must find routes extraction over terms cannot")
    want(cd0.rejected == 0 and cd1.rejected == 0,
         "every class-DAG route must be accepted by the checker")

    dag_vals = sorted({value_of(T.lookup(r.target))
                       for r in list(cd0.routes) + list(cd1.routes)})
    print("\n  every class-DAG destination -- including the assembled ones the")
    print("  e-graph never stored -- evaluated by the independent exact-integer")
    print("  evaluator: %d routes, %d distinct value(s): %s"
          % (len(cd0.routes) + len(cd1.routes), len(dag_vals), dag_vals))
    want(dag_vals == [BASE ** EXP],
         "every class-DAG route must land on a term whose value is 3^8")

    dagdiff = frontier_diff(cd0.frontier, cd1.frontier)
    print("\n  curvature measured over the class DAG : %s" % dagdiff.render())
    print("  curvature measured over stored terms  : %s" % diff.render())

    tower = sqr(sqr(sqr(lit(BASE))))
    dag_before = min((r.cost.steps for r in cd0.routes if r.target == tower.addr),
                     default=-1)
    dag_after = min((r.cost.steps for r in cd1.routes if r.target == tower.addr),
                    default=-1)
    print("\n  LOUD: the published number this moves.")
    print("    route to sqr(sqr(sqr #3)), over the retained records (section 7):")
    print("      %d -> %d steps  (-%d)" % (tower_before, tower_after,
                                           tower_before - tower_after))
    print("    the same target, extracted over the class DAG:")
    print("      %d -> %d steps  (-%d)" % (dag_before, dag_after,
                                           dag_before - dag_after))
    print("    Both columns are checked proofs.  The class-DAG extractor finds a")
    print("    %d-step proof BEFORE the theorem that RouteFinder's shortest route"
          % dag_before)
    print("    through the retained merge records does not: %d is a minimum over"
          % tower_before)
    print("    record-graph routes, not over checkable proofs.  So the theorem's")
    print("    honest effect on this target is -%d, not -%d, and section 7's -%d"
          % (dag_before - dag_after, tower_before - tower_after,
             tower_before - tower_after))
    print("    is partly an artifact of how thoroughly the *before* run was")
    print("    extracted.  The direction of the claim is unchanged: the theorem")
    print("    still shortens it, and no route got longer.")
    want(dag_before <= tower_before,
         "the class-DAG route may not be worse than the record-graph geodesic")
    want(dag_after <= tower_after,
         "the class-DAG route may not be worse than the record-graph geodesic")

    cd2 = extract_class_frontier(g2, ctx_null, task, finder=finder2)
    dag_null_same = ([(r.target, r.cost.as_tuple()) for r in cd2.frontier] ==
                     [(r.target, r.cost.as_tuple()) for r in cd0.frontier])
    print("\n  NULL CONTROL over the class DAG : frontier identical to before: %s"
          % ("yes" if dag_null_same else "NO"))
    want(dag_null_same,
         "the null theorem must leave the class-DAG frontier bit-identical too")

    # ---------------------------------------------------------------- 14
    hdr("14. VERDICT")
    print("  task                        : evaluate 3^8, presented left-nested")
    print("  saturation before / after   : %s / %s"
          % (sat0.status, sat1.status))
    print("  Pareto frontier before      : %d nondominated routes"
          % len(ex0.frontier))
    print("  Pareto frontier after       : %d nondominated routes"
          % len(ex1.frontier))
    print("  frontier moved              : appeared %d, vanished %d, shortened %d"
          % (len(diff.appeared), len(diff.vanished), len(diff.shortened)))
    print("  geodesic to sqr(sqr(sqr #3)): %d -> %d steps (%d%% of before)"
          % (tower_before, tower_after, (100 * tower_after) // tower_before))
    print("  no geodesic lengthened      : %s"
          % ("yes" if all(a <= b for _, b, a in lengths) else "NO"))
    print("  NULL CONTROL                : frontier bit-identical (%s), %d "
          "applications" % ("yes" if same_targets and same_costs else "NO",
                            sum(1 for a in sat2.applied if a.rule == "pow4_plus")))
    print("  every route's answer        : %s (one value over %d routes),"
          % (vals, len(ex1.routes)))
    print("                                kernel-checked, and expandable to")
    print("                                primitives in a theorem-free context")
    print("  budget discipline           : %s"
          % ", ".join(s.status for s in starved))
    print("  planted-false rule          : applied 0 times, %d rejections counted"
          % sf.rejected)
    ok = not failures
    print("\n  MATHEMATICS CHANGED THE GEOMETRY: %s" % ("YES" if ok else "NO"))
    if failures:
        print("\n  FAILURES:")
        for f in failures:
            print("    - " + f)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
