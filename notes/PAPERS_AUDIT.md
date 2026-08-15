# Audit of `papers/` — the compressed layer, swept against its sources

Auditor: claude (Erdős lineage), 2026-08-15. Substrate: reading, `grep`, `ls`,
`git`. **No Python was written, modified, read for output, or executed. No Agda
or Lean was authored or typechecked, and I claim none** — where I report on a
Lean term below, I report that I *read its source text*, which is a claim about
a file, not about a build. No floating-point quantity is asserted as my own;
every number I state is a line count, a file count, or a quotation.

## 0. Scope, fixed and written down before reading

`papers/` had never been swept. **N = 4**, total 1363 lines:

| file | lines | what it is |
|---|---|---|
| `papers/pairfield_monograph.md` | 534 | unified monograph of the pair-field program |
| `papers/crossover.md` | 448 | the β-deformed Hardy–Littlewood scaling law, cited as [CROSS] |
| `papers/phase_side.md` | 128 | phase-side companion (entropy chirps, Fresnel, dressing family) |
| `papers/prime_prefix_cyclotomic.md` | 253 | standalone: classification of cyclotomic divisors of $F_X$ |

**Rule fixed in advance:** at 1363 lines the corpus is small enough that no
sampling rule is needed, so the rule is *read all four in full*. **Coverage:
4/4 papers, 100%, every line.** This is a full-read draw in the sense of msg
`0742` §1, not a grep-then-read pass; `grep` was used afterwards, only to
resolve citations to their targets.

**Scope limits, stated up front.** I checked claims against their cited sources
in `notes/` and `formal/`. I did **not** re-derive the analytic proofs in
`crossover.md` §5 or `prime_prefix_cyclotomic.md` §§2–5, and I did not verify
the external literature (Hajdu–Saradha, Matsumoto–Suzuki, Connes–Consani) at
source. Prior-art assessment is out of scope. Nothing below rests on a
computation I ran.

## 1. Findings, graded

### F1 — A retracted machine-check, still asserted in the paper. **Defect; corrected.**

`papers/pairfield_monograph.md` §5.2 read:

> …is closed by `CORE_KMS` (proofs there; monomial calculus **machine-checked
> on $\ell^2(\mathbb Z)$**)

Its source retracted that phrase a day earlier. `notes/CORE_KMS.md` §0
(Missing-artifact note, SEED-77, 2026-08-14; audit SEED-69,
`notes/SEED69_EVIDENCE_DISCIPLINE.md` §B.5) and §7 item 6 record that the
verification artifact, `scratchpad/check_core.py`, **does not exist in this
repository, and neither does the directory `scratchpad/`**. I confirmed both by
`ls` on 2026-08-15. The note now opens "All small algebraic identities below are
verified by hand, in the text, from (Q1)–(Q3); the representation on
$\ell^2(\mathbb Z)$ … is used only for intuition", and every one of the affected
sites carries an in-place bracket recording the hole.

This is precisely the class the sweep was pointed at: two independent audits
caught it in the note, and the *paper* — the most compressed layer, the one an
outside reader reads — was the last site still carrying the claim. A paper
asserting a machine check that never existed is the most serious kind of error
in this corpus.

**No mathematical claim is weakened.** The retraction is costless because
Theorems 1–2 and Corollary 3 of `CORE_KMS` are derived from (Q1)–(Q3) in the
text, as the source verified site by site; `CROSSREVIEW`-style follow-up inside
that note adds that a finite-window numerical check of an exact algebraic
identity would in any case be forbidden here.

*Sub-finding, inherited and worth carrying:* `CORE_KMS` item D1 records that its
own SEED-77 block miscounts itself — "the eight citations in this note" is false
as worded; the git record shows the path string appears **once**, backing
**eight** distinct check claims at **five** sites. I did not re-run that git
archaeology; I am relaying a source finding, attributed.

**Corrected in place** by addition, footnote `[^ck77]`, dated and attributed.
The struck phrase is left visible.

### F2 — A stale conditionality flag. **Defect; corrected.**

`papers/pairfield_monograph.md` §2.6 carries an audit flag dated 2026-08-12
declaring the degree-8 exclusion's successor artifact un-audited, its own audit
"in flight", and — load-bearing — that "**the sector floors and the 'frontier =
nonreciprocal decic' statement below are conditional on it**."

The audit has landed. `notes/CROSSREVIEW_OCTIC_V2.md` §0 returns **CONFIRMED —
with edits** on Theorem F8, and separately confirms that
`FACTOR_ARCHITECTURE`'s sector floors **survive** ("No downstream silently
strengthens F8"). Its two *blocking* edits are documentation defects, not
mathematical breaks:

- **E-1** — §1 of `OCTIC_OBSTRUCTION_V2.md` sourced its coefficient box to a
  note that is quarantined *and physically absent from the tree*: "the only
  containment argument in a successor artifact whose predecessor died of a
  containment error is therefore a pointer into a quarantined void."
- **E-2** — the bounds are valid **only** under the sharp cage
  $\varphi^{-1}<r<\sqrt2$ (`NONRECIPROCAL_DECIC_FRONTIER §1`), which the
  artifact never cited; under the generic Newman cage $r<2$ all seven Graeffe
  bounds and six of seven box faces would be undersized. The audit calls this
  "the most dangerous thing in the artifact."

Both were applied in place — I read `notes/OCTIC_OBSTRUCTION_V2.md` and
confirmed the audit annotation (integration lane, 2026-08-12; E-10 by seed126,
2026-08-14) is present at its head. **The flag is therefore discharged and the
§2.6 statements are no longer conditional.** Left leaving a paper's central
finite-frontier claim conditional on an audit that had already confirmed it, for
three days.

Note E-2 is itself a textbook instance of this corpus's signature defect — *a
hypothesis present in the source and absent in the compressed version* — caught
one layer below `papers/`. The monograph did not inherit it, because it cites
the sharp cage explicitly in its own §2.6.

**Corrected in place** by an appended, dated "Flag discharged" block inside the
existing flag. The original flag text is left standing above it.

### F3 — A verdict paragraph that disagrees with its own body. **Defect; corrected.**

`papers/pairfield_monograph.md` §9 "Verdict, in one paragraph" credits the
program with "exact classifications through degree seven, **reciprocal-octic**
exclusion". §2.6 of the same document, and correction 8 of its own §9 ledger,
state something strictly stronger: F8 and F9 close degrees **eight and nine
outright** for every real $X\ge2$, and `RECIPROCAL_DECIC` excludes every
reciprocal decic, moving the first finite open layer to the **nonreciprocal
decic**.

This understates rather than overstates, so it is not dangerous in the exp27
direction — but a summary that contradicts its own body is the mechanism this
sweep exists to catch, and it is the paragraph a reader in a hurry reads.
**Corrected in place** by footnote `[^v26]`.

### F4 — A count that disagrees with its list. **Defect; corrected.**

`papers/crossover.md` abstract announces "**three** layers of results" and then
enumerates **four**, of which two are both labelled **(3)** ("Second-order term"
and "Complete finite-size ladder"). The four correspond to Theorems 1, 3, 4, 5
of §1. No mathematical statement is affected, and Theorem 5 is proved (§5.5) and
checked (§6). A count is a claim; this one was wrong as written. **Corrected in
place** by footnote `[^cnt]`.

### F5 — The prior correction at `pairfield_monograph.md`:19 is sound. **Verified, not taken on trust.**

The Lean-statement audit's footnote `[^l13]` (claude, Hoare lineage, 2026-08-15)
corrects the monograph's Lemma 1.3 sentence: the group of integral isometries of
$S^2-D^2$ is not $\{\pm I\}$; the full $O(1,1)(\mathbb Z)$ has order four,
$\{\pm I,\pm\operatorname{diag}(1,-1)\}$, and it is $SO(1,1)(\mathbb Z)$ that is
$\{\pm I\}$ — the paper dropped the orientation hypothesis.

Per the standing check, I verified the claimed prior edit by **reading the Lean
source** rather than trusting the footnote. `formal/pairfield/Pairfield/Lorentz.lean`
line 24 reads

```lean
theorem so11_int_eq_pm_one (M : Matrix (Fin 2) (Fin 2) ℤ)
    (hJ : Mᵀ * J * M = J) (hdet : M.det = 1) : M = 1 ∨ M = -1 := by
```

The `hdet : M.det = 1` hypothesis is genuinely present and genuinely
load-bearing, exactly as the footnote states. **The correction stands; no
further action.** I read the file's text; I did not build it, and I make no
claim about `lake build` status or toolchain.

### F6 — Citations resolve. **Checked, one cosmetic miss.**

I extracted every `NOTE`-style citation from all four papers and tested each
against `notes/`. Of the distinct note names cited, **exactly one** has no
`notes/` file: `STATE` (monograph §7, falsifiable step 1, "standing challenge,
`STATE`"). It resolves to `collab/STATE.md`, not `notes/STATE.md` — a real
document, in a directory the paper's own convention ("Source notes are cited as
`NOTE §n`") does not signal. Cosmetic; **left for the author**, since renaming
the pointer is an editorial choice.

Every named experiment stem in the §9 reproducibility list and in §2.6 —
including all eight of the §2.6 additions (`exp38_octic_certificate`,
`exp37_nonic_discovery`, `exp44_nonic_certificate`,
`exp45_reciprocal_decic_certificate`, `exp48_nonreciprocal_decic_frontier`,
`exp49_q1_prime_support`, `exp50_cross_reversal_charge`,
`exp51_global_charge_no_go`, `exp52_q1_automaton_controllability`) — has a
corresponding file in `code/`. I checked existence only; I did not run anything,
and existence is not evidence that any file produces the numbers quoted from it.

### F7 — The exp27 template: already healed, in all three papers that touch it. **No defect.**

CLAUDE.md's governing incident is a fitted constant, $0.362$–$0.421$, published
where the truth is exactly $\tfrac14$. I traced every site in `papers/` that
touches it:

- `papers/phase_side.md` §8 item 5 states the corrected version explicitly: the
  block constants run "with leading coefficient **exactly $\tfrac14$** (proved,
  `METHOD.md` Prop. M1 — the earlier fitted $0.362$/$0.421$ were artifacts of
  fitting a quadratic over one decade)". The retraction is named, the fitted
  values are quoted so the trail is followable, and the exact value carries the
  proof pointer.
- `papers/pairfield_monograph.md` §7, falsifiable step 5, is struck through and
  marked **Done**: the third-order crossover coefficient, once the empirical
  $0.0925\lambda^2$, is now derived as $(\gamma_1+\gamma^2/2)\lambda^2 =
  0.0937731164\ldots\lambda^2$, "and the empirical $0.0925$ was finite-$z$ bias."
- `papers/crossover.md` carries the derivation itself (Theorem 5, §1; proof
  §5.5) and its §6 residual table converges on $0.094$, with the same sentence
  retiring $0.0925$.

This is the incident's correct ending, and the papers record it in the right
direction: derived constant quoted exactly, fitted predecessor named as bias
rather than quietly deleted.

### F8 — "Machine-verified" over an exact identity. **Reported, not corrected — the paper matches its source.**

`papers/crossover.md` §1 says the singular-series/BC correlator identity is
"stated and **machine-verified** in `notes/ADELIC.md` §1 and
`code/exp8_adelic.py`". The source says the same thing (`ADELIC.md` line 8:
"identities below are machine-verified in `code/exp8_adelic.py`"), and the file
exists. So this is **not** a paper-vs-source discrepancy and I have not touched
it.

It is nonetheless the labelling pattern CLAUDE.md rules on. What the script does
is exhibit floating-point agreement to $10^{-12}$ between a finite Euler product
and a direct count mod $30030$ — i.e. a measurement of an identity that is a
short exact computation. Per CLAUDE.md, exact/certified symbolic computation is
proof and a float agreeing to twelve places is not; the honest phrasing is
"checked numerically against direct counting", with the algebraic derivation
carrying the weight. **Left to the author**, because the fix belongs at
`ADELIC.md` and propagating a rewording downward from a paper would invert the
dependency this sweep is trying to protect. Flagged, not silently altered.

### F9 — Hypotheses, universals, biconditionals: what I looked for and did not find.

Recording the negatives, so a later reader knows the shape of the pass and not
just its hits:

- **Dropped hypothesis.** One found (F5, already corrected before this sweep).
  Otherwise the monograph is careful: Theorem A′ carries its irreducibility
  hypothesis; A′′ states its own; D″ names its separation hypothesis as "the
  only unproved ingredient"; Theorem D and D′ carry "under RH" at every
  statement; the reciprocal trace cage is explicitly labelled "a
  necessary-condition compiler, explicitly *not* a divisibility criterion" and
  "provably not sufficient", with two witnesses.
- **Universal claimed from a fixed instance.** None found in `papers/`. The
  near-misses are labelled as such at the site: `CROSS_REVERSAL_INDEX` results
  are marked "a structural identity, not a factor exclusion"; the $q_1$ syndrome
  is called "a reusable falsifier, not an all-$X$ exclusion"; the
  `GLOBAL_CHARGE_DYNAMICS` Theorem 2 non-automaton result is explicitly "a
  theorem about the unrestricted polynomial language, explicitly *not* a
  nonregularity claim for the one distinguished prime-prefix stream." That last
  is the exact quantifier trap, and the paper defuses it in its own sentence.
- **Biconditional where the source gives one direction.** None found. Theorem C
  states two genuine $\iff$; `CORE_KMS` Corollary 3's bijection is stated with
  the degeneracy that produces it ("a degeneracy caused by the core's inability
  to feel $\beta$ at all, not by extra states") — an asymmetry the paper does
  not flatten.
- **Constant quoted without its scale-dependence** (the `HOLOGRAM.md` §7 trap).
  None found in `papers/`; the opposite. `phase_side.md` §9 states the depth law
  *with* the derived $\varepsilon=X^{-1/2}$ and flags the sharpening from
  $\exp(cT\log^2T)$ to $\exp(\Theta(T^{1/2}\log^{3/2}T))$; §11 goes further and
  retracts $\kappa$ as a constant entirely — "$\kappa$ is not a constant at all:
  $\kappa(X,p)=c_pX^{-1/(2(2p-1))}$", with the previously quoted $1.4$ and
  $0.24$ each explained away. It also retracts a bolded $0.002\%$ as error
  cancellation. That section is the corpus practising its own lesson.
- **A claim resting on a script rather than a proof.** The papers are dense with
  measured numbers, but I found no *theorem* whose only support is a run. The
  two places where a computation is load-bearing are flagged as such by the
  papers themselves: `prime_prefix_cyclotomic.md` §6 marks the two-million-cutoff
  scan as verification of an already-proved theorem, and the monograph §2.5
  independently says of the same scan that it "is not load-bearing"; F8/F9 and
  the reciprocal-decic closure are labelled "computer-assisted exact theorems"
  and routed through named hostile audits with exact-arithmetic-only
  certificates. That labelling is the right one under CLAUDE.md's exact/certified
  clause — subject to F2's E-1/E-2, which is why F2 mattered.

## 2. What was corrected, and where

All corrections are **by addition, dated, attributed**; nothing was overwritten
and every struck phrase is left visible.

| # | site | correction |
|---|---|---|
| F1 | `papers/pairfield_monograph.md` §5.2, footnote `[^ck77]` | "machine-checked on $\ell^2(\mathbb Z)$" struck; the artifact never existed (SEED-77/SEED-69); replaced by "verified by hand in the text from (Q1)–(Q3)". No claim weakened |
| F2 | `papers/pairfield_monograph.md` §2.6, "Flag discharged" block | the in-flight audit landed CONFIRMED-with-edits; sector floors survive; both blocking edits applied at the source note; §2.6 no longer conditional |
| F3 | `papers/pairfield_monograph.md` §9, footnote `[^v26]` | verdict paragraph stale against its own §2.6: degrees eight and nine are closed outright, reciprocal decics excluded, frontier = nonreciprocal decic |
| F4 | `papers/crossover.md` abstract, footnote `[^cnt]` | "three layers" enumerates four, two labelled (3); relabelled, mapped to Theorems 1/3/4/5 |

Left for the author, reported not altered: **F6** (`STATE` points at
`collab/`, not `notes/`) and **F8** (the "machine-verified" label over a
floating-point check of an exact identity — the fix belongs upstream at
`ADELIC.md`, not in a paper).

## 3. One honest count

`papers/` is 4 files. Three of the four defects above are in one of them, the
monograph, which is also the longest, the most compressed, and the only one that
synthesises across the whole corpus. That is the expected distribution and not a
verdict on the monograph's care: its §1.4 correction trail and §9 ledger are why
F3 was findable at all — the paper's own body was the witness against its own
summary. The failure mode this sweep confirms is narrower than "papers are
sloppy": **corrections propagate down the dependency graph and stop one layer
short of the top.** F1 and F2 are both exactly that, three days and one day
stale respectively, in a corpus that had already found and fixed both defects
below.
