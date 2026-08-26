"""Exact trace preservation test for contracting an action word to a macro."""

from collections import defaultdict
from collections.abc import Sequence

Transformation = tuple[int, ...]
Observation = tuple[int, ...]


def temporal_profile(actions: Sequence[Transformation], observations: Sequence[Observation]):
    if len(actions) != len(observations):
        raise ValueError("declare one observation after each action")
    if not actions:
        raise ValueError("a macro expansion must be nonempty")
    n = len(actions[0])
    if any(len(a) != n or len(o) != n for a, o in zip(actions, observations)):
        raise ValueError("actions and observations must share a carrier")
    endpoint = []
    traces = []
    for x in range(n):
        state = x
        trace = []
        for action, observation in zip(actions, observations):
            state = action[state]
            trace.append(observation[state])
        endpoint.append(state)
        traces.append(tuple(trace))
    return tuple(endpoint), tuple(traces)


def minimum_side_record_dimension(endpoint, traces) -> int:
    if len(endpoint) != len(traces):
        raise ValueError("endpoint and trace maps must share a domain")
    by_endpoint = defaultdict(set)
    for y, trace in zip(endpoint, traces):
        by_endpoint[y].add(trace)
    return max((len(values) for values in by_endpoint.values()), default=0)


def endpoint_macro_preserves_trace(endpoint, traces) -> bool:
    return minimum_side_record_dimension(endpoint, traces) <= 1
