{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SetBaseNoMonodromy
--
-- DELTA 14, PROGRAM 14.76 — THE KILL TEST, ANSWERED.
--
-- Delta 14 §D asks, verbatim:
--
--   "Search for actual loop transport on those fibers; if every loop
--    acts trivially, kill the parity-monodromy route."
--
-- `PerspectiveCore` supplies the type to inhabit,
--
--   MonodromyOf F b p = Σ[ x ∈ F b ] (subst F p x ≡ x → ⊥)
--
-- and its C14.25 warning: a two-element fibre plus a section is NOT an
-- obstruction, because `B × Bool → B` has both and trivial transport.
-- An obstruction needs SHEET EXCHANGE, exhibited separately.
--
--
-- THE VERDICT, AND THE SINGLE FACT THAT DECIDES IT
--
-- The verdict is **DISSOLVED, and the parity-monodromy route dies with
-- it**.  The deciding fact is one line of homotopy type theory:
--
--   `setNoMonodromy` : if the BASE is a set (a 0-type), then
--   `MonodromyOf F b p` is uninhabited for EVERY family `F`, EVERY
--   point `b`, and EVERY loop `p` — not because the transport happens
--   to be trivial, but because `p ≡ refl`.
--
-- And every base in the sieve lane is a set:
--   * `Vis = ℕ × ℕ × ℕ` — `SieveFiber.isSetVis`;
--   * `Sieve = Dom / ∼`  — `SQ.squash/`, a set by construction;
--   * `Bool` (the charge index) — `isSetBool`.
--
-- So there is no loop for monodromy to be about.  This is NOT the
-- statement "we looked for a nontrivial loop action and found none";
-- it is the statement "the question does not arise in a 0-truncated
-- base, and every base this lane has built is 0-truncated".  Any
-- obstruction in the sieve lane must therefore come from somewhere
-- other than loop transport, and reviving the parity-monodromy route
-- requires FIRST exhibiting an index object that is not a set.
--
-- This strictly generalises `PerspectiveCore.constNoMonodromy`, which
-- covers only CONSTANT families (over any base) — including the sieve
-- fibration's own varying families, which that lemma explicitly does
-- not reach (see its `SCOPE` paragraph).  Over a set base, varying is
-- as harmless as constant.
--
--
-- THE NEGATIVE IS NOT VACUOUS: `MonodromyOf` IS INHABITABLE
--
-- A negative result about an uninhabitable type would be worthless, so
-- §3 exhibits a genuine inhabitant: the Bool double cover of the
-- circle, `Cover base = Bool`, `Cover (loop i) = notEq i`.  Transport
-- along `loop` exchanges the two sheets, so `s¹Monodromy` inhabits
-- `MonodromyOf Cover base loop`.  Consequences, both checked:
--
--   * the definition has content — sheet exchange is a real phenomenon
--     that a family CAN have;
--   * `S¹NotSet` — `isSet S¹ → ⊥`, derived from the two results above,
--     which is the contrapositive reading: the ONLY way to get
--     monodromy is a base that is not a set.
--
--
-- WHAT IS NOT CLAIMED
--
--  * Nothing here is new mathematics.  "A set has no nontrivial loops"
--    is `isSet`'s definition; the Bool cover of S¹ is the standard
--    first example of a nonconstant family in every HoTT text and in
--    cubical v0.5's own `Cubical.HITs.S1`.  The contribution is that
--    the machine now HAS the sieve lane's instance as a checked term,
--    so the kill test is settled by citation and not by re-argument.
--  * No claim that the sieve lane has no obstruction.  It has one —
--    `SieveFiber.noChargePreservingSection`.  The claim is only that
--    the obstruction is not, and cannot be, a monodromy.
--  * No claim about bases nobody has built.  If a later lane produces a
--    charge index with higher structure (a groupoid of sieve states, a
--    delooping, a torsor with a nontrivial automorphism), this file
--    says nothing against it — it says that lane must supply the
--    non-set base first, and `S¹NotSet` is the template for what that
--    supply looks like.
------------------------------------------------------------------------

module SetBaseNoMonodromy where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; notEq ; true≢false ; isSetBool)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.HITs.S1 using (S¹ ; base ; loop)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; squash/)

open import PerspectiveCore using (MonodromyOf)
open import SieveFiber using (Vis ; isSetVis ; Sieve)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  THE GENERAL THEOREM
--
-- A 0-truncated base admits no monodromy, for any family whatsoever.
------------------------------------------------------------------------

-- The deciding lemma.  `hB b b refl p : refl ≡ p` is the whole proof:
-- the loop is not merely acting trivially, it IS the trivial loop.
setNoMonodromy :
  {B : Type ℓ} → isSet B
  → (F : B → Type ℓ') (b : B) (p : b ≡ b)
  → MonodromyOf F b p → ⊥
setNoMonodromy {B = B} hB F b p (x , nontrivial) =
  nontrivial (subst (λ r → subst F r x ≡ x) (hB b b refl p) (substRefl {B = F} x))

-- The same statement in the shape a lane hunting an obstruction wants:
-- over a set base there is no loop to hunt on.
setLoopIsRefl : {B : Type ℓ} → isSet B → (b : B) (p : b ≡ b) → p ≡ refl
setLoopIsRefl hB b p = hB b b p refl

------------------------------------------------------------------------
-- §2  THE SIEVE INSTANCES
--
-- Every base the sieve lane has built is a set, so 14.76's search
-- terminates immediately at each of them.
------------------------------------------------------------------------

-- The visible sieve state `Vis = ℕ × ℕ × ℕ` (SieveFiber §3).
visNoMonodromy :
  (F : Vis → Type ℓ) (v : Vis) (p : v ≡ v) → MonodromyOf F v p → ⊥
visNoMonodromy = setNoMonodromy isSetVis

-- The actual set quotient `Sieve = Dom / ∼` (SieveFiber §7), i.e. the
-- HIT the proposal asked to be built.  A set quotient is a set by
-- construction, so this holds before any arithmetic is inspected.
sieveNoMonodromy :
  (F : Sieve → Type ℓ) (s : Sieve) (p : s ≡ s) → MonodromyOf F s p → ⊥
sieveNoMonodromy = setNoMonodromy squash/

-- The charge index itself (Ω mod 2, valued in `Bool`).  This is the
-- base of Program 14.74's grading, so 14.74 inherits the verdict too.
chargeNoMonodromy :
  (F : Bool → Type ℓ) (r : Bool) (p : r ≡ r) → MonodromyOf F r p → ⊥
chargeNoMonodromy = setNoMonodromy isSetBool

------------------------------------------------------------------------
-- §3  THE CONTROL: `MonodromyOf` IS INHABITABLE
--
-- Without this section §§1–2 would be compatible with `MonodromyOf`
-- being empty for silly reasons.  It is not.
------------------------------------------------------------------------

-- The Bool double cover of the circle.  `notEq : Bool ≡ Bool` is
-- cubical v0.5's involution path for `not`, and it computes:
-- `transp (λ i → notEq i) i0 true` reduces to `false`.
Cover : S¹ → Type
Cover base       = Bool
Cover (loop i)   = notEq i

-- Sheet exchange, by normalisation.
coverTransport : subst Cover loop true ≡ false
coverTransport = refl

-- … and therefore an inhabitant of `MonodromyOf`: the loop acts
-- non-identically on the fibre.  This is exactly what C14.25 demands of
-- anyone claiming a binary obstruction, and exactly what the sieve
-- lane cannot supply.
s¹Monodromy : MonodromyOf Cover base loop
s¹Monodromy = true , λ p → true≢false (sym p ∙ coverTransport)

-- The contrapositive of §1, and the reason the verdict is structural:
-- monodromy forces the base out of the 0-types.
S¹NotSet : isSet S¹ → ⊥
S¹NotSet h = setNoMonodromy h Cover base loop s¹Monodromy
