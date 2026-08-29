{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वितीय-नियम — the second law, counted.
--
-- The śeṣa trilaw's conservation clause, run along time.  Two
-- monotonicities, opposite in sign, jointly the counting form of the
-- second law:
--
--   §1  DOWNSTREAM, COLLAPSE IS FOREVER.  A distinction merged by any
--       stage stays merged under every later stage (one cong), and no
--       later stage can be a left inverse of a merging one (the
--       recovery refutation, generic).  Visible distinctions are
--       monotone non-increasing along composition: the irreversible
--       direction, with its arrow derived rather than assumed.
--
--   §2  UPSTREAM, THE LEDGER IS FOREVER.  The displacement machine of
--       ApasaranaNiyama, iterated: each step pushes the current input
--       onto the environment tape.  Proved: whatever the tape holds
--       at any depth, it holds at the corresponding depth at EVERY
--       later time — the run only deepens the address, never the
--       content.  Displaced distinctions do not fade; the ledger
--       accumulates monotonically.
--
-- Together with ApasaranaNiyama (each erasure is a displacement) this
-- is the accounting identity of the corpus's physics: what leaves the
-- visible marginal (§1, decreasing) arrives in the ledger (§2,
-- persistent), and the sum is the conservation the trilaw states.
-- Entropy growth, in counting form: the visible shrinks, the kept
-- fibre grows, nothing is destroyed.
--
-- SYĀT — THE CLAIM, EXACTLY.  Counting, not measure: the weighted
-- form (probabilities over the tape, and the logarithm that turns
-- products into sums) is the next construction.
------------------------------------------------------------------------

module DvitiyaNiyama_CollapsedDistinctionsNeverReturnDownstreamAndTheLedgerNeverForgetsUpstream where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Empty using (⊥)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)

open Dhārā

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · Downstream: collapse propagates, recovery is refuted.
------------------------------------------------------------------------

saṅkoca-anuvartana : {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''}
                     (f : A → B) (g : B → C) {x y : A}
                   → f x ≡ f y → g (f x) ≡ g (f y)
saṅkoca-anuvartana f g = cong g

na-pratyānayana : {A : Type ℓ} {B : Type ℓ'}
                  (f : A → B) {x y : A}
                → (x ≡ y → ⊥) → f x ≡ f y
                → (h : B → A) → ((a : A) → h (f a) ≡ a) → ⊥
na-pratyānayana f bheda mṛjana h sec =
  bheda (sym (sec _) ∙ cong h mṛjana ∙ sec _)

------------------------------------------------------------------------
-- २ · Upstream: the tape machine, and the persistence of the ledger.
------------------------------------------------------------------------

Paṭṭikā : Type₀
Paṭṭikā = Dhārā Bool

pāṭha : ℕ → Paṭṭikā → Bool
pāṭha zero    t = śiras t
pāṭha (suc j) t = pāṭha j (śeṣam t)

nikṣepa : Bool → Paṭṭikā → Paṭṭikā
śiras (nikṣepa b t) = b
śeṣam (nikṣepa b t) = t

-- Run n steps: push each successive input onto the tape.
dhāvana : ℕ → Paṭṭikā → Paṭṭikā → Paṭṭikā
dhāvana zero    ins t = t
dhāvana (suc n) ins t = dhāvana n (śeṣam ins) (nikṣepa (śiras ins) t)

-- THE PERSISTENCE THEOREM: content at depth j now is content at
-- depth n + j after n more steps — the run deepens addresses, never
-- touches contents.
smṛti : (n j : ℕ) (ins t : Paṭṭikā)
      → pāṭha j t ≡ pāṭha (n + j) (dhāvana n ins t)
smṛti zero    j ins t = refl
smṛti (suc n) j ins t =
  smṛti n (suc j) (śeṣam ins) (nikṣepa (śiras ins) t)
  ∙ cong (λ m → pāṭha m (dhāvana n (śeṣam ins) (nikṣepa (śiras ins) t)))
         (+-suc n j)

-- And each step records its input at the surface, by refl: the ledger
-- writes before it deepens.
lekhana : (ins t : Paṭṭikā) → pāṭha 0 (dhāvana 1 ins t) ≡ śiras ins
lekhana ins t = refl
