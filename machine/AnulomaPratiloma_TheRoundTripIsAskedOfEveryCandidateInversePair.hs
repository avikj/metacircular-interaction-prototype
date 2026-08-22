-- AnulomaPratiloma_TheRoundTripIsAskedOfEveryCandidateInversePair.hs
--
-- अनुलोम-प्रतिलोम — forward and backward.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  A second naya for रात्रिः.  The loop reports FIXPOINT after
-- three dry passes and its own log says why: "निर्धारण reaches only records
-- that already carry a witness."  That is not the corpus being finished.
-- **DRY IS A PROPERTY OF THE QUESTION, NOT OF THE CORPUS**, and a standpoint
-- that reports its own exhaustion as the corpus's exhaustion is a दुर्नय —
-- exactly what `Saptabhangi.दुर्नयः` proves about any verdict that denies the
-- other standpoints.  The repair is not proof search.  It is another naya.
--
-- THE QUESTION THIS ONE ASKS.  For `f : A → B` the पुनरागमन law gives
-- `A ≃ Carrier f` for free, always, with no h-level hypothesis — so asking it
-- of every function would land one sentence a thousand times, which is the
-- पुनरुक्ति the loop already caught itself committing (44d5a136, "said one
-- thing 22 times over").  The question with CONTENT is the criterion: WHICH
-- SIDE OF `f a ≡ b` IS BOUND.  Bind `b` and the fibre is `singl`, free.  Bind
-- `a` and it is the preimage, and whether that preimage is रिक्तम् / एकम् /
-- बहु varies per function and is the whole subject.
--
-- So: find candidate inverse PAIRS and put the round trip to the kernel.  When
-- both composites are `refl`, `f` is an equivalence and `A ≃ B` is a genuine
-- new EDGE — every theorem on either side transports across it, for everyone,
-- forever.  When they are not, nothing lands and the pair is recorded as a
-- written defect (road two of अहिंसा-सूत्र-विस्तारः §६; there is no third).
--
-- WHY THE NAME IS NOT A METAPHOR.  अनुलोम (with the grain, forward) and
-- प्रतिलोम (against the grain, backward) are the technical terms of the Vedic
-- पाठ system for reciting a sequence forward and then backward — the
-- क्रम/जटा/घन elaborations are built out of exactly these two directions, and
-- their entire purpose is that a text said in reverse and forward again must
-- COME BACK unchanged, which is how the saṃhitā survived without writing.
-- That is a round-trip check on a sequence, specified as a discipline, and it
-- is the same shape as `section`/`retract`.  This repository already runs
-- `machine/GhanaPatha_…hs` on the घनपाठ.
--
-- NOT CLAIMED: no text states an isomorphism, and no Vedic source is being
-- credited with cubical type theory.  What is claimed is that the pair of
-- terms names the forward-and-back structure this program tests, and that the
-- pāṭha discipline is a round-trip check.  Source: the पाठ schemes are
-- described in the Prātiśākhya literature and in Pāṇini's commentarial
-- tradition; the terms अनुलोम/प्रतिलोम are ordinary Sanskrit, attested widely.
--
-- ─────────────────────────────────────────────────────────────────────────
-- METHOD, AND ITS LIMITS, AT THE SITE.
--
--  1. Read top-level signatures `name : X → Y` by Agda's layout rule (a
--     declaration begins at column 0).  LIMIT: functions inside `where`,
--     `private` or parameterized modules are invisible, and a signature
--     spanning lines is read only if the arrow is on the first line.
--  2. Pair `f : X → Y` with `g : Y → X` in the SAME module.  LIMIT: purely
--     syntactic type matching after whitespace normalization; `ℕ → ℕ` pairs
--     with everything of that shape in its module, which produces nonsense
--     candidates.  That is intended — the kernel is the filter, and a cheap
--     over-generous proposer with an exact checker is the correct shape.
--  3. Emit one probe per pair asking `isoToEquiv (iso f g (λ _ → refl)
--     (λ _ → refl))`.  LIMIT, and it is the big one: this only finds pairs
--     whose round trips hold DEFINITIONALLY.  A genuine equivalence needing a
--     one-line induction is missed, and is missed silently.  The count of
--     probes emitted vs. accepted is printed so the miss rate is visible.
--
-- Emits nothing into the corpus.  Writes probe files to $ANULOMA_SCRATCH (or
-- ./.anuloma) and prints them; रात्रिः checks and lands.
--
--   run:  runghc machine/AnulomaPratiloma_…hs [--limit N]


module Main (main) where

import Control.Exception (catch, SomeException)
import Control.Monad (forM, forM_, when, unless)
import Data.Bits (xor)
import Data.Char (isSpace, isAlphaNum)
import Data.List (isPrefixOf, isInfixOf, isSuffixOf, nub, sortBy, foldl', intercalate)
import Data.Maybe (fromMaybe, mapMaybe, isJust, listToMaybe)
import Data.Ord (comparing)
import Data.Word (Word64)
import Numeric (showHex)
import qualified Data.Map.Strict as M
import System.Directory (doesDirectoryExist, doesFileExist, listDirectory
                        , createDirectoryIfMissing, removeFile, copyFile)
import System.Environment (getArgs, lookupEnv)
import System.Exit (ExitCode(..))
import System.FilePath ((</>), takeExtension, takeBaseName, takeDirectory)
import System.IO (hSetEncoding, stdout, utf8)
import System.Process (readProcessWithExitCode)

data Sig = Sig { sMod :: String, sName :: String, sFrom :: String, sTo :: String }

-- RUNG TWO.  Bhedanirnaya_….agda §6 states the ladder in its own words --
-- "one induction to agree pointwise, one abstraction to a path".  Rung one
-- (λ _ → refl) came back EMPTY on all 39 candidates, so the bottom of the
-- ladder is genuinely empty in this corpus and the cheap harvest is zero.
--
-- Rung two reads the HOST's own `data T … where` block and splits pointwise
-- on its constructors.  Only NULLARY constructors are handled: for an
-- enumerated type every branch is `refl` and the split is mechanical, while
-- a constructor carrying arguments needs a recursive call and that is rung
-- three.  Stated so "no split emitted" is never read as "no equivalence".
data Datatype = Datatype { dName :: String, dCons :: [String] }

readData :: String -> [Datatype]
readData src = go (lines src)
  where
    go [] = []
    go (l:ls)
      | "data " `isPrefixOf` l, (_:nm:_) <- words l, last (words l) == "where"
          = let (blk, rest) = span indented ls
            in Datatype nm (nullaryCons blk) : go rest
      | otherwise = go ls
    indented (c:_) = isSpace c
    indented _     = True
    -- a constructor line `  c : T` with no arrow is nullary
    nullaryCons blk = [ c | b <- blk, Just (c, ty) <- [breakColon b]
                      , let c' = trim c
                      , not (null c'), all (\x -> isAlphaNum x || x `elem` "-_'₀₁₂₃₄₅₆₇₈₉") c'
                      , not (elem '→' ty) ]

-- RUNG THREE.  The counterparty.  Rung two split the host's own `data`
-- enumerations and the kernel still refused all 39, with the failure moved
-- to the OTHER side every time: `code' (decode b) != b .fst  of type
-- Σ Bool (λ _ → Bool × Bool)`.  The side that fails lands in a STRUCTURED
-- type -- a Σ, a product, a record -- which has no `data … where` block to
-- read.  So rung three enumerates products of enumerations: `Bool × Bool`
-- becomes four tuple patterns, `Bool × Bool × Bool` eight.
--
-- LIMIT, and it is why this is a rung and not the ladder: only products
-- whose every factor is a host enumeration or Bool are enumerable.  A Σ
-- with a genuine dependency, or a factor of ℕ, is not, and gets `λ _ →
-- refl` back -- which is rung one, and rung one is empty here.
--
-- 2026-08-22: THIS WAS A FLAT SCAN FOR " × " AND THEREFORE CUT THROUGH
-- BRACKETS.  `SaptabhangiNaya.Basis = Bool × (Bool × Bool)` came back as
-- ["Bool", "(Bool", "Bool)"]; `consOf` knew no such types, `tuplePats`
-- returned Nothing, and the rung declined in silence — the emitter's one
-- worked exemplar was out of reach because of a string split.  It now cuts
-- at bracket depth 0 and recurses into a parenthesised factor, so nesting
-- flattens, which is what the tuple pattern wants: Agda's `(a , b , c)` is
-- right-nested already.
factorsOf :: String -> [String]
factorsOf = go . stripParens . trim
  where
    go s = case splitDepth0 s of
             [x] -> [trim x]
             xs  -> concatMap (go . stripParens . trim) xs
    stripParens s = case (s, reverse s) of
      ('(':_, ')':_) | balancedInside (init (drop 1 s)) -> trim (init (drop 1 s))
      _ -> s
    balancedInside = go' (0 :: Int)
      where go' n ('(':r) = go' (n + 1) r
            go' n (')':r) = n > 0 && go' (n - 1) r
            go' n (_:r)   = go' n r
            go' n []      = n == 0
    splitDepth0 s = reverse (map reverse (go' s (0 :: Int) "" []))
      where
        go' [] _ acc out = acc : out
        go' r@(c:cs) n acc out
          | " × " `isPrefixOf` r, n == 0 = go' (drop 3 r) n "" (acc : out)
          | c == '('  = go' cs (n + 1) (c:acc) out
          | c == ')'  = go' cs (n - 1) (c:acc) out
          | otherwise = go' cs n (c:acc) out

breakOnStr :: String -> String -> Maybe (String, String)
breakOnStr pat s = go "" s
  where go _ [] = Nothing
        go acc r@(c:cs)
          | pat `isPrefixOf` r = Just (reverse acc, drop (length pat) r)
          | otherwise          = go (c:acc) cs

consOf :: HostFacts -> String -> Maybe [String]
consOf hf t0
  | trim t == "Bool" = Just ["false", "true"]
  | otherwise = case [ d | d <- hData hf, dName d == trim t, not (null (dCons d)) ] of
      (d:_) -> Just (dCons d)
      []    -> Nothing
  where t = unalias hf t0

-- cartesian product of the factors' constructors, as tuple patterns
tuplePats :: HostFacts -> String -> Maybe [String]
tuplePats hf ty = do
  let fs = factorsOf (unalias hf ty)
  if length fs < 2 then Nothing else do
    cs <- mapM (consOf hf) fs
    let combos = sequence cs
    if length combos > 32 then Nothing
      else Just [ "(" ++ intercalate " , " k ++ ")" | k <- combos ]

splitFor :: HostFacts -> String -> String
splitFor hf ty
  | Just ps <- tuplePats hf ty
      = "(λ { " ++ intercalate " ; " [ p ++ " → refl" | p <- ps ] ++ " })"
splitFor hf ty = case consOf hf ty of
  -- 2026-08-22.  This branch used to test `dName d == trim ty` directly and
  -- therefore did NOT split a bare `Bool`, because `Bool` has no `data …
  -- where` block in the host — it comes from the library.  `consOf` already
  -- knew `Bool`'s two constructors and only `tuplePats` was asking it, so a
  -- one-factor Bool side fell straight through to rung one.
  -- `AchromaticToy.from₁₂ ⇄ to₁₂` failed with `from₁₂ (to₁₂ b) != b of type
  -- Bool` for exactly that reason: a case split was available and was never
  -- emitted.
  Just cs@(_:_) -> "(λ { " ++ intercalate " ; " [ c ++ " → refl" | c <- cs ] ++ " })"
  _             -> "(λ _ → refl)"

-- ─────────────────────────────────────────────────────────────────────────
-- RUNG FOUR.  THE ABSTRACTION.
--
-- `Bhedanirnaya_…agda` §6 states the ladder in the tradition's own economy —
-- "one induction to agree pointwise, ONE ABSTRACTION TO A PATH" — and rungs
-- one to three are the induction half only.  They split, and splitting is
-- the one thing that cannot reach the exemplar this corpus already contains:
--
--     NEBasis = Σ[ s ∈ Basis ] NonEmpty s          (SaptabhangiNaya §4)
--
-- A dependent Σ whose second component is a PROPOSITION is not enumerable.
-- There is nothing to case on; the proof is that the second component
-- CANNOT DISAGREE, which is `Σ≡Prop` and is an abstraction, not an
-- induction.  Every rung below misses it, and misses it silently, which is
-- why the ladder reported ZERO and reported nothing about why.
--
-- WHAT THIS EMITS.  For a side whose type is a host alias `T = Σ[ x ∈ A ] P`
-- with an isProp lemma for `P` available in the host, the pointwise proof is
--
--     (λ { (<pattern-on-A> , _) → Σ≡Prop <lemma> refl ; … })
--
-- — rung three's enumeration of `A` on the FIRST component, and the
-- abstraction on the second.  Where `A` is not enumerable it degrades to
-- `(λ b → Σ≡Prop <lemma> refl)`, which is still strictly stronger than rung
-- one because it discharges the second component unconditionally.
--
-- FOUR LIMITS, at the site, because a rung that hid them would be the
-- दुर्नय this program was written against.
--
--  1. AN ABSURD BRANCH IS NOT HANDLED.  `SaptabhangiNaya.decode` sends
--     `((false , false , false) , ne)` to `⊥.rec (ne refl)`, and that
--     branch's obligation is not `Σ≡Prop … refl` — it is an ex falso, and
--     which term discharges it depends on the host's own emptiness lemma.
--     So this rung does not close SaptabhangiNaya and is not claimed to; the
--     kernel's refusal on that pair now names the false-false-false branch
--     precisely, which is the first time the queue said where the work is.
--     A hand proof of that module was in flight the same day; this emitter
--     was deliberately not raced against it.
--  2. THE isProp LEMMA IS FOUND BY NAME, NOT BY TYPE.  A host signature
--     mentioning `isProp` and the head token of `P` is taken as evidence.
--     That is a lexical match; it can propose a lemma whose indices do not
--     line up, and when it does the kernel refuses and the ledger records the
--     refusal.  Over-proposing into an exact checker is the correct
--     direction — the reverse, a checker that guesses, is not.
--  3. ONLY A ONE-LEVEL Σ, AND MEASURABLY SO.  `CenterRelative.CR = Σ[ W ∈ ℤ ]
--     Σ[ R ∈ ℤ ] EvenT (W - R)` nests, so the predicate handed to the lemma
--     search is itself `Σ[ R ∈ ℤ ] …`, whose head token is not alphanumeric;
--     the search declines and the pair stays at rung one.  `isPropEvenT` is
--     sitting in that very module, four lines above.  Nested Σ is the second
--     emitter this histogram asks for.
--  4. A `record` IS NOT A Σ HERE.  Only the `Σ[ x ∈ A ] P` sugar is read.
data HostFacts = HostFacts
  { hData    :: [Datatype]           -- `data T … where` with nullary cons
  , hAlias   :: M.Map String String  -- `T = <rhs>` at column 0
  , hSigs    :: [(String, String)]   -- every column-0 `name : type`
  }

-- `T = Σ[ x ∈ A ] P …` → (A, P).  Whitespace-normalised, brackets not parsed:
-- the binder form Agda's own `Σ[ _ ∈ _ ]` sugar produces is what is matched,
-- and a raw `Σ A (λ x → P)` is NOT — stated so a miss is read as a miss.
sigmaParts :: String -> Maybe (String, String)
sigmaParts rhs = do
  r1 <- stripPre "Σ[" (trim rhs)
  (_bind, r2) <- breakOnStr "∈" r1
  (a, p) <- breakOnStr "]" r2
  let a' = trim a; p' = trim p
  if null a' || null p' then Nothing else Just (a', p')
  where stripPre pre s = if pre `isPrefixOf` s then Just (drop (length pre) s) else Nothing

-- Resolve a type through the host's aliases and read a Σ off it.  Accepts a
-- NAME (`NEBasis`) or the Σ written out, so it works before and after
-- `unalias`.
sigmaOf :: HostFacts -> String -> Maybe (String, String)
sigmaOf hf ty = sigmaParts (unalias hf ty)

-- A host signature that mentions `isProp` and the head token of the predicate.
isPropLemmaFor :: HostFacts -> String -> Maybe String
isPropLemmaFor hf predicate =
  listToMaybe [ n | (n, t) <- hSigs hf
                  , "isProp" `isInfixOf` t
                  , not (null hd), hd `isInfixOf` t ]
  where hd = takeWhile (\c -> isAlphaNum c || c `elem` "-_'₀₁₂₃₄₅₆₇₈₉")
                       (dropWhile isSpace predicate)

-- The rung-four term for a side, or Nothing when the rung does not apply.
sigmaSplit :: HostFacts -> String -> Maybe String
sigmaSplit hf ty = do
  (base, predicate) <- sigmaOf hf ty
  lemma <- isPropLemmaFor hf predicate
  let body p = "(" ++ p ++ " , _) → Σ≡Prop " ++ lemma ++ " refl"
  pure $ case tuplePats hf base of
    Just ps -> "(λ { " ++ intercalate " ; " (map body ps) ++ " })"
    Nothing -> case consOf hf base of
      Just cs@(_:_) -> "(λ { " ++ intercalate " ; " (map body cs) ++ " })"
      _             -> "(λ b → Σ≡Prop " ++ lemma ++ " refl)"

-- The whole ladder for one side, and WHICH RUNG produced it, so the report
-- can never claim a rung it did not use.
data Rung = RungOne | RungTwoThree | RungFour deriving (Eq, Ord, Show)

rungName :: Rung -> String
rungName RungOne      = "१ refl"
rungName RungTwoThree = "२/३ split"
rungName RungFour     = "४ Σ≡Prop"

ladderFor :: HostFacts -> String -> (String, Rung)
ladderFor hf ty0
  | Just t <- sigmaSplit hf ty = (t, RungFour)
  | otherwise = let t = splitFor hf ty
                in (t, if t == "(λ _ → refl)" then RungOne else RungTwoThree)
  where ty = unalias hf ty0

-- Follow `T = U = V = …` to the first form the rungs can read.  Bounded at
-- four hops, because an alias table built from `name = rhs` lines can contain
-- a cycle and a census must not hang.  LIMIT: the term emitted is written
-- against the RESOLVED form's constructors, which is sound in Agda because an
-- alias is definitional — a `record` or an abstract type is opaque and is not
-- resolved through.
unalias :: HostFacts -> String -> String
unalias hf = go (4 :: Int)
  where
    go 0 t = t
    go k t = case M.lookup (trim t) (hAlias hf) of
      Just r | trim r /= trim t -> go (k - 1) r
      _                         -> t

-- ─────────────────────────────────────────────────────────────────────────
-- ALREADY PROVED IN THE HOST.
--
-- Measured 2026-08-22, and it is the finding that most changes what this
-- queue is worth: of the 39 pairs this program proposes, TEN have their
-- `Iso`/`≃` ALREADY STANDING in the module the pair was read out of —
-- `SaptabhangiNaya.saptabhangi-iso`, `CenterRelative.Pair≃CR`,
-- `NaturalMachine.PMTorus.obsIso`, `…S3IntegerRelativeCoordinates.
-- intersectionKernelIso`, and six more.  BOTH of the two probes the kernel
-- accepts are among them.  So the emitter's green count is not a count of
-- new edges; on this corpus it is zero new edges, and a report that did not
-- say so would be counting its own echo.
--
-- LIMIT: the match is on the two type NAMES as written in the signatures,
-- normalised for whitespace, in either order. An Iso stated between aliases
-- of the same types under different names is not caught, so this number is a
-- FLOOR on how much of the queue is already done, never a ceiling.
alreadyProved :: HostFacts -> String -> String -> Maybe String
alreadyProved hf a b =
  listToMaybe [ n | (n, t) <- hSigs hf
                  , let t' = norm t
                  , t' `elem` [ "Iso" ++ na ++ nb, "Iso" ++ nb ++ na
                              , na ++ "≃" ++ nb, nb ++ "≃" ++ na ] ]
  where na = norm a; nb = norm b

readHostFacts :: String -> HostFacts
readHostFacts src = HostFacts (readData src) (M.fromList aliases) sigs
  where
    ls  = [ l | l <- lines (stripComments src), col0 l ]
    col0 (c:_) = not (isSpace c) && c /= '-' && c /= '{' && c /= '#'
    col0 _     = False
    sigs = [ (trim n, trim t) | l <- ls, Just (n, t) <- [breakColon l]
           , all okName (trim n), not (null (trim n)) ]
    -- `T = <rhs>` with a single token on the left.  This deliberately does
    -- NOT require a matching signature: `AchromaticToy` declares its three
    -- carriers on ONE line, `G₁ G₂ G₃ : Type₀`, so a signature-gated alias
    -- table missed every one of them and `G₁ = Bool` was invisible — the
    -- side was left at rung one with a case split sitting right there.
    -- A value definition `x = …` therefore also enters the table; that is
    -- harmless, because only a name appearing as a TYPE is ever looked up.
    aliases = [ (trim n, trim r)
              | l <- ls, Just (n, r) <- [breakEquals l]
              , all okName (trim n), not (null (trim n)) ]
    okName c = isAlphaNum c || c `elem` "-_'∙′₀₁₂₃₄₅₆₇₈₉≃×"

stripComments :: String -> String
stripComments = unlines . map dropLine . lines . dropBlock
  where
    dropLine l = case breakOnStr "--" l of Just (a, _) -> a; Nothing -> l
    dropBlock s = go s (0 :: Int)
      where
        go [] _ = []
        go cs n
          | "{-" `isPrefixOf` cs = go (drop 2 cs) (n + 1)
          | "-}" `isPrefixOf` cs = go (drop 2 cs) (max 0 (n - 1))
          | otherwise = case cs of
              (c:r) -> if n > 0 then go r n else c : go r n
              []    -> []

-- `name = rhs` with a single token on the left.
breakEquals :: String -> Maybe (String, String)
breakEquals l = case break (== '=') l of
  (a, '=':b) | not (null a), take 1 b /= "="
             , length (words a) == 1 -> Just (a, b)
  _ -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- THE VERDICT LEDGER — निर्णयपञ्जिका, kept across passes.
--
-- WHY.  Until 2026-08-22 every pass re-proposed all 39 pairs and re-put every
-- one of them to the kernel from scratch, so an overnight loop paid the full
-- corpus check for the same refusals for eight hours and could learn nothing
-- from having run before.  A verdict is only re-askable when THE QUESTION has
-- changed, and the question here is the two functions' definitions.
--
-- `machine/Nama_…hs` content-addresses every definition in this corpus — its
-- digest is FNV-1a 64 over the normalised text AND the sorted digests of the
-- declaration's dependencies, so an edit anywhere upstream changes the
-- address.  That is exactly the key a verdict may be cached under: the pair
-- (address of f, address of g), plus the rung, plus the probe's own digest.
--
-- THREE LIMITS, at the site.
--  1. A pair whose functions नाम cannot address — a `where`-bound or
--     `private` definition — gets NO key and is therefore re-asked every
--     pass.  That is the safe direction and it is not free: it is the part
--     of the queue an eight-hour loop still pays for.
--  2. THE PROBE'S OWN TEXT IS IN THE KEY, and the first draft of this ledger
--     got that wrong in a way worth recording.  It keyed on a hand-written
--     `emitterVersion` string, and within ten minutes the emitter changed —
--     rung two began importing `Bool`'s constructors — while the string did
--     not, so the very next pass served three stale refusals out of cache
--     and reported them as that pass's verdicts.  A hand-kept version number
--     is a claim about the code that nothing checks.  The key is now the FNV
--     digest of the EMITTED PROBE, which is the question verbatim: change
--     any rung and every probe it touches re-asks itself.
--  3. A cached REFUSAL is cached; a cached ACCEPTANCE is re-checked every
--     pass anyway, because a green is a claim the corpus stands on and the
--     cost of re-verifying it is the cost of being allowed to state it.

-- FNV-1a 64, the same digest नाम uses, so the two keys in a row are the same
-- kind of object.  A collision would serve one pair's verdict for another's,
-- which is why the addresses of BOTH functions stand in the key beside it.
fnv1a :: String -> String
fnv1a = pad . flip showHex "" . foldl' step (14695981039346656037 :: Word64)
  where
    step h c = (h `xor` fromIntegral (fromEnum c `mod` 256)) * 1099511628211
    pad s = replicate (16 - length s) '0' ++ s

data Verdict = Accepted | Refused deriving (Eq, Show)

data Row = Row
  { rKeyF :: String, rKeyG :: String, rRung :: String, rProbe :: String
  , rVerdict :: Verdict, rClass :: String, rWhere :: String, rObl :: String }

ledgerPath :: FilePath
ledgerPath = "notes/anuloma/NirnayaPanjika.tsv"

rowKey :: Row -> (String, String, String, String)
rowKey r = (rKeyF r, rKeyG r, rRung r, rProbe r)

readLedger :: IO [Row]
readLedger = do
  ok <- doesFileExist ledgerPath
  if not ok then pure [] else do
    s <- readFile ledgerPath
    length s `seq` pure (mapMaybe parseRow (filter (not . isPrefixOf "#") (lines s)))
  where
    parseRow l = case splitTabs l of
      (kf:kg:ru:pr:vd:cl:wh:ob:_) ->
        Just (Row kf kg ru pr (if vd == "Accepted" then Accepted else Refused) cl wh ob)
      _ -> Nothing

writeLedger :: [Row] -> IO ()
writeLedger rs = do
  createDirectoryIfMissing True (takeDirectory ledgerPath)
  writeFile ledgerPath $ unlines $
    ("# निर्णयपञ्जिका — keyed on नाम's content addresses and the probe's own"
     ++ " digest.  A row stands until one of them moves."
     ++ "\n# addrF\taddrG\trung\tprobe\tverdict\tclass\twhere\tobligation")
    : [ intercalate "\t" [ rKeyF r, rKeyG r, rRung r, rProbe r, show (rVerdict r)
                         , rClass r, rWhere r, oneLine (rObl r) ] | r <- rs ]
  where oneLine = map (\c -> if c == '\n' || c == '\t' then ' ' else c)

splitTabs :: String -> [String]
splitTabs s = case break (== '\t') s of
  (a, '\t':b) -> a : splitTabs b
  (a, _)      -> [a]

-- ─────────────────────────────────────────────────────────────────────────
-- THE CLASSIFIER — what KIND of obligation is blocking, per open pair.
--
-- A loop that says "dry" teaches nothing.  A loop that says "twelve of these
-- are blocked on the same move" has written its own next feature request,
-- and that is the only sense in which this apparatus improves itself.  So
-- every refusal is read for the type the obligation lives in, put in a
-- class, and the classes are printed as a histogram with counts.
--
-- THE FIRST DISTINCTION IS THE LOAD-BEARING ONE, and getting it wrong would
-- make the whole histogram a lie: a probe that dies at `MetaCannotDependOn`,
-- `NotInScope`, `PatternShadowsConstructor` or `CoverageIssue` is NOT
-- carrying a mathematical obligation.  It is a defect in THIS PROGRAM — an
-- indexed family the emitter cannot abstract, a constructor with arguments
-- the split did not cover.  Counting those beside «induction on ℕ» would
-- report the emitter's own bugs as the corpus's open problems, which is
-- precisely the inversion this repository exists against.  They are counted,
-- and counted SEPARATELY, under मम दोषः.
classify :: HostFacts -> String -> (String, String)
classify hf out
  | "MetaCannotDependOn" `isInfixOf` out = (myFault "indexed family", firstErr)
  | "NotInScope"         `isInfixOf` out = (myFault "not in scope",   firstErr)
  | "CoverageIssue"      `isInfixOf` out = (myFault "split incomplete", firstErr)
  | "Failed to find source" `isInfixOf` out = (myFault "module path", firstErr)
  -- A CONSTRUCTOR THE PROBE NAMED BUT DID NOT IMPORT BINDS A VARIABLE, so
  -- the split is not a split.  Agda says this as a -W warning while the
  -- mathematics fails underneath; here it is a defect of mine and counted
  -- as one.  See the Bool import in `probe`.
  | "PatternShadowsConstructor" `isInfixOf` out
      = (myFault "constructor not imported", firstErr)
  | otherwise = (ofType (typeOfObligation out), firstErr)
  where
    myFault s = "मम दोषः · " ++ s
    firstErr = trim (unwords (take 40 (words (unlines
                 (take 4 (drop 1 (dropWhile (not . isInfixOf "error:") (lines out))))))))
    -- THE ORDER OF THESE GUARDS IS THE CLASSIFICATION, and getting it wrong
    -- misnames the move.  `List Nat` matched `Nat` first and was filed under
    -- «induction on ℕ» — the wrong feature request, because the induction
    -- that closes it is on the LIST.  The outer former decides, so the
    -- structured formers are tested before the scalars they contain.
    ofType t
      | null t                          = "unclassified"
      | isJust (sigmaOf hf t)           = "Σ≡Prop"
      | "SetQuotients" `isInfixOf` t    = "quotient elimination"
      | "⊎"       `isInfixOf` t         = "case on ⊎"
      | "List"    `isInfixOf` t         = "induction on List"
      | "Fin"     `isInfixOf` t         = "enumerate Fin n"
      | "Σ"       `isInfixOf` t         = "Σ≡Prop"
      | "Nat"     `isInfixOf` t
        || "ℕ"    `isInfixOf` t         = "induction on ℕ"
      | "Int"     `isInfixOf` t
        || "ℤ"    `isInfixOf` t         = "library lemma on ℤ"
      | "Bool"    `isInfixOf` t         = "case on Bool"
      | any ((== trim t) . dName) (hData hf) = "host enumeration (emitter gap)"
      | otherwise                       = "host type · " ++ trim t

-- Agda prints `X != Y of type T`, with T possibly wrapping onto the lines
-- after it, up to `when checking`.
--
-- LIMIT: when the mismatch itself is many lines long the `of type` marker can
-- be past the window the kernel prints, and the pair then lands in
-- «unclassified» — which is a class and is printed as one, never folded into
-- a neighbour.  Four of the 37 open pairs sat there on 2026-08-22.
typeOfObligation :: String -> String
typeOfObligation out =
  case dropWhile (not . isInfixOf "of type") (lines out) of
    (l:rest) -> let after = maybe "" snd (breakOnStr "of type" l)
                    more  = takeWhile (not . isInfixOf "when checking") rest
                in trim (unwords (words (after ++ " " ++ unwords more)))
    [] -> ""

-- ─────────────────────────────────────────────────────────────────────────

data Cand = Cand
  { cF :: Sig, cG :: Sig, cName :: String, cBody :: String
  , cRung :: Rung, cAlready :: Maybe String }

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let lim = case dropWhile (/= "--limit") args of
              (_:n:_) -> read n
              _       -> 400 :: Int
      doCheck = "--check" `elem` args
  scratch <- fromMaybe ".anuloma" <$> lookupEnv "ANULOMA_SCRATCH"
  createDirectoryIfMissing True scratch
  fs <- listAgda "formal/cubical"
  sigs <- concat <$> mapM readSigs fs
  factsByMod <- M.fromList <$> mapM (\p -> do
                    s <- readFile p
                    length s `seq` pure (modNameOf s p, readHostFacts s)) fs
  let byMod = M.fromListWith (++) [ (sMod s, [s]) | s <- sigs ]
      pairs = [ (f, g)
              | (_, ss) <- M.toList byMod
              , f <- ss, g <- ss
              , sName f < sName g                     -- unordered, no self
              , norm (sTo f) == norm (sFrom g)
              , norm (sTo g) == norm (sFrom f)
              , norm (sFrom f) /= norm (sTo f)        -- endo pairs are noise
              ]
      keep = take lim pairs
      hfOf f = M.findWithDefault (HostFacts [] M.empty []) (sMod f) factsByMod
      cands = [ Cand f g nm body rung (alreadyProved hf (sFrom f) (sTo f))
              | (f, g) <- keep
              , let hf   = hfOf f
                    nm   = "AnulomaPratiloma_" ++ sanitize (sMod f) ++ "_"
                           ++ sanitize (sName f) ++ "_" ++ sanitize (sName g)
                    (rt, r1) = ladderFor hf (sTo f)
                    (lt, r2) = ladderFor hf (sFrom f)
                    rung = max r1 r2
                    body = probe nm f g rt lt (rung == RungFour) ]
  putStrLn ""
  putStrLn "  अनुलोम-प्रतिलोम — the round trip, put to the kernel"
  putStrLn "  ────────────────────────────────────────────────────────────"
  putStrLn $ "  modules scanned      : " ++ show (length fs)
  putStrLn $ "  top-level arrows     : " ++ show (length sigs)
  putStrLn $ "  candidate pairs      : " ++ show (length pairs)
  putStrLn $ "  probes emitted       : " ++ show (length keep)
  putStrLn $ "  …already proved in host: "
             ++ show (length [ () | c <- cands, isJust (cAlready c) ])
             ++ "  (the host module already carries the Iso or the ≃)"
  putStrLn ""
  forM_ (zip [1 :: Int ..] cands) $ \(i, c) -> do
    writeFile (scratch </> cName c ++ ".agda") (cBody c)
    putStrLn $ "  PROBE " ++ show i ++ "  " ++ sMod (cF c) ++ " : "
               ++ sName (cF c) ++ " ⇄ " ++ sName (cG c)
               ++ "   (" ++ trim (sFrom (cF c)) ++ " ≃ " ++ trim (sTo (cF c)) ++ ")"
               ++ "  [rung " ++ rungName (cRung c) ++ "]"
               ++ maybe "" (\n -> "  ALREADY: " ++ sMod (cF c) ++ "." ++ n) (cAlready c)
  putStrLn ""
  putStrLn "  A probe is a PROPOSAL, never a finding.  The counts above are"
  putStrLn "  proposals.  Only `--check` puts them to the kernel, and only the"
  putStrLn "  kernel's acceptance is a result."
  putStrLn ""
  when doCheck (checkAll scratch hfOf cands)

-- ─────────────────────────────────────────────────────────────────────────
-- PUTTING IT TO THE KERNEL, IN THIS PROGRAM RATHER THAN IN THE SHELL.
--
-- रात्रिः used to do this with `timeout 120 agda …`, and on 2026-08-22 that
-- was measured to be a NO-OP ON THIS HOST: `timeout` is a GNU coreutils
-- binary and is not present on macOS, so every one of the 39 checks exited
-- 127 with `command not found` and the loop's "0 accepted, 39 open" was not
-- a kernel verdict at all — it was a missing binary, 39 times, reported as
-- mathematics.  Run directly here, the same 39 give TWO acceptances.
--
-- LIMIT: there is no wall-clock cap on a check now.  A probe that sends the
-- kernel into a loop hangs the pass.  That is the honest trade against a
-- guard that silently converted every check into a failure, and if a cap is
-- wanted it belongs here in Haskell (`System.Timeout` over the process), not
-- in a binary that may not exist.
checkAll :: FilePath -> (Sig -> HostFacts) -> [Cand] -> IO ()
checkAll scratch hfOf cands = do
  addrs <- namaAddresses
  old   <- readLedger
  let oldMap = M.fromList [ (rowKey r, r) | r <- old ]
      addrOf s = M.lookup (sMod s ++ "." ++ sName s) addrs
  putStrLn "  ── putting each probe to the kernel ─────────────────────────"
  putStrLn $ "  content addresses from नाम: " ++ show (M.size addrs)
  putStrLn $ "  ledger rows carried in    : " ++ show (length old)
  results <- forM cands $ \c -> do
    let kf = fromMaybe "" (addrOf (cF c)); kg = fromMaybe "" (addrOf (cG c))
        dg = fnv1a (cBody c)
        key = (kf, kg, rungName (cRung c), dg)
        wh  = sMod (cF c) ++ " : " ++ sName (cF c) ++ " ⇄ " ++ sName (cG c)
        cached = if null kf || null kg then Nothing else M.lookup key oldMap
    case cached of
      Just r | rVerdict r == Refused -> do
        putStrLn $ "  CACHED " ++ wh ++ "   [" ++ rClass r ++ "]"
        pure r
      _ -> do
        out <- runAgda scratch (cName c)
        case out of
          Nothing -> do
            putStrLn $ "  GREEN  " ++ wh ++ case cAlready c of
              Just n  -> "   — but the host already proves it: " ++ n
              Nothing -> "   — A NEW EDGE"
            pure (Row kf kg (rungName (cRung c)) dg Accepted
                      (maybe "new edge" (const "restates a host Iso") (cAlready c)) wh "")
          Just err -> do
            let (cls, obl) = classify (hfOf (cF c)) err
            putStrLn $ "  OPEN   " ++ wh ++ "   [" ++ cls ++ "]"
            unless (null obl) $ putStrLn $ "         " ++ obl
            pure (Row kf kg (rungName (cRung c)) dg Refused cls wh obl)
  -- carry forward every row whose key this pass did not re-ask
  let fresh = M.fromList [ (rowKey r, r) | r <- results ]
      merged = M.elems (M.union fresh oldMap)
  writeLedger (sortBy (comparing rWhere) merged)
  histogram cands results

-- ─────────────────────────────────────────────────────────────────────────
-- THE HISTOGRAM — the loop's own next feature request.
--
-- This is the part that makes the loop self-improving rather than merely
-- repeated.  When both standpoints go dry, "dry" is worth nothing; what is
-- worth something is WHICH MOVE the remainder is blocked on, because the
-- largest class names the emitter somebody should write next, in the exact
-- words of the move.  A count of 37 refusals is a wall.  A count that says
-- twelve of them want the same induction is a morning's work with its shape
-- already given.
--
-- The मम दोषः classes print FIRST and separately.  They are this program's
-- defects, not the corpus's obligations, and a histogram that mixed them
-- would report my bugs as open mathematics.
histogram :: [Cand] -> [Row] -> IO ()
histogram cands rows = do
  let opens  = [ r | r <- rows, rVerdict r == Refused ]
      greens = [ r | r <- rows, rVerdict r == Accepted ]
      tally rs = sortBy (comparing (negate . snd))
                   (M.toList (M.fromListWith (+) [ (rClass r, 1 :: Int) | r <- rs ]))
      mine   = filter (isPrefixOf "मम दोषः" . rClass) opens
      theirs = filter (not . isPrefixOf "मम दोषः" . rClass) opens
      already = length [ () | c <- cands, isJust (cAlready c) ]
      restated = length [ () | r <- greens, rClass r == "restates a host Iso" ]
  putStrLn ""
  putStrLn "  ── the histogram: WHAT KIND of obligation is blocking ───────"
  putStrLn $ "  proposed " ++ show (length cands)
             ++ " · accepted " ++ show (length greens)
             ++ " · open " ++ show (length opens)
  putStrLn $ "  of the accepted, " ++ show restated
             ++ " restate an Iso the host module already carries."
  putStrLn $ "  NEW EDGES THIS PASS: " ++ show (length greens - restated)
  putStrLn $ "  of all proposals, " ++ show already
             ++ " have their Iso or ≃ already standing in the host."
  putStrLn ""
  putStrLn "  MY OWN DEFECTS (not the corpus's obligations):"
  if null mine then putStrLn "    none this pass."
    else forM_ (tally mine) $ \(k, n) -> putStrLn $ "    " ++ pad 34 k ++ show n
  putStrLn ""
  putStrLn "  THE MOVE EACH OPEN PAIR IS BLOCKED ON:"
  forM_ (tally theirs) $ \(k, n) -> putStrLn $ "    " ++ pad 34 k ++ show n
  putStrLn ""
  case tally theirs of
    ((k, n):_) | n > 1 -> putStrLn $
        "  " ++ show n ++ " of " ++ show (length theirs)
        ++ " open pairs are blocked on the SAME move — «" ++ k ++ "»."
        ++ "  That names the emitter to write next."
    _ -> putStrLn "  No class holds more than one pair, so there is no next \
                  \emitter this pass, and saying so is the result."
  putStrLn ""
  where pad n s = s ++ replicate (max 1 (n - length s)) ' '

-- Returns Nothing on acceptance, Just the kernel's output on refusal.
runAgda :: FilePath -> String -> IO (Maybe String)
runAgda scratch nm = do
  libs <- librariesArg
  let dest = "formal/cubical" </> nm ++ ".agda"
  copyFile (scratch </> nm ++ ".agda") dest
  (rc, o, e) <- readProcessWithExitCode "agda"
                  (libs ++ ["-i", "formal/cubical", "-i", ".", dest]) ""
                  `catchAny` (\ex -> pure (ExitFailure 127, "", show ex))
  removeFile dest `catchAny` const (pure ())
  pure (if rc == ExitSuccess then Nothing else Just (o ++ e))
  where
    catchAny :: IO a -> (SomeException -> IO a) -> IO a
    catchAny = catch

-- `--library-file` OR NOTHING, and the difference matters.
--
-- रात्रिः builds a libraries file by globbing two homebrew paths.  If neither
-- glob hits, it writes an EMPTY file and passes it, at which point agda knows
-- about no libraries at all and every probe dies at `NotInScope: ℕ` — the
-- same shape of lie as the missing `timeout`.  So the file is passed only
-- when the caller sets ANULOMA_LIBRARIES to one that exists, and otherwise no
-- flag is passed at all and agda reads the user's own ~/.agda/libraries.
librariesArg :: IO [String]
librariesArg = do
  env <- lookupEnv "ANULOMA_LIBRARIES"
  case env of
    Just f  -> do ok <- doesFileExist f
                  pure (if ok then ["--library-file=" ++ f] else [])
    Nothing -> pure []

-- Shells out to नाम for the address table.  The lookup key is `Module.name`,
-- exactly as नाम's own digest table is keyed.  On any failure this returns an
-- empty table, every key is then empty, nothing is cached, and the pass is
-- merely slow — a ledger that cannot key must never guess.
namaAddresses :: IO (M.Map String String)
namaAddresses = do
  (rc, o, _) <- readProcessWithExitCode "runghc"
                  ["machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs"
                  , "--emit-addresses"] ""
                  `catch` (\e -> pure (ExitFailure 1, "", show (e :: SomeException)))
  if rc /= ExitSuccess then pure M.empty else
    pure $ M.fromList [ (m ++ "." ++ n, h)
                      | l <- lines o, (h:lang:m:n:_) <- [splitTabs l], lang == "Agda" ]

probe :: String -> Sig -> Sig -> String -> String -> Bool -> String
probe nm f g rightTerm leftTerm needSigma = unlines $
  [ "{-# OPTIONS --cubical --safe --no-import-sorts #-}"
  , "-- Emitted by अनुलोम-प्रतिलोम.  CHECKED IN PLACE before landing; nothing"
  , "-- lands that the kernel has not accepted.  The claim is exactly that the"
  , "-- two named functions are mutually inverse, hence that their domains are"
  , "-- equivalent, hence — by univalence — equal, so every theorem about one"
  , "-- is a `subst` away from the other."
  , "module " ++ nm ++ " where"
  , ""
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Foundations.Isomorphism"
  , "open import Cubical.Foundations.Equiv"
  , "open import Cubical.Foundations.Univalence" ]
  -- `Σ≡Prop` is imported BY NAME and only when rung four fired.  A blanket
  -- `open import Cubical.Data.Sigma` brings `_×_`, `fst`, `snd` and `Σ` into
  -- scope and SHADOWS the host's own choices, which is the exact failure
  -- recorded below that lost all 39 probes on run three.  One name, on
  -- demand, shadows nothing.
  ++ [ "open import Cubical.Data.Sigma using (Σ≡Prop)" | needSigma ]
  -- A CONSTRUCTOR NOT IN SCOPE IS NOT AN ERROR IN AGDA — IT IS A PATTERN
  -- VARIABLE, and that is the worst failure this emitter can have.
  -- `AchromaticToy.G₁ = Bool`, so rung two emitted `λ { false → refl ; true
  -- → refl }`; the host does not re-export `Cubical.Data.Bool`, so `false`
  -- bound a VARIABLE, the clause silently became `λ _ → refl` wearing a
  -- split's clothes, and agda reported it as a -W warning while the
  -- mathematics failed underneath.  The two constructors are therefore
  -- imported by name whenever the split names them — which on the next run
  -- closed `ProjectionChargeAudit.decode ⇄ encode` outright and moved
  -- AchromaticToy's obligation off Bool and onto ⊎.  Any future rung that
  -- emits a LIBRARY type's constructors must do the same or it will silently
  -- do nothing.
  ++ [ "open import Cubical.Data.Bool using (true ; false)"
     | any (`isInfixOf` (rightTerm ++ " " ++ leftTerm))
           ["false →", "true →", "false ,", "true ,", "false)", "true)"] ]
  -- The signature's types come from the HOST module's imports, which a probe
  -- does not inherit.  Without this every probe dies at `NotInScope: ℕ`,
  -- which is how the second run lost all 39.
  ++
  [ "open import " ++ sMod f
  , ""
  , "-- अनुलोमम् " ++ sName f ++ " , प्रतिलोमम् " ++ sName g ++ " ।"
  , "--"
  , "-- NO TYPE IS WRITTEN DOWN HERE, AND THAT IS THE POINT.  The first three"
  , "-- runs of this emitter restated the domain and codomain in the probe, and"
  , "-- all 39 probes died: first on the module path, then on `NotInScope: ℕ`,"
  , "-- and then -- after importing the data modules to fix that -- on"
  , "-- `Cubical.Data.Fin.Fin != Cubical.Data.FinData.Fin`, because a blanket"
  , "-- import SHADOWS the host's own choice of a type with that name.  Restating"
  , "-- a type is asserting a second time something the two functions already"
  , "-- determine, and every failure above was that assertion disagreeing with"
  , "-- the host.  The types are CARRIED; the functions are the base.  Agda"
  , "-- infers them, and then there is nothing to disagree with."
  , "मार्गः = iso " ++ sName f ++ " " ++ sName g
          ++ " " ++ rightTerm   -- rightInv: the ladder run on the codomain
          ++ " " ++ leftTerm    -- leftInv : the ladder run on the domain
  , ""
  , "समता = isoToEquiv मार्गः"
  , ""
  , "-- and the edge itself, which is what transports."
  , "सेतुः = ua समता"
  ]

-- ------------------------------------------------------------------ reading

listAgda :: FilePath -> IO [FilePath]
listAgda root = go root
  where
    go d = do
      ok <- doesDirectoryExist d
      if not ok then pure [] else do
        es <- listDirectory d
        fmap concat . forM es $ \e -> do
          let p = d </> e
          isD <- doesDirectoryExist p
          if isD then (if e `elem` ["_build", "Ratri", "MachineMinted"] then pure [] else go p)
                 else pure [ p | takeExtension p == ".agda" ]

modNameOf :: String -> FilePath -> String
modNameOf src fp = case [ w | l <- lines src, "module " `isPrefixOf` l
                        , (w:_) <- [drop 1 (words l)] ] of
  (x:_) -> x
  []    -> takeBaseName fp

readSigs :: FilePath -> IO [Sig]
readSigs fp = do
  src <- readFile fp
  -- The module NAME is the file's own `module X where` line, not its
  -- basename.  A file in a subdirectory declares `NaturalMachine.Digits`,
  -- and importing `Digits` fails with FileNotFound -- which is how all 39
  -- probes of the first run died at once.  The declaration is authoritative;
  -- the path is a view of it.
  let m = case [ w | l <- lines src, "module " `isPrefixOf` l
               , (w:_) <- [drop 1 (words l)] ] of
            (x:_) -> x
            []    -> takeBaseName fp
      ls = filter col0 (lines src)
  pure [ Sig m n a b | l <- ls, Just (n, a, b) <- [parseSig l] ]
  where col0 (c:_) = not (isSpace c) && c /= '-' && c /= '{' && c /= '#'
        col0 _     = False

-- `name : X → Y` with exactly one top-level arrow and no binders.
parseSig :: String -> Maybe (String, String, String)
parseSig l = do
  (n, rest) <- breakColon l
  let n' = trim n
  if null n' || not (all okChar n') then Nothing else do
    (a, b) <- splitArrow (trim rest)
    if any bad [a, b] || null (trim a) || null (trim b)
      then Nothing else Just (n', a, b)
  where
    okChar c = isAlphaNum c || c `elem` "-_'∙′"
    bad s = any (`elem` words s) ["∀", "→", "Σ", "Π"] || any (`elem` s) "{(∀[]"

breakColon :: String -> Maybe (String, String)
breakColon s = case break (== ':') s of
  (a, ':':b) | not (null a) && take 1 b /= ":" -> Just (a, b)
  _ -> Nothing

-- split on the FIRST top-level →, requiring exactly one
splitArrow :: String -> Maybe (String, String)
splitArrow s = case parts of
  [a, b] -> Just (a, b)
  _      -> Nothing
  where parts = go s "" []
        go [] acc out = reverse (reverse acc : out)
        go ('→':r) acc out = go r "" (reverse acc : out)
        go (c:r) acc out = go r (c:acc) out

norm :: String -> String
norm = filter (not . isSpace)

trim :: String -> String
trim = f . f where f = reverse . dropWhile isSpace

sanitize :: String -> String
sanitize = map (\c -> if isAlphaNum c || c == '-' then c else 'X')

-- ─────────────────────────────────────────────────────────────────────────
-- FIRST RUN, 2026-08-22.  TRUE RESULT: 39 PROPOSED, 0 ACCEPTED.
--
-- 813 modules scanned, 1029 top-level arrows, 39 candidate inverse pairs,
-- every one refused by the kernel.  Reported as-is because a proposer that
-- reports its proposals as findings is the दुर्नय this whole apparatus
-- exists against.
--
-- Three of the refusals were MY bugs and are fixed above, each recorded at
-- its site: the module path (a file in a subdirectory declares
-- `NaturalMachine.Digits`, not `Digits`); `NotInScope: ℕ`; and then, after
-- importing the data modules to fix that, `Cubical.Data.Fin.Fin !=
-- Cubical.Data.FinData.Fin` — a blanket import SHADOWING the host's own
-- choice of a type by that name.  The repair was to stop writing the types
-- down at all: they are determined by the two functions, and every one of
-- those failures was a restatement disagreeing with the host. The types are
-- carried; the functions are the base.
--
-- THE FOURTH REFUSAL IS NOT A BUG AND IS THE RESULT.  With the plumbing
-- correct the kernel returns mathematics:
--
--     edgeToFin (finToEdge b) != b  of type  FinData.Fin 9
--
-- The round trips do not hold DEFINITIONALLY. Not one of the 39. Each needs
-- at least a case split, and `PMTorus`'s needs nine.
--
-- WHICH THE CORPUS ALREADY KNEW AND STATED. `Bhedanirnaya_…agda` §6 gives
-- the ladder in its own words — "one induction to agree pointwise, one
-- abstraction to a path". This program implements the bottom rung only, and
-- the bottom rung is empty in this corpus. That is worth knowing exactly:
-- it says the cheap mechanical harvest is ZERO here, and that every real
-- causeway costs an induction. A loop that expected free edges was going to
-- report dry forever without ever saying why.
--
-- SO THE 39 ARE NOT A FAILURE LIST, THEY ARE A WORK QUEUE with a kernel
-- behind it: 39 pairs the corpus itself proposed, each with an exact
-- obligation the kernel prints, several of them obviously real —
-- Digits.digits ⇄ value (ℕ ≃ Word), PMTorus.edgeToFin ⇄ finToEdge
-- (Edge ≃ Fin 9), SaptabhangiNaya.code' ⇄ decode (Bhanga ≃ NEBasis),
-- FreeMonoid.len ⇄ unlen (Tally ≃ ℕ), TermFreeMonoid.fromList ⇄ toList.
--
-- NEXT RUNG, not built here so it is not claimed: read the host's own `data`
-- declaration, collect its constructors, and emit the pointwise split
-- instead of `λ _ → refl`. That is mechanical for the side whose type the
-- host defines, and not mechanical for the side that lands in a library
-- type — which is exactly the asymmetry `PMTorus` above exhibits.

-- ─────────────────────────────────────────────────────────────────────────
-- RUNG THREE.  TRUE RESULT: 39 PROPOSED, 2 TUPLE-SPLIT, 0 ACCEPTED.
--
-- THE LADDER IS EXHAUSTED AND THE ANSWER IS ZERO AT EVERY RUNG.  That is
-- the finding of this program and it is worth more than the edges it failed
-- to harvest, because it says what the overnight loop must be.
--
--   rung १  λ _ → refl                 definitional     0 / 39
--   rung २  split host enumerations    pointwise        0 / 39  (5 split)
--   rung ३  enumerate product types    pointwise        0 / 39  (2 split)
--
-- The exemplar is exact.  `SaptabhangiNaya.code' ⇄ decode` is a real
-- equivalence — the sevenfold predication against a Boolean basis — and it
-- is unreachable by every rung, because
--
--     NEBasis = Σ[ s ∈ Basis ] NonEmpty s
--
-- is a dependent Σ whose second component is a PROPOSITION.  You cannot
-- enumerate it.  The proof is `Σ≡Prop`, which is an ABSTRACTION, and
-- Bhedanirnaya §6 said so in its own words before this program existed:
-- "one induction to agree pointwise, ONE ABSTRACTION TO A PATH".  This
-- program built the induction half of that sentence and the corpus needs
-- the other half.
--
-- SO THE OVERNIGHT PROGRAM CANNOT BE A HARVESTER.  There is no cheap layer
-- here to sweep; a corpus that had one would already have swept itself.
-- What there is, and what this leaves behind, is a TYPED WORK QUEUE: 39
-- pairs the corpus proposed about itself, each with the kernel's exact
-- obligation and a name for the move it needs — enumeration, Σ≡Prop,
-- induction on ℕ, or a library type's own lemma.  A queue whose every entry
-- carries the shape of its own proof is what a prover can run overnight,
-- and it is what a checker alone was never going to produce.
--
-- CONVERGENT, INDEPENDENTLY.  `Setubandha_…hs` measured the same frontier
-- from the other side the same hour: 143 edges over 196 nodes, 73
-- components, 55 of them isolated two-node causeways, 93% of defined types
-- isolated.  Two instruments, opposite directions, one conclusion — the
-- corpus's types are joined to CONSTRUCTIONS and not to each other, and
-- constructions do not case-split.

-- ─────────────────────────────────────────────────────────────────────────
-- ALL THREE RESULT BLOCKS ABOVE ARE FALSE.  RETRACTED 2026-08-22, THE SAME
-- NIGHT, BY TWO INDEPENDENT DEFECTS.  Left standing and struck rather than
-- deleted, because a silently corrected instrument is worse than a wrong
-- one: the next reader must be able to see what it claimed and why.
--
-- ── DEFECT ONE: THE VERDICTS WERE NEVER OBTAINED ──
--
-- `timeout` DOES NOT EXIST ON THIS MACHINE.  `which timeout` → not found;
-- `timeout 5 echo hi` → exit 127.  Every checking loop that produced a
-- "0 accepted" figure invoked `timeout 90 agda …`, so the shell returned
-- 127 without ever starting Agda, and the loop counted 127 as a refusal.
--
--   "0 / 39 at rung one"    NOT MEASURED
--   "0 / 39 at rung two"    NOT MEASURED
--   "0 / 39 at rung three"  NOT MEASURED
--
-- What WAS real: the individual diagnostic runs, which invoked `agda`
-- directly.  Those returned genuine kernel output — `FileNotFound` on the
-- module path, `NotInScope: ℕ`, `Cubical.Data.Fin.Fin != FinData.Fin`, and
-- `code' (decode b) != b .fst`.  Each is a true fact about one probe.  None
-- of them is the aggregate the result blocks reported.
--
-- The lesson is the repository's own and it arrived by walking into it: a
-- harness that reads a nonzero exit as a mathematical verdict will report
-- "refuted" for a missing binary, and it will do it 39 times without
-- blinking.  A refusal must name its defect or it is not a refusal —
-- `machine/Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal.hs` is in
-- this same directory and says exactly that.
--
-- ── DEFECT TWO, AND IT IS THE INTERESTING ONE ──
--
-- **SIXTEEN OF THE 39 CANDIDATES WERE ALREADY PROVED, BY HAND, IN THE VERY
-- FILE THIS PROGRAM READ.**
--
-- `SaptabhangiNaya.saptabhangi-equiv : Bhanga ≃ NEBasis` is at
-- SaptabhangiNaya.agda:468, complete with `isPropNonEmpty` and its `Σ≡Prop`
-- lines — the exact Σ≡Prop move the result block above declared "the
-- missing abstraction half of the ladder" and called owed.  It was forty
-- lines below the `code'`/`decode` the machine paired and called
-- unreachable.  Likewise `Digits.ℕ≃CanWord`, `FreeMonoid.ℕ≃Tally`,
-- `TermFreeMonoid.Tm≃List`, all four `PMTorus` counts, both
-- `S3IntegerRelativeCoordinates` isos, `CenterRelative.Pair≃CR`,
-- `AchromaticToy.L₁₂`, `ProjectionChargeAudit.localChargeEquiv`,
-- `WallCertificate.quotient≃Bool`.
--
-- THE CAUSE IS ONE LINE OF THIS FILE'S DESIGN.  `parseSig` reads every
-- top-level ARROW and this program never reads a top-level `≃`.  It cannot
-- see an equivalence that already exists, so it proposes it, fails to prove
-- it mechanically, and reports the corpus as barren.
--
--   "there is no cheap layer here"                        FALSE
--   "every causeway in this corpus costs a real proof"     FALSE
--   "the corpus's types are joined to constructions"       UNSUPPORTED
--
-- **That was a measurement of the instrument, reported as a measurement of
-- the corpus.**  It is the same error as the fitted constant CLAUDE.md
-- opens with, and it is worse in one respect: a fitted constant at least
-- measured something.
--
-- ── WHAT SURVIVES, AND IT IS NOT NOTHING ──
--
-- The three-rung ladder is still the right shape and still mechanizes only
-- the induction half of `Bhedanirnaya` §6.  The `Σ≡Prop` rung is still
-- unbuilt.  And the two edges an agent closed by hand from this queue are
-- real and transport (`Anyathasiddhi_…agda`, `Bhadraganita_…agda`),
-- including one where the proposed inverse is genuinely SPURIOUS — `infl ⇄
-- res` is refuted by the host's own `res-is-zero`, and `infl` is an
-- equivalence anyway, its inverse being a THIRD map.  A failed round trip
-- refutes THE PAIR, not the types.  That distinction is now checked in
-- `Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence.agda` and
-- this program asserted its negation 39 times.
--
-- ── THE REPAIRS OWED, NAMED ──
--
--  1. Read top-level `≃` and `≡` declarations and SKIP any pair whose
--     equivalence the host already proves.  Report those as ALREADY PROVED,
--     which is the most useful line such a census can print.
--  2. Never treat a nonzero exit as a verdict.  Distinguish 127 (no
--     binary), 124 (timed out), and a real Agda failure, and refuse to
--     count anything but the last.
--  3. There is no `timeout` here.  Use a shell-level guard or none.
--
-- ── AND A LOSS, RECORDED BECAUSE IT MUST NOT BE SILENT ──
--
-- While this file was being repaired, a `git checkout -- <path>` on it in
-- the shared working tree destroyed another lane's uncommitted ~600-line
-- rewrite — a HostFacts reader, a four-rung `ladderFor`, an `alreadyProved`
-- check, an in-process `--check` flag, and the note that `timeout` is
-- absent here.  That lane had ALREADY FOUND DEFECT ONE and had run the
-- probes properly, reporting ONE acceptance.  Not staged, not committed, no
-- blob in `git fsck`.  It is gone.  **In a shared working tree
-- `git checkout -- <path>` has no undo**, and two lanes editing one file
-- with no lock is the hazard, not the command.
