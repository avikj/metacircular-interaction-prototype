{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- ğ”‰_Î© := Î¦ âˆ˜ Attack âˆ˜ Î“ âˆ˜ Class âˆ˜ ğ” âˆ˜ Î âˆ˜ R,     ğ’_{Î+1} = ğ”‰_Î© ğ’_Î.
--
-- Two theorems and their conjunction:
--
--   halts                    contracting âˆâˆ˜ğ”‰  â’  every question resolves
--   never-final              any quotation of ğ’ leaves an observable outside
--   halting-does-not-close   both at once: ààà°àààà¾ â àà®à¾àààà¿
--
-- à¨ ``ààà°ààà®à¾ààà¡ àà² àà‹ à—à¯à¾'' â” the flow reaching 0 is a theorem about âˆ and
-- Î´_end is a theorem about ââˆ’â; they do not compete, and the second survives
-- the first.

module QuestionMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_<_ ; _â‰¤_ ; zero-â‰¤ ; suc-â‰¤-suc ; pred-â‰¤-pred ; Â¬-<-zero ; â‰¤-trans)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import EndObstruction using (Observable ; Quote ; next-door)

record Machine (ğ’¬ : Typeâ‚€) : Typeâ‚€ where
  constructor machine
  field
    âˆ‚ : ğ’¬ â†’ â„•        -- ğ”‡ âˆ˜ Î· âˆ˜ R : the obstruction carried by a question
    ğ”‰ : ğ’¬ â†’ ğ’¬        -- Î¦ âˆ˜ Attack âˆ˜ Î“ âˆ˜ Class : the classified response

open Machine public

orbit : {ğ’¬ : Typeâ‚€} â†’ Machine ğ’¬ â†’ â„• â†’ ğ’¬ â†’ ğ’¬
orbit M zero q = q
orbit M (suc k) q = orbit M k (ğ”‰ M q)

Resolves : {ğ’¬ : Typeâ‚€} â†’ Machine ğ’¬ â†’ ğ’¬ â†’ Typeâ‚€
Resolves {ğ’¬} M q = Î£[ k âˆˆ â„• ] âˆ‚ M (orbit M k q) â‰¡ 0

Contracting : {ğ’¬ : Typeâ‚€} â†’ Machine ğ’¬ â†’ Typeâ‚€
Contracting {ğ’¬} M = (q : ğ’¬) â†’ 0 < âˆ‚ M q â†’ âˆ‚ M (ğ”‰ M q) < âˆ‚ M q

--------------------------------------------------------------------------
-- ààà°àààà¾ : a contracting machine closes every question it is given
--------------------------------------------------------------------------

private
  â‰¤zeroâ†’â‰¡zero : (n : â„•) â†’ n â‰¤ 0 â†’ n â‰¡ 0
  â‰¤zeroâ†’â‰¡zero zero _ = refl
  â‰¤zeroâ†’â‰¡zero (suc n) p = âŠ¥.rec (Â¬-<-zero p)

  zeroOrPos : (n : â„•) â†’ (n â‰¡ 0) âŠ (0 < n)
  zeroOrPos zero = inl refl
  zeroOrPos (suc n) = inr (suc-â‰¤-suc zero-â‰¤)

  halts-fuel :
      {ğ’¬ : Typeâ‚€} (M : Machine ğ’¬) â†’ Contracting M
    â†’ (fuel : â„•) (q : ğ’¬) â†’ âˆ‚ M q â‰¤ fuel â†’ Resolves M q
  halts-fuel M c zero q h = 0 , â‰¤zeroâ†’â‰¡zero (âˆ‚ M q) h
  halts-fuel M c (suc fuel) q h with zeroOrPos (âˆ‚ M q)
  ... | inl z = 0 , z
  ... | inr pos =
        let room : âˆ‚ M (ğ”‰ M q) â‰¤ fuel
            room = pred-â‰¤-pred (â‰¤-trans (c q pos) h)

            rest : Resolves M (ğ”‰ M q)
            rest = halts-fuel M c fuel (ğ”‰ M q) room
        in suc (fst rest) , snd rest

halts : {ğ’¬ : Typeâ‚€} (M : Machine ğ’¬) â†’ Contracting M â†’ (q : ğ’¬) â†’ Resolves M q
halts M c q = halts-fuel M c (âˆ‚ M q) q (0 , refl)

--------------------------------------------------------------------------
-- àà¨ààà¿à®à—àà°à¨ààà¿à : and it is still not finished
--------------------------------------------------------------------------

never-final :
    {ğ’¬ : Typeâ‚€} (âŒœ_âŒ : Quote ğ’¬)
  â†’ Î£[ d âˆˆ Observable ğ’¬ ] ((q : ğ’¬) â†’ Â¬ (âŒœ q âŒ â‰¡ d))
never-final âŒœ_âŒ = next-door âŒœ_âŒ

-- à‰àààà° â‰  àà¨àà; à‰àààà° = ààà°ààà¨àààà¾à¨àà°à¿àµà°ààà¨à®à
halting-does-not-close :
    {ğ’¬ : Typeâ‚€} (M : Machine ğ’¬) (âŒœ_âŒ : Quote ğ’¬) â†’ Contracting M
  â†’ (q : ğ’¬)
  â†’ Resolves M q Ã— (Î£[ d âˆˆ Observable ğ’¬ ] ((r : ğ’¬) â†’ Â¬ (âŒœ r âŒ â‰¡ d)))
halting-does-not-close M âŒœ_âŒ c q = halts M c q , never-final âŒœ_âŒ
