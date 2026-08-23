-- Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodesAreTheFrontier.hs
--
-- सेतुबन्ध · setu-bandha, "the binding of a causeway".
--
-- THE TERM, ITS TEXT AND ITS DATE.  `setu` (सेतु) is ordinary Sanskrit for a
-- dam, dyke or causeway and is Vedic -- Ṛgveda 10.53.8 uses it in the sense
-- of a crossing built so that others may pass.  The compound `setu-bandha`
-- is the building of the causeway to Laṅkā, Vālmīki, *Rāmāyaṇa*,
-- Yuddhakāṇḍa, sargas 22-23 (date of the text disputed; the Yuddhakāṇḍa is
-- conventionally placed in the last centuries BCE).
--
-- WHAT IS AND IS NOT CLAIMED.  Nothing mathematical is claimed of either
-- source.  Vālmīki did not build a graph and the Ṛgveda is not a theory of
-- transport.  The word is used here in its plain sense and for one property
-- of it that is load-bearing for this program: a causeway is worth naming
-- only where the two banks are otherwise unjoined, and its value is that
-- everything which crosses it crosses once and thereafter for everybody.
-- That is exactly the claim about a checked `A ≃ B`.  Per CLAUDE.md's second
-- naming condition: the mathematics here originates in cubical type theory
-- (Voevodsky's univalence, which this repository's own frame names as the
-- one admitted non-Indian substrate), not in the Rāmāyaṇa.
--
-- WHAT THE PROGRAM DOES.  It reads every `.agda` file under
-- `formal/cubical/` and `punaragamana/src/`, extracts the top-level type
-- signatures whose CONCLUSION is an identification between two TYPES, and
-- emits the graph whose nodes are those types and whose edges are the
-- modules that identify them.  It then reports components, diameter, the
-- largest component, and the isolated nodes: types this corpus defines that
-- nothing identifies with anything.
--
-- WHAT IT DELIBERATELY REFUSES TO CALL AN EDGE, and why each refusal is
-- worth as much as an edge (नयभेदे सङ्क्षेपो न विद्यते):
--
--   * A signature whose sides mention a variable bound in its own telescope
--     (`{A B : Type ℓ} → A ≃ B → ...`) is a LEMMA ABOUT transport, not an
--     instance of it.  It joins no two named banks.
--   * A self-identification (`Bool ≃ Bool`, `G₁ ≃ G₁`) is an automorphism.
--     It is counted and reported separately; it adds no reachability.
--   * A refutation (`¬ (A ≃ B)`) is a NON-edge and is reported as one.  A
--     proved separation is a fact about the graph and must never be silently
--     dropped into the same bucket as an unproved absence.
--   * Two types with the SAME NAME in DIFFERENT MODULES are two nodes, not
--     one.  Six Ratri modules each declare `censusΣ ≃ CensusBase`; those are
--     six edges between twelve nodes, not one edge repeated.  Names are
--     resolved to the module that defines them; a name defined in no module
--     of the corpus is resolved to a single `⟨lib⟩` node, because the
--     library's `Fin` really is one type.
--
-- RUN:  runghc machine/Setubandha_...hs [repo-root]

module Main where

import Data.Char (isSpace, isUpper, isDigit)
import Data.List (isPrefixOf, isSuffixOf, isInfixOf, sort, nub, sortBy, foldl', intercalate)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.Maybe (fromMaybe, mapMaybe, catMaybes)
import Data.Ord (comparing)
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.FilePath ((</>), takeExtension)
import System.IO

-- ─────────────────────────────────────────────────────────────────────────
-- 1.  Files
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

-- ─────────────────────────────────────────────────────────────────────────
-- 2.  Lexical clean-up: strip block and line comments, keep line structure
-- ─────────────────────────────────────────────────────────────────────────

stripComments :: String -> String
stripComments = go (0 :: Int)
  where
    go _ [] = []
    go 0 ('{':'-':r)             = ' ' : go 1 r
    go 0 ('-':'-':r)             = let (a,b) = break (=='\n') r
                                   in map (const ' ') a ++ go 0 b
    go 0 (c:r)                   = c : go 0 r
    go n ('-':'}':r)             = ' ' : go (n-1) r
    go n ('{':'-':r)             = ' ' : go (n+1) r
    go n ('\n':r)                = '\n' : go n r
    go n (_:r)                   = ' ' : go n r

-- ─────────────────────────────────────────────────────────────────────────
-- 3.  Top-level declarations
-- ─────────────────────────────────────────────────────────────────────────

data Decl = Decl { dNames :: [String], dType :: String } deriving Show

dName :: Decl -> String
dName d = case dNames d of (n:_) -> n; [] -> "?"

isIdentChar :: Char -> Bool
isIdentChar c = not (isSpace c) && c `notElem` "(){};.@\""

-- A module's own module name, from `module X where`.
moduleNameOf :: String -> Maybe String
moduleNameOf src =
  case [ ws | l <- lines src, let ws = words l, take 1 ws == ["module"] ] of
    (( _ : n : _) : _) -> Just n
    _                  -> Nothing

-- Split the source into top-level "blocks": a column-0 line plus its
-- indented continuation lines.
blocks :: String -> [String]
blocks src = go (lines src)
  where
    go [] = []
    go (l:ls)
      | null (dropWhile isSpace l) = go ls
      | isSpace (head l)           = go ls           -- orphan continuation
      | otherwise =
          let (cont, rest) = span (\x -> null (dropWhile isSpace x) || isSpace (head x)) ls
          in unwords (map (dropWhile isSpace) (l:cont)) : go rest

-- A signature block:  name : type
-- Agda allows `G₁ G₂ G₃ : Type₀` -- several names, one type.  Missing this
-- cost the first run three nodes and merged six others; it is the reason the
-- resolution table has to be built from the same parse as the edges.
sigOf :: String -> Maybe Decl
sigOf b =
  case splitTop ":" b of
    Just (lhs, rhs)
      | not (":" `isPrefixOf` rhs)                       -- not `::`
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

-- `variable A B : Type ℓ` at column 0 introduces IMPLICIT binders that are
-- generalised into every signature below.  A signature mentioning one is a
-- lemma about transport, not an edge, and the first run of this program
-- silently minted `⟨lib⟩.A` nodes for them.
variablesOf :: String -> [String]
variablesOf b = case words b of
  ("variable":rest) -> case splitTop ":" (unwords rest) of
                         Just (lhs,_) -> tokens lhs
                         Nothing      -> []
  _ -> []

-- `import M as X`, with or without a leading `open`.  The alias is the only
-- way an Agda module can mention two types of the SAME NAME at once, which
-- is precisely the shape of every duplication this program's frontier report
-- flags; see the note at `resolveIdent`.
aliasOf :: String -> Maybe (String, String)
aliasOf b = case words b of
  ("import" : m : "as" : a : _)          -> Just (a, m)
  ("open" : "import" : m : "as" : a : _) -> Just (a, m)
  _                                      -> Nothing

-- `[open] import M using (n1 ; n2 ; …)` binds each named identifier to the
-- module M it is imported from.  This is PRATYAKṢA for the resolver: a third
-- module that writes `open import Punaragamanam using (Carrier)` has stated
-- WHICH `Carrier` it means, and a reader that ignores the import and resolves
-- the bare name to ⟨ambig⟩ is doing anumāna where the qualified identity was
-- available directly.  Added 2026-08-23: the machine named `⟨ambig⟩.Carrier
-- योग` as load-bearing in its own spine, and the identity was in the imports
-- the whole time.
usingOf :: String -> [(String, String)]
usingOf b = case words b of
  ("import" : m : "using" : rest)         -> bind m rest
  ("open" : "import" : m : "using" : rest) -> bind m rest
  _                                        -> []
  where
    bind m rest = [ (n, m) | n <- namesInParens (unwords rest) ]
    namesInParens s = case dropWhile (/= '(') s of
      ('(':r) -> filter (not . null) (splitSemi (takeWhile (/= ')') r))
      _       -> []
    splitSemi = words . map (\c -> if c == ';' then ' ' else c)

-- A type-former declaration: `data N ...`, `record N ...`
dataRecOf :: String -> Maybe String
dataRecOf b = case words b of
  (k:n:_) | k `elem` ["data","record"] -> Just (takeWhile isIdentChar n)
  _                                    -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- 4.  Telescope stripping and top-level splitting
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

-- The conclusion of a signature.  Two steps, and the second one is the
-- one that matters: `→` binds LOOSER than `≡` and `≃`, so
--     पूर्णता : (n : ℕ) (ds : छन्दस्) → मात्रा ds ≡ n → छन्द-∈ ds (सर्व n)
-- has conclusion `छन्द-∈ ds (सर्व n)` and its `≡` is an ELEMENT-level
-- hypothesis.  The first run of this program read it as an identification of
-- types and minted four edges that do not exist.  Anything left of the last
-- top-level arrow is a hypothesis, not a conclusion.
conclusion :: String -> String
conclusion = lastArrowComponent . dropBinders

lastArrowComponent :: String -> String
lastArrowComponent s = case breakArrowTop s of
  Just (_, rest) -> lastArrowComponent (trim rest)
  Nothing        -> trim s

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
        Just (_, rest) ->
          let r = trim rest
          in case stripAnyPrefix arrowPrefixes r of
               Just r' -> go (k+1) r'
               Nothing -> s

stripAnyPrefix :: [String] -> String -> Maybe String
stripAnyPrefix ps s = case [ drop (length p) s | p <- ps, p `isPrefixOf` s ] of
                        (x:_) -> Just x
                        []    -> Nothing

-- Split a string on a top-level (paren/brace-depth-0) occurrence of a token.
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
  Nothing      -> 0
  Just (_, r)  -> 1 + countTop tok r

unparen :: String -> String
unparen s0 =
  let s = trim s0
  in case s of
       ('(':_) -> case matchClose '(' ')' s of
                    Just (g, rest) | null (trim rest) -> unparen (init (tail g))
                    _ -> s
       _ -> s

-- ─────────────────────────────────────────────────────────────────────────
-- 5.  Identifiers occurring in a type expression
-- ─────────────────────────────────────────────────────────────────────────

tokens :: String -> [String]
tokens = filter (not . null) . foldr step [[]] . map keep
  where
    keep c | c `elem` "(){}[];," = ' '
           | otherwise           = c
    step c (w:ws) | isSpace c = [] : (w:ws)
                  | otherwise = (c:w) : ws
    step _ [] = [[]]

-- Names occurring in a type expression.  A name counts if it is capitalised
-- (the usual Agda convention for a type) OR if this corpus is known to define
-- it as a type -- `censusΣ` is lowercase and is a type, and treating case as
-- the criterion merged six distinct `censusΣ`s into one node.
identsIn' :: S.Set String -> String -> [String]
identsIn' known = filter looksLikeName . tokens
  where
    looksLikeName t = not (null t)
                      && (isUpper (head t) || head t `elem` nonAscii || t `S.member` known)
                      && t `notElem` reserved
    nonAscii = "ΣΠℕℤℚℝ𝔽"
    reserved = ["Type","Set","Type₀","Type₁","Setω"]

identsIn :: String -> [String]
identsIn = identsIn' S.empty

-- Binder names introduced by the telescope of a signature.
binders :: String -> [String]
binders = go (0 :: Int)
  where
    go k s0 | k > 200 = []
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
    grp k s o c = case matchClose o c s of
      Nothing -> []
      Just (g, rest) ->
        let r = trim rest
        in case stripAnyPrefix arrowPrefixes r of
             Just r' -> namesOf (init (tail g)) ++ go (k+1) r'
             Nothing -> []
    namesOf g = takeWhile (/= ":") (tokens g)

breakArrowTop :: String -> Maybe (String, String)
breakArrowTop s = case splitTop "→" s of
                    Just p  -> Just p
                    Nothing -> splitTop "->" s

-- ─────────────────────────────────────────────────────────────────────────
-- 6.  Node resolution
-- ─────────────────────────────────────────────────────────────────────────

-- defTable : type-name  ->  set of modules that define it as a TYPE
type DefTable = M.Map String (S.Set String)

-- aliasTable : the `import M as X` bindings of ONE file, as (X, M).
type AliasTable = [(String, String)]

-- A DEFECT FOUND BY WALKING THE FRONTIER THIS PROGRAM PRINTS, 2026-08-22.
--
-- `tokens` keeps a dot inside a token, so `A.सप्तभङ्गी` arrives here whole,
-- misses the definition table (which is keyed by BARE names), and lands on
-- the `⟨lib⟩` branch as `⟨lib⟩.A.सप्तभङ्गी`.  That is not a cosmetic
-- misnaming.  This program's own frontier report names three separate
-- `सप्तभङ्गी`, three `जाल`, three `समासः`, two `वल्ली` as the corpus's
-- duplication to be resolved -- and the ONLY way to write an Agda module
-- joining two types of the SAME NAME is `import X as A` / `import Y as B`.
-- So the program was structurally unable to see any causeway built between
-- exactly the nodes it was pointing at, and would have gone on reporting
-- them as isolated after they were joined.  A frontier list that cannot
-- observe its own frontier being closed is worse than no list.
--
-- The repair resolves a one-segment qualifier through the file's alias
-- table.  A fully-written `NaturalMachine.FreeMonoid.Tally` is untouched:
-- its first segment is not an alias, so it falls through to the behaviour
-- that was already there.
resolveIdent :: DefTable -> AliasTable -> [(String, String)] -> String -> String -> String
resolveIdent defs als usng home n =
  case break (== '.') n of
    (q, '.' : base)
      | Just m <- lookup q als
      , Just ms <- M.lookup base defs
      , m `S.member` ms
      -> m ++ "." ++ base
    _ -> viaUsing
  where
    -- pratyakṣa: if this file `using`-imports the bare name from a module that
    -- defines it, that IS the identity — resolve there rather than to ⟨ambig⟩.
    viaUsing = case lookup n usng of
      Just m | Just ms <- M.lookup n defs, m `S.member` ms -> m ++ "." ++ n
      _ -> bare
    bare = case M.lookup n defs of
      Just ms | home `S.member` ms -> home ++ "." ++ n
              | S.size ms == 1     -> S.findMin ms ++ "." ++ n
              | otherwise          -> "⟨ambig⟩." ++ n
      Nothing -> "⟨lib⟩." ++ n

-- Render a type expression with every identifier resolved, so that the same
-- expression written in two modules becomes the same node.
resolveExpr :: DefTable -> AliasTable -> [(String, String)] -> String -> String -> String
resolveExpr defs als usng home e =
  let ids = nub (identsIn' (M.keysSet defs) e)
  in normalise (foldl' (\acc i -> replaceWord i (resolveIdent defs als usng home i) acc) e ids)

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

-- ─────────────────────────────────────────────────────────────────────────
-- 7.  Extraction
-- ─────────────────────────────────────────────────────────────────────────

data Finding
  = Edge     { fMod :: String, fName :: String, fA :: String, fB :: String, fKind :: String }
  | Loop     { fMod :: String, fName :: String, fA :: String }
  | Refusal  { fMod :: String, fName :: String, fA :: String, fB :: String }
  | Generic  { fMod :: String, fName :: String }
  deriving Show

data FileInfo = FileInfo
  { fiPath  :: FilePath
  , fiMod   :: String
  , fiDefs  :: [String]      -- type-former names defined here
  , fiSigs  :: [Decl]
  , fiVars  :: [String]      -- names bound by a top-level `variable` block
  , fiIdent :: S.Set String  -- every token appearing in a signature here
  , fiAlias :: AliasTable    -- `import M as X` bindings of this file
  , fiUsing :: [(String, String)]  -- `import M using (n)` name→module bindings
  }

scanFile :: FilePath -> IO FileInfo
scanFile p = do
  raw <- readUtf8 p
  let src = stripComments raw
      bs  = blocks src
      m   = fromMaybe (fallbackName p) (moduleNameOf src)
      sigs = mapMaybe sigOf bs
      dr   = mapMaybe dataRecOf bs
      -- a signature `N : Type ...` also defines a type
      tyAbbrev = concat [ dNames d | d <- sigs, isTypeSort (dropBinders (dType d)) ]
      vars = concatMap variablesOf bs
  return (FileInfo p m (nub (dr ++ tyAbbrev)) sigs (nub vars)
            (S.fromList (concatMap (tokens . dType) sigs))
            (mapMaybe aliasOf bs)
            (concatMap usingOf bs))
  where
    fallbackName = reverse . takeWhile (/= '/') . reverse
    isTypeSort c = case words (unparen c) of
      (w:_) -> w `elem` ["Type","Type₀","Type₁","Set","Set₀","Set₁","Type_","SetΩ"]
      _     -> False

classify :: DefTable -> FileInfo -> Decl -> Maybe Finding
classify defs fi d0 =
  let nm = dName d0
      ty = dType d0
      idn = identsIn' (M.keysSet defs)
      concl = conclusion ty
      bnds  = S.fromList (binders ty ++ fiVars fi)
      home  = fiMod fi
      als   = fiAlias fi
      usng  = fiUsing fi
      identsIn = idn
      mk tok kind =
        case splitTop tok concl of
          Just (a, b) | countTop tok concl == 1 ->
            let a' = unparen a; b' = unparen b
                free e = any (`S.member` bnds) (identsIn e)
            in if null (trim a') || null (trim b') then Nothing
               else if free a' || free b' then Just (Generic home nm)
               else let ra = resolveExpr defs als usng home a'
                        rb = resolveExpr defs als usng home b'
                    in if ra == rb then Just (Loop home nm ra)
                       else Just (Edge home nm ra rb kind)
          _ -> Nothing
      -- ¬ (A ≃ B)  : a proved separation
      refusal =
        let c = trim concl
        in if take (length "¬") c == "¬"
             then let inner = unparen (trim (drop (length "¬") c))
                  in case splitTop "≃" inner of
                       Just (a,b) | countTop "≃" inner == 1
                                  , not (any (`S.member` bnds) (identsIn a))
                                  , not (any (`S.member` bnds) (identsIn b)) ->
                          Just (Refusal home nm (resolveExpr defs als usng home (unparen a))
                                                (resolveExpr defs als usng home (unparen b)))
                       _ -> Nothing
             else Nothing
  in case refusal of
       Just r  -> Just r
       Nothing -> case mk "≃" "equiv" of
                    Just f  -> Just f
                    Nothing -> typeLevelPath defs fi bnds home nm concl

-- `A ≡ B` counts only when BOTH sides resolve to something the corpus (or
-- the library) knows as a type.  An element-level `x ≡ y` must not become an
-- edge, and no amount of grep distinguishes them; the definition table does.
typeLevelPath :: DefTable -> FileInfo -> S.Set String -> String -> String -> String -> Maybe Finding
typeLevelPath defs _fi bnds home nm concl =
  let identsIn = identsIn' (M.keysSet defs)
      als      = fiAlias _fi
      usng     = fiUsing _fi in
  case splitTop "≡" concl of
    Just (a,b) | countTop "≡" concl == 1 ->
      let a' = unparen a; b' = unparen b
      in if any (`S.member` bnds) (identsIn a') || any (`S.member` bnds) (identsIn b')
           then Nothing
         else if not (knownType defs a') || not (knownType defs b')
           then Nothing
         -- `W p ≡ W p'` is a statement about a family's ARGUMENTS, not an
         -- identification of two types.  Same applied head on both sides:
         -- refuse, and say so rather than counting a spurious causeway.
         else if sameAppliedHead a' b'
           then Nothing
         else let ra = resolveExpr defs als usng home a'; rb = resolveExpr defs als usng home b'
              in if ra == rb then Nothing else Just (Edge home nm ra rb "path")
    _ -> Nothing

-- The HEAD of the expression has to be a type, not merely some capitalised
-- name occurring anywhere inside it.  `deficit V t ≡ gaps s V t + deficit
-- (s ∷ V) t` mentions the type-name `V` and is an equation between natural
-- numbers; the run before this one made eleven such edges.  An expression
-- with a top-level arithmetic operator is likewise arithmetic, whatever its
-- head is.
sameAppliedHead :: String -> String -> Bool
sameAppliedHead a b =
  case (tokens (unparen a), tokens (unparen b)) of
    ((h1:r1), (h2:r2)) -> h1 == h2 && not (null r1) && not (null r2)
    _                  -> False

knownType :: DefTable -> String -> Bool
knownType defs e0 =
  let e = trim (unparen e0)
  in not (any (\op -> countTop op e > 0) arith)
     && case firstJust [ splitTop op e | op <- tyOps ] of
          Just (l,r) -> knownType defs l && knownType defs r
          Nothing    -> case tokens e of
            (h:_) -> M.member h defs || h `elem` libTypes || h `elem` tyHeads
            []    -> False
  where
    arith    = ["+","·","*","∸","^","⊓","⊔","⋆"]
    tyOps    = ["×","⊎","→","->"]
    libTypes = ["Fin","Bool","Unit","Unit*","Lift","List","Vec","Maybe"
               ,"ℕ","ℤ","ℚ","Type","⊥","⊤","SumFin","FinData"]
    tyHeads  = ["Σ","Σ[","¬","∥","fiber","fibre","isEquiv","isProp","isSet"
               ,"isContr","isOfHLevel","Path","PathP"]
    firstJust xs = case [ x | Just x <- xs ] of (y:_) -> Just y; [] -> Nothing

-- ─────────────────────────────────────────────────────────────────────────
-- 8.  Graph
-- ─────────────────────────────────────────────────────────────────────────

type Graph = M.Map String (S.Set String)

buildGraph :: [Finding] -> Graph
buildGraph fs = foldl' add M.empty [ (a,b) | Edge _ _ a b _ <- fs ]
  where add g (a,b) = M.insertWith S.union a (S.singleton b)
                    $ M.insertWith S.union b (S.singleton a) g

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

-- distances from s within the graph
dists :: Graph -> String -> M.Map String Int
dists g s = go (M.singleton s 0) [s]
  where
    go d [] = d
    go d (x:xs) =
      let dx = d M.! x
          nb = S.toList (fromMaybe S.empty (M.lookup x g))
          new = [ y | y <- nb, not (M.member y d) ]
          d' = foldr (\y acc -> M.insert y (dx+1) acc) d new
      in go d' (xs ++ new)

eccentricities :: Graph -> S.Set String -> [(String,Int)]
eccentricities g comp =
  [ (n, maximum (M.elems (dists g n))) | n <- S.toList comp ]

-- ─────────────────────────────────────────────────────────────────────────
-- 9.  Main
-- ─────────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let root = case args of (r:_) -> r; [] -> "."
      roots = [ root </> "formal/cubical", root </> "punaragamana/src" ]
  paths <- fmap concat (mapM walk roots)
  infos <- mapM scanFile paths
  let defs :: DefTable
      defs = M.fromListWith S.union
               [ (n, S.singleton (fiMod fi)) | fi <- infos, n <- fiDefs fi ]
      findings = [ f | fi <- infos, d <- fiSigs fi, Just f <- [classify defs fi d] ]
      edges    = [ f | f@Edge{}    <- findings ]
      loops    = [ f | f@Loop{}    <- findings ]
      refusals = [ f | f@Refusal{} <- findings ]
      generics = [ f | f@Generic{} <- findings ]
      g        = buildGraph edges
      comps    = sortBy (flip (comparing S.size)) (components g)
      biggest  = if null comps then S.empty else head comps
      ecc      = eccentricities g biggest
      diam     = if null ecc then 0 else maximum (map snd ecc)

  putStrLn "═══ सेतुबन्ध · the graph of checked identifications ═══"
  putStrLn ""
  putStrLn $ "files scanned                  : " ++ show (length paths)
  putStrLn $ "modules                        : " ++ show (length (nub (map fiMod infos)))
  putStrLn $ "type-formers defined           : " ++ show (M.size defs)
  putStrLn $ "top-level signatures           : " ++ show (sum (map (length . fiSigs) infos))
  putStrLn ""
  putStrLn $ "EDGES   (concrete A ≃ B / A ≡ B) : " ++ show (length edges)
  putStrLn $ "  of which ≃                     : " ++ show (length [()|Edge _ _ _ _ "equiv" <- edges])
  putStrLn $ "  of which ≡ between types       : " ++ show (length [()|Edge _ _ _ _ "path"  <- edges])
  putStrLn $ "LOOPS   (A ≃ A, automorphisms)   : " ++ show (length loops)
  putStrLn $ "REFUSED (¬ (A ≃ B), proved)      : " ++ show (length refusals)
  putStrLn $ "GENERIC (lemma about transport)  : " ++ show (length generics)
  putStrLn ""
  -- An edge whose two endpoints live in the same module joins a type to a
  -- restatement of itself next door.  It is a real theorem and it is not a
  -- causeway: nothing crosses to another bank.  Routing lives on the rest.
  let owner n = takeWhile (/= '.') (reverse (dropWhile (/= '.') (reverse n)))
      crossing = length [ () | Edge _ _ a b _ <- edges, owner a /= owner b ]
  putStrLn $ "  of which CROSS-MODULE            : " ++ show crossing
  putStrLn $ "  of which within one module       : " ++ show (length edges - crossing)
  putStrLn ""
  putStrLn $ "NODES                            : " ++ show (M.size g)
  putStrLn $ "COMPONENTS                       : " ++ show (length comps)
  putStrLn $ "LARGEST COMPONENT                : " ++ show (S.size biggest)
  putStrLn $ "DIAMETER of largest component    : " ++ show diam
  putStrLn $ "component size histogram         : "
             ++ show (M.toList (M.fromListWith (+) [ (S.size c, 1::Int) | c <- comps ]))
  putStrLn ""

  putStrLn "── THE LARGEST COMPONENT, by degree ──"
  let degs = sortBy (flip (comparing snd)) [ (n, S.size s) | (n,s) <- M.toList g, n `S.member` biggest ]
  mapM_ (\(n,d) -> putStrLn ("  " ++ show d ++ "  " ++ n)) (take 25 degs)
  putStrLn ""

  putStrLn "── PAIRS AT DISTANCE ≥ 2 in the largest component (routing targets) ──"
  let far = [ (a,b,d) | a <- S.toList biggest
                      , (b,d) <- M.toList (dists g a)
                      , d >= 2, a < b ]
  mapM_ (\(a,b,d) -> putStrLn ("  d=" ++ show d ++ "  " ++ a ++ "   ⟶   " ++ b))
        (take 40 (sortBy (flip (comparing (\(_,_,d)->d))) far))
  putStrLn ""

  putStrLn "── PROVED SEPARATIONS (non-edges, and they are results) ──"
  mapM_ (\(Refusal m n a b) -> putStrLn ("  " ++ m ++ "." ++ n ++ " : ¬ (" ++ a ++ " ≃ " ++ b ++ ")")) refusals
  putStrLn ""

  putStrLn "── AUTOMORPHISMS (A ≃ A: no reachability, real content) ──"
  mapM_ (\(Loop m n a) -> putStrLn ("  " ++ m ++ "." ++ n ++ " : " ++ a ++ " ≃ " ++ a)) (take 30 loops)
  putStrLn ""

  -- ISOLATED NODES: types the corpus defines that no edge touches.
  let allTypes = S.fromList [ fiMod fi ++ "." ++ n | fi <- infos, n <- fiDefs fi ]
      touched  = M.keysSet g
      isolated = S.difference allTypes touched
      -- rank by how many modules mention the bare name: the more a type is
      -- talked about while being identified with nothing, the more it is the
      -- frontier rather than a local scratch definition.
      mentions nm = length [ () | fi <- infos, nm `S.member` fiIdent fi ]
      bare = reverse . takeWhile (/= '.') . reverse
      ranked = sortBy (flip (comparing snd))
                 [ (n, mentions (bare n)) | n <- S.toList isolated ]
  putStrLn "── ISOLATED NODES: defined types that nothing identifies ──"
  putStrLn $ "  isolated : " ++ show (S.size isolated) ++ " of " ++ show (S.size allTypes)
             ++ " defined types  ("
             ++ show ((100 * S.size isolated) `div` max 1 (S.size allTypes)) ++ "%)"
  putStrLn "  ranked by how many modules mention the name."
  putStrLn "  ONE-AND-TWO-CHARACTER NAMES ARE EXCLUDED from the ranking: `S`,"
  putStrLn "  `R`, `W`, `X`, `M`, `V` are local abbreviations reused in dozens of"
  putStrLn "  modules, and their mention counts measure the alphabet, not the"
  putStrLn "  corpus.  They stay in the isolated COUNT; they are not frontier."
  let substantive = [ (n,c) | (n,c) <- ranked, length (bare n) > 2 ]
  mapM_ (\(n,c) -> putStrLn ("  " ++ pad (show c) ++ "  " ++ n)) (take 60 substantive)
  putStrLn ""
  putStrLn "  ── isolated nodes named in the tradition's own vocabulary ──"
  let devanagari = [ (n,c) | (n,c) <- ranked, any (\ch -> ch >= '\x0900' && ch <= '\x097F') (bare n) ]
  mapM_ (\(n,c) -> putStrLn ("  " ++ pad (show c) ++ "  " ++ n)) devanagari
  putStrLn ""
  putStrLn "── EVERY EDGE ──"
  mapM_ (\(Edge m n a b k) ->
          putStrLn ("  [" ++ k ++ "] " ++ a ++ "  ≃  " ++ b ++ "   « " ++ m ++ "." ++ n))
        (sortBy (comparing fA) edges)
  where
    pad s = replicate (max 0 (3 - length s)) ' ' ++ s
