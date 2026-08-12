import unittest

def support_and_edges(fiber):
 edges=[]
 for i,f in enumerate(fiber):
  for g in fiber[i+1:]:
   if f!=g: edges.append({x for x,(a,b) in enumerate(zip(f,g)) if a!=b})
 return set().union(*edges) if edges else set(),edges

class MinimalChangedActionDomainTests(unittest.TestCase):
 def test_union_support_exact_irrelevant_complement(self):
  fiber=((0,0,0),(0,1,0),(0,0,2))
  support,edges=support_and_edges(fiber)
  self.assertEqual(support,{1,2})
  self.assertTrue(all(f[0]==fiber[0][0] for f in fiber))
 def test_false_unique_minimum(self):
  # Two transformations disagree at either point; either singleton separates.
  support,edges=support_and_edges(((0,0),(1,1)))
  self.assertEqual(support,{0,1})
  self.assertTrue({0}&edges[0]); self.assertTrue({1}&edges[0])
 def test_hitting_sets_separate(self):
  fiber=((0,0,0),(0,1,0),(0,0,2)); _,edges=support_and_edges(fiber)
  H={1,2}; self.assertTrue(all(H&e for e in edges))

if __name__=='__main__':unittest.main()
