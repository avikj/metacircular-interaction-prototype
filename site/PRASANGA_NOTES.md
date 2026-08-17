# PRASANGA_NOTES — design record for `site/prasanga.html`

Author: `web-prasanga` session, 2026-08-12. Worktree `worker/web_prasanga`.
Companion to `site/index.html`, which shows the same corpus through its
surviving results. This page shows it through its refutations.

---

## 1. Design thesis

**A corpus you can trust is one that shows you its scars, and every scar names
the theorem it bought.** The page is built so that a reader can follow a single
claim from proposal → refutation → repaired statement → cost → yield, and see
what the kill was worth. It argues the correction trail rather than apologising
for it.

The organising idea is not "transparency" (a posture) but **prasaṅga** (a
method): refutation by consequence, in which you advance no thesis of your own
and instead draw out what the claim entails until it breaks. `PROTOCOL.md` §7
already names "Prasaṅga norms" as house rules — annihilation apparatus shipped
with every headline claim, `pramāṇa` named under every load-bearing step. The
page borrows the frame from the repository rather than importing it.

The second organising idea is that HTML already has the right two elements.
The repo's norm is **correct by strike-through, never delete**. The page is
literally built from `<del>` and `<ins>`, which carry the distinction in the
accessibility tree and not only in colour. Every `<del>` on the page contains a
visually-hidden "struck:" and every `<ins>` a "replaced by:".

## 2. Form

Register: the **critical apparatus of a scholarly edition** — an edition prints
the rejected readings. Narrow measure, marginal sigla in mono, hairline rules,
footnote-density type, warm paper. Sigla (`PROPOSED / REFUTED BY / REPAIRED TO
/ YIELD / PROCESS / AND THEN`) sit in a left gutter separated by a rule, so a
trail is scannable as a sequence of stations before it is read as prose.

Two accent colours only: an oxide **strike** and a deep-ink **repair**. Nothing
else is coloured. Trails are native `<details>` — keyboard-operable, no JS. The
only JS is the theme toggle and expand-all.

Figures: two, both drawn from numbers printed in the corpus.

1. **The exact values that already contained the refutation** — the four
   rational values of `S(Q)` printed in `notes/METHOD.md` §1 beside the fit,
   converging to `0.257780…` against the `0.3613` in use.
2. **The blast radius** — one fitted constant propagating into two notes, a
   paper section, and a round of cross-review before a derivation cut it; with
   the second-order correction found *inside* the correction shown as a dashed
   branch.

## 2a. The closing beat: F32

The ledger's newest entry landed while the page was being built, and it is the
final trail rather than a footnote, because it is the one entry that shows the
ledger is a live instrument and not a curated museum. It also took the most care
to state, because three different things are true of it at once:

- **The theorem stands.** `notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` is correct
  and verified — leakage rank is half the commutator rank, via
  $[P,A]=L^{*}-L$. The page labels it `THEOREM PROVED` and says explicitly that
  it "is not what died here". The note's own novelty position — none claimed,
  likely folklore, *no prior-art search performed*, filed as an open
  obligation — is reproduced rather than smoothed over, because that honesty is
  itself the material.
- **The installation was refuted**, by exact operation counts: 9,413,736 against
  7,895,152 ring operations at $n=6$. Counts, not timings — which is why it is a
  refutation and not a benchmark.
- **The forecast failed in a specific and unusual way.** Registered before
  computing per `PROTOCOL.md` §4, it offered two outcomes as alternatives that
  are in fact compatible, and both occurred. The page states the diagnosis in
  the author's own terms: *the credences were not the error; the outcome space
  was malformed.* This is the subtlest item on the page; I checked it against
  `LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` §4 and message 0372 before writing it.

The second yield — *substrate conditioning*, an artifact shaped like an
installation because the repository's habitual shape is script + note +
message — is given equal weight to the first, since it is what produced a
same-day structural change to how the repository works.

## 3. References — taken and refused

**Taken:**

- *The apparatus criticus of critical scholarly editions.* The whole layout.
  Lemma, then variant readings, then the sigla identifying who reads what.
  This is the one tradition that treats rejected material as first-class
  typography rather than as an appendix.
- *Retraction Watch* (fetched). Taken: the discipline of a **neutral,
  factual register** — the notice states what happened and stops. Taken: the
  bidirectional link between a correction and its site, which is why every
  trail on this page carries a `sources` line naming the exact files.
- *COPE / Nature correction taxonomy* (searched). Taken: the hard distinction
  between **erratum, correction, and retraction**, which maps almost exactly
  onto the corpus's own distinction between a gap-fix (statement survives), a
  refutation (statement dies), and a supersession (statement survives but stops
  bearing weight). Monograph §9 entry 8 makes that distinction explicitly
  ("superseded, not refuted"), so the page keeps it as a separate status label.
- *torus.network* (fetched, per brief). Taken: restraint — one idea per screen,
  no promotional furniture, the "in R&D" honesty of labelling developmental
  work as developmental. Its own copy voice was not taken (see below).
- `site/index.html`. Taken: the status-pill vocabulary and the mono-eyebrow
  section marking, so the two pages read as one repository. Palette
  deliberately not shared — index.html is teal/iron on cool paper; this page is
  oxide/ink on warm paper.

**Refused:**

- *Retraction Watch's naming of individuals and institutions.* Its editorial
  model foregrounds who erred. The brief and the corpus require the opposite:
  external researchers named only neutrally and factually, no claim about any
  person. The R0021 section names no one and says so.
- *torus.network's abstract-visionary voice* ("scale-free, reflexive-autopoietic
  process"). The wrong register for a page whose entire argument is that plain
  statements can be checked. Rick Rubin's receptive posture was taken as a
  working method; none of its vocabulary appears on the page.
- *Stripe Press / Long Now grandeur.* Considered and dropped. Both are about
  durability and stature; this page is about a working scientist writing down
  what went wrong this week. The scale is a lab notebook, not a monument.
- *Self-flagellation-as-marketing.* Explicitly argued against in the closing
  section, on the corpus's own grounds: a walk that has not stated its yield is
  unfinished, so a page of failures without yields would be unfinished work
  dressed as candour. Every entry carries what it bought or it is not on the
  page.
- *Any dashboard, counter, or progress metric.* `FAILURES.md` F24's yield says
  it directly — "do not build another dashboard."

## 4. Where the source material did not support what I wanted to say

Recorded per the brief. Three items, one of them substantive.

### 4.1 The fitted-curve figure I wanted to draw, and did not — SUBSTANTIVE

`notes/METHOD.md` §1 closes with a worked illustration:

> "Over $\log Q\in[1.6,4.8]$ — one decade — a genuine $\tfrac14L^2+1.18L+9$ is
> fitted by a pure quadratic as $\approx0.36L^2$, because the linear term has
> nowhere else to go. Nine points cannot separate $L^2$ from $L$ over one
> decade. This is the whole lesson in one number."

I intended to draw exactly this: the true curve and the best pure quadratic,
indistinguishable over the window. **It does not reproduce as printed.** With
the constant $+9$, the least-squares pure quadratic $cL^2$ through nine evenly
spaced points on $[1.6,4.8]$ has

    c = 1.1346   (nine points, least squares)
    c = 1.1843   (continuum least squares over the same interval)

— not $\approx0.36$. The illustration *does* reproduce if one uses the note's
own **corrected** $O(1)$ residual instead:

    with constant -3.1:  c = 0.3411   (nine points, least squares)

which lands just under the reported $0.362$. The correction to $+9 \to -3.1$ is
made in the same section (struck in place, `METHOD.md` §1), and is exactly the
residual whose provenance the note marks as unresolved (`E2_PROOF.md` ledger
H5) — so the illustrative sentence appears to have kept the pre-correction
constant.

This changes **nothing** about Proposition M1: the leading $\tfrac14$, the
linear coefficient $1.181852$, and the diagnosis (a missing linear term absorbed
into the leading coefficient over one decade) are all untouched. It is a
stale constant inside an illustration.

Action taken: I did not draw the figure. I drew the `S(Q)` convergence instead,
every number of which is quoted verbatim from the note. The arithmetic above is
reported to the corpus in `collab/messages/0380-web-prasanga-correction-trail-site.md`
rather than asserted on the page, since messages coordinate and documents
assert (`PROTOCOL.md` §1), and a website is not the right place to land a new
correction.

### 4.2 "Two notes, a paper section, and a round of cross-review"

The blast-radius figure labels the two intermediate notes as "note ①" and
"note ②" rather than naming them. `CLAUDE.md` states the count and the kinds
but not the identities, and I could not pin both to specific files with
certainty from the sources I read. Naming the wrong file on a page about
correction discipline would have been the obvious own goal. The count is
sourced; the identities are not claimed.

### 4.3 The F28 trail is the vaguest on the page

`FAILURES.md` F28 (cf-vesper) is dense in objects the page cannot introduce
without a page of setup (band mass, the hybrid large sieve, character
orthogonality, $\lambda \le 1+o(1)$). I kept the two checkable numbers — the
lossiness budget $C<3$ and the large sieve's $\pi^4/18 = 5.4116$ failing by
$1.80$ — and paraphrased the rest. A reader cannot verify the paraphrase from
the page alone; they can only follow the `sources` line. That trade is disclosed
here rather than hidden.

## 5. Verification of what is on the page

Every claim was checked against one of: `collab/FAILURES.md`, `notes/METHOD.md`,
`notes/REDTEAM.md`, `CLAUDE.md`, `collab/PROTOCOL.md`, `collab/STATE.md`,
`papers/pairfield_monograph.md` §1.3–1.4/§2.3/§9,
`collab/discovery/claims/R0021-window5-stationary-countermodel.md`,
`notes/FOREST.md`, `notes/BUCHSTAB_LADDER.md`, `notes/BAND.md`,
`notes/KAPPA.md`, `notes/TWO_ADIC_CONFINEMENT.md`,
`notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md`,
`collab/messages/0047-cf-ack-forest-corrections.md`,
`collab/messages/0372-opus-shesha-leakage-is-half-commutator-rank.md`,
`collab/messages/0373-opus-shesha-why-python-is-banned.md`.

No status label appears that could not be found in `notes/` or
`collab/STATE.md`. No number appears that is not printed in a source, except the
contrast arithmetic in §4.1 above, which is not on the page.

**R0021 handling.** Stated with its own preservation ledger, in two explicit
columns: what it establishes (the printed orbit step does not follow from the
inputs listed beside it) and what it does not (it is *not* a counterexample to
the theorem; the arithmetic conclusion is untouched). The packet's real status
is shown — `formalizing`, not load-bearing, novelty requiring external review,
independent audit *open*. No researcher, institution, or journal is named on
the page, and no claim is made about any person. The section says in its own
text why it is there: it is the sharpest test of whether the page's discipline
is real.

## 6. Accessibility and mechanics

- Single file, no network. Verified: zero `http(s)://` references in the file.
- Full light palette on bare `:root`; overrides under **both**
  `@media (prefers-color-scheme: dark){:root:not([data-theme="light"])}` and
  `:root[data-theme="dark"]`. Explicit `body` background token. Toggle sets
  `data-theme` and reports state via `aria-pressed`.
- Contrast measured, not eyeballed. Every foreground/background pair used for
  small text is ≥ 4.5:1 in both themes; `--ink-3` was darkened (light) and
  lightened (dark) after measurement failed at 4.28 and 3.82 against table
  header fill.
- Strike-through is never colour-alone: `<del>`/`<ins>` semantics plus
  visually-hidden "struck:" / "replaced by:" text, plus the line itself.
- `prefers-reduced-motion` disables smooth scroll and all transitions.
- Trails are `<details>`/`<summary>` — native keyboard operation, no JS
  dependency for content access. `:focus-visible` outline throughout.
- Wide content (tables, both SVGs) scrolls inside its own `overflow-x:auto`
  container; `body{overflow-x:hidden}`; verified at 1100px and by construction
  at small widths via `minmax` grids and a single-column station layout below
  620px.
- Semantic heading order, `<title>`, `lang="en"`, `<!doctype html>`.
- Rendered and inspected in both themes (headless Chrome, light and
  `data-theme="dark"`, trails open and closed), and at 400 px width for the
  responsive check.
- **No script was written for this deliverable, in any language.** The page is
  hand-authored HTML/CSS/JS; the only executed commands were `git`, `grep`, and
  a headless-browser screenshot for visual inspection. `machinery/worktree_guard.py`
  (a repository tool, not mine) reports `OK isolated worktree`; its two WARNs
  were memory-anchor and README-visibility declarations, and a journal has been
  added at `collab/journals/web_prasanga.md` to clear the first.

## 7. The weakest thing about this page

**It ships with no falsifier, and its central claim is not the kind of thing
that has one.**

Every other artifact in this corpus is required to arrive with its own
annihilation apparatus — a control, a counterexample generator, a replayable
script. This page's thesis — *a corpus that shows its scars is one you can
trust* — is exactly the sort of unfalsifiable rhetorical claim that
`PROTOCOL.md` §4 exists to block. It could be made, word for word, by a corpus
that showed you eight scars and hid eighty. Nothing on the page rules that out,
and nothing on the page could.

The sharper version, which is the one I would put to a reviewer: **this page is
a compressed centre document**, and F8's yield — which the page itself
prints — is that compressed centre documents need hostile review *more* than
proofs do, because they strip the local verification scaffolding and keep the
authority. This one has had none. It is a single-session summary of forty-plus
ledger entries by an author who verified that the corpus says what the page says
it says, and did not verify that the corpus is right.

Concrete mitigations, all partial: every entry cites its files; no claim appears
without a source that could be opened; the two figures use only printed numbers;
and §4 above lists the places where the material did not support what I wanted.
None of that is a falsifier. The correct next move is the one the corpus would
demand of any other landing — a hostile pass by a different lineage, checking
each trail against its sources and reporting the first place the page overstates.
