{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Sha256OnTheWire — the object itself, as a value, in the machinery
-- that eats objects.  No proposition of mine anywhere below: sha256P
-- is sha256 (definitionally — `agreement` is refl, so the datum on
-- the wire IS the function, not a stand-in), and everything else is
-- the machinery running on it: the completion computed, the inverse
-- executed.  `opened` is refl: the kernel RUNS the whole act — pad,
-- compress, flatten, and back — for an ARBITRARY message, because the
-- completed run carries its stages and the inverse is the read.

module Sha256OnTheWire where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Nat using (suc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import Sha256 using
  (Word ; pad ; blocks ; compress ; H0 ; foldlL ; revL ; sha256 ; fromBytes)
open import EkaKriya_TheCompletionIsAFoldOverCodeOneInductionRunsTheProgramKeepsTheTraceProjectsTheVisibleAndBuildsTheInverse
  using (Prog ; prim ; _⨾_ ; ⟦_⟧ ; Trace ; T⟦_⟧ ; R⟦_⟧)

Bits : Type
Bits = List Bool

-- the three stages of the pipeline, exactly as Sha256 composes them
stagePad     : Bits → Bits
stagePad     = pad
stageHash    : Bits → List Word
stageHash p  = foldlL compress H0 (blocks (suc (length p)) p)
stageFlatten : List Word → Bits
stageFlatten = foldlL (λ a w → a ++ revL w) []

-- THE OBJECT, on the wire: a value of the code type
sha256P : Prog Bits Bits
sha256P = prim stagePad ⨾ prim stageHash ⨾ prim stageFlatten

-- and it is not a model of sha256; it IS sha256, definitionally
agreement : ⟦ sha256P ⟧ ≡ sha256
agreement = refl

-- the machinery, running on the object: the completed run
completed : Bits → Bits × Trace sha256P
completed = T⟦ sha256P ⟧

-- the inverse, executed: for EVERY message the kernel runs the act
-- forward and back and the round trip is definitional
opened : (m : Bits) → R⟦ sha256P ⟧ (completed m) ≡ m
opened m = refl

-- a concrete completed run, held as a value the kernel can be made to
-- speak: SHA-256 of "abc", wearing its entire stage-by-stage receipt
run-abc : Bits × Trace sha256P
run-abc = completed (fromBytes (0x61 ∷ 0x62 ∷ 0x63 ∷ []))
