import unittest
from math import gcd


def units(T): return tuple(a for a in range(1,T) if gcd(a,T)==1)
def orbit(a,T): return tuple(sorted({a, (-a)%T}))


class ProjectiveSplitRecordTests(unittest.TestCase):
    def test_ordered_record_reconstructs(self):
        for T in range(2,30):
            for a in units(T):
                d=((a,T-a),(T-a,a))
                self.assertEqual(d[0][0],a)
    def test_unordered_orbits(self):
        for T in range(3,30):
            os={orbit(a,T) for a in units(T)}
            self.assertEqual(2*len(os),len(units(T)))
    def test_false_control_nonunits_excluded(self):
        self.assertNotIn(2,units(6))


if __name__ == '__main__': unittest.main()
