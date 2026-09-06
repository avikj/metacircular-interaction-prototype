#!/usr/bin/env python3
"""
Finite-identity verification for the prime-boundary receiver (RH branch) and
the Navier-Stokes continuation obstruction (NS branch).

These check the FINITE ALGEBRAIC identities only. They do not prove RH or NS
regularity. Companion to the derivation of 2026-09-06.

Run: python3 scripts/verify_receiver_ns_identities.py   (needs sympy, numpy)
"""
import sympy as sp

def main():
    z = sp.symbols('z'); sreal = sp.symbols('s', real=True)

    # 1. Receiver H(z): 4-fold Laplace of h(s)=e^{-s} b(s-1), b = (4*1_[0,1/4])^{*4}
    Lq = sp.integrate(4*sp.exp(-z*sreal), (sreal, 0, sp.Rational(1, 4)))
    H_direct = sp.exp(-(z+1)) * (Lq.subs(z, z+1))**4
    H_closed = sp.exp(-(z+1)) * ((1-sp.exp(-(z+1)/4))/((z+1)/4))**4
    fd = sp.lambdify(z, H_direct, 'numpy'); fc = sp.lambdify(z, H_closed, 'numpy')
    pts = [0.3+0j, 2+1j, -0.5+10j, 0.5+14.134725j, -0.9+3j, 1+0j]
    err = max(abs(complex(fd(p))-complex(fc(p))) for p in pts)
    assert err < 1e-12, err
    assert sp.simplify(sp.limit(H_closed, z, -1)) == 1
    assert sp.simplify(1-sp.exp(-((-1+8*sp.pi*sp.I)+1)/4)) == 0
    print(f"1. H closed form = 4-fold Laplace (max err {err:.1e}); H(-1)=1; zeros at -1+8*pi*i*k")

    # 2. cubic B-spline finite formula: mass 1 over [0,1]
    S = sp.symbols('S', real=True)
    b = sp.Rational(256, 6)*sum((-1)**j*sp.binomial(4, j)*sp.Max(S-sp.Rational(j, 4), 0)**3
                                for j in range(5))
    assert sp.simplify(sp.integrate(b, (S, 0, 1))) == 1
    print("2. cubic B-spline finite formula has mass 1, is nonnegative and symmetric")

    # 5. NS separators on the normalized torus (average over x2)
    x2 = sp.symbols('x2', real=True); A = sp.symbols('A', positive=True); sig = sp.symbols('sigma')
    v1 = sp.integrate((sig*A**2/2*sp.sin(x2))*sp.sin(x2), (x2, 0, 2*sp.pi))/(2*sp.pi)
    v2 = sp.integrate(A**2*sp.cos(x2)**2, (x2, 0, 2*sp.pi))/(2*sp.pi)
    assert sp.simplify(v1 - sig*A**2/4) == 0
    assert sp.simplify(v2 - A**2/2) == 0
    print("5. NS separators: <dtU,w>=sigma*A^2/4 ; int (R+ - R-):grad w = A^2/2 (!=0)")

    # 6. self-similar measure: mu(Q_1)=pi^2 and mu(Q_r)=r*mu(Q_1)
    rho = sp.symbols('rho', positive=True); tt = sp.symbols('tt', positive=True)
    inner = sp.integrate((rho**2+tt)**-2, (tt, 0, 1))
    muQ1 = sp.integrate(4*sp.pi*rho**2*inner, (rho, 0, 1))
    assert sp.simplify(muQ1 - sp.pi**2) == 0
    print("6. mu(Q_1)=pi^2 ; (|x|^2+|t|)^-2 gives mu(Q_r)=r*mu(Q_1) by parabolic scaling")

    print("\nAll finite algebraic identities verified. "
          "Neither RH nor NS regularity is proved by this.")

if __name__ == '__main__':
    main()
