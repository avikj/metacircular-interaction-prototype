{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- लेखा — सर्वा लेखा मुक्ता, न केवलम् एकं पदम् ।
--
-- (the whole ledger rides free, not just one step.)
--
-- ────────────────────────────────────────────────────────────────────
-- `loss/src/Loss/Carrier.agda` proves ONE step free: the
-- datum and its witness contribute zero degrees of freedom, because
-- `singl (f a)` is contractible.  Everything downstream in this corpus —
-- that a receipted mathematics is affordable at all, that proof-of-
-- transport is cheap, that Bennett's garbage tape is the constructive
-- witness — is a claim about CHAINS, and one step does not give it.  A
-- reader could reasonably fear the trail accumulates.
--
-- It does not.  §२: a point carried through TWO maps, dragging both
-- intermediate values and both witnesses, is equivalent to the bare
-- point.  Not small — EQUAL, and the equivalence is `Σ`-contraction
-- twice with no hypothesis on `A`, `B`, `C`, `f` or `g`.
--
-- READ AT BENNETT.  Reversible computation pays for its garbage tape in
-- space, per execution, which is why it stayed theoretical.  Here the
-- trail is contractible, so what is stored is not the intermediates but
-- WHICH standard trail they are, and §२ is the statement that this holds
-- at length two exactly as at length one.  README movement 5's identity —
-- the reversible computer's garbage tape and the constructive proof's
-- carried witness are one object — is that sentence, and §२ is the part
-- of it that has to be true for the economics to work.
--
-- WHAT IS NOT CLAIMED.  ~~Two steps, not n.~~ **§३ closes this: the
-- n-fold case is proved by induction for an iterated endomorphism.**
-- What is still not claimed: nothing about time,
-- space, joules, or Landauer is claimed: this is an informational
-- statement about degrees of freedom and nothing else.  And it says
-- nothing about the FIBRES of `f` and `g` — those are the other binding
-- and are arbitrary (`Abhijnana_…agda` §१).
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Lekha_TheWholeAuditTrailOfAChainIsFreeToCarryAndNotOnlyOneStep where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isOfHLevelΣ ; isContrΣ)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _,_ ; fst ; snd ; Σ-contractSnd)

private variable ℓ : Level

module _ {A B C : Type ℓ} (f : A → B) (g : B → C) where

------------------------------------------------------------------------
-- १ · लेखा — the full trail: the point, both images it passes through,
--     and the witness at each step that it IS that image.
------------------------------------------------------------------------

  लेखा : Type ℓ
  लेखा = Σ[ a ∈ A ] Σ[ p ∈ singl (f a) ] singl (g (p .fst))

------------------------------------------------------------------------
-- २ · लेखा मुक्ता — AND IT IS THE POINT.
--
-- Both intermediates and both witnesses contract away.  No hypothesis on
-- anything: arbitrary types, arbitrary maps, however lossy.
------------------------------------------------------------------------

  लेखा-मुक्ता : लेखा ≃ A
  लेखा-मुक्ता = Σ-contractSnd λ a → isOfHLevelΣ 0 (isContrSingl (f a))
                                              (λ p → isContrSingl (g (p .fst)))


------------------------------------------------------------------------
-- ३ · अनन्त-लेखा — AND AT EVERY LENGTH, by induction.
--
-- §२ fenced itself at two steps and named the n-fold version as an
-- induction nobody had written.  This writes it, for the iterated case:
-- one endomorphism, a trail of `n` steps, every intermediate and every
-- witness carried.  Contractible for every `n`.
--
-- So the audit trail of an arbitrarily long computation is informationally
-- free — which is the statement the whole per-edge economics rests on, and
-- it is four lines.  What is bounded is not the trail; it is what the
-- MAPS destroy, and that is the other binding entirely.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; isContrUnit)

module _ {A : Type ℓ} (h : A → A) where

  -- the trail of n steps from a, with every image and every witness
  अनन्त-लेखा : ℕ → A → Type ℓ
  अनन्त-लेखा zero    a = Unit*
    where open import Cubical.Data.Unit using (Unit*)
  अनन्त-लेखा (suc n) a = Σ[ p ∈ singl (h a) ] अनन्त-लेखा n (p .fst)

  अनन्त-लेखा-मुक्ता : (n : ℕ) (a : A) → isContr (अनन्त-लेखा n a)
  अनन्त-लेखा-मुक्ता zero    a = isContrUnit*
    where open import Cubical.Data.Unit using (isContrUnit*)
  अनन्त-लेखा-मुक्ता (suc n) a =
    isContrΣ (isContrSingl (h a)) (λ p → अनन्त-लेखा-मुक्ता n (p .fst))
