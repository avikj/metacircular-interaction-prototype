{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नेरोड-यन्त्र — the machine, constructed.
--
-- RESOLUTION OF A FORMER SCOPE LINE.  Abstract 15 proved the
-- indistinguishability relation of a modular sensor family equal to
-- divisibility by the lcm, and its closing section said the automaton
-- itself was absent — the automata-theoretic reading was offered, not
-- proved.  This file ends that: THE AUTOMATON NOW EXISTS, and the
-- reading is a theorem, in its strongest form:
--
--   §1  A Moore machine is a transition function δ : S → S (unary
--       alphabet — the input letter is "advance") with an observation
--       out : S → O.  Its Nerode relation is agreement of the two
--       states' observations under EVERY word: ∀ k, out (δᵏ s) ≡
--       out (δᵏ t).
--
--   §2  THE COLLAPSE THEOREM, generic.  If the next observation
--       factors through the current one — out ∘ δ = g ∘ out for some
--       g : O → O, i.e. the observation is a coalgebra homomorphism,
--       the dashboard condition of UpakaranaVrddhi in coalgebraic form
--       — then the whole Nerode relation IS the kernel of one
--       observation: Nerode s t ≃ (out s ≡ out t), an equivalence of
--       types, for any set O.  Infinitely many experiments collapse to
--       one, not approximately but as an equivalence, and the residue
--       class is the whole Nerode class.
--
--   §3  The instance abstract 15 promised: states ℕ, advance = suc,
--       observation = (parity, residue mod 3).  The factoring is
--       DEFINITIONAL (fac = refl): stepping the counter steps the
--       readout.  Hence its Nerode congruence is computed — two counts
--       are Nerode-equivalent exactly when one readout agrees — and
--       with abstract 15's own theorem (agreement ≃ divisibility by 6)
--       the chain closes: Nerode class = residue mod lcm, now WITH the
--       machine, not about a machine-shaped absence.
--
-- The connective tissue is this session's factoring law: a derived
-- reading is blind on its source's fibres (ApurvaIndriyam), a derived
-- sense adds no separation (UpakaranaVrddhi), and here the same
-- factoring, pointed along time instead of between instruments, is
-- exactly what makes an observation FINITE-STATE-COMPLETE: the future
-- adds no separation because the future's readout is post-processing
-- of the present's.  One law: factoring kills separation — across
-- instruments, and now across time.
--
-- SYĀT — THE CLAIM, EXACTLY.  The alphabet is unary; "automaton" means
-- the Moore machine above; no regular languages and no minimisation
-- algorithm appear.  Those are the next absences to construct, not
-- readings left unproved.
------------------------------------------------------------------------

module NerodeYantra_TheMooreMachineNowExistsAndWhenTheNextObservationFactorsThroughTheCurrentTheNerodeCongruenceIsOneObservationsKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels using (isPropΠ ; isSetRetract ; isSet×)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; isSetBool)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

private
  variable
    ℓ ℓ' : Level

-- Word application: run the machine k letters.
cakra : {A : Type ℓ} → (A → A) → ℕ → A → A
cakra δ zero    s = s
cakra δ (suc k) s = δ (cakra δ k s)

------------------------------------------------------------------------
-- १–२ · The machine, its Nerode relation, and the collapse theorem.
------------------------------------------------------------------------

module Yantra {S : Type ℓ} {O : Type ℓ'}
              (δ : S → S) (out : S → O)
              (setO : isSet O)
              (g : O → O) (fac : ∀ s → out (δ s) ≡ g (out s)) where

  Nerode : S → S → Type ℓ'
  Nerode s t = ∀ k → out (cakra δ k s) ≡ out (cakra δ k t)

  -- The readout of the k-th state is the k-th post-processing of the
  -- first readout: the future is derived from the present.
  bhaviṣya : ∀ k s → out (cakra δ k s) ≡ cakra g k (out s)
  bhaviṣya zero    s = refl
  bhaviṣya (suc k) s = fac (cakra δ k s) ∙ cong g (bhaviṣya k s)

  -- Hence one agreement propagates to every word…
  vistāra : ∀ s t → out s ≡ out t → Nerode s t
  vistāra s t p k = bhaviṣya k s ∙ cong (cakra g k) p ∙ sym (bhaviṣya k t)

  -- …and the Nerode relation is the kernel of ONE observation, as an
  -- equivalence of types.
  nerode-saṅkoca : ∀ s t → Nerode s t ≃ (out s ≡ out t)
  nerode-saṅkoca s t = isoToEquiv
    (iso (λ nd → nd zero)
         (vistāra s t)
         (λ p → setO _ _ _ p)
         (λ nd → isPropΠ (λ k → setO _ _) _ nd))

------------------------------------------------------------------------
-- ३ · The instance abstract 15 promised: the (2,3) sensor counter.
------------------------------------------------------------------------

data Tri : Type₀ where
  t0 t1 t2 : Tri

paribhramaṇa : Tri → Tri
paribhramaṇa t0 = t1
paribhramaṇa t1 = t2
paribhramaṇa t2 = t0

triNum : Tri → ℕ
triNum t0 = 0
triNum t1 = 1
triNum t2 = 2

numTri : ℕ → Tri
numTri zero                = t0
numTri (suc zero)          = t1
numTri (suc (suc _))       = t2

isSetTri : isSet Tri
isSetTri = isSetRetract triNum numTri
  (λ { t0 → refl ; t1 → refl ; t2 → refl }) isSetℕ

-- The two sensors, run jointly.
sama : ℕ → Bool
sama zero    = true
sama (suc n) = not (sama n)

śeṣatri : ℕ → Tri
śeṣatri zero    = t0
śeṣatri (suc n) = paribhramaṇa (śeṣatri n)

darśana : ℕ → Bool × Tri
darśana n = sama n , śeṣatri n

-- The factoring is definitional: stepping the counter steps the
-- readout, with no lemma.
gati : Bool × Tri → Bool × Tri
gati (b , t) = not b , paribhramaṇa t

darśana-pravahati : ∀ n → darśana (suc n) ≡ gati (darśana n)
darśana-pravahati n = refl

open Yantra {S = ℕ} {O = Bool × Tri} suc darśana
  (isSet× isSetBool isSetTri) gati darśana-pravahati public
  renaming (nerode-saṅkoca to nerode-of-the-sensor-counter)

-- The machine exists; its Nerode congruence is the kernel of one joint
-- readout, by nerode-of-the-sensor-counter; and abstract 15's checked
-- theorem (readout agreement ≃ divisibility of the difference by 6)
-- composes with it to give: Nerode class = residue class mod lcm.
