#!/usr/bin/env python3
"""THE CORE, minimal form: one law, applied to itself.

The minimality answer (found under challenge — the previous revision of
this file was the four-collapse answer, and the four were one):

    VERIFICATION IS DESCENT.

A claim of this corpus is an observable over its instance world.  It is a
theorem iff its truth-observable DESCENDS through the indiscrete carrier
with constant value True — a theorem is exactly an observable that cannot
split its own world.  A dead claim FORMS, and the fiber that splits off
is the counterexample, delivered by the same law that grows the living
machine.  So there is no verifier separate from the organism: the sixteen
hand-written checkers of the previous revision were sixteen private
re-implementations of `DescentMachine.offer`, and this file deletes them
in favour of the one call.

What the whole system is, in total: (1) the descent law
(`descent_formation_machine.offer`), and (2) an exact evaluator
presenting worlds.  Everything else — the sixteen claims below, the
machine's genome, the walls — is DATA fed to (1) through (2).  Documents
elsewhere in the repo are strictly worse interfaces to this ledger.

Each claim is (name, statement, world, holds): `world()` yields the
finite instance world (hashable states; for expensive constructions the
world materializes the object and `holds` states its law — exactly the
machine's hidden-world pattern), `holds` is the truth-observable.  Two
claims have worlds of propositions (thunks) because their content is a
finite conjunction of unlike parts; their observable is `_truth`.

Run: python3 core_knowledge.py   (prints the ledger, with the splitting
witness for any dead claim; exit 0 iff all alive)
"""

from fractions import Fraction
from itertools import product
from math import gcd

from kuttaka_pulverizer import cell_from_kuttaka, pulverize, valli_replay
from diagonal_smith_congruence_torsor import classical_cell, diag, mat_mul


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


def _truth(proposition):
    return proposition()


# ---- worlds and observables ----------------------------------------------

def _S(i, p=2):
    """Endpoint moment S(p^i) from the psi sum (R0040)."""
    from math import isqrt
    from hecke_coset_smith_assembly import psi
    n = p ** i
    return sum(c * psi(n // (c * c))
               for c in range(1, isqrt(n) + 1) if n % (c * c) == 0)


def _C(i, k, p=2):
    """Chains to a fixed label-i lattice at level p^k (automaton law)."""
    if i == 0:
        return 1
    if 2 * i > k:
        return 0
    if 2 * i == k:
        return (p + 1) * _C(i - 1, k - 1, p)
    return _C(i, k - 1, p) + p * _C(i - 1, k - 1, p)


def w_ballot():
    return range(1, 6)


def h_ballot(k):
    from math import comb
    from hecke_coset_smith_assembly import hnf_bases, smith_invariants
    p = 2
    W = 0
    for base in hnf_bases(p ** k):
        e1 = smith_invariants(base)[0]
        i = e1.bit_length() - 1  # e1 = p^i for p = 2
        W += e1 * _C(i, k)
    rhs = sum((comb(k, j) - (comb(k, j - 1) if j else 0))
              * p ** (2 * j) * _S(k - 2 * j)
              for j in range(k // 2 + 1))
    if W != rhs:
        return False
    return k != 2 or W - _S(2) == p * p  # the refutation gap, exactly


def w_labels():
    from hecke_coset_smith_assembly import hnf_bases
    bases = [tuple(map(tuple, b)) for b in hnf_bases(2)]
    return bases + [((2, 0), (0, 2))]


def h_labels(base):
    from hecke_composition_smith_labels import compose
    from hecke_coset_smith_assembly import hnf_bases, smith_invariants
    steps = hnf_bases(2)
    labels = sorted(smith_invariants(compose(base, s))[0] for s in steps)
    if base == ((2, 0), (0, 2)):     # balanced: all keep, raise impossible
        return labels == [2, 2, 2]
    return (smith_invariants(base)[0] == 1
            and labels == [1, 1, 2])  # keep, keep, raise


def w_unimodular_window():
    return [((a, b), (c, e))
            for a, b, c, e in product(range(-2, 3), repeat=4)
            if abs(a * e - b * c) == 1]


def h_mixed_rank(h):
    from mixed_rank_smith_stabilizer import (h_side_member,
                                             one_sided_member,
                                             one_sided_stabilizes,
                                             partner, two_sided_stabilizes)
    flag, n = (2,), 2
    member = h_side_member(h, flag)
    if member != (h[1][0] == 0):  # corner GL_1 = {+-1}: C must vanish
        return False
    if member and not two_sided_stabilizes(h, partner(h, flag, n), flag, n):
        return False
    return one_sided_stabilizes(h, flag, n) == one_sided_member(h, flag)


def _sl2_size(N):
    s, n, p = N ** 3, N, 2
    while p * p <= n:
        if n % p == 0:
            s = s // (p * p) * (p * p - 1)
            while n % p == 0:
                n //= p
        p += 1
    if n > 1:
        s = s // (n * n) * (n * n - 1)
    return s


def w_index():
    return ((1, 2), (2, 3), (2, 2), (1, 6), (3, 5), (2, 6))


def h_index(inst):
    from math import lcm
    from hecke_coset_smith_assembly import psi
    m12, m21 = inst
    N = lcm(m12, m21)
    cnt = sum(1 for a in range(N) for b in range(0, N, m12)
              for c in range(0, N, m21) for d in range(N)
              if (a * d - b * c) % N == 1)
    return _sl2_size(N) // cnt == psi(m12 * m21)


def w_galois():
    return (1, 2, 3)


def h_galois(n):
    from invariant_schema_breaker_audit import galois_adjunction_holds
    return galois_adjunction_holds(n)


def w_transporter():
    from invariant_schema_breaker_audit import (determinant_unrecoverable,
                                                transporter_is_complete)
    return [lambda: transporter_is_complete(5), determinant_unrecoverable]


def w_chart():
    return [(k, s) for k in range(-4, 5) for s in (1, -1)]


def h_chart(inst):
    from smith_path_coordinate_torsor import (chart, chart_inverse,
                                              intertwining, stab,
                                              mat_mul as smm)
    k, s = inst
    if chart(chart_inverse(k, s)) != (k, s):
        return False
    for b, e in product(range(-3, 4), (1, -1)):
        if smm(stab(b, e), chart_inverse(k, s)) != \
           chart_inverse(*intertwining(b, e, k, s)):
            return False
    return True


def w_gamma0():
    return [(d1, d2, h)
            for d1, d2 in ((1, 3), (2, 6), (1, -2))
            for h in w_unimodular_window()]


def h_gamma0(inst):
    from diagonal_smith_congruence_torsor import (conjugate_by_diag,
                                                  in_gamma0, inv_unimodular)
    d1, d2, h = inst
    member = in_gamma0(h, d2 // d1)
    d = diag(d1, d2)
    try:
        k = conjugate_by_diag(inv_unimodular(h), d1, d2)
        works = mat_mul(mat_mul(h, d), k) == d
    except AssertionError:
        works = False
    return member == works


def w_det_pair():
    from total_smith_replay_payload import section
    from test_verifier_blind_fiber_reward import window_events
    out = []
    for mat in (((2, 0), (1, 7)), ((2, 0), (0, -3))):
        u0, v0, d = section(mat)
        sign = 1 if det2(mat) > 0 else -1
        for u, v in window_events(mat, d):
            out.append((u, v, sign))
    return out


def h_det_pair(inst):
    u, v, sign = inst
    return det2(u) * det2(v) == sign


def w_moduli():
    out = ["delta-defect"]
    for flag in ((1, 2, 4), (6, 10, 15)):
        for i in range(3):
            for j in range(3):
                if i != j:
                    out.extend((flag, i, j, v) for v in range(1, 7))
    return out


def h_moduli(inst):
    from flag_congruence_smith_stabilizer import in_flag_gamma0_conjugation
    if inst == "delta-defect":
        flag = (6, 10, 15)
        m = lambda a, b: abs(flag[a]) // gcd(flag[a], flag[b])
        return m(0, 1) * m(1, 2) == 6 and m(0, 2) == 2  # delta = 3
    flag, i, j, v = inst
    m_ij = abs(flag[i]) // gcd(flag[i], flag[j])
    h = tuple(tuple((1 if r == c else 0) + (v if (r, c) == (i, j) else 0)
                    for c in range(3)) for r in range(3))
    return in_flag_gamma0_conjugation(h, flag) == (v % m_ij == 0)


def w_assembly():
    return range(1, 61)


def h_assembly(m):
    from math import isqrt
    from hecke_coset_smith_assembly import psi, sigma1
    return sigma1(m) == sum(psi(m // (c * c))
                            for c in range(1, isqrt(m) + 1)
                            if m % (c * c) == 0)


def w_spheres():
    A = ((1, 2), (0, 1))
    B = ((1, 0), (2, 1))

    def inv(m):
        d = det2(m)
        return ((m[1][1] * d, -m[0][1] * d), (-m[1][0] * d, m[0][0] * d))

    gens = [A, B, inv(A), inv(B)]
    frontier, seen = {((1, 0), (0, 1))}, {((1, 0), (0, 1))}
    out = []
    for n in range(1, 6):
        nxt = set()
        for g in frontier:
            for s in gens:
                x = mat_mul(g, s)
                if x not in seen:
                    seen.add(x)
                    nxt.add(x)
        out.append((n, len(nxt)))
        frontier = nxt
    return out


def h_spheres(inst):
    n, size = inst
    return size == 4 * 3 ** (n - 1)


def _mwu_setup():
    carrier = list(range(10))
    reward = {x: 3 if x % 2 else 1 for x in carrier}
    pi = {x: Fraction(x + 1) for x in carrier}
    z = sum(pi.values())
    return carrier, reward, {x: p / z for x, p in pi.items()}


def w_mwu():
    from format_conserved_learning_geometry import mwu
    carrier, reward, pi = _mwu_setup()
    traj = [tuple(pi[x] for x in carrier)]
    for _ in range(5):
        pi = mwu(pi, reward, Fraction(3, 2))
        traj.append(tuple(pi[x] for x in carrier))
    return traj


def h_mwu(pi_tuple):
    from format_conserved_learning_geometry import (conditionals,
                                                    partition_from_format)
    carrier, _, pi0 = _mwu_setup()
    part = partition_from_format(carrier, lambda x: x % 2)
    pi = dict(zip(carrier, pi_tuple))
    return conditionals(pi, part) == conditionals(pi0, part)


def w_kuttaka():
    return ((4, 6), (2, 3), (9, 6))


def h_kuttaka(inst):
    a, b = inst
    u, v, d = cell_from_kuttaka(a, b)
    if mat_mul(mat_mul(u, diag(a, b)), v) != d:
        return False
    if d != classical_cell(a, b)[2]:
        return False
    valli, g, x, y = pulverize(a, b)
    return valli_replay(a, b, valli)


def w_descent():
    return (12, 30)


def h_descent(n):
    from descent_formation_machine import DescentMachine
    m = DescentMachine(range(n))
    if m.offer("c", lambda x: 0)["kind"] != "descends":
        return False
    if m.offer("m2", lambda x: x % 2)["kind"] != "forms":
        return False
    if m.offer("m3", lambda x: x % 3)["kind"] != "forms":
        return False
    return (len(m.fibers()) == 6
            and m.offer("m6", lambda x: x % 6)["kind"] == "descends")


def w_rank_r_coords():
    a_list = (((1, 0), (0, 1)), ((1, 1), (0, 1)),
              ((1, 0), (2, 1)), ((-1, 1), (2, -1)))
    coords = [(a, b, e, rb, s)
              for a in a_list
              for b in (((0,), (0,)), ((1,), (-1,)))
              for e in (((1,),), ((-1,),))
              for rb in (((0, 0),), ((1, -1),))
              for s in (((1,),), ((-1,),))]
    sub = coords[::5]
    return [(x, y) for x in sub for y in sub]


def h_rank_r_coords(inst):
    from rank_r_payload_normal_form import (assemble, coords_valid, extract,
                                            group_identity, group_inverse,
                                            group_law, mul)
    flag, n = (1, 2), 3
    x, y = inst
    if not (coords_valid(x, flag, n) and coords_valid(y, flag, n)):
        return False
    hx, kx = assemble(x, flag, n)
    hy, ky = assemble(y, flag, n)
    z = group_law(x, y, flag)
    if not coords_valid(z, flag, n):
        return False
    hz, kz = assemble(z, flag, n)
    if (hz, kz) != (mul(hx, hy), mul(ky, kx)):  # K composes opposite
        return False
    if extract(hz, kz, flag, n) != z:
        return False
    return group_law(x, group_inverse(x, flag), flag) == \
        group_identity(flag, n)


def w_horizon():
    return ((13,), (20,), (40,), (96,))


def h_horizon(inst):
    """The machine's staggered-horizon world (found through three dead
    designs in one night): at every grant level g >= 13, exactly five
    word-classes are visible — four words signed inside the horizon,
    the rest indistinguishable beyond it — and the replay-prefix
    observable separates exactly those five.  The developmental
    profile of the living machine, as an exact claim."""
    import living_machine as lm
    (g,) = inst
    saved = lm.PORT_BITS[0]
    try:
        lm.PORT_BITS[0] = lm.KIND_BASE + g
        words = lm.h_family(lm.VALLI_EPOCH)
        prefixes = {w[:g] for w in words}
        replays = {lm.replay_prefix(w, min(len(w), g)) for w in words}
        return len(words) == 8 and len(prefixes) == 5 \
            and len(replays) == 5
    finally:
        lm.PORT_BITS[0] = saved


def _subgroups_sym(n):
    """All subgroups of S_n as frozensets of permutation tuples."""
    from itertools import permutations as perms

    def compose(p, q):
        return tuple(p[q[i]] for i in range(n))

    elems = list(perms(range(n)))
    subs = set()
    for seed in range(1 << len(elems)):
        gens = [e for i, e in enumerate(elems) if seed >> i & 1]
        h = {tuple(range(n))}
        frontier = list(h) + gens
        while frontier:
            g = frontier.pop()
            for x in list(h) + gens:
                for y in (compose(g, x), compose(x, g)):
                    if y not in h:
                        h.add(y)
                        frontier.append(y)
        subs.add(frozenset(h))
        if len(subs) == 6 and n == 3:
            break
    return subs


def w_envelope_loss():
    return [(n, h) for n in (1, 2, 3) for h in sorted(
        _subgroups_sym(n), key=lambda s: (len(s), sorted(s)))]


def h_envelope_loss(inst):
    """Carr row C3 (archivist ← codex-schema ← R0027, three lineages):
    E = Stab∘Inv is a closure; every subgroup of S_1, S_2 is lossless,
    and at degree 3 the UNIQUE lossy subgroup is C3 with envelope S3 —
    the minimal finite loss of the invariant-schema feedback."""
    from itertools import permutations as perms
    n, h = inst
    orbits = []
    seen = set()
    for i in range(n):
        if i in seen:
            continue
        orb = {p[i] for p in h} | {i}
        changed = True
        while changed:
            changed = False
            for p in h:
                for x in list(orb):
                    if p[x] not in orb:
                        orb.add(p[x])
                        changed = True
        orbits.append(orb)
        seen |= orb
    envelope = frozenset(
        p for p in perms(range(n))
        if all({p[x] for x in o} == o for o in orbits))
    if n < 3 or len(h) != 3:
        return envelope == h          # lossless everywhere else
    return len(envelope) == 6         # C3's envelope is all of S3


def w_index_n3():
    return [(2, 1, (0, 0, 1)), (2, 1, (0, 1, 1)), (3, 1, (0, 0, 1)),
            (2, 2, (0, 1, 2)), ("delta-global",)]


def h_index_n3(inst):
    """The delta question answered: [SL3(Z_p):K(a)] =
    [SL3(F_p):P(supp a)] * p^{sum max(0,a_ij-1)} — the n=2 product
    collapse fails at n=3, the pattern's shape enters, and the
    delta-witness diag(6,10,15) has global index 7*13*31 = 2821."""
    from two_sided_index_n3 import (count_sl3_pattern, pattern_of,
                                    predicted_index, sl3_size,
                                    delta_witness_global_index)
    if inst == ("delta-global",):
        return delta_witness_global_index() == 2821
    p, k, e = inst
    a = pattern_of(e)
    return sl3_size(p, k) // count_sl3_pattern(p, k, a) == \
        predicted_index(p, k, a)


def w_charge():
    return ("trivial", "adic-bit", "payload")


def h_charge(inst):
    """Theorem 24 (the information spine), exact on the torsor: the
    TV bound holds with EQUALITY at the optimal estimator; the
    det-flip involution makes flip-invariant observables (the adic
    parity) charge-blind at price exactly zero; the full payload is
    exactly one bit."""
    from fractions import Fraction
    from charge_information_obstruction import verify
    rows = {name: (two_tv, corr, adv, tight)
            for name, two_tv, corr, adv, tight in verify()}
    two_tv, corr, adv, tight = rows[inst]
    if not tight:
        return False
    if inst in ("trivial", "adic-bit"):
        return adv == 0
    return adv == Fraction(1, 2)


def w_nat_bridge():
    def prof(k, S):
        return tuple(k % p for p in S)

    def mod4_diverges():   # forms with witness (2, 8)
        return prof(2, (2, 3)) == prof(8, (2, 3)) and 2 % 4 != 8 % 4

    def mod11_vacuous():   # joint profile injective below 122
        profiles = [prof(k, (2, 3, 5, 7)) for k in range(2, 122)]
        return len(set(profiles)) == len(profiles)

    return [mod4_diverges, mod11_vacuous]


KNOWLEDGE = [
    ("ballot-moment", "the chain and endpoint moments are bridged by the "
     "ballot transform and never equal: the k=2 gap is exactly p^2",
     w_ballot, h_ballot),
    ("label-dynamics", "index-p children keep the label p times and "
     "raise once; balanced lattices only keep", w_labels, h_labels),
    ("mixed-rank-stabilizer", "rank-deficient stabilizers are parabolic "
     "over the flag corner; one-sided collapses the corner",
     w_unimodular_window, h_mixed_rank),
    ("two-sided-index", "the two-sided congruence index is psi of the "
     "product of the moduli; the delta-defect is invisible at n=2",
     w_index, h_index),
    ("envelope-galois", "invariants give a Galois closure, never a "
     "presentation", w_galois, h_galois),
    ("transporter-two-components", "endpoint data cannot recover even "
     "det of the reducer", w_transporter, _truth),
    ("dihedral-chart", "rank-one payload = one integer + one sign, a "
     "regular D-infinity torsor", w_chart, h_chart),
    ("gamma0-stabilizer", "the 2x2 event fiber is Gamma_0(d2/d1), "
     "partner forced", w_gamma0, h_gamma0),
    ("det-pair-law", "det U * det V = sign(det M) on every event",
     w_det_pair, h_det_pair),
    ("two-sided-moduli", "general stabilizer: m_ij = |d_i|/gcd both "
     "sides; delta-defect is real", w_moduli, h_moduli),
    ("assembly-identity", "sigma_1 = sum psi over square divisors",
     w_assembly, h_assembly),
    ("free-spheres", "payload groups carry free subgroups: spheres "
     "4*3^(n-1), density log 3", w_spheres, h_spheres),
    ("mwu-conservation", "fiber conditionals are conserved by "
     "format-measurable learning", w_mwu, h_mwu),
    ("kuttaka-cell", "the pulverizer IS the normalization cell; the "
     "valli replays", w_kuttaka, h_kuttaka),
    ("descent-law", "observables descend or form; the joint is the "
     "coarsest common carrier", w_descent, h_descent),
    ("ideal-vs-function-descent", "the life's skip is ideal descent, "
     "diverging from function descent both ways", w_nat_bridge, _truth),
    ("rank-r-coordinate-law", "the five-block coordinates (A,B,E,R,S) "
     "compose by the twisted law (K side opposite, R twisted through "
     "the D_r conjugation) matching matrix multiplication exactly",
     w_rank_r_coords, h_rank_r_coords),
    ("staggered-horizon", "the machine's word world shows exactly five "
     "classes at every grant level: four signed inside the horizon, "
     "the rest beyond it — formations and walls both recur forever",
     w_horizon, h_horizon),
    ("envelope-minimal-loss", "the invariant-schema envelope is "
     "lossless on every subgroup below degree 3; C3 inside S3 is the "
     "unique minimal loss (Carr C3, three independent derivations)",
     w_envelope_loss, h_envelope_loss),
    ("two-sided-index-n3", "the local index is the pattern-subgroup "
     "index times the smooth lift p^(a_ij-1); the n=2 product "
     "collapse fails at n=3 and diag(6,10,15) has index 2821",
     w_index_n3, h_index_n3),
    ("charge-obstruction", "the balanced det-charge obeys the TV "
     "bound with equality at the optimum; flip-invariant observables "
     "are charge-blind at price zero; the payload is one bit",
     w_charge, h_charge),
]

# Interface debt — knowledge NOT yet expressible as a claim here (the
# pruning frontier; each entry names why):
DEBT = [
    ("cubical-migration", "THE debt, per the substrate directive: each "
     "claim below is a finite shadow of a type; the knowledge side "
     "moves to formal/cubical, Python remains the world/oracle side "
     "only.  Typed so far (8 modules): the descent law, the full "
     "R0033 torsor (partner/converse/freeness/transitivity/"
     "transporter-membership), the unimodular toolkit, and the valli "
     "trace laws — gamma0-stabilizer, kuttaka-cell, dihedral-chart "
     "shadows now have typed counterparts"),
    ("wall-certificates-live", "the machine's own runtime knowledge; "
     "verified by running, not by boot check"),
]


def verify_core():
    """The one checker: offer each claim's truth-observable to the descent
    law over its instance world.  Alive iff it descends to the point with
    value True; a dead claim forms, and the split fiber is the
    counterexample."""
    from descent_formation_machine import DescentMachine
    ledger = []
    for name, statement, world, holds in KNOWLEDGE:
        try:
            instances = list(world())
            event = DescentMachine(instances).offer(
                name, lambda x: bool(holds(x)))
            ok = (event["kind"] == "descends"
                  and bool(holds(instances[0])))
        except Exception:  # noqa: BLE001
            ok = False
        ledger.append((name, ok))
    return ledger


if __name__ == "__main__":
    ledger = verify_core()
    alive = sum(1 for _, ok in ledger if ok)
    worlds = {name: (world, holds)
              for name, _, world, holds in KNOWLEDGE}
    for name, ok in ledger:
        if ok:
            print("ALIVE " + name)
        else:
            world, holds = worlds[name]
            try:
                witness = next(x for x in world() if not holds(x))
            except Exception:  # noqa: BLE001
                witness = "(world unconstructible)"
            print(f"DEAD  {name}  split witness: {witness!r}")
    print(f"CORE: {alive}/{len(ledger)} claims alive; "
          f"{len(DEBT)} interface debts")
    raise SystemExit(0 if alive == len(ledger) else 1)
