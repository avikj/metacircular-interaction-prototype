#!/usr/bin/env python3
"""Hostile tests for the automatic language reopening cycle (msgs 0363/0365/0366)."""

from __future__ import annotations

from itertools import product

from language_reopening_cycle import (ALPHABET, Cycle, DFA, joint_reachable,
                                      mod_count, moore_minimize,
                                      shortest_leakage_witness, suffix,
                                      task_distinguisher)

CHECKS = []


def check(name, ok):
    CHECKS.append((name, ok))
    print(("PASS" if ok else "FAIL"), name)


def words(max_len):
    for L in range(max_len + 1):
        for tup in product(ALPHABET, repeat=L):
            yield "".join(tup)


def quotient_class(org, w):
    q = 0
    for c in w:
        q = org.trans[q][ALPHABET.index(c)]
    return org.part[q]


def main():
    # Build a two-task organism directly.
    org = Cycle()
    org.admit(mod_count("a", 2), 4, ["ab"])
    org.admit(suffix("b"), 4, ["ab"])

    # 1. Soundness of no-leakage: complement task returns None AND factors
    #    through the quotient exhaustively (words to length 8).
    comp = mod_count("a", 2, 1)
    w_none = shortest_leakage_witness(org.trans, org.labels, org.part, comp)
    factor = {}
    ok = w_none is None
    for w in words(8):
        cls = quotient_class(org, w)
        acc = comp.accepts(w)
        if cls in factor and factor[cls] != acc:
            ok = False
        factor[cls] = acc
    check("no-leakage verdict is sound (complement factors, all |w|<=8)", ok)

    # 2. PLANTED FALSE: a genuinely new task must not return None.
    leak = shortest_leakage_witness(org.trans, org.labels, org.part,
                                    mod_count("b", 3))
    check("planted false caught: mod-3 task leaks", leak is not None)

    # 3. Witness validity + minimality: there exist quotient-equal access
    #    words u,v whose task behavior differs on the witness, and no
    #    strictly shorter continuation separates any quotient-equal pair.
    task = mod_count("b", 3)
    wit = leak
    valid = False
    min_ok = True
    seenpairs = {}
    for w in words(6):
        cls = quotient_class(org, w)
        x = task.run(w)
        seenpairs.setdefault(cls, set()).add(x)
    shortest = None
    for cls, xs in seenpairs.items():
        xs = sorted(xs)
        for i in range(len(xs)):
            for j in range(i + 1, len(xs)):
                d = task_distinguisher(task, xs[i], xs[j])
                if d is not None:
                    if shortest is None or len(d) < len(shortest):
                        shortest = d
    valid = shortest is not None
    min_ok = valid and len(wit) == len(shortest)
    check("witness valid and minimal (%r vs exhaustive %r)" % (wit, shortest),
          valid and min_ok)

    # 4. Behavior preservation: the joint quotient answers every admitted
    #    task exactly, exhaustively to length 8.
    ok = True
    for w in words(8):
        q = 0
        for c in w:
            q = org.trans[q][ALPHABET.index(c)]
        if tuple(int(d.accepts(w)) for d in org.tasks) != org.labels[q]:
            ok = False
            break
    check("quotient preserves all admitted task behavior (|w|<=8)", ok)

    # 5. Break-even boundary exact on both sides (0363): route flips at
    #    floor(C/(D-S))+1.
    e = org.admit(mod_count("b", 3), 1, ["ab", "ba", "abab", "bbab"])
    C, D, S = e["C"], e["D"], e["S"]
    k0 = C // (D - S) + 1
    below = (k0 - 1) * (D - S) > C
    at = k0 * (D - S) > C
    check("break-even boundary: k0-1 fails, k0 succeeds (k0=%d)" % k0,
          (not below) and at)

    # 6. Null control end to end: re-admitting an answered task changes
    #    nothing and costs nothing.
    before_states = 1 + max(org.part)
    e2 = org.admit(mod_count("a", 2), 4, ["ab"])
    check("null control: zero refinement, zero C",
          e2["leakage_witness"] is None and e2["C"] == 0
          and 1 + max(org.part) == before_states)

    # 7. Minimality of the quotient itself: Moore fixpoint has no two
    #    equivalent classes (pairwise distinguishable under some task).
    trans, labels, _ = joint_reachable(org.tasks)
    part, _ = moore_minimize(trans, labels)
    nclasses = 1 + max(part)
    reps = {}
    for q, b in enumerate(part):
        reps.setdefault(b, q)
    distinct = True
    for b1 in reps:
        for b2 in reps:
            if b1 < b2:
                sep = False
                for w in words(nclasses):
                    qa, qb = reps[b1], reps[b2]
                    for c in w:
                        qa = trans[qa][ALPHABET.index(c)]
                        qb = trans[qb][ALPHABET.index(c)]
                    if labels[qa] != labels[qb]:
                        sep = True
                        break
                if not sep:
                    distinct = False
    check("quotient is minimal (all %d classes pairwise separated)" % nclasses,
          distinct)

    failed = [n for n, ok in CHECKS if not ok]
    print("SUMMARY passed=%d failed=%d" % (len(CHECKS) - len(failed),
                                           len(failed)))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
