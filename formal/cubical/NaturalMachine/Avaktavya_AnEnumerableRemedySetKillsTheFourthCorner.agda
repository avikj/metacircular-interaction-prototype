{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AnEnumerableRemedySetKillsTheFourthCorner
--
-- `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift` showed
-- that at a single instance the fourth corner IS a counterexample to
-- the double-negation shift, and left EXISTENCE open with the remark
-- that a model would be needed.  It also recorded that the earlier
-- `Enumerated` hypothesis on the INSTANCE set was INERT there —
-- `Enumerated Unit` is immediate, so enumerability of instances cannot
-- be what separates the corner from its absence.
--
-- Enumerability of the REMEDY set is a different matter, and it is not
-- inert: it kills the corner outright.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   All / allFromPointwise / allAtMember
--                     the recursive family and its two directions
--   finiteDNSList     the double-negation shift holds over a LIST:
--                     `All (¬¬ P) xs → ¬ ¬ All P xs`, by induction, with
--                     no decidability and no choice
--   finiteDNS         hence over an ENUMERATED type:
--                     `((r) → ¬ ¬ Q r) → ¬ ¬ ((r) → Q r)`
--   theFourthCornerNeedsANonEnumerableRemedySet
--                     so at a single instance the fourth corner refutes
--                     `Enumerated R`
--
-- **The two enumerability hypotheses are not symmetric, and that is the
-- finding.**  Enumerating the INSTANCES buys nothing — one instance
-- already suffices for the corner, and one instance is enumerable.
-- Enumerating the REMEDIES buys everything: DNS becomes a theorem, and
-- the corner cannot exist.  An earlier module reached for `Enumerated`
-- on the wrong side of the pair and this says which side it belonged
-- on.  Where the corner can live is now: a NON-ENUMERABLE remedy set
-- with a badness that is not stable.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  That DNS holds over a finite index is elementary and
-- classical in the constructive literature — DNS is only interesting
-- for infinite domains, which is exactly why Spector's bar recursion
-- concerns `ℕ`.  It is proved here because this corpus reached for
-- enumerability twice without noticing the two sides differ.
--
-- WHAT IS STILL NOT CLAIMED.  EXISTENCE, as ever: this narrows where
-- the corner can be and exhibits nothing.  `Enumerated` carries a
-- CHOSEN list, so "non-enumerable" here means "no such list and
-- covering proof is given", not any cardinality claim.  The result is
-- for the ONE-INSTANCE family, where `¬ सामयिक` reduces to pointwise
-- `¬ ¬`; for a general instance set that reduction fails and nothing
-- here applies.  `finiteDNSList` gives `¬ ¬ All`, never `All` — no
-- decidability is used and none is smuggled in, so this does not say
-- finite domains make everything decidable.
--
-- School named: सामयिक and नित्य are `AnuktaAvaktavya`'s, another
-- identity's, used unchanged; DNS is from proof theory and no claim is
-- made that the two traditions are talking about one thing.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Avaktavya_AnEnumerableRemedySetKillsTheFourthCorner where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import NaturalMachine.Avaktavya_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; Enumerated)
open import NaturalMachine.Avaktavya_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one ; DNSFailure ; fourthCornerGivesDNSFailure)

private
  variable
    A R : Type

------------------------------------------------------------------------
-- 1.  All, and its two directions
------------------------------------------------------------------------

All : (P : A → Type) → List A → Type
All P []       = Unit
All P (x ∷ xs) = P x × All P xs

allFromPointwise :
  (P : A → Type) → ((a : A) → P a) → (xs : List A) → All P xs
allFromPointwise P f []       = tt
allFromPointwise P f (x ∷ xs) = f x , allFromPointwise P f xs

allAtMember :
  (P : A → Type) (xs : List A) (a : A)
  → All P xs → Any (λ y → y ≡ a) xs → P a
allAtMember P []       a _          e       = ⊥.rec e
allAtMember P (x ∷ xs) a (p , _)    (inl q) = subst P q p
allAtMember P (x ∷ xs) a (_ , rest) (inr m) = allAtMember P xs a rest m

------------------------------------------------------------------------
-- 2.  The double-negation shift holds over a list
--
-- No decidability, no choice: the negative translation of a finite
-- conjunction is a finite conjunction of negative translations, and
-- the induction is one line.
------------------------------------------------------------------------

finiteDNSList :
  (P : A → Type) (xs : List A)
  → All (λ a → ¬ ¬ P a) xs → ¬ ¬ All P xs
finiteDNSList P []       _           k = k tt
finiteDNSList P (x ∷ xs) (nnp , rest) k =
  nnp (λ p → finiteDNSList P xs rest (λ ap → k (p , ap)))

------------------------------------------------------------------------
-- 3.  Hence over an enumerated type
------------------------------------------------------------------------

finiteDNS :
  (Q : R → Type) → Enumerated R
  → ((r : R) → ¬ ¬ Q r) → ¬ ¬ ((r : R) → Q r)
finiteDNS {R = R} Q (xs , cov) pointwise k =
  finiteDNSList Q xs (allFromPointwise (λ r → ¬ ¬ Q r) pointwise xs)
    (λ allQ → k (λ r → allAtMember Q xs r allQ (cov r)))

------------------------------------------------------------------------
-- 4.  So the corner needs a non-enumerable remedy set
------------------------------------------------------------------------

theFourthCornerNeedsANonEnumerableRemedySet :
  (Q : R → Type)
  → (¬ सामयिक (one Q)) × (¬ नित्य (one Q))
  → ¬ Enumerated R
theFourthCornerNeedsANonEnumerableRemedySet Q corner enum =
  finiteDNS Q enum (fst d) (snd d)
  where
    d : DNSFailure Q
    d = fourthCornerGivesDNSFailure Q corner
