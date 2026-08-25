{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessPolicy
--
-- The obligation `GenerativeLoop` names for itself, discharged:
--
--   "Witness policy still degenerate (`witness = var`), as in
--    `obs-complete`.  Conservativity holds for any base witness; an
--    *informative* body policy is the next theorem, not one proved
--    here."                        — GenerativeLoop.agda, §"NOT CLAIMED"
--
-- An `Obstruction V` already carries everything an informative policy
-- needs and nothing was doing with it: the field `arg` is the base
-- subterm the failed match was carrying, and `argBase : Over V arg` is
-- the evidence that the failure was exactly at the root.  `argBase` is
-- *precisely* gate D4 for the body `arg` — the body mentions only
-- earlier vocabulary — so the informative policy is not an addition to
-- the substrate; it is the substrate's unused hypothesis.
--
--   degenerate V o :  witness = var    (the policy in `obs-complete`
--                                       and in `GenerativeLoop.probe`)
--   inform     V o :  witness = arg o  (the policy proved here)
--
-- Read the two as definitions: `inform` names the missing head as an
-- ABBREVIATION FOR THE VERY PAYLOAD THE MATCHER CHOKED ON, where
-- `degenerate` names it as an abbreviation for its own parameter.
--
-- Substrate: exactly `Obstruction` and
-- `GenerativeLoop`.  Nothing new is axiomatised; the two
-- new definitions of this file are `size : Tm → ℕ` and the two policies.
--
--
-- WHAT IS CHECKED
--
-- P0. The unfolding lemmas the rest needs (§1).
--
--   `plug-size`            size (plug b u) ≡ size b + size u.
--   `unfold-fixes-base`    a definitional extension by a head absent
--                          from V acts as the IDENTITY on every term
--                          base over V.  (One induction; this is why
--                          the unfoldings below compute exactly.)
--   `body-retrievable`     unfold d b (node d var) ≡ b, for every d and
--                          every b.  THE INVERSION: the body of a
--                          definitional extension is recovered, on the
--                          nose, by unfolding its generic instance.
--
-- P1. Conservativity survives the change of policy (task item 1).
--
--   `informative-conservative`
--                          the exact analogue of
--                          `GenerativeLoop.Compile.generated-definition-
--                          conservative` / `Obstruction.propose-eliminable`
--                          for `inform`: every term over the extended
--                          vocabulary unfolds, through the INFORMATIVE
--                          body, to a base term.  IT SURVIVES, and it
--                          survives for the structural reason above:
--                          `witnessBase := argBase`.
--   `informative-stuck-base`
--                          the same at the stuck term specifically: the
--                          term that could not be matched unfolds to a
--                          base term.
--   `informative-unfolds-stuck`, `degenerate-unfolds-stuck`
--                          and here is what each policy does to it,
--                          computed exactly:
--                            inform      :  stuckTm o ↦ plug (arg o) (arg o)
--                            degenerate  :  stuckTm o ↦ arg o
--                          — the degenerate extension deletes the head,
--                          the informative one substitutes the recorded
--                          payload for it.
--
-- P2. `inform` is strictly more informative than `degenerate` (task
--     item 2).  Three separations, of increasing strength.
--
--   `informative-abbreviates`
--                          unfold (residual o) (witness (inform V o))
--                            (node (residual o) var)  ≡  arg o.
--                          RETRIEVAL: the payload of the failed match is
--                          recoverable, on the nose, from the generated
--                          definition — one symbol of the extended
--                          vocabulary unfolds to the whole missing
--                          structure.
--   `degenerate-forgets`   the same term, under the degenerate policy,
--                          unfolds to `var`.  The payload is GONE.
--   `policies-differ`      hence for every obstruction whose payload is
--                          not the bare parameter, the two generated
--                          definitions are DIFFERENT definitions: their
--                          generic instances have distinct unfoldings.
--                          (Not "differ in general" — differ at this
--                          named term, with the hypothesis stated.)
--   `degenerate-never-grows`
--                          the uniform negative, which is what makes the
--                          separation more than a naming difference: for
--                          EVERY term t whatsoever,
--                            size (unfold d var t) ≤ size t.
--                          The degenerate policy can only erase.  It can
--                          abbreviate nothing, at any term, ever.
--   `informative-abbreviation-size`, `informative-grows`,
--   `policy-separation`
--                          against that: the informative policy's
--                          generic instance has size 1 and unfolds to
--                          size (arg o), so on any obstruction with
--                          1 < size (arg o) it STRICTLY grows — a
--                          property the degenerate policy provably does
--                          not have at any term.  `policy-separation`
--                          is the pair, as one term.
--   `Example.o₀…`          the hypothesis `1 < size (arg o)` is not
--                          vacuous: an explicit obstruction satisfying
--                          it, over the vocabulary `0 ∷ []`.
--
--   The honest scope of P2, checked as statements rather than asserted:
--   `policies-agree-on-matching`, `policies-agree-on-coverage` —
--   `extend` reads only `residual`, so the two policies induce the SAME
--   `Matches` and the SAME `Over`, definitionally.  The informativeness
--   is invisible to the matcher and lives entirely in `unfold`.  See
--   "NOT CLAIMED" below.
--
-- P3. `inform` is a drop-in for `degenerate` (task item 3).
--
--   `informative-step`     the step function of `GenerativeLoop.B2`,
--                          with an informative obstruction and the SAME
--                          strict decrease
--                          deficit (extend V o) t < deficit V t.
--                          (The decrease transports along nothing: the
--                          policies have definitionally equal `extend`.)
--   `AllInformative`       a chain all of whose steps are informative.
--   `informative-loop`,
--   `informative-generative-loop`
--                          `GenerativeLoop.loop` / `generative-loop`
--                          re-run under the informative policy: for
--                          every V and every target t there is W, an
--                          ObsChain V W every step of which is
--                          informative, Over W t, and
--                          chainLen ch ≤ deficit V t.  Same measure,
--                          same bound, no step lost.
--   `informative-loop-drops-in`
--                          forgetting informativity returns the
--                          conclusion of `generative-loop` verbatim.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * NOT claimed: that the informative policy enlarges the matchable
--    set beyond the degenerate one.  It provably does not.
--    `extend V o = residual o ∷ V` reads only the residual, so
--    `policies-agree-on-matching` and `policies-agree-on-coverage` hold
--    by `refl`.  The task's candidate "the extension supports a match
--    the degenerate policy's extension does not" is therefore FALSE in
--    this substrate, and is recorded here as a checked equality rather
--    than left as an open option.  Every separation in P2 is a
--    separation of UNFOLDINGS — of definitional content — not of
--    matchability.  A substrate in which the body's shape feeds back
--    into matching (patterns below the root) would be a different
--    model; it is not this one.
--  * NOT claimed: optimality or canonicity of `witness = arg`.  It is
--    one informative policy — the one the obstruction record already
--    justifies.  Nothing here says it is the best body, and
--    `policy-separation`'s hypothesis `1 < size (arg o)` says only that
--    it beats `var` on obstructions with a non-trivial payload; on
--    obstructions with `arg = var` the two policies coincide
--    (definitionally, and that is not hidden).
--  * NOT claimed: that `plug (arg o) (arg o)` — what the informative
--    extension does to the stuck term — is the "intended" semantics of
--    anything.  It is what `Obstruction.unfold`'s defining equation
--    computes, stated exactly (`informative-unfolds-stuck`) so that it
--    can be argued with.  The duplication is real: the recorded body is
--    substituted AND the argument survives at the parameter.
--  * NOT claimed: any statement about the ORDER in which the loop reads
--    obstructions, or that the informative bodies accumulated along a
--    chain compose to anything.  `AllInformative` is a conjunction over
--    steps, not a coherence.  Chain-level conservativity is not stated;
--    what is stated is per-step conservativity (P1), which is what
--    `GenerativeLoop.Compile.C1` also stated.
--  * NOT claimed: a size bound on the informative loop's OUTPUT.  The
--    step bound `chainLen ch ≤ deficit V t` is inherited unchanged; the
--    total size of the generated bodies is not measured.
--  * `size` is the node count of a term (`size var = 0`), not a measure
--    of anything in `runtime/vocabulary/`.  `degenerate-never-grows` is
--    a statement about `unfold` in this model and about nothing else.
--  * Everything inherited from `Obstruction`'s and `GenerativeLoop`'s
--    disclaimers stands: single-parameter bodies, matching only at the
--    root, no arity structure in the residual, gates D2-D7 unmodelled,
--    no unification of the two substrates of `GenerativeLoop.C`.
------------------------------------------------------------------------

module WitnessPolicy where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; snotz)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-refl ; ≤-suc ; ≤-trans ; zero-≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; true≢false ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Obstruction
open Obstruction
open Extension

open import GenerativeLoop

------------------------------------------------------------------------
-- 1.  Size, plugging, and how a definitional extension acts on base
--     terms.
--
-- `size` counts node positions.  The one fact that makes every
-- unfolding below compute exactly is `unfold-fixes-base`: a head absent
-- from V cannot occur in a term base over V, so unfolding it is the
-- identity there.  (This is the arithmetic behind `unfold-elim`: the
-- elimination pass touches only the new head.)
------------------------------------------------------------------------

size : Tm → ℕ
size var        = 0
size (node _ t) = suc (size t)

plug-size : (b u : Tm) → size (plug b u) ≡ size b + size u
plug-size var        u = refl
plug-size (node c b) u = cong suc (plug-size b u)

plug-var : (b : Tm) → plug b var ≡ b
plug-var var        = refl
plug-var (node c b) = cong (node c) (plug-var b)

-- The two branches of `unfold`, named so that the implicit arguments of
-- `if≡true` / `if≡false` are pinned by the stated type.
unfold-hit : (d : Shape) (b : Tm) (c : Shape) (u : Tm) → eqℕ c d ≡ true
           → unfold d b (node c u) ≡ plug b (unfold d b u)
unfold-hit d b c u e =
  if≡true {x = plug b (unfold d b u)} {y = node c (unfold d b u)} e

unfold-miss : (d : Shape) (b : Tm) (c : Shape) (u : Tm) → eqℕ c d ≡ false
            → unfold d b (node c u) ≡ node c (unfold d b u)
unfold-miss d b c u e =
  if≡false {x = plug b (unfold d b u)} {y = node c (unfold d b u)} e

-- A head absent from V does not occur in a term base over V, so
-- unfolding it there changes nothing.
unfold-fixes-base : (V : Vocab) (d : Shape) (b : Tm) → memb d V ≡ false
                  → (t : Tm) → Over V t → unfold d b t ≡ t
unfold-fixes-base V d b hd var        _         = refl
unfold-fixes-base V d b hd (node c u) (hc , hu) =
    unfold-miss d b c u ne
  ∙ cong (node c) (unfold-fixes-base V d b hd u hu)
  where
  ne : eqℕ c d ≡ false
  ne = ≢→eqℕ-false c d (λ p → true≢false (sym hc ∙ cong (λ z → memb z V) p ∙ hd))

-- THE INVERSION.  The body of a definitional extension is recovered, on
-- the nose, by unfolding the generic instance `node d var` of the
-- defined head.  This is what makes "informative" a checkable property
-- of a policy rather than a description of one: whatever the policy put
-- in the body, this term hands back.
body-retrievable : (d : Shape) (b : Tm) → unfold d b (node d var) ≡ b
body-retrievable d b = unfold-hit d b d var (eqℕ-refl d) ∙ plug-var b

------------------------------------------------------------------------
-- 2.  The two policies.
--
-- Both are endofunctions of `Obstruction V` fixing everything except
-- the body: same residual, same payload, same failure evidence.  They
-- differ in one field, and `Informative` is the predicate that field
-- satisfies.
------------------------------------------------------------------------

-- The policy of `Obstruction.obs-complete` and `GenerativeLoop.probe`.
degenerate : (V : Vocab) → Obstruction V → Obstruction V
degenerate V o = record
  { residual = residual o ; arg = arg o ; argBase = argBase o
  ; failed   = failed o   ; witness = var ; witnessBase = tt }

-- THE INFORMATIVE POLICY.  The body is the payload of the failed match,
-- and it is a legal body — gate D4 — by the obstruction's own
-- `argBase`, the field that says the failure was at the root.
inform : (V : Vocab) → Obstruction V → Obstruction V
inform V o = record
  { residual = residual o ; arg = arg o ; argBase = argBase o
  ; failed   = failed o   ; witness = arg o ; witnessBase = argBase o }

Informative : {V : Vocab} → Obstruction V → Type₀
Informative o = witness o ≡ arg o

inform-informative : (V : Vocab) (o : Obstruction V) → Informative (inform V o)
inform-informative V o = refl

-- Definitional bookkeeping.  These are `refl`, and they carry no
-- mathematical content on their own; they are recorded because every
-- drop-in claim in §5 depends on them holding DEFINITIONALLY (no
-- transport appears anywhere in §5), and a reader is entitled to see
-- that stated rather than inferred from the absence of `subst`.
inform-preserves-residual : (V : Vocab) (o : Obstruction V)
                          → residual (inform V o) ≡ residual o
inform-preserves-residual V o = refl

inform-preserves-stuck : (V : Vocab) (o : Obstruction V)
                       → stuckTm (inform V o) ≡ stuckTm o
inform-preserves-stuck V o = refl

inform-preserves-extension : (V : Vocab) (o : Obstruction V)
                           → extend V (inform V o) ≡ extend V o
inform-preserves-extension V o = refl

------------------------------------------------------------------------
-- 3.  P1.  CONSERVATIVITY SURVIVES.
--
-- The question the header obligation actually asks: does the extension
-- still eliminate when the body is no longer a bare parameter?  It
-- does, and the reason is structural rather than lucky —
-- `propose-eliminable` needs `Over V (witness o)`, and the informative
-- policy supplies it as `argBase o`, the field the obstruction record
-- already had to carry in order to state that the failure was at the
-- root.  No new hypothesis is introduced anywhere in this file.
------------------------------------------------------------------------

informative-conservative : (V : Vocab) (o : Obstruction V) (t : Tm)
  → Over (install V (propose V (inform V o))) t
  → Over V (unfold (residual o) (arg o) t)
informative-conservative V o = propose-eliminable V (inform V o)

-- The same, at the term the matcher actually failed on.
informative-stuck-base : (V : Vocab) (o : Obstruction V)
  → Over V (unfold (residual o) (arg o) (stuckTm o))
informative-stuck-base V o =
  informative-conservative V o (stuckTm o)
    ( memb-here (residual o) V
    , Over-mono V (residual o) (arg o) (argBase o) )

-- What each policy actually does to the stuck term, computed.
informative-unfolds-stuck : (V : Vocab) (o : Obstruction V)
  → unfold (residual o) (arg o) (stuckTm o) ≡ plug (arg o) (arg o)
informative-unfolds-stuck V o =
    unfold-hit (residual o) (arg o) (residual o) (arg o) (eqℕ-refl (residual o))
  ∙ cong (plug (arg o))
      (unfold-fixes-base V (residual o) (arg o) (failed o) (arg o) (argBase o))

degenerate-unfolds-stuck : (V : Vocab) (o : Obstruction V)
  → unfold (residual o) var (stuckTm o) ≡ arg o
degenerate-unfolds-stuck V o =
    unfold-hit (residual o) var (residual o) (arg o) (eqℕ-refl (residual o))
  ∙ unfold-fixes-base V (residual o) var (failed o) (arg o) (argBase o)

------------------------------------------------------------------------
-- 4.  P2.  THE SEPARATION.
--
-- First the retrieval theorem, then the uniform negative that gives it
-- teeth: the degenerate policy cannot abbreviate anything, at any term,
-- because its unfolding never grows a term.
------------------------------------------------------------------------

-- Retrieval: one symbol of the extended vocabulary unfolds to the whole
-- missing structure.
informative-abbreviates : (V : Vocab) (o : Obstruction V)
  → unfold (residual o) (witness (inform V o)) (node (residual o) var) ≡ arg o
informative-abbreviates V o = body-retrievable (residual o) (arg o)

-- ... and the degenerate policy's generated definition has forgotten it.
degenerate-forgets : (V : Vocab) (o : Obstruction V)
  → unfold (residual o) (witness (degenerate V o)) (node (residual o) var) ≡ var
degenerate-forgets V o = body-retrievable (residual o) var

private
  isVarT : Tm → Type₀
  isVarT var        = Unit
  isVarT (node _ _) = ⊥

node≢var : (c : Shape) (u : Tm) → ¬ (node c u ≡ var)
node≢var c u p = subst isVarT (sym p) tt

-- The two generated definitions are different definitions, whenever the
-- payload is not the bare parameter.
policies-differ : (V : Vocab) (o : Obstruction V) → ¬ (arg o ≡ var)
  → ¬ ( unfold (residual o) (witness (inform V o))     (node (residual o) var)
      ≡ unfold (residual o) (witness (degenerate V o)) (node (residual o) var) )
policies-differ V o ne p =
  ne (sym (informative-abbreviates V o) ∙ p ∙ degenerate-forgets V o)

-- THE UNIFORM NEGATIVE.  Under the degenerate policy, unfolding is
-- non-increasing on EVERY term: `plug var u = u`, so each occurrence of
-- the defined head is deleted and nothing is ever inserted.  The
-- degenerate extension is an eraser; it abbreviates nothing.
degenerate-never-grows : (d : Shape) (t : Tm) → size (unfold d var t) ≤ size t
degenerate-never-grows d var        = ≤-refl
degenerate-never-grows d (node c u) = go (dichotomyBool (eqℕ c d))
  where
  ih : size (unfold d var u) ≤ size u
  ih = degenerate-never-grows d u

  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → size (unfold d var (node c u)) ≤ suc (size u)
  go (inl e) =
    subst (λ z → size z ≤ suc (size u)) (sym (unfold-hit d var c u e)) (≤-suc ih)
  go (inr e) =
    subst (λ z → size z ≤ suc (size u)) (sym (unfold-miss d var c u e)) (suc-≤-suc ih)

-- Against that: the informative policy's generic instance is one symbol
-- and unfolds to the whole payload.
informative-abbreviation-size : (V : Vocab) (o : Obstruction V)
  → size (unfold (residual o) (witness (inform V o)) (node (residual o) var))
  ≡ size (arg o)
informative-abbreviation-size V o = cong size (informative-abbreviates V o)

informative-grows : (V : Vocab) (o : Obstruction V) → 1 < size (arg o)
  → size (node (residual o) var)
  < size (unfold (residual o) (witness (inform V o)) (node (residual o) var))
informative-grows V o h = subst (1 <_) (sym (informative-abbreviation-size V o)) h

-- P2, as one term: on any obstruction with a non-trivial payload the
-- informative extension strictly grows a term, and the degenerate
-- extension provably grows no term at all.
policy-separation : (V : Vocab) (o : Obstruction V) → 1 < size (arg o)
  → ( size (node (residual o) var)
      < size (unfold (residual o) (witness (inform V o)) (node (residual o) var)) )
  × ( (t : Tm) → size (unfold (residual o) (witness (degenerate V o)) t) ≤ size t )
policy-separation V o h =
  informative-grows V o h , degenerate-never-grows (residual o)

------------------------------------------------------------------------
-- 4a.  The honest scope of §4, checked.
--
-- `extend` reads only the residual.  So the informative policy buys
-- NOTHING at the matcher, and this is stated as a `refl`-equality
-- rather than left as an unexamined possibility.  All of §4 is a
-- separation of definitional content, not of matchability.
------------------------------------------------------------------------

policies-agree-on-matching : (V : Vocab) (o : Obstruction V)
  → Matches (extend V (inform V o)) ≡ Matches (extend V (degenerate V o))
policies-agree-on-matching V o = refl

policies-agree-on-coverage : (V : Vocab) (o : Obstruction V)
  → Over (extend V (inform V o)) ≡ Over (extend V (degenerate V o))
policies-agree-on-coverage V o = refl

------------------------------------------------------------------------
-- 5.  P3.  DROP-IN: progress and the step bound survive.
--
-- `GenerativeLoop.generative-step` returns an obstruction with the
-- degenerate body together with the strict decrease of `deficit`.
-- Applying `inform` to it changes the body and leaves `extend`
-- definitionally where it was, so the SAME decrease proof retypes.  The
-- loop is then re-run verbatim, carrying the informativity of every
-- step through the (routine) chain reassociation.
------------------------------------------------------------------------

informative-step : (V : Vocab) (t : Tm)
  → Over V t
  ⊎ (Σ[ o ∈ Obstruction V ] (Informative o × (deficit (extend V o) t < deficit V t)))
informative-step V t = read (generative-step V t)
  where
  read : Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
       → Over V t
       ⊎ (Σ[ o ∈ Obstruction V ] (Informative o × (deficit (extend V o) t < deficit V t)))
  read (inl h)         = inl h
  read (inr (o , dec)) = inr (inform V o , refl , dec)

-- A chain every step of which was generated by an informative policy.
AllInformative : {V W : Vocab} → ObsChain V W → Type₀
AllInformative done        = Unit
AllInformative (step ch o) = AllInformative ch × Informative o

consChain-informative : {V W : Vocab} (o : Obstruction V) → Informative o
                      → (ch : ObsChain (extend V o) W) → AllInformative ch
                      → AllInformative (consChain o ch)
consChain-informative o io done         _          = tt , io
consChain-informative o io (step ch o') (ac , io') =
  consChain-informative o io ch ac , io'

private
  ¬<zero : (n : ℕ) → ¬ (n < 0)
  ¬<zero n (k , p) = snotz (sym (+-suc k n) ∙ p)

-- What the informative loop delivers: `GenerativeLoop.Reaches` plus the
-- informativity of every step.
InfReaches : Vocab → Tm → ℕ → Type₀
InfReaches V t f =
  Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
    (AllInformative ch × (Over W t × (chainLen ch ≤ f)))

informative-loop : (f : ℕ) (V : Vocab) (t : Tm) → deficit V t ≤ f → InfReaches V t f
informative-loop zero V t h = go (informative-step V t)
  where
  go : Over V t
     ⊎ (Σ[ o ∈ Obstruction V ] (Informative o × (deficit (extend V o) t < deficit V t)))
     → InfReaches V t 0
  go (inl cov)           = V , done , tt , cov , ≤-refl
  go (inr (o , _ , dec)) =
    Empty.rec (¬<zero (deficit (extend V o) t) (≤-trans dec h))
informative-loop (suc f) V t h = go (informative-step V t)
  where
  go : Over V t
     ⊎ (Σ[ o ∈ Obstruction V ] (Informative o × (deficit (extend V o) t < deficit V t)))
     → InfReaches V t (suc f)
  go (inl cov)            = V , done , tt , cov , zero-≤
  go (inr (o , io , dec)) =
    next (informative-loop f (extend V o) t (pred-≤-pred (≤-trans dec h)))
    where
    next : InfReaches (extend V o) t f → InfReaches V t (suc f)
    next (W , ch , ac , cov , len) =
      W , consChain o ch , consChain-informative o io ch ac , cov
        , subst (_≤ suc f) (sym (consChain-len o ch)) (suc-≤-suc len)

-- TERMINATION, under the informative policy, with the SAME bound as
-- `GenerativeLoop.generative-loop`: every step of the chain carries an
-- informative body, and there are at most `deficit V t` of them.
informative-generative-loop : (V : Vocab) (t : Tm)
  → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
      (AllInformative ch × (Over W t × (chainLen ch ≤ deficit V t)))
informative-generative-loop V t = informative-loop (deficit V t) V t ≤-refl

-- Forgetting informativity returns `generative-loop`'s conclusion
-- verbatim: the informative policy is a drop-in, not a variant.
informative-loop-drops-in : (V : Vocab) (t : Tm)
  → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ] (Over W t × (chainLen ch ≤ deficit V t))
informative-loop-drops-in V t = forget (informative-generative-loop V t)
  where
  forget : (Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
              (AllInformative ch × (Over W t × (chainLen ch ≤ deficit V t))))
         → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ]
              (Over W t × (chainLen ch ≤ deficit V t))
  forget (W , ch , _ , cov , len) = W , ch , cov , len

------------------------------------------------------------------------
-- 6.  Non-vacuity of `policy-separation`'s hypothesis.
--
-- `1 < size (arg o)` is a real hypothesis and it is inhabited: over the
-- vocabulary `0 ∷ []` the head `1` is absent, and `node 0 (node 0 var)`
-- is base, so it is a legal payload of size 2.  Everything below is
-- checked, not asserted; the two `refl`s are the freshness evidence and
-- the coverage evidence computing.
------------------------------------------------------------------------

module Example where

  V₀ : Vocab
  V₀ = 0 ∷ []

  o₀ : Obstruction V₀
  o₀ = record
    { residual = 1 ; arg = node 0 (node 0 var)
    ; argBase  = refl , refl , tt
    ; failed   = refl ; witness = var ; witnessBase = tt }

  o₀-payload-big : 1 < size (arg o₀)
  o₀-payload-big = ≤-refl

  o₀-payload-nontrivial : ¬ (arg o₀ ≡ var)
  o₀-payload-nontrivial = node≢var 0 (node 0 var)

  -- The generated definition of head `1`, unfolded at its generic
  -- instance, hands back the whole payload.
  o₀-abbreviates : unfold 1 (witness (inform V₀ o₀)) (node 1 var) ≡ node 0 (node 0 var)
  o₀-abbreviates = informative-abbreviates V₀ o₀

  o₀-separated :
      ( size (node (residual o₀) var)
        < size (unfold (residual o₀) (witness (inform V₀ o₀)) (node (residual o₀) var)) )
    × ( (t : Tm) → size (unfold (residual o₀) (witness (degenerate V₀ o₀)) t) ≤ size t )
  o₀-separated = policy-separation V₀ o₀ o₀-payload-big

  o₀-policies-differ :
    ¬ ( unfold (residual o₀) (witness (inform V₀ o₀))     (node (residual o₀) var)
      ≡ unfold (residual o₀) (witness (degenerate V₀ o₀)) (node (residual o₀) var) )
  o₀-policies-differ = policies-differ V₀ o₀ o₀-payload-nontrivial
