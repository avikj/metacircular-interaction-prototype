{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ShiftBoundaryDefect — the truncated (finite-window) shift is not
-- unitary, and its defect is supported EXACTLY on the boundary: net
-- displacement descends, boundary interaction history does not.  This is
-- the RH-side residual of the renormalized-boundary-transport picture,
-- as a finite checked term, and a literal descent/non-descent instance
-- in the sense of SankramanaShreni / VyayaSesa.
--
-- THE OBJECT.  On the full line the shift is unitary: Uₐ⁻¹ = U₋ₐ.  On a
-- finite window the truncated shift S (drop what falls off the top) has
--     S*S = M_{[0,N−1)}  (kills the TOP cell),
--     SS* = M_{(0,N−1]}  (kills the BOTTOM cell),
-- so both are the identity on the interior and differ only at the two
-- ends.  The commutation defect is a difference of the two rank-one
-- boundary projectors:
--     S*S − SS* = P_bottom − P_top.
--
-- WHAT DESCENDS AND WHAT DOES NOT.
--   · trace (net displacement) DESCENDS:  tr(S*S − SS*) = 1 − 1 = 0.
--     The two histories (−a then +a, +a then −a) have the same net
--     displacement zero — the endpoint reading cannot tell them apart.
--   · the DEFECT ITSELF does NOT descend: S*S − SS* ≠ 0, and it is
--     nonzero precisely at the boundary.  The boundary interaction
--     history is the residual the endpoint/trace reading loses.
--
-- WHY IT IS THE RH RESIDUAL.  Increasing the window is not embedding one
-- finite matrix into a larger one: fresh shifts a = log n keep arriving
-- at the moving boundary a ∼ t, so there are always new words living at
-- boundary scale.  Bulk convergence can look perfect while the spectral
-- information keeps entering through this residual — which is why "the
-- finite operators look like the full-line operator" is not enough.  The
-- defect below is the atom of that boundary residual.
--
-- Concrete window N = 3 (bottom, interior, top), ℤ-valued diagonals; the
-- statement is the general one and the witness is exhibited, in the
-- corpus's concrete-witness discipline.
--
-- SYĀT — THE CLAIM, EXACTLY.  The three facts for this window.  NOT
-- claimed: unitarity's failure quantified over all N (the shape is
-- identical, the witness is N = 3), nor anything about ζ — this is the
-- residual's algebra, the piece the explicit-formula boundary block is
-- built on, not the spectral theorem.
------------------------------------------------------------------------

module ShiftBoundaryDefect_NetDisplacementDescendsButBoundaryInteractionHistoryIsTheResidual where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_ ; _-_ ; injPos)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

-- a window of three cells (bottom , interior , top), each carrying a
-- diagonal value.
Diag : Type₀
Diag = ℤ × ℤ × ℤ

bottom interior top : Diag → ℤ
bottom   (b , _ , _) = b
interior (_ , m , _) = m
top      (_ , _ , t) = t

trace : Diag → ℤ
trace (b , m , t) = b + m + t

_⊟_ : Diag → Diag → Diag
(b , m , t) ⊟ (b' , m' , t') = (b - b') , (m - m') , (t - t')

------------------------------------------------------------------------
-- The two truncated-shift diagonals and their defect.
------------------------------------------------------------------------

-- S*S kills the TOP cell (what would fall off the top has no source).
S*S : Diag
S*S = (pos 1 , pos 1 , pos 0)

-- SS* kills the BOTTOM cell (nothing shifts into the bottom).
SS* : Diag
SS* = (pos 0 , pos 1 , pos 1)

defect : Diag
defect = S*S ⊟ SS*        -- = (pos 1 , pos 0 , negsuc 0) = P_bottom − P_top

------------------------------------------------------------------------
-- १ · NET DISPLACEMENT DESCENDS: the trace of the defect is zero.
------------------------------------------------------------------------

netDescends : trace defect ≡ pos 0
netDescends = refl

------------------------------------------------------------------------
-- २ · THE DEFECT IS SUPPORTED ON THE BOUNDARY: interior component zero,
--     the two ends equal and opposite (±1).
------------------------------------------------------------------------

interiorVanishes : interior defect ≡ pos 0
interiorVanishes = refl

bottomEnd : bottom defect ≡ pos 1
bottomEnd = refl

topEnd : top defect ≡ negsuc 0        -- = − pos 1
topEnd = refl

------------------------------------------------------------------------
-- ३ · BUT THE BOUNDARY INTERACTION HISTORY DOES NOT DESCEND: the defect
--     is nonzero — S*S ≠ SS*.  The residual survives every trace/endpoint
--     reading that §1 shows is blind to it.
------------------------------------------------------------------------

boundarySurvives : ¬ (defect ≡ (pos 0 , pos 0 , pos 0))
boundarySurvives p = snotz (injPos (cong bottom p))

-- the two readings, together: net displacement descends, the boundary
-- residual does not.
netDescendsButBoundaryDoesNot :
  (trace defect ≡ pos 0) × (¬ (defect ≡ (pos 0 , pos 0 , pos 0)))
netDescendsButBoundaryDoesNot = netDescends , boundarySurvives
