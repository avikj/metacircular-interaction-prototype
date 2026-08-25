#!/usr/bin/env python3
"""Exact tests for the token-philosophy instruments.

The decisive tests are `test_collective_identifies_causally_distinct` (the
checked derivation) together with `test_threads_separate_beyond_boundary_orbit`
(the model that keeps them apart): jointly they refute the `notes/STATEBOX.md`
§7 guess that the fibre of the token-forgetting map is a boundary orbit.

Everything else is a control.  Three matter: withholding `COMM` must make the
identification underivable (it is the one axiom the individual-token theory
rejects); planted-false steps must be refused; and the thread model must
satisfy the symmetric monoidal laws it is standing in for, checked
exhaustively on a generated fragment.
"""

import itertools
import unittest

from compositional_crystal import factor_map

from token_philosophy import (
    AXIOMS,
    CAUSAL_COLLAPSE,
    CAUSAL_COLLAPSE_START,
    CAUSAL_COLLAPSE_TARGET,
    COLLECTIVE_IDENTIFICATION,
    DerivationError,
    F_EXEC,
    G_EXEC,
    SIG_ONE,
    SIG_TWO,
    SS,
    T1,
    T2,
    TypeError_,
    SEQ_12,
    SEQ_21,
    STEPS_TO_TENSOR,
    STEP_12,
    STEP_21,
    SPECTATOR_12,
    SPECTATOR_21,
    boundary_orbit,
    check_derivation,
    collapse_derivation,
    comp,
    dom_cod,
    gen,
    idm,
    ARITIES_BIN,
    ARITIES_UNARY,
    SIG_BIN,
    arity,
    commutation_derivation,
    concurrency_threshold,
    equal_collectively,
    interpret_spectator,
    interpret_threads,
    normal_form,
    occurrences,
    padding_is_injective,
    report,
    rewrite_component,
    boundary_crystal,
    collectively_equal,
    collective_factors_through_boundary,
    fire,
    local_trace_class,
    marking,
    run,
    trace_equivalent,
    transposable,
    two_steps,
    sym,
    tens,
    thread_multiset,
    w_comp,
    w_id,
    w_sym,
    w_tens,
    x_comp,
    x_gen,
    x_id,
    x_tens,
)


class CollectiveIdentification(unittest.TestCase):
    def test_collective_identifies_causally_distinct(self):
        chain = check_derivation(F_EXEC, COLLECTIVE_IDENTIFICATION, G_EXEC, SIG_TWO)
        self.assertEqual(len(chain), 4)
        self.assertEqual(chain[0], F_EXEC)
        self.assertEqual(chain[-1], G_EXEC)

    def test_causal_collapse(self):
        chain = check_derivation(CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE,
                                 CAUSAL_COLLAPSE_TARGET, SIG_ONE)
        self.assertEqual(len(chain), 7)

    def test_every_step_preserves_the_boundary(self):
        for start, steps, sig in ((F_EXEC, COLLECTIVE_IDENTIFICATION, SIG_TWO),
                                  (CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE, SIG_ONE)):
            chain = check_derivation(start, steps,
                                     G_EXEC if sig is SIG_TWO else CAUSAL_COLLAPSE_TARGET, sig)
            boundaries = {dom_cod(t, sig, collective=True) for t in chain}
            self.assertEqual(len(boundaries), 1)


class Controls(unittest.TestCase):
    def test_withholding_commutativity_kills_the_identification(self):
        """COMM is the whole content of the collective philosophy.  Without it
        the same script is not a derivation."""
        without = tuple(a for a in AXIOMS if a != "COMM")
        with self.assertRaises(DerivationError):
            check_derivation(F_EXEC, COLLECTIVE_IDENTIFICATION, G_EXEC, SIG_TWO,
                             allowed=without)
        with self.assertRaises(DerivationError):
            check_derivation(CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE,
                             CAUSAL_COLLAPSE_TARGET, SIG_ONE, allowed=without)

    def test_planted_false_steps_are_refused(self):
        # COMM at a position that is not a tensor.
        with self.assertRaises(DerivationError):
            check_derivation(F_EXEC, [((0,), "COMM", True)], F_EXEC, SIG_TWO)
        # INTERCHANGE forwards where the term is not a composite of tensors.
        with self.assertRaises(DerivationError):
            check_derivation(F_EXEC, [((), "INTERCHANGE", True)], F_EXEC, SIG_TWO)
        # A correct step that lands somewhere other than the claimed target.
        with self.assertRaises(DerivationError):
            check_derivation(F_EXEC, [((), "INTERCHANGE", False)], G_EXEC, SIG_TWO)
        # UNIT_L forwards where the left factor is not an identity.
        with self.assertRaises(DerivationError):
            check_derivation(comp(T1, T1), [((), "UNIT_L", True)], T1, SIG_TWO)
        # An ill-typed term is refused before any axiom is consulted.
        with self.assertRaises(TypeError_):
            check_derivation(comp(idm(("s", "s")), T1), [((), "UNIT_L", True)],
                             T1, SIG_TWO)

    def test_ill_typed_terms_are_refused(self):
        with self.assertRaises(TypeError_):
            dom_cod(comp(T1, tens(T1, T2)), SIG_TWO)
        with self.assertRaises(TypeError_):
            dom_cod(gen("nonexistent"), SIG_TWO)

    def test_occurrence_multiset_survives_every_step(self):
        """What the collective view keeps: the multiset of transition
        occurrences is constant along both derivations."""
        for start, steps, target, sig in (
                (F_EXEC, COLLECTIVE_IDENTIFICATION, G_EXEC, SIG_TWO),
                (CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE, CAUSAL_COLLAPSE_TARGET, SIG_ONE)):
            chain = check_derivation(start, steps, target, sig)
            self.assertEqual(len({occurrences(t, sig) for t in chain}), 1)


class ThreadModel(unittest.TestCase):
    def test_threads_separate_beyond_boundary_orbit(self):
        """f and g have different thread multisets, and the thread multiset is
        constant on boundary orbits -- so g is in no boundary orbit of f."""
        self.assertEqual(thread_multiset(F_EXEC, SIG_TWO), ("t1t1", "t2t2"))
        self.assertEqual(thread_multiset(G_EXEC, SIG_TWO), ("t1t2", "t2t1"))
        orbit = boundary_orbit(F_EXEC, SIG_TWO, SS)
        self.assertEqual(len(orbit), 4)
        for member in orbit:
            self.assertEqual(thread_multiset(member, SIG_TWO),
                             thread_multiset(F_EXEC, SIG_TWO))
            self.assertNotEqual(thread_multiset(member, SIG_TWO),
                                thread_multiset(G_EXEC, SIG_TWO))

    def test_collapse_pair_also_separated_individually(self):
        self.assertNotEqual(thread_multiset(CAUSAL_COLLAPSE_START, SIG_ONE),
                            thread_multiset(CAUSAL_COLLAPSE_TARGET, SIG_ONE))

    def test_threads_refute_commutativity(self):
        """Phi is a strict symmetric monoidal functor, so it validates every
        axiom of the individual-token theory; it refutes COMM, which is exactly
        the axiom that separates the two philosophies."""
        self.assertNotEqual(interpret_threads(tens(T1, T2), SIG_TWO),
                            interpret_threads(tens(T2, T1), SIG_TWO))

    def _fragment(self):
        """A finite set of W-morphisms, closed enough to test the laws on."""
        atoms = {1: [w_id(1), ((0,), ("t1",)), ((0,), ("t2",))],
                 2: [w_id(2), w_sym(1, 1)]}
        for a in atoms[1]:
            for b in atoms[1]:
                atoms[2].append(w_tens(a, b))
        return atoms

    def test_thread_model_satisfies_symmetric_monoidal_laws(self):
        frag = self._fragment()
        one, two = frag[1], frag[2]

        for a, b, c in itertools.product(one, repeat=3):
            self.assertEqual(w_comp(w_comp(a, b), c), w_comp(a, w_comp(b, c)))
        for a in one + two:
            n = len(a[0])
            self.assertEqual(w_comp(w_id(n), a), a)
            self.assertEqual(w_comp(a, w_id(n)), a)
        for a, b in itertools.product(one, repeat=2):
            self.assertEqual(w_tens(w_id(1), w_id(1)), w_id(2))
            # interchange
            for c, d in itertools.product(one, repeat=2):
                self.assertEqual(w_comp(w_tens(a, c), w_tens(b, d)),
                                 w_tens(w_comp(a, b), w_comp(c, d)))
            # symmetry naturality and involution
            self.assertEqual(w_comp(w_sym(1, 1), w_tens(b, a)),
                             w_comp(w_tens(a, b), w_sym(1, 1)))
        self.assertEqual(w_comp(w_sym(1, 1), w_sym(1, 1)), w_id(2))
        self.assertEqual(w_comp(w_sym(2, 1), w_sym(1, 2)), w_id(3))

    def test_thread_interpretation_matches_hand_computation(self):
        # f: strand 0 traverses t1t1 and stays put; strand 1 traverses t2t2.
        self.assertEqual(interpret_threads(F_EXEC, SIG_TWO), ((0, 1), ("t1t1", "t2t2")))
        # post-composing with the swap moves both strands, labels unchanged.
        swapped = comp(F_EXEC, sym(("s",), ("s",)))
        self.assertEqual(interpret_threads(swapped, SIG_TWO), ((1, 0), ("t1t1", "t2t2")))
        # pre-composing with the swap exchanges which label sits on which strand.
        self.assertEqual(interpret_threads(comp(sym(("s",), ("s",)), F_EXEC), SIG_TWO),
                         ((1, 0), ("t2t2", "t1t1")))


class SpectatorModel(unittest.TestCase):
    """The successor conjecture of notes/TOKEN_PHILOSOPHY.md §5 -- that a
    collective execution is exactly its occurrence multiset -- is false.  X is
    the model that kills it, and the same tests show precisely how much of the
    order survives: none of it, once one idle token stands beside."""

    def test_order_survives_on_a_single_strand(self):
        self.assertNotEqual(interpret_spectator(SEQ_12, SIG_TWO),
                            interpret_spectator(SEQ_21, SIG_TWO))
        # ...while the occurrence multiset, the refuted conjecture's invariant,
        # cannot tell them apart.
        self.assertEqual(occurrences(SEQ_12, SIG_TWO), occurrences(SEQ_21, SIG_TWO))

    def test_one_spectator_token_erases_the_order(self):
        self.assertEqual(interpret_spectator(SPECTATOR_12, SIG_TWO),
                         interpret_spectator(SPECTATOR_21, SIG_TWO))
        for start in (SPECTATOR_12, SPECTATOR_21):
            target = tens(T1, T2) if start is SPECTATOR_12 else tens(T2, T1)
            chain = check_derivation(start, collapse_derivation(), target, SIG_TWO)
            self.assertEqual(len(chain), 7)
        # and the two targets are COMM-equal, closing the square
        check_derivation(tens(T2, T1), [((), "COMM", True)], tens(T1, T2), SIG_TWO)

    def test_spectator_model_is_constant_along_every_derivation(self):
        """Soundness, used as a falsifier: X must validate every axiom the
        derivations invoke.  If X were not a commutative monoidal category this
        test would break."""
        for start, steps, target, sig in (
                (F_EXEC, COLLECTIVE_IDENTIFICATION, G_EXEC, SIG_TWO),
                (CAUSAL_COLLAPSE_START, CAUSAL_COLLAPSE, CAUSAL_COLLAPSE_TARGET, SIG_ONE),
                (SPECTATOR_12, collapse_derivation(), tens(T1, T2), SIG_TWO)):
            chain = check_derivation(start, steps, target, sig)
            values = {interpret_spectator(t, sig) for t in chain}
            self.assertEqual(len(values), 1)

    def test_spectator_model_satisfies_the_axioms(self):
        atoms = [x_id(1), x_gen("t1"), x_gen("t2")]
        wide = [x_id(2), x_tens(x_gen("t1"), x_id(1)), x_tens(x_id(1), x_gen("t2"))]
        unit = x_id(0)
        for a, b, c in itertools.product(atoms, repeat=3):
            self.assertEqual(x_comp(x_comp(a, b), c), x_comp(a, x_comp(b, c)))
        for a in atoms + wide + [unit]:
            self.assertEqual(x_comp(a, x_id(a[0])), a)
            self.assertEqual(x_comp(x_id(a[0]), a), a)
            self.assertEqual(x_tens(a, unit), a)
            self.assertEqual(x_tens(unit, a), a)
        self.assertEqual(x_tens(x_id(1), x_id(1)), x_id(2))
        for a, b, c, d in itertools.product(atoms, repeat=4):
            # interchange
            self.assertEqual(x_comp(x_tens(a, c), x_tens(b, d)),
                             x_tens(x_comp(a, b), x_comp(c, d)))
        for a, b in itertools.product(atoms + wide, repeat=2):
            # the symmetry is the identity, so naturality is commutativity
            self.assertEqual(x_tens(a, b), x_tens(b, a))

    def test_threads_and_spectator_disagree_exactly_where_they_should(self):
        """Phi keeps order on any number of strands; X keeps it on one.  The
        difference between the philosophies is that gap."""
        self.assertNotEqual(interpret_threads(SPECTATOR_12, SIG_TWO),
                            interpret_threads(SPECTATOR_21, SIG_TWO))
        self.assertEqual(interpret_spectator(SPECTATOR_12, SIG_TWO),
                         interpret_spectator(SPECTATOR_21, SIG_TWO))


class DecisionProcedure(unittest.TestCase):
    """For the one-place unary class the free commutative monoidal category is
    determined: a word on one strand, a multiset on two or more.  These tests
    are the falsifier that found the gap in the axiom set (associativity was
    missing) and the derivation that drives the theorem."""

    def test_adjacent_padded_steps_commute_from_two_tokens_on(self):
        self.assertEqual(len(check_derivation(STEP_12, STEPS_TO_TENSOR,
                                              tens(T1, T2), SIG_TWO)), 9)
        self.assertEqual(len(check_derivation(STEP_21, STEPS_TO_TENSOR,
                                              tens(T2, T1), SIG_TWO)), 9)
        check_derivation(tens(T2, T1), [((), "COMM", True)], tens(T1, T2), SIG_TWO)
        self.assertTrue(equal_collectively(STEP_12, STEP_21, SIG_TWO))

    def test_no_such_move_at_one_token(self):
        self.assertFalse(equal_collectively(SEQ_12, SEQ_21, SIG_TWO))
        self.assertEqual(normal_form(SEQ_12, SIG_TWO), ("word", ("t1", "t2")))
        self.assertEqual(normal_form(SEQ_21, SIG_TWO), ("word", ("t2", "t1")))

    def test_padding_injective_except_at_one(self):
        self.assertEqual([padding_is_injective(n) for n in range(4)],
                         [True, False, True, True])
        # the n = 1 failure, exhibited
        self.assertFalse(equal_collectively(SEQ_12, SEQ_21, SIG_TWO))
        self.assertTrue(equal_collectively(SPECTATOR_12, SPECTATOR_21, SIG_TWO))

    def test_rewriting_never_crosses_a_normal_form(self):
        """Soundness of the invariant, as a search falsifier: no axiom rewrite
        from any of these seeds ever reaches a different normal form.  This is
        the test that caught the missing associativity axioms."""
        for seed, sig, cap in ((SEQ_12, SIG_TWO, 400),
                               (SPECTATOR_12, SIG_TWO, 400),
                               (F_EXEC, SIG_TWO, 400),
                               (CAUSAL_COLLAPSE_START, SIG_ONE, 400)):
            found = rewrite_component(seed, sig, max_leaves=4, cap=cap)
            self.assertGreater(len(found), 5)
            self.assertEqual(len({normal_form(x, sig) for x in found}), 1)
            for x in found:
                self.assertEqual(arity(x, sig), arity(seed, sig))

    def test_search_connects_the_pairs_the_theorem_identifies(self):
        found = rewrite_component(SPECTATOR_12, SIG_TWO, max_leaves=4, cap=800)
        self.assertIn(SPECTATOR_21, found)
        self.assertIn(tens(T1, T2), found)
        self.assertIn(STEP_12, found)
        # ...and never the arity-1 pair, which no derivation identifies
        found1 = rewrite_component(SEQ_12, SIG_TWO, max_leaves=4, cap=800)
        self.assertNotIn(SEQ_21, found1)


class Concurrency(unittest.TestCase):
    """Dropping unarity does not break the mechanism; it shows what the
    mechanism was measuring.  Two padded steps commute exactly when both
    firings fit in the marking, so the collective category is a trace monoid
    with independence = resource-disjointness."""

    def test_derivation_exists_exactly_at_the_threshold(self):
        n = concurrency_threshold("b1", "b2", ARITIES_BIN)
        self.assertEqual(n, 4)
        for a, b in (("b1", "b2"), ("b2", "b1")):
            chain = check_derivation(two_steps(a, b, n, ARITIES_BIN),
                                     commutation_derivation(a, b, n, ARITIES_BIN),
                                     tens(gen(a), gen(b)), SIG_BIN)
            self.assertEqual(len(chain), 5)
        check_derivation(tens(gen("b2"), gen("b1")), [((), "COMM", True)],
                         tens(gen("b1"), gen("b2")), SIG_BIN)

    def test_the_same_script_is_refused_one_token_short(self):
        """The control that locates the mechanism: at n = 3 the two tensor
        splits are (2,1) and (1,2), so interchange has nothing to act on."""
        script = commutation_derivation("b1", "b2", 4, ARITIES_BIN)
        with self.assertRaises(DerivationError):
            check_derivation(two_steps("b1", "b2", 3, ARITIES_BIN), script,
                             tens(gen("b1"), gen("b2")), SIG_BIN)
        with self.assertRaises(TypeError_):
            commutation_derivation("b1", "b2", 3, ARITIES_BIN)

    def test_trace_model_thresholds(self):
        for arities, threshold in ((ARITIES_UNARY, 2), (ARITIES_BIN, 4),
                                   ({"t1": 1, "t2": 2}, 3)):
            a, b = sorted(arities)
            self.assertEqual(concurrency_threshold(a, b, arities), threshold)
            for n in range(1, threshold + 3):
                if arities[a] > n or arities[b] > n:
                    continue
                self.assertEqual(trace_equivalent((a, b), (b, a), n, arities),
                                 n >= threshold)

    def test_trace_normal_form_is_an_invariant_of_the_relation(self):
        ar = {"t1": 1, "t2": 1, "t3": 3}
        # at n = 2, t1 and t2 commute but neither fits beside t3
        self.assertTrue(trace_equivalent(("t1", "t2"), ("t2", "t1"), 2, ar))
        self.assertFalse(trace_equivalent(("t1", "t2"), ("t2", "t2"), 2, ar))
        # at n = 4, t1 and t3 fit side by side; t2 and t3 do not at n = 3
        self.assertTrue(trace_equivalent(("t1", "t3"), ("t3", "t1"), 4, ar))
        self.assertFalse(trace_equivalent(("t2", "t3"), ("t3", "t2"), 3, ar))
        # longer traces: partial commutation, not full
        self.assertTrue(trace_equivalent(("t1", "t2", "t3"), ("t2", "t1", "t3"), 2, ar))
        self.assertFalse(trace_equivalent(("t1", "t3", "t2"), ("t3", "t2", "t1"), 2, ar))

    def test_unary_case_is_theorem_11(self):
        """The k = 1 specialisation must reproduce the decided class."""
        self.assertEqual(concurrency_threshold("t1", "t2", ARITIES_UNARY), 2)
        self.assertFalse(trace_equivalent(("t1", "t2"), ("t2", "t1"), 1, ARITIES_UNARY))
        self.assertTrue(trace_equivalent(("t1", "t2"), ("t2", "t1"), 2, ARITIES_UNARY))
        self.assertEqual(normal_form(SEQ_12, SIG_TWO)[0], "word")
        self.assertEqual(normal_form(SPECTATOR_12, SIG_TWO)[0], "multiset")


class GeneralNets(unittest.TestCase):
    """Nothing in the mechanism needed one place or a marking-preserving
    transition.  In general the transposition condition is *local* -- read at
    the marking where the exchange happens -- and the equivalence it generates
    is strictly coarser than the relation at the source marking."""

    NET = {"p": (marking(), marking(s=1)),
           "a": (marking(s=1), marking(s=1)),
           "b": (marking(s=1), marking(s=1))}

    def test_locality_is_not_a_technicality(self):
        one = marking(s=1)
        # at one token a and b compete, so their order is real...
        self.assertFalse(collectively_equal(one, ("a", "b"), ("b", "a"), self.NET))
        self.assertFalse(transposable(one, "a", "b", self.NET))
        # ...but a transition that *produces* a token can be scheduled early,
        # and then it is not.  The relation is local; its closure is not.
        self.assertTrue(collectively_equal(one, ("a", "b", "p"), ("b", "a", "p"), self.NET))
        self.assertEqual(len(local_trace_class(one, ("p", "a", "b"), self.NET)), 6)

    def test_two_tokens_restores_the_theorem_13_threshold(self):
        two = marking(s=2)
        self.assertTrue(transposable(two, "a", "b", self.NET))
        self.assertTrue(collectively_equal(two, ("a", "b"), ("b", "a"), self.NET))

    def test_agrees_with_the_one_place_theorem(self):
        """Where Theorem 14 applies, the general construction reproduces it."""
        net = {"t1": (marking(s=1), marking(s=1)), "t2": (marking(s=1), marking(s=1))}
        for n in (1, 2, 3):
            self.assertEqual(
                collectively_equal(marking(s=n), ("t1", "t2"), ("t2", "t1"), net),
                trace_equivalent(("t1", "t2"), ("t2", "t1"), n, ARITIES_UNARY))
        binary = {"b1": (marking(s=2), marking(s=2)), "b2": (marking(s=2), marking(s=2))}
        for n in (2, 3, 4, 5):
            self.assertEqual(
                collectively_equal(marking(s=n), ("b1", "b2"), ("b2", "b1"), binary),
                trace_equivalent(("b1", "b2"), ("b2", "b1"), n, ARITIES_BIN))

    def test_disabled_sequences_are_refused(self):
        with self.assertRaises(TypeError_):
            run(marking(), ("a",), self.NET)
        with self.assertRaises(TypeError_):
            local_trace_class(marking(s=1), ("a", "a", "b", "b", "b"), 
                              {"a": (marking(s=1), marking()),
                               "b": (marking(s=1), marking(s=1))})

    def test_the_class_never_leaves_its_boundary_or_its_occurrences(self):
        one = marking(s=1)
        cls = local_trace_class(one, ("p", "a", "b"), self.NET)
        for w in cls:
            visited = run(one, w, self.NET)
            self.assertEqual(visited[-1], marking(s=2))
            self.assertEqual(tuple(sorted(w)), ("a", "b", "p"))


class CorpusCrystal(unittest.TestCase):
    """Corollary 6 is not a new construction.  The boundary relation is the
    compositional crystal of the two symmetry operations, and this corpus
    already has that object, its universal property, and a runtime that emits
    it with a minimum separating context basis.  So compute it there."""

    def test_boundary_fibres_are_the_orbits(self):
        elements, crystal = boundary_crystal([F_EXEC, G_EXEC], SIG_TWO)
        self.assertEqual(len(elements), 8)
        self.assertEqual(len(crystal.fibers), 2)
        self.assertEqual({len(f) for f in crystal.fibers}, {4})
        self.assertEqual(set(crystal.observations),
                         {("t1t1", "t2t2"), ("t1t2", "t2t1")})

    def test_collective_factors_but_is_not_injective(self):
        """factor_map succeeds: the collective normal form is constant on the
        boundary fibres, so the collective relation is coarser.  It takes the
        SAME value on both fibres, so it is strictly coarser -- Corollary 6,
        computed rather than argued."""
        crystal, values, injective = collective_factors_through_boundary(
            [F_EXEC, G_EXEC], SIG_TWO)
        self.assertEqual(len(values), 2)
        self.assertEqual(values[0], values[1])
        self.assertFalse(injective)

    def test_one_context_separates_the_orbits(self):
        _, crystal = boundary_crystal([F_EXEC, G_EXEC], SIG_TWO)
        self.assertEqual(len(crystal.separating_contexts), 1)
        self.assertEqual(len(crystal.equations), 12)   # 2 orbits, C(4,2) each

    def test_factor_map_refuses_a_finer_observation(self):
        """Control: a map that separates two members of one orbit does not
        factor -- the runtime's universal property is doing real work."""
        elements, crystal = boundary_crystal([F_EXEC, G_EXEC], SIG_TWO)
        with self.assertRaises(ValueError):
            factor_map(crystal, {e: e for e in elements})


class Report(unittest.TestCase):
    def test_report_runs(self):
        text = report()
        self.assertIn("f = g in 3 checked steps", text)
        self.assertIn("g in boundary orbit of f: False", text)


if __name__ == "__main__":
    unittest.main()
