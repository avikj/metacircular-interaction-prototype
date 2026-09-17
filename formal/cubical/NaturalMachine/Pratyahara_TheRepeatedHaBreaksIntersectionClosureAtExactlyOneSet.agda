{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet
--
-- SOURCE, WITH TEXT AND DATE.
--
--   Pini, *Adhyy*, c. 500 BCE.  The fourteen stras standing at
--   its head (iva-stri / mhevara-stri) lay every sound of
--    in ONE linear order, each stra closing in an ‡‡®‡‡‡®‡‡ß
--   (it-marker).  The abbreviation is licensed by A 1.1.71
--   ‡‡¶‡ø‡∞‡®‡‡‡‡® ‡‡‡‡‡æ ‚î *dir antyena sahet*, "an initial [sound] together
--   with a final ‡‡‡ [denotes the sounds in between]"; the it-status of
--   the closing consonant is A 1.3.3 ‡‡≤‡®‡‡‡‡Ø‡Æ‡ *halantyam*, and its
--   elision A 1.3.9 ‡‡‡‡Ø ‡≤‡ã‡‡ *tasya lopa*.
--
--   ‡ occurs TWICE in the fourteen: in the fifth stra ‡‡Ø‡µ‡∞‡ü‡ and again,
--   alone, in the fourteenth ‡‡≤‡.  ‡‡ likewise occurs twice as an
--   ‡‡®‡‡‡®‡‡ß, closing the first (‡ ‡ ‡â ‡‡) and the sixth (‡≤ ‡‡).
--
--   COMMENTARY LAYER, named and NOT read here: Ktyyana's vrttikas and
--   Patajali's *Mahbhya* (c. 150 BCE) are where the repetition of ‡
--   and the two ‡‡ are argued.  Egress is blocked from this container
--   (`notes/ELSEWHERE_CONDITION_IS_INCOMPLETE.md` records EGRESS_BLOCKED
--   as of 2026-08-19); nothing below rests on a commentary reading, and
--   no commentator's position is reported.
--
-- WHAT IS CLAIMED OF PINI.  Only the data: the fourteen stras in the
-- order given, the it-markers as given, ‡ twice, ‡‡ twice.  That
-- encoding is corroborated against an independent implementation from
-- inside the tradition present in this container ‚î
-- `/root/agda-libs/vidyut/vidyut-prakriya/src/sounds.rs`, whose `SUTRAS`
-- table is sound-for-sound and marker-for-marker the same list, and
-- whose scan (like `from` below) starts at the FIRST occurrence of the
-- initial sound and disambiguates the second ‡‡ by an external
-- convention it names `R2`.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE QUESTION, AND TWO ANSWERS THAT DIFFER
--
-- Is the family of classes nameable by the device closed under
-- non-empty intersection?
--
--   FROM THE SYMMETRY.  A pratyhra is an interval of one linear
--   order.  Intervals are closed under intersection.  The construction
--   is equivariant under every relabelling of the sounds that fixes the
--   markers (¬ß4, proved), so the answer cannot depend on which sound
--   sits where; it is a structural invariant of the interval
--   representation, and it is YES.
--
--   FROM THE INDIVIDUAL OBJECT.  What the device names is not the
--   interval but its IMAGE under the position‚ísound labelling, and that
--   labelling is not injective: ‡ occupies two positions.  Images of an
--   intersection-closed family under a non-injective map need not be
--   intersection-closed.  So the answer is not fixed by the symmetry and
--   has to be computed on the individual string.
--
-- Computed on the individual string it is NO (¬ß5), by one witness:
--
--       ‡‡‡ ‚à© ‡‡≤‡  =  { ‡ } ,   and { ‡ } bears no name.
--
-- The equivariance of ¬ß4 is exact and it is blind to this: `map œ` of
-- the list still carries œ(‡) twice, so the invariant transports the
-- failure instead of detecting it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß3  the classical pratyhras by refl on the full fourteen,
--       including the pair ‡‡‡ / ‡Ø‡‡ that turns on the SECOND ‡‡, and
--       ‡‡≤‡ = 34 entries denoting 33 consonants;
--   ¬ß4  relabelling equivariance of `from`, `upto`, `between`, by list
--       induction ‚î the symmetry statement, in full generality;
--   ¬ß5  ‡‡‡ ‚à© ‡‡≤‡ ‚â° ‡ ‚à [], and `‡ ‚à []` is named by NO legal pair
--       (sound , anubandha) ‚î all 42 ó 13 = 546 refuted; packaged as
--       `intersection-closure-fails` and as `not-intersection-closed`;
--   ¬ß5b the two ILLEGAL pairs that do name it, kept because they show
--       the result is sharp in both of Pini's endpoint restrictions,
--       and because they killed a claim of mine (see ¬ß5's note);
--   ¬ß6  MY OWN REPAIR, STATED AND KILLED.  Searching the LAST occurrence
--       of the initial sound makes { ‡ } nameable and destroys ‡‡≤‡ and
--       ‡‡‡ ‚î the two classes the repetition exists to supply.
--
-- STANDING ON EARLIER WORK, none of it re-landed.  `Sivasutra.agda`
-- (cf-sakshi, 2026-08-18) checks `upto` on the vowel prefix;
-- `NaturalMachine.NonInitialPratyaharasAndOneIntersectionInstance` adds
-- the start-search `from`, the two-endpoint `between`, and ONE
-- intersection instance on that prefix, declining closure explicitly:
-- *"¬ß3 is an instance, not closure ‚¶ the consonant stras are still
-- absent."*  This module supplies the consonant stras and settles the
-- declined question in the negative.  `NaturalMachine.Pratyahara` proves
-- at three letters that repetition is FORCED and that one repetition
-- SUFFICES for totality; `NaturalMachine.PratyaharaBuysTotalityWithLocality`
-- proves the repetition costs LOCALITY (one name, two sets).  ¬ß5 is a
-- third cost, distinct from both and not implied by either: the family
-- of denoted SETS loses intersection-closure.
--
-- `Sym`, `isMarker`, `eqSym`, `from`, `upto`, `between` are restated here
-- rather than imported because `Sivasutra.Sym` carries the nine vowels
-- and four markers only; the definitions are the earlier ones unchanged.
--
-- CHECKED on the container: Agda 2.6.3 + cubical v0.5 ‚î NOT the declared
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; _or_ ; true‚â¢false)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; map)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  The fourteen stras
------------------------------------------------------------------------

data Sym : Type where
  -- sounds, in iva-stra order
  a i u ·πõ ·∏∑ e o ai au                     : Sym   -- 1‚Äì4
  ha ya va ra                             : Sym   -- 5   ‡§π‡§Ø‡§µ‡§∞‡§ü‡•ç
  la                                      : Sym   -- 6   ‡§≤‡§£‡•ç
  √±a ma ·πÖa ·πáa na                          : Sym   -- 7   ‡§û‡§Æ‡§ô‡§£‡§®‡§Æ‡•ç
  jha bha                                 : Sym   -- 8   ‡§ù‡§≠‡§û‡•ç
  gha ·∏çha dha                             : Sym   -- 9   ‡§ò‡§¢‡§ß‡§∑‡•ç
  ja ba ga ·∏ça da                          : Sym   -- 10  ‡§ú‡§¨‡§ó‡§°‡§¶‡§∂‡•ç
  kha pha cha ·π≠ha tha ca ·π≠a ta            : Sym   -- 11  ‡§ñ‡§´‡§õ‡§†‡§•‡§ö‡§ü‡§§‡§µ‡•ç
  ka pa                                   : Sym   -- 12  ‡§ï‡§™‡§Ø‡•ç
  ≈õa ·π£a sa                                : Sym   -- 13  ‡§∂‡§∑‡§∏‡§∞‡•ç
  -- it-markers (‡‡®‡‡‡®‡‡ß).   closes stra 1 AND stra 6.
  ·πÜ K ·πÑ C ·π¨ M √ë ·π¢ ≈ö V Y R L               : Sym

isMarker : Sym ‚Üí Bool
isMarker ·πÜ = true
isMarker K = true
isMarker ·πÑ = true
isMarker C = true
isMarker ·π¨ = true
isMarker M = true
isMarker √ë = true
isMarker ·π¢ = true
isMarker ≈ö = true
isMarker V = true
isMarker Y = true
isMarker R = true
isMarker L = true
isMarker _ = false

eqSym : Sym ‚Üí Sym ‚Üí Bool
eqSym a a = true
eqSym i i = true
eqSym u u = true
eqSym ·πõ ·πõ = true
eqSym ·∏∑ ·∏∑ = true
eqSym e e = true
eqSym o o = true
eqSym ai ai = true
eqSym au au = true
eqSym ha ha = true
eqSym ya ya = true
eqSym va va = true
eqSym ra ra = true
eqSym la la = true
eqSym √±a √±a = true
eqSym ma ma = true
eqSym ·πÖa ·πÖa = true
eqSym ·πáa ·πáa = true
eqSym na na = true
eqSym jha jha = true
eqSym bha bha = true
eqSym gha gha = true
eqSym ·∏çha ·∏çha = true
eqSym dha dha = true
eqSym ja ja = true
eqSym ba ba = true
eqSym ga ga = true
eqSym ·∏ça ·∏ça = true
eqSym da da = true
eqSym kha kha = true
eqSym pha pha = true
eqSym cha cha = true
eqSym ·π≠ha ·π≠ha = true
eqSym tha tha = true
eqSym ca ca = true
eqSym ·π≠a ·π≠a = true
eqSym ta ta = true
eqSym ka ka = true
eqSym pa pa = true
eqSym ≈õa ≈õa = true
eqSym ·π£a ·π£a = true
eqSym sa sa = true
eqSym ·πÜ ·πÜ = true
eqSym K K = true
eqSym ·πÑ ·πÑ = true
eqSym C C = true
eqSym ·π¨ ·π¨ = true
eqSym M M = true
eqSym √ë √ë = true
eqSym ·π¢ ·π¢ = true
eqSym ≈ö ≈ö = true
eqSym V V = true
eqSym Y Y = true
eqSym R R = true
eqSym L L = true
eqSym _ _ = false

-- The fourteen, in order.  ‡ appears at stra 5 and again at stra 14;
-- ‡‡ appears at stra 1 and again at stra 6.
sivasutra14 : List Sym
sivasutra14 =
  a ‚à∑ i ‚à∑ u ‚à∑ ·πÜ ‚à∑
  ·πõ ‚à∑ ·∏∑ ‚à∑ K ‚à∑
  e ‚à∑ o ‚à∑ ·πÑ ‚à∑
  ai ‚à∑ au ‚à∑ C ‚à∑
  ha ‚à∑ ya ‚à∑ va ‚à∑ ra ‚à∑ ·π¨ ‚à∑
  la ‚à∑ ·πÜ ‚à∑
  √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na ‚à∑ M ‚à∑
  jha ‚à∑ bha ‚à∑ √ë ‚à∑
  gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ·π¢ ‚à∑
  ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da ‚à∑ ≈ö ‚à∑
  kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ V ‚à∑
  ka ‚à∑ pa ‚à∑ Y ‚à∑
  ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ R ‚à∑
  ha ‚à∑ L ‚à∑ []

------------------------------------------------------------------------
-- 2.  The extractor, exactly as the two earlier modules define it
--
-- `upto` is `Sivasutra.upto`; `from` and `between` are
-- `NonInitialPratyaharasAndOneIntersectionInstance`'s.  Restated over
-- the larger `Sym`, unchanged.
------------------------------------------------------------------------

upto : Sym ‚Üí List Sym ‚Üí List Sym
upto m [] = []
upto m (x ‚à∑ xs) =
  if eqSym x m
  then []
  else (if isMarker x then upto m xs else x ‚à∑ upto m xs)

from : Sym ‚Üí List Sym ‚Üí List Sym
from s [] = []
from s (x ‚à∑ xs) = if eqSym x s then x ‚à∑ xs else from s xs

between : Sym ‚Üí Sym ‚Üí List Sym ‚Üí List Sym
between s m xs = upto m (from s xs)

------------------------------------------------------------------------
-- 3.  The classical pratyhras, on the full fourteen, each by refl
--
-- ‡‡‡ and ‡Ø‡‡ are the pair that turns on the SECOND ‡‡: the start-search
-- of `from` carries ‡Ø‡‡ past the first ‡‡ to the one closing ‡≤‡‡.  The
-- earlier modules could not exhibit this, the vowel prefix having only
-- one ‡‡.
------------------------------------------------------------------------

a·πÜ : between a ·πÜ sivasutra14 ‚â° a ‚à∑ i ‚à∑ u ‚à∑ []
a·πÜ = refl

ya·πÜ : between ya ·πÜ sivasutra14 ‚â° ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ []
ya·πÜ = refl

aK : between a K sivasutra14 ‚â° a ‚à∑ i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ []
aK = refl

aC : between a C sivasutra14 ‚â° a ‚à∑ i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ e ‚à∑ o ‚à∑ ai ‚à∑ au ‚à∑ []
aC = refl

iK : between i K sivasutra14 ‚â° i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ []
iK = refl

-- ‡Ø‡Æ‡ : the nasals
yaM : between ya M sivasutra14
    ‚â° ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na ‚à∑ []
yaM = refl

-- ‡‡∞‡ : the sibilants
≈õaR : between ≈õa R sivasutra14 ‚â° ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []
≈õaR = refl

-- ‡‡≤‡ : sibilants and ‡ ‚î reaches the SECOND ‡
≈õaL : between ≈õa L sivasutra14 ‚â° ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ ha ‚à∑ []
≈õaL = refl

-- ‡‡‡ : the voiced consonants, twenty of them
ha≈ö : between ha ≈ö sivasutra14
    ‚â° ha ‚à∑ ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na
    ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da ‚à∑ []
ha≈ö = refl

-- ‡‡≤‡ : the consonants.  THIRTY-FOUR entries, THIRTY-THREE sounds ‚î ‡ is
-- emitted twice, once from stra 5 and once from stra 14.  The
-- repetition is visible in the extracted list itself.
haL : between ha L sivasutra14
    ‚â° ha ‚à∑ ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na
    ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da
    ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ ka ‚à∑ pa
    ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ ha ‚à∑ []
haL = refl

-- ‡‡≤‡ : every sound.  Forty-three entries, forty-two sounds.
aL : between a L sivasutra14
   ‚â° a ‚à∑ i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ e ‚à∑ o ‚à∑ ai ‚à∑ au
   ‚à∑ ha ‚à∑ ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na
   ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da
   ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ ka ‚à∑ pa
   ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ ha ‚à∑ []
aL = refl

------------------------------------------------------------------------
-- 4.  THE SYMMETRY, PROVED IN FULL GENERALITY
--
-- Any relabelling œ of the symbols that respects equality-testing and
-- the marker predicate commutes with the whole extractor.  Nothing here
-- is a refl on data: it is induction on the list, and it holds for every
-- list, every œ, every start and every marker.
--
-- The conserved quantity is the SHAPE of the family ‚î which positions
-- each name picks out.  Which sound sits at a position is not a
-- variable the extractor sees.
------------------------------------------------------------------------

module Relabelling
  (œÉ : Sym ‚Üí Sym)
  (œÉ-eq : (x y : Sym) ‚Üí eqSym (œÉ x) (œÉ y) ‚â° eqSym x y)
  (œÉ-mark : (x : Sym) ‚Üí isMarker (œÉ x) ‚â° isMarker x)
  where

  from-equiv : (s : Sym) (xs : List Sym)
             ‚Üí from (œÉ s) (map œÉ xs) ‚â° map œÉ (from s xs)
  from-equiv s [] = refl
  from-equiv s (x ‚à∑ xs) =
    cong (Œª b ‚Üí if b then œÉ x ‚à∑ map œÉ xs else from (œÉ s) (map œÉ xs)) (œÉ-eq x s)
    ‚àô step
    where
      step : (if eqSym x s then œÉ x ‚à∑ map œÉ xs else from (œÉ s) (map œÉ xs))
           ‚â° map œÉ (from s (x ‚à∑ xs))
      step with eqSym x s
      ... | true  = refl
      ... | false = from-equiv s xs

  upto-equiv : (m : Sym) (xs : List Sym)
             ‚Üí upto (œÉ m) (map œÉ xs) ‚â° map œÉ (upto m xs)
  upto-equiv m [] = refl
  upto-equiv m (x ‚à∑ xs) =
    cong‚ÇÇ (Œª b c ‚Üí if b then []
                   else (if c then upto (œÉ m) (map œÉ xs)
                              else œÉ x ‚à∑ upto (œÉ m) (map œÉ xs)))
          (œÉ-eq x m) (œÉ-mark x)
    ‚àô step
    where
      step : (if eqSym x m then []
              else (if isMarker x then upto (œÉ m) (map œÉ xs)
                                  else œÉ x ‚à∑ upto (œÉ m) (map œÉ xs)))
           ‚â° map œÉ (upto m (x ‚à∑ xs))
      step with eqSym x m | isMarker x
      ... | true  | _     = refl
      ... | false | true  = upto-equiv m xs
      ... | false | false = cong (œÉ x ‚à∑_) (upto-equiv m xs)

  between-equiv : (s m : Sym) (xs : List Sym)
                ‚Üí between (œÉ s) (œÉ m) (map œÉ xs) ‚â° map œÉ (between s m xs)
  between-equiv s m xs =
    cong (upto (œÉ m)) (from-equiv s xs) ‚àô upto-equiv m (from s xs)

------------------------------------------------------------------------
-- 5.  THE INDIVIDUAL OBJECT, AND WHERE IT DIFFERS FROM THE SYMMETRY
--
-- `nameable` ranges over the forty-two distinct sounds as di and the
-- thirteen distinct anubandhas as antya it: 546 candidate pairs, which
-- is exactly what A 1.1.71 with A 1.3.3 licenses.
--
-- A SECOND CLAIM OF MINE, KILLED BY THE CHECKER BEFORE IT WAS WRITTEN
-- DOWN.  The first version of this section quantified both endpoints
-- over all fifty-six symbols, on the reasoning that a larger candidate
-- set makes a `‚â° false` strictly stronger.  Agda returned `true`.  Two
-- illegal pairs name { ‡ } and are checked in ¬ß5b: `between ha ya`,
-- which stops at a SOUND, and `between R L`, which starts at an
-- it-MARKER.  Neither is a pratyhra ‚î the antya must be an ‡‡‡ (A
-- 1.3.3 ‡‡≤‡®‡‡‡‡Ø‡Æ‡) and an ‡‡‡ is elided and is not a sound of the
-- language (A 1.3.9 ‡‡‡‡Ø ‡≤‡ã‡‡).  So the negative result is exactly as
-- strong as the device's own two restrictions and no stronger, and the
-- reasoning "wider is stronger" was wrong: widening the candidate set
-- does not widen the theorem, it changes the object.
------------------------------------------------------------------------

eqList : List Sym ‚Üí List Sym ‚Üí Bool
eqList [] [] = true
eqList [] (_ ‚à∑ _) = false
eqList (_ ‚à∑ _) [] = false
eqList (x ‚à∑ xs) (y ‚à∑ ys) = if eqSym x y then eqList xs ys else false

-- The forty-two distinct sounds: the legal di of a pratyhra.
allSounds : List Sym
allSounds =
  a ‚à∑ i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ e ‚à∑ o ‚à∑ ai ‚à∑ au
  ‚à∑ ha ‚à∑ ya ‚à∑ va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na
  ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da
  ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ ka ‚à∑ pa
  ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []

-- The thirteen distinct anubandhas: the legal antya it.
allMarkers : List Sym
allMarkers = ·πÜ ‚à∑ K ‚à∑ ·πÑ ‚à∑ C ‚à∑ ·π¨ ‚à∑ M ‚à∑ √ë ‚à∑ ·π¢ ‚à∑ ≈ö ‚à∑ V ‚à∑ Y ‚à∑ R ‚à∑ L ‚à∑ []

anySym : (Sym ‚Üí Bool) ‚Üí List Sym ‚Üí Bool
anySym p [] = false
anySym p (x ‚à∑ xs) = p x or anySym p xs

-- is `t` the value of `between s m` for SOME legal pair (sound , marker)?
nameable : List Sym ‚Üí Bool
nameable t =
  anySym (Œª s ‚Üí anySym (Œª m ‚Üí eqList (between s m sivasutra14) t) allMarkers) allSounds

-- the intersection of two extracted classes, as lists
mem : Sym ‚Üí List Sym ‚Üí Bool
mem s [] = false
mem s (x ‚à∑ xs) = if eqSym x s then true else mem s xs

inter : List Sym ‚Üí List Sym ‚Üí List Sym
inter [] ys = []
inter (x ‚à∑ xs) ys = if mem x ys then x ‚à∑ inter xs ys else inter xs ys

isNil : List Sym ‚Üí Bool
isNil [] = true
isNil (_ ‚à∑ _) = false

-- Both classes are named.
ha≈ö-named : nameable (between ha ≈ö sivasutra14) ‚â° true
ha≈ö-named = refl

≈õaL-named : nameable (between ≈õa L sivasutra14) ‚â° true
≈õaL-named = refl

-- Their intersection is { ‡ }, and it is not empty.
ha≈ö‚à©≈õaL : inter (between ha ≈ö sivasutra14) (between ≈õa L sivasutra14) ‚â° ha ‚à∑ []
ha≈ö‚à©≈õaL = refl

ha≈ö‚à©≈õaL-nonempty : isNil (inter (between ha ≈ö sivasutra14) (between ≈õa L sivasutra14)) ‚â° false
ha≈ö‚à©≈õaL-nonempty = refl

-- And { ‡ } bears no name: 42 ó 13 = 546 candidate pairs, all refuted.
ha-alone-unnameable : nameable (ha ‚à∑ []) ‚â° false
ha-alone-unnameable = refl

-- Packaged.  The family the device generates is NOT closed under
-- non-empty intersection.
intersection-closure-fails :
  Œ£[ X ‚àà List Sym ] Œ£[ P ‚àà List Sym ]
    ((nameable X ‚â° true)
     √ó (nameable P ‚â° true)
     √ó (isNil (inter X P) ‚â° false)
     √ó (nameable (inter X P) ‚â° false))
intersection-closure-fails =
  between ha ≈ö sivasutra14 ,
  between ≈õa L sivasutra14 ,
  ha≈ö-named , ≈õaL-named , ha≈ö‚à©≈õaL-nonempty ,
  subst (Œª z ‚Üí nameable z ‚â° false) (sym ha≈ö‚à©≈õaL) ha-alone-unnameable

-- stated as the impossibility it is
not-intersection-closed :
  ¬¨ ((X P : List Sym) ‚Üí nameable X ‚â° true ‚Üí nameable P ‚â° true
     ‚Üí isNil (inter X P) ‚â° false ‚Üí nameable (inter X P) ‚â° true)
not-intersection-closed h =
  true‚â¢false
    (sym (h (between ha ≈ö sivasutra14) (between ≈õa L sivasutra14)
            ha≈ö-named ≈õaL-named ha≈ö‚à©≈õaL-nonempty)
     ‚àô subst (Œª z ‚Üí nameable z ‚â° false) (sym ha≈ö‚à©≈õaL) ha-alone-unnameable)

------------------------------------------------------------------------
-- 5b.  The two illegal pairs that do name { ‡ }
--
-- Kept, not deleted: they are why the candidate set is the device's and
-- not a wider one, and they show the negative result is sharp ‚î it fails
-- the moment either of Pini's two restrictions on the endpoints is
-- dropped.
------------------------------------------------------------------------

-- stop at a SOUND rather than an anubandha (excluded by A 1.3.3)
illegal-stop-names-ha : between ha ya sivasutra14 ‚â° ha ‚à∑ []
illegal-stop-names-ha = refl

-- start at an it-MARKER, which A 1.3.9 elides (so it is no sound at all)
illegal-start-names-ha : between R L sivasutra14 ‚â° ha ‚à∑ []
illegal-start-names-ha = refl

------------------------------------------------------------------------
-- 6.  A CLAIM OF MINE, STATED AND THEN KILLED
--
-- CLAIM R (mine, and the first repair I reached for).  The failure at
-- { ‡ } is an artefact of `from` taking the FIRST occurrence of the
-- initial sound.  Take the LAST occurrence instead and { ‡ } becomes
-- nameable ‚î `between ha L` then runs from stra 14's ‡ to ‡≤‡ and
-- denotes exactly { ‡ } ‚î so closure is restored by a one-line change to
-- the extractor and nothing about the iva-stras is at stake.
--
-- The first half of Claim R is TRUE and is checked below.  The claim is
-- still false, and ¬ß6b is what kills it: under last-occurrence search,
-- ‡‡≤‡ and ‡‡‡ are not merely different ‚î they are unnameable.  `fromLast
-- ha` can never again reach stra 5, so no pair whatever names the
-- consonants or the voiced consonants.
--
-- So the convention is not free and not arbitrary.  First-occurrence
-- search is what the repetition of ‡ is FOR: it is the convention under
-- which the second ‡ extends ‡‡≤‡ to the end of the list rather than
-- starting a new class.  Claim R traded one unnameable set for two, and
-- the two it lost are classes the Adhyy uses constantly.
--
-- Recorded rather than deleted, per this repository's practice.
------------------------------------------------------------------------

fromLast : Sym ‚Üí List Sym ‚Üí List Sym
fromLast s [] = []
fromLast s (x ‚à∑ xs) =
  if eqSym x s
  then (if isNil (fromLast s xs) then x ‚à∑ xs else fromLast s xs)
  else fromLast s xs

betweenLast : Sym ‚Üí Sym ‚Üí List Sym ‚Üí List Sym
betweenLast s m xs = upto m (fromLast s xs)

nameableLast : List Sym ‚Üí Bool
nameableLast t =
  anySym (Œª s ‚Üí anySym (Œª m ‚Üí eqList (betweenLast s m sivasutra14) t) allMarkers) allSounds

-- 6a.  The true half of Claim R: { ‡ } does become nameable.
claimR-half-true : betweenLast ha L sivasutra14 ‚â° ha ‚à∑ []
claimR-half-true = refl

claimR-ha-nameable : nameableLast (ha ‚à∑ []) ‚â° true
claimR-ha-nameable = refl

-- 6b.  THE KILL.  ‡‡≤‡ and ‡‡‡ are lost outright.
claimR-loses-haL : nameableLast (between ha L sivasutra14) ‚â° false
claimR-loses-haL = refl

claimR-loses-ha≈ö : nameableLast (between ha ≈ö sivasutra14) ‚â° false
claimR-loses-ha≈ö = refl

claimR-refuted :
  (nameableLast (ha ‚à∑ []) ‚â° true)
  √ó (nameableLast (between ha L sivasutra14) ‚â° false)
  √ó (nameableLast (between ha ≈ö sivasutra14) ‚â° false)
claimR-refuted = claimR-ha-nameable , claimR-loses-haL , claimR-loses-ha≈ö

------------------------------------------------------------------------
-- 7.  WHAT ¬ß5 DOES AND DOES NOT BEAR ON
--
-- IT DOES NOT TOUCH PETERSEN 2004.  That theorem concerns the family of
-- classes Pini's rules REQUIRE, and asks whether a linear order
-- represents it by intervals ‚î and, given that it does, whether his
-- order is minimal.  ¬ß5 concerns the family the device GENERATES, which
-- is larger: every (start, marker) pair, whether or not any rule uses
-- it.  A required family can be intersection-closed while the generated
-- family is not, and { ‡ } is precisely a set no rule needs a
-- two-symbol name for.  The two statements do not contradict and neither
-- implies the other.
--
-- IT DOES CONSTRAIN A READING ALREADY IN THIS CORPUS.
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md` ¬ß1.1 records the iva-stras as
-- "an interval representation of an intersection-closed set family over
-- a linear order".  Read as a statement about the required family that
-- is the received claim and nothing here disturbs it.  Read as a
-- statement about the device ‚î as the shorter phrase "the pratyhras
-- are intersection-closed" invites ‚î it is false, and ¬ß5 is the
-- counterexample.  The distinction is exactly the non-injectivity of the
-- labelling, which is exactly the repeated ‡.
--
-- THE COST LEDGER OF THE REPETITION, NOW THREE ENTRIES, EACH CHECKED IN
-- A DIFFERENT MODULE.  Repetition buys totality (`Pratyahara`, forced at
-- three letters; one repetition suffices).  It costs locality
-- (`PratyaharaBuysTotalityWithLocality`: one name, two sets ‚î the ‡‡‡
-- ambiguity).  It costs intersection-closure of the generated family
-- (¬ß5).  The third is not a corollary of the second: the collision in
-- that module is between two runs sharing a NAME, and ¬ß 5's failure is
-- between two SETS with no shared name at all.
--
-- WHAT IS STILL OPEN.  Whether { ‡ } is the ONLY non-empty intersection
-- of two nameable classes that is itself unnameable.  ¬ß5 exhibits one;
-- an exhaustive sweep over all 56 ó 56 ordered pairs of classes is a
-- finite computation and is NOT run here ‚î the derivation says the
-- failures can only arise where the labelling is non-injective, i.e.
-- only at ‡, but that is an argument and not a check, and this file
-- publishes no unchecked count.
------------------------------------------------------------------------
