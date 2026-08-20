-- Prakriyā saṃskṛtā -- the Aṣṭādhyāyī's sandhi rules as ONE instantiation of
-- the general derivational core, and the primary one.
--
-- SOURCE.  Pāṇini, *Aṣṭādhyāyī*, ~500 BCE.  Sūtra text and numbering follow
-- the vulgate.  The sound system -- the fourteen śivasūtras, the pratyāhāra
-- extractor, savarṇa by 1.1.9 `tulyāsyaprayatnaṃ savarṇam` with the 1.1.10
-- `nājjhalau` override and the 1.1.69 extension -- is NOT restated here: it is
-- imported from `machine/Astadhyayi.hs`, which is the running grammar this
-- core was factored out of.
--
-- WHY THE RULES ARE RESTATED AND THE SOUNDS ARE NOT.  `Astadhyayi.Sutra`
-- carries `fires :: Reading -> [Item] -> [Rewrite]`, and `Reading` is not
-- exported, so no other module can call a sūtra.  Restating fifteen rules in
-- the core's vocabulary is therefore forced.  It is made honest rather than
-- left as a fork by `agreement` below, which runs BOTH engines over the same
-- corpus and requires them to agree form for form: if `Astadhyayi.hs` changes
-- a rule, this file fails rather than drifting.  Exporting `Reading` and
-- sharing the single table is the right fix and is left undone (that file is
-- under active edit by another identity; a rename of someone else's module is
-- an offer, not a move).
--
-- WHAT THE INSTANTIATION SUPPLIES, device by device:
--
--   ā́mnāya          the varṇasamāmnāya, converted from Astadhyayi's Slot
--   query family    the twelve classes these rules actually ask for
--   adhikāra        6.1.72 saṃhitāyām, 6.1.84 ekaḥ pūrvaparayoḥ, 8.1.16
--                   padasya, and the anuvṛtti of `aci` from 6.1.77 with its
--                   nivṛtti at 6.1.109
--   niyama          what 6.1.84 REQUIRES: one substitute for two, checked on
--                   the rewrites, with 1.1.51 `ur aṇ raparaḥ` discounted
--   kakṣyā          8.2.1 pūrvatrāsiddham: the tripādī is stratum 1
--   paribhāṣā       the full Paribhāṣenduśekhara-38 list; the grammar uses
--                   apavāda (6.1.88 over 6.1.87) and para (1.4.2), abstains
--                   on antaraṅga, and nitya never decides in this corpus
--   sthānivadbhāva  ABSTAINED: see `residual` note at the bottom of this file
--
-- NOT CLAIMED.  That this is the Aṣṭādhyāyī: it is fifteen sūtras of ~3983
-- (recensions differ, 3959-3996), the same sample `Astadhyayi.coverage`
-- reports and by the same count.  That the core is what makes the grammar
-- work: the grammar worked; the core is a claim about which of its devices
-- are separable, and section `residual` in the core lists what separating
-- them costs.
module PrakriyaSamskrta_TheAstadhyayiRunByTheGeneralCore
  ( samskrtam
  , derive
  , deriveTrace
  , corpus
  , agreement
  , selfTest
  , report
  ) where

import qualified Astadhyayi as A
import Prakriya_TheGeneralDerivationCoreFactoredFromTheAstadhyayi
import Data.List (nub)

------------------------------------------------------------------------
-- the sound system, imported, not restated
------------------------------------------------------------------------

amnaya :: Amnaya String String
amnaya = map conv A.varnasamamnaya
  where conv (A.Snd s) = Varna s
        conv (A.It m)  = Anubandha m

aC, iK, aK, eC, eN, haL, jhaL, khaR, jhaS, sTu, sCu, sTuR :: [String]
aC   = A.denotes (A.pratyahara "a" "c")
iK   = A.denotes (A.pratyahara "i" "k")
aK   = A.denotes (A.pratyahara "a" "k")
eC   = A.pratyahara "e" "c"
eN   = A.pratyahara "e" "ṅ"
haL  = nub (A.pratyahara "h" "l")
jhaL = nub (A.pratyahara "jh" "l")
khaR = nub (A.pratyahara "kh" "r")
jhaS = A.pratyahara "jh" "ś"
sTu  = ["s","t","th","d","dh","n"]
sCu  = ["ś","c","ch","j","jh","ñ"]
sTuR = ["ṣ","ṭ","ṭh","ḍ","ḍh","ṇ"]

-- The classes the rules below actually query.  `stu`, `ścu` and `ṣṭu` are in
-- the text as gaṇa-like citations (`stoḥ ścunā ścuḥ`), not as pratyāhāras,
-- and the lāghava audit reports them as what they are.
prcchana :: [(String, [String])]
prcchana =
  [ ("aC",   A.pratyahara "a" "c"), ("iK", A.pratyahara "i" "k")
  , ("aK",   A.pratyahara "a" "k"), ("eC", eC), ("eṄ", eN)
  , ("haL",  haL), ("jhaL", jhaL), ("khaR", khaR), ("jhaŚ", jhaS)
  , ("stu",  sTu), ("ścu", sCu), ("ṣṭu", sTuR) ]

------------------------------------------------------------------------
-- rule helpers (1.1.51 and the varga tables) -- restated with the rules
------------------------------------------------------------------------

type I = A.Item

nextPhBy :: Bool -> [I] -> Int -> Maybe (Int, String)
nextPhBy crossPause xs i = go (i + 1)
  where
    go j | j >= length xs = Nothing
    go j = case xs !! j of
             A.P s      -> Just (j, s)
             A.Avasana  -> if crossPause then go (j + 1) else Nothing
             _          -> go (j + 1)

-- 6.1.72 saṃhitāyām, AT THE POINT OF APPLICATION: with the heading in force
-- a pause blocks; without it the walk crosses the pause.
nextPhIn :: [String] -> [I] -> Int -> Maybe (Int, String)
nextPhIn ctx = nextPhBy (notElem "saṃhitāyām" ctx)

nextPh :: [I] -> Int -> Maybe (Int, String)
nextPh = nextPhBy False

atPadanta :: [I] -> Int -> Bool
atPadanta xs i = case drop (i + 1) xs of
                   (A.Pada : _)    -> True
                   (A.Avasana : _) -> True
                   []              -> True
                   _               -> False

-- 8.1.16 padasya, AT THE POINT OF APPLICATION.
padantaIn :: [String] -> [I] -> Int -> Bool
padantaIn ctx xs i = notElem "padasya" ctx || atPadanta xs i

-- the anuvṛtti of `aci` from 6.1.77, which four later sūtras condition on
-- and none of them states.
aciIn :: [String] -> String -> Bool
aciIn ctx t = notElem "aci" ctx || t `elem` aC

atAvasana :: [I] -> Int -> Bool
atAvasana xs i = case drop (i + 1) xs of
                   []              -> True
                   (A.Avasana : _) -> True
                   _               -> False

scan :: [I] -> (Int -> String -> [Karya I]) -> [Karya I]
scan xs f = concat [ f i s | (i, A.P s) <- zip [0 ..] xs ]

guna :: String -> [I]
guna x = case x of
  "i" -> [A.P "e"]; "ī" -> [A.P "e"]
  "u" -> [A.P "o"]; "ū" -> [A.P "o"]
  "ṛ" -> [A.P "a", A.P "r"]; "ṝ" -> [A.P "a", A.P "r"]   -- 1.1.51 ur aṇ raparaḥ
  "ḷ" -> [A.P "a", A.P "l"]                              -- 1.1.51, la-paraḥ
  _   -> [A.P x]

gunaRapara :: String -> Int
gunaRapara x = if x `elem` ["ṛ","ṝ","ḷ"] then 1 else 0

vrddhi, dirgha, yan, jas, car, ku, scuOf, stuRetroOf :: String -> String
vrddhi x = case x of
  "e" -> "ai"; "o" -> "au"; "ai" -> "ai"; "au" -> "au"
  "a" -> "ā"; "ā" -> "ā"; "i" -> "ai"; "ī" -> "ai"; "u" -> "au"; "ū" -> "au"
  _ -> x
dirgha x = case x of
  "a" -> "ā"; "ā" -> "ā"; "i" -> "ī"; "ī" -> "ī"
  "u" -> "ū"; "ū" -> "ū"; "ṛ" -> "ṝ"; "ṝ" -> "ṝ"; _ -> x
yan x = case x of
  "i" -> "y"; "ī" -> "y"; "u" -> "v"; "ū" -> "v"
  "ṛ" -> "r"; "ṝ" -> "r"; "ḷ" -> "l"; _ -> x
jas x = case x of
  "k" -> "g"; "kh" -> "g"; "g" -> "g"; "gh" -> "g"
  "c" -> "j"; "ch" -> "j"; "j" -> "j"; "jh" -> "j"
  "ṭ" -> "ḍ"; "ṭh" -> "ḍ"; "ḍ" -> "ḍ"; "ḍh" -> "ḍ"
  "t" -> "d"; "th" -> "d"; "d" -> "d"; "dh" -> "d"
  "p" -> "b"; "ph" -> "b"; "b" -> "b"; "bh" -> "b"; _ -> x
car x = case x of
  "k" -> "k"; "kh" -> "k"; "g" -> "k"; "gh" -> "k"
  "c" -> "c"; "ch" -> "c"; "j" -> "c"; "jh" -> "c"
  "ṭ" -> "ṭ"; "ṭh" -> "ṭ"; "ḍ" -> "ṭ"; "ḍh" -> "ṭ"
  "t" -> "t"; "th" -> "t"; "d" -> "t"; "dh" -> "t"
  "p" -> "p"; "ph" -> "p"; "b" -> "p"; "bh" -> "p"; _ -> x
ku x = case x of
  "c" -> "k"; "ch" -> "kh"; "j" -> "g"; "jh" -> "gh"; "ñ" -> "ṅ"; _ -> x
scuOf x = case x of
  "s" -> "ś"; "t" -> "c"; "th" -> "ch"; "d" -> "j"; "dh" -> "jh"; "n" -> "ñ"; _ -> x
stuRetroOf x = case x of
  "s" -> "ṣ"; "t" -> "ṭ"; "th" -> "ṭh"; "d" -> "ḍ"; "dh" -> "ḍh"; "n" -> "ṇ"; _ -> x

ayavayav :: String -> [I]
ayavayav x = case x of
  "e" -> [A.P "a", A.P "y"]; "o" -> [A.P "a", A.P "v"]
  "ai" -> [A.P "ā", A.P "y"]; "au" -> [A.P "ā", A.P "v"]
  _ -> [A.P x]

------------------------------------------------------------------------
-- THE SŪTRAS, as Sasanas of the core
------------------------------------------------------------------------

su :: [Int] -> String -> [[Int]] -> Bool -> ([String] -> [I] -> [Karya I]) -> Sasana I
su r nm apa alv f = Sasana r nm apa alv f

sutrani :: [Sasana I]
sutrani =
  [ -- 6.1.77 iko yaṇ aci -- STATES `aci`; outside the 6.1.84 heading, so the
    -- following vowel survives.
    su [6,1,77] "iko yaṇ aci" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,77] i (j - i) [A.P (yan s)]
          ("iK " ++ s ++ " -> yaṆ " ++ yan s ++ " before aC " ++ t)
      | s `elem` iK, Just (j, t) <- [nextPhIn ctx xs i], aciIn ctx t ]))

    -- 6.1.78 eco 'yavāyāvaḥ -- outside the heading: ONE sound becomes TWO,
    -- which is the case proving the heading does work.
  , su [6,1,78] "eco 'yavāyāvaḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,78] i (j - i) (ayavayav s)
          ("eC " ++ s ++ " -> " ++ concat [ c | A.P c <- ayavayav s ] ++ " before aC " ++ t)
      | s `elem` eC, Just (j, t) <- [nextPhIn ctx xs i], aciIn ctx t ]))

    -- 6.1.87 ād guṇaḥ -- inside the heading, and its condition is the
    -- inherited `aci`, not iK: the narrowing is done by 6.1.88 (apavāda) and
    -- 6.1.101 (para), which is where it belongs.
  , su [6,1,87] "ād guṇaḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,87] i (j - i + 1) (guna t)
          ("a + aC " ++ t ++ " -> guṇa " ++ concat [ c | A.P c <- guna t ])
      | s `elem` ["a","ā"], Just (j, t) <- [nextPhIn ctx xs i], aciIn ctx t ]))

    -- 6.1.88 vṛddhir eci -- APAVĀDA to 6.1.87.  Earlier in the text than
    -- 6.1.101 and it still wins over the utsarga, because apavāda outranks
    -- para: the whole point of ranked metarules.
  , su [6,1,88] "vṛddhir eci" [[6,1,87]] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,88] i (j - i + 1) [A.P (vrddhi t)]
          ("a + eC " ++ t ++ " -> vṛddhi " ++ vrddhi t)
      | s `elem` ["a","ā"], Just (j, t) <- [nextPhIn ctx xs i], t `elem` eC ]))

    -- 6.1.101 akaḥ savarṇe dīrghaḥ -- later than 6.1.77 and 6.1.87, so 1.4.2
    -- gives it the site: dadhi+indra -> dadhīndra, not *dadhyindra.
  , su [6,1,101] "akaḥ savarṇe dīrghaḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,101] i (j - i + 1) [A.P (dirgha s)]
          (s ++ " + savarṇa " ++ t ++ " -> dīrgha " ++ dirgha s)
      | s `elem` aK, Just (j, t) <- [nextPhIn ctx xs i], aciIn ctx t
      , A.savarna s t ]))

    -- 6.1.109 eṅaḥ padāntād ati -- later than 6.1.78; states its own `ati`,
    -- at which the anuvṛtti of `aci` stops.
  , su [6,1,109] "eṅaḥ padāntād ati" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [6,1,109] i (j - i + 1) [A.P s, A.Avagraha]
          ("pada-final " ++ s ++ " + a -> " ++ s ++ " (a elided, avagraha)")
      | s `elem` eN, atPadanta xs i
      , Just (j, t) <- [nextPhIn ctx xs i], t == "a" ]))

    ------------------------------------------------------------------
    -- THE TRIPĀDĪ.  8.2.1 pūrvatrāsiddham: stratum 1.
    ------------------------------------------------------------------

    -- 8.2.30 coḥ kuḥ -- two words, "of cU, kU".  Where is `padasya`, stated
    -- at 8.1.16 and running to 8.3.54.
  , su [8,2,30] "coḥ kuḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [8,2,30] i 1 [A.P (ku s)]
          ("cU " ++ s ++ " -> kU " ++ ku s ++ " at pada-end")
      | s `elem` ["c","ch","j","jh","ñ"], padantaIn ctx xs i ]))

  , su [8,2,39] "jhalāṃ jaśo 'nte" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [8,2,39] i 1 [A.P (jas s)]
          ("jhaL " ++ s ++ " -> jaŚ " ++ jas s ++ " at pada-end")
      | s `elem` jhaL, jas s /= s, padantaIn ctx xs i ]))

  , su [8,2,66] "sasajuṣo ruḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [8,2,66] i 1 [A.P "r"] "pada-final s -> ru"
      | s == "s", padantaIn ctx xs i ]))

  , su [8,3,15] "kharavasānayor visarjanīyaḥ" [] True (\ctx xs -> scan xs (\i s ->
      [ Karya [8,3,15] i 1 [A.P "ḥ"] "r -> visarga (before khaR, or in pause)"
      | s == "r", padantaIn ctx xs i
      , case nextPh xs i of
          Nothing     -> True
          Just (_, t) -> t `elem` khaR ]))

  , su [8,4,40] "stoḥ ścunā ścuḥ" [] True (\_ xs -> concat
      [ r
      | (i, A.P s) <- zip [0 ..] xs
      , Just (j, t) <- [nextPh xs i]
      , let r | s `elem` sTu && t `elem` sCu =
                  [ Karya [8,4,40] i (j - i) [A.P (scuOf s)]
                      ("stu " ++ s ++ " -> ścu " ++ scuOf s ++ " before " ++ t) ]
              | s `elem` sCu && t `elem` sTu =
                  [ Karya [8,4,40] j 1 [A.P (scuOf t)]
                      ("stu " ++ t ++ " -> ścu " ++ scuOf t ++ " after " ++ s) ]
              | otherwise = []
      , not (null r) ])

  , su [8,4,41] "ṣṭunā ṣṭuḥ" [] True (\_ xs -> concat
      [ r
      | (i, A.P s) <- zip [0 ..] xs
      , Just (j, t) <- [nextPh xs i]
      , let r | s `elem` sTu && t `elem` sTuR =
                  [ Karya [8,4,41] i (j - i) [A.P (stuRetroOf s)]
                      ("stu " ++ s ++ " -> ṣṭu " ++ stuRetroOf s ++ " before " ++ t) ]
              | s `elem` sTuR && t `elem` sTu =
                  [ Karya [8,4,41] j 1 [A.P (stuRetroOf t)]
                      ("stu " ++ t ++ " -> ṣṭu " ++ stuRetroOf t ++ " after " ++ s) ]
              | otherwise = []
      , not (null r) ])

  , su [8,4,53] "jhalāṃ jaś jhaśi" [] True (\_ xs -> scan xs (\i s ->
      [ Karya [8,4,53] i (j - i) [A.P (jas s)]
          ("jhaL " ++ s ++ " -> jaŚ " ++ jas s ++ " before jhaŚ " ++ t)
      | s `elem` jhaL, jas s /= s
      , Just (j, t) <- [nextPh xs i], t `elem` jhaS ]))

  , su [8,4,55] "khari ca" [] True (\_ xs -> scan xs (\i s ->
      [ Karya [8,4,55] i (j - i) [A.P (car s)]
          ("jhaL " ++ s ++ " -> caR " ++ car s ++ " before khaR " ++ t)
      | s `elem` jhaL, car s /= s
      , Just (j, t) <- [nextPh xs i], t `elem` khaR ]))

  , su [8,4,56] "vāvasāne" [] True (\_ xs -> scan xs (\i s ->
      [ Karya [8,4,56] i 1 [A.P (car s)]
          ("jhaL " ++ s ++ " -> caR " ++ car s ++ " in pause")
      | s `elem` jhaL, car s /= s, atAvasana xs i ]))
  ]

------------------------------------------------------------------------
-- THE GRAMMAR
------------------------------------------------------------------------

-- 1.1.51 `ur aṇ raparaḥ`: the r/l that follows the guṇa substitute of ṛ/ḷ is
-- added BY THAT PARIBHĀṢĀ and is not part of the substitute, so 6.1.84's
-- "one for two" is satisfied although two items appear.
rapara :: Karya I -> Int
rapara k
  | kySthana k == [6,1,87]
  , (A.P "a" : rest) <- kyAdesa k
  , [A.P y] <- rest, y `elem` ["r","l"] = 1
  | otherwise = 0

samskrtam :: Vyakarana A.Item String String
samskrtam = Vyakarana
  { vyAmnaya   = amnaya
  , vyPrcchana = prcchana
  , vySasanani = sutrani
  , vyAdhikara =
      [ ([6,1,72], [6,1,157], "saṃhitāyām")
      , ([6,1,77], [6,1,108], "aci")               -- anuvṛtti, nivṛtti at 6.1.109
      , ([6,1,84], [6,1,111], "ekaḥ pūrvaparayoḥ")
      , ([8,1,16], [8,3,54],  "padasya")
      ]
  , vyNiyama =
      [ ("ekaḥ pūrvaparayoḥ"
        , \k -> length [ () | A.P _ <- kyAdesa k ] - rapara k == 1) ]
  , vyKaksya = \r -> case r of
      (8 : p : _) | p >= 2 -> 1      -- 8.2.1 pūrvatrāsiddham: the tripādī
      _                    -> 0
  , vyParibhasa = paribhasenduSekhara38
  , vyApavada   = \_ _ -> False      -- only the declared ones (6.1.88 -> 6.1.87)
  , vyAntaranga = \_ _ -> Nothing    -- ABSTAIN: no nimitta depth is defined for
                                     -- phoneme sites in this sample
  , vyParatva   = True               -- a sūtra's number is authored: 1.4.2 applies
  , vyOverlap   = samsarga
  , vySthanivat = id                 -- see the note below
  , vyAdesaSamjna = \_ new -> new    -- ditto
  , vyIt        = const False        -- no affix it-marker is in this sample
  , vySame      = (==)
  }

-- STHĀNIVADBHĀVA IS ABSTAINED FROM HERE, and saying so is the point.
-- 1.1.56 `sthānivad ādeśo 'nalvidhau` needs a substitute to carry the
-- DESIGNATIONS of what it replaced, and `Astadhyayi.Item` carries a phoneme
-- and nothing else -- there is no saṃjñā on it to transport.  So both hooks
-- are identities and every rule here is declared `alvidhi` (form-inspecting),
-- which for phonological rules is true.  The device is exercised in the
-- second instantiation instead, where it decides an output.

derive :: String -> String
derive = A.render . rupa samskrtam 64 . A.parseInput

deriveTrace :: String -> ([Pada A.Item], Maybe Dosa, [A.Item])
deriveTrace = prasadhana samskrtam 64 . A.parseInput

corpus :: [String]
corpus =
  [ "dadhi + indra", "deva + indra", "mahā + indra", "su + ukta"
  , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
  , "te + api", "ne - ana", "ne + ana", "rāmas", "tat + ca", "tat + jalam"
  , "vāc", "deva . indra" ]

-- THE CROSS-CHECK.  Two engines, one rule set, form by form.
agreement :: [String]
agreement =
  [ w ++ ": core gives " ++ derive w ++ ", Astadhyayi.derive gives " ++ A.derive w
  | w <- corpus, derive w /= A.derive w ]

selfTest :: [String]
selfTest = concat
  [ agreement
  , chk "the ā́mnāya survives conversion"
      (length (varnah amnaya)) (length [ () | A.Snd _ <- A.varnasamamnaya ])
  -- THE AUDIT FOUND A SECOND NAMING DEVICE, which is what an audit is for.
  -- Nine of the twelve classes are śivasūtra intervals.  The other three are
  -- not, and they are not sloppiness: `stu`, `ścu`, `ṣṭu` are formed by the
  -- OTHER half of 1.1.69 `aṇudit savarṇasya cāpratyayaḥ` -- a sound cited
  -- with `u` as its it-marker denotes its savarṇas -- so `stu` is s plus tU,
  -- i.e. s plus every savarṇa of t.  Checked as generated, not asserted.
  , chk "the classes that are NOT intervals are exactly stu, ścu, ṣṭu"
      (lgUnnamed (laghava amnaya prcchana)) ["stu","ścu","ṣṭu"]
  , chk "and each of those three is s/ś/ṣ plus a u-dit varga, by 1.1.69"
      [ sTu, sCu, sTuR ]
      [ "s" : A.savarnasOf "t", "ś" : A.savarnasOf "c", "ṣ" : A.savarnasOf "ṭ" ]
  , chk "aC is named by the two symbols a and c"
      (take 1 (namesFor amnaya (A.pratyahara "a" "c"))) [("a","c",0)]
  , chk "6.1.84 governs 6.1.87/88/101/109"
      (map (elem "ekaḥ pūrvaparayoḥ" . adhikrta samskrtam)
           [[6,1,87],[6,1,88],[6,1,101],[6,1,109]]) [True,True,True,True]
  , chk "6.1.84 does NOT govern 6.1.77/78"
      (map (elem "ekaḥ pūrvaparayoḥ" . adhikrta samskrtam) [[6,1,77],[6,1,78]])
      [False,False]
  , chk "`aci` reaches 6.1.87 and 6.1.101, which do not state it"
      (map (elem "aci" . adhikrta samskrtam) [[6,1,87],[6,1,101]]) [True,True]
  , chk "`aci` has stopped by 6.1.109 (nivṛtti)"
      (elem "aci" (adhikrta samskrtam [6,1,109])) False
  , chk "no offer under 6.1.84 violates ekaḥ pūrvaparayoḥ"
      (adhikaraAudit samskrtam (map A.parseInput corpus)) []
  , chk "8.2.1: the tripādī is stratum 1 and nothing else is"
      (nub [ vyKaksya samskrtam (ssSthana s) | s <- sutrani
           , let (a : p : _) = ssSthana s, a == 8, p >= 2 ]) [1]
  , chk "1.4.2 decides dadhi + indra for 6.1.101 over 6.1.77"
      (decidedBy "dadhi + indra" [6,1,101] [6,1,77]) (Just "para")
  , chk "apavāda decides deva + aiśvarya for 6.1.88 over the utsarga 6.1.87"
      (decidedBy "deva + aiśvarya" [6,1,88] [6,1,87]) (Just "apavāda")
  , chk "1.4.2 decides te + api for 6.1.109 over 6.1.78"
      (decidedBy "te + api" [6,1,109] [6,1,78]) (Just "para")
  , chk "no derivation in the corpus ends in a written defect"
      [ w | w <- corpus, let (_, d, _) = deriveTrace w, maybe False (const True) d ] []
  , chk "6.1.72 saṃhitāyām is load-bearing: across a pause there is no sandhi"
      (derive "deva . indra") "deva indra"
  ]
  where
    chk nm got want | got == want = []
                    | otherwise   = [ nm ++ ": got " ++ show got
                                      ++ ", wanted " ++ show want ]
    decidedBy w win lost =
      case [ pdParibhasa p
           | let (steps, _, _) = deriveTrace w, p <- steps
           , pdSthana p == win, lost `elem` pdBeaten p ] of
        (b : _) -> Just b
        []      -> Nothing

report :: [String]
report =
  [ "THE AṢṬĀDHYĀYĪ RUN BY THE GENERAL CORE" , "" ]
  ++ laghavaReport (laghava amnaya prcchana)
  ++ [ "", "sūtras instantiated here: " ++ show (length sutrani)
          ++ " of ~3983 (recensions differ: 3959-3996)"
     , "", "derivations (core engine, then Astadhyayi.hs's own engine):" ]
  ++ [ "  " ++ pad 16 w ++ " -> " ++ pad 12 (derive w)
       ++ "  (Astadhyayi: " ++ A.derive w ++ ")" | w <- corpus ]
  where pad n s = s ++ replicate (max 0 (n - length s)) ' '
