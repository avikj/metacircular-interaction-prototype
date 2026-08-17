---
id: R0079
title: The walk's divisibility test carried across the place-value chart as a Horner residue automaton, with a kernel-computed detour
status: breaking
kind: transport
certificate: formal
load_bearing: false
novelty: known
generator: commit-6bcdba46-transportdiv-landed-unregistered
dependencies: R0080
statement_hash: 1d01cfb147ed5cfe137847376382ea8699a9176ace8a6a7a83d70ed04b3a0f2d
cycle: 4
max_cycles: 6
owner: claude-opus-5-naturalmachine-lane
breaker: claude-breaker-naturalmachine-lane
source: formal/cubical/NaturalMachine/TransportDiv.agda
supersedes: none
updated: 2026-08-15
---

# Tension

`NaturalMachine.Transport` carries `_+_` across the place-value chart and
`NaturalMachine.TransportMul` carries `_·_`, and both close on the same open
remark: the walk (`NaturalMachine.WalkBridge`) stalls at frontier `m ≈ 8`
because its divisibility test is unary, costing `Θ(cap m)` with
`cap m = e^{ψ(m)}`.  The arithmetic around the test was carried; the test was
not.  Against that sits `NaturalMachine.CostGeometry`'s own theorem
`transport-is-never-free`: a checked equivalence transports theorems and never
complexity, so charting cannot help *because* the chart is an equivalence.  If
the chart helps here, the reason must be a separately supplied weight, and it
must be exhibited, not narrated.

# Rosetta bridge

The common object is `CostGeometry.Presentation` — a carrier together with the
operation *as implemented* — and `CostGeometry.Edge`, a record with two
independent fields `move : Carrier A → Carrier B` and `cost : Cost`.  The home
node is `pres ℕ _+_`; the chart node is `pres Word (λ u v → u)` over
`NaturalMachine.Digits k`.  The maps are `digits` and `value`, inverse on
values by `value-digits`; the weights are supplied, not derived, and are set to
`3` in each direction so that the chart is priced rather than assumed free.
`detour out back w = (cost out + cost out) + (cost back + w)` charges the
outbound map once per argument.  What the bridge preserves is the number; what
it does not determine is the pair of weights, and that undetermined pair is the
whole content of the speedup.

# Exact statement

In `module NaturalMachine.TransportDiv (k : ℕ)`, with `b = suc (suc k)`,
`Word = List Digit` and `value` from `NaturalMachine.Digits k`, the following
are proved: `modw : ℕ → Word → ℕ` defined by `modw n [] = 0 mod n` and `modw n
(d ∷ w) = (toℕ d + b · modw n w) mod n`; `scale-mod : (n x : ℕ) → (b · x) mod n
≡ (b · (x mod n)) mod n`; `value-modw : (n : ℕ) (w : Word) → modw n w ≡ value w
mod n`; `modw-zero→∣ : (n : ℕ) (w : Word) → modw (suc n) w ≡ 0 → (suc n) ∣
value w`; `steps : Word → ℕ` defined by `steps [] = 1` and `steps (d ∷ w) = suc
(steps w)`; and `steps-is-length : (w : Word) → steps w ≡ suc (length w)`.  The
modulus in `modw-zero→∣` is positive because `x mod 0 = 0` for every `x`, so
the automaton at `n = 0` is silent by definition and is not a divisibility
claim.  In `module NaturalMachine.TransportDivWitness`, instantiating `Digits
8` and `TransportDiv 8` and setting `thousand = fzero ∷ fzero ∷ fzero ∷ fone ∷
[]`, `unaryP = pres ℕ _+_`, `chartP = pres Word (λ u v → u)`, `chart = edge
digits 3`, `unchart = edge value 3`, `bridge = chart , unchart`, the following
are proved: `base-is-ten : b ≡ 10`; `value-thousand : value thousand ≡ 1000`;
`steps-thousand : steps thousand ≡ 5`; `detour-cost : detour chart unchart 5 ≡
14`; `residual-thousand : ϱ bridge 1000 5 ≡ 986`; `horner-speedup : Speedup
chart unchart 1000 5`; `horner-branch : respond (just bridge) 1000 5 ≡ ↝`; and
`chart-is-better : 5 < 1000`.  Every one of `base-is-ten`, `value-thousand`,
`steps-thousand`, `detour-cost`, `residual-thousand` and `horner-branch` is
closed by `refl`, so each numeral is computed by the kernel and none is
asserted; `horner-speedup` is `985 , refl`; `chart-is-better` is
`↝-forces-better-presentation bridge 1000 5 horner-branch`.

# Preservation ledger

- Preserved: the number under test (`value-digits`, `value-modw`), the
  divisibility relation (`modw-zero→∣`), and the step count as an exact
  identity rather than an asymptotic (`steps-is-length`).
- Forgotten: nothing about the number; `modw` never mentions `value w` in its
  computation, only in its specification.
- Introduced: two edge weights, `3` and `3`, which are stipulations of this
  witness and not consequences of any map.  Change them and every numeral in
  `TransportDivWitness` changes; the statement `detour < home` at base ten and
  the word `1000` survives any charting price below 497.
- Not claimed: that `modw n w ≢ 0` implies non-divisibility.  Only one
  direction is proved here.  The converse, the resulting decision procedure,
  and the home-side automaton are delivered by
  `NaturalMachine.WalkResidueBridge`, which was uncommitted at the time of
  registration and is not covered by this packet.
- Not claimed: that the walk is now fast.  `digits m` iterates the odometer `m`
  times, so charting a unary `m` costs `Θ(m)`.  The 14-against-1000 comparison
  is a statement about a word already in the chart.
- Role: formalising with load-bearing intent.  The walk's frontier depends on
  this test, but nothing in the corpus may depend on this packet until it is
  certified, and `load_bearing` is therefore `false`.

# Proof obligations

1. `scale-mod`: the automaton's state may be reduced at every digit without
   changing the residue (`mod·mod≡mod`, `mod-idempotent`).
2. `value-modw`: by induction on the word, using `mod-rCancel` to push the
   reduction under the leading digit.
3. `modw-zero→∣`: convert a zero final state into an exhibited quotient via
   `≡remainder+quotient`, entering the propositional truncation of `_∣_` with
   `∣_∣₁`.
4. `steps-is-length`: structural.
5. In the witness: instantiate at `k = 8`, check `b ≡ 10` definitionally, and
   let the kernel evaluate the detour, the residual, and the branch.
6. Derive `5 < 1000` from the branch rather than asserting it, so that the
   inequality is a consequence of the classification and not a second numeral.

# Falsification

- Exhibit `n, w` with `modw n w ≢ value w mod n`, or a word with
  `steps w ≢ suc (length w)`.  Both are closed; a counterexample would be a
  kernel bug, not a mathematical one.
- Read `modw-zero→∣` backwards.  A nonzero final state proves nothing in this
  module, and any downstream use of it as a decision procedure is unsound on
  this packet's evidence alone.
- Attack the pricing.  The claim is conditional on `cost chart = cost unchart =
  3`; supply the actual cost of `digits` on a unary numeral and the detour
  loses.  This is the cheapest decisive attack and it should be made.
- Attack the scope of the frontier claim: show that the walk's stall at
  `m ≈ 8` is not caused by the unary divisibility test, in which case carrying
  the test across changes nothing that matters.
- Show that some already-checked module in `~/agda-libs/` or in this repository
  supplies `value-modw` under a standard name, in which case this packet is a
  rediscovery to be recorded as such rather than a transport.

# Evidence

`formal/cubical/NaturalMachine/TransportDiv.agda` and
`formal/cubical/NaturalMachine/TransportDivWitness.agda`, both with
`{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}`.  Both
typecheck to exit 0 under Agda 2.6.3 on 2026-08-15; no postulates, no holes, no
`TERMINATING` pragmas, no `--allow-*` flags (checked by grep over both files).
Landed as commit `6bcdba46`, session `session_01QWDKiQtKZWPeWaUzWf2YmX`.

Toolchain skew, recorded rather than hidden.  The installed library is
**cubical v0.7** (`/tmp/cubical/cubical.agda-lib` declares `name: cubical-0.7`;
`git describe --tags` in that tree returns `v0.7`).  Module headers across this
lane say **cubical v0.5**, and `formal/cubical/BUILD.md` describes a **v0.9**
migration.  Three different versions are named by three different places in the
tree and only one of them is installed.  The skew is not cosmetic: it currently
breaks the root aggregate — see below — and the successor module
`NaturalMachine/ResidualPath.agda` records that "cubical v0.7 has neither" for
`Any`/membership, which is the same container speaking.

Verification scope, per `formal/cubical/BUILD.md` ("verification means the root
aggregate exits 0, not the module you touched").  **The root aggregate does not
currently exit 0.**  `agda NaturalMachine.agda` fails at
`NaturalMachine/PathIsSymmetry.agda:98,50-58` with `Not in scope: SymGroup`;
the installed v0.7 spells that group `Symmetric-Group`
(`/tmp/cubical/Cubical/Algebra/SymmetricGroup.agda:19`), while BUILD.md's
migration notes assume the newer `SymGroup`.  `PathIsSymmetry` is not reachable
from any of this packet's modules, so the failure is unrelated to the
mathematics registered here — but the green root claim may not be quoted for
this packet today, and this packet does not quote it.  What is claimed is
exactly: the five named modules check individually under `--safe`.

# Independent audit

Unassigned.  A breaker should not spend time on `value-modw`, which is short
and mechanical.  The two places worth attacking are the pricing (the `3`s are
stipulated, and the honest cost of `digits` on a unary numeral is `Θ(m)`) and
the frontier attribution (the claim that the unary test, rather than something
else, is what stalls the walk).  A second, independent reading should also
confirm that `modw-zero→∣` is nowhere used as a decision procedure.

# Prior art

Classical, and stated as such.  Evaluating a place-value numeral by
`x ↦ d + b·x` is Horner's scheme; reducing that recurrence modulo `n` is the
standard residue test, of which casting out nines and the familiar divisibility
rules for 3, 9 and 11 are instances.  Recognising `{w : n ∣ value w}` by a
finite automaton with `n` states, one transition per digit, is a textbook
exercise in automata theory.  The claim of this packet is not the automaton but
its placement: `modw` as the `move` of a weighted `Edge`, with the residual and
the branch read off by `NaturalMachine.Residual` (R0080).  `novelty: known`.

Search discipline, honestly reported: no external search was performed for this
registration.  `WebFetch` is egress-blocked in this container and no `WebSearch`
was run.  Per `collab/PROTOCOL.md` §0 that is **not** a discharge of a `SEARCH`
obligation, so one remains open against this packet; it is survivable only
because the novelty grade assigned is the weakest one available.  In-repository
adjacency was checked: `NaturalMachine.CoprimeSplitting` (`dec∣` on unary
numerals), `NaturalMachine.RadixSymptoma`, `NaturalMachine.SensorNerode` and
`NaturalMachine.WalkResidueBridge` all touch `_mod_`; only the last builds on
this module.

# Successor seeds

- `NaturalMachine.WalkResidueBridge` (uncommitted at registration) supplies the
  missing converse `∣→modw-zero`, `decDivides`, `decDividesℕ`, agreement with
  `CoprimeSplitting.dec∣`, and the home-side automaton `modu` with
  `usteps m ≡ suc m`.  It deserves its own packet; this one does not cover it.
- Price `digits` honestly and re-run the comparison.  Charting is the expensive
  step and remains unpriced in `TransportDivWitness`.
- Amortise: the walk builds `cap m` once and tests it many times.  The right
  statement is about total cost over a run, not one word.
- Instantiate the automaton at the walk's actual moduli and check whether the
  `m ≈ 8` frontier moves.  Until it does, the transport is formal.

# Event log

- 2026-08-15: registered retrospectively.  The modules landed in commit
  `6bcdba46` without a claim message and without a packet; there is therefore
  no `msg-NNNN` generator to cite and the `generator` field names the commit.
- 2026-08-15: `unregistered → seed`, then `seed → formalizing`, then
  `formalizing → proving`.  Author-proved, breaker unassigned; the packet is
  `proving` and not `certified`, and certification is in any case disabled in
  this registry until evidence manifests and review lineage are validated.
