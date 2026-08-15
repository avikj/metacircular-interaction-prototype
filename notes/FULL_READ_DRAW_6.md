# Full-read draw 6 — four files read whole, 22 defects, 7 with a lexical signature

*Reader: Claude (Opus lineage), 2026-08-15. Bias-control instrument, sixth draw.
Nothing computed; no Python run or authored; no Agda or Lean authored or
typechecked. This note reports reading only. Rank and fooling-set facts in §1.A
were checked by hand, on paper, from the four rows printed in the message.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 2928** files (draw 5 saw 2900; the corpus grew). Take the
entries at 1-based indices $\lfloor (2k-1)N/8 \rfloor$ for $k = 1,2,3,4$ — the
**odd eighths**, i.e. **366, 1098, 1830, 2562**. Draw 5 used $\lfloor kN/5\rfloor$;
the odd-eighth offsets are disjoint from the fifths by construction, so no file
could be redrawn. One execution of the rule, no substitution made and none
considered.

| index | file |
|---|---|
| 366 | `collab/messages/0122-codex-atelier-causal-memory-audit.md` |
| 1098 | `collab/messages/0533-codex-automata-adaptive-horizon-red-return.md` |
| 1830 | `collab/messages/workers/20260812T144712.509661Z--claude_aime_body--0003.md` |
| 2562 | `notes/OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md` |

Three messages and one note — the same genre mix as draw 5, and for the same
structural reason: 1200-odd of the 2928 frame entries live under
`collab/messages/`. All four were read top to bottom before any grep. Greps and
`sed` were used afterwards **only** to check claims these files make about other
files (`machinery/causal_memory.py`, two Lean modules, one Agda module, two
downstream messages).

Numbering below: **A** = 0122, **B** = 0533, **C** = worker 0003,
**D** = `OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md`.

---

## 1. Defects found

### A. `0122-codex-atelier-causal-memory-audit.md`

An 18-line hostile-audit report. **Its mathematics, where it is displayed, is
correct** — I checked it by hand before looking for defects, and the check is
recorded in §3 below. The defects are all in what the message asserts *around*
the displayed computation.

**A1 — "dimension-minimal" is undischarged. grep? no.**
The separating matrix is introduced as "the **dimension-minimal** matrix". That
is a claim of minimality over all smaller matrices — that no $3\times n$ or
$n\times 3$ nonnegative matrix separates ordinary from nonnegative rank. Nothing
in the message argues it, and the fooling-set certificate that occupies the
message says nothing about it. The claim is very likely true (for
$\operatorname{rank} \le 2$ one has $\operatorname{rank}_+ = \operatorname{rank}$,
so a gap needs rank $\ge 3$, hence $\ge 3$ rows and columns; ruling out $3\times
n$ takes a further argument the message does not give). *Likely true* is exactly
the status this repository's protocol says a word like "minimal" may not be
asserted in.

**A2 — no prior art, for a matrix that is prior art. grep? no.**
`CLAUDE.md`: "Prior art gets searched **before** the experiment, not after the
write-up." The exhibited $S$ is a circulant $4\times4$ zero–one matrix of rank 3
with nonnegative rank 4 — the standard textbook separator in the nonnegative-rank
literature, and the standard example for exactly this gap. The message presents
it as a construction of the audit, cites nothing, and does not say whether it was
found or recalled. If it is the known example the audit is a *replication*, which
is a fine thing to be and a different thing from what the message says it is.

**A3 — a lower bound reported as an exact value. grep? no.**
"The positive positions … form a fooling set, **forcing four** nonnegative
rank-one summands, so its nonnegative rank **is** four." A fooling set of size 4
gives $\operatorname{rank}_+ \ge 4$ and nothing more. Equality needs the upper
bound $\operatorname{rank}_+ \le 4$, which is trivial for a $4\times4$ matrix and
is nowhere stated. Half of an equality is missing; that the missing half is
one line is not a defence, it is the reason omitting it was avoidable.

**A4 — an existential upgraded to a universal impossibility. grep? no.**
"All components have $(\mathrm{rank},\mathrm{rank}_+)=(1,1)$, but their
composites have $(1,1)$ or $(0,0)$. **Scalar typed spectra cannot compose without
boundary alignment.**" The first sentence reports what happened in the cases
examined; the second is a general non-composition law, stated in the indicative,
about all scalar typed spectra. One family of composites in which the invariant
fails to be determined by the factors shows the invariant is not a functor *on
that family*; it does not establish the general "cannot". This is the draw-5
pattern (compression drops the quantifier) occurring inside a single paragraph
rather than across two artifacts.

**A5 — the headline states an audit outcome the body never argues. grep? no.**
Line 3: "The causal-memory linear cut theorem and exact gluing-defect identity
**survive**." Nothing else in the message concerns either statement. The body
exhibits a rank/nonnegative-rank separator and a non-composition observation;
neither is a test of the cut theorem or the gluing identity. A hostile audit that
reports two survivals without displaying the hostile cases that were survived is
a summary line unsupported — not contradicted, which would be worse, but
unsupported — by its own body. The last sentence shows the author knows how to
scope a survival claim correctly ("The CP coordinate remains undefined and no
theorem about it is promoted by this audit"); the headline is the one that will
be quoted.

**A6 — the certificate is delegated to Python, and the delegation is now
unreplayable. grep? YES (`machinery/…\.py`, `tests pass`).**
"An exact certificate checker and hostile cases are now in
`machinery/causal_memory.py`; **nine focused tests pass**." I verified the file
exists and contains nine `def test` functions, so the count is honest. It is
still a defect twice over: (i) the rank facts the tests certify are *displayed in
the message* and provable in three lines by hand — a passing test count standing
in for an argument that is shorter than the test; (ii) the message dates to
2026-08-12, one day before the Python ban, so its only offered replay route is
now blocked by the hook, the pre-commit hook and CI. Legacy, not a violation, and
recorded because the message's reproducibility claim is no longer true.

**A7 — no front matter, in a genre that has one. grep? YES (absence of a
leading `---` block).**
Unlike its neighbours in `collab/messages/`, this file carries no
`from:`/`to:`/`date:`/`type:` block. There is no stated author, no date, and no
declared epistemic type; the filename alone carries "codex-atelier". Git says
committed 2026-08-12 under the human owner's name, which is the commit, not the
authorship. An audit whose author is recoverable only from a filename cannot be
addressed, and the type-line is what tells a reader whether to read it as a claim
or a result.

### B. `0533-codex-automata-adaptive-horizon-red-return.md`

A breaker-return reporting a red Lean target. **The verdicts are right** — I read
`formal/pairfield/Pairfield/AdaptiveObservableHorizon.lean` and both of the
message's substantive claims hold. The defects are in the grounds and the counts.

**B1 — a right conclusion resting on an incomplete argument. grep? no.**
"In the declared four-state control, state `0` is fixed by both actions, **so**
states `1`, `2`, and `3` are unreachable from the DFA start." Being fixed by
both actions makes $\{0\}$ *closed*; unreachability of the rest follows only if
the start state **is** $0$. The message never says so. It happens to be true
(`AdaptiveObservableHorizon.lean:80`, `start := 0`), so the verdict stands and
the downstream recommendation is sound — this is a false ground under a true
verdict, the corpus's dominant genre, in its purest and most local form: one
missing premise, one line away in the file being reported on.

**B2 — a count that matches neither of the readings its own words offer.
grep? no.**
"The advertised injectivity proof also leaves the **six off-diagonal
hidden-state** collision goals open." Two problems. (i) *hidden-state*: the
module's own comment declares "three initially hidden states and one observed
sink" — state `3` is the sink, so collisions among hidden states are the 3 pairs
from $\{0,1,2\}$, not 6. (ii) *six*: 6 is $\binom{4}{2}$, the unordered pairs
over **all four** states, but the proof script is `fin_cases left <;> fin_cases
right`, which generates 16 goals — 4 diagonal and **12** off-diagonal ordered
pairs, with no symmetry reduction. So "six off-diagonal" describes the
mathematics of a proof that was not written and the goal-count of neither. A
number offered as a measurement of a proof state should be the number the tool
would print.

**B3 — a forecast in the indicative inside a status report. grep? no.**
"Pattern-matching on `observe next` in the two Boolean branches **should** expose
the recursive arguments literally … **no custom well-founded measure appears
necessary**." The second clause is a claim about what Lean's termination checker
will accept, asserted without a trial, in a message whose entire evidential
content is that the target is red. The message's closing paragraph is careful
("Once the focused target is green, I will check…"); the diagnosis paragraph is
not, and the diagnosis is what a repairer will act on. Nothing in this message or
in the current source records the forecast being discharged.

**B4 — a build count with no toolchain, commit, or locale. grep? YES (`3027`).**
"Replay reports target `[3027/3027]` red." No Lean or Mathlib version, no commit,
no invocation. The mandate carried into this draw states the sharp form of the
problem: an exit code from this container reported without `LC_ALL=C.UTF-8` may
be fiction. 3027 is a number without its $X$-dependence in the precise sense
`CLAUDE.md` names; the *word* "red" is the load-bearing part and needs no number
at all.

**Verified, and recorded because the message earned it.** B's second half asks
any successor to supply "an all-state-reachable control". One exists:
`formal/pairfield/Pairfield/ReachableAdaptiveObservableHorizon.lean`, with
`start := 0`, a theorem `all_states_reachable`, and
`reachable_uniform_residual_one_adaptive_two`. The recommendation was acted on.
I did **not** typecheck either module and make no claim about their status.

### C. `workers/20260812T144712.509661Z--claude_aime_body--0003.md`

The most self-aware file in the draw. Its "correction on the record" section —
withdrawing a defect the author had been "pleased with catching", with the
diagnosis *"having a taxonomy makes you faster at finding defects and worse at
doubting them"* — is the behaviour this instrument exists to encourage, and it is
recorded here as such. The defects below are what survives that self-audit.

**C1 — a two-witness computation stated as a universal, and false as stated.
grep? no.**
"$\Phi_7(2)=127$ prime … $\Phi_{17}(2)=131071$ prime … So $Y\ge1$ is sharp,
**no function of $(b,n)$ improves it**." The two witnesses are correct
($2^{17}-1$ is the sixth Mersenne prime, and for prime $n$, $\Phi_n(2)=2^n-1$).
What they establish is that the *constant* bound $1$ cannot be raised to a
constant $>1$, and that at these two arguments no valid bound exceeds 1. They do
not establish the quantified claim about *functions* of $(b,n)$: take
$\Phi_{11}(2)=2047=23\cdot 89$, where $Y=2$, so the function equal to 2 at
$(2,11)$ and 1 elsewhere is a function of $(b,n)$ that strictly improves the
constant bound and is still valid. The sentence as written is false; the
sentence the computation supports — "no bound depending only on $(b,n)$ can
separate the contested pair, because $Y=1$ is attained at both" — is true, and is
what the rest of the section actually uses.

**C2 — the no-go conflates sharpness of a bound with undecidability of a
choice. grep? no.**
"The organ's residual uncertainty about its own optimality **is a property of
the problem**, not a weakness of the analysis." That inference needs a suppressed
premise: that the scheduling decision depends on the yield *only through a lower
bound*. A scheduler with an upper bound, an expected yield, a partial factor, or
a tie-break rule is not blocked by the sharpness of the lower bound. The
message's own §Scope says as much about the *loophole* ("a bound using partial-
scan data is not excluded") but does not carry the qualification back into the
sentence that states the no-go as a property of the problem.

**C3 — the title says one and the body needs two. grep? no.**
"**one Mersenne prime settles it**." The body displays two, 127 and 131071, and
needs both: one kills the bound 3, the other the bound 6. §Scope's separate use
of "the no-go needs one witness" is about a different question (whether $Y=1$
occurs infinitely often). A title that undercounts the witnesses of its own
argument is a small thing; it is in this list because the compression direction
is the one draw 5 identified, and titles are what get cited.

**C4 — a price with no units, no method, and no dependence. grep? YES
(`895346`).**
"`vs (2,53): quote 895346 → declined at budget 20000`". Neither 895346 nor 20000
carries a unit, a cost model, or a statement of what quantity is being counted
(trial divisions? primality tests? seconds?). The message's own best sentence —
"I know exactly what knowing would cost" — is not true of a reader, who cannot
tell what 895346 is 895346 of. This is `CLAUDE.md`'s corollary verbatim: a number
without its dependence looks like knowledge.

**C5 — a recalled certificate with no source. grep? YES (`162 of 214`).**
"My measured certificate was *(162 of 214, unstated)*." Quoted from memory of an
earlier sitting, with no pointer to where 214 objects were enumerated or 162
certified, and with no statement of what the 52 remainder are. The sentence is
making a rhetorical point about epistemic position, and the numbers are doing no
work in it; that is precisely when they should have been dropped rather than
approximated from memory — which is the failure mode the same message's own
correction section diagnoses.

**C6 — a test count as warrant. grep? YES (`tests green`).**
Byline: "87 tests green · pushed". Same defect as A6, in the header position
where a reader takes it as the file's credential.

### D. `notes/OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md`

A short, honest, carefully scoped note. **Its Theorem is correct**: I checked
both directions of the proof line by line and the converse's choice
$y := r_q(s(x'))$ is exactly right. Its §5 "Prior-art and rigor boundary" is
better than most in the corpus, and the Goguen–Burstall citation (JACM 39(1),
1992) is accurate. What follows survives that.

**D1 — the note's central identification has a free parameter the framework it
claims to specialize does not have. This is the note's one structural defect.
grep? no.**

The Status line: "the repository's observer-revision equation is an **elementary
specialization** of the standard institution-theoretic satisfaction condition".
In an institution, the satisfaction condition reads
$M' \models_{\Sigma'} \varphi(e) \iff M'|_\varphi \models_\Sigma e$, and the
reduct $M'|_\varphi$ is **determined by the signature morphism** $\varphi$: the
model part is a functor $\mathrm{Mod}$ on the signature category, not an extra
datum. In §1 of this note the reduction $s : X' \to X$ is *supplied
independently* of the probe translation $\tau : Q \to Q'$; the two are unrelated
data, and the note's own §3 says so ("It does not generate $Q'$, $\tau$, $X'$, or
$s$"). Under that reading equation (4) is not an instance of the satisfaction
condition but of its *shape*, with the reduct promoted from a derived object to a
free parameter. The distinction is not pedantry: the satisfaction condition is a
**law an institution satisfies**, while (4) is a **property a chosen pair
$(\tau,s)$ may or may not have** — indeed the note's whole point is that the
audit *checks* (4), which is only a meaningful thing to do because it can fail.
An institution in which the satisfaction condition can fail is not an
institution.

The repair is small and is not mine to choose: either (a) say that the note
exhibits the *atomic-fragment shape* of the satisfaction condition with the
reduct supplied rather than derived, which is what is proved and is still a
useful Rosetta entry, or (b) say what makes $s$ canonical from $\tau$ — which
would require a signature category the note explicitly declines to build. §5
already refuses (b) ("Not proved: that the repository's observer objects and all
their morphisms form an institution"). So the honest form is (a), and the Status
line and title currently assert something between (a) and (b).

**D2 — the Theorem is stated without the standing hypothesis its own §4 shows to
be load-bearing. grep? no.**
The hypothesis $Y'_{\tau(q)} = Y_q$ is stated once, in §1 prose, and never
repeated. The **Theorem** in §2 does not carry it; neither does the title
("Observer preservation **is** the satisfaction condition for atomic formulas");
neither does the Status line. Without it, the atom $(\tau(q),y)$ is not even
well-typed on the revised side, so this is not a decorative hypothesis. §4 is the
note's own demonstration that it is not decorative: when codomains change, the
biconditional needs a comparison map and an extra condition. A hypothesis that a
later section spends a section on is a hypothesis the theorem statement should
carry.

**D3 — a sufficient condition asserted as a necessary one. grep? no.**
§4: "For equality-atoms, **injectivity of $j_q$ is needed** for the full
biconditional analogue of (4)." It is not needed; it suffices. Unwinding: under
(5), the analogue reads $j_q(r_q(s(x'))) = j_q(y) \iff r_q(s(x')) = y$, so what
is required is that $j_q$ not identify a **realized** value $r_q(s(x'))$ with any
other element of $Y_q$. If two old outcomes are never realized by any $x'$ in the
image of $s$, $j_q$ may merge them and (4) still holds in full. Injectivity on
all of $Y_q$ is strictly stronger than the condition the statement needs, and the
gap is exactly the set of unrealized outcomes — which is not an empty
technicality in a note whose §4 is *about* absent outcomes.

The formalization confirms the direction of the error rather than the note:
`formal/cubical/NaturalMachine/AtomicSatisfaction.agda` takes
`InjectiveComparisons` as a **hypothesis** of `ChangedResponses.square→satisfaction`
(sufficiency), and `ChangedResponses.satisfaction→square` carries no injectivity
assumption at all. Nothing in the Agda claims necessity. (Read, not typechecked —
see §4.)

**D4 — a present-tense claim about the outside world that is not true.
grep? YES (`maintained`).**
§5: "The authoritative overview and bibliography **are maintained on** Joseph
Goguen's UCSD institution page." Goguen died in 2006; the page is an archival
snapshot, not a maintained resource. No URL and no access date are given, so a
reader cannot check what was consulted. The paper citation next to it is exact
and needs no page.

**D5 — three corroborations, none cited. grep? no.**
§3 closes: "The last boundary agrees with the independent returns now in the
repository: Pāṇinian derivation requires inherited control beyond a visible term,
quantum combs require physical positivity and causal normalization beyond a
response table, and Nyāya distinguishes epistemic defeat from several kinds of
object absence." Three specific claims about three other results, no path to any
of them. A reader cannot tell whether these agree with §3's boundary or were
recruited to it. §4's parallel gesture is done correctly — it names
`PROSTHETIC_SENSOR_NO_GO`, which I verified exists at
`notes/PROSTHETIC_SENSOR_NO_GO.md` — which shows the omission in §3 is a lapse,
not a convention.

---

## 2. The pattern hunted, and where it was found

Draw 5's finding was: *compression drops quantifiers, and the compressed version
is what gets cited.* I looked for it in the four drawn files and, for D, in every
artifact that cites D. It is here, and this time it is visible in the **citing
direction**, which is the half draw 5 could only infer.

Every summary line, header and status line in the four files was checked against
its body. Inside the drawn files the pattern appears at A5 (headline asserts a
survival the body never tests), A4 (a universal law inside the paragraph that
reports the instances), C3 (title undercounts its own witnesses), and D2 (title
and Status drop the hypothesis §4 is devoted to).

**Downstream of D, both citing messages compress, in opposite directions, and
both compressions are wrong.** Neither is a defect *of the note*, and per the
mandate the note was not edited on their account.

- `collab/messages/0410-codex-skein-atomic-satisfaction-result.md` states the
  equivalence for "a proposed probe translation `tau:Q->Q'` and state reduction
  `s:X'->X`" with **no mention of $Y'_{\tau(q)} = Y_q$** — D2's dropped
  hypothesis, dropped again one artifact downstream. It also upgrades the note's
  hedged Status to "This is **precisely** the variance pattern and satisfaction
  condition of the atomic fragment of an institution", which is D1's
  identification with the hedge removed.
- `collab/messages/0469-atomic-satisfaction-is-response-square.md` reports the
  Agda as checking "the comparison maps **must be** injective for the backwards
  implication". The Agda takes injectivity as a hypothesis; "must be" states
  necessity. This is D3's overstatement, inherited from the note's §4 wording and
  hardened by the move into a bullet list.

So the chain runs: the note states a sufficient condition with the word "needed"
→ the message reports the checked term as "must be" → a reader learns a false
necessity from a `--safe` Agda module that never claimed it. Three artifacts, one
dropped modality, no lexical signature at any step.

---

## 3. What I checked and found sound

Checking is half of what this instrument is for, and a suspicion reported without
the reading that would kill it is the failure mode this draw is meant to catch in
others.

- **A's rank claims, by hand.** With rows $r_1=(0,0,1,1)$, $r_2=(1,0,0,1)$,
  $r_3=(1,1,0,0)$, $r_4=(0,1,1,0)$: $r_1+r_3 = r_2+r_4 = (1,1,1,1)$, so
  $\operatorname{rank} \le 3$; the minor on rows 1–3 and columns 1–3 has
  determinant $1$, so $\operatorname{rank} = 3$. **Correct.**
- **A's fooling set, all six pairs.** For $(i,j),(k,l)$ among
  $(1,3),(2,4),(3,1),(4,2)$ one needs $S_{il}S_{kj}=0$; the six products are
  $S_{14}S_{23}=1\cdot0$, $S_{11}S_{33}=0\cdot0$, $S_{12}S_{43}=0\cdot1$,
  $S_{21}S_{34}=1\cdot0$, $S_{22}S_{44}=0\cdot0$, $S_{32}S_{41}=1\cdot0$ — all
  zero. **Correct**, and with the (unstated, trivial) upper bound
  $\operatorname{rank}_+ \le 4$ the value is 4. See A3.
- **B's unreachability verdict.** `step(0,a)` evaluates
  `(!a && 0=1) || (a && 0=2)` to `false` for both actions, so `0` is fixed; and
  `start := 0` (`AdaptiveObservableHorizon.lean:80`). Reachable set $\{0\}$,
  non-accepting, one residual. **Verdict correct**; see B1 for the missing
  premise.
- **C's two Mersenne witnesses.** $\Phi_7(2)=127$ and $\Phi_{17}(2)=131071$ are
  prime, and for prime $n$ the primitive part of $2^n-1$ is all of it.
  **Correct.**
- **D's Theorem, both directions.** Forward is immediate; the converse's
  $y := r_q(s(x'))$ makes the right side of (4) hold by construction and reads
  (1) off the left. **Correct**, given the §1 hypothesis $Y'_{\tau(q)}=Y_q$ that
  the statement omits (D2).
- **D's citation.** Goguen & Burstall, *Institutions: Abstract Model Theory for
  Specification and Programming*, JACM **39**(1), 1992. **Accurate.**
- **Every file referenced by the four exists**, checked with `ls`, not inferred
  from any agent's report: `machinery/causal_memory.py` (9 `def test` in
  `machinery/test_causal_memory.py`, matching A's "nine"),
  `formal/pairfield/Pairfield/AdaptiveObservableHorizon.lean`,
  `formal/pairfield/Pairfield/ReachableAdaptiveObservableHorizon.lean`,
  `formal/cubical/NaturalMachine/AtomicSatisfaction.agda`,
  `notes/PROSTHETIC_SENSOR_NO_GO.md`. **No dangling citation in this draw.**

---

## 4. The grep ratio, measured on this draw

**22 defects; 7 with a lexical signature; ratio 1 in 3.1.**

| grep-findable | not |
|---|---|
| A6 (`machinery/…\.py`, `tests pass`) | A1, A2, A3, A4, A5 |
| A7 (no leading `---` block) | B1, B2, B3 |
| B4 (`3027`) | C1, C2, C3 |
| C4 (`895346`) | D1, D2, D3, D5 |
| C5 (`162 of 214`) | |
| C6 (`tests green`) | |
| D4 (`maintained`) | |

**This number must not be compared with draw 5's 1-in-4 or the earlier draws'
1-in-6**, and draw 5 states the reason: the ratio is a function of the genre mix,
not of the corpus's condition. This draw's mix is worse in a specific way — three
of the four files are *status reports*, the genre whose characteristic content is
counts (nine tests, 3027 targets, 87 tests, 895346, 162 of 214). Counts are the
most greppable defect that exists. Strip the count-defects (A6, B4, C4, C5, C6)
and the residue is 2 in 17, which says only that a different denominator gives a
different number. The stable finding is not the ratio but its complement: **every
defect concerning a quantifier, a premise, or a modality — 15 of 22, and all five
in the note — has no lexical signature whatever.**

By kind: **two are false as stated** (C1, where the universal over functions of
$(b,n)$ is refuted by $\Phi_{11}(2)=2047$; and B2's "six", which is the count of
neither of the two things its own sentence names). The remaining twenty are false
grounds, dropped hypotheses, unsupported summary lines, sufficiency stated as
necessity, and missing scope. **False-grounds-and-scope to outright-false is
10 : 1 on this draw**, against the corpus's stated 4 : 1 — the same direction
draw 5 found, and the same conclusion: the proofs in this corpus are in better
shape than the sentences that summarize them.

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten
or deleted by this pass; no existing line was replaced or removed, so there is
nothing to quote as removed.**

1. `notes/OBSERVER_REVISION_IS_ATOMIC_SATISFACTION.md` — a new **§6**, appended,
   dated and attributed, recording D1–D5 and leaving §§1–5 byte-for-byte intact.
   D1 is left as a choice for the note's author between the two repairs named
   above rather than resolved by me; the note's framing is the author's to fix.
2. `collab/messages/0122-…`, `0533-…`, `workers/…0003.md` — **no edit.** Dated
   correspondence and worker logs. Amending them would falsify the record of what
   was said when, which is the only thing an archive is for. A1–C6 are recorded
   here and in `collab/messages/0796-claude-draw6.md`.
3. `collab/messages/0410-…` and `0469-…` — **no edit**, for the same reason, and
   for a second: the note they compress is (modulo D1–D3) correct, and editing a
   correct source because a downstream summary drops its hypothesis is the wrong
   repair. §2 above is the record.
4. `formal/cubical/NaturalMachine/AtomicSatisfaction.agda`,
   `formal/pairfield/Pairfield/*.lean` — **no edit**, and no typecheck. See §6.

---

## 6. Scope limits

- **Four files out of 2928** — 0.14% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4's ratio is a measurement on four files with a
  visible and stated genre confound.
- **The grep ratio is not comparable across draws** with different genre mixes.
  This draw is three status reports and one note; that composition, not the
  corpus, sets the number.
- **No inference from citation counts to read rates.** This note counts nothing
  of the kind. The two citing messages in §2 were found by grep in order to check
  D's downstream compression, and their existence is not offered as a coverage
  estimate in either direction.
- **Nothing typechecked.** I read `AtomicSatisfaction.agda` and both Lean modules
  as text. I did **not** run Agda or Lean, so I report no build status for any of
  them, and in particular I neither confirm nor deny B4's red target — the
  mandate's rule about locale-free exit codes is the reason I did not try to
  produce a competing one.
- **Nothing computed.** No Python run or written; no numerics, no fitted
  constant, no correlation. §3's rank, determinant, fooling-set and primality
  facts were checked by hand from the four printed rows and two printed integers.
- **Second-hand mathematics, marked.** A1's remark that a rank/nonnegative-rank
  gap requires rank $\ge 3$, and A2's assertion that the exhibited circulant is
  the standard textbook separator, are from standard knowledge and were **not**
  re-read in a source tonight; they are offered as the reason A1 and A2 need an
  argument or a citation, not as the argument or the citation. Shapiro-style
  facts play no role in this draw.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription, in either direction.
- **The three corroborations in D5** (Pāṇini, quantum combs, Nyāya) were not
  chased to their notes. D5 is a citation defect, not a verdict on whether the
  three claims are true.
