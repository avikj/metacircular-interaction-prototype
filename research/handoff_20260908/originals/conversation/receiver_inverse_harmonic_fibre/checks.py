#!/usr/bin/env python3
"""Exact algebraic checks; not an NS/RH proof or a PDE convergence test.
Run: python checks.py. Requires sympy.
"""
from __future__ import annotations
from dataclasses import dataclass
import sympy as s

@dataclass
class Check:
    name: str
    passed: bool

checks: list[Check] = []

def zero(name: str, expression: s.Expr | s.MatrixBase) -> None:
    items = list(expression) if isinstance(expression, s.MatrixBase) else [expression]
    ok = all(s.simplify(s.expand(e)) == 0 for e in items)
    checks.append(Check(name, ok))
    if not ok:
        raise AssertionError(f'{name}: {expression}')

# Finite history inverse, including its symbolic all-N induction step.
z, x = s.symbols('z x')
for n in range(13):
    series = sum((j+1)*z**j for j in range(n+1))
    remainder = 1-(n+2)*z**(n+1)+(n+1)*z**(n+2)
    zero(f'inverse boundary polynomial N={n}', (1-z)**2*series-remainder)
n = s.symbols('n', integer=True, nonnegative=True)
# Divide the induction difference by z**(N+1) before symbolic simplification.
zero('inverse boundary polynomial induction, all N',
     (-(n+3)*z+(n+2)*z*z+(n+2)-(n+1)*z)
     -(n+2)*(1-z)**2)
q = s.symbols('q')
zero('inverse identity after one extra difference N=3',
     (1-(3+2)*q**4+(3+1)*q**5) * (1-q)**2
     -(1-q)**4*sum((j+1)*q**j for j in range(4)))
H = 16*(1-s.exp(-(z+4)/4))**2/(z+4)**2
zero('fixed receiver differential-delay multiplier',
     (z+4)**2*H-16*(1-s.exp(-1)*s.exp(-z/4))**2)
zero('spectral-strip contraction exponent', -1+s.Rational(1,2)*s.Rational(1,4)+s.Rational(7,8))

# Affine strain source realized by a compactly cut off vector potential.
xx, yy, zz = s.symbols('X Y Z', real=True)
xyz = (xx, yy, zz)
X = s.Matrix(xyz)
a,b,d,e,f = s.symbols('a b d e f', real=True)
A=s.Matrix([[a,d,e],[d,b,f],[e,f,-a-b]])

def curl(V: s.MatrixBase) -> s.Matrix:
    return s.Matrix([s.diff(V[2],yy)-s.diff(V[1],zz),
                     s.diff(V[0],zz)-s.diff(V[2],xx),
                     s.diff(V[1],xx)-s.diff(V[0],yy)])

def div(V: s.MatrixBase) -> s.Expr:
    return sum(s.diff(V[j],xyz[j]) for j in range(3))

psi=-X.cross(A*X)/3
zero('vector potential produces arbitrary trace-free affine strain',curl(psi)-A*X)
zero('affine strain has no vorticity',curl(A*X))
zero('affine strain is divergence free',div(A*X))
C = s.Function('C')(xx,yy,zz)
zero('arbitrary smooth cutoff keeps the constructed field divergence free',div(curl(C*psi)))
zero('affine cofactor current',A.cofactor_matrix().T*(A*X)-A.det()*X)
zero('pure-strain cubic term cancels its cofactor divergence',
     -4*A.det()+s.Rational(4,3)*div(A.cofactor_matrix().T*(A*X)))

# True NS vorticity time derivative at the common normalized source point.
o1,o2,o3=s.symbols('o1 o2 o3', real=True)
Om=s.Matrix([o1,o2,o3])
rotation=Om.cross(X)/2
zero('core rotation vorticity',curl(rotation)-Om)
zero('affine harmonic addition preserves core vorticity',curl(rotation+A*X)-Om)
base=rotation.jacobian(xyz)*Om
shifted=(rotation+A*X).jacobian(xyz)*Om
zero('actual first-vorticity-variation separator',shifted-base-A*Om)
zero('solid rotation alone has zero local stretching',base)

# Exact spherical fourth moments give the missing strain observer.
def sphere_average(poly: s.Expr) -> s.Expr:
    result=s.S.Zero
    for powers, coefficient in s.Poly(s.expand(poly),xx,yy,zz).terms():
        if any(p%2 for p in powers):
            continue
        ks=[p//2 for p in powers]
        numerator=s.prod(s.factorial2(2*k-1) if k else 1 for k in ks)
        denominator=s.factorial2(2*sum(ks)+1)
        result += coefficient*numerator/denominator
    return s.simplify(result)
normal=(X.T*A*X)[0]
recovered=s.Matrix(3,3,lambda i,j:s.Rational(15,2)*sphere_average(
    normal*(X[i]*X[j]-(s.Rational(1,3) if i==j else 0))))
zero('boundary quadrupole recovers every trace-free symmetric strain',recovered-A)

# Log-radial cutoff core: curl formula used in the peak-normalization proof.
r=s.sqrt(xx*xx+yy*yy+zz*zz)
F=s.Function('F')
radial_rotation=F(r)*Om.cross(X)
# Avoid differentiating with respect to a composite expression in sympy.
Fp=s.Subs(s.diff(F(s.Symbol('r')),s.Symbol('r')),s.Symbol('r'),r)
radial_expected=(2*F(r)+r*Fp)*Om-Fp*(Om.dot(X))*X/r
zero('radial compact rotation curl formula',curl(radial_rotation)-radial_expected)

# Parabolic L2 / maximum-vorticity dimensions, all in three dimensions.
lam=s.symbols('lambda', positive=True)
zero('parabolic L2 square scales by r',lam**(-2)*lam**3-lam)
zero('parabolic maximum vorticity scales by r^-2',lam**(-1)*lam**(-1)-lam**(-2))

if __name__=='__main__':
    for check in checks:
        print(f'PASS {check.name}')
    print(f'\n{sum(c.passed for c in checks)}/{len(checks)} exact algebraic checks passed.')
    print('No Navier-Stokes evolution, RH verification, or Agda/Lean build was executed.')
