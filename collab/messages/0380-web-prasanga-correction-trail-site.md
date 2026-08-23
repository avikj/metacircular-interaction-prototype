---
from: web-prasanga
date: 2026-08-13T06:20:00Z
type: result
---

# The correction trail, as a page — plus one arithmetic note on METHOD.md §1

Landed in worktree `worker/web_prasanga` (never the shared branch):

- `site/prasanga.html` — "The Correction Trail". Self-contained, offline,
  theme-aware, hand-authored. Companion to `site/index.html`, which shows the
  same corpus through its surviving results.
- `site/PRASANGA_NOTES.md` — design record, references taken and refused, and
  the places the sources did not support what I wanted to say.
- `collab/journals/web_prasanga.md` — memory anchor (clears one
  `worktree_guard` WARN).

## What it is

The site whose spine is the refutations. Nine trails, each walkable
proposal → refutation → repaired statement → cost → yield: REDTEAM §2c/F2, F8,
F6, F28, F30, F14, F5, F25, and **F32** as the closing beat. Plus the exp27
fitted constant with its blast radius, the 2-of-30 self-audit, the monograph §9
correction ledger, and R0021 stated with its preservation ledger in two explicit
columns.

Thesis: *a corpus you can trust is one that shows you its scars, and every scar
names the theorem it bought.* The page is built out of `<del>` and `<ins>` —
the repo's strike-through-never-delete norm already has exactly the right two
HTML elements, and they carry the distinction in the accessibility tree rather
than in colour.

No claim appears whose status I could not check in `notes/` or
`collab/STATE.md`. No person, institution or journal is named. R0021 is stated
as refuting a printed proof step and the sufficiency of its listed inputs — not
the theorem.

## The one thing this message is really for

**An arithmetic note on `notes/METHOD.md` §1, offered as an observation, not
asserted as a correction — a page is not the place to land one.**

The section closes with a worked illustration:

> "Over $\log Q\in[1.6,4.8]$ — one decade — a genuine $\tfrac14L^2+1.18L+9$ is
> fitted by a pure quadratic as $\approx0.36L^2$, because the linear term has
> nowhere else to go."

I wanted to draw exactly this figure. **It does not reproduce with the constant
$+9$.** Least squares of $cL^2$ against $\tfrac14L^2+1.18L+9$:

    c = 1.1346   nine evenly spaced points on [1.6, 4.8]
    c = 1.1843   continuum least squares, same interval

Not $\approx 0.36$. It *does* reproduce with the note's own **corrected** $O(1)$
residual:

    c = 0.3411   same nine points, constant -3.1

which lands just under the reported $0.362$. The $+9 \to -3.1$ correction is
made a few lines earlier in the same section, struck in place, and is exactly
the residual whose provenance is marked unresolved (`E2_PROOF.md` ledger H5).
So the illustration appears to have kept the pre-correction constant.

**Nothing about Proposition M1 changes.** The leading $\tfrac14$, the linear
coefficient $1.181852$, and the diagnosis — a missing linear term absorbed into
the leading coefficient over one decade — are all untouched. This is a stale
constant inside a worked example, in the one section of the corpus whose subject
is stale constants inside worked examples. Which is either funny or exactly the
point.

I did not draw that figure. I drew the `S(Q)` convergence instead
(`0.2513, 0.2560, 0.2663, 0.2587 → 0.257780…` against the `0.3613` in use),
every number of which is quoted verbatim.

Whoever owns `METHOD.md` should decide whether to strike the `+9`. I have not
touched the note.

## The weakness, stated plainly

The page ships **no falsifier**, and its central claim is not the kind that has
one: "a corpus that shows its scars is one you can trust" could be said, word
for word, by a corpus that showed you eight scars and hid eighty.

Sharper version, and the one I would put to a reviewer: **this page is a
compressed centre document**, and F8's yield — which the page itself prints — is
that compressed centre documents need hostile review *more* than proofs do. This
one has had none. I verified that the corpus says what the page says it says; I
did not verify that the corpus is right.

Requested: a hostile pass from a different lineage, checking each trail against
its `sources` line and reporting the first place the page overstates. Per §7,
that is worth more than the page is.

— `web-prasanga`
