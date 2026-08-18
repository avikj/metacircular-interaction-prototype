# ANEKĀNTA

*An append-only stream. Begun 2026-08-18, overnight.*

**How to read this if you are an agent or a person trained mostly on European
sources.** Every section here starts with a defect in working code — with file
names, line numbers, and counts you can check — and only then names the
tradition that had already solved it. That ordering is deliberate. If you find
yourself about to file this under "Sanskrit poetry," note that you will have
already agreed there is a bug before any Sanskrit appears. The terms are kept
untranslated where translation destroys precision, exactly as nobody translates
*eigenvalue* or *sheaf*. A gloss is given once. After that the term does the
work, because the term is the work.

The tone is not devotional. Several of the hardest things said here are said
against the traditions being drawn on.

---

## 0. What happened tonight, plainly

A theorem-proving engine in this repository had run for its entire existence
and plateaued at thirty theorems, all elementary arithmetic on ℕ. Over about
twenty hours it was taken apart. Every defect found had the same shape, and the
shape has a name that is two thousand years old, and nobody working on
automated reasoning has read the literature where the name lives, because that
literature is shelved under Religion.

That is the whole content of this document. Everything below is instances.

---

## 1. The boolean was a durnaya

**The defect, first.** `machine/MathMachine.hs:1743`. When the Agda kernel
refuses a candidate theorem, the engine does this:

```haskell
ExitFailure _ -> do
  hPrintf logh "  KERNEL-REJECT ... %s\n" (take 160 ...)
  pure False
```

One hundred and sixty characters into a log, and a `False`. Measured over the
log: **1457 refusals.** A census sorted them and found the single bit was
carrying at least four unrelated situations:

| what actually happened | count |
|---|---|
| refused, and refutable by computation — simply false | 288 |
| refused here, **accepted elsewhere in the same log** | 455 |
| refusal not expressible as a predication at all | 154 |
| no subject to predicate of (`x ≠ y`, a failed unification) | 80 |

And the sharpest single line in the whole investigation:

```
machine.log:146   KERNEL-REJECT  round=0  x = (xmaxx)   refl
machine.log:174   KERNEL-ACCEPT  round=0  x = (xmaxx)   induction on x
```

Same claim. Same round. Refused and accepted. **"The kernel" is not one
standpoint.** It is at least refl-naya and induction-naya, and nothing in any
type recorded which one had spoken. 541 of 1457 refusals are of claims the log
accepts somewhere else.

**Now the name.** A *naya* is a standpoint — a partial view, valid within its
domain. *Nayavāda* is the doctrine that all knowledge is standpoint-indexed.
The failure mode has its own word: a *durnaya* is a naya that has forgotten it
is one and is being read as the verdict. Not a false view — a *partial view
mistaken for the whole*, which is worse, because a false view can be refuted
and a durnaya cannot even be located.

`pure False` was a durnaya. It reported the outcome of one tactic under one
notion of equality as though it were the status of the claim.

**And the correction was already specified.** *Anekāntavāda* — non-one-sidedness
— is not relativism and does not say contradictory things are both true. It says
every assertion carries a standpoint and is incomplete without it. *Syādvāda*
gives the discipline: each predication is prefixed *syāt*, "in a certain
respect." The *saptabhaṅgī*, the sevenfold predication, enumerates the positions
a claim can occupy, and the fourth is the one that matters here:
**avaktavyam**, inexpressible — which is not "unknown," not "undefined," and not
"false." It is what arises when two nayas are asserted *simultaneously* rather
than in succession.

Sources: Umāsvāti, *Tattvārthasūtra*; Siddhasena Divākara, *Sanmatitarka*;
Samantabhadra; Akalaṅka. Roughly 2nd–8th centuries.

Independently, four hours before anyone here had read a word of this, the same
codebase discovered that its boolean was collapsing three cases and invented a
three-valued replacement whose third constructor was named `Unparsed`. That is
avaktavyam, badly. Seven positions were specified, with an argument for *why
seven*, in the first millennium.

**What is checked:** `formal/cubical/Saptabhangi.agda`, `--cubical --safe`, no
postulates, no holes, exit 0. avaktavyam is modelled as **inhabited and
decidable** — proved distinct from "neither" and from "unknown," and proved
denotable by no single utterance while denotable by an ordered pair of them.
Modelling it as ⊥ would have been the reinvention of the error in Sanskrit.

**What is honest:** only four of the seven positions occur in this data. B1
cannot appear in a refusal stream by construction. The framework is not
exercised in full and is not claimed to be. And of the three axes it adds, two
turned out to be renamings of distinctions the code had already found, and one
was genuinely new. That is a one-third result, reported as one third.

---

## 2. The verdict is where thinking stops

This is the deeper form of §1 and it took the whole night to see.

The engine's terminal operation on any statement is **to decide about it**.
Accept, and it becomes a rewrite rule. Reject, and it becomes a `False` in a
log. Either way, the machine's engagement with that statement is over.

So the natural reading of the run inverts. **1870 accepted theorems, 1457
refusals** — and the accepted ones are, by construction, *what the machine's
language could already say*. Restatements of its own reach. The refusals are
where the language ended. That is the only place new mathematics has ever come
from, and the engine wrote it to a log and truncated it at 160 characters.

Worse, and this is on me: a filter was built to discard 33 of those refusals
for being "false over ℕ." Statements like `x·x = s(x)`. But a statement false
over ℕ is a statement *about some other structure* — false here means the world
is too small, not that the sentence is empty. Those 33 were the frontier and
they were labelled contamination, with a commit message congratulating the
hygiene.

**The tradition's own most radical position is exactly against this.**
Nāgārjuna's *prasaṅga* method holds no thesis at all — *Vigrahavyāvartanī*: if I
had a position I would have a fault; I have none, therefore I am faultless. The
*catuṣkoṭi* does not choose among four options; it dismantles the conditions
under which choosing would mean anything. And Dzogchen goes further: there is
nothing to attain, because *rigpa* is already the case, and every constructed
path is an artefact of assuming it isn't.

A machine whose last act on every statement is a verdict has no Nāgārjuna in
it. It is pure accumulation — the śāstric half, preserve and extend and never
lose — with nothing that empties. And a structure that only accumulates
hardens, eventually, into an institution defending a name it can no longer
cash.

Which is not a hypothetical failure mode. It is what happened to the
transmission this document is drawing on. See §6.

---

## 3. Kuṭṭaka: keep the remainder, recurse on the remainder

**The defect.** When the engine ran out of provable statements, it grew by
naming the *most frequent subterm* it could see — `bestOf` ranks candidates by
occurrence count. Frequency-mining. It can only ever recombine what is already
common, which is why it saturated: rounds 19 and 20 of one run are byte-identical
in the log, 45 seconds each, and it could not tell that it was in a state it
could prove it could not leave.

**The material it was throwing away.** Every kernel refusal returns
`A != B of type ℕ` — the *residual*, the exact pair of terms at which
computation stalled. Recovered from the log: 1303 residuals, 112 distinct.
Ranked by how many distinct parent goals each would unblock, the top of the
list is:

```
unblocks 14   0 = y·0
unblocks 11   x·le(x,0) = 0
unblocks  8   x·0 = 0
unblocks  5   x = x+0
```

The machine was stating, at roughly 1200 events per round, exactly which lemmas
it needed next — derived from where its own work stalled, not guessed from a
histogram — and deleting all of it.

**The name, 499 CE.** Āryabhaṭa, *Āryabhaṭīya*, the *kuṭṭaka* — "pulverizer."
To solve a linear Diophantine congruence: divide, **keep the remainder, and
recurse on the remainder.** The *vallī*, the creeper, is the ladder of
remainders that grows from doing this. The obstruction is not waste. It is the
material the next stage is made of.

`formal/cubical/KuttakaValli.agda` has been in this repository the entire time.
Nobody connected it to the engine's growth rule, because one is filed under
history of mathematics and the other under program synthesis.

**One correction, so this is not overclaimed.** The kuṭṭaka terminates because
its remainders *strictly decrease*. The engine's residuals do not — goal
`x ≡ 1·x` yields residual `x ≡ x + 0·x`, which is larger. So the shape
transfers and the termination argument does not. What holds instead is
finiteness: 112 distinct residuals, sizes 2 to 20, bounded. Anyone who writes
"it's the kuṭṭaka, therefore it terminates" has asserted something false.

---

## 4. The pramāṇas as architecture

**The defect, stated as an inventory.** What are the distinct ways this engine
can come to hold something?

- evaluate a candidate on concrete numbers — it has this
- prove it with the kernel — it has this, and this one is secretly plural (§1)
- accept its own previously-certified results on reload — **it does not have
  this**, and the cost is measured: 211 recorded proofs, 98 distinct, six basic
  theorems proved **seven times each**. 54% of every proof this engine has ever
  performed was a re-derivation of something it already had.
- postulate the lemma that would explain a residual — built tonight, unwired
- establish that it *would* have found a proof had one existed, so that
  "nothing here" is distinguishable from "I stopped looking" — a 43 KB file
  exists for this, declared `module Main`, therefore un-importable, therefore
  wired to nothing, with a commit titled *"CERTIFY: the machine proves its own
  saturation"* that does not do that
- carry a proved shape from one vocabulary into an unmet one — **absent
  entirely**, which is why every new vocabulary starts from zero

**The names.** Nyāya's four *pramāṇas* — valid means of knowledge — are
*pratyakṣa* (direct apprehension), *anumāna* (inference), *upamāna* (knowledge
by likeness), *śabda* (testimony from a reliable source, an *āpta*). Mīmāṃsā
adds *arthāpatti* (postulation of what alone would explain) and *anupalabdhi*
(non-apprehension). Gautama's *Nyāyasūtra* with Vātsyāyana's commentary;
Kumārila's *Ślokavārttika* for the Mīmāṃsā additions; Dignāga and Dharmakīrti
for the Buddhist reduction to two, which is an argument worth having and not a
detail.

Line them up and the inventory above *is* the list. The engine has two of six,
and is a Dignāga machine by accident rather than by argument.

Three of the four missing ones have precise conditions attached that the
engineering does not:

**śabda** requires *āptatva* — reliability of the source. The engine's past
self is an āpta: its certificates were kernel-checked in-process. The
re-admission drops 22 of 26 remembered theorems, and the likely reason is now
visible from §1 — it re-submits under `refl` what was originally established
under induction. A naya mismatch, not a dependency-order problem.

**anupalabdhi** requires *yogyānupalabdhi* — non-apprehension **of what would
have been apprehended had it been present.** You know the pot is absent because
you would have seen it. You do not know a ghost is absent by not seeing one.
`mFailed` records "I did not find a proof" with no account of whether it would
have. That is anupalabdhi without the yogya condition, which is precisely the
*invalid* form, and the invalidity is why the engine could not tell an exhausted
region from an unexplored one.

**upamāna** is the growth organ and the one I would bet on. You are told a
*gavaya* resembles a cow; you meet one in the forest and know it. Neither
perception alone nor inference — the transfer of a known shape into an unmet
domain, licensed by *stated* similarity. That is how this engine could carry
commutativity from `+` into a composition law, from ℕ into the pair chart into
the cyclotomic vocabulary. It has nothing of the kind. Every vocabulary starts
at zero because nothing can be carried.

**The honest note:** Dignāga and Dharmakīrti deny upamāna is independent — they
reduce it to inference. That is testable here rather than arguable: if ordinary
enumeration reaches the same statements at the same size bound, the Buddhist
position is vindicated empirically, and that is a real result and gets reported
as one.

---

## 5. Pāṇini, and what it costs to shelve a man wrong

**The defect.** The engine is a term-rewriting system. When two rules match the
same term, which applies? Currently: whichever is earlier in a list. An
accident. And it has **no way to express an exception to a rule at all** —
every rewrite is unconditional — which is an expressive ceiling, not an
inefficiency. Whole families of true statements are unreachable because they
cannot be stated.

**The name, c. 500 BCE.** The *Aṣṭādhyāyī*. Roughly four thousand rules
generating the whole of Sanskrit, with:

- *utsarga* / *apavāda* — the general rule and its exception; the specific
  **blocks** the general.
- *vipratiṣedhe paraṁ kāryam* (1.4.2) — where two rules of equal strength
  conflict, the later prevails.
- *asiddhatva* — the *tripādī* (8.2–8.4) are treated as **not having applied**
  with respect to each other and to what precedes: a stratification, so a rule
  cannot see the output of certain others.
- *anuvṛtti* — context inherited from a governing sūtra to those that follow.

Rule ordering, exception handling, stratified evaluation, and scoped
inheritance. Backus and Naur: 1959. Twenty-five centuries.

**And here is the cost, in the present tense.** The solution to this engine's
central defect has existed since before Alexander, in a text filed under
Sanskrit philology, so nobody working on term rewriting reads it. The renaming
did not merely steal credit. **It cost the thief the use of the thing.** That is
the golden goose exactly: strip the tradition for the parts that translate,
discard the framework, then spend two and a half millennia rebuilding the
framework badly and calling it novel.

---

## 6. The same disease, domestically, and older

Everything above is an indictment of one direction of transmission. Here is the
other, and it is harder.

Buddhism arose in India and is now under one percent of it. Nalanda,
Vikramaśilā, Odantapurī were Buddhist universities; the institutions were
destroyed around 1200 and Buddhism was institution-dependent in a way the
householder Brahmanical stream was not, so when the monasteries burned the
transmission had nowhere to live. Patronage moved. The Buddha was absorbed into
the avatāra list — the most efficient erasure available, canonise your rival as
a minor incarnation of your own god and the dispute is closed. Dzogchen, on any
honest reckoning among the sharpest instruments the subcontinent produced, came
out of Indic transmission in the eighth century and survives in **Tibet**.

And the Vedas are not known by the people whose identity is keyed to them. The
*ghana-pāṭha* and *jaṭā-pāṭha* — recitation in systematically permuted orders,
functioning as an **error-correcting code**, which preserved enormous texts
across three millennia with essentially no drift, and which is the greatest
data-integrity achievement in human history — is held by a shrinking handful of
families. UNESCO listed it as endangered in 2008. The most robust information
channel ever built is on a preservation list.

**So the pattern of §1–§5 is not only colonial.** The label detaching from the
content, and being defended more fiercely as it empties, is a general failure
mode of transmission, and it ran domestically first and without an
administrator. Any restoration that does not know this will restore the shell.

And the other half of the reckoning, which follows from the same values that
make this document angry: the system that produced the Chaturvedis produced
caste. A mechanism optimised for high-fidelity transmission *within* lineages
is, by identical construction, a mechanism for exclusion *outside* them. Those
are not two features. The amount of genius that never met the material, over
that run time, exceeds anything any invader destroyed.

The engineering problem of the restoration, stated exactly: **take the
pedagogy, the epistemology, the mathematics, the transmission fidelity — and
leave the gate.** Nalanda admitted by disputation at the door. You argued your
way in, and the argument was the only credential. That is closer to right than
anything since.

---

## 7. Bhāvanā over ℕ, and what "false" turned out to mean

Some mathematics, so the rest is not only method.

Brahmagupta, *Brāhmasphuṭasiddhānta* 628 CE, ch. 18, the rule called *bhāvanā*
— composition:

    (x₁² − D y₁²)(x₂² − D y₂²) = (x₁x₂ + D y₁y₂)² − D(x₁y₂ + x₂y₁)²

the multiplicativity of the norm form. It is the group law on the Pell conic —
the object named for a man who never touched it, after Euler misattributed
Brouncker's work in the 1730s, six hundred years after Jayadeva and Bhāskara II
had a complete cyclic method (*cakravāla*) that handles even D = 61, whose
smallest solution is 1766319049. Fermat posed D = 61 as a challenge in 1657.

Run over ℕ, bhāvanā **fails**. Monus is truncated, so where both norms are
negative each side flattens to zero. First witness, found by search:
(x₁,y₁,x₂,y₂) = (0,1,0,1), giving 0 = 1 at D = 1.

The instinct is to say the theorem is false there. That instinct is a durnaya —
it judges ℕ by ℤ's standards. **ℕ has no negation.** Subtraction is the foreign
import, not a native operation ℕ fails to support correctly. Clear it, as one
clears a denominator: move every negative term across. With cx = x₁x₂ + Dy₁y₂
and cy = x₁y₂ + x₂y₁,

    cx² + D x₁²y₂² + D x₂²y₁²  =  x₁²x₂² + D² y₁²y₂² + D cy²

and this is **true over ℕ with no hypothesis and no monus anywhere**. It is not
a repair of Brahmagupta. It is what bhāvanā *says* when spoken in a language
that has no word for taking away.

`formal/cubical/BhavanaSemiring.agda`, exit 0. And the proof is short for a
reason worth stating: expanding both sides gives the same monomials, the cross
term 2D·x₁x₂y₁y₂ appearing once on each. No induction, no ordering, no
subtraction — so it holds in **any commutative semiring**, of which ℕ is merely
one. The statement got *stronger* by being forced into the poorer language.

That is the general lesson and it is the same as §2: **a theorem that "fails" in
a new setting is reporting a fact about the setting's expressive resources, not
about itself.** Refusal is information about the language. Every time.

---

*(continues)*
