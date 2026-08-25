#!/usr/bin/env python3
"""Peres-Mermin under one typed diagram: section failure vs cocycle phase.

    python3 machinery/pm_section_cocycle.py

Executes madhavi's 0366 physics spark (claimed msg 0368, forecast
0.6/0.3/0.1): for the Peres-Mermin square, separate exactly
  (a) the missing compatible section (sheaf-level obstruction),
  (b) the cocycle phase (operator-level projective structure),
and say which the contextuality obstruction IS, under one typed diagram:

    mu : F2^4 x F2^4 -> Z4          (operator phase 2-cocycle, COMPUTED
                                     from exact Gaussian-integer matrices,
                                     cocycle identity verified exhaustively)
        |  evaluate on the 6 commuting contexts
        v
    s : contexts -> F2              (required sign vector, DERIVED not
                                     postulated: rows +,+,+  cols +,+,-)
        |  connecting map: class of s in coker(delta)
        v
    [s] in F2^6 / im(delta)  ~ F2   (the combinatorial obstruction class)

Global sections exist iff [s] = 0. Everything below is exact integer
arithmetic; every sign is computed from the actual Pauli algebra.
"""

from __future__ import annotations

from itertools import product

# -------------------------------------------------------------------------
# exact Gaussian-integer 2x2/4x4 matrices: entries are (re, im) int pairs
# -------------------------------------------------------------------------

def gmul(x, y):
    return (x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def gadd(x, y):
    return (x[0] + y[0], x[1] + y[1])


def mat_mul(A, B):
    n = len(A)
    return [[
        __import__("functools").reduce(gadd, (gmul(A[i][k], B[k][j])
                                               for k in range(n)), (0, 0))
        for j in range(n)] for i in range(n)]


def tensor(A, B):
    n, m = len(A), len(B)
    return [[gmul(A[i // m][j // m], B[i % m][j % m])
             for j in range(n * m)] for i in range(n * m)]


I2 = [[(1, 0), (0, 0)], [(0, 0), (1, 0)]]
X = [[(0, 0), (1, 0)], [(1, 0), (0, 0)]]
Y = [[(0, 0), (0, -1)], [(0, 1), (0, 0)]]
Z = [[(1, 0), (0, 0)], [(0, 0), (-1, 0)]]
PAULI1 = {"I": I2, "X": X, "Y": Y, "Z": Z}


def op(two: str):
    return tensor(PAULI1[two[0]], PAULI1[two[1]])


def scalar_of(M):
    """If M = c*Identity with c in {1,-1,i,-i}, return c; else None."""
    n = len(M)
    c = M[0][0]
    for i in range(n):
        for j in range(n):
            want = c if i == j else (0, 0)
            if M[i][j] != want:
                return None
    return c


# -------------------------------------------------------------------------
# the Peres-Mermin square, signs DERIVED from the algebra
# -------------------------------------------------------------------------

GRID = [["XI", "IX", "XX"],
        ["IY", "YI", "YY"],
        ["XY", "YX", "ZZ"]]

CONTEXTS = ([tuple(GRID[r][c] for c in range(3)) for r in range(3)] +
            [tuple(GRID[r][c] for r in range(3)) for c in range(3)])


def context_signs():
    """Compute each context's product exactly; must be +/-1 times identity."""
    signs = []
    for ctx in CONTEXTS:
        P = op(ctx[0])
        for name in ctx[1:]:
            P = mat_mul(P, op(name))
        c = scalar_of(P)
        assert c in ((1, 0), (-1, 0)), "context product is not +/-I: %r" % (c,)
        signs.append(0 if c == (1, 0) else 1)     # additive F2: 0=+1, 1=-1
    return signs


def commuting_certificate():
    """Every context is a commuting triple (checked by exact matrices)."""
    for ctx in CONTEXTS:
        for a in range(3):
            for b in range(a + 1, 3):
                A, B = op(ctx[a]), op(ctx[b])
                if mat_mul(A, B) != mat_mul(B, A):
                    return False
    return True


# -------------------------------------------------------------------------
# upstream object: the operator phase 2-cocycle mu on F2^4 with values Z4
# -------------------------------------------------------------------------
# canonical representative of symplectic vector (a1,b1,a2,b2):
#   P_v = (X^a1 Z^b1) tensor (X^a2 Z^b2)   -- phase-free normal form.

def sym_of(name: str):
    v = []
    for ch in name:
        v += {"I": [0, 0], "X": [1, 0], "Y": [1, 1], "Z": [0, 1]}[ch]
    return tuple(v)


def canon(v):
    def single(a, b):
        M = I2
        if a:
            M = X
        if a and b:
            M = mat_mul(X, Z)
        elif b:
            M = Z
        return M
    return tensor(single(v[0], v[1]), single(v[2], v[3]))


def vadd(u, v):
    return tuple((a + b) % 2 for a, b in zip(u, v))


IPOW = {(1, 0): 0, (0, 1): 1, (-1, 0): 2, (0, -1): 3}


def mu(u, v):
    """P_u P_v = i^mu(u,v) P_{u+v}, computed exactly. Values in Z4."""
    lhs = mat_mul(canon(u), canon(v))
    rhs = canon(vadd(u, v))
    # lhs = c * rhs with c a power of i: find c from first nonzero entry
    for i in range(4):
        for j in range(4):
            if rhs[i][j] != (0, 0):
                a, b = rhs[i][j]
                c, d = lhs[i][j]
                # solve (c,d) = (x,y)*(a,b) over Gaussian integers, |x+iy|=1
                den = a * a + b * b
                x = (c * a + d * b) // den
                y = (d * a - c * b) // den
                assert (x * a - y * b, x * b + y * a) == (c, d)
                return IPOW[(x, y)]
    raise AssertionError("zero matrix")


def cocycle_identity_exhaustive():
    """mu(u,v)+mu(u+v,w) == mu(v,w)+mu(u,v+w) mod 4, all 16^3 triples."""
    vs = list(product((0, 1), repeat=4))
    for u in vs:
        for v in vs:
            for w in vs:
                if (mu(u, v) + mu(vadd(u, v), w)) % 4 != \
                   (mu(v, w) + mu(u, vadd(v, w))) % 4:
                    return False
    return True


def gauge(name: str) -> int:
    """The representative 1-cochain: actual observable = i^gauge * P_sym.
    Each Pauli Y is i * (XZ), so gauge counts Y factors (value in Z4)."""
    return name.count("Y") % 4


def signs_from_mu():
    """Pushforward: context sign = gauge 1-cochain + mu 2-cocycle terms.
    A_x = i^{gauge(x)} P_{sym(x)}, so for a closed triple u+v+w = 0:
      A_u A_v A_w = i^{gauge(u)+gauge(v)+gauge(w) + mu(u,v)+mu(u+v,w)} I.
    The phase thus SPLITS as (gauge part) + (cocycle part) -- the typed
    diagram's upstream object is the pair (phi, mu), and only their sum
    on closed contexts is representative-independent."""
    out = []
    for ctx in CONTEXTS:
        u, v, w = (sym_of(n) for n in ctx)
        assert vadd(vadd(u, v), w) == (0, 0, 0, 0)
        ph = (sum(gauge(n) for n in ctx) + mu(u, v) + mu(vadd(u, v), w)) % 4
        assert ph in (0, 2), "context phase not +/-1"
        out.append(0 if ph == 0 else 1)
    return out


# -------------------------------------------------------------------------
# downstream object: delta over F2 and the obstruction class
# -------------------------------------------------------------------------

OBS = sorted({n for row in GRID for n in row})


def incidence():
    return [[1 if o in ctx else 0 for o in OBS] for ctx in CONTEXTS]


def f2_solve(M, b):
    """Solve Mx=b over F2; return (rank, solution or None, coker_dim)."""
    rows = [list(r) + [bb] for r, bb in zip([r[:] for r in M], b)]
    n, m = len(rows), len(rows[0]) - 1
    piv = []
    r = 0
    for c in range(m):
        for i in range(r, n):
            if rows[i][c]:
                rows[r], rows[i] = rows[i], rows[r]
                for k in range(n):
                    if k != r and rows[k][c]:
                        rows[k] = [(a + bb) % 2 for a, bb in zip(rows[k], rows[r])]
                piv.append(c)
                r += 1
                break
    for i in range(r, n):
        if rows[i][m]:
            return r, None, n - r
    x = [0] * m
    for i, c in enumerate(piv):
        x[c] = rows[i][m]
    return r, x, n - r


def run():
    report = {}
    report["commuting"] = commuting_certificate()
    s_matrix = context_signs()
    s_mu = signs_from_mu()
    report["signs"] = s_matrix
    report["pushforward_agrees"] = s_matrix == s_mu
    report["cocycle_identity"] = cocycle_identity_exhaustive()

    M = incidence()
    rank, sol, coker = f2_solve(M, s_matrix)
    report["rank"], report["coker_dim"] = rank, coker
    report["global_section"] = sol            # None == PM theorem
    # exhaustive confirmation over all 512 assignments
    count = 0
    for bits in product((0, 1), repeat=9):
        v = dict(zip(OBS, bits))
        if all(sum(v[o] for o in ctx) % 2 == s for ctx, s in
               zip(CONTEXTS, s_matrix)):
            count += 1
    report["global_sections_exhaustive"] = count
    # local sections per context
    report["local_sections_per_context"] = [
        sum(1 for t in product((0, 1), repeat=3) if sum(t) % 2 == s)
        for s in s_matrix]
    # the class: parity functional (kernel of M^T sums contexts)
    report["obstruction_class"] = sum(s_matrix) % 2

    # CONTROL 1 (cover-dependence): rows only -> sections exist
    r3, sol3, _ = f2_solve(M[:3], s_matrix[:3])
    report["rows_only_section_exists"] = sol3 is not None

    # CONTROL 2 (local-system twist): flip the identification of ZZ between
    # its row and column: replace s by s + delta(indicator ZZ in col ctx)
    tw = list(s_matrix)
    for i, ctx in enumerate(CONTEXTS[3:], start=3):
        if "ZZ" in ctx:
            tw[i] = (tw[i] + 1) % 2
    rt, solt, _ = f2_solve(M, tw)
    # count twisted sections exhaustively
    tcount = 0
    for bits in product((0, 1), repeat=9):
        v = dict(zip(OBS, bits))
        if all(sum(v[o] for o in ctx) % 2 == s for ctx, s in zip(CONTEXTS, tw)):
            tcount += 1
    report["twisted_section_exists"] = solt is not None
    report["twisted_sections_count"] = tcount

    # CONTROL 3 (planted false): all-plus sign vector must admit sections
    rp, solp, _ = f2_solve(M, [0] * 6)
    report["all_plus_sections_exist"] = solp is not None
    return report


def main() -> int:
    r = run()
    print("commuting contexts (exact matrices):", r["commuting"])
    print("derived sign vector (rows,cols):    ", r["signs"],
          " (0=+1, 1=-1)")
    print("mu is a 2-cocycle (16^3 exhaustive): ", r["cocycle_identity"])
    print("pushforward mu -> s agrees:          ", r["pushforward_agrees"])
    print("incidence rank over F2: %d, coker dim: %d"
          % (r["rank"], r["coker_dim"]))
    print("obstruction class [s] in coker ~ F2: ", r["obstruction_class"])
    print("global sections: solver=%s exhaustive=%d"
          % (r["global_section"], r["global_sections_exhaustive"]))
    print("local sections per context:          ", r["local_sections_per_context"])
    print("CONTROL rows-only cover: sections exist =", r["rows_only_section_exists"])
    print("CONTROL one-edge local-system twist: sections exist = %s (count %d)"
          % (r["twisted_section_exists"], r["twisted_sections_count"]))
    print("CONTROL all-plus signs: sections exist =", r["all_plus_sections_exist"])
    ok = (r["commuting"] and r["cocycle_identity"] and r["pushforward_agrees"]
          and r["global_section"] is None and r["global_sections_exhaustive"] == 0
          and r["obstruction_class"] == 1 and r["rows_only_section_exists"]
          and r["twisted_section_exists"] and r["all_plus_sections_exist"])
    print("VERDICT: obstruction = nonzero class in coker(delta) ~ F2,"
          " reached as pushforward of the operator cocycle;"
          " cover-relative and twist-relative:", "CONSISTENT" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
