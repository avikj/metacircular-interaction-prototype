#!/usr/bin/env python3
"""exp54 (fleet-L5): claim-anchored LP for the q-aspect transplant threshold C*.

Declared statement S2 (notes/L5_TRANSPLANT.md section 4): in the
doubly-positive Montgomery functional with band lambda* > 1 and an
unconditional plateau UPPER bound C on (1, lambda*],

  J_C(fhat) = fhat(0) + int_{|x|<=1} |x| fhat(x) dx + C int_{1<|x|<=L*} fhat dx,
  minimized over fhat >= 0 (frame double positivity, L3_SDP Lemma L3.2),
  supp fhat in [-L*, L*], f >= 0 pointwise, f(0) = int fhat = 1,

there is a finite threshold C*(L*) such that the optimum is strictly below
the Montgomery-Taylor value 1/c1* = 1.3274992... iff C < C*, and equals it
for C >= C* (outside mass priced out).  S2 is confirmed if the measured
value(C) curve crosses 1/c1* at some finite C* > 1, killed if value(C)
never drops below MT for any C >= 1 (then the q-aspect door pays nothing
even at the conjectural plateau C = 1).

Controls (known-answer / known-false):
  K1: band = 1 (any C): must reproduce MT 1.3274992 (known, CCLM17).
  K2: C = 1e6 at band 1.5: must equal K1 (outside mass priced out; if it
      beat MT the LP would be buying mass at infinite price -> bug).
  K3 (proves-too-much): drop the physical positivity f >= 0 and set C = 1,
      band 1.5: the value must collapse below 1 (which would "certify"
      N* < N, false since N* >= N) -- confirming f >= 0 is load-bearing,
      exactly as in exp49 Q5/Q6.
"""
import numpy as np
from scipy.optimize import linprog

MT = 1.3274992963  # 1/c1*, Montgomery-Taylor

def solve(band, C, phys_pos=True, nx=300, nt=6000, tmax=120.0):
    xs = np.linspace(0.0, band, nx)      # fhat grid (even function, x>=0)
    dx = xs[1] - xs[0]
    # weights for integrals: trapezoid, doubling for x>0
    w_int = np.full(nx, 2.0 * dx); w_int[0] = dx
    w_int[-1] = dx  # trapezoid ends
    v = np.where(xs <= 1.0, xs, C)       # objective density |x| inside, C outside
    # objective: fhat(0) + sum v(x_j) fhat_j w_int_j   (fhat(0) = u_0 point value)
    c = v * w_int
    c[0] += 1.0
    # normalization f(0) = int fhat = 1
    A_eq = w_int.reshape(1, -1); b_eq = np.array([1.0])
    A_ub = None; b_ub = None
    if phys_pos:
        ts = np.linspace(0.0, tmax, nt)
        # f(t) = sum_j w_int_j fhat_j cos(2 pi x_j t) >= 0
        M = -np.cos(2 * np.pi * np.outer(ts, xs)) * w_int
        A_ub, b_ub = M, np.zeros(nt)
    res = linprog(c, A_ub=A_ub, b_ub=b_ub, A_eq=A_eq, b_eq=b_eq,
                  bounds=[(0, None)] * nx, method="highs")
    assert res.status == 0, res.message
    return res.fun, res.x, xs, w_int

def main():
    out = []
    v1, *_ = solve(1.0, 0.0)
    out.append(f"K1 band=1: value={v1:.7f} vs MT={MT:.7f} (diff {v1-MT:+.2e})")
    v2, *_ = solve(1.5, 1e6)
    out.append(f"K2 band=1.5 C=1e6: value={v2:.7f} (diff vs K1 {v2-v1:+.2e})")
    # K3 proves-too-much: no physical positivity
    v3, *_ = solve(1.5, 1.0, phys_pos=False)
    out.append(f"K3 control (drop f>=0, C=1): value={v3:.7f} "
               f"({'collapses below 1 as required' if v3 < 1 else 'CONTROL FAILED'})")
    # S2 measurement: value(C) at band 1.5 and band 2.0
    for band in (1.5, 2.0):
        rows = []
        for C in (1.0, 1.1, 1.2, 1.3, 1.5, 2.0, 3.0, 3.4, 4.0, 8.0):
            val, x, xs, w = solve(band, C)
            outside = float(np.sum((xs > 1.0) * w * x))
            rows.append((C, val, outside))
        out.append(f"S2 band={band}:")
        for C, val, om in rows:
            mark = "GAIN" if val < MT - 1e-6 else "no gain"
            out.append(f"  C={C:6.2f}  value={val:.7f}  outside-mass={om:.5f}  {mark}")
        # bisect C*
        lo, hi = 1.0, 8.0
        flo = solve(band, lo)[0]
        if flo < MT - 1e-6:
            for _ in range(30):
                mid = 0.5 * (lo + hi)
                if solve(band, mid)[0] < MT - 1e-6:
                    lo = mid
                else:
                    hi = mid
            out.append(f"  C*({band}) = {0.5*(lo+hi):.4f} (bisection, grid-level)")
        else:
            out.append(f"  no gain even at C=1: S2 KILLED at band {band}")
    print("\n".join(out))

if __name__ == "__main__":
    main()
