{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सकलादेशः — एकेन वचनेन न उच्यते, अर्थस्तु सङ्कलितः ।
--
-- (the total statement: no single utterance denotes it — and yet its
--  content folds.)
--
-- TEXT AND DATE.  सकलादेश / विकलादेश — the total statement against the
-- partial one — is the pair Malliṣeṇa uses in the स्याद्वादमञ्जरी, 1292 CE,
-- glossing Hemacandra; it is older in the Akalaṅka commentarial line
-- (Vidyānandi, अष्टसहस्री, c. 9th c.).  सकलादेश is the utterance made
-- from प्रमाण, grasping the whole at once; विकलादेश is made from a नय, one
-- aspect at a time.  The mode distinction it rests on — क्रमार्पण against
-- सहार्पण, in succession against simultaneously — is AKALAṄKA's,
-- लघीयस्त्रयम् / अष्टशती, c. 720–780 CE.  अवक्तव्यम् as the fourth position
-- is canonical: भगवती-सूत्र (व्याख्याप्रज्ञप्ति), oldest strata pre-Common-Era,
-- redacted at Valabhī c. 5th c. CE; fixed at seven with स्यात् prefixed
-- throughout by Samantabhadra, आप्तमीमांसा, c. 6th c. CE.
--
-- WHAT IS AND IS NOT CLAIMED OF THEM.  None of them proved anything below.
-- What is claimed is that the distinction the theorems turn on — whether ONE
-- utterance can denote what SEVERAL express in succession — is theirs, is the
-- reason अवक्तव्यम् is a position rather than a gap, and is stated in the
-- sources as a claim about expression and not about truth.  No critical
-- edition was opened for this module; the attributions are carried from this
-- repository's own notes and from secondary literature, and are शब्द at that
-- grade.
--
-- WHY THIS MODULE EXISTS, AND WHAT IT CORRECTS.
--
-- `SaptabhangiNaya` fixes THREE standpoints and SIX utterances, and proves
-- `no-single-vacana` by listing all six.  `AvaktavyaDoesNotFactor`
-- turns that list into the shape it really has:
--
--     ¬ Σ[ v ] (∀ φ → denotes v φ ≡ joint φ)
--
-- — a factorisation obstruction.  Both are at n = 3 standpoints and a joint
-- content of TWO conjuncts, and both proceed by exhausting the utterances.
--
-- §3 below proves it for an ARBITRARY standpoint type and an ARBITRARY
-- finite demand, with no case analysis over utterances, no decidable
-- equality on standpoints, and no finiteness: two constant profiles do the
-- whole job.  So the obstruction is not an artefact of three standpoints.
--
-- AND IT WITHDRAWS A CLAIM MADE IN CONVERSATION, WHICH IS THE MORE USEFUL
-- HALF.  It was put to the owner that सहार्पण is "irreducibly n-ary" — that
-- the total statement over n standpoints cannot be built from binary steps —
-- on the ground that `Arpitanarpita_….सह-असङ्गतिः-ऊर्ध्वम्` proves सहार्पणम्
-- non-associative.  That inference conflates two different objects:
--
--   · the CONTENT demanded by the total statement, which is a conjunction
--     over the demand.  §2: it FOLDS.  `and` is associative, so the n-ary
--     content is exactly the iterated binary one, and `क्रम-सङ्कलनम्` holds
--     by `refl`.  The claim was wrong here.
--   · the OPERATION combining seven-fold POSITIONS, `सह-योग` / `सहार्पणम्`,
--     which `SaptabhangiSamyoga_….सह-असङ्गतिः` and `Arpitanarpita_….सह-
--     असङ्गतिः-ऊर्ध्वम्` prove non-associative on labels and on records
--     alike.  There the n-ary operation genuinely is not determined by the
--     binary one.  The claim was right here, about a different thing.
--
-- Content folds; the composition of positions does not.  Reading the second
-- as licensing the first is exactly the collapse this corpus exists to
-- refuse — बहून् एकनाम्ना गृह्णाति — so it is written out rather than
-- quietly dropped (अहिंसा-सूत्र-विस्तारः §६: लिखितो दोषो जीवति).
--
-- WHAT IS PROVED.  --cubical --safe, no postulates, no holes.
--
--   क्रम-सङ्कलनम्      succession expresses the demand, by construction.
--   सर्व-सत्ये-मिथ्या   a demand with any negative entry is false at the
--                     all-affirming profile.
--   सर्व-मिथ्या-मिथ्या  a demand with any positive entry is false at the
--                     all-denying profile.
--   एक-वचनेन-न        NO SINGLE UTTERANCE denotes a mixed demand — any
--                     standpoint type, any length.  Two profiles, no
--                     exhaustion, no decidability.
--   सकलादेशो-न-सङ्गच्छते  the same as a factorisation obstruction.
--   रिक्तं-तन्तुजालम्    and as the statement that the fibre of `denotes`
--                     over the demanded content is EMPTY.
--
-- THE LAST ONE IS THE POINT, and it is what places अवक्तव्यम् on the scale
-- this corpus has been assembling.  A map's fibre being CONTRACTIBLE is
-- `Loss.Carrier`: nothing lost, the datum rides free.  A fibre with
-- MORE than one point is नष्टि: the "which" is destroyed (§४), priced when
-- the fibre is finite and decidable, अप्रतिकार्य when truncated.  A fibre
-- that is EMPTY is neither: nothing was lost, because nothing was ever
-- there to lose — the content simply is not in the image of single
-- utterance.  That is अवक्तव्यम्, and it is why the tradition insists it is
-- not "unknown" and not "neither true nor false".  It is a statement about
-- what one vacana can denote.
--
-- THE SCOPE, EXACTLY.  That seven is exhaustive — `SaptabhangiNaya` §6
-- carries Akalaṅka's argument and this module does not touch it.  That the
-- demand list is the right model of सकलादेश — it is a model of what a total
-- statement DEMANDS, and Malliṣeṇa's question of what अवक्तव्यम् IS (failure
-- of expression, or consumption of what was to be expressed) is untouched
-- here, exactly as `Arpitanarpita_…` §११ says the composition laws cannot
-- settle it.  Nothing here settles it either.
------------------------------------------------------------------------

module Sakaladesa_NoSingleUtteranceDenotesTheTotalStatementAndTheContentNonethelessFolds where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; _or_ ; true≢false ; false≢true)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

module _ {S : Type ℓ} where

  ----------------------------------------------------------------------
  -- १ · वचनम् — the vocabulary, with no finiteness anywhere.
  --
  -- A प्रोफाइल records, for each standpoint, whether the property is
  -- present there.  A वचन — a single utterance — names ONE standpoint and
  -- ONE polarity, and denotes what that standpoint says.  This is
  -- `SaptabhangiNaya`'s `asti-from` / `nasti-from`, with the three fixed
  -- standpoints replaced by an arbitrary type.
  ----------------------------------------------------------------------

  Profile : Type ℓ
  Profile = S → Bool

  Vacana : Type ℓ
  Vacana = S × Bool

  denotes : Vacana → Profile → Bool
  denotes (s , true)  φ = φ s
  denotes (s , false) φ = not (φ s)

  -- सर्वास्ति / सर्वनास्ति — the two profiles that do all the work in §3.
  सर्वास्ति सर्वनास्ति : Profile
  सर्वास्ति  _ = true
  सर्वनास्ति _ = false

  ----------------------------------------------------------------------
  -- २ · आदेशः — the demand, and its content.
  --
  -- What a सकलादेश asks for: a finite list of standpoint-with-polarity,
  -- all of them at once.  Its content is their conjunction.
  --
  -- क्रम-सङ्कलनम् — SUCCESSION EXPRESSES IT, BY CONSTRUCTION, and the whole
  -- interest of §3 is that this is the easy direction.  `SaptabhangiNaya.
  -- krama-expresses` is this at one fixed two-element demand.
  --
  -- NOTE WHAT THIS SETTLES.  The content is a fold of the binary
  -- conjunction, so at the level of CONTENT the n-ary total statement is
  -- the iterated binary one.  The header records the claim this refutes.
  ----------------------------------------------------------------------

  Adesa : Type ℓ
  Adesa = List Vacana

  joint : Adesa → Profile → Bool
  joint []      _ = true
  joint (v ∷ d) φ = denotes v φ and joint d φ

  क्रम-सङ्कलनम् : (v : Vacana) (d : Adesa) (φ : Profile)
                → joint (v ∷ d) φ ≡ (denotes v φ and joint d φ)
  क्रम-सङ्कलनम् _ _ _ = refl

  ----------------------------------------------------------------------
  -- ३ · एक-वचनेन न — NO SINGLE UTTERANCE.
  --
  -- The demand is MIXED when it asks for at least one presence and at
  -- least one absence.  That is the whole hypothesis: no finiteness of S,
  -- no decidable equality on S, no exhaustion of utterances.
  ----------------------------------------------------------------------

  अस्ति-कश्चित् नास्ति-कश्चित् : Adesa → Bool
  अस्ति-कश्चित् []            = false
  अस्ति-कश्चित् ((_ , p) ∷ d) = p or अस्ति-कश्चित् d
  नास्ति-कश्चित् []            = false
  नास्ति-कश्चित् ((_ , p) ∷ d) = not p or नास्ति-कश्चित् d

  -- At the all-affirming profile every negative entry reads false, so one
  -- negative entry is enough to falsify the whole demand.
  सर्व-सत्ये-मिथ्या : (d : Adesa) → नास्ति-कश्चित् d ≡ true
                    → joint d सर्वास्ति ≡ false
  सर्व-सत्ये-मिथ्या []                h = Empty.rec (false≢true h)
  सर्व-सत्ये-मिथ्या ((_ , false) ∷ _) _ = refl
  सर्व-सत्ये-मिथ्या ((_ , true)  ∷ d) h = सर्व-सत्ये-मिथ्या d h

  -- …and dually.
  सर्व-मिथ्या-मिथ्या : (d : Adesa) → अस्ति-कश्चित् d ≡ true
                     → joint d सर्वनास्ति ≡ false
  सर्व-मिथ्या-मिथ्या []               h = Empty.rec (false≢true h)
  सर्व-मिथ्या-मिथ्या ((_ , true) ∷ _) _ = refl
  सर्व-मिथ्या-मिथ्या ((_ , false) ∷ d) h = सर्व-मिथ्या-मिथ्या d h

  -- THE THEOREM.  Whatever the single utterance is, one of the two
  -- constant profiles separates it from the demanded content — because a
  -- single utterance always reads TRUE at the constant profile matching
  -- its own polarity, while a mixed demand reads FALSE at both.
  एक-वचनेन-न : (d : Adesa)
              → अस्ति-कश्चित् d ≡ true → नास्ति-कश्चित् d ≡ true
              → (v : Vacana) → Σ[ φ ∈ Profile ] (¬ (denotes v φ ≡ joint d φ))
  एक-वचनेन-न d ha hn (s , true) =
    सर्वास्ति , λ e → true≢false (e ∙ सर्व-सत्ये-मिथ्या d hn)
  एक-वचनेन-न d ha hn (s , false) =
    सर्वनास्ति , λ e → true≢false (e ∙ सर्व-मिथ्या-मिथ्या d ha)

  ----------------------------------------------------------------------
  -- ४ · सकलादेशो न सङ्गच्छते — the same, as a factorisation obstruction.
  --
  -- The shape `AvaktavyaDoesNotFactor` names, here at
  -- arbitrary S and arbitrary demand length.
  ----------------------------------------------------------------------

  EkenaVacanena : Adesa → Type ℓ
  EkenaVacanena d = Σ[ v ∈ Vacana ] ((φ : Profile) → denotes v φ ≡ joint d φ)

  सकलादेशो-न-सङ्गच्छते : (d : Adesa)
                       → अस्ति-कश्चित् d ≡ true → नास्ति-कश्चित् d ≡ true
                       → ¬ EkenaVacanena d
  सकलादेशो-न-सङ्गच्छते d ha hn (v , agrees) =
    एक-वचनेन-न d ha hn v .snd (agrees (एक-वचनेन-न d ha hn v .fst))

  ----------------------------------------------------------------------
  -- ५ · रिक्तं तन्तुजालम् — AND AS A STATEMENT ABOUT A FIBRE.
  --
  -- `denotes` sends an utterance to the content it denotes.  §4 says the
  -- demanded content is NOT IN ITS IMAGE, i.e. the fibre over it is empty.
  --
  -- Placed against the rest of the scale:
  --
  --   fibre contractible   nothing lost.  `Loss.Carrier`; the datum
  --                        is determined and rides free.
  --   fibre with >1 point  नष्टि: the "which" is destroyed (§४).  Priced
  --                        when finite and decidable — the कुट्टक's side is
  --                        exactly one bit, and a comparison per step is
  --                        what recovers it.  अप्रतिकार्य when truncated.
  --   fibre EMPTY          अवक्तव्यम्.  Nothing was lost; nothing was ever
  --                        there.  The content is not sayable by one
  --                        utterance at all.
  --
  -- The three are different failures and the middle one is the only one
  -- that is a LOSS.  Calling the third a loss — "information destroyed by
  -- the fourth position" — is a reading this module removes.
  ----------------------------------------------------------------------

  Tantu : Adesa → Type ℓ
  Tantu d = Σ[ v ∈ Vacana ] ((φ : Profile) → denotes v φ ≡ joint d φ)

  रिक्तं-तन्तुजालम् : (d : Adesa)
                    → अस्ति-कश्चित् d ≡ true → नास्ति-कश्चित् d ≡ true
                    → ¬ Tantu d
  रिक्तं-तन्तुजालम् = सकलादेशो-न-सङ्गच्छते

------------------------------------------------------------------------
-- ६ · द्वि-नयम् — the smallest instance, so nothing above is vacuous.
--
-- Two standpoints, a demand asking presence at one and absence at the
-- other: precisely `SaptabhangiNaya.joint`, and precisely the
-- configuration the third bhaṅga (स्यादस्ति च नास्ति च) is about.  It is
-- expressible in succession and by §4 it is not expressible by one vacana.
------------------------------------------------------------------------

data द्वि : Type₀ where
  प्रथमः द्वितीयः : द्वि

आदेशः-द्वि : Adesa {S = द्वि}
आदेशः-द्वि = (प्रथमः , true) ∷ (द्वितीयः , false) ∷ []

मिश्रः-अस्ति : अस्ति-कश्चित् आदेशः-द्वि ≡ true
मिश्रः-अस्ति = refl

मिश्रः-नास्ति : नास्ति-कश्चित् आदेशः-द्वि ≡ true
मिश्रः-नास्ति = refl

-- realised: there is a profile at which the demand is met, so the content
-- is not empty of instances — it is a genuine two-valued predicate and not
-- a truth-value gap.  (`SaptabhangiNaya.joint-realised`, restated here so
-- §6 does not depend on that module.)
आदेशः-सिद्धः : Σ[ φ ∈ Profile {S = द्वि} ] (joint आदेशः-द्वि φ ≡ true)
आदेशः-सिद्धः = φ , refl
  where
  φ : Profile {S = द्वि}
  φ प्रथमः  = true
  φ द्वितीयः = false

-- and yet no single utterance denotes it.
अवक्तव्यम्-द्वि : ¬ EkenaVacanena आदेशः-द्वि
अवक्तव्यम्-द्वि = सकलादेशो-न-सङ्गच्छते आदेशः-द्वि मिश्रः-अस्ति मिश्रः-नास्ति

------------------------------------------------------------------------
-- ७ · What this does NOT license.
--
-- It does not say the total statement is impossible — क्रम-सङ्कलनम् says
-- succession expresses it exactly, and §6 exhibits a profile meeting the
-- demand.  It says one vacana does not denote it.  That distinction is the
-- entire content of अवक्तव्यम् in the sources and it is easy to lose in
-- translation: the position is about EXPRESSION, not about truth, not
-- about knowledge, and not about a third truth value.
--
-- Nor does it bear on which of the seven positions a given object
-- occupies, on the exhaustiveness of the seven, or on whether the record
-- lane and the label lane of `Arpitanarpita_…` can be reconciled.  Those
-- are three separate open questions and none of them is touched here.
------------------------------------------------------------------------
