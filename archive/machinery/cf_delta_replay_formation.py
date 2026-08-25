"""cf-delta independent replay of FORMATION_RELATIVE_QUANTUM_MEMORY.

Independent of machinery/formation_relative_quantum_memory.py (which uses
collections.Counter).  Here fibers are recomputed from scratch by sort-and-group
over an explicit sensor evaluation, and the two claims are checked:

  (1) d_S(q) = max_y |S cap q^-1(y)| <= max_y |q^-1(y)| = d_X(q)  (monotone).
  (2) residue sensor q_m on S_N = {0,...,N-1} has cost ceil(N/m), diverging
      only along the declared exhaustion; every finite S has finite cost while
      the ambient mod-m fibers on N are infinite.

Exact / combinatorial throughout; the randomized sweep is an adversarial
falsifier for (1), not a measurement.
"""

import random


def max_fiber(states, sensor):
    """max_y |{x in states : sensor(x) = y}|, from scratch by grouping."""
    groups = {}
    for x in states:
        groups.setdefault(sensor(x), []).append(x)
    return max((len(g) for g in groups.values()), default=0)


def check_monotone(ambient, formed, sensor):
    assert set(formed) <= set(ambient)
    dX = max_fiber(ambient, sensor)
    dS = max_fiber(formed, sensor)
    assert dS <= dX, f"monotonicity violated: dS={dS} > dX={dX}"
    equal = dS == dX
    return dX, dS, equal


def main():
    # deterministic anchor case from the note: mod 3 on range(12), S={0,1,2}
    dX, dS, eq = check_monotone(range(12), (0, 1, 2), lambda x: x % 3)
    assert (dX, dS, eq) == (4, 1, False), (dX, dS, eq)
    print(f"anchor mod-3 range(12), S={{0,1,2}}: dX={dX} dS={dS} equal={eq}")

    # equality case: choose S to contain a full ambient maximum fiber
    dX2, dS2, eq2 = check_monotone(range(12), (0, 3, 6, 9), lambda x: x % 3)
    assert (dX2, dS2, eq2) == (4, 4, True), (dX2, dS2, eq2)
    print(f"equality case S={{0,3,6,9}}: dX={dX2} dS={dS2} equal={eq2}")

    # adversarial randomized falsifier for monotonicity (1)
    rng = random.Random(20260812)
    for _ in range(2000):
        n = rng.randint(1, 40)
        universe = list(range(n))
        k = rng.randint(1, n)
        formed = rng.sample(universe, k)
        m = rng.randint(1, 12)
        _dX, _dS, _ = check_monotone(universe, formed, lambda x, m=m: x % m)
    print("2000 random (ambient, formed, mod-m) cases: dS <= dX always holds.")

    # residue exhaustion law: cost on S_N = {0,...,N-1} is ceil(N/m)
    def ceil_div(a, b):
        return -(-a // b)
    for m in range(1, 8):
        for N in range(1, 200):
            cost = max_fiber(range(N), lambda x, m=m: x % m)
            assert cost == ceil_div(N, m), (m, N, cost, ceil_div(N, m))
    print("residue S_N cost = ceil(N/m) verified for m<=7, N<200.")

    # infinite no-go framing: fibers of mod m on N are countably infinite, so
    # no finite overwritten dilation exists; yet every finite S is finite.
    # Exhibit divergence of ceil(N/m) along the exhaustion while any fixed S
    # stays bounded.
    m = 6
    growth = [ceil_div(N, m) for N in (6, 60, 600, 6000)]
    assert growth == [1, 10, 100, 1000]
    print("mod-6 ambient cost ceil(N/6) diverges along exhaustion:", growth,
          "-> no finite ambient dilation, finite formed worlds only lower-bound.")

    print("CONFIRMED: formation-restricted cost is a lower bound on ambient; "
          "finite formed worlds cannot certify the infinite ambient cost.")


if __name__ == "__main__":
    main()
