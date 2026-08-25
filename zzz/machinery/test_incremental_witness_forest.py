import unittest
from collections import deque,defaultdict

def forest(states,actions,observations):
 pairs=[(x,y) for x in states for y in states]; pred=defaultdict(list)
 for u in pairs:
  for label,a in actions: pred[(a(u[0]),a(u[1]))].append((u,label))
 cert={};q=deque()
 for u in pairs:
  for name,o in observations:
   if o(u[0])!=o(u[1]):cert[u]=(0,None,name);q.append(u);break
 while q:
  v=q.popleft(); dist=cert[v][0]
  for u,label in pred[v]:
   if u not in cert:cert[u]=(dist+1,(label,v),None);q.append(u)
 return cert

class IncrementalWitnessForestTests(unittest.TestCase):
 def test_depth_and_replay(self):
  X=(0,1,2); acts=(("a",lambda x:min(x+1,2)),); obs=(("is2",lambda x:x==2),)
  c=forest(X,acts,obs); self.assertEqual(c[(0,1)][0],1)
  _,(label,v),_=c[(0,1)]; self.assertEqual((label,v),("a",(1,2)))
  self.assertEqual(c[v][2],"is2")
 def test_distances_strictly_decrease(self):
  c=forest(range(4),(('a',lambda x:min(x+1,3)),),(('is3',lambda x:x==3),))
  for u,(d,p,_) in c.items():
   if p:self.assertEqual(c[p[1]][0],d-1)
 def test_observation_local_roots(self):
  c=forest((0,1,2),(('i',lambda x:x),),(('par',lambda x:x%2),('zero',lambda x:x==0)))
  roots={name for _,(_,_,name) in c.items() if name}
  self.assertEqual(roots,{'par','zero'})

if __name__=='__main__':unittest.main()
