"""How much does the sharp odd-support cage |z|<sqrt2 shrink the degree-10 box,
versus the generic Newman bound |z|<2 that F4..F9 actually used?

Bound (UNIT_PRODUCT_VIETA, Thm 1): for monic g of degree n with all roots in
|z| <= R and product of roots = +-1,
    |e_k| <= C(n-1,k) R^k + C(n-1,k-1) R^{k-n}.
Exact integer/rational arithmetic; the box count is the product of (2*floor+1).
"""
from fractions import Fraction as F
from math import comb, isqrt

def bound(n,k,R2num,R2den):
    """R = sqrt(R2num/R2den).  Return an exact rational upper bound on |e_k|
    by bounding R^k and R^(k-n) from above with exact rationals."""
    def powR(e):                      # R^e as an exact rational upper bound
        if e >= 0:
            q = F(R2num, R2den) ** (e // 2)
            if e % 2:                 # multiply by sqrt(R2num/R2den), round up
                # sqrt(a/b) <= (isqrt(a*b)+1)/b
                q *= F(isqrt(R2num*R2den)+1, R2den)
            return q
        else:
            q = F(R2den, R2num) ** ((-e) // 2)
            if (-e) % 2:
                q *= F(isqrt(R2den*R2num)+1, R2num)
            return q
    return comb(n-1,k)*powR(k) + comb(n-1,k-1)*powR(k-n)

def boxsize(n, R2num, R2den, label):
    tot = 1; widths=[]
    for k in range(1,n):
        b = bound(n,k,R2num,R2den)
        w = int(b)                     # floor
        widths.append(w)
        tot *= (2*w+1)
    print(f"  {label:<22} per-coefficient floors {widths}")
    return tot

print("degree-10 coefficient box, exact Vieta bounds\n")
loose  = boxsize(10, 4,1, "generic |z|<2")
sharp  = boxsize(10, 2,1, "odd-support |z|<sqrt2")
print(f"\n  generic box   {loose:,}")
print(f"  sharp box     {sharp:,}")
print(f"  shrink factor {F(loose,sharp)} = {float(F(loose,sharp)):.4g}x")

print("\nsame comparison at the degrees already certified:")
for n in (4,5,6,7,8,9,10,12):
    lo = 1; sh = 1
    for k in range(1,n):
        lo *= 2*int(bound(n,k,4,1))+1
        sh *= 2*int(bound(n,k,2,1))+1
    print(f"  deg {n:>2}:  generic {lo:>28,}   sharp {sh:>22,}   "
          f"shrink {float(F(lo,sh)):.4g}x")
