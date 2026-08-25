import unittest

from descent_formation_machine import DescentMachine


class DescentMachineTest(unittest.TestCase):
    def test_descends_then_forms_then_idempotent(self):
        m = DescentMachine(range(6))
        self.assertEqual(m.offer("const", lambda x: 0)["kind"], "descends")
        e = m.offer("parity", lambda x: x % 2)
        self.assertEqual(e["kind"], "forms")
        self.assertEqual(e["fibers"], 2)
        # offering the same observable again must descend (idempotence)
        self.assertEqual(m.offer("parity2", lambda x: x % 2)["kind"],
                         "descends")

    def test_joint_is_coarsest(self):
        m = DescentMachine(range(12))
        m.offer("mod2", lambda x: x % 2)
        m.offer("mod3", lambda x: x % 3)
        self.assertEqual(len(m.fibers()), 6)  # joint = mod 6
        # anything factoring through mod 6 now descends
        self.assertEqual(m.offer("mod6", lambda x: x % 6)["kind"],
                         "descends")

    def test_equivariance_obstruction_enforced(self):
        m = DescentMachine(range(4))
        swap = lambda x: x ^ 1  # orbits {0,1},{2,3}
        # orbit-invariant observable: allowed to form across orbits
        e = m.offer("pair", lambda x: x // 2, symmetry=[swap])
        self.assertEqual(e["kind"], "forms")
        # falsely-claimed-invariant observable splitting an orbit: caught
        with self.assertRaises(AssertionError):
            m.offer("bad", lambda x: x, symmetry=[swap])

    def test_engine_formation_rederived_with_three_kinds(self):
        from smith_residual_machine import smith_reduce
        mats = [((a, b), (c, d))
                for a in range(-2, 3) for b in range(-2, 3)
                for c in range(-2, 3) for d in range(-2, 3)
                if (a, b, c, d) != (0, 0, 0, 0)]
        fiber1 = [x for x in mats if smith_reduce(x).steps
                  and smith_reduce(x).steps[0].residual == 1]
        m = DescentMachine(fiber1)
        self.assertEqual(
            m.offer("residual",
                    lambda x: smith_reduce(x).steps[0].residual)["kind"],
            "descends")
        e = m.offer("kind", lambda x: smith_reduce(x).steps[0].kind)
        self.assertEqual(e["kind"], "forms")
        # the general law sees THREE kinds where the engine's hardcoded
        # sensor saturated at its first two-kind collision
        self.assertEqual(e["fibers"], 3)


if __name__ == "__main__":
    unittest.main()
