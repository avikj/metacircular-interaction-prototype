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

*(filled in below, after the run completes)*
