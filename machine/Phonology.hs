-- Phonology -- Panini's grammar as a running machine, not a description of one.
--
-- WHAT THIS IS.  The Phonology (Panini, ~500 BCE) is a rewriting system with
-- ~3983 rules.  It is not a description of Sanskrit.  It is a device that,
-- given a root and an affix, COMPUTES the surface form -- and it was built
-- twenty-four centuries before anyone in Europe wrote down what a rewriting
-- system is.  Everything in this repository that touches Panini until now has
-- checked PROPERTIES of the mechanism in Agda (Sivasutra.agda checks that the
-- pratyahara is an interval; ElsewhereCondition.agda checks utsarga/apavada;
-- Panini.agda checks the conflict rule).  None of it RAN a sutra.
--
-- This file runs sutras.  You give it `deva + indra` and it gives you
-- `devendra`, and it tells you which sutra fired, in which order, and -- when
-- two sutras both wanted the same position -- which one won and by which
-- metarule.
--
-- THE SIX MECHANISMS, each implemented and each self-tested:
--
--   1. PRATYAHARA.  The fourteen siva-sutras lay all forty-two phonemes in ONE
--      linear order, each sutra ending in an anubandha (it-marker).  A class of
--      sounds is named by the INTERVAL from a sound to a marker: aC = every
--      vowel, haL = every consonant, yaN = the semivowels, jhaS = the voiced
--      aspirates.  Two letters name any class the grammar needs.  Encoded here
--      in full -- all fourteen sutras, not the vowel prefix -- and every
--      traditional pratyahara is CHECKED against its traditional value in
--      `selfTest`.
--
--   2. VIPRATISEDHE PARAM KARYAM (1.4.2).  "In conflict, the LATER operation."
--      Position in the text is semantic: a sutra's number is part of its
--      meaning.  So `Ref` is carried on every rule and `resolve` uses it.
--      Genuine instances fall out of the test corpus -- dadhi+indra has 6.1.77
--      and 6.1.101 both firing at the same position, and 6.1.101 wins because
--      101 > 77.  Nobody put that in by hand; it is what the rules do.
--
--   3. UTSARGA / APAVADA.  A specific rule blocks the general one it is an
--      exception to, REGARDLESS of position.  This is the elsewhere condition,
--      rediscovered by Kiparsky in 1973 and named after him in the phonology
--      literature.  Carried in `apavadaTo`.
--
--   4. PURVATRASIDDHAM (8.2.1).  The last three quarter-chapters (8.2, 8.3,
--      8.4 -- the `tripadi`) are ASIDDHA, "as if not having taken effect", for
--      everything before them.  So the grammar is stratified: the first seven
--      and a quarter chapters run to a fixpoint with all rules mutually
--      visible, and then the tripadi runs ONCE, in order, each rule seeing only
--      what precedes it.  `derive` implements exactly this, and `asiddhaAudit`
--      reports which earlier rules WOULD have fired on tripadi output and were
--      correctly refused.
--
--   5. ANUVRTTI and ADHIKARA (section 3a, added 2026-08-20).  A term stated
--      once RUNS FORWARD into subsequent sutras until cancelled, and a
--      heading governs a whole block.  So a sutra is NOT LOCALLY READABLE:
--      8.2.30 `coh kuh` is two words and its restriction is stated at
--      8.1.16.  `fires` now takes a `Reading` -- what is written plus what
--      is inherited -- and a rule cannot tell the two apart, which is the
--      device.  `sutraAlone` prints a sutra with its gaps visible; every
--      `Step` carries the governing context the rule stood inside; and
--      `deriveUnder` cancels a word to show the heading is load-bearing:
--      without 8.1.16 `padasya`, tat + ca derives `dad ga` and not
--      `tacca`.  With inheritance explicit the presentation cost is
--      computable -- section 8a, `laghavaReport`.
--
--   6. STHANIVADBHAVA (1.1.56) and LOPA (1.1.60), section 6c, added
--      2026-08-20.  `sthanivad adeso 'nalvidhau`: a substitute counts as
--      the original FOR SUBSEQUENT RULES, except for rules conditioned on
--      the sounds themselves.  It inherits the original's DESIGNATIONS and
--      not its FORM -- an abstraction barrier with a named exception for
--      the clients that inspect the representation, which is sharper than
--      the modern folklore version offering full transparency or full
--      opacity and having no vocabulary for the middle.
--
--      Before this section the engine could not have obeyed the sutra: a
--      rewrite overwrote the string and the sthanin was gone.  Now every
--      substitution writes what it stands in place of into a channel
--      parallel to the word, `alVidhiTable` declares per sutra WITH ITS
--      REASON which of the two readings that sutra takes, `seenBy` hands
--      each rule the view it is entitled to, and every `Step` records
--      which reading fired at which site.  Cancelling the exception
--      clause is a RUN (`deriveSthanivatEverywhere`), not an edit, and it
--      changes four derived forms.
--
--      1.1.60 `adarsanam lopah` is the companion: an elided element is
--      absent from the surface and present to the conditions.  `Lupta`
--      is that distinction in the type, and 1.1.5 `kniti ca` reads the
--      `k` that 1.3.9 erased -- `ci ~ kta` gives `cita`, and a deletion
--      instead of an adarsana gives `ceta`.
--
--      WHAT IS NOT EXERCISED, said here and not only in `coverage`: the
--      INHERITANCE half.  The three designation-reading rules encoded
--      (1.1.5, 1.3.9, 7.1.1) never fire at a site holding a substitute,
--      so striking `sthanivat` changes nothing in this corpus.  The
--      exception half is exercised; the inheritance half is declared.
--
-- ADHIKARA AS A CHECKABLE PROPERTY.  6.1.84 `ekah purvaparayoh`
-- ("one, in place of both the preceding and the following") is a heading that
-- governs 6.1.85-6.1.111.  Sutras inside that scope replace TWO sounds by ONE;
-- sutras outside it do not.  That is a mechanically checkable property of the
-- rewrites, and `selfTest` checks it: 6.1.87, 6.1.88, 6.1.101, 6.1.109 all
-- produce single substitutes, and 6.1.77 and 6.1.78 -- which sit BELOW 84 and
-- are therefore outside the heading -- do not.  6.1.78 in particular turns one
-- sound into two (e -> ay), which would be a bug if the heading covered it and
-- is correct because it does not.
--
-- HOW MUCH OF PANINI IS HERE.  `coverage` prints it and does not round up.
-- The Phonology has ~3983 sutras (counts vary by recension, 3959-3996).  This
-- file encodes the number given by `length sutras` -- read it there, not here,
-- so it cannot go stale.  What is complete is the siva-sutra table, the
-- pratyahara extractor, the savarna relation of 1.1.9/1.1.10, and the four
-- metarule mechanisms.  What is a sample is the vidhi rules: enough of 6.1
-- (vowel sandhi) and 8.2-8.4 (the tripadi) to run real derivations end to end
-- and to exhibit each mechanism doing work.
--
-- SOURCES.  Panini, Phonology, ~500 BCE (Katyayana's varttikas ~250 BCE,
-- Patanjali's Mahabhasya ~150 BCE).  Sutra text and numbering follow the
-- vulgate; the siva-sutra order and the savarna definition follow 1.1.9
-- `tulyasyaprayatnam savarnam` and 1.1.10 `najjhalau`, and the extension of a
-- pratyahara to its savarnas follows 1.1.69 `anudit savarnasya capratyayah`.
-- Where the tradition distinguishes degrees of vivrta to keep `e` and `ai`
-- from being savarna, that distinction is encoded as a fifth prayatna and
-- flagged at the definition.
--
-- NO FLOATING POINT, no measurement, no fitted anything.  Every claim this
-- file makes is a finite exhaustive check in `selfTest`, which either returns
-- [] or names what failed.

module Phonology
  ( -- the sound system
    Slot(..)
  , sivasutraTable
  , varnasamamnaya
  , pratyahara
  , pratyaharaOcc
  , pratyaharaSet
  , rawSpan
  , denotes
    -- phonetics (1.1.9, 1.1.10, 1.1.69)
  , Sthana(..)
  , Prayatna(..)
  , Phone(..)
  , phones
  , phoneOf
  , savarna
  , savarnasOf
    -- the grammar
  , Ref
  , SutraType(..)
  , Sutra(..)
  , sutras
    -- anuvrtti and adhikara (section 3a)
  , Vrtti(..)
  , Inherited(..)
  , Reading(..)
  , anuvrttiTable
  , nivrttiTable
  , contextAt
  , contextAtUnder
  , readingUnder
  , has
  , fullReading
  , sutraAlone
  , showR
  , adhikaras
  , governedBy
  , tripadi
    -- derivation
  , Item(..)
  , Rewrite(..)
  , Step(..)
  , tokenize
  , render
  , parseInput
  , derive
  , deriveUnder
  , deriveTrace
  , deriveTraceUnder
  , asiddhavatPass
  , deriveAsiddhavat
  , asiddhaAudit
  , applyRw
    -- स्थानिवद्भावः 1.1.56 and लोपः 1.1.60 (section 6c)
  , Vidhi(..)
  , Sthanin(..)
  , Prov
  , navah
  , applyRwP
  , alVidhiTable
  , vidhiOf
  , vidhiWhy
  , Drsti(..)
  , Vidhana(..)
  , yathasutram
  , drstiVidhi
  , drsta
  , seenBy
  , firesV
  , sthaniAt
  , deriveV
  , deriveTraceV
  , deriveLekhaV
  , deriveSthanivatEverywhere
  , deriveRupamEverywhere
  , deriveWithoutLopa
  , deriveWithoutLopaTrace
  , barrierAudit
  , knitAudit
  , upadesaSpan
  , upadesaAudible
  , itPending
  , knitPratyaya
  , angaAntya
    -- शेषः: the residual (section 7b)
  , Lekha(..)
  , deriveLekha
  , deriveLekhaUnder
  , resolveN
  , stepANUnder
  , Hetu(..)
  , Sandhi
  , Sesa(..)
  , SesaKey
  , sesaKey
  , sesaPrccha
  , sesaPada
  , showSandhi
  , Nirnaya(..)
  , nirnaya
  , vidhiRefs
  , Pravesha(..)
  , pravesha
  , sesah
  , sesaKosha
  , sesaPrasna
  , sesaPrasnaNava
  , abhyasa
  , sesaLekha
    -- the karaka layer (2.3.1, 2.3.2, 2.3.18)
  , Karaka(..)
  , Vibhakti(..)
  , Vacya(..)
  , abhihita
  , vibhaktiOf
  , Drshya
  , pacatiScene
  , dadatiScene
  , assign
    -- laghavam (section 8a)
  , Laghava(..)
  , laghava
  , laghavaReport
  , laghavaByWord
  , varnasOf
  , varnaCount
  , ardhamatras
    -- honesty
  , coverage
  , selfTest
  ) where

import Data.List (isPrefixOf, nub, sortOn, intercalate, maximumBy)
import Data.Maybe (mapMaybe, listToMaybe, fromMaybe, isJust)
import Data.Ord (comparing)

------------------------------------------------------------------------
-- 1.  THE FOURTEEN SIVA-SUTRAS
--
-- The whole phoneme inventory in one line, punctuated by markers.  Consonants
-- are cited in the tradition with an inherent `a` (`ha ya va ra Ta`) which is
-- an articulatory aid, not part of the sound; the phonemes are h y v r.
------------------------------------------------------------------------

data Slot = Snd String | It String
  deriving (Eq, Show)

-- (number, sounds, anubandha)
sivasutraTable :: [(Int, [String], String)]
sivasutraTable =
  [ ( 1, ["a","i","u"],                            "ṇ")
  , ( 2, ["ṛ","ḷ"],                                "k")
  , ( 3, ["e","o"],                                "ṅ")
  , ( 4, ["ai","au"],                              "c")
  , ( 5, ["h","y","v","r"],                        "ṭ")
  , ( 6, ["l"],                                    "ṇ")
  , ( 7, ["ñ","m","ṅ","ṇ","n"],                    "m")
  , ( 8, ["jh","bh"],                              "ñ")
  , ( 9, ["gh","ḍh","dh"],                         "ṣ")
  , (10, ["j","b","g","ḍ","d"],                    "ś")
  , (11, ["kh","ph","ch","ṭh","th","c","ṭ","t"],   "v")
  , (12, ["k","p"],                                "y")
  , (13, ["ś","ṣ","s"],                            "r")
  , (14, ["h"],                                    "l")
  ]

-- The varnasamamnaya: the flat sequence, sounds and markers interleaved.
varnasamamnaya :: [Slot]
varnasamamnaya = concat [ map Snd ss ++ [It m] | (_, ss, m) <- sivasutraTable ]

-- The pratyahara as an interval.  `pratyaharaOcc s m k` = the sounds from the
-- first occurrence of sound `s`, up to but not including the (k+1)-th
-- occurrence of marker `m` at or after it; intervening markers are skipped,
-- because a marker is a boundary and never a member.
pratyaharaOcc :: String -> String -> Int -> [String]
pratyaharaOcc s m k = go k (dropWhile (/= Snd s) varnasamamnaya)
  where
    go _ [] = []
    go n (It x : rest)
      | x == m    = if n <= 0 then [] else go (n - 1) rest
      | otherwise = go n rest
    go n (Snd x : rest) = x : go n rest

-- The convention the tradition uses: the FIRST occurrence of the marker at or
-- after the starting sound.  Only `ṇ` occurs twice as a marker (siva-sutras 1
-- and 6), and this convention gives the traditional value for both aṆ (= a i u,
-- the marker of sutra 1) and yaṆ (= y v r l, the marker of sutra 6), because
-- `y` sits after sutra 1's marker.  Where the tradition needs the OTHER reading
-- -- 1.1.69 `anudit savarnasya capratyayah` reads its own `aṇ` as the sutra-6
-- one, i.e. the vowels together with h y v r l -- use `pratyaharaOcc` with k=1.
pratyahara :: String -> String -> [String]
pratyahara s m = pratyaharaOcc s m 0

-- The raw span, markers included: what the interval actually covers in the
-- varnasamamnaya before the anubandhas are dropped.
rawSpan :: String -> String -> [Slot]
rawSpan s m = go (dropWhile (/= Snd s) varnasamamnaya)
  where
    go [] = []
    go (It x : rest) | x == m = []
    go (x : rest) = x : go rest

-- `h` occurs twice in the sequence (siva-sutra 5 and siva-sutra 14): the
-- sound-repetition that is one of the two devices letting every needed class
-- be an interval.  So haL has 34 slots and 33 distinct sounds.
pratyaharaSet :: String -> String -> [String]
pratyaharaSet s m = nub (pratyahara s m)

------------------------------------------------------------------------
-- 2.  PHONETICS: 1.1.9 tulyasyaprayatnam savarnam, 1.1.10 najjhalau
--
-- 1.1.9: two sounds are savarna when their PLACE (asya/sthana) and their
-- EFFORT (prayatna) are the same.  1.1.10 `najjhalau`: a vowel and a consonant
-- are never savarna, whatever the tables say -- an explicit override, encoded
-- as one.
------------------------------------------------------------------------

data Sthana
  = Kantha | Talu | Murdhan | Danta | Ostha
  | KanthaTalu | KanthaOstha | DantOstha
  deriving (Eq, Show)

-- The tradition distinguishes degrees of openness among the vivrta sounds
-- (Siddhantakaumudi on 1.1.9) precisely so that `e` and `ai` -- same place,
-- both open -- do not come out savarna.  `Vivrtatara` is that distinction.
data Prayatna
  = Sprsta        -- stops: full contact
  | IsatSprsta    -- semivowels: slight contact
  | IsadVivrta    -- sibilants and h: slightly open
  | Vivrta        -- vowels
  | Vivrtatara    -- ai, au
  deriving (Eq, Show)

data Phone = Phone
  { phName    :: String
  , phSthana  :: Sthana
  , phPrayatna :: Prayatna
  , phVowel   :: Bool
  , phGhosa   :: Bool   -- voiced
  , phMahaprana :: Bool -- aspirated
  , phNasal   :: Bool
  } deriving (Eq, Show)

vow :: String -> Sthana -> Prayatna -> Phone
vow n s p = Phone n s p True True False False

cons :: String -> Sthana -> Prayatna -> Bool -> Bool -> Bool -> Phone
cons n s p g mp na = Phone n s p False g mp na

phones :: [Phone]
phones =
  -- vowels
  [ vow "a" Kantha Vivrta,      vow "ā" Kantha Vivrta
  , vow "i" Talu Vivrta,        vow "ī" Talu Vivrta
  , vow "u" Ostha Vivrta,       vow "ū" Ostha Vivrta
  , vow "ṛ" Murdhan Vivrta,     vow "ṝ" Murdhan Vivrta
  , vow "ḷ" Danta Vivrta
  , vow "e" KanthaTalu Vivrta,  vow "ai" KanthaTalu Vivrtatara
  , vow "o" KanthaOstha Vivrta, vow "au" KanthaOstha Vivrtatara
  -- ka-varga
  , cons "k" Kantha Sprsta False False False
  , cons "kh" Kantha Sprsta False True False
  , cons "g" Kantha Sprsta True False False
  , cons "gh" Kantha Sprsta True True False
  , cons "ṅ" Kantha Sprsta True False True
  -- ca-varga
  , cons "c" Talu Sprsta False False False
  , cons "ch" Talu Sprsta False True False
  , cons "j" Talu Sprsta True False False
  , cons "jh" Talu Sprsta True True False
  , cons "ñ" Talu Sprsta True False True
  -- Ta-varga
  , cons "ṭ" Murdhan Sprsta False False False
  , cons "ṭh" Murdhan Sprsta False True False
  , cons "ḍ" Murdhan Sprsta True False False
  , cons "ḍh" Murdhan Sprsta True True False
  , cons "ṇ" Murdhan Sprsta True False True
  -- ta-varga
  , cons "t" Danta Sprsta False False False
  , cons "th" Danta Sprsta False True False
  , cons "d" Danta Sprsta True False False
  , cons "dh" Danta Sprsta True True False
  , cons "n" Danta Sprsta True False True
  -- pa-varga
  , cons "p" Ostha Sprsta False False False
  , cons "ph" Ostha Sprsta False True False
  , cons "b" Ostha Sprsta True False False
  , cons "bh" Ostha Sprsta True True False
  , cons "m" Ostha Sprsta True False True
  -- antahstha (semivowels)
  , cons "y" Talu IsatSprsta True False False
  , cons "r" Murdhan IsatSprsta True False False
  , cons "l" Danta IsatSprsta True False False
  , cons "v" DantOstha IsatSprsta True False False
  -- usman (sibilants and h)
  , cons "ś" Talu IsadVivrta False False False
  , cons "ṣ" Murdhan IsadVivrta False False False
  , cons "s" Danta IsadVivrta False False False
  , cons "h" Kantha IsadVivrta True False False
  -- visarga, an output of 8.3.15
  , cons "ḥ" Kantha IsadVivrta False False False
  ]

phoneOf :: String -> Maybe Phone
phoneOf n = listToMaybe [ p | p <- phones, phName p == n ]

-- 1.1.9 with the 1.1.10 override.
savarna :: String -> String -> Bool
savarna x y =
  case (phoneOf x, phoneOf y) of
    (Just p, Just q)
      | phVowel p /= phVowel q -> False              -- 1.1.10 najjhalau
      | otherwise -> phSthana p == phSthana q && phPrayatna p == phPrayatna q
    _ -> False

savarnasOf :: String -> [String]
savarnasOf x = [ phName p | p <- phones, savarna x (phName p) ]

-- 1.1.69 `anudit savarnasya capratyayah`: a sound named by the pratyahara aṆ
-- (read with the sutra-6 marker: the vowels together with h y v r l), or named
-- with `u` as its it-marker, denotes ALSO its savarnas.  This is why `aC`
-- reaches the long vowels, which are nowhere in the siva-sutras.
denotes :: [String] -> [String]
denotes xs = nub (concatMap expand xs)
  where
    anUdit = pratyaharaOcc "a" "ṇ" 1     -- the sutra-6 reading, per 1.1.69
    expand x | x `elem` anUdit = savarnasOf x
             | otherwise       = [x]

-- the classes used below, each an interval and nothing else
aC, iK, aK, eC, eN, haL, jhaL, khaR, jhaS_voiced, sTu, sCu, sTu_retro :: [String]
aC   = denotes (pratyahara "a" "c")        -- every vowel
iK   = denotes (pratyahara "i" "k")        -- i u ṛ ḷ + savarnas
aK   = denotes (pratyahara "a" "k")        -- a i u ṛ ḷ + savarnas
eC   = pratyahara "e" "c"                  -- e o ai au
eN   = pratyahara "e" "ṅ"                  -- e o
haL  = nub (pratyahara "h" "l")            -- every consonant
jhaL = nub (pratyahara "jh" "l")           -- stops + sibilants + h
khaR = nub (pratyahara "kh" "r")           -- voiceless stops + sibilants
jhaS_voiced = pratyahara "jh" "ś"          -- the voiced stops
sTu  = ["s","t","th","d","dh","n"]         -- 8.4.41's `stu`, s + ta-varga
sCu  = ["ś","c","ch","j","jh","ñ"]         -- `scu`, s' + ca-varga
sTu_retro = ["ṣ","ṭ","ṭh","ḍ","ḍh","ṇ"]    -- `stu` retroflex, s. + Ta-varga

------------------------------------------------------------------------
-- 3.  THE GRAMMAR: sutras carrying their position, because position is
--     semantic (1.4.2).
------------------------------------------------------------------------

type Ref = (Int, Int, Int)      -- adhyaya . pada . sutra

data SutraType
  = Samjna      -- definitional: gives a technical name
  | Paribhasa   -- interpretive: how to read other sutras
  | Vidhi       -- operational: performs a substitution
  | Niyama      -- restrictive
  | Atidesa     -- extension by analogy
  | Adhikara    -- heading: governs a range
  deriving (Eq, Show)

-- A juncture is not automatically a pada boundary.  6.1.109 conditions on
-- `padāntāt` -- pada-FINAL -- so `te + api` (two padas) and `ne - ana` (one
-- pada, root and kṛt affix) must be distinguishable, and they give different
-- answers: te'pi against nayana.  `Pada` is the pada boundary, `Morph` the
-- juncture inside a pada.
-- `Avasana` is a PAUSE, written `.` in the input.  It is here because
-- 6.1.72 `samhitayam` is a real condition and not a decoration: sandhi
-- applies in close juncture, and across a pause it does not.  Without a
-- pause in the input language the heading could not be shown doing
-- anything, and a gate that cannot fail is not a gate.
-- `Pratyaya` is the boundary written `~` in the input: the affix as it is
-- ENUNCIATED, markers and all, which is what the it-sutras of 1.3 operate on.
-- `lyuT` is l-y-u-T on the far side of a `~`; it is `ana` only after 1.3.3 and
-- 1.3.8 have marked and 1.3.9 has elided.  Without a boundary that says "an
-- upadesa starts here" those sutras have no locus and cannot be encoded at all.
--
-- WHY `It` AND `Lupta` ARE CONSTRUCTORS AND NOT A PARALLEL CHANNEL.  Everything
-- 1.1.56 needs about a substitute IS carried in a parallel channel (`Prov`,
-- section 7c) and `Item` is untouched by it, because a substitute occupies its
-- position and every function of `[Item]` alone still gives the right answer on
-- it.  Lopa is the opposite case and that is why it is here: by 1.1.60
-- `adarsanam lopah` an elided sound must be ABSENT from `render` and from
-- `nextPhBy` -- both of which are functions of `[Item]` and of nothing else --
-- and PRESENT to 1.1.5, which reads it.  A parallel flag on a `P` would leave
-- the sound visible to every sound-reading rule in the file, which is the one
-- thing lopa is defined to prevent.  So:
--
--   Anubandha s  a sound MARKED as an it by 1.3.3 / 1.3.8, still appearing.  1.3.9
--            has not yet run; `nextPhBy` sees it, `render` prints it.
--   Lupta s  1.3.9's output.  Invisible to `render` and to `nextPhBy` -- the
--            adarsana of 1.1.60 -- and readable by rules that condition on the
--            designation, which is 1.1.62 pratyayalaksanam.
--
-- This is `formal/cubical/Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.agda`
-- section 5's `ph`/`lupta` split, with the marked-but-not-yet-elided state the
-- Agda does not carry because there 1.3.9 has already run.
data Item = P String | Pada | Morph | Avagraha | Avasana
          | Pratyaya | Anubandha String | Lupta String
  deriving (Eq, Show)

data Rewrite = Rewrite
  { rSutra  :: Ref
  , rPos    :: Int          -- index of the first item replaced
  , rLen    :: Int          -- how many items replaced
  , rNew    :: [Item]
  , rRapara :: Int          -- items added by 1.1.51 `ur an raparah`
  , rNote   :: String
  } deriving (Show)

data Sutra = Sutra
  { num       :: Ref
  , text      :: String
  , gloss     :: String
  , styp      :: SutraType
  , apavadaTo :: [Ref]      -- utsargas this sutra is an exception to
  , fires     :: Reading -> [Item] -> [Rewrite]
  }

------------------------------------------------------------------------
-- 3a.  ANUVRTTI AND ADHIKARA -- what a sutra does not say.
--
-- A sutra of the Phonology is NOT LOCALLY READABLE.  `coh kuh` is two
-- words -- "of cU, kU" -- and it does not say where, or when, or what
-- kind of substitute.  The restriction it actually carries, `padasya`
-- ("of a pada"), is stated at 8.1.16, more than a hundred sutras earlier,
-- and runs forward through 8.3.54.  A reciter holding 8.2.30 alone holds
-- almost nothing; the content is in the context, and the context is
-- distributed over a block.
--
-- TWO DEVICES, and they are not the same one:
--
--   ANUVRTTI     a word stated once RUNS FORWARD into subsequent sutras
--                until it is cancelled (NIVRTTI) or replaced by a word
--                that specialises it.  The continuation is not written
--                anywhere.  It costs zero symbols.
--   ADHIKARA     a heading whose domain is a stated BLOCK: 6.1.72
--                `samhitayam` governs 6.1.72-6.1.157, 6.1.84
--                `ekah purvaparayoh` governs 6.1.84-6.1.111, 8.1.16
--                `padasya` governs 8.1.16-8.3.54.  A module parameter,
--                distributed over its scope.
--
-- WHAT CHANGED HERE (2026-08-20).  Before this section the sutras were
-- self-contained records: 8.2.30's pada-final restriction was written
-- into its own Haskell closure, and the adhikara table was an annotation
-- that `selfTest` read and the ENGINE did not.  That is the opposite of
-- how the text works.  Now:
--
--   * `fires` takes a `Reading`, not just an input.  A rule asks whether
--     a word is available to it -- `has "padasya" rd`, `has "aci" rd` --
--     and the answer is the same whether the word is written in the sutra
--     or inherited from elsewhere.  That is what anuvrtti IS: the meaning
--     is resolved at the point of APPLICATION, not at the point of
--     writing.
--   * `sutraAlone` prints a sutra with its gaps visible and says what it
--     inherits from where.
--   * every `Step` of a derivation carries the governing context the rule
--     was standing inside when it fired.
--   * cancelling a word is an experiment you can run: `deriveUnder`
--     takes extra nivrttis, and `selfTest` checks that removing a
--     heading changes the derived FORM.  An adhikara that could be
--     deleted without changing an output would be decoration.
--
-- WHAT IS ENCODED, and the limit.  Four continuations, listed below, each
-- one standard and checkable against the shape of the rules that inherit
-- it.  The Phonology's real anuvrtti graph runs to thousands of edges
-- and no source carrying it is reachable from this container (see the
-- 6.4.22 note in section 7a for the same egress limit).  So the laghava
-- figure in section 8a is a figure FOR THIS SAMPLE and a floor for the
-- text; it is not an estimate of the Phonology's compression, and
-- nothing here extrapolates to one.
------------------------------------------------------------------------

data Vrtti
  = Adhikrta Ref    -- an adhikara: governs the block ending at this Ref
  | Anuvrtta        -- a running word: forward from its statement until nivrtti
  deriving (Eq, Show)

data Inherited = Inherited
  { avWord  :: String
  , avGloss :: String
  , avFrom  :: Ref
  , avVrtti :: Vrtti
  } deriving (Eq, Show)

-- (the sutra that states it, the word, its gloss, how it runs)
anuvrttiTable :: [(Ref, String, String, Vrtti)]
anuvrttiTable =
  [ ((6,1,72), "saṃhitāyām", "in close juncture, no pause intervening"
      , Adhikrta (6,1,157))
  , ((6,1,77), "aci", "when a vowel (aC) follows", Anuvrtta)
  , ((6,1,84), "ekaḥ pūrvaparayoḥ"
      , "one substitute, in place of the preceding and the following together"
      , Adhikrta (6,1,111))
  , ((8,1,16), "padasya", "of a pada -- i.e. at the end of one", Adhikrta (8,3,54))
  ]

-- NIVRTTI: where a running word stops.  A word listed here does not reach
-- the sutra named, nor anything after it.  The third field is why, because
-- a cancellation with no reason is a free parameter.
--
-- MODELLING NOTE, stated rather than hidden: the vulgate reading of 6.1.109
-- `engah padantad ati` is that `ati` SPECIALISES the continued `aci` rather
-- than cancelling it (`ati` is narrower, so the two give the same firing
-- either way).  It is encoded as a cancellation because this engine has no
-- specialisation relation between conditions, and the two are
-- indistinguishable in every derivation this file runs.
nivrttiTable :: [(Ref, String, String)]
nivrttiTable =
  [ ((6,1,109), "aci", "6.1.109 states its own `ati`, which is narrower") ]

-- The context of a sutra: every word in force at it that is NOT written in
-- it.  `extra` supplies counterfactual cancellations, so that deleting a
-- heading is an experiment rather than an edit.
contextAtUnder :: [(Ref, String)] -> Ref -> [Inherited]
contextAtUnder extra r =
  sortOn avFrom
    [ Inherited w g src v
    | (src, w, g, v) <- anuvrttiTable
    , src < r                                    -- forward only; a word never
                                                 -- reaches what precedes it
    , inForce v
    , not (cancelledBefore w)
    ]
  where
    inForce (Adhikrta hi) = r <= hi
    inForce Anuvrtta      = True
    cancelledBefore w =
      any (\(at, w') -> w' == w && at <= r)
          ([ (a, b) | (a, b, _) <- nivrttiTable ] ++ extra)

contextAt :: Ref -> [Inherited]
contextAt = contextAtUnder []

-- What a sutra means at the point of application: what is written in it,
-- plus what is not.
data Reading = Reading
  { rdRef       :: Ref
  , rdText      :: String
  , rdInherited :: [Inherited]
  } deriving (Eq, Show)

readingUnder :: [(Ref, String)] -> Sutra -> Reading
readingUnder extra s = Reading (num s) (text s) (contextAtUnder extra (num s))

-- A rule asks this, and cannot tell -- and must not be able to tell --
-- whether the word is its own or inherited.  That indistinguishability is
-- the whole device.
has :: String -> Reading -> Bool
has w rd = w `elem` words (rdText rd) || w `elem` map avWord (rdInherited rd)

-- The full reading: inherited words, in the order of the sutras that state
-- them, then the sutra as transmitted.
fullReading :: Ref -> String
fullReading r = unwords (map avWord (contextAt r) ++ [text (sutraAt r)])

-- A sutra printed alone, with its incompleteness visible.  This is the
-- point of the section: the isolated sutra is not a unit of meaning.
sutraAlone :: Ref -> [String]
sutraAlone r =
  let s   = sutraAt r
      ctx = contextAt r
      own = length (words (text s))
      inh = length ctx
  in [ showR r ++ "  " ++ text s ]
     ++ (if null ctx
           then [ "        complete as it stands (" ++ show own ++ " words, none inherited)" ]
           else [ "        INCOMPLETE AS IT STANDS: " ++ show own ++ " word"
                    ++ plural own ++ " written, " ++ show inh
                    ++ " inherited and written nowhere here" ]
                ++ [ "          ← " ++ showR (avFrom a) ++ "  " ++ avWord a
                       ++ "  [" ++ kind (avVrtti a) ++ "]  " ++ avGloss a
                   | a <- ctx ]
                ++ [ "        full reading: " ++ fullReading r ])
  where
    plural n = if n == 1 then "" else "s"
    kind Anuvrtta      = "anuvṛtti"
    kind (Adhikrta hi) = "adhikāra, through " ++ showR hi

showR :: Ref -> String
showR (a,b,c) = show a ++ "." ++ show b ++ "." ++ show c

-- The adhikara table, DERIVED from the continuation table rather than kept
-- beside it, so the two cannot drift apart.
adhikaras :: [(Ref, Ref, String)]
adhikaras = [ (src, hi, w) | (src, w, _, Adhikrta hi) <- anuvrttiTable ]

governedBy :: Ref -> [String]
governedBy r = [ avWord a | a <- contextAt r, isAdhikara (avVrtti a) ]
  where isAdhikara (Adhikrta _) = True
        isAdhikara Anuvrtta     = False

-- 8.2.1 purvatrasiddham: everything from 8.2.1 on is asiddha for what precedes.
tripadi :: Ref -> Bool
tripadi (a, p, _) = a > 8 || (a == 8 && p >= 2)

------------------------------------------------------------------------
-- 4.  RULE HELPERS
------------------------------------------------------------------------

-- next phoneme after index i, skipping pada boundaries and avagrahas.
-- A PAUSE stops it: nothing follows, in samhita, across an avasana.
nextPh :: [Item] -> Int -> Maybe (Int, String)
nextPh = nextPhBy False

-- ...and the same walk with the pause ignored, which is what these rules
-- would do if 6.1.72 `samhitayam` were not standing over them.  Nobody
-- gets to choose this: `nextPhIn` reads the heading out of the Reading.
nextPhBy :: Bool -> [Item] -> Int -> Maybe (Int, String)
nextPhBy crossPause xs i = go (i + 1)
  where
    go j | j >= length xs = Nothing
    go j = case xs !! j of
             P s      -> Just (j, s)
             Anubandha s -> Just (j, s)  -- marked, not yet elided: still a sound
             Lupta _  -> go (j + 1)      -- 1.1.60 adarsanam lopah: NON-APPEARANCE
             Pratyaya -> go (j + 1)
             Pada     -> go (j + 1)
             Morph    -> go (j + 1)
             Avagraha -> go (j + 1)
             Avasana  -> if crossPause then go (j + 1) else Nothing

-- THE ADHIKARA, AT THE POINT OF APPLICATION.  6.1.72 `samhitayam` governs
-- 6.1.72-6.1.157 and is written in none of them.
nextPhIn :: Reading -> [Item] -> Int -> Maybe (Int, String)
nextPhIn rd = nextPhBy (not (has "saṃhitāyām" rd))

atPadanta :: [Item] -> Int -> Bool
atPadanta xs i = case drop (i + 1) xs of
                   (Pada : _)    -> True
                   (Avasana : _) -> True
                   []            -> True     -- avasana counts as pada-end
                   _             -> False

-- THE OTHER ADHIKARA, AT THE POINT OF APPLICATION.  8.1.16 `padasya`
-- governs 8.1.16-8.3.54.  8.2.30 `coh kuh` says nothing about padas; this
-- is where its pada-finality comes from, and cancelling the heading (see
-- `deriveUnder`) changes the derived form.
padantaIn :: Reading -> [Item] -> Int -> Bool
padantaIn rd xs i = not (has "padasya" rd) || atPadanta xs i

-- ANUVRTTI, AT THE POINT OF APPLICATION.  `aci` is written in 6.1.77 and
-- in none of 6.1.78, 6.1.87, 6.1.88, 6.1.101, which nonetheless all
-- condition on it.  `has` cannot tell the two cases apart, and that is
-- exactly the property anuvrtti has in the text.
aciIn :: Reading -> String -> Bool
aciIn rd t = not (has "aci" rd) || t `elem` aC

atAvasana :: [Item] -> Int -> Bool
atAvasana xs i = case drop (i + 1) xs of
                   []            -> True
                   (Avasana : _) -> True
                   _             -> False

------------------------------------------------------------------------
-- 4b.  उपदेशः -- THE AFFIX AS ENUNCIATED, AND ITS IT-MARKERS.
--      Added 2026-08-20, with the lopa machinery it exists to feed.
--
-- `lyuṬ` is enunciated l-y-u-ṭ and MEANS `ana`.  The distance between the
-- two is 1.3.3 `halantyam` (the final consonant is an it), 1.3.8
-- `laśakvataddhite` (an initial l, ś or kU is an it), 1.3.9 `tasya lopaḥ`
-- (that it is elided) and 7.1.1 `yuvor anākau`.  None of it can be encoded
-- without a boundary in the input saying "an upadeśa starts here", which is
-- what `~` and `Pratyaya` are.
--
-- WHAT IS NOT ENCODED, said here rather than implied by silence:
--   * 1.3.2 `upadeśe 'j anunāsika it` -- nasalised vowels as its.  The
--     engine has no nasalisation on vowels.
--   * 1.3.4 `na vibhaktau tusmāḥ`, 1.3.5-1.3.7 -- the other it rules.
--   * the taddhita restriction in 1.3.8 is vacuous here because no taddhita
--     affix is encoded; the rule is written with the restriction anyway,
--     because a rule stripped of a condition it always satisfies is a
--     different rule.
--   * 3.4.113-114 sārvadhātuka/ārdhadhātuka.  Every `~` affix here is
--     treated as ārdhadhātuka, which is what lyuṬ and kta are, and the
--     classification that would make the treatment general is absent.
------------------------------------------------------------------------

-- the upadeśa: every position after the last `Pratyaya` boundary.  An input
-- with no `~` in it has none, so nothing below can touch the derivations
-- that were here before.
upadesaSpan :: [Item] -> [Int]
upadesaSpan xs = case [ i | (i, Pratyaya) <- zip [0 ..] xs ] of
  [] -> []
  bs -> [ maximum bs + 1 .. length xs - 1 ]

-- the sounds of the upadeśa that still APPEAR.  1.1.60: an elided one does
-- not, and so is not a candidate for anything conditioned on a sound.
upadesaAudible :: [Item] -> [(Int, String)]
upadesaAudible xs =
  [ (i, s) | i <- upadesaSpan xs
           , s <- case xs !! i of P t -> [t]; Anubandha t -> [t]; _ -> [] ]

unmarked :: [Item] -> Int -> Bool
unmarked xs i = case xs !! i of P _ -> True; _ -> False

-- 1.3.3 halantyam: the FINAL sound of the upadeśa, if it is a hal.
halantyaAt :: [Item] -> [Int]
halantyaAt xs = case reverse (upadesaAudible xs) of
  ((i, s) : _) | s `elem` haL, unmarked xs i -> [i]
  _                                          -> []

-- 1.3.8 laśakvataddhite: an INITIAL l, ś or kU of a pratyaya (not a taddhita).
lasakvatAt :: [Item] -> [Int]
lasakvatAt xs = case upadesaAudible xs of
  ((i, s) : _) | s `elem` (["l","ś"] ++ kU), unmarked xs i -> [i]
  _                                                        -> []
  where kU = ["k","kh","g","gh","ṅ"]

-- 1.3.2-1.3.8 confer, 1.3.9 elides, and until both have run the affix is
-- still IN UPADEŚA.  Until then no aṅga rule looks at it -- which is what
-- `upadeśe`, running down from 1.3.2, says.  It is stated as a guard here
-- because this engine's scheduler is leftmost-first and the aṅga's vowel
-- lies to the LEFT of the affix's markers; the ordering is Pāṇini's, the
-- guard is this file's way of getting it.
itPending :: [Item] -> Bool
itPending xs = not (null (halantyaAt xs ++ lasakvatAt xs))
            || or [ True | Anubandha _ <- xs ]

-- 1.1.5 kṅiti ca, as the predicate it is: does the affix bear a k or a ṅ?
-- It reads the ELIDED marker -- 1.1.62 pratyayalakṣaṇam -- which is the whole
-- content of 1.1.60's `adarśana` rather than a deletion.
knitPratyaya :: [Item] -> Bool
knitPratyaya xs = or [ s `elem` ["k","ṅ"]
                     | i <- upadesaSpan xs
                     , s <- case xs !! i of
                              Lupta t     -> [t]
                              Anubandha t -> [t]
                              _           -> [] ]

-- the aṅga's final audible sound: the last one before the upadeśa begins.
angaAntya :: [Item] -> Maybe (Int, String)
angaAntya xs = case [ i | (i, Pratyaya) <- zip [0 ..] xs ] of
  [] -> Nothing
  bs -> listToMaybe [ (i, s) | i <- [maximum bs - 1, maximum bs - 2 .. 0]
                    , s <- case xs !! i of P t -> [t]; Anubandha t -> [t]; _ -> [] ]

phAt :: [Item] -> Int -> Maybe String
phAt xs i | i < 0 || i >= length xs = Nothing
          | otherwise = case xs !! i of P s -> Just s; _ -> Nothing

-- scan every position, offering the rewrites a rule wants
scan :: [Item] -> (Int -> String -> [Rewrite]) -> [Rewrite]
scan xs f = concat [ f i s | (i, P s) <- zip [0 ..] xs ]

guna :: String -> [Item]
guna x = case x of
  "i" -> [P "e"];  "ī" -> [P "e"]
  "u" -> [P "o"];  "ū" -> [P "o"]
  "ṛ" -> [P "a", P "r"];  "ṝ" -> [P "a", P "r"]   -- 1.1.51 ur aṇ raparaḥ
  "ḷ" -> [P "a", P "l"]                            -- 1.1.51, la-parah
  _   -> [P x]

gunaRapara :: String -> Int
gunaRapara x = if x `elem` ["ṛ","ṝ","ḷ"] then 1 else 0

vrddhi :: String -> String
vrddhi x = case x of
  "e" -> "ai"; "o" -> "au"; "ai" -> "ai"; "au" -> "au"
  "a" -> "ā";  "ā" -> "ā"
  "i" -> "ai"; "ī" -> "ai"; "u" -> "au"; "ū" -> "au"
  _   -> x

dirgha :: String -> String
dirgha x = case x of
  "a" -> "ā"; "ā" -> "ā"
  "i" -> "ī"; "ī" -> "ī"
  "u" -> "ū"; "ū" -> "ū"
  "ṛ" -> "ṝ"; "ṝ" -> "ṝ"
  _   -> x

yan :: String -> String
yan x = case x of
  "i" -> "y"; "ī" -> "y"
  "u" -> "v"; "ū" -> "v"
  "ṛ" -> "r"; "ṝ" -> "r"
  "ḷ" -> "l"
  _   -> x

ayavayav :: String -> [Item]
ayavayav x = case x of
  "e"  -> [P "a", P "y"]
  "o"  -> [P "a", P "v"]
  "ai" -> [P "ā", P "y"]
  "au" -> [P "ā", P "v"]
  _    -> [P x]

-- jas: the voiced unaspirated sound of the same varga (8.2.39, 8.4.53)
jas :: String -> String
jas x = case x of
  "k" -> "g";  "kh" -> "g";  "g" -> "g";  "gh" -> "g"
  "c" -> "j";  "ch" -> "j";  "j" -> "j";  "jh" -> "j"
  "ṭ" -> "ḍ";  "ṭh" -> "ḍ";  "ḍ" -> "ḍ";  "ḍh" -> "ḍ"
  "t" -> "d";  "th" -> "d";  "d" -> "d";  "dh" -> "d"
  "p" -> "b";  "ph" -> "b";  "b" -> "b";  "bh" -> "b"
  _   -> x

-- car: the voiceless unaspirated sound of the same varga (8.4.55, 8.4.56)
car :: String -> String
car x = case x of
  "k" -> "k";  "kh" -> "k";  "g" -> "k";  "gh" -> "k"
  "c" -> "c";  "ch" -> "c";  "j" -> "c";  "jh" -> "c"
  "ṭ" -> "ṭ";  "ṭh" -> "ṭ";  "ḍ" -> "ṭ";  "ḍh" -> "ṭ"
  "t" -> "t";  "th" -> "t";  "d" -> "t";  "dh" -> "t"
  "p" -> "p";  "ph" -> "p";  "b" -> "p";  "bh" -> "p"
  _   -> x

-- ku: the guttural of the same series (8.2.30 coh kuh)
ku :: String -> String
ku x = case x of
  "c" -> "k"; "ch" -> "kh"; "j" -> "g"; "jh" -> "gh"; "ñ" -> "ṅ"
  _   -> x

scuOf :: String -> String
scuOf x = case x of
  "s" -> "ś"; "t" -> "c"; "th" -> "ch"; "d" -> "j"; "dh" -> "jh"; "n" -> "ñ"
  _   -> x

stuRetroOf :: String -> String
stuRetroOf x = case x of
  "s" -> "ṣ"; "t" -> "ṭ"; "th" -> "ṭh"; "d" -> "ḍ"; "dh" -> "ḍh"; "n" -> "ṇ"
  _   -> x

------------------------------------------------------------------------
-- 5.  THE SUTRAS
--
-- Definitional and interpretive sutras carry no rewrite (`fires = const []`)
-- but ARE in the table, because they are the meaning of the vidhi rules that
-- cite them and because `coverage` must not flatter itself by counting only
-- the ones that do something visible.
------------------------------------------------------------------------

sutras :: [Sutra]
sutras =
  [ Sutra (1,1,1) "vṛddhir ādaic"
      "ā, ai, au are named vṛddhi" Samjna [] (\_ _ -> [])

  , Sutra (1,1,2) "adeṅ guṇaḥ"
      "a, e, o are named guṇa" Samjna [] (\_ _ -> [])

  , Sutra (1,1,3) "iko guṇavṛddhī"
      "guṇa/vṛddhi named without a locus operate on iK" Paribhasa [] (\_ _ -> [])

  -- 1.1.5 kniti ca.  A NISEDHA: it performs no substitution, it REFUSES
  -- one.  What it reads is a DESIGNATION -- kit, ngit -- conferred on the
  -- affix by 1.3.8 and erased from the affix by 1.3.9 before this rule is
  -- ever consulted.  So the whole content of 1.1.60 `adarsanam lopah` is
  -- here: the marker is gone from the surface and present to this
  -- condition.  Encoded as `knitPratyaya`, read by 7.3.84's guard, and
  -- audited by `knitAudit` -- which prints it as a refusal, because a
  -- prohibition that leaves no trace is indistinguishable from a rule that
  -- never applied.
  , Sutra (1,1,5) "kṅiti ca"
      "no guṇa or vṛddhi when the affix is marked kit or ṅit" Niyama [] (\_ _ -> [])

  , Sutra (1,1,9) "tulyāsyaprayatnaṃ savarṇam"
      "same place and same effort: savarṇa" Samjna [] (\_ _ -> [])

  , Sutra (1,1,10) "nājjhalau"
      "a vowel and a consonant are never savarṇa" Niyama [] (\_ _ -> [])

  , Sutra (1,1,51) "ur aṇ raparaḥ"
      "an aṆ replacing ṛ is followed by r" Paribhasa [] (\_ _ -> [])

  , Sutra (1,1,69) "aṇudit savarṇasya cāpratyayaḥ"
      "an aṆ sound, or one marked with u, denotes its savarṇas too" Paribhasa [] (\_ _ -> [])

  ----------------------------------------------------------------
  -- 1.3.3, 1.3.8, 1.3.9: the it-markers and their lopa.
  ----------------------------------------------------------------

  , Sutra (1,3,3) "halantyam"
      "the final hal of an upadeśa is an it" Samjna []
      (\_ xs ->
        [ Rewrite (1,3,3) i 1 [Anubandha s] 0
            ("upadeśa-final hal " ++ s ++ " is an it (1.3.3)")
        | i <- halantyaAt xs, Just s <- [phAt xs i] ])

  , Sutra (1,3,8) "laśakvataddhite"
      "an initial l, ś or kU of a pratyaya (not a taddhita) is an it" Samjna []
      (\_ xs ->
        [ Rewrite (1,3,8) i 1 [Anubandha s] 0
            ("pratyaya-initial " ++ s ++ " is an it (1.3.8)")
        | i <- lasakvatAt xs, Just s <- [phAt xs i] ])

  -- 1.3.9 tasya lopah.  `tasya` resumes the it-SAMJNA, not any sound: this
  -- is the rule that erases the marker AFTER it has done its marking, and
  -- 1.1.60 `adarsanam lopah` is what erasure means -- non-appearance, not
  -- removal.  `Lupta` is that distinction made in the type: invisible to
  -- `render` and to `nextPhBy`, readable by 1.1.5.  Run this engine with
  -- `vLopa = False` (`deriveWithoutLopaTrace`) and the marker is REMOVED
  -- instead, which is the naive implementation, and `ci ~ kta` comes out
  -- `ceta` rather than `cita`.
  , Sutra (1,3,9) "tasya lopaḥ"
      "the it is elided -- 1.1.60: non-appearance, not deletion" Vidhi []
      (\_ xs ->
        [ Rewrite (1,3,9) i 1 [Lupta s] 0
            ("the it " ++ s ++ " is elided (1.1.60 adarśana: it still conditions)")
        | (i, x) <- zip [0 ..] xs, Anubandha s <- [x] ])

  , Sutra (1,4,2) "vipratiṣedhe paraṃ kāryam"
      "in conflict, the later operation" Paribhasa [] (\_ _ -> [])

  , Sutra (6,1,72) "saṃhitāyām"
      "heading: in close juncture" Adhikara [] (\_ _ -> [])

  -- 6.1.77 iko yan aci.  OUTSIDE the 6.1.84 heading: replaces the preceding
  -- sound only, and the following vowel survives.  This is the sutra that
  -- STATES `aci`; everything below inherits it and none of them says it.
  , Sutra (6,1,77) "iko yaṇ aci"
      "iK becomes yaṆ before a vowel" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,77) i (j - i) [P (yan s)] 0
            ("iK " ++ s ++ " -> yaṆ " ++ yan s ++ " before aC " ++ t)
        | s `elem` iK
        , Just (j, t) <- [nextPhIn rd xs i]
        , aciIn rd t ]))

  -- 6.1.78 eco 'yavayavah.  Also outside the heading: e -> ay, ONE sound
  -- becomes TWO.  This is the case that proves the heading is doing work.
  -- Its `aci` is inherited from 6.1.77.
  , Sutra (6,1,78) "eco 'yavāyāvaḥ"
      "eC becomes ay/av/āy/āv before a vowel" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,78) i (j - i) (ayavayav s) 0
            ("eC " ++ s ++ " -> " ++ concat [ c | P c <- ayavayav s ] ++ " before aC " ++ t)
        | s `elem` eC
        , Just (j, t) <- [nextPhIn rd xs i]
        , aciIn rd t ]))

  , Sutra (6,1,84) "ekaḥ pūrvaparayoḥ"
      "heading: one substitute, for the preceding and the following together" Adhikara [] (\_ _ -> [])

  -- 6.1.87 ad gunah.  Inside the heading: two sounds out, one in.
  --
  -- ITS CONDITION IS ONE WORD LONG AND THAT WORD IS NOT IN IT.  `ad gunah`
  -- says "after a/aa, guna" -- guna of WHAT is `aci`, running down from
  -- 6.1.77.  This file previously wrote the condition as iK, which is not
  -- what the sutra says: iK is what SURVIVES after 6.1.88 (vrddhi before
  -- eC, an apavada) and 6.1.101 (dirgha before a savarna, later and so
  -- winning by 1.4.2) have taken their share.  Restoring the inherited
  -- reading makes those two metarules do the narrowing, which is where the
  -- narrowing belongs, and the utsarga/apavada machinery -- declared here
  -- since this file was written and never once exercised -- now fires on
  -- deva + aisvarya.
  , Sutra (6,1,87) "ād guṇaḥ"
      "a/ā followed by aC (inherited): guṇa replaces both" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,87) i (j - i + 1) (guna t) (gunaRapara t)
            ("a + aC " ++ t ++ " -> guṇa " ++ concat [ c | P c <- guna t ])
        | s `elem` ["a","ā"]
        , Just (j, t) <- [nextPhIn rd xs i]
        , aciIn rd t ]))

  -- 6.1.88 vrddhir eci.  Apavada to 6.1.87: the specific rule blocks the
  -- general one REGARDLESS of position.  With 6.1.87 read as the text has
  -- it -- before aC, inherited -- the two domains OVERLAP (eC is inside
  -- aC), which is what makes this an apavada at all; `selfTest` now checks
  -- that 6.1.88 beats 6.1.87 on deva + aisvarya.
  , Sutra (6,1,88) "vṛddhir eci"
      "a/ā followed by eC: vṛddhi replaces both" Vidhi [(6,1,87)]
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,88) i (j - i + 1) [P (vrddhi t)] 0
            ("a + eC " ++ t ++ " -> vṛddhi " ++ vrddhi t)
        | s `elem` ["a","ā"]
        , Just (j, t) <- [nextPhIn rd xs i]
        , t `elem` eC ]))

  -- 6.1.101 akah savarne dirghah.  Inside the heading.  Later than 6.1.77
  -- and later than 6.1.87, so 1.4.2 gives it the position when they collide:
  -- dadhi+indra -> dadhindra, not dadhyindra.  `savarne` qualifies the
  -- inherited `aci`, which is why the sutra can say "savarne" and nothing
  -- more.
  , Sutra (6,1,101) "akaḥ savarṇe dīrghaḥ"
      "aK followed by a savarṇa vowel: the long vowel replaces both" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,101) i (j - i + 1) [P (dirgha s)] 0
            (s ++ " + savarṇa " ++ t ++ " -> dīrgha " ++ dirgha s)
        | s `elem` aK
        , Just (j, t) <- [nextPhIn rd xs i]
        , aciIn rd t
        , savarna s t ]))

  -- 6.1.109 engah padantad ati.  Later than 6.1.78, so 1.4.2 gives it te+api
  -- -> te 'pi rather than 6.1.78's *tayapi.  It states its own `padantat`
  -- and its own `ati`, and by the latter the anuvrtti of `aci` stops here.
  , Sutra (6,1,109) "eṅaḥ padāntād ati"
      "pada-final e/o before a: the e/o alone remains (a is elided)" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (6,1,109) i (j - i + 1) [P s, Avagraha] 0
            ("pada-final " ++ s ++ " + a -> " ++ s ++ " (a elided, avagraha)")
        | s `elem` eN
        , atPadanta xs i
        , Just (j, t) <- [nextPhIn rd xs i]
        , t == "a" ]))

  ----------------------------------------------------------------
  -- 7.1.1 and 7.3.84: what the affix BECOMES, and what the stem does
  -- in front of it.  Two sutras of chapter 7, which this engine had
  -- none of, and they are here because 1.1.56 and 1.1.60 have nothing
  -- to operate on in pure sandhi -- every rule of 6.1 and of the
  -- tripadi is an al-vidhi, so the barrier's OTHER side needed a rule
  -- that reads a designation, and the designation-reading rules of
  -- this grammar are in 1.3 and 7.
  ----------------------------------------------------------------

  , Sutra (7,1,1) "yuvor anākau"
      "the affix-material yu becomes ana, vu becomes aka" Vidhi []
      (\_ xs ->
        [ Rewrite (7,1,1) i 2 [P a1, P a2, P a3] 0
            (y ++ u ++ " -> " ++ a1 ++ a2 ++ a3 ++ " (7.1.1)")
        | (i, y) : (j, u) : rest <- [upadesaAudible xs]
        , null rest, j == i + 1
        , (a1, a2, a3) <- case (y, u) of
                            ("y","u") -> [("a","n","a")]
                            ("v","u") -> [("a","k","a")]
                            _         -> [] ])

  -- 7.3.84 sarvadhatukardhadhatukayoh.  Guna of the anga's final vowel,
  -- and `ikah` -- of the iK -- is 1.1.3's supplying of the locus, not a
  -- word of this sutra.
  --
  -- TWO GUARDS, and neither is decoration:
  --   * `itPending`: while the affix still has its markers it is still in
  --     upadesa, and 1.3.2's `upadese` puts the it-rules before any anga
  --     rule.  Without this the leftmost-first scheduler would guna the
  --     stem before 1.3.8 had marked the k of kta, and 1.1.5 would arrive
  --     too late to refuse it.
  --   * `knitPratyaya`: 1.1.5 kniti ca.  This is the refusal, and it is
  --     made on a marker that 1.3.9 has already erased.
  , Sutra (7,3,84) "sārvadhātukārdhadhātukayoḥ"
      "before a sārvadhātuka or ārdhadhātuka affix: guṇa of the aṅga's final iK" Vidhi []
      (\_ xs ->
        [ Rewrite (7,3,84) i 1 (guna s) (gunaRapara s)
            ("aṅga-final iK " ++ s ++ " -> guṇa "
             ++ concat [ c | P c <- guna s ] ++ " before the pratyaya")
        | not (itPending xs)
        , not (knitPratyaya xs)                    -- 1.1.5 kṅiti ca refuses
        , Just (i, s) <- [angaAntya xs]
        , s `elem` iK ])

  ----------------------------------------------------------------
  -- THE TRIPADI.  8.2.1 makes everything from here asiddha for
  -- everything before, and `derive` runs these once, in order.
  ----------------------------------------------------------------

  , Sutra (8,2,1) "pūrvatrāsiddham"
      "what follows is as-if-not-effected for what precedes" Paribhasa [] (\_ _ -> [])

  -- 8.2.30 coh kuh.  TWO WORDS: "of cU, kU".  It does not say where.  The
  -- restriction is `padasya`, stated at 8.1.16 -- a hundred and some sutras
  -- back, in a different quarter-chapter -- and running through 8.3.54.
  -- `padantaIn` reads it out of the Reading, and `selfTest` cancels it to
  -- show that tat + ca then derives tatka instead of tacca.
  , Sutra (8,2,30) "coḥ kuḥ"
      "cU becomes kU (pada-final, by 8.1.16 padasya)" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (8,2,30) i 1 [P (ku s)] 0 ("cU " ++ s ++ " -> kU " ++ ku s ++ " at pada-end")
        | s `elem` ["c","ch","j","jh","ñ"]
        , padantaIn rd xs i ]))

  , Sutra (8,2,39) "jhalāṃ jaśo 'nte"
      "jhaL becomes jaŚ at the end (of a pada, by 8.1.16)" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (8,2,39) i 1 [P (jas s)] 0 ("jhaL " ++ s ++ " -> jaŚ " ++ jas s ++ " at pada-end")
        | s `elem` jhaL, jas s /= s
        , padantaIn rd xs i ]))

  , Sutra (8,2,66) "sasajuṣo ruḥ"
      "s becomes ru (pada-final, by 8.1.16 padasya)" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (8,2,66) i 1 [P "r"] 0 "pada-final s -> ru"
        | s == "s"
        , padantaIn rd xs i ]))

  , Sutra (8,3,15) "kharavasānayor visarjanīyaḥ"
      "r before khaR or in pause becomes visarga (pada-final, by 8.1.16)" Vidhi []
      (\rd xs -> scan xs (\i s ->
        [ Rewrite (8,3,15) i 1 [P "ḥ"] 0 "r -> visarga (before khaR, or in pause)"
        | s == "r"
        , padantaIn rd xs i
        , case nextPh xs i of
            Nothing     -> True                 -- avasana
            Just (_, t) -> t `elem` khaR ]))

  , Sutra (8,4,40) "stoḥ ścunā ścuḥ"
      "s/ta-varga in contact with ś/ca-varga becomes ścu" Vidhi []
      (\_ xs -> concat
        [ r
        | (i, P s) <- zip [0 ..] xs
        , Just (j, t) <- [nextPh xs i]
        , let r | s `elem` sTu && t `elem` sCu =
                    [ Rewrite (8,4,40) i (j - i) [P (scuOf s)] 0
                        ("stu " ++ s ++ " -> ścu " ++ scuOf s ++ " before " ++ t) ]
                | s `elem` sCu && t `elem` sTu =
                    [ Rewrite (8,4,40) j 1 [P (scuOf t)] 0
                        ("stu " ++ t ++ " -> ścu " ++ scuOf t ++ " after " ++ s) ]
                | otherwise = []
        , not (null r) ])

  , Sutra (8,4,41) "ṣṭunā ṣṭuḥ"
      "s/ta-varga in contact with ṣ/Ta-varga becomes ṣṭu" Vidhi []
      (\_ xs -> concat
        [ r
        | (i, P s) <- zip [0 ..] xs
        , Just (j, t) <- [nextPh xs i]
        , let r | s `elem` sTu && t `elem` sTu_retro =
                    [ Rewrite (8,4,41) i (j - i) [P (stuRetroOf s)] 0
                        ("stu " ++ s ++ " -> ṣṭu " ++ stuRetroOf s ++ " before " ++ t) ]
                | s `elem` sTu_retro && t `elem` sTu =
                    [ Rewrite (8,4,41) j 1 [P (stuRetroOf t)] 0
                        ("stu " ++ t ++ " -> ṣṭu " ++ stuRetroOf t ++ " after " ++ s) ]
                | otherwise = []
        , not (null r) ])

  , Sutra (8,4,53) "jhalāṃ jaś jhaśi"
      "jhaL becomes jaŚ before jhaŚ" Vidhi []
      (\_ xs -> scan xs (\i s ->
        [ Rewrite (8,4,53) i (j - i) [P (jas s)] 0
            ("jhaL " ++ s ++ " -> jaŚ " ++ jas s ++ " before jhaŚ " ++ t)
        | s `elem` jhaL, jas s /= s
        , Just (j, t) <- [nextPh xs i]
        , t `elem` jhaS_voiced ]))

  , Sutra (8,4,55) "khari ca"
      "jhaL becomes caR before khaR" Vidhi []
      (\_ xs -> scan xs (\i s ->
        [ Rewrite (8,4,55) i (j - i) [P (car s)] 0
            ("jhaL " ++ s ++ " -> caR " ++ car s ++ " before khaR " ++ t)
        | s `elem` jhaL, car s /= s
        , Just (j, t) <- [nextPh xs i]
        , t `elem` khaR ]))

  , Sutra (8,4,56) "vāvasāne"
      "jhaL in pause optionally becomes caR" Vidhi []
      (\_ xs -> scan xs (\i s ->
        [ Rewrite (8,4,56) i 1 [P (car s)] 0
            ("jhaL " ++ s ++ " -> caR " ++ car s ++ " in pause")
        | s `elem` jhaL, car s /= s
        , atAvasana xs i ]))
  ]

------------------------------------------------------------------------
-- 6.  TOKENIZER AND RENDERER
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5a.  THE KARAKA LAYER, 2026-08-19 -- the SEMANTIC entry point.
--
-- Everything above this is phonology: forms meeting forms.  `coverage`
-- has been saying "nothing of the karaka system" since this file was
-- written, and that is the half where the Phonology stops describing
-- sound and starts computing FROM MEANING.
--
-- THE ARCHITECTURE, which is not the Western one.  Panini does not go
-- meaning -> syntax -> sound.  He goes
--
--     karaka (semantic role)  ->  vibhakti (case)  ->  sandhi
--
-- and there is no constituent-structure layer at all; Sanskrit word order
-- is free because the endings already carry who did what to whom.
--
-- THE SUTRAS, sourced 2026-08-19 rather than recalled:
--
--   2.3.1  अनभिहिते  anabhihite -- a governing ADHIKARA: the rules below
--          apply only if the information has NOT ALREADY BEEN EXPRESSED.
--          It is what makes the karaka layer and the case layer separable
--          at all, and the term contrasts with `abhihite`: anabhihite
--          governs karma-vacya (passive), abhihite the kartr-vacya
--          (active) subject.
--   2.3.2  कर्मणि द्वितीया  karmani dvitiya -- when not otherwise
--          expressed, the SECOND vibhakti in the sense of karman.
--   2.3.18 कर्तृकरणयोस्तृतीया  kartrkaranayos trtiya -- the THIRD for
--          kartr and karana.
--
-- WHAT THE ENDING EXPRESSES.  In the active the verbal ending expresses
-- the kartr; in the passive it expresses the karman.  Whatever it
-- expresses is thereby `abhihita`, 2.3.1 withdraws, and the nominative
-- appears instead.
--
-- SOURCING LIMIT, stated because it is a real one: the precise sutra
-- locus for the nominative on the abhihita karaka is NOT confirmed by the
-- sources reached here (both sutra sites carrying the texts are blocked
-- by the network egress policy).  The PRINCIPLE -- what is already
-- expressed takes prathama -- is what the 2.3.1 contrast states, and is
-- what is encoded; the number is left unclaimed rather than guessed.
--
-- WHY THIS IS THE INTERESTING HALF.  The same scene under two voices has
-- THE SAME KARAKAS and DIFFERENT VIBHAKTIS.  Devadatta is the kartr in
-- both `devadattah odanam pacati` and `devadattena odanah pacyate`; the
-- world did not change and the roles did not change.  Only the mapping
-- did, because 2.3.1 withdrew a rule when the ending already carried the
-- fact.  That is two levels coming apart, and it is why the karaka layer
-- cannot be collapsed into the case layer -- the thing Fillmore's "The
-- Case for Case" (1968) proposed, with no anabhihite, 2400 years later.
------------------------------------------------------------------------

-- THE SIX KARAKAS, completed 2026-08-23.  The file shipped with three
-- (Kartr, Karman, Karana) and its header said so.  The full six are the
-- defining sutras of 1.4, each sourced, so the semantic layer is whole and
-- a scene can carry every role a channel needs (adhikarana = the locus,
-- e.g. a proof hole; karana = the instrument, e.g. a lemma; karman = the
-- term acted on):
--   1.4.54 स्वतन्त्रः कर्ता            kartr, the agent
--   1.4.49 कर्तुरीप्सिततमं कर्म         karman, the most-desired-to-attain
--   1.4.42 साधकतमं करणम्              karana, the most-effective means
--   1.4.32 कर्मणा यमभिप्रैति स सम्प्रदानम् sampradana, the recipient
--   1.4.24 ध्रुवमपायेऽपादानम्          apadana, the fixed point of departure
--   1.4.45 आधारोऽधिकरणम्              adhikarana, the locus
data Karaka = Kartr | Karman | Karana | Sampradana | Apadana | Adhikarana
  deriving (Eq, Show)

-- the seven vibhaktis (Sasthi is śeṣe, not a karaka case; kept for the
-- complete declension the channel renders into)
data Vibhakti = Prathama | Dvitiya | Trtiya | Caturthi | Panchami | Sasthi | Saptami
  deriving (Eq, Show)

data Vacya = Kartari | Karmani          -- active, passive
  deriving (Eq, Show)

-- what the verbal ending itself expresses, and is therefore `abhihita`
abhihita :: Vacya -> Karaka
abhihita Kartari = Kartr
abhihita Karmani = Karman

-- 2.3.1 as a GATE, not an annotation: the assignment rules below are
-- consulted only for a karaka the ending has not already expressed.
vibhaktiOf :: Vacya -> Karaka -> (Vibhakti, String)
vibhaktiOf v k
  | k == abhihita v = (Prathama,  "abhihita: the ending already expresses it, so 2.3.1 withdraws")
  | k == Karman     = (Dvitiya,   "2.3.2 कर्मणि द्वितीया")
  | k == Kartr      = (Trtiya,    "2.3.18 कर्तृकरणयोस्तृतीया")
  | k == Karana     = (Trtiya,    "2.3.18 कर्तृकरणयोस्तृतीया")
  | k == Sampradana = (Caturthi,  "2.3.13 चतुर्थी सम्प्रदाने")
  | k == Apadana    = (Panchami,  "2.3.28 अपादाने पञ्चमी")
  | k == Adhikarana = (Saptami,   "2.3.36 सप्तम्यधिकरणे च")
  | otherwise       = (Sasthi,    "2.3.50 षष्ठी शेषे")

-- a scene: which participants fill which roles.  This is the INPUT to the
-- Phonology, and it is not a string.
type Drshya = [(Karaka, String)]

pacatiScene :: Drshya
pacatiScene = [ (Kartr, "devadatta"), (Karman, "odana") ]

-- a full six-role scene: devadatta gives rice to the brahmin from the pot
-- with his hand in the house.  Every karaka filled, so `assign` marks each
-- participant with a single case and the order is free — the minimal
-- overhead channel, one utterance carrying who-did-what-to-whom-whence-
-- wherewith-where.
dadatiScene :: Drshya
dadatiScene =
  [ (Kartr, "devadatta"), (Karman, "odana"), (Sampradana, "brahmana")
  , (Apadana, "sthali"), (Karana, "hasta"), (Adhikarana, "grha") ]

-- the case each participant receives, under a chosen voice
assign :: Vacya -> Drshya -> [(String, Karaka, Vibhakti, String)]
assign v scene =
  [ (who, k, vb, why) | (k, who) <- scene, let (vb, why) = vibhaktiOf v k ]

-- longest-match over the phoneme inventory: `dh` before `d`, `ai` before `a`
tokenize :: String -> [String]
tokenize [] = []
tokenize s =
  case [ n | n <- longestFirst, n `isPrefixOf` s ] of
    (n : _) -> n : tokenize (drop (length n) s)
    []      -> [ [head s] ] ++ tokenize (tail s)   -- unknown sound, kept whole
  where
    longestFirst = sortOn (negate . length) (map phName phones)

parseInput :: String -> [Item]
parseInput = go . words
  where
    go []           = []
    go ["+"]        = []
    go ["-"]        = []
    go ["."]        = []
    go ["~"]        = []
    go ("+" : rest) = Pada     : go rest
    go ("-" : rest) = Morph    : go rest
    go ("." : rest) = Avasana  : go rest
    go ("~" : rest) = Pratyaya : go rest
    go (w : rest)   = map P (tokenize w) ++ go rest

render :: [Item] -> String
render = concatMap f
  where
    f (P s)    = s
    f Pada      = " "
    f Morph     = ""
    f Avasana   = " "
    f Avagraha  = "'"
    f Pratyaya  = ""
    f (Anubandha s) = s    -- marked and still there: 1.3.9 has not run
    f (Lupta _) = ""       -- 1.1.60 adarsanam lopah

------------------------------------------------------------------------
-- 7.  THE ENGINE
--
-- Section A (1.1.1 .. 8.1.x): all rules mutually siddha; run to a fixpoint,
--   resolving conflicts by apavada first, then by 1.4.2 paratva.
-- Section B (8.2.1 .. 8.4.x, the tripadi): each rule ONCE, in numeric order,
--   seeing only what precedes it.  That IS 8.2.1.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6c.  स्थानिवद्भावः -- 1.1.56, AS A CHANNEL AND NOT AS A REMARK.
--      Added 2026-08-20.
--
--   1.1.56  स्थानिवदादेशोऽनल्विधौ   sthānivad ādeśo 'nalvidhau
--           An ādeśa is LIKE the sthānin -- except in an al-vidhi, an
--           operation conditioned on the sounds themselves (aL is the
--           pratyāhāra of the whole inventory).
--
-- So a substitute inherits the original's DESIGNATIONS and not its FORM.
-- That is an abstraction barrier with a named exception for the clients
-- that inspect the representation, and the exception is a CLASS OF RULES,
-- not a per-site escape hatch -- which is the part the modern folklore
-- version (transparent, or opaque, pick one) has no vocabulary for.
--
-- WHAT WAS HERE BEFORE.  Nothing.  `Item` was `P String` and a rewrite
-- overwrote it, so the moment 8.2.30 turned `c` into `k` the `c` was gone
-- from the machine and no later rule could have read it even if 1.1.56
-- told it to.  `machine/Nigrahasthana_...hs` recorded exactly this gap:
-- "the al-vidhi direction is asserted; the designation direction is
-- recorded as absent."  The channel below is the missing half.
--
-- THE CHANNEL IS PARALLEL AND `Item` IS UNTOUCHED BY IT.  A substitute
-- occupies its position and appears; every function of `[Item]` alone
-- still gives the right answer about it, so nothing about the ādeśa needs
-- to be in the item.  (Lopa is the opposite case, and that is why `Lupta`
-- IS a constructor -- see the note on `Item`.)
------------------------------------------------------------------------

-- WHICH READING A RULE TAKES.  `NoVidhi` is not a third kind of rule: it
-- is the answer at a site that holds no ādeśa, where the two readings
-- coincide and 1.1.56 has nothing to say.
data Vidhi = AlVidhi | AnalVidhi | NoVidhi
  deriving (Eq, Show)

-- स्थानी -- what a position stands in place of.
--
-- ONE MODELLING CHOICE, AND THE TRADITION DISPUTES IT.  `snOrig` is what
-- was standing at the position immediately before the substitution -- ONE
-- step back, not the whole chain.  Whether sthānivadbhāva composes (is the
-- ādeśa of an ādeśa sthānivat to the FIRST sthānin?) is argued in the
-- Mahābhāṣya on 1.1.56 and is not settled by the sūtra's wording.  One
-- step is taken here because it is what the encoded derivations need and
-- because a chain would have to be justified, not assumed; a run that
-- wants the other reading is a change to `applyRwP` and to nothing else.
data Sthanin = Sthanin
  { snAdesa :: String     -- the substitute now standing here
  , snOrig  :: String     -- what it stands in place of
  , snBy    :: Ref        -- the sūtra that put it there
  } deriving (Eq, Show)

-- Index-for-index with the `[Item]`.  A shorter list reads as all-Nothing,
-- so no caller can get an off-by-one silently.
type Prov = [Maybe Sthanin]

navah :: [Item] -> Prov
navah = map (const Nothing)

provAt :: Prov -> Int -> Maybe Sthanin
provAt pv i | i < 0 || i >= length pv = Nothing
            | otherwise               = pv !! i

-- The sound at a position, as it now stands.  `Lupta` has none: 1.1.60.
rupaAt :: [Item] -> Int -> String
rupaAt xs i | i < 0 || i >= length xs = ""
            | otherwise = case xs !! i of
                            P s  -> s
                            Anubandha s -> s
                            _    -> ""

-- 1.1.56 AT THE MOMENT OF SUBSTITUTION.  Applying a rewrite writes the
-- ādeśa into the word and the sthānin into the channel, at the same index.
-- Where 6.1.84 `ekaḥ pūrvaparayoḥ` takes two sounds and gives one, the
-- sthānin recorded is the two joined -- which is what the sūtra says the
-- substitute stands in place of, and which is deliberately not a single
-- sound of the inventory (`phoneOf` declines it, so no rule can pretend to
-- condition on it).
applyRwP :: ([Item], Prov) -> Rewrite -> ([Item], Prov)
applyRwP (xs, pv) rw@(Rewrite r i n new _ _) =
  (applyRw xs rw, take i pv ++ map mark new ++ drop (i + n) pv)
  where
    orig = concat [ rupaAt xs j | j <- [i .. i + n - 1] ]
    mark (P s) | not (null orig), s /= orig = Just (Sthanin s orig r)
    mark _ = Nothing

-- अल्विधिः -- WHICH ENCODED RULES ARE CONDITIONED ON THE SOUNDS.
--
-- Declared, with the text and the reason, one entry per sūtra in `sutras`;
-- `selfTest` checks the table is TOTAL, so no rule can acquire a reading
-- by defaulting.  A boolean guessed at each `fires` would have been an
-- assertion with no place to put its justification.
--
-- READ THE THIRD COLUMN BEFORE THE SECOND.  Two of these are genuinely
-- argued in the commentaries and are marked DISPUTED rather than decided:
-- an operation whose locus is a pada-final sound conditions on a saṃjñā
-- (pada) AND on an aL, and which of the two makes it an al-vidhi is not
-- settled by 1.1.56's wording.  They are entered as al-vidhi because the
-- SUBSTITUEND in each is a sound; the other reading is one line away and
-- the note says so.
alVidhiTable :: [(Ref, Vidhi, String)]
alVidhiTable =
  [ ((1,1,1),   NoVidhi,   "vṛddhir ādaic -- saṃjñā, performs no operation")
  , ((1,1,2),   NoVidhi,   "adeṅ guṇaḥ -- saṃjñā")
  , ((1,1,3),   NoVidhi,   "iko guṇavṛddhī -- paribhāṣā")
  , ((1,1,5),   AnalVidhi, "kṅiti ca -- conditions on the DESIGNATIONS kit and "
                           ++ "ṅit, which are marks, not sounds.  The only "
                           ++ "anal-vidhi in this table, and the one 1.3.9's "
                           ++ "lopa is read by")
  , ((1,1,9),   NoVidhi,   "tulyāsyaprayatnaṃ savarṇam -- saṃjñā")
  , ((1,1,10),  NoVidhi,   "nājjhalau -- niyama on the saṃjñā")
  , ((1,1,51),  NoVidhi,   "ur aṇ raparaḥ -- paribhāṣā")
  , ((1,1,69),  NoVidhi,   "aṇudit savarṇasya cāpratyayaḥ -- paribhāṣā")
  , ((1,3,3),   AlVidhi,   "halantyam -- the condition is `hal`, a pratyāhāra "
                           ++ "of sounds, and `antya`, final.  Conditioned on "
                           ++ "the sound")
  , ((1,3,8),   AlVidhi,   "laśakvataddhite -- the condition is the sounds l, ś "
                           ++ "and kU.  `taddhite` restricts the locus and does "
                           ++ "not change what is read")
  , ((1,3,9),   AnalVidhi, "tasya lopaḥ -- `tasya` resumes the it-SAṂJÑĀ "
                           ++ "conferred by 1.3.2-1.3.8, not any sound.  It "
                           ++ "elides whatever bears the designation")
  , ((1,4,2),   NoVidhi,   "vipratiṣedhe paraṃ kāryam -- paribhāṣā")
  , ((6,1,72),  NoVidhi,   "saṃhitāyām -- adhikāra")
  , ((6,1,77),  AlVidhi,   "iko yaṇ aci -- substituend iK, condition aC; both "
                           ++ "pratyāhāras of sounds")
  , ((6,1,78),  AlVidhi,   "eco 'yavāyāvaḥ -- substituend eC.  This is the "
                           ++ "worked case: no function of the designations "
                           ++ "agrees with it, proved in "
                           ++ "formal/cubical/Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.agda")
  , ((6,1,84),  NoVidhi,   "ekaḥ pūrvaparayoḥ -- adhikāra")
  , ((6,1,87),  AlVidhi,   "ād guṇaḥ -- substituend a/ā before aC")
  , ((6,1,88),  AlVidhi,   "vṛddhir eci -- substituend a/ā before eC")
  , ((6,1,101), AlVidhi,   "akaḥ savarṇe dīrghaḥ -- substituend aK, and savarṇa "
                           ++ "is 1.1.9's relation between SOUNDS")
  , ((6,1,109), AlVidhi,   "eṅaḥ padāntād ati -- DISPUTED.  Substituend eṄ and "
                           ++ "the following `a`, both sounds; but `padāntāt` "
                           ++ "is a pada-saṃjñā condition.  Entered as al-vidhi "
                           ++ "on the substituend")
  , ((7,1,1),   AnalVidhi, "yuvor anākau -- the substituends `yu` and `vu` are "
                           ++ "named as UPADEŚA forms of affixes, and the rule "
                           ++ "reaches them through the pratyaya-saṃjñā.  "
                           ++ "DISPUTED: read as naming two sound-sequences it "
                           ++ "is an al-vidhi.  Entered as anal-vidhi because "
                           ++ "the locus is the affix and not a sound of it")
  , ((7,3,84),  AlVidhi,   "sārvadhātukārdhadhātukayoḥ -- guṇa of the aṅga's "
                           ++ "final iK by 1.1.3; the substituend is a sound")
  , ((8,2,1),   NoVidhi,   "pūrvatrāsiddham -- paribhāṣā")
  , ((8,2,30),  AlVidhi,   "coḥ kuḥ -- DISPUTED, as 6.1.109.  Substituend cU, a "
                           ++ "pratyāhāra of sounds; locus `padasya` from 8.1.16")
  , ((8,2,39),  AlVidhi,   "jhalāṃ jaśo 'nte -- substituend jhaL.  THE "
                           ++ "DIVERGENCE CASE: on `vāc` this rule fires at a "
                           ++ "position 8.2.30 has already substituted, and the "
                           ++ "two readings of that position give different words")
  , ((8,2,66),  AlVidhi,   "sasajuṣo ruḥ -- substituend the sound s")
  , ((8,3,15),  AlVidhi,   "kharavasānayor visarjanīyaḥ -- substituend r, "
                           ++ "condition khaR; `avasāna` is a pause and not a "
                           ++ "sound, which does not make the substituend one")
  , ((8,4,40),  AlVidhi,   "stoḥ ścunā ścuḥ -- sTu and ścU, both classes of sounds")
  , ((8,4,41),  AlVidhi,   "ṣṭunā ṣṭuḥ -- ṣṭu, a class of sounds")
  , ((8,4,53),  AlVidhi,   "jhalāṃ jaś jhaśi -- jhaL before jhaŚ")
  , ((8,4,55),  AlVidhi,   "khari ca -- jhaL before khaR")
  , ((8,4,56),  AlVidhi,   "vāvasāne -- jhaL in pause")
  ]

-- दृष्टिः -- the READING REGIME a whole run takes.  `Yathasutram` is the
-- grammar as Pāṇini states it: `alVidhiTable` decides per rule.  The other
-- two strike one half of 1.1.56 each and are COUNTERFACTUALS -- they are
-- here so the sūtra's clause can be shown to be load-bearing rather than
-- described as load-bearing.
data Drsti = Yathasutram | SthanivatSarvatra | RupamSarvatra
  deriving (Eq, Show)

-- The lopa half is a separate switch because it is a separate sūtra.
-- `vLopa False` makes 1.3.9 DELETE instead of leaving an adarśana, which
-- is the naive implementation 1.1.60 exists to forbid.
data Vidhana = Vidhana
  { vDrsti :: Drsti
  , vLopa  :: Bool
  } deriving (Eq, Show)

yathasutram :: Vidhana
yathasutram = Vidhana Yathasutram True

vidhiOf :: Ref -> Vidhi
vidhiOf r = head ([ v | (q, v, _) <- alVidhiTable, q == r ] ++ [AlVidhi])

vidhiWhy :: Ref -> String
vidhiWhy r = head ([ w | (q, _, w) <- alVidhiTable, q == r ]
                   ++ ["not in alVidhiTable -- defaulted to al-vidhi"])

-- The reading in force, under a regime.  A NoVidhi rule performs no
-- operation, so no regime has anything to change about it.
drstiVidhi :: Drsti -> Ref -> Vidhi
drstiVidhi d r = case (d, vidhiOf r) of
  (_, NoVidhi)               -> NoVidhi
  (Yathasutram, v)           -> v
  (SthanivatSarvatra, _)     -> AnalVidhi   -- `anal-vidhau` struck out
  (RupamSarvatra, _)         -> AlVidhi     -- `sthānivat` struck out

-- दृष्टम् -- WHAT A RULE IS HANDED.  This is the barrier itself: an
-- anal-vidhi is given the word with every ādeśa replaced by its sthānin,
-- so it cannot tell the substitute from the original; an al-vidhi is given
-- the word as it stands.  Indices are preserved, so a rewrite offered
-- against the view applies to the word.
drsta :: Vidhi -> ([Item], Prov) -> [Item]
drsta AnalVidhi (xs, pv) = [ f x (provAt pv i) | (i, x) <- zip [0 ..] xs ]
  where f (P _) (Just sn) = P (snOrig sn)
        f x _             = x
drsta _ (xs, _) = xs

seenBy :: Vidhana -> Sutra -> ([Item], Prov) -> [Item]
seenBy vd s wp = drsta (drstiVidhi (vDrsti vd) (num s)) wp

-- Every offer a sūtra makes, through the barrier.  `vLopa False` is the
-- counterfactual engine in which 1.3.9 removes the it rather than leaving
-- it as an adarśana; nothing else in the file knows about it.
firesV :: Vidhana -> Sutra -> Reading -> ([Item], Prov) -> [Rewrite]
firesV vd s rd wp =
  [ if vLopa vd || num s /= (1,3,9)
      then r
      else r { rNew = [], rNote = rNote r ++ " (COUNTERFACTUAL: deleted, not elided)" }
  | r <- fires s rd (seenBy vd s wp) ]

-- WHAT THE SITE HELD AND WHAT THE RULE READ THERE, for the trace.
-- Returns (view, sthānin, form, what it read, did it cross the barrier).
sthaniAt :: Vidhana -> Ref -> ([Item], Prov) -> Rewrite -> (Vidhi, String, String, String, Bool)
sthaniAt vd r (xs, pv) rw =
  let i    = rPos rw
      n    = max 1 (rLen rw)
      cell j = case provAt pv j of
                 Just sn -> (snAdesa sn, snOrig sn)
                 Nothing -> (rupaAt xs j, rupaAt xs j)
      cells = map cell [i .. i + n - 1]
      form  = concatMap fst cells
      orig  = concatMap snd cells
      view  | form == orig = NoVidhi
            | otherwise    = drstiVidhi (vDrsti vd) r
      saw   = case view of AnalVidhi -> orig; _ -> form
  in (view, orig, form, saw, view == AlVidhi && form /= orig)

data Step = Step
  { stSutra   :: Ref
  , stText    :: String
  , stNote    :: String
  , stBeaten  :: [Ref]       -- rules that also wanted this position and lost
  , stReason  :: String      -- why this one won
  , stBefore  :: String
  , stAfter   :: String
  , stInherited :: [Inherited]   -- the governing context the rule was standing
                                 -- inside when it fired.  A trace that names
                                 -- the sutra and not this names half of it.
    -- 1.1.56, per step.  A trace that names the sutra and the context and NOT
    -- these says which rule fired and not what it was looking at.
  , stView    :: Vidhi     -- which reading 1.1.56 gave this rule here
  , stSthanin :: String    -- what the site stands in place of
  , stForm    :: String    -- what is actually standing there
  , stSaw     :: String    -- which of the two the rule was handed
  , stThroughBarrier :: Bool  -- an adesa was there and the rule read past it
  } deriving (Show)

applyRw :: [Item] -> Rewrite -> [Item]
applyRw xs (Rewrite _ i n new _ _) = take i xs ++ new ++ drop (i + n) xs

overlaps :: Rewrite -> Rewrite -> Bool
overlaps a b = rPos a < rPos b + rLen b && rPos b < rPos a + rLen a

-- utsarga/apavada, then 1.4.2.
--
-- TWO CASES THE METARULES DO NOT DECIDE, and until 2026-08-20 the order of
-- the list was deciding them silently:
--
--   * two competitors carrying the SAME Ref.  1.4.2 `vipratiṣedhe paraṃ
--     kāryam` compares POSITIONS IN THE TEXT, and equal positions are not
--     comparable, so paratva has nothing to say.  `maximumBy` returned one
--     anyway.
--   * two or more apavādas inside one competing set.  Utsarga/apavāda ranks
--     a PAIR -- this rule is the exception to that one -- and says nothing
--     about which of two exceptions wins.  `(r : _)` took the first.
--
-- `resolveN` returns the same winner in every case (`resolve` is exactly its
-- projection, so no derivation changes) and additionally returns the
-- competitors WHEN NOTHING DECIDED THEM, so section 7b can record the debt
-- instead of the caller inheriting a decision the grammar never made.
resolveN :: [Rewrite] -> (Rewrite, [Ref], String, Maybe [Ref])
resolveN [r] = (r, [], "sole candidate", Nothing)
resolveN rs =
  let apavadas = [ r | r <- rs, any (\o -> rSutra o `elem` apavadaTo (sutraAt (rSutra r))) rs ]
      refs = map rSutra rs
      undecided
        | length apavadas > 1                             = Just (map rSutra apavadas)
        | null apavadas && length (nub refs) < length refs = Just refs
        | otherwise                                       = Nothing
  in case apavadas of
       (r : _) -> (r, [ rSutra o | o <- rs, rSutra o /= rSutra r ]
                  , "apavāda blocks the utsarga (elsewhere condition)", undecided)
       []      -> let w = maximumBy (comparing rSutra) rs
                  in (w, [ rSutra o | o <- rs, rSutra o /= rSutra w ]
                     , "1.4.2 vipratiṣedhe paraṃ kāryam: the later sūtra", undecided)

resolve :: [Rewrite] -> (Rewrite, [Ref], String)
resolve rs = let (a, b, c, _) = resolveN rs in (a, b, c)

sutraAt :: Ref -> Sutra
sutraAt r = head ([ s | s <- sutras, num s == r ] ++ [ missing ])
  where missing = Sutra r "?" "?" Vidhi [] (\_ _ -> [])

sectionA :: [Sutra]
sectionA = [ s | s <- sutras, not (tripadi (num s)) ]

sectionB :: [Sutra]
sectionB = sortOn num [ s | s <- sutras, tripadi (num s) ]

-- one fixpoint step over the mutually-siddha section.  `nv` carries extra
-- nivrttis, so that "what if this heading were not there" is a run and not
-- an edit.
--
-- EVERY OFFER NOW COMES THROUGH THE BARRIER.  `firesV` hands each sūtra the
-- view 1.1.56 gives IT -- the form, or the sthānin -- so which rules see
-- through is decided by `alVidhiTable` and by nothing local.  Under
-- `yathasutram` every operational rule in this table is an al-vidhi except
-- 1.1.5, 1.3.9 and 7.1.1, so the view usually IS the word and the derivations
-- that were here before are unchanged; that they are unchanged is checked.
stepANV :: Vidhana -> [(Ref, String)] -> ([Item], Prov)
        -> Maybe (Rewrite, [Ref], String, Maybe [Ref])
stepANV vd nv wp =
  case sortOn rPos (concatMap (\s -> firesV vd s (readingUnder nv s) wp) sectionA) of
    []  -> Nothing
    all_ ->
      let leftmost = minimum (map rPos all_)
          here     = [ r | r <- all_, overlaps r (head [ q | q <- all_, rPos q == leftmost ]) ]
      in Just (resolveN here)

stepANUnder :: [(Ref, String)] -> [Item] -> Maybe (Rewrite, [Ref], String, Maybe [Ref])
stepANUnder nv xs = stepANV yathasutram nv (xs, navah xs)

stepAUnder :: [(Ref, String)] -> [Item] -> Maybe (Rewrite, [Ref], String)
stepAUnder nv xs = fmap (\(w, l, why, _) -> (w, l, why)) (stepANUnder nv xs)

stepA :: [Item] -> Maybe (Rewrite, [Ref], String)
stepA = stepAUnder []

deriveTrace :: [Item] -> ([Step], [Item])
deriveTrace = deriveTraceUnder []

deriveTraceUnder :: [(Ref, String)] -> [Item] -> ([Step], [Item])
deriveTraceUnder nv start = let (sts, xs, _) = deriveLekhaUnder nv start in (sts, xs)

-- लेखः -- WHAT THE ENGINE SAW WHILE IT RAN, added 2026-08-20 for section 7b.
--
-- Three things were being computed and dropped on every derivation: the
-- offers that were made and lost or never taken, the loci where the
-- metarules did not separate the contenders, and the fact that a GUARD
-- rather than a fixpoint ended the run.  The last is the worst of the
-- three -- a partial form was returned in the same shape as a finished one,
-- so nothing downstream could tell them apart.
data Lekha = Lekha
  { lVrtta    :: [([Item], [(Ref, Int, Int)])]  -- each configuration, and every (sūtra, pos, len) offered against it
  , lAnirnita :: [([Item], Int, [Ref])]         -- configuration, locus, contenders the metarules did not separate
  , lAsamapta :: Maybe Int                      -- the guard, and the count it tripped at
  } deriving (Show)

deriveLekha :: [Item] -> ([Step], [Item], Lekha)
deriveLekha = deriveLekhaUnder []

deriveLekhaUnder :: [(Ref, String)] -> [Item] -> ([Step], [Item], Lekha)
deriveLekhaUnder = deriveLekhaV yathasutram

-- THE DERIVATION, WITH THE PROVENANCE CHANNEL THREADED.  The word is
-- `([Item], Prov)` from here down: `applyRwP` writes the sthānin into the
-- channel at the moment of substitution, `firesV` hands each rule the view
-- 1.1.56 gives it, and `sthaniAt` records on the Step which of the two
-- readings the rule was given at the site it fired on.  Every construction
-- site of a `Step` in this file goes through `mkStep`, so no step can be
-- built without saying what it was looking at.
deriveLekhaV :: Vidhana -> [(Ref, String)] -> [Item] -> ([Step], [Item], Lekha)
deriveLekhaV vd nv start =
  let (sts, (xs, _), lg) = phaseB (phaseA 0 (start, navah start) [] (Lekha [] [] Nothing))
  in (sts, xs, lg)
  where
    reading s = readingUnder nv s

    mkStep r wp@(xs, _) rw lost why ys inh =
      let (vw, sn, fm, saw, thru) = sthaniAt vd r wp rw
      in Step r (text (sutraAt r)) (rNote rw) lost why (render xs) (render ys)
              inh vw sn fm saw thru

    -- every offer against this configuration, from EVERY sūtra in the table.
    -- Not only the section whose turn it is: the question section 7b asks is
    -- "did anything in the grammar ever reach for this juncture", and a rule
    -- refused by asiddhatva still reached for it.
    note wp@(xs, _) lg = lg { lVrtta = lVrtta lg ++
                        [ (xs, [ (num s, rPos r, rLen r)
                               | s <- sutras, r <- firesV vd s (reading s) wp ]) ] }

    phaseA :: Int -> ([Item], Prov) -> [Step] -> Lekha -> ([Step], ([Item], Prov), Lekha)
    phaseA k wp@(xs, _) acc lg
      | k > 64 = (reverse acc, wp, lg { lAsamapta = Just k })  -- guard; no derivation here is long
      | otherwise =
          let lg' = note wp lg in
          case stepANV vd nv wp of
          Nothing -> (reverse acc, wp, lg')
          Just (w, lost, why, undec) ->
            let wq@(ys, _) = applyRwP wp w
                st = mkStep (rSutra w) wp w lost why ys
                       (rdInherited (reading (sutraAt (rSutra w))))
                lg'' = case undec of
                         Nothing -> lg'
                         Just rf -> lg' { lAnirnita = lAnirnita lg' ++ [(xs, rPos w, rf)] }
            in if ys == xs then (reverse acc, wp, lg'')
                           else phaseA (k + 1) wq (st : acc) lg''

    phaseB :: ([Step], ([Item], Prov), Lekha) -> ([Step], ([Item], Prov), Lekha)
    phaseB (acc, wp0, lg0) = go sectionB wp0 acc lg0
      where
        go [] wp acc' lg = (acc', wp, lg)
        go (s : ss) wp acc' lg =
          -- a tripadi rule applies to a fixpoint on ITS OWN output (a rule is
          -- siddha to itself) but never sees a later rule, and is never
          -- revisited once passed.
          let (wp', steps, lg') = saturate s wp [] lg
          in go ss wp' (acc' ++ steps) lg'

        saturate s wp@(xs, _) acc' lg =
          let lgN = note wp lg in
          case firesV vd s (reading s) wp of
            [] -> (wp, reverse acc', lgN)
            (r : _) ->
              let wq@(ys, _) = applyRwP wp r
              in if ys == xs then (wp, reverse acc', lgN)
                 else if length acc' > 16
                   then (wp, reverse acc', lgN { lAsamapta = Just (length acc') })
                   else saturate s wq
                          (mkStep (num s) wp r [] "tripādī: in order, 8.2.1"
                             ys (rdInherited (reading s)) : acc') lgN


------------------------------------------------------------------------
-- 7a.  ASIDDHAVAT -- the OTHER device, 6.4.22, added 2026-08-19.
--
-- Panini spends a sutra on each of two regimes and they are not variants
-- of one another.  This engine had only the first:
--
--   8.2.1  purvatrasiddham       any SUBSEQUENT rule is asiddha with
--          (Phonology 8.2.1)    respect to any rule that PRECEDES it, so
--                                the tripadi applies strictly in the order
--                                enumerated.  One-way, backwards blindness.
--                                `deriveTrace`'s phaseB, above.
--
--   6.4.22 asiddhavad atrabhat   the change a stem undergoes by any rule
--          (heads 6.4.22-6.4.129) of that section counts as NOT HAVING
--                                TAKEN EFFECT when applying any OTHER rule
--                                of the same section.  MUTUAL invisibility;
--                                the rules apply AS IF SIMULTANEOUSLY.
--
-- The corpus already carries the distinction under its Jain name --
-- `formal/cubical/Saptabhangi.agda` proves krama (successive) and saha
-- (simultaneous) arpana reach DIFFERENT positions, so simultaneity is not
-- sequential both-ness -- and `formal/cubical/Asiddhatva.agda` proves the
-- ordered regime buys termination.  This is the simultaneous regime, so
-- the engine can exhibit the difference instead of the corpus asserting it.
--
-- NO SUTRA OF 6.4 IS ENCODED, and that makes this mechanism one with no
-- content of its own -- the shelf shape this session kept finding
-- elsewhere.  Recorded rather than left implied.  What IS sourced
-- (2026-08-19): 6.4.64 ato lopa iti ca elides a root-final aa before an
-- ardhadhatuka affix with the augment iT, and carries 6.4.22 in its
-- anuvrtti; 6.4.98 elides the root-vowel of gam han jan khan ghas before
-- a kit/ngit affix beginning with a vowel, but not before the aorist aNg,
-- and also carries 6.4.22.  A worked case for the first is dhmaa + liT
-- giving dhadhmatuh, where 6.4.64 elides the aa after reduplication.
--
-- NOT IMPLEMENTED, and why rather than silently: running 6.4 needs
-- ardhadhatuka/sarvadhatuka classification, the iT-augment rules, kit/ngit
-- marking and reduplication -- a subsystem this engine does not have -- and
-- the two sutra sites that carry the texts (sanskritdictionary.com,
-- learnsanskrit.org) are both blocked by the network egress policy here.
-- Building it from the fragments above would be reconstructing Sanskrit
-- from memory, which is the failure this repository exists to prevent.
-- The mechanism is exercised counterfactually below until that is fixed.
--
-- WHAT IS AND IS NOT CLAIMED.  The rules run below are the tripadi's own,
-- which belong to the ORDERED regime; running them simultaneously is a
-- COUNTERFACTUAL, not a claim about Sanskrit.  Its purpose is to show that
-- the regime itself changes the output -- that the choice of device is
-- load-bearing rather than presentational.  No sutra of 6.4 is encoded
-- here; the schematic treatment is the same choice
-- formal/cubical/NaturalMachine/AsiddhatvaBreaksFactoring.agda makes and
-- says it makes ("three letters and one substitution... deliberate").

-- One asiddhavat pass: every rule of the block is offered the SAME input,
-- so none of them sees any other's effect.  Non-overlapping rewrites are
-- then applied together; where two rewrites overlap, the block cannot
-- perform both at once and 1.4.2 decides, exactly as it does elsewhere.
asiddhavatPass :: [Sutra] -> [Item] -> ([Step], [Item])
asiddhavatPass block xs = let (sts, ys, _) = asiddhavatPassP block (xs, navah xs)
                          in (sts, ys)

-- the same pass with the channel threaded, so a simultaneous step records
-- what its site held exactly as an ordered one does
asiddhavatPassP :: [Sutra] -> ([Item], Prov) -> ([Step], [Item], Prov)
asiddhavatPassP block wp@(xs, _) =
  let offers = [ (s, r) | s <- block, r <- firesV yathasutram s (readingUnder [] s) wp ]
      chosen = pick (sortOn (rPos . snd) offers)
      -- apply right-to-left so earlier positions keep their indices
      (ys, pw) = foldl applyRwP wp (reverse (sortOn rPos (map snd chosen)))
      steps = [ let (vw, sn, fm, saw, thru) = sthaniAt yathasutram (num s) wp r
                in Step (num s) (text s) (rNote r) [] "asiddhavat: simultaneous, 6.4.22"
                        (render xs) (render ys) (contextAt (num s))
                        vw sn fm saw thru
              | (s, r) <- chosen ]
  in (steps, ys, pw)
  where
    pick [] = []
    pick ((s, r) : rest) =
      let clash = [ o | o <- rest, overlaps r (snd o) ]
          winner = foldl (\a b -> if num (fst b) > num (fst a) then b else a) (s, r) clash
      in winner : pick [ o | o <- rest, not (overlaps (snd winner) (snd o)) ]

-- The same rules under both regimes.  If the two agree everywhere the
-- device is presentational; `selfTest` checks that they do not.
deriveAsiddhavat :: String -> String
deriveAsiddhavat = render . snd . asiddhavatPass sectionB . snd
                 . deriveTrace' . parseInput
  where
    -- section A only, so the comparison isolates the tripadi regime
    deriveTrace' xs0 = go (0 :: Int) xs0
      where
        go k xs | k > 64 = ([] :: [Step], xs)
        go k xs = case stepA xs of
                    Nothing -> ([], xs)
                    Just (w, _, _) ->
                      let ys = applyRw xs w
                      in if ys == xs then ([], xs) else go (k + 1) ys

derive :: String -> String
derive = render . snd . deriveTrace . parseInput

-- CANCELLING A HEADING IS AN EXPERIMENT, NOT AN EDIT.  Supply extra
-- nivrttis and derive again; if the form does not change, the word was
-- decoration.  `selfTest` runs this on 8.1.16 `padasya`, on 6.1.72
-- `samhitayam`, and on the anuvrtti of `aci`, and all three change a form.
deriveUnder :: [(Ref, String)] -> String -> String
deriveUnder nv = render . snd . deriveTraceUnder nv . parseInput

-- 1.1.56 AND 1.1.60, RUN THE OTHER WAY.  Cancelling a clause of a sutra is
-- an experiment here, the same way cancelling a heading is: strike
-- `anal-vidhau` and every rule reads the sthanin, strike `sthanivat` and
-- every rule reads the form, make 1.3.9 delete and 1.1.5 has nothing to
-- read.  Each is a RUN of the same sutras, not an edited grammar.
deriveV :: Vidhana -> String -> String
deriveV vd = render . (\(_, x, _) -> x) . deriveLekhaV vd [] . parseInput

deriveTraceV :: Vidhana -> [Item] -> ([Step], [Item])
deriveTraceV vd start = let (sts, xs, _) = deriveLekhaV vd [] start in (sts, xs)

-- `sthanivat` with the exception struck: every rule reads the sthanin.
deriveSthanivatEverywhere :: String -> String
deriveSthanivatEverywhere = deriveV (Vidhana SthanivatSarvatra True)

-- the other half struck: every rule reads the form, which is the engine as
-- it stood before this section existed.
deriveRupamEverywhere :: String -> String
deriveRupamEverywhere = deriveV (Vidhana RupamSarvatra True)

-- 1.3.9 as a DELETION rather than an adarsana.  1.1.60 is what this run
-- does not have.
deriveWithoutLopa :: String -> String
deriveWithoutLopa = deriveV (Vidhana Yathasutram False)

deriveWithoutLopaTrace :: [Item] -> ([Step], [Item])
deriveWithoutLopaTrace = deriveTraceV (Vidhana Yathasutram False)

-- 1.1.56, doing visible work.  Every step of the real derivation at which
-- the site held an adesa AND the rule was an al-vidhi, so it read past the
-- barrier to the form.  Where this list is empty the barrier was never
-- tested in that derivation; where it is not, the counterfactual
-- `deriveSthanivatEverywhere` on the same input gives a different word.
barrierAudit :: [Item] -> [(Ref, Vidhi, String, String)]
barrierAudit start =
  [ (stSutra st, stView st, stSthanin st, stForm st)
  | st <- fst (deriveTrace start), stThroughBarrier st ]

-- 1.1.60, doing visible work.  Every configuration of the real derivation at
-- which 7.3.84's guna is refused by 1.1.5 reading a marker 1.3.9 erased.  The
-- reason carries the counterfactual, because a refusal whose consequence is
-- not shown is indistinguishable from a rule that never applied.
knitAudit :: [Item] -> [(Ref, String)]
knitAudit start =
  nub [ ( (1,1,5)
        , "the affix bears " ++ marks cfg ++ ", elided by 1.3.9 and read here: "
          ++ "guṇa of the aṅga-final " ++ s ++ " by 7.3.84 is refused, and the "
          ++ "form is " ++ render final ++ ".  Delete the marker instead of "
          ++ "eliding it and the same sūtras give " ++ render noLopa )
      | (cfg, _) <- lVrtta lg
      , knitPratyaya cfg
      , not (itPending cfg)
      , Just (_, s) <- [angaAntya cfg]
      , s `elem` iK ]
  where
    (_, final, lg) = deriveLekha start
    (_, noLopa)    = deriveWithoutLopaTrace start
    marks cfg = intercalate ", "
      (nub [ t | i <- upadesaSpan cfg
               , t <- case cfg !! i of
                        Lupta u     | u `elem` ["k","ṅ"] -> [u]
                        Anubandha u | u `elem` ["k","ṅ"] -> [u]
                        _                                -> [] ])

-- 8.2.1 purvatrasiddham, doing visible work.
--
-- The derived form is deliberately NOT a global fixpoint of the rule set.
-- Rules that precede the one which created the final context would happily
-- fire on it, and are refused, because for them that context does not exist.
-- `vac` is the case: 8.2.30 gives k, 8.2.39 gives g, 8.4.56 gives k again --
-- and 8.2.39 would now turn that k back into g, forever.  Asiddhatva is what
-- makes the grammar terminate, not a bookkeeping nicety.  This lists every
-- such refusal.
asiddhaAudit :: [Item] -> [(Ref, String)]
asiddhaAudit start =
  let (_, final) = deriveTrace start
  in [ (num s, rNote r)
     | s <- sutras
     , r <- fires s (readingUnder [] s) final
     , applyRw final r /= final ]

------------------------------------------------------------------------
-- 7b.  शेषः -- THE RESIDUAL.  Added 2026-08-20.
--
-- यो शेषं त्यजति तस्य यन्त्रं न चलति ।
-- A system that discards what it could not resolve has nothing left to run on.
--
-- THE SOURCE.  Āryabhaṭa, Āryabhaṭīya 2.32-33 (499 CE), the kuṭṭaka: divide,
-- KEEP THE REMAINDER, recurse on the remainder.  The quotient column is the
-- vallī and the answer is read by climbing it -- the intermediate trace IS
-- the result, not scratch work thrown away once a result is reached.  Space
-- log, time log, no table.
--
-- WHAT IS NOT CLAIMED, stated first because it is the easy overclaim.  The
-- kuṭṭaka terminates because its remainders STRICTLY DECREASE.  Nothing here
-- strictly decreases; a residual is frequently a larger object than the
-- configuration that produced it.  What holds instead is FINITENESS -- the
-- queue is a set of keys over the finite juncture alphabet, and requeue is
-- suppressed explicitly.  "It is the kuṭṭaka, therefore it terminates" is
-- false.  What is taken from Āryabhaṭa is the DISPOSAL RULE (keep the
-- remainder, it is the material) and not the termination proof.
--
-- THE PRECEDENT IN THIS REPOSITORY.  `machine/Obstruction.hs` did this for
-- the theorem engine: the kernel's refusals carried the exact pair of terms
-- at which computation stalled, and every one of them was truncated to 160
-- characters and collapsed to `False`.  1303 residuals recovered, 112
-- distinct, ranked by how many parent goals each would unblock (`0 = y·0`
-- unblocked fourteen).  The engine had been stating which lemma it needed
-- next, ~1200 times a round, and deleting all of it.
--
-- THE SAME THING HERE, and where it was going.  A derivation stalls in four
-- ways and all four were being swallowed:
--
--   अनक्षरम्  Anaksaram -- a token that is not a sound of the
--             varṇasamāmnāya.  Every sūtra conditions through pratyāhāras
--             over the 42 sounds, so NO sūtra can mention it; the grammar is
--             definitionally silent.  `tokenize` kept it whole and said
--             nothing.
--   असूत्रम्  Asutram -- a boundary survives into the final form and no
--             sūtra ever offered a rewrite touching it, at any configuration
--             of the run.  The rule set has nothing in its domain here.
--   अनिर्णीतम् Anirnitam -- two or more rewrites contend for one locus and
--             the metarules do not separate them: equal Refs (1.4.2 compares
--             positions in the text, and equal positions are incomparable),
--             or two apavādas within one competing set (utsarga/apavāda
--             ranks a PAIR, not two specifics).  `resolve` took `head` and
--             the debt vanished.
--   असमाप्तम् Asamaptam -- the fixpoint guard tripped (k > 64 in section A,
--             16 iterations in one tripādī rule).  The partial form was
--             returned as though it were final.
--
-- A residual is emitted at every stall and carries the configuration, the
-- position, the juncture, the competing refs, and the parent input that
-- demanded it -- so the debt is traceable to what asked for it.  Then
-- `nirnaya` triages WITH EVIDENCE, `pravesha` admits or turns back WITH ITS
-- GROUND (the discipline of Obstruction.hs: नकारः खण्डनं ददाति, स्वीकारः
-- साक्षिणम् -- nowhere a bare truth-value), and `sesaPrasna` ranks what
-- entered by HOW MANY DISTINCT PARENTS demand it.  That ranking is the
-- machine stating which sūtra it needs next, derived from where its own work
-- stalled rather than guessed by a person from a frequency table.
------------------------------------------------------------------------

-- हेतुः -- which of the four stalls, carrying what distinguishes it.
data Hetu
  = Anaksaram String    -- the token outside the varṇasamāmnāya
  | Asutram             -- a surviving boundary no sūtra ever reached for
  | Anirnitam [Ref]     -- the competitors the metarules did not separate
  | Asamaptam Int       -- the guard, and the count it tripped at
  deriving (Eq, Show)

-- सन्धिः -- the juncture as the machine sees it: what precedes, the boundary
-- itself, what follows.  `Nothing` on a side means there is no sound there,
-- which is the case `nirnaya` calls निर्धर्मिन्.
type Sandhi = (Maybe String, Item, Maybe String)

-- शेषः.  Everything the stall knew at the moment it stalled.
data Sesa = Sesa
  { sHetu    :: Hetu
  , sSandhi  :: Sandhi     -- the configuration at the stall, localised
  , sSthana  :: Int        -- WHERE, as an index into sRupa
  , sRupa    :: [Item]     -- the whole configuration, so the locus is checkable
  , sSpardhi :: [Ref]      -- who contended here (empty when nobody did)
  , sDrsta   :: [Ref]      -- who DID reach for this juncture during the run
  , sJanaka  :: String     -- the parent that demanded it
  } deriving (Eq, Show)

-- The key a residual is remembered by.  The parent is DELIBERATELY not in
-- it: counting distinct parents per key is the ranking, so a key that
-- included the parent would rank everything 1 and say nothing.
type SesaKey = (Hetu, Sandhi)

sesaKey :: Sesa -> SesaKey
sesaKey s = (sHetu s, sSandhi s)

-- What the machine is asking for, in one line.
sesaPrccha :: Sesa -> String
sesaPrccha s = case sHetu s of
  Anaksaram t -> "no sound " ++ show t ++ " in the varṇasamāmnāya: "
                 ++ "no pratyāhāra reaches it, so no sūtra can condition on it"
  Asutram     -> "no sūtra offers at " ++ showSandhi (sSandhi s)
  Anirnitam rs -> "two sūtras at one locus and no metarule separates them: "
                 ++ intercalate ", " (map showR rs)
  Asamaptam k -> "the derivation did not converge (" ++ show k ++ " steps)"

showSandhi :: Sandhi -> String
showSandhi (l, b, r) =
  maybe "∅" id l ++ " " ++ boundary b ++ " " ++ maybe "∅" id r
  where boundary Pada      = "+"
        boundary Avasana   = "."
        boundary Morph     = "-"
        boundary Avagraha  = "'"
        boundary Pratyaya  = "~"
        boundary (Anubandha x) = x
        boundary (Lupta x) = "(" ++ x ++ ")"    -- 1.1.60: written, not appearing
        boundary (P x)     = x

-- The juncture alone, restated as an input.
--
-- THIS IS NOT EQUIVALENT TO THE PARENT, and the machine says so: `sesah` on
-- it gives a DIFFERENT key.  Extracted from "tam + ca" the pair m + c has the
-- c at avasana, where 8.2.30 cohkuh turns it into k, and the juncture the
-- residual named no longer exists.  A residual does not survive being taken
-- out of the trace that produced it -- which is why `sJanaka` is carried and
-- why `abhyasa` re-asks the PARENT and not this.  Kept, and checked, because
-- the negative result is the content.
sesaPada :: Sesa -> String
sesaPada s = case sSandhi s of
  (Just l, Pada,  Just r) -> l ++ " + " ++ r
  (Just l, Morph, Just r) -> l ++ " - " ++ r
  (Just l, _,     Just r) -> l ++ " " ++ r
  (Just l, _,     Nothing) -> l
  (Nothing, _,    Just r)  -> r
  _ -> ""

-- निर्णयः -- the verdict on one residual, and every constructor carries the
-- evidence that put it there.  This is `Obstruction.hs`'s `Verdict`, the same
-- four positions for the same reason: a verdict without its ground arrives
-- downstream stripped of why, and nothing downstream can ask.
-- नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् -- क्वापि न शून्यबोधः ।
data Nirnaya
  = Aviruddha [Ref]   -- अविरुद्ध -- unrefuted, CARRYING THE DOMAIN SEARCHED:
                      -- which sūtras were offered this configuration and did
                      -- not reach for it.  Not "a rule is missing here" --
                      -- the absence of one over a stated extent, which is the
                      -- yogya condition and is meaningless without the extent.
  | Khandita Ref      -- खण्डित -- refuted: a sūtra DID reach for this juncture
                      -- during the run, so it is not a gap in the rule set.
                      -- Carrying which.  A refutation is exact.
  | Nirdharmin String -- निर्धर्मिन् -- no subject to predicate of, carrying
                      -- which side was empty.
  | Tusnim String     -- तूष्णीम् -- the grammar declines to speak, carrying the
                      -- token outside its sound system that silenced it.
  deriving (Eq, Show)

nirnaya :: Sesa -> Nirnaya
nirnaya s = case sHetu s of
  Anaksaram t  -> Tusnim t
  Anirnitam rs -> Aviruddha rs
  Asamaptam _  -> Aviruddha (nub (sDrsta s))
  Asutram      -> case sSandhi s of
    (Nothing, _, _) -> Nirdharmin "nothing precedes the boundary"
    (_, _, Nothing) -> Nirdharmin "nothing follows the boundary"
    _ -> case sDrsta s of
           (r : _) -> Khandita r
           []      -> Aviruddha vidhiRefs

-- The extent actually searched, for अविरुद्ध on a juncture: every operational
-- sūtra in the table.  An unrefutedness that does not say over what is the
-- unfalsifiable number this repository's protocol forbids.
vidhiRefs :: [Ref]
vidhiRefs = [ num s | s <- sutras, styp s == Vidhi ]

-- प्रवेशः -- admission, WITH ITS GROUND on both sides.  The extension is
-- Obstruction.hs's, deliberately: अविरुद्ध and तूष्णीम् enter, खण्डित and
-- निर्धर्मिन् turn back.  तूष्णीम् entering is not an oversight -- a token the
-- sound system does not contain is a debt against the INVENTORY, and it is
-- the one debt no sūtra can ever discharge.
data Pravesha
  = Pravishati Nirnaya   -- प्रविशति -- it enters, carried in by THIS verdict
  | Nivartate  Nirnaya   -- निवर्तते -- it turns back, turned by THIS verdict
  deriving (Eq)

instance Show Pravesha where
  show (Pravishati v) = "enters on " ++ show v
  show (Nivartate  v) = "turns back on " ++ show v

pravesha :: Nirnaya -> Pravesha
pravesha v@(Aviruddha _)  = Pravishati v
pravesha v@(Tusnim _)     = Pravishati v
pravesha v@(Khandita _)   = Nivartate v
pravesha v@(Nirdharmin _) = Nivartate v

-- DELIBERATELY ABSENT, as in Obstruction.hs: `entered :: Pravesha -> Bool`.
-- One line of that shape restores the bare label for every caller at once and
-- reads as a convenience while doing it.  Callers match, and in matching they
-- hold the reason.

------------------------------------------------------------------------
-- COLLECTION
------------------------------------------------------------------------

-- सेतवः -- the boundaries of a configuration, each with its ORDINAL and its
-- index.  A boundary has to be identified across configurations, because the
-- question is "did anything ever reach for THIS juncture" and the index moves
-- under every rewrite.
--
-- THE LIMIT OF THE IDENTIFICATION, said rather than hidden: boundaries are
-- matched by ordinal from the left.  Rewrites consume boundaries (6.1.101
-- takes the Pada with the two vowels) and never create them, so where a
-- boundary to the LEFT of this one is consumed mid-run the ordinal shifts and
-- the match is wrong.  Every input in `sesaKosha` carries at most one
-- boundary, where the identification is exact.  With more, this
-- under-reports what reached for a juncture, which emits residuals that are
-- not owed -- so it is the direction that must be fixed before the queue is
-- trusted on multi-pada input.
setavah :: [Item] -> [(Int, Int)]
setavah xs = zip [0 ..] [ i | (i, x) <- zip [0 ..] xs
                            , x `elem` [Pada, Morph, Avasana, Pratyaya] ]

-- the sound before an index, skipping boundaries
prevPh :: [Item] -> Int -> Maybe String
prevPh xs i = listToMaybe [ s | j <- [i-1, i-2 .. 0], P s <- [xs !! j] ]

sandhiAt :: [Item] -> Int -> Sandhi
sandhiAt xs i = ( prevPh xs i
                , xs !! i
                , listToMaybe [ s | j <- [i+1 .. length xs - 1], P s <- [xs !! j] ] )

-- Did this offer REACH FOR this boundary?  A rewrite spanning [i, i+n) counts
-- as reaching boundary b when b lies in [i-1, i+n]: the boundary itself may be
-- consumed (6.1.101), or the rule may rewrite the sound immediately before it
-- (8.2.39 at pada-end) or immediately after it (8.4.40's second branch).  The
-- window is deliberately LOOSE.  Erring wide marks more junctures as reached
-- and so emits FEWER residuals, which is the conservative direction: this file
-- must not manufacture a debt.
sprsati :: Int -> (Ref, Int, Int) -> Bool
sprsati b (_, i, n) = b >= i - 1 && b <= i + n

-- शेषाः -- every residual one derivation produces.  The parent is the input
-- string, so every debt below names what demanded it.
sesah :: String -> [Sesa]
sesah src = alien ++ undecided ++ unfinished ++ gaps
  where
    xs0 = parseInput src
    (_, final, lg) = deriveLekha xs0
    at cfg i h drsta spardhi = Sesa h (sandhiAt cfg i) i cfg spardhi drsta src

    alien = [ at xs0 i (Anaksaram t) [] []
            | (i, P t) <- zip [0 ..] xs0, phoneOf t == Nothing ]

    undecided = [ at cfg i (Anirnitam rs) [] rs | (cfg, i, rs) <- lAnirnita lg ]

    unfinished = [ Sesa (Asamaptam k) (Nothing, Pada, Nothing) 0 final []
                        (nub [ r | (_, os) <- lVrtta lg, (r, _, _) <- os ]) src
                 | Just k <- [lAsamapta lg] ]

    gaps = [ at final b Asutram (reachedFor o) [] | (o, b) <- setavah final ]

    reachedFor o = nub [ r | (cfg, offers) <- lVrtta lg
                           , Just b <- [lookup o (setavah cfg)]
                           , (r, i, n) <- offers, sprsati b (r, i, n) ]

------------------------------------------------------------------------
-- THE QUEUE
------------------------------------------------------------------------

-- What entered, ranked by HOW MANY DISTINCT PARENTS demand it -- the ranking
-- `Obstruction.curriculum` uses, for the same reason.  A raw occurrence count
-- over-weights one input retried across rounds; what a queue is actually
-- being asked is which single missing rule unblocks the most derivations.
--
-- Refuted and degenerate residuals are dropped BEFORE the queue rather than
-- filtered where they are used.  A queue carrying objects nobody may act on
-- is a queue that will be acted on.
sesaPrasna :: [String] -> [(Sesa, Int)]
sesaPrasna = sesaPrasnaNava []

-- पुनरावृत्तिनिवारणम् -- requeue suppression, load-bearing rather than tidy.
--
-- THE LIVELOCK IS REAL AND WAS HIT HERE.  The obvious way to act on a queue
-- is to re-run the derivations that stalled and see which debts are now
-- discharged.  Re-running a parent whose debt is still open re-emits the
-- identical residual -- same juncture, same key -- and it goes back on the
-- queue, forever, at no point doing anything wrong.  `held` is what stops it:
-- a key already queued is never queued again.
--
-- THIS IS NOT THE KUTTAKA'S TERMINATION and must not be reported as it.
-- Āryabhaṭa's remainders strictly decrease and that is why the vallī ends.
-- These do not decrease at all; a residual can be a larger object than the
-- configuration that produced it.  What holds here is only finiteness -- the
-- juncture alphabet is finite -- plus this suppression.
sesaPrasnaNava :: [SesaKey] -> [String] -> [(Sesa, Int)]
sesaPrasnaNava held corpus =
    sortOn (\(s, n) -> (negate n, showSandhi (sSandhi s)))
      [ (g, length (nub (map sJanaka grp)))
      | k <- nub (map sesaKey entered), k `notElem` held
      , let grp = [ s | s <- entered, sesaKey s == k ]
      , g <- take 1 grp ]
  where
    entered = [ s | s <- concatMap sesah corpus
                  , Pravishati _ <- [pravesha (nirnaya s)] ]

-- अभ्यासः -- the loop that livelocks without `held`.  Each round re-asks the
-- parents that stalled; a round that adds no new key ends it.  Returns one
-- list per round.
abhyasa :: Int -> [String] -> [[(Sesa, Int)]]
abhyasa n corpus = go n [] corpus
  where
    go 0 _ _ = []
    go k held cs =
      case sesaPrasnaNava held cs of
        [] -> []
        q  -> q : go (k - 1) (held ++ map (sesaKey . fst) q)
                    (nub (map (sJanaka . fst) q))

-- WHAT THE MACHINE ASKS FOR, printed -- not a summary of the queue, the queue
-- in its own words.
sesaLekha :: [String] -> [String]
sesaLekha corpus =
  [ "the machine asks for " ++ show (length q) ++ " thing"
      ++ (if length q == 1 then "" else "s") ++ ", best first:" ]
  ++ [ "  demanded by " ++ show n ++ " derivation"
       ++ (if n == 1 then "" else "s") ++ ": " ++ sesaPrccha s
       ++ "   [from " ++ sJanaka s ++ "]"
     | (s, n) <- q ]
  where q = sesaPrasna corpus

-- कोशः -- the corpus the queue is measured over: every derivation this file
-- already tests, and nothing invented to make the queue look busy.  The four
-- additions at the end are the probes that exhibit each verdict, and each is
-- ordinary Sanskrit or, in one case, deliberately not Sanskrit at all.
sesaKosha :: [String]
sesaKosha =
  [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana", "ne + ana", "rāmas", "tat + ca"
  , "tat + jalam", "vāc"
  , "tam + ca"        -- m is neither jhaL nor cU nor s: nothing reaches for it
  , "kim + ca"        -- the same juncture from a different parent
  , "rāmas + ca"      -- the juncture survives, but 8.2.66 and 8.3.15 reached for it
  , "tat + fala"      -- f is not a sound of the varṇasamāmnāya
  ]

------------------------------------------------------------------------
-- 8.  HONESTY
------------------------------------------------------------------------

-- The Phonology has about 3983 sutras (recensions differ: 3959-3996).  This
-- reports what is actually here, split by whether the sutra performs a
-- substitution or supplies the meaning of one.  It does not round up.
coverage :: [String]
coverage =
  [ "sūtras encoded here:            " ++ show (length sutras)
  , "  of which vidhi (operational): " ++ show (length [ () | s <- sutras, styp s == Vidhi ])
  , "  saṃjñā / paribhāṣā / adhikāra: "
      ++ show (length [ () | s <- sutras, styp s `elem` [Samjna, Paribhasa, Adhikara, Niyama] ])
  , "sūtras in the Aṣṭādhyāyī:       ~3983 (recensions differ: 3959-3996)"
  , "fraction:                       "
      ++ show (length sutras) ++ " / 3983"
  , ""
  , "COMPLETE here: the śivasūtra table (all 14), the pratyāhāra extractor,"
  , "  savarṇa (1.1.9 + 1.1.10 + 1.1.69), and all five metarule mechanisms"
  , "  (1.4.2 paratva, utsarga/apavāda, adhikāra scope, 8.2.1 asiddhatva,"
  , "  and anuvṛtti with explicit nivṛtti -- section 3a)."
  , ""
  , "ANUVṚTTI: " ++ show (length anuvrttiTable) ++ " continuations encoded, "
      ++ show (sum [ length (contextAt (num s)) | s <- sutras ])
      ++ " inheritance edges over " ++ show (length sutras) ++ " sūtras."
  , "  The Aṣṭādhyāyī's own anuvṛtti graph runs to thousands of edges and no"
  , "  source carrying it is reachable from this container.  What is here is"
  , "  four continuations that can be checked against the shape of the rules"
  , "  that inherit them, and the laghava figure below is a figure for THIS"
  , "  sample -- a floor for the text, not an estimate of it."
  , ""
  , "स्थानिवद्भावः, section 6c: 1.1.56 is a CHANNEL and not an annotation."
  , "  Every substitution records what it stands in place of; every sūtra is"
  , "  handed the reading 1.1.56 gives IT -- the form if it is an al-vidhi,"
  , "  the sthānin if it is not -- and `alVidhiTable` declares which, with"
  , "  the reason, one entry per sūtra, checked total by `selfTest`.  Three"
  , "  entries are marked DISPUTED (6.1.109, 7.1.1, 8.2.30: an operation whose"
  , "  locus is a saṃjñā and whose substituend is a sound) rather than decided."
  , "  EXERCISED: the exception clause.  Three corpus words have a rule"
  , "  reading past a substitution (`barrierAudit`), and striking the clause"
  , "  changes four derived forms.  NOT EXERCISED: the inheritance half."
  , "  The designation-reading rules here (1.1.5, 1.3.9, 7.1.1) never fire at"
  , "  a site holding an ādeśa, so `deriveRupamEverywhere` -- which strikes"
  , "  `sthānivat` -- gives the same word on the whole corpus.  Said here"
  , "  because a mechanism whose second half is declared and never run is a"
  , "  shelf, and the report of it is worth more than a manufactured case."
  , ""
  , "लोपः, 1.1.60 with 1.3.3, 1.3.8, 1.3.9 and 1.1.5: an elided it is absent"
  , "  from the surface and present to the conditions.  `Lupta` is that in the"
  , "  type.  `ci ~ kta` derives cita because 1.1.5 reads the k that 1.3.9"
  , "  erased; make lopa a deletion (`deriveWithoutLopa`) and the same sūtras"
  , "  give ceta.  Nothing of 1.3.2, 1.3.4-1.3.7 is encoded, and no"
  , "  sārvadhātuka/ārdhadhātuka classification: every `~` affix is treated as"
  , "  ārdhadhātuka, which is what lyuṬ and kta are and is not a general rule."
  , ""
  , "A SAMPLE here: the vidhi rules -- 6.1 vowel sandhi and the tripādī --"
  , "  chosen to be enough to run derivations end to end and to make each"
  , "  mechanism do visible work.  Nothing of morphology, nothing of the"
  , "  dhātupāṭha."
  , ""
  , "THE KĀRAKA LAYER now has its entry point: 2.3.1 anabhihite as a GATE,"
  , "  with 2.3.2 karmaṇi dvitīyā and 2.3.18 kartṛkaraṇayos tṛtīyā under it."
  , "  That is three sūtras of ~3983 and it is not morphology -- no affix is"
  , "  selected, no stem is built.  What it does carry is the ARCHITECTURE:"
  , "  a scene of semantic roles is the input, and the case each role"
  , "  receives depends on what the verbal ending already expressed."
  , "  Checked: the same scene under two voices has the same kārakas and"
  , "  different vibhaktis, so the two layers provably do not collapse."
  , "  The sūtra locus for the nominative on an abhihita kāraka is NOT"
  , "  confirmed by sources reachable here and is left unclaimed."
  , ""
  , "शेषः, section 7b: the engine's stalls are kept rather than swallowed."
  , "  A derivation that cannot proceed emits the configuration, the position,"
  , "  the contending sūtras and the parent that demanded it, and `sesaPrasna`"
  , "  ranks the debts by how many distinct derivations each would unblock."
  , "  Run it: `sesaLekha sesaKosha`.  What the machine currently asks for is"
  , "  a sūtra at m + c -- which the Aṣṭādhyāyī has (8.3.23 `mo 'nusvāraḥ`)"
  , "  and this file does not.  The machine derived the gap; the number is"
  , "  supplied here by a reader and is not part of the residual."
  ]


------------------------------------------------------------------------
-- 8a.  LAGHAVAM -- what the anuvrtti costs, in symbols.
--
--   ardhamatralaghavena putrotsavam manyante vaiyakaranah
--   "grammarians hold the saving of half a mora to be the birth of a son"
--   (the vaiyakarana proverb, transmitted in the commentarial literature;
--   the sentiment is Patanjali's Mahabhasya, ~150 BCE, on the economy of
--   the sutrapatha.)
--
-- WITH INHERITANCE EXPLICIT THE SAVING IS COMPUTABLE, and this section
-- computes it rather than admiring it.  Two presentations of the SAME
-- grammar:
--
--   TRANSMITTED   each sutra as the text has it.  A continued word is
--                 written once, in the sutra that states it.
--   EXPANDED      every sutra self-contained: each inherited word written
--                 out again in every sutra that inherits it.  This is what
--                 this file's own sutra table looked like before section
--                 3a: the pada-final condition duplicated into four
--                 closures, the vowel condition into five.
--
-- THE THEOREM, WRITTEN BEFORE THE COMPUTATION, per the protocol in
-- CLAUDE.md.  There is nothing to measure here: for a word w of cost c(w)
-- in force over n(w) sutras (the one that states it, plus the n(w)-1 that
-- inherit it), the transmitted presentation writes it once and the
-- expanded one writes it n(w) times, so
--
--     expanded - transmitted  =  SUM over w of  (n(w) - 1) * c(w)
--
-- exactly, in any additive symbol-measure whatsoever, with no
-- cross-terms, because expansion adds text and changes nothing else.  The
-- saving is LINEAR IN CHAIN LENGTH and the constant is the word.  That is
-- the whole content of the device, and it is why the real Phonology --
-- where a heading can govern several hundred sutras -- gets a factor and
-- not a discount.  `laghavaIdentity` in `selfTest` checks the identity
-- holds of the tables here rather than trusting the derivation of it.
--
-- TWO UNITS, both exact integers, no floating point anywhere:
--
--   VARNA         one symbol = one phoneme.  Spaces are orthography and
--                 are not counted; the tradition counts sound.
--   ARDHAMATRA    half-morae, which is the unit the proverb is in:
--                 a consonant is half a matra, a hrasva (short) vowel one,
--                 a dirgha (long) vowel two.  Counted in halves so the
--                 arithmetic stays in the integers.
--
-- WHAT THIS FIGURE IS AND IS NOT.  It is the figure for the 26 sutras and
-- 4 continuations encoded in this file, and it is stated as such by
-- `laghavaReport`, which prints the sample size beside every number.  It
-- is NOT an estimate for the Phonology: the real anuvrtti graph is not
-- reachable from this container (same egress limit recorded at 6.4.22),
-- and a figure extrapolated from four continuations to several thousand
-- would be exactly the fitted constant this repository's protocol exists
-- to prevent.  What generalises is the identity above, which is proved,
-- not the number, which is a sample.
--
-- AND IT DOES NOT PICK THE PRESENTATION.  See section 8b, which also
-- carries the prior art: NaturalMachine/AnuvrttiIsTheSameTrade.agda
-- already proves the word-count case of the identity above and already
-- proves that the content does not factor through the text.  What is new
-- here is chains, the word's own cost, Panini's unit, and a running
-- instance in Sanskrit.
------------------------------------------------------------------------

-- longest-match over the phoneme inventory, plus the marks that occur in
-- sutra text; spaces, avagraha and hyphens are not sounds and are dropped.
varnasOf :: String -> [String]
varnasOf [] = []
varnasOf s@(c : rest)
  | c `elem` (" '-" :: String) = varnasOf rest
  | otherwise =
      case [ n | n <- longestFirst, n `isPrefixOf` s ] of
        (n : _) -> n : varnasOf (drop (length n) s)
        []      -> [c] : varnasOf rest
  where
    longestFirst = sortOn (negate . length) (map phName phones ++ ["ṃ"])

varnaCount :: String -> Int
varnaCount = length . varnasOf

-- half-morae.  hrasva 2, dirgha 4, consonant/anusvara/visarga 1.
ardhamatras :: String -> Int
ardhamatras = sum . map w . varnasOf
  where
    w v | v `elem` ["a","i","u","ṛ","ḷ"]                        = 2
        | v `elem` ["ā","ī","ū","ṝ","e","o","ai","au"]          = 4
        | otherwise                                             = 1

data Laghava = Laghava
  { lgSutras       :: Int
  , lgEdges        :: Int   -- (sutra, inherited word) pairs: the chain length,
                            -- summed over words, minus one per word
  , lgTransVarna   :: Int
  , lgTransArdha   :: Int
  , lgExpVarna     :: Int
  , lgExpArdha     :: Int
  } deriving (Eq, Show)

laghava :: Laghava
laghava = Laghava
  { lgSutras     = length sutras
  , lgEdges      = sum [ length (contextAt (num s)) | s <- sutras ]
  , lgTransVarna = sum [ varnaCount (text s) | s <- sutras ]
  , lgTransArdha = sum [ ardhamatras (text s) | s <- sutras ]
  , lgExpVarna   = sum [ varnaCount (fullReading (num s)) | s <- sutras ]
  , lgExpArdha   = sum [ ardhamatras (fullReading (num s)) | s <- sutras ]
  }

-- the right-hand side of the identity: SUM over w of (n(w) - 1) * c(w)
laghavaByWord :: (String -> Int) -> [(String, Int, Int)]   -- word, inheritors, cost
laghavaByWord cost =
  [ (w, length [ () | s <- sutras, w `elem` map avWord (contextAt (num s)) ], cost w)
  | (_, w, _, _) <- anuvrttiTable ]

laghavaReport :: [String]
laghavaReport =
  [ "SAMPLE: " ++ show (lgSutras laghava) ++ " sūtras encoded, "
      ++ show (length anuvrttiTable) ++ " continuations, "
      ++ show (lgEdges laghava) ++ " inheritance edges."
  , "  (a figure for this file, not for the Aṣṭādhyāyī -- see the header.)"
  , ""
  , "                                   varṇa    ardhamātrā"
  , "  transmitted (anuvṛtti used)      " ++ pad 9 (show (lgTransVarna laghava))
                                          ++ show (lgTransArdha laghava)
  , "  expanded (every sūtra alone)     " ++ pad 9 (show (lgExpVarna laghava))
                                          ++ show (lgExpArdha laghava)
  , "  saved by anuvṛtti + adhikāra     " ++ pad 9 (show savedV)
                                          ++ show savedA
  , "  saved, as a fraction             " ++ pad 9 (show savedV ++ "/" ++ show (lgExpVarna laghava))
                                          ++ show savedA ++ "/" ++ show (lgExpArdha laghava)
  , "  i.e. the expanded presentation is " ++ show (lgExpArdha laghava)
      ++ "/" ++ show (lgTransArdha laghava) ++ " of the transmitted one in ardhamātrās"
  , ""
  , "  per word, (n-1) x cost, which is the identity that is PROVED:"
  ]
  ++ [ "    " ++ pad 20 w ++ "in force over " ++ show (n + 1) ++ " sūtras, "
         ++ show c ++ " ardhamātrās, saves " ++ show (n * c)
     | (w, n, c) <- laghavaByWord ardhamatras ]
  ++ [ "    " ++ pad 20 "TOTAL" ++ "saves " ++ show (sum [ n * c | (_, n, c) <- laghavaByWord ardhamatras ]) ++ " ardhamātrās, which is exactly the difference above"
     , ""
     , "  half a mora is the unit in the proverb; this saves "
         ++ show savedA ++ " of them."
     ]
  where
    savedV = lgExpVarna laghava - lgTransVarna laghava
    savedA = lgExpArdha laghava - lgTransArdha laghava
    pad n s = s ++ replicate (max 0 (n - length s)) ' '

------------------------------------------------------------------------
-- 8b.  AND LAGHAVA STILL DOES NOT PICK THE PRESENTATION.
--
-- PRIOR ART IN THIS REPOSITORY, searched before this section was written
-- rather than after, and it is closer than expected:
--
--   NaturalMachine/LaghavaUnderdeterminesSoTheMetarulesAreNotOptional.agda
--     brevity attains its minimum NON-UNIQUELY -- `plus var (lit 1)` and
--     `plus (lit 1) var`, equal size, EQUAL denotation.  So the measure
--     picks a level set and something else must choose inside it, which
--     is why the paribhasas are structurally required.
--   NaturalMachine/AnuvrttiIsTheSameTrade.agda
--     §2 prices the device -- three sutras under one governing word cost
--     4 words with anuvrtti and 6 without, "one word per sutra beyond
--     the first".  §3 proves the other half: `anuvrtti-does-not-factor`,
--     the operative content of a sutra does NOT factor through its own
--     text, because two sutras with identical text under different
--     adhikara have the same reading and different content.
--   NaturalMachine/Anuvrtti.agda
--     laghava is not a function of the SET of rules; the order carries
--     information no set carries.
--
-- So the theorem is already proved, twice, and this file does not
-- restate it.  What is added here is exactly what
-- `AnuvrttiIsTheSameTrade` names in its own NOT CLAIMED paragraph --
-- "the real anuvrtti chains run many words deep with their own
-- nivrtti", and "the saving in §2 is not the Phonology's actual
-- economy":
--
--   * CHAINS, not one edge.  Four words, in force over 8, 6, 5 and 6
--     sutras, overlapping, with a nivrtti that stops one of them.
--   * THE WORD'S OWN COST.  §2 counts words, so its saving is
--     (n-1) x 1.  Section 8a counts the word, so the saving is
--     (n-1) x c(w) and the constants differ by a factor of six here:
--     `aci` is 5 ardhamatras and `ekah purvaparayoh` is 29.
--   * PANINI'S UNIT.  ardhamatra, which is the unit the proverb is in.
--   * A RUNNING INSTANCE of `anuvrtti-does-not-factor`: the Agda
--     exhibits two sites with the same reading and different content;
--     `selfTest` here exhibits two cancellation schedules over the SAME
--     26 sutra texts that derive DIFFERENT SANSKRIT -- tacca against
--     dad ga, deva indra against devendra.
--
-- And the sharpening the running instance forces, which follows from
-- the two Agda results and is not either of them: a NIVRTTI COSTS
-- NOTHING.  The cancellation of a running word is written nowhere in
-- the sutrapatha; it is inferred.  `laghava` therefore has no argument
-- in which to receive the schedule -- it is a function of `map text
-- sutras` alone, checked -- while the schedule decides the grammar.  A
-- minimum-description-length criterion with an uncounted channel is not
-- a criterion.  The tradition's response is not to pretend the channel
-- is absent but to name it and transmit it: the anuvrtti is carried by
-- the commentary, sutra by sutra, and that is what the commentary is
-- FOR.
------------------------------------------------------------------------

-- Every claim this file makes, checked exhaustively.  Returns [] on success.
selfTest :: [String]
selfTest = concat
  [ pratyaharaTests
  , inventoryTests
  , savarnaTests
  , adhikaraTest
  , conflictTests
  , derivationTests
  , asiddhaTests
  , regimeTests
  , karakaTests
  , sutraTableTests
  , anuvrttiTests
  , inheritanceIsLoadBearingTests
  , sesaTests
  , laghavaTests
  , sthanivatTests
  ]
  where
    chk name got want
      | got == want = []
      | otherwise   = [ name ++ ": got " ++ show got ++ ", wanted " ++ show want ]

    -- 8.1  the pratyaharas, each against its traditional value
    pratyaharaTests = concat
      [ chk "aṆ (vowels a i u)"        (pratyahara "a" "ṇ")   ["a","i","u"]
      , chk "aK"                       (pratyahara "a" "k")   ["a","i","u","ṛ","ḷ"]
      , chk "iK"                       (pratyahara "i" "k")   ["i","u","ṛ","ḷ"]
      , chk "eṄ"                       (pratyahara "e" "ṅ")   ["e","o"]
      , chk "aC (all vowels)"          (pratyahara "a" "c")
          ["a","i","u","ṛ","ḷ","e","o","ai","au"]
      , chk "eC"                       (pratyahara "e" "c")   ["e","o","ai","au"]
      , chk "aṬ"                       (pratyahara "a" "ṭ")
          ["a","i","u","ṛ","ḷ","e","o","ai","au","h","y","v","r"]
      , chk "yaṆ (semivowels)"         (pratyahara "y" "ṇ")   ["y","v","r","l"]
      , chk "ñaM (nasals)"             (pratyahara "ñ" "m")   ["ñ","m","ṅ","ṇ","n"]
      , chk "yaM"                      (pratyahara "y" "m")
          ["y","v","r","l","ñ","m","ṅ","ṇ","n"]
      , chk "jhaṢ (voiced aspirates)"  (pratyahara "jh" "ṣ")  ["jh","bh","gh","ḍh","dh"]
      , chk "jhaŚ (voiced stops)"      (pratyahara "jh" "ś")
          ["jh","bh","gh","ḍh","dh","j","b","g","ḍ","d"]
      , chk "jaŚ (voiced unaspirated)" (pratyahara "j" "ś")   ["j","b","g","ḍ","d"]
      , chk "baŚ"                      (pratyahara "b" "ś")   ["b","g","ḍ","d"]
      , chk "khaY (voiceless stops)"   (pratyahara "kh" "y")
          ["kh","ph","ch","ṭh","th","c","ṭ","t","k","p"]
      , chk "śaR (sibilants)"          (pratyahara "ś" "r")   ["ś","ṣ","s"]
      , chk "caR"                      (pratyahara "c" "r")
          ["c","ṭ","t","k","p","ś","ṣ","s"]
      , chk "śaL"                      (pratyahara "ś" "l")   ["ś","ṣ","s","h"]
      -- cardinalities of the big ones (the traditional counts)
      , chk "|jhaY| = 20 (all stops)"  (length (pratyahara "jh" "y")) 20
      , chk "|jhaL| = 24"              (length (pratyahara "jh" "l")) 24
      , chk "|yaR| = 32"               (length (pratyahara "y" "r"))  32
      , chk "|maY| = 24"               (length (pratyahara "m" "y"))  24
      , chk "|haL| = 34 slots"         (length (pratyahara "h" "l"))  34
      , chk "|haL| = 33 sounds"        (length (pratyaharaSet "h" "l")) 33
      , chk "|aL| = 43 slots"          (length (pratyahara "a" "l"))  43
      , chk "|aL| = 42 sounds"         (length (pratyaharaSet "a" "l")) 42
      -- the two escape hatches, made explicit
      , chk "h occurs twice"
          (length [ () | Snd "h" <- varnasamamnaya ]) 2
      -- The anubandha is a boundary, never a member.  Stated as: the extractor
      -- returns exactly the SOUND slots of the raw span, and the spans in
      -- question really do straddle markers -- so the skipping is doing work.
      -- (It cannot be stated as "the marker letter is absent from the class":
      -- every marker letter -- ṇ k ṅ c ṭ m ñ ṣ ś v y r l -- is also a genuine
      -- phoneme of Sanskrit, and those phonemes DO belong to classes.  That
      -- collision is the whole reason anubandhas are deleted by 1.3.9
      -- `tasya lopaḥ` rather than distinguished by shape.)
      , chk "extractor returns exactly the sound slots of the span"
          [ (s, mk) | (_, ss, mk) <- sivasutraTable, s <- ss
                    , pratyahara s mk /= [ x | Snd x <- rawSpan s mk ] ] []
      , chk "aC straddles 3 markers, none of them collected"
          (length [ () | It _ <- rawSpan "a" "c" ]) 3
      , chk "haL straddles 9 markers, none of them collected"
          (length [ () | It _ <- rawSpan "h" "l" ]) 9
      -- the only duplicated marker, and why the convention still works
      , chk "ṇ is the only repeated marker"
          (sortOn id [ m | (_, _, m) <- sivasutraTable
                         , length [ () | (_,_,m') <- sivasutraTable, m' == m ] > 1 ])
          ["ṇ","ṇ"]
      ]

    -- 8.2  the inventory
    inventoryTests = concat
      [ chk "14 śivasūtras" (length sivasutraTable) 14
      , chk "42 distinct sounds in the sequence"
          (length (nub [ s | Snd s <- varnasamamnaya ])) 42
      , chk "every śivasūtra sound is a known phone"
          [ s | Snd s <- varnasamamnaya, phoneOf s == Nothing ] []
      ]

    -- 8.3  savarna, 1.1.9 and 1.1.10
    savarnaTests = concat
      [ chk "a and ā are savarṇa"        (savarna "a" "ā")   True
      , chk "i and ī are savarṇa"        (savarna "i" "ī")   True
      , chk "a and i are not"            (savarna "a" "i")   False
      , chk "k and kh are savarṇa"       (savarna "k" "kh")  True
      , chk "k and ṅ are savarṇa"        (savarna "k" "ṅ")   True
      , chk "k and c are not"            (savarna "k" "c")   False
      , chk "1.1.10: a and h are not"    (savarna "a" "h")   False
      , chk "e and ai are not savarṇa"   (savarna "e" "ai")  False
      , chk "1.1.69: aC reaches ā"       ("ā" `elem` aC)     True
      , chk "1.1.69: iK reaches ī, ū, ṝ"
          (all (`elem` iK) ["ī","ū","ṝ"]) True
      , chk "1.1.69: aC does not reach consonants"
          (any (`elem` aC) ["k","y","s"]) False
      ]

    -- 8.4  the adhikara 6.1.84, checked on the rewrites themselves
    adhikaraTest =
      let single r = length [ () | P _ <- rNew r ] - rRapara r == 1
          probe = parseInput "deva + indra"
          probes = [ parseInput "deva + indra", parseInput "dadhi + indra"
                   , parseInput "su + ukta",    parseInput "ne + ana"
                   , parseInput "te + api",     parseInput "mahā + ṛṣi"
                   , parseInput "deva + aiśvarya" ]
          rws = [ r | xs <- probes, s <- sectionA, r <- fires s (readingUnder [] s) xs ]
          inScope  = [ r | r <- rws, "ekaḥ pūrvaparayoḥ" `elem` governedBy (rSutra r) ]
          outScope = [ r | r <- rws, not ("ekaḥ pūrvaparayoḥ" `elem` governedBy (rSutra r))
                         , styp (sutraAt (rSutra r)) == Vidhi ]
      in concat
         [ chk "6.1.84 governs 6.1.87/88/101/109"
             (map (\r -> "ekaḥ pūrvaparayoḥ" `elem` governedBy r)
                  [(6,1,87),(6,1,88),(6,1,101),(6,1,109)])
             [True,True,True,True]
         , chk "6.1.84 does NOT govern 6.1.77/78"
             (map (\r -> "ekaḥ pūrvaparayoḥ" `elem` governedBy r) [(6,1,77),(6,1,78)])
             [False,False]
         , chk "every rewrite under 6.1.84 is a single substitute"
             (all single inScope) True
         , chk "6.1.78 (outside the heading) makes one sound into two"
             (any (\r -> rSutra r == (6,1,78)
                      && length [ () | P _ <- rNew r ] == 2) rws) True
         , chk "6.1.72 saṃhitāyām governs all of 6.1.77-109"
             (all (\r -> "saṃhitāyām" `elem` governedBy r)
                  [(6,1,77),(6,1,78),(6,1,87),(6,1,88),(6,1,101),(6,1,109)]) True
         , if null probe then ["parse failure"] else []
         ]

    -- 8.5  1.4.2 doing real work: conflicts the corpus actually produces
    conflictTests =
      let steps xs = fst (deriveTrace (parseInput xs))
          beatenBy input winner loser =
            chk ("1.4.2 on " ++ input)
              (any (\st -> stSutra st == winner && loser `elem` stBeaten st) (steps input))
              True
      in concat
         [ beatenBy "dadhi + indra" (6,1,101) (6,1,77)
         , beatenBy "su + ukta"     (6,1,101) (6,1,77)
         , beatenBy "te + api"      (6,1,109) (6,1,78)
         , chk "no conflict where only one rule fires"
             (all (null . stBeaten) (steps "deva + indra")) True
         ]

    -- 8.6  the derivations themselves
    derivationTests = concat
      [ chk "dadhi + indra"    (derive "dadhi + indra")    "dadhīndra"
      , chk "deva + indra"     (derive "deva + indra")     "devendra"
      , chk "mahā + indra"     (derive "mahā + indra")     "mahendra"
      , chk "su + ukta"        (derive "su + ukta")        "sūkta"
      , chk "deva + ṛṣi"       (derive "deva + ṛṣi")       "devarṣi"
      , chk "mahā + ṛṣi"       (derive "mahā + ṛṣi")       "maharṣi"
      , chk "madhu + ari"      (derive "madhu + ari")      "madhvari"
      , chk "deva + aiśvarya"  (derive "deva + aiśvarya")  "devaiśvarya"
      , chk "te + api"         (derive "te + api")         "te'pi"
      -- same two vowels, different juncture, different sūtra, different word:
      -- 6.1.109 needs padāntāt and does not get it inside a pada.
      , chk "ne - ana"         (derive "ne - ana")         "nayana"
      , chk "ne + ana"         (derive "ne + ana")         "ne'na"
      , chk "rāmas (in pause)" (derive "rāmas")            "rāmaḥ"
      , chk "tat + ca"         (derive "tat + ca")         "tacca"
      , chk "tat + jalam"      (derive "tat + jalam")      "tajjalam"
      , chk "vāc (in pause)"   (derive "vāc")              "vāk"
      ]

    -- 8.6a  THE TWO REGIMES ARE NOT THE SAME DEVICE -- and the difference
    -- is ONE PASS against a fixpoint, which is narrower than it first
    -- looked.  [NARROWED 2026-08-19, after checking the obvious next claim
    -- in formal/cubical/AsiddhavatRegime.agda and finding it false:
    -- ITERATE the simultaneous pass and it converges, to exactly the form
    -- the ordered regime gives in one traversal.  So simultaneity is not
    -- incapable of the answer; what the ordering buys is the answer IN ONE
    -- PASS, and the tripadi is traversed once.  A claim that the
    -- simultaneous device "cannot get there" would have been false.]
    -- The ordered one
    -- is what produces attested Sanskrit.  Run the tripadi under 6.4.22's
    -- simultaneous regime instead of 8.2.1's ordered one and `tat + jalam`
    -- comes out `tadjalam`, which Sanskrit does not have; the ordered
    -- regime gives the attested `tajjalam`.  Same rules, same 1.4.2, and
    -- the choice of regime decides the form -- so purvatrasiddham is
    -- load-bearing rather than presentational, and it is the ORDERED one.
    --
    -- The mechanism, from the offers against the unmodified form: 8.2.39
    -- (t to d at pada-end), 8.4.40 (t to c before j) and 8.4.53 (t to d
    -- before jhaS' j) ALL fire at the same position, because none of them
    -- sees the others.  1.4.2 takes the latest, 8.4.53, and stops.
    -- Ordered, 8.2.39 runs first and 8.4.40 then acts on ITS output.
    regimeTests = concat
      [ chk "ordered gives the attested tajjalam"
          (derive "tat + jalam") "tajjalam"
      , chk "simultaneous gives tadjalam instead"
          (deriveAsiddhavat "tat + jalam") "tadjalam"
      , chk "so the regimes differ"
          (derive "tat + jalam" == deriveAsiddhavat "tat + jalam") False
      , chk "and agree where only one rule ever fires"
          (derive "tat + ca" == deriveAsiddhavat "tat + ca") True
      ]

    -- 8.9  THE KARAKA LAYER: 2.3.1 anabhihite withdrawing a rule.
    --
    -- The load-bearing check is the LAST one.  The roles are identical
    -- under both voices and the cases are not: the karaka layer and the
    -- vibhakti layer come apart, which is the whole reason Panini has two
    -- of them.  If they could be collapsed this test would fail.
    karakaTests = concat
      [ chk "active: the ending expresses the kartr"
          (abhihita Kartari) Kartr
      , chk "passive: the ending expresses the karman"
          (abhihita Karmani) Karman
      -- active: devadattah odanam pacati
      , chk "active kartr takes prathama (abhihita, 2.3.1 withdraws)"
          (fst (vibhaktiOf Kartari Kartr)) Prathama
      , chk "active karman takes dvitiya (2.3.2)"
          (fst (vibhaktiOf Kartari Karman)) Dvitiya
      -- passive: devadattena odanah pacyate
      , chk "passive karman takes prathama (abhihita)"
          (fst (vibhaktiOf Karmani Karman)) Prathama
      , chk "passive kartr takes trtiya (2.3.18)"
          (fst (vibhaktiOf Karmani Kartr)) Trtiya
      -- karana is never expressed by the ending in either voice
      , chk "karana takes trtiya under both voices"
          (map (\v -> fst (vibhaktiOf v Karana)) [Kartari, Karmani])
          [Trtiya, Trtiya]
      -- THE POINT
      , chk "same scene, same karakas under both voices"
          (map (\(_, k, _, _) -> k) (assign Kartari pacatiScene)
             == map (\(_, k, _, _) -> k) (assign Karmani pacatiScene)) True
      , chk "same scene, DIFFERENT vibhaktis under the two voices"
          (map (\(_, _, vb, _) -> vb) (assign Kartari pacatiScene)
             == map (\(_, _, vb, _) -> vb) (assign Karmani pacatiScene)) False
      , chk "and the cases are exactly the attested ones"
          (map (\(w, _, vb, _) -> (w, vb)) (assign Kartari pacatiScene)
          ,map (\(w, _, vb, _) -> (w, vb)) (assign Karmani pacatiScene))
          ( [("devadatta", Prathama), ("odana", Dvitiya)]
          , [("devadatta", Trtiya),  ("odana", Prathama)] )
      ]

    -- 8.7  8.2.1 is load-bearing: `vāc` derives to vāk, and 8.2.39 would turn
    -- that k straight back into g if it could see it.  Asiddhatva is what
    -- makes the grammar terminate.
    asiddhaTests = concat
      [ chk "the tripādī's output is NOT a global fixpoint"
          (null (asiddhaAudit (parseInput "vāc"))) False
      , chk "and it is 8.2.39 that is refused"
          (map fst (asiddhaAudit (parseInput "vāc"))) [(8,2,39)]
      , chk "where nothing is refused, the audit is empty"
          (asiddhaAudit (parseInput "deva + indra")) []
      ]

    -- 8.8  the table itself
    sutraTableTests = concat
      [ chk "sūtra numbers are distinct"
          (length (nub (map num sutras))) (length sutras)
      , chk "sūtra table is in text order"
          (map num sutras) (sortOn id (map num sutras))
      , chk "every apavāda names a sūtra that exists"
          [ r | s <- sutras, r <- apavadaTo s, not (any ((== r) . num) sutras) ] []
      , chk "8.2.1 is the first tripādī sūtra"
          (num (head sectionB)) (8,2,1)
      , chk "the tripādī is exactly 8.2-8.4"
          (all (\s -> let (a,p,_) = num s in a == 8 && p >= 2) sectionB) True
      ]

    -- 8.10  ANUVRTTI: a sutra is not locally readable, and the machine
    --       says what it inherits from where.
    anuvrttiTests = concat
      [ chk "6.1.101 writes 3 words and stands inside 3 more"
          (length (words (text (sutraAt (6,1,101)))), map avWord (contextAt (6,1,101)))
          (3, ["saṃhitāyām", "aci", "ekaḥ pūrvaparayoḥ"])
      , chk "8.2.30 coḥ kuḥ inherits padasya, stated 8.1.16 -- a different pāda"
          (map (\a -> (avWord a, avFrom a)) (contextAt (8,2,30)))
          [("padasya", (8,1,16))]
      , chk "8.4.40 inherits nothing: the padasya heading ends at 8.3.54"
          (contextAt (8,4,40)) []
      , chk "a word never reaches what precedes its statement"
          [ r | (src, w, _, _) <- anuvrttiTable
              , (r, _, _, _) <- anuvrttiTable
              , r <= src, w `elem` map avWord (contextAt r) ] []
      , chk "`aci` is written in exactly one sūtra and in force in six"
          ( length [ () | s <- sutras, "aci" `elem` words (text s) ]
          , length [ () | s <- sutras, "aci" `elem` map avWord (contextAt (num s)) ] )
          (1, 5)
      , chk "nivṛtti: `aci` does not reach 6.1.109, which states its own `ati`"
          ("aci" `elem` map avWord (contextAt (6,1,109))) False
      -- the point of the whole section: a rule cannot tell its own words
      -- from its inherited ones, and neither reading is privileged.
      , chk "6.1.77 has `aci` because it says it; 6.1.87 because it inherits it"
          (map (\r -> has "aci" (readingUnder [] (sutraAt r))) [(6,1,77),(6,1,87)])
          [True, True]
      , chk "and only one of the two has it written"
          (map (\r -> "aci" `elem` words (text (sutraAt r))) [(6,1,77),(6,1,87)])
          [True, False]
      , chk "every derivation step reports the context it stood inside"
          (map (map avWord . stInherited) (fst (deriveTrace (parseInput "dadhi + indra"))))
          [["saṃhitāyām", "aci", "ekaḥ pūrvaparayoḥ"]]
      ]

    -- 8.11  THE HEADINGS ARE LOAD-BEARING AT THE POINT OF APPLICATION.
    --       Cancel one and a derived form changes.  A heading that could be
    --       deleted with no effect would be an annotation, which is what
    --       the adhikara table in this file WAS until 2026-08-20.
    inheritanceIsLoadBearingTests =
      let without w = deriveUnder [((0,0,0), w)]
      in concat
         [ chk "8.1.16 padasya: without it tat + ca derives dad ga, not tacca"
             (derive "tat + ca", without "padasya" "tat + ca")
             ("tacca", "dad ga")
         , chk "6.1.72 saṃhitāyām: sandhi does not cross a pause, and without"
             (derive "deva . indra", without "saṃhitāyām" "deva . indra")
             ("deva indra", "devendra")
         , chk "6.1.77's aci: without it 6.1.77/78/87 fire before consonants"
             (derive "deva + kula", without "aci" "deva + kula")
             ("deva kula", "dyvkula")
         , chk "the attested corpus is unchanged when nothing is cancelled"
             (map derive corpusForms) (map (deriveUnder []) corpusForms)
         -- the elsewhere condition, which this file declared in 2026-08-19
         -- and never once exercised, now does work: 6.1.87 read with its
         -- inherited `aci` OVERLAPS 6.1.88, and the apavada blocks it.
         , chk "6.1.88 beats 6.1.87 by apavāda, not by position"
             [ (stSutra st, stBeaten st, stReason st)
             | st <- fst (deriveTrace (parseInput "deva + aiśvarya")) ]
             [ ((6,1,88), [(6,1,87)]
               , "apavāda blocks the utsarga (elsewhere condition)") ]
         ]

    corpusForms :: [String]
    corpusForms =
      [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
      , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
      , "te + api", "ne - ana", "rāmas", "tat + ca", "tat + jalam", "vāc" ]

    -- 8.12  LAGHAVAM.  The identity is derived in section 8a; this checks
    --       it holds of the tables, in both units, rather than trusting the
    --       derivation.  It is not a measurement: both sides are integers
    --       computed exactly from the same finite tables.
    laghavaTests = concat
      [ chk "ardhamātrā: expanded - transmitted = Σ (n-1)·c"
          (lgExpArdha laghava - lgTransArdha laghava)
          (sum [ n * c | (_, n, c) <- laghavaByWord ardhamatras ])
      , chk "varṇa: the same identity in the other unit"
          (lgExpVarna laghava - lgTransVarna laghava)
          (sum [ n * c | (_, n, c) <- laghavaByWord varnaCount ])
      , chk "the counter: `saṃhitāyām` is 18 half-morae"
          (ardhamatras "saṃhitāyām") 18   -- s a ṃ h i t ā y ā m = 1+2+1+1+2+1+4+1+4+1
      , chk "the counter: a short vowel is 2 halves, a long one 4, a stop 1"
          (map ardhamatras ["a", "ā", "k", "ai", "ḥ"]) [2,4,1,4,1]
      , chk "the counter drops orthography, not sound"
          (varnasOf "eco 'yavāyāvaḥ")
          ["e","c","o","y","a","v","ā","y","ā","v","a","ḥ"]
      , chk "the saving is positive in both units"
          ( lgExpArdha laghava > lgTransArdha laghava
          , lgExpVarna laghava > lgTransVarna laghava ) (True, True)
      -- 8b: and it still does not pick the presentation.  The cancellation
      -- schedule is written nowhere, so `laghava` has no argument in which
      -- to receive it -- yet the grammars differ.  This is the running
      -- instance of `anuvrtti-does-not-factor`
      -- (NaturalMachine/AnuvrttiIsTheSameTrade.agda §3), on real sutra
      -- texts and with the difference visible as a derived form.
      , chk "nivṛtti costs nothing: the measure is a function of the text alone"
          (lgTransArdha laghava, lgTransVarna laghava)
          (sum [ ardhamatras (text s) | s <- sutras ]
          , sum [ varnaCount (text s) | s <- sutras ])
      , chk "and the two schedules over that same text derive different forms"
          (derive "deva + kula" == deriveUnder [((0,0,0),"aci")] "deva + kula") False
      ]

    -- 8.11  स्थानिवद्भावः (1.1.56) and लोपः (1.1.60), section 6c.
    --
    -- WHAT IS AND IS NOT EXERCISED, and this is the honest half of the
    -- section.  The EXCEPTION clause `anal-vidhau` is exercised: three
    -- corpus words have a rule firing at a position another rule had
    -- already substituted, and the rule reads the ādeśa (`barrierAudit`).
    -- The INHERITANCE half is DECLARED for the three designation-reading
    -- rules encoded here -- 1.1.5, 1.3.9, 7.1.1 -- and in every derivation
    -- this file runs, those three fire at sites holding no ādeśa, so their
    -- two readings COINCIDE and nothing distinguishes them.  That is
    -- checked below, not glossed over: `deriveRupamEverywhere`, which
    -- strikes `sthānivat` and makes every rule read the form, gives the
    -- same word as the grammar on the whole corpus.
    --
    -- So the divergence is exhibited by striking the EXCEPTION -- reading
    -- 1.1.56 as the folklore's full transparency -- and not by an encoded
    -- anal-vidhi seeing a sthānin.  Four corpus words then derive
    -- differently, and the mechanism differs in each:
    --
    --   tat + ca   tacca / tajca   8.4.40 keeps reading the t that 8.2.39
    --                              replaced, and substitutes again
    --   ne - ana   nayana / naaiana  6.1.87 and 6.1.88 chain on sthānins
    --   rāmas      rāmaḥ / rāmar   8.3.15 reads the s it was given in place
    --                              of, so its `r` condition is never met
    --   nī ~ lyuṭ  nayana / neyu   7.3.84 reads the ī it has just replaced,
    --                              re-offers the SAME guṇa, and the offer is
    --                              a no-op -- so the derivation reports a
    --                              fixpoint and halts three rules early.
    --
    -- The last is the sharpest and it was not the expected one: a guṇa rule
    -- that counts its own output as the sthānin cannot tell that it has
    -- fired.  `anal-vidhau` is what stops that, and stopping it is not a
    -- refinement of the rule -- without the clause the derivation ends in
    -- the wrong place, not merely with the wrong sound.
    --
    -- `vāc` is NOT in that list and the reason is worth recording: under
    -- the struck reading 8.2.39 cycles k → j → g and 8.4.56 cycles g → c → k,
    -- and the cycle happens to land back on the attested `vāk` after five
    -- steps instead of three.  Same form, different derivation.  A test on
    -- the form alone would have called this agreement.
    sthanivatTests = concat
      [ -- the table is TOTAL, so no rule acquires a reading by defaulting
        chk "every sūtra has an al-vidhi entry"
          [ num s | s <- sutras, num s `notElem` [ r | (r, _, _) <- alVidhiTable ] ] []
      , chk "and every entry names a sūtra that exists"
          [ r | (r, _, _) <- alVidhiTable, not (any ((== r) . num) sutras) ] []
      , chk "no sūtra is entered twice"
          (length (nub [ r | (r, _, _) <- alVidhiTable ])) (length alVidhiTable)
      , chk "every entry carries a reason"
          [ r | (r, _, w) <- alVidhiTable, null w ] []
      -- the barrier is CROSSED, and by which rules reading what
      , chk "vāc: 8.2.39 and 8.4.56 read past the sthānin to the ādeśa"
          (barrierAudit (parseInput "vāc"))
          [ ((8,2,39), AlVidhi, "c", "k"), ((8,4,56), AlVidhi, "k", "g") ]
      , chk "nī ~ lyuṭ: 6.1.78 reads the e that 7.3.84 put for ī"
          (barrierAudit (parseInput "nī ~ lyuṭ"))
          [ ((6,1,78), AlVidhi, "ī", "e") ]
      , chk "where nothing was substituted the barrier is never tested"
          (barrierAudit (parseInput "deva + indra")) []
      -- THE TWO READINGS DIFFER, on the encoded rules
      , chk "striking anal-vidhau changes four corpus words"
          [ (w, derive w, deriveSthanivatEverywhere w)
          | w <- [ "tat + ca", "ne - ana", "rāmas", "nī ~ lyuṭ" ] ]
          [ ("tat + ca",  "tacca",  "tajca")
          , ("ne - ana",  "nayana", "naaiana")
          , ("rāmas",     "rāmaḥ",  "rāmar")
          , ("nī ~ lyuṭ", "nayana", "neyu") ]
      , chk "and on vāc it changes the derivation and not the form"
          ( derive "vāc" == deriveSthanivatEverywhere "vāc"
          , length (fst (deriveTrace (parseInput "vāc")))
          , length (fst (deriveTraceV (Vidhana SthanivatSarvatra True) (parseInput "vāc"))) )
          (True, 3, 5)
      -- and the OTHER half is declared, not exercised: say so with a test
      , chk "striking sthānivat changes nothing here -- the inheritance half"
          [ w | w <- corpusWords, derive w /= deriveRupamEverywhere w ] []
      -- 1.1.60: lopa is not deletion, and the difference is a derived form
      , chk "ci ~ kta: 1.1.5 reads the k that 1.3.9 erased"
          (map fst (knitAudit (parseInput "ci ~ kta"))) [(1,1,5)]
      , chk "and the refusal decides the word"
          (derive "ci ~ kta", deriveWithoutLopa "ci ~ kta") ("cita", "ceta")
      , chk "where no affix is marked there is nothing to read"
          (knitAudit (parseInput "nī ~ lyuṭ"), knitAudit (parseInput "vāc")) ([], [])
      , chk "and deleting instead of eliding changes nothing without a marker"
          [ w | w <- corpusWords, w /= "ci ~ kta", derive w /= deriveWithoutLopa w ] []
      -- the channel is inert on the grammar that was here before it
      , chk "no derivation of the old corpus moved"
          [ (w, derive w) | (w, want) <- oldCorpus, derive w /= want ] []
      ]

    corpusWords =
      [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
      , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
      , "te + api", "ne - ana", "rāmas", "tat + ca", "tat + jalam", "vāc"
      , "nī ~ lyuṭ", "ci ~ kta" ]

    oldCorpus =
      [ ("dadhi + indra", "dadhīndra"), ("deva + indra", "devendra")
      , ("mahā + indra", "mahendra"),   ("su + ukta", "sūkta")
      , ("deva + ṛṣi", "devarṣi"),      ("mahā + ṛṣi", "maharṣi")
      , ("madhu + ari", "madhvari"),    ("deva + aiśvarya", "devaiśvarya")
      , ("te + api", "te'pi"),          ("ne - ana", "nayana")
      , ("ne + ana", "ne'na"),          ("rāmas", "rāmaḥ")
      , ("tat + ca", "tacca"),          ("tat + jalam", "tajjalam")
      , ("vāc", "vāk") ]

    -- 8.10  शेषः -- THE RESIDUAL.  The engine's stalls, kept.
    --
    -- The stall exhibited here is genuine and was not planted.  `tam + ca` is
    -- ordinary Sanskrit; m is neither jhaL nor cU nor s nor sTu, so not one
    -- of the sūtras encoded in this file reaches for that juncture at any
    -- configuration of the run, and the boundary survives into the final
    -- form.  The engine used to return `tam ca` in exactly the shape it
    -- returns `tajjalam` and say nothing.  It now emits the configuration,
    -- the position, who contended, who ever reached for it, and the parent
    -- that demanded it.
    --
    -- What the Aṣṭādhyāyī has here is 8.3.23 `mo 'nusvāraḥ`.  The residual
    -- does NOT name it: the machine states where it stalled, not the answer,
    -- and asserting a sūtra number the machine did not derive would be the
    -- fitted constant this repository's protocol exists to prevent.
    sesaTests =
      let gaps  = [ s | s <- sesah "tam + ca", sHetu s == Asutram ]
          seen  = [ s | s <- sesah "rāmas + ca", sHetu s == Asutram ]
          alien = [ s | s <- sesah "tat + fala", isAnaksara (sHetu s) ]
          edge  = [ s | s <- sesah "+ ca", sHetu s == Asutram ]
          isAnaksara (Anaksaram _) = True
          isAnaksara _             = False
          isAnirnita (Anirnitam _) = True
          isAnirnita _             = False
          r1 = Rewrite (6,1,77) 0 1 [P "y"] 0 "constructed, not from the table"
          r2 = Rewrite (6,1,77) 0 1 [P "v"] 0 "constructed, not from the table"
          r3 = Rewrite (6,1,101) 0 1 [P "ī"] 0 "constructed, not from the table"
          undec rs = let (_, _, _, u) = resolveN rs in u
      in concat
      -- the stall itself
      [ chk "tam + ca stalls: the juncture survives"
          (derive "tam + ca") "tam ca"
      , chk "and one residual is emitted for it"        (length gaps) 1
      , chk "carrying the exact juncture"
          (map (showSandhi . sSandhi) gaps) ["m + c"]
      , chk "carrying the parent that demanded it"      (map sJanaka gaps) ["tam + ca"]
      , chk "nobody ever reached for it"                (concatMap sDrsta gaps) []
      , chk "nobody contended for it"                   (concatMap sSpardhi gaps) []
      , chk "so the verdict is aviruddha over the vidhi sūtras searched"
          (map nirnaya gaps) [Aviruddha vidhiRefs]
      , chk "and it enters, carried in by that verdict"
          (map (pravesha . nirnaya) gaps) [Pravishati (Aviruddha vidhiRefs)]
      , chk "and this is what it asks for"
          (map sesaPrccha gaps) ["no sūtra offers at m + c"]
      -- the three that must NOT enter.  The khandita witness is 8.2.66
      -- `sasajuso ruh`, not 8.3.15: 8.2.66 is the FIRST rule to reach for
      -- that juncture, and the verdict carries who refuted it rather than
      -- who finished the job.  Written here after the machine said so.
      , chk "a juncture that survived but was reached for is khaṇḍita"
          (map nirnaya seen) [Khandita (8,2,66)]
      , chk "and turns back"
          (map (pravesha . nirnaya) seen) [Nivartate (Khandita (8,2,66))]
      , chk "a boundary with nothing before it has no dharmin"
          (map nirnaya edge) [Nirdharmin "nothing precedes the boundary"]
      , chk "and turns back"
          (all (\s -> case pravesha (nirnaya s) of Nivartate _ -> True; _ -> False) edge)
          True
      , chk "a resolved derivation leaves no debt"
          (sesaPrasna ["deva + indra"]) []
      -- the sound system's own silence
      , chk "f is not a sound of the varṇasamāmnāya"     (phoneOf "f") Nothing
      , chk "so the residual is तूष्णीम्, carrying the token"
          (map nirnaya alien) [Tusnim "f"]
      , chk "and तूष्णीम् enters, as it does in Obstruction.hs"
          (map (pravesha . nirnaya) alien) [Pravishati (Tusnim "f")]
      -- the conflict the metarules do not decide.  ARMED, NOT EXERCISED:
      -- the sūtras encoded here never produce two contenders at one locus
      -- that 1.4.2 cannot separate, and that is checked exhaustively over
      -- the corpus rather than assumed.  The mechanism is unit-tested on
      -- constructed rewrites, which are labelled as constructed.
      , chk "same Ref twice: 1.4.2 compares positions and these are equal"
          (undec [r1, r2]) (Just [(6,1,77),(6,1,77)])
      , chk "distinct Refs: 1.4.2 decides, and nothing is owed"
          (undec [r1, r3]) Nothing
      , chk "the encoded rule set never trips it (exhaustive over the corpus)"
          [ sHetu s | i <- sesaKosha, s <- sesah i, isAnirnita (sHetu s) ] []
      , chk "and no derivation in the corpus hits the fixpoint guard"
          [ sHetu s | i <- sesaKosha, s <- sesah i
                    , case sHetu s of Asamaptam _ -> True; _ -> False ] []
      -- the queue
      , chk "ranked by DISTINCT PARENTS, not by occurrences"
          (map snd (sesaPrasna ["tam + ca", "kim + ca", "tam + ca"])) [2]
      , chk "one juncture, two parents, one queue entry"
          (map (showSandhi . sSandhi . fst) (sesaPrasna ["tam + ca", "kim + ca"]))
          ["m + c"]
      -- पुनरावृत्तिः -- the livelock, and the thing that stops it
      , chk "re-asking the same parent yields THE SAME KEY -- stationary,\
            \ so an unsuppressed loop never ends"
          (map (sesaKey . fst) (sesaPrasna ["tam + ca"])
             == map (sesaKey . fst) (sesaPrasna ["tam + ca"])) True
      , chk "suppression: abhyasa over that parent stops after one round"
          (length (abhyasa 16 ["tam + ca"])) 1
      , chk "and holding the key empties the queue"
          (sesaPrasnaNava (map (sesaKey . fst) (sesaPrasna ["tam + ca"])) ["tam + ca"])
          []
      -- and the residual does NOT survive extraction from its parent
      , chk "the juncture alone renders as an input"
          (map (sesaPada . fst) (sesaPrasna ["tam + ca"])) ["m + c"]
      , chk "but that input is a different question: 8.2.30 cohkuh applies at\
            \ avasana and the juncture the residual named is gone"
          (map (sesaKey . fst) (sesaPrasna ["m + c"])
             == map (sesaKey . fst) (sesaPrasna ["tam + ca"])) False
      , chk "which is why the trace is kept and the parent is carried"
          (derive "m + c") "m k"
      ]
