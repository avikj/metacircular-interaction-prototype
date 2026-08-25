import unittest
from collections import deque,defaultdict

def compose(f,g): return tuple(f[g[i]] for i in range(len(g)))
def closure(old_gens,new_gens):
 io=tuple(range(len(old_gens[0]))); inn=tuple(range(len(new_gens[0])))
 start=(inn,io); words={start:""}; q=deque([start])
 while q:
  nf,of=q.popleft()
  for label,(ng,og) in enumerate(zip(new_gens,old_gens)):
   nxt=(compose(ng,nf),compose(og,of))
   if nxt not in words: words[nxt]=words[(nf,of)]+str(label);q.append(nxt)
 return words

class IncrementalSyntacticMonoidTests(unittest.TestCase):
 def test_fibers_split_old_transformations(self):
  # old quotient parity; refined quotient mod4; generator +1.
  old=((1,0),); new=((1,2,3,0),)
  pairs=closure(old,new); fibers=defaultdict(set)
  for (n,o) in pairs:fibers[o].add(n)
  self.assertEqual(len(pairs),4)
  self.assertEqual(sorted(len(v) for v in fibers.values()),[2,2])
 def test_shortest_words(self):
  words=closure(((1,0),),((1,2,3,0),))
  self.assertEqual(sorted(len(w) for w in words.values()),[0,1,2,3])
 def test_false_control_refinement_not_always_split(self):
  pairs=closure(((1,0),),((1,0),))
  self.assertEqual(len(pairs),2)
  self.assertTrue(all(n==o for n,o in pairs))

if __name__=='__main__':unittest.main()
