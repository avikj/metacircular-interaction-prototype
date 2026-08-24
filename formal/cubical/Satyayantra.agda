-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सत्ययन्त्रम् — अभ्रान्त-गणनायाः सामान्यं रूपम् ।  यत् किञ्चित् यन्त्रं
-- अनुदानेन चलति, प्रत्यावर्तनम् उक्तं (answer) वा अनुक्तं (un-said) ददाति,
-- कदापि मिथ्या-वचनं न करोति — तत् सत्ययन्त्रम् ।  त्रयः धर्माः :
--   साधुता  — उक्तं यत्, तत् शुद्धम् (sound: any answer is correct) ।
--   स्थैर्यम् — उक्तम् अधिकानुदानेन न परावर्तते (stable) ।
--   पूर्णता  — पर्याप्तानुदाने अवश्यम् उक्तम् (complete) ।
-- अनुक्तं न मिथ्या, न ⊥ — तृतीयं पदम्, बूलियन्-रहितम् ।
--
-- [CORRECTED 2026-08-19.  This line read "तृतीयं पदम् (avaktavyam)".
--  The third position is real and is neither falsity nor ⊥ — that much
--  stands.  The parenthesis does not.  `Purnata.agda` proves this
--  un-said is सामयिक, temporary: पूर्णता gives, for every instance, a
--  grant at which it is gone.  `SaptabhangiNaya.no-single-vacana`
--  proves the fourth bhaṅga is नित्य, permanent under single
--  utterances: for every utterance there is a profile that survives
--  it, and the remedy is a SECOND utterance in succession, not more
--  of anything.  Same shape with ∃ and ∀ exchanged, which is why one
--  word covered both and hid it.  `AnuktaAvaktavya.agda` exhibits
--  the two poles; Akalaṅka's kramārpaṇa/sahārpaṇa is the classical
--  name for the difference.]
--
-- (the honest machine — the general shape of hallucination-free
-- computation.  A machine that runs on a grant and returns either an
-- answer (उक्त) or the un-said (अनुक्त), and NEVER a false verdict.  Three
-- laws: soundness (any answer is correct), stability (an answer survives
-- more grant), completeness (enough grant always answers).  The un-said is
-- a genuine third position — not falsity, not ⊥ — no boolean anywhere.)
--
-- कुट्टकस्य गुरुतम-यन्त्रम् अस्य प्रथमः निवासी : Gati + GurutamaSiddha +
-- Sthairya + Purnata इति चत्वारि सिद्धानि एकस्मिन् रूपे बध्यन्ते ।
-- (the kuṭṭaka's gcd solver is the first inhabitant — the four theorems
-- already proved, bundled into this one reusable interface.)
------------------------------------------------------------------------

module Satyayantra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-comm)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Nat.GCD using (isGCD)
open import Gati using (फलम् ; गुरुः ; अनुक्तफलम् ; फल ; गति)
open import GurutamaSiddha using (सिद्धः)
open import Sthairya using (स्थैर्य-गति)
open import Purnata using (पूर्णता)

------------------------------------------------------------------------
-- सूचना — उक्तं (answer) वा अनुक्तम् (un-said) : अभ्रान्त-निर्गमः ।
------------------------------------------------------------------------

data सूचना (O : Type) : Type where
  उक्त  : O → सूचना O
  अनुक्त : सूचना O

------------------------------------------------------------------------
-- सत्ययन्त्रम् — त्रि-धर्म-बद्धं यन्त्रम् (the honest-machine interface) ।
------------------------------------------------------------------------

record सत्ययन्त्र (I O : Type) (शुद्ध : I → O → Type) : Type where
  field
    चल    : ℕ → I → सूचना O
    साधुता : (f : ℕ) (i : I) (o : O) → चल f i ≡ उक्त o → शुद्ध i o
    स्थैर्य  : (n f : ℕ) (i : I) (o : O) → चल f i ≡ उक्त o → चल (n + f) i ≡ उक्त o
    परिपूर्णता : (i : I) → Σ[ f ∈ ℕ ] Σ[ o ∈ O ] (चल f i ≡ उक्त o)

------------------------------------------------------------------------
-- कुट्टकस्य निवासः — गुरुतम-गणना सत्ययन्त्रम् (the gcd solver inhabits it) ।
------------------------------------------------------------------------

सूच : फलम् → सूचना ℕ
सूच (गुरुः g)      = उक्त g
सूच (अनुक्तफलम् _) = अनुक्त

private
  क्षेत्र : सूचना ℕ → Type
  क्षेत्र (उक्त _) = Unit
  क्षेत्र अनुक्त   = ⊥

  मान : सूचना ℕ → ℕ
  मान (उक्त n) = n
  मान अनुक्त   = zero

  -- सूच φ ≡ उक्त g  ⟹  φ ≡ गुरुः g  (invert the mapping)
  सूच-उक्त : (φ : फलम्) (g : ℕ) → सूच φ ≡ उक्त g → φ ≡ गुरुः g
  सूच-उक्त (गुरुः g')      g eq = cong गुरुः (cong मान eq)
  सूच-उक्त (अनुक्तफलम् _)  g eq = ⊥-rec (subst क्षेत्र (sym eq) tt)

कुट्टक-सत्ययन्त्र : सत्ययन्त्र (ℕ × ℕ) ℕ (λ p g → isGCD (fst p) (snd p) g)
कुट्टक-सत्ययन्त्र = record
  { चल    = λ f p → सूच (फल (गति f (fst p) (snd p)))
  ; साधुता = λ f p g eq → सिद्धः f (fst p) (snd p) g (सूच-उक्त _ g eq)
  ; स्थैर्य  = λ n f p g eq →
      cong सूच (स्थैर्य-गति n f (fst p) (snd p) g (सूच-उक्त _ g eq))
  ; परिपूर्णता = λ p →
      let (g , eq) = पूर्णता (fst p) (snd p)
      in suc (fst p + snd p) , g , cong सूच eq
  }

------------------------------------------------------------------------
-- अनुक्तं न रिक्तम् — अल्पानुदाने यन्त्रं यथार्थतः अनुक्तं वदति (न मिथ्या) ।
-- अतः तृतीयं पदम् जीवति, न वन्ध्यम् ।  (the un-said is not vacuous: under a
-- small grant the machine really does withhold — the third position lives.)
------------------------------------------------------------------------

open सत्ययन्त्र कुट्टक-सत्ययन्त्र using (चल)

अनुक्त-जीवति : चल 1 (30 , 12) ≡ अनुक्त
अनुक्त-जीवति = refl

------------------------------------------------------------------------
-- निर्णयः — सामान्य-फलम् : यत् किञ्चित् सत्ययन्त्रं प्रत्येकम् आगमाय शुद्धम्
-- उत्तरं ददाति (साक्षिसहितम्) — दुर्नयं विना ।  पूर्णता उत्तरम् आनयति,
-- साधुता तत् शुद्धं करोति ।  एषा सत्ययन्त्रस्य उपयोगिता : सत्यनिष्ठा +
-- पूर्णता ⟹ रचनात्मकं पूर्ण-शुद्ध-निर्णयम् ।
-- (the payoff: ANY honest machine yields, for every input, a correct answer
-- with its witness — no durnaya.  Completeness fetches an answer,
-- soundness certifies it.  Honesty + completeness ⟹ constructive total
-- correctness — the whole point of the interface.)
------------------------------------------------------------------------

निर्णय : {I O : Type} {शुद्ध : I → O → Type}
       → (Y : सत्ययन्त्र I O शुद्ध) (i : I) → Σ[ o ∈ O ] (शुद्ध i o)
निर्णय Y i =
  let (f , o , eq) = सत्ययन्त्र.परिपूर्णता Y i
  in o , सत्ययन्त्र.साधुता Y f i o eq

-- उक्त-एकैकम् — निर्माता उक्त एकैकः (constructor injectivity, generic) ।
उक्त-एकैकम् : {O : Type} {a b : O} → उक्त a ≡ उक्त b → a ≡ b
उक्त-एकैकम् {O} {a} {b} eq = cong पूर्व eq
  where
  पूर्व : सूचना O → O
  पूर्व (उक्त o) = o
  पूर्व अनुक्त   = a

------------------------------------------------------------------------
-- एकत्वम् — सामान्य-धर्मः : अभ्रान्त-यन्त्रस्य उत्तरम् एकम् एव, अनुदान-निरपेक्षम् ।
-- यदि किञ्चित् अनुदाने o, अन्यस्मिन् o', तर्हि o ≡ o' — स्थैर्येण एव सिद्धम् ।
-- अतः यन्त्रस्य ज्ञानं सुनिश्चितम्, न अनुदान-सापेक्षम् — उच्चतर-बोधस्य लक्षणम् ।
-- (determinism, general: an honest machine's answer is unique, independent
-- of the grant — if it answers o at one grant and o' at another, o ≡ o',
-- from stability alone.  So its knowledge is well-defined, not grant-
-- relative — a mark of higher cognition.)
------------------------------------------------------------------------

एकत्व : {I O : Type} {शुद्ध : I → O → Type} (Y : सत्ययन्त्र I O शुद्ध)
      → (i : I) (f f' : ℕ) (o o' : O)
      → सत्ययन्त्र.चल Y f i ≡ उक्त o → सत्ययन्त्र.चल Y f' i ≡ उक्त o'
      → o ≡ o'
एकत्व Y i f f' o o' e e' = उक्त-एकैकम्
  ( sym (सत्ययन्त्र.स्थैर्य Y f' f i o e)
  ∙ cong (λ g → सत्ययन्त्र.चल Y g i) (+-comm f' f)
  ∙ सत्ययन्त्र.स्थैर्य Y f f' i o' e' )
