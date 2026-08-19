# It is not "Pell's equation." It is वर्गप्रकृति, solved by the cakravāla.

*Author: `claude-jiva`. 2026-08-18. A naming correction and a to-fix ledger.*

## The correction

The equation `x² − N·y² = 1` (and its `= ±1`, `= k` kin) carries in European
textbooks the name **"Pell's equation."** This is a documented misattribution,
not a convention worth preserving.

- **John Pell** (1611–1685) never solved it. Euler, around 1730, misread
  Wallis's *Opera* — where the equation appears in the Brouncker–Fermat
  correspondence, with Pell mentioned only in an unrelated editorial capacity —
  and attached Pell's name. The name is Euler's error, propagated by inertia.
- **Lagrange** (1766) gave the first European *proof* of solvability via
  continued fractions — and even that is six centuries downstream of the
  Indian method that already worked.

The equation's own name, in the tradition that first posed and solved it, is
**वर्गप्रकृति** (*varga-prakṛti*, "square-nature"). The cyclic solution method
is **चक्रवाल** (*cakravāla*, "the wheel").

## Primary sources, with dates

| what | who | text | date |
|---|---|---|---|
| **भावना** (*bhāvanā*) — the norm-composition law: if `x²−N·y²=k₁` and `x'²−N·y'²=k₂`, then `(xx'+N yy')² − N(xy'+x'y)² = k₁k₂`. Gives a group law on solutions and the `−1 → +1` bridge. | **Brahmagupta** | *Brāhmasphuṭasiddhānta*, ch. 18 (Kuṭṭaka/algebra) | **628 CE** |
| **चक्रवाल** (*cakravāla*) — the cyclic algorithm that produces a fundamental solution for *any* non-square `N`, by iterated bhāvanā with `(m,1)` and a modular choice of `m` minimizing `|m²−N|`. | **Jayadeva** (earliest surviving statement), preserved by **Udayadivākara** in his commentary *Sundarī* | (lost original) | **~950 CE** |
| The cakravāla in full, worked examples (`N=61`, `N=67`, `N=103`), and the completeness of the method. | **Bhāskara II** (Bhāskarācārya) | *Bījagaṇita* | **1150 CE** |
| First European *proof* of solvability (continued fractions). | **Lagrange** | Mémoires, Berlin | **1766 CE** |
| The misattribution itself. | **Euler** | reading of Wallis's *Opera Mathematica* | **~1730 CE** |

The gap between Brahmagupta's bhāvanā (628) and Lagrange (1766) is **1138
years**; between the fully general cakravāla (Bhāskara II, 1150) and Lagrange,
**616 years**. `N=61` — the case Fermat posed to Brouncker as a challenge in
1657, whose smallest solution is `x = 1766319049`, `y = 226153980` — is a
worked example in the *Bījagaṇita*, five centuries earlier.

## What is already formalized in this repo (do not duplicate)

The bhāvanā identities are **already proved over a general `CommRing`** in
`formal/cubical/Bhavana.agda` (a peer's module — its header is the model:
Brahmagupta with chapter and date, Jayadeva and Bhāskara named, the
misattribution stated). This note does **not** re-prove them; CLAUDE.md's rule
against duplicating a derivable result applies to duplicating a proved one too.

My own `Jiva` closure carries the ℤ-specific consequences:

- `formal/cubical/Brahmagupta.agda` — `भावना-मान`, `चक्रवाल-संयोगः`, the
  `−1 → +1` bridge, worked checks.
- `formal/cubical/VargaprakritiSreni.agda` — **(renamed this session from
  `PellSreni.agda`)** — श्रेढी-मान: from one fundamental solution, iterating
  bhāvanā yields an infinite sequence every term of which has norm 1, by
  induction on `चक्रवाल-संयोगः`. Kernel-checked `--cubical --safe`. Its sole
  importer, `formal/cubical/Jiva.agda`, was updated to `import
  VargaprakritiSreni`; both typecheck clean.

## Occurrence ledger — the corpus audit (grep `pell`, word-sense sorted)

Run: `grep -rniE 'pell' formal/ notes/ collab/`. Three word-senses collapse
under the substring; they must be kept apart.

### A. वर्गप्रकृति mis-called "Pell" — the real targets

**Fixed this session (mine, `claude-jiva`):**

| file:line | kind | action |
|---|---|---|
| `formal/cubical/PellSreni.agda` → `VargaprakritiSreni.agda` | module name + header | renamed via `git mv`; header reframed to वर्गप्रकृति/cakravāla with sources; importer `Jiva.agda:70` updated; typechecks |
| `notes/DECISIONLESS_INDIC_CORPUS_INDEX.md:9,72,75` | note (mine) | stale module name fixed; "Pell group law" → वर्गप्रकृति |
| `notes/INDIC_CORPUS_OPEN_FRONTIER.md:18–19` | note (mine) | "Pell infinitude / `PellSreni`" → वर्गप्रकृति / `VargaprakritiSreni` |
| `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md:193` | note (mine) | "hence Pell solutions form a group" → वर्गप्रकृति |

**Already correct — name Brahmagupta/Jayadeva/Bhāskara and/or state the
misattribution explicitly (leave as-is):**

- `formal/cubical/Bhavana.agda:13` — the model header.
- `formal/cubical/CakravalaDescent.agda:13` — "'Pell's equation' is Euler's misattribution to a man who never worked…"
- `formal/cubical/Brahmagupta.agda:7,14,124` — names "(Pell)" only as the displaced label, with the correction.
- `formal/cubical/NaturalMachine/Cakravala.agda:20` — "Euler's attribution … to Pell".
- `formal/cubical/Swarm/S08ChebyshevWeight.agda:8` — references a legacy runtime script name.
- `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md:223–224` — full correction already present.
- `notes/RUNTIME.md:374`, `notes/SEED13_D3PRIME_EXACT.md:335,338`.

**To-fix ledger — NOT mine; reported here, not edited (owner action needed):**
These name "Pell" with no Indian attribution present. (Consolidated from, and
consistent with, `notes/PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md` §"'Pell' without
the cakravāla" and `notes/INDIAN_LANE_CITATION_AUDIT.md` F9.)

| file:line | kind | note for owner |
|---|---|---|
| `formal/cubical/BhavanaSemiring.agda:99` | Agda comment | "the Pell identity element" — in the very lane that exists to refuse the name (audit F9). Should read वर्गप्रकृति. |
| `formal/pairfield/Pairfield/Lorentz.lean:38` | Lean comment | "the two Pell-type equations" → varga-prakṛti-type. |
| `notes/SEED49_completeness_of_three_families.md:16,92,266` | note | "Pell/norm-one lane", "Pell", "the Pell ladder (Lagrange)". |
| `notes/SEED74_IHARA_BASS_SETTLED_THE_WRONG_TRACE_FORMULA.md:371` | note | "Pell solutions". |
| `notes/LEAN_TO_CUBICAL_PORT_MAP.md:78` | note | "Pell-factorization". |
| `notes/FLEET_BREAKER_PASS_2026_08_14.md:80` | note | "Gauss's Pell criterion". |
| `notes/SEED60_COARSE_GEOMETRY_OF_THE_LEVEL_TOWER.md:421` | note | "a finite Pell-type question". |
| `notes/SEED26_WITNESS_RADIUS_PARITY_OBSTRUCTION.md:306` | note | "the Pell-unit torsor". |
| `notes/SEED13_D3PRIME_EXACT.md:335` | note | "the Pell solution" (line 338 already disclaims). |
| `collab/messages/0698-…:179`, `collab/messages/genius-braid/1-09-brahmagupta.md:8,45`, `collab/swarm/2026-08-14/swarm-0814-08-chebyshev-weight-pell.md` (title + body), `collab/messages/0464-…:34`, `collab/messages/0708-…:104` | collab/messages | peer-authored correspondence; report only. |
| `collab/STATE.md:341` | shared index | "Pell/class-number geodesic enumeration". |

### B. **"Pellet"** — a false positive, DO NOT touch

Every "Pell" in `notes/PROOF_DIFF_FF.md`, `notes/FF.md`, `notes/ATIYAH.md`,
`notes/FF_PAIRFIELD.md`, `collab/discovery/claims/R0010`, `R0014`,
`collab/chronicle/MESSAGES.md`, `collab/messages/0046-…` is **Pellet** — the
mathematician of the parity-of-irreducible-factors theorem (`μ(f) = (−1)^deg
χ₂(disc f)`), in the function-field Chowla lane. Unrelated to वर्गप्रकृति.
Substring collateral. Already flagged in `PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md`.

### C. Other false positives

`notes/LIFETIME_EXECUTION.md:48` "Montpellier" (place name). Any `-pell-`
inside "spelled/propelled" filtered out at grep time.

## The point, not the bookkeeping

Renaming a file is the smallest part. वर्गप्रकृति is not a "Pell equation with
an Indian backstory" — it is a different object embedded in a different
epistemology: the bhāvanā is a *composition* (a saṃskāra on ordered pairs), the
cakravāla is a *wheel* (चक्र) chosen so the wheel closes, and the whole sits
inside Brahmagupta's and Bhāskara's algebra of the unknown (अव्यक्त-गणित). To
file it as "Pell, solved early" is exactly the Colebrooke move CLAUDE.md warns
against: keep the theorem, discard the tradition. The name वर्गप्रकृति keeps
both.
