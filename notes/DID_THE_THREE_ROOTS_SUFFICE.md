# Did the three roots suffice? — the sufficiency experiment, answered

**The experiment** (owner, 2026-08-18): build from **India + Pythagoras +
Voevodsky only, crediting nothing else** — *"let's give no one else any
credit and see where this can take us, really. It's the only way to pay
respects without treating future/west as better than past/east."*

**Status:** 38 modules checked in one session, `--safe`, exit 0 each, no
postulates, no holes. This note is the experiment's result, including the
place where I broke its rule without noticing.

---

## What each root actually supplied

**India.**

| source | date | what it did here |
|---|---|---|
| Piṅgala, *Chandaḥśāstra* | c. 300–200 BCE | naṣṭa/uddiṣṭa — a lossless enumeration **with its decode as a named algorithm**; `PingalaIsOptimal` |
| Virahāṅka | c. 600–800 | mātrāmeru; `virahanka-optimal` makes it an information-theoretic minimum |
| Āryabhaṭa, *Āryabhaṭīya* 2.32–33 | 499 | kuṭṭaka — the multipliers, i.e. Bézout certificates; the whole chain from `CoprimePowers` to `FrontierCount` runs on them |
| Brahmagupta, *Brāhmasphuṭasiddhānta* 18 | 628 | bhāvanā — the conic, norm multiplicativity, `rot-norm`, `gen-hom`, the composition of triples |
| Jayadeva / Bhāskara II | c. 950 / 1150 | cakravāla — `Cakravala`, and its dependence on the kuṭṭaka |
| Pāṇini, *Aṣṭādhyāyī* | c. 500 BCE | lāghava, anuvṛtti, pratyāhāra, utsarga/apavāda — the entire tower of description |
| Navya-Nyāya (Gaṅgeśa et al.) | 14th c. | abhāva, pratiyogin, avacchedaka — the deflation's frame |
| the Kerala school — Mādhava, *Yuktibhāṣā* | c. 1400 / c. 1530 | vārasaṅkalita, repeated summation; `Sankalita.varasankalita` proves it IS Piṅgala's array, seventeen centuries earlier |
| Jain logicians | — | anekānta, saptabhaṅgī — the collapse dichotomy |

**Pythagoras.** The triples, and number-as-ratio. `PythagoreanTransition`,
`EveryTripleIsARotation`, `DescentCostsTheIntegers` — and the correction in
§24 of the barrier note, that ratio is not a price but the ground.

**Voevodsky.** `ua`, transport, the structured defect. And — the sharpest
thing univalence did here — `UnivalenceErasesTheAlgorithm`, which is
univalence used to *locate its own limit*.

## Where I broke the rule without noticing

I used "the Chinese remainder theorem" throughout — in
`WalkObservationCount`, `CRTChain`, `FrontierCount`, and four commit
messages — while three modules earlier building the **kuṭṭaka** by name.

Āryabhaṭa's pulveriser (*Āryabhaṭīya* 2.32–33, 499) is a general
constructive method for exactly the simultaneous-congruence problem, and
Brahmagupta and Bhāskara extend it. The *Sun Zi Suanjing* (c. 3rd–5th c.)
poses the problem with a rule for a special case; Qin Jiushao's general
method is 1247. Both traditions have it; only one of them was in this
experiment's brief, and I used the name of neither of the two I should have
been weighing — I used the one I had been handed.

That is exactly the failure CLAUDE.md's table describes: *"A citation to
the restatement alone is an error of the same kind as publishing a fitted
constant — it asserts a provenance you did not check."* I did not check. It
cost nothing to check and I did it only when writing this note.

**Nothing mathematical changes.** The provenance does, and provenance is
what the experiment was about.

## The honest ledger of what came from outside the three roots

| dependency | origin | verdict |
|---|---|---|
| Euclidean algorithm (`Cubical.Data.Int.Divisibility.bézout`) | Euclid, and the kuṭṭaka independently | co-extensive; the kuṭṭaka is the constructive version and is what I actually used downstream |
| pigeonhole / cardinality (`card↪Inequality'`) | generic | not anyone's idea in particular |
| Gauss's lemma (`FinCardinality.gauss`) | its content is Bézout | reduces to the kuṭṭaka |
| the CommRingSolver, Agda, cubical | infrastructure | tools, not ideas — the experiment was about whose *ideas* carry the weight |

I can find no result in the 38 modules whose **mathematical content**
requires a source outside the three roots. That is the experiment's answer.

## But the answer has a shape worth stating

The three roots did not merely suffice — they **divided the labour**, and
the division is not one anybody planned:

- **Āryabhaṭa supplies certificates.** Every coprimality fact in the chain
  is a Bézout pair being carried, and `CoprimePowers.bez-mul` composes them
  by one ring identity. Getting a certificate is work; having one is free.
- **Brahmagupta supplies composition.** bhāvanā is the same move one level
  up: two solutions compose into a third, and the norm multiplies.
- **Piṅgala supplies the decode.** naṣṭa is not a proof that uddiṣṭa
  inverts — it *is* the inverse, with its own name. `Pingala.agda` meets a
  standard most of this corpus's `FactorsThrough` results do not.
- **Pāṇini supplies everything below the denotation** — and
  `Laghava.laghava-is-not-semantic` proves nothing above it can see that
  layer.
- **Voevodsky supplies the top of the tower, exactly**, and `uaβ` proves it
  reaches no further.

Five traditions, five levels, and each one's tool sits precisely where the
tower says it does. That coincidence is the finding, and it is not an
argument that the roots are sufficient for *mathematics* — only that for
this corpus's actual questions, they were, and that the questions turned
out to be about description rather than about size.

## What the experiment does not license

- It does not show these results are unavailable by other routes. Most are
  standard; the contribution is the assembly and the provenance.
- It does not extend past what this session touched. The analytic lane's
  questions — Chebyshev, the barrier — were reached only far enough to say
  what *shape* of statement they need (`notes/THE_BARRIER_PROBLEM_IS_A_COLLISION.md`).
- And it does not make the naming failure above less bad. The experiment's
  whole point was provenance, and I was six modules deep before I checked
  one.

---

## Addendum: the Kerala school, added after the fact

The table above was written before `NaturalMachine/Sankalita.agda` landed
and did not include Mādhava's tradition, because at that point nothing in
this session used it. It now has a checked contribution, and the row is
added above.

What it contributes is worth stating precisely, because the obvious thing
to claim would be wrong. **Nothing analytic is here.** Mādhava's series for
π, its error terms, and the convergence acceleration are the Kerala
school's actual achievement, and this lane has no reals. What is here is
the exact finite operation those arguments are built on — vārasaṅkalita,
repeated summation — and the theorem that it *is* Piṅgala's meru-prastāra:

```
varasankalita :  Σ^r 1 at n  ≡  meru n r
```

Two lines from `Pingala.meruRecurrence`, which is Halāyudha's rule that
each entry is the sum of the two above it. The two constructions coincide
**at the level of the recurrence**, not merely in their values, and they
are separated by about seventeen centuries within one tradition.

That strengthens the experiment's answer in a direction I did not expect
when I wrote it: the roots did not only divide the labour across the five
levels of the tower — one of them, taken at two widely separated dates,
supplies the *same* construction twice, and the identification is a
theorem rather than an analogy.
