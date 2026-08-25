"""Replay the typed end-to-end valuation sensing certificate."""

from adaptive_center_chain import center_chain


def power_ladder(p: int, k: int):
    if p < 2 or k < 1:
        raise ValueError("require p>=2 and k>=1")
    powers = [p]
    dependencies = []
    for _ in range(1, k):
        nxt = powers[-1] * p
        dependencies.append((powers[-1], p, nxt))
        powers.append(nxt)
    return powers, dependencies


def compile_run(r: int, p: int, k: int):
    powers, multiplications = power_ladder(p, k)
    centers, subtractions, recovered = center_chain(r, p, k)
    return {
        "powers": powers,
        "multiplications": multiplications,
        "centers": centers,
        "subtractions": subtractions,
        "queries": len(centers),
        "recovered": recovered,
    }

