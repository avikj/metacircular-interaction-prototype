{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡®‡æ‡∞‡æ‡Ø‡-‡ó‡µ‡æ‡Æ‡-‡‡æ‡‡ ‚î ‡ó‡ã-‡∞‡‡®‡æ-‡‡®‡‡‡‡ ‡‡ø‡∞‡‡ø ‡‡ï-‡µ‡∞‡‡-‡‡‡∞‡ø-‡µ‡∞‡‡-‡‡æ‡ó‡æ‡‡‡Ø‡æ‡ ‡‡ø‡¶‡‡Ø‡‡ ‡
--
-- ‡‡‡∞‡ã‡‡ : ‡®‡æ‡∞‡æ‡Ø‡‡‡‡‡°‡ø‡‡, ‡ó‡‡ø‡‡ï‡‡Æ‡‡¶‡, ‡‡ô‡‡ï‡‡æ‡‡ (‡ß‡©‡‡ ‡à.) ‚î ‡ó‡ã-‡‡∞‡‡ó‡, ‡‡µ‡‡‡‡‡ø‡
--          a(n) = a(n‚àí1) + a(n‚àí3) ; ‡µ‡ø‡∞‡‡æ‡ô‡‡ï‡, ‡µ‡‡‡‡‡‡æ‡‡ø‡‡Æ‡‡‡‡‡Ø‡ (~‡‡¶‡¶‚ì‡Æ‡¶‡¶ ‡à.),
--          ‡Æ‡æ‡‡‡∞‡æ-‡Æ‡‡∞‡‡ (‡¶‡‡µ‡ø-‡‡¶-‡‡µ‡‡‡‡‡ø‡) ‡Ø‡‡‡Ø ‡‡‡‡ ‡‡‡∞‡ø-‡‡¶-‡‡ó‡ø‡®‡-‡∞‡‡‡Æ‡ ‡
--
-- ‡µ‡ø‡∞‡‡æ‡ô‡‡ï‡‡‡Ø {‡ß,‡®}-‡Æ‡æ‡‡‡∞‡æ-‡‡®‡‡‡‡ (Virahanka.agda) ‡‡ø‡∞‡‡ø ‡¶‡‡µ‡‡ß‡æ ‡‡ø‡¶‡‡Ø‡‡ ; ‡®‡æ‡∞‡æ‡Ø‡‡‡‡Ø
-- ‡ó‡ã-‡‡‡∞‡‡‡ {‡ß,‡©}-‡‡æ‡ó‡à‡ (‡‡ï-‡µ‡∞‡‡‡ ‡µ‡æ ‡‡‡∞‡ø-‡µ‡∞‡‡‡) ‡∞‡‡‡Ø‡‡ , ‡‡‡ ‡‡‡‡Ø‡æ‡ ‡‡®‡‡‡‡ ‡‡ø‡∞‡‡ø
-- ‡‡‡∞‡‡ß‡æ-‡Æ‡æ‡∞‡‡ó‡‡ ‡¶‡‡µ‡‡ß‡æ ‡‡ø‡¶‡‡Ø‡‡ : ‡‡‡∞‡‡-‡‡æ‡ó‡ ‡‡ï-‡µ‡∞‡‡‡ (‡‡æ‡∞‡ ‡ß, ‡‡‡‡ n‚àí1) ‡µ‡æ
-- ‡‡‡∞‡ø-‡µ‡∞‡‡‡ (‡‡æ‡∞‡ ‡©, ‡‡‡‡ n‚àí3) ‡  ‡‡‡æ ‡‡‡¶‡‡ß‡æ ‡‡®‡‡‡-‡‡‡≤‡‡Ø‡‡æ (equivalence of fibres) ,
-- ‡® ‡ó‡‡®‡æ ‡® ‡‡ø‡‡‡°‡ø‡-‡∞‡‡‡Æ‡ : ‡‡‡ñ‡‡Ø‡æ ‡‡‡‡Ø‡æ‡ ‡‡æ‡Ø‡æ ‡Æ‡æ‡‡‡∞‡Æ‡ ‡
--
-- ‡‡‡‡∞ ‡Ø‡‡ *‡®* ‡‡æ‡ß‡‡Ø‡‡ : ‡® ‡ï‡‡‡‡ø‡‡ ‡‡‡µ‡‡-‡∞‡‡‡ (closed form) , ‡® ‡‡ø‡‡‡°‡ø‡‡ ‡Ø‡ã‡ó‡ ,
-- ‡® ‡®‡æ‡∞‡æ‡Ø‡‡‡® ‡‡‡æ ‡‡®‡‡‡-‡∞‡‡‡‡ ‡â‡ï‡‡‡æ ‚î ‡ï‡‡µ‡≤‡ ‡‡‡‡Ø {‡ß,‡©}-‡‡µ‡‡‡‡‡‡ ‡‡®‡‡‡-‡‡‡‡æ‡®‡Æ‡ ‡
--
-- (Nryaa Paita, Gaitakaumud, akapa, 1356 CE: the cow sequence
--  a(n) = a(n‚àí1) + a(n‚àí3), built from {1,3}-compositions.  As Virahka's
--  {1,2}-mtr fibre splits at the head into two branches, this {1,3}-fibre
--  splits at the head into the one-year branch (weight 1, remainder n‚àí1) and
--  the three-year branch (weight 3, remainder n‚àí3).  An EQUIVALENCE OF FIBRES,
--  not a count: the numbers are its shadow.  Claimed of the source: only the
--  {1,3} recurrence; the fibre statement and its proof are made here.)
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, --safe, exit 0.
------------------------------------------------------------------------

module NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; isSet‚Ñï ; injSuc ; znots)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; Œ£‚â°Prop)
open import Cubical.Data.Empty as Empty using (‚ä•)

-- one part is worth one year (‡‡ï-‡µ‡∞‡‡‡) or three years (‡‡‡∞‡ø-‡µ‡∞‡‡‡)
‡§µ‡§∞‡•ç‡§∑‡§É : Bool ‚Üí ‚Ñï
‡§µ‡§∞‡•ç‡§∑‡§É true  = 1
‡§µ‡§∞‡•ç‡§∑‡§É false = 3

-- the total maturation weight of a composition (‡ó‡ã-‡‡∞‡‡ó‡‡‡Ø ‡‡æ‡∞‡)
‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É : List Bool ‚Üí ‚Ñï
‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É []       = 0
‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (x ‚à∑ xs) = ‡§µ‡§∞‡•ç‡§∑‡§É x + ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É xs

-- the fibre's witness is a proposition, because ‚ï is a set
‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä : {n : ‚Ñï} (l : List Bool) ‚Üí isProp (‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É l ‚â° n)
‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä _ = isSet‚Ñï _ _

-- the three-step head split: fibre at (3+n) ‚â fibre at (2+n) ‚ä fibre at n
‡§®‡§æ‡§∞‡§æ‡§Ø‡§£-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï)
  ‚Üí fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc (suc n)))
      ‚âÉ (fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc n)) ‚äé fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É n)
‡§®‡§æ‡§∞‡§æ‡§Ø‡§£-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É n = isoToEquiv (iso ‡§≠‡§ô‡•ç‡§ó‡§É ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É)
  where
    ‡§≠‡§ô‡•ç‡§ó‡§É : fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc (suc n)))
          ‚Üí (fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc n)) ‚äé fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É n)
    ‡§≠‡§ô‡•ç‡§ó‡§É ([]         , p) = Empty.rec (znots p)
    ‡§≠‡§ô‡•ç‡§ó‡§É (true  ‚à∑ xs , p) = inl (xs , injSuc p)
    ‡§≠‡§ô‡•ç‡§ó‡§É (false ‚à∑ xs , p) = inr (xs , injSuc (injSuc (injSuc p)))

    ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : (fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc n)) ‚äé fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É n)
            ‚Üí fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc (suc n)))
    ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inl (xs , q)) = (true  ‚à∑ xs) , cong suc q
    ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inr (xs , q)) = (false ‚à∑ xs) , cong (Œª k ‚Üí suc (suc (suc k))) q

    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : _) ‚Üí ‡§≠‡§ô‡•ç‡§ó‡§É (‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É y) ‚â° y
    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inl (xs , q)) = cong inl (Œ£‚â°Prop ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä refl)
    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inr (xs , q)) = cong inr (Œ£‚â°Prop ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä refl)

    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : fiber ‡§∏‡§∞‡•ç‡§ó‡§≠‡§æ‡§∞‡§É (suc (suc (suc n)))) ‚Üí ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (‡§≠‡§ô‡•ç‡§ó‡§É y) ‚â° y
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ([]         , p) = Empty.rec (znots p)
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (true  ‚à∑ xs , p) = Œ£‚â°Prop ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä refl
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (false ‚à∑ xs , p) = Œ£‚â°Prop ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä refl
