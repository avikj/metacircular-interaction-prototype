import unittest

class LocalMonoidUpdateNoGoTests(unittest.TestCase):
 def test_unchanged_source_witnesses_split(self):
  f=(0,0,0); g=(0,0,1) # u=0,v=1,w=2
  self.assertEqual(f[:2],g[:2])
  self.assertNotEqual(f,g)
  old=lambda t: tuple(0 if t[i] in (0,1) else 1 for i in (0,2))
  self.assertEqual(old(f),old(g))
 def test_false_control_without_w_state_they_coincide(self):
  self.assertEqual((0,0),(0,0))

if __name__=='__main__':unittest.main()
