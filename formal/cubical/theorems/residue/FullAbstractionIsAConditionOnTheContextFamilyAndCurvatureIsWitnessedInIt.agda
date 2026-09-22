{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt
--
-- ON THE NAME.  Contextual equivalence and full abstraction are
-- Milner's and Plotkin's (1977); there is no Indian source term for
-- them and none is invented.
--
-- ────────────────────────────────────────────────────────────────────
--
--   "**Theorem 28.14 (flat compression):** fully abstract compression
--    for all arising contexts preserves semantics for every order.
--    Curvature arises only from too-small context families,
--    approximation, dropped witnesses, or incoherent interface
--    updates."
--
-- A context family appears here, and with it the theorem.
--
-- WHAT IS PROVED
--
--   CtxEq p q        contextual equivalence RELATIVE TO A FAMILY: the
--                    family is a type `K` of indices with `ctxOf :
--                    K → Ctx`, so "too small" and "all arising" are
--                    both expressible, which is the whole point
--   FullyAbstract C  the compression identifies whatever the family
--                    cannot separate
--   flatCompressionPreservesEveryOrder
--                    **Theorem 28.14**: if two elimination orders are
--                    contextually equivalent at every input, a fully
--                    abstract compression sends them to the SAME value
--                    — "for every order" being an arbitrary pair of
--                    composites, not two fixed steps
--   curvatureIsWitnessedInTheFamily
--                    the contrapositive, and the sharper reading of
--                    §36–38's causal list: if the images differ, the
--                    family already separates the two orders
--   curvatureExhibitsAContext
--                    and when the family is ENUMERATED and the
--                    observation type is DISCRETE, the separating
--                    context can be produced — a Σ, not a double
--                    negation
--
-- **WHY THE FAMILY BEING A PARAMETER IS THE CONTENT.**  §36–38 blames
-- curvature on "too-small context families" without a family in the
-- statement; once `K` is a parameter, "fully abstract for all arising
-- contexts" and "fully abstract for a small family" are the SAME
-- theorem at different `K`, and the difference in conclusion is
-- visible: a smaller `K` makes `CtxEq` easier, hence `FullyAbstract`
-- harder, hence the hypothesis of 28.14 stronger.  The note's causal
-- claim is, in this reading, the observation that shrinking `K` breaks
-- the hypothesis — not that it creates curvature by some other route.
--
-- **THE COST OF THE WITNESS.**
-- `curvatureIsWitnessedInTheFamily` gives `� CtxEq`, a double
-- negation; turning it into a context needs two hypotheses:
-- enumerability of the index and decidability of the
-- observation — through the same lemma, `decΣOverEnumerated`.
------------------------------------------------------------------------

module FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary
  using (¬_ ; Dec ; yes ; no ; Discrete ; Dec→Stable)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Enumerated ; decΣOverEnumerated)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (decNeg)

module _ {Tm O : Type} (Ctx : Type) (plug : Ctx → Tm → Tm) (obs : Tm → O)
         (K : Type) (ctxOf : K → Ctx)
  where

  ------------------------------------------------------------------
  -- 1.  Contextual equivalence, relative to the family
  ------------------------------------------------------------------

  CtxEq : Tm → Tm → Type
  CtxEq p q = (k : K) → obs (plug (ctxOf k) p) ≡ obs (plug (ctxOf k) q)

  module _ {D : Type} (C : Tm → D) where

    FullyAbstract : Type
    FullyAbstract = (p q : Tm) → CtxEq p q → C p ≡ C q

    ----------------------------------------------------------------
    -- 2.  Theorem 28.14
    ----------------------------------------------------------------

    flatCompressionPreservesEveryOrder :
      FullyAbstract → (r₁ r₂ : Tm → Tm)
      → ((p : Tm) → CtxEq (r₁ p) (r₂ p))
      → (p : Tm) → C (r₁ p) ≡ C (r₂ p)
    flatCompressionPreservesEveryOrder fa r₁ r₂ eqv p = fa (r₁ p) (r₂ p) (eqv p)

    ----------------------------------------------------------------
    -- 3.  Curvature is separation inside the family
    ----------------------------------------------------------------

    curvatureIsWitnessedInTheFamily :
      FullyAbstract → (p q : Tm) → ¬ (C p ≡ C q) → ¬ CtxEq p q
    curvatureIsWitnessedInTheFamily fa p q ¬eq ce = ¬eq (fa p q ce)

    curvatureExhibitsAContext :
      Enumerated K → Discrete O → FullyAbstract
      → (p q : Tm) → ¬ (C p ≡ C q)
      → Σ[ k ∈ K ] ¬ (obs (plug (ctxOf k) p) ≡ obs (plug (ctxOf k) q))
    curvatureExhibitsAContext en dO fa p q ¬eq
      with decΣOverEnumerated en
             (λ k → ¬ (obs (plug (ctxOf k) p) ≡ obs (plug (ctxOf k) q)))
             (λ k → decNeg (dO (obs (plug (ctxOf k) p))
                               (obs (plug (ctxOf k) q))))
    ... | yes w  = w
    ... | no ¬w  =
      ⊥.rec (curvatureIsWitnessedInTheFamily fa p q ¬eq
              (λ k → Dec→Stable
                       (dO (obs (plug (ctxOf k) p)) (obs (plug (ctxOf k) q)))
                       (λ ¬e → ¬w (k , ¬e))))

------------------------------------------------------------------------
-- THE CONVERSE.  Everything above states ONE implication,
-- `CtxEq p q → C p ≡ C q`.  The converse is proved in
-- `AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem`.
--
-- **AND THE CONVERSE IS NOT A SECOND HYPOTHESIS.**  It follows from two
-- premises about `C`, by `cong` three times:
--
--   Compositional   C (plug c t) ≡ act c (C t)
--   Factors         obs t ≡ obsD (C t)
--
-- so `C p ≡ C q → CtxEq p q` costs no decidability, no enumerability,
-- and does not use `FullyAbstract`.  Together with `FullyAbstract` it
-- gives that `CtxEq` IS the kernel of `C`, not merely contained in it.
--
-- **WHAT THAT MAKES VISIBLE.**
-- `curvatureExhibitsAContext` above pays `Enumerated K` + `Discrete O`
-- + `FullyAbstract` to produce a separating context from `¬ (C p ≡ C q)`.
-- The OPPOSITE direction — a separating context yielding
-- `� (C p ≡ C q)` — is free at the recording site.
-- **The cost is not the statement's, it is the
-- DIRECTION's.**  One way is a congruence.  The other is a search.
------------------------------------------------------------------------
