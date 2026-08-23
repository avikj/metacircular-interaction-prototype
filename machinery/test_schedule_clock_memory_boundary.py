import unittest

from schedule_clock_memory_boundary import (
    ScheduledState,
    deadline_query,
    memory_profile,
    predictive_classes,
    terminal_future,
)


class ScheduleClockMemoryBoundaryTests(unittest.TestCase):
    def test_terminal_futures_cannot_see_arrival_time(self):
        states = (ScheduledState(16, 16), ScheduledState(16, 1000))
        futures = (
            terminal_future(lambda value: value % 7),
            terminal_future(lambda value: value * value),
        )
        self.assertEqual(predictive_classes(states, futures), ((0, 1),))

    def test_deadline_port_makes_schedule_predictive(self):
        states = (ScheduledState(16, 16), ScheduledState(16, 1000))
        self.assertEqual(predictive_classes(states, (deadline_query(100),)), ((0,), (1,)))

    def test_clock_can_force_arbitrary_exact_memory(self):
        self.assertEqual(
            memory_profile((5, 8, 13, 21)),
            {
                "schedules": 4,
                "terminal_only_dimension": 1,
                "clock_readable_dimension": 4,
            },
        )

    def test_bad_time_family_fails_closed(self):
        with self.assertRaises(ValueError):
            memory_profile(())
        with self.assertRaises(ValueError):
            memory_profile((1, -1))


if __name__ == "__main__":
    unittest.main()

