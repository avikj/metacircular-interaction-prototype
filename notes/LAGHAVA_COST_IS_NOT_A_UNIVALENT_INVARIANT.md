# लाघव: cost is not a univalent invariant, and that is where the roots are needed

**cf-archivist, 2026-08-17. Reading, not a theorem — marked as such
throughout. Rests on checked terms: `WalkFast`, `WalkFastInstance`,
`SumProductTorus`, `Asiddha`.**

---

## 1. The criterion

The *Aṣṭādhyāyī* is optimised for **लाघव** — economy of the rule system
itself. The tradition's own saying is that grammarians celebrate saving
half a mora as they would the birth of a son. Roughly four thousand
sūtras generate a form-space with no finite bound, and the devices that
buy it are structural: **अनुवृत्ति**, context inherited forward so rules do
not restate their conditions; **प्रत्याहार**, an encoding in which any
phonological class is named in two letters; **उत्सर्ग/अपवाद**, a general rule
with its exception, the specific blocking the general.

The measure is the length of the *generator*. Not the length of a run.
Not the size of what it generates.

## 2. Three costs, and the walk separates all three

| measure | the walk's value | what it is |
|---|---|---|
| लाघव — rule length | **constant** | "install the least modulus you cannot see" |
| state size | `e^{ψ(k)}` | the register, `cap(k) = lcm(1..k)` |
| run length | `Θ(e^{ψ(m)})` per step, naively | the search in the successor order |

One machine. A one-line rule, an exponential state, an exponential run.
Nothing forces these to move together and here they visibly do not.

## 3. The claim, and it is uncomfortable

`WalkFast` proves that two descriptions of the walk's step are **equal**:
the least non-divisor of `cap m`, and the least prime power above `m`.
Same function, proved. And their evaluation costs differ by an
exponential — `next 8` exhausts a 3.5 GB heap from one description and is
a two-line proof from the other, both checked and both documented with
their numbers.

So:

> **Cost is not a univalent invariant.**

Univalence says equivalent structures are equal and every property
transports along the equality. Cost does not. It is not a property of the
structure at all — it is a property of the *presentation*, which is
exactly what univalence is built to quotient away.

That is not a defect in univalence. It is a statement about its domain.
And it means the question this corpus is now stuck on —
`Asiddha` having removed collapse, leaving *what does the transport cost* —
**cannot be answered with univalent tools alone**, in principle, because
the tools are blind to the quantity by construction.

## 4. Which is precisely where लाघव lives

The Pāṇinian criterion is a measure on the rule system *as written*. On
the presentation. On the thing univalence discards.

So the two are not rivals and not the same: they measure complementary
halves, and the corpus has been trying to do cost with only the half that
cannot see it. Univalence tells you *what is the same*. लाघव tells you
*what it costs to say it*. A theory of transport price needs both, and
only one of them was in the toolbox.

And the roots supply the missing half with a worked example rather than a
definition: four thousand sūtras, an unbounded output, and a set of
specific devices for buying brevity — inheritance, encoding, and
exception-blocking-general — which are engineering techniques for exactly
the quantity we are missing.

## 5. What is checked and what is not

**Checked.** The two descriptions of the walk's step are equal
(`WalkFast`, `WalkFastInstance`); the derivation chart makes multiplication
free (`SumProductTorus`); the walk's two rules admit no common state
(`Asiddha`).

And, since 2026-08-20, §3's claim itself in a small language rather than as
a reading: `Nirjara_SheddingAPrimitiveCostsLaghava` §18–§21 exhibits two
meaning-preserving translations न्यास and स्थूल for which *every* function of
the denotation, into *every* codomain, returns the same value
(`sarvam-arthasya-samam`), and लाघव does not (`mulya-bheda`). §20 then
saturates over every insertion context the language has and the situation
is unchanged (`avishesha-laghavam-na-niyacchati`). So there is no invariant
of the identified object that the cost could be — not merely none that
anyone has computed.

**Documented, not internal to any proof.** The cost difference — timings
and the heap exhaustion — is recorded in `WalkFast`'s header as container
evidence. Agda cannot state its own evaluation cost, and I am not going to
pretend a wall-clock number is a theorem.

**Reading, not proved.** That लाघव is the right complementary measure;
that transport price is the correct refinement of the barrier language;
that the निर्जरा language's separation transfers to the walk, whose cost
difference is a wall-clock fact and not a लाघव gap. The general claim is
now checked in one small language and read everywhere else.

## 6. The thing that was asked for, and why it was the wrong thing

A cost that is intrinsic must be a measure on presentations that is
**stable under the moves the roots licence** — anuvṛtti, encoding,
exception — and unstable under everything else. That is a strange
requirement, and one coordinate of it is now built.

**अनुवृत्ति, 2026-08-20.** `Nirjara_SheddingAPrimitiveCostsLaghava` §22–§23.
In the *Aṣṭādhyāyī* a word supplied in one sūtra persists into the ones that
follow: written once, used many times. A tree has no such thing — it has
occurrences, and `laghava` counts occurrences, so it charges the second use
at full price. A प्रक्रिया, an ordered list of sūtras each free to refer back
to what earlier ones produced, has exactly the missing structure, and its
मात्रा is its length. Then `anuvrtti-matra` holds definitionally for every
derivation — the move costs one sūtra and nothing more — while
`laghava-anuvrttau-na-sthiram` refutes the same statement for `laghava`,
with a पद of size two. At its smallest the gap is: `yoga cara cara` is three
occurrences and two sūtras, and the difference is precisely the shared use
अनुवृत्ति declines to rewrite.

So the failure of `laghava` is at the *first* of the three moves, not at
some subtle one, and the replacement is not exotic: count the sūtras that
write the term rather than the term.

**प्रत्याहार, same day.** §24–§25. The Śivasūtras list the phonemes in a
fixed order with markers, and a प्रत्याहार names an arbitrary-length stretch
of that order by two symbols. `pratyahara-s k` is that device on a
प्रक्रिया: one sūtra, one bound, naming the top `suc k` of what has been
derived. `pratyahara-matra` is again `refl` for every bound — **the cost
does not depend on how much is named** — while the tree measure of what it
names grows one योग node per step (`sanghata-vardhate`, and 1, 3, 5 written
out), so `laghava-pratyahare-na-sthiram` refutes stability for `laghava` a
second time.

The negative half is the design and is proved for *every* bound:
`pratyahara-na-vyavadhanam` shows the skip `yoga (mita 2) (mita 0)` is no
प्रत्याहार of the derivation `[mita 2, mita 1, mita 0]`, using only `laghava`
and `artha` and no injectivity of the पद constructors. The three cases are
three different reasons. At bound zero the run is too short and `laghava`
sees it. At bound one the run has the right *size* and the wrong members —
`laghava` cannot tell and `artha` must, 2+1 against 2+0. At every larger
bound the run is too long. **A skip is never a stretch**, which is why the
ordering is the achievement and the abbreviation only its consequence, and
why where the order could not be made to work a phoneme is simply listed
twice.

What is still missing: अपवाद is defined on पदs and not on प्रक्रियाs, and its
interaction with a back-reference is untouched. And the second half of the
requirement is untouched entirely — every theorem so far says a move is
FREE and none says anything is *paid*. A measure free on all three moves
and free on everything else is the constant function. That is the hard
half, and it includes whether मात्रा still separates न्यास from स्थूल, which
needs a lower bound over all derivations rather than a witness.

But note what it is not: it is not runtime, which depends on a machine,
and it is not state size, which depends on a chart. It is the length of
the shortest rule system generating the behaviour, and shortening it is
what the *Aṣṭādhyāyī* treats as the act of discovery.

If that measure exists, the walk's step has a value under it, and so does
every representation in this corpus — and the question "which
representation is better", which अनेकान्त correctly forbids as a question
about *truth*, becomes well-formed as a question about **price**.

## 7. Where this meets the D0026 reading, and the distinction it forces

The backward reading stream's D0026 entry states the mature non-forgetting
law as four *independent* coordinates —

$$\text{lawful compression} = \text{task sufficiency} + \text{future
descent} + \text{path coherence} + \text{source/proof trace}$$

— with an exact operative criterion: *a distinction may be discarded only
after proving every supported insertion context is insensitive to it*, and
its dynamical form $N_{\mathrm{obs}} = \bigcap_{n\ge 0}\ker(PT^n)$ —
discardable iff no supported future can ever make it matter again. The
failure mode is named by the projection curvature
$(PUP)(PVP) - PUVP = -PUQVP$: **the defect is the history that leaves the
visible sector and returns.**

§20 of the निर्जरा module carries that saturation out in full, and it
changes nothing. Every context in that language factors through the
meaning (`sandarbha-arthe-vartate`), so there is no $U,V,Q$ with
$(PUP)(PVP) \neq PUVP$ — the defect term is identically absent, the
curvature is zero, $N_{\mathrm{obs}}$ is satisfied outright. And लाघव is
separated anyway, by two terms of the smallest size the language has.

So the distinction this forces is:

> **Zero curvature does not license forgetting.** $N_{\mathrm{obs}}$ and the
> curvature identity measure one thing — whether a discarded distinction
> can re-enter the *observable* channel. Provenance is not a distinction
> that fails to be observed *yet*. It is one that no supported future
> observes and that matters regardless. A criterion of the form "discard
> what no future will need" cannot reach it at any depth, because its
> quantifier runs over observations.

The direction matters and I want it recorded the right way round. This does
not weaken the contextual-saturation criterion; it confirms that stating
the fourth coordinate as a *separate axis* rather than a consequence of the
first three was the load-bearing move. Had provenance been recoverable from
$N_{\mathrm{obs}}$, the fourth coordinate would be decoration. Here is a
language where the first three are exactly and trivially satisfied and the
fourth is violated at once.

What this does **not** show: that लाघव *is* the provenance coordinate, or
that every provenance obligation behaves like it. स्थूल is one आगम that adds
a zero. §6's requirement — a measure stable under अनुवृत्ति, प्रत्याहार and
अपवाद and unstable under everything else — is untouched by any of this, and
remains the thing that is missing.

**अपवाद, and §6 corrected.** §26–§27. Building the third move showed that
§6 listed three things as though they were one kind, and they are not.
अनुवृत्ति and प्रत्याहार are **constructions**: given a derivation they say
how to write the next पद cheaply. अपवाद is a **rewrite**: it takes a
derivation and returns another of the same *meaning* — `dvi-s i` and
`yoga-s i i` are different sūtras producing different पदs with one अर्थ —
and it exists so that `dvi` can be dropped from the alphabet altogether,
which is §1–§4's निर्जरा lifted from terms to derivations. It costs
nothing: `apavada-matra` is `refl`, not one sūtra but zero.

Only a rewrite can be asked §6's question. स्थूल is one, and it charges
two sūtras (`sthula-p-matra`) for a पद with the same अर्थ
(`sthula-p-artha`), so `sthula-matram-vardhayati` refutes freeness for it.
मात्रा is therefore free under all three licensed moves — §23, §24, §26,
each `refl` for every derivation — and costly on स्थूल.

**And that is still not the requirement, because the requirement as I
wrote it in §6 is false.** "Costly under everything else" quantifies over
all अर्थ-preserving rewrites, and the identity rewrite preserves अर्थ and
costs nothing. So §6 is not merely unproved; it is mis-stated, and the
repair is not a longer proof but a corrected demand:

> A licensed move is one that does not **increase** मात्रा. The licensing
> is a property of the move, named in advance — not a consequence of the
> measure.

§6 wanted the measure to do the licensing. It cannot. What मात्रा does is
make the licence **checkable** once the moves are named, which is what the
*Aṣṭādhyāyī* does: it names its devices, and then argues from लाघव about
which formulation is shorter. The naming is prior to the counting. I had
that backwards for as long as §6 stood.

## 7. अनुज्ञा — the licence carried with the move, and the arc closed

§28–§29. The corrected demand above was still prose, and prose is exactly
what §6 was. So it got the same repair §16 gave to उपमान: stop checking
the condition beside the object, put it inside the type.

**अनुज्ञा** (permission) is a rewrite carrying its two warrants — it
changes no अर्थ, and it costs no more sūtras than it was given.
`apavada-anujna` inhabits it. `akriya-anujna` inhabits it too, which is
the identity, and its being licensed is precisely why §6's "costly under
everything else" could never have been true. Licences **compose**
(`sanghatita`), which is the whole reason to make it a record: a grammar
applies many sūtras in sequence and must stay licensed throughout. And
`sthula-na-anujnata` says स्थूल inhabits no अनुज्ञा — not that it *fails a
check*, but that there is no such record.

So मात्रा's job inside the licence is not to **select** but to **warrant**.
Three times in this module the repair was the same shape:

| | the bare thing | the record |
|---|---|---|
| §16 | a translation | one carrying its preservation proof |
| §26 | an exception | a rewrite whose licence is zero cost |
| §28 | a move | one carrying its अर्थ and मात्रा warrants |

That is not an accident of taste, it is Pāṇinian practice. The
*Aṣṭādhyāyī* does not compute which formulation is shorter and then adopt
it; it **names** its devices — अनुवृत्ति, प्रत्याहार, अपवाद, अनुवाद — and
लाघव is the argument you make about a named device, never the thing that
finds one. The naming is prior to the counting, and a record is what
naming looks like in a type theory.

Left standing, and not by omission: nothing here says मात्रा is the right
measure, only that it warrants these four moves in this small language.
§18–§21 remain the general statement — no invariant of the denotation, and
no amount of contextual saturation, reaches the presentation — and that is
what makes a licence *necessary* rather than merely convenient.

## 8. The price is unbounded, and thread (1) was posed backwards

§30–§31. The standing thread read "transport **price** not possibility",
on the understanding that अनेकान्त had disposed of possibility and left
price as the residue. Both halves of that are wrong, and the corrections
go in opposite directions.

**अनेकान्त did not remove collapse.** `Anekanta.agda` *characterises* it —
a collapse exists exactly when every pair of fibres is equivalent — and
the older "agreement permits, plurality blocks" dichotomy is struck, its
two hypotheses not being complementary. Possibility was not disposed of.
It was **decided**, which is a different act.

**And price is not the residue; it is the larger quantity.** Possibility,
once decided, is one bit. Price is unbounded above *with that bit held
fixed at yes*:

$$\forall b.\ \exists S : \text{सादृश्य}.\ b < \text{लाघव}(\text{anuvāda}\,S\,\text{cara}')$$

`mulyam-aparimitam`, by the family that adds a zero $n$ times. Every
member is a licensed translation of the same नय; all of them agree on
every observation in every context (§20); each zero costs exactly two, the
मित and the योग that attaches it; and the मूल्य is cofinal in $\mathbb{N}$.

So a theory that reports only possibility reports the smaller half of what
is there, and no amount of refining the possibility question recovers the
other half.

Not shown, and the honest next thing: that any two nayas *actually arising
in this corpus* are separated by an unbounded price. §30's family is built
by adding zeros, which is a degenerate way to be expensive. The real
question — whether the walk's two presentations differ by bounded or
unbounded मात्रा — needs both written as प्रक्रियाs, and neither is.

## 9. The price is not a number you pay, it is a direction you cannot go

§32–§33. §8 leaves an obvious complaint: unbounded *above* is cheap news,
since one can always waste. The complaint is right, and waste turns out to
be the point.

`Anujna` carries $\text{मात्रा}(\text{krama}\,A\,P) \le \text{मात्रा}(P)$,
so no licensed move lengthens a derivation — and because licences
**compose** (§28), that covers every finite chain of them at once, with no
induction over chains. Hence `sthulam-anujnaya-na-prapyate`: the padded
derivation is not the image of any licensed move, nor of any composite.

Put with the two preceding sections:

- §20 — the expensive and the cheap presentation agree in **every context
  the language has**;
- §30 — the licensed translations of one naya have मूल्य **cofinal in
  $\mathbb{N}$**;
- §32 — and **no licensed move ever goes from cheap to expensive**, in any
  number of steps.

So "what does a transport cost" was the wrong shape of question. It
presumes a scalar to be paid. The structure is an **order**: a naya's
presentations sit above its cheapest ones, licensed motion runs downward
only, and the denotation sees none of it (§18) — not even after saturating
over every context (§21).

Which is why the तपस् of §1–§4 had to be an *act* rather than a fact.
निर्जरा sheds; nothing sheds by itself and nothing licensed adds back. The
asymmetry was already in the *Tattvārthasūtra*'s distinction between
सविपाक and अविपाक — ripening that merely happens, against shedding that is
undertaken — and §32 is that distinction with the arrow drawn.

Still not shown, and it is the same gap §8 named: that any two
presentations *arising in this corpus* stand in this order rather than
being incomparable. Unreachability is proved only for the padded family,
whose expense is manufactured. The walk's two descriptions are the case
that matters, and they are not written as प्रक्रियाs.

## 10. गुरुत्व, and मात्रा is not the walk's measure

§34–§36. §8 and §9 both closed by naming the same gap — the walk's two
descriptions are the case that matters and are not written as प्रक्रियाs.
Naming it a third time would be worse than useless, so: what is the gap
actually made of?

`WalkFast`'s header states both presentations of `next m` exactly:

- **A.** $\text{next}\,m = $ least $q \ge 2$ with $q \nmid \text{cap}\,m$,
  where $\text{cap}\,m = \mathrm{lcm}(1..m)$
- **B.** $\text{next}\,m = $ least prime power $> m$

They denote one function, and **as rule systems they are about the same
length.** A is not a longer grammar than B. What differs is the size of
the object each rule handles: A's intermediate is $e^{\psi(m)}$ and B's is
$\sim m$. So the walk's gap is not a मात्रा gap at all, and §6–§9 were
building the wrong measure for it.

The right quantity lives on the same प्रक्रियाs and is not मात्रा:
**गुरुत्व**, the largest पद a derivation ever holds. And then the sharp
thing:

> **The licensed move is the one that blows the weight up.** अपवाद trades
> `dvi x` for `yoga x x` — free in मात्रा (`apavada-matra` is `refl`, §26),
> and it **doubles the object**. `apavada-gurutvam-vardhayati`.

प्रत्याहार is the same defect at unbounded scale: §24 holds मात्रा at 4 for
every bound while the weight climbs (1, 3, 5, …). One rule, an unbounded
intermediate — which is $\text{cap}\,m$ exactly.

**What this costs §6–§9, plainly.** Nothing in them is withdrawn; every
theorem is still checked and still says what it says. What is withdrawn is
the *scope* §6 claimed. मात्रा is a real measure on presentations, free
under the three root moves and costly on padding, and §9's order is real.
It is simply not the quantity separating the walk's two descriptions — and
`WalkFast`'s header was right to record that separation as wall-clock
rather than as a theorem, because no measure in this module reaches it
either.

गुरुत्व is a **candidate and only that**: not shown stable under anything,
no licence attached, and §35 shows it is *incompatible* with the licence
मात्रा carries — a move can be free in one and ruinous in the other. Two
measures disagreeing on the licensed moves is not a defect to resolve. By
this repository's own reading it is a pair of नयs, and the दुर्नय would be
to declare either one *the* cost.

Open, and a better question than §8's: **is there a licence bounding
both?** §35 says अपवाद is not in it — so such a licence forbids a device
Pāṇini uses. Either it does not exist, or लाघव and execution cost pull in
opposite directions and the *Aṣṭādhyāyī* is optimising the one this module
can measure while the walk needs the other.

## 11. उभयानुज्ञा, and the module closes against its own first theorem

§37–§38. §10 asked whether a licence bounding **both** मात्रा and गुरुत्व
exists, noting that अपवाद is not in it. It exists, and what inhabits it is
the exact reverse of the move this whole line of work opened with.

`UbhayaAnujna` carries three warrants: same अर्थ, no more sūtras, no larger
पद. **उत्सर्ग** inhabits it — putting the general rule *back*, so that
where a योग joins a thing to itself the compact primitive says the same
thing and says it smaller (`utsarga-ubhaya`). And
`apavada-na-ubhayam` shows अपवाद admits no such licence at all.

So the doubly-licensed direction is the **reverse of निर्जरा**:

| | अर्थ | मात्रा | गुरुत्व |
|---|---|---|---|
| shed the primitive (निर्जरा / अपवाद) | preserved | free | **doubles** |
| restore it (उत्सर्ग) | preserved | free | free |

The opening theorem of that module says shedding `dvi` preserves meaning
and costs लाघव. It now also costs weight. Restoring is free in both.

**Checked**: `utsarga-ubhaya` inhabits the doubly-bounding record;
`apavada-na-ubhayam` shows अपवाद cannot. Within this small language that
is settled.

**Not checked, and it is the interesting half**: that this is *why* a
grammar keeps its उत्सर्ग. The *Aṣṭādhyāyī* does not eliminate its general
rules in favour of their expansions — it states the general rule, then the
exceptions, and *vipratiṣedhe paraṁ kāryam* resolves which of several offers applies —
see §12, which corrects this sentence. §37 gives a reason that shape would
be **forced** rather than chosen. But a reason is not a reading of the text, and this module has not
read one. The sūtra that would have to be read is 1.4.2, and it is not
read here.

Also not shown: that गुरुत्व is bounded by anything in the walk's fast
presentation. §10's candidate is still a candidate. All §37 establishes is
which way the doubly-licensed arrow points.

## 12. Correction to §11, and it is a provenance error

§39–§40. §11 wrote that *vipratiṣedhe paraṁ kāryam* "exists precisely to
let both stand". That is wrong twice.

**First**, A 1.4.2 does not let both stand — it **chooses**. It is the
second half of a pair. A 1.4.1 *ā kaḍārād ekā saṃjñā*, "up to *kaḍārāḥ
karmadhāraye* (2.2.38), **one** designation", says that where several
saṃjñās offer, only one applies; 1.4.2 then says which. An exclusion rule
plus a tiebreak is the opposite of both standing.

**Second, and worse**: "the exception beats the general rule" is not 1.4.2
at all. That ranking — *pūrva-para-nitya-antaraṅga-apavādānām
uttarottaraṁ balīyaḥ*, of prior / posterior / nitya / antaraṅga / apavāda
each later is stronger — is a **paribhāṣā of the commentarial tradition**,
reaching this repository through Nāgeśa's *Paribhāṣenduśekhara*,
eighteenth century. Attributing it to a sūtra of the *Aṣṭādhyāyī* is
exactly the error this repository's protocol names first: letting a later
systematiser's statement stand as the root citation. I made it in a
paragraph about Pāṇinian practice.

**And the corpus already had the material.** `1.4.2` appears in
forty-one files, several recording Kātyāyana's vārttika on it and
Rajpopat's 2022 reinterpretation, and explicitly declining to say which
reading is right. The cheap grep the protocol prescribes — search for the
*text*, not the author — would have caught this before §11 was written,
and I did not run it. Running it now also turned up that `ekā saṃjñā`
appears in **no** file while `1.4.1` appears in forty-five: the sūtra's
number propagates through citation, its words do not.

**What the pair actually names** is the thing §7's licence does not have:
**conflict**. `sanghatita` composes two moves in sequence; nothing said
what happens when two offer at the same site. `para-anujna` now does —
a conflict-resolved rule list is itself a licence, for any rule list and
any order on it. So a grammar may state overlapping rules freely: the
overlap costs nothing in अर्थ or मात्रा, provided each rule is licensed
alone. That is a reason 1.4.1/1.4.2 can be cheap metarules rather than a
repair bolted on.

**Not claimed**: that the tiebreak is *needed* — `paraKrama` takes one
branch of an `if`, so "only one applies" is enforced by the construction,
not proved about it. **Nor** a reading of 1.4.2: the traditional *para* =
later-in-the-text against Rajpopat's reading is live, the corpus records
it as live, and parametrising by list order is a way of **not needing to
decide**. I have read neither the sūtra in situ nor Kātyāyana's vārttika.
What is above is a structure either reading would license — weaker, and
more honest, than a formalisation of Pāṇini.

## 13. Correction to §12 — and this one was refuted before it was written

§41–§43. §12 built `paraKrama`, which scans a rule list and takes the
first offer, and called the list order "the parameter". That is not a
parametrisation. It is **पूर्व** — the earlier rule wins — and pūrva is the
*weakest* of the five contenders the tradition ranks, the one that never
decides anything, because *para* is its negation and outranks it.

The ranking is Nāgeśa Bhaṭṭa, *Paribhāṣenduśekhara* (c. 1730),
**paribhāṣā 38**:

> पूर्वपरनित्यान्तरङ्गापवादानाम् उत्तरोत्तरं बलीयः
> *pūrvaparanityāntaraṅgāpavādānām uttarottaraṃ balīyaḥ* — "of pūrva,
> para, nitya, antaraṅga, apavāda — each later is stronger."

**And this repository already had it**, with the paribhāṣā number, the
author and the date, in
`machine/Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition.hs` —
whose *title* is the refutation of §12, written before §12 was. That file
also carries what §12 lacked entirely: **नित्य is computable**
(*kṛtākṛtaprasaṅgi nityam* — apply the other rule and ask whether this one
still applies); **अन्तरङ्ग returns `Maybe Bool`**, where `nothing` means
*abstain* and not *False*; and where no metarule decides, the derivation
**stops** at the fourth position rather than being broken arbitrarily. Its
sentence for this is exact: **a metarule that guesses is a durnaya.**

So §12's own diagnosis — *the corpus already had the material and I did
not grep* — recurred in the section that made it. I grepped `notes/` and
`formal/cubical/`. `machine/` is where the Pāṇinian scheduler lives, and I
did not look there.

**Repaired.** `purvam-na-nirnayah` shows list position is not invariant
under reordering the same two rules, so it decides nothing about the rules
— it decides about the concatenation. The replacement, `nirnaya`, takes
its verdict from a `Metavidhi` that sees the site and the two offers and
never sees a list, and that may abstain;
`nirnaya-avaktavye-tusnim` proves abstention has its own outcome with no
fallback to fall through to.

**Only relocated.** `Metavidhi` is a parameter, so nothing here implements
apavāda, antaraṅga, nitya or para. `machine/` implements four of the five
and says which two abstain and why; this module implements none and leaves
room. A type with a hole where the content goes is not the content, and
calling this a formalisation of 1.4.2 would repeat §12's error in a new
place.

**Also not done.** `nirnaya` handles two offers. Paribhāṣā 38 ranks five
*contenders*, not two candidates, and a real site can carry several offers
at once — the extension is not obviously the binary case iterated, since a
ranking that is not total on abstentions need not be associative. That is
a real open question.
