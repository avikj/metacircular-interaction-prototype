{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूलः — pūla, "a bundle, a sheaf (of grass)".  The ordinary Sanskrit
-- word for a bundle, borrowed here for its literal meaning and nothing
-- else.  No claim that any source states a fibre-bundle theorem; the
-- compound usage is this corpus's, declared at its site.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS FILE EXISTS
--
-- README §II and `HolonomyIsInvisibleExactlyToAnInvariantSemantics`
-- close with a disclaimer: "NOT anything about physical spacetime,
-- quantum states, Hilbert spaces or SU(2) — §II is about a semantics and
-- an equivalence."  `Visvarupa_…` repeats it and adds "no bundle over a
-- manifold appears in this repository."
--
-- Half of that was true and half of it was a gap the disclaimer was
-- hiding.  The SMOOTH content of gauge theory is genuinely absent — no
-- manifold, no Lie group, no connection form, no curvature 2-form, and
-- nothing below changes that.  But the HOMOTOPICAL content is not
-- absent, it was merely unwritten, and the corpus already holds every
-- piece of it:
--
--   `EkaSankramana_…`     a torsor is an equivalence: the element
--                         carrying one point to another is exactly one
--   `AbstractSpinNetworkKinematics`  gauge invariance IS the
--                         equivariance square, not a constraint on top
--   `Pradakshina_…`       holonomy is transport around a loop, computed
--   `Visvarupa_…`         a family is a map into the universe, and Σ is
--                         its total space
--
-- What was missing is the one module that says how they are one object.
-- This is that module, and its content is that a principal bundle needs
-- no new primitive: IT IS A FAMILY WHOSE FIBRES ARE TORSORS.  Everything
-- physics calls structure on top of that — the connection, the
-- holonomy's group-valuedness, the gauge transformation law — is forced,
-- and is proved below rather than posited.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  Torsor — a G-torsor packaged as a type with a free transitive
--       action.  `एकः` : the translating element is UNIQUE, imported as
--       a live use of `EkaSankramana`'s `regular` rather than restated.
--       `सारथिः` : hence the orbit map Carrier → Pts is an equivalence.
--
--   §2  पूलः / आधारः / तन्तुः-पूलस्य — a principal G-bundle over B is a map
--       B → Torsor.  That IS its classifying map: by the object
--       classifier (`Visvarupa` §1) a family and a map into the universe
--       are the same thing, so "the bundle" and "the map into the type
--       of torsors" are not two objects.  The total space is Σ, the
--       projection is `fst`, and the fibre over b is the torsor over b.
--
--   §3  समवृत्तिः — TRANSPORT IN A BUNDLE IS EQUIVARIANT, by path
--       induction.  Nothing is assumed about the family beyond its
--       being one: equivariance of parallel transport is not a
--       compatibility axiom imposed on a connection, it is a theorem
--       about `subst`.  This is the section that makes the rest work.
--
--   §4  होलोनोमी (`परिक्रमा`) — the holonomy of a loop, measured at a point
--       of the fibre, is a GROUP ELEMENT, uniquely determined; the
--       constant loop gives the identity; and
--           परिक्रमा (ℓ ∙ ℓ') p ≡ परिक्रमा ℓ p · परिक्रमा ℓ' p.
--       Holonomy is a homomorphism from the loops of the base into G.
--       Not a definition — the group law is derived from §3 and §1's
--       uniqueness.
--
--   §5  संवर्तनम् — CHANGING THE POINT OF THE FIBRE CONJUGATES THE
--       HOLONOMY:
--           परिक्रमा ℓ (k ▸ p) ≡ (k · परिक्रमा ℓ p) · inv k.
--       So a loop does not determine an element of G.  It determines a
--       CONJUGACY CLASS, and the choice of fibre point — the gauge — is
--       exactly the ambiguity.  This is the gauge transformation law,
--       and it is a corollary of uniqueness, not an assumption.
--
--   §6  क्षेत्रम् — matter.  A representation is a family on the type of
--       torsors; the associated bundle is the composite with the
--       classifying map; a matter field is a SECTION, i.e. a dependent
--       function; and its parallel transport is §3's `subst`, the same
--       operation, at the associated bundle.  `जीवितम्` exhibits the
--       tautological representation, whose associated bundle is the
--       principal bundle itself.
--
-- ────────────────────────────────────────────────────────────────────
-- READ WITH README §II.  §II proved that an observable is blind to
-- holonomy exactly when it is gauge-invariant.  §5 says what the
-- holonomy it is blind to actually is: a conjugacy class in G, with the
-- fibre point as the residual freedom.  The two together are the
-- statement that the physical residue of a gauge theory is the holonomy
-- up to conjugation — over a base with no smooth structure at all,
-- which is why the corpus's LQG reading ("LQG kinematics is the category
-- of actions of the gauge group") did not need one either.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.
--
-- * NOT that this is a theorem about physical spacetime.  There is no
--   manifold here, no smooth structure, no Lie group, no connection
--   1-form and no curvature.  The base is an arbitrary type and the
--   "connection" is `subst`.  What is shown is that the homotopical
--   skeleton of a principal bundle — fibres that are torsors, transport
--   that is equivariant, holonomy valued in the group up to conjugation
--   — needs none of that apparatus and follows from the fibre law.  The
--   step from a smooth principal bundle to this skeleton is standard
--   differential geometry and is NOT formalised here.
--
-- * NOT that the Standard Model, SU(3)×SU(2)×U(1), spin networks with
--   SU(2) labels, or any specific gauge theory is constructed.  G is an
--   arbitrary group given by its law set.
--
-- * NOT that holonomy determines the bundle (that is a reconstruction
--   theorem and needs connectedness and more), and NOT that every
--   G-bundle here is smooth, locally trivial, or has a global section.
--
-- * §6's associated bundle is the HoTT formulation — a representation as
--   a family on the classifying type — not the quotient construction
--   (P × V)/G, which would need a quotient HIT and is not built.  For
--   the tautological representation the two agree trivially; in general
--   the identification is not proved here.
--
-- No postulates, no holes, --safe.
--
-- CHECK STATUS AT THIS COMMIT: **NOT YET CHECKED AT THE PIN.**  The
-- container had no toolchain; `sh setup` was still building Agda 2.8.0.
-- Until `sh check --all` names this module `ok` at Agda 2.8.0 /
-- agda/cubical v0.9, every term below is a CLAIM and not a verdict.
------------------------------------------------------------------------

module Pula_ThePrincipalBundleIsAFamilyOfTorsorsSoItsHolonomyIsTheGroupAndTheFibrePointConjugatesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; isEquiv)
open import Cubical.Foundations.Transport using (substComposite)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Functions.Fibration using (fiberEquiv)

open import EkaSankramana_AFreeTransitiveActionsTranslationIsUniqueSoTheTorsorIsAnEquivalence
  using (Group ; Action ; Free ; Transitive ; regular ; torsorIsEquiv)

private
  variable
    ℓ ℓ' ℓb ℓv : Level

module _ (Grp : Group ℓ) where
  open Group Grp

  ----------------------------------------------------------------------
  -- §0  two lines of group algebra, used only in §5.
  ----------------------------------------------------------------------

  private
    cancelR : (a b k : Carrier) → a · k ≡ b · k → a ≡ b
    cancelR a b k eq =
      a                    ≡⟨ sym (idr a) ⟩
      a · e                ≡⟨ cong (a ·_) (sym (invr k)) ⟩
      a · (k · inv k)      ≡⟨ sym (assoc a k (inv k)) ⟩
      (a · k) · inv k      ≡⟨ cong (_· inv k) eq ⟩
      (b · k) · inv k      ≡⟨ assoc b k (inv k) ⟩
      b · (k · inv k)      ≡⟨ cong (b ·_) (invr k) ⟩
      b · e                ≡⟨ idr b ⟩
      b ∎

    shiftR : (x y k : Carrier) → x · k ≡ y → x ≡ y · inv k
    shiftR x y k eq = cancelR x (y · inv k) k
      (x · k                 ≡⟨ eq ⟩
       y                     ≡⟨ sym (idr y) ⟩
       y · e                 ≡⟨ cong (y ·_) (sym (invl k)) ⟩
       y · (inv k · k)       ≡⟨ sym (assoc y (inv k) k) ⟩
       (y · inv k) · k ∎)

  ----------------------------------------------------------------------
  -- §1  A G-torsor: a set with a free transitive action.  The type of
  --     G-torsors is the classifying type — "BG" — and a principal
  --     bundle is a map into it (§2).
  ----------------------------------------------------------------------

  record Torsor (ℓ' : Level) : Type (ℓ-max ℓ (ℓ-suc ℓ')) where
    field
      Pts    : Type ℓ'
      setPts : isSet Pts
      α      : Action Grp Pts
      free   : Free Grp Pts α
      tran   : Transitive Grp Pts α

  open Torsor public

  -- the action, written infix, at a named torsor
  _▸[_]_ : {ℓ' : Level} → Carrier → (T : Torsor ℓ') → Pts T → Pts T
  g ▸[ T ] p = Action.act Grp (Pts T) (α T) g p

  -- एकः — the translating element is exactly one.  `EkaSankramana`'s
  -- theorem, used rather than restated: if it is renamed or weakened,
  -- this file goes red.
  एकः : {ℓ' : Level} (T : Torsor ℓ') (p q : Pts T) (g h : Carrier)
      → g ▸[ T ] p ≡ q → h ▸[ T ] p ≡ q → g ≡ h
  एकः T p q g h gp hq = regular Grp (Pts T) (α T) (free T) p q g h gp hq

  -- and hence the orbit map is an equivalence: the torsor IS the group,
  -- once a point of it is named.  Naming that point is the gauge.
  सारथिः : {ℓ' : Level} (T : Torsor ℓ') (p : Pts T)
         → isEquiv (λ g → g ▸[ T ] p)
  सारथिः T p = torsorIsEquiv Grp (Pts T) (setPts T) (α T) (free T) (tran T) p

  ----------------------------------------------------------------------
  -- §2  पूलः — the principal bundle.  A map B → Torsor IS the bundle and
  --     IS its classifying map; by the object classifier those are not
  --     two objects.  The total space is Σ and the projection is fst.
  ----------------------------------------------------------------------

  पूलः : {ℓ' : Level} (B : Type ℓb) → Type (ℓ-max ℓb (ℓ-max ℓ (ℓ-suc ℓ')))
  पूलः {ℓ' = ℓ'} B = B → Torsor ℓ'

  -- the family of points: the bundle read as a family, which is what the
  -- classifier says it already was
  तन्तवः : {ℓ' : Level} {B : Type ℓb} → पूलः {ℓ' = ℓ'} B → B → Type ℓ'
  तन्तवः P b = Pts (P b)

  आधारः : {ℓ' : Level} {B : Type ℓb} → पूलः {ℓ' = ℓ'} B → Type (ℓ-max ℓb ℓ')
  आधारः {B = B} P = Σ[ b ∈ B ] तन्तवः P b

  प्रक्षेपः : {ℓ' : Level} {B : Type ℓb} (P : पूलः {ℓ' = ℓ'} B) → आधारः P → B
  प्रक्षेपः P = fst

  -- the fibre of the projection over b is the torsor over b.
  -- HoTT Lemma 4.8.1 at this family; `Visvarupa` §2 is the same lemma at
  -- the universal family.
  तन्तुः-पूलस्य : {ℓ' : Level} {B : Type ℓb} (P : पूलः {ℓ' = ℓ'} B) (b : B)
              → fiber (प्रक्षेपः P) b ≃ Pts (P b)
  तन्तुः-पूलस्य P b = fiberEquiv (तन्तवः P) b

  ----------------------------------------------------------------------
  -- §3  समवृत्तिः — transport in a bundle is equivariant.  By path
  --     induction, and about `subst` alone: equivariance of parallel
  --     transport is not an axiom imposed on a connection.
  ----------------------------------------------------------------------

  समवृत्तिः : {ℓ' : Level} {B : Type ℓb} (P : पूलः {ℓ' = ℓ'} B)
            {b b' : B} (q : b ≡ b') (g : Carrier) (p : Pts (P b))
          → subst (तन्तवः P) q (g ▸[ P b ] p)
          ≡ g ▸[ P b' ] subst (तन्तवः P) q p
  समवृत्तिः P {b = b} q g p =
    J (λ y r → subst (तन्तवः P) r (g ▸[ P b ] p)
             ≡ g ▸[ P y ] subst (तन्तवः P) r p)
      (substRefl {B = तन्तवः P} (g ▸[ P b ] p)
        ∙ cong (g ▸[ P b ]_) (sym (substRefl {B = तन्तवः P} p)))
      q

  ----------------------------------------------------------------------
  -- §4  परिक्रमा — the holonomy of a loop, measured at a point of the
  --     fibre.  It is a group element, and it is a homomorphism.
  ----------------------------------------------------------------------

  module _ {ℓ' : Level} {B : Type ℓb} (P : पूलः {ℓ' = ℓ'} B) {b : B} where

    -- the point the loop carries p to, in the same fibre
    वहनम् : (q : b ≡ b) → Pts (P b) → Pts (P b)
    वहनम् q = subst (तन्तवः P) q

    परिक्रमा : (q : b ≡ b) (p : Pts (P b)) → Carrier
    परिक्रमा q p = fst (tran (P b) p (वहनम् q p))

    परिक्रमा-वहति : (q : b ≡ b) (p : Pts (P b))
                 → परिक्रमा q p ▸[ P b ] p ≡ वहनम् q p
    परिक्रमा-वहति q p = snd (tran (P b) p (वहनम् q p))

    -- and it is the ONLY element that does: the holonomy is determined,
    -- not chosen.
    परिक्रमा-एका : (q : b ≡ b) (p : Pts (P b)) (g : Carrier)
                → g ▸[ P b ] p ≡ वहनम् q p → g ≡ परिक्रमा q p
    परिक्रमा-एका q p g gp = एकः (P b) p (वहनम् q p) g (परिक्रमा q p) gp (परिक्रमा-वहति q p)

    -- the constant loop has trivial holonomy
    परिक्रमा-रिक्ते : (p : Pts (P b)) → परिक्रमा refl p ≡ e
    परिक्रमा-रिक्ते p =
      sym (परिक्रमा-एका refl p e
        (Action.act-e Grp (Pts (P b)) (α (P b)) p
          ∙ sym (substRefl {B = तन्तवः P} p)))

    -- HOLONOMY IS A HOMOMORPHISM.  Derived from §3 and §1's uniqueness.
    परिक्रमा-योगे : (q r : b ≡ b) (p : Pts (P b))
                 → परिक्रमा (q ∙ r) p ≡ परिक्रमा q p · परिक्रमा r p
    परिक्रमा-योगे q r p =
      sym (परिक्रमा-एका (q ∙ r) p (परिक्रमा q p · परिक्रमा r p) step)
      where
      g = परिक्रमा q p
      h = परिक्रमा r p
      step : (g · h) ▸[ P b ] p ≡ वहनम् (q ∙ r) p
      step =
        (g · h) ▸[ P b ] p              ≡⟨ Action.act-· Grp (Pts (P b)) (α (P b)) g h p ⟩
        g ▸[ P b ] (h ▸[ P b ] p)       ≡⟨ cong (g ▸[ P b ]_) (परिक्रमा-वहति r p) ⟩
        g ▸[ P b ] वहनम् r p             ≡⟨ sym (समवृत्तिः P r g p) ⟩
        वहनम् r (g ▸[ P b ] p)           ≡⟨ cong (वहनम् r) (परिक्रमा-वहति q p) ⟩
        वहनम् r (वहनम् q p)               ≡⟨ sym (substComposite (तन्तवः P) q r p) ⟩
        वहनम् (q ∙ r) p ∎

    ------------------------------------------------------------------
    -- §5  संवर्तनम् — the gauge transformation law.  Moving the point of
    --     the fibre by k conjugates the holonomy by k.  So a loop does
    --     not name an element of G; it names a conjugacy class, and the
    --     choice of fibre point is exactly the residual freedom.
    ------------------------------------------------------------------

    संवर्तनम् : (q : b ≡ b) (p : Pts (P b)) (k : Carrier)
             → परिक्रमा q (k ▸[ P b ] p) ≡ (k · परिक्रमा q p) · inv k
    संवर्तनम् q p k = shiftR (परिक्रमा q (k ▸[ P b ] p)) (k · परिक्रमा q p) k both
      where
      g  = परिक्रमा q p
      g' = परिक्रमा q (k ▸[ P b ] p)
      -- both g' · k and k · g carry p to the transported point
      left : (g' · k) ▸[ P b ] p ≡ वहनम् q (k ▸[ P b ] p)
      left =
        (g' · k) ▸[ P b ] p           ≡⟨ Action.act-· Grp (Pts (P b)) (α (P b)) g' k p ⟩
        g' ▸[ P b ] (k ▸[ P b ] p)    ≡⟨ परिक्रमा-वहति q (k ▸[ P b ] p) ⟩
        वहनम् q (k ▸[ P b ] p) ∎
      right : (k · g) ▸[ P b ] p ≡ वहनम् q (k ▸[ P b ] p)
      right =
        (k · g) ▸[ P b ] p            ≡⟨ Action.act-· Grp (Pts (P b)) (α (P b)) k g p ⟩
        k ▸[ P b ] (g ▸[ P b ] p)     ≡⟨ cong (k ▸[ P b ]_) (परिक्रमा-वहति q p) ⟩
        k ▸[ P b ] वहनम् q p           ≡⟨ sym (समवृत्तिः P q k p) ⟩
        वहनम् q (k ▸[ P b ] p) ∎
      both : g' · k ≡ k · g
      both = एकः (P b) p (वहनम् q (k ▸[ P b ] p)) (g' · k) (k · g) left right

  ----------------------------------------------------------------------
  -- §6  क्षेत्रम् — matter is a section of an associated bundle.
  --
  -- A representation is a family on the classifying type; the associated
  -- bundle is the composite with the classifying map; a matter field is
  -- a dependent function.  Its parallel transport is §3's operation at
  -- the associated bundle — the same `subst`, one family over.
  ----------------------------------------------------------------------

  प्रतिरूपम् : (ℓ' ℓv : Level) → Type (ℓ-max (ℓ-max ℓ (ℓ-suc ℓ')) (ℓ-suc ℓv))
  प्रतिरूपम् ℓ' ℓv = Torsor ℓ' → Type ℓv

  सहपूलः : {ℓ' : Level} {B : Type ℓb} → प्रतिरूपम् ℓ' ℓv → पूलः {ℓ' = ℓ'} B → B → Type ℓv
  सहपूलः ρ P b = ρ (P b)

  क्षेत्रम् : {ℓ' : Level} {B : Type ℓb} → प्रतिरूपम् ℓ' ℓv → पूलः {ℓ' = ℓ'} B → Type (ℓ-max ℓb ℓv)
  क्षेत्रम् {B = B} ρ P = (b : B) → सहपूलः ρ P b

  -- the tautological representation: the associated bundle it builds is
  -- the principal bundle itself.
  जीवितम् : {ℓ' : Level} {B : Type ℓb} (P : पूलः {ℓ' = ℓ'} B) (b : B)
          → सहपूलः {ℓb = ℓb} Pts P b ≡ तन्तवः P b
  जीवितम् P b = refl
