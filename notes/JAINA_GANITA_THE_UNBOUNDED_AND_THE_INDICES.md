# Jaina gaṇita: the taxonomy of the unbounded, and the laws of indices

**Set down 2026-08-19.** Fourth of the set, after the three Tattvārthasūtra
notes. No application, no mapping to code in this repository, no argument of
my own.

**Why this exists.** `CLAUDE.md` names *Anuyogadvāra*, *Sthānāṅga* and
*Bhagavatī* and says of them: "combinatorics, laws of indices, and a taxonomy
of infinities (*saṃkhyāta* / *asaṃkhyāta* / *ananta*, each with distinct
orders) arising from cosmology and karma theory, not from 'mathematics'." The
repository has been citing that sentence and has never set down what is in
those texts. This is the attempt, at the fidelity this container allows.

**The clause that matters most in that directive is the last one.** These are
not mathematical works with cosmological illustrations. They are canonical and
commentarial works of doctrine in which the counting is *doctrinally
necessary* — how many kinds of soul, how long a hell-life lasts, how many
karmic sub-natures there are. The arithmetic exists because the ontology
demands exact answers about quantities no one can count.

**Provenance.** Egress blocks every text archive from this container
(`wisdomlib.org`, `archive.org`, `en.wikipedia.org`, `jainqq.org`,
`mathshistory.st-andrews.ac.uk`, and the rest). Search returns snippets.

- **[searched]** — anchored against search results this session.
- **[recalled]** — training alone.
- Where a construction is past confident recall I say so rather than supply
  numbers.

---

## I. The threefold division of number

The *Anuyogadvāra-sūtra* (c. 1st c. CE, Śvetāmbara canon — one of the four
*mūlasūtras*) divides all quantity into three. *[searched]*

- **saṃkhyāta** — numerable, countable
- **asaṃkhyāta** — innumerable
- **ananta** — infinite

**This is not a two-way split with a middle term for politeness.** The
innumerable is a *third* category with its own arithmetic: quantities that are
not finite and are not infinite. Nothing in the Greek or the later European
tradition has this position — there, a magnitude is finite or it is not.

Each of the three is further divided into three *[searched]*:

- **jaghanya** — least
- **madhyama** — middling
- **utkṛṣṭa** — greatest

giving nine. And the middle terms are subdivided again — the reported scheme
runs **parīta / yukta / asaṃkhyāta-asaṃkhyāta** within the innumerable, and
correspondingly within the infinite, so the full enumeration is commonly given
as twenty-one kinds. *[recalled; the count 21 is the figure I have, and I am
not confident enough of the sub-scheme to lay out all of it.]*

One named member survives in the search record: **jaghanya-parīta-asaṃkhyāta**,
"the least innumerable of enhanced order". *[searched]* That a specific
innumerable has a proper name is the whole point — these are *individuated*
quantities, not a shrug at largeness.

### Five kinds of ananta

The infinite is itself divided by direction and extent. The kinds reported
*[searched]*: infinite in one direction, infinite in two directions, infinite
in area, infinite everywhere, and perpetually infinite (infinite in time).

**Infinity is classified by the shape of what it extends through.** A line
infinite one way and a line infinite both ways are different infinities — a
distinction about *ordinal structure*, made in a cosmological register,
centuries before it was made anywhere else I know of.

---

## II. Palyopama and sāgaropama — how a quantity too large to count is fixed

The characteristic move is not to name a large number but to *specify a
procedure* whose duration is the number.

**palyopama** — "pit-measure". A pit, given as eight yojana each way, packed
tight with the hair-tips of a seven-day-old lamb; one particle is removed
every hundred years; the time to empty the pit is one palyopama. *[searched —
the pit, the hair, the hundred years. The dimension figure varies in the
sources I saw and I do not fix it.]*

**sāgaropama** — "ocean-measure". Ten *koṭī-koṭī* (ten crore crore) palyopama.
*[searched — the relation is given as ten crores of palyopama in one snippet
and ten koṭī-koṭī in my recall; I report the discrepancy rather than pick.]*

These are the units in which hell-lifespans and heaven-lifespans are stated in
Tattvārthasūtra Adhyāyas 3 and 4. So the arithmetic of Section I is not
ornamental to the cosmology — **it is the notation the cosmology is written
in**, and Umāsvāti's chapters on the worlds cannot be read without it.

---

## III. The laws of indices

### varga — squaring, iterated

The Jaina texts build large numbers by repeated squaring. *[searched]*

- first varga: 2² = 4
- second varga: 4² = 16
- third varga: 16² = 256

and so on — each varga is the square of the last, so the *n*-th varga is
2^(2^n).

**The number of human beings** is given in the *Anuyogadvāra* as the fifth
varga multiplied by the sixth varga. *[searched]* Not as a numeral — as an
expression in this notation. The text works in a positional-free algebra of
iterated squares because the quantity has no convenient decimal form.

### vargita-saṃvargita

In the *Dhavalā* (Vīrasena's commentary on the *Ṣaṭkhaṇḍāgama*, c. 816 CE),
the **vargita-saṃvargita** of *n* is **n^n**. *[searched]*

### The identity quoted from the Anuyogadvāra

> "The first square root multiplied by the second square root is the cube of
> the second square root." *[searched — this is quoted in the secondary
> literature as an Anuyogadvāra statement; I have not seen the Prakrit.]*

In modern notation: √a · a^(1/4) = (a^(1/4))³. Both sides are a^(3/4). It is
a law of indices stated as a relation between roots, with no exponent
notation available to state it in.

### ardhaccheda — the halving-count

**ardhaccheda** of *n* is the number of times *n* can be halved: log₂ *n*.
*[searched — the term is attested in the lists of Jaina mathematical
vocabulary; the identification with log base 2 is how the secondary literature
renders it.]* Related terms in the same family are *trikaccheda* (log₃) and
*caturthaccheda* (log₄). *[recalled]*

The cosmological use reported *[searched]*: the largest diameter is subjected
to log base two to obtain the number of bisections of a *rajju*, the
cosmological unit of distance, and this is related to the number of astral
bodies. **The logarithm is introduced because a bisection-count is what the
cosmology asks for**, not because anyone wanted an inverse to exponentiation.

---

## IV. Combinatorics: the bhaṅga schemes

The *Bhagavatī Sūtra* (Viyāha-pannatti, fifth Aṅga) computes the number of
combinations (*bhaṅga*) selectable from a set — the passages give the counts
for selections of 1, 2, 3, … from a stated collection, and the
*Sthānāṅga* organises doctrine itself by number, chapter *n* treating what
comes in *n*s. *[recalled]*

I do not set out the specific numbers. The passages I can half-recall are
exactly the ones where a wrong figure would be worst.

What I can say without a figure: **the combinatorial question in these texts
is generated by the doctrine.** How many ways can the karmic natures combine;
how many kinds of soul arise from crossing the classifications of
Tattvārthasūtra 2; how many bhaṅgas does a sevenfold predication admit. The
*saptabhaṅgī*'s own "why exactly seven" (3 singly + 3 in pairs + 1 together)
is a combinatorial argument of this kind, and Akalaṅka gives it as one.

---

## V. What the tradition is doing, in its own terms

Set down because leaving it out would be the extraction this note exists to
stop:

The counting is **karma-theoretic and cosmological before it is
mathematical**. A soul's bondage has a duration (Tattvārthasūtra 8.3,
*sthiti*) and that duration must be a definite quantity even when it is
measured in sāgaropama. The loka has a definite extent and a definite
population of each class of being. Omniscience — *kevala-jñāna* — is knowledge
of all substances in all their modes, which is a claim that the totality is
*determinate*, and a determinate totality of infinite extent forces exactly
the apparatus above: individuated infinities, named innumerables, and an
arithmetic that operates on them.

**A tradition that did not hold kevala-jñāna would not have needed the orders
of ananta.** The mathematics is downstream of the soteriology.

---

## What I did not establish

- No primary text was fetched. Every archive is blocked from this container.
- No Prakrit or Sanskrit is given for any Anuyogadvāra passage; I have not
  seen the text.
- The 21-fold subdivision of Section I is reported at the level of its
  structure, not enumerated.
- The palyopama pit dimension and the palyopama→sāgaropama factor are both
  reported with the discrepancy I found rather than resolved.
- The *Bhagavatī* and *Sthānāṅga* combinatorial passages are described in kind
  and not in number, because I would get the numbers wrong.
- Dates: Anuyogadvāra c. 1st c. CE and Dhavalā c. 816 CE are as reported;
  I have not checked either against a critical edition.
- Nothing here is checked by anything.
