# Mādhava's series, and the अन्त्यसंस्कार the restatements did not carry

**Set down 2026-08-19.** Tenth of the source set, and the one
`THE_KERALA_TEXTS_BEFORE_ANY_SERIES.md` deliberately deferred:

> I stop here deliberately. **The series belong to a note that comes after this
> one**, and writing them into the same document would be doing again what I did
> two nights ago: reaching past the text for the part that converts.

No application, no mapping to code in this repository, no argument of my own.

---

## 0. Provenance — and a standing caveat in this set is now stale

Every note in this source set carries the same line: *"Egress blocks every text
archive from this container. Search returns snippets."* **That is no longer
true as of this writing.** From this container, this session, `WebFetch` on
`en.wikipedia.org` and `arxiv.org` returned full page content, not snippets.

I record it here because it is a fact about the instrument that eight notes
depend on, and their authors should know it. It does **not** retroactively
weaken those notes — a caveat that was true when written and is honestly
marked is doing its job. It means the next pass can do better than recall.

> **Re-tested 2026-08-20, cf-archivist: BLOCKED AGAIN, in a different
> container.** `WebFetch` on `en.wikipedia.org` → `EGRESS_BLOCKED`; on
> `arxiv.org` → `EGRESS_BLOCKED`. Both refused by the network egress proxy,
> not by a fetch error.
>
> Neither reading is wrong. An egress test is an **event about a container**,
> never a **state of the project** — the same distinction
> `run_the_natural_machine_forever`'s header had to learn about liveness, and
> the same one that let a DUE-BY stamp be read as a verdict on the machine
> (`5788c92a`). The 2026-08-19 line above is a true event; so is this one; and
> a note that says "egress works" without naming its container has recorded a
> state it cannot observe.
>
> **What this means for a reader today:** do not plan a pass around fetching.
> Test it yourself, in your own container, before you promise scholarship you
> may not be able to do — and if it works for you, append a dated line here
> rather than editing the one above. The caveat in the other eight notes is
> live again as of this date.

What it does **not** give me: I still have not read the *Yuktibhāṣā*, the
*Tantrasaṅgraha*, or Śaṅkara Vāriyar's commentary. I have read **encyclopaedia
and secondary-literature descriptions of them**, which is a different thing and
is marked as such throughout.

- **[fetched]** — read this session from a named URL, full text.
- **[searched]** — from search result text only.
- **[recalled]** — training alone.

---

## I. The three series, and how they reach us

**Mādhava of Saṅgamagrāma, c. 1340–1425. His own works on this are lost.**
*[fetched]* What survives is quotation: his successors state the results in his
name, and the attribution is theirs, not a modern reconstruction.

The three, in modern notation *[fetched]*:

$$\arctan x = x - \frac{x^3}{3} + \frac{x^5}{5} - \frac{x^7}{7} + \cdots \quad (|x| \le 1)$$
$$\sin\theta = \theta - \frac{\theta^3}{3!} + \frac{\theta^5}{5!} - \cdots \qquad
\cos\theta = 1 - \frac{\theta^2}{2!} + \frac{\theta^4}{4!} - \cdots$$

Who carries them *[fetched]*: **Nīlakaṇṭha Somayāji** (1444–1544);
**Jyeṣṭhadeva** (c. 1500–1575) in the *Yuktibhāṣā*; **Śaṅkara Vāriyar**
(c. 1500–1560) in his commentary on the *Tantrasaṅgraha*. Verse locations
given as: sine 2.440–2.441, cosine 2.442–2.443, arctangent 2.206–2.209.
*[fetched — I did not verify which edition's numbering this is, and it matters.]*

The tradition's own transmission of the arctangent rule, quoted in translation
*[fetched]*:

> The succeeding terms are obtained by a process of iteration when the first
> term is repeatedly multiplied by the square of the sine and divided by the
> square of the cosine.

**The rule is stated as an iteration on the previous term, not as a closed
form of the general term.** What is transmitted is how to get the next one.

---

## II. अन्त्यसंस्कार — the end correction

*antya*, end; *saṃskāra*, a refinement or perfecting operation. **"End
correction."** *[searched]* The technique corrects the *tail* of a truncated
series: with $S_n$ the sum to $n$ terms, a sequence $a_n$ is supplied such that
$S_n + a_n$ converges faster than $S_n$. *[searched]*

This is the part CLAUDE.md's table names — *"power series, error terms,
convergence acceleration"* — and it is the part that did not travel with the
name. The series called Leibniz's is quoted, in most places it is quoted at
all, **without any correction term**, which is to say: without the reason a
practitioner would compute with it.

$$\frac{\pi}{4} = 1 - \frac13 + \frac15 - \frac17 + \cdots$$

converges so slowly as to be useless for the accuracy a *siddhānta* wants. The
correction is what makes it an instrument.

### The three correction terms

Attributed to Mādhava; each a successively finer estimate of the tail after
$n$ terms *[fetched, both sources agreeing]*:

$$F_1(n) = \frac{1}{4n} \qquad
F_2(n) = \frac{n}{4n^2+1} \qquad
F_3(n) = \frac{n^2+1}{4n^3+5n}$$

The two sources write the third differently — $\dfrac{n^2+1}{4n^3+5n}$ and
$\dfrac{n^2+1}{n(4n^2+5)}$ — and these are the same expression. Recorded
because the set's practice is to report a discrepancy rather than resolve one,
and this one resolves.

Where recorded *[fetched]*: $F_2$ in **Chapter 2, verses 271–274** and $F_3$ in
**Chapter 2, verses 295–296** of the *Laghuvivṛti* commentary on the
*Tantrasaṅgraha*. **The two sources name that commentary differently** — one
"Tantrasaṅgraha-Laghuvivṛti", attributing it to Nīlakaṇṭha and dating it 1501;
the other "Yuktidīpikā-Laghuvivṛti". I do not resolve this. The *Yuktibhāṣā*
contains explicit expressions for $F_2$ and $F_3$. *[fetched]*

Translation of the verse for the second *[fetched, partial]*:

> To the diameter multiplied by 4 alternately add and subtract … the result is
> to be added or subtracted … This gives the circumference more accurately.

and for the third:

> A subtler method, with another correction. [Retain] the first procedure
> involving division of four times the diameter by the odd numbers, 3, 5, etc.

### What they buy

Correct decimal digits of $\pi$ *[fetched]*:

| $n$ | no correction | $F_1$ | $F_2$ | $F_3$ |
|---|---|---|---|---|
| 11 | ~1 | ~4 | ~6 | ~8 |
| 51 | ~2 | ~6 | ~10 | ~13 |
| 101 | ~2 | ~7 | ~11 | ~15 |

**Eleven terms and the third correction give eight digits.** Eleven terms
without it give one.

---

## III. स्थौल्य — the criterion, which is the युक्ति

This is the part I did not expect to find and it is why this note exists.

The Kerala authors did not produce the corrections by inspection. They defined
a **measure of the inaccuracy — *sthaulya* (coarseness, grossness)** — and
chose the correction that makes it vanish to the order they were working at.
*[fetched]* The condition, in the form the secondary source gives it, for a
correction $f$ at odd $p$:

$$f(p-2) + f(p) - \frac{1}{p} \;\approx\; 0$$

That is a consistency requirement between successive partial sums: the two
adjacent corrections must together account for the term that separates them.
Impose it and the corrections are *derived* rather than guessed — the choice of
the even integer $4n$ for the first, and then $k=4$ in the next refinement to
kill the term proportional to $p^2$. *[fetched]*

**This is what *yukti* means, concretely.** The claim that Indian mathematics
is algorithmic and unproved is contradicted here not by a modern reconstruction
but by the tradition's own optimisation criterion, stated as a criterion.

And the scholarly assessment is recorded with it, because leaving it out would
be hagiography — the arXiv author's own words *[fetched]*: *"the rationale
presented by Kerala authors is not strong enough to convince modern
mathematical scholarship."* He also states that **the Kerala texts give no
rationale at all for the third correction term**, and supplies one himself by
extending their method with $k=16$, obtaining a continued-fraction form; and
he derives further corrections in the same pattern, whose numerators run
through successive perfect squares $4, 16, 36, 64, \ldots$ *[fetched]*

Two things are true at once and both belong in the record: the criterion is
theirs and it is a rationale, and it does not meet a modern standard of proof.

---

## IV. What the names displaced

| in the tradition | commonly called | gap |
|---|---|---|
| the arctangent series (Mādhava, before 1425) | Gregory, 1671 | ~250 yr |
| the sine and cosine series (Mādhava) | Newton, 1669 (pub. 1711) | ~250 yr |
| the $\pi$ series **with its अन्त्यसंस्कार** | "Leibniz series", 1673/1676, **usually quoted with no correction term at all** | ~250 yr |
| स्थौल्य as the criterion the correction is chosen to minimise | — no displacement; no current name, and the tradition is usually denied to have had a rationale | — |

**The first three are misattributions and a citation repairs them. The fourth
is not a misattribution.** It is a piece of the mathematics — the reason the
series is usable — that did not survive the crossing, and there is nothing to
correct the attribution *of*, because the receiving tradition did not take it.

---

## V. The स्थौल्य, checked — and what it says the corrections are not

Written 2026-08-20, and it corrects something this corpus published.

§III gives the criterion. Written with $p = 2n+1$ it is

$$f(n) + f(n+1) \;-\; \frac{1}{2n+1} \;=\; E(n),$$

$E$ being the स्थौल्य, and the correction being chosen to make it small.
Cross-multiply and every trace of analysis leaves: for $f = P/Q$ with $P, Q$
polynomial, the statement becomes

$$\bigl(P(n)Q(n{+}1) + P(n{+}1)Q(n)\bigr)\,(2n{+}1) \;=\; Q(n)Q(n{+}1) \;+\; r$$

with $r$ an integer. `formal/cubical/NaturalMachine/AntyaSamskaraSthaulya.agda`
checks this over an **arbitrary commutative ring** — no $\mathbb{R}$, no
$\mathbb{Q}$, no limits — for the three transmitted corrections and for the
fourth convergent of Krishna's continued fraction:

| | $f_k$ | $r$ |
|---|---|---|
| $k=1$ | $1/(4n)$ | $+4$ |
| $k=2$ | $n/(4n^2+1)$ | $-4$ |
| $k=3$ | $(n^2+1)/(4n^3+5n)$ | $+9$ |
| $k=4$ | $(4n^3+13n)/(16n^4+56n^2+9)$ | $-576$ |

**The content is that $r$ does not depend on $n$.** That is what makes an
अन्त्यसंस्कार a correction and not an estimate, and it is why the hierarchy was
reachable without limits: it is a difference equation solved in closed form.

**The correction to this corpus.** That module was called
`AntyaSamskaraIsSquares` and asserted the residues were $1, 4, 9$ — the
squares — and that the pattern was the acceleration. It is withdrawn, and the
mechanism is now exhibited rather than merely confessed. The $1$ was the $k=1$
identity divided through by $4$; both scalings are checked in the module, and
only the divided one produces a square at $k=1$. A residue is a property of the
**representation** $P/Q$, not of the correction $f$, so no sequence of residues
can carry a law at all. And $576 = 24^2$, which is exactly why the fit was
reachable and exactly why it is empty: there is a square at every position and
no relation between them.

**What is invariant.** The स्थौल्य itself, $E(n) = f(n) + f(n{+}1) - 1/(2n{+}1)$,
depends on $f$ alone. In closed form its denominator has degree $2k+1$ —

$$E_1 = \frac{1}{4n(n{+}1)(2n{+}1)}, \qquad
  E_2 = \frac{-4}{(2n{+}1)(4n^2{+}1)(4n^2{+}8n{+}5)}, \qquad
  E_3 \sim n^{-7}, \qquad E_4 \sim n^{-9}$$

— so each successive अन्त्यसंस्कार drops the coarseness by exactly **two orders
in $n$**. Degree survives rescaling; the residue does not. That is the
acceleration, stated in the tradition's own quantity rather than as a pattern in
integers, and it is the sense in which §III's criterion is doing real work: the
Kerala authors are minimising the thing that is invariant.

Stated for $k \le 4$ and checked for $k \le 4$. The general claim — that every
convergent of that continued fraction has स्थौल्य numerator constant in $n$ — is
not proved here and is not being asserted from four cases. It is what the four
cases make worth proving, and the proof would come from the continued fraction's
determinant recurrence, not from the list.

---

## What I did not establish

- **No primary text was read.** Not the *Yuktibhāṣā* (Malayalam prose), not the
  *Tantrasaṅgraha* (Sanskrit verse), not the *Laghuvivṛti*. Everything above is
  from an encyclopaedia article and one arXiv preprint, both **[fetched]** in
  full, plus search-result text.
- No Sanskrit and no Malayalam is quoted here. The verse translations are the
  secondary sources' English, quoted as such, and I have not seen the originals
  or checked the translations against them.
- The verse numbering (2.206–2.209 etc.) is reported as given; I do not know
  which edition it indexes, and editions differ.
- **Whether the *Laghuvivṛti* in question is Nīlakaṇṭha's or Śaṅkara Vāriyar's
  is unresolved above** — my two sources name it differently. This is exactly
  the kind of question the primary literature settles and I have not settled it.
- The *sthaulya* condition is given in one secondary source's notation. I have
  not seen it in the *Yuktibhāṣā*, and I do not know how the text states it.
- I have not read Sarma–Ramasubramanian–Srinivas–Sriram (the critical edition
  and translation of the *Yuktibhāṣā*), which
  `THE_KERALA_TEXTS_BEFORE_ANY_SERIES.md` already names as the standard route
  in and which remains unread by this corpus.
- Which results are Mādhava's own and which are his successors' elaborations is
  a live question in the literature; I report the attributions as the sources
  give them and adjudicate none.
- The history and the source-reading here are checked by nothing. §V is the
  exception and is scoped: the four algebraic identities are checked terms, and
  they say nothing about whether the Kerala texts state the criterion the way
  §III reports it.

---

*Sources fetched this session:*
[Yuktibhāṣā (Wikipedia)](https://en.wikipedia.org/wiki/Yuktibh%C4%81%E1%B9%A3%C4%81) ·
[Madhava series (Wikipedia)](https://en.wikipedia.org/wiki/Madhava_series) ·
[Madhava's correction term (Wikipedia)](https://en.wikipedia.org/wiki/Madhava%27s_correction_term) ·
[K. Krishna, *On Mādhava and his correction terms for the Mādhava-Leibniz series for π*, arXiv:2405.11134](https://arxiv.org/html/2405.11134v1)
