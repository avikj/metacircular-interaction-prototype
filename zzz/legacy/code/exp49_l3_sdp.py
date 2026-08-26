"""exp49: L3 mechanism attribution — where does the CGdL 0.6792 gain live?

Claim-anchored per PROTOCOL section 4. Declared candidate statement S1
(notes/L3_SDP.md, lever L3 of notes/BEYOND.md):

  S1. The Chirre--Goncalves--de Laat improvement over Montgomery--Taylor
      (J* : 1.3275 -> 1.3208, hence simple-zero proportion 0.6725 -> 0.6792
      under RH) is produced exactly by the sign freedom "fhat < 0 somewhere
      on |alpha| > 1"; on the doubly-positive cone {f >= 0, fhat >= 0,
      supp fhat in [-1,1]} — which is where every kernel realizable by the
      two-trace Gabor-compression inertia frame lives (Lemma L3.2 of
      notes/L3_SDP.md) — the optimum equals the band-limited
      Montgomery--Taylor value 1/c1* = 1.3274992....

Montgomery's functional (convention of CGdL arXiv:1810.08843, intro):
  N*(T) <= (1/f(0)) ( fhat(0) + int_{-1}^{1} fhat(x)|x| dx + o(1) ) N(T)
valid (under RH) for f >= 0; band-limited class: supp fhat in [-1,1];
CGdL relaxed class: fhat(x) <= 0 for |x| >= 1 (uses F(x,T) >= 0, which is
the |.|^2 positivity of Montgomery's form factor).
Objective (normalized f(0) = 1):  J(f) = fhat(0) + 2 int_0^1 fhat(x) x dx.

Computed quantities and confirm/kill criteria:
  Q1  J(f_MT) for the Montgomery--Taylor extremal window v(s)=cos(sqrt2 s)
      (f = (vhat)^2, fhat = autocorr(v)): must equal 1/c1* to 1e-6, where
      c1* = sqrt2 tan(1/sqrt2) / (1 + tan(1/sqrt2)/sqrt2)  [manuscript
      Thm D; KAPPA.md sec 3], AND min fhat >= 0 (MT extremal is doubly
      positive, i.e. lies in the realizable cone).  Kill: J mismatch, or
      fhat_MT < 0 somewhere.
  Q2  discretized LP optimum, band-limited class P_band.   Expect ~1.3275.
  Q3  discretized LP optimum, doubly-positive class P_DP = P_band + fhat>=0.
      Confirm: Q3 - Q2 < 2e-3 (double positivity costless inside the band).
      Kill: Q3 - Q2 large (would mean the inertia frame cannot even reach
      MT — contradicting the manuscript's 0.6725).
  Q4  discretized LP optimum, CGdL class P_CGdL (supp fhat in [-2,2],
      fhat <= 0 on |x| > 1).  Confirm: Q4 < Q2 - 2e-3 and the optimizer has
      strictly negative fhat-mass on (1,2] (the gain needs the sign).
      Rigorous value for comparison: 1.3208 (CGdL Thm 1, SDP certificate).
      Kill: Q4 >= Q2 (no gain from the sign freedom at this discretization).
  Q5  CONTROL (statement known false: "f >= 0 is not load-bearing"):
      P_band without f >= 0.  Expect unbounded below / huge negative.
  Q6  CONTROL (proves-too-much; statement known false: "only the support
      width matters, not the sign"): P_wide+ = {f >= 0, supp fhat in
      [-2,2], fhat >= 0 on |x| > 1}.  The tent fhat(a) = (1/2)(1-|a|/2)
      gives J = 5/6 < 1, and N* <= (5/6)N contradicts N* >= N (every zero
      has multiplicity >= 1).  Expect LP ~ 5/6: the wrong-sign relaxation
      proves too much, so the sign constraint is what carries validity.
  Q7  identity check for Lemma L3.2 (double positivity of realizable
      kernels): for random signed coefficient vectors c and random signed
      windows phi_i on [-1/2,1/2], the FT of the tr(A^2)-kernel
      g = sum_ij c_i c_j ((phi_i phi_j)^)^2 equals
      ghat(u) = int z(t,u)^2 dt >= 0 with z(t,u) = sum_i c_i phi_i(t)
      phi_i(t-u).  Checked by two independent computations (grid FT vs
      the z-integral), agreement < 6e-3 (quadrature-limited) and
      min ghat >= -1e-12.

Discretization: piecewise-linear even fhat on hats of width da; positivity
of f sampled on a dense x-grid (values are indicative, not certified; the
rigorous anchors are 4/3 (Fejer, exact), 1/c1* (closed form, Q1) and
1.3208 (CGdL's own SDP certificate)).
"""
import numpy as np
from scipy.integrate import quad, dblquad
from scipy.optimize import linprog

OUT = []
def log(s):
    print(s); OUT.append(s)

# ---------------------------------------------------------------- Q1
s2 = np.sqrt(2.0)
c1s = s2*np.tan(1/s2) / (1 + np.tan(1/s2)/s2)
target = 1.0/c1s
v = lambda s: np.cos(s2*s)          # MT window on [-1/2,1/2], v > 0 there
Iv,_  = quad(v, -0.5, 0.5)
Iv2,_ = quad(lambda s: v(s)**2, -0.5, 0.5)
Idd,_ = dblquad(lambda t,srr: abs(srr-t)*v(srr)*v(t), -0.5,0.5, -0.5,0.5,
                epsabs=1e-12, epsrel=1e-12)
J_MT = (Iv2 + Idd)/Iv**2
# fhat_MT = autocorrelation of v (v > 0 on its support => autocorr >= 0)
al = np.linspace(0,1,401)
acorr = np.array([quad(lambda t: v(t)*v(t-a), -0.5+a, 0.5)[0] if a<1 else 0.0
                  for a in al])
log(f"Q1  J(f_MT) = {J_MT:.10f}   target 1/c1* = {target:.10f}   "
    f"diff = {abs(J_MT-target):.2e}")
log(f"Q1  min fhat_MT on [0,1] = {acorr.min():.3e}  (>= 0: doubly positive)")
assert abs(J_MT-target) < 1e-6 and acorr.min() >= 0

# ---------------------------------------------------------------- LP machinery
def lp(amax, n, sign_lo=None, sign_hi=None, drop_f_pos=False,
       Xmax=160.0, m=12800, box=20.0):
    """min J over piecewise-linear even fhat with hat nodes a_i = i*da,
    i = 0..n-1, da = amax/n (support inside [-amax, amax]).
    sign_lo/sign_hi: node sign constraint threshold (fhat>=0 / fhat<=0 for
    a_i past it).  box: |u_i| <= box regularization — kills the edge-ray
    degeneracy (continuum rays f = 1-cos(2 pi a0 x), J-slope -> 0 as
    a0 -> 1, which grid positivity tips unbounded); the true optimizers
    have |fhat| = O(1), so a generous box does not bind at the optimum
    (asserted post hoc)."""
    da = amax/n
    a = da*np.arange(n)
    x = np.linspace(0, Xmax, m)
    # FT of unit hat at center a_i (even-symmetrized):
    #   hhat_i(x) = da*sinc^2(da x)*cos(2 pi a_i x), doubled for i>0
    snc = np.sinc(da*x)**2                       # np.sinc(t)=sin(pi t)/(pi t)
    B = da*snc[None,:]*np.cos(2*np.pi*np.outer(a,x))
    B[1:] *= 2.0
    f0 = B[:,0].copy()                           # f(0) coefficients
    # objective: J = u_0 + 2 int_0^1 fhat(a) a da  (hat moments, exact)
    cobj = np.zeros(n); cobj[0] = 1.0 + 2*(da**2/3)/1  # hat at 0: 2*int_0^da (1-a/da) a da = da^2/3, doubled for symmetry? no:
    # careful: int_0^1 fhat(a) a da uses only a>=0 branch of the even fn.
    # node 0 hat on [0,da]: contributes u0 * int_0^da (1-a/da) a da = u0*da^2/6
    cobj[0] = 1.0 + 2*(da*da/6)
    for i in range(1,n):
        # interior hat centered a_i (width da each side), inside [0, amax]:
        # int hat_i(a) a da = da * a_i   (exact),  clipped at 1 for the
        # objective window [0,1]: nodes with a_i <= 1-da fully inside;
        # straddling nodes: integrate hat*min(a,?)... use exact overlap:
        lo, hi = a[i]-da, a[i]+da
        if lo >= 1.0: contrib = 0.0
        elif hi <= 1.0: contrib = da*a[i]
        else:
            # integrate (1-|t-a_i|/da) * t over [max(lo,0), 1]
            from scipy.integrate import quad as q2
            contrib = q2(lambda t: max(0.0,1-abs(t-a[i])/da)*t, lo, 1.0)[0]
        cobj[i] = 2*contrib
    A_ub, b_ub = [], []
    if not drop_f_pos:
        A_ub.append(-B.T); b_ub.append(np.zeros(m))     # f(x_j) >= 0
    bounds = [(-box,box)]*n
    if sign_hi is not None:  # fhat <= 0 for a_i > thr
        thr = sign_hi
        for i in range(n):
            if a[i] > thr + 1e-12: bounds[i] = (-box, 0.0)
    if sign_lo is not None:  # fhat >= 0 for a_i > thr / everywhere (P_DP)
        thr = sign_lo
        for i in range(n):
            if a[i] > thr - 1e-12:
                bounds[i] = (0.0, bounds[i][1])
    A_eq = f0[None,:]; b_eq = np.array([1.0])
    A_ub = np.vstack(A_ub) if A_ub else None
    b_ub = np.concatenate(b_ub) if b_ub is not None and A_ub is not None else None
    r = linprog(cobj, A_ub=A_ub, b_ub=b_ub, A_eq=A_eq, b_eq=b_eq,
                bounds=bounds, method="highs")
    return r, a

def binds(r, box=20.0):
    return np.max(np.abs(r.x)) > 0.98*box

# Q2: band-limited (Montgomery/MT class), amax=1
r2,_ = lp(1.0, 64)
log(f"Q2  LP band-limited [supp fhat in [-1,1], f>=0]        : "
    f"{r2.fun:.6f}   (MT rigorous 1.3274992; box binds: {binds(r2)})")
# Q3: + fhat >= 0 (doubly-positive = realizable cone closure)
r3,_ = lp(1.0, 64, sign_lo=0.0)
log(f"Q3  LP doubly-positive [ + fhat >= 0 ]                 : "
    f"{r3.fun:.6f}   (Q3-Q2 = {r3.fun-r2.fun:+.2e}; box binds: {binds(r3)})")
# Q4: CGdL class, amax=2, fhat <= 0 past 1
r4,a4 = lp(2.0, 128, sign_hi=1.0)
neg_mass = r4.x[(a4>1.0)].sum()
log(f"Q4  LP CGdL [supp in [-2,2], fhat<=0 on |x|>1, f>=0]   : "
    f"{r4.fun:.6f}   (CGdL rigorous 1.3208; box binds: {binds(r4)})")
log(f"Q4  outside fhat node values: min = {r4.x[a4>1.0].min():.4f}, "
    f"sum = {neg_mass:.4f}  (strictly negative => gain needs the sign)")
# Q5 control: drop f >= 0 (expected: races to the box => hugely negative,
# unbounded in the limit box -> inf)
r5,_ = lp(1.0, 64, drop_f_pos=True)
v5 = "unbounded" if r5.status == 3 else f"{r5.fun:.3f} (box-bound ray)"
log(f"Q5  CONTROL drop f>=0: status={r5.status}, value {v5} "
    f"— f>=0 is load-bearing")
# Q6 control: wrong sign outside (proves too much)
r6,_ = lp(2.0, 128, sign_lo=1.0)
log(f"Q6  CONTROL wrong-sign relaxation [fhat>=0 on |x|>1]   : "
    f"{r6.fun:.6f}   (tent gives 5/6 = 0.8333; any value < 1 falsifies "
    f"N* >= N — proves too much, so the <=0 sign carries validity)")

ok = (abs(r3.fun-r2.fun) < 2e-3 and r4.fun < r2.fun - 2e-3
      and r4.x[a4>1.0].min() < -1e-3
      and (r5.status == 3 or r5.fun < 0) and r6.fun < 1.0
      and not (binds(r2) or binds(r3) or binds(r4)))

# ---------------------------------------------------------------- Q7
rng = np.random.default_rng(49)
T = 2048; L = 1.0
t = np.linspace(-2, 2, T, endpoint=False); dt = t[1]-t[0]
fails = 0
for trial in range(5):
    k = 3
    phis = []
    for i in range(k):
        c0,c1,c2 = rng.normal(size=3)
        supp = (np.abs(t) <= L/2)
        phis.append(np.where(supp, (c0 + c1*np.sin(3*t) + c2*t**2)*(0.25 - t**2), 0.0))
    c = rng.normal(size=k)          # SIGNED coefficients
    # ghat via z-integral
    us = np.linspace(-1.5, 1.5, 121)
    ghat_z = []
    for u in us:
        sh = int(round(u/dt))
        z = np.zeros(T)
        for ci,ph in zip(c,phis):
            z += ci*ph*np.roll(ph, sh)      # phi_i(t) phi_i(t-u), zero-padded ok
        ghat_z.append((z**2).sum()*dt)
    ghat_z = np.array(ghat_z)
    # ghat via FT of g:  g(x) = sum_ij c_i c_j ((phi_i phi_j)^)(x)^2
    xs = np.linspace(-120, 120, 12001); dx = xs[1]-xs[0]
    g = np.zeros_like(xs)
    for i in range(k):
        for j in range(k):
            pij = phis[i]*phis[j]
            ftij = (pij[None,:]*np.exp(1j*np.outer(xs,t))).sum(axis=1)*dt
            g += c[i]*c[j]*np.abs(ftij)**2   # (real FT)^2; phis real even? not even — use |.|^2 of conj-sym FT
    ghat_ft = np.array([(g*np.cos(u*xs)).sum()*dx/(2*np.pi) for u in us])
    err = np.max(np.abs(ghat_ft-ghat_z))/max(1e-12, np.max(np.abs(ghat_z)))
    if err > 6e-3 or ghat_z.min() < -1e-10: fails += 1
    log(f"Q7  trial {trial}: rel agreement FT-vs-z = {err:.2e}, "
        f"min ghat = {ghat_z.min():.2e} (>=0)")
ok = ok and fails == 0

log(f"\nVERDICT: S1 {'CONFIRMED' if ok else 'KILLED'} at this discretization "
    f"(rigorous anchors: 4/3 Fejer exact; 1/c1* = {target:.7f} closed form; "
    f"1.3208 CGdL SDP certificate).")

with open("../data/exp49_out.txt","w") as fh:
    fh.write("\n".join(OUT)+"\n")
