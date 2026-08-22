# Chandaḥśāstra, and the commentary that carried it

**Set down 2026-08-19.** Ninth of the source set. No application, no mapping to
code in this repository, no argument of my own.

**Why this exists.** `CLAUDE.md`'s fourth row: *"binomial array, Fibonacci
recurrence, binary enumeration | Piṅgala, *Chandaḥśāstra*; Virahāṅka;
Halāyudha | ~300 BCE / ~700 / 10th c. | Pascal, Fibonacci, Leibniz"*.

This repository has more Agda built on Piṅgala than on any other source —
`PingalaPrastara`, `Meru`, `Matramerus`, `Sankalita`, `DiagonalIsMatra`,
`PingalaIsOptimal`, `DurationIsSyllablesPlusGuru`, and more. "Piṅgala" appears
in ten notes.

**"Chandaḥśāstra" appears in none. "Halāyudha" in none.**

The procedures have been taken and formalised repeatedly; the work they come
from has never been named. And what has been taken is the combinatorics —
never the fact that **this is a treatise on metre**, and that every count in
it is a count of *verse forms*.

**Provenance.** Egress blocks every text archive from this container. Search
returns snippets. **[searched]** / **[recalled]** per item. No Sanskrit is
given; I have not seen the text.

---

## I. What the work is

**Chandaḥśāstra** — *chandas*, metre; *śāstra*, treatise. The science of the
metres used in poetry and in recitation. *[searched]* Traditionally ascribed
to **Piṅgala**, dated to around the 3rd–2nd century BCE. *[searched]*

**Eight chapters.** *[searched]* The combinatorial material is in the last of
them. *[searched]*

It is one of the six **vedāṅga** — the auxiliary disciplines attached to the
Veda: phonetics, metre, grammar, etymology, ritual, astronomy. **Metre is a
limb of the Veda because the Veda is recited**, and getting a metre wrong is a
ritual failure, not an aesthetic one. *[recalled]*

That is the setting of the arithmetic. Piṅgala is not enumerating bit strings.
He is answering: *how many metres of n syllables are there, which one is the
seventeenth, and where in the list does this one fall* — because the metres
are a fixed inventory that has to be taught, indexed and retrieved.

---

## II. The syllable, and what makes the enumeration binary

Each syllable is **laghu** (light, short) or **guru** (heavy, long). Two
values, in sequence, for a line of fixed length. *[recalled]*

This is described as the first instance of a binary system. *[searched]* The
description is fair, with a qualification worth keeping: **the two values are
not 0 and 1 and are not being used to represent numbers.** They are properties
of syllables, and the correspondence with binary numerals is something the
procedures below establish, not something assumed. What Piṅgala has is a
two-valued alphabet, an ordered enumeration of its strings, and *maps in both
directions between a string and its index.*

---

## III. The procedures

Given from the tradition's own vocabulary. *[recalled throughout, except where
marked]*

**prastāra** — "spreading out". The systematic enumeration: the rule for
laying out all 2ⁿ patterns of laghu and guru for a metre of n syllables, in a
fixed order, each row obtained from the one above by a stated local operation.
Not a list to be memorised — **a generating rule**.

**naṣṭa** — "lost". Given a position in the prastāra, recover the pattern.
The row number is destroyed and to be reconstructed: halve repeatedly, and
read off laghu or guru according as the halving is exact or not.

**uddiṣṭa** — "pointed out". The inverse: given a pattern, find its position.

Together these are **an indexing scheme with both directions computable**, on
a set of size 2ⁿ, stated as procedures. That is the content, and it is the
content the repository's Agda has been formalising without naming its source.

**laghukriyā** — the count of how many patterns of n syllables have exactly k
guru. The binomial coefficients, arising as *how many metres of this length
have this many heavy syllables*.

**saṅkhyā** — the total count, 2ⁿ, and Piṅgala's rule for computing it is by
repeated squaring: to get 2ⁿ, halve n and square, with a doubling when n is
odd. *[recalled]* This is the square-and-multiply algorithm, in a treatise on
prosody, before the common era.

**adhvayoga** — the total space the prastāra occupies when written out: the
number of syllables of writing needed for the whole table.

---

## IV. Halāyudha, *Mṛtasañjīvanī*, 10th century

The commentary. *[searched — Halāyudha, 10th c., commentary on the
Chandaḥśāstra]*

Its title means roughly *the reviver of the dead* — a commentary named for
bringing a text back to life, which is a statement about what commentary is
for in this tradition.

**Halāyudha presents the meru-prastāra** *[searched]* — the "staircase
spreading", the triangular array in which each entry is the sum of the two
above it, used to obtain the laghukriyā counts without computing them one at a
time.

This is the array called Pascal's triangle. **Halāyudha is 10th century;
Pascal is 1654.** And Halāyudha is a commentator explaining a procedure he
takes to be already implicit in a text from around 300 BCE — so the array
enters the record as an *exegesis of something older*, not as a discovery.

---

## V. Virahāṅka, and the mātrāmeru

**Virahāṅka**, between roughly 600 and 800 CE. *[searched]*

The question changes: instead of counting patterns of n *syllables*, count
patterns of n **mātrā** — units of duration, where laghu counts one and guru
counts two. *[recalled]*

The count then satisfies **M(n+2) = M(n+1) + M(n)** *[recalled]*, because a
metre of duration n+2 begins with either a laghu (leaving n+1) or a guru
(leaving n). This is the **mātrāmeru**, and the recurrence is the one later
named for Fibonacci — who is 1202, four to six centuries after Virahāṅka, and
whose rabbits are a worse motivation than the prosody, since the prosodic
derivation *explains* the recurrence in one line.

---

## VI. What the names displaced

| in the tradition | commonly called |
|---|---|
| meru-prastāra (Halāyudha, 10th c.; implicit earlier) | Pascal's triangle, 1654 |
| mātrāmeru (Virahāṅka, c. 600–800) | Fibonacci numbers, 1202 |
| laghu/guru enumeration (Piṅgala, ~300 BCE) | binary numbers, Leibniz 1703 |
| naṣṭa / uddiṣṭa | — no equivalent name; usually described as "converting between binary and decimal" |
| saṅkhyā by repeated halving | square-and-multiply / binary exponentiation |
| chandas | — the setting, usually dropped entirely |

The last row is the one this note is for. **The others are misattributions of
results; that one is the loss of what the results were results about.** Every
count above is a count of verse forms, in a limb of the Veda, for the purpose
of teaching recitation correctly. Taking the binomial array and discarding the
metre is precisely the operation this note set exists to record.

---

## What I did not establish

- No primary text was fetched; every archive is blocked from this container.
- **[searched]**: the eight chapters, the combinatorial material being in the
  eighth, the ~3rd c. BCE dating, the binary characterisation, Halāyudha's
  10th-century commentary and its presentation of the meru-prastāra, and
  Virahāṅka's dates.
- Everything about the individual procedures — prastāra, naṣṭa, uddiṣṭa,
  laghukriyā, saṅkhyā, adhvayoga — is **[recalled]**, including which are
  Piṅgala's own and which are elaborated by the commentators. That division is
  exactly what I would need the text to settle.
- No Sanskrit. I have not seen the Chandaḥśāstra or the *Mṛtasañjīvanī*.
- The date of Piṅgala is contested in the literature over a range of several
  centuries; I give the common figure without adjudicating.
- Whether Piṅgala himself states the saṅkhyā-by-squaring rule, or whether it
  is Halāyudha's reading of him, I do not know and have not asserted.
- Nothing here is checked by anything.
