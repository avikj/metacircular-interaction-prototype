{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.DurationIsSyllablesPlusGuru
--
-- The surviving route from `Sankalita` §13, taken one step.
--
-- Three encodings of the mātrāmeru/meru diagonal identity were refuted
-- there, each differently, leaving one: Piṅgala's own argument, which
-- sorts patterns by syllable count instead of manipulating sums.  Its
-- heart is a one-line induction, and here it is.
--
-- ────────────────────────────────────────────────────────────────────
-- THE LEMMA
--
--     matra-split :  matrāOf p  ≡  varṇa p + guruOf p
--
-- Duration equals syllable count plus guru count, because a laghu weighs
-- one mātrā and a guru weighs two.  Trivial, and it is exactly what
-- reparametrises the identity out of subtraction: a pattern of duration
-- `n` with `a` syllables and `b` guru satisfies `a + b ≡ n`, with no
-- `n − k` anywhere.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT BUYS
--
--     metre-sorts :  Metre n  ≃  Σ[ (a,b) : a + b ≡ n ] Chosen a b
--
-- — "a metre of duration `n` is a choice of how many syllables and how
-- many of them are guru, then a pattern with those statistics" — is now a
-- statement with no truncated subtraction in it, which is what killed the
-- second encoding.  `metre-to-sorted` and `sorted-to-metre` below are the
-- two maps; the equivalence needs a Σ-contraction and is not assembled
-- here.
--
-- Taking cardinalities of that statement, with `Pingala.matraCount` and
-- `Pingala.meruCount`, is the diagonal identity — and the remaining step
-- is the cardinality of a Σ over a finite index, which is
-- `Cubical.Data.FinSet.Cardinality` machinery and is named, not waved at.
--
-- WHAT IS NOT CLAIMED.  The equivalence, and hence the identity.  What is
-- claimed is that the obstacle common to all three refuted encodings —
-- subtraction, or a family not closed under reindexing — is absent from
-- this formulation, and the lemma that makes it absent is checked.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.DurationIsSyllablesPlusGuru where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)

open import Mula.PingalaPrastara
  using ( Pattern ; Syllable ; laghu ; guru ; mora
        ; matraOf ; varna ; guruOf ; Metre ; Chosen )

------------------------------------------------------------------------
-- 1.  THE LEMMA.  Duration is syllables plus guru.
------------------------------------------------------------------------

matra-split : (p : Pattern) → matraOf p ≡ varna p + guruOf p
matra-split [] = refl
matra-split (laghu ∷ p) = cong suc (matra-split p)
matra-split (guru ∷ p) =
    cong (λ z → suc (suc z)) (matra-split p)
  ∙ cong suc (sym (+-suc (varna p) (guruOf p)))

------------------------------------------------------------------------
-- 2.  The two maps of the sorting statement
------------------------------------------------------------------------

Sorted : ℕ → Type
Sorted n = Σ[ ab ∈ (ℕ × ℕ) ] ((fst ab + snd ab ≡ n) × Chosen (fst ab) (snd ab))

metre-to-sorted : (n : ℕ) → Metre n → Sorted n
metre-to-sorted n (p , dur) =
  (varna p , guruOf p) , (sym (matra-split p) ∙ dur) , (p , refl , refl)

sorted-to-metre : (n : ℕ) → Sorted n → Metre n
sorted-to-metre n ((a , b) , sum , (p , va , gu)) =
  p , (matra-split p ∙ cong₂ _+_ va gu ∙ sum)

------------------------------------------------------------------------
-- 3.  One round trip is immediate — the pattern is untouched
------------------------------------------------------------------------

roundtrip-pattern :
  (n : ℕ) (m : Metre n) → fst (sorted-to-metre n (metre-to-sorted n m)) ≡ fst m
roundtrip-pattern n (p , _) = refl

------------------------------------------------------------------------
-- 4.  Where the thread stands.
--
-- `Sankalita` §13 left one route standing out of four.  This file shows
-- its first step goes through, and that the reparametrisation removes the
-- obstacle the other three died of: there is no `n − k` in `Sorted`, and
-- the index set `{(a,b) : a + b ≡ n}` is closed under the reindexing the
-- Pascal step performs, because it is symmetric in the two coordinates.
--
-- What is left is a Σ-contraction (both round trips) and a cardinality
-- transfer.  Neither is an obstacle of the kind that killed the others,
-- and saying so this time is backed by the two maps existing.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  The Σ-contraction, and the equivalence.
--
-- Both round trips leave the PATTERN untouched — that is what
-- `roundtrip-pattern` records — so every remaining component is an
-- equation in ℕ, hence a proposition, hence transported by
-- `isProp→PathP`.  The contraction is that observation and nothing else.
------------------------------------------------------------------------

open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (isSetℕ)

metre-roundtrip :
  (n : ℕ) (m : Metre n) → sorted-to-metre n (metre-to-sorted n m) ≡ m
metre-roundtrip n (p , dur) =
  ΣPathP (refl , isProp→PathP (λ _ → isSetℕ _ _) _ _)

sorted-roundtrip :
  (n : ℕ) (s : Sorted n) → metre-to-sorted n (sorted-to-metre n s) ≡ s
sorted-roundtrip n ((a , b) , sum , (p , va , gu)) =
  ΣPathP ( ΣPathP (va , gu)
         , ΣPathP ( isProp→PathP (λ _ → isSetℕ _ _) _ _
                  , ΣPathP ( refl
                           , ΣPathP ( isProp→PathP (λ _ → isSetℕ _ _) _ _
                                    , isProp→PathP (λ _ → isSetℕ _ _) _ _ ) ) ) )

metre-sorts-Iso : (n : ℕ) → Iso (Metre n) (Sorted n)
Iso.fun      (metre-sorts-Iso n) = metre-to-sorted n
Iso.inv      (metre-sorts-Iso n) = sorted-to-metre n
Iso.rightInv (metre-sorts-Iso n) = sorted-roundtrip n
Iso.leftInv  (metre-sorts-Iso n) = metre-roundtrip n

-- THE STATEMENT.  A metre of duration n IS a choice of syllable count and
-- guru count summing to n, together with a pattern having those
-- statistics.  Piṅgala's sorting, as an equivalence.
metre-sorts : (n : ℕ) → Metre n ≃ Sorted n
metre-sorts n = isoToEquiv (metre-sorts-Iso n)

------------------------------------------------------------------------
-- 6.  What is left is now one step, and it is a cardinality.
--
-- `metre-sorts` is the typed diagonal identity.  Taking cardinalities
-- gives the numeric one:
--
--     mātrā n  ≡  Σ_{a+b=n} meru a b   ( = `Sankalita.antidiag n` )
--
-- via `Pingala.matraCount` on the left, `Pingala.meruCount` inside the
-- sum on the right, and the cardinality of a Σ over a finite index —
-- `Cubical.Data.FinSet.Cardinality`.  That last is the only remaining
-- ingredient, and unlike the three obstacles `Sankalita` §13 records, it
-- is a library lemma rather than a reformulation.
--
-- Four encodings, three refuted, one carried to an equivalence.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  CORRECTION to §6: "a library lemma" was checked and is not the
--     whole of it.
--
-- §6 says the remaining ingredient is `Cubical.Data.FinSet.Cardinality`
-- and calls it a library lemma rather than a reformulation.  The lemma is
-- real —
--
--     cardΣ : card (Σ X Y) ≡ sum X (λ x → card (Y x))
--
-- — but it takes `X` as a **FinSet**, and the index set here,
-- `Σ[ (a,b) ] (a + b ≡ n)`, does not arrive with a finiteness proof.  So
-- two ingredients are needed, not one:
--
--   (i)  the index set is finite;
--   (ii) the library's `sum` over that FinSet is the recursive sum
--        `Sankalita.AD` — a reindexing, and the third refuted encoding of
--        `Sankalita` §13 was exactly a reindexing going wrong.
--
-- (i) IS AVAILABLE, and structurally, which is worth recording because it
-- was the sticking point everywhere else.  Induct on `n`:
--
--     Σ[ (a,b) ] (a + b ≡ 0)        ≃  Unit
--     Σ[ (a,b) ] (a + b ≡ suc n)    ≃  Unit ⊎ Σ[ (a,b) ] (a + b ≡ n)
--
-- — the first summand is the pair `(0 , suc n)`, the rest have `a` a
-- successor and drop to the previous level.  No subtraction, and the
-- recursion is the one `AD` already walks, which is a good sign for (ii).
--
-- So: one ingredient is a library lemma, one is a short structural
-- induction that is now written down, and one is a reindexing of the kind
-- that has failed here before and should not be called routine again.
--
-- That is the fourth time in this thread that a "what is left" sentence
-- needed correcting.  The pattern is consistent enough to state as a
-- rule: **do not characterise remaining work until you have looked at the
-- thing you are characterising.**  Every one of the four was cheap to
-- check and none of them was checked before being written.
------------------------------------------------------------------------
