{-# OPTIONS --guardedness #-}
module SvargaMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import Svarga using (report)

postulate
  putStr' : String → IO ⊤

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC putStr' = TIO.putStr #-}

main : IO ⊤
main = putStr' report
