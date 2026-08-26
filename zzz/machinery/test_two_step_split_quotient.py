import unittest
from math import gcd

def mask(R,Q,C,S):
 lo=max(0,S-C); hi=min(C,S)
 return tuple(gcd(R,a,S)==1 and gcd(Q,C-a,C-S+a)==1 for a in range(lo,hi+1))

class TwoStepSplitQuotientTests(unittest.TestCase):
 def test_mask_matches_suffix_acceptance(self):
  C,S=6,7
  for R in (1,2,3,5,6):
   for Q in (1,2,3,5,6):
    actual=[]
    for a in range(max(0,S-C),min(C,S)+1):
     b=S-a
     actual.append(gcd(R,a,b)==1 and gcd(Q,C-a,C-b)==1)
    self.assertEqual(mask(R,Q,C,S),tuple(actual))
 def test_multiple_classes(self):
  masks={mask(R,Q,3,2) for R in (1,2,3,5,6) for Q in (1,2,3,5,6)}
  self.assertGreater(len(masks),2)
 def test_distinct_masks_have_witness_position(self):
  a=mask(1,1,3,2); b=mask(1,2,3,2)
  self.assertNotEqual(a,b)
  self.assertTrue(any(x!=y for x,y in zip(a,b)))

if __name__=='__main__':unittest.main()
