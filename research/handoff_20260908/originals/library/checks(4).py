"""Exact algebra controls for the source-retaining midpoint return formula.

No PDE simulation, zeta verification, or proof-assistant build is performed.
The Fourier calculation retains every generated mode (no Galerkin truncation).
"""
from __future__ import annotations
import sympy as s

COUNT = 0

def check(name: str, expression) -> None:
    global COUNT
    entries = list(expression) if isinstance(expression, s.MatrixBase) else [expression]
    assert all(s.simplify(e) == 0 for e in entries), name
    COUNT += 1
    print(f'EXACT {COUNT:02d}: {name}')

# General quadratic polynomial, including nonsymmetric polarization.
x = s.Matrix(s.symbols('x0:3'))
y = s.Matrix(s.symbols('y0:3'))
u = s.Matrix(s.symbols('u0:3'))
qcoef = s.symbols('q0:18')
lcoef = s.symbols('l0:9')
L = s.Matrix(3,3,lcoef)
monomials = [u[0]**2,u[1]**2,u[2]**2,u[0]*u[1],u[0]*u[2],u[1]*u[2]]
N = s.Matrix([sum(qcoef[6*i+j]*monomials[j] for j in range(6)) for i in range(3)])
F = L*u+N
sub = lambda v: dict(zip(u,v))
check('arbitrary quadratic midpoint identity', F.subs(sub(x+y), simultaneous=True)-F.subs(sub(x), simultaneous=True)-F.jacobian(u).subs(sub(x+y/2), simultaneous=True)*y)

# A generic energy-preserving quadratic vector field.
M = s.Matrix(3,3,s.symbols('m0:9'))
N = u.cross(M*u)
P = s.diag(1,0,0)
Q = s.eye(3)-P
a,b = P*u,Q*u
mid = a+b/2
C = N.jacobian(u).subs(sub(mid), simultaneous=True)
return_term = P*C*b
hidden_rhs = Q*N
check('generic cubic kinetic conservation', (u.T*N)[0])
check('source-dependent return is the exact observed difference', return_term-P*(N-N.subs(sub(a),simultaneous=True)))
check('all-order signed work exchange', (a.T*return_term)[0]+(b.T*hidden_rhs)[0])
check('midpoint is distinct from a frozen visible-source tangent', (C-N.jacobian(u).subs(sub(a),simultaneous=True))*b-N.subs(sub(b),simultaneous=True))

# Moving orthogonal observer: full frame-change work cancels.
w1,w2,w3=s.symbols('w1 w2 w3', real=True)
Om=s.Matrix([[0,w1,w2],[-w1,0,w3],[-w2,-w3,0]])
Pprime=Om*P-P*Om
check('projection derivative is symmetric', Pprime-Pprime.T)
check('projection derivative has no visible-visible block', P*Pprime*P)
check('projection derivative has no hidden-hidden block', Q*Pprime*Q)
check('observer-motion work is exchanged, not destroyed', (a.T*Pprime*b)[0]-(b.T*Pprime*a)[0])

# Energy/vorticity thermostat: all linear gauge terms are skew in L2.
mu, mudot, nu=s.symbols('mu mudot nu', positive=True)
length=mu**(-s.Rational(2,5)); amplitude=mu**(-s.Rational(3,5)); clock=mu
check('thermostat preserves kinetic norm', amplitude**2*length**(-3)-1)
# Actual forward spatial argument is c+length*y, so curl_y V=amplitude*length*curl_x u.
check('actual forward vorticity scaling', amplitude*length-mu**(-1))
check('thermostat retains unit nonlinear coefficient', 1/(clock*amplitude*length)-1)
check('thermostat effective viscosity', nu/(clock*length**2)-nu*mu**(-s.Rational(1,5)))
beta=s.diff(length,mu)*mudot/(length*clock)
scalar=s.diff(amplitude,mu)*mudot/(amplitude*clock)
check('dilation generator has exactly the L2-skew scalar term', scalar-s.Rational(3,2)*beta)
check('dilation rate', beta+s.Rational(2,5)*mudot/mu**2)
check('peak stretching time integral is invariant', (mu**(-1))*clock-1)

# An amplifying hidden propagator can still obey the exact signed storage law.
z,t,visc=s.symbols('z t visc', real=True)
source=s.Matrix([-u[0]*u[1]-u[1]**2,u[0]**2+u[0]*u[1]])
check('amplifying two-coordinate control conserves energy', u[0]*source[0]+u[1]*source[1])
# prescribed visible x=1, y'=1+(1-visc)y, returned visible force=-y-y^2.
check('amplifying hidden control has nonpositive supplied work balance', (-z-z**2)+z*(1+(1-visc)*z)+visc*z**2)

# RH shift / Abel inverse identities, independent of zeta.
rho,lam,c=s.symbols('rho lam c')
Br=(1-rho)*lam/(1-rho*lam)
for m in range(1,7):
    check(f'Abel operator normal form, order {m}', ((1-lam)/(1-rho*lam))**m-(1-Br)**m)
    check(f'negative-binomial generating kernel, order {m}', s.diff((1-rho*lam)**(-m),rho)-m*lam*(1-rho*lam)**(-m-1))
    check(f'bounded inverse coefficient sum, order {m}', c**(-m)*(1-c**(-1))**(-m)-(c-1)**(-m))
# Explicit failure of ordinary higher-tail convergence from x_n -> 0 alone.
n=s.symbols('n',integer=True,nonnegative=True)
amplitude2=1+2*(n+1)/(n+2)+(n+1)/(n+3)
check('second weighted-difference counterexample has nonvanishing term magnitude', s.limit(amplitude2,n,s.oo)-4)

# Untruncated Fourier NS example (periodic algebra control, not a domain substitution).
VEC0=s.zeros(3,1)
Mode=tuple[int,int,int]
Field=dict[Mode,s.Matrix]

def clean(f: Field) -> Field:
    out={}
    for k,v in f.items():
        v=v.applyfunc(s.simplify)
        if any(x!=0 for x in v): out[k]=v
    return out

def add(*fields: Field) -> Field:
    out={}
    for f in fields:
        for k,v in f.items(): out[k]=out.get(k,VEC0)+v
    return clean(out)

def scale(c, f: Field) -> Field: return clean({k:c*v for k,v in f.items()})

def wave(k: Mode, v, kind='cos') -> Field:
    vv=s.Matrix(v); minus=tuple(-j for j in k)
    if kind=='cos': return {k:vv/2,minus:vv/2}
    return {k:vv/(2*s.I),minus:-vv/(2*s.I)}

def leray(k: Mode, v):
    kk=s.Matrix(k); q=(kk.T*kk)[0]
    return v if q==0 else v-kk*(kk.T*v)[0]/q

def conv(f: Field,g: Field) -> Field:
    out={}
    for p,v in f.items():
        for q,w in g.items():
            k=tuple(pi+qi for pi,qi in zip(p,q))
            val=-s.I*leray(k,(v.T*s.Matrix(q))[0]*w)
            out[k]=out.get(k,VEC0)+val
    return clean(out)

def nonlinear(f): return conv(f,f)
def derivative(m,b): return add(conv(m,b),conv(b,m))
def project(f, complement=False):
    return {k:v for k,v in f.items() if ((sum(t*t for t in k)<=1) != complement)}
def inner(f,g):
    return s.simplify(sum((v.T*s.conjugate(g.get(k,VEC0)))[0] for k,v in f.items()))
def fieldcheck(name,f):
    check(name,s.Matrix.vstack(*list(f.values())) if f else s.zeros(1,1))

fa=add(wave((1,0,0),(0,1,0)),wave((0,1,0),(0,0,1)),wave((0,0,1),(1,0,0)))
fb=add(wave((1,1,0),(1,-1,1),'sin'),wave((1,0,1),(1,2,-1)))
fu=add(fa,fb); fm=add(fa,scale(s.Rational(1,2),fb))
for name,ff in [('visible',fa),('hidden',fb)]:
    check(f'Fourier {name} field is divergence free', s.Matrix([(s.Matrix(k).T*v)[0] for k,v in ff.items()]))
fieldcheck('Fourier midpoint identity with every product mode retained',add(nonlinear(fu),scale(-1,nonlinear(fa)),scale(-1,derivative(fm,fb))))
fret=project(derivative(fm,fb))
check('Fourier exact signed all-source energy exchange',inner(fa,fret)+inner(fb,nonlinear(fu)))
check('Fourier full nonlinear energy conservation',inner(fu,nonlinear(fu)))
fout=project(nonlinear(fa),True)
ffirst=project(derivative(fa,fout))
outnorm=inner(fout,fout); firstnorm=inner(ffirst,ffirst)
assert outnorm>0 and firstnorm>0
COUNT+=1
print(f'EXACT {COUNT:02d}: nontrivial NS excursion and return: ||QN(a)||^2={outnorm}, ||PDN(a)QN(a)||^2={firstnorm}')
print(f'\nTOTAL: {COUNT} exact symbolic/algebra controls passed.')
print('All Fourier products retained; no PDE evolution was numerically solved.')
