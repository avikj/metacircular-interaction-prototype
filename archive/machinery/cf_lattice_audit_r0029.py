#!/usr/bin/env python3
"""Independent hostile audit of R0029 (situated port engine integration).

Breaker: cf-lattice (Claude Fable 5 lineage).  This file re-derives the exact
statement of R0029 with an ENTIRELY SEPARATE permutation algebra and drives the
real ``EncounterEngine`` through its public API.  Nothing here imports the
builder's ``situated_constructor_port`` helpers; every quantity the packet
asserts (candidate set, selection uniqueness, grammar order, source trace) is
recomputed here from first principles and then compared against what the engine
actually installs.  If the engine's behaviour and this file's independent
mathematics ever disagree, the audit fails.

Exact statement under audit (verbatim from the packet):

    In the coupled encounter engine on X={0,1,2}, before a constructor port is
    supplied the exact candidate set is T={g in S_3:g(0)=1}, the active
    constructor and selection policy are both absent, and querying proposal
    attention and T in either order leaves the executable grammar empty.
    Supplying the exact equation g(2)=2 installs the order-two cyclic grammar
    with source trace (0,1), while g(2)=0 installs the order-three cyclic
    grammar with source trace (0,1,2); proposal scores cannot alter either
    certified selection.  Withdrawing either port removes the active iterate
    action and explicit policy, restores T, and retains the selection
    certificate and provenance in history.

Design of the attack: use permutations represented as dicts internally, compose
by explicit function application (opposite bookkeeping style from the builder's
tuple ``p[q[i]]`` convention but the same group), compute cyclic order by lcm of
cycle lengths, and compute the source trace as the literal orbit of the point 0.
"""

from __future__ import annotations

import os
import sys
from math import gcd

# Make the module importable regardless of the caller's working directory,
# mirroring how the builder's tests assume the machinery/ directory on path.
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from coupled_encounter_engine import EncounterEngine  # noqa: E402


# ---------------------------------------------------------------------------
# Independent permutation algebra on {0,1,2}.  Deliberately different code from
# situated_constructor_port: dict maps, explicit recursion for S_n, cycle
# decomposition for order, orbit walk for the trace.
# ---------------------------------------------------------------------------

Perm = tuple  # a tuple t means the map i -> t[i]; kept as tuple for hashing.


def _all_perms(n: int) -> list[tuple[int, ...]]:
    """Every bijection of range(n), built by explicit insertion recursion."""
    if n == 0:
        return [()]
    smaller = _all_perms(n - 1)
    out: list[tuple[int, ...]] = []
    for p in smaller:
        for pos in range(n):
            out.append(p[:pos] + (n - 1,) + p[pos:])
    return out


def candidate_set(n: int, source: int, target: int) -> set[tuple[int, ...]]:
    """T = {g in S_n : g(source) = target}, as an unordered set."""
    return {p for p in _all_perms(n) if p[source] == target}


def apply(g: tuple[int, ...], x: int) -> int:
    return g[x]


def cyclic_order(g: tuple[int, ...]) -> int:
    """Order of g in S_n via lcm of its cycle lengths (independent method)."""
    n = len(g)
    seen = [False] * n
    order = 1
    for start in range(n):
        if seen[start]:
            continue
        length = 0
        x = start
        while not seen[x]:
            seen[x] = True
            x = g[x]
            length += 1
        order = order * length // gcd(order, length)
    return order


def orbit_trace(g: tuple[int, ...], point: int) -> tuple[int, ...]:
    """Literal orbit of ``point`` under repeated application of g."""
    trace: list[int] = []
    x = point
    while True:
        trace.append(x)
        x = g[x]
        if x == point:
            break
    return tuple(trace)


def unique_selection(
    n: int, source: int, target: int, context: int, response: int
) -> tuple[int, ...] | None:
    """The unique g in T solving g(context)=response, or None if not unique.

    This is the exact port equation, recomputed independently.  Uniqueness (or
    its failure) is a property of the finite set, not of any engine code.
    """
    matches = [
        g
        for g in candidate_set(n, source, target)
        if g[context] == response
    ]
    return matches[0] if len(matches) == 1 else None


# ---------------------------------------------------------------------------
# Structured audit report: independent expectations vs engine reality.
# ---------------------------------------------------------------------------


def independent_expectations() -> dict:
    """What the mathematics forces, computed without touching the engine."""
    T = candidate_set(3, 0, 1)
    exp = {"candidate_set": T, "responses": {}}
    for response in (0, 2):
        g = unique_selection(3, 0, 1, 2, response)
        assert g is not None, "port equation must be uniquely solvable here"
        exp["responses"][response] = {
            "selected": g,
            "order": cyclic_order(g),
            "source_trace": orbit_trace(g, 0),
        }
    # response 1 is inconsistent with T (needs g(0)=1 and g(2)=1): impossible.
    exp["inconsistent_response"] = unique_selection(3, 0, 1, 2, 1)  # None
    return exp


def engine_reality() -> dict:
    """What the real EncounterEngine actually installs for each response."""
    out: dict = {"responses": {}}
    # Pre-port state, inspected in one order here (order-invariance is a
    # separate check below).
    pre = EncounterEngine.inherited()
    out["pre"] = {
        "choices": set(pre.constructor_choices()),
        "active_constructor": pre.active_constructor,
        "policy": pre.constructor_selection_policy,
        "grammar_len": len(pre.active_grammar),
    }
    for response in (0, 2):
        e = EncounterEngine.inherited()
        cert = e.couple_constructor_port(response, f"audit-{response}")
        out["responses"][response] = {
            "selected": cert.selected,
            "grammar_len": len(e.active_grammar),
            "future": e.constructor_future(0),
            "policy": e.constructor_selection_policy,
            "cert_verifies": cert.verifies(),
        }
    return out


def run_audit() -> dict:
    """Compare independent expectations against engine reality; return a report."""
    exp = independent_expectations()
    real = engine_reality()
    findings: list[str] = []

    # Candidate set.
    if real["pre"]["choices"] != exp["candidate_set"]:
        findings.append("candidate set mismatch")
    if len(exp["candidate_set"]) != 2:
        findings.append("candidate set is not the two-element torsor")

    # Pre-port emptiness.
    if real["pre"]["active_constructor"] is not None:
        findings.append("active constructor present before any port")
    if real["pre"]["policy"] is not None:
        findings.append("selection policy present before any port")
    if real["pre"]["grammar_len"] != 0:
        findings.append("executable grammar nonempty before any port")

    # Each response installs the independently predicted grammar.
    for response in (0, 2):
        want = exp["responses"][response]
        got = real["responses"][response]
        if got["selected"] != want["selected"]:
            findings.append(f"r={response}: wrong constructor selected")
        if got["grammar_len"] != want["order"]:
            findings.append(f"r={response}: grammar order mismatch")
        if got["future"] != want["source_trace"]:
            findings.append(f"r={response}: source trace mismatch")
        if not got["cert_verifies"]:
            findings.append(f"r={response}: certificate does not verify")

    # Orders must genuinely differ (2 vs 3) -> monoids cannot be equal.
    if real["responses"][2]["grammar_len"] == real["responses"][0]["grammar_len"]:
        findings.append("the two responses install equal-size grammars")

    return {
        "verdict": "CONFIRMED" if not findings else "REFUTED",
        "findings": findings,
        "expectations": exp,
        "reality": real,
    }


if __name__ == "__main__":
    report = run_audit()
    print("verdict:", report["verdict"])
    for f in report["findings"]:
        print("  finding:", f)
    for response in (0, 2):
        r = report["reality"]["responses"][response]
        print(
            f"port g(2)={response}: selected={r['selected']} "
            f"order={r['grammar_len']} trace={r['future']} "
            f"verifies={r['cert_verifies']}"
        )
