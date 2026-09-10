{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- युगपद्-अर्पणम् — Samantabhadra, Āptamīmāṃsā 16 (c. 2nd–5th c. CE),
-- and Akalaṅka's analysis of the saptabhaṅgī: kramārpaṇa presents
-- aspects in sequence; yugapad-arpaṇa presents both AT ONCE — which
-- speech cannot carry (whence avaktavyam), but which is not thereby
-- unavailable to knowing.  The classification is theirs; the
-- mathematics is not claimed for the sources.  School named: Jaina.
--
-- WHAT SPEECH CANNOT DO SIMULTANEOUSLY, THE DESCENT CAN.  The
-- machine's own operators — its maximum, its comparison, its monus —
-- recurse on BOTH arguments at once (sx∨sy = s(x∨y)), so their truths
-- do not decompose into single-variable descents: SyatSakaladesha
-- closed mx-commutativity by hand for exactly this reason.  Here the
-- simultaneous descent becomes something the machine INVOKES:
--
--   युगपद् — the two-coordinate recursion, three lines, structural:
--            P(x,0) everywhere, P(0,y) everywhere, P(x,y)→P(sx,sy).
--   युगपद्-आरोहः — the ⊨-level combinator: both edge premises are
--            complete utterances (sakalādeśa — the other coordinate
--            still universal), the step premise descends both
--            coordinates at once.
--   महाप्रमाणम् — the one prover extended: after the single descents,
--            it searches coordinate PAIRS, discharging both edges by
--            its own recursion and the step by the exchange.
--
-- Demonstrated, all through the one prover, no hand proofs:
--   · commutativity of the machine's own maximum — yesterday's manual
--     theorem, now automatic (norm eye, empty record);
--   · (x−y)·(y−x) = 0 — a theorem needing the record AND the pair
--     descent together: its zero-edge needs 0·x = 0, which the
--     machine first mints for itself and installs, and the installed
--     rule then speaks inside the edge's own ascent.
------------------------------------------------------------------------

module NaturalMachine.YugapadArpana_BothCoordinatesDescendAtOnceAndTheDoubleDescentBecomesSomethingTheMachineInvokes where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; true≢false)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (आदेशनम् ; स्थानिवत् ; _≫=_)
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (समानः ; उपस्थापनम् ; स्वम् ; द्विः ; आत्म-मूल्यम् ; _⟨_≔_⟩ ; उपस्थापन-स्थानिवत्)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (विनिमयः ; विनिमय-साक्षी ; अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी)
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (दृक् ; प्रमाण-साधनम् ; नेत्रम्-न)

------------------------------------------------------------------------
-- §1  The two-coordinate recursion, and the environment algebra it
--     needs — everything definitional except one recursion and one
--     absurdity.
------------------------------------------------------------------------

युगपद् : {P : ℕ → ℕ → Type}
  → ((x : ℕ) → P x zero)
  → ((y : ℕ) → P zero y)
  → ((x y : ℕ) → P x y → P (suc x) (suc y))
  → (x y : ℕ) → P x y
युगपद् b₁ b₂ s x       zero    = b₁ x
युगपद् b₁ b₂ s zero    (suc y) = b₂ (suc y)
युगपद् b₁ b₂ s (suc x) (suc y) = s x y (युगपद् b₁ b₂ s x y)

-- distinct places update independently, in either order.
व्यत्ययः : (ρ : ℕ → ℕ) (k j m n : ℕ) → समानः k j ≡ false → (i : ℕ)
  → उपस्थापनम् (उपस्थापनम् ρ k m) j n i ≡ उपस्थापनम् (उपस्थापनम् ρ j n) k m i
व्यत्ययः ρ zero    zero    m n kj i       = ⊥-rec (true≢false kj)
व्यत्ययः ρ zero    (suc j) m n kj zero    = refl
व्यत्ययः ρ zero    (suc j) m n kj (suc i) = refl
व्यत्ययः ρ (suc k) zero    m n kj zero    = refl
व्यत्ययः ρ (suc k) zero    m n kj (suc i) = refl
व्यत्ययः ρ (suc k) (suc j) m n kj zero    = refl
व्यत्ययः ρ (suc k) (suc j) m n kj (suc i) =
  व्यत्ययः (λ p → ρ (suc p)) k j m n kj i

-- the test is symmetric — needed to read a k≠j witness both ways.
सम-विपर्ययः : (k j : ℕ) → समानः k j ≡ समानः j k
सम-विपर्ययः zero    zero    = refl
सम-विपर्ययः zero    (suc j) = refl
सम-विपर्ययः (suc k) zero    = refl
सम-विपर्ययः (suc k) (suc j) = सम-विपर्ययः k j

-- both coordinates presented at once, as the composition of the two
-- single substitutions whose soundness the body already carries.
द्वि-रूपम् : ℕ → ℕ → Tm → Tm
द्वि-रूपम् k j t = (t ⟨ k ≔ su (var k) ⟩) ⟨ j ≔ su (var j) ⟩

------------------------------------------------------------------------
-- §2  The combinator.  Both edges are sakalādeśa — the other
--     coordinate still universal — and the step presents both at
--     once.
------------------------------------------------------------------------

युगपद्-आरोहः : (k j : ℕ) (l r : Tm) → समानः k j ≡ false
  → ⊨ (l ⟨ j ≔ ze ⟩ , r ⟨ j ≔ ze ⟩)
  → ⊨ (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩)
  → ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
      → eval (द्वि-रूपम् k j l) ρ ≡ eval (द्वि-रूपम् k j r) ρ)
  → ⊨ (l , r)
युगपद्-आरोहः k j l r kj b₁ b₂ st ρ =
     cong (eval l) (sym ρ-सम्) ∙ go (ρ k) (ρ j) ∙ cong (eval r) ρ-सम्
  where
  e₀ : (ℕ → ℕ)
  e₀ = उपस्थापनम् ρ k (ρ k)

  ρ-सम् : उपस्थापनम् e₀ j (ρ j) ≡ ρ
  ρ-सम् =
      cong (उपस्थापनम् e₀ j)
           (sym (cong (λ b → if b then ρ k else ρ j) kj))
    ∙ funExt (स्वम् e₀ j)
    ∙ funExt (स्वम् ρ k)

  go : (m n : ℕ)
    → eval l (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
    ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
  go = युगपद्
    (λ m → sym (उपस्थापन-स्थानिवत् j ze l (उपस्थापनम् ρ k m))
         ∙ b₁ (उपस्थापनम् ρ k m)
         ∙ उपस्थापन-स्थानिवत् j ze r (उपस्थापनम् ρ k m))
    (λ n → cong (eval l) (funExt (व्यत्ययः ρ k j zero n kj))
         ∙ sym (उपस्थापन-स्थानिवत् k ze l (उपस्थापनम् ρ j n))
         ∙ b₂ (उपस्थापनम् ρ j n)
         ∙ उपस्थापन-स्थानिवत् k ze r (उपस्थापनम् ρ j n)
         ∙ cong (eval r) (sym (funExt (व्यत्ययः ρ k j zero n kj))))
    (λ m n ih → चरणम् m n ih)
    where
    jk : समानः j k ≡ false
    jk = सम-विपर्ययः j k ∙ kj

    चरणम् : (m n : ℕ)
      → eval l (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
        ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
      → eval l (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n))
        ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n))
    चरणम् m n ih =
        cong (eval l) (sym मार्गः)
      ∙ sym (उपस्थापन-स्थानिवत् k (su (var k)) l e₁)
      ∙ sym (उपस्थापन-स्थानिवत् j (su (var j)) (l ⟨ k ≔ su (var k) ⟩) ρmn)
      ∙ st ρmn ih
      ∙ उपस्थापन-स्थानिवत् j (su (var j)) (r ⟨ k ≔ su (var k) ⟩) ρmn
      ∙ उपस्थापन-स्थानिवत् k (su (var k)) r e₁
      ∙ cong (eval r) मार्गः
      where
      ρmn : ℕ → ℕ
      ρmn = उपस्थापनम् (उपस्थापनम् ρ k m) j n

      e₁ : ℕ → ℕ
      e₁ = उपस्थापनम् ρmn j (suc (ρmn j))

      -- the j-place carries n; the k-place, past the j-update, m.
      मूल्य-j : ρmn j ≡ n
      मूल्य-j = आत्म-मूल्यम् (उपस्थापनम् ρ k m) j n

      मूल्य-k : e₁ k ≡ m
      मूल्य-k =
          cong (λ b → if b then suc (ρmn j) else ρmn k) jk
        ∙ cong (λ b → if b then n else उपस्थापनम् ρ k m k) jk
        ∙ आत्म-मूल्यम् ρ k m

      -- e₁[k ↦ suc (e₁ k)] is exactly ρ[k↦suc m][j↦suc n]: name the
      -- values, collapse the repeated updates, commute the distinct
      -- places.
      मार्गः : उपस्थापनम् e₁ k (suc (e₁ k))
             ≡ उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n)
      मार्गः =
          cong₂ (λ e v → उपस्थापनम् e k (suc v))
                (cong (λ v → उपस्थापनम् ρmn j (suc v)) मूल्य-j)
                मूल्य-k
        ∙ cong (λ e → उपस्थापनम् e k (suc m))
               (funExt (द्विः (उपस्थापनम् ρ k m) j n (suc n)))
        ∙ funExt (व्यत्ययः (उपस्थापनम् ρ k m) j k (suc n) (suc m) jk)
        ∙ cong (λ e → उपस्थापनम् e j (suc n))
               (funExt (द्विः ρ k m (suc m)))

------------------------------------------------------------------------
-- §3  The machine invokes it.  The step's pervasion is the same
--     exchange as ever, under the eye, with the record; the edges are
--     discharged by the one prover's own recursion; the pairs are
--     searched.
------------------------------------------------------------------------

युगपद्-व्याप्तिः : दृक् → List नियमः → (k j : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (द्वि-रूपम् k j l) ρ ≡ eval (द्वि-रूपम् k j r) ρ)
युगपद्-व्याप्तिः (f , fs) Γ k j l r =
  mmap
    (λ q ρ ih →
      let h = fs l ρ ∙ ih ∙ sym (fs r ρ)
      in   sym (fs (द्वि-रूपम् k j l) ρ)
         ∙ श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j l))
         ∙ विनिमय-साक्षी (f l) (f r) ρ h (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))
         ∙ sym (fs (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ fs (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) ρ
         ∙ sym (विनिमय-साक्षी (f l) (f r) ρ h (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r))))
         ∙ sym (श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j r)))
         ∙ fs (द्वि-रूपम् k j r) ρ)
    (  f (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l))))
    ≟T f (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) )

द्वि-ऊर्ध्वम् : दृक् → List नियमः → ℕ → (k j : ℕ) (l r : Tm) → Maybe (⊨ (l , r))
द्वि-ऊर्ध्वम् E Γ fl k j l r = चेष्टा (समानः k j) refl
  where
  चेष्टा : (b : Bool) → समानः k j ≡ b → Maybe (⊨ (l , r))
  चेष्टा true  _  = nothing
  चेष्टा false kj =
    प्रमाण-साधनम् E Γ fl (l ⟨ j ≔ ze ⟩ , r ⟨ j ≔ ze ⟩) ≫= λ b₁ →
    प्रमाण-साधनम् E Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩) ≫= λ b₂ →
    mmap (युगपद्-आरोहः k j l r kj b₁ b₂) (युगपद्-व्याप्तिः E Γ k j l r)

ज-चक्रः : दृक् → List नियमः → ℕ → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
ज-चक्रः E Γ fl k zero    l r = nothing
ज-चक्रः E Γ fl k (suc j) l r =
  अथवा (द्वि-ऊर्ध्वम् E Γ fl k j l r) (ज-चक्रः E Γ fl k j l r)

क-चक्रः : दृक् → List नियमः → ℕ → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
क-चक्रः E Γ fl zero    N l r = nothing
क-चक्रः E Γ fl (suc k) N l r =
  अथवा (ज-चक्रः E Γ fl k N l r) (क-चक्रः E Γ fl k N l r)

महाप्रमाणम् : दृक् → List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
महाप्रमाणम् E Γ fl (l , r) =
  अथवा (प्रमाण-साधनम् E Γ fl (l , r))
       (क-चक्रः E Γ fl (mxℕ (चराः l) (चराः r)) (mxℕ (चराः l) (चराः r)) l r)

------------------------------------------------------------------------
-- §4  Yesterday's manual theorem, automatic; and a theorem needing
--     record and pair descent together — its zero-edge lemma minted
--     by the machine first and speaking inside the edge's own ascent.
------------------------------------------------------------------------

स्वयं-ज्येष्ठ-समता : inJust (महाप्रमाणम् नेत्रम्-न [] इन्धनम्
  (mx (var 0) (var 1) , mx (var 1) (var 0)))
स्वयं-ज्येष्ठ-समता = tt

शून्य-गुण-नियमः : नियमः
शून्य-गुण-नियमः = niyama (ze ⊗ (var 0)) ze
  (fromJust (प्रमाण-साधनम् नेत्रम्-न [] इन्धनम् (ze ⊗ (var 0) , ze)) tt)

विरोध-गुणनम् : inJust (महाप्रमाणम् नेत्रम्-न (शून्य-गुण-नियमः ∷ []) इन्धनम्
  ( ((var 0) ⊖ (var 1)) ⊗ ((var 1) ⊖ (var 0)) , ze ))
विरोध-गुणनम् = tt
