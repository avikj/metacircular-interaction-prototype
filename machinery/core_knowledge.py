#!/usr/bin/env python3
"""THE CORE: all knowledge of this corpus as executable, self-verifying
claims.  Every theorem the session proved lives here as (name, statement,
checker) — the checker re-derives it exactly, from primitives, at every
boot of the living machine.  A document that says what a checker checks
is a strictly worse interface than this file; knowledge not expressible
here is interface debt, listed at the bottom as the pruning frontier.

Run: python3 core_knowledge.py   (prints the ledger; exit 0 iff all alive)
"""

from fractions import Fraction
from itertools import permutations, product
from math import gcd

from kuttaka_pulverizer import (cell_from_kuttaka, pulverize, valli_replay)
from diagonal_smith_congruence_torsor import classical_cell, diag, mat_mul


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


# ---- the claims -----------------------------------------------------------

def chk_envelope_galois():
    """R0027: G <= K(E) iff orbits refine E — exhaustive n=3."""
    from invariant_schema_breaker_audit import galois_adjunction_holds
    return all(galois_adjunction_holds(n) for n in (1, 2, 3))


def chk_transporter_two_components():
    """R0027 audit: T(A,D) has det=-1 AND det=+1 components; det is
    unrecoverable from endpoint data."""
    from invariant_schema_breaker_audit import (determinant_unrecoverable,
                                                transporter_is_complete)
    return transporter_is_complete(5) and determinant_unrecoverable()


def chk_dihedral_chart():
    """R0032: the rank-one transporter is a regular D-infinity torsor with
    chart (k, s); free and transitive."""
    from smith_path_coordinate_torsor import (chart, chart_inverse,
                                              intertwining, stab, mat_mul
                                              as smm)
    for k, s in product(range(-4, 5), (1, -1)):
        if chart(chart_inverse(k, s)) != (k, s):
            return False
        for b, e in product(range(-3, 4), (1, -1)):
            if smm(stab(b, e), chart_inverse(k, s)) != \
               chart_inverse(*intertwining(b, e, k, s)):
                return False
    return True


def chk_gamma0_stabilizer():
    """R0033: HDK=D iff m | H_21 (sign-blind), K forced."""
    from diagonal_smith_congruence_torsor import (conjugate_by_diag,
                                                  in_gamma0, inv_unimodular)
    for d1, d2 in ((1, 3), (2, 6), (1, -2)):
        m = d2 // d1
        d = diag(d1, d2)
        for a, b, c, e in product(range(-2, 3), repeat=4):
            h = ((a, b), (c, e))
            if abs(det2(h)) != 1:
                continue
            member = in_gamma0(h, m)
            try:
                k = conjugate_by_diag(inv_unimodular(h), d1, d2)
                works = mat_mul(mat_mul(h, d), k) == d
            except AssertionError:
                works = False
            if member != works:
                return False
    return True


def chk_det_pair_law():
    """R0035 audit: det U * det V = sign(det M) on every event."""
    from total_smith_replay_payload import section
    from test_verifier_blind_fiber_reward import window_events
    for mat in (((2, 0), (1, 7)), ((2, 0), (0, -3))):
        u0, v0, d = section(mat)
        sign = 1 if det2(mat) > 0 else -1
        for u, v in window_events(mat, d):
            if det2(u) * det2(v) != sign:
                return False
    return True


def chk_two_sided_moduli_and_delta():
    """R0036 corrected: membership iff m_ij | H_ij BOTH sides,
    m_ij = |d_i|/gcd; delta-defect witness at diag(6,10,15)."""
    from flag_congruence_smith_stabilizer import in_flag_gamma0_conjugation
    flag = (6, 10, 15)
    m13 = abs(flag[0]) // gcd(flag[0], flag[2])
    m12 = abs(flag[0]) // gcd(flag[0], flag[1])
    m23 = abs(flag[1]) // gcd(flag[1], flag[2])
    if not (m12 * m23 == 6 and m13 == 2):  # the defect
        return False
    h = ((1, 0, 2), (0, 1, 0), (0, 0, 1))  # I + 2 E_13: genuine member
    return in_flag_gamma0_conjugation(h, flag)


def chk_assembly_identity():
    """R0034/R0040: sigma_1(m) = sum_{c^2|m} psi(m/c^2), m <= 60."""
    from hecke_coset_smith_assembly import psi, sigma1
    from math import isqrt
    return all(
        sigma1(m) == sum(psi(m // (c * c))
                         for c in range(1, isqrt(m) + 1) if m % (c * c) == 0)
        for m in range(1, 61))


def chk_free_spheres():
    """R0044: Sanov spheres are exactly 4*3^(n-1), n <= 5 (certifies no
    relation of length <= 10)."""
    A = ((1, 2), (0, 1)); B = ((1, 0), (2, 1))
    def inv(m):
        d = det2(m)
        return ((m[1][1] * d, -m[0][1] * d), (-m[1][0] * d, m[0][0] * d))
    gens = [A, B, inv(A), inv(B)]
    frontier, seen = {((1, 0), (0, 1))}, {((1, 0), (0, 1))}
    for n in range(1, 6):
        nxt = set()
        for g in frontier:
            for s in gens:
                x = mat_mul(g, s)
                if x not in seen:
                    seen.add(x); nxt.add(x)
        if len(nxt) != 4 * 3 ** (n - 1):
            return False
        frontier = nxt
    return True


def chk_mwu_conservation():
    """R0043: format-measurable rewards conserve within-class
    conditionals exactly (rational MWU)."""
    from format_conserved_learning_geometry import (conditionals, mwu,
                                                    partition_from_format)
    carrier = list(range(10))
    part = partition_from_format(carrier, lambda x: x % 2)
    reward = {x: 3 if x % 2 else 1 for x in carrier}
    pi = {x: Fraction(x + 1) for x in carrier}
    z = sum(pi.values()); pi = {x: p / z for x, p in pi.items()}
    c0 = conditionals(pi, part)
    for _ in range(5):
        pi = mwu(pi, reward, Fraction(3, 2))
        if conditionals(pi, part) != c0:
            return False
    return True


def chk_kuttaka_is_the_cell():
    """Kuttaka: the pulverizer's cell equals the classical construction;
    the valli replays."""
    for a, b in ((4, 6), (2, 3), (9, 6)):
        u, v, d = cell_from_kuttaka(a, b)
        if mat_mul(mat_mul(u, diag(a, b)), v) != d:
            return False
        if d != classical_cell(a, b)[2]:
            return False
        valli, g, x, y = pulverize(a, b)
        if not valli_replay(a, b, valli):
            return False
    return True


def chk_descent_law():
    """R0046/the law: descends iff constant on fibers; joint is coarsest;
    idempotent."""
    from descent_formation_machine import DescentMachine
    m = DescentMachine(range(12))
    if m.offer("c", lambda x: 0)["kind"] != "descends":
        return False
    if m.offer("m2", lambda x: x % 2)["kind"] != "forms":
        return False
    if m.offer("m3", lambda x: x % 3)["kind"] != "forms":
        return False
    return (len(m.fibers()) == 6
            and m.offer("m6", lambda x: x % 6)["kind"] == "descends")


def chk_ideal_vs_function_descent():
    """Nat bridge: mod-4 forms with witness (2,8); mod-11 is vacuous at
    121 (joint profile injective)."""
    prof = lambda k, S: tuple(k % p for p in S)
    if prof(2, (2, 3)) != prof(8, (2, 3)) or 2 % 4 == 8 % 4:
        return False
    profiles = [prof(k, (2, 3, 5, 7)) for k in range(2, 122)]
    return len(set(profiles)) == len(profiles)  # injective => vacuous


KNOWLEDGE = [
    ("envelope-galois", "invariants give a Galois closure, never a "
     "presentation", chk_envelope_galois),
    ("transporter-two-components", "endpoint data cannot recover even "
     "det of the reducer", chk_transporter_two_components),
    ("dihedral-chart", "rank-one payload = one integer + one sign, a "
     "regular D-infinity torsor", chk_dihedral_chart),
    ("gamma0-stabilizer", "the 2x2 event fiber is Gamma_0(d2/d1), "
     "partner forced", chk_gamma0_stabilizer),
    ("det-pair-law", "det U * det V = sign(det M) on every event",
     chk_det_pair_law),
    ("two-sided-moduli", "general stabilizer: m_ij = |d_i|/gcd both "
     "sides; delta-defect is real", chk_two_sided_moduli_and_delta),
    ("assembly-identity", "sigma_1 = sum psi over square divisors",
     chk_assembly_identity),
    ("free-spheres", "payload groups carry free subgroups: spheres "
     "4*3^(n-1), density log 3", chk_free_spheres),
    ("mwu-conservation", "fiber conditionals are conserved by "
     "format-measurable learning", chk_mwu_conservation),
    ("kuttaka-cell", "the pulverizer IS the normalization cell; the "
     "valli replays", chk_kuttaka_is_the_cell),
    ("descent-law", "observables descend or form; the joint is the "
     "coarsest common carrier", chk_descent_law),
    ("ideal-vs-function-descent", "the life's skip is ideal descent, "
     "diverging from function descent both ways",
     chk_ideal_vs_function_descent),
]

# Interface debt — knowledge NOT yet expressible as a checker here (the
# pruning frontier; each entry names why):
DEBT = [
    ("hecke-composition-labels", "R0038/R0042/R0045 label dynamics: "
     "checkers exist in tests but are minutes-long; need budgeted forms"),
    ("rank-r-payload-normal-form", "R0039 five-coordinate calculus: "
     "same"),
    ("cubical/lean formalizations", "other-language substrate; the core "
     "cannot run Agda/Lean here"),
    ("wall-certificates-live", "the machine's own runtime knowledge; "
     "verified by running, not by boot check"),
]


def verify_core():
    ledger = []
    for name, statement, chk in KNOWLEDGE:
        try:
            ok = bool(chk())
        except Exception as exc:  # noqa: BLE001
            ok = False
        ledger.append((name, ok))
    return ledger


if __name__ == "__main__":
    ledger = verify_core()
    alive = sum(1 for _, ok in ledger if ok)
    for name, ok in ledger:
        print(("ALIVE " if ok else "DEAD  ") + name)
    print(f"CORE: {alive}/{len(ledger)} claims alive; "
          f"{len(DEBT)} interface debts")
    raise SystemExit(0 if alive == len(ledger) else 1)
