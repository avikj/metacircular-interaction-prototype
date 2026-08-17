"""cf-rune independent replay of PM_SECTION_VS_COCYCLE (cross-review).

Rebuilds the Peres-Mermin section/cocycle result from scratch, with code
written independently of machinery/pm_section_cocycle.py:

  1. exact Pauli matrix products give sign vector (+,+,+ | +,+,-);
  2. Weyl 2-cocycle mu on F2^4 with Z4 values satisfies the cocycle
     identity on all 4096 triples; gauge law A = i^phi P_v on all nine
     observables; derived signs equal matrix signs;
  3. planted-false control: dropping the gauge cochain phi changes signs;
  4. delta : F2^9 -> F2^6 has rank 5, coker dim 1; each context has 4
     local sections; global sections number 0 (solver + 512 exhaustion);
  5. rows-only cover admits sections; one-edge local-system twist on ZZ
     kills the class and yields exactly 16 twisted sections.

All arithmetic is exact (Gaussian integers via Python complex with
integer parts; F2 elimination in pure Python). Run: python3 <this file>.
"""

import itertools, sys

# ---------- exact 2x2 Paulis and tensor products ----------
I2 = ((1, 0), (0, 1))
X = ((0, 1), (1, 0))
Z = ((1, 0), (0, -1))
Y = ((0, -1j), (1j, 0))

def mat_mul(A, B):
    n = len(A)
    return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(n))
                       for j in range(n)) for i in range(n))

def kron(A, B):
    n, m = len(A), len(B)
    return tuple(tuple(A[i // m][j // m] * B[i % m][j % m]
                       for j in range(n * m)) for i in range(n * m))

def scal(c, A):
    return tuple(tuple(c * x for x in row) for row in A)

I4 = kron(I2, I2)

# ---------- the square, with Weyl labels v = (a1,b1,a2,b2) ----------
# single-qubit label: X^a Z^b ; Y has (a,b) = (1,1)
P1 = {(0, 0): I2, (1, 0): X, (0, 1): Z, (1, 1): mat_mul(X, Z)}  # XZ = -iY

def weyl(v):
    return kron(P1[(v[0], v[1])], P1[(v[2], v[3])])

# observables: name -> (matrix, label)
def pauli(c):
    return {"I": I2, "X": X, "Y": Y, "Z": Z}[c]

square = [["XI", "IX", "XX"],
          ["IZ", "ZI", "ZZ"],
          ["XZ", "ZX", "YY"]]

def label(name):
    lab = {"I": (0, 0), "X": (1, 0), "Y": (1, 1), "Z": (0, 1)}
    return lab[name[0]] + lab[name[1]]

def matrix(name):
    return kron(pauli(name[0]), pauli(name[1]))

names = [n for row in square for n in row]
contexts = [tuple(square[i]) for i in range(3)] + \
           [tuple(square[i][j] for i in range(3)) for j in range(3)]

# ---------- 1. matrix sign vector ----------
def context_sign(ctx):
    M = I4
    for n in ctx:
        M = mat_mul(M, matrix(n))
    if M == I4:
        return 0
    if M == scal(-1, I4):
        return 1
    raise AssertionError("context product not +-I: %s" % (ctx,))

s = [context_sign(c) for c in contexts]
assert s == [0, 0, 0, 0, 0, 1], s
print("1. matrix sign vector (+,+,+|+,+,-): OK")

# ---------- 2. cocycle mu, gauge phi, derived signs ----------
F24 = list(itertools.product((0, 1), repeat=4))

def vadd(u, v):
    return tuple((a + b) % 2 for a, b in zip(u, v))

POW_I = {0: 1, 1: 1j, 2: -1, 3: -1j}

def mu(u, v):
    prod = mat_mul(weyl(u), weyl(v))
    tgt = weyl(vadd(u, v))
    for k in range(4):
        if prod == scal(POW_I[k], tgt):
            return k
    raise AssertionError("P_u P_v not i^k P_{u+v}")

MU = {(u, v): mu(u, v) for u in F24 for v in F24}
bad = [(u, v, w) for u in F24 for v in F24 for w in F24
       if (MU[(u, v)] + MU[(vadd(u, v), w)]
           - MU[(v, w)] - MU[(u, vadd(v, w))]) % 4 != 0]
assert not bad, bad[:3]
print("2a. cocycle identity on all 4096 triples: OK")

def phi(name):
    return name.count("Y")

for n in names:
    assert matrix(n) == scal(POW_I[phi(n) % 4], weyl(label(n))), n
print("2b. gauge law A = i^phi(A) P_v on all nine observables: OK")

def derived_sign(ctx, use_phi=True):
    u, v, w = (label(n) for n in ctx)
    assert vadd(vadd(u, v), w) == (0, 0, 0, 0)
    e = MU[(u, v)] + MU[(vadd(u, v), w)]
    if use_phi:
        e += sum(phi(n) for n in ctx)
    e %= 4
    assert e in (0, 2), (ctx, e)
    return 0 if e == 0 else 1

assert [derived_sign(c) for c in contexts] == s
print("2c. derived signs equal matrix signs: OK")

# ---------- 3. planted-false control ----------
def try_no_phi():
    out = []
    for c in contexts:
        u, v, w = (label(n) for n in c)
        e = (MU[(u, v)] + MU[(vadd(u, v), w)]) % 4
        out.append(e)
    return out

nophi = try_no_phi()
assert any(e in (1, 3) or (0 if e == 0 else 1) != sv
           for e, sv in zip(nophi, s)), "control failed to fail"
print("3.  dropping phi breaks the signs (planted-false control): OK")

# ---------- 4. F2 incidence, rank, sections ----------
# delta: F2^9 -> F2^6, (delta x)_c = sum of x over observables in c
rows = [[1 if n in c else 0 for n in names] for c in contexts]

def f2_rank_and_solve(A, b):
    """Return (rank, solvable, num_solutions) over F2."""
    m, n = len(A), len(A[0])
    aug = [row[:] + [bb] for row, bb in zip(A, b)]
    r = 0
    for col in range(n):
        piv = next((i for i in range(r, m) if aug[i][col]), None)
        if piv is None:
            continue
        aug[r], aug[piv] = aug[piv], aug[r]
        for i in range(m):
            if i != r and aug[i][col]:
                aug[i] = [(a + p) % 2 for a, p in zip(aug[i], aug[r])]
        r += 1
    solvable = all(any(row[:-1]) or not row[-1] for row in aug)
    return r, solvable, (2 ** (n - r) if solvable else 0)

rank, solvable, _ = f2_rank_and_solve(rows, s)
assert rank == 5 and not solvable
print("4a. rank(delta) = 5, coker dim 1, delta x = s unsolvable: OK")

count = sum(1 for x in itertools.product((0, 1), repeat=9)
            if all(sum(x[names.index(n)] for n in c) % 2 == sv
                   for c, sv in zip(contexts, s)))
assert count == 0
print("4b. 512-fold exhaustion, global sections = 0: OK")

for c, sv in zip(contexts, s):
    loc = sum(1 for t in itertools.product((0, 1), repeat=3)
              if sum(t) % 2 == sv)
    assert loc == 4, (c, loc)
print("4c. each context has exactly 4 local sections: OK")

# ---------- 5. cover-relative and local-system-relative ----------
rrank, rsolv, rcount = f2_rank_and_solve(rows[:3], s[:3])
assert rsolv and rcount == 2 ** (9 - rrank)
print("5a. rows-only cover admits sections (%d of them): OK" % rcount)

# twist the identification of ZZ between its two contexts: flip s in one
zz_ctxs = [i for i, c in enumerate(contexts) if "ZZ" in c]
assert len(zz_ctxs) == 2
for i in zz_ctxs:
    s2 = s[:]
    s2[i] ^= 1
    r2, ok2, n2 = f2_rank_and_solve(rows, s2)
    assert ok2 and n2 == 16, (i, ok2, n2)
print("5b. one-edge ZZ twist kills the class; 16 twisted sections: OK")

print("ALL CHECKS PASSED — PM_SECTION_VS_COCYCLE independently replayed")
