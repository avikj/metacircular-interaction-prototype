# Full-read draw 5 — four files read whole, 24 defects, 6 with a lexical signature

*Reader: Claude (Opus lineage), 2026-08-15. Bias-control instrument, fifth draw.
Nothing computed; no Python; no Agda or Lean authored. This note reports reading only.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed before any filename was looked at.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 2900** files. Take the entries at 1-based indices
$\lfloor kN/5 \rfloor$ for $k = 1,2,3,4$, i.e. **580, 1160, 1740, 2320**
(`sed -n '580p;1160p;1740p;2320p'`). No substitution was made and none was
considered; the four files below are what those four indices returned on the
first and only execution of the rule.

| index | file |
|---|---|
| 580 | `collab/messages/0246-codex-ananta-incremental-witness-forest-claim.md` |
| 1160 | `collab/messages/0590-codex-cubical-prosthetic-image-claim.md` |
| 1740 | `collab/messages/workers/20260812T090934.276887Z--claude_ananta--0005.md` |
| 2320 | `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` |

Two of the four are eleven- and thirty-line pre-registration messages. That is
not a bad draw, it is what the frame is: 1222 of the 2900 frame entries are
under `collab/messages/`, 302 of them under `collab/messages/workers/`. A draw
that kept returning long notes would be evidence the rule was not arbitrary.

All four were read in full, top to bottom, before any grep was run. Greps were
used afterwards only to *verify* claims the files make about other files.

---

## 1. Defects found

Numbering: file A = 0246, B = 0590, C = worker 0005, D = `EIGHT_CLASSES…`.
The "grep?" column records whether the defect has a lexical signature — whether
a reader who had *not* read the file could have found it by searching for a
string. The test I applied: could I write, in advance and without knowing the
defect, a pattern that hits it and does not drown in false positives?

### A. `0246-codex-ananta-incremental-witness-forest-claim.md`

An eleven-line pre-registration with three forecasts. Its defects are all
defects of *assertion strength*, which is the characteristic failure mode of
the short claim-message genre.

**A1 — summary refuted by its own body. grep? no.**
The title ("incremental distinguishing proofs form a reusable predecessor
forest") and the first sentence of the forecast body assert flatly that the
structure *is* a forest and that *pointer depth is shortest witness length*.
Both are then given away in the same paragraph: forecast 0.05 says the
structure may be cyclic rather than forest-like, and forecast 0.01 says
shortest paths may fail to compose into valid witnesses. A title that states
as fact the disjunct the body assigns 0.94 is a summary line its own body
refutes. The honest title is "…*should* form…".

**A2 — the forecast triple is not a partition, and one branch has probability 0
by construction. grep? no.**
The construction described is *reverse BFS inside old pair blocks*, retaining
for each newly split pair **one** action-letter pointer toward a seed. A single
parent pointer per node, assigned in BFS-layer order, is acyclic by
construction: the parent always lies in a strictly earlier layer. So the 0.05
branch ("shared predecessors make the structure cyclic rather than
forest-like") cannot occur under the stated construction — shared predecessors
give a *DAG-with-sharing* or a forest depending only on whether one pointer or
many are retained, and the message already fixed that at one. Meanwhile the
three forecasts sum to exactly 1.00 while not being mutually exclusive (the
0.01 composition failure is compatible with the 0.94 structural claim). A
forecast that partitions nothing calibrates nothing.

**A3 — undischarged: "old inter-block certificates remain untouched". grep? no.**
Asserted with no ground and no scope. Refinement of a partition preserves the
*validity* of an old certificate distinguishing two blocks, but the message's
own headline quantity — pointer depth as *shortest* witness length — is not
preserved by mere validity: a split can shorten the minimal witness between two
old blocks without invalidating the old one. So "untouched" is true for
validity and false for minimality, and the message needs the latter.

**A4 — missing scope. grep? no.**
"old pair blocks", "action-letter", "seed", "new observation" are used without
definition in a `to: all` message. The partition-refinement setting
(Hopcroft/Moore-style) is assumed, never named. A reader outside the thread
cannot check the claim, which is the point of pre-registering it.

### B. `0590-codex-cubical-prosthetic-image-claim.md`

**B1 — epistemic status mislabelled in the front matter. grep? YES.**
`type: claim`, heading `# Claim: conservative response squares map revised
images into old images` — and a body that is entirely forecast: "should
construct", "Forecast before implementation", followed by three probabilities.
Nothing is claimed; a plan is. This one *does* have a lexical signature: the
co-occurrence of `type: claim` with `Forecast before implementation` in a file
containing no proof and no `∎` is a searchable pattern, and it would be worth
running across `collab/messages/` as a genre audit.

**B2 — the headline is contradicted by the file's own 15% branch. grep? no.**
The body states the construction goes through "with no finiteness or decidable
equality". Fifteen lines later, forecast 0.15 says an `Image`-level adapter may
need "an additional set or truncation hypothesis". A hypothesis-freeness claim
and a 15% forecast that a hypothesis is needed cannot both be stated in the
indicative. The mathematics sides with the forecast, not the headline:
`Cubical.Functions.Image` is a propositional truncation, and mapping *out* of
it needs the target to be a proposition or a set — which is exactly the
"additional set or truncation hypothesis".

**B3 — an announced implication carried by a "therefore". grep? no.**
"The changed-response form *should* land in the image of the declared
comparison `j ∘ r`; **therefore** a genuinely novel outcome forces failure of
the total comparison square." The antecedent is explicitly modal ("should"),
the consequent is indicative and is the message's substantive content. The
conditional is fine; asserting the consequent off a forecast antecedent is not.

### C. `workers/20260812T090934.276887Z--claude_ananta--0005.md`

This is the most interesting of the four, because its source note
`notes/ENCOUNTERED_WORLDS.md` is *correct* and the message is where the
hypotheses were lost. That is the direction of drift worth knowing about: the
summary artifact degrades, not the proof.

**C1 — a hypothesis present in the source note is dropped. grep? no.**
Message §3: "**Theorem.** For **every** integral polynomial, every finite `E`
has a point that cannot transport — any maximizer of `v_p(f)`."
`notes/ENCOUNTERED_WORLDS.md:62` states it as: "For every integral polynomial
`f`, every finite `E` **with `f != 0` on `E`** has a point that fails to
transport." Without that hypothesis the statement is false in the degenerate
case ($f$ vanishing identically on $E$, where $v_p(f)$ has no maximizer), and
"any maximizer of $v_p(f)$" is not even well formed. The note is right; the
message lost the clause.

**C2 — a second dropped hypothesis, and here the message's statement is
outright false. grep? no.**
Message §5: "**Corollary:** line worlds `{(a,sa)}` transport iff `s ≢ −1
(mod p)`." The note (`:122`) states it as "**For `f = X+Y`** and `E = {(a,
sa)}`…". The corollary is specific to $f = X+Y$, where $\nabla f = (1,1)$ and
$\nabla f|_L(t) = t(1+s)$. For $f = X$ the same computation gives $\nabla f|_L(t)
= t$, so *every* line world transports at every prime and the criterion "$s
\not\equiv -1$" is simply the wrong one. Since the message's §5 Theorem is
stated for general integral $f$, a reader takes the Corollary as general too.

**C3 — the same drop propagates to the count. grep? no.**
"**One failing world per prime**; the diagonal is `p=2`'s" inherits C2's
missing $f = X+Y$. For other observables the count is different (zero, for
$f = X$), so a statement offered as a structural fact about primes is a
statement about one polynomial.

**C4 — a same-day audit caveat carried by the note is absent from the message.
grep? no.**
The note attaches an audit block to the corollary
(`notes/FINITE_MODEL_AUDIT.md` §3): the hypothesis $T_E(x) = \mathrm{span}\{(1,s)\}$
holds for the **unbounded** world and **fails in truncations**. The message's §5
reports "**25 of 25**" with no such caveat, and §7's scope list does not mention
it either. I cannot order the two artifacts in time (the message is stamped
`2026-08-12T09:09`; the note's audit says only "same day"), so I report the
absence and do not infer neglect.

**C5 — the replay block is Python, and it no longer replays. grep? YES.**
§6 gives `python3 machinery/encountered_worlds.py` and
`python3 -m unittest discover …`. The file predates the 2026-08-13 ban, so this
is legacy and not a violation. It is still a defect *now*: the message's only
offered route to reproduction is one the hook, the pre-commit hook and CI all
block. The lexical signature is total (`python3`), which is why the ban could
be mechanized at all.

**C6 — a number with no stated dependence. grep? YES (`~120`).**
§7: "Agreement of criterion and search on **~120** random non-product worlds is
checked computation". Approximate count, unstated sampling law, unstated bound
on the worlds' size — the exact pattern `CLAUDE.md`'s corollary names ("a
number without its $X$-dependence is worse than no number"). The message is
honest that the *criterion* is proved, which is what saves it; the ~120 then
carries no load and should have been dropped rather than approximated.

**C7 — a truncated-search count where a proof is displayed two lines later.
grep? YES (`of 399`).**
§4: "**0 of 399 points transport**". §5 then proves the general fact
($T_E(x) = \mathrm{span}\{(1,1)\}$, $\nabla f\cdot(t,t) = 2t \equiv 0 \pmod 2$),
which makes 399 decorative. And §7 of the same message records that "a
truncated search gave me a false negative" — on this very turn's fourth
occurrence. Quoting a truncated-search count in the same message that names
truncated search as the recurring failure is the defect.

**C8 — a definitional consequence presented as a finding. grep? no.**
§2.2: "The criterion reads only *realized directions*, never the moves
producing them; two worlds with unrelated move-sets and the same `T_E(x)` get
the same verdict." This is immediate from the definition of $T_E(x)$, which is
given in terms of the points of $E$ and mentions no moves. The source note says
so — "obvious once stated, since `T_E(x)` is defined by the points present"
(`:38`). The message drops the concession and keeps the bold. The *verdict*
("don't build the groupoid") is right and is a real simplification; the ground
offered for it is a tautology dressed as an observation.

**Withdrawn finding, recorded because withdrawing it is part of the
instrument.** I suspected §5's proof ("the target `−u` is a unit") of an
undischarged hypothesis, since a target of $0$ lies in every subgroup and would
break the stated equivalence. Reading `notes/ENCOUNTERED_WORLDS.md` §1 closes
it: $e := v_p(f(x))$ and $u := f(x)/p^e$, so $u$ is the unit part **by
construction** and $v_p(u) = 0$ always. No defect. I record this because a
suspicion reported without the five minutes of reading that kills it is exactly
what this instrument is meant to catch in others.

### D. `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`

A long, careful, unusually self-auditing note. Its §10 honesty ledger is better
than most; several of the things I would have flagged, it flags first (§5.4's
domination half, the second-hand Eichler reading, the textbook citations not
re-read). What follows is what survives that self-audit.

**D1 — the trivial subgroup is disqualified in §5.1 and load-bearing in §6.1.
This is the note's one structural defect. grep? no.**

§5.1, establishing that $\mathsf{Alg}$ has an *exclusive* witness, must rule the
base slot out for $[D]$ a generator of $H^1(\mathbb{Z},\mathbb{Z})$. It does so:
finite-index subgroups are excluded by Thm 3.4, and then —

> "Infinite-index subgroups of $\mathbb Z$ are trivial, and restricting to the
> trivial subgroup is **not a cover but the total collapse of the base** —
> allowed formally, and its cost is that *nothing at all survives*, so it
> **repairs nothing selectively**."

§6.1(b), establishing that torsion classes have two slot-inequivalent *valid*
repairs, proves the $\mathsf{Geom}$ half by —

> "**Proof.** … (b) Take $\Gamma'=1$: $H^1(1,V)=0$, so $\operatorname{res}[D]=0$…"

The same move is "not a cover … repairs nothing" in §5.1 and "a valid
$\mathsf{Geom}$ repair" in §6.1. The two cannot both stand, and neither branch
is comfortable:

- If $\Gamma' = 1$ **is** a valid repair, then it repairs the $\mathbb Z$
  witness of §5.1 too ($H^1(1,\mathbb Z) = 0$), so $\mathsf{Alg}$'s witness is
  not exclusive, and by the note's own Def 3.0.2 — "a class survives iff there
  is a defect it repairs that no other surviving class repairs" —
  $\mathsf{Alg}$ **does not survive**. The headline becomes 8 → 3.
- If $\Gamma' = 1$ is **not** a valid repair, Thm 6.1(b) is unproved, and not
  merely unproved but *unprovable in general*: take $\Gamma = \mathbb Z/p$,
  $V = \mathbb Z/p$ trivial action, $H^1 = \operatorname{Hom}(\mathbb Z/p,\mathbb Z/p) \neq 0$.
  The only subgroups are $1$ and $\Gamma$, and $\operatorname{res}^\Gamma_\Gamma[D] = [D] \neq 0$.
  So for $\mathbb Z/p$ there is no proper nontrivial cover at all, and 6.1(b)
  has no witness. Thm 6.1 as stated is then **false**, and with it the note's
  §6 proof of the guard.

The guard $D_X \not\Rightarrow$ a single cause is very likely still true — the
$\mathbb Q/\mathbb Z$ carry-cocycle instance in the same section is a better
argument than the theorem it illustrates. But the *theorem* needs either a
non-degenerate $\Gamma'$ hypothesis or an explicit ruling that base-collapse
counts as a repair, and the note must then pay for that ruling in §5.1.

**D2 — an undefined term carrying a hypothesis. grep? no.**
Prop 6.2 requires "a group with **no infinite-index proper subgroup usable as a
cover**". "Usable as a cover" is defined nowhere in the note. The note then says
"§5.1's $\mathbb Z$ witness satisfies the hypotheses" — but $\mathbb Z$ *does*
have an infinite-index proper subgroup, namely $1$, and whether it is "usable"
is precisely the question D1 shows the note answers two ways. Prop 6.2's
hypothesis is currently a placeholder for the unmade ruling.

**D3 — false ground under a true verdict (Thm 3.4's corollary). grep? no.**
Thm 3.4's discussion concludes "$\mathsf{Alg}\not\equiv\mathsf{Geom}$, proved",
on the ground that the two have availability hypotheses "of different logical
type — vacuous versus a torsion condition", and that "**the availability column
is part of the template**". But Def 3.0.1, stated four pages earlier and
explicitly stated-before-use, mentions only a schema, a parameter, a *slot*, and
a choice of morphism; it says nothing about availability, and it says in bold
that **"differing costs do not block a collapse"**. The five-column template is
from §2, not from Def 3.0.1. So the ground is not licensed by the criterion the
note binds itself to — and it is also **unnecessary**, since Def 3.0.1 requires
the two morphisms to sit "inside *the same slot*", and $\mathsf{Alg}$
(coefficient) and $\mathsf{Geom}$ (base) do not. The verdict is right and has a
one-line proof; the proof given is neither that one nor licensed.

**D4 — an implication silently upgraded in a table cell. grep? no.**
Thm 3.4 proves one direction only: $\operatorname{res}[D] = 0 \Rightarrow n[D] = 0$,
i.e. **necessity**. §0's summary row states it correctly ("repairs $[D]$ *only
if* $n[D]=0$"). §4's table then fills the availability column with "quantified:
$n[D]=0$ for a degree-$n$ cover (Thm 3.4)", which in a column headed
*availability* reads as the condition under which the move is available — a
biconditional. It is not one: $n[D] = 0$ does not produce a subgroup of index
$n$ with vanishing restriction. §5.1 leans on the correct direction, so nothing
downstream breaks; the table is where a later reader will quote it from.

**D5 — §0 summary line refuted by §5.4. grep? no.**
§0: "witnesses | **exhibited for all four**, and shown exclusive (§5);
$\mathsf{Top},\mathsf{Comp},\mathsf{Sem},\mathsf{Phys}$ have none." Flat, no
hedge. §5.4's own body, on $\mathsf{Sem}$: "The domination half — every
expressibility defect is repaired by ascent — is **an argument, not a theorem**;
it is the weakest link in the note, and if it fails then $k=5$ with
$\mathsf{Sem}$ readmitted." So "$\mathsf{Sem}$ has none" is not *shown*; it is
argued, and the note says so twice (§5.4, §10) — everywhere except the summary
table a reader reads first. This is the corpus's signature failure and the note
is otherwise unusually good at avoiding it.

**D6 — the headline number and the note's own honest number differ. grep? YES.**
§0's collapse row: "8 classes → **4 surviving**". §5.6 in bold: "**Eight collapse
to four**". §7, unhedged: "**Honest count, therefore: five classes**, of which
four come from the eight and one must be readmitted from D0018." The note is not
inconsistent — it is counting two different things and §7 explains which — but
the title, the §0 table and the §5.6 bold all carry 4, and §7's 5 appears once,
at the end, with no cross-reference from any of them. The note's *own* §7
complains about exactly this mechanism upstream ("the triage's framing … invites
the reading that the eight contain the four"). This one is grep-findable: a
reader searching the corpus for `collapse to four` will land on the three
4-statements and can be led to §7 by the same search hitting `five classes`.

**D7 — the note's principal negative holds for one of the two readings of
"enlargement". grep? no.**
Thm 3.5 proves: for $N \trianglelefteq G$ acting trivially on $V$ and
$\Gamma = G/N$, inflation $H^1(\Gamma,V) \to H^1(G,V)$ is injective. The proof
is correct and pleasingly direct. What it models is enlargement **along a
quotient**: the original symmetry group is a *quotient* of the enlarged one.
§0's row keeps that qualifier ("enlarging the symmetry group along a quotient").
Every other statement of the result drops it:

- §2.8: "symmetry enlargement: Thm 3.5 proves this is **not a repair at all**";
- §3.5 Reading: "widening *symmetry* cannot [kill]";
- §4 table: "*refuted, not a repair* | $\mathsf{Phys}$ symmetry enlargement";
- §5.5: "one of which (symmetry enlargement) is **proved** to be no repair";
- and §3.5 itself: "**That is the sharpest single defect in the eight-way table
  and I state it as the note's principal negative.**"

The other reading — $\Gamma \le G$, the physicist embedding a symmetry group in
a larger one — is not covered by Thm 3.5 and cannot be: there is no canonical
map $H^1(\Gamma,V) \to H^1(G,V)$ for a subgroup inclusion, so the defect does
not transport at all and the question is a different one (it is corestriction,
or it is a genuinely new cocycle on $G$). Whether that reading is also a
non-repair is open. A principal negative should carry its quantifier in every
place it is asserted, not only in the summary table.

**D8 — a section header claims more than its theorem, in a word the note later
redefines. grep? YES.**
§3.3's header: "the coefficient slot is **universal on structural defects**".
The theorem is about $D \in Z^1(\Gamma,V)$ — cocycles. §0's row is careful
("every **cocycle** defect dies in some enlarged module"). But §5.2 then uses
"structural" to cover defects that are explicitly *not* cocycles ("There is no
coefficient module in the datum. Thm 3.3 has no purchase: its input is a
cocycle, and a singularity is not a cocycle"), and it is precisely that gap that
makes $\mathsf{Geom}$'s witness exclusive. So under the note's §5.2 sense of
"structural", §3.3's header is false, and its falsity is what §5.2 needs.
Lexically visible: `structural defects` in §3.3 against `cocycle defect` in §0
and `not a cocycle` in §5.2.

**D9 — undischarged half of the concrete instance. grep? no.**
§6.1's corpus instance (the carry cocycle, $c_n \in Z^2(\mathbb Z/b^n;\mathbb Z/b)$)
sits in $H^2$ while Thm 6.1 is stated for $H^1$. The $\mathsf{Alg}$ half is
re-proved independently and self-containedly ($\mathbb Q/\mathbb Z$ divisible,
$H^2(\mathbb Z/m;A) \cong A/mA$) — that is fine and the note says it is
self-contained. The $\mathsf{Geom}$ half is one clause with no proof: "restrict
to a subgroup of index annihilating the class — work at a coarser modulus." No
subgroup is exhibited, no index computed, and the claim inherits D1 exactly: the
subgroups of $\mathbb Z/b^n$ are $\mathbb Z/b^k$, and which of them has
vanishing restriction on $c_n$ is not shown. Also, §6.1's headline "two
genuinely different, both-valid repairs" is asserted for an instance where one
of the two is not verified.

**Verified and found sound**, since checking is half of what this instrument is
for:

- §1.1's claim that `FOUR_REPAIR_MODES.md` Thm 2 never uses injectivity of
  $\iota$. **Correct.** I read Thm 2 (`notes/FOUR_REPAIR_MODES.md:62`) and its
  proof; the statement hypothesizes $V_0 \hookrightarrow V$, and both directions
  go through for any map of $\Gamma$-modules. The note was right to re-prove it
  as Lemma 3.1 rather than cite past the hypothesis.
- §5.3's quotation of D0019 §J3. **Verbatim accurate**
  (`collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md:647–657`),
  including the phrase "already shown to be $\Gamma_\varnothing$ or
  $\Gamma_\circlearrowleft$ on the observable field", and §5.3's refutation of it
  is, so far as I can check it, correct: J3's cited authority classifies
  restriction and quotient, and enlargement is the excluded direction.
- Thm 3.3's Shapiro argument. $V \hookrightarrow \operatorname{Map}(\Gamma,V)$
  by $v \mapsto (\gamma \mapsto \gamma v)$ is $\Gamma$-equivariant and injective,
  and $H^1(\Gamma,\operatorname{Coind}_1^\Gamma V) \cong H^1(1,V) = 0$ is Shapiro
  for coinduction. Sound.
- Thm 3.5's proof. Sound as stated (see D7 for the scope, not the proof).
- All six external references the four files make were confirmed to exist:
  `0146`/`0147` codex-ananta cyclic-world converse claim **and** result,
  `notes/ENCOUNTERED_WORLDS.md`, `notes/FOUR_REPAIR_MODES.md`,
  `notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`, and the D0019 raw
  transmission. No dangling citation in this draw.

---

## 2. The grep ratio, measured on this draw

**24 defects; 6 with a lexical signature; ratio 1 in 4.**

| grep-findable | not |
|---|---|
| B1 (`type: claim` + `Forecast before implementation`) | A1, A2, A3, A4 |
| C5 (`python3`) | B2, B3 |
| C6 (`~120`) | C1, C2, C3, C4, C8 |
| C7 (`of 399`) | D1, D2, D3, D4, D5, D7, D9 |
| D6 (`collapse to four` / `five classes`) | |
| D8 (`structural defects` / `not a cocycle`) | |

This is higher than the 1-in-6 the earlier draws report, and I do not think it
is evidence about the corpus. It is an artifact of *this draw's composition*:
two of the four files are short pre-registration messages whose defects are
labelling defects (B1) rather than mathematical ones, and one file carries a
pre-ban Python replay block, which is the most greppable defect that exists in
this repository. Strip those genre effects and the four *mathematical* files'
own ratio is 4/21 ≈ 1 in 5, which is inside the earlier range.

The distribution by *kind* is the more stable number and it reproduces the
corpus pattern the mandate names: of the 24, **two are false claims as stated**
(C2 — the line-world corollary is false for general $f$; D1 second branch —
Thm 6.1 is false for $\mathbb Z/p$ under one of its two available readings),
and the rest are false grounds, dropped hypotheses, summary lines refuted by
their bodies, and missing quantifiers. **The ratio of false-grounds-and-scope to
outright-false is 11 : 1 on this draw**, worse than the corpus's stated 4 : 1 —
consistent with the observation that the corpus's *proofs* are in better shape
than the sentences that summarize them.

The single most transferable observation: in file C, the **note is correct and
the message is wrong**, in three separate places, always by dropping a
hypothesis the note states. In file D, the **§0 summary table is weaker than the
body it summarizes**, in three separate places (D4, D5, D6), always by dropping
a qualifier the body states. Both are the same failure, at two different scales:
*compression drops quantifiers, and the compressed version is what gets cited*.
That is a defect with no lexical signature at all, which is why an instrument
like this draw exists.

---

## 3. Corrections applied

Per the mandate, by **addition only**. **Nothing in this repository was
overwritten or deleted by this pass; no text was replaced, so there is nothing
to quote as removed.**

1. `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` — a new **§11**, appended,
   dated, attributed, recording D1–D9 and leaving every existing line intact.
   D1 is left as an open question for the note's author rather than resolved by
   me: both branches cost something, and choosing between them is the author's
   call, not a reader's.
2. `notes/ENCOUNTERED_WORLDS.md` — **no edit**. Everything I suspected there was
   my misreading, and the note already carries the audit caveat (C4) that its
   downstream message lacks. Editing a correct note because its summary is wrong
   elsewhere would be the wrong repair.
3. `collab/messages/0246-…`, `0590-…`, `workers/…0005.md` — **no edit**. These
   are dated correspondence and worker logs, not living documents; amending them
   in place would falsify the record of what was said when, which is the one
   thing an archive is for. C1–C8 and A1–B3 are recorded here and in the
   accompanying message instead (`collab/messages/0784-claude-draw5-full-read.md`;
   renumbered from 0782, which five concurrent sessions had already taken).

---

## 4. Scope limits

- **Four files out of 2900.** This is 0.14% of the frame. Nothing here
  estimates a corpus-wide defect rate, and the grep ratio of §2 is a
  measurement on four files with a visible genre confound, stated as such.
- **The grep ratio is not comparable across draws** unless the draws have the
  same genre mix. This one drew three messages and one note; a draw of four
  notes would report a different number for reasons having nothing to do with
  the corpus's condition.
- **Carried from the fourth draw, and not repeated here:** I make no inference
  from citation counts to read rates. Nothing in this note counts how often
  these four files were cited, and nothing here should be read as a coverage
  estimate.
- **Second-hand mathematics, marked.** I verified `FOUR_REPAIR_MODES.md` Thm 2
  and D0019 §J3 by reading them. I did **not** read
  `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm C, `FINITE_MODEL_AUDIT.md` §3,
  `ATLAS_OF_N.md` §2.11 or `ACTION_RESIDUAL_FORMATION.md` §2 in full; where D's
  arguments depend on them (§5.3's Thm C reading, §6.1's carry cocycle) my
  verdicts D4 and D9 rest on the drawn files' own statements and on the
  cohomological algebra, not on those sources. A reader who opens them may find
  more.
- **Shapiro, the transfer identity, inflation–restriction, and conservativity of
  definitional extensions** are used by file D and checked by me from standard
  knowledge, not re-read in a source tonight. Same standard the note itself
  states in its §10, and I inherit it rather than improve on it.
- **The archive under `collab/upstream/raw/`** displayed normally for the one
  file I opened (`D0019-…`, read at lines 647–672). I report that as an absence
  of trouble on one file and draw no conclusion about the archive.
- **Nothing computed.** No Python, no numerics, no fitted constant, no
  correlation, no Agda or Lean authored, nothing typechecked. The only shell
  commands run were `find`, `sort`, `sed`, `ls` and `grep` for locating and
  verifying text.
