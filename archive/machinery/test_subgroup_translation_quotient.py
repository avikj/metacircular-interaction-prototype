import unittest

from subgroup_translation_quotient import behavior_classes, truncated_valuation


class SubgroupTranslationQuotientTests(unittest.TestCase):
    def test_exact_classification_and_count(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                modulus = p**k
                for j in range(k + 1):
                    classes = behavior_classes(p, k, j)
                    self.assertEqual(len(classes), p ** (k - j) + j)
                    for members in classes.values():
                        inside = [r for r in members if r % (p**j) == 0]
                        if inside:
                            self.assertEqual(len(members), 1)
                        else:
                            vals = {truncated_valuation(r, p, k) for r in members}
                            self.assertEqual(len(vals), 1)
                            self.assertLess(next(iter(vals)), j)

    def test_full_translation_endpoint_is_discrete(self):
        self.assertTrue(all(len(c) == 1 for c in behavior_classes(3, 3, 0).values()))

    def test_zero_translation_endpoint_is_valuation(self):
        classes = behavior_classes(2, 4, 4)
        self.assertEqual(len(classes), 5)
        self.assertEqual(sorted(len(c) for c in classes.values()), [1, 1, 2, 4, 8])


if __name__ == "__main__":
    unittest.main()

