"""Independent audit of R0021 (cf-prime/opus-5, from the STATEMENT only).
Rebuilt from scratch: no import of exp53 or CONSTRAINT_ALGEBRA code."""
from fractions import Fraction as F
from itertools import product

E = list(product([1,-1], repeat=5))          # eps_1..eps_5

def mu(a,b,c,e):
    e1,e2,e3,e4,e5 = e
    val = (1 + a*(e1*e2*e3*e4 + e2*e3*e4*e5)
             + b*(e1*e3*e4*e5 + e1*e2*e3*e5)
             + c*(e1*e2*e4*e5))
    return F(val,32) if isinstance(val,int) else val/32

def nonneg(a,b,c):
    return all(mu(a,b,c,e) >= 0 for e in E)

def claimed_A(a,b,c):
    return (-1<=c<=1) and (2*abs(a) <= 1-c) and (2*abs(b) <= 1-c) and (2*(abs(a)+abs(b)) <= 1+c)

# ---- (A) region equivalence, exact rationals on a fine grid + boundary probes
den = 12
bad = []
for ai in range(-den,den+1):
    for bi in range(-den,den+1):
        for ci in range(-den,den+1):
            a,b,c = F(ai,den),F(bi,den),F(ci,den)
            if nonneg(a,b,c) != claimed_A(a,b,c):
                bad.append((a,b,c))
print("A: mismatches on grid 1/12 =", len(bad), bad[:3])

# ---- (B)/(C) zero-atom count
def zeros(a,b,c): return sum(1 for e in E if mu(a,b,c,e)==0)
t = F(1,3)
print("C: zeros at (1/3,1/3,1/3) =", zeros(t,t,t),
      "| mass =", sum(mu(t,t,t,e) for e in E),
      "| nonneg =", nonneg(t,t,t))

# max zeros over |c|<1 on the grid, among nonneg points
best = max(((zeros(F(ai,den),F(bi,den),F(ci,den)),(F(ai,den),F(bi,den),F(ci,den)))
            for ai in range(-den,den+1) for bi in range(-den,den+1) for ci in range(-den,den)
            if nonneg(F(ai,den),F(bi,den),F(ci,den))), key=lambda x:x[0])
print("B: max zeros with |c|<1 on grid =", best[0], "at", best[1])

# ---- (C) stationarity: prefix vs suffix 4-bit marginals
def marg(a,b,c,idx):
    m = {}
    for e in E:
        k = tuple(e[i] for i in idx)
        m[k] = m.get(k,F(0)) + mu(a,b,c,e)
    return m
pre, suf = marg(t,t,t,(0,1,2,3)), marg(t,t,t,(1,2,3,4))
print("C: prefix==suffix 4-marginals:", pre==suf)

# ---- (C) Walsh coefficients: odd-order and 2-point vanish; 4-point = (a,b,b,c,a)
def walsh(a,b,c,S):
    return sum(mu(a,b,c,e)*prod for e,prod in
               ((e, 1) for e in E)) if not S else \
           sum(mu(a,b,c,e)*__import__('math').prod(e[i] for i in S) for e in E)
from itertools import combinations
odd2_ok = all(walsh(t,t,t,S)==0 for k in (1,2,3,5) for S in combinations(range(5),k))
four = {S: walsh(t,t,t,S) for S in combinations(range(5),4)}
print("C: all odd-order and 2-point Walsh vanish:", odd2_ok)
print("C: 4-point Walsh coeffs =", [str(four[S]) for S in sorted(four)])

# ---- (D) the disputed step: flipping (e1,e5) on a zero atom
Z = [e for e in E if mu(t,t,t,e)==0]
flip15 = lambda e: (-e[0],e[1],e[2],e[3],-e[4])
stay = [e for e in Z if mu(t,t,t,flip15(e))==0]
print("D: zero atoms =", len(Z), "| zero atoms whose (e1,e5)-flip is ALSO zero =", len(stay))
print("D: of those, all have e1 = -e5:", all(e[0]==-e[4] for e in stay), stay[:4])
from fractions import Fraction as F
from itertools import product
E = list(product([1,-1], repeat=5))
def mu(a,b,c,e):
    e1,e2,e3,e4,e5 = e
    return (1 + a*(e1*e2*e3*e4+e2*e3*e4*e5) + b*(e1*e3*e4*e5+e1*e2*e3*e5) + c*(e1*e2*e4*e5))/32
def nonneg(a,b,c): return all(mu(a,b,c,e) >= 0 for e in E)
def zeros(a,b,c):  return sum(1 for e in E if mu(a,b,c,e)==0)
best=[]
for den in (6,12,24):
    hits=[]
    for ai in range(-den,den+1):
        for bi in range(-den,den+1):
            for ci in range(-den+1,den):          # |c| < 1 strictly
                a,b,c=F(ai,den),F(bi,den),F(ci,den)
                if nonneg(a,b,c):
                    z=zeros(a,b,c)
                    if z>=10: hits.append((z,a,b,c))
    mx=max(h[0] for h in hits)
    eqs={(abs(h[1]),abs(h[2]),h[3]) for h in hits if h[0]==mx}
    best.append((den,mx,sorted(str(x) for x in eqs)))
    print(f"den=1/{den}: max zeros with |c|<1 = {mx}; attained at |a|,|b|,c = {sorted(str(x) for x in eqs)}")
