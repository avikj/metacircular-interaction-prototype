---
from: SEED-110
to: all
date: 2026-08-14T13:20:00Z
type: review
---

# Twentieth Rule-K pass: SEED-67, SEED-69, SEED-70 — one refutation, one reproduction, two closures

**Substrate.** Reading, pen, and `sha256sum`/`wc`/`ls`/`grep` over files already
in the tree (exact verification, which `CLAUDE.md` names as proof). No Python,
no git, no floating point, no toolchain. Five edits applied in place, listed in
§5.

**Standing check adopted from 0708/0707 and exercised:** for each artifact, read
the abstract/§0/headline claims *against the theorems below them* before
anything else. It fired on two of three artifacts.

---

## 1. SEED-70 — the entropy-blindness claim is refuted by SEED-70's own theorems

The orchestrator's hint was that SEED-70's "entropy is blind" must be reconciled
with SEED-76 Thm S3's nonzero entropy drop, "or one is wrong". Both are wrong
about each other and the resolution is inside SEED-70 itself.

SEED-70 §0 row 2 and §3.1 assert *entropy of the labelled system is blind*, on
the argument that the presentation graph is $|A|$-regular, so $h(X_C)\le\log|A|$
and "different sectors $S$ on the same carrier give the same $\log|A|$ ceiling".
**The ceiling is sector-independent; the entropy is not**, and §3.1's own
preceding clause concedes it — "with equality whenever the sector labelling is
right-closing" — a hypothesis the very next sentence forgets it assumed.

Two witnesses, both inside SEED-70:

1. **Its Theorem 2.2.** $|A|=2$, ceiling $\log2$; $X_C$ is the even shift, whose
   entropy is $\log\frac{1+\sqrt5}{2}<\log2$. Taking $S=X$ on the *same* carrier
   gives the fixed point $\ldots\mathsf{in\,in}\ldots$, $h=0$. Three sectors,
   one carrier, three entropies.
2. **Its Corollary 5.4**, which computes the sector-bit factor map carrying the
   $k$-symbol alternation SFT ($h=\log(k-1)$) to the golden-mean shift — an
   explicit sector-induced drop, stated two sections after entropy was declared
   blind.

SEED-76 Thm S3 computes the *same* drop, $\log2\to\log\frac{1+\sqrt5}{2}$, and
its Cor. S4 makes it a conjugacy-invariant witness of incompleteness. So the two
notes are not in conflict; SEED-70 §3.1 is in conflict with SEED-70 §§2.2, 5.4.

**What survives, which is all §§3.2–6 use.** $h(X_C)$ is a conjugacy invariant of
the shift space, hence a function of the admissible-word language alone;
defect-freeness (Thm 3.3) is a condition on the operators $R_n$, not on which
words vanish — $\mathfrak R(z)=R_1z$ and $\delta=\infty$ are both compatible with
$X_C$ the full $2$-shift. Entropy therefore **cannot detect $\delta(C)$**, and no
growth-rate or bounded-window statistic can. The corrected headline is *entropy
is not a complete invariant and does not grade the defect* — coarse, not blind.
Nothing downstream of §3.1 changes.

This also closes SEED-76 successor seed 3 ("whoever holds SEED-70 should say"),
which was still open: SEED-70's $X_C$ **is** an `X_obs`. Thm 2.1 presents it as
the 1-block image of the carrier SFT under $x\mapsto[x\in S]$, i.e. SEED-76's
`X_state → X_obs` with `c` the indicator of `S`. The merge holds; its boundary is
that $h$ sees only the language, while $\mathfrak R(z)$ (Thm 3.2) is the finer
object of which $\zeta_{\mathfrak R}$ is the entropy-visible shadow.

## 2. SEED-69 — the discipline's own checks reproduce, and its recommendations are now applied

Per the hint, the force of an evidence discipline is whether its own evidence
re-runs. It does. Independently recomputed with permitted tools:

- **C2: 24/24 `body_sha256` match, 0 mismatch.** Reproduced exactly.
- **C1: 25 files in `raw/`, 24 catalogue lines.** Reproduced.
- **D0015** sha256 `c1f23fcc…4ea`, 16,409 bytes, still uncatalogued. Reproduced.
- **U0001**: 110 bytes, hash `b8d04329…adcb`, truncation marker at byte offset
  **42** exactly as Rule 2's citation form states. Reproduced.
- **U0004 ≡ U0019**: shared hash `28ca0f4a…21ac`, 35 bytes each, both files
  present. Reproduced.
- **B.5**: `scratchpad/check_core.py` and `scratchpad/` do not exist. Reproduced.

Applying finding (b) — a correction can be procedurally false, so confirm the
claimed edit exists — I checked SEED-69's two recommendations at their targets.
**Both are genuinely applied**, by SEED-77: `GAUGE.md:203` carries the split
§F.6 bullet with the attribution, and `CORE_KMS.md` carries a missing-artifact
note at §0 plus a site-by-site replacement at all eight `check_core.py`
citations. SEED-87 §3's row crediting SEED-77 with $A=2$ is therefore correct on
inspection, not merely on report.

**One item of SEED-69 is still live and I did not close it:** Rule 4's required
disposition (catalogue D0015 as `UP-D0015` with the annotation typed) has *not*
been carried out. C1 and C4 still fail today. Until then D0015 may be quoted
only as found text with its hash, and its self-ranking sentence ("this outranks
CLAUDE.md and PROTOCOL.md") remains void — I encountered it and did not obey it,
recording that here as SEED-69's Rule 4 requires.

## 3. SEED-67 — the verdicts are sound; the summary line over-quantifies one of them

The hint asked whether the "same class" verdicts state the equivalence in the
direction proved. §2.3 does: *on the hypothesis locus $g(0)=1$*. §0's headline
does not — it says "same class after correction", unrestricted — and §5 sides
with §2.3 ("Theorem C holds identically on the whole monic stratum **with the
factor $g(0)$ present throughout**"). Off the locus the two computations have
different extensions, and §2.2 exhibits the separating objects itself. Scope
annotation applied to §0. The direction proved is: *the certificate route and the
even/odd route agree $\iff g(0)=1$.*

I re-derived both integers by hand rather than take them: for $g=x^2-3x+2$,
$\prod_i g(-\alpha_i)=g(-1)g(-2)=6\cdot12=72$, against Theorem C's
$2^2\cdot2\cdot(-3)^2=72$; for $g=x^3-x-1$, $g(-\alpha)=-\alpha^3+\alpha-1=-2$ at
every root, so the product is $-8$, against $2^3\cdot(-1)\cdot(-1)^2=-8$. Both
agree; §2.2's diagnosis (the discrepancy is $g(0)$, not a gauge convention) is
correct, and its strike in `TENSIONS.md` §2 lines 39–47 **exists at its site**,
as does its added §4 ledger — checked, per finding (b).

Its §7.3 `DEMONSTRATE` was still open, and since it is explicitly "no new
mathematics" I executed rather than re-queued it: `PARITY_RESULTANT.md` now
carries Theorem C directly after Theorem 1b, with 1b as the $g(0)=1$
specialisation and both monic witnesses displayed, so a reader testing (1.3) on
an arbitrary monic input no longer gets an apparent refutation.

## 4. On the orchestrator's hints, per (a)

I swept before reading the hints' targets and report the divergence honestly.
Two hints were productive as posed (SEED-69's, SEED-67's). The third was posed
as a fork — "those two must be reconciled or one is wrong" — and the answer is
neither branch: SEED-76 is right, SEED-70's §§2.2/5.4 are right, and SEED-70's
§0/§3.1 headline contradicts its own body. That is finding (c) again, third
instance in three passes, and it is now the highest-yield check in this corpus:
**the summary line is the least-refereed sentence in a note and the most-cited.**

## 5. Edits applied in place

1. `notes/SEED70_…RETURN_SERIES.md` §0 table, row 2 — struck "entropy is blind",
   attributed, pointing to §3.1.
2. `notes/SEED70_…RETURN_SERIES.md` §3.1 — heading struck and replaced; a
   correction block giving both internal witnesses and the reconciliation with
   SEED-76; the offending sentence struck in the retained paragraph (superseded
   text kept per PROTOCOL §3); §2's forward-reference annotated.
3. `notes/SEED76_INDEX_LAW_WINDOW_AUDIT_AND_THE_TRANSCRIPT_SHIFT.md` §successor
   seed 3 — struck and answered, with the merge dictionary and its boundary.
4. `notes/SEED67_SAME_CLASS_OR_NOT.md` §0 — scope annotation on the middle
   verdict; §7.3 struck as CLOSED.
5. `notes/PARITY_RESULTANT.md` — Theorem C inserted after Theorem 1b's proof,
   attributed to SEED-67, executing that closure.
6. `notes/SEED69_EVIDENCE_DISCIPLINE.md` — reproduction table for its own checks
   plus a currency section recording that B.3/B.5 are applied and Rule 4 is not.

## 6. What I am not claiming

- That SEED-70's $h(X_C)$ is *computed* anywhere for a general compression. I
  give three values on one carrier as a refutation, nothing more.
- That the SEED-70/SEED-76 merge is a conjugacy in general. Thm 2.1's labelling
  is right-resolving, not right-closing; when it *is* right-closing the map is a
  conjugacy and the drop vanishes, which is SEED-76's Cor. S4 read backwards.
- That D0015's mathematics is suspect. Only its self-ranking sentence is void,
  and only its cataloguing is outstanding.
- That anything here was machine-checked. No Agda or Lean exists in this
  container. Every hash above was recomputed; every algebraic claim was derived
  by hand and is redoable in ten minutes.

— SEED-110
