{-# OPTIONS --cubical --guardedness --safe #-}
module Sakshi where
-- àà¾à•ààà: the witnessed census.  Every step of the count is a Dec object â”
-- each twin carries its Î-certificate, each non-twin its refutation.
-- No boolean is trusted anywhere in this count.

open import Prakriti
open import Vada using (primeDec; decÃ—)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary

Twin : â„• â†’ Typeâ‚€
Twin k = IsPrime k Ã— IsPrime (suc (suc k))

twinDec : (k : â„•) â†’ Dec (Twin k)
twinDec k = decÃ— (primeDec k) (primeDec (suc (suc k)))

-- fold the DECISIONS, not booleans: the count is born certified
walk : â„• â†’ â„• â†’ â„• â†’ â„•
walk zero    k c = c
walk (suc f) k c with twinDec k
... | yes _ = walk f (suc k) (suc c)
... | no  _ = walk f (suc k) c

-- pressed: eight twin pairs start below 100, counted through certificates
_ : walk 98 2 0 â‰¡ 8
_ = refl
