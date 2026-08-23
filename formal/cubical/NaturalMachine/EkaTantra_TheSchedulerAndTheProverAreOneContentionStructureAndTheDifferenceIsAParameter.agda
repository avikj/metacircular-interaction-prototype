{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- एकतन्त्रम् — one loom.  Compound built here, 2026-08-24; not a source
-- term.
--
-- THE OWNER'S SENTENCE, tonight, taken as a theorem: "scheduler and
-- prover should be almost identical — everything should be.  Consult
-- Jain philosophy; it is exactly what we have implemented."  This
-- module is that sentence as a term.
--
-- THE ONE STRUCTURE.  A सभा (assembly): standpoints, each speaking
-- PARTIALLY about sites (a naya asserts syāt — from its own scope,
-- nothing outside it).  At a site, the utterances are gathered; a
-- JOINER — the fact that identifies utterances — either brings them to
-- one (निर्णीतम्) or does not, and then the position is held WITH the
-- utterances entire (अवक्तव्यम् carrying its full residue: not unknown,
-- not empty — the fourth position, Sanmatitarka's discipline that a
-- standpoint decided by denying another with no fact is durnaya).
-- From a residue whose members a DEEPER fact identifies, a standpoint
-- is born whose entire scope is that one site — अनवकाश, "having no
-- other scope" — and scope-exactness is a theorem here, not a claim.
--
-- THE TWO FACES, and what "almost identical" means exactly:
--
--   SCHEDULER (machine/Vipratisedha_…hs, the executable elder):
--     वक्तारः = tSasanani (sūtras as partial offers)
--     निर्णीतम्/अवक्तव्यम् = Nirnita / Avaktavya+Sesa, field for field
--     the joiner = the metarule order (paribhāṣā 38) — DATA
--     the birth = AvaktavyaPrasava's prasava (agreement under anugama)
--
--   PROVER (this lane, on EkaBhasha's foundation):
--     वक्तारः = the store's rewrite rules as partial offers on terms
--     a critical pair = two standpoints meeting on ONE term —
--       Kātyāyana's द्वौ प्रसङ्गौ अन्यार्थौ एकस्मिन् स विप्रतिषेधः,
--       vārttika 1 on Aṣṭādhyāyī 1.4.2, verbatim the configuration
--     the joiner = the SOUND NORMALIZER (norm, with norm-sound) — DATA
--     the birth = सिद्धि's install; and on this foundation the born
--       standpoint carries its proof BY TYPE (नियमः), so the birth
--       cannot mint an unproven rule — the gate is the type.
--
-- Same record, twice.  The difference is the joiner parameter and
-- nothing else — which is the owner's "identical or almost", located.
--
-- SOURCES (the classification is theirs; the code is not claimed to be
-- in any of them): Umāsvāti, Tattvārthasūtra 5.31 (arpita/anarpita —
-- the birth reads the residue under the asserted aspect); Siddhasena
-- Divākara, Sanmatitarka 1.21 (durnaya — why the verdict never picks
-- without a fact); Akalaṅka, Laghīyastraya (sahārpaṇa — why the held
-- position carries both); Kātyāyana as above (the contention);
-- the anavakāśa reasoning from the paribhāṣā literature via
-- machine/AvaktavyaPrasava's header.  NOVELTY CLAIMED: none of the
-- mathematics; the identification, checked.
------------------------------------------------------------------------

module NaturalMachine.EkaTantra_TheSchedulerAndTheProverAreOneContentionStructureAndTheDifferenceIsAParameter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  The one structure.
------------------------------------------------------------------------

-- a standpoint: a partial voice over sites.  syāt: it speaks from its
-- scope and is silent outside it — silence is not denial.
नयः : (O R : Type) → Type
नयः O R = O → Maybe R

-- the assembly is just its standpoints; everything else is an act upon
-- them, parameterized by a fact.
सभा : (O R : Type) → Type
सभा O R = List (नयः O R)

-- the utterances at a site, gathered entire — nothing dropped.
उक्तयः : {O R : Type} → सभा O R → O → List R
उक्तयः []       o = []
उक्तयः (n ∷ ns) o with n o
... | just r  = r ∷ उक्तयः ns o
... | nothing = उक्तयः ns o

-- the verdict: silence, one voice standing (all joined), or the held
-- fourth position CARRYING the utterances entire.  No fourth
-- constructor, and no Bool anywhere.
data फलम् (R : Type) : Type where
  मौनम्     : फलम् R
  निर्णीतम्  : R → फलम् R
  अवक्तव्यम् : R → R → List R → फलम् R   -- at least two voices, all kept

-- the joiner is the FACT that identifies utterances — the parameter in
-- which the scheduler and the prover differ, and the only one.
निर्णयः : {R : Type} → (R → R → Maybe R) → List R → फलम् R
निर्णयः j []       = मौनम्
निर्णयः j (r ∷ rs) = go r rs rs
  where
  go : _ → List _ → List _ → फलम् _
  go acc []        kept = निर्णीतम् acc
  go acc (s ∷ ss) kept with j acc s
  ... | just acc' = go acc' ss kept
  ... | nothing   = अवक्तव्यम् acc s kept

------------------------------------------------------------------------
-- §2  The birth, and anavakāśa as a theorem.
------------------------------------------------------------------------

-- a site-equality that returns the path (the nondual test).
Site≟ : (O : Type) → Type
Site≟ O = (a b : O) → Maybe (a ≡ b)

-- the born standpoint: its entire scope is the one contested site.
अनवकाशः : {O R : Type} → Site≟ O → O → R → नयः O R
अनवकाशः _≟_ site r o = mmap (λ _ → r) (site ≟ o)

-- scope-exactness, both halves — the paribhāṣā's ground made a term:
-- it speaks the agreed thing at its site, and NOTHING anywhere else,
-- so it takes nothing from the standpoints it excepts (anyārtha).
अनवकाश-वदति : {O R : Type} (eq : Site≟ O) (site : O) (r : R)
  → (p : eq site site ≡ just refl)
  → अनवकाशः eq site r site ≡ just r
अनवकाश-वदति eq site r p = cong (mmap (λ _ → r)) p

अनवकाश-मौनम् : {O R : Type} (eq : Site≟ O) (site o : O) (r : R)
  → eq site o ≡ nothing
  → अनवकाशः eq site r o ≡ nothing
अनवकाश-मौनम् eq site o r q = cong (mmap (λ _ → r)) q

------------------------------------------------------------------------
-- §3  FACE ONE — the prover, on the proven foundation.  The store's
--     rules as standpoints on terms; the joiner is the sound
--     normalizer; the birth carries its proof by type.
------------------------------------------------------------------------

-- a rule of the store speaks at exactly the terms matching its lhs; on
-- this slice, at the term ITSELF (root instance — the general matcher
-- is the elder Haskell's and migrates in the next slice, declared).
शासनम् : नियमः → नयः Tm Tm
शासनम् s t = mmap (λ _ → नियमः.rhs s) (नियमः.lhs s ≟T t)

-- the prover's joiner: two utterances are one exactly when the sound
-- normalizer identifies them — and then the identification is TRUE of
-- the standard model, by norm-sound, not merely syntactic.
योजकः : Tm → Tm → Maybe Tm
योजकः a b = mmap (λ _ → norm a) (norm a ≟T norm b)

-- THE BIRTH WITH ITS PROOF: from a contested pair the joiner
-- identifies, a नियमः — constructible only with its साक्षी, so this
-- face's births are born proven.  The gate is the type.
प्रसवः : (a b : Tm) → (⊨ (a , b)) → नियमः
प्रसवः a b pf = niyama a b pf

------------------------------------------------------------------------
-- §4  The demonstration, on the machine's own material: a REAL
--     contention (two utterances of one site, raw-distinct), held by
--     the raw joiner, identified by the sound joiner, and the born
--     rule installed as a typed value.
--
--     Site: the term le(0, s(x)).  Voice one utters s(0) (the le-zero
--     rule's reading); voice two utters le(0, x) (the le-suc reading).
--     Raw, they differ: अवक्तव्यम्, both kept.  Under योजकः they are
--     one: both normalize to s(0).  The birth: le(0, s(x)) = s(0),
--     with its proof, by the internal prover.
------------------------------------------------------------------------

site₁ voice₁ voice₂ : Tm
site₁  = lq ze (su (var 0))
voice₁ = su ze
voice₂ = lq ze (var 0)

-- raw joiner: syntactic identity only.
शुद्ध-योजकः : Tm → Tm → Maybe Tm
शुद्ध-योजकः a b = mmap (λ _ → a) (a ≟T b)

-- held raw: the fourth position, both utterances carried.
धृतम् : निर्णयः शुद्ध-योजकः (voice₁ ∷ voice₂ ∷ []) ≡
        अवक्तव्यम् voice₁ voice₂ (voice₂ ∷ [])
धृतम् = refl

-- identified deep: the sound normalizer brings the two voices to one.
मिलितम् : योजकः voice₁ voice₂ ≡ just (su ze)
मिलितम् = refl

-- the born rule, PROVEN — its construction is its proof; a failure
-- here would be a type error, not a verdict.
जातः : नियमः
जातः = प्रसवः site₁ voice₁
        (fromJust (साधनम् (site₁ , voice₁)) tt)

-- and the born standpoint decides its own site, speaking the truth the
-- deep fact licensed — anavakāśa executing on the prover face.
जात-वदति : शासनम् जातः site₁ ≡ just voice₁
जात-वदति = refl
