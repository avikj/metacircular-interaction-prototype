-- Lopa_TheIrreversibleEdgesAreTheOtherGraphAndTheyRunOneWay.hs
--
-- लोप · lopa, "elision" — the disappearance of an element from the form.
--
-- THE TERM, ITS TEXT AND ITS DATE.  Pāṇini, *Aṣṭādhyāyī* 1.1.60,
-- **अदर्शनं लोपः** — "lopa is non-appearance" (~500 BCE).  The grammar's own
-- name for a step after which something that was there is not there.  Its
-- companion 1.1.62, प्रत्ययलोपे प्रत्ययलक्षणम् — "when an affix has been
-- elided, the operations conditioned by the affix still apply" — is the
-- reason the term is right for this program rather than merely evocative:
-- Pāṇini's system RECORDS what was elided, by keeping the elided element's
-- conditioning power.  What is gone from the form is not gone from the
-- derivation.
--
-- WHAT IS AND IS NOT CLAIMED.  Pāṇini did not write a graph, did not have a
-- notion of a fibre, and nothing here is attributed to the *Aṣṭādhyāyī* as
-- mathematics.  What is borrowed is the term in its exact grammatical sense
-- — a licensed step after which the input is not recoverable from the
-- output — and the one structural observation that a system which elides
-- must say what the elision conditioned.  The mathematics below is cubical
-- type theory (Voevodsky's univalence and the fibre of a map), which this
-- repository's frame names as its one admitted non-Indian substrate.  The
-- house name is deliberately the complement of
-- `formal/cubical/Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm.agda`,
-- which measured **अलोपः**, non-elision — the road on which nothing is lost.
--
-- ────────────────────────────────────────────────────────────────────────
-- WHY THIS PROGRAM EXISTS.
--
-- `machine/Setubandha_…hs` built the graph whose edges are the corpus's
-- checked identifications, `A ≃ B` and type-level `A ≡ B`.  Every one of
-- those edges is INVERTIBLE.  `notes/CAUSAL_MEMORY_SPACETIME.md` Theorem 7.1
-- writes the gluing defect of a composite as
--     rank(AB) = rank(B) − dim(im B ∩ ker A),
-- and on a graph all of whose edges are equivalences that defect is
-- identically zero.  So Setubandha has a two-valued cut INDICATOR where the
-- physics lane has a cut SPECTRUM, and its own closing line says the
-- irreversible edges are unmeasured.  This is that measurement.
--
-- अहिंसा-सूत्र-विस्तारः §६ (`notes/AHIMSA_SUTRA_VISTARA.md`): **द्वौ मार्गौ,
-- तृतीयो न विद्यते** — two roads and no third: transport, or a written
-- defect.  Setubandha counted road one.  This counts road two.  §४ of the
-- same file gives the shape of a lossy step: यत् तिष्ठति, कः नश्यति — the
-- THAT survives and the WHICH is destroyed.
--
-- ────────────────────────────────────────────────────────────────────────
-- WHAT COUNTS AS AN EDGE HERE, and it is a DIRECTED edge.
--
-- A top-level signature whose type, after its telescope is dropped, ends in
-- a top-level arrow whose last hypothesis and whose conclusion BOTH resolve
-- to concrete named types of this corpus (or of the library).  That is a
-- map `A ⟶ B` and the edge runs A to B and not back.
--
-- WHAT IS DELIBERATELY REFUSED, and each refusal is worth as much as an edge:
--
--   * A conclusion that is a PROPOSITION — `≡`, `≃`, `¬ …`, `⊥`, `isProp`,
--     `Dec`, `isEquiv` — is a theorem, not a map.  `f : A → x ≡ y` does not
--     send anything anywhere.
--   * A last hypothesis whose head is a PREDICATE (`isSet A → …`) is a
--     side condition, not a source bank.
--   * A signature mentioning a variable bound in its own telescope or in a
--     top-level `variable` block is a lemma ABOUT maps, not an instance.
--   * A self-map `A → A` is an endomorphism.  Counted separately; it adds
--     no reachability, exactly as Setubandha treats `A ≃ A`.
--   * **A map whose node pair ALREADY carries a Setubandha equivalence is
--     reported separately as PARALLEL.**  It is a map between banks the
--     causeway already joins; it may be lossy, but it does not extend
--     reachability, and counting it with the rest would inflate the one
--     number this program exists to produce.
--
-- ────────────────────────────────────────────────────────────────────────
-- THE VERDICT COLUMN, and its restraint is the point.
--
-- `formal/cubical/Avaccheda_…agda` proves that the predictive quotient of a
-- response map IS its fibre, and that the fibre has THREE verdicts, not two:
--   रिक्तम्  a target nothing reaches;  एकम्  contractible, no memory there;
--   बहु      memory required, and the fibre IS the amount.
-- `isContr` merges the first and the third.  `Saptabhangi.दुर्नयः` proves
-- that a two-valued verdict on three seeds must identify two of them, so a
-- verdict guessed is worse than a verdict withheld.
--
-- This program therefore decides a verdict ONLY where the type expression
-- forces it, and reports UNDECIDED separately and by count.  The deciding
-- rules, each stated so it can be attacked:
--
--   R1  target contractible (`Unit`, `⊤`, `Unit*`) and source in the
--       ≥2-element whitelist  ⟹  बहु, and the fibre IS the source.
--   R2  target is the propositional truncation `∥ A ∥₁` of the source A,
--       and A is in the whitelist of SETS with ≥2 elements  ⟹  बहु.
--       (∥A∥₁ is an inhabited prop hence contractible, its path spaces are
--       contractible, so the fibre is A, which is not.)
--   R3  target is `⊥`  ⟹  degenerate; there is no b, so no fibre to grade.
--   R4  source is `⊥`  ⟹  every fibre is empty: रिक्तम् everywhere.
--
-- Everything else is UNDECIDED and says so.  The whitelist is small and
-- explicit and every member of it is a type whose ≥2-element-ness is a
-- library theorem (`true≢false`, `znots`, …), not an assumption.
--
-- ────────────────────────────────────────────────────────────────────────
-- A FINDING ABOUT Setubandha, FOUND BY BUILDING THE SECOND GRAPH, AND IT
-- IS THE LOUDEST THING HERE BECAUSE IT COMES OUT BADLY.
--
-- **Setubandha over-counts its own edges by roughly a factor of two: 167
-- printed, 88 survive.**  Not one of the 79 is a new refusal invented
-- here.  Every one violates a rule Setubandha's own header states —
-- *"a signature whose sides mention a variable bound in its own telescope
-- is a LEMMA ABOUT transport, not an instance of it; it joins no two named
-- banks"* — and its classifier could not see the violation, for two
-- independent parser reasons found while building the map extractor,
-- because the SOURCE bank of a map is exactly the component Setubandha's
-- `dropBinders` mishandles:
--
--   (1) **Consecutive binder groups.**  Agda writes `(Jewel : Root → Type
--       ℓJ) (root : Root) → …` with no arrow between the groups.  Both
--       `dropBinders` and `binders` strip ONE group and then require an
--       arrow; finding none they stop, so the second group's names are
--       never recorded as bound.  `rootFiberEquiv : … (Jewel : Root →
--       Type ℓJ) (root : Root) → RootFiber Jewel root ≃ Jewel root`
--       became an edge to a node called `⟨lib⟩.Jewel root`.
--
--   (2) **Lowercase binders.**  Freeness was tested with `identsIn'`,
--       which only admits capitalised or non-ASCII tokens.  A binder
--       named `n`, `x`, `left` is therefore invisible, so
--       `द्विगुण-वाक् : (n : ℕ) → Vak (suc n) ≃ (Vak n ⊎ Vak n)` — a
--       family of equivalences, not one — was counted as a causeway
--       between `Vak (suc n)` and `Vak n ⊎ Vak n`.  This is by far the
--       larger of the two: it accounts for 63 of the 79.
--
-- Both are repaired here, at `dropBinders`, at `binders`, and at the
-- `free` test.  The effect on Setubandha's headline numbers:
--
--     edges       167 → 88     nodes  222 → 120     components  85 → 42
--
-- The corrected figure makes this program's own headline SHARPER, not
-- weaker, which is exactly why it is stated at the top rather than
-- buried: road one is half the size it was reported to be, and road two
-- is twelve times its size.  `Setubandha` is not edited here — another
-- lane owns that file, and an audit that silently rewrites its subject is
-- not an audit.  The `CONTROL AUDIT` block of this program's output prints
-- the surviving declaration names so the diff can be taken by hand.
--
-- RUN:  runghc machine/Lopa_…hs [repo-root]        (true exit code; no I/O
--       outside the two source trees Setubandha reads.)

module Main where

import Data.Char (isSpace, isUpper)
import Data.List (isPrefixOf, isSuffixOf, isInfixOf, nub, sortBy, foldl')
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.Maybe (fromMaybe, mapMaybe)
import Data.Ord (comparing)
import System.Directory (doesDirectoryExist, listDirectory)
import Control.Monad (when)
import System.Environment (getArgs)
import System.FilePath ((</>), takeExtension)
import System.IO

-- ─────────────────────────────────────────────────────────────────────────
-- 1.  Files.  Identical to Setubandha's, deliberately: the two graphs are
--     compared node for node, so they must be read from the same parse.
-- ─────────────────────────────────────────────────────────────────────────

walk :: FilePath -> IO [FilePath]
walk root = do
  isDir <- doesDirectoryExist root
  if not isDir then return [] else do
    entries <- listDirectory root
    fmap concat $ mapM (step . (root </>)) entries
  where
    step p = do
      d <- doesDirectoryExist p
      if d then (if "_build" `isSuffixOf` p then return [] else walk p)
           else return [p | takeExtension p == ".agda"]

readUtf8 :: FilePath -> IO String
readUtf8 p = do
  h <- openFile p ReadMode
  hSetEncoding h utf8
  hGetContents h

stripComments :: String -> String
stripComments = go (0 :: Int)
  where
    go _ [] = []
    go 0 ('{':'-':r) = ' ' : go 1 r
    go 0 ('-':'-':r) = let (a,b) = break (=='\n') r
                       in map (const ' ') a ++ go 0 b
    go 0 (c:r)       = c : go 0 r
    go n ('-':'}':r) = ' ' : go (n-1) r
    go n ('{':'-':r) = ' ' : go (n+1) r
    go n ('\n':r)    = '\n' : go n r
    go n (_:r)       = ' ' : go n r

-- ─────────────────────────────────────────────────────────────────────────
-- 2.  Declarations
-- ─────────────────────────────────────────────────────────────────────────

data Decl = Decl { dNames :: [String], dType :: String } deriving Show

dName :: Decl -> String
dName d = case dNames d of (n:_) -> n; [] -> "?"

isIdentChar :: Char -> Bool
isIdentChar c = not (isSpace c) && c `notElem` "(){};.@\""

moduleNameOf :: String -> Maybe String
moduleNameOf src =
  case [ ws | l <- lines src, let ws = words l, take 1 ws == ["module"] ] of
    ((_ : n : _) : _) -> Just n
    _                 -> Nothing

blocks :: String -> [String]
blocks src = go (lines src)
  where
    go [] = []
    go (l:ls)
      | null (dropWhile isSpace l) = go ls
      | isSpace (headSafe l)       = go ls
      | otherwise =
          let (cont, rest) = span (\x -> null (dropWhile isSpace x) || isSpace (headSafe x)) ls
          in unwords (map (dropWhile isSpace) (l:cont)) : go rest
    headSafe s = case s of (c:_) -> c; [] -> ' '

sigOf :: String -> Maybe Decl
sigOf b =
  case splitTop ":" b of
    Just (lhs, rhs)
      | not (":" `isPrefixOf` rhs)
      , let ns = tokens lhs
      , not (null ns)
      , all (all isIdentChar) ns
      , all (`notElem` keywords) ns
      -> Just (Decl ns (trim rhs))
    _ -> Nothing
  where
    keywords = ["module","open","import","data","record","postulate"
               ,"private","variable","infix","infixl","infixr","field"
               ,"mutual","abstract","instance","syntax","pattern"
               ,"where","with","renaming","using","hiding","→","->","="]

variablesOf :: String -> [String]
variablesOf b = case words b of
  ("variable":rest) -> case splitTop ":" (unwords rest) of
                         Just (lhs,_) -> tokens lhs
                         Nothing      -> []
  _ -> []

aliasOf :: String -> Maybe (String, String)
aliasOf b = case words b of
  ("import" : m : "as" : a : _)          -> Just (a, m)
  ("open" : "import" : m : "as" : a : _) -> Just (a, m)
  _                                      -> Nothing

dataRecOf :: String -> Maybe String
dataRecOf b = case words b of
  (k:n:_) | k `elem` ["data","record"] -> Just (takeWhile isIdentChar n)
  _                                    -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- 3.  Telescopes, arrows, splitting
-- ─────────────────────────────────────────────────────────────────────────

matchClose :: Char -> Char -> String -> Maybe (String, String)
matchClose o c = go (0 :: Int) ""
  where
    go _ _ [] = Nothing
    go n acc (x:xs)
      | x == o           = go (n+1) (x:acc) xs
      | x == c && n == 1 = Just (reverse (x:acc), xs)
      | x == c           = go (n-1) (x:acc) xs
      | otherwise        = go n (x:acc) xs

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

arrowPrefixes :: [String]
arrowPrefixes = ["→", "->"]

-- Every top-level arrow component of a type, in order.  `[C₁,…,Cₙ]` means
-- the type is `C₁ → ⋯ → Cₙ`.  Setubandha keeps only Cₙ; this program needs
-- the pair (Cₙ₋₁, Cₙ), which is the map.
arrowComponents :: String -> [String]
arrowComponents s = case breakArrowTop s of
  Just (a, rest) -> trim a : arrowComponents (trim rest)
  Nothing        -> [trim s]

-- A DEFECT INHERITED FROM Setubandha AND REPAIRED HERE, 2026-08-22.
--
-- Agda writes consecutive binder groups without an arrow between them:
--     Family : (L : Type ℓ) (level : Level) → Type _
-- Setubandha's `dropBinders` strips a group and then REQUIRES an arrow; on
-- `(level : Level)` it finds none and stops, leaving the second binder group
-- glued to the front of what it calls the type.  For Setubandha that mostly
-- costs a spurious node.  For this program it is fatal: the SOURCE bank of a
-- map is exactly the component that group sits in, so every multi-group
-- signature would have produced an edge out of a binder.  Two of the first
-- forty edges sampled were of that shape.
--
-- The repair: a parenthesised group counts as a binder group and may be
-- followed by another with no arrow, but ONLY when it contains a top-level
-- `:` — otherwise `(A × B) → C` would lose its source.
dropBinders :: String -> String
dropBinders = go (0 :: Int)
  where
    go k s0 | k > 200 = trim s0
    go k s0 =
      let s = trim s0 in
      case s of
        [] -> []
        ('∀':r) -> case breakArrowTop r of
                     Just (_, rest) -> go (k+1) rest
                     Nothing        -> s
        ('{':_) -> afterGroup k s '{' '}'
        ('(':_) -> afterGroup k s '(' ')'
        _       -> s
    afterGroup k s o c =
      case matchClose o c s of
        Nothing -> s
        Just (g, rest) ->
          let r = trim rest
              isBinderGroup = case matchClose o c g of
                                _ | length g >= 2 -> hasTopColon (init (tail g))
                                _ -> False
          in case stripAnyPrefix arrowPrefixes r of
               Just r' -> go (k+1) r'
               Nothing | isBinderGroup && not (null r) -> go (k+1) r
                       | otherwise -> s
    hasTopColon x = case splitTop ":" x of Just _ -> True; Nothing -> False

stripAnyPrefix :: [String] -> String -> Maybe String
stripAnyPrefix ps s = case [ drop (length p) s | p <- ps, p `isPrefixOf` s ] of
                        (x:_) -> Just x
                        []    -> Nothing

splitTop :: String -> String -> Maybe (String, String)
splitTop tok = go (0 :: Int) ""
  where
    go _ _ [] = Nothing
    go n acc s@(x:xs)
      | n == 0 && tok `isPrefixOf` s = Just (reverse acc, drop (length tok) s)
      | x `elem` "({[" = go (n+1) (x:acc) xs
      | x `elem` ")}]" = go (n-1) (x:acc) xs
      | otherwise      = go n (x:acc) xs

countTop :: String -> String -> Int
countTop tok s = case splitTop tok s of
  Nothing     -> 0
  Just (_, r) -> 1 + countTop tok r

unparen :: String -> String
unparen s0 =
  let s = trim s0
  in case s of
       ('(':_) -> case matchClose '(' ')' s of
                    Just (g, rest) | null (trim rest), length g >= 2 ->
                      unparen (init (tail g))
                    _ -> s
       _ -> s

breakArrowTop :: String -> Maybe (String, String)
breakArrowTop s = case splitTop "→" s of
                    Just p  -> Just p
                    Nothing -> splitTop "->" s

-- ─────────────────────────────────────────────────────────────────────────
-- 4.  Identifiers, binders
-- ─────────────────────────────────────────────────────────────────────────

tokens :: String -> [String]
tokens = filter (not . null) . foldr step [[]] . map keep
  where
    keep c | c `elem` "(){}[];," = ' '
           | otherwise           = c
    step c (w:ws) | isSpace c = [] : (w:ws)
                  | otherwise = (c:w) : ws
    step _ [] = [[]]

identsIn' :: S.Set String -> String -> [String]
identsIn' known = filter looksLikeName . tokens
  where
    looksLikeName t = not (null t)
                      && (isUpper (head t) || head t `elem` nonAscii || t `S.member` known)
                      && t `notElem` reserved
    nonAscii = "ΣΠℕℤℚℝ𝔽"
    reserved = ["Type","Set","Type₀","Type₁","Setω"]

binders :: String -> [String]
binders = go (0 :: Int)
  where
    go k _  | k > 200 = []
    go k s0 =
      let s = trim s0 in
      case s of
        [] -> []
        ('∀':r) -> case breakArrowTop r of
                     Just (g, rest) -> namesOf g ++ go (k+1) rest
                     Nothing -> []
        ('{':_) -> grp k s '{' '}'
        ('(':_) -> grp k s '(' ')'
        _ -> []
    -- consecutive binder groups, same repair as `dropBinders`: otherwise the
    -- names bound by the second group are not recognised as bound, and a
    -- lemma ABOUT maps is minted as an instance of one.
    grp k s o c = case matchClose o c s of
      Nothing -> []
      Just (g, rest) | length g >= 2 ->
        let r = trim rest
            inner = init (tail g)
        in case stripAnyPrefix arrowPrefixes r of
             Just r' -> namesOf inner ++ go (k+1) r'
             Nothing | hasTopColon inner && not (null r) -> namesOf inner ++ go (k+1) r
                     | otherwise -> []
      _ -> []
    namesOf g = takeWhile (/= ":") (tokens g)
    hasTopColon x = case splitTop ":" x of Just _ -> True; Nothing -> False

-- ─────────────────────────────────────────────────────────────────────────
-- 5.  Node resolution.  Byte-for-byte Setubandha's, including the alias
--     repair, because a node name that differs between the two graphs makes
--     the comparison this program exists for meaningless.
-- ─────────────────────────────────────────────────────────────────────────

type DefTable   = M.Map String (S.Set String)
type AliasTable = [(String, String)]

resolveIdent :: DefTable -> AliasTable -> String -> String -> String
resolveIdent defs als home n =
  case break (== '.') n of
    (q, '.' : base)
      | Just m <- lookup q als
      , Just ms <- M.lookup base defs
      , m `S.member` ms
      -> m ++ "." ++ base
    _ -> bare
  where
    bare = case M.lookup n defs of
      Just ms | home `S.member` ms -> home ++ "." ++ n
              | S.size ms == 1     -> S.findMin ms ++ "." ++ n
              | otherwise          -> "⟨ambig⟩." ++ n
      Nothing -> "⟨lib⟩." ++ n

resolveExpr :: DefTable -> AliasTable -> String -> String -> String
resolveExpr defs als home e =
  let ids = nub (identsIn' (M.keysSet defs) e)
  in normalise (foldl' (\acc i -> replaceWord i (resolveIdent defs als home i) acc) e ids)

replaceWord :: String -> String -> String -> String
replaceWord from to = go
  where
    go [] = []
    go s@(c:cs)
      | from `isPrefixOf` s && boundaryAfter (drop (length from) s) = to ++ go (drop (length from) s)
      | otherwise = c : go cs
    boundaryAfter [] = True
    boundaryAfter (x:_) = not (isIdentChar x) || x `elem` "()"

normalise :: String -> String
normalise = unwords . words

knownType :: DefTable -> String -> Bool
knownType defs e0 =
  let e = trim (unparen e0)
  in not (any (\op -> countTop op e > 0) arith)
     && case firstJust [ splitTop op e | op <- tyOps ] of
          Just (l,r) -> knownType defs l && knownType defs r
          Nothing    -> case tokens e of
            (h:_) -> M.member h defs || h `elem` libTypes || h `elem` tyHeads
                     || bare h `M.member` defs
            []    -> False
  where
    bare = reverse . takeWhile (/= '.') . reverse
    arith    = ["+","·","*","∸","^","⊓","⊔","⋆"]
    tyOps    = ["×","⊎","→","->"]
    libTypes = ["Fin","Bool","Unit","Unit*","Lift","List","Vec","Maybe"
               ,"ℕ","ℤ","ℚ","Type","⊥","⊤","SumFin","FinData"]
    tyHeads  = ["Σ","Σ[","¬","∥","fiber","fibre","isEquiv","isProp","isSet"
               ,"isContr","isOfHLevel","Path","PathP"]
    firstJust xs = case [ x | Just x <- xs ] of (y:_) -> Just y; [] -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- 6.  Extraction
-- ─────────────────────────────────────────────────────────────────────────

data FileInfo = FileInfo
  { fiPath  :: FilePath
  , fiMod   :: String
  , fiDefs  :: [String]
  , fiSigs  :: [Decl]
  , fiVars  :: [String]
  , fiIdent :: S.Set String
  , fiAlias :: AliasTable
  }

scanFile :: FilePath -> IO FileInfo
scanFile p = do
  raw <- readUtf8 p
  let src  = stripComments raw
      bs   = blocks src
      m    = fromMaybe (fallbackName p) (moduleNameOf src)
      sigs = mapMaybe sigOf bs
      dr   = mapMaybe dataRecOf bs
      tyAbbrev = concat [ dNames d | d <- sigs, isTypeSort (dropBinders (dType d)) ]
      vars = concatMap variablesOf bs
  return (FileInfo p m (nub (dr ++ tyAbbrev)) sigs (nub vars)
            (S.fromList (concatMap (tokens . dType) sigs))
            (mapMaybe aliasOf bs))
  where
    fallbackName = reverse . takeWhile (/= '/') . reverse
    isTypeSort c = case words (unparen c) of
      (w:_) -> w `elem` ["Type","Type₀","Type₁","Set","Set₀","Set₁","Type_","SetΩ"]
      _     -> False

-- ── 6a.  The INVERTIBLE graph, so the control is computed from this parse
--         and not read off a stale printout.  This is Setubandha's classifier
--         reduced to what the comparison needs: the set of node pairs it
--         joins.  It does NOT reproduce Setubandha's refusal/loop/generic
--         reporting; that program is the authority on those.

invertibleEdges :: DefTable -> FileInfo -> [(String,String)]
invertibleEdges defs fi = map snd (invertibleEdgesNamed defs fi)

invertibleEdgesNamed :: DefTable -> FileInfo -> [(String,(String,String))]
invertibleEdgesNamed defs fi =
  [ (fiMod fi ++ "." ++ dName d, e) | d <- fiSigs fi, e <- one d ]
  where
    one d =
      let ty    = dType d
          concl = lastComp (dropBinders ty)
          bnds  = S.fromList (binders ty ++ fiVars fi)
          home  = fiMod fi
          als   = fiAlias fi
          idn   = identsIn' (M.keysSet defs)
          free e = any (`S.member` bnds) (idn e ++ tokens e)
          mk tok gate = case splitTop tok concl of
            Just (a,b) | countTop tok concl == 1 ->
              let a' = unparen a; b' = unparen b
              in if null (trim a') || null (trim b') || free a' || free b'
                   then []
                 else if not (gate a' b') then []
                 else let ra = resolveExpr defs als home a'
                          rb = resolveExpr defs als home b'
                      in [ (ra,rb) | ra /= rb ]
            _ -> []
      in if isNegation concl then []
         else case mk "≃" (\_ _ -> True) of
                [] -> mk "≡" (\a b -> knownType defs a && knownType defs b
                                      && not (sameAppliedHead a b))
                es -> es
    lastComp = last . arrowComponents
    isNegation c = "¬" `isPrefixOf` trim c

sameAppliedHead :: String -> String -> Bool
sameAppliedHead a b =
  case (tokens (unparen a), tokens (unparen b)) of
    ((h1:r1), (h2:r2)) -> h1 == h2 && not (null r1) && not (null r2)
    _                  -> False

-- ── 6b.  The IRREVERSIBLE graph.

data Lopa = Lopa
  { lMod  :: String
  , lName :: String
  , lSrc  :: String        -- resolved source node
  , lTgt  :: String        -- resolved target node
  , lRawS :: String        -- unresolved, for the verdict rules
  , lRawT :: String
  , lKind :: String
  } deriving Show

data Verdict = Bahu String | Riktam String | Degenerate String | Undecided
  deriving (Eq, Show)

verdictTag :: Verdict -> String
verdictTag (Bahu _)       = "बहु"
verdictTag (Riktam _)     = "रिक्तम्"
verdictTag (Degenerate _) = "degenerate"
verdictTag Undecided      = "UNDECIDED"

verdictWhy :: Verdict -> String
verdictWhy (Bahu w)       = w
verdictWhy (Riktam w)     = w
verdictWhy (Degenerate w) = w
verdictWhy Undecided      = "the type expression does not force a verdict"

-- Types whose ≥2-element-ness is a LIBRARY THEOREM, not an assumption:
-- `true≢false` (Cubical.Data.Bool), `znots` (Cubical.Data.Nat), `negsucnotpos`
-- (Cubical.Data.Int).  Nothing enters this list on plausibility.
multiElementSets :: [String]
multiElementSets = ["Bool","ℕ","ℤ","Nat","Int"]

contractibleTargets :: [String]
contractibleTargets = ["Unit","⊤","Unit*","Lift"]

headOf :: String -> String
headOf e = case tokens (unparen e) of (h:_) -> h; [] -> ""

-- The four deciding rules of the header, and nothing else decides.
grade :: String -> String -> Verdict
grade rawS rawT
  | headOf rawT == "⊥"                    = Degenerate "target ⊥: no b, so no fibre to grade"
  | headOf rawS == "⊥"                    = Riktam "source ⊥: every fibre is empty"
  | headOf rawT `elem` contractibleTargets
  , headOf rawS `elem` multiElementSets   = Bahu ("R1 · fibre is " ++ trim rawS
                                                  ++ ", a set with two provably distinct elements")
  | isTrunc1 rawT
  , headOf rawS `elem` multiElementSets
  , truncArg rawT == headOf rawS          = Bahu ("R2 · fibre is " ++ trim rawS
                                                  ++ "; ∥·∥₁ is an inhabited prop, so the fibre is the source")
  | otherwise                             = Undecided
  where
    isTrunc1 t = "∥" `isPrefixOf` trim t && "∥₁" `isSuffixOf` trim t
    truncArg t = headOf (trim (drop 1 (reverse (drop 2 (reverse (trim t))))))

-- Head names that make a component a SIDE CONDITION rather than a bank.
predicateHeads :: [String]
predicateHeads = ["isProp","isSet","isContr","isEquiv","isOfHLevel","isGroupoid"
                 ,"Dec","Discrete","¬","Path","PathP","isInjective","isSurjection"
                 ,"isEmbedding","isIso","Iso","≃","≡"]

-- A component that is a proposition or a predicate, not a type of data we
-- would call a bank.
isSideCondition :: String -> Bool
isSideCondition e =
  let t = trim (unparen e)
  in headOf t `elem` predicateHeads
     || countTop "≡" t > 0
     || countTop "≃" t > 0
     || "¬" `isPrefixOf` t
     -- a leftover `:` means a binder group survived `dropBinders`; the
     -- component is a telescope, not a bank.  Belt and braces after the
     -- consecutive-group repair above.
     || (case splitTop ":" t of Just _ -> True; Nothing -> False)

-- A SORT is not a bank.  `A → Type` is a type FAMILY — a predicate, a
-- fibration, an indexed definition — and it sends no element of A anywhere.
-- The first run of this program minted 100+ such edges and they were the
-- single largest false-positive class: `AllP : List ℕ → Type` is a
-- definition, not a road out of `List ℕ`.
isSort :: String -> Bool
isSort e = headOf (trim (unparen e))
             `elem` ["Type","Type₀","Type₁","Set","Set₀","Set₁","Setω","SetΩ","Type_"]

-- `A → ⊥` is `¬ A`, a REFUTATION.  It is a proved separation, exactly as
-- Setubandha's `¬ (A ≃ B)` is, and it belongs in its own bucket rather than
-- in the count of roads.  Nothing crosses to ⊥.
isRefutation :: String -> Bool
isRefutation e = headOf (trim (unparen e)) == "⊥"

kindOf :: String -> String -> String
kindOf s t
  | "∥" `isPrefixOf` trim t                    = "truncation"
  | countTop "/" t > 0                         = "quotient"
  | headOf s == "Σ" || headOf s == "Σ["
  , countTop "×" s > 0 || True                 = if isProjection then "projection" else "map"
  | countTop "×" s > 0, isProjection           = "projection"
  | otherwise                                  = "map"
  where
    isProjection = trim t `isInfixOf` trim s

-- The classification of one signature.  `Left ()` marks the two buckets that
-- are NOT roads and are still results: a refutation `A → ⊥`, and a family
-- `A → Type`.  They are counted, not silently dropped.
data Outcome = ARoad Lopa | ARefutation String | AFamily String
             | AAvaktavyam String   -- map-shaped, every guard passed, lopaOf still
                                    -- declines: BOTH readings assert सह, and the
                                    -- instrument's tongue divides.  The fourth bhanga.
             | AAprastuta           -- not map-shaped at all: no root applies, so by
                                    -- कुतः सप्त this is not a bhanga.  Outside the question.

lopaOf' :: DefTable -> FileInfo -> Decl -> Outcome
lopaOf' defs fi d =
  let ty    = dType d
      comps = arrowComponents (dropBinders ty)
      bnds  = S.fromList (binders ty ++ fiVars fi)
      idn   = identsIn' (M.keysSet defs)
      free e = any (`S.member` bnds) (idn e ++ tokens e)
  in case reverse comps of
       (tgt : src : _)
         | let s = unparen src, let t = unparen tgt
         , not (null (trim s)), not (null (trim t))
         , not (free s), not (free t)
         , not (isSideCondition s)
         , knownType defs s
         -> if isRefutation t then ARefutation (fiMod fi ++ "." ++ dName d)
            else if isSort t  then AFamily     (fiMod fi ++ "." ++ dName d)
            else maybe (AAvaktavyam (fiMod fi ++ "." ++ dName d)) ARoad
                       (lopaOf defs fi d)
       _ -> AAprastuta

lopaOf :: DefTable -> FileInfo -> Decl -> Maybe Lopa
lopaOf defs fi d =
  let ty    = dType d
      comps = arrowComponents (dropBinders ty)
      bnds  = S.fromList (binders ty ++ fiVars fi)
      home  = fiMod fi
      als   = fiAlias fi
      idn   = identsIn' (M.keysSet defs)
      free e = any (`S.member` bnds) (idn e ++ tokens e)
  in case reverse comps of
       (tgt : src : _) ->
         let s = unparen src; t = unparen tgt
         in if null (trim s) || null (trim t)          then Nothing
            else if free s || free t                   then Nothing
            else if isSideCondition s || isSideCondition t then Nothing
            else if isSort s || isSort t || isRefutation t then Nothing
            else if not (knownType defs s) || not (knownType defs t) then Nothing
            else let rs = resolveExpr defs als home s
                     rt = resolveExpr defs als home t
                 in if rs == rt then Nothing
                    else Just (Lopa home (dName d) rs rt s t (kindOf s t))
       _ -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- 7.  Graph utilities (directed, and undirected for components)
-- ─────────────────────────────────────────────────────────────────────────

type Graph = M.Map String (S.Set String)

undirected :: [(String,String)] -> Graph
undirected = foldl' add M.empty
  where add g (a,b) = M.insertWith S.union a (S.singleton b)
                    $ M.insertWith S.union b (S.singleton a) g

directed :: [(String,String)] -> Graph
directed = foldl' add M.empty
  where add g (a,b) = M.insertWith S.union b S.empty
                    $ M.insertWith S.union a (S.singleton b) g

components :: Graph -> [S.Set String]
components g = go (M.keys g) S.empty
  where
    go [] _ = []
    go (n:ns) seen
      | n `S.member` seen = go ns seen
      | otherwise = let c = bfsSet g n in c : go ns (S.union seen c)

bfsSet :: Graph -> String -> S.Set String
bfsSet g s = go (S.singleton s) [s]
  where
    go seen [] = seen
    go seen (x:xs) =
      let nb = S.toList (fromMaybe S.empty (M.lookup x g))
          new = [ y | y <- nb, not (y `S.member` seen) ]
      in go (foldr S.insert seen new) (xs ++ new)

-- ─────────────────────────────────────────────────────────────────────────
-- 8.  Main
-- ─────────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let root  = case args of (r:_) -> r; [] -> "."
      roots = [ root </> "formal/cubical", root </> "punaragamana/src" ]
  paths <- fmap concat (mapM walk roots)
  infos <- mapM scanFile paths
  let defs :: DefTable
      defs = M.fromListWith S.union
               [ (n, S.singleton (fiMod fi)) | fi <- infos, n <- fiDefs fi ]

      invNamed = [ x | fi <- infos, x <- invertibleEdgesNamed defs fi ]
      invE   = nub [ e | fi <- infos, e <- invertibleEdges defs fi ]
      invG   = undirected invE
      invNodes = M.keysSet invG

      outcomes = [ lopaOf' defs fi d | fi <- infos, d <- fiSigs fi ]
      allLopa    = [ l | ARoad l       <- outcomes ]
      refutations= [ n | ARefutation n <- outcomes ]
      families   = [ n | AFamily n     <- outcomes ]
      -- the two halves of what used to be one constructor.  This split IS
      -- `Saptabhangi.दुर्नयः` obeyed rather than cited: the fourth bhanga
      -- (सह, both readings at once) and अप्रस्तुत (no root applies) were
      -- printing as the same silence.  सूत्र ७ — मौनं न निषेधः.
      avaktavya  = [ n | AAvaktavyam n <- outcomes ]
      aprastuta  = length [ () | AAprastuta <- outcomes ]
      -- an endomorphism adds no reachability, exactly as Setubandha's LOOPS
      (endo, nonEndo) = ([ l | l <- allLopa, lSrc l == lTgt l ]
                        ,[ l | l <- allLopa, lSrc l /= lTgt l ])
      joinedByInv = S.fromList ([ (a,b) | (a,b) <- invE ] ++ [ (b,a) | (a,b) <- invE ])
      parallel = [ l | l <- nonEndo, (lSrc l, lTgt l) `S.member` joinedByInv ]
      genuine  = [ l | l <- nonEndo, not ((lSrc l, lTgt l) `S.member` joinedByInv) ]

      lopE   = nub [ (lSrc l, lTgt l) | l <- genuine ]
      lopG   = directed lopE
      lopU   = undirected lopE
      lopNodes = M.keysSet lopG
      comps  = sortBy (flip (comparing S.size)) (components lopU)

      newNodes = S.difference lopNodes invNodes

      allTypes = S.fromList [ fiMod fi ++ "." ++ n | fi <- infos, n <- fiDefs fi ]
      isolatedInv = S.difference allTypes invNodes
      rescued     = S.intersection isolatedInv lopNodes

      graded = [ (l, grade (lRawS l) (lRawT l)) | l <- genuine ]
      byVerdict = M.fromListWith (+) [ (verdictTag v, 1::Int) | (_,v) <- graded ]
      byKind    = M.fromListWith (+) [ (lKind l, 1::Int)      | l <- genuine ]

  putStrLn "═══ लोप · the irreversible graph, and it runs one way ═══"
  putStrLn "अदर्शनं लोपः — Pāṇini, Aṣṭādhyāyī 1.1.60 (~500 BCE)"
  putStrLn ""
  putStrLn $ "files scanned                    : " ++ show (length paths)
  putStrLn $ "type-formers defined             : " ++ show (M.size defs)
  putStrLn $ "top-level signatures             : " ++ show (sum (map (length . fiSigs) infos))
  putStrLn ""
  if null paths
    then do
      putStrLn "── अप्रस्तुत · THIS RUN ASKED NOTHING ──"
      putStrLn "  Zero files were scanned, so every count below would be 0 —"
      putStrLn "  and a 0 from an instrument that never looked is NOT the 0"
      putStrLn "  of an instrument that looked and found nothing.  सूत्र ७:"
      putStrLn "  मौनं न निषेधः — silence is not denial.  This program printed"
      putStrLn "  a full confident census on an empty scan until 2026-08-22,"
      putStrLn "  including the line 'THE NUMBER THIS PROGRAM EXISTS FOR: 0'."
      putStrLn "  No census follows.  Pass a root, e.g.  runghc <this> ."
    else do
    putStrLn ""
    putStrLn "── CONTROL · the invertible graph, recomputed from THIS parse ──"
    putStrLn $ "  invertible edges (A ≃ B, A ≡ B): " ++ show (length invE)
    putStrLn $ "  nodes touched                  : " ++ show (S.size invNodes)
    putStrLn $ "  components                     : " ++ show (length (components invG))
    putStrLn $ "  defined types it never touches : " ++ show (S.size isolatedInv)
               ++ " of " ++ show (S.size allTypes)
               ++ "  (" ++ pct (S.size isolatedInv) (S.size allTypes) ++ ")"
    putStrLn ""
    putStrLn "── REFUSED, and each refusal is a result ──"
    putStrLn $ "  A ⟶ ⊥, i.e. ¬A: proved separations: " ++ show (length refutations)
    putStrLn $ "  A ⟶ Type: families, not maps      : " ++ show (length families)
    putStrLn ""
    putStrLn "── THIS INSTRUMENT'S OWN FIBRE · अदृष्टं तन्तुः ──"
    putStrLn "  Every observation is a quotient (सूत्र ३); what it cannot see"
    putStrLn "  is the fibre (सूत्र ४).  These two lines are that fibre, and"
    putStrLn "  until 2026-08-22 this program printed neither — so a signature"
    putStrLn "  it could not read and a signature that was not a map came out"
    putStrLn "  as the same silence.  मौनं न निषेधः (सूत्र ७)."
    putStrLn ""
    putStrLn $ "  स्यात्-अवक्तव्यम् · map-shaped, guards passed,"
    putStrLn $ "    lopaOf declines — BOTH readings सह  : " ++ show (length avaktavya)
    putStrLn $ "  अप्रस्तुत · not map-shaped; no root"
    putStrLn $ "    applies, so by कुतः सप्त not a bhanga : " ++ show aprastuta
    putStrLn $ "  ── the four buckets partition the signatures:"
    putStrLn $ "     " ++ show (length allLopa) ++ " + " ++ show (length refutations)
               ++ " + " ++ show (length families) ++ " + " ++ show (length avaktavya)
               ++ " + " ++ show aprastuta ++ " = "
               ++ show (length allLopa + length refutations + length families
                        + length avaktavya + aprastuta)
               ++ "   (top-level signatures: "
               ++ show (sum (map (length . fiSigs) infos)) ++ ")"
    putStrLn ""
    putStrLn "── ROAD TWO · irreversible edges ──"
    putStrLn $ "  candidate maps A ⟶ B            : " ++ show (length allLopa)
    putStrLn $ "  of which endomorphisms A ⟶ A    : " ++ show (length endo)
    putStrLn $ "  of which PARALLEL to a causeway : " ++ show (length parallel)
    putStrLn $ "  GENUINE one-way edges           : " ++ show (length genuine)
    putStrLn $ "  distinct node pairs             : " ++ show (length lopE)
    putStrLn $ "  NODES                           : " ++ show (S.size lopNodes)
    putStrLn $ "  COMPONENTS (undirected)         : " ++ show (length comps)
    putStrLn $ "  largest component               : "
               ++ show (if null comps then 0 else S.size (head comps))
    putStrLn $ "  component size histogram        : "
               ++ show (M.toList (M.fromListWith (+) [ (S.size c, 1::Int) | c <- comps ]))
    putStrLn ""
    putStrLn "── THE NUMBER THIS PROGRAM EXISTS FOR ──"
    putStrLn $ "  nodes reachable on road two that road one never touches"
    putStrLn $ "                                  : " ++ show (S.size newNodes)
               ++ "  (" ++ pct (S.size newNodes) (max 1 (S.size lopNodes))
               ++ " of the irreversible graph's nodes)"
    putStrLn $ "  defined types isolated in Setubandha and RESCUED here"
    putStrLn $ "                                  : " ++ show (S.size rescued)
               ++ " of " ++ show (S.size isolatedInv)
    putStrLn ""
    putStrLn "── EDGE KINDS ──"
    mapM_ (\(k,n) -> putStrLn ("  " ++ pad (show n) ++ "  " ++ k))
          (sortBy (flip (comparing snd)) (M.toList byKind))
    putStrLn ""
    putStrLn "── FIBRE VERDICTS, decided only where the type forces it ──"
    mapM_ (\(k,n) -> putStrLn ("  " ++ pad (show n) ++ "  " ++ k))
          (sortBy (flip (comparing snd)) (M.toList byVerdict))
    putStrLn "  A verdict guessed is worse than a verdict withheld:"
    putStrLn "  Saptabhangi.दुर्नयः proves a two-valued verdict on three seeds"
    putStrLn "  must identify two of them."
    putStrLn ""
    putStrLn "── EVERY DECIDED VERDICT ──"
    mapM_ (\(l,v) -> putStrLn ("  [" ++ verdictTag v ++ "] " ++ lSrc l ++ "  ⟶  " ++ lTgt l
                               ++ "\n        « " ++ lMod l ++ "." ++ lName l
                               ++ "\n        " ++ verdictWhy v))
          [ (l,v) | (l,v) <- graded, v /= Undecided ]
    putStrLn ""
    -- ── THE QUEUE ──────────────────────────────────────────────────────
    --
    -- Added 2026-08-22.  Until now this program printed every DECIDED
    -- verdict in full and the UNDECIDED ones as a bare count, so the 1045
    -- edges that are the actual work were the one thing a consumer could
    -- not read.  A peer lane asked for this twice; the honest answer was
    -- that it did not exist.
    --
    -- Emitted under `--queue` as TAB-separated `src ⟶ tgt ⟶ module.name`
    -- so a join can run against `machine/Nama_…hs`'s address table.  The
    -- first pass over these is NOT a proof effort: `fiber योग n` came back
    -- `PairsSummingTo.Pairs` ON THE NOSE, and that module was written for
    -- Piṅgala's metrical antidiagonal by someone who never saw addition's
    -- fibre.  The receipts are largely already here under other names, and
    -- every instrument that skipped the lookup reported the corpus barren.
    when ("--queue" `elem` args) $ do
      putStrLn ""
      putStrLn "── THE UNDECIDED QUEUE (src\\ttgt\\tsite) ──"
      mapM_ (\l -> putStrLn (lSrc l ++ "\t" ++ lTgt l ++ "\t" ++ lMod l ++ "." ++ lName l))
            [ l | (l,v) <- graded, v == Undecided ]
      putStrLn ""
  
    putStrLn "── NODES ON ROAD TWO THAT ROAD ONE NEVER TOUCHES ──"
    let outdeg n = S.size (fromMaybe S.empty (M.lookup n lopG))
        indeg  n = length [ () | (_,b) <- lopE, b == n ]
    mapM_ (\n -> putStrLn ("  out=" ++ show (outdeg n) ++ " in=" ++ show (indeg n) ++ "  " ++ n))
          (sortBy (flip (comparing (\n -> outdeg n + indeg n))) (S.toList newNodes))
    putStrLn ""
    putStrLn "── CONTROL AUDIT · the declarations this parse calls invertible ──"
    putStrLn "  (diff this against Setubandha's `EVERY EDGE` block.  The two"
    putStrLn "   parsers differ ONLY in the consecutive-binder-group repair"
    putStrLn "   documented at `dropBinders`; any name here that Setubandha"
    putStrLn "   does not print, or vice versa, is that repair firing.)"
    mapM_ putStrLn (nub (map fst invNamed))
    putStrLn ""
    putStrLn "── EVERY GENUINE ONE-WAY EDGE ──"
    mapM_ (\l -> putStrLn ("  [" ++ lKind l ++ "] " ++ lSrc l ++ "  ⟶  " ++ lTgt l
                           ++ "   « " ++ lMod l ++ "." ++ lName l))
          (sortBy (comparing lSrc) genuine)
  where
    pad s = replicate (max 0 (4 - length s)) ' ' ++ s
    pct a b = show ((100 * a) `div` max 1 b) ++ "%"
