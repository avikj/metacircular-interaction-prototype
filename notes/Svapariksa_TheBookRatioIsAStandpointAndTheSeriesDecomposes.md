# स्वपरीक्षा — the book ratio is a standpoint, and the series decomposes

*यो यन्त्रं वदति स स्वयं परीक्ष्यः* — AHIMSA_SUTRA_VISTARA §२८. He who reports
an instrument is himself to be examined. §२८ already carries one run of this
count, in the form कर्तृ-कृति-गणना: *पिङ्गलः द्वाविंशतिः, छन्दःशास्त्रं द्वौ.*
Piṅgala twenty-two, Chandaḥśāstra two. That count is re-run in §6, and it has
moved.

Measured 2026-08-20 11:54 PDT, working tree at `4794facf`. Reproduction
commands in §7. The tree is moving while it is measured — see §3 and the note
at the end of §2 — so every figure below is stamped, not standing.

---

## 1.  What was claimed, and what the instrument reports now

`CLAUDE.md` carried, and called "the single most important fact in this file":

> **the book is currently 15% of this corpus.** 120 files in a chapter, 655 in
> the apparatus.

`machine/Anukramani.hs`, run today, reports **186 reaching a chapter, 740
reaching none — 20%**.

Three things moved, and merging any two of them destroys the finding:

1. **the corpus grew** — 775 source files at the moment the published figure
   was taken, 926 now;
2. **the instrument changed** — on 2026-08-20 the chapter keys were widened to
   include every WORK named in a chapter's ṛṣi line, and `classify` was changed
   from first-match to longest-key-match (`da227e37`, `3c0cd851`);
3. **the published pair was never reproducible from the instrument at its own
   commit** — §3. This one was not previously recorded.

---

## 2.  The grid

Two classifiers × three states of the filesystem. The classifiers are
`classify` as it stood at `f0a9c28c` (first match wins, author keys) and
`classify` as it stands today (longest key wins, work keys added). The file
set is `.agda` and `.hs` under `formal/cubical` and `machine`, which is what
the instrument has always scanned.

| tree | n | old instrument | new instrument |
|---|---|---|---|
| `578cb2fe`, 08-19 17:14 — the file count the published pair was taken from | 775 | 118 (15.23%) | 130 (16.77%) |
| `f0a9c28c`, 08-19 21:58 — the commit that published "15%" | 814 | 121 (14.86%) | 133 (16.34%) |
| working tree, 08-20 11:54 | 926 | 165 (17.82%) | **186 (20.09%)** |

Decomposition of 15.23% → 20.09%, holding one variable at a time:

|  | percentage points |
|---|---|
| corpus growth alone (old instrument, `578cb2fe` → now) | **+2.59** |
| instrument change alone (tree `578cb2fe`, old → new classifier) | **+1.54** |
| interaction | +0.73 |
| total | +4.86 |

Growth is the larger term but neither dominates, and the honest sentence is
that **roughly a third of the movement is the ruler, not the thing measured.**

The same file set scanned forty minutes earlier in the same session held 918
files, not 926. Eight source modules were written by other hands between the
two scans. That is the drift rate; §3 is what it does over five hours.

---

## 3.  The published pair is not reproducible, and the reason is the finding

`git worktree add --detach <tmp> f0a9c28c`, then running that commit's own
`machine/AnukramaniRun.hs` in that tree, prints:

```
  in the book   : 121
  apparatus     : 693
  the book is 14% of this corpus.
```

Not 120 / 655. The commit message and `CLAUDE.md` both say 120 / 655 = 15%.

The file count 775 is reached exactly once in the history, at `578cb2fe`
(2026-08-19 17:14) — four hours and forty-four minutes before `f0a9c28c` was
committed at 21:58. Diffing the 120 chapter paths listed in that commit's
`BOOK_INDEX.md` against the 121 the same program produces on the same commit's
tree gives exactly one extra file. So the index was generated against a
working tree ~4¾ hours behind the commit that shipped it.

**In that window 39 source files were written. Exactly one of them reached a
chapter.** The measurement went stale, and it went stale in one direction,
because in the interval the corpus was gaining apparatus at thirty-eight to
one. The staleness is not noise around the number; it is the number's own
subject, showing up as measurement error.

The next commit, `657bbd4c` — *"the book went from 15% to 14% while we
worked"* — read that drop as growth during the session that followed. It was
already 14% at the moment "15%" was written.

---

## 4.  What the classifier should count, stated so it can be disputed

The instrument scans `.agda` and `.hs` under two directories. `BOOK.md` says
the Agda and Haskell **are the appendix**. So the sentence *"the book is N% of
this corpus"* has, for its whole life, meant: *of the appendix's own files,
what fraction is anchored to a source.* The only way to raise it is to write
more Agda. That is the gradient `CLAUDE.md` exists to oppose, wired into the
one number that reports on it.

This is the compression §२ and §७ of the sūtra name. A naya that does not state
its standpoint becomes a durnaya — not false, but unrefusable, because the
place it speaks from is hidden. *"The book is 15% of this corpus"* asserts
itself as whole. *"20% of the appendix's files name a source in their
filename"* is the same fact with its standpoint returned to it, and it can be
argued with.

**The definition adopted here: report two ratios, never one, each naming its
file set; and bracket each between its lower and upper instrument rather than
publishing a point.** The lower instrument is the filename key — what
`classify` does. The upper is the same keys tested against the file's BODY,
which counts a passing mention and therefore cannot be an undercount.

Keys of length ≥ 7 are used for the body test; short keys like `naya`,
`varga`, `rasa` collide with ordinary English and are excluded. A Haskell run
and a bare `grep -lEi` agree file for file.

| file set | n | filename (lower) | body, ≥9 | body, ≥7 (upper) |
|---|---|---|---|---|
| `.agda`/`.hs` in `formal/cubical`, `machine` | 926 | 186 (20.1%) | 215 (23.2%) | 310 (33.5%) |
| `notes/*.md` | 975 | 37 (3.8%) | 70 (7.2%) | 136 (13.9%) |

**Under all three instruments the appendix is between 2.4× and 5.3× more
source-anchored than the prose, and the prose does not reach the appendix's
LOWER bound under any of them.** The rise from 15% to 20% is a fact about the
appendix. It is not evidence that the book grew.

The two rows are not summed. They carry different measurement error — the
repository's file-naming law puts a Sanskrit term first in a module name, so a
source-anchored module is nearly always visible to a filename test, and there
is no such law for `notes/`. Summing a tight bound with a loose one presents
the loose one as a value.

A third figure is left explicitly unmeasured. `BOOK.md` names three
categories — chapter, apparatus, noise — and the instrument returns two. A
file reaching no chapter is apparatus **or** noise and the instrument cannot
say which. Recording it as "apparatus" is a two-valued verdict standing where
three things live; that undone half is the śeṣa, not a shortfall in the count.

---

## 5.  The flow, which is what actually tracks the gradient

A stock ratio can rise while the pull still points at the appendix, and that
is what happened. Between `578cb2fe` (08-19 17:14) and the working tree today:

| lane | files added | reaching a chapter |
|---|---|---|
| `.agda`/`.hs` | 152 | 57 (37.5%) |
| `notes/*.md` | 33 | 11 (33.3%) |

One source file was removed; no note was.

Two readings, both true, which is why both are here.

**The aim has evened out.** New work in either lane reaches a chapter at about
the same rate, 37.5% against 33.3%, and both are far above the legacy stock
they are averaging into (20.1% and 3.8%). The work written since `f0a9c28c` is
roughly three times as source-anchored as the work written before it, in both
lanes at once.

**The volume has not.** 152 to 33 — four and a half source files per note.
`CLAUDE.md`'s reasoning is unchanged and the gradient it names has not
reversed; it has moved from the aim into the volume, where a single stock
percentage cannot see it. A rate is the wrong instrument for a pull. Files
written per lane is the right one.

---

## 6.  कर्तृ-कृति-गणना, re-run

The cheap check `CLAUDE.md` prescribes: grep `notes/` for the TEXT's name, not
the author's. An author's name propagates through citation; a work's name
appears only when someone attended to the work. Files mentioning, over 975
`notes/*.md`, case-insensitive, Roman and diacritic spellings:

| author | files | work | files |
|---|---|---|---|
| Pāṇini | 46 | Aṣṭādhyāyī | 21 |
| Brahmagupta | 30 | Brāhmasphuṭasiddhānta | 15 |
| Piṅgala | 27 | Chandaḥśāstra | 12 |
| Mādhava | 23 | Yuktibhāṣā / Tantrasaṅgraha | 10 |
| Dharmakīrti | 19 | Pramāṇavārttika / Nyāyabindu | 5 |
| Dignāga | 18 | Pramāṇasamuccaya | 6 |
| Akalaṅka | 10 | Laghīyastraya / Nyāyaviniścaya | 1 |
| Umāsvāti | 7 | Tattvārthasūtra | 9 |
| Fazang | 4 | Huayan / Avataṃsaka / the Golden Lion | 15 |
| Kauṭilya | 0 | Arthaśāstra | 2 |
| Nārāyaṇa Paṇḍita | 1 | Gaṇitakaumudī | 2 |
| Vātsyāyana | 1 | Nyāyabhāṣya | **0** |

§२८ recorded Piṅgala 22 / Chandaḥśāstra 2, and Dignāga 6 / Pramāṇasamuccaya 0.
Today: 27 / 12, and 18 / 6. Piṅgala's ratio went from 11:1 to 2.3:1, and
Dignāga's work is no longer at zero. Those moved because they were written
down, which is the only reason any of these move.

Vātsyāyana is the one source in the corpus whose text has never been named:
one file names him, none names the *Nyāyabhāṣya*. He is not incidental here —
chapter 4's ṛṣi line carries him, and the bhāṣya is where the Nyāyasūtra's
pramāṇa scheme is argued rather than listed.

Four sources invert, naming the work more often than the author: Umāsvāti,
Fazang, Kauṭilya, Nārāyaṇa Paṇḍita. Inversion is what attention to a work
looks like from the outside.

---

## 7.  Reproduction

```sh
# the headline pair, and the prose figure
runghc -imachine machine/AnukramaniRun.hs | tail -30

# the grid: check out the historical instrument beside the current one
git show f0a9c28c:machine/Anukramani.hs   # first-match classify, author keys
git worktree add --detach /tmp/wt f0a9c28c && \
  (cd /tmp/wt && runghc -imachine machine/AnukramaniRun.hs | tail -5)

# the body-key bracket, no Haskell needed
K=$(grep -o '"[a-z]*"' machine/Anukramani.hs | tr -d '"' | sort -u \
    | awk 'length($0)>=7' | paste -sd'|' -)
grep -lEi "$K" notes/*.md | wc -l
grep -lEi "$K" $(find formal/cubical machine \( -name '*.agda' -o -name '*.hs' \)) | wc -l
```
