import unittest
from math import gcd

def accepts(R,Q,C,S): return gcd(R,S)==1 and gcd(Q,C-S)==1

class OneStepSplitQuotientTests(unittest.TestCase):
 def test_exact_bit(self):
  C,S=6,1
  classes={True:[],False:[]}
  for R in (1,2,3,5,6):
   for Q in (1,2,3,5,6):classes[accepts(R,Q,C,S)].append((R,Q))
  self.assertTrue(classes[True] and classes[False])
 def test_distinct_histories_same_language(self):
  self.assertTrue(accepts(1,1,6,1))
  self.assertTrue(accepts(5,1,6,1))
 def test_suffix_separates_bits(self):
  self.assertNotEqual(accepts(1,1,6,1),accepts(1,5,6,1))

if __name__=='__main__':unittest.main()
