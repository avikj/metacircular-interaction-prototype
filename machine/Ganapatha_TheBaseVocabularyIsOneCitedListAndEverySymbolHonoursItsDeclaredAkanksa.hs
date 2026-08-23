-- गणपाठः — Gaṇapāṭha: the list the rules cite, kept once, outside them.
--
-- ---------------------------------------------------------------------
-- WHAT THIS FILE IS, IN ONE SENTENCE
--
-- The engine's base vocabulary — its Term algebra, its `Sym` record and
-- the eight symbols 0, s, +, *, max, -, gcd, le — lived inside
-- machine/MathMachine.hs, which is `module Main` and therefore importable
-- by nothing; it lives here, so the copy the engine actually runs on can
-- be READ AND RUN by another module instead of being described in prose.
--
-- ---------------------------------------------------------------------
-- WHY IT MOVED, AND WHAT WAS ESTABLISHED BEFORE IT MOVED
--
-- machine/dosa.lekha record 0023 hands forward three remainders.  The
-- third is this one, in its own words:
--
--     "move baseVocabulary out of `module Main` so the engine's own copy
--      can be compared at all.  Today the three copies of the base
--      vocabulary are checked against each other by prose in three
--      headers."
--
-- The three headers are ArithVocab.hs:151 ("Copied verbatim from
-- MathMachine.hs so this module's terms ARE its terms"), PairVocab.hs:180
-- ("Its {0,s,+,*,-} evaluators are MathMachine's, verbatim"), and this
-- file's ancestor.  Two of the three can be imported and were compared by
-- running: machine/AkanksaRun.hs §3 reports that on `+`, `*` and `-` the
-- two agree at every stated grid point and carry 2, 2 and 3 defining
-- equations against 0, 0 and 0 — the field the proof kernel is allowed to
-- use is the field that diverged.  The third copy could not be compared,
-- and "verbatim" was a claim about it that nothing could check.
--
-- It can now.  Reading it, before any run, already shows one divergence
-- that record 0023 recorded as READ and not run: this list's `s` is
-- written as an exhaustive match and refuses a wrong-length argument
-- list, where both copies calling themselves verbatim are `head vs + 1`
-- and answer.
--
-- ---------------------------------------------------------------------
-- THE SECOND REMAINDER, TAKEN HERE: ĀKĀṄKṢĀ
--
-- Record 0023's first remainder is one line per symbol; its second is
-- "make the two fields inseparable, the stronger repair, and the one that
-- would also cover symbols added later, which the first does not."  This
-- file takes the second, because moving the list is the moment at which
-- it costs nothing extra.
--
-- `Sym` carries `symArity`, a number a symbol DECLARES it is waiting for,
-- and `symSem`, a function someone WROTE.  They were independent fields.
-- An evaluator written `\vs -> vs !! 0 + vs !! 1` reads a prefix and never
-- measures the list, so `+` on [7,11,13] returned 18 — the value [7,11]
-- gives — and no caller could recover which list arrived.  That is ∥·∥₁ of
-- the argument list and it admits no retraction
-- (notes/AHIMSA_SUTRA_VISTARA.md §5; formal/cubical/
-- Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda).
--
-- The repair is `akanksitaSym`, below, and the fact that the `Sym`
-- CONSTRUCTOR IS NOT EXPORTED.  Every symbol admitted to this engine is
-- therefore built by a function that carries the declared arity into the
-- evaluator, and the two fields cannot part — including for symbols
-- imported from ArithVocab and PairVocab, which are wrapped at the
-- boundary in MathMachine.hs and are not edited by this change, and
-- including for symbols the engine invents at runtime.
--
-- WHAT IS AND IS NOT CLAIMED.  No wrong answer is claimed, before or
-- after.  Term generation is arity-respecting and no caller was known to
-- offer a mis-lengthed list, so what was repaired was LATENT and saying
-- otherwise would be the fitted-constant error in another costume.  What
-- is claimed is that the identification is now impossible to make rather
-- than merely unmade, and that a caller which regresses meets the same
-- fail-loud boundary MathMachine's `eval` already builds for an unknown
-- NAME — "unknown syntax must never acquire the accidental meaning zero"
-- — which was built for the name and not for the expectancy.
--
-- ---------------------------------------------------------------------
-- व्ययः — WHAT DID NOT TRAVEL (§31: व्ययो वक्तव्यः, तत्रैव)
--
--   − ORDER IS THE PRECEDENCE.  `precedence` in MathMachine reads an index
--     into `vocabulary`, and `vocabulary = baseVocabulary ++ …`.  The list
--     below is byte-order-identical to the one it replaces; anything
--     appended must be appended at the END or every normal form in
--     machine/library.terms becomes a different object.  That constraint
--     is carried by nothing in the type and travels only as this comment.
--   − The three copies are still three.  This file makes the engine's copy
--     COMPARABLE; it does not make ArithVocab and PairVocab import it,
--     which is the remainder record 0023's run prints ("decide which module
--     owns the base vocabulary and have the others import it").  Those two
--     files carried another lane's uncommitted work on the day this was
--     written and `git commit -o` takes the working tree, so editing them
--     would have swept it — dosa 0013's harm.  Handed forward, not swept.
--   − `akanksitaSym` measures the LENGTH of the argument list.  It says
--     nothing about the values in it, which is yogyatā and not ākāṅkṣā,
--     and is machine/Yogyata.hs's question.
--   − Making the length check forces the list's spine where `const 0` did
--     not.  Every argument list in this engine is built by `map` over a
--     finite argument list, so this is not a change in termination; it is
--     recorded because it is a change.
--
-- ---------------------------------------------------------------------
-- गणपाठः — THE TERM, AND WHOSE IT IS
--
-- Pāṇini's *Aṣṭādhyāyī* (c. 500 BCE) is about four thousand sūtras, and it
-- refers to lists of stems by a name — `sarvādi`, `gargādi` — rather than
-- by enumerating their members in the rule.  The lists themselves are a
-- separate text, the *Gaṇapāṭha*, transmitted alongside the sūtras with
-- the *Dhātupāṭha*.  The reason is stated in the tradition's own currency:
-- अर्धमात्रालाघवेन पुत्रोत्सवं मन्यन्ते वैयाकरणाः — a grammarian counts the saving of
-- half a mora as the birth of a son.  A list cited once and referred to by
-- name is not a filing convenience; it is what stops the members being
-- retyped into every rule that needs them, which is precisely the failure
-- record 0023 measured when three copies of one vocabulary drifted apart
-- in the one field nobody compared.
--
-- NOT CLAIMED: that Pāṇini wrote about vocabularies of function symbols in
-- a term-rewriting engine, that the *Gaṇapāṭha* is uncontested in its
-- transmitted extent (it is not — the boundaries of several gaṇas are
-- disputed and marked ākṛtigaṇa, open-ended, by the commentators), or that
-- this file's list is a gaṇa.  What is taken is the one structural point:
-- the members live in one text and the rules cite it.
--
-- ākāṅkṣā is Mīmāṃsaka in origin — Śabara's *Śābarabhāṣya* on Jaimini's
-- *Mīmāṃsāsūtra*, c. 5th c. CE, argues sentence-unity from mutual
-- expectancy — and is stated with yogyatā and sannidhi as the three
-- conditions of śābdabodha by Viśvanātha Nyāyapañcānana in the
-- *Bhāṣāpariccheda* with the *Siddhāntamuktāvalī*, 17th c.  The schools
-- divide on what unifies a sentence (Prābhākara anvitābhidhāna against
-- Bhāṭṭa abhihitānvaya) and this file takes no side; what it takes is the
-- point both need, that expectancy is declared by the word in advance and
-- that supply not matching it yields no meaning rather than a weaker one.
--
--     runghc -imachine machine/AkanksaRun.hs
--
-- ---------------------------------------------------------------------

module Ganapatha_TheBaseVocabularyIsOneCitedListAndEverySymbolHonoursItsDeclaredAkanksa
  ( Term(..)
  , Sym(symName, symArity, symSem, symDefs)
  , akanksitaSym
  , baseVocabulary
  , x_, y_, zero_, su, bin
  ) where

import Data.List (intercalate)

-- ---------------------------------------------------------------- terms

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b])
    | f `elem` ["+","*","^","gcd","max"] = "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ intercalate "," (map show as) ++ ")"

-- --------------------------------------------------------- the language
--
-- A symbol carries its arity and its meaning as a computation.  The
-- machine's vocabulary is data: it starts small and widens when the
-- machine exhausts what it can see.

-- A symbol is three things at once, and the machine needs all three:
-- how it computes (for killing conjectures), what it MEANS (its
-- defining equations, which are what makes proof possible at all), and
-- its arity.  A symbol without defining equations is a black box the
-- machine can test but never reason about — the first version of this
-- file had exactly that bug and proved nothing but coincidences.
--
-- It is a fourth thing as well, and that is what record 0023 found: the
-- defining equations are the field the proof kernel may use, so two
-- symbols agreeing on name, arity and every tested value are still not the
-- same symbol if they hand the kernel different equations.
data Sym = Sym { symName :: String
               , symArity :: Int
               , symSem :: [Integer] -> Integer
               , symDefs :: [(Term,Term)] }

-- | The only way to build a `Sym`.  The constructor is not exported, so
--   this function is where the declared expectancy enters the evaluator
--   and the reason the two fields cannot afterwards part.
--
--   The message names the symbol, what it declared, and what arrived —
--   all three, because a refusal that does not say what it refused is a
--   truncation of the same kind as the answer it replaces.
akanksitaSym :: String -> Int -> ([Integer] -> Integer) -> [(Term,Term)] -> Sym
akanksitaSym nm ar sem defs = Sym nm ar checked defs
  where
    checked vs
      | length vs == ar = sem vs
      | otherwise =
          error ("Ganapatha: symbol " ++ show nm ++ " declares ākāṅkṣā "
                 ++ show ar ++ " and received " ++ show (length vs)
                 ++ " arguments; argument lists of different lengths are "
                 ++ "not identified here")

x_, y_ :: Term
x_ = V 0
y_ = V 1

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

-- THE GIVEN VOCABULARY, and the seam where a wider one is dispatched.
--
-- `baseVocabulary` is the list this engine ran on before 2026-08-16, in the
-- order it ran on.  ORDER IS THE PRECEDENCE (MathMachine's `precedence` reads
-- an index into `vocabulary`), so anything appended must be appended at the
-- END or the reduction order on every existing term changes and every normal
-- form in machine/library.terms becomes a different object.
--
-- `vocabulary = baseVocabulary ++ arithVocabulary` therefore leaves the
-- precedence of 0,s,+,*,max,-,gcd,le exactly where it was (indices 0..7) and
-- gives mod,lcm,v2 indices 8,9,10.  What keeps the DEFAULT behaviour identical
-- is not the order but `dVocabCap`: the machine may only ever look at
-- `take dVocabCap vocabulary`, and its default is `baseVocabCap = 8`.
baseVocabulary :: [Sym]
baseVocabulary =
  [ akanksitaSym "0"   0 (const 0)      []
  , akanksitaSym "s"   1 (\vs -> case vs of
                           [v] -> v + 1
                           _   -> error "successor received wrong arity") []
  , akanksitaSym "+"   2 (\vs -> vs !! 0 + vs !! 1)
      [ (bin "+" x_ zero_,      x_)
      , (bin "+" x_ (su y_),    su (bin "+" x_ y_)) ]
  , akanksitaSym "*"   2 (\vs -> vs !! 0 * vs !! 1)
      [ (bin "*" x_ zero_,      zero_)
      , (bin "*" x_ (su y_),    bin "+" (bin "*" x_ y_) x_) ]
  , akanksitaSym "max" 2 (\vs -> max (vs !! 0) (vs !! 1))
      [ (bin "max" x_ zero_,          x_)
      , (bin "max" zero_ x_,          x_)
      , (bin "max" (su x_) (su y_),   su (bin "max" x_ y_)) ]
  , akanksitaSym "-"   2 (\vs -> max 0 (vs !! 0 - vs !! 1))
      [ (bin "-" x_ zero_,          x_)
      , (bin "-" zero_ x_,          zero_)
      , (bin "-" (su x_) (su y_),   bin "-" x_ y_) ]
  , akanksitaSym "gcd" 2 (\vs -> gcd (vs !! 0) (vs !! 1))
      -- These are the only unconditional gcd equations currently admitted
      -- to the proof kernel.  The former recursive clause
      --
      --   gcd (s x) (s y) = gcd ((s x) - (s y)) (s y)
      --
      -- was false when x < y: at x=1,y=2 it asserted gcd 2 3 = gcd 0 3,
      -- hence 1 = 3.  A correct Euclidean step needs a comparison/guard or
      -- remainder operation.  Until the term language can express one, gcd
      -- remains computationally visible to conjecture generation but only
      -- its sound base cases are available to proof search.  The Agda module
      -- NaturalMachine.HaskellDefinitionBoundary checks this exact boundary.
      [ (bin "gcd" x_ zero_, x_)
      , (bin "gcd" zero_ x_, x_) ]
  , akanksitaSym "le"  2 (\vs -> if vs !! 0 <= vs !! 1 then 1 else 0)
      -- Eleven of the machine's thirty-five theorems were `max`-shaped
      -- restatements of x <= y.  It was not producing junk; it was
      -- reaching for a predicate it had no name for.  (x+y) = ((x+y)max x)
      -- IS x <= x+y wearing a costume.
      [ (bin "le" zero_ x_,          su zero_)
      , (bin "le" (su x_) zero_,     zero_)
      , (bin "le" (su x_) (su y_),   bin "le" x_ y_) ]
  ]
