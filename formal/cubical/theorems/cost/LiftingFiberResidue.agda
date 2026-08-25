{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LiftingFiberResidue
--
-- A constructive audit of `notes/OPTIMIZATION_THROUGH_FORGETTING.md` §1.
--
-- THE SENTENCE UNDER AUDIT.  That note fixes a forgetful functor
-- `U : C -> D`, relaxed candidates `p` downstairs, and defines the exact
-- residual of `p` to be the lifting fibre
--
--     Lift_U(p) = { f in F_C(A,B) : U(f) = p }.
--
-- It then states two things.  First (call it TRANSPORT):
--
--     "If `p` is Pareto-optimal downstairs, then every element of
--      Lift_U(p) is Pareto-optimal upstairs."
--
-- Second (call it VALIDITY):
--
--     "optimize then lift is valid at p  <=>  Lift_U(p) /= empty."
--
-- and its §5 step 4 says what "valid" is for: "transport the optimum
-- WITH ITS WITNESS".
--
-- THE OBJECTION.  `Lift_U(p) /= empty` is `¬ ¬ Lift_U(p)`.  Step 4 needs
-- an element.  Between them sits `∥ Lift_U(p) ∥₁`.  The note writes one
-- symbol for three different types, which is harmless classically and is
-- not harmless here: this repository's substrate is `--cubical --safe`,
-- where the three are genuinely different and the difference is exactly
-- what step 4 consumes.
--
-- WHAT IS PROVED HERE.  The note's sentence splits into a strong true
-- part and a residue that is a logical principle nobody declared.
--
--   §2  TRANSPORT is constructive and hypothesis-free.  `paretoLift`
--       needs no truncation, no decidability, no h-level assumption, no
--       faithfulness, and no univalence.  It is true of EVERY element of
--       the fibre, exactly as the note says.  This is the strong part and
--       it survives intact.
--
--   §3  The residue at the level of WITNESSES.  For `A` and `B` sets,
--       `witness = fst : LiftFib U p → A` factors through
--       `∥ LiftFib U p ∥₁` IF AND ONLY IF the lift is unique
--       (`factors↔isProp`).  So the compression "replace the fibre by
--       mere inhabitation" is sound for asserting validity and unsound
--       for performing step 4, with the exact boundary being uniqueness
--       of the lift — not a weakening one may take and repay later.
--
--   §4  The residue at the level of LOGIC.  Read at the generality the
--       note states it, VALIDITY is the schema
--
--         LiftDNS : for all sets A,B, all U : A → B and all p,
--                   ¬ ¬ LiftFib U p → ∥ LiftFib U p ∥₁
--
--       and `liftDNS→LEM` shows this schema IMPLIES excluded middle for
--       propositions (`lem→liftDNS` gives the converse, so it IS
--       excluded middle).  The mechanism is `everySetIsAFibre`: every
--       set is, up to equivalence, a lifting fibre of a map between
--       sets, so the schema cannot be weaker than unrestricted
--       double-negation shift.  The note's biconditional is therefore
--       not an oversight of notation; at its stated generality it is a
--       classical axiom.
--
--   §5  Where the note already contains its own repair, attached to the
--       wrong sentence.  Two paragraphs below VALIDITY it says "For
--       discrete feasible candidate sets, ...".  `decLiftFib` shows that
--       hypothesis is exactly what VALIDITY needs: given an ENUMERATION
--       `A ≃ Fin n` and `Discrete B`, the fibre is decidable WITH
--       WITNESS, so all of `LiftFib`, `∥ LiftFib ∥₁` and `¬ ¬ LiftFib`
--       coincide (`collapse`) and step 4 goes through.
--
-- WHAT IS DELIBERATELY NOT CLAIMED.
--
--  * Nothing here refutes `¬ ¬ X → ∥ X ∥₁`.  It is independent, not
--    false; §4 measures its strength, it does not contradict it.  In
--    particular no module here proves any negation of a classical
--    principle, and none could under `--safe` without postulates.
--
--  * §5 uses a GIVEN enumeration `A ≃ Fin n`, which is structure.  Mere
--    finiteness `∥ A ≃ Fin n ∥₁` is NOT claimed to suffice and I do not
--    believe it does: the search that produces the witness runs along a
--    chosen enumeration.  (Contrast `LinearOrderFinite`,
--    where mere totality DOES suffice because the target `Dec (x ≤ y)`
--    is a proposition.  The target here, an element of `A`, is not.)
--
--  * The equivalence in §4 is with excluded middle for PROPOSITIONS, at
--    one universe level.  No choice principle is analysed.
--
--  * MY LEAST-SURE STEP, and it is not formalised here.  §4 quantifies
--    over arbitrary maps `U : A → B` between sets, whereas the note
--    quantifies over the hom-action of a forgetful FUNCTOR.  I claim
--    these coincide, by the following construction, which is argued in
--    prose and NOT checked: let `C` have objects `{a,b}` with
--    `Hom(a,b) = Dec P`, `Hom(b,a) = ⊥`, and only identities otherwise;
--    let `D` be the same with `Hom(a,b) = Unit*`; let `U` be the
--    identity on objects and the constant map on homs.  Composition
--    never pairs two non-identity arrows, so both are categories and `U`
--    is a functor.  If that construction is wrong, §4 degrades from "the
--    note's sentence IS excluded middle" to "the sentence as I have
--    generalised it is", and §3 and §5 are untouched.  This is the step
--    to attack.
--
--  * `¬ ¬ X → ∥ X ∥₁ ⟺ LEM` is standard folklore in univalent
--    foundations (CITED; web search "HoTT double negation propositional
--    truncation equivalent to law of excluded middle" — the two are
--    routinely observed to coincide only classically, e.g. the nLab
--    discussion of double-negation as an approximation to truncation).
--    The content claimed as new is the AUDIT: §3's uniqueness boundary,
--    §4's `everySetIsAFibre` reduction pinning the note's own sentence
--    to that principle, and §5's identification of the repair already
--    present in the note.
--
--  * This module imports no other module of this repository and is
--    imported by none; it modifies nothing.  It is a sibling top-level
--    module in the style of `ProjectionChargeAudit.agda`, deliberately
--    NOT added to `agda`.
------------------------------------------------------------------------

module LiftingFiberResidue where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.SumFin using (Fin)
open import Cubical.HITs.PropositionalTruncation as Prop
  using (∥_∥₁ ; ∣_∣₁ ; squash₁ ; isPropPropTrunc)
open import Cubical.Relation.Nullary

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1.  The lifting fibre.
------------------------------------------------------------------------

-- `U` forgets structure; `LiftFib U p` is the note's `Lift_U(p)`, kept
-- proof-relevant.  Its ELEMENTS are what §5 step 4 transports.
LiftFib : {A : Type ℓ} {B : Type ℓ'} (U : A → B) (p : B) → Type (ℓ-max ℓ ℓ')
LiftFib {A = A} U p = Σ[ f ∈ A ] (U f ≡ p)

-- The transport map of §5 step 4.
witness : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B} → LiftFib U p → A
witness = fst

------------------------------------------------------------------------
-- 2.  TRANSPORT: constructive, hypothesis-free.  The strong true part.
------------------------------------------------------------------------

-- Costs live downstairs in `C` with a strict domination relation, and
-- forgetting preserves cost exactly (the note's `c_C(f) = c_D(Uf)`), so
-- the upstairs cost of `f` is by definition `c (U f)`.
module Pareto {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''}
              (U : A → B) (c : B → C) (_≺_ : C → C → Type ℓ'') where

  -- "no relaxed candidate strictly dominates p"
  MinD : B → Type (ℓ-max ℓ' ℓ'')
  MinD p = (q : B) → c q ≺ c p → ⊥

  -- "no structured candidate strictly dominates f"
  MinC : A → Type (ℓ-max ℓ ℓ'')
  MinC f = (g : A) → c (U g) ≺ c (U f) → ⊥

  -- THE NOTE'S TRANSPORT SENTENCE, VERBATIM AND CONSTRUCTIVE:
  -- every element of the fibre over a downstairs optimum is an upstairs
  -- optimum.  An upstairs dominator forgets to a downstairs dominator.
  --
  -- Note what is absent: no truncation, no `Dec`, no `isSet`, no
  -- faithfulness of `U`, no univalence.  This half of §1 needed none of
  -- the apparatus the other half turns out to need.
  paretoLift : (p : B) → MinD p → (l : LiftFib U p) → MinC (witness l)
  paretoLift p min (f , q) g d = min (U g) (subst (λ z → c (U g) ≺ z) (cong c q) d)

  -- Consequently mere validity does give a mere upstairs optimum: the
  -- statement "some structured candidate is optimal" is a proposition
  -- once truncated, and truncation is functorial.  This is the most that
  -- `∥ · ∥₁` can deliver, and §3 says it is strictly less than step 4.
  paretoLift∥ : (p : B) → MinD p → ∥ LiftFib U p ∥₁ → ∥ Σ[ f ∈ A ] MinC f ∥₁
  paretoLift∥ p min = Prop.map (λ l → witness l , paretoLift p min l)

------------------------------------------------------------------------
-- 3.  The residue at the level of witnesses: truncation ⟺ uniqueness.
------------------------------------------------------------------------

-- "`h` factors through mere inhabitation", with the factorisation
-- required to compute correctly on witnesses.  This is precisely what
-- step 4 would need if the fibre had been compressed to `∥ · ∥₁`.
FactorsThroughTrunc : {X : Type ℓ} {Y : Type ℓ'} (h : X → Y) → Type (ℓ-max ℓ ℓ')
FactorsThroughTrunc {X = X} {Y = Y} h = Σ[ g ∈ (∥ X ∥₁ → Y) ] ((x : X) → g ∣ x ∣₁ ≡ h x)

-- Any factorisation forces weak constancy.  Constructive, no hypotheses:
-- ALL elements of `∥ X ∥₁` are equal, so `g` cannot tell witnesses apart.
factors→2Const : {X : Type ℓ} {Y : Type ℓ'} {h : X → Y}
               → FactorsThroughTrunc h → 2-Constant h
factors→2Const (g , β) x y =
  sym (β x) ∙ cong g (squash₁ ∣ x ∣₁ ∣ y ∣₁) ∙ β y

-- Converse, for `Y` a set: Kraus' factorisation of weakly constant maps.
-- (`rec→Set` is the library's; it is not reproved here.)
2Const→factors : {X : Type ℓ} {Y : Type ℓ'} {h : X → Y}
               → isSet Y → 2-Constant h → FactorsThroughTrunc h
2Const→factors {h = h} isSetY k = Prop.rec→Set isSetY h k , λ _ → refl

-- Weak constancy of `witness` IS uniqueness of the lift, when `B` is a
-- set (so that `U f ≡ p` is a proposition and the fibre is a Σ over a
-- subsingleton family).
2Const-witness→isProp : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B}
                      → isSet B
                      → 2-Constant (witness {U = U} {p = p})
                      → isProp (LiftFib U p)
2Const-witness→isProp isSetB k l m = Σ≡Prop (λ f → isSetB _ _) (k l m)

isProp→2Const-witness : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B}
                      → isProp (LiftFib U p)
                      → 2-Constant (witness {U = U} {p = p})
isProp→2Const-witness ip l m = cong witness (ip l m)

-- THE BOUNDARY.  For `A`, `B` sets: the witness map of a lifting fibre
-- factors through mere validity exactly when the lift is unique.
--
-- Read as a prohibition: if a relaxed optimum `p` admits two distinct
-- structured lifts, then NO function on `∥ Lift_U(p) ∥₁` performs step 4.
-- Truncating the fibre keeps the note's VALIDITY sentence and destroys
-- the note's own step 4.  This is the compression that is unsound as a
-- reusable move, stated exactly.
factors→isProp : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B}
               → isSet B
               → FactorsThroughTrunc (witness {U = U} {p = p})
               → isProp (LiftFib U p)
factors→isProp isSetB = 2Const-witness→isProp isSetB ∘ factors→2Const

isProp→factors : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B}
               → isSet A
               → isProp (LiftFib U p)
               → FactorsThroughTrunc (witness {U = U} {p = p})
isProp→factors isSetA ip = 2Const→factors isSetA (isProp→2Const-witness ip)

-- The two halves, packaged.  For hom-SETS upstairs and downstairs:
--     step 4 survives truncation  ⟺  the lift is unique.
factors↔isProp : {A : Type ℓ} {B : Type ℓ'} {U : A → B} {p : B}
               → isSet A → isSet B
               → (FactorsThroughTrunc (witness {U = U} {p = p}) → isProp (LiftFib U p))
               × (isProp (LiftFib U p) → FactorsThroughTrunc (witness {U = U} {p = p}))
factors↔isProp isSetA isSetB = factors→isProp isSetB , isProp→factors isSetA

-- A concrete instance of the prohibition: `U : Bool-like → Unit` has a
-- two-element fibre, so its witness map admits no factorisation.
-- (Stated over an arbitrary type with two provably distinct points, so
-- that no `Bool` machinery is needed.)
noFactorOnTwoPoints :
    {A : Type ℓ} (a₀ a₁ : A) → (a₀ ≡ a₁ → ⊥)
  → FactorsThroughTrunc (witness {A = A} {B = Unit* {ℓ}} {U = λ _ → tt*} {p = tt*})
  → ⊥
noFactorOnTwoPoints a₀ a₁ ne fac =
  ne (factors→2Const fac (a₀ , refl) (a₁ , refl))

------------------------------------------------------------------------
-- 4.  The residue at the level of logic: VALIDITY is excluded middle.
------------------------------------------------------------------------

-- Excluded middle for propositions, at one level.
LEM : (ℓ : Level) → Type (ℓ-suc ℓ)
LEM ℓ = (P : Type ℓ) → isProp P → Dec P

-- The note's biconditional, read constructively and at the generality it
-- is stated: "the fibre is nonempty" gives "the fibre is inhabited",
-- uniformly in the forgetful map.  Restricted to SETS, which is the only
-- case the note is about (hom-sets of feasible morphisms).
LiftDNS : (ℓ : Level) → Type (ℓ-suc ℓ)
LiftDNS ℓ = {A B : Type ℓ} → isSet A → isSet B → (U : A → B) (p : B)
          → ((LiftFib U p → ⊥) → ⊥) → ∥ LiftFib U p ∥₁

-- Every type is a lifting fibre: forget everything.  `Σ[ x ∈ X ] (tt* ≡ tt*)`
-- has contractible second component, so the fibre IS `X`.
everySetIsAFibre : (X : Type ℓ) → LiftFib {A = X} {B = Unit* {ℓ}} (λ _ → tt*) tt* ≃ X
everySetIsAFibre X =
  Σ-contractSnd (λ _ → isProp→isContrPath isPropUnit* tt* tt*)

-- `Dec P` is a set when `P` is a proposition, and is irrefutable.
private
  ¬¬Dec : {P : Type ℓ} → (Dec P → ⊥) → ⊥
  ¬¬Dec k = k (no (λ p → k (yes p)))

-- THE REDUCTION.  The note's VALIDITY sentence, at its stated
-- generality, implies excluded middle.
--
-- Take the feasible structured candidates to be `Dec P` and forget
-- everything: the relaxed problem is trivial, so `p = tt*` is vacuously
-- Pareto-optimal and its fibre is irrefutable.  VALIDITY hands back a
-- mere decision, which is a proposition, so it untruncates.  Nothing
-- about optimisation is used — which is the point: the sentence is
-- carrying a logical principle, not a fact about forgetting.
liftDNS→LEM : LiftDNS ℓ → LEM ℓ
liftDNS→LEM {ℓ = ℓ} dns P isPropP =
  Prop.rec (isPropDec isPropP) (idfun _) merelyDec
  where
    A : Type ℓ
    A = Dec P

    isSetA : isSet A
    isSetA = isProp→isSet (isPropDec isPropP)

    e : LiftFib {A = A} {B = Unit* {ℓ}} (λ _ → tt*) tt* ≃ A
    e = everySetIsAFibre A

    ¬¬fib : ((LiftFib {A = A} {B = Unit* {ℓ}} (λ _ → tt*) tt* → ⊥) → ⊥)
    ¬¬fib k = ¬¬Dec {P = P} (λ d → k (invEq e d))

    merelyDec : ∥ A ∥₁
    merelyDec = Prop.map (equivFun e) (dns isSetA isSetUnit* (λ _ → tt*) tt* ¬¬fib)

-- Converse: excluded middle does prove VALIDITY, so the two are
-- equivalent and §4 has located the principle exactly, not merely a
-- lower bound.  (Decide `∥ fibre ∥₁`, which is a proposition.)
lem→liftDNS : LEM ℓ → LiftDNS ℓ
lem→liftDNS lem {A = A} {B = B} _ _ U p nn =
  decide (lem ∥ LiftFib U p ∥₁ isPropPropTrunc)
  where
    decide : Dec ∥ LiftFib U p ∥₁ → ∥ LiftFib U p ∥₁
    decide (yes t) = t
    decide (no ¬t) = Empty.rec (nn (λ l → ¬t ∣ l ∣₁))

------------------------------------------------------------------------
-- 5.  The repair the note already contains, attached to its own sentence.
------------------------------------------------------------------------

-- Bounded search: a decidable predicate on a standard finite type is
-- decidable as a Σ, WITH the witness.  This is the constructive content
-- of "for discrete feasible candidate sets".
searchFin : (n : ℕ) (Q : Fin n → Type ℓ)
          → ((k : Fin n) → Dec (Q k)) → Dec (Σ[ k ∈ Fin n ] Q k)
searchFin zero    Q dq = no (λ z → Empty.rec (fst z))
searchFin (suc n) Q dq = step (dq (inl tt)) (searchFin n (λ k → Q (inr k)) (λ k → dq (inr k)))
  where
    step : Dec (Q (inl tt)) → Dec (Σ[ k ∈ Fin n ] Q (inr k)) → Dec (Σ[ k ∈ Fin (suc n) ] Q k)
    step (yes q) _         = yes (inl tt , q)
    step (no _) (yes (k , q)) = yes (inr k , q)
    step (no ¬q) (no ¬r)   = no neither
      where
        neither : Σ[ k ∈ Fin (suc n) ] Q k → ⊥
        neither (inl tt , q) = ¬q q
        neither (inr k  , q) = ¬r (k , q)

-- With an ENUMERATION of the structured candidates and a discrete
-- relaxed target, the lifting fibre is decidable — and `yes` carries the
-- lift itself, which is what §5 step 4 consumes.
decLiftFib : {A : Type ℓ} {B : Type ℓ'} (n : ℕ) (enum : A ≃ Fin n)
           → Discrete B → (U : A → B) (p : B) → Dec (LiftFib U p)
decLiftFib {A = A} {B = B} n enum dB U p =
  EquivPresDec (invEquiv reindex)
    (searchFin n (λ k → U (invEq enum k) ≡ p) (λ k → dB (U (invEq enum k)) p))
  where
    reindex : LiftFib U p ≃ (Σ[ k ∈ Fin n ] (U (invEq enum k) ≡ p))
    reindex =
      Σ-cong-equiv enum
        (λ a → pathToEquiv (cong (λ z → U z ≡ p) (sym (retEq enum a))))

-- Under that hypothesis all four readings of the note's `Lift_U(p) /= ∅`
-- coincide, and VALIDITY is a theorem rather than an axiom.
collapse : {A : Type ℓ} {B : Type ℓ'} (n : ℕ) (enum : A ≃ Fin n)
         → Discrete B → (U : A → B) (p : B)
         → ((LiftFib U p → ⊥) → ⊥) → LiftFib U p
collapse n enum dB U p nn = go (decLiftFib n enum dB U p)
  where
    go : Dec (LiftFib U p) → LiftFib U p
    go (yes l) = l
    go (no ¬l) = Empty.rec (nn ¬l)

-- and therefore step 4 runs: the transported optimum, with its witness.
collapseParetoLift :
    {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''}
    (n : ℕ) (enum : A ≃ Fin n) (dB : Discrete B)
    (U : A → B) (c : B → C) (_≺_ : C → C → Type ℓ'') (p : B)
  → Pareto.MinD U c _≺_ p
  → ((LiftFib U p → ⊥) → ⊥)
  → Σ[ f ∈ A ] Pareto.MinC U c _≺_ f
collapseParetoLift n enum dB U c _≺_ p min nn =
  let l = collapse n enum dB U p nn
  in witness l , Pareto.paretoLift U c _≺_ p min l
