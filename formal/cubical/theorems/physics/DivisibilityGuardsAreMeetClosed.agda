{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DivisibilityGuardsAreMeetClosed
--
-- `notes/ELSEWHERE_CONDITION_IS_INCOMPLETE.md` §6.1 supplies a
-- corpus-native intersection-closed guard family — the divisibility
-- guards, with `D_d ∩ D_e = D_lcm(d,e)` — and says of it:
--
--   "PROVED on paper in one line from unique factorisation; **not**
--    mechanised here — the Agda module carries no divisibility
--    instance."
--
-- Mechanised here, and WITHOUT unique factorisation: the meet law is
-- exactly the lcm's universal property, so it needs no factorisation at
-- all.  That is a narrowing of §6.1's own account of its proof, offered
-- for its author (§4 below), not applied.
--
-- Cubical v0.5 has no lcm module.  Per the standing idiom in this
-- corpus, the lcm is therefore taken by its universal property rather
-- than constructed: `IsLcm d e l` says l is a common multiple that
-- divides every common multiple.  Nothing below asserts that such an l
-- exists — existence is a separate obligation and is NOT discharged.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES NOT DO, and it is the interesting half
--
-- This does NOT become an instance of `ElsewhereCondition.directedRooted`.
-- I read that module: its `Guard A = A → Bool`, so a guard there is a
-- DECISION, while `D d` below is a Σ — a search for the cofactor.
-- Turning `D d` into a `Guard` is exactly the step of deciding
-- divisibility, which is available for ℕ but is not free and is not
-- done here.  So §6.1's family is meet-closed as stated, and is still
-- not plugged in, and the thing standing between them is a decision.
--
-- That is the same axis as
-- `AskingIsNotAPropertyOfTheFunction` and
-- `PermanentUnsaidIsStableAndTemporaryIsASearch`, met
-- here from a third direction and not by design.
--
-- WHAT IS NOT CLAIMED.  Nothing about §6's OPEN conjecture (whether the
-- pratyāhāra system is the ∩-closure §2 requires) — that needs the
-- external sūtra corpus, which is EGRESS_BLOCKED, and it stays open.
-- Nothing about Petersen 2004, NOT proved and NOT read.  No claim that
-- divisibility guards model any Pāṇinian guard.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
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
-- 4.  A narrowing offered to §6.1, NOT applied
--
-- §6.1 says the meet law is "PROVED on paper in one line from unique
-- factorisation".  §3 uses no factorisation: `both→lcmGuard` IS the
-- universal property applied, and `lcmGuard→both` is two transitivities.
-- Unique factorisation is needed for a different sentence in the same
-- paragraph — that `D_d ⋐ D_e` iff `v_p(e) ≤ v_p(d)` for every p, which
-- is genuinely about valuations and is NOT proved here.
--
-- Suggested replacement, for that note's author to take or leave:
--
--   "the meet law is the lcm's universal property and needs no
--    factorisation; unique factorisation is what turns the containment
--    order into the valuation coordinate."
--
-- The existence of the lcm is a third statement again, and none of the
-- three is discharged by the other two.  Nothing here constructs one.
------------------------------------------------------------------------
