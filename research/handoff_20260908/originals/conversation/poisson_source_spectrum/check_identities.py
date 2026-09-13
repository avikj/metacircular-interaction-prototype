"""Exact algebraic controls for Poisson source spectrum and shared-noise unitality.

Requirements: Python 3.10+, sympy.
These checks do not prove the infinite-dimensional spectral/continuation claims.
The accompanying note provides the analytic arguments.
"""
from __future__ import annotations

import math
from fractions import Fraction
import sympy as sp


def require_zero(name: str, value: sp.Expr | sp.MatrixBase) -> None:
    entries = list(value) if isinstance(value, sp.MatrixBase) else [value]
    if any(sp.simplify(x) != 0 for x in entries):
        raise AssertionError(f"Failed: {name}: {value}")
    print(f"PASS: {name}")


def average_two_torus(expr: sp.Expr, x: sp.Symbol, y: sp.Symbol) -> sp.Expr:
    integrand = sp.expand_trig(expr)
    integral = sp.integrate(sp.integrate(integrand, (x, -sp.pi, sp.pi)),
                            (y, -sp.pi, sp.pi))
    return sp.simplify(integral / (4 * sp.pi**2))


def shear_norm_witness_squared(p: int, k: int) -> Fraction:
    """Exact norm ratio squared for input e1*(1+cos y)^p*exp(i*k*z).

    Source u=(sin y,0,0). Leray projection is applied exactly in Fourier
    coordinates. The common 2**(-p) Fourier normalization cancels.
    """
    if p < 1 or k < 1:
        raise ValueError("p and k must be positive integers")
    c = {m: math.comb(2*p, p+m) for m in range(-p, p+1)}
    denom = sum(a*a for a in c.values())
    numer = Fraction(0)
    for m in range(-p-1, p+2):
        d = Fraction(c.get(m-1, 0) + c.get(m+1, 0), 2)
        numer += d*d * Fraction(k*k, k*k + m*m)
    return numer / denom


def main() -> None:
    wx, wy, wz = sp.symbols("wx wy wz", real=True)
    # C*a = a cross omega, not omega cross a.
    C = sp.Matrix([[0, wz, -wy], [-wz, 0, wx], [wy, -wx, 0]])
    P = sp.diag(1, 1, 0)
    plus = sp.Matrix([1, sp.I, 0])
    minus = sp.conjugate(plus)
    require_zero("transverse principal-symbol eigenvalue -wz", sp.I*P*C*P*plus + wz*plus)
    require_zero("transverse principal-symbol eigenvalue +wz", sp.I*P*C*P*minus - wz*minus)

    h = sp.symbols("h0:6", real=True)
    H = sp.Matrix([[h[0],h[1],h[2]], [h[1],h[3],h[4]], [h[2],h[4],h[5]]])
    B = C*H
    require_zero("Hamiltonian stabilizer B*Pi+Pi*B^T=0", B*C + C*B.T)

    j = sp.symbols("j0:9", real=True)
    J = sp.Matrix(3,3,j)
    nu = sp.symbols("nu", positive=True)
    D = sp.Matrix([[0,1,-2],[-1,0,3],[2,-3,0]])
    L = J + nu*D*D
    generator_identity = L + L.T + 2*nu*D*D.T
    require_zero("shared-noise generator at identity equals J+J^T", generator_identity-J-J.T)

    x,y,z,t = sp.symbols("x y z t", real=True)
    a = sp.symbols("a", positive=True)
    coords=(x,y,z)
    u=sp.Matrix([a*sp.exp(-nu*t)*sp.sin(y),0,0])
    v=sp.Matrix([-sp.sin(x+y), sp.sin(x)+sp.sin(x+y),0])
    grad=u.jacobian(coords)
    S=(grad+grad.T)/2
    lap=u.applyfunc(lambda f: sum(sp.diff(f,q,2) for q in coords))
    require_zero("unforced globally smooth shear solves NS with p=0", sp.diff(u,t)+grad*u-nu*lap)
    require_zero("test field is divergence-free", sum(sp.diff(v[i],coords[i]) for i in range(3)))
    require_zero("test-field L2 norm squared is 3/2", average_two_torus(v.dot(v),x,y)-sp.Rational(3,2))
    dv2=sum(sp.diff(v[i],q)**2 for i in range(3) for q in coords)
    require_zero("test-field gradient norm squared is 5/2", average_two_torus(dv2,x,y)-sp.Rational(5,2))
    require_zero("strain pairing equals -a*exp(-nu*t)/4", average_two_torus((v.T*S*v)[0],x,y)+a*sp.exp(-nu*t)/4)

    print("\nExact finite-Fourier norm witnesses, displayed as decimal square roots:")
    for p in (2,4,8,16,32,64,128):
        value=shear_norm_witness_squared(p,p*p)
        assert 0 < value < 1
        print(f"p={p:3d}, k={p*p:5d}, ||Pi v||/||v||={math.sqrt(float(value)):.12f}")


if __name__ == "__main__":
    main()
