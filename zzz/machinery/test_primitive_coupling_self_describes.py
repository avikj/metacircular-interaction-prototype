import unittest
from functools import reduce
from math import gcd, lcm


def content(v):
    return reduce(gcd, v)


def couple(children):
    totals = [sum(v) for v in children]
    L = lcm(*totals)
    return [tuple((L // t) * x for x in v) for v, t in zip(children, totals)]


def decode(parent):
    return [(content(v), tuple(x // content(v) for x in v)) for v in parent]


class PrimitiveCouplingSelfDescribesTests(unittest.TestCase):
    def test_decode_multiplier_and_child(self):
        families = (
            [(1, 1), (1, 1, 1)],
            [(2, 1), (1, 4), (1, 1, 1, 1)],
            [(1, 0, 1), (2, 3)],
        )
        for children in families:
            self.assertTrue(all(content(v) == 1 for v in children))
            parent = couple(children)
            decoded = decode(parent)
            self.assertEqual([v for _, v in decoded], children)
            self.assertTrue(all(n * sum(v) == sum(parent[0]) for n, v in decoded))

    def test_lcm_promise_replays(self):
        children = [(2, 1), (1, 4), (1, 1, 1, 1)]
        parent = couple(children)
        decoded = decode(parent)
        L = lcm(*(sum(v) for _, v in decoded))
        self.assertTrue(all(n == L // sum(v) for n, v in decoded))

    def test_false_control_nonprimitive_ambiguity(self):
        output = (2, 2)
        descriptions = ((1, (2, 2)), (2, (1, 1)))
        self.assertTrue(all(tuple(n * x for x in child) == output
                            for n, child in descriptions))
        self.assertNotEqual(descriptions[0], descriptions[1])


if __name__ == "__main__":
    unittest.main()
