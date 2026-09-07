"""The nerve of the four-view cover, its cochains, delta, and exact cohomology.

    pairwise consistency between local views does not imply global coherence;
    where three agree the fourth may not glue; there the obstruction lives, and
    the obstruction is the result.

THE NERVE
---------
Four views, so the ambient nerve is the full 3-simplex: **4 vertices, 6
pairwise overlaps, 4 triples, 1 quadruple** -- 15 simplices, each a *sorted*
tuple of view indices.  Orientation is the ascending order of those indices and
is never re-chosen, so every cochain is canonical and two runs agree byte for
byte.

THE PRESHEAF
------------
A *channel* is a name together with a **support**: the set of simplices on
which that reading exists at all.  For a claim, one channel per site:

    supp(admit@s) = { sigma : every view in sigma can see s,
                              and sigma is licensed }

so a view that is blind at ``s`` deletes its vertex from that site's support,
and an overlap with no shared quotient deletes that edge (and everything above
it).  The presheaf is

    F(sigma) = Z^{ K(sigma) },   K(sigma) = { channels whose support has sigma }

with restriction ``F(sigma) -> F(tau)``, for ``sigma <= tau``, the coordinate
projection: keep the channels ``tau`` still has, drop the rest, and send a
channel ``tau`` has but ``sigma`` does not to 0.

    (delta c)_tau = sum_j (-1)^j  res( c_{tau minus its j-th vertex} )

**delta . delta = 0 iff every support is convex in the face poset**, i.e.
``sigma <= tau <= upsilon`` with ``sigma`` and ``upsilon`` in the support forces
``tau`` in it.  That is not a hygiene rule bolted on: it is exactly the
condition under which the two halves of each cancelling pair of the standard
computation carry the same coefficient.  ``convexity_violations`` finds the
witness, ``verify_delta_squared`` runs the identity on the standard basis, and
the suite plants a non-convex support so that ``delta . delta != 0`` is
observed rather than assumed.

Because the complex splits over channels, ``H^k`` is the direct sum over sites
of the simplicial cohomology of that site's support.  Everything is a finitely
generated free Z-module and everything is computed exactly by Smith normal
form: free rank and torsion, no floats, no rationals, no rank heuristics.

TWO THEOREMS THIS FILE MAKES OPERATIONAL, AND ONE OF THEM IS NEGATIVE
---------------------------------------------------------------------
1.  The 0-cochain of the four measured readings glues **iff** ``delta^0 s = 0``.
    That is the whole gluing question and it is decided exactly.

2.  ``delta^0 s`` is a coboundary *by construction*, so its class in ``H^1`` is
    always zero.  **Therefore no obstruction to gluing can ever be detected by
    comparing vertex readings alone.**  This is why the interesting cochain is
    ``discord``, whose channels have **no vertex support at all** -- a single
    view cannot report a disagreement, disagreement is irreducibly 1-cochain
    data -- so for ``discord`` the coboundary group is 0 and every non-zero
    cocycle is a non-zero class.

Both statements are asserted in the suite, and (2) is the mathematical content
of the brief's first sentence.
"""

from __future__ import annotations

from typing import Dict, Iterable, List, Mapping, Optional, Sequence, Tuple

from .views import (ALL_VIEWS, Claim, LocalSection, NerveError, View,
                    assert_independent, read_all, require_four_views,
                    view_name)

# --------------------------------------------------------------------------
# the nerve
# --------------------------------------------------------------------------

Simplex = Tuple[int, ...]


def _all_simplices() -> Tuple[Simplex, ...]:
    out: List[Simplex] = []
    for mask in range(1, 1 << len(ALL_VIEWS)):
        sigma = tuple(v for v in ALL_VIEWS if mask & (1 << v))
        out.append(sigma)
    out.sort(key=lambda s: (len(s), s))
    return tuple(out)


#: All 15 non-empty simplices, ordered by dimension then lexicographically.
SIMPLICES: Tuple[Simplex, ...] = _all_simplices()

#: 4 vertices, 6 edges, 4 triangles, 1 tetrahedron.
DIM_COUNTS: Tuple[int, ...] = (4, 6, 4, 1)

MAX_DIM = 3


def dim(sigma: Simplex) -> int:
    return len(sigma) - 1


def simplices_of_dim(k: int) -> Tuple[Simplex, ...]:
    return tuple(s for s in SIMPLICES if dim(s) == k)


def faces(sigma: Simplex) -> Tuple[Simplex, ...]:
    """The codimension-1 faces, in the order the coboundary signs use."""
    return tuple(sigma[:j] + sigma[j + 1:] for j in range(len(sigma)))


def simplex_name(sigma: Simplex) -> str:
    return "{" + ",".join(view_name(v) for v in sigma) + "}"


def is_face(sigma: Simplex, tau: Simplex) -> bool:
    return set(sigma) <= set(tau)


# --------------------------------------------------------------------------
# exact integer linear algebra
# --------------------------------------------------------------------------

Matrix = List[List[int]]


def zeros(m: int, n: int) -> Matrix:
    return [[0] * n for _ in range(m)]


def identity(n: int) -> Matrix:
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def matmul(a: Matrix, b: Matrix) -> Matrix:
    m = len(a)
    k = len(b)
    n = len(b[0]) if k else 0
    out = zeros(m, n)
    for i in range(m):
        row = a[i]
        orow = out[i]
        for t in range(k):
            v = row[t]
            if v:
                brow = b[t]
                for j in range(n):
                    orow[j] += v * brow[j]
    return out


def matvec(a: Matrix, x: Sequence[int]) -> List[int]:
    return [sum(a[i][j] * x[j] for j in range(len(x))) for i in range(len(a))]


class SNF:
    """``U * M * V == D`` with ``U``, ``V`` unimodular and ``D`` diagonal.

    Exact over Z.  ``invariants`` are the non-zero diagonal entries, positive
    and each dividing the next -- the standard invariant factors.
    """

    __slots__ = ("D", "U", "V", "Uinv", "Vinv", "rank", "invariants",
                 "rows", "cols")

    def __init__(self, D, U, V, Uinv, Vinv, rows, cols):
        self.D, self.U, self.V, self.Uinv, self.Vinv = D, U, V, Uinv, Vinv
        self.rows, self.cols = rows, cols
        inv = []
        for i in range(min(rows, cols)):
            if D[i][i]:
                inv.append(abs(D[i][i]))
        self.invariants = tuple(inv)
        self.rank = len(inv)


def smith(M: Matrix, rows: int, cols: int) -> SNF:
    """Smith normal form with all four transformation matrices.

    The matrices here are tiny (tens of rows) and their entries are in
    ``{-1, 0, 1}`` before elimination, so the schoolbook algorithm with a
    smallest-pivot rule is both fast enough and free of coefficient blow-up.
    """
    D = [list(r) for r in M] if rows else []
    if rows == 0:
        D = []
    U, Uinv = identity(rows), identity(rows)
    V, Vinv = identity(cols), identity(cols)

    def row_add(i, j, k):                # row_i += k * row_j
        if k == 0:
            return
        Di, Dj = D[i], D[j]
        for c in range(cols):
            Di[c] += k * Dj[c]
        Ui, Uj = U[i], U[j]
        for c in range(rows):
            Ui[c] += k * Uj[c]
        for r in range(rows):             # Uinv: col_j -= k * col_i
            Uinv[r][j] -= k * Uinv[r][i]

    def col_add(i, j, k):                # col_i += k * col_j
        if k == 0:
            return
        for r in range(rows):
            D[r][i] += k * D[r][j]
        for r in range(cols):
            V[r][i] += k * V[r][j]
        Vj = Vinv[j]                      # Vinv: row_j -= k * row_i
        Vi = Vinv[i]
        for c in range(cols):
            Vj[c] -= k * Vi[c]

    def row_swap(i, j):
        if i == j:
            return
        D[i], D[j] = D[j], D[i]
        U[i], U[j] = U[j], U[i]
        for r in range(rows):
            Uinv[r][i], Uinv[r][j] = Uinv[r][j], Uinv[r][i]

    def col_swap(i, j):
        if i == j:
            return
        for r in range(rows):
            D[r][i], D[r][j] = D[r][j], D[r][i]
        for r in range(cols):
            V[r][i], V[r][j] = V[r][j], V[r][i]
        Vinv[i], Vinv[j] = Vinv[j], Vinv[i]

    def row_neg(i):
        for c in range(cols):
            D[i][c] = -D[i][c]
        for c in range(rows):
            U[i][c] = -U[i][c]
        for r in range(rows):
            Uinv[r][i] = -Uinv[r][i]

    t = 0
    while t < min(rows, cols):
        # find a pivot: the smallest non-zero absolute value in the submatrix
        best = None
        for i in range(t, rows):
            for j in range(t, cols):
                v = D[i][j]
                if v and (best is None or abs(v) < best[0]):
                    best = (abs(v), i, j)
        if best is None:
            break
        row_swap(t, best[1])
        col_swap(t, best[2])
        if D[t][t] < 0:
            row_neg(t)
        while True:
            changed = False
            for i in range(t + 1, rows):
                if D[i][t]:
                    q = D[i][t] // D[t][t]
                    row_add(i, t, -q)
                    if D[i][t]:
                        row_swap(t, i)
                        if D[t][t] < 0:
                            row_neg(t)
                        changed = True
            for j in range(t + 1, cols):
                if D[t][j]:
                    q = D[t][j] // D[t][t]
                    col_add(j, t, -q)
                    if D[t][j]:
                        col_swap(t, j)
                        if D[t][t] < 0:
                            row_neg(t)
                        changed = True
            if not changed:
                break
        # divisibility: fold any entry the pivot does not divide back in
        pivot = D[t][t]
        offender = None
        for i in range(t + 1, rows):
            for j in range(t + 1, cols):
                if D[i][j] % pivot:
                    offender = (i, j)
                    break
            if offender:
                break
        if offender:
            row_add(t, offender[0], 1)
            continue
        t += 1
    return SNF(D, U, V, Uinv, Vinv, rows, cols)


def kernel_basis(snf: SNF) -> List[List[int]]:
    """A Z-basis of ``ker M`` as a list of column vectors.

    ``M V = U^{-1} D``, so ``M (V e_j) = 0`` exactly for ``j >= rank``, and the
    columns of a unimodular ``V`` beyond the rank are a basis of a direct
    summand -- the kernel lattice, saturated.
    """
    return [[snf.V[r][j] for r in range(snf.cols)]
            for j in range(snf.rank, snf.cols)]


def solve_exact(snf: SNF, b: Sequence[int]) -> Optional[List[int]]:
    """Solve ``M x = b`` over Z, or ``None`` if there is no integer solution."""
    ub = matvec(snf.U, list(b))
    y = [0] * snf.cols
    for i in range(snf.rank):
        d = snf.D[i][i]
        if ub[i] % d:
            return None
        y[i] = ub[i] // d
    for i in range(snf.rank, snf.rows):
        if ub[i]:
            return None
    return [sum(snf.V[r][c] * y[c] for c in range(snf.cols))
            for r in range(snf.cols)]


def coordinates_in_kernel(snf: SNF, b: Sequence[int]) -> Optional[List[int]]:
    """Express ``b`` in the kernel basis of ``kernel_basis(snf)``."""
    z = matvec(snf.Vinv, list(b))
    for i in range(snf.rank):
        if z[i]:
            return None
    return z[snf.rank:]


class Cohomology:
    """``H^k`` as a finitely generated abelian group: free rank plus torsion."""

    __slots__ = ("degree", "free_rank", "torsion", "cochain_rank",
                 "cocycle_rank", "coboundary_rank")

    def __init__(self, degree, free_rank, torsion, cochain_rank,
                 cocycle_rank, coboundary_rank):
        self.degree = degree
        self.free_rank = free_rank
        self.torsion = tuple(torsion)
        self.cochain_rank = cochain_rank
        self.cocycle_rank = cocycle_rank
        self.coboundary_rank = coboundary_rank

    def is_trivial(self) -> bool:
        return self.free_rank == 0 and not self.torsion

    def render(self) -> str:
        if self.is_trivial():
            body = "0"
        else:
            parts = []
            if self.free_rank:
                parts.append("Z^%d" % self.free_rank if self.free_rank > 1
                             else "Z")
            parts.extend("Z/%d" % t for t in self.torsion)
            body = " + ".join(parts)
        return "H^%d = %-12s  (C^%d rank %d, cocycles %d, coboundaries %d)" % (
            self.degree, body, self.degree, self.cochain_rank,
            self.cocycle_rank, self.coboundary_rank)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Cohomology(H^%d, free=%d, torsion=%r)" % (
            self.degree, self.free_rank, self.torsion)


# --------------------------------------------------------------------------
# channels and the presheaf
# --------------------------------------------------------------------------

class Channel:
    """A named reading together with the simplices on which it exists."""

    __slots__ = ("name", "support", "note")

    def __init__(self, name: str, support: Iterable[Simplex], note: str = ""):
        self.name = name
        sup = set()
        for s in support:
            s = tuple(s)
            if s not in SIMPLICES:
                raise NerveError("not a simplex of the nerve: %r" % (s,))
            sup.add(s)
        self.support = frozenset(sup)
        self.note = note

    def has(self, sigma: Simplex) -> bool:
        return tuple(sigma) in self.support

    def support_sorted(self) -> Tuple[Simplex, ...]:
        return tuple(s for s in SIMPLICES if s in self.support)

    def render(self) -> str:
        return "%-22s %s" % (
            self.name, " ".join(simplex_name(s) for s in self.support_sorted()))

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Channel(%r, %d simplices)" % (self.name, len(self.support))


def convexity_violations(support: Iterable[Simplex]
                         ) -> Tuple[Tuple[Simplex, Simplex, Simplex], ...]:
    """Witnesses ``(sigma, tau, upsilon)`` to non-convexity in the face poset.

    ``sigma <= tau <= upsilon`` with the two ends in the support and the middle
    missing.  Exactly the configuration that breaks ``delta . delta = 0``.
    """
    sup = set(tuple(s) for s in support)
    out = []
    for sigma in SIMPLICES:
        if sigma not in sup:
            continue
        for upsilon in SIMPLICES:
            if upsilon not in sup or not is_face(sigma, upsilon):
                continue
            for tau in SIMPLICES:
                if tau in sup:
                    continue
                if is_face(sigma, tau) and is_face(tau, upsilon):
                    out.append((sigma, tau, upsilon))
    return tuple(sorted(set(out)))


class Presheaf:
    """The presheaf of readings, and the Cech complex it carries."""

    __slots__ = ("channels", "_by_name", "_basis", "_index", "_delta")

    def __init__(self, channels: Sequence[Channel], check_convex: bool = True):
        names = [c.name for c in channels]
        if len(set(names)) != len(names):
            raise NerveError("duplicate channel names: %r" % (sorted(names),))
        self.channels = tuple(sorted(channels, key=lambda c: c.name))
        self._by_name = {c.name: c for c in self.channels}
        if check_convex:
            for c in self.channels:
                bad = convexity_violations(c.support)
                if bad:
                    sigma, tau, upsilon = bad[0]
                    raise NerveError(
                        "channel %r has a non-convex support: %s <= %s <= %s "
                        "with the middle missing, so delta.delta != 0"
                        % (c.name, simplex_name(sigma), simplex_name(tau),
                           simplex_name(upsilon)))
        self._basis: Dict[int, Tuple[Tuple[Simplex, str], ...]] = {}
        self._index: Dict[int, Dict[Tuple[Simplex, str], int]] = {}
        self._delta: Dict[int, Matrix] = {}

    # -- basis -----------------------------------------------------------
    def channel(self, name: str) -> Channel:
        try:
            return self._by_name[name]
        except KeyError:
            raise NerveError("no such channel: %r" % (name,))

    def basis(self, k: int) -> Tuple[Tuple[Simplex, str], ...]:
        if k < 0 or k > MAX_DIM:
            return ()
        if k not in self._basis:
            items = []
            for sigma in simplices_of_dim(k):
                for c in self.channels:
                    if c.has(sigma):
                        items.append((sigma, c.name))
            items.sort()
            self._basis[k] = tuple(items)
            self._index[k] = {b: i for i, b in enumerate(self._basis[k])}
        return self._basis[k]

    def index(self, k: int) -> Dict[Tuple[Simplex, str], int]:
        self.basis(k)
        return self._index.get(k, {})

    def rank(self, k: int) -> int:
        return len(self.basis(k))

    # -- coboundary ------------------------------------------------------
    def delta_matrix(self, k: int) -> Matrix:
        """Rows indexed by ``basis(k+1)``, columns by ``basis(k)``."""
        if k in self._delta:
            return self._delta[k]
        src = self.basis(k)
        dst = self.basis(k + 1)
        idx = self.index(k)
        M = zeros(len(dst), len(src))
        for r, (tau, name) in enumerate(dst):
            for j, face in enumerate(faces(tau)):
                key = (face, name)
                col = idx.get(key)
                if col is None:
                    continue                 # restriction sends it to 0
                M[r][col] += (-1) ** j
        self._delta[k] = M
        return M

    # -- cohomology ------------------------------------------------------
    def cohomology(self, k: int) -> Cohomology:
        n = self.rank(k)
        A = self.delta_matrix(k)               # C^k -> C^{k+1}
        snfA = smith(A, self.rank(k + 1), n)
        cocycle_rank = n - snfA.rank
        if k == 0:
            return Cohomology(0, cocycle_rank, (), n, cocycle_rank, 0)
        B = self.delta_matrix(k - 1)           # C^{k-1} -> C^k
        snfB = smith(B, n, self.rank(k - 1))
        K = kernel_basis(snfA)                 # columns: basis of ker A
        # express every column of im B in the kernel basis
        cols = []
        for j in range(self.rank(k - 1)):
            b = [B[i][j] for i in range(n)]
            coords = coordinates_in_kernel(snfA, b)
            if coords is None:                 # pragma: no cover - impossible
                raise NerveError("delta.delta != 0: im delta is not in ker delta")
            cols.append(coords)
        kdim = len(K)
        Y = zeros(kdim, len(cols))
        for j, coords in enumerate(cols):
            for i in range(kdim):
                Y[i][j] = coords[i]
        snfY = smith(Y, kdim, len(cols))
        torsion = tuple(d for d in snfY.invariants if d != 1)
        free = kdim - snfY.rank
        return Cohomology(k, free, torsion, n, cocycle_rank, snfB.rank)

    def cohomology_all(self) -> Tuple[Cohomology, ...]:
        return tuple(self.cohomology(k) for k in range(MAX_DIM + 1))


# --------------------------------------------------------------------------
# cochains
# --------------------------------------------------------------------------

class Cochain:
    """A ``k``-cochain: an exact integer on each basis element of ``C^k``."""

    __slots__ = ("degree", "presheaf", "values")

    def __init__(self, degree: int, presheaf: Presheaf,
                 values: Mapping[Tuple[Simplex, str], int] = ()):
        self.degree = degree
        self.presheaf = presheaf
        idx = presheaf.index(degree)
        vals: Dict[Tuple[Simplex, str], int] = {}
        for key, v in dict(values or {}).items():
            key = (tuple(key[0]), key[1])
            if key not in idx:
                raise NerveError(
                    "%s is not in the support of channel %r, so it carries no "
                    "value" % (simplex_name(key[0]), key[1]))
            if int(v):
                vals[key] = int(v)
        self.values = vals

    def vector(self) -> List[int]:
        basis = self.presheaf.basis(self.degree)
        return [self.values.get(b, 0) for b in basis]

    def get(self, sigma: Simplex, name: str) -> int:
        return self.values.get((tuple(sigma), name), 0)

    def is_zero(self) -> bool:
        return not self.values

    def support(self) -> Tuple[Tuple[Simplex, str], ...]:
        return tuple(sorted(self.values))

    def render(self, limit: int = 12) -> str:
        if not self.values:
            return "0"
        items = sorted(self.values.items())
        head = ["%s@%s = %+d" % (simplex_name(s), n, v)
                for (s, n), v in items[:limit]]
        if len(items) > limit:
            head.append("... (%d more)" % (len(items) - limit))
        return "; ".join(head)

    def __eq__(self, other) -> bool:
        return (isinstance(other, Cochain) and other.degree == self.degree
                and other.values == self.values)

    def __hash__(self):                            # pragma: no cover
        return hash((self.degree, tuple(sorted(self.values.items()))))

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Cochain(deg=%d, %d non-zero)" % (self.degree, len(self.values))


def from_vector(degree: int, presheaf: Presheaf,
                vec: Sequence[int]) -> Cochain:
    basis = presheaf.basis(degree)
    if len(vec) != len(basis):
        raise NerveError("vector length %d != C^%d rank %d"
                         % (len(vec), degree, len(basis)))
    return Cochain(degree, presheaf,
                   {b: v for b, v in zip(basis, vec) if v})


def coboundary(c: Cochain) -> Cochain:
    """``delta c``, exactly."""
    p = c.presheaf
    M = p.delta_matrix(c.degree)
    out = matvec(M, c.vector()) if p.rank(c.degree + 1) else []
    return from_vector(c.degree + 1, p, out)


def verify_delta_squared(presheaf: Presheaf) -> Tuple[bool, Tuple[str, ...]]:
    """Run ``delta . delta = 0`` on every standard basis vector of every degree."""
    bad = []
    for k in range(MAX_DIM - 1):
        basis = presheaf.basis(k)
        for i, b in enumerate(basis):
            e = Cochain(k, presheaf, {b: 1})
            dd = coboundary(coboundary(e))
            if not dd.is_zero():
                bad.append("delta^2 e_%d (%s@%s) = %s"
                           % (i, simplex_name(b[0]), b[1], dd.render()))
    return (not bad, tuple(bad))


class CochainClass:
    """Where a measured cochain sits: cocycle? coboundary? which class?"""

    __slots__ = ("degree", "cochain", "is_cocycle", "coboundary_of",
                 "is_coboundary", "cohomology", "failure", "class_coords")

    def __init__(self, degree, cochain, is_cocycle, coboundary_of,
                 is_coboundary, cohomology, failure, class_coords):
        self.degree = degree
        self.cochain = cochain
        self.is_cocycle = is_cocycle
        self.coboundary_of = coboundary_of
        self.is_coboundary = is_coboundary
        self.cohomology = cohomology
        self.failure = failure
        self.class_coords = class_coords

    def is_zero_class(self) -> bool:
        return self.is_cocycle and self.is_coboundary

    def render(self) -> str:
        if self.cochain.is_zero():
            return "0 -- the sections agree on every overlap they share"
        if not self.is_cocycle:
            return ("NOT a cocycle: delta of it is non-zero at %s -- the "
                    "pairwise data does not even assemble on a triple"
                    % self.failure.render())
        if self.is_coboundary:
            return ("a non-zero cocycle whose class in H^%d is 0: the "
                    "disagreement is a coboundary, trivialised by %s"
                    % (self.degree, self.coboundary_of.render()))
        return ("a non-zero class in H^%d = %s"
                % (self.degree,
                   self.cohomology.render().split("=", 1)[1].split("(")[0].strip()))

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "CochainClass(deg=%d, cocycle=%r, coboundary=%r)" % (
            self.degree, self.is_cocycle, self.is_coboundary)


def classify(c: Cochain) -> CochainClass:
    """Decide, exactly over Z: cocycle?  coboundary?  which class?"""
    p = c.presheaf
    k = c.degree
    d = coboundary(c)
    is_cocycle = d.is_zero()
    coh = p.cohomology(k)
    if k == 0:
        return CochainClass(k, c, is_cocycle, None, c.is_zero(), coh, d, None)
    B = p.delta_matrix(k - 1)
    snfB = smith(B, p.rank(k), p.rank(k - 1))
    x = solve_exact(snfB, c.vector()) if is_cocycle else None
    witness = from_vector(k - 1, p, x) if x is not None else None
    coords = None
    if is_cocycle and x is None:
        A = p.delta_matrix(k)
        snfA = smith(A, p.rank(k + 1), p.rank(k))
        coords = coordinates_in_kernel(snfA, c.vector())
    return CochainClass(k, c, is_cocycle, witness, x is not None, coh, d, coords)


# --------------------------------------------------------------------------
# building the presheaf of a claim
# --------------------------------------------------------------------------

ADMIT = "admit"
DISCORD = "discord"


def site_support(claim: Claim, sections: Mapping[int, LocalSection],
                 site: str, min_dim: int = 0) -> Tuple[Simplex, ...]:
    """The simplices on which ``site`` carries a reading.

    ``sigma`` qualifies when every view in ``sigma`` can see the site *and*
    ``sigma`` is licensed.  Blindness deletes a vertex; an unlicensed overlap
    deletes an edge and, by face closure of the licence, everything above it.
    The result is convex: a face of a licensed simplex is licensed and a subset
    of seeing views is seeing.
    """
    seeing = frozenset(v for v in ALL_VIEWS if site in sections[v].reading)
    out = []
    for sigma in SIMPLICES:
        if dim(sigma) < min_dim:
            continue
        if not set(sigma) <= seeing:
            continue
        if not claim.is_licensed(sigma):
            continue
        out.append(sigma)
    return tuple(out)


def build_presheaf(claim: Claim,
                   sections: Mapping[int, LocalSection]) -> Presheaf:
    """Two channel families, and the second is where an obstruction can live.

    ``admit@s``     supported wherever the site is seen and the overlap is
                    licensed, **including vertices**.  Carries the four
                    readings; its coboundary is the pairwise disagreement.

    ``discord@s``   the same support with the vertices removed.  A single view
                    cannot report a disagreement, so this channel has no
                    0-cochains at all: ``B^1 = 0`` on it and every non-zero
                    cocycle is a non-zero class of ``H^1``.
    """
    channels: List[Channel] = []
    for site in claim.sites:
        full = site_support(claim, sections, site, min_dim=0)
        if full:
            channels.append(Channel(
                "%s@%s" % (ADMIT, site), full,
                "the shared alphabet at %r, on every licensed overlap whose "
                "views can see it" % site))
        joint = tuple(s for s in full if dim(s) >= 1)
        if joint:
            channels.append(Channel(
                "%s@%s" % (DISCORD, site), joint,
                "disagreement at %r; irreducibly overlap data, so no vertex "
                "carries it" % site))
    return Presheaf(channels)


def section_cochain(presheaf: Presheaf,
                    sections: Mapping[int, LocalSection]) -> Cochain:
    """The measured 0-cochain: each view's own reading at each site."""
    vals = {}
    for (sigma, name) in presheaf.basis(0):
        if not name.startswith(ADMIT + "@"):
            continue
        site = name[len(ADMIT) + 1:]
        v = sigma[0]
        vals[(sigma, name)] = sections[v].reading[site]
    return Cochain(0, presheaf, vals)


def discord_cochain(presheaf: Presheaf,
                    sections: Mapping[int, LocalSection]) -> Cochain:
    """The measured 1-cochain of joint disagreement.

    ``discord@s`` on an overlap is 1 when the views of that overlap do not all
    read ``s`` the same way, 0 when they do.  It is computed from the pair, not
    from either member, which is exactly why its channel has no vertex.
    """
    vals = {}
    for (sigma, name) in presheaf.basis(1):
        if not name.startswith(DISCORD + "@"):
            continue
        site = name[len(DISCORD) + 1:]
        readings = set(sections[v].reading[site] for v in sigma)
        vals[(sigma, name)] = 0 if len(readings) == 1 else 1
    return Cochain(1, presheaf, vals)


class Disagreement:
    """Where two views read the same site differently."""

    __slots__ = ("edge", "site", "left", "right")

    def __init__(self, edge, site, left, right):
        self.edge, self.site, self.left, self.right = edge, site, left, right

    def render(self) -> str:
        return "%-24s %-16s %s=%d  %s=%d" % (
            simplex_name(self.edge), self.site,
            view_name(self.edge[0]), self.left,
            view_name(self.edge[1]), self.right)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "Disagreement(%r, %r)" % (self.edge, self.site)


def disagreements(claim: Claim, sections: Mapping[int, LocalSection]
                  ) -> Tuple[Disagreement, ...]:
    out = []
    for sigma in simplices_of_dim(1):
        if not claim.is_licensed(sigma):
            continue
        i, j = sigma
        for site in claim.sites:
            if site not in sections[i].reading or site not in sections[j].reading:
                continue
            a, b = sections[i].reading[site], sections[j].reading[site]
            if a != b:
                out.append(Disagreement(sigma, site, a, b))
    return tuple(out)


def triple_failures(claim: Claim, sections: Mapping[int, LocalSection]
                    ) -> Tuple[Tuple[Simplex, str], ...]:
    """Triples on which three views do not all agree, per site."""
    out = []
    for sigma in simplices_of_dim(2):
        if not claim.is_licensed(sigma):
            continue
        for site in claim.sites:
            vals = [sections[v].reading.get(site) for v in sigma]
            if any(x is None for x in vals):
                continue
            if len(set(vals)) > 1:
                out.append((sigma, site))
    return tuple(out)


def glues_on(claim: Claim, sections: Mapping[int, LocalSection],
             sigma: Simplex) -> bool:
    """Do the views of ``sigma`` glue -- agree on every site all of them see?"""
    if not claim.is_licensed(sigma):
        return False
    for site in claim.sites:
        vals = [sections[v].reading.get(site) for v in sigma]
        if any(x is None for x in vals):
            continue
        if len(set(vals)) > 1:
            return False
    return True


# --------------------------------------------------------------------------
# the four-fold certificate -- the reusable gate
# --------------------------------------------------------------------------

COHERENT = "COHERENT"
OBSTRUCTED = "OBSTRUCTED"
UNASSESSABLE = "UNASSESSABLE"


class FourFoldCertificate:
    """What a claim gets for supplying all four views.

    **The gate never rejects.**  A claim whose views do not glue is marked with
    its obstruction class and admitted, because the obstruction is information:
    it is the exact statement of what the claim's four descriptions disagree
    about, and where.  Rejection would discard it.
    """

    __slots__ = ("claim", "sections", "presheaf", "verdict", "complaints",
                 "independence", "delta_squared", "section", "disagreement",
                 "disagreement_class", "discord", "discord_class",
                 "cohomology", "disagreements", "triple_failures",
                 "glue_by_simplex", "holonomy")

    def __init__(self, claim, sections, presheaf, verdict, complaints,
                 independence, delta_squared, section, disagreement,
                 disagreement_class, discord, discord_class, cohomology,
                 disagreements_, triple_failures_, glue_by_simplex):
        self.claim = claim
        self.sections = dict(sections)
        self.presheaf = presheaf
        self.verdict = verdict
        self.complaints = tuple(complaints)
        self.independence = independence
        self.delta_squared = delta_squared
        self.section = section
        self.disagreement = disagreement
        self.disagreement_class = disagreement_class
        self.discord = discord
        self.discord_class = discord_class
        self.cohomology = tuple(cohomology)
        self.disagreements = tuple(disagreements_)
        self.triple_failures = tuple(triple_failures_)
        self.glue_by_simplex = dict(glue_by_simplex)
        self.holonomy = None                       # attached by holonomy.py

    # -- queries ---------------------------------------------------------
    def glues(self) -> bool:
        return self.verdict == COHERENT

    def obstruction_class(self) -> Optional[CochainClass]:
        return None if self.glues() else self.discord_class

    def three_agree_fourth_does_not(self) -> Tuple[Tuple[Simplex, str], ...]:
        """Triples that glue while the quadruple containing them does not."""
        out = []
        quad = simplices_of_dim(3)[0]
        if self.glue_by_simplex.get(quad, True):
            return ()
        for sigma in simplices_of_dim(2):
            if self.glue_by_simplex.get(sigma, False):
                out.append((sigma, "glues; the quadruple does not"))
        return tuple(out)

    def render(self) -> str:
        lines = ["four-fold certificate: %s" % self.claim.name,
                 "  verdict          %s" % self.verdict]
        if self.complaints:
            for c in self.complaints:
                lines.append("  complaint        %s" % c)
        lines.append("  locality         %s" % self.independence.render())
        lines.append("  delta.delta=0    %s" % ("verified" if self.delta_squared[0]
                                                else "FAILED: %s"
                                                % (self.delta_squared[1],)))
        for h in self.cohomology:
            lines.append("  %s" % h.render())
        lines.append("  disagreement     %s" % self.disagreement_class.render())
        lines.append("  discord (H^1)    %s" % self.discord_class.render())
        return "\n".join(lines)

    def __repr__(self) -> str:                     # pragma: no cover - view
        return "FourFoldCertificate(%r, %s)" % (self.claim.name, self.verdict)


def coherence_gate(claim: Claim,
                   readers: Mapping[int, object] = None) -> FourFoldCertificate:
    """The optional gate.  Run it on any claim; it marks, it does not reject.

    Wired nowhere else on purpose: no other lane's code is retrofitted, and a
    lane that wants the check imports it.
    """
    ok, complaints = require_four_views(claim)
    sections = read_all(claim)
    independence = assert_independent(claim, readers)
    presheaf = build_presheaf(claim, sections)
    dd = verify_delta_squared(presheaf)
    s = section_cochain(presheaf, sections)
    g = coboundary(s)
    gclass = classify(g)
    d = discord_cochain(presheaf, sections)
    dclass = classify(d)
    cohom = presheaf.cohomology_all()
    dis = disagreements(claim, sections)
    trip = triple_failures(claim, sections)
    glue = {sigma: glues_on(claim, sections, sigma) for sigma in SIMPLICES}
    if not ok or not independence.ok or not dd[0]:
        verdict = UNASSESSABLE
    elif g.is_zero():
        verdict = COHERENT
    else:
        verdict = OBSTRUCTED
    return FourFoldCertificate(claim, sections, presheaf, verdict, complaints,
                               independence, dd, s, g, gclass, d, dclass,
                               cohom, dis, trip, glue)


__all__ = [
    "Simplex", "SIMPLICES", "DIM_COUNTS", "MAX_DIM", "dim", "simplices_of_dim",
    "faces", "simplex_name", "is_face",
    "Matrix", "zeros", "identity", "matmul", "matvec", "SNF", "smith",
    "kernel_basis", "solve_exact", "coordinates_in_kernel", "Cohomology",
    "Channel", "convexity_violations", "Presheaf", "Cochain", "from_vector",
    "coboundary", "verify_delta_squared", "CochainClass", "classify",
    "ADMIT", "DISCORD", "site_support", "build_presheaf", "section_cochain",
    "discord_cochain", "Disagreement", "disagreements", "triple_failures",
    "glues_on", "COHERENT", "OBSTRUCTED", "UNASSESSABLE",
    "FourFoldCertificate", "coherence_gate",
]
