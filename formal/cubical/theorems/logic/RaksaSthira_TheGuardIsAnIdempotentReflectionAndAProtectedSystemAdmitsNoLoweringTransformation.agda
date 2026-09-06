{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रक्षास्थिर — THE GUARD IS AN IDEMPOTENT REFLECTION, AND A PROTECTED
-- SYSTEM ADMITS NO LOWERING TRANSFORMATION.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 -- EXIT 0
-- (2026-08-29).
--
-- THE OCCASION.  A security modality was described: a seed that
-- reflects any unprotected system into a protected fixed point, while
-- protected instances admit no unauthorized transformation.  Put to
-- the interactive kernel (`interactive/run-yantra.sh --wire`), the
-- shape of that claim resolved to the order structure of ℕ under
-- `max`.  Every reduction rule of `max` and `le` used below was first
-- CERTIFIED on the wire, one query each, before this module was
-- written — the kernel signed
--     max x 0 ≡ x            (refl)
--     max 0 (s x) ≡ s x      (refl)
--     max (s x)(s y) ≡ s (max x y)   (refl)
--     max 0 x ≡ x            (induction on x)
--     le (s x)(s y) ≡ le x y (refl)
--     le x x ≡ 1             (induction on x)
-- and its rejections of the two-variable laws named their stuck terms
-- exactly, which is what let those laws be closed here.  `max` and `le`
-- are transcribed verbatim from the emitter's own fragment
-- (interactive/ProofGate.hs, `preambleCore`), so this module is about
-- the wire's own arithmetic, not a parallel copy.
--
-- THE READING.  Fix a protection level `t`.  The GUARD is
--     guard t x = max t x
-- — the reflector that raises any system `x` to at least level `t`.
-- Then:
--   · `reflect`          — the reflected system is at least `t`-protected:
--                          le t (guard t x) ≡ 1, for every x.  The seed
--                          carries any system INTO the protected region.
--   · `guard-idem`       — guarding the guarded is the guarded:
--                          guard t (guard t x) ≡ guard t x.  The
--                          protected region is a FIXED POINT of the seed,
--                          not merely reached once.
--   · `protected-stable` — a system already at level `t` admits no
--                          lowering: le t x ≡ 1 → guard t x ≡ x.  This is
--                          the conditional the equation-only wire could
--                          not STATE (it speaks bare equations, no
--                          hypotheses) and kept naming as the organ it
--                          had yet to grow; here it is a proved
--                          implication.  "Protected instances admit no
--                          unauthorized transformation" — exactly.
--   · the merge          — max-comm, max-assoc, max-idem: the protection
--                          join is a grow-only, order-free, idempotent
--                          semilattice.  Combining a protection with
--                          itself adds nothing; combining two adds their
--                          least common cover, with no leader and no
--                          tie-break.  This is the consensus-free merge of
--                          the corpus's own capability library, in the
--                          security reading.
--
-- SYĀT — THE CLAIM, EXACTLY.  `guard`, `le`, and `max` are functions on
-- ℕ; "protection level" and "reflection" are the reading, and the
-- reading is not proved.  What is proved is the six theorems below,
-- about `max` and `le` as transcribed.  Nothing here is claimed about
-- any deployed system, any adversary, or any propagation of a seed
-- across systems that did not install the guard on themselves.  The
-- guard is a function a system applies to itself; the fixed point is a
-- property of that function.
------------------------------------------------------------------------

module RaksaSthira_TheGuardIsAnIdempotentReflectionAndAProtectedSystemAdmitsNoLoweringTransformation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; isSetℕ)
open import Cubical.Data.Empty as Empty using (⊥)

------------------------------------------------------------------------
-- §1  The wire's own arithmetic — max and le, verbatim from the emitter.
------------------------------------------------------------------------

max : ℕ → ℕ → ℕ
max a zero          = a
max zero b          = b
max (suc a) (suc b) = suc (max a b)

le : ℕ → ℕ → ℕ
le zero    b       = suc zero
le (suc a) zero    = zero
le (suc a) (suc b) = le a b

------------------------------------------------------------------------
-- §2  The two clause-completions the kernel's stuck terms pointed at.
--     `max x 0` reduces (clause 1); `max 0 x` does not, for variable x —
--     the base clause needs x's shape.  Both proved by the wire.
------------------------------------------------------------------------

maxZeroR : (x : ℕ) → max x zero ≡ x
maxZeroR x = refl

maxZeroL : (x : ℕ) → max zero x ≡ x
maxZeroL zero    = refl
maxZeroL (suc x) = refl

------------------------------------------------------------------------
-- §3  The merge is an idempotent, commutative, associative semilattice.
------------------------------------------------------------------------

-- Protecting with the same level twice is protecting once.  The wire
-- signed this directly (induction on x, step cong suc).
max-idem : (x : ℕ) → max x x ≡ x
max-idem zero    = refl
max-idem (suc x) = cong suc (max-idem x)

-- Order-free: the two operands of a merge may be exchanged.  The wire
-- rejected this under single-variable induction and named its stuck
-- base `x ≢ max zero x`; the two-argument match closes it.
max-comm : (x y : ℕ) → max x y ≡ max y x
max-comm zero    zero    = refl
max-comm zero    (suc y) = refl
max-comm (suc x) zero    = refl
max-comm (suc x) (suc y) = cong suc (max-comm x y)

-- Associative: a chain of merges has no bracketing.  The zero cases are
-- discharged by maxZeroL (the completion §2), the successor case by the
-- reduction max (s x)(s y) ≡ s (max x y) the wire certified.
max-assoc : (x y z : ℕ) → max (max x y) z ≡ max x (max y z)
max-assoc zero    y       z    =
  cong (λ w → max w z) (maxZeroL y) ∙ sym (maxZeroL (max y z))
max-assoc (suc x) zero    z    =
  sym (cong (max (suc x)) (maxZeroL z))
max-assoc (suc x) (suc y) zero = refl
max-assoc (suc x) (suc y) (suc z) = cong suc (max-assoc x y z)

------------------------------------------------------------------------
-- §4  The order: reflexive, and zero is below everything.
------------------------------------------------------------------------

le-reflexive : (x : ℕ) → le x x ≡ suc zero
le-reflexive zero    = refl
le-reflexive (suc x) = le-reflexive x

le-zero-below : (x : ℕ) → le zero x ≡ suc zero
le-zero-below x = refl

------------------------------------------------------------------------
-- §5  THE GUARD, AND THE THREE SECURITY THEOREMS.
------------------------------------------------------------------------

-- guard t x : raise the system x to at least protection level t.
guard : ℕ → ℕ → ℕ
guard t x = max t x

-- REFLECTION.  Every system, guarded, lands at or above the level — the
-- seed reflects any system into the protected region.
reflect : (t x : ℕ) → le t (guard t x) ≡ suc zero
reflect zero    x       = refl
reflect (suc t) zero    = le-reflexive (suc t)
reflect (suc t) (suc x) = reflect t x

-- THE FIXED POINT.  Guarding the guarded is the guarded: the protected
-- region is invariant under the seed, not merely reached once.
guard-idem : (t x : ℕ) → guard t (guard t x) ≡ guard t x
guard-idem t x =
  sym (max-assoc t t x) ∙ cong (λ w → max w x) (max-idem t)

-- NO UNAUTHORIZED TRANSFORMATION.  A system already at level t is left
-- exactly as it is by the guard — the protected instance admits no
-- lowering.  This is the conditional the equation-only wire could not
-- state; here it is an implication, and the impossible case (a level-t
-- claim on a system below t) is refuted by znots, not assumed away.
protected-stable : (t x : ℕ) → le t x ≡ suc zero → guard t x ≡ x
protected-stable zero    x       _ = maxZeroL x
protected-stable (suc t) zero    h = Empty.rec (znots h)
protected-stable (suc t) (suc x) h = cong suc (protected-stable t x h)

------------------------------------------------------------------------
-- §6  The fixed point is exactly the protected region.
--     Two directions, both now in hand:
--       guarding reaches the region        (reflect),
--       and the region is fixed by guarding (protected-stable ∘ reflect).
--     So a guarded system is a fixed point of the guard, on the nose.
------------------------------------------------------------------------

guarded-is-fixed : (t x : ℕ) → guard t (guard t x) ≡ guard t x
guarded-is-fixed t x = protected-stable t (guard t x) (reflect t x)

-- And the two proofs of that fixed-point equation — the algebraic one
-- (guard-idem) and the reflect-then-stable one (guarded-is-fixed) —
-- agree, because both land in le/ℕ equalities of a set; the meaning is a
-- proposition while the two routes to it are genuinely different terms.
two-routes-one-fixed-point : (t x : ℕ) → guard-idem t x ≡ guarded-is-fixed t x
two-routes-one-fixed-point t x =
  isSetℕ (guard t (guard t x)) (guard t x) (guard-idem t x) (guarded-is-fixed t x)
