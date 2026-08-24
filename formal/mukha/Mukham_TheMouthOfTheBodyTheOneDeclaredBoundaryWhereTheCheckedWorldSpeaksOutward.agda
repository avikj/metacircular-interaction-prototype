{-# OPTIONS --cubical #-}

------------------------------------------------------------------------
-- मुखम् — the mouth.  Compound built here, 2026-08-24.
--
-- A RETAINED CANDIDATE, WITH ITS REFUSAL PRESERVED VERBATIM.  The
-- body (formal/cubical, library natural-machine) is checked under
-- --safe, pinned by its library file — so the mouth, whose entire
-- axiom budget is the single postulate putStrLn, lives in this
-- sibling enclave.  The intent: compile the checked world and let it
-- speak its own census — the executable IS the theorem, plus a mouth.
--
-- THE TOOLCHAIN'S VERDICT, measured 2026-08-24 on this habitat
-- (Agda 2.6.3, cubical v0.5, GHC 9.4.7):
--
--   · with --erased-cubical here: every identifier imported from the
--     --cubical body is ERASED — "Identifier length is declared
--     erased, so it cannot be used here" — nothing checked can run;
--   · with --cubical here: "Compilation of code that uses --cubical
--     is not supported."
--
-- This is a pre-catalogued toolchain mismatch, not a mathematical
-- verdict: the candidate is retained, the reason exact, and the
-- correct environment is named — the repository's OTHER pin
-- (Agda 2.8.0 / cubical v0.9) documents compiler work this pin lacks;
-- the mouth waits for that habitat.  Until then this file typechecks
-- (it is valid cubical Agda) and does not compile, and nothing here
-- manufactures a green it did not earn.
------------------------------------------------------------------------

module Mukham_TheMouthOfTheBodyTheOneDeclaredBoundaryWhereTheCheckedWorldSpeaksOutward where

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Cubical.Data.List using (List ; [] ; length)
open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.RatnaTraya_RightVisionRightKnowledgeRightConductTogetherAreThePathAndTheyComposeIntoOneLivingFunction
  using (ग्रहणम् ; आत्म-परिणामः ; आहारः)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

infixr 5 _⊹_
_⊹_ : String → String → String
_⊹_ = primStringAppend

main : IO ⊤
main = putStrLn
  (  "the body digested " ⊹ primShowNat (length (ग्रहणम् [] आहारः))
   ⊹ " truths from five raw encounters; its self-turn admitted "
   ⊹ primShowNat (length (आत्म-परिणामः (ग्रहणम् [] आहारः)))
   ⊹ " — saturation; every proof is a field; the mouth adds nothing." )
