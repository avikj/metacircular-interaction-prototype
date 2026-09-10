"""Exact symbolic checks for source/coadjoint/tangent residual identities.

Fourier fields are finite dictionaries. Products retain every generated mode;
there is no Galerkin cutoff. These checks do not prove compactness, stochastic
existence, or continuation. Those arguments are in the accompanying note.
"""
from __future__ import annotations
import json
from pathlib import Path
import sympy as sp

I = sp.I
Vec = sp.Matrix
Z = Vec([0, 0, 0])
Field = dict[tuple[int, int, int], sp.Matrix]
results: list[str] = []

def clean(field: Field) -> Field:
    return {k: q for k, v in field.items()
            if (q := v.applyfunc(sp.simplify)) != Z}

def add(f: Field, g: Field) -> Field:
    return clean({k: f.get(k, Z) + g.get(k, Z) for k in set(f) | set(g)})

def scale(c: sp.Expr | int, f: Field) -> Field:
    return clean({k: c*v for k, v in f.items()})

def projection(k: tuple[int, int, int], v: sp.Matrix) -> sp.Matrix:
    kv = Vec(k)
    return Z if k == (0, 0, 0) else v-kv*(kv.dot(v))/kv.dot(kv)

def leray(f: Field) -> Field:
    return clean({k: projection(k, v) for k, v in f.items()})

def deriv(j: int, f: Field) -> Field:
    return clean({k: I*k[j]*v for k, v in f.items()})

def lap(f: Field) -> Field:
    return clean({k: -sum(x*x for x in k)*v for k, v in f.items()})

def curl(f: Field) -> Field:
    return clean({k: I*Vec(k).cross(v) for k, v in f.items()})

def cross(f: Field, g: Field) -> Field:
    out: Field = {}
    for k, a in f.items():
        for l, b in g.items():
            p = tuple(x+y for x, y in zip(k, l))
            out[p] = out.get(p, Z) + a.cross(b)
    return clean(out)

def pi(u: Field, a: Field) -> Field:
    return leray(cross(a, curl(u)))

def bracket(f: Field, g: Field) -> Field:
    out: Field = {}
    for k, a in f.items():
        for l, b in g.items():
            p = tuple(x+y for x, y in zip(k, l))
            out[p] = out.get(p, Z) + I*(a.dot(Vec(l))*b-b.dot(Vec(k))*a)
    return clean(out)

def M(u: Field, w: Field) -> Field:
    return pi(w, u)

def J(u: Field, a: Field) -> Field:
    return add(M(u, a), pi(u, a))

def Jstar(u: Field, a: Field) -> Field:
    return add(bracket(u, a), scale(-1, pi(u, a)))

def sinfield(k: tuple[int, int, int], v: list[int]) -> Field:
    return {k: -I*Vec(v)/2, tuple(-x for x in k): I*Vec(v)/2}

def assert_zero(name: str, f: Field) -> None:
    assert not clean(f), (name, clean(f))
    results.append('PASS: '+name)

# Universal transverse-symbol identities (n is any nonzero formal vector).
n = Vec(sp.symbols('n1 n2 n3', real=True))
p = Vec(sp.symbols('p1 p2 p3', real=True))
q = Vec(sp.symbols('q1 q2 q3', real=True))

def C(w: sp.Matrix) -> sp.Matrix:
    return sp.Matrix.hstack(*(sp.eye(3)[:, j].cross(w) for j in range(3)))

Pn = sp.eye(3)-n*n.T/(n.dot(n))
for name, matrix in [
    ('universal transverse symbol', Pn*C(p)*Pn-(n.dot(p)/n.dot(n))*C(n)),
    ('universal leading-symbol commutation',
     Pn*C(p)*Pn*C(q)*Pn-Pn*C(q)*Pn*C(p)*Pn),
]:
    assert matrix.applyfunc(sp.simplify) == sp.zeros(3), name
    results.append('PASS: '+name)

u = sinfield((0, 1, 0), [1, 0, 0])
w = sinfield((0, 0, 1), [0, 1, 0])
a = {(1, 0, 0): Vec([0, 0, 1])}
comm = add(pi(u, pi(w, a)), scale(-1, pi(w, pi(u, a))))
expected = {(1, e, d): Vec([sp.Rational(1, 6), -sp.Rational(e, 12), -sp.Rational(d, 12)])
            for e in (-1, 1) for d in (-1, 1)}
assert_zero('explicit nonzero commutator coefficients', add(comm, scale(-1, expected)))
assert comm
assert_zero('coadjoint drift of the witness source vanishes', M(u, w))

sources = [u, w, add(u, scale(2, w)), sinfield((1, 1, 0), [1, -1, 0])]
tests = [a, sinfield((1, 0, 1), [1, 2, -1])]
for k, source in enumerate(sources):
    for l, test in enumerate(tests):
        lhs0 = add(M(u, pi(source, test)), pi(source, bracket(u, test)))
        rhs0 = pi(M(u, source), test)
        assert_zero(f'coadjoint naturality {k},{l}', add(lhs0, scale(-1, rhs0)))
        lhs1 = add(J(u, pi(source, test)), pi(source, Jstar(u, test)))
        defect = add(pi(u, pi(source, test)), scale(-1, pi(source, pi(u, test))))
        assert_zero(f'tangent residual {k},{l}', add(lhs1, scale(-1, add(rhs0, defect))))
        diff = add(lap(pi(source, test)), pi(source, lap(test)))
        for j in range(3):
            diff = add(diff, scale(-2, deriv(j, pi(source, deriv(j, test)))))
        assert_zero(f'common-noise Laplacian identity {k},{l}',
                    add(diff, scale(-1, pi(lap(source), test))))

# Exact high-frequency witness for several arbitrary-size indices, no cutoff.
for N in (1, 2, 3, 7, 19):
    aN = {(N, 0, 0): Vec([0, 0, 1])}
    kN = add(pi(u, pi(w, aN)), scale(-1, pi(w, pi(u, aN))))
    want = {(N, e, d): Vec([sp.Rational(1, 2*(N*N+2)),
                           -sp.Rational(N*e, 4*(N*N+2)),
                           -sp.Rational(N*d, 4*(N*N+2))])
            for e in (-1, 1) for d in (-1, 1)}
    assert_zero(f'high-frequency witness N={N}', add(kN, scale(-1, want)))
    norm2 = sp.simplify(sum((v.conjugate().T*v)[0] for v in kN.values()))
    assert norm2 == sp.Rational(1, 2*(N*N+2))
    results.append(f'PASS: norm-squared ratio N={N}: {norm2}')

report = '\n'.join(results) + f'\n\n{len(results)} exact checks passed.\n'
report += ('No Fourier truncation was used. No Agda/Lean compiler, stochastic\n'
           'simulation, global continuation test, or RH certificate was run.\n')
Path(__file__).with_name('check_results.txt').write_text(report)
print(report)
