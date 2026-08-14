# Breaker audit: the three generative modules (Obstruction, GenerativeLoop, AcceptanceTest)

**Auditor role**: hostile breaker, per collab tradition. Date: 2026-08-13.
Discipline: checked Cubical Agda only. No Python, no numerics.
Toolchain: Agda 2.6.3 + cubical v0.5, per `formal/cubical/BUILD.md`.

**Scope**: the three modules landed today and explicitly excluded from
`notes/NATURALMACHINE_CLAIM_AUDIT.md`'s 19-module sweep:

- `formal/cubical/NaturalMachine/Obstruction.agda`
- `formal/cubical/NaturalMachine/GenerativeLoop.agda`
- `formal/cubical/NaturalMachine/AcceptanceTest.agda`

announced in `collab/messages/0370-cf-tessera-generative-loop-checked.md`,
whose §2 self-disclaimer (items 1–11) was read first and is treated as the
floor: every item there is confirmed or refuted below, and the audit goes
past it. Method is the prior audit's: extract every comment-level claim,
check it against what the type-checker certified, classify with file:line
evidence.

**Verdict key** (unchanged from the prior audit)
- **PROVED** — the prose names a checked theorem whose statement matches the prose.
- **DEFINED-ONLY** — the prose describes definitions/data; no theorem certifies it.
- **OVERSTATED** — the checked content is strictly weaker than the prose.
- **VACUOUS** — `refl`/`cong` on definitionally-determined things, presented as content;
  or a theorem whose hypothesis nothing in the corpus supplies.

**Totals: 46 claims audited — 22 PROVED, 6 DEFINED-ONLY, 15 OVERSTATED, 3 VACUOUS.**

No mathematical error was found. Every theorem in the three modules is
correctly proved; the entire finding list is about what the surrounding
prose says those theorems mean. Line numbers below are **post-fix** (this
audit edited all three modules; see §5).

All checks green after the fixes: `Obstruction` 0, `GenerativeLoop` 0,
`AcceptanceTest` 0, `WitnessPolicy` 0 (dependent), aggregate
`NaturalMachine.agda` 0.

---

## 1. `Obstruction.agda` — 17 claims

| # | Claim (location) | Status | Evidence |
|---|---|---|---|
| O1 | "states and CHECKS both halves in the smallest substrate that carries them honestly" (:18) | OVERSTATED | A superlative with no referent; and false for the frequency half — see O12/O13, where the substrate is small enough that the theorem becomes automatic. *Corrected in place.* |
| O2 | The `Obstruction` record is "the residual of a failed match", `arg` "the base subterm below the failure frontier", `argBase` "the failure is exactly at the root" (:32-38, :311-321) | DEFINED-ONLY | A record declaration. Nothing proves failed matches decompose this way — there is no matcher that *returns* an `Obstruction`. Further: `argBase` is **consumed by no theorem in these modules** (grep: it occurs at its declaration :315 and at record literals `Obstruction.agda:584`, `GenerativeLoop.agda:429, 607` — never eliminated). Msg 0370's "without `argBase` the loop's probe cannot be built" is half right: it constrains how obstructions may be *built* (the probe must run innermost-first to supply it), but no proof in either module consumes it. |
| O3 | `propose` "gets D1 for free because it only ever names what just failed" (:39-43, :346-349) | PROVED | By typing: `Extension.fresh : memb name V ≡ false` (:337) is discharged with `failed o`. The claim is certified by `propose` type-checking. |
| O4 | T1 `defining-equation` "the new head unfolds by its body" (:283) | PROVED | `if≡true (eqℕ-refl d)` — `cong` on the scrutinee, not `refl`. Thin but real. |
| O5 | T2 `unfold-elim`/`propose-eliminable`: "the extension is definitional, **hence conservative**" (orig header T2; now :48-60) | OVERSTATED | What is proved (:290) is: `Over V b → Over (d ∷ V) t → Over V (unfold d b t)` — eliminability at the level of *coverage*. No provability relation exists anywhere in the three modules, so "conservative" is borrowed collateral in exactly the sense the prior audit's G1 uses for the Smith nouns. Confirms msg 0370 pt 8. The statement with conservativity content is P3 of `notes/OBSTRUCTION_AGDA_PLAN.md` and is unproved. *Header corrected.* |
| O6 | T3 `match-conservative` is "the D3 content" (orig header T3; now :61-66) | OVERSTATED | :265 is `cong (_≡ true) (memb-skip …)`: a membership skip lemma. Gate D3 refuses old-language left-hand sides (`x*y := x+y`); that refusal is P3, and nothing here touches it. *Header corrected.* |
| O7 | T4 `match-mono`/`Over-mono` "extension loses nothing" (:253, :257) | PROVED | Real inductions. |
| O8 | T5 `progress-before`/`progress-after`/`strictly-extends` (:382-388) | PROVED | Statement matches prose exactly. |
| O9 | T6 `obstruction-eliminated` "proposing consumes the obstruction" (:394) | PROVED | Genuine, if one line: a same-residual obstruction at `extend V o` would contradict `memb-here`. |
| O10 | `propose-installs` "definitionally" (:356) | VACUOUS | `refl`. Honestly labelled; no action. |
| O11 | `proposal-determined` "the proposal is determined by the residual" (:365) | VACUOUS | `cong (λ s → Matches (s ∷ V)) p`. Holds of *any* `Vocab`-indexed construction applied to `residual o`; it records that `extend` ignores the record's other four fields and says nothing about the proposer. *Comment corrected, :360-364.* |
| O12 | T7 `plateau`: "THE PLATEAU THEOREM … a path of functions, by funExt … naming re-describes the matchable set, it does not enlarge it" (header :75-82; :418, :444) | OVERSTATED | See §4 gap **A**, the worst finding. As a theorem about `FreqChain` it is correct and its proof is real work (`memb-absorb` + `funExt`). As a model of §7 it is degenerate: the step constructor (:438-441) can only name a head **already installed**, so the vocabulary provably never changes at all. *Closed by landing T7′ and T10.* |
| O13 | T8 `frequency-cannot-reach` "is §7's sentence as a single checked statement" (orig header T8; :499) | OVERSTATED | Same root cause. §7's frequency proposer *installed twelve heads that were not there*; the modelled one installs nothing (`freq-memb-absorbed` :476). *Closed by `class-cannot-reach` :544, which is §7's argument with genuine growth allowed.* |
| O14 | T9 `obs-complete` — "**completeness**: every term is fully covered" (orig header T9; now :96-99) | OVERSTATED (wording) | The theorem (:573) is coverage of a term by a vocabulary. "Completeness" names a property of deductive systems; there is none here. *Header corrected.* |
| O15 | "the chain constructed here uses the degenerate witness `var`; a witness policy is a refinement, not a prerequisite" (:565-566) | PROVED | Accurate self-disclosure. |
| O16 | "all checked, none postulated — `--safe`" (:45) | PROVED | grep: no `postulate`, no holes; `--safe` on :1. |
| O17 | §7 preamble: "The frequency-based proposer draws its candidate from the history of SUCCESSFUL matches: it can only ever name the head of a term the matcher already fired on" (:404-410) | DEFINED-ONLY | This describes the datatype `FreqChain` (:438), asserting it as a property of frequency proposers. Confirms and sharpens msg 0370 pt 9. *Pointer to T7′ added, :412-416.* |

## 2. `GenerativeLoop.agda` — 17 claims

| # | Claim (location) | Status | Evidence |
|---|---|---|---|
| G1 | "the exact converse of `Obstruction.frequency-cannot-reach`/`plateau`" (:7-8) | OVERSTATED | Inherits O12: the thing it is the converse of is a statement about an inert proposer. Also inexact in the technical sense of G3. |
| G2 | A1 `obs-step-strict` (:224) | PROVED | Real. |
| G3 | A2 `anti-plateau`: "no obstruction chain **THROUGH at least one step** leaves it equal" (orig header A2) | OVERSTATED | :235 names the chain's **first** obstruction and types the rest from `extend V o`. But `ObsChain` grows at the *right*: a nonempty `ObsChain V X` is `step ch o` with `o` at the chain's **end** (`Obstruction.agda:563`). The quoted generality needs the last-step form, which was absent. *Closed: `anti-plateau-step` :249; header split into A2/A2′ at :36-45.* |
| G4 | A3 `obstruction-reaches` (:230) | PROVED | Real. |
| G5 | A4 `obstruction-beats-frequency` "§7's sentence, both halves, one term" (header :46-50; :259) | OVERSTATED | The "no frequency chain reaches it" half is O13. The "some obstruction chain does" half is a single step. |
| G6 | B0 "the measure is faithful … without this pair the measure would be decoration" (header :62-66) | PROVED | `Over→deficit0` :290, `deficit0→Over` :295. Model prose: the module states the obligation that keeps a measure honest and discharges it. |
| G7 | B1 `deficit-split` "installing s removes exactly the s-labelled gaps and nothing else" (header :67-68) | PROVED | :365, via a genuine `delta-split` case analysis :331. |
| G8 | B2 `generative-step` "reads off the innermost uncovered head TOGETHER WITH a proof that the measure drops" (header :69-77) | PROVED | :437; the decrease is in the type. |
| G9 | B3 `loop` fuelled iteration (header :78-80) | PROVED | :475. |
| G10 | B4 `generative-loop` "TERMINATION, unconditional … the loop does not stall" (header :81-85) | PROVED | :497, bound `chainLen ch ≤ deficit V t`. |
| G11 | "B4 strengthens `obs-complete`" (header :87-89) | PROVED | `generative-loop-complete` :504 has `obs-complete`'s exact type, obtained from the bounded version. |
| G12 | C1 "so the extended vocabulary **proves nothing new** about base terms … (`propose-eliminable`, at the loop's step)" (orig comment above :551) | OVERSTATED | Two errors in one comment. (i) "proves nothing new" is O5's borrowed noun. (ii) "at the loop's step" — the definition is `generated-definition-conservative = propose-eliminable` (:551): a renaming whose type mentions nothing about the loop. *Comment corrected, :541-547.* |
| G13 | C2 "one obstruction-indexed step is what **flips** the compiler's branch" (header :98-115; :566) | OVERSTATED | With `compile` stipulated (:529, a single `if memb checkpoint V`), the flip is `if≡false`/`if≡true` applied to the obstruction's `failed` field (:532-538, :551-556). This answers msg 0370 §4's first invited attack: `generated-step-improves` is not an elaborate `refl`, but the flip component of it is `cong`, and the term's content is entirely `betterProgram` + `progress-before`/`after` + C1. *Header downgraded to say exactly that.* |
| G14 | C2's hypothesis `residual o ≡ checkpoint` (:567) | VACUOUS (hypothesis never discharged) | Confirms msg 0370's own flag. Nothing in the corpus produced an obstruction whose residual is the checkpoint, so the flagship composition theorem had no supplied subject. *Closed: `checkpoint-obstruction` :605, `checkpoint-decreases` :616, `compile-improves` :624.* |
| G15 | The "WHAT IS DELIBERATELY NOT CLAIMED" list, items 1–7 (:126-…) | PROVED (one item stale) | The best disclaimer in the corpus, and every item is accurate — except the witness-policy item, which said "that is the next theorem in this line, not one proved here" while `NaturalMachine/WitnessPolicy.agda` had already landed it. *Corrected.* |
| G16 | "Substrate: exactly `NaturalMachine.Obstruction`'s … Nothing new is axiomatised" (:23-25) | PROVED | Imports are Obstruction + AcceptanceTest + cubical stdlib; no postulates. |
| G17 | Disclaimer: "`deficit` does not decrease on obstructions whose residual does not occur in the target — it is unchanged" (NOT-CLAIMED list) | DEFINED-ONLY → now PROVED | The disclaimer asserted an arithmetic lemma nothing checked. It is one line from `deficit-split`. *Closed: `no-gaps→no-decrease` :396.* |

## 3. `AcceptanceTest.agda` — 12 claims

| # | Claim (location) | Status | Evidence |
|---|---|---|---|
| A1 | "adding ONE theorem makes a task **compile** to a strictly better program … This module lands one complete instance" (:6-8) | OVERSTATED | The module contains no compiler, no task object, and no notion of compilation: `compile` lives in `GenerativeLoop.Compile` (`GenerativeLoop.agda:529`) and is stipulated there. What is landed is two plans, proved equal in output and unequal in declared cost. *Bounded by the new NOT-CLAIMED section.* |
| A2 | "Programs are DATA, not meta-level observations" (:13-16) | PROVED | `Plan` is a two-constructor datatype :111; `cost`/`exec` are functions on it (:116, :121). |
| A3 | "`cost` reads off the number of carry-machine ticks a plan schedules" (:14-15) | DEFINED-ONLY | No theorem linked `cost` to `exec`; the agreement was by eye. *Now pinned by `exec-runs-cost` :183 — which is `refl`, hence definitional only, and labelled as such.* |
| A4 | "Without T the resumed plan is a program whose *correctness is unprovable* … **delete T and `replay` has no proof, hence no `betterProgram`**" (orig header, now replaced at :29-42) | OVERSTATED — **and false** | Two defects. (i) Unprovability-after-deletion is not an Agda judgement (msg 0370 pt 11 concedes this). (ii) The claim is *false*: `digitsC-resume` is three lines of renaming over `CountedComposition.run-+` (`CountedComposition.agda:40-42, 71-75`), and `replay` is re-derivable from `run-+` + `run-is-digitsC` without it. **Refutation landed**: `replay-without-T` :145. See §4 gap **B**. *Header replaced by an explicit CORRECTION paragraph.* |
| A5 | "for variable m, `run` computes on the count and m + n does not reduce past m's variable spine" (:24-27) | DEFINED-ONLY | A true statement about reduction behaviour, not a checked one. Retained, reworded to stand alone. |
| A6 | "nothing else in the corpus relates an execution started at an arbitrary checkpoint to one started at zero" (orig header) | OVERSTATED | `CountedComposition.run-+` is exactly that relation, in a strictly more general form; `digitsC-resume` instantiates it. *Removed.* |
| A7 | `replay` (:132) | PROVED | Real; the composite is well-typed and non-definitional. |
| A8 | `replay-observed` "the shared answer decodes to m + n" (:137) | PROVED | `= observe-resume`. |
| A9 | "STRICTLY BETTER … the witness is closed-form — the gap is exactly the checkpointed prefix" (:150-156) | PROVED | `resume-cheaper` :156; and "the gap is exactly the prefix" is now the checked identity `cost-accounting` :187. |
| A10 | `betterProgram` "on the whole nonempty range … nothing is measured" (:46-52) | PROVED | :199. Sharpness of the `suc n` restriction now checked too: `no-improvement-at-empty-checkpoint` :190. |
| A11 | "Task. Produce the canonical base-(2+k) digit word of m + n, given that the checkpoint word `digitsC n` has already been computed" (:10-12) | DEFINED-ONLY | The task is prose. There is no `Task` type, no specification a plan is proved to *satisfy*, and no claim that `restart`/`resume` are the only or best plans. The nearest checked thing is A8. |
| A12 | The module had **no** "WHAT IS DELIBERATELY NOT CLAIMED" section, unlike its two siblings | OVERSTATED (by omission) | Confirms msg 0370 pt 11. The absence is itself a finding: A1/A3/A4 stood unbounded. *Section added, :57-85.* |

---

## 4. Ranked gaps, each with the theorem that closes it

### A. **WORST.** `plateau`/`frequency-cannot-reach` do not model §7; the modelled frequency proposer provably cannot install anything

Not circular *as a derivation* — `extend-absorbed` (:418) needs `memb-absorb`
and `funExt`, and `plateau` (:444) iterates it; that is real, if small, work.
Circular *as a model*. `FreqChain`'s step (:438-441) takes `(t , m : Matches W t)`
and installs `headShape W t m`, which by `headShape-built` (:431) is already in `W`;
and every installed head arises this way, from `node s var`. So the class of
proposals the datatype can express is **exactly the already-installed heads**,
and no `FreqChain` step can change any membership test.

§7's ceiling is a different statement. There the proposer *did* install twelve
new constructors; the closure was over a **shape class** ("every proposal is a
binary product"), and the point was that B3's 3-ary grouping lies outside that
class. The Agda model replaced closure-under-a-class by closure-under-the-
installed-set, which makes the conclusion automatic and unavailable as evidence
about frequency proposers. The `funExt` headline — "leaves the matcher EQUAL,
not equivalent, EQUAL" — is a *symptom* of the collapse, not extra strength: a
faithful model cannot have a path of matchers, because a class proposer really
does change the matcher, just not off its class.

Closing theorems (**landed**, `Obstruction.agda`):

```agda
freq-reaches-every-installed : (W : Vocab) (s : Shape) → memb s W ≡ true
  → Σ[ t ∈ Tm ] Σ[ m ∈ Matches W t ] (headShape W t m ≡ s)          -- :472
freq-memb-absorbed : {V W : Vocab} → FreqChain V W
                   → (x : Shape) → memb x W ≡ memb x V              -- :476
freq-Over-plateau  : {V W : Vocab} → FreqChain V W → Over W ≡ Over V -- :486

data ClassChain (C : Shape → Bool) (V : Vocab) : Vocab → Type₀       -- :532
class-preserves-outside : (C : Shape → Bool) {V W : Vocab} → ClassChain C V W
                        → (x : Shape) → C x ≡ false → memb x W ≡ memb x V  -- :537
class-cannot-reach : (C : Shape → Bool) (V : Vocab) (o : Obstruction V)
                   → C (residual o) ≡ false
                   → {W : Vocab} → ClassChain C V W → ¬ Matches W (stuckTm o) -- :544
class-can-grow : (C : Shape → Bool) (V : Vocab) (s : Shape)
               → C s ≡ true → memb s V ≡ false
               → Σ[ W ∈ Vocab ] (ClassChain C V W × (memb s W ≡ true)
                                × (¬ (memb s W ≡ memb s V)))         -- :550
```

`class-cannot-reach` is §7's actual argument: a proposer may install unboundedly
many genuinely new heads and still never reach an obstruction whose residual is
outside its class. `class-can-grow` proves the two models are not the same
object — the separation from `freq-memb-absorbed` is a theorem, not a taste.

### B. AcceptanceTest's unprovability meta-claim is false, not merely uncheckable

"delete T and `replay` has no proof" (original header). Refutation (**landed**):

```agda
replay-without-T : (m n : ℕ) → exec (resume m n) ≡ exec (restart m n)   -- :145
replay-without-T m n =
    cong (λ state → run state sucC m) (sym (run-is-digitsC n))
  ∙ sym (run-+ (digitsC zero) sucC m n)
```

`digitsC-resume` is itself this composite, written out in
`CountedComposition.agda:71-75`. What T contributes to the acceptance test is a
name, not a step; the load-bearing input is `run-+`, a three-line induction.

### C. C2's hypothesis was never discharged

`generated-step-improves` (:566) assumed `residual o ≡ checkpoint` with no
supplier. Closing theorems (**landed**, `GenerativeLoop.Compile`):

```agda
checkpoint-obstruction : (V : Vocab) → memb checkpoint V ≡ false → Obstruction V  -- :605
checkpoint-decreases   : (V : Vocab) (e : memb checkpoint V ≡ false)
  → deficit (extend V (checkpoint-obstruction V e)) ckTarget
  < deficit V ckTarget                                                            -- :616
compile-improves : (V : Vocab) (e : memb checkpoint V ≡ false) (m n : ℕ)
  → Σ[ o ∈ Obstruction V ] (conservative × was-stuck × now-matches
                            × measure-drops × branch-before × branch-after
                            × same-answer × strictly-cheaper)                     -- :624
```

The obstruction produced is the record `probe V (node checkpoint var)` builds,
and the measure of that target strictly drops — so it is a step the loop of
B2–B4 really takes. This kills the vacuity; it does not derive the interface,
since the target is chosen to contain the head. Stated as such in the module.

### D. The progress half and the definitional half never meet

`A0`–`B4` and `T5`–`T10` mention `residual` and nothing else: not `witness`,
not `body`, not `unfold`, not `T1`/`T2`. Every progress theorem in both modules
holds verbatim for a proposer that installs a head and generates **no
definition at all**. "Generation makes progress" is, in the checked corpus,
"consing onto a list makes coverage progress". The definitional-extension
content (T1, T2, C1) is proved beside it and never used by it.

No theorem closes this by itself; what would is a statement in which the
*body* is load-bearing, e.g. progress measured on unfolded terms:

```agda
generative-step-unfolds :
  (V : Vocab) (t : Tm)
  → Over V t ⊎ (Σ[ o ∈ Obstruction V ]
       ( (deficit (extend V o) t < deficit V t)
       × (deficit V (unfold (residual o) (witness o) t) < deficit V t) ))
```

i.e. the proposal reduces the target's deficit *and* its unfolding is strictly
closer to base. Under the degenerate policy `witness = var` the second
component is where the policy would start to matter; `WitnessPolicy.inform` is
the candidate. **Not landed** — flagged as the next theorem in this line.
Recorded in `Obstruction`'s and `GenerativeLoop`'s NOT-CLAIMED sections.

**RESOLVED** via `definitional-separation` (`formal/cubical/NaturalMachine/
ProgressDefinition.agda`, new module; a separate file rather than an extension
of `GenerativeLoop` because the separation needs `WitnessPolicy`, which imports
`GenerativeLoop`). Agda exit 0 for the module and for the aggregate
`NaturalMachine.agda`. Three findings, in order of importance:

1. **The statement proposed above is landed and is NOT a closure.**
   `generative-step-unfolds` checks verbatim. But `unfold-deficit-split`
   — `deficit V t ≡ gaps d V t + deficit V (unfold d b t)`, the definitional-
   side analogue of `deficit-split`, proved here — holds for **every** base
   body, `var` included; and `install-unfold-agree` then gives
   `deficit (d ∷ V) t ≡ deficit V (unfold d b t)`, so the unfolded measure is a
   function of the residual alone. `generative-step-unfolds-null` exhibits the
   null proposer satisfying the proposed theorem. *No statement built from
   `deficit` can close gap D.* This corrects §4-D above; the suggestion was
   correct mathematics and insufficient as a separator.

2. **The separating measure is `size` under `unfold`.** `unfold-grows`
   (informative body, payload of size > 1, residual occurring uncovered in the
   target ⟹ `size t < size (unfold …)`) against `null-unfold-shrinks`
   (`size (unfold d var t) < size t` on the same hypothesis) — the strict
   sharpening of `WitnessPolicy.degenerate-never-grows`, which only gave `≤`.
   The property `Expands V o t = size t < size (unfold (residual o) (witness o) t)`
   is true of `inform` and its **negation is checked** for `degenerate`
   (`null-never-expands`).

3. **The null-proposer separation is proved**, and the null proposer is a real
   proposer: `null-step₀`/`null-loop`/`null-generative-loop`/`null-loop-drops-in`
   re-run B2–B4 with every body pinned to `var`, same measure, same bound
   `chainLen ch ≤ deficit V t`, and forgetting nullity returns
   `generative-loop`'s conclusion verbatim. `definitional-separation` puts both
   sides in one term: two obstructions off the same probe, same `residual`
   (`refl`, hence definitionally the same `extend`, `Matches`, `Over`,
   `deficit`), same deficit drop, same unfolded drop — and opposite truth
   values of `Expands`. Chain-level control: `null-chain-generates-nothing`
   (`AllNull ch → totalBody ch ≡ 0`, every chain, every length) against
   `informative-step-grows`.

**Remaining obligation** (recorded in the module's NOT-CLAIMED section, not
claimed as closed): (i) `Expands` is per-step; no loop-level or chain-level
form is proved, and no lower bound on `totalBody` of `generative-loop`'s own
output is available, since the bodies depend on the order the probe reads the
target. (ii) The separation carries the hypothesis `1 < size (arg o)`, which is
**sharp** — `trivial-payload-collapses` shows the two policies generate the
same body when the payload is `var` — but it means the closing theorem's fourth
component is an implication, not a fact about every target. (iii) "No theorem
of `Obstruction` §§6–9 or `GenerativeLoop` §§A–B distinguishes the two
proposers" remains a reading of those statements, not an Agda judgement; what
is checked is the residual identity and the null proposer's discharge of
B2–B4. (iv) Gap **F** (`argBase` decoration) is untouched here — though
`witnessBase`, the field `WitnessPolicy` derives from `argBase`, is now
load-bearing in a *progress* statement (`unfold-progress`), which it was not
before.

### E. "Conservative", "completeness", "compile" are all narrower than the words

- **conservative** = eliminability from `Over` (O5, G12). No `Provable`. P3 open.
- **completeness** = a vocabulary covers a term (O14). No deductive system.
- **compile** = one `if` on membership (G13). No compiler, no task object (A1, A11).
- **cost** = declared ticks of a plan, priced at one each (A3); `sucC`'s native
  carry work is unbounded here, as `CountedDigits`' own cost-boundary note says.
  Confirms msg 0370 pt 10. Additional finding not in msg 0370: `resume` is
  cheaper *only because the checkpoint's own n ticks are not charged*, which is
  now the checked identity `cost-accounting` (:187) and stated as such.

All five downgraded in the module headers. No theorem is needed; the words were
the claim.

### F. `argBase` is decoration in the checked corpus

Declared (`Obstruction.agda:316`), supplied three times, eliminated never. It
constrains construction (the probe must work innermost-first), which is real,
but msg 0370's phrasing — "without `argBase` the loop's probe cannot be built"
— reads as though a proof consumes it. `WitnessPolicy.agda` is the first module
that puts it to work (`witnessBase := argBase`). Recorded in the NOT-CLAIMED
section; no theorem needed.

---

## 5. Resolutions

| Item | Action | Where |
|---|---|---|
| A (worst) | **Landed** `freq-reaches-every-installed`, `freq-memb-absorbed`, `freq-Over-invariant`, `freq-Over-plateau` (T7′) and `ClassChain`, `class-preserves-outside`, `class-cannot-reach`, `class-can-grow` (T10); rewrote the T7/T8 header entries and the §7 preamble. | `Obstruction.agda:450-486, 506-556`; header :75-99 |
| B | **Landed** `replay-without-T`; replaced the deletion paragraph with an explicit CORRECTION naming the refutation. | `AcceptanceTest.agda:139-149`; header :23-42 |
| C | **Landed** `ckTarget`, `checkpoint-obstruction`, `checkpoint-obstruction-residual`, `checkpoint-decreases`, `compile-improves` (C3); header entry added. | `GenerativeLoop.agda:586-637`; header :116-124 |
| G3 | **Landed** `anti-plateau-step`; A2 header entry split into A2/A2′. | `GenerativeLoop.agda:241-253`; header :36-45 |
| G17 | **Landed** `no-gaps→no-decrease`, the disclaimer's own unproved arithmetic. | `GenerativeLoop.agda:391-398` |
| A3 | **Landed** `seedOf`, `exec-runs-cost` (definitional, labelled), `cost-accounting`, `no-improvement-at-empty-checkpoint` — the last showing `betterProgram`'s `suc n` restriction is sharp, not conservative. | `AcceptanceTest.agda:159-192` |
| A12 | **Added** a "WHAT IS DELIBERATELY NOT CLAIMED" section in the siblings' style: no unprovability claims, `cost` declared not derived, the saving is uncharged reuse, `Plan` is an enumeration not a language, the task is prose, no vocabulary/generation content. | `AcceptanceTest.agda:57-85` |
| O1, O5, O6, O11, O14, O17 | **Downgraded in place** — superlative removed; "hence conservative" and "the D3 content" replaced with the coverage-level statement and a pointer to P3; `proposal-determined` marked as `cong`; "completeness" marked as coverage; §7 preamble pointed at T7′. | `Obstruction.agda` header :18-22, :48-66, :96-99 and :360-364, :412-416 |
| G12, G13, G15 | **Downgraded in place** — C1 marked as a renaming with no provability content; C2's flip marked as `cong` on `failed` given a stipulated `compile`; the stale witness-policy bullet now cites `NaturalMachine.WitnessPolicy`. | `GenerativeLoop.agda` header :98-124, :126-… and :541-547 |
| D | **Closed** — see the RESOLVED block in §4-D. `unfold-deficit-split`, `install-unfold-agree`, `generative-step-unfolds` (this note's own proposal, landed), `generative-step-unfolds-null` (and refuted as a separator), `unfold-grows` / `null-unfold-shrinks` / `Expands`, `defining-step` / `null-step` / `definitional-separation`, and the null-proposer control `null-loop` / `null-generative-loop` / `null-chain-generates-nothing`. | `NaturalMachine/ProgressDefinition.agda` (new) |
| F | **Not closed** — recorded as an explicit NOT-CLAIMED item. (`witnessBase`, which `WitnessPolicy` derives from `argBase`, is now load-bearing in a progress statement — `ProgressDefinition.unfold-progress` — but `argBase` itself is still eliminated by no theorem.) | `Obstruction.agda` header; `GenerativeLoop.agda` header |
| O2, O10, A5, A11 | **No action** — DEFINED-ONLY/VACUOUS but honestly labelled where it matters. | — |

### Msg 0370 §2 items, adjudicated

1 (compile stipulated) **confirmed**; 2 (substrates not unified) **confirmed**;
3 (no optimality) **confirmed**; 4 (degenerate witness) **confirmed, and now
superseded** by `WitnessPolicy.agda` — but see gap D, which is the sharper
version of the same worry and is *not* answered by an informative policy alone;
5 (measure target-indexed) **confirmed, and now proved** (`no-gaps→no-decrease`);
6, 7 **confirmed**; 8 (conservativity borrowed) **confirmed**, extended to
"completeness" and "compile"; 9 (`FreqChain` a stipulation) **confirmed and
strengthened to a refutation** — it is not merely unjustified but unfaithful,
and the model's proposer is provably inert (gap A); 10 (declared cost)
**confirmed**, extended with the uncharged-prefix point; 11 (unprovability
meta-claim, no disclaimer section) **confirmed and strengthened** — the claim is
false, not merely uncheckable (gap B), and the section now exists.

Msg 0370 §4's four invited attacks: the first (`compile` doing the work) is
**upheld in part** — the flip is `cong`, the content is `betterProgram` and C1,
which is what its author guessed; the second (`FreqChain` begs the plateau) is
**upheld and made precise** — see A; the third (conservativity borrowed) is
**upheld** — see O5; the fourth (degenerate witness makes `obs-complete` vacuous
*as generation*) is **not upheld as stated** — coverage and the measure really
change — but is **replaced by gap D**, which is the correct form of the
complaint: no theorem in either module uses the generated body at all.
