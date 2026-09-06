{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Sthana — the sixty-four rounds are a permutation, and the loss
-- has one address: the feed-forward.
--
-- व्यये स्थानम् — loss has location, not only size.  This module gives
-- SHA-256's loss its address, as checked terms about the working
-- bit-level implementation:
--
--   §1  subC — ripple-borrow subtraction, and the cancellation
--       सम-हरणम् : subW (addW u v) v ≡ u, by twelve clauses each of
--       which is a full-adder/full-subtractor case closing by refl.
--       Addition mod 2³² is a group action; the kernel now holds the
--       inverse ride.
--   §2  roundInv — the EXPLICIT inverse of one round: from the eight
--       new registers and (Kt , Wt), recover T2 from the copied
--       registers, peel T1 off the new a, peel d off the new e, and
--       peel h out of T1 itself.
--   §3  परिवृत्ति-हरणम् — one round undone: roundInv ∘ roundStep is
--       the identity on the eight named registers.
--   §4  आवली-हरणम् — ALL SIXTY-FOUR undone: the whole round phase of
--       the compression is invertible, and hence injective
--       (आवली-एकैकम्).
--
-- CONSEQUENCE, and it is the point.  The compression function is
--   compress H b = addW-pointwise H (rounds H (schedule b))
-- and §4 says the `rounds` factor forgets NOTHING — it is a
-- permutation of the state space for every fixed message block.  So
-- every bit of the hash's non-injectivity enters at exactly two
-- addresses: the Davies–Meyer feed-forward (the one pointwise addW
-- with H, which superposes the permutation's input onto its output)
-- and the padding/blocking quotient upstream.  This is WHY the
-- feed-forward exists — an invertible compression would be no hash at
-- all — and that design fact is now a theorem about this
-- implementation, not a remark about a construction.
--
-- NOT claimed as new mathematics: that Davies–Meyer's cipher leg is a
-- permutation is the construction's own textbook rationale.  What is
-- claimed: the working implementation's 64 rounds, as written, with
-- their strictness discipline, verifiably compose to a bijection —
-- and therefore the loss the previous modules studied (the classes,
-- the fibres, the one-wayness) is created wholly at the named seam.
--
-- CHECKED: Agda 2.8.0, --cubical --safe, through scripts/oracle.
------------------------------------------------------------------------

module Sha256Sthana_TheSixtyFourRoundsAreAPermutationAndTheLossHasOneAddressTheFeedForward where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import Sha256
  using ( Word ; addW ; addC ; nth ; foldlL ; roundStep
        ; Σ0 ; Σ1 ; ch ; maj ; and2 ; or2 ; xor2 )
open import Sha256Parimana_EveryDigestIsExactly256BitsSoTheRealHashIsUnconditionallyANonEquivalence
  using (roundStep-≡ ; T1of ; T2of)

------------------------------------------------------------------------
-- §1  Ripple-borrow subtraction, and the cancellation.
------------------------------------------------------------------------

subC : Bool → Word → Word → Word
subC c []       _        = []
subC c (a ∷ as) []       =
  xor2 a c ∷ subC (and2 (not a) c) as []
subC c (a ∷ as) (b ∷ bs) =
  xor2 a (xor2 b c)
  ∷ subC (or2 (and2 (not a) (or2 b c)) (and2 b c)) as bs

subW : Word → Word → Word
subW = subC false

-- twelve full-adder/full-subtractor cases, each closing by refl on the
-- head bit and the borrow, so the tail is exactly the induction
सम-हरणम् : (c : Bool) (u v : Word) → subC c (addC c u v) v ≡ u
सम-हरणम् c     []           _           = refl
सम-हरणम् false (false ∷ as) []          = cong (false ∷_) (सम-हरणम् false as [])
सम-हरणम् true  (false ∷ as) []          = cong (false ∷_) (सम-हरणम् false as [])
सम-हरणम् false (true  ∷ as) []          = cong (true  ∷_) (सम-हरणम् false as [])
सम-हरणम् true  (true  ∷ as) []          = cong (true  ∷_) (सम-हरणम् true  as [])
सम-हरणम् false (false ∷ as) (false ∷ bs) = cong (false ∷_) (सम-हरणम् false as bs)
सम-हरणम् true  (false ∷ as) (false ∷ bs) = cong (false ∷_) (सम-हरणम् false as bs)
सम-हरणम् false (false ∷ as) (true  ∷ bs) = cong (false ∷_) (सम-हरणम् false as bs)
सम-हरणम् true  (false ∷ as) (true  ∷ bs) = cong (false ∷_) (सम-हरणम् true  as bs)
सम-हरणम् false (true  ∷ as) (false ∷ bs) = cong (true  ∷_) (सम-हरणम् false as bs)
सम-हरणम् true  (true  ∷ as) (false ∷ bs) = cong (true  ∷_) (सम-हरणम् true  as bs)
सम-हरणम् false (true  ∷ as) (true  ∷ bs) = cong (true  ∷_) (सम-हरणम् true  as bs)
सम-हरणम् true  (true  ∷ as) (true  ∷ bs) = cong (true  ∷_) (सम-हरणम् true  as bs)

------------------------------------------------------------------------
-- §2  The explicit inverse of one round.
------------------------------------------------------------------------

-- the T1 summand that does not involve h, named so §3 can peel h off
Xof : List Word → Word → Word → Word
Xof st k w =
  addW (Σ1 (nth 4 st))
    (addW (ch (nth 4 st) (nth 5 st) (nth 6 st)) (addW k w))

roundInv : Word × Word → List Word → List Word
roundInv (k , w) ns =
  let a  = nth 1 ns ; b = nth 2 ns ; c = nth 3 ns
      e  = nth 5 ns ; f = nth 6 ns ; g = nth 7 ns
      T2 = addW (Σ0 a) (maj a b c)
      T1 = subW (nth 0 ns) T2
      d  = subW (nth 4 ns) T1
      h  = subW T1 (addW (Σ1 e) (addW (ch e f g) (addW k w)))
  in  a ∷ b ∷ c ∷ d ∷ e ∷ f ∷ g ∷ h ∷ []

-- the eight named registers of a state
अष्टकम् : List Word → List Word
अष्टकम् st =
  nth 0 st ∷ nth 1 st ∷ nth 2 st ∷ nth 3 st
  ∷ nth 4 st ∷ nth 5 st ∷ nth 6 st ∷ nth 7 st ∷ []

------------------------------------------------------------------------
-- §3  One round undone.
------------------------------------------------------------------------

परिवृत्ति-हरणम् : (st : List Word) (k w : Word)
  → roundInv (k , w) (roundStep st (k , w)) ≡ अष्टकम् st
परिवृत्ति-हरणम् st k w =
  cong (roundInv (k , w)) (roundStep-≡ st k w)
  ∙ λ i → nth 0 st ∷ nth 1 st ∷ nth 2 st ∷ dPath i
        ∷ nth 4 st ∷ nth 5 st ∷ nth 6 st ∷ hPath i ∷ []
  where
    t1Path : subW (addW (T1of st k w) (T2of st k w)) (T2of st k w)
           ≡ T1of st k w
    t1Path = सम-हरणम् false (T1of st k w) (T2of st k w)

    dPath : subW (addW (nth 3 st) (T1of st k w))
                 (subW (addW (T1of st k w) (T2of st k w)) (T2of st k w))
          ≡ nth 3 st
    dPath =
      cong (subW (addW (nth 3 st) (T1of st k w))) t1Path
      ∙ सम-हरणम् false (nth 3 st) (T1of st k w)

    hPath : subW (subW (addW (T1of st k w) (T2of st k w)) (T2of st k w))
                 (Xof st k w)
          ≡ nth 7 st
    hPath =
      cong (λ t → subW t (Xof st k w)) t1Path
      ∙ सम-हरणम् false (nth 7 st) (Xof st k w)

------------------------------------------------------------------------
-- §4  All sixty-four undone: the round phase is a permutation.
------------------------------------------------------------------------

आवली-हरः : List (Word × Word) → List Word → List Word
आवली-हरः []       ns = अष्टकम् ns
आवली-हरः (p ∷ ps) ns = roundInv p (आवली-हरः ps ns)

आवली-हरणम् : (ps : List (Word × Word)) (st : List Word)
  → आवली-हरः ps (foldlL roundStep st ps) ≡ अष्टकम् st
आवली-हरणम् []             st = refl
आवली-हरणम् ((k , w) ∷ ps) st =
  cong (roundInv (k , w)) (आवली-हरणम् ps (roundStep st (k , w)))
  ∙ परिवृत्ति-हरणम् st k w

-- hence the round phase forgets nothing: it is injective on the eight
-- registers, for EVERY message block's schedule, at every length
आवली-एकैकम् : (ps : List (Word × Word)) (st st′ : List Word)
  → foldlL roundStep st ps ≡ foldlL roundStep st′ ps
  → अष्टकम् st ≡ अष्टकम् st′
आवली-एकैकम् ps st st′ q =
  sym (आवली-हरणम् ps st) ∙ cong (आवली-हरः ps) q ∙ आवली-हरणम् ps st′
