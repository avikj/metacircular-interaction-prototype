{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����������������� � ������ ������������� ��������� �������� �
--
-- (the joining: a union is classified by BOTH constitutions.)
--
-- TEXT.  Vtsyyana, *Kmastra*, second adhikaraa (Smprayogika),
-- chapter 1: "On the kinds of union according to dimension, force of
-- desire, and time."  Read for this module, 2026-08-21, in the Burton
-- rendering (Project Gutenberg 27827), which is the one available here;
-- the  was not opened and the terms below are carried from the
-- secondary literature, so the verse-level citation is owed.
--
-- THE TEXT'S STRUCTURE, which is a taxonomy and is used here as one:
--
--   ������  dimension     ��   ����  ����      (hare, bull, horse)
--                          �����  ����  �������   (deer, mare, elephant)
--   ����     force          ����  ����  ����      (small, middling, intense)
--   ����     duration       ������ ����  ���       (short, moderate, long)
--
-- Each axis gives 3 � 3 = 9 pairings.  Three of the nine are �� � the
-- constitutions match � and six are ����, split into ����� (the first
-- exceeds) and ��� (it falls short).  Across all three axes the text says
-- the kinds are innumerable; the count of the taxonomy is 9³ = 729, which
-- §4 has the kernel compute rather than assert.
--
-- THE DOCTRINE THAT MAKES THIS A MATHEMATICAL STATEMENT.  The text does
-- not rank unions by one party's magnitude.  It classifies by the PAIR,
-- it holds the equal union to be best, and for the unequal ones it
-- prescribes technique � the larger is governed so that the smaller is
-- not injured.  That is a compatibility theory, and it is exactly what is
-- needed to say whether two mathematical organisms can be composed.
--
-- THE TWO ORGANISMS.  §3 places them, with the evidence for each
-- placement named.  §5 reads off where they are ��, where ����, and what
-- the ���� axes therefore OWE � which is the point of doing this at all:
-- an unequal union is not forbidden, it is conditional on a technique,
-- and the technique here is a theorem that already exists.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical, with the back-port in
-- notes/CUBICAL_PATCH.md), --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Samprayogika_TheJoinIsClassifiedByBothConstitutions where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; _++_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

--------------------------------------------------------------------------
-- 1.  The three axes, as the text has them
--------------------------------------------------------------------------

data प्रमाण : Type₀ where   -- dimension: what each side can take and give
  शश वृषभ अश्व : प्रमाण

data वेग : Type₀ where      -- force: how hard it drives per step
  मन्द मध्य चण्ड : वेग

data काल : Type₀ where      -- duration: how long it sustains
  शीघ्र मध्यम चिर : काल

-- a constitution is a point on all three
प्रकृति : Type₀
प्रकृति = प्रमाण × (वेग × काल)

-- a union is a pair of constitutions.  Not one magnitude; the pair.
योग : Type₀
योग = प्रकृति × प्रकृति

--------------------------------------------------------------------------
-- 2.  �� / ����� / ���, per axis
--------------------------------------------------------------------------

data सम्बन्ध : Type₀ where
  सम  : सम्बन्ध     -- equal: the constitutions match
  उच्च : सम्बन्ध     -- high: the first exceeds the second
  नीच : सम्बन्ध     -- low:  the first falls short

rank-प्रमाण : प्रमाण → ℕ
rank-प्रमाण शश = 0
rank-प्रमाण वृषभ = 1
rank-प्रमाण अश्व = 2

rank-वेग : वेग → ℕ
rank-वेग मन्द = 0
rank-वेग मध्य = 1
rank-वेग चण्ड = 2

rank-काल : काल → ℕ
rank-काल शीघ्र = 0
rank-काल मध्यम = 1
rank-काल चिर = 2

compare : ℕ → ℕ → सम्बन्ध
compare zero zero = सम
compare zero (suc _) = नीच
compare (suc _) zero = उच्च
compare (suc m) (suc n) = compare m n

-- the verdict of a union, one component per axis
विभाग : योग → सम्बन्ध × (सम्बन्ध × सम्बन्ध)
विभाग ((p₁ , (v₁ , k₁)) , (p₂ , (v₂ , k₂))) =
    compare (rank-प्रमाण p₁) (rank-प्रमाण p₂)
  , ( compare (rank-वेग v₁) (rank-वेग v₂)
    , compare (rank-काल k₁) (rank-काल k₂) )

--------------------------------------------------------------------------
-- 3.  The two organisms, placed, with the evidence for each placement
--------------------------------------------------------------------------

-- machine/MathMachine.hs.
--   ������ ����  � it takes the entire term space at once: 637,852 terms in
--                 one round at vocabulary 8, horizon 7.
--   ���� ����     � every round acts on everything it can see, and the
--                 obstruction it leaves behind climbed 8 � 79,656 in ten
--                 rounds before the growth rule was changed.
--   ���� ���      � `loop = round1 � >> loop`.  It does not stop.
यन्त्रम् : प्रकृति
यन्त्रम् = अश्व , (चण्ड , चिर)

-- Returnm_TheStepIsAConjugationAndNothingIsTouchedByIt.
--   ������ ��   � one triple, three slots: ������, ��������, ����.
--   ���� ����    � the step is ����� ∘ Φ ∘ �������, a single conjugation,
--                and no fibre is collapsed by it.
--   ���� ���     � ��� is coinductive; the net runs forever.
विवेकः : प्रकृति
विवेकः = शश , (मन्द , चिर)

अस्माकं-योगः : योग
अस्माकं-योगः = यन्त्रम् , विवेकः

--------------------------------------------------------------------------
-- 4.  The taxonomy's own count, computed and not asserted
--------------------------------------------------------------------------

all-प्रमाण : List प्रमाण
all-प्रमाण = शश ∷ वृषभ ∷ अश्व ∷ []

all-वेग : List वेग
all-वेग = मन्द ∷ मध्य ∷ चण्ड ∷ []

all-काल : List काल
all-काल = शीघ्र ∷ मध्यम ∷ चिर ∷ []

-- the full product: every dimension with every force with every duration
all-प्रकृति : List प्रकृति
all-प्रकृति = go all-प्रमाण
  where
    withVK : प्रमाण → List वेग → List प्रकृति
    withVK p [] = []
    withVK p (v ∷ vs) = map (λ k → p , (v , k)) all-काल ++ withVK p vs

    go : List प्रमाण → List प्रकृति
    go [] = []
    go (p ∷ ps) = withVK p all-वेग ++ go ps

all-योग : List योग
all-योग = go all-प्रकृति
  where
    go : List प्रकृति → List योग
    go [] = []
    go (a ∷ as) = map (λ b → a , b) all-प्रकृति ++ go as

-- twenty-seven constitutions �
सप्तविंशतिः : length all-प्रकृति ≡ 27
सप्तविंशतिः = refl

-- � and 9 � 9 � 9 unions, by the kernel.  (This counts the enumeration,
-- which is the full product by construction; it is not a completeness
-- theorem and is not offered as one.)
नवशतम्-एकोनत्रिंशत् : length all-योग ≡ 729
नवशतम्-एकोनत्रिंशत् = refl

--------------------------------------------------------------------------
-- 5.  Where this pair stands, and what the unequal axes owe
--------------------------------------------------------------------------

-- �� in duration.  Both run forever: one by `loop`, one by coinduction.
-- ����� in dimension and in force: the engine exceeds on both.
अस्माकं-विभागः : विभाग अस्माकं-योगः ≡ (उच्च , (उच्च , सम))
अस्माकं-विभागः = refl

-- THE OBLIGATION.  The text's rule for an ����� union is that the greater
-- is governed so the lesser is not injured.  Stated mathematically: the
-- large organism's action must be proved not to destroy what the small
-- one carries.  That is exactly
--
--     Calana.������           the remainder survives the whole run, � n
--     Alopa_TheEngineNeverTouchesTheMeaning.������
--                            the engine's normalisation preserves every
--                            meaning, � n, by structure
--
-- so the ���ension and force axes are discharged, in that order, by
-- theorems and not by hope.  What is NOT discharged, and is named here
-- rather than hidden: the engine's own step has no proof that it
-- preserves the small organism's ���� specifically � only that it
-- preserves meanings under a semantics.  Until the two are the same
-- statement, this union is conditional.
data Obligation : Type₀ where
  discharged : Obligation
  owed       : Obligation

प्रमाण-obligation वेग-obligation काल-obligation : Obligation
प्रमाण-obligation = discharged   -- Alopa.अलोपः
वेग-obligation    = discharged   -- Calana.अलोपः
काल-obligation    = discharged   -- सम: no technique required

-- and the one that is still owed, stated as data so it cannot be lost
शेष-obligation : Obligation
शेष-obligation = owed
