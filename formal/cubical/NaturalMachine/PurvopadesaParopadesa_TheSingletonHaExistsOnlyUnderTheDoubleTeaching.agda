{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PurvopadesaParopadesa_TheSingletonHaExistsOnlyUnderTheDoubleTeaching
--
-- SOURCE, WITH TEXT, EDITION AND DATE.
--
--   Patajali, *Vykaraa-Mahbhya*, c. 150 BCE.  ivastra section,
--   the paragraph on the twice-taught ‡: Kielhorn I.27.2‚ì20 = Rohtak
--   I,93‚ì94, thirty sentences.  Read from GRETIL's e-text
--   `sa_pataJjali-vyAkaraNamahAbhASya`, section marker `s_5.1`
--   (github.com/tokushige-koyasan/gretil-corpus, snapshot 2026-08-20).
--   The vrttikas embedded at {5}/{6} and {13} are Ktyyana's,
--   c. 250 BCE.
--
--   THE TWO SENTENCES THIS MODULE ENCODES, verbatim as GRETIL gives them:
--
--     {3}  yadi puna prva eva upadiyeta para eva v .
--     {4}  ka ca atra viea .
--
--   ‚î "what if only the earlier were taught, or only the later?  and
--   what is the difference here?"  `sivasutra14-para` is his first
--   branch (‡‡ï‡æ‡∞‡‡‡Ø ‡‡∞‡ã‡‡¶‡‡‡, {5}); `sivasutra14-prva` is his second
--   (‡‡‡‡‡ ‡‡∞‡‡‡ø ‡‡‡∞‡‡µ‡ã‡‡¶‡‡‡, {12}).  His own conclusion is {29}
--   tasmt prva ca upadeavya para ca.
--
-- WHAT IS CLAIMED OF PATAJALI.  That he poses those two counterfactuals
-- and rejects both.  Nothing else.  His grounds are RULE COVERAGE ‚î in
-- the *para* branch the a-mentions (A 8.3.3, 8.3.9, 8.4.63) and
-- A 6.1.114 ‡‡‡ø ‡ lose ‡ and need a separate ‡‡ï‡æ‡∞‡ ‡; in the *prva*
-- branch A 1.2.26 (‡∞‡≤‡), A 3.1.45 (‡‡≤‡), A 7.2.35/7.2.76 (‡µ‡≤‡) and the
-- ‡‡≤‡-mentions (A 8.2.26 and six others) lose ‡.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED, and why it is not already in the module it extends
--
-- `NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet`
-- proves ‡‡‡ ‚à© ‡‡≤‡ ‚â° ‡ ‚à [] and that ‡ ‚à []
-- bears no legal name, hence that the generated family is not closed
-- under non-empty intersection.  It does NOT ask where that singleton
-- comes from.
--
--   ¬ß2  ‡‡‡ ‚à© ‡‡≤‡ is nonempty ONLY under the double teaching.  Delete
--       the later ‡ and the intersection is empty (‡‡≤‡ loses ‡).  Delete
--       the earlier ‡ and the NAME ‡‡‡ ceases to exist ‚î the anubandha
--       ‡‡ no longer occurs after any ‡.  So the one set at which
--       ‚à©-closure fails is manufactured by exactly the repetition
--       Ktyyana and Patajali argue is forced.
--
--   ¬ß1  a definedness predicate `named?`, which the shared extractor
--       lacks and needs.  `upto` returns the truncated tail when the
--       marker is absent, so `between` MANUFACTURES a denotation for a
--       name that does not exist; on the *para* string it reports
--       ‡‡‡ = ‡ ‚à [] ‚î the unnameable singleton itself.
--
--   ¬ß4  Ktyyana's list in the *prva* branch is exactly the classes
--       that begin after the earlier ‡ and close at ‡≤‡.  Four of them
--       are checked here by refl; that the four are ALL the ones the
--       Adhyy uses is philological, is established outside Agda,
--       and is stated in the note, not here.
------------------------------------------------------------------------

module NaturalMachine.PurvopadesaParopadesa_TheSingletonHaExistsOnlyUnderTheDoubleTeaching where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma

open import NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet
  using ( Sym
        ; a ; i ; u ; ·πõ ; ·∏∑ ; e ; o ; ai ; au
        ; ha ; ya ; va ; ra ; la
        ; √±a ; ma ; ·πÖa ; ·πáa ; na ; jha ; bha ; gha ; ·∏çha ; dha
        ; ja ; ba ; ga ; ·∏ça ; da
        ; kha ; pha ; cha ; ·π≠ha ; tha ; ca ; ·π≠a ; ta ; ka ; pa
        ; ≈õa ; ·π£a ; sa
        ; ·πÜ ; K ; ·πÑ ; C ; ·π¨ ; M ; √ë ; ·π¢ ; ≈ö ; V ; Y ; R ; L
        ; eqSym ; isMarker ; from ; upto ; between
        ; sivasutra14 ; inter ; isNil )

------------------------------------------------------------------------
-- 1.  Definedness of a NAME, which the shared extractor does not test
--
-- A pratyhra name is licensed by A 1.1.71 ‡‡¶‡ø‡∞‡®‡‡‡‡® ‡‡‡‡‡æ only when
-- the closing ‡‡‡ actually stands AFTER the initial sound.  `upto` runs
-- off the end of the list and returns what it has collected, so
-- `between s m` yields a list for every pair, licensed or not.  `named?`
-- is the missing side condition.
------------------------------------------------------------------------

reaches : Sym ‚Üí List Sym ‚Üí Bool
reaches m [] = false
reaches m (x ‚à∑ xs) = if eqSym x m then true else reaches m xs

named? : Sym ‚Üí Sym ‚Üí List Sym ‚Üí Bool
named? s m xs = reaches m (from s xs)

-- On the fourteen as they stand, both names of Pratyahara's witness exist.
ha≈ö-exists : named? ha ≈ö sivasutra14 ‚â° true
ha≈ö-exists = refl

≈õaL-exists : named? ≈õa L sivasutra14 ‚â° true
≈õaL-exists = refl

------------------------------------------------------------------------
-- 2.  Patajali's two counterfactuals, as strings
--
-- Nothing else moves: same sounds, same order, same anubandhas.  Only
-- the disputed ‡ is removed, from the fifth stra in the first and from
-- the fourteenth in the second.
------------------------------------------------------------------------

-- {5} ‡‡ï‡æ‡∞‡‡‡Ø ‡‡∞‡ã‡‡¶‡‡‡ ‚î ‡ taught only in the LATER place.
-- The fifth stra becomes ‡Ø‡µ‡∞‡ü‡.
sivasutra14-para : List Sym
sivasutra14-para =
  a ‚à∑ i ‚à∑ u ‚à∑ ·πÜ ‚à∑
  ·πõ ‚à∑ ·∏∑ ‚à∑ K ‚à∑
  e ‚à∑ o ‚à∑ ·πÑ ‚à∑
  ai ‚à∑ au ‚à∑ C ‚à∑
  ya ‚à∑ va ‚à∑ ra ‚à∑ ·π¨ ‚à∑
  la ‚à∑ ·πÜ ‚à∑
  √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na ‚à∑ M ‚à∑
  jha ‚à∑ bha ‚à∑ √ë ‚à∑
  gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ·π¢ ‚à∑
  ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da ‚à∑ ≈ö ‚à∑
  kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ V ‚à∑
  ka ‚à∑ pa ‚à∑ Y ‚à∑
  ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ R ‚à∑
  ha ‚à∑ L ‚à∑ []

-- {12} ‡‡‡‡‡ ‡‡∞‡‡‡ø ‡‡‡∞‡‡µ‡ã‡‡¶‡‡‡ ‚î ‡ taught only in the EARLIER place.
-- The fourteenth stra keeps its anubandha and loses its sound.
sivasutra14-p≈´rva : List Sym
sivasutra14-p≈´rva =
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
  L ‚à∑ []

------------------------------------------------------------------------
-- 3.  THE PARA BRANCH: the name ‡‡‡ ceases to exist
--
-- With the earlier ‡ gone, the only ‡ in the string stands at the end,
-- after the anubandha ‡‡ that closes ‡‡‡ó‡°‡¶‡‡.  No ‡ is followed by ‡‡,
-- so nothing can be called ‡‡‡.
------------------------------------------------------------------------

ha≈ö-unnamed-under-para : named? ha ≈ö sivasutra14-para ‚â° false
ha≈ö-unnamed-under-para = refl

-- THE EXTRACTOR ON THE VANISHED NAME.
--
-- `between ha  sivasutra14-para` does not come out ‚â° [].
-- `upto` collects until it finds the marker or
-- runs out of list, so it walks off the end and returns the sounds it
-- passed:
ha≈ö-para-is-manufactured : between ha ≈ö sivasutra14-para ‚â° ha ‚à∑ []
ha≈ö-para-is-manufactured = refl

-- which is worse than empty in the exact way that matters here: the
-- extractor hands back the very singleton Pratyahara proves is UNNAMEABLE, as
-- though it were the value of a name.  So the ‚à©-closure statement cannot
-- be transported to a counterfactual string by `between` alone; it needs
-- `named?`.  On the actual fourteen the silent truncation never fires
-- for these two names (¬ß1), so Pratyahara's theorem is untouched ‚î but its
-- extractor is total by truncation, not by totality, and that is a
-- defect the three modules sharing it all carry.

-- The other class is undisturbed: ‡‡≤‡ still names {‡ ‡ ‡ ‡}.
≈õaL-under-para : between ≈õa L sivasutra14-para ‚â° ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ ha ‚à∑ []
≈õaL-under-para = refl

------------------------------------------------------------------------
-- 4.  THE PRVA BRANCH: the classes that close at ‡≤‡ lose ‡
--
-- {13} prvopadee kittvaksevidhaya jhalgrahani ca ‚î the vrttika
-- names four things.  Here are the four pratyhras behind them, on the
-- string with the later ‡ deleted.  Each keeps its name and loses ‡.
------------------------------------------------------------------------

-- ‡‡≤‡ ‚î A 3.1.45 ‡‡≤ ‡‡ó‡‡‡ß‡æ‡¶‡®‡ø‡ü‡ ‡ï‡‡‡, cited at {20}.
≈õaL-under-p≈´rva : between ≈õa L sivasutra14-p≈´rva ‚â° ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []
≈õaL-under-p≈´rva = refl

-- ‡∞‡≤‡ ‚î A 1.2.26 ‡∞‡≤‡ã ‡µ‡‡Ø‡‡‡ß‡æ‡¶‡‡ß‡≤‡æ‡¶‡‡ ‡‡‡‡‡, cited at {16}.
raL-under-p≈´rva : between ra L sivasutra14-p≈´rva
  ‚â° ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha
  ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta
  ‚à∑ ka ‚à∑ pa ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []
raL-under-p≈´rva = refl

-- ‡µ‡≤‡ ‚î A 7.2.35 ‡‡∞‡‡ß‡ß‡æ‡‡‡ï‡‡‡Ø‡‡°‡ ‡µ‡≤‡æ‡¶‡‡, behind {24} ‡µ‡≤‡æ‡¶‡ø‡≤‡ï‡‡‡‡ ‡‡ü‡.
vaL-under-p≈´rva : between va L sivasutra14-p≈´rva
  ‚â° va ‚à∑ ra ‚à∑ la ‚à∑ √±a ‚à∑ ma ‚à∑ ·πÖa ‚à∑ ·πáa ‚à∑ na ‚à∑ jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha
  ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta
  ‚à∑ ka ‚à∑ pa ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []
vaL-under-p≈´rva = refl

-- ‡‡≤‡ ‚î A 8.2.26 ‡‡≤‡ã ‡‡≤‡ø, cited at {28} as the fault: ‡‡¶‡æ‡ó‡‡ß‡æ‡Æ‡ ‡‡¶‡æ‡ó‡‡ß‡Æ‡.
jhaL-under-p≈´rva : between jha L sivasutra14-p≈´rva
  ‚â° jha ‚à∑ bha ‚à∑ gha ‚à∑ ·∏çha ‚à∑ dha ‚à∑ ja ‚à∑ ba ‚à∑ ga ‚à∑ ·∏ça ‚à∑ da
  ‚à∑ kha ‚à∑ pha ‚à∑ cha ‚à∑ ·π≠ha ‚à∑ tha ‚à∑ ca ‚à∑ ·π≠a ‚à∑ ta ‚à∑ ka ‚à∑ pa
  ‚à∑ ≈õa ‚à∑ ·π£a ‚à∑ sa ‚à∑ []
jhaL-under-p≈´rva = refl

-- ‡‡‡ is untouched by the prva branch: it closes at ‡‡, long before
-- the place the deleted ‡ stood.
ha≈ö-under-p≈´rva : between ha ≈ö sivasutra14-p≈´rva ‚â° between ha ≈ö sivasutra14
ha≈ö-under-p≈´rva = refl

------------------------------------------------------------------------
-- 5.  THE THEOREM
--
-- The intersection that breaks ‚à©-closure is nonempty under the double
-- teaching and empty (or nameless) under either single teaching.
------------------------------------------------------------------------

-- as given: nonempty, and equal to { ‡ } (Pratyahara ¬ß5).
inter-double : isNil (inter (between ha ≈ö sivasutra14)
                            (between ≈õa L sivasutra14)) ‚â° false
inter-double = refl

-- prva only: both names exist, and the intersection is EMPTY.
inter-p≈´rva : inter (between ha ≈ö sivasutra14-p≈´rva)
                    (between ≈õa L sivasutra14-p≈´rva) ‚â° []
inter-p≈´rva = refl

singleton-needs-both :
  (named? ha ≈ö sivasutra14 ‚â° true)
  √ó (named? ≈õa L sivasutra14 ‚â° true)
  √ó (isNil (inter (between ha ≈ö sivasutra14) (between ≈õa L sivasutra14)) ‚â° false)
  √ó (named? ha ≈ö sivasutra14-para ‚â° false)
  √ó (isNil (inter (between ha ≈ö sivasutra14-p≈´rva)
                  (between ≈õa L sivasutra14-p≈´rva)) ‚â° true)
singleton-needs-both =
  ha≈ö-exists , ≈õaL-exists , inter-double , ha≈ö-unnamed-under-para ,
  cong isNil inter-p≈´rva

------------------------------------------------------------------------
-- 6.  WHAT THIS SETTLES
--
-- The counterexample to ‚à©-closure is not incidental to the
-- string.  It is the trace of the repetition, and the repetition is what
-- Kielhorn I.27.2‚ì20 argues is forced.  The two pratyhras in Pratyahara's
-- witness are, further, the two that Patajali cites on OPPOSITE sides
-- of his alternative ‚î ‡‡‡ from A 6.1.114 in the *para* branch {10},
-- ‡‡≤‡ from A 3.1.45 in the *prva* branch {20} ‚î and each of those is
-- the only stra in the Adhyy using its pratyhra.
--
-- A separate question is whether ‚à©-closure is a property Pini's device was
-- ever meant to have.  Nothing in the thirty sentences suggests the
-- question was posed, and ¬ß4 of Pratyahara's module already shows the failure
-- is invisible to the symmetry.  Coverage
-- and ‚à©-closure are two different demands on the same family; the
-- tradition argues the first at length, and satisfying the first is
-- what breaks the second ‚î here, at exactly one set.
------------------------------------------------------------------------
