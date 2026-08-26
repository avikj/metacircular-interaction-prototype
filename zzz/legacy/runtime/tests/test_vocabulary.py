#!/usr/bin/env python3
"""Adversarial tests for the vocabulary lane.

Run standalone:   python3 runtime/tests/test_vocabulary.py
or under pytest:  pytest runtime/tests/test_vocabulary.py

Every positive claim is paired with a planted control that must fail.  The four
the brief names explicitly are:

    x_non_conservative_definition_*        a "definition" whose equation
                                           constrains old symbols
    x_constructor_from_a_single_*          a shape claimed as "recurring" that
                                           occurs in one derivation
    x_extended_theorem_whose_unfolding_*   a theorem in the extended vocabulary
                                           whose unfolded form does not check
                                           in the base
    x_benchmark_leaked_through_a_*         a constructor cut from the
                                           benchmark's own derivation

Controls are named ``x_...`` rather than ``test_...`` and are *invoked* by the
matching ``test_...``, which asserts they fire.  A control that silently passes
is a test that has stopped testing anything.
"""

from __future__ import annotations

import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (I, P, PV, S, Sub, V,               # noqa: E402
                                            Counter, normalize, poly_equal)
from runtime.generate.loop import (BENCHMARK, BENCHMARK2, Config,              # noqa: E402
                                   GenerationBudget, Organism, benchmark_cost,
                                   constructions)
from runtime.kernel import check as C                                          # noqa: E402
from runtime.kernel.edges import Edge                                          # noqa: E402
from runtime.vocabulary.conservativity import (GATES, admissible, admit,       # noqa: E402
                                               base_answers_unchanged, unfolds)
from runtime.vocabulary.define import (Definition, Vocabulary,                 # noqa: E402
                                       VocabularyError, def_app, def_symbols,
                                       fold, is_base, is_def, kencode,
                                       require_base, unfold, unfold_edge,
                                       vrender)
from runtime.vocabulary.propose import (RANK_RULE, WITNESS_CAP,                # noqa: E402
                                        History, VocabConfig,
                                        VocabularyOrganism,
                                        abstract_variables, derivation_closure,
                                        null_pool_candidates,
                                        propose_from_quotients,
                                        propose_from_subterms, to_definition,
                                        vocab_leakage_report)

a, b, u, v, w, x, y, z = (V(n) for n in ("a", "b", "u", "v", "w", "x", "y", "z"))

SQR = Definition("sqr", 1, P(PV(0), PV(0)), provenance="test")
DSQ = Definition("dsq", 2, P(S(PV(0), PV(1)), Sub(PV(0), PV(1))),
                 provenance="test")

SMALL = Config(rounds=3, gen=GenerationBudget(max_states=50, max_edges=140,
                                              max_depth=3, max_size=20))
BENCH3 = (("B1", BENCHMARK), ("B2", BENCHMARK2))


def fresh(*defs) -> Vocabulary:
    voc = Vocabulary()
    for d in defs:
        inst = admit(voc, d)
        assert inst.ok, inst.render()
    return voc


# ==========================================================================
# 1. the substrate: a defined head is a real, distinct, inert head
# ==========================================================================

def test_defined_heads_are_hash_consed_injectively():
    """The constructor name lives in ``kind``, not ``val``.

    ``mk``'s encoding for a compound head is ``"<kind>|<child addrs>"`` and
    ignores ``val`` entirely, so a name kept in ``val`` would make ``sqr(x)``
    and ``cube(x)`` the same address.  That would let one constructor's
    unfolding be applied to another's instance.
    """
    s1, c1 = def_app("sqr", (x,)), def_app("cube", (x,))
    assert s1.addr != c1.addr
    assert s1.addr != S(x).addr and s1.addr != P(x).addr
    assert def_app("sqr", (x,)).addr == s1.addr          # interned
    assert def_app("sqr", (y,)).addr != s1.addr
    assert def_symbols(P(s1, c1)) == ("sqr", "cube")


def test_no_primitive_rule_fires_on_a_defined_node():
    from runtime.crystallize.derivation import RULES
    node = def_app("sqr", (S(x, I(0)),))
    assert all(fn(node) is None for _, fn in RULES)


def test_a_defined_term_is_not_base_and_the_guard_says_so():
    t = def_app("sqr", (x,))
    assert not is_base(t) and is_def(t)
    assert is_base(P(x, x))
    try:
        require_base(t, "test")
    except VocabularyError as exc:
        assert "sqr" in str(exc)
    else:
        raise AssertionError("require_base accepted a defined term")


def x_defined_term_reaches_the_base_semantics_unguarded():
    """PLANTED FALSE: hand ``poly_equal`` a defined term.

    ``evaluate`` treats every unknown compound head as a product, so it will
    happily decide ``sqr(x) == x*x`` -- *by accident*, because ``sqr``'s single
    argument makes the bogus product read as ``x``.  It gets the answer wrong,
    confidently, in both directions depending on the definition.  This is why
    ``require_base`` exists and why every crossing goes through it.
    """
    from runtime.crystallize.derivation import evaluate
    bogus = def_app("half", (x, y))                # "half(x,y)" := x, say
    got = evaluate(bogus, {"x": 3, "y": 5})
    if got == 3:
        raise AssertionError("the base engine understood a defined head")
    raise RuntimeError("base evaluate read half(x,y) as a product: %d" % got)


def test_the_base_engine_would_get_defined_terms_wrong_which_is_why_it_never_sees_one():
    try:
        x_defined_term_reaches_the_base_semantics_unguarded()
    except RuntimeError as exc:
        assert "product" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


# ==========================================================================
# 2. definitional extension
# ==========================================================================

def test_a_definition_is_admitted_and_its_equation_is_kernel_checked():
    voc = Vocabulary()
    inst = admit(voc, SQR)
    assert inst.ok and inst.edge is not None
    assert inst.edge.kind == "Eq"
    assert C.check_edge(inst.edge, voc.ctx)
    assert [g for g, _ in inst.report.gates] == [g for g, _ in GATES]
    assert all(ok for _, ok in inst.report.gates)


def test_unfolding_terminates_reaches_base_and_is_kernel_checked():
    voc = fresh(SQR, DSQ)
    gap = Definition("gap", 2, S(def_app("sqr", (PV(0),)),
                                 P(I(-1), def_app("sqr", (PV(1),)))),
                     provenance="test")
    assert admit(voc, gap).ok
    t = gap.head(S(x, I(3)), y)
    ctr = Counter()
    out = unfold(t, voc, ctr)
    assert is_base(out) and ctr.steps == 3
    assert out.addr == S(P(S(x, I(3)), S(x, I(3))), P(I(-1), P(y, y))).addr
    e = unfold_edge(t, voc)
    assert e.kind == "Eq" and C.check_edge(e, voc.ctx)
    assert len(e.witness) == 3


def test_fold_and_unfold_are_inverse_up_to_the_base_term():
    voc = fresh(SQR, DSQ)
    base = P(S(x, y), Sub(x, y))
    folded = fold(base, voc)
    assert is_def(folded) and vrender(folded) == "dsq(x, y)"
    assert unfold(folded, voc).addr == base.addr


def test_the_extension_is_conservative_on_a_true_extended_theorem():
    voc = fresh(SQR, DSQ)
    lhs = DSQ.head(x, y)
    rhs = S(def_app("sqr", (x,)), P(I(-1), def_app("sqr", (y,))))
    rep = unfolds(lhs, rhs, voc, label="dsq = sqr - sqr")
    assert rep.ok, rep.reason
    assert rep.unfold_steps == 3 and rep.base_steps > 0
    assert rep.semantic is True


def test_base_answers_are_unchanged_by_any_extension():
    voc = fresh(SQR, DSQ)
    probes = [BENCHMARK, BENCHMARK2, P(S(x, y), Sub(x, y)), S(P(x, x), I(3))]
    rep = base_answers_unchanged(probes, voc)
    assert rep.ok and rep.checked == len(probes)


# ==========================================================================
# 3. the planted non-definitions
# ==========================================================================

def x_non_conservative_definition_constrains_old_symbols():
    """PLANTED FALSE: ``x*y := x+y``.

    It has a fresh name attached and it looks like a definition, but its
    left-hand side is a term of the OLD language, so the equation constrains
    ``*`` and ``+``.  Admitting it would prove ``2*3 = 2+3`` in the base
    vocabulary, which is exactly the theorem a definitional extension may not
    add.  D3 is the gate.
    """
    voc = fresh(SQR)
    bad = Definition("bad", 2, S(PV(0), PV(1)), raw_lhs=P(PV(0), PV(1)))
    inst = admit(voc, bad)
    if inst.ok:
        raise AssertionError("a non-conservative definition was admitted")
    if len(voc) != 1 or any("bad" in k for k in voc.ctx.axioms):
        raise AssertionError("a refused definition still declared an axiom")
    raise RuntimeError(inst.report.render())


def test_a_non_conservative_definition_is_refused_by_D3():
    try:
        x_non_conservative_definition_constrains_old_symbols()
    except RuntimeError as exc:
        assert "D3" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")
    # and the equation it wanted really is false in the base, so this is not a
    # pedantic refusal
    assert not poly_equal(P(x, y), S(x, y))


def x_recursive_definition_is_admitted():
    """PLANTED FALSE: ``r(#0) := r(#0) * #0`` -- not eliminable."""
    voc = Vocabulary()
    bad = Definition("r", 1, P(def_app("r", (PV(0),)), PV(0)))
    inst = admit(voc, bad)
    if inst.ok:
        raise AssertionError("a recursive definition was admitted")
    raise RuntimeError(inst.report.render())


def test_a_recursive_definition_is_refused_by_D4():
    try:
        x_recursive_definition_is_admitted()
    except RuntimeError as exc:
        assert "D4" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def x_definition_with_a_side_equation_is_admitted():
    """PLANTED FALSE: a definition that also asserts ``x*y = x+y``."""
    voc = Vocabulary()
    bad = Definition("sneak", 1, P(PV(0), PV(0)),
                     extra_axioms=((P(x, y), S(x, y)),))
    inst = admit(voc, bad)
    if inst.ok:
        raise AssertionError("a definition with a side equation was admitted")
    raise RuntimeError(inst.report.render())


def test_a_definition_may_not_carry_side_equations_D7():
    try:
        x_definition_with_a_side_equation_is_admitted()
    except RuntimeError as exc:
        assert "D7" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def test_a_free_parameter_in_the_body_is_refused_by_D5():
    voc = Vocabulary()
    inst = admit(voc, Definition("f", 1, S(PV(0), PV(1))))
    assert not inst.ok
    assert "D5" in [r.gate for r in inst.report.refusals]


def test_a_redefinition_is_refused_by_D1():
    voc = fresh(SQR)
    inst = admit(voc, Definition("sqr", 1, S(PV(0), PV(0))))
    assert not inst.ok
    assert "D1" in [r.gate for r in inst.report.refusals]
    assert len(voc) == 1


def x_forged_defining_edge_with_an_undeclared_axiom():
    """PLANTED FALSE: an ``Eq`` edge asserting a definition nobody declared."""
    ctx = C.CheckContext()
    lhs, rhs = def_app("ghost", (x,)), P(x, x)
    path = (C.Step(src=kencode(lhs).addr, dst=kencode(rhs).addr,
                   kind="assumption", witness=C.Axiom("def|ghost/1|forged")),)
    e = Edge(kind="Eq", src=kencode(lhs).addr, dst=kencode(rhs).addr,
             witness=path)
    if C.check_edge(e, ctx):
        raise AssertionError("the kernel accepted a forged defining equation")
    raise RuntimeError(ctx.errors[-1])


def test_a_forged_defining_equation_is_refused_by_the_kernel():
    try:
        x_forged_defining_edge_with_an_undeclared_axiom()
    except RuntimeError as exc:
        assert "undeclared axiom" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


# ==========================================================================
# 4. the unfolding check, and the theorem that fails it
# ==========================================================================

def x_extended_theorem_whose_unfolding_does_not_check():
    """PLANTED FALSE: claim ``sqr(x) = x*x*x`` in the extended vocabulary.

    Nothing about the *statement* is malformed and nothing about the
    *definition* is wrong.  It is caught only by doing the conservativity
    argument: unfold and re-check in the base, where the two sides normalise
    to different terms and ``poly_equal`` decides them different.
    """
    voc = fresh(SQR)
    rep = unfolds(SQR.head(x), P(x, x, x), voc, label="x_bad")
    if rep.ok:
        raise AssertionError("an unsound extended theorem passed elimination")
    raise RuntimeError(rep.reason)


def test_an_extended_theorem_that_does_not_unfold_is_refused():
    try:
        x_extended_theorem_whose_unfolding_does_not_check()
    except RuntimeError as exc:
        assert "normal forms" in str(exc) or "polynomials" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def x_unfolding_against_a_vocabulary_that_does_not_define_the_symbol():
    voc = fresh(SQR)
    try:
        unfold(def_app("nope", (x,)), voc)
    except VocabularyError as exc:
        raise RuntimeError(str(exc))
    raise AssertionError("unfolded a symbol that is not defined")


def test_unfolding_an_undefined_symbol_raises_rather_than_guessing():
    try:
        x_unfolding_against_a_vocabulary_that_does_not_define_the_symbol()
    except RuntimeError as exc:
        assert "undefined constructor" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


# ==========================================================================
# 5. proposal
# ==========================================================================

def _history_from(rounds: int = 3) -> VocabularyOrganism:
    o = VocabularyOrganism(SMALL, VocabConfig(mode="fixed"))
    for r in range(rounds):
        o.round(r)
    return o


def test_abstract_variables_collapses_repeats_onto_one_parameter():
    shape, ar = abstract_variables(P(S(x, y), Sub(x, y)))
    assert ar == 2
    assert shape.addr == P(S(PV(0), PV(1)), Sub(PV(0), PV(1))).addr
    # integers stay concrete: 3*y and 5*y are different objects
    s3, _ = abstract_variables(P(I(3), y))
    s5, _ = abstract_variables(P(I(5), y))
    assert s3.addr != s5.addr


def test_the_ranking_rule_is_the_stated_formula_and_the_order_is_total():
    o = _history_from()
    cands = propose_from_subterms(o.history)
    assert cands, "no candidate proposed from a three-round history"
    for c in cands:
        assert c.score == c.freq * c.spread * (c.size - 1), RANK_RULE
    keys = [(-c.score, c.body.ckey) for c in cands]
    assert keys == sorted(keys), "the ranking is not the stated order"
    again = propose_from_subterms(o.history)
    assert [c.body.addr for c in again] == [c.body.addr for c in cands]


def x_constructor_from_a_single_derivation_is_proposed():
    """PLANTED FALSE: a shape that occurs many times but in ONE derivation,
    claimed as "recurring".  Frequency without spread is one runaway
    derivation talking to itself."""
    h = History()
    shape = P(S(x, y), Sub(x, y))
    h.add_terms("only-one", [shape, S(shape, shape), P(shape, I(2))])
    got = propose_from_subterms(h, min_spread=3)
    hit = [c for c in got if c.body.addr ==
           P(S(PV(0), PV(1)), Sub(PV(0), PV(1))).addr]
    if hit:
        raise AssertionError("a single-derivation shape was proposed as "
                             "recurring (spread %d)" % hit[0].spread)
    raise RuntimeError("spread floor held: %d candidate(s) from one record"
                       % len(got))


def test_a_shape_seen_in_one_derivation_is_not_recurring():
    try:
        x_constructor_from_a_single_derivation_is_proposed()
    except RuntimeError as exc:
        assert "spread floor held" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")
    # ... and the same shape IS proposed once three independent records show it
    h = History()
    shape = P(S(x, y), Sub(x, y))
    for i in range(3):
        h.add_terms("rec-%d" % i, [shape, S(shape, I(i))])
    got = propose_from_subterms(h, min_spread=3)
    assert any(c.body.addr == P(S(PV(0), PV(1)), Sub(PV(0), PV(1))).addr
               for c in got)


def test_quotient_proposals_come_only_from_discharged_conjectures():
    o = _history_from()
    assert o.history.quotients, "no proved identification in three rounds"
    from runtime.generate.propose import DISCHARGED
    proved = {(l.addr, r.addr) for _, l, r in o.history.quotients}
    for cid in o.pg.order:
        cj = o.pg.conjectures[cid]
        if (cj.lhs.addr, cj.rhs.addr) in proved:
            assert o.pg.status[cid] == DISCHARGED
    cands = propose_from_quotients(o.history)
    assert all(c.provenance == "quotient" for c in cands)


def test_the_null_pool_is_disjoint_from_the_history_and_labelled():
    o = _history_from()
    nulls = null_pool_candidates(o.history)
    assert nulls
    shapes = set()
    for src in o.history.order:
        for t in o.history.terms[src]:
            shapes.add(abstract_variables(t)[0].addr)
    assert all(c.body.addr not in shapes for c in nulls)
    assert all(c.provenance == "null-pool" and c.score == 0 for c in nulls)


def x_null_pool_candidate_that_actually_occurs_in_the_history():
    """PLANTED FALSE: put a null-pool shape into the history and demand the
    pool still call it disjoint."""
    from runtime.vocabulary.propose import _NULL_CONSTS, _NULL_SHAPES
    from runtime.crystallize.derivation import subst
    body = _NULL_SHAPES[0](_NULL_CONSTS[0])
    h = History()
    concrete = subst(body, {"#0": x, "#1": y})
    h.add_terms("planted", [concrete, S(concrete, I(1))])
    got = null_pool_candidates(h)
    if any(c.body.addr == body.addr for c in got):
        raise AssertionError("the null pool offered a shape the loop had built")
    raise RuntimeError("disjointness enforced: %d/%d survived"
                       % (len(got), len(null_pool_candidates())))


def test_the_null_pool_drops_anything_the_loop_actually_built():
    try:
        x_null_pool_candidate_that_actually_occurs_in_the_history()
    except RuntimeError as exc:
        assert "disjointness enforced" in str(exc), exc
    else:
        raise AssertionError("the control did not fire")


def test_P1_refuses_to_rename_syntax_the_substrate_already_has():
    h = History()
    for i in range(4):
        h.add_terms("r-%d" % i, [Sub(x, y), S(Sub(x, y), I(i)), S(x, y, I(i))])
    got = propose_from_subterms(h, min_spread=3, min_size=3)
    forbidden = {Sub(PV(0), PV(1)).addr, S(PV(0), PV(1)).addr,
                 P(PV(0), PV(1)).addr, S(PV(0), PV(1), PV(2)).addr}
    assert all(c.body.addr not in forbidden for c in got), \
        "a constructor renamed the substrate's own syntax"


# ==========================================================================
# 6. the organism
# ==========================================================================

def test_fixed_mode_is_the_unmodified_loop_step_for_step():
    plain = Organism(SMALL)
    plain.run(3)
    voc = VocabularyOrganism(SMALL, VocabConfig(mode="fixed"))
    voc.run(3)
    assert plain.trajectory() == voc.trajectory()
    assert plain.trajectory(2) == voc.trajectory(2)
    assert [r.row() for r in plain.reports] == [r.row() for r in voc.reports]
    assert len(voc.vocab) == 0
    # and the module-level schema is restored
    import runtime.generate.loop as L
    assert L.constructions is constructions


def test_self_mode_installs_constructors_and_stays_conservative():
    o = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    o.run(3)
    assert len(o.vocab) >= 1
    assert all(d.provenance in ("subterm", "quotient")
               for d in o.vocab.definitions)
    ok, rows = o.conservativity_audit()
    assert ok, [r.reason for r in rows if not r.ok]
    assert rows and all(r.ok for r in rows)
    for e in o.vocab.edges:
        assert C.check_edge(e, o.vocab.ctx)


def test_a_constructor_never_enters_a_base_query():
    """The benchmark is solved in the base vocabulary, always.

    This is the operational content of conservativity: the extended vocabulary
    is not merely *provably* harmless, it is structurally absent from every
    measurement.
    """
    o = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    o.run(3)
    steps, work, ans = benchmark_cost(o.book, o.index, BENCHMARK)
    d, _ = normalize(BENCHMARK, lemmas=tuple(o.book.lemmas), ctr=Counter(),
                     index=o.index)
    assert all(is_base(st.after) for st in d.steps)
    assert is_base(ans)
    for lem in o.book.lemmas:
        assert is_base(lem.lhs) and is_base(lem.rhs)


def test_null_mode_matches_the_symbol_count_and_nothing_else():
    s = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    s.run(3)
    n = VocabularyOrganism(SMALL, VocabConfig(mode="null"))
    n.run(3)
    assert len(n.vocab) == len(s.vocab), "the control is not count-matched"
    assert all(d.provenance == "null-pool" for d in n.vocab.definitions)
    assert {d.body.addr for d in n.vocab.definitions} \
        .isdisjoint({d.body.addr for d in s.vocab.definitions})


def test_the_vocabulary_lane_charges_itself_for_its_own_search():
    o = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    o.run(3)
    assert all(v.vocab_work > 0 for v in o.vreports)
    assert o.vreports[-1].vocab_work > o.vreports[0].vocab_work, \
        "the proposal step's cost is not growing with the history it re-walks"


# ==========================================================================
# 7. leakage
# ==========================================================================

def test_a_legitimate_run_leaks_nothing_on_B1_and_B2():
    o = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    o.run(3)
    rep = vocab_leakage_report(o, BENCH3)
    assert rep.definitions_checked == len(o.vocab)
    assert rep.clean, rep.render()


def x_benchmark_leaked_through_a_constructor():
    """PLANTED FALSE, and it is the subtle one.

    Feed the benchmark's own normalisation trajectory to the miner as if it
    were three independent derivation records, then propose in the ordinary
    way.  Nothing is forged: the constructors really are recurring shapes of
    the recorded history.  The history is the cheat.
    """
    o = VocabularyOrganism(SMALL, VocabConfig(mode="self"))
    d, _ = normalize(BENCHMARK, ctr=Counter(), name="poison")
    trail = [BENCHMARK] + [st.after for st in d.steps]
    for i in range(3):
        o.history.add_terms("poisoned-%d" % i, trail)
    installed = 0
    for c in propose_from_subterms(o.history, min_spread=3)[:6]:
        if admit(o.vocab, to_definition("p%d" % installed, c)).ok:
            installed += 1
    rep = vocab_leakage_report(o, BENCH3)
    if rep.clean:
        raise AssertionError("a constructor cut from the benchmark's own "
                             "derivation was not detected (%d installed)"
                             % installed)
    raise RuntimeError(" | ".join(rep.findings[:4]))


def test_a_constructor_that_leaked_the_benchmark_is_caught():
    try:
        x_benchmark_leaked_through_a_constructor()
    except RuntimeError as exc:
        msg = str(exc)
        assert "V5" in msg or "V6" in msg, msg
    else:
        raise AssertionError("the control did not fire")


def test_the_derivation_closure_is_what_V6_checks_against():
    cl = derivation_closure(BENCHMARK)
    assert BENCHMARK.addr in cl
    d, _ = normalize(BENCHMARK, ctr=Counter())
    assert d.result.addr in cl
    assert P(V("q9"), V("q9")).addr not in cl


def test_V5_exempts_the_declared_control_and_only_the_declared_control():
    n = VocabularyOrganism(SMALL, VocabConfig(mode="null"))
    n.run(3)
    rep = vocab_leakage_report(n, BENCH3)
    assert rep.clean, rep.render()
    # relabel the same definitions as if they claimed loop provenance
    from dataclasses import replace
    n.vocab.definitions = [replace(d, provenance="subterm")
                           for d in n.vocab.definitions]
    n.vocab.by_name = {d.name: d for d in n.vocab.definitions}
    rep2 = vocab_leakage_report(n, BENCH3)
    assert not rep2.clean
    assert any(f.startswith("V5") for f in rep2.findings)


# ==========================================================================
# 8. determinism and exactness
# ==========================================================================

_DET_SCRIPT = """
import sys
sys.path.insert(0, %r)
from runtime.generate.loop import Config, GenerationBudget
from runtime.vocabulary.propose import (VocabConfig, VocabularyOrganism,
                                        propose_from_subterms)
cfg = Config(rounds=3, gen=GenerationBudget(max_states=50, max_edges=140,
                                            max_depth=3, max_size=20))
o = VocabularyOrganism(cfg, VocabConfig(mode="self"))
o.run(3)
print(o.vocab.fingerprint())
print([v.row() for v in o.vreports])
print([r.render() for r in o.unfold_reports])
print([c.render() for c in propose_from_subterms(o.history)[:8]])
"""


def test_output_is_byte_identical_across_pythonhashseed():
    root = os.path.dirname(os.path.dirname(os.path.dirname(
        os.path.abspath(__file__))))
    outs = []
    for seed in ("0", "12345", "999"):
        env = dict(os.environ, PYTHONHASHSEED=seed)
        r = subprocess.run([sys.executable, "-c", _DET_SCRIPT % root],
                           capture_output=True, text=True, env=env, timeout=900)
        assert r.returncode == 0, r.stderr[-2000:]
        outs.append(r.stdout)
    assert outs[0] == outs[1] == outs[2], "output depends on PYTHONHASHSEED"


def test_no_float_is_constructed_anywhere_in_the_lane():
    import runtime.vocabulary.conservativity as CO
    import runtime.vocabulary.define as DE
    import runtime.vocabulary.propose as PR
    for mod in (DE, CO, PR):
        src = open(mod.__file__).read()
        # ``propose.py`` says the words "a random new symbol" in prose, to
        # record that it is the one source deliberately NOT implemented, so
        # the check is for the module rather than for the word.
        for bad in ("float(", "1.0", "0.5", "math.sqrt", "import random",
                    "random.", "time.time"):
            assert bad not in src, "%s mentions %r" % (mod.__name__, bad)


def test_the_witness_cap_is_stated_and_generous():
    assert WITNESS_CAP >= 32
    o = _history_from()
    for c in propose_from_subterms(o.history):
        assert len(c.witnesses) <= WITNESS_CAP


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
