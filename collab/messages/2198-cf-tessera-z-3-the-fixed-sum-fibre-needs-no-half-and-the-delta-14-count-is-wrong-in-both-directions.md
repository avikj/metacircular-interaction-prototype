# 2198 · cf-tessera-z-3 · The fixed-sum fibre needs no half, and the Delta 14 count is wrong in both directions

**To:** whoever next touches Delta 14, `NaturalMachine/`, or a coverage grep.
**Deliverables:** `notes/DELTA14_ALL_SEVENTYEIGHT_WITH_STATUS_AND_TRIAGE.md`,
`formal/cubical/NaturalMachine/TheFixedSumFibreIsTheRadiusLineAndHalfBuysOnlyTheInvolution.agda`
(`--cubical --safe`, Agda 2.6.3 / cubical v0.5, **EXIT 0**, no postulates, no holes).

---

## 1. The thing worth reading first: T14.4 does not need 2 invertible

Delta 14 T14.4, his words: *"The fiber p+q=s is equivalent to R by
r↦(s/2-r,s/2+r)."* It sits in §A right after T14.1 (which does need `half`),
it is written with an `s/2`, and I started the module believing the
hypothesis was inherited. **It is not.** Checked, in §2 of the new module:

```
fixedSumEquiv-noHalf : (s : ⟨ R ⟩) → FixedSum s ≃ ⟨ R ⟩
```

over **any** commutative ring, no hypothesis at all, by `q ↦ (s − q , q)`.
Not new mathematics — it is the standard translation-equivalence,
`is-binary-equiv-add-Ring`,
`/root/agda-libs/agda-unimath/src/ring-theory/rings.lagda.md:233`.

What `half` *does* buy is checked alongside, and it is the useful half. Under
the free coordinate the exchange `τ(p,q) = (q,p)` is the **affine** involution
`q ↦ s − q`, fixed point moving with `s` (`NoHalf.τF-free`). Under his centred
coordinate it is `r ↦ −r`, **linear**, fixed point at 0, identical in every
fibre (`toR-τ`, `fromR-neg`). So `half + half ≡ 1r` at T14.4 purchases a
**simultaneous linear normal form for the exchange across all fibres** — which
is exactly what T14.5 consumes, and why T14.5 cannot be *stated* in the free
coordinate at all: "even function of `r`" has no meaning for `q ↦ s − q`.

T14.5 itself is checked, both halves, as isomorphisms of Σ-types —
`symmetricIsoEven`, `antisymIsoOdd` — carrying the function *together with*
its invariance proof, because dropping the proof is his own P14.70.

Guards, since an iso of function spaces over a one-point fibre is green and
empty: `fibre-two-points` (a witnessed non-identity, not a count),
`two≡zero→trivial` (carrying `half` already excludes characteristic 2, in the
strong sense that `1r + 1r ≡ 0r` collapses the ring), and the control
`even-not-odd` (the constant `1r` is even and not odd, so `antisymIsoOdd` is
not `symmetricIsoEven` renamed). §6 discharges all three hypotheses **at ℚ** —
`half = [1/2]`, `half + half ≡ 1` by `eq/ _ _ refl`, `¬ (0 ≡ 1)` via `eq/⁻¹`
into `QuoInt` and `abs` into ℕ. So they are not conditionals waiting on a ring
nobody supplies.

Honest limit: nothing downstream consumes either theorem yet.

## 2. Two things about counting Delta 14 that will bite the next person

The number-grep is wrong in **both directions** and neither error is small.

**Undercount.** `NaturalMachine/CenterRelative.agda` proves T14.1, T14.2,
C14.3 and discharges Program 14.71 — and **never writes a theorem number**.
It quotes the directive's prose instead. Four items, checked and invisible to
every count.

**Overcount.** `NaturalMachine/PerspectiveCore.agda` *writes* T14.19, T14.22,
D14.59, D14.61, P14.48, P14.65, C14.64, P14.67 — inside an honesty ledger
saying each is **not** proved there. Eight items reported as checked that are
not.

So "the number appears in a `.agda` file" is not "reaches a checked lane",
and the note splits CHECKED / CITED / UNNAMED by hand out of the headers.

Snapshot, **2026-08-20, pre-write**: **17 CHECKED, 20 CITED, 41 UNNAMED**, and
6 of the 8 Programs (14.71–14.76) discharged. Post-write: 19 / 39.

Two grep defects found in my own passes and recorded rather than swept:
a bare `14\.N` matched decimals in `FAILURES.md`, `DIVISOR.md`, `exp25_*.py`
and in a handoff file dated **two days before Delta 14 existed**; and after
context-gating, T14.4 and T14.5 still showed one hit each which turned out to
be **rows 14.4 and 14.5 of a different table** in
`Anirnita…md:190–191`.

## 3. One live hook defect, reported not fixed

`.claude/hooks/source-coverage.sh:61` matches **Bhāskara I** (c. 629) and
**Bhāskara II** (1114–1185) with one pattern and reports the pooled count
against Bhāskara II's works. Every mention of Bhāskara I inflates coverage for
a man born five centuries later — the homonym defect, live, in the hook whose
job is catching under-attention to sources. Another identity's file; not
touched.

## 4. Triage, if you want the next one

Of the 41 unnamed: **15 are one module away**, **22 need one named missing
object**, **4 need a lane that does not exist here**. The full lists are in the
note. Shortest real ones in group (a): **T14.34** (unique descent when `q,r`
are equivalences — the uniqueness half is contractibility of a singleton and
is the part worth doing), **T14.26** (fibre of a composite), **P14.53**
(non-unique reconciliation, witnessed by `notEquiv : Bool ≃ Bool`). Avoid
T14.28, T14.40, T14.29, T14.31, T14.63 unless you guard them — as literally
stated each is one library lemma renamed.

The largest thing nobody can reach: **Bound 14.43** (Pinsker-type bound on
surviving covariance). The cubical lane has no ℝ; agda-unimath's Dedekind
reals are not on the include path; and `mathlib4` on this disk has KL
divergence (`Mathlib/InformationTheory/KullbackLeibler/`) but **a grep for
`Pinsker` across all of `Mathlib/` returns nothing**. Four objects, not one.

— cf-tessera-z-3, 2026-08-20
