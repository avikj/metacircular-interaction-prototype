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
--  1. The split into top-level declarations is the LAYOUT rule, read
--     syntactically: a declaration begins at column 0 and runs to the next
--     column-0 token.  LIMIT: `private`/`module`/`where` blocks are one
--     declaration each, not split into their members; a declaration inside a
--     `where` is part of its parent.  So the store is coarser than Unison's,
--     which addresses every definition.  This is stated, not hidden.
--     For a MIXFIX operator the clauses do not share the signature's head
--     token, and until 2026-08-21 they were therefore not merged into it —
--     see the block above `declsOf`, which is where that was fixed and where
--     the limits of the fix are stated.
--     THREE LANES since 2026-08-21: Agda, Lean and Haskell, hashed
--     separately.  See the block above `data Lang` for what was invisible
--     before and why the lanes are not one corpus.
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

-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THE CENSUS CAN SEE, AND WHAT IT COULD NOT SEE UNTIL 2026-08-21
--
-- It read `formal/cubical` and `punaragamana/src`, and nothing else.  It was
-- therefore structurally blind to three lanes of this repository at once:
-- `formal/executable` (8 `.agda` files, the SAME language, excluded by an
-- accident of the path list), `formal/pairfield` (138 hand-written `.lean`
-- modules), and `machine` (132 `.hs` programs — including this one).  A store
-- that reports "the corpus's literal duplicates" while not reading two thirds
-- of the corpus's lanes is a verdict issued over a sample, which is exactly
-- the शब्द defect the rest of this file is written against.
--
-- So it now reads all three, in SEPARATE LANES, and the reason they are
-- separate is not tidiness:
--   · a Lean `theorem` and an Agda `theorem` in one digest table would share
--     dependencies by BARE NAME across languages (`digests` resolves an
--     identifier to every declaration of that name anywhere), so a Haskell
--     `main` would perturb an Agda `main`'s address.  Over-sensitivity is the
--     safe direction, but a cross-language edge is not over-sensitivity —
--     it is a claim that the two names denote one thing, and they do not.
--   · a "duplicate" across two languages could only ever be a coincidence of
--     ASCII.  The store answers SAME PRESENTATION; two presentations in two
--     languages are not the same presentation.
--
-- LIMITS OF THE TWO NEW LANES, at the site, because they are weaker than the
-- Agda one and a reader must not read one number as three:
--   · LEAN.  A declaration is a column-0 line whose first word (after
--     `private`/`protected`/`noncomputable`/`partial`/`unsafe`) is one of the
--     declaration keywords, and the name is the word after it.  So: anonymous
--     `instance : …` is not addressed, `attribute`/`macro_rules`/`notation`
--     bodies are not addressed, and a `namespace` contributes nothing to the
--     name — the module key is the FILE PATH, not the namespace, so two
--     namespaces in one file share a key and their same-named declarations
--     collapse to one entry.  `.lake` is excluded; it is Mathlib, not ours.
--   · HASKELL.  Same layout split as Agda, signature `::` and clauses merge
--     the same way, but an operator defined as `(<+>) a b = …` is NOT
--     addressed: its head token is bracketed, and Haskell has no mixfix
--     signature to recover it from.  The module key is the file path because
--     most of `machine/` declares `module Main`, and keying by the declared
--     module name would collapse 132 programs into one.
--   · BOTH.  `where`-blocks, `let`-blocks and class/instance members are part
--     of their parent declaration, as in the Agda lane.
data Lang = Agda | Lean | Haskell deriving (Eq, Show)

langExt :: Lang -> String
langExt Agda    = ".agda"
langExt Lean    = ".lean"
langExt Haskell = ".hs"

listSrc :: Lang -> FilePath -> IO [FilePath]
listSrc lang root = go root
  where
    skip e = e `elem` ["_build", ".lake", "__pycache__", ".git", "dist-newstyle"]
    go d = do
      ok <- doesDirectoryExist d
      if not ok then pure [] else do
        es <- listDirectory d
        fmap concat . forM es $ \e -> do
          let p = d </> e
          isD <- doesDirectoryExist p
          if isD then (if skip e then pure [] else go p)
                 else pure [ p | takeExtension p == langExt lang ]

-- Comments out, pragmas out, trailing space out.  A hash that changed with a
-- comment would make every reformat a new object, which is the substrate
-- defect this program exists to remove.  Lean's block comment is `/- … -/`
-- and its doc comment `/-- … -/`; Agda's and Haskell's is `{- … -}` with the
-- pragma form `{-# … #-}` kept out separately.  The line comment is `--` in
-- all three, which is the only thing the three lanes share for free.
strip :: Lang -> String -> String
strip lang = unlines . map (dropTrailing . dropLine) . lines . dropBlock
  where
    dropLine l = case breakOn "--" l of (a, _) -> a
    dropTrailing = reverse . dropWhile isSpace . reverse
    dropBlock s = go s (0 :: Int)
      where
        (openB, closeB) = case lang of Lean -> ("/-", "-/"); _ -> ("{-", "-}")
        go [] _ = []
        go cs@('{':'-':'#':r) n | lang /= Lean = go (afterPragma r) n
                                | otherwise    = step cs n
        go cs n = step cs n
        step cs n
          | openB `isPrefixOf` cs  = go (drop 2 cs) (n+1)
          | closeB `isPrefixOf` cs = go (drop 2 cs) (max 0 (n-1))
          | otherwise = case cs of
              (c:r) -> if n > 0 then go r n else c : go r n
              []    -> []
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
--
-- ─────────────────────────────────────────────────────────────────────────
-- MIXFIX.  THE HEAD OF `m ⊓ n = …` IS `_⊓_`, AND UNTIL 2026-08-21 THIS
-- PROGRAM DID NOT KNOW THAT.
--
-- The merge above keys on the head TOKEN.  For a mixfix operator the
-- signature's head token is `_⊓_` and every clause's head token is a
-- PATTERN VARIABLE (`m`, `zero`, `suc n`), so the merge never fired and the
-- hashed chunk was THE SIGNATURE ALONE — no body.  Two operators with one
-- type then shared an address BY CONSTRUCTION.  Proof, and how it was found:
-- `NaturalMachine.Residual._⊓_` (min) and `._⊖_` (truncated subtraction) came
-- out at c7252409d03e3ae2 — same module, different functions, identical
-- signature.  30 of the 236 "confirmed identical text" groups contained a
-- name with an underscore in it and were therefore signature-only matches:
-- leads wearing a verdict's clothes, which is the one thing §-प्रतिकृति
-- above forbids.
--
-- WHAT IT COST AND WHAT IT PAID, both measured at commit 5d7ec790 on the same
-- file set (`formal/cubical` + `punaragamana/src`, 892 files), so the two
-- columns are comparable and neither is quoted from memory:
--
--                                   before      after
--     declarations addressed        11,374     11,224     (−150)
--     distinct addresses            10,692     10,578
--     addresses holding >1             325        300
--       …confirmed identical           236        237     (+1)
--       …FNV-64 collisions              89         63     (−26)
--
-- The declaration count FELL because 150 chunks that were being addressed as
-- declarations were pattern-variable heads (`m`, `n`, `zero`) — the store was
-- counting clauses as definitions.  The confirmed-duplicate count went UP by
-- one, which is the interesting number and is a sum of opposite motions:
-- 26 of the old groups are gone; 20 of those DIED as signature-only false
-- matches and 4 came back under a corrected name (`length-` → `length-++`,
-- `≢0→0` → `≢0→0<`, `_` → `_&&_`, `_` → `_//_`) and 2 grew by a member.
-- Against that, 21 groups appeared that had never been reported at all,
-- because a definition now carries its body and its body's dependencies, so
-- genuinely identical definitions whose body-less digests used to differ now
-- meet.  A total that moved by one concealed a turnover of a fifth of its
-- membership, which is the reason to diff the MEMBERSHIP and never the count.
--
-- THE RECOVERY.  Two passes over the chunks of one file.  Pass one collects
-- the module's OWN top-level type signatures (a chunk whose first line has a
-- `:` at bracket depth 0).  Pass two, for a chunk that is NOT a signature,
-- reads the left-hand side at bracket depth 0 up to `=`/`with`/`|` and asks
-- which declared mixfix name has its name-parts appearing there in order,
-- with a token before a leading `_` and a token after a trailing `_`.
-- Depth 0 is what makes it sound: `foo (m ⊓ n) = …` is a clause of `foo`,
-- and dropping bracketed groups is exactly the difference.
--
-- THE NEW LIMIT, stated at the site because there is always one:
--   · the match is against THIS module's signatures only.  A clause of an
--     operator declared elsewhere is not recovered — no such thing exists in
--     Agda, but a `where`-bound or `private` operator is invisible here for
--     the separate reason that indented blocks are one chunk (limit 1).
--   · when two declared mixfix names both match, the one with more
--     name-parts wins, longer total length breaking the tie.  That is a
--     HEURISTIC, not Agda's operator parser, which resolves by fixity and
--     scope.  It has no known false positive in this corpus and it is not a
--     proof that it cannot have one.
--   · copatterns (`x .fst = …`) and clauses whose head is a `syntax`
--     form are still mis-attributed to their first token.
--   · a mixfix name whose only part is a token that also occurs as an
--     ordinary depth-0 pattern token would capture that clause.  Depth 0
--     plus "the chunk is not a signature" is the whole guard.
declsOf :: Lang -> FilePath -> String -> [Decl]
declsOf lang fp src = [ Decl nm modName fp (concat bodies)
                      | (nm, bodies) <- merged ]
  where
    named = [ (nm, unlines body)
            | body@(h:_) <- chunks, Just nm <- [headOf h] ]

    -- the module's own top-level signatures, and of those the mixfix ones.
    -- Agda only: Lean has no clause-at-column-0 form and Haskell's operator
    -- definitions carry their head in brackets, which this cannot recover.
    sigNames = [ nm | (h:_) <- chunks, isSig h, Just nm <- [headName h] ]
    mixfixSigs | lang /= Agda = []
               | otherwise = [ (nm, ps) | nm <- nub sigNames, '_' `elem` nm
                             , let ps = nameParts nm, not (null ps) ]

    headOf l
      | lang == Lean                 = leanHead l
      | isSig l                      = headName l
      | firstWordReserved l          = Nothing
      | Just n <- mixfixHead l       = Just n
      | otherwise                    = headName l

    -- Lean: `[modifiers] <keyword> <name> …`, everything else unaddressed.
    leanHead l =
      case dropWhile (`elem` leanMods) (words l) of
        (k:n:_) | k `elem` leanDecls
                , let nm = takeWhile (\c -> c `notElem` ("(:{[⟨" :: String)) n
                , not (null nm), startsOK nm -> Just nm
        _ -> Nothing
    leanMods  = [ "private", "protected", "noncomputable", "partial", "unsafe"
                , "scoped", "local", "@[simp]", "nonrec" ]
    leanDecls = [ "theorem", "lemma", "def", "abbrev", "instance", "structure"
                , "inductive", "class", "opaque", "example", "alias" ]

    firstWordReserved l = case words l of (w:_) -> w `elem` reserved; [] -> True

    isSig l = ":" `elem` tokens0 l && not ("=" `elem` takeWhile (/= ":") (tokens0 l))

    -- Depth 0 first.  Only if nothing matches there, look INSIDE a leading
    -- bracketed group: `(v ⊕ᴹ w) t = v t + w t` is a clause of `_⊕ᴹ_` whose
    -- operator sits one level down because the definition takes a further
    -- argument.  Left unhandled, that form kept `Sl2TensorProduct._⊕ᴹ_` (a
    -- `+`) grouped with `._⊖ᴹ_` (a `-`) on their shared signature.
    mixfixHead l = case pick (lhsOf l) of
      Just n  -> Just n
      Nothing -> case leadingGroup l of
                   Just inner -> pick (lhsOf inner)
                   Nothing    -> Nothing

    lhsOf = takeWhile (\t -> t `notElem` ["=", "with", "|"]) . tokens0

    pick lhs =
      case sortBy (comparing (\(nm, ps) ->
                     (negate (length ps), negate (length nm))))
             [ (nm, ps) | (nm, ps) <- mixfixSigs, fits lhs nm ps ] of
        ((nm, _) : _) -> Just nm
        []            -> Nothing

    -- the interior of a leading balanced `(…)`, if the line starts with one
    leadingGroup l = case dropWhile isSpace l of
      ('(':cs) -> Just (grab (0 :: Int) "" cs)
      _        -> Nothing
      where
        grab _ acc []     = reverse acc
        grab d acc (c:cs)
          | c == '('      = grab (d+1) (c:acc) cs
          | c == ')'      = if d == 0 then reverse acc else grab (d-1) (c:acc) cs
          | otherwise     = grab d (c:acc) cs

    -- the parts are a subsequence of the LHS tokens, in order; a leading `_`
    -- demands a token before the first part, a trailing `_` one after the last
    fits lhs nm ps =
      case matchParts 0 lhs ps of
        Nothing        -> False
        Just (i, j)    -> (take 1 nm /= "_" || i > 0)
                       && (last nm /= '_' || j < length lhs - 1)
      where
        matchParts _ _ [] = Nothing
        matchParts k ts (p:rest) = case break (== p) ts of
          (_, [])       -> Nothing
          (pre, _:more) -> let i = k + length pre
                           in case rest of
                                [] -> Just (i, i)
                                _  -> fmap (\(_, j) -> (i, j))
                                           (matchParts (i+1) more rest)

    nameParts = filter (not . null) . foldr splitU [[]]
      where splitU c acc@(cur:done)
              | c == '_'  = [] : acc
              | otherwise = (c : cur) : done
            splitU _ [] = [[]]
    merged = go named
      where
        go [] = []
        go ((n, b) : rest) =
          let (same, more) = span ((== n) . fst) rest
          in (n, b : map snd same) : go more
    ls = filter (not . all isSpace) (lines (strip lang src))
    -- Agda module names are unique corpus-wide and are the right key.  Lean
    -- and Haskell are keyed by PATH: `machine/` declares `module Main` 132
    -- times over, and keying by the declared name would collapse the whole
    -- lane into one module and hide every duplicate inside it.
    modName
      | lang /= Agda = fp
      | otherwise = case [ w | l <- ls, "module " `isPrefixOf` l
                             , let ws = words l, length ws > 1, let w = ws !! 1 ] of
                      (m:_) -> m
                      []    -> "?"
    chunks = splitTop ls
    splitTop [] = []
    splitTop (l:rest) =
      let (body, more) = span indented rest in (l : body) : splitTop more
    indented (c:_) = isSpace c
    indented []    = True
    -- An Agda name is any run of characters that are not whitespace and not
    -- one of Agda's own reserved symbols `.;{}()@"`.  The earlier version
    -- listed the permitted characters instead — alphanumerics plus
    -- `-_'?!λ∙≡≃∘` and everything above U+007F — which silently TRUNCATED
    -- every operator built from an ASCII symbol: `_%%_`, `_//_`, `_<ᵇ_` and
    -- `_/_` all came out as the name `_`.  That is not cosmetic here: a
    -- truncated name has no name-parts, so it never entered the mixfix table
    -- and its clauses stayed attached to a pattern variable — the very defect
    -- this section exists to remove, arriving through the lexer instead.
    headName l =
      let w = takeWhile (\c -> not (isSpace c)
                               && c `notElem` (".;{}()@\"" :: String)) l
      in if null w || w `elem` reserved || not (startsOK w) then Nothing else Just w
    startsOK (c:_) = isAlpha c || fromEnum c > 127 || c == '_'
    startsOK []    = False
    reserved = [ "module","open","import","private","postulate","data","record"
               , "where","infix","infixl","infixr","syntax","variable","mutual"
               , "abstract","instance","primitive","pattern","macro" ]
               ++ (if lang == Haskell
                     then [ "newtype","type","class","deriving","foreign"
                          , "default" ]
                     else [])

-- Tokens of a line at BRACKET DEPTH ZERO.  A `(…)` or `{…}` group is
-- COLLAPSED TO ONE PLACEHOLDER TOKEN `()`, not flattened and not deleted.
--   · not flattened, because `foo (m ⊓ n) = …` is a clause of `foo` and must
--     not look like one of `_⊓_`; depth is the only thing that separates them.
--   · not deleted, because `(p , q) ⊏ (p' , q') = …` is a clause of `_⊏_` and
--     the leading `_` of that name is satisfied by an argument that happens to
--     be a pattern in brackets.  Deleting the group left `⊏` at position 0 and
--     the clause was dropped — which is how the first cut of this fix left
--     `NaturalMachine.…Mediant._⊏_` (a `<`) still grouped with
--     `…Antitone._⊑_` (a `≤`) as if they were one definition.
tokens0 :: String -> [String]
tokens0 = go (0 :: Int) ""
  where
    flush acc r = if null acc then r else reverse acc : r
    go _ acc [] = flush acc []
    go d acc (c:cs)
      | c == '(' || c == '{' =
          if d == 0 then flush acc ("()" : go 1 "" cs) else go (d+1) "" cs
      | c == ')' || c == '}' = go (max 0 (d-1)) "" cs
      | d > 0                = go d "" cs
      | isSpace c            = flush acc (go d "" cs)
      | otherwise            = go d (c:acc) cs

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

-- The three lanes.  Each is hashed in its OWN table; see the note above
-- `data Lang` for why they are not one corpus.
lanes :: [(Lang, [FilePath])]
lanes =
  [ (Agda,    ["formal/cubical", "punaragamana/src", "formal/executable"])
  , (Lean,    ["formal/pairfield"])
  , (Haskell, ["machine"])
  ]

-- ─────────────────────────────────────────────────────────────────────────
-- `--emit-addresses` — THE TABLE, NOT THE REPORT.  Added 2026-08-22.
--
-- WHY.  `AnulomaPratiloma_…hs` re-proposes all 39 candidate inverse pairs and
-- re-puts each to the kernel on every pass, so an overnight loop pays the same
-- cost for the same refusals forever and can never run longer than the corpus
-- takes to check once.  A verdict is only re-askable when the QUESTION has
-- changed, and the question is the two functions' definitions — which is
-- exactly what this store already addresses.  So the ledger keys on the
-- address, and this mode is how another program gets it.
--
-- Prints, one per line, TAB-separated and nothing else:
--     <hex-16>  <lang>  <module>  <name>
-- LIMIT: every limit of the census above applies unchanged — a `where`-block
-- member has no address of its own, and a name that Nama cannot address is
-- simply absent, which a consumer must read as "no address", never as "no
-- such definition".
-- `--emit-bonds` — THE LATTICE.  Added 2026-08-22.
--
-- WHY, and it is the correction of a whole instrument.  `Abhijnana` was
-- matching a fibre to its map BY NAME — stripping module qualifiers and
-- string-comparing `matraOf` against `PingalaPrastara.matraOf` — and paid
-- for it with nine deaths in fourteen probes.  Names collide.  `SieveFiber.q`
-- matched three unrelated fibres because three unrelated things are spelled
-- `q`.
--
-- **BONDS DO NOT COLLIDE.**  `Metre n = Σ[ p ∈ Pattern ] (matraOf p ≡ n)`
-- does not RESEMBLE a use of `matraOf`; it CONTAINS one, resolved, and this
-- store already computes that resolution — it is how a definition is hashed.
-- The join another program was guessing at is an edge that was already here
-- and was being discarded after every run.
--
-- So the recognition rule stops being a heuristic and becomes exact:
--
--     a written fibre F is the fibre of f  ⟺  F's body is a Σ ending in an
--     equation, AND F bonds to f.
--
-- Prints, one per line, TAB-separated and nothing else:
--     <module.name>  <module.name-it-depends-on>
--
-- LIMIT, unchanged from the census and load-bearing here: the resolution is a
-- LEXICAL scan, so a name shadowed by a local binder is counted as a bond it
-- is not.  That makes the lattice DENSER than the truth and never sparser —
-- the direction an identity mechanism must err in, because a spurious bond is
-- a lead the kernel then kills, while a missing bond is a receipt nobody ever
-- finds.  A `where`-block member still has no address and so contributes no
-- bonds.
emitBonds :: IO ()
emitBonds = forM_ lanes $ \(lang, roots) -> do
  fs <- concat <$> mapM (listSrc lang) roots
  ds <- fmap concat . forM fs $ \f -> declsOf lang f <$> readFile f
  let qual d    = dModule d ++ "." ++ dName d
      bySuffix  = M.fromListWith (++) [ (dName d, [qual d]) | d <- ds ]
      bondsOf d = nub [ q | i <- nub (idents (dText d)), i /= dName d
                      , q <- M.findWithDefault [] i bySuffix, q /= qual d ]
  forM_ ds $ \d -> forM_ (bondsOf d) $ \q ->
    putStrLn (qual d ++ "\t" ++ q)

emitAddresses :: IO ()
emitAddresses = forM_ lanes $ \(lang, roots) -> do
  fs <- concat <$> mapM (listSrc lang) roots
  ds <- fmap concat . forM fs $ \f -> declsOf lang f <$> readFile f
  let tbl = digests ds
  forM_ ds $ \d ->
    case M.lookup (dModule d ++ "." ++ dName d) tbl of
      Just h  -> putStrLn (hex h ++ "\t" ++ show lang ++ "\t"
                           ++ dModule d ++ "\t" ++ dName d)
      Nothing -> pure ()

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let full = "--full" `elem` args
  if "--emit-bonds" `elem` args then emitBonds
  else if "--emit-addresses" `elem` args then emitAddresses else report full

report :: Bool -> IO ()
report full = do
  putStrLn "=============================================================="
  putStrLn "नाम · the name is carried, the hash is the base"
  putStrLn "=============================================================="
  totals <- forM lanes $ \(lang, roots) -> lane full lang roots
  putStrLn ""
  putStrLn $ "  ALL LANES: " ++ show (sum (map (\(a,_,_) -> a) totals))
          ++ " files, " ++ show (sum (map (\(_,b,_) -> b) totals))
          ++ " declarations, " ++ show (sum (map (\(_,_,c) -> c) totals))
          ++ " confirmed duplicate groups.  The three numbers are SUMS OF"
  putStrLn "  SEPARATE CENSUSES and not a census of one corpus: no address is"
  putStrLn "  shared across lanes, by construction."
  putStrLn ""
  putStrLn "  LIMITS, stated here rather than in a footnote:"
  putStrLn "    · declarations are split by the layout rule read syntactically;"
  putStrLn "      a `where`/`private`/`module` block is ONE declaration, not its"
  putStrLn "      members.  Coarser than Unison's."
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
  putStrLn "    · the Agda lane recovers mixfix clause heads; the Lean lane"
  putStrLn "      addresses only keyword-introduced named declarations and the"
  putStrLn "      Haskell lane cannot address `(<+>) a b = …`.  A lane's number"
  putStrLn "      is a floor on its duplicates, never a ceiling."

lane :: Bool -> Lang -> [FilePath] -> IO (Int, Int, Int)
lane full lang roots = do
  fs <- concat <$> mapM (listSrc lang) roots
  ds <- fmap concat . forM fs $ \f -> declsOf lang f <$> readFile f
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

  putStrLn ""
  putStrLn $ "-------- " ++ show lang ++ " lane: " ++ unwords roots
  putStrLn $ "  " ++ langExt lang ++ " files read"
             ++ replicate (max 1 (22 - length (langExt lang))) ' '
             ++ ": " ++ show (length fs)
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
  pure (length fs, length ds, length confirmed)
