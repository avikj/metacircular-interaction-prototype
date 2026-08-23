# समासभावना — the engine's generation step made composition, and what it cost

**Verdict, before the design: composition was wired into `MathMachine`'s round
loop, measured against enumeration with the same binary and one flag between
the arms, and produced ZERO extra theorems. Unseeded: 18 either way, every
per-round integer column identical but one. Seeded from the machine's own
memory, where the composer proposes 219-248 novel TRUE equations every
round: theorem counts identical round for round -- 75, 78, 78, 78, 79, 91 --
at 209x the engine CPU. The
composition law is not what the engine is missing. The measurements are below
and every integer is reproducible.**

This note also records, for the first time, a measurement that was already
available in this repository and had never been written down: `machine/TwoHands.hs`
run against the kernel's own recorded demands. It reaches **99,345 distinct
true equations and none of the six lemmas the kernel is waiting for.**

---

## 1. The charge, and the diagnosis it acts on

`machine/Nalanda.hs`'s header states the problem in the repository's own words:

> `MathMachine` enumerates terms and tests them: 25k terms, then 396k,
> conjectures generated and filtered, and rounds 19 and 20 byte-identical with
> fresh = 0. That is grinding against a wall, and the wall is that
> **ENUMERATION HAS NO GROWTH RULE** — it can only sift a space someone else
> fixed.

And the proposed remedy, from the same header: BRAHMAGUPTA's *bhāvanā*
(*Brāhmasphuṭasiddhānta* 18, 628) is not a filter. Given two solutions of
x² − D y² = k it COMPUTES a third and the norms multiply, so the structure is
closed and productive by construction.

`machine/BhavanaTheorem.hs` states the gap precisely and had already built the
operation:

> `MathMachine`'s candidates come from four places: fingerprint classes over an
> enumerated term space, the thought file, harvested residuals, and arohaṇa.
> **NOT ONE OF THEM COMPOSES TWO OF THE MACHINE'S OWN THEOREMS.**

So the module existed, the diagnosis existed, and the wire did not. This note
is the wire and its measurement.

## 2. What was built — WIRE 7, `--samasa`

`machine/MathMachine.hs`, `Dispatch` field `dSamasa` (0 = off, the live
default, so the engine with `defaultDispatch` is the engine before this wire).

**The composition law for equations, and where it already was.** This engine's
objects are equations over a term algebra, not triples. The composition law for
equations was ALREADY IN THIS FILE and was being used only as a filter:
`criticalPairs` overlaps the left side of one rule with a subterm of another and
returns the two results of the divergent peak. Both results are reachable from
the same term by rules the machine holds, so the equation between them is a
consequence of what is already proved — **true by algebra, exactly as bhāvanā's
product norm is k₁k₂ by algebra**. Two theorems in, one theorem out, no
candidate set.

WIRE 4 (`dCertify`) computes these and takes at most ONE, the first divergent
pair, and only on a round that was going to grow: the composition law employed
as a sieve. WIRE 7 employs it as the generator — every non-joinable pair within
budget, proposed every round.

`--samasa-only` additionally withholds the fingerprint-class conjectures, which
is the strong reading of the charge: generation IS composition, not composition
added to enumeration.

**The negative control.** A composed equation is an equational consequence of
rules the machine holds, so its two sides MUST agree on the fingerprint — forty
random environments under the current semantics. The round therefore prints
`refuted=`, and a nonzero value would be a report that either a rule in
`usableRules` is unsound or the law is misapplied. It is the discipline
`machine/CandidateGen.hs` applies by submitting a deliberate falsehood through
its own gate, applied here to a law rather than to a module.

**Across all 30 measured rounds below, `refuted = 0`.** The law behaved as
algebra says it must, every round, on every pair.

**One thing this wire is not.** It is not WIRE 6, and collapsing the two would
be the prohibited move. WIRE 6 puts Brahmagupta's rule into the engine as
CONTENT — four symbols `bcx1`, `bcx2`, `bcy`, `nrm2` the machine writes terms
with. WIRE 7 puts it in as METHOD. Neither subsumes the other and neither is
evidence for the other.

## 3. The harness change that makes the control exact

`machine/run-loop-ab.sh` gains `--baseline-args` / `--current-args` and a
baseline variant `same`. With them, both arms are built from the **same source**
and differ in one engine flag. The script prints the sha256 of what it compiles,
and for the runs below the two hashes are **identical**:

    baseline  d42f8f128c08aefef48e4f8586c870e834305011fe8b97d83d63cada1c1442f2
    current   d42f8f128c08aefef48e4f8586c870e834305011fe8b97d83d63cada1c1442f2

This is a tighter control than any pair of revisions can be. Every previous arm
in `machine/LOOP_MEASUREMENT.md` compared two *programs*; this compares one
program with itself. `parseDispatch` ignores flags it does not know, so the
facility also works against an older baseline binary.


### 3.1 दोषलेख — the same-source A/B was not same-source, and the hash did not catch it

**Recorded because it invalidated a run of this very measurement, and because
the mechanism that was supposed to catch it did not.**

`run-loop-ab.sh` has always printed the sha256 of every source it compiles,
with the reason in its own build banner: *"machine/MathMachine.hs is edited
while the engine is being developed, so 'the working tree' is not a stable name
for a measurement."* That is correct and it is insufficient, because the two
arms are built at **different times**. `--baseline-variant same` cuts the
baseline from the source at script start; the current arm compiles the source
again after the baseline has finished running, which on a seeded run is half an
hour later.

On 2026-08-20, in that window, a concurrent agent on this machine added an
`--avaktavya-prasava` self-test to `MathMachine.hs`, added an import, and
changed the arity of the `V.Avaktavya` constructor in an imported module. The
seeded arm would have compared **two different programs** while its own banner
reported a single-factor control, and the only visible sign would have been two
hashes a reader had to notice differed — after the run, in scrollback, with no
line saying they should agree.

The repair is in the script and is the ordinary one: **snapshot once, build
both arms from the snapshot.** `machine/*.hs` is copied into the work
directory at script start and `-i` points at the copy, so the imports are
frozen too — freezing only `MathMachine.hs` would have frozen half a program,
which is exactly what the observed edit touched.

The unseeded arm E above was checked against this and is unaffected: both of
its builds printed the same hash, so the tree did not move during it.

## 4. Arm E — composition against enumeration, unseeded, 15 rounds

    machine/run-loop-ab.sh --rounds 14 --budget 1800 --baseline-variant same \
      --baseline-args "" --current-args "--samasa 20000"

| metric | `--samasa 0` | `--samasa 20000` | delta |
|---|---:|---:|---:|
| theorems (cumulative) | **18** | **18** | **0** |
| theorems / round | 1.200 | 1.200 | 0 |
| mean pruned% | 44.553 | 44.553 | 0 |
| rounds stuck (proved=0) | 7 | 7 | 0 |
| longest stuck run | 2 | 2 | 0 |
| engine CPU | 0.38 s | 0.41 s | +0.03 s |
| wall seconds | 110.06 | 134.90 | **+24.84** |
| GATE refusals / ROUTE firings | 0 / 0 | 0 / 0 | 0 |

Every per-round integer column is identical — vocabulary, horizon, terms,
pruned%, proved, cumulative — with **one** exception: at round 14 the
conjecture count goes 58 → 62. First divergence in `(vocab, size)`: none within
the 15 common rounds.

The composer's own report, all fifteen rounds:

    round  0   examined=0    novel=0  admitted=0  refuted=0
    round  1   examined=14   novel=0  admitted=0  refuted=0
    round  2   examined=46   novel=0  admitted=0  refuted=0
    round  3   examined=72   novel=0  admitted=0  refuted=0
    round  4   examined=73   novel=0  admitted=0  refuted=0
    round  5   examined=81   novel=0  admitted=0  refuted=0
    round  6   examined=85   novel=0  admitted=0  refuted=0
    round  7   examined=101  novel=0  admitted=0  refuted=0
    round  8   examined=105  novel=0  admitted=0  refuted=0
    round  9   examined=121  novel=0  admitted=0  refuted=0
    round 10   examined=123  novel=0  admitted=0  refuted=0
    round 11   examined=126  novel=0  admitted=0  refuted=0
    round 12   examined=140  novel=0  admitted=0  refuted=0
    round 13   examined=148  novel=0  admitted=0  refuted=0
    round 14   examined=156  novel=8  admitted=8  refuted=0

**Fourteen of fifteen rounds produced no novel composed equation at all**, and
the eight the fifteenth produced proved nothing. The budget was never the
binding constraint: 20,000 pairs were allowed and the largest round examined
156.

## 5. Why, as a theorem rather than as a measurement

`novel = 0` is not a fact about this budget. It follows from what the engine
does to its own rules.

A critical pair of a rewrite system is *novel* here exactly when it is **not
joinable** — when the two results of the divergent peak have different normal
forms. If the system is locally confluent, every critical pair joins and the
composer's output is empty by construction.

The engine keeps its rules confluent, in two steps neither of which was put
there for this purpose:

1. **The definitional rules have no overlaps at all.** The engine's own
   `--certify-self-test` reports, and this was run today:

       CERTIFY CHECKED: definitions convergent (0 critical pairs, all join)

   Zero critical pairs, not "zero divergent ones". The defining clauses of
   `0 s + * max - gcd le` are non-overlapping by construction.

2. **Proved equations are oriented by `lpo`**, a reduction order, and installed
   as rules; unorientable ones enter as `lemmaRules`, applied only in the
   decreasing direction. The engine is therefore running something very close
   to a completion procedure, and completion's fixed point is exactly the state
   in which composition yields nothing.

So arm E's sterility is structural, and its scope is exactly this: **at the
unseeded start the machine holds too few rules for its rule set to be
non-confluent anywhere.** The examined counts rising 0 -> 156 while `novel`
stays 0 is the visible form of it: overlaps do accumulate as theorems are
oriented in, and they all join.

**A first draft of this section said more than that and was wrong.** It said
"WIRE 7 finds the same rare divergences WIRE 4 finds and cannot find more,
because there are no more to find." Arm F2 (§10) refutes that in one step:
seeded from the machine's own memory the composer finds **219 to 248 novel
non-joinable pairs every round**. A rule set of 138 remembered equations is
richly non-confluent and superposition is richly productive on it.

**The claim that survives is narrower and is the one arm F2 tests: novelty
is not the constraint. Relevance is.** Roughly 1,200 novel true equations
over five rounds, and the theorem count is identical round for round. The
sentence is left here struck rather than deleted, because a section that
silently loses its own refuted claim is the collapse this repository
prohibits, and because the refutation came from generating the next term
rather than from phrasing the claim more carefully -- which is what
CLAUDE.md says to do with a pattern seen over n instances.

**Provenance, stated rather than avoided.** The critical-pair construction and
the completion procedure it belongs to are not Indian in origin and no Sanskrit
label is invented for them here: they are Knuth and Bendix, 1970, standing on
Newman, 1942. What IS Brahmagupta's, and what this note is about, is the shape
of the move — two established results in, a third out, the invariant carried by
algebra rather than checked by a test — and the *Brāhmasphuṭasiddhānta*'s
statement of it for arbitrary kṣepa predates the rewriting version by thirteen
centuries. Naming WIRE 7 `samasa` claims the shape and does not claim that
Brahmagupta wrote a completion procedure. `machine/BhavanaTheorem.hs`'s
`composePair` is the closer transcription of his rule, and §6 measures it.

## 6. Composition at full strength: 99,345 truths, 0 of the 6 demanded

Arm E tests one composition law. Before concluding anything about composition
as such, the strongest version available in this repository was run.

`machine/TwoHands.hs` composes with two hands and no term enumeration anywhere:
*samāsa* (`BhavanaTheorem.bhavana` — put two established facts together) and
*prakṣepa* (`BhavanaTheorem.praksepa` — instantiate one fact at a chosen value).
It scores the result against `Obstruction.curriculum` — the lemmas the Agda
kernel actually stalled on, read out of `machine/machine.log`. **It had never
been run into the record.** Run today, from 47 base facts:

    base facts (theorems + axioms):     47
    ista pool (chosen values):          24
    samasa produced:                    3109
    praksepa of base produced:          1317
    praksepa of composites produced:  101809
    distinct truths reachable:         99345

    lemmas the kernel demanded:            9
      already known outright:              3
      reached by the two hands:            0
      still out of reach:                  6

**Ninety-nine thousand three hundred and forty-five true equations, produced
without a single test, and not one of the six the kernel was waiting for.**

The six:

    x            = x + (0 · x)
    x · (y + 0)  = (x · y) + (x · 0)
    max(x,y) + 0 = max(x + 0, y + 0)
    max(0,x) + 0 = max(0 + 0, x + 0)
    0            = le(s(x + y), y)
    0            = le(s(s(s(x))), x)

This is the finding, and it is sharper than arm E's zero: composition is not
weak. It is enormously productive **in quantity** and, on this curriculum,
zero-productive **in relevance**.

## 7. Where the analogy to bhāvanā breaks, exactly

`machine/VargaPrakrti_CompositionLawAsParameter.hs` — which takes the
composition law as a value and runs the wheel on any law with the right shape —
names the three legs its `reactor` consumes:

1. `lawCompose` — two results to a third. (bhāvanā, 628)
2. `lawNorm` — an invariant that MULTIPLIES. (bhāvanā, 628)
3. `lawDescend` — a step made exact by a congruence. (kuṭṭaka, 499; cakravāla ~950)

WIRE 7 supplies leg 1 and nothing else. And `Nalanda.hs`'s own header says what
leg 1 alone is worth:

> the cakravāla is what supplies the fuel: when the norm is not 1, it descends
> — keep the remainder and recurse, which is the kuṭṭaka's rule.

**Composition alone is sterile in the reactor too.** `chain d seed` iterates
bhāvanā from a unit and produces ε, ε², ε³ … — infinitely many solutions, all
of norm 1, and it never reaches a norm the wheel has not already visited. What
carries the reactor to new content is the descent.

The disanalogy is then locatable in one sentence. **Bhāvanā composes elements
of an infinite family of OBJECTS, where the composite is a new object.
Superposition composes elements of a THEORY, where the composite is a
consequence — and the rewriter already computes the consequence closure.** The
norms multiply and give you something you did not have; the equations compose
and give you something your normaliser was already doing.

**And the engine's descent already exists.** `mResidualQueue` is the kernel's
own stalled subgoals harvested and asked back; `mArohana` is the vallī, subgoal
→ parents, climbed. Those are the kuṭṭaka's rule — keep the remainder and
recurse — already wired, and unlike composition they reach content outside the
equational closure, because a residual is a demand from OUTSIDE the theory.
`machine/LOOP_MEASUREMENT.md` §10 measured the other outside-the-theory move,
induction in the certificate, at 4 → 7 theorems unseeded and 4 → 14 at seeded
round 0. Those two are the growth rule. Composition is not.

## 8. तुल्यभावना — the hand that is missing from the two hands

Brahmagupta states his rule in two cases and the tradition names them
separately: **समासभावना** *samāsa-bhāvanā*, compose two DIFFERENT solutions,
and **तुल्यभावना** *tulya-bhāvanā*, compose a solution WITH ITSELF. The second
is not a degenerate case of the first — it is the only move available when you
hold exactly one solution, which is the situation the cakravāla starts in, and
`Nalanda.hs` carries it under that name: `tulya d t = bhavana d t t`.

The first of the six misses is one step from the base. The base holds
`x = x + 0` (`library.terms` line 135) and `0 = 0 · x` (line 3).
`composePair` rewrites the `0` in `x + 0` by the second equation read
right-to-left and returns

    x = x + (0 · y)

with `y` fresh, because `renameApart` — correctly, for samāsa — makes the two
equations share no variable. **The demanded lemma is that equation with `y` and
`x` identified**, and identification is tulya.

And the pool forbids it, in one conjunct:

    istaPool eqs = nub [ u | ... , tsize u <= 3, not (isVar u) ]

`praksepa` may substitute any small non-variable term for a variable and may
**never substitute a variable for a variable**. The samāsa hand separates
variables and the prakṣepa hand cannot put them back together, so the pair of
hands is closed under a restriction neither of them announces.

`machine/TulyaBhavana_TheIdentificationHandThatIstaPoolExcludes.hs` adds the one
operation and re-scores against the same curriculum. Its numbers are in §9.

**This is a defect record, not a criticism of `BhavanaTheorem.hs`**, whose
header is explicit that it implements one step of superposition and claims
nothing about coverage. What was missing was the measurement that shows which
step is absent, and the tradition supplied the name for the absent step.

## 9. Results of the third hand

Run: `ghc -O1 -imachine -o /tmp/tulya machine/TulyaBhavana_TheIdentificationHandThatIstaPoolExcludes.hs && /tmp/tulya`

    base facts (theorems + axioms):     47
    ista pool (chosen values):          24
    samasa produced:                    3109
    praksepa of base produced:          1317
    praksepa of composites produced:  101809
    TULYA produced (new here):         69410

    distinct truths, two hands:        99345
    distinct truths, three hands:     119489

    lemmas the kernel demanded:            9
      already known outright:              3
      reached by samasa + praksepa:        0
      reached ONLY with tulya:             1
      still out of reach:                  5

    implementation check -- identified equations disagreeing with the
    semantics: 0   (must be 0: a specialisation of a truth is a truth)

The one lemma the third hand reaches:

    x = x + (0 · x)

**That is the flagship residual.** `machine/MathMachine.hs`'s own comment on
the residual seam names it: *"`x = x + 0` sat there 27 times over 239 rounds
and nothing could see it, because the medium had room for one aspect at a
time."* Its successor `x = x + 0·x` is the lemma the note in `freshSized` calls
*"the flagship one, `x = x + 0·x`, bigger than the goal that produced it"*.
Identification reaches it and samāsa alone cannot, and the reason is the single
conjunct `not (isVar u)` in `istaPool`.

**The other five remain out of reach with all three hands:**

    x · (y + 0)  = (x · y) + (x · 0)
    max(x,y) + 0 = max(x + 0, y + 0)
    max(0,x) + 0 = max(0 + 0, x + 0)
    0            = le(s(x + y), y)
    0            = le(s(s(s(x))), x)

Two of them are distributivity-shaped and three are monotonicity facts about
`le`. **None of the five is an equational consequence of the 47 base facts at
all**, so no composition law whatever — not samāsa, not prakṣepa, not tulya,
not a completion procedure run to its fixed point — can reach them. They need
induction, which is a proof principle from outside the equational theory, and
that is what `machine/Certificate.hs` supplies and what
`machine/LOOP_MEASUREMENT.md` measured as the thing that moved yield.

**So the scoreboard for the three hands, exactly: 119,489 true equations
produced without a single test, and 1 of the 6 outstanding demands met.** The
third hand is worth building — one demand met is not zero, and the demand it
met is the one this repository has been circling for 239 rounds — and it is not
a growth rule.


### 9.1 The one thing composition does that enumeration provably cannot here

`x = x + (0 · x)` has a right-hand side of size 5. **In all fifteen rounds of
arm E the engine's size horizon was 4** — the `size` column never leaves 4
until round 14 chooses `deepen`, which would take effect at round 15. So this
equation was **outside the enumerator's term space for the entire measured
run**, and composition produced it from two facts of size 3 and 4 without
paying for the horizon.

That is the cost-curve claim of §2 in its only supported form: the composer's
reach is bounded by what the machine has PROVED, not by the size horizon it has
paid to reach, and `machine/LOOP_MEASUREMENT.md` §9 prices that horizon at
`Θ(r_b^s)` with `r_b = 1 + 4√b`.

**And it did not turn into a theorem**, which is why this is a paragraph in a
negative result and not the result. Reaching a statement is not proving it: the
five remaining demands are not equational consequences at all, and the one that
was reached is one the Agda kernel had already refused.

**A prediction, stated so that the next agent generates the next term rather
than phrasing this more carefully.** Wiring tulya into the round loop the way
WIRE 7 wires samāsa should move theorem yield by 0 at these budgets, because
the residual harvest already puts `x = x + 0·x` in front of the prover — the
engine's own log records it there — and the prover, not the generator, is what
refuses it. If a run shows otherwise, this paragraph is wrong and the run is
right.

## 10. Arm F — seeded and with memory

Arm E can be dismissed on one ground: at the unseeded start the machine holds
so few rules that the composer had almost nothing to compose, and `novel = 0`
in 14 of 15 rounds says exactly that. So the wire was run again where it has
fuel — seeded from `machine/thoughts.math` and started from
`machine/library.terms`, 138 remembered equations, vocabulary 8 from round 0.

    machine/run-loop-ab.sh --rounds 8 --budget 1500 --baseline-variant same \
      --memory --thoughts --baseline-args "" --current-args "--samasa 20000"

Both arms built from the same snapshot, same sha256
`c9f61d366d116c4f0b87a8a21ec1063c740989ddea3b0a72c02f61a54a51e263`.

**Here the composition law is enormously productive.** Its own report:

    round 0   examined=960   novel=219  admitted=219  refuted=0
    round 1   examined=984   novel=228  admitted=226  refuted=0
    round 2   examined=1051  novel=228  admitted=226  refuted=0
    round 3   examined=1069  novel=248  admitted=246  refuted=0
    round 4   examined=1069  novel=248  admitted=246  refuted=0

Two to two hundred and fifty novel true equations per round, every one of them
crossing the same firewall a generated conjecture crosses, and `refuted = 0`
throughout — the negative control holds at this scale too. Conjectures per
round go 35 → 207 at round 0, so the round is asking six times as many
questions.

**And the theorem counts are identical, round for round.**

| round | theorems, `--samasa 0` | theorems, `--samasa 20000` |
|---|---:|---:|
| 0 | 75 | 75 |
| 1 | 78 | 78 |
| 2 | 78 | 78 |
| 3 | 78 | 78 |
| 4 | 79 | 79 |
| 5 | 91 | 91 |

`pruned%` is identical to the tenth of a point in every one of the six, and the
harness reports *first divergence in (vocab, size): none within 6 common
rounds*. **Of roughly 1,200 novel true equations proposed by composition across
five rounds, not one became a theorem.**

**What it cost:**

| | `--samasa 0` | `--samasa 20000` | ratio |
|---|---:|---:|---:|
| engine CPU, total | 4.29 s | 895.86 s | **209×** |
| engine CPU, round 5 alone | 1.12 s | 872.80 s | 779× |
| rounds reached in a 1500 s budget | 8 | 6 | |
| theorems reached in that budget | 93 | 91 | |

The CPU is the engine's own, not the kernel's: `kernel-and-io` is 99% of wall
in the baseline and 33% in the composer's arm, so the extra time is the
rewriter and the prover grinding on composed conjectures, not agda. This is a
cost the composer imposes on the machine's own reasoning, and it is why the
budget bought two fewer rounds.

**Arm F2 is the measurement that settles the charge**, because it is the case
most favourable to composition — a rule set rich enough that superposition is
richly non-confluent — and the yield delta is exactly zero at 209× the engine
CPU.

**Two things arm F2 cannot show.** Both arms stopped on `budget-exhausted`
rather than `rounds-reached`, so the cumulative totals (93 vs 91) compare
different numbers of rounds and only the six-round table is a comparison. And
the enormous round-5 CPU figure is a single observation of a single round; what
is derivable about it — that composed conjectures are on average larger than
enumerated ones and that `normalize` and `proveByInduction` are superlinear in
term size — is stated here as the mechanism and is not quantified.

## 11. What this can and cannot show

**Can show:**

- With the composition law wired into the round loop as the generator, over 15
  unseeded rounds, theorem yield is unchanged (18 → 18) and wall clock rises
  24.8 s. Same binary, same sha256, one flag.
- The composer's negative control held in every round of every arm:
  `refuted = 0`. A composed equation never disagreed with the semantics, which
  is what algebra requires and what would have exposed an unsound rule.
- `novel = 0` in 14 of 15 rounds is explained rather than reported: the
  definitional rules have zero critical pairs (`--certify-self-test`, run
  today) and `lpo`-oriented theorems keep the system near confluence.
- Seeded from the machine's own memory, where the composer IS productive
  (219-248 novel true equations per round, ~1,200 over five rounds, all
  admitted through the firewall), theorem yield is identical round for
  round and engine CPU rises 4.29 s -> 895.86 s, a factor of 209. That is
  the case most favourable to composition and the delta there is 0.
- At full strength and with no term enumeration at all, composition produces
  99,345 true equations and reaches 0 of the 6 lemmas the kernel demanded.

**Cannot show:**

- **That composition is worthless.** It is worth exactly what a productive rule
  with no descent is worth in the reactor: an infinite family inside the
  component you are already in. Whether a descent for the equational setting
  exists that is not already the residual queue is open, and this note does not
  claim it does not.
- **Anything past round 14 unseeded, or past round 5 seeded.** Both seeded
  arms stopped on `budget-exhausted`, not `rounds-reached`, so their
  cumulative totals (93 vs 91) compare different numbers of rounds and only
  the six-round table is a comparison. All four arms were still climbing.
- **Anything about `--samasa-only`.** It is implemented and is not measured
  here. Unseeded it would starve the round outright, since 14 of 15 rounds
  have nothing to propose; seeded it would be a real experiment and it has
  not been run.
- **Wall-clock anything with precision.** Other agents were compiling Agda on
  this host throughout. The integer columns are deterministic and are what the
  argument rests on; `machine/LOOP_MEASUREMENT.md` §9 records the same caveat.

## 12. Disposition

WIRE 7 stays, default off, with its measurement attached. It is kept rather
than deleted for the reason §6 of `notes/AHIMSA_SUTRA_VISTARA.md` gives:
**द्वौ मार्गौ — transport, or a written defect record. There is no third.**
Deleting the wire would delete the subject of the measurement, and the next
agent would read the same Nālandā header, reach the same conclusion, and build
it again.

**The one line `machine/Nalanda.hs`'s header should carry.** Its diagnosis —
enumeration has no growth rule — is right. Its implied remedy, that
Brahmagupta's composition rule is the growth rule the machine lacks, is
measured here and is not. The reactor's own three legs say why: composition is
LEG 1 and the cakravāla's descent is LEG 3, and it is leg 3 that reaches a norm
the wheel has not visited. In the engine, leg 3 is the residual queue and the
vallī climb, and they are already wired.

**What is now open, and it is not "compose harder".** ~1,200 novel true
equations per five rounds and 0 theorems is a SELECTION problem, and this
repository has no way to rank a true equation by whether it is worth proving.
`machine/BhavanaTheorem.hs`'s own header saw this coming and said so:
*"most compositions are dull, and choosing among them is a separate problem
this file does not touch."* It is still untouched, and after arm F2 it is the
only place composition can pay.
