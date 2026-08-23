-- The process an LLM talks to.  See Sabha_TheSessionKernelAnLLMTalksTo.
--     ghc -O0 -imachine -o machine/sabha machine/SabhaRun.hs
--     machine/sabha              -- JSON lines on stdin/stdout
--     machine/sabha --selftest   -- a scripted session, invariant checked
module Main (main) where

import Sabha_TheSessionKernelAnLLMTalksTo (sabhaMain)

main :: IO ()
main = sabhaMain
