#!/usr/bin/env python3
"""Independent verification by finite model search.

The engine produces its verdicts by *syntax* -- completion, critical pairs,
rewriting. Re-running that machinery is repetition, not verification. This
module checks the same verdicts by *semantics*: brute-force enumeration of
all structures on a small domain.

The two methods share nothing. A verdict confirmed by both was reached by
completion and by counting, which is the only kind of agreement worth having
here.

What each verdict predicts, and how a model refutes it:

    SUCCEEDED        every model of T is a model of S.
                     REFUTED by one T-model failing S.

    IMPOSSIBLE       T together with S has only one-element models.
                     REFUTED by one model of size >= 2 satisfying both.

    STRICTLY_WEAKER  some model of T fails S (that is the content), and
                     models of size >= 2 satisfying both DO exist.
                     REFUTED if every T-model satisfies S.

Domain sizes 2 and 3 are enough to refute; they can never *prove* a
universal statement, and this module never claims they do. A verdict that
survives is CONSISTENT WITH the models tried, which is exactly as strong as
it sounds and no stronger.
"""

from __future__ import annotations

import sys
from itertools import product
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import Term  # noqa: E402
from machinery.crystal.theories import LIBRARY  # noqa: E402


def _vars(t: Term, acc: set) -> set:
    if t.is_var:
        acc.add(t.head)
    for a in t.args:
        _vars(a, acc)
    return acc


def _eval(t: Term, interp: dict, env: dict) -> int:
    """Evaluate a term in a finite structure. `interp` maps (sym,arity) to a
    table; `env` maps variable names to domain elements."""
    if t.is_var:
        return env[t.head]
    key = (t.head, len(t.args))
    args = tuple(_eval(a, interp, env) for a in t.args)
    return interp[key][args]


def structures(sig: set, n: int):
    """Every interpretation of `sig` on the domain {0..n-1}. Exhaustive."""
    syms = sorted(sig)
    tables = []
    for s, ar in syms:
        cells = n ** ar
        tables.append([dict(zip(product(range(n), repeat=ar), vals))
                       for vals in product(range(n), repeat=cells)])
    for combo in product(*tables):
        yield {syms[i]: combo[i] for i in range(len(syms))}


def satisfies(interp: dict, axioms: list, n: int) -> bool:
    for _, l, r in axioms:
        vs = sorted(_vars(l, set()) | _vars(r, set()))
        for vals in product(range(n), repeat=len(vs)):
            env = dict(zip(vs, vals))
            if _eval(l, interp, env) != _eval(r, interp, env):
                return False
    return True


def models(theory: str, n: int, extra_sig: set = frozenset()):
    """Every model of `theory` on n elements, over its signature widened by
    `extra_sig` (so a source theory's symbols are present when needed)."""
    ax, sig = LIBRARY[theory]
    for interp in structures(set(sig) | set(extra_sig), n):
        if satisfies(interp, ax, n):
            yield interp


def check(src: str, tgt: str, verdict: str, sizes=(2, 3)) -> dict:
    """Verify one engine verdict semantically. Identity map only."""
    s_ax, s_sig = LIBRARY[src]
    t_ax, t_sig = LIBRARY[tgt]
    sig = set(s_sig) | set(t_sig)

    t_models = 0
    t_models_failing_s = []
    joint_nontrivial = []

    for n in sizes:
        for interp in structures(sig, n):
            if not satisfies(interp, t_ax, n):
                continue
            t_models += 1
            sat_s = satisfies(interp, s_ax, n)
            if not sat_s and len(t_models_failing_s) < 2:
                t_models_failing_s.append((n, interp))
            if sat_s:
                # a joint model; nontrivial iff the carrier is not collapsed,
                # i.e. some operation actually distinguishes two elements
                if _nontrivial(interp, n):
                    if len(joint_nontrivial) < 2:
                        joint_nontrivial.append((n, interp))

    if verdict == "SUCCEEDED":
        ok = not t_models_failing_s
        why = ("every model of the target satisfies the source"
               if ok else "a target model FAILS the source")
    elif verdict == "IMPOSSIBLE":
        ok = not joint_nontrivial
        why = ("no nontrivial model satisfies both"
               if ok else "a nontrivial JOINT model exists")
    elif verdict == "STRICTLY_WEAKER":
        ok = bool(t_models_failing_s) and bool(joint_nontrivial)
        why = ("a target model fails the source, and a joint model exists"
               if ok else "no separating model, or no joint model")
    else:
        return {"verdict": verdict, "status": "NOT_CHECKED",
                "why": "no semantic prediction for this verdict"}

    return {"verdict": verdict, "status": "CONSISTENT" if ok else "REFUTED",
            "why": why, "target_models": t_models,
            "counterexample": t_models_failing_s[0] if t_models_failing_s else None,
            "joint": joint_nontrivial[0] if joint_nontrivial else None}


def _nontrivial(interp: dict, n: int) -> bool:
    """A model is trivial if the whole carrier is forced equal. On a domain
    of n >= 2 elements the structure itself is never degenerate -- the
    carrier has n distinct elements by construction -- so any model on n >= 2
    witnesses that x = y is NOT derivable."""
    return n >= 2
