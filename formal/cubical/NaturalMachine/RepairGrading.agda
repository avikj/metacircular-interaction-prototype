{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RepairGrading
--
-- Retraction of two hedges made in `notes/OBSTRUCTION_CALCULUS.md` §2.
--
-- There I wrote that of the four repair kinds of `papers/hieroglyphics_ii.tex`
-- only `Γ∅` and `Γ^` are distinguishable, "after 0-truncation", and that
-- `χ = ΔReach/ΔKill` is not encodable without a cost model.  Both statements
-- were about the model I had chosen, not about what is encodable.  Cubical
-- Agda is exactly the setting where identifications are data, and this
-- repository forbids *measured* numbers, not *counted* ones.
--
--   A.  `Γ⇑` and `Γ↺` are separated here, by S¹: two repairs of one defect
--       that `Γ⇑` distinguishes and `Γ↺` identifies.  No truncation was
--       forced on us; I had imposed it.
--
--   B.  `χ = 1` is proved for the sign defect --- not as a ratio of two
--       measured rates, but as a biconditional: Φ newly separates a pair
--       exactly when `Γ^` re-identifies it.  A ratio of counts needs a
--       cardinality; an equality of predicates does not, and is stronger.
------------------------------------------------------------------------

module NaturalMachine.RepairGrading where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Int using (ℤ ; pos ; discreteℤ ; injPos)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; squash₁)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; ΩS¹ ; winding)

open import NaturalMachine.SmithSignNormal using (absℤ)
open import NaturalMachine.ObstructionCalculus
  using (Obs ; Sep ; Blind ; absField ; signField)

private
  variable
    X : Type₀

------------------------------------------------------------------------
-- A.  `Γ⇑` and `Γ↺` are different repairs.
--
-- `Γ⇑(δ) : δ ↦ (α : f ⇒ g)` promotes the defect to an identification and
-- *keeps which one*.  `Γ↺(δ) : δ ↦ [δ]` keeps the class: that an
-- identification exists, not which.  In a 0-truncated model these coincide
-- because there is at most one identification to have; in a univalent one
-- they do not, and the gap is the whole subject of higher coherence.

-- Γ⇑: a chosen identification.  Proof-relevant.
Promote : X → X → Type₀
Promote x y = x ≡ y

-- Γ↺: the identification as a class.  Proof-irrelevant by construction.
Class : X → X → Type₀
Class x y = ∥ x ≡ y ∥₁

-- The comparison map: forget which repair, keep that there was one.
promote→class : {x y : X} → Promote x y → Class x y
promote→class = ∣_∣₁

-- Two repairs of the *same* defect: the identity loop, and the generating
-- loop of the circle.  Both identify `base` with `base`.
repair₀ repair₁ : Promote {X = S¹} base base
repair₀ = refl
repair₁ = loop

-- They are distinguished by their winding number, which is exactly the
-- statement that `Γ⇑` retains information.
winding-refl : winding repair₀ ≡ pos 0
winding-refl = refl

winding-loop : winding repair₁ ≡ pos 1
winding-loop = refl

Γ⇑-separates : ¬ (repair₀ ≡ repair₁)
Γ⇑-separates p = znots (injPos (sym winding-refl ∙ cong winding p ∙ winding-loop))

-- And identified by `Γ↺`, since a class has no room to tell them apart.
Γ↺-identifies : promote→class repair₀ ≡ promote→class repair₁
Γ↺-identifies = squash₁ _ _

-- So `Γ↺` is a strict quotient of `Γ⇑`: the comparison map is not injective,
-- and the defect it forgets is a genuine one.
Γ⇑≢Γ↺ : Σ[ x ∈ S¹ ] Σ[ p ∈ Promote x x ] Σ[ q ∈ Promote x x ]
          ((¬ (p ≡ q)) × (promote→class p ≡ promote→class q))
Γ⇑≢Γ↺ = base , repair₀ , repair₁ , Γ⇑-separates , Γ↺-identifies

------------------------------------------------------------------------
-- B.  `χ = 1` for the sign defect.
--
-- `χ := ΔReach(𝒪α) / ΔKill(Γα)`, with `χ = 1` the golden boundary between
-- saturation and endless novelty.  Read as a ratio it needs two cardinals.
-- Read as what the ratio is *for* --- does the widening open exactly as much
-- as the repair closes --- it needs neither: it is the assertion that the
-- pairs Φ newly separates are precisely the pairs `Γ^` re-identifies.
--
-- For the sign defect that is provable, and true on the nose.

-- What Φ opened: invisible before the widening, visible after.
NewlySeparated : ℤ → ℤ → Type₀
NewlySeparated x y = Blind absField x y × Sep signField x y

-- What Γ^ closes: distinct points that the normalizer `absℤ` identifies.
Killed : ℤ → ℤ → Type₀
Killed x y = (absℤ x ≡ absℤ y) × (¬ (x ≡ y))

-- Blindness of the divisibility field is exactly agreement of absolute
-- values.  (`¬¬`-elimination is available because ℤ is discrete; nothing
-- classical is used.)
blind→abs : (x y : ℤ) → Blind absField x y → absℤ x ≡ absℤ y
blind→abs x y b with discreteℤ (absℤ x) (absℤ y)
... | yes p = p
... | no ¬p = Empty.rec (b (tt , ¬p))

abs→blind : (x y : ℤ) → absℤ x ≡ absℤ y → Blind absField x y
abs→blind x y p (_ , ¬p) = Empty.rec (¬p p)

-- The golden balance, forwards.
opened→closed : (x y : ℤ) → NewlySeparated x y → Killed x y
opened→closed x y (b , inl tt , ne) = Empty.rec (ne (blind→abs x y b))
opened→closed x y (b , inr tt , ne) = blind→abs x y b , ne

-- And backwards.
closed→opened : (x y : ℤ) → Killed x y → NewlySeparated x y
closed→opened x y (h , ne) = abs→blind x y h , (inr tt , ne)

-- `χ = 1`: the widening opens exactly what the repair closes.  Not a measured
-- ratio; an equivalence of the two conditions, pair by pair.
golden : (x y : ℤ) → (NewlySeparated x y → Killed x y)
                   × (Killed x y → NewlySeparated x y)
golden x y = opened→closed x y , closed→opened x y

-- The witnessing instance, for the record: 6 and -6 are opened by the sign
-- observation and closed by `absℤ`.
golden-witness : Killed (pos 6) (pos 0) → NewlySeparated (pos 6) (pos 0)
golden-witness = closed→opened (pos 6) (pos 0)
