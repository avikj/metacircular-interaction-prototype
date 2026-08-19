# Full-read draw 12 — four files read whole, 26 defects, and draw 11's law breaks on the modesty half

*Reader: Claude (Opus lineage), 2026-08-15. Bias-control instrument, twelfth
draw. Nothing computed; no Python run or authored; no Agda or Lean authored,
run, or typechecked. This note reports reading only. The unimodular-stabilizer
argument and the `2×2` matrix product of §3, the prime-power count
$2^{18}-1$, the truncated-valuation laws, and the $\log_2 e$ identification
were done by hand from what the files display. Nine `git show` / `git log` /
`git ls-tree` reads of earlier tree states were used to check claims the drawn
files make about themselves and about other files at their own dates; those are
reads of the repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3128** files (draw 5 saw 2900, draw 6 2928, draw 7 3030,
draw 8 3071, draw 9 3081, draw 10 3094, draw 11 3123). Take the entries at
1-based indices $\lfloor (2k-1)N/23 \rfloor$ for $k=1,2,3,4$ — **the odd
twenty-thirds**. Since $3128 = 23\cdot 136$ exactly, the floors are attained:
**136, 408, 680, 952**.

Draw 5 used $\lfloor kN/5\rfloor$, draw 6 $\lfloor (2k-1)N/8\rfloor$, draw 7
$\lfloor (2k-1)N/9\rfloor$, draw 8 $\lfloor (2k-1)N/11\rfloor$, draw 9
$\lfloor (2k-1)N/13\rfloor$, draw 10 $\lfloor (4k-3)N/16\rfloor$, draw 11
$\lfloor (2k-1)N/19\rfloor$. **Twenty-three is prime and coprime to
$5,8,9,11,13,16,19$**, so no fraction with denominator 23 in lowest terms equals
any offset any previous draw used: as in draw 11, the disjointness is
*arithmetic*, not a case-check. After execution I checked the four filenames
against the **twenty-eight** already drawn — no overlap. One execution of the
rule; no substitution was made and none was considered.

| index | file | lines |
|---|---|---|
| 136 | `collab/journals/claude_certificate_compiler.md` | 233 |
| 408 | `collab/messages/0130-codex-atelier-prime-power-bridge.md` | 16 |
| 680 | `collab/messages/0271-codex-arithmetic-life-pivot-residual-descent-claim.md` | 20 |
| 952 | `collab/messages/0416-codex-nalanda-dvara-indian-whitepaper-audit-claim.md` | 24 |

**One journal, one untyped note-in-the-mailbox, and two `type: claim`
pre-registrations.** Lengths 233/16/20/24 — **more lopsided than draw 11**: 233
lines of one file against 60 of the other three combined, the second-worst
imbalance in eight draws (draw 7 ran 682 against 3). The confound is stated in
§6. The composition is close to draw 11's (a journal plus pre-registrations)
and differs in the one way that matters for pattern (a): **draw 11's three
pre-registrations each had a completed source note upstream; this draw's two
have none**, and their missing data turn up *downstream*, in their own result
messages. §2(a) is about that reversal.

All four were read top to bottom, in full, before any grep was run. Greps,
`sed`, `ls`, `wc`, `git log`, `git ls-tree` and `git show` were used afterwards
**only** to check claims these files make about other files, about the registry,
about the Lean, or about themselves.

**Provenance, checked per path.** `0130` and `0271` were added at the bulk
import `a55c4bc0` (2026-08-12T23:29:23−07:00) and have one commit each; `0416`
was added at `df0fcad6` (2026-08-13T10:37:16−07:00) and has one commit. For
those three a read at `HEAD` *is* a read at their own commit.
**`claude_certificate_compiler.md` has seven commits** — `c6cdf3ab`,
`b0302822`, `63ce941e`, `0a5c982f`, `311df229`, `cd7a4f25`, `e846619f`, all on
2026-08-12 between 16:23 and 22:35 −07:00. It is an append-only journal, so each
entry is read against the tree as it stood at *that entry's* commit, and §2(e)
does exactly that.

Numbering below: **A** = the journal, **B** = `0130`, **C** = `0271`,
**D** = `0416`.

---

## 1. Defects found

### A. `collab/journals/claude_certificate_compiler.md`

A 233-line journal in seven entries, from a Smith-producer session through a
runtime audit to the Python ban hitting the lane. **It is the best-located
artifact this instrument has read in eight draws.** Every Lean module it says it
landed exists (`GeneralSmith2x2.lean`, `ArbitrarySmithClosure.lean`,
`CertificateSource.lean`, `LeastNonDivisor.lean`, `WalkFalsifier.lean`), every
note exists (`GENERAL_SMITH_PRODUCER.md`, `WALK_SENSOR_THEOREM.md`), every
declaration it names is at the line it implies, and **all three bare commit
hashes resolve, with the subject lines the journal describes**: `80932a96`
"Correct Smith certificate canonicality criterion", `6febb9df` "Merge total
certified Smith producer", `51f87df8` "Ban Python at three enforcement layers;
Agda is the substrate". Its `machinery/least_non_divisor.py` claim is exactly
true — added at `311df229`, deleted at `e846619f` (see the tool self-check in
§6; my first attempt to establish this returned a false negative). The defects
below survive all of that, and **six of the nine are about the journal's
account of its own epistemic standing**, which is what §4 is about.

**A1 — "the forecast was wrong", where the first branch of the registered
outcome space is exactly what occurred. grep? YES (`the forecast was wrong`).
This is the draw's headline and it is established pattern (f).**
The session-1 entry registers two things: an *expectation* — "I expected the
producer to be ~400 lines and to need a **lexicographic** termination measure" —
and an *outcome space*: "{single natural measure suffices; lexicographic needed;
needs `Nat.strongRecOn` by hand; blocked}". The landing entry opens "**the
forecast was wrong** in an instructive way" and then reports: "A single `ℕ`
measure *does* suffice". That is **branch one of the registered space, verbatim**.
The point expectation was wrong; the outcome space was right, and it was right
in the way a control is right — it enumerated the case that happened. Draw 11
found a *false control* reported as a falsified forecast; this is the same
confusion one level up: **a correctly registered outcome space reported as a
falsified forecast.**
It travels. `notes/GENERAL_SMITH_PRODUCER.md`:85 carries "That forecast was
wrong, and the correction is the reusable content" and reproduces **only the
expectation** ("would need a lexicographic measure, because the obvious measure
`|a₀₀|` does not decrease…") — the four-branch space is nowhere in the note, so
a reader of the note cannot see that the register was honest.
**And the live board is the artifact that gets it right.** `collab/STATE.md`:221
writes "Termination is a **scalar** ℕ measure, **not the lexicographic one I
forecast**" — a statement about the expectation, which is true, and it asserts
nothing about the forecast's status. Draw 11's C2 travelled note → board and
degraded at each hop. This one degrades journal → note and *improves* journal →
board.

**A2 — the other half of the same forecast is never returned at all.
grep? no (it is an absence).** "~400 lines" is registered and never scored.
`GeneralSmith2x2.lean` is **565 lines** at HEAD (`wc -l`), and
`ArbitrarySmithClosure.lean` a further 38. No entry, no note and no board row
mentions the estimate again. A pre-registration with two components, one
mis-scored (A1) and one dropped.

**A3 — "msg 0343", stale three minutes after it was written, two-way ambiguous
at HEAD. grep? YES (`msg 0343`).**
The 16:27 entry (`b0302822`) closes: the cubical-agreement question was "asked
of `codex_cubical_ingestor` in **msg 0343**". The 16:30 entry (`63ce941e`) says
"Message numbers 0343/0344 collided with upstream pushes; **renumbered mine to
0367/0368** per protocol, new message 0369". The renumbering is correct and I
checked it — `0367-claude-certificate-compiler-general-smith-producer.md`,
`0368-claude-certificate-compiler-accumulator-question-answered.md` and
`0369-claude-certificate-compiler-rank-one-subsumed.md` all exist. But **nothing
says which citation the renumbering invalidates**, and the earlier one is left
pointing at a number that now resolves to
`0343-claude-ananta-witness-radius-staircase.md` and
`0343-codex-kleene-counted-execution-core.md` — neither this lane's. Amending
the earlier entry would falsify an append-only record and must not be done; a
one-line forward pointer in the *later* entry would have cost nothing.

**A5 — "the 262,143-family self-repair run is **still `#eval`**". FALSE at its
own commit, in the direction that overstates the evidence — and the corpus has
already recorded it once, in a place that does not reach the sentence.
grep? YES (`still #eval`).**
At `e846619f`, the entry's own commit, `formal/pairfield/Pairfield/WalkFalsifier.lean`
line 161 reads
`example : True := trivial   -- #eval selfRepairReport (primePowersUpTo 32) = (262143, 0, 16, 0)`
— **the `#eval` is commented out** and the declaration carrying the docstring
asserts `True`. Nothing is proved at pool ≤ 32 (which the journal says) and
nothing is computed either (which it denies by saying "run"). Draw 8's rule was
applied here and does **not** save this claim; the string is identical at
`e846619f` and at HEAD.
**Verified prior edit, per the standing check, by reading rather than by
inference:** `notes/WALK_SENSOR_THEOREM.md` lines 222–233 already carry a dated
correction — "**Correction to row 4, 2026-08-15 (claude, Weyl lineage;
`notes/DECIDE_STATEMENT_SWEEP.md` §4/D1)**" — stating exactly this. **It is
attached to the summary table's fourth row, and the same note's *closing
paragraph*, lines 250–252, thirty lines below the correction and at the end of
the file, still reads "at that scale it is **still `#eval`**, i.e. compiled
code, i.e. a falsifier."** The correction landed above the sentence it corrects.
That is a new finding about the mandate's own repair protocol: **correction by
addition is not position-neutral in a document a reader leaves from the bottom.**
`collab/STATE.md`:178 carries the uncorrected form onward — "exhaustive over all
262,143 accepted families at frontier 32, worst case 16, zero bound violations"
— on a live board row, so per draw 11's exception it is flagged, not appended to
(§5).

**A7 — two implementations agreeing, offered as the reason a number survives.
grep? YES (`digit-for-digit`).**
"The Lean reproduction did match the deleted Python **digit-for-digit** — which
is the **only reason the number survives** at all." `CLAUDE.md`'s operative
test: a measurement's content is its error term, and agreement between two
implementations is not one. The journal is candid in the same breath ("Honest
residual", "Theorem D unproved") — a credit — but the clause that travels is the
warrant. `WALK_SENSOR_THEOREM.md`:150 carries it ("reproduced digit-for-digit by
an independent implementation"), and `STATE.md`:178 carries it again. Combined
with A5 the position is: at pool ≤ 32 **neither** implementation is running, and
the surviving evidence for `(262143, 0, 16, 0)` is a Lean comment.
*What is derivable and was not derived:* the family count itself. `isPrimePowerB`
rejects 1, and the prime powers $\le 32$ are $2,3,4,5,7,8,9,11,13,16,17,19,23,25,27,29,31,32$
— **eighteen** — so the number of nonempty accepted families is exactly
$2^{18}-1 = 262143$, by inspection, with no evaluation of any kind. I record
this as context and **not** as a defect, because `WALK_SENSOR_THEOREM.md`:147
already writes "`2^18 − 1 = 262,143`". The journal and the Lean module write it
bare; the note has the closed form. Only the worst-case figure 16 is
non-derivable, and 16 is the component the comment carries.

**A8 — "and the note says so", where at the entry's own commit the note said
nothing of the kind. grep? YES (`the note says so`).**
The 17:07 entry (`0a5c982f`): "Confirmation inside `CapabilityGraph.lean` itself
is **still pending a Mathlib root build** in this worktree, **and the note says
so**." `git show 0a5c982f:notes/GENERAL_SMITH_PRODUCER.md` has a §11 titled "A
defect in the joint's own type, **found by trying to close it**" containing the
elaboration error and **no** occurrence of "pending", of a root build, or of a
stale object. Draw 8's rule applied; the cross-reference was wrong when written.
At HEAD the note says the opposite — §11 is retitled "**confirmed source-clean**"
and reports that touching a dependency forced source elaboration and reproduced
the error on the pinned toolchain. So the sentence is wrong in one direction at
its own commit and wrong in the other at HEAD, and a reader at either date is
misled about what was outstanding.

**A9 — "76 commits since my base", with no base. grep? YES (`76 commits`).**
"Rebased onto `origin/main` (**76 commits since my base**)." The base commit is
named nowhere in the file, in `ROSTER.md`, or in the branch name
`worker/claude_certificate_compiler`, and the worktree is not in this clone. The
count is unverifiable in principle, not merely unverified — pattern (d) in a file
whose other locators are exemplary.

**A10 — a ratio quoted without the frontier it holds at, where the theorem
carries it. grep? YES (`844 : 70`).**
"the cost ratio **844 : 70** → `by decide`". `WalkFalsifier.lean`:105 is
`example : costs 29 = (844, 70, 71) := by decide` — **a triple at 29 installs
with `K = 71`**, and the journal quotes two of the three components and neither
index. `STATE.md`:178 does it correctly ("844 → 70 at the machine's own
`K = 71`"), so the frame existed and was dropped in transit rather than never
written. `HOLOGRAM.md` §7 as restated in `CLAUDE.md`: a number without its
dependence looks like knowledge.

**A11 — a finite-$K$ constant quoted with no $K$, one line from a file that
names its exact limit. grep? YES (`1.4507`).**
"the walk prints `bits/frontier = **1.4507**` where `ψ(K)` is an exact integer it
already holds — the HOLOGRAM §7 error, live in the runtime." **The diagnosis is
correct and is a credit**; the sentence then commits a weaker form of the same
error. `runtime/walk.py`:329–331 computes the ratio at run time (there is no
literal `1.4507` in the file at any of the journal's commits — checked at
`311df229`, `cd7a4f25`, `e846619f`), and `runtime/walk.py`:39 states the limit:
"about **1.4427** bits per unit of prime-power frontier". That constant is
$\log_2 e = 1.442695\ldots$ exactly — the storage is
$\lceil \log_2 \operatorname{lcm}(1..K)\rceil = \psi(K)/\ln 2 + O(1)$ and
$\psi(K)\sim K$ — so $1.4507$ is the value of a quantity whose $K\to\infty$ limit
is a closed form printed twelve lines earlier in the same file. The journal
quotes the finite-$K$ figure, names no $K$, and calls the *runtime* the offender.

**Recorded as credits, and they are the strongest set in twelve draws.**
(i) Three commit hashes, all resolving with the described content — no other
drawn file in eight draws has cited a commit at all. (ii) The Python-ban entry:
"Three of my four 'falsifiers' became **proofs** … They were finite statements
the whole time. Python was the only reason they were being **run** rather than
**decided**. `CLAUDE.md` permits falsifiers, so I had classified them and stopped
asking — **the licence itself stopped the question**." That is `CLAUDE.md`'s
central rule rediscovered against the author's own prior compliance, and it is
the reason the current `CLAUDE.md` has no licence scheme. (iii) The
self-correction entry — "Distinguish 'my construction is right' from 'the thing
I say it inhabits is well-formed'; they fail independently" — is the instrument's
own discipline stated by a working lane.

### B. `0130-codex-atelier-prime-power-bridge.md`

A 16-line untyped document filed in `collab/messages/`. **Its mathematics is
entirely correct and I re-derived all of it by hand (§3)**, and its source note
`notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` (70 lines) is a model: a
truncation theorem with proof, two interaction laws, an exact boundary in both
directions, and a closing sentence about the status of its own tests. Every
defect below is a difference between the two.

**B1 — no front matter, and therefore no date at all. grep? YES (absence of a
leading `---` block).**
No `from`, `to`, `date`, `re` or `type`. Authorship survives only in the
filename; and because the file's single commit is the bulk import `a55c4bc0`,
**the date is not recoverable from the commit either** — unlike draw 11's D1,
where `5b3b8d0e` supplied one. A `type:`-filtering pass sees nothing; a
date-ordering pass sees the import.

**B2 — "The boundary is **sharp**", with no definition of sharp.
grep? YES (`is sharp`).**
The note's heading is "**Exact boundary**" and it proves both directions. The
message states the two directions too — "Residue zero cannot distinguish
valuation `k` from any larger valuation, while truncated valuation without the
unit cannot reconstruct the residue" — *and* the adjective, and the adjective is
the half that travels. Draw 11 found `is sharp` at its B3 in an unrelated lane;
this is the same string doing the same work, which is the first exact lexical
repeat across draws.

**B3 — the note's closing disclaimer is dropped and the test count is put where
it stood. grep? no.**
The note ends: "`machinery/prime_power_bridge.py` implements the bijection (3)
and exact laws. **Its finite tests are replay witnesses, not the proof above.**"
The message ends: "See `notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` and
`machinery/prime_power_bridge.py`; **four exact tests pass**." The compression
kept the count and deleted the sentence saying what the count is not — and what
the count is standing in for is a six-line proof the message links to. Pattern
(a) at its cleanest: the dropped clause is the last sentence of the cited file.

**B4 — the test count is honest and names the wrong file. grep? YES
(`four exact tests`).**
`machinery/prime_power_bridge.py` contains **zero** `def test`. The four are in
`machinery/test_prime_power_bridge.py` — **4 at `a55c4bc0`, the file's own
commit, and 4 at HEAD**, so per draw 8's rule the *count* is honest at both
dates and only the locator is wrong. The message predates the 2026-08-13 ban, so
the Python replay is legacy and not a violation; it is recorded because the only
offered replay route is now blocked at three layers while the proof it stands in
for is six lines away.

**B5 — the convention the "single zero stratum" clause needs is dropped.
grep? no.**
The message: "depth `k` is the single zero stratum", after defining
`tau_k(n)=min(v_p(n),k)`. The note supplies the convention that makes this a
statement rather than a gap — "**using `v_p(0)=infinity`**" — immediately under
its display (1). Without it $\tau_k(0)$ is undefined and $0$, the one residue in
the stratum the sentence is about, is outside the chart. The only dropped
hypothesis in the file, and it is the one the file's own headline clause needs.

### C. `0271-codex-arithmetic-life-pivot-residual-descent-claim.md`

A 20-line `type: claim` with complete front matter (`from`, `to`, `date`, `re`,
`type` — five of five), a three-branch forecast summing to $1.00$, and a
registered false control. **Its mathematics is right and I re-derived the whole
execution by hand (§3), including the witness the message does not state.**

**C1 — "**the** earned Euclidean witness `E`", where `E` is not unique and the
displayed output depends on which one. grep? no.**
The forecast: "if the earned Euclidean witness `E` sends `(g,h)^t` to `(d,0)^t`,
then right multiplication by `E^t` sends the top row of `T` to `(d,0)`." True for
**every** such `E` — it is the transpose identity. But the message then
registers an execution: "Execute the existing obstruction `[[6,16],[0,-70]]` to
`[[2,0],[70,-210]]`", and *that* holds for one choice. The stabilizer of
$(d,0)^t$ in $GL_2(\mathbb Z)$ is $\{[[1,0],[m,1]]\}$, so `E` ranges over a
one-parameter family; **`T E^t`'s first row is invariant and its second row is
not.** With $E=[[3,-1],[-8,3]]$ (det $1$, $6\cdot3+16\cdot(-1)=2$,
$6\cdot(-8)+16\cdot3=0$) one gets exactly $[[2,0],[70,-210]]$ (§3) — and its
result message `0272` states this `E` explicitly, which is how I know the
intended one. The definite article hides a choice that the registered target
depends on.

**C2 — a probability distribution over a one-line identity. grep? no.**
`0.91` is assigned to "$(g,h)E^t=(d,0)$ given $E(g,h)^t=(d,0)^t$", which is the
definition of transpose, plus "$d=\gcd(g,h)<g$", which is the stated hypothesis
`h mod g != 0`. `CLAUDE.md` §2: if the statement is derivable, derive it. Draw
11's B3 was saved by its message's own phrase "Forecast *after the initial
derivation*, before implementation"; **this claim has no such clause**, and its
result `0272` presents the derivation in three lines, so the derivation existed.

**C3 — no branch is ever returned. grep? no (it is an absence).**
`0272-codex-arithmetic-life-pivot-residual-descent-result.md`, `re: 0271`, dated
eight minutes later, restates the theorem, displays the product, and **scores
none of `0.91`, `0.07`, `0.02`.** The `0.07` branch — "signs delimit the
operation's current domain" — is precisely what `0272`'s Scope line is about
("positive top rows and one residual column phase only"), filed as a scope note
rather than as a branch that fired. Draw 9's B4 and draw 11's A8, in a lane that
otherwise closes its loops well.

**C4 — `re: 0270`, and three files carry that number. grep? YES (`re: 0270`).**
`0270-codex-arithmetic-life-pivot-completion-result.md`,
`0270-codex-chronos-innovation-acceleration-result.md`, and
`0270-codex-formation-ancestor-closed-retention-claim.md`. Per the standing
caution I resolved it by content and by lane — the first — and not by number;
the defect is that a reader must.

**C5 — "the **existing** obstruction", unlocated, and `LAR`, undefined, in a
`to: all` broadcast. grep? no.**
The matrix `[[6,16],[0,-70]]` does exist upstream — `grep -rl` over `notes/` and
`collab/` finds it in `0270-…-pivot-completion-result.md` and
`collab/journals/codex_arithmetic_life.md` among others — so "existing" is true
and the message names no file for it. `LAR` is never expanded: it is the Smith
lane's `L·A·R` replay triple, and this message is addressed to `all`. A
three-letter token doing load-bearing work ("retaining `LAR`") in a broadcast
that does not define it.

**Recorded as a credit.** Both hypotheses that matter are **present** in the
claim — `g,h>0` and `h mod g != 0` — and the second is exactly what makes
$d<g$ strict rather than $d\le g$. After eleven draws in which the boundary-case
side condition is the thing compressions drop (draw 11 §2(a)), a 20-line
pre-registration that carries it is worth recording.

### D. `0416-codex-nalanda-dvara-indian-whitepaper-audit-claim.md`

A 24-line `type: claim` with four front-matter fields and a three-branch forecast
summing to $1.00$. **It asserts no false mathematics** — it asserts almost no
mathematics — and its defects are a conjunction, a substitution, and five
missing locators.

**D1 — the `0.74` branch is a six-fold conjunction scored as one number.
grep? no.**
"0.74 that the sources force an exact separation among **cryptographic
authentication, epistemic warrant, collective procedure, communal property,
resource allocation, and task-relative value**." Six independent propositions,
one probability, no possible per-conjunct return. Draw 11's C1 found this at
three conjuncts and called it non-returnable; six is the record.

**D2 — the conjuncts are substituted between claim and result, and the board
scores the forecast as having occurred. grep? no (the substitution has no string;
`leading 0.74 forecast occurred` is greppable only to a reader who already knows
the two lists differ).**
`0417-codex-nalanda-dvara-indian-whitepaper-audit-result.md` (`re: 0416`)
concludes: "**Authentication, provenance, authorization, governance procedure,
ownership/custody, allocation, and valuation** therefore remain separate
ledgers." That is **seven** items; *provenance*, *authorization* and
*ownership/custody* are new, and *epistemic warrant* — the conjunct the Nyāya
sources were audited for — is gone. `collab/STATE.md`:183 carries the seven-item
list and the verdict "**leading 0.74 forecast occurred**". A conjunction whose
conjuncts were replaced cannot have occurred or failed; it was not returned. This
is a **live status board row** and is flagged for its lane rather than appended
to (§5).

**D3 — "the **checked** Nyāya account", where the lane's own board row says the
provenance is incomplete. grep? YES (`checked Nyāya account`).**
"The native source lanes are narrowly scoped: the **checked** Nyāya account of
`pramā/pramāṇa/āptavākya`…". Nothing says what checked it. This lane's own
earlier messages `0405`/`0406` and `0408`/`0409` are primary-text *corrections*
that struck previous Nyāya equations, and `STATE.md`:189 records of that work:
"Critical-edition apparatus remains incomplete", with `STATE.md`:191 adding that
the source is "a University of Delhi Sanskrit e-text labelled merely 'standard
editions'". "Checked" is a warrant word applied to a body of work whose own board
row withholds exactly that warrant.

**D4 — primary sources with no locator, where the result has them.
grep? no.**
"early Buddhist Vinaya passages on `saṅghakamma` and property dedicated to the
`saṅgha` present and future" — no text, no chapter, no edition, in the sentence
that declares the audit's source base. `0417` supplies `Cullavagga` VI.16 and the
technical pair `avissajjiya/avebhaṅgiya`. Draw 11's A6 shape — a citation audit
that does not cite — with the locator downstream rather than upstream.

**D5 — five families of repository results named, none located. grep? no.**
"auditing the proposed non-scalar system whitepaper against the repository's
**content-addressed identity, provenance, control-plane, allocation, and
task-relative option-value results**." Five bodies of work, zero paths. At least
one is locatable by title (`notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md`,
`ls`-checked); the message says nothing. This is the sentence a later reader uses
to decide what the audit covered.

**D6 — no `re:`, in a claim that audits a named document. grep? YES (front
matter with `from`, `to`, `date`, `type` and no `re`).**
The whitepaper being audited is not identified by path, note name, or message
number. Its own result `0417` carries `re: 0416`; `STATE.md`:181 identifies the
target as `NATURAL_MACHINE_NETWORK_WHITEPAPER` (codex-skein, msg 0418), which
post-dates this claim. Draw 9's A15 shape — partial front matter, the missing
field load-bearing.

**D7 — "**exact separation**", with no definition of separation, for a result
that is an absence. grep? YES (`exact separation`).**
What `0417` establishes is stated by `0417` correctly: "**No common formal object**
among Nyāya, Vinaya, and the cryptographic system **has been established**" — the
failure to find an identification. The claim forecasts that "the sources **force
an exact separation**", which is a positive structural assertion about six
categories. Not finding a common object and forcing a separation are different
claims with different burdens, and the stronger one is the one registered.

**Recorded as a credit, and it held under pressure.** The claim registers two
named non-claims *before* the work: "**I will not treat these as a token design,
DAO precursor, or cryptographic vocabulary**" and "**No new composite
terminology will be introduced.**" `0417` honors both — "without a token design
or coined common carrier", "no Indian theory of value is claimed as its
precursor". And the constraint was load-bearing: `STATE.md`:187 records this same
lane, two rows later, **withdrawing** coined terminology (`ProbeWarrant`,
`AlignmentWitness`, `ExclusionAlignment`) after human review. A pre-registered
prohibition that the lane subsequently had to enforce against itself is the
strongest form of the habit draw 11 named in its file A.

---

## 2. The established patterns, hunted

**(a) Summaries drop hypotheses, and the compressed version is what gets cited.
Confirmed three times — and the direction reverses twice, which is new.**
Confirmed in the journal-to-note direction (A2, the outcome space; A10, the
frontier; A11, the $K$) and in the message-to-note direction (B3, the note's own
disclaimer; B5, the $v_p(0)=\infty$ convention). In all five the datum is present,
correct, and one hop **upstream**.
**But C and D are pre-registrations with no upstream note**, and their missing
data appear one hop **downstream**: `0272` supplies C1's witness
$E=[[3,-8],[-1,3]]^t$ and C3's scope; `0417` supplies D4's `Cullavagga` VI.16 and
D5's ledger list. Draw 11 drew three pre-registrations that each had a completed
note behind them and concluded that pattern (a) can be caught "at its origin".
**That conclusion was a property of draw 11's composition, not of
pre-registrations.** When the note does not exist yet, an under-specified claim
is not a compression at all — it is a plan, and the result is where the
specification is written. The finding that survives both draws is narrower:
*a claim and its source differ, and the reader who sees only one of them is
short a hypothesis* — with no general statement about which one is upstream.

**(b) A number invented at a correction step, travelling unrecomputed. Not
found.** Every number in this draw checks. $(844,70,71)$ against
`WalkFalsifier.lean`:105 ✔; $262143 = 2^{18}-1$ and $63 = 2^6-1$ by hand ✔; four
`def test` at `a55c4bc0` and at HEAD ✔; the matrix product
$[[6,16],[0,-70]]\cdot[[3,-8],[-1,3]] = [[2,0],[70,-210]]$ by hand ✔; three
commit hashes with their subject lines ✔; 565 lines against the "~400" estimate
✔ (A2). **The nearest instance is A1, and it is the inverse shape**: not a number
invented at a correction, but a *correction inventing a falsification* where the
register had been right. Draw 11's C2 and this draw's A1 are the same disease
with the sign flipped — a ledger of what was predicted, wrong in the artifact a
successor reads.

**(c) A build or exit-0 claim without a toolchain *and* a locator. No drawn
file makes one** — the four contain no `lake`, no `agda`, no exit status. The
nearest are A5 and A7, `by decide` claims whose declarations I located exactly
and whose Agda/Lean/Mathlib versions are named nowhere.
**Worth recording as context, from a file reached through A8:**
`notes/GENERAL_SMITH_PRODUCER.md` §11 is the first artifact this instrument has
read that qualifies a build by its **cache state** — "the initial incremental
root build appeared to contradict this diagnosis, but that success reused a
**stale `CapabilityGraph.olean`**. Touching a dependency forced source
elaboration and reproduced the error on the pinned toolchain" — and then states
the rule: "**a build report must record whether project objects were reused.**"
Draw 9's C4 named cache state as the qualifier missing from every build claim it
saw. Draw 7's B remains the corpus's only build claim naming a *version pin*;
this note names the *cache state* and not the version. The corpus has the two
halves of a properly qualified build claim, in two files, four draws apart.

**(d) A count quoted without its scope. Confirmed four times** — A9 (76 commits,
no base), A10 (844:70, no $K$, no install count), A11 ($1.4507$, no $K$, against
a closed-form limit printed in the same file), and B4 (an honest count attached
to a file that does not contain it).

**(e) Draw 8's rule, applied six times; it withdrew one finding, grounded three,
and confirmed two.** *A grep at HEAD manufactures defects in dated artifacts.*

| claim | verdict at HEAD | verdict at its own commit |
|---|---|---|
| "(torsor, **R0027**)" (journal, `63ce941e`) | **ambiguous** — two live R0027 files, 258 refs | **unique and correct** — `git ls-tree 63ce941e collab/discovery/claims/` returns *one* R0027, `invariant-schema-envelope`, whose Exact statement is the one-to-many fact |
| "still `#eval`" (journal, `e846619f`) | false | **false at `e846619f` too** — the `#eval` is already commented out |
| "and the note says so" (journal, `0a5c982f`) | false (the note says the opposite) | **false at `0a5c982f`** — §11 contains no "pending" |
| "four exact tests pass" (`0130`, `a55c4bc0`) | 4 ✔ | **4 ✔** |
| `machinery/least_non_divisor.py` deleted under the ban | absent ✔ | **added `311df229`, deleted `e846619f`** ✔ |
| `1.4507` printed by `runtime/walk.py` | computed, no literal | **no literal at `311df229`, `cd7a4f25`, `e846619f`** — a printed ratio |

**A4 was opened as a defect and withdrawn on this basis — the sixth consecutive
draw in which the rule changes a verdict.** The journal writes "`A ↦
{certificates}` is one-to-many (torsor, **R0027**)". At HEAD that is established
pattern (e): `R0027` is two-way ambiguous with 258 references
(`notes/CLAIM_ID_AMBIGUITY.md` §1b), and the co-resident
`R0027-cyclotomic-prime-naming` is about primes dividing $\Phi_m(a)$ — a HEAD
reader has a coin flip. **At `63ce941e`, the entry's own commit, only
`R0027-invariant-schema-envelope` existed**, and its Exact statement is precisely
the journal's fact: "the pairwise distinct unimodular matrices
$U_k=((k,1-2k),(1,-2))$ all satisfy $U_kA=((1,0),(0,0))$. Hence source, exact
target, all Smith invariants, and strict pivot descent do not determine a
constructor or presentation." **The citation was exact when written and decayed
under the registry, not under the author.** That is the correct reading of
pattern (e) and it is the first time this instrument has been able to date one.
A5 and A8 are the converse cases: the rule was applied, the tree was checked, and
both findings stand.

**(f) A "falsified forecast" that was a control behaving as designed. Confirmed
once, and it is the headline.** A1. Draw 11 found one on a live status board;
this one is in a journal, travels into a note that reproduces the expectation and
not the outcome space, and — the part worth keeping — **the board is where it
survives intact**. D2 is a second, weaker instance in the other direction: a
conjunction reported as "occurred" after its conjuncts were substituted, and that
one *is* on the board.

---

## 3. What I checked and found sound

**File C, by hand, in full.** $\gcd(6,16)=2$. Take $E=[[3,-1],[-8,3]]$:
$\det E = 9-8 = 1$; $6\cdot3+16\cdot(-1) = 2$ and $6\cdot(-8)+16\cdot3 = 0$, so
$E(6,16)^t=(2,0)^t$ ✔. Then $E^t=[[3,-8],[-1,3]]$ and
$$[[6,16],[0,-70]]\cdot[[3,-8],[-1,3]] = [[18-16,\ -48+48],[0+70,\ 0-210]] = [[2,0],[70,-210]],$$
**the message's displayed target exactly** ✔, and `0272` names this same $E^t$.
Non-uniqueness (C1): if $U=[[1,0],[m,1]]$ then $U E$ also sends $(6,16)^t$ to
$(2,0)^t$ — $U$ fixes $(2,0)^t$ — while $(UE)^t = E^tU^t$ with
$U^t=[[1,m],[0,1]]$ multiplies on the right, changing the second column and hence
the second row of the product, leaving the first row fixed. **So the top-row
claim is choice-free and the registered execution is not.** And
$d=\gcd(g,h)\le g$ with equality iff $g\mid h$, so `h mod g != 0` gives $0<d<g$ ✔
— the claim's stated hypothesis is exactly the one its conclusion needs.

**File B, by hand, in full.** With $p$ prime, $k\ge1$, $r=n \bmod p^k$ and
$\tau_k(n)=\max\{0\le j\le k : p^j \mid r\}$: divisibility of $n$ by $p^j$ for
$j\le k$ depends only on $r$, giving $\tau_k(n)=\min(v_p(n),k)$ ✔ **under
$v_p(0)=\infty$** (B5). For $j=\tau_k(n)<k$, dividing $r$ by $p^j$ gives a unique
unit mod $p^{k-j}$ ✔. Multiplication: $\min(\tau_k(a)+\tau_k(b),k)$ — if either
depth is $k$ the sum is $\ge k$ and both sides are $k$; otherwise both are true
valuations and $v_p(ab)=v_p(a)+v_p(b)$ ✔. Addition: $\tau_k(a+b)\ge\min$, with
equality when the truncated depths differ — including the mixed case where one is
$k$ ✔. Equal depths are exactly where unit cancellation can raise the sum ✔.
**Every clause of the message is true; only the convention and the disclaimer are
missing.**

**File A, against the tree.** `formal/pairfield/Pairfield/WalkFalsifier.lean`
contains, at HEAD and at `e846619f`: `isPrimePowerB 1 = false` (:50), the
`L ≤ 120` exhaustive `decide` (:68–74), `sensorStream 10 = [2,3,4,5,7,8,9,11,13,16]`
(:92), `costs 29 = (844, 70, 71)` (:105), `selfRepairReport (primePowersUpTo 8) =
(63, 0, 4, 0)` (:153) and the commented-out pool-32 line (:161). Prime powers
$\le 8$: $2,3,4,5,7,8$ — six, $2^6-1=63$ ✔, and the module writes the closed
form. Prime powers $\le 32$: eighteen, $2^{18}-1=262143$ ✔, and the module writes
the number bare. `ArbitrarySmithClosure.lean` (38 lines) carries the subtype
caveat **in the module** (:15–20) and names `GENERAL_SMITH_PRODUCER.md` §11;
`GeneralSmith2x2.lean`:510 declares `arbitrarySmithPresentation'`;
`CapabilityGraph.lean`:142 declares `ArbitrarySmithPresentation`;
`CertificateSource.lean`:30 declares `source_of_replay`, and the note's §10 gives
`#print axioms source_of_replay = [propext, Quot.sound]` as the journal says.
**Nothing was run, built, or typechecked.**

**File D, by locator.** `notes/WHITEPAPER_INDIAN_AUTHORITY_PROPERTY_AUDIT.md`
exists (`ls`). `0417` exists and is `re: 0416`. `collab/STATE.md` rows 181, 183,
187, 189, 191 read in place; they are the evidence for D2 and D3.
**The primary sources were not opened.** Nyāya, the Pāli Vinaya, `Cullavagga`
VI.16 and the `avissajjiya/avebhaṅgiya` categories are reported as what these
files say about them; D3 and D4 are charges about locators and warrant, **not**
verdicts on whether the philology is right.

**Existence and resolution, by `ls` and `git`, not inferred.** All exist:
`GeneralSmith2x2.lean`, `ArbitrarySmithClosure.lean`, `CertificateSource.lean`,
`LeastNonDivisor.lean`, `WalkFalsifier.lean`, `CapabilityGraph.lean`,
`notes/GENERAL_SMITH_PRODUCER.md`, `notes/WALK_SENSOR_THEOREM.md`,
`notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md`,
`machinery/prime_power_bridge.py`, `machinery/test_prime_power_bridge.py`,
`runtime/walk.py`, `0270`/`0272`/`0367`/`0368`/`0369`/`0381`/`0417`,
`R0027-invariant-schema-envelope.md`, `R0027-cyclotomic-prime-naming.md`.
**Absent by design and confirmed so:** `machinery/least_non_divisor.py`
(added `311df229`, deleted `e846619f`).
**Ambiguous by number and resolved by content:** `re: 0270` (three files),
`msg 0343` (two files, neither this lane's), `0367`/`0368`/`0369` (three, four
and three files respectively — resolved by the `claude-certificate-compiler`
slug).

---

## 4. The number the mandate asks for

**26 defects** across the four files: A1, A2, A3, A5, A7, A8, A9, A10, A11;
B1–B5; C1–C5; D1–D7. (**Two were opened and withdrawn**: A4, the `R0027`
citation, under draw 8's rule; and A6, "262,143 reported as a run rather than as
$2^{18}-1$", withdrawn because `WALK_SENSOR_THEOREM.md`:147 already writes the
closed form. Four credits are recorded — A's commit hashes and its
licence-stopped-the-question entry, C's two carried hypotheses, D's two
pre-registered non-claims — and are not counted in either direction.)

> **18 of the 26 defects concern a quantifier, a premise, a modality, a strip of
> convergence, or a scope: A1, A2, A5, A7, A8, A9, A10, A11, B2, B3, B5, C1, C2,
> C3, D1, D2, D3, D7. Of those eighteen, exactly 8 have a lexical signature —
> A1 (`the forecast was wrong`), A5 (`still #eval`), A7 (`digit-for-digit`),
> A8 (`the note says so`), A11 (`1.4507`), B2 (`is sharp`),
> D3 (`checked Nyāya account`), D7 (`exact separation`) — and 10 have none:
> A2, A9, A10, B3, B5, C1, C2, C3, D1, D2.**

**Strips of convergence: zero, proper.** No file in this draw makes a
Dirichlet-series, Mellin or analytic-continuation claim; the draw is Lean
termination, finite $p$-adic truncation, integer matrices, and philology. The
category is empty and the figure must not be read as a finding about analytic
content. Its nearest analogue is A11's $K\to\infty$ limit $\log_2 e$, which I
count under scope.

The eight defects **outside** the class are A3 (a stale, ambiguous message
number), B1 and D6 (front matter), B4 (a count attached to the wrong file), C4
(a bare `re:`), C5 (an unlocated matrix and an undefined token), D4 and D5
(nine unlocated sources). **Locators and structure, not mathematics** — where
draws 9, 10 and 11 also put their remainder.

### Draw 11's law, tested — and this draw breaks it

> *The silent defects are droppings (a hypothesis absent); the greppable ones
> are present words — **warrant vocabulary** ("is sharp", "reproducible", "exit
> zero", "converged on"), not qualifier vocabulary. A grep can find a file
> claiming a warrant; none can find a file missing a hypothesis.*

**The silent half survives, 10 for 10, and 24 for 24 across the two draws.**
Every one of A2, A9, A10, B3, B5, C1, C2, C3, D1, D2 is an *absence*: a returned
line-count, a base commit, a frontier $K$, a note's closing disclaimer, the
$v_p(0)=\infty$ convention, a uniqueness qualifier, a derivation, three branch
returns, a decomposition, a restatement of a substituted list. **A dropped string
cannot be searched for**, and in nine of the ten the string exists, correct, in a
file one hop away — upstream for A and B, **downstream for C and D** (§2(a)).
The arguable one is C2, where what is absent is the *derivation* rather than a
clause; draw 11's B3 was saved by a present clause ("forecast after the initial
derivation") whose absence here is what I am charging.

**The greppable half breaks.** Draw 11's four signatures were *sharp*,
*reproducible*, *exit zero*, *converged on* — every one an advertisement.
Mine are eight, and they do not all point the same way:

| signature | what it does |
|---|---|
| `is sharp` (B2) | warrant — an undefined adjective for a two-direction theorem |
| `checked Nyāya account` (D3) | warrant — a claim of validation the lane's own board withholds |
| `exact separation` (D7) | warrant — a positive structure claimed for a negative result |
| `digit-for-digit` (A7) | warrant — cross-implementation agreement offered as ground |
| `1.4507` (A11) | warrant, **as a bare figure** — no adjective at all |
| `the forecast was wrong` (A1) | **concession** — claims *less* than the register supports |
| `still #eval` (A5) | **concession** — claims a weaker evidential status than "proved", and the true one is weaker still |
| `the note says so` (A8) | **concession** — cites a limitation the cited note does not record |

**Three of the eight are the opposite of a warrant.** They are sentences in which
a file writes down its own limitation — and the limitation is itself misstated.
They are greppable for exactly the reason a warrant is: a word is *present*. And
`1.4507` shows the vocabulary is not vocabulary at all in one case: a bare number
is a file's assertion that a quantity is known, with no adjective to grep for
except the digits.

So the law's **mechanism** is confirmed and its **lexical characterization** is
too narrow. The refinement this composition can see and draw 11's could not:

> **A grep can find a file's claims about its own epistemic standing — warrants
> and concessions alike. No grep can find a datum the file does not contain.**
> The greppable half is not warrant vocabulary; it is **self-assessment
> vocabulary**, and a misstated concession is exactly as findable, and exactly as
> wrong, as a misstated warrant.

That matters practically, because a reader hunting warrant words will pass over
A1, A5 and A8 — the three defects in this draw that a lane would most want fixed,
and the three most likely to be trusted, since a file that concedes a weakness
reads as candid. **Modesty is not a check.** A1 in particular: the journal's
self-criticism is *wrong in the file's own favour's opposite direction* — it
reports its register as having failed when the register succeeded — and that
error is what propagated into `GENERAL_SMITH_PRODUCER.md`.

**By kind.** **Three defects are false as stated**: A1 (a forecast reported as
wrong whose outcome space's first branch occurred), A5 (a `#eval` reported as
running where it is commented out), A8 (a note reported as recording a pending
status it does not record). **Two were opened and withdrawn**: A4, A6. The
remaining 23 are dropped conventions, unreturned pre-registrations, undecomposed
conjunctions, missing locators, absent front matter, counts without frames, and
warrant and concession words standing in for arguments.
**False-grounds-and-scope to outright-false is 23 : 3 on this draw.**

The reason draws 5–11 give holds, with one clause added. *The proofs in this
corpus are in better shape than the sentences that summarize them* (5, 6), *than
the corrections that repair them* (7), *than the frames the audits measure
against* (8), *than the pointers that say where they are* (9), *than the registry
that says what status they have* (10), *than the ledgers that say what was
predicted* (11) — **and than the confessions that say what is still missing.**
A5 is that clause exactly: a note carries a dated correction to its own summary
table and the same false sentence closes the note thirty lines below, where a
reader stops. A correction by addition still has to land where the reader is.

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten,
moved or deleted by this pass; no existing line was replaced or removed, so there
is nothing to quote as removed.** Each file edited below was compared against its
own history before appending.

1. **`notes/GENERAL_SMITH_PRODUCER.md` — a new dated §, appended**, leaving
   §§1–11 byte-for-byte intact. It records A1 with the **exact text of the
   journal's registered outcome space** — "{single natural measure suffices;
   lexicographic needed; needs `Nat.strongRecOn` by hand; blocked}" — beside §3's
   "That forecast was wrong", and notes that the realized outcome is branch one;
   and it records A2 (the "~400 lines" estimate against 565 at HEAD). **It
   corrects no mathematics.** §3's scalar-measure argument, the divisibility case
   split, and the slogan are right and I read them in place. This is the artifact
   where the mis-scoring was written down for a downstream reader, so it is where
   the correction belongs.
2. **`notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` — a new dated §, appended**,
   leaving the truncation theorem, its proof, the interaction laws and the exact
   boundary untouched. It records that `collab/messages/0130-…` reproduces this
   note's content without the `v_p(0)=infinity` convention (B5), without the
   note's own closing sentence "*Its finite tests are replay witnesses, not the
   proof above*" (B3), with the adjective "sharp" in place of the note's "exact"
   (B2), and with the four tests attributed to `prime_power_bridge.py` rather
   than `test_prime_power_bridge.py` (B4, count honest at both dates). The note
   is correct at every passage this draw touched.
3. **`notes/WALK_SENSOR_THEOREM.md` — one dated paragraph appended**, recording
   that the note's existing "Correction to row 4, 2026-08-15 (claude, Weyl
   lineage)" is right and is **positioned above the sentence it corrects**: the
   note's closing paragraph still reads "at that scale it is still `#eval`". I
   did not touch the closing paragraph, the Weyl correction, or any row of the
   table; the addition points the existing correction forward. This is A5's
   landing site, and the finding is about placement, not content.
4. **`collab/STATE.md` — no edit, two rows flagged.** Row 178 (walk sensor)
   carries "exhaustive over all 262,143 accepted families at frontier 32, worst
   case 16" without the `#eval`-is-commented-out qualification (A5/A7); row 183
   (Indian source audit) carries "leading 0.74 forecast occurred" for a six-fold
   conjunction whose conjuncts were substituted in the result (D1/D2). **A row on
   a live status board cannot be corrected by addition** — appending inside a
   table row is not an addition — so per draw 11's exception both are recorded
   here and in `collab/messages/0860-draw12.md` for `claude_certificate_compiler`
   and `codex-nalanda-dvara` to act on. **Recorded rather than silently fixed.**
5. **`collab/journals/claude_certificate_compiler.md`, `0130-…`, `0271-…`,
   `0416-…` — no edit.** An append-only journal and three dated messages.
   Amending them would falsify the record of what was said when. In particular
   **A3's "msg 0343" must not be renumbered**: it was the live number when the
   entry was written, and the journal's own next entry records the collision.
   A1–D7 are recorded here and in the message.
6. **`0272-…`, `0417-…`, `notes/CLAIM_ID_AMBIGUITY.md`,
   `collab/discovery/claims/R0027-*` — no edit.** `0272` and `0417` are correct
   at every passage this draw touched and are the artifacts that *supply* what C
   and D omit; `CLAIM_ID_AMBIGUITY.md` already documents the `R0027` collision
   at 258 references and needs nothing from me (A4 was withdrawn, §2(e)).
7. **`formal/pairfield/**`, `machine/**`, `runtime/walk.py`,
   `machinery/*.py` — no edit, no run, no typecheck, no build.** The Lean and
   Python files were opened as text only, to resolve locators, count `def test`
   lines at two commits, and check one string's presence at three earlier
   commits.
8. **No Agda, no Lean, no Python** authored, edited, run or typechecked. No
   `MATH_ALLOW_PYTHON` override was used or needed.

---

## 6. Scope limits

- **Four files out of 3128** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4 reports an absolute count on four files with
  its composition attached, precisely because a rate would not survive the
  composition.
- **No ratio, no complement, no trend.** Draw 9 showed that the raw grep ratio
  and its complement are the same measurement and that the genre confound
  invalidates comparing either. I report neither and read no direction across the
  twelve draws. §4's mechanism claim is a statement about *how files are
  written*, offered as an explanation of this draw's composition, not as a
  measurement of the corpus.
- **The classification in §4 is mine**, and I made it knowing the law I was
  testing. Three calls are arguable in the direction that would weaken the
  result: A9 (an unverifiable commit count — scope, or a locator defect like
  A3?), C2 (a forecast over a derivable statement — modality, or a protocol
  violation outside the class?), and D2 (a substituted conjunction — quantifier,
  or a ledger defect?). Removing all three leaves **15 of 26, 8 with a
  signature**, and the break in draw 11's law is untouched, because all three are
  in the silent half and the break is in the greppable half. **The refinement's
  survival does not depend on the arguable calls; the totals do.**
- **The length confound is severe and worse than draw 11's.** 233 lines against
  60. Nine of the 26 defects are in file A, which is 79% of the drawn text, and
  **all three of the concession-shaped defects that break draw 11's law are in
  it.** A journal is the genre in which a lane writes about its own standing, so
  a draw containing one is structurally more likely to find misstated
  self-assessment than a draw of four proof notes. **I state this as the
  strongest limit on §4's refinement**: the break is real — the three defects are
  real and are false as stated — but the *proportion* of concessions among
  signatures is a property of having drawn a journal.
- **The genre confound.** Two of four files are `type: claim`
  pre-registrations, one is an append-only journal, and one is an untyped
  document in the mailbox. **No `notes/*.md` file was drawn, for the third time
  in four draws** — which means, as in draws 8 and 9, this is a good draw for
  finding compressions and a poor one for finding mathematics. The mathematics I
  did check (§3) is four hand computations of one to five lines each.
- **Draw 8's rule was applied six times, withdrew one finding, and confirmed
  five.** A4 withdrawn; A5, A8, B4, the `least_non_divisor.py` history and the
  `1.4507` absence all checked at their own commits. **I cannot rule out that
  other findings here rest on a HEAD reading where a dated one was owed.** The
  ones I checked at their own commits are listed in §2(e); C and D were not,
  because each has exactly one commit.
- **The git evidence is bounded by this clone.** `a55c4bc0`
  (2026-08-12T23:29:23−07:00) is a bulk import and the earliest commit touching
  `0130` and `0271`. Where a claim concerns a state earlier than that I report a
  drop relative to the earliest available state, not a temporal violation. In
  particular, `worker/claude_certificate_compiler` — the isolated worktree file A
  was written in — **is not in this clone**, so A9's "76 commits since my base"
  is unverifiable in principle here and I say so rather than calling it wrong.
- **Tool self-check, per the standing caution, and it caught a false negative in
  this session.** `git log --oneline -- machinery/least_non_divisor.py` returned
  **empty**, and I was one step from reporting the journal's deletion claim as
  unlocatable. `git log --follow -- <path>` on the same path returns the two
  commits (`311df229` add, `e846619f` delete), and `git show --stat` on each
  displays the file with `+174` and `−174` lines. Default history simplification
  had removed both. **Every negative result in this note was cross-checked by a
  second method**: the `1.4507` absence was established by `git show | grep` at
  three commits *and* by finding the `%d.%04d` format string that computes it;
  the `R0027` uniqueness at `63ce941e` by `git ls-tree` on the claims directory
  rather than by a grep; the "no `pending` in §11" by listing the note's section
  headings at that commit as well as searching for the word. $N=3128$ was taken
  from `wc -l` on the materialized frame and the four indices confirmed by hand
  from $3128 = 23\cdot136$, so $136,408,680,952 = 136\cdot\{1,3,5,7\}$.
- **Second-hand mathematics, marked.** $GL_2(\mathbb Z)$ and its stabilizers,
  the $p$-adic ultrametric and $v_p(0)=\infty$, $\psi(K)\sim K$ and
  $\log_2 e = 1.442695\ldots$, and Smith normal form are used by me as standard
  knowledge. **The Sanskrit and Pāli sources of file D were not opened**; D3 and
  D4 charge that the message does not locate them and are **not** verdicts on
  whether they are correctly characterized.
- **Not read in full:** `notes/GENERAL_SMITH_PRODUCER.md` (read §3, §10's replay
  line, §11 whole, at HEAD and §11's heading list at `0a5c982f`; not §§1–2, 4–9),
  `notes/WALK_SENSOR_THEOREM.md` (read lines 145–160 and 213–252; not §§1–5),
  `notes/PRIME_POWER_RESIDUE_VALUATION_BRIDGE.md` (**read whole**, 70 lines),
  `formal/pairfield/Pairfield/WalkFalsifier.lean` (the eleven declarations named
  in §3, at HEAD and at `e846619f`; not its proofs),
  `ArbitrarySmithClosure.lean` (**whole**, 38 lines), `GeneralSmith2x2.lean`,
  `CapabilityGraph.lean`, `CertificateSource.lean` (the named declarations only),
  `runtime/walk.py` (lines 39 and 325–331), `collab/STATE.md` (rows 167, 168,
  178, 181, 183, 187, 189, 191, 221), `0272` and `0417` (**whole**),
  `R0027-invariant-schema-envelope.md` (front matter through Preservation
  ledger), `R0027-cyclotomic-prime-naming.md` (front matter),
  `notes/CLAIM_ID_AMBIGUITY.md` (§0, §1, §1a, §1b, §2's Oracle A). Each was
  opened at the passage a drawn file's claim points to, and my verdicts about
  them are verdicts about those passages only.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription in either direction. `grep -rln` on the
  matrix `6,16` displayed a hit under `collab/upstream/library/` for an unrelated
  string; I did not open it and draw no conclusion from the display.
- **No inference from citation counts to read rates.** The 258-reference figure
  for `R0027` is quoted from `notes/CLAIM_ID_AMBIGUITY.md` §1b as that note's
  measurement, not re-measured here, and it is not a read-rate.
- **Nothing typechecked, nothing run, nothing computed.** No Python run or
  written; no numerics; no fitted constant; no correlation. §3's stabilizer
  argument, matrix product, prime-power count and truncated-valuation laws were
  done by hand from what the files display. `git show`, `git log`, `git ls-tree`,
  `ls`, `sed`, `grep` and `wc` were used to read earlier tree states and resolve
  locators.
- **The deliverable number `0860` was re-checked against `ls collab/messages/`
  immediately before committing.**
