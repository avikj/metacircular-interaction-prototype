{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������������ � the mode is a PATH, the substance is the TYPE it lives in,
-- and dhrauvya (persistence) is exactly what makes transport possible.
-- The keystone: the Jain metaphysics of being IS proof-of-transport.
--
-- SOURCE.  Umsvti, *Tattvrthastra* (~2nd�5th c.):
--   5.29  utpda-vyaya-dhrauvya-yukta sat � what IS, is joined with
--         origination, cessation, and persistence (together, ������� �
--         `Anekanta.���������`/`������`).
--   5.37  gua-paryyavad dravyam � a substance is that which has qualities
--         and MODES (paryya).  5.38 (Digambara) tad-bhvvyaya nityam �
--         permanence is non-loss of its own being through the modes.
--   Siddhasena, *Sanmatitarka* 1.3-6: dravyrthika (substance-regarding)
--         and paryyrthika (mode-regarding) are two standpoints on ONE
--         real; each denying the other is a durnaya.
--
-- THE IDENTIFICATION, exactly, in cubical type theory.  Take a dravya to
-- be the space of its own modes � a type `D`.  Then:
--   � a paryya (mode) is a POINT of D;
--   � a parima (a transformation, one mode becoming another) is a PATH
--       p : m� ≡ m� in D;
--   � VYAYA is the source endpoint (the mode that ceases), UTPDA the
--       target (the mode that arises), and DHRAUVYA is D itself � the
--       substance, the SAME type at both ends of every path.
--   � transport `subst P p` � the free road (`PramanaSankramana`) � carries
--       any property across the change; and it EXISTS precisely because
--       both modes lie in one D.  Persistence of the substance is the exact
--       condition for lossless transport across its modes.
--
-- So utpda-vyaya-dhrauvya-yukta sat is not a slogan and not three facts:
-- it is the single statement that to BE is to be a type through which its
-- modes transport without loss.  The Jain definition of the real and the
-- corpus's free road are ONE object.
--
-- WHAT IS PROVED:
--   §2  ������ � every parima carries all three moments: vyaya (source),
--       utpda (target), dhrauvya (both in one D), �������.
--   §3  ���������� � transport along a parima is free: any property of the
--       ceasing mode is carried to the arisen one (subst), and the record
--       of the arisen mode is contractible (`isContrSingl`) � road one.
--   §4  ��������-�����������-����� � dhrauvya is the GROUND of transport: the
--       identity parima (no change) transports as the identity (nothing
--       moves when nothing changes � `Dhruva`'s ����� read here), and every
--       transport is reversible (the parima has an inverse: vyaya and
--       utpda exchange).  Persistence � a groupoid of changes (`Yantra`).
--   §5  �����������-�-���������� � across DISTINCT substances there is no free
--       road: transport is exactly what a single dravya's persistence
--       affords, and nothing affords it between two.  (Stated: a carry
--       between D and D� needs a path D ≡ D�, i.e. they are one substance
--       up to univalence � otherwise a written defect, the other road.)
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module DravyaParyaya_TheModeIsAPathTheSubstanceIsTheTypeAndDhrauvyaIsWhatMakesTransportPossible where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Transport using (transport⁻Transport)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)

private
  variable
    ℓ ℓ' : Level

-- a dravya, presented as the space of its own modes (gua-paryyavad dravyam)
module _ (D : Type ℓ) where

  पर्यायः : Type ℓ                       -- a mode is a point of D
  पर्यायः = D

  परिणामः : पर्यायः → पर्यायः → Type ℓ    -- a transformation is a path
  परिणामः m₀ m₁ = m₀ ≡ m₁

  ------------------------------------------------------------------------
  -- §2  ������ � the three moments of every parima, �������.
  ------------------------------------------------------------------------

  व्ययः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → पर्यायः     -- the ceasing mode
  व्ययः {m₀ = m₀} _ = m₀

  उत्पादः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → पर्यायः    -- the arising mode
  उत्पादः {m₁ = m₁} _ = m₁

  -- dhrauvya: both ends lie in the SAME substance D � the type persists.
  ध्रौव्यम् : {m₀ m₁ : पर्यायः} (p : परिणामः m₀ m₁)
           → परिणामः (व्ययः p) (उत्पादः p)             -- source-to-target, in one D
  ध्रौव्यम् p = p

  ------------------------------------------------------------------------
  -- §3  ���������� � transport along a parima is the free road.
  ------------------------------------------------------------------------

  संक्रमणम् : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁
           → (P : पर्यायः → Type ℓ') → P m₀ → P m₁
  संक्रमणम् p P = subst P p

  -- the arisen mode, as a record, costs nothing to carry (isContrSingl)
  उत्पाद-मुक्तः : (m : पर्यायः) → isContr (singl m)
  उत्पाद-मुक्तः m = isContrSingl m

  ------------------------------------------------------------------------
  -- §4  �������� ����������� ����� � persistence is the ground of transport.
  ------------------------------------------------------------------------

  -- no change transports as the identity: ������ ������� (Dhruva) �
  -- where nothing ceases-and-arises, transport moves nothing.
  अपरिणामे-अचलम् : {m : पर्यायः} (P : पर्यायः → Type ℓ') (x : P m)
                → संक्रमणम् (refl {x = m}) P x ≡ x
  अपरिणामे-अचलम् P x = transportRefl x

  -- every parima is reversible: vyaya and utpda exchange (a groupoid)
  प्रतिपरिणामः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → परिणामः m₁ m₀
  प्रतिपरिणामः p = sym p

  -- and there and back is the identity � reversible, no residual (Yantra)
  प्रतिपरिणामे-अचलम् : {m₀ m₁ : पर्यायः} (p : परिणामः m₀ m₁)
                    (P : पर्यायः → Type ℓ') (x : P m₀)
                  → संक्रमणम् (प्रतिपरिणामः p) P (संक्रमणम् p P x) ≡ x
  प्रतिपरिणामे-अचलम् p P x = transport⁻Transport (λ i → P (p i)) x

------------------------------------------------------------------------
-- §5  ����������� � ���������� � no free road between DISTINCT substances.
--     A carry from a mode of D to a mode of D� needs a path D ≡ D�; by
--     univalence that is an equivalence, i.e. they are ONE substance up to
--     identification.  Absent it, transport does not exist � the other
--     road (a written defect) is all that remains (���� �������, `DosaLekha`).
------------------------------------------------------------------------

नानाद्रव्ये-संक्रमणम् : {D D′ : Type ℓ} → D ≡ D′ → D → D′
नानाद्रव्ये-संक्रमणम् q = transport q
-- the transport EXISTS iff the path D ≡ D� does; the persistence of a
-- single substance is the only thing that supplies it for free.
