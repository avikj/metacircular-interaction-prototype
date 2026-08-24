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

-- Residual.hs — the machine's residual organ: what it cannot know, and the
-- exact menu of what would unlock it.
--
-- WHAT THIS IS FOR
--
-- `notes/THE_MACHINE.md` states the loop as CLOSE / CERTIFY / PORT / GROW,
-- and says of CERTIFY:
--
--     prove the wall: grammar induction ... + exact residual check
--     → emit: remainder torsor, its group, its quotient menu
--
-- and of PORT:
--
--     receive one quotient step of the remainder — a declared section,
--     never a derivation.
--
-- Every word of that is already a checked theorem in the charge world.
-- `formal/cubical/NaturalMachine/GaugeOrbitClasses.agda` §5 proves
--
--     obs σ qs ≡ obs σ' qs   ⟺   σ' ⋆ σ  ∈  qs^⊥            (classes-⇐/⇒)
--
-- i.e. THE FIBRES OF THE TRANSCRIPT MAP ARE THE COSETS OF THE ANNIHILATOR
-- SUBGROUP qs^⊥, which §3 proves is a subgroup (ann-unit, ann-mul,
-- ann-self-inverse).  That subgroup IS the remainder: the set of gauge
-- elements that no query in the set can split.  It had never been wired
-- into a running loop.  This module wires it.
--
-- WHAT IT COMPUTES (all of it exact; see PROTOCOL below)
--
--   residual  :: [Query] -> Subgroup      the annihilator qs^⊥: order and
--                                         generators, by exact F2 kernel
--   portMenu  :: Subgroup -> [Quotient]   the menu of index-2 quotients of
--                                         the residual — one port = one
--                                         quotient step, each named by the
--                                         concrete query that grants it
--   grant     :: Subgroup -> Quotient -> Subgroup     the new residual
--
-- and then runs the demonstration: a query set whose residual is provably
-- nontrivial (the machine is blind to 8 of 32 gauge elements), a port
-- granted, the residual recomputed, and the order strictly halving —
-- ignorance decreasing by an exact, computed amount, printed at each step.
--
-- THE DICTIONARY (matched to the Agda; nothing here is invented)
--
--   Agda                                    here
--   ----------------------------------------------------------------
--   Signs      = ℕ → Bool                   Gauge (bitmask over n primes)
--   true = +1, false = −1                   bit CLEAR = +1, bit SET = −1
--   _·_ (true·b = b, false·b = not b)       bmul  (this is XNOR on Bool,
--                                             hence XOR on the bits: G is
--                                             (F2)^n and _·_ is its law)
--   Number     = List ℕ  (Ω = length)       Query = [PrimeIx], with
--                                             multiplicity: [3,3] is 7²
--   val σ []=true; val σ (p∷ns)=σ p · …     valDirect (the same fold)
--   (τ ⋆ σ) p  = τ p · σ p                  star (xor of masks)
--   τ₊ / τ₋ / τ₀                            tauPlus / tauMinus / tau0
--   obs σ qs   = map (val σ) qs             obs
--   AllNeutral τ qs                         allNeutral
--   HasCharge  τ qs                         hasCharge
--   qs^⊥                                    residual
--
-- The bit encoding is a THEOREM, not a convenience, and §CHECK verifies it
-- exhaustively rather than asserting it: Agda's `_·_` on Bool is XNOR, so
-- under (true ↦ 0, false ↦ 1) it is addition in F2; `val τ q` is therefore
-- the F2 pairing ⟨τ, pv q⟩ where pv q is the multiplicity vector of q taken
-- mod 2 — which is exactly why GaugeOrbitClasses §7 (`square-neutral`) is
-- true: a square has pv = 0.  Consequently qs^⊥ is the KERNEL of the matrix
-- whose rows are the pv's, computed here by exact Gaussian elimination over
-- F2 on Integer bitmasks — integer arithmetic only, no floating point,
-- no fitting, nothing measured.
--
-- PROTOCOL (`CLAUDE.md`)
--
-- Every number this program prints is an exact finite computation over F2:
-- a kernel, a subgroup order 2^d, an index, or an exhaustive verification
-- over a finite group.  CLAUDE.md's operative distinction admits exactly
-- this ("exact / certified symbolic computation is proof ... a finite
-- exhaustive verification"); there is no measurement, no correlation, and
-- no fitted constant anywhere in this file.  The orders are derived, and
-- the derivations are stated at the point of use:
--
--   |qs^⊥| = 2^(n − rank {pv q : q ∈ qs})        (rank–nullity over F2)
--   #ports  = 2^d − 1,  d = dim qs^⊥              (nonzero elements of the
--                                                  F2-dual of the residual)
--   each port has index exactly 2                 (kernel of a surjection
--                                                  onto F2)
--
-- §CHECK re-derives each of these by brute-force enumeration of the whole
-- group and fails the run on any disagreement, which is the collision /
-- replication standard: two independent computations of the same object.
--
-- WHY THE MENU DEPENDS ONLY ON THE RESIDUAL
--
-- `portMenu` is given the residual R alone — not the query set that
-- produced it — and that is not an oversight.  In a finite F2 space
-- (R^⊥)^⊥ = R, so the span of the queries is recoverable from R, and two
-- queries grant the same port exactly when they differ by an element of
-- R^⊥ = span(qs).  The menu is therefore an invariant of the machine's
-- ignorance and not of its history: the same wall, however you walked into
-- it, offers the same doors.  (Checked: `doubleAnnihilator`.)
--
-- BUILD
--
--   ghc -O1 -o machine/residual machine/Residual.hs && machine/residual
--
-- Exits nonzero if any cross-check against the Agda fails.

module Main (main) where

import Data.Bits (bit, popCount, setBit, shiftL, testBit, xor, (.&.))
import Data.List (delete, foldl', intercalate, nub, sortOn)
import System.Exit (exitFailure, exitSuccess)

------------------------------------------------------------------------
-- §1  The gauge world, concretely.
--
-- G = (F2)^n under XOR, presented as sign assignments on a finite prime
-- set: true = +1 = bit clear, false = −1 = bit set.  Agda's Signs is
-- ℕ → Bool; a machine with a finite vocabulary sees the first n primes,
-- and everything below is that restriction, which is a subgroup of the
-- full torus of GAUGE.md §F.1 and a quotient of it by the primes it
-- cannot name.
------------------------------------------------------------------------

type PrimeIx = Int

-- Agda: Number = List ℕ, the multiset of prime indices; Ω = length.
-- Multiplicity is significant: [3,3] is 7² and [0,1] is 6.
type Query = [PrimeIx]

-- A gauge element / sign assignment on the first n primes.  Bit p set
-- means σ(p) = false = −1.
newtype Gauge = Gauge Integer deriving (Eq, Ord)

-- Agda ParitySeparator §1:  _·_ : Bool → Bool → Bool
--                           true  · b = b
--                           false · b = not b
bmul :: Bool -> Bool -> Bool
bmul True b = b
bmul False b = not b

-- Agda: sgn : ℕ → Bool, (−1)^n, true at even n.
sgn :: Int -> Bool
sgn k = even k

-- Agda: Ω = length.
omega :: Query -> Int
omega = length

signAt :: Gauge -> PrimeIx -> Bool
signAt (Gauge m) p = not (testBit m p)

-- Agda ParitySeparator §2:  val σ []       = true
--                           val σ (p ∷ ns) = σ p · val σ ns
-- Transcribed literally.  This is the definition of record; `valFast`
-- below is the linear-algebra shortcut, and §CHECK proves they agree.
valDirect :: Gauge -> Query -> Bool
valDirect g = foldr (\p acc -> signAt g p `bmul` acc) True

-- The multiplicity vector of a query, mod 2 — its square class.  This is
-- GaugeOrbitClasses §7 made into a data structure: a query is read only
-- modulo squares, so pv [3,3] = 0 and no gauge element sees it.
parityVec :: Query -> Integer
parityVec = foldl' (\acc p -> acc `xor` bit p) 0

-- val as the F2 pairing.  ⟨τ, pv q⟩ = 0 ⟺ val τ q = +1.
valFast :: Gauge -> Query -> Bool
valFast (Gauge m) q = even (popCount (m .&. parityVec q))

-- Agda GaugeOrbitClasses §1: (τ ⋆ σ) p = τ p · σ p.  XNOR on signs is XOR
-- on bits, so the group law is exclusive-or and every element is its own
-- inverse (`ann-self-inverse`).
star :: Gauge -> Gauge -> Gauge
star (Gauge a) (Gauge b) = Gauge (a `xor` b)

tauPlus :: Gauge                 -- Agda τ₊: the identity, all +1
tauPlus = Gauge 0

tauMinus :: Int -> Gauge         -- Agda τ₋: the total flip, all −1
tauMinus n = Gauge (bit n - 1)

tau0 :: Gauge                    -- Agda τ₀: flip at the single prime p₀
tau0 = Gauge 1

-- Agda: flip σ p = not (σ p); GaugeOrbitClasses `flip-is-τ₋`.
flipG :: Int -> Gauge -> Gauge
flipG n = star (tauMinus n)

-- Agda: obs σ qs = map (val σ) qs.
obs :: Gauge -> [Query] -> [Bool]
obs g qs = map (valDirect g) qs

-- Agda §3: AllNeutral τ qs = every query reads +1 on τ.
allNeutral :: Gauge -> [Query] -> Bool
allNeutral g = all (valDirect g)

-- Agda §3: HasCharge τ qs = some query reads −1 on τ.
hasCharge :: Gauge -> [Query] -> Bool
hasCharge g = any (not . valDirect g)

------------------------------------------------------------------------
-- §2  Subgroups of G, exactly.
--
-- A subgroup of (F2)^n is an F2-subspace; it is stored by a reduced basis
-- (distinct leading bits), which makes membership a greedy reduction and
-- the order literally 2^(number of generators).
------------------------------------------------------------------------

-- Stored in reduced row echelon form (§3's `rref`): pivot column paired
-- with its row, pivot columns ascending, each pivot column set in exactly
-- one row.  That form is CANONICAL for the subspace, so equality of
-- `sgPivots` is equality of subgroups — which is what lets §CHECK compare
-- "residual recomputed from the enlarged query set" against "kernel the
-- menu promised" by ==, rather than by mutual inclusion.
data Subgroup = Subgroup
  { sgAmbient :: Int                -- n: the size of the prime vocabulary
  , sgPivots  :: [(Int, Integer)]   -- reduced row echelon basis
  } deriving (Eq)

sgBasis :: Subgroup -> [Integer]
sgBasis = map snd . sgPivots

sgDim :: Subgroup -> Int
sgDim = length . sgPivots

-- |R| = 2^dim.  Derived (rank–nullity), not counted — and re-derived by
-- counting the whole group in §CHECK.
sgOrder :: Subgroup -> Integer
sgOrder sg = 1 `shiftL` sgDim sg

mkSubgroup :: Int -> [Integer] -> Subgroup
mkSubgroup n gs = Subgroup n (rref n gs)

sgMember :: Subgroup -> Gauge -> Bool
sgMember sg (Gauge v) =
  foldl' (\x (c, r) -> if testBit x c then x `xor` r else x) v (sgPivots sg) == 0

sgElements :: Subgroup -> [Gauge]
sgElements sg = map Gauge (foldl' step [0] (sgBasis sg))
  where step acc b = acc ++ map (`xor` b) acc

-- Is H a subgroup of R?  (Used to certify that a granted port shrinks the
-- residual inside itself rather than replacing it by something unrelated.)
sgContains :: Subgroup -> Subgroup -> Bool
sgContains r h = all (sgMember r) (map Gauge (sgBasis h))

------------------------------------------------------------------------
-- §3  The residual: the exact remainder.
--
--     residual qs = qs^⊥ = { τ : val τ q = +1 for every q ∈ qs }
--
-- which by §1's pairing is the kernel of the F2 matrix whose rows are the
-- square classes pv q.  Order 2^(n − rank) by rank–nullity; generators are
-- the free-column kernel vectors.  This is the object GaugeOrbitClasses
-- §3 proves is a subgroup and §5 proves is the fibre of the transcript.
------------------------------------------------------------------------

-- Reduced row echelon form over F2: pivot column paired with its row.
rref :: Int -> [Integer] -> [(Int, Integer)]
rref n rows0 = sortOn fst (go 0 (filter (/= 0) rows0) [])
  where
    go c rs piv
      | c >= n = piv
      | otherwise =
          case filter (\r -> testBit r c) rs of
            [] -> go (c + 1) rs piv
            (r : _) ->
              let rest = filter (/= 0)
                           [ if testBit x c then x `xor` r else x | x <- delete r rs ]
                  piv' = [ (pc, if testBit pr c then pr `xor` r else pr) | (pc, pr) <- piv ]
              in go (c + 1) rest ((c, r) : piv')

-- Kernel of the matrix with these rows, as a basis.
kernelF2 :: Int -> [Integer] -> [Integer]
kernelF2 n rows = map mk freeCols
  where
    piv = rref n rows
    pivCols = map fst piv
    freeCols = [ c | c <- [0 .. n - 1], c `notElem` pivCols ]
    -- v has 1 in its free column f, and in pivot column pc the entry of
    -- that pivot row at f; then every row pairs to 0 with v.
    mk f = foldl' (\v (pc, pr) -> if testBit pr f then setBit v pc else v) (bit f) piv

rankF2 :: Int -> [Integer] -> Int
rankF2 n = length . rref n

-- THE RESIDUAL, over an explicit prime vocabulary of size n.
residualIn :: Int -> [Query] -> Subgroup
residualIn n qs = mkSubgroup n (kernelF2 n (map parityVec qs))

-- THE RESIDUAL, over the smallest vocabulary naming every prime the
-- queries mention.  (The signature THE_MACHINE.md's CERTIFY step asks for.)
residual :: [Query] -> Subgroup
residual qs = residualIn (vocabOf qs) qs

vocabOf :: [Query] -> Int
vocabOf qs = 1 + maximum ((-1) : concat qs)

------------------------------------------------------------------------
-- §4  The port menu: the quotient lattice, one step at a time.
--
-- A port grants the machine ONE distinction inside its residual R.  The
-- smallest nontrivial distinction is a surjection χ : R ↠ F2 — one bit,
-- index 2 — and THE_MACHINE.md is explicit that this is the unit of the
-- ladder ("grant h mod 2 before h — each port one quotient step, so the
-- machine's development recapitulates the discrimination lattice").  So:
--
--     PORT  =  nonzero χ ∈ Hom(R, F2)   =   maximal subgroup ker χ ⊂ R
--     #PORTS = 2^d − 1                  (d = dim R)
--     after granting:  R ↦ ker χ,  |ker χ| = |R| / 2   exactly.
--
-- Every χ is realised by an actual query — the characters of G are exactly
-- the square classes — so each port carries the concrete number the
-- machine would have to be allowed to read.  Two queries realise the same
-- port exactly when they differ by an element of R^⊥, which is the span of
-- the queries already granted; the menu is therefore a function of R
-- alone, and the representative printed is the least-weight (smallest)
-- number in its class: the cheapest question that opens that door.
--
-- The whole quotient lattice of R is generated by composing ports: this is
-- why the menu lists only the index-2 steps and not all 2^(d(d-1)/2)-ish
-- subgroups.  The demonstration in §6 walks a maximal chain, R of order
-- 2^d down to the trivial group, one bit per port.
------------------------------------------------------------------------

data Quotient = Quotient
  { qChar        :: Integer    -- the character, as a square class in G
  , qQuery       :: Query      -- a concrete query realising it
  , qNumber      :: Integer    -- that query as a number
  , qKernel      :: Subgroup   -- the residual AFTER the grant
  , qIndex       :: Integer    -- always 2: one quotient step
  , qOrderBefore :: Integer
  , qOrderAfter  :: Integer
  }

-- The annihilator of a subgroup inside the dual — for R = qs^⊥ this is the
-- span of qs (double annihilator), recovered from R alone.
dualAnnihilator :: Subgroup -> [Integer]
dualAnnihilator r = kernelF2 (sgAmbient r) (sgBasis r)

spanOf :: [Integer] -> [Integer]
spanOf = foldl' (\acc b -> acc ++ map (`xor` b) acc) [0]

portMenu :: Subgroup -> [Quotient]
portMenu r = sortOn (\q -> (popCount (qChar q), qChar q)) (map mk chars)
  where
    d = sgDim r
    -- A basis of Hom(R, F2), read back inside G.  Because R is stored in
    -- reduced row echelon form, its pivot column c_k is a coordinate where
    -- basis vector b_k is 1 and every OTHER basis vector is 0 — so
    -- ⟨e_{c_k}, b_j⟩ = δ_{jk} and the unit vectors at the pivot columns
    -- are a dual basis, with no search required.
    dualBasis = [ bit c | (c, _) <- sgPivots r ]
    chars = [ foldl' xor 0 [ v | (j, v) <- zip [0 :: Int ..] dualBasis, testBit s j ]
            | s <- [1 .. (1 `shiftL` d) - 1 :: Integer] ]
    -- Two characters grant the same port iff they differ by an element of
    -- R^⊥ (= the span of the queries already held).  Print the cheapest
    -- member of the class: the smallest number that opens this door.
    coset = spanOf (dualAnnihilator r)          -- size 2^(n−d)
    canonical c
      | length coset <= 65536 = snd (minimum [ (popCount (c `xor` z), c `xor` z) | z <- coset ])
      | otherwise = c
    mk c0 =
      let c = canonical c0
          k = restrictKernel r c
      in Quotient { qChar = c
                  , qQuery = bitsOf c
                  , qNumber = numberOf (bitsOf c)
                  , qKernel = k
                  , qIndex = sgOrder r `div` sgOrder k
                  , qOrderBefore = sgOrder r
                  , qOrderAfter = sgOrder k
                  }

-- ker(χ|R): the elements of R the new query still cannot split.
restrictKernel :: Subgroup -> Integer -> Subgroup
restrictKernel r c = mkSubgroup (sgAmbient r) (kernelF2' (sgBasis r) c)
  where
    -- Solve ⟨c, Σ x_k b_k⟩ = 0 in the coordinates of R's own basis, then
    -- push forward.  One linear condition, so the kernel has index 1 or 2.
    kernelF2' bs cc =
      let vals = [ (b, odd (popCount (b .&. cc))) | b <- bs ]
      in case [ b | (b, True) <- vals ] of
           [] -> bs                                  -- χ|R = 0: no shrink
           (p : ps) -> [ b | (b, False) <- vals ] ++ map (xor p) ps

grant :: Subgroup -> Quotient -> Subgroup
grant _ = qKernel

------------------------------------------------------------------------
-- §5  Naming: queries as numbers.
------------------------------------------------------------------------

primes :: [Integer]
primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]

numberOf :: Query -> Integer
numberOf = product . map (primes !!)

bitsOf :: Integer -> Query
bitsOf v = [ i | i <- [0 .. 63], testBit v i ]

showQuery :: Query -> String
showQuery [] = "1"
showQuery [p] = show (primes !! p)
showQuery q = show (numberOf q) ++ " = " ++ intercalate "·" (map (show . (primes !!)) q)

showGauge :: Int -> Gauge -> String
showGauge n g = "(" ++ [ if signAt g p then '+' else '-' | p <- [0 .. n - 1] ] ++ ")"

showSubgroup :: Subgroup -> String
showSubgroup sg =
  "order " ++ show (sgOrder sg) ++ " = 2^" ++ show (sgDim sg)
    ++ ", generators ["
    ++ intercalate ", " [ showGauge (sgAmbient sg) (Gauge b) | b <- sgBasis sg ]
    ++ "]"

------------------------------------------------------------------------
-- §CHECK  Cross-check against the checked Agda.
--
-- Every statement GaugeOrbitClasses / ChargeCriterion certifies is
-- re-verified here by exhaustive enumeration over the finite group — the
-- collision/replication standard: two independent computations of the same
-- object, one a proof term, one a program, agreeing on every case.
------------------------------------------------------------------------

allGauges :: Int -> [Gauge]
allGauges n = map Gauge [0 .. (1 `shiftL` n) - 1]

-- a small corpus of queries, including squares and the Agda probes
testQueries :: [Query]
testQueries = [ [], [0], [1], [0, 1], [1, 2], [0, 2], [0, 1, 2], [2, 2]
              , [0, 0, 1], [3], [0, 3], [1, 1, 2, 2], [0, 1, 2, 3] ]

probe2, probe6 :: [Query]
probe2 = [[0]]              -- Agda ChargeCriterion.probe-2, the number 2
probe6 = [[0, 1]]           -- Agda ChargeCriterion.probe-6, the number 6

type Check = (String, Bool)

checks :: [Check]
checks =
  [ ( "val: definitional fold = F2 pairing (bit encoding is faithful)"
    , and [ valDirect g q == valFast g q | g <- allGauges n, q <- testQueries ] )

  , ( "val-⋆ : val (τ⋆σ) q = val τ q · val σ q            [GaugeOrbitClasses §2]"
    , and [ valDirect (star t s) q == bmul (valDirect t q) (valDirect s q)
          | t <- allGauges n, s <- allGauges n, q <- testQueries ] )

  , ( "val-τ₋ : val τ₋ q = sgn (Ω q)                       [GaugeOrbitClasses §2]"
    , and [ valDirect (tauMinus n) q == sgn (omega q) | q <- testQueries ] )

  , ( "flip-is-τ₋ : flip σ = τ₋ ⋆ σ                        [GaugeOrbitClasses §2]"
    , and [ flipG n s == star (tauMinus n) s | s <- allGauges n ] )

  , ( "flip-law : val (flip σ) q = sgn (Ω q) · val σ q     [ParitySeparator §3]"
    , and [ valDirect (flipG n s) q == bmul (sgn (omega q)) (valDirect s q)
          | s <- allGauges n, q <- testQueries ] )

  , ( "ANNIHILATOR: residual qs = { τ : AllNeutral τ qs }  [GaugeOrbitClasses §3]"
    , and [ sgMember (residualIn n qs) g == allNeutral g qs
          | qs <- querySets, g <- allGauges n ] )

  , ( "order: |qs^⊥| = 2^(n−rank) = #{τ : AllNeutral τ qs} (rank–nullity)"
    , and [ sgOrder (residualIn n qs)
              == fromIntegral (length (filter (`allNeutral` qs) (allGauges n)))
            && sgOrder (residualIn n qs)
              == (1 `shiftL` (n - rankF2 n (map parityVec qs)))
          | qs <- querySets ] )

  , ( "ann-unit : τ₊ ∈ qs^⊥                                [GaugeOrbitClasses §3]"
    , and [ allNeutral tauPlus qs | qs <- querySets ] )

  , ( "ann-mul : τ,ρ ∈ qs^⊥ ⇒ τ⋆ρ ∈ qs^⊥                   [GaugeOrbitClasses §3]"
    , and [ allNeutral (star t r) qs
          | qs <- querySets
          , t <- sgElements (residualIn n qs), r <- sgElements (residualIn n qs) ] )

  , ( "ann-self-inverse : τ ⋆ τ = τ₊                       [GaugeOrbitClasses §3]"
    , and [ star g g == tauPlus | g <- allGauges n ] )

  , ( "neutral-not-charged : AllNeutral ⇒ ¬ HasCharge      [GaugeOrbitClasses §3]"
    , and [ not (allNeutral g qs && hasCharge g qs) | qs <- querySets, g <- allGauges n ] )

  , ( "classes-⇐/⇒ : obs σ qs = obs σ' qs ⟺ σ'⋆σ ∈ qs^⊥   [GaugeOrbitClasses §5]"
    , and [ (obs s qs == obs s' qs) == sgMember (residualIn n qs) (star s' s)
          | qs <- querySets, s <- allGauges n, s' <- allGauges n ] )

  , ( "obs-agree⋆ : τ ∈ qs^⊥ ⇒ transcripts EQUAL (no separator can exist)"
    , and [ obs s qs == obs (star t s) qs
          | qs <- querySets, t <- sgElements (residualIn n qs), s <- allGauges n ] )

  , ( "charge⇒separator⋆ : τ ∉ qs^⊥ ⇒ constructed decide separates, ∀σ"
    , and [ separatorWorks t s qs
          | qs <- querySets, t <- allGauges n, not (sgMember (residualIn n qs) t)
          , s <- allGauges n ] )

  , ( "§6 witness: τ₋ ∈ probe-6^⊥ and τ₀ ∉ probe-6^⊥       [even-but-not-blind]"
    , sgMember (residualIn n probe6) (tauMinus n)
        && not (sgMember (residualIn n probe6) tau0) )

  , ( "§6 witness: τ₋ ∉ probe-2^⊥  (probe-2 separates)     [probe-2-separates]"
    , not (sgMember (residualIn n probe2) (tauMinus n)) )

  , ( "§7 square-neutral : val τ (k++k) = +1 for EVERY τ   [GaugeOrbitClasses §7]"
    , and [ valDirect g (k ++ k) | g <- allGauges n, k <- testQueries ] )

  , ( "§7 square-free-of-charge : (k++k) : qs has the same residual"
    , and [ sgBasis (residualIn n ((k ++ k) : qs)) == sgBasis (residualIn n qs)
          | qs <- querySets, k <- testQueries ] )

  , ( "§7 all-squares-blind : an all-square query set has residual = G"
    , and [ sgOrder (residualIn n [ k ++ k | k <- ks ]) == (1 `shiftL` n)
          | ks <- [ [[0]], [[0], [1, 2]], [[0, 1, 2, 3]] ] ] )

  , ( "double annihilator : (qs^⊥)^⊥ = span qs (menu depends on R alone)"
    , and [ let r = residualIn n qs
                sp = nub (spanOf (map parityVec qs))
            in nub (spanOf (dualAnnihilator r)) `sameSet` sp
          | qs <- querySets ] )

  , ( "PORTS: #menu = 2^d − 1, each of index exactly 2, kernel ⊂ R"
    , and [ let r = residualIn n qs
                m = portMenu r
            in fromIntegral (length m) == sgOrder r - 1
               && all (\p -> qOrderBefore p == 2 * qOrderAfter p) m
               && all (\p -> sgContains r (qKernel p)) m
               && length (nub (map (sgBasis . qKernel) m)) == length m
          | qs <- querySets ] )

  , ( "PORTS realise: granting port p = adding its query to the query set"
    , and [ let r = residualIn n qs
            in all (\p -> sgBasis (residualIn n (qQuery p : qs)) == sgBasis (qKernel p))
                   (portMenu r)
          | qs <- querySets ] )

  , ( "PORTS split: the granted port strictly separates a class it could not"
    , and [ let r = residualIn n qs
            in all (\p -> any (\t -> sgMember r t && not (sgMember (qKernel p) t))
                              (sgElements r))
                   (portMenu r)
          | qs <- querySets ] )
  ]
  where
    n = 4
    querySets = [ [], probe2, probe6, [[0], [1]], [[0, 1], [1, 2]]
                , [[0, 1], [1, 2], [0, 2]], [[0, 1], [2, 2]], [[0, 1, 2, 3]]
                , [[0], [1], [2], [3]] ]
    sameSet a b = all (`elem` b) a && all (`elem` a) b

-- Agda charge⇒separator⋆, transcribed: find the first charged query, read
-- its answer off the transcript, compare against the base point's value.
separatorWorks :: Gauge -> Gauge -> [Query] -> Bool
separatorWorks t s qs =
  case [ i | (i, q) <- zip [0 :: Int ..] qs, not (valDirect t q) ] of
    [] -> True   -- vacuous: τ is neutral, no separator claimed
    (i : _) ->
      let q = qs !! i
          decide l = bmul (valDirect s q) (l !! i)
      in decide (obs s qs) && not (decide (obs (star t s) qs))

------------------------------------------------------------------------
-- §6  THE DEMONSTRATION.
--
-- A world of five primes (|G| = 32) and a query set of four numbers, one
-- of them a square.  The residual is computed; it is nontrivial, so the
-- machine is PROVABLY blind to something and can name what.  One port is
-- granted.  The residual is recomputed from the enlarged query set — not
-- patched — and it has strictly halved.  Repeat to the wall.
------------------------------------------------------------------------

demoN :: Int
demoN = 5

demoQueries :: [Query]
demoQueries = [ [0, 1]        -- 6
              , [1, 2]        -- 15
              , [0, 2]        -- 10   ( = 6·15 / 3², dependent: adds nothing )
              , [3, 3]        -- 49   ( a square: GaugeOrbitClasses §7 )
              ]

report :: String -> IO ()
report = putStrLn

banner :: String -> IO ()
banner s = report "" >> report s >> report (replicate (length s) '=')

describeResidual :: Int -> Subgroup -> IO ()
describeResidual n r = do
  report ("  residual  : " ++ showSubgroup r)
  report ("  ignorance : " ++ show (sgOrder r) ++ " of " ++ show (1 `shiftL` n :: Integer)
          ++ " gauge elements are invisible; " ++ show (sgOrder r - 1)
          ++ " nontrivial distinctions the machine provably cannot make")
  report ("  classes   : the transcript map has "
          ++ show ((1 `shiftL` n :: Integer) `div` sgOrder r)
          ++ " fibres, each a coset of the residual [GaugeOrbitClasses classes-⇐/⇒]")
  if sgOrder r <= 16
    then report ("  the wall  : " ++ intercalate " " (map (showGauge n) (sgElements r)))
    else return ()

showPort :: Quotient -> String
showPort p =
  "    port  χ = " ++ showQuery (qQuery p)
    ++ "   |R| " ++ show (qOrderBefore p) ++ " → " ++ show (qOrderAfter p)
    ++ "   (index " ++ show (qIndex p) ++ ", one quotient step)"

demonstrate :: IO ()
demonstrate = do
  banner "DEMONSTRATION — the machine's ignorance, computed and then spent"
  report ("world     : " ++ show demoN ++ " primes "
          ++ show (take demoN primes) ++ ", gauge group G = (F2)^" ++ show demoN
          ++ ", |G| = " ++ show (1 `shiftL` demoN :: Integer))
  report  "queries   :"
  mapM_ (\q -> report ("    " ++ showQuery q ++ "   Ω = " ++ show (omega q))) demoQueries
  report ("rank of the query span = "
          ++ show (rankF2 demoN (map parityVec demoQueries))
          ++ "  (10 = 6·15/3² is dependent; 49 is a square and has rank 0)")

  let r0 = residualIn demoN demoQueries
  report ""
  report "CERTIFY — the wall:"
  describeResidual demoN r0
  report ("  blind to τ₋ (total flip, the parity grading)? "
          ++ show (sgMember r0 (tauMinus demoN))
          ++ "   [all Ω even ⇒ parity-blind, ChargeCriterion]")
  report ("  blind to τ₀ (flip at 2 alone)?               "
          ++ show (sgMember r0 tau0)
          ++ "   [GaugeOrbitClasses §6: even-Ω is NOT gauge-blind]")

  report ""
  report "no gradient: appending an arbitrarily large square changes nothing"
  let bigSquare = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4]        -- (2·3·5·7·11)²
      r0' = residualIn demoN (bigSquare : demoQueries)
  report ("  query " ++ show (numberOf bigSquare) ++ " added; residual order "
          ++ show (sgOrder r0) ++ " → " ++ show (sgOrder r0')
          ++ "   [GaugeOrbitClasses square-free-of-charge]")

  report ""
  report ("PORT MENU — " ++ show (length (portMenu r0))
          ++ " ports = 2^" ++ show (sgDim r0) ++ " − 1, each one quotient step,")
  report  "            ordered cheapest first (fewest primes: h mod 2 before h)"
  mapM_ (report . showPort) (portMenu r0)
  report ("  (each port is a CLASS of "
          ++ show ((1 `shiftL` demoN :: Integer) `div` sgOrder r0)
          ++ " queries differing by span(qs) — e.g. 2, 3 and 5 grant the same")
  report  "   port here, and 6, 10, 15, 49 grant none: the menu is a function of the"
  report  "   residual alone, not of the history that produced it)"

  banner "GRANTING ONE PORT"
  let p1 = head (portMenu r0)
      r1 = grant r0 p1
  report ("  granted   : " ++ showQuery (qQuery p1) ++ "  — a declared section, not a derivation")
  report ("  recomputed from the enlarged query set: "
          ++ show (sgBasis (residualIn demoN (qQuery p1 : demoQueries)) == sgBasis r1))
  describeResidual demoN r1
  report ("  SHRANK    : " ++ show (sgOrder r0) ++ " → " ++ show (sgOrder r1)
          ++ ", exactly a factor " ++ show (sgOrder r0 `div` sgOrder r1)
          ++ "; ignorance down by exactly 1 bit")
  let split = [ g | g <- sgElements r0, not (sgMember r1 g) ]
  report ("  newly visible gauge elements ("
          ++ show (length split) ++ "): "
          ++ intercalate " " (map (showGauge demoN) split))

  banner "WALKING THE CHAIN TO THE WALL"
  chain demoQueries r0 (1 :: Int)

  banner "THE AGDA PROBES, THROUGH THE SAME ORGAN"
  report  "(`residual` over the smallest vocabulary the queries name)"
  let r2 = residual probe2
      r6 = residual probe6
  report ("  probe-2 = {2}  : " ++ showSubgroup r2
          ++ "  — trivial residual: everything it can name, it can split")
  report ("                   τ₋ ∈ residual? " ++ show (sgMember r2 (tauMinus (sgAmbient r2)))
          ++ "   [ChargeCriterion.probe-2-separates]")
  report ("  probe-6 = {6}  : " ++ showSubgroup r6
          ++ "  — blind to exactly one nontrivial element")
  report ("                   τ₋ ∈ residual? " ++ show (sgMember r6 (tauMinus (sgAmbient r6)))
          ++ "   [ChargeCriterion.probe-6-cannot]")
  report ("                   τ₀ ∈ residual? " ++ show (sgMember r6 tau0)
          ++ "  [GaugeOrbitClasses.even-but-not-blind: even Ω is NOT gauge-blind]")
  report ("  probe-6's port menu: "
          ++ intercalate ", " [ showQuery (qQuery p) | p <- portMenu r6 ]
          ++ "   — one port, one bit, and the wall is gone")
  where
    chain qs r k
      | sgDim r == 0 = do
          report ("  step " ++ show k ++ ": residual is TRIVIAL — order 1.")
          report  "  the machine can now split every gauge element it can name;"
          report  "  no port remains, and GROW is the only move left."
      | otherwise = do
          let p = head (portMenu r)
              qs' = qQuery p : qs
              r' = residualIn demoN qs'
          report ("  step " ++ show k ++ ": grant " ++ showQuery (qQuery p)
                  ++ "  |R| " ++ show (sgOrder r) ++ " → " ++ show (sgOrder r')
                  ++ "  (menu had " ++ show (length (portMenu r))
                  ++ (if length (portMenu r) == 1 then " port)" else " ports)"))
          if sgBasis r' /= sgBasis (qKernel p)
            then report "  !! recomputation disagreed with the menu" >> chain qs' r' (k + 1)
            else chain qs' r' (k + 1)

------------------------------------------------------------------------
-- main
------------------------------------------------------------------------

main :: IO ()
main = do
  banner "CROSS-CHECK against formal/cubical/NaturalMachine/*.agda"
  report "exhaustive over the whole group (n = 4, |G| = 16, all 256 pairs);"
  report "exact F2 arithmetic throughout — no measurement, no fit."
  report ""
  mapM_ (\(nm, ok) -> report ((if ok then "  PASS  " else "  FAIL  ") ++ nm)) checks
  let bad = [ nm | (nm, False) <- checks ]
  report ""
  report ("  " ++ show (length checks - length bad) ++ "/" ++ show (length checks)
          ++ " checks pass")
  demonstrate
  report ""
  if null bad then exitSuccess else report ("FAILED: " ++ show bad) >> exitFailure
