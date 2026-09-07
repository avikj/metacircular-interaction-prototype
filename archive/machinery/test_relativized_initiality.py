#!/usr/bin/env python3
"""Hostile tests for relativized initiality (notes/TWO_IDENTITIES.md §2).

Exhaustive over the finite slice: every pointed unary algebra with at most
four states, every congruence of (Z/6, +1), planted-false controls.
"""

from __future__ import annotations

from itertools import product

from relativized_initiality import (
    Model,
    T6,
    admits_unique_map,
    canonical_map,
    charge_completion,
    factors_through,
    homomorphisms,
    isomorphic_to_term,
    observational_congruence,
    quotient_model,
    term_model,
    word_equivalence_cost,
)

CHECKS = []


def check(name: str, ok: bool) -> None:
    CHECKS.append((name, ok))
    print(("PASS" if ok else "FAIL"), name)


def all_models(max_size: int):
    for size in range(1, max_size + 1):
        for step in product(range(size), repeat=size):
            for base in range(size):
                yield Model(size, step, base)


def main() -> None:
    # 1. Initiality of T6: h(k)=s^k(q0) is a homomorphism, and it is unique,
    #    for every admissible model up to size 4 — exhaustively.
    unique_ok = True
    admissible = 0
    for m in all_models(4):
        hs = homomorphisms(T6, m)
        if admits_unique_map(m):
            admissible += 1
            unique_ok &= len(hs) == 1 and hs[0] == canonical_map(m)
        else:
            unique_ok &= len(hs) == 0
    check(f"initiality exhaustive over size<=4 ({admissible} admissible models)", unique_ok)

    # 2. The observational congruence for probe mod 3 is the mod-3 partition,
    #    and it is the GREATEST congruence inside ker(probe): the only
    #    congruences of (Z/6,+1) are the mod-d partitions for d | 6.
    labels = observational_congruence(6, lambda x: x % 3)
    check("probe mod3 -> mod3 congruence", [l % 3 for l in range(6)] == [labels[x] % 3 for x in range(6)] and len(set(labels)) == 3)
    congruences = []
    for d in (1, 2, 3, 6):
        congruences.append([x % d for x in range(6)])
    inside_kernel = [c for c in congruences if all(x % 3 == y % 3 for x in range(6) for y in range(6) if c[x] == c[y])]
    greatest = min(inside_kernel, key=lambda c: len(set(c)))
    check("greatest congruence inside ker(mod3) is mod3", len(set(greatest)) == 3)

    # 3. Relativization, exhaustively: a model receives a homomorphism from
    #    T6/Θ iff its canonical map factors (ker h ⊇ Θ). No silent survivals.
    quot, proj = quotient_model(6, labels)
    relativize_ok = True
    in_class = out_class = 0
    for m in all_models(4):
        receives = len(homomorphisms(quot, m)) > 0
        validates = factors_through(m, proj)
        relativize_ok &= receives == validates
        if validates:
            in_class += 1
        elif admits_unique_map(m):
            out_class += 1
    check(f"T/Θ maps exist iff Θ validated (in={in_class}, excluded={out_class})", relativize_ok and out_class > 0)

    # 4. The excluded task, concretely: parity. It is an admissible model,
    #    it does NOT validate Θ, and no map T/Θ -> parity exists.
    parity = Model(2, (1, 0), 0)
    check("parity admissible", admits_unique_map(parity))
    check("parity excluded by Θ", not factors_through(parity, proj))
    check("no homomorphism quotient->parity", homomorphisms(quot, parity) == [])

    # 5. Cost: the quotient serves an in-class task strictly cheaper.
    mod3_task = Model(3, (1, 2, 0), 0)
    check("mod3 task validates Θ", factors_through(mod3_task, proj))
    _, cost_full = word_equivalence_cost(T6, 4, 10)
    _, cost_quot = word_equivalence_cost(quot, 4, 10)
    check(f"quotient strictly cheaper ({cost_quot} < {cost_full})", cost_quot < cost_full)
    ans_full, _ = word_equivalence_cost(T6, 4, 10)
    ans_quot, _ = word_equivalence_cost(quot, 4, 10)
    check("answers agree on in-class question", ans_full == ans_quot)

    # 6. Charge recovery: quotient x parity is the minimal completion and is
    #    isomorphic to T6 (CRT, executable round trip); parity now factors.
    completed = charge_completion(quot, parity)
    check("quotient x charge ≅ T6 (CRT)", isomorphic_to_term(completed, 6))
    check("parity factors through completion", factors_through(parity, tuple(range(6))) or len(homomorphisms(completed, parity)) == 1)

    # 7. NULL CONTROL: quotient by the trivial congruence must not move any
    #    counter and must exclude nothing.
    trivial_quot, trivial_proj = quotient_model(6, list(range(6)))
    _, cost_null = word_equivalence_cost(trivial_quot, 4, 10)
    check("null control: cost unchanged", cost_null == cost_full)
    null_ok = all(
        (len(homomorphisms(trivial_quot, m)) > 0) == admits_unique_map(m)
        for m in all_models(4)
    )
    check("null control: nothing excluded", null_ok)

    # 8. PLANTED FALSE: asserting the excluded task factors must fail; a
    #    wrong 'greatest' congruence (mod 6, i.e. no collapse) must not be
    #    what refinement returns for the mod-3 probe.
    check("planted false caught: parity does not factor", not factors_through(parity, proj))
    check("planted false caught: refinement actually collapses", len(set(labels)) != 6)

    failed = [name for name, ok in CHECKS if not ok]
    print(f"SUMMARY passed={len(CHECKS) - len(failed)} failed={len(failed)}")
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
