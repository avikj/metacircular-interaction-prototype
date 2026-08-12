"""Independent breaker audit of R0030 (prediction/authority boundary).

Auditor: cf-tessera (Claude Fable 5 lineage).  Hostile tests against the
packet's exact statement: an exact replayable Smith forecast has no
installation authority; the live port remains an independent admitted input;
double reuse gives the discrete predictive partition on the two-constructor
carrier.  Registered suspect joints (msg 0432): the forecast-ledger append is
the ONLY mutation, and double reuse is exactly minimal (single reuse does not
separate).
"""

import unittest

from coupled_encounter_engine import EncounterEngine
from situated_constructor_port import Port, powers, select_with_port
from smith_residual_machine import smith_reduce

FORECAST_MATRIX = ((2, 1), (0, 7))


def authority_snapshot(engine):
    """Every installation-bearing field EXCEPT the forecast ledger."""
    return (
        engine.active_constructor,
        engine.active_grammar,
        engine.constructor_selection_policy,
        tuple(engine.constructor_history),
        frozenset(engine.sensors),
        frozenset(engine.actions),
        tuple((n, p.status) for n, p in sorted(engine.proposals.items())),
        engine.active_task,
        engine.rich_memory_states,
    )


class ForecastAdapterTest(unittest.TestCase):
    def test_declared_matrix_forecasts_zero(self):
        cert = smith_reduce(FORECAST_MATRIX)
        self.assertEqual(cert.steps[0].kind, "row-residual")
        self.assertTrue(cert.verify())
        engine = EncounterEngine.inherited()
        self.assertEqual(
            engine.forecast_port_from_smith(FORECAST_MATRIX).response, 0
        )

    def test_otherwise_branch_realized_by_controls(self):
        engine = EncounterEngine.inherited()
        for matrix, kind in (
            (((2, 0), (1, 7)), "column-residual"),
            (((2, 0), (0, 3)), "divisibility-residual"),
        ):
            self.assertEqual(smith_reduce(matrix).steps[0].kind, kind)
            self.assertEqual(engine.forecast_port_from_smith(matrix).response, 2)

    def test_stepless_matrix_raises(self):
        engine = EncounterEngine.inherited()
        with self.assertRaises(ValueError):
            engine.forecast_port_from_smith(((1, 0), (0, 1)))


class NoAuthorityTest(unittest.TestCase):
    def test_forecast_mutates_exactly_the_ledger(self):
        engine = EncounterEngine.inherited()
        before = authority_snapshot(engine)
        self.assertEqual(engine.response_forecasts, [])
        engine.forecast_port_from_smith(FORECAST_MATRIX)
        self.assertEqual(authority_snapshot(engine), before)
        self.assertEqual(len(engine.response_forecasts), 1)

    def test_repeated_forecasts_accumulate_only_in_ledger(self):
        engine = EncounterEngine.inherited()
        before = authority_snapshot(engine)
        for _ in range(5):
            engine.forecast_port_from_smith(FORECAST_MATRIX)
        self.assertEqual(authority_snapshot(engine), before)
        self.assertEqual(len(engine.response_forecasts), 5)

    def test_forecast_does_not_enable_execution_or_shrink_torsor(self):
        engine = EncounterEngine.inherited()
        engine.forecast_port_from_smith(FORECAST_MATRIX)
        self.assertEqual(len(engine.constructor_choices()), 2)
        with self.assertRaises(ValueError):
            engine.constructor_future(0)


class OpposedPortTest(unittest.TestCase):
    def test_live_port_overrides_nothing_and_installs(self):
        engine = EncounterEngine.inherited()
        forecast = engine.forecast_port_from_smith(FORECAST_MATRIX)
        self.assertEqual(forecast.response, 0)
        cert = engine.couple_constructor_port(2, "live-participant")
        self.assertEqual(cert.selected, (1, 0, 2))
        self.assertEqual(len(engine.active_grammar), 2)
        self.assertEqual(engine.constructor_future(0), (0, 1))
        # Disagreement is retained, not resolved: ledger still says 0,
        # installation certificate says 2.
        self.assertEqual(engine.response_forecasts[-1].response, 0)
        self.assertEqual(engine.constructor_history[-1].port.response, 2)

    def test_forecast_after_installation_still_has_no_authority(self):
        engine = EncounterEngine.inherited()
        engine.couple_constructor_port(2, "live-participant")
        before = authority_snapshot(engine)
        engine.forecast_port_from_smith(((2, 0), (1, 7)))  # agreeing forecast
        self.assertEqual(authority_snapshot(engine), before)


class PredictivePartitionTest(unittest.TestCase):
    def test_double_reuse_separates_single_does_not(self):
        """Suspect joint (ii): starting from source 0, one application of
        either constructor observes 1, so single reuse cannot separate; the
        second application observes 0 vs 2, giving the discrete partition.
        Hence 'double reuse' in the exact statement is exactly minimal."""
        g2 = select_with_port(3, 0, 1, Port(2, 2, "live")).selected
        g3 = select_with_port(3, 0, 1, Port(2, 0, "live")).selected
        one_step = {g: g[0] for g in (g2, g3)}
        self.assertEqual(set(one_step.values()), {1})  # not separated
        two_step = {g: g[g[0]] for g in (g2, g3)}
        self.assertEqual(two_step[g2], 0)
        self.assertEqual(two_step[g3], 2)
        self.assertEqual(len(set(two_step.values())), 2)  # discrete

    def test_no_third_predictive_class(self):
        """The current carrier has exactly the two constructors; the
        double-reuse observation map is injective on it, so the predictive
        partition is discrete and no third class exists."""
        g2 = select_with_port(3, 0, 1, Port(2, 2, "live")).selected
        g3 = select_with_port(3, 0, 1, Port(2, 0, "live")).selected
        observations = {
            g: tuple(x for x in [g[0], g[g[0]]]) for g in (g2, g3)
        }
        self.assertEqual(len(set(observations.values())), 2)
        for g in (g2, g3):
            self.assertEqual(len(powers(g)), {g2: 2, g3: 3}[g])


if __name__ == "__main__":
    unittest.main()
