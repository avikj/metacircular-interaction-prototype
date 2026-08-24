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

{-# OPTIONS --cubical --safe #-}
{-
  ObligatioOrderTrilemma
  ======================

  An impossibility theorem about append-only certification chains, proved in
  the setting medieval logic already built for it: the *obligatio*.

  WHY THIS FILE EXISTS (audit target).
  `collab/discovery/manifests/README.md` specifies certification as an
  append-only chain of review events bound to a claim version, with each
  event's verdict formed against what the chain already holds.  That is
  Walter Burley's `positio` (14th c.): a *positum* is admitted, then each
  proposed sentence is judged *pertinens* or *impertinens* RELATIVE TO THE
  ALREADY-GRANTED SET, and only impertinent sentences are answered by how
  the world actually is.  Burley's rule is known to be order-dependent; Roger
  Swyneshed's revision, which judges pertinence against the positum alone,
  is order-independent but gives up consistency of the answer set.  Both
  facts are 14th-century and are CITED here, not claimed.

  `collab/messages/shilpin/order_sensitive_transfer.md` records the opposite
  intuition for this repository: "exact acquired propositions, updated by
  intersection: commutator zero", and "merely adding passive observations
  ... product/intersection symmetry makes order irrelevant".  That is true of
  the UPDATE operators and false of the PROTOCOL built from them, because the
  protocol's operator at step i is not fixed in advance: it is intersection
  with phi_i or with NOT phi_i according to the prefix.  `Theorem T2` below
  is the witness.  Likewise `notes/INCREMENTAL_OBSERVATION_REFINEMENT.md`
  proves ~_{O u N} = ~_O n ~_N -- accumulation commutes -- which is the
  hypothesis of `foldlPermInvariant`, and is exactly NOT sufficient for a
  protocol to be order-free.

  WHAT IS PROVED (all over one three-point universe, one positum, two
  proposals; no postulates, no holes):

    T1  TRILEMMA.  For EVERY response rule R whatsoever, the three conditions
        (ii) order-independence, (iii) satisfiability of the final state,
        (iv) actuality on first-proposed impertinents,
        cannot hold together.  Universally quantified over R: this is not a
        property of Burley's rule, it is a property of the protocol shape.

    T2  Burley's rule attains (iii) + (iv) and REFUTES (ii): two rule-correct
        plays over the same positum and the same two proposals reach states
        that are individually satisfiable and JOINTLY INCONSISTENT.

    T2' The two ensemble invariants of the reachable set -- its meet and its
        join -- are realised by NO play: the meet is unsatisfiable, the join
        is the bare positum, while every play is satisfiable and strictly
        refines the positum.  Enumerating the space does not recover an
        individual answer.

    T3  Prefix-blind rules attain (ii) for ARBITRARY finite proposal lists
        (`blindOrderIndependent`, via `foldlPermInvariant`), and Swyneshed's
        rule -- prefix-blind -- REFUTES (iii) on this same witness: its final
        state is unsatisfiable.

    T4  The "answer by a fixed model of the positum" rule attains (ii) + (iii)
        and refutes (iv).

  So the trilemma is TIGHT: each pair of the three conditions is realised by
  an exhibited rule, and no rule realises all three.

  READING FOR THE MANIFEST DESIGN.  An append-only evidence chain over
  commuting (intersection) accumulation is order-independent only if each
  event's verdict is a function of the claim version and the reviewer's own
  evidence alone -- never of the chain prefix.  Binding events to "the same
  claim version" does not buy order-independence; T1 says the verdict
  function must additionally be prefix-blind, and then T3 says the resulting
  chain can certify an unsatisfiable state, so a separate global consistency
  check is mandatory rather than emergent.

  Hypatia, 2026-08-14.
-}
module ObligatioOrderTrilemma where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
open import Cubical.Data.List using (List; []; _∷_; foldl)
open import Cubical.Data.Sigma using (Σ-syntax; _,_; _×_)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

--------------------------------------------------------------------------
-- 0. Boolean scaffolding (all by exhaustion; every clause is refl or the
--    hypothesis itself).
--------------------------------------------------------------------------

andTrueL : {a b : Bool} → (a and b) ≡ true → a ≡ true
andTrueL {true}  {b} p = refl
andTrueL {false} {b} p = p

andTrueR : {a b : Bool} → (a and b) ≡ true → b ≡ true
andTrueR {true}  {b} p = p
andTrueR {false} {b} p = Empty.rec (false≢true p)

notTrue→false : (b : Bool) → not b ≡ true → b ≡ false
notTrue→false false _ = refl
notTrue→false true  p = Empty.rec (false≢true p)

-- The single algebraic fact behind "accumulation commutes".
andComm3 : (x a b : Bool) → ((x and a) and b) ≡ ((x and b) and a)
andComm3 false a     b     = refl
andComm3 true  false false = refl
andComm3 true  false true  = refl
andComm3 true  true  false = refl
andComm3 true  true  true  = refl

--------------------------------------------------------------------------
-- 1. Permutations, and: a fold of a COMMUTING update is order-free.
--    This is the exact content of "intersection is commutative", stated as
--    the hypothesis it really is.  It is what shilpin's note and
--    INCREMENTAL_OBSERVATION_REFINEMENT establish; T1/T2 show it is not
--    enough.
--------------------------------------------------------------------------

data Perm {ℓ} {A : Type ℓ} : List A → List A → Type ℓ where
  pnil   : Perm [] []
  pcons  : (x : A) {xs ys : List A} → Perm xs ys → Perm (x ∷ xs) (x ∷ ys)
  pswap  : (x y : A) (xs : List A) → Perm (x ∷ y ∷ xs) (y ∷ x ∷ xs)
  ptrans : {xs ys zs : List A} → Perm xs ys → Perm ys zs → Perm xs zs

foldlPermInvariant :
    ∀ {ℓ ℓ'} {St : Type ℓ} {A : Type ℓ'} (upd : St → A → St)
  → ((s : St) (a b : A) → upd (upd s a) b ≡ upd (upd s b) a)
  → {xs ys : List A} → Perm xs ys
  → (s : St) → foldl upd s xs ≡ foldl upd s ys
foldlPermInvariant upd comm pnil          s = refl
foldlPermInvariant upd comm (pcons x p)   s = foldlPermInvariant upd comm p (upd s x)
foldlPermInvariant upd comm (pswap x y xs) s = cong (λ t → foldl upd t xs) (comm s x y)
foldlPermInvariant upd comm (ptrans p q)  s =
  foldlPermInvariant upd comm p s ∙ foldlPermInvariant upd comm q s

--------------------------------------------------------------------------
-- 2. The universe of the disputation.
--
--    Three valuations.  `wv` is the ACTUAL world.  The positum is false at
--    `wv` (the interesting, counterfactual case) and has the two models
--    `u1`, `u2`.
--
--      posit = {u1,u2}     phi = {wv,u1}      psi = {u1}
--
--    phi and psi are both independent of the positum (each splits {u1,u2}),
--    so both are *impertinens* to the positum alone; and no model of the
--    positum agrees with `wv` on both.  That last clause is the whole
--    combinatorial content of T1.
--------------------------------------------------------------------------

data Val : Type where
  wv u1 u2 : Val

Pred : Type
Pred = Val → Bool

posit : Pred
posit wv = false
posit u1 = true
posit u2 = true

phi : Pred
phi wv = true
phi u1 = true
phi u2 = false

psi : Pred
psi wv = false
psi u1 = true
psi u2 = false

neg : Pred → Pred
neg p v = not (p v)

conj : Pred → Pred → Pred
conj g p v = g v and p v

-- Entailment, by exhaustion over the three valuations.
allV : Pred → Bool
allV f = f wv and (f u1 and f u2)

ent : Pred → Pred → Bool
ent g p = allV (λ v → not (g v) or p v)

--------------------------------------------------------------------------
-- 3. Responses, rules, plays.
--------------------------------------------------------------------------

data Resp : Type where
  grant deny : Resp

RespCode : Resp → Type
RespCode grant = Unit
RespCode deny  = ⊥

grant≢deny : ¬ (grant ≡ deny)
grant≢deny p = subst RespCode p tt

act : Resp → Pred → Pred
act grant p = p
act deny  p = neg p

-- A rule reads the current state and the proposal.  Nothing more general is
-- needed: the positum and the actual world are fixed throughout.
Rule : Type
Rule = Pred → Pred → Resp

step : Rule → Pred → Pred → Pred
step R g p = conj g (act (R g p) p)

play2 : Rule → Pred → Pred → Pred → Pred
play2 R g a b = step R (step R g a) b

--------------------------------------------------------------------------
-- 4. T1 --- THE TRILEMMA.  Quantified over every rule.
--------------------------------------------------------------------------

module _ (R : Rule) where

  playAB playBA : Pred
  playAB = play2 R posit phi psi     -- phi proposed first
  playBA = play2 R posit psi phi     -- psi proposed first

  -- (ii) order-independence : the two plays end in the same state
  -- (iii) consistency       : that state is satisfiable
  -- (iv) actuality          : a proposal that is impertinent to the positum,
  --                           when proposed FIRST, is answered by its truth
  --                           value at the actual world `wv`.
  --
  -- Note `phi wv` reduces to `true` and `psi wv` to `false`, so (iv) reads
  -- "grant phi first, deny psi first" -- exactly Burley's and Swyneshed's
  -- shared clause for impertinents.
  trilemma :
      ((v : Val) → playAB v ≡ playBA v)
    → (Σ[ u ∈ Val ] playAB u ≡ true)
    → (R posit phi ≡ (if phi wv then grant else deny))
    → (R posit psi ≡ (if psi wv then grant else deny))
    → ⊥
  trilemma orderIndep (u , satAB) actPhi actPsi = contradiction u positTrue phiTrue psiFalse
    where
      satBA : playBA u ≡ true
      satBA = sym (orderIndep u) ∙ satAB

      -- Peel the outer conjunction of each play.
      preAB : (posit u and act (R posit phi) phi u) ≡ true
      preAB = andTrueL satAB

      preBA : (posit u and act (R posit psi) psi u) ≡ true
      preBA = andTrueL satBA

      positTrue : posit u ≡ true
      positTrue = andTrueL preAB

      -- phi was proposed first in play AB, so (iv) fixes its response.
      phiActed : act (R posit phi) phi u ≡ true
      phiActed = andTrueR preAB

      phiTrue : phi u ≡ true
      phiTrue = sym (cong (λ r → act r phi u) actPhi) ∙ phiActed

      -- psi was proposed first in play BA, so (iv) fixes its response.
      psiActed : act (R posit psi) psi u ≡ true
      psiActed = andTrueR preBA

      psiNegTrue : not (psi u) ≡ true
      psiNegTrue = sym (cong (λ r → act r psi u) actPsi) ∙ psiActed

      psiFalse : psi u ≡ false
      psiFalse = notTrue→false (psi u) psiNegTrue

      -- The witness has no model: `wv` fails the positum, `u1` grants psi
      -- against actuality, `u2` denies phi against actuality.
      contradiction : (x : Val) → posit x ≡ true → phi x ≡ true → psi x ≡ false → ⊥
      contradiction wv h _ _ = false≢true h
      contradiction u1 _ _ h = true≢false h
      contradiction u2 _ h _ = false≢true h

--------------------------------------------------------------------------
-- 5. T2 --- Burley's positio: (iii) and (iv) hold, (ii) FAILS.
--
--    Pertinence is judged against the accumulated state.  Everything below
--    is a closed computation; each proof is `refl` unless marked.
--------------------------------------------------------------------------

burley : Rule
burley g p = if ent g p        then grant
             else (if ent g (neg p) then deny
             else (if p wv then grant else deny))

burleyAB burleyBA : Pred
burleyAB = play2 burley posit phi psi
burleyBA = play2 burley posit psi phi

-- Burley obeys (iv): both proposals are impertinent to the bare positum, so
-- the first response is actuality.
burleyActPhi : burley posit phi ≡ (if phi wv then grant else deny)
burleyActPhi = refl

burleyActPsi : burley posit psi ≡ (if psi wv then grant else deny)
burleyActPsi = refl

-- Burley obeys (iii): each play's final state is satisfiable -- neither
-- respondent has granted an inconsistent set, so neither has lost.
burleyAB-sat : burleyAB u1 ≡ true
burleyAB-sat = refl

burleyBA-sat : burleyBA u2 ≡ true
burleyBA-sat = refl

-- The two final states are the two DISJOINT singletons {u1} and {u2}.
burleyAB-wv : burleyAB wv ≡ false
burleyAB-wv = refl

burleyAB-u2 : burleyAB u2 ≡ false
burleyAB-u2 = refl

burleyBA-wv : burleyBA wv ≡ false
burleyBA-wv = refl

burleyBA-u1 : burleyBA u1 ≡ false
burleyBA-u1 = refl

-- Hence: two rule-correct plays over the same positum and the same two
-- proposals reach JOINTLY INCONSISTENT states.
burleyJointlyInconsistent : (v : Val) → (burleyAB v and burleyBA v) ≡ false
burleyJointlyInconsistent wv = refl
burleyJointlyInconsistent u1 = refl
burleyJointlyInconsistent u2 = refl

-- (ii) is refuted.
burleyOrderDependent : ¬ ((v : Val) → burleyAB v ≡ burleyBA v)
burleyOrderDependent h = true≢false (sym burleyAB-sat ∙ h u1 ∙ burleyBA-u1)

-- The responses themselves diverge, not merely the bookkeeping: psi is
-- granted when proposed second and denied when proposed first.
burleyPsiSecond : burley (step burley posit phi) psi ≡ grant
burleyPsiSecond = refl

burleyPsiFirst : burley posit psi ≡ deny
burleyPsiFirst = refl

burleyResponseDiverges : ¬ (burley (step burley posit phi) psi ≡ burley posit psi)
burleyResponseDiverges h = grant≢deny (sym burleyPsiSecond ∙ h ∙ burleyPsiFirst)

-- T2' --- THE ENSEMBLE INVARIANTS ARE REALISED BY NO PLAY.
--
--    Enumerate the reachable set R = {burleyAB, burleyBA} and take its meet
--    and join, as one does when one prefers the recursively enumerated space
--    to the individual object.  Then:
--
--      meet R = bottom   (`burleyJointlyInconsistent`)
--      join R = posit    (`burleyJoinIsPositum`)
--
--    and NEITHER is the outcome of any play: both plays are satisfiable
--    (`burleyAB-sat`, `burleyBA-sat`) and both strictly refine the positum
--    (the two negative results below).  So the ensemble reports either
--    "the evidence is contradictory" or "the reviews added nothing", and no
--    reviewer ever found either.  The individual plays are each unimpeachable
--    and collectively contradictory; the ensemble object exists and is
--    occupied by nobody.  R is not a lattice interval spanned by its plays.
burleyJoinIsPositum : (v : Val) → (burleyAB v or burleyBA v) ≡ posit v
burleyJoinIsPositum wv = refl
burleyJoinIsPositum u1 = refl
burleyJoinIsPositum u2 = refl

burleyABStrictlyRefines : ¬ ((v : Val) → burleyAB v ≡ posit v)
burleyABStrictlyRefines h = false≢true (h u2)

burleyBAStrictlyRefines : ¬ ((v : Val) → burleyBA v ≡ posit v)
burleyBAStrictlyRefines h = false≢true (h u1)

--------------------------------------------------------------------------
-- 6. T3 --- prefix-blind rules: (ii) holds for ARBITRARY finite proposal
--    lists; Swyneshed's rule attains (ii) + (iv) and REFUTES (iii).
--------------------------------------------------------------------------

-- A prefix-blind verdict function and the update it induces.
blindUpd : (rho : Pred → Resp) → Pred → Pred → Pred
blindUpd rho g p = conj g (act (rho p) p)

blindComm : (rho : Pred → Resp) (g : Pred) (x y : Pred)
          → blindUpd rho (blindUpd rho g x) y ≡ blindUpd rho (blindUpd rho g y) x
blindComm rho g x y = funExt (λ v → andComm3 (g v) (act (rho x) x v) (act (rho y) y v))

-- THE POSITIVE HALF: prefix-blindness buys order-independence outright, for
-- every finite proposal list and every permutation of it.
blindOrderIndependent :
    (rho : Pred → Resp) {xs ys : List Pred} → Perm xs ys → (g : Pred)
  → foldl (blindUpd rho) g xs ≡ foldl (blindUpd rho) g ys
blindOrderIndependent rho p g = foldlPermInvariant (blindUpd rho) (blindComm rho) p g

-- Swyneshed: pertinence is measured against the POSITUM only.
swynRho : Pred → Resp
swynRho p = if ent posit p        then grant
            else (if ent posit (neg p) then deny
            else (if p wv then grant else deny))

swyn : Rule
swyn _ p = swynRho p

swynAB swynBA : Pred
swynAB = play2 swyn posit phi psi
swynBA = play2 swyn posit psi phi

-- (iv) holds, by the same clause as Burley's.
swynActPhi : swyn posit phi ≡ (if phi wv then grant else deny)
swynActPhi = refl

swynActPsi : swyn posit psi ≡ (if psi wv then grant else deny)
swynActPsi = refl

-- (ii) holds on this witness (and, by `blindOrderIndependent`, in general).
swynOrderIndependent : (v : Val) → swynAB v ≡ swynBA v
swynOrderIndependent wv = refl
swynOrderIndependent u1 = refl
swynOrderIndependent u2 = refl

-- (iii) FAILS: the order-independent final state has no model at all.  This
-- is Swyneshed's known price, recovered here as a computation.
swynUnsatisfiable : (v : Val) → swynAB v ≡ false
swynUnsatisfiable wv = refl
swynUnsatisfiable u1 = refl
swynUnsatisfiable u2 = refl

swynNoModel : ¬ (Σ[ u ∈ Val ] swynAB u ≡ true)
swynNoModel (u , h) = false≢true (sym (swynUnsatisfiable u) ∙ h)

--------------------------------------------------------------------------
-- 7. T4 --- the oracle rule: (ii) + (iii) hold, (iv) FAILS.
--    Answer every proposal by its truth value at a fixed model of the
--    positum.  This is the degenerate corner: consistent and order-free,
--    but it has stopped listening to the actual world.
--------------------------------------------------------------------------

oracleRho : Pred → Resp
oracleRho p = if p u1 then grant else deny

oracle : Rule
oracle _ p = oracleRho p

oracleAB oracleBA : Pred
oracleAB = play2 oracle posit phi psi
oracleBA = play2 oracle posit psi phi

oracleOrderIndependent : (v : Val) → oracleAB v ≡ oracleBA v
oracleOrderIndependent wv = refl
oracleOrderIndependent u1 = refl
oracleOrderIndependent u2 = refl

oracleSat : oracleAB u1 ≡ true
oracleSat = refl

-- (iv) FAILS: psi is impertinent to the positum and false at the actual
-- world, yet the oracle grants it.
oracleViolatesActuality : ¬ (oracle posit psi ≡ (if psi wv then grant else deny))
oracleViolatesActuality h = grant≢deny h

--------------------------------------------------------------------------
-- 8. Corollary in the form the manifest audit needs.
--
--    Read `Rule` as "verdict function of a review event", `posit` as the
--    claim under review, `phi`/`psi` as two reviewers' submitted evidence,
--    and `wv` as the actual state of the mathematics.  Then:
--
--      * T1: no verdict function makes an append-only chain simultaneously
--            order-free, consistent, and faithful to the evidence's own
--            content when it arrives first;
--      * T2: a prefix-reading verdict (the manifest's current shape) can
--            certify two mutually contradictory states from the same
--            evidence set, with no reviewer at fault;
--      * T3: making the verdict prefix-blind repairs order-freeness for
--            every finite arrival order, at the cost of an unsatisfiable
--            certified state -- so a global consistency check is mandatory
--            and cannot be an emergent property of the chain;
--      * T4: the remaining corner abandons the evidence.
--
--    The three corners below are inhabited terms, so tightness of T1 is
--    itself checked and not merely asserted.
--------------------------------------------------------------------------

-- Corner (ii)+(iv), missing (iii): Swyneshed.  Order-free and actual; the
-- certified state has no model (`swynNoModel`).
cornerOrderFree∧Actual :
    ((v : Val) → swynAB v ≡ swynBA v)
  × ((swyn posit phi ≡ (if phi wv then grant else deny))
     × (swyn posit psi ≡ (if psi wv then grant else deny)))
cornerOrderFree∧Actual = swynOrderIndependent , (swynActPhi , swynActPsi)

-- Corner (iii)+(iv), missing (ii): Burley.  Consistent and actual; the two
-- arrival orders certify contradictory states (`burleyOrderDependent`,
-- `burleyJointlyInconsistent`).
cornerConsistent∧Actual :
    (Σ[ u ∈ Val ] burleyAB u ≡ true)
  × ((burley posit phi ≡ (if phi wv then grant else deny))
     × (burley posit psi ≡ (if psi wv then grant else deny)))
cornerConsistent∧Actual = (u1 , burleyAB-sat) , (burleyActPhi , burleyActPsi)

-- Corner (ii)+(iii), missing (iv): the oracle.  Order-free and consistent;
-- it has stopped reading the evidence (`oracleViolatesActuality`).
cornerOrderFree∧Consistent :
    ((v : Val) → oracleAB v ≡ oracleBA v)
  × (Σ[ u ∈ Val ] oracleAB u ≡ true)
cornerOrderFree∧Consistent = oracleOrderIndependent , (u1 , oracleSat)
