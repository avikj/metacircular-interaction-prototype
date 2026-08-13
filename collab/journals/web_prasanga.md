# Journal — `web_prasanga`

Design/engineering session. Worktree `../avikj-math-readme-workers/web_prasanga`,
branch `worker/web_prasanga`. Never edits the shared checkout.

## What I carry

The corpus's **correction trail** as a human-facing surface: the site whose
spine is the refutations rather than the results. Deliverable
`site/prasanga.html` ("The Correction Trail"), with its design record at
`site/PRASANGA_NOTES.md`.

Thesis: *a corpus you can trust is one that shows you its scars, and every scar
names the theorem it bought.* The page is built from `<del>` and `<ins>`,
because the repo's norm — correct by strike-through, never delete — already has
exactly the right two HTML elements.

## State

- Page shipped. Nine trails, each walkable proposal → refutation → repaired
  statement → cost → yield: REDTEAM §2c/F2, F8, F6, F28, F30, F14, F5, F25, F32.
- Sections: method (prasaṅga + label semantics + strike specimens), the exp27
  fitted constant with two figures, the 2-of-30 self-audit, the trails, the
  monograph §9 correction ledger, R0021 stated with its preservation ledger,
  and a closing that argues against penance.
- Companion `site/index.html` (surviving results) left untouched.

## Open, for a future instance of me

1. **The page has had no hostile review**, and by F8's own yield a compressed
   centre document needs one more than a proof does. That is the honest
   weakness, recorded in `PRASANGA_NOTES.md` §7. First reviewer should check
   each trail against its `sources` line and report the first overstatement.
2. **`notes/METHOD.md` §1 arithmetic**, reported in message 0380 and not
   asserted on the page: the illustrative sentence "$\tfrac14L^2+1.18L+9$ is
   fitted by a pure quadratic as $\approx0.36L^2$" does not reproduce with the
   constant $+9$ (nine-point LSQ gives $c=1.1346$; continuum $1.1843$). It does
   reproduce with the note's own corrected residual $-3.1$ ($c=0.3411$). Looks
   like the illustration kept the pre-correction constant. Proposition M1 is
   untouched; this is a stale constant inside a worked example.
3. Two identities behind "two notes, a paper section, and a round of
   cross-review" (`CLAUDE.md`) are not pinned to files; the figure labels them
   ① and ② rather than guessing.

## Norms I am bound by that bit here

- No script in any language (human owner, hook-enforced). The page is
  hand-authored; the only commands run were `git`, `grep`, and a headless
  browser for visual inspection.
- Status labels must match `notes/` and `collab/STATE.md`. Nothing appears on
  the page whose label I could not find there.
- R0021 refutes a *printed proof step and the sufficiency of its listed
  inputs*, not the theorem and not anyone's competence. No person, institution
  or journal is named on the page.
