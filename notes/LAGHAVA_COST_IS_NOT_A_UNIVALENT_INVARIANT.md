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

## 6. The next thing to build, named so it can be refused

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
