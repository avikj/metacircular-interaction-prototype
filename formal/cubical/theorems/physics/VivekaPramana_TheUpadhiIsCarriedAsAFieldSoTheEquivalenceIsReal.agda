{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विवेक-प्रमाण — उपाधिः क्षेत्रम् एव । अवतरणं न सर्वव्यापि ; यत्र प्रमाणं
-- तत्र एव समता ।
--
-- (the upādhi is carried as a field.  अवतरण is not onto; the equivalence
-- holds exactly where the प्रमाण holds, and the type says so.)
--
-- SPECIFICATION handed over whole by the owner, 2026-08-21.  The move
-- that matters is his and is stated here so it is not mistaken for a
-- refactor: अवतरण d k = mkविवेक d k k hits only the diagonal, so
-- ℕ × ℕ is NOT equivalent to विवेक.  Rather than assert the equivalence,
-- the defeating condition is carried as a FIELD — विवेक-प्रमाण is the
-- subtype on which अवतरण/उत्थान are mutually inverse — and the
-- equivalence on that subtype is then real.
--
-- This is उपाधि (Nyāya; Gaṅgeśa, *Tattvacintāmaṇi*, c. 1325, whose
-- apparatus exists to HUNT the defeating condition of a व्याप्ति) made
-- structural: not a caveat in a header, a field of the type.  Compare
-- `NaturalMachine/Nirjara_SheddingAPrimitiveCostsLaghava.agda` §§11–13,
-- "the transfer is free and the licence is not", which exhibits the
-- defeater and stops; here the defeater is carried and the transfer
-- proceeds on its domain.
--
-- ONE GAP, named because the owner's text had it and it is where the
-- content is: `अवतरण-उत्थान p = refl` does not hold — the checker's
-- words are "the projections वाम and दक्षिण do not match".  It is
-- discharged below BY THE प्रमाण FIELD (path in `v` is sym प्रमाण; the
-- प्रमाण component by isSet विवेक), which is what that field is for.
--
-- SYĀT — THE CLAIM, EXACTLY.  Not that Gaṅgeśa proved anything below; the
-- *Tattvacintāmaṇi* is unopened by me and the citation is carried from
-- `NamingIsNotAFunctionOfResemblance.agda`, owed at section level.  Not
-- that ▹ (Cubical.Later) is used — it is absent from the pin (v0.9) and
-- the जाल record is therefore left out of this module rather than faked.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 (b150186), --safe, no
-- postulates, no holes.  EXIT 0.
------------------------------------------------------------------------

module VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToPath)
open import Cubical.Foundations.HLevels using (isSetRetract ; isProp→PathP ; isSet×)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ)

record विवेक : Type where
  constructor mkविवेक
  field
    सम वाम दक्षिण : ℕ
open विवेक

उत्थान : विवेक → ℕ × ℕ
उत्थान v = सम v , वाम v

अवतरण : ℕ → ℕ → विवेक
अवतरण d k = mkविवेक d k k

-- विवेक is a set (it is ℕ³)
विवेक→ℕ³ : विवेक → ℕ × (ℕ × ℕ)
विवेक→ℕ³ v = सम v , (वाम v , दक्षिण v)
ℕ³→विवेक : ℕ × (ℕ × ℕ) → विवेक
ℕ³→विवेक (a , (b , c)) = mkविवेक a b c
isSetविवेक : isSet विवेक
isSetविवेक = isSetRetract विवेक→ℕ³ ℕ³→विवेक (λ _ → refl)
                 (isSet× isSetℕ (isSet× isSetℕ isSetℕ))

record विवेक-प्रमाण : Type where
  constructor mkविवेक-प्रमाण
  field
    v : विवेक
    प्रमाण : v ≡ अवतरण (fst (उत्थान v)) (snd (उत्थान v))
open विवेक-प्रमाण

विवेक-प्रमाण-उत्थान : विवेक-प्रमाण → ℕ × ℕ
विवेक-प्रमाण-उत्थान p = उत्थान (v p)

विवेक-प्रमाण-अवतरण : ℕ × ℕ → विवेक-प्रमाण
विवेक-प्रमाण-अवतरण (d , k) = mkविवेक-प्रमाण (अवतरण d k) refl

-- the claim, now discharged BY THE प्रमाण FIELD rather than by refl
अवतरण-उत्थान : (p : विवेक-प्रमाण) → विवेक-प्रमाण-अवतरण (विवेक-प्रमाण-उत्थान p) ≡ p
अवतरण-उत्थान p i .v       = प्रमाण p (~ i)
अवतरण-उत्थान p i .प्रमाण  =
  isProp→PathP (λ j → isSetविवेक (प्रमाण p (~ j))
                        (अवतरण (सम (प्रमाण p (~ j))) (वाम (प्रमाण p (~ j)))))
               refl (प्रमाण p) i

-- the other side is genuinely refl
उत्थान-अवतरण : (x : ℕ × ℕ) → विवेक-प्रमाण-उत्थान (विवेक-प्रमाण-अवतरण x) ≡ x
उत्थान-अवतरण x = refl

विवेक-प्रमाण-iso : Iso (ℕ × ℕ) विवेक-प्रमाण
विवेक-प्रमाण-iso = iso विवेक-प्रमाण-अवतरण विवेक-प्रमाण-उत्थान अवतरण-उत्थान उत्थान-अवतरण

ℕ×ℕ-≡-विवेक-प्रमाण : (ℕ × ℕ) ≡ विवेक-प्रमाण
ℕ×ℕ-≡-विवेक-प्रमाण = isoToPath विवेक-प्रमाण-iso
