import unittest
from machinery.context_formation_boundary import generated_repairs,formation_obligation


class TestContextFormationBoundary(unittest.TestCase):
    def test_pair_generates_repair_obligation_but_not_one_context(self):
        p=(0,0,0,0,1); s=(0,0,1,2,0)
        self.assertEqual(generated_repairs(p,s),
                         ((0,0,1,1,2),(0,0,1,2,3)))
        self.assertEqual(len(formation_obligation(p,s)),2)

    def test_orientation_equivariance(self):
        p=(0,0,0,0,1); s=(0,0,1,2,0)
        self.assertEqual(generated_repairs(p,s),generated_repairs(s,p)[::-1])

    def test_commuting_pair_generates_no_obligation(self):
        p=(0,0,1,1); s=(0,1,0,1)
        self.assertEqual(formation_obligation(p,s),())


if __name__ == "__main__": unittest.main()

