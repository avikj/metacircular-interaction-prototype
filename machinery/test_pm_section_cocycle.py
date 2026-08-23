#!/usr/bin/env python3
"""Hostile tests for the Peres-Mermin section/cocycle separation."""

from __future__ import annotations

from itertools import product

from pm_section_cocycle import (CONTEXTS, GRID, OBS, canon, cocycle_identity_exhaustive,
                                commuting_certificate, context_signs, f2_solve,
                                gauge, incidence, mat_mul, mu, op, run,
                                scalar_of, signs_from_mu, sym_of, vadd)

CHECKS = []


def check(name, ok):
    CHECKS.append((name, ok))
    print(("PASS" if ok else "FAIL"), name)


def main():
    r = run()

    # 1. The theorem: no global section, class nonzero, both routes agree.
    check("PM: zero global sections (solver and 512-exhaustive)",
          r["global_section"] is None and r["global_sections_exhaustive"] == 0)
    check("obstruction class = 1 in coker of dim exactly 1",
          r["obstruction_class"] == 1 and r["coker_dim"] == 1 and r["rank"] == 5)
    check("every context has exactly 4 local sections",
          r["local_sections_per_context"] == [4] * 6)

    # 2. Derived, not postulated: signs from exact matrices = (+,+,+,+,+,-).
    check("derived sign vector is [0,0,0,0,0,1]",
          r["signs"] == [0, 0, 0, 0, 0, 1])

    # 3. The typed diagram: mu is a cocycle; pushforward with gauge agrees.
    check("mu cocycle identity (4096 triples)", r["cocycle_identity"])
    check("pushforward (gauge + mu) reproduces matrix signs",
          r["pushforward_agrees"])

    # 4. PLANTED FALSE (the caught defect, kept as a control): pushforward
    #    WITHOUT the gauge 1-cochain must disagree with the matrix signs.
    bare = []
    for ctx in CONTEXTS:
        u, v, w = (sym_of(n) for n in ctx)
        ph = (mu(u, v) + mu(vadd(u, v), w)) % 4
        bare.append(0 if ph == 0 else 1)
    check("planted false caught: gauge-free pushforward disagrees",
          bare != r["signs"])

    # 5. Relativity controls: cover and local system.
    check("rows-only cover admits sections", r["rows_only_section_exists"])
    check("one-edge twist admits exactly 2^(9-rank) = 16 sections",
          r["twisted_section_exists"] and r["twisted_sections_count"] == 16)
    check("all-plus signs admit sections", r["all_plus_sections_exist"])

    # 6. Mutation: corrupting one grid cell must break commuting or the
    #    derived signs (the structure is rigid, not decorative).
    import pm_section_cocycle as P
    original = P.GRID[2][2]
    P.GRID[2][2] = "XZ"
    P.CONTEXTS = ([tuple(P.GRID[i][c] for c in range(3)) for i in range(3)] +
                  [tuple(P.GRID[i][c] for i in range(3)) for c in range(3)])
    broke = not P.commuting_certificate()
    if not broke:
        try:
            broke = P.context_signs() != r["signs"]
        except AssertionError:
            broke = True
    P.GRID[2][2] = original
    P.CONTEXTS = ([tuple(P.GRID[i][c] for c in range(3)) for i in range(3)] +
                  [tuple(P.GRID[i][c] for i in range(3)) for c in range(3)])
    check("mutation ZZ->XZ breaks the structure", broke)

    # 7. Gauge is exactly the Y-count: check A_x = i^gauge * P_sym on all 9.
    ok = True
    for name in OBS:
        A = op(name)
        Pm = canon(sym_of(name))
        g = gauge(name)
        # multiply Pm by i^g and compare
        ig = [(1, 0), (0, 1), (-1, 0), (0, -1)][g]
        scaled = [[(ig[0] * a - ig[1] * b, ig[0] * b + ig[1] * a)
                   for (a, b) in row] for row in Pm]
        ok &= A == scaled
    check("gauge law A = i^{#Y} P_sym holds for all nine observables", ok)

    failed = [n for n, okk in CHECKS if not okk]
    print("SUMMARY passed=%d failed=%d" % (len(CHECKS) - len(failed), len(failed)))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
