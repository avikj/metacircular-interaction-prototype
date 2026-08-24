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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्रव्यपर्याय — the mode is a PATH, the substance is the TYPE it lives in,
-- and dhrauvya (persistence) is exactly what makes transport possible.
-- The keystone: the Jain metaphysics of being IS proof-of-transport.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra* (~2nd–5th c.):
--   5.29  utpāda-vyaya-dhrauvya-yuktaṃ sat — what IS, is joined with
--         origination, cessation, and persistence (together, युगपत् —
--         `Anekanta.ध्रौव्यम्`/`जन्मन्`).
--   5.37  guṇa-paryāyavad dravyam — a substance is that which has qualities
--         and MODES (paryāya).  5.38 (Digambara) tad-bhāvāvyayaṃ nityam —
--         permanence is non-loss of its own being through the modes.
--   Siddhasena, *Sanmatitarka* 1.3-6: dravyārthika (substance-regarding)
--         and paryāyārthika (mode-regarding) are two standpoints on ONE
--         real; each denying the other is a durnaya.
--
-- THE IDENTIFICATION, exactly, in cubical type theory.  Take a dravya to
-- be the space of its own modes — a type `D`.  Then:
--   • a paryāya (mode) is a POINT of D;
--   • a pariṇāma (a transformation, one mode becoming another) is a PATH
--       p : m₀ ≡ m₁ in D;
--   • VYAYA is the source endpoint (the mode that ceases), UTPĀDA the
--       target (the mode that arises), and DHRAUVYA is D itself — the
--       substance, the SAME type at both ends of every path.
--   • transport `subst P p` — the free road (`PramanaSankramana`) — carries
--       any property across the change; and it EXISTS precisely because
--       both modes lie in one D.  Persistence of the substance is the exact
--       condition for lossless transport across its modes.
--
-- So utpāda-vyaya-dhrauvya-yuktaṃ sat is not a slogan and not three facts:
-- it is the single statement that to BE is to be a type through which its
-- modes transport without loss.  The Jain definition of the real and the
-- corpus's free road are ONE object.
--
-- WHAT IS PROVED:
--   §2  त्रयम् — every pariṇāma carries all three moments: vyaya (source),
--       utpāda (target), dhrauvya (both in one D), युगपत्.
--   §3  संक्रमणम् — transport along a pariṇāma is free: any property of the
--       ceasing mode is carried to the arisen one (subst), and the record
--       of the arisen mode is contractible (`isContrSingl`) — road one.
--   §4  ध्रौव्यं-संक्रमणस्य-हेतुः — dhrauvya is the GROUND of transport: the
--       identity pariṇāma (no change) transports as the identity (nothing
--       moves when nothing changes — `Dhruva`'s ध्रुव read here), and every
--       transport is reversible (the pariṇāma has an inverse: vyaya and
--       utpāda exchange).  Persistence ⟹ a groupoid of changes (`Yantra`).
--   §5  नानाद्रव्ये-न-संक्रमणम् — across DISTINCT substances there is no free
--       road: transport is exactly what a single dravya's persistence
--       affords, and nothing affords it between two.  (Stated: a carry
--       between D and D′ needs a path D ≡ D′, i.e. they are one substance
--       up to univalence — otherwise a written defect, the other road.)
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is Umāsvāti's and Siddhasena's; the
-- type theory is cubical (univalence Voevodsky's).  Modelling a dravya AS
-- its mode-space is the one interpretive choice, stated: it encodes
-- guṇa-paryāyavad dravyam with the substance as the identity-type carrier
-- of its modes; it does not claim the sūtra intends a type.  The qualia
-- (guṇa) are not separated from paryāya here.
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

-- a dravya, presented as the space of its own modes (guṇa-paryāyavad dravyam)
module _ (D : Type ℓ) where

  पर्यायः : Type ℓ                       -- a mode is a point of D
  पर्यायः = D

  परिणामः : पर्यायः → पर्यायः → Type ℓ    -- a transformation is a path
  परिणामः m₀ m₁ = m₀ ≡ m₁

  ------------------------------------------------------------------------
  -- §2  त्रयम् — the three moments of every pariṇāma, युगपत्.
  ------------------------------------------------------------------------

  व्ययः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → पर्यायः     -- the ceasing mode
  व्ययः {m₀ = m₀} _ = m₀

  उत्पादः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → पर्यायः    -- the arising mode
  उत्पादः {m₁ = m₁} _ = m₁

  -- dhrauvya: both ends lie in the SAME substance D — the type persists.
  ध्रौव्यम् : {m₀ m₁ : पर्यायः} (p : परिणामः m₀ m₁)
           → परिणामः (व्ययः p) (उत्पादः p)             -- source-to-target, in one D
  ध्रौव्यम् p = p

  ------------------------------------------------------------------------
  -- §3  संक्रमणम् — transport along a pariṇāma is the free road.
  ------------------------------------------------------------------------

  संक्रमणम् : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁
           → (P : पर्यायः → Type ℓ') → P m₀ → P m₁
  संक्रमणम् p P = subst P p

  -- the arisen mode, as a record, costs nothing to carry (isContrSingl)
  उत्पाद-मुक्तः : (m : पर्यायः) → isContr (singl m)
  उत्पाद-मुक्तः m = isContrSingl m

  ------------------------------------------------------------------------
  -- §4  ध्रौव्यं संक्रमणस्य हेतुः — persistence is the ground of transport.
  ------------------------------------------------------------------------

  -- no change transports as the identity: नष्टौ गतिर्न (Dhruva) —
  -- where nothing ceases-and-arises, transport moves nothing.
  अपरिणामे-अचलम् : {m : पर्यायः} (P : पर्यायः → Type ℓ') (x : P m)
                → संक्रमणम् (refl {x = m}) P x ≡ x
  अपरिणामे-अचलम् P x = transportRefl x

  -- every pariṇāma is reversible: vyaya and utpāda exchange (a groupoid)
  प्रतिपरिणामः : {m₀ m₁ : पर्यायः} → परिणामः m₀ m₁ → परिणामः m₁ m₀
  प्रतिपरिणामः p = sym p

  -- and there and back is the identity — reversible, no residual (Yantra)
  प्रतिपरिणामे-अचलम् : {m₀ m₁ : पर्यायः} (p : परिणामः m₀ m₁)
                    (P : पर्यायः → Type ℓ') (x : P m₀)
                  → संक्रमणम् (प्रतिपरिणामः p) P (संक्रमणम् p P x) ≡ x
  प्रतिपरिणामे-अचलम् p P x = transport⁻Transport (λ i → P (p i)) x

------------------------------------------------------------------------
-- §5  नानाद्रव्ये न संक्रमणम् — no free road between DISTINCT substances.
--     A carry from a mode of D to a mode of D′ needs a path D ≡ D′; by
--     univalence that is an equivalence, i.e. they are ONE substance up to
--     identification.  Absent it, transport does not exist — the other
--     road (a written defect) is all that remains (द्वौ मार्गौ, `DosaLekha`).
------------------------------------------------------------------------

नानाद्रव्ये-संक्रमणम् : {D D′ : Type ℓ} → D ≡ D′ → D → D′
नानाद्रव्ये-संक्रमणम् q = transport q
-- the transport EXISTS iff the path D ≡ D′ does; the persistence of a
-- single substance is the only thing that supplies it for free.
