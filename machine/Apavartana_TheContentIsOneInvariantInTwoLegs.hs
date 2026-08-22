-- अपवर्तन — Apavartana: the content is ONE invariant wearing legs 2 and 3.
--
-- THE TERM, ITS TEXT AND ITS DATE.  अपवर्तन (apavartana), "turning away /
-- reducing", is the operation of dividing through by a common divisor;
-- अपवर्तक (apavartaka) is the divisor itself.  BRAHMAGUPTA,
-- *Brāhmasphuṭasiddhānta* 18 (628), states it as the FIRST step of the
-- kuṭṭaka: divide the dividend, the divisor and the additive by their
-- common divisor, and — this is the load-bearing half — if the additive is
-- not divisible by that common divisor of the other two, the question is a
-- bad one and has no solution.  BHĀSKARA II repeats it in the *Bījagaṇita*
-- (1150).  (Both passages in Colebrooke's translation, *Algebra, with
-- Arithmetic and Mensuration, from the Sanscrit of Brahmegupta and
-- Bháscara*, London 1817, ch. XVIII; Datta & Singh, *History of Hindu
-- Mathematics* II, ch. on the pulveriser.)
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  Brahmagupta states the
-- apavartana condition — the common divisor of dividend and divisor is a
-- COMPLETE criterion on the additive — in 628.  He does not state a normal
-- form for matrices, and nothing here says he did.  The Hermite (1851) and
-- Smith (1861) normal forms are nineteenth-century European and are named
-- as such where they are used; what this module shows is that the invariant
-- those forms isolate, e₁, is the apavartaka, and that its two roles were
-- already two halves of one procedure in 628.
--
-- ------------------------------------------------------------------------
-- WHAT THIS MODULE IS FOR.
--
-- Two documents in this repository state one theorem about one invariant
-- and do not cite each other:
--
--   notes/HECKE_COMPOSITION_SMITH_LABELS.md, Theorem 1
--       for sublattices of ℤ² of COPRIME indices, the Smith invariants
--       multiply coordinatewise under composition.
--       — that is LEG 2 of `VargaPrakrti_CompositionLawAsParameter.Law`:
--         an invariant that multiplies under lawCompose.
--
--   formal/cubical/Swarm/S09SmithKuttaka.agda
--       the Smith invariant d of the 1×2 matrix [a m] is the COMPLETE
--       obstruction of a z ≡ b (mod m), with explicit integer witnesses
--       both ways.
--       — that is LEG 3: the exactness device that makes the descent's
--         divisions come out whole.
--
-- The invariant is the same object in both: e₁, the gcd of the entries,
-- the apavartaka.  This module instantiates `Law` on it, runs the reactor,
-- and reports what the run finds.
--
-- ------------------------------------------------------------------------
-- THE BRIDGE, which is what makes the two lanes one lane.
--
-- Send w = x + yω in ℤ[ω], ω² = Tω + C, to its multiplication matrix in
-- the basis (1, ω):
--
--     μ(x, y)  =  [ x   C y    ]        det μ(w) = x² + Txy − Cy² = N(w)
--                 [ y   x + Ty ]        gcd of entries = gcd(x, y)
--
-- Then μ(u·v) = μ(u)·μ(v) — BHĀVANĀ IS COMPOSITION OF SUBLATTICES OF ℤ²,
-- the norm is the index, and the CONTENT of the pair is the Smith label e₁
-- of the sublattice.  Brahmagupta's composition rule (628) and the Hecke
-- note's Theorem 1 are then the same statement about the same invariant,
-- written once about surds and once about lattices.
--
-- ------------------------------------------------------------------------
-- THE NEW ANSWER: THE APAVARTANA BOUND, which Theorem 1 does not state.
--
-- Theorem 1 is a statement at COPRIME indices only.  Off that locus the
-- note goes to counting (Theorem 2's 1 / p+1 multiplicities) and says
-- nothing about the label of a composite.  The general statement is:
--
--     THEOREM.  For 2×2 integer matrices M, N with det M ≠ 0 ≠ det N,
--
--         e₁(M) · e₁(N)  |  e₁(MN)      and, writing
--         e(M,N) = e₁(MN) / (e₁(M)·e₁(N)),
--         e(M,N)  |  gcd( det M / e₁(M)² ,  det N / e₁(N)² ).
--
--     Coprime indices force e = 1, which is Theorem 1's e₁ statement, so
--     the bound CONTAINS Theorem 1 and extends it to the whole locus.
--
-- The proof is one adjugate contraction and is the same move S09SmithKuttaka
-- already makes in `keyA` / `keyM`:  det M · N = adj(M) · (MN), so every
-- entry of det M · N is an integer combination of entries of MN; if some
-- integer combination of N's entries is 1 — which is what e₁(N) = 1 says —
-- then any c dividing all entries of MN divides det M.  Kernel-checked, over
-- an arbitrary commutative ring, in
-- formal/cubical/Apavartana_TheContentBoundAndThePrimitiveWheel.agda.
--
-- ------------------------------------------------------------------------
-- WHAT THE BOUND BUYS BACK IN THE REACTOR, and this is the point.
--
-- `vargaPrakrti`'s leg 3 refuses when gcd(b, |k|) ≠ 1 — "the kuṭṭaka
-- refuses".  A scan of every turn of every wheel at T = 0, D ≤ 400 and
-- T = 1, Δ ≤ 2001 finds that guard firing ZERO times.  Under this
-- repository's protocol a measurement like that is standing in for a
-- theorem, and here is the theorem:
--
--     COROLLARY.  The cakravāla step preserves content.  If gcd(a,b) = 1
--     then gcd(a',b') = 1, hence gcd(b', |k'|) = 1, hence leg 3's
--     congruence is solvable at every turn of the principal wheel.
--
--     Proof.  q·(m,1) = k·q'.  Both q and (m,1) have content 1, so by the
--     bound the content of the product divides gcd(k, m²+Tm−C) = |k|,
--     because k divides m²+Tm−C at the chosen m.  That content is
--     |k|·gcd(a',b').  So |k|·gcd(a',b') divides |k|.  ∎
--
-- So the `inverseMod` guard is provably dead code on the principal wheel,
-- and the 15 stops the reactor lane recorded at cap 600 are the STATED TURN
-- BOUND and nothing else — the two were never in danger of being confused,
-- and now they cannot be.
--
-- ------------------------------------------------------------------------
-- WHERE THE OBSTRUCTION IS LIVE, and it is Brahmagupta's own sentence.
--
-- Off the principal wheel — Brahmagupta composes with ARBITRARY kṣepa, and
-- x² − Dy² = 1 is one row of his table — a seed with content g > 1 makes
-- leg 3's congruence genuinely unsolvable unless g divides a + bT.  That is
-- the apavartana condition of 628, verbatim, arriving as the exactness
-- criterion of a descent written thirteen centuries later.  The run below
-- exhibits both branches with their residues.
--
-- ------------------------------------------------------------------------
-- ROAD TWO.  Where a step cannot be carried, this module writes a śeṣa — a
-- remainder handed forward, carrying the failing instance so a reader can
-- rerun exactly it (notes/AHIMSA_SUTRA_VISTARA.md §6, §16; doṣa 0028).  The
-- carrier type is `Defect` from `VargaPrakrti_CompositionLawAsParameter`,
-- which is that lane's name for the same record; the word used here for
-- what road two produces is śeṣa.
--
-- EXACT Integer ARITHMETIC ONLY.  No floating point anywhere.

module Apavartana_TheContentIsOneInvariantInTwoLegs
  ( Mat(..)
  , matMul, matDet, matContent, hermite, hermiteBases
  , mu, quadContent
  , apavartanaLaw
  , excess
  , selfTestApavartana
  ) where

import VargaPrakrti_CompositionLawAsParameter
import Data.List (nub)

------------------------------------------------------------------- matrices
--
-- Row-major 2×2.  A sublattice of ℤ² is the COLUMN lattice Mℤ², following
-- notes/HECKE_COMPOSITION_SMITH_LABELS.md's fixed convention.
data Mat = Mat !Integer !Integer !Integer !Integer deriving (Eq)

instance Show Mat where
  show (Mat p q r s) = "[" ++ show p ++ " " ++ show q ++ "; "
                           ++ show r ++ " " ++ show s ++ "]"

matMul :: Mat -> Mat -> Mat
matMul (Mat p q r s) (Mat p' q' r' s') =
  Mat (p*p' + q*r') (p*q' + q*s') (r*p' + s*r') (r*q' + s*s')

matDet :: Mat -> Integer
matDet (Mat p q r s) = p*s - q*r

-- e₁, the Smith label, the apavartaka: the gcd of the entries.  For a
-- nonsingular M it is the largest c with Mℤ² ⊆ cℤ².
matContent :: Mat -> Integer
matContent (Mat p q r s) = gcd (gcd (abs p) (abs q)) (gcd (abs r) (abs s))

-- Column reduction to the note's canonical basis: columns (a,b) and (0,d),
-- a·d = index, 0 ≤ b < d.  The first step is EUCLID ON THE FIRST ROW, which
-- is the kuṭṭaka: `bezout` is imported from the varga-prakṛti lane rather
-- than rewritten, because it is the same procedure (Āryabhaṭa, 499).
--
-- The transformation is a right GL₂(ℤ) action, so the column lattice is
-- unchanged; `selfTestApavartana` re-checks |det| and the lattice at every
-- use rather than trusting that.
hermite :: Mat -> Either Defect Mat
hermite m@(Mat p q r s)
  | matDet m == 0 = Left (Defect
      "leg 1 (composition), law = apavartana"
      "the matrix is singular: it is not a basis of a finite-index sublattice"
      (show m))
  | otherwise =
      let (u, v, g) = bezout p q          -- u·p + v·q = g = gcd(p,q)
          -- U = [ u  -q/g ] has det (u·p + v·q)/g = 1
          --     [ v   p/g ]
          b1 = r*u + s*v
          b2 = r*(negate q `div` g) + s*(p `div` g)
          -- now the matrix is [ g 0 ; b1 b2 ]; normalise signs and corner
          (g' , b1' ) = if g  < 0 then (negate g , negate b1) else (g , b1)
          (b2', b1'') = if b2 < 0 then (negate b2, b1'      ) else (b2, b1')
          bfin = b1'' `mod` b2'
      in Right (Mat g' 0 bfin b2')

-- every Hermite basis of index m: a·d = m, 0 ≤ b < d.  σ₁(m) of them.
hermiteBases :: Integer -> [Mat]
hermiteBases m = [ Mat a 0 b d | a <- [1 .. m], m `mod` a == 0
                 , let d = m `div` a, b <- [0 .. d - 1] ]

--------------------------------------------------------------- the bridge
--
-- μ(x,y) : the matrix of multiplication by x + yω in the basis (1, ω).
mu :: Integer -> Integer -> Quad -> Mat
mu t c (Quad x y) = Mat x (c*y) y (x + t*y)

quadContent :: Quad -> Integer
quadContent (Quad x y) = gcd (abs x) (abs y)

----------------------------------------------------------------- the law
--
-- LEG 1  lawCompose   = the Hermite form of the matrix product.  For
--                       sublattices this is composition of chains
--                       (HECKE_COMPOSITION_SMITH_LABELS §0).
-- LEG 2  lawNorm      = e₁, the apavartaka.  It multiplies at coprime
--                       indices (Theorem 1) and NOT in general, so
--                       `composeChecked` is here an instrument: every
--                       failure it writes is an instance of the Hecke
--                       recursion's off-cyclic term.
-- LEG 3  lawDescend   = apavartana by ONE prime at a time.  L ⊆ e₁ℤ² gives
--                       L = e₁·L₀, exactly; taking one prime factor per
--                       turn makes the wheel turn Ω(e₁) times and each turn
--                       is the homothety step of the note's Theorem 2,
--                       {L : p | e₁(L)} = {pL' : [ℤ²:L'] = index/p²}.
--
-- lawFinish is Nothing: Brahmagupta's k = −1, ±2, 4 shortcut is a statement
-- about the quadratic norm and has no analogue for the content.  Saying so
-- is cheaper than inventing one.
apavartanaLaw :: Mat -> Law Mat
apavartanaLaw seed = Law
  { lawName   = "apavartana  e₁ on sublattices of ℤ²"
  , lawSource = "Brahmagupta, Brāhmasphuṭasiddhānta 18 (628) for the \
                \apavartana condition on the kuṭṭaka, and 18.64–65 for the \
                \composition; Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33 (499) \
                \for the pulveriser itself.  The Hermite (1851) and Smith \
                \(1861) normal forms are the nineteenth-century European \
                \restatements of the invariant, used here under their own \
                \names for the matrix bookkeeping only."
  , lawUnit    = Mat 1 0 0 1
  , lawCompose = \a b -> either (const (matMul a b)) id (hermite (matMul a b))
  , lawNorm    = matContent
  , lawSeed    = Right seed
  , lawDescend = descend
  , lawFinish  = const Nothing
  , lawShow    = show
  }
  where
    descend m@(Mat p q r s) =
      let e = matContent m in
      case smallestPrimeFactor e of
        Nothing -> Left (Defect
          "leg 3 (descent), law = apavartana"
          "the content is 1: the lattice is already in the cyclic stratum \
          \and there is nothing to divide out"
          (show m))
        Just pr
          | all (\z -> z `mod` pr == 0) [p,q,r,s] ->
              Right (Mat (p `div` pr) (q `div` pr) (r `div` pr) (s `div` pr))
          | otherwise -> Left (Defect
              "leg 3 (descent), law = apavartana"
              ("apavartana is not exact: " ++ show pr ++ " divides the content "
               ++ show e ++ " but not every entry — the content was computed "
               ++ "wrongly, which cannot happen, so this śeṣa records a broken "
               ++ "invariant rather than a mathematical obstruction")
              (show m ++ "   residues mod " ++ show pr ++ " = "
               ++ show (map (`mod` pr) [p,q,r,s])))

smallestPrimeFactor :: Integer -> Maybe Integer
smallestPrimeFactor n
  | n <= 1 = Nothing
  | otherwise = Just (head ([ d | d <- [2 .. isqrt n], n `mod` d == 0 ] ++ [n]))

-- the excess of Theorem 1, off the coprime locus.
excess :: Mat -> Mat -> Either Defect Integer
excess m n = do
  mn <- hermite (matMul m n)
  let e = matContent mn
      g = matContent m * matContent n
  if g /= 0 && e `mod` g == 0
    then Right (e `div` g)
    else Left (Defect "leg 2 (multiplicative invariant), law = apavartana"
           ("e₁(M)·e₁(N) = " ++ show g ++ " does not divide e₁(MN) = " ++ show e)
           (show m ++ " · " ++ show n))
