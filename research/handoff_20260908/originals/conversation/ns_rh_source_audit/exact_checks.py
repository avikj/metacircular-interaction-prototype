"""Finite exact checks accompanying the source-coherent continuation calculations.

Requires SymPy. These are algebraic checks, not an NS/RH proof or a Lean/Agda build.
Run: python exact_checks.py
"""
from itertools import product
from math import lcm, prod
import sympy as sp


def check_quadratic_jets():
    x, y, z, a, b, c, t = sp.symbols('x y z a b c t', real=True)
    u = sp.Matrix([x, y, z])
    v = sp.Matrix([a, b, c])
    Q = sp.Matrix([-2*y*z, x*z, x*y])
    J = Q.jacobian(u)
    Qv = Q.subs({x: a, y: b, z: c}, simultaneous=True)
    assert sp.expand(u.dot(Q)) == 0
    assert sp.expand(v.dot(J*v) + u.dot(Qv)) == 0
    base = sp.Matrix([1, 0, 0])
    J0 = J.subs({x: 1, y: 0, z: 0})
    first = sp.Matrix([0, sp.cosh(t), sp.sinh(t)])
    second = sp.Matrix([1-sp.cosh(2*t), 0, 0])
    assert all(sp.simplify(q) == 0 for q in first.diff(t)-J0*first)
    Qfirst = Q.subs(dict(zip(u, first)), simultaneous=True)
    assert all(sp.simplify(sp.expand_trig(q)) == 0
               for q in second.diff(t)-J0*second-2*Qfirst)
    assert sp.simplify(first.dot(first)+base.dot(second)-1) == 0
    print('PASS: cubic conservation, canonical tangent defect, exact second-jet compensation.')


def check_nilpotent_coefficients():
    # Mixed labelled jets in R[e1,e2,e3]/(ei**2).
    e = sp.symbols('e0:3')
    masks = range(8)
    coeffs = sp.symbols('u0:8')
    monomials = [prod(e[i] for i in range(3) if mask & (1 << i)) for mask in masks]
    polynomial = sum(coeffs[mask]*monomials[mask] for mask in masks)
    square = sp.Poly(sp.expand(polynomial**2), *e)
    for mask in masks:
        powers = tuple(int(bool(mask & (1 << i))) for i in range(3))
        expected = sum(coeffs[j]*coeffs[mask ^ j] for j in masks if (j & mask) == j)
        assert sp.expand(square.coeff_monomial(powers)-expected) == 0
    print('PASS: all eight labelled subset-product coefficients at order three.')


def check_crt_histories():
    C = [1]
    for m in range(1, 8):
        C.append(lcm(C[-1], m))
    for n in range(1, 7):
        coherent = 0
        images = set()
        for xs in product(*(range(C[m]) for m in range(n))):
            defects = tuple((xs[m]-xs[m+1]) % C[m] for m in range(n-1))
            image = (xs[-1], defects)
            assert image not in images
            images.add(image)
            reconstructed = [0]*n
            reconstructed[-1] = xs[-1]
            for m in range(n-2, -1, -1):
                reconstructed[m] = (defects[m]+reconstructed[m+1]) % C[m]
            assert tuple(reconstructed) == xs
            coherent += all(d == 0 for d in defects)
        ambient = prod(C[:n])
        assert len(images) == ambient
        assert coherent == C[n-1]
        assert sp.Rational(coherent, ambient) == sp.Rational(1, prod(C[:n-1]))
    # Source idempotent at the first distinguishing modulus.
    assert C[3] == 6 and 4**2 % 6 == 4
    assert all(root % 6 != 4 for root in (0, 1))
    print('PASS: exhaustive CRT endpoint/defect bijections through length six; probability identity.')


def check_capacity_potential():
    C = [1]
    for m in range(1, 51):
        C.append(lcm(C[-1], m))
    eta = [1]*51
    for m in range(2, 51):
        factors = sp.factorint(m)
        if len(factors) == 1:
            eta[m] = int(next(iter(factors)))
    for n in range(1, 51):
        delta = prod(C[:n])
        other = prod(eta[j]**(n-j) for j in range(1, n))
        assert delta == other
    print('PASS: exact integer DMR product reindexing through n=50.')


def check_logtime_transport():
    t, z = sp.symbols('t z', real=True)
    f = sp.Function('f')
    E = sp.exp(-sp.Rational(3, 2)*t)*f(sp.exp(t))
    op = lambda a: sp.diff(a,t,2)+2*sp.diff(a,t)+sp.Rational(3,4)*a
    target = sp.exp(t/2)*sp.Subs(sp.diff(f(z),z,2),z,sp.exp(t))
    assert sp.simplify(op(E)-target) == 0
    assert sp.simplify(op(-sp.exp(t/2)/2)+sp.exp(t/2)) == 0
    b = sp.Function('b')
    h = sp.exp(-t)*b(t-1)
    assert sp.simplify(op(h)-sp.exp(-t)*(sp.diff(b(t-1),t,2)-b(t-1)/4)) == 0
    g = sp.exp(-t/2)-sp.exp(-sp.Rational(3,2)*t)
    assert sp.simplify(op(g)) == 0
    assert g.subs(t,0) == 0 and sp.diff(g,t).subs(t,0) == 1
    # Unilateral-transform initial terms, with E(0)=-1/2, E'(0)=-1/4.
    Lz = (z+sp.Rational(1,2))*(z+sp.Rational(3,2))
    assert sp.simplify(Lz/(2*(z-sp.Rational(1,2)))
                       -(z/2+sp.Rational(5,4)+1/(z-sp.Rational(1,2)))) == 0
    print('PASS: log-time differential transport, causal Green jump, kernel and initial-boundary terms.')


if __name__ == '__main__':
    check_quadratic_jets()
    check_nilpotent_coefficients()
    check_crt_histories()
    check_capacity_potential()
    check_logtime_transport()
    print('All finite exact checks passed. No global PDE or zeta-location conclusion is certified.')
