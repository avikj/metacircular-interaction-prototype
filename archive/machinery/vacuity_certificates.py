#!/usr/bin/env python3
"""Genuine-vs-vacuous certificates for finite descent verdicts (exact).

The corpus lesson, three times over (R0036 window replays; nat-trace span
vacuity; the living machine's discrete carriers): a descent verdict on a
FINITE universe says only that no witness pair sits inside the universe.
It never says why.  This module makes the "why" a checkable object.

Setting.  A finite universe U of states; a carrier partition P on U given
as the level sets of a key function kappa; an offered observable f.  The
DECLARED DOMAIN SEMANTICS of f: f is the restriction to U of a total
function F on a declared ambient world W containing U, and kappa is
likewise the restriction of an ambient key.  The practical declaration of
W is a finite MARGIN SAMPLE: states of W beyond U on which kappa and F
can be evaluated exactly.  Everything below is exact integer / symbolic
computation; there are no floats and no fits anywhere.

The trichotomy (Definition, implemented literally by `certify`):

  FORMS            some P-fiber of U holds x, y with f(x) != f(y).
                   Certificate: the earliest such pair in U-order (the
                   canonical witness of DescentMachine/IncrementalDM).

  GENUINE-DESCENT  f is constant on every P-fiber of U, AND the constancy
                   is exhibited as forced: the explicit interpolated
                   g : {fiber keys} -> values with f = g o kappa on U is
                   verified to extend to F = g o kappa on the margin
                   sample of W, with at least one REVISIT — a margin
                   state landing in an already-interpolated fiber and
                   agreeing.  (A margin that only ever opens new fibers
                   tests nothing; see UNDECIDED-VACUOUS.)  Certificate:
                   g itself, plus the exact scope (|U|, margin size,
                   revisit count, revisited fibers).

  VACUOUS          f is constant on every P-fiber of U, but the ambient
                   world contains a pair — realizable in W, absent from U
                   (at least one endpoint outside U) — lying in ONE
                   ambient kappa-fiber with different F-values: f would
                   split there, so its descent on U is an artifact of the
                   sample, not a law.  Certificate: the exhibited pair,
                   its fiber key, its two F-values, and the singleton-
                   fiber count of U (the usual mechanism of the disease:
                   a carrier discrete or near-discrete on U descends
                   everything).

  UNDECIDED-VACUOUS  f is constant on every P-fiber of U but ambient
                   realizability cannot be decided from what was
                   declared: no ambient world given, an empty margin, or
                   a margin that never revisits a fiber.  Certificate:
                   the reason, verbatim.  Honest scoping is the point —
                   a GENUINE verdict is never issued on unexercised
                   constancy.

Singleton fibers alone are a SYMPTOM, never a verdict: U = {2} descends
every observable with a singleton fiber, yet mod-6 over mod-2,mod-3 is
still genuine there.  VACUOUS therefore always demands the exhibited
ambient pair; the symptom is reported alongside.

The COMPLETE specialization (`certify_complete`).  The living machine's
COMPLETE verdict says: the carrier is discrete on the shell.  That is
exactly the statement "the IDENTITY observable descends" (identity is
constant on every fiber iff every fiber is a singleton).  Discreteness
never un-happens on subsets, so the vacuity question for COMPLETE is a
LOOK-AHEAD: does the genome's evaluation map stay injective on the next
world (bigger shell, deeper fiber family)?  For the identity observable a
revisit-with-agreement is impossible (agreement of identity means the
same state, excluded by dedup), so the revisit requirement is dropped —
"no collision on the sample" is the entire content:

  NOT-COMPLETE      the carrier was not discrete on U at all (the claimed
                    precondition fails); witness pair exhibited.
  GENUINE-COMPLETE  genome key injective on U and on the sampled next
                    world: discreteness is real at the sampled horizon.
  SHELL-LOCAL       a state of the next world collides with an existing
                    (or another new) state: COMPLETE was an artifact of
                    the shell; witness pair exhibited.
  UNDECIDED-VACUOUS empty/absent look-ahead sample, with the reason.

Instances (each returns the exact certificate; see the test battery):

  * R0036 window (instance_r0036_window): on the {-1,0,1} window at
    D = (1,2,4) the mutant moduli table (below-diagonal 2,4,2 -> 997)
    descends — VACUOUS, ambient pair (member of the window, I + 2E_10);
    the derived gcd-moduli description is GENUINE on the same window via
    the elementary-certificate margin.
  * nat trace (instance_nat_mod11 / instance_nat_mod6): mod-11 on {2..121}
    over the joint profile of {2,3,5,7} — VACUOUS, 120 singleton fibers,
    ambient pair (2, 212); mod-6 on {2..36} over {2,3,5} — GENUINE via
    the interpolated g (the CRT identity), margin one full period.
  * living machine (instance_living_complete): full genome (entries, det,
    hentries) at epoch 0, bound 1 — bits=2 is COMPLETE on the shell but
    SHELL-LOCAL under look-ahead (epoch-1 shear k=4 is I mod 4); bits=5
    is GENUINE-COMPLETE on the same look-ahead; bits=0 is NOT-COMPLETE.

Budget: every certificate counts |U| + |margin| against a hard budget
(default 100_000) and raises rather than sample silently.

Run demo:  cd machinery && python3 vacuity_certificates.py
Tests:     cd machinery && python3 -m unittest test_vacuity_certificates -v
"""

from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

__all__ = [
    "FORMS", "GENUINE", "VACUOUS", "UNDECIDED",
    "NOT_COMPLETE", "GENUINE_COMPLETE", "SHELL_LOCAL",
    "certify", "certify_complete",
    "instance_r0036_window", "instance_nat_mod11", "instance_nat_mod6",
    "instance_nat_mod4_forms", "instance_living_complete",
    "nat_profile", "living_universe", "living_evaluator", "LIVING_GENOME",
]

FORMS = "FORMS"
GENUINE = "GENUINE-DESCENT"
VACUOUS = "VACUOUS"
UNDECIDED = "UNDECIDED-VACUOUS"

NOT_COMPLETE = "NOT-COMPLETE"
GENUINE_COMPLETE = "GENUINE-COMPLETE"
SHELL_LOCAL = "SHELL-LOCAL"

BUDGET = 100_000


# -------------------------------------------------------------------------
# the certificate
# -------------------------------------------------------------------------

def certify(universe, kappa, F, margin=None, require_revisit=True,
            budget=BUDGET):
    """The genuine-vs-vacuous certificate.  Exact; returns a dict whose
    "verdict" is FORMS | GENUINE | VACUOUS | UNDECIDED with the witnesses
    described in the module docstring.

    universe : finite iterable of hashable states, in canonical order
               (witness pairs are earliest in this order).
    kappa    : carrier key; total on universe and margin.  P-fibers of U
               are the level sets of kappa on U.
    F        : the offered observable's ambient total function; f = F|_U.
    margin   : declared ambient sample of W (may overlap U; overlaps and
               duplicates are removed, order preserved).  None = no
               ambient world declared.
    require_revisit : GENUINE demands >= 1 margin revisit of an
               interpolated fiber (see docstring).  `certify_complete`
               turns this off for the identity observable, where a
               revisit-with-agreement is impossible by construction.
    """
    U = list(universe)
    Uset = set(U)
    if len(Uset) != len(U):
        raise ValueError("universe contains duplicate states")
    M = None
    if margin is not None:
        M, seen = [], set()
        for w in margin:
            if w not in Uset and w not in seen:
                seen.add(w)
                M.append(w)
    total = len(U) + (len(M) if M else 0)
    if total > budget:
        raise ValueError(f"enumeration budget exceeded: {total} > {budget}")

    # phase 1 — the descent law on U: FORMS or constant-on-fibers.
    rep = {}        # fiber key -> (earliest state, its F-value)
    sizes = {}      # fiber key -> |fiber|
    for x in U:
        k = kappa(x)
        v = F(x)
        sizes[k] = sizes.get(k, 0) + 1
        if k in rep:
            a, va = rep[k]
            if va != v:
                return {"verdict": FORMS, "witness": (a, x), "fiber": k,
                        "values": (va, v), "universe_size": len(U)}
        else:
            rep[k] = (x, v)
    g = {k: v for k, (_x, v) in rep.items()}
    base = {"universe_size": len(U), "fibers": len(g),
            "singleton_fibers": sum(1 for c in sizes.values() if c == 1)}

    if M is None:
        return {"verdict": UNDECIDED,
                "reason": "no ambient world declared; realizability of a "
                          "splitting pair cannot be decided from U alone",
                **base}
    if not M:
        return {"verdict": UNDECIDED,
                "reason": "ambient margin sample is empty (or entirely "
                          "inside U); constancy was never tested beyond U",
                **base}

    # phase 2 — the ambient scan: same law, U-representatives first, so a
    # collision's first endpoint is a U-state whenever the fiber meets U.
    amb = dict(rep)
    revisits = 0
    revisited = set()
    new_keys = 0
    for w in M:
        k = kappa(w)
        v = F(w)
        if k in amb:
            a, va = amb[k]
            if va != v:
                return {"verdict": VACUOUS, "witness": (a, w), "fiber": k,
                        "values": (va, v),
                        "witness_in_U": (a in Uset, False),
                        "margin_size": len(M), **base}
            revisits += 1
            revisited.add(k)
        else:
            amb[k] = (w, v)
            new_keys += 1
    if require_revisit and revisits == 0:
        return {"verdict": UNDECIDED,
                "reason": "margin sample never revisited a fiber; the "
                          "interpolated identity F = g(kappa) was not "
                          "tested at any point beyond its construction",
                "margin_size": len(M), "new_keys": new_keys, **base}
    return {"verdict": GENUINE, "g": g,
            "identity": "F = g(kappa), g interpolated on U, verified on "
                        "U plus the margin sample",
            "margin_size": len(M), "revisits": revisits,
            "revisited_fibers": len(revisited), "new_keys": new_keys,
            **base}


def certify_complete(genome, universe, next_world, evaluate, budget=BUDGET):
    """Certify a COMPLETE verdict (carrier discrete on `universe` under
    the genome's evaluation map) by look-ahead on `next_world`.

    COMPLETE == "the identity observable descends" (all fibers
    singletons), so this is `certify` with F = identity and the revisit
    requirement dropped (agreement of identity on a revisit would mean
    the same state twice — impossible after dedup — hence "no collision
    on the sample" is the entire ambient content).

    Verdicts: NOT-COMPLETE (precondition fails on U, witness pair),
    GENUINE-COMPLETE (key injective on U and the sampled next world),
    SHELL-LOCAL (a next-world state collides; witness pair),
    UNDECIDED-VACUOUS (no usable look-ahead sample; reason).
    """
    genome = list(genome)

    def key(s):
        return tuple(evaluate(t, s) for t in genome)

    r = certify(universe, key, lambda s: s, margin=next_world,
                require_revisit=False, budget=budget)
    v = r["verdict"]
    if v == FORMS:
        r["verdict"] = NOT_COMPLETE
        del r["values"]         # F is identity: the values ARE the pair
    elif v == GENUINE:
        r["verdict"] = GENUINE_COMPLETE
        del r["g"]  # for identity the interpolant is the inverse key
        # map itself; report its size, not the map
        r["identity"] = ("genome key injective on U and the sampled "
                         "next world")
        r["injective_on"] = r["universe_size"] + r["new_keys"]
    elif v == VACUOUS:
        r["verdict"] = SHELL_LOCAL
        del r["values"]         # F is identity: the values ARE the pair
    r["genome_size"] = len(genome)
    return r


# -------------------------------------------------------------------------
# instance (a): R0036 — the {-1,0,1} window at D = (1,2,4)
# -------------------------------------------------------------------------

def _tup(H):
    return tuple(map(tuple, H))


def instance_r0036_window():
    """Returns (vacuous_cert, genuine_cert) for D = (1,2,4).

    Universe U: all of GL_3(Z) with entries in {-1,0,1} (6960 matrices).
    Carrier kappa: true two-sided stabilizer membership (forced-partner
    integrality — the ground truth of the blind audit).

    vacuous_cert — offered observable: the MUTANT moduli table with the
    below-diagonal moduli 2, 4, 2 replaced by 997.  On the window every
    member has zero below-diagonal entries, so the mutant test agrees with
    truth pointwise and descends; the ambient margin of elementary
    certificates I + vE_ij (v >= 2, below-diagonal) contains I + 2E_10:
    a true member the mutant test rejects — the exhibited pair.

    genuine_cert — offered observable: the DERIVED gcd-moduli description
    m_ij = |d_i|/gcd(d_i,d_j) | H_ij.  Same universe, margin = elementary
    certificates at every off-diagonal position, v = 1..8: both fibers
    (member / non-member) are revisited, no collision — the description
    is certified genuine exactly where the mutant is certified vacuous.
    """
    from blind_audit_r0036 import (
        unimodular_3x3, in_stabilizer, corner_moduli, modulus_condition,
        general_corner_condition, elementary,
    )
    D = [1, 2, 4]
    U = [_tup(H) for H in unimodular_3x3(1)]
    kappa = lambda H: in_stabilizer(D, H)                    # noqa: E731

    true_mods = corner_moduli(D)          # below-diagonal: 2, 4, 2
    mutant = dict(true_mods)
    for ij in ((1, 0), (2, 0), (2, 1)):
        mutant[ij] = 997
    f_mutant = lambda H: modulus_condition(mutant, H)        # noqa: E731
    below_margin = [_tup(elementary(3, i, j, v))
                    for (i, j) in ((1, 0), (2, 0), (2, 1))
                    for v in range(2, 9)]
    vac = certify(U, kappa, f_mutant, margin=below_margin)

    f_derived = lambda H: general_corner_condition(D, H)     # noqa: E731
    full_margin = [_tup(elementary(3, i, j, v))
                   for (i, j) in sorted(true_mods)
                   for v in range(1, 9)]
    gen = certify(U, kappa, f_derived, margin=full_margin)
    return vac, gen


# -------------------------------------------------------------------------
# instance (b): the nat trace — span vacuity vs the CRT identity
# -------------------------------------------------------------------------

def nat_profile(sensors):
    """The fine carrier of the nat bridge: joint residue profile."""
    sensors = tuple(sensors)
    return lambda k: tuple(k % p for p in sensors)


def instance_nat_mod11(margin_hi=340):
    """mod-11 on U = {2..121} over the joint profile of {2,3,5,7}.

    L = 210 > 119 = |U| - 1: the profile is injective on U, all 120
    fibers are singletons, mod-11 descends.  Ambient world: N itself;
    margin {122..margin_hi-1}.  The bridge's trichotomy says vacuous with
    ambient pair (2, 2+210): same profile, 2 mod 11 = 2 != 3 = 212 mod 11.
    The certificate exhibits exactly that pair.
    """
    return certify(list(range(2, 122)), nat_profile((2, 3, 5, 7)),
                   lambda k: k % 11, margin=range(122, margin_hi))


def instance_nat_mod6():
    """mod-6 on U = {2..36} over the joint profile of {2,3,5} (the
    life's sensor state at trigger 36).  6 | L = 30: the CRT identity
    k mod 6 = g(k mod 2, k mod 3, k mod 5) holds on all of N.  Margin =
    {37..96}, two further periods: every margin state revisits an
    interpolated fiber and agrees — GENUINE with the explicit g
    (30 fiber keys, the CRT interpolant)."""
    return certify(list(range(2, 37)), nat_profile((2, 3, 5)),
                   lambda k: k % 6, margin=range(37, 97))


def instance_nat_mod4_forms():
    """mod-4 on U = {2..16} over the joint profile of {2,3}: FORMS with
    the bridge's canonical witness (2, 8) — the certificate's FORMS
    branch coincides with the descent law's own earliest pair."""
    return certify(list(range(2, 17)), nat_profile((2, 3)),
                   lambda k: k % 4)


# -------------------------------------------------------------------------
# instance (c): the living machine's COMPLETE verdict
# -------------------------------------------------------------------------

import living_machine as _lm  # noqa: E402  (the machine's own evaluator)

LIVING_GENOME = list(_lm.ENTRIES) + [("det",)] + list(_lm.HENTRIES)


def living_universe(epoch, bound):
    """The machine's own world at (epoch, bound): shell(bound) states
    paired with h_family(epoch) payloads, in the machine's own order."""
    saved = _lm.H_SET
    try:
        _lm.H_SET = _lm.h_family(epoch)
        return list(_lm.shell(bound))
    finally:
        _lm.H_SET = saved


def living_evaluator(bits):
    """The machine's own `ev` with the port granted `bits` bits (hentry
    sees h mod 2^bits).  Restores the machine's globals after each call."""
    def evaluate(term, state):
        saved_bits, saved_port = _lm.PORT_BITS[0], _lm.PORTED[0]
        _lm.PORT_BITS[0] = bits
        _lm.PORTED[0] = bits > 0
        try:
            return _lm.ev(term, state)
        finally:
            _lm.PORT_BITS[0], _lm.PORTED[0] = saved_bits, saved_port
    return evaluate


def instance_living_complete(bits, epoch=0, bound=1,
                             next_epoch=1, next_bound=2):
    """Certify a COMPLETE verdict of the living machine by look-ahead.

    Universe: the machine's world at (epoch, bound) — 400 states at the
    defaults.  Genome: entries + det + hentries (the full coordinate
    genome the machine earns before a COMPLETE).  Next world: the SAME
    shell under the deeper fiber family h_family(next_epoch), plus the
    bigger shell(next_bound) under it — exactly the two growth directions
    the machine takes after logging COMPLETE.

      bits=0 : hentries are blind — carrier not discrete: NOT-COMPLETE.
      bits=2 : all 5 epoch-0 payloads distinct mod 4 — COMPLETE on the
               shell; but epoch-1 adds the shear k=4, and (1,4;0,1) is
               the identity mod 4: SHELL-LOCAL, witness ((m,I),(m,shear)).
      bits=5 : epoch-1 entries reach only 8 < 32 — injective on the whole
               look-ahead: GENUINE-COMPLETE.
    """
    U = living_universe(epoch, bound)
    look_ahead = (living_universe(next_epoch, bound)
                  + living_universe(next_epoch, next_bound))
    return certify_complete(LIVING_GENOME, U, look_ahead,
                            living_evaluator(bits))


# -------------------------------------------------------------------------
# demonstration
# -------------------------------------------------------------------------

def _brief(cert):
    c = dict(cert)
    if "g" in c:
        c["g"] = f"<interpolant on {len(c['g'])} fiber keys>"
    return c


def main():
    print("=== (a) R0036 window, D = (1,2,4) ===")
    vac, gen = instance_r0036_window()
    print("mutant moduli (below-diagonal -> 997):", _brief(vac))
    print("derived gcd moduli                  :", _brief(gen))
    print()
    print("=== (b) nat trace ===")
    print("mod-4 over {2,3} on {2..16}    :", _brief(instance_nat_mod4_forms()))
    print("mod-11 over {2,3,5,7} on {2..121}:", _brief(instance_nat_mod11()))
    print("mod-6 over {2,3,5} on {2..36}  :", _brief(instance_nat_mod6()))
    print()
    print("=== (c) living machine COMPLETE, epoch 0 bound 1 ===")
    for bits in (0, 2, 5):
        c = instance_living_complete(bits)
        print(f"bits={bits}:", _brief(c))


if __name__ == "__main__":
    main()
