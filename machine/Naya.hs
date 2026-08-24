-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Naya.hs -- DECIDE whether a set of standpoints may be collapsed to one.
--
-- Answers YES or NO on real input, and when the answer is NO it prints
-- what the collapse would have destroyed.
--
-- WHY THIS EXISTS.  formal/cubical/ApohaParyaya_… and cf-archivist's
-- Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld together
-- specify exactly when collapsing standpoints is legitimate:
--
--     * standpoints that AGREE (same content, not merely same truth)
--       may be collapsed -- and then "holding both" said one thing twice;
--     * standpoints that MUTUALLY ENTAIL but do not AGREE may not --
--       collapsing them is durnaya, and the loss is exhibitable;
--     * a standpoint that DENIES another is the third position,
--       syād-asti-nāsti, assertable in succession (krama);
--     * asserted simultaneously (saha / yugapat) rather than in
--       succession, the pair is avaktavyam -- no single utterance carries
--       it.  Akalanka, Laghiyastraya (c. 720-780), kramarpana against
--       saharpana.
--
-- Those are theorems.  A theorem is not a machine: it does not take an
-- input and it does not answer.  This does.
--
-- SOURCES.  Siddhasena Divakara, Sanmatitarka 1.21, for durnaya -- a naya
-- asserting itself by denying the others.  Umasvati, Tattvarthasutra 5.31
-- (arpitanarpitasiddheh) and 5.29 (utpadavyayadhrauvyayuktam sat).
-- Akalanka for the krama/saha distinction.  GRADE: author, work, date,
-- and the doctrine each is known for; verse numbers given only where I
-- can state them.
--
-- NOT CLAIMED: that any of them wrote a decision procedure.  What is
-- taken is the classification and the rule for which case is which.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FITNESS OF THE LOOKING, stated first, because a verdict is worth
-- exactly what its looking is worth (yogya-anupalabdhi; Kumarila,
-- Slokavarttika, Abhavapariccheda, c. 7th c.).
--
-- Type equality is undecidable, so this decides a FRAGMENT: standpoints
-- whose content is given by a finite, enumerable witness set.  Content is
-- compared up to size and membership, truth is inhabitation.  Outside
-- that fragment it returns Abhinna and says so rather than guessing.
--
-- The fragment is not a toy.  It is exactly the case where somebody is
-- about to collapse several documented positions into one verdict, and
-- the witnesses are the documents.

module Naya where

import Data.List (sort, nub, intercalate, sortOn)

-- | A standpoint: a name, and the witnesses that stand under it.
--   Content = the witness set.  Truth = whether it is inhabited.
data Naya = Naya { nayaName :: String, witnesses :: [String] }

-- | What a collapse of the given standpoints would be.
data Verdict
  = Ekartha   String [String]        -- one thing said many times; collapse LEGAL
  | Durnaya   String [(String,[String])]  -- collapse ILLEGAL; here is what it destroys
  | KramaBhanga String [String] [String]  -- one affirms, one denies: succession, legal in order
  | Avaktavya String [String]        -- asserted together: no single utterance carries it
  | Abhinna   String                 -- outside the fragment; no verdict issued

inhabited :: Naya -> Bool
inhabited = not . null . witnesses

content :: Naya -> [String]
content = sort . nub . witnesses

-- | Do all inhabited standpoints have the SAME content, not merely the
--   same truth?  This is the distinction the whole thing turns on, and it
--   is the one a boolean verdict destroys.
agree :: [Naya] -> Bool
agree ns = case map content ns of
  []     -> True
  (c:cs) -> all (== c) cs

mutuallyEntail :: [Naya] -> Bool
mutuallyEntail ns = all inhabited ns || all (not . inhabited) ns

-- | THE DECISION.  `saha` = the standpoints are being asserted
--   simultaneously (Akalanka's saharpana); False = in succession (krama).
decide :: Bool -> [Naya] -> Verdict
decide saha ns
  | length ns < 2 = Abhinna "fewer than two standpoints: nothing to collapse"
  | any (any null . witnesses') ns = Abhinna "a standpoint carries an empty witness label"
  | not (mutuallyEntail ns) =
      let yes = [ nayaName n | n <- ns, inhabited n ]
          no  = [ nayaName n | n <- ns, not (inhabited n) ]
      in if saha
           then Avaktavya "affirmed and denied SIMULTANEOUSLY (saha): no single utterance carries it" (yes ++ map ("¬ " ++) no)
           else KramaBhanga "affirmed and denied IN SUCCESSION (krama): assertable, in that order" yes no
  | agree ns =
      Ekartha "COLLAPSE PERMITTED -- these standpoints have the same content, so you said one thing several times" (content (head ns))
  | saha =
      Avaktavya "COLLAPSE FORBIDDEN, and asserted together the pair has no single utterance (saha)"
                (map nayaName ns)
  | otherwise =
      Durnaya "COLLAPSE FORBIDDEN -- they entail each other and their content differs; any single verdict discards the difference"
              [ (nayaName n, lostBy n) | n <- ns ]
  where
    witnesses' n = witnesses n
    -- what collapsing to some OTHER standpoint would throw away from n
    lostBy n = [ w | w <- content n, any (\m -> nayaName m /= nayaName n
                                              && w `notElem` content m) ns ]

render :: Verdict -> [String]
render v = case v of
  Ekartha msg c ->
    [ "  VERDICT: YES, collapse is legal."
    , "  " ++ msg
    , "  shared content (" ++ show (length c) ++ "): " ++ intercalate "; " c
    , "  So a report that 'holds both' here is not balance.  It is repetition."
    ]
  Durnaya msg losses ->
    [ "  VERDICT: NO." , "  " ++ msg , "" ] ++
    concat [ [ "  collapsing away `" ++ nm ++ "` destroys " ++ show (length ws) ++ ":" ]
             ++ [ "      - " ++ w | w <- ws ]
           | (nm, ws) <- sortOn fst losses, not (null ws) ] ++
    [ "", "  Siddhasena, Sanmatitarka 1.21: a naya asserting itself by denying"
    , "  the others is a durnaya.  The loss above is what the denial costs." ]
  KramaBhanga msg yes no ->
    [ "  VERDICT: YES, in succession only."
    , "  " ++ msg
    , "  affirmed: " ++ intercalate ", " yes
    , "  denied  : " ++ intercalate ", " no
    , "  Akalanka's kramarpana.  Assert them one after the other; a single"
    , "  simultaneous sentence is a different position (see saha)." ]
  Avaktavya msg parts ->
    [ "  VERDICT: NO -- and not because it is unknown."
    , "  " ++ msg
    , "  standpoints: " ++ intercalate ", " parts
    , "  This is the FOURTH bhanga.  It arises from saha/yugapat, not from"
    , "  ignorance and not from undefinedness.  Both keep their full force;"
    , "  what fails is the single sentence, not either standpoint." ]
  Abhinna msg ->
    [ "  NO VERDICT ISSUED."
    , "  " ++ msg
    , "  The looking was not fit to decide this, and an unfit looking's"
    , "  silence is not a NO (Kumarila, Abhavapariccheda)." ]
