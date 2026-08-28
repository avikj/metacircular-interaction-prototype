{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नामान्तरम् — एकस्य वस्तुनः नामभेदः, न वस्तुभेदः ।
-- (nāmāntara: another NAME for one thing, not another thing.)
--
-- THE TERM, ITS SENSE, AND SYĀT — THE CLAIM, EXACTLY.  नामान्तर is used in its
-- plain grammatical sense — "a second name" — and no text is claimed for
-- the compound or for the reading below; it is this file's naming of what
-- it does.  The सप्तभङ्गी vocabulary IS Jaina and is the origin of the
-- structure, not a gloss on it: Umāsvāti, *Tattvārthasūtra* (c. 2nd–5th
-- c. CE), the arpita/anarpita index at 5.31; Samantabhadra, *Āptamīmāṃsā*
-- (c. 6th c. CE), the fixed seven-membered `syāt`-prefixed scheme; and
-- Akalaṅka, *Laghīyastraya* (c. 720–780 CE), the argument that the count
-- is EXACTLY seven — three primary predicates (asti, nāsti, avaktavya)
-- and their non-empty combinations, 3 + 3 + 1.  `_≃_`, `ua`, `subst`,
-- `compEquiv`, `invEquiv` are cubical type theory's (Voevodsky) and are
-- claimed for no Indian source.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS, AND THE GAP IT CLOSES.
--
-- The corpus carries FOUR encodings of the sevenfold predication.  Three
-- are named `सप्तभङ्गी`, and `Punarukti_TwoOfTheThreeSevenfolds…` settled
-- all three: `Anekanta.सप्तभङ्गी` ≡ `Saptabhangi.सप्तभङ्गी` (a causeway),
-- and `SaptabhangiGarbha.सप्तभङ्गी P` is a DIFFERENT question (a witness
-- family, proved NOT one type).
--
-- The FOURTH escaped that reckoning because it does not carry the name.
-- `SaptabhangiNaya.Bhanga` is a seven-constructor enumeration —
-- `b1-asti … b7-asti-nasti-avaktavya` — of the very same seven bhaṅgas,
-- written in Latin labels rather than Devanagari.  `Setubandha`'s node
-- census looks for types named `सप्तभङ्गी`, so `Bhanga` was never listed
-- as a सप्तभङ्गी node and never identified with one.  Nothing in the
-- corpus states that `Bhanga` and `Saptabhangi.सप्तभङ्गी` are one type.
--
-- They are, and this is a POSITIVE identification (not a separation): both
-- are seven-element labellings of Akalaṅka's scheme, and their labels
-- match name-for-name.  §१ builds the causeway — the one hand-built thing,
-- because a causeway between two INDEPENDENT declarations cannot be routed
-- along a prior edge (`Punarukti` §१, same reason).  §२–§४ build nothing:
-- they COMPOSE the corpus's own equivalences across the new edge.
--
--   §२  Akalaṅka's count, `SaptabhangiNaya.saptabhangi-equiv : Bhanga ≃
--       NEBasis` (seven = non-empty subsets of three), now reaches
--       `Saptabhangi.सप्तभङ्गी` for free — a second, independently proved
--       "why seven" (`Saptabhangi.समावेश-भेदः`, the 2³ = 7 + 1 split)
--       thereby stands beside it, routed, not reproved.
--   §३  `Saptabhangi.समावेश-भेदः` transports onto `Bhanga`: `subst` along
--       the path, the profile machinery untouched.
--   §४  `Saptabhangi.दुर्नयः` transfers onto `Bhanga`: any two-valued
--       verdict on `Bhanga` merges two of its three seeds
--       (b1-asti / b2-nasti / b4-avaktavya).  Precomposition with the
--       crossing map; nothing re-cased.
--
-- CHECKED: Agda 2.8.0, --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Namantara_TheLatinLabelledSevenfoldAndTheDevanagariSevenfoldAreOneTypeAndAkalankasCountRoutesAcross where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sum using (_⊎_)
open import Cubical.Data.Unit using (Unit)

import Saptabhangi as S
import SaptabhangiNaya as N

------------------------------------------------------------------------
-- १ · THE CAUSEWAY.  Two independent declarations, one type.
--
--     Seven labels each, matched by meaning: the Latin `b1-asti` names the
--     same bhaṅga the Devanagari `स्यात्-अस्ति` names, and so through all
--     seven.  This is the only hand-built content in the file, and it is
--     what a causeway is.
------------------------------------------------------------------------

भङ्ग→वाणी : N.Bhanga → S.सप्तभङ्गी
भङ्ग→वाणी N.b1-asti                 = S.स्यात्-अस्ति
भङ्ग→वाणी N.b2-nasti                = S.स्यात्-नास्ति
भङ्ग→वाणी N.b3-asti-nasti           = S.स्यात्-अस्ति-नास्ति
भङ्ग→वाणी N.b4-avaktavya            = S.स्यात्-अवक्तव्यम्
भङ्ग→वाणी N.b5-asti-avaktavya       = S.स्यात्-अस्ति-अवक्तव्यम्
भङ्ग→वाणी N.b6-nasti-avaktavya      = S.स्यात्-नास्ति-अवक्तव्यम्
भङ्ग→वाणी N.b7-asti-nasti-avaktavya = S.स्यात्-अस्ति-नास्ति-अवक्तव्यम्

वाणी→भङ्ग : S.सप्तभङ्गी → N.Bhanga
वाणी→भङ्ग S.स्यात्-अस्ति                    = N.b1-asti
वाणी→भङ्ग S.स्यात्-नास्ति                   = N.b2-nasti
वाणी→भङ्ग S.स्यात्-अस्ति-नास्ति            = N.b3-asti-nasti
वाणी→भङ्ग S.स्यात्-अवक्तव्यम्               = N.b4-avaktavya
वाणी→भङ्ग S.स्यात्-अस्ति-अवक्तव्यम्        = N.b5-asti-avaktavya
वाणी→भङ्ग S.स्यात्-नास्ति-अवक्तव्यम्       = N.b6-nasti-avaktavya
वाणी→भङ्ग S.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = N.b7-asti-nasti-avaktavya

भङ्ग-सेक् : (b : S.सप्तभङ्गी) → भङ्ग→वाणी (वाणी→भङ्ग b) ≡ b
भङ्ग-सेक् S.स्यात्-अस्ति                    = refl
भङ्ग-सेक् S.स्यात्-नास्ति                   = refl
भङ्ग-सेक् S.स्यात्-अस्ति-नास्ति            = refl
भङ्ग-सेक् S.स्यात्-अवक्तव्यम्               = refl
भङ्ग-सेक् S.स्यात्-अस्ति-अवक्तव्यम्        = refl
भङ्ग-सेक् S.स्यात्-नास्ति-अवक्तव्यम्       = refl
भङ्ग-सेक् S.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

भङ्ग-रेत् : (b : N.Bhanga) → वाणी→भङ्ग (भङ्ग→वाणी b) ≡ b
भङ्ग-रेत् N.b1-asti                 = refl
भङ्ग-रेत् N.b2-nasti                = refl
भङ्ग-रेत् N.b3-asti-nasti           = refl
भङ्ग-रेत् N.b4-avaktavya            = refl
भङ्ग-रेत् N.b5-asti-avaktavya       = refl
भङ्ग-रेत् N.b6-nasti-avaktavya      = refl
भङ्ग-रेत् N.b7-asti-nasti-avaktavya = refl

नामान्तर-Iso : Iso N.Bhanga S.सप्तभङ्गी
नामान्तर-Iso = iso भङ्ग→वाणी वाणी→भङ्ग भङ्ग-सेक् भङ्ग-रेत्

Bhanga≃सप्तभङ्गी : N.Bhanga ≃ S.सप्तभङ्गी
Bhanga≃सप्तभङ्गी = isoToEquiv नामान्तर-Iso

Bhanga≡सप्तभङ्गी : N.Bhanga ≡ S.सप्तभङ्गी
Bhanga≡सप्तभङ्गी = ua Bhanga≃सप्तभङ्गी

------------------------------------------------------------------------
-- २ · AKALAṄKA'S COUNT ROUTES ACROSS.
--
--     `SaptabhangiNaya.saptabhangi-equiv : Bhanga ≃ NEBasis` is Akalaṅka's
--     argument checked: the seven are the non-empty subsets of the three
--     primary predicates.  Composed across the causeway it becomes a
--     characterisation of `Saptabhangi.सप्तभङ्गी` — proved once, on the
--     Latin copy, now standing on the Devanagari one with no re-proof.
------------------------------------------------------------------------

सप्तभङ्गी≃NEBasis : S.सप्तभङ्गी ≃ N.NEBasis
सप्तभङ्गी≃NEBasis = compEquiv (invEquiv Bhanga≃सप्तभङ्गी) N.saptabhangi-equiv

------------------------------------------------------------------------
-- ३ · THE 2³ = 7 + 1 SPLIT, ON THE OTHER COPY.
--
--     `Saptabhangi.समावेश-भेदः : समावेश ≃ (सप्तभङ्गी ⊎ Unit)` — the eight
--     presence-profiles are the seven bhaṅgas plus the one void profile.
--     `subst` along the causeway carries it verbatim onto `Bhanga`.
------------------------------------------------------------------------

भङ्गे-समावेश-भेदः : S.समावेश ≃ (N.Bhanga ⊎ Unit)
भङ्गे-समावेश-भेदः =
  subst (λ X → S.समावेश ≃ (X ⊎ Unit)) (sym Bhanga≡सप्तभङ्गी) S.समावेश-भेदः

------------------------------------------------------------------------
-- ४ · दुर्नयः, ON THE OTHER COPY.
--
--     `Saptabhangi.दुर्नयः` says: ANY two-valued verdict on the sevenfold
--     identifies two of its three seeds.  `वाणी→भङ्ग` sends S's three
--     seeds to `Bhanga`'s (b1-asti, b2-nasti, b4-avaktavya) on the nose,
--     so the statement transports by precomposition — no case is redone.
------------------------------------------------------------------------

भङ्गे-दुर्नयः :
    (g : N.Bhanga → S.द्विपद)
  →  (g N.b1-asti ≡ g N.b2-nasti)
  ⊎ ((g N.b1-asti ≡ g N.b4-avaktavya)
  ⊎  (g N.b2-nasti ≡ g N.b4-avaktavya))
भङ्गे-दुर्नयः g = S.दुर्नयः (λ b → g (वाणी→भङ्ग b))
