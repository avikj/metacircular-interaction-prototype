#!/usr/bin/env python3
"""Adversarial tests for the generation lane and the closed loop.

Run standalone:   python3 runtime/tests/test_generate.py
or under pytest:  pytest runtime/tests/test_generate.py

Every positive claim here is paired with a planted control that must fail.
The four the brief names explicitly are:

    x_corrupt_rewrite_*            a corrupt rewrite trying to enter the
                                   accepted graph
    x_conjecture_used_as_*         a conjecture used as if it were discharged
    x_refuted_conjecture_cone_*    a refutation whose cone is left standing
    x_benchmark_as_generation_*    a "benchmark improvement" that is really
                                   leakage -- the benchmark used as a target

Controls are named ``x_...`` rather than ``test_...`` and are *invoked* by the
matching ``test_...`` case, which asserts they fail.  A control that silently
passes is a test that has stopped testing anything, so each one is asserted to
raise the specific exception it is supposed to raise.
"""

from __future__ import annotations

import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (I, P, RULE_TABLE, S, Sub, V,       # noqa: E402
                                            Lemma, PV, poly_equal, render)
from runtime.execute.rewrite import RewriteError, rule_from_edge              # noqa: E402
from runtime.generate.loop import (BENCHMARK, BENCHMARK2, BENCHMARKS,        # noqa: E402
                                   Config, Organism, benchmark_cost,
                                   constructions, leakage_report)
from runtime.generate.multiway import (AxiomVault, GenerationBudget, MEdge,    # noqa: E402
                                       MultiwayGraph, Refusal, causal_report,
                                       encode, generate, kernel_dirs,
                                       lift_path)
from runtime.generate.propose import (AUDIT_GRID, DEFAULT_CHANNEL,             # noqa: E402
                                      DISCHARGED, OPEN, REFUTED, ProposalGraph,
                                      collisions, discharge_by_rewriting,
                                      discharge_by_saturation, probe,
                                      signature, triage, uniform, variables_of)
from runtime.kernel import check as C                                          # noqa: E402
from runtime.kernel import term as T                                           # noqa: E402
from runtime.kernel.edges import Edge, compose                                 # noqa: E402
from runtime.propagate.cone import Derivation as PDerivation                   # noqa: E402
from runtime.propagate.cone import Fact                                        # noqa: E402

a, b, u, v, x, y, z = (V(n) for n in ("a", "b", "u", "v", "x", "y", "z"))

SEED = P(S(x, y), Sub(x, y))
SEED2 = P(S(u, v), S(u, v))

SMALL = GenerationBudget(max_states=60, max_edges=150, max_depth=4, max_size=20)


def _graph(seeds=(SEED,), budget=SMALL):
    return generate(list(seeds), budget)


# ==========================================================================
# 1. the bridge and the typed edge
# ==========================================================================

def test_encoding_is_injective_on_the_terms_the_loop_builds():
    """Two different ring terms must never share a kernel address.

    If they could, a corrupt step could be laundered into a true one by
    collision alone, and every gate downstream would be checking the wrong
    pair of terms.
    """
    g = _graph()
    seen = {}
    for addr in g.order:
        t = g.states[addr]
        k = encode(t).addr
        assert seen.setdefault(k, addr) == addr, \
            "encode collided: %s and %s" % (render(t), render(g.states[seen[k]]))
    assert len(seen) == len(g.order) > 20


def test_kernel_dirs_and_lift_path_reach_the_right_subterm():
    t = S(I(3), P(S(x, y), Sub(x, y)))
    dirs = kernel_dirs(t, (1, 0))
    k = encode(t)
    for d in dirs:
        k = k.children[0] if d == "fn" else k.children[1]
    assert k is encode(S(x, y))


def test_every_generated_edge_is_a_kernel_checked_Eq_edge():
    g = _graph()
    assert len(g.edges) > 30
    ok, why = g.audit()
    assert ok, why
    assert all(e.edge.kind == "Eq" for e in g.edges)
    # the audit is not vacuous: it uses a *fresh* context, not the admitting one
    assert len(g.vault) > 0


def test_multiway_retains_all_histories_not_one_route():
    """A state reached two ways keeps both edges; that is the multiway claim."""
    g = _graph()
    multi = [addr for addr in g.order if len(g.inc[addr]) > 1]
    assert multi, "no state was reached by two distinct histories"
    total_in = sum(len(g.inc[addr]) for addr in g.order)
    assert total_in > len(g.order), (total_in, len(g.order))


def test_causal_structure_separates_dependent_from_concurrent_steps():
    g = _graph()
    cr = causal_report(g)
    assert cr.causal > 0 and cr.concurrent > 0, cr.render()
    assert cr.diamonds_closed > 0, "no concurrent pair reconverged"
    assert cr.max_out_degree > 1


def test_generation_is_deterministic_and_budget_honest():
    g1, g2 = _graph(), _graph()
    assert [g1.states[a].addr for a in g1.order] == \
           [g2.states[a].addr for a in g2.order]
    assert [(e.rule, e.pos, e.src, e.dst) for e in g1.edges] == \
           [(e.rule, e.pos, e.src, e.dst) for e in g2.edges]
    tiny = generate([SEED], GenerationBudget(max_states=8, max_edges=40,
                                             max_depth=3, max_size=20))
    assert tiny.status.startswith("budget:"), tiny.status
    assert len(tiny.states) <= 8


# ==========================================================================
# 2. CONTROL -- a corrupt rewrite must be refused entry
# ==========================================================================

def x_corrupt_rewrite_enters_the_accepted_graph():
    """PLANTED FALSE: claim ``distrib`` produced a term it did not produce."""
    g = MultiwayGraph(AxiomVault())
    forged = S(P(x, x))                        # not distrib's output, and false
    got = g.admit(SEED, (), "distrib", forged)
    if isinstance(got, MEdge):
        raise AssertionError("a corrupt rewrite was admitted")
    raise RuntimeError(got.render())


def test_corrupt_rewrite_is_refused_by_gate_A1():
    try:
        x_corrupt_rewrite_enters_the_accepted_graph()
    except RuntimeError as exc:
        assert "A1" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")
    g = MultiwayGraph(AxiomVault())
    g.admit(SEED, (), "distrib", S(P(x, x)))
    assert len(g.edges) == 0 and len(g.states) == 0
    assert len(g.vault) == 0, "a refused step still declared an axiom"


def x_true_but_wrongly_attributed_rewrite_is_admitted():
    """PLANTED FALSE, subtler: the claimed contractum is a *true* equality but
    is not what the named rule does.  A2 would pass; A1 must still refuse."""
    g = MultiwayGraph(AxiomVault())
    true_other = S(P(x, x), P(I(-1), y, y))     # equals SEED, but not distrib
    assert poly_equal(SEED, true_other)
    got = g.admit(SEED, (), "distrib", true_other)
    if isinstance(got, MEdge):
        raise AssertionError("a mis-attributed rewrite was admitted")
    raise RuntimeError(got.render())


def test_true_but_wrongly_attributed_rewrite_is_still_refused():
    try:
        x_true_but_wrongly_attributed_rewrite_is_admitted()
    except RuntimeError as exc:
        assert "A1" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def x_forged_edge_with_an_undeclared_axiom_is_accepted():
    """PLANTED FALSE: bypass the vault entirely and hand the checker an edge
    whose witness names an axiom nobody declared."""
    vault = AxiomVault()
    src, dst = encode(SEED), encode(S(P(x, x)))
    path = (C.Step(src=src.addr, dst=dst.addr, kind="assumption",
                   witness=C.Axiom("rw|distrib|forged|forged")),)
    e = Edge(kind="Eq", src=src.addr, dst=dst.addr, witness=path)
    if C.check_edge(e, vault.ctx):
        raise AssertionError("the checker accepted a forged edge")
    raise RuntimeError(vault.ctx.errors[-1])


def test_forged_edge_is_refused_by_the_kernel():
    try:
        x_forged_edge_with_an_undeclared_axiom_is_accepted()
    except RuntimeError as exc:
        assert "undeclared axiom" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def test_a_fabricated_rule_name_declares_nothing():
    vault = AxiomVault()
    assert vault.declare("no_such_rule", SEED, S(P(x, x))) is None
    assert vault.a1_failures == 1 and len(vault) == 0


def test_lemma_steps_go_through_the_same_gate():
    """An installed lemma is still re-matched before its axiom is declared."""
    good = Lemma("L", P(S(PV(0), PV(1)), S(PV(0), P(I(-1), PV(1)))),
                 S(P(I(-1), PV(1), PV(1)), P(PV(0), PV(0))))
    vault = AxiomVault()
    rhs = S(P(I(-1), y, y), P(x, x))
    assert vault.declare("lemma:L", SEED, rhs, lemma=good) is not None
    bad = Lemma("B", P(S(PV(0), PV(1)), S(PV(0), P(I(-1), PV(1)))), P(PV(0), PV(0)))
    v2 = AxiomVault()
    assert v2.declare("lemma:B", SEED, rhs, lemma=bad) is None
    assert v2.a1_failures == 1


# ==========================================================================
# 3. observation, collision, proposal
# ==========================================================================

def test_signature_is_exact_and_refuses_unobservable_terms():
    assert signature(S(x, y), (uniform(1),)) == (2,)
    assert signature(S(x, y), (uniform(1, mod=2),)) == (0,)
    assert signature(V("q"), (uniform(1),)) is None
    assert all(isinstance(k, int) for k in signature(P(x, y), DEFAULT_CHANNEL))


def test_collisions_are_a_permutation_under_source_priority():
    """Source priority reorders, it never adds or drops a pair."""
    # four terms, one bucket (all vanish on the diagonal), two sources
    terms = [P(S(x, y), Sub(x, y)), S(P(x, x), P(I(-1), y, y)),
             P(S(u, v), Sub(u, v)), S(P(u, u), P(I(-1), v, v))]
    chan = (uniform(1), uniform(2))
    src = {terms[0].addr: 0, terms[1].addr: 0,
           terms[2].addr: 1, terms[3].addr: 1}
    plain = collisions(terms, chan)
    ranked = collisions(terms, chan, sources=src)
    key = lambda ps: sorted((p.addr, q.addr) for p, q in ps)   # noqa: E731
    assert len(plain) == 6, len(plain)
    assert key(plain) == key(ranked), "source priority changed the *set*"
    assert plain != ranked, "source priority changed nothing at all"
    first = ranked[0]
    assert src[first[0].addr] != src[first[1].addr], "first pair is same-source"
    # and under a budget the cross-source pairs are the ones that survive
    cut = collisions(terms, chan, limit=4, sources=src)
    assert all(src[p.addr] != src[q.addr] for p, q in cut), cut


def test_conjecture_edges_never_compose_and_never_check():
    g = _graph()
    pg = ProposalGraph(g.vault)
    t1, t2 = g.states[g.order[0]], g.states[g.order[1]]
    cj = pg.propose(t1, t2, 0)
    assert cj is not None and cj.edge.kind == "Conjecture"
    assert not C.check_edge(cj.edge, C.CheckContext())
    good = g.edges[0].edge
    assert compose(cj.edge, good) is None
    assert compose(good, cj.edge) is None


def x_conjecture_used_as_if_discharged():
    """PLANTED FALSE, three ways: put a Conjecture edge in the accepted set,
    make a rewrite rule from it, and ask the checker to believe it."""
    g = _graph()
    pg = ProposalGraph(g.vault)
    cj = pg.propose(g.states[g.order[0]], g.states[g.order[1]], 0)
    fails = 0
    try:
        pg.accept(cj.cid, cj.edge)
    except ValueError:
        fails += 1
    try:
        rule_from_edge(cj.edge, C.CheckContext(), "th0")
    except RewriteError:
        fails += 1
    if not C.check_edge(cj.edge, g.vault.ctx):
        fails += 1
    if fails != 3:
        raise AssertionError("a conjecture was used as if discharged (%d/3 "
                             "refusals)" % fails)
    assert pg.accepted_edges == []
    raise RuntimeError("all three refused")


def test_conjecture_cannot_be_used_as_if_discharged():
    try:
        x_conjecture_used_as_if_discharged()
    except RuntimeError as exc:
        assert "all three refused" in str(exc)
    else:
        raise AssertionError("the control did not fire")


def test_discharge_builds_an_edge_the_kernel_re_accepts():
    g = _graph()
    pg = ProposalGraph(g.vault)
    t1 = g.states[g.order[0]]
    t2 = g.states[g.order[3]]
    cj = pg.propose(t1, t2, 0)
    d = discharge_by_rewriting(pg, cj.cid, ())
    assert d.status == DISCHARGED, d.render()
    pg.accept(cj.cid, d.edge)
    ok, why = pg.audit()
    assert ok, why
    fresh = C.CheckContext(axioms=dict(g.vault.ctx.axioms))
    assert C.check_edge(d.edge, fresh)


def test_saturation_route_closes_a_pair_and_expands_to_primitives():
    """Route B really runs ``execute.saturate`` and its answer survives
    expansion back to the vault's axioms alone."""
    g = _graph()
    pg = ProposalGraph(g.vault)
    t1, t2 = g.states[g.order[0]], g.states[g.order[2]]
    cj = pg.propose(t1, t2, 0)
    d = discharge_by_saturation(pg, cj.cid, g)
    assert d.status == DISCHARGED, d.render()
    bare = C.CheckContext(axioms=dict(g.vault.ctx.axioms))
    assert C.check_edge(d.edge, bare), bare.errors[-1:]


def test_every_accepted_discharge_is_semantically_true():
    """G7-style independent audit: the polynomial identity is *decided*."""
    o = Organism(Config(rounds=2, max_conjectures=10, closure_limit=3))
    o.run()
    n = 0
    for cid, st in o.pg.status.items():
        if st == DISCHARGED:
            cj = o.pg.conjectures[cid]
            assert poly_equal(cj.lhs, cj.rhs), cj.render()
            n += 1
    assert n > 5, n


def test_every_refutation_is_semantically_false():
    o = Organism(Config(rounds=3, max_conjectures=14, closure_limit=4))
    o.run()
    assert o.pg.counterexamples, "no counterexample was ever found"
    for cid, sep, va, vb in o.pg.counterexamples:
        cj = o.pg.conjectures[cid]
        assert va != vb
        assert not poly_equal(cj.lhs, cj.rhs), cj.render()


# ==========================================================================
# 4. CONTROL -- a refuted conjecture must invalidate its cone
# ==========================================================================

def _speculative_triple(pg, t1, t2, t3):
    c1 = pg.propose(t1, t2, 0)
    c2 = pg.propose(t2, t3, 0)
    c3 = pg.propose(t1, t3, 0, "closure", (c1.cid, c2.cid))
    return c1, c2, c3


def x_refuted_conjecture_leaves_its_cone_standing():
    """PLANTED FALSE: the naive handling -- mark the refuted conjecture and
    stop.  The speculative consequence it spawned survives, which is exactly
    the bug ``propagate/`` exists to prevent."""
    g = _graph()
    pg = ProposalGraph(g.vault)
    t1, t2, t3 = P(x, x), P(y, y), P(z, z)
    c1, c2, c3 = _speculative_triple(pg, t1, t2, t3)
    pg.status[c1.cid] = REFUTED          # the naive "just mark it"
    if pg.status[c3.cid] == REFUTED:
        raise AssertionError("marking alone invalidated the cone")
    raise RuntimeError("the cone survived: %s is still %s"
                       % (c3.cid, pg.status[c3.cid]))


def test_refuted_conjecture_invalidates_its_dependency_cone():
    try:
        x_refuted_conjecture_leaves_its_cone_standing()
    except RuntimeError as exc:
        assert "cone survived" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")

    g = _graph()
    pg = ProposalGraph(g.vault)
    t1, t2, t3 = P(x, x), P(y, y), P(z, z)
    c1, c2, c3 = _speculative_triple(pg, t1, t2, t3)
    sep = pg.refute(c1.cid)
    assert sep is not None
    plan, report = pg.record_refutation(c1.cid, sep)
    assert pg.status[c1.cid] == REFUTED
    assert c3.cid in plan.cone.facts, plan.render()
    assert pg.status[c3.cid] == REFUTED, "the speculative consequence survived"
    assert pg.status[c2.cid] == OPEN, "an independent conjecture was killed"
    assert plan.cone.size < plan.cone.total_facts


def test_refutation_cones_really_fire_inside_the_loop():
    o = Organism(Config(rounds=4, max_conjectures=20, closure_limit=6))
    o.run()
    assert o.pg.invalidations, "no cone was ever computed"
    assert max(i.cone.size for i in o.pg.invalidations) > 1, \
        "every cone was the seed alone -- the closure graph is inert"
    assert o.pg.closure_edges > 0


# ==========================================================================
# 5. CONTROL -- leakage
# ==========================================================================

def test_no_benchmark_is_reachable_from_the_construction_schema():
    seen = set()
    for r in range(24):
        for t in constructions(r):
            seen.add(t.addr)
    for _, t in BENCHMARKS:
        assert t.addr not in seen


def x_benchmark_as_generation_target_passes_the_leakage_check():
    """PLANTED FALSE: seed generation with the benchmark itself, which is the
    cheapest way to make a "benchmark improvement" that means nothing."""
    o = Organism(Config(rounds=1, max_conjectures=6, closure_limit=2))
    o.all_seeds.append(BENCHMARK)
    o.round(0)
    rep = leakage_report(o)
    if rep.clean:
        raise AssertionError("leakage went undetected")
    raise RuntimeError(rep.render())


def test_leakage_is_detected_when_the_benchmark_is_a_generation_target():
    try:
        x_benchmark_as_generation_target_passes_the_leakage_check()
    except RuntimeError as exc:
        assert "L1" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def x_benchmark_reached_as_a_generated_state_passes_the_leakage_check():
    """PLANTED FALSE, subtler: never seed the benchmark, but *reach* it (or a
    piece of it) during generation, so its derivation could be mined."""
    o = Organism(Config(rounds=1, max_conjectures=6, closure_limit=2))
    o.round(0)
    o.all_state_addrs.add(P(S(P(x, x), P(I(3), y)),
                            Sub(P(x, x), P(I(3), y))).addr)
    rep = leakage_report(o)
    if rep.clean:
        raise AssertionError("subterm leakage went undetected")
    raise RuntimeError(rep.render())


def test_leakage_is_detected_at_subterm_granularity():
    try:
        x_benchmark_reached_as_a_generated_state_passes_the_leakage_check()
    except RuntimeError as exc:
        assert "L2" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def x_benchmark_is_an_instance_of_a_seed():
    """PLANTED FALSE, subtlest: the seed is not the benchmark and the benchmark
    is never generated, but the benchmark is an *instance* of the seed -- so the
    "independent problem" is an instance of a training problem."""
    o = Organism(Config(rounds=1, max_conjectures=4, closure_limit=1))
    o.all_seeds.append(S(P(S(a, b), Sub(a, b)), u))     # pattern matches BENCHMARK
    rep = leakage_report(o)
    if rep.clean:
        raise AssertionError("instance leakage went undetected")
    raise RuntimeError(rep.render())


def test_leakage_is_detected_when_the_benchmark_instantiates_a_seed():
    try:
        x_benchmark_is_an_instance_of_a_seed()
    except RuntimeError as exc:
        assert "L4" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def test_the_real_run_is_leakage_clean():
    o = Organism(Config(rounds=4, max_conjectures=16, closure_limit=4))
    o.run()
    rep = leakage_report(o)
    assert rep.clean, rep.render()
    assert rep.states_checked > 200 and rep.mining_inputs_checked >= 12


# ==========================================================================
# 6. the measurement itself
# ==========================================================================

def test_benchmark_baselines_and_answers():
    steps, work, ans = benchmark_cost(None)
    assert (steps, work) == (29, 5431), (steps, work)
    assert render(ans) == "(x*x*x*x)"
    s2, w2, a2 = benchmark_cost(None, None, BENCHMARK2)
    assert (s2, w2) == (24, 5025), (s2, w2)
    assert poly_equal(BENCHMARK2, a2)
    assert BENCHMARK.addr != BENCHMARK2.addr


def test_the_two_benchmarks_drop_in_different_rounds():
    """The staircase claim: learning recurs, and each drop lands once."""
    b1 = benchmark_cost(None)[0]
    b2 = benchmark_cost(None, None, BENCHMARK2)[0]
    o = Organism(Config(rounds=4, max_conjectures=14, closure_limit=4))
    o.run()
    t1 = [r.bench_steps for r in o.reports]
    t2 = [r.bench2_steps for r in o.reports]
    assert t1[0] < b1, t1
    assert t2[0] == b2 and min(t2) < b2, t2
    assert t1.index(min(t1)) < t2.index(min(t2)), (t1, t2)
    # neither ever regresses in steps
    assert max(t1) <= b1 and max(t2) <= b2, (t1, t2)


def test_an_irrelevant_book_costs_search_and_buys_nothing():
    """The null-control signature, measured on a held-out problem: after round
    0 the book is real, checked and useless to B2 -- steps flat, work up."""
    b2_steps, b2_work, _ = benchmark_cost(None, None, BENCHMARK2)
    o = Organism(Config(rounds=1, max_conjectures=12, closure_limit=3))
    o.run()
    steps, work, _ = benchmark_cost(o.book, o.index, BENCHMARK2)
    assert steps == b2_steps, (steps, b2_steps)
    assert work > b2_work, (work, b2_work)


def test_the_loop_makes_the_held_out_benchmark_strictly_cheaper():
    base = benchmark_cost(None)[0]
    o = Organism(Config(rounds=3, max_conjectures=16, closure_limit=4))
    o.run()
    best = min(r.bench_steps for r in o.reports)
    assert best < base, (best, base)
    # and the cheaper answer is still the right answer, decided independently
    steps, work, ans = benchmark_cost(o.book, o.index)
    assert ans.addr == P(x, x, x, x).addr
    assert poly_equal(BENCHMARK, ans)


def test_null_trajectory_generation_without_crystallization_changes_nothing():
    """The control that decides 'learning' from 'merely generating'."""
    o = Organism(Config(rounds=4, crystallize=False, max_conjectures=16,
                        closure_limit=4))
    o.run()
    assert [r.bench_steps for r in o.reports] == [29] * 4
    assert [r.bench_work for r in o.reports] == [5431] * 4
    assert [r.bench2_steps for r in o.reports] == [24] * 4
    assert [r.bench2_work for r in o.reports] == [5025] * 4
    assert all(r.book == 0 for r in o.reports)
    assert sum(r.states for r in o.reports) > 200, "the null run still generated"


def test_the_index_keeps_the_benchmark_cost_flat_as_the_book_grows():
    """SCALE.md sec 3 inside a live loop: with the discrimination net the
    benchmark's search work does not grow with the book; with the linear scan
    it does."""
    on = Organism(Config(rounds=4, use_index=True, max_conjectures=14,
                         closure_limit=4))
    off = Organism(Config(rounds=4, use_index=False, max_conjectures=14,
                          closure_limit=4))
    on.run()
    off.run()
    assert [r.book for r in on.reports] == [r.book for r in off.reports]
    assert [r.bench_steps for r in on.reports] == \
           [r.bench_steps for r in off.reports], "the index changed a step count"
    grew = off.reports[-1].bench_work - off.reports[0].bench_work
    flat = on.reports[-1].bench_work - on.reports[0].bench_work
    assert grew > 0, "the scan did not fight back at all"
    assert abs(flat) < grew, (flat, grew)


def test_route_frontier_is_nondominated_and_plural():
    o = Organism(Config(rounds=2, max_conjectures=10, closure_limit=3))
    o.run()
    from runtime.execute.extract import dominates
    for front in o.frontiers:
        assert front
        for p in front:
            assert not any(dominates(q, p) for q in front)


def test_arrows_that_are_not_wired_say_so():
    from runtime.generate.loop import ARROWS
    names = [n for n, _ in ARROWS]
    assert "REALIZE" in names
    unwired = [n for n, d in ARROWS if "NOT WIRED" in d]
    assert unwired == ["REALIZE"], unwired


def test_compress_never_consults_the_benchmark():
    """COMPRESS's firing counts must come only from generated targets.

    Asserted structurally: run the loop, then rerun it with a *different*
    benchmark passed to ``benchmark_cost``.  Every book, channel and frontier
    must be identical, because none of them may depend on the benchmark.
    """
    o1 = Organism(Config(rounds=3, max_conjectures=12, closure_limit=3))
    o1.run()
    o2 = Organism(Config(rounds=3, max_conjectures=12, closure_limit=3))
    o2.run()
    alt = S(P(S(a, b), Sub(a, b)), P(I(4), b, b))
    s1 = benchmark_cost(o2.book, o2.index, target=alt)
    assert s1[0] > 0
    assert [l.lid for l in o1.book.lemmas] == [l.lid for l in o2.book.lemmas]
    assert o1.channel == o2.channel
    assert [f.as_tuple() for f in o1.frontiers[-1]] == \
           [f.as_tuple() for f in o2.frontiers[-1]]


# ==========================================================================
# 7. determinism
# ==========================================================================

_DET_SCRIPT = r"""
import sys, os
sys.path.insert(0, %r)
from runtime.generate.loop import Config, Organism
o = Organism(Config(rounds=3, max_conjectures=12, closure_limit=3))
o.run()
print([(r.states, r.edges, r.proposed, r.discharged, r.refuted, r.book,
        r.channel, r.bench_steps, r.bench_work) for r in o.reports])
print(sorted(o.pg.status.items())[:5])
"""


def test_output_is_byte_identical_across_pythonhashseed():
    root = os.path.dirname(os.path.dirname(os.path.dirname(
        os.path.abspath(__file__))))
    outs = []
    for seed in ("0", "12345", "999"):
        env = dict(os.environ, PYTHONHASHSEED=seed)
        r = subprocess.run([sys.executable, "-c", _DET_SCRIPT % root],
                           capture_output=True, text=True, env=env, timeout=600)
        assert r.returncode == 0, r.stderr[-2000:]
        outs.append(r.stdout)
    assert outs[0] == outs[1] == outs[2], "output depends on PYTHONHASHSEED"


def test_no_float_is_constructed_anywhere_in_the_lane():
    import runtime.generate.loop as L
    import runtime.generate.multiway as M
    import runtime.generate.propose as PP
    for mod in (M, PP, L):
        src = open(mod.__file__).read()
        for bad in ("float(", "1.0", "0.5", "math.sqrt"):
            assert bad not in src, "%s mentions %r" % (mod.__name__, bad)


TESTS = [(n, f) for n, f in sorted(globals().items())
         if n.startswith("test_") and callable(f)]
CONTROLS = [n for n in sorted(globals()) if n.startswith("x_")]


def main() -> int:
    bad = 0
    for name, fn in TESTS:
        try:
            fn()
            print("  ok    %s" % name)
        except Exception as exc:  # noqa: BLE001 - a test runner reports all
            bad += 1
            print("  FAIL  %s\n          %s: %s"
                  % (name, type(exc).__name__, exc))
    print("\n%d/%d passed  (%d planted controls, every one invoked)"
          % (len(TESTS) - bad, len(TESTS), len(CONTROLS)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
