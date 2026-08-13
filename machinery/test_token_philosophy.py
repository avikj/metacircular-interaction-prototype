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
    SPECTATOR_12,
    SPECTATOR_21,
    boundary_orbit,
    check_derivation,
    collapse_derivation,
    comp,
    dom_cod,
    gen,
    idm,
    interpret_spectator,
    interpret_threads,
    occurrences,
    report,
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


class Report(unittest.TestCase):
    def test_report_runs(self):
        text = report()
        self.assertIn("f = g in 3 checked steps", text)
        self.assertIn("g in boundary orbit of f: False", text)


if __name__ == "__main__":
    unittest.main()
