# What this container can verify — a registered prediction, then the audit

**Timing disclosure** (following `LEAKAGE_PAST_IDEMPOTENCE.md`'s precedent):
the prediction in §2 was written and committed **before** the audit in §3
was read. The audit was already running in the background when the
prediction was written; its output had not been looked at.

---

## 1. The finding that prompted it

`formal/cubical/NaturalMachine.agda` — the root whose green `BUILD.md`
quotes — fails in this container:

```
NaturalMachine/PathIsSymmetry.agda:98   Not in scope: SymGroup   EXIT=42
```

`Cubical.Algebra.SymmetricGroup` exports `Symmetric-Group` in the version
installed here; `SymGroup` is the **v0.9** name. `BUILD.md` pins the
repository at **Agda 2.8.0 / cubical v0.9**; this container runs **2.6.3 /
v0.5**. The root is not broken — it is unbuildable *here*.

`BUILD.md` already records the other half of the same drift: the
repository's solver spelling `solve!` is v0.9-only, and v0.5 has `solve`.
`Bhavana.agda`'s header says it uses the older spelling deliberately, "the
one presentation that is stable across both surfaces", and it builds here.

So there are two known v0.9-only names in play. That is enough for a
prediction.

## 2. The prediction, registered

Counting **non-comment** occurrences only (comments mentioning a name cost
nothing — `Bhavana` and `Kuttaka` name `solve!` in prose and build fine):

- **15 top-level modules use `solve!` in code** — `CayleyPairChart`,
  `CenterRelative`, `DynamicDescent`, `Gamma0Converse`,
  `Gamma0ConverseSharp`, `Gamma0Freeness`, `Gamma0Partner`,
  `Gamma0PartnerRigidity`, `Gamma0Transitivity`, `KuttakaValli`,
  `M2Unimodular`, `ParityNormEliminant`, `Rank1DihedralChart`,
  `SubsetSumChartDepth`, `TransporterMembership`.
- **4 `NaturalMachine/` modules use `SymGroup` in code** —
  `Decategorification`, `FiniteNonabelianHolonomy`, `PathIsSymmetry`,
  `StabilizerSubgroup`.

**Predicted:** those 15 fail at the top level, `Everything.agda` and
`NaturalMachine.agda` fail through the `SymGroup` chain, and **every other
top-level module passes**. If a module fails that is on neither list, the
"pin drift explains it" diagnosis is incomplete and there is a second
cause to find.

## 3. The audit

**70 of 93 top-level modules build here. 23 do not.**

### The prediction failed, and the hypothesis it was testing did not

Predicted: 17 failures (15 `solve!` users, plus `Everything` and
`NaturalMachine` through `SymGroup`). Actual: **23**. The prediction was
wrong.

It was wrong in its **enumeration**, not its **theory**. Every one of the
23 failures is pin drift, and there is no second cause:

| missing name | modules |
|---|---|
| `solve!` | 18 |
| `SymGroup` | 4 |
| `solveℕ!` | 1 |
| `·IdR` | 1 |

Zero failures from anything else. What I got wrong was the list:

- I grepped for **two** v0.9-only names when there are at least **four**.
  `solveℕ!` (the ℕ-solver spelling, v0.5 has `solve`) and `·IdR` (v0.5 has
  a different name) are the same drift and I did not think to look for
  them — `BUILD.md` names `solve!` and I found `SymGroup` myself, so I
  audited exactly the two I already knew.
- I ignored **transitivity**. `NaturalMachineRun`, `TotientFibreSymmetry`
  fail through `PathIsSymmetry`; `PrimePairField` through `CenterRelative`;
  `SmithTorsorBridge` through `Gamma0Partner`. Four of the six
  "unpredicted" failures are predicted modules one import away.

So the honest verdict is a right theory with a wrong list, which is a
different kind of error from a wrong theory and worth separating. The
registered form is what makes the separation visible: had §2 not been
committed first, "pin drift explains everything" would read as a finding
rather than as a hypothesis that survived a failed enumeration.

### The map, which is the useful output

**Verifiable in this container:** 70 top-level modules, plus all of
`NaturalMachine/` that they and this session's 45 reach.

**Not verifiable here, and not broken:** the 23 above. Each is correct for
the pinned toolchain (Agda 2.8.0 / cubical v0.9) and unbuildable at 2.6.3 /
v0.5. Nothing in this audit says anything about whether they are green at
the pin — that claim can only be made by someone running it.

### The four names, for anyone writing here

`Bhavana.agda`'s header already gives the rule and gives it correctly:
prefer the spelling that is stable across both surfaces. Concretely, in
this container use `solve` (not `solve!`, not `solveℕ!`),
`Symmetric-Group` (not `SymGroup`), and check `·IdR`-style names against
the installed library before use. Every module this session added follows
that rule, which is why all 45 build here.
