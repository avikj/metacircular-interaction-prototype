# Siddhānta-Śiromaṇi (1150 CE), in its own order

**Set down 2026-08-19.** Seventh of the source set, and the last of the three
CLAUDE.md's table names by author. No application, no mapping to code in this
repository, no argument of my own.

**Why this exists.** Row three of the table — *"descent on quadratic forms |
Jayadeva, then Bhāskara II, *Bījagaṇita*, cakravāla | ~950 / 1150 | 'Pell's
equation' — Pell never solved it; Euler misattributed it"*. The repo has taken
cakravāla as a descent law and has a note on the misattribution. It has not
read the work.

**Provenance.** Egress blocks every text archive from this container. Search
returns snippets. **[searched]** / **[recalled]** marked per item. No Sanskrit
is given for any verse; I have not seen the text.

---

## The shape of the work

**Four parts, composed 1150, the author aged thirty-six.** *[searched — the
four parts and the date; the age is recalled]*

| part | subject |
|---|---|
| **Līlāvatī** | arithmetic, mensuration, and combinatorics |
| **Bījagaṇita** | algebra |
| **Grahagaṇita** | the mathematics of the planets |
| **Golādhyāya** | the sphere |

Again: **two parts of four are mathematics, and two are astronomy.** The
*Siddhānta-Śiromaṇi* is one work, and Līlāvatī and Bījagaṇita circulate
separately only because later readers wanted the parts that detach.

That detachment is itself the pattern this note set exists to record.
Līlāvatī has been printed, taught and translated on its own for eight
centuries; the Golādhyāya, which is the reason the arithmetic is there, much
less so.

---

## I. Līlāvatī

The arithmetic is set as **problems addressed to a person**, in verse, with
the vocative — *"Fair-eyed one, tell me…"*, *"O deer-eyed…"*. The tradition
that the work is addressed to the author's daughter is old and is not in the
text as a statement of fact; it comes from a later story about a horoscope and
a water-clock. *[recalled]* I set the story down as a story.

**The address is not decoration.** The whole is pedagogy: worked types with
their rules, in a metre, to be memorised. The problems are about swarms of
bees, lotuses in ponds, monkeys, necklaces broken and scattered — and the
concreteness is the method, because the rule is learned through the instance.

Content *[recalled]*: operations on integers and fractions; the rule of three
and its extensions; interest; mixtures; series; plane figures; excavations and
piles; shadows; and **permutations and combinations** (*aṅka-pāśa*, "the net
of digits"), including the count of permutations with repeated elements.

There is a determination of the number of possible combinations of tastes, and
a metrical statement of the number of variations of Śiva's attributes —
combinatorics arising, again, from a non-mathematical question.

---

## II. Bījagaṇita — the algebra

### खहर — division by zero

Bhāskara treats *n/0* as a quantity in its own right, called **khahara**,
"having the void for divisor". *[searched]*

> A quantity divided by zero becomes a fraction the denominator of which is
> zero. This fraction is termed an infinite quantity. *[searched — quoted in
> the secondary literature as his statement]*

And he adds the property that matters *[recalled]*: in this quantity there is
no alteration though many be added or subtracted — as no change takes place in
the infinite and immutable at the destruction or creation of worlds, though
numerous orders of beings are absorbed or put forth.

**This is a correction of Brahmagupta**, five hundred years earlier, who had
said 0/0 = 0. Bhāskara's answer is not modern rigour — he does not distinguish
the cases, and taken as an arithmetic it still fails — but it is a *better*
answer, and it is arrived at by attending to the behaviour of the object
rather than by completing a table of sign rules.

The analogy he reaches for is the immutable that is unchanged by the creation
and destruction of worlds. **That is where the notion comes from**, and
excising it to leave "he anticipated infinity" is the excision this set of
notes exists to stop.

### चक्रवाल — the cyclic method

The method for x² − Ny² = 1 in general, which Brahmagupta could not reach
except from k = ±1, ±2, ±4.

**Attribution.** Commonly given to Bhāskara II; **Jayadeva, c. 950–1000, had
it earlier.** *[searched]* Jayadeva saw that Brahmagupta's approach could be
generalised and described the general method; Bhāskara refined it in the
*Bījagaṇita*. Jayadeva's own work survives only through quotation in
Udayadivākara's commentary. *[recalled]*

So the row in CLAUDE.md's table is right to name Jayadeva first, and the
displacement here is **two-layered**: Jayadeva displaced by Bhāskara within
the tradition, and the whole displaced by "Pell" outside it.

**What the method does** *[recalled]*: from a triple (a, b, k) with
a² − Nb² = k, choose m such that k divides (a + bm), and among such m take the
one minimising |m² − N|; compose by bhāvanā with (m, 1); divide through by k.
The new triple is again integral, and the cycle repeats. It terminates.

The *choice of m* is the whole invention. Brahmagupta had the composition;
what he lacked was a rule for what to compose *with*, such that the k shrinks
and the process closes. **cakra** — wheel — names the cycling.

Bhāskara solves x² − 61y² = 1, whose least solution is
1766319049² − 61·226153980² = 1. *[recalled]* Fermat proposed the same case as
a challenge to European mathematicians in 1657, five centuries later.

### The rest of the Bījagaṇita
Positive and negative quantities; the unknown (*yāvat-tāvat*, "as much as
so much") and further unknowns named by colours (*varṇa*) — hence the term
*kālaka*, black, for a second unknown; surds; simple and quadratic equations;
indeterminate equations of first and second degree. *[recalled]*

---

## III. Grahagaṇita and Golādhyāya

Planetary mean and true motions, eclipses, risings, conjunctions; and in the
Golādhyāya the sphere, cosmography, the seasons, and instruments. *[recalled]*

Two things belong here and are usually reported out of context:

**The instantaneous motion.** In treating the planets' true motion Bhāskara
uses the difference of positions over a vanishing interval — *tātkālika-gati*,
instantaneous velocity — and states that where the motion is momentarily zero
the planet is at its greatest or least. *[recalled]* This is a derivative-like
argument and a stationary-point condition, arrived at because **the astronomy
needed the planet's speed at an instant**, not because anyone was building a
calculus.

**The rejection of perpetual motion.** Bhāskara describes a self-turning
wheel; later tradition treats it as a perpetual-motion proposal. *[recalled]*
I do not know what he claimed for it and do not assert either way.

---

## IV. What the names displaced

| in the text | commonly called |
|---|---|
| cakravāla, after Jayadeva | "the chakravala method", credited to Bhāskara; the equation "Pell's" |
| khahara | "Bhāskara's infinity", stripped of the immutability analogy |
| aṅka-pāśa | permutations and combinations |
| yāvat-tāvat, varṇa | the unknown, and further unknowns |
| tātkālika-gati | "anticipation of the derivative" |

The last is the one to be careful about in both directions. Calling it an
anticipation of the calculus flatters and distorts; denying it is there
because it is not accompanied by a theory of limits is the opposite error.
**It is a stationary-point argument used for the purpose it was built for.**

---

## What I did not establish

- No primary text was fetched; every archive is blocked from this container.
- **[searched]**: the four parts and their subjects, the 1150 date, the
  khahara statement as quoted, and Jayadeva's priority on cakravāla.
  Everything else is recall.
- No Sanskrit for any verse.
- The cakravāla procedure is given in modern notation. Bhāskara states it as a
  rule on triples with named quantities, not as an algorithm over ℤ.
- The x² − 61y² = 1 solution values are from recall and I have not recomputed
  them.
- The Līlāvatī-as-daughter story is set down as a story; I do not know its
  earliest source.
- I have not read Colebrooke's 1817 translation, which carries both
  Bījagaṇita and the Brāhmasphuṭasiddhānta chapters into English and is the
  route most later citation runs through.
- Nothing here is checked by anything.
