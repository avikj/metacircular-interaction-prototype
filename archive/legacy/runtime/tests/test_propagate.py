#!/usr/bin/env python3
"""Adversarial test suite for L4 (runtime/propagate) and the Part-A homotopy fix.

Repo norm (collab/PROTOCOL.md Sec.7, msg 0073): a headline claim ships with its
own annihilation apparatus or it is not a claim.  Every capability below is
paired with a planted-false control that must fail.  A control that passes is a
failure of the suite and is reported as one.

Run:  python3 runtime/tests/test_propagate.py
Exit: 0 iff every capability passed AND every control failed as designed.

Output is byte-identical across runs: no floats, no clock, no set iteration.
"""

from __future__ import annotations

import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.kernel import check as C  # noqa: E402
from runtime.kernel import term as T  # noqa: E402
from runtime.kernel.egraph import (  # noqa: E402
    EGraph,
    IncompleteEnumeration,
    axiom_atom,
)
from runtime.propagate import (  # noqa: E402
    DIES,
    SURVIVES,
    UNDECIDED,
    CacheEntry,
    DependencyGraph,
    Derivation,
    Fact,
    Obligation,
    PropagateError,
    apply,
    brute_force_dependents,
    invalidate,
    justification_classes,
    route_delta,
    route_table,
    survival,
    verify_no_stale_reuse,
    verify_untouched,
)
from runtime.propagate.recompute import intact_cache_ids  # noqa: E402

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(REPO, "runtime", "demo"))
from propagate_demo import OBLIGATIONS, build_library, mix  # noqa: E402

# --------------------------------------------------------------------------
# harness (same shape as tests/test_kernel.py)
# --------------------------------------------------------------------------

CAPS: list = []
CONTROLS: list = []
LOG: list = []


def capability(name):
    def deco(fn):
        CAPS.append((name, fn))
        return fn
    return deco


def control(name):
    """A planted-false control.  The body returns True iff the runtime
    *rejected* / *detected* the planted falsehood."""
    def deco(fn):
        CONTROLS.append((name, fn))
        return fn
    return deco


def rejects(fn, *exc):
    try:
        fn()
    except exc:
        return True
    except Exception as other:
        LOG.append("    unexpected exception: %r" % (other,))
        return False
    return False


# --------------------------------------------------------------------------
# shared vocabulary
# --------------------------------------------------------------------------

N = T.base_sort("N")
qa, qb, qc = T.Const("qa", N), T.Const("qb", N), T.Const("qc", N)
idN = T.Lam(N, T.Var(0, N))


def two_axiom_graph():
    """a=b for two genuinely different reasons: two homotopy classes."""
    g = EGraph()
    g.add(qa)
    g.add(qb)
    g.merge(qa, qb, C.Axiom("ax:one"), edge_id="E1")
    g.merge(qa, qb, C.Axiom("ax:two"), edge_id="E2")
    return g


def reassociation_graph():
    """(id a) = (id b) two ways: congruence, or beta-axiom-beta.

    This is the naturality square of beta against congruence.  Both routes
    consume exactly the axiom ``ax:one`` and nothing else, so they are one
    proof in two presentations: 2 raw paths, 1 homotopy class.
    """
    t1, t2 = T.App(idN, qa), T.App(idN, qb)
    g = EGraph()
    g.add(t1)
    g.add(t2)
    g.merge(qa, qb, C.Axiom("ax:one"), edge_id="X1")   # fires congruence t1=t2
    g.merge(t1, qa, C.Beta(), edge_id="X2")
    g.merge(t2, qb, C.Beta(), edge_id="X3")
    return g, t1, t2


def dense_graph(links=6, parallel=3):
    """A chain with ``parallel`` independent axioms per link: parallel**links
    genuinely distinct classes.  Used to force an incomplete enumeration."""
    g = EGraph()
    chain = [T.Const("z%d" % i, N) for i in range(links + 1)]
    for t in chain:
        g.add(t)
    k = 0
    for i in range(links):
        for r in range(parallel):
            g.merge(chain[i], chain[i + 1], C.Axiom("ax:%d:%d" % (i, r)),
                    edge_id="D%03d" % k)
            k += 1
    return g, chain[0], chain[-1]


# ==========================================================================
# PART A -- homotopy classes of proof paths
# ==========================================================================

@capability("A1 two independent axioms are two homotopy classes")
def t_two_classes():
    g = two_axiom_graph()
    r = g.explanation_classes(qa, qb)
    assert r.complete, r.reason
    assert len(r.classes) == 2, "expected 2 classes, got %d" % len(r.classes)
    keys = sorted(c.multiset for c in r.classes)
    assert keys == [((("axiom", "ax:one"), 1),), ((("axiom", "ax:two"), 1),)], keys
    assert all(c.size == 1 for c in r.classes)
    return True


@capability("A2 two reassociations of one proof are ONE homotopy class")
def t_one_class():
    g, t1, t2 = reassociation_graph()
    r = g.explanation_classes(t1, t2)
    assert r.complete, r.reason
    assert r.raw_paths == 2, "expected 2 raw simple paths, got %d" % r.raw_paths
    assert len(r.classes) == 1, "expected 1 class, got %d" % len(r.classes)
    cls = r.classes[0]
    assert cls.multiset == ((("axiom", "ax:one"), 1),), cls.multiset
    assert cls.raw_paths == 2, cls.raw_paths
    return True


@capability("A3 every class representative is re-checked by the kernel checker")
def t_representatives_checked():
    ctx = C.CheckContext()
    ctx.declare_axiom("ax:one", qa, qb)
    ctx.declare_axiom("ax:two", qa, qb)
    g = two_axiom_graph()
    for cls in g.explanation_classes(qa, qb).classes:
        assert C.check_path(cls.representative, qa.addr, qb.addr, ctx), ctx.errors
    g2, t1, t2 = reassociation_graph()
    for cls in g2.explanation_classes(t1, t2).classes:
        assert C.check_path(cls.representative, t1.addr, t2.addr, ctx), ctx.errors
    return True


@capability("A4 congruence consumes its arguments' axioms, not an axiom of its own")
def t_congruence_atoms():
    f = T.Const("cf", T.arrow(N, N))
    fa, fb = T.App(f, qa), T.App(f, qb)
    g = EGraph()
    g.add(fa)
    g.add(fb)
    g.merge(qa, qb, C.Axiom("ax:one"), edge_id="E1")
    r = g.explanation_classes(fa, fb)
    assert r.complete
    assert len(r.classes) == 1
    # the congruence step's class is exactly the argument's class
    assert r.classes[0].multiset == ((("axiom", "ax:one"), 1),), r.classes[0].multiset
    assert r.classes[0].size == 1
    return True


@capability("A5 a hit bound yields an explicit Incomplete, carrying what and why")
def t_incomplete_marker():
    g, lo, hi = dense_graph()
    full = g.explanation_classes(lo, hi)
    assert full.complete and len(full.classes) == 3 ** 6, len(full.classes)
    tight = g.explanation_classes(lo, hi, max_paths=100)
    assert not tight.complete
    assert "max_paths=100" in tight.reason, tight.reason
    assert len(tight.partial()) == 100, len(tight.partial())
    assert tight.count_or_none() is None
    assert dict(tight.bounds)["max_paths"] == 100
    deep = g.explanation_classes(lo, hi, max_depth=2)
    assert not deep.complete and "max_depth" in deep.reason, deep.reason
    return True


@capability("A6 enumeration is deterministic and order-independent in its keys")
def t_deterministic():
    a1 = [c.multiset for c in two_axiom_graph().explanation_classes(qa, qb).classes]
    a2 = [c.multiset for c in two_axiom_graph().explanation_classes(qa, qb).classes]
    g, lo, hi = dense_graph(3, 2)
    b1 = [c.multiset for c in g.explanation_classes(lo, hi).classes]
    g2, lo2, hi2 = dense_graph(3, 2)
    b2 = [c.multiset for c in g2.explanation_classes(lo2, hi2).classes]
    return a1 == a2 and b1 == b2 and len(b1) == 8


def deep_branch_graph(deep=300, short=15):
    """The shape the L3 lane filed against this enumerator.

    ``z0 = z1 = ... = z_deep = END`` is a long chain whose records carry the
    *lowest* ids, so a depth-first search meets it first and cannot close it
    inside ``max_depth``.  A genuinely short ``short``-axiom route between the
    same endpoints is added afterwards, with higher record ids.  The geodesic
    class is therefore hidden *behind* a branch that overruns the depth bound.
    """
    g = EGraph()
    chain = [T.Const("z%03d" % i, N) for i in range(deep + 1)]
    end = T.Const("END", N)
    for t in chain:
        g.add(t)
    g.add(end)
    for i in range(deep):
        g.merge(chain[i], chain[i + 1], C.Axiom("deep:%d" % i), edge_id="D%04d" % i)
    g.merge(chain[deep], end, C.Axiom("deep:tail"), edge_id="D%04d" % deep)
    mids = [T.Const("s%03d" % i, N) for i in range(1, short)]
    for t in mids:
        g.add(t)
    nodes = [chain[0]] + mids + [end]
    for i in range(len(nodes) - 1):
        g.merge(nodes[i], nodes[i + 1], C.Axiom("short:%d" % i), edge_id="S%04d" % i)
    return g, chain[0], end


@capability("A7 max_depth backtracks: a short class behind a deep branch is found")
def t_depth_backtracks():
    g, lo, hi = deep_branch_graph()
    r = g.explanation_classes(lo, hi)          # default max_depth=32
    found = r.partial()
    # the defect: the DFS dove into the 301-record chain, hit max_depth and
    # aborted the whole enumeration, returning nothing usable.
    assert found, "depth bound aborted the search instead of backtracking"
    assert min(c.size for c in found) == 15, sorted(c.size for c in found)
    # and the short class really is the short route, not a bookkeeping artefact
    short = min(found, key=lambda c: c.size)
    assert all(a[0] == "axiom" and a[1].startswith("short:") for a in short.axioms), \
        sorted(short.axioms)
    assert len(short.representative) == 15, len(short.representative)
    # honesty is unchanged: the deep branch really was pruned, so the
    # enumeration must still refuse to call itself complete.
    assert not r.complete and "max_depth" in r.reason, r.reason
    return True


@capability("A8 a raised depth bound closes the same enumeration completely")
def t_depth_raised():
    g, lo, hi = deep_branch_graph(deep=8, short=4)
    tight = g.explanation_classes(lo, hi, max_depth=4)
    assert not tight.complete and "max_depth" in tight.reason, tight.reason
    assert [c.size for c in tight.partial()] == [4], [c.size for c in tight.partial()]
    full = g.explanation_classes(lo, hi, max_depth=32)
    assert full.complete, full.reason
    assert sorted(c.size for c in full.classes) == [4, 9], \
        sorted(c.size for c in full.classes)
    return True


@control("CONTROL A: backtracking must not launder a pruned search as complete")
def x_depth_pruned_not_complete():
    g, lo, hi = deep_branch_graph(deep=40, short=5)
    r = g.explanation_classes(lo, hi, max_depth=6)
    planted = r.complete                       # the falsehood: "found some, so done"
    ok = not planted and len(r.partial()) >= 1
    ok &= rejects(lambda: r.classes, IncompleteEnumeration)
    return ok


@control("CONTROL A: a caller that ignores the Incomplete marker must break loudly")
def x_ignore_incomplete():
    g, lo, hi = dense_graph()
    tight = g.explanation_classes(lo, hi, max_paths=100)

    def naive_len():
        return len(tight)                       # the planted careless caller

    def naive_iter():
        return [p for p in tight]

    def naive_classes():
        return tight.classes

    def naive_eq():
        return tight == ()

    ok = rejects(naive_len, IncompleteEnumeration)
    ok &= rejects(naive_iter, IncompleteEnumeration)
    ok &= rejects(naive_classes, IncompleteEnumeration)
    ok &= rejects(naive_eq, IncompleteEnumeration)
    # and the honest caller still gets the goods, having said so in writing
    ok &= len(tight.partial()) == 100
    return ok


@control("CONTROL A: two independent axioms must NOT collapse to one class")
def x_overmerge():
    g = two_axiom_graph()
    r = g.explanation_classes(qa, qb)
    planted = (len(r.classes) == 1)             # the falsehood
    return not planted


@control("CONTROL A: two reassociations must NOT be counted as two proofs")
def x_oversplit():
    g, t1, t2 = reassociation_graph()
    r = g.explanation_classes(t1, t2)
    planted = (len(r.classes) == r.raw_paths)   # the falsehood: raw paths as proofs
    return not planted and r.raw_paths == 2


@control("CONTROL A: a Conjecture is not an axiom atom")
def x_conjecture_atom():
    return rejects(lambda: axiom_atom(C.Conjectural("RH")), Exception)


# ==========================================================================
# PART B -- L4
# ==========================================================================

@capability("B1 the forward cone is exact: it matches a full reread of the library")
def t_cone_exact():
    g = build_library()
    g.build()
    for seed in ("P00", "P07", "P12", "ISOLATED", "P23"):
        cone = g.forward_cone(seed)
        oracle = brute_force_dependents(g, seed)
        assert frozenset(cone.facts) == oracle, (
            seed, sorted(oracle - frozenset(cone.facts)),
            sorted(frozenset(cone.facts) - oracle))
    cone = g.forward_cone("P00")
    assert cone.size == 7 and cone.total_facts == 45, (cone.size, cone.total_facts)
    return True


@capability("B2 a consequence with an independent second proof SURVIVES; one without DIES")
def t_survival():
    g = build_library()
    g.build()
    sa = survival(g, "THEOREM_A", "P00")
    sb = survival(g, "THEOREM_B", "P00")
    sc = survival(g, "COROLLARY", "P00")
    assert sa.status == SURVIVES and sa.alive, sa.render()
    assert len(sa.surviving) == 1 and len(sa.killed) == 1
    assert sb.status == DIES and not sb.alive, sb.render()
    assert sc.status == SURVIVES, sc.render()
    # the surviving class must genuinely avoid the retracted fact
    assert ("fact", "P00") not in sa.surviving[0].axioms
    assert all(("fact", "P00") in c.axioms for c in sb.killed)
    return True


@capability("B3 survival (decided before) agrees with liveness (computed after)")
def t_survival_agrees():
    g = build_library()
    g.build()
    plan = invalidate(g, "P00", OBLIGATIONS)
    apply(g, plan)
    for fid in plan.cone.facts:
        expect = plan.survivals[fid].status == SURVIVES
        assert g.is_live_fact(fid) == expect, (
            fid, plan.survivals[fid].status, g.is_live_fact(fid))
    return True


@capability("B4 caches: stale vs dead vs intact, and intact means the same object")
def t_caches():
    g = build_library()
    g.build()
    snap = g.cache_snapshot()
    plan = invalidate(g, "P00", OBLIGATIONS)
    assert set(plan.stale_caches) == {"THEOREM_A", "COROLLARY"}, plan.stale_caches
    assert set(plan.dead_caches) == {"P00", "S0_0", "S0_top", "THEOREM_B",
                                     "REPORT"}, plan.dead_caches
    outside = intact_cache_ids(g, plan)
    apply(g, plan)
    ok, bad = verify_untouched(snap, g, outside)
    assert ok, bad
    ok2, bad2 = verify_no_stale_reuse(g, plan, snap)
    assert ok2, bad2
    for f in plan.dead_caches:
        assert g.cache_entry(f) is None, f
    return True


@capability("B5 incremental recomputation is cheaper AND agrees with a full rebuild")
def t_incremental():
    g = build_library()
    g.build()
    plan = invalidate(g, "P00", OBLIGATIONS)
    rep = apply(g, plan)
    assert rep.cost == 42 and rep.full_cost == 226, (rep.cost, rep.full_cost)
    assert rep.cost * 4 < rep.full_cost, rep.render()
    incremental = {f: g.value(f) for f in g.live_facts()
                   if g.cache_entry(f) is not None}
    # a from-scratch rebuild of the same post-retraction library must agree
    h = build_library()
    h.mark_retracted("P00")
    h.build()
    scratch = {f: h.value(f) for f in h.live_facts()
               if h.cache_entry(f) is not None}
    assert incremental == scratch, sorted(
        k for k in set(incremental) | set(scratch)
        if incremental.get(k) != scratch.get(k))
    return True


@capability("B6 NULL CONTROL: retracting a fact nothing depends on dirties nothing")
def t_null_control():
    g = build_library()
    g.build()
    snap = g.cache_snapshot()
    plan = invalidate(g, "ISOLATED", OBLIGATIONS)
    outside = intact_cache_ids(g, plan)
    rep = apply(g, plan)
    assert plan.cone.size == 1, plan.cone.render()
    assert plan.cone.steps == 1, plan.cone.steps
    assert plan.steps <= 2, plan.steps                 # O(1), not O(library)
    assert rep.steps <= 2, rep.steps
    assert rep.cost == 0 and rep.recomputed == (), rep.render()
    assert plan.stale_caches == () and plan.survives == ()
    ok, bad = verify_untouched(snap, g, outside)
    assert ok, bad
    assert len(outside) == 44
    return True


@capability("B7 routes vanish on retraction and shorten on a crystallised lemma")
def t_routes():
    g = build_library()
    g.build()
    targets = ("THEOREM_A", "THEOREM_B", "COROLLARY", "REPORT")
    before = route_table(g, targets)
    assert before["THEOREM_A"].classes == 2 and before["THEOREM_A"].shortest == 12
    assert before["THEOREM_B"].classes == 1 and before["THEOREM_B"].shortest == 6
    plan = invalidate(g, "P00", OBLIGATIONS)
    apply(g, plan)
    after = route_table(g, targets)
    d = {x.fid: x.status for x in route_delta(before, after)}
    assert d["THEOREM_B"] == "vanished" and d["REPORT"] == "vanished", d
    assert d["THEOREM_A"] == "narrowed" and d["COROLLARY"] == "narrowed", d
    g.add_derivation(Derivation("d.A.lemma", "THEOREM_A", ("S2_top",), 5,
                                "crystallised shortcut", mix))
    lemma = route_table(g, ("THEOREM_A", "COROLLARY"))
    d2 = {x.fid: x.status for x in route_delta(after, lemma)}
    assert d2["THEOREM_A"] == "shortened" and d2["COROLLARY"] == "shortened", d2
    assert lemma["THEOREM_A"].shortest == 6, lemma["THEOREM_A"]
    return True


@capability("B8 obligations sort into discharged / sharper / irrelevant / unchanged")
def t_obligations():
    g = build_library()
    g.build()
    obs = OBLIGATIONS + (
        Obligation("O4", "THEOREM_A", frozenset({"P00", "P12"}), "mixed"),
    )
    plan = invalidate(g, "P00", obs)
    got = {v.oid: v.status for v in plan.obligations}
    assert got["O1"] == "discharged", got          # owed only dead facts
    assert got["O2"] == "irrelevant", got          # target died
    assert got["O3"] == "unchanged", got           # still load-bearing
    assert got["O4"] == "sharper", got             # P00 dropped, P12 remains
    o4 = [v for v in plan.obligations if v.oid == "O4"][0]
    assert o4.owes_before == ("P00", "P12") and o4.owes_after == ("P12",), o4
    return True


@capability("B9 the demo runs and is byte-identical across runs")
def t_demo_deterministic():
    path = os.path.join(REPO, "runtime", "demo", "propagate_demo.py")
    env = dict(os.environ)
    a = subprocess.run([sys.executable, path], capture_output=True, env=env)
    env["PYTHONHASHSEED"] = "12345"
    b = subprocess.run([sys.executable, path], capture_output=True, env=env)
    assert a.returncode == 0 and b.returncode == 0, (a.returncode, b.returncode)
    assert a.stdout == b.stdout, "demo output is not deterministic"
    assert b"NULL CONTROL" in a.stdout
    return True


def deep_justification_library(deep=60, retracted="R0"):
    """The L4 shape of the defect the L3 lane filed against L2.

    ``THEOREM`` has exactly two derivations:

    ``d.a_deep``   a chain of ``deep`` derivations standing on ``R0`` -- deeper
                   than the default ``max_depth`` and, because derivations are
                   taken in sorted id order, the branch the search meets first;
    ``d.b_short``  one derivation from two independent primitives, using
                   nothing the retraction touches.

    So the *surviving* justification sits behind a branch that overruns the
    depth bound.  A search that aborts globally at ``max_depth`` returns no
    class at all, and ``survival`` degrades to ``UNDECIDED`` -- on a theorem
    that plainly survives.
    """
    g = DependencyGraph()
    g.add_fact(Fact(retracted, "the retracted hypothesis", 1))
    g.add_fact(Fact("Q0", "independent hypothesis", 2))
    g.add_fact(Fact("Q1", "independent hypothesis", 3))
    prev = retracted
    for i in range(deep):
        nxt = "C%03d" % i
        g.add_fact(Fact(nxt, "chain link", i))
        g.add_derivation(Derivation("d.chain%03d" % i, nxt, (prev,), 1,
                                    compute=lambda v, _p=prev: v[_p]))
        prev = nxt
    g.add_fact(Fact("THEOREM", "the consequence", None))
    g.add_derivation(Derivation("d.a_deep", "THEOREM", (prev,), 1,
                                compute=lambda v, _p=prev: v[_p]))
    g.add_derivation(Derivation("d.b_short", "THEOREM", ("Q0", "Q1"), 1,
                                compute=lambda v: v["Q0"] + v["Q1"]))
    return g


@capability("B10 max_depth backtracks in L4: a SURVIVOR behind a deep branch is found")
def t_l4_depth_backtracks():
    g = deep_justification_library()
    g.build()
    enum = justification_classes(g, "THEOREM")       # default max_depth=32
    found = enum.partial()
    # the defect: the first (deep) derivation overran max_depth and set a global
    # stop flag, so the enumeration returned nothing and the short, independent
    # justification was never seen.
    assert found, "depth bound aborted the search instead of backtracking"
    assert min(c.size for c in found) == 2, sorted(c.size for c in found)
    short = min(found, key=lambda c: c.size)
    assert short.leaves() == ("Q0", "Q1"), short.leaves()
    assert short.representative == ("d.b_short",), short.representative
    # and the verdict it decides: SURVIVES, where the defect gave UNDECIDED.
    s = survival(g, "THEOREM", "R0")
    assert s.status == SURVIVES and s.alive, s.render()
    assert ("fact", "R0") not in s.surviving[0].axioms
    # the deep branch really was pruned, so the enumeration must still say so
    assert not enum.complete and "max_depth" in enum.reason, enum.reason
    return True


@capability("B11 a raised depth bound closes the same L4 enumeration completely")
def t_l4_depth_raised():
    g = deep_justification_library(deep=8)
    g.build()
    tight = justification_classes(g, "THEOREM", max_depth=4)
    assert not tight.complete and "max_depth" in tight.reason, tight.reason
    assert [c.size for c in tight.partial()] == [2], [c.size for c in tight.partial()]
    full = justification_classes(g, "THEOREM", max_depth=32)
    assert full.complete, full.reason
    assert sorted(c.size for c in full.classes) == [1, 2], \
        sorted(c.size for c in full.classes)
    # the deep class is the one that dies with R0; the short one is not
    deep_cls = [c for c in full.classes if ("fact", "R0") in c.axioms]
    assert len(deep_cls) == 1 and len(deep_cls[0].representative) == 9, \
        [c.representative for c in full.classes]
    return True


@control("CONTROL B: L4 backtracking must not launder a pruned search as complete")
def x_l4_depth_pruned_not_complete():
    g = deep_justification_library(deep=40)
    g.build()
    enum = justification_classes(g, "THEOREM", max_depth=6)
    planted = enum.complete                    # the falsehood: "found some, so done"
    ok = not planted and len(enum.partial()) == 1
    ok &= "max_depth" in enum.reason
    ok &= rejects(lambda: enum.classes, IncompleteEnumeration)
    # and a *complete* run on the same graph must still be able to say complete,
    # so the control is testing the reporting and not a hard-wired False
    ok &= justification_classes(g, "THEOREM", max_depth=64).complete
    return ok


@control("CONTROL B: a 'survivor' whose every proof runs through the retracted fact")
def x_false_survivor():
    """THEOREM_B is *claimed* to survive because it has a derivation.  Having a
    derivation is not having an independent one: every class contains P00."""
    g = build_library()
    g.build()
    s = survival(g, "THEOREM_B", "P00")
    planted = (s.status == SURVIVES)
    ok = not planted and s.status == DIES
    # the claim is falsified constructively: exhibit the class inventory
    enum = justification_classes(g, "THEOREM_B")
    ok &= enum.complete and len(enum.classes) >= 1
    ok &= all(("fact", "P00") in c.axioms for c in enum.classes)
    # and .alive must not silently answer for an undecided verdict
    ok &= rejects(lambda: survival(g, "THEOREM_A", "P00", max_paths=1).alive
                  if survival(g, "THEOREM_A", "P00", max_paths=1).status == UNDECIDED
                  else (_ for _ in ()).throw(IncompleteEnumeration("n/a")),
                  IncompleteEnumeration)
    return ok


@control("CONTROL B: a cone that omits a genuine dependent must be detectable")
def x_truncated_cone():
    g = build_library()
    g.build()
    # the planted falsehood: "direct dependents are the cone"
    truncated = {"P00"} | {g.derivation(d).conclusion for d in g.uses("P00")}
    oracle = brute_force_dependents(g, "P00")
    real = frozenset(g.forward_cone("P00").facts)
    ok = truncated != oracle and truncated < oracle      # it really is missing some
    ok &= real == oracle                                 # and the real cone is not
    missing = oracle - truncated
    ok &= {"THEOREM_A", "THEOREM_B", "COROLLARY", "REPORT"} <= missing
    return ok


@control("CONTROL B: a 'clean' recompute that silently reuses an invalid cache")
def x_stale_reuse():
    g = build_library()
    g.build()
    snap = g.cache_snapshot()
    plan = invalidate(g, "P00", OBLIGATIONS)
    apply(g, plan)
    # plant it: put the pre-retraction entry back, as a lazy incremental engine
    # would if it decided "THEOREM_A survived, so its value is still fine"
    g._cache["THEOREM_A"] = snap["THEOREM_A"]
    ok, bad = verify_no_stale_reuse(g, plan, snap)
    return (not ok) and bad == ("THEOREM_A",)


@control("CONTROL B: an equal-but-rebuilt cache outside the cone is not 'untouched'")
def x_equal_not_identical():
    g = build_library()
    g.build()
    snap = g.cache_snapshot()
    plan = invalidate(g, "P00", OBLIGATIONS)
    outside = intact_cache_ids(g, plan)
    apply(g, plan)
    old = g.cache_entry("S2_top")
    g._cache["S2_top"] = CacheEntry(fid=old.fid, did=old.did, value=old.value,
                                    support=old.support, generation=old.generation)
    assert g.cache_entry("S2_top") == old        # equal values -- the planted claim
    ok, bad = verify_untouched(snap, g, outside)
    return (not ok) and bad == ("S2_top",)


@control("CONTROL B: a derived fact must not be retractable as if it were primitive")
def x_retract_derived():
    g = build_library()
    g.build()
    ok = rejects(lambda: invalidate(g, "THEOREM_A"), PropagateError)
    ok &= rejects(lambda: g.mark_retracted("S0_top"), PropagateError)
    return ok


@control("CONTROL B: a plan built on an UNDECIDED survival must not be applied")
def x_undecided_plan():
    g = build_library()
    g.build()
    plan = invalidate(g, "P00", OBLIGATIONS, max_paths=1)
    ok = bool(plan.undecided)                    # the bound really did bite
    ok &= rejects(lambda: apply(g, plan), IncompleteEnumeration)
    ok &= rejects(lambda: route_table(g, ("THEOREM_A",), max_paths=1),
                  IncompleteEnumeration)
    return ok


@control("CONTROL B: a retracted fact must not justify anything afterwards")
def x_retracted_justifies():
    g = build_library()
    g.build()
    plan = invalidate(g, "P00", OBLIGATIONS)
    apply(g, plan)
    enum = justification_classes(g, "THEOREM_B")
    ok = enum.complete and len(enum.classes) == 0       # planted: "still provable"
    enum_a = justification_classes(g, "THEOREM_A")
    ok &= enum_a.complete and len(enum_a.classes) == 1
    ok &= all(("fact", "P00") not in c.axioms for c in enum_a.classes)
    ok &= not g.is_live_fact("P00")
    return ok


# --------------------------------------------------------------------------
# counter demo
# --------------------------------------------------------------------------

def counter_demo() -> str:
    g = build_library()
    full = g.build()
    plan = invalidate(g, "P00", OBLIGATIONS)
    rep = apply(g, plan)
    eg = two_axiom_graph()
    eg.explanation_classes(qa, qb)
    lines = [
        "counter demo: 45-fact library; retract P00; homotopy-class survival",
        "  cone      : %s" % plan.cone.render(),
        "  verdict   : %s" % plan.render(),
        "  recompute : %s" % rep.render(),
        "  full build %d -> incremental %d (%d%% of a rebuild)"
        % (full, rep.cost, rep.cost * 100 // rep.full_cost),
        "  propagate : %s" % g.report(),
        "  egraph    : %s" % eg.report(),
    ]
    return "\n".join(lines)


def main() -> int:
    passed = failed = 0
    for name, fn in CAPS:
        try:
            ok = bool(fn())
        except Exception as exc:
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s" % name)
        else:
            failed += 1
            print("FAIL  %s" % name)
    for name, fn in CONTROLS:
        try:
            ok = bool(fn())
        except Exception as exc:
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s (planted falsehood was rejected)" % name)
        else:
            failed += 1
            print("FAIL  %s (planted falsehood was ACCEPTED)" % name)
    print()
    print(counter_demo())
    if LOG:
        print()
        print("diagnostics:")
        for line in LOG:
            print(line)
    print()
    print("SUMMARY capabilities=%d controls=%d passed=%d failed=%d"
          % (len(CAPS), len(CONTROLS), passed, failed))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
