#!/usr/bin/env python3
"""Tests for the mathematical-runtime kernel.

The load-bearing test is `test_group_completion_is_the_known_system`: the
runtime is pointed at a theory whose completed form is known independently
from the literature, and must reproduce it. A runtime that invents
plausible-looking rules is worse than useless, so the check is against an
external answer, not against its own output.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import (  # noqa: E402
    LPO,
    Completion,
    critical_pairs,
    match,
    mk,
    normalize,
    rename,
    Rule,
    search_equal,
    subst,
    unify,
    var,
    variables,
)

E = mk("e")
x, y, z = var("x"), var("y"), var("z")
a, b, c = mk("a"), mk("b"), mk("c")


def op(p, q):
    return mk("*", p, q)


def inv(p):
    return mk("i", p)


GROUP = [
    ("assoc", op(op(x, y), z), op(x, op(y, z))),
    ("left-identity", op(E, x), x),
    ("left-inverse", op(inv(x), x), E),
]


class TestTerms(unittest.TestCase):
    def test_hash_consing_gives_identity(self):
        self.assertIs(op(a, b), op(a, b))
        self.assertIsNot(op(a, b), op(b, a))

    def test_address_is_a_function_of_structure_only(self):
        self.assertEqual(op(a, b).addr, op(a, b).addr)
        self.assertNotEqual(op(a, b).addr, op(b, a).addr)

    def test_address_is_stable_across_construction_order(self):
        first = inv(op(a, b)).addr
        _ = op(b, a), inv(b), op(inv(b), inv(a))
        self.assertEqual(inv(op(a, b)).addr, first)

    def test_size_and_variables(self):
        self.assertEqual(op(x, inv(y)).size, 4)
        self.assertEqual(variables(op(x, inv(y))), {"?x", "?y"})

    def test_rename_avoids_capture(self):
        r = rename(op(x, y), "_1")
        self.assertEqual(variables(r), {"?x_1", "?y_1"})


class TestMatching(unittest.TestCase):
    def test_match_binds_consistently(self):
        s = match(op(x, x), op(a, a))
        self.assertIsNotNone(s)
        self.assertIs(s["?x"], a)
        self.assertIsNone(match(op(x, x), op(a, b)))

    def test_match_is_one_way(self):
        self.assertIsNotNone(match(x, op(a, b)))
        self.assertIsNone(match(op(a, b), x))

    def test_subst_roundtrip(self):
        self.assertIs(subst(op(x, y), {"?x": a, "?y": b}), op(a, b))

    def test_unify_is_symmetric_where_matching_is_not(self):
        self.assertIsNotNone(unify(op(a, b), x, {}))
        self.assertIsNotNone(unify(x, op(a, b), {}))

    def test_occurs_check(self):
        self.assertIsNone(unify(x, op(a, x), {}))


class TestOrder(unittest.TestCase):
    def setUp(self):
        self.o = LPO(["i", "*", "e"])

    def test_strict(self):
        self.assertFalse(self.o.gt(a, a))

    def test_subterm_property(self):
        self.assertTrue(self.o.gt(op(a, b), a))
        self.assertFalse(self.o.gt(a, op(a, b)))

    def test_precedence(self):
        self.assertTrue(self.o.gt(inv(a), op(a, a)) or self.o.gt(op(a, a), inv(a)))

    def test_orients_the_group_axioms(self):
        for _, l, r in GROUP:
            self.assertTrue(self.o.gt(l, r), f"{l!r} should exceed {r!r}")

    def test_antisymmetry_on_a_sample(self):
        terms = [a, b, E, inv(a), op(a, b), op(inv(a), b), inv(op(a, b))]
        for s in terms:
            for t in terms:
                if s is not t:
                    self.assertFalse(self.o.gt(s, t) and self.o.gt(t, s))


class TestRewriting(unittest.TestCase):
    def test_normalize_reaches_a_fixed_point(self):
        rules = [Rule(op(E, x), x, 1, ("axiom", "u"))]
        nf, steps = normalize(op(E, op(E, a)), rules)
        self.assertIs(nf, a)
        self.assertEqual(steps, 2)

    def test_normalize_is_idempotent(self):
        rules = [Rule(op(E, x), x, 1, ("axiom", "u"))]
        nf, _ = normalize(op(E, a), rules)
        again, steps = normalize(nf, rules)
        self.assertIs(again, nf)
        self.assertEqual(steps, 0)


class TestCriticalPairs(unittest.TestCase):
    def test_no_pair_from_a_rule_with_itself_at_the_root(self):
        r = Rule(op(E, x), x, 1, ("axiom", "u"))
        self.assertEqual(list(critical_pairs(r, r)), [])

    def test_overlap_is_found_and_carries_its_origin(self):
        r1 = Rule(op(inv(x), x), E, 1, ("axiom", "li"))
        r2 = Rule(op(op(x, y), z), op(x, op(y, z)), 2, ("axiom", "assoc"))
        pairs = list(critical_pairs(r2, r1))
        self.assertTrue(pairs)
        for _, _, origin in pairs:
            self.assertEqual(origin[0], "critical-pair")
            self.assertEqual((origin[1], origin[3]), (2, 1))


class TestCompletion(unittest.TestCase):
    """The external-answer tests. These are what make the runtime checkable."""

    def setUp(self):
        self.comp = Completion(LPO(["i", "*", "e"]))
        self.rules = self.comp.run(GROUP)

    def test_group_completion_is_the_known_system(self):
        # Knuth-Bendix (1970): the minimal left-axiom presentation of group
        # theory completes to a canonical system of exactly ten rules.
        self.assertEqual(len(self.rules), 10)

    def test_it_derives_the_theorems_that_were_not_assumed(self):
        got = {(r.lhs, r.rhs) for r in self.rules}
        for lhs, rhs in [
            (op(x, E), x),                       # right identity
            (op(x, inv(x)), E),                  # right inverse
            (inv(inv(x)), x),                    # double inverse
            (inv(E), E),                         # inverse of the identity
            (inv(op(x, y)), op(inv(y), inv(x))), # anti-automorphism
        ]:
            self.assertTrue(
                any(match(l, subst(lhs, {v: a for v in variables(lhs)})) is not None
                    and match(r, subst(rhs, {v: a for v in variables(rhs)})) is not None
                    for l, r in got)
                or self.comp.decides(subst(lhs, {"?x": a, "?y": b}),
                                     subst(rhs, {"?x": a, "?y": b}))[0],
                f"runtime failed to derive {lhs!r} = {rhs!r}",
            )

    def test_every_derived_rule_carries_a_derivation(self):
        for r in self.rules:
            self.assertIn(r.origin[0], {"axiom", "critical-pair", "interreduce"})
            if r.origin[0] == "critical-pair":
                self.assertEqual(len(r.origin), 4)

    def test_the_system_is_confluent_no_pair_survives(self):
        for r1 in self.rules:
            for r2 in self.rules:
                for l, r, _ in critical_pairs(r1, r2):
                    ln, _ = normalize(l, self.rules)
                    rn, _ = normalize(r, self.rules)
                    self.assertIs(ln, rn, f"unjoinable pair: {l!r} vs {r!r}")

    def test_it_decides_independent_identities(self):
        for l, r in [
            (op(a, inv(a)), E),
            (inv(inv(inv(a))), inv(a)),
            (inv(op(a, op(b, c))), op(inv(c), op(inv(b), inv(a)))),
            (op(op(a, b), op(inv(b), inv(a))), E),
            (op(inv(a), op(a, b)), b),
        ]:
            ok, _ = self.comp.decides(l, r)
            self.assertTrue(ok, f"failed to decide {l!r} = {r!r}")

    def test_it_refutes_what_is_false_in_a_general_group(self):
        # Commutativity is not a group theorem; the runtime must not
        # "decide" it. This is the proves-too-much control.
        ok, _ = self.comp.decides(op(a, b), op(b, a))
        self.assertFalse(ok)
        ok, _ = self.comp.decides(inv(op(a, b)), op(inv(a), inv(b)))
        self.assertFalse(ok)


class TestTheLedgerClaim(unittest.TestCase):
    """The runtime's one substantive claim, tested rather than asserted."""

    def test_compilation_makes_an_independent_problem_cheaper(self):
        goal_l, goal_r = inv(op(a, b)), op(inv(b), inv(a))

        _, before = search_equal(goal_l, goal_r, GROUP, max_nodes=20_000)
        comp = Completion(LPO(["i", "*", "e"]))
        comp.run(GROUP)
        ok, after = comp.decides(goal_l, goal_r)

        self.assertTrue(ok)
        self.assertLess(after, before / 100)

    def test_search_finds_what_is_reachable_and_reports_what_is_not(self):
        proved, _ = search_equal(op(E, op(E, a)), a, GROUP, max_nodes=5_000)
        self.assertTrue(proved)
        # search is sound: it must not "prove" a non-theorem
        proved, _ = search_equal(op(a, b), op(b, a), GROUP, max_nodes=5_000)
        self.assertFalse(proved)


class TestTransport(unittest.TestCase):
    """The second edge type: interpretations between theories."""

    def setUp(self):
        from machinery.crystal.transport import Interpretation, arg

        self.Interp, self.arg = Interpretation, arg
        self.left_zero = [
            ("assoc", op(op(x, y), z), op(x, op(y, z))),
            ("left-zero", op(x, y), x),
        ]
        self.right_zero = [
            ("assoc", op(op(x, y), z), op(x, op(y, z))),
            ("right-zero", op(x, y), y),
        ]
        self.target = Completion(LPO(["*"]))
        self.target.run(self.left_zero)

    def _map(self, reversing: bool):
        cl = mk("*", self.arg(1), self.arg(0)) if reversing \
            else mk("*", self.arg(0), self.arg(1))
        return self.Interp("m", {("*", 2): cl}, self.right_zero, self.target)

    def test_a_mistyped_map_is_rejected(self):
        m = self._map(reversing=False)
        self.assertFalse(m.check())
        self.assertTrue(m.failures)

    def test_a_rejected_map_cannot_be_used(self):
        m = self._map(reversing=False)
        m.check()
        with self.assertRaises(RuntimeError):
            m.decides(op(a, b), b)

    def test_an_unchecked_map_cannot_be_used(self):
        with self.assertRaises(RuntimeError):
            self._map(reversing=True).decides(op(a, b), b)

    def test_the_anti_isomorphism_is_accepted(self):
        self.assertTrue(self._map(reversing=True).check())

    def test_transport_decides_the_uncompiled_theory(self):
        m = self._map(reversing=True)
        m.check()
        for l, r in [(op(a, b), b),
                     (op(op(a, b), c), c),
                     (op(a, op(b, c)), c),
                     (op(op(op(a, b), c), a), a)]:
            self.assertTrue(m.decides(l, r)[0], f"failed on {l!r} = {r!r}")

    def test_transport_refuses_what_is_false_in_the_source(self):
        m = self._map(reversing=True)
        m.check()
        for l, r in [(op(a, b), a), (op(op(a, b), c), a)]:
            self.assertFalse(m.decides(l, r)[0], f"wrongly decided {l!r} = {r!r}")

    def test_translation_is_homomorphic_and_reverses(self):
        m = self._map(reversing=True)
        self.assertIs(m.apply(op(a, b)), op(b, a))
        self.assertIs(m.apply(op(op(a, b), c)), op(c, op(b, a)))

    def test_group_theory_is_self_dual_so_both_maps_check(self):
        # Recorded because it broke the first version of the transport
        # demo. Groups are self-dual: the completed left-axiom theory
        # proves the right-axiom ones, so the identity map is a genuine
        # interpretation and the reversal is not needed. The kernel
        # accepting it was correct; the test that called it a bug was not.
        E = mk("e")

        def inv(p):
            return mk("i", p)

        target = Completion(LPO(["i", "*", "e"]))
        target.run(GROUP)
        right_axioms = [
            ("assoc", op(op(x, y), z), op(x, op(y, z))),
            ("right-identity", op(x, E), x),
            ("right-inverse", op(x, inv(x)), E),
        ]
        for reversing in (False, True):
            cl = mk("*", self.arg(1), self.arg(0)) if reversing \
                else mk("*", self.arg(0), self.arg(1))
            m = self.Interp("g", {("*", 2): cl, ("i", 1): mk("i", self.arg(0)),
                                  ("e", 0): E}, right_axioms, target)
            self.assertTrue(m.check(), f"reversing={reversing} should check")


class TestObstruction(unittest.TestCase):
    """Failed transports must be kept and classified, not discarded."""

    def setUp(self):
        from machinery.crystal.obstruction import Verdict, obstruction_of
        from machinery.crystal.transport import Interpretation, arg

        self.V, self.obs_of, self.Interp, self.arg = (
            Verdict, obstruction_of, Interpretation, arg)
        self.order = LPO(["*", "e"])
        self.assoc = ("assoc", op(op(x, y), z), op(x, op(y, z)))
        self.E = mk("e")

    #: pointed semigroups: `e` is in the signature, unconstrained by axioms
    POINTED = {("*", 2), ("e", 0)}

    def _obs(self, target_ax, source_ax, reversing=False, sig=None):
        target = Completion(self.order)
        target.run(target_ax)
        cl = mk("*", self.arg(1), self.arg(0)) if reversing \
            else mk("*", self.arg(0), self.arg(1))
        i = self.Interp("m", {("*", 2): cl}, source_ax, target)
        return self.obs_of(i, target_ax, self.order, sig)

    def test_a_checking_map_has_no_obstruction(self):
        self.assertIsNone(self._obs(
            [self.assoc, ("lz", op(x, y), x)],
            [self.assoc, ("rz", op(x, y), y)], reversing=True))

    def test_incompatible_theories_are_fatal_with_a_witness(self):
        o = self._obs([self.assoc, ("lz", op(x, y), x)],
                      [self.assoc, ("rz", op(x, y), y)])
        self.assertIs(o.verdict, self.V.FATAL)
        l, r, _ = o.collapse_witness
        # the witness must actually be a collapse of the carrier
        self.assertTrue(l.is_var and r.is_var and l is not r)

    def test_a_missing_axiom_extends_rather_than_kills(self):
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        o = self._obs([self.assoc], monoid, sig=self.POINTED)
        self.assertIs(o.verdict, self.V.EXTENDS)
        got = {(r.lhs, r.rhs) for r in o.derived_rules}
        self.assertIn((op(self.E, x), x), got)
        self.assertIn((op(x, self.E), x), got)

    def test_an_unorientable_obstruction_is_undecided_not_guessed(self):
        comm = [self.assoc, ("comm", op(x, y), op(y, x))]
        o = self._obs([self.assoc], comm)
        self.assertIs(o.verdict, self.V.UNORIENTABLE)
        self.assertIsNotNone(o.surviving_residual)
        self.assertEqual(o.derived_rules, [])

    def test_a_variable_equals_constant_collapse_is_also_fatal(self):
        # The other shape of collapse: no var-vs-var equation arises, only
        # ?x = e. It must still be fatal -- a universally quantified equation
        # with a bare variable on one side kills the carrier either way.
        trivial = [self.assoc, ("collapse", x, self.E)]
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        o = self._obs(monoid, trivial)
        self.assertIs(o.verdict, self.V.FATAL)
        a, b, _ = o.collapse_witness
        self.assertTrue(a.is_var)
        self.assertNotIn(a.head, variables(b))

    def test_a_collapse_is_found_with_the_variable_on_either_side(self):
        # `e = x` normalises with the bare variable on the RIGHT. Examining
        # only one orientation of the residue would miss it.
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        o = self._obs(monoid, [self.assoc, ("collapse", self.E, x)])
        self.assertIs(o.verdict, self.V.FATAL)
        a, b, _ = o.collapse_witness
        self.assertTrue(a.is_var)

    def test_spending_the_budget_is_EXHAUSTED_not_UNORIENTABLE(self):
        # A budget failure and a representation failure are different facts
        # and license different next actions. Starve the monoid obstruction,
        # which is perfectly orientable, and the verdict must say so.
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        o = self._obs([self.assoc], monoid, sig=self.POINTED)
        o.classify(max_rules=60, max_rounds=1)
        self.assertIs(o.verdict, self.V.EXHAUSTED)
        self.assertEqual(o.budget, (60, 1))
        self.assertEqual(o.derived_rules, [])

    def test_an_unmapped_source_symbol_is_OUT_OF_SCOPE_not_an_obstruction(self):
        # The source mentions a symbol the map does not send and the target
        # does not have. That is a gap in the map, not mathematics.
        foreign = mk("@", x)
        src = [self.assoc, ("foreign", foreign, x)]
        o = self._obs([self.assoc], src)
        self.assertIs(o.verdict, self.V.OUT_OF_SCOPE)
        self.assertIn(("@", 1), o.unmapped)
        self.assertEqual(o.residuals, [])

    def test_the_residual_records_where_the_image_landed(self):
        o = self._obs([self.assoc, ("lz", op(x, y), x)],
                      [self.assoc, ("rz", op(x, y), y)])
        (res,) = [r for r in o.residuals if r.axiom == "rz"]
        self.assertIs(res.image_lhs_nf, x)   # phi(x*y) normalised to x
        self.assertIs(res.image_rhs_nf, y)   # but had to equal y

    def test_the_five_limbs_are_all_present(self):
        o = self._obs([self.assoc, ("lz", op(x, y), x)],
                      [self.assoc, ("rz", op(x, y), y)])
        self.assertTrue(o.interpretation)       # nimitta
        self.assertTrue(o.target_axioms)        # desha
        self.assertTrue(o.residuals)            # bheda
        self.assertIsNotNone(o.verdict)         # parivartana
        self.assertIsNotNone(o.collapse_witness)  # phala

    def test_the_presentation_is_target_plus_residual(self):
        target_ax = [self.assoc, ("lz", op(x, y), x)]
        o = self._obs(target_ax, [self.assoc, ("rz", op(x, y), y)])
        pres = o.presentation()
        self.assertEqual(len(pres), len(target_ax) + len(o.residuals))
        self.assertTrue(any(n.startswith("obstruction:") for n, _, _ in pres))


class TestPursuit(unittest.TestCase):
    """The cycle: each residual must select its own next move."""

    def setUp(self):
        from machinery.crystal.chakravala import Outcome, pursue
        from machinery.crystal.transport import Interpretation, arg

        self.Outcome, self.pursue = Outcome, pursue
        self.Interp, self.arg = Interpretation, arg
        self.order = LPO(["*", "e"])
        self.assoc = ("assoc", op(op(x, y), z), op(x, op(y, z)))
        self.E = mk("e")
        self.ident = {("*", 2): mk("*", arg(0), arg(1))}

    def _run(self, source, target, sig, clauses=None, **kw):
        cl = clauses or self.ident
        return self.pursue(lambda t: self.Interp("phi", cl, source, t),
                           target, self.order, sig, **kw)

    def test_the_cycle_closes_by_repairing_two_different_failures(self):
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        p = self._run(monoid, [self.assoc], {("*", 2)})
        self.assertEqual(p.outcome, self.Outcome.SUCCEEDED)
        kinds = [s.verdict for s in p.trace if s.verdict]
        self.assertEqual(kinds, ["OUT_OF_SCOPE", "EXTENDS"])

    def test_an_impossibility_stops_at_once_with_no_successor(self):
        p = self._run([self.assoc, ("rz", op(x, y), y)],
                      [self.assoc, ("lz", op(x, y), x)], {("*", 2)})
        self.assertEqual(p.outcome, self.Outcome.IMPOSSIBLE)
        self.assertEqual(len(p.trace), 1)

    def test_a_symmetric_residual_is_beyond_lpo_under_every_precedence(self):
        p = self._run([self.assoc, ("comm", op(x, y), op(y, x))],
                      [self.assoc], {("*", 2)})
        self.assertEqual(p.outcome, self.Outcome.BEYOND_LPO)
        self.assertIn("modulo AC", str(p.yield_))

    def test_no_step_is_blind_retry_when_structure_is_available(self):
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        p = self._run(monoid, [self.assoc], {("*", 2)})
        self.assertNotIn("EXHAUSTED", [s.verdict for s in p.trace])

    def test_every_step_is_individually_accountable(self):
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        p = self._run(monoid, [self.assoc], {("*", 2)})
        for s in p.trace:
            self.assertTrue(s.move, "a step with no stated move is blind")
            self.assertGreaterEqual(s.cost, 0)

    def test_the_pursuit_terminates_rather_than_cycling(self):
        # The measure argument, exercised: an adopt step must not be
        # repeatable forever. Cap the steps low; a converging cycle finishes
        # well inside it, a spinning one would hit the cap.
        monoid = [self.assoc, ("lu", op(self.E, x), x), ("ru", op(x, self.E), x)]
        p = self._run(monoid, [self.assoc], {("*", 2)}, max_steps=4)
        self.assertEqual(p.outcome, self.Outcome.SUCCEEDED)
        self.assertLessEqual(len(p.trace), 4)

    def test_a_succeeding_transport_needs_no_cycle_at_all(self):
        p = self._run([self.assoc, ("rz", op(x, y), y)],
                      [self.assoc, ("lz", op(x, y), x)], {("*", 2)},
                      clauses={("*", 2): mk("*", self.arg(1), self.arg(0))})
        self.assertEqual(p.outcome, self.Outcome.SUCCEEDED)
        self.assertEqual(len(p.trace), 1)


if __name__ == "__main__":
    unittest.main(verbosity=2)
