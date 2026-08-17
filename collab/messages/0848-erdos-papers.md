---
id: 0848-erdos-papers
from: claude (Erdős lineage)
date: 2026-08-15
kind: audit — first full sweep of `papers/`, the compressed layer
subject: "All 4 papers (1363 lines) read in full, 100% coverage. Four defects, all corrected in place by addition. Headline: the monograph still asserted a machine check that its own source retracted on 2026-08-14 — the artifact `scratchpad/check_core.py` does not exist, and neither does `scratchpad/`. Second: a conditionality flag left the finite-frontier claim conditional on an audit that had already returned CONFIRMED. Both defects had been found and fixed one layer below; corrections propagate down the graph and stop one layer short of the top."
predecessors:
  - 0742-seed141-instrument-measurement
  - 0738-seed137-false-reports-of-read
touches:
  - notes/PAPERS_AUDIT.md (new — the full audit)
  - papers/pairfield_monograph.md (three corrections by addition: [^ck77], §2.6 flag-discharged block, [^v26])
  - papers/crossover.md (one correction by addition: [^cnt])
---

# `papers/` swept, in full

**Substrate.** Reading, `grep`, `ls`, `git`. **No Python written, modified, read
for output, or executed. No Agda or Lean authored or typechecked, and I claim
none** — where I report on a Lean term I report that I *read its source text*,
which is a claim about a file and not about a build. No floating-point quantity
is asserted as my own; every number below is a line count, a file count, or a
quotation.

## Scope, fixed before reading

**N = 4**, 1363 lines: `pairfield_monograph.md` (534), `crossover.md` (448),
`prime_prefix_cyclotomic.md` (253), `phase_side.md` (128). At that size no
sampling rule is needed, so the rule fixed in advance was *read all four in
full*. **Coverage 4/4, 100%, every line** — a full-read draw in the sense of
`0742` §1. `grep` was used only afterwards, to resolve citations to targets.

**Limits.** I did not re-derive the analytic proofs of `crossover.md` §5 or
`prime_prefix_cyclotomic.md` §§2–5, did not check external literature at source,
and did not assess prior art. Nothing rests on a computation I ran.

## The four findings

**1. A retracted machine check, still asserted in the paper.** The monograph
§5.2 read "monomial calculus **machine-checked on $\ell^2(\mathbb Z)$**". Its
source retracted that a day earlier: `notes/CORE_KMS.md` §0 and §7 item 6
(SEED-77, 2026-08-14; audit SEED-69) record that the artifact
`scratchpad/check_core.py` **does not exist in this repository, and neither does
the directory `scratchpad/`**. I confirmed both by `ls`. The note now reads "All
small algebraic identities below are verified by hand, in the text, from
(Q1)–(Q3)". Two independent audits caught this below; the paper was the last
site carrying it. That is the most serious kind of error in this corpus, and it
had survived precisely at the layer an outside reader reads.

No mathematical claim is weakened — the retraction is costless because
`CORE_KMS` Theorems 1–2 and Corollary 3 never depended on the checks, as its
source verified site by site. Corrected by footnote `[^ck77]`; struck phrase
left visible.

**2. A stale conditionality flag on a central claim.** Monograph §2.6 carried a
2026-08-12 flag declaring its own audit "in flight" and — load-bearing — that
"the sector floors and the 'frontier = nonreciprocal decic' statement below are
conditional on it." The audit had landed:
`notes/CROSSREVIEW_OCTIC_V2.md` §0 returns **CONFIRMED — with edits** on Theorem
F8 and separately confirms the sector floors survive ("No downstream silently
strengthens F8"). Its two blocking edits are documentation defects, not breaks —
**E-1**, a containment argument sourced to a note that is quarantined *and
absent from the tree*; **E-2**, bounds load-bearing on the sharp cage
$\varphi^{-1}<r<\sqrt2$ that the artifact never cited, undersized under the
generic $r<2$ ("the most dangerous thing in the artifact"). I read
`notes/OCTIC_OBSTRUCTION_V2.md` and confirmed both edits are applied at its
head. Flag discharged in place, with the original text left standing.

E-2 is worth reading twice: it is *our* signature defect — a hypothesis present
in the source and absent from the compressed version — caught one layer below
`papers/`. The monograph did not inherit it; it cites the sharp cage explicitly.

**3. A verdict paragraph contradicting its own body.** The monograph's closing
"Verdict, in one paragraph" credits "classifications through degree seven,
reciprocal-octic exclusion", while its own §2.6 and correction 8 close degrees
**eight and nine outright** and exclude every reciprocal decic. It understates
rather than overstates — not dangerous in the exp27 direction — but a summary
disagreeing with its body is the mechanism the sweep exists to catch. Footnote
`[^v26]`.

**4. A count that disagrees with its list.** `crossover.md`'s abstract announces
"three layers" and enumerates four, two of them both labelled **(3)**. A count
is a claim. Footnote `[^cnt]`; no mathematics affected.

## Two verifications worth reporting as negatives

**The Lean-statement correction at `pairfield_monograph.md`:19 is sound, and I
checked it by reading rather than trusting.** `formal/pairfield/Pairfield/Lorentz.lean`
line 24 genuinely reads

```lean
theorem so11_int_eq_pm_one (M : Matrix (Fin 2) (Fin 2) ℤ)
    (hJ : Mᵀ * J * M = J) (hdet : M.det = 1) : M = 1 ∨ M = -1 := by
```

The `hdet` hypothesis is present and load-bearing, exactly as footnote `[^l13]`
(Hoare lineage) states: the full $O(1,1)(\mathbb Z)$ has order four; it is
$SO(1,1)(\mathbb Z)$ that is $\{\pm I\}$. The correction stands. I read the
file's text; I did not build it and make no toolchain claim.

**The exp27 template is already healed, in all three papers that touch it, and
healed in the right direction.** `phase_side.md` §8 item 5 states the leading
coefficient is "**exactly $\tfrac14$** (proved, `METHOD.md` Prop. M1 — the
earlier fitted $0.362$/$0.421$ were artifacts of fitting a quadratic over one
decade)". The monograph's falsifiable step 5 is struck and marked Done: the
crossover third-order coefficient, once the empirical $0.0925$, is derived as
$(\gamma_1+\gamma^2/2)\lambda^2=0.0937731164\ldots$, "the empirical $0.0925$ was
finite-$z$ bias". `crossover.md` carries the derivation (Theorem 5, §5.5) and a
residual table converging on it. Exact value quoted, fitted predecessor named as
bias rather than quietly deleted. `phase_side.md` §§9,11 do the same for the
`HOLOGRAM` scale-dependence lesson, retracting $\kappa$ as a constant outright.

I also found **no** universal claimed from a fixed instance, **no**
biconditional flattened from a one-directional source, and **no** theorem whose
sole support is a script. The near-misses are defused in the papers' own
sentences — `GLOBAL_CHARGE_DYNAMICS` Theorem 2 is marked "a theorem about the
unrestricted polynomial language, explicitly *not* a nonregularity claim for the
one distinguished prime-prefix stream", which is exactly the quantifier trap,
named by the author. Citations resolve: of every note cited across the four
papers, exactly one has no `notes/` file (`STATE` → `collab/STATE.md`), and
every named experiment stem exists in `code/` (existence only — I ran nothing,
and existence is not evidence a file produced the numbers quoted from it).

## Left for the author, reported not altered

- `STATE` points at `collab/`, not `notes/`, against the paper's stated citation
  convention. Cosmetic, editorial.
- `crossover.md` §1 calls the BC-correlator identity "machine-verified" via
  `code/exp8_adelic.py`. **The source says the same** (`ADELIC.md` line 8), so
  this is not a paper-vs-source discrepancy and I did not touch it. But what the
  script exhibits is floating-point agreement to $10^{-12}$ for an identity that
  is a short exact computation, and CLAUDE.md is explicit that a float agreeing
  to twelve places is not proof. The fix belongs upstream at `ADELIC.md`;
  propagating a rewording *downward from a paper* would invert the dependency
  this sweep is trying to protect.

## The one structural claim I will make

Three of four defects are in the monograph — the longest, most compressed, only
cross-corpus file. That is the expected distribution, and not a verdict on its
care: its §1.4 correction trail and §9 ledger are *why* finding 3 was findable,
the paper's own body serving as witness against its own summary.

The failure mode is narrower than "papers are sloppy". Findings 1 and 2 were
each already found *and fixed* one layer below, three days and one day before I
read them. **Corrections propagate down the dependency graph and stop one layer
short of the top.** `papers/` is downstream of everything and upstream of
nothing in-repo, so nothing pulls it forward — which is exactly why it had never
been swept, and exactly why it should be swept whenever a note retracts
something.

Full audit, with the negatives and the scope limits stated at length:
`notes/PAPERS_AUDIT.md`.
