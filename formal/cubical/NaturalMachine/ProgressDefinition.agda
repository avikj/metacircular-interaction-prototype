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
-- NaturalMachine.ProgressDefinition
--
-- GAP D of `notes/GENERATIVE_MODULES_AUDIT.md`, closed.
--
-- The audit's finding, verbatim:
--
--   "`A0`-`B4` and `T5`-`T10` mention `residual` and nothing else: not
--    `witness`, not `body`, not `unfold`, not `T1`/`T2`.  Every progress
--    theorem in both modules holds verbatim for a proposer that installs
--    a head and generates NO DEFINITION AT ALL."
--
-- What is needed to close it is not another theorem about definitions
-- standing beside the progress theorems — `Obstruction` T1/T2 and
-- `WitnessPolicy` P1/P2 are already that — but a PROGRESS statement in
-- which the generated body is load-bearing, i.e. one that is FALSE for a
-- proposer generating nothing.  This file lands both halves: the measure
-- identity that lets a body enter a progress statement at all (§1-§2),
-- and the separating statement together with its negative control
-- (§3-§6).
--
-- Location: a separate module, not an extension of `GenerativeLoop`,
-- because the separation needs `NaturalMachine.WitnessPolicy` (`size`,
-- `inform`, `degenerate`, `degenerate-never-grows`) and WitnessPolicy
-- imports GenerativeLoop.  Putting it in GenerativeLoop would be a cycle.
--
-- Substrate: exactly `Obstruction` + `GenerativeLoop` + `WitnessPolicy`.
-- Nothing new is axiomatised; the only new definitions are `Expands`,
-- `Null`, `AllNull` and `totalBody`.
--
--
-- WHAT IS CHECKED
--
-- D0.  The body enters the measure (§1).
--
--   `plug-deficit`          deficit V (plug b u) ≡ deficit V b + deficit V u.
--   `unfold-deficit-split`  FOR ANY BASE BODY b:
--                             deficit V t ≡ gaps d V t + deficit V (unfold d b t).
--                           The exact analogue of `GenerativeLoop.
--                           deficit-split` on the DEFINITIONAL side:
--                           expanding the generated definition in the
--                           target removes exactly the d-labelled gaps
--                           and nothing else.  `Over V b` is load-bearing
--                           (through `Over→deficit0`); this is the first
--                           statement in the development in which a
--                           progress quantity is computed FROM a body.
--   `install-unfold-agree`  deficit (d ∷ V) t ≡ deficit V (unfold d b t).
--                           Installing the head and expanding its
--                           definition make exactly the same progress —
--                           the two halves the audit says never meet,
--                           met, as an equation.  (`inj-m+` on D0.)
--
-- D1.  The audit's own proposed closing theorem, verbatim (§2).
--
--   `unfold-progress`       deficit V (unfold (residual o) (witness o) t)
--                             < deficit V t, for any obstruction whose
--                           residual occurs uncovered in the target.
--   `generative-step-unfolds`
--                           the audit's statement, character for
--                           character:
--                             Over V t ⊎ Σ[ o ] ( deficit (extend V o) t
--                                                   < deficit V t
--                                               × deficit V (unfold …) t
--                                                   < deficit V t ).
--                           It checks.
--
-- D2.  ...AND IT DOES NOT SEPARATE (§2).  This is a correction to the
--      audit, not a confirmation of it.
--
--   `generative-step-unfolds-null`
--                           the same statement, with the obstruction's
--                           body pinned to `var` — the null policy of
--                           `WitnessPolicy.degenerate`, the proposer that
--                           generates no definition.  It satisfies D1
--                           too.  Reason, once seen, is forced:
--                           `unfold-deficit-split` holds for EVERY base
--                           body, `var` included, so no `deficit`
--                           statement can distinguish bodies.  The
--                           measure that closes gap D cannot be `deficit`.
--
-- D3.  The separating measure (§3).  It is `size`, and the dividing line
--      is whether expanding the generated definition in the target
--      RETAINS the target's structure.
--
--   `unfold-mono`           0 < size b → size t ≤ size (unfold d b t).
--   `unfold-grows`          1 < size b → the residual occurs uncovered in
--                           t → size t < size (unfold d b t).
--   `null-unfold-shrinks`   the residual occurs uncovered in t →
--                             size (unfold d var t) < size t.
--                           STRICT LOSS, not merely "no gain": the
--                           sharpening of `WitnessPolicy.degenerate-
--                           never-grows` that the separation needs.
--   `Expands V o t`         size t < size (unfold (residual o) (witness o) t)
--                           — "the generated definition expands the
--                           target".
--   `inform-expands`        the informative policy satisfies it (payload
--                           of size > 1).
--   `null-never-expands`    the null policy provably CANNOT: ¬ Expands.
--
-- D4.  THE CLOSING THEOREM (§4).
--
--   `defining-step`         the generative step, with the definitional
--                           progress attached: for every V and t, either
--                           V covers t, or the loop reads an obstruction
--                           that is (i) informative, (ii) drops the
--                           deficit — `GenerativeLoop.B2` — (iii) drops
--                           it again under unfolding — D1 — and (iv)
--                           EXPANDS the target.  (iv) is the component
--                           that mentions the body irremovably.
--   `null-step`             the same probe, the same residual, the null
--                           policy: (i) (ii) (iii) hold verbatim, and
--                           `¬ Expands` — the fourth component FAILS, as
--                           a checked negation.
--   `definitional-separation`
--                           both in one term: two obstructions with the
--                           SAME residual, hence the same extension, the
--                           same matcher, the same deficit drop, the same
--                           unfolding drop; and opposite truth values of
--                           `Expands`.  This is the statement gap D asks
--                           for: it is false for a proposer that
--                           generates nothing, and everything the two
--                           modules already proved is true of both.
--
-- D5.  The null proposer is a real proposer (§5) — the negative control
--      at loop scale, so that "the null proposer satisfies the existing
--      progress theorems" is checked and not asserted.
--
--   `null-step₀`, `AllNull`, `null-loop`, `null-generative-loop`
--                           `GenerativeLoop.B2`-`B4` re-run with every
--                           body pinned to `var`: same measure, same
--                           bound `chainLen ch ≤ deficit V t`, no step
--                           lost.
--   `null-loop-drops-in`    forgetting nullity returns `generative-loop`'s
--                           conclusion verbatim — so the null proposer
--                           does discharge B3-B4, checked, not asserted.
--                           (That NO theorem of §§A-B distinguishes the
--                           two is a reading of those statements, not a
--                           theorem of this file; see NOT CLAIMED.)
--   `totalBody`             the chain measure the audit's list is
--                           missing: the total size of the bodies a chain
--                           generated.
--   `null-chain-generates-nothing`
--                           AllNull ch → totalBody ch ≡ 0.  Uniform, over
--                           every chain, of every length: the null
--                           proposer's definitional output is zero.
--   `totalBody-step-null`   and it never moves: totalBody (step ch o) ≡
--                           totalBody ch on a null step.
--   `informative-step-grows`
--                           against that: an informative step with a
--                           non-empty payload STRICTLY increases
--                           totalBody.
--
-- D6.  Sharpness and non-vacuity (§6).
--
--   `trivial-payload-collapses`
--                           the hypothesis `0 < size (arg o)` is
--                           necessary and not an artefact: when the
--                           payload IS the bare parameter the two
--                           policies have the same body, so NO property
--                           whatsoever separates them there.
--   `SeparationExample.o₁`, `.ex-informative`, `.ex-null`,
--   `.ex-size-informative`, `.ex-size-null`, `.ex-same-decrease`
--                           an explicit vocabulary, target and
--                           obstruction with the hypothesis satisfied,
--                           the two unfolded sizes computed by `refl`
--                           (4 against 2, from a target of size 3), and
--                           the separation instantiated.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * NOT claimed: that the audit's proposed theorem closes gap D.  It is
--    landed here (D1) and then REFUTED as a separator (D2): it is
--    satisfied by the null proposer, because `unfold-deficit-split`
--    holds for every base body.  The audit's §4-D suggestion is correct
--    as mathematics and insufficient as a closure; that is a finding of
--    this module against the note, recorded in the note's gap-D entry.
--  * NOT claimed: that `Expands` is canonical, or that it is the only
--    definitional progress measure, or that it is optimal.  It is one
--    property that is (a) about the generated bodies, (b) true of the
--    informative policy, (c) provably false of the null one.  Those
--    three are what gap D asks for; nothing more is argued.
--  * NOT claimed: that `Expands` holds unconditionally.  It needs
--    `1 < size (arg o)` for strictness (`0 < size (arg o)` for the
--    non-strict form), and that hypothesis is SHARP, not conservative:
--    `trivial-payload-collapses` shows the two policies generate
--    literally the same body when the payload is `var`, so no separation
--    is available there and none is claimed.  In particular
--    `defining-step`'s fourth component is stated as an implication from
--    that hypothesis, not as a fact about every target.
--  * NOT claimed: any chain-level or loop-level form of `Expands`.  The
--    closing theorem is per-step.  What is chain-level is `totalBody`
--    and its null control; the loop's own chain is opaque (the bodies it
--    installs depend on the order the probe reads the target), and no
--    lower bound on `totalBody` of `generative-loop`'s output is proved
--    or claimed.
--  * NOT claimed, as a theorem: that NO theorem of `Obstruction` §§6-9
--    or `GenerativeLoop` §§A-B distinguishes the two proposers.  That is
--    a statement ABOUT the corpus, of the kind `AcceptanceTest`'s
--    refuted "delete T and `replay` has no proof" was, and Agda does not
--    judge it.  What IS checked is the direction that matters: the two
--    obstructions have the same `residual` (`definitional-separation`'s
--    first component, `refl`), hence definitionally the same `extend`,
--    `Matches`, `Over` and `deficit`; and the null one discharges B2-B4
--    (§5).  The reader may confirm by inspection that every statement in
--    those sections mentions only `residual`; the audit already did.
--  * NOT claimed: that the informative policy enlarges the matchable
--    set.  It provably does not — `WitnessPolicy.policies-agree-on-
--    matching` — and that is exactly why gap D was open: matching,
--    coverage and `deficit` are all blind to the body.  `size` under
--    `unfold` is the first quantity in the development that is not.
--  * NOT claimed: that `size` measures anything in
--    `runtime/vocabulary/`.  It is the node count of a `Tm`
--    (`size var = 0`), as in `WitnessPolicy`.
--  * `Null o = witness o ≡ var` is this substrate's rendering of
--    "generates no definition at all".  It is a rendering: the record
--    `Obstruction` has no way to omit a body, so the null proposer is the
--    one whose body is the parameter, i.e. whose definition is the
--    identity abbreviation `d x := x`.  `degenerate-never-grows` and
--    `null-unfold-shrinks` are what justify calling that "nothing".
--  * Everything inherited from `Obstruction`'s, `GenerativeLoop`'s and
--    `WitnessPolicy`'s disclaimers stands: single-parameter bodies,
--    matching only at the root, no arity structure in the residual,
--    gates D2-D7 unmodelled, `compile` stipulated, no provability
--    relation anywhere.
------------------------------------------------------------------------

module NaturalMachine.ProgressDefinition where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-assoc ; +-comm ; inj-m+ ; znots ; snotz)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-refl ; ≤-suc ; ≤-trans ; ≤-+-≤ ; ≤SumRight ; zero-≤
        ; suc-≤-suc ; pred-≤-pred ; <-trans ; <-weaken ; <-k+ ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Obstruction
open Obstruction
open Extension

open import NaturalMachine.GenerativeLoop
open import NaturalMachine.WitnessPolicy

------------------------------------------------------------------------
-- 1.  D0.  THE BODY ENTERS THE MEASURE.
--
-- `GenerativeLoop.deficit-split` is the naming-side accounting:
--
--     deficit V t  ≡  gaps s V t  +  deficit (s ∷ V) t
--
-- installing s removes exactly the s-labelled gaps.  Here is the
-- definitional-side accounting, which nothing in the development had:
--
--     deficit V t  ≡  gaps d V t  +  deficit V (unfold d b t)
--
-- EXPANDING the generated definition removes exactly the same gaps.  The
-- body's legality (`Over V b`, gate D4 — for a proposal, the
-- obstruction's own `witnessBase`) is what makes the accounting exact:
-- an illegal body would contribute deficit of its own.
------------------------------------------------------------------------

plug-deficit : (V : Vocab) (b u : Tm) → deficit V (plug b u) ≡ deficit V b + deficit V u
plug-deficit V var        u = refl
plug-deficit V (node c b) u =
    cong (delta V c +_) (plug-deficit V b u)
  ∙ +-assoc (delta V c) (deficit V b) (deficit V u)

private
  swap13 : (a g x : ℕ) → a + (g + x) ≡ g + (a + x)
  swap13 a g x =
      +-assoc a g x
    ∙ cong (_+ x) (+-comm a g)
    ∙ sym (+-assoc g a x)

unfold-deficit-split : (V : Vocab) (d : Shape) (b : Tm) → Over V b
                     → (t : Tm) → deficit V t ≡ gaps d V t + deficit V (unfold d b t)
unfold-deficit-split V d b bB var        = refl
unfold-deficit-split V d b bB (node c u) = go (dichotomyBool (eqℕ c d))
  where
  ih : deficit V u ≡ gaps d V u + deficit V (unfold d b u)
  ih = unfold-deficit-split V d b bB u

  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → deficit V (node c u) ≡ gaps d V (node c u) + deficit V (unfold d b (node c u))
  go (inl e) =
      cong (delta V c +_) ih
    ∙ +-assoc (delta V c) (gaps d V u) (deficit V (unfold d b u))
    ∙ sym ( cong₂ _+_
              (cong (_+ gaps d V u) (if≡true {x = delta V c} {y = 0} e))
              ( cong (deficit V) (unfold-hit d b c u e)
              ∙ plug-deficit V b (unfold d b u)
              ∙ cong (_+ deficit V (unfold d b u)) (Over→deficit0 V b bB) ) )
  go (inr e) =
      cong (delta V c +_) ih
    ∙ swap13 (delta V c) (gaps d V u) (deficit V (unfold d b u))
    ∙ sym ( cong₂ _+_
              (cong (_+ gaps d V u) (if≡false {x = delta V c} {y = 0} e))
              (cong (deficit V) (unfold-miss d b c u e)) )

-- The two halves the audit says never meet, met, as an equation:
-- installing the head and expanding its definition make EXACTLY the same
-- progress on the target.
install-unfold-agree : (V : Vocab) (d : Shape) (b : Tm) → Over V b
                     → (t : Tm) → deficit (d ∷ V) t ≡ deficit V (unfold d b t)
install-unfold-agree V d b bB t =
  inj-m+ (sym (deficit-split d V t) ∙ unfold-deficit-split V d b bB t)

------------------------------------------------------------------------
-- 2.  D1 and D2.  The audit's proposed closing theorem — landed, then
--     refuted as a SEPARATOR.
--
-- D1 is exactly `notes/GENERATIVE_MODULES_AUDIT.md` §4-D's
-- `generative-step-unfolds`.  It checks.  D2 is the reason it does not
-- close the gap: `unfold-deficit-split` was proved for EVERY base body,
-- and `var` is a base body, so the null proposer satisfies D1 verbatim.
-- No statement built from `deficit` alone can separate the policies,
-- because `install-unfold-agree` makes the unfolded measure a function
-- of the residual alone.
------------------------------------------------------------------------

unfold-progress : (V : Vocab) (o : Obstruction V) (t : Tm) → Occurs (residual o) V t
                → deficit V (unfold (residual o) (witness o) t) < deficit V t
unfold-progress V o t occ =
  subst (_< deficit V t)
        (install-unfold-agree V (residual o) (witness o) (witnessBase o) t)
        (occurs→decreases (residual o) V t occ)

-- THE AUDIT'S STATEMENT, verbatim.
generative-step-unfolds :
  (V : Vocab) (t : Tm)
  → Over V t ⊎ (Σ[ o ∈ Obstruction V ]
       ( (deficit (extend V o) t < deficit V t)
       × (deficit V (unfold (residual o) (witness o) t) < deficit V t) ))
generative-step-unfolds V t = read (probe V t)
  where
  read : Probe V t
       → Over V t ⊎ (Σ[ o ∈ Obstruction V ]
            ( (deficit (extend V o) t < deficit V t)
            × (deficit V (unfold (residual o) (witness o) t) < deficit V t) ))
  read (covered h) = inl h
  read (gap o occ) =
    inr (o , occurs→decreases (residual o) V t occ , unfold-progress V o t occ)

-- ...and here is the same statement with the body pinned to `var`: the
-- proposer that generates no definition satisfies it too.  So D1 does
-- not close gap D.
generative-step-unfolds-null :
  (V : Vocab) (t : Tm)
  → Over V t ⊎ (Σ[ o ∈ Obstruction V ]
       ( (witness o ≡ var)
       × (deficit (extend V o) t < deficit V t)
       × (deficit V (unfold (residual o) (witness o) t) < deficit V t) ))
generative-step-unfolds-null V t = read (probe V t)
  where
  read : Probe V t
       → Over V t ⊎ (Σ[ o ∈ Obstruction V ]
            ( (witness o ≡ var)
            × (deficit (extend V o) t < deficit V t)
            × (deficit V (unfold (residual o) (witness o) t) < deficit V t) ))
  read (covered h) = inl h
  read (gap o occ) =
    inr ( degenerate V o
        , refl
        , occurs→decreases (residual o) V t occ
        , unfold-progress V (degenerate V o) t occ )

------------------------------------------------------------------------
-- 3.  D3.  THE SEPARATING MEASURE.
--
-- `deficit` counts uncovered heads and is therefore blind to bodies.
-- `size` under `unfold` is not.  The dividing line:
--
--   informative body (payload, size > 1) : expanding it in the target
--                                          STRICTLY GROWS the target;
--   null body (`var`)                    : expanding it in the target
--                                          STRICTLY SHRINKS the target.
--
-- The second is the sharpening `WitnessPolicy.degenerate-never-grows`
-- stops short of: not merely "never grows" but "always loses", as soon
-- as the residual really occurs uncovered in the target — which is
-- precisely the situation the loop's probe reports.
------------------------------------------------------------------------

unfold-mono : (d : Shape) (b : Tm) → 0 < size b
            → (t : Tm) → size t ≤ size (unfold d b t)
unfold-mono d b hb var        = ≤-refl
unfold-mono d b hb (node c u) = go (dichotomyBool (eqℕ c d))
  where
  ih : size u ≤ size (unfold d b u)
  ih = unfold-mono d b hb u

  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → size (node c u) ≤ size (unfold d b (node c u))
  go (inl e) =
    subst (λ z → size (node c u) ≤ size z) (sym (unfold-hit d b c u e))
      (subst (size (node c u) ≤_) (sym (plug-size b (unfold d b u)))
        (≤-+-≤ hb ih))
  go (inr e) =
    subst (λ z → size (node c u) ≤ size z) (sym (unfold-miss d b c u e))
      (suc-≤-suc ih)

unfold-grows : (V : Vocab) (d : Shape) (b : Tm) → 1 < size b
             → (t : Tm) → Occurs d V t → size t < size (unfold d b t)
unfold-grows V d b hb var (j , p) = Empty.rec (znots p)
unfold-grows V d b hb (node c u) (j , p) = go (dichotomyBool (eqℕ c d))
  where
  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → size (node c u) < size (unfold d b (node c u))
  go (inl e) =
    subst (λ z → size (node c u) < size z) (sym (unfold-hit d b c u e))
      (subst (size (node c u) <_) (sym (plug-size b (unfold d b u)))
        (≤-+-≤ hb (unfold-mono d b (<-weaken hb) u)))
  go (inr e) =
    subst (λ z → size (node c u) < size z) (sym (unfold-miss d b c u e))
      (suc-≤-suc (unfold-grows V d b hb u
        ( j , sym (cong (_+ gaps d V u) (if≡false {x = delta V c} {y = 0} e)) ∙ p )))

-- The null policy's exact opposite: strict LOSS wherever the residual
-- occurs uncovered.
null-unfold-shrinks : (V : Vocab) (d : Shape) (t : Tm) → Occurs d V t
                    → size (unfold d var t) < size t
null-unfold-shrinks V d var        (j , p) = Empty.rec (znots p)
null-unfold-shrinks V d (node c u) (j , p) = go (dichotomyBool (eqℕ c d))
  where
  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → size (unfold d var (node c u)) < size (node c u)
  go (inl e) =
    subst (λ z → size z < size (node c u)) (sym (unfold-hit d var c u e))
      (suc-≤-suc (degenerate-never-grows d u))
  go (inr e) =
    subst (λ z → size z < size (node c u)) (sym (unfold-miss d var c u e))
      (suc-≤-suc (null-unfold-shrinks V d u
        ( j , sym (cong (_+ gaps d V u) (if≡false {x = delta V c} {y = 0} e)) ∙ p )))

-- DEFINITIONAL PROGRESS: expanding the generated definition in the
-- target retains — indeed enlarges — the target's structure.
Expands : (V : Vocab) → Obstruction V → Tm → Type₀
Expands V o t = size t < size (unfold (residual o) (witness o) t)

inform-expands : (V : Vocab) (o : Obstruction V) → 1 < size (arg o)
               → (t : Tm) → Occurs (residual o) V t → Expands V (inform V o) t
inform-expands V o h t occ = unfold-grows V (residual o) (arg o) h t occ

null-never-expands : (V : Vocab) (o : Obstruction V) (t : Tm)
                   → Occurs (residual o) V t → ¬ Expands V (degenerate V o) t
null-never-expands V o t occ ex =
  ¬m<m (<-trans ex (null-unfold-shrinks V (residual o) t occ))

------------------------------------------------------------------------
-- 4.  D4.  THE CLOSING THEOREM.
--
-- One probe of the target; two proposals off it.  Everything
-- `GenerativeLoop` §§A-B proves is true of both — same residual, hence
-- the same extension, the same matcher, the same deficit drop — and
-- everything §2 above proves is true of both.  They differ on `Expands`,
-- and they differ there DECIDEDLY: one satisfies it, the other's
-- negation is checked.
--
-- The shared components are shared DEFINITIONALLY, not up to a path:
-- `inform` and `degenerate` change only the `witness` field, and
-- `extend V o = residual o ∷ V` reads only the residual, so the first
-- component of `definitional-separation` is `refl` and no transport
-- occurs anywhere below.
------------------------------------------------------------------------

defining-step : (V : Vocab) (t : Tm)
  → Over V t
  ⊎ ( Σ[ o ∈ Obstruction V ]
        ( Informative o
        × Occurs (residual o) V t
        × (deficit (extend V o) t < deficit V t)
        × (deficit V (unfold (residual o) (witness o) t) < deficit V t)
        × (1 < size (arg o) → Expands V o t) ) )
defining-step V t = read (probe V t)
  where
  Goal : Type₀
  Goal = Over V t
       ⊎ ( Σ[ o ∈ Obstruction V ]
             ( Informative o
             × Occurs (residual o) V t
             × (deficit (extend V o) t < deficit V t)
             × (deficit V (unfold (residual o) (witness o) t) < deficit V t)
             × (1 < size (arg o) → Expands V o t) ) )

  read : Probe V t → Goal
  read (covered h) = inl h
  read (gap o occ) =
    inr ( inform V o
        , refl
        , occ
        , occurs→decreases (residual o) V t occ
        , unfold-progress V (inform V o) t occ
        , (λ h → inform-expands V o h t occ) )

-- The same probe, the null policy: (i)-(iii) verbatim, (iv) refuted.
null-step : (V : Vocab) (t : Tm)
  → Over V t
  ⊎ ( Σ[ o ∈ Obstruction V ]
        ( (witness o ≡ var)
        × Occurs (residual o) V t
        × (deficit (extend V o) t < deficit V t)
        × (deficit V (unfold (residual o) (witness o) t) < deficit V t)
        × (¬ Expands V o t) ) )
null-step V t = read (probe V t)
  where
  Goal : Type₀
  Goal = Over V t
       ⊎ ( Σ[ o ∈ Obstruction V ]
             ( (witness o ≡ var)
             × Occurs (residual o) V t
             × (deficit (extend V o) t < deficit V t)
             × (deficit V (unfold (residual o) (witness o) t) < deficit V t)
             × (¬ Expands V o t) ) )

  read : Probe V t → Goal
  read (covered h) = inl h
  read (gap o occ) =
    inr ( degenerate V o
        , refl
        , occ
        , occurs→decreases (residual o) V t occ
        , unfold-progress V (degenerate V o) t occ
        , null-never-expands V o t occ )

-- BOTH IN ONE TERM.  Gap D, closed: `Expands` is a progress property of
-- the loop's step that is true of the informative proposer and FALSE of
-- the proposer that generates nothing, while every other component is
-- shared between them — including the residual, so the two are
-- indistinguishable by every theorem of `Obstruction` §§6-9 and
-- `GenerativeLoop` §§A-B.
definitional-separation : (V : Vocab) (t : Tm)
  → Over V t
  ⊎ ( Σ[ o ∈ Obstruction V ] Σ[ o′ ∈ Obstruction V ]
        ( (residual o ≡ residual o′)                                      -- same name
        × Informative o × (witness o′ ≡ var)                              -- opposite bodies
        × (deficit (extend V o) t < deficit V t)                          -- same naming progress
        × (deficit (extend V o′) t < deficit V t)
        × (deficit V (unfold (residual o) (witness o) t) < deficit V t)   -- same unfolded progress
        × (deficit V (unfold (residual o′) (witness o′) t) < deficit V t)
        × (1 < size (arg o) → Expands V o t)                              -- and here they part
        × (¬ Expands V o′ t) ) )
definitional-separation V t = read (probe V t)
  where
  Goal : Type₀
  Goal = Over V t
       ⊎ ( Σ[ o ∈ Obstruction V ] Σ[ o′ ∈ Obstruction V ]
             ( (residual o ≡ residual o′)
             × Informative o × (witness o′ ≡ var)
             × (deficit (extend V o) t < deficit V t)
             × (deficit (extend V o′) t < deficit V t)
             × (deficit V (unfold (residual o) (witness o) t) < deficit V t)
             × (deficit V (unfold (residual o′) (witness o′) t) < deficit V t)
             × (1 < size (arg o) → Expands V o t)
             × (¬ Expands V o′ t) ) )

  read : Probe V t → Goal
  read (covered h) = inl h
  read (gap o occ) =
    inr ( inform V o
        , degenerate V o
        , refl
        , refl
        , refl
        , occurs→decreases (residual o) V t occ
        , occurs→decreases (residual o) V t occ
        , unfold-progress V (inform V o) t occ
        , unfold-progress V (degenerate V o) t occ
        , (λ h → inform-expands V o h t occ)
        , null-never-expands V o t occ )

------------------------------------------------------------------------
-- 5.  D5.  THE NULL PROPOSER IS A REAL PROPOSER.
--
-- The separation above is only worth something if the null proposer
-- really does satisfy the existing progress theorems — otherwise
-- `Expands` would be separating a proposer from a non-proposer.  So:
-- `GenerativeLoop.B2`-`B4`, re-run with every body pinned to `var`.
-- Same measure, same bound, no step lost; and `null-loop-drops-in`
-- returns `generative-loop`'s conclusion verbatim.
--
-- Then the chain measure the development was missing: `totalBody`, the
-- total size of the bodies a chain generated.  The null proposer pins it
-- at zero, uniformly, over every chain of every length.
------------------------------------------------------------------------

Null : {V : Vocab} → Obstruction V → Type₀
Null o = witness o ≡ var

degenerate-null : (V : Vocab) (o : Obstruction V) → Null (degenerate V o)
degenerate-null V o = refl

null-step₀ : (V : Vocab) (t : Tm)
  → Over V t ⊎ (Σ[ o ∈ Obstruction V ] (Null o × (deficit (extend V o) t < deficit V t)))
null-step₀ V t = read (generative-step V t)
  where
  read : Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
       → Over V t
       ⊎ (Σ[ o ∈ Obstruction V ] (Null o × (deficit (extend V o) t < deficit V t)))
  read (inl h)         = inl h
  read (inr (o , dec)) = inr (degenerate V o , refl , dec)

AllNull : {V W : Vocab} → ObsChain V W → Type₀
AllNull done        = Unit
AllNull (step ch o) = AllNull ch × Null o

consChain-null : {V W : Vocab} (o : Obstruction V) → Null o
               → (ch : ObsChain (extend V o) W) → AllNull ch
               → AllNull (consChain o ch)
consChain-null o no done         _          = tt , no
consChain-null o no (step ch o') (ac , no') = consChain-null o no ch ac , no'

private
  ¬<zero : (n : ℕ) → ¬ (n < 0)
  ¬<zero n (k , p) = snotz (sym (+-suc k n) ∙ p)

NullReaches : Vocab → Tm → ℕ → Type₀
NullReaches V t f =
  Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
    (AllNull ch × (Over W t × (chainLen ch ≤ f)))

null-loop : (f : ℕ) (V : Vocab) (t : Tm) → deficit V t ≤ f → NullReaches V t f
null-loop zero V t h = go (null-step₀ V t)
  where
  go : Over V t
     ⊎ (Σ[ o ∈ Obstruction V ] (Null o × (deficit (extend V o) t < deficit V t)))
     → NullReaches V t 0
  go (inl cov)           = V , done , tt , cov , ≤-refl
  go (inr (o , _ , dec)) =
    Empty.rec (¬<zero (deficit (extend V o) t) (≤-trans dec h))
null-loop (suc f) V t h = go (null-step₀ V t)
  where
  go : Over V t
     ⊎ (Σ[ o ∈ Obstruction V ] (Null o × (deficit (extend V o) t < deficit V t)))
     → NullReaches V t (suc f)
  go (inl cov)            = V , done , tt , cov , zero-≤
  go (inr (o , no , dec)) =
    next (null-loop f (extend V o) t (pred-≤-pred (≤-trans dec h)))
    where
    next : NullReaches (extend V o) t f → NullReaches V t (suc f)
    next (W , ch , ac , cov , len) =
      W , consChain o ch , consChain-null o no ch ac , cov
        , subst (_≤ suc f) (sym (consChain-len o ch)) (suc-≤-suc len)

-- B4 for the null proposer: same statement, same bound.
null-generative-loop : (V : Vocab) (t : Tm)
  → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
      (AllNull ch × (Over W t × (chainLen ch ≤ deficit V t)))
null-generative-loop V t = null-loop (deficit V t) V t ≤-refl

-- ...and forgetting nullity gives `GenerativeLoop.generative-loop`'s
-- conclusion verbatim.  Every theorem of `GenerativeLoop` §§A-B is blind
-- to the difference.
null-loop-drops-in : (V : Vocab) (t : Tm)
  → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ] (Over W t × (chainLen ch ≤ deficit V t))
null-loop-drops-in V t = forget (null-generative-loop V t)
  where
  forget : (Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
              (AllNull ch × (Over W t × (chainLen ch ≤ deficit V t))))
         → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
              (Over W t × (chainLen ch ≤ deficit V t))
  forget (W , ch , _ , cov , len) = W , ch , cov , len

-- The chain measure the progress theorems never had: how much
-- definitional content the chain actually generated.
totalBody : {V W : Vocab} → ObsChain V W → ℕ
totalBody done        = 0
totalBody (step ch o) = totalBody ch + size (witness o)

null-chain-generates-nothing : {V W : Vocab} (ch : ObsChain V W)
                             → AllNull ch → totalBody ch ≡ 0
null-chain-generates-nothing done        _         = refl
null-chain-generates-nothing (step ch o) (ac , no) =
  cong₂ _+_ (null-chain-generates-nothing ch ac) (cong size no)

totalBody-step-null : {V W : Vocab} (ch : ObsChain V W) (o : Obstruction W)
                    → Null o → totalBody (step ch o) ≡ totalBody ch
totalBody-step-null ch o no =
  cong (totalBody ch +_) (cong size no) ∙ +-zero (totalBody ch)

private
  n<n+m : (n m : ℕ) → 0 < m → n < n + m
  n<n+m n m h = subst (_< n + m) (+-zero n) (<-k+ h)

-- Against that: an informative step with a non-empty payload strictly
-- increases the measure.  Strictness at the definitional level, which is
-- what the naming-level theorems (`obs-step-strict`, `anti-plateau`)
-- never had.
informative-step-grows : {V W : Vocab} (ch : ObsChain V W) (o : Obstruction W)
                       → Informative o → 0 < size (arg o)
                       → totalBody ch < totalBody (step ch o)
informative-step-grows ch o io h =
  n<n+m (totalBody ch) (size (witness o)) (subst (0 <_) (sym (cong size io)) h)

------------------------------------------------------------------------
-- 6.  D6.  SHARPNESS AND NON-VACUITY.
--
-- The payload hypothesis is not a convenience.  When the payload IS the
-- bare parameter the two policies generate literally the same body, so
-- nothing whatsoever separates them there — that is a checked equality,
-- not an unexamined case.  And the hypothesis is inhabited at a genuine
-- loop configuration: a vocabulary, a target the vocabulary does not
-- cover, and the obstruction read off it.
------------------------------------------------------------------------

trivial-payload-collapses : (V : Vocab) (o : Obstruction V) → arg o ≡ var
                          → witness (inform V o) ≡ witness (degenerate V o)
trivial-payload-collapses V o p = p

module SeparationExample where

  V₁ : Vocab
  V₁ = 0 ∷ []

  -- The target: a 3-ary-free spine whose OUTER head is missing and whose
  -- payload (two installed nodes) is what the matcher choked on.
  t₁ : Tm
  t₁ = node 1 (node 0 (node 0 var))

  o₁ : Obstruction V₁
  o₁ = record
    { residual = 1 ; arg = node 0 (node 0 var)
    ; argBase  = refl , refl , tt
    ; failed   = refl ; witness = var ; witnessBase = tt }

  -- The head really is missing and really does occur uncovered in t₁.
  occ₁ : Occurs (residual o₁) V₁ t₁
  occ₁ = 0 , refl

  o₁-payload : 1 < size (arg o₁)
  o₁-payload = ≤-refl

  -- The two unfoldings, computed.  The target has size 3.
  ex-size-informative : size (unfold (residual o₁) (witness (inform V₁ o₁)) t₁) ≡ 4
  ex-size-informative = refl

  ex-size-null : size (unfold (residual o₁) (witness (degenerate V₁ o₁)) t₁) ≡ 2
  ex-size-null = refl

  ex-size-target : size t₁ ≡ 3
  ex-size-target = refl

  -- The separation, instantiated.
  ex-informative : Expands V₁ (inform V₁ o₁) t₁
  ex-informative = inform-expands V₁ o₁ o₁-payload t₁ occ₁

  ex-null : ¬ Expands V₁ (degenerate V₁ o₁) t₁
  ex-null = null-never-expands V₁ o₁ t₁ occ₁

  -- ...while the naming-level progress is identical for the two.
  ex-same-decrease :
      (deficit (extend V₁ (inform V₁ o₁)) t₁ < deficit V₁ t₁)
    × (deficit (extend V₁ (degenerate V₁ o₁)) t₁ < deficit V₁ t₁)
  ex-same-decrease =
      occurs→decreases (residual o₁) V₁ t₁ occ₁
    , occurs→decreases (residual o₁) V₁ t₁ occ₁
