import unittest

def counts(vertices,seeds,parent):
 return len(vertices),len(parent),len(seeds)

class WitnessForestStorageNoGoTests(unittest.TestCase):
 def test_parent_choice_same_counts(self):
  V={0,1,2,3};Z={3}
  p1={0:1,1:3,2:3};p2={0:2,1:3,2:3}
  self.assertEqual(counts(V,Z,p1),counts(V,Z,p2))
  self.assertEqual(counts(V,Z,p1),(4,3,1))
 def test_multiple_seeds(self):
  V=set(range(6));Z={4,5};parent={0:2,1:3,2:4,3:5}
  self.assertEqual(counts(V,Z,parent),(6,4,2))

if __name__=='__main__':unittest.main()
