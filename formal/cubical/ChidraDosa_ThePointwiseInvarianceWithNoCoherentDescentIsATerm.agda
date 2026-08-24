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
-- ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm
--
-- छिद्रदोष — the defect that lives in a gap.
--
-- `NaturalMachine.FiniteInformation` proves
--
--   factorsThrough→fiberConstant : hypothesis-free, and
--   fiberConstant→factorsThrough : requires `isSet T`.
--
-- The asymmetry is not bookkeeping.  This module exhibits the gap as a
-- closed term: a concrete observable `q` and target `t` with `T` NOT a
-- set, such that
--
--   `FiberConstant q t`   HOLDS   (§3, `fiberConstantDoubleId`), and
--   `FactorsThrough q t`  FAILS   (§4, `noFactorsThroughDoubleId`).
--
-- THE EXHIBIT.  X = Y = T = S¹, q = double (the connected double cover
-- z ↦ z², i.e. loop ↦ loop ∙ loop), t = the identity.
--
--   * FiberConstant double id asks for a TERM
--
--       (x x' : S¹) → double x ≡ double x' → x ≡ x'
--
--     i.e. a continuous "halving" of every identification of squares.
--     It exists: eliminate both circle arguments into the SET
--     (double x ≡ double x' → x ≡ x') via `toSetElim2`; at base/base
--     the required map ΩS¹ → ΩS¹ is p ↦ intLoop ⌊winding p / 2⌋, and
--     the two loop-transport conditions are exactly the floor-division
--     law  half (m + 2) ≡ half m + 1  (§1, `half2`).  So pointwise
--     invariance holds — as data, not merely as a proposition.
--
--   * FactorsThrough double id would be a decoder on the univalent
--     image.  Since double is surjective (§4, `doubleIsSurjective`),
--     any decoder yields g : S¹ → S¹ with g ∘ double ∼ id, and the
--     winding number of loop then satisfies 1 = n + n in ℤ (the
--     homotopy is natural, cong distributes over ∙, conjugation is a
--     homomorphism, winding is a homomorphism).  Parity refutes it.
--
-- So the fiberwise constancy witnesses exist everywhere, but they are
-- not 2-coherent over the base: transporting the halving around the
-- base loop shifts it by the deck transformation, and no global choice
-- survives.  This is the anomaly named in the collaboration's queue
-- item: POINTWISE INVARIANCE WITH NO COHERENT GLOBAL DESCENT.  The
-- `isSet T` hypothesis in `fiberConstant→factorsThrough` is therefore
-- not an artefact of the proof (`PT.rec→Set`'s 2-Constancy demand); it
-- is the exact price of the phenomenon, and this module is the witness
-- that the price is nonzero.
--
-- WHERE THE ANOMALY CANNOT LIVE (§2, the honest boundary).  If q has a
-- section, FiberConstant → FactorsThrough with NO hypothesis on T
-- (`sectionKillsTheGap`).  In particular Y = Unit with X pointed — the
-- naive first candidate — can never exhibit the gap: over a trivial
-- base the decoder is `t ∘ section ∘ fst`.  The gap needs monodromy.
-- Corollary (§5): the double cover admits no section — the classical
-- nonsplitting of z ↦ z², here a two-line consequence of the gap.
--
-- THE REPAIR (§6).  The SAME constancy data, pushed forward along
-- ∣_∣₂ : S¹ → ∥ S¹ ∥₂, descends at once through the corpus's own
-- `fiberConstant→factorsThrough` — the set-truncated shadow of the
-- identity is a function of the observation, the identity itself is
-- not.  What set-truncation destroys is precisely what obstructed.
--
-- LITERATURE.  That weakly constant maps into non-sets need not factor
-- through ∥_∥₁ is the theme of Kraus–Escardó–Coquand–Altenkirch,
-- "Notions of Anonymous Existence in Martin-Löf Type Theory" (LMCS
-- 2017), and Kraus's general universal property of the propositional
-- truncation (coherence at all levels).  The contribution here is not
-- the phenomenon but the TERM: a closed, --safe, hole-free instance in
-- the corpus's own vocabulary (`FiberConstant`/`FactorsThrough` over
-- the univalent `Image`), with the failure refuted by parity rather
-- than assumed from a model, plus the section boundary and the ∥_∥₂
-- repair beside it.  Relation to the corpus: `SetTruncationDescent-
-- Boundary` locates set-level descent OF THE IDENTITY ALONG ∣_∣₂ at
-- `isSet A`; here the base map is a COVER OF THE CIRCLE BY ITSELF, the
-- fiberwise identifications all exist, and the obstruction is not the
-- h-level of the base or of the image (both are groupoids) but the
-- incoherence of the invariance data itself.
--
-- No holes, no postulates, --safe.
------------------------------------------------------------------------

module ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun ; _∘_ ; homotopyNatural)
open import Cubical.Foundations.GroupoidLaws
  using (assoc ; lUnit ; rUnit ; lCancel ; congFunct ; symDistr)
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Data.Sigma using (Σ≡Prop ; Σ-syntax)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; snotz ; injSuc ; +-suc ; +-zero)
  renaming (_+_ to _+ℕ_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; sucℤ ; predℤ ; _+_ ; sucPred ; predSuc
       ; +Comm ; pos+ ; injPos ; negsucNotpos)
open import Cubical.HITs.S1
  using (S¹ ; base ; loop ; ΩS¹ ; winding ; intLoop ; windingℤLoop
       ; intLoop-hom ; winding-hom ; decodeEncode ; toSetElim2 ; toPropElim
       ; isGroupoidS¹)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.HITs.SetTruncation using (∥_∥₂ ; ∣_∣₂ ; squash₂)
open import Cubical.Functions.Image
  using (Image ; isInImage ; isPropIsInImage ; restrictToImage)
open import Cubical.Functions.Surjection using (isSurjection)

open import NaturalMachine.FiniteInformation
  using (FiberConstant ; FactorsThrough ; fiberConstant→factorsThrough)
open import NaturalMachine.SetBaseNoMonodromy using (S¹NotSet)

private
  variable
    ℓ ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- §0  The observable: the connected double cover of the circle.
------------------------------------------------------------------------

double : S¹ → S¹
double base     = base
double (loop i) = (loop ∙ loop) i

-- The target is the identity; its codomain S¹ is NOT a set.
targetIsNotASet : ¬ isSet S¹
targetIsNotASet = S¹NotSet

------------------------------------------------------------------------
-- §1  Integer halving, and the one law the monodromy conditions need.
------------------------------------------------------------------------

half : ℤ → ℤ
half (pos zero)            = pos zero
half (pos (suc zero))      = pos zero
half (pos (suc (suc n)))   = sucℤ (half (pos n))
half (negsuc zero)         = negsuc zero
half (negsuc (suc zero))   = negsuc zero
half (negsuc (suc (suc n))) = predℤ (half (negsuc n))

-- half (m + 2) ≡ half m + 1 — floor division is equivariant for the
-- deck shift.  This single identity discharges both loop conditions.
half2 : (m : ℤ) → half (sucℤ (sucℤ m)) ≡ sucℤ (half m)
half2 (pos n)                = refl
half2 (negsuc zero)          = refl
half2 (negsuc (suc zero))    = refl
half2 (negsuc (suc (suc n))) = sym (sucPred (half (negsuc n)))

halfSS : (n : ℤ) → sucℤ (half (predℤ (predℤ n))) ≡ half n
halfSS n =
    sym (half2 (predℤ (predℤ n)))
  ∙ cong half (cong sucℤ (sucPred (predℤ n)) ∙ sucPred n)

halfPS : (n : ℤ) → predℤ (half (sucℤ (sucℤ n))) ≡ half n
halfPS n = cong predℤ (half2 n) ∙ predSuc (half n)

------------------------------------------------------------------------
-- §2  The honest boundary: a section kills the gap.
--
-- With any section of q, fiber constancy descends with NO hypothesis
-- on T.  So the anomaly cannot be exhibited over a trivial base (a
-- pointed X over Unit gives a section of the image restriction), and
-- any exhibit must carry monodromy.  This is the reason the candidate
-- constructions "X = Bool over Unit", "t constant at base" all close:
-- their bases are sectioned.
------------------------------------------------------------------------

sectionKillsTheGap :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T)
  (s : Y → X) (hs : (y : Y) → q (s y) ≡ y)
  → FiberConstant q t → FactorsThrough q t
sectionKillsTheGap q t s hs fc =
  (λ im → t (s (fst im))) , λ x → fc (s (q x)) x (hs (q x))

------------------------------------------------------------------------
-- §3  POINTWISE INVARIANCE HOLDS: FiberConstant double id, as a term.
--
-- Both circle arguments are eliminated into the set
-- (double x ≡ double x' → x ≡ x'); at base/base the datum is integer
-- halving transported through winding, and the two loop conditions are
-- `half2` in the two directions.
------------------------------------------------------------------------

-- Loops are equal as soon as their winding numbers are.
eqΩ : {a b : ΩS¹} → winding a ≡ winding b → a ≡ b
eqΩ {a} {b} h = sym (decodeEncode base a) ∙∙ cong intLoop h ∙∙ decodeEncode base b

windingLoop : winding loop ≡ pos 1
windingLoop = cong winding (lUnit loop) ∙ windingℤLoop (pos 1)

windingLoop² : winding (loop ∙ loop) ≡ pos 2
windingLoop² = cong winding (cong (_∙ loop) (lUnit loop)) ∙ windingℤLoop (pos 2)

windingSymLoop² : winding (sym (loop ∙ loop)) ≡ negsuc 1
windingSymLoop² = cong winding (symDistr loop loop) ∙ windingℤLoop (negsuc 1)

-- Transport in path types, in the two directions used by the
-- monodromy conditions.
substCod : {A : Type ℓ} {x y z : A} (r : y ≡ z) (p : x ≡ y)
         → subst (x ≡_) r p ≡ p ∙ r
substCod {x = x} r p =
  J (λ _ r → subst (x ≡_) r p ≡ p ∙ r) (substRefl {B = x ≡_} p ∙ rUnit p) r

substDom : {A : Type ℓ} {x y z : A} (r : x ≡ y) (p : x ≡ z)
         → subst (_≡ z) r p ≡ sym r ∙ p
substDom {z = z} r p =
  J (λ _ r → subst (_≡ z) r p ≡ sym r ∙ p) (substRefl {B = _≡ z} p ∙ lUnit p) r

-- The base datum: halve the winding number.
k₀ : ΩS¹ → ΩS¹
k₀ p = intLoop (half (winding p))

-- Monodromy condition in the second argument.
private
  right : PathP (λ i → (base ≡ (loop ∙ loop) i) → base ≡ loop i) k₀ k₀
  right = toPathP (funExt step)
    where
    step : (p : ΩS¹)
         → transport (λ i → (base ≡ (loop ∙ loop) i) → base ≡ loop i) k₀ p ≡ k₀ p
    step p = substCod loop (k₀ p') ∙ eqΩ windGoal
      where
      p' : ΩS¹
      p' = subst (base ≡_) (sym (loop ∙ loop)) p

      windp' : winding p' ≡ predℤ (predℤ (winding p))
      windp' =
          cong winding (substCod (sym (loop ∙ loop)) p)
        ∙ winding-hom p (sym (loop ∙ loop))
        ∙ cong (winding p +_) windingSymLoop²

      windGoal : winding (k₀ p' ∙ loop) ≡ winding (k₀ p)
      windGoal =
          winding-hom (k₀ p') loop
        ∙ cong₂ _+_ (windingℤLoop (half (winding p'))) windingLoop
        ∙ cong (λ m → sucℤ (half m)) windp'
        ∙ halfSS (winding p)
        ∙ sym (windingℤLoop (half (winding p)))

  -- Monodromy condition in the first argument.
  left : PathP (λ i → ((loop ∙ loop) i ≡ base) → loop i ≡ base) k₀ k₀
  left = toPathP (funExt step)
    where
    step : (p : ΩS¹)
         → transport (λ i → ((loop ∙ loop) i ≡ base) → loop i ≡ base) k₀ p ≡ k₀ p
    step p = substDom loop (k₀ p') ∙ eqΩ windGoal
      where
      p' : ΩS¹
      p' = subst (_≡ base) (sym (loop ∙ loop)) p

      windp' : winding p' ≡ sucℤ (sucℤ (winding p))
      windp' =
          cong winding (substDom (sym (loop ∙ loop)) p)
        ∙ winding-hom (loop ∙ loop) p
        ∙ cong (_+ winding p) windingLoop²
        ∙ +Comm (pos 2) (winding p)

      windGoal : winding (sym loop ∙ k₀ p') ≡ winding (k₀ p)
      windGoal =
          winding-hom (sym loop) (k₀ p')
        ∙ cong₂ _+_ (windingℤLoop (negsuc zero)) (windingℤLoop (half (winding p')))
        ∙ +Comm (negsuc zero) (half (winding p'))
        ∙ cong (λ m → predℤ (half m)) windp'
        ∙ halfPS (winding p)
        ∙ sym (windingℤLoop (half (winding p)))

-- THE POSITIVE HALF OF THE GAP: fiberwise invariance, hypothesis-free.
fiberConstantDoubleId : FiberConstant double (idfun S¹)
fiberConstantDoubleId =
  toSetElim2 {B = λ s t → double s ≡ double t → s ≡ t}
    (λ s t → isSetΠ (λ _ → isGroupoidS¹ s t))
    k₀ right left

------------------------------------------------------------------------
-- §4  COHERENT DESCENT FAILS: ¬ FactorsThrough double id.
------------------------------------------------------------------------

doubleIsSurjective : (y : S¹) → isInImage double y
doubleIsSurjective = toPropElim (λ y → isPropIsInImage double y) ∣ base , refl ∣₁

-- Parity: no integer doubles to one.
private
  negsucAdd : (a b : ℕ) → negsuc a + negsuc b ≡ negsuc (suc (a +ℕ b))
  negsucAdd a zero    = cong (λ n → negsuc (suc n)) (sym (+-zero a))
  negsucAdd a (suc k) =
    cong predℤ (negsucAdd a k) ∙ cong (λ n → negsuc (suc n)) (sym (+-suc a k))

  ℕnoDoubleOne : (m : ℕ) → ¬ (m +ℕ m ≡ 1)
  ℕnoDoubleOne zero    e = znots e
  ℕnoDoubleOne (suc k) e = snotz (sym (+-suc k k) ∙ injSuc e)

notDoubleOne : (n : ℤ) → ¬ (n + n ≡ pos 1)
notDoubleOne (pos m)    h = ℕnoDoubleOne m (injPos (pos+ m m ∙ h))
notDoubleOne (negsuc m) h = negsucNotpos (suc (m +ℕ m)) 1 (sym (negsucAdd m m) ∙ h)

-- Conjugation by a fixed path is multiplicative.
private
  conjSplit : {A : Type ℓ} {u v : A} (r : u ≡ v) (a b : u ≡ u)
            → (sym r ∙ (a ∙ b)) ∙ r ≡ ((sym r ∙ a) ∙ r) ∙ ((sym r ∙ b) ∙ r)
  conjSplit {u = u} r a b =
    J (λ _ r → (sym r ∙ (a ∙ b)) ∙ r ≡ ((sym r ∙ a) ∙ r) ∙ ((sym r ∙ b) ∙ r))
      (e (a ∙ b) ∙ cong₂ _∙_ (sym (e a)) (sym (e b)))
      r
    where
    e : (x : u ≡ u) → (refl ∙ x) ∙ refl ≡ x
    e x = sym (rUnit (refl ∙ x)) ∙ sym (lUnit x)

-- THE NEGATIVE HALF OF THE GAP.
noFactorsThroughDoubleId : ¬ FactorsThrough double (idfun S¹)
noFactorsThroughDoubleId (dec , replay) = notDoubleOne (winding c) (sym contra)
  where
  g : S¹ → S¹
  g y = dec (y , doubleIsSurjective y)

  f₀ : S¹ → S¹
  f₀ x = g (double x)

  imPath : (x : S¹)
         → Path (Image double) (double x , doubleIsSurjective (double x))
                               (restrictToImage double x)
  imPath x = Σ≡Prop (isPropIsInImage double) refl

  -- The decoder replays the identity: g ∘ double ∼ id.
  H : (x : S¹) → f₀ x ≡ x
  H x = cong dec (imPath x) ∙ replay x

  Hb : g base ≡ base
  Hb = H base

  -- The conjugated image of the generator …
  c : ΩS¹
  c = (sym Hb ∙ cong g loop) ∙ Hb

  -- … whose double is the generator: naturality of H at loop.
  conjEq : (sym Hb ∙ cong f₀ loop) ∙ Hb ≡ loop
  conjEq =
      (sym Hb ∙ cong f₀ loop) ∙ Hb  ≡⟨ sym (assoc (sym Hb) (cong f₀ loop) Hb) ⟩
      sym Hb ∙ (cong f₀ loop ∙ Hb)  ≡⟨ cong (sym Hb ∙_) (sym (homotopyNatural H loop)) ⟩
      sym Hb ∙ (Hb ∙ loop)          ≡⟨ assoc (sym Hb) Hb loop ⟩
      (sym Hb ∙ Hb) ∙ loop          ≡⟨ cong (_∙ loop) (lCancel Hb) ⟩
      refl ∙ loop                   ≡⟨ sym (lUnit loop) ⟩
      loop ∎

  loopSplit : loop ≡ c ∙ c
  loopSplit =
      sym conjEq
    ∙ cong (λ w → (sym Hb ∙ w) ∙ Hb) (congFunct g loop loop)
    ∙ conjSplit Hb (cong g loop) (cong g loop)

  contra : pos 1 ≡ winding c + winding c
  contra = sym windingLoop ∙ cong winding loopSplit ∙ winding-hom c c

------------------------------------------------------------------------
-- §5  Corollary: the double cover is nonsplit — read off from the gap.
------------------------------------------------------------------------

doubleHasNoSection :
  ¬ (Σ[ s ∈ (S¹ → S¹) ] ((y : S¹) → double (s y) ≡ y))
doubleHasNoSection (s , hs) =
  noFactorsThroughDoubleId
    (sectionKillsTheGap double (idfun S¹) s hs fiberConstantDoubleId)

------------------------------------------------------------------------
-- §6  THE REPAIR: the same invariance data descends after ∥_∥₂.
--
-- Exactly the corpus's `fiberConstant→factorsThrough`, fed the
-- push-forward of the SAME constancy term along ∣_∣₂.  The gap is the
-- h-level of the target and nothing else.
------------------------------------------------------------------------

fiberConstantDoubleTrunc : FiberConstant double (λ (x : S¹) → ∣ x ∣₂)
fiberConstantDoubleTrunc x x' p = cong ∣_∣₂ (fiberConstantDoubleId x x' p)

factorsThroughDoubleTrunc : FactorsThrough double (λ (x : S¹) → ∣ x ∣₂)
factorsThroughDoubleTrunc =
  fiberConstant→factorsThrough squash₂ double (λ x → ∣ x ∣₂)
    fiberConstantDoubleTrunc
