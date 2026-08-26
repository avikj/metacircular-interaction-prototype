#!/usr/bin/env python3
"""Exact pentagon sandpile: stabilization, burning, and recurrent action."""

from itertools import product

DELTA = (
    (2, -1, 0, 0),
    (-1, 2, -1, 0),
    (0, -1, 2, -1),
    (0, 0, -1, 2),
)


def determinant(a):
    """Bareiss exact determinant."""
    m = [list(row) for row in a]
    sign, previous = 1, 1
    for k in range(len(m) - 1):
        if m[k][k] == 0:
            swap = next(i for i in range(k + 1, len(m)) if m[i][k])
            m[k], m[swap] = m[swap], m[k]
            sign *= -1
        pivot = m[k][k]
        for i in range(k + 1, len(m)):
            for j in range(k + 1, len(m)):
                m[i][j] = (m[i][j] * pivot - m[i][k] * m[k][j]) // previous
        previous = pivot
    return sign * m[-1][-1]


def stabilize(configuration, choose="left"):
    h = list(configuration)
    firings = [0] * 4
    while True:
        unstable = [i for i, value in enumerate(h) if value >= 2]
        if not unstable:
            return tuple(h), tuple(firings)
        i = unstable[0] if choose == "left" else unstable[-1]
        for row in range(4):
            h[row] -= DELTA[row][i]
        firings[i] += 1


def recurrent(configuration):
    """Dhar burning test after burning sink 0 of cycle 0-1-2-3-4-0."""
    unburnt = {1, 2, 3, 4}
    heights = {i + 1: configuration[i] for i in range(4)}
    adjacency = {1: {0, 2}, 2: {1, 3}, 3: {2, 4}, 4: {3, 0}}
    while True:
        burnable = [v for v in unburnt if heights[v] >= len(adjacency[v] & unburnt)]
        if not burnable:
            return not unburnt
        unburnt.remove(min(burnable))


def add_then_stabilize(configuration, vertex):
    h = list(configuration)
    h[vertex] += 1
    return stabilize(h)[0]


def verify():
    assert determinant(DELTA) == 5
    recurrent_states = tuple(c for c in product((0, 1), repeat=4) if recurrent(c))
    assert recurrent_states == ((0, 1, 1, 1), (1, 0, 1, 1),
                                (1, 1, 0, 1), (1, 1, 1, 0), (1, 1, 1, 1))

    # Schedule independence on a bounded but nontrivial exact family.
    for h in product(range(5), repeat=4):
        left = stabilize(h, "left")
        right = stabilize(h, "right")
        assert left == right

    actions = []
    for vertex in range(4):
        image = tuple(add_then_stabilize(state, vertex) for state in recurrent_states)
        assert set(image) == set(recurrent_states)
        actions.append(dict(zip(recurrent_states, image)))
    for a in actions:
        for b in actions:
            for state in recurrent_states:
                assert a[b[state]] == b[a[state]]

    orbit, state = [], (1, 1, 1, 1)
    while state not in orbit:
        orbit.append(state)
        state = actions[0][state]
    assert state == orbit[0] and len(orbit) == 5
    return recurrent_states, orbit


if __name__ == "__main__":
    states, orbit = verify()
    print("det(Delta)=5")
    print("recurrent:", *("".join(map(str, s)) for s in states))
    print("A_1 orbit:", " -> ".join("".join(map(str, s)) for s in orbit))
    print("PASS: exact stabilization and commuting recurrent action")
