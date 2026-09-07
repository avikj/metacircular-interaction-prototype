from fractions import Fraction as F
from math import comb
def eulerian(n,k): return sum((-1)**j*(k+1-j)**n*comb(n+1,j) for j in range(k+1))
def fct(n):
    r=1
    for i in range(1,n+1): r*=i
    return r

def digit_sum_dist(n,b):
    "exact counts of sum of n iid uniform digits in [0,b), by convolution"
    d=[1]
    for _ in range(n):
        nd=[0]*(len(d)+b-1)
        for i,v in enumerate(d):
            if v:
                for j in range(b): nd[i+j]+=v
        d=nd
    return d

def stationary(n,b):
    tot=b**n; ds=digit_sum_dist(n,b)
    M=[[F(0)]*n for _ in range(n)]
    for c in range(n):
        for s,k in enumerate(ds):
            if k: M[c][(c+s)//b]+=F(k,tot)
    A=[[M[j][i]-(F(1) if i==j else F(0)) for j in range(n)] for i in range(n)]
    A[-1]=[F(1)]*n; rhs=[F(0)]*(n-1)+[F(1)]
    for i in range(n):
        p=next(r for r in range(i,n) if A[r][i]!=0)
        A[i],A[p]=A[p],A[i]; rhs[i],rhs[p]=rhs[p],rhs[i]
        for r in range(n):
            if r!=i and A[r][i]!=0:
                f=A[r][i]/A[i][i]
                A[r]=[a-f*c for a,c in zip(A[r],A[i])]; rhs[r]-=f*rhs[i]
    return [rhs[i]/A[i][i] for i in range(n)]

print("adding n numbers, base b: stationary carry distribution vs Eulerian A(n,k)/n!\n")
allmatch=True
for n in range(2,9):
    eu=[F(eulerian(n,k),fct(n)) for k in range(n)]
    bases=[2,3,7,10,97,1000]
    res=[stationary(n,b)==eu for b in bases]
    allmatch &= all(res)
    print(f"n={n:>2}  A(n,k)/n! = {', '.join(str(e) for e in eu)}")
    print(f"      bases {bases} -> {'all EQUAL' if all(res) else res}")
print("\nevery case identical, base-independent:", allmatch)

# and the eigenvalues of the 'amazing matrix'
print("\neigen-structure check: powers of 1/b should appear")
from itertools import product
def charpoly_roots_hint(n,b):
    ds=digit_sum_dist(n,b); tot=b**n
    M=[[F(0)]*n for _ in range(n)]
    for c in range(n):
        for s,k in enumerate(ds):
            if k: M[c][(c+s)//b]+=F(k,tot)
    # trace of M^j vs sum of (1/b)^i
    tr=sum(M[i][i] for i in range(n))
    pred=sum(F(1,b**i) for i in range(n))
    return tr, pred
for n in (3,4,5,6):
    for b in (2,10):
        tr,pred=charpoly_roots_hint(n,b)
        print(f"  n={n} b={b}: trace={tr}   sum of 1,1/b,...,1/b^(n-1)={pred}   {'match' if tr==pred else 'DIFFER'}")
