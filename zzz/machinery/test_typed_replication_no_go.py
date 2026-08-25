import unittest
from collections import deque


def chain_length(n):
    if n == 1:
        return 0
    queue = deque([((1,), 0)])
    seen = {(1,)}
    while queue:
        values, depth = queue.popleft()
        for a in values:
            for b in values:
                c = a + b
                if c > n or c in values:
                    continue
                nxt = tuple(sorted(values + (c,)))
                if c == n:
                    return depth + 1
                if nxt not in seen:
                    seen.add(nxt)
                    queue.append((nxt, depth + 1))
    raise AssertionError


class TypedReplicationNoGoTests(unittest.TestCase):
    def test_small_exact_lengths(self):
        self.assertEqual([chain_length(n) for n in range(1, 8)], [0, 1, 2, 2, 3, 3, 4])

    def test_equalization_example(self):
        multipliers = (3, 2)
        self.assertEqual(sum(chain_length(n) for n in multipliers), 3)

    def test_false_control_scalar_chain_underprices_typed_outputs(self):
        typed = chain_length(3) + chain_length(2)
        scalar_union = chain_length(3)  # chain 1,2,3 contains both integers
        self.assertEqual((typed, scalar_union), (3, 2))
        self.assertNotEqual(typed, scalar_union)


if __name__ == "__main__":
    unittest.main()
