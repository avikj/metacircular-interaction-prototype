import unittest

def basin(blocks, edges, split):
 out=set(split); changed=True
 while changed:
  changed=False
  for x in blocks:
   if x not in out and any(y in out for y in edges[x]):out.add(x);changed=True
 return out

class BackwardBasinBoundaryTests(unittest.TestCase):
 def test_complement_forward_invariant(self):
  blocks=(0,1,2,3); edges={0:{1},1:{1},2:{3},3:{3}}
  B=basin(blocks,edges,{1}); U=set(blocks)-B
  self.assertEqual(B,{0,1})
  self.assertTrue(all(edges[x]<=U for x in U))
 def test_basin_can_overreach(self):
  # blocks C=0 and split B=1; sole refined action is constant, so C adds no distinction.
  self.assertEqual(basin((0,1),{0:{1},1:{1}},{1}),{0,1})
  f=(1,1,1) # refined states w,u,v all map to u
  self.assertEqual(len({f}),1)

if __name__=='__main__':unittest.main()
