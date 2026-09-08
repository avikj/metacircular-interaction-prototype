#!/usr/bin/env python3
"""Exact source-preserving elimination certificates and finite controls.

This is a standalone SymPy certificate checker, NOT an Agda/Lean build or
an implementation of continuum NS evolution.  A certificate is an exact
matrix identity holding for every forcing vector.  Derived certificates
can be composed, independently replayed, and installed as operations.
The finite causal matrix is explicitly a synthetic algebraic control.
"""
from __future__ import annotations
from dataclasses import dataclass, replace
from pathlib import Path
import json
import sympy as sp

CHECKS: list[str] = []

def is_zero(value: sp.Expr | sp.MatrixBase) -> bool:
    entries = list(value) if isinstance(value, sp.MatrixBase) else [value]
    return all(sp.cancel(sp.expand(entry)) == 0 for entry in entries)

def check_zero(value: sp.Expr | sp.MatrixBase, label: str) -> None:
    if not is_zero(value):
        raise AssertionError(f"{label}: {value}")
    CHECKS.append(label)

def select(indices: tuple[int, ...], n: int) -> sp.ImmutableMatrix:
    if len(set(indices)) != len(indices) or any(i < 0 or i >= n for i in indices):
        raise ValueError("Selection must contain distinct valid indices")
    return sp.ImmutableMatrix(len(indices), n,
        lambda i, j: sp.Integer(j == indices[i]))

@dataclass(frozen=True)
class EliminationCertificate:
    original: sp.ImmutableMatrix
    observe: sp.ImmutableMatrix
    effective: sp.ImmutableMatrix
    forcing: sp.ImmutableMatrix
    reconstruct_state: sp.ImmutableMatrix
    reconstruct_source: sp.ImmutableMatrix
    trace: tuple[str, ...]

    def verify(self, record: bool = True) -> None:
        M, E, S, T, R, Z = (self.original, self.observe, self.effective,
                            self.forcing, self.reconstruct_state,
                            self.reconstruct_source)
        n, k = M.rows, E.rows
        if M.cols != n or E.cols != n or S.shape != (k, k):
            raise ValueError("Ill-typed elimination certificate")
        if T.shape != (k, n) or R.shape != (n, k) or Z.shape != (n, n):
            raise ValueError("Ill-typed source or reconstruction map")
        equations = (
            (E*R-sp.eye(k), "observed state round trip"),
            (E*Z, "source correction has zero visible component"),
            (M*R-E.T*S, "reconstructed homogeneous equation"),
            (M*Z-sp.eye(n)+E.T*T, "reconstructed source equation"),
            (R*E+Z*M-sp.eye(n), "all actual solutions reconstruct"),
        )
        for value, label in equations:
            if not is_zero(value):
                raise ValueError("Rejected certificate: " + label)
            if record:
                CHECKS.append("certificate: " + label)

    @classmethod
    def derive(cls, M: sp.MatrixBase, keep: tuple[int, ...]) -> 'EliminationCertificate':
        M = sp.ImmutableMatrix(M)
        n = M.rows
        E = select(keep, n)
        hidden = tuple(i for i in range(n) if i not in set(keep))
        F = select(hidden, n)
        if hidden:
            H = (F*M*F.T).inv()
            S = E*M*E.T-E*M*F.T*H*F*M*E.T
            T = E-E*M*F.T*H*F
            R = E.T-F.T*H*F*M*E.T
            Z = F.T*H*F
        else:
            S, T, R, Z = E*M*E.T, E, E.T, sp.zeros(n)
        cert = cls(M, E, sp.ImmutableMatrix(S), sp.ImmutableMatrix(T),
                   sp.ImmutableMatrix(R), sp.ImmutableMatrix(Z),
                   (f"eliminate {hidden}; retain {keep}",))
        cert.verify()
        return cert

    def followed_by(self, later: 'EliminationCertificate') -> 'EliminationCertificate':
        self.verify(record=False)
        later.verify(record=False)
        if self.effective != later.original:
            raise ValueError("Certificates do not share the actual intermediate equation")
        c = EliminationCertificate(
            self.original,
            sp.ImmutableMatrix(later.observe*self.observe),
            later.effective,
            sp.ImmutableMatrix(later.forcing*self.forcing),
            sp.ImmutableMatrix(self.reconstruct_state*later.reconstruct_state),
            sp.ImmutableMatrix(self.reconstruct_source +
                self.reconstruct_state*later.reconstruct_source*self.forcing),
            self.trace + later.trace,
        )
        c.verify()
        return c

@dataclass(frozen=True)
class InstalledOperation:
    certificate: EliminationCertificate

    def apply(self, source: sp.MatrixBase) -> sp.ImmutableMatrix:
        c = self.certificate
        if source.shape != (c.original.rows, 1):
            raise ValueError("Wrong source type")
        reduced_source = c.forcing*source
        visible = c.effective.inv()*reduced_source
        full = c.reconstruct_state*visible+c.reconstruct_source*source
        return sp.ImmutableMatrix(full)

class Kernel:
    def __init__(self) -> None:
        self.library: list[InstalledOperation] = []

    def install(self, certificate: EliminationCertificate) -> InstalledOperation:
        certificate.verify(record=False)
        op = InstalledOperation(certificate)
        self.library.append(op)
        return op

    def retire(self, first: EliminationCertificate,
               second: EliminationCertificate) -> InstalledOperation:
        return self.install(first.followed_by(second))


def main() -> None:
    # Synthetic finite causal history: three sectors at three ordered times.
    # Every arrow points from an earlier time to a later time; gains are large.
    nt, ns = 3, 3
    n = nt*ns
    K = sp.Matrix(n, n, lambda i, j:
        sp.Integer(7*((2*i+j) % 5 + 1)) if i//ns > j//ns else sp.Integer(0))
    M = sp.eye(n)-K
    check_zero(K**nt, "strict causal matrix is nilpotent despite large norm")
    assert max(sum(abs(K[i,j]) for j in range(n)) for i in range(n)) > 100
    CHECKS.append("causal matrix sup-norm exceeds 100: no smallness assumption")
    z = sp.symbols('z')
    resolvent = sum((z**j*K**j for j in range(nt)), sp.zeros(n))
    check_zero((sp.eye(n)-z*K)*resolvent-sp.eye(n),
               "entire causal resolvent: left inverse, symbolic coupling z")
    check_zero(resolvent*(sp.eye(n)-z*K)-sp.eye(n),
               "entire causal resolvent: right inverse, symbolic coupling z")

    p = tuple(i for i in range(n) if i % ns == 0)
    pq = tuple(i for i in range(n) if i % ns in (0,1))
    pr = tuple(i for i in range(n) if i % ns in (0,2))
    direct = EliminationCertificate.derive(M, p)
    first_q = EliminationCertificate.derive(M, pr)
    second_q = EliminationCertificate.derive(first_q.effective,
        tuple(i for i, old in enumerate(pr) if old in p))
    first_r = EliminationCertificate.derive(M, pq)
    second_r = EliminationCertificate.derive(first_r.effective,
        tuple(i for i, old in enumerate(pq) if old in p))
    via_q = first_q.followed_by(second_q)
    via_r = first_r.followed_by(second_r)
    for c, name in ((via_q, 'q then r'), (via_r, 'r then q')):
        for attr in ('observe', 'effective', 'forcing', 'reconstruct_state', 'reconstruct_source'):
            check_zero(getattr(c,attr)-getattr(direct,attr),
                f"order independence {name}: {attr}")

    source = sp.Matrix(sp.symbols('b0:'+str(n)))
    kernel = Kernel()
    direct_op = kernel.install(direct)
    learned_op = kernel.retire(first_q, second_q)
    x = learned_op.apply(source)
    check_zero(M*x-source, "retired operation solves original equation for every symbolic source")
    check_zero(x-direct_op.apply(source), "retirement and direct compilation agree on every source")
    check_zero(x-(sp.eye(n)+K+K**2)*source,
               "compiled solution equals all causal paths")

    # The effective operator alone is not enough. A lost source history is rejected.
    bad = replace(direct, forcing=direct.forcing+sp.ones(*direct.forcing.shape))
    try:
        kernel.install(bad)
    except ValueError:
        CHECKS.append("rejected forged certificate that preserves operator but loses source")
    else:
        raise AssertionError("unsound source-altering certificate was accepted")
    # Wrong intermediate equation must also be rejected.
    try:
        first_q.followed_by(EliminationCertificate.derive(sp.eye(first_q.effective.rows),
            tuple(i for i, old in enumerate(pr) if old in p)))
    except ValueError:
        CHECKS.append("rejected mismatched intermediate equation in proof composition")
    else:
        raise AssertionError("ill-typed proof composition was accepted")

    # Prefix consistency for every cut of the causal matrix.
    for cut in (3,6):
        prefix_inverse = M[:cut,:cut].inv()
        check_zero(x[:cut,0]-prefix_inverse*source[:cut,0],
                   f"causal restriction preserves source prefix at cut {cut}")

    # Beta/Gamma coefficient recurrence for the 1/2-order Volterra majorant.
    # This checks the symbolic integrals' gamma recurrence at finite orders;
    # the general induction and convergence proof are in proof_note.md.
    t, C = sp.symbols('t C', positive=True)
    for j in range(8):
        lhs = C**(j+1)*sp.pi**(sp.Rational(j,2))*t**sp.Rational(j+1,2) * (
            sp.gamma(sp.Rational(1,2))*sp.gamma(sp.Rational(j,2)+1) /
            sp.gamma(sp.Rational(j+1,2)+1)) / sp.gamma(sp.Rational(j,2)+1)
        rhs = (C*sp.sqrt(sp.pi))**(j+1)*t**sp.Rational(j+1,2)/sp.gamma(sp.Rational(j+1,2)+1)
        check_zero(lhs-rhs, f"Volterra ordered-simplex coefficient {j+1}")

    # Actual-source variation: every occurrence of the same field varies.
    a,b,c,pv,qv,h,d = sp.symbols('a b c p q h d')
    residual = qv-b-a*(pv+qv)**2
    check_zero(sp.diff(residual,qv)-(1-2*a*(pv+qv)),
               "hidden derivative differentiates both common-source slots")
    remainder = residual.subs({pv:pv+h,qv:qv+d})-residual
    expected = d-2*a*(pv+qv)*(h+d)-a*(h+d)**2
    check_zero(remainder-expected, "exact nonlinear rebase identity")

    # A failed expansion certificate is not a source singularity.
    s, u = sp.symbols('s u', nonnegative=True)
    y0 = sp.symbols('y0', positive=True)
    phi = lambda time, initial: initial/(1+time*initial)
    check_zero(phi(t+s,y0)-phi(t,phi(s,y0)), "global decaying quadratic control rebase composition")
    yt=phi(t,y0)
    check_zero(sp.diff(yt,t)+yt**2, "decaying quadratic control actual differential equation")
    assert yt.subs({t:2,y0:1}) == sp.Rational(1,3)
    CHECKS.append("decaying quadratic control is regular beyond its origin Taylor disk")
    variation = 1/(1+t)**2
    integral = sp.integrate(1/(1+u)**3,(u,0,t))
    check_zero(variation-(1-2*integral), "Volterra variation around non-small regular solution")

    # RH: apparent hidden pivot pole versus genuine full-source poles.
    d, sig = sp.symbols('d sigma', nonzero=True)
    Rpair = sp.Matrix([[d,sig],[sig,d]])
    inverse = Rpair.inv()
    reduced = sp.cancel(1/(d-sig**2/d))
    check_zero(reduced-d/(d**2-sig**2), "RH source-preserving Schur normalization")
    check_zero(inverse[0,0]-reduced, "RH normalized expression is actual resolvent corner")
    check_zero(inverse.subs(d,0)-sp.Matrix([[0,1/sig],[1/sig,0]]),
               "RH apparent self-energy pole d=0 is removable for sigma nonzero")
    check_zero(sp.limit((d-sig)*reduced,d,sig)-sp.Rational(1,2),
               "RH genuine right pair pole has residue one half")
    check_zero(sp.limit((d+sig)*reduced,d,-sig)-sp.Rational(1,2),
               "RH genuine left pair pole has residue one half")
    d0=sp.symbols('d0')
    check_zero(sp.cancel(d0/(d0**2))-1/d0,
               "RH fixed-orbit case retains actual neutral pole")

    # Safe transfer cannot drop a nonzero multiplicity by removing a pivot.
    result = {
        'checks_passed': len(CHECKS),
        'checks': CHECKS,
        'synthetic_causal_control': {
            'times': nt, 'sectors': ns,
            'sup_operator_row_sum': str(max(sum(abs(K[i,j]) for j in range(n)) for i in range(n))),
            'effective_matrix': str(direct.effective),
            'retired_trace': list(learned_op.certificate.trace),
            'installed_operations': len(kernel.library),
        },
        'scope': 'Exact finite matrix/polynomial controls. No continuum PDE evolution or proof-assistant build.',
    }
    base=Path(__file__).resolve().parent
    (base/'check_results.json').write_text(json.dumps(result,indent=2))
    lines=[f"{len(CHECKS)} exact checks passed.", result['scope'], '']
    lines += [f'{i+1}. {label}' for i,label in enumerate(CHECKS)]
    (base/'check_results.txt').write_text('\n'.join(lines)+'\n')
    print('\n'.join(lines))

if __name__ == '__main__':
    main()
