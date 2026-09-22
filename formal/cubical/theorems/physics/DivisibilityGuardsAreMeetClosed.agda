{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DivisibilityGuardsAreMeetClosed
--
-- The divisibility guards, with `D_d ∩ D_e = D_lcm(d,e)`, are a
-- corpus-native intersection-closed guard family (§6.1).
--
-- Mechanised here WITHOUT unique factorisation: the meet law is
-- exactly the lcm's universal property, so it needs no factorisation at
-- all.  That is a narrowing of §6.1's own account of its proof (§4
-- below).
--
-- The lcm is taken by its universal property rather than constructed:
-- `IsLcm d e l` says l is a common multiple that divides every common
-- multiple.  Existence of such an l is a hypothesis of every statement
-- below.
--
-- This is NOT an instance of `ElsewhereCondition.directedRooted`: its
-- `Guard A = A → Bool`, so a guard there is a DECISION, while `D d`
-- below is a  — a search for the cofactor.  Turning `D d` into a
-- `Guard` is exactly the step of deciding divisibility.  So §6.1's
-- family is meet-closed as stated, and the thing standing between it
-- and `directedRooted` is a decision.
--
-- That is the same axis as
-- `AskingIsNotAPropertyOfTheFunction` and
-- `PermanentUnsaidIsStableAndTemporaryIsASearch`, met
-- here from a third direction.
------------------------------------------------------------------------

module DivisibilityGuardsAreMeetClosed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _·_ ; ·-assoc)
open import Cubical.Data.Sigma

------------------------------------------------------------------------
-- 1.  Divisibility, and the guard it names
------------------------------------------------------------------------

_divides_ : ℕ → ℕ → Type
d divides x = Σ[ k ∈ ℕ ] (x ≡ k · d)

-- the guard "d divides the point"
D : ℕ → ℕ → Type
D d x = d divides x

divides-trans : {a b c : ℕ} → a divides b → b divides c → a divides c
divides-trans {a} {b} {c} (k , b≡ka) (j , c≡jb) =
  j · k , c≡jb ∙ cong (j ·_) b≡ka ∙ ·-assoc j k a

------------------------------------------------------------------------
-- 2.  The lcm by its universal property — no construction, no
--     factorisation
------------------------------------------------------------------------

record IsLcm (d e l : ℕ) : Type where
  field
    d∣l   : d divides l
    e∣l   : e divides l
    least : (m : ℕ) → d divides m → e divides m → l divides m

open IsLcm public

------------------------------------------------------------------------
-- 3.  THE MEET LAW.  D_l is exactly D_d ∩ D_e, pointwise, both ways.
------------------------------------------------------------------------

lcmGuard→both :
  {d e l : ℕ} → IsLcm d e l → (x : ℕ) → D l x → (D d x × D e x)
lcmGuard→both isl x lx =
  divides-trans (isl .d∣l) lx , divides-trans (isl .e∣l) lx

both→lcmGuard :
  {d e l : ℕ} → IsLcm d e l → (x : ℕ) → (D d x × D e x) → D l x
both→lcmGuard isl x (dx , ex) = isl .least x dx ex

-- and therefore the directedness hypothesis §2 asks for, at any point
-- where both guards fire: a third guard that fires there and is narrower
-- than both EVERYWHERE, not just at that point.
divisibilityIsDirected :
  {d e l : ℕ} → IsLcm d e l → (x : ℕ) → D d x → D e x
  → (D l x) × ((y : ℕ) → D l y → (D d y × D e y))
divisibilityIsDirected isl x dx ex =
    both→lcmGuard isl x (dx , ex)
  , lcmGuard→both isl

------------------------------------------------------------------------
-- 4.  The narrowing of §6.1
--
-- §6.1 says the meet law is "PROVED on paper in one line from unique
-- factorisation".  §3 uses no factorisation: `both→lcmGuard` IS the
-- universal property applied, and `lcmGuard→both` is two transitivities.
-- Unique factorisation is needed for a different sentence in the same
-- paragraph — that `D_d ⋐ D_e` iff `v_p(e) ≤ v_p(d)` for every p, which
-- is about valuations and is not the subject of this module.
--
-- So: the meet law is the lcm's universal property and needs no
-- factorisation; unique factorisation is what turns the containment
-- order into the valuation coordinate.  The existence of the lcm is a
-- third statement again, independent of the other two; here it is the
-- hypothesis `IsLcm`.
------------------------------------------------------------------------
