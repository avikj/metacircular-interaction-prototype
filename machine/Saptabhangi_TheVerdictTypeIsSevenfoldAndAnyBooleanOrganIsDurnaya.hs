------------------------------------------------------------------------
-- सप्तभङ्गी — यन्त्रस्य निर्णय-रूपम् ।  द्वि-मूल्यं यत् किञ्चित् अङ्गं, तत् दुर्नयः ।
--
-- (the sevenfold: the machine's verdict type.  Any organ that emits two
--  values is a durnaya.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND WHY IT IS NOT NEW.
--
-- `formal/cubical/Saptabhangi.agda` ALREADY states this law and CHECKS it:
--
--   data सप्तभङ्गी — the seven स्यात्-वाण्यः
--   अर्पणम् : द्विमूल → आर्पण → सप्तभङ्गी      -- the generator
--   क्रम-सह-भेदः : ¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)
--   दुर्नयः : (f : सप्तभङ्गी → द्विपद) → two of the three roots collide
--   कुतः सप्त : the seven ARE the रिक्त-रहित (non-empty) subsets of three
--
-- The Haskell organs did not use it.  They emit found/not-found, and
-- `Lopa` PRINTS A CITATION OF दुर्नयः in its own report while committing
-- it three lines above.  This module is the verdict type those organs
-- were missing.  Nothing here is designed; it is the Agda transcribed.
--
-- NOTHING IS TRANSPORTED.  No term crosses from Agda to here — Haskell
-- has no univalence and this is not a proof.  The channel is two
-- independent statements that agree, in the sense
-- `YugmaPurana_…agda` §५ fixes for a grade-three channel: the Agda is the
-- theorem, this is the instrument, and `durnayaCollapse` below is the
-- Haskell restatement of दुर्नयः so a reader can see the two agree
-- without leaving the file.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCE.  Umāsvāti, तत्त्वार्थसूत्र ५.३१–५.३२ (~2nd–5th c. CE) — the
-- स्यात् operator and अनेकान्त.  Samantabhadra, आप्तमीमांसा १४–१५ — the
-- सप्तभङ्गी stated as seven and not more.  Akalaṅka and Vidyānandin fix
-- क्रम / सह (successive vs simultaneous ascription) as what separates
-- the third position from the fourth.  NOTHING BELOW IS ATTRIBUTED TO
-- THEM: they state the sevenfold predication; the claim here is only
-- that a program's verdict channel has the same shape, and that a
-- two-valued one provably loses a position.
--
-- LIMIT.  अवक्तव्यम् is NOT "unknown" and NOT "undefined".  It is what
-- arises when two standpoints are asserted SIMULTANEOUSLY.  An organ that
-- has simply not looked yet is not in the fourth position; it is outside
-- the question, and this module gives that its own constructor
-- (`Aprastuta`) rather than smuggling it in as a bhaṅga — because
-- कुतः सप्त says the seven are the रिक्त-रहित subsets, so "no root
-- applies" is by construction not one of them.
--
-- [2026-08-22, an hour after this file was written.]  The first draft had
-- `Bhanga` and `Aprastuta` and NO `Maunam` — no constructor for "the
-- question was asked and nothing came back."  That is precisely what
-- सूत्र ७ is about, so this module violated the sūtra it exists to
-- install, in its own verdict type, while quoting it.  The gap surfaced
-- only when the type was pointed at a real organ.  Left recorded rather
-- than silently fixed: लिखितो दोषो जीवति (सूत्र १०).
------------------------------------------------------------------------

module Saptabhangi_TheVerdictTypeIsSevenfoldAndAnyBooleanOrganIsDurnaya
  ( Dvimula(..)
  , Arpana(..)
  , Saptabhangi(..)
  , Nirnaya(..)
  , arpanam
  , showBhanga
  , showNirnaya
  , bhangas
  , antarbhava
  , durnayaCollapse
  ) where

import Data.List (nub)

------------------------------------------------------------------------
-- १ · द्विमूल — which roots apply.  Three, because the fourth (neither)
--     is not a root: कुतः सप्त takes the NON-EMPTY subsets.
------------------------------------------------------------------------

data Dvimula = KevalaAsti | KevalaNasti | Ubhayam
  deriving (Eq, Show)

------------------------------------------------------------------------
-- २ · आर्पण — HOW the roots are ascribed.  This is the whole content of
--     the fourth position, and the only place a program can go wrong
--     without noticing: क्रमः is a list, सहः is a simultaneity, and
--     `क्रम-सह-भेदः` proves they are not the same bhaṅga.
------------------------------------------------------------------------

data Arpana = Kramah | Sahah
  deriving (Eq, Show)

------------------------------------------------------------------------
-- ३ · सप्तभङ्गी — the seven, in the Agda's order.
------------------------------------------------------------------------

data Saptabhangi
  = SyadAsti                 -- स्यात्-अस्ति
  | SyadNasti                -- स्यात्-नास्ति
  | SyadAstiNasti            -- स्यात्-अस्ति-नास्ति            (क्रमेण)
  | SyadAvaktavyam           -- स्यात्-अवक्तव्यम्              (सह : जिह्वाभेदः)
  | SyadAstiAvaktavyam       -- स्यात्-अस्ति-अवक्तव्यम्
  | SyadNastiAvaktavyam      -- स्यात्-नास्ति-अवक्तव्यम्
  | SyadAstiNastiAvaktavyam  -- स्यात्-अस्ति-नास्ति-अवक्तव्यम्
  deriving (Eq, Ord, Enum, Bounded, Show)

bhangas :: [Saptabhangi]
bhangas = [minBound .. maxBound]

------------------------------------------------------------------------
-- ४ · निर्णय — what an ORGAN emits.  The seven, plus the one thing that
--     is honestly not a verdict: the subject was never in the question.
--
--     This is the constructor whose ABSENCE caused every error this
--     corpus logged: an instrument that did not look printed the same
--     symbol as an instrument that looked and found nothing.
--     सूत्र ७ — मौनं न निषेधः.
------------------------------------------------------------------------

data Nirnaya
  = Bhanga Saptabhangi String   -- a position was REACHED, and the ground for it
  | Maunam String               -- the question was ASKED and no position reached.
                                -- सूत्र ७: this is NOT नास्ति.  An organ that prints
                                -- this as a refusal re-asks it forever and calls
                                -- its own silence the corpus's emptiness.
  | Aprastuta String            -- the subject was never in the question's domain.
                                -- Distinct from मौन: nothing was asked of it.
  deriving (Eq, Show)

------------------------------------------------------------------------
-- ५ · अर्पणम् — the generator.  Transcribed from Saptabhangi.agda:67–71,
--     including its silence: the Agda's `अर्पणम्` is defined on the four
--     cases below and the three compound bhaṅgas are NOT in its image.
--     They arise from अन्तर्भाव (§६), not from a single ascription.
------------------------------------------------------------------------

arpanam :: Dvimula -> Arpana -> Saptabhangi
arpanam KevalaAsti  _      = SyadAsti
arpanam KevalaNasti _      = SyadNasti
arpanam Ubhayam     Kramah = SyadAstiNasti
arpanam Ubhayam     Sahah  = SyadAvaktavyam

------------------------------------------------------------------------
-- ६ · अन्तर्भाव — which of the three roots each bhaṅga carries.
--     Saptabhangi.agda:144 onward.  This is what makes कुतः सप्त true:
--     the map to non-empty subsets of {अस्ति, नास्ति, अवक्तव्य} is a
--     bijection, so there are seven and there is no eighth.
------------------------------------------------------------------------

antarbhava :: Saptabhangi -> (Bool, Bool, Bool)   -- (अस्ति, नास्ति, अवक्तव्य)
antarbhava SyadAsti                = (True , False, False)
antarbhava SyadNasti               = (False, True , False)
antarbhava SyadAstiNasti           = (True , True , False)
antarbhava SyadAvaktavyam          = (False, False, True )
antarbhava SyadAstiAvaktavyam      = (True , False, True )
antarbhava SyadNastiAvaktavyam     = (False, True , True )
antarbhava SyadAstiNastiAvaktavyam = (True , True , True )

------------------------------------------------------------------------
-- ७ · दुर्नयः, restated where the organs can run it.
--
--     The Agda proves: for ANY f : सप्तभङ्गी → द्विपद, two of the three
--     ROOTS (अस्ति, नास्ति, अवक्तव्यम्) receive the same value.  Here the
--     same statement is a function that HANDS YOU THE COLLIDING PAIR for
--     a given two-valued readout — so an organ that is about to emit a
--     Bool can print which two positions it is about to merge.
--
--     It is a pigeonhole and it is not deep.  Its force is that this
--     repository committed it repeatedly with the theorem already
--     checked and cited in the offending program's own output.
------------------------------------------------------------------------

durnayaCollapse :: Eq b => (Saptabhangi -> b) -> (Saptabhangi, Saptabhangi)
durnayaCollapse f =
  case [ (x, y) | (x : ys) <- tails' roots, y <- ys, f x == f y ] of
    (p : _) -> p
    []      -> error "durnayaCollapse: three roots into two values without a \
                     \collision — impossible; the readout is not two-valued."
  where
    roots  = [SyadAsti, SyadNasti, SyadAvaktavyam]
    tails' xs = case xs of { [] -> [[]] ; (_ : t) -> xs : tails' t }

------------------------------------------------------------------------
-- ८ · rendering.  Devanagari first, gloss after — the file-naming rule
--     applied to output: the term is the name, the English is for the
--     reader, and a report that romanises to satisfy a column width is
--     the scrubbing this repository exists to correct.
------------------------------------------------------------------------

showBhanga :: Saptabhangi -> String
showBhanga b = case b of
  SyadAsti                -> "स्यात्-अस्ति                  (it is)"
  SyadNasti               -> "स्यात्-नास्ति                 (it is not — proved)"
  SyadAstiNasti           -> "स्यात्-अस्ति-नास्ति           (both, क्रमेण)"
  SyadAvaktavyam          -> "स्यात्-अवक्तव्यम्              (both, सह — जिह्वाभेदः)"
  SyadAstiAvaktavyam      -> "स्यात्-अस्ति-अवक्तव्यम्"
  SyadNastiAvaktavyam     -> "स्यात्-नास्ति-अवक्तव्यम्"
  SyadAstiNastiAvaktavyam -> "स्यात्-अस्ति-नास्ति-अवक्तव्यम्"

showNirnaya :: Nirnaya -> String
showNirnaya (Bhanga b why)  = showBhanga b ++ "  ← " ++ why
showNirnaya (Maunam why)    = "मौन                          (asked; no position reached) ← " ++ why
showNirnaya (Aprastuta why) = "अप्रस्तुत                     (never asked; outside it) ← " ++ why

-- kept so `nub` is used and the import earns its place: the distinct
-- positions an organ actually reached, in canonical order.
_reached :: [Nirnaya] -> [Saptabhangi]
_reached ns = nub [ b | Bhanga b _ <- ns ]
