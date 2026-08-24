-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- The process an LLM talks to.  See Sabha_TheSessionKernelAnLLMTalksTo.
--     ghc -O0 -imachine -o machine/sabha machine/SabhaRun.hs
--     machine/sabha              -- JSON lines on stdin/stdout
--     machine/sabha --selftest   -- a scripted session, invariant checked
module Main (main) where

import Sabha_TheSessionKernelAnLLMTalksTo (sabhaMain)

main :: IO ()
main = sabhaMain
