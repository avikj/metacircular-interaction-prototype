#!/usr/bin/env python3
"""Trace-induced macro redundancy and predictive-quotient no-go."""


def equivalent(marking, left, right):
    if left == right:
        return True
    return marking >= 2 and {left, right} == {("a", "b"), ("b", "a")}


def macro_redundant(marking):
    # Installed macro m expands to ba; existing compiled word c expands to ab.
    return equivalent(marking, ("b", "a"), ("a", "b"))


def descends(marking, observer):
    histories = (("a", "b"), ("b", "a"))
    return all(not equivalent(marking, x, y) or observer(x) == observer(y)
               for x in histories for y in histories)


def quotient_size(marking, observer):
    if not descends(marking, observer):
        raise ValueError("observer is not lawful on the carrier trace quotient")
    histories = (("a", "b"), ("b", "a"))
    profiles = {observer(h) for h in histories}
    return len(profiles)


def endpoint(_history):
    return "done"


def order(history):
    return history


def main():
    # Growth: macro becomes redundant, then shrink reopens it.
    assert not macro_redundant(1)
    assert macro_redundant(2)
    assert not macro_redundant(1)

    # A trace-invariant task has the same predictive quotient before/after.
    assert descends(1, endpoint) and descends(2, endpoint)
    assert quotient_size(1, endpoint) == quotient_size(2, endpoint) == 1

    # The apparent two-to-one predictive reduction uses an order-sensitive
    # observer.  It is lawful at low carrier and forbidden, not compressed,
    # after interchange is installed.
    assert descends(1, order)
    assert quotient_size(1, order) == 2
    assert not descends(2, order)
    try:
        quotient_size(2, order)
    except ValueError:
        pass
    else:
        raise AssertionError("non-trace-invariant observer was silently accepted")

    print({"macro_redundant": {1: False, 2: True},
           "endpoint_quotient_sizes": {1: 1, 2: 1},
           "order_task": {1: "two states", 2: "fails descent"}})
    print("ALL EXACT MACRO/TRACE REOPENING CHECKS PASS")


if __name__ == "__main__":
    main()
