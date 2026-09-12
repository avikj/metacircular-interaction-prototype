{-# OPTIONS --guardedness #-}

module CorpusSelfPresentation_run where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String

-- The checked core.  Importing this is the executable boundary: if the core
-- does not typecheck, this mouth does not compile.
open import CorpusSelfPresentation

postulate
  putStrLn : String → IO ⊤

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC putStrLn = TIO.putStrLn #-}

report : String
report =
  "CORPUS SELF-PRESENTATION CORE: CHECKED\n"
  primStringAppend
  "  present : question -> visible target × exact residual fibre × continuation\n"
  (primStringAppend
  "  install : finite dependent trace -> native future Question\n"
  (primStringAppend
  "  lossless : Source ≃ Σ visible . fibre\n"
  "  refinement : demanded read factors through current presentation iff constant on its residual fibres\n"))

main : IO ⊤
main = putStrLn report
