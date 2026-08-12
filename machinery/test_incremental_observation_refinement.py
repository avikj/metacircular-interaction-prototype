import unittest

def future_partition(states, actions, observations):
 sig={x:tuple(o(a(x)) for o in observations for a in actions) for x in states}
 return {x:sig[x] for x in states}

class IncrementalObservationRefinementTests(unittest.TestCase):
 def test_new_partition_only_splits(self):
  X=range(6); actions=(lambda x:x, lambda x:(x+1)%6)
  old=(lambda x:x%2,); new=(lambda x:x%3,)
  po=future_partition(X,actions,old); pn=future_partition(X,actions,old+new)
  for x in X:
   for y in X:
    if pn[x]==pn[y]:self.assertEqual(po[x],po[y])
 def test_distinct_old_blocks_need_no_new_witness(self):
  X=range(6); actions=(lambda x:x,); old=(lambda x:x%2,); new=(lambda x:x%3,)
  po=future_partition(X,actions,old); pn=future_partition(X,actions,old+new)
  self.assertNotEqual(po[0],po[1]); self.assertNotEqual(pn[0],pn[1])
 def test_false_control_observation_removal_can_merge(self):
  X=range(6); actions=(lambda x:x,)
  fine=future_partition(X,actions,(lambda x:x%2,lambda x:x%3))
  coarse=future_partition(X,actions,(lambda x:x%2,))
  self.assertNotEqual(fine[0],fine[2]); self.assertEqual(coarse[0],coarse[2])

if __name__=='__main__':unittest.main()
