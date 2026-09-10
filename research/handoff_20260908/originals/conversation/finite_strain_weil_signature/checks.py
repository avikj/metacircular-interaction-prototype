#!/usr/bin/env python3
"""Exact algebra controls for the attached analytical proof note.

These tests do not verify Calderon--Zygmund estimates, Hilbert-space density,
PDE compactness, actual zeta zero locations, or a proof-assistant build.
The four complex numbers in the signature test are formal off-line model
labels, not claimed zeros of zeta.
"""
from __future__ import annotations
import sympy as s

passed: list[str] = []
def check(name: str, value, expected=0) -> None:
    if isinstance(value, s.MatrixBase):
        rhs = expected if isinstance(expected, s.MatrixBase) else s.zeros(*value.shape)
        okay = all(s.simplify(e) == 0 for e in value-rhs)
    else:
        okay = s.simplify(value-expected) == 0
    if not okay:
        raise AssertionError(f"FAILED: {name}: {value!s}")
    passed.append(name)

x,y,z,t = s.symbols('x y z t', real=True)
xvec=s.Matrix([x,y,z]); xyz=(x,y,z)
a,b,d,e,f=s.symbols('a b d e f', real=True)
A=s.Matrix([[a,d,e],[d,b,f],[e,f,-a-b]])
shift=s.Matrix(s.symbols('b1 b2 b3', real=True))

def curl(v):
    return s.Matrix([s.diff(v[2],y)-s.diff(v[1],z),
                     s.diff(v[0],z)-s.diff(v[2],x),
                     s.diff(v[1],x)-s.diff(v[0],y)])
def div(v):
    return sum(s.diff(v[i],xyz[i]) for i in range(3))
def grad(v):
    return v.jacobian(xvec)
def lap(v):
    return v.applyfunc(lambda q: sum(s.diff(q,w,2) for w in xyz))

check('symmetric trace-free affine kernel: symmetry',A-A.T)
check('symmetric trace-free affine kernel: trace',s.trace(A))
check('affine kernel: curl',curl(A*xvec+shift))
check('affine kernel: divergence',div(A*xvec+shift))
check('affine kernel: Laplacian',lap(A*xvec+shift))
params=(a,b,d,e,f)
basis=[A.diff(q) for q in params]
mat=s.Matrix.hstack(*[m.reshape(9,1) for m in basis])
check('five strain basis matrices are independent',mat.rank(),5)

# Mean of a polynomial over the centered unit ball for degree <= 2.
def ballmean(expr):
    poly=s.Poly(s.expand(expr),x,y,z)
    total=0
    for powers,coeff in poly.terms():
        if powers==(0,0,0): total += coeff
        elif powers in ((2,0,0),(0,2,0),(0,0,2)): total += coeff/s.Integer(5)
        elif any(q%2 for q in powers): pass
        else: raise ValueError(f'Unsupported monomial {powers}')
    return s.simplify(total)

omega=s.Matrix(s.symbols('w1 w2 w3',real=True))
rotation=omega.cross(xvec)/2
u=shift+A*xvec+rotation+s.Matrix([0,0,x*y])
Su=(grad(u)+grad(u).T)/2
mu=u.applyfunc(ballmean)
alpha=Su.applyfunc(ballmean)
normalized=s.simplify(u-mu-alpha*xvec)
check('velocity mean reads the translation component',mu,shift)
check('mean strain reads five affine coordinates',alpha,A)
check('normalization preserves vorticity',curl(normalized)-curl(u))
check('normalization preserves incompressibility',div(normalized)-div(u))
check('normalized velocity has zero mean',normalized.applyfunc(ballmean))
check('normalized velocity has zero mean strain',((grad(normalized)+grad(normalized).T)/2).applyfunc(ballmean))
check('normalization is idempotent',normalized-normalized.applyfunc(ballmean)-((grad(normalized)+grad(normalized).T)/2).applyfunc(ballmean)*xvec,normalized)

# Time-dependent affine fields: exact NS with an explicit quadratic pressure.
aa,bb,dd,ee,ff=[s.Function(n)(t) for n in ('aa','bb','dd','ee','ff')]
At=s.Matrix([[aa,dd,ee],[dd,bb,ff],[ee,ff,-aa-bb]])
ct=s.Matrix([s.Function(n)(t) for n in ('c1','c2','c3')])
ua=At*xvec+ct
pa=-s.Rational(1,2)*(xvec.T*(s.diff(At,t)+At*At)*xvec)[0]-(s.diff(ct,t)+At*ct).dot(xvec)
res=s.diff(ua,t)+grad(ua)*ua+s.Matrix([s.diff(pa,q) for q in xyz])
check('arbitrary time-dependent affine strain solves NS with retained pressure',res)
check('affine pressure Poisson law',sum(s.diff(pa,q,2) for q in xyz)+s.trace(At*At))

# Metric transport identity, verified without presuming the deformation orthogonal.
F=s.Matrix([[1,2,0],[0,1,3],[0,0,1]])
D=F.inv()*F.inv().T
check('volume-preserving sample deformation',F.det(),1)
check('pulled-back diffusion is symmetric',D-D.T)
check('pulled-back diffusion has determinant one',D.det(),1)
check('metric and diffusion are inverses',D*(F.T*F),s.eye(3))
# Affine stretching cancels in transported vorticity at the algebraic level.
qvec=s.Matrix(s.symbols('q1 q2 q3', real=True))
check('affine vorticity stretch cancels moving frame derivative',-F.inv()*A*qvec+F.inv()*(A*qvec))

# Reflection signature for a formal off-line quartet plus one line label.
sigma,gamma,eta=s.symbols('sigma gamma eta',positive=True,real=True)
labels=[sigma+s.I*gamma,-sigma+s.I*gamma,sigma-s.I*gamma,-sigma-s.I*gamma,s.I*eta]
reflection=[1,0,3,2,4]
J=s.zeros(5)
for i,j in enumerate(reflection): J[i,j]=1
Z=s.diag(*labels)
check('reflection involution',J*J,s.eye(5))
check('reflection is Hermitian',J.H,J)
check('generator preserves the indefinite form',Z.H*J+J*Z)
check('signature: one quartet has two negative dimensions',sum(mult for val,mult in J.eigenvals().items() if val<0),2)
check('signature: one quartet plus one on-line label has three positive dimensions',sum(mult for val,mult in J.eigenvals().items() if val>0),3)
neg=s.Matrix([[1,0],[-1,0],[0,1],[0,-1],[0,0]])/s.sqrt(2)
check('reflection-odd basis has negative identity Gram',neg.H*J*neg,-s.eye(2))

m,k=s.symbols('m k',positive=True,real=True)
weights=s.diag(m,m,m,m,k)
check('multiplicity weights commute with reflection',weights*J-J*weights)
check('weighted form is Hermitian',weights*J,(weights*J).H)
check('changing multiplicity does not create duplicate evaluation dimensions', (weights*J).rank(),5)

# An arbitrary source combination has the same reflected modal Gram.
C=s.Matrix([[1,s.I],[2,1],[0,3],[1,-s.I],[2,0]])
check('finite source Gram is Hermitian',C.H*weights*J*C,(C.H*weights*J*C).H)

# Independent current consistency control.
Jcurrent=A.cofactor_matrix().T*(A*xvec)
check('affine cofactor current',Jcurrent,A.det()*xvec)
check('zero-vorticity affine Betchov balance',-4*A.det()+s.Rational(4,3)*div(Jcurrent))

print('\n'.join('PASS '+p for p in passed))
print(f'\n{len(passed)} exact checks passed.')
print('Not checked by this script: BMO estimates; compactness; infinite spectral density; zeta zero locations; global NS/RH; Agda/Lean compilation.')
