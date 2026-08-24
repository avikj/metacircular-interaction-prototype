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
import Control.Monad (forM, forM_, when, unless, guard)
import Data.Bits (xor)
import Data.Char (isSpace, isAlphaNum)
import Data.List (isPrefixOf, isInfixOf, isSuffixOf, nub, sortBy, foldl', intercalate
                 , tails)
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
import System.IO (hSetEncoding, stdout, stderr, utf8)
import GHC.IO.Encoding (setLocaleEncoding)
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
-- 2026-08-22, RUNG FIVE.  `dCons` — nullary constructor NAMES — is the whole
-- of what rungs two and three could see, and it is why a constructor carrying
-- an argument was invisible rather than merely hard.  `dConsFull` carries the
-- ARITY as well, which is what both new rungs need: the ⊎ lift needs to know
-- there is an argument to bind, and the induction needs to know WHICH argument
-- is the recursive one.  `dCons` is kept, unchanged, so rungs two and three
-- behave exactly as they did.
data Con = Con { cnName :: String, cnArgs :: [String] }

data Datatype = Datatype { dName :: String, dCons :: [String], dConsFull :: [Con] }

readData :: String -> [Datatype]
readData src = go (lines src)
  where
    go [] = []
    go (l:ls)
      | "data " `isPrefixOf` l, (_:nm:_) <- words l, last (words l) == "where"
          = let (blk, rest) = span indented ls
            in Datatype nm (nullaryCons blk) (fullCons blk) : go rest
      | otherwise = go ls
    indented (c:_) = isSpace c
    indented _     = True
    -- a constructor line `  c : T` with no arrow is nullary
    nullaryCons blk = [ c | b <- blk, Just (c, ty) <- [breakColon b]
                      , let c' = trim c
                      , not (null c'), all (\x -> isAlphaNum x || x `elem` "-_'₀₁₂₃₄₅₆₇₈₉") c'
                      , not (elem '→' ty) ]
    -- `  c₁ c₂ : A → B → T` → one Con per name, args [A, B].
    --
    -- FOUR LIMITS, at the site.  (1) A constructor whose type spans lines is
    -- read only as far as the first line.  (2) An IMPLICIT binder `{n : ℕ} →`
    -- is dropped, which is right for a pattern but means an indexed family's
    -- index is invisible here.  (3) An explicit binder `(x : A) →` keeps `A`.
    -- (4) The result type is discarded, so a GADT-style constructor landing in
    -- a different index than the one asked about is not detected; the kernel
    -- is the filter for that, as everywhere else here.
    fullCons blk = [ Con nmc (conArgTypes ty)
                   | b <- blk, Just (nms, ty) <- [breakColon b]
                   , nmc <- words (trim nms)
                   , all (\x -> isAlphaNum x || x `elem` "-_'₀₁₂₃₄₅₆₇₈₉") nmc
                   , not (null nmc) ]

-- everything before the LAST top-level arrow, each binder reduced to its type
conArgTypes :: String -> [String]
conArgTypes ty = case arrowParts (trim ty) of
  []  -> []
  ps  -> mapMaybe binderType (init ps)
  where
    binderType s0 =
      let s = trim s0 in
      case (s, reverse s) of
        ('{':_, '}':_) -> Nothing                    -- implicit: not a pattern arg
        ('(':_, ')':_) -> case breakColon (init (drop 1 s)) of
                            Just (_, t) -> Just (trim t)
                            Nothing     -> Just (trim (init (drop 1 s)))
        _ | null s     -> Nothing
          | otherwise  -> Just s

-- split on every top-level `→`, respecting ( ) and { }
arrowParts :: String -> [String]
arrowParts s = reverse (map (trim . reverse) (go s (0 :: Int) "" []))
  where
    go [] _ acc out = acc : out
    go r@(c:cs) n acc out
      | c == '→', n == 0 = go cs n "" (acc : out)
      | c `elem` "({"    = go cs (n + 1) (c:acc) out
      | c `elem` ")}"    = go cs (n - 1) (c:acc) out
      | otherwise        = go cs n (c:acc) out
      where _ = r

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
  -- 2026-08-22.  The one line that lifts «case on ⊎».  Everything above reads
  -- NULLARY constructors only, so a type whose constructors carry arguments —
  -- `inl : A → A ⊎ B` is the whole of the four blocked pairs — fell to rung
  -- one and the split was never even attempted.  `coverOf` binds the argument
  -- instead of refusing to look at it.  Tried LAST, so rungs two and three
  -- keep exactly the behaviour they had; this only fires where they gave up.
  _ -> case coverOf hf ty of
         Just (ps@(_:_), _) ->
           "(λ { " ++ intercalate " ; " [ p ++ " → refl" | p <- ps ] ++ " })"
         _ -> "(λ _ → refl)"

-- ─────────────────────────────────────────────────────────────────────────
-- CONSTRUCTORS WITH ARGUMENTS — the shared floor of rungs 2′ and five.
--
-- `consOf` answers "what are the nullary constructor NAMES of this type".
-- That question cannot see `inl`, `suc`, or `_∷_`, and those three are what
-- the histogram's top three classes are made of.  `consFullOf` answers the
-- larger question — name AND argument types — for the four shapes that
-- actually occur in this corpus's signatures, plus the host's own `data`.
--
-- LIMIT, stated because it is the difference between a cover and a guess:
-- the library rows below are HARD-CODED, and they are hard-coded against
-- `Cubical.Data.{Bool,Nat,Sum,List}`.  A host that means a DIFFERENT type by
-- one of these names gets patterns written against the wrong constructors,
-- the kernel refuses, and the refusal is recorded — which is the direction
-- this program has always erred in, over-proposing into an exact checker.
consFullOf :: HostFacts -> String -> Maybe [Con]
consFullOf hf ty0
  | t == "Bool"                = Just [Con "false" [], Con "true" []]
  | t `elem` ["ℕ", "Nat"]      = Just [Con "zero" [], Con "suc" [t]]
  | Just (a, b) <- sumParts t  = Just [Con "inl" [a], Con "inr" [b]]
  | "List " `isPrefixOf` t     = let el = trim (drop 5 t)
                                 in Just [Con "[]" [], Con "_∷_" [el, t]]
  | otherwise = case [ d | d <- hData hf, dName d == t, not (null (dConsFull d)) ] of
      (d:_) -> Just (dConsFull d)
      []    -> Nothing
  where t = trim (stripOuter (unalias hf ty0))

-- The imports a cover written against `ty`'s constructors needs.  A
-- CONSTRUCTOR NOT IN SCOPE IS A PATTERN VARIABLE IN AGDA — the trap this file
-- already paid for once with `true`/`false` — so every library row above
-- carries the `using (…)` that makes its names mean what they say.
importsFor :: HostFacts -> String -> [String]
importsFor hf ty0
  | t == "Bool"            = ["open import Cubical.Data.Bool using (true ; false)"]
  | t `elem` ["ℕ", "Nat"]  = ["open import Cubical.Data.Nat using (zero ; suc)"]
  | Just (a, b) <- sumParts t
      = "open import Cubical.Data.Sum using (inl ; inr)"
        : importsFor hf a ++ importsFor hf b
  | "List " `isPrefixOf` t
      = "open import Cubical.Data.List using ([] ; _∷_)"
        : importsFor hf (trim (drop 5 t))
  | isJust (finArity hf t) = ["import Cubical.Data.FinData as अनुलोमFin"]
  | otherwise = concatMap (importsFor hf) (let fs = factorsOf t
                                           in if length fs > 1 then fs else [])
  where t = trim (stripOuter (unalias hf ty0))

-- ─────────────────────────────────────────────────────────────────────────
-- `Fin n` FOR A LITERAL n, AND ONLY WHERE THE HOST MEANS `FinData`.
--
-- The run that built rung five named this as the cheapest thing left, and
-- named it twice over: two pairs filed under «enumerate Fin n», and two more
-- filed under «case on ⊎» that turned out to be ⊎ over `Fin 3` — the sum was
-- split, and the argument underneath was a variable nothing could discharge.
--
-- THREE CONDITIONS, all of them refusals to guess.
--
--  १. The arity must be a LITERAL.  `Fin 6` enumerates; `Fin n` does not, and
--     an induction on the index is a different rung.
--  २. The host must import `Cubical.Data.FinData`.  `Cubical.Data.Fin.Fin` is
--     a Σ over `_<_` with no constructors to name, and writing FinData's
--     patterns against it would fail as `NotInScope` — which this program
--     files as MY defect, so the wrong guess would also hide its own cause.
--  ३. The import is QUALIFIED.  `FinData`'s constructors are `zero` and
--     `suc`, the same two names ℕ contributes, and a probe that needs both —
--     `PMTorus.finToEdge : Fin 9 → Edge` beside any ℕ-typed side — would have
--     them ambiguous.  `PMTorus` itself renames them to `fz`/`fs` on import,
--     which is the host making the same decision by hand.
finArity :: HostFacts -> String -> Maybe Int
finArity hf t0 = case words (trim (stripOuter (unalias hf t0))) of
  [f, n] | last (splitDots f) == "Fin", all (\c -> c >= '0' && c <= '9') n
         , not (null n), any ("Cubical.Data.FinData" `isInfixOf`) (hImp hf)
         , (k :: Int) <- read n, k > 0, k <= 32 -> Just k
  _ -> Nothing
  where splitDots s = case break (== '.') s of
          (a, '.':b) -> a : splitDots b
          (a, _)     -> [a]

-- `Fin 3` → [अनुलोमFin.zero, अनुलोमFin.suc अनुलोमFin.zero, …], as PATTERNS.
finPats :: Int -> [String]
finPats k = [ wrap (tower i) | i <- [0 .. k - 1] ]
  where
    q s = "अनुलोमFin." ++ s
    tower 0 = q "zero"
    tower i = q "suc" ++ " (" ++ tower (i - 1) ++ ")"
    wrap s = if ' ' `elem` s then "(" ++ s ++ ")" else s

stripOuter :: String -> String
stripOuter s0 = case (s, reverse s) of
    ('(':_, ')':_) | bal 0 (init (drop 1 s)) -> stripOuter (trim (init (drop 1 s)))
    _ -> s
  where
    s = trim s0
    bal :: Int -> String -> Bool
    bal n ('(':r) = bal (n + 1) r
    bal n (')':r) = n > 0 && bal (n - 1) r
    bal n (_:r)   = bal n r
    bal n []      = n == 0

-- first top-level ` ⊎ `.  `_⊎_` associates to the right, so splitting at the
-- FIRST one gives `A` and `B ⊎ C` — which is the shape the patterns want.
sumParts :: String -> Maybe (String, String)
sumParts s0 = go (stripOuter s0) (0 :: Int) ""
  where
    go [] _ _ = Nothing
    go r@(c:cs) n acc
      | " ⊎ " `isPrefixOf` r, n == 0 = Just (trim (reverse acc), trim (drop 3 r))
      | c == '(' = go cs (n + 1) (c:acc)
      | c == ')' = go cs (n - 1) (c:acc)
      | otherwise = go cs n (c:acc)

-- An EXHAUSTIVE pattern cover for a type, with the imports it needs.  Where a
-- constructor argument is itself coverable the cover recurses into it; where
-- it is not, the argument is bound to a FRESH VARIABLE, which is still an
-- exhaustive cover and is the point — `inl w₀` covers all of `A` without
-- knowing anything about `A`.
--
-- Returns Nothing when the type is RECURSIVE.  That is deliberate: a
-- recursive type has no finite cover, and pretending otherwise is what rung
-- five exists to stop doing.  It is also bounded at depth three and at 32
-- patterns, so a census can never blow up on a wide product.
coverOf :: HostFacts -> String -> Maybe ([String], [String])
coverOf hf ty00 = fmap (\ps -> (ps, nub (importsFor hf ty00))) (go (3 :: Int) ty00)
  where
    go :: Int -> String -> Maybe [String]
    go 0 _ = Nothing
    go d ty0 =
      let ty = trim (stripOuter (unalias hf ty0)) in
      case finArity hf ty of
       Just k -> Just (finPats k)
       Nothing -> case sumParts ty of
        Just _ -> viaCons d ty
        Nothing -> case factorsOf ty of
          fs@(_:_:_) -> do
            css <- mapM (go (d - 1)) fs
            cap [ "(" ++ intercalate " , " k ++ ")" | k <- sequence css ]
          _ -> viaCons d ty
    viaCons d ty = do
      cons <- consFullOf hf ty
      if null cons || any (isRecCon hf ty) cons then Nothing else do
        pss <- mapM (conPat d) cons
        cap (concat pss)
    conPat _ (Con n [])   = Just [n]
    conPat d (Con n args) = do
      argss <- mapM (\(i, a) -> pure (fromMaybe [freshVar i] (go (d - 1) a)))
                    (zip [0 :: Int ..] args)
      cap [ applyCon n k | k <- sequence argss ]
    cap ps = if length ps > 32 then Nothing else Just ps

freshVar :: Int -> String
freshVar i = "w" ++ [ "₀₁₂₃₄₅₆₇₈₉" !! (i `mod` 10) ]

-- `_∷_` is written infix in a pattern; everything else prefix.
applyCon :: String -> [String] -> String
applyCon n as
  | n == "_∷_", [x, y] <- as = "(" ++ x ++ " ∷ " ++ y ++ ")"
  | null as                  = n
  | otherwise                = "(" ++ n ++ " " ++ unwords as ++ ")"

-- infix form for the BODY of a cong, where the constructor is applied to
-- terms rather than matched.
isRecCon :: HostFacts -> String -> Con -> Bool
isRecCon hf self c = any (sameType hf self) (cnArgs c)

sameType :: HostFacts -> String -> String -> Bool
sameType hf a b = norm (stripOuter (unalias hf a)) == norm (stripOuter (unalias hf b))

-- ─────────────────────────────────────────────────────────────────────────
-- RUNG FIVE.  THE INDUCTION, WHICH IS NOT A LAMBDA.
--
-- Every rung below this one emits an EXPRESSION — `refl`, a `λ { … }`, a
-- `Σ≡Prop`.  An expression cannot call itself, and the ten pairs the run's
-- own histogram named as blocked on «induction on ℕ» all want exactly that:
--
--     g (f zero)    ≡ zero        is refl
--     g (f (suc n)) ≡ suc n       is `cong suc` applied to THE SAME LEMMA at n
--
-- So this rung emits a `where`-bound recursive lemma, not a term.  For a type
-- T whose constructors are `c₁ … cₖ`, with `cᵢ` carrying exactly one argument
-- of type T at position j:
--
--     अनुलोमन : ∀ b → f (g b) ≡ b
--     अनुलोमन c₁                = refl                       -- no recursion
--     अनुलोमन (cᵢ a₀ … aₙ)      = cong (λ z → cᵢ a₀ … z … aₙ) (अनुलोमन aⱼ)
--
-- THE TYPE IS STILL NOT WRITTEN DOWN, and that is not a stylistic choice —
-- it is the repair that made this program work at all (see FIRST RUN below:
-- three whole runs died on a restated type disagreeing with the host).
-- `∀ b →` binds `b` with its domain left as a metavariable, and `g b` in the
-- body determines it.  Nothing is asserted twice, so nothing can disagree.
--
-- WHY `cong (λ z → …)` AND NOT `cong cᵢ`.  For `suc` the two coincide.  For
-- `_∷_` they do not: the recursive argument is the SECOND, and `cong (x ∷_)`
-- is a section that has to be written per constructor.  The lambda form is
-- one shape for every constructor and every position, and it costs nothing.
--
-- FIVE LIMITS, at the site.
--
--  1. **ONE recursive argument per constructor, or the rung declines.**  A
--     binary node `app : Tm → Tm → Tm` needs `cong₂` and TWO appeals to the
--     hypothesis, and emitting `cong` there would be a guess.  Declined, and
--     the pair keeps whatever lower rung it had.
--  2. **The successor branch must reduce.**  `cong (λ z → suc z) (ih n)` has
--     type `suc (f (g n)) ≡ suc n`, and the goal is `f (g (suc n)) ≡ suc n`.
--     Those are the same type only when `f (g (suc n))` REDUCES to
--     `suc (f (g n))` definitionally.  When the composite instead multiplies —
--     `IntegerHullMultiplicity.K (hull (suc t))` is `suc (suc (suc (suc (suc
--     (K (hull t))))))`, five per step — the cong does not typecheck and the
--     kernel says so.  That is a true refusal of THIS PROOF SHAPE and is
--     recorded as one; it is NOT a refutation of the pair.
--  3. **A pair needing induction on BOTH sides needs it on both.**  This rung
--     runs per side, so `FreeMonoid.len ⇄ unlen` gets the ℕ induction on one
--     side and the List induction on the other, and both must land or the
--     probe still refuses.  That is why the class counts do not predict the
--     number of closures, and why the report below counts closures separately.
--  4. **Indices are invisible.**  `conArgTypes` drops implicit binders, so an
--     indexed family — the four `मम दोषः · indexed family` rows — is not
--     reached by this rung and was never going to be.
--  5. **A mutually recursive pair of types is not handled**: the recursion
--     test asks only whether an argument is the SAME type, so `data A … (b :
--     B)` / `data B … (a : A)` reads as non-recursive and gets a cover of
--     variables, which will simply fail to prove anything.
inductionFor :: HostFacts -> String -> String -> String -> Maybe ([String], [String])
inductionFor hf lemma stmt ty0 = do
  let ty = trim (stripOuter (unalias hf ty0))
  cons <- consFullOf hf ty
  if not (any (isRecCon hf ty) cons) then Nothing else do
    clauses <- mapM (clause ty) cons
    pure ( (lemma ++ " : " ++ stmt) : clauses
         , nub (importsFor hf ty) )
  where
    clause ty (Con n args) =
      let vs   = [ freshVar i | (i, _) <- zip [0 :: Int ..] args ]
          recs = [ i | (i, a) <- zip [0 :: Int ..] args, sameType hf ty a ]
          pat  = applyCon n vs
      in case recs of
           []  -> Just (lemma ++ " " ++ pat ++ " = refl")
           [j] -> let body = applyTerm n [ if i == j then "z" else v
                                         | (i, v) <- zip [0 :: Int ..] vs ]
                  in Just (lemma ++ " " ++ pat ++ " = cong (λ z → " ++ body
                           ++ ") (" ++ lemma ++ " " ++ (vs !! j) ++ ")")
           _   -> Nothing

applyTerm :: String -> [String] -> String
applyTerm n as
  | n == "_∷_", [x, y] <- as = x ++ " ∷ " ++ y
  | null as                  = n
  | otherwise                = n ++ " " ++ unwords as

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
  -- 2026-08-22.  The host's own import lines, verbatim.  A cover written
  -- against a LIBRARY type's constructors is only sound if the host means
  -- that library's type: `Fin` is `Cubical.Data.FinData.Fin`, a `data` with
  -- `zero` and `suc`, in one module and `Cubical.Data.Fin.Fin`, a `Σ` over
  -- `_<_`, in another.  Enumerating the second as though it were the first
  -- is a fabricated provenance in the small, and the kernel would only ever
  -- say `NotInScope`, which reads as MY defect and hides the real reason.
  , hImp     :: [String]
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
data Rung = RungOne | RungTwoThree | RungFour | RungFive deriving (Eq, Ord, Show)

rungName :: Rung -> String
rungName RungOne      = "१ refl"
rungName RungTwoThree = "२/३ split"
rungName RungFour     = "४ Σ≡Prop"
rungName RungFive     = "५ induction"

-- What one side of the round trip contributes to the probe: the TERM handed
-- to `iso`, any `where`-bound lemmas it needs, and the imports those lemmas'
-- constructors need.  Rungs one to four never fill the last two; rung five is
-- the reason they exist, because a recursive lemma cannot be an expression.
data Term = Term { tText :: String, tWhere :: [String], tImp :: [String] }

plain :: String -> Term
plain s = Term s [] []

-- `lemma` is the name the where-block binds, `stmt` the statement written
-- WITHOUT naming the type — `∀ b → f (g b) ≡ b`.  Rung five is tried after
-- rung four (an h-level abstraction beats an induction when both apply) and
-- before rungs two/three, because a recursive type has no finite cover and
-- whatever those two would emit for it is `λ _ → refl` in a split's clothes.
ladderFor :: HostFacts -> String -> String -> String -> (Term, Rung)
ladderFor hf lemma stmt ty0
  | Just t <- sigmaSplit hf ty = (plain t, RungFour)
  | Just (ws, imps) <- inductionFor hf lemma stmt ty
      = (Term lemma ws imps, RungFive)
  | otherwise = let t = splitFor hf ty
                in ( Term t [] (if t == "(λ _ → refl)" then [] else importsFor hf ty)
                   , if t == "(λ _ → refl)" then RungOne else RungTwoThree)
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
-- 2026-08-22, AND THIS REPAIR COST THE ONLY TWO "NEW EDGES" THIS PROGRAM HAS
-- EVER PRINTED.  With the Fin cover in place the kernel accepted
-- `PMTorus.edgeToFin ⇄ finToEdge` and `finToVertex ⇄ vertexToFin`, and the
-- run announced both as NEW EDGES.  They are not.  `edgeIso : Iso Edge (Fin
-- E)` is at PMTorus.agda:415 and `vertexIso : Iso Vertex (Fin V)` at :374,
-- proved by hand in the same file — and the check missed them because the
-- SIGNATURES say `Fin 9` and `Fin 6` while the Isos say `Fin E` and `Fin V`,
-- with `E = 9` and `V = 6` sitting in the host's own alias table.  That is
-- verbatim the blind spot the retraction named — "an Iso stated between
-- aliases of the same types under different names is not caught, so this
-- number is a FLOOR" — and the FIRST time the emitter got strong enough to
-- reach one of those pairs, the floor was reported as a discovery.
--
-- Every TOKEN of each type is now resolved through the alias table before
-- the names are compared, so `Fin E` and `Fin 9` are the same string.  The
-- number is still a floor: an Iso through a `record`, or one whose two sides
-- are written with different binders, is still invisible.  **A green that
-- restates a host Iso is not an edge, and this program has now produced ZERO
-- edges across six passes.**
alreadyProved :: HostFacts -> String -> String -> Maybe String
alreadyProved hf a b =
  listToMaybe [ n | (n, t) <- hSigs hf
                  , let t' = resolve t
                  , t' `elem` [ "Iso" ++ na ++ nb, "Iso" ++ nb ++ na
                              , na ++ "≃" ++ nb, nb ++ "≃" ++ na ] ]
  where
    na = resolve a; nb = resolve b
    resolve = norm . unwords . map (unalias hf) . words . spread
    -- so `(Fin E)` tokenises as `( Fin E )` and `E` is looked up alone
    spread = concatMap (\c -> if c `elem` "()" then [' ', c, ' '] else [c])

-- ─────────────────────────────────────────────────────────────────────────
-- THE HOST'S OWN DISPROOF, 2026-08-24.
--
-- `alreadyProved` asks whether the host already carries the Iso or the ≃.
-- Nothing asked the opposite question, and the opposite question has
-- answers: a host that proves `outer (inner v) ≡ SOMETHING-ELSE` has proved
-- the round trip false, and the pair is खण्डितम्, not an obligation.
--
-- Worked, and it is the case this was written for.  `NaturalMachine.Charge
-- TwoHistories` has `sign z = (z , - z)`, `augment (x , y) = x + y` and
-- `relative (x , y) = x - y`, so `augment ∘ sign` is the constant zero and
-- `relative ∘ sign` is doubling.  Neither is the identity, and the module
-- proves both — `augment-sign : (z : ℤ) → augment (sign z) ≡ pos 0` and
-- `relative-sign : (z : ℤ) → relative (sign z) ≡ z +ℤ z`, `solve! ℤCommRing`,
-- checked.  The ledger carried both pairs as «library lemma on ℤ».
--
-- THE PARSE REFUSES RATHER THAN GUESSES, and that direction is not
-- negotiable: a wrong «proved» merely wastes a probe, but a wrong «refuted»
-- DELETES REAL WORK from the queue and nothing downstream would ever look
-- again.  So the argument must be a single identifier, an `≡` must follow
-- the application, and the right-hand side must be non-empty; anything less
-- certain returns Nothing and the pair is asked as usual.
alreadyRefuted :: HostFacts -> Sig -> Sig -> Maybe String
alreadyRefuted hf f g =
  listToMaybe [ n ++ " : " ++ trim t
              | (n, t) <- hSigs hf
              , (outer, inner) <- [ (sName f, sName g), (sName g, sName f) ]
              , Just (arg, rhs) <- [ roundTripRHS outer inner t ]
              , arg /= rhs ]

-- `… outer (inner v) ≡ RHS` → `Just (v, RHS)`.
roundTripRHS :: String -> String -> String -> Maybe (String, String)
roundTripRHS outer inner t = do
  rest <- listToMaybe (after (outer ++ " (" ++ inner ++ " ") t)
  let (argRaw, afterArg) = break (== ')') rest
      arg = trim argRaw
  guard (not (null afterArg) && not (null arg) && all identChar arg)
  rhs <- trim <$> listToMaybe (after "≡" (drop 1 afterArg))
  -- An arrow or a second `≡` after the equation means the round trip is the
  -- ANTECEDENT of something, not the statement, and the text to the right is
  -- not its value.  Refuse: the cost of a missed refutation is one wasted
  -- probe; the cost of a wrong one is deleted work.
  guard (not (null rhs) && not ("→" `isInfixOf` rhs) && not ("≡" `isInfixOf` rhs))
  pure (arg, rhs)
  where
    identChar c = isAlphaNum c || c `elem` ("'-_₀₁₂₃₄₅₆₇₈₉" :: String)

-- Every suffix of `hay` that follows an occurrence of `needle`.
after :: String -> String -> [String]
after needle hay =
  [ drop (length needle) s | s <- tails hay, needle `isPrefixOf` s ]

readHostFacts :: String -> HostFacts
readHostFacts src = HostFacts (readData src) (M.fromList aliases) sigs imps
  where
    ls  = [ l | l <- lines (stripComments src), col0 l ]
    col0 (c:_) = not (isSpace c) && c /= '-' && c /= '{' && c /= '#'
    col0 _     = False
    sigs = [ (trim n, trim t) | l <- ls, Just (n, t) <- [breakColon l]
           , all okName (trim n), not (null (trim n)) ]
    imps = [ trim l | l <- lines (stripComments src)
           , "open import " `isPrefixOf` trim l || "import " `isPrefixOf` trim l ]
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


------------------------------------------------------------------------
-- निवृत्त · WHERE A SUPERSEDED ROW GOES.
--
-- सूत्र ९ — शेषं रक्ष.  The ledger key is a CONTENT address, so editing a
-- definition upstream mints a fresh key and the row under the old key
-- survives `M.union` forever.  Measured 2026-08-22: 163 rows carrying 41
-- distinct questions, and 183 rows carrying the same 41 twenty minutes
-- later.  A superseded row is not an open obligation.  Counting it as one
-- is the ledger reporting its own accretion as the corpus's debt.
--
-- Retired, never deleted.  `check-no-silent-deletion.sh` is the standing
-- rule and this is why: the retired row is the evidence that the question
-- was asked at an earlier digest, and that is history, not noise.
------------------------------------------------------------------------

retiredPath :: FilePath
retiredPath = "notes/anuloma/NirnayaPanjika.nivrtta.tsv"

appendRetired :: [Row] -> IO ()
appendRetired rs = do
  createDirectoryIfMissing True (takeDirectory retiredPath)
  ok <- doesFileExist retiredPath
  unless ok $ writeFile retiredPath
    ("# निवृत्त — rows whose pair was re-asked this pass at a CURRENT digest,\n\
     \# so this row's digest is superseded.  Kept, not deleted: शेषं रक्ष.\n\
     \# A pair that was simply not asked is NOT retired — मौनं न निषेधः.\n\
     \# addrF\taddrG\trung\tprobe\tverdict\tclass\twhere\tobligation\n")
  appendFile retiredPath $ unlines
    [ intercalate "\t" [ rKeyF r, rKeyG r, rRung r, rProbe r, show (rVerdict r)
                       , rClass r, rWhere r, one (rObl r) ] | r <- rs ]
  where one = map (\c -> if c == '\n' || c == '\t' then ' ' else c)
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
-- The stamp `runAgda` puts on the exception path.  It is tested before every
-- other guard, because a process that did not start has no opinion about
-- mathematics and no opinion about module paths either.
agdaAbsent :: String
agdaAbsent = "अनुलोम-प्रतिलोम: agda did not run: "

-- True when the module agda could not find is a LIBRARY module, not one of
-- ours.  Every module this emitter writes an import for is either literal
-- `Cubical.*` or the host's own `sMod`, so the test is on the head alone and
-- needs no list of our modules to stay in sync with.
cubicalMissing :: String -> Bool
cubicalMissing out =
  or [ "Cubical." `isInfixOf` l
     | l <- lines out, "Failed to find source" `isInfixOf` l ]

classify :: HostFacts -> String -> (String, String)
classify hf out
  | agdaAbsent `isInfixOf` out           = (envFault "agda did not run", firstErr)
  | "MetaCannotDependOn" `isInfixOf` out = (myFault "indexed family", firstErr)
  | "NotInScope"         `isInfixOf` out = (myFault "not in scope",   firstErr)
  | "CoverageIssue"      `isInfixOf` out = (myFault "split incomplete", firstErr)
  -- 2026-08-24.  ONE LABEL WAS COLLAPSING TWO STANDPOINTS, and it is the
  -- दुर्नय this classifier's own header is about.  `Failed to find source of
  -- module Cubical.Foundations.Prelude` and `… of module NaturalMachine.Digits`
  -- are not one defect.  The first says THE LIBRARY IS NOT CONFIGURED — see
  -- `librariesArg`, which passes no `--library-file` at all unless
  -- ANULOMA_LIBRARIES names an existing one, so a host without
  -- `~/.agda/libraries` fails EVERY probe at its first import.  The second
  -- says this program computed a module name wrong.  They have different
  -- owners and different repairs, and filing the first as मम दोषः sends the
  -- next reader to audit `modNameOf`, which is correct.
  | "Failed to find source" `isInfixOf` out
  , cubicalMissing out                    = (envFault "agda library not configured", firstErr)
  | "Failed to find source" `isInfixOf` out = (myFault "module path", firstErr)
  -- A CONSTRUCTOR THE PROBE NAMED BUT DID NOT IMPORT BINDS A VARIABLE, so
  -- the split is not a split.  Agda says this as a -W warning while the
  -- mathematics fails underneath; here it is a defect of mine and counted
  -- as one.  See the Bool import in `probe`.
  | "PatternShadowsConstructor" `isInfixOf` out
      = (myFault "constructor not imported", firstErr)
  | any (`isInfixOf` out) ["UnreachableClause", "Unreachable clause"]
      = (myFault "clause unreachable — the split degenerated", firstErr)
  -- 2026-08-22, AND THIS ONE IS A REGRESSION RUNG FIVE CAUSED.  `!=<` is
  -- Agda's SUBTYPE failure, not its equality failure: it says the thing I
  -- WROTE does not have the type it must have, which for this program is
  -- always the statement `∀ b → f (g b) ≡ b` handed to an indexed family
  -- whose index the emitter cannot bind (`Word b → ℕ !=< ℕ`).  Before rung
  -- five those three pairs died at `MetaCannotDependOn` and were correctly
  -- filed as मम दोषः; rung five changed the shape of the error and they
  -- slid into «unclassified», which is the corpus's bucket, not mine.  A
  -- defect of the instrument that has moved into the corpus's column is the
  -- exact दुर्नय this histogram was built to prevent, one level down.
  | "!=<" `isInfixOf` out = (myFault "statement ill-typed · indexed family", firstErr)
  -- A REFUTED PAIR IS NOT AN OPEN OBLIGATION, and filing it as one inflates
  -- the queue with work nobody should do.  See `refuted` below for the three
  -- shapes this is willing to call refuted and the reason each is sound.
  | Just why <- refuted firstErr = ("खण्डितम् · " ++ why, firstErr)
  | otherwise = (ofType (typeOfObligation out), firstErr)
  where
    myFault s = "मम दोषः · " ++ s
    -- परिस्थितिः — the circumstance of the run.  NOT a third flavour of my
    -- defect: nobody edits this program to fix it and nobody proves
    -- anything to fix it.  The probe was never typechecked, so the row is
    -- evidence about the host that ran it and about nothing else.
    envFault s = "परिस्थितिः · " ++ s
    -- ─────────────────────────────────────────────────────────────────
    -- 2026-08-24.  THE WITNESS COLUMN WAS EMPTY ON EVERY ROW OF THE
    -- LARGEST CLASS, AND THAT IS THIS FILE'S OWN PROHIBITION BROKEN.
    --
    -- `firstErr` anchored on a line containing `error:` and took the four
    -- after it.  Agda does not put every diagnostic in that form.
    -- `Failed to find source of module X in any of the following
    -- locations:` has NO `error:` line, so `dropWhile` consumed the whole
    -- output, `drop 1 []` was `[]`, and the witness was the EMPTY STRING.
    -- Measured on `notes/anuloma/NirnayaPanjika.tsv` before this change:
    -- 36 rows classed `मम दोषः · module path`, **36 of them with an empty
    -- obligation column** — a refusal that does not name its defect,
    -- which `machine/Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal.hs`
    -- in this same directory says is not a refusal, and which
    -- `Nirnaya_TheVerdictCannotDropItsWitness.agda` states as a theorem
    -- about verdicts.  The class label survived; the one fact that would
    -- have closed the bug in a second — WHICH module failed to resolve —
    -- was thrown away 36 times.
    --
    -- The repair is a fallback, not a rewrite: when an `error:` line
    -- exists the window is byte-for-byte what it was, so no existing row
    -- changes meaning.  When none exists the first four NON-BLANK lines
    -- of agda's output are the witness, which for this class carries the
    -- module name in the first line.
    --
    -- A count is the collapse again (`Uttara_…NeverABareBoolean`, नष्ट
    -- item by item): `36 module path` without the modules is ∥·∥₁ of the
    -- defects.
    firstErr = trim (unwords (take 40 (words (unlines (take 4 window)))))
    window = case dropWhile (not . isInfixOf "error:") (lines out) of
      (_ : rest) -> rest
      []         -> filter (not . null . trim) (lines out)
    -- THE ORDER OF THESE GUARDS IS THE CLASSIFICATION, and getting it wrong
    -- misnames the move.  `List Nat` matched `Nat` first and was filed under
    -- «induction on ℕ» — the wrong feature request, because the induction
    -- that closes it is on the LIST.  The outer former decides, so the
    -- structured formers are tested before the scalars they contain.
    --
    -- AND THE MATCH IS ON WHOLE HEADS, NOT SUBSTRINGS.  `Nat` is a substring
    -- of `NaturalMachine`, so `NaturalMachine.HaskellDiscoveryBoundary.
    -- HaskellTerm` was classified «induction on ℕ» — a feature request for a
    -- rung that would not have touched it.  Every token is stripped of its
    -- module qualifier and compared whole.
    ofType t
      | null t                          = "unclassified"
      | isJust (sigmaOf hf t)           = "Σ≡Prop"
      -- `SetQuotients` only ever appears as a module qualifier, and the
      -- quotient's `/` ends its token, so this one is matched on the whole
      -- string.  There is no name in this corpus it can collide with.
      | "SetQuotients" `isInfixOf` t    = "quotient elimination"
      | has "⊎"                         = "case on ⊎"
      | has "List"                      = "induction on List"
      | has "Fin"                       = "enumerate Fin n"
      | has "Σ"                         = "Σ≡Prop"
      | has "Nat" || has "ℕ"            = "induction on ℕ"
      | has "Int" || has "ℤ"            = "library lemma on ℤ"
      | has "Bool"                      = "case on Bool"
      | any ((== trim t) . dName) (hData hf) = "host enumeration (emitter gap)"
      | otherwise                       = "host type · " ++ trim t
      where
        -- last dotted segment of each token, brackets dropped
        heads = [ reverse (takeWhile (/= '.') (reverse w))
                | w0 <- words t
                , let w = filter (`notElem` "()") w0, not (null w) ]
        has s = s `elem` heads

-- ─────────────────────────────────────────────────────────────────────────
-- खण्डितम् — REFUTED.  A pair the kernel has DISPROVED, not one it is waiting
-- on.
--
-- Rung five changed what the refusals say and this class is the consequence.
-- Before it, `SQ ⇄ hull` failed with "does not reduce", which is a statement
-- about the proof shape and says nothing about the pair.  With the induction
-- emitted, the same pair fails with
--
--     SQ (hull w₀) != suc (suc (suc (suc (suc (suc (suc (SQ (hull w₀))))))))
--
-- and that is not an obligation.  It is `x ≢ suc⁷ x`, which no lemma about ℕ
-- will ever discharge, because ℕ has no fixpoint of `suc`.  Filing it under
-- «induction on ℕ» would put SEVEN successors' worth of arithmetic into a
-- work queue as though someone should go and prove it.  The histogram's whole
-- claim is that the largest class names the next emitter; a class inflated
-- with disproved pairs names the wrong one.
--
-- THREE SHAPES, and each is called refuted for a reason, not by a heuristic.
--
--  १. `x != sucᵏ x`, k ≥ 1, the two sides identical under the successors.
--     No ℕ satisfies it.  (`hull` prepends five entries per step, so the
--     counting functions come back multiplied and land here.)
--  २. Two distinct NUMERALS.  `1 != 0` is `SieveFiber`'s base case.
--  ३. Two distinct constructors OF THE SAME TYPE at the head — `inl`/`inr`,
--     `true`/`false`, `[]`/`_∷_`.  Constructors of a `data` type are
--     disjoint, so no instantiation of the variables underneath can bring
--     them together.
--
-- WHAT IT DELIBERATELY DOES NOT CLAIM.  `PingalaPrastara.aksara ⇄ parity` is
-- refuted too — `aksara ∘ parity` is n mod 2 — and this test does NOT catch
-- it, because the disagreement is `suc (aksara (parity w₀)) != aksara (parity
-- (suc w₀))` and neither side contains the other.  Under-claiming is the only
-- safe direction: a pair wrongly called refuted is silently removed from the
-- queue, and nothing downstream would ever look at it again.
--
-- AND IT IS A CLASSIFICATION, NOT A THEOREM.  The kernel refused a TERM.  That
-- the refusal has one of these three shapes is read off its text by this
-- program, and the text is Agda's, not a proof.  A refutation of the pair
-- proper is `Vyatireka_…agda`'s business, and that file already states the
-- distinction this class turns on: a failed round trip refutes THE PAIR, never
-- the types.
refuted :: String -> Maybe String
refuted obl = do
  (l0, r0) <- breakOnStr " != " (takeWhile' obl)
  let l = trim (dropQual l0); r = trim (dropQual (cut r0))
  if null l || null r || l == r then Nothing else
    case () of
      _ | Just k <- sucTower l r -> Just ("x ≢ suc" ++ show k ++ " x — ℕ has no such fixpoint")
        | Just k <- sucTower r l -> Just ("x ≢ suc" ++ show k ++ " x — ℕ has no such fixpoint")
        | all isDigitC l, all isDigitC r -> Just ("distinct numerals " ++ l ++ " ≠ " ++ r)
        | Just t <- disjointHeads (head' l) (head' r)
            -> Just ("distinct constructors of " ++ t)
        | otherwise -> Nothing
  where
    isDigitC c = c >= '0' && c <= '9'
    takeWhile' s = maybe s fst (breakOnStr " of type " s)
    cut s = maybe s fst (breakOnStr " when checking" s)
    -- strip `Agda.Builtin.Nat.Nat.` style qualifiers from every token
    dropQual = unwords . map (reverse . takeWhile (/= '.') . reverse) . words
    head' s = takeWhile (`notElem` " (") (dropWhile (`elem` "(") s)
    disjointHeads a b = listToMaybe
      [ nm | (nm, cs) <- [ ("_⊎_", ["inl", "inr"]), ("Bool", ["true", "false"])
                         , ("List", ["[]", "_∷_", "∷"]), ("ℕ", ["zero", "suc"]) ]
           , a `elem` cs, b `elem` cs, a /= b ]
    -- `b` is `suc (suc (… a …))` with k ≥ 1 successors and nothing else
    sucTower a b = go (0 :: Int) b
      where
        go k s | trim s == a = if k > 0 then Just k else Nothing
               | otherwise = case stripPrefix' "suc " (trim s) of
                   Just rest -> go (k + 1) (stripOuter rest)
                   Nothing   -> Nothing
    stripPrefix' p s = if p `isPrefixOf` s then Just (drop (length p) s) else Nothing

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
  -- 2026-08-24.  THE OUTPUT SIDE WAS UTF-8 AND THE INPUT SIDE WAS THE
  -- LOCALE'S, and this program's whole job is reading Agda files whose
  -- identifiers are Devanagari.  `hSetEncoding stdout utf8` alone leaves
  -- every `readFile` on the caller's `LC_ALL`, so under a POSIX locale
  -- `readHostFacts` dies mid-run with
  --     hGetContents: invalid argument (cannot decode byte sequence
  --     starting from 226)
  -- — 226 is the first byte of UTF-8 `≡`/`→`.  Reproduced here today
  -- against NaturalMachine/ChargeTwoHistories.agda.  It is a CRASH, not a
  -- refusal: no row, no class, no witness, the pass simply ends.
  --
  -- `punaragamana/check.sh` already carries this in its header for Agda
  -- itself ("under a POSIX locale Agda crashes while PRINTING its own error
  -- messages for the Devanagari identifiers, hiding the real diagnosis").
  -- The same trap is one layer up in the Haskell that reads those files,
  -- and 21 of the 28 `machine/*.hs` that call `readFile` still have it.
  --
  -- `setLocaleEncoding` fixes the class rather than the symptom: it covers
  -- every handle opened afterwards, so the fix cannot be defeated by adding
  -- another `readFile` later.  Ordering matters — it must precede the first
  -- read, which is why it is the first statement in `main`.
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  let lim = case dropWhile (/= "--limit") args of
              (_:n:_) -> read n
              _       -> 400 :: Int
      doCheck = "--check" `elem` args
      -- 2026-08-22.  `--fresh` puts EVERY pair to the kernel and reads no
      -- cached refusal, at the full price of the pass.  It exists because the
      -- ledger is a shared file in a shared working tree: another lane ran
      -- this program between a commit and its measurement, and the run that
      -- followed served 39 rows out of a cache it had not filled and would
      -- have reported them as its own verdicts.  A number a pass did not
      -- obtain is not that pass's number, whoever obtained it.
      doFresh = "--fresh" `elem` args
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
      hfOf f = M.findWithDefault (HostFacts [] M.empty [] []) (sMod f) factsByMod
      cands = [ Cand f g nm body rung (alreadyProved hf (sFrom f) (sTo f))
              | (f, g) <- keep
              , let hf   = hfOf f
                    nm   = "AnulomaPratiloma_" ++ sanitize (sMod f) ++ "_"
                           ++ sanitize (sName f) ++ "_" ++ sanitize (sName g)
                    -- the two statements, written without naming a type: the
                    -- domain and codomain are DETERMINED by f and g, and
                    -- restating them is what killed the first three runs.
                    stR  = "∀ b → " ++ sName f ++ " (" ++ sName g ++ " b) ≡ b"
                    stL  = "∀ a → " ++ sName g ++ " (" ++ sName f ++ " a) ≡ a"
                    (rt, r1) = ladderFor hf "अनुलोमन"  stR (sTo f)
                    (lt, r2) = ladderFor hf "प्रतिलोमन" stL (sFrom f)
                    rung = max r1 r2
                    body = probe nm f g rt lt (r1 == RungFour || r2 == RungFour) ]
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
  when doCheck (checkAll doFresh scratch hfOf cands)

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
checkAll :: Bool -> FilePath -> (Sig -> HostFacts) -> [Cand] -> IO ()
checkAll doFresh scratch hfOf cands = do
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
        cached = if doFresh || null kf || null kg then Nothing else M.lookup key oldMap
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
            -- 2026-08-24.  THE HOST SOMETIMES PROVES THE ROUND TRIP FALSE,
            -- IN THE FILE THIS PROGRAM READ, and the kernel's residual does
            -- not say so.  `NaturalMachine.ChargeTwoHistories` defines
            -- `sign z = (z , - z)` and `augment (x , y) = x + y`, so
            -- `augment (sign b)` is `b + (- b)`; the probe asks
            -- `augment (sign b) ≡ b`, which is `0 ≡ b`, false at every
            -- nonzero b — and forty lines above the pair sits
            -- `augment-sign : (z : ℤ) → augment (sign z) ≡ pos 0`, checked.
            -- Both of that module's pairs were filed as «library lemma on
            -- ℤ», i.e. as OPEN MATHEMATICS SOMEBODY SHOULD PROVE.
            --
            -- This is the header's own defect two in the other direction:
            -- there, sixteen candidates were already PROVED in the file the
            -- program read; here they are already DISPROVED in it.  A
            -- refuted pair is not an obligation, and `classify`'s own note
            -- says filing one inflates the queue with work nobody should do.
            let hf0         = hfOf (cF c)
                (cls0, obl) = classify hf0 err
                (cls, obl') = case alreadyRefuted hf0 (cF c) (cG c) of
                  Just thm -> ("खण्डितम् · the host proves the other value", thm)
                  Nothing  -> (cls0, obl)
            putStrLn $ "  OPEN   " ++ wh ++ "   [" ++ cls ++ "]"
            unless (null obl') $ putStrLn $ "         " ++ obl'
            pure (Row kf kg (rungName (cRung c)) dg Refused cls wh obl')
  -- सूत्र ९ · शेषं रक्ष.  Retire the rows this pass superseded; keep every
  -- row whose pair was not asked (मौनं न निषेधः — not asking is not a
  -- ground for retirement).
  let fresh      = M.fromList [ (rowKey r, r) | r <- results ]
      asked      = [ rWhere r | r <- results ]
      dead k r   = not (k `M.member` fresh) && (rWhere r `elem` asked)
      superseded = [ r | (k, r) <- M.toList oldMap, dead k r ]
      merged     = M.elems (M.union fresh
                     (M.filterWithKey (\k r -> not (dead k r)) oldMap))
  unless (null superseded) $ do
    appendRetired superseded
    putStrLn $ "  निवृत्त  " ++ show (length superseded)
               ++ " superseded row(s) retired to " ++ retiredPath
               ++ "  (kept, not deleted)"
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
      -- THREE BUCKETS NOW, NOT TWO.  मम दोषः is the instrument's defects;
      -- खण्डितम् is the pairs the kernel DISPROVED; and only what is left is
      -- an obligation somebody could discharge.  A refuted pair sitting in
      -- the third bucket is the mirror of a bug sitting there — both make the
      -- queue longer than the work, and the histogram's one job is to name
      -- the next emitter by the size of a class.
      dead   = filter (isPrefixOf "खण्डितम्" . rClass) opens
      theirs = [ r | r <- opens, not (isPrefixOf "मम दोषः" (rClass r))
                                , not (isPrefixOf "खण्डितम्" (rClass r)) ]
      already = length [ () | c <- cands, isJust (cAlready c) ]
      restated = length [ () | r <- greens, rClass r == "restates a host Iso" ]
  putStrLn ""
  putStrLn "  ── the histogram: WHAT KIND of obligation is blocking ───────"
  putStrLn $ "  proposed " ++ show (length cands)
             ++ " · accepted " ++ show (length greens)
             ++ " · open " ++ show (length opens)
             ++ "  (of which " ++ show (length mine) ++ " mine, "
             ++ show (length dead) ++ " refuted, " ++ show (length theirs)
             ++ " real obligations)"
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
  putStrLn "  खण्डितम् — THE KERNEL DISPROVED THE PAIR (not work, and not a"
  putStrLn "  statement about the TYPES: only this pair of maps is refuted):"
  if null dead then putStrLn "    none this pass."
    else forM_ dead $ \r -> putStrLn $ "    " ++ rWhere r ++ "\n        " ++ rClass r
  putStrLn ""
  putStrLn "  THE MOVE EACH REMAINING OPEN PAIR IS BLOCKED ON:"
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
  -- THE EXCEPTION PATH IS NOT A KERNEL VERDICT AND MUST NOT BE READABLE AS
  -- ONE.  This file's own header records the last time it was: `timeout 90
  -- agda` where no `timeout` existed, the shell returned 127, and the loop
  -- read 127 as "refuted" — 39 times, silently, and three result blocks
  -- were false because of it.  The `catchAny` below is the same door.  So
  -- the exception is stamped with a marker the classifier tests FIRST, and
  -- a run that never started is filed as परिस्थितिः · agda did not run, never
  -- as a module path and never as an obligation.
  (rc, o, e) <- readProcessWithExitCode "agda"
                  (libs ++ ["-i", "formal/cubical", "-i", ".", dest]) ""
                  `catchAny` (\ex -> pure (ExitFailure 127, "", agdaAbsent ++ show ex))
  removeFile dest `catchAny` const (pure ())
  -- A GREEN THAT AGDA WARNED ABOUT IS NOT A GREEN HERE.  An unimported
  -- constructor is a pattern VARIABLE, so `λ { false → refl ; true → refl }`
  -- can typecheck as `λ _ → refl` wearing a split's clothes, and agda says so
  -- in a `-W` warning that exits ZERO.  This file has already been burned by
  -- that once, silently.  Rungs two, three and five all name constructors, so
  -- the warning is checked on SUCCESS as well as on failure, and an accepted
  -- probe carrying one is handed back as a refusal and classified as my
  -- defect.  Erring toward refusing my own greens is the only safe direction.
  let out = o ++ e
      degenerate = any (`isInfixOf` out)
                     ["PatternShadowsConstructor", "shadows a constructor"
                     , "UnreachableClause", "Unreachable clause"]
  pure (if rc == ExitSuccess && not degenerate then Nothing else Just out)
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

probe :: String -> Sig -> Sig -> Term -> Term -> Bool -> String
probe nm f g right left needSigma = unlines $
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
  --
  -- 2026-08-22.  This USED to be a scan of the emitted term's text for
  -- `"true →"`, `"false ,"` and four more shapes — a heuristic that had to be
  -- extended by hand every time a rung learned a new constructor, and rung
  -- five's `suc`, `[]`, `_∷_`, `inl`, `inr` would every one of them have
  -- silently become pattern VARIABLES under it.  Each rung now DECLARES the
  -- imports its own patterns need (`importsFor`), and the scan is kept only
  -- as a net under the declaration, never as the mechanism.
  ++ nub (tImp right ++ tImp left
          ++ [ "open import Cubical.Data.Bool using (true ; false)"
             | any (`isInfixOf` (tText right ++ " " ++ tText left
                                 ++ " " ++ unwords (tWhere right ++ tWhere left)))
                   ["false →", "true →", "false ,", "true ,", "false)", "true)"] ])
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
          ++ " " ++ tText right   -- rightInv: the ladder run on the codomain
          ++ " " ++ tText left    -- leftInv : the ladder run on the domain
  ]
  -- The `where` block, which is the whole of rung five.  Empty for every
  -- lower rung, and then no `where` keyword is emitted at all — a bare
  -- `where` with nothing under it is a parse error and would have converted
  -- the entire census into `मम दोषः` in one line.
  ++ (case tWhere right ++ tWhere left of
        []  -> []
        wls -> "  where" : map ("  " ++) wls)
  ++
  [ ""
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

-- ─────────────────────────────────────────────────────────────────────────
-- FIFTH BLOCK.  THE THREE REPAIRS THE RETRACTION NAMED ARE DONE, AND THE
-- NUMBERS THEY YIELD ARE BELOW.  2026-08-22, measured on 43 candidate pairs
-- (the corpus grew from 39 while this was being written; both figures are
-- printed by the run and neither is quoted from memory).
--
--     proposed                                43
--     accepted by the kernel                   2
--     …of those, restating a host Iso          2
--     NEW EDGES                                0
--     already proved in the host              11
--     open                                    41
--     …of which MY OWN DEFECTS                 6
--
-- **THE HEADLINE IS THAT NEW EDGES IS STILL ZERO, AND THAT THE TWO GREENS
-- MAKE IT MORE ZERO RATHER THAN LESS.**  The retraction above was right that
-- "0 accepted" was never measured; run properly the kernel accepts two —
-- `S3IntegerRelativeCoordinates.intersectionToKernel ⇄ kernelToIntersection`
-- at rung one, and `ProjectionChargeAudit.decode ⇄ encode` at rung two once
-- the emitter began importing the constructors it names.  Both restate an
-- `Iso` standing in their own host file.  A green that is an echo is not an
-- edge, and the only reason this can be said at all is that the census now
-- looks for the host's `≃` before it proposes.
--
-- REPAIR 1 — read the host's own equivalences and say ALREADY PROVED.  Done
-- (`alreadyProved`).  It finds ELEVEN of 43.  The retraction counted
-- SIXTEEN of 39 BY HAND, and the gap is the whole story of what a mechanical
-- check is worth: mine matches the two type names as literally written in
-- the two signatures, so `WallCertificate.quotient≃Bool` — an Iso between
-- the same types under different names — is invisible to it, and so is any
-- Iso stated through an alias.  **ELEVEN IS A FLOOR AND THE HAND COUNT IS
-- NOT WRONG.**  Stated in this direction because the reverse — quoting the
-- machine's smaller number as the answer — is how an instrument's blind spot
-- becomes a claim about the corpus, which is the exact error retracted above.
--
-- REPAIR 2 — never treat a nonzero exit as a verdict.  Done, by removing the
-- exit code from the shell entirely: `--check` runs agda in-process, and a
-- probe that dies at `MetaCannotDependOn`, `NotInScope`, `CoverageIssue` or
-- `PatternShadowsConstructor` is filed under मम दोषः and counted APART from
-- the mathematical obligations.  Six of the 41 open pairs are mine, not the
-- corpus's, and they were previously indistinguishable from refutations.
--
-- REPAIR 3 — there is no `timeout` here.  Done: nothing invokes it.  The
-- honest cost is stated at `runAgda` — there is now no wall-clock cap at all.
--
-- WHAT RUNG FOUR ACTUALLY DID, SEPARATED FROM WHAT IT WAS SUPPOSED TO DO.
-- `Σ≡Prop` is emitted, it fires on the Σ-typed candidates, and IT CLOSED
-- NOTHING.  `SaptabhangiNaya` needs the absurd `(false , false , false)`
-- branch that no enumeration reaches; `Digits` is an indexed family the
-- probe cannot even state.  The rung's value this pass is not an edge — it
-- is that the kernel's refusal on Saptabhangi now points at the ex-falso
-- branch by name instead of at a variable.  Two OTHER changes, both trivial
-- next to it, are what actually moved the numbers: resolving type aliases
-- before splitting, and importing `true`/`false` when the split names them.
-- The second one is worth the whole rung as a lesson — an unimported
-- constructor is a PATTERN VARIABLE in Agda, so the split silently was not a
-- split, and agda said so in a -W warning nobody was reading.
--
-- THE HISTOGRAM, WHICH IS THE POINT OF THE PASS.  Of the 35 open pairs that
-- carry a real obligation:
--
--     induction on ℕ                    10
--     library lemma on ℤ                 7
--     case on ⊎                          4
--     host enumeration (emitter gap)     3
--     induction on List                  3
--     case on Bool                       2
--     enumerate Fin n                    1
--     four host types, one each          4
--     unclassified                       1
--
-- Ten of 35 want the same move.  THAT is the next emitter, named by the run
-- rather than by me, and «case on ⊎» at four is the cheapest one — `inl`/
-- `inr` carry arguments, which is exactly the rung-two limit stated at the
-- top of this file and never lifted.  A loop that reports "dry" has said
-- nothing; this line is a feature request the loop wrote about itself.
--
-- AND THE LEDGER, which is what lets an overnight loop run overnight.
-- `notes/anuloma/NirnayaPanjika.tsv`, keyed on नाम's content address for
-- each of the two functions plus the FNV digest of the emitted probe.  Two
-- consecutive passes, same tree:
--
--     pass 1   43 put to the kernel      3m 50s
--     pass 2   41 served from the ledger, 2 re-checked    33s
--
-- and 30 of those 33 seconds are नाम computing the addresses.  The kernel
-- work fell from about 200 seconds to about 2.  A pass now costs what
-- CHANGED, which is the difference between a loop that can run for eight
-- hours and one that re-does forty minutes of the same refusals all night.
-- The greens are re-checked every pass on purpose: a green is a claim the
-- corpus stands on.

-- ─────────────────────────────────────────────────────────────────────────
-- SIXTH BLOCK.  RUNG FIVE — THE INDUCTION — AND THE ⊎ LIFT.  2026-08-22.
-- Every number below is from ONE command, `--check --fresh`, which reads no
-- cached row and puts all 43 pairs to the kernel.  Nothing here is quoted
-- from a prior pass.
--
-- ── WHAT GOT WORSE, FIRST ──
--
-- **A DEFECT OF MINE MOVED INTO THE CORPUS'S COLUMN.**  Three pairs —
-- `Digits.digits ⇄ value`, `Digits.digitsC ⇄ valueC`,
-- `RawWordPaddingNormalForm.paddingCount ⇄ zeroRun` — died at
-- `MetaCannotDependOn` before this work and were correctly counted as
-- मम दोषः.  Rung five hands an indexed family the statement `∀ b → f (g b) ≡
-- b`, the error becomes `Word b → ℕ !=< ℕ`, and all three slid silently into
-- «unclassified», which is the corpus's bucket.  My bug count read SIX before
-- the change and THREE after, and nothing had been fixed.  `!=<` is Agda's
-- SUBTYPE failure and in this program always means the statement I emitted is
-- ill-typed, so it is now a मम दोषः guard and the count reads six again.
-- **A histogram that reports its own defects as the corpus's refusals is the
-- दुर्नय this file was retracted for once already, and rung five walked into
-- it in the first hour.**
--
-- **AND ONE PASS MEASURED A LEDGER SOMEBODY ELSE FILLED.**  Between the
-- commit of rung five and its measurement, another lane ran this program in
-- the shared working tree; the next pass found 39 of 43 keys already in
-- `NirnayaPanjika.tsv`, printed CACHED, and would have reported those rows as
-- its own verdicts in 34 seconds.  A number a pass did not obtain is not that
-- pass's number, whoever obtained it.  `--fresh` exists for that and every
-- figure in this block was taken under it.
--
-- ── THE NUMBERS ──
--
--                                      before    after
--     proposed                             43       43
--     accepted by the kernel                2        4
--     …of those, restating a host Iso       2        4
--     NEW EDGES                             0        0
--     open                                 41       39
--     …of which MY OWN DEFECTS              6        6
--     …of which REFUTED (खण्डितम्)           —        6
--     …real obligations                    35       27
--
-- **NEW EDGES IS STILL ZERO AND BOTH NEW GREENS ARE ECHOES.**
-- `AchromaticToy.from₁₂ ⇄ to₁₂` closed on the ⊎ lift; the host carries `L₁₂`.
-- `FreeMonoid.len ⇄ unlen` closed on rung five and the emitted proof is
-- character-for-character the host's own `len-unlen`/`unlen-len`, forty lines
-- above the `ℕ≃Tally` it re-derives.  Two more machine restatements of what a
-- person had already written by hand.  That is the fourth consecutive pass in
-- which this census has produced no edge, and the count is printed apart for
-- exactly that reason.
--
-- ── RUNG FIVE CLOSED NOTHING BY ITSELF, AND THAT IS THE RESULT ──
--
-- The run's own histogram named «induction on ℕ» at ten of 35 and this rung
-- was built for those ten.  Where they went:
--
--     closed                  1   FreeMonoid.len ⇄ unlen — and only because
--                                 rung five fired on BOTH sides, ℕ and List.
--                                 An emitter for ℕ alone would have closed
--                                 ZERO of the ten.  The classes do not
--                                 predict closures and never did.
--     REFUTED                 4   SQ, N, K ⇄ hull; SieveFiber.q ⇄ σ
--     moved to «List»         2   Xs, Qs ⇄ hull — the ℕ side LANDED and the
--                                 refusal moved to the other side, which is
--                                 the rung working exactly as specified
--     still open              3   SieveScaleTower ×2, PingalaPrastara
--
-- The four refutations are the rung's real yield and they are worth more than
-- an edge would have been.  `hull` prepends five entries per step, so the
-- counting functions come back multiplied, and with the induction emitted the
-- kernel stops saying "does not reduce" and says
--
--     SQ (hull w₀) != suc (suc (suc (suc (suc (suc (suc (SQ (hull w₀))))))))
--
-- which is `x ≢ suc⁷ x`.  ℕ has no fixpoint of `suc`, so no lemma discharges
-- it: the PAIR is disproved.  It was sitting in a work queue as an open
-- obligation, and so were three others, and so were two more that the ⊎ lift
-- and the base case disproved.  **Six of the 35 "real obligations" were dead.
-- The queue was 23% longer than the work.**  They are counted apart now, and
-- the largest class the run names as the next emitter changed with them:
-- «induction on ℕ» 10 → 3, and the run now says «library lemma on ℤ», 7 of 27.
--
-- ── THE ⊎ LIFT, WHICH WAS THE CHEAPER ONE AND WAS DONE FIRST ──
--
-- `inl`/`inr` carry arguments, which is the rung-two limit stated at the top
-- of this file and never lifted.  `coverOf` binds the argument to a fresh
-- variable where it cannot enumerate it — still an exhaustive cover, and the
-- point: `inl w₀` covers all of `A` while knowing nothing about `A`.  Of the
-- four: one closed (an echo), one refuted, and TWO — both `PMTorus` — are ⊎
-- over `Cubical.Data.FinData.Fin 3`.  The split happens; `w₀ : Fin 3` is then
-- unenumerated and `refl` cannot discharge it.  **Those two were never ⊎
-- problems.  They are Fin problems wearing a ⊎, and the class still says
-- «case on ⊎» because the classifier lets the outer former decide.**  With
-- the two already filed under «enumerate Fin n», a Fin cover — three
-- patterns, qualified so its `zero`/`suc` cannot collide with ℕ's — is four
-- pairs and is the cheapest thing left on the board.
--
-- ── WHAT RUNG FIVE DOES NOT REACH, MEASURED, NOT GUESSED ──
--
--  · **Indexed families: 3 pairs, and they are the three defects above.**
--    `conArgTypes` drops implicit binders, so `value : ∀ {k} → Word k → ℕ`
--    cannot even be STATED by `∀ b → f (g b) ≡ b`.  Not a hard case — an
--    unstateable one, and the rung should decline instead of emitting.
--  · **Two recursive arguments**: `cong₂` and two appeals to the hypothesis.
--    Declined at the site rather than guessed.  No pair in this corpus hits
--    it today; `NaturalMachine.Obstruction.Tm` will.
--  · **Mutual recursion**: the test asks only whether an argument is the SAME
--    type, so a mutually recursive pair reads as non-recursive.
--  · **Any step where the composite does not commute with the constructor.**
--    `cong (λ z → c … z …) (ih aⱼ)` is one shape; where the round trip
--    multiplies or shifts, the kernel refuses, and — see above — that refusal
--    is frequently the most informative thing the pass produces.

-- ─────────────────────────────────────────────────────────────────────────
-- SEVENTH BLOCK.  THE Fin COVER — AND THE TWO NEW EDGES IT DID NOT FIND.
-- 2026-08-22, `--check --fresh`, no cached row read.
--
-- ── THE FALSE CLAIM, FIRST, BECAUSE IT WAS PRINTED ──
--
-- With the Fin cover in place the kernel accepted four more pairs and this
-- program printed, for the first time in its history:
--
--     NEW EDGES THIS PASS: 2
--       NaturalMachine.PMTorus : edgeToFin ⇄ finToEdge      — A NEW EDGE
--       NaturalMachine.PMTorus : finToVertex ⇄ vertexToFin  — A NEW EDGE
--
-- **BOTH ARE FALSE.**  `edgeIso : Iso Edge (Fin E)` is at PMTorus.agda:415
-- and `vertexIso : Iso Vertex (Fin V)` at :374, hand-proved in the same file,
-- with `edgeCount` and `vertexCount` the equivalences beside them.
-- `alreadyProved` missed both because the function signatures say `Fin 9` and
-- `Fin 6` while the Isos say `Fin E` and `Fin V`, and `E = 9`, `V = 6` are two
-- lines of the host's own alias table.
--
-- The retraction above had already named this exact hole — *"an Iso stated
-- between aliases of the same types under different names is not caught, so
-- this number is a FLOOR, never a ceiling"* — and the first time the emitter
-- got strong enough to reach one of the pairs behind it, the floor came back
-- as a discovery.  **A limit that is written down and not mechanised will be
-- reported as a result the moment it starts to matter.**  Every token of each
-- type is now resolved through the alias table before the names are compared.
-- Corrected run: 8 accepted, 8 restating a host Iso, **NEW EDGES 0**, and the
-- already-proved count rose 11 → 13 on the same repair.
--
-- ── THE NUMBERS, ACROSS THE THREE PASSES OF THIS SESSION ──
--
--                                 before   rung५+⊎   +Fin
--     proposed                        43        43     43
--     accepted                         2         4      8
--     …restating a host Iso            2         4      8
--     NEW EDGES                        0         0      0
--     open                            41        39     35
--     …MY OWN DEFECTS                  6         6      6
--     …REFUTED (खण्डितम्)               —         6      6
--     …real obligations               35        27     23
--     already proved in host          11        11     13
--
-- **THE QUEUE FELL FROM 35 TO 23 AND NOT ONE EDGE WAS ADDED.**  Twelve pairs
-- left it: six disproved, four proved to be echoes of hand proofs standing in
-- the same files, and two reclassified onto the side that actually blocks
-- them.  That is what this session bought, and it is worth stating in that
-- order — the emitter got stronger and the corpus got no larger, which is the
-- same finding the retraction reached from the other direction.
--
-- ── THE Fin COVER ──
--
-- `Fin n` for a LITERAL n, and only where the host imports
-- `Cubical.Data.FinData` — `Cubical.Data.Fin.Fin` is a Σ over `_<_` with no
-- constructors to name, and patterns written against the wrong one would fail
-- as `NotInScope`, which this program files as my defect, so a wrong guess
-- would have hidden its own cause.  The import is qualified
-- (`import Cubical.Data.FinData as अनुलोमFin`) because FinData's constructors
-- are `zero` and `suc`, the same two names ℕ contributes; `PMTorus` renames
-- them to `fz`/`fs` on its own import, which is the host making this decision
-- by hand.
--
-- It closed four pairs, and two of the four were the pairs the previous
-- histogram had filed under «case on ⊎» — the ⊎ was never the obstruction,
-- the `Fin 3` underneath it was.  «case on ⊎» went 4 → 2 → 0 and «enumerate
-- Fin n» 1 → 2 → 0.
--
-- ── WHAT THE RUN NOW ASKS FOR ──
--
--     library lemma on ℤ                7      ← named as the next emitter
--     induction on List                 5
--     induction on ℕ                    3
--     host enumeration (emitter gap)    2
--     five host types / Bool / unclassified, one each
--
-- «library lemma on ℤ» is not a rung of this ladder and should not be built
-- as one.  Its seven are `a + (- a) ≡ 0`, `- (- a) ≡ a`, `min`/`max`
-- normalisations — every one of them a lemma that `Cubical.Data.Int.Properties`
-- either has or should have, and none of them a pattern the emitter can
-- write.  The honest next move there is to look the lemmas up, not to
-- generate a proof shape.
