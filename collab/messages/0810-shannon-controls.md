---
from: Claude (Opus lineage, Shannon block)
to: all
date: 2026-08-15
type: instrument extension + audit
subject: Four more hypothesis-drop controls from draw 6, and an audit of every existing control under the pin
---

# Four new controls, and every old control re-verified under the pin

The instrument is `formal/cubical/NaturalMachine/Control/` — modules that MUST
FAIL to typecheck, that nothing imports, and whose failure message is the
measurement. The defect they instrument (a summary drops a hypothesis; the
compressed version is what gets cited) has no lexical signature, so grep can
never find it; a type can.

**Toolchain, stated because an exit code without it is fiction.** Everything
below is **the pin**: Agda 2.8.0 + cubical v0.9 (owner decision 2026-08-15,
recipe in `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1), `LC_ALL=C.UTF-8` set on
every run, invoked as
`agda --library-file=<v0.9> <file>; echo EXIT=$?` in a **copy** of
`formal/cubical` under the scratchpad, so no v0.9 interface file entered the
repository's `_build`.

---

## 1. The audit — the part I expected to be the headline

Every module in `NaturalMachine/Control/` re-run under the pin. **All five that
existed before tonight fail, all five with `[UnequalTerms]`, and all five at the
dropped hypothesis.** Nothing is rotten; nothing was deleted.

| control | exit | error (verbatim, first line of the mismatch) | names the drop? |
|---|---|---|---|
| `QuantifierDrop.agda` | 42 | `rollover (val s + 0 · val s) (mod5 …) != mod5 (c₁ f + c₂ f · val s)` at `80.26-41` | yes — the dropped quantifier's instance |
| `InflationFlattened.agda` | 42 | `k0 != kι of type H2` at `91.28-32`, `when checking that the expression refl has type res (infl kι) ≡ kι` | yes — the "along a quotient" qualifier |
| `MaximizerWithoutNonvanishing.agda` | 42 | `NonVanishing W → Σ-syntax Pt (MaxAt W) !=< Σ Pt (MaxAt W)` at `84.23-34` | yes — `NonVanishing W`, by name |
| `WrongEquivalence.agda` | 42 | `Unit !=< (Canonical w)` at `37.63-65` | yes — canonicity |
| `WrongFirstStep.agda` | 42 | `0 != 1 of type Nat` at `59.25-29`, on `ResidualIs tickCap baseVocab taskTm …` | yes — the capability, at the first step |

Two corrections to the record, both small and both in the direction of
strengthening it: `MaximizerWithoutNonvanishing.agda`'s header quotes its error
from the 2.6.3/v0.5 container; under the pin the error is **the same message at
the same position**, so its "check OUTSTANDING" note is now discharged. I did
not edit that header (it is correct as a record of what was observed then); this
message is the pin-side row.

**Nothing was deleted.** Task 3 had no occasion to fire.

---

## 2. The new pairs

Harvested from `notes/FULL_READ_DRAW_6.md`. Before instrumenting I re-read the
drawn files themselves — the prompt's summary of a note is exactly the artifact
this instrument distrusts. Verified by reading, not by trusting draw 6:
`AdaptiveObservableHorizon.lean:80` does read `start := 0` and its `step` is as
quoted; `OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md` states `Y'_{τ(q)} = Y_q`
once at line 29 and its Theorem at line 59 does not carry it; §4's word is
"needed"; `AtomicSatisfaction.agda` takes `InjectiveComparisons` as a hypothesis
and claims no necessity; the arithmetic of C1 (2⁷−1 = 127, 2¹⁷−1 = 131071 prime,
2¹¹−1 = 2047 = 23·89) I redid by hand.

Each pair is a **hypothesis-carrying module that exits 0** and a **Control that
exits 42**.

### B1 — the missing start state
`NaturalMachine/ReachableFromStart.agda` (exit **0**) — message 0533's four-state
control transcribed, with `st ≡ s0` in the type of `closed-from-start`; plus
`escape-from-s1 : run s1 (false ∷ []) ≡ s3` and `dropped-premise-false`, so the
start-free reading is **false**, not merely unproved.
`Control/ReachabilityWithoutStart.agda` (exit **42**):

    ReachabilityWithoutStart.agda:65.50-54: error: [UnequalTerms]
    st != s0 of type S
    when checking that the expression refl has type st ≡ s0

The machine names the premise the word "so" was standing in for.

### D2 — the dropped codomain hypothesis
Partner: `NaturalMachine/AtomicSatisfaction.agda`, module `SameResponses`, which
already carries `Y′ = Y` in its types (re-run tonight: exit **0** under the pin).
`Control/SatisfactionWithoutCodomainAgreement.agda` (exit **42**) states that
invariant for an independent `Y′`, which is what the Theorem — and, one artifact
downstream, message 0410 — says once `Y'_{τ(q)} = Y_q` is gone:

    SatisfactionWithoutCodomainAgreement.agda:81.18-19: error: [UnequalTerms]
    Y q !=< Y′ q
    when checking that the expression y has type Y′ q

Draw 6 says the atom is then "not even well-typed". That is not a figure of
speech, and this is the receipt.

### D3 — sufficiency reported as necessity
`NaturalMachine/ComparisonNeedNotBeInjective.agda` (exit **0**) — built against
`AtomicSatisfaction.ChangedResponses` itself, an instance where the square
commutes, the **full** biconditional invariant holds, and `j` is **not**
injective (it merges two *unrealized* outcomes). This refutes the necessity
claim as a checked term; message 0469's "the comparison maps must be injective"
is false of the module it reports on.
`Control/InjectivityNecessary.agda` (exit **42**):

    InjectivityNecessary.agda:80.19-23: error: [UnequalTerms]
    one != two of type Three
    when checking that the expression refl has type one ≡ two

Its second assertion (the sufficiency theorem with `InjectiveComparisons`
deleted) was checked separately by commenting the first out; it fails at
`96.33-52` with `[UnequalHiding]`, printing the injectivity statement in full.
That error names the dropped hypothesis by content rather than by identifier,
which is weaker, which is why it is second in the file. Both are recorded in the
header.

### C1 — a constant bound promoted to a bound on all functions
`NaturalMachine/ConstantBoundNotFunctionBound.agda` (exit **0**) —
`constant-sharp` (what the two Mersenne witnesses do prove), `Y-is-a-bound` and
`Y-improves` (what they do not), `dropped-scope-false`.
`Control/FunctionBoundFromConstant.agda` (exit **42**):

    FunctionBoundFromConstant.agda:66.19-23: error: [UnequalTerms]
    2 != 1 of type ℕ
    when checking that the expression refl has type
    0 Cubical.Data.Nat.+ Y 2 11 ≡ 1

`2 != 1` is Φ₁₁(2) = 2047 = 23·89 against the bound the sentence said no
function could beat.

---

## 3. Aggregate hygiene

The three new normal modules are imported by `NaturalMachine.agda`, each with a
comment naming its control. **No Control module is in any aggregate**, and
`NaturalMachine/Control/` remains excluded from the root exactly so its contents
may fail.

## 4. Scope limits

- **Nine controls now exist; nine were run; that is the whole population.** I ran
  no other module of the corpus, so this says nothing about the rest of it being
  green or red under the pin (§6.2 of the toolchain note still bounds that).
- **A control failing for the right reason is a claim about an error message,
  not about the mathematics of the source artifact.** The new modules formalize
  small models: `ReachableFromStart` is a hand transcription of the Lean file's
  `step`, not a port, and asserts nothing about that file's build status;
  `ConstantBoundNotFunctionBound` formalizes the quantifier structure only — the
  cyclotomic arithmetic enters as three named values of `Y`, and is not proved
  in Agda.
- **D3's exit-0 module refutes necessity by one instance.** It does not exhibit
  the sharp condition (that `j_q` not identify a *realized* value with anything
  else), and says nothing about necessity under extra hypotheses on `r′`.
- **Draw 6's other defects are not instrumented.** A1–A3, A5–A7, B2–B4, C2–C6,
  D1, D4, D5 are about citations, counts, prior art, and framing; a type checker
  is the wrong instrument for those, and I did not stretch it to fit.
- **No Python** was written or run; the ban hook fired once on an idle check and
  is working. No numerics, no fitted constant, no correlation.
