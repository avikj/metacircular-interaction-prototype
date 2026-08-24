-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- This driver contains no rewrite implementation.  It calls the Haskell
-- emitted by MAlonzo from formal/executable/RewriteDynamics.agda.
module Main (main) where

import MAlonzo.RTE (coe)
import qualified MAlonzo.Code.Agda.Builtin.Sigma as Sigma
import qualified MAlonzo.Code.Agda.Builtin.Bool as Bool
import qualified MAlonzo.Code.RewriteDynamics as R
import qualified MAlonzo.Code.RootedReweave as W
import qualified MAlonzo.Code.BalancedReweave as B
import qualified MAlonzo.Code.TheoremCompiledObservation as T
import qualified MAlonzo.Code.InstalledRootedQuotient as I
import qualified MAlonzo.Code.BoundedMinimization as BM
import qualified MAlonzo.Code.ConsequenceFiber as CF
import qualified MAlonzo.Code.FiberJewelNet as FJ

showTm :: R.T_Tm_2 -> String
showTm R.C_var_4 = "x"
showTm R.C_zeroT_6 = "0"
showTm (R.C_sucT_8 t) = "s(" ++ showTm t ++ ")"
showTm (R.C_add_10 l r) = "(" ++ showTm l ++ "+" ++ showTm r ++ ")"

main :: IO ()
main = do
  let input = R.C_add_10 R.C_var_4 (R.C_sucT_8 R.C_zeroT_6)
      result = case R.d_rootStep_134 input of
        Sigma.C__'44'__32 out _proof -> coe out :: R.T_Tm_2
      before = R.d_eval_38 input 7
      after = R.d_eval_38 result 7
  putStrLn (showTm input ++ " -> " ++ showTm result)
  putStrLn ("eval@7: " ++ show before ++ " = " ++ show after)
  putStrLn ("all-root reweave: north=" ++ showBool W.d_north'45'after_404
    ++ " south=" ++ showBool W.d_south'45'after_406)
  putStrLn ("adaptive fusion after 100 writes: read1="
    ++ showBool (B.d_adaptiveSelected_848 100 1)
    ++ " read2=" ++ showBool (B.d_adaptiveSelected_848 100 2))
  putStrLn ("theorem-compiled parity: direct-even="
    ++ showBool (T.d_directEvenValue_312 50000)
    ++ " quotient-bit=" ++ showBool T.d_compiledEvenValue_316)
  putStrLn ("language expansion: predecessor reopened="
    ++ showBool I.d_extensionWasReopened_544
    ++ " exact-state=" ++ show I.d_reopenedState_554)
  putStrLn ("theorem-compiled bounded mu: result="
    ++ show BM.d_compiledThreeResult_310
    ++ " exact-budget=" ++ show BM.d_compiledThreeBudget_312)
  putStrLn ("same consequence, distinct fibers: outputs="
    ++ show CF.d_replayOutput_124 ++ "/" ++ show CF.d_installedOutput_126
    ++ " next-values=" ++ show CF.d_replayNextValue_128 ++ "/"
    ++ show CF.d_installedNextValue_130 ++ " costs="
    ++ show CF.d_replayNextCost_132 ++ "/" ++ show CF.d_installedNextCost_134)
  putStrLn ("fiber-jewel net: outputs="
    ++ show FJ.d_netReplayOutput_162 ++ "/" ++ show FJ.d_netInstalledOutput_164
    ++ " rooted-costs=" ++ show FJ.d_netReplayCost_156 ++ "/"
    ++ show FJ.d_netInstalledCost_158 ++ " transported="
    ++ show FJ.d_transportedCost_160)
  if before == after then pure () else fail "extracted dynamics violated its checked semantics"
  where
    showBool Bool.C_false_8 = "false"
    showBool Bool.C_true_10 = "true"
