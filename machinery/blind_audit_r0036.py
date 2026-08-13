"""Blind hostile audit of claim R0036 (two-sided Smith stabilizer, general n).

BLIND: written without reading the owner's derivation
(notes/FLAG_CONGRUENCE_SMITH_STABILIZER.md, machinery/flag_congruence_*,
notes/MIXED_RANK_SMITH_STABILIZER.md, machinery/mixed_rank_*).

Everything below is derived from HDK = D directly, then verified by exact
integer computation (exhaustive window sweeps + targeted elementary
certificates).  No floating point anywhere.

--------------------------------------------------------------------------
Independent derivation (the theorems the computations certify)
--------------------------------------------------------------------------

Throughout D = diag(d_1, ..., d_n) with all d_i nonzero integers.

Lemma A (the partner is forced).  If H, K are invertible over Q and
HDK = D, then K = D^{-1} H^{-1} D.  Proof: solve.  Hence the two-sided
integer stabilizer {(H, K) in GL_n(Z)^2 : HDK = D} is exactly
    {(H, D^{-1} H^{-1} D) : H in GL_n(Z), D^{-1} H^{-1} D in M_n(Z)}.
(An integral D^{-1}H^{-1}D automatically has det = det H^{-1} = +-1, so
integrality alone puts it in GL_n(Z).)

Lemma B (entrywise form of the conjugation condition -- ANY nonzero
diagonal, chain or not).  (D^{-1} X D)_{ij} = X_ij d_j / d_i, so for
integer X:
    D^{-1} X D integral  <=>  d_i | X_ij d_j            for all i, j
                         <=>  ( |d_i| / gcd(d_i, d_j) ) | X_ij  for i != j
(the diagonal i = j is vacuous).  For H in GL_n(Z) this is exactly
membership in D GL_n(Z) D^{-1}, so
    Gamma_0(D) := GL_n(Z) /\ D GL_n(Z) D^{-1}
                = {H in GL_n(Z) : (|d_i|/gcd(d_i,d_j)) | H_ij, all i != j}.
Gamma_0(D) is a group for EVERY nonzero diagonal D -- it is an
intersection of two groups; no chain hypothesis and no flag relation
d_i/d_j = (d_i/d_k)(d_k/d_j) is needed for closure.  (Closure is also
visible entrywise: (HH')_ij d_j/d_i = sum_k (H_ik d_k/d_i)(H'_kj d_j/d_k),
a sum of products of integers -- again for arbitrary nonzero diagonal D.)

Lemma C (stabilizer ~ Gamma_0(D), ANY nonzero diagonal).  Gamma_0(D) is
closed under inverse, so  H in Gamma_0(D)  <=>  H^{-1} in Gamma_0(D)
<=>  K := D^{-1}H^{-1}D in GL_n(Z).  With Lemma A, H |-> (H, D^{-1}H^{-1}D)
is an isomorphism Gamma_0(D) -> stabilizer.  The chain hypothesis in
R0036 is NOT needed for this part of the claim.

Lemma D (what the chain buys).  If d_i | d_j for i <= j then for i < j
the condition d_i | H_ij d_j is vacuous (d_j is a multiple of d_i), and
for i > j it reads (d_i/d_j) | H_ij, where d_i/d_j is a (possibly
negative) integer and divisibility is sign-blind.  So the claimed
description {H : (d_i/d_j) | H_ij for i > j} is exactly Gamma_0(D) for a
divisor chain -- including chains with negative / mixed-sign entries.
For a NON-chain diagonal the description MUTATES (does not merely fail):
divisibility constraints appear on BOTH sides of the diagonal with
moduli m_ij = |d_i| / gcd(d_i, d_j).  E.g.
    D = diag(2,3):    2 | H_12  and  3 | H_21;
    D = diag(4,6,9):  2|H_12, 4|H_13, 3|H_21, 2|H_23, 9|H_31, 3|H_32.

Lemma E (torsor).  Fix any nonsingular integer M and any diagonal D with
event set E = {(U,V) in GL_n(Z)^2 : UMV = D} nonempty.  For H in
Gamma_0(D), H.(U,V) := (HU, V D^{-1}H^{-1}D) is again an event
(HU M V D^{-1}H^{-1}D = H D D^{-1} H^{-1} D = D).  The action is free
(HU = U => H = I) and transitive: if UMV = U'MV' = D then with
H := U'U^{-1}, K := V^{-1}V' we get HDK = D, so by Lemmas A+C
H in Gamma_0(D) and V' = V D^{-1}H^{-1}D.  Hence E is a regular
Gamma_0(D)-torsor, and relative to a base event (U0,V0) the payload
pi(U,V) = U U0^{-1} is a bijection E -> Gamma_0(D) with inverse
H |-> (H U0, V0 D^{-1}H^{-1}D).  Again: no chain hypothesis needed.

Lemma F (non-uniqueness of the diagonal -- the sign defect).  If
UMV = D then for any epsilon in {+-1}^n, (diag(epsilon) U, V) is an
event for diag(epsilon) D, whose entries |d_i| are unchanged and which
still satisfies the chain divisibility d_i | d_j (divisibility is
sign-blind).  So ALL 2^n sign patterns of a chain diagonal are reachable
by normalization events, and "all events share the same normalized D" is
FALSE under R0036's stated hypothesis "nonzero integers with d_i | d_j"
unless "normalized" additionally pins the signs (e.g. all d_i > 0, the
standard Smith convention).  What IS invariant is (|d_1|, ..., |d_n|):
the determinantal divisors g_k(M) = gcd of all k x k minors satisfy
g_k(UMV) = g_k(M), and for a chain diagonal g_k = |d_1 ... d_k|.

--------------------------------------------------------------------------
All functions below use exact integer arithmetic only.
"""

from math import gcd
from itertools import combinations


# ---------------------------------------------------------------- linear algebra

def identity(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def mat_mul(A, B):
    n, k, m = len(A), len(B), len(B[0])
    return [[sum(A[i][t] * B[t][j] for t in range(k)) for j in range(m)]
            for i in range(n)]


def diag_mat(D):
    n = len(D)
    return [[D[i] if i == j else 0 for j in range(n)] for i in range(n)]


def det(A):
    n = len(A)
    if n == 1:
        return A[0][0]
    if n == 2:
        return A[0][0] * A[1][1] - A[0][1] * A[1][0]
    if n == 3:
        (a, b, c), (d, e, f), (g, h, i) = A
        return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
    raise ValueError("only n <= 3 supported")


def _minor(A, i, j):
    return [[A[r][c] for c in range(len(A)) if c != j]
            for r in range(len(A)) if r != i]


def adjugate(A):
    n = len(A)
    if n == 1:
        return [[1]]
    if n == 2:
        (a, b), (c, d) = A
        return [[d, -b], [-c, a]]
    if n == 3:
        # adj[i][j] = cofactor C_ji = (-1)^{i+j} det(minor deleting row j, col i)
        return [[(-1) ** (i + j) * det(_minor(A, j, i)) for j in range(3)]
                for i in range(3)]
    raise ValueError("only n <= 3 supported")


def is_unimodular(A):
    return det(A) in (1, -1)


def unimodular_inverse(A):
    """Exact inverse of a unimodular integer matrix: inv = det(A) * adj(A)."""
    d = det(A)
    if d not in (1, -1):
        raise ValueError("matrix not unimodular")
    adj = adjugate(A)
    return [[d * adj[i][j] for j in range(len(A))] for i in range(len(A))]


# ---------------------------------------------------------------- divisibility

def divides(a, b):
    """Sign-blind integer divisibility a | b, a != 0."""
    return a != 0 and b % a == 0


def exact_div(a, b):
    q, r = divmod(a, b)
    if r != 0:
        raise ValueError(f"{b} does not divide {a}")
    return q


def is_chain(D):
    """d_i | d_j for all i <= j, all entries nonzero (R0036 hypothesis)."""
    if any(d == 0 for d in D):
        return False
    return all(divides(D[i], D[j]) for i in range(len(D)) for j in range(i, len(D)))


# ---------------------------------------------------------------- the four membership tests

def conj_by_D(D, X):
    """Return D^{-1} X D as an exact integer matrix, or None if not integral.

    (D^{-1} X D)_{ij} = X_ij d_j / d_i.
    """
    n = len(D)
    out = []
    for i in range(n):
        row = []
        for j in range(n):
            num = X[i][j] * D[j]
            q, r = divmod(num, D[i])
            if r != 0:
                return None
            row.append(q)
        out.append(row)
    return out


def stabilizer_partner(D, H):
    """The forced K = D^{-1} H^{-1} D (Lemma A) if integral, else None.

    (H, K) is in the two-sided stabilizer of D iff this returns a matrix.
    """
    return conj_by_D(D, unimodular_inverse(H))


def in_stabilizer(D, H):
    """H in GL_n(Z) admits an integer partner K with HDK = D."""
    return stabilizer_partner(D, H) is not None


def in_gamma0_intersection(D, H):
    """H in GL_n(Z) /\\ D GL_n(Z) D^{-1}: D^{-1} H D integral (Lemma B)."""
    return conj_by_D(D, H) is not None


def claimed_chain_condition(D, H):
    """R0036's entrywise description: (d_i/d_j) | H_ij for i > j (chain only)."""
    n = len(D)
    for i in range(n):
        for j in range(i):
            if not divides(exact_div(D[i], D[j]), H[i][j]):
                return False
    return True


def corner_moduli(D):
    """Derived general moduli m_ij = |d_i| / gcd(d_i,d_j) for i != j (Lemma B)."""
    n = len(D)
    return {(i, j): abs(D[i]) // gcd(D[i], D[j])
            for i in range(n) for j in range(n) if i != j}


def general_corner_condition(D, H):
    """Derived description valid for ANY nonzero diagonal: m_ij | H_ij."""
    return all(divides(m, H[i][j]) if m != 1 else True
               for (i, j), m in corner_moduli(D).items())


def modulus_condition(mods, H):
    """Membership under an arbitrary moduli table {(i,j): m} (for mutant tests)."""
    return all(divides(m, H[i][j]) for (i, j), m in mods.items())


# ---------------------------------------------------------------- enumeration

def unimodular_2x2(bound):
    rng = range(-bound, bound + 1)
    for a in rng:
        for b in rng:
            for c in rng:
                for d in rng:
                    if a * d - b * c in (1, -1):
                        yield [[a, b], [c, d]]


def unimodular_3x3(bound):
    """All H in GL_3(Z) with entries in [-bound, bound].

    Iterates (row1, row2) pairs, forms the cross product, and scans row3
    with det = row3 . (row1 x row2) -- exact, with early pruning.
    """
    rng = range(-bound, bound + 1)
    rows = [(a, b, c) for a in rng for b in rng for c in rng]
    for r1 in rows:
        a, b, c = r1
        for r2 in rows:
            d, e, f = r2
            c0 = b * f - c * e
            c1 = c * d - a * f
            c2 = a * e - b * d
            if c0 == 0 and c1 == 0 and c2 == 0:
                continue
            for r3 in rows:
                if r3[0] * c0 + r3[1] * c1 + r3[2] * c2 in (1, -1):
                    yield [list(r1), list(r2), list(r3)]


def sweep_3x3(bound, D_list):
    """One pass over all unimodular 3x3 matrices with entries in [-bound,bound].

    For each diagonal D in D_list, checks agreement of the four membership
    tests on every H:
        stab    : forced-partner integrality  (Lemma A, the ground truth)
        inter   : D^{-1} H D integral         (intersection form, Lemma B)
        derived : general_corner_condition    (gcd moduli, Lemma B)
        claimed : claimed_chain_condition     (R0036 text; chains only)
    Returns (total_unimodular, results) where results[D] is a dict with
    member count, per-entry value sets among members, and any mismatches.
    """
    results = {}
    for D in D_list:
        results[tuple(D)] = {
            "count": 0,
            "entry_vals": {(i, j): set() for i in range(3) for j in range(3) if i != j},
            "mismatch_stab_vs_derived": [],
            "mismatch_stab_vs_claimed": [],
            "mismatch_stab_vs_inter": [],
        }
    total = 0
    chainflag = {tuple(D): is_chain(D) for D in D_list}
    for H in unimodular_3x3(bound):
        total += 1
        Hinv = unimodular_inverse(H)
        for D in D_list:
            key = tuple(D)
            r = results[key]
            stab = conj_by_D(D, Hinv) is not None
            inter = conj_by_D(D, H) is not None
            derived = general_corner_condition(D, H)
            if stab != derived and len(r["mismatch_stab_vs_derived"]) < 3:
                r["mismatch_stab_vs_derived"].append([row[:] for row in H])
            if stab != inter and len(r["mismatch_stab_vs_inter"]) < 3:
                r["mismatch_stab_vs_inter"].append([row[:] for row in H])
            if chainflag[key]:
                claimed = claimed_chain_condition(D, H)
                if stab != claimed and len(r["mismatch_stab_vs_claimed"]) < 3:
                    r["mismatch_stab_vs_claimed"].append([row[:] for row in H])
            if stab:
                r["count"] += 1
                for i in range(3):
                    for j in range(3):
                        if i != j:
                            r["entry_vals"][(i, j)].add(H[i][j])
    return total, results


# ---------------------------------------------------------------- invariants

def determinantal_divisors(M):
    """(g_1, ..., g_n): g_k = gcd of all k x k minors (GL x GL invariant)."""
    n = len(M)
    out = []
    for k in range(1, n + 1):
        g = 0
        for rows in combinations(range(n), k):
            for cols in combinations(range(n), k):
                sub = [[M[r][c] for c in cols] for r in rows]
                g = gcd(g, det(sub))
        out.append(g)
    return tuple(out)


def elementary(n, i, j, v):
    """I + v * E_ij."""
    E = identity(n)
    E[i][j] = v
    return E


# ---------------------------------------------------------------- events / torsor

def partner_V(U, M, D):
    """The unique rational V with U M V = diag(D) is V = (UM)^{-1} diag(D).

    Return it as an exact integer matrix if it is integral and unimodular
    (i.e. (U, V) is a genuine normalization event), else None.
    Exact: (UM)^{-1} = adj(UM) / det(UM), so V = adj(UM) diag(D) / det(UM).
    """
    A = mat_mul(U, M)
    dA = det(A)
    if dA == 0:
        return None
    N = mat_mul(adjugate(A), diag_mat(D))
    V = []
    for i in range(len(M)):
        row = []
        for j in range(len(M)):
            q, r = divmod(N[i][j], dA)
            if r != 0:
                return None
            row.append(q)
        V.append(row)
    if det(V) not in (1, -1):
        return None
    return V


def events_for(M, D, bound):
    """All events (U, V) with U M V = diag(D) and U unimodular with entries
    in [-bound, bound].  (V is forced by U, Lemma A, so this enumerates the
    event set restricted to a U-window.)  Exact integers throughout."""
    n = len(M)
    gen = unimodular_2x2(bound) if n == 2 else unimodular_3x3(bound)
    out = []
    for U in gen:
        V = partner_V(U, M, D)
        if V is not None:
            out.append((U, V))
    return out


def act(D, H, event):
    """The claimed Gamma_0(D)-action H.(U,V) = (HU, V D^{-1} H^{-1} D).

    Raises if H is not in Gamma_0(D) (partner not integral)."""
    U, V = event
    K = stabilizer_partner(D, H)
    if K is None:
        raise ValueError("H not in Gamma_0(D)")
    return mat_mul(H, U), mat_mul(V, K)


def payload(event, base_event):
    """pi(U, V) = U U0^{-1} relative to the base event (U0, V0)."""
    U0 = base_event[0]
    return mat_mul(event[0], unimodular_inverse(U0))


def unpayload(D, H, base_event):
    """Claimed inverse of the payload: H |-> (H U0, V0 D^{-1} H^{-1} D)."""
    U0, V0 = base_event
    K = stabilizer_partner(D, H)
    if K is None:
        raise ValueError("H not in Gamma_0(D)")
    return mat_mul(H, U0), mat_mul(V0, K)
