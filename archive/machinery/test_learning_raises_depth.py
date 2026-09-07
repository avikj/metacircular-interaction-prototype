import unittest


def vp(n, p):
    if n == 0:
        return float("inf")
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e


def relative_depth(world, x, p):
    target = vp(x, p)
    for k in range(target + 2):
        modulus = p**k
        fiber = [y for y in world if y % modulus == x % modulus]
        if all(vp(y, p) == target for y in fiber):
            return k
    raise AssertionError("ambient bound exceeded")


def staircase(p, e):
    x = p**e
    worlds = [{x}]
    for j in range(1, e + 1):
        worlds.append(worlds[-1] | {x + p ** (j - 1)})
    worlds.append(worlds[-1] | {p ** (e + 1)})
    return x, worlds


class LearningRaisesDepthTests(unittest.TestCase):
    def test_every_depth_appears_in_nested_worlds(self):
        for p in (2, 3, 5, 7):
            for e in range(0, 9):
                x, worlds = staircase(p, e)
                self.assertEqual(
                    [relative_depth(world, x, p) for world in worlds],
                    list(range(e + 2)),
                )
                self.assertTrue(
                    all(worlds[k] < worlds[k + 1] for k in range(e + 1))
                )

    def test_depth_is_monotone_under_arbitrary_enlargement(self):
        p, x = 3, 81
        points = [x + d for d in range(-40, 41) if x + d > 0]
        world = {x}
        previous = relative_depth(world, x, p)
        for y in points:
            world.add(y)
            current = relative_depth(world, x, p)
            self.assertGreaterEqual(current, previous)
            previous = current

    def test_false_control_world_size_does_not_determine_depth(self):
        p, e = 2, 7
        x, worlds = staircase(p, e)
        shallow = {x, x + 1}
        deep = {x, p ** (e + 1)}
        self.assertEqual(len(shallow), len(deep))
        self.assertEqual(relative_depth(shallow, x, p), 1)
        self.assertEqual(relative_depth(deep, x, p), e + 1)


if __name__ == "__main__":
    unittest.main()
