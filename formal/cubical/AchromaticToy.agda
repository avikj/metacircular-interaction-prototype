-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AchromaticToy
--
-- The finite Φ toy of the Eternal Golden Braid
-- (notes/ETERNAL_GOLDEN_BRAID_DELTA24.md §19.C), one full cycle of the
-- achromatic-reflection discipline on the smallest possible material:
--
--   G₁ = Bool          the two-valued perspective
--   G₂ = Unit ⊎ Unit   the same content, differently presented
--   G₃ = Unit          the collapsed perspective
--
-- 1. TRUE EQUIVALENCE (Φ.3, univalent completion): G₁ ≃ G₂ is
--    certified, `ua` turns it into a path, and a native theorem of G₁
--    transports through the lens.  Equivalence by proof, not
--    resemblance.
--
-- 2. HOLONOMY (T24.3): the cycle G₁ ≃ G₂ ≃ G₁ built from two
--    individually certified lenses composes to `not`, provably not the
--    identity, and its `ua`-path is provably not `refl`.  A unity cycle
--    retains automorphism data; achromatic does not mean contentless.
--
-- 3. WEAKER RELATION, GLUED (Φ.2, T24.2): the collapse G₂ → G₃ is kept
--    as its graph relation and glued into a collage.  The collage
--    provably loses nothing (its projection to G₂ is an equivalence),
--    while the collapse provably identifies points a separating
--    context distinguishes.  Relation retained, not misdeclared
--    identity.
--
-- 4. DEFECT AS OBJECT (Φ.4): the separator is installed as a term of a
--    defect type, and that term GENERATES the refutation of the false
--    proposed equivalence G₂ ≃ G₃.  When equivalence fails, inspect
--    the torn thread.
--
-- 5. REFLECTION, UNIVERSE-GRADED (Φ.5–Φ.6, §8): the stage is quoted as
--    a record whose type lives one universe up (`Stage ℓ : Type
--    (ℓ-suc ℓ)`), instantiated by the toy, and the diagonal engine of
--    LawvereDiagonal exhibits, for every claimed enumeration of the
--    stage's Bool-observations, the observation that escapes it — the
--    next stage's new generator.  The boundary is the mother of the
--    next stage.
------------------------------------------------------------------------

module AchromaticToy where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Bool
open import Cubical.Data.Sum
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary

open import LawvereDiagonal

------------------------------------------------------------------------
-- The three perspectives

G₁ G₂ G₃ : Type₀
G₁ = Bool
G₂ = Unit ⊎ Unit
G₃ = Unit

------------------------------------------------------------------------
-- 1. The certified lens G₁ ≃ G₂ and transport through it

to₁₂ : G₁ → G₂
to₁₂ true  = inl tt
to₁₂ false = inr tt

from₁₂ : G₂ → G₁
from₁₂ (inl _) = true
from₁₂ (inr _) = false

L₁₂ : G₁ ≃ G₂
L₁₂ = isoToEquiv (iso to₁₂ from₁₂ sec ret)
  where
  sec : section to₁₂ from₁₂
  sec (inl tt) = refl
  sec (inr tt) = refl
  ret : retract to₁₂ from₁₂
  ret true  = refl
  ret false = refl

-- a native theorem of G₁ …
distinct₁ : ¬ true ≡ false
distinct₁ = true≢false

-- … transported through the certified lens to G₂
distinct₂ : ¬ Path G₂ (inl tt) (inr tt)
distinct₂ p = distinct₁ (cong from₁₂ p)

------------------------------------------------------------------------
-- 2. Holonomy of a unity cycle (T24.3, witnessed)
--
-- The return lens is individually certified, but twisted relative to
-- L₁₂.  Both lenses are honest; the CYCLE still carries `not`.

to₂₁ : G₂ → G₁
to₂₁ (inl _) = false
to₂₁ (inr _) = true

L₂₁ : G₂ ≃ G₁
L₂₁ = isoToEquiv (iso to₂₁ inv sec ret)
  where
  inv : G₁ → G₂
  inv true  = inr tt
  inv false = inl tt
  sec : section to₂₁ inv
  sec true  = refl
  sec false = refl
  ret : retract to₂₁ inv
  ret (inl tt) = refl
  ret (inr tt) = refl

holonomy : G₁ ≃ G₁
holonomy = compEquiv L₁₂ L₂₁

holonomyIsNot : equivFun holonomy ≡ not
holonomyIsNot = funExt λ { true → refl ; false → refl }

holonomyNontrivial : ¬ equivFun holonomy ≡ idfun G₁
holonomyNontrivial p = true≢false (sym (funExt⁻ p true))

-- univalent completion of the cycle: the path is not refl.  The unity
-- object of an equivalence-only cycle is one perspective PLUS holonomy.
holonomyPath : G₁ ≡ G₁
holonomyPath = ua holonomy

holonomyPathNontrivial : ¬ holonomyPath ≡ refl
holonomyPathNontrivial p =
  true≢false (sym (sym (uaβ holonomy true)
                  ∙ cong (λ q → transport q true) p
                  ∙ transportRefl true))

------------------------------------------------------------------------
-- 3. The weaker lens G₂ → G₃, kept as a glued relation

collapse : G₂ → G₃
collapse _ = tt

-- the graph relation: proof-relevant comparison data, not yet identity
R₂₃ : G₂ → G₃ → Type₀
R₂₃ x u = collapse x ≡ u

-- the collage of the relation (Φ.2): both worlds and their comparison
Collage : Type₀
Collage = Σ[ x ∈ G₂ ] Σ[ u ∈ G₃ ] R₂₃ x u

-- gluing loses nothing: the collage projects equivalently onto G₂
collageFaithful : Collage ≃ G₂
collageFaithful = Σ-contractSnd λ x → isContrSingl tt

-- two collage points with the SAME shadow in G₃ …
cInl cInr : Collage
cInl = inl tt , tt , refl
cInr = inr tt , tt , refl

sameShadow : fst (snd cInl) ≡ fst (snd cInr)
sameShadow = refl

-- … which the collage keeps distinct (T24.2: the quotient would not)
collageSeparates : ¬ cInl ≡ cInr
collageSeparates p = distinct₂ (cong fst p)

------------------------------------------------------------------------
-- 4. The defect as an object, generating the refutation (Φ.4)

-- the torn thread: a context on G₂ distinguishing the two points the
-- proposed synthesis G₂ ≃ G₃ would identify
Defect₂₃ : Type₀
Defect₂₃ = Σ[ C ∈ (G₂ → Bool) ] (¬ C (inl tt) ≡ C (inr tt))

defect₂₃ : Defect₂₃
defect₂₃ = from₁₂ , true≢false

-- any inhabitant of the defect type refutes the proposed equivalence:
-- the defect is not a failure report, it is a proof-generating object
defectBlocks : Defect₂₃ → ¬ (G₂ ≃ G₃)
defectBlocks (C , sep) e = sep (cong C identified)
  where
  identified : Path G₂ (inl tt) (inr tt)
  identified = sym (retEq e (inl tt))
             ∙ cong (invEq e) (isPropUnit _ _)
             ∙ retEq e (inr tt)

¬G₂≃G₃ : ¬ (G₂ ≃ G₃)
¬G₂≃G₃ = defectBlocks defect₂₃

------------------------------------------------------------------------
-- 5. Reflection into the next stage, universe-graded (§8, Φ.5–Φ.6)

-- the stage quoted as an object: perspectives, a certified lens, a
-- glued relation, and the retained defect — two points related to the
-- same shadow that the stage itself keeps distinct
record Stage (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Persp₁ Persp₂ Persp₃ : Type ℓ
    certified : Persp₁ ≃ Persp₂
    relation  : Persp₂ → Persp₃ → Type ℓ
    x₀ y₀     : Persp₂
    shadow    : Persp₃
    relX      : relation x₀ shadow
    relY      : relation y₀ shadow
    torn      : ¬ x₀ ≡ y₀

-- §8 as a typing fact: the stage's self-description lives one
-- universe above its perspectives.  Φ is graded, not endo.
StageIsHigher : Type₁
StageIsHigher = Stage ℓ-zero

stage₀ : Stage ℓ-zero
stage₀ = record
  { Persp₁ = G₁ ; Persp₂ = G₂ ; Persp₃ = G₃
  ; certified = L₁₂
  ; relation  = R₂₃
  ; x₀ = inl tt ; y₀ = inr tt
  ; shadow = tt
  ; relX = refl ; relY = refl
  ; torn = distinct₂
  }

-- diagonal ascent (Φ.6): no stage enumerates its own
-- Bool-observations; for every claimed enumeration the diagonal
-- observation escapes, with a pointwise witness.  This escaping
-- observation is the material the next stage must adjoin.
module Ascent (S : Stage ℓ-zero) where
  open Stage S

  nextGenerator : (e : Persp₂ → Persp₂ → Bool)
    → Σ[ d ∈ (Persp₂ → Bool) ]
        ((a : Persp₂) → ¬ ((x : Persp₂) → e a x ≡ d x))
  nextGenerator = cantorDefect

-- instantiated at the toy stage: the ascent is available, not merely
-- schematic
nextGenerator₀ : (e : G₂ → G₂ → Bool)
  → Σ[ d ∈ (G₂ → Bool) ] ((a : G₂) → ¬ ((x : G₂) → e a x ≡ d x))
nextGenerator₀ = Ascent.nextGenerator stage₀
