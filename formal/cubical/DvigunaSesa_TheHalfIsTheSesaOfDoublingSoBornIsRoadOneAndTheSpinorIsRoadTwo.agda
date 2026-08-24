{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्विगुण-शेषः — the half is the śeṣa (fibre) of doubling, and the two ½s
-- of physics are its two bindings.  This is Punaragamana's fibre law —
-- कः पक्षो बद्ध, which side of f a ≡ b is bound — at ONE map, x ↦ x + x.
-- It is not a new organ; it is the core object read at doubling.  It
-- clears away the four modules this session spun — three circling this
-- exact dichotomy (the loop-charge abelian, Brahmagupta's composition
-- abelian, the Born/spinor fork) and one side-quest (the compound
-- bhaṅgas) — and leaves this one term in their place.  Less machine, not
-- more.
--
-- शेष _+_ c = Σ[ x ] (x + x ≡ c) is the fibre of doubling over c: the
-- halves of c.  The fibre law says which side you bind is everything:
--
--   ROAD ONE — bind so the half rides FREE.  `isProp (शेष _+_ c)`: the
--     half is unique if it exists, contractible, gauge.  That predicate IS
--     EkatvaMatraDvaya's `halvesUniquely` (its Σ is this Σ), the exact
--     hypothesis that FORCES the symmetric Born weight ½.  Over an
--     archimedean carrier (ℚ, ℝ) it holds at c = 𝟙: the Born ½.
--
--   ROAD TWO — bind so the śeṣa CARRIES content.  `¬ isProp (शेष _+_ c)`:
--     the fibre has more than one point, and the extra point is the loss
--     the free binding hid.  Over ℤ/2 = (Bool, ⊕) at c = 0 the fibre is
--     {0, g}: g is the 2-torsion generator, the nonzero half of zero —
--     the spinor, π₁(SO(3)) = ℤ/2, the j = ½ the abelian charge cannot
--     see.  (The physical reading is header commentary; what is checked is
--     that this fibre is not a proposition.)
--
-- So the Born ½ and the spinor ½ are not two numbers; they are one map's
-- śeṣa, bound the two ways the fibre law names.  Everything the session's
-- charge modules said — abelian = free = road one, charge/torsion/loss =
-- road two — is this one dichotomy.
--
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module DvigunaSesa_TheHalfIsTheSesaOfDoublingSoBornIsRoadOneAndTheSpinorIsRoadTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _⊕_ ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

-- The śeṣa of doubling over c: the halves of c.  (Punaragamana's fibre,
-- at the map x ↦ x + x.)
शेष : {ℓ : Level} {W : Type ℓ} (_+_ : W → W → W) → W → Type ℓ
शेष {W = W} _+_ c = Σ[ x ∈ W ] ((x + x) ≡ c)

-- ROAD ONE.  The half rides free: the śeṣa is a proposition.  This is
-- EkatvaMatraDvaya's `halvesUniquely` — the hypothesis that forces Born ½.
Born : {ℓ : Level} {W : Type ℓ} (_+_ : W → W → W) → W → Type ℓ
Born _+_ c = isProp (शेष _+_ c)

-- ROAD TWO over ℤ/2 = (Bool, ⊕).  The śeṣa over 0 carries content: two
-- points, and the nonzero one is the torsion generator — the spinor.
spinor : शेष _⊕_ false          -- (true, refl): true ⊕ true ≡ false, and true ≠ 0
spinor = true , refl

vacuum : शेष _⊕_ false           -- (false, refl): the trivial half
vacuum = false , refl

-- so the śeṣa over 0 is NOT a proposition: road two, the content the free
-- binding hid.  The half of zero is not unique — that non-uniqueness IS
-- the spinor.
road-two : ¬ (Born _⊕_ false)
road-two hp = true≢false (cong fst (hp spinor vacuum))
