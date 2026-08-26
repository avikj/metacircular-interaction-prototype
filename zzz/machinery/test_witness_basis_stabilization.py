import unittest


def relative_depth(world, x, charts, observable):
    for k, chart in enumerate(charts):
        fiber = [y for y in world if chart(y) == chart(x)]
        if all(observable(y) == observable(x) for y in fiber):
            return k
    raise ValueError("no sufficient chart")


class WitnessBasisStabilizationTests(unittest.TestCase):
    def test_first_critical_witness_is_exact_stabilization_time(self):
        charts = [lambda z, k=k: z % (2**k) for k in range(7)]
        vp2 = lambda z: (z & -z).bit_length() - 1
        x = 16
        schedule = [x, 17, 18, 20, 24, 32, 48]
        worlds = []
        world = set()
        for y in schedule:
            world = world | {y}
            worlds.append(world)
        depths = [relative_depth(s, x, charts, vp2) for s in worlds]
        self.assertEqual(depths, [0, 1, 2, 3, 4, 5, 5])
        critical = lambda y: y % 16 == x % 16 and vp2(y) != vp2(x)
        tau = next(t for t, y in enumerate(schedule) if critical(y))
        self.assertEqual(tau, 5)
        self.assertTrue(all(d == 5 for d in depths[tau:]))

    def test_one_deep_witness_defeats_every_coarser_chart(self):
        charts = [lambda z, k=k: z % (3**k) for k in range(6)]
        vp3 = lambda z: next(e for e in range(10) if z % (3 ** (e + 1)))
        x, witness = 27, 81
        world = {x, witness}
        self.assertEqual(relative_depth(world, x, charts, vp3), 4)
        for k in range(4):
            self.assertEqual(charts[k](x), charts[k](witness))

    def test_nesting_is_essential_false_control(self):
        x, y = 0, 2
        charts = [lambda z: z % 2, lambda z: z % 3]
        observable = lambda z: z
        self.assertEqual(charts[0](x), charts[0](y))
        self.assertNotEqual(charts[1](x), charts[1](y))
        # A witness at chart 0 says nothing about an unrelated earlier/later
        # ordering; the theorem explicitly requires nested fibers.
        self.assertEqual(relative_depth({x, y}, x, charts, observable), 1)


if __name__ == "__main__":
    unittest.main()
