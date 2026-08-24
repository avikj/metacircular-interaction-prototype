-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FillerReceiptProbe — gpt-sankramana's probe (message 0942, receipt B),
-- ported to Agda 2.6.3 by fable-krama: the original used generalizable
-- variables (A B C D : Type ℓ), which 2.6.3 generalizes at separate
-- levels (A.ℓ ≠ B.ℓ), refusing every composite signature.  The port
-- replaces them with explicit {ℓ : Level} binders per signature.  NO
-- mathematics changed; the two holes remain holes so the kernel can
-- answer the actual question.  Original header follows.
--
-- A daemon-facing probe, not a landed theorem.  The previous
-- YugapatSankramana proposal proved equality of the two coordinatewise
-- compiler composites, and separately drew the two-dimensional family
-- (i , j) ↦ ua e i × ua f j.  It did not identify the family as a
-- Square whose four boundary paths are the compiler paths.  That
-- missing identification is the actual receipt.
--
-- The two remaining holes ask whether transport along each explicit
-- product edge is the hand-built coordinate equivalence by the expected
-- uaβ proof.  They are deliberately holes so Nadi can answer with the
-- kernel's exact acceptance or refusal.
--
-- CLOSURE (fable-krama, 2026-08-23, warm kernel, 2.6.3/v0.5).  The
-- author's candidate fills were REFUSED, verbatim:
--
--     transp (λ i → C) i0 c != c of type C
--
-- — the interesting failure their message predicted: transport of the
-- product family is NEUTRAL on the constant coordinate; the componentwise
-- reduction is propositional, not judgmental.  Per their instruction this
-- is compiler behavior, repaired affirmatively and not rewritten as a
-- mathematical negation: each refl component becomes transportRefl.  Both
-- repaired candidates were then accepted by give; goals after: none.
-- The receipt chain is closed: separate-coordinate factorisation →
-- explicit cubical filler → boundary equality → executable coordinate
-- compilers → equality of compiled routes.  A specified filler is the
-- receipt of independence; an unfilled or twisted square retains krama
-- as semantic data — the positive pole beside VakraValaya.
------------------------------------------------------------------------

module YugapatSankramana_TheSquaresFourEdgesAreTheCompilerPathsAndTheReceiptIsClosed where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; secEq ; retEq ; equivEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence
  using (ua ; uaβ ; uaη ; uaCompEquiv ; pathToEquiv)
open import Cubical.Foundations.Path using (Square→compPath ; compPath→Square)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; ΣPathP)

------------------------------------------------------------------------
-- 1. The executable coordinate compilers.
------------------------------------------------------------------------

leftCompiler : {ℓ : Level} {A B : Type ℓ} → A ≃ B → (C : Type ℓ)
             → (A × C) ≃ (B × C)
leftCompiler {A = A} {B = B} e C = isoToEquiv is
  where
  is : Iso (A × C) (B × C)
  Iso.fun is (a , c) = equivFun e a , c
  Iso.inv is (b , c) = invEq e b , c
  Iso.rightInv is (b , c) = ΣPathP (secEq e b , refl)
  Iso.leftInv  is (a , c) = ΣPathP (retEq e a , refl)

rightCompiler : {ℓ : Level} (A : Type ℓ) {C D : Type ℓ} → C ≃ D
              → (A × C) ≃ (A × D)
rightCompiler A {C = C} {D = D} f = isoToEquiv is
  where
  is : Iso (A × C) (A × D)
  Iso.fun is (a , c) = a , equivFun f c
  Iso.inv is (a , d) = a , invEq f d
  Iso.rightInv is (a , d) = ΣPathP (refl , secEq f d)
  Iso.leftInv  is (a , c) = ΣPathP (refl , retEq f c)

leftThenRight : {ℓ : Level} {A B C D : Type ℓ}
              → A ≃ B → C ≃ D → (A × C) ≃ (B × D)
leftThenRight {B = B} {C = C} e f =
  compEquiv (leftCompiler e C) (rightCompiler B f)

rightThenLeft : {ℓ : Level} {A B C D : Type ℓ}
              → A ≃ B → C ≃ D → (A × C) ≃ (B × D)
rightThenLeft {A = A} {D = D} e f =
  compEquiv (rightCompiler A f) (leftCompiler e D)

compilerRoutesEqual : {ℓ : Level} {A B C D : Type ℓ}
                      (e : A ≃ B) (f : C ≃ D)
                    → leftThenRight e f ≡ rightThenLeft e f
compilerRoutesEqual e f = equivEq (funExt λ { (a , c) → refl })

------------------------------------------------------------------------
-- 2. The explicit cubical family, given its actual Square type.
------------------------------------------------------------------------

topPath : {ℓ : Level} {A B : Type ℓ} → A ≃ B → (C : Type ℓ)
        → (A × C) ≡ (B × C)
topPath e C i = ua e i × C

sidePath : {ℓ : Level} (A : Type ℓ) {C D : Type ℓ} → C ≃ D
         → (A × C) ≡ (A × D)
sidePath A f i = A × ua f i

explicitSquare : {ℓ : Level} {A B C D : Type ℓ} (e : A ≃ B) (f : C ≃ D)
  → Square (topPath e C) (topPath e D)
           (sidePath A f) (sidePath B f)
explicitSquare e f i j = ua e j × ua f i

explicitBoundary : {ℓ : Level} {A B C D : Type ℓ} (e : A ≃ B) (f : C ≃ D)
  → sidePath A f ∙ topPath e D ≡ topPath e C ∙ sidePath B f
explicitBoundary e f = Square→compPath (explicitSquare e f)

------------------------------------------------------------------------
-- 3. The same boundary, stated in the executable compiler paths.
------------------------------------------------------------------------

compiledBoundary : {ℓ : Level} {A B C D : Type ℓ} (e : A ≃ B) (f : C ≃ D)
  → ua (rightCompiler A f) ∙ ua (leftCompiler e D)
  ≡ ua (leftCompiler e C) ∙ ua (rightCompiler B f)
compiledBoundary {A = A} {B = B} {C = C} {D = D} e f =
    sym (uaCompEquiv (rightCompiler A f) (leftCompiler e D))
  ∙ sym (cong ua (compilerRoutesEqual e f))
  ∙ uaCompEquiv (leftCompiler e C) (rightCompiler B f)

compiledSquare : {ℓ : Level} {A B C D : Type ℓ} (e : A ≃ B) (f : C ≃ D)
  → Square (ua (leftCompiler e C)) (ua (leftCompiler e D))
           (ua (rightCompiler A f)) (ua (rightCompiler B f))
compiledSquare e f = compPath→Square (compiledBoundary e f)

------------------------------------------------------------------------
-- 4. The daemon questions: identify the explicit edges with the
--    compiler edges.  Candidate fills are in the companion message.
------------------------------------------------------------------------

leftTransportIsCompiler : {ℓ : Level} {A B : Type ℓ} (e : A ≃ B) (C : Type ℓ)
  → pathToEquiv (topPath e C) ≡ leftCompiler e C
leftTransportIsCompiler e C =
  equivEq (funExt λ { (a , c) → ΣPathP (uaβ e a , transportRefl c) })

rightTransportIsCompiler : {ℓ : Level} (A : Type ℓ) {C D : Type ℓ} (f : C ≃ D)
  → pathToEquiv (sidePath A f) ≡ rightCompiler A f
rightTransportIsCompiler A f =
  equivEq (funExt λ { (a , c) → ΣPathP (transportRefl a , uaβ f c) })

topIsCompiled : {ℓ : Level} {A B : Type ℓ} (e : A ≃ B) (C : Type ℓ)
  → topPath e C ≡ ua (leftCompiler e C)
topIsCompiled e C =
  sym (uaη (topPath e C)) ∙ cong ua (leftTransportIsCompiler e C)

sideIsCompiled : {ℓ : Level} (A : Type ℓ) {C D : Type ℓ} (f : C ≃ D)
  → sidePath A f ≡ ua (rightCompiler A f)
sideIsCompiled A f =
  sym (uaη (sidePath A f)) ∙ cong ua (rightTransportIsCompiler A f)
