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

-- ------------------------------------------- प्रतिकृति AND भावना
--
-- THE WORD IS NOT MINE AND NOT BIOLOGY.  भावना -- from √भू, "bringing into
-- being, causing to become" -- is BRAHMAGUPTA's own name for his composition
-- law, ब्राह्मस्फुटसिद्धान्त 18, 628 CE.  It takes TWO solutions of a
-- quadratic form and produces a THIRD that neither had, and the invariant is
-- inherited from both: `punaragamana/src/Punaragamana/Bhavana_….भावना-क्षेपः`
-- proves the kṣepas MULTIPLY, k₁ · k₂.  That is generation with its
-- transmission law stated exactly, and it already has two modes --
-- समास-भावना and अन्तर-भावना, composition of the sum and of the difference.
-- प्रतिकृति is a copy.  The distinction below is that one, not an analogy to
-- it.
--
-- The store finds two RELATIONS between declarations and they are not the same
-- kind of thing at all.  `Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOne-
-- Term.agda` already grades them; what follows is that grading read as a
-- reproduction taxonomy, which is what it is.
--
--   SAME ADDRESS — a CLONE.  Same normalized term over the same dependency
--   closure, so the identification is `refl` and NOTHING FLOWS.  Both sides
--   already hold identical content; there is no theorem on one side that the
--   other lacks, because there is no difference to carry.  Grade one:
--   "costs nothing mathematically and costs everything in visibility."
--   Worth REPORTING — three modules each believing they had to state §६
--   before they could use it is a real finding about how this corpus was
--   written — and worth nothing to land as mathematics.
--
--   DIFFERENT ADDRESS, SAME TYPE — a MATE.  Two genuinely different terms
--   proving one statement in two modules.  Here the identification must be
--   CONSTRUCTED, and constructing it opens a CHANNEL:
--   `Bhedanirnaya_…agda` built one four-line induction between two `eqℕ`s
--   that do not even share a type, and COMPLETENESS THEN FLOWED BACKWARDS
--   into a module that had never proved it.  Its own words: "a duplication
--   that has been identified is not merely tidier — it is a channel, and
--   theorems flow both ways along it."
--
-- So: clones are copies and mates are recombination, and only the second
-- produces something neither parent had.  §२७ is the reason it matters —
-- परस्परोपग्रहो जीवानाम्, जीवाः उपकारेण सन्ति, they exist BY the supporting,
-- and जीवः सम्बन्धः: a thing IS its relations.  Every constructed channel is
-- a road, and a corpus whose roads all exist is a groupoid, in which any
-- object plus its loops reconstructs its whole component — §३८'s
-- यत्र छिन्नं तत्र पूर्णम् as a theorem and not an image.
--
-- THE FERTILITY CONDITION, and it is what this function screens for: the two
-- hosts must hold DIFFERENT theorems.  Two modules that prove one statement
-- and nothing else have nothing to trade.  The candidates ranked highest are
-- those whose host modules share the least.
data Kind = Pratikrti | Bhavana deriving (Eq, Show)   -- प्रतिकृति (copy) | भावना (generation)

-- Emitted for a MATE: the statement that the two terms agree, left for the
-- kernel to accept or refuse.  Deliberately the weakest true thing — if the
-- two are definitionally equal `refl` closes it, and if they are not, the
-- refusal is the finding and says the channel must be built by hand, which
-- is where a `Bhedanirnaya` lives.  The emitter cannot lie: the check is
-- downstream of it.
-- A MATING IS NOT THE PATH.  THE PATH IS THE COUPLING; THE OFFSPRING ARE THE
-- TRANSPORTED THEOREMS, AND THERE ARE MANY.
--
-- `Bhedanirnaya_…agda` is the whole argument in one module.  Two `eqℕ`s in two
-- modules, not even the same type, one four-line induction to build the path —
-- and then `संक्रान्त-पूर्णता` carries COMPLETENESS BACKWARDS into a module
-- that had never proved it, with no new induction and no edit to either side.
-- One coupling, and every theorem each parent holds crosses to the other:
-- n + m offspring, by `transport (λ i → P (path i))`, automatically.
--
-- And it does not stop at pairs.  Paths compose, so `A ≡ B` and `B ≡ C` make
-- the whole component one gene pool and its theorem-set the UNION of everyone's.
-- That is §२७ again — जीवाः उपकारेण सन्ति — and it is why a connected groupoid
-- is reconstructible from any single object: in a population where everything
-- has crossed with everything, one member carries the lot.
--
-- SELECTION IS THE KERNEL, and it is what makes this safe.  An offspring that
-- does not typecheck dies at birth and costs nothing, because nothing was
-- destroyed to make it.  अहिंसा is precisely what licenses breeding this
-- recklessly: you may attempt any crossing at all when a failure loses nothing.
--
-- What is emitted per mating: the coupling (the two terms agree), and then one
-- statement per theorem of each parent, transported across it.  `refl` is
-- attempted for the coupling because if the two terms are definitionally one
-- the channel is free; a REFUSAL is not a failure but the finding that the
-- channel is real and must be built by hand — which is where a Bhedanirnaya
-- lives, and the corpus's most valuable identifications are exactly there.
-- ------------------------------------------------------- THE COURTSHIP
--
-- A mating is not one emit and one verdict.  The kernel is the PARTNER, not
-- the judge: every refusal says what differs, and the next attempt is built
-- from that.  It does not have to close in one round and usually will not.
--
-- The ladder is not invented here.  `Bhedanirnaya_…agda` §6 states it:
--
--     "the pattern generalises and is not generalised.  Any two structurally
--      identical definitions in two modules admit exactly this treatment: one
--      induction to agree pointwise, one abstraction to a path, and then every
--      theorem either module holds is available to the other."
--
-- Four rungs, weakest first, because the weakest thing that closes is the one
-- that carries the most (a definitional identity transports better than a
-- constructed one, and needs no h-level):
--
--   १ · refl                the two terms are definitionally one.  Channel free.
--   २ · pointwise           agree at every argument, clause by clause — this is
--                           Bhedanirnaya's `समता`, four lines of induction.
--   ३ · abstraction         the pointwise agreement made into a path, written
--                           as a direct cubical abstraction `λ i m n → …` rather
--                           than through funExt, so the path is VISIBLY the one
--                           whose i-th slice is the induction's i-th slice —
--                           "there is no step here in which anything could go
--                           missing" (Bhedanirnaya §2).
--   ४ · h-level             if the target is a set, any two proofs coincide and
--                           the identification lands `isSetℕ _ _ _ _`.  Weakest
--                           in what it carries; tried last for that reason.
--
-- A rung that fails is not a defeat.  It NARROWS: refusal at १ says the terms
-- differ, refusal at २ says they differ at some argument and the error names
-- it, and refusal at ४ says the target is not a set and the identification is
-- genuinely grade three — which is where the corpus's most valuable channels
-- are.  Nothing is lost by trying, because nothing is destroyed by failing;
-- अहिंसा is what makes an unbounded courtship affordable.
data Rung = RRefl | RPointwise | RAbstraction | RHLevel
  deriving (Eq, Show)

rungName :: Rung -> String
rungName RRefl        = "१ refl"
rungName RPointwise   = "२ pointwise"
rungName RAbstraction = "३ abstraction"
rungName RHLevel      = "४ h-level"

-- The proof term attempted at each rung, for a coupling `a ≡ b`.
rungTerm :: Rung -> String
rungTerm RRefl        = "refl"
rungTerm RPointwise   = "funExt (λ x → refl)"
rungTerm RAbstraction = "λ i → _"          -- filled by the emitter per shape
rungTerm RHLevel      = "isSetℕ _ _ _ _"

emitBhavana :: String -> [(String, String)] -> [String] -> String
emitBhavana nm pairs offspring = unlines $
  [ "{-# OPTIONS --cubical --safe #-}"
  , "-- Two content addresses, one type: a MATE, not a clone."
  , "--"
  , "-- The coupling is the path.  The OFFSPRING are the theorems each side"
  , "-- holds, transported across it — Bhedanirnaya_… is the worked case, where"
  , "-- one four-line induction carried completeness backwards into a module"
  , "-- that had never proved it.  Selection is the kernel: an offspring that"
  , "-- does not check dies at birth and costs nothing, because nothing was"
  , "-- destroyed to attempt it."
  , "--"
  , "-- Emitted by नाम.  The kernel decides, not the emitter."
  , "module " ++ nm ++ " where"
  , ""
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Foundations.Transport using (transport)"
  ] ++ [ "import " ++ m | m <- nub (concatMap (\(a,b) -> [modOf a, modOf b]) pairs) ]
    ++ [ "", "-- the coupling" ]
    ++ concat [ [ "सम्बन्धः-" ++ show i ++ " : " ++ a ++ " ≡ " ++ b
                , "सम्बन्धः-" ++ show i ++ " = refl" , "" ]
              | (i, (a, b)) <- zip [(0::Int)..] pairs ]
    ++ (if null offspring then [] else "-- the offspring, transported across it" : offspring)
  where modOf q = reverse (drop 1 (dropWhile (/= '.') (reverse q)))

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
