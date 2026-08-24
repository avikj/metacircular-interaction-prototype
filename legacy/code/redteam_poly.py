"""RED TEAM audit of Theorem A' (REPORT.md section 2.1) and Problem 8.1.

(1) Do reciprocal (palindromic) irreducible NON-cyclotomic 0-1 polynomials
    exist?  Brute force small degrees.
(2) Independently re-verify: F_X = sum_{p<=X} x^{p-2} irreducible for all prime
    cutoffs X <= 2000 except X=11; verify the X=11 factorization identity.
(3) Factor the minimal homometric pair's polynomials to exhibit HOW homometry
    arises from factor reversal, and test the claim of Problem 8.1 that
    "no reciprocal non-cyclotomic factor implies rigidity".
(4) Independent brute-force re-verification of Theorem A: minimal homometric
    pairs among subsets of {0..13}; zero sum-marginal collisions.
"""
import itertools, time
import numpy as np
from flint import fmpz_poly

# ---------------------------------------------------------------- utilities
def poly(coeffs):
    return fmpz_poly(list(map(int, coeffs)))

def rev(p):
    return fmpz_poly(list(reversed(list(p.coeffs()))))

def is_palindromic_pm(p):
    c = list(p.coeffs())
    return c == list(reversed(c)) or c == [-v for v in reversed(c)]

def is_cyclotomic(p):
    """Irreducible monic integer p: cyclotomic iff all roots on unit circle
    (Kronecker).  Numeric root test with margin, backed by an exact test:
    p divides x^m - 1 for some m if cyclotomic-like."""
    c = np.array(list(p.coeffs()), dtype=float)
    if abs(c[-1]) != 1 or abs(c[0]) != 1:
        return False
    r = np.roots(c[::-1])
    if not np.allclose(np.abs(r), 1.0, atol=1e-6):
        return False
    # exact confirmation: find m with p | x^m - 1, phi(m) = deg  =>  m <= 6*deg^2 safe
    d = p.degree()
    x = fmpz_poly([0, 1])
    for m in range(1, max(1000, 3 * d * d)):
        xm = pow(x, m, p) if False else None
        # cheap: evaluate x^m - 1 mod p via repeated multiplication is slow;
        # instead check p | (x^m - 1) by exact division for divisors of small m
        q = fmpz_poly([-1] + [0] * (m - 1) + [1])
        if m >= d and q % p == 0:
            return True
    return False  # numerically on unit circle but no small m found (flag)

# ---------------------------------------------------------------- (1)
def search_reciprocal_noncyclotomic(dmax=14):
    print("== (1) reciprocal irreducible non-cyclotomic 0-1 polynomials ==")
    found = []
    for d in range(2, dmax + 1, 2):          # palindromic 0-1 with c0=cd=1
        inner = d - 1                         # coefficients c1..c_{d-1}, palindromic
        half = (d - 1) // 2 + (1 if (d - 1) % 2 else 0)
        nfree = (d) // 2                      # c1..c_{d/2} determine the rest
        cnt = 0
        for bits in itertools.product([0, 1], repeat=nfree):
            c = [1] + list(bits)
            # complete palindrome of length d+1
            full = c + list(reversed(c[: d + 1 - len(c)]))
            if len(full) != d + 1:
                full = c + list(reversed(c))[len(c) + len(c) - (d + 1):]
            # build robustly:
            full = [0] * (d + 1)
            full[0] = full[d] = 1
            for i, b in enumerate(bits, start=1):
                full[i] = b
                full[d - i] = b
            p = poly(full)
            if p.degree() != d:
                continue
            _, facs = p.factor()
            if len(facs) == 1 and facs[0][1] == 1:
                q = facs[0][0]
                if q.degree() == d and not is_cyclotomic(q):
                    cnt += 1
                    if len(found) < 8:
                        found.append(full)
        print(f"  degree {d:2d}: {cnt} palindromic 0-1 irreducible non-cyclotomic")
    for f in found[:6]:
        print("   example:", f)
    return found

# ---------------------------------------------------------------- (2)
def primes_upto(n):
    s = np.ones(n + 1, bool); s[:2] = False
    for p in range(2, int(n ** .5) + 1):
        if s[p]:
            s[p * p:: p] = False
    return np.nonzero(s)[0]

def FX(X, ps):
    sel = ps[ps <= X]
    c = [0] * (sel[-1] - 1)
    c = [0] * (sel[-1] - 2 + 1)
    for p in sel:
        c[p - 2] = 1
    return poly(c)

def audit_FX(cutoff=2000):
    print(f"\n== (2) irreducibility of F_X for all prime cutoffs X <= {cutoff} ==")
    ps = primes_upto(cutoff)
    bad = []
    t0 = time.time()
    for X in ps:
        if X < 3:
            continue
        f = FX(X, ps)
        _, facs = f.factor()
        nf = sum(e for _, e in facs)
        if nf > 1:
            bad.append((int(X), [(list(map(int, q.coeffs())), e) for q, e in facs]))
    print(f"  scanned {len(ps)} cutoffs in {time.time()-t0:.1f}s; reducible cases: "
          f"{[b[0] for b in bad]}")
    for X, facs in bad:
        print(f"  X={X}:")
        for c, e in facs:
            pal = 'palindromic' if c == c[::-1] else 'NOT palindromic'
            q = poly(c)
            cyc = is_cyclotomic(q) if q.degree() <= 24 else '?'
            print(f"    factor deg {len(c)-1} ^{e}  {pal}  cyclotomic={cyc}  {c}")
    # explicit X=11 identity from REPORT.md
    f11 = FX(11, ps)
    phi6 = poly([1, -1, 1])
    other = poly([1, 2, 1, 0, -1, 0, 1, 1])   # x^7+x^6-x^4+x^2+2x+1
    print(f"  X=11 identity check: F_11 == Phi6 * (x^7+x^6-x^4+x^2+2x+1)? ",
          f11 == phi6 * other)
    if f11 != phi6 * other:
        _, facs = f11.factor()
        print("   actual factorization:", [(list(map(int, q.coeffs())), e) for q, e in facs])

# ---------------------------------------------------------------- (3)
def audit_homometric_factors():
    print("\n== (3) factor structure of the minimal homometric pair ==")
    A = [0, 1, 2, 6, 8, 11]
    B = [0, 1, 6, 7, 9, 11]
    for name, S in [("A", A), ("B", B)]:
        c = [0] * 12
        for s in S:
            c[s] = 1
        p = poly(c)
        _, facs = p.factor()
        print(f"  {name} = {S}")
        for q, e in facs:
            cc = list(map(int, q.coeffs()))
            pal = 'reciprocal(+/-)' if is_palindromic_pm(q) else 'non-reciprocal'
            cyc = is_cyclotomic(q)
            print(f"    deg {q.degree()} ^{e}  {pal}  cyclotomic={cyc}  {cc}")
    print("  If A's factors include >=2 non-reciprocal non-cyclotomic factors and")
    print("  B is obtained by reversing a strict subset, then Problem 8.1's claim")
    print("  'no reciprocal non-cyclotomic factor => rigidity' is refuted.")

# ---------------------------------------------------------------- (4)
def audit_bruteforce(nmax=13):
    print(f"\n== (4) independent brute force over subsets of {{0..{nmax}}} ==")
    def canon(A):
        A = sorted(A); t = tuple(a - A[0] for a in A)
        B = sorted(A[-1] - a for a in A); r = tuple(b - B[0] for b in B)
        return min(t, r)
    sumkeys, diffkeys = {}, {}
    ncoll_sum, pairs = 0, set()
    for k in range(4, 8):
        for rest in itertools.combinations(range(1, nmax + 1), k - 1):
            A = (0,) + rest
            if A[-1] != nmax and 0 not in A:
                pass
            cA = canon(A)
            s = tuple(sorted(a + b for a in A for b in A))
            d = tuple(sorted(abs(a - b) for a in A for b in A))
            if s in sumkeys and sumkeys[s] != cA:
                ncoll_sum += 1
            sumkeys[s] = cA
            if d in diffkeys and diffkeys[d] != cA:
                pairs.add(tuple(sorted([diffkeys[d], cA])))
            else:
                diffkeys[d] = cA
    print(f"  sum-marginal collisions: {ncoll_sum} (claim: 0)")
    md = min(max(p[0][-1], p[1][-1]) for p in pairs) if pairs else None
    six = [p for p in pairs if len(p[0]) == 6]
    print(f"  homometric pairs found: {len(pairs)}; minimal diameter: {md}")
    for p in sorted(pairs)[:4]:
        print("   ", p[0], "~", p[1])

if __name__ == "__main__":
    audit_homometric_factors()
    audit_bruteforce()
    search_reciprocal_noncyclotomic(12)
    audit_FX(2000)
