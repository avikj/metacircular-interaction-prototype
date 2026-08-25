{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आवृत्ति — तन्तोः आवृत्तिः एव सङ्ख्या ।
--
-- (the fibre's recurrence is exactly the count.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE CLASS THIS PRICES, AND WHY IT NEEDED A DIFFERENT MACHINE.
--
-- `machine/Lopa_…hs` grades 1062 one-way edges; **237 have source ℕ or a
-- list-like type** and no case table will ever reach them, because their
-- domains are infinite.  A finite source is swept by enumeration.  An
-- infinite one has to be priced by an IDENTIFICATION, and the only
-- identification available for a map defined by structural recursion is
-- a RECURRENCE ON ITS FIBRE, read off the map's own clauses.
--
-- Two such were proved by hand in this corpus before anyone noticed they
-- were one thing:
--
--   `Lopa_….fiber योग n ≃ SumFin (suc n)`      — addition's antidiagonal
--   `PingalaPrastara.matrameruIso`
--        : Metre (2+n) ≃ Metre (1+n) ⊎ Metre n  — the मात्रामेरु
--
-- Both are the same move: the map's clauses say what the first
-- constructor costs, so the fibre over `n` decomposes by which
-- constructor came first, over fibres at smaller indices.  **That is the
-- emitter for the whole infinite-domain class**, and this module is its
-- clean case.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED.
--
-- §१  the general recurrence, for ANY element type: the fibre of `length`
--     over a successor is the element type times the fibre below it.
--     `fiber length (suc n) ≃ X × fiber length n`.  Nothing about `X` is
--     assumed — not finiteness, not decidable equality, not an h-level.
-- §२  the base: `fiber length 0 ≃ Unit`.  Only `[]` is empty.
-- §३  Piṅgala's instance, for `varna` as the host actually writes it —
--     and it is not `length` by definition, it is a separate recursion
--     with the same clauses, so the recurrence is re-proved rather than
--     transported, and §३ says so.
-- §४  **the payoff, and it is the point**: `sankhya (suc n) ≡ sankhya n +
--     sankhya n` is the DOUBLING Piṅgala states, and §१ is WHY — the
--     fibre over `suc n` is a two-element type times the fibre over `n`,
--     because a syllable is लघु or गुरु and nothing else.  The count's
--     recurrence is the fibre's recurrence.  छन्दःशास्त्रम् ८.२४–२८
--     gives the procedure; this gives the reason the procedure is right.
--
-- **NOT CLAIMED.**  That every structurally recursive map's fibre has a
-- recurrence this clean.  `length` adds exactly one per constructor, so
-- no truncated subtraction and no guard appears.  A weighted map — where
-- `matraOf` charges 1 for लघु and 2 for गुरु — needs `n ∸ w x` and a
-- proof that the weight fits, which is `matrameruIso`'s extra work and
-- is not done here.  §५ names that as the next rung and does not gesture
-- past it.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  आवृत्ति — turning-back, repetition, recurrence.  Ordinary
-- Sanskrit, and the tradition's own word for the construction rule of
-- the मेरुप्रस्तार as हलायुध states it in the मृतसञ्जीवनी (10th c.) on
-- पिङ्गल's छन्दःशास्त्रम् ८.३४–३५: अग्रिम-पङ्क्तिः पूर्व-पङ्क्तेः
-- पार्श्व-योगैः — the next row from the adjacent sums of the previous.
-- Usually cited under Pascal's name (1654), a restatement six centuries
-- later, named here after the source and as one.
--
-- LIMIT: Piṅgala and Halāyudha state procedures and prove nothing below;
-- no source states a fibre, a type, or an equivalence.  What is claimed
-- is that the objects the pratyayas enumerate ARE the fibres of the
-- counting maps — a fact about the definitions in `PingalaPrastara.agda`.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avrtti_TheFibreOfACountingMapSatisfiesARecurrenceAndThatRecurrenceIsSankhya where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to ⊥-rec)

open import SourcedProofs.PingalaPrastara using (Syllable ; laghu ; guru ; Pattern ; varna ; Vak ; sankhya)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · The recurrence.  No hypothesis on the element type at all.
------------------------------------------------------------------------

module _ {X : Type ℓ} where

  आवृत्तिः : (n : ℕ) → fiber (length {A = X}) (suc n) ≃ (X × fiber (length {A = X}) n)
  आवृत्तिः n = isoToEquiv (iso भङ्गः सङ्घातः निवृत्तिः प्रत्यावृत्तिः)
    where
    भङ्गः : fiber (length {A = X}) (suc n) → X × fiber (length {A = X}) n
    भङ्गः ([]     , p) = ⊥-rec (znots p)
    भङ्गः (x ∷ xs , p) = x , (xs , injSuc p)

    सङ्घातः : X × fiber (length {A = X}) n → fiber (length {A = X}) (suc n)
    सङ्घातः (x , (xs , q)) = (x ∷ xs) , cong suc q

    निवृत्तिः : (y : X × fiber (length {A = X}) n) → भङ्गः (सङ्घातः y) ≡ y
    निवृत्तिः (x , (xs , q)) =
      ΣPathP (refl , Σ≡Prop (λ _ → isSetℕ _ _) refl)

    प्रत्यावृत्तिः : (y : fiber (length {A = X}) (suc n)) → सङ्घातः (भङ्गः y) ≡ y
    प्रत्यावृत्तिः ([]     , p) = ⊥-rec (znots p)
    प्रत्यावृत्तिः (x ∷ xs , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl

------------------------------------------------------------------------
-- २ · The base.  Only the empty list is empty.
------------------------------------------------------------------------

  मूलम् : fiber (length {A = X}) 0 ≃ Unit
  मूलम् = isoToEquiv (iso _ (λ _ → [] , refl) (λ _ → refl) र)
    where
    र : (y : fiber (length {A = X}) 0) → ([] , refl) ≡ y
    र ([]     , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl
    र (x ∷ xs , p) = ⊥-rec (snotz p)

------------------------------------------------------------------------
-- ३ · Piṅगala's instance, RE-PROVED and not transported.
--
-- `varna` is a separate recursion with the same clauses as `length`, so
-- they are not definitionally one function.  The recurrence is therefore
-- established again here for `varna` itself — three lines, and honest —
-- rather than moved across an identification nobody has written.
------------------------------------------------------------------------

वाक्-आवृत्तिः : (n : ℕ) → Vak (suc n) ≃ (Syllable × Vak n)
वाक्-आवृत्तिः n = isoToEquiv (iso भ स नि प्र)
  where
  भ : Vak (suc n) → Syllable × Vak n
  भ ([]     , p) = ⊥-rec (znots p)
  भ (s ∷ ps , p) = s , (ps , injSuc p)

  स : Syllable × Vak n → Vak (suc n)
  स (s , (ps , q)) = (s ∷ ps) , cong suc q

  नि : (y : Syllable × Vak n) → भ (स y) ≡ y
  नि (s , (ps , q)) = ΣPathP (refl , Σ≡Prop (λ _ → isSetℕ _ _) refl)

  प्र : (y : Vak (suc n)) → स (भ y) ≡ y
  प्र ([]     , p) = ⊥-rec (znots p)
  प्र (s ∷ ps , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl

------------------------------------------------------------------------
-- ४ · Why सङ्ख्या doubles.
--
-- `sankhya (suc n) = sankhya n + sankhya n` is what Piṅgala states.  §३
-- is the reason: the fibre over `suc n` is `Syllable × (fibre over n)`,
-- and a syllable is लघु or गुरु and nothing else.  **The count's
-- recurrence IS the fibre's recurrence** — the procedure and its ground,
-- separated by twenty-three centuries and now in one file.
--
-- Stated as the definitional fact it is, so nothing is overclaimed: the
-- doubling holds by `sankhya`'s own clauses, and §३ is what makes it the
-- right definition rather than a stipulation.
------------------------------------------------------------------------

सङ्ख्या-द्वैगुण्यम् : (n : ℕ) → sankhya (suc n) ≡ sankhya n + sankhya n
सङ्ख्या-द्वैगुण्यम् n = refl

------------------------------------------------------------------------
-- ५ · शेषः — the next rung, named rather than gestured at.
--
-- `length` charges exactly one per constructor, so §१ has no truncated
-- subtraction and no guard.  A WEIGHTED counting map does: `matraOf`
-- charges 1 for लघु and 2 for गुरु, so its fibre over `n` decomposes as
-- the fibre over `n ∸ 1` plus the fibre over `n ∸ 2`, and each summand
-- needs a proof that the weight fits.  That is exactly
-- `PingalaPrastara.matrameruIso`, proved by hand, and the general
-- weighted emitter is not written here.
--
-- ~~The general shape it would have: for `f : List X → ℕ` with
-- `f [] = 0` and `f (x ∷ xs) = w x + f xs`,
--
--     fiber f n  ≃  Σ[ x ∈ X ] Σ[ m ∈ ℕ ] (w x + m ≡ n) × fiber f m
--
-- with the base at `n ≡ 0`.  Every summand carries its own fitting
-- proof, which is why the weighted case is a rung above §१ and not a
-- corollary of it.~~
--
-- **STRUCK 2026-08-23 — THE SHAPE CANNOT HOLD AS STATED, and the rung is
-- written.**  The empty list inhabits `fiber f 0` and has no head `x` to
-- produce, so the right-hand side is uninhabited where the left is not.
-- "The base at `n ≡ 0`" names the gap without closing it: the nil case is
-- not a base condition on `n`, it is a SEPARATE SUMMAND, and the honest
-- decomposition is a coproduct:
--
--     fiber f n ≃ (0 ≡ n) ⊎ (Σ[ x ∈ X ] Σ[ xs ∈ List X ] (w x + f xs ≡ n))
--
-- And the second sentence is wrong in the other direction: no summand
-- constructs a fitting proof.  `f (x ∷ xs)` REDUCES to `w x + f xs`, so
-- the path is carried across unchanged and both round trips close by
-- `refl` — the guard this paragraph anticipated does not appear.  The
-- `Σ[ m ]` form above is equivalent anyway, since `Σ[ m ] (f xs ≡ m) × …`
-- carries a contractible `singl (f xs)`.
--
-- Written and checked at
-- `Bharavrtti_TheWeightedCountingMapsFibreDecomposesByHeadWeightAndTheNilCaseIsASeparateSummand.agda`,
-- exit 0.  The rung IS above §१ — that part stands — but for the reason
-- that the codomain splits, not because fitting proofs must be built.
