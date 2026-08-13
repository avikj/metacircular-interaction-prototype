import unittest
from machinery.typed_bounded_unfold import *


class TestTypedBoundedUnfold(unittest.TestCase):
    def test_unfold_preserves_denotation_and_exposes_cost(self):
        t=App("D",App("M",Var()))
        u=unfold(t,{"M":BODY})
        interp={**BASE,"M":mul(A,P)}
        self.assertEqual(denote(t,interp),denote(u,BASE))
        self.assertEqual(size(t),2)
        self.assertEqual(size(u),3)

    def test_bounded_denotation_strictly_grows(self):
        interp={**BASE,"M":mul(A,P)}
        old=denotation_language(tuple(BASE),2,BASE)
        new=denotation_language(tuple(interp),2,interp)
        target=key(mul(D,mul(A,P)))
        self.assertNotIn(target,old)
        self.assertIn(target,new)

    def test_unbounded_no_go_at_finite_witness(self):
        # Every macro term eliminates to a base term with identical denotation.
        interp={**BASE,"M":mul(A,P)}
        for t in terms(tuple(interp),3):
            u=unfold(t,{"M":BODY})
            self.assertEqual(denote(t,interp),denote(u,BASE))

    def test_body_is_base_covered(self):
        self.assertEqual({"A","P"},heads(BODY))


def heads(t):
    return set() if isinstance(t,Var) else {t.head}|heads(t.arg)


if __name__ == "__main__": unittest.main()

