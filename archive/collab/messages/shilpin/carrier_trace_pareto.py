#!/usr/bin/env python3
"""Carrier-dependent trace relation and exact Pareto schedule frontier."""


ARITY = {"a": 1, "b": 1}


def independent(marking, x, y):
    return x != y and marking >= ARITY[x] + ARITY[y]


def trace_classes(marking):
    words = (("a", "b"), ("b", "a"))
    return 1 if independent(marking, "a", "b") else len(words)


def dominates(x, y):
    return all(a <= b for a, b in zip(x, y)) and any(a < b for a, b in zip(x, y))


def frontier(costs):
    return tuple(sorted(c for c in set(costs)
                        if not any(dominates(d, c) for d in costs)))


def schedule_frontier(marking):
    costs = [(2, 1)]  # sequential: latency two, peak occupied carrier one
    if independent(marking, "a", "b"):
        costs.append((1, 2))  # concurrency cell: latency one, peak two
    return frontier(costs)


def additive_work_frontier(marking):
    # If only total work is priced, both sequential and parallel executions
    # cost two.  The trace quotient changes no frontier.
    costs = [(2,)]
    if independent(marking, "a", "b"):
        costs.append((2,))
    return frontier(costs)


def main():
    assert trace_classes(1) == 2
    assert schedule_frontier(1) == ((2, 1),)
    assert trace_classes(2) == 1
    assert schedule_frontier(2) == ((1, 2), (2, 1))

    # A carrier update creates and then erases the interchange equation.
    marking = 1
    history = [(marking, trace_classes(marking), schedule_frontier(marking))]
    marking += 1
    history.append((marking, trace_classes(marking), schedule_frontier(marking)))
    marking -= 1
    history.append((marking, trace_classes(marking), schedule_frontier(marking)))
    assert history[0] == history[2]

    # Hostile control: commutation alone cannot affect additive work cost.
    assert additive_work_frontier(1) == additive_work_frontier(2) == ((2,),)
    print({"grow_shrink_history": history,
           "additive_work_control": ((2,),)})
    print("ALL EXACT CARRIER/TRACE/PARETO CHECKS PASS")


if __name__ == "__main__":
    main()
