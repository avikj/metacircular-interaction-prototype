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
