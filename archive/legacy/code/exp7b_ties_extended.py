"""Experiment 7b: cyclotomic ties of the prime polynomial, extended and explained.

Phi_m | F_X = sum_{p<=X} x^{p-2}  iff  sum_{p<=X} zeta_m^{p-2} = 0 ("tie" of the
zeta_m-weighted prime race).  Known: exactly one tie (X,m)=(11,6) for m<=60,
X<=10^6.  Here:

PART 1 (numerics): full scan m <= 200, X <= 10^7, incremental reduction-row
  method (rows precomputed exactly; scan = chunked numpy cumsums).

PART 2 (numerics): running minimum norm of the reduced vector for m in {3,4,6}
  after X=11 (probing the "2d random walk should recur" heuristic).

PART 3 (exact theory, machine-verified): classification of ties for each m.
  Write the tie condition, for X > m, as
      sum_{c in (Z/m)^*} n_c(X) * v_c  =  -t_m,
  where n_c(X) = #{p <= X unramified : p = c mod m},
  v_c = coeff vector of x^{(c-2) mod m} mod Phi_m, and
  t_m = sum_{p | m} x^{(p-2) mod m} mod Phi_m  (fixed once X >= max prime | m).
  * If -t_m is NOT in the Q-span of {v_c}: ties are IMPOSSIBLE for X > m
    (and the scan certifies X <= m). Unconditional theorem.
  * If m is squarefree, the primitive m-th roots are Q-linearly independent,
    so the map n -> sum n_c v_c is injective: the tie forces n_c to EXACT
    values.  Counts are nondecreasing and -> infinity, so ties occur for at
    most finitely many X, all effectively bounded.  We solve for the forced
    counts and list the ties they permit.
  * Otherwise (mu(m)=0, target in span): the constraint is a mean-zero walk of
    effective dimension rank{v_c}; recurrence heuristic: infinitely many ties
    plausible only if rank <= 2.  (We report whether any such m survives.)
"""
import os, sys, time
import numpy as np
import sympy
from sympy import cyclotomic_poly, primefactors, factorint
from sympy.abc import x
from flint import fmpz_mat

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pairfield import sieve_primes

MMAX = int(os.environ.get("MMAX", 200))
XMAX = int(os.environ.get("XMAX", 10_000_000))
CHUNK = 250_000
OUT = os.environ.get("OUT", os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                         "..", "data", "exp7b_out.txt"))

log_lines = []
def log(s=""):
    print(s, flush=True)
    log_lines.append(s)


def reduction_rows(m):
    """rows[j] = coeff vector of x^j mod Phi_m, j = 0..m-1 (exact, iterative)."""
    phi = [int(c) for c in reversed(cyclotomic_poly(m, x).as_poly(x).all_coeffs())]
    d = len(phi) - 1  # = phi(m), monic
    rows = np.zeros((m, d), dtype=np.int64)
    r = np.zeros(d, dtype=np.int64)
    r[0] = 1
    rows[0] = r
    low = -np.array(phi[:d], dtype=np.int64)  # x^d = low . (1,x,..,x^{d-1})
    for j in range(1, m):
        top = r[d - 1]
        r = np.roll(r, 1)
        r[0] = 0
        r += top * low
        # note: roll moved old r[d-1] into r[0]; we zeroed it and add reduction
        rows[j] = r
    return rows


def int_solve_lattice(A_cols, b):
    """Is b an integer combination of the columns in A_cols (list of int vectors)?
    Returns (solvable_over_Q, solvable_over_Z). Uses HNF of the row-matrix."""
    M = fmpz_mat([list(map(int, v)) for v in A_cols])         # rows = generators
    Mb = fmpz_mat([list(map(int, v)) for v in A_cols] + [list(map(int, b))])
    rQ, rQb = M.rank(), Mb.rank()
    if rQb > rQ:
        return False, False
    H = M.hnf()  # row HNF: basis of the lattice spanned by rows
    Hrows = [list(map(int, [H[i, j] for j in range(H.ncols())]))
             for i in range(H.nrows())]
    Hrows = [r for r in Hrows if any(r)]
    bb = list(map(int, b))
    for r in Hrows:
        piv = next(i for i, v in enumerate(r) if v)
        if bb[piv] % r[piv] != 0:
            return True, False
        q = bb[piv] // r[piv]
        bb = [bi - q * ri for bi, ri in zip(bb, r)]
    return True, all(v == 0 for v in bb)


def classify_m(m, rows):
    """PART 3 for one m. Returns dict describing the tie-classification."""
    d = rows.shape[1]
    units = [c for c in range(m) if sympy.gcd(c, m) == 1] if m > 1 else [0]
    steps = [rows[(c - 2) % m] for c in units]
    t = np.zeros(d, dtype=np.int64)
    for p in primefactors(m):
        t += rows[(p - 2) % m]
    target = -t
    S = fmpz_mat([[int(v) for v in s] for s in steps])
    rank = S.rank()
    sqfree = all(e == 1 for e in factorint(m).values()) if m > 1 else True
    solvQ, solvZ = int_solve_lattice(steps, target)
    forced = None
    if solvQ and sqfree and rank == len(units) == d:
        # unique rational solution: solve steps^T n = target
        A = fmpz_mat([[int(steps[k][i]) for k in range(len(units))] for i in range(d)])
        B = fmpz_mat([[int(v)] for v in target])
        try:
            sol = A.solve(B)  # rational solution
            forced = [(units[k], sol[k, 0]) for k in range(len(units))]
        except Exception:
            forced = "singular?"
    return dict(m=m, phi=d, rank=rank, sqfree=sqfree, mu=int(sympy.mobius(m)),
                solvQ=solvQ, solvZ=solvZ, forced=forced)


def main():
    t00 = time.time()
    log(f"# exp7b: cyclotomic ties, m <= {MMAX}, X <= {XMAX:.0e}; started {time.strftime('%FT%TZ', time.gmtime())}")
    isp = sieve_primes(XMAX)
    primes = np.nonzero(isp)[0].astype(np.int64)
    N = len(primes)
    log(f"pi({XMAX}) = {N}")

    ms = list(range(2, MMAX + 1))
    t0 = time.time()
    ROWS = {m: reduction_rows(m) for m in ms}
    log(f"reduction rows precomputed for m=2..{MMAX} in {time.time()-t0:.1f}s; "
        f"max |coeff| = {max(int(np.abs(R).max()) for R in ROWS.values())}")

    # ---------- PART 1: scan ----------
    log("\n== PART 1: tie scan ==")
    t0 = time.time()
    ties = []
    minstats = {}   # m -> per-decade min L2^2 norm and argmin, for m in {3,4,6}
    TRACK = (3, 4, 6)
    for m in ms:
        R = ROWS[m]
        d = R.shape[1]
        carry = np.zeros(d, dtype=np.int64)
        resid = ((primes - 2) % m).astype(np.int64)
        track = m in TRACK
        if track:
            minstats[m] = {}
        for lo in range(0, N, CHUNK):
            hi = min(lo + CHUNK, N)
            V = R[resid[lo:hi]]           # (chunk, d)
            V = np.cumsum(V, axis=0)
            V += carry
            carry = V[-1].copy()
            # tie check (skip first two primes: cutoffs X >= 5)
            start = max(lo, 2) - lo
            if start < hi - lo:
                cand = np.nonzero(V[start:, 0] == 0)[0] + start
                for i in cand:
                    if not V[i].any():
                        X = int(primes[lo + i])
                        ties.append((X, m))
                        log(f"TIE: Phi_{m} | F_X at X={X} (pi(X)={lo+i+1})")
            if track:
                n2 = np.einsum('ij,ij->i', V, V)  # squared L2 norms
                # decade buckets by X
                Xs = primes[lo:hi]
                for i in range(start, hi - lo):
                    pass  # (vectorized below)
                dec = np.log10(Xs).astype(int)
                for dd in np.unique(dec):
                    sel = (dec == dd)
                    sel[:start] = sel[:start] & False if lo == 0 else sel[:start]
                    if lo == 0:
                        sel[:2] = False
                    if not sel.any():
                        continue
                    j = np.nonzero(sel)[0][np.argmin(n2[sel])]
                    best = (float(n2[j]), int(Xs[j]))
                    cur = minstats[m].get(int(dd))
                    if cur is None or best[0] < cur[0]:
                        minstats[m][int(dd)] = best
    log(f"scan done in {time.time()-t0:.1f}s; ties found: {len(ties)} -> {ties}")

    # ---------- PART 2: near-tie / min-norm report for m = 3, 4, 6 ----------
    log("\n== PART 2: running min |v_m| (squared L2) per decade of X, m in {3,4,6} ==")
    log("(v_m = reduced vector; v_m = 0 is a tie. Excludes X < 5.)")
    for m in TRACK:
        log(f" m={m}:")
        for dd in sorted(minstats[m]):
            n2, X = minstats[m][dd]
            log(f"   10^{dd} <= X < 10^{dd+1}:  min |v|^2 = {int(n2)} at X={X}")
    # exact count of |v|^2 == 1 events for m=4 (race ties mod 4) over full range
    m = 4
    R = ROWS[4]
    resid = ((primes - 2) % 4).astype(np.int64)
    V = np.cumsum(R[resid], axis=0)
    n2 = np.einsum('ij,ij->i', V, V)
    n2[:2] = 10**9
    cnt1 = int(np.sum(n2 == 1))
    first = primes[np.nonzero(n2 == 1)[0][:5]] if cnt1 else []
    log(f" m=4: |v|^2=1 (i.e. mod-4 race tie n_1=n_3, floor of the frozen p=2 "
        f"coordinate) at {cnt1} prime cutoffs; first few X: {list(map(int,first))}")
    for m in (3, 6):
        R = ROWS[m]
        resid = ((primes - 2) % m).astype(np.int64)
        V = np.cumsum(R[resid], axis=0)
        n2 = np.einsum('ij,ij->i', V, V)
        n2[:2] = 10**9
        after = n2[primes > 11]
        Xafter = primes[primes > 11]
        j = int(np.argmin(after))
        log(f" m={m}: min |v|^2 for X in (11, 10^7] = {int(after[j])} at X={int(Xafter[j])}"
            f" (theory: one coordinate is monotone -> transient, no recurrence)")
    del V, n2

    # ---------- PART 3: exact classification ----------
    log("\n== PART 3: exact classification of ties, per m (machine-verified) ==")
    log("columns: m, phi(m), mu(m), squarefree, rank(step lattice), target in Q-span,"
        " target in Z-lattice, forced counts (squarefree case)")
    never, forcedfinite, walkers = [], [], []
    t0 = time.time()
    for m in ms:
        c = classify_m(m, ROWS[m])
        if not c['solvQ'] or (c['solvQ'] and not c['solvZ']):
            never.append(m)
            verdict = "NEVER (X>m): target not in step lattice"
        elif c['sqfree']:
            forcedfinite.append((m, c['forced']))
            verdict = f"FINITE: forced counts {c['forced']}"
        else:
            walkers.append((m, c['rank']))
            verdict = f"WALK dim {c['rank']} (recurrence heuristic: {'RECURRENT' if c['rank']<=2 else 'transient'})"
        log(f" m={m:3d} phi={c['phi']:3d} mu={c['mu']:2d} sqfree={int(c['sqfree'])} "
            f"rank={c['rank']:3d} Qspan={int(c['solvQ'])} Zlat={int(c['solvZ'])}  {verdict}")
    log(f"\nclassification time {time.time()-t0:.1f}s")
    log(f"NEVER-tie m (proven, X>m; X<=m certified by scan): {len(never)} values")
    log(f"  {never}")
    log(f"squarefree m with forced finite counts: {len(forcedfinite)} values")
    for m, f in forcedfinite:
        if f is not None and f != 'singular?':
            fs = {c: str(v) for c, v in f}
            nonint = any('/' in s for s in fs.values())
            neg = any(s.startswith('-') for s in fs.values())
            tag = " (NO nonneg-integer solution -> NEVER for X>m)" if (nonint or neg) else ""
            log(f"  m={m}: forced n_c = {fs}{tag}")
    log(f"non-squarefree m with target in lattice (potential recurrent walkers): {walkers}")

    # ---------- PART 3b: exact tie intervals for squarefree m (ALL X, not just X<=XMAX) ----------
    log("\n== PART 3b: exact tie set for squarefree m (valid for ALL X > max prime | m) ==")
    log("tie iff n_c(X) = t_c for every class c; counts are monotone, so the tie set")
    log("is the interval [max_c L_c, min_c U_c) with L_c = t_c-th prime in class c,")
    log("U_c = (t_c+1)-th.  (X <= max prime | m <= 200 is separately certified by the scan.)")
    P0 = primes[:50000]
    all_ties_allX = []
    for m, f in forcedfinite:
        if f is None or f == 'singular?':
            continue
        try:
            tc = {c: int(v) for c, v in ((c, sympy.Rational(str(v))) for c, v in f)
                  if sympy.Rational(str(v)).is_integer}
            if len(tc) != len(f) or any(v < 0 for v in tc.values()):
                log(f" m={m}: forced counts non-integral or negative -> NEVER (X > m)")
                continue
        except Exception:
            continue
        pm = P0 % m
        lo, hi = 0, np.inf
        feasible = True
        for c, t in tc.items():
            cp = P0[pm == c]
            if t > len(cp):
                feasible = False
                break
            L = 0 if t == 0 else int(cp[t - 1])
            U = int(cp[t]) if t < len(cp) else np.inf
            lo, hi = max(lo, L), min(hi, U)
        if not feasible or lo >= hi:
            log(f" m={m}: tie interval empty -> NEVER (for X > max prime | m)")
        else:
            tX = [int(p) for p in primes[(primes >= max(lo, 3)) & (primes < hi)]]
            log(f" m={m}: tie interval [X in [{lo},{hi})) -> tie at prime cutoffs {tX}")
            all_ties_allX += [(X, m) for X in tX]
    log(f"\ncomplete tie list over ALL X (m squarefree <= {MMAX}, X > max p|m): {all_ties_allX}")
    log(f"\ntotal time {time.time()-t00:.1f}s")
    with open(OUT, "w") as fh:
        fh.write("\n".join(log_lines) + "\n")


def extend_classification(lo, hi, xscan=2000):
    """Fast Part-3-only classification for m in [lo, hi] (no big scan).
    Squarefree m: unique Q-solution (Lemma F2.1 in notes/RIGIDITY_FRONTIER.md)
    -> direct fmpz_mat.solve, then exact tie interval from class primes.
    Non-squarefree m: Z-lattice membership test (HNF). A mini-scan X <= xscan
    covers the X <= m region where the ramified part is not yet complete.
    Valid classification of ALL X for every m in range. Appends to OUT."""
    from flint import fmpz_mat as _fm
    t00 = time.time()
    isp = sieve_primes(300000)
    primes = np.nonzero(isp)[0].astype(np.int64)
    small = primes[primes <= xscan]
    assert xscan >= hi
    never_lat = never_forced = 0
    tie_hits, walkers = [], []
    for m in range(lo, hi + 1):
        R = reduction_rows(m)
        d = R.shape[1]
        units = [c for c in range(m) if sympy.gcd(c, m) == 1]
        steps = [R[(c - 2) % m] for c in units]
        t = np.zeros(d, dtype=np.int64)
        for p in primefactors(m):
            t += R[(p - 2) % m]
        target = (-t).tolist()
        sqfree = all(e == 1 for e in factorint(m).values())
        v = np.zeros(d, dtype=np.int64)
        for i, p in enumerate(small):
            v += R[(int(p) - 2) % m]
            if i >= 2 and not v.any():
                tie_hits.append((int(p), m))
        if sqfree:
            A = _fm([[int(steps[k][i]) for k in range(len(units))] for i in range(d)])
            B = _fm([[int(x)] for x in target])
            sol = A.solve(B)
            tc, ok = {}, True
            for k in range(len(units)):
                r = sympy.Rational(str(sol[k, 0]))
                if not r.is_integer or r < 0:
                    ok = False
                    break
                tc[units[k]] = int(r)
            if not ok:
                never_forced += 1
                continue
            pm = primes % m
            lo_, hi_ = 0, float('inf')
            for cls, tt in tc.items():
                cp = primes[pm == cls]
                L = 0 if tt == 0 else int(cp[tt - 1])
                U = int(cp[tt]) if tt < len(cp) else float('inf')
                lo_, hi_ = max(lo_, L), min(hi_, U)
            if lo_ < hi_:
                tie_hits += [(int(p), m) for p in
                             primes[(primes >= max(lo_, 3)) & (primes < hi_)]]
            else:
                never_forced += 1
        else:
            solvQ, solvZ = int_solve_lattice(steps, target)
            if solvQ and solvZ:
                walkers.append(m)
            else:
                never_lat += 1
    msg = [f"\n== EXTENSION: exact classification m in [{lo},{hi}], ALL X "
           f"(mini-scan X<={xscan}) ==",
           f"non-squarefree, target outside step lattice (NEVER): {never_lat}",
           f"squarefree, forced counts infeasible (NEVER): {never_forced}",
           f"solvable non-squarefree walkers: {walkers}",
           f"complete tie list (ALL X) in this m-range: {sorted(set(tie_hits))}",
           f"time {time.time()-t00:.1f}s"]
    print("\n".join(msg), flush=True)
    with open(OUT, "a") as fh:
        fh.write("\n".join(msg) + "\n")


if __name__ == "__main__":
    ext = os.environ.get("EXTEND")
    if ext:
        lo, hi = map(int, ext.split(":"))
        extend_classification(lo, hi)
    else:
        main()
