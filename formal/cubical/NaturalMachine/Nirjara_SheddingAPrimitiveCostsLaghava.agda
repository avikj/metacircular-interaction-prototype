{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- निर्जरा at the level of the vocabulary, and what it costs.
--
-- Umāsvāti, Tattvārthasūtra 9.19-9.20 (~2nd-5th c.): nirjarā is brought
-- about by tapas; savipāka, the shedding that happens as karma ripens,
-- gains nothing, and only avipāka — deliberate, before its time — is a
-- path.  10.1: kevala-jñāna arises from the DESTRUCTION of the obscuring
-- karmas, not from acquisition.
--
-- Taken as given: shedding an inert primitive loses no meaning and does
-- remove the symbol, and it strictly INCREASES the presentation.  An
-- engine steered by लाघव can never take the step.  Only तपस् removes a
-- primitive, and तपस् is the operation you do against the gradient.
--
-- What the terms below establish, in the order they are stated:
--   no invariant of the denotation sees the presentation, and saturating
--   over every context does not reach it either; a licence is a record,
--   not a check, and licences compose; the price of a licensed
--   translation is cofinal in ℕ and no licensed move goes from cheap to
--   expensive; उत्सर्ग is the only move non-increasing in all three
--   measures; conflict is decided by a metarule that may abstain, and the
--   binary case does not fold; a rule carrying its own domain need not
--   have that domain stated again, and carving is forced exactly when the
--   behaviour acts off its निमित्त; extent does not determine price.
--
-- ATTESTED, used as the source uses them: निर्जरा, तपस्, सविपाक/अविपाक;
-- उपमान, उपाधि, दुर्नय, अवक्तव्य; अनुवृत्ति, प्रत्याहार, अपवाद, उत्सर्ग,
-- विप्रतिषेध, सूत्र, परिभाषा; लघु/गुरु as Piṅgala's pair; मात्रा as the
-- grammarians' unit of लाघव (अर्धमात्रालाघवेन पुत्रोत्सवं मन्यन्ते
-- वैयाकरणाः — Nāgeśa, Paribhāṣenduśekhara ~1700; Patañjali ~150 BCE).
-- Five-term strength ranking: Nāgeśa, Paribhāṣenduśekhara 38.
--
-- MINE, the Sanskrit is decoration on a standard construction:
-- Sandarbha/sthapana/Avishesha (one-hole contexts, contextual
-- equivalence), Prakriya/Sutra as used here (a straight-line program with
-- back-references), guru (largest intermediate), and mulya, sthula,
-- bhrama, Anujna, Ankita, cakra, jaya, svavisaya, nishkriya, ubhau,
-- avrtti, and every Sanskrit theorem name below.
--
-- CHECKED: exit code quoted in the commit.  Agda 2.6.3 + cubical v0.5 in
-- this container, which is NOT the repository pin.
------------------------------------------------------------------------

module NaturalMachine.Nirjara_SheddingAPrimitiveCostsLaghava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; injSuc ; snotz ; znots)
open import Cubical.Data.Nat.Properties using (+-zero ; +-suc)
open import Cubical.Foundations.Prelude using (funExt⁻)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; if_then_else_ ; _and_ ; _or_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-suc ; ≤-sucℕ ; suc-≤-suc ; pred-≤-pred ; zero-≤ ; ≤SumLeft ; ≤SumRight ; ≤-+k ; ≤Dec ; ¬-<-zero ; ¬m<m)
open import Cubical.Data.Nat using (discreteℕ)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)
open import Cubical.Data.Empty renaming (rec to ⊥rec)
open import Cubical.Data.Maybe using (Maybe ; just ; nothing ; ¬just≡nothing)

data Pada : Type₀ where
  cara : Pada                    -- the variable
  mita : ℕ → Pada                -- a literal
  yoga : Pada → Pada → Pada      -- addition
  dvi  : Pada → Pada             -- the candidate primitive

Artha : Type₀
Artha = ℕ → ℕ

artha : Pada → Artha
artha cara       n = n
artha (mita k)   _ = k
artha (yoga a b) n = artha a n + artha b n
artha (dvi a)    n = artha a n + artha a n

nirjara : Pada → Pada
nirjara cara       = cara
nirjara (mita k)   = mita k
nirjara (yoga a b) = yoga (nirjara a) (nirjara b)
nirjara (dvi a)    = yoga (nirjara a) (nirjara a)

nirjara-artha-aviruddha : (e : Pada) → artha (nirjara e) ≡ artha e
nirjara-artha-aviruddha cara       = refl
nirjara-artha-aviruddha (mita k)   = refl
nirjara-artha-aviruddha (yoga a b) i n =
  nirjara-artha-aviruddha a i n + nirjara-artha-aviruddha b i n
nirjara-artha-aviruddha (dvi a)    i n =
  nirjara-artha-aviruddha a i n + nirjara-artha-aviruddha a i n

dviYukta : Pada → Bool
dviYukta cara       = false
dviYukta (mita _)   = false
dviYukta (yoga a b) with dviYukta a
... | true  = true
... | false = dviYukta b
dviYukta (dvi _)    = true

nirjara-shuddha : (e : Pada) → dviYukta (nirjara e) ≡ false
nirjara-shuddha cara     = refl
nirjara-shuddha (mita k) = refl
nirjara-shuddha (dvi a)  with dviYukta (nirjara a) | nirjara-shuddha a
... | false | p = nirjara-shuddha a
... | true  | p = p
nirjara-shuddha (yoga a b) with dviYukta (nirjara a) | nirjara-shuddha a
... | false | _ = nirjara-shuddha b
... | true  | p = p

laghava : Pada → ℕ
laghava cara       = 1
laghava (mita _)   = 1
laghava (yoga a b) = suc (laghava a + laghava b)
laghava (dvi a)    = suc (laghava a)

private
  2≢3 : ¬ (2 ≡ 3)
  2≢3 p = snotz (sym (injSuc (injSuc p)))

sakshin : Pada
sakshin = dvi cara

nirjara-laghavam-vardhayati : ¬ (laghava (nirjara sakshin) ≡ laghava sakshin)
nirjara-laghavam-vardhayati p = 2≢3 (sym p)

tapas : (e : Pada)
      → Σ (artha (nirjara e) ≡ artha e)
          (λ _ → dviYukta (nirjara e) ≡ false)
tapas e = nirjara-artha-aviruddha e , nirjara-shuddha e

tulya-artha : artha (dvi cara) ≡ artha (yoga cara cara)
tulya-artha = refl

dvi-yukta-bheda : ¬ (dviYukta (dvi cara) ≡ dviYukta (yoga cara cara))
dvi-yukta-bheda p = true≢false p

prayoga-na-arthasya : ¬ (Σ (Artha → Bool) (λ f → (e : Pada) → f (artha e) ≡ dviYukta e))
prayoga-na-arthasya (f , spec) =
  dvi-yukta-bheda ( sym (spec (dvi cara))
                  ∙ cong f tulya-artha
                  ∙ spec (yoga cara cara) )

sarva-artha-samam :
  {ℓ : Level} {X : Type ℓ} (g : Artha → X)
  → g (artha (dvi cara)) ≡ g (artha (yoga cara cara))
sarva-artha-samam g = cong g tulya-artha

shabda-eva : (e : Pada) → artha (nirjara e) ≡ artha e
shabda-eva = nirjara-artha-aviruddha

data Laghu : Type₀ where
  cara'  : Laghu
  mita'  : ℕ → Laghu
  yoga'  : Laghu → Laghu → Laghu

nyasa : Laghu → Pada
nyasa cara'        = cara
nyasa (mita' k)    = mita k
nyasa (yoga' a b)  = yoga (nyasa a) (nyasa b)

matra : Laghu → ℕ
matra cara'       = 1
matra (mita' _)   = 1
matra (yoga' a b) = suc (matra a + matra b)

laghava-nyasa-samam : (t : Laghu) → laghava (nyasa t) ≡ matra t
laghava-nyasa-samam cara'       = refl
laghava-nyasa-samam (mita' k)   = refl
laghava-nyasa-samam (yoga' a b) i =
  suc (laghava-nyasa-samam a i + laghava-nyasa-samam b i)

apavada : Pada → Laghu
apavada cara       = cara'
apavada (mita k)   = mita' k
apavada (yoga a b) = yoga' (apavada a) (apavada b)
apavada (dvi a)    = yoga' (apavada a) (apavada a)

nyasa-apavada : (e : Pada) → nyasa (apavada e) ≡ nirjara e
nyasa-apavada cara       = refl
nyasa-apavada (mita k)   = refl
nyasa-apavada (yoga a b) i = yoga (nyasa-apavada a i) (nyasa-apavada b i)
nyasa-apavada (dvi a)    i = yoga (nyasa-apavada a i) (nyasa-apavada a i)

laghava-sthiram : (e : Pada) → matra (apavada e) ≡ laghava (nirjara e)
laghava-sthiram e =
  sym (laghava-nyasa-samam (apavada e)) ∙ cong laghava (nyasa-apavada e)

artha' : Laghu → Artha
artha' cara'       n = n
artha' (mita' k)   _ = k
artha' (yoga' a b) n = artha' a n + artha' b n

nyasa-artha : (t : Laghu) → artha (nyasa t) ≡ artha' t
nyasa-artha cara'       = refl
nyasa-artha (mita' k)   = refl
nyasa-artha (yoga' a b) i n = nyasa-artha a i n + nyasa-artha b i n

upamana : (s t : Laghu) → artha' s ≡ artha' t → artha (nyasa s) ≡ artha (nyasa t)
upamana s t p = nyasa-artha s ∙ p ∙ sym (nyasa-artha t)

upamana-laghavam-na-vardhayati : (t : Laghu) → laghava (nyasa t) ≡ matra t
upamana-laghavam-na-vardhayati = laghava-nyasa-samam

bhrama : Laghu → Pada
bhrama cara'       = cara
bhrama (mita' k)   = mita k
bhrama (yoga' a b) = dvi (bhrama a)

private
  vama dakshina : Laghu
  vama     = yoga' cara' (mita' 0)
  dakshina = cara'

  artha'-samam : artha' vama ≡ artha' dakshina
  artha'-samam i n = +-zero n i

  bhrama-bheda : ¬ (artha (bhrama vama) ≡ artha (bhrama dakshina))
  bhrama-bheda p = snotz (injSuc (funExt⁻ p 1))

upamana-upadhi-apeksate :
  ¬ ((s t : Laghu) → artha' s ≡ artha' t → artha (bhrama s) ≡ artha (bhrama t))
upamana-upadhi-apeksate f = bhrama-bheda (f vama dakshina artha'-samam)

sarvatra-samam : (n : ℕ) → artha' vama n ≡ artha' dakshina n
sarvatra-samam n = +-zero n

upadhi-anuvade-vasati :
  ((n : ℕ) → artha' vama n ≡ artha' dakshina n)
  × (¬ (artha (bhrama vama) ≡ artha (bhrama dakshina)))
upadhi-anuvade-vasati = sarvatra-samam , bhrama-bheda

record Sadrsya : Type₀ where
  constructor sadrsyam
  field
    anuvada : Laghu → Pada
    pramana : (t : Laghu) → artha (anuvada t) ≡ artha' t

open Sadrsya public

upamana-sadrsyat :
  (S : Sadrsya) (s t : Laghu)
  → artha' s ≡ artha' t
  → artha (anuvada S s) ≡ artha (anuvada S t)
upamana-sadrsyat S s t p = pramana S s ∙ p ∙ sym (pramana S t)

nyasa-sadrsyam : Sadrsya
nyasa-sadrsyam = sadrsyam nyasa nyasa-artha

bhrama-na-sadrsyam : ¬ (Σ Sadrsya (λ S → anuvada S ≡ bhrama))
bhrama-na-sadrsyam (S , e) =
  bhrama-bheda ( cong (λ f → artha (f vama)) (sym e)
               ∙ upamana-sadrsyat S vama dakshina artha'-samam
               ∙ cong (λ f → artha (f dakshina)) e )

mulya : Sadrsya → Laghu → ℕ
mulya S t = laghava (anuvada S t)

nyasa-nirmulyam : (t : Laghu) → mulya nyasa-sadrsyam t ≡ matra t
nyasa-nirmulyam = laghava-nyasa-samam

sthula : Laghu → Pada
sthula t = yoga (nyasa t) (mita 0)

sthula-artha : (t : Laghu) → artha (sthula t) ≡ artha' t
sthula-artha t =
  funExt (λ n → +-zero (artha (nyasa t) n)) ∙ nyasa-artha t

sthula-sadrsyam : Sadrsya
sthula-sadrsyam = sadrsyam sthula sthula-artha

mulya-artha-samam : (S T : Sadrsya) (t : Laghu)
                  → artha (anuvada S t) ≡ artha (anuvada T t)
mulya-artha-samam S T t = pramana S t ∙ sym (pramana T t)

sarvam-arthasya-samam :
  {ℓ : Level} {X : Type ℓ} (g : Artha → X) (S T : Sadrsya) (t : Laghu)
  → g (artha (anuvada S t)) ≡ g (artha (anuvada T t))
sarvam-arthasya-samam g S T t = cong g (mulya-artha-samam S T t)

mulya-bheda : ¬ (mulya nyasa-sadrsyam cara' ≡ mulya sthula-sadrsyam cara')
mulya-bheda p = znots (injSuc p)

mulya-na-arthasya :
  ¬ (Σ (Artha → ℕ)
       (λ c → (S : Sadrsya) (t : Laghu) → c (artha (anuvada S t)) ≡ mulya S t))
mulya-na-arthasya (c , h) =
  mulya-bheda ( sym (h nyasa-sadrsyam cara')
              ∙ cong c (mulya-artha-samam nyasa-sadrsyam sthula-sadrsyam cara')
              ∙ h sthula-sadrsyam cara' )

data Sandarbha : Type₀ where
  chidra         : Sandarbha
  yoga-vama      : Sandarbha → Pada → Sandarbha
  yoga-dakshina  : Pada → Sandarbha → Sandarbha
  dvi-antar      : Sandarbha → Sandarbha

sthapana : Sandarbha → Pada → Pada
sthapana chidra              e = e
sthapana (yoga-vama C b)     e = yoga (sthapana C e) b
sthapana (yoga-dakshina a C) e = yoga a (sthapana C e)
sthapana (dvi-antar C)       e = dvi (sthapana C e)

sandarbha-arthe-vartate :
  (C : Sandarbha) (a b : Pada) → artha a ≡ artha b
  → artha (sthapana C a) ≡ artha (sthapana C b)
sandarbha-arthe-vartate chidra a b p = p
sandarbha-arthe-vartate (yoga-vama C d) a b p =
  funExt (λ n → cong (_+ artha d n)
                     (funExt⁻ (sandarbha-arthe-vartate C a b p) n))
sandarbha-arthe-vartate (yoga-dakshina d C) a b p =
  funExt (λ n → cong (artha d n +_)
                     (funExt⁻ (sandarbha-arthe-vartate C a b p) n))
sandarbha-arthe-vartate (dvi-antar C) a b p =
  funExt (λ n → cong₂ _+_ (funExt⁻ (sandarbha-arthe-vartate C a b p) n)
                          (funExt⁻ (sandarbha-arthe-vartate C a b p) n))

Avishesha : Pada → Pada → Type₀
Avishesha a b = (C : Sandarbha) → artha (sthapana C a) ≡ artha (sthapana C b)

sadrsya-avishesha : (S T : Sadrsya) (t : Laghu)
                  → Avishesha (anuvada S t) (anuvada T t)
sadrsya-avishesha S T t C =
  sandarbha-arthe-vartate C (anuvada S t) (anuvada T t) (mulya-artha-samam S T t)

nyasa-sthula-avishesha : (t : Laghu) → Avishesha (nyasa t) (sthula t)
nyasa-sthula-avishesha t =
  sadrsya-avishesha nyasa-sadrsyam sthula-sadrsyam t

avishesha-laghavam-na-niyacchati :
  ¬ ((a b : Pada) → Avishesha a b → laghava a ≡ laghava b)
avishesha-laghavam-na-niyacchati h =
  mulya-bheda (h (nyasa cara') (sthula cara') (nyasa-sthula-avishesha cara'))

data Sutra : Type₀ where
  cara-s : Sutra
  mita-s : ℕ → Sutra
  yoga-s : ℕ → ℕ → Sutra      -- अनुवृत्ति: two back-references
  dvi-s  : ℕ → Sutra
  pratyahara-s : ℕ → Sutra    -- प्रत्याहार: one bound names a whole run

Prakriya : Type₀
Prakriya = List Sutra

anu : List Pada → ℕ → Pada
anu []       _       = cara
anu (p ∷ _)  zero    = p
anu (_ ∷ ps) (suc i) = anu ps i

sanghata : List Pada → ℕ → Pada
sanghata []       _       = cara
sanghata (p ∷ _)  zero    = p
sanghata (p ∷ ps) (suc k) = yoga p (sanghata ps k)

pada-of : Sutra → List Pada → Pada
pada-of cara-s       _  = cara
pada-of (mita-s m)   _  = mita m
pada-of (yoga-s i j) ps = yoga (anu ps i) (anu ps j)
pada-of (dvi-s i)    ps = dvi (anu ps i)
pada-of (pratyahara-s k) ps = sanghata ps k

sadhana : Prakriya → List Pada
sadhana []       = []
sadhana (s ∷ ss) = pada-of s (sadhana ss) ∷ sadhana ss

phala : Prakriya → Pada
phala []       = cara
phala (s ∷ ss) = pada-of s (sadhana ss)

matra-p : Prakriya → ℕ
matra-p = length

anu-zero : (P : Prakriya) → anu (sadhana P) zero ≡ phala P
anu-zero []       = refl
anu-zero (s ∷ ss) = refl

anuvrtti : Prakriya → Prakriya
anuvrtti P = yoga-s zero zero ∷ P

anuvrtti-phala : (P : Prakriya) → phala (anuvrtti P) ≡ yoga (phala P) (phala P)
anuvrtti-phala P i = yoga (anu-zero P i) (anu-zero P i)

anuvrtti-matra : (P : Prakriya) → matra-p (anuvrtti P) ≡ suc (matra-p P)
anuvrtti-matra P = refl

anuvrtti-artha : (P : Prakriya) (n : ℕ)
  → artha (phala (anuvrtti P)) n ≡ artha (phala P) n + artha (phala P) n
anuvrtti-artha P n i = funExt⁻ (cong artha (anuvrtti-phala P)) n i

laghava-anuvrttau-na-sthiram :
  ¬ ((P : Prakriya) → laghava (phala (anuvrtti P)) ≡ suc (laghava (phala P)))
laghava-anuvrttau-na-sthiram h =
  snotz (injSuc (injSuc (h (cara-s ∷ []))))

dvitva : Prakriya
dvitva = anuvrtti (cara-s ∷ [])

dvitva-phala : phala dvitva ≡ yoga cara cara
dvitva-phala = anuvrtti-phala (cara-s ∷ [])

dvitva-matra : matra-p dvitva ≡ 2
dvitva-matra = refl

dvitva-laghava : laghava (yoga cara cara) ≡ 3
dvitva-laghava = refl

pratyahara : ℕ → Prakriya → Prakriya
pratyahara k P = pratyahara-s k ∷ P

pratyahara-matra : (k : ℕ) (P : Prakriya)
                 → matra-p (pratyahara k P) ≡ suc (matra-p P)
pratyahara-matra k P = refl

sanghata-vardhate : (p : Pada) (ps : List Pada) (k : ℕ)
  → laghava (sanghata (p ∷ ps) (suc k))
  ≡ suc (laghava p + laghava (sanghata ps k))
sanghata-vardhate p ps k = refl

trini : Prakriya
trini = cara-s ∷ cara-s ∷ cara-s ∷ []

pratyahara-matra-sthiram : (k : ℕ) → matra-p (pratyahara k trini) ≡ 4
pratyahara-matra-sthiram k = refl

pratyahara-laghava-calam :
    (laghava (phala (pratyahara 0 trini)) ≡ 1)
  × (laghava (phala (pratyahara 1 trini)) ≡ 3)
  × (laghava (phala (pratyahara 2 trini)) ≡ 5)
pratyahara-laghava-calam = refl , refl , refl

laghava-pratyahare-na-sthiram :
  ¬ ((k : ℕ) → laghava (phala (pratyahara k trini))
             ≡ laghava (phala (pratyahara zero trini)))
laghava-pratyahare-na-sthiram h = snotz (injSuc (h 1))

mishra : Prakriya
mishra = mita-s 2 ∷ mita-s 1 ∷ mita-s 0 ∷ []

vyavadhana : Pada          -- the top and the bottom, skipping the middle
vyavadhana = yoga (mita 2) (mita 0)

pratyahara-na-vyavadhanam :
  (k : ℕ) → ¬ (phala (pratyahara k mishra) ≡ vyavadhana)
pratyahara-na-vyavadhanam zero          p = znots (injSuc (cong laghava p))
pratyahara-na-vyavadhanam (suc zero)    p =
  snotz (injSuc (injSuc (funExt⁻ (cong artha p) zero)))
pratyahara-na-vyavadhanam (suc (suc k)) p =
  snotz (injSuc (injSuc (injSuc (cong laghava p))))

apavada-p : Prakriya → Prakriya
apavada-p (dvi-s i ∷ ss)        = yoga-s i i ∷ ss
apavada-p []                    = []
apavada-p (cara-s ∷ ss)         = cara-s ∷ ss
apavada-p (mita-s m ∷ ss)       = mita-s m ∷ ss
apavada-p (yoga-s i j ∷ ss)     = yoga-s i j ∷ ss
apavada-p (pratyahara-s k ∷ ss) = pratyahara-s k ∷ ss

apavada-artha : (P : Prakriya) → artha (phala (apavada-p P)) ≡ artha (phala P)
apavada-artha (dvi-s i ∷ ss)        = refl
apavada-artha []                    = refl
apavada-artha (cara-s ∷ ss)         = refl
apavada-artha (mita-s m ∷ ss)       = refl
apavada-artha (yoga-s i j ∷ ss)     = refl
apavada-artha (pratyahara-s k ∷ ss) = refl

apavada-matra : (P : Prakriya) → matra-p (apavada-p P) ≡ matra-p P
apavada-matra (dvi-s i ∷ ss)        = refl
apavada-matra []                    = refl
apavada-matra (cara-s ∷ ss)         = refl
apavada-matra (mita-s m ∷ ss)       = refl
apavada-matra (yoga-s i j ∷ ss)     = refl
apavada-matra (pratyahara-s k ∷ ss) = refl

sthula-p : Prakriya → Prakriya
sthula-p P = yoga-s (suc zero) zero ∷ mita-s 0 ∷ P

sthula-p-artha : (P : Prakriya) (n : ℕ)
               → artha (phala (sthula-p P)) n ≡ artha (phala P) n
sthula-p-artha P n =
    cong (λ x → artha x n + 0) (anu-zero P)
  ∙ +-zero (artha (phala P) n)

sthula-p-matra : (P : Prakriya) → matra-p (sthula-p P) ≡ suc (suc (matra-p P))
sthula-p-matra P = refl

sthula-matram-vardhayati : ¬ ((P : Prakriya) → matra-p (sthula-p P) ≡ matra-p P)
sthula-matram-vardhayati h = snotz (h [])

record Anujna : Type₀ where
  constructor anujnata
  field
    krama             : Prakriya → Prakriya
    artha-sthiram     : (P : Prakriya) → artha (phala (krama P)) ≡ artha (phala P)
    matra-na-vardhate : (P : Prakriya) → matra-p (krama P) ≤ matra-p P
open Anujna public

apavada-anujna : Anujna
apavada-anujna = anujnata apavada-p apavada-artha
  (λ P → subst (λ x → x ≤ matra-p P) (sym (apavada-matra P)) ≤-refl)

akriya-anujna : Anujna
akriya-anujna = anujnata (λ P → P) (λ P → refl) (λ P → ≤-refl)

sanghatita : Anujna → Anujna → Anujna
sanghatita A B = anujnata
  (λ P → krama A (krama B P))
  (λ P → artha-sthiram A (krama B P) ∙ artha-sthiram B P)
  (λ P → ≤-trans (matra-na-vardhate A (krama B P)) (matra-na-vardhate B P))

sthula-na-anujnata : ¬ (Σ Anujna (λ A → krama A ≡ sthula-p))
sthula-na-anujnata (A , q) =
  ¬-<-zero (subst (λ f → matra-p (f []) ≤ matra-p []) q (matra-na-vardhate A []))

bahu-sthula : ℕ → Laghu → Pada
bahu-sthula zero    t = nyasa t
bahu-sthula (suc n) t = yoga (bahu-sthula n t) (mita 0)

bahu-sthula-artha : (n : ℕ) (t : Laghu) → artha (bahu-sthula n t) ≡ artha' t
bahu-sthula-artha zero    t = nyasa-artha t
bahu-sthula-artha (suc n) t =
    funExt (λ m → +-zero (artha (bahu-sthula n t) m))
  ∙ bahu-sthula-artha n t

bahu-sthula-sadrsyam : ℕ → Sadrsya
bahu-sthula-sadrsyam n = sadrsyam (bahu-sthula n) (bahu-sthula-artha n)

bahu-mulya-vardhate : (n : ℕ) (t : Laghu)
  → laghava (bahu-sthula (suc n) t) ≡ suc (suc (laghava (bahu-sthula n t)))
bahu-mulya-vardhate n t =
  cong suc (  +-suc (laghava (bahu-sthula n t)) 0
            ∙ cong suc (+-zero (laghava (bahu-sthula n t))))

n<bahu : (n : ℕ) → n < laghava (bahu-sthula n cara')
n<bahu zero    = ≤-refl
n<bahu (suc n) =
  subst (λ x → suc (suc n) ≤ x) (sym (bahu-mulya-vardhate n cara'))
        (≤-suc (suc-≤-suc (n<bahu n)))

mulyam-aparimitam : (b : ℕ) → Σ Sadrsya (λ S → b < laghava (anuvada S cara'))
mulyam-aparimitam b = bahu-sthula-sadrsyam b , n<bahu b

anujna-na-dirghayati : (A : Anujna) (P : Prakriya)
                     → ¬ (matra-p P < matra-p (krama A P))
anujna-na-dirghayati A P h = ¬m<m (≤-trans h (matra-na-vardhate A P))

sthulam-anujnaya-na-prapyate :
  (A : Anujna) (P : Prakriya) → ¬ (krama A P ≡ sthula-p P)
sthulam-anujnaya-na-prapyate A P q =
  ¬m<m (≤-trans ≤-sucℕ
         (subst (λ R → matra-p R ≤ matra-p P) q (matra-na-vardhate A P)))

maha : ℕ → ℕ → ℕ
maha zero    n       = n
maha (suc m) zero    = suc m
maha (suc m) (suc n) = suc (maha m n)

guru : Prakriya → ℕ
guru []       = 0
guru (s ∷ ss) = maha (laghava (pada-of s (sadhana ss))) (guru ss)

apavada-gurutvam-vardhayati : ¬ ((P : Prakriya) → guru (apavada-p P) ≡ guru P)
apavada-gurutvam-vardhayati h =
  snotz (injSuc (injSuc (h (dvi-s zero ∷ cara-s ∷ []))))

guru-pratyahare-vardhate :
    (guru (pratyahara 0 trini) ≡ 1)
  × (guru (pratyahara 1 trini) ≡ 3)
  × (guru (pratyahara 2 trini) ≡ 5)
guru-pratyahare-vardhate = refl , refl , refl

maha-vama : {m n : ℕ} → m ≤ maha m n
maha-vama {zero}  {n}     = zero-≤
maha-vama {suc m} {zero}  = ≤-refl
maha-vama {suc m} {suc n} = suc-≤-suc maha-vama

maha-dakshina : {m n : ℕ} → n ≤ maha m n
maha-dakshina {zero}  {n}     = ≤-refl
maha-dakshina {suc m} {zero}  = zero-≤
maha-dakshina {suc m} {suc n} = suc-≤-suc maha-dakshina

maha-alpa : {m g k : ℕ} → m ≤ k → g ≤ k → maha m g ≤ k
maha-alpa {zero}  {g}     {k}     p q = q
maha-alpa {suc m} {zero}  {k}     p q = p
maha-alpa {suc m} {suc g} {zero}  p q = ⊥rec (¬-<-zero p)
maha-alpa {suc m} {suc g} {suc k} p q =
  suc-≤-suc (maha-alpa (pred-≤-pred p) (pred-≤-pred q))

record UbhayaAnujna : Type₀ where
  constructor ubhayam
  field
    ukrama  : Prakriya → Prakriya
    u-artha : (P : Prakriya) → artha (phala (ukrama P)) ≡ artha (phala P)
    u-matra : (P : Prakriya) → matra-p (ukrama P) ≤ matra-p P
    u-guru  : (P : Prakriya) → guru (ukrama P) ≤ guru P
open UbhayaAnujna public

utsarga-p : Prakriya → Prakriya
utsarga-p []                    = []
utsarga-p (cara-s ∷ ss)         = cara-s ∷ ss
utsarga-p (mita-s m ∷ ss)       = mita-s m ∷ ss
utsarga-p (dvi-s i ∷ ss)        = dvi-s i ∷ ss
utsarga-p (pratyahara-s k ∷ ss) = pratyahara-s k ∷ ss
utsarga-p (yoga-s i j ∷ ss)     with discreteℕ i j
... | yes _ = dvi-s i ∷ ss
... | no  _ = yoga-s i j ∷ ss

utsarga-artha : (P : Prakriya) → artha (phala (utsarga-p P)) ≡ artha (phala P)
utsarga-artha []                    = refl
utsarga-artha (cara-s ∷ ss)         = refl
utsarga-artha (mita-s m ∷ ss)       = refl
utsarga-artha (dvi-s i ∷ ss)        = refl
utsarga-artha (pratyahara-s k ∷ ss) = refl
utsarga-artha (yoga-s i j ∷ ss)     with discreteℕ i j
... | yes p = funExt (λ n → cong (λ z → artha (anu (sadhana ss) i) n + artha z n)
                                 (cong (anu (sadhana ss)) p))
... | no  _ = refl

utsarga-matra : (P : Prakriya) → matra-p (utsarga-p P) ≤ matra-p P
utsarga-matra []                    = ≤-refl
utsarga-matra (cara-s ∷ ss)         = ≤-refl
utsarga-matra (mita-s m ∷ ss)       = ≤-refl
utsarga-matra (dvi-s i ∷ ss)        = ≤-refl
utsarga-matra (pratyahara-s k ∷ ss) = ≤-refl
utsarga-matra (yoga-s i j ∷ ss)     with discreteℕ i j
... | yes _ = ≤-refl
... | no  _ = ≤-refl

utsarga-guru : (P : Prakriya) → guru (utsarga-p P) ≤ guru P
utsarga-guru []                    = ≤-refl
utsarga-guru (cara-s ∷ ss)         = ≤-refl
utsarga-guru (mita-s m ∷ ss)       = ≤-refl
utsarga-guru (dvi-s i ∷ ss)        = ≤-refl
utsarga-guru (pratyahara-s k ∷ ss) = ≤-refl
utsarga-guru (yoga-s i j ∷ ss)     with discreteℕ i j
... | yes _ = maha-alpa {suc (laghava (anu (sadhana ss) i))} {guru ss}
                       {maha (suc (laghava (anu (sadhana ss) i)
                                 + laghava (anu (sadhana ss) j))) (guru ss)}
              (≤-trans (suc-≤-suc (≤SumLeft {laghava (anu (sadhana ss) i)}
                                            {laghava (anu (sadhana ss) j)}))
                       (maha-vama {suc (laghava (anu (sadhana ss) i) + laghava (anu (sadhana ss) j))} {guru ss}))
              (maha-dakshina {suc (laghava (anu (sadhana ss) i) + laghava (anu (sadhana ss) j))} {guru ss})
... | no  _ = ≤-refl

utsarga-ubhaya : UbhayaAnujna
utsarga-ubhaya = ubhayam utsarga-p utsarga-artha utsarga-matra utsarga-guru

apavada-na-ubhayam : ¬ (Σ UbhayaAnujna (λ U → ukrama U ≡ apavada-p))
apavada-na-ubhayam (U , q) =
  ¬m<m (subst (λ f → guru (f (dvi-s zero ∷ cara-s ∷ []))
                   ≤ guru (dvi-s zero ∷ cara-s ∷ []))
              q (u-guru U (dvi-s zero ∷ cara-s ∷ [])))

record SanujnaKaarya : Type₀ where
  constructor kaaryam
  field
    ksetra : Prakriya → Bool       -- where this कार्य offers to apply
    anujna : Anujna
open SanujnaKaarya public

paraKrama : List SanujnaKaarya → Prakriya → Prakriya
paraKrama []       P = P
paraKrama (k ∷ ks) P with ksetra k P
... | true  = krama (anujna k) P
... | false = paraKrama ks P

para-artha : (ks : List SanujnaKaarya) (P : Prakriya)
           → artha (phala (paraKrama ks P)) ≡ artha (phala P)
para-artha []       P = refl
para-artha (k ∷ ks) P with ksetra k P
... | true  = artha-sthiram (anujna k) P
... | false = para-artha ks P

para-matra : (ks : List SanujnaKaarya) (P : Prakriya)
           → matra-p (paraKrama ks P) ≤ matra-p P
para-matra []       P = ≤-refl
para-matra (k ∷ ks) P with ksetra k P
... | true  = matra-na-vardhate (anujna k) P
... | false = para-matra ks P

para-anujna : List SanujnaKaarya → Anujna
para-anujna ks = anujnata (paraKrama ks) (para-artha ks) (para-matra ks)

sada : Prakriya → Bool
sada _ = true

kApavada kAkriya : SanujnaKaarya
kApavada = kaaryam sada apavada-anujna
kAkriya  = kaaryam sada akriya-anujna

purvam-na-nirnayah :
  ¬ ((P : Prakriya) → paraKrama (kApavada ∷ kAkriya ∷ []) P
                    ≡ paraKrama (kAkriya ∷ kApavada ∷ []) P)
purvam-na-nirnayah h =
  snotz (injSuc (injSuc (cong guru (h (dvi-s zero ∷ cara-s ∷ [])))))

Paribhasa : Type₀
Paribhasa = Prakriya → SanujnaKaarya → SanujnaKaarya → Maybe Bool

nirnaya : Paribhasa → SanujnaKaarya → SanujnaKaarya → Prakriya → Maybe Prakriya
nirnaya M k l P with M P k l
... | nothing     = nothing
... | just true   = just (krama (anujna k) P)
... | just false  = just (krama (anujna l) P)

nirnaya-avaktavye-tusnim :
  (M : Paribhasa) (k l : SanujnaKaarya) (P : Prakriya)
  → M P k l ≡ nothing → nirnaya M k l P ≡ nothing
nirnaya-avaktavye-tusnim M k l P q with M P k l
... | nothing    = refl
... | just true  = ⊥rec (¬just≡nothing q)
... | just false = ⊥rec (¬just≡nothing q)

utsarga-anujna : Anujna
utsarga-anujna = anujnata utsarga-p utsarga-artha utsarga-matra

gurutva-vidhi : Paribhasa
gurutva-vidhi P k l
  with ≤Dec (guru (krama (anujna k) P)) (guru (krama (anujna l) P))
     | ≤Dec (guru (krama (anujna l) P)) (guru (krama (anujna k) P))
... | yes _ | yes _ = nothing       -- equal weight: abstain, do not guess
... | yes _ | no  _ = just true
... | no  _ | yes _ = just false
... | no  _ | no  _ = nothing

vijeta : Paribhasa → SanujnaKaarya → SanujnaKaarya → Prakriya
       → Maybe SanujnaKaarya
vijeta M k l P with M P k l
... | nothing    = nothing
... | just true  = just k
... | just false = just l

vama-krama : Paribhasa → SanujnaKaarya → SanujnaKaarya → SanujnaKaarya
           → Prakriya → Maybe SanujnaKaarya
vama-krama M a b c P with vijeta M a b P
... | nothing = nothing
... | just w  = vijeta M w c P

dakshina-krama : Paribhasa → SanujnaKaarya → SanujnaKaarya → SanujnaKaarya
               → Prakriya → Maybe SanujnaKaarya
dakshina-krama M a b c P with vijeta M b c P
... | nothing = nothing
... | just w  = vijeta M a w P

kApavada' : SanujnaKaarya
kApavada' = kaaryam sada (sanghatita apavada-anujna akriya-anujna)

nirnaya-na-sahayogi :
  ¬ ((M : Paribhasa) (a b c : SanujnaKaarya) (P : Prakriya)
     → vama-krama M a b c P ≡ dakshina-krama M a b c P)
nirnaya-na-sahayogi h =
  ¬just≡nothing
    (h gurutva-vidhi kAkriya kApavada kApavada' (dvi-s zero ∷ cara-s ∷ []))

record Ankita : Type₀ where
  constructor ankitam
  field
    anka   : ℕ
    kaarya : SanujnaKaarya
open Ankita public

cakra : ℕ → ℕ → Bool
cakra zero             (suc zero)       = true
cakra (suc zero)       (suc (suc zero)) = true
cakra (suc (suc zero)) zero             = true
cakra _                _                = false

AnkaVidhi : Type₀
AnkaVidhi = Prakriya → Ankita → Ankita → Bool

cakra-vidhi : AnkaVidhi
cakra-vidhi _ k l = cakra (anka k) (anka l)

jaya : AnkaVidhi → Ankita → Ankita → Prakriya → Ankita
jaya V k l P with V P k l
... | true  = k
... | false = l

vama3 : AnkaVidhi → Ankita → Ankita → Ankita → Prakriya → Ankita
vama3 V a b c P = jaya V (jaya V a b P) c P

dakshina3 : AnkaVidhi → Ankita → Ankita → Ankita → Prakriya → Ankita
dakshina3 V a b c P = jaya V a (jaya V b c P) P

samagram-api-na-sahayogi :
  ¬ ((V : AnkaVidhi) (a b c : Ankita) (P : Prakriya)
     → anka (vama3 V a b c P) ≡ anka (dakshina3 V a b c P))
samagram-api-na-sahayogi h =
  snotz (h cakra-vidhi (ankitam 0 kAkriya) (ankitam 1 kAkriya)
           (ankitam 2 kAkriya) (dvi-s zero ∷ cara-s ∷ []))

sutra-matra : Sutra → ℕ
sutra-matra cara-s           = 1
sutra-matra (mita-s m)       = 1 + m
sutra-matra (yoga-s i j)     = 1 + i + j
sutra-matra (dvi-s i)        = 1 + i
sutra-matra (pratyahara-s k) = 1 + k

matra-akshara : Prakriya → ℕ
matra-akshara []       = 0
matra-akshara (s ∷ ss) = sutra-matra s + matra-akshara ss

anuvrtti-akshara : (P : Prakriya)
                 → matra-akshara (anuvrtti P) ≡ suc (matra-akshara P)
anuvrtti-akshara P = refl

apavada-akshara-vardhate :
  ¬ ((P : Prakriya) → matra-akshara (apavada-p P) ≡ matra-akshara P)
apavada-akshara-vardhate h =
  snotz (injSuc (injSuc (injSuc (injSuc
    (h (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ []))))))

record AksharaAnujna : Type₀ where
  constructor aksharam
  field
    akrama   : Prakriya → Prakriya
    a-artha  : (P : Prakriya) → artha (phala (akrama P)) ≡ artha (phala P)
    a-matra  : (P : Prakriya) → matra-akshara (akrama P) ≤ matra-akshara P
open AksharaAnujna public

apavada-na-aksharanujnatam : ¬ (Σ AksharaAnujna (λ A → akrama A ≡ apavada-p))
apavada-na-aksharanujnatam (A , q) =
  ¬m<m
    (subst (λ f → matra-akshara (f (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ []))
                ≤ matra-akshara (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ []))
           q (a-matra A (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ [])))

utsarga-akshara : (P : Prakriya) → matra-akshara (utsarga-p P) ≤ matra-akshara P
utsarga-akshara []                    = ≤-refl
utsarga-akshara (cara-s ∷ ss)         = ≤-refl
utsarga-akshara (mita-s m ∷ ss)       = ≤-refl
utsarga-akshara (dvi-s i ∷ ss)        = ≤-refl
utsarga-akshara (pratyahara-s k ∷ ss) = ≤-refl
utsarga-akshara (yoga-s i j ∷ ss)     with discreteℕ i j
... | yes p = subst (λ z → ((1 + i) + matra-akshara ss)
                         ≤ (((1 + i) + z) + matra-akshara ss))
                    p (≤-+k {k = matra-akshara ss} (≤SumLeft {1 + i} {i}))
... | no  _ = ≤-refl

record TriAnujna : Type₀ where
  constructor trayam
  field
    tkrama   : Prakriya → Prakriya
    t-artha  : (P : Prakriya) → artha (phala (tkrama P)) ≡ artha (phala P)
    t-sutra  : (P : Prakriya) → matra-p (tkrama P) ≤ matra-p P
    t-matra  : (P : Prakriya) → matra-akshara (tkrama P) ≤ matra-akshara P
    t-guru   : (P : Prakriya) → guru (tkrama P) ≤ guru P
open TriAnujna public

utsarga-trayam : TriAnujna
utsarga-trayam = trayam utsarga-p utsarga-artha utsarga-matra
                        utsarga-akshara utsarga-guru

apavada-na-trayam : ¬ (Σ TriAnujna (λ T → tkrama T ≡ apavada-p))
apavada-na-trayam (T , q) =
  ¬m<m (subst (λ f → matra-akshara (f (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ []))
                   ≤ matra-akshara (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ []))
              q (t-matra T (dvi-s (suc zero) ∷ cara-s ∷ cara-s ∷ [])))

sarvam-kramasya-samam :
  {ℓ : Level} {X : Type ℓ} (g : (Prakriya → Prakriya) → X)
  → g (krama akriya-anujna)
  ≡ g (krama (sanghatita akriya-anujna akriya-anujna))
sarvam-kramasya-samam g = refl

data Nimitta : Type₀ where
  sarvatra : Nimitta
  dviyoge  : Nimitta
  ayoge    : Nimitta
  ubhau    : Nimitta → Nimitta → Nimitta   -- both at once (§70)
  anyatara : Nimitta → Nimitta → Nimitta   -- either one (§73)

nimitta-matra : Nimitta → ℕ
nimitta-matra sarvatra = 0
nimitta-matra dviyoge  = 1
nimitta-matra ayoge    = 1
nimitta-matra (ubhau c d)    = nimitta-matra c + nimitta-matra d
nimitta-matra (anyatara c d) = nimitta-matra c + nimitta-matra d

sthiti : Nimitta → Prakriya → Bool
sthiti sarvatra _                  = true
sthiti dviyoge  (dvi-s _ ∷ _)      = true
sthiti dviyoge  _                  = false
sthiti ayoge    (yoga-s _ _ ∷ _)   = true
sthiti ayoge    _                  = false
sthiti (ubhau c d) P               = sthiti c P and sthiti d P
sthiti (anyatara c d) P            = sthiti c P or sthiti d P

data Vidhi : Type₀ where
  akriya-v  : Vidhi                  -- अक्रिया, do nothing
  apavada-v : Vidhi                  -- dvi-s i  ↦  yoga-s i i
  utsarga-v : Vidhi                  -- yoga-s i i  ↦  dvi-s i
  krama-v   : Vidhi → Vidhi → Vidhi  -- one, then the other
  yadi      : Nimitta → Vidhi → Vidhi → Vidhi   -- the CARVED rule (§60)

vidhi-matra : Vidhi → ℕ
vidhi-matra akriya-v      = 1
vidhi-matra apavada-v     = 1
vidhi-matra utsarga-v     = 1
vidhi-matra (krama-v a b) = suc (vidhi-matra a + vidhi-matra b)
vidhi-matra (yadi c a b)  = suc (nimitta-matra c + vidhi-matra a + vidhi-matra b)

artha-v : Vidhi → (Prakriya → Prakriya)
artha-v akriya-v      = λ P → P
artha-v apavada-v     = apavada-p
artha-v utsarga-v     = utsarga-p
artha-v (krama-v a b) = λ P → artha-v a (artha-v b P)
artha-v (yadi c a b)  = λ P → if sthiti c P then artha-v a P else artha-v b P

vidhi-tulya : artha-v akriya-v ≡ artha-v (krama-v akriya-v akriya-v)
vidhi-tulya = refl

sarvam-vidher-arthasya-samam :
  {ℓ : Level} {X : Type ℓ} (g : (Prakriya → Prakriya) → X)
  → g (artha-v akriya-v) ≡ g (artha-v (krama-v akriya-v akriya-v))
sarvam-vidher-arthasya-samam g = cong g vidhi-tulya

vidhi-matra-bheda :
  ¬ (vidhi-matra akriya-v ≡ vidhi-matra (krama-v akriya-v akriya-v))
vidhi-matra-bheda p = znots (injSuc p)

vidhi-matra-na-arthasya :
  ¬ (Σ ((Prakriya → Prakriya) → ℕ)
       (λ f → (v : Vidhi) → f (artha-v v) ≡ vidhi-matra v))
vidhi-matra-na-arthasya (f , h) =
  znots (injSuc (sym (h akriya-v) ∙ h (krama-v akriya-v akriya-v)))

sthanika : (P : Prakriya)
  → artha-v (yadi dviyoge apavada-v akriya-v) P ≡ artha-v apavada-v P
sthanika []                    = refl
sthanika (cara-s ∷ ss)         = refl
sthanika (mita-s m ∷ ss)       = refl
sthanika (yoga-s i j ∷ ss)     = refl
sthanika (dvi-s i ∷ ss)        = refl
sthanika (pratyahara-s k ∷ ss) = refl

sankshepa : artha-v (yadi dviyoge apavada-v akriya-v) ≡ artha-v apavada-v
sankshepa = funExt sthanika

laghutaram : vidhi-matra apavada-v < vidhi-matra (yadi dviyoge apavada-v akriya-v)
laghutaram = 2 , refl

Svavisaya : Nimitta → Vidhi → Type₀
Svavisaya c v = (P : Prakriya) → sthiti c P ≡ false → artha-v v P ≡ P

carvana-lemma :
  (c : Nimitta) (v : Vidhi) → Svavisaya c v
  → (P : Prakriya) (b : Bool) → sthiti c P ≡ b
  → (if b then artha-v v P else artha-v akriya-v P) ≡ artha-v v P
carvana-lemma c v hyp P true  e = refl
carvana-lemma c v hyp P false e = sym (hyp P e)

svavisaye-carvanam-vyartham :
  (c : Nimitta) (v : Vidhi) → Svavisaya c v
  → artha-v (yadi c v akriya-v) ≡ artha-v v
svavisaye-carvanam-vyartham c v hyp =
  funExt (λ P → carvana-lemma c v hyp P (sthiti c P) refl)

carvanam-dirgham :
  (c : Nimitta) (v : Vidhi)
  → vidhi-matra v < vidhi-matra (yadi c v akriya-v)
carvanam-dirgham c v =
  suc-≤-suc (≤-trans (≤SumRight {vidhi-matra v} {nimitta-matra c})
                     (≤SumLeft {nimitta-matra c + vidhi-matra v} {1}))

apavada-svavisaya : Svavisaya dviyoge apavada-v
apavada-svavisaya []                    e = refl
apavada-svavisaya (cara-s ∷ ss)         e = refl
apavada-svavisaya (mita-s m ∷ ss)       e = refl
apavada-svavisaya (yoga-s i j ∷ ss)     e = refl
apavada-svavisaya (dvi-s i ∷ ss)        e = ⊥rec (true≢false e)
apavada-svavisaya (pratyahara-s k ∷ ss) e = refl

Nishkriya : Nimitta → (Prakriya → Prakriya) → Type₀
Nishkriya c f = (P : Prakriya) → sthiti c P ≡ false → f P ≡ P

svavisayat-nishkriyam :
  (c : Nimitta) (w : Vidhi)
  → Σ Vidhi (λ v → (artha-v v ≡ artha-v w) × Svavisaya c v)
  → Nishkriya c (artha-v w)
svavisayat-nishkriyam c w (v , p , sv) P e =
  sym (funExt⁻ p P) ∙ sv P e

nishkriyat-svavisayam :
  (c : Nimitta) (w : Vidhi)
  → Nishkriya c (artha-v w)
  → Σ Vidhi (λ v → (artha-v v ≡ artha-v w) × Svavisaya c v)
nishkriyat-svavisayam c w hyp = w , refl , hyp

ubhayatah : Vidhi
ubhayatah = yadi dviyoge apavada-v utsarga-v

ubhayatah-na-nishkriyam : ¬ (Nishkriya dviyoge (artha-v ubhayatah))
ubhayatah-na-nishkriyam h =
  snotz (injSuc (injSuc
    (cong guru (sym (h (yoga-s zero zero ∷ cara-s ∷ []) refl)))))

ubhayatah-na-svavisayam :
  ¬ (Σ Vidhi (λ v → (artha-v v ≡ artha-v ubhayatah) × Svavisaya dviyoge v))
ubhayatah-na-svavisayam s =
  ubhayatah-na-nishkriyam (svavisayat-nishkriyam dviyoge ubhayatah s)

sarvatra-sarvam-svavisayam : (v : Vidhi) → Svavisaya sarvatra v
sarvatra-sarvam-svavisayam v P e = ⊥rec (true≢false e)

ubhayatah-na-ayoge : ¬ (Nishkriya ayoge (artha-v ubhayatah))
ubhayatah-na-ayoge h =
  snotz (injSuc (injSuc
    (cong guru (h (dvi-s zero ∷ cara-s ∷ []) refl))))

_nyunam_ : Nimitta → Nimitta → Type₀
c nyunam c' = (P : Prakriya) → sthiti c P ≡ true → sthiti c' P ≡ true

notTrue→False : (b : Bool) → ¬ (b ≡ true) → b ≡ false
notTrue→False true  h = ⊥rec (h refl)
notTrue→False false h = refl

nishkriya-vardhate :
  (c c' : Nimitta) → c nyunam c' → (f : Prakriya → Prakriya)
  → Nishkriya c f → Nishkriya c' f
nishkriya-vardhate c c' sub f hyp P e =
  hyp P (notTrue→False (sthiti c P)
          (λ t → true≢false (sym (sub P t) ∙ e)))

dviyoge-nyunam-sarvatra : dviyoge nyunam sarvatra
dviyoge-nyunam-sarvatra P _ = refl

sarvatra-alpiyah : nimitta-matra sarvatra ≤ nimitta-matra dviyoge
sarvatra-alpiyah = 1 , refl

sarvatra-na-carvati : (a b : Vidhi) → artha-v (yadi sarvatra a b) ≡ artha-v a
sarvatra-na-carvati a b = funExt (λ P → refl)

and-true-vamam : (b c : Bool) → (b and c) ≡ true → b ≡ true
and-true-vamam true  c e = refl
and-true-vamam false c e = ⊥rec (true≢false (sym e))

ubhau-mahiyah : (c d : Nimitta) → nimitta-matra c ≤ nimitta-matra (ubhau c d)
ubhau-mahiyah c d = ≤SumLeft {nimitta-matra c} {nimitta-matra d}

ubhau-nyunam : (c d : Nimitta) → (ubhau c d) nyunam c
ubhau-nyunam c d P e = and-true-vamam (sthiti c P) (sthiti d P) e

ubhau-gurutaram :
  (c d : Nimitta) (f : Prakriya → Prakriya)
  → Nishkriya (ubhau c d) f → Nishkriya c f
ubhau-gurutaram c d f = nishkriya-vardhate (ubhau c d) c (ubhau-nyunam c d) f

sarvatra-ekam-sthiti : (c : Nimitta) (P : Prakriya)
                     → sthiti (ubhau sarvatra c) P ≡ sthiti c P
sarvatra-ekam-sthiti c P = refl

sarvatra-ekam-matra : (c : Nimitta)
                    → nimitta-matra (ubhau sarvatra c) ≡ nimitta-matra c
sarvatra-ekam-matra c = refl

or-true-vamam : (b c : Bool) → b ≡ true → (b or c) ≡ true
or-true-vamam true  c e = refl
or-true-vamam false c e = ⊥rec (true≢false (sym e))

anyatara-adhikam : (c d : Nimitta) → c nyunam (anyatara c d)
anyatara-adhikam c d P e = or-true-vamam (sthiti c P) (sthiti d P) e

nishkriya-anyatare :
  (c d : Nimitta) (f : Prakriya → Prakriya)
  → Nishkriya c f → Nishkriya (anyatara c d) f
nishkriya-anyatare c d f =
  nishkriya-vardhate c (anyatara c d) (anyatara-adhikam c d) f

anyatara-sarvatra-sthiti :
  (c : Nimitta) (P : Prakriya)
  → sthiti (anyatara sarvatra c) P ≡ sthiti sarvatra P
anyatara-sarvatra-sthiti c P = refl

anyatara-sarvatra-samam : sthiti (anyatara sarvatra dviyoge) ≡ sthiti sarvatra
anyatara-sarvatra-samam = funExt (anyatara-sarvatra-sthiti dviyoge)

matra-na-sthiteh :
  ¬ (Σ ((Prakriya → Bool) → ℕ)
       (λ g → (c : Nimitta) → g (sthiti c) ≡ nimitta-matra c))
matra-na-sthiteh (g , h) =
  znots (sym (h sarvatra)
       ∙ cong g (sym anyatara-sarvatra-samam)
       ∙ h (anyatara sarvatra dviyoge))

sarva-visayasya-samam :
  {ℓ : Level} {X : Type ℓ} (g : (Prakriya → Bool) → X)
  → g (sthiti sarvatra) ≡ g (sthiti (anyatara sarvatra dviyoge))
sarva-visayasya-samam g = cong g (sym anyatara-sarvatra-samam)

nimitta-akshara : Nimitta → ℕ
nimitta-akshara sarvatra       = 1
nimitta-akshara dviyoge        = 1
nimitta-akshara ayoge          = 1
nimitta-akshara (ubhau c d)    = suc (nimitta-akshara c + nimitta-akshara d)
nimitta-akshara (anyatara c d) = suc (nimitta-akshara c + nimitta-akshara d)

sarvatra-ubhau-matra : nimitta-matra (ubhau sarvatra sarvatra)
                     ≡ nimitta-matra sarvatra
sarvatra-ubhau-matra = refl

matra-na-vakyasya :
  ¬ (Σ (ℕ → ℕ) (λ f → (c : Nimitta) → f (nimitta-matra c) ≡ nimitta-akshara c))
matra-na-vakyasya (f , h) =
  znots (injSuc (sym (h sarvatra) ∙ h (ubhau sarvatra sarvatra)))

sutrat-na-aksharam :
  ¬ (Σ (ℕ → ℕ) (λ f → (P : Prakriya) → f (matra-p P) ≡ matra-akshara P))
sutrat-na-aksharam (f , h) =
  znots (injSuc (sym (h (cara-s ∷ [])) ∙ h (mita-s 5 ∷ [])))

aksharat-na-gurutvam :
  ¬ (Σ (ℕ → ℕ) (λ f → (P : Prakriya) → f (matra-akshara P) ≡ guru P))
aksharat-na-gurutvam (f , h) =
  snotz (injSuc (sym (h (dvi-s zero ∷ cara-s ∷ []))
               ∙ h (cara-s ∷ cara-s ∷ [])))

gurutvat-na-aksharam :
  ¬ (Σ (ℕ → ℕ) (λ f → (P : Prakriya) → f (guru P) ≡ matra-akshara P))
gurutvat-na-aksharam (f , h) =
  znots (injSuc (sym (h (cara-s ∷ [])) ∙ h (mita-s 5 ∷ [])))

avrtti : (i : ℕ) (ss : Prakriya)
       → utsarga-p (apavada-p (dvi-s i ∷ ss)) ≡ dvi-s i ∷ ss
avrtti i ss with discreteℕ i i
... | yes _  = refl
... | no ¬p  = ⊥rec (¬p refl)

avrtti-akriyavat : (i : ℕ) (ss : Prakriya)
  → artha-v (krama-v utsarga-v apavada-v) (dvi-s i ∷ ss)
  ≡ artha-v akriya-v (dvi-s i ∷ ss)
avrtti-akriyavat i ss = avrtti i ss

avrtti-mulyam :
  ¬ (vidhi-matra (krama-v utsarga-v apavada-v) ≡ vidhi-matra akriya-v)
avrtti-mulyam p = snotz (injSuc p)

