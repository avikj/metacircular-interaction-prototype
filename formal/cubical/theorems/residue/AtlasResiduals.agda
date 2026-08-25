{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AtlasResiduals
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
-- half of 3.1 is already in `PathIsSymmetry` (ΩFin≃Sym)
-- and `Decategorification` (ℕ≃π₀FinSet, card≡MereEq,
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
--   A2 `ℕ-isInitial∞`        for EVERY (1+X)-algebra B, at any universe
--      `ℕ-isInitial`         level and with NO h-level hypothesis on the
--                            carrier, the comparison type is
--                            CONTRACTIBLE — a path, not a
--                            mere-propositional "at most one".
--                            The theorem is
--                            `Cubical.Data.Nat.Algebra.isNatHInitialℕ`
--                            (Awodey–Gambino–Sojakova, arXiv:1504.05531).
--   A2c `AlgHomChart`        ... and THIS is the second chart on it:
--      `chart-lib-ours`      our pointwise comparison type and the
--      `chart-ours-lib`      library's funExt'd one are interchangeable
--                            ON THE NOSE, both round trips `refl`.  Not
--                            a redundancy to be eliminated — a checked
--                            translation, stronger than an equivalence,
--                            in the module that argues presentations are
--                            charts.  The earlier hand proof and the set
--                            hypothesis it needed are gone; the second
--                            presentation stays, now connected.
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
--    induction on n, and it is NOT here.
--
--    STATUS 2026-08-14 — **RESOLVED**, by
--    `LinearOrderFinite` (--safe, no postulates, no
--    holes, exit 0 standalone and through the root aggregate, which
--    imports it).  That module defines `LinOrd′` as a genuine order
--    structure and proves
--        `linOrd′≃ : LinOrd′ X ≃ (X ≃ Fin n)`  for X with ∥ X ≃ Fin n ∥₁
--    — half (i), whole, with both round trips:
--      * forward `Order.rankEquiv`, the rank map x ↦ #{ z | z < x },
--        proved an equivalence (injective by antisymmetry through
--        `rank-order`, surjective by a finite pigeonhole `embSurj`
--        proved there by counting fibres);
--      * backward `pull`, transport of Fin n's standard order;
--      * `rank-pull`, `pull-rank`, the two composites, as paths.
--    Its `isContrOrdTotal′ : isContr (Σ[ X ∈ BSₙ ] LinOrd′ ⟨X⟩)` is
--    Theorem 3.2 whole, and it is obtained by transporting B5 below
--    along that fibrewise equivalence: B5 is imported, not reproved.
--
--    Two riders, both spelled out in that file's header.  (a) The
--    axioms are the classical ones with MERE (truncated) totality;
--    decidability of the order — which the obligation above offered as
--    an axiom — is DERIVED there from mere totality plus decidable
--    equality, so nothing was weakened to force the close.  (b) The
--    proof counts down-sets; it is NOT the induction on n predicted
--    above.  The prediction was wrong about the method, not about the
--    content.
--
--    Prior art (from the ecosystem survey, `notes/HOTT_ECOSYSTEM_MAP.md`,
--    and kept here): UniMath states this existence direction and then
--    `Abort`s it (`OrderTheory/OrderedSets/OrderedSets.v:360`); no
--    library surveyed — cubical, agda-unimath, Coq-HoTT, 1lab — has it
--    constructively; mathlib4 has it classically as `monoEquivOfFin`.
--
--    B5 is unchanged and is still exactly the univalence half.  It may
--    now be cited as such without the rider that the other half is
--    missing — but it is still NOT Theorem 3.2 by itself.  The name for
--    the whole theorem is `LinearOrderFinite.isContrOrdTotal′`.
--
--  * ~~A2 requires the TARGET algebra's carrier to be a set (`isSetCar`
--    is a field of `Alg`) ... Initiality of ℕ among (1+X)-algebras on
--    arbitrary types — the ∞-algebra statement — is neither proved nor
--    refuted here.~~  **WITHDRAWN 2026-08-14.**  The ∞-algebra statement
--    was proved in 2019, in `Cubical/Data/Nat/Algebra.agda`, inside the
--    library pinned by this very corpus, and nothing in this file ever
--    imported it.  `isSetCar` has been deleted from `Alg`; A2 is now
--    that library theorem, repackaged.  §3 inherits the strengthening.
--    Found by the HoTT/UF ecosystem survey (`notes/HOTT_ECOSYSTEM_MAP.md`),
--    which reports that 12 of 15 univalent claims in this corpus are
--    already proved elsewhere, nine of them in libraries already on disk.
--    Struck rather than deleted: the withdrawn text is a correct record
--    of what was believed and is part of the mathematics.  Note what is
--    withdrawn and what is not.  Withdrawn: that the ∞-statement was
--    open.  NOT withdrawn, and never was: that this file states the
--    theorem in its own vocabulary.  That is a chart, it is kept, and
--    `AlgHomChart` is now the transition to the library's.
--
--  * `isInitial` is stated at a FIXED universe level, because A5 must
--    apply an algebra's initiality to another algebra AND to itself.
--    A2 is separately universe-polymorphic in the target.  No claim is
--    made that these two notions of initiality agree.
--
--  * Nothing here is about chart (b) as a MONOID.  The note's Theorem
--    2.1 also asserts that the induced (N,+,0) is a free commutative
--    monoid and that the two constructions are mutually inverse.  That
--    half lives in `FreeMonoid`, which builds ℕ ≃ Tally
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

module AtlasResiduals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Algebra
  using (NatAlgebra ; NatMorphism ; NatAlgebraℕ ; isNatHInitialℕ)
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
    Car : Type ℓ
    pt  : Car
    op  : Car → Car

open Alg public

AlgHom : Alg ℓ → Alg ℓ' → Type (ℓ-max ℓ ℓ')
AlgHom A B =
  Σ[ h ∈ (Car A → Car B) ]
    ((h (pt A) ≡ pt B) × ((x : Car A) → h (op A x) ≡ op B (h x)))

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
ℕAlg = alg ℕ zero suc

------------------------------------------------------------------------
-- A2, RE-DERIVED FROM THE LIBRARY AND STRENGTHENED, 2026-08-14.
--
-- This module's first version proved A2 by hand and required the target
-- carrier to be a SET.  `Cubical.Data.Nat.Algebra` — a module of the
-- library this file already depends on, following
-- Awodey–Gambino–Sojakova (arXiv:1504.05531) — proves
--
--     isNatHInitialℕ : (M : NatAlgebra ℓ) → isContr (NatMorphism NatAlgebraℕ M)
--
-- with NO h-level hypothesis at all, at every universe level, and has
-- since 2019.
--
-- TWO THINGS FOLLOW, AND THEY ARE DIFFERENT THINGS.
--
-- (1) The set hypothesis was a genuine WEAKENING and is deleted.
--     `isSetCar` was used in exactly one place (the hand proof's appeal
--     to `Σ≡Prop`), so removing it costs nothing and §3's
--     `initial→isEquiv` and `isContrAlgIso` now hold for algebras on
--     ARBITRARY types — their proofs only ever used contractibility.
--     This part is a strengthening, and it is why the hand proof went.
--
-- (2) The second PRESENTATION is not a redundancy, and it stays.  An
--     earlier version of this comment called it "packaging" and treated
--     having re-stated a known theorem in local vocabulary as the error.
--     That reading is withdrawn, and it was wrong in a specific way: it
--     is the reading this whole module is written against.  A chart is
--     not a lesser copy of the object.  Parallel presentations are how
--     anything gets deciphered, and the transition between them is the
--     mathematical content — which is exactly what `AlgHomChart` below
--     now records, publicly and by name.
--
--     Nor is it a mere equivalence.  Both round trips compute to `refl`
--     (`chart-lib-ours`, `chart-ours-lib`): the library's funExt'd
--     `comm-suc` and our pointwise one are DEFINITIONALLY
--     interchangeable, because cubical `funExt` / `funExt⁻` are inverse
--     by computation.  That is strictly more information than "the two
--     comparison types are equivalent", and it is information neither
--     chart carries alone.  You cannot state it with one presentation.
------------------------------------------------------------------------

AlgHom∞ : {B : Type ℓ} → B → (B → B) → Type ℓ
AlgHom∞ {B = B} b₀ bs =
  Σ[ h ∈ (ℕ → B) ] ((h zero ≡ b₀) × ((n : ℕ) → h (suc n) ≡ bs (h n)))

module _ {B : Type ℓ} (b₀ : B) (bs : B → B) where

  -- The library's presentation of the same algebra.
  libAlg : NatAlgebra ℓ
  NatAlgebra.Carrier  libAlg = B
  NatAlgebra.alg-zero libAlg = b₀
  NatAlgebra.alg-suc  libAlg = bs

  ----------------------------------------------------------------------
  -- THE CHART TRANSITION.  This is the contribution of this section,
  -- and it is not "packaging" — it is the atlas entry between our
  -- pointwise presentation of a comparison and the library's funExt'd
  -- one, in a module whose entire subject is that presentations are
  -- charts and the transitions between them carry the content.
  ----------------------------------------------------------------------

  toLib : AlgHom∞ b₀ bs → NatMorphism NatAlgebraℕ libAlg
  NatMorphism.morph     (toLib φ) = φ .fst
  NatMorphism.comm-zero (toLib φ) = φ .snd .fst
  NatMorphism.comm-suc  (toLib φ) = funExt (φ .snd .snd)

  fromLib : NatMorphism NatAlgebraℕ libAlg → AlgHom∞ b₀ bs
  fromLib m = NatMorphism.morph m
            , NatMorphism.comm-zero m
            , funExt⁻ (NatMorphism.comm-suc m)

  -- The two charts agree ON THE NOSE.  Both round trips are `refl`, so
  -- the presentations are not merely equivalent but DEFINITIONALLY
  -- interchangeable: record eta and Σ eta on one side, and the fact
  -- that cubical `funExt` / `funExt⁻` are inverse by computation rather
  -- than by a proof, on the other.  A mere Iso would be weaker, and
  -- weaker in the way that matters — transport along this one costs
  -- nothing, so a statement proved in either chart is available in the
  -- other with no coercion left in the term.
  chart-lib-ours : (m : NatMorphism NatAlgebraℕ libAlg) → toLib (fromLib m) ≡ m
  chart-lib-ours _ = refl

  chart-ours-lib : (φ : AlgHom∞ b₀ bs) → fromLib (toLib φ) ≡ φ
  chart-ours-lib _ = refl

  AlgHomChart : Iso (AlgHom∞ b₀ bs) (NatMorphism NatAlgebraℕ libAlg)
  Iso.fun      AlgHomChart = toLib
  Iso.inv      AlgHomChart = fromLib
  Iso.rightInv AlgHomChart = chart-lib-ours
  Iso.leftInv  AlgHomChart = chart-ours-lib

  -- A2∞.  No set hypothesis, any universe level.  Transported along the
  -- chart from the library's theorem.
  ℕ-isInitial∞ : isContr (AlgHom∞ b₀ bs)
  ℕ-isInitial∞ = isOfHLevelRetractFromIso 0 AlgHomChart (isNatHInitialℕ libAlg)

-- A2.  The original statement, now a definitional instance of A2∞
-- (`AlgHom ℕAlg B` reduces to `AlgHom∞ (pt B) (op B)`).
ℕ-isInitial : (B : Alg ℓ) → isContr (AlgHom ℕAlg B)
ℕ-isInitial B = ℕ-isInitial∞ (pt B) (op B)

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
