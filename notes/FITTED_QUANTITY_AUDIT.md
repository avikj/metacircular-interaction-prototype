# The fitted-quantity audit, second pass — D0020 §J7 and the corpus sweep

*Auditor pass, 2026-08-15, commissioned by `collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md`
§J7. Scope as assigned: `notes/` and `collab/upstream/raw/`. **Nothing was computed.**
No Python, no floating-point run, no fit. §4's derivation is algebra applied to
integers and decimals already printed in `notes/DSIDE.md`; that is the same licence
`SEED37_FITTED_CONSTANT_SWEEP.md` §3 used ("testing a derivation against published
tables, nothing recomputed"), and it is declared rather than assumed.*

---

## 0. What this pass is, given that a prior pass exists

`notes/SEED37_FITTED_CONSTANT_SWEEP.md` (SEED-37, 2026-08-14; amended in place by
SEED-100 and SEED-119) already swept **`notes/` and `papers/`** for numerical constants
quoted as results, graded ~50 of them `D`/`V`/`F`/`F!`/`X`, and derived two of them.
That note is good and this pass does not redo it. Re-enumerating its ~50 rows here would
be the audit equivalent of the failure it documents.

What is left, and what this pass does:

1. **`collab/upstream/raw/` was never swept.** SEED-37's coverage ledger (L7) says
   `notes/` and `papers/`. The upstream transmission archive is outside it. **§2.**
2. **~58 notes were added after SEED-37's pass.** **§3.**
3. **SEED-37's live rows were claimed, not verified, to be live.** Standing check:
   verify by reading. **§5.**
4. **One item — SEED-37 row I, self-described as "the highest-value untriaged item in
   the corpus" — is derivable, and I derive it.** **§4.** The answer is not the one
   SEED-37 predicted, and SEED-37 said in its own ledger (L8) that this was the row it
   would bet against itself on. It was right to.

---

## 1. First finding: the prompt's description of §J7 is not §J7's

The task that commissioned this pass described §J7 as flagging "the THIRD occurrence in
five transmissions of a **fitted/measured** quantity presented as if determined."
§J7 reads, in full:

> **(J7) HAZARD, third occurrence of the pattern.** §9's
> $\upsilon(\tau_\star):=\Delta|\!\uparrow_{\kappa_\tau}(\tau_\star)|$ and §3's efficiency
> ratios are quantities **with no stated measure**. They are **not** $\chi_\alpha$ or
> $\rho(D\mathcal K)$ — those two have been shown not to be each other either — but the
> shape is the same. Not to be measured. Define or withdraw.

The flagged defect is **absence of a measure**, not presence of a fit. This distinction
is not pedantry, and getting it wrong would have mis-aimed the whole sweep:

| | exp27 shape | §J7 shape |
|---|---|---|
| what exists | a number | a symbol |
| what is missing | the derivation and the error term | the domain, the measure, the units |
| how it fails | the number is wrong ($0.36$ for $\tfrac14$) | the number does not exist yet |
| remedy | derive the constant | define the quantity, **or withdraw it** |

The §J7 family is the **precursor** of the exp27 family: an undefined ratio with a
trichotomy at $1$ is precisely a fitted constant that has not been fitted yet. That is
why the triage says "not to be measured" — measuring it is the step that would convert
a §J7 defect into an exp27 defect. The three occurrences are counted correctly and the
count is verified in §2.

---

## 2. `collab/upstream/raw/` — swept

**There is not one fitted numerical constant in the entire upstream archive.** I checked
all 30 files (`D0015`–`D0025`, `U0001`–`U0020`) for decimal literals with two or more
places, for percentages, and for the words measured/fitted/empirical/correlation. The
transmissions are symbolic throughout; the only decimals that appear are section
numbers, `CLAUDE.md`'s own $0.362$–$0.421$ quoted back as a warning, and `D0016` §J
referring to what the fleet "measured empirically."

What the archive contains instead is the §J7 family. Enumerated exhaustively:

| # | quantity | site | measure? | disposition on file |
|---|---|---|---|---|
| **T1** | $\chi_\alpha:=\dfrac{\Delta\operatorname{Reach}(\mathcal O_\alpha)}{\Delta\operatorname{Kill}(\Gamma_\alpha)}$, with $\chi\lessgtr1$ trichotomy | D0018 §D, triaged §J5 | none. Neither numerator nor denominator defined | **HAZARD, not to be measured.** Define or withdraw |
| **T2** | $\rho(D\mathcal K)$, $\mathcal K:=\partial\circ\Gamma$, same trichotomy at $1$ | D0019 §C, triaged §J5 | none. No domain, no norm, no linearization, no basepoint | **HAZARD.** Same disposition, plus the obligation to say whether T1 and T2 are the same quantity |
| **T3a** | $\upsilon(\tau_\star):=\Delta\bigl|\!\uparrow_{\kappa_\tau}(\tau_\star)\bigr|$ | D0020 §9, triaged §J7 | none. $|\cdot|$ on an up-set in a closure system with no cardinality bound | **HAZARD.** Define or withdraw |
| **T3b** | §3's "trophic efficiency" | D0020 §3, triaged §J7 | none — and no number is quoted either | **HAZARD**, prospective only |

Three occurrences, three transmissions (D0018, D0019, D0020). **The count in §J7 is
correct.** Note also that §J7 explicitly declines to identify T3 with T1/T2, and records
that T1 and T2 "have been shown not to be each other either" — that non-identification
is on file at `notes/ARCHIVE_FIDELITY_AUDIT.md` §6 and `notes/FILLABILITY_AS_SUCCESS.md`
(scope limit (v)), both of which I read. The archive is internally consistent here.

### 2.1 T3a is derivable, and the derivation is a withdrawal

§J7 says "define or withdraw." The second horn is available in a paragraph, and it is
worth writing because it is the same theorem the corpus already has for `UsefulEscape`.

**Setup, from D0020 §9 verbatim.**
$\kappa_{\tau+1}:=\overline{\kappa_\tau\cup\{\tau_\star\}}^{\,\circ,\otimes,\int,\simeq,\partial,\Gamma}$,
and $\upsilon(\tau_\star):=\Delta|\!\uparrow_{\kappa_\tau}(\tau_\star)|$ — the change in
the size of the up-set of $\tau_\star$.

**Proposition (T3a takes only two values, neither of them informative).**
Let $\kappa$ be closed under a binary operation $\otimes$ and let $\tau_\star\notin\kappa$.
Then the elements $\tau_\star,\ \tau_\star\otimes\tau_\star,\ \tau_\star\otimes(\tau_\star\otimes\tau_\star),\dots$
all lie in $\kappa_{\tau+1}\setminus\kappa_\tau$ unless a relation identifies two of
them. D0020 §0 imposes no relations on $\otimes$ beyond membership closure — $\kappa$ is
defined as the *intersection of all supersets closed under the operations*, i.e. the free
such closure — so no identification is available, and
$|\kappa_{\tau+1}\setminus\kappa_\tau|\ge\aleph_0$. Hence

$$\upsilon(\tau_\star)=\begin{cases}0,&\tau_\star\in\kappa_\tau,\\ \infty,&\tau_\star\notin\kappa_\tau.\end{cases}$$

$\upsilon$ is therefore the indicator of novelty composed with a divergent scale: it is
$\{0,\infty\}$-valued, admits no comparison of two new $\tau_\star$'s, and supports no
threshold. **It is not a quantity; it is a predicate wearing a magnitude.**

**This is not new, and that is the point.** It is `notes/ADVANCE_CONJUNCTS_DEFINED.md`
Theorem U (`UsefulEscape` has no non-vacuous definition in $\mathscr L_{\mathrm{Chu}}$)
in a different vocabulary, and D0020 §J6 already observes that §9 poses "the same
question." A successor should **cite Theorem U and withdraw $\upsilon$**, not define it.
The only route to a real-valued $\upsilon$ is the one Theorem U identifies: a fixed
universal machine and a description length $L$ — at which point the D0019 §J6 invariance
caveat binds (only *differences* at fixed $\mathfrak L$ are meaningful, since $L$ is
defined up to an additive machine constant).

**X-dependence.** Vacuously scale-free: $\upsilon$ has no scale because it has no
measure. But this is the precise sense in which a number without its $X$-dependence
"looks like knowledge": had anyone measured $\upsilon$ on a *finite truncation*
$\kappa_\tau^{(n)}$ of the closure, they would have obtained a finite number growing
without bound in $n$, and reported it as a constant. The finite-truncation reading is the
trap, and it is the `HOLOGRAM.md` §7 trap exactly.

### 2.2 T3b — trophic efficiency

The ratio is not given a number in the archive; §3 names it in a run of standard ecology
alongside generalised Lotka–Volterra. **The theorem it would stand in for does not exist
and is not a theorem of this corpus:** trophic transfer efficiency is an *empirically
measured* ecological quantity (Lindeman's "10 % law"), with a spread across ecosystems of
roughly an order of magnitude, no closed form, and strong dependence on ecosystem, taxon
and measurement protocol. The correct disposition is therefore neither "define" nor
"derive" but **out of scope**: it is external empirical science, and importing it as a
mathematical constant would be an $X$-dependence failure of the worst kind, since the
"$X$" is *which ecosystem was measured*. Flagged so no successor derives it.

---

## 3. Notes added after SEED-37 (~58 files) — swept

Read by pattern (decimals with $\ge2$ places, measured/fitted/empirical/observed/
correlation) and then read in body for every hit. **Result: the post-SEED-37 layer is
essentially clean, and conspicuously so.** Roughly two-thirds of these notes carry an
explicit line of the form "*Nothing computed. No Python, no numerics, no fitted constant,
no correlation*" in a scope-limits or honesty section
(`CHANGING_TESTS_VERSUS_SHRINKING.md`:549, `COHERENCE_AND_FLOW_SLOTS.md`:489,
`EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`:610, `ORDINAL_LADDER_SMALLNESS.md`:501,
`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`:489, `FILLABILITY_AS_SUCCESS.md`:292,
`LAX_TRANSLATION_REPAIR.md`:19, `MYSTERY_AND_DESCRIPTION_LENGTH.md`:5,
`PRIME_PAIR_KERNEL_VERIFIED.md`:20, `OBSTRUCTION_COEND_REPAIR.md`:581,
`NAT_TRACE_DESCENT_BRIDGE.md`:232, `D0019_LEDGER.md`:427, `FOUR_REPAIR_MODES.md`:196,
`CENTRE_AND_YANG_BAXTER_DEFECT.md`:377, and others). The `CLAUDE.md` mechanism is working
in this layer.

Four hits survived reading. Two are exemplary and are recorded as the reference set; two
are live.

### 3.1 Exemplary — recorded so the shape is on file

- **`notes/HITTING_TIME.md` §3, "The measured gap."** A table of combined hitting times
  for $x=p^e$, $p\in\{3,5\}$, $e\le5$. The note says: solo column $p^e$ **proved**;
  combined column "the data is consistent with linear growth in $e$ … **but I have not
  proved any upper bound for the combined rule and do not claim the rate**"; §4 files it
  under "*Checked computation only*" and lists $O(e\log p)$ under "*Conjectured,
  explicitly not claimed*." The qualitative theorem ($12<243$) rests on an exhibited path
  and a proof, not on the table. **This is what a legitimate table looks like: the rate
  that a fit would have produced is named and refused.**
- **`notes/ARCHIVE_FIDELITY_AUDIT.md` §6.** States that its own recall is
  **unmeasured** ("a defect invisible from inside … is undetectable by this method and
  its rate is unmeasured. The five sites found are a lower bound"), and that its
  denominator (53) "is a choice … the count is not comparable to another pass's."
  A count with its frame declared.

### 3.2 **Live, N1** — `notes/ATTACK_SET_CALIBRATED.md` §2.2: "false-positive rate 1 in 2"

**The claim.** The inscription-check screen "has a **false-positive rate of 1 in 2 on the
flagged pairs of that sweep** … Any statement of the ninth attack that omits *then read
it* is **statistically 50 % wrong on its own alarms**."

**The theorem it stands in for.** There isn't one, and there cannot be — which is the
finding. The quantity is $\Pr[\text{0 \% retention} \mid \text{not an overwrite}]$, and
the note's own §2.2 derives the *mechanism* correctly and completely: a zero-retention
signature is produced by a preserving branch merge (`DELTA17_SPLIT_TORUS_AUDIT.md`,
$443=242+201$ lines, both headers, no conflict markers) exactly as it is by a destroying
overwrite. Once that is known, the "rate" is not a property of the instrument at all: it
is **the ratio of merge events to overwrite events in the commit window swept**, which is
a fact about this repository's branching on 2026-08-14 and about nothing else.

**Derivation available, and it is short.** From `collab/messages/0754`, as quoted in the
same section: 1953 candidate ordered pairs, **2** flagged, **1** genuine. So the numerator
and denominator are $1$ and $2$. The Clopper–Pearson 95 % interval for $1/2$ at $n=2$ is
$[0.013,\,0.987]$: the measurement excludes nothing. **"Statistically 50 % wrong" is not a
statistic.** The honest statement, which the note is one sentence away from making, is:
*the screen's alarms are not self-certifying, because the signature is provably
non-discriminating; therefore read every alarm, whatever the rate.* That statement is a
theorem (it follows from the mechanism), it is $n$-free, and it supports the note's own
prescription — *screen, then read* — strictly better than the numeral does.

**$X$-dependence: severe, and partially declared.** The note does scope it ("on the
flagged pairs of that sweep"), which is more than exp27 did. But it then de-scopes it one
sentence later into "statistically 50 % wrong on its own alarms," which reads as a
property of the method. The rate scales with the repo's merge/overwrite mix and with the
sweep window; it has no limit as the window grows, and it is not a constant.

**Disposition.** `DEMONSTRATE`→**withdraw the numeral, keep the mechanism.** Replace
"false-positive rate of 1 in 2" with the non-discrimination lemma. Costs nothing;
strengthens the section. Downstream: `ARCHIVE_FIDELITY_AUDIT.md` §6 already cites the
numeral ("measured the numeric screen at one false positive in two alarms") — and, to its
credit, immediately says it "read every alarm rather than counting them," which is the
mechanism reading. Two sites, one edit each.

### 3.3 **Live, N2** — `notes/COST_GEOMETRY.md`: stipulated weights presented next to measured ones

`COST_GEOMETRY.md`:92 states plainly: "*Stipulated, not measured: W2's weights*", and
:96 proposes redoing it "with honest measured weights." The declaration is correct and
present. The residual hazard is only that :63 replays "the repo's measured edge" in the
same table as the stipulated weights without a column separating the two provenances.
**No numeral is wrong; no derivation is owed.** Filed as a presentation item, not a
defect, and explicitly *not* escalated. Recorded because a future sweep will hit the word
"measured" here and should not have to re-read the file.

---

## 4. SEED-37 row **I** derived — `DSIDE.md`'s $-2.208$ is not a missing lower-order term

SEED-37 row I called this "**the highest-value untriaged item in the corpus**" and its
§5(I) recommended the next block derive a new lower-order arithmetic term, predicting the
$D$-side analogue of Theorem F's $-\tfrac14$. Its ledger L8 said row I was the one claim
"a single page of algebra could overturn." **This section is that page.** The prediction
does not survive; the gap is an error-term artifact and no new arithmetic is owed.

**The claim under audit** (`notes/DSIDE.md`:52): a global fit over 32 values
$h\in[10,3\cdot10^4]$ at $X=10^6$ gives
$\mathrm{Var}/h=0.983\log(X/h)-2.208$ against the predicted $1.000\log(X/h)-2.415$;
"the fitted constants within $0.07$–$0.21$ of $-(\gamma_E+\log2\pi)$; … consistent with
the known lower-order terms."

**Step 1 — the per-$h$ column is not an independent measurement of $B$.** The note's own
table gives, per $h$, a measured/predicted variance ratio $r$ and a "fitted $B$." Since
the model is $\mathrm{Var}/h=L+B$ with $L=\log(X/h)$, and the predicted value is
$L+B_{\mathrm{pred}}$, a measured ratio $r$ gives $\mathrm{Var}/h=r(L+B_{\mathrm{pred}})$,
hence **exactly**
$$\boxed{\ \Delta B\;=\;B_{\mathrm{meas}}-B_{\mathrm{pred}}\;=\;(r-1)\,\bigl(L+B_{\mathrm{pred}}\bigr).\ }$$
Check against the printed table, $X=10^6$, $B_{\rm pred}=-2.41516$:

| $h$ | $L$ | $L+B$ | $r$ printed | $(r-1)(L+B)$ | $\Delta B$ printed |
|---|---|---|---|---|---|
| $10^2$ | $9.2103$ | $6.795$ | $1.010$ | $+0.068$ | $-2.348-(-2.415)=+0.067$ |
| $10^3$ | $6.9078$ | $4.493$ | $1.034$ | $+0.153$ | $+0.153$ |
| $10^4$ | $4.6052$ | $2.190$ | $1.006$ | $+0.013$ | $+0.012$ |

The identity reproduces the $B$ column to the printed digits. **The "fitted $B$" column
carries no information the ratio column does not.** It is the ratio column multiplied by
$L+B$, an $h$- and $X$-dependent amplifier. Quoting both as two agreements is
double-counting one measurement.

**Step 2 — the amplifier is the whole story of the "$0.07$–$0.21$" spread.** With $r-1$
of order the note's stated per-point accuracy ("verified to 1–3 % per point") and
$L+B\in[2.19,\,6.80]$ over the tabulated range, $|\Delta B|$ ranges over roughly
$[0.02,\,0.20]$ *with no arithmetic input whatever*. The quoted spread "$0.07$–$0.21$" is
that interval. It is not evidence about $B$; it is the variance accuracy read through a
lens whose magnification is $\log(X/h)+B$.

**Step 3 — the note's own displayed error term already covers it, with zero fitted
parameters.** `DSIDE.md`:44 displays the RH error as
$O\bigl(h^2\log^2X+hX^{1/2}\log^2X\bigr)$ against a main term $hX(L+B)$. The relative
size is
$$\frac{h\log^2X}{X(L+B)}+\frac{\log^2X}{X^{1/2}(L+B)}.$$
At $X=10^6$, $\log^2X=190.9$, $X^{1/2}=10^3$:

| $h$ | first term | second term | total bound | observed $|r-1|$ |
|---|---|---|---|---|
| $10^2$ | $0.0003$ | $0.0281$ | $2.8\%$ | $1.0\%$ |
| $10^3$ | $0.0043$ | $0.0425$ | $4.7\%$ | $3.4\%$ |
| $10^4$ | $0.0872$ | $0.0872$ | $17\%$ | $0.6\%$ |

**Every observed deviation lies inside the note's own unconditional-given-RH error bound,
at every $h$.** No missing arithmetic term is required, and none is detectable: the data
cannot see a lower-order term until it exceeds the $hX^{1/2}\log^2X$ floor.

> **Proposition I.** At $X=10^6$ the constant $B$ in
> $\mathrm{Var}(X,h)\sim h(\log(X/h)+B)$ is not determined by the `DSIDE.md` data to
> better than $\pm\bigl(\log(X/h)+B\bigr)\cdot\varepsilon_{\rm RH}(X,h)$, where
> $\varepsilon_{\rm RH}=h\log^2X/X+\log^2X/X^{1/2}$; numerically $\pm0.19$ at $h=10^2$
> and worse elsewhere. The observed $-2.208$ is consistent with $-2.41516\ldots$ and is
> **equally consistent with anything in $[-2.6,-2.2]$**. The measurement has no power to
> discriminate a lower-order term at this $X$.
>
> **Corollary (the $X$-law, which is the load-bearing part).** The dominant error is
> $\log^2X/X^{1/2}$, independent of $h$. To pin $B$ to $\pm0.01$ requires
> $\log^2X\,(\log(X/h)+B)/X^{1/2}\le0.01$, i.e. $X\gtrsim10^{10}$–$10^{11}$ — four to
> five orders of magnitude beyond the run. **Any refinement of $B$ below $X=10^{10}$ is
> reading noise.** This is `HOLOGRAM.md` §7 in its exact form: the constant was measured
> at one scale and its precision, not its value, is what carries the $X$-dependence.

**Consequences.**
1. SEED-37 §5(I)'s recommended task — derive the $D$-side analogue of Theorem F's
   $-\tfrac14$ — **should not be undertaken as a way of closing this gap.** The
   derivation may be worth doing for its own sake; it will not be confirmed or refuted by
   these data, and a successor who "closes three notes at once" against $-2.208$ will
   have fitted a lower-order term to an error bar. That is exp27's mechanism F1 with an
   extra step.
2. `DSIDE.md`:52's "consistent with the known lower-order terms" is, as SEED-37
   suspected, an unearned reassurance — but for the opposite reason. It is unearned
   because it is *unfalsifiable at this $X$*, not because a term is missing.
3. Row I moves from `F`/`V` to **`V` (closed)**: the measurement verifies the derived
   $B$ to within its own derived, $X$-dependent precision, and the precision is now
   written down.

**Honesty ledger for §4.** The identity in Step 1 is exact algebra. The table check uses
the three $r$ and three $B$ values printed in `DSIDE.md`; I recomputed nothing and ran
nothing, and the agreement to the printed digit is the evidence that I read the note's
model correctly, not evidence about $\zeta$. Step 3 uses the implied constant in the
$O(\cdot)$ as $1$, which is the standard abuse; if it is $10$ the conclusion strengthens,
if it is $1/10$ the $h=10^3$ row becomes marginal and the corollary's threshold rises by
one order. **I have not read `code/exp*` for the $h$-spacing of the 32-point global fit**,
so the global-fit intercept $-2.208$ is treated only through the per-point identity;
a slope–intercept covariance argument would give a second, independent account of the
same $0.207$ (least squares forces $\hat b-b=(a-\hat a)\bar L+\overline{\text{resid}}$,
and $(1-0.983)\bar L\approx0.13$ for log-spaced $h$, $\approx0.07$ for linear), but it
depends on the spacing and I do not assert it.

---

## 5. SEED-37's live rows, verified by reading (not by trusting)

Standing check: claimed prior edits must be verified by opening the target.

| SEED-37 row | claimed state | **verified today** |
|---|---|---|
| **A** — $C/D=1.44$, forced correction (i) | "still unapplied at `papers/phase_side.md`:25,98" | **CONFIRMED STILL UNAPPLIED.** `:25` reads "$C/D=1.44$ (the measured Poisson-separation input)" inside a sentence headed "*closes with explicit constants*" — no band, no grade, and the parenthetical calls it measured while the sentence calls it explicit. `:98` repeats "the measured linearity $E(\eta)=C\eta$ ($C/D=1.44$)". **Live for a third pass.** (`papers/` is outside this pass's assigned scope; re-flagged, not edited.) |
| **A** — `BLOCKS.md`:409 "over five decades" | "struck at its site by this pass" | **CONFIRMED APPLIED.** `:409` now reads "~~over five decades~~ **over the $\sim2.5$ decades where statistics exist**". The strike is real. |
| **C** — $\approx680\,Q$ slack | live `F`, "the shortest open `PROVE` item this sweep found" | **CONFIRMED LIVE.** `LENS_NUMERICS.md`:46 still reads "Asymptotic waste of the bound: a constant $\approx680\,Q$". No error term, no $X$-dependence, and the object is the looseness of one Cauchy–Schwarz step — so it is not a constant of the problem at all. **This is still the shortest open `PROVE` item, and it is now the shortest one, since §4 removed row I from the queue.** |
| **I** — `DSIDE.md` $-2.208$ | live, "highest-value untriaged" | **DERIVED AND CLOSED — §4 above.** |
| **U** — `INDRA_CROSS.md`:158 $-0.0139$ | live `F`, needs a noise floor | **CONFIRMED LIVE.** `:158` still reads "the measured total is $-0.0139$ with no log-growth anywhere," with no comparison scale. Fix is one clause: state $N^{-1/2}$ for the atom count used, as `BLOCKS.md`:285 does. A null without a comparison scale is not a null. |
| **W** — $\approx0.49$ discrepancy level | live `F`, "needs the $T$-dependence written (F2 risk)" | **PARTIALLY REFUTED — SEED-37 was harsh here.** `INTERVAL_DISCREPANCY_MEAN_SQUARE.md`:146 does state its scale ($X=10^7$), does give the competing extremal law ($0.166$ at that $X$), does say the observed level is governed by neither the extremal law nor the mean square, and does name the crossing height ($10^{141}$) and mark the reconciliation **OPEN**. The $X$-dependence is written. Downgrade `F`→`V`-with-open-question. |

---

## 6. Score, and what this pass claims

- **Upstream archive:** 0 fitted constants; 3 occurrences of the §J7 undefined-quantity
  pattern, count verified; 1 of them (T3a) derived to a withdrawal via an existing
  corpus theorem; 1 (T3b) ruled out of scope as external empirical science.
- **Post-SEED-37 notes:** 2 exemplary, 1 live (N1, `ATTACK_SET_CALIBRATED.md`'s
  $1$-in-$2$), 1 presentational (N2). The layer is clean and the reason is that the
  notes in it declare their own emptiness of numerals.
- **SEED-37 carryover:** rows A(paper half), C, U confirmed live by reading;
  A(`BLOCKS.md` half) confirmed applied; W downgraded; **I derived and closed.**
- **The number that mattered most turned out not to need a new theorem.** The lesson of
  §4 is narrower and harder than "derive the constant": *before deriving the constant,
  derive the precision*. `DSIDE.md`'s $-2.208$ was never a wrong number. It was a number
  quoted to three decimals by an instrument with a resolution of $0.2$, next to a
  prediction quoted to five.

## 7. Scope limits

1. **`papers/` was not swept** — it is outside the assigned scope
   (`notes/` + `collab/upstream/raw/`) and SEED-37 covered it on 2026-08-14. The one
   `papers/` line I opened, `phase_side.md`:25,98, I opened only to verify a SEED-37
   liveness claim, and I did not edit it.
2. **`collab/messages/` was not swept.** 781 files. `0754`'s counts are used only as
   quoted inside `ATTACK_SET_CALIBRATED.md` §2.2, which I read; I did not open `0754`
   itself, so §3.2's numerator and denominator ($1$ of $2$; $1953$ candidates) rest on
   that quotation and not on the source. Stated because it is exactly the
   inscription-check failure the section is about.
3. **`code/` was not read.** §4's ledger records the one place this bites (the 32-point
   fit's $h$-spacing), and §4's conclusion is stated so as not to depend on it.
4. **Method.** Grep to seed, then read. Every hit reported above was read in body. Grep
   alone would have returned 321 files in `notes/` and would have missed §2 entirely
   (the transmission hazards contain no numerals) and §4 entirely (the defect there is a
   *missing* error term, which has no lexical signature). Conversely, constants stated in
   prose without digits are not covered, as SEED-37 L7 also declared.
5. **Nothing was computed.** No Python — and running one to check a constant would have
   been the error under audit. No Agda or Lean authored; nothing typechecked.
   $\chi_\alpha$ and $\rho(D\mathcal K)$ are untouched: not defined, not measured, not
   estimated, not identified with each other or with $\upsilon(\tau_\star)$.
6. **No transmission mathematics was edited.** The archive's own transcription warning
   applies: `D0020` declares itself display-incomplete, and §2's enumeration is an
   enumeration of *this archive*. A hazard absent from the archive is not thereby absent
   from the owner's original. **Reported as an absent display, not concluded from.**
