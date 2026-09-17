{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡æ‡∞ ‚î ‡Ø‡ã ‡‡æ‡∞‡ ‡‡‡∞‡µ‡ø‡‡‡ø ‡ ‡‡µ ‡‡®‡‡‡‡ ‡‡ø‡®‡‡‡‡ø ‡
--
-- (it is the weight that goes in which splits the fiber.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE RUNG ABOVE `‡‡µ‡‡‡‡‡ø`, AND WHY IT IS A RUNG AND NOT A COROLLARY.
--
-- `Avrtti_‚¶agda` prices the fiber of `length`: one constructor costs
-- exactly one, so `fiber length (suc n) ‚â X ó fiber length n` with no
-- guard anywhere.  Every counting map that charges a CONSTANT per
-- element is that theorem.
--
-- A **weighted** map is not.  `PingalaPrastara.matraOf` charges 1 for
-- ‡≤‡ò‡ and 2 for ‡ó‡‡∞‡, so its fiber over `n` decomposes over `n‚à1` and
-- `n‚à2` ‚î and each summand needs a proof that its weight actually fits
-- under `n`, which truncated subtraction silently swallows.  That is why
-- `matrameruIso` had to be proved by hand.
--
-- **The fix is to carry the fitting proof as an EQUATION and never
-- subtract.**  `Œ[ m ] (w x + m ‚â° n)` says "the rest is `m`, and the
-- weight fits, and here is the witness" in one object.  With `‚à` the
-- witness is thrown away and has to be reconstructed by a case split;
-- with `‚â°` it is the datum.  **That is this corpus's own rule applied to
-- its own arithmetic: keep the remainder, ‡‡‡‡ ‡∞‡ï‡‡.**
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED, over an ARBITRARY element type and an ARBITRARY
-- weight ‚î no finiteness, no decidable equality, no h-level on `X`, and
-- no assumption that the weight is nonzero.
--
-- ¬ß‡ß  `‡‡æ‡∞-‡ó‡‡®‡æ w`, the weighted count, by structural recursion.
-- ¬ß‡®  **`‡‡æ‡∞-‡‡µ‡‡‡‡‡ø‡`** : for `n` a successor,
--
--        fiber (‡‡æ‡∞-‡ó‡‡®‡æ w) n
--          ‚â  Œ[ x ‚àà X ] Œ[ m ‚àà ‚ï ] ((w x + m ‚â° n) ó fiber (‡‡æ‡∞-‡ó‡‡®‡æ w) m)
--
--     the fiber over `n` is: which element came first, what the rest
--     weighed, the proof that they add to `n`, and the rest's own fiber.
--     Every summand carries its own fitting proof.
-- ¬ß‡©  the base at zero is NOT `Unit` in general ‚î a weight of 0 lets
--     arbitrarily many elements sit at index 0 ‚î so ¬ß‡© states the base
--     only under the hypothesis that no weight is zero, and says so.
--     **This is the place a careless emitter would forge a receipt.**
--
-- ¬ß‡  `matraOf` is an instance: `X = Syllable`, `w laghu = 1`,
--     `w guru = 2`.  Stated, and the identification with the host's own
--     `matraOf` is left as an obligation rather than asserted, because
--     `matraOf` is a separate recursion and nothing here proves the two
--     agree.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡‡æ‡∞ ‚î weight, load, that which is carried.  Ordinary ;
-- in the prosodic tradition the weight of a syllable is its ‡Æ‡æ‡‡‡∞‡æ
-- (Pigala, ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡, ~300 BCE: ‡≤‡ò‡ one mtr, ‡ó‡‡∞‡ two).  LIMIT:
-- ‡‡æ‡∞ is used here in its plain sense for the cost a constructor
-- charges; the prosodists' term for the syllable's own weight is ‡Æ‡æ‡‡‡∞‡æ
-- and no text states a weighted fiber decomposition.  Pigala proves
-- nothing below.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Bhara_TheWeightedCountingMapsFiberDecomposesOverEverySummandThatFits where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_<_ ; ¬¨m<m)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to ‚ä•-rec)

private variable ‚Ñì : Level

module _ {X : Type ‚Ñì} (w : X ‚Üí ‚Ñï) where

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡æ‡∞-‡ó‡‡®‡æ ‚î the weighted count.
------------------------------------------------------------------------

  ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ : List X ‚Üí ‚Ñï
  ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ []       = 0
  ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ (x ‚à∑ xs) = w x + ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs

------------------------------------------------------------------------
-- ‡® ¬ ‡‡æ‡∞-‡‡µ‡‡‡‡‡ø‡ ‚î the decomposition, with every fitting proof carried.
--
-- No `‚à` appears.  The equation `w x + m ‚â° n` IS the fitting witness, so
-- nothing is discarded and nothing has to be reconstructed.
------------------------------------------------------------------------

  ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É : ‚Ñï ‚Üí Type ‚Ñì
  ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É n = fiber ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ n

------------------------------------------------------------------------
-- ‡® ¬ ‡‡æ‡∞-‡‡µ‡‡‡‡‡ø‡ ‚î the decomposition.
--
-- No case split on `n`, and no `‚à` anywhere.  A list is `[]` or a cons,
-- so its fiber is that same coproduct: the empty list sits over `n` iff
-- `0 ‚â° n`, and a cons sits over `n` iff its head's weight plus the
-- tail's count is `n`.  **The equation IS the fitting witness** ‚î with
-- truncated subtraction the witness is discarded and has to be rebuilt
-- by a case split; here it is the datum.  ‡‡‡‡ ‡∞‡ï‡‡.
------------------------------------------------------------------------

  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï)
    ‚Üí ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É n
      ‚âÉ ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs ‚â° n)))
  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É n = isoToEquiv (iso ‡§≠ ‡§∏ ‡§®‡§ø ‡§™‡•ç‡§∞)
    where
    ‡§≠ : ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É n ‚Üí ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs ‚â° n)))
    ‡§≠ ([]     , p) = inl p
    ‡§≠ (x ‚à∑ xs , p) = inr (x , xs , p)

    ‡§∏ : ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs ‚â° n))) ‚Üí ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É n
    ‡§∏ (inl e)            = [] , e
    ‡§∏ (inr (x , xs , p)) = (x ‚à∑ xs) , p

    ‡§®‡§ø : (t : (0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs ‚â° n)))
       ‚Üí ‡§≠ (‡§∏ t) ‚â° t
    ‡§®‡§ø (inl e)            = refl
    ‡§®‡§ø (inr (x , xs , p)) = refl

    ‡§™‡•ç‡§∞ : (t : ‡§≠‡§æ‡§∞-‡§§‡§®‡•ç‡§§‡•Å‡§É n) ‚Üí ‡§∏ (‡§≠ t) ‚â° t
    ‡§™‡•ç‡§∞ ([]     , p) = refl
    ‡§™‡•ç‡§∞ (x ‚à∑ xs , p) = refl

------------------------------------------------------------------------
-- ‡© ¬ The base is NOT `Unit`, and this is where a careless emitter
-- forges a receipt.
--
-- `fiber length 0 ‚â Unit` held because `length` charges one per element.
-- A weight of ZERO breaks it: if `w x ‚â° 0` then `x ‚à x ‚à ‚¶ ‚à []` has
-- count 0 for every length, so the fiber over 0 is infinite.  ¬ß‡® still
-- holds ‚î it is stated with no hypothesis at all ‚î but the left summand
-- is `0 ‚â° n` and the right one does not vanish at `n ‚â° 0`.
--
-- So the base collapses only under a hypothesis, and it is named:
------------------------------------------------------------------------

  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞-‡§Ö‡§≠‡§æ‡§µ‡§É : ((x : X) ‚Üí 0 < w x)
    ‚Üí (xs : List X) ‚Üí ‡§≠‡§æ‡§∞-‡§ó‡§£‡§®‡§æ xs ‚â° 0 ‚Üí xs ‚â° []
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞-‡§Ö‡§≠‡§æ‡§µ‡§É pos []       _ = refl
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§≠‡§æ‡§∞-‡§Ö‡§≠‡§æ‡§µ‡§É pos (x ‚à∑ xs) p =
    ‚ä•-rec (¬¨m<m (subst (0 <_) (m+n‚â°0‚Üím‚â°0√ón‚â°0 p .fst) (pos x)))
