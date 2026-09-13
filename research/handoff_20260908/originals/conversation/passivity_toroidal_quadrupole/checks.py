"""Exact algebraic checks: passivity supply and toroidal quadrupole.
These checks do not establish global NS regularity or RH.
"""
import sympy as sp
checks = []

def check(name, lhs, rhs=0):
    assert sp.simplify(lhs-rhs) == 0, name
    checks.append(name)

x,y,z = sp.symbols("x y z", real=True)
a,b,c,d,e = sp.symbols("a b c d e", real=True)
A = sp.Matrix([[a,c,d],[c,b,e],[d,e,-a-b]])
X = sp.Matrix([x,y,z])
P = X.cross(A*X)
r2 = X.dot(X)
check("toroidal tangency", P.dot(X))
check("toroidal Cartesian divergence", sum(sp.diff(P[i], X[i]) for i in range(3)))
h = sp.Function('h')(r2)
check("radial-factor toroidal divergence",
      sum(sp.diff(h*P[i], X[i]) for i in range(3)))
curlP = sp.Matrix([sp.diff(P[2],y)-sp.diff(P[1],z),
                  sp.diff(P[0],z)-sp.diff(P[2],x),
                  sp.diff(P[1],x)-sp.diff(P[0],y)])
for i in range(3):
    check(f"curl(x cross A x), component {i}", curlP[i], -3*(A*X)[i])

# Normalized area average on S^2 by its exact even moments.
def sphavg(poly):
    ans = 0
    for powers, coeff in sp.Poly(sp.expand(poly), x,y,z).terms():
        if any(k % 2 for k in powers):
            continue
        total = sum(powers)
        num = sp.prod(sp.factorial2(k-1) for k in powers)
        den = sp.factorial2(total+1)
        ans += coeff*num/den
    return sp.simplify(ans)

Craw = X*(X.cross(P)).T + X.cross(P)*X.T
for i in range(3):
    for j in range(i,3):
        check(f"normalized shell tensor {i}{j}",
              sphavg(Craw[i,j]), -sp.Rational(2,5)*A[i,j])
check("toroidal quadrupole squared norm",
      sphavg(P.dot(P)), sp.trace(A*A)/5)
A2 = sp.Matrix([[2,1,-1],[1,-3,2],[-1,2,1]])
check("toroidal quadrupole polarized inner product",
      sphavg(P.dot(X.cross(A2*X))), sp.trace(A*A2)/5)
# Shell strain coefficient: (3/(8pi))*(4pi)*average = 3/2 average.
for i in range(3):
    check(f"shell strain coefficient {i}", sp.Rational(3,2)*sphavg(Craw[i,i]),
          -sp.Rational(3,5)*A[i,i])

# Orthogonality to a family of harmonic gradients, checked angularly.
harmonic_polynomials = [
    x,y,z,
    x*y,x*z,y*z,x*x-y*y,2*z*z-x*x-y*y,
    x**3-3*x*y*y, z*(x*x-y*y), x*y*z
]
for k,H in enumerate(harmonic_polynomials):
    check(f"harmonicity of test {k}", sum(sp.diff(H,v,2) for v in [x,y,z]))
    gradH = sp.Matrix([sp.diff(H,v) for v in [x,y,z]])
    check(f"toroidal-gradient orthogonality {k}", sphavg(P.dot(gradH)))

# Network controls, real inputs.
M,Z,c1,c2 = sp.symbols("M Z c1 c2", real=True)
gram = sp.Matrix([[M,Z],[Z,M]])
v = sp.Matrix([c1,c2])
check("two-pulse supply equals half Gram quadratic",
      (v.T*gram*v)[0]/2, M*(c1*c1+c2*c2)/2+Z*c1*c2)
q = sp.symbols("q", real=True)
negtest = (sp.Matrix([1,-1]).T*sp.Matrix([[1,q],[q,1]])*sp.Matrix([1,-1]))[0]/2
check("active cosh two-pulse work", negtest, 1-q)
u1,u2,v1,v2,f1,f2,gamma = sp.symbols(
    "u1 u2 v1 v2 f1 f2 gamma", real=True)
# Complex oscillator state a=u1+i*u2 and input f=f1+i*f2.
state = u1+sp.I*u2
forcing = f1+sp.I*f2
adot = sp.I*gamma*state+forcing
check("lossless oscillator energy rate",
      sp.re(sp.conjugate(state)*adot), sp.re(sp.conjugate(forcing)*state))

# Remote-field scaling and homogeneous counterexample growth.
m = sp.symbols("m", positive=True)
# Integral of r^{-m} for m>1 gives R^{1-m}/(m-1).
R = sp.symbols("R", positive=True)
check("radial high-derivative kernel primitive",
      sp.diff(R**(1-m)/(m-1), R), -R**(-m))

print(f"{len(checks)} exact checks passed.")
for item in checks:
    print("PASS: "+item)
