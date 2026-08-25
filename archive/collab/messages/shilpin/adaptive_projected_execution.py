#!/usr/bin/env python3
"""Counterexample-driven installation of a minimal linear complement."""

import importlib.util
from fractions import Fraction
from pathlib import Path

_source = Path(__file__).with_name("minimal_complementary_channel.py")
_spec = importlib.util.spec_from_file_location("minimal_complementary_channel", _source)
assert _spec is not None and _spec.loader is not None
_mc = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mc)
add, diagonal, identity, mm, primitive_projector, rank = (
    _mc.add, _mc.diagonal, _mc.identity, _mc.mm,
    _mc.primitive_projector, _mc.rank,
)


def columns(a):
    return tuple(tuple(a[i][j] for i in range(len(a))) for j in range(len(a[0])))


def from_columns(cols):
    if not cols:
        return tuple()
    return tuple(tuple(cols[j][i] for j in range(len(cols))) for i in range(len(cols[0])))


def solve_full_column(b, v):
    """Solve Bx=v when B has full column rank and v lies in its image."""
    rows, cols = len(b), len(b[0])
    m = [list(b[i]) + [v[i]] for i in range(rows)]
    pivot_row = 0
    pivots = []
    for col in range(cols):
        pivot = next(r for r in range(pivot_row, rows) if m[r][col])
        m[pivot_row], m[pivot] = m[pivot], m[pivot_row]
        unit = m[pivot_row][col]
        m[pivot_row] = [x / unit for x in m[pivot_row]]
        for r in range(rows):
            if r != pivot_row and m[r][col]:
                scale = m[r][col]
                m[r] = [x - scale * y for x, y in zip(m[r], m[pivot_row])]
        pivots.append((pivot_row, col))
        pivot_row += 1
    assert all(any(row[j] for j in range(cols)) or row[-1] == 0 for row in m)
    x = [Fraction(0) for _ in range(cols)]
    for row, col in pivots:
        x[col] = m[row][-1]
    return tuple(x)


def rank_factor(a):
    """Return A=B C with inner dimension rank(A), exactly."""
    chosen = []
    for col in columns(a):
        candidate = from_columns(tuple(chosen) + (col,))
        if rank(candidate) > len(chosen):
            chosen.append(col)
    if not chosen:
        z = tuple(tuple(Fraction(0) for _ in range(len(a[0]))) for _ in range(0))
        return tuple(tuple() for _ in range(len(a))), z
    b = from_columns(tuple(chosen))
    c = from_columns(tuple(solve_full_column(b, col) for col in columns(a)))
    assert mm(b, c) == a
    return b, c


def compile_execution(p, a):
    q = add(identity(len(p)), p, scale=-1)
    primary = mm(p, mm(a, p))
    leakage = mm(q, mm(a, p))
    decoder, channel = rank_factor(leakage)
    recovered = primary if not channel else add(primary, mm(decoder, channel))
    assert recovered == mm(a, p)
    return primary, channel, decoder


def main():
    q = 6
    P = primitive_projector(q)
    T = _mc._pl.translation(q, 1)
    M = diagonal(range(q))

    primary_t, channel_t, decoder_t = compile_execution(P, T)
    assert len(channel_t) == 0
    assert primary_t == mm(T, P)

    primary_m = mm(P, mm(M, P))
    assert primary_m != mm(M, P)  # pre-installation failure
    primary_m, channel_m, decoder_m = compile_execution(P, M)
    assert len(channel_m) == 2
    assert add(primary_m, mm(decoder_m, channel_m)) == mm(M, P)

    # Rank-one truncation cannot be exact because the residual has rank two.
    assert rank(mm(decoder_m, channel_m)) == 2
    print({"translation_installed_channels": 0,
           "position_preinstall_exact": False,
           "position_installed_channels": len(channel_m),
           "position_postinstall_exact": True})
    print("ALL EXACT ADAPTIVE-EXECUTION CHECKS PASS")


if __name__ == "__main__":
    main()
