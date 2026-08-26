{-# OPTIONS --cubical --safe --no-import-sorts #-}

{-
  SubgroupIndex — the coset space of a subgroup of a finite group, its
  cardinality (THE INDEX), and LAGRANGE'S THEOREM  |G| = [G:H] · |H|,
  together with the divisibility corollary and a NEGATION derived from it.

  ---------------------------------------------------------------------------
  WHAT ALREADY EXISTED, verified by reading and NOT rebuilt here
  ---------------------------------------------------------------------------

    * `Cubical.Algebra.Group.Subgroup` (v0.9): `isSubgroup`, `Subgroup`,
      `⟪_⟫`, `Subgroup→Group`, `isNormal`, `trivialSubgroup`,
      `groupSubgroup`, kernels and images.  A subgroup is a subSET
      (`ℙ ⟨ G ⟩`), which is exactly the hypothesis shape needed below.
    * `Cubical.Algebra.Group.QuotientGroup` (v0.9): the quotient *group*
      `G / N` for a NORMAL subgroup, built on `SetQuotients`.  It is not
      what this file needs: Lagrange is about the coset SET of an
      arbitrary subgroup, which carries no group structure.
    * `Cubical.Data.FinSet.Quotients` (v0.9): `isFinSetQuot` — a set
      quotient of a finite set by a decidable equivalence relation is
      finite.  This is where the decidability hypothesis is spent, and it
      is imported, not re-proved.
    * `Cubical.Data.FinSet.Cardinality` (v0.9): `card`, `cardEquiv`,
      `sumCardFiber`, `sumConst`, `isContr→card≡1`.  The fibrewise count
      `|X| = Σ_y |fibre f y|` is the library's; the content here is the
      identification of each fibre with `H`.
    * IN THIS REPOSITORY: `FinCardinality.agda` (Cauchy, today) supplies
      `injSameCard→isEquiv`, CRT, `countMul`;
      `NaturalMachine/FiniteEquivalenceBridge.agda` and
      `NaturalMachine/Decategorification.agda` supply card-transport;
      `NaturalMachine/StabilizerSubgroup.agda` and
      `NaturalMachine/StabilizerTorsor.agda` supply stabiliser subgroups
      and the torsor structure of transporters.  None of them mentions a
      coset space, an index, or an order.

  ---------------------------------------------------------------------------
  THE DELTA
  ---------------------------------------------------------------------------

  Before this module, `formal/` contained NO group order and NO subgroup
  `grep -rn "Lagrange\|coset"` over `formal/cubical/` returned only prose
  comments.  Cubical v0.9 has no Lagrange theorem either: the coset space
  of a non-normal subgroup does not appear in the library at all.  What is
  added here is exactly:

      Coset, index, order, lagrange, order∣card, and the corollary.

  The proof is four steps of finite counting and no analysis:

      1. `x ∼ y := inv x · y ∈ H` is an equivalence relation (the three
         subgroup axioms, once each);
      2. its quotient is finite, because membership is decidable
         (`isFinSetQuot`);
      3. every fibre of `[_] : G → G/∼` is EQUIVALENT to `H`, by
         `h ↦ g · h` at any representative `g` — well-defined on the
         quotient because the goal `card (fibre c) ≡ |H|` is a
         PROPOSITION, so `elimProp` needs no choice of representative;
      4. `sumCardFiber` + `sumConst`.

  Step 3 is where a set-level proof would need to choose coset
  representatives; in HoTT the choice is unnecessary because the
  *cardinality* of the fibre, unlike the fibre, is a proposition-valued
  statement.  That is the only place this proof differs from the textbook
  one, and it is worth recording as the reason no choice principle appears.

  PRIOR ART.  Lagrange's theorem is Lagrange (1771)/Galois; every algebra
  text has it.  In type theory it is well-trodden: agda-unimath has
  `group-theory.lagrange-theorem` (CITED, not read — `WebFetch` is blocked
  in this container, so nothing is asserted about its exact contents), and
  the HoTT book's finite-set material contains the counting principles it
  rests on.  NOTHING NEW IS CLAIMED MATHEMATICALLY.  What is claimed is the
  certificate under this pin, in the library where the Γ₀(N) lane needs it,
  reusing that lane's own `Subgroup` type so downstream work does not have
  to bridge two notions of subgroup.

  Hypotheses are arguments, not comments: finiteness of `G` and
  decidability of membership in `H` are parameters of the module, and
  §5 shows the theorem has teeth by DERIVING A NEGATION from it (no group
  of order 3 has a subgroup of order 2) rather than by exhibiting an
  instance where it holds.
-}

module SubgroupIndex where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Powerset
open import Cubical.Foundations.Structure using (⟨_⟩)

open import Cubical.Data.Sigma
open import Cubical.Data.Bool
-- v0.9 name-clash note.  Inside `module Index` below, `_·_` would denote BOTH
-- ℕ multiplication and the group operation (GroupStr).  Agda disambiguates
-- ambiguous CONSTRUCTOR and field names but not ambiguous DEFINED names, so
-- ℕ multiplication is taken under the unambiguous name `_·ℕ_` throughout this
-- file and `_·_` is left to the group.  Same operation, same statements.
open import Cubical.Data.Nat hiding (_·_)
open import Cubical.Data.Nat using () renaming (_·_ to _·ℕ_)
open import Cubical.Data.Nat.Divisibility using (_∣_)
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty

open import Cubical.Relation.Nullary hiding (⟪_⟫)   -- v0.9 exports ⟪_⟫ = Populated;
                                                    -- this module means the subgroup carrier
                                                    -- Cubical.Algebra.Group.Subgroup.⟪_⟫
open import Cubical.Relation.Nullary.DecidablePropositions
open import Cubical.Relation.Binary.Base

open import Cubical.HITs.SetQuotients as SetQuot renaming (_/_ to _/s_)
open import Cubical.HITs.PropositionalTruncation as PropTrunc using (∣_∣₁)

open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors
open import Cubical.Data.FinSet.Cardinality
open import Cubical.Data.FinSet.Quotients

open import Cubical.Algebra.Group.Base
open import Cubical.Algebra.Group.Properties
open import Cubical.Algebra.Group.Subgroup

private
  variable
    ℓ : Level

open BinaryRelation
open isSubgroup

------------------------------------------------------------------------
-- §0  Two small bridges the library does not state in this direction.
------------------------------------------------------------------------

-- `isDecProp` is the Bool-valued formulation `isFinSetQuot` demands;
-- `isDecProp→Dec` exists, the converse for a *proposition* does not.
Dec→isDecProp : {P : Type ℓ} → isProp P → Dec P → isDecProp P
Dec→isDecProp hp (yes p) =
  true , propBiimpl→Equiv hp isPropUnit (λ _ → tt) (λ _ → p)
Dec→isDecProp hp (no ¬p) = false , uninhabEquiv ¬p (λ x → x)

-- The singleton at a FIXED TARGET.  `isContrSingl` is the fixed-source
-- one; this direction is what a "trivial subgroup" carrier is.
isContrΣ≡ : {A : Type ℓ} (y : A) → isContr (Σ[ x ∈ A ] x ≡ y)
fst (isContrΣ≡ y) = y , refl
snd (isContrΣ≡ y) (x , p) i = p (~ i) , λ j → p (~ i ∨ j)

------------------------------------------------------------------------
-- §1  The coset space of a subgroup of a finite group.
--
-- HYPOTHESES, all as arguments:
--   finG  : the group is finite;
--   decH  : membership in H is decidable.
-- Both are spent in exactly one place each (§2), and neither is
-- decorative: without `decH` the quotient of a finite set need not be
-- finite, so `index` would not be a natural number at all.
------------------------------------------------------------------------

module Index (G : Group ℓ)
             (finG : isFinSet ⟨ G ⟩)
             (H : Subgroup G)
             (decH : (g : ⟨ G ⟩) → Dec (g ∈ ⟪ H ⟫)) where

  open GroupStr (snd G)
  open GroupTheory G

  private
    X : Type ℓ
    X = ⟨ G ⟩

    Hsub : isSubgroup G ⟪ H ⟫
    Hsub = H .snd

  FG : FinSet ℓ
  FG = X , finG

  -- Left cosets: x ∼ y iff x and y differ by an element of H on the right.
  _∼_ : X → X → Type ℓ
  x ∼ y = (inv x · y) ∈ ⟪ H ⟫

  isProp∼ : (x y : X) → isProp (x ∼ y)
  isProp∼ x y = ∈-isProp ⟪ H ⟫ (inv x · y)

  -- Each clause is one subgroup axiom, transported along one group law.
  ∼refl : (x : X) → x ∼ x
  ∼refl x = subst (_∈ ⟪ H ⟫) (sym (·InvL x)) (Hsub .id-closed)

  ∼sym : (x y : X) → x ∼ y → y ∼ x
  ∼sym x y p =
    subst (_∈ ⟪ H ⟫)
      (invDistr (inv x) y ∙ cong (inv y ·_) (invInv x))
      (Hsub .inv-closed p)

  ∼trans : (x y z : X) → x ∼ y → y ∼ z → x ∼ z
  ∼trans x y z p q = subst (_∈ ⟪ H ⟫) path (Hsub .op-closed p q)
    where
    path : ((inv x · y) · (inv y · z)) ≡ (inv x · z)
    path = sym (·Assoc (inv x) y (inv y · z))
         ∙ cong (inv x ·_)
             (·Assoc y (inv y) z ∙ cong (_· z) (·InvR y) ∙ ·IdL z)

  isEquivRel∼ : isEquivRel _∼_
  isEquivRel∼ = equivRel ∼refl ∼sym ∼trans

  isDecProp∼ : (x y : X) → isDecProp (x ∼ y)
  isDecProp∼ x y = Dec→isDecProp (isProp∼ x y) (decH (inv x · y))

  Coset : Type ℓ
  Coset = X /s _∼_

  -- The decidability hypothesis is spent HERE and only here.
  finCoset : isFinSet Coset
  finCoset = isFinSetQuot FG _∼_ isEquivRel∼ isDecProp∼

  FCoset : FinSet ℓ
  FCoset = Coset , finCoset

  q : X → Coset
  q x = SetQuot.[ x ]

  -- The carrier of H.  Definitionally the carrier of the library's
  -- `Subgroup→Group H`, so `order` below is the order of that group.
  HCarrier : Type ℓ
  HCarrier = Σ[ x ∈ X ] x ∈ ⟪ H ⟫

  finH : isFinSet HCarrier
  finH = isFinSetΣ FG (λ x → _ , isDecProp→isFinSet (∈-isProp ⟪ H ⟫ x) (decH x))

  FH : FinSet ℓ
  FH = HCarrier , finH

  -- THE INDEX and THE ORDER, as natural numbers.
  index : ℕ
  index = card FCoset

  order : ℕ
  order = card FH

  ------------------------------------------------------------------
  -- §2  Every fibre of the quotient map is equivalent to H.
  ------------------------------------------------------------------

  private
    cancelL : (g x : X) → (g · (inv g · x)) ≡ x
    cancelL g x = ·Assoc g (inv g) x ∙ cong (_· x) (·InvR g) ∙ ·IdL x

    cancelL' : (g x : X) → (inv g · (g · x)) ≡ x
    cancelL' g x = ·Assoc (inv g) g x ∙ cong (_· x) (·InvL g) ∙ ·IdL x

  -- h ↦ g · h, at a chosen representative g.
  fibreIso : (g : X) → Iso HCarrier (fiber q (q g))
  Iso.fun (fibreIso g) (h , hh) =
    (g · h) , eq/ (g · h) g (subst (_∈ ⟪ H ⟫) toInv (Hsub .inv-closed hh))
    where
    toInv : inv h ≡ (inv (g · h) · g)
    toInv = sym (cong (_· g) (invDistr g h) ∙ sym (·Assoc (inv h) (inv g) g)
               ∙ cong (inv h ·_) (·InvL g) ∙ ·IdR (inv h))
  Iso.inv (fibreIso g) (x , p) =
    (inv g · x)
    , subst (_∈ ⟪ H ⟫)
        (invDistr (inv x) g ∙ cong (inv g ·_) (invInv x))
        (Hsub .inv-closed (effective isProp∼ isEquivRel∼ x g p))
  Iso.rightInv (fibreIso g) (x , p) =
    Σ≡Prop (λ _ → squash/ _ _) (cancelL g x)
  Iso.leftInv (fibreIso g) (h , hh) =
    Σ≡Prop (λ y → ∈-isProp ⟪ H ⟫ y) (cancelL' g h)

  FFibre : (c : Coset) → FinSet ℓ
  FFibre c = fiber q c , isFinSetFiber FG FCoset q c

  -- No representative is chosen: the goal is a path in ℕ, hence a
  -- proposition, so `elimProp` discharges it.  This is the step that
  -- would need choice of coset representatives in a set-level proof.
  cardFibre : (c : Coset) → card (FFibre c) ≡ order
  cardFibre =
    SetQuot.elimProp (λ c → isSetℕ (card (FFibre c)) order)
      (λ g → cardEquiv (FFibre (q g)) FH ∣ invEquiv (isoToEquiv (fibreIso g)) ∣₁)

  ------------------------------------------------------------------
  -- §3  Lagrange.
  ------------------------------------------------------------------

  lagrange' : card FG ≡ order ·ℕ index
  lagrange' = sumCardFiber FG FCoset q
            ∙ sumConst FCoset (λ c → card (FFibre c)) order cardFibre

  lagrange : card FG ≡ index ·ℕ order
  lagrange = lagrange' ∙ ·-comm order index

  order∣card : order ∣ card FG
  order∣card = ∣ index , sym lagrange ∣₁
    -- Was a placeholder carrying `·Comm (card FG) 0`, a term of no type here
    -- (`·Comm` is the CommRing/Monoid name; ℕ's commutativity in cubical v0.9
    -- is `·-comm`, and the second factor was wrong besides).  The STATEMENT
    -- is unchanged; the proof is now the one `order∣card'` below already
    -- gives, so the two are the same theorem twice, which is what the
    -- original comment said was intended.

  order∣card' : order ∣ card FG
  order∣card' = ∣ index , sym lagrange ∣₁

------------------------------------------------------------------------
-- §4  Non-vacuity, stated for EVERY finite group rather than at an
--     instance: the two extreme subgroups have the two extreme indices.
------------------------------------------------------------------------

module Extremes (G : Group ℓ) (finG : isFinSet ⟨ G ⟩) where

  open GroupStr (snd G)

  private
    X : Type ℓ
    X = ⟨ G ⟩

  decTrivial : (g : X) → Dec (g ∈ ⟪ trivialSubgroup {G' = G} ⟫)
  decTrivial g = isFinSet→Discrete finG g 1g

  decTotal : (g : X) → Dec (g ∈ ⟪ groupSubgroup {G' = G} ⟫)
  decTotal g = yes refl

  module T = Index G finG (trivialSubgroup {G' = G}) decTrivial
  module A = Index G finG (groupSubgroup {G' = G}) decTotal

  -- |{1}| = 1, hence [G : {1}] = |G|.
  order-trivial : T.order ≡ 1
  order-trivial = isContr→card≡1 T.FH (isContrΣ≡ 1g)

  index-trivial : T.index ≡ card T.FG
  index-trivial =
    sym (·-identityʳ T.index) ∙ cong (T.index ·ℕ_) (sym order-trivial) ∙ sym T.lagrange

  -- G/G is contractible, hence [G : G] = 1, and then |G| = |G|.
  isContrCosetTotal : isContr A.Coset
  fst isContrCosetTotal = A.q 1g
  snd isContrCosetTotal =
    SetQuot.elimProp (λ c → squash/ (A.q 1g) c) (λ x → eq/ 1g x refl)

  index-total : A.index ≡ 1
  index-total = isContr→card≡1 A.FCoset isContrCosetTotal

  order-total : card A.FG ≡ A.order
  order-total = A.lagrange ∙ cong (_·ℕ A.order) index-total ∙ ·-identityˡ A.order

------------------------------------------------------------------------
-- §5  A NEGATION derived from Lagrange.
--
-- The strongest control available is not an instance where the theorem
-- holds but a statement it makes FALSE.  For every group of order 3 and
-- every decidable subgroup of it, having order 2 is IMPOSSIBLE — not
-- merely unproved.  This is Lagrange's content, and it is stated for all
-- G at once, so it is not a finite check in disguise.
------------------------------------------------------------------------

private
  ¬n·2≡1 : (n : ℕ) → ¬ (n ·ℕ 2 ≡ 1)
  ¬n·2≡1 zero p = znots p
  ¬n·2≡1 (suc n) p = snotz (injSuc p)

  ¬n·2≡3 : (n : ℕ) → ¬ (n ·ℕ 2 ≡ 3)
  ¬n·2≡3 zero p = znots p
  ¬n·2≡3 (suc n) p = ¬n·2≡1 n (injSuc (injSuc p))

no-order-2-in-order-3 :
    (G : Group ℓ) (finG : isFinSet ⟨ G ⟩)
    (H : Subgroup G) (decH : (g : ⟨ G ⟩) → Dec (g ∈ ⟪ H ⟫))
  → card (Index.FG G finG H decH) ≡ 3
  → ¬ (Index.order G finG H decH ≡ 2)
no-order-2-in-order-3 G finG H decH c3 o2 =
  ¬n·2≡3 (Index.index G finG H decH)
    (sym (cong (Index.index G finG H decH ·ℕ_) o2)
       ∙ sym (Index.lagrange G finG H decH) ∙ c3)
    -- The where-bound alias `_⁻¹ = sym` that stood here cannot be used in
    -- `_ ⁻¹ ∙ _`: an undeclared postfix operator gets the default `infixl 20`,
    -- which is LOOSER than `_∙_`'s 30, so the application does not parse.
    -- `sym` written out is the same term.
