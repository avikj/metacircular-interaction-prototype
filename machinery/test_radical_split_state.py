import unittest
from itertools import product
from math import gcd

def radical(n):
 if n==0:return 0
 r=1;p=2
 while p*p<=n:
  if n%p==0:
   r*=p
   while n%p==0:n//=p
  p+=1
 return r*n

class RadicalSplitStateTests(unittest.TestCase):
 def test_future_gcd_equivalence(self):
  for g in range(0,30):
   for suffix in product(range(7),repeat=3):
    a=g
    for x in suffix:a=gcd(a,x)
    b=radical(g)
    for x in suffix:b=gcd(b,x)
    self.assertEqual(a==1,b==1)
 def test_exact_gcd_false_minimality(self):
  self.assertEqual(radical(2),radical(4))
  for suffix in product(range(6),repeat=2):
   self.assertEqual(gcd(2,*suffix)==1,gcd(4,*suffix)==1)
 def test_distinct_radicals_can_separate(self):
  self.assertNotEqual(gcd(2,2)==1,gcd(3,2)==1)

if __name__=='__main__':unittest.main()
