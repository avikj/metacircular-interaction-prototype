"""Exact algebra checks for source-strain tomography and Hardy innovations.

These are not a proof-assistant build and do not verify the infinite operator,
number-theoretic, or PDE continuation assertions in the accompanying note.
"""
from __future__ import annotations

import math
import sympy as sp

COUNT = 0

def check(name: str, value: sp.Expr | sp.MatrixBase) -> None:
    global COUNT
    entries = list(value) if isinstance(value, sp.MatrixBase) else [value]
    assert all(sp.simplify(x) == 0 for x in entries), name
    COUNT += 1
    print(f"PASS {COUNT:02d}: {name}")

# A completely general real trace-free symmetric strain.
a, b, d, e, f = sp.symbols('a b d e f', real=True)
S = sp.Matrix([[a, d, e], [d, b, f], [e, f, -a-b]])
I3 = sp.eye(3)
e1, e2, e3 = (I3[:, j] for j in range(3))

def symbol(n: sp.MatrixBase) -> sp.MatrixBase:
    P = I3 - n*n.T
    return sp.expand(-P*S*P - ((n.T*S*n)[0]/2)*P)

Q1, Q2, Q3 = [symbol(n) for n in [e1, e2, e3]]
J3 = sp.I*sp.Matrix([[0, -1, 0], [1, 0, 0], [0, 0, 0]])
check('transverse trace zero', sp.trace(Q3))
check('longitudinal component killed', Q3*e3)
check('helical sign anticommutes with transverse symbol', Q3*J3 + J3*Q3)
rho2 = (a-b)**2/4+d**2
check('transverse eigenvalues squared', Q3*Q3-rho2*sp.diag(1,1,0))

# Scalar spin-two amplitude in a circular polarization basis.
hplus = sp.Matrix([1, sp.I, 0])/sp.sqrt(2)
hminus = sp.conjugate(hplus)
amp = (sp.conjugate(hplus).T*Q3*hminus)[0]
check('cross-helicity scalar amplitude', amp - (-(a-b)/2+sp.I*d))
check('cross-helicity amplitude modulus squared', amp*sp.conjugate(amp)-rho2)

# The energy-critical Sobolev weight fixes the transverse trace cancellation.
eta = sp.symbols('eta', real=True)
P3 = sp.diag(1,1,0)
Qeta = -P3*S*P3-eta*S[2,2]*P3
check('general Sobolev trace', sp.trace(Qeta)-(1-2*eta)*S[2,2])

# Five scalar readings reconstruct all of S.
r1, r2, r3, r4, r5 = Q3[0,0], Q3[0,1], Q2[0,0], Q2[0,2], Q1[1,2]
Srec = sp.Matrix([[-sp.Rational(2,3)*(r1+r3), -r2, -r4],
                  [-r2, sp.Rational(4,3)*r1-sp.Rational(2,3)*r3, -r5],
                  [-r4, -r5, -sp.Rational(2,3)*r1+sp.Rational(4,3)*r3]])
check('five scalar principal-symbol readings reconstruct strain', Srec-S)
check('two-direction actual stretching reconstruction',
      -sp.Rational(2,3)*(Q1[2,2]+Q2[2,2])-S[2,2])

# Spherical averaging is done by exact monomial moments, not quadrature.
nx, ny, nz = sp.symbols('nx ny nz', real=True)
n = sp.Matrix([nx,ny,nz])
Q = symbol(n)

def sphere_average(expr: sp.Expr) -> sp.Expr:
    ans = 0
    for powers, coefficient in sp.Poly(sp.expand(expr), nx,ny,nz).terms():
        if any(k % 2 for k in powers):
            continue
        half = [k//2 for k in powers]
        numerator = math.prod(int(sp.factorial2(2*k-1)) for k in half)
        denominator = int(sp.factorial2(2*sum(half)+1))
        ans += coefficient*sp.Rational(numerator,denominator)
    return sp.expand(ans)

Qavg = Q.applyfunc(sphere_average)
check('spherical symbol average = -2/5 strain', Qavg+sp.Rational(2,5)*S)

# Direct Fourier derivation of the subprincipal term for the coadjoint generator.
px, py, pz, vx, vy, vz, eps = sp.symbols('px py pz vx vy vz eps', real=True)
p = sp.Matrix([px,py,pz])
v = sp.Matrix([vx,vy,vz])
r = (1+2*pz*eps+(px*px+py*py+pz*pz)*eps**2)**sp.Rational(1,4)
scalar_limit = sp.diff(1/r-r,eps).subs(eps,0)*vz
check('critical weight transport correction', scalar_limit+pz*vz)
Sf = sp.I*(v*p.T+p*v.T)/2
fourier_limit = sp.I*P3*(scalar_limit*I3-p*v.T-v*p.T)*P3/2
predicted = -P3*Sf*P3-Sf[2,2]*P3/2
check('Fourier high-frequency coefficient matches principal symbol', fourier_limit-predicted)

# Hardy source recovery on one general term; linearity proves any finite sum.
s,z,w,T,U = sp.symbols('s z w T U')
term = sp.exp(z*T+w*U)/(2*s-z-w)
L = lambda expr: sp.expand(2*s*expr-sp.diff(expr,T)-sp.diff(expr,U))
check('Hardy transport derivative recovers source product', L(term)-sp.exp(z*T+w*U))
berg = sp.exp(z*T+w*U)/(2*s-z-w)**2
check('Bergman transport derivative is Hardy kernel', L(berg)-term)
check('second Bergman transport derivative recovers product', L(L(berg))-sp.exp(z*T+w*U))
check('damping derivative is Bergman kernel', -sp.diff(term,s)/2-berg)

# Cauchy determinant: full symbolic three-point kernel (unnormalized).
x1,x2,x3,y1,y2,y3 = sp.symbols('x1 x2 x3 y1 y2 y3')
xs, ys = [x1,x2,x3], [y1,y2,y3]
C = sp.Matrix([[1/(x+y) for y in ys] for x in xs])
cauchy_product = sp.prod(xs[j]-xs[i] for i in range(3) for j in range(i+1,3))*sp.prod(ys[j]-ys[i] for i in range(3) for j in range(i+1,3))/sp.prod(x+y for x in xs for y in ys)
check('three-point Cauchy determinant', sp.factor(C.det()-cauchy_product))

# Exact rational complex test points in the allowed half-plane.
s0 = sp.Rational(2)
zs = [sp.Rational(1,4)+sp.I, -sp.Rational(1,3)+2*sp.I, sp.Rational(1,5)+4*sp.I]
def gram(points: list[sp.Expr]) -> sp.MatrixBase:
    return sp.Matrix([[2*sp.sqrt((s0-sp.re(z))*(s0-sp.re(w)))/(2*s0-z-sp.conjugate(w)) for w in points] for z in points])
def rho_sq(z: sp.Expr,w: sp.Expr) -> sp.Expr:
    return sp.simplify((z-w)*sp.conjugate(z-w)/((2*s0-z-sp.conjugate(w))*sp.conjugate(2*s0-z-sp.conjugate(w))))

GN = gram(zs)
check('normalized three-point determinant is pair-distance product',
      GN.det()-sp.prod(rho_sq(zs[i],zs[j]) for i in range(3) for j in range(i+1,3)))
check('new-mode Schur residual = product of two distances',
      GN.det()/gram(zs[:2]).det()-rho_sq(zs[2],zs[0])*rho_sq(zs[2],zs[1]))

gap, sreal = sp.symbols('gap sreal', positive=True)
qabs = 2*sreal/sp.sqrt(4*sreal**2+gap**2)
check('nearby critical-line pair lower-eigenvalue bound identity',
      (1-qabs) - gap**2/(sp.sqrt(4*sreal**2+gap**2)*(sp.sqrt(4*sreal**2+gap**2)+2*sreal)))

print(f'\n{COUNT} exact algebraic controls passed.')
print('Not checked here: pseudodifferential norm theorem, zero-density theorem, infinite products, PDE continuation, or RH.')
