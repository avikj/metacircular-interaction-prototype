{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PurvopadesaParopadesa_TheSingletonHaExistsOnlyUnderTheDoubleTeaching
--
-- SOURCE, WITH TEXT, EDITION AND DATE.
--
--   Patañjali, *Vyākaraṇa-Mahābhāṣya*, c. 150 BCE.  Śivasūtra section,
--   the paragraph on the twice-taught ह: Kielhorn I.27.2–20 = Rohtak
--   I,93–94, thirty sentences.  Read from GRETIL's e-text
--   `sa_pataJjali-vyAkaraNamahAbhASya`, section marker `Śs_5.1`
--   (github.com/tokushige-koyasan/gretil-corpus, snapshot 2026-08-20).
--   The vārttikas embedded at {5}/{6} and {13} are Kātyāyana's,
--   c. 250 BCE.
--
--   THE TWO SENTENCES THIS MODULE ENCODES, verbatim as GRETIL gives them:
--
--     {3}  yadi punaḥ pūrvaḥ eva upadiśyeta paraḥ eva vā .
--     {4}  kaḥ ca atra viśeṣaḥ .
--
--   — "what if only the earlier were taught, or only the later?  and
--   what is the difference here?"  `sivasutra14-para` is his first
--   branch (हकारस्य परोपदेशे, {5}); `sivasutra14-pūrva` is his second
--   (अस्तु तर्हि पूर्वोपदेशः, {12}).  His own conclusion is {29}
--   tasmāt pūrvaḥ ca upadeṣṭavyaḥ paraḥ ca.
--
-- WHAT IS CLAIMED OF PATAÑJALI.  That he poses those two counterfactuals
-- and rejects both.  Nothing else.  His grounds are RULE COVERAGE — in
-- the *para* branch the aṭ-mentions (A 8.3.3, 8.3.9, 8.4.63) and
-- A 6.1.114 हशि च lose ह and need a separate हकारे च; in the *pūrva*
-- branch A 1.2.26 (रल्), A 3.1.45 (शल्), A 7.2.35/7.2.76 (वल्) and the
-- झल्-mentions (A 8.2.26 and six others) lose ह.
--
-- WHAT IS NOT CLAIMED OF PATAÑJALI.  That he stated, considered, or
-- would recognise anything about intersections of pratyāhāras.  He does
-- not.  Read for it, he asks throughout only *whether a rule reaches a
-- form*: every one of the thirty sentences is of the shape "rule R would
-- not obtain in example E".  The theorems below are NOT his.  They are
-- about the family of sets his two counterfactuals move, and the link
-- between his question and the ∩-closure question is the finding, not a
-- reading of his intent.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, and why it is not already in the module it extends
--
-- `NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet`
-- (cf-tessera-k-6, 691156fe) proves हश् ∩ शल् ≡ ह ∷ [] and that ह ∷ []
-- bears no legal name, hence that the generated family is not closed
-- under non-empty intersection.  It does NOT ask where that singleton
-- comes from.
--
--   §2  हश् ∩ शल् is nonempty ONLY under the double teaching.  Delete
--       the later ह and the intersection is empty (शल् loses ह).  Delete
--       the earlier ह and the NAME हश् ceases to exist — the anubandha
--       श् no longer occurs after any ह.  So the one set at which
--       ∩-closure fails is manufactured by exactly the repetition
--       Kātyāyana and Patañjali argue is forced.
--
--   §1  a definedness predicate `named?`, which the shared extractor
--       lacks and needs.  `upto` returns the truncated tail when the
--       marker is absent, so `between` MANUFACTURES a denotation for a
--       name that does not exist; on the *para* string it reports
--       हश् = ह ∷ [] — the unnameable singleton itself.  §3 records that
--       as a refuted claim of mine rather than hiding it.
--
--   §4  Kātyāyana's list in the *pūrva* branch is exactly the classes
--       that begin after the earlier ह and close at ल्.  Four of them
--       are checked here by refl; that the four are ALL the ones the
--       Aṣṭādhyāyī uses is philological, is established outside Agda,
--       and is stated in the note, not here.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (the container's pair, not the
-- declared repository pin).  --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PurvopadesaParopadesa_TheSingletonHaExistsOnlyUnderTheDoubleTeaching where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma

open import NaturalMachine.Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet
  using ( Sym
        ; a ; i ; u ; ṛ ; ḷ ; e ; o ; ai ; au
        ; ha ; ya ; va ; ra ; la
        ; ña ; ma ; ṅa ; ṇa ; na ; jha ; bha ; gha ; ḍha ; dha
        ; ja ; ba ; ga ; ḍa ; da
        ; kha ; pha ; cha ; ṭha ; tha ; ca ; ṭa ; ta ; ka ; pa
        ; śa ; ṣa ; sa
        ; Ṇ ; K ; Ṅ ; C ; Ṭ ; M ; Ñ ; Ṣ ; Ś ; V ; Y ; R ; L
        ; eqSym ; isMarker ; from ; upto ; between
        ; sivasutra14 ; inter ; isNil )

------------------------------------------------------------------------
-- 1.  Definedness of a NAME, which the shared extractor does not test
--
-- A pratyāhāra name is licensed by A 1.1.71 आदिरन्तेन सहेता only when
-- the closing इत् actually stands AFTER the initial sound.  `upto` runs
-- off the end of the list and returns what it has collected, so
-- `between s m` yields a list for every pair, licensed or not.  `named?`
-- is the missing side condition.
------------------------------------------------------------------------

reaches : Sym → List Sym → Bool
reaches m [] = false
reaches m (x ∷ xs) = if eqSym x m then true else reaches m xs

named? : Sym → Sym → List Sym → Bool
named? s m xs = reaches m (from s xs)

-- On the fourteen as they stand, both names of k-6's witness exist.
haŚ-exists : named? ha Ś sivasutra14 ≡ true
haŚ-exists = refl

śaL-exists : named? śa L sivasutra14 ≡ true
śaL-exists = refl

------------------------------------------------------------------------
-- 2.  Patañjali's two counterfactuals, as strings
--
-- Nothing else moves: same sounds, same order, same anubandhas.  Only
-- the disputed ह is removed, from the fifth sūtra in the first and from
-- the fourteenth in the second.
------------------------------------------------------------------------

-- {5} हकारस्य परोपदेशे — ह taught only in the LATER place.
-- The fifth sūtra becomes यवरट्.
sivasutra14-para : List Sym
sivasutra14-para =
  a ∷ i ∷ u ∷ Ṇ ∷
  ṛ ∷ ḷ ∷ K ∷
  e ∷ o ∷ Ṅ ∷
  ai ∷ au ∷ C ∷
  ya ∷ va ∷ ra ∷ Ṭ ∷
  la ∷ Ṇ ∷
  ña ∷ ma ∷ ṅa ∷ ṇa ∷ na ∷ M ∷
  jha ∷ bha ∷ Ñ ∷
  gha ∷ ḍha ∷ dha ∷ Ṣ ∷
  ja ∷ ba ∷ ga ∷ ḍa ∷ da ∷ Ś ∷
  kha ∷ pha ∷ cha ∷ ṭha ∷ tha ∷ ca ∷ ṭa ∷ ta ∷ V ∷
  ka ∷ pa ∷ Y ∷
  śa ∷ ṣa ∷ sa ∷ R ∷
  ha ∷ L ∷ []

-- {12} अस्तु तर्हि पूर्वोपदेशः — ह taught only in the EARLIER place.
-- The fourteenth sūtra keeps its anubandha and loses its sound.
sivasutra14-pūrva : List Sym
sivasutra14-pūrva =
  a ∷ i ∷ u ∷ Ṇ ∷
  ṛ ∷ ḷ ∷ K ∷
  e ∷ o ∷ Ṅ ∷
  ai ∷ au ∷ C ∷
  ha ∷ ya ∷ va ∷ ra ∷ Ṭ ∷
  la ∷ Ṇ ∷
  ña ∷ ma ∷ ṅa ∷ ṇa ∷ na ∷ M ∷
  jha ∷ bha ∷ Ñ ∷
  gha ∷ ḍha ∷ dha ∷ Ṣ ∷
  ja ∷ ba ∷ ga ∷ ḍa ∷ da ∷ Ś ∷
  kha ∷ pha ∷ cha ∷ ṭha ∷ tha ∷ ca ∷ ṭa ∷ ta ∷ V ∷
  ka ∷ pa ∷ Y ∷
  śa ∷ ṣa ∷ sa ∷ R ∷
  L ∷ []

------------------------------------------------------------------------
-- 3.  THE PARA BRANCH: the name हश् ceases to exist
--
-- With the earlier ह gone, the only ह in the string stands at the end,
-- after the anubandha श् that closes जबगडदश्.  No ह is followed by श्,
-- so nothing can be called हश्.
------------------------------------------------------------------------

haŚ-unnamed-under-para : named? ha Ś sivasutra14-para ≡ false
haŚ-unnamed-under-para = refl

-- A CLAIM OF MINE, STATED AND KILLED.
--
-- I first wrote that `between ha Ś sivasutra14-para` would come out ≡ []
-- — that the extractor would report the vanished name as the empty
-- class.  It does not.  `upto` collects until it finds the marker or
-- runs out of list, so it walks off the end and returns the sounds it
-- passed:
haŚ-para-is-manufactured : between ha Ś sivasutra14-para ≡ ha ∷ []
haŚ-para-is-manufactured = refl

-- which is worse than empty in the exact way that matters here: the
-- extractor hands back the very singleton k-6 proves is UNNAMEABLE, as
-- though it were the value of a name.  So the ∩-closure statement cannot
-- be transported to a counterfactual string by `between` alone; it needs
-- `named?`.  On the actual fourteen the silent truncation never fires
-- for these two names (§1), so k-6's theorem is untouched — but its
-- extractor is total by truncation, not by totality, and that is a
-- defect the three modules sharing it all carry.

-- The other class is undisturbed: शल् still names {श ष स ह}.
śaL-under-para : between śa L sivasutra14-para ≡ śa ∷ ṣa ∷ sa ∷ ha ∷ []
śaL-under-para = refl

------------------------------------------------------------------------
-- 4.  THE PŪRVA BRANCH: the classes that close at ल् lose ह
--
-- {13} pūrvopadeśe kittvakseḍvidhayaḥ jhalgrahaṇāni ca — the vārttika
-- names four things.  Here are the four pratyāhāras behind them, on the
-- string with the later ह deleted.  Each keeps its name and loses ह.
------------------------------------------------------------------------

-- शल् — A 3.1.45 शल इगुपधादनिटः क्सः, cited at {20}.
śaL-under-pūrva : between śa L sivasutra14-pūrva ≡ śa ∷ ṣa ∷ sa ∷ []
śaL-under-pūrva = refl

-- रल् — A 1.2.26 रलो व्युपधाद्धलादेः संश्च, cited at {16}.
raL-under-pūrva : between ra L sivasutra14-pūrva
  ≡ ra ∷ la ∷ ña ∷ ma ∷ ṅa ∷ ṇa ∷ na ∷ jha ∷ bha ∷ gha ∷ ḍha ∷ dha
  ∷ ja ∷ ba ∷ ga ∷ ḍa ∷ da ∷ kha ∷ pha ∷ cha ∷ ṭha ∷ tha ∷ ca ∷ ṭa ∷ ta
  ∷ ka ∷ pa ∷ śa ∷ ṣa ∷ sa ∷ []
raL-under-pūrva = refl

-- वल् — A 7.2.35 आर्धधातुकस्येड् वलादेः, behind {24} वलादिलक्षणः इट्.
vaL-under-pūrva : between va L sivasutra14-pūrva
  ≡ va ∷ ra ∷ la ∷ ña ∷ ma ∷ ṅa ∷ ṇa ∷ na ∷ jha ∷ bha ∷ gha ∷ ḍha ∷ dha
  ∷ ja ∷ ba ∷ ga ∷ ḍa ∷ da ∷ kha ∷ pha ∷ cha ∷ ṭha ∷ tha ∷ ca ∷ ṭa ∷ ta
  ∷ ka ∷ pa ∷ śa ∷ ṣa ∷ sa ∷ []
vaL-under-pūrva = refl

-- झल् — A 8.2.26 झलो झलि, cited at {28} as the fault: अदाग्धाम् अदाग्धम्.
jhaL-under-pūrva : between jha L sivasutra14-pūrva
  ≡ jha ∷ bha ∷ gha ∷ ḍha ∷ dha ∷ ja ∷ ba ∷ ga ∷ ḍa ∷ da
  ∷ kha ∷ pha ∷ cha ∷ ṭha ∷ tha ∷ ca ∷ ṭa ∷ ta ∷ ka ∷ pa
  ∷ śa ∷ ṣa ∷ sa ∷ []
jhaL-under-pūrva = refl

-- हश् is untouched by the pūrva branch: it closes at श्, long before
-- the place the deleted ह stood.
haŚ-under-pūrva : between ha Ś sivasutra14-pūrva ≡ between ha Ś sivasutra14
haŚ-under-pūrva = refl

------------------------------------------------------------------------
-- 5.  THE THEOREM
--
-- The intersection that breaks ∩-closure is nonempty under the double
-- teaching and empty (or nameless) under either single teaching.
------------------------------------------------------------------------

-- as given: nonempty, and equal to { ह } (k-6 §5).
inter-double : isNil (inter (between ha Ś sivasutra14)
                            (between śa L sivasutra14)) ≡ false
inter-double = refl

-- pūrva only: both names exist, and the intersection is EMPTY.
inter-pūrva : inter (between ha Ś sivasutra14-pūrva)
                    (between śa L sivasutra14-pūrva) ≡ []
inter-pūrva = refl

singleton-needs-both :
  (named? ha Ś sivasutra14 ≡ true)
  × (named? śa L sivasutra14 ≡ true)
  × (isNil (inter (between ha Ś sivasutra14) (between śa L sivasutra14)) ≡ false)
  × (named? ha Ś sivasutra14-para ≡ false)
  × (isNil (inter (between ha Ś sivasutra14-pūrva)
                  (between śa L sivasutra14-pūrva)) ≡ true)
singleton-needs-both =
  haŚ-exists , śaL-exists , inter-double , haŚ-unnamed-under-para ,
  cong isNil inter-pūrva

------------------------------------------------------------------------
-- 6.  WHAT THIS DOES AND DOES NOT SETTLE
--
-- Settles: the counterexample to ∩-closure is not incidental to the
-- string.  It is the trace of the repetition, and the repetition is what
-- Kielhorn I.27.2–20 argues is forced.  The two pratyāhāras in k-6's
-- witness are, further, the two that Patañjali cites on OPPOSITE sides
-- of his alternative — हश् from A 6.1.114 in the *para* branch {10},
-- शल् from A 3.1.45 in the *pūrva* branch {20} — and each of those is
-- the only sūtra in the Aṣṭādhyāyī using its pratyāhāra (checked against
-- `/root/agda-libs/vidyut/vidyut-prakriya/data/sutrapatha.tsv`, 3984
-- sūtras, snapshot 2026-08-20; reported in the note).
--
-- Does not settle: whether ∩-closure is a property Pāṇini's device was
-- ever meant to have.  Nothing in the thirty sentences suggests the
-- question was posed, and §4 of k-6's module already shows the failure
-- is invisible to the symmetry.  The honest statement is that coverage
-- and ∩-closure are two different demands on the same family, that the
-- tradition argues the first at length, and that satisfying the first is
-- what breaks the second — here, at exactly one set.
------------------------------------------------------------------------
