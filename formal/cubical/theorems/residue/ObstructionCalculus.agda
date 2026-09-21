{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ObstructionCalculus
--
-- The machine-checked fragment of `papers/hieroglyphics_ii.tex`.
--
-- The document's central structural claim is that Φ does not change the
-- object -- `Φ ≠ वस्तुपरिवर्तनम्` -- but widens the field of visible
-- distinctions, `Φ = दृश्यभेदक्षेत्रविस्तारः`, and that consequently
--
--     Obs_{𝒪α}(X) = 0   ⇏   Obs_{𝒪α+1}(X) = 0.
--
-- That non-implication is the part with content, it is the part this
-- repository has twice been bitten by, and it is provable here rather than
-- asserted.  Sections A--C do it.
--
-- Section D is the discipline `प्रथमं वर्गीकुरु; पश्चात् Γ` -- classify the
-- defect before repairing it -- encoded the only way a proof assistant can
-- encode a methodological rule: the classification is an *argument* to the
-- repair, so an unclassified repair does not typecheck.
--
-- Section E is `जननीयता ≢ पुनर्निर्मेयता`: generability and
-- reconstructibility are independent, with both witnesses.
--
-- WHAT IS NOT HERE, and why.  This module is 0-truncated and finite.  It is
-- the decategorified shadow of the document, not the document:
--
--   * `δ◁ = cofib(hocolim 𝔐ᵢ → X)` and `δ▷ = fib(X → holim 𝔐ᵢ)` appear only
--     as "is this map split-surjective / injective".  The homotopy-theoretic
--     content is discarded; what survives is the independence.
--   * Of the four repair kinds `Γ∅, Γ⇑, Γ↺, Γ^`, only `Γ∅` and `Γ^` are
--     distinguishable at this truncation, and Section D proves the one
--     implication that holds between them.  `Γ⇑` (promote the defect to a
--     2-cell) and `Γ↺` (keep it as a class) need genuine higher structure to
--     differ from `Γ∅`.  That is not a defect of the schema -- it is the
--     schema's own point, that the higher structure is what tells the repairs
--     apart -- but it does mean this module cannot see them.
--   * `χ = ΔReach/ΔKill` is absent.  It needs a cost model, and this
--     repository has none: see `CountedDigits`' cost boundary.
--     A ratio of two unmeasured rates is exactly the kind of number
--     `CLAUDE.md` forbids.
------------------------------------------------------------------------

module ObstructionCalculus where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; posNotnegsuc)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import SmithSignNormal using (absℤ ; absℤ-idem)

private
  variable
    X V : Type₀

------------------------------------------------------------------------
-- A.  Observation fields, and the two things one can say about a pair.

-- A field of observations on `X` with values in `V`.  This is `𝒪`.
record Obs (X V : Type₀) : Type₁ where
  constructor obs
  field
    Index : Type₀
    read : Index → X → V

open Obs

-- `Sep 𝒪 x y` is a *witness* that the field distinguishes `x` from `y`: a
-- named observation together with a proof that its two readings differ.  This
-- is the repository's own notion -- `natural_crystal` keeps exactly this
-- witness, and keeps the shortest one.
Sep : Obs X V → X → X → Type₀
Sep O x y = Σ[ i ∈ O .Index ] (¬ (O .read i x ≡ O .read i y))

-- Blindness is the *absence* of such a witness.  `Obs_𝒪(X) = 0` in the
-- document's notation, for the pair `x , y`.
Blind : Obs X V → X → X → Type₀
Blind O x y = ¬ Sep O x y

------------------------------------------------------------------------
-- B.  Φ: widening the field, not changing the object.

-- `O ⊑ P` says `P` sees everything `O` sees, reading it the same way.  Note
-- that `X` is fixed: the object does not move.
record _⊑_ (O P : Obs X V) : Type₀ where
  constructor widen
  field
    push : O .Index → P .Index
    keep : (i : O .Index) (z : X) → P .read (push i) z ≡ O .read i z

open _⊑_

-- Distinctions survive widening.  This direction is the easy one, and it is
-- the only direction that holds.
Φ-monotone : {O P : Obs X V} → O ⊑ P → {x y : X}
           → Sep O x y → Sep P x y
Φ-monotone {O = O} {P = P} w {x} {y} (i , ne) =
  w .push i ,
  λ p → ne (sym (w .keep i x) ∙ p ∙ w .keep i y)

-- Adjoining one observation to a field.
extend : (O : Obs X V) → (X → V) → Obs X V
extend O f .Index = O .Index ⊎ Unit
extend O f .read (inl i) = O .read i
extend O f .read (inr _) = f

extend-⊒ : (O : Obs X V) (f : X → V) → O ⊑ extend O f
extend-⊒ O f .push = inl
extend-⊒ O f .keep _ _ = refl

------------------------------------------------------------------------
-- C.  `Obs_𝒪 = 0 ⇏ Obs_{𝒪⁺} = 0`, twice: once concretely, once in general.

-- C1.  The live instance, and the reason this module exists.
--
-- `diag(1,-6)` where the Lean gate demands nonnegative invariants.  Under the
-- field the divisibility theory actually uses -- absolute value, because `∣`
-- over ℤ factors through `abs` -- the two answers are indistinguishable.  Add
-- the identity observation and they separate.  Nothing about the object
-- changed; the field did.

absField : Obs ℤ ℤ
absField .Index = Unit
absField .read _ = absℤ

signField : Obs ℤ ℤ
signField = extend absField (λ z → z)

absField⊑signField : absField ⊑ signField
absField⊑signField = extend-⊒ absField (λ z → z)

-- Six and minus six are invisible to the divisibility field.
sign-blind : Blind absField (pos 6) (negsuc 5)
sign-blind (_ , ne) = ne refl

-- And visible to the widened one.
sign-seen : Sep signField (pos 6) (negsuc 5)
sign-seen = inr tt , posNotnegsuc 6 5

-- So completeness relative to a field is not completeness.
Φ-creates : Σ[ P ∈ Obs ℤ ℤ ]
              ((absField ⊑ P) × (Blind absField (pos 6) (negsuc 5) × Sep P (pos 6) (negsuc 5)))
Φ-creates = signField , absField⊑signField , sign-blind , sign-seen

-- C2.  `0 ⇏ अन्तः`, in general.
--
-- PRIOR ART.  `ChuAdvance` states this content first and states
-- it better: "the defect of a Chu space is monotone in the test list ... a
-- vanishing defect is a statement about 𝒯, never about X".  It carries
-- `Shrink(𝒯) ⇒ δ↓` and the base-flat/fibre-curved separation, neither of which
-- is here.  I did not check the directory before writing this and only found
--
-- What `break-blindness` adds is small and worth keeping distinct: `ChuAdvance`
-- shows the empty test list makes every pair agree, so `δ = 0` is uninformative
-- at the bottom.  This shows the *other* end -- that from ANY field, however
-- rich, a widening exists that separates any two genuinely distinct points.
-- Neither end follows from the other: one says blindness is cheap to have, this
-- says it is always possible to lose.
--
-- Saturation is never a property of the object alone.  For *any* field, any
-- two genuinely distinct points, and any two distinct values to report, there
-- is a widening that separates them.  So `Blind` can always be broken, and a
-- machine that stops when its current field reports no obstruction has
-- concluded something about its field and nothing about its object.

charAt : (dec : Discrete X) (x : X) (a b : V) → X → V
charAt dec x a b z with dec z x
... | yes _ = a
... | no _ = b

charAt-here : (dec : Discrete X) (x : X) (a b : V)
            → charAt dec x a b x ≡ a
charAt-here dec x a b with dec x x
... | yes _ = refl
... | no ¬p = Empty.rec (¬p refl)

charAt-there : (dec : Discrete X) (x y : X) (a b : V)
             → ¬ (y ≡ x)
             → charAt dec x a b y ≡ b
charAt-there dec x y a b y≢x with dec y x
... | yes p = Empty.rec (y≢x p)
... | no _ = refl

-- Any blindness is removable.
break-blindness :
    (O : Obs X V) (dec : Discrete X)
    (a b : V) (a≢b : ¬ (a ≡ b))
    (x y : X) (x≢y : ¬ (y ≡ x))
  → Σ[ P ∈ Obs X V ] ((O ⊑ P) × Sep P x y)
break-blindness O dec a b a≢b x y y≢x =
  extend O (charAt dec x a b) ,
  extend-⊒ O (charAt dec x a b) ,
  ( inr tt
  , λ p → a≢b (sym (charAt-here dec x a b)
             ∙ p
             ∙ charAt-there dec x y a b y≢x) )

------------------------------------------------------------------------
-- D.  `प्रथमं वर्गीकुरु; पश्चात् Γ` -- classify, then repair.

data Kind : Type₀ where
  Γ∅ Γ⇑ Γ↺ Γ^ : Kind

-- A defect is not a raw inequality: it is a *witnessed* separation together
-- with a decision about what kind of defect it is.  This is the encoding of
-- the discipline: `Repair` below consumes a `Classified`, so there is no term
-- of repair type that has not been classified first.
record Classified (O : Obs X V) (x y : X) : Type₀ where
  constructor classify
  field
    kind : Kind
    witness : Sep O x y

open Classified

-- `Γ∅`: identify the two, keeping no representative.
record Collapse (x y : X) : Type₁ where
  constructor collapse
  field
    Target : Type₀
    quot : X → Target
    identifies : quot x ≡ quot y

-- `Γ^`: complete to a chosen representative.  Idempotence is what makes it a
-- choice of representatives rather than a further move -- `∂X̂ ≃ 0` in the
-- document, `absℤ-idem` in ours.
record Completion (x y : X) : Type₀ where
  constructor complete
  field
    norm : X → X
    idem : (z : X) → norm (norm z) ≡ norm z
    resolves : norm x ≡ norm y

-- The repair available for a classified defect.  The type depends on the
-- kind, which is what forces classification to come first.
Repair : {O : Obs X V} {x y : X} → Classified O x y → Type₁
Repair {x = x} {y = y} c with c .kind
... | Γ∅ = Collapse x y
... | Γ^ = Lift (Completion x y)
-- `Γ⇑` promotes the defect to a 2-cell and `Γ↺` retains it as a class.  Both
-- are `Γ∅` after 0-truncation; distinguishing them is what the higher
-- structure is for, and this module has none.  They are not silently
-- collapsed -- they are given the same repair type, openly.
... | Γ⇑ = Collapse x y
... | Γ↺ = Collapse x y

-- A completion always yields a collapse: take the target to be `X` itself and
-- the quotient map to be the normalizer.
Completion→Collapse : {x y : X} → Completion x y → Collapse x y
Completion→Collapse {X = X} co =
  collapse X (Completion.norm co) (Completion.resolves co)

-- The converse is not provided, and the omission is the content: a collapse
-- gives the quotient, a completion gives a section of it.  `Γ^` is strictly
-- more information than `Γ∅`, which is why the document orders them and why
-- `SmithSignNormal` implements `Γ^`.

-- The sign defect, classified and repaired.
signDefect : Classified signField (pos 6) (negsuc 5)
signDefect = classify Γ^ sign-seen

signCompletion : Completion (pos 6) (negsuc 5)
signCompletion = complete absℤ absℤ-idem refl

signRepair : Repair signDefect
signRepair = lift signCompletion

------------------------------------------------------------------------
-- E.  `जननीयता ≢ पुनर्निर्मेयता`.
--
-- For a view `q : X → Y`, the document's two obstructions are
-- `δ◁ = cofib(hocolim 𝔐ᵢ → X)` and `δ▷ = fib(X → holim 𝔐ᵢ)`.  Decategorified,
-- `δ◁ = 0` is "the relations generate" and `δ▷ = 0` is "the relations
-- reconstruct".  They are independent, and both witnesses are below.

Generates : {X Y : Type₀} → (X → Y) → Type₀
Generates {X = X} {Y = Y} q = (y : Y) → Σ[ x ∈ X ] q x ≡ y

Reconstructs : {X Y : Type₀} → (X → Y) → Type₀
Reconstructs {X = X} q = (x x' : X) → q x ≡ q x' → x ≡ x'

-- Generates but does not reconstruct: the constant view of a two-state world.
forget : Bool → Unit
forget _ = tt

forget-generates : Generates forget
forget-generates _ = true , refl

forget-not-reconstructs : ¬ (Reconstructs forget)
forget-not-reconstructs r = true≢false (r true false refl)

-- Reconstructs but does not generate: a single state observed in a two-state
-- language.
name : Unit → Bool
name _ = true

name-reconstructs : Reconstructs name
name-reconstructs x x' _ = isPropUnit x x'

name-not-generates : ¬ (Generates name)
name-not-generates g = true≢false (g false .snd)

-- Neither obstruction implies the other.
generability≢reconstructibility :
    (Σ[ q ∈ (Bool → Unit) ] (Generates q × (¬ (Reconstructs q))))
  × (Σ[ q ∈ (Unit → Bool) ] (Reconstructs q × (¬ (Generates q))))
generability≢reconstructibility =
    (forget , forget-generates , forget-not-reconstructs)
  , (name , name-reconstructs , name-not-generates)
