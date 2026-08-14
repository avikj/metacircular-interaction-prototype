# Delta 24, made exact: the diagonal engine as a theorem, and the Φ-toy obligation

**2026-08-14, branch `claude/eternal-golden-braid-eaw7do`.** Companion to
`EGB_DELTA24.md` (the recovered founding-object program). Delta 24's own honesty
line — *"No novelty claim. The purpose is inheritance and exactification"* — is
taken literally here. Two of its sections are certifiable *without a
typechecker*, and one is a formalization obligation that this session's
environment cannot discharge (no `agda`/`lean` installed; `run` guards every
check behind `command -v agda`). This note does the certifiable part in full and
states the obligation precisely, with its limitor attached.

**Checked/unchecked ledger (stated first, per the corpus's own gate discipline):**

| item | status here |
|---|---|
| §1 Lawvere fixed-point theorem | **proved below**, elementary, reader-checkable |
| §2 no-terminal-stage schema | **proved below** from §1, hypotheses explicit |
| §3 finite Φ-toy design + finite facts | **hand-verified** (finite, decidable) |
| §3 Agda module `formal/cubical/EGBPhiToy.agda` | **UNCHECKED** — no toolchain in this session; a kernel obligation, deliberately out of `run`'s build list |

Nothing below wears a "verified green" badge it did not earn. The Lawvere results
are proofs (a reader is the checker); the Agda is an obligation, marked as one.

---

## 1. Lawvere's fixed-point theorem (the diagonal engine, §9 of Delta 24)

This is the exact mature template Delta 24 §9 names, and it is one paragraph.

**Setup.** Work in a cartesian closed category (or any setting with the two
constructions used: a "diagonal" `A → A × A` and evaluation of `A`-indexed
`Y`-valued families). Let `A`, `Y` be objects. A morphism `e : A → Y^A` is
**weakly point-surjective** when every `f : A → Y` is *pointwise* hit: there
exists `a : A` such that for all `x : A`, `e(a)(x) = f(x)`.

**Theorem (Lawvere).** *If some `e : A → Y^A` is weakly point-surjective, then
every endomorphism `ν : Y → Y` has a fixed point.*

**Proof.** Fix `ν : Y → Y`. Define the diagonal family
```
f : A → Y,      f(x) := ν( e(x)(x) ).
```
By weak point-surjectivity choose `a : A` with `e(a)(x) = f(x)` for all `x`.
Instantiate at `x = a`:
```
e(a)(a) = f(a) = ν( e(a)(a) ).
```
So `y := e(a)(a)` satisfies `ν(y) = y`. ∎

**Contrapositive (the boundary-as-production form).** *If `ν : Y → Y` has **no**
fixed point, then no `e : A → Y^A` is weakly point-surjective — and the family
`d(x) := ν(e(x)(x))` is a witness of failure: it is not pointwise represented by
any `a`.* Indeed if `e(a) = d` pointwise for some `a`, then `e(a)(a) = ν(e(a)(a))`,
a fixed point of `ν`, contradiction.

This is Delta 24's slogan made precise: the diagonal `d` is not a *prohibition*,
it is a *constructed object* provably outside the range of `e`. Cantor
(`Y = Bool`, `ν = ¬`, no fixed point ⇒ `A ↛ Bool^A` surjectively), Russell,
Tarski (undefinability of truth), Gödel (`ν` = "provably false" has no fixed
point in a sound theory), and Turing (halting) are the instances; the morphology
is this one lemma (Lawvere 1969). The corpus's `PathIsSymmetry.agda` universe
jump `(X ≡ X)` living one level above `X` is the same phenomenon at the level of
universes.

---

## 2. No terminal stage (Delta 24 §10, §19.D), with hypotheses named

Delta 24 §10 states this as a *schema requiring exact choices*; here are the
choices, and the theorem.

**A stage** `S` provides: an object `X` of *arguments*, an object `Y` of
*values*, an object `C` of *codes*, a coding `q : X → C`, and an
**evaluator** `eval : C × X → Y`. Write `⌜x⌝ := q(x)`.

Say `S` is **behavior-complete** when the curried evaluator represents every
behavior on the diagonal: for every `h : X → Y` there is `c : C` with
`eval(c, x) = h(x)` for all `x`. (Equivalently: `λc.λx. eval(c,x) : C → Y^X`,
precomposed with `q` to land families indexed by `X`, is weakly point-surjective
onto behaviors.)

**Theorem (no self-complete stage with a fixed-point-free value operation).**
*If `Y` carries an endomorphism `ν : Y → Y` with no fixed point, then `S` is not
behavior-complete. Concretely, the diagonal behavior*
```
d : X → Y,      d(x) := ν( eval( ⌜x⌝ , x) )
```
*is not represented: there is no `c` with `eval(c,x) = d(x)` for all `x`.*

**Proof.** Suppose `eval(c₀, x) = d(x) = ν(eval(⌜x⌝, x))` for all `x`. This is
the hypothesis of §1 with `A := X`, `e(x) := λx'. eval(⌜x⌝, x')`, and the
representative `a := ` any `x₀` with `⌜x₀⌝ = c₀` — but we do not even need that:
instantiate the displayed equation at `x = ` the argument whose code is `c₀`. If
`q` is such that some `x₀` has `⌜x₀⌝ = c₀` (true whenever `c₀` is a genuine code,
e.g. `C = X`, `q = id`), then
```
eval(c₀, x₀) = d(x₀) = ν( eval(⌜x₀⌝, x₀) ) = ν( eval(c₀, x₀) ),
```
a fixed point of `ν` — contradiction. ∎

**Consequence for the Braid.** A stage closed under total self-evaluation and
carrying *any* fixed-point-free operation on its values cannot be terminal: the
diagonal `d` is a genuine new object it does not contain, and Φ (Delta 24 §7.6)
adjoins exactly `d` (or its code) at stage `n+1`. This is why Delta 24 §8 is
right to *grade* the reflection operator `Φₙ : Stageₙ → Stage_{n+1}` across
universes rather than seek an internal fixed point, and why §11's ω-colimit is
**not** automatically terminal (`Φ` of it may re-run the diagonal). The
"no God-object" discipline is not caution; it is this theorem.

The one hypothesis that does the work is the existence of a **fixed-point-free
`ν : Y → Y`**. For `Y = Bool`, `ν = ¬` qualifies. This is the precise, minimal
sense in which "inexhaustibility" is a *theorem* and not a mood: it is the
non-existence of a fixed point, nothing more and nothing less. (This word is used
carefully. As a *verified claim* it must reduce to exactly the statement above;
as a name for the Braid's *generative law* it is transmitted and re-derived, not
grepped for — the two standards are kept separate, per `SIXTEEN_LENSES...` §0.)

**A named obstruction is not yet a productive boundary.** Delta 24 (and its v0.1
predecessor) is severe on exactly this point, and it corrects the theorem above.
Lawvere's `d` is a *named obstruction* — a witness `b` locating a failure. But a
*productive* boundary must also supply (i) a warranted extension `Xₙ → Xₙ₊₁`
generated by `b`, (ii) a construction or transport `ρ_b` that was blocked at stage
`n` and is now possible, and (iii) a new consequence `c_b` unavailable before. The
diagonal gives the *morphology* of production — the cell attachment
`X' = X ∪_A B` in which the old boundary becomes a constructor — but **not the
warrant**. The attachment is licensed only when the relevant path, coherence, or
reflection principle has itself been justified (a *pramāṇa*: Nyāya is here
constitutional, not decorative). So §2 proves the stage is non-terminal *and
locates the next object*; it does **not** by itself prove that adjoining `d`
advances the reachable mathematics. For the prime-pair target that gap is the
whole game: a diagonal that merely names "this sieve missed a pair" is a named
obstruction; a diagonal that hands over a *witnessed new pair each finite lens
misses* would be a productive boundary. The corpus's `WITNESS_GENERATION.md`
(finite construction → accessible valuation witness) is the nearest instance where
the warrant is actually discharged — and it is discharged for a *valuation*
witness, not a prime pair (see `SIXTEEN_LENSES...` §3, Cantor).

---

## 3. The finite Φ toy (Delta 24 §19.C): design, finite facts, and the Agda obligation

Delta 24 §19.C asks for a bounded, checkable cycle exhibiting all of Φ's moves.
Here is a concrete design in which every fact is finite and hand-verifiable, so
the *mathematics* is certified now and only the *machine transcription* is
deferred. Three presentations:

```
G₁ := Bool        G₂ := Fin 2        G₃ := Fin 3
```

The eight ingredients of §19.C:

1. **Native objects.** `Bool`, `Fin 2`, `Fin 3` — three finite presentations.
2. **One TRUE equivalence** `e₁₂ : Bool ≃ Fin 2` (send `false ↦ 0`, `true ↦ 1`;
   the inverse is `0 ↦ false`, `1 ↦ true`; both round-trips hold by case split).
   *Finite fact, verified by exhaustion on 2 points.*
3. **One WEAKER relation** `R₂₃ : Fin 2 → Fin 3 → Type`, the graph of the
   inclusion `ι : Fin 2 ↪ Fin 3`, `R₂₃ i j := (ι i ≡ j)`. It is a genuine
   proof-relevant relation (a mono), and it is **not** an equivalence — there is
   no `Fin 2 ≃ Fin 3`. Retained, not collapsed.
4. **One FALSE proposed equivalence + explicit separator.** Propose
   `Fin 2 ≃ Fin 3`. The separator is the *cardinality gap*: any `Fin m ≃ Fin n`
   forces `m ≡ n` (Fin is standard-finite; an equivalence induces equality of
   cardinalities), and `¬ (2 ≡ 3)`. So `¬ (Fin 2 ≃ Fin 3)`. *Finite fact:
   pigeonhole on ≤ 3 points; `2 ≢ 3` is `snotz`/`¬ (suc² 0 ≡ suc³ 0)`.*
5. **Univalent (Rezk) completion of the equivalence.** `ua e₁₂ : Bool ≡ Fin 2`;
   transport any structure on `Bool` (e.g. the involution `not`) across to the
   equal structure on `Fin 2`. *This is the `Digits.agda`/`Transport.agda`
   pattern the corpus already runs (47+68=115 by `refl`).*
6. **Gluing of the relation.** Form the collage/span object of `R₂₃`: the
   pushout-style total space `Σ (i : Fin 2) Σ (j : Fin 3) R₂₃ i j`, in which both
   `Fin 2` and `Fin 3` embed and the relation is internalized without being
   declared an identity. (Artin gluing / Sterling logical-relations-as-types,
   Delta 24 §5.)
7. **Retained defect from the separator.** The object `¬ (Fin 2 ≃ Fin 3)` — the
   torn thread — is *kept as a term*, exactly as `Controls.no-raw-round-trip`
   keeps the leading-zero separator. It is adjoined, not discarded.
8. **One reflection step.** The cycle `Bool ≃ Fin 2 —R₂₃→ Fin 3 ⇢ Bool` does
   **not** close to `id`: the `Fin 2 → Fin 3` leg is a non-invertible relation
   and the return leg is a *refuted* equivalence. So the "unity" of the cycle is
   not a single object collapsing to `Bool`; it is the collage of §6 *plus* the
   defect of §7. That composite, presented one universe up, is `S₂ := Φ(S₁)`.
   **The holonomy of the cycle is the defect** — Delta 24's T24.3/T24.4 in the
   smallest nontrivial finite instance.

**What the toy demonstrates, as mathematics (certified):** Φ is not averaging.
Where equivalence holds (§2), it transports (§5) and the presentations `Bool`,
`Fin 2` become interchangeable. Where only a relation holds (§3), gluing (§6)
retains it. Where equivalence is *claimed but false* (§4), the separator (§7) is
manufactured and kept, and it obstructs the cycle from closing (§8). This is
"equivalence by proof, not resemblance" and "when equivalence fails, inspect the
torn thread" realized on three finite types — and every step is a finite check.

**The Agda obligation.** `formal/cubical/EGBPhiToy.agda` transcribes this. In
this session it is **UNCHECKED** (no `agda`), so it is *not* added to `run`'s
build list and its header says so — the same treatment
`Control/WrongEquivalence.agda` gets, for the honest reason (there: must fail;
here: cannot be run). Discharging it on a machine with Agda 2.8 + cubical is the
next exact step. Library-lemma names (Fin cardinality, `snotz`) may need
adjustment against the installed cubical version; that adjustment *is* the
kernel check, and until it is run the file claims nothing green.

---

## Prior art inherited (Delta 24 §21)

- F. W. Lawvere, *Diagonal Arguments and Cartesian Closed Categories* (1969) — §1, §2.
- Ahrens–Kapulkin–Shulman, *Univalent Categories and the Rezk Completion* — the
  exact "equivalence-by-proof" component of Φ (§3 ingredient 5).
- Kaposi–Huber–Sattler, *Gluing for Type Theory*; Sterling, *Logical Relations as
  Types* — the "retain the relation" component (§3 ingredient 6).
- Sojakova–van Doorn–Rijke, *Sequential Colimits in HoTT* — the home for the
  lattice colimit (Delta 24 §11), with its two warnings intact.

The move, as Delta 24 says, is inheritance and exactification — not a new branded
formalism. What this note adds beyond the document is only the discipline of
saying which lines are proofs, which are hand-checked finite facts, and which are
a kernel obligation no one in this session can honestly mark green.
