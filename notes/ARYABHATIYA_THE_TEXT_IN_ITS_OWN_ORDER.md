# Āryabhaṭīya (499 CE), in its own order

**Set down 2026-08-19.** Fifth of the set. No application, no mapping to code
in this repository, no argument of my own.

**Why this exists.** `CLAUDE.md`'s table names the Āryabhaṭīya in its first
row — *"`KuttakaValli.agda`, the descent law | Āryabhaṭa, *Āryabhaṭīya*,
kuṭṭaka/vallī | 499 | 'extended Euclidean algorithm'"* — and this repository
cites Āryabhaṭa in at least five notes. **Not one of them is about the text.**
Every mention is a citation attached to something else the repo was doing: the
kuṭṭaka as a source for a descent lemma, the name as evidence in a
naming-rule audit. The work has been mined for the one procedure that
converts and has never been set down as what it is — an astronomical treatise
of 121 verses in which the mathematics occupies one quarter.

**Provenance.** Egress blocks every text archive from this container. Search
returns snippets.

- **[searched]** — anchored against search results this session.
- **[recalled]** — training alone. Sanskrit is the least reliable content
  here and I give it only where I am reasonably confident.
- Where I do not know a verse I say so rather than supply one.

---

## The shape of the work

121 verses in four *pāda*. *[searched — the total and all four counts]*

| pāda | verses | subject |
|---|---|---|
| **Gītikāpāda** | 13 | the alphabetic numeration; astronomical constants; the sine table |
| **Gaṇitapāda** | 33 | mathematics |
| **Kālakriyāpāda** | 25 | reckoning of time; planetary longitudes; yugas |
| **Golapāda** | 50 | the sphere: spherical astronomy, eclipses, the earth's rotation |

**The mathematics is 33 of 121 verses.** This is an astronomy, and the
gaṇita is the apparatus it needs. Reading the Gaṇitapāda alone — which is what
this repository has done — is reading the tool chest and not the work.

---

## I. Gītikāpāda — the notation and the table

### 1.2 — the alphabetic numeration
Āryabhaṭa assigns numerical values to the consonants and uses the vowels to
place them in powers of a hundred, so that very large astronomical constants
fit in a metrical line. *[recalled]* The *varga* letters (k through m) take
the squares' places and the *avarga* letters (y through h) the intermediate
ones.

This is a **positional notation built for verse**, not for calculation. It
exists because the constants had to be memorised and transmitted orally, and
it is a different design problem from the decimal place-value notation the
same tradition also had.

### 1.12 — the sine table
The table of sine-differences is given in a **single verse** in the *gītikā*
metre. *[searched: the table is in Gītikāpāda verse 12, one compact verse.]*

Twenty-four values, at intervals of 225 minutes of arc, tabulating not the
sine but the **jyā** — the half-chord — in the same units as the radius,
R = 3438. *[recalled]* The entries are given as *differences*, so what is
transmitted is the table's second structure, not its values.

The word is **jyā**, "bowstring". It passed into Arabic as *jība*, was read
as *jaib* — "fold, bosom" — and was rendered into Latin as *sinus*. **The
English "sine" is a mistranslation of a transliteration of this word.**

---

## II. Gaṇitapāda — the mathematics

### 2.2 — place value
> *sthānāt sthānaṃ daśaguṇaṃ syāt* *[recalled]*
>
> From place to place, each is ten times the preceding.

Stated as a definition of the naming of places — eka, daśa, śata, sahasra,
and upward — not as a discovery.

### 2.3–2.5 — squares, cubes, and their roots
Definitions of *varga* and *ghana*, then **procedures** for extracting square
and cube roots digit by digit from a decimal numeral. *[recalled]* The
root-extraction algorithms presuppose place value and are among the earliest
written statements of them.

### 2.6 — areas, and an error
The area of a triangle as half the base times the height. *[recalled]* The
same verse extends the rule to a solid — half the base area times the height
— **which is wrong**: that is not the volume of a pyramid, and Āryabhaṭa's
sphere volume is also incorrect. *[recalled]*

Set down because the alternative is hagiography. The text contains errors, and
the commentators — Bhāskara I in 629, and later Nīlakaṇṭha — argue with it.

### 2.10 — the ratio of circumference to diameter
> *caturadhikaṃ śatam aṣṭaguṇaṃ dvāṣaṣṭis tathā sahasrāṇām /
> ayutadvayaviṣkambhasyāsanno vṛttapariṇāhaḥ* *[recalled]*
>
> One hundred and four, multiplied by eight, and sixty-two thousand: this is
> the **approximate** circumference of a circle whose diameter is twenty
> thousand.

62832 / 20000 = 3.1416.

**The operative word is āsanna — "approached", approximate.** Āryabhaṭa
states that the value is not exact. He does not say why, and the tradition
does not read him as claiming irrationality; but the epistemic marker is in
the verse, and it is not in most of what was written elsewhere for the next
thousand years.

### 2.11–2.12 — the construction of the sine table
The rule for generating the tabulated differences: each difference is obtained
from the preceding ones by subtracting an accumulated quantity. *[recalled]*
In effect a second-difference recurrence, which is the discrete form of the
statement that the sine satisfies a second-order equation.

I do not set out the exact wording. This is the verse I would most want to
have in front of me and do not.

### 2.17 — the diagonal
> The square on the *bhujā* and the square on the *koṭi* together are the
> square on the *karṇa*. *[recalled — content; wording approximate]*

Stated for the semi-chord construction, as an instrument for the circle, not
as a theorem of interest in itself.

### 2.19–2.22 — series
Arithmetic progression: the sum, and the *inverse* problem — given the sum,
the first term and the common difference, find the number of terms, which
requires solving a quadratic and Āryabhaṭa gives the root. *[recalled]*

Then *saṅkalita* — summation — and the sums of squares and of cubes:

> the sum of the series of squares, and the sum of the series of cubes.
> *[recalled: he gives both, in closed form.]*

### 2.26 — the rule of three
*trairāśika*, stated as a general procedure for proportion. *[recalled]*

### 2.32–2.33 — कुट्टक
The pulveriser. Given two divisors and two remainders, find the number
leaving those remainders — the general linear indeterminate problem, solved
by a **descent that repeatedly divides and keeps the remainder**, then
back-substitutes up the chain of quotients.

The chain of quotients written in a column is the **vallī**, the creeper, and
the back-substitution runs up it.

This is the row of CLAUDE.md's table: displaced in the literature by
"extended Euclidean algorithm". The displacement loses something specific —
Āryabhaṭa's problem is *congruential from the start*. He is not computing a
gcd and noticing a by-product; he is solving for a number under simultaneous
remainder conditions, because that is what the astronomy asks (a planet's
position, given cycles of different length). **The gcd is the by-product, in
the original.**

---

## III. Kālakriyāpāda — time

Divisions of time from the smallest unit upward; the *yuga* and its
subdivisions; the rule for intercalary months and omitted lunar days; the
mean motions of the planets. *[recalled]*

### 3.10 — the author dates himself
> When sixty times sixty years and three quarter-*yuga*s had elapsed,
> twenty-three years had then passed since my birth. *[recalled — content]*

**This is why the date is 499 CE and the birth 476.** The text carries its own
chronology, which is rare, and it is the anchor for dating much else in the
tradition by relative reference.

---

## IV. Golapāda — the sphere

### The earth is a sphere, and it rotates
> As a man in a boat moving forward sees the stationary objects on the bank
> moving backward, so at Laṅkā one sees the fixed stars moving uniformly
> westward. *[recalled — content; this is the verse usually numbered 4.9]*

The rotation of the earth, argued by relative motion, with a boat. Later
astronomers in the same tradition — including Brahmagupta — **rejected it**,
and the rejection is part of the record.

### Eclipses
The moon and the earth's shadow, not Rāhu. *[recalled]* Āryabhaṭa gives the
computation for the size of the shadow at the moon's distance, and the
mythological account is replaced by a geometrical one inside a text that
still opens with an invocation.

### The moon and planets shine by reflected light *[recalled]*

---

## V. What is displaced by which name

| in the text | commonly called |
|---|---|
| kuṭṭaka / vallī | "extended Euclidean algorithm" |
| jyā (half-chord) | "sine" — via *jība* → *jaib* → *sinus* |
| trairāśika | "rule of three" |
| the 2.10 ratio, marked *āsanna* | quoted as "Āryabhaṭa's π", the approximation-marker usually dropped |

The last is the one this repository should care about: **the qualification is
in the source and is routinely discarded in transmission.** A tradition that
marks its own approximations, quoted as though it did not, is being made to
look less careful than it was.

---

## What I did not establish

- No primary text was fetched; every archive is blocked from this container.
- Only 1.12's location, the four pāda names and their verse counts, and the
  total of 121 are **[searched]**. Everything else is recall.
- The Sanskrit of 2.10 and 2.2 is given from recall and I have not checked it
  against an edition. The other verses I give in content only.
- Verse numbers in the Gaṇitapāda are approximate past 2.10; different
  editions and the two recensions number differently.
- The construction rule at 2.11–2.12 is the verse I most want and least have.
- I have not read Bhāskara I's 629 commentary, which is the earliest and the
  one that fixes most of the readings.
- Nothing here is checked by anything.
