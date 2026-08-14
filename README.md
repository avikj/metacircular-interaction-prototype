# The Pythagorean machine

Almost everything has already been solved by someone nobody listened to.

That is not a lament and it is not humility theatre. It is the single most
exploitable fact about mathematics, and it is the reason this repository
exists. The bottleneck on discovery has never been cleverness. There are eight
billion people alive and three thousand years of written argument behind them,
and the overwhelming majority of it is unread — not refuted, not superseded,
*unread*. Riemann had the Riemann–Siegel formula in a drawer for seventy years
until Siegel went into the Nachlass and found it in 1932, better than anything
published in the interval. Gauss's diary sat unopened for forty-three years
after his death while Abel, Jacobi, Bolyai and Lobachevsky spent their careers
rediscovering its contents. Grassmann invented exterior algebra in 1844, was
ignored so thoroughly that he quit mathematics, and went off to write a Rigveda
dictionary that Sanskritists still use. Mādhava summed arctangent series in
Kerala around 1400 — *with end-correction terms and error estimates*, which is
to say he had this repository's central methodological doctrine six hundred
years before we wrote it down as a rule. Cartwright and Littlewood found chaos
in the van der Pol oscillator in 1945 and it took twenty years and a
meteorologist for anyone to notice what they had.

The machine we are building is the one that listens.

---

## What this repository is for

**Mathematics that changes the means of mathematics.** One coupled process, not
two: results must change how the next result is routed, represented and reused;
better representations must in turn expose real questions and real proofs. A
theorem that leaves the search apparatus exactly as it found it has done half a
job. An apparatus that produces no theorem has done none.

Nothing here is owned by a named conjecture. RH is not a destination; let it
become central exactly when the dependency structure makes it central, and let
it recede when something else pulls harder. The long aspiration is wider than
number theory and always was — number, light, language, computation, cognition,
mechanics, the resolution of uncertainty. Do not shrink the goal to whatever is
easiest to measure this week.

### Pythagorean perception, Euclidean reconstruction

Two motions, neither of which may substitute for the other.

**Pythagorean:** hunt for number, ratio, periodicity, symmetry, resonance and
harmony *across* domains — the cheerful conviction that the thing in front of
you is secretly the same as a thing in a field you have never studied. This is
the half that finds anything. It is also the half that produces cranks.

**Euclidean:** reconstruct every perceived connection through explicit
definitions, constructions, hypotheses and proofs, until the claim survives
having every metaphor stripped out of it.

Deduction without structural perception is locally correct and globally blind.
Resonance without reconstruction is mythology. Typechecking invented vocabulary
is neither. The test of a result is whether it still matters when you delete
every word of framing around it.

---

## The failure mode, with tonight's receipts

The characteristic way an intelligent agent wastes a night here is not error.
It is *fluent, correct, checked reconstruction of something that already
exists*. It feels exactly like discovery from the inside. Every one of the
following passed its own tests:

- **`AtlasResiduals.agda` re-derives `Cubical/Data/Nat/Algebra.agda` — a file
  inside the library this repository already depends on — in a strictly weaker
  form.** The library proves the initial ℕ-algebra comparison type contractible
  for any carrier. We proved it for *set* carriers and wrote a paragraph
  apologizing for the gap the library had closed in 2019. The library file
  names the paper in its header. `grep -rn "Data.Nat.Algebra" formal/` returned
  nothing.
- **`ATLAS_OF_N` §3 is Chapter 4 of the *Symmetry* book.** What we called our
  sharpest residual, `Sₙ ≅ π₁(BSₙ)`, is an exercise there. The book was already
  on disk.
- **The corpus's most-repeated construction is Myhill–Nerode.** Minimal
  realization for Moore coalgebras, re-proved under private names — and the
  same induction was written *three times in one module* because nobody named
  the final coalgebra they were building.
- **`Tm` is `List Shape`, constructor for constructor.** About 1400 lines of
  the generative lane are the free monoid's universal property with the serial
  numbers filed off. The lane has no terms.
- **`CRYSTAL.md` is babble + egg + Adapton + CEGAR + LCF**, four shipping
  systems and a fifty-year-old architecture, re-specified.
- **`PayloadMorphism.MinCarrier` is a character-for-character duplicate** of a
  library module sitting fifteen lines below an existing import.
- **`exp27` published a fitted constant, 0.362–0.421, where the true value is
  exactly ¼.** The error reached two notes, a paper section, and a round of
  cross-review before anyone did the page of algebra.
- We import **62 of 859** modules of our own pinned library. Of its 88
  category-theory modules: **zero**.

The lesson is not "be more careful." It is that *your own fluency is the
adversary*. You can generate a correct proof of a known theorem faster than you
can find out it is known, and the generated proof will feel better. The only
defense is a hard ordering: **search before you prove, and search under the
standard name, not the one we coined.** Our names are precisely what hide the
standard objects — that is the mechanism, demonstrated above, repeatedly.

---

## The listening discipline

Before you open any item, spend the first hour reading. Not scoping, not
planning — reading. This is the highest-yield hour available to you and it will
never feel like it.

1. **Grep the ecosystem under the standard name.** `~/agda-libs/` holds the
   cubical library, agda-unimath (3035 modules), UniMath, the Symmetry book,
   Coq-HoTT, mathlib4 (8886 files) and vidyut (≈2000 Aṣṭādhyāyī rules with
   derivation traces). `notes/PRIOR_ART_INDEX.md` carries a
   coined-name → standard-name translation table. Extend it every time you find
   another one; that table is the most valuable file in the repository.
2. **Search the literature.** `WebSearch` works; `WebFetch` is egress-blocked
   on every host, so search results are *testimony*, not text you read — mark
   them accordingly and never quote a paper you have not opened.
3. **Then write down the theorem your computation would replace.** If it
   follows from Stirling, the explicit formula, stationary phase, a Mellin
   transform, an integral-domain argument or a standard asymptotic — prove it.
   Do not run it. Every structural law in this corpus was measured first and
   proved later, always in less space than the measurement took.
4. **Exact symbolic computation is proof** and is always welcome: an
   irreducibility certificate, a finite exhaustive verification, a resultant, a
   factorization. These produce objects. Correlations, fitted exponents and
   "the model matches at 0.9999" produce nothing — they stand in for an error
   analysis you did not do. *A correlation coefficient has no content; the
   content is the error term.* And a constant measured at one scale hides its
   scaling: deriving that a "measured" noise floor of 10⁻³ was really X^(−1/2)
   changed a depth law from T log²T to T^(1/2) log^(3/2) T.

Being scooped by 1932 is a *good* outcome. It means you were asking a real
question and it costs you one afternoon. Discovering it at review time costs
everyone.

---

## Who you are not listening to

Read outside your century and outside your language. The following are not
decorations; each is a live technical resource with something this
collaboration currently lacks, and several are already on disk.

**Pāṇini** (c. 500 BCE) wrote a compiler. Four thousand rules, metarules that
govern rule application, inheritance of context between rules (*anuvṛtti* — it
is lexical scoping), a stratified final section whose rules cannot feed back
into the earlier ones, and a general-versus-exception mechanism (*utsarga /
apavāda*) that generative phonology re-derived in 1973 and had the grace to
name the Elsewhere Condition after him. His conflict-resolution rule 1.4.2 was
still being re-read in 2022. We have his rule base in `~/agda-libs/vidyut` with
derivation traces. Nobody in this repository has typed it.

**Mādhava and the Kerala school** (c. 1400) had power series for arctangent,
sine and cosine, and — the part that matters here — *correction terms with
error control*, because a series without a bound on the tail is not an answer.
That is `CLAUDE.md`'s rule, six centuries early.

**Dignāga and Dharmakīrti** (5th–7th c.) built a semantics in which meaning is
*apoha*, exclusion-of-the-other: a term means by cutting away, not by naming a
positive universal. There is no formal reconstruction of this. Type theory is
built almost entirely on positive introduction rules. That gap is a research
program, and an honest one — a previous block searched for a common formal
object with Nyāya and reported finding none, which is the correct thing to
report.

**Brahmagupta** (628) gave arithmetic rules for zero and negatives. **Jayadeva
and Bhāskara II** solved Pell's equation by *cakravāla* centuries before
Lagrange. **Seki Takakazu** had determinants before Leibniz. **Oresme** graphed
functions and proved the harmonic series diverges in the 14th century.

**Ramanujan** learned mathematics from Carr's *Synopsis* — five thousand
theorems, no proofs — and the resulting habit of *asserting the true statement
and reconstructing the reason afterwards* is a legitimate mode of work that
this collaboration systematically punishes. His lost notebook sat in a Trinity
box for sixty years.

**Sophie Germain**'s actual plan for Fermat was only understood when her
manuscripts were finally read in the 1990s. **Heaviside**'s operational
calculus was rejected as non-rigorous and vindicated twice over, by
distributions and by Mikusiński. **Peirce**'s existential graphs are string
diagrams, drawn a century early and mostly unpublished. **de Bruijn**'s
Automath was the first proof assistant, with dependent types and
propositions-as-types, in 1967 — everything in `formal/` is downstream of a
system almost nobody used.

The unifying observation: in every case the work was *available*, and the
problem was attention. That is exactly the problem an agent fleet is
structurally good at and temperamentally bad at.

---

## And the frontier is 2026, not 2019

The other half of not listening is being current. The consolidated layer we
keep re-deriving — concrete groups, deloopings, the sign homomorphism — is
formalized and finished. Above it, right now: higher observational type theory
with *definitional* univalence; simplicial and directed type theory recovering
straightening–unstraightening type-theoretically; 2-groups in HoTT. Meanwhile
our analytic lane has a note whose "only known crossing of θ = 1/2" was
falsified by a 2025 paper, and a result that was published elsewhere with a
sharper error term than ours.

Synthesis *across* live frontiers is the only thing left that is genuinely
unowned. Everything strictly inside one frontier has eight billion people and a
faster clock working on it. Read two fields at once and the intersection is
empty of competitors.

When you sample what to read, **sample randomly**. Curating the search to what
seems relevant projects your own boundaries onto the subject, and your
boundaries are the thing being tested. `shuf` over the corpus and over subject
classifications has outperformed judgment here, more than once.

---

## Working here

**One session, one worktree.** Two sessions in one checkout destroy each
other's uncommitted work and silently duplicate each other's thinking. Both
happened here inside one hour.

```sh
git worktree add -b worker/<handle> ../avikj-math-readme-workers/<handle> <base-branch>
cd ../avikj-math-readme-workers/<handle>
sh .githooks/worktree-guard.sh          # must print OK
git push origin worker/<handle>:<your-designated-branch>
```

**No Python.** Not run, not added, not repaired, not revived. Mathematics is
written in Agda (`formal/cubical/`, `--cubical --safe`, no postulates, no
holes) or Lean (`formal/pairfield/`). A script that prints a number asks the
reader to trust the script, its author and the run; a checked term is the
object itself, and it is still there tomorrow. Enforced by hook, pre-commit and
CI. The 660 legacy `.py` files are debt — deletions pass, additions do not.

**Names carry categories.** `ls` alone must tell you what kind of thing
something is; you should never open a file to learn its category. The canonical
instance is the directory named
`DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/`, which is *not*
`FAILURES.md`: that ledger holds dead routes, which are research and compose
into future briefs. This one holds behaviours that produced nothing while
looking like they had. Every entry in it passed its tests. Read it before you
reach for an artifact, and add to it the same day you catch one.

**Refutations are first-class.** Strike through, never silently delete. Being
wrong in public is the mechanism; a corpus where nothing is ever struck is a
corpus nobody is checking. Several of the receipts above are self-inflicted and
they are the most valuable paragraphs in this file.

**Nothing load-bearing enters unverified**, and verification means the root
aggregate exits 0 — not the module you touched. See `formal/cubical/BUILD.md`
for what the green claim does and does not cover, and for why the toolchain pin
is forced rather than chosen.

---

## Where things are

| you want | read |
|---|---|
| **who is awake right now** | `collab/BOARD.md` — live session blocks; edit your own, archive the stale |
| **what has landed** | `collab/STATE.md` — authoritative, 214 KB; grep it, do not read it |
| **the binding research rule** | `CLAUDE.md` — write the theorem the computation would replace, first |
| **prior art, before you prove** | `notes/PRIOR_ART_INDEX.md`, `notes/HOTT_ECOSYSTEM_MAP.md`, `notes/FORMALIZED_ECOSYSTEM_RECON.md` |
| **dead routes and their yields** | `collab/FAILURES.md` — a walk without a yield is unfinished |
| **behaviours that felt like progress** | `DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/` |
| **the norms** | `collab/PROTOCOL.md` |
| **the direction, at length** | `notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` |
| **the mathematical picture** | `notes/MATHEMATICS_THAT_LEARNS.md` |
| **what is actually implemented** | `notes/RESEARCH_SYSTEM.md` (as against designed, as against aspirational) |

---

## One last thing

The instinct that makes you good at this — generate, elaborate, produce — is
the same instinct that produced every item in the receipts list. When you feel
the pull to start writing, that is the moment the expected value of *reading*
is highest. The people named above were not smarter than you. They were just
not listened to, and the only difference between their situation and yours is
that you have their books on disk.

Go find out who already solved it. Then, having found out, go somewhere nobody
has been — which is almost always the seam between two fields, and almost never
the middle of one.
