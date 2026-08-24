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

-- English plural allomorphy, run by the same core -- the second instantiation,
-- present so that the factoring in
-- `Prakriya_TheGeneralDerivationCoreFactoredFromTheAstadhyayi.hs` can be
-- checked for being a rename.
--
-- THE NAME IS ENGLISH ON PURPOSE.  The file-naming rule of this repository
-- leads with the term the SOURCE tradition uses, and invents nothing: the
-- material here is English phonology and there is no Sanskrit object it is
-- the name of.  Every DEVICE it is run by is Pāṇini's, is named in Sanskrit
-- at the field, and is cited in the core.
--
-- WHAT IT IS.  A toy: four rules over a six-word corpus, in a coarse
-- transcription, with no claim about English phonological theory and no
-- claim about Pāṇini.  Its only job is to make four devices do visible work
-- on material Pāṇini never saw, and each of the four is shown load-bearing
-- by running the same rules with that one device changed and getting a form
-- English does not have:
--
--   pratyāhāra    "voiceless" and "sibilant" are INTERVALS in one linear
--                 order of English phonemes punctuated by markers, two
--                 symbols each, exactly the śivasūtra device.  The order is
--                 mine and is unmotivated -- see residual 7 in the core.
--   apavāda       sibilant epenthesis (horse -> horses) is an exception to
--                 the general devoicing rule and is EARLIER in the order, so
--                 only a ranked metarule gets it right; 1.4.2 alone gives
--                 *hɔss.
--   8.2.1         the it-marker deletion is a later stratum.  Put it in the
--                 same stratum and it removes its own rules' condition
--                 before they can use it: *kætz.
--   1.1.56        `sthānivad ādeśo 'nalvidhau`.  knife -> knives: f becomes
--                 v, and the devoicing rule INSPECTS FORM, so it sees v and
--                 does not fire.  Declare it a non-al-vidhi rule -- let it
--                 read the substitute as its sthānin f -- and it fires:
--                 *naɪvs.
--
-- SOURCES FOR THE DEVICES.  Pāṇini, *Aṣṭādhyāyī*, ~500 BCE: 1.1.56, 1.3.9
-- `tasya lopaḥ`, 1.4.2, 8.2.1.  Nāgeśa Bhaṭṭa, *Paribhāṣenduśekhara*, c.
-- 1730, paribhāṣā 38, for the strength order of the metarules.
--
-- SOURCE FOR THE DATA.  The forms cats, dogs, horses, churches, knives, buzz
-- are ordinary English and are checked against themselves; no phonological
-- authority is cited because none is claimed.
module EnglishPluralAllomorphy_TheSecondInstantiationOfTheCore
  ( Seg(..)
  , english
  , plural
  , corpus
  , variants
  , selfTest
  , report
  ) where

import Prakriya_TheGeneralDerivationCoreFactoredFromTheAstadhyayi
import Data.List (nub)

------------------------------------------------------------------------
-- 1.  THE UNIT.  A segment carries a form, the form it replaced (its
--     sthānin), and its designations.
------------------------------------------------------------------------

data Seg = Seg { sgForm :: String, sgSthanin :: String, sgSamjna :: [String] }
  deriving (Eq, Show)

seg :: String -> Seg
seg f = Seg f f []

tagged :: String -> [String] -> Seg
tagged f ts = Seg f f ts

-- 1.3.9 `tasya lopaḥ`: the juncture marker conditions the three rules below
-- and must not survive.  It is what tells them "this sibilant is the plural
-- suffix" -- without it, buzz would look like a stem plus a suffix.
markerForm :: String
markerForm = "#"

isMarker :: Seg -> Bool
isMarker s = sgForm s == markerForm

------------------------------------------------------------------------
-- 2.  THE ORDER, and the classes as intervals in it.
------------------------------------------------------------------------

amnaya :: Amnaya String String
amnaya = map Varna ["p","t","k","f","θ","h","s","ʃ","tʃ"] ++ [Anubandha "K"]
      ++ map Varna ["z","ʒ","dʒ"] ++ [Anubandha "S"]
      ++ map Varna [ "b","d","g","v","ð","m","n","ŋ","l","r","w","j"
                   , "ɪ","æ","ɒ","ɜ","ʌ","ɔ","aɪ" ] ++ [Anubandha "L"]

voiceless, sibilant, voiced, nasal :: [String]
voiceless = antaralaSet amnaya "p" "K" 0     -- "pK"
sibilant  = antaralaSet amnaya "s" "S" 0     -- "sS", straddling the marker K
voiced    = antaralaSet amnaya "z" "L" 0     -- "zL", straddling S
nasal     = ["m","n","ŋ"]                    -- queried by nothing; see below

-- The classes the rules query, plus one they do not.  `nasal` is listed so
-- that the lāghava audit reports a failure: this order names it with no
-- interval, and an order that named every subset would not exist (the bound
-- in the audit is why).  Pāṇini's answer to that case is a gaṇapāṭha -- a
-- list -- and the gaṇa below is one.
prcchana :: [(String, [String])]
prcchana = [ ("voiceless", voiceless), ("sibilant", sibilant)
           , ("voiced", voiced), ("nasal", nasal) ]

-- The gaṇa: the stems whose final fricative voices before the plural.  A
-- LIST, because it is not a phonological class -- leaf, knife, wife voice;
-- cliff, cuff, chief do not.  Marked in the lexicon as a designation.
ganaLeaf :: [String]
ganaLeaf = ["gaṇa-leaf"]

------------------------------------------------------------------------
-- 3.  THE RULES
------------------------------------------------------------------------

at :: [Seg] -> Int -> Maybe Seg
at xs i | i < 0 || i >= length xs = Nothing
        | otherwise               = Just (xs !! i)

formAt :: [Seg] -> Int -> String
formAt xs i = maybe "" sgForm (at xs i)

-- G1.  leaf-gaṇa fricative voicing: f -> v before the plural juncture.
g1 :: Sasana Seg
g1 = Sasana [1,1] "leaf-gaṇa fricative voicing" [] True $ \_ xs ->
  [ Karya [1,1] i 1 [Seg "v" "f" (sgSamjna s)]
      ("f -> v (gaṇa: leaf, knife, wife) before the plural juncture")
  | (i, s) <- zip [0 ..] xs
  , sgForm s == "f"
  , any (`elem` sgSamjna s) ganaLeaf
  , formAt xs (i + 1) == markerForm ]

-- E1.  sibilant epenthesis: ɪ before the suffix when the stem ends in a
-- sibilant.  APAVĀDA to A1, and EARLIER in the order than A1, so position
-- alone gets it wrong.
e1 :: Sasana Seg
e1 = Sasana [1,2] "sibilant epenthesis" [[1,3]] True $ \_ xs ->
  [ Karya [1,2] i 1 [tagged "ɪ" ["epenthetic"], s]
      "ɪ inserted before the suffix after a sibilant-final stem"
  | (i, s) <- zip [0 ..] xs
  , sgForm s `elem` sibilant
  , formAt xs (i - 1) == markerForm
  , formAt xs (i - 2) `elem` sibilant ]

-- A1.  suffix devoicing: z -> s after a voiceless segment.  DECLARED
-- al-vidhi (form-inspecting), which is what 1.1.56 exempts from
-- sthānivadbhāva, and the knife case turns on that declaration.
a1 :: Sasana Seg
a1 = Sasana [1,3] "plural suffix devoicing" [] True $ \_ xs ->
  [ Karya [1,3] i 1 [Seg "s" (sgForm s) (sgSamjna s)]
      ("suffix z -> s after voiceless " ++ formAt xs (i - 2))
  | (i, s) <- zip [0 ..] xs
  , sgForm s == "z"
  , formAt xs (i - 1) == markerForm
  , formAt xs (i - 2) `elem` voiceless ]

-- L1.  1.3.9 `tasya lopaḥ`: the marker has conditioned; delete it.  STRATUM
-- 1, because in stratum 0 it stands to the LEFT of every site the three
-- rules above act on, the engine takes the leftmost site, and the condition
-- is gone before it is used.
l1 :: Sasana Seg
l1 = Sasana [2,1] "it-marker deletion (1.3.9 tasya lopaḥ)" [] True $ \_ xs ->
  [ Karya [2,1] i 1 [] "juncture marker deleted after conditioning"
  | (i, s) <- zip [0 ..] xs, isMarker s ]

------------------------------------------------------------------------
-- 4.  THE GRAMMAR
------------------------------------------------------------------------

english :: Vyakarana Seg String String
english = Vyakarana
  { vyAmnaya   = amnaya
  , vyPrcchana = prcchana
  , vySasanani = [g1, e1, a1, l1]
  , vyAdhikara = [ ([1,1], [1,3], "at the plural juncture") ]
  , vyNiyama   =
      [ ("at the plural juncture"
        , \k -> kySthana k /= [2,1]) ]   -- nothing under the heading deletes
  , vyKaksya   = \r -> case r of
      (1 : _) -> 0
      _       -> 1                       -- 8.2.1 generalised: lopa runs last
  , vyParibhasa = paribhasenduSekhara38
  , vyApavada   = \_ _ -> False
  , vyAntaranga = \_ _ -> Nothing        -- ABSTAIN: nimitta depth undefined here
  , vyParatva   = True                   -- the addresses are authored, by me
  , vyOverlap   = samsarga
    -- 1.1.56, negatively: read a substitute as the segment it replaced.
  , vySthanivat = \s -> s { sgForm = sgSthanin s }
    -- 1.1.56, positively: the substitute takes the sthānin's designations
    -- (and remembers what it replaced).
  , vyAdesaSamjna = \old new ->
      [ n { sgSamjna = nub (sgSamjna n ++ concatMap sgSamjna old)
          , sgSthanin = case old of (o : _) -> sgSthanin o; [] -> sgSthanin n }
      | n <- new ]
  , vyIt   = isMarker
  , vySame = (==)
  }

------------------------------------------------------------------------
-- 5.  THE CORPUS
------------------------------------------------------------------------

-- a word: the stem, and whether the plural suffix is attached
word :: [Seg] -> Bool -> [Seg]
word stem False = stem
word stem True  = stem ++ [tagged markerForm ["it"], tagged "z" ["PL"]]

stems :: [(String, [Seg], Bool)]
stems =
  [ ("cat",    map seg ["k","æ","t"],       True)
  , ("dog",    map seg ["d","ɒ","g"],       True)
  , ("horse",  map seg ["h","ɔ","s"],       True)
  , ("church", map seg ["tʃ","ɜ","tʃ"],     True)
  , ("knife",  map seg ["n","aɪ"] ++ [tagged "f" ["gaṇa-leaf"]], True)
  , ("buzz",   map seg ["b","ʌ","z"],       False)
  ]

corpus :: [(String, [Seg], String)]
corpus =
  [ ("cat",    word (segsOf "cat")    True,  "kæts")
  , ("dog",    word (segsOf "dog")    True,  "dɒgz")
  , ("horse",  word (segsOf "horse")  True,  "hɔsɪz")
  , ("church", word (segsOf "church") True,  "tʃɜtʃɪz")
  , ("knife",  word (segsOf "knife")  True,  "naɪvz")
  , ("buzz",   word (segsOf "buzz")   False, "bʌz")
  ]
  where segsOf n = head ([ st | (m, st, _) <- stems, m == n ] ++ [[]])

render :: [Seg] -> String
render = concatMap sgForm

plural :: [Seg] -> String
plural = render . rupa english 32

------------------------------------------------------------------------
-- 6.  THE FOUR DEVICES, EACH SHOWN LOAD-BEARING BY BREAKING IT
------------------------------------------------------------------------

-- 1.4.2 alone: apavāda and nitya both removed from the list.
onlyPara :: Vyakarana Seg String String
onlyPara = english { vyParibhasa = [paraP], vySasanani = [g1, e1 { ssApavadaTo = [] }, a1, l1] }

-- the same, with no authored order at all: the defect gets written.
unauthored :: Vyakarana Seg String String
unauthored = onlyPara { vyParatva = False }

-- 8.2.1 removed: one stratum.
oneStratum :: Vyakarana Seg String String
oneStratum = english { vyKaksya = const 0 }

-- 1.1.56 inverted: the devoicing rule reads the substitute as its sthānin.
noAlvidhi :: Vyakarana Seg String String
noAlvidhi = english { vySasanani = [g1, e1, a1 { ssAlvidhi = False }, l1] }

variants :: [(String, String, String, String)]
variants =
  [ ( "apavāda dropped (1.4.2 alone)", "horse"
    , render (rupa onlyPara 32 (input "horse")), "hɔsɪz" )
  , ( "8.2.1 dropped (lopa in stratum 0)", "cat"
    , render (rupa oneStratum 32 (input "cat")), "kæts" )
  , ( "1.1.56 inverted (devoicing reads the sthānin)", "knife"
    , render (rupa noAlvidhi 32 (input "knife")), "naɪvz" )
  ]
  where input n = head ([ x | (m, x, _) <- corpus, m == n ] ++ [[]])

input :: String -> [Seg]
input n = head ([ x | (m, x, _) <- corpus, m == n ] ++ [[]])

------------------------------------------------------------------------
-- 7.  CHECKS.  Returns [] on success.
------------------------------------------------------------------------

selfTest :: [String]
selfTest = concat
  [ concat [ chk ("plural of " ++ nm) (plural xs) want | (nm, xs, want) <- corpus ]
    -- the pratyāhāra device on an unrelated carrier
  , chk "\"pK\" names the voiceless segments, in two symbols"
      voiceless ["p","t","k","f","θ","h","s","ʃ","tʃ"]
  , chk "\"sS\" names the sibilants, straddling the marker K"
      sibilant ["s","ʃ","tʃ","z","ʒ","dʒ"]
  , chk "the sibilant interval really does straddle a foreign marker"
      (length [ () | Anubandha _ <- spanOf amnaya "s" "S" 0 ]) 1
  , chk "the order names the three classes the rules query, and not nasals"
      (lgUnnamed (laghava amnaya prcchana)) ["nasal"]
    -- each device, broken, gives a form English does not have
  -- 1.4.2 alone takes the LATER rule, devoicing, and epenthesis then applies
  -- to its output: hɔsɪs, which English does not have.  The ranked metarule
  -- is what puts the exception first.
  , chk "with 1.4.2 alone, horse comes out wrong"
      (render (rupa onlyPara 32 (input "horse"))) "hɔsɪs"
  , chk "with one stratum, the marker is deleted before it conditions"
      (render (rupa oneStratum 32 (input "cat"))) "kætz"
  , chk "with 1.1.56 inverted, knife comes out wrong"
      (render (rupa noAlvidhi 32 (input "knife"))) "naɪvs"
    -- and the same three, unbroken, are right
  , chk "apavāda decides the horse site for epenthesis over devoicing"
      (decidedBy english "horse" [1,2] [1,3]) (Just "apavāda")
    -- OBSERVED, not designed: with the apavāda declaration removed but the
    -- full metarule list kept, NITYA decides the same way -- epenthesis still
    -- has its occasion after devoicing has applied and devoicing does not
    -- after epenthesis has.  So the wrong form needs BOTH stronger metarules
    -- gone, which is why `onlyPara` drops the list and not just the
    -- declaration.
  , chk "with the apavāda declaration removed, nitya still decides for it"
      (decidedBy (english { vySasanani = [g1, e1 { ssApavadaTo = [] }, a1, l1] })
                 "horse" [1,2] [1,3]) (Just "nitya")
    -- 1.1.56 positively: the substitute keeps the designation it replaced
  , chk "the devoiced suffix is still designated PL although its form changed"
      [ (sgForm s, "PL" `elem` sgSamjna s)
      | s <- rupa english 32 (input "cat"), "PL" `elem` sgSamjna s ]
      [("s", True)]
    -- 1.3.9: no marker survives
  , concat [ itAudit english (rupa english 32 xs) | (_, xs, _) <- corpus ]
    -- the heading is checked against the rewrites, not annotated
  , chk "no offer under the heading violates it"
      (adhikaraAudit english [ xs | (_, xs, _) <- corpus ]) []
    -- and where nothing decides, a defect is WRITTEN rather than a rule picked
  , chk "unauthored order: the derivation stops and writes a defect"
      (case prasadhana unauthored 32 (input "horse") of
         (_, Just _, _) -> True
         _              -> False) True
  ]
  where
    chk nm got want | got == want = []
                    | otherwise   = [ nm ++ ": got " ++ show got
                                      ++ ", wanted " ++ show want ]
    decidedBy g nm win lost =
      case [ pdParibhasa p
           | let (steps, _, _) = prasadhana g 32 (input nm), p <- steps
           , pdSthana p == win, lost `elem` pdBeaten p ] of
        (b : _) -> Just b
        []      -> Nothing

report :: [String]
report =
  [ "ENGLISH PLURAL ALLOMORPHY, RUN BY THE SAME CORE", "" ]
  ++ laghavaReport (laghava amnaya prcchana)
  ++ [ "", "  voiceless = pK = " ++ unwords voiceless
     , "  sibilant  = sS = " ++ unwords sibilant
     , "  voiced    = zL = " ++ unwords voiced
     , "", "derivations:" ]
  ++ concat [ [ "  " ++ pad 8 nm ++ " -> " ++ plural xs ] ++ trace xs
            | (nm, xs, _) <- corpus ]
  ++ [ "", "each device broken in turn, same rules otherwise:" ]
  ++ [ "  " ++ pad 46 what ++ nm ++ " -> " ++ got ++ "  (attested: " ++ want ++ ")"
     | (what, nm, got, want) <- variants ]
  ++ [ "", "with no authored order and 1.4.2 alone, nothing decides:" ]
  ++ (case prasadhana unauthored 32 (input "horse") of
        (_, Just d, _) -> map ("  " ++) (showDosa d)
        _              -> ["  (decided -- this line should not appear)"])
  where
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
    trace xs =
      let (steps, _, _) = prasadhana english 32 xs
      in [ "        " ++ showSthana (pdSthana p) ++ "  " ++ pdName p
           ++ "  [" ++ pdParibhasa p ++ "]"
           ++ (if null (pdBeaten p) then ""
                 else "  beat " ++ unwords (map showSthana (pdBeaten p)))
         | p <- steps ]
