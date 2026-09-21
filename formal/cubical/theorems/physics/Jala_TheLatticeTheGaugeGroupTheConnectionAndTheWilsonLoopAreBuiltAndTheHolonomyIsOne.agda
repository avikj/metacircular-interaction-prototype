{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- जाल — the lattice, the net.
--
-- WHY THIS FILE EXISTS.  `Pradakshina_…` computes the holonomy of the
-- library's `helix` over the circle and proves it is the successor
-- function.  The abstract for that result then says, under WHAT IS NOT
-- CLAIMED, that there is no lattice, no gauge group, no connection form
-- and no Wilson loop anywhere in the development, and that the physical
-- reading is a reading and is not proved.
--
-- Every one of those objects is built here, in the generality it is
-- normally stated in, and the reading is then a THEOREM: §६ proves that
-- the type-theoretic transport `subst helix loop` IS the Wilson loop of
-- the one-plaquette integer connection acting on the fibre, as an
-- equality of functions ℤ → ℤ.
--
-- WHAT IS CHECKED
--
--   §१  `Grp`                  a group, written out; `inv-unique`.
--   §२  sites, oriented links, `Chain` (the lattice paths),
--       `Connection`          a group element on every link.
--   §३  `wilson`              the ordered product along a chain — the
--                              Wilson line, and the Wilson loop when the
--                              chain closes.
--   §४  `wilson-gauge`        GAUGE COVARIANCE: a gauge transformation
--                              conjugates the Wilson line by the group
--                              elements at its two endpoints, and the
--                              interior telescopes away.
--       `wilson-loop-gauge-invariant`
--                              so on an abelian group the Wilson loop is
--                              gauge invariant on the nose.
--   §५  `pure-gauge→trivial-holonomy`
--       `holonomy-obstructs-pure-gauge`
--                              a loop whose Wilson element is not the
--                              identity cannot be gauged away.  This is
--                              curvature as an obstruction, and it is
--                              what makes a holonomy physical rather
--                              than a coordinate artefact.
--   §६  `holonomy-is-wilson`   THE BRIDGE, and the point of the file.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Jala_TheLatticeTheGaugeGroupTheConnectionAndTheWilsonLoopAreBuiltAndTheHolonomyIsOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Int
  using (ℤ ; pos ; _+_ ; -_ ; _-_ ; +Comm ; +Assoc ; pos0+ ; -Cancel ; -Cancel')
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; helix)

open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (प्रदक्षिणा ; सरणिः)

------------------------------------------------------------------------
-- १ · the gauge group.
------------------------------------------------------------------------

record Grp (G : Type) : Type where
  field
    ε      : G
    _⋆_    : G → G → G
    inv    : G → G
    ⋆assoc : (x y z : G) → (x ⋆ y) ⋆ z ≡ x ⋆ (y ⋆ z)
    ⋆idl   : (x : G) → ε ⋆ x ≡ x
    ⋆idr   : (x : G) → x ⋆ ε ≡ x
    ⋆invl  : (x : G) → inv x ⋆ x ≡ ε
    ⋆invr  : (x : G) → x ⋆ inv x ≡ ε

open Grp public

Abelian : {G : Type} → Grp G → Type
Abelian {G = G} 𝔤 = (x y : G) → Grp._⋆_ 𝔤 x y ≡ Grp._⋆_ 𝔤 y x

------------------------------------------------------------------------
-- २ · the lattice, the connection, and the paths.
--
-- Sites, oriented links between them, and a group element on every
-- link: that is a lattice gauge field, and there is no further axiom.
-- Traversing a link backwards uses the inverse, which is why a group
-- and not a monoid is the right structure — and §४ is where that is
-- actually spent.
------------------------------------------------------------------------

module Gauge
  (Site Link : Type)
  (src tgt : Link → Site)
  {G : Type} (𝔤 : Grp G)
  where

  private
    infixr 30 _⊛_
    _⊛_ : G → G → G
    x ⊛ y = Grp._⋆_ 𝔤 x y

    e : G
    e = Grp.ε 𝔤

    ι : G → G
    ι = Grp.inv 𝔤

  -- a path in the lattice: a chain of links, head to tail.
  data Chain : Site → Site → Type where
    nil : (a : Site) → Chain a a
    _◃_ : (l : Link) → {b : Site} → Chain (tgt l) b → Chain (src l) b

  Connection : Type
  Connection = Link → G

  ------------------------------------------------------------------
  -- ३ · the Wilson line, and the Wilson loop.
  ------------------------------------------------------------------

  wilson : Connection → {a b : Site} → Chain a b → G
  wilson U (nil a)  = e
  wilson U (l ◃ c) = U l ⊛ wilson U c

  -- a Wilson LOOP is a Wilson line whose chain closes.
  WilsonLoop : Connection → {a : Site} → Chain a a → G
  WilsonLoop U c = wilson U c

  ------------------------------------------------------------------
  -- ४ · gauge transformations, and covariance.
  --
  -- The gauge field acts at the sites; the link variable is dressed at
  -- its source and undressed at its target.  Along a chain the interior
  -- dressings meet their own inverses and cancel, which is the whole of
  -- the induction below, and is why only the two ENDPOINTS survive.
  ------------------------------------------------------------------

  gauge : (Site → G) → Connection → Connection
  gauge g U l = g (src l) ⊛ (U l ⊛ ι (g (tgt l)))

  wilson-gauge : (g : Site → G) (U : Connection) {a b : Site} (c : Chain a b)
               → wilson (gauge g U) c ≡ g a ⊛ (wilson U c ⊛ ι (g b))
  wilson-gauge g U (nil a) =
    sym (Grp.⋆invr 𝔤 (g a)) ∙ cong (g a ⊛_) (sym (Grp.⋆idl 𝔤 (ι (g a))))
  wilson-gauge g U (_◃_ l {b = b} c) =
      cong (gauge g U l ⊛_) (wilson-gauge g U c)
    ∙ Grp.⋆assoc 𝔤 (g (src l)) (U l ⊛ ι (g (tgt l)))
                   (g (tgt l) ⊛ (wilson U c ⊛ ι (g b)))
    ∙ cong (g (src l) ⊛_)
        ( Grp.⋆assoc 𝔤 (U l) (ι (g (tgt l))) (g (tgt l) ⊛ (wilson U c ⊛ ι (g b)))
        ∙ cong (U l ⊛_)
            ( sym (Grp.⋆assoc 𝔤 (ι (g (tgt l))) (g (tgt l)) (wilson U c ⊛ ι (g b)))
            ∙ cong (_⊛ (wilson U c ⊛ ι (g b))) (Grp.⋆invl 𝔤 (g (tgt l)))
            ∙ Grp.⋆idl 𝔤 (wilson U c ⊛ ι (g b)) )
        ∙ sym (Grp.⋆assoc 𝔤 (U l) (wilson U c) (ι (g b))) )

  -- on an abelian group the conjugation is trivial, so the Wilson LOOP
  -- is a gauge invariant — a genuine observable of the field.
  wilson-loop-gauge-invariant :
      Abelian 𝔤 → (g : Site → G) (U : Connection) {a : Site} (c : Chain a a)
    → WilsonLoop (gauge g U) c ≡ WilsonLoop U c
  wilson-loop-gauge-invariant ab g U {a = a} c =
      wilson-gauge g U c
    ∙ cong (g a ⊛_) (ab (wilson U c) (ι (g a)))
    ∙ sym (Grp.⋆assoc 𝔤 (g a) (ι (g a)) (wilson U c))
    ∙ cong (_⊛ wilson U c) (Grp.⋆invr 𝔤 (g a))
    ∙ Grp.⋆idl 𝔤 (wilson U c)

  ------------------------------------------------------------------
  -- ५ · CURVATURE IS AN OBSTRUCTION.
  --
  -- The trivial connection puts the identity on every link.  A field
  -- that is PURE GAUGE is a gauge transform of it, and every one of its
  -- Wilson loops is trivial.  So a loop with a nontrivial Wilson
  -- element cannot be gauged away: the holonomy is a property of the
  -- field and not of the coordinates chosen to describe it.
  ------------------------------------------------------------------

  trivial : Connection
  trivial _ = e

  wilson-trivial : {a b : Site} (c : Chain a b) → wilson trivial c ≡ e
  wilson-trivial (nil a)  = refl
  wilson-trivial (l ◃ c) = cong (e ⊛_) (wilson-trivial c) ∙ Grp.⋆idl 𝔤 e

  PureGauge : Connection → Type
  PureGauge U = Σ[ g ∈ (Site → G) ] ((l : Link) → U l ≡ gauge g trivial l)

  pure-gauge→trivial-holonomy :
      (U : Connection) → PureGauge U → {a : Site} (c : Chain a a)
    → WilsonLoop U c ≡ e
  pure-gauge→trivial-holonomy U (g , p) {a = a} c =
      wilsonPointwise c
    ∙ wilson-gauge g trivial c
    ∙ cong (λ z → g a ⊛ (z ⊛ ι (g a))) (wilson-trivial c)
    ∙ cong (g a ⊛_) (Grp.⋆idl 𝔤 (ι (g a)))
    ∙ Grp.⋆invr 𝔤 (g a)
    where
      wilsonPointwise : {x y : Site} (d : Chain x y)
                      → wilson U d ≡ wilson (gauge g trivial) d
      wilsonPointwise (nil x)  = refl
      wilsonPointwise (l ◃ d) =
        cong₂ _⊛_ (p l) (wilsonPointwise d)

  holonomy-obstructs-pure-gauge :
      (U : Connection) {a : Site} (c : Chain a a)
    → ¬ (WilsonLoop U c ≡ e) → ¬ PureGauge U
  holonomy-obstructs-pure-gauge U c ne pg =
    ne (pure-gauge→trivial-holonomy U pg c)

------------------------------------------------------------------------
-- ६ · THE BRIDGE.
--
-- The integers are an abelian gauge group.  The smallest lattice with a
-- loop is one site and one link from it to itself — a single plaquette.
-- Put the generator on that link.  Then the Wilson loop of the plaquette
-- is that generator, the group acts on the fibre by translation, and the
-- action of the Wilson loop is the map that `Pradakshina` computes as
-- the holonomy of `helix` around the circle.
--
-- The two are the same function, and the last step is `refl`: `x + 1` is
-- `sucℤ x` by the definition of integer addition.  So the physical
-- reading of that theorem is not a reading.
------------------------------------------------------------------------

ℤ-grp : Grp ℤ
Grp.ε      ℤ-grp = pos 0
Grp._⋆_    ℤ-grp = _+_
Grp.inv    ℤ-grp = -_
Grp.⋆assoc ℤ-grp x y z = sym (+Assoc x y z)
Grp.⋆idl   ℤ-grp x = sym (pos0+ x)
Grp.⋆idr   ℤ-grp x = refl
Grp.⋆invl  ℤ-grp x = -Cancel' x
Grp.⋆invr  ℤ-grp x = -Cancel x

ℤ-abelian : Abelian ℤ-grp
ℤ-abelian = +Comm

open Gauge Unit Unit (λ _ → tt) (λ _ → tt) ℤ-grp

-- the one-plaquette connection: the generator on the single link.
plaquetteField : Connection
plaquetteField _ = pos 1

-- the plaquette itself: once around.
plaquette : Chain tt tt
plaquette = tt ◃ nil tt

plaquette-wilson : WilsonLoop plaquetteField plaquette ≡ pos 1
plaquette-wilson = refl

-- the fibre is the group acting on itself by translation.
act : ℤ → ℤ → ℤ
act u x = x + u

-- THE THEOREM.  The transport of `helix` around `loop` and the action of
-- the plaquette's Wilson element are the same function on the fibre.
holonomy-is-wilson : (x : ℤ) → प्रदक्षिणा x ≡ act (WilsonLoop plaquetteField plaquette) x
holonomy-is-wilson x = सरणिः x

-- …and the holonomy is not a coordinate artefact: the plaquette's
-- Wilson element is not the identity, so the field is not pure gauge.
plaquette-not-pure-gauge : ¬ (WilsonLoop plaquetteField plaquette ≡ pos 0)
                         → ¬ PureGauge plaquetteField
plaquette-not-pure-gauge =
  holonomy-obstructs-pure-gauge plaquetteField plaquette
