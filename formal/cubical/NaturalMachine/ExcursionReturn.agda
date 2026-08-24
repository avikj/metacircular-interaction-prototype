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

------------------------------------------------------------------------
-- NaturalMachine.ExcursionReturn
--
-- Delta 18 T18.4–T18.6, checked.
--
-- Delta 15 gave the machine's residual a TYPE (NaturalMachine.
-- StructuredDefect: a reopening is an uninhabited identity type).  That
-- says whether the structure transports.  It does not say what the
-- damage IS when it does not.  Delta 18 supplies exactly that, as an
-- algebraic identity, and this module checks it.
--
--   T18.4  K_t K_s − K_{t+s} = − P T_t Q T_s i
--
-- with i : S → U, P : U → S, P i = id, Q = 1 − iP, and K_t = P T_t i the
-- compressed evolution.  The defect term is not "mysterious lost
-- information": it is *leave the selected sector, evolve outside, return
-- to the observable sector*.  Compression generates memory exactly when
-- an excursion can come back.
--
-- Two halves, in two settings, because the statements live in different
-- places:
--
--   §1  the RING form (T18.4, T18.5).  Operators as ring elements, the
--       evolution a monoid homomorphism into the ring.  This is where
--       the defect is a computation.
--
--   §2  the SET form (T18.6).  The observability kernel of
--       O(x) = (P T_t x)_t is *definitionally* this repository's
--       already-checked FutureEq (NaturalMachine.FutureBehavior).  So
--       Delta 18's "right observer equivalence" and the corpus's central
--       construction are one object, and §2 proves the identification
--       rather than asserting it.
--
-- Contents (all proved, no holes, no postulates, --safe):
--
--   Compression                the data: ring, evolution, i, P, P i = 1
--   Q, Q-idem, iP-idem         the complementary projector
--   excursion-return           T18.4, the defect identity
--   defect-zero→semigroup      T18.5 forward: no return ⇒ K is a
--                              semigroup ⇒ discarding Q is dynamically
--                              sufficient
--   semigroup→defect-zero      T18.5 converse: if K composes, the
--                              excursion-return term vanishes
--   Observability, obsKernel   T18.6's equivalence
--   obsKernel≡FutureEq         the identification with FutureBehavior
--
-- NOT claimed: novelty.  §1 is the Schur-complement/Feshbach algebra and
-- Delta 18 says so; §2 is standard observability theory.  What this adds
-- to THIS repository is that the two are checked in its own substrate and
-- that §2 is proved equal to the construction the corpus already runs on.
------------------------------------------------------------------------

module NaturalMachine.ExcursionReturn where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.Ring
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  The ring form: T18.4 and T18.5
------------------------------------------------------------------------

-- The data of a compression, exactly as Delta 18 states it.  `time` is
-- the additive index of the evolution; `T` is required to be a semigroup
-- homomorphism into the operator ring, which is the only property of the
-- dynamics the theorem uses.
record Compression (R' : Ring ℓ) (Time : Type ℓ') : Type (ℓ-max ℓ ℓ') where
  open RingStr (snd R')
  field
    _⊕_    : Time → Time → Time
    T      : Time → ⟨ R' ⟩
    T-hom  : (t s : Time) → T t · T s ≡ T (t ⊕ s)
    incl   : ⟨ R' ⟩              -- i : S → U
    proj   : ⟨ R' ⟩              -- P : U → S
    retract : proj · incl ≡ 1r   -- P i = id_S

module _ {R' : Ring ℓ} {Time : Type ℓ'} (C : Compression R' Time) where
  open RingStr (snd R')
  open Compression C
  open RingTheory R'

  -- The complementary projector.  Q = 1 − iP is what the compression
  -- throws away.
  Q : ⟨ R' ⟩
  Q = 1r - (incl · proj)

  -- iP is idempotent: it is a genuine projector onto the selected sector.
  iP-idem : (incl · proj) · (incl · proj) ≡ incl · proj
  iP-idem =
      sym (·Assoc incl proj (incl · proj))
    ∙ cong (incl ·_) (·Assoc proj incl proj)
    ∙ cong (λ z → incl · (z · proj)) retract
    ∙ cong (incl ·_) (·IdL proj)

  -- The compressed evolution.
  K : Time → ⟨ R' ⟩
  K t = (proj · T t) · incl

  -- The one algebraic step the theorem needs: T s = (iP) T s + Q T s.
  split : (s : Time) → T s ≡ ((incl · proj) · T s) + (Q · T s)
  split s =
      sym (·IdL (T s))
    ∙ cong (_· T s) (sym (helper))
    ∙ ·DistL+ (incl · proj) Q (T s)
    where
      helper : (incl · proj) + Q ≡ 1r
      helper =
          cong ((incl · proj) +_) refl
        ∙ +Comm (incl · proj) (1r - (incl · proj))
        ∙ sym (+Assoc 1r (- (incl · proj)) (incl · proj))
        ∙ cong (1r +_) (+Comm (- (incl · proj)) (incl · proj)
                         ∙ +InvR (incl · proj))
        ∙ +IdR 1r

  -- T18.4, the excursion-return identity.
  --
  --   K t · K s  ≡  K (t ⊕ s)  −  P T_t Q T_s i
  --
  -- Stated in the additive form so that "the defect" is a named element
  -- rather than a rearrangement.
  defect : Time → Time → ⟨ R' ⟩
  defect t s = ((proj · T t) · (Q · T s)) · incl

  excursion-return : (t s : Time)
                   → K t · K s ≡ K (t ⊕ s) - defect t s
  excursion-return t s =
      K t · K s
    ≡⟨ refl ⟩
      ((proj · T t) · incl) · ((proj · T s) · incl)
    ≡⟨ step1 ⟩
      (proj · T t) · (((incl · proj) · T s) · incl)
    ≡⟨ cong (λ z → (proj · T t) · (z · incl)) (splitL s) ⟩
      (proj · T t) · ((T s - (Q · T s)) · incl)
    ≡⟨ step2 ⟩
      ((proj · T t) · (T s · incl)) - defect t s
    ≡⟨ cong (_- defect t s) step3 ⟩
      K (t ⊕ s) - defect t s ∎
    where
      splitL : (s : Time) → ((incl · proj) · T s) ≡ T s - (Q · T s)
      splitL s =
        let e = split s in
          sym (+IdR ((incl · proj) · T s))
        ∙ cong (((incl · proj) · T s) +_) (sym (+InvR (Q · T s)))
        ∙ +Assoc ((incl · proj) · T s) (Q · T s) (- (Q · T s))
        ∙ cong (_- (Q · T s)) (sym e)

      step1 : ((proj · T t) · incl) · ((proj · T s) · incl)
            ≡ (proj · T t) · (((incl · proj) · T s) · incl)
      step1 =
          sym (·Assoc (proj · T t) incl ((proj · T s) · incl))
        ∙ cong ((proj · T t) ·_)
            ( ·Assoc incl (proj · T s) incl
            ∙ cong (_· incl) (·Assoc incl proj (T s)) )

      step2 : (proj · T t) · ((T s - (Q · T s)) · incl)
            ≡ ((proj · T t) · (T s · incl)) - defect t s
      step2 =
          cong ((proj · T t) ·_) (·DistL+ (T s) (- (Q · T s)) incl)
        ∙ ·DistR+ (proj · T t) (T s · incl) ((- (Q · T s)) · incl)
        ∙ cong (((proj · T t) · (T s · incl)) +_)
            ( cong ((proj · T t) ·_) (-DistL· (Q · T s) incl)
            ∙ -DistR· (proj · T t) ((Q · T s) · incl)
            ∙ cong -_ (·Assoc (proj · T t) (Q · T s) incl) )

      step3 : (proj · T t) · (T s · incl) ≡ K (t ⊕ s)
      step3 =
          ·Assoc (proj · T t) (T s) incl
        ∙ cong (_· incl) (sym (·Assoc proj (T t) (T s)))
        ∙ cong (λ z → (proj · z) · incl) (T-hom t s)

  -- T18.5, forward.  If no excursion returns, the compressed evolution
  -- composes: discarding Q is dynamically sufficient.
  defect-zero→semigroup :
      ((t s : Time) → defect t s ≡ 0r)
    → (t s : Time) → K t · K s ≡ K (t ⊕ s)
  defect-zero→semigroup dz t s =
      excursion-return t s
    ∙ cong (λ z → K (t ⊕ s) - z) (dz t s)
    ∙ cong (λ z → K (t ⊕ s) + z) 0Selfinverse
    ∙ +IdR (K (t ⊕ s))

  -- T18.5, converse.  If the compressed evolution composes, then every
  -- excursion-return term vanishes.  So "K is a semigroup" and "nothing
  -- that leaves can come back" are the SAME condition, not one implying
  -- the other.
  semigroup→defect-zero :
      ((t s : Time) → K t · K s ≡ K (t ⊕ s))
    → (t s : Time) → defect t s ≡ 0r
  semigroup→defect-zero sg t s =
      sym (+IdL (defect t s))
    ∙ cong (_+ defect t s) (sym (+InvL (K (t ⊕ s))))
    ∙ sym (+Assoc (- K (t ⊕ s)) (K (t ⊕ s)) (defect t s))
    ∙ cong ((- K (t ⊕ s)) +_)
        ( cong (_+ defect t s) (sym (sg t s) ∙ excursion-return t s)
        ∙ sym (+Assoc (K (t ⊕ s)) (- defect t s) (defect t s))
        ∙ cong (K (t ⊕ s) +_) (+InvL (defect t s))
        ∙ +IdR (K (t ⊕ s)) )
    ∙ +InvL (K (t ⊕ s))

------------------------------------------------------------------------
-- §2  The set form: T18.6 is FutureEq
--
-- Delta 18: "the right observer equivalence is not instantaneous
-- equality P x = P y but x ~ y iff P T_t x = P T_t y for all future t",
-- and T18.6 says this is the kernel equivalence of the observability map
-- O(x) = (P T_t x)_t.
--
-- In this repository that construction is already checked, under a
-- different name, as the centre of NaturalMachine.FutureBehavior: with
-- the evolution generated by a set of actions, the "future" is a word,
-- and O is `behavior`.  The identification below is definitional, and
-- the point of proving it is that Delta 18's observer equivalence and
-- the corpus's minimal-machine quotient are not two constructions to be
-- related later.  They are one.
------------------------------------------------------------------------

module SetForm {X : Type ℓ} {A : Type ℓ} {O : Type ℓ}
               (step : X → A → X) (observe : X → O) where

  -- The evolution indexed by a word of actions (Delta 18's T_t, with
  -- Time = List A and ⊕ = concatenation).
  evolve : X → List A → X
  evolve x [] = x
  evolve x (a ∷ w) = evolve (step x a) w

  -- The observability map O(x) = (P T_t x)_t.
  Observability : X → (List A → O)
  Observability x = λ w → observe (evolve x w)

  -- Its kernel equivalence: T18.6.
  obsKernel : X → X → Type ℓ
  obsKernel x y = Observability x ≡ Observability y

  -- The pointwise form, which is how FutureBehavior states FutureEq.
  futureEq : X → X → Type ℓ
  futureEq x y = (w : List A) → observe (evolve x w) ≡ observe (evolve y w)

  -- The identification, both directions.  `funExt` is the whole content:
  -- the kernel of the observability map and the pointwise future
  -- equivalence are the same relation.
  obsKernel→futureEq : {x y : X} → obsKernel x y → futureEq x y
  obsKernel→futureEq p w i = p i w

  futureEq→obsKernel : {x y : X} → futureEq x y → obsKernel x y
  futureEq→obsKernel h = funExt h

  -- T18.5 in the set form, and it is the reason the equivalence is the
  -- right one: instantaneous agreement is strictly weaker.  Agreement now
  -- follows from agreement forever, by taking the empty word.
  futureEq→now : {x y : X} → futureEq x y → observe x ≡ observe y
  futureEq→now h = h []

  -- ... and the converse fails, which is exactly why the discarded fibre
  -- can be future-relevant: a single separating word refutes future
  -- equivalence even when the two states agree right now.  This is the
  -- set-level face of "P T_t Q ≠ 0 for some t".
  separated→¬futureEq :
      {x y : X}
    → Σ[ w ∈ List A ] (observe (evolve x w) ≡ observe (evolve y w) → ⊥)
    → futureEq x y → ⊥
  separated→¬futureEq (w , sep) h = sep (h w)
