"""Theorem 24 (charge-obstruction), exact on the Smith event torsor.

The user's information spine (Theorems 4/23/24) states: for a
conditionally balanced charge C in {+-1} given Y, any estimator B(Y,Z)
has |E[C B]| <= 2 E_Y TV(P_Y, Q_Y) <= sqrt(2 I(C;Z|Y)) — computation
cannot compensate for absent information, and surviving correlation
prices cross-scale information.

On our torsor the corpus's exact-arithmetic discipline sharpens this:
the TV form holds with EQUALITY at the optimal estimator, in exact
rationals, no Pinsker loss.  Instantiation:

  events  = normalization events (U,V) of a fixed matrix, closed under
            the det-flip involution H- = diag(1,-1) in Gamma_0(m)
            (U,V) -> (H- U, V diag(1,-1)) — so the charge
            C = det U is EXACTLY balanced: E[C|Y] = 0 (R0027: both
            components; R0041: endpoint observables are torsor-blind).
  Y       = the endpoint (constant on the event set: the format).
  Z       = a recorded observable; here the finite-adic parities of
            payload entries (the machine's port coordinates).

Verified exactly (Fractions): max_B E[C B] = 2 E_Y TV(P,Q), with the
three regimes:
  Z trivial      -> advantage 0            (Cor 4.2 = R0041, exact)
  Z = 2-adic bit -> 0 <= advantage = TV    (the priced middle)
  Z = payload    -> advantage 1/2, I = log 2  (Thm 23: one full bit)
"""

from fractions import Fraction

from diagonal_smith_congruence_torsor import diag, mat_mul
from total_smith_replay_payload import section
from test_verifier_blind_fiber_reward import window_events


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


FLIP = ((1, 0), (0, -1))


def closed_event_set(mat):
    """Window events, closed under the det-flip involution."""
    u0, v0, d = section(mat)
    evs = set(window_events(mat, d))
    closed = set()
    for u, v in evs:
        closed.add((u, v))
        u2 = mat_mul(FLIP, u)
        v2 = mat_mul(v, FLIP)  # partner of diag(1,-1) is itself
        closed.add((u2, v2))
    # sanity: the involution really maps events to events
    for u, v in closed:
        assert mat_mul(mat_mul(u, mat), v) == d
    return sorted(closed), u0


def exact_tv_and_best(events, u0, zfun):
    """E_Y TV(P, Q) and the optimal-estimator correlation, exact.

    Y is constant on the event set (the shared endpoint), so
    conditioning on Y is trivial; C = det U is balanced by
    construction.  Returns (2*TV, max_B E[C B], advantage)."""
    n = len(events)
    joint = {}
    for u, v in events:
        c = det2(u)
        z = zfun(u, v, u0)
        joint[(c, z)] = joint.get((c, z), 0) + Fraction(1, n)
    zs = {z for _, z in joint}
    corr = sum(abs(joint.get((1, z), Fraction(0))
                   - joint.get((-1, z), Fraction(0))) for z in zs)
    pc = {c: sum(pr for (cc, z), pr in joint.items() if cc == c)
          for c in (1, -1)}
    pz = {z: sum(pr for (c, zz), pr in joint.items() if zz == z)
          for z in zs}
    tv = Fraction(1, 2) * sum(
        abs(joint.get((c, z), Fraction(0)) - pc[c] * pz[z])
        for c in (1, -1) for z in zs)
    assert pc[1] == pc[-1] == Fraction(1, 2), "charge not balanced"
    return 2 * tv, corr, corr / 2


def z_trivial(u, v, u0):
    return 0


def z_adic_bit(u, v, u0):
    """One 2-adic bit of the payload: parity of the payload's c-entry
    divided by the level — the machine's port coordinate."""
    from diagonal_smith_congruence_torsor import inv_unimodular
    h = mat_mul(u, inv_unimodular(u0))
    return h[1][0] % 2


def z_payload(u, v, u0):
    return (u, v)


def verify(mat=((2, 0), (1, 7))):
    events, u0 = closed_event_set(mat)
    out = []
    for name, zf in (("trivial", z_trivial), ("adic-bit", z_adic_bit),
                     ("payload", z_payload)):
        two_tv, corr, adv = exact_tv_and_best(events, u0, zf)
        out.append((name, two_tv, corr, adv, corr == two_tv))
    return out


if __name__ == "__main__":
    ok = True
    rows = verify()
    for name, two_tv, corr, adv, tight in rows:
        print(f"Z={name:9s} 2*E_Y TV={two_tv}  max E[CB]={corr}  "
              f"advantage={adv}  {'TIGHT' if tight else 'SLACK'}")
        ok = ok and tight
    ok = ok and rows[0][3] == 0            # blindness exact (R0041)
    ok = ok and rows[2][3] == Fraction(1, 2)  # full payload: one bit
    print("charge-obstruction chain: " + ("EXACT" if ok else "BROKEN"))
    raise SystemExit(0 if ok else 1)
