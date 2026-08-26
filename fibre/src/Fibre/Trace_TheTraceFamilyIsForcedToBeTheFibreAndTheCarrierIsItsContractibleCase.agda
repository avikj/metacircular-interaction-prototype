{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punarāgamana · Trace
--
-- THE GENERALISATION OF THE LAW.
--
-- `Fibre.Carrier` proves one thing exactly: when the datum a computation
-- adds is DETERMINED by what it already had — a contractible fibre — the
-- enriched presentation is equivalent to the bare one.  That is lossless
-- RE-PRESENTATION, and it is the whole content of `Carrier`.
--
-- It is not yet lossless COMPUTATION.  A general f : A → B forgets, and no
-- amount of univalence turns a many-to-one map into an equivalence.  What
-- survives is not the map but the FACTORISATION:
--
--   A  ≃  Σ[ b ∈ B ] Trace b                     (the whole is the sum
--                                                  of the traces over the
--                                                  visible results)
--
-- with the canonical choice Trace = fiber f, the homotopy fibre.  This
-- module is that statement, and then the one theorem that makes it a law
-- rather than a definition:
--
--   THEOREM (fibre-of-run).  For ANY conservative factorisation, the trace
--   family is pointwise equivalent to the fibre family of the visible map
--   it induces:      Trace b  ≃  fiber (run) b.
--
-- So the fibre is not one choice of residue among many.  It is the ONLY
-- one, up to equivalence.  "Keep a smaller trace" is available exactly to
-- the extent that the fibre was already smaller; a factorisation cannot
-- retain less than the fibre and remain a factorisation.  This is the
-- precise sense in which the residue of a computation is not negotiable.
--
-- THE PROVISO THIS CORRECTS.  "You may replace the fibre by a smaller
-- trace family T provided A ≃ Σ[ b ] T b" is NOT sufficient as stated, and
-- the counterexample is small: for f : Bool → Bool constantly `true`, the
-- family T b = Unit satisfies Bool ≃ Σ[ b ] T b, and it is smaller than
-- fiber f (which is Bool over `true` and empty over `false`).  Nothing is
-- wrong with the equivalence; what is wrong is that it is not an
-- equivalence OVER B — its first projection is the identity, not f, so it
-- is a factorisation of a DIFFERENT computation.  The fix is the one this
-- module takes: read the visible map OFF the equivalence (`run`) instead
-- of assuming it, and then the trace family is pinned.
--
-- TWO COROLLARIES, and they are the two halves of the same fact:
--
--   contractible trace   ⟹  run is an equivalence   (nothing was forgotten)
--   run an equivalence   ⟹  contractible trace      (nothing was retained)
--
-- Read together: the trace measures EXACTLY the failure of the visible
-- result to be the whole event.  `Carrier` is the left-hand end of that
-- scale — `representation` below exhibits it as such, and the identifica-
-- tion of `Carrier f` with its Σ-form is the one already proved in
-- Carrier.agda, reused rather than restated.
--
-- WHAT IS ALREADY IN THE CORPUS, AND IS NOT CLAIMED HERE.  The
-- decomposition A ≃ Σ[ b ] fiber f b is standard, and this repository
-- already has it twice, with its readings:
--   formal/cubical/theorems/logic/SarvavibhagaH_…    (every map is the sum
--                                                     of its fibres)
--   formal/cubical/theorems/number/Avaccheda_…       (memory is the fibre
--                                                     failing to be
--                                                     contractible)
-- `fiberize` below is that same fact, re-proved here only because the
-- `fibre` library does not depend on `natural-machine` and a law should
-- not be imported by prose.  The NEW content of this module is
-- `fibre-of-run` — which is about an ARBITRARY factorisation rather than
-- the canonical one — and the refutation at the foot of the file.
--
-- WHAT IS NOT CLAIMED.  Nothing here says a trace is cheap to store, safe
-- to publish, or authorised to exist.  The record has two fields and both
-- are mathematics.  Effects, capability, disclosure and admissibility are
-- separate obligations and are not smuggled in by naming them.
------------------------------------------------------------------------

module Fibre.Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Relation.Nullary using (¬_)

open import Fibre.Carrier

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The record.  Two fields; everything else is derived from them.
------------------------------------------------------------------------

record Conservative (A B : Type ℓ) : Type (ℓ-suc ℓ) where
  constructor conserving
  field
    Trace : B → Type ℓ
    whole : A ≃ (Σ[ b ∈ B ] Trace b)

  -- The visible half of the event…
  run : A → B
  run a = fst (equivFun whole a)

  -- …and the half that the visible half does not show.  Note the type:
  -- the trace is not free-floating, it lives OVER the result.
  trace : (a : A) → Trace (run a)
  trace a = snd (equivFun whole a)

open Conservative public

------------------------------------------------------------------------
-- The singleton in the other direction.  `isContrSingl` in the library is
-- Σ[ x ] (a ≡ x); the contraction below is Σ[ x ] (x ≡ a), which is what
-- a fibre-over-b unfolds to and is not in the library under that name.
------------------------------------------------------------------------

isContrInto : {B : Type ℓ} (b : B) → isContr (Σ[ b' ∈ B ] (b' ≡ b))
isContrInto b .fst = b , refl
isContrInto b .snd (b' , p) i = p (~ i) , λ j → p (~ i ∨ j)

------------------------------------------------------------------------
-- THE THEOREM.  The trace family of a factorisation is the fibre family
-- of the map that factorisation induces.  Five steps, each one a library
-- equivalence, and the last is where the choice of b is consumed.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (C : Conservative A B) where

  private
    T : B → Type ℓ
    T = Trace C

  fibre-of-run : (b : B) → fiber (run C) b ≃ T b
  fibre-of-run b = compEquiv s1 (compEquiv s2 (compEquiv s3 (compEquiv s4 s5)))
    where
      -- transport the domain of the fibre along the factorisation itself
      s1 : fiber (run C) b ≃ (Σ[ s ∈ Σ[ b' ∈ B ] T b' ] (fst s ≡ b))
      s1 = Σ-cong-equiv-fst {B = λ s → fst s ≡ b} (whole C)

      s2 : (Σ[ s ∈ Σ[ b' ∈ B ] T b' ] (fst s ≡ b))
         ≃ (Σ[ b' ∈ B ] Σ[ _ ∈ T b' ] (b' ≡ b))
      s2 = Σ-assoc-≃ {A = B} {B = T} {C = λ b' _ → b' ≡ b}

      s3 : (Σ[ b' ∈ B ] Σ[ _ ∈ T b' ] (b' ≡ b))
         ≃ (Σ[ b' ∈ B ] Σ[ _ ∈ (b' ≡ b) ] T b')
      s3 = Σ-cong-equiv-snd (λ _ → Σ-swap-≃)

      s4 : (Σ[ b' ∈ B ] Σ[ _ ∈ (b' ≡ b) ] T b')
         ≃ (Σ[ x ∈ (Σ[ b' ∈ B ] (b' ≡ b)) ] T (fst x))
      s4 = invEquiv (Σ-assoc-≃ {A = B} {B = λ b' → b' ≡ b} {C = λ b' _ → T b'})

      -- the path component is a singleton: contracting it is what turns a
      -- family over "some b' equal to b" into the family at b.
      s5 : (Σ[ x ∈ (Σ[ b' ∈ B ] (b' ≡ b)) ] T (fst x)) ≃ T b
      s5 = Σ-contractFst {B = λ x → T (fst x)} (isContrInto b)

  -- The same statement read as the constraint it is: you may choose the
  -- trace family, but only up to equivalence with the fibre.
  trace-is-forced : (b : B) → T b ≃ fiber (run C) b
  trace-is-forced b = invEquiv (fibre-of-run b)

  -- Nothing forgotten ⟹ the visible map is already the whole event.
  exact-when-contractible : ((b : B) → isContr (T b)) → isEquiv (run C)
  equiv-proof (exact-when-contractible h) b =
    isOfHLevelRespectEquiv 0 (invEquiv (fibre-of-run b)) (h b)

  -- …and conversely.  An invertible visible map has nothing to retain.
  contractible-when-exact : isEquiv (run C) → (b : B) → isContr (T b)
  contractible-when-exact e b =
    isOfHLevelRespectEquiv 0 (fibre-of-run b) (equiv-proof e b)

------------------------------------------------------------------------
-- The canonical factorisation: every map has one, with no hypothesis.
------------------------------------------------------------------------

fiberize : {A B : Type ℓ} (f : A → B) → A ≃ (Σ[ b ∈ B ] fiber f b)
fiberize {A = A} {B = B} f = isoToEquiv is
  where
    is : Iso A (Σ[ b ∈ B ] fiber f b)
    Iso.fun is a = f a , a , refl
    Iso.inv is x = fst (snd x)
    Iso.rightInv is (b , a , p) i = p i , a , λ j → p (i ∧ j)
    Iso.leftInv is a = refl

canonical : {A B : Type ℓ} (f : A → B) → Conservative A B
Conservative.Trace (canonical f) = fiber f
Conservative.whole (canonical f) = fiberize f

-- The visible half of the canonical factorisation IS the original map:
-- factorising changes nothing about what the computation returns.
canonical-run : {A B : Type ℓ} (f : A → B) (a : A)
              → run (canonical f) a ≡ f a
canonical-run f a = refl

-- …and the retained half identifies the source inside its own fibre.
-- This is the losslessness, and it holds by refl: nothing is reconstructed,
-- the source was never left behind.
canonical-recovers : {A B : Type ℓ} (f : A → B) (a : A)
                   → fst (trace (canonical f) a) ≡ a
canonical-recovers f a = refl

------------------------------------------------------------------------
-- The contractible end of the scale: `Fibre.Carrier` read as a
-- Conservative whose visible map is the identity.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  representation : Conservative A A
  Conservative.Trace representation a = singl (f a)
  Conservative.whole representation = isoToEquiv is
    where
      is : Iso A (Σ[ a ∈ A ] singl (f a))
      Iso.fun is a = a , (f a , refl)
      Iso.inv is = fst
      Iso.rightInv is (a , s) i = a , isContrSingl (f a) .snd s i
      Iso.leftInv is a = refl

  -- it forgets nothing because it does nothing
  representation-run : (a : A) → run representation a ≡ a
  representation-run a = refl

  -- and this is literally Carrier.agda's Σ-form, not a lookalike:
  -- `Carrier.fibre f a` and `Trace representation a` are the same type.
  representation-is-the-carrier
    : Iso (Carrier f) (Σ[ a ∈ A ] Trace representation a)
  representation-is-the-carrier = Carrier-as-Σ f

  -- the theorem above, instantiated: contractible trace ⟹ exact.
  representation-exact : isEquiv (run representation)
  representation-exact =
    exact-when-contractible representation (λ a → isContrSingl (f a))

------------------------------------------------------------------------
-- The proviso, refuted.  An equivalence A ≃ Σ[ b ] T b that is not over B
-- factorises some computation — just not the one you meant.
------------------------------------------------------------------------

alwaysTrue : Bool → Bool
alwaysTrue _ = true

-- Bool ≃ Σ[ b ∈ Bool ] Unit.  The trace is a point everywhere, and it is
-- strictly smaller than fiber alwaysTrue, which is empty over `false`.
unitTrace : Conservative Bool Bool
Conservative.Trace unitTrace _ = Unit
Conservative.whole unitTrace = isoToEquiv is
  where
    is : Iso Bool (Σ[ b ∈ Bool ] Unit)
    Iso.fun is b = b , tt
    Iso.inv is = fst
    Iso.rightInv is _ = refl
    Iso.leftInv is _ = refl

-- The map it actually factorises is the identity…
unitTrace-run : (b : Bool) → run unitTrace b ≡ b
unitTrace-run b = refl

-- …and not alwaysTrue, whose fibre over `false` is empty.
alwaysTrue-misses-false : ¬ fiber alwaysTrue false
alwaysTrue-misses-false (b , p) = true≢false p

-- So the equivalence alone licenses nothing about alwaysTrue.  Compare
-- `fibre-of-run`, which is about the map the equivalence does factorise:
-- there the trace is pinned, here it is unrelated.
unitTrace-is-not-a-trace-of-alwaysTrue
  : ¬ ((b : Bool) → Trace unitTrace b ≃ fiber alwaysTrue b)
unitTrace-is-not-a-trace-of-alwaysTrue h =
  alwaysTrue-misses-false (equivFun (h false) tt)
