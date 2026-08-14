{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AtlasResiduals
--
-- SOURCE OF THE TARGETS.  `notes/ATLAS_OF_N.md` §7, "Formalization
-- targets for the sibling Cubical lane", lists four statements from that
-- note as worth machine-checking.  Two of them were unclaimed; this
-- module lands those two.
--
--   * Theorem 2.1 (§2.1), the half the note calls load-bearing: not that
--     the comparison between chart (a) (initial (1+X)-algebra) and chart
--     (b) (free monoid on one generator) EXISTS, but that the type of
--     comparisons is CONTRACTIBLE.  "Residual 2.1: the trivial group"
--     is exactly this contractibility, and §8's residual table records
--     it as "comparison type is contractible".
--
--   * Theorem 3.2 (§3.2): Σ[ X ∈ BSₙ ] LinOrd(X) is contractible — the
--     note's "two-line univalent proof that is the whole content of
--     'ordinals rigidify what cardinals truncate'".
--
-- The other two §7 targets (Theorem 3.1's ∐ BSₙ decomposition, and
-- Theorem 2.7 + Proposition 2.11) are NOT touched here; the loop-group
-- half of 3.1 is already in `NaturalMachine.PathIsSymmetry` (ΩFin≃Sym)
-- and `NaturalMachine.Decategorification` (ℕ≃π₀FinSet, card≡MereEq,
-- FinSetLoop≃Sym), and nothing below reproves any of them.
--
--
-- WHAT IS CHECKED
--
-- A. Theorem 2.1, contractibility half (§1–§3 below).
--
--   A1 `AlgHom`              the comparison type itself, as a Σ: a
--                            carrier map together with the two
--                            commutation data (h pt ≡ pt, h ∘ op ≡ op ∘ h).
--                            Comparisons are DATA here, not a property.
--   A2 `ℕ-isInitial`         for EVERY (1+X)-algebra B on a set, at any
--                            universe level, `AlgHom ℕAlg B` is
--                            CONTRACTIBLE.  The recursor is the centre;
--                            uniqueness is a path, produced by induction
--                            plus `Σ≡Prop`, not a mere-propositional
--                            statement of "there is at most one".
--   A3 `ℕ-recursor-unique`   the honest minimum the task names: the type
--                            of algebra maps ℕ → ℕ commuting with zero
--                            and suc is contractible.
--   A4 `ℕ-algebra-endo-is-id`
--                            ... and its centre is the identity, so
--                            every such endomorphism is PATH-equal to
--                            `idAlgHom`.  This is the strengthening of
--                            `PathIsSymmetry.ℕ-algebra-Aut-trivial`,
--                            which only handled self-EQUIVALENCES and
--                            only concluded a path of equivalences.
--   A5 `initial→isEquiv`     the generalisation to two initial algebras,
--     `isContrAlgIso`        which did land cleanly: if A and B are both
--                            initial then every comparison map is an
--                            equivalence, and the type of algebra
--                            ISOMORPHISMS A ≅ B is contractible.  This
--                            is §2.1's Residual-2.1 statement (1)
--                            verbatim: "the type of isomorphisms between
--                            two initial objects is contractible, not
--                            merely inhabited".
--
-- B. Theorem 3.2 (§4 below).
--
--   B1 `BS`                  BSₙ = Σ[ X ∈ Type₀ ] ∥ X ≃ Fin n ∥₁, the
--                            type of n-element types (note §3.1).
--   B2 `OrdTotal`            Σ[ X ∈ BSₙ ] LinOrd n ⟨X⟩.
--   B3 `forgetTrunc`         OrdTotal n ≅ Σ[ X ∈ Type₀ ] (X ≃ Fin n):
--                            the mere-finiteness component is REDUNDANT
--                            in the presence of the order datum.  (This
--                            is the only step of the note's proof that
--                            is not univalence, and it is why the total
--                            space is a BASED path space rather than
--                            something over BSₙ.)
--   B4 `ordTotal≃basedPath`  ... and by univalence that is the based
--                            path space Σ[ X ∈ Type₀ ] (X ≡ Fin n).
--   B5 `isContrOrdTotal`     THE THEOREM: Σ[ X ∈ BSₙ ] LinOrd(X) is
--                            contractible.
--   B6 `linOrd-torsor`       the fibrewise companion (note Theorem 2.5):
--                            given one order on X, the type of orders on
--                            X is equivalent to Sₙ = (Fin n ≃ Fin n).
--                            A torsor is a fibre that becomes the group
--                            once a point is chosen; that is this line.
--
--
-- ====================================================================
-- WHAT IS DELIBERATELY NOT CLAIMED
-- ====================================================================
--
--  * ***THE LINEAR ORDER IS A DEFINITIONAL SHORTCUT, AND B5 IS THEREFORE
--    NEAR-TAUTOLOGICAL AS AN ORDER-THEORETIC STATEMENT.***  `LinOrd n X`
--    is DEFINED to be `X ≃ Fin n`.  It is not defined as a decidable
--    total order (a relation _≤_ with reflexivity, antisymmetry,
--    transitivity, totality and decidability), and no such relation
--    appears anywhere below.  The note's proof of Theorem 3.2 has two
--    halves —
--        (i) "a linear order on an n-element type is the same datum as
--             an equivalence X ≃ Fin n (send the k-th smallest element
--             to k; conversely transport the standard order)", and
--       (ii) "so the displayed type is a based path space, contractible
--             by univalence"
--    — and ONLY HALF (ii) IS CHECKED HERE.  Half (i) is assumed by
--    fiat, by naming `X ≃ Fin n` "LinOrd".  What B5 honestly certifies
--    is that the univalence half of the argument is correct and that the
--    truncation in BSₙ costs nothing; it certifies NOTHING about orders.
--
--    THE EXACT REMAINING OBLIGATION, stated so that a later block can
--    discharge it without reinterpreting anything: define
--
--        LinOrd′ X = Σ[ _≤_ ∈ (X → X → Type₀) ]
--                      (isProp-valued × reflexive × antisymmetric ×
--                       transitive × total × decidable)
--
--    and prove `LinOrd′ X ≃ (X ≃ Fin n)` for every X with ∥ X ≃ Fin n ∥₁.
--    The forward map is "rank in the order"; the backward map transports
--    Fin n's standard order.  That equivalence — the rigidification
--    statement of §2.3, Proposition 2.4 — is the content, it is a real
--    induction on n, and it is NOT here.  Until it lands, B5 should be
--    cited as "the univalence half of Theorem 3.2" and never as
--    Theorem 3.2.
--
--  * A2 requires the TARGET algebra's carrier to be a set (`isSetCar` is
--    a field of `Alg`).  That hypothesis is what makes the commutation
--    data a proposition, hence what lets `Σ≡Prop` produce the path.
--    Initiality of ℕ among (1+X)-algebras on arbitrary types — the
--    ∞-algebra statement — is neither proved nor refuted here.  ℕ itself
--    is a set, so A3/A4 lose nothing; the restriction bites only for
--    exotic targets.
--
--  * `isInitial` is stated at a FIXED universe level, because A5 must
--    apply an algebra's initiality to another algebra AND to itself.
--    A2 is separately universe-polymorphic in the target.  No claim is
--    made that these two notions of initiality agree.
--
--  * Nothing here is about chart (b) as a MONOID.  The note's Theorem
--    2.1 also asserts that the induced (N,+,0) is a free commutative
--    monoid and that the two constructions are mutually inverse.  That
--    half lives in `NaturalMachine.FreeMonoid`, which builds ℕ ≃ Tally
--    and the SIP equality of monoids; the present module contributes
--    only the contractibility, which is the half §7 singled out.
--
--  * `BS` is taken at `Type₀` with `Cubical.Data.Fin.Fin`, matching
--    `Decategorification`.  No universe-polymorphic BSₙ, no comparison
--    with `Cubical.Data.FinSet`'s `FinSet`, and no claim that BSₙ is
--    connected (it is, by the truncation, but connectedness is not used
--    and not stated).
--
--  * B6 exhibits an equivalence, not a group action.  No torsor
--    structure is packaged, no Sₙ-action is defined, and freeness and
--    transitivity are not separately stated: they are what the
--    equivalence would unfold to, and unfolding them is not done.
------------------------------------------------------------------------

module NaturalMachine.AtlasResiduals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin ; isSetFin)
open import Cubical.Data.Sigma
open import Cubical.HITs.PropositionalTruncation
  using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1.  (1 + X)-algebras and their comparison type.
--
-- An algebra is a carrier with a point and an endomap; a comparison is
-- a carrier map TOGETHER WITH the two commutation witnesses.  Keeping
-- the witnesses as data (rather than quotienting them away) is the
-- entire point: contractibility of this Σ is a strictly stronger
-- statement than "there is a unique underlying function".
------------------------------------------------------------------------

record Alg (ℓ : Level) : Type (ℓ-suc ℓ) where
  constructor alg
  field
    Car      : Type ℓ
    isSetCar : isSet Car
    pt       : Car
    op       : Car → Car

open Alg public

AlgHom : Alg ℓ → Alg ℓ' → Type (ℓ-max ℓ ℓ')
AlgHom A B =
  Σ[ h ∈ (Car A → Car B) ]
    ((h (pt A) ≡ pt B) × ((x : Car A) → h (op A x) ≡ op B (h x)))

-- The commutation data is a proposition, because the target is a set.
-- This lemma is the whole reason contractibility (and not merely
-- "unique up to a homotopy of underlying functions") is available.
isPropCommutes : (A : Alg ℓ) (B : Alg ℓ') (h : Car A → Car B)
               → isProp ((h (pt A) ≡ pt B) × ((x : Car A) → h (op A x) ≡ op B (h x)))
isPropCommutes A B h =
  isProp× (isSetCar B _ _) (isPropΠ (λ _ → isSetCar B _ _))

idAlgHom : (A : Alg ℓ) → AlgHom A A
idAlgHom A = idfun (Car A) , refl , λ _ → refl

compAlgHom : {A : Alg ℓ} {B : Alg ℓ'} {C : Alg ℓ''}
           → AlgHom A B → AlgHom B C → AlgHom A C
compAlgHom (h , p , q) (h' , p' , q') =
    (λ x → h' (h x))
  , (cong h' p ∙ p')
  , (λ x → cong h' (q x) ∙ q' (h x))

------------------------------------------------------------------------
-- 2.  ℕ is the initial (1 + X)-algebra, and the comparison type is
--     CONTRACTIBLE.  (Theorem 2.1, the load-bearing half.)
------------------------------------------------------------------------

ℕAlg : Alg ℓ-zero
ℕAlg = alg ℕ isSetℕ zero suc

natrec : {Y : Type ℓ} → Y → (Y → Y) → ℕ → Y
natrec y₀ g zero    = y₀
natrec y₀ g (suc n) = g (natrec y₀ g n)

-- A2.  Universe-polymorphic in the target.
ℕ-isInitial : (B : Alg ℓ) → isContr (AlgHom ℕAlg B)
ℕ-isInitial B = centre , contract
  where
    centre : AlgHom ℕAlg B
    centre = natrec (pt B) (op B) , refl , λ _ → refl

    unique : (φ : AlgHom ℕAlg B) (n : ℕ)
           → natrec (pt B) (op B) n ≡ φ .fst n
    unique φ zero    = sym (φ .snd .fst)
    unique φ (suc n) = cong (op B) (unique φ n) ∙ sym (φ .snd .snd n)

    contract : (φ : AlgHom ℕAlg B) → centre ≡ φ
    contract φ =
      Σ≡Prop (isPropCommutes ℕAlg B) (funExt (unique φ))

-- A3.  The honest minimum: algebra maps ℕ → ℕ commuting with 0 and suc
-- form a CONTRACTIBLE type.  Uniqueness of the recursor as a path.
ℕ-recursor-unique : isContr (AlgHom ℕAlg ℕAlg)
ℕ-recursor-unique = ℕ-isInitial ℕAlg

-- A4.  ... and the unique such map is the identity, on the nose, as a
-- path in the comparison type (so the commutation witnesses are
-- identified too, not just the underlying functions).
ℕ-algebra-endo-is-id : (φ : AlgHom ℕAlg ℕAlg) → φ ≡ idAlgHom ℕAlg
ℕ-algebra-endo-is-id φ =
  sym (ℕ-recursor-unique .snd φ) ∙ ℕ-recursor-unique .snd (idAlgHom ℕAlg)

------------------------------------------------------------------------
-- 3.  Two initial algebras: the comparison is unique AND automatically
--     an isomorphism.  (Residual 2.1, statement (1).)
------------------------------------------------------------------------

isInitial : Alg ℓ → Type (ℓ-suc ℓ)
isInitial {ℓ = ℓ} A = (B : Alg ℓ) → isContr (AlgHom A B)

ℕ-isInitial₀ : isInitial ℕAlg
ℕ-isInitial₀ = ℕ-isInitial

AlgIso : Alg ℓ → Alg ℓ → Type ℓ
AlgIso A B = Σ[ φ ∈ AlgHom A B ] isEquiv (φ .fst)

-- A5a.  Between initial algebras every comparison map is invertible:
-- the two round trips are algebra endomorphisms, hence equal to the
-- identity by contractibility of the endo-comparison type.
initial→isEquiv : {A B : Alg ℓ}
                → isInitial A → isInitial B
                → (φ : AlgHom A B) → isEquiv (φ .fst)
initial→isEquiv {A = A} {B = B} iA iB φ =
  isoToIsEquiv (iso (φ .fst) (ψ .fst)
                    (λ b i → φψ i .fst b)
                    (λ a i → ψφ i .fst a))
  where
    ψ : AlgHom B A
    ψ = iB A .fst

    ψφ : compAlgHom {A = A} {B = B} {C = A} φ ψ ≡ idAlgHom A
    ψφ = sym (iA A .snd (compAlgHom {A = A} {B = B} {C = A} φ ψ))
       ∙ iA A .snd (idAlgHom A)

    φψ : compAlgHom {A = B} {B = A} {C = B} ψ φ ≡ idAlgHom B
    φψ = sym (iB B .snd (compAlgHom {A = B} {B = A} {C = B} ψ φ))
       ∙ iB B .snd (idAlgHom B)

-- A5b.  Hence the type of algebra ISOMORPHISMS between two initial
-- algebras is contractible: `isEquiv` is a proposition, and it is
-- inhabited at every point of a contractible base.
isContrAlgIso : {A B : Alg ℓ}
              → isInitial A → isInitial B → isContr (AlgIso A B)
isContrAlgIso {A = A} {B = B} iA iB =
  isContrΣ (iA B)
           (λ φ → inhProp→isContr (initial→isEquiv {A = A} {B = B} iA iB φ)
                                   (isPropIsEquiv (φ .fst)))

------------------------------------------------------------------------
-- 4.  Theorem 3.2: the total space of orders over BSₙ is contractible.
--
-- READ THE HEADER FIRST.  `LinOrd` is DEFINED as `X ≃ Fin n`; the
-- order-theoretic half of the note's proof is assumed, not checked.
-- What is checked is that the truncation in BSₙ is redundant here, and
-- that the resulting type is a based path space.
------------------------------------------------------------------------

-- The type of n-element types (note §3.1).
BS : ℕ → Type₁
BS n = Σ[ X ∈ Type₀ ] ∥ X ≃ Fin n ∥₁

-- *** DEFINITIONAL SHORTCUT — see "WHAT IS DELIBERATELY NOT CLAIMED". ***
-- A linear order on an n-element type is here TAKEN to be a rank
-- listing, i.e. an equivalence with the standard n-element type.  The
-- theorem below is a statement about rank listings, and becomes a
-- statement about orders only after the missing equivalence
-- `LinOrd′ X ≃ (X ≃ Fin n)` is proved.
LinOrd : ℕ → Type₀ → Type₀
LinOrd n X = X ≃ Fin n

OrdTotal : ℕ → Type₁
OrdTotal n = Σ[ X ∈ BS n ] LinOrd n (X .fst)

-- B3.  The order datum already supplies the mere finiteness witness, so
-- the truncation component carries no information: it is a proposition
-- whose inhabitant is determined by the datum sitting next to it.
forgetTrunc : (n : ℕ) → Iso (OrdTotal n) (Σ[ X ∈ Type₀ ] (X ≃ Fin n))
Iso.fun      (forgetTrunc n) ((X , _) , e) = X , e
Iso.inv      (forgetTrunc n) (X , e)       = (X , ∣ e ∣₁) , e
Iso.rightInv (forgetTrunc n) _             = refl
Iso.leftInv  (forgetTrunc n) ((X , t) , e) i =
  (X , isPropPropTrunc ∣ e ∣₁ t i) , e

-- B4.  Univalence, applied fibrewise: the space of rank listings on a
-- varying X is the based path space at Fin n.  THIS is the step the
-- note calls "a two-line univalent proof".
basedPath≃ : (n : ℕ) → (Σ[ X ∈ Type₀ ] (X ≡ Fin n)) ≃ (Σ[ X ∈ Type₀ ] (X ≃ Fin n))
basedPath≃ n = Σ-cong-equiv-snd (λ _ → univalence)

ordTotal≃basedPath : (n : ℕ) → OrdTotal n ≃ (Σ[ X ∈ Type₀ ] (X ≡ Fin n))
ordTotal≃basedPath n =
  compEquiv (isoToEquiv (forgetTrunc n)) (invEquiv (basedPath≃ n))

isContrBasedPath : (n : ℕ) → isContr (Σ[ X ∈ Type₀ ] (X ≡ Fin n))
isContrBasedPath n =
  isOfHLevelRespectEquiv 0 (invEquiv (basedPath≃ n)) (EquivContr (Fin n))

-- B5.  THE STATEMENT.  (With the caveat of the header: this is the
-- univalence half of Theorem 3.2.)
isContrOrdTotal : (n : ℕ) → isContr (OrdTotal n)
isContrOrdTotal n =
  isOfHLevelRespectEquiv 0 (invEquiv (ordTotal≃basedPath n)) (isContrBasedPath n)

-- Immediate consequence, and the form in which the note uses it: any
-- two ordered n-element types are equal, uniquely.
isPropOrdTotal : (n : ℕ) → isProp (OrdTotal n)
isPropOrdTotal n = isContr→isProp (isContrOrdTotal n)

------------------------------------------------------------------------
-- 5.  The fibrewise companion (note Theorem 2.5): over a FIXED carrier
--     the space of orders is not contractible but a copy of Sₙ.
--
-- Contractibility of the TOTAL space together with non-contractibility
-- of the fibres is exactly "chart (d) rigidifies what chart (c)
-- truncates": the orders on one set form an Sₙ-worth of choices, and
-- letting the set vary along with the order collapses all of them.
------------------------------------------------------------------------

linOrd-torsor : (n : ℕ) (X : Type₀) → LinOrd n X → LinOrd n X ≃ (Fin n ≃ Fin n)
linOrd-torsor n X e = equivComp e (idEquiv (Fin n))

-- Sanity, definitional: the standard n-element type carries the
-- standard rank listing, so the fibres are inhabited and §5 is not
-- vacuous.
stdLinOrd : (n : ℕ) → LinOrd n (Fin n)
stdLinOrd n = idEquiv (Fin n)
