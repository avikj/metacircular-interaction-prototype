import unittest

from machinery.generative_store import decode, encode, hybrid_store, named_interval


class GenerativeStoreTests(unittest.TestCase):
    def test_named_interval(self):
        for depth in range(9):
            self.assertEqual(named_interval(depth), tuple(range(2**depth)))

    def test_round_trip(self):
        for depth in range(8):
            for value in range(2**depth):
                bits = encode(value, depth)
                self.assertEqual(len(bits), depth)
                self.assertEqual(decode(bits), value)

    def test_materialization_is_exponential(self):
        self.assertEqual(len(named_interval(12)), 2**12)

    def test_hybrid_has_dense_digits_and_long_tower(self):
        store = hybrid_store(8, 3, 20)
        self.assertTrue(set(range(256)) <= store)
        self.assertIn(3**20, store)

    def test_bad_address_fails_closed(self):
        with self.assertRaises(ValueError):
            encode(8, 3)
        with self.assertRaises(ValueError):
            decode((0, 2))


if __name__ == "__main__":
    unittest.main()
