{-# OPTIONS --erased-cubical --erasure #-}

------------------------------------------------------------------------
-- मुखम् — the mouth.  The one declared boundary: its whole axiom
-- budget is putStrLn.  Everything it says is computed by the
-- act-portion (कर्मकाण्ड) — the same definitions the --cubical body
-- proves over — on the elder's store as emitted for the act side.
-- The habitat boundary, measured (Agda 2.8.0): full --cubical does
-- not compile; erased-cubical admits the body's names only erased —
-- proofs cross, values do not — so the mouth speaks from the act side
-- and the knowledge-portion's censuses are its warrant.
------------------------------------------------------------------------

module Mukham_TheMouthOfTheBodyTheOneDeclaredBoundaryWhereTheCheckedWorldSpeaksOutward where

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
open import AgamaKanda_TheEldersStoreOnTheActSide

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

-- how many of the elder's rules the flat act (norm, then the boolean
-- mirror of the test) closes at runtime.
समतल-गणना : List Eq' → Nat
समतल-गणना [] = zero
समतल-गणना ((l , r) ∷ es) with समः (norm l) (norm r)
... | true  = suc (समतल-गणना es)
... | false = समतल-गणना es

दीर्घता : List Eq' → Nat
दीर्घता []       = zero
दीर्घता (_ ∷ es) = suc (दीर्घता es)

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

main : IO ⊤
main = putStrLn
  (  "the act-portion, compiled, speaks: of the elder's "
   ⊹ primShowNat (दीर्घता आगमः)
   ⊹ " rules, the flat act closes "
   ⊹ primShowNat (समतल-गणना आगमः)
   ⊹ " at runtime; the knowledge-portion holds the rest, and the mouth adds nothing." )
