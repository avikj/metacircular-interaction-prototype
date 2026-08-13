import unittest
from machinery.residual_language_growth import A,D,P,ZERO,key,mul,bounded_actions,run_cycle


class TestResidualLanguageGrowth(unittest.TestCase):
    def test_installed_macro_changes_next_bounded_language(self):
        z=run_cycle(); k=key(z["next_action"])
        self.assertNotIn(k,z["before"])
        self.assertNotIn(k,bounded_actions(z["primitives"]+(("M",z["first"]["body"],1),),1))
        self.assertEqual(z["after"][k][0],2)
        self.assertEqual(z["after"][k][1],"DM")

    def test_new_action_is_next_nonzero_residual(self):
        z=run_cycle()
        self.assertEqual(z["next_action"],z["next_residual"])
        self.assertNotEqual(z["next_residual"],ZERO)
        self.assertEqual(z["second"]["body"],z["next_action"])
        self.assertEqual(len(z["second"]["B"][0]),1)
        # compile_macro(P,F) compiles Q F P; here F=DM1 and M1 already ends in P.
        self.assertEqual(z["second"]["image_matrix"],z["next_residual"])

    def test_unfolding_cost_is_three(self):
        target=mul(D,mul(A,P))
        primitive=bounded_actions((("A",A,1),("D",D,1),("P",P,1)),3)
        self.assertEqual(primitive[key(target)][0],3)

    def test_no_extensional_growth(self):
        z=run_cycle(); m=z["first"]["body"]
        self.assertEqual(m,mul(A,P))
        # At budget 3 primitives already denote the supposedly new action.
        primitive=bounded_actions(z["primitives"],3)
        self.assertIn(key(z["next_action"]),primitive)

    def test_nilpotent_chain_stops(self):
        z=run_cycle()
        self.assertEqual(mul(D,z["next_action"]),ZERO)

    def test_zero_residual_does_not_generate(self):
        # P itself has QPP=0; compiling it only reproduces P and adds no action.
        from machinery.qap_informative_macro import compile_macro
        z=compile_macro(P,P)
        self.assertEqual(z["image_matrix"],ZERO)
        self.assertEqual(z["body"],P)


if __name__ == "__main__": unittest.main()
