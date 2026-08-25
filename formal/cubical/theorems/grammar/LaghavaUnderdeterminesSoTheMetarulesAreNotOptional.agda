{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LaghavaUnderdeterminesSoTheMetarulesAreNotOptional
--
-- `Laghava.laghava-is-not-semantic` proves the kernel of `eval` is not
-- empty, and stops there.  It never asks what the fibre looks like.  That
-- is Pāṇini's question rather than a footnote to it: the Aṣṭādhyāyī's
-- method is to choose among presentations of one meaning, and the
-- commentarial tradition celebrates the saving of half a mora — a
-- difference *inside* a fibre — like the birth of a son.
--
-- Two facts about the fibre.
--
--   * लाघव ATTAINS its minimum.  For the meaning `n ↦ n + 1` the minimum
--     is 3, and `three-is-minimal` proves it: an expression of size 1 is
--     `var` or `lit k`, and neither denotes this meaning, while `plus`
--     and `times` are ≥ 3 by construction.
--
--   * **It does not attain it uniquely.**  `plus var (lit 1)` and
--     `plus (lit 1) var` are distinct presentations, both of size 3, with
--     EQUAL denotation — equal, not merely equivalent, because addition
--     on ℕ commutes.
--
-- So brevity does not pick a presentation.  It picks a LEVEL SET, and
-- something else must choose inside it.  That is why the Aṣṭādhyāyī
-- carries परिभाषा — metarules — and an explicit conflict rule
-- (विप्रतिषेधे परं कार्यम्, "of two rules in conflict the later applies"):
-- not as ornament on a brevity criterion but because brevity alone is
-- underdetermined, and without a tie-break the grammar is not a function.
-- The metarules are structurally required, and the tradition supplies
-- them.
--
-- The tie does not go away by sharpening the measure.  Pāṇini counts
-- morae and rule-slots, not nodes; but commutativity of `+` is a fact
-- about the MEANING, so it is invisible to `eval` and survives into every
-- presentation-measure whatsoever.  Any measure blind to a symmetry of
-- the denotation attains its minima non-uniquely, by that fact alone.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the pin.
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module LaghavaUnderdeterminesSoTheMetarulesAreNotOptional where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-comm ; znots ; injSuc)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; zero-≤ ; suc-≤-suc ; ≤-+-≤)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Laghava
  using (Expr ; var ; lit ; plus ; times ; size ; eval)

------------------------------------------------------------------------
-- 1.  One meaning, two shortest presentations of it
------------------------------------------------------------------------

target : ℕ → ℕ
target n = n + 1

left right : Expr
left  = plus var (lit 1)
right = plus (lit 1) var

left-means : eval left ≡ target
left-means = refl

right-means : eval right ≡ target
right-means i n = +-comm 1 n i

sizes-agree : size left ≡ size right
sizes-agree = refl

private
  firstIsVar : Expr → Bool
  firstIsVar (plus var _) = true
  firstIsVar _            = false

left≢right : ¬ (left ≡ right)
left≢right p = true≢false (cong firstIsVar p)

------------------------------------------------------------------------
-- 2.  Three is the minimum
------------------------------------------------------------------------

size≥1 : (e : Expr) → 1 ≤ size e
size≥1 var        = ≤-refl
size≥1 (lit _)    = ≤-refl
size≥1 (plus _ _) = suc-≤-suc zero-≤
size≥1 (times _ _) = suc-≤-suc zero-≤

private
  varFails : ¬ (eval var ≡ target)
  varFails p = znots (cong (λ f → f 0) p)

  litFails : (k : ℕ) → ¬ (eval (lit k) ≡ target)
  litFails k p = znots (injSuc (sym (cong (λ f → f 0) p) ∙ cong (λ f → f 1) p))

three-is-minimal : (e : Expr) → eval e ≡ target → 3 ≤ size e
three-is-minimal var         p = ⊥.rec (varFails p)
three-is-minimal (lit k)     p = ⊥.rec (litFails k p)
three-is-minimal (plus a b)  _ = suc-≤-suc (≤-+-≤ (size≥1 a) (size≥1 b))
three-is-minimal (times a b) _ = suc-≤-suc (≤-+-≤ (size≥1 a) (size≥1 b))

------------------------------------------------------------------------
-- 3.  So the minimum is attained twice, and brevity does not choose
------------------------------------------------------------------------

laghava-underdetermines :
  Σ[ p ∈ Expr ] Σ[ q ∈ Expr ]
    ( (eval p ≡ target) × (eval q ≡ target)
    × (size p ≡ size q)
    × (¬ (p ≡ q)) )
laghava-underdetermines =
  left , right , left-means , right-means , sizes-agree , left≢right
