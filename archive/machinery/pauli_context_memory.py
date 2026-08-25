#!/usr/bin/env python3
"""Exact memory states of a sequential Pauli-measurement process.

Everything here is exact: signs live in ``{+1,-1}``, symplectic vectors in
``F_2^{2n}``, probabilities in ``fractions.Fraction``.  No floating point and
no numerical linear algebra enter any certificate.

A Hermitian Pauli observable is written

    W(x,z) = i^(x . z) X^x Z^z ,

with ``x . z`` the *integer* dot product of the 0/1 vectors.  Every ``W(x,z)``
is Hermitian and squares to the identity.  A signed observable is a pair
``(s, (x, z))`` with ``s in {+1,-1}``.

A memory state of the process is a stabilizer group: a subgroup ``S`` of the
signed Hermitian Pauli group with ``-I not in S``.  It represents the density
matrix ``rho_S = 2^-n sum_{g in S} g``.  The maximally mixed state is the
trivial group.

See ``notes/PAULI_MEMORY_LAGRANGIAN.md``.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import product
from typing import Dict, FrozenSet, Iterable, List, Sequence, Tuple

Vector = Tuple[int, ...]
Symplectic = Tuple[Vector, Vector]
Signed = Tuple[int, Symplectic]
Group = FrozenSet[Signed]


# --------------------------------------------------------------------------
# exact signed Pauli arithmetic
# --------------------------------------------------------------------------


def _dot(u: Vector, v: Vector) -> int:
    return sum(a * b for a, b in zip(u, v))


def _xor(u: Vector, v: Vector) -> Vector:
    return tuple(a ^ b for a, b in zip(u, v))


def identity(n: int) -> Signed:
    zero = tuple([0] * n)
    return (1, (zero, zero))


def commute(a: Symplectic, b: Symplectic) -> bool:
    """Symplectic form ``<a,b> = x_a . z_b + x_b . z_a`` vanishes mod 2."""
    (xa, za), (xb, zb) = a, b
    return (_dot(xa, zb) + _dot(xb, za)) % 2 == 0


def multiply(a: Signed, b: Signed) -> Signed:
    """Product of two *commuting* signed Hermitian Paulis.

    Raises if the arguments anticommute, since then the product is
    anti-Hermitian and leaves the represented set.
    """
    sa, (xa, za) = a
    sb, (xb, zb) = b
    if not commute((xa, za), (xb, zb)):
        raise ValueError("multiply is defined on commuting Paulis only")
    xc, zc = _xor(xa, xb), _xor(za, zb)
    # i^(xa.za) i^(xb.zb) (-1)^(za.xb) = phase * i^(xc.zc)
    exponent = _dot(xa, za) + _dot(xb, zb) - _dot(xc, zc)
    phase = 2 * _dot(za, xb) + exponent
    if phase % 4 not in (0, 2):
        raise AssertionError("commuting product must be real")
    sign = 1 if phase % 4 == 0 else -1
    return (sa * sb * sign, (xc, zc))


def generate(gens: Iterable[Signed], n: int) -> Group:
    """Subgroup closure of pairwise commuting signed Paulis."""
    elements = {identity(n)}
    frontier = list(elements)
    gens = list(gens)
    while frontier:
        new = []
        for g in frontier:
            for h in gens:
                p = multiply(g, h)
                if p not in elements:
                    elements.add(p)
                    new.append(p)
        frontier = new
    if any(s == -1 and all(v == 0 for v in x + z) for s, (x, z) in elements):
        raise ValueError("generated group contains -I")
    return frozenset(elements)


# --------------------------------------------------------------------------
# ideal (projective, repeatable) measurement of a Pauli observable
# --------------------------------------------------------------------------


def measure(state: Group, obs: Symplectic, n: int) -> List[Tuple[Fraction, int, Group]]:
    """Ideal measurement of ``W(obs)``: list of ``(probability, outcome, state')``."""
    for sign, vec in state:
        if vec == obs:
            return [(Fraction(1), sign, state)]
    kept = [g for g in state if commute(g[1], obs)]
    outcomes = []
    for outcome in (1, -1):
        new = generate(list(kept) + [(outcome, obs)], n)
        outcomes.append((Fraction(1, 2), outcome, new))
    return outcomes


def reachable(start: Group, observables: Sequence[Symplectic], n: int) -> List[Group]:
    """All memory states reachable from ``start`` by the admitted measurements."""
    seen = {start}
    frontier = [start]
    while frontier:
        nxt = []
        for state in frontier:
            for obs in observables:
                for _, _, succ in measure(state, obs, n):
                    if succ not in seen:
                        seen.add(succ)
                        nxt.append(succ)
        frontier = nxt
    return sorted(seen, key=lambda g: (len(g), sorted(g)))


def recurrent(states: Sequence[Group], observables: Sequence[Symplectic], n: int) -> List[Group]:
    """States lying on a cycle of the reachability digraph (the recurrent set).

    Computed as the union of the terminal strongly connected components, by
    iterated removal of states that cannot be re-entered.
    """
    index = {s: i for i, s in enumerate(states)}
    edges = {i: set() for i in range(len(states))}
    for state in states:
        for obs in observables:
            for _, _, succ in measure(state, obs, n):
                edges[index[state]].add(index[succ])
    # keep only vertices reachable from themselves through >=1 step
    alive = set(range(len(states)))
    changed = True
    while changed:
        changed = False
        for v in list(alive):
            stack, seen = [w for w in edges[v] if w in alive], set()
            found = False
            while stack:
                w = stack.pop()
                if w == v:
                    found = True
                    break
                if w in seen:
                    continue
                seen.add(w)
                stack.extend(u for u in edges[w] if u in alive)
            if not found:
                alive.discard(v)
                changed = True
    return [states[i] for i in sorted(alive)]


# --------------------------------------------------------------------------
# exact predictive (causal-state) quotient
# --------------------------------------------------------------------------


def predictive_quotient(
    states: Sequence[Group], observables: Sequence[Symplectic], n: int
) -> List[List[Group]]:
    """Partition states by equality of all future measurement statistics.

    Exact Hopcroft/Moore-style refinement on the measurement-labelled Markov
    decision process.  Two states are merged only if, for every observable,
    they give the same outcome distribution and land in the same blocks with
    the same probabilities -- the greatest bisimulation, which for a
    deterministic-observation process coincides with equality of conditional
    future distributions over all finite measurement sequences.
    """
    block = {s: 0 for s in states}
    while True:
        signature: Dict[Group, tuple] = {}
        for s in states:
            row = []
            for obs in observables:
                cell = tuple(
                    sorted((prob, outcome, block[succ]) for prob, outcome, succ in measure(s, obs, n))
                )
                row.append(cell)
            signature[s] = (block[s], tuple(row))
        labels = {sig: i for i, sig in enumerate(sorted(set(signature.values())))}
        new_block = {s: labels[signature[s]] for s in states}
        if new_block == block:
            break
        block = new_block
    classes: Dict[int, List[Group]] = {}
    for s in states:
        classes.setdefault(block[s], []).append(s)
    return [classes[k] for k in sorted(classes)]


# --------------------------------------------------------------------------
# scenarios
# --------------------------------------------------------------------------


def pauli(label: str) -> Symplectic:
    """Parse a Pauli word such as ``"XY"`` into its symplectic vector."""
    x, z = [], []
    for letter in label:
        x.append(1 if letter in "XY" else 0)
        z.append(1 if letter in "ZY" else 0)
    return (tuple(x), tuple(z))


PERES_MERMIN_ROWS = [
    ["XI", "IX", "XX"],
    ["IY", "YI", "YY"],
    ["XY", "YX", "ZZ"],
]

PERES_MERMIN_CONTEXTS = [list(r) for r in PERES_MERMIN_ROWS] + [
    [PERES_MERMIN_ROWS[r][c] for r in range(3)] for c in range(3)
]

PERES_MERMIN = [w for row in PERES_MERMIN_ROWS for w in row]


def all_paulis(n: int) -> List[Symplectic]:
    vectors = []
    for bits in product((0, 1), repeat=2 * n):
        x, z = bits[:n], bits[n:]
        if any(x) or any(z):
            vectors.append((x, z))
    return vectors


def lagrangians(observables: Sequence[Symplectic], n: int) -> List[FrozenSet[Symplectic]]:
    """Maximal isotropic subspaces of ``F_2^(2n)`` all of whose nonzero
    elements are admitted observables (the *contexts* of the scenario).

    Enumerated by exhaustive isotropic-subspace growth; ``n`` is small.
    """
    admitted = set(observables)
    zero = (tuple([0] * n), tuple([0] * n))
    found = set()

    def grow(span: FrozenSet[Symplectic]) -> None:
        extensions = [
            v
            for v in admitted
            if v not in span and all(commute(v, w) for w in span)
        ]
        maximal = True
        for v in extensions:
            new = set(span)
            for w in list(span):
                new.add((_xor(v[0], w[0]), _xor(v[1], w[1])))
            new.add(v)
            new.discard(zero)
            if not new <= admitted:
                continue
            maximal = False
            grow(frozenset(new))
        if maximal and span:
            found.add(span)

    grow(frozenset())
    return sorted(found, key=sorted)


def context_signs(context: Sequence[str]) -> int:
    """Exact product of the three Hermitian Paulis of a commuting context."""
    acc = (1, pauli(context[0]))
    for label in context[1:]:
        acc = multiply(acc, (1, pauli(label)))
    sign, (x, z) = acc
    assert not any(x) and not any(z), "a context must multiply to +-I"
    return sign


# --------------------------------------------------------------------------
# report
# --------------------------------------------------------------------------


def analyse(name: str, labels: Sequence[str] | None, n: int, observables=None) -> dict:
    obs = observables if observables is not None else [pauli(w) for w in labels]
    lags = lagrangians(obs, n)
    mixed_start = frozenset({identity(n)})
    states = reachable(mixed_start, obs, n)
    classes = predictive_quotient(states, obs, n)
    by_rank: Dict[int, int] = {}
    for s in states:
        by_rank[len(s).bit_length() - 1] = by_rank.get(len(s).bit_length() - 1, 0) + 1

    # pure preparation: stabilizer state of the first context.  Signs may only
    # be chosen freely on an independent generating set; the multiplier fixes
    # the rest (this is exactly the anomalous context's constraint).
    gens: List[Signed] = []
    span = {identity(n)}
    for v in sorted(lags[0]):
        if any(v == w for _, w in span):
            continue
        gens.append((1, v))
        span = set(generate(gens, n))
    pure_start = generate(gens, n)
    pure_states = reachable(pure_start, obs, n)
    pure_classes = predictive_quotient(pure_states, obs, n)

    return {
        "name": name,
        "qubits": n,
        "observables": len(obs),
        "contexts": len(lags),
        "mixed_start_reachable": len(states),
        "mixed_start_recurrent": len(recurrent(states, obs, n)),
        "mixed_start_predictive_classes": len(classes),
        "by_stabilizer_rank": dict(sorted(by_rank.items())),
        "pure_start_reachable": len(pure_states),
        "pure_start_predictive_classes": len(pure_classes),
        "contexts_times_2n": len(lags) * 2 ** n,
    }


# --------------------------------------------------------------------------
# hostile control: explicit Gaussian-integer matrices
# --------------------------------------------------------------------------


def _kron(a, b):
    return [
        [a[i][k] * b[j][l] for k in range(len(a[0])) for l in range(len(b[0]))]
        for i in range(len(a))
        for j in range(len(b))
    ]


def _matmul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def explicit_matrix(vec: Symplectic):
    """``W(x,z)`` as an exact matrix over ``Z[i]`` (python ``complex`` with
    integer parts is avoided; entries are Python complex-valued ``int`` pairs
    represented as ``complex`` only after exact integer construction)."""
    single = {
        (0, 0): [[1, 0], [0, 1]],
        (1, 0): [[0, 1], [1, 0]],
        (0, 1): [[1, 0], [0, -1]],
        (1, 1): [[0, complex(0, -1)], [complex(0, 1), 0]],  # Y = i^1 X Z
    }
    x, z = vec
    acc = [[1]]
    for xi, zi in zip(x, z):
        acc = _kron(acc, single[(xi, zi)])
    return acc


def matrix_control(n: int) -> None:
    """Check the symbolic sign arithmetic against explicit matrices."""
    obs = all_paulis(n)
    for a in obs:
        for b in obs:
            if not commute(a, b):
                continue
            sign, vec = multiply((1, a), (1, b))
            lhs = _matmul(explicit_matrix(a), explicit_matrix(b))
            rhs = [[sign * v for v in row] for row in explicit_matrix(vec)]
            assert lhs == rhs, (a, b, sign)


def is_noncontextual(obs: Sequence[Symplectic], n: int) -> bool:
    """Does a global +-1 value assignment reproduce every context product?

    Solves the F_2 system ``sum_{v in L} val(v) = phase(L)`` over all contexts
    by exact Gaussian elimination over ``F_2``.
    """
    index = {v: i for i, v in enumerate(obs)}
    rows = []
    for L in lagrangians(obs, n):
        acc = (1, (tuple([0] * n), tuple([0] * n)))
        row = [0] * (len(obs) + 1)
        for v in sorted(L):
            acc = multiply(acc, (1, v))
            row[index[v]] = 1
        row[-1] = 0 if acc[0] == 1 else 1
        rows.append(row)
    width = len(obs)
    pivot_row = 0
    for col in range(width):
        pivot = next((r for r in range(pivot_row, len(rows)) if rows[r][col]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        for r in range(len(rows)):
            if r != pivot_row and rows[r][col]:
                rows[r] = [a ^ b for a, b in zip(rows[r], rows[pivot_row])]
        pivot_row += 1
    return not any(all(v == 0 for v in row[:-1]) and row[-1] for row in rows)


def pure_memory(observables: Sequence[Symplectic], n: int) -> int:
    """Number of memory states reachable from one pure stabilizer preparation."""
    lags = lagrangians(observables, n)
    gens: List[Signed] = []
    span = {identity(n)}
    for v in sorted(lags[0]):
        if any(v == w for _, w in span):
            continue
        gens.append((1, v))
        span = set(generate(gens, n))
    return len(reachable(generate(gens, n), list(observables), n))


def all_context_covers(n: int) -> List[Tuple[Symplectic, ...]]:
    """Every observable set that is a union of full contexts, deduplicated.

    Obtained as the closure of the Lagrangian singletons under union, so the
    enumeration is exhaustive without touching all ``2^|C|`` subsets.
    """
    full = [frozenset(L) for L in lagrangians(all_paulis(n), n)]
    seen = {frozenset(L) for L in full}
    frontier = list(seen)
    while frontier:
        nxt = []
        for s in frontier:
            for L in full:
                u = s | L
                if u not in seen:
                    seen.add(u)
                    nxt.append(u)
        frontier = nxt
    return sorted((tuple(sorted(s)) for s in seen), key=lambda t: (len(t), t))


def context_cover_sweep(n: int = 2) -> None:
    """Exhaustive sweep over all two-qubit union-of-contexts scenarios.

    Records, for every such scenario, the induced context count, the pure
    memory count, and whether the scenario is contextual.  A row carrying both
    families refutes "the memory count measures contextuality".
    """
    table: Dict[Tuple[int, int], List[int]] = {}
    for chosen in all_context_covers(n):
        lags = lagrangians(chosen, n)
        key = (len(lags), pure_memory(chosen, n))
        cell = table.setdefault(key, [0, 0])
        cell[1 if not is_noncontextual(chosen, n) else 0] += 1
    print(f"all union-of-context scenarios on {n} qubit(s)")
    print("     |C|  memory  |C|*2^n  noncontextual  contextual")
    collisions = []
    for (nl, count), (nc, c) in sorted(table.items()):
        print(f"    {nl:4d}  {count:6d}  {nl * 2 ** n:7d}  {nc:13d}  {c:10d}")
        if c and nc:
            collisions.append((nl, count, c, nc))
    print()
    if collisions:
        print("    contextuality-blind rows (same |C| and same memory):")
        for nl, count, c, nc in collisions:
            print(f"      |C|={nl}, memory={count}: {c} contextual, {nc} noncontextual")
    else:
        print("    no contextuality-blind row")
    print()


def contextuality_control() -> None:
    """Exhaustive control: does memory count track contextuality?

    Sweeps every 9-element subset of the 15 two-qubit Pauli observables,
    retains those with six contexts, and reports the pure-memory count of the
    contextual and the noncontextual families separately.
    """
    from itertools import combinations

    obs_all = all_paulis(2)
    full = [frozenset(L) for L in lagrangians(obs_all, 2)]
    assert len(full) == 15 and all(len(L) == 3 for L in full)
    contextual: Dict[int, int] = {}
    noncontextual: Dict[int, int] = {}
    for subset in combinations(obs_all, 9):
        chosen = set(subset)
        lags = [L for L in full if L <= chosen]
        # every admitted observable must sit in a full three-element context,
        # so that a pure stabilizer preparation exists and is never left
        if len(lags) != 6 or set().union(*lags) != chosen:
            continue
        gens: List[Signed] = []
        span = {identity(2)}
        for v in sorted(lags[0]):
            if any(v == w for _, w in span):
                continue
            gens.append((1, v))
            span = set(generate(gens, 2))
        count = len(reachable(generate(gens, 2), list(subset), 2))
        target = noncontextual if is_noncontextual(subset, 2) else contextual
        target[count] = target.get(count, 0) + 1
    print("nine-observable two-qubit scenarios, six full contexts covering all nine")
    print(f"    contextual    : pure-memory counts {contextual}")
    print(f"    noncontextual : pure-memory counts {noncontextual}")
    print()


def main() -> None:
    matrix_control(1)
    matrix_control(2)
    print("signed-Pauli arithmetic agrees with explicit matrices for n = 1, 2")
    print()
    print("Peres-Mermin context products (phase bit 0 = +I):")
    for ctx in PERES_MERMIN_CONTEXTS:
        print("   ", "*".join(ctx), "=", "+I" if context_signs(ctx) == 1 else "-I")
    print()
    reports = [
        analyse("Peres-Mermin square (9 observables)", PERES_MERMIN, 2),
        analyse("all two-qubit Paulis (15 observables)", None, 2, all_paulis(2)),
        analyse("one qubit (3 observables)", None, 1, all_paulis(1)),
    ]
    for r in reports:
        print(r["name"])
        for key in (
            "qubits",
            "observables",
            "contexts",
            "contexts_times_2n",
            "pure_start_reachable",
            "pure_start_predictive_classes",
            "mixed_start_reachable",
            "mixed_start_recurrent",
            "mixed_start_predictive_classes",
            "by_stabilizer_rank",
        ):
            print(f"    {key:22s} {r[key]}")
        print()
    context_cover_sweep(1)
    context_cover_sweep(2)
    contextuality_control()


if __name__ == "__main__":
    main()
