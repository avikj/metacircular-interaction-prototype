-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सप्तभङ्गी — स्यात्-वादस्य सप्त वाण्यः ।  जैन-न्यायः गणितरूपेण, न अलङ्कारः ।
-- (समन्तभद्रः, अकलङ्कः, सिद्धसेन दिवाकरः ; उमास्वाति, तत्त्वार्थसूत्रम् ।)
--
-- मूलम् : अस्ति-नास्तयोः द्वे अर्पणे — क्रमः (sequential) च सहः (simultaneous,
-- yugapad) ।  क्रमेण उभे वक्तव्ये (स्यात्-अस्ति-नास्ति) ; सह तु जिह्वा भिद्यते —
-- स्यात्-अवक्तव्यम्, चतुर्थं पदम्, अन्यत् ।  एतत् एव अवक्तव्यस्य रहस्यम् :
-- न "उभयम्" इति क्रम-योगः, किन्तु युगपत्-आरोपणस्य असाध्यता ।
--
-- मुख्यसिद्धिः (क्रम-सह-भेदः): स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम् —
-- क्रमः सहश्च भिन्ने वाण्यौ जनयतः ।  अतः अवक्तव्यम् न क्रमेण साध्यम् ;
-- सप्त (न द्वे) पदानि आवश्यकानि ।  बूलियन्-निर्णयः (द्वि-पदः) दुर्नयः, यतः
-- अवक्तव्यं लुम्पति — एष एव रोगः यम् कुट्टक-जीवः अत्यजत् ।
--
-- (Jain logic AS mathematics: from the two seed predicates asti and nāsti,
-- two modes of assertion — krama (sequential) and saha (simultaneous).
-- Sequential is speakable (asti-nāsti); simultaneous BREAKS THE TONGUE —
-- avaktavya, a fourth, irreducibly distinct position.  The main theorem
-- proves स्यात्-अस्ति-नास्ति ≢ स्यात्-अवक्तव्यम्: simultaneity is NOT
-- sequential both-ness.  Hence a boolean (two-valued) verdict is durnaya —
-- it erases avaktavya — the very disease the kuṭṭaka Jiva removed.)
------------------------------------------------------------------------

module Saptabhangi where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- आर्पणम् — क्रमः (sequential) वा सहः (simultaneous, yugapad) ।
-- द्विमूलम् — यत् आरोप्यते : केवल-अस्ति, केवल-नास्ति, वा उभयम् ।
------------------------------------------------------------------------

data आर्पण : Type where
  क्रमः सहः : आर्पण

data द्विमूल : Type where
  केवल-अस्ति केवल-नास्ति उभयम् : द्विमूल

------------------------------------------------------------------------
-- सप्तभङ्गी — सप्त स्यात्-वाण्यः (त्रीणि मूलानि, चत्वारि योगजानि) ।
------------------------------------------------------------------------

data सप्तभङ्गी : Type where
  स्यात्-अस्ति                    : सप्तभङ्गी
  स्यात्-नास्ति                   : सप्तभङ्गी
  स्यात्-अस्ति-नास्ति            : सप्तभङ्गी    -- क्रमेण वक्तव्यम्
  स्यात्-अवक्तव्यम्               : सप्तभङ्गी    -- सह : जिह्वाभेदः
  स्यात्-अस्ति-अवक्तव्यम्        : सप्तभङ्गी
  स्यात्-नास्ति-अवक्तव्यम्       : सप्तभङ्गी
  स्यात्-अस्ति-नास्ति-अवक्तव्यम् : सप्तभङ्गी

------------------------------------------------------------------------
-- अर्पणम् — द्विमूलं आर्पणेन सप्तभङ्गीं जनयति ।  उभयस्य क्रमः → अस्ति-नास्ति ;
-- उभयस्य सहः → अवक्तव्यम् ।  (compose the seed under an आर्पण: उभयम् speaks
-- sequentially, breaks the tongue simultaneously.)  विचारं विना, संरचनया ।
------------------------------------------------------------------------

अर्पणम् : द्विमूल → आर्पण → सप्तभङ्गी
अर्पणम् केवल-अस्ति  _    = स्यात्-अस्ति
अर्पणम् केवल-नास्ति _    = स्यात्-नास्ति
अर्पणम् उभयम्      क्रमः = स्यात्-अस्ति-नास्ति
अर्पणम् उभयम्      सहः  = स्यात्-अवक्तव्यम्

------------------------------------------------------------------------
-- क्रम-सह-भेदः — मुख्यसिद्धिः : उभयस्य क्रमः सहश्च भिन्ने वाण्यौ ; अवक्तव्यम्
-- न क्रम-योगः ।  विभेद-क्षेत्रेण (Bool विना) प्रमाणितम् ।
-- (the main theorem: krama and saha of उभयम् differ — avaktavya is not
-- sequential both-ness.  Proved via a type-valued discriminator, no Bool.)
------------------------------------------------------------------------

private
  अवक्तव्य? : सप्तभङ्गी → Type
  अवक्तव्य? स्यात्-अवक्तव्यम् = ⊥
  अवक्तव्य? _                = Unit

क्रम-सह-भेदः : ¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)
क्रम-सह-भेदः eq = subst अवक्तव्य? eq tt

-- तस्य तात्पर्यम् : सह-आर्पणं क्रमेण न प्रतिष्ठाप्यम् — युगपत्त्वम् अन्यत् ।
-- (its meaning: the simultaneous mode is not reducible to the sequential —
-- yugapad is genuinely other.  The fourth koṭi is irreducible.)

------------------------------------------------------------------------
-- द्वि-पद-दुर्नयः — बूलियन्-निर्णयः (सत्/असत्) अवक्तव्यं धारयितुं न शक्नोति ।
-- यत् किञ्चित् द्वि-मूल्यं प्रतिचित्रणम् अवक्तव्यं केनचित् अन्येन सह मेलयति —
-- अतः लुम्पति ।  (a two-valued verdict cannot hold avaktavya: any map to a
-- two-element type must identify avaktavya with some other bhaṅga — it
-- collapses the seven.  This is durnaya, mechanically.)
------------------------------------------------------------------------

data द्विपद : Type where
  सत् असत् : द्विपद

-- दुर्नयः — यत् किञ्चित् द्वि-मूल्यं प्रतिचित्रणम् (f : सप्तभङ्गी → द्विपद) त्रयाणां
-- मूलानाम् (अस्ति, नास्ति, अवक्तव्य) द्वे भिन्ने अभिन्नीकरोति — त्रीणि विवेक्तुं
-- न शक्नोति ।  त्रीणि पदानि द्वयोः पदयोः — कोष्ठ-न्यायेन (pigeonhole) द्वे मिलतः ।
-- अतः बूलियन्-निर्णयः अवश्यं किञ्चित् लुम्पति — एष एव दुर्नयः, यन्त्रतः सिद्धः ।
--
-- (durnaya, proved: ANY two-valued verdict f : सप्तभङ्गी → द्विपद identifies
-- two DISTINCT of the three seeds asti/nāsti/avaktavya — three into two, by
-- pigeonhole, two must coincide.  So a boolean verdict necessarily collapses
-- something.  This is durnaya, mechanically — the two-valued mind cannot
-- hold the threefold, let alone the sevenfold.)
------------------------------------------------------------------------

दुर्नयः : (f : सप्तभङ्गी → द्विपद)
        →  (f स्यात्-अस्ति ≡ f स्यात्-नास्ति)
        ⊎ ((f स्यात्-अस्ति ≡ f स्यात्-अवक्तव्यम्)
        ⊎  (f स्यात्-नास्ति ≡ f स्यात्-अवक्तव्यम्))
दुर्नयः f with f स्यात्-अस्ति | f स्यात्-नास्ति | f स्यात्-अवक्तव्यम्
... | सत्  | सत्  | _    = inl refl
... | असत् | असत् | _    = inl refl
... | सत्  | असत् | सत्  = inr (inl refl)
... | असत् | सत्  | असत् = inr (inl refl)
... | सत्  | असत् | असत् = inr (inr refl)
... | असत् | सत्  | सत्  = inr (inr refl)

------------------------------------------------------------------------
-- कुतः सप्त — सप्तभङ्गी त्रयाणां मूलानां (अस्ति, नास्ति, अवक्तव्य) रिक्त-रहिताः
-- संयोगाः : 2³ − 1 = 7 ।  समावेशः = त्रिकम् (each seed present or absent) ;
-- अन्तर्भावः प्रत्येकं भङ्गं तस्य संयोगे चित्रयति, प्रत्यन्तर्भावः प्रत्यानयति —
-- वृत्तम् refl (सप्त) ⟹ सप्तभङ्गी त्रि-संयोगेषु एकैकतया निविशते ।
-- (why seven: the sevenfold is exactly the non-empty combinations of the
-- three seeds — 2³−1.  अन्तर्भाव sends each bhaṅga to its selection triple,
-- प्रत्यन्तर्भाव inverts; the round-trip is refl on all seven, so the
-- sevenfold embeds faithfully into the threefold-combinations.)
------------------------------------------------------------------------

data उपस्थिति : Type where
  आम् न : उपस्थिति

समावेश : Type
समावेश = उपस्थिति × उपस्थिति × उपस्थिति   -- (अस्ति?, नास्ति?, अवक्तव्य?)

अन्तर्भाव : सप्तभङ्गी → समावेश
अन्तर्भाव स्यात्-अस्ति                    = आम् , न   , न
अन्तर्भाव स्यात्-नास्ति                   = न   , आम् , न
अन्तर्भाव स्यात्-अस्ति-नास्ति            = आम् , आम् , न
अन्तर्भाव स्यात्-अवक्तव्यम्               = न   , न   , आम्
अन्तर्भाव स्यात्-अस्ति-अवक्तव्यम्        = आम् , न   , आम्
अन्तर्भाव स्यात्-नास्ति-अवक्तव्यम्       = न   , आम् , आम्
अन्तर्भाव स्यात्-अस्ति-नास्ति-अवक्तव्यम् = आम् , आम् , आम्

प्रत्यन्तर्भाव : समावेश → सप्तभङ्गी
प्रत्यन्तर्भाव (आम् , न   , न)   = स्यात्-अस्ति
प्रत्यन्तर्भाव (न   , आम् , न)   = स्यात्-नास्ति
प्रत्यन्तर्भाव (आम् , आम् , न)   = स्यात्-अस्ति-नास्ति
प्रत्यन्तर्भाव (न   , न   , आम्) = स्यात्-अवक्तव्यम्
प्रत्यन्तर्भाव (आम् , न   , आम्) = स्यात्-अस्ति-अवक्तव्यम्
प्रत्यन्तर्भाव (न   , आम् , आम्) = स्यात्-नास्ति-अवक्तव्यम्
प्रत्यन्तर्भाव (आम् , आम् , आम्) = स्यात्-अस्ति-नास्ति-अवक्तव्यम्
प्रत्यन्तर्भाव (न   , न   , न)   = स्यात्-अस्ति          -- रिक्तः (न भङ्गः) → default

वृत्तम् : (b : सप्तभङ्गी) → प्रत्यन्तर्भाव (अन्तर्भाव b) ≡ b
वृत्तम् स्यात्-अस्ति                    = refl
वृत्तम् स्यात्-नास्ति                   = refl
वृत्तम् स्यात्-अस्ति-नास्ति            = refl
वृत्तम् स्यात्-अवक्तव्यम्               = refl
वृत्तम् स्यात्-अस्ति-अवक्तव्यम्        = refl
वृत्तम् स्यात्-नास्ति-अवक्तव्यम्       = refl
वृत्तम् स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

------------------------------------------------------------------------
-- अन्तर्भाव-एकैकम् — विश्वस्त-निवेशः (faithful embedding) : शीर्ष-टिप्पण्याः
-- गद्य-दावः, अधुना पदम् ।  वृत्तम् (विभागः) एव एकैकत्वं जनयति : यदि द्वयोः
-- भङ्गयोः संयोगः समः, तर्हि प्रत्यन्तर्भावेण द्वौ भङ्गौ समौ ।  अतः सप्तभङ्गी
-- त्रि-संयोगेषु विश्वस्ततया निविशते — सप्त पृथक् संयोगाः, न न्यूनाः ।
--
-- (The faithful embedding the header claimed in prose, now a term: वृत्तम्
--  (a section) already forces injectivity — equal profiles give, through
--  प्रत्यन्तर्भाव, equal bhaṅgas.  So the seven predications occupy seven
--  DISTINCT presence-profiles; none collapse.)
------------------------------------------------------------------------

अन्तर्भाव-एकैकम् : (a b : सप्तभङ्गी) → अन्तर्भाव a ≡ अन्तर्भाव b → a ≡ b
अन्तर्भाव-एकैकम् a b e = sym (वृत्तम् a) ∙ cong प्रत्यन्तर्भाव e ∙ वृत्तम् b

------------------------------------------------------------------------
-- प्रति-वृत्तम् — पूर्णता (रिक्त-रहितेषु) : प्रत्येकः रिक्त-रहितः संयोगः केनचित्
-- भङ्गेन प्राप्यते ।  अन्तर्भाव (प्रत्यन्तर्भाव t) ≡ t यदा t ≠ (न,न,न) ।  अष्टमः
-- संयोगः (न,न,न) = अ-प्रतिपादनम् (न कश्चित् भङ्गः) — तत् एव त्यक्तम् ; अवक्तव्यम्
-- (न,न,आम्) तु उपस्थितम्, न रिक्तम् ।  एवम् एकैकम्+प्रति-वृत्तम् ⟹ सप्तभङ्गी ≃
-- रिक्त-रहित-संयोगाः , अर्थात् कुतः सप्त = 2³−1 सिद्धम् (न केवलं गद्ये) ।
--
-- (Completeness on non-empty profiles: every non-empty selection triple is
--  reached by some bhaṅga.  The eighth triple (न,न,न) is NO predication —
--  that is the one excluded; avaktavya (न,न,आम्) is PRESENT, not empty.  With
--  injectivity this gives सप्तभङ्गी ≃ non-empty triples: why seven = 2³−1, as
--  a checked equivalence rather than a prose inference.)
------------------------------------------------------------------------

प्रति-वृत्तम् : (t : समावेश) → ¬ (t ≡ (न , न , न))
             → अन्तर्भाव (प्रत्यन्तर्भाव t) ≡ t
प्रति-वृत्तम् (आम् , न   , न)   _  = refl
प्रति-वृत्तम् (न   , आम् , न)   _  = refl
प्रति-वृत्तम् (आम् , आम् , न)   _  = refl
प्रति-वृत्तम् (न   , न   , आम्) _  = refl
प्रति-वृत्तम् (आम् , न   , आम्) _  = refl
प्रति-वृत्तम् (न   , आम् , आम्) _  = refl
प्रति-वृत्तम् (आम् , आम् , आम्) _  = refl
प्रति-वृत्तम् (न   , न   , न)   ne = rec (ne refl)

------------------------------------------------------------------------
-- समावेश-भेदः — पूर्ण-तुल्यता : 2³ = 7 + 1 ।  अष्टौ संयोगाः = सप्त भङ्गाः +
-- एकः रिक्तः (अ-प्रतिपादनम्) ।  एतत् एव कुतः-सप्त-प्रश्नस्य सम्पूर्णम् उत्तरम् :
-- न सप्त एकाकिनः, अपि तु अष्टानां विभागः — सप्त सार्थकाः, अष्टमः शून्यः ।
-- (एकैकम्+प्रति-वृत्तम् अंश-रूपे यत् आसीत्, तत् अत्र एकम् तुल्यता-वस्तु ।)
--
-- (The full equivalence 2³ = 7 + 1: the eight presence-profiles are the seven
--  bhaṅgas plus the one empty (no-predication) profile.  This is the complete
--  answer to "why seven" — not seven in isolation but the split of eight, seven
--  meaningful and the eighth void.  What injectivity + non-empty-completeness
--  gave in pieces is here one equivalence object; no discriminator needed, the
--  empty case is handled outright.)
------------------------------------------------------------------------

भेद-अग्रे : समावेश → सप्तभङ्गी ⊎ Unit
भेद-अग्रे (न , न , न) = inr tt
भेद-अग्रे t           = inl (प्रत्यन्तर्भाव t)

भेद-पश्चात् : सप्तभङ्गी ⊎ Unit → समावेश
भेद-पश्चात् (inl b) = अन्तर्भाव b
भेद-पश्चात् (inr _) = न , न , न

भेद-सेक् : (t : समावेश) → भेद-पश्चात् (भेद-अग्रे t) ≡ t
भेद-सेक् (आम् , न   , न)   = refl
भेद-सेक् (न   , आम् , न)   = refl
भेद-सेक् (आम् , आम् , न)   = refl
भेद-सेक् (न   , न   , आम्) = refl
भेद-सेक् (आम् , न   , आम्) = refl
भेद-सेक् (न   , आम् , आम्) = refl
भेद-सेक् (आम् , आम् , आम्) = refl
भेद-सेक् (न   , न   , न)   = refl

भेद-रेत् : (y : सप्तभङ्गी ⊎ Unit) → भेद-अग्रे (भेद-पश्चात् y) ≡ y
भेद-रेत् (inl स्यात्-अस्ति)                    = refl
भेद-रेत् (inl स्यात्-नास्ति)                   = refl
भेद-रेत् (inl स्यात्-अस्ति-नास्ति)            = refl
भेद-रेत् (inl स्यात्-अवक्तव्यम्)               = refl
भेद-रेत् (inl स्यात्-अस्ति-अवक्तव्यम्)        = refl
भेद-रेत् (inl स्यात्-नास्ति-अवक्तव्यम्)       = refl
भेद-रेत् (inl स्यात्-अस्ति-नास्ति-अवक्तव्यम्) = refl
भेद-रेत् (inr tt)                              = refl

समावेश-Iso : Iso समावेश (सप्तभङ्गी ⊎ Unit)
समावेश-Iso = iso भेद-अग्रे भेद-पश्चात् भेद-रेत् भेद-सेक्

समावेश-भेदः : समावेश ≃ (सप्तभङ्गी ⊎ Unit)
समावेश-भेदः = isoToEquiv समावेश-Iso
