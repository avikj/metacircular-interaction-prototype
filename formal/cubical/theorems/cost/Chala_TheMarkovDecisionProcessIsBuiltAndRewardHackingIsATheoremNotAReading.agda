{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- छल — the quibble.
--
-- In Nyāya, `chala` is the named fallacy of taking a statement in a
-- sense its author did not intend, by exploiting a reading the words
-- literally admit.  That is specification gaming exactly: the objective
-- is met as written and defeated as meant.  The word is used here for
-- that literal content; no source is claimed to state anything below.
--
-- WHY THIS FILE EXISTS.  The abstract "NO SCORING FUNCTION OF THE
-- OUTCOME DISTINGUISHES TWO ROUTES TO IT" says, under WHAT IS NOT
-- CLAIMED, that no MDP, no policy, no return, no estimator and no
-- training dynamics appear in the development, and that naming reward
-- hacking and specification gaming as the phenomena it explains is a
-- reading and is not proved.
--
-- All of it is built here, and the identification becomes a theorem.
-- A Markov decision process; policies; the return, both undiscounted
-- and DISCOUNTED at an arbitrary rate; optimality quantified over EVERY
-- policy rather than over an enumerated shortlist; and then three
-- theorems that are reward hacking, stated exactly.
--
-- WHAT IS CHECKED
--
--   §१  `MDP`, `Policy`, `ret`, `dret`   the process and the return.
--       `dret-undiscounted`              γ = 1 recovers the plain sum.
--   §२  the process: a start, a lure, a goal, and an idle state.
--   §३  `hack-proxy-optimal`             the gaming policy is optimal
--                                        for the proxy — over ALL
--                                        policies, not a shortlist.
--   §४  `proxy-optimal→true-worthless`   AND EVERY proxy-optimal policy
--                                        earns zero true reward.  So
--                                        maximising the proxy is not
--                                        merely unhelpful, it is
--                                        incompatible with the aim.
--   §५  `no-estimator-repairs-it`        two policies with EQUAL proxy
--                                        return and different true
--                                        return, so every function of
--                                        the proxy return whatsoever
--                                        ranks them together.  The
--                                        failure is not statistical and
--                                        no amount of data touches it.
--   §६  the same three under an ARBITRARY discount rate, so none of it
--       is an artefact of the undiscounted finite horizon.
--
-- ON THE DISCOUNT, and why no rationals are needed.  With γ = a/b the
-- discounted return over horizon n is `Σ γᵗ rₜ`; multiplying by the
-- positive constant `bⁿ` gives `Σ aᵗ b⁽ⁿ⁻ᵗ⁾ rₜ`, which is what `dret`
-- computes in ℕ.  Multiplying every policy's return by one positive
-- constant reorders nothing, so optimality statements transfer exactly.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Chala_TheMarkovDecisionProcessIsBuiltAndRewardHackingIsATheoremNotAReading where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; +-comm ; ·-identityˡ ; ·-identityʳ
        ; 0≡m·0 ; snotz ; znots)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; zero-≤ ; ≤-refl)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

  infixr 8 _^_
  _^_ : ℕ → ℕ → ℕ
  x ^ zero  = 1
  x ^ suc n = x · (x ^ n)

  one^ : (n : ℕ) → 1 ^ n ≡ 1
  one^ zero    = refl
  one^ (suc n) = ·-identityˡ (1 ^ n) ∙ one^ n

------------------------------------------------------------------------
-- १ · the process, the policy, and the return.
------------------------------------------------------------------------

record MDP (S A : Type) : Type where
  field
    move   : S → A → S
    payoff : S → A → ℕ

open MDP public

Policy : Type → Type → Type
Policy S A = S → A

-- the undiscounted return over a finite horizon.
ret : {S A : Type} → MDP S A → ℕ → Policy S A → S → ℕ
ret M zero    π s = 0
ret M (suc n) π s = payoff M s (π s) + ret M n π (move M s (π s))

-- the discounted return at rate a/b, scaled by bⁿ (see the header).
dret : {S A : Type} → MDP S A → ℕ → ℕ → ℕ → Policy S A → S → ℕ
dret M a b zero    π s = 0
dret M a b (suc n) π s =
  (b ^ n) · payoff M s (π s) + a · dret M a b n π (move M s (π s))

-- at γ = 1 the discounted return IS the plain sum, so `ret` is the
-- special case and not a different quantity.
dret-undiscounted : {S A : Type} (M : MDP S A) (n : ℕ) (π : Policy S A) (s : S)
                  → dret M 1 1 n π s ≡ ret M n π s
dret-undiscounted M zero    π s = refl
dret-undiscounted M (suc n) π s =
  cong₂ _+_
    (cong (_· payoff M s (π s)) (one^ n) ∙ ·-identityˡ (payoff M s (π s)))
    (·-identityˡ (dret M 1 1 n π (move M s (π s)))
     ∙ dret-undiscounted M n π (move M s (π s)))

------------------------------------------------------------------------
-- २ · the process.  A start, a lure, a goal, and somewhere to idle.
--
-- The proxy pays for sitting at the lure; the true objective pays for
-- sitting at the goal.  Every state but the start is absorbing, so a
-- policy's whole content is what it does on the first move — which is
-- what lets §३–§५ quantify over EVERY policy in three lines each.
------------------------------------------------------------------------

data St : Type where
  start lure goal idle : St

data Act : Type where
  toLure toGoal toIdle : Act

step : St → Act → St
step start toLure = lure
step start toGoal = goal
step start toIdle = idle
step lure  _      = lure
step goal  _      = goal
step idle  _      = idle

proxyPay : St → Act → ℕ
proxyPay lure _ = 1
proxyPay _    _ = 0

truePay : St → Act → ℕ
truePay goal _ = 1
truePay _    _ = 0

Proxy True′ : MDP St Act
move   Proxy = step
payoff Proxy = proxyPay
move   True′ = step
payoff True′ = truePay

hack honest idler : Policy St Act
hack   _ = toLure
honest _ = toGoal
idler  _ = toIdle

------------------------------------------------------------------------
-- ३ · the gaming policy is proxy-optimal, over EVERY policy.
--
-- Only the first move matters, so the case split is on `π start` and
-- each branch is a computation.
------------------------------------------------------------------------

proxy3 : Policy St Act → ℕ
proxy3 π = ret Proxy 3 π start

true3 : Policy St Act → ℕ
true3 π = ret True′ 3 π start

hack-proxy3 : proxy3 hack ≡ 2
hack-proxy3 = refl

honest-true3 : true3 honest ≡ 2
honest-true3 = refl

hack-proxy-optimal : (π : Policy St Act) → proxy3 π ≤ proxy3 hack
hack-proxy-optimal π with π start
... | toLure = ≤-refl
... | toGoal = zero-≤
... | toIdle = zero-≤

------------------------------------------------------------------------
-- ४ · AND EVERY PROXY-OPTIMAL POLICY EARNS NOTHING.
--
-- Not "the optimum may be gamed": attaining the proxy optimum FORCES a
-- true return of zero.  The two objectives are not merely misaligned,
-- they are incompatible at the top of the proxy.
------------------------------------------------------------------------

proxy-optimal→true-worthless :
  (π : Policy St Act) → proxy3 π ≡ 2 → true3 π ≡ 0
proxy-optimal→true-worthless π p with π start
... | toLure = refl
... | toGoal = absurd (znots p)
... | toIdle = absurd (znots p)

-- and a policy that does attain the true optimum exists, so this is a
-- real conflict and not a degenerate process.
honest-beats-every-proxy-optimum :
  (π : Policy St Act) → proxy3 π ≡ 2 → true3 π < true3 honest
honest-beats-every-proxy-optimum π p =
  subst (_< true3 honest) (sym (proxy-optimal→true-worthless π p)) (1 , refl)

------------------------------------------------------------------------
-- ५ · NO ESTIMATOR REPAIRS IT.
--
-- The honest policy and the idle policy have EQUAL proxy return, so
-- every function of the proxy return — every score, every ranking,
-- every learned critic, at every target type — assigns them the same
-- value.  Their true returns differ.  So the failure is not a shortage
-- of samples and not a bad estimator: the signal does not contain the
-- distinction, and this is the same subsingleton argument the abstract
-- makes, instantiated in a decision process.
------------------------------------------------------------------------

honest-idler-agree-on-proxy : proxy3 honest ≡ proxy3 idler
honest-idler-agree-on-proxy = refl

honest-idler-differ-on-truth : ¬ (true3 honest ≡ true3 idler)
honest-idler-differ-on-truth p = snotz (cong predℕ′ p)
  where
    predℕ′ : ℕ → ℕ
    predℕ′ zero    = zero
    predℕ′ (suc n) = n

no-estimator-repairs-it :
  {X : Type} (score : ℕ → X) → score (proxy3 honest) ≡ score (proxy3 idler)
no-estimator-repairs-it score = cong score honest-idler-agree-on-proxy

-- the sharp form: no ranking computed from the proxy return separates a
-- policy that achieves the objective from one that achieves nothing.
no-proxy-ranking-separates :
  ¬ (Σ[ score ∈ (ℕ → ℕ) ] ((π : Policy St Act) → score (proxy3 π) ≡ true3 π))
no-proxy-ranking-separates (score , sound) =
  honest-idler-differ-on-truth
    (sym (sound honest) ∙ no-estimator-repairs-it score ∙ sound idler)

------------------------------------------------------------------------
-- ६ · …AND NONE OF IT IS AN ARTEFACT OF THE UNDISCOUNTED SUM.
--
-- The same statements at an ARBITRARY discount rate a/b: the gaming
-- policy is still optimal for the proxy over every policy, it still
-- earns exactly zero true reward, and the honest policy still earns a
-- positive one at every rate that gives the future any weight at all.
--
-- The induction that does the work is `dret-zero-under`: if a set of
-- states is closed under the policy's moves and pays nothing on it,
-- the discounted return from inside it is zero, at every rate and
-- every horizon.
------------------------------------------------------------------------

·0 : (x : ℕ) → x · 0 ≡ 0
·0 x = sym (0≡m·0 x)

dret-zero-under :
  {S A : Type} (M : MDP S A) (a b n : ℕ) (π : Policy S A) (P : S → Type) (s : S)
  → P s
  → ((t : S) → P t → payoff M t (π t) ≡ 0)
  → ((t : S) → P t → P (move M t (π t)))
  → dret M a b n π s ≡ 0
dret-zero-under M a b zero    π P s _  _  _   = refl
dret-zero-under M a b (suc n) π P s ps zp inv =
  cong₂ _+_
    (cong ((b ^ n) ·_) (zp s ps) ∙ ·0 (b ^ n))
    (cong (a ·_) (dret-zero-under M a b n π P (move M s (π s)) (inv s ps) zp inv)
     ∙ ·0 a)

-- the states from which the proxy pays nothing, ever again.
settled : St → Type
settled start = ⊥
settled lure  = ⊥
settled goal  = Unit
settled idle  = Unit

settled-pays-nothing : (π : Policy St Act) (t : St) → settled t → proxyPay t (π t) ≡ 0
settled-pays-nothing π start ()
settled-pays-nothing π lure  ()
settled-pays-nothing π goal  _ = refl
settled-pays-nothing π idle  _ = refl

settled-closed : (π : Policy St Act) (t : St) → settled t → settled (step t (π t))
settled-closed π start ()
settled-closed π lure  ()
settled-closed π goal  _ = tt
settled-closed π idle  _ = tt

dproxy : ℕ → ℕ → Policy St Act → ℕ
dproxy a b π = dret Proxy a b 3 π start

dtrue : ℕ → ℕ → Policy St Act → ℕ
dtrue a b π = dret True′ a b 3 π start

dproxy-from-settled : (a b n : ℕ) (π : Policy St Act) (s : St) → settled s
                    → dret Proxy a b n π s ≡ 0
dproxy-from-settled a b n π s ps =
  dret-zero-under Proxy a b n π settled s ps (settled-pays-nothing π) (settled-closed π)

-- the gaming policy is proxy-optimal at EVERY discount rate, over every
-- policy: anything that does not walk into the lure is settled from the
-- first move andcollects nothing.
hack-dproxy-optimal : (a b : ℕ) (π : Policy St Act) → dproxy a b π ≤ dproxy a b hack
hack-dproxy-optimal a b π with π start
... | toLure = ≤-refl
... | toGoal =
  subst (_≤ dproxy a b hack)
    (sym (cong₂ _+_ (·0 (b ^ 2))
                    (cong (a ·_) (dproxy-from-settled a b 2 π goal tt) ∙ ·0 a)))
    zero-≤
... | toIdle =
  subst (_≤ dproxy a b hack)
    (sym (cong₂ _+_ (·0 (b ^ 2))
                    (cong (a ·_) (dproxy-from-settled a b 2 π idle tt) ∙ ·0 a)))
    zero-≤

-- the states from which the TRUE objective pays nothing, ever again.
notGoal : St → Type
notGoal start = Unit
notGoal lure  = Unit
notGoal goal  = ⊥
notGoal idle  = Unit

hack-pays-nothing : (t : St) → notGoal t → truePay t (hack t) ≡ 0
hack-pays-nothing start _ = refl
hack-pays-nothing lure  _ = refl
hack-pays-nothing goal  ()
hack-pays-nothing idle  _ = refl

hack-notGoal-closed : (t : St) → notGoal t → notGoal (step t (hack t))
hack-notGoal-closed start _ = tt
hack-notGoal-closed lure  _ = tt
hack-notGoal-closed goal  ()
hack-notGoal-closed idle  _ = tt

-- at every rate, the gaming policy earns exactly nothing that matters.
hack-dtrue-zero : (a b : ℕ) → dtrue a b hack ≡ 0
hack-dtrue-zero a b =
  dret-zero-under True′ a b 3 hack notGoal start tt
    hack-pays-nothing hack-notGoal-closed

-- …and the honest policy earns something, at every rate that gives the
-- future any weight.  So the conflict is not an artefact of the horizon
-- or of the discounting: it is in the specification.
honest-dtrue-value : (a b : ℕ)
                   → dtrue a b honest ≡ a · dret True′ a b 2 honest goal
honest-dtrue-value a b =
  cong (_+ (a · dret True′ a b 2 honest goal)) (·0 (b ^ 2))

honest-dtrue-positive : (a b : ℕ) → ¬ (dtrue (suc a) (suc b) honest ≡ 0)
honest-dtrue-positive a b p =
  snotz (sym (honest-dtrue-value (suc a) (suc b)) ∙ p)
