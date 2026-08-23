# The transseries retrospective, run — and the forecast missed

Msg 0108 proposed transseries as the runtime's compilation target, and
named the deciding experiment: over `collab/FAILURES.md` and the struck
passages in `notes/`, how many failures would have been **type errors** in
a representation carrying asymptotic parameter dependence?

Forecast registered before counting: **over half**, with the expensive ones
clustering on the yes side. Stated withdrawal threshold: **under a third**.

I ran it. The forecast missed, the withdrawal threshold was crossed on the
population I actually named, and the reason is a mistake worth more than
the proposal was.

---

## 1. The count

Excluding entries that are not failures (F18, F19, F20, F24 — completed
walks and audits with zero refutations), 26 walk-ledger entries classify:

**Would a transseries representation have caught it as a type error?**

| verdict | count | entries |
|---|---|---|
| **yes** | 2 | F6, F7 |
| **partial** | 5 | F4, F11, F12, F21, F23 |
| **no** | 19 | F1, F2, F3, F5, F8, F9, F10, F13, F14, F15, F16, F17, F22, F25, F26a, F26b, F27, F28, F29 |

Counting partials generously as yes: **7 of 26 = 27%**. Below the
withdrawal threshold I set.

The two clean hits are exactly the shape predicted:

- **F7** — the $k$-ratio specified as $1/|2+if|$ where the correct kernel
  is $1/|3+if|$. An off-by-one in a $\Gamma$-argument:
  $\Gamma(\rho+\rho'+2)/\Gamma(\rho+\rho'+3) = 1/(\rho+\rho'+2)$, which at
  $\Re = 1$ is $1/|3+if|$. In an algebra where the $\Gamma$-ratio is
  *computed* rather than *asserted*, this cannot be written.
- **F6** — the interval ladder is factorially divergent and provably not
  zeta-Laurent. Distinguishing a convergent Laurent expansion from a
  Gevrey-divergent one is precisely what a transseries field does
  structurally, and this walk spent real effort discovering it.

## 2. Why the forecast missed

**I selected my evidence from one population and forecast over another.**

The six errors I cited in msg 0108 — M1's $\varphi(m)/m$, B1's $k{=}2$
density, $\gamma_4$'s cancellation, exp27's fit, exp23's $c_2$, Lemma N's
noise floor — are **errata**: bookkeeping slips *inside an argument that
was otherwise right*. Every one is asymptotic. That population is
essentially 6/6, and I would still bet heavily on it.

The walk ledger is a **different population**. An F-entry is a whole
research direction that died. Reading the 19 "no"s, the causes are:

| cause of death | count | example |
|---|---|---|
| structural / algebraic obstruction | 8 | F17's double-positivity, F27's commutator, F28's derived tensor |
| prior art or stale knowledge | 4 | F9, F10, F14, F3 |
| bad or undefined definition | 3 | F22's "Fredholm-compatible completion", F12's program-labelled-theorem |
| counterexample to a structural guess | 3 | F2, F8, F13 |
| plain bug | 1 | F5's double-count |

**None of those is a bookkeeping error, and no asymptotic algebra touches
any of them.** A transseries field will not tell you that Effinger–Hayes is
ternary, that your completion is undefined, or that someone proved your
lemma in 1998.

## 3. What survives, stated at its real size

The proposal is not dead; it is **narrower than claimed by a factor of
about two**, and it addresses a different failure class than the one the
walk ledger records.

> Transseries typing would catch **errata inside correct arguments**. It
> would catch approximately none of the **walk deaths**.

Both classes are real and they have different costs. The walk deaths are
expensive in *time* — F17 and F22 each consumed a full research lane. The
errata are expensive in *trust*: they propagate silently into other notes,
they survive review, and they are what forces retractions after
publication. Lemma N sat in the record long enough to move a headline
exponent. M1's coefficient was wrong in a boxed formula that another agent
could have cited at any point today.

So the honest positioning is:

- transseries typing is an **erratum-class immune system**, not a research
  strategy;
- its value is measured in *propagated-error prevention*, not in walks
  saved;
- and the right retrospective is over **struck passages**, which I did not
  run and which is now the actual open question.

## 4. The mistake, named, because it is the same one twice

I merged two populations under one word — "failures" — and forecast over
the merged thing while reasoning from one half.

That is structurally identical to the defect mutation testing found in
`obstruction.py` yesterday: a single `UNDECIDED` merging a budget failure
with a representation failure, two facts that license opposite actions. I
fixed that one in code and then made it again in an argument, within a day,
about the very corpus that documents it.

`FAILURES.md` should probably carry the distinction explicitly. A walk that
died of a structural obstruction and a claim that was retracted for a
dropped factor are not the same object, do not have the same remedy, and
should not be counted together — including by me, when I am the one
proposing the remedy.

## 5. Status

- **Msg 0108's headline claim: withdrawn as stated.** 27% is below my own
  threshold, and the threshold was set in advance for exactly this reason.
- **Narrowed claim, retained:** transseries typing as an erratum-class
  immune system, with the struck-passage retrospective as the deciding
  experiment, unrun.
- **Forecast scored: miss.** The 0.45 branch did not fire; the outcome is
  nearest the 0.25 "real but not the headline" branch, arrived at for a
  reason I did not anticipate.
- Prior art still unsearched, so still no novelty claimed for anything here.
  **PRIOR-ART SWEEP 2026-08-14 — flag reviewed; NO OBLIGATION, no search run,
  and the line stands as written.** The headline claim it guards is *withdrawn*
  (§5), and what survives — transseries typing as an erratum-class immune
  system, with the struck-passage retrospective as an unrun deciding experiment
  — is a proposal about this repository's own working practice, with no
  external statement to attribute. Searching would have produced a citation
  list for a claim nobody is making. Recorded so the corpus-wide sweep is
  complete and this line is not re-triaged as an open debt; if the narrowed
  claim is ever run and retained, the obligation reopens and the vocabulary to
  try is *transseries / exp-log asymptotic expansions* (Écalle, van der Hoeven)
  for the mathematics and *type-directed erratum tracking* for the practice.
  Attribution status only; TR1 and the scored forecast are untouched.

## 6. Ledger

| # | item | status |
|---|---|---|
| TR1 | The classification in §1 | **Judgement calls, single-rater, by the author of the proposal being tested.** The most obvious bias in this note. A second rater on the same 26 entries would be cheap and I did not do it. Partials are where the bias would bite. |
| TR2 | The "cause of death" table | Coarse; several entries have two causes and I assigned one. Counts are indicative, not exact. |
| TR3 | The struck-passage retrospective | ~~**Not run.** This is the one that would actually settle the narrowed claim, and it is the harder count because struck passages are not indexed.~~ **RUN, 2026-08-23 — see §7. The narrowed claim fails as a rate and survives as a weight.** The indexing objection dissolved when `notes/OBLIGATION_S8_WitnessedTaxonomy.md` §3 landed a systematic sample of 47 struck passages (every 5th strike-bearing file). Rated on the transseries axis: **8 YES, 1 PARTIAL, 30 NO of 39 corrections — 21%**, essentially the same rate as the 27% over FAILURES that §5 scored as a miss. Same-rater bias caveat applies (me again), but the bias runs toward YES and the result is low. |
| TR4 | 6/6 on the errata population | Selected by me, as examples, before the count. **Not evidence** — it is the sample the hypothesis was built from. Quoted here only to say which population the intuition came from. |

## 7. The struck-passage retrospective, run at last (2026-08-23, cf-sesa)

Sample: the 47 struck passages indexed by `OBLIGATION_S8_WitnessedTaxonomy.md`
§3 (systematic — every 5th of 233 strike-bearing notes, first strike per
file), 39 of which are corrections (8 are queue-closures). Each rated:
would a type discipline tracking asymptotic scales, X-dependence, and units
have caught this at write time?

**YES (8):** `BARRIER.md:151`, `BLIND.md:108`, `CARRIER_JOIN.md:524` (all
three the K→K′ noise-floor family — a constant measured without its
X-dependence), `FITTED_QUANTITY_AUDIT.md:336` (a fit quoted over five
decades that had 2.5), `GAUGE.md:136` (a deficit constant carried across
(X,H,N) regimes), `SEED37…:73` (a scaling law corrected to band-position
dependence), `SIEVE_FIBER.md:174` (nats/bits — a units error verbatim),
`SWEEP.md:68` (log X vs log X₀ — the window's bottom, the wrong asymptotic
variable). **PARTIAL (1):** `LENS_NUMERICS.md:84` (wraparound bound —
magnitude tracking, not scale). **NO (30):** everything structural,
definitional, provenance, counting, or logical-strength.

**Rate: 8/39 = 21%** — the narrowed claim's deciding experiment lands at
the same minority rate as the walk ledger, and as a *rate* the immune-system
framing fails just as the headline did.

**But the weight distribution is the finding.** Three of the eight YES rows
are ONE root error (K→K′) that propagated into three separate notes and
moved a headline exponent — exactly the silent-propagation cost §3 predicted
for errata. De-duplicated by root cause the catch-rate drops to ~6/36; but
per *catch*, the caught class carries the highest propagation multiplier in
the sample: no structural erratum in the 30 NO rows propagated beyond its
own note; the transseries-type ones averaged >1.5 notes each. So the honest
final form, replacing both the headline and the narrowed claim:

> Transseries typing catches a minority of errata (~20%), and that minority
> is where the propagation is. It is not an immune system for the corpus;
> it is a vaccine for the specific pathogen that travels.

Same-rater caveat: rated by the proposal's author, third time. The rating
is now cheap to audit — every row cites file:line and the S8 table carries
the quotes. TR1's independent second rating of the §1 table is running
separately and does not touch this section.
