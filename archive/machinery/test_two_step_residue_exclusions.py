import unittest
from math import gcd
def mask(R,Q,C,S):
 lo=max(0,S-C);hi=min(C,S)
 return tuple(gcd(R,a,S)==1 and gcd(Q,C-a,C-S+a)==1 for a in range(lo,hi+1))

def primes(n):
 p=2; out=[]
 while p*p<=n:
  if n%p==0:
   out.append(p)
   while n%p==0:n//=p
  p+=1
 if n>1:out.append(n)
 return out
def factored(R,Q,C,S):
 lo=max(0,S-C);hi=min(C,S); P=primes(gcd(R,S));Qp=primes(gcd(Q,2*C-S))
 return tuple(not(any(a%p==0 for p in P) or any((C-a)%p==0 for p in Qp))
              for a in range(lo,hi+1))

class TwoStepResidueExclusionsTests(unittest.TestCase):
 def test_factorization(self):
  for C in range(1,10):
   for S in range(2*C+1):
    for R in range(1,15):
     for Q in range(1,15):self.assertEqual(factored(R,Q,C,S),mask(R,Q,C,S))
 def test_finite_interval_redundancy(self):
  # I={1}; child-side exclusions for 2 and 3 both miss it.
  self.assertEqual(mask(2,1,1,1),mask(3,1,1,1))

if __name__=='__main__':unittest.main()
