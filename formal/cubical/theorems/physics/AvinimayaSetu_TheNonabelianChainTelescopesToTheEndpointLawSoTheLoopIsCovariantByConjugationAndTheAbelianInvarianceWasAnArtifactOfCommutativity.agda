{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अविनिमय-सेतु — the non-commuting link field.
--
-- SetuKsetra built the lattice, the connection, the gauge transformation
-- and the Wilson loop for ℤ/2, and proved the loop gauge invariant by
-- telescoping.  Its two cancellation laws, madhya-lopa and
-- trika-vinimaya, both spend commutativity.  RelationalHolonomyRefinement
-- works over an arbitrary group but takes the endpoint law
-- t · g · s⁻¹ as given on a single coarse holonomy.  This file joins the
-- two: the link-wise gauge transformation on a chain over ANY group
-- telescopes, with no commutativity, to exactly that endpoint law, and
-- what it says about a closed loop is sharper than invariance.
--
--   §1  The lattice over a group G.  A chain is a list of (link, right
--       site); the left site of each link is the previous site, seeded
--       by the start site.  The Wilson line composes later links on the
--       left, as the corpus's holonomy does.  A gauge transformation
--       rewrites each link g from site a to site b as b · g · a⁻¹.
--
--   §2  THE NONABELIAN TELESCOPING LAW.  The transformed Wilson line is
--       (end site) · (original line) · (start site)⁻¹.  The middle sites
--       cancel in pairs by a⁻¹ · a = 1 alone: madhya-lopa without
--       commutativity.
--
--   §3  THE ENDPOINT LAW IS DERIVED, NOT ASSUMED.  §2 is, verbatim,
--       RelationalHolonomyRefinement's endpointGauge (start , end)
--       applied to the line — the coarse law is the lattice's own
--       telescoping.
--
--   §4  THE CLOSED LOOP IS COVARIANT, NOT INVARIANT.  On a chain that
--       returns to its start site the loop transforms by conjugation
--       h · W · h⁻¹.  Hence every conjugation-invariant observable of the
--       loop — every class function — is gauge invariant, by
--       closedLoopGaugeInvariant applied to the lattice loop.
--
--   §5  THE ABELIAN INVARIANCE WAS AN ARTIFACT.  Supply commutativity and
--       conjugation collapses to the identity: SetuKsetra's cakra-avikāra
--       is the special case, recovered from §4 in four steps.
--
--   §6  A CLASS FUNCTION THAT IS NOT THE CONSTANT ONE.  Flatness — the
--       loop has trivial holonomy — is conjugation invariant, so by §4
--       it is a gauge-invariant observable of the lattice loop.  The
--       previous nonabelian instance observed only into Unit.
--
--   §7  THE LOOP ITSELF MOVES.  In S₃ the one-link loop s₀₁, transformed
--       at site s₁₂, becomes s₁₂ · s₀₁ · s₁₂⁻¹, which is not s₀₁: the
--       Wilson element is gauge-dependent and only its class is
--       observable.  The witness is FiniteNonabelianHolonomy's
--       noncommuting, moved across one inverse.
--
-- अविनिमय (a-vinimaya, non-exchange) is ordinary Sanskrit; SetuKsetra's
-- own trika-vinimaya is the exchange this file does without.
------------------------------------------------------------------------

module AvinimayaSetu_TheNonabelianChainTelescopesToTheEndpointLawSoTheLoopIsCovariantByConjugationAndTheAbelianInvarianceWasAnArtifactOfCommutativity where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Univalence using (hPropExt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
import Cubical.Data.Prod as P

import RelationalHolonomyRefinement as RHR
open import FiniteNonabelianHolonomy using (S₃ ; s₀₁ ; s₁₂ ; noncommuting)

private
  variable
    ℓ ℓo : Level

module _ (G : Group ℓ) where

  private
    module G = GroupStr (snd G)
    open G using (_·_ ; 1g ; inv)

  ----------------------------------------------------------------------
  -- १ · The lattice, the field, the transformation, the line.
  ----------------------------------------------------------------------

  Setu : Type ℓ
  Setu = List (⟨ G ⟩ × ⟨ G ⟩)

  -- The Wilson line: later links on the left.
  wilson : List ⟨ G ⟩ → ⟨ G ⟩
  wilson []       = 1g
  wilson (g ∷ gs) = wilson gs · g

  -- The gauge transformation: link g from site h to site h' becomes
  -- h' · g · h⁻¹.
  parivartana : ⟨ G ⟩ → Setu → List ⟨ G ⟩
  parivartana h []               = []
  parivartana h ((g , h') ∷ c) = ((h' · g) · inv h) ∷ parivartana h' c

  -- The final site of the chain.
  anta : ⟨ G ⟩ → Setu → ⟨ G ⟩
  anta h []              = h
  anta h ((_ , h') ∷ c) = anta h' c

  ----------------------------------------------------------------------
  -- २ · Middle cancellation without commutativity, and the telescoping law.
  ----------------------------------------------------------------------

  -- (X · h'⁻¹) · ((h' · g) · Y) ≡ (X · g) · Y, by h'⁻¹ · h' = 1 alone.
  madhya-lopa : (X h' g Y : ⟨ G ⟩)
              → (X · inv h') · ((h' · g) · Y) ≡ (X · g) · Y
  madhya-lopa X h' g Y =
      sym (G.·Assoc X (inv h') ((h' · g) · Y))
    ∙ cong (X ·_) (G.·Assoc (inv h') (h' · g) Y)
    ∙ cong (X ·_) (cong (_· Y) (G.·Assoc (inv h') h' g))
    ∙ cong (X ·_) (cong (_· Y) (cong (_· g) (G.·InvL h')))
    ∙ cong (X ·_) (cong (_· Y) (G.·IdL g))
    ∙ G.·Assoc X g Y

  saṅkalana : (h : ⟨ G ⟩) (c : Setu)
            → wilson (parivartana h c)
            ≡ (anta h c · wilson (map fst c)) · inv h
  saṅkalana h [] =
    sym (cong (_· inv h) (G.·IdR h) ∙ G.·InvR h)
  saṅkalana h ((g , h') ∷ c) =
      cong (_· ((h' · g) · inv h)) (saṅkalana h' c)
    ∙ madhya-lopa (anta h' c · wilson (map fst c)) h' g (inv h)
    ∙ cong (_· inv h) (sym (G.·Assoc (anta h' c) (wilson (map fst c)) g))

  ----------------------------------------------------------------------
  -- ३ · The endpoint law is the telescoping, verbatim.
  ----------------------------------------------------------------------

  setu-endpoint : (h : ⟨ G ⟩) (c : Setu)
                → wilson (parivartana h c)
                ≡ RHR.endpointGauge G (P._,_ h (anta h c)) (wilson (map fst c))
  setu-endpoint = saṅkalana

  ----------------------------------------------------------------------
  -- ४ · The closed loop is covariant by conjugation; class functions
  --     are invariant.
  ----------------------------------------------------------------------

  cakra-saṃyoga : (h : ⟨ G ⟩) (c : Setu) → anta h c ≡ h
                → wilson (parivartana h c)
                ≡ (h · wilson (map fst c)) · inv h
  cakra-saṃyoga h c band =
    saṅkalana h c ∙ cong (λ z → (z · wilson (map fst c)) · inv h) band

  varga-avikāra : {O : Type ℓo} (f : ⟨ G ⟩ → O)
                → RHR.ConjugationInvariant G f
                → (h : ⟨ G ⟩) (c : Setu) → anta h c ≡ h
                → f (wilson (parivartana h c)) ≡ f (wilson (map fst c))
  varga-avikāra f invariant h c band =
      cong f (cakra-saṃyoga h c band)
    ∙ RHR.closedLoopGaugeInvariant G f invariant h (wilson (map fst c))

  ----------------------------------------------------------------------
  -- ५ · Commutativity collapses conjugation: the abelian case recovered.
  ----------------------------------------------------------------------

  sama-avikāra : ((x y : ⟨ G ⟩) → x · y ≡ y · x)
               → (h : ⟨ G ⟩) (c : Setu) → anta h c ≡ h
               → wilson (parivartana h c) ≡ wilson (map fst c)
  sama-avikāra comm h c band =
      cakra-saṃyoga h c band
    ∙ cong (_· inv h) (comm h (wilson (map fst c)))
    ∙ sym (G.·Assoc (wilson (map fst c)) h (inv h))
    ∙ cong (wilson (map fst c) ·_) (G.·InvR h)
    ∙ G.·IdR (wilson (map fst c))

  ----------------------------------------------------------------------
  -- ६ · A class function that is not the constant one: flatness.
  --     "The loop has trivial holonomy" is conjugation invariant, so by
  --     §4 it is a gauge-invariant observable of the lattice loop.
  ----------------------------------------------------------------------

  samatala : ⟨ G ⟩ → Type ℓ
  samatala g = g ≡ 1g

  -- conjugate back: h⁻¹ · (h · g · h⁻¹) · h ≡ g, by cancellation alone.
  pratisaṃyoga : (h g : ⟨ G ⟩) → (inv h · ((h · g) · inv h)) · h ≡ g
  pratisaṃyoga h g =
      cong (_· h) (G.·Assoc (inv h) (h · g) (inv h))
    ∙ cong (_· h) (cong (_· inv h) (G.·Assoc (inv h) h g))
    ∙ cong (_· h) (cong (_· inv h) (cong (_· g) (G.·InvL h)))
    ∙ cong (_· h) (cong (_· inv h) (G.·IdL g))
    ∙ sym (G.·Assoc g (inv h) h)
    ∙ cong (g ·_) (G.·InvL h)
    ∙ G.·IdR g

  samatala-varga : RHR.ConjugationInvariant G samatala
  samatala-varga h g =
    hPropExt (G.is-set _ _) (G.is-set _ _) forward backward
    where
    forward : (h · g) · inv h ≡ 1g → g ≡ 1g
    forward p =
        sym (pratisaṃyoga h g)
      ∙ cong (λ z → (inv h · z) · h) p
      ∙ cong (_· h) (G.·IdR (inv h))
      ∙ G.·InvL h
    backward : g ≡ 1g → (h · g) · inv h ≡ 1g
    backward q =
        cong (λ z → (h · z) · inv h) q
      ∙ cong (_· inv h) (G.·IdR h)
      ∙ G.·InvR h

  -- Flatness of the lattice loop is gauge invariant.
  samatala-avikāra : (h : ⟨ G ⟩) (c : Setu) → anta h c ≡ h
                   → samatala (wilson (parivartana h c))
                   ≡ samatala (wilson (map fst c))
  samatala-avikāra = varga-avikāra samatala samatala-varga

------------------------------------------------------------------------
-- ७ · The loop itself moves: the S₃ witness.
------------------------------------------------------------------------

module S = GroupStr (snd S₃)

-- Conjugating s₀₁ by s₁₂ cannot return s₀₁: cancel the inverse and the
-- two transpositions would commute.
sākṣī : ((s₁₂ S.· s₀₁) S.· S.inv s₁₂ ≡ s₀₁) → ⊥
sākṣī p = noncommuting (sym moved)
  where
  moved : s₁₂ S.· s₀₁ ≡ s₀₁ S.· s₁₂
  moved =
      sym (S.·IdR (s₁₂ S.· s₀₁))
    ∙ cong ((s₁₂ S.· s₀₁) S.·_) (sym (S.·InvL s₁₂))
    ∙ S.·Assoc (s₁₂ S.· s₀₁) (S.inv s₁₂) s₁₂
    ∙ cong (S._· s₁₂) p

-- One closed link carrying s₀₁, transformed at site s₁₂: the transformed
-- loop is not the original loop.
eka-cakra : Setu S₃
eka-cakra = (s₀₁ , s₁₂) ∷ []

eka-baddha : anta S₃ s₁₂ eka-cakra ≡ s₁₂
eka-baddha = refl

loop-calita : wilson S₃ (parivartana S₃ s₁₂ eka-cakra)
            ≡ wilson S₃ (map fst eka-cakra) → ⊥
loop-calita p = sākṣī (sym (S.·IdL _) ∙ p ∙ S.·IdL s₀₁)
