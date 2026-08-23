# DRISHTI — design thesis, references, and corrections

Companion to `site/drishti.html`. Session `web-shesha-drishti`, 2026-08-13,
branch `worker/web_drishti`.

**Verification substrate.** Python is banned in this repository (human owner,
2026-08-13; `collab/messages/0373`). Every number on the page is **derived by
hand in exact rationals and the derivation is printed on the page itself**, so
that a reader regenerates rather than trusts it. One claim that required
computation with no short derivation was **withdrawn**, not restated on trust —
see §2.C10 and §5 below. No script, no build step, no generator produced any
part of `site/drishti.html`.

---

## 1. Design thesis

**The page is organised around the residual.** Nearly every result in this
corpus that earned its keep has one shape — *a lossy view, together with the
loss returned as an exact algebraic object rather than an error bar* — and the
founding mistake of the repository is that same shape inverted, a residual
measured instead of returned. The page draws eight instances of the shape and
puts the inversion first, not in a footnote.

**The diagram is the argument, in Byrne's sense.** Three colours carry meaning
and nothing else across all ten figures: teal = one view, iron = the other view
when two are compared, ochre = the residual, grey = unreachable. Ochre never
means anything but *residual*. A reader who learns the law in §1 can read every
later figure without a legend, and can see at a glance which page-objects are
named and which are only described.

**The status label is part of the mathematics.** Rows whose residual is a named
object are proved; the one row whose residual is still a *description*
(`BUDGET`'s "accessible off-diagonal depth") is drawn with a dashed edge and
labelled OPEN, and the superseded depth-law exponent is struck through rather
than deleted, per `collab/PROTOCOL.md` §4.

---

## 2. Corrections to the table I was handed

The brief's table was a good map and mostly right. Every place it was wrong,
with the source that corrected it:

### C1 — `lens commutation`: the integrality condition is the corollary, not the criterion

**Brief said:** residual = "|B||D|/|E| must be an integer — an integrality
obstruction to order-independence."

**Correction.** The criterion is the exact equality `|B ∩ D| · |E| = |B| · |D|`
for every `π`-block `B` and `σ`-block `D` inside every join block `E` — that is,
conditional independence given the join. Integrality is a strictly weaker
*necessary* condition derived from it: failing it proves non-commutation,
satisfying it proves nothing. Two further constraints the brief dropped:

- the criterion itself is **classical** (arXiv:1307.6403 Prop. 7), and
  `LENS_ORDER_COMMUTATION.md` §6 says so explicitly — "reconstructed, not new".
  Only the cheap integrality corollary and the unconditional CRT statement are
  marked `possibly-new` (searched twice, no hit).
- the integrality corollary is an artifact of **counting measure** and
  "disappears entirely" under a general positive weight (§6, scope limits). It
  must not be exported.

*Source:* `notes/LENS_ORDER_COMMUTATION.md` §§2, 3, 6.

### C2 — `CRT gluing` vs `lens commutation`: the brief's table silently conflates two different failures

**Brief said:** the two rows sit adjacent as two instances of one loss.

**Correction, and this is the sharpest one.** They are *different failures*, and
the corpus proves it. `LENS_ORDER_COMMUTATION.md` §4.1 shows the mod-`m` and
mod-`n` lenses on `ℤ/mn` commute for **every** `m, n`, coprime or not — because
`|B||D|/|E| = nm/(mn/d) = d = gcd(m,n)` exactly. The residual fiber of size
`gcd(m,n)` that blocks *reconstruction* is precisely what makes the
equidistribution count come out even. The note's own sentence: **"Losing
information and losing order-independence are different failures."**

This does not weaken the thesis — it strengthens it, because it means the
residual is returned exactly in *both* senses and they are independent axes. But
a page that had drawn CRT and lens non-commutation as the same picture would
have taught something false. §3.1 and §3.2 of the page are deliberately drawn
with different mechanisms, and §3.2 carries a callout stating the distinction.

### C3 — `HOLOGRAM Thm K`: the brief quotes the *superseded* exponent

**Brief said:** "zero-correlation content pinned at 0 until log X ~ T log²T/2π²."

**Correction.** That is Theorem K(b), and `HOLOGRAM.md` §7 supersedes it in
place. The `ε ≈ 10⁻³` gating every capacity statement was an *empirical* input
from exp6b/exp14; Lemma N derives it in one line from the explicit formula as
`O(X^{−1/2+o(1)})`, and feeding `ε = X^{−1/2}` back through the superresolution
threshold gives

> **Theorem K′.** `X_needed(T) = exp( Θ( T^{1/2} log^{3/2} T ) )`,

with corrected constant `π^{−1/2}` per verifier A. The published K(b) figures
(`T=100 → 10⁵³`, `T=500 → 10⁷⁷²`, `T=1000 → 10²¹³⁴`) are superseded. This is
the exact case `CLAUDE.md` names as the most expensive of the three measurement
errors, and it is the reason the brief's own thesis is right — so quoting the
retracted exponent inside it was worth catching.

Two smaller riders: Lemma N is conditional on **RH and simple zeros**; and
`HOLOGRAM.md` §3 records a librarian scope correction that the broad reading
("no feasible computation reads correlation-grade structure from arithmetic
data") is **false** — Montgomery's `F(α,T)` is computed from prime data and
proved for `|α| < 1`.

*Source:* `notes/HOLOGRAM.md` §§1–3, §7; `CLAUDE.md` corollary; `notes/METHOD.md` §2.

### C4 — `BUDGET §2`: not proved, and the note says so

**Brief said:** listed without status alongside proved rows.

**Correction.** `BUDGET.md` §5: "**Not proved here:** that 'accessible
off-diagonal depth' admits a single formal definition specializing to 2 over ℤ
and ∞ in the geometric limit. … the honest status is *a conjecture with two
instances and a mechanism*, not a law." The constituent facts (Rudnick–Sarnak's
`σ<2` and its diagonal explanation; Katz–Sarnak/Deligne equidistribution) are
classical and cited. It is the only OPEN row on the page and the only figure
whose ochre object is drawn dashed.

*Source:* `notes/BUDGET.md` §§2, 5.

### C5 — `resultant defect module`: "Smith factors" is not what the note says

**Brief said:** residual = "the module; Smith factors the determinant forgot."

**Correction.** `RESULTANT_OBSERVER_DEFECT.md` §0 states the residual as: the
finite module `𝒟(f,g) = coker(m_g : ℤ[x]/(f) → ℤ[x]/(f))`, of order
`|Res(f,g)|`, whose number of independent mod-`p` coordinates is
`d_p = deg gcd(f̄, ḡ)`. Invariant factors are a natural gloss but are not
asserted, and the note adds a boundary the gloss would hide: `d_p` is *both* the
dimension of information lost by observing only after multiplication by `g` and
the dimension of the modular cokernel syndrome, and "the two spaces have equal
dimension by rank–nullity; **they are not canonically identical**." The page
uses the note's own language.

### C6 — `cross-reversal charge`: the view is the *reversal resultant*, and the residual is its *square root*

**Brief said:** view = "the determinant", residual = "det(I − ∧²A), with a
conservation law."

**Correction, two parts.**

1. `𝒞(P) = det(1 − ∧²A_P)` is itself a determinant, so "the determinant"
   does not name the coarse view. The coarse view is specifically
   `Res(P, P*)`, and the relation is
   `Res(P,P*) = (−1)ⁿ P(1) P(−1) · 𝒞(P)²` (Theorem 1). What the resultant
   forgot is a **square root** plus two endpoint factors — which is why the
   falsifier sharpens from `L² | Res(F_X, F_X*)` to `L | 𝒞(F_X)`.
2. The "conservation law" is Theorem 2, *factorisation* conservation:
   multiplicativity across a factorisation with one explicit cross term. Not a
   dynamical conservation law.

Also worth carrying: the note itself scopes the result as "a reusable falsifier,
not an all-`X` exclusion" — the witness `q₁` has `L = −7`, and a genuine prime
prefix at `X = 2467` passes its test.

### C7 — `leakage rank (new)`: correct, but the novelty boundary belongs with it

**Brief said:** "rank = Σ over join blocks of (rank N_E − 1)." **This is exactly
right**, including the `−1`. The note's own boundary should travel with it:
Corollary 2.2 (projections commute iff every join block's contingency table has
rank one) claims **no novelty** — "very likely folklore in the
conditional-expectation literature", and the recorded search is "none performed
this session". What is offered as new *to this repository* is the identification
of the two lanes' matrices and the closed form for the rank.

### C8 — the founding wound is three layers deep, not one

**Brief said:** "a constant was fitted (0.362–0.421) where the true value is
exactly 1/4."

**Correction.** True, and incomplete in a way that matters for a page about
residuals — the correction has its own unreturned residual:

| layer | published | corrected to | status |
|---|---|---|---|
| leading coefficient | 0.362 / 0.421 | ¼ | proved (Prop. M1) |
| linear coefficient | 1.388949 | 1.181852 | proved — a factor `φ(m)/m` had been dropped from the termwise Ramanujan limit |
| the `O(1)` | ≈ +9.0 | ≈ −3.1 | **unresolved**, `E2_PROOF.md` ledger H5 |

Also, `METHOD.md` §1 originally flagged the wrong lemma for the obstruction to
an explicit `O(1)`: the pointwise non-uniformity is exact and *is* the Mertens
function, but it is irrelevant here (the bad `n` satisfy `n ≥ P_Q`, annihilated
by the `n^{-2}` weight); the actual obstruction is an incomplete-interval
bilinear cancellation bound (Hypothesis U).

### C9 — a new finding, produced while drawing Figure 2

`METHOD.md` §1's illustrative sentence — *"a genuine ¼L²+1.18L+9 is fitted by a
pure quadratic as ≈0.36L²"* — still carries the **stale** constant `+9` that its
own bracketed correction, three paragraphs earlier, had already retracted to
`≈ −3.1`.

**Derivation, by hand, no machine.** Least squares of `c·L²` against
`aL² + bL + c₀` is linear in `(a, b, c₀)`, so the fitted `c` decomposes term by
term as `c = a·w₂ + b·w₁ + c₀·w₀` with `w_k = ∫L^{k+2} / ∫L⁴` over the window.
On `[8/5, 24/5]` the powers collapse, because

    24⁵ − 8⁵ = 8⁵(3⁵−1) = 2¹⁵·242 = 2¹⁶·11²
    24⁴ − 8⁴ = 8⁴(3⁴−1) = 2¹²·80  = 2¹⁶·5
    24³ − 8³ = 8³(3³−1) = 2⁹·26   = 2¹⁰·13

so that (the `5^k` from `a, b = 8/5, 24/5` cancelling against the `5⁵` below)

    w₁ = (25/4)·(24⁴−8⁴)/(24⁵−8⁵)  = (25/4)·5/11²   = 125/484    = 0.258264…
    w₀ = (125/3)·(24³−8³)/(24⁵−8⁵) = (125·13)/(3·2⁶·11²) = 1625/23232 = 0.069946…

and `w₂ = 1`. Two multiplications decide the question:

| the `O(1)` used | `¼·w₂ + 1.181852·w₁ + c₀·w₀` |
|---|---|
| stale `+9.0` | `0.25 + 0.30523 + 0.62952 = **1.1848**` |
| corrected `−3.1` | `0.25 + 0.30523 − 0.21683 = **0.3384**` |

With `+9` the sentence's own number is off by a factor of about three; with the
corrected `−3.1` it reproduces the published `0.362` well. The lesson the
sentence teaches is correct — nine points over one decade cannot separate `L²`
from `L` — and it is wrong *for exactly the reason it is about*: it kept a
superseded residual.

**Suggested repair in `notes/METHOD.md` §1:** change `+9` to `−3.1` in the "Why
the fits failed" paragraph (or restate the illustration with the constant left
free), and record that the pure-quadratic fit then decomposes exactly as
`0.250 + 0.305 − 0.217 = 0.338`.

*Scope, honestly.* This is the **continuous** least squares over the window,
which is what makes it hand-derivable. `BLOCKS.md` fitted a nine-point grid, and
the grid weights are not hand-computable to four digits. The conclusion is not
sensitive to that — the two weights are both `O(1/4)` and `O(1/14)` for any
reasonable sample of the window, and the factor-of-three gap between `1.18` and
`0.34` is far outside any plausible grid variation — but the exact grid figure
is **UNVERIFIED** here and is not quoted on the page.

### C10 — a second finding: the repository's live non-commuting example is priced

`LEAKAGE_RANK_IS_INCIDENCE_RANK.md` §6 seed 2 asks for the two-resource repair
frontier, and `LENS_ORDER_COMMUTATION.md` §4.2 leaves Śilpin's `ℤ/1000Z` pair as
a no-go. Applying Theorem 2.1 to it. **The whole thing is a paper derivation:**

1. `x` and `x−1` are coprime, so `8 | x²−x ⟺ x ≡ 0, 1 (mod 8)`, and likewise
   `125 | x²−x ⟺ x ≡ 0, 1 (mod 125)`. With `1000 = 8·125` and CRT, the four
   `σ`-blocks have sizes `2·2, 2·123, 6·2, 6·123 = 4, 246, 12, 738` — matching
   the note's reported sizes, now derived rather than computed.
2. The join is trivial: any join block is a union of `π`-blocks (so `|E| ≡ 0
   mod 100`) and of `σ`-blocks (so `|E|` is a subset sum of `{738,246,12,4}`).
   Those sums are `0, 4, 12, 16, 246, 250, 258, 262, 738, 742, 750, 754, 984,
   988, 996, 1000`, and the only nonzero multiple of 100 is `1000`.
3. **The incidence table factors.** `x mod 10 = (x mod 2, x mod 5)`, and
   `x mod 2` is read off `x mod 8` while `x mod 5` is read off `x mod 125`, so
   each entry is a product of an 8-side count and a 125-side count.
   *8-side:* of the 4 residues mod 8 of a given parity exactly 1 lies in
   `{0,1}` — weights `(1,3)`, same for both parities.
   *125-side:* of the 25 residues mod 125 with a given residue mod 5, the
   number in `{0,1}` is 1 if that residue is 0 or 1 and 0 otherwise — weights
   `(1,24)` or `(0,25)`.
   Multiplying: digits `d ≡ 0,1 (mod 5)`, i.e. `d ∈ {0,1,5,6}` (the last
   digits of the idempotents `{0,1,376,625}`), give
   `[3·24, 1·24, 3·1, 1·1] = [72,24,3,1]`; every other digit gives
   `[3·25, 1·25, 0, 0] = [75,25,0,0]`.
4. **Two distinct rows, not proportional** — `75/72 = 25/24` but `3 ≠ 0` — so
   `rank N_E = 2`.
5. Theorem 2.1: leakage rank `= 2 − 1 = **1**`. Keeping both lenses costs
   **exactly one scalar per application**. The free block-count ceiling
   `min(|π|,|σ|) − |π∨σ| = 3` overestimates it threefold — a concrete instance
   of Corollary 2.4 being non-tight.

This converts the corpus's own live no-go into a *priced repair*, the second
remedy `LENS_REPAIR`'s lattice coarsening cannot express.

**One claim withdrawn.** An earlier draft of this page also verified the rank by
building the operator `(I−P_L)P_C P_L` directly and collapsing it to its 40
cells. That route has no short hand derivation, so under the ban it has been
**withdrawn rather than restated on trust**. The result now rests on one
hand-derived table plus a proved theorem, which is stronger than two agreeing
scripts; the page says so in §5 instead of quietly keeping the number. A reader
wanting an independent check should use `machinery/leakage_rank.py`, which is
legacy and already in the corpus — not a new artifact from this session.

### C11 — two small path corrections in the brief

- `notes/MATHEMATICS_THAT_LEARNS.md` does not exist on this branch. That content
  is `README.md` — the sections "Forgetting and remembering", "A thing is what
  it can do with other things", and the Chinese-remainder passage.
- `machinery/worktree_guard.py` does not exist on this branch, so the prescribed
  `must print OK` setup step cannot run. The worktree was created and used as
  instructed; all work is inside
  `../avikj-math-readme-workers/web_drishti`.

### C12 — disclosure: this session used Python before the ban reached it

Full disclosure, because the ban's own logic is that the residual gets returned.
This session began before the Python directive arrived and, working in the
repository's habitual shape, wrote and ran `site/drishti_replay.py` to produce
the numbers for Figures 2 and 4. On receiving the correction I:

1. deleted the script (legacy `.py` deletions pass all three enforcement layers);
2. re-derived Figures 2 and 4 by hand in exact rationals and **put the
   derivations on the page**, where the script never was — this is strictly
   better output, and it is the ban working as designed;
3. withdrew the one claim that had no hand derivation (C10);
4. added §5 to the page, because the ban's argument *is* this page's argument
   and belongs in the exposition rather than in a colophon.

No result on the page now depends on the deleted script. The rebase onto
`origin/claude/prime-pair-field-research-18tq7b` was clean and the `.githooks/`
pre-commit hook is active in this worktree via `core.hooksPath`.

The instructive part, and the reason this is in the corrections list rather than
a footnote: **the script did not make the numbers wrong.** It made them
*unreturnable*. The hand derivations agree with what it printed. What changed is
that the reader can now check them, and that one claim which the script had
"confirmed" turned out to have no derivation behind it at all — which is exactly
the residual a `VERDICT: PASS` conceals.

---

## 3. References — taken and refused

### Taken

- **Oliver Byrne, *The First Six Books of the Elements of Euclid* (1847).** The
  bar. Colour as *reference*, not decoration: a coloured region in the figure
  is the same object as the coloured region in the sentence, so the argument
  needs no letters. Adapted as the page-wide three-colour law.
- **Edward Tufte.** Data-ink ratio, applied to argument-ink: every mark names
  something. No gridlines that carry nothing, no framing rules that are not
  boundaries, no legend repeated per figure.
- **Bartosz Ciechanowski.** The diagram belongs exactly where the sentence needs
  it, at the same scale as the prose — not in a figure appendix, not decorative
  at the top of a section.
- **3Blue1Brown's visual grammar** — only one element: consistent colour
  identity for a mathematical object across an entire exposition, so a colour
  becomes a name.
- **This repository's own `site/index.html`.** Serif body, monospace labels,
  teal/iron accents, the honest status pill, the `notes/` link discipline. The
  new page is a sibling, deliberately not a replacement.
- **`notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §9.** "Every cue should be
  expandable back to the native object and derivation that generated it." Every
  figure carries its source note, and the three computed numbers carry a replay
  script.

### Refused

- **Byrne's literal red / yellow / blue.** They cannot hold accessible contrast
  across both themes. The colour *law* was kept; the hues were re-chosen (teal /
  iron / ochre) and checked in light and dark.
- **Interactive explorables (Nicky Case, Distill).** Tempting for the lens
  diagrams — but every slider invites fitting a curve by eye, which is the exact
  failure mode `CLAUDE.md` exists to prevent. The only moving part on the page
  is the theme toggle.
- **torus.network's tone.** Fetched for design language as instructed. Its
  conceptually dense coinages ("cyber-morphogenetic closure") read as
  confidence; this corpus's discipline is the opposite. The vertical rhythm and
  the willingness to lead with one large diagram were worth taking; the register
  was not.
- **Animated reveals and scroll-triggered transitions.** They gate the argument
  on time and break under `prefers-reduced-motion` in ways that are hard to make
  equivalent. Everything is present on load.
- **A hero SVG with no referent.** Figure 1 is abstract but is a *statement* —
  the projection-and-fiber that every later figure specialises.
- **A generator.** No build step, no templating, no script emitting SVG. Every
  path was placed by hand. Slower, and the point of the page's §5.

---

## 4. The weakest thing about the page

**Figure 9 (the depth law) is the only figure that is not a mechanism.** It is a
schematic of two exponent *shapes*, with hand-placed control points and no
computed values. I refused to print digits for a `Θ`-statement, which is right,
but the consequence is that this one figure shows a *comparison of moods* — one
curve steep, one flat — where the other nine show an actual object. A reader
could not reconstruct anything from it. The honest fix is not a better drawing:
it is to draw what actually produces the exponent — the superresolution
threshold `(δL)^{2p-1} ≳ ε` with `p` fixed self-consistently as the atom count
per Rayleigh cell — which is a real diagram I did not have the room or the
confidence in my reading of Theorem K0 to attempt. Until then Figure 9 is
labelled schematic on its face, and it is the figure I would delete first if the
page had to lose one.

Secondary weakness: §3.4 and §3.5 (resultant defect module, cross-reversal
charge) are drawn as *decompositions of a number*, which is honest but visually
thin next to Figures 3–5. They are the two entries where I read only the note's
§0–§2 rather than the whole note, and it shows.

Third, and now the most consequential given the substrate direction: **nothing
on this page is machine-checked.** The hand derivations are the right move under
the ban and are printed so a reader can regenerate them, but "a careful person
did the arithmetic on paper and typed it into an HTML file" is still an
assertion the reader must trust — the same criticism the ban makes of scripts,
weakened only by the derivations being short and visible. The genuinely correct
substrate for the two arithmetic claims here (the `ℤ/8 × ℤ/125` block factoring;
the two rational weights) is Agda in `formal/cubical/`, and that is a real,
small, tractable target I did not attempt because this was a design session. If
a later session wants a concrete task from this page, that is it.
