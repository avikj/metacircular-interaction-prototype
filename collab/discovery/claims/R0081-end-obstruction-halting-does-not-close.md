---
id: R0081
title: Every quotation leaves a diagonal observable outside its image, so a contracting machine closes every question and is still not finished
status: breaking
kind: obstruction
certificate: formal
load_bearing: false
novelty: known
generator: commit-41b088b7-endobstruction-questionmachine-landed-unregistered
dependencies: none
statement_hash: 625039603dba43b8f08a41bf50a7a99d306c781f7fac7847c5f906f5e8542138
cycle: 4
max_cycles: 6
owner: claude-opus-5-naturalmachine-lane
breaker: claude-breaker-naturalmachine-lane
source: formal/cubical/NaturalMachine/EndObstruction.agda
supersedes: none
updated: 2026-08-15
---

# Tension

The question machine `𝔉_Ω = Φ ∘ Attack ∘ Γ ∘ Class ∘ 𝔇 ∘ η ∘ R` carries an
obstruction measure `∂`, and if `∂` strictly decreases whenever it is positive
then every question it is handed resolves.  That is a completeness statement,
and completeness invites a second, illegitimate one: that the machine could
therefore be finished — that "the universe is solved".  The two statements are
about different objects (`∂` on one side, a quotation `⌜−⌝` on the other), and
the question is whether the second survives the first.  Stating them together
is the only way to see that they do not compete.

# Rosetta bridge

The common object is a quotation `⌜−⌝ : 𝒬 → (𝒬 → Bool)`: the machine's ability
to name its own `Bool`-valued observables.  Termination lives on `∂ : 𝒬 → ℕ`
and is a well-founded-descent fact; self-description lives on `⌜−⌝` and is a
diagonal fact.  The bridge is that both are statements about the same carrier
`𝒬` and neither mentions the other's structure, so their conjunction is
inhabited whenever both are — which is what makes "halting does not close" a
theorem about *independence* rather than a tension to be resolved.

# Exact statement

In `module NaturalMachine.EndObstruction`, with `Observable 𝒬 = 𝒬 → Bool`,
`Quote 𝒬 = 𝒬 → Observable 𝒬`, and `diag : {𝒬 : Type₀} → Quote 𝒬 → Observable 𝒬`
defined by `diag ⌜_⌝ x = not (⌜ x ⌝ x)`, the following are proved: `δ-end :
{𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (x : 𝒬) → ¬ (⌜ x ⌝ ≡ diag ⌜_⌝)`;
`no-complete-quotation : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ ((d : Observable 𝒬) →
Σ[ x ∈ 𝒬 ] ⌜ x ⌝ ≡ d)`; and `next-door : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → Σ[ d ∈
Observable 𝒬 ] ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d))`, so the missing observable is
exhibited and not merely asserted to exist.  In `module
NaturalMachine.QuestionMachine`, with `record Machine (𝒬 : Type₀)` carrying `∂ :
𝒬 → ℕ` and `𝔉 : 𝒬 → 𝒬`, `orbit M zero q = q`, `orbit M (suc k) q = orbit M k (𝔉
M q)`, `Resolves M q = Σ[ k ∈ ℕ ] ∂ M (orbit M k q) ≡ 0`, and `Contracting M =
(q : 𝒬) → 0 < ∂ M q → ∂ M (𝔉 M q) < ∂ M q`, the following are proved: `halts :
{𝒬 : Type₀} (M : Machine 𝒬) → Contracting M → (q : 𝒬) → Resolves M q`;
`never-final : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → Σ[ d ∈ Observable 𝒬 ] ((q : 𝒬) → ¬
(⌜ q ⌝ ≡ d))`; and `halting-does-not-close : {𝒬 : Type₀} (M : Machine 𝒬) (⌜_⌝ :
Quote 𝒬) → Contracting M → (q : 𝒬) → Resolves M q × (Σ[ d ∈ Observable 𝒬 ] ((r
: 𝒬) → ¬ (⌜ r ⌝ ≡ d)))`.  `halts` is proved by an auxiliary `halts-fuel`
recursing on a natural-number fuel initialised to `∂ M q`; `never-final` is
`next-door`; and `halting-does-not-close M ⌜_⌝ c q` is the pair `halts M c q ,
never-final ⌜_⌝`.

# Preservation ledger

- Preserved: constructivity throughout.  No truncation, no excluded middle, no
  choice; `δ-end` is proved from `x≢not` by `funExt⁻`, and `next-door` returns
  the diagonal observable itself.
- Preserved: the independence.  `halts` mentions only `∂` and `𝔉`;
  `never-final` mentions only `⌜−⌝`.  Neither hypothesis constrains the other's
  data.
- Introduced: nothing.  There is no numeral, no measurement and no choice of
  presentation anywhere in either module.
- Not claimed, and this must be stated plainly: `halting-does-not-close` is a
  **pair constructor**.  Its proof term is `halts M c q , never-final ⌜_⌝` and
  contains no interaction between the two components.  The content of the
  statement is entirely in the fact that the two hypotheses are jointly
  satisfiable and the conclusion of one does not weaken the other — a
  clarification, deliberately typed so that it cannot be overstated in prose,
  not a theorem with an argument in it.
- Not claimed: any halting result about a machine that is *not* assumed
  contracting.  `Contracting` is a hypothesis, and supplying it is where all
  the difficulty of any real instance lives.  This packet contains no instance.
- Role: formalising.  Not load-bearing, and unlikely ever to be: the general
  form of `δ-end` is already in the repository (see Prior art), so anything
  wanting it should depend on that instead.

# Proof obligations

1. `x≢not : (x : Bool) → ¬ (x ≡ not x)`, by a `Bool`-indexed code family and
   `subst`, avoiding pattern-matching on paths.
2. `δ-end`: apply the claimed path at `x` with `funExt⁻` and hit (1).
3. `no-complete-quotation`, `next-door`: package (2); the second exhibits `diag
   ⌜_⌝` as the witness.
4. `≤zero→≡zero` and `zeroOrPos`, the two arithmetic facts `halts-fuel` needs.
5. `halts-fuel`: structural recursion on the fuel, with `pred-≤-pred ∘ ≤-trans`
   supplying the room for the recursive call; `halts` instantiates the fuel at
   `∂ M q` with `(0 , refl)`.
6. `halting-does-not-close`: pairing.

# Falsification

- The mathematics here is not seriously attackable; the honest attacks are all
  attacks on the packet's *claims about itself*.
- Show that `δ-end` is a special case of something already proved in this
  repository, in which case this module should be a corollary and not a proof.
  This attack succeeds: see Prior art.
- Show that `halts` is a special case of well-founded recursion on `<` on `ℕ`,
  in which case the fuel is an implementation detail rather than a method.
  This attack also succeeds; the lane's own `NaturalMachine/KFlowWF.agda`
  (commit `630ffc19`) replaces the fuel with accessibility pushed back along
  the measure.
- Show that `halting-does-not-close` says nothing that its two conjuncts do not
  already say.  Formally this succeeds too — it is a pair — and the packet
  concedes it in the ledger rather than defending it.
- Attack the reading, which is where a real error could hide: if any note or
  paper section derived from these modules asserts a limitative result about
  *machines* (a Gödel- or Turing-flavoured claim) rather than about
  *quotations*, that inference is not licensed here.  `𝒬` is any type and
  `⌜−⌝` is any function; nothing computational is assumed of either.

# Evidence

`formal/cubical/NaturalMachine/EndObstruction.agda` (62 lines) and
`formal/cubical/NaturalMachine/QuestionMachine.agda` (90 lines), both with
`{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}`.  Both
typecheck to exit 0 under Agda 2.6.3 on 2026-08-15; no postulates, no holes, no
`TERMINATING`, no `--allow-*` (checked by grep over both files).  Landed as
commit `41b088b7`, session `session_01QWDKiQtKZWPeWaUzWf2YmX`.

Toolchain skew, recorded rather than hidden.  The installed library is
**cubical v0.7** (`/tmp/cubical/cubical.agda-lib` declares `name: cubical-0.7`;
`git describe --tags` in that tree returns `v0.7`), while this lane's module
headers say **cubical v0.5** and `formal/cubical/BUILD.md` documents a **v0.9**
migration.  Three versions named in three places, one installed.  These two
modules import only `Prelude`, `Bool`, `Nat`, `Nat.Order`, `Empty`, `Unit`,
`Sum`, `Sigma` and `Relation.Nullary`, all stable across those versions, so the
skew is not load-bearing *here* — but it is load-bearing in the tree, and this
packet does not pretend the container matches the headers.

Verification scope, per `formal/cubical/BUILD.md`: verification means the root
aggregate exits 0.  **It does not today.**  `agda NaturalMachine.agda` fails at
`NaturalMachine/PathIsSymmetry.agda:98,50-58` with `Not in scope: SymGroup`;
the installed v0.7 spells that group `Symmetric-Group`
(`/tmp/cubical/Cubical/Algebra/SymmetricGroup.agda:19`).  `PathIsSymmetry` is
unreachable from both modules registered here, so the failure is unrelated to
this mathematics — but the root green claim may not be quoted, and is not.

# Independent audit

Unassigned, and a breaker's time is better spent elsewhere unless the corpus
starts citing these names.  If it does, the audit to perform is textual rather
than mathematical: check every note, paper section and message that cites
`δ-end`, `never-final` or `halting-does-not-close` and confirm that none of
them upgrades a statement about quotations into a statement about computation,
and that none of them presents the pair `halting-does-not-close` as a proof
that the two facts interact.

# Prior art

Known, old, and already present in this repository — all three, and the packet
is worth filing mainly to record that.

Externally: the argument is Cantor's diagonal (1891) in the form given by
F. W. Lawvere, *Diagonal arguments and cartesian closed categories* (1969).
`δ-end` is the `B = Bool`, `f = not` instance of Lawvere's fixed-point theorem;
Russell, Tarski, Gödel and Turing are the other standard instances of the same
contrapositive.  `halts` is strong induction on a natural-number measure,
presented with an explicit fuel — the standard well-founded-descent argument.

Internally, which matters more: the general theorem is **already formalized in
this repository** at `formal/cubical/LawvereDiagonal.agda`, in the untruncated
pointwise form `WkPtSurj e = (f : A → Y) → Σ[ a ∈ A ] ((x : A) → e a x ≡ f x)`,
for arbitrary `Y` and arbitrary fixed-point-free `ν` — strictly more general
than `EndObstruction`, which fixes `Y = Bool` and `ν = not`.  The lane has
since acknowledged this itself: `formal/cubical/NaturalMachine/Lawvere.agda`
(commit `630ffc19`) states "NOTHING HERE IS NEW", cites Lawvere 1969, records
`LawvereDiagonal.agda` as in-repository prior art, proves the pointwise and
path forms interderivable, and derives `δ-end` and `no-complete-quotation` as
the `Bool`/`not` instance "so that the machine's end-obstruction is visibly a
corollary and not an independent argument".  `EndObstruction.agda` as
registered here is therefore a re-proof of an in-corpus result under a private
name, of the kind `notes/PRIOR_ART_INDEX.md` exists to stop.  It is registered
as such.  `novelty: known`.

Search discipline, honestly reported: the in-repository search was performed
and found the duplication above.  No external search was performed —
`WebFetch` is egress-blocked here and no `WebSearch` was run — so the Lawvere
attribution rests on standard knowledge and on the citation already written
into `Lawvere.agda`, not on a source opened during this registration.  Per
`collab/PROTOCOL.md` §0 that is not a discharge of a `SEARCH` obligation; the
obligation is moot only because no novelty is claimed.

# Successor seeds

- Rewrite `EndObstruction.agda` as a thin corollary of `LawvereDiagonal.agda`
  and delete the duplicated diagonal, or register `Lawvere.agda` — which
  already does the reduction — as the successor packet and mark this one
  `superseded`.  Deleting the duplicate is the better outcome.
- Replace `halts-fuel` by well-founded recursion; `NaturalMachine/KFlowWF.agda`
  has done this and generalised the measure to any well-founded relation, with
  `KFlow.decay` returning as the instance `μ = id`.
- Supply one instance.  `Contracting` is the entire difficulty and this packet
  exhibits no machine satisfying it; a checked instance would turn a schema
  into a result.
- Ask the sharper question the modules gesture at and do not answer: is there a
  `∂` whose descent is *itself* one of the observables `⌜−⌝` cannot name?  That
  would make the two halves interact, which `halting-does-not-close` currently
  does not.

# Event log

- 2026-08-15: registered retrospectively.  The modules landed in commit
  `41b088b7` without a claim message and without a packet, so `generator` names
  the commit rather than a `msg-NNNN`.
- 2026-08-15: `unregistered → seed`, then `seed → formalizing`, then
  `formalizing → proving`.  Author-proved, breaker unassigned; not `certified`,
  and certification transitions are disabled in this registry in any case.
- 2026-08-15: recorded at registration that commit `630ffc19` (later than the
  registered modules) already supersedes the mathematics of
  `EndObstruction.agda` via `NaturalMachine/Lawvere.agda`.  Status is left
  `proving` rather than `superseded` because no packet yet exists for
  `Lawvere.agda` to be superseded *by*; `supersedes`/`superseded` must name a
  packet, not a commit.
