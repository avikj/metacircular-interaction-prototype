{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ObstructionCalculus
--
-- The machine-checked fragment of `papers/hieroglyphics_ii.tex`.
--
-- The document's central structural claim is that Î¦ does not change the
-- object -- `Î¦ â‰  àµàààààà°à¿àµà°ààà¨à®à` -- but widens the field of visible
-- distinctions, `Î¦ = à¦àààà¯ààà¦à•àààààà°àµà¿àààà¾à°à`, and that consequently
--
--     Obs_{ğ’Î}(X) = 0   â   Obs_{ğ’Î+1}(X) = 0.
--
-- That non-implication is the part with content, it is the part this
-- repository has twice been bitten by, and it is provable here rather than
-- asserted.  Sections A--C do it.
--
-- Section D is the discipline `ààà°àà®à àµà°àà—àà•àà°à; ààààà¾àà Î“` -- classify the
-- defect before repairing it -- encoded the only way a proof assistant can
-- encode a methodological rule: the classification is an *argument* to the
-- repair, so an unclassified repair does not typecheck.
--
-- Section E is `àà¨à¨àà¯àà¾ â‰ ààà¨à°àà¨à¿à°àà®àà¯àà¾`: generability and
-- reconstructibility are independent, with both witnesses.
------------------------------------------------------------------------

module ObstructionCalculus where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc ; posNotnegsuc)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)

open import SmithSignNormal using (absâ„¤ ; absâ„¤-idem)

private
  variable
    X V : Typeâ‚€

------------------------------------------------------------------------
-- A.  Observation fields, and the two things one can say about a pair.

-- A field of observations on `X` with values in `V`.  This is `ğ’`.
record Obs (X V : Typeâ‚€) : Typeâ‚ where
  constructor obs
  field
    Index : Typeâ‚€
    read : Index â†’ X â†’ V

open Obs

-- `Sep ğ’ x y` is a *witness* that the field distinguishes `x` from `y`: a
-- named observation together with a proof that its two readings differ.  This
-- is the repository's own notion -- `natural_crystal` keeps exactly this
-- witness, and keeps the shortest one.
Sep : Obs X V â†’ X â†’ X â†’ Typeâ‚€
Sep O x y = Î£[ i âˆˆ O .Index ] (Â¬ (O .read i x â‰¡ O .read i y))

-- Blindness is the *absence* of such a witness.  `Obs_ğ’(X) = 0` in the
-- document's notation, for the pair `x , y`.
Blind : Obs X V â†’ X â†’ X â†’ Typeâ‚€
Blind O x y = Â¬ Sep O x y

------------------------------------------------------------------------
-- B.  Î¦: widening the field, not changing the object.

-- `O âŠ P` says `P` sees everything `O` sees, reading it the same way.  Note
-- that `X` is fixed: the object does not move.
record _âŠ‘_ (O P : Obs X V) : Typeâ‚€ where
  constructor widen
  field
    push : O .Index â†’ P .Index
    keep : (i : O .Index) (z : X) â†’ P .read (push i) z â‰¡ O .read i z

open _âŠ‘_

-- Distinctions survive widening.  This direction is the easy one, and it is
-- the only direction that holds.
Î¦-monotone : {O P : Obs X V} â†’ O âŠ‘ P â†’ {x y : X}
           â†’ Sep O x y â†’ Sep P x y
Î¦-monotone {O = O} {P = P} w {x} {y} (i , ne) =
  w .push i ,
  Î» p â†’ ne (sym (w .keep i x) âˆ™ p âˆ™ w .keep i y)

-- Adjoining one observation to a field.
extend : (O : Obs X V) â†’ (X â†’ V) â†’ Obs X V
extend O f .Index = O .Index âŠ Unit
extend O f .read (inl i) = O .read i
extend O f .read (inr _) = f

extend-âŠ’ : (O : Obs X V) (f : X â†’ V) â†’ O âŠ‘ extend O f
extend-âŠ’ O f .push = inl
extend-âŠ’ O f .keep _ _ = refl

------------------------------------------------------------------------
-- C.  `Obs_ğ’ = 0 â Obs_{ğ’âº} = 0`, twice: once concretely, once in general.

-- C1.  The live instance, and the reason this module exists.
--
-- `diag(1,-6)` where the Lean gate demands nonnegative invariants.  Under the
-- field the divisibility theory actually uses -- absolute value, because `âˆ`
-- over â factors through `abs` -- the two answers are indistinguishable.  Add
-- the identity observation and they separate.  Nothing about the object
-- changed; the field did.

absField : Obs â„¤ â„¤
absField .Index = Unit
absField .read _ = absâ„¤

signField : Obs â„¤ â„¤
signField = extend absField (Î» z â†’ z)

absFieldâŠ‘signField : absField âŠ‘ signField
absFieldâŠ‘signField = extend-âŠ’ absField (Î» z â†’ z)

-- Six and minus six are invisible to the divisibility field.
sign-blind : Blind absField (pos 6) (negsuc 5)
sign-blind (_ , ne) = ne refl

-- And visible to the widened one.
sign-seen : Sep signField (pos 6) (negsuc 5)
sign-seen = inr tt , posNotnegsuc 6 5

-- So completeness relative to a field is not completeness.
Î¦-creates : Î£[ P âˆˆ Obs â„¤ â„¤ ]
              ((absField âŠ‘ P) Ã— (Blind absField (pos 6) (negsuc 5) Ã— Sep P (pos 6) (negsuc 5)))
Î¦-creates = signField , absFieldâŠ‘signField , sign-blind , sign-seen

-- C2.  `0 â àà¨ààà`, in general.
--
-- PRIOR ART.  `ChuAdvance` states this content first and states
-- it better: "the defect of a Chu space is monotone in the test list ... a
-- vanishing defect is a statement about ğ’¯, never about X".  It carries
-- `Shrink(ğ’¯) â’ Î´â“` and the base-flat/fibre-curved separation, neither of which
-- is here.  I did not check the directory before writing this and only found
--
-- What `break-blindness` adds is small and worth keeping distinct: `ChuAdvance`
-- shows the empty test list makes every pair agree, so `Î´ = 0` is uninformative
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

charAt : (dec : Discrete X) (x : X) (a b : V) â†’ X â†’ V
charAt dec x a b z with dec z x
... | yes _ = a
... | no _ = b

charAt-here : (dec : Discrete X) (x : X) (a b : V)
            â†’ charAt dec x a b x â‰¡ a
charAt-here dec x a b with dec x x
... | yes _ = refl
... | no Â¬p = Empty.rec (Â¬p refl)

charAt-there : (dec : Discrete X) (x y : X) (a b : V)
             â†’ Â¬ (y â‰¡ x)
             â†’ charAt dec x a b y â‰¡ b
charAt-there dec x y a b yâ‰¢x with dec y x
... | yes p = Empty.rec (yâ‰¢x p)
... | no _ = refl

-- Any blindness is removable.
break-blindness :
    (O : Obs X V) (dec : Discrete X)
    (a b : V) (aâ‰¢b : Â¬ (a â‰¡ b))
    (x y : X) (xâ‰¢y : Â¬ (y â‰¡ x))
  â†’ Î£[ P âˆˆ Obs X V ] ((O âŠ‘ P) Ã— Sep P x y)
break-blindness O dec a b aâ‰¢b x y yâ‰¢x =
  extend O (charAt dec x a b) ,
  extend-âŠ’ O (charAt dec x a b) ,
  ( inr tt
  , Î» p â†’ aâ‰¢b (sym (charAt-here dec x a b)
             âˆ™ p
             âˆ™ charAt-there dec x y a b yâ‰¢x) )

------------------------------------------------------------------------
-- D.  `ààà°àà®à àµà°àà—àà•àà°à; ààààà¾àà Î“` -- classify, then repair.

data Kind : Typeâ‚€ where
  Î“âˆ… Î“â‡‘ Î“â†º Î“^ : Kind

-- A defect is not a raw inequality: it is a *witnessed* separation together
-- with a decision about what kind of defect it is.  This is the encoding of
-- the discipline: `Repair` below consumes a `Classified`, so there is no term
-- of repair type that has not been classified first.
record Classified (O : Obs X V) (x y : X) : Typeâ‚€ where
  constructor classify
  field
    kind : Kind
    witness : Sep O x y

open Classified

-- `Î“âˆ`: identify the two, keeping no representative.
record Collapse (x y : X) : Typeâ‚ where
  constructor collapse
  field
    Target : Typeâ‚€
    quot : X â†’ Target
    identifies : quot x â‰¡ quot y

-- `Î“^`: complete to a chosen representative.  Idempotence is what makes it a
-- choice of representatives rather than a further move -- `âˆXÌ â‰ 0` in the
-- document, `absâ-idem` in ours.
record Completion (x y : X) : Typeâ‚€ where
  constructor complete
  field
    norm : X â†’ X
    idem : (z : X) â†’ norm (norm z) â‰¡ norm z
    resolves : norm x â‰¡ norm y

-- The repair available for a classified defect.  The type depends on the
-- kind, which is what forces classification to come first.
Repair : {O : Obs X V} {x y : X} â†’ Classified O x y â†’ Typeâ‚
Repair {x = x} {y = y} c with c .kind
... | Î“âˆ… = Collapse x y
... | Î“^ = Lift (Completion x y)
-- `Î“â` promotes the defect to a 2-cell and `Î“âº` retains it as a class.  Both
-- are `Î“âˆ` after 0-truncation; distinguishing them is what the higher
-- structure is for, and this module has none.  They are not silently
-- collapsed -- they are given the same repair type, openly.
... | Î“â‡‘ = Collapse x y
... | Î“â†º = Collapse x y

-- A completion always yields a collapse: take the target to be `X` itself and
-- the quotient map to be the normalizer.
Completionâ†’Collapse : {x y : X} â†’ Completion x y â†’ Collapse x y
Completionâ†’Collapse {X = X} co =
  collapse X (Completion.norm co) (Completion.resolves co)

-- The converse is not provided, and the omission is the content: a collapse
-- gives the quotient, a completion gives a section of it.  `Î“^` is strictly
-- more information than `Î“âˆ`, which is why the document orders them and why
-- `SmithSignNormal` implements `Î“^`.

-- The sign defect, classified and repaired.
signDefect : Classified signField (pos 6) (negsuc 5)
signDefect = classify Î“^ sign-seen

signCompletion : Completion (pos 6) (negsuc 5)
signCompletion = complete absâ„¤ absâ„¤-idem refl

signRepair : Repair signDefect
signRepair = lift signCompletion

------------------------------------------------------------------------
-- E.  `àà¨à¨àà¯àà¾ â‰ ààà¨à°àà¨à¿à°àà®àà¯àà¾`.
--
-- For a view `q : X â’ Y`, the document's two obstructions are
-- `Î´â— = cofib(hocolim ğ”µ â’ X)` and `Î´â– = fib(X â’ holim ğ”µ)`.  Decategorified,
-- `Î´â— = 0` is "the relations generate" and `Î´â– = 0` is "the relations
-- reconstruct".  They are independent, and both witnesses are below.

Generates : {X Y : Typeâ‚€} â†’ (X â†’ Y) â†’ Typeâ‚€
Generates {X = X} {Y = Y} q = (y : Y) â†’ Î£[ x âˆˆ X ] q x â‰¡ y

Reconstructs : {X Y : Typeâ‚€} â†’ (X â†’ Y) â†’ Typeâ‚€
Reconstructs {X = X} q = (x x' : X) â†’ q x â‰¡ q x' â†’ x â‰¡ x'

-- Generates but does not reconstruct: the constant view of a two-state world.
forget : Bool â†’ Unit
forget _ = tt

forget-generates : Generates forget
forget-generates _ = true , refl

forget-not-reconstructs : Â¬ (Reconstructs forget)
forget-not-reconstructs r = trueâ‰¢false (r true false refl)

-- Reconstructs but does not generate: a single state observed in a two-state
-- language.
name : Unit â†’ Bool
name _ = true

name-reconstructs : Reconstructs name
name-reconstructs x x' _ = isPropUnit x x'

name-not-generates : Â¬ (Generates name)
name-not-generates g = trueâ‰¢false (g false .snd)

-- Neither obstruction implies the other.
generabilityâ‰¢reconstructibility :
    (Î£[ q âˆˆ (Bool â†’ Unit) ] (Generates q Ã— (Â¬ (Reconstructs q))))
  Ã— (Î£[ q âˆˆ (Unit â†’ Bool) ] (Reconstructs q Ã— (Â¬ (Generates q))))
generabilityâ‰¢reconstructibility =
    (forget , forget-generates , forget-not-reconstructs)
  , (name , name-reconstructs , name-not-generates)
