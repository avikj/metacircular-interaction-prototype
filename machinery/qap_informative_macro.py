"""Exact finite-linear compilation of projector leakage.

Column vectors are used.  Given an idempotent P and Q=I-P, factor
R=QAP=B C through im(R).  The compiled body PAP+BC is certified equal to AP.
All arithmetic is Fraction arithmetic.
"""
from fractions import Fraction as F


def M(a): return [[F(x) for x in r] for r in a]
def eye(n): return [[F(i == j) for j in range(n)] for i in range(n)]
def add(a,b): return [[x+y for x,y in zip(r,s)] for r,s in zip(a,b)]
def sub(a,b): return [[x-y for x,y in zip(r,s)] for r,s in zip(a,b)]
def mul(a,b): return [[sum((a[i][k]*b[k][j] for k in range(len(b))), F(0)) for j in range(len(b[0]))] for i in range(len(a))]
def cols(a, js): return [[r[j] for j in js] for r in a]


def rref(a):
    a=M(a); rows=len(a); columns=len(a[0]); piv=[]; i=0
    for j in range(columns):
        k=next((k for k in range(i,rows) if a[k][j]),None)
        if k is None: continue
        a[i],a[k]=a[k],a[i]; z=a[i][j]; a[i]=[x/z for x in a[i]]
        for k in range(rows):
            if k!=i and a[k][j]:
                z=a[k][j]; a[k]=[x-z*y for x,y in zip(a[k],a[i])]
        piv.append(j); i+=1
        if i==rows: break
    return a,piv


def inverse(a):
    n=len(a); rr,piv=rref([r+s for r,s in zip(M(a),eye(n))])
    if piv[:n] != list(range(n)): raise ValueError("singular basis change")
    return [r[n:] for r in rr]


def solve_full_column_rank(b, r):
    """C with B C=R; B must have independent columns and R lie in im B."""
    n=len(b); k=len(b[0]) if b else 0; out=[]
    for j in range(len(r[0])):
        aug=[b[i]+[r[i][j]] for i in range(n)]
        rr,piv=rref(aug)
        if any(all(x==0 for x in row[:k]) and row[k] for row in rr):
            raise ValueError("column outside image")
        x=[F(0)]*k
        for i,p in enumerate(piv):
            if p<k: x[p]=rr[i][k]
        out.append(x)
    return [list(x) for x in zip(*out)] if k else []


def image_factor(r):
    """Chosen coordinate program B,C for the basis-free carrier im(r)."""
    _, piv=rref(r)  # pivot columns of R are an image basis
    b=cols(r,piv)
    c=solve_full_column_rank(b,r) if piv else []
    return b,c,piv


def compile_macro(p,a):
    n=len(p); q=sub(eye(n),p); leakage=mul(mul(q,a),p)
    b,c,piv=image_factor(leakage)
    body=add(mul(mul(p,a),p), mul(b,c) if b and c else [[F(0)]*n for _ in range(n)])
    target=mul(a,p)
    if mul(p,p)!=p: raise ValueError("P is not idempotent")
    if body!=target: raise AssertionError("certificate AP=PAP+BC failed")
    return {"image_matrix": leakage, "B": b, "C": c, "pivot_columns": piv,
            "body": body, "target": target}


def transport(p,a,cert,s):
    """Transport state coordinates x=S x'; carrier coordinates unchanged."""
    si=inverse(s)
    pp=mul(mul(si,p),s); aa=mul(mul(si,a),s)
    bp=mul(si,cert["B"]); cp=mul(cert["C"],s)
    body=add(mul(mul(pp,aa),pp),mul(bp,cp))
    assert body==mul(aa,pp)==mul(mul(si,cert["target"]),s)
    assert mul(bp,cp)==mul(mul(si,cert["image_matrix"]),s)
    return pp,aa,bp,cp,body
