from fractions import Fraction as F
from math import comb

def carry_matrix(n,b):
    """Holte's carries chain: adding n numbers in base b.
       state = carry value in {0..n-1}. Exact."""
    # distribution of the sum of n iid uniform digits in [0,b)
    d=[1]
    for _ in range(n):
        nd=[0]*(len(d)+b-1)
        for i,v in enumerate(d):
            if v:
                for j in range(b): nd[i+j]+=v
        d=nd
    tot=b**n
    M=[[F(0)]*n for _ in range(n)]
    for c in range(n):
        for s,k in enumerate(d):
            if k: M[c][(c+s)//b]+=F(k,tot)
    return M

def eulerian(n,k): return sum((-1)**j*(k+1-j)**n*comb(n+1,j) for j in range(k+1))

def tv_profile(n,b,steps):
    fact=1
    for i in range(1,n+1): fact*=i
    pi=[F(eulerian(n,k),fact) for k in range(n)]
    M=carry_matrix(n,b)
    v=[F(0)]*n; v[0]=F(1)          # start: no carry (adding from the bottom digit)
    out=[]
    for k in range(1,steps+1):
        v=[sum(v[i]*M[i][j] for i in range(n)) for j in range(n)]
        tv=sum(abs(v[j]-pi[j]) for j in range(n))/2
        out.append((k,tv))
    return out

for n,b,steps in ((52,2,14),(52,10,6),(10,2,10),(100,2,16)):
    print(f"\nadding {n} numbers in base {b}  (= {b}-shuffling {n} cards)")
    print(f"  digit   total-variation distance from Eulerian")
    for k,tv in tv_profile(n,b,steps):
        bar='#'*int(float(tv)*40)
        print(f"   {k:>3}    {float(tv):.6f}  {bar}")
