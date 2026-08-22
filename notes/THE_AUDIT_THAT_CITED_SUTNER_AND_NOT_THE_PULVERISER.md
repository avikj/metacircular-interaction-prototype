# A specimen of the mining machine, produced inside the repository that documents it

2026-08-15, recorded 2026-08-19 against the book frame. Chapter bearing: 6
(Āryabhaṭīya), 2 (Chandaḥśāstra), 7 (Brāhmasphuṭasiddhānta), and 13 (the
machine of truth) — this is the machine's own epistemics caught in the act.

## What happened

On 2026-08-15 I added `NaturalMachine/TransportDiv.agda`: the divisibility
test carried across the place-value chart as a digit automaton, `modw n`,
with `value-modw : modw n w ≡ value w mod n`. The repository protocol
requires prior art to be searched **before** the write-up. I ran that audit.
It produced `notes/PRIOR_ART_TRANSPORTDIV.md`, and it is thorough: Sutner,
*Divisibility and State Complexity*, Mathematica Journal 11:3 (2010), which
names the object a **Horner automaton** and states δ(0,w) = val(w) mod m
verbatim; Alexeev, JCSS 69:2 (2004), for the minimal state counts; Knuth,
TAOCP vol. 2 §4.6.4; mathlib's `Nat.ofDigits` with its whole surrounding
API; the Agda standard library's `Data.Digit.fromDigits`; Büchi 1960 and
Cobham 1969 for b-recognisability. Nineteen citations. The audit even found
the internal duplicate — `NaturalMachine/RadixSymptoma.agda`, which already
had the digit action — and I committed a header correcting my omission.

It cited nothing Indian. Not one line.

Sitting in the same repository, one directory up from the module being
audited, were `formal/cubical/Kuttaka.agda`, `KuttakaCRT.agda`,
`KuttakaValli.agda`, and — in the *same* directory as `TransportDiv` —
`NaturalMachine/CakravalaNeedsKuttaka.agda`, whose header opens: *"the
mechanism was available in 499 CE."*

## The exact record, stated so it cannot be inflated

Three separate objects, three different provenances, and only fairness makes
the specimen worth anything:

**The reduction step is not Āryabhaṭa's.** What `WalkChartedCap.gcd-mod`
performs — replace `gcd a n` by `gcd (a mod n) n` — is the Euclidean
descent, and it is older than Euclid as anthyphairesis. I cited cubical's
`stepGCD` for it, which is correct as a source of the lemma and silent as a
source of the idea. No erasure there; note it and move on.

**The pulveriser is, and it is stronger than anything my lane needed.**
Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE): the **kuṭṭaka**
solves the linear indeterminate congruence — not "what is the gcd" but
"which multiplier lands on this residue" — by the vallī, the ladder of
quotients with a back-substitution. `formal/cubical/Kuttaka.agda` has it as
a checked theorem, with `bezout` extracting the multiplier pair from a
division run and `inhomogeneous` scaling it by the iṣṭa. My audit was for a
module that computes residues from digits. The repository's own checked
statement of the harder problem, in the adjacent directory, appears in no
line of it.

**The digit word and the chart are the ones that matter most.** The whole
Transport lane rests on two objects it treats as ambient furniture: a word
of digits, and the map `value : Word → ℕ` that the lane calls *the chart*.
The binary word as a mathematical object — the enumeration of light and
heavy syllables, prastāra, with naṣṭa and uddiṣṭa as the two directions of
the addressing map — is **Piṅgala's**, *Chandaḥśāstra*, c. 300 BCE, and this
repository has eight modules on it (chapter 2). Place value with **śūnya as
a number carrying its own arithmetic** is **Brahmagupta's**,
*Brāhmasphuṭasiddhānta*, 628, and this repository has a chapter on that too.
My audit cited four Western sources for `value` — mathlib's `Nat.ofDigits`
is "definitionally this repo's `value`", it observes — and named neither.

## Why this is a finding and not an apology

The book's claim about the northwestern axis is a claim about a *mechanism*:
that the record was not merely lost but processed — mined, restated, renamed
after the restater. A historical claim of that shape is normally argued from
the 18th and 19th centuries, where the defendant cannot answer and the
reader must weigh intent across two hundred years.

Here it ran in an afternoon, in 2026, with the counter-evidence in the
working tree.

The conditions could not have been more favourable to the correct outcome.
The agent was instructed to search prior art first. It had file-system
access to a corpus organised into thirteen chapters of Indian mathematics.
The very module it was auditing sits in a directory containing
`CakravalaNeedsKuttaka.agda`. It searched the web, found a 2010 paper in a
software vendor's journal, and adopted that paper's name for the object —
*Horner automaton*, after William George Horner, 1819, for a rule Liu Hui
used in the third century and the Chinese and Indian traditions both had
long before Horner restated it.

So the mechanism does not require malice, or even ignorance of where to
look. It requires only that the search be pointed at the literature that
indexes itself well, and that "prior art" be operationalised as *what a
citation search returns*. The northwestern chain is well indexed. The
Sanskrit is not, and it does not answer keyword queries in English about
"digit automata".

That is the finding: **the erasure reproduces itself through search
infrastructure, in an agent that had the primary sources locally and a
standing instruction to find them.** The book has been arguing that the
machine exists. This is the machine, photographed mid-cycle, by its own
subject.

## What was repaired

- `TransportDiv.agda`'s header now names Piṅgala, Brahmagupta and the
  in-repo `Kuttaka.agda` alongside Sutner and Alexeev, and says which of the
  three objects each is provenance for.
- `WalkChartedCap.agda`'s Euclid-step section names anthyphairesis as the
  descent's origin and points at `Kuttaka.agda` for the stronger statement
  it does not need but should have known about.
- `notes/PRIOR_ART_TRANSPORTDIV.md` carries the omission at the top rather
  than a silent amendment; a prior-art note that is corrected quietly is
  worth less than one that shows what it missed.

## What is NOT claimed

That Sutner or Alexeev or the mathlib authors erased anything. They wrote
what they wrote. The mechanism is downstream of them, in the indexing and in
the searcher — which in this instance was me.

That the digit automaton is "really" Indian in some way that makes Sutner's
state-complexity result less his. It does not; his minimality analysis is
his own and is cited as such.

That the corpus's Sanskrit-named modules are unaffected by the same force.
They were written by agents in this repository too, and the honest next
question — which this note does not answer — is whether *their* provenance
sections cite the European restatements more carefully than the primary
text, which would be the same machine running in the other direction.
