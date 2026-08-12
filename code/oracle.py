"""Candidate generator for closed-form recognition in the math loop.

Motivation (METALOOP.md): three times tonight a measured float became a
theorem because someone recognized its closed form by hand:
  0.0937731164 -> (gamma^2 + 2*gamma_1)/2      (crossover third order, K2 II)
  0.0461910    -> 2 + gamma - log(4*pi)        (screw mass, SCREW.md)
  0.4509       -> exp(-Ein(1))                 (crossover profile)
This tool mechanizes one narrow move: PSLQ integer-relation detection over a
declared curated basis.  Its output is never evidence of identity and may not
promote a discovery packet beyond conjecture/formalizing.  Multiple testing,
algebraic dependence in the basis, and uncertain input digits can all create
false recognitions.  A candidate must survive higher-precision recomputation,
basis ablation, held-out digits, and then an independent proof.

Usage:  python3 oracle.py 0.0937731164
        python3 oracle.py 0.0461910 --tol 1e-6
or from code: from oracle import recognize; recognize(x)
"""
import sys
import mpmath as mp

mp.mp.dps = 30


def basis():
    """Curated constants of this program's world, with names."""
    g = mp.euler
    g1 = mp.mpf('-0.0728158454836767248605863758749')   # Stieltjes gamma_1
    g2 = mp.mpf('-0.00969036319287691890560770')        # gamma_2
    C2 = mp.mpf('0.66016181584686957392781211')         # twin prime constant
    b = {
        '1': mp.mpf(1),
        'gamma': g,
        'gamma^2': g * g,
        'gamma_1': g1,
        'gamma_2': g2,
        'log2': mp.log(2),
        'logpi': mp.log(mp.pi),
        'log2pi': mp.log(2 * mp.pi),
        'pi^2': mp.pi ** 2,
        'pi': mp.pi,
        'zeta(3)': mp.zeta(3),
        'e^gamma': mp.exp(g),
        'C2_twin': C2,
        'log^2(2)': mp.log(2) ** 2,
        'gamma*log2': g * mp.log(2),
    }
    return b


def recognize(x, tol=1e-9, max_coeff=64, max_terms=4, denominators=(1, 2, 3, 4, 6, 8, 12, 24)):
    """Try to express x as a small rational combination of basis constants.

    Strategy: for each small subset of the basis containing '1', run PSLQ on
    [x] + subset; accept relations with small integer coefficients and verify
    to tol. Returns list of (expression string, residual) sorted by size.
    """
    x = mp.mpf(x)
    b = basis()
    names = list(b.keys())
    results = []
    from itertools import combinations
    # always try single-constant rational multiples first
    for n in names:
        if n == '1':
            continue
        for d in denominators:
            for num in range(-max_coeff, max_coeff + 1):
                if num == 0:
                    continue
                cand = mp.mpf(num) / d * b[n]
                if abs(cand - x) < tol * max(1, abs(x)):
                    results.append((f"({num}/{d})*{n}", float(abs(cand - x))))
    # PSLQ over subsets
    for k in range(2, max_terms + 1):
        for sub in combinations([n for n in names], k):
            vec = [x] + [b[n] for n in sub]
            try:
                rel = mp.pslq(vec, tol=mp.mpf(10) ** (-12), maxcoeff=max_coeff, maxsteps=2000)
            except Exception:
                rel = None
            if rel and rel[0] != 0:
                # rel[0]*x + sum rel[i]*b = 0  ->  x = -sum(rel[i]/rel[0]) b_i
                expr_terms = []
                val = mp.mpf(0)
                for c, n in zip(rel[1:], sub):
                    if c:
                        expr_terms.append(f"({-c}/{rel[0]})*{n}")
                        val += mp.mpf(-c) / rel[0] * b[n]
                if expr_terms and abs(val - x) < tol * max(1, abs(x)):
                    results.append((" + ".join(expr_terms), float(abs(val - x))))
        if results:
            break
    # dedupe, sort by expression complexity then residual
    seen, out = set(), []
    for e, r in sorted(results, key=lambda t: (len(t[0]), t[1])):
        if e not in seen:
            seen.add(e)
            out.append((e, r))
    return out[:10]


def selftest():
    """Exercise two advertised linear relations and one control relation.

    The Dickman/Ein crossover is nonlinear in the present basis and is
    deliberately not claimed as a PSLQ self-test.
    """
    g = mp.euler
    g1 = mp.mpf('-0.0728158454836767248605863758749')
    tests = [
        ((g * g + 2 * g1) / 2, "(gamma^2 + 2 gamma_1)/2  [K2 II]"),
        (2 + g - mp.log(4 * mp.pi), "2 + gamma - log(4 pi)  [SCREW mass]"),
        (g / 2, "gamma/2 [control]"),
    ]
    for x, label in tests:
        res = recognize(x, tol=1e-8)
        print(f"x = {mp.nstr(x, 24)}  ({label})")
        for e, r in res[:3]:
            print(f"   -> {e}   (residual {r:.1e})")
        if not res:
            print("   -> no relation found")
        print()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] != "--selftest":
        tol = 1e-9
        if "--tol" in sys.argv:
            tol = float(sys.argv[sys.argv.index("--tol") + 1])
        print("CANDIDATES ONLY — independent precision, ablation, and proof required")
        for e, r in recognize(sys.argv[1], tol=tol):
            print(f"{e}   (residual {r:.2e})")
    else:
        selftest()
