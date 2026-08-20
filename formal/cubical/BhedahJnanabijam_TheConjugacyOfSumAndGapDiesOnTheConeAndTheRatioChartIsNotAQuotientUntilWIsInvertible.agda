{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BhedahJnanabijam_TheConjugacyOfSumAndGapDiesOnTheCone
--                   AndTheRatioChartIsNotAQuotientUntilWIsInvertible
--
-- WHERE THE MATHEMATICS COMES FROM, stated first because the naming rule
-- requires it.  The programme, the nine nodes, the demand that every one
-- of the thirty-six pairs carry an exact status, and the four-state
-- comparison type are the OWNER'S, in
--
--   collab/upstream/library/raw/ANEKANTA_UNIVALENCE_DELTA_13_2026-08-13.md
--
-- (§"Univalent representation atlas", §"Research operator", §"Boundary-
-- breaking schema"), and the two cells §5 records as his are T18.1 and
-- T18.3 of the next transmission, Prime-Pair Atlas Delta 18, 2026-08-13,
-- preserved at notes/reflection_ground--owner-messages-FULL-TRANSCRIPT
-- -20260812-to-20260820.md lines 1685-1790.
--
-- This is NOT material from a classical text and no Sanskrit label is
-- invented for it.  The file name quotes Delta 13's own epigraph:
--
--     न एकदृष्टिः पर्याप्ता। न सर्वदृष्टयः समानाः।
--     यत्र समता प्रमाणिता तत्र परिवहनम्; यत्र न, तत्र भेदः ज्ञानबीजम्।
--
--     One view is insufficient; not all views are equal.  Where
--     equivalence is proved, transport.  Where it is not, the defect is
--     a seed of knowledge.  (भेदः ज्ञानबीजम् — the difference is the
--     seed of knowledge.)
--
-- Every theorem below is of the second kind.  Not one of the four cells
-- this module determines is an equivalence.
--
--
-- WHAT IS CHECKED
--
--   §0  the SHAPE of the atlas, as a term: nine nodes, thirty-six
--       unordered pairs, and the count of cells this module claims.
--       The enumeration's size is checked, not only its emptiness --
--       `length allNodes ≡ 9` and `length atlasEdges ≡ 36` -- because a
--       fold over the empty list satisfies every predicate.
--
--   §1  the three nodes this module can actually present as maps.
--
--   §2  ⟨pair field, sum projection⟩ = QUOTIENT.  The homotopy fibre of
--       σ over every w is ℤ (`fibreSum≃ℤ`), so σ is a fibration with
--       constant fibre ℤ and is not an equivalence (`σ-not-equiv`).
--
--   §3  ⟨pair field, gap projection⟩ = QUOTIENT, same fibre
--       (`fibreGap≃ℤ`, `δ-not-equiv`).
--
--   §4  ⟨sum projection, gap projection⟩.  Three separate facts:
--       `σ≢δ`                  Def(σ,δ) is EMPTY;
--       `gapIsSumAfterFlip`    and yet δ = σ ∘ J₁ with J₁ an equivalence
--       `J₁Equiv`              of the pair field -- they are CONJUGATE;
--       `noConeConjugacy`      and no function whatever conjugates them
--                              on the positive cone.
--       That last is Delta 13's "Immediate target B" -- equivalence
--       upstairs, inequivalent effective subspaces downstairs -- and it
--       is the same phenomenon the owner reports in the ratio chart as
--       T18.2 (x ↦ 1/x leaves |x| < 1).
--
--   §5  ⟨pair field, Hahn/angular⟩.  The comparison the owner names in
--       T18.1 is the ratio x = R/W.  Denominator-free it is `t-share`
--       and `T18-2-inversion`, both one line of ring algebra.  But the
--       relation "same ratio" is reflexive and symmetric and NOT
--       transitive on the pair field (`ratio-not-transitive`, witness at
--       W = 0), and it IS transitive as soon as the middle term has
--       W invertible (`ratio-trans`).  That hypothesis is then SHARPENED
--       (`ratio-trans-sharp`, `originOnly`): transitivity survives every
--       khahara point W = 0, R ≠ 0 and fails at exactly one point, the
--       origin, where the ratio is 0÷0.  So the cell is a quotient after
--       deleting ONE POINT, not a divisor, and Bhāskara II's distinction
--       between khahara and 0÷0 (Khahara.agda, this directory) is
--       precisely the distinction the chart makes.
--
--   §6  MY OWN CLAIMS, KILLED, two of them.  I wrote the table's first
--       draft on the rule "Def(f,g) empty ⟹ the two nodes are distinct
--       perspectives"; §4 kills it (`emptyDefDoesNotSeparate`).  I then
--       wrote §5's boundary as W = 0; §5.6 kills that too.
--
-- WHAT IS NOT CLAIMED: nothing analytic, nothing about primes, nothing
-- about tanh or η or Meixner-Pollaczek measures.  §5 checks the
-- denominator-free shadow of T18.1/T18.2 over ℤ and says so.  Delta 18's
-- SU(1,1) content is over the positive reals and cubical v0.5 has no ℝ.
--
-- CHECKED on Agda 2.6.3 + cubical v0.5, which is NOT the repository pin.
-- Exit code quoted in the commit message and in the accompanying note.
------------------------------------------------------------------------

module BhedahJnanabijam_TheConjugacyOfSumAndGapDiesOnTheConeAndTheRatioChartIsNotAQuotientUntilWIsInvertible where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; _++_ ; map)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; _+_ ; _-_ ; _·_ ; -_)
open import Cubical.Data.Int.Properties
  using ( isSetℤ ; injPos ; posNotnegsuc ; +Comm ; minusPlus ; plusMinus
        ; -Involutive ; ·lCancel ; pos+ ; discreteℤ ; isIntegralℤ )
open import Cubical.Algebra.CommRing using (CommRing)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

------------------------------------------------------------------------
-- §0  The shape of the atlas, as a term.
--
-- Delta 13 lists nine presentations of Prime-Pair and asks for the exact
-- status of every pair.  Nine nodes give thirty-six unordered pairs.
-- Both numbers are checked, because a claim about an enumeration is
-- worthless without its size: `foldr _and_ true []` is `true` for any
-- predicate, and so is any exhaustion over a list I forgot to fill.
------------------------------------------------------------------------

data Node : Type₀ where
  pairField        : Node   -- the two legs (p , q)
  sumProjection    : Node   -- W = p + q
  gapProjection    : Node   -- R = q - p
  mellinDirichlet  : Node
  finiteAdicCharge : Node
  buchstabFlow     : Node
  hahnAngular      : Node
  su11Meixner      : Node
  affineFixedDet   : Node

allNodes : List Node
allNodes =
  pairField ∷ sumProjection ∷ gapProjection ∷ mellinDirichlet
  ∷ finiteAdicCharge ∷ buchstabFlow ∷ hahnAngular ∷ su11Meixner
  ∷ affineFixedDet ∷ []

-- Guard 1: the enumeration has the size Delta 13's list has.
nineNodes : length allNodes ≡ 9
nineNodes = refl

-- Guard 2: the enumeration is complete.  Nine clauses, no catch-all, so
-- adding a constructor breaks this and not silently the counts below.
data _∈L_ {A : Type₀} (x : A) : List A → Type₀ where
  here  : {xs : List A} → x ∈L (x ∷ xs)
  there : {y : A} {xs : List A} → x ∈L xs → x ∈L (y ∷ xs)

allNodesComplete : (n : Node) → n ∈L allNodes
allNodesComplete pairField        = here
allNodesComplete sumProjection    = there here
allNodesComplete gapProjection    = there (there here)
allNodesComplete mellinDirichlet  = there (there (there here))
allNodesComplete finiteAdicCharge = there (there (there (there here)))
allNodesComplete buchstabFlow     = there (there (there (there (there here))))
allNodesComplete hahnAngular      = there (there (there (there (there (there here)))))
allNodesComplete su11Meixner      = there (there (there (there (there (there (there here))))))
allNodesComplete affineFixedDet   = there (there (there (there (there (there (there (there here)))))))

-- The thirty-six unordered pairs, in the order the note's table prints.
withEach : Node → List Node → List (Node × Node)
withEach x ys = map (λ y → (x , y)) ys

edges : List Node → List (Node × Node)
edges []       = []
edges (x ∷ xs) = withEach x xs ++ edges xs

atlasEdges : List (Node × Node)
atlasEdges = edges allNodes

-- Guard 3: thirty-six, not "however many I happened to write".
thirtySixEdges : length atlasEdges ≡ 36
thirtySixEdges = refl

-- The verdict carried by each cell.
data Status : Type₀ where
  checkedHere  : Status   -- determined below, by a term in this module
  ownerFilled  : Status   -- determined by the owner in Delta 18
  notAttempted : Status

status : Node × Node → Status
status (pairField     , sumProjection)  = checkedHere   -- §2
status (pairField     , gapProjection)  = checkedHere   -- §3
status (pairField     , hahnAngular)    = checkedHere   -- §5
status (sumProjection , gapProjection)  = checkedHere   -- §4
status (gapProjection , affineFixedDet) = ownerFilled   -- Delta 18 T18.3
status (hahnAngular   , su11Meixner)    = ownerFilled   -- Delta 18 T18.1
status _                                = notAttempted

-- A two-valued tag, defined here rather than imported, so the counting
-- below has no dependency beyond ℕ.
data Bool' : Type₀ where
  yes' no' : Bool'

isChecked isOwner isOpen : Status → Bool'
isChecked checkedHere  = yes'
isChecked _            = no'
isOwner   ownerFilled  = yes'
isOwner   _            = no'
isOpen    notAttempted = yes'
isOpen    _            = no'

count : (Status → Bool') → List (Node × Node) → ℕ
count f []       = 0
count f (c ∷ cs) with f (status c)
... | yes' = suc (count f cs)
... | no'  = count f cs

-- Guard 4: the three counts are what the note's table says, and they
-- sum to thirty-six.  If a cell is re-graded in `status` and the note is
-- not, this breaks.
checkedCount : count isChecked atlasEdges ≡ 4
checkedCount = refl

ownerCount : count isOwner atlasEdges ≡ 2
ownerCount = refl

openCount : count isOpen atlasEdges ≡ 30
openCount = refl

------------------------------------------------------------------------
-- §1  The three nodes this module can present as structure, not prose.
--
-- Delta 13: "a perspective is a structure-producing interpretation
-- L_i : X ↦ X_i, not prose."  Of the nine, exactly these three have a
-- presentation over ℤ that needs nothing the corpus has not got.
------------------------------------------------------------------------

PairField : Type₀
PairField = ℤ × ℤ

-- W, the sum projection.
σ : PairField → ℤ
σ (p , q) = p + q

-- R, the gap projection.
δ : PairField → ℤ
δ (p , q) = q - p

------------------------------------------------------------------------
-- §2  ⟨pair field, sum projection⟩ — QUOTIENT, fibre ℤ.
--
-- Delta 13's stated action where only a quotient exists: compute the
-- homotopy fibres.  They are ℤ, uniformly in w.
------------------------------------------------------------------------

fibreSumIso : (w : ℤ) → Iso (fiber σ w) ℤ
Iso.fun (fibreSumIso w) ((p , _) , _) = p
Iso.inv (fibreSumIso w) p = (p , w - p) , (+Comm p (w - p) ∙ minusPlus p w)
Iso.rightInv (fibreSumIso w) p = refl
Iso.leftInv (fibreSumIso w) ((p , q) , e) =
  ΣPathP ( (λ i → (p , lem i))
         , isProp→PathP (λ i → isSetℤ _ _) _ _ )
  where
    lem : w - p ≡ q
    lem = cong (_- p) (sym e) ∙ cong (_- p) (+Comm p q) ∙ plusMinus p q

fibreSum≃ℤ : (w : ℤ) → fiber σ w ≃ ℤ
fibreSum≃ℤ w = isoToEquiv (fibreSumIso w)

private
  pos0≢pos1 : ¬ (pos 0 ≡ pos 1)
  pos0≢pos1 e = znots (injPos e)

-- Not an equivalence: an equivalence is injective and σ is not.
σ-not-equiv : ¬ (isEquiv σ)
σ-not-equiv e = pos0≢pos1 (cong fst collapse)
  where
    E : PairField ≃ ℤ
    E = σ , e
    sameSum : σ (pos 0 , pos 1) ≡ σ (pos 1 , pos 0)
    sameSum = refl
    collapse : (pos 0 , pos 1) ≡ (pos 1 , pos 0)
    collapse =
      sym (retEq E (pos 0 , pos 1))
      ∙ cong (invEq E) sameSum
      ∙ retEq E (pos 1 , pos 0)

------------------------------------------------------------------------
-- §3  ⟨pair field, gap projection⟩ — QUOTIENT, the same fibre.
------------------------------------------------------------------------

fibreGapIso : (w : ℤ) → Iso (fiber δ w) ℤ
Iso.fun (fibreGapIso w) ((p , _) , _) = p
Iso.inv (fibreGapIso w) p = (p , w + p) , plusMinus p w
Iso.rightInv (fibreGapIso w) p = refl
Iso.leftInv (fibreGapIso w) ((p , q) , e) =
  ΣPathP ( (λ i → (p , lem i))
         , isProp→PathP (λ i → isSetℤ _ _) _ _ )
  where
    lem : w + p ≡ q
    lem = cong (_+ p) (sym e) ∙ minusPlus p q

fibreGap≃ℤ : (w : ℤ) → fiber δ w ≃ ℤ
fibreGap≃ℤ w = isoToEquiv (fibreGapIso w)

δ-not-equiv : ¬ (isEquiv δ)
δ-not-equiv e = pos0≢pos1 (cong fst collapse)
  where
    E : PairField ≃ ℤ
    E = δ , e
    sameGap : δ (pos 0 , pos 0) ≡ δ (pos 1 , pos 1)
    sameGap = refl
    collapse : (pos 0 , pos 0) ≡ (pos 1 , pos 1)
    collapse =
      sym (retEq E (pos 0 , pos 0))
      ∙ cong (invEq E) sameGap
      ∙ retEq E (pos 1 , pos 1)

------------------------------------------------------------------------
-- §4  ⟨sum projection, gap projection⟩.
--
-- Delta 13: "For parallel routes f, g : A → B, study the comparison type
-- Def(f,g) := (f = g).  It may be contractible, multiply inhabited,
-- empty, or unknown."  Here it is EMPTY -- and that turns out to settle
-- nothing, which is §6.
------------------------------------------------------------------------

-- 4.1  Def(σ,δ) is empty.  At (1,0) the sum is 1 and the gap is -1.
σ≢δ : ¬ (σ ≡ δ)
σ≢δ e = posNotnegsuc 1 0 (cong (λ f → f (pos 1 , pos 0)) e)

-- 4.2  and yet: the one-leg sign flip conjugates one into the other.
J₁ : PairField → PairField
J₁ (p , q) = (- p , q)

J₁Involutive : (x : PairField) → J₁ (J₁ x) ≡ x
J₁Involutive (p , q) i = (-Involutive p i , q)

J₁Equiv : PairField ≃ PairField
J₁Equiv = isoToEquiv (iso J₁ J₁ J₁Involutive J₁Involutive)

gapIsSumAfterFlip : (x : PairField) → σ (J₁ x) ≡ δ x
gapIsSumAfterFlip (p , q) = +Comm (- p) q

-- 4.3  BOUNDARY BREAKING (Delta 13, "Immediate target B").
--      The conjugacy does not survive restriction to the positive cone,
--      and not merely because J₁ fails to preserve it: NO function of
--      the cone to itself conjugates σ into δ there.

Pos : ℤ → Type₀
Pos (pos zero)    = ⊥
Pos (pos (suc _)) = Unit
Pos (negsuc _)    = ⊥

private
  posSum : (a b : ℤ) → Pos a → Pos b → Pos (a + b)
  posSum (pos (suc m)) (pos (suc n)) _  _  = subst Pos (pos+ (suc m) (suc n)) tt
  posSum (pos zero)    _             pa _  = ⊥rec pa
  posSum (negsuc _)    _             pa _  = ⊥rec pa
  posSum (pos (suc _)) (pos zero)    _  pb = ⊥rec pb
  posSum (pos (suc _)) (negsuc _)    _  pb = ⊥rec pb

Cone : Type₀
Cone = Σ[ x ∈ PairField ] (Pos (fst x) × Pos (snd x))

coneSumPos : (c : Cone) → Pos (σ (fst c))
coneSumPos ((p , q) , (pp , pq)) = posSum p q pp pq

coneWitness : Cone
coneWitness = ((pos 2 , pos 1) , (tt , tt))

-- σ is positive everywhere on the cone; δ is not, at (2,1) it is -1.
noConeConjugacy :
  ¬ (Σ[ ψ ∈ (Cone → Cone) ] ((c : Cone) → σ (fst (ψ c)) ≡ δ (fst c)))
noConeConjugacy (ψ , h) =
  subst Pos (h coneWitness) (coneSumPos (ψ coneWitness))

------------------------------------------------------------------------
-- §5  ⟨pair field, Hahn/angular⟩ — the owner's T18.1 comparison, and the
--     exact hypothesis it consumes.
--
-- Delta 18 T18.1: with W = x₁+x₂ and R = x₂-x₁, the angular coordinate
-- is x = R/W, and "ratio x₂/x₁, split-torus parameter η, and Jacobi
-- coordinate x are the same rank-one orbit coordinate in three charts";
-- with t = x₁/(x₁+x₂), x = 1-2t.
--
-- Over ℤ there is no division.  What survives, denominator-free, is
-- 5.1 and 5.2, and both are one line of ring algebra -- no analytic
-- content is claimed for either.  The mathematical work is 5.3-5.5: the
-- relation "same ratio", read by cross-multiplication, is NOT an
-- equivalence relation on the pair field.
------------------------------------------------------------------------

-- 5.1  T18.1's "x = 1 - 2t", cleared of denominators: W - 2p = R.
t-share : (p q : ℤ) → σ (p , q) - (p + p) ≡ δ (p , q)
t-share = solve ℤCommRing

-- 5.2  T18.2's "x ↦ 1/x", cleared of denominators.  J₂ carries (W,R) to
--      (-R,-W), so the ratio's numerator/denominator pair goes from
--      (R,W) to (-W,-R); that this is the reciprocal is the cross
--      equality (-W)·R = W·(-R).
T18-2-inversion : (W R : ℤ) → (- W) · R ≡ W · (- R)
T18-2-inversion = solve ℤCommRing

-- 5.3  The ratio chart as a relation on the pair field.
SameRatio : PairField → PairField → Type₀
SameRatio x y = δ x · σ y ≡ δ y · σ x

sameRatio-refl : (x : PairField) → SameRatio x x
sameRatio-refl x = refl

sameRatio-sym : (x y : PairField) → SameRatio x y → SameRatio y x
sameRatio-sym x y = sym

-- Dilation invariance: the chart really is a function of the ray.
dil : ℤ → PairField → PairField
dil k (p , q) = (k · p , k · q)

private
  dilAlg : (k p q : ℤ) → ((k · q) - (k · p)) · (p + q) ≡ (q - p) · ((k · p) + (k · q))
  dilAlg = solve ℤCommRing

sameRatio-dil : (k : ℤ) (x : PairField) → SameRatio (dil k x) x
sameRatio-dil k (p , q) = dilAlg k p q

-- 5.4  IT IS NOT TRANSITIVE.  The witness sits exactly on W = 0.
private
  a₀ b₀ c₀ : PairField
  a₀ = (pos 1 , pos 2)     -- W = 3, R = 1
  b₀ = (pos 0 , pos 0)     -- W = 0, R = 0   ← the deleted divisor
  c₀ = (pos 1 , pos 3)     -- W = 4, R = 2

  ab : SameRatio a₀ b₀
  ab = refl

  bc : SameRatio b₀ c₀
  bc = refl

  pos4≢pos6 : ¬ (pos 4 ≡ pos 6)
  pos4≢pos6 e = znots (injSuc (injSuc (injSuc (injSuc (injPos e)))))

  ¬ac : ¬ (SameRatio a₀ c₀)
  ¬ac = pos4≢pos6

ratio-not-transitive :
  ¬ ((x y z : PairField) → SameRatio x y → SameRatio y z → SameRatio x z)
ratio-not-transitive tr = ¬ac (tr a₀ b₀ c₀ ab bc)

-- 5.5  and it IS transitive the moment the middle term's W is nonzero.
--      That is the hypothesis the theorem consumes; nothing else is
--      needed, and it is exactly "delete the divisor W = 0".
private
  h1 : (a b c : ℤ) → b · (a · c) ≡ (a · b) · c
  h1 = solve ℤCommRing
  h2 : (d e c : ℤ) → (d · e) · c ≡ (d · c) · e
  h2 = solve ℤCommRing
  h3 : (f b e : ℤ) → (f · b) · e ≡ b · (f · e)
  h3 = solve ℤCommRing

ratio-trans :
  (x y z : PairField) → ¬ (σ y ≡ pos 0) →
  SameRatio x y → SameRatio y z → SameRatio x z
ratio-trans x y z nz p q =
  ·lCancel (σ y) (δ x · σ z) (δ z · σ x)
    ( h1 (δ x) (σ y) (σ z)          -- σy·(δx·σz) ≡ (δx·σy)·σz
    ∙ cong (_· σ z) p               --            ≡ (δy·σx)·σz
    ∙ h2 (δ y) (σ x) (σ z)          --            ≡ (δy·σz)·σx
    ∙ cong (_· σ x) q               --            ≡ (δz·σy)·σx
    ∙ h3 (δ z) (σ y) (σ x) )        --            ≡ σy·(δz·σx)
    nz

-- 5.6  and `σ y ≢ 0` is NOT the sharp hypothesis.  This is the second
--      thing of mine that died on the way (see §6).
--
--      Khahara.agda, in this directory, records Bhāskara II's
--      distinction (Līlāvatī / Bījagaṇita, 1150, correcting Brahmagupta,
--      Brāhmasphuṭasiddhānta, 628): n÷0 with n ≠ 0 is khahara, a
--      determinate non-finite quantity, and is a DIFFERENT thing from
--      0÷0, whose defect — as that module's 2026-08-19 correction states
--      it — is that the solution set is not a singleton.
--
--      That distinction is exactly the one the ratio chart makes.  A
--      khahara point (W = 0, R ≠ 0) does not break transitivity at all:
--      relating to it forces the outer terms' W to vanish too, and the
--      conclusion then holds.  Only the 0÷0 point (W = 0 AND R = 0) —
--      which is the origin (0,0) of the pair field, and nothing else —
--      relates to everything and so destroys transitivity.
--
--      So the divisor to delete is not W = 0.  It is the single point
--      W = R = 0, which is the origin of the pair field (`originOnly`).
--      The witness of 5.4 is that point.  Together with 5.4 this is
--      "exactly one point", not a manner of speaking.
private
  zeroR : (a : ℤ) → a · pos 0 ≡ pos 0
  zeroR = solve ℤCommRing

  doubleq : (p q : ℤ) → q + q ≡ (p + q) + (q - p)
  doubleq = solve ℤCommRing
  doublep : (p q : ℤ) → p + p ≡ (p + q) - (q - p)
  doublep = solve ℤCommRing
  two· : (a : ℤ) → pos 2 · a ≡ a + a
  two· = solve ℤCommRing
  pos2≢0 : ¬ (pos 2 ≡ pos 0)
  pos2≢0 e = znots (sym (injPos e))

  halve : (a : ℤ) → a + a ≡ pos 0 → a ≡ pos 0
  halve a e = ·lCancel (pos 2) a (pos 0) (two· a ∙ e ∙ sym (zeroR (pos 2))) pos2≢0

-- The vanishing locus of both projections is one point.
originOnly : (p q : ℤ) →
  σ (p , q) ≡ pos 0 → δ (p , q) ≡ pos 0 → (p , q) ≡ (pos 0 , pos 0)
originOnly p q sw sr i =
  ( halve p (doublep p q ∙ cong₂ _-_ sw sr) i
  , halve q (doubleq p q ∙ cong₂ _+_ sw sr) i )

ratio-trans-sharp :
  (x y z : PairField) → ¬ ((σ y ≡ pos 0) × (δ y ≡ pos 0)) →
  SameRatio x y → SameRatio y z → SameRatio x z
ratio-trans-sharp x y z nz p q with discreteℤ (σ y) (pos 0)
... | no  σy≢0 = ratio-trans x y z σy≢0 p q
... | yes σy≡0 =
  cong (δ x ·_) σz≡0 ∙ zeroR (δ x) ∙ sym (zeroR (δ z)) ∙ cong (δ z ·_) (sym σx≡0)
  where
    δy≢0 : ¬ (δ y ≡ pos 0)
    δy≢0 e = nz (σy≡0 , e)
    σx≡0 : σ x ≡ pos 0
    σx≡0 = isIntegralℤ (δ y) (σ x)
             (sym p ∙ cong (δ x ·_) σy≡0 ∙ zeroR (δ x)) δy≢0
    σz≡0 : σ z ≡ pos 0
    σz≡0 = isIntegralℤ (δ y) (σ z)
             (q ∙ cong (δ z ·_) σy≡0 ∙ zeroR (δ z)) δy≢0

------------------------------------------------------------------------
-- §6  MY OWN CLAIMS, KILLED.
--
-- CLAIM 1 (mine, 2026-08-20).  The first draft of the accompanying table
-- graded cells by the rule: if f, g : A → B are the maps presenting two
-- nodes and Def(f,g) := (f ≡ g) is empty, the two nodes are distinct
-- perspectives and the cell is a proved failure.
--
-- It is false, and §4 is the counterexample: Def(σ,δ) is empty and the
-- two are nevertheless conjugate by an equivalence of the pair field.
-- Emptiness of the comparison type is not evidence of inequivalence; it
-- is evidence about ONE choice of parallel routes.  `emptyDefDoesNot-
-- Separate` below.
--
-- CLAIM 2 (mine, same day).  I wrote §5's boundary as "the ratio chart
-- is a quotient after deleting the divisor W = 0", and `ratio-trans` is
-- the theorem I proved for it.  That hypothesis is not sharp: 5.6 shows
-- transitivity survives every khahara point (W = 0, R ≠ 0) and fails at
-- exactly one point, the origin.  A hypothesis that is true and not
-- sharp reads, in a status table, as a bigger obstruction than there is.
-- Both statements are kept, in that order, because the second is only
-- legible as a correction of the first.
--
-- (The neighbouring theorem, from the other side: NaturalMachine.
-- TransportPrice_AgreementDoesNotDetermineTheTransport shows agreement
-- does not determine the transport.  This shows disagreement does not
-- deny it.)
------------------------------------------------------------------------

emptyDefDoesNotSeparate :
  ¬ ( (A B : Type₀) (f g : A → B) → ¬ (f ≡ g) →
      ¬ (Σ[ e ∈ (A ≃ A) ] ((x : A) → f (equivFun e x) ≡ g x)) )
emptyDefDoesNotSeparate rule =
  rule PairField ℤ σ δ σ≢δ (J₁Equiv , gapIsSumAfterFlip)

------------------------------------------------------------------------
-- §7  What is not claimed.
--
--  * No cell of the atlas is marked `equivalence` by this module.  Four
--    are determined and all four are quotients or failures.
--  * §5 checks the denominator-free shadow of T18.1 and T18.2 over ℤ.
--    It does NOT check T18.1's identification of the ratio with tanh η,
--    which is a statement about positive reals; cubical v0.5 ships no ℝ.
--    That cell is graded `ownerFilled, transport not formalized` in the
--    note, and the route that would settle it is named there.
--  * `Pos` is a structural positivity predicate on ℤ chosen so the cone
--    computations reduce.  No order theory is developed and none is
--    needed for §4.3.
--  * Nothing here bears on primality, on Goldbach, or on twin primes.
------------------------------------------------------------------------
