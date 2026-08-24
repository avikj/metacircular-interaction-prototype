-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.EndianAtlasReplay where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero)
open import Cubical.Data.Fin using (fzero ; fone)
open import Cubical.Data.List using ([] ; _∷_ ; rev)
open import Cubical.Data.Sigma using (_×_)
import NaturalMachine.Endian
import NaturalMachine.Digits

module E = NaturalMachine.Endian zero
module D = NaturalMachine.Digits zero

-- The four fixed two-bit raw words, little-endian.  `E.value` is their
-- integer code 0..3; no new encoding is introduced.
w00 w01 w10 w11 : D.Word
w00 = fzero ∷ fzero ∷ []
w01 = fone  ∷ fzero ∷ []
w10 = fzero ∷ fone  ∷ []
w11 = fone  ∷ fone  ∷ []

code : D.Word → ℕ
code = D.value

idTable : ℕ × ℕ × ℕ × ℕ
idTable = code w00 , code w01 , code w10 , code w11

revTable : ℕ × ℕ × ℕ × ℕ
revTable = code (rev w00) , code (rev w01) ,
           code (rev w10) , code (rev w11)

compTable : ℕ × ℕ × ℕ × ℕ
compTable = code (E.compw w00) , code (E.compw w01) ,
            code (E.compw w10) , code (E.compw w11)

revCompTable : ℕ × ℕ × ℕ × ℕ
revCompTable = code (rev (E.compw w00)) , code (rev (E.compw w01)) ,
               code (rev (E.compw w10)) , code (rev (E.compw w11))

id-replay : idTable ≡ (0 , 1 , 2 , 3)
id-replay = refl

rev-replay : revTable ≡ (0 , 2 , 1 , 3)
rev-replay = refl

comp-replay : compTable ≡ (3 , 2 , 1 , 0)
comp-replay = refl

revComp-replay : revCompTable ≡ (3 , 1 , 2 , 0)
revComp-replay = refl
