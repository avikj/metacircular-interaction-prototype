{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Samvada — the hash is an interactive coalgebra: its process
-- space is contractible, the demand matters, and the first shown
-- digest computes every later answer.
--
-- संवाद — dialogue.  Sha256Srotas put SHA-256 into the coinductive
-- calculus's DEGENERATE fragment: the stream, the interaction where
-- the environment has exactly one thing it can say (Fibre.Samvada's
-- own words).  This module puts it where it belongs: into the
-- interactive coalgebra ISC itself —
--
--   ISC Q O E w  ≃  (q : Q w) → Σ w' Σ o (E w q w' o × ISC Q O E w')
--
-- with a REAL query family.  The environment of a hasher can do two
-- things: offer a block, or demand the digest —
--
--   Q w      = अर्पय b | दर्शय            (absorb | emit)
--   gamanam  : absorb steps by compress; EMIT DOES NOT RESET STATE
--   uttaram  : absorb shows nothing; emit shows the chaining value
--   E        = the RECEIPT that the reaction is the lawful one:
--              (o ≡ uttaram w q) × (w' ≡ gamanam w q)
--
-- E is doing kernel work here: lawfulness is part of the TYPE, so a
-- process of this interface cannot exist without carrying, at every
-- reaction, the checked witness that it answered and stepped as
-- SHA-256 — unforgeable by type, the ControlledGrammar discipline
-- transposed to the coalgebra.
--
-- WHAT IS PROVED, all checked terms, no postulates, no holes:
--
--   §2  saṃvādin — the canonical process, by guarded corecursion; and
--       परीक्षा-संवादः, the NIST empty-message vector obtained BY
--       ASKING: offer the padded empty block, demand the digest, and
--       the answer is e3b0c442…7852b855, by the kernel computing.
--   §3  एक-संवादः — THE PROCESS SPACE IS CONTRACTIBLE.  Niyati proved
--       determinism-as-contractibility for the closed machine; here it
--       holds for the OPEN one: sāmyaP builds, corecursively over a
--       path of states, a path between ANY two processes of the
--       interface, using the E-receipts to align states and answers
--       and isProp→PathP to collapse the receipts themselves (the
--       receipt space is a proposition — support, not mass).  One
--       interface, one behaviour: every implementation of lawful
--       SHA-256 interaction IS the canonical one, as a path.
--   §4  पृच्छा-भेदः — THE DEMAND MATTERS: two strategies at H0
--       computably disagree at the very first answer (ask and you see
--       eight words; offer and you see none).  This is Samvada's
--       `counter-demand-matters` separation instantiated at the hash:
--       the interactive presentation is PROPERLY more than the stream,
--       so Srotas was the trivial-query shadow of this module.
--   §5  दीर्घीकरण-भेदः — THE BREACH.  For EVERY process of the
--       interface: demand, offer b, demand again — and the third
--       answer is compress (first answer) b.  The environment computes
--       the hasher's future from one emission and its own block: the
--       length-extension attack as three receipts composed, holding
--       not of one implementation but of the contractible space of
--       all of them.  (Real-world SHA-256 length extension must also
--       thread the padding of the first message through अर्पय — the
--       padding quotient lives upstream in `pad`, at the loss's other
--       address; Parimana and Sesa hold that boundary.)
--   §6  एकाग्र-पातः — THE COLLAPSE: under an offer-only strategy the
--       interaction IS the Srotas chain — observe returns exactly the
--       take-truncation of Khaṇḍa.gati on the constant block stream.
--       det-observe's collapse, at SHA-256: kill the demand and the
--       dialogue degenerates to the stream module, theorem by theorem.
--
-- Read §3 and §5 together and the design of every MAC built on this
-- hash falls out as mathematics: the digest is TOTAL STATE DISCLOSURE
-- (fst of the दर्शय receipt), the process space is a point, so an
-- environment holding one answer holds the whole future — secrecy can
-- only live in what was never shown (the past fibre, infinite by
-- Parimana), never in the process.  HMAC exists because §5 is a
-- theorem.
--
-- CHECKED: Agda 2.8.0, cubical v0.9 (the pin, via sh setup), --cubical
-- --safe; natural-machine now depends on the fibre library, which was
-- always one flag away (fibre.agda-lib's own note).
------------------------------------------------------------------------

module Sha256Samvada_TheHashIsAnInteractiveCoalgebraItsProcessSpaceIsContractibleTheDemandMattersAndTheFirstShownDigestComputesEveryLaterAnswer where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp×)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; isSetBool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.List.Properties using (cons-inj₁ ; isOfHLevelList ; ¬cons≡nil)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers
  using (ISC ; react ; Strategy ; observe)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open Dhārā
open import HistoryCompletion_TheValueStreamOfATraceUnderAnEvaluatorCompletesByCorecursionItsLimitDescendsToTruncationsAndBoundednessDoesNot
  using (module Take)
open Take using (take)

open import Sha256 using (Word ; word ; compress ; H0)
open import Sha256Srotas_TheHashIsATruncationOfOneProductiveChainTheChainForgetsItsPastByReflAndTheRoundLayerIsInjectiveAtEveryDepth
  using (module Khaṇḍa ; bls)

------------------------------------------------------------------------
-- §1  The interface: what the environment may say, what it then sees,
--     and the receipt that makes lawfulness a type.
------------------------------------------------------------------------

W : Type₀
W = List Word                          -- the chaining state

data Praśna : Type₀ where
  अर्पय  : List Bool → Praśna          -- offer a 512-bit block
  दर्शय : Praśna                       -- demand the digest

Q : W → Type₀
Q _ = Praśna

-- how the state moves: absorb compresses; EMIT DOES NOT RESET STATE —
-- this one clause is the whole cryptographic drama below
gamanam : W → Praśna → W
gamanam w (अर्पय b) = compress w b
gamanam w दर्शय    = w

-- what is shown: absorbing shows nothing; emitting shows the state
uttaram : W → Praśna → List Word
uttaram w (अर्पय b) = []
uttaram w दर्शय    = w

O : (w : W) → Q w → W → Type₀
O _ _ _ = List Word

-- THE RECEIPT: a reaction is lawful exactly when it showed uttaram and
-- stepped to gamanam.  Paths in a set, so the receipt is a proposition:
-- support, not mass (the kernel's safety discipline, §V of NOTES).
E : (w : W) (q : Q w) (w' : W) → O w q w' → Type₀
E w q w' o = (o ≡ uttaram w q) × (w' ≡ gamanam w q)

-- the type of SHA-256 interactions
Śālā : W → Type₀
Śālā = ISC Q O E

isSetLW : isSet (List Word)
isSetLW = isOfHLevelList 0 (isOfHLevelList 0 isSetBool)

isPropE : (w : W) (q : Q w) (w' : W) (o : O w q w') → isProp (E w q w' o)
isPropE w q w' o = isProp× (isSetLW _ _) (isSetLW _ _)

------------------------------------------------------------------------
-- §2  The canonical process, and the NIST vector obtained by asking.
------------------------------------------------------------------------

saṃvādin : (w : W) → Śālā w
react (saṃvādin w) q = gamanam w q , uttaram w q , (refl , refl) , saṃvādin (gamanam w q)

-- projections of one reaction, named
dṛṣṭam : {w : W} (q : Q w) (p : Śālā w) → List Word
dṛṣṭam q p = fst (snd (react p q))

śeṣaḥ : {w : W} (q : Q w) (p : Śālā w) → Śālā (fst (react p q))
śeṣaḥ q p = snd (snd (snd (react p q)))

-- the head block of the padded empty message
śiro'ṃśaḥ : List (List Bool) → List Bool
śiro'ṃśaḥ []      = []
śiro'ṃśaḥ (b ∷ _) = b

-- THE RECEIPT BY DIALOGUE: offer the padded empty block to the hasher
-- at H0, then demand — and the answer is the NIST digest, by the
-- kernel running the whole pipeline inside the coalgebra.
परीक्षा-संवादः :
  dṛṣṭam दर्शय (śeṣaḥ (अर्पय (śiro'ṃśaḥ (bls []))) (saṃvādin H0)) ≡ map word
    ( 0xe3b0c442 ∷ 0x98fc1c14 ∷ 0x9afbf4c8 ∷ 0x996fb924
    ∷ 0x27ae41e4 ∷ 0x649b934c ∷ 0xa495991b ∷ 0x7852b855 ∷ [])
परीक्षा-संवादः = refl

------------------------------------------------------------------------
-- §3  THE PROCESS SPACE IS A POINT.  Niyati's theorem for the open
--     machine: a path between ANY two processes, corecursively over a
--     path of states.  The receipts align the visible components; the
--     receipt space, being a proposition, collapses by isProp→PathP;
--     the tails recurse, guarded, over the aligned state path.
------------------------------------------------------------------------

sāmyaP : {w₀ w₁ : W} (π : w₀ ≡ w₁) (p : Śālā w₀) (q : Śālā w₁)
       → PathP (λ i → Śālā (π i)) p q
react (sāmyaP {w₀} {w₁} π p q i) pr = wP i , oP i , eP i , sāmyaP wP tp tq i
  where
    a₀ = fst (react p pr)
    o₀ = fst (snd (react p pr))
    e₀ = fst (snd (snd (react p pr)))
    tp = snd (snd (snd (react p pr)))
    a₁ = fst (react q pr)
    o₁ = fst (snd (react q pr))
    e₁ = fst (snd (snd (react q pr)))
    tq = snd (snd (snd (react q pr)))

    wP : a₀ ≡ a₁
    wP = snd e₀ ∙∙ (λ j → gamanam (π j) pr) ∙∙ sym (snd e₁)

    oP : o₀ ≡ o₁
    oP = fst e₀ ∙∙ (λ j → uttaram (π j) pr) ∙∙ sym (fst e₁)

    eP : PathP (λ j → E (π j) pr (wP j) (oP j)) e₀ e₁
    eP = isProp→PathP (λ j → isPropE (π j) pr (wP j) (oP j)) e₀ e₁

-- THE THEOREM.  One interface, one behaviour: the space of lawful
-- SHA-256 interactions from any state is contractible.
एक-संवादः : (w : W) → isContr (Śālā w)
एक-संवादः w = saṃvādin w , sāmyaP refl (saṃvādin w)

------------------------------------------------------------------------
-- §4  THE DEMAND MATTERS: two strategies, one state, two different
--     first answers — the coalgebra is properly more than a stream.
------------------------------------------------------------------------

-- the answers a strategy extracts, to finite depth
śrutiḥ : (σ : Strategy Q) (n : ℕ) (w : W) (p : Śālā w) → List (List Word)
śrutiḥ σ zero    w p = []
śrutiḥ σ (suc n) w p =
  fst (snd (react p (σ w))) ∷ śrutiḥ σ n (fst (react p (σ w))) (snd (snd (snd (react p (σ w)))))

pṛcchā arpaṇā : Strategy Q
pṛcchā _ = दर्शय
arpaṇā _ = अर्पय []

पृच्छा-भेदः : ¬ ( śrutiḥ pṛcchā 1 H0 (saṃvādin H0)
                ≡ śrutiḥ arpaṇā 1 H0 (saṃvādin H0) )
पृच्छा-भेदः π = ¬cons≡nil (cons-inj₁ π)

------------------------------------------------------------------------
-- §5  THE BREACH: demand, offer, demand — and the third answer is a
--     function of the first, for EVERY process of the interface.  The
--     digest is total state disclosure, so one emission hands the
--     environment the hasher's entire future.
------------------------------------------------------------------------

दीर्घीकरण-भेदः : (H : W) (b : List Bool) (p : Śālā H) →
    dṛṣṭam दर्शय (śeṣaḥ (अर्पय b) (śeṣaḥ दर्शय p))
  ≡ compress (dṛṣṭam दर्शय p) b
दीर्घीकरण-भेदः H b p =
    fst e₃                                    -- the third answer is the state it was asked at
  ∙ snd e₂                                    -- which is the compression of the state after the first demand
  ∙ cong (λ x → compress x b)
      (snd e₁ ∙ sym (fst e₁))                 -- and THAT state was exactly what the first demand showed
  where
    p₁ = śeṣaḥ दर्शय p
    e₁ = fst (snd (snd (react p दर्शय)))
    p₂ = śeṣaḥ (अर्पय b) p₁
    e₂ = fst (snd (snd (react p₁ (अर्पय b))))
    e₃ = fst (snd (snd (react p₂ दर्शय)))

------------------------------------------------------------------------
-- §6  THE COLLAPSE: kill the demand and the dialogue is the stream.
--     Under an offer-only strategy, observation of the interaction is
--     exactly the take-truncation of Sha256Srotas' block chain — the
--     previous module recovered as the trivial-query case of this one.
------------------------------------------------------------------------

nitya : {A : Type₀} → A → Dhārā A
śiras (nitya a) = a
śeṣam (nitya a) = nitya a

एकाग्र-पातः : (c : List Bool) (n : ℕ) (w : W)
  → observe (λ _ → अर्पय c) n (saṃvādin w)
  ≡ take n (Khaṇḍa.gati w (nitya c))
एकाग्र-पातः c zero    w = refl
एकाग्र-पातः c (suc n) w = cong (compress w c ∷_) (एकाग्र-पातः c n (compress w c))
