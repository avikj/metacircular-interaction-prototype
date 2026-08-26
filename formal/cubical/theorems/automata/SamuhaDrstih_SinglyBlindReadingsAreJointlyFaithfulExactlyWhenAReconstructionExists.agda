{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समूह-दृष्टिः — एकैकम् अन्धाः, समूहेन पश्यन्ति ; प्रत्यानयनं प्रमाणम् ।
--
-- (singly blind readings are JOINTLY faithful, and a reconstruction is the
-- certificate.)
--
-- WHY THIS EXISTS.  Four terms landed in this corpus this session and every
-- one of them is a NO-GO:
--
--   SamacaranaNityam  a transitive symmetry flattens every observable
--   ApurvaIndriyam    a derived reading is blind inside its source's fibers
--   ParimanaAndha     |·| cannot see the Möbius sign
--   TiryakTantu       the residue class and the factorisation are transverse
--
-- Read together they say what cannot be done, and read carelessly they say
-- the frontier is closed.  They do not say that, and this file is the half
-- that was missing: **blindness is not stable under taking families.**
--
-- The transversality of `TiryakTantu` is created by FIXING v.  Over the whole
-- family of moduli nothing is lost at all — u ↦ (u mod v)_v is injective, and
-- that is the Chinese remainder theorem, which this corpus knows as कुट्टक
-- and which is 1500 years older than the obstruction it dissolves.  So the
-- honest reading of four no-gos is not *no chart sees both*; it is
--
--     no SINGLE chart sees both, and a FAMILY with a reconstruction does.
--
-- §३ makes "with a reconstruction" the whole content: a family is jointly
-- faithful exactly when the joint reading has a left inverse, and exhibiting
-- one is cheaper than proving injectivity — 6 refls against 36 cases here.
--
-- AND IT IS THE SECTION AGAIN.  `EkaVidhih` §३ showed descent costs a section
-- of S.  Joint faithfulness costs a reconstruction of the joint reading.
-- Same object, opposite side: a section chooses a point in each fiber, a
-- reconstruction proves each fiber was a point already.  The one law's costly
-- direction is paid in the same currency both times.
------------------------------------------------------------------------

module SamuhaDrstih_SinglyBlindReadingsAreJointlyFaithfulExactlyWhenAReconstructionExists where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; snotz ; injSuc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibersSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · सामान्यम् — the general statement, no finiteness anywhere
--
-- A reconstruction of a reading is a left inverse.  It is DATA, like
-- `प्रवहति`: a family that cannot hand one over has not shown it is faithful.
------------------------------------------------------------------------

प्रत्यानयनम् : {X : Type ℓ} {O : Type ℓ'} → (X → O) → Type (ℓ-max ℓ ℓ')
प्रत्यानयनम् {X = X} S = Σ[ r ∈ (_ → X) ] ((x : X) → r (S x) ≡ x)

-- A reading with a reconstruction identifies nothing.  One rewrite.
प्रत्यानयनात्-भेदः : {X : Type ℓ} {O : Type ℓ'} (S : X → O)
                   → प्रत्यानयनम् S → (x y : X) → S x ≡ S y → x ≡ y
प्रत्यानयनात्-भेदः S (r , ρ) x y p = sym (ρ x) ∙ cong r p ∙ ρ y

------------------------------------------------------------------------
-- २ · कुट्टकः षट्सु — the exhibit: two blind readings, jointly faithful
--
-- Āryabhaṭa, Āryabhaṭīya (499), kuṭṭaka — the residue system, stated as the
-- descent that solves simultaneous congruences.  Here at moduli 2 and 3 on
-- six residues, the smallest case where both readings are individually
-- blind and their pair is not.
------------------------------------------------------------------------

data षट् : Type where
  र० र१ र२ र३ र४ र५ : षट्

-- the two readings
द्वि : षट् → ℕ                     -- mod 2
द्वि र० = 0
द्वि र१ = 1
द्वि र२ = 0
द्वि र३ = 1
द्वि र४ = 0
द्वि र५ = 1

त्रि : षट् → ℕ                     -- mod 3
त्रि र० = 0
त्रि र१ = 1
त्रि र२ = 2
त्रि र३ = 0
त्रि र४ = 1
त्रि र५ = 2

समूहः : षट् → ℕ × ℕ                -- the joint reading
समूहः x = (द्वि x , त्रि x)

------------------------------------------------------------------------
-- २a · एकैकम् अन्धाः — each reading alone identifies two residues
------------------------------------------------------------------------

अङ्कः : षट् → ℕ                    -- a code, to get disequality of residues
अङ्कः र० = 0
अङ्कः र१ = 1
अङ्कः र२ = 2
अङ्कः र३ = 3
अङ्कः र४ = 4
अङ्कः र५ = 5

र०≢र२ : र० ≡ र२ → ⊥
र०≢र२ p = znots (cong अङ्कः p)

र०≢र३ : र० ≡ र३ → ⊥
र०≢र३ p = znots (cong अङ्कः p)

-- mod 2 cannot separate र० from र२ …
द्वि-अन्धम् : द्वि र० ≡ द्वि र२
द्वि-अन्धम् = refl

-- … and mod 3 cannot separate र० from र३.
त्रि-अन्धम् : त्रि र० ≡ त्रि र३
त्रि-अन्धम् = refl

-- So NEITHER part admits a reconstruction: a reading that identifies two
-- distinct points has no left inverse, by §१ read backwards.  This is what
-- makes §३ a genuine gain rather than a restatement.
द्वेः-न-प्रत्यानयनम् : प्रत्यानयनम् द्वि → ⊥
द्वेः-न-प्रत्यानयनम् ρ = र०≢र२ (प्रत्यानयनात्-भेदः द्वि ρ र० र२ द्वि-अन्धम्)

त्रेः-न-प्रत्यानयनम् : प्रत्यानयनम् त्रि → ⊥
त्रेः-न-प्रत्यानयनम् ρ = र०≢र३ (प्रत्यानयनात्-भेदः त्रि ρ र० र३ त्रि-अन्धम्)

------------------------------------------------------------------------
-- ३ · मुख्यसिद्धिः — the pair reconstructs, so the pair is faithful
--
-- Six `refl`s.  Injectivity of the joint reading would be thirty-six cases;
-- the reconstruction is the cheaper certificate and is the honest form,
-- because it is the datum a user of the family actually needs.
------------------------------------------------------------------------

पुनः : ℕ × ℕ → षट्                  -- kuṭṭaka: (a mod 2, a mod 3) ↦ a mod 6
पुनः (0 , 0) = र०
पुनः (1 , 1) = र१
पुनः (0 , 2) = र२
पुनः (1 , 0) = र३
पुनः (0 , 1) = र४
पुनः (1 , 2) = र५
पुनः _       = र०                   -- off the image; never consulted below

समूह-प्रत्यानयनम् : प्रत्यानयनम् समूहः
समूह-प्रत्यानयनम् = पुनः , ρ
  where
    ρ : (x : षट्) → पुनः (समूहः x) ≡ x
    ρ र० = refl
    ρ र१ = refl
    ρ र२ = refl
    ρ र३ = refl
    ρ र४ = refl
    ρ र५ = refl

-- Hence the joint reading separates everything the parts could not.
समूहेन-भेदः : (x y : षट्) → समूहः x ≡ समूहः y → x ≡ y
समूहेन-भेदः = प्रत्यानयनात्-भेदः समूहः समूह-प्रत्यानयनम्

------------------------------------------------------------------------
-- ४ · तत्फलम् — what four no-gos actually said
--
-- `अपूर्वम्` refutes derivation of one reading FROM another.  It says nothing
-- against a family, and §३ is the reason: the pair is not derived from either
-- part — it is derived from both, and its fiber is a point where each part's
-- was not.  Blindness is a property of a chart, not of the object, and it
-- does not survive being joined.
--
-- For the residual bilinear form this is the standing instruction and not a
-- hope.  `TiryakTantu` proves the residue class and the Möbius sign are
-- transverse AT A FIXED v.  It cannot and does not prove that a family —
-- several moduli, or the class together with the factorisation carried as one
-- datum — is blind.  A proof that works on the joint object owes no
-- reconstruction of one half from the other, because it never separated them:
-- सूत्र ५, बद्ध-b, the datum rides free.
--
-- मर्यादा, at the site.  §३ is kuṭṭaka at moduli 2 and 3 on six residues.  It
-- exhibits that joint faithfulness HAPPENS and supplies the certificate shape;
-- it is not the general CRT, and it says nothing about whether any PARTICULAR
-- family arising in the bilinear form admits a reconstruction.  That question
-- is the work.  What is settled is that the four no-gos do not close it, and
-- reading them as closing it would be a durnaya — a two-valued verdict
-- (blind / not blind) on a question whose third position is *blind alone,
-- seeing together*.
------------------------------------------------------------------------
