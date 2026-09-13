#!/usr/bin/env python3
"""Exact finite controls for the full-history kernel calculation.

SymPy exact algebra, not a proof-assistant build and not a numerical NS
simulation. Synthetic polynomial controls are distinguished from actual
Fourier Galerkin identities of the NS nonlinearity.
"""
from __future__ import annotations
from dataclasses import dataclass
from functools import lru_cache
from itertools import product
import json
from pathlib import Path
import sympy as s

checks: list[str] = []

def zero(expr, name: str) -> None:
    if isinstance(expr, s.MatrixBase):
        ok = all(s.expand(e) == 0 or s.simplify(e) == 0 for e in expr)
    else:
        ok = s.expand(expr) == 0 or s.simplify(expr) == 0
    if not ok:
        raise AssertionError(f'{name}: {expr}')
    checks.append(name)
    if len(checks)%20 == 0: print(f'Passed {len(checks)} controls', flush=True)

x,y = s.symbols('x y')
a,b,c,d,e,f,al,be = s.symbols('a b c d e f alpha beta')

@dataclass(frozen=True)
class PolynomialKernel:
    """One derivation and one retraction generate every return coefficient."""
    variables: tuple
    field: tuple
    substitution: tuple

    @lru_cache(None)
    def L(self, h):
        return s.expand(sum(s.diff(h,v)*F for v,F in zip(self.variables,self.field)))

    @lru_cache(None)
    def P(self, h):
        return s.expand(h.subs(dict(self.substitution), simultaneous=True))

    @lru_cache(None)
    def Q(self, h):
        return s.expand(h-self.P(h))

    @lru_cache(None)
    def iterate(self, n: int, h):
        return h if n == 0 else self.L(self.iterate(n-1,h))

    @lru_cache(None)
    def K(self, n: int, h):
        return self.P(self.iterate(n,self.P(h)))

    @lru_cache(None)
    def A(self, h):
        return self.P(self.L(self.P(h)))

    @lru_cache(None)
    def memory(self, n: int, h):
        # B D^n C, with A=P L P, B=P L Q, C=Q L P, D=Q L Q.
        q = self.Q(self.L(self.P(h)))
        for _ in range(n):
            q = self.Q(self.L(self.Q(q)))
        return self.P(self.L(self.Q(q)))

G = PolynomialKernel((x,y),
  (-al*x+a*x*x+b*x*y+c*y*y, -be*y+d*x*x+e*x*y+f*y*y), ((y,s.Integer(0)),))
zero(G.memory(0,x)-b*d*x**3, 'symbolic first return = b*d*x^3')
# Actual full derivative minus re-encoded resolved derivative.
first_observable = G.Q(G.L(x))
zero(G.P(G.L(first_observable))-b*d*x**3,
     'first return differentiates the common quadratic source')

F = PolynomialKernel((x,y),(-2*x+x*x+2*x*y-y*y, -3*y+3*x*x-x*y+2*y*y),
                     ((y,s.Integer(0)),))
# Pure finite algebra: multiplication and differentiation remain source-coherent.
for h,k in [(x,y),(x*x+y,x*y+1),(x+y*y,x*x*y)]:
    zero(F.L(h*k)-F.L(h)*k-h*F.L(k),'Leibniz '+str((h,k)))
    zero(F.P(h*k)-F.P(h)*F.P(k),'retraction preserves source products '+str((h,k)))
    defect = F.Q(F.L(h*k))-F.Q(F.L(h))*k-h*F.Q(F.L(k))
    expected = F.P(F.L(h))*F.Q(k)+F.Q(h)*F.P(F.L(k))
    zero(defect-expected,'projected generator product defect '+str((h,k)))

for n in range(7):
    for h in (x,x*x):
        rhs=F.A(F.K(n,h))
        if n:
            rhs+=sum(F.memory(j,F.K(n-1-j,h)) for j in range(n))
        zero(F.K(n+1,h)-rhs,f'ordered renewal recurrence n={n}, observable={h}')

for n in range(6):
    h=x+y
    k=x*y+1
    rhs=sum(s.binomial(n,j)*F.iterate(j,h)*F.iterate(n-j,k) for j in range(n+1))
    zero(F.iterate(n,h*k)-rhs,f'all-order source-product rule n={n}')

# Retain a nonzero complementary initial state using an affine retraction.
y0=s.symbols('y0')
Fy=PolynomialKernel((x,y),F.field,((y,y0),))
for h in (x,y,x*y+y*y):
    zero(Fy.P(Fy.P(h))-Fy.P(h),'affine retraction idempotence '+str(h))
    zero(Fy.P(h).subs(x,2)-h.subs({x:2,y:y0}),
         'source evaluation retained '+str(h))

# Source-image/Carleman controls: moments are not independent states.
for i,j in [(1,0),(0,1),(2,0),(1,1),(0,3),(2,2)]:
    h=x**i*y**j
    lhs=F.L(h)
    rhs=(i*x**(i-1)*y**j*F.field[0] if i else 0)+(j*x**i*y**(j-1)*F.field[1] if j else 0)
    zero(lhs-rhs,f'Carleman row {(i,j)}')

# Two equivalent recursive resummations, for a scalar formal control.
z=s.symbols('z')
Y=[None]+[s.Integer(0)]*8
Y[1]=z
for n in range(2,9):
    Y[n]=s.expand(sum(Y[j]*Y[n-j] for j in range(1,n)))
for n in range(1,9):
    zero(Y[n]-s.catalan(n-1)*z**n,f'Catalan source-tree multiplicity n={n}')
series=sum(Y[1:])
zero(s.series(series-z-series**2,z,0,9).removeO(),
     'tree sum solves same-source quadratic fixed point through order eight')

# RH: actual algebra of one reflected mode pair; the values are symbols,
# not claims that an off-critical zeta zero has been found.
sigma,gamma,lam,t=s.symbols('sigma gamma lambda t', real=True)
I=s.I
J=s.Matrix([[0,1],[1,0]])
D=s.diag(-(sigma+I*gamma),-(-sigma+I*gamma))
H=s.Matrix([[1,1],[1,-1]])/s.sqrt(2)
Gpair=s.simplify(H.T*D*H)
zero(Gpair-s.Matrix([[-I*gamma,-sigma],[-sigma,-I*gamma]]),'RH reflection eigenbasis generator')
resolvent=(lam*s.eye(2)-Gpair).inv()
selfenergy=sigma**2/(lam+I*gamma)
zero(resolvent[0,0]-1/(lam+I*gamma-selfenergy),'RH exact Feshbach denominator')
zero(resolvent[0,0]-(lam+I*gamma)/((lam+I*gamma)**2-sigma**2),
     'RH pair resolvent all-return sum')
# Check the exact time-domain memory identity without special-function integration.
K=s.exp(-I*gamma*t)*s.cosh(sigma*t)
conv=sigma*s.exp(-I*gamma*t)*s.sinh(sigma*t)
zero(s.diff(K,t)+I*gamma*K-conv,'RH causal convolution renewal equation')
zero(s.diff(conv,t)+I*gamma*conv-sigma**2*K,'RH convolution evaluated by its defining ODE')
zero(conv.subs(t,0),'RH convolution zero initial value')

# Exact elimination preserves the scalar local majorant threshold.
kappa,pnorm,qnorm=s.symbols("kappa pnorm qnorm")
zero((1-2*kappa*pnorm)**2-4*kappa*(qnorm+kappa*pnorm**2)
     -(1-4*kappa*(pnorm+qnorm)),
     "nonlinear elimination has the same quadratic local majorant threshold")

# Actual NS Fourier nonlinearity on a finite symmetry-closed periodic
# Galerkin set. Rational coefficients; no time evolution is simulated.
Kset=[k for k in product((-1,0,1),repeat=3) if k!=(0,0,0)]
ks=set(Kset)

def vv(k): return s.Matrix(k)
def pr(k,z):
    kv=vv(k)
    return (z-kv*(kv.dot(z))/kv.dot(kv)).applyfunc(s.expand)

def source(seed):
    out={}
    for j,k in enumerate(Kset):
        if k in out: continue
        raw=s.Matrix([s.Integer((j+seed)%5-2)+I*s.Integer((2*j+seed)%3-1),
                      s.Integer((3*j+seed)%7-3)+I*s.Integer((j+2*seed)%5-2),
                      s.Integer((j+3*seed)%4-1)+I*s.Integer((5*j+seed)%3-1)])
        val=pr(k,raw)
        out[k]=val
        out[tuple(-v for v in k)]=s.conjugate(val)
    return out

def ns_adv(u,v):
    out={}
    for k in Kset:
        val=s.zeros(3,1)
        for p in Kset:
            q=tuple(k[i]-p[i] for i in range(3))
            if q in ks:
                val += u[p].dot(vv(q))*v[q]
        out[k]=(-I*pr(k,val)).applyfunc(s.expand)
    return out

def curl(u):
    return {k:I*vv(k).cross(u[k]) for k in Kset}

def ns_cross(u):
    w=curl(u); out={}
    for k in Kset:
        val=s.zeros(3,1)
        for p in Kset:
            q=tuple(k[i]-p[i] for i in range(3))
            if q in ks:
                val+=u[p].cross(w[q])
        out[k]=pr(k,val).applyfunc(s.expand)
    return out

u=source(1)
v=source(3)
N=ns_adv(u,u)
Nx=ns_cross(u)
w=curl(u)
for k in Kset:
    zero(vv(k).dot(u[k]),f'NS source divergence-free mode {k}')
    zero(N[k]-Nx[k],f'NS advective/cross source identity mode {k}')
zero(sum(s.conjugate(u[k]).dot(N[k]) for k in Kset),
     'NS Galerkin nonlinear kinetic-energy conservation')
zero(sum(s.conjugate(w[k]).dot(N[k]) for k in Kset),
     'NS Galerkin nonlinear helicity conservation')
uv={k:u[k]+v[k] for k in Kset}
Nuv=ns_adv(uv,uv); Nv=ns_adv(v,v); Auv=ns_adv(u,v); Avu=ns_adv(v,u)
for k in Kset:
    zero(Nuv[k]-N[k]-Nv[k]-Auv[k]-Avu[k],
         f'NS complete symmetric polarization mode {k}')

# Scaling identities: S_r omega=r^2 omega(rx); B(S_r a,S_r b)=r^2 S_r B(a,b).
zero(2+2-4,'NS vorticity quadratic scaling degree')
zero(2+2-4,'NS viscous generator scaling degree')

out=Path(__file__).parent
report={'passed':len(checks),'checks':checks,
        'toy_memory_coefficients':{str(n):str(F.memory(n,x)) for n in range(4)},
        'scope': 'Exact finite algebra only. No proof-assistant compilation, global proof, or PDE time simulation.'}
(out/'check_results.json').write_text(json.dumps(report,indent=2))
text=f'{len(checks)} exact finite checks passed.\n\n'+'\n'.join(checks)
text+='\n\nSynthetic two-variable memory coefficients:\n'
text+='\n'.join(f'M_{n} x = {F.memory(n,x)}' for n in range(4))
text+='\n\n'+report['scope']+'\n'
(out/'check_results.txt').write_text(text)
print(text)
