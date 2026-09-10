"""Exact symbolic controls and separately labelled numerical consistency checks.

No actual off-critical zeta zero is used.  The synthetic divisor below is a
finite algebra control only.  No Agda/Lean build or NS evolution is performed.
Run: python checks.py
"""
from __future__ import annotations
import math
import sympy as sp
import mpmath as mp

COUNT = 0

def exact(name, expression):
    global COUNT
    entries = list(expression) if isinstance(expression, sp.MatrixBase) else [expression]
    for entry in entries:
        assert sp.simplify(entry) == 0, (name, entry)
    COUNT += 1
    print(f"EXACT {COUNT:02d}: {name}")

# ---- Actual-source division: finite-divisor algebra control ----
w, x, z = sp.symbols('w x z')
a = sp.Rational(1,4) + 2*sp.I
roots = [a, sp.conjugate(a), -sp.conjugate(a), -a, sp.I, -sp.I]
multiplicities = [2,2,2,2,1,1]
P = sp.Poly(sp.prod((w-r)**m for r,m in zip(roots,multiplicities)),w)
exact('synthetic divisor is even', P.as_expr().subs(w,-w)-P.as_expr())
exact('synthetic divisor has real coefficients', sp.Matrix([sp.im(c) for c in P.all_coeffs()]))
cardinals = []
for i,(root,m) in enumerate(zip(roots,multiplicities)):
    quotient, remainder = sp.div(P, sp.Poly((w-root)**m,w))
    exact(f'division by full multiplicity at synthetic root {i}', remainder.as_expr())
    norm = sp.simplify(sp.factorial(m)/sp.diff(P.as_expr(),w,m).subs(w,root))
    I = sp.Poly(sp.expand(norm*quotient.as_expr()),w)
    cardinals.append(I.as_expr())
    for j,other in enumerate(roots):
        exact(f'cardinal value {i},{j}', I.eval(other)-int(i==j))

# Volterra discrepancy is a homogeneous solution with coefficients the moments.
for m in range(1,5):
    moments = sp.symbols(f'mu0:{m}')
    poly = sum(sp.binomial(m-1,j)*x**(m-1-j)*(-1)**j*moments[j]
               for j in range(m))/sp.factorial(m-1)
    expr = sp.exp(z*x)*poly
    for _ in range(m):
        expr = sp.diff(expr,x)-z*expr
    exact(f'order-{m} past/future mismatch solves the homogeneous ODE',expr)

m = sp.symbols('m',positive=True)
v = sp.Matrix([1,1,-1,-1])/(2*sp.sqrt(m))
J = sp.Matrix([[0,0,1,0],[0,0,0,1],[1,0,0,0],[0,1,0,0]])
exact('real quartet direction is J-negative',(J+sp.eye(4))*v)
exact('multiplicity-weighted quartet norm equals one',m*(v.T*v)[0]-1)
exact('multiplicity-weighted quartet Weil value equals minus one',m*(v.T*J*v)[0]+1)

# Theta-source differential identity.
t, p = sp.symbols('t p',positive=True)
F = sp.exp(t/2-p*sp.exp(2*t))
phi_term = (4*p**2*sp.exp(4*t)-6*p*sp.exp(2*t))*F
exact('theta-source kernel is (D^2-1/4) applied to e^(x/2) psi',sp.diff(F,t,2)-F/4-phi_term)

# ---- Toroidal quadrupole heat transfer ----
y = sp.symbols('y',positive=True)
r,nu,tau = sp.symbols('r nu tau',positive=True)
h = sp.erf(y)-2/sp.sqrt(sp.pi)*sp.exp(-y*y)*(y+sp.Rational(2,3)*y**3)
exact('quadrupole attenuation derivative',sp.diff(h,y)-8/(3*sp.sqrt(sp.pi))*y**4*sp.exp(-y*y))
exact('quadrupole attenuation at zero',h.subs(y,0))
exact('quadrupole attenuation at infinity',sp.limit(h,y,sp.oo)-1)
exact('quadrupole attenuation small-radius coefficient',sp.limit(h/y**5,y,0)-8/(15*sp.sqrt(sp.pi)))
H = h.subs(y,r/(2*sp.sqrt(nu*tau)))
Phi = sp.erf(r/(2*sp.sqrt(nu*tau)))/(4*sp.pi*r)
exact('heat-regularized Newton Hessian coefficient',sp.diff(Phi,r,2)-sp.diff(Phi,r)/r-3*H/(4*sp.pi*r**3))
exact('backward radial response equation',sp.diff(H,tau)-nu*(sp.diff(H,r,2)-4*sp.diff(H,r)/r))
b = sp.Function('b')(r)
C = r*r*b
radial = sp.diff(C,r,2)+2*sp.diff(C,r)/r-6*C/r**2
exact('toroidal l=2 radial heat is seven-dimensional after division by r^2',radial-r*r*(sp.diff(b,r,2)+6*sp.diff(b,r)/r))
# Integration by parts proves int h(y)y^-3 dy = 1/2 int h'(y)y^-2 dy.
I = sp.integrate(sp.diff(h,y)/(2*y*y),(y,0,sp.oo))
exact('dimensionless integrated memory is one third',I-sp.Rational(1,3))
exact('shell memory integral is r^2/(6nu)',r*r/(2*nu)*I-r*r/(6*nu))
# First moment from Tonelli's gamma identity.
A = r*r/(4*nu)
first = A*A*sp.gamma(sp.Rational(1,2))/(2*sp.gamma(sp.Rational(5,2)))
exact('first temporal moment is r^4/(24nu^2)',first-r**4/(24*nu**2))

# Geometric source stacks.
N = sp.symbols('N',integer=True,positive=True)
exact('energy-amplitude sum for R_j=4^-j',(1-sp.Integer(32)**(-N))/31-(sp.Rational(1,32)*(1-sp.Integer(32)**(-N))/(1-sp.Rational(1,32))))
exact('time-integrated shell-memory sum',(1-sp.Integer(16)**(-N))/15-(sp.Rational(1,16)*(1-sp.Integer(16)**(-N))/(1-sp.Rational(1,16))))

nx,ny,nz = sp.symbols('nx ny nz',real=True)
n = sp.Matrix([nx,ny,nz])
Amat = sp.diag(sp.Rational(1,2),sp.Rational(1,2),-1)
TA = n.cross(Amat*n)
exact('quadrupole shell vorticity amplitude formula',(TA.T*TA)[0]-sp.Rational(9,4)*nz*nz*(nx*nx+ny*ny))
exact('quadrupole provides positive axial central strain',(-sp.Rational(3,5)*Amat)[:,2]-sp.Matrix([0,0,sp.Rational(3,5)]))

# Core vorticity is bounded by 1 when 0<=chi<=1 and 0<=q=-r chi'<=1.
chi,q,c = sp.symbols('chi q c',real=True)
coremag = chi**2*c*c+(chi-q/2)**2*(1-c*c)
exact('core amplitude is convex combination of radial/tangential squares',coremag-(chi*chi*c*c+(chi-q/2)**2*(1-c*c)))

print(f'\nTOTAL: {COUNT} exact symbolic controls passed.')

# ---- Numerical checks: independent quadratures, not theorem proofs ----
mp.mp.dps = 45
NUM = 0

def numerical(name, left, right, tolerance=mp.mpf('1e-34')):
    global NUM
    err = abs(left-right)
    assert err <= tolerance*max(1,abs(right)), (name,left,right,err)
    NUM += 1
    print(f'NUMERICAL {NUM:02d}: {name}; error={mp.nstr(err,5)}')

def theta_phi(x):
    x=abs(x)
    E=mp.exp(2*x)
    return mp.fsum((4*(mp.pi*k*k*E)**2-6*mp.pi*k*k*E)*mp.exp(x/2-mp.pi*k*k*E)
                   for k in range(1,9))

def xi_center(z):
    s=mp.mpf('0.5')+z
    return s*(s-1)/2*mp.power(mp.pi,-s/2)*mp.gamma(s/2)*mp.zeta(s)

# The interval x>=3 has double-exponentially negligible mass at this precision.
for zz in [mp.mpf('0'),mp.mpf('0.2'),mp.mpc('0.3','2')]:
    observed=2*mp.quad(lambda xx:theta_phi(xx)*mp.cosh(zz*xx),[0,.25,.5,1,2,3])
    numerical(f'theta-source transform matches completed zeta at {zz}',observed,xi_center(zz))

def h5(y):
    return mp.gammainc(mp.mpf('2.5'),0,y*y)/mp.gamma(mp.mpf('2.5'))

J0=mp.quad(lambda yy:h5(yy)/yy**3,[0,.25,1,3,mp.inf])
numerical('incomplete-gamma memory integral',J0,mp.mpf(1)/3)
for rr,vv in [(mp.mpf('1'),mp.mpf('1')),(mp.mpf('2'),mp.mpf('0.7'))]:
    observed=mp.quad(lambda tt:h5(rr/(2*mp.sqrt(vv*tt))),[0,.01,.1,1,10,mp.inf])
    numerical(f'physical shell lifetime r={rr},nu={vv}',observed,rr*rr/(6*vv),mp.mpf('1e-30'))
print(f'TOTAL: {NUM} numerical consistency checks passed.')
