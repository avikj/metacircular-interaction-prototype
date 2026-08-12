import unittest
from collections import deque

def witnesses(states, actions, old_class, new_obs):
 pairs=[(x,y) for x in states for y in states if old_class[x]==old_class[y]]
 pred={p:[] for p in pairs}; out={}
 for p in pairs:
  x,y=p
  for label,act in actions:
   q=(act(x),act(y)); pred[q].append((p,label))
 seeds=[]
 for p in pairs:
  for name,o in new_obs:
   if o(p[0])!=o(p[1]):out[p]=((),name);seeds.append(p);break
 q=deque(seeds)
 while q:
  v=q.popleft()
  for u,label in pred[v]:
   if u not in out:
    w,name=out[v];out[u]=((label,)+w,name);q.append(u)
 return out

class IncrementalWitnessPairGraphTests(unittest.TestCase):
 def test_shortest_witnesses(self):
  X=tuple(range(8)); actions=(("a",lambda x:(x+1)%8),)
  old={x:x%2 for x in X}; new=(("mod4",lambda x:x%4),)
  out=witnesses(X,actions,old,new)
  self.assertIn((0,2),out)
  self.assertEqual(out[(0,2)][0],())
  self.assertNotIn((0,4),out) # mod4 remains equal under common translation
 def test_predecessor_witness(self):
  X=(0,1,2); actions=(("a",lambda x:min(x+1,2)),)
  old={x:0 for x in X}; new=(("is2",lambda x:x==2),)
  out=witnesses(X,actions,old,new)
  self.assertEqual(out[(0,1)][0],("a",))
 def test_old_blocks_excluded(self):
  X=(0,1); actions=(("i",lambda x:x),); old={0:0,1:1}
  self.assertEqual(witnesses(X,actions,old,(("o",lambda x:x),)),{})

if __name__=='__main__':unittest.main()
