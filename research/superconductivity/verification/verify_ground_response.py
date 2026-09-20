#!/usr/bin/env python3
"""Exact rational controls for the ground-kernel and density-response derivations.
These finite controls supplement the general written proofs; they are not a
thermodynamic calculation or a proof-assistant build.
"""
from __future__ import annotations
import itertools as it
import json, math, time
from pathlib import Path
import sympy as s

checks=[]
def check(name, condition):
    if not condition: raise AssertionError(name)
    checks.append(name)
    print('PASS', name, flush=True)

def zero(A): return all(v == 0 for v in A)
def dg(A, k):
    """Number-conserving second quantization of A on wedge^k C^q."""
    q=A.rows
    masks=[sum(1 << j for j in c) for c in it.combinations(range(q),k)]
    loc={b:i for i,b in enumerate(masks)}
    out=s.MutableSparseMatrix(len(masks),len(masks),{})
    for col,mask in enumerate(masks):
        for b in range(q):
            if not (mask >> b) & 1: continue
            mid=mask ^ (1<<b)
            sg1=(-1)**((mask & ((1<<b)-1)).bit_count())
            for a in range(q):
                v=A[a,b]
                if not v or (mid >> a) & 1: continue
                sg2=(-1)**((mid & ((1<<a)-1)).bit_count())
                out[loc[mid|(1<<a)],col]+=v*sg1*sg2
    return s.ImmutableSparseMatrix(out)

def frame(L):
    W=s.zeros(2*L,L)
    for r in range(L):
        for j,sg in [(0,1),(1,-1)]:
            W[2*r+j,r]=s.Rational(1,2)
            W[2*r+j,(r-1)%L]=sg*s.Rational(1,2)
    return W

def bipair(F,M):
    """Coefficient of u in det[(I+uF)[I,J]], i.e.
    B_F eta^(M-1) up to the common phase and (M-1)! factor.
    Uses derivatives of minors by multilinearity, avoiding inverse matrices.
    """
    n=F.rows
    subsets=list(it.combinations(range(n),M))
    out=[]
    for I in subsets:
        for J in subsets:
            a=s.eye(n).extract(I,J)
            b=F.extract(I,J)
            val=0
            for c in range(M):
                mat=a.copy();mat[:,c]=b[:,c];val+=mat.det()
            out.append(val)
    return s.Matrix(out)

def norm_eta(M,n): return s.binomial(n,M) # minors of I, without M! prefactor

def connected_components(S):
    left=set(range(S.rows)); comps=[]
    while left:
        start=left.pop(); seen={start}; stack=[start]
        while stack:
            i=stack.pop()
            nb={j for j in left if S[i,j]!=0}
            left-=nb;seen|=nb;stack.extend(nb)
        comps.append(seen)
    return comps

def main():
    start=time.monotonic();n=3; W=frame(n);P=W*W.T;p=s.Rational(1,2)
    A=[W.row(i).T*W.row(i) for i in range(W.rows)]
    S=P.applyfunc(lambda x:x*x)
    check('frame isometry', W.T*W==s.eye(n))
    check('projector and uniform diagonal',P*P==P and set(P.diagonal())=={p})
    check('connected overlap',len(connected_components(S))==1)
    check('rank-one resolution',sum(A,s.zeros(n))==s.eye(n) and all(a*a==p*a for a in A))
    check('overlap Gram',s.Matrix([[s.trace(a*b) for b in A] for a in A])==S)
    check('overlap row sum',S*s.ones(2*n,1)==p*s.ones(2*n,1))
    # Lie closure of the rank-one generators, exact over Q.
    lie=[]; vecs=[]
    def insert(B):
        v=s.Matrix(list(B));cand=s.Matrix.hstack(*(vecs+[v]))
        if cand.rank()>len(vecs):lie.append(B);vecs.append(v);return True
        return False
    for a in A:insert(a)
    changed=True
    while changed:
        changed=False
        for a,b in it.combinations(list(lie),2):
            if insert(a*b-b*a):changed=True
    check('rank-one generators span gl(3) under Lie closure',len(lie)==n*n)
    # Entire projected Fock space, by spin-number sectors.
    U=s.Rational(3);Delta=s.Rational(5)
    for ku in range(n+1):
        for kd in range(n+1):
            du=math.comb(n,ku);dd=math.comb(n,kd)
            generators=[s.kronecker_product(dg(a,ku),s.eye(dd))-s.kronecker_product(s.eye(du),dg(a.T,kd)) for a in A]
            stacked=s.Matrix.vstack(*generators)
            nullity=du*dd-stacked.rank()
            check(f'complete common kernel ({ku},{kd})', nullity==(1 if ku==kd else 0))
    # One pair-deformation subspace and its induced metric at all fillings.
    Fs=[]
    for a,b in it.product(range(n),repeat=2):
        F=s.zeros(n);F[a,b]=1;Fs.append(F)
    LF=lambda F:U*(p*F-sum((a*F*a for a in A),s.zeros(n)))
    for M in range(1,n+1):
        d=math.comb(n,M); Id=s.eye(d)
        H0=s.zeros(d*d)
        for a in A:
            g=s.kronecker_product(dg(a,M),Id)-s.kronecker_product(Id,dg(a.T,M))
            H0+=U*g*g/2
        maps=[bipair(F,M) for F in Fs]
        aa=s.binomial(n-2,M-1);bb=s.binomial(n-2,M-2)
        check(f'pair deformation intertwiner M={M}',all(H0*v==bipair(LF(F),M) for F,v in zip(Fs,maps)))
        check(f'pair deformation metric M={M}',all((maps[i].T*maps[j])[0]==aa*s.trace(Fs[i].T*Fs[j])+bb*s.trace(Fs[i])*s.trace(Fs[j]) for i in range(n*n) for j in range(n*n)))
        eta=bipair(s.eye(n),M)/M
        V=s.Matrix.hstack(*[(s.kronecker_product(dg(a,M),Id)+s.kronecker_product(Id,dg(a.T,M))-2*s.Rational(M,n)*p*s.eye(d*d))*eta for a in A])
        kappa=4*s.Rational(M*(n-M),n*(n-1))
        target=kappa*(S-(p*p/n)*s.ones(2*n))
        check(f'projected density equal-time covariance M={M}',V.T*V==s.binomial(n,M)*target)
        Dsite=U*(p*s.eye(2*n)-S)
        check(f'projected density invariant dynamical sector M={M}',H0*V==V*Dsite)
    # Full parent in fixed-spin sectors on all six physical orbitals.
    for M in [1,2]:
        q=P.rows;subs=list(it.combinations(range(q),M));d=len(subs);Id=s.eye(d)
        Q=s.eye(q)-P
        Hp=Delta*(s.kronecker_product(dg(Q,M),Id)+s.kronecker_product(Id,dg(Q.T,M)))
        Ap=[P[:,i]*P[i,:] for i in range(q)]
        for a in Ap:Hp-=U*s.kronecker_product(dg(a,M),dg(a.T,M))
        E=-U*p*M
        Hs=Hp-E*s.eye(d*d)
        psi=s.Matrix([P.extract(I,J).det() for I in subs for J in subs])
        Nrm=s.binomial(n,M)
        check(f'full-parent norm M={M}',(psi.T*psi)[0]==Nrm)
        check(f'full-parent exact ground M={M}',zero(Hs*psi))
        Nu=[];Np=[]
        for i in range(q):
            e=s.zeros(q);e[i,i]=1
            nt=s.kronecker_product(dg(e,M),Id)+s.kronecker_product(Id,dg(e,M))
            nb=s.kronecker_product(dg(Ap[i],M),Id)+s.kronecker_product(Id,dg(Ap[i].T,M))
            mean=2*s.Rational(M,n)*p
            Nu.append((nt-nb)*psi)
            Np.append((nb-mean*s.eye(d*d))*psi)
        Vu=s.Matrix.hstack(*Nu);Vp=s.Matrix.hstack(*Np)
        kappa=4*s.Rational(M*(n-M),n*(n-1));nu=s.Rational(M,n)
        check(f'upper transition single exact energy M={M}',Hs*Vu==(Delta+U*p)*Vu)
        check(f'physical interband weight M={M}',Vu.T*Vu==Nrm*2*nu*(p*s.eye(q)-S))
        check(f'lower/upper density channels orthogonal M={M}',zero(Vp.T*Vu))
        check(f'lower physical embedding dynamics M={M}',Hs*Vp==Vp*(U*(p*s.eye(q)-S)))
        check(f'full equal-time density formula M={M}',(Vu+Vp).T*(Vu+Vp)==Nrm*(kappa*(S-p*p/n*s.ones(q))+2*nu*(p*s.eye(q)-S)))
        check(f'full first density moment M={M}',(Vu+Vp).T*Hs*(Vu+Vp)==Nrm*(kappa*S*U*(p*s.eye(q)-S)+2*nu*(Delta+U*p)*(p*s.eye(q)-S)))
    # 3D compact frame uses rational tensors: no sampling or float threshold.
    W3=s.kronecker_product(W,W,W);P3=W3*W3.T;S3=P3.applyfunc(lambda x:x*x)
    check('three-dimensional isometry',W3.T*W3==s.eye(n**3))
    check('three-dimensional diagonal',set(P3.diagonal())=={s.Rational(1,8)})
    check('three-dimensional overlap connected',len(connected_components(S3))==1)
    check('three-dimensional overlap tensor factorization',S3==s.kronecker_product(S,S,S))
    # Countercase: disconnected components have more than the global eta tower.
    Wd=s.diag(1,1);Ad=[s.diag(1,0),s.diag(0,1)]
    md=[s.kronecker_product(a,s.eye(2))-s.kronecker_product(s.eye(2),a.T) for a in Ad]
    check('disconnected one-pair kernel has two components',4-s.Matrix.vstack(*md).rank()==2)
    report={'status':'passed','assertions':len(checks),'checks':checks,'seconds':time.monotonic()-start,'scope':'Exact finite rational controls for written general proofs. No finite-temperature or proof-assistant claim.'}
    target=Path(__file__).resolve().parent/'ground_response_results.json';target.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='checks'},indent=2))

if __name__=='__main__':main()
