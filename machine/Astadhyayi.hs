-- Astadhyayi -- Panini's grammar as a running machine, not a description of one.
--
-- WHAT THIS IS.  The Astadhyayi (Panini, ~500 BCE) is a rewriting system with
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
-- THE FIVE MECHANISMS, each implemented and each self-tested:
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
-- The Astadhyayi has ~3983 sutras (counts vary by recension, 3959-3996).  This
-- file encodes the number given by `length sutras` -- read it there, not here,
-- so it cannot go stale.  What is complete is the siva-sutra table, the
-- pratyahara extractor, the savarna relation of 1.1.9/1.1.10, and the four
-- metarule mechanisms.  What is a sample is the vidhi rules: enough of 6.1
-- (vowel sandhi) and 8.2-8.4 (the tripadi) to run real derivations end to end
-- and to exhibit each mechanism doing work.
--
-- SOURCES.  Panini, Astadhyayi, ~500 BCE (Katyayana's varttikas ~250 BCE,
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

module Astadhyayi
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
    -- the karaka layer (2.3.1, 2.3.2, 2.3.18)
  , Karaka(..)
  , Vibhakti(..)
  , Vacya(..)
  , abhihita
  , vibhaktiOf
  , Drshya
  , pacatiScene
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
data Item = P String | Pada | Morph | Avagraha | Avasana
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
-- A sutra of the Astadhyayi is NOT LOCALLY READABLE.  `coh kuh` is two
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
-- it.  The Astadhyayi's real anuvrtti graph runs to thousands of edges
-- and no source carrying it is reachable from this container (see the
-- 6.4.22 note in section 7a for the same egress limit).  So the laghava
-- figure in section 8a is a figure FOR THIS SAMPLE and a floor for the
-- text; it is not an estimate of the Astadhyayi's compression, and
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

  , Sutra (1,1,9) "tulyāsyaprayatnaṃ savarṇam"
      "same place and same effort: savarṇa" Samjna [] (\_ _ -> [])

  , Sutra (1,1,10) "nājjhalau"
      "a vowel and a consonant are never savarṇa" Niyama [] (\_ _ -> [])

  , Sutra (1,1,51) "ur aṇ raparaḥ"
      "an aṆ replacing ṛ is followed by r" Paribhasa [] (\_ _ -> [])

  , Sutra (1,1,69) "aṇudit savarṇasya cāpratyayaḥ"
      "an aṆ sound, or one marked with u, denotes its savarṇas too" Paribhasa [] (\_ _ -> [])

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
-- written, and that is the half where the Astadhyayi stops describing
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

data Karaka = Kartr | Karman | Karana
  deriving (Eq, Show)

data Vibhakti = Prathama | Dvitiya | Trtiya
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
  | k == abhihita v = (Prathama, "abhihita: the ending already expresses it, so 2.3.1 withdraws")
  | k == Karman     = (Dvitiya,  "2.3.2 कर्मणि द्वितीया")
  | otherwise       = (Trtiya,   "2.3.18 कर्तृकरणयोस्तृतीया")

-- a scene: which participants fill which roles.  This is the INPUT to the
-- Astadhyayi, and it is not a string.
type Drshya = [(Karaka, String)]

pacatiScene :: Drshya
pacatiScene = [ (Kartr, "devadatta"), (Karman, "odana") ]

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
    go ("+" : rest) = Pada    : go rest
    go ("-" : rest) = Morph   : go rest
    go ("." : rest) = Avasana : go rest
    go (w : rest)   = map P (tokenize w) ++ go rest

render :: [Item] -> String
render = concatMap f
  where
    f (P s)    = s
    f Pada     = " "
    f Morph    = ""
    f Avasana  = " "
    f Avagraha = "'"

------------------------------------------------------------------------
-- 7.  THE ENGINE
--
-- Section A (1.1.1 .. 8.1.x): all rules mutually siddha; run to a fixpoint,
--   resolving conflicts by apavada first, then by 1.4.2 paratva.
-- Section B (8.2.1 .. 8.4.x, the tripadi): each rule ONCE, in numeric order,
--   seeing only what precedes it.  That IS 8.2.1.
------------------------------------------------------------------------

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
  } deriving (Show)

applyRw :: [Item] -> Rewrite -> [Item]
applyRw xs (Rewrite _ i n new _ _) = take i xs ++ new ++ drop (i + n) xs

overlaps :: Rewrite -> Rewrite -> Bool
overlaps a b = rPos a < rPos b + rLen b && rPos b < rPos a + rLen a

-- utsarga/apavada, then 1.4.2.
resolve :: [Rewrite] -> (Rewrite, [Ref], String)
resolve [r] = (r, [], "sole candidate")
resolve rs =
  let apavadas = [ r | r <- rs, any (\o -> rSutra o `elem` apavadaTo (sutraAt (rSutra r))) rs ]
  in case apavadas of
       (r : _) -> (r, [ rSutra o | o <- rs, rSutra o /= rSutra r ]
                  , "apavāda blocks the utsarga (elsewhere condition)")
       []      -> let w = maximumBy (comparing rSutra) rs
                  in (w, [ rSutra o | o <- rs, rSutra o /= rSutra w ]
                     , "1.4.2 vipratiṣedhe paraṃ kāryam: the later sūtra")

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
stepAUnder :: [(Ref, String)] -> [Item] -> Maybe (Rewrite, [Ref], String)
stepAUnder nv xs =
  case sortOn rPos (concatMap (\s -> fires s (readingUnder nv s) xs) sectionA) of
    []  -> Nothing
    all_ ->
      let leftmost = minimum (map rPos all_)
          here     = [ r | r <- all_, overlaps r (head [ q | q <- all_, rPos q == leftmost ]) ]
          (w, l, why) = resolve here
      in Just (w, l, why)

stepA :: [Item] -> Maybe (Rewrite, [Ref], String)
stepA = stepAUnder []

deriveTrace :: [Item] -> ([Step], [Item])
deriveTrace = deriveTraceUnder []

deriveTraceUnder :: [(Ref, String)] -> [Item] -> ([Step], [Item])
deriveTraceUnder nv start = phaseB (phaseA 0 start [])
  where
    reading s = readingUnder nv s

    phaseA :: Int -> [Item] -> [Step] -> ([Step], [Item])
    phaseA k xs acc
      | k > 64 = (reverse acc, xs)          -- guard; no derivation here is long
      | otherwise = case stepAUnder nv xs of
          Nothing -> (reverse acc, xs)
          Just (w, lost, why) ->
            let ys = applyRw xs w
                st = Step (rSutra w) (text (sutraAt (rSutra w))) (rNote w)
                       lost why (render xs) (render ys)
                       (rdInherited (reading (sutraAt (rSutra w))))
            in if ys == xs then (reverse acc, xs) else phaseA (k + 1) ys (st : acc)

    phaseB :: ([Step], [Item]) -> ([Step], [Item])
    phaseB (acc, xs0) = go sectionB xs0 acc
      where
        go [] xs acc' = (acc', xs)
        go (s : ss) xs acc' =
          -- a tripadi rule applies to a fixpoint on ITS OWN output (a rule is
          -- siddha to itself) but never sees a later rule, and is never
          -- revisited once passed.
          let (xs', steps) = saturate s xs []
          in go ss xs' (acc' ++ steps)

        saturate s xs acc' =
          case fires s (reading s) xs of
            [] -> (xs, reverse acc')
            (r : _) ->
              let ys = applyRw xs r
              in if ys == xs || length acc' > 16
                   then (xs, reverse acc')
                   else saturate s ys
                          (Step (num s) (text s) (rNote r) [] "tripādī: in order, 8.2.1"
                             (render xs) (render ys) (rdInherited (reading s)) : acc')


------------------------------------------------------------------------
-- 7a.  ASIDDHAVAT -- the OTHER device, 6.4.22, added 2026-08-19.
--
-- Panini spends a sutra on each of two regimes and they are not variants
-- of one another.  This engine had only the first:
--
--   8.2.1  purvatrasiddham       any SUBSEQUENT rule is asiddha with
--          (Astadhyayi 8.2.1)    respect to any rule that PRECEDES it, so
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
asiddhavatPass block xs =
  let offers = [ (s, r) | s <- block, r <- fires s (readingUnder [] s) xs ]
      chosen = pick (sortOn (rPos . snd) offers)
      -- apply right-to-left so earlier positions keep their indices
      ys = foldl applyRw xs (reverse (sortOn rPos (map snd chosen)))
      steps = [ Step (num s) (text s) (rNote r) [] "asiddhavat: simultaneous, 6.4.22"
                     (render xs) (render ys) (contextAt (num s))
              | (s, r) <- chosen ]
  in (steps, ys)
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
-- 8.  HONESTY
------------------------------------------------------------------------

-- The Astadhyayi has about 3983 sutras (recensions differ: 3959-3996).  This
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
-- the whole content of the device, and it is why the real Astadhyayi --
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
-- is NOT an estimate for the Astadhyayi: the real anuvrtti graph is not
-- reachable from this container (same egress limit recorded at 6.4.22),
-- and a figure extrapolated from four continuations to several thousand
-- would be exactly the fitted constant this repository's protocol exists
-- to prevent.  What generalises is the identity above, which is proved,
-- not the number, which is a sample.
--
-- AND IT DOES NOT PICK THE PRESENTATION.  See section 8b.
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
-- `formal/cubical/NaturalMachine/LaghavaUnderdeterminesSoTheMetarulesAreNotOptional.agda`
-- proves that brevity attains its minimum NON-UNIQUELY: `plus var (lit 1)`
-- and `plus (lit 1) var` are distinct expressions of equal size with EQUAL
-- denotation, so the measure picks a level set and something else must
-- choose inside it -- which is why the paribhasas are structurally
-- required rather than ornamental.
--
-- Making anuvrtti explicit EXTENDS that, in the direction the Agda file
-- does not reach, and does not contradict it.  There, two presentations
-- of one meaning had equal cost.  Here, two presentations with IDENTICAL
-- cost have DIFFERENT MEANINGS -- because a nivrtti costs nothing.  The
-- cancellation of a running word is written NOWHERE in the sutrapatha;
-- it is inferred by the reader.  So the transmitted text, taken as a
-- string of symbols, does not determine the grammar at all: two
-- cancellation schedules over the same characters denote different
-- languages at zero difference in varnas and zero in ardhamatras.
--
-- laghava therefore does not merely fail to pick among presentations of
-- one meaning (the Agda result).  It fails to pick the MEANING.  What
-- supplies it is the same apparatus the Agda file names -- the
-- paribhasas, and the commentarial tradition that transmits the
-- anuvrtti with the text.  A minimum-description-length criterion with
-- an uncounted channel is not a criterion, and the tradition's answer is
-- to name the channel and transmit it, not to pretend it is not there.
--
-- `nivrttiIsFree` is that fact, checked: same symbol counts, different
-- derived forms.
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
  , laghavaTests
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
      -- to receive it -- yet the grammars differ.  Equal cost, different
      -- meaning: the dual of the Agda result, which has equal cost and
      -- EQUAL meaning.
      , chk "nivṛtti costs nothing: the measure is a function of the text alone"
          (lgTransArdha laghava, lgTransVarna laghava)
          (sum [ ardhamatras (text s) | s <- sutras ]
          , sum [ varnaCount (text s) | s <- sutras ])
      , chk "and the two schedules over that same text derive different forms"
          (derive "deva + kula" == deriveUnder [((0,0,0),"aci")] "deva + kula") False
      ]
