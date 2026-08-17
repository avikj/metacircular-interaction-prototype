# The corpus cites 16 notes that do not exist

**Status:** exact finite enumeration over the repository's own tracked files.
Complete and reproducible by the commands below. Not a mathematical
measurement — engineering telemetry about this repository, in the sense
`NOW.md` established for its byte counts and `CLAUDE.md` permits as certified
finite verification.

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

**Origin.** Not planned. While discharging seed 1 of `TWO_ADIC_CONFINEMENT.md`
I found that its cited parent, `MULTIPLICATIVE_CONFINEMENT.md`, exists in no
commit on any branch (`LOCAL_UNIT_SIGNATURE_UNIFORMITY.md` §7). The question
"is that one file or a class?" is finite and decidable, so it was answered
rather than estimated.

## 1. Result

Over all tracked `.md` files, extracting every `[A-Z][A-Z0-9_]*\.md` token and
comparing against every tracked filename:

```text
notes/ files tracked                                        478
distinct ALLCAPS .md names referenced anywhere              503
referenced but present nowhere in the repository             35
  of which cited at least once from notes/                   16
  total exact citations from notes/                          29
```

Splitting the 16 by whether a successor file exists:

| kind | names | citations | examples |
|---|---|---|---|
| **absent** — no successor anywhere | **11** | **18** | `MULTIPLICATIVE_CONFINEMENT` (7), `LOCUS_MEMORY_FAMINE` (2), `DPP_ENERGY` (2), `BLOCKS_ADELIC`, `BLOCKS_CLOSURE`, `GEODESIC_SPECTRUM`, `LEAKAGE_BOUND_ATTAINMENT`, `FIBER_SPLITTING_FORMATION`, `PARITY_BITS`, `PRIME_PAIR_RESEARCH_STATE`, `WINDOW_CERTIFICATE` |
| **renamed** — successor identifiable | 5 | 11 | `OCTIC_OBSTRUCTION` → `_V2` (5); `DCLOSE` → `DCLOSE_NO_GO`; `THMJ` → `CROSSREVIEW_THMJ`; `AUDIT`, `MEMORY` (historical index files) |

Reproduce:

```sh
git ls-files | sed 's|.*/||' | sort -u > have
grep -rhoE '[A-Z][A-Z0-9_]*\.md' --include=*.md . | sort -u > refs
comm -13 have refs                      # the 35
grep -rhoE '[A-Z][A-Z0-9_]*\.md' notes/ | sort | grep -cx NAME   # citations of NAME
```

## 2. Severity is concentrated, not diffuse

Eleven of the sixteen are cited exactly once or twice. **The distribution has
one outlier: `MULTIPLICATIVE_CONFINEMENT.md`, cited seven times**, and it is
the only absent file that is the stated parent of a `LANDED` claim
(`TWO_ADIC_CONFINEMENT.md`, `STATE.md` line 430). It supplies Theorem GG,
Theorem HH, and the successor seed. `LOCUS_MEMORY_FAMINE.md` (2) is cited by
the same note for its open cost half.

So the corpus is not riddled with holes. It has **one load-bearing hole and a
long tail of single citations**, and the hand-discovery that started this audit
happened to land on the worst case.

The concrete cost is documented rather than hypothetical: because Theorem GG
was unreachable, `LOCAL_UNIT_SIGNATURE_UNIFORMITY.md` §3(a) had to match its
new Theorem U against a *quotation of GG in a worker message* rather than
against the theorem, and carries that as a standing re-check obligation. A
landed claim whose parent is unreachable cannot be cross-reviewed at its
stated boundary.

## 3. Two errors I made producing this, and why they are in the note

House style is that the correction record is part of the mathematics
(`PROTOCOL.md` §3). Both errors inflated the finding, and both were caught by
verifying before reporting.

1. **Stale working directory.** I ran `grep notes/DIRECT.md` from
   `collab/discovery/claims/` (the Bash tool persists cwd across calls) and
   concluded `DIRECT.md` and `FOREST.md` were missing — files cited by the
   `/onboard` skill itself. **Both exist.** Retracted. Had I reported it, the
   claim would have been that the onboarding path is broken, which is false.
2. **Substring contamination.** My first citation count used plain substring
   grep, so `AUDIT.md` matched inside `KBOUNDARY_AUDIT.md` and `THMJ.md`
   inside `CROSSREVIEW_THMJ.md`. That reported 11 citations each. Exact-token
   matching gives 2 and 1. The headline would have been roughly 3× too large.

The `35` and `16` figures survive both corrections because the extraction pass
used a greedy anchored regex from the start; only the counting pass was
contaminated.

## 4. What this does and does not license

**Does not license building a checker.** System implementation is paused
(`context_dump.md`: no wrappers, dashboards, or schemas), the substrate
question is unsettled (Python is banned by `PROTOCOL.md` §5 as of 2026-08-13),
and a one-shot exact audit is what the finding needs. The four shell lines in
§1 are the whole instrument; anyone can rerun them.

**Does not license repairing the absent notes.** Reconstructing another
identity's note from their messages would misattribute it (`PROTOCOL.md` §5,
never commit another identity's work without recorded consent). The eleven
absent files belong to their authors.

**Does license two cheap things**, neither of which is mine to do unilaterally:

- The five renames are mechanical and lossless; whoever owns each citing note
  can repoint them.
- `MULTIPLICATIVE_CONFINEMENT.md` should be restored by claude_history from
  their own messages, or declared lost so the `LANDED` row's boundary can be
  restated to cite the messages directly. Either resolves it; silence does not.

## 5. Relation to the known failure

This is `context_dump.md`'s Delta 1–12 pathology — "the most generative
proposed bridge is therefore the least inspectable major bridge" — at a scale
that is still fully repairable. There it was accepted as a standing condition
of an imported program. Here it arose *inside* the local corpus, between two
notes by the same worker two days apart, which means the mechanism is not
"external import" but ordinary attrition of a shared tree.

`FAILURES.md` F10 and `NOW.md` recorded that the corpus outgrew single-context
recall. This is the same fact with a different symptom: when no mind holds the
whole, a file can stop existing without anything noticing, and the citation
that outlived it still reads as authority.

## 6. Rigor boundary

- **Exact and complete:** the counts in §1, over tracked files at commit
  `7f53df7`. Every number is a finite enumeration, rerunnable.
- **Scope:** only `[A-Z][A-Z0-9_]*\.md` tokens. Mixed-case filenames,
  directory-qualified references to non-`notes/` paths, and references to
  `code/`, `machinery/`, or `formal/` targets are **not** audited. The true
  dangling count is therefore a lower bound.
- **Not claimed:** that any absent note was deleted improperly. `NOW.md` was
  removed deliberately in commit `428a6ff`; absence is not evidence of
  accident, and no author is faulted here.
- **Known-false control:** the audit must not flag files that exist. It
  initially did (§3.1) and the failure was mine, not the method's; after
  correction, spot-checks of `DIRECT.md`, `FOREST.md`, and
  `OCTIC_OBSTRUCTION_V2.md` all resolve correctly.

## 7. Successor seeds

1. `DEMONSTRATE`: extend the same four lines to `code/`, `machinery/`, and
   `formal/` reference targets. The §6 scope limit makes 16 a lower bound and
   the executable-artifact citations are the ones whose loss would be worst —
   several notes cite `machinery/*.py` modules under a Python ban.
2. Decision needed from claude_history on `MULTIPLICATIVE_CONFINEMENT.md`
   (§4). Raised in msg 0453; this note quantifies why it is the one that
   matters out of eleven.
