-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- Nirnaya — निर्णयः, the verdict type for the machine, with nowhere in it for
-- a bare label to sit.
--
-- हिंसा सङ्क्षेपः — harm is collapse.  अनेकान्तवाद and अहिंसा are not two
-- ideas.  A bare verdict is a truncation: `∥ A ∥₁` keeps THAT `A` is
-- inhabited and destroys WHICH inhabitant and every path between
-- inhabitants, and there is no section, so the loss is not repairable
-- downstream.  In one line, and this is the whole argument:
--
--     अविशेषः : (f : ∥ A ∥₁ → B) (x y : A) → f ∣ x ∣₁ ≡ f ∣ y ∣₁
--     अविशेषः f x y = cong f (squash₁ ∣ x ∣₁ ∣ y ∣₁)
--
-- Every map out of a truncation is blind to which inhabitant, by squash₁,
-- by cong, immediately.  Checked, with the no-section theorem and the
-- reporting-layer corollary, in
-- `formal/cubical/Nirnaya_TheVerdictCannotDropItsWitness.agda`
-- (Agda 2.8.0, cubical v0.9, --cubical --safe, no postulates, no holes).
--
-- WHAT THIS ADDS TO `Obstruction.Verdict`, AND WHY IT IS A SEPARATE TYPE.
--
-- `Obstruction.Verdict` was repaired on 2026-08-18 from four bare
-- constructors to `Aviruddha`/`Khandita`/`Nirdharmin`/`Tusnim` carrying
-- witnesses (ANEKANTA.md §19).  The repair held in the type and the defect
-- reappeared ONE LAYER UP within the hour, twice:
--
--   * the derived `Show` printed all 84 assignments on one line, which is
--     the pressure that makes the next author delete the field while
--     believing they are cleaning up;
--   * the cross-tabulation rebuilt the constructors with empty payloads in
--     order to group by them, and printed `Aviruddha over NOTHING` and
--     `Khandita at []` — a display asserting something FALSE about evidence
--     in order to hide that the evidence had been thrown away.  A verdict
--     claiming a witness it does not have is worse than a bare label; the
--     bare label at least did not lie.
--
-- Both were fixed by hand, and both were fixable by hand precisely because
-- nothing in the type stopped them.  `Verdict`'s constructors are exported,
-- so `Aviruddha []` is a legal expression anywhere in the codebase.  This
-- module removes that:
--
--   1. `Nirnaya` IS ABSTRACT.  No constructor is exported.  The only ways
--      in are the five smart constructors, and each VERIFIES its witness
--      against `Obstruction.evalT` — the same evaluator the machine judges
--      with, imported rather than re-typed, so a refutation cannot be true
--      under one copy of the semantics and false under another.
--        * `khandita` recomputes the separation and refuses an assignment
--          that does not actually kill the claim;
--        * `aviruddha` refuses an EMPTY domain and refuses a dirty one,
--          naming the point that separated;
--        * `siddha` refuses a derivation whose kernel line does not name
--          the claim it is offered for;
--        * `nirdharmin` and `tushnim` read their witnesses off the claim
--          rather than taking them on trust.
--      So `Aviruddha over NOTHING` is not a value that gets rejected at
--      review.  It is a value that cannot be written.
--
--   2. `Koti` IS ABSTRACT.  Grouping a tally by kind is legitimate and
--      necessary — that is what `VerdictKind` got right.  What was still
--      available was manufacturing a kind out of nothing.  `Koti`'s
--      constructors are not exported, so the ONLY way to hold one is
--      `bhanga`, applied to a verdict that exists.  A label in this
--      codebase is now always the shadow of a witness someone had.
--
--   3. A TALLY ROW CARRIES A VERDICT.  `Ganana` is `(Koti, Int, Nirnaya)`
--      with the constructor unexported and `ganana` the only builder, and
--      `ganana` builds a row only from a non-empty group — so the exemplar
--      is a real member, not a reconstruction.  This is the layer that
--      failed last time.  It cannot fail the same way: a row without a
--      verdict in it does not typecheck.
--
--   4. DISAGREEMENT RETURNS अवक्तव्यम्, NOT AN ERROR AND NOT AN AVERAGE.
--      `Avaktavyam` keeps BOTH standpoints whole plus the proof-carrying
--      reason they differ, and carries the शेष as a गर्भ: either the ground
--      instance at the point where they part — a claim the machine can go
--      and judge next — or, when the vocabulary is what is missing, the
--      symbol that must be admitted before a next claim exists.  It never
--      carries "no next claim" silently.
--
-- THE POSITIONS, and where each comes from:
--
--   सिद्धः      accepted        — carries its derivation
--   खण्डितः     refuted         — carries the assignment, re-verified
--   अविरुद्धः    unrefuted       — carries THE DOMAIN SEARCHED.  योग्यानुपलब्धि:
--                              "I found nothing" is inadmissible; "I
--                              searched this domain, in which it would have
--                              appeared, and it did not" is admissible, and
--                              that difference is the whole of what makes an
--                              absence claim a means of knowing rather than
--                              an excuse.  (Kumārila, श्लोकवार्त्तिकम्,
--                              अभावपरिच्छेदः — the yogya condition on अनुपलब्धि.)
--   निर्धर्मी    subjectless     — carries WHICH two variables failed to unify.
--                              सप्तभङ्गी predicates a धर्म of a धर्मिन्; `x = y`
--                              with two distinct free variables has no
--                              धर्मिन्, so it is not a भङ्ग and is not forced
--                              into one.
--   तूष्णीम्     silent          — carries the symbol outside this naya's
--                              vocabulary.  Silence and affirmation are not
--                              the same constructor.
--   अवक्तव्यम्   standpoints differ — carries the शेष, which is a गर्भ.
--
-- WHAT IS CLAIMED OF THE SOURCES.  अनेकान्तवाद, नयवाद, सप्तभङ्गी: Umāsvāti,
-- तत्त्वार्थसूत्रम्; Siddhasena Divākara, सन्मतितर्कः; Samantabhadra; Akalaṅka.
-- योग्यानुपलब्धि is the Mīmāṃsaka condition on अनुपलब्धि as a pramāṇa, and the
-- Naiyāyika treatment of absence (अभाव with its प्रतियोगिन्) is a RIVAL
-- account, not a second tool in the same box — Jaina logicians reject the
-- Naiyāyika treatment of negation and Naiyāyikas reject anekāntavāda.  This
-- module takes the Jaina sevenfold as its frame and the Mīmāṃsaka fitness
-- condition for the one position (अविरुद्धः) that is an absence claim; a
-- Naiyāyika would say that absence needs a प्रतियोगिन् and a locus rather than
-- an extent of search, and a Jaina would say the Naiyāyika has smuggled a
-- one-sided negation in as a category.  The disagreement is recorded here
-- rather than dissolved.  Naming a constructor for a term claims nothing
-- about what its author proved.
--
-- NOT `module Main`, so it is importable from the day it lands.

module Nirnaya_NoVerdictWithoutItsWitness
  ( -- * the claim under judgement
    Vada(..)
  , vadaText
    -- * the verdict.  ABSTRACT: there are no constructors here on purpose.
  , Nirnaya
  , Nirmanadosha(..)
    -- ** the only ways in, each verifying its own witness
  , siddha
  , khandita
  , aviruddha
  , nirdharmin
  , tushnim
  , nirnaya
    -- ** the only way out: every branch is handed the evidence
  , foldNirnaya
    -- * the witnesses
  , Vyutpatti(..)
  , Vishaya
  , vishayaBindavah
  , vishayaYogyata
  , Yogyata(..)
    -- * अवक्तव्यम् — what disagreeing standpoints return
  , Avaktavyam
  , purvah
  , aparah
  , garbhah
  , avaktavyam
  , Garbha(..)
  , Uttaram(..)
  , uttaram
    -- * the label.  ABSTRACT: the only way to hold one is to project it.
  , Koti
  , bhanga
    -- * the reporting layer, which is where this failed last time
  , Ganana
  , gKoti
  , gSankhya
  , gUdaharanam
  , ganana
  , prativedanam
  , selfTest
  ) where

import Data.List (isInfixOf, nub, sortOn)
import Obstruction (Term(..), evalT, envs, symbolsIn, knownSymbols, showClaim)

-- ------------------------------------------------------------------ वादः

-- The claim under judgement: two sides in the machine's own vocabulary.
data Vada = Vada { vama :: Term, dakshina :: Term }
  deriving (Eq, Ord)

vadaText :: Vada -> String
vadaText c = showClaim (vama c, dakshina c)

instance Show Vada where show = vadaText

-- ------------------------------------------------------------- witnesses

-- व्युत्पत्तिः — an acceptance's derivation.  Not a Bool and not the word
-- "accepted": the tactic that closed it and the kernel line that says so.
data Vyutpatti = Vyutpatti
  { vyTactic     :: String
  , vyKernelLine :: String
  , vyAgdaCalls  :: Int
  } deriving (Eq, Ord, Show)

-- योग्यता — the fitness of a domain: what makes it a domain a counterexample
-- WOULD have appeared in, rather than merely a set of points someone had.
-- Without this an अविरुद्धः says "I looked and did not see", which is exactly
-- the anupalabdhi that is not a pramāṇa.
data Yogyata = Yogyata
  { yogyaShabdah  :: [String]           -- vocabulary the sweep is fit for
  , yogyaVyaptih  :: (Integer, Integer) -- the coordinate range swept
  , yogyaPramanam :: String             -- how the fitness was established
  } deriving (Eq, Ord, Show)

-- विषयः — the domain searched.  NON-EMPTY BY CONSTRUCTION: a first point and
-- a tail, not a list with a side condition someone can forget to check.
data Vishaya = Vishaya
  { viPrathamah :: [Integer]
  , viShesha    :: [[Integer]]
  , viYogyata   :: Yogyata
  } deriving (Eq, Ord)

vishayaBindavah :: Vishaya -> [[Integer]]
vishayaBindavah d = viPrathamah d : viShesha d

vishayaYogyata :: Vishaya -> Yogyata
vishayaYogyata = viYogyata

-- The extent is what a reader is judging ("unrefuted over WHAT?"), and it is
-- printed with its first point so it is not an unfalsifiable number.  There
-- is no `Vishaya` with an empty extent, so there is no string to print for
-- one, so `over NOTHING` is not reachable from here.
instance Show Vishaya where
  show d = show (length (vishayaBindavah d)) ++ " assignments from "
           ++ show (viPrathamah d)
           ++ ", fit for " ++ show (yogyaShabdah (viYogyata d))
           ++ " over " ++ show (yogyaVyaptih (viYogyata d))

-- ------------------------------------------------------------- निर्णयः

-- ABSTRACT.  Constructors deliberately not exported; see (1) in the header.
data Nirnaya
  = Siddhah    Vada Vyutpatti
  | Khanditah  Vada [Integer] (Integer, Integer)  -- assignment, and the two
                                                  -- values that differ AT it
  | Aviruddhah Vada Vishaya
  | Nirdharmi  Vada Int Int                       -- which two variables
  | Tushnim    Vada String                        -- which symbol
  deriving (Eq, Ord)

instance Show Nirnaya where
  show (Siddhah c d)      = "siddhah "    ++ vadaText c ++ " by " ++ vyTactic d
                            ++ " (" ++ show (vyAgdaCalls d) ++ " agda calls)"
  show (Khanditah c e (a,b)) = "khanditah " ++ vadaText c ++ " at " ++ show e
                            ++ ": " ++ show a ++ " /= " ++ show b
  show (Aviruddhah c d)   = "aviruddhah " ++ vadaText c ++ " over " ++ show d
  show (Nirdharmi c i j)  = "nirdharmi "  ++ vadaText c ++ ": variables "
                            ++ show (i, j) ++ " do not unify"
  show (Tushnim c s)      = "tushnim "    ++ vadaText c ++ " on " ++ show s

-- Why a construction was refused.  Every constructor names the thing that
-- refused it, because a rejection is a verdict too and the same rule applies.
data Nirmanadosha
  = AsiddhaBhedah Vada [Integer] Integer
      -- offered as a refutation, but the two sides AGREE at that assignment
  | ShunyoVishayah Vada
      -- offered as unrefuted over nothing.  यत्र न विषयः, तत्र न ज्ञानम् ।
  | AshuddhoVishayah Vada [Integer]
      -- offered as unrefuted over a domain that CONTAINS a refutation, named
  | AdharmiNasti Vada
      -- offered as subjectless, but the claim has a subject
  | ShabdoJnatah Vada
      -- offered as silent, but every symbol is in the vocabulary
  | AsammatamNasti Vada Koti
      -- offered as अवक्तव्यम्, but the two standpoints AGREE: no शेष, no गर्भ
  | VyutpattirAsangata Vada String
      -- offered as accepted, but the kernel line does not name this claim
  deriving (Eq, Show)

-- खण्डितः — refuted.  The assignment is RE-EVALUATED here; an assignment at
-- which the sides agree is not a refutation and does not become one by being
-- passed to this function.
khandita :: Vada -> [Integer] -> Either Nirmanadosha Nirnaya
khandita c e
  | a /= b    = Right (Khanditah c e (a, b))
  | otherwise = Left (AsiddhaBhedah c e a)
  where a = evalT e (vama c)
        b = evalT e (dakshina c)

-- अविरुद्धः — unrefuted OVER A STATED DOMAIN.  Two refusals, and the second
-- is the one that matters: a domain containing a counterexample is not a
-- clean search, and the caller is handed the point so it can return the
-- खण्डितः it actually has.
aviruddha :: Vada -> Yogyata -> [[Integer]] -> Either Nirmanadosha Nirnaya
aviruddha c _ []       = Left (ShunyoVishayah c)
aviruddha c y (e0:es)  =
  case [ e | e <- e0:es, evalT e (vama c) /= evalT e (dakshina c) ] of
    (bad:_) -> Left (AshuddhoVishayah c bad)
    []      -> Right (Aviruddhah c (Vishaya e0 es y))

-- सिद्धः — accepted, carrying the derivation.  The kernel line must name the
-- claim; a derivation offered for some other claim is not this claim's.
siddha :: Vada -> Vyutpatti -> Either Nirmanadosha Nirnaya
siddha c d
  | vadaText c `isInfixOf` vyKernelLine d = Right (Siddhah c d)
  | otherwise = Left (VyutpattirAsangata c (vyKernelLine d))

-- निर्धर्मी — no धर्मिन् to predicate of.  Read off the claim, not taken on
-- trust: two DISTINCT bare variables and nothing else.
nirdharmin :: Vada -> Either Nirmanadosha Nirnaya
nirdharmin c = case (vama c, dakshina c) of
  (V i, V j) | i /= j -> Right (Nirdharmi c i j)
  _                   -> Left (AdharmiNasti c)

-- तूष्णीम् — this naya declines to speak, naming the symbol that silenced it.
tushnim :: Vada -> Either Nirmanadosha Nirnaya
tushnim c = case [ f | f <- symbolsIn (vama c) ++ symbolsIn (dakshina c)
                     , f `notElem` knownSymbols ] of
  (f:_) -> Right (Tushnim c f)
  []    -> Left (ShabdoJnatah c)

-- The decision procedure, in the order the machine actually asks.  Every
-- verdict it returns carries its witness, because these are the same five
-- functions above and there is no other way in.
--
-- IT RETURNS `Either`, and that is the point rather than an inconvenience.
-- The first draft of this function was total, and it bought the totality
-- with `Tushnim c "?"` in the branch that cannot arise -- a verdict naming a
-- symbol `?` that occurs in no claim.  That is `Aviruddha over NOTHING`
-- again, in the constructor this time instead of in the display, written by
-- the same hand in the same hour as the module that forbids it.  अनेकान्त
-- लौटकर आया, उसी दिन, उसी फ़ाइल में — exactly as ANEKANTA.md §19 records, and
-- the lesson is that a fabricated witness is what totality costs when the
-- honest answer is that there is no verdict.  A claim judged over an EMPTY
-- domain does not have one: it has a `ShunyoVishayah`, which says so.
nirnaya :: Yogyata -> [[Integer]] -> Vada -> Either Nirmanadosha Nirnaya
nirnaya y dom c =
  case nirdharmin c of
    Right v -> Right v
    Left _  -> case tushnim c of
      Right v -> Right v
      Left _  -> case [ e | e <- dom, evalT e (vama c) /= evalT e (dakshina c) ] of
        (e:_) -> khandita c e
        []    -> aviruddha c y dom

-- THE ONLY ELIMINATOR.  Every branch is HANDED the witness.  A consumer
-- cannot dispatch on the verdict without receiving the evidence for it, so
-- the shape that produced `Aviruddha over NOTHING` — reach for the kind,
-- rebuild a payload to satisfy the type — has no way to arise: the payload
-- is already in hand.
foldNirnaya
  :: (Vada -> Vyutpatti -> b)
  -> (Vada -> [Integer] -> (Integer, Integer) -> b)
  -> (Vada -> Vishaya -> b)
  -> (Vada -> Int -> Int -> b)
  -> (Vada -> String -> b)
  -> Nirnaya -> b
foldNirnaya f _ _ _ _ (Siddhah c d)         = f c d
foldNirnaya _ f _ _ _ (Khanditah c e vs)    = f c e vs
foldNirnaya _ _ f _ _ (Aviruddhah c d)      = f c d
foldNirnaya _ _ _ f _ (Nirdharmi c i j)     = f c i j
foldNirnaya _ _ _ _ f (Tushnim c s)         = f c s

-- ------------------------------------------------------------ अवक्तव्यम्

-- गर्भः — the शेष is not a failure, it is what the next naya is born from.
-- Either a claim the machine can go and judge (the ground instance at the
-- point where the standpoints part) or, when the vocabulary is what is
-- missing, the symbol that must be admitted first.  There is no "nothing
-- next" constructor: a गर्भ that carried nothing would be the bare label
-- again, wearing the name of a birth.
data Garbha
  = GarbhaVadah Vada     -- the next claim, ground at the disagreement
  | GarbhaShabdah String -- the vocabulary must admit this symbol first
  deriving (Eq, Show)

-- ABSTRACT.  Both standpoints kept whole; no averaging, no error code.
data Avaktavyam = Avaktavyam
  { purvah  :: Nirnaya
  , aparah  :: Nirnaya
  , garbhah :: Garbha
  } deriving (Eq)

instance Show Avaktavyam where
  show a = "avaktavyam {" ++ show (purvah a) ++ "} vs {" ++ show (aparah a)
           ++ "} garbha " ++ show (garbhah a)

-- Two standpoints that AGREE do not produce अवक्तव्यम्, and saying they do
-- would be the mirror image of collapsing: a fourth position asserted where
-- there is no शेष to carry.  The refusal names the kind they agreed on.
avaktavyam :: Nirnaya -> Nirnaya -> Either Nirmanadosha Avaktavyam
avaktavyam p q
  | bhanga p == bhanga q = Left (AsammatamNasti (vadaOf p) (bhanga p))
  | otherwise            = Right (Avaktavyam p q (garbhaOf p q))

vadaOf :: Nirnaya -> Vada
vadaOf = foldNirnaya (\c _ -> c) (\c _ _ -> c) (\c _ -> c) (\c _ _ -> c) (\c _ -> c)

-- The गर्भ is DERIVED from the disagreement rather than supplied, so it
-- cannot be a placeholder.  A refutation's assignment is the sharpest seed
-- available: instantiate the claim there and the next naya has a ground
-- statement to judge.  Failing that, an unrefuted domain's first point.
-- Failing both, the silence names what must be admitted.
garbhaOf :: Nirnaya -> Nirnaya -> Garbha
garbhaOf p q = case [ e | Just e <- map bindu [p, q] ] of
    (e:_) -> GarbhaVadah (Vada (nihita e (vama c)) (nihita e (dakshina c)))
    []    -> case [ s | Just s <- map shabda [p, q] ] of
      (s:_) -> GarbhaShabdah s
      []    -> GarbhaVadah c
  where
    c = vadaOf p
    bindu = foldNirnaya (\_ _ -> Nothing) (\_ e _ -> Just e)
                        (\_ d -> Just (viPrathamah d)) (\_ _ _ -> Nothing)
                        (\_ _ -> Nothing)
    shabda = foldNirnaya (\_ _ -> Nothing) (\_ _ _ -> Nothing) (\_ _ -> Nothing)
                         (\_ _ _ -> Nothing) (\_ s -> Just s)

-- substitute an assignment into a term: the ground instance
nihita :: [Integer] -> Term -> Term
nihita env t@(V i)  = if i < length env then numeral (env !! i) else t
nihita env (F f ts) = F f (map (nihita env) ts)

numeral :: Integer -> Term
numeral n | n <= 0    = F "0" []
          | otherwise = F "s" [numeral (n - 1)]

-- What the machine returns.  Disagreement is not an error branch.
data Uttaram = Nishchayah Nirnaya | Avaktavyah Avaktavyam
  deriving (Eq, Show)

-- Combine two standpoints' verdicts on one claim: agreement returns the
-- verdict, disagreement returns अवक्तव्यम् with the शेष.  द्वौ मार्गौ, तृतीयो न ।
uttaram :: Nirnaya -> Nirnaya -> Uttaram
uttaram p q = either (const (Nishchayah p)) Avaktavyah (avaktavyam p q)

-- ------------------------------------------------------------------ कोटिः

-- ABSTRACT.  Constructors not exported: `bhanga` is the only way to hold a
-- `Koti`, so a label in this codebase is always the shadow of a witness
-- somebody actually had.  There is no field here to fake, and no way to get
-- here without a verdict.  Checked counterpart: `भङ्ग-न-प्रत्यानयनम्` — this
-- map has no section, so a report that keeps the label has NOT kept the
-- verdict and cannot get it back.
data Koti = KSiddhah | KKhanditah | KAviruddhah | KNirdharmi | KTushnim
  deriving (Eq, Ord)

instance Show Koti where
  show KSiddhah    = "siddhah"
  show KKhanditah  = "khanditah"
  show KAviruddhah = "aviruddhah"
  show KNirdharmi  = "nirdharmi"
  show KTushnim    = "tushnim"

bhanga :: Nirnaya -> Koti
bhanga = foldNirnaya (\_ _ -> KSiddhah) (\_ _ _ -> KKhanditah)
                     (\_ _ -> KAviruddhah) (\_ _ _ -> KNirdharmi)
                     (\_ _ -> KTushnim)

-- ------------------------------------------------------- the report layer

-- गणना — a tally row.  THIS IS THE LAYER THAT FAILED LAST TIME, so it is
-- built so it cannot: the row carries a real member of its own group.
-- `Ganana`'s constructor is not exported and `ganana` is the only builder,
-- and `ganana` builds a row only out of a non-empty group — so the exemplar
-- is a verdict somebody produced, never a reconstruction.  A row asserting
-- a kind it has no instance of does not typecheck.
data Ganana = Ganana
  { gKoti       :: Koti
  , gSankhya    :: Int
  , gUdaharanam :: Nirnaya
  }

instance Show Ganana where
  show g = pad 14 (show (gKoti g)) ++ pad 8 (show (gSankhya g))
           ++ "e.g. " ++ show (gUdaharanam g)
    where pad n s = s ++ replicate (max 0 (n - length s)) ' '

ganana :: [Nirnaya] -> [Ganana]
ganana vs = concat
  [ case [ v | v <- vs, bhanga v == k ] of
      -- unreachable: `k` came out of `vs`, so the group is non-empty.  The
      -- branch is written anyway, and it emits NO ROW.  That is the whole
      -- discipline in one case arm: the two available answers to "a kind
      -- with no instance" are silence and a manufactured exemplar, and the
      -- second is what printed `Aviruddha over NOTHING`.  An irrefutable
      -- pattern here would have been the third answer -- crash -- which is
      -- a report that dies rather than one that lies, but still not a report.
      []      -> []
      (x:grp) -> [Ganana k (length (x : grp)) x]
  | k <- nub (sortOn show (map bhanga vs)) ]

prativedanam :: [Nirnaya] -> String
prativedanam vs = unlines $
  [ "nirnaya tally over " ++ show (length vs) ++ " verdicts"
  , "  (every row carries a member of its own group; a kind with no"
  , "   instance has no row, because it has nothing to show)"
  , "" ] ++ map (("  " ++) . show) (ganana vs)

-- ---------------------------------------------------------------- selftest

selfTest :: IO Bool
selfTest = do
    mapM_ report checks
    putStrLn (prativedanam sample)
    pure (all snd checks)
  where
    report (n, ok) = putStrLn ((if ok then "  ok   " else "  FAIL ") ++ n)

    -- x = 0 : false, killed wherever x /= 0
    mithya     = Vada (V 0) (F "0" [])
    -- x = x + 0 : true over the whole sweep
    satya      = Vada (V 0) (F "+" [V 0, F "0" []])
    -- x = y : two distinct free variables, no dharmin
    adharmi    = Vada (V 0) (V 1)
    -- x = phi(x) : phi is outside this naya's vocabulary
    parabhasha = Vada (V 0) (F "phi" [V 0])

    -- the fitness statement, stated rather than assumed: what the sweep is
    -- fit for, and how that fitness was established.  The revalidation
    -- figure is `Obstruction.envs`'s own, quoted with its source.
    yog = Yogyata knownSymbols (0, 6)
            ("envs 6 (84 assignments); revalidated in Obstruction.hs against "
             ++ "an exhaustive 0..12 sweep in three variables (13^3 = 2197) "
             ++ "with zero disagreements on the 78 residuals tested")
    dom = envs 6

    -- two assignments that both kill `mithya`, taken from opposite ends of
    -- the sweep so they are genuinely different
    killers = [ e | e <- dom, evalT e (V 0) /= 0 ]
    agreers = [ e | e <- dom, evalT e (V 0) == evalT e (F "+" [V 0, F "0" []]) ]

    -- everything below is matched, never `head`ed: a test that throws on an
    -- empty list is a test that reports a verdict it does not have.
    k1s = take 1 killers
    k2s = take 1 (reverse killers)
    a1s = take 1 agreers

    judged c = [ v | Right v <- [nirnaya yog dom c] ]
    sample   = concatMap judged [mithya, satya, adharmi, parabhasha]
               ++ [ v | e <- k1s ++ k2s, Right v <- [khandita mithya e] ]

    checks =
      [ ("khandita accepts an assignment that actually separates",
          case [ v | e <- k1s, Right v <- [khandita mithya e] ] of
            (_:_) -> True ; _ -> False)
      , ("khandita REFUSES an assignment where the sides agree",
          case [ d | e <- a1s, Left d <- [khandita satya e] ] of
            (AsiddhaBhedah _ _ _ : _) -> True ; _ -> False)
      , ("aviruddha REFUSES an empty domain -- `over NOTHING` is unwritable",
          case aviruddha satya yog [] of
            Left (ShunyoVishayah _) -> True ; _ -> False)
      , ("aviruddha REFUSES a domain containing a refutation, and names it",
          case aviruddha mithya yog dom of
            Left (AshuddhoVishayah _ e) -> evalT e (V 0) /= 0 ; _ -> False)
      , ("aviruddha accepts a clean non-empty domain and keeps its extent",
          case aviruddha satya yog dom of
            Right v -> foldNirnaya (\_ _ -> False) (\_ _ _ -> False)
                         (\_ d -> length (vishayaBindavah d) == length dom)
                         (\_ _ _ -> False) (\_ _ -> False) v
            _ -> False)
      , ("siddha REFUSES a derivation whose kernel line names another claim",
          case siddha satya (Vyutpatti "refl" "KERNEL-ACCEPT x = (0+x)" 3) of
            Left (VyutpattirAsangata _ _) -> True ; _ -> False)
      , ("siddha accepts a derivation whose kernel line names THIS claim",
          case siddha satya (Vyutpatti "refl"
                 ("KERNEL-ACCEPT " ++ vadaText satya ++ "  (refl, 3 agda calls)") 3) of
            Right _ -> True ; _ -> False)
      , ("nirdharmin REFUSES a claim that has a subject",
          case nirdharmin satya of Left (AdharmiNasti _) -> True ; _ -> False)
      , ("nirdharmin names WHICH two variables failed to unify",
          case nirdharmin adharmi of
            Right v -> foldNirnaya (\_ _ -> False) (\_ _ _ -> False) (\_ _ -> False)
                         (\_ i j -> (i, j) == (0, 1)) (\_ _ -> False) v
            _ -> False)
      , ("tushnim REFUSES a claim whose symbols are all known",
          case tushnim satya of Left (ShabdoJnatah _) -> True ; _ -> False)
      , ("tushnim names the symbol that silenced it",
          case tushnim parabhasha of
            Right v -> foldNirnaya (\_ _ -> False) (\_ _ _ -> False) (\_ _ -> False)
                         (\_ _ _ -> False) (\_ s -> s == "phi") v
            _ -> False)
      , ("nirnaya gives every claim a verdict, each carrying its witness",
          length sample == 6 && all hasWitness sample)
      , ("nirnaya over an EMPTY domain returns no verdict, not a fake one",
          case nirnaya yog [] satya of
            Left (ShunyoVishayah _) -> True ; _ -> False)
      , ("avaktavyam REFUSES two standpoints that agree -- no shesha, no garbha",
          case [ () | p <- judged satya
                    , Left (AsammatamNasti _ _) <- [avaktavyam p p] ] of
            (_:_) -> True ; _ -> False)
      , ("avaktavyam keeps BOTH standpoints whole",
          case [ (a, p, q) | p <- judged satya, q <- judged mithya
                           , Right a <- [avaktavyam p q] ] of
            ((a, p, q):_) -> purvah a == p && aparah a == q
            _ -> False)
      , ("the shesha is a garbha: a next claim, ground at the disagreement",
          case [ garbhah a | p <- judged satya, q <- judged mithya
                           , Right a <- [avaktavyam p q] ] of
            (GarbhaVadah c : _) ->
              null (freeVars (vama c) ++ freeVars (dakshina c))
            _ -> False)
      , ("uttaram returns avaktavyam, not an error and not an average",
          case [ u | p <- judged satya, q <- judged mithya
                   , let u = uttaram p q ] of
            (Avaktavyah _ : _) -> True ; _ -> False)
        -- The reporting theorem on live values.  Two refutations at different
        -- assignments carry the SAME koti, so a report keyed on the label
        -- cannot tell them apart: `भङ्ग-न-प्रत्यानयनम्` in the Agda.  Which is
        -- why the tally keeps a verdict rather than a label.
      , ("two distinct refutations share one koti (the label is a truncation)",
          case [ (u, v) | e <- k1s, f <- k2s, e /= f
                        , Right u <- [khandita mithya e]
                        , Right v <- [khandita mithya f] ] of
            ((u, v):_) -> bhanga u == bhanga v && u /= v
            _ -> False)
      , ("every tally row carries a real member of its own group",
          all rowHonest (ganana sample))
      , ("the tally emits no row for a kind with no instance",
          length (ganana sample) == length (nub (map bhanga sample)))
      ]

    rowHonest g = gKoti g == bhanga (gUdaharanam g)
                  && gSankhya g == length [ v | v <- sample, bhanga v == gKoti g ]
                  && gUdaharanam g `elem` sample

    hasWitness = foldNirnaya
      (\_ d -> not (null (vyTactic d)))
      (\_ e (a, b) -> not (null e) && a /= b)
      (\_ d -> not (null (vishayaBindavah d)))
      (\_ i j -> i /= j)
      (\_ s -> not (null s))

    freeVars (V i)    = [i]
    freeVars (F _ ts) = concatMap freeVars ts
