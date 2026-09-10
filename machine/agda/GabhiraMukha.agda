{-# OPTIONS --guardedness #-}

module GabhiraMukha where

open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import Gabhira using (report)

postulate
  putStr' : String → IO ⊤

{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# COMPILE GHC putStr' = TIO.putStr #-}

main : IO ⊤
main = putStr' report
