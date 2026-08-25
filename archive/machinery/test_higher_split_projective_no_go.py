import unittest
from itertools import product
from math import gcd
from functools import reduce

def primitive(v): return reduce(gcd,v)==1
def fiber(D,C):
    return [x for x in product(range(C+1),repeat=D)
            if 2*sum(x)==D*C and primitive(x) and primitive(tuple(C-a for a in x))]

class HigherSplitProjectiveNoGoTests(unittest.TestCase):
    def test_smallest_counterexample(self):
        f=fiber(3,2)
        self.assertEqual(len(f),7)
        self.assertIn((1,1,1),f)
        self.assertEqual({tuple(sorted(x)) for x in f},{(0,1,2),(1,1,1)})
    def test_unordered_orbits(self):
        f=fiber(3,2); orbits={tuple(sorted((x,tuple(2-a for a in x)))) for x in f}
        self.assertEqual(len(orbits),4)
    def test_fixed_point_only_C_two(self):
        for C in range(1,8):
            fixed=[x for x in fiber(4,C) if x==tuple(C-a for a in x)]
            self.assertEqual(len(fixed),int(C==2))
    def test_odd_total_empty(self): self.assertEqual(fiber(3,1),[])

if __name__=='__main__': unittest.main()
