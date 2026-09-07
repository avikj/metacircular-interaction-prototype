import unittest
from itertools import product
from math import gcd,lcm

def survives(d,e,r,S,C):
 return any(sum(xs)==S and all(x%d==0 and (C-x)%e==0 for x in xs)
            for xs in product(range(C+1),repeat=r))
def criterion(d,e,r,S,C):
 vals=[a for a in range(lcm(d,e)) if a%d==0 and (C-a)%e==0]
 if not vals:return False
 a=vals[0]; L=lcm(d,e); K=(C-a)//L
 return S>=r*a and (S-r*a)%L==0 and (S-r*a)//L<=r*K

class CoupledDivisorSurvivalTests(unittest.TestCase):
 def test_formula(self):
  for C in range(1,7):
   for r in range(1,4):
    for S in range(r*C+1):
     for d in range(1,7):
      for e in range(1,7):self.assertEqual(criterion(d,e,r,S,C),survives(d,e,r,S,C))
 def test_crt_false_control(self):
  self.assertFalse(criterion(2,2,2,2,3))

if __name__=='__main__':unittest.main()
