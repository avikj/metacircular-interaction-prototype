-- Prakriyā -- the derivational device of the Aṣṭādhyāyī, factored so that a
-- second rule set can be run by it, with the Sanskrit rule set remaining the
-- first and primary instantiation.
--
-- SOURCE.  Pāṇini, *Aṣṭādhyāyī*, ~500 BCE.  Every parameter of the record
-- below is a device of that text and is named for it, with the sūtra given at
-- the field.  Kātyāyana's vārttikas (~250 BCE) and Patañjali's *Mahābhāṣya*
-- (~150 BCE) are where the paribhāṣās used here were argued; Nāgeśa Bhaṭṭa
-- collects them in the *Paribhāṣenduśekhara* (c. 1730), paribhāṣā 38 for the
-- strength order.  `machine/Astadhyayi.hs` is the running grammar this was
-- factored out of; `machine/Vipratisedha_...hs` had already lifted two of
-- these devices (metarule ranking, strata) and this file keeps its vocabulary
-- where it overlaps.
--
-- THE PŪRVAPAKṢA, ANSWERED BEFORE THE FIRST LINE OF CODE.
--
--   "Generalising is how a tradition gets mined.  You take the part that
--   converts -- the rewriting calculus -- discard the epistemology, and file
--   the remainder as a contribution to computer science.  A `Vyakarana`
--   record parameterised over an alphabet IS the Aṣṭādhyāyī with the Sanskrit
--   removed, which is the exact move that turned the cakravāla into 'Pell's
--   equation'."
--
-- The answer is not that the objection is wrong.  It is that the objection
-- names a REAL failure mode with a checkable signature, and the signature is
-- checked here rather than disclaimed:
--
--   1. The mined artefact REPLACES its source.  This one cannot: the Sanskrit
--      instantiation is the primary one, it is checked against
--      `Astadhyayi.derive` form by form (PrakriyaSamskrta), and if the core
--      ever fails to reproduce the grammar the core is what is wrong.
--   2. The mined artefact reports no loss.  This one reports its loss, in
--      `residual` below, as a list of devices of the Aṣṭādhyāyī that the
--      parameterisation provably does not carry.  A factoring that reports no
--      residual is a factoring nobody checked.
--   3. The mined artefact renames.  A rename is detectable: it runs exactly
--      one system.  This one runs a second, unrelated system
--      (EnglishPluralAllomorphy) whose rules were not written by Pāṇini and
--      whose conflicts the same four named metarules decide.
--
-- What is NOT claimed: that the device is culturally neutral, that Sanskrit is
-- an "instance" of something more general, or that the general core is the
-- interesting object.  The grammar is the interesting object.  This is a
-- statement about what MACHINERY it contains, made by exhibiting the machinery
-- running something else -- which is evidence about the machinery, not a
-- reassignment of the credit.
--
-- WHAT MODERN REWRITING THEORY HAS AND HAS NOT.  Confluence, termination,
-- critical pairs and Knuth-Bendix completion (1970) all address the SAME
-- object.  Two devices below have no counterpart there and are the reason
-- this file exists:
--
--   * conflict resolved by a NAMED metarule with the decision RECORDED
--     (`Paribhasa`, `pdParibhasa`, `pdMula`) -- not by list order, not by an
--     arbitrary choice inside a completion procedure, and where no metarule
--     decides the derivation STOPS and writes a defect (`Avaktavya`) rather
--     than picking one;
--   * the DESIGNATION / FORM distinction, 1.1.56 `sthānivad ādeśo 'nalvidhau`
--     -- a substitute counts as the original it replaced for every rule EXCEPT
--     one conditioned on form.  A term rewriting system has no notion of a
--     redex that is, for some rules, still its predecessor.
--
-- THE RESIDUAL, in the header because it is not an appendix.  What this
-- parameterisation LOSES relative to the Aṣṭādhyāyī, stated in full in
-- `residual` at the foot of the file and summarised here:
--
--   1. the metarules are a PARAMETER here and are INFERRED there, from the
--      wording of sūtras, by jñāpaka.  Largest loss, and structural.
--   2. anuvṛtti is reduced to a scope table; a sūtra without its inherited
--      words is not a complete statement, and every `Sasana` here is a total
--      function.
--   3. the order is audited, never constructed: intervalhood is checked,
--      minimality is not, and the two devices that FORCE intervalhood are
--      admitted and never generated.
--   4. sthānivadbhāva is one boolean per rule; 1.1.57 and the contested
--      classification of al-vidhi are gone.
--   5. no semantics.  The kāraka layer -- the half that computes FROM meaning
--      -- is left behind, which is the mining move, performed here and named.
--   6. a sūtra is a text under commentary and can be argued with; a closure
--      cannot.
--   7. the carrier of the śivasūtras is motivated (1.1.9 ties the order to
--      place and effort); `Amnaya` is any finite list.
--
-- NO FLOATING POINT, no measurement.  Every claim is a finite check.
module Prakriya_TheGeneralDerivationCoreFactoredFromTheAstadhyayi
  ( -- 1.  ALPHABET AND MARKER DISCIPLINE (the śivasūtra device, generalised)
    Slot(..)
  , Amnaya
  , varnah
  , anubandhah
  , antarala
  , antaralaSet
  , spanOf
  , Nama
  , namesFor
  , Laghava(..)
  , laghava
  , laghavaReport
    -- 2.  RULES
  , Sthana
  , showSthana
  , Karya(..)
  , Sasana(..)
  , samsarga
    -- 3.  THE GRAMMAR
  , Vyakarana(..)
  , adhikrta
  , adhikaraAudit
  , itAudit
    -- 4.  METARULES
  , Nirvacana(..)
  , Paribhasa(..)
  , Nirnaya(..)
  , Dosa(..)
  , showDosa
  , apavadaP
  , antarangaP
  , nityaP
  , paraP
  , paribhasenduSekhara38
  , nirnaya
    -- 5.  THE ENGINE
  , Pada(..)
  , offersOf
  , drsti
  , prayoga
  , ekapada
  , prasadhana
  , rupa
    -- 6.  WHAT THE ABSTRACTION LOSES
  , residual
  ) where

import Data.List (nub, sortOn, intercalate)

------------------------------------------------------------------------
-- 1.  THE ALPHABET AND ITS MARKERS
--
-- The śivasūtras lay every phoneme in ONE linear order punctuated by
-- markers, and a class is the INTERVAL from a sound to a marker: two symbols
-- name it.  Nothing in that device is about sound.  What it needs is (i) a
-- finite carrier, (ii) a family of classes the rules actually query, and
-- (iii) an order in which every member of that family is an interval.
--
-- A marker is a BOUNDARY, never a member, and an interval may straddle
-- markers other than its own -- that is the second of the two devices (the
-- first is repeating a sound: `h` occurs twice in the śivasūtras) by which
-- Pāṇini gets every needed class to be an interval.
------------------------------------------------------------------------

data Slot a m = Varna a | Anubandha m
  deriving (Eq, Show)

type Amnaya a m = [Slot a m]

varnah :: Amnaya a m -> [a]
varnah am = [ a | Varna a <- am ]

anubandhah :: Amnaya a m -> [m]
anubandhah am = [ m | Anubandha m <- am ]

-- The interval, with the occurrence index the tradition needs when a marker
-- letter is reused (only `ṇ` is, in the śivasūtras: sūtras 1 and 6).
antarala :: (Eq a, Eq m) => Amnaya a m -> a -> m -> Int -> [a]
antarala am s mk k = go k (dropWhile (/= Varna s) am)
  where
    go _ [] = []
    go n (Anubandha x : r)
      | x == mk   = if n <= (0 :: Int) then [] else go (n - 1) r
      | otherwise = go n r
    go n (Varna x : r) = x : go n r

antaralaSet :: (Eq a, Eq m) => Amnaya a m -> a -> m -> Int -> [a]
antaralaSet am s mk k = nub (antarala am s mk k)

-- What the interval covers before the markers are dropped, so that the
-- straddling can be shown rather than asserted.
spanOf :: (Eq a, Eq m) => Amnaya a m -> a -> m -> Int -> Amnaya a m
spanOf am s mk k = go k (dropWhile (/= Varna s) am)
  where
    go _ [] = []
    go n (Anubandha x : r)
      | x == mk   = if n <= (0 :: Int) then [] else Anubandha x : go (n - 1) r
      | otherwise = Anubandha x : go n r
    go n (v : r) = v : go n r

type Nama a m = (a, m, Int)

-- Every two-symbol name (plus occurrence index) that denotes exactly `cls`.
namesFor :: (Eq a, Eq m) => Amnaya a m -> [a] -> [Nama a m]
namesFor am cls =
  [ (s, mk, k)
  | s  <- nub (varnah am)
  , mk <- nub (anubandhah am)
  , k  <- [0 .. 2]
  , let got = antaralaSet am s mk k
  , not (null got)
  , all (`elem` cls) got, all (`elem` got) cls ]

-- LĀGHAVA -- economy, the criterion the grammarians themselves state
-- (`ardhamātrālāghavena putrotsavaṃ manyante vaiyākaraṇāḥ`: a grammarian
-- rejoices at saving half a mora as at the birth of a son -- Mahābhāṣya
-- tradition).  This is the audit of an order against the query family:
-- which classes it names, which it fails to name, and the hard bound on how
-- many classes ANY order can name at all.
data Laghava a m = Laghava
  { lgNamed    :: [(String, Nama a m)]
  , lgUnnamed  :: [String]
  , lgBound    :: Int        -- upper bound on distinct classes an order can name
  , lgUniverse :: Integer    -- subsets of the carrier
  }

laghava :: (Eq a, Eq m) => Amnaya a m -> [(String, [a])] -> Laghava a m
laghava am fam = Laghava named unnamed bound universe
  where
    named    = [ (nm, n) | (nm, cls) <- fam, (n : _) <- [namesFor am cls] ]
    unnamed  = [ nm | (nm, cls) <- fam, null (namesFor am cls) ]
    bound    = length (varnah am) * length [ () | Anubandha _ <- am ]
    universe = 2 ^ length (nub (varnah am))

laghavaReport :: (Show a, Show m) => Laghava a m -> [String]
laghavaReport lg =
  [ "classes queried by the rules:   " ++ show (length (lgNamed lg) + length (lgUnnamed lg))
  , "  named as an interval:         " ++ show (length (lgNamed lg))
  , "  NOT nameable in this order:   " ++ show (length (lgUnnamed lg))
      ++ (if null (lgUnnamed lg) then "" else "  " ++ show (lgUnnamed lg))
  , "distinct classes ANY order of this ā́mnāya can name, at most:  "
      ++ show (lgBound lg)
  , "subsets of the carrier:                                       "
      ++ show (lgUniverse lg)
  , "-- so the order is fitted to the query family and to nothing else;"
  , "   a class outside the family is named by a list (gaṇapāṭha), not by an"
  , "   interval, and Pāṇini keeps such a list for exactly that reason."
  ]

------------------------------------------------------------------------
-- 2.  RULES
--
-- `Sthana` is a rule's ADDRESS and it is semantic, not a label: 1.4.2
-- `vipratiṣedhe paraṃ kāryam` decides a conflict by it.  A list index is not
-- an address (see `vyParatva`).
------------------------------------------------------------------------

type Sthana = [Int]

showSthana :: Sthana -> String
showSthana = intercalate "." . map show

-- One rule's offer to act: where, how wide, what goes in, and what it did in
-- words.  The substitute is given as items, not as a whole object, because
-- 1.1.56 has to be able to transport designations from the sthānin to the
-- ādeśa and cannot do that through an opaque result.
data Karya u = Karya
  { kySthana :: Sthana
  , kyPos    :: Int
  , kyLen    :: Int
  , kyAdesa  :: [u]
  , kyNote   :: String
  }

-- A rule.  `ssFires` receives the words GOVERNING it (anuvṛtti/adhikāra,
-- section 3) and the object as that rule is entitled to see it (1.1.56,
-- section 5) -- so a rule is not locally readable, which is the property the
-- text has.
data Sasana u = Sasana
  { ssSthana    :: Sthana
  , ssName      :: String
  , ssApavadaTo :: [Sthana]   -- utsargas this rule is declared an exception to
  , ssAlvidhi   :: Bool       -- 1.1.56 `analvidhau`: does it inspect FORM?
  , ssFires     :: [String] -> [u] -> [Karya u]
  }

-- Do two offers contend for the same site?  A zero-width offer still
-- contends with what stands at its position.
samsarga :: Karya u -> Karya u -> Bool
samsarga a b =
  kyPos a < kyPos b + max 1 (kyLen b) && kyPos b < kyPos a + max 1 (kyLen a)

------------------------------------------------------------------------
-- 3.  THE GRAMMAR
------------------------------------------------------------------------

data Vyakarana u a m = Vyakarana
  { vyAmnaya    :: Amnaya a m
    -- the classes the rule set actually queries, for the lāghava audit
  , vyPrcchana  :: [(String, [a])]
  , vySasanani  :: [Sasana u]
    -- ADHIKĀRA / ANUVṚTTI (e.g. 6.1.72 `saṃhitāyām` over 6.1.72-157): a word
    -- stated once and governing a block, resolved at the point of
    -- APPLICATION, so a rule's content is non-locally encoded.
  , vyAdhikara  :: [(Sthana, Sthana, String)]
    -- what a heading REQUIRES of every offer made under it, so that a scope
    -- is a checkable property of the rewrites and not an annotation.  6.1.84
    -- `ekaḥ pūrvaparayoḥ`: one substitute for two.
  , vyNiyama    :: [(String, Karya u -> Bool)]
    -- 8.2.1 `pūrvatrāsiddham` generalised: stratum 0 runs to a fixpoint with
    -- all its rules mutually visible; strata 1..n run ONCE each, in address
    -- order, and no earlier stratum ever sees their output.
  , vyKaksya    :: Sthana -> Int
    -- the metarules, in strength order, as a PARAMETER
  , vyParibhasa :: [Paribhasa u]
  , vyApavada   :: Sthana -> Sthana -> Bool         -- computed exceptions
  , vyAntaranga :: Karya u -> Karya u -> Maybe Bool -- Nothing = ABSTAIN
  , vyParatva   :: Bool                             -- is the address authored?
  , vyOverlap   :: Karya u -> Karya u -> Bool
    -- 1.1.56 `sthānivad ādeśo 'nalvidhau`: how a substitute reads as its
    -- sthānin.  MUST be length-preserving on the item list.
  , vySthanivat :: u -> u
    -- the positive half of 1.1.56: designations carried onto the substitute.
  , vyAdesaSamjna :: [u] -> [u] -> [u]
    -- IT-MARKERS IN THE OBJECT (1.3.2-1.3.8 marked, 1.3.9 `tasya lopaḥ`
    -- deleted).  A marker conditions rules and must not survive the
    -- derivation; `itAudit` checks that it does not.
  , vyIt        :: u -> Bool
  , vySame      :: [u] -> [u] -> Bool
  }

adhikrta :: Vyakarana u a m -> Sthana -> [String]
adhikrta g r = [ w | (lo, hi, w) <- vyAdhikara g, lo <= r, r <= hi ]

-- A heading is load-bearing iff every offer under it satisfies what the
-- heading says.  Returns the violations.
adhikaraAudit :: Vyakarana u a m -> [[u]] -> [String]
adhikaraAudit g probes =
  [ showSthana (ssSthana s) ++ " offers under the heading \"" ++ w
      ++ "\" something the heading forbids: " ++ kyNote k
  | (w, req) <- vyNiyama g
  , s <- vySasanani g
  , w `elem` adhikrta g (ssSthana s)
  , xs <- probes
  , k <- offersOf g s xs
  , not (req k) ]

-- 1.3.9 `tasya lopaḥ`: a marker conditions and is then deleted.  Any marker
-- reaching the output is a leak.
itAudit :: Vyakarana u a m -> [u] -> [String]
itAudit g out
  | any (vyIt g) out = ["an it-marker survived into the derived form"]
  | otherwise        = []

------------------------------------------------------------------------
-- 4.  THE METARULES
--
-- Nāgeśa Bhaṭṭa, *Paribhāṣenduśekhara* (c. 1730), paribhāṣā 38:
--   पूर्वपरनित्यान्तरङ्गापवादानामुत्तरोत्तरं बलीयः
--   "of pūrva, para, nitya, antaraṅga, apavāda -- each later is stronger."
-- So the order tried is apavāda, antaraṅga, nitya, para; pūrva -- the earlier
-- rule -- is weakest and decides nothing here.  The metarules are a
-- PARAMETER: a domain may supply fewer, or its own, and what decided is
-- recorded in the trace either way.
------------------------------------------------------------------------

data Nirvacana u = Nirvacana
  { nvApavada   :: Sthana -> Sthana -> Bool
  , nvAntaranga :: Karya u -> Karya u -> Maybe Bool
  , nvNitya     :: Karya u -> Karya u -> Bool
  , nvParatva   :: Bool
  }

data Paribhasa u = Paribhasa
  { pbName   :: String
  , pbMula   :: String     -- where it is stated.  An unsourced metarule is a
                           -- decision by list order wearing a better coat.
  , pbNirnaya :: Nirvacana u -> [Karya u] -> Either String (Karya u)
  }

uniqueWinner :: String -> [Karya u] -> Either String (Karya u)
uniqueWinner _   [w] = Right w
uniqueWinner why _   = Left why

apavadaP :: Paribhasa u
apavadaP = Paribhasa "apavāda"
  ("utsarga/apavāda: the specific blocks the general REGARDLESS of position. "
   ++ "Aṣṭādhyāyī, passim; Paribhāṣenduśekhara 38 ranks it strongest. "
   ++ "Restated in phonology as the Elsewhere Condition, Kiparsky 1973, who "
   ++ "took it from Pāṇini and said so.")
  (\nv ks -> uniqueWinner
      "no candidate is an apavāda to every other candidate"
      [ x | x <- ks
          , all (\y -> kySthana y == kySthana x
                       || nvApavada nv (kySthana x) (kySthana y)) ks ])

antarangaP :: Paribhasa u
antarangaP = Paribhasa "antaraṅga"
  ("antaraṅgaṃ bahiraṅgāt: the rule whose conditioning causes lie further "
   ++ "inside wins.  Depth is a fact about the objects, so the domain "
   ++ "supplies it and MAY ABSTAIN; Nothing is not False.")
  (\nv ks -> case [ x | x <- ks
                      , all (\y -> kySthana y == kySthana x
                                   || nvAntaranga nv x y == Just True) ks ] of
               [w] -> Right w
               _   -> Left (if any (\x -> any (\y -> kySthana y /= kySthana x
                                                && nvAntaranga nv x y == Nothing) ks) ks
                              then "the domain abstains: no nimitta depth is defined here"
                              else "no candidate is antaraṅga to all the others"))

nityaP :: Paribhasa u
nityaP = Paribhasa "nitya"
  ("kṛtākṛtaprasaṅgi nityam: nitya is what has its occasion whether or not "
   ++ "the other has been performed.  Not a gloss -- an executable test, run "
   ++ "by applying the other candidate and asking whether this one still offers.")
  (\nv ks -> uniqueWinner
      "kṛtākṛtaprasaṅga is mutual or empty; nitya decides nothing here"
      [ x | x <- ks
          , all (\y -> kySthana y == kySthana x || nvNitya nv x y) ks
          , not (all (\y -> kySthana y == kySthana x || nvNitya nv y x) ks
                 && length ks > 1) ])

paraP :: Paribhasa u
paraP = Paribhasa "para"
  "1.4.2 विप्रतिषेधे परं कार्यम् `vipratiṣedhe paraṃ kāryam`: in conflict, the later."
  (\nv ks ->
     let top = maximum (map kySthana ks)
     in if not (nvParatva nv)
          then Left ("the domain declares its rule order unauthored: a list "
                     ++ "index is not an address, so 1.4.2 has nothing to compare")
          else case [ x | x <- ks, kySthana x == top ] of
                 [w] -> Right w
                 _   -> Left ("the contending rules share the address "
                              ++ showSthana top ++ "; their list order carries no fact"))

paribhasenduSekhara38 :: [Paribhasa u]
paribhasenduSekhara38 = [apavadaP, antarangaP, nityaP, paraP]

-- A written defect: the fourth position, `avaktavyam`.  Not a failure code --
-- a record, naming every metarule that abstained and why.
data Dosa = Dosa
  { doSite       :: Int
  , doCandidates :: [(Sthana, String, String)]
  , doTried      :: [(String, String)]
  }

showDosa :: Dosa -> [String]
showDosa d =
  [ "DEFECT -- vipratiṣedha undecided at site " ++ show (doSite d) ++ "."
  , "  Two or more rules contend and no metarule decides.  Nothing was applied."
  , "  candidates:" ] ++
  [ "    " ++ showSthana r ++ "  " ++ nm ++ "  -- " ++ note
  | (r, nm, note) <- doCandidates d ] ++
  [ "  metarules tried, strongest first:" ] ++
  [ "    " ++ b ++ " -- " ++ why | (b, why) <- doTried d ]

data Nirnaya u
  = Nirnita (Karya u) [Sthana] String String   -- winner, beaten, metarule, source
  | Avaktavya Dosa

nirnaya :: Vyakarana u a m -> [u] -> [Karya u] -> Nirnaya u
nirnaya _ _ [k] = Nirnita k [] "eka" "sole candidate; no conflict arose"
nirnaya g xs ks = go (vyParibhasa g) []
  where
    nv = Nirvacana
      { nvApavada = \a b -> vyApavada g a b
                            || or [ b `elem` ssApavadaTo s
                                  | s <- vySasanani g, ssSthana s == a ]
      , nvAntaranga = vyAntaranga g
      , nvNitya = \x y ->
          let ys = prayoga g xs y
          in or [ vyOverlap g z x
                | s <- vySasanani g, ssSthana s == kySthana x
                , z <- offersOf g s ys ]
      , nvParatva = vyParatva g
      }
    nameOf r = head ([ ssName s | s <- vySasanani g, ssSthana s == r ] ++ ["?"])
    go [] tried = Avaktavya Dosa
      { doSite = minimum (map kyPos ks)
      , doCandidates = [ (kySthana k, nameOf (kySthana k), kyNote k) | k <- ks ]
      , doTried = reverse tried }
    go (p : rest) tried = case pbNirnaya p nv ks of
      Right w  -> Nirnita w [ kySthana y | y <- ks, kySthana y /= kySthana w ]
                           (pbName p) (pbMula p)
      Left why -> go rest ((pbName p, why) : tried)

------------------------------------------------------------------------
-- 5.  THE ENGINE
------------------------------------------------------------------------

data Pada u = Pada
  { pdSthana    :: Sthana
  , pdName      :: String
  , pdNote      :: String
  , pdBeaten    :: [Sthana]
  , pdParibhasa :: String
  , pdMula      :: String
  , pdAdhikara  :: [String]
  , pdBefore    :: [u]
  , pdAfter     :: [u]
  }

-- 1.1.56, negatively: a rule conditioned on FORM sees the form; every other
-- rule sees the substitute AS its sthānin.
drsti :: Vyakarana u a m -> Sasana u -> [u] -> [u]
drsti g s xs = if ssAlvidhi s then xs else map (vySthanivat g) xs

offersOf :: Vyakarana u a m -> Sasana u -> [u] -> [Karya u]
offersOf g s xs = ssFires s (adhikrta g (ssSthana s)) (drsti g s xs)

-- 1.1.56, positively: the substitute takes the designations of what it
-- replaced.
prayoga :: Vyakarana u a m -> [u] -> Karya u -> [u]
prayoga g xs k =
  take (kyPos k) xs
    ++ vyAdesaSamjna g (take (kyLen k) (drop (kyPos k) xs)) (kyAdesa k)
    ++ drop (kyPos k + kyLen k) xs

-- One step over a block: every offer, leftmost contended site, resolved.
ekapada :: Vyakarana u a m -> [Sasana u] -> [u] -> Maybe (Nirnaya u)
ekapada g block xs =
  case concatMap (\s -> offersOf g s xs) block of
    []     -> Nothing
    offers ->
      let leftmost = minimum (map kyPos offers)
          anchor   = head [ k | k <- offers, kyPos k == leftmost ]
          here     = [ k | k <- offers, vyOverlap g k anchor ]
      in Just (nirnaya g xs (sortOn kySthana here))

prasadhana :: Vyakarana u a m -> Int -> [u] -> ([Pada u], Maybe Dosa, [u])
prasadhana g fuel start = phase0 fuel start []
  where
    strata = nub (sortOn id (map (vyKaksya g . ssSthana) (vySasanani g)))
    block k = sortOn ssSthana [ s | s <- vySasanani g, vyKaksya g (ssSthana s) == k ]
    nameOf r = head ([ ssName s | s <- vySasanani g, ssSthana s == r ] ++ ["?"])

    step xs (Nirnita w lost by src) =
      let ys = prayoga g xs w
      in (ys, Pada (kySthana w) (nameOf (kySthana w)) (kyNote w) lost by src
                   (adhikrta g (kySthana w)) xs ys)

    -- stratum 0: mutually siddha, to a fixpoint
    phase0 0 xs acc = later (drop 1 strata) xs (reverse acc)
    phase0 k xs acc =
      case ekapada g (block 0) xs of
        Nothing            -> later (drop 1 strata) xs (reverse acc)
        Just (Avaktavya d) -> (reverse acc, Just d, xs)
        Just n ->
          let (ys, p) = step xs n
          in if vySame g ys xs
               then later (drop 1 strata) xs (reverse acc)
               else phase0 (k - 1) ys (p : acc)

    -- strata 1..n: 8.2.1.  Each rule once, in address order.  A rule is
    -- siddha to ITSELF and may saturate on its own output; it never sees a
    -- later rule and is never revisited.
    later [] xs acc = (acc, Nothing, xs)
    later (k : ks) xs acc = go (block k) xs acc
      where
        go [] ys acc' = later ks ys acc'
        go (s : ss) ys acc' =
          case saturate (16 :: Int) s ys acc' of
            Left d           -> (acc', Just d, ys)
            Right (zs, acc'') -> go ss zs acc''
        saturate 0 _ ys acc' = Right (ys, acc')
        saturate n s ys acc' =
          case offersOf g s ys of
            []  -> Right (ys, acc')
            off -> case nirnaya g ys (sortOn kyPos off) of
                     Avaktavya d -> Left d
                     n' -> let (zs, p) = step ys n'
                           in if vySame g zs ys then Right (ys, acc')
                              else saturate (n - 1) s zs (acc' ++ [p])

rupa :: Vyakarana u a m -> Int -> [u] -> [u]
rupa g fuel xs = let (_, _, out) = prasadhana g fuel xs in out

------------------------------------------------------------------------
-- 6.  THE RESIDUAL -- what this abstraction LOSES relative to the
--     Aṣṭādhyāyī.  Every abstraction has one; a factoring that reports none
--     is a factoring nobody checked.  This is the whole difference between
--     the file and mining.
------------------------------------------------------------------------

residual :: [String]
residual =
  [ "1.  THE METARULES ARE A PARAMETER HERE AND ARE INFERRED THERE.  Pāṇini's"
  , "    paribhāṣās are not given with the rule set: the commentators DERIVE"
  , "    them from the wording of individual sūtras by jñāpaka -- an inference"
  , "    from a feature of a sūtra that would otherwise be pointless to the"
  , "    general principle that makes it purposeful.  `vyParibhasa` takes a"
  , "    list.  No parameterisation over a fixed list can derive its own"
  , "    metarules from its own rules, and that derivation is a live part of"
  , "    the system (Kātyāyana, Patañjali, and the whole paribhāṣā literature"
  , "    down to Nāgeśa 1730).  This is the largest loss and it is structural."
  , ""
  , "2.  ANUVṚTTI IS REDUCED TO A SCOPE TABLE.  `vyAdhikara` maps an address"
  , "    range to a word.  In the text a word runs forward from the sūtra that"
  , "    states it until cancelled (nivṛtti) or specialised, the continuation"
  , "    is written NOWHERE, it may be partial (ekadeśānuvṛtti), and it may"
  , "    leap (maṇḍūkapluti).  Above all: a sūtra WITHOUT its inherited words"
  , "    is not a complete statement at all -- `coḥ kuḥ` is two words -- while"
  , "    every `Sasana` here is a total function on the object.  The core"
  , "    carries the EFFECT of anuvṛtti and not its form."
  , ""
  , "3.  THE ORDER IS AUDITED, NEVER CONSTRUCTED.  `laghava` checks that each"
  , "    queried class is an interval and gives the hard bound on how many"
  , "    classes any order can name.  It does not construct an order, and it"
  , "    does not certify minimality: the two devices by which Pāṇini FORCES"
  , "    intervalhood -- repeating a sound (h twice) and reusing a marker (ṇ"
  , "    twice) -- are admitted by the encoding and never generated by it."
  , ""
  , "4.  STHĀNIVADBHĀVA IS ONE BOOLEAN PER RULE.  1.1.56 `sthānivad ādeśo"
  , "    'nalvidhau` is qualified by 1.1.57 `acaḥ parasmin pūrvavidhau` and by"
  , "    a contested classification of which operations count as al-vidhi."
  , "    `ssAlvidhi` is a bit.  The dispute is the content and it is gone."
  , ""
  , "5.  NO SEMANTICS.  The Aṣṭādhyāyī computes FROM MEANING: a scene of"
  , "    kārakas (2.3.1 anabhihite and what stands under it) is the input, and"
  , "    the form is downstream.  This core is form-to-form only.  Taking the"
  , "    rewriting calculus and leaving the kāraka layer behind is precisely"
  , "    the mining move, performed here, and named rather than hidden."
  , ""
  , "6.  A SŪTRA IS A TEXT UNDER COMMENTARY.  It is recited, it is corrected"
  , "    by vārttikas, and its wording is evidence.  `Sasana` is a closure."
  , "    Nothing in this core can be argued with."
  , ""
  , "7.  THE ŚIVASŪTRAS' CARRIER IS NOT ARBITRARY.  The order is over Sanskrit"
  , "    phonemes and is defensible on articulatory grounds (1.1.9 savarṇa"
  , "    ties place and effort to the ordering).  `Amnaya` is any finite list."
  , "    A second instantiation therefore shows the DEVICE transfers; it shows"
  , "    nothing about whether an order for that carrier is motivated, and the"
  , "    toy in EnglishPluralAllomorphy declares its own order unmotivated."
  ]
