# Breaker audit of R0079, R0080, R0081

**Date:** 2026-08-15. **Role:** breaker (registry role `breaker`).
**Container:** Agda 2.6.3, cubical **v0.7** at `/tmp/cubical`
(`cubical.agda-lib` declares `name: cubical-0.7`).

## 0. Lineage warning — read this before quoting anything below

**I share a session lineage with the builder.** The three packets were
registered under `lineage: claude-opus-5-session_01QWDKiQtKZWPeWaUzWf2YmX-…`,
their modules were landed by the same session, and this audit runs inside the
same session as a differently-instructed agent. That is **not** an independent
audit in the sense `collab/discovery/README.md` requires
("A proof written by its builder is still `proving` until an independent
breaker records an audit"), and it is not the "distinct lineages" the
certification gate in `code/discovery_loop.py` demands
(`breaker_lineages | checker_lineages` of size ≥ 2).

I am the best audit currently available, not an independent one. **All three
packets should say so in their `Independent audit` sections**, which today say
only "Unassigned". The correct wording is: *audited by a same-lineage breaker;
an out-of-lineage audit is still owed.* Until that is written down, a reader
scanning `Independent audit` sees "Unassigned" and does not learn that a
partial audit exists; a reader scanning the event chain sees an audit and does
not learn that it is same-lineage. Both readings are wrong in opposite
directions.

## 1. What was checked mechanically, today, in this container

Every cited module typechecks **individually**, exit 0, `--cubical
--guardedness --safe --no-import-sorts`, no postulates, no holes:

`TransportDiv`, `TransportDivWitness`, `TransportDivQuot`, `TransportDivScale`,
`Residual`, `ResidualPath`, `CostGeometry`, `EndObstruction`,
`QuestionMachine`, `Lawvere`, `WalkResidueBridge`.

The **root aggregate still does not exit 0**:

```
agda NaturalMachine.agda
NaturalMachine/PathIsSymmetry.agda:98,50-58  Not in scope: SymGroup
```

All three packets state this honestly and none of them quotes the root green
claim. That part of the Evidence sections survives intact.

**No header drift found in the cited modules.** I extracted every top-level
declaration of `TransportDiv`, `TransportDivWitness`, `Residual`,
`EndObstruction`, `QuestionMachine` and compared against the packets and
against each module's own header. I also checked the four names
`ResidualPath`'s header advertises (`Γ↝-sound-any`, `Γ↝-optimal`,
`Γ↝-greatest`, `Γ↝-attained`) — all four exist as declarations, not only as
comments. The failure mode named in the brief (a header claiming three
theorems it did not have) is `WalkFastInstance`'s, and that module has since
been repaired and says so.

**Statement hashes.** I recomputed all three by the validator's own rule
(sha256 of the whitespace-normalised `Exact statement` section) without running
the banned script, and all three match their front matter and all nine existing
events. But see §2.3: an internally consistent hash over an *under-transcribed*
statement is exactly the hole the hash was supposed to close, and it does not
close it.

Three scratch Agda modules were written **outside the repository**
(`$SCRATCH/break/BreakR0079.agda`, `BreakR0080.agda`, `BreakR0081.agda`) and
all three typecheck under the same flags against the repo's include path. No
`.agda` file in the repository was modified. The scratch files are the actual
evidence for the counterexamples below; they are reproduced inline here so the
note survives the scratch directory.

---

## 2. R0079 — WEAKENED, with two component claims refuted

*The walk's divisibility test carried across the place-value chart as a Horner
residue automaton, with a kernel-computed detour.*

The registered `Exact statement` — the list of Agda facts — is **true and
checked**, every item of it, including every `refl`-closed numeral. What does
not survive is the packet's Tension, one numeral in its Preservation ledger,
and the repair `TransportDivScale` claims to supply.

### 2.1 REFUTED: the frontier attribution, by the builder's own later commit

R0079's Tension asserts that "the walk (`NaturalMachine.WalkBridge`) stalls at
frontier `m ≈ 8` **because** its divisibility test is unary, costing `Θ(cap m)`".
The Falsification section lists the matching attack:

> Attack the scope of the frontier claim: show that the walk's stall at
> `m ≈ 8` is not caused by the unary divisibility test, in which case carrying
> the test across changes nothing that matters.

**That attack lands, and it lands from the same lane, 23 minutes after the
packets were filed.** Commit `24336aea` (2026-08-15 06:09:30; packets filed at
`de511914`, 05:46:13) is titled *"The walk's frontier is broken, and my
diagnosis of it was wrong"* and says:

> next 8 = 9, next 9 = 11, next 10 = 11 now typecheck. Whole module 3.1 s,
> EXIT=0 … **cap m is never run.** … What forces the evaluation is the
> conversion checker … The route round is that a metavariable is solved by
> ASSIGNMENT and never by reduction … The log is in the header: the last two
> rows differ only in `let`, 3.5 GB against 2.2 s.

So the `m ≈ 8` frontier was an **Agda elaboration/sharing artifact**, not the
unary divisibility test; it was moved past 10 by a `let`-binding; and
`WalkFastInstance.agda` — the module that moved it — imports
`CoprimeSplitting`, `WalkBridge` and `WalkFast`, and **does not import
`TransportDiv` at all** (verified by grep over its import list).

R0079's Successor seeds say: *"Instantiate the automaton at the walk's actual
moduli and check whether the `m ≈ 8` frontier moves. Until it does, the
transport is formal."* The frontier moved **without** the automaton. The
transport is therefore not "formal pending an instance"; its stated motivation
is retracted, and the packet was never updated to say so.

This does not touch the mathematics of `TransportDiv`. It removes the reason
the packet gives for caring about it.

### 2.2 REFUTED: an unchecked numeral in the Preservation ledger

The ledger asserts, with no proof term behind it:

> the statement `detour < home` at base ten and the word `1000` survives any
> charting price below 497.

It does not. With `unchart` held at its stipulated 3 and `wThere = steps
thousand = 5`, `detour = 2c + 3 + 5`, so a speedup needs `2c + 8 < 1000`, i.e.
`c ≤ 495`. At `c = 496` — which is "below 497" — the detour is **exactly 1000**
and the branch is `↻`, not `↝`. Kernel-checked:

```agda
price-496-is-not-a-speedup : detour (chartE 496) (unchartE 3) (steps e3) ≡ 1000
price-496-is-not-a-speedup = refl

branch-at-496 : respond (just (bridgeE 496 3)) (value e3) (steps e3) ≡ ↻
branch-at-496 = refl

branch-at-495 : respond (just (bridgeE 495 3)) (value e3) (steps e3) ≡ ↝
branch-at-495 = refl
```

An off-by-one in a hand-computed bound, inside a packet whose entire boast is
that *"every numeral is computed by the kernel and none is asserted"*. The
boast is true of the `Exact statement` and false of the ledger, and the ledger
is where a reader looks for the scope of the claim. This is the CLAUDE.md
failure mode (`exp27`) in miniature: the numbers that got checked were checked;
the number that framed them was not.

### 2.3 The `Exact statement` is a strict under-transcription of the module

`TransportDiv.agda` has ten top-level declarations. The packet's `Exact
statement` transcribes six. The four it omits are

```
run, run-state, run-count, run-is-the-automaton
```

— §5 of the module, which landed in commit `5ccb0394` ("Answer the audit: the
step count is now the automaton's own recursion") at 05:43:06, **three minutes
before the packet was filed at 05:46:13**. The module's own §5 header says why
§5 exists:

> An audit of this file observed that §4 as first written was a definitional
> identity about a function connected to `modw` by nothing at all: `steps`
> counted its own clauses, and no theorem said those clauses were the
> automaton's. That objection is correct and this section answers it.

The packet registers **§4 and not §5** — that is, it registers the cost claim
in exactly the form a prior audit called hollow, and omits the repair, while
the Preservation ledger continues to present `steps-is-length` as "the step
count as an exact identity". The statement hash is internally consistent, and
that is the point: **a hash over an under-transcription is consistent with
itself and tells you nothing.** The registry's stated purpose ("a packet that
hashes a statement subtly different from the checked one is the failure mode
the registry exists to prevent") is defeated here not by a wrong transcription
but by a short one.

Repair: extend the `Exact statement` with §5, rehash, and record the extension
as a new event. Nothing needs to be retracted.

### 2.4 The `TransportDivScale` repair is not weight-independent

`TransportDivScale` is offered as the answer to "the weights are stipulated":
(S2) `canonical-speedup` quantifies over `c c' : ℕ` and gives a speedup for
every canonical word with `4 + ((c + c) + c') ≤ length w`. That reads as
weight-independence. It is not, for a structural reason:

**`Edge.cost : Cost` is a scalar.** There is no way in `CostGeometry` for an
edge's cost to depend on the argument it moves. So quantifying over `c c'`
quantifies over **constant** weights only — and the one map the packet is
actually about, `digits`, is not constant-cost: R0079's own ledger concedes
"`digits m` iterates the odometer `m` times, so charting a unary `m` costs
`Θ(m)`". The quantifier ranges over exactly the assignments that exclude the
honest one.

Worse, the threshold `4 + ((c + c) + c') ≤ length w` is **a lower bound on the
word by the weights**. Any weight that grows with the word makes the hypothesis
unsatisfiable, so (S2) is not merely inapplicable, it is *vacuous*. Priced at
`c := value (d ∷ w)` — a generous lower bound on `digits`'s cost, since the
odometer is iterated that many times — the conclusion **reverses**, at every
length, in every base, above and below the threshold alike. Kernel-checked:

```agda
dear-out-no-speedup :
    {A B : Presentation} (out : Edge A B) (back : Edge B A)
    (wHere wThere : Work) → wHere ≤ cost out → NoSpeedup out back wHere wThere

honest-chart-never-pays :
    (c' : ℕ) (d : Digit) (w : Word)
  → NoSpeedup (chartE (value (d ∷ w))) (unchartE c')
              (value (d ∷ w)) (steps (d ∷ w))

honest-branch-is-flat :
    (c' : ℕ) (d : Digit) (w : Word)
  → respond (just (bridgeE (value (d ∷ w)) c'))
            (value (d ∷ w)) (steps (d ∷ w)) ≡ ↻

honest-threshold-unsatisfiable :
    (c' : ℕ) (d : Digit) (w : Word) → Canonical (d ∷ w)
  → ¬ (4 + ((value (d ∷ w) + value (d ∷ w)) + c') ≤ length w)

repriced-thousand : respond (just (bridgeE 1000 3)) (value e3) (steps e3) ≡ ↻
```

`repriced-thousand` is the witness's own point, repriced: the same word, the
same automaton, the outbound edge charged what its map costs, and the branch
flips from `↝` to `↻`.

So the answer to the brief's question is: **the quantified version pushes the
stipulation into the threshold, exactly as suspected.** What (S2) proves is a
true and non-trivial statement about *constant-weight* edges. What it is
offered as — "the chart wins for every long enough word" — requires a cost
model `CostGeometry` cannot express.

The honest repair is not a bigger quantifier but a wider `Edge`: `cost :
Carrier A → Cost`. Note that this would also cost `CostGeometry` its two
theorems as stated, so it is a real change and not a rewording.

### 2.5 Two smaller things

- The home work `1000` is a **stipulation** and is not listed under
  "Introduced" in the Preservation ledger, which lists only the two edge
  weights. `notes/COST_GEOMETRY.md` §Rigor boundary does list it; the packet
  does not. Moreover the lane's own `WalkResidueBridge.gap-1000` computes the
  home automaton's step count on this word as **1001**, not 1000 (`usteps m ≡
  suc m`, the +1 being the initial state). So the numeral that frames the
  headline comparison is neither derived nor, on the lane's own later reckoning,
  the right one.
- `unaryP = pres ℕ _+_` and `chartP = pres Word (λ u v → u)`: neither
  presentation's `op` is a divisibility test, and `op` is not read by `detour`,
  `Speedup` or `NoSpeedup` anywhere. The `Presentation` packaging is inert
  decoration in this witness. Harmless, but it is why the reader believes the
  `Work` numbers are about divisibility when only `steps` is.

### 2.6 What survives R0079

- `modw`, `scale-mod`, `value-modw`, `modw-zero→∣`, `steps`, `steps-is-length`,
  and (unregistered) `run`, `run-state`, `run-count`, `run-is-the-automaton`:
  all checked, all correct, and correctly graded `novelty: known` (Sutner 2010,
  Alexeev 2004, `Nat.ofDigits`, `Data.Digit.fromDigits`, and in-repo
  `RadixSymptoma`).
- The witness numerals, **as statements about the stipulated weights 3 and 3**.
- The positivity side condition on the modulus, correctly stated.
- The honest recording of the toolchain skew and the red root aggregate.

**Verdict: WEAKENED.** Survives as: *a checked, classical residue automaton,
plus a cost comparison that holds for constant-weight edges and reverses under
the only weight assignment the packet's own ledger says is honest.* The
frontier attribution (§2.1) and the "below 497" bound (§2.2) are refuted
outright.

---

## 3. R0080 — WEAKENED: the name over-claims, and the general statement is true

*The residual of a checked bridge is not seen by an equivalence-invariant
response, and the fifth response is min-plus over neighbours.*

The `Exact statement` matches `Residual.agda` **symbol for symbol**; I checked
all 23 top-level declarations and every type. The hash is consistent.
`no-invariant-response-sees-ϱ : ¬ Invariant respondB` is correct and its
four-line proof is correct.

### 3.1 The name, attacked as the brief asks

`no-invariant-response-sees-ϱ` proves `¬ Invariant respondB` — that **one**
response fails invariance. The packet's ledger licenses the general reading
this way:

> The reading "no equivalence-invariant response can see `ϱ`" is licensed only
> because the branch is by definition a function of `ϱ`, so any response
> agreeing with `respondB` is `respondB`. A breaker should test whether that
> step is as tight as it sounds.

Tested. **The step is a tautology, not an argument** — "any response equal to
`respondB` is `respondB`" is true of any term whatever and licenses nothing.
And the general statement it is standing in for is **false on its obvious
formalisation**: "sees `ϱ`" cannot mean "is a function of `ϱ`", because
constant responses are functions of `ϱ` and are invariant. Kernel-checked:

```agda
constΓ : {A B : Presentation} → Bridge A B → Work → Work → Branch
constΓ _ _ _ = ↻

const-invariant : Invariant constΓ
const-invariant _ _ _ _ _ _ _ _ = refl
```

(A useful by-product: `Invariant` is **inhabited**, so the module's theorem is
not vacuous. That was worth checking and the packet does not check it.)

### 3.2 The general statement, correctly stated, is true — and unproved in the module

The right notion of "sees" is *nonconstant in `ϱ`*, and then the general
theorem holds and is two lines longer than the special case. Kernel-checked:

```agda
read : (ℕ → Branch) → {A B : Presentation} → Bridge A B → Work → Work → Branch
read g b wh wt = g (ϱ b wh wt)

invariant-read-is-constant :
    (g : ℕ → Branch) → Invariant (read g) → (m n : ℕ) → g m ≡ g n
```

Proof (as checked): apply invariance at `A = B = pres Unit _`, both maps the
identity, `wHere = m + n`, `wThere = 0`, outbound weights `0` and `0`, inbound
weights `n` and `m`. The two detours are `n` and `m`, so the two residuals are
`(m + n) ⊖ n = m` and `(m + n) ⊖ m = n`, and invariance forces `g m ≡ g n`.
Since `m, n` are arbitrary, an invariant response that reads `ϱ` is constant.

The module's theorem is the instance `g = branchOf`, which is nonconstant:

```agda
recover : ¬ Invariant respondB
recover inv = branchOf-nonconstant (invariant-read-is-constant branchOf inv 0 1)
```

So: **the intended general statement is true, is stronger, and is not in the
module.** The name is defensible *after* this two-line generalisation and not
before. Until it is added, the name asserts a universal quantifier the file
does not carry, and `notes/COST_GEOMETRY.md:85` ("no response that reads only
the `move` fields can land in the right branch") propagates the universal
reading into prose on the strength of the special case.

Repair, in order of preference: (i) add `invariant-read-is-constant` and derive
the existing theorem from it, keeping the name; (ii) keep the module as is and
rename to `respondB-is-not-invariant`. (i) is four lines.

### 3.3 Attacks that did NOT land

- **`Γ↝-sound` as an oracle.** The Falsification section warns that a
  downstream module consuming only `Γ↝-sound`'s type consumes an oracle. No
  such consumer exists: the only downstream user, `MachineLoop.agda`, imports
  `ResidualPath.Γ↝-sound-member` / `Γ↝-optimal` / `Γ↝-greatest` — the indexed
  versions — and never `Residual.Γ↝-sound`. `ResidualPath` has landed since the
  packet called it "in-flight", and all four names its header advertises exist.
  The packet is more pessimistic about itself than the corpus warrants.
- **`↻` includes ties.** `NoSpeedup` is `wHere ≤ detour`, so `↻` covers exact
  ties. I found no downstream reading of `↻` as strict flatness.
- **Vacuity of `Invariant`.** Refuted; see §3.1.
- **Min-plus prior art.** Already conceded in the packet, correctly and in
  unusually plain language.

### 3.4 One thing neither the builder nor the earlier audits caught

`formal/cubical/NaturalMachine/README.md:290` lists `Residual` with status
**`load-bearing`**, and line 291 lists `ResidualPath` the same way. R0080
declares `load_bearing: false` and says it "must stay `false` until
certification"; `code/discovery_loop.py` refuses any packet that declares
itself load-bearing while uncertified. **The corpus index and the registry
disagree about the status of the same module.** The index is the document a
reader consults; the packet is the document the registry enforces. One of them
must change, and the registry is the authority.

**Verdict: WEAKENED.** Survives as: *`respondB` is not `Invariant`, with an
explicit two-weight countermodel; and the intended universal statement is true
but is not proved by the cited module.* Everything else in the `Exact
statement` stands as written.

---

## 4. R0081 — WEAKENED: it is two theorems wearing one name, and the corpus index states it backwards

*Every quotation leaves a diagonal observable outside its image, so a
contracting machine closes every question and is still not finished.*

The `Exact statement` matches `EndObstruction.agda` and `QuestionMachine.agda`
symbol for symbol; all 12 declarations checked; hash consistent. `δ-end`,
`no-complete-quotation`, `next-door`, `halts`, `never-final` are all correct.

### 4.1 It is a conjunction, and formally weaker than its conjuncts

The packet concedes this in the ledger. The concession is right, and it can be
made sharper than "the proof term is a pair". Kernel-checked:

```agda
is-literally-the-pair :
    {𝒬 : Type₀} (M : Machine 𝒬) (⌜_⌝ : Quote 𝒬) (c : Contracting M) (q : 𝒬)
  → halting-does-not-close M ⌜_⌝ c q ≡ (halts M c q , never-final ⌜_⌝)
is-literally-the-pair M ⌜_⌝ c q = refl

second-ignores-the-machine :
    {𝒬 : Type₀} (M M' : Machine 𝒬) (⌜_⌝ : Quote 𝒬)
    (c : Contracting M) (c' : Contracting M') (q q' : 𝒬)
  → snd (halting-does-not-close M  ⌜_⌝ c  q )
  ≡ snd (halting-does-not-close M' ⌜_⌝ c' q')
second-ignores-the-machine M M' ⌜_⌝ c c' q q' = refl

first-ignores-the-quotation :
    {𝒬 : Type₀} (M : Machine 𝒬) (⌜_⌝ ⌜_⌝' : Quote 𝒬)
    (c : Contracting M) (q : 𝒬)
  → fst (halting-does-not-close M ⌜_⌝  c q)
  ≡ fst (halting-does-not-close M ⌜_⌝' c q)
first-ignores-the-quotation M ⌜_⌝ ⌜_⌝' c q = refl
```

Two different machines with two different contraction proofs at two different
questions give the *same* second component, by `refl`; two different quotations
give the same first, by `refl`. There is no channel in either direction.

Note also that the composite is **strictly weaker than the conjunction of its
parts**: it demands `Contracting M` and a `q : 𝒬` in order to deliver a second
component that needs neither. As a proposition it is `A × B` with two unused
hypotheses attached to `B`.

**Answer to the brief: it is a conjunction of two theorems wearing one name.**

### 4.2 Sharper than the packet's concession: nothing ties `⌜−⌝` to the machine

`record Machine (𝒬 : Type₀)` has exactly two fields, `∂ : 𝒬 → ℕ` and `𝔉 : 𝒬 →
𝒬`. **There is no quotation field.** So the name's reading — *the machine
cannot describe its own end* — is not licensed by the type at all: `⌜_⌝` is an
arbitrary function `𝒬 → (𝒬 → Bool)` with no stated relation to `M`. The only
thing joining the two halves is the type variable `𝒬`. Kernel-checked with an
alien quotation:

```agda
triv : Machine Unit
triv = machine (λ _ → 0) (λ x → x)

alien : Quote Unit
alien _ _ = true

unrelated-instance :
    Resolves triv tt × (Σ[ d ∈ Observable Unit ] ((r : Unit) → ¬ (alien r ≡ d)))
unrelated-instance = halting-does-not-close triv alien triv-contracting tt

resolves-immediately : fst unrelated-instance .fst ≡ 0
resolves-immediately = refl
```

A machine that does nothing (`∂ ≡ 0`, `𝔉 = id`) "closes every question" in zero
steps, and a quotation that names one constant observable is "not final", and
the conjunction holds. The theorem is as true of a machine that does nothing as
of one that does something — which is the precise sense in which it is a
clarification and not a result. The packet says this; the packet's *title* does
not.

### 4.3 What neither the builder nor the earlier audits caught

R0081's `Independent audit` section names exactly the right job and nobody did
it:

> check every note, paper section and message that cites `δ-end`,
> `never-final` or `halting-does-not-close` and confirm that none of them
> upgrades a statement about quotations into a statement about computation, and
> that none of them presents the pair `halting-does-not-close` as a proof that
> the two facts interact.

I ran it. There are two citations outside the packets, and **one of them states
the theorem backwards**:

`formal/cubical/NaturalMachine/README.md:298`

> | `QuestionMachine` | `halts`, `never-final`, and their conjunction
> `halting-does-not-close`: **completeness does not imply termination of the
> question flow.** | load-bearing |

The implication is **reversed**. What is proved is that *termination does not
imply completeness*: `halts` gives termination under `Contracting`, and
`never-final` denies completeness of the quotation. `QuestionMachine.agda`'s
own header says `पूर्णता ⇏ समाप्ति` and the packet's title says "closes every
question **and is still not finished**". The corpus index says the converse,
which is not proved anywhere in the lane and is not what any of these terms
inhabit.

The same row also marks `QuestionMachine` **load-bearing**, and line 297 marks
`EndObstruction` load-bearing, against `load_bearing: false` in R0081 and
against the registry's rule that uncertified packets may not be load-bearing.
Same contradiction as §3.4, in the same table.

### 4.4 Prior art: verified, and the packet is right to concede

`formal/cubical/LawvereDiagonal.agda` carries `WkPtSurj`, `lawvere`, `cantor`,
`cantorDefect` for arbitrary `Y` and arbitrary fixed-point-free `ν` — strictly
more general. `formal/cubical/NaturalMachine/Lawvere.agda` (commit `630ffc19`)
carries `δ-end`, `no-complete-quotation`, `δ-end-same-statement`,
`quotation-same-statement`, `derivations-agree`, `next-door-same-statement`,
`door-agrees` — i.e. it already proves the two derivations coincide. Both
verified present and typechecking. `EndObstruction.agda` is a duplicate under a
private name, exactly as registered.

**Verdict: WEAKENED.** Survives as: *two independent theorems — `halts`
(descent on an ℕ-measure, superseded by `KFlowWF`) and `never-final` (the
`Bool`/`not` instance of Lawvere, superseded by `LawvereDiagonal` and
`Lawvere`) — whose conjunction carries no interaction and no statement about
any machine's self-description.* The registered mathematics is intact; the name
and the corpus index are not.

---

## 5. Where the registry could not record what I found

Both of these are findings about the registry, not about the packets.

### 5.1 `refuted` is disabled, so a breaker cannot record a refutation

`code/discovery_loop.py` sets `CERTIFICATION_ENABLED = False`, and

```python
if args.to in {"certified", "refuted", "known"} and not CERTIFICATION_ENABLED:
    print(f"Transition to {args.to} is disabled …")
```

From `proving`, the legal targets are `{breaking, refuted, known, blocked,
inconclusive, quarantined}`, of which `refuted` and `known` are disabled in
code. **A breaker's only recordable verdict is `breaking`** — "an audit is
under way" — which is a *status*, not a verdict. There is no vocabulary at all
for WEAKENED, which is the verdict all three packets earned. I have therefore
recorded `proving → breaking` on each and put the verdict in the event's
`reason` field and in this note. The two refuted component claims of R0079
(§2.1, §2.2) are **not** recordable as refutations anywhere in the registry;
they live here.

Recommendation: the state machine needs either a `weakened` status or a
`verdict` field on events. A loop whose breaker can only say "I am looking"
cannot distinguish a packet that survived from one that has not been read.

### 5.2 A breaker who does not own the claim file cannot leave the registry valid

`validate()` requires

- `packet.meta["status"]` to equal the **last event's `to`**, and
- `packet.meta["cycle"]` to equal the **number of events**.

Appending an event is therefore *never* a self-contained act: it invalidates
the packet until someone with write access to
`collab/discovery/claims/RNNNN-*.md` updates `status`, `cycle`, `breaker` and
`updated`. I own the event directories and this note, and not the claim files.
So after these three events the three packets will each report two validation
errors until an owner applies:

```
R0079, R0080, R0081:  status: breaking   cycle: 4   updated: 2026-08-15
                      breaker: claude-opus-5-breaker-R0079-R0081   (same lineage)
```

That is a transitional inconsistency I am creating deliberately and flagging
rather than hiding. The alternative — recording nothing — is worse.

Two smaller registry observations:

- **Event filenames diverge from the tool.** `command_transition` writes
  `{stamp}-{role}.json`; the nine existing events are named
  `{stamp}-{destination}.json` (`…-seeded.json`, `…-formalizing.json`,
  `…-proving.json`). I followed the existing chain, not the tool, since the
  chain is what a reader sees. Somebody should decide which is the convention.
- **The `cycle` budget is spent on registration.** All three packets arrived at
  `cycle: 3` with `max_cycles: 6` before any mathematics was audited, because
  `unregistered → seed → formalizing → proving` was recorded as three separate
  events on the same day by the same actor. Half the budget for a packet's
  entire life is consumed by filing it. A breaking/proving round trip costs two
  more, leaving one.

---

## 6. Summary table

| Packet | Verdict | Refuted components | Survives as |
|---|---|---|---|
| R0079 | **WEAKENED** | frontier attribution (§2.1); "below 497" (§2.2) | a checked classical residue automaton; a cost comparison valid for constant-weight edges only, reversing under honest pricing of `digits` (§2.4) |
| R0080 | **WEAKENED** | none | `¬ Invariant respondB` with its countermodel; the universal statement the name asserts is true (§3.2) but is not in the module |
| R0081 | **WEAKENED** | none | two independent theorems, both prior art in-repo; the conjunction carries no interaction and says nothing about any machine's self-description |

Attacks run and survived: statement-hash recomputation (all three consistent);
symbol-for-symbol comparison of every declaration (R0080, R0081 exact; R0079
short by four); individual typechecks of all eleven cited and adjacent modules;
root-aggregate check (still red, honestly reported); header-vs-content check on
`ResidualPath`; downstream-consumer check on `Γ↝-sound` (attack did not land);
prose-citation sweep (found the reversed gloss, §4.3); prior-art spot-check
against `LawvereDiagonal` and `Lawvere` (confirmed).

**And once more: I share a session lineage with the builder. An out-of-lineage
audit of all three packets is still owed, and the packets should say so.**
