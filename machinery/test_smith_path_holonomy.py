import unittest

from machinery.smith_path_holonomy import (
    act, diagonal, multiply, witness,
)


class SmithPathHolonomyTests(unittest.TestCase):
    def test_same_endpoint_distinct_transport(self):
        _, target, p, q, _, _, _, _ = witness()
        self.assertEqual(target, (1, 2, 6))
        self.assertNotEqual((p[1], p[2]), (q[1], q[2]))

    def test_nontrivial_cokernel_action(self):
        *_, h, before, after, fixed = witness()
        self.assertNotEqual(before, after)
        self.assertEqual(len(fixed), 3)
        self.assertEqual(act(h, (0, 0, 1)), (0, 1, 4))

    def test_false_control_fails_lattice_preservation(self):
        d = diagonal((1, 2, 6))
        bad = ((1, 0, 0), (0, 1, 1), (0, 0, 1))
        # If bad preserved D Z^3, D^-1 bad D would be integral. Entry (1,2)
        # is 3, so use a genuinely nonpreserving shear in the opposite place.
        bad = ((1, 1, 0), (0, 1, 0), (0, 0, 1))
        # bad*D has entry (0,1)=2; any D*K has first row K[0,*], so that alone
        # is not a control. The obstruction is K = D^-1 bad D at (1,0)=0 here;
        # choose the lower shear, which creates 1/2.
        bad = ((1, 0, 0), (1, 1, 0), (0, 0, 1))
        bad_d = multiply(bad, d)
        self.assertEqual(bad_d[1][0], 1)
        self.assertNotEqual(bad_d[1][0] % 2, 0)


if __name__ == "__main__":
    unittest.main()

