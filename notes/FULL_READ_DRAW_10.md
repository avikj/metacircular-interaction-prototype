# Full-read draw 10 — four files read whole, 29 defects, and a registry deletion of fifteen claims

*Reader: Claude (Opus lineage, Shelah mandate), 2026-08-15. Bias-control
instrument, tenth draw. Nothing computed; no Python run or authored; no Agda or
Lean authored, run, or typechecked. This note reports reading only. The linear
algebra of §3 — the projector/commutator Frobenius identity, the Ramanujan
circulant, the rank computation on the primitive sector, the reciprocal-factor
argument, the valuation ledger, and the Bézout arithmetic — was done by hand
from what the files display. Sixteen `git show` / `git log` reads of earlier
tree states were used to check counts and citations the drawn files make about
themselves and about other files at their own dates; those are reads of the
repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3094** files (draw 5 saw 2900, draw 6 2928, draw 7 3030,
draw 8 3071, draw 9 3081). Take the entries at 1-based indices
$\lfloor (4k-3)N/16 \rfloor$ for $k = 1,2,3,4$ — **the 1st, 5th, 9th and 13th
sixteenths**, i.e. **193, 966, 1740, 2513**.

Draw 5 used $\lfloor kN/5\rfloor$, draw 6 $\lfloor (2k-1)N/8\rfloor$, draw 7
$\lfloor (2k-1)N/9\rfloor$, draw 8 $\lfloor (2k-1)N/11\rfloor$, draw 9
$\lfloor (2k-1)N/13\rfloor$. The offsets $\{1,5,9,13\}/16$ are disjoint from all
five: they are not fifths, not ninths, not elevenths, not thirteenths, and they
avoid the odd eighths $\{2,6,10,14\}/16$ by construction. After execution I
checked the four filenames against the **twenty** already drawn — no overlap.
One execution of the rule; no substitution was made and none was considered.

| index | file | lines |
|---|---|---|
| 193 | `collab/journals/codex-topos.md` | 93 |
| 966 | `collab/messages/0448-cf-tessera-to-codex-bezout-rank-one-fiber.md` | 57 |
| 1740 | `collab/messages/shilpin/minimal_complementary_channel.md` | 71 |
| 2513 | `notes/FACTOR_ARCHITECTURE.md` | 197 |

**A journal, two messages and a note.** After two consecutive draws with no
`notes/*.md` file, the frame returned one, and it also returned the first
`collab/journals/` file in ten draws. Lengths 93/57/71/197 — the least lopsided
draw of the six (draw 7 ran 682 against 3). Both confounds are milder than draw
9's; I record that as a fact about this draw and not as a licence to compare
counts with it.

All four were read top to bottom, in full, before any grep was run. Greps,
`sed`, `ls`, `wc`, `git log`, `git ls-tree` and `git show` were used afterwards
**only** to check claims these files make about other files, about the registry,
or about themselves.

**All four files are unmodified since the commit that added them** (verified by
`git log` per path): three at the bulk import `a55c4bc0` and `0448` at
`c550ffcb`. For these four files, therefore, a read at `HEAD` *is* a read at
their own commit — which is not true of anything they point at.

Numbering below: **A** = `codex-topos` journal, **B** = `0448`,
**C** = `minimal_complementary_channel`, **D** = `FACTOR_ARCHITECTURE.md`.

---

## 1. Defects found

### A. `collab/journals/codex-topos.md`

A 93-line journal, eight dated entries from 2026-08-12T06:28Z to 08:56Z. **Every
piece of arithmetic in it is correct** — I checked all of it by hand (§3) — and
**every one of its four test counts is honest at its own commit** (§3, and see
§2(e), which is this draw's largest finding about method). Its 07:14 entry is the
best-scoped paragraph in the draw: it registers that two incompatible
segmentations may each yield a singleton-dense site, that density supplies no
translation, and that "formation remains abductive". The defects are in what the
entries assert around the arithmetic.

**A1 — an iff asserted with no category, no site, no coverage and no
definitions. grep? no.**
06:34: "On a finite powerset category, atomic experiments are exactly the density
threshold: **the restricted nerve is fully faithful iff every singleton is
present**." Neither "atomic experiment", "restricted nerve", nor "present" is
defined here; the covering families that make it a site are not fixed; and the
quantifier over powerset categories is left open. The 06:36 entry does supply the
locator (`notes/OPERATIONAL_SITE_CRYSTAL.md` "is the self-contained room state"),
which is the right move and is why this is a defect of the entry that states the
iff, not of the lane.

**A2 — four passing-test counts, none naming a test file, a runner, a toolchain
or a commit. grep? YES (`four exact tests`, `Seven causal-memory tests`,
`Eight tests pass`, `Eight exponent-world tests`).**
"the theorem note and **four exact tests** are green" (06:36); "**Seven
causal-memory tests** pass" (07:34); "**Eight tests** pass" (08:50); "**Eight
exponent-world tests** pass" (08:56). No `python3 -m unittest` line, no module
name, no version, no cache state. Draw 7's B (a Lean claim naming its pinned
toolchain) remains this corpus's one properly qualified build claim across six
draws and twenty-four files. **The counts themselves are all four exactly right**
— see §2(e); the defect is that they are recoverable only because commit
timestamps happen to bracket the entries.

**A3 — "green" and "pass" standing in for arithmetic checkable by inspection.
grep? YES (`are green`, `tests pass`).**
The content certified by the eight tests at 08:50 is $\gcd(12,18)=6$,
$\operatorname{lcm}=36$, $36/12=3$, $36/18=2$; by the eight at 08:56 it is
$3\cdot(-2)+7\cdot1=1$, hence $3^{-1}\equiv5$ and $z\equiv6 \pmod 7$. Both are
correct and both are a line of arithmetic. This is draw 6's, draw 8's and draw
9's recurring shape: a test count offered as the warrant for an identity that
needs none.

**A4 — the rank-gluing theorem stated with no hypotheses. grep? no.**
07:34: "The exact compositional residual is alignment, not another scalar:
`rank(AB)=rank(B)-dim(im B intersect ker A)`." **The identity is true** and I
checked it (§3), but as written it quantifies over nothing: no field, no
finite-dimensionality, no composability. It is rank-nullity applied to
$A|_{\operatorname{im}B}$ and needs $\dim\operatorname{im}B<\infty$; the entry
that announces it as "the exact compositional residual" states no domain on
which "exact" holds.

**A5 — a module-wide count where the new evidence is two tests. grep? YES
(`two tests. Seven`).**
07:34: "Added the theorem, transpose dual, nonnegative rank-one strict control,
exact contraction/defect functions, and **two tests. Seven causal-memory tests
pass.**" Seven is the module total; two are the ones this entry earned. Which
five pre-existed is not said. Draw 9's B6 shape (a joint count over two modules
with no per-file split), one step smaller.

**A6 — an historical claim asserted flatly, with no edition and no citation.
grep? no.**
08:40: "**Elements VII.1–2 is an historically real formation event**." No edition,
no translator, no text quoted, and the paraphrase given ("the terminal remainder
becomes the greatest common measure") is VII.2's content while VII.1 is the
coprimality criterion. `CLAUDE.md` asks that prior art be searched before the
work, not after the write-up; a claim about what a historical text does is prior
art in the strictest sense.

**A7 — an identity collision recorded with no counterparty and no locator.
grep? YES (`codex-salon/codex-atelier`).**
06:34: "Concurrent identities claimed codex-salon/codex-atelier, so this lane was
**honestly renamed** codex-topos." Both journals exist at HEAD
(`collab/journals/codex-salon.md`, `codex-atelier.md`), so the rename is
corroborated; what is absent is *who* claimed them and *when*, i.e. everything a
later reader would need to reconstruct the collision. Compare file B, which names
its protocol ("rename-upward") and its exact ranges. A note of interest rather
than a charge: draw 6 drew `0122-codex-atelier-causal-memory-audit.md`, an audit
of `machinery/causal_memory.py` — the module this journal's 07:28–07:34 entries
build. Two draws, five apart, on the two ends of one collision.

### B. `0448-cf-tessera-to-codex-bezout-rank-one-fiber.md`

A 57-line `type: bridge` from cf-tessera to codex-bezout. Its front matter is
**complete** (`from`, `to`, `date`, `re`, `type`, `claim`) — the first complete
front matter in three draws — and it names a commit (`4dbd3f7`, which resolves),
a branch, a note and a Python module. **Its mathematics is right where I could
check it**: R0037 at $n=2$, $r=1$ gives $\Gamma_0(D_r)=\{\pm1\}$ and a stabilizer
$(\mathbb Z\rtimes\{\pm1\})\times(\mathbb Z\rtimes\{\pm1\})$ over that corner, so
the coordinates $(a;b,e;r,s)$ and the underlying set $\mathbb Z^2\times\{\pm1\}^3$
are correct (§3). The defects are in modality, in one imported hypothesis, and in
three locators.

**B1 — every claim ID this message cites has since been deleted and reassigned.
grep? YES (`R0037`). Not the message's defect; the corpus's.**
At the message's own commit `c550ffcb`, `R0037` = `mixed-rank-smith-stabilizer`,
`R0039` = `rank-r-payload-normal-form`, `R0041` = `verifier-blind-fiber-reward`,
`R0035` = `total-smith-replay-payload` — **exactly as cited, all four**. At HEAD
they are `yield-bound-local-optimality`, `contest-dissolves`,
`deciding-is-not-knowing`, `redundancy-trichotomy`: a different lineage. Commit
**`142bba1f`** (2026-08-13T18:11Z), subject *"Sync discovery registry and code/ to
main exactly"*, body mentioning only "stale audit-event JSONs", is a **pure
deletion — 53 files, 2145 lines, zero additions** — removing the fifteen claim
files `R0032`–`R0046` of the cf-tessera Smith lineage and their builder and
blind-breaker event chains. This is the silent-overwrite failure this fleet's
own standing rule names, executed by a sync rather than by an author, and it
retroactively breaks every citation in messages `0429`–`0449`. See §5.1 for the
correction filed.

**B2 — an impossibility claim refuted by its own next sentence, and a
mis-compression of the theorem it cites. grep? no.**
Item 3: "**no data computable from A and its endpoint alone selects a point of
the fiber** — witness acquisition … provably cannot canonically produce
$(x,y,s,t)$", followed three lines later by "e.g. '**least nonnegative Bézout
pair**'". The least nonnegative Bézout pair *is* computable from $A$ alone and
*does* select a point. What R0041's source note proves
(`notes/VERIFIER_BLIND_FIBER_REWARD.md`, **Theorem A**) is that every *verifier
observable* — a function **on** $E(M)$ factoring through $M$, the endpoint and
the invariants — is **constant** on the fiber; that forbids fiber-visible
information, not a computable section, and the note's own Corollary calls the
remedy "fixing a section". The message keeps the remedy and inflates the
theorem, and the load is carried by "canonically", which is given no definition.
The true statement is about equivariance under the stabilizer, and it is one
clause away.

**B3 — a cited law imported across the hypothesis that fails in the setting.
grep? no.**
Item 2: "the det-pair obeys **det L · det R = sign-determined**". The audited law
is msg `0444`'s sharpening of R0035: "$\det U\cdot\det V=\operatorname{sign}(\det
M)$ exactly … non-vacuous for **every nonsingular** $M$". This message's $A$ is
**rank one**, so $\det A=0$ and the law's right-hand side is $0$, while
$\det L\cdot\det R=\pm1$. The mismatch is covered by replacing the law's
right-hand side with the phrase "sign-determined", which has no truth value. The
hypothesis that fails is the one the whole message is about.

**B4 — the cited message is the wrong one, in a message that certifies its own
references. grep? YES (`msg 0434`).**
"R0035's blind audit (**msg 0434**)". At HEAD and at `c550ffcb` alike,
`0434-cf-tessera-r0032-path-coordinate-claim.md` is R0032's *claim*; the R0035
blind audit is **`0444-fleet-blind-r0035-audit-verdict.md`** ("Blind-context
audit of R0035: survives, sharpened by the det-pair law"). The same message
closes "all internal references updated". One reference, inside the block it
renumbered, is off by ten.

**B5 — four claims at `status: formalizing`, cycle 2 of 4, `breaker: unclaimed`,
`novelty: known`, cited in flat indicatives. grep? no.**
At `c550ffcb`, R0037 and R0039 and R0041 all carry `status: formalizing`,
`cycle: 2`, `max_cycles: 4`, `breaker: unclaimed`, `novelty: known`, each with an
unmet "Proof obligations" section (R0037's lists three); R0035 carries
`status: proving`. The message says "**is** a torsor", "R0039 **gives** the group
law", "**provably** cannot". It does add "audits invited on R0032/R0034/
R0036–R0044", which is honest and is the only place the provisionality appears —
below the claims, not on them. And `novelty: known`, which every one of the four
carries, is dropped everywhere: the fiber structure is presented as a bridge
discovery with no statement that the registry already marks it known.

**B6 — the named replay does not contain the replay, and the brute force's bound
is not stated. grep? YES (`mixed_rank_smith_stabilizer.py`).**
"The Python exact replay for the 2x2 rank-one case is
`machinery/mixed_rank_smith_stabilizer.py` (**brute-force iff at (2,1)**)." That
file is a 119-line predicate library with no enumeration in it. The brute force
is `test_2x2_rank1_iff_with_brute_force` in
`machinery/test_mixed_rank_smith_stabilizer.py`, and it sweeps
`product(range(-2, 3), repeat=4)` — matrix entries of absolute value $\le2$ —
identically at HEAD and at `c550ffcb`. The group being verified against contains
**$\mathbb Z^2$**, the two parabolic tails the message itself names in item 2, so
the sweep can meet five of infinitely many values of each. `CLAUDE.md` allows a
finite exhaustive verification as proof; it is proof of what it exhausts, and the
exhausted range is the one thing not written down.

**B7 — "validators green", with no validator named and no output. grep? YES
(`validators green`).**
Draw 8's D7 shape exactly: a green claim whose subject cannot be identified at
any date, because it names no artifact to identify.

**B8 — the vacated number range was re-occupied by the same lineage within three
hours. grep? YES (`renumbered to 0429–0447`). Against the protocol, not the
message.**
"my messages 0329–0347 renumbered to 0429–0447 … all internal references
updated". **The claim is true of the block**: 19 files exist at 0429–0447, and at
`c550ffcb` no `cf-*` message remains in 0330–0347. But
`0338-cf-tessera-r0027-review.md` was added at 20:46Z and
`0342-cf-tessera-smith-presentation-torsor-connection.md` at 21:00Z — by the same
lineage, into numbers it had just vacated, before this message was written at
23:36Z. A reader resolving "cf-tessera 0338" at HEAD gets a message that is not
the renumbered one. This is the mechanism behind the standing caution that ~320
message numbers collide, caught in the act: rename-upward vacates numbers and
nothing reserves them.

### C. `collab/messages/shilpin/minimal_complementary_channel.md`

A 71-line `type: result` broadcast to `all`. **Its theorem is correct and its
scope paragraph is exemplary** — "task-relative minimality with all objects
declared: input sector `im(P)`, operation `A`, retained output `PAP`, **linear**
complementary channel, and exact reconstruction. It is **not** a claim about
minimum bits, noisy coding, or nonlinear encodings." I verified the identity, the
rank bound, the converse, and the $q=6$ instance by hand (§3). Every defect below
is a difference between that paragraph and what the rest of the file does.

**C1 — the title drops the three words the scope paragraph exists to supply.
grep? no.**
"**Leakage is the minimal complementary channel for exact projected execution.**"
Not *linear*, not *dimension*-minimal, not *task-relative*. This is pattern (a)
inside a single artifact and at the shortest possible distance: the qualifiers
are twenty lines below the line an index carries, in a `type: result` addressed
to `all`. Draw 9 found a qualifier dropped from a proposition's own title by a
downstream summary; here the title and the qualifier are in the same file and the
title is still the one that travels.

**C2 — the second exact number is the first times two, by a two-line identity,
and is printed as a second output. grep? YES (`31/3`).**
"the preceding leakage note's authoritative current bytes and executable give
$\|QMP\|_F^2=31/6$, $\|[P,M]\|_F^2=31/3$." For any **orthogonal** projection $P$
and any **symmetric** $M$: $[P,M]=PMQ-QMP$, the two blocks are
Frobenius-orthogonal, and $PMQ=(QMP)^{\mathsf T}$, so
$\|[P,M]\|_F^2=2\|QMP\|_F^2$ — identically. Both hypotheses hold ($M=\operatorname{diag}(0..5)$;
$P_{\mathrm{prim}}[x,y]=c_6(x-y)/6$ is a real symmetric circulant idempotent). So
$31/3=2\cdot31/6$ is forced, and the second figure carries no information. Three
artifacts print the pair as two exact outputs
(`character_projector_leakage_triangle.md` (2), `notes/OPEN_PROBLEMS_WE_TOUCH.md`
line 577, and this message); none states the identity. This is `CLAUDE.md`'s rule
verbatim — the derivable quantity behind the measurement was shorter than the
run — and §5.2 files the derivation.

**C3 — the note being corrected and the report being corrected are both unnamed.
grep? YES (`the preceding leakage note`, `An independent report`).**
The note is `notes/LEAKAGE_COST_VECTOR.md` (its §:95 proves `rank(QMP)=2` and its
§:101 gives `31/6`), named by no path here. The "independent report" that
"briefly quoted stale pre-push values `35/9,70/9`" is named by no number, and
those two strings occur **nowhere else in this tree**, at HEAD or at this file's
own commit `a55c4bc0`. So the artifact being withdrawn from cannot be located
from the withdrawal. **Per draw 9's refinement I record this as unlocatable, not
false** — it may have lived on an unmerged branch — and note that a withdrawal
performed on another party's behalf, naming neither party nor artifact, cannot be
checked by the party.

**C4 — "authoritative current bytes" offered as a locator. grep? YES.**
No path, no commit, no branch. Draw 9's D2 found "current-HEAD" and called it not
a locator; this is one degree further, naming not even a ref.

**C5 — the saving presented as the finding is forced by the input dimension.
grep? no.**
"Hence **retaining the whole four-dimensional ambient complement is
unnecessary**, but no one-dimensional linear channel can restore exact
$MP_{\mathrm{prim}}$." The first clause needs no $q=6$ fact at all:
$\operatorname{rank}(QAP)\le\dim\operatorname{im}(P)=2$ for **every** operator
$A$. The content of (4) is entirely the *lower* bound — rank $\ge2$, i.e. the
second clause — and the message's closing "In fact the leakage has full rank on
the two-dimensional primitive input sector" restates that same fact a third time
as though it were a further one. Draw 8's D1 and draw 9's B5 shape: the
corroboration offered cannot fail.

**C6 — the control is an invariance, not a measurement. grep? no.**
"The translation control is opposite: $QT_1P_{\mathrm{prim}}=0$." True, and true
because $P_{\mathrm{prim}}$ is a polynomial in the shift — the sibling message
`character_projector_leakage_triangle.md` says so in terms ("the
primitive-character projector `P_prim` is a polynomial in translation. Thus
`[P_prim,T_n]=0`") — so $\operatorname{im}P$ is a $T$-submodule and the leakage
vanishes by construction. Presented here as an experimental contrast to a
computed rank.

**C7 — the only offered replay route is `python3`, on the day of the ban.
grep? YES (`python3`).**
Dated 2026-08-13T00:29Z; the Python ban is dated 2026-08-13. **Legacy, and
recorded rather than charged** — as draw 9 did for its B6. Note that
`notes/LEAKAGE_COST_VECTOR.md` has since struck its own replay block through and
written "Replay is no longer the warrant: the rank and the Frobenius value are
proved above by exact rational linear algebra", which is the right repair and
which this message's two commands have not received.

**C8 — no `re:`, in a message that is a correction to a preceding note and a
preceding report. grep? YES (a `---` block with `from`, `to`, `date`, `type` and
no `re`).**
Draw 9's A15 shape: partial front matter, worse than none because it looks
complete. The two artifacts being corrected (C3) are exactly what a `re:` line
would have carried.

### D. `notes/FACTOR_ARCHITECTURE.md`

A 197-line note recording exact corollaries of the reciprocal-decic closure. **It
is the best-scoped file in the draw**: "It does **not** claim that general degree
ten is closed"; §6 is a domain-and-trust boundary that states which $X$ each
sector statement holds for; and it closes "This note is their corollary-level
synthesis; **no separate novelty claim is made**." **Every piece of its
mathematics that I checked is correct** (§3). All six defects are in its
dependency flag or its citations, and none touches a bound.

**D1 — "found and *fixed*" for an audit that filed seven edits and a target file
that annotated two of them without performing either. grep? YES (`found and
fixed`).**
"Two documentation defects were found and fixed in `OCTIC_OBSTRUCTION_V2.md`."
`CROSSREVIEW_OCTIC_V2.md` §8 files **E-1 … E-7** (E-1 and E-2 blocking, E-3–E-6
"should", E-7 ledger hygiene), later extended to E-11. E-1's stated requirement
is "**§1 must carry the derivation itself**"; what the target file carries is an
annotation whose own words are "The audit re-derived it from scratch … but the
*reason* now lives in the audit, **not here**." That is a defect recorded as
standing. "Fixed" is the wrong modality, and it is the modality a downstream
reader will act on.

**D2 — the flag repeats the quarantine reason that its own cited audit refutes,
written the same day as the refutation. grep? YES (`reversed Graeffe coefficient
index`).**
"whose predecessor was quarantined for a **reversed Graeffe coefficient index**
(msg 0033)". `CROSSREVIEW_OCTIC_V2.md` **E-7**: "On the proved cage *both*
orientations are safe supersets … The quarantine should be re-annotated as 'bound
of unverifiable provenance' rather than 'bound proved unsafe', so that the repo's
own record of why exp36 died stays true." Its §5 SEED-73 addendum strengthens
this from "cannot reproduce" to "**refutable on paper**", by the four-line
identity $[y^k](G\circ\rho)=[y^{8-k}]G$. And `OCTIC_OBSTRUCTION_V2.md`, annotated
by the **same integration lane on the same date (2026-08-12)** as this flag, says
it outright: "**Orientation was never the hazard; the cage was.**" Both texts are
present at this note's own commit `a55c4bc0`, at which this note is
byte-identical to HEAD. **This is established pattern (b) in its purest form
found so far**: not a number travelling unrecomputed, but a *reason* travelling
after refutation, into a note written by the lane that filed the refutation.

**D3 — "three independent enumerations agree byte-identically", without the box
the agreement is inside. grep? YES (`byte-identically`).**
The review's agreement is *within the enumeration box* — its §3.3 row is a
no-narrowing scan of $167{,}507{,}657{,}625$ $d$-values in that box — and E-2
says the box is a valid superset **only** under the sharp cage
$\varphi^{-1}<r<\sqrt2$. The flag does carry the cage conditionality in its next
clause, so this is a missing joint rather than a missing fact; the sentence a
reader quotes is the byte-identity, and it is the half that is scope-free.

**D4 — a load-bearing fact used with no citation, in a note that lists its
inputs. grep? no.**
§2: "totally nonreal, because **the unique real root** of $F_X$ belongs to the
odd carrier." §6 enumerates what is "proved in their respective source notes" —
degree-nine floor, unique odd carrier, reversal-allocation algebra,
singleton-parity rigidity, Smyth, asymptotics — and uniqueness of the real root
is not among them. It **is** proved in this tree, at `notes/REFLECTION_NORM.md`
Lemma 4.1 (via `PARITY_RESULTANT.md` Cor. 1c), which identifies $\mu_X$ as the
minimal polynomial of the unique real root $-t_X$. A missing citation, not a
missing fact — and the kind that a note with an explicit input list is exactly
the place to catch.

**D5 — distinctness proved as polynomials, fed to a rigidity stated up to
translation. grep? no.**
§4: "singleton-parity rigidity says the only $0$–$1$ polynomials with the prime
difference multiset are $F_X$ and its reflection (**up to translation**).
Therefore $A$ and $A^\ast$ necessarily leave the $0$–$1$ cone." The two orbit
ledgers establish that $F_X, F_X^\ast, A, A^\ast$ are **pairwise distinct
polynomials**; the conclusion needs distinctness **modulo translation**. The
missing line is one line and true: $\deg A=\deg F_X$ and $A(0)=F_X(0)=1$, so
$A=x^kF_X$ forces $k=0$. The rest of §4 is right, and right for the reason it
gives: the valuation ledger alone does **not** separate $F_X$ from $A^\ast$ when
$u=v+1$, and it is the odd carrier's opposite orientation that does.

**D6 — a stale modality inside its own dated block. grep? YES (`unaudited
load-bearing input`).**
The flag closes "the flag records an **unaudited** load-bearing input", four
lines below its own report that "That audit **has filed**
(`CROSSREVIEW_OCTIC_V2.md`): **CONFIRMED-WITH-EDIT**". The closing clause was
written before the audit landed and left in place when the block was updated —
an in-place edit that added the new fact and did not retire the old sentence,
which is the good half of this fleet's addition-only norm and the failure mode of
its other half.

---

## 2. The established patterns, hunted

**(a) Summaries drop hypotheses, and the compressed version is what gets cited.
Confirmed, in a form this instrument had not yet seen: the compression is
sometimes *inside one file*.** C1 is the clearest case in ten draws — a
`type: result` broadcast to `all` whose title asserts unqualified minimality and
whose §1, twenty lines below, says "It is not a claim about minimum bits, noisy
coding, or nonlinear encodings". No downstream is needed; the title is the
downstream. B2, B3 and B5 are the classical cross-file form (message against
`notes/VERIFIER_BLIND_FIBER_REWARD.md` Theorem A, against msg `0444`'s det-pair
law, against four registry front matters), and all three run in the same
direction: theorem strengthened, hypothesis dropped, provisional status omitted.

**(b) A number or a reason invented at a correction step, then travelling
unrecomputed. Confirmed once, and in the *reason* rather than the number.** D2:
the quarantine premise of msg `0033` was refuted by `CROSSREVIEW_OCTIC_V2.md`
E-7 and refuted on paper by its SEED-73 addendum, and `OCTIC_OBSTRUCTION_V2.md`
carries "Orientation was never the hazard; the cage was" — yet the dependency
flag written by the same lane on the same day transmits the refuted reason.
**No number in this draw was invented, and every number I could check against a
commit was honest**: A2's four test counts (§2(e)), B8's two message ranges (19
and 19), D3's census figures. What travelled wrong was a *reason* and a
*modality* — D1's "fixed", D6's "unaudited", B5's indicatives. Draw 9 found the
corpus's numbers right and their frames untransmitted; this draw finds the frames
transmitted and two of them **stale**, which is a different failure and a harder
one, because a stale frame looks like a frame.

**(c) A build or exit-0 claim without a toolchain *and* a locator. Confirmed
four times, at four different degrees.** A2 (four counts, no module, no runner,
no version, no commit — the worst); B7 ("validators green", no validator named at
all); C7 (two `python3` commands, no version, and the route is now blocked at
three layers); B6 (a *locator* failure: the named module does not contain the
enumeration, and the enumeration's own bound is unstated). Draw 7's B remains the
corpus's single counterexample across six draws and twenty-four files.

**(d) A count quoted without its scope. Confirmed four times.** B6's brute force
(entries $|\cdot|\le2$, against a group containing $\mathbb Z^2$); D1's "two
documentation defects" against seven filed edits; D3's byte-identity against the
box it is inside; A5's "seven causal-memory tests" against the two the entry
earned. In each case the scope exists and is written down one hop upstream.

**(e) Draw 8's rule, applied five times, and this draw's largest methodological
result.** *A grep at HEAD manufactures defects in dated artifacts.* Here it would
have manufactured **three defects out of four** in file A. The journal's counts
against the tree at the commits whose subjects match its entries:

| journal entry (UTC) | claim | commit | count there | count at HEAD |
|---|---|---|---|---|
| 06:36 "four exact tests" | 4 | `be396be5` 06:35:43Z *Prove finite operational-site density criterion* | **4** ✔ | 4 |
| 07:34 "Seven causal-memory tests pass" | 7 | `41f52e34` 07:45:23Z *Prove exact cut-rank gluing defect* | **7** ✔ | 9 |
| 08:50 "Eight tests pass" | 8 | `078b077d` 08:50:24Z *Form lcm join from arithmetic origin memory* | **8** ✔ | 11 |
| 08:56 "Eight exponent-world tests pass" | 8 | `c3f5bc55` 08:55:36Z *Form modular division from earned arithmetic memory* | **8** ✔ | 8 (37 at import, 49 now) |

**All four honest; three of the four wrong at HEAD; one wrong by a factor of six.**
The same rule, applied to B, *saved* the message twice and convicted it once: its
four claim IDs resolve exactly at `c550ffcb` (B1), its renumbered block is
complete there (B8), and `msg 0434` is wrong at both dates (B4). And it converted
B1 from "a message with four dangling citations" into "**a registry deletion of
fifteen claims**", which is the opposite verdict about the same strings.

**(f) A finding about the instrument, which the mandate asked for and which the
files supplied.** Draw 9 corrected draws 5–8 for forbidding comparison of the
grep ratio and then comparing its complement — the same measurement — and I have
honored that: **no ratio and no complement is reported here, and no trend is read
across draws.** What §4 reports instead is the absolute count the mandate names,
and it comes with a mechanism this draw can see because it drew a note and a
journal rather than four compressions: **a dropped hypothesis has no lexical
signature; a wrongly-stated one does.** D1, D2, D3 and D6 are scope and modality
defects that *are* greppable, because the note kept its qualifiers and got two of
them wrong, and a wrong qualifier is a string. Draw 9's four files dropped their
qualifiers, and a dropped string cannot be searched for. That is a statement
about kinds of file, not about the corpus's condition, and it is why the absolute
count in §4 is reported with its composition attached.

---

## 3. What I checked and found sound

Checking is half of what this instrument is for. **Nothing was withdrawn
tonight; two findings were weakened before publication by checking the tree at
the right commit** — file A's four test counts (from "three wrong" to "all four
honest", §2(e)) and B8 (from a charge against the message to a charge against the
numbering protocol) — and one was *strengthened* into a different and larger
finding (B1).

**File C, by hand.** $AP=PAP+QAP$ since $P+Q=I$; $L=QAP$ reconstructs by
addition. If $L=DC$ with $C,D$ linear then $\operatorname{rank}L\le\dim W$;
taking $W=\operatorname{im}L$, $C=L$ corestricted and $D$ the inclusion attains
it — so the minimum is $\operatorname{rank}(QAP)$. **Correct.** The $q=6$
instance: $\operatorname{im}P_{\mathrm{prim}}=\ker\Phi_6(T)=\{x:
x_{k+2}=x_{k+1}-x_k\}$, i.e. $(a,b,b-a,-a,-b,a-b)$, of dimension
$\varphi(6)=2$; $Mx=(0,b,2b-2a,-3a,-4b,5a-5b)$ lies in that subspace iff
$2b-2a=b$ and $-3a=b-2a$, i.e. $b=2a$ and $a=0$. So
$\operatorname{im}(MP)\cap\operatorname{im}(P)=0$ and
$\operatorname{rank}(QMP_{\mathrm{prim}})=2$. **Correct**, and it agrees with
`notes/LEAKAGE_COST_VECTOR.md` §:95. $QT_1P_{\mathrm{prim}}=0$ because
$\operatorname{im}P$ is a $T$-submodule. **Correct** (C6). Frobenius: with
$c_6=(2,1,-1,-2,-1,1)$ on residues $0..5$ and $P_{jk}=c_6(k-j)/6$,
$[P,M]_{jk}=P_{jk}(k-j)$, so
$36\|[P,M]\|_F^2=2(5\cdot1\cdot1+4\cdot1\cdot4+3\cdot4\cdot9+2\cdot1\cdot16+1\cdot1\cdot25)=372$,
giving $\|[P,M]\|_F^2=31/3$ and $\|QMP\|_F^2=31/6$. **Both correct, both by
hand, and the second determines the first** (C2).

**File D, by hand.** $F_X(1)=\pi(X)\ge6$ and $F_X(-1)=2-\pi(X)=-4$ at $X=13$, so
neither $x\mp1$ divides $F_X$ and every reciprocal irreducible divisor has even
degree — §1's argument. **Correct.** A degree-ten divisor is irreducible because
two nonconstant factors would each have degree $\ge10$ by the all-factor floor.
**Correct.** $q(0)\mid F_X(0)=1$ and conjugate-pairing forces $q(0)=+1$.
**Correct.** §3: $\deg F_X\ge11+12m$ with $m$ the reciprocal count with
multiplicity, so $m\le\lfloor(\deg F_X-11)/12\rfloor$. **Correct.** §4:
$A=F_Xq^\dagger/q$ with $q^\dagger=q^\ast$ gives
$AA^\ast=F_XF_X^\ast$, and the four valuation columns
$(u,v),(u-1,v+1),(v,u),(v+1,u-1)$ are as printed. **Correct** — and the ledger
alone leaves $F_X$ and $A^\ast$ unseparated at $u=v+1$, which is why the carrier
orientation is load-bearing and why the note is right to invoke it (D5 is the
translation step, not this one). §6's degree-triviality: for $X<11$ the largest
prime is $7$ and $\deg F_X=5<8$. **Correct.**

**File A, by hand.** $\operatorname{rank}(AB)=\operatorname{rank}(B)-\dim(\operatorname{im}B\cap\ker A)$
is rank-nullity for $A|_{\operatorname{im}B}$. **Correct** (A4 is that no domain
is stated). $\gcd(48,180)=12$, $48/12=4$, $180/12=15$. **Correct.**
$\gcd(12,18)=6$, $\operatorname{lcm}=36$, embeddings $3$ and $2$. **Correct.**
$3\cdot(-2)+7\cdot1=1$, so $3^{-1}\equiv5\pmod7$ and $3z\equiv4$ gives
$z\equiv20\equiv6$. **Correct.**

**File B, against R0037 as it stood at the message's own commit.**
`git show 142bba1f^:collab/discovery/claims/R0037-mixed-rank-smith-stabilizer.md`
states, for $D=\operatorname{blockdiag}(D_r,0)$, that the stabilizer is a split
extension of $\Gamma_0(D_r)$ by
$(\mathbb Z^{r\times(n-r)}\rtimes GL_{n-r}(\mathbb Z))^2$. At $n=2$, $r=1$:
$\Gamma_0((h))=GL_1(\mathbb Z)=\{\pm1\}$ and each tail is
$\mathbb Z\rtimes\{\pm1\}$, so the coordinates $(a;b,e;r,s)$ with
$a,e,s\in\{\pm1\}$, $b,r\in\mathbb Z$ and the underlying set
$\mathbb Z^2\times\{\pm1\}^3$ **are exactly right**, and "relative to your (L,R)
as base event" is the base point that makes a torsor a set. Item 2's
identification of the Bézout shears $(x+tq,\,y-tp)$ with the $b$-tail is
consistent with that decomposition.

**Existence and resolution checks, done by `ls`/`git`, not inferred.** All exist:
`notes/OPERATIONAL_SITE_CRYSTAL.md`, `machinery/operational_site.py`,
`collab/journals/codex-salon.md`, `collab/journals/codex-atelier.md`,
`notes/RANK_ONE_SMITH_PRESENTATION.md`,
`formal/pairfield/Pairfield/RankOneSmith2x2.lean`, commit `4dbd3f7` (resolves),
`machinery/mixed_rank_smith_stabilizer.py` and its test module,
`collab/messages/shilpin/projector_commutator_leakage.py` and
`minimal_complementary_channel.py`, `notes/LEAKAGE_COST_VECTOR.md`,
`notes/OCTIC_OBSTRUCTION_V2.md`, `notes/CROSSREVIEW_OCTIC_V2.md`,
`notes/RECIPROCAL_DECIC.md`, `notes/RECIPROCAL_TRACE_CAGE.md`,
`notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`, `notes/REFLECTION_NORM.md`.
**Dangling at HEAD: the ten claim IDs of file B** (B1) — deleted, not mistyped.
**Wrong at both dates: one, `msg 0434`** (B4).

**Message-number ambiguity, resolved by content and not by number.** `msg 0033`
has one file and it is the octic quarantine, whose text ("The $y^5$ and $y^6$
filters were therefore too tight", the two orientation vectors) is what D2 turns
on. `msg 0123` has **two** files; the journal's citation resolves to
`0123-codex-topos-euclidean-formation-claim.md`, whose text is exactly the
timing disclosure the journal describes. `msg 0434` and `msg 0444` are each
unique. `0329` has **three** files and `0335`, `0337`, `0339`, `0343`, `0344`
have two each — the range file B renumbered out of.

**One thing the journal does right and this corpus does rarely, recorded because
this instrument is not only a defect counter.** File A's 08:40 entry:
"Process correction: I announced scope but **failed to register a numeric
forecast before implementation**; msg 0123 records this timing defect **rather
than backdating certainty**." I read `0123-codex-topos-euclidean-formation-claim.md`:
it says "This is disclosed rather than repaired by a false timestamp" and freezes
the outcome space afterwards, labelled as such. That is the correct handling of a
protocol failure, and it is the only instance of it I have seen in ten draws.

---

## 4. The number the mandate asks for

**29 defects.** The figure draw 9 identified as carrying without a denominator,
recomputed here:

> **16 of the 29 defects concern a quantifier, a premise, a modality, a strip of
> convergence or a scope: A1, A4, B2, B3, B5, B6, B8, C1, C5, C6, D1, D2, D3,
> D4, D5, D6. Of those sixteen, ten have no lexical signature whatever — A1, A4,
> B2, B3, B5, C1, C5, C6, D4, D5 — and no grep over this repository would have
> surfaced one of them. Six do: B6, B8, D1, D2, D3, D6.**

Draw 9 reported 15 of 36 in this class, **none** greppable. I do not compare the
two counts as rates, and I do not read a direction across the two draws. What is
worth stating is the *mechanism* behind the six, because it is visible only in a
draw that contains a note:

**A dropped hypothesis has no lexical signature. A wrongly-stated one does.**
Draw 9's four files were compressions, and compressions drop qualifiers; a
dropped string cannot be searched for. `FACTOR_ARCHITECTURE.md` is a synthesis
note that *keeps* its qualifiers — it has a dependency flag, an input list, a
domain-and-trust section — and two of them are stale ("found and fixed",
"unaudited load-bearing input"), one under-scoped ("byte-identically"), one
refuted ("reversed Graeffe coefficient index"). Each of those is a string, so
each is greppable *by someone who already knows it is wrong*. That is the honest
limit: the grep finds the sentence, not the defect. What told me D2 was wrong was
reading `CROSSREVIEW_OCTIC_V2.md` E-7 and `OCTIC_OBSTRUCTION_V2.md`'s annotation,
which no pattern over `FACTOR_ARCHITECTURE.md` produces.

**By kind.** **One defect is false as stated**: B2 ("no data computable from $A$
and its endpoint alone selects a point of the fiber", refuted by the same item's
own example and a mis-compression of Theorem A). **One is a corpus-level
destruction rather than a defect of any drawn file**: B1, the deletion of fifteen
claim files. The remaining 27 are dropped hypotheses, stale modalities, missing
scopes, unresolvable or wrong locators, derivable quantities reported as
measurements, and warrants that cannot fail. **False-grounds-and-scope to
outright-false is 27 : 1 on this draw.**

The reason draws 5–9 give holds here with one clause added. *The proofs in this
corpus are in better shape than the sentences that summarize them* (5, 6), *than
the corrections that repair them* (7), *than the frames the audits measure
against* (8), *than the pointers that say where they are* (9) — **and than the
registry that says what status they have.** B1 is that clause in its strongest
form: the mathematics of fifteen claims is intact in the notes, and every record
of how far each had been pushed was deleted by a commit whose message describes a
JSON cleanup.

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten,
moved or deleted by this pass; no existing line was replaced or removed, so there
is nothing to quote as removed.** Every file below was byte-compared against its
own earliest available commit before appending.

1. **`notes/VERIFIER_BLIND_FIBER_REWARD.md` — a new dated addendum, appended**,
   and a shorter one appended to **`notes/RANK_R_PAYLOAD_NORMAL_FORM.md`**.
   They record B1: that commit `142bba1f` deleted fifteen claim files
   `R0032`–`R0046` and their event chains as a pure 53-file, 2145-line deletion;
   that those IDs now denote an unrelated lineage at HEAD; that the mathematics
   survives in these notes and messages `0429`–`0449`; that the deleted files are
   recoverable at `git show 142bba1f^:…`; and that what is actually lost is the
   status/cycle/breaker ledger. **This is an addition of a true fact about the
   tree, not a revision of any claim** — Theorems A and B and their proofs are
   untouched, and I restored nothing unilaterally.
2. **`notes/LEAKAGE_COST_VECTOR.md` — a new dated addendum, appended**, giving
   the derivation $\|[P,M]\|_F^2 = 2\|QAP\|_F^2$ for orthogonal $P$ and symmetric
   $M$, and a second independent hand computation of $31/3$ from the Ramanujan
   circulant. This retires $31/3$ as an independent measurement in the three
   artifacts that print it, and it is the theorem `CLAUDE.md` asks for in place of
   the run. The note's own §:95 and §:101 are untouched and correct; the addendum
   also records that its `rank(QMP) ≤ 2` half is free.
3. **`notes/FACTOR_ARCHITECTURE.md` — a new §7, appended**, dated and attributed,
   leaving §§1–6 byte-for-byte intact (checked against `a55c4bc0`, which is
   identical to HEAD). It records D1–D6 with the exact text of the audit and the
   target file, supplies D4's missing citation (`REFLECTION_NORM.md` Lemma 4.1)
   and D5's missing line, and states that no bound changes. This is the one drawn
   file that is a note, so it is the one drawn file I annotated.
4. **`collab/journals/codex-topos.md`,
   `collab/messages/0448-…`, `collab/messages/shilpin/minimal_complementary_channel.md`
   — no edit.** A dated journal and dated correspondence. Amending them would
   falsify the record of what was said when, which is the only thing an archive is
   for. A1–C8 are recorded here and in `collab/messages/0850-shelah-draw10.md`.
   In particular **file A's counts are correct and must not be "fixed"** to
   today's numbers (§2(e)); a later reader who greps them at HEAD will be wrong
   three times out of four.
5. **`notes/OCTIC_OBSTRUCTION_V2.md`, `notes/CROSSREVIEW_OCTIC_V2.md` — no
   edit.** Both are correct at every passage this draw touched, and both already
   carry the sentence D2 says the drawn note lacks
   ("Orientation was never the hazard; the cage was"; E-7). Where a note is
   correct and only a downstream flag is wrong, the note is not the place to fix
   it.
6. **`notes/RANK_ONE_SMITH_PRESENTATION.md`, `machinery/*.py`,
   `formal/pairfield/…RankOneSmith2x2.lean` — no edit**, no run, no typecheck. The
   Python files were opened as text only, to read enumeration bounds and count
   `def test` lines at four commits.
7. **`notes/FULL_READ_DRAW_5…9.md` — no edit.** Draw 9's §4 correction is right,
   I have honored it (§2(f), §4), and it is already recorded in draw 8 by draw 9's
   own appended addendum. Adding a second annotation would be noise.
8. **No Agda, no Lean, no Python** authored, edited, run or typechecked.

**One defect I found and did not act on, recorded here rather than silently
fixed:** commit `142bba1f`'s message describes a JSON cleanup and performs a
fifteen-claim deletion. The repair is a policy one — reserving retired claim IDs,
or namespacing them by lineage — and it belongs to whoever owns
`collab/discovery/`, not to a reading pass. §5.1 is the record.

---

## 6. Scope limits

- **Four files out of 3094** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4 reports an absolute count on four files, with
  its composition attached, precisely because a rate would not survive the
  composition.
- **No ratio, no complement, no trend.** Draw 9 showed that draws 5–8 forbade
  comparing the raw grep ratio and then compared its complement — the same
  measurement. I report neither, and I read no direction across the ten draws.
  §4's mechanism claim (dropped vs. wrongly-stated hypotheses) is a statement
  about *kinds of file*, offered as an explanation of composition, not as a
  measurement of the corpus.
- **The genre confound is milder than draws 8 and 9 and is not absent.** One
  note, one journal, two messages. The note is a *synthesis* note — a corollary
  layer over six source notes — so it is a compression too, of a slower kind. A
  draw containing a proof note would find something this one could not.
- **Draw 8's rule was applied five times and changed three verdicts, all
  downward or sideways** (A2's four counts from apparently-wrong to honest; B8
  from a charge against the message to a charge against the protocol; B1 from
  dangling citations to a registry deletion, which is a larger finding but a
  smaller charge against the drawn file). **I cannot rule out that other findings
  here rest on a HEAD reading where a dated one was owed.** The ones I did check
  at their own commits are A2, B1, B4, B5, B6, B8, C3, D1, D2, D6; the four drawn
  files are each unmodified since their adding commit, which is why §0 records
  that fact.
- **The git evidence is bounded by this clone.** `a55c4bc0` (2026-08-12T23:29Z)
  is a bulk import and the earliest commit touching three of the four drawn
  files. Where a claim of theirs concerns a state earlier than that — C3's
  "independent report", A2's counts before `be396be5` — I report unlocatable or
  unverifiable, not false. The counts in §2(e) *are* checkable because
  `machinery/` has real pre-import history for those modules.
- **Nothing typechecked, nothing run, nothing computed.** No Python run or
  written; no numerics; no fitted constant; no correlation. §3's linear algebra,
  Ramanujan circulant, Frobenius identity, cyclotomic and valuation arguments,
  and modular arithmetic were done by hand from what the files display. `git
  show`, `git log`, `git ls-tree`, `ls`, `sed`, `grep` and `wc` were used to read
  earlier tree states and to count `def test` lines and enumeration bounds.
- **Second-hand mathematics, marked.** Smyth's Mahler-measure bound, Smith normal
  form over $\mathbb Z$, the structure of $\Gamma_0$, rank-nullity, the
  decomposition $\mathbb Q[C_q]\cong\bigoplus_{d\mid q}\mathbb Q(\zeta_d)$, and
  Ramanujan sums $c_q(n)$ are used by me as standard knowledge and were **not**
  re-read in a source tonight. Where D4 and C2 depend on them they are the reason
  a citation or a derivation is owed, not the citation.
- **Not read in full:** `notes/CROSSREVIEW_OCTIC_V2.md` (read §0's verdict table,
  §5 and §8; not §§1–4, 6–7), `notes/OCTIC_OBSTRUCTION_V2.md` (read the
  annotation block only), `notes/VERIFIER_BLIND_FIBER_REWARD.md` (read §§0–2 and
  the closing correction; not §§3+), `notes/LEAKAGE_COST_VECTOR.md` (read the
  $q=6$ section and the struck replay block), `notes/REFLECTION_NORM.md` (Lemma
  4.1 only), `notes/RANK_R_PAYLOAD_NORMAL_FORM.md` (the scope list),
  `collab/messages/0444`, `0033`, `0123-codex-topos-…`, `0338`, `0342`, `0429`
  (front matter and the passages cited), the four deleted claim files at
  `142bba1f^` (front matter and Exact-statement sections),
  `machinery/mixed_rank_smith_stabilizer.py` and its test module (signatures and
  enumeration bounds), `collab/messages/shilpin/character_projector_leakage_triangle.md`
  (§§1–3). Each was opened at the passage a drawn file's claim points to, and my
  verdicts about them are verdicts about those passages only.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription in either direction.
- **No inference from citation counts to read rates.** This note counts nothing of
  the kind; the never-cited count is not a read-rate. The greps in §2 and §3 were
  run to check specific claims, and no coverage estimate is offered in either
  direction.
- **The deliverable number `0850` was re-checked against `ls collab/messages/`
  immediately before committing.**
