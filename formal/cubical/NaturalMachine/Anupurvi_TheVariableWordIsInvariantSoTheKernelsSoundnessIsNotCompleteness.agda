{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Ānupūrvī — the order of the series, and the fact that no rewrite in this
-- kernel disturbs it.
--
-- TERM.  आनुपूर्वी, succession / regular order.  The Jain canonical
-- literature treats it as a topic in its own right: the *Anuyogadvāra*
-- distinguishes pūrvānupūrvī (the forward order of a series),
-- paścādānupūrvī (the reverse) and anānupūrvī (every other arrangement),
-- and counts them — which is combinatorics of permutations arising from
-- the classification of a sequence, not from mathematics as a separate
-- subject.  GRADE OF THE CITATION: I have the text and the doctrine; I
-- have NOT verified a sūtra number against an edition, so none is given.
-- Nothing below is a theorem of that tradition.  The word names what is
-- proved invariant here: the arrangement of the variables, as against
-- their multiplicity.
--
-- THE QUESTION THIS ANSWERS, AND WHY IT IS THE NEXT ONE.
--
-- `Sesa_…` proves the kernel's soundness map is not injective: many
-- derivations, one meaning, and no semantic criterion recovers which.
-- `Asesa_…` proves it is therefore not an equivalence — by exhibiting the
-- failure of INJECTIVITY at the kernel's own seed.  The other half was
-- never asked.  Is it SURJECTIVE?  That is: does the calculus derive
-- everything its semantics identifies?
--
-- It does not, and the obstruction is exact.
--
--   §2  Every `Step` — `add-zero`, `add-suc`, the three congruences, and
--       `reverse` — preserves the LEFT-TO-RIGHT WORD OF VARIABLE
--       OCCURRENCES.  Every rule of the calculus manipulates `zero` and
--       `suc`; none permutes two variable subterms.
--
--   §3  Hence no derivation joins `add var yvar` to `add yvar var`, whose
--       words are `x y` and `y x`.
--
--   §4  Yet `eval` identifies them at every environment (`+-comm`).  So
--       soundness is not completeness, and the gap is precisely the
--       symmetric group acting on the variable positions.
--
-- WHAT THIS PUTS TOGETHER, and it is the reason the module is worth its
-- lines.  `Ankapasa_…` shows that the COUNTING semantics cannot see a
-- transposition: commutativity at `add var var` is a loop that ℕ is forced
-- to call `refl`, while the univalent semantics calls it the swap and `ua`
-- of it is non-trivial.  This module shows the DERIVATIONS cannot perform
-- one.  The two are the same datum from the two sides:
--
--     the arrangement is what the calculus preserves
--     and what the count discards.
--
-- So adding `add-comm` — the extension `Ankapasa_…` makes, and shows to be
-- sound — does two things at once, and they are one thing.  It completes
-- the calculus towards its ℕ-semantics, and it introduces the ℤ/2 of
-- holonomy that the counting readout annihilates.  The completion and the
-- holonomy arrive together, because they are the same generator.
--
-- WHAT IS **NOT** CLAIMED.  Not that the word is a COMPLETE invariant.
-- §5 states the normalisation conjecture — derivable iff same word and
-- same constant — as a type, unproved, and says what proving it needs
-- (a normal form and a terminating strategy, neither of which exists in
-- this corpus).  Nothing here concerns the extended calculus `Step⁺`;
-- `Ankapasa_…` is not imported, and its `add-comm` would break §2 by
-- design, which is the point.  Nothing here says the ℕ-theory of the
-- calculus is decidable, though §4's argument suggests where to look.
-- `word` is defined on the six coordinates only, ignoring `zero` and
-- `suc`, because those are exactly what the rules move.
--
-- No postulates, no holes, --safe.  CHECKED this session, EXIT 0, at
-- Agda 2.6.3 + agda/cubical v0.5 -- which is NOT the corpus pin (2.8.0 +
-- v0.9).  Re-check at the pin before treating this green as the lane's.
------------------------------------------------------------------------

module NaturalMachine.Anupurvi_TheVariableWordIsInvariantSoTheKernelsSoundnessIsNotCompleteness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ) renaming (zero to nzero ; suc to nsuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; ++-unit-r)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import NaturalMachine.RewriteCertificate

------------------------------------------------------------------------
-- §1.  THE WORD.  The variable occurrences, left to right.
------------------------------------------------------------------------

data VarName : Type₀ where
  vx vy vz vu vv vw : VarName

word : Tm → List VarName
word var       = vx ∷ []
word yvar      = vy ∷ []
word zvar      = vz ∷ []
word uvar      = vu ∷ []
word vvar      = vv ∷ []
word wvar      = vw ∷ []
word zero      = []
word (suc t)   = word t
word (add l r) = word l ++ word r

------------------------------------------------------------------------
-- §2.  EVERY STEP PRESERVES IT.
--
-- Read the six clauses: `add-zero` drops an empty word from the right,
-- `add-suc` moves a successor across a concatenation that does not change,
-- the three congruences are `cong`, and `reverse` is `sym`.  There is no
-- clause in the calculus that could permute, which is the content.
------------------------------------------------------------------------

step-preserves-word : {a b : Tm} → Step a b → word a ≡ word b
step-preserves-word (add-zero t)     = ++-unit-r (word t)
step-preserves-word (add-suc l r)    = refl
step-preserves-word (suc-step p)     = step-preserves-word p
step-preserves-word (add-left p z)   = cong (_++ word z) (step-preserves-word p)
step-preserves-word (add-right z p)  = cong (word z ++_) (step-preserves-word p)
step-preserves-word (reverse p)      = sym (step-preserves-word p)

derivation-preserves-word : {a b : Tm} → Derivation a b → word a ≡ word b
derivation-preserves-word (done t)        = refl
derivation-preserves-word (then-step p d) =
  step-preserves-word p ∙ derivation-preserves-word d

------------------------------------------------------------------------
-- §3.  SO THE CALCULUS CANNOT PERMUTE.
------------------------------------------------------------------------

private
  firstIsX : List VarName → Bool
  firstIsX (vx ∷ _) = true
  firstIsX _        = false

  xy≢yx : ¬ ((vx ∷ vy ∷ []) ≡ (vy ∷ vx ∷ []))
  xy≢yx p = true≢false (cong firstIsX p)

no-derivation-transposes-two-variables :
  ¬ Derivation (add var yvar) (add yvar var)
no-derivation-transposes-two-variables d =
  xy≢yx (derivation-preserves-word d)

------------------------------------------------------------------------
-- §4.  BUT THE SEMANTICS IDENTIFIES THEM.  Hence soundness is not
--      completeness, and the gap is the transposition.
------------------------------------------------------------------------

open import Cubical.Data.Nat.Properties using (+-comm)

the-semantics-identifies-them :
  (ρ : Env) → eval (add var yvar) ρ ≡ eval (add yvar var) ρ
the-semantics-identifies-them ρ = +-comm (eval var ρ) (eval yvar ρ)

-- The statement, assembled: there is a pair of terms equal at every
-- environment with no derivation between them.  `sound` is not onto.
soundness-is-not-completeness :
  ((ρ : Env) → eval (add var yvar) ρ ≡ eval (add yvar var) ρ)
  × (¬ Derivation (add var yvar) (add yvar var))
soundness-is-not-completeness =
  the-semantics-identifies-them , no-derivation-transposes-two-variables

------------------------------------------------------------------------
-- §5.  ~~THE NORMALISATION CONJECTURE~~ — STRUCK THE SAME DAY, BY ME.
--      It is FALSE.  `Baddha_…` exhibits a third conservation law (a
--      successor trapped in a left operand whose sibling carries a
--      variable can never reach the front, because the calculus has no
--      associativity) and separates `add (suc var) yvar` from
--      `suc (add var yvar)` — same word, same constant, no derivation.
--      The type is kept below so the refutation has something to name.
--      ORIGINAL WORDING, for the record: the conjecture, as a type.  Unproved, and stated so
--      that what is missing is visible: a normal form for `Tm` under the
--      calculus, and a terminating strategy reaching it.  Neither exists
--      in this corpus, and `Asiddhatva.agda`'s result — that a rewrite
--      system can admit NO strict order in which every step decreases —
--      is the standing warning that the second is not routine.
------------------------------------------------------------------------

NormalisationConjecture : Type₀
NormalisationConjecture =
  (a b : Tm)
  → word a ≡ word b
  → ((ρ : Env) → eval a ρ ≡ eval b ρ)
  → Derivation a b
