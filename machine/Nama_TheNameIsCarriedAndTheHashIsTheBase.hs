-- Nama_TheNameIsCarriedAndTheHashIsTheBase.hs
--
-- नाम — the name.  नाम्नि जीवनम् (§१२).
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, IN ONE SENTENCE
--
-- A content-addressed store for this corpus's definitions, in which the HASH
-- is the base and the NAME is carried — पुनरागमन applied to storage itself.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHY.  MERGE CONFLICTS ARE A नष्टि MANUFACTURED BY THE SUBSTRATE.
--
-- Today's criterion: WHICH SIDE OF `f a ≡ b` IS BOUND.  A text file binds the
-- PATH and derives the content — bind-a.  The fibre of `path ↦ content` is a
-- preimage: many contents claim one path, and a merge conflict IS that fibre
-- failing to be contractible.  Content-addressing binds the other side: the
-- content is primary, `hash ↦ content` has a `singl` fibre, and two
-- definitions cannot collide because they are not the same object.
--
-- Everything that follows is the same inversion:
--   · no aggregate root.  `formal/cubical/Everything.agda` exists because a
--     file can sit on disk unbuilt, so something must list what to check — and
--     a hand-kept list rots (Indrajala: 13 modules unreachable, 3 dark and not
--     by design; Pairfield.lean's header claims 133 imports and makes 129).
--     A store has no outside.
--   · renaming is free, because a name is metadata over a hash.
--   · a dependency cannot break from an upstream edit, because it refers to a
--     hash and an edit makes a NEW object.
--
-- AND THE FILE TREE BECOMES A VIEW, WHICH IS FREE.
-- `punaragamana/src/Punaragamana/Prastara_…` proves प्रस्तार ≡ ℕ: नष्ट and
-- उद्दिष्ट each carry the other, so base and carried may be EXCHANGED and
-- storing and generating are THE SAME TYPE.  §४१ सारणी वा क्रिया is therefore
-- not a trade.  Keep the store; regenerate the files.
--
-- ─────────────────────────────────────────────────────────────────────────
-- THE BOUNDARY, TAKEN FROM notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md
--
-- That note (848 lines, architecture only, explicitly unimplemented) states
-- the line this program must not cross, and it is right:
--
--     Do not ask one hash to mean both "these bytes are the same" and "these
--     mathematical structures are the same."
--
-- So: this store answers ONLY the first.  Two definitions with one hash are
-- the same PRESENTATION.  Mathematical sameness is a separate, proof-relevant
-- thing and is NOT a digest — asking a hash for it would be exactly the
-- दुर्नय `Saptabhangi.दुर्नयः` proves: one verdict merging two questions.
--
-- WHERE I DEPART FROM THAT NOTE, deliberately, with autonomy granted and the
-- reason on the record.  It proposes the equivalence layer as a maintained
-- GRAPH that "earns the stronger word groupoid only after its hashed identity,
-- inverse, composition, and law checkers pass."  In cubical those are not
-- things to check.  `A ≃ B` gives `A ≡ B` by univalence, and then `refl`,
-- `sym` and `_∙_` ARE identity, inverse and composition with the groupoid laws
-- already theorems in the library.  Writing law-checkers builds scaffolding
-- for what the substrate hands you, and by this corpus's own rule that means
-- the joint is wrong.  So an EDGE is not a graph entry: it is a landed module
-- of type `A ≃ B`, content-addressed by this same mechanism.  One store, no
-- second machinery — and `scripts/Ratri_…sh` already lands such modules.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT IS MEASURED, AND THE LIMIT OF EACH, AT THE SITE
--
--  1. The split into top-level declarations is Agda's LAYOUT rule, read
--     syntactically: a declaration begins at column 0 and runs to the next
--     column-0 token.  LIMIT: `private`/`module`/`where` blocks are one
--     declaration each, not split into their members; a declaration inside a
--     `where` is part of its parent.  So the store is coarser than Unison's,
--     which addresses every definition.  This is stated, not hidden.
--  2. The dependency edges are free identifiers that name another declaration
--     IN THIS CORPUS.  LIMIT: it is a lexical scan, so a name shadowed by a
--     local binder is counted as a dependency it is not.  That makes the
--     hash SOUNDER than needed (it changes when it need not) and never
--     unsound (it cannot miss a real dependency), which is the direction an
--     identity mechanism must err in.
--  3. The digest is FNV-1a 64 over the normalized text and the SORTED
--     dependency digests.  LIMIT: 64 bits, so a collision is possible; every
--     reported collision is CONFIRMED by comparing the normalized texts, and
--     the report says how many were confirmed. A real store would use SHA3-512
--     as Unison does; this is a census, not a production store, and the
--     confirmation step is what makes its numbers honest anyway.
--
-- THE IMMEDIATE PAYOFF, which is why this is worth running before the rest of
-- the substrate exists: two declarations with ONE HASH ARE THE SAME
-- DEFINITION, byte for byte after normalization, wherever they live.  That
-- finds the corpus's literal duplicates mechanically — the thing
-- `Indrajala`'s समानार्थ check can only approximate by comparing printed
-- types, and which it flags as "a lead, never a verdict."  Here it is a
-- verdict, because identity of presentation is exactly what a hash decides.
--
--   run:  runghc machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs [--full]
--   from the repository root.  Prints a report.  Writes nothing.

module Main (main) where

import Control.Monad (forM, forM_, when)
import Data.Bits (xor, shiftL, (.&.))
import Data.Char (isAlpha, isAlphaNum, isSpace)
import Data.List (foldl', isPrefixOf, isSuffixOf, sort, sortBy, group, nub)
import qualified Data.Graph as G
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Data.Maybe (mapMaybe)
import Data.Ord (comparing)
import Data.Word (Word64)
import Numeric (showHex)
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.FilePath ((</>), takeExtension)
import System.IO (hSetEncoding, stdout, utf8)

------------------------------------------------------------------ digest

-- FNV-1a, 64 bit.  Chosen for having no dependency; every collision the
-- report names is confirmed against the texts, so the digest's strength
-- bounds the WORK, not the truth of the output.
fnv :: String -> Word64
fnv = foldl' step 14695981039346656037
  where step h c = (h `xor` fromIntegral (fromEnum c `mod` 256)) * 1099511628211

hex :: Word64 -> String
hex w = let s = showHex w "" in replicate (16 - length s) '0' ++ s

------------------------------------------------------------------ reading

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
          if isD then (if e == "_build" then pure [] else go p)
                 else pure [ p | takeExtension p == ".agda" ]

-- Comments out, pragmas out, trailing space out.  A hash that changed with a
-- comment would make every reformat a new object, which is the substrate
-- defect this program exists to remove.
strip :: String -> String
strip = unlines . map (dropTrailing . dropLine) . lines . dropBlock
  where
    dropLine l = case breakOn "--" l of (a, _) -> a
    dropTrailing = reverse . dropWhile isSpace . reverse
    dropBlock s = go s (0 :: Int)
      where
        go [] _ = []
        go ('{':'-':'#':cs) n = go (afterPragma cs) n
        go ('{':'-':cs) n = go cs (n+1)
        go ('-':'}':cs) n = go cs (max 0 (n-1))
        go (c:cs) n = if n > 0 then go cs n else c : go cs n
        afterPragma ('#':'-':'}':cs) = cs
        afterPragma (_:cs) = afterPragma cs
        afterPragma [] = []
    breakOn pat s = go "" s
      where go acc r@(c:cs) | pat `isPrefixOf` r = (reverse acc, r)
                            | otherwise = go (c:acc) cs
            go acc [] = (reverse acc, [])

-- Agda's layout rule, read syntactically: a top-level declaration begins at
-- column 0 and runs to the next column-0 token.
data Decl = Decl { dName :: String, dModule :: String, dFile :: FilePath
                 , dText :: String }

-- A DEFINITION IS ITS SIGNATURE PLUS ALL ITS CLAUSES.  Agda writes each
-- pattern-matching clause at column 0, so a naive layout split reports
-- `quarter` four times in one module and the store then claims four
-- declarations share an address — which is the mechanism inventing duplicates
-- rather than finding them.  Consecutive chunks with the same head name are
-- therefore merged into one declaration.  Found the same way as the qualified
-- name bug: by a collision count no digest could produce.
declsOf :: FilePath -> String -> [Decl]
declsOf fp src = [ Decl nm modName fp (concat bodies)
                 | (nm, bodies) <- merged ]
  where
    named = [ (nm, unlines body)
            | body@(h:_) <- chunks, Just nm <- [headName h] ]
    merged = go named
      where
        go [] = []
        go ((n, b) : rest) =
          let (same, more) = span ((== n) . fst) rest
          in (n, b : map snd same) : go more
    ls = filter (not . all isSpace) (lines (strip src))
    modName = case [ w | l <- ls, "module " `isPrefixOf` l
                       , let ws = words l, length ws > 1, let w = ws !! 1 ] of
                (m:_) -> m
                []    -> "?"
    chunks = splitTop ls
    splitTop [] = []
    splitTop (l:rest) =
      let (body, more) = span indented rest in (l : body) : splitTop more
    indented (c:_) = isSpace c
    indented []    = True
    headName l =
      let w = takeWhile (\c -> isAlphaNum c || c `elem` ("-_'?!λ∙≡≃∘" :: String)
                               || fromEnum c > 127) l
      in if null w || w `elem` reserved || not (startsOK w) then Nothing else Just w
    startsOK (c:_) = isAlpha c || fromEnum c > 127 || c == '_'
    startsOK []    = False
    reserved = [ "module","open","import","private","postulate","data","record"
               , "where","infix","infixl","infixr","syntax","variable","mutual"
               , "abstract","instance","primitive","pattern","macro" ]

------------------------------------------------------------- dependencies

idents :: String -> [String]
idents = go
  where
    go [] = []
    go s@(c:cs)
      | isAlpha c || fromEnum c > 127 || c == '_' =
          let (w, r) = span (\x -> isAlphaNum x || x `elem` ("-_'" :: String)
                                   || fromEnum x > 127) s
          in w : go r
      | otherwise = go cs

------------------------------------------------------------------- store

-- The digest of a declaration: its normalized text WITH ITS OWN NAME ERASED,
-- plus the sorted digests of its corpus dependencies.  Erasing the name is
-- what makes renaming free; sorting the deps is what makes the digest
-- independent of the order they were written in.
--
-- MUTUAL RECURSION IS THE WHOLE DIFFICULTY, and the fix is not mine.  A knot
-- tied naively diverges — the first run of this program printed `<<loop>>` on
-- a corpus of 27,319 declarations, which is the honest way to discover that a
-- dependency cycle has no least fixed point under "hash me after my deps".
-- Unison's answer, quoted in notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md
-- from the official hash reference: "mutually recursive definitions share a
-- COMPONENT HASH with a member index."  So: condense the dependency graph into
-- its strongly connected components, hash each COMPONENT from its members'
-- texts plus the digests of everything OUTSIDE it, and give every member that
-- component digest salted by its index in the component's own sorted order.
--
-- The member index is what keeps two members of one cycle distinct while
-- keeping the component's identity independent of which member you entered
-- from.  Without it a mutual pair would share one address and the store would
-- claim they are the same definition, which is a सङ्क्षेप: two things under
-- one name.
digests :: [Decl] -> M.Map String Word64
digests ds = foldl' step M.empty ordered
  where
    -- KEYED BY QUALIFIED NAME.  Keying by the bare name collapsed every
    -- same-named declaration across 881 files into one entry, so 8,074
    -- declarations came out sharing an address BY CONSTRUCTION — a सङ्क्षेप
    -- committed by the identity mechanism itself, which is the one place it
    -- must never happen.  Caught by the first run reporting more collisions
    -- than FNV-1a could plausibly produce in 27,391 items.
    qual d = dModule d ++ "." ++ dName d
    byName = M.fromList [ (qual d, d) | d <- ds ]
    -- An identifier resolves to EVERY declaration of that name anywhere, so a
    -- digest changes when any of them changes.  Over-sensitive, never unsound
    -- — the direction an identity mechanism must err in.
    bySuffix = M.fromListWith (++) [ (dName d, [qual d]) | d <- ds ]
    depsOf d = nub [ q | i <- nub (idents (dText d)), i /= dName d
                   , q <- M.findWithDefault [] i bySuffix, q /= qual d ]
    ordered = G.stronglyConnComp
                [ (d, qual d, depsOf d) | d <- M.elems byName ]

    step tbl scc =
      let members = case scc of
            G.AcyclicSCC d  -> [d]
            G.CyclicSCC dsC -> dsC
          inside  = S.fromList (map qual members)
          -- the component's own content: every member's text, name-erased,
          -- in a canonical order, so entering from any member gives one value
          body = concat (sort [ erase (dName m) (dText m) | m <- members ])
          -- everything the component depends on that is NOT in it
          outer = sort [ h | m <- members, i <- depsOf m
                       , not (i `S.member` inside), Just h <- [M.lookup i tbl] ]
          comp = fnv (body ++ concatMap hex outer)
          -- member index: distinct within the component, independent of entry
          idx m = length (takeWhile (/= qual m) (sort (map qual members)))
      in foldl' (\t m -> M.insert (qual m) (fnv (hex comp ++ show (idx m))) t)
                tbl members

    erase nm = unwords . map (\w -> if w == nm then "_SELF_" else w) . words

------------------------------------------------------------------ report

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let full = "--full" `elem` args
  fs <- concat <$> mapM listAgda ["formal/cubical", "punaragamana/src"]
  ds <- fmap concat . forM fs $ \f -> declsOf f <$> readFile f
  let tbl  = digests ds
      keyed = [ (h, d) | d <- ds, Just h <- [M.lookup (dModule d ++ "." ++ dName d) tbl] ]
      byHash = M.fromListWith (++) [ (h, [d]) | (h, d) <- keyed ]
      dupes = [ (h, grp) | (h, grp) <- M.toList byHash, length grp > 1 ]
      -- a hash collision is only a duplicate if the normalized texts agree
      -- Compare the ERASED text: the digest erases each declaration's own name,
      -- which is what makes renaming free, so one definition under two names
      -- SHOULD share an address.  Comparing raw text called those "collisions"
      -- and buried the store's central property as if it were a defect.
      eraseSelf d = unwords (map (\w -> if w == dName d then "_SELF_" else w)
                                 (words (dText d)))
      confirmed = [ (h, grp) | (h, grp) <- dupes
                  , let ts = nub (map eraseSelf grp), length ts == 1 ]
      spurious = length dupes - length confirmed
      norm = unwords . words

  putStrLn "=============================================================="
  putStrLn "नाम · the name is carried, the hash is the base"
  putStrLn "=============================================================="
  putStrLn $ "  .agda files read                : " ++ show (length fs)
  putStrLn $ "  top-level declarations addressed: " ++ show (length ds)
  putStrLn $ "  distinct content addresses      : " ++ show (M.size byHash)
  putStrLn $ "  addresses holding >1 declaration: " ++ show (length dupes)
  putStrLn $ "    …confirmed identical text     : " ++ show (length confirmed)
  putStrLn $ "    …hash collisions, NOT the same: " ++ show spurious
  putStrLn ""
  putStrLn "  A confirmed pair is ONE DEFINITION standing in two places.  Not a"
  putStrLn "  lead — a verdict, because identity of PRESENTATION is exactly what"
  putStrLn "  a hash decides.  Mathematical sameness is a different question and"
  putStrLn "  this program does not answer it (notes/CONTENT_ADDRESSED_"
  putStrLn "  MATHEMATICAL_IDENTITY.md: do not ask one hash for both)."
  putStrLn ""

  let shown = if full then confirmed else take 25 confirmed
  forM_ (sortBy (comparing (negate . length . snd)) shown) $ \(h, grp) -> do
    putStrLn $ "  " ++ hex h ++ "  ×" ++ show (length grp)
    forM_ grp $ \d ->
      putStrLn $ "      " ++ dModule d ++ " . " ++ dName d
  when (not full && length confirmed > 25) $
    putStrLn $ "  … " ++ show (length confirmed - 25) ++ " more (--full)"

  putStrLn ""
  putStrLn "  LIMITS, stated here rather than in a footnote:"
  putStrLn "    · declarations are split by Agda's layout rule read"
  putStrLn "      syntactically; a `where`/`private`/`module` block is ONE"
  putStrLn "      declaration, not its members.  Coarser than Unison's."
  putStrLn "    · dependencies are a lexical scan, so a shadowed name counts as"
  putStrLn "      a dependency it is not — the digest changes when it need not,"
  putStrLn "      and never misses a real one.  That is the direction an"
  putStrLn "      identity mechanism must err in."
  putStrLn "    · FNV-1a 64.  Every collision above is confirmed against the"
  putStrLn "      texts, so the digest bounds the WORK and not the truth."
  putStrLn "    · this store answers SAME PRESENTATION.  An edge saying two"
  putStrLn "      different presentations are the same MATHEMATICS is a checked"
  putStrLn "      `A ≃ B`, content-addressed by this same mechanism, and"
  putStrLn "      scripts/Ratri_…sh already lands them."
