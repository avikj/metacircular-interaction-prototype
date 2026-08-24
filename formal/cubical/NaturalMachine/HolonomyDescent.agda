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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.HolonomyDescent
--
-- Holonomy descent (path erasure), checked in Cubical Agda.
--
-- Rank-2 port from the Lean development `formal/pairfield/Pairfield/
-- HolonomyDescent.lean` (129 lines), per the spec in
-- notes/LEAN_TO_CUBICAL_PORT_MAP.md §3.2.  Two halves:
--
--   Orbit         a group G acts on a type X of presentations; the
--                 orbit quotient X / OrbitRel erases the path by which
--                 a presentation was reached.  A set-valued task
--                 descends iff it is invariant under every generated
--                 holonomy, and the descent is unique — stated here as
--                 an isContr, fusing Lean's factors_through_orbit_iff
--                 with orbit_factor_unique.  Effectivity: the path
--                 space of the quotient at two named presentations IS
--                 the mere orbit relation (orbitPathTruncIso; the
--                 group laws enter only here and in orbitMk-▸).
--
--   Coinvariants  the additive half.  Lean builds
--                 `differenceSubgroup := AddSubgroup.closure
--                 {g • x - x}` and quotients the group by it, spending
--                 its whole second half on closure_le / ker /
--                 QuotientAddGroup.lift / addMonoidHom_ext.  Here the
--                 HIT set quotient by the RAW generator relation
--                    DiffRel a b = Σ g x. a ≡ b + ((g ▸ x) - x)
--                 (not an equivalence relation — transitivity fails,
--                 and none is needed) generates the closure for free:
--                 eq/ on generators is the subgroup, _+Q_ descends by
--                 SQ.rec2 because DiffRel is translation-invariant,
--                 and both universal-property proofs are one
--                 SQ.elimProp each.  Success test from the port map
--                 holds: NO closure lemma appears anywhere below.
--
-- Signature ledger (Lean name → this module):
--   orbitSetoid                        → OrbitRel (raw Σ, no setoid)
--   OrbitSet / orbitMk                 → OrbitSet / orbitMk
--   orbitMk_smul                       → orbitMk-▸
--   factors_through_orbit_iff          → factors→invariant,
--                                        invariant→factors (descend)
--   orbit_factor_unique                → descend-contr   (isContr ≥ ∃!)
--   —  (unstated in Lean)              → orbitPathTruncIso (effectivity)
--   differenceSubgroup + quotient      → DiffRel, Coinv (one HIT)
--   coinvariantMk (→+)                 → coinvMk, coinvMkHom
--   coinvariantMk_smul                 → coinvMk-▸
--   addHom_factors_through_…_iff       → homFactors→invariant,
--                                        invariant→homFactors (descendHom)
--   coinvariant_factor_unique          → descendHom-contr (isContr ≥ ∃!)
--   —  (Lean: instance resolution)     → CoinvAbGroup, 0Q/_+Q_/-Q_
--
-- Deltas against the port-map spec (§3.2), all strengthenings:
--   * The coinvariants half needs ONLY the additivity axiom ▸-hom
--     (g ▸ (x + y) ≡ g ▸ x + g ▸ y): the unit and composition laws of
--     the action are never used, so they are not hypotheses.  Lean's
--     [DistribMulAction G A] carries both; the port drops them.
--   * descend/descendHom uniqueness is stated as isContr of the full
--     factorization data, which is strictly stronger than Lean's ∃!
--     (it includes uniqueness of the commuting homotopy).
--   * The AbGroup structure on the coinvariants is exhibited
--     (CoinvAbGroup), where Lean leaves it to instance resolution.
--   * v0.5 skew (anticipated by the map): no group-action module in
--     cubical v0.5, so the action and its laws are module parameters.
--
-- Honesty note on the map's "port is shorter" thesis: the CLOSURE
-- APPARATUS is gone as predicted (this file contains no subgroup, no
-- closure, no ker, no lift), but the raw file is ~194 code lines vs
-- Lean's ~99.  The excess is (i) content Lean does not prove —
-- CoinvAbGroup with its laws, coinvMkHom, effectivity, the isContr
-- strengthenings, ▸-0/▸-neg — and (ii) a real cost the map missed:
-- Lean's AddSubgroup.closure is closed under negation FOR FREE, while
-- the raw generator relation needs the explicit diffNeg lemma before
-- -Q_ descends.  Statement-for-statement against Lean's theorem set
-- the two are comparable; the Cubical side is denser only in what it
-- additionally proves.
--
-- All statements proved; no holes, no postulates, --safe.
------------------------------------------------------------------------

module NaturalMachine.HolonomyDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Data.Sigma using (Σ≡Prop ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁)
open import Cubical.Relation.Binary.Base using (module BinaryRelation)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)
open import Cubical.Algebra.Group.Morphisms using (IsGroupHom)
open import Cubical.Algebra.Group.MorphismProperties
  using (makeIsGroupHom ; GroupHom≡)
open import Cubical.Algebra.AbGroup.Base
  using (AbGroup ; AbGroupStr ; AbGroupHom ; AbGroup→Group ; makeAbGroup)

------------------------------------------------------------------------
-- 1.  Orbit descent: the set-quotient half
------------------------------------------------------------------------

module Orbit {ℓg ℓx : Level} (G : Group ℓg) {X : Type ℓx}
    (_▸_    : ⟨ G ⟩ → X → X)
    (▸-id   : (x : X) → GroupStr.1g (snd G) ▸ x ≡ x)
    (▸-comp : (g h : ⟨ G ⟩) (x : X)
            → GroupStr._·_ (snd G) g h ▸ x ≡ g ▸ (h ▸ x))
  where

  private
    module 𝒢 = GroupStr (snd G)

  -- Two presentations are identified when a generated holonomy carries
  -- one to the other.  Raw relation: no setoid proof is needed to
  -- quotient by it.
  OrbitRel : X → X → Type (ℓ-max ℓg ℓx)
  OrbitRel x y = Σ[ g ∈ ⟨ G ⟩ ] (g ▸ x ≡ y)

  OrbitSet : Type (ℓ-max ℓg ℓx)
  OrbitSet = X / OrbitRel

  orbitMk : X → OrbitSet
  orbitMk = [_]

  isSetOrbitSet : isSet OrbitSet
  isSetOrbitSet = squash/

  -- The inverse holonomy undoes a generated holonomy (the only place
  -- the group laws are needed for descent).
  ▸-cancel : (g : ⟨ G ⟩) (x : X) → 𝒢.inv g ▸ (g ▸ x) ≡ x
  ▸-cancel g x =
    sym (▸-comp (𝒢.inv g) g x) ∙ cong (_▸ x) (𝒢.·InvL g) ∙ ▸-id x

  -- Path erasure: acting does not change the orbit (Lean: orbitMk_smul).
  orbitMk-▸ : (g : ⟨ G ⟩) (x : X) → orbitMk (g ▸ x) ≡ orbitMk x
  orbitMk-▸ g x = eq/ _ _ (𝒢.inv g , ▸-cancel g x)

  -- Descent data, for a set-valued task.
  module _ {ℓy : Level} {Y : Type ℓy} where

    Invariant : (X → Y) → Type (ℓ-max (ℓ-max ℓg ℓx) ℓy)
    Invariant task = (g : ⟨ G ⟩) (x : X) → task (g ▸ x) ≡ task x

    Factors : (X → Y) → Type (ℓ-max (ℓ-max ℓg ℓx) ℓy)
    Factors task = Σ[ d ∈ (OrbitSet → Y) ] ((x : X) → d (orbitMk x) ≡ task x)

    -- Lean: factors_through_orbit_iff, forward direction.
    factors→invariant : (task : X → Y) → Factors task → Invariant task
    factors→invariant task (d , comm) g x =
      sym (comm (g ▸ x)) ∙ cong d (orbitMk-▸ g x) ∙ comm x

    -- Lean: factors_through_orbit_iff, backward direction.  SQ.rec;
    -- the β-rule is refl (descend-β).
    descend : isSet Y → (task : X → Y) → Invariant task → OrbitSet → Y
    descend setY task tinv =
      SQ.rec setY task (λ x y r → sym (tinv (r .fst) x) ∙ cong task (r .snd))

    descend-β : (setY : isSet Y) (task : X → Y) (tinv : Invariant task)
        (x : X) → descend setY task tinv (orbitMk x) ≡ task x
    descend-β setY task tinv x = refl

    invariant→factors : isSet Y → (task : X → Y)
      → Invariant task → Factors task
    invariant→factors setY task tinv = descend setY task tinv , λ x → refl

    -- Lean: orbit_factor_unique, strengthened from ∃! to isContr of the
    -- full factorization data.
    descend-contr : (setY : isSet Y) (task : X → Y) → Invariant task
      → isContr (Factors task)
    descend-contr setY task tinv .fst = invariant→factors setY task tinv
    descend-contr setY task tinv .snd (d , comm) =
      Σ≡Prop (λ d' → isPropΠ (λ x → setY _ _))
        (funExt (SQ.elimProp (λ q → setY _ _) (λ x → sym (comm x))))

  -- Effectivity: OrbitRel is an equivalence relation (this is where the
  -- remaining group laws enter), so a path of orbits is exactly a mere
  -- holonomy witness.
  orbitRel-refl : (x : X) → OrbitRel x x
  orbitRel-refl x = 𝒢.1g , ▸-id x

  orbitRel-sym : (x y : X) → OrbitRel x y → OrbitRel y x
  orbitRel-sym x y (g , p) =
    𝒢.inv g , cong (𝒢.inv g ▸_) (sym p) ∙ ▸-cancel g x

  orbitRel-trans : (x y z : X) → OrbitRel x y → OrbitRel y z → OrbitRel x z
  orbitRel-trans x y z (g , p) (h , q) =
    (h 𝒢.· g) , ▸-comp h g x ∙ cong (h ▸_) p ∙ q

  orbitRelIsEquivRel : BinaryRelation.isEquivRel OrbitRel
  orbitRelIsEquivRel =
    BinaryRelation.equivRel orbitRel-refl orbitRel-sym orbitRel-trans

  orbitRel→path : {x y : X} → OrbitRel x y → orbitMk x ≡ orbitMk y
  orbitRel→path = eq/ _ _

  orbitPathTruncIso : (x y : X)
    → Iso (orbitMk x ≡ orbitMk y) ∥ OrbitRel x y ∥₁
  orbitPathTruncIso = SQ.isEquivRel→TruncIso orbitRelIsEquivRel

------------------------------------------------------------------------
-- 2.  Coinvariants: the additive half.  The HIT quotient by the raw
--     generator relation replaces Lean's AddSubgroup.closure entirely.
------------------------------------------------------------------------

module Coinvariants {ℓg ℓa : Level} (G : Group ℓg) (A : AbGroup ℓa)
    (_▸_   : ⟨ G ⟩ → ⟨ A ⟩ → ⟨ A ⟩)
    (▸-hom : (g : ⟨ G ⟩) (x y : ⟨ A ⟩)
           → g ▸ (AbGroupStr._+_ (snd A) x y)
             ≡ AbGroupStr._+_ (snd A) (g ▸ x) (g ▸ y))
  where

  open AbGroupStr (snd A)
    using (_+_ ; -_ ; _-_ ; 0g ; +Assoc ; +IdR ; +IdL ; +InvR ; +InvL ; +Comm)
  open GroupTheory (AbGroup→Group A)
    using (invInv ; invDistr ; invUniqueL ; idFromIdempotency)

  -- Additivity alone forces the action to preserve 0 and negation
  -- (Lean assumes both, inside DistribMulAction).
  ▸-0 : (g : ⟨ G ⟩) → g ▸ 0g ≡ 0g
  ▸-0 g = idFromIdempotency (g ▸ 0g)
            (cong (g ▸_) (sym (+IdR 0g)) ∙ ▸-hom g 0g 0g)

  ▸-neg : (g : ⟨ G ⟩) (x : ⟨ A ⟩) → g ▸ (- x) ≡ - (g ▸ x)
  ▸-neg g x = invUniqueL
    (sym (▸-hom g (- x) x) ∙ cong (g ▸_) (+InvL x) ∙ ▸-0 g)

  -- The raw generator relation: a and b differ by ONE holonomy
  -- difference.  Not transitive; the HIT quotient below generates the
  -- subgroup closure that Lean had to construct by hand.
  DiffRel : ⟨ A ⟩ → ⟨ A ⟩ → Type (ℓ-max ℓg ℓa)
  DiffRel a b = Σ[ g ∈ ⟨ G ⟩ ] Σ[ x ∈ ⟨ A ⟩ ] (a ≡ b + ((g ▸ x) - x))

  Coinv : Type (ℓ-max ℓg ℓa)
  Coinv = ⟨ A ⟩ / DiffRel

  coinvMk : ⟨ A ⟩ → Coinv
  coinvMk = [_]

  isSetCoinv : isSet Coinv
  isSetCoinv = squash/

  -- Path erasure, additively (Lean: coinvariantMk_smul).
  coinvMk-▸ : (g : ⟨ G ⟩) (x : ⟨ A ⟩) → coinvMk (g ▸ x) ≡ coinvMk x
  coinvMk-▸ g x = eq/ _ _ (g , x , sym absorb)
    where
    absorb : x + ((g ▸ x) - x) ≡ g ▸ x
    absorb = cong (x +_) (+Comm (g ▸ x) (- x))
           ∙ +Assoc x (- x) (g ▸ x)
           ∙ cong (_+ (g ▸ x)) (+InvR x)
           ∙ +IdL (g ▸ x)

  -- DiffRel is translation-invariant and negation-invariant; these
  -- three lemmas are the entire "closure" content of the Lean file.
  private
    exch : (u d v : ⟨ A ⟩) → (u + d) + v ≡ (u + v) + d
    exch u d v = sym (+Assoc u d v) ∙ cong (u +_) (+Comm d v) ∙ +Assoc u v d

    diff+L : (b : ⟨ A ⟩) {a a' : ⟨ A ⟩}
      → DiffRel a a' → DiffRel (a + b) (a' + b)
    diff+L b {a} {a'} (g , x , p) =
      g , x , cong (_+ b) p ∙ exch a' ((g ▸ x) - x) b

    diff+R : (a : ⟨ A ⟩) {b b' : ⟨ A ⟩}
      → DiffRel b b' → DiffRel (a + b) (a + b')
    diff+R a {b} {b'} (g , x , p) =
      g , x , cong (a +_) p ∙ +Assoc a b' ((g ▸ x) - x)

    diffNeg : {a b : ⟨ A ⟩} → DiffRel a b → DiffRel (- a) (- b)
    diffNeg {a} {b} (g , x , p) = g , (- x) , q
      where
      d : ⟨ A ⟩
      d = (g ▸ x) - x
      negd : - d ≡ (g ▸ (- x)) - (- x)
      negd = invDistr (g ▸ x) (- x)
           ∙ cong (_+ (- (g ▸ x))) (invInv x)
           ∙ +Comm x (- (g ▸ x))
           ∙ sym (cong₂ _+_ (▸-neg g x) (invInv x))
      q : - a ≡ (- b) + ((g ▸ (- x)) - (- x))
      q = cong (-_) p ∙ invDistr b d ∙ +Comm (- d) (- b)
        ∙ cong ((- b) +_) negd

  -- The abelian-group structure descends: SQ.rec2 needs exactly the
  -- translation invariance above, no closure lemma.
  0Q : Coinv
  0Q = [ 0g ]

  _+Q_ : Coinv → Coinv → Coinv
  _+Q_ = SQ.rec2 squash/ (λ a b → [ a + b ])
    (λ a a' b r → eq/ _ _ (diff+L b r))
    (λ a b b' r → eq/ _ _ (diff+R a r))

  -Q_ : Coinv → Coinv
  -Q_ = SQ.rec squash/ (λ a → [ - a ]) (λ a b r → eq/ _ _ (diffNeg r))

  +Q-β : (a b : ⟨ A ⟩) → coinvMk a +Q coinvMk b ≡ coinvMk (a + b)
  +Q-β a b = refl

  -- The group laws are inherited pointwise (Lean: instance resolution
  -- for QuotientAddGroup; here, three elimProps).
  CoinvAbGroup : AbGroup (ℓ-max ℓg ℓa)
  CoinvAbGroup = makeAbGroup 0Q _+Q_ -Q_ squash/
    (SQ.elimProp3 (λ _ _ _ → squash/ _ _) (λ a b c → cong [_] (+Assoc a b c)))
    (SQ.elimProp (λ _ → squash/ _ _) (λ a → cong [_] (+IdR a)))
    (SQ.elimProp (λ _ → squash/ _ _) (λ a → cong [_] (+InvR a)))
    (SQ.elimProp2 (λ _ _ → squash/ _ _) (λ a b → cong [_] (+Comm a b)))

  -- The projection is an additive map (Lean: coinvariantMk : A →+ …);
  -- here its homomorphism law is refl.
  coinvMkHom : AbGroupHom A CoinvAbGroup
  coinvMkHom .fst = coinvMk
  coinvMkHom .snd = makeIsGroupHom (λ a b → refl)

  ----------------------------------------------------------------------
  -- Universal property: additive tasks descend iff they kill every
  -- holonomy difference, uniquely.
  ----------------------------------------------------------------------

  module _ {ℓb : Level} (B : AbGroup ℓb) where

    private
      module 𝔹 = AbGroupStr (snd B)
      isSetB : isSet ⟨ B ⟩
      isSetB = 𝔹.is-set

    HomInvariant : AbGroupHom A B → Type (ℓ-max ℓg (ℓ-max ℓa ℓb))
    HomInvariant f = (g : ⟨ G ⟩) (x : ⟨ A ⟩) → f .fst (g ▸ x) ≡ f .fst x

    HomFactors : AbGroupHom A B → Type (ℓ-max ℓg (ℓ-max ℓa ℓb))
    HomFactors f = Σ[ d ∈ AbGroupHom CoinvAbGroup B ]
                     ((x : ⟨ A ⟩) → d .fst (coinvMk x) ≡ f .fst x)

    -- Lean: addHom_factors_through_coinvariants_iff, forward.
    homFactors→invariant : (f : AbGroupHom A B)
      → HomFactors f → HomInvariant f
    homFactors→invariant f (d , comm) g x =
      sym (comm (g ▸ x)) ∙ cong (d .fst) (coinvMk-▸ g x) ∙ comm x

    -- An invariant additive map kills each generator — this single
    -- computation replaces Lean's closure_le-into-ker argument.
    private
      kills : (f : AbGroupHom A B) → HomInvariant f
        → (a b : ⟨ A ⟩) → DiffRel a b → f .fst a ≡ f .fst b
      kills f finv a b (g , x , p) =
          cong (f .fst) p
        ∙ pres· b ((g ▸ x) - x)
        ∙ cong (𝔹._+_ (f .fst b))
            ( pres· (g ▸ x) (- x)
            ∙ cong₂ 𝔹._+_ (finv g x) (presinv x)
            ∙ 𝔹.+InvR (f .fst x))
        ∙ 𝔹.+IdR (f .fst b)
        where open IsGroupHom (f .snd)

    -- Lean: addHom_factors_through_coinvariants_iff, backward
    -- (QuotientAddGroup.lift → SQ.rec; the β-rule is refl).
    descendHom : (f : AbGroupHom A B) → HomInvariant f
      → AbGroupHom CoinvAbGroup B
    descendHom f finv .fst = SQ.rec isSetB (f .fst) (kills f finv)
    descendHom f finv .snd = makeIsGroupHom
      (SQ.elimProp2 (λ _ _ → isSetB _ _) (IsGroupHom.pres· (f .snd)))

    descendHom-β : (f : AbGroupHom A B) (finv : HomInvariant f) (a : ⟨ A ⟩)
      → descendHom f finv .fst (coinvMk a) ≡ f .fst a
    descendHom-β f finv a = refl

    invariant→homFactors : (f : AbGroupHom A B)
      → HomInvariant f → HomFactors f
    invariant→homFactors f finv = descendHom f finv , λ x → refl

    -- Lean: coinvariant_factor_unique (addMonoidHom_ext → SQ.elimProp),
    -- strengthened from ∃! to isContr of the factorization data.
    descendHom-contr : (f : AbGroupHom A B) → HomInvariant f
      → isContr (HomFactors f)
    descendHom-contr f finv .fst = invariant→homFactors f finv
    descendHom-contr f finv .snd (d , comm) =
      Σ≡Prop (λ d' → isPropΠ (λ x → isSetB _ _))
        (GroupHom≡ (funExt (SQ.elimProp (λ q → isSetB _ _)
                                        (λ x → sym (comm x)))))

    -- The universal property as a reversible machine interface.  A
    -- factorisation program and a holonomy-invariance certificate contain
    -- exactly the same information: each side is proposition-valued, while
    -- invariant→homFactors constructs the unique executable factor.
    isPropHomInvariant : (f : AbGroupHom A B) → isProp (HomInvariant f)
    isPropHomInvariant f = isPropΠ (λ g → isPropΠ (λ x → isSetB _ _))

    isPropHomFactors : (f : AbGroupHom A B) → isProp (HomFactors f)
    isPropHomFactors f h₀ h₁ =
      isContr→isProp
        (descendHom-contr f (homFactors→invariant f h₀)) h₀ h₁

    homFactorsIsoInvariant : (f : AbGroupHom A B)
      → Iso (HomFactors f) (HomInvariant f)
    Iso.fun (homFactorsIsoInvariant f) = homFactors→invariant f
    Iso.inv (homFactorsIsoInvariant f) = invariant→homFactors f
    Iso.rightInv (homFactorsIsoInvariant f) finv =
      isPropHomInvariant f _ _
    Iso.leftInv (homFactorsIsoInvariant f) hfac =
      isPropHomFactors f _ _

    -- Representative independence.  A quotient path is enough to replay a
    -- lawful additive task; no section or sampled representative is part of
    -- the executable interface.
    coinvPath→homPath : (f : AbGroupHom A B) → HomInvariant f
      → {a b : ⟨ A ⟩} → coinvMk a ≡ coinvMk b
      → f .fst a ≡ f .fst b
    coinvPath→homPath f finv {a} {b} p =
        sym (descendHom-β f finv a)
      ∙ cong (descendHom f finv .fst) p
      ∙ descendHom-β f finv b
