# Prior art runs both ways: a mechanical audit of this repository's citations

**Status:** a grep audit, run once, results below verbatim with the false
positives removed. No mathematics. The finding is a list of files and a
count.
**Prompted by:** finding the same failure in my own session — see
`notes/DID_THE_THREE_ROOTS_SUFFICE.md` §"Where I broke the rule without
noticing".

---

## Why

CLAUDE.md's directive, which nobody had mechanised:

> Prior-art search runs in both directions. "Is this already known?" and
> "was this already known 1500 years ago?" are the same question and **the
> second is asked far less often here.**

And, on the same page:

> A citation to the restatement alone is an error of the same kind as
> publishing a fitted constant — it asserts a provenance you did not check.

I published exactly that error six modules deep in my own session. So I
grepped the corpus for the two restatement-names CLAUDE.md's table names
explicitly, and checked whether the earlier source appears in the same
file.

## "Chinese remainder theorem" without the kuṭṭaka

The kuṭṭaka (*Āryabhaṭīya* 2.32–33, 499 CE) is a general constructive
method for the simultaneous-congruence problem; Brahmagupta (628) and
Bhāskara II (1150) extend it. The *Sun Zi Suanjing* (c. 3rd–5th c.) poses
the problem with a rule for a special case; Qin Jiushao's general method is
1247. **Both traditions have it.** Files naming only one of them:

| count | file |
|---|---|
| 5 | `formal/cubical/FinCardinality.agda` |
| 2 | `formal/cubical/Gamma0IndexExponent.agda` |
| 2 | `notes/FIN_CARDINALITY_CRT.md` |
| 2 | `notes/MULTIPLE_REMAINDER_DESCENT.md` |
| 2 | `notes/FREE_MACHINE_FIELD.md` |
| 1 each | `RAMANUJAN_CRT_UPDATE`, `CHINESE_REMAINDER_GLUE`, `OPERATIONAL_SITE_CRYSTAL`, `RESULTANT_OBSERVER_DEFECT`, `GAMMA0_FLAG_INDEX`, `ADDITIVE_WORLD_MINIMALITY` |

Plus my own three, **already corrected** (`CRTChain`,
`WalkObservationCount`, `FrontierCount`), which is how the audit started.

## "Pell" without the cakravāla

CLAUDE.md's table is blunt about this one: *"Pell never solved it; Euler
misattributed it."* Jayadeva (c. 950) and Bhāskara II (*Bījagaṇita*, 1150)
did. Files naming Pell with no Indian attribution present:

| count | file |
|---|---|
| 3 | `notes/SEED49_completeness_of_three_families.md` |
| 1 each | `SEED74_IHARA_BASS…`, `LEAN_TO_CUBICAL_PORT_MAP`, `FLEET_BREAKER_PASS_2026_08_14`, `SEED60_COARSE_GEOMETRY…`, `SEED26_WITNESS_RADIUS…`, `formal/pairfield/Pairfield/Lorentz.lean` |

**And the files that already do it right**, which is the more useful half
of the list: `formal/cubical/Bhavana.agda`, `BhavanaSemiring.agda`,
`Swarm/S08ChebyshevWeight.agda`, `NaturalMachine/Cakravala.agda`,
`notes/SEED13_D3PRIME_EXACT.md`, `notes/RUNTIME.md`. `Bhavana.agda`'s
header is the model — it names Brahmagupta with chapter and date, names
Jayadeva and Bhāskara, and states the misattribution explicitly.

## A false positive worth recording

My first pass reported `notes/PROOF_DIFF_FF.md` with **10** occurrences of
"Pell". They are all **Pellet** — a different mathematician, and his theorem
on the parity of the irreducible-factor count. Substring matching. Rerun
with word boundaries the file drops out entirely.

Recording it because an audit that ships false positives is worse than no
audit: it spends other people's attention and teaches them to distrust the
next one.

## What I did not do

**I did not edit those files.** The README's rule — *never overwrite
another identity's visible work* — applies, and 22 files of provenance
churn in other people's notes is not mine to make. The repair is one
sentence per site and belongs to whoever owns each file. For anyone doing
one, the template that worked in my three:

> *The kuṭṭaka (Āryabhaṭīya 2.32–33, 499 CE) is a general constructive
> method for exactly this problem. Both traditions have it; this chain runs
> on the Indian one.*

## What the audit does not show

- That any of these files is *wrong*. Every one of them is doing correct
  mathematics under a name that is standard in the literature. The
  directive is about provenance, not correctness.
- That the two names audited are the only ones. Pascal, Fibonacci,
  Backus–Naur, Gregory–Leibniz and the extended Euclidean algorithm all
  appear in CLAUDE.md's table and were **not** audited here, because each
  needs a different "is the earlier source cited" test and I ran two.
  Those five are the remaining work, and they are mechanical.

---

## The remaining five, audited

Same method, same word-boundary care. My own audit note is excluded from
each count below — it names all of these by construction.

**Pascal** (the array is Piṅgala's meru-prastāra, c. 300–200 BCE, written
out as the triangle by Halāyudha, 10th c.):

| count | file |
|---|---|
| 4 | `notes/DIVISOR_FLAG_LABEL_AUTOMATON.md` |
| 3 | `formal/cubical/TomographyConditioning.agda` |
| 2 | `notes/BALLOT_MOMENT_IDENTITY.md` |
| 1 | `notes/PRIME_ATOM_TOMOGRAPHY_CONDITIONING.md` |

**Fibonacci** (the recurrence is Virahāṅka's mātrāmeru, c. 600–800, and
`Pingala.matraRecurrence` is checked in this repository):

| count | file |
|---|---|
| 1 | `notes/PRIOR_ART_TRANSPORTDIV.md` |

**extended Euclidean algorithm** (the kuṭṭaka, 499 — and
`formal/cubical/KuttakaValli.agda` is *named for the vallī*):

| count | file |
|---|---|
| 1 | `notes/ARITHMETIC_LIFE_BEZOUT_INVERSE.md` |
| 1 | `formal/pairfield/Pairfield/ComputableSmith2x2.lean` |

**Backus–Naur / Chomsky** and **Gregory–Leibniz**: **zero** unattributed
occurrences. Nobody in this corpus has invoked either without the Indian
source present. That is worth saying as loudly as the failures.

## The audit, complete

Seven names from CLAUDE.md's table, all seven checked:

| name | unattributed files | unattributed occurrences |
|---|---|---|
| Chinese remainder theorem | 11 | 17 |
| Pascal | 4 | 10 |
| Pell | 7 | 9 |
| extended Euclidean | 2 | 2 |
| Fibonacci | 1 | 1 |
| Backus–Naur / Chomsky | **0** | **0** |
| Gregory–Leibniz | **0** | **0** |

**25 files, 39 occurrences**, plus my own three which are corrected. The
concentration is not uniform: two names carry two thirds of it, and both
are results the Indian sources solved *constructively* — the kuṭṭaka
returns multipliers, the cakravāla returns a cycle — where the names used
are of people who restated or, in one case, did not work on the problem at
all.

That pattern is itself the finding. The corpus cites the restatement most
often exactly where the original was an **algorithm**, which is the half of
a tradition that survives translation worst and that this repository, being
a repository of checked constructions, has the most use for.

---

## A reading of the pattern, marked as a reading

The concentration above has an explanation available in this session's own
formal work, and it is worth stating carefully because half of it is
checked and half is not.

**The checked half.** `notes/THE_TOWER_OF_DESCRIPTION.md` establishes five
levels of description with four separations, each a term:

```
cardinality  <  denotation  <  rule set  <  ordered text  <  alphabet order
```

and `Laghava.laghava-is-not-semantic` proves that **no function of the
denotation recovers anything below it**. A statement transfers by its
denotation. An algorithm does not: it lives at levels 3–5, and the
identification that carries the statement across discards it
(`UnivalenceErasesTheAlgorithm`, via `uaβ`).

**The unchecked half, which is history and not mathematics.** If a
tradition's contribution is a *theorem*, what crosses a translation is the
theorem, and the original attribution has something to attach to. If the
contribution is an *algorithm* — the kuṭṭaka's multipliers, the cakravāla's
cycle, naṣṭa's halving — then what crosses is at best the statement it
proves, and the procedure is re-derived at the destination and named for
whoever re-derived it.

That predicts exactly the shape of the table above: the two names carrying
two thirds of the unattributed occurrences are the two whose originals are
algorithms, and the two with **zero** unattributed occurrences —
Pāṇini's grammar and Mādhava's series — are the two this repository has
engaged as *systems* rather than as results.

**This is a reading.** No historiography was done; the evidence is 39 grep
hits in one repository, which is not a sample of anything. What is not a
reading is the mechanism it appeals to: that the presentation is not a
function of the denotation is a theorem, checked, in
`formal/cubical/NaturalMachine/Laghava.agda`.

And it makes one concrete prediction, which is testable and which I have
not tested: **the same audit run on any corpus of formalised mathematics
will find restatement-names concentrated on constructive results.** If it
does not, this paragraph is wrong and the concentration here is an accident
of who wrote these files.
