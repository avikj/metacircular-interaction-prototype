import unittest
from machinery.qap_informative_macro import M, compile_macro, transport, mul, inverse


class TestQAPMacro(unittest.TestCase):
    def setUp(self):
        self.p=M([[1,0,0],[0,1,0],[0,0,0]])
        self.a=M([[1,2,7],[3,4,8],[5,6,9]])

    def test_nonzero_minimal_correction(self):
        z=compile_macro(self.p,self.a)
        self.assertEqual(len(z["B"][0]),1)       # rank(QAP)=1
        self.assertEqual(mul(z["B"],z["C"]),z["image_matrix"])
        self.assertEqual(z["body"],z["target"])

    def test_basis_change_conjugates_execution(self):
        z=compile_macro(self.p,self.a)
        s=M([[1,1,0],[0,1,1],[1,0,1]])
        pp,aa,b,c,body=transport(self.p,self.a,z,s)
        self.assertEqual(body,mul(aa,pp))
        self.assertEqual(mul(mul(inverse(s),z["body"]),s),body)
        self.assertNotEqual(b,z["B"])             # program coordinates changed

    def test_zero_leakage(self):
        a=M([[1,2],[3,4]]); p=M([[1,0],[0,1]])
        z=compile_macro(p,a)
        self.assertEqual(z["pivot_columns"],[])
        self.assertEqual(z["body"],a)

    def test_reject_nonprojector(self):
        with self.assertRaises(ValueError):
            compile_macro(M([[1,1],[0,1]]),M([[1,0],[0,1]]))


if __name__ == "__main__": unittest.main()

