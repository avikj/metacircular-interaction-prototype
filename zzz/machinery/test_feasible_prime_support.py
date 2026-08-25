import unittest
from itertools import product

def survives(q,r,S,C,complement=False):
 return any(sum(xs)==S and all(((C-x) if complement else x)%q==0 for x in xs)
            for xs in product(range(C+1),repeat=r))
def criterion(q,r,S,C):return S%q==0 and S//q<=r*(C//q)

class FeasiblePrimeSupportTests(unittest.TestCase):
 def test_exact_criteria(self):
  for C in range(1,8):
   for r in range(1,5):
    for S in range(r*C+1):
     for q in (2,3,5,7):
      self.assertEqual(survives(q,r,S,C),criterion(q,r,S,C))
      self.assertEqual(survives(q,r,S,C,True),criterion(q,r,r*C-S,C))
 def test_capacity_false_control(self):
  # divisibility alone is insufficient: two multiples <=5 cannot sum to 12.
  self.assertEqual(12%3,0)
  self.assertFalse(criterion(3,2,12,5))
 def test_forced_kill(self):
  # sum 5 cannot be achieved by two even coordinates, so prime 2 must die.
  self.assertFalse(criterion(2,2,5,4))

if __name__=='__main__':unittest.main()
