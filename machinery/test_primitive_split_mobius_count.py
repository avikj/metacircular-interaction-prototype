import unittest
from functools import reduce
from itertools import product
from math import gcd

def mobius(n):
    p=2; sign=1; m=n
    while p*p<=m:
        if m%p==0:
            m//=p; sign=-sign
            if m%p==0:return 0
            while m%p==0:m//=p
        p+=1
    if m>1:sign=-sign
    return sign
def primitive(v):return reduce(gcd,v)==1
def brute(D,C):
    if D*C%2:return 0
    return sum(1 for x in product(range(C+1),repeat=D)
               if sum(x)*2==D*C and primitive(x) and primitive(tuple(C-a for a in x)))
def formula(D,C):
    if D*C%2:return 0
    target=D*C//2; total=0
    for d in range(1,C+1):
      for e in range(1,C+1):
        vals=[a for a in range(C+1) if a%d==0 and (C-a)%e==0]
        counts=[0]*(target+1); counts[0]=1
        for _ in range(D):
          nxt=[0]*(target+1)
          for s,c in enumerate(counts):
            for a in vals:
              if s+a<=target:nxt[s+a]+=c
          counts=nxt
        total+=mobius(d)*mobius(e)*counts[target]
    return total

class PrimitiveSplitMobiusCountTests(unittest.TestCase):
 def test_formula_against_fibers(self):
  for D in range(2,5):
   for C in range(1,7):self.assertEqual(formula(D,C),brute(D,C))
 def test_prior_seven(self):self.assertEqual(formula(3,2),7)
 def test_crt_false_control(self):
  C,d,e=3,2,2
  self.assertNotEqual(C%gcd(d,e),0)
  self.assertEqual([a for a in range(C+1) if a%d==0 and (C-a)%e==0],[])

if __name__=='__main__':unittest.main()
