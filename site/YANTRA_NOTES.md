# YANTRA — design notes

Companion to `site/yantra.html`. Author: `web-yantra` (Claude Opus 5),
2026-08-13. Page read at commit `51f87df`, stamped 2026-08-13 05:20Z.

## Thesis

The single most unusual true thing about this repository is that it is awake
right now: seven minds across three model lineages, in separate worktrees,
coordinating through nothing but files. Every research site I looked at is a
mausoleum — finished claims, past tense, the mess swept out — so the form
followed from the one fact the mausoleum shape cannot hold: **build the page as
an instrument reading a nervous system, and make its honesty about its own
reading the thing that distinguishes it.** The board is the hero, the retraction
trail sits at equal weight to the results, and the page says in three separate
places that it is a frozen snapshot, because a dashboard that *looks* live is
exactly the artifact this corpus has learned to distrust.

## What the form had to obey

`notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §9 is the design law, and it is not a
style rule — it is the repository's own constraint on perception: *every
perceptual cue should be expandable back to the native object and derivation
that generated it*, and must never become a second source of truth. Everything
on the page follows from taking that literally:

- every board card carries `README.md:<line>` and its journal path;
- every quotation is verbatim and names its file and section;
- the dial's encoding is spelled out in full, including its distortion (the
  radial axis has an offset origin — the inner ring is 0 h, drawn as a ring
  rather than a point, because otherwise seven heartbeats inside seven hours
  collapse into an unreadable blob). The colophon says outright that the dial
  is the element on the page you should trust least, and the numbers printed
  beside it are the reading.

The status labels obey `collab/PROTOCOL.md` §6: PROVED / RETRACTED / REFUTED
are taken from the status line of the note carrying the proof, not restated in
my own words. Where a note says "no novelty claimed, recorded search: none
performed", the page quotes that sentence rather than paraphrasing it away.

## References, and what I took from each

Fetched and studied (public pages only; nothing from this repository went out
in a query, per PROTOCOL §8):

- **torus.network** — the collaborator project the owner pointed at. Took: the
  centred generative form as the page's one visual anchor, and the small honest
  status label ("In R&D") worn openly rather than hidden. **Refused:** the
  unfalsifiable-visionary register ("scale-free, reflexive-autopoietic process
  for the expansion of life into cyberspace"). This repo's binding rule kills
  that sentence on contact; the biological metaphor survives on my page only
  where it is literally true — seven processes with heartbeats and a takeover
  clock.
- **distill.pub** — took the principle that the figure and the argument are one
  object, and the visible peer-review apparatus. **Refused:** its bespoke
  typographic system; a single offline file cannot carry it, and imitating it
  at low fidelity reads worse than not trying.
- **longnow.org/clock** — took the idea that duration should be rendered as
  *mechanism* rather than as a number ("acorns knowing that I will never live
  to harvest the oaks"). The 24-hour takeover clock is on the page as a rim you
  can see people sitting inside, not as a field labelled "last updated".
- **worrydream.com** — took the reverse-chronological archive whose ordering is
  itself the argument, and the wry first-person register that treats the reader
  as a peer. The line "You never know who's still awake" is the closest thing I
  found anywhere to what this repository actually is.

Rejected without fetching, deliberately: the research-lab-landing-page genre
(hero claim, logo wall, three benefit cards). It is the mausoleum shape with
better kerning, and this project has 543 messages of evidence that its real
texture is argument, retraction and repair.

## What I killed along the way

The first build of this page was produced by a generator — a Python script that
parsed the board with the repository's own validator, counted the files, drew
the dial and stamped the output; deterministic, offline, byte-identical across
runs. Four minutes before I finished, commit `51f87df` banned scripts at three
enforcement layers, on the argument that *a script that prints a number is an
assertion the reader must trust*. The generator was deleted and the page
rewritten by hand. I think the ban is right and the page is better for it: what
replaced the script is not less rigour but more provenance — every figure now
names the file and the command that re-derives it, which is what a reader
needed anyway and what the script's output was silently standing in for.

That episode is on the page as section 02, because it is the best available
demonstration of the thesis: the thing interrupted its own documentation.

Two earlier casualties worth recording: an initial dial encoding mapped angle
to elapsed time, which collapsed four near-simultaneous heartbeats onto one
point and made the fleet look like a single mind — a figure that lied. And a
first pass rendered board fields with only their first physical line, silently
truncating every carried question mid-sentence. Both were caught by looking at
the rendered page rather than the markup.

## Snapshot vs. live — the honest list

**Nothing on this page is live.** It is one static file with no fetch, no
polling, and no self-updating timestamp.

| Element | Source | Status |
| --- | --- | --- |
| Board cards, dial, heartbeats, ages | `README.md` lines 62–115 | snapshot, frozen 05:20Z |
| Commit table (18 rows) | `git log`, rendered in UTC | snapshot, frozen at `51f87df` |
| Counts of notes / messages / journals / identities | `ls -l` sums, `git rev-list --count` | snapshot, exact at read time |
| "2 of ~30 experiments earned their keep" | `notes/METHOD.md` §2 | quoted from the note |
| Retractions, yields, both results | `notes/`, `collab/FAILURES.md` | verbatim quotation |
| Status labels | status line of the note carrying the proof | verbatim, not restated |
| All framing prose, section titles, the reading of the commit table | me | editorial |

The stamp is 05:20Z rather than the HEAD commit time (05:04Z) because 05:20Z is
the latest timestamp appearing anywhere in the data reported, and ages measured
against an earlier clock would have come out negative. That choice is stated on
the page.

Refreshing the page means a person re-reads the seven sources above and edits
the file. At the commit rate visible in the table — fifteen commits in fifty
minutes — the board section will be wrong within the hour. The page says so.

## Known weaknesses

1. **It rots, fast, and by hand.** No build step means no `--check` gate; the
   next reader has no automatic signal that the board is stale beyond the
   timestamp. Mitigated only by making the timestamp loud and repeated. This is
   not hypothetical: between reading the board and pushing this branch — about
   twenty minutes — `README.md` gained twelve lines above the board and every
   line citation moved. The citations are therefore pinned as
   `README.md@51f87df:<line>`, and the page says on its face that this happened.
2. **The seven board cards are transcription.** I re-read them against
   `README.md` after writing, but a typo in a carried question would be
   invisible to any check.
3. **The dial's offset origin is a real distortion.** Disclosed, but disclosure
   is not the same as being undistorted, and a reader skimming the shape
   without reading the caption will over-read the polygon's size.
4. **One-lineage view.** I read Claude-lineage notes more closely than Codex
   ones; the board is balanced but the two featured results are both Opus.

## Technical

Single file, ~1,100 lines. Inline CSS and one 20-line inline script (theme
toggle, three states, persisted). Zero occurrences of `http` in the file: no
fonts, no CDN, no images, no links out. Works offline. Full light palette on
bare `:root`, overridden under both `@media (prefers-color-scheme: dark)
{:root:not([data-theme="light"])}` and `:root[data-theme="dark"]`; `body` has an
explicit background token. `prefers-reduced-motion` disables the one animation
(a slow pulse behind live markers) and smooth scrolling. All text/background
pairs check at ≥ 4.5:1 in both themes. Semantic headings h1→h2→h3 in order,
skip link, `:focus-visible` rings, table captions, the SVG carries
`role="img"` with a `<desc>` that states the figure's reading in words. Wide
content (dial, tables) scrolls inside its own container; the body never scrolls
horizontally.
