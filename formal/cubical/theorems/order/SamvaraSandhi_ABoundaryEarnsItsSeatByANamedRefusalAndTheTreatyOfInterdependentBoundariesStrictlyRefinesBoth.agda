{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संवर-सन्धि — the boundary treaty.
--
-- WHAT THIS IS.  Boundaries are first-class in this corpus (README §32:
-- an incoming trace is admitted only if the boundary family is
-- inhabited; §36: saṃvara is closure of inadmissible ingress).  When
-- two parties interact, their boundaries meet: the negotiated interface
-- is the pointwise conjunction, and NEGOTIATION is the question of what
-- each party's boundary contributes to that meet.  This file answers it
-- with two theorems, and the answer is the saṃvara-dual of the
-- interdependent pair:
--
--   §2  A DOMINATED BOUNDARY IS FREE TO DROP, AS A PATH IN THE
--       UNIVERSE.  If every check of B₂ is implied by B₁ (and
--       admissibility is a proposition, as verdicts are in this
--       corpus), then the negotiated boundary B₁ ∧ B₂ is EQUAL — by
--       univalence, pointwise and then by function extensionality as
--       families — to B₁ alone.  A party whose every refusal is already
--       the counterparty's refusal contributes nothing: it is not a
--       negotiator, it is a spectator, and the treaty says so as a
--       type equality.
--
--   §3  A BOUNDARY EARNS ITS SEAT EXACTLY BY A NAMED REFUSAL.  The
--       treaty record (Sandhi): each party exhibits a state it refuses
--       that the other admits.  From that data alone: neither boundary
--       is derivable from the other (na-adhīna, both directions), and
--       the meet STRICTLY refines both (tīkṣṇa, both directions) — the
--       negotiated interface is genuinely new, below each party's own
--       boundary.  Negotiation is real precisely when the boundaries
--       are interdependent.
--
-- THE DUALITY, stated exactly.  This is the Parasparāśraya record with
-- vision dualized to protection: the blind pair (two states a sense
-- cannot separate) becomes the named refusal (a state one boundary
-- excludes and the other admits); joint faithfulness (the pair
-- reconstructs) becomes the strict meet (the treaty refuses more than
-- either party); and UpakaranaVrddhi's "a derived sense adds no
-- separation" becomes §2's "a derived boundary adds no protection."
-- One shape, read outward twice: what you can SEE together, and what
-- you can REFUSE together, obey the same law — novelty must be named,
-- or the joint object collapses onto one side.
--
-- The interaction reading (§17): autonomy is control of the local
-- boundary, and this file is the algebra of what happens when two
-- autonomies meet — the treaty is exactly as strong as the refusals
-- the parties genuinely do not share.  The term sandhi is the
-- statecraft word for treaty (the first of the six measures of policy
-- in the Arthaśāstra tradition — locus unverified; no theorem is
-- attributed to any historical author).
--
-- WHAT IS NOT CLAIMED.  No protocol, no adversary model, no game
-- theory, no mechanism design.  A boundary is a type family, the meet
-- is the pointwise product, and every claim below is about those.
------------------------------------------------------------------------

module SamvaraSandhi_ABoundaryEarnsItsSeatByANamedRefusalAndTheTreatyOfInterdependentBoundariesStrictlyRefinesBoth where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · Boundaries, their order, and the negotiated meet.
------------------------------------------------------------------------

-- The meet: admitted by the treaty iff admitted by both parties.
_∧ᵇ_ : {X : Type ℓ} → (X → Type ℓ') → (X → Type ℓ') → (X → Type ℓ')
(B₁ ∧ᵇ B₂) x = B₁ x × B₂ x

-- Domination: every admission of B₁ is already an admission of B₂ —
-- equivalently, every refusal of B₂ is already B₁'s refusal.
_≤ᵇ_ : {X : Type ℓ} → (X → Type ℓ') → (X → Type ℓ') → Type (ℓ-max ℓ ℓ')
B₁ ≤ᵇ B₂ = ∀ x → B₁ x → B₂ x

-- The meet is a lower bound on both sides, by projection.
meet-≤₁ : {X : Type ℓ} (B₁ B₂ : X → Type ℓ') → (B₁ ∧ᵇ B₂) ≤ᵇ B₁
meet-≤₁ B₁ B₂ x = fst

meet-≤₂ : {X : Type ℓ} (B₁ B₂ : X → Type ℓ') → (B₁ ∧ᵇ B₂) ≤ᵇ B₂
meet-≤₂ B₁ B₂ x = snd

-- And the greatest one: anything below both is below the meet.
meet-mahattama : {X : Type ℓ} (B₁ B₂ C : X → Type ℓ')
               → C ≤ᵇ B₁ → C ≤ᵇ B₂ → C ≤ᵇ (B₁ ∧ᵇ B₂)
meet-mahattama B₁ B₂ C h₁ h₂ x c = h₁ x c , h₂ x c

------------------------------------------------------------------------
-- २ · The dominated party is a spectator: its seat is free to drop,
-- and the treaty is EQUAL to the other party's boundary alone.
------------------------------------------------------------------------

module _ {X : Type ℓ} (B₁ B₂ : X → Type ℓ')
         (prop₂ : ∀ x → isProp (B₂ x))
         (adhīna : B₁ ≤ᵇ B₂) where

  mukta : ∀ x → (B₁ ∧ᵇ B₂) x ≃ B₁ x
  mukta x = isoToEquiv (iso fst
                            (λ b → b , adhīna x b)
                            (λ b → refl)
                            (λ pq i → fst pq , prop₂ x (adhīna x (fst pq)) (snd pq) i))

  -- The treaty collapses onto the undominated party — as an equality
  -- of boundary FAMILIES, one path in the universe per state.
  sandhi-mukta : (B₁ ∧ᵇ B₂) ≡ B₁
  sandhi-mukta = funExt (λ x → ua (mukta x))

------------------------------------------------------------------------
-- ३ · The treaty of interdependent boundaries.  Each party names a
-- refusal the other does not make; from that alone, neither dominates
-- and the meet strictly refines both.
------------------------------------------------------------------------

record Sandhi {X : Type ℓ} (B₁ B₂ : X → Type ℓ') : Type (ℓ-max ℓ ℓ') where
  field
    nirodha₁ : Σ[ x ∈ X ] ((B₁ x → ⊥) × B₂ x)  -- B₁ refuses it, B₂ admits it
    nirodha₂ : Σ[ x ∈ X ] ((B₂ x → ⊥) × B₁ x)  -- B₂ refuses it, B₁ admits it

  -- Neither boundary is derivable from the other.
  na-adhīna₁₂ : B₁ ≤ᵇ B₂ → ⊥
  na-adhīna₁₂ imp =
    fst (snd nirodha₂) (imp (fst nirodha₂) (snd (snd nirodha₂)))

  na-adhīna₂₁ : B₂ ≤ᵇ B₁ → ⊥
  na-adhīna₂₁ imp =
    fst (snd nirodha₁) (imp (fst nirodha₁) (snd (snd nirodha₁)))

  -- The negotiated boundary strictly refines each party's own: the
  -- treaty refuses something each party alone admits.
  tīkṣṇa₁ : B₁ ≤ᵇ (B₁ ∧ᵇ B₂) → ⊥
  tīkṣṇa₁ h = na-adhīna₁₂ (λ x b → snd (h x b))

  tīkṣṇa₂ : B₂ ≤ᵇ (B₁ ∧ᵇ B₂) → ⊥
  tīkṣṇa₂ h = na-adhīna₂₁ (λ x b → fst (h x b))

------------------------------------------------------------------------
-- ४ · The smallest treaty, inhabited.  Two parties over the plane:
-- one guards the first coordinate, the other the second.  Each names
-- its refusal; the treaty admits only the corner both accept, and the
-- strictness theorems land by instantiation.
------------------------------------------------------------------------

prathama-rakṣā : Bool × Bool → Type₀
prathama-rakṣā p = fst p ≡ true

dvitīya-rakṣā : Bool × Bool → Type₀
dvitīya-rakṣā p = snd p ≡ true

yugma-sandhi : Sandhi prathama-rakṣā dvitīya-rakṣā
Sandhi.nirodha₁ yugma-sandhi =
  (false , true) , (λ p → true≢false (sym p)) , refl
Sandhi.nirodha₂ yugma-sandhi =
  (true , false) , (λ p → true≢false (sym p)) , refl
