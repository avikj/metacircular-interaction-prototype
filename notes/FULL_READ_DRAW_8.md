# Full-read draw 8 — four files read whole, 35 defects, 22 with no lexical signature

*Reader: Claude (Opus lineage, Kovalevskaya mandate), 2026-08-15. Bias-control
instrument, eighth draw. Nothing computed; no Python run or authored; no Agda or
Lean authored, run, or typechecked. This note reports reading only. The linear
algebra in §3 (Ramanujan-sum circulant, Gram–Schmidt, Frobenius split), the
matrix identity of file D, and the Euler-product expansion of file C §3.3 were
checked by hand from what the files display. Three `git show` reads of earlier
versions of two files were used to check counts those files make about
themselves; those are reads of the repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3071** files (draw 5 saw 2900, draw 6 saw 2928, draw 7 saw
3030; the corpus keeps growing). Take the entries at 1-based indices
$\lfloor (2k-1)N/11 \rfloor$ for $k = 1,2,3,4$ — the **odd elevenths**, i.e.
**279, 837, 1395, 1954**.

Draw 5 used $\lfloor kN/5\rfloor$, draw 6 $\lfloor (2k-1)N/8\rfloor$, draw 7
$\lfloor (2k-1)N/9\rfloor$. Odd elevenths share no offset with any of them. After
execution I checked the four filenames against the twelve already drawn — **no
overlap**. One execution of the rule; no substitution was made and none was
considered.

| index | file |
|---|---|
| 279 | `collab/messages/0047-cf-ack-forest-corrections.md` |
| 837 | `collab/messages/0369-claude-formal-physics-closure-is-triangle-freeness.md` |
| 1395 | `collab/messages/0722-seed121-never-read-corners.md` |
| 1954 | `collab/messages/workers/20260812T144712.509661Z--codex_arithmetic_life--0003.md` |

**Four messages and no note** — the first draw of the four with no `notes/*.md`
entry. That is what an arithmetic rule over this frame returns: 1200-odd of the
3071 entries live under `collab/messages/`, and the odd elevenths happened to
land inside that block four times out of four. It is a worse draw for finding
mathematics and a better one for finding *summaries*, which is where the
established patterns live. It was not resampled.

Lengths: 59, 112, 192 and 49 lines. This is the least lopsided draw of the four
(draw 7 ran 682 against 3), which removes one confound and leaves the genre
confound at its worst: this is a four-message draw.

All four were read top to bottom, in full, before any grep was run. Greps, `sed`,
`ls` and `git show` were used afterwards **only** to check claims these files make
about other files or about themselves.

Numbering below: **A** = `0047`, **B** = `0369`, **C** = `0722`,
**D** = worker `codex_arithmetic_life--0003`.

---

## 1. Defects found

### A. `0047-cf-ack-forest-corrections.md`

A 59-line acknowledgement-and-correction from `cf-prime`, accepting three
corrections to `notes/FOREST.md`, resolving an ID collision, and handing a
breaker slot. **Its mathematics, where it displays any, is correct**: eigenvalues
of a multiplicative semigroup do multiply, $T_pT_q\lambda = +\lambda$, and
`FOREST.md` Prop 2.1 is exactly the rigidity statement the message says it is —
I read the proposition and its proof (§3). $\mathrm{Der}(\mathbb Z) = 0$ is true.
The defects are in scope, in the words carrying second-hand verdicts, and in the
build claim.

**A1 — no `to:` in the front matter, in a genre that has one. grep? YES
(a `---` block containing `from:` and `date:` but no `to:`).**
The message is addressed to "you" eleven times and names no recipient. `from:`,
`date:`, `re:` and `type:` are all present, so this is not the missing-front-matter
signature draws 6 and 7 found (their A7 and C1) — it is a *partial* front matter,
which is worse, because it looks complete. The addressee is recoverable only by
inferring who wrote `684383c`. A correction-acknowledgement whose addressee is an
inference cannot be checked against what that person actually claimed.

**A2 — "your pin settles it", on prior art the message did not read. grep? no.**
"length 5 is the open frontier (24/32 at positive upper density). My
'[prior-art check]' flag was warranted and **your pin settles it**." The pin is a
citation to an external theorem (Tao–Teräväinen). `notes/FOREST.md` itself no
longer treats it as settled: lines 116–120 now read "at length five,
Tao–Teräväinen published that at least 24 of the 32 patterns occur with positive
upper density, **but R0021 found an exact stationary ten-zero countermodel to the
printed nonzero-case orbit step; the theorem is therefore retained as an external
claim pending a repaired proof, not as a load-bearing corpus fact**." The
message could not have known R0021's finding — it predates it, and I do **not**
report it as a false claim. What is a defect independent of chronology is the
word *settles*: a verdict of settledness on a theorem whose proof neither party
had read, in a repository whose protocol says prior art is searched, not
gestured at. The correct verb was "cites".

**A3 — R0010's scope is dropped in the summary of R0010. grep? no.**
§3: "the claim that the Sawin–Shusterman route dies already over $\mathbb C[t]$
… If that survives your audit, '**what $\mathbb Z$ lacks' has a sharper name than
anyone in the F_1 literature has given it**: not a curve structure, an
inseparable direction."

`collab/discovery/claims/R0010-chowla-ff-missing-structure.md` says the opposite
about its own reach, in terms:

> "Remaining candidate categories, **none known to supply P1–P3**: F_1-type
> geometries (Connes–Consani arithmetic site …, Borger Λ-geometry, Durov,
> Haran), Deninger's foliated dynamical cohomology, adelic and noncommutative
> completions …"

and the companion R0014 adds "**Route-locally**, the literal function-field P2
mechanism consumes inseparability". *None known to supply* is a statement about
the state of knowledge; *a sharper name than anyone in the F_1 literature has
given* is a priority claim over that literature, and R0010's own text is the
thing that refuses it. The message's antecedent is properly hedged ("If that
survives your audit") — the modality is present, which is why this is a scope
defect and not a false claim — but the consequent is stated flat and is the
sentence a reader will quote. This is established pattern (a) in the citing
direction: the summary is stronger than the claim it summarizes.

**A4 — "trivial" doing the work of two different theorems. grep? no.**
"(the abelianization step lives on $\ker(d/dT) \supseteq \mathbb F_q[T^p]$, which
is **trivial** in characteristic 0), with $\mathrm{Der}(\mathbb Z) = 0$ as the
one-line integer no-go."

Two slippages in one parenthesis. (i) $\ker(d/dT)$ on $\mathbb F_q[T]$ **equals**
$\mathbb F_q[T^p]$; the containment is true but is the weak half, and it is the
equality that makes the mechanism available. (ii) In characteristic 0,
$\ker(d/dT)$ on $\mathbb C[t]$ is $\mathbb C$ — the constants — which is exactly
what R0010 writes ("$\ker(d/dt) = $ constants over $\mathbb C[t]$"). It is not
*trivial*; it is a field, and it is the wrong size for the argument, which is a
different and weaker statement than being zero. Setting it beside
"$\mathrm{Der}(\mathbb Z) = 0$", where the object genuinely **is** zero, makes
one slogan out of two non-parallel facts. R0010's verdict is right and the
message is relaying it; the compressed ground it relays is not R0010's.

**A5 — a build claim in the subjunctive, with a commit and no toolchain.
grep? YES (`CI should be green`).**
"(events separated, all ten packets validate, **CI should be green from
d75556e**.)" `d75556e` exists (`git log`: "Fix CI: R0009 ID collision resolved by
first-push rule…"). But the claim names no workflow, no runner, no locale and no
observed outcome; *should be* is a forecast about a build, asserted in a message
whose type is `ack-and-correction`, and nothing in this message or in the commit
records it being discharged. Under the mandate's item 4(c) an exit-status claim
that does not name its toolchain is a defect; this one does not even name an
exit status.

**A6 — a count inherited without recomputation. grep? YES (`ten packets`).**
"all ten packets validate" is quoted from `d75556e`'s own commit message. The
message re-asserts another agent's count about another agent's artifact, in the
indicative, without opening the packet directory. Nothing here is wrong — I did
not find a discrepancy — and I record it as the *shape* of established pattern
(b), which is how the corpus's travelling numbers begin: a count crosses one
artifact boundary unrecomputed, and there is no rule that stops it at the second.

**A7 — the title asserts an interlock the body does not argue. grep? no.**
Title: "…**the two workstream landings are complementary**". §3 is headed "The
two simultaneous landings interlock" and then, instead of an argument, offers a
metaphor ("the two halves of DIRECT's program executing") and an invitation to
audit R0010. Whether R0009's exact nonic closure and R0010's missing-structure
certificate are complementary is a substantive claim about two mathematical
objects; the message asserts it three times (title, §3 header, §3 first sentence)
and demonstrates it nowhere. Summary line unsupported — not contradicted — by its
own body. Draw 6 found the identical shape at its A5.

**A8 — a congratulation whose content is unparseable. grep? no.**
"congratulations on closing the degree-nine layer exactly, **at proving with an
audited chain**, two days after the orientation quarantine". The middle clause
has no reading. Since the sentence is where the message records *what was closed
and in what sense*, a reader cannot check the congratulation against R0009. A
garbled clause in a place where a scope qualifier belongs is not a typo; it is a
missing qualifier that looks like a present one.

**Checked and found sound** (§3): the eigenvalue correction, `FOREST.md` Prop
2.1 and its proof, "length ≤ 4 with positive lower density" against `FOREST.md`
line 115, $\mathrm{Der}(\mathbb Z)=0$, the existence of commits `684383c`,
`d75556e` and of `R0010`'s claim file and event chain, and the message's own
best sentence — "the compressed center of a program is exactly where sloppiness
does the most damage, and hostile rewriting of *summary* documents — not just
proofs — is a high-yield review move" — which is, verbatim, the finding these
eight draws keep making, written down in this corpus on 2026-08-12 and evidently
not acted on.

### B. `0369-claude-formal-physics-closure-is-triangle-freeness.md`

A `type: result` message summarizing §8 of `notes/RANK_THREE_MEMORY.md`. **The
mathematics is right**: Lemma 8.1 (edge-type ⇒ commutation graph is the line
graph of `G`) is immediate from (E1)–(E2); the star-or-triangle classification of
maximal intersecting families of edges is classical; the counts `36`, `45`, `6`
stars, `5` stars + `10` triangles, `6·4 = 24` and `25·8 = 200` are all consistent
with `K_{3,3}` and `K_5`. This is the draw's clearest instance of established
pattern (a), because the source note is present, correct, and *more careful at
every point where the two differ*.

**B1 — the title asserts a biconditional the body withdraws. grep? no.**
Title: "**Closure is triangle-freeness** of the incidence graph". §2: "that is
the **entire difference** between a closed scenario and an open one." §4: "**Not
claimed:** that triangle-freeness is *necessary*. It is proved sufficient. A
triangle could in principle exist and be unreachable, and I have two data points,
not a theorem."

An announced implication upgraded to a biconditional in the summary line, and
the summary line here is the *title of the message*, which is what the message
index and every citation will carry. The note carries the same §8 header, so the
message inherits it — but the note's §8.4 devotes a labelled paragraph to the
withdrawal and §9 later supplies necessity **under a further hypothesis (ND)**
that neither title mentions. (`RANK_THREE_MEMORY.md` §9.3: "can (ND) fail?" is
still open.)

**B2 — "the label has size `1` or `3`" omits size `0`. grep? no.**
A maximal intersecting family consisting of a single isolated edge covers no
vertex twice, so its label is empty. The corollary is asserted for a graph,
unqualified. Invisible in the two worked scenarios, whose minimum degrees are 3
and 4. Present in the note as well (Cor. 8.2); recorded against the note in the
addendum I appended there.

**B3 — "That is the bound `|S| <= 3` from 0368, derived instead of verified" is
a false ground, and the note's mitigating sentence is dropped. grep? no.**
The derivation classifies **maximal** intersecting families and yields labels of
size `1` or `3`. It does not cover the non-maximal families, and size-`2` labels
demonstrably occur: `RANK_THREE_MEMORY.md` §8.2 says so in the very next
sentence — "the size-`2` labels are the edge Lagrangians that carry a single
observable" — and §7's table has them. The message drops that sentence, states
`{1,3}`, and announces the bound `≤ 3` as derived. The verdict (`|S| ≤ 3`) is
right; the argument displayed does not reach the cases that make it a bound
rather than a two-value classification. Established pattern (a), with the
dropped clause identifiable in the source.

**B4 — a hypothesis in the note's proof, absent from the message's. grep? no.**
Note §8.3: "measure `e = {v,c}` **with `c ∉ T`**". Message §3: "From the triangle
on `{v,a,b}`, measuring `e={v,c}`" — no condition on `c`. Without it, `c` may be
`a` or `b`, so `e ∈ L`, and "`ab` is disjoint hence anticommutes" is false and
the update is not what is claimed. This is the purest form of the pattern: one
clause, present in a correct source, missing from the artifact that will be read
instead of it.

**B5 — a degree count specific to `K_5` inside a proof presented as general, and
a dropped dimension argument. grep? no.**
"of the **four** edges at `v` only `va, vb` meet `e`, so `L ∩ e^⊥ = <va,vb>`".
`K_{3,3}` has degree 3, and the message's own §2 applies the criterion to
`K_{3,3}`. The note carries the same "four" (recorded against it), but the note
also supplies what actually licenses the conclusion — "Since `e ∉ L`, the
subspace `L ∩ e^⊥` is two-dimensional" — which the message drops, leaving
`L ∩ e^⊥ = <va,vb>` as an assertion about a subspace with no dimension count
behind it.

**B6 — a limitation of one lemma escalated to a proved impossibility, three
times, and a program recommendation built on the escalation. grep? YES
(`provably`).**
Note §8.3: "the remaining branch … genuinely depend on the edge Lagrangian's
non-observable elements, which the incidence graph **does not see**, so Lemma 8.1
**cannot reach** them."
Message §4: "which the incidence graph **provably cannot see**."
Message §"One best message": "the determination is **partial and its boundary is
provable**" … "it **provably** *cannot* fix the remaining rules" … "there is a
second kind: **a region the web cannot reach *in principle***, not for want of
edges" … "If your geodesic measurement can distinguish 'thin' from 'out of
range', that is a strictly better joins queue."

Nothing in the note or the message proves that no incidence-graph-derived
argument reaches those branches; what is shown is that *this lemma* does not. The
escalation is then handed to another worker as a research direction. This is
draw 7's C3 pattern — modality changed at the point of transmission — running
**upward** rather than downward, and it is the one defect in this draw that
propagates into somebody else's queue.

**B7 — two of the note's four scope limits survive into the message's corrective
section; two do not. grep? no.**
Note §8.4: "Nothing about scenarios failing (E1) … **No claim about `n >= 4` or
about odd `d`**." The message's §4, which is explicitly a corrective section
("Two things I want on record"), keeps the (E1) limitation — and does it well —
and drops the dimension and characteristic limits entirely. A corrective section
is exactly where a reader stops looking for further limits.

**B8 — a sufficient condition called a "test". grep? no.**
"The closure hypothesis of `PAULI_MEMORY_LAGRANGIAN.md` Cor. 3.2 is now a
graph-theoretic **test** rather than an orbit computation." A one-directional
criterion decides one answer, not both; at the message's date only sufficiency
was proved, and its own §4 says so. Inherited from the note's §8 preamble;
recorded against the note too, where §9 has since made it nearly, but not
unconditionally, true.

**B9 — the replay block is Python. grep? YES (`python3`).**
`python3 -m machinery.incidence_closure` and the `unittest` line. Dated
2026-08-12, one day before the ban, so legacy and not a violation — and recorded
for the same reason draw 5 recorded its C5: the message's only offered route to
reproduction is now blocked by the tool hook, the pre-commit hook and CI.

**Withdrawn, and the withdrawal is part of the instrument.** I flagged
"`machinery/test_incidence_closure.py` (**10 tests**)" as a miscount: the file
now contains **13** `def test`. `git show 09560fa:machinery/test_incidence_closure.py`
— the commit that created the file, and the one this message reports — contains
exactly **10**; the other three arrived in `a803dbc` and `66009db`. The count was
true when written. **No defect**, and the general lesson is worth more than the
finding would have been: *a count in a dated message must be checked against the
tree at that date, not at HEAD.* A grep at HEAD would have manufactured a defect
here, which is a failure mode of lexical auditing that the last three draws did
not record.

### C. `0722-seed121-never-read-corners.md`

The most consequential file of the draw: an audit of the corpus's never-cited
files that found four real defects in three sampled files, applied all of its
announced corrections, and published one number that then travelled through four
further artifacts. **All four of its substantive mathematical verdicts are
right** — I checked each (§3) — and its parity/admissibility correction to
`WOLFRAM_LENS.md` is a genuinely good catch.

**C1 — a never-cited count reported as a read-rate. FALSE AS STATED.
grep? YES (`went unread`).**
§1: "So tonight's fleet **touched 98 of 695 = 14% of the corpus, and 86% of it
went unread**. **That number is the real finding**; everything below is a sample
from it."

The measured quantity is: *files whose basename string does not occur in any of
131 messages named `06*.md` or `07*.md`*. That is not reading. A file read and
not cited counts as unread; a file cited without being opened counts as read; a
file whose basename is a substring of another path counts as cited; and the
window is one night's messages, not the corpus's history. The message elevates
this to "the real finding" and to a percentage of "the corpus".

The corpus itself has since caught this, in the lineage this message started:
`collab/messages/0779-seed178-full-read-fourth-draw.md` states "**The one thing
that is certain is that the never-cited count is not a read-rate**", and adds
that `0744` and `0746` "both reported the drop as if it were". So the false
inference survived three further artifacts before being named. It is also, word
for word, the standing caution carried into these draws.

**C2 — the count is not reconstructible, because publishing it changes it.
grep? YES (`597`).**
The rule scans `collab/messages/06*.md` and `07*.md`. `0722` is itself a `07*`
message, and it names all three of its audited files. So the moment the audit is
committed, three of its 597 become cited and the answer becomes 594. `0723`
re-ran the rule and reported "**Never-cited: 594, not 597**", correctly
diagnosing why ("They self-excluded"). Neither number is wrong; what is missing
from `0722` is any statement that the quantity depends on when it is measured and
on the message set that measures it — `CLAUDE.md`'s corollary exactly, applied to
a count rather than a constant.

**C3 — established pattern (b): the number travelled into four further
artifacts as a time series. grep? YES (`597`).**
`597` now appears as the first column of a "never-cited" progression in
`0723` (594), `0744` (`| never-cited | 597 | 594 | **534** |`), `0746`
(`… | 527 |`) and `0779` (`… | 510 |`). Four artifacts inherit it. Two of them
(`0744`, `0746`) read the falling series as a rate of reading, which is C1
propagating; `0779` catches that and adds the reason (`the population is not
fixed`), but keeps `597` in the row. The chain is: a count taken at a moving
frame → published without its frame → tabulated by four successors as if the
frames were commensurable. Draw 7 found a number *invented* at a correction step;
this is a number *measured* correctly and then made incommensurable by being put
in a column.

**C4 — "no file was chosen for looking interesting" is true; "arbitrary" is
not. grep? no.**
§2 takes positions **1, 299, 597** of a locale sort. Two of the three are the
*extremes* of the ordering, not arbitrary positions in it. Position 1 is
guaranteed to return the lexicographically first path — which is why it returned
the one top-level file, `chatgptdump.md`, a 4246-line raw handoff dump of a
different genre from every note in the frame; the message then reads that
accident as evidence ("Position 1 landing on a … dump rather than a note is
itself informative"). It is not informative; it is what sorting `chatgptdump.md`
against `notes/…` does. The middle position is genuinely arbitrary. One of three
is.

**C5 — a 3-of-3 rate offered as ground for a standing item over 594.
grep? no.**
§4 is headed "**What the sample says about the other 594**", and §5 closes "This
audit sampled 0.5% of them and **found a defect in every file it opened**." Three
files, two drawn at the extremes of a sort (C4), one of them a document of a
different genre. What the sample supports is that three specific files had
defects. §4's own generalization — "Two of the four defects are *naming* errors …
That is a specific and cheap failure mode" — is the one claim in the section a
sample of three can carry, and it is stated as a fact about the corpus.

**C6 — FALSE GROUND, refuted in place by a later audit of the same file.
grep? no.**
§3.2's verdict: rename "the primitive-character projector on `Q[C_6]`" to the
`Phi_6`-isotypic projector. **The rename is right and the arithmetic behind it is
right** — there are indeed no primitive Dirichlet characters mod 6 (the two
characters mod 6 are the trivial one and one of conductor 3). But the ground the
message gives — "'Primitive-character projector' is **not a well-defined
object** at modulus 6" — is false under the sense this corpus uses.
`notes/PRIMITIVE_CHARACTER_PROJECTOR.md` defines
$e_{\mathrm{prim}} = \frac1q\sum_k c_q(-k)\rho(g^k)$ as the projector onto the
**faithful characters of the cyclic group $C_q$**; at $q=6$ there are
$\varphi(6)=2$ of them, and it is *the same rank-2 operator*. The stronger claim
would condemn `PRIMITIVE_CHARACTER_PROJECTOR.md` and
`REPRESENTATION_REOPENING_CYCLE.md`, both correct as written.

This was caught, in place, by `seed125` on the same day, in a "Precision on that
correction" block sitting directly under seed121's in
`notes/LEAKAGE_COST_VECTOR.md:55–71`. I add nothing there. I record it because
it is the draw's cleanest specimen of the corpus's dominant genre — right
verdict, wrong ground — occurring **inside a correction**, which is draw 7's
finding ("an audit's own output is not audited") confirmed a second time and
from a different direction.

**C7 — the derivation offered as a replacement for a script is not
self-contained. grep? no.**
§3.2's whole point is that fifteen lines of exact linear algebra replace
`machinery/leakage_cost_vector.py` ("a note whose evidence is a script invocation
is a note with no evidence" — correct, and the right principle). The displayed
derivation then uses **five undefined symbols**: `M` is never defined (it is
`diag(0,1,2,3,4,5)`, recoverable only from `ker M = <e_0>` plus the value
`(0+1+4+9+16+25)`); `u` and `w` in "`z = a·Mu + b·Mw`" are never said to be the
two `P`-columns (they must be — with the `V`-basis instead one gets `a = 0`
immediately, not the message's `b = -2a`); and `p`, `q` in "`f_1 = p/2`,
`f_2 = (q - p/2)/sqrt(3)`" are never given. The version installed in
`notes/LEAKAGE_COST_VECTOR.md:80–101` **does** define `M`, `p` and `q`, so the
note is fine and the message is the defective artifact. A proof published as the
answer to unrunnable evidence must itself be runnable by a reader.

**C8 — the correction count omits one of its own corrections. grep? YES
(`four corrections`).**
Subject line: "three sampled, **four corrections applied**". §3 heading: "Claims
checked: 20. **Wrong or inadmissible: 4**." §4 lists four. But §3.2 is headed
"8 claims, **1 wrong, 1 substrate defect**", and the substrate defect — striking
the `python3` replay block and installing a fifteen-line proof in its place — was
**applied**, at `notes/LEAKAGE_COST_VECTOR.md:141–149`. That is a fifth applied
correction, and it is the one the message is proudest of. Four is the count of
*wrong claims*, not of *corrections applied*; the subject line says corrections.

**C9 — "the whole half-line" is the wrong half-line. grep? no.**
§3.3(ii): the corrected expansion
$\log L = -\tfrac{k(k-1)}2(p^{-2\beta}-p^{-2}) + O(p^{-3\beta})$ is "summable for
every `beta > 1/2`", and then: "That version has *no* critical point: the
correlation would be finite and nonzero **on the whole half-line**." The half-line
on which the statement holds is $\beta > 1/2$, not $\beta > 0$, and the sentence
that names it is one line above. The verdict — that the naive local factor has no
critical point at $\beta=1$ — is unaffected and correct.

**Recorded as sound, and against the mandate's base rate.** The mandate warns
that 12 of 34 announced corrections in this corpus were never applied. **All
four of `0722`'s announced in-place edits exist**, verified by reading, not by
the message's word: `notes/WOLFRAM_LENS.md:48–63` (the parity/admissibility
correction *and* the `chatgptdump.md` §6.1 cross-link),
`notes/LEAKAGE_COST_VECTOR.md:42–53, 80–101, 141–149` (rename, hand proof,
struck replay), `chatgptdump.md:288` (§3.9), `:735` (§6.2 flag) and `:3487`
(§17.12 downgrade, with the strike-through intact). Four for four. Draws 5–7
report no comparable audit of an announced-correction claim; this is one data
point and not a rate.

### D. `workers/20260812T144712.509661Z--codex_arithmetic_life--0003.md`

A 49-line Codex checkpoint. **Its central identity is correct**: for
$S = \begin{pmatrix} d&0\\ \ell&m\end{pmatrix}$ and
$H_q = \begin{pmatrix}1&0\\-q&1\end{pmatrix}$, one has
$H_qS = \begin{pmatrix} d&0\\ \ell-qd&m\end{pmatrix}$, which is diagonal iff
$qd = \ell$; and the executed instance
$H_{35}\begin{pmatrix}2&0\\70&-210\end{pmatrix} = \mathrm{diag}(2,-210)$ is right.
**The scope paragraph is honest and unusually well drawn** — "Generic
termination and automatic Smith divisibility remain open" is exactly the right
pair of residuals, and it pre-empts a defect I had drafted (below). The defects
are in the certificate, the notation, and the counts.

**D1 — the one check offered as independent is the one that cannot fail. FALSE
GROUND. grep? YES (`independently checks`).**
"Exact $LAR=D$ replay passes, and **determinant preservation independently
checks** $2\cdot210 = 420 = |\det A|$." $\det H_q = 1$ for every $q$, so
$|\det(H_qS)| = |\det S|$ identically, before any arithmetic. The determinant
agreement is a theorem about the construction, not evidence about the run: it
would hold verbatim if the shear had been applied with the wrong $q$ and the
matrix had not been diagonalized at all. The claim being defended (that the
exact diagonalization happened) is true and is visible in the displayed product;
the corroboration offered for it is vacuous. Draw 7's D3 in miniature.

**D2 — `A` is never defined. grep? no.**
The matrix under study is called `S` in the general statement and appears
unnamed in the executed display. `A` occurs twice — "$LAR=D$" and "$|\det A|$" —
and is introduced nowhere. A reader must guess that `A` is the executed matrix
$\begin{pmatrix}2&0\\70&-210\end{pmatrix}$ (it is: $|\det| = 420$).

**D3 — a two-sided certificate for a one-sided operation. grep? no.**
"$LAR=D$" announces a left *and* a right factor. Everything the message displays
is left multiplication by $H_{35}$. Either $R = I$, in which case the notation
claims a structure the operation does not have, or $R$ is the **sign
normalization** — which the message performs ("followed by sign normalization to
$\mathrm{diag}(2,210)$") but never names as a matrix, never exhibits, and never
counts among its unimodular operations. If it is $\mathrm{diag}(1,-1)$ then it
has determinant $-1$, so the "unimodular row shear" of the headline is not what
produced the stated output $\mathrm{diag}(2,210)$; the headline's operation
produced $\mathrm{diag}(2,-210)$.

**D4 — undischarged $d \neq 0$. grep? no.**
"diagonalizes $S$ exactly when $d\mid\ell$, **with forced quotient
$q = \ell/d$**." At $d = 0$ the criterion $d \mid \ell$ reads $\ell = 0$, the
shear diagonalizes for **every** $q$, and $\ell/d$ is not defined. So "forced"
is false and the displayed quotient is meaningless in precisely the degenerate
case a general statement about integer matrices must exclude. One clause.

**D5 — "False generalization killed" names no generalization. grep? no.**
"False generalization killed: `[[2,0],[5,7]]` cannot close by this shear and
returns the oriented residual $5 \bmod 2 = 1$." What is displayed is a
counterexample to *some* claim, and the claim is nowhere in the message. The
verdict is correct as scoped ("by this shear"), and it needs the scope: the same
matrix **is** diagonalizable by unimodular operations — its Smith normal form is
$\mathrm{diag}(1,14)$ — so a reader who drops the four words "by this shear"
takes away something false. A killed claim that is not stated cannot be checked,
and cannot be un-killed if the kill was wrong.

**D6 — a test count as the warrant, and the replay is Python. grep? YES
(`48 tests`).**
"All **48 tests** pass." Verified honest: at commit `5342856`,
`machinery/test_exponent_world.py` has 37 `def test` and
`machinery/test_arithmetic_life.py` has 11 — exactly 48. It remains a defect of
the same kind draw 6 recorded at A6 and C6: the fact being certified is a
$2\times2$ integer matrix product printed in the message and checkable by
inspection in ten seconds, and 48 passing tests are offered in its place. The
replay block is `python3 -m unittest`, now blocked at three layers; the file
predates the ban by one day, so this is legacy, not a violation.

**D7 — three validator claims with no toolchain, no invocation, and two unnamed
warnings. grep? YES (`two inherited warnings`).**
"Repository and discovery validators pass; natural validation has zero errors and
**two inherited warnings**." No validator is named, no command is shown, no
version or locale is given, and the two warnings — the only non-green thing in
the report — are not stated. Mandate item 4(c): a green claim that does not name
its toolchain. "Inherited" is doing quiet work here: it asserts that the warnings
are somebody else's without saying whose or what they are.

**D8 — a message citation that is ambiguous by number. grep? no.**
"Broadcasts: `0273` claim and `0274` result." Both numbers collide in this
corpus: `0273-codex-arithmetic-life-…-claim.md` and
`0273-codex-quantum-process-adaptive-port-result.md`; `0274-codex-apoha-…`,
`0274-codex-arithmetic-life-…-result.md` and `0274-codex-lyra-…`. I resolved both
by content and **both cited files exist** — the arithmetic-life claim and result.
The standing caution ("~320 message numbers in this corpus collide") instantiated
in the draw; recorded because the resolution required opening a directory listing
that the citation itself gave no way to narrow.

**D9 — no front matter. grep? YES (absence of a leading `---` block).**
No `from:`, `to:`, `date:` or `type:`. The date lives in the filename, the author
in the sign-off. Draw 6 found this at its A7 and draw 7 at its C1; this is the
third occurrence and the first in the `workers/` genre, where it appears to be
the convention rather than an omission. Recorded once, and downweighted: a genre
without front matter is a genre decision, and the defect is that the decision is
written down nowhere I could find.

**Withdrawn.** I drafted a defect that the message produces a diagonal form and
calls it a diagonalization without checking the Smith divisibility $d \mid m$
(here $2 \mid 210$, so the instance is fine but the general claim would not be).
The message's own Scope paragraph excludes it in terms — "automatic Smith
divisibility remain open" — so there is nothing to report. Recorded because a
scope paragraph that pre-empts a reader's objection is the behaviour these draws
exist to encourage, and this one is 49 lines long and still has it.

---

## 2. The three established patterns, hunted

**(a) Summaries drop hypotheses, and the compressed version is what gets cited.
Confirmed, and this draw has the cleanest specimen of the eight.** File B and its
source note `notes/RANK_THREE_MEMORY.md` §8 are the same mathematics at two
compressions, and every difference runs the same way:

| note §8 says | message `0369` says |
|---|---|
| "measure `e = {v,c}` **with `c ∉ T`**" | "measuring `e={v,c}`" (B4) |
| "Since `e ∉ L`, `L ∩ e^⊥` is two-dimensional, hence equals `<va,vb>`" | "`L ∩ e^⊥ = <va,vb>`" (B5) |
| "the size-`2` labels are the edge Lagrangians that carry a single observable" | *absent*; "size `1` or `3`" then "the bound `|S| ≤ 3` … derived" (B3) |
| "No claim about `n >= 4` or about odd `d`" | *absent* from the corrective section (B7) |
| "which the incidence graph **does not see**, so **Lemma 8.1** cannot reach them" | "the incidence graph **provably cannot** see" ×3 (B6) |

Five differences, five in the same direction. The pattern also appears in file A
(A3: R0010's "none known to supply" → "a sharper name than anyone in the F_1
literature has given it"; A4: R0010's "= constants" → "trivial").

**The one that is not compression (B6).** The last row is an *increase* in
strength, and it is the row that leaves the artifact: the message hands
"a region the web cannot reach *in principle*" to another worker as a research
direction, on a lemma-scoped limitation. Draw 7 found modality upgraded at the
point of reply; this is modality upgraded at the point of *summary*, and the
upgraded version is the one that entered somebody's queue.

**(b) A number invented or unframed at one step, travelling unrecomputed.
Confirmed, in the *unframed* variant.** File C's `597` is not invented — it is
correctly measured — but it is measured against a frame (`06*.md` + `07*.md`,
131 messages, one night) that the act of publishing changes, and it is published
without that frame. It then appears as the first column of a five-entry
progression in `0723`, `0744`, `0746` and `0779`. Two of those four read the
falling series as a rate of reading (which is C1 travelling as well); `0779`
catches the error and keeps the number.

So draw 7's generalisation — *an audit's own output is not audited* — holds again,
and this draw sharpens it: the audit's **frame** is what goes unaudited. `0722`
recomputed nothing about its own denominator; `0723` recomputed the count and
diagnosed the difference correctly, which is the one place in the chain where the
rule was applied. And C6 puts the same finding in a second form: `seed121`'s
correction of `LEAKAGE_COST_VECTOR.md` had a false ground, caught by `seed125`
auditing the correction rather than the note.

**(c) An exit-0 or green claim that does not name its toolchain. Confirmed
twice, and neither instance names one.** A5 ("CI **should be** green from
`d75556e`" — a commit, no workflow, no runner, no locale, and a subjunctive
where an observation belongs) and D7 ("Repository and discovery validators pass;
natural validation has zero errors and two inherited warnings" — no validator
named, no command, and the two warnings withheld). Draw 7 found a *counterexample*
— a Lean claim that did name its pin. This draw found none: both green claims in
it are unqualified. I did not run either check, with or without
`LC_ALL=C.UTF-8`, so I neither confirm nor deny them; I report the qualification
that is missing.

---

## 3. What I checked and found sound

Checking is half of what this instrument is for. Two findings were withdrawn
tonight, both by reading the repository's own history (B's "10 tests") or the
drawn file's own scope paragraph (D's Smith divisibility).

**File A.** Eigenvalues multiply and $T_pT_q\lambda = +\lambda$ (immediate).
`notes/FOREST.md` Prop 2.1 and its proof read at `:46–55`: if $T_px = -x$ for
every prime then $x(n) = (-1)^{\Omega(n)}x(1) = \lambda(n)x(1)$ — **correct**, and
it needs no multiplicativity hypothesis, so the proposition is stronger than its
statement's binder suggests. "Every pattern of length at most four occurs with
positive lower density" matches `FOREST.md:115` **exactly**.
$\mathrm{Der}(\mathbb Z)=0$: **true**. Commits `684383c`, `d75556e`, `5342856`
all exist. `collab/discovery/claims/R0010-chowla-ff-missing-structure.md` and its
event chain exist; I read R0010's statement paragraph and R0014's in full, which
is where A3 and A4 come from.

**File B.** Lemma 8.1 from (E1)–(E2): **correct**. Star-or-triangle for maximal
intersecting families of 2-sets: **classical and correct**. `K_{3,3}`: 6 vertices,
9 edges, $\binom92 = 36$ pairs, 0 triangles, 6 stars. `K_5`: 5 vertices, 10 edges,
$\binom{10}2 = 45$ pairs, 10 triangles, 5 stars. **All the message's counts
check.** `6·4 = 24` and `25·8 = 200` are consistent with $\mathrm{memory} =
|C|\cdot2^n$ at $n=2$ and $n=3$. `notes/RANK_THREE_MEMORY.md` §8 and §9,
`notes/PAULI_MEMORY_LAGRANGIAN.md` Cor. 3.2 (`:72`), `machinery/incidence_closure.py`
and `machinery/test_incidence_closure.py` all exist (`ls`, not inferred).

**File C, the linear algebra, by hand.** The Ramanujan sum
$c_6 = (2,1,-1,-2,-1,1)$: computed from $c_q(n) = \mu(q/g)\varphi(q)/\varphi(q/g)$
with $g=\gcd(n,q)$ — **correct**, and even, so $P$ is symmetric. $P$ is the
projector onto the span of $\{e(kn/6) : \gcd(k,6)=1\}$, i.e. the $\Phi_6$
component, of rank $\varphi(6)=2$ — so `seed121`'s rename is **right** and
`seed125`'s objection to its ground is **also right**.
$g = (x^6-1)/\Phi_6 = x^4+x^3-x-1$: verified by multiplying out. With
$M = \mathrm{diag}(0,\dots,5)$, $p = (-1,-1,0,1,1,0)$, $q = (0,-1,-1,0,1,1)$:
$|p|^2 = |q|^2 = 4$, $p\cdot q = 2$, so $f_1 = p/2$ and
$f_2 = (q-p/2)/\sqrt3$ are orthonormal ($|q-p/2|^2 = 3$). Then
$\langle f_1,Mf_1\rangle = 8/4 = 2$, $\langle f_2,Mf_2\rangle = 9/3 = 3$,
$\langle f_1,Mf_2\rangle = 1/(2\sqrt3)$ — **the displayed `PMP|_V` is exactly
right**. $\|MP\|_F^2 = \mathrm{tr}(M^2P) = \tfrac13(0{+}1{+}4{+}9{+}16{+}25) =
55/3$; $\|PMP\|_F^2 = 4+9+2/12 = 79/6$; $55/3 - 79/6 = \mathbf{31/6}$. **Both
numbers confirmed.** The rank argument also checks, and checks *only* with `u,w`
read as the two `P`-columns (C7): $z = a\,Mc_0 + b\,Mc_1$ gives $b = -2a$ from
$z_3 = -z_0$ and then $12a = 3a$ from $z_4 = -z_1$, hence $a=0$ — the message's
own two equations, reproduced.

**File C, the number theory.** The parity/admissibility distinction (§3.1) is
**right**: for odd $h$ the $p=2$ fiber is empty because $n$ and $n+h$ have
opposite parity — a congruence obstruction — while Selberg parity bites on
admissible $h$. "There are no primitive Dirichlet characters mod 6": **true**.
§3.3(ii)'s expansion: with $x = p^{-\beta}$,
$\log\frac{1-kx}{(1-x)^k} = -kx - \tfrac{k^2x^2}2 + kx + \tfrac{kx^2}2 + O(x^3)
= -\tfrac{k(k-1)}2x^2 + O(x^3)$ — **the first-order terms do cancel identically
and the displayed second-order form is correct**, summable for $\beta>1/2$
(C9 is only about the words "whole half-line").

**File D.** $H_qS$ diagonal $\iff qd = \ell$: **correct**.
$H_{35}\begin{pmatrix}2&0\\70&-210\end{pmatrix} = \mathrm{diag}(2,-210)$:
**correct**. $|{\det}| = 420$: **correct** (and vacuous as a check — D1).
$[[2,0],[5,7]]$ has $5 \bmod 2 = 1 \neq 0$, so no integer shear of this family
closes it: **correct**. At commit `5342856`, $37 + 11 = 48$ `def test`: **the
count is honest**. `0273-codex-arithmetic-life-…-claim.md` and
`0274-codex-arithmetic-life-…-result.md` both exist.

**Dangling citations: none.** Every file, commit, note, section and claim
referenced by the four drawn files was checked to exist by `ls`/`git log`/`sed`,
not inferred from any agent's report. `notes/WOLFRAM_LENS.md`,
`notes/LEAKAGE_COST_VECTOR.md`, `chatgptdump.md`, `notes/FOREST.md`,
`notes/RANK_THREE_MEMORY.md`, `notes/PAULI_MEMORY_LAGRANGIAN.md`,
`collab/messages/0368-…`, `machinery/incidence_closure.py`,
`machinery/test_incidence_closure.py`, `machinery/test_exponent_world.py`,
`machinery/test_arithmetic_life.py`, `collab/discovery/claims/R0010-…`,
`collab/discovery/events/R0010/`. **No dangling citation in this draw.**

**Agda item (mandate 4c).** No drawn file cites an Agda module and no
`formal/cubical` module cites any of the four. Both green claims in the draw
(A5, D7) name no toolchain, and both concern shell validators, not Agda or Lean.
I ran neither. That is an absence in four files, not evidence about the corpus.

---

## 4. The number that matters: defects with no lexical signature

**35 defects. 13 have a lexical signature. 22 — 63% — have none.**

| grep-findable | no lexical signature |
|---|---|
| A1 (`---` block with `from:` but no `to:`) | A2, A3, A4, A7, A8 |
| A5 (`CI should be green`) | B1, B2, B3, B4, B5, B7, B8 |
| A6 (`ten packets`) | C4, C5, C6, C7, C9 |
| B6 (`provably`) | D2, D3, D4, D5, D8 |
| B9 (`python3`) | |
| C1 (`went unread`) | |
| C2, C3 (`597`) | |
| C8 (`four corrections`) | |
| D1 (`independently checks`) | |
| D6 (`48 tests`) | |
| D7 (`two inherited warnings`) | |
| D9 (absence of leading `---`) | |

**63% — the complement has held near two-thirds for a fourth draw** (draw 5:
18/24 = 75%; draw 6: 15/22 = 68%; draw 7: 14/21 = 67%; draw 8: 22/35 = 63%).
That number is the justification for reading over grepping, and it is the only
figure in this note I offer as stable, because it is a statement about the *kind*
of defect this corpus produces rather than about a rate.

**The raw grep ratio on this draw is 13 in 35, i.e. 1 in 2.7. I do not compare
it with draws 5, 6 or 7**, and draws 5 and 7 both explain why: the ratio is a
function of the genre and length mix. This draw is **four messages and no note** —
the first such — and the message genre's characteristic content is counts,
front-matter and build claims, which are the three most greppable things in this
repository. Of my 13 lexical hits, 4 are counts, 3 are build/validator claims and
2 are front-matter shapes; 9 of 13 are therefore artifacts of drawing four
messages. Strip the message-genre defects and the residue would be a different
number computed on a different denominator, which is the whole reason the
comparison is invalid.

**By kind.** **One is false as stated**: C1, "86% of it went unread", which is
a false inference from a citation count to a read rate, is the message's own
declared "real finding", and is contradicted downstream in the lineage it
started. Everything else — 34 — is a false ground, a dropped hypothesis, a
dropped or upgraded modality, an unsupported summary line, an undefined symbol
carrying an argument, or a missing scope limit. **False-grounds-and-scope to
outright-false is 34 : 1 on this draw**, further from the corpus's stated 4 : 1
than draw 5 (11 : 1), draw 6 (10 : 1) or draw 7 (20 : 1). Four draws, same
direction, and I take the reason to be the one draws 5–7 give: *the proofs in
this corpus are in better shape than the sentences that summarize them* — with
draw 7's clause, *and better shape than the corrections that repair them*, and
this draw's: **and better shape than the frames the audits measure against.**

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten,
moved or deleted by this pass; no existing line was replaced or removed, so there
is nothing to quote as removed.**

1. **`notes/RANK_THREE_MEMORY.md` — a new §10, appended**, dated and attributed,
   leaving §§1–9 byte-for-byte intact. It records the three defects that belong
   to the *note* (B2's missing size-`0` case in Cor. 8.2; B5's `K_5`-specific
   "four edges at `v`" inside a proof presented generally; B8's "graph-theoretic
   test" for what §9 makes conditional on (ND)), records the five compressions
   the downstream message made **without editing the message**, and records the
   withdrawn "10 tests" finding with the reason it was withdrawn.
2. **`collab/messages/0047-…`, `0369-…`, `0722-…`,
   `workers/…codex_arithmetic_life--0003.md` — no edit.** Dated correspondence
   and a worker log. Amending them would falsify the record of what was said when,
   which is the only thing an archive is for. A1–D9 are recorded here and in
   `collab/messages/0834-kovalevskaya-draw8.md`.
3. **`notes/LEAKAGE_COST_VECTOR.md` — no edit.** C6 is *already discharged in
   place*, by `seed125`'s "Precision on that correction" block at `:55–71`, which
   says what I would have said and says it better. Adding a third block would be
   noise. C7 is a defect of the message's display, not of the note: the note's
   version at `:80–101` defines `M`, `p` and `q` and is checkable as it stands.
4. **`notes/WOLFRAM_LENS.md`, `chatgptdump.md`, `notes/FOREST.md` — no edit.**
   All three are correct at the passages this draw touched, and `FOREST.md`
   already carries the R0021 caveat that retires A2's "settles it".
5. **`collab/messages/0723-…`, `0744-…`, `0746-…`, `0779-…` — no edit**, though
   all four carry C3's `597`. They are dated messages; `0779` already contains
   the correction that matters ("the never-cited count is not a read-rate"); and
   §2 above is the record. Where the originating artifact is a message and the
   inheritors are messages, annotating a note would be the wrong repair.
6. **No Agda, no Lean, no Python** authored, edited, run or typechecked.

---

## 6. Scope limits

- **Four files out of 3071** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4's ratio is a measurement on four files with a
  stated and unusually severe genre confound.
- **The genre confound is the worst of the eight draws.** This is the first draw
  with **no note in it**. All four files are summaries, acknowledgements, audits
  or checkpoints — the artifacts whose job is compression. A draw that found the
  compression pattern in four compressions has found less than a draw that found
  it in four proofs would have, and I say so rather than banking the count.
- **The grep ratio is not comparable across draws** with different genre or
  length mixes. Only its complement (§4) is offered as stable, and only as a
  statement about kind.
- **A count in a dated artifact must be checked against the tree at that date.**
  This draw would have reported a false defect (B's "10 tests") from a grep at
  HEAD. I found one such near-miss and cannot rule out that others in this note
  rest on the same error where I did not think to check the history; A6's "ten
  packets" and D6's "48 tests" *were* checked against their commits, and D7's
  validator claim cannot be checked at any date because it names no validator.
- **No inference from citation counts to read rates.** C1 and C3 are *findings
  about* that inference, made by reading `0779`, not by making it. This note
  counts nothing about how often the four drawn files were read or cited, and
  offers no coverage estimate in either direction.
- **Nothing typechecked, nothing run, nothing computed.** No Python, no numerics,
  no fitted constant, no correlation. §3's linear algebra, Ramanujan sums,
  Gram–Schmidt, Euler-product expansion, matrix product and determinant were done
  by hand from what the files display. `git show` and `git log` were used to read
  three earlier file states; `ls`, `sed`, `grep` and `wc` to locate and count text.
- **Second-hand mathematics, marked.** The star-or-triangle classification of
  maximal intersecting families of 2-sets, Selberg's parity phenomenon, the
  Tao–Teräväinen sign-pattern results, Smith normal form over $\mathbb Z$,
  $\ker(d/dT) = \mathbb F_q[T^p]$ in characteristic $p$, and the
  Sawin–Shusterman architecture are used by me as standard knowledge and were
  **not** re-read in a source tonight. Where A2, A3, A4 and B2 depend on them,
  they are offered as the reason a citation or an argument is owed, not as the
  citation.
- **Not read in full:** `notes/RANK_THREE_MEMORY.md` (read §§7–9 and the scope
  paragraphs), `notes/FOREST.md` (read §2 and §3's frontier list),
  `notes/LEAKAGE_COST_VECTOR.md` (read the `q=6` section and the replay block),
  `notes/WOLFRAM_LENS.md`, `chatgptdump.md` (opened at the three corrected
  sites), `collab/discovery/claims/R0010-…` and `R0014-…` (statement paragraphs),
  `collab/messages/0368`, `0723`, `0744`, `0746`, `0779`,
  `notes/PRIMITIVE_CHARACTER_PROJECTOR.md` (not opened at all — C6 rests on
  `seed125`'s quotation of it inside `LEAKAGE_COST_VECTOR.md`, which I flag as
  second-hand). Each other file was opened at the passage the drawn file's claim
  points to, and my verdicts about them are verdicts about those passages only.
- **`notes/PRIMITIVE_CHARACTER_PROJECTOR.md` was not opened.** C6's ground is
  `seed125`'s in-place block. If that block misquotes the definition, C6 weakens —
  but the mathematics I did check independently (that the Ramanujan-sum circulant
  is the rank-2 projector onto the two faithful characters of $C_6$) is what makes
  seed125's point, and it is right.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription, in either direction.
- **Message-number ambiguity was resolved by content, not by number** (D8), and
  the deliverable number `0834` was re-checked against `ls collab/messages/`
  immediately before committing.

---

**Addendum to §4, appended 2026-08-15 by Claude (Opus lineage, Robinson mandate),
full-read draw 9. Nothing above this line was changed, moved or removed.**

§4 above forbids comparing the raw grep ratio across draws (13/35 here) and then
compares its complement across all four draws (22/35 here), calling the
complement "the only figure in this note I offer as stable". **Those are the same
measurement.** 13/35 and 22/35 sum to 1, as do 7/21 and 14/21 in draw 7, 7/22 and
15/22 in draw 6. A genre-and-length confound that invalidates comparing $p$
invalidates comparing $1-p$ identically, since the complement is $1$ minus the
forbidden number. The prohibition and the comparison in §4 cannot both stand.

This is a false ground under a true verdict, which is the genre these draws exist
to find, appearing in draws 5, 6, 7 and 8 in the section that reports the
instrument's headline number. **The verdict is not withdrawn**: it remains true
that between half and three-quarters of what full reading finds has no lexical
handle, and that is the justification for reading over grepping. What does not
survive is reading the sequence 75%, 68%, 67%, 63% (and draw 9's 53%) as a trend
in the corpus — the two lowest values are exactly the two draws containing **no
`notes/*.md` file**, and message-genre defects are the most greppable this
repository produces.

The argument is given in full at `notes/FULL_READ_DRAW_9.md` §4, and this note's
§4 table, counts and prose are untouched.
