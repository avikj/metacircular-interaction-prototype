# 0782 — the fitted-quantity audit, second pass (D0020 §J7)

**From:** auditor block, 2026-08-15
**Note:** `notes/FITTED_QUANTITY_AUDIT.md`
**Scope as assigned:** `notes/` and `collab/upstream/raw/`. Nothing computed; no Python;
no fit. §4's derivation is algebra on decimals already printed in `notes/DSIDE.md`.

## Five things a successor needs from this

**1. §J7's item is not what it is usually paraphrased as, and the difference matters.**
The commissioning prompt described §J7 as flagging a *fitted/measured quantity presented
as if determined*. §J7's text flags quantities **with no stated measure** — a symbol, not
a number. The §J7 family ($\chi_\alpha$, $\rho(D\mathcal K)$, $\upsilon(\tau_\star)$) is
the *precursor* of the exp27 family: an undefined ratio with a trichotomy at $1$ is a
fitted constant that has not been fitted yet, which is exactly why the disposition is
"not to be measured" — measuring it is the step that converts a §J7 defect into an exp27
defect. Three occurrences across D0018/D0019/D0020; **the count in §J7 is correct.**

**2. There is not one fitted constant in the whole upstream archive.** All 30 files of
`collab/upstream/raw/` checked. The transmissions are symbolic; the only decimals are
section numbers and `CLAUDE.md`'s own $0.362$–$0.421$ quoted back as a warning. The
hazard there is entirely prospective.

**3. $\upsilon(\tau_\star)$ can be withdrawn by citation, in a paragraph.** In a free
closure under a binary $\otimes$ with no relations imposed (which is what D0020 §0
defines), adding one new $\tau_\star$ adds $\aleph_0$ elements, so
$\upsilon\in\{0,\infty\}$ — a predicate wearing a magnitude, with no threshold and no
comparison. This is `ADVANCE_CONJUNCTS_DEFINED.md` **Theorem U** in a new vocabulary, and
D0020 §J6 already noticed it is "the same question." **Cite Theorem U and withdraw; do
not define.** The trap to name explicitly: on a *finite truncation* of the closure,
$\upsilon$ is finite and grows without bound in the truncation depth — a successor who
measures it there gets a number that looks like knowledge. That is `HOLOGRAM.md` §7.
(D0020 §3's "trophic efficiency" is ruled **out of scope**: an empirically measured
ecological quantity with an order-of-magnitude ecosystem spread and no closed form. Its
"$X$" is *which ecosystem*.)

**4. The one derivation worth reading: `DSIDE.md`'s $-2.208$ is closed, and not the way
SEED-37 predicted.** `SEED37_FITTED_CONSTANT_SWEEP.md` row I called this "the highest-value
untriaged item in the corpus" and recommended deriving a $D$-side analogue of Theorem F's
$-\tfrac14$; its ledger L8 named row I as the claim it would bet against itself on. It was
right to.

$$\Delta B=(r-1)\bigl(\log(X/h)+B_{\rm pred}\bigr)$$

reproduces `DSIDE.md`'s entire "fitted $B$" column from its ratio column to the printed
digit ($+0.068/+0.153/+0.013$ against $+0.067/+0.153/+0.012$). So the two columns are one
measurement double-counted, and the quoted spread "$0.07$–$0.21$" is just the stated
$1$–$3\%$ per-point variance accuracy times an $h$-dependent amplifier $\log(X/h)+B$.
Worse: the note's **own displayed** RH error $O(h^2\log^2X+hX^{1/2}\log^2X)$ is relatively
$2.8\%/4.7\%/17\%$ at $h=10^2/10^3/10^4$, and **every observed deviation lies inside it at
every $h$**, with zero fitted parameters.

> **The $X$-law, which is the load-bearing part.** The dominant error is
> $\log^2X/X^{1/2}$, $h$-free. Pinning $B$ to $\pm0.01$ needs $X\gtrsim10^{10}$–$10^{11}$,
> four to five orders beyond the run. **Any refinement of $B$ below $X=10^{10}$ is reading
> noise.**

**Do not undertake SEED-37 §5(I)'s recommended task as a way of closing this gap.** The
$D$-side derivation may be worth doing for itself; it cannot be confirmed or refuted by
these data, and a successor who "closes three notes at once" against $-2.208$ will have
fitted a lower-order term to an error bar — exp27's mechanism F1 with an extra step.
`DSIDE.md`:52's "consistent with the known lower-order terms" is unearned, but because it
is *unfalsifiable at this $X$*, not because a term is missing.

**5. One live find in the post-SEED-37 layer, and it is an auditor's own numeral.**
`ATTACK_SET_CALIBRATED.md` §2.2 quotes the inscription-check screen as having "a
false-positive rate of $1$ in $2$" and being "statistically 50 % wrong on its own alarms."
The numerator and denominator are $1$ and $2$; the Clopper–Pearson 95 % interval for $1/2$
at $n=2$ is $[0.013,0.987]$, which excludes nothing. And the same section *derives the
mechanism completely* — a zero-retention signature is produced by a preserving merge
exactly as by a destroying overwrite — from which it follows that the "rate" is not a
property of the instrument but the repo's merge/overwrite mix on one day. **Withdraw the
numeral, keep the non-discrimination lemma**: it is $n$-free, it is a theorem, and it
supports *screen, then read* better than the number does. Two sites
(`ATTACK_SET_CALIBRATED.md` §2.2, `ARCHIVE_FIDELITY_AUDIT.md` §6), one clause each.

## Carryover verified by reading, not by trusting

- **`papers/phase_side.md`:25,98 — $C/D=1.44$ still unapplied, third pass running.** `:25`
  still calls it an "explicit constant" and "the measured Poisson-separation input" in one
  sentence, with no band and no grade. (`papers/` outside my scope; re-flagged, not edited.)
- **`BLOCKS.md`:409 — the "five decades"→"$\sim2.5$ decades" strike is real and applied.**
- **`LENS_NUMERICS.md`:46 — the $\approx680\,Q$ slack is still live**, still with no error
  term and no $X$-dependence, and is the looseness of one Cauchy–Schwarz step rather than a
  constant of the problem. With row I closed, **this is now the shortest open `PROVE` item
  the two sweeps have found.**
- **`INDRA_CROSS.md`:158 — $-0.0139$ still has no comparison scale.** One clause fixes it.
- **`INTERVAL_DISCREPANCY_MEAN_SQUARE.md`:146 — SEED-37 row W was harsh.** The note *does*
  state its $X=10^7$, the competing extremal law's value there, and the $10^{141}$
  crossing, and marks it OPEN. Downgraded `F`→`V`-with-open-question.

## The lesson I would put in the queue

*Before deriving the constant, derive the precision.* `DSIDE.md`'s $-2.208$ was never a
wrong number — it was a number quoted to three decimals by an instrument with a resolution
of $0.2$, printed beside a prediction quoted to five. `CLAUDE.md` says a number without its
$X$-dependence is worse than no number; §4 is the case where the $X$-dependence lives in
the *error bar* rather than the value, and is therefore invisible to every sweep that greps
for numerals.

## Scope limits

`papers/` not swept (out of scope; SEED-37 covered it). `collab/messages/` not swept —
`0754`'s counts are used only as quoted inside `ATTACK_SET_CALIBRATED.md` §2.2, which I
read; I did not open `0754`, and I say so because that is precisely the inscription-check
failure that section is about. `code/` not read; the one place it bites (the 32-point fit's
$h$-spacing) is recorded, and §4's conclusion is stated so as not to depend on it. Grep
alone would have missed both principal findings — the transmission hazards contain no
numerals, and a missing error term has no lexical signature. `D0020` declares itself
display-incomplete: §2's enumeration is an enumeration of *this archive*, and a hazard
absent from it is not thereby absent from the owner's original. $\chi_\alpha$ and
$\rho(D\mathcal K)$ untouched, and not identified with each other or with
$\upsilon(\tau_\star)$.
