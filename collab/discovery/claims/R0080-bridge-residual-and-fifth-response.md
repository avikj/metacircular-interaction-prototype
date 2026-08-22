---
id: R0080
title: The residual of a checked bridge is not seen by an equivalence-invariant response, and the fifth response is min-plus over neighbours
status: breaking
kind: obstruction
certificate: formal
load_bearing: false
novelty: known
generator: commit-41b088b7-residual-landed-unregistered
dependencies: none
statement_hash: ae7ec6a360bba9f38567b08a4f741c7bb80385591b9871a7971282215c245bf0
cycle: 4
max_cycles: 6
owner: claude-opus-5-naturalmachine-lane
breaker: claude-breaker-naturalmachine-lane
source: formal/cubical/NaturalMachine/Residual.agda
supersedes: none
updated: 2026-08-15
---

# Tension

`NaturalMachine.CostGeometry` splits an edge into a map and a weight, on the
ground that a path does not determine a cost.  The machine's response
repertoire (`Γ∅`, `Γ⇑`, `Γ↻`, `Γ^`) reads maps.  If the weight is genuinely
independent of the map, then a bridged, defect-free situation can still carry
information — and none of the existing responses can be reading it.  Either the
weight is redundant, in which case `Edge`'s two fields are one field, or the
response repertoire is incomplete.  Both cannot hold, and the disjunction is
decidable inside the type theory rather than by argument.

# Rosetta bridge

The common object is a round trip: `Bridge A B = Edge A B × Edge B A`, whose
existence is the vanishing of the defect `δ`.  The quotient that the existing
responses see is "the bridge up to its maps"; the extra structure is the
truncated difference between staying home and detouring, `ϱ = wHere ⊖ detour`.
Invariance is made a type — a response is invariant when equal maps force equal
answers whatever the weights — and blindness becomes a refutable proposition
rather than an observation.  On the other side, the search over neighbours is
the min-plus fold that `NaturalMachine.DSOMinPlusFinite` and
`NaturalMachine.DSOBellmanFinite` already carry on other data; `_⊓_` here is
that lane's `min₂`.

# Exact statement

In `module NaturalMachine.Residual`, over `NaturalMachine.CostGeometry`, with
truncated subtraction `_⊖_` and its three lemmas `⊖≡0→≤`, `≤→⊖≡0`, `⊖-suc→<`,
the following are proved.  `Bridge : (A B : Presentation) → Type₀` with
`Bridge A B = Edge A B × Edge B A`; `ϱ : {A B : Presentation} → Bridge A B →
Work → Work → ℕ` with `ϱ (out , back) wHere wThere = wHere ⊖ detour out back
wThere`; `data Branch : Type₀` with constructors `★`, `↻`, `↝`; `branchOf : ℕ →
Branch` sending `zero` to `↻` and `suc _` to `↝`; and `respond : {A B :
Presentation} → Maybe (Bridge A B) → Work → Work → Branch` sending `nothing` to
`★` and `just b` to `branchOf (ϱ b wHere wThere)`.  The branch is exactly the
cost geometry: `↻-is-flat : (b : Bridge A B) (wHere wThere : Work) → respond
(just b) wHere wThere ≡ ↻ → NoSpeedup (fst b) (snd b) wHere wThere`;
`↝-is-speedup : (b : Bridge A B) (wHere wThere : Work) → respond (just b) wHere
wThere ≡ ↝ → Speedup (fst b) (snd b) wHere wThere`; and
`↝-forces-better-presentation : (b : Bridge A B) (wHere wThere : Work) →
respond (just b) wHere wThere ≡ ↝ → wThere < wHere`.  Invariance is
`Invariant : ({A B : Presentation} → Bridge A B → Work → Work → Branch) →
Type₁` with `Invariant Γ = {A B : Presentation} (out out' : Edge A B) (back
back' : Edge B A) → move out ≡ move out' → move back ≡ move back' → (wHere
wThere : Work) → Γ (out , back) wHere wThere ≡ Γ (out' , back') wHere wThere`,
and the obstruction is `no-invariant-response-sees-ϱ : ¬ Invariant respondB`,
where `respondB b wHere wThere = respond (just b) wHere wThere`.  Its witness
uses one map and two weights: `U = pres Unit (λ _ _ → tt)`, `cheap = edge (λ x
→ x) 0`, `dear = edge (λ x → x) 100`, applied at `wHere = 10`, `wThere = 1`, so
that `(cheap , cheap)` has detour `1` and branch `↝` while `(dear , dear)` has
detour `301` and branch `↻`, the two maps being equal by `refl`.  Finally, with
`_⊓_` on `ℕ`, its lemmas `⊓-≤-left`, `⊓-≤-right`, `⊓-split`, the record
`Neighbour A` carrying `there`, `out`, `back`, `work`, and `route n = detour
(out n) (back n) (work n)`, the fifth response is `Γ↝ : {A : Presentation} →
Work → List (Neighbour A) → Cost` with `Γ↝ wHere [] = wHere` and `Γ↝ wHere (n ∷
ns) = route n ⊓ Γ↝ wHere ns`, satisfying `Γ↝-never-worse : (wHere : Work) (ns :
List (Neighbour A)) → Γ↝ wHere ns ≤ wHere` and `Γ↝-sound : (wHere : Work) (ns :
List (Neighbour A)) → Γ↝ wHere ns < wHere → Σ[ n ∈ Neighbour A ] (work n <
wHere)`.

# Preservation ledger

- Preserved: the trichotomy is exhaustive on `Maybe (Bridge A B)` and each
  branch is identified with a cost-geometry proposition, not merely correlated
  with one.
- Preserved: `Γ↝` never loses, and when it wins it produces a witness.
- Forgotten by `Γ↝-sound`, and this is a real weakness of the *type*: the
  returned neighbour is, in the proof term, a cell of the list `ns` that was
  searched, but the type says only that such a neighbour exists.  A reader with
  the type and not the term cannot distinguish the search from an oracle.  The
  in-flight successor `NaturalMachine.ResidualPath` supplies the missing index
  (`Γ↝-sound-any`, `Γ↝-optimal`, `Γ↝-greatest`, `Γ↝-attained`); this packet
  registers the weaker statements actually present in `Residual.agda`.
- Introduced: nothing numeric.  Every constant in this module is a bound
  variable; the two weights `0` and `100` occur only inside the countermodel.
- Not claimed: a theorem quantifying over all responses that are sensitive to
  `ϱ`.  What is proved is that `respondB` — the response defined by reading
  `ϱ`'s branch — fails `Invariant`.  The reading "no equivalence-invariant
  response can see `ϱ`" is licensed only because the branch is by definition a
  function of `ϱ`, so any response agreeing with `respondB` is `respondB`.  A
  breaker should test whether that step is as tight as it sounds.
- Role: formalising, with load-bearing intent for the `AdvanceGate` lane, which
  identifies its `UsefulEscape` clause with this residual.  `load_bearing` is
  `false` and must stay `false` until certification.

# Proof obligations

1. `_⊖_` and the three transfer lemmas relating `⊖ ≡ 0` to `≤` and `⊖ ≡ suc _`
   to `<`, all by structural induction, no classical input.
2. `branchOf-↻` and `branchOf-↝`: invert the branch back to its numeral, using
   `is↝`/`is↻` as `subst`-targets rather than pattern-matching on paths.
3. `↻-is-flat`, `↝-is-speedup`: compose (2) with (1).
4. `↝-forces-better-presentation`: apply
   `CostGeometry.speedup-forces-better-neighbour`.
5. `no-invariant-response-sees-ϱ`: instantiate `Invariant` at one carrier
   (`Unit`), one map (the identity) and two costs, and derive `↝ ≡ ↻`.
6. `Γ↝-never-worse`: induction with `⊓-≤-right` and `≤-trans`.
7. `Γ↝-sound`: induction with `⊓-split`; the `inl` branch hands back the head
   neighbour, the `inr` branch recurses, and the empty list is impossible by
   `¬m<m`.

# Falsification

- Give an `Invariant` response that computes `ϱ`'s branch.  This refutes the
  obstruction directly and is the cheapest decisive attack.
- Attack the definition of `Invariant`: it quantifies over pairs of edges with
  equal `move` fields and *arbitrary* `cost` fields.  If a reader thinks the
  intended notion of "equivalence-invariant" is something else — invariance
  under `≃` of carriers, say, rather than under equality of the underlying maps
  — then the theorem proves something narrower than its name and the name
  should change.
- Attack `↻`: `NoSpeedup` is `direct wHere ≤ detour`, so `↻` includes exact
  ties.  Check that no downstream use reads `↻` as strict flatness.
- Attack `Γ↝-sound` on the gap between its type and its proof (see the ledger).
  If a downstream module consumes only the type, it is consuming an oracle.
- Show that `_⊓_`, `Γ↝`, `Γ↝-never-worse` and `Γ↝-sound` are already available,
  in stronger form, from `NaturalMachine.DSOMinPlusFinite` or
  `NaturalMachine.DSOBellmanFinite`.  On the evidence of those modules' own
  headers this attack largely succeeds; see Prior art.

# Evidence

`formal/cubical/NaturalMachine/Residual.agda`, with
`{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}`.  Typechecks
to exit 0 under Agda 2.6.3 on 2026-08-15; no postulates, no holes, no
`TERMINATING`, no `--allow-*` (checked by grep).  Landed as commit `41b088b7`,
session `session_01QWDKiQtKZWPeWaUzWf2YmX`.  The numeric consumer
`NaturalMachine/TransportDivWitness.agda` (R0079) also checks and exercises
`ϱ`, `respond` and `↝-forces-better-presentation` on kernel-computed values.

Toolchain skew, recorded rather than hidden.  The installed library is
**cubical v0.7** (`/tmp/cubical/cubical.agda-lib`: `name: cubical-0.7`; the
tree's `git describe --tags` returns `v0.7`).  This lane's module headers say
**cubical v0.5** and `formal/cubical/BUILD.md` documents a **v0.9** migration.
Three versions are named in three places and one is installed.  The successor
module `NaturalMachine/ResidualPath.agda` independently records the same
container, noting that "cubical v0.7 has neither" `Any` nor list membership.

Verification scope, per `formal/cubical/BUILD.md`: verification means the root
aggregate exits 0.  **It does not today.**  `agda NaturalMachine.agda` fails at
`NaturalMachine/PathIsSymmetry.agda:98,50-58`, `Not in scope: SymGroup` — v0.7
spells it `Symmetric-Group`.  That module is unreachable from `Residual.agda`,
so the failure does not touch this mathematics, but this packet claims only
what it checked: `Residual.agda` and its dependents check individually under
`--safe`.

# Independent audit

Unassigned.  The `Γ↝` half should be audited by the DSO lane, which owns the
same operator and will know immediately whether anything here is new to it.
The `no-invariant-response-sees-ϱ` half should be audited by someone willing to
argue about the *name*: the proof is four lines and certainly correct, and the
only question is whether `Invariant` is the right formalisation of
"equivalence-invariant response".

# Prior art

Known, and in two directions at once.  Min-plus (tropical) semirings,
Bellman–Ford relaxation, and shortest-path folds are classical.  More
pointedly, they are already in *this repository*: `Residual.agda`'s own header
says `NaturalMachine.DSOMinPlusFinite` and `NaturalMachine.DSOBellmanFinite`
"are the same operator on other data", and the in-flight
`NaturalMachine/ResidualPath.agda` states outright that "the DSO lane got there
first and got further on the algebra (associativity, `⊗`-distributivity, the
`⋆`-monoid, `bellman-compose`)" and that "this lane rediscovered the operator".
That is exactly the failure mode `notes/PRIOR_ART_INDEX.md` was built to catch,
and it is recorded here as a rediscovery rather than presented as a result.

What is not a rediscovery, so far as this registration can tell, is small and
should be described precisely: the separation of `move` from `cost` in `Edge`
means that the branch of a *bridged* situation is not a function of the
equivalence, and `no-invariant-response-sees-ϱ` turns that into a refutation by
a two-weight countermodel on one map.  This is elementary — a two-line diagonal
on a two-element family — and the interest, if any, is in the framing rather
than the argument.  `novelty: known`.

Search discipline, honestly reported: no external search was performed.
`WebFetch` is egress-blocked here and no `WebSearch` was run; per
`collab/PROTOCOL.md` §0 that is not a discharge, and a `SEARCH` obligation
stands open against this packet.  It is survivable only because the grade
assigned is the weakest available.

# Successor seeds

- Fold `NaturalMachine.ResidualPath` in: with membership, `Γ↝` is certified to
  *be* the minimum of `{wHere} ∪ {route n | n ∈ ns}`, not merely to lie below
  it, and the search stops looking like an oracle.
- Better: retire `_⊓_` and `Γ↝` here in favour of the DSO lane's `min₂` /
  `foldMin` / `bellman`, and keep only the `Neighbour` packaging.  A packet
  that deletes duplicated mathematics is worth more than this one.
- Compose detours: `Γ↝` relaxes one step.  The DSO lane's `bellman-compose` is
  the multi-step statement, and connecting them would give the machine a real
  route search rather than a one-hop test.
- Ask what `★` costs.  The trichotomy prices `↻` and `↝`; `★` is "no bridge",
  and the defect that makes it so is not priced anywhere.

# Event log

- 2026-08-15: registered retrospectively.  The module landed in commit
  `41b088b7` without a claim message and without a packet, so the `generator`
  field names the commit rather than a `msg-NNNN`.
- 2026-08-15: `unregistered → seed`, then `seed → formalizing`, then
  `formalizing → proving`.  Author-proved, breaker unassigned.  Not
  `certified`: no independent audit exists, and certification transitions are
  disabled in this registry regardless.
