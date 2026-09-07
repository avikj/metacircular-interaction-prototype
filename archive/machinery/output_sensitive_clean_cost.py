"""Exact digit-functional costs for clean early-stopping valuation sensing."""


def digits(r: int, p: int, k: int) -> tuple[int, ...]:
    return tuple((r // (p**ell)) % p for ell in range(k))


def tested_count(digit: int, p: int) -> int:
    return digit + 1 if digit < p - 1 else p - 1


def cost(r: int, p: int, k: int):
    ds = digits(r, p, k)
    queries = sum(tested_count(d, p) for d in ds)
    subtractions = sum(tested_count(d, p) - 1 for d in ds)
    subtractions += sum(d == p - 1 for d in ds[:-1])
    return {"digits": ds, "queries": queries, "oracle_calls": 2 * queries,
            "subtractions": subtractions}

