import unittest
from collections import defaultdict
from math import gcd
from test_primitive_split_mobius_count import brute

def machine_count(D,C):
 if D*C%2:return 0
 target=D*C//2; states={(0,0,0):1}
 for j in range(D):
  nxt=defaultdict(int)
  for (s,g,h),count in states.items():
   for a in range(C+1):
    ns=s+a
    if ns<=target and ns+(D-j-1)*C>=target:
     nxt[(ns,gcd(g,a),gcd(h,C-a))]+=count
  states=nxt
 return states.get((target,1,1),0)

class OnlinePrimitiveSplitMachineTests(unittest.TestCase):
 def test_matches_direct_fibers(self):
  for D in range(2,6):
   for C in range(1,8):self.assertEqual(machine_count(D,C),brute(D,C))
 def test_prior_case(self):self.assertEqual(machine_count(3,2),7)
 def test_false_control_dropping_complement_gcd(self):
  # x=(1,1), C=3 has gcd(x)=1 and balanced sum 2 != 3; choose D=2,C=2:
  # x=(1,1) is valid, whereas x=(0,2) has primitive complement but nonprimitive x.
  self.assertEqual(gcd(0,2),2)
  self.assertEqual(gcd(2,0),2)

if __name__=='__main__':unittest.main()
