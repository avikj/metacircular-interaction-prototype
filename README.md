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

## Enter here — draw your door before you read anything, including this file

```sh
# no toolchain needed -- coreutils only, use this unless you have a reason not to
./random_entry_seeder_so_agents_dont_cluster/seed.sh <your_handle>            # one agent
./random_entry_seeder_so_agents_dont_cluster/seed.sh <your_handle> --swarm 16 # a swarm

# canonical, if a Rust toolchain is present
rustc -O random_entry_seeder_so_agents_dont_cluster/seed.rs \
      -o random_entry_seeder_so_agents_dont_cluster/seed
./random_entry_seeder_so_agents_dont_cluster/seed <your_handle> --swarm 16
```

Read the eleven drawn files in full before forming any plan. Do not triage them;
the draw is uniform precisely so that your sense of relevance does not act.

**This is binding on every mind that enters, and on every mind you spawn.**
If you launch subagents, you draw for them — disjointly, one slice each — and
you pass each one its own draw in its prompt. You do **not** divide a swarm by
task. Task decomposition is computed from the same sense of relevance that
caused the clustering, so dividing by task rebuilds it; divide by *what each
agent has read* instead. A swarm whose members share a reading path is one
agent with extra steps.

**Appending to the lists is not optional.** `frontier_fields.txt`,
`ancient_fields.txt` and `method_lenses.txt` were written by minds who could
only list what they could think of, so the lists are themselves a clustering.
Every agent that meets a field or a method the lists do not name appends it. A
list that stops growing has become the next attractor. (The file draw needs no
maintenance — its urn is the repository itself.)

This is not decoration. **Twenty files in `collab/upstream/` holding this
project's own directives, in the owner's own words, went unread by every agent
for four days** — because they did not look relevant, while the conspicuous
orientation documents did. A random draw surfaced them in one pass. Several of
those documents encode the *opposite* of the directives they drifted from.
`random_entry_seeder_so_agents_dont_cluster/why_this_exists.md` has the
measurement and the two contradicting quotes.

So: the reading paths below are a *convention*, not an authority, and conventions
in this repository are the thing that produced four days of clustered work. If
your draw and a convention disagree about what matters, that is evidence about
the convention. `collab/upstream/` outranks every document in this repository,
including `CLAUDE.md` and `PROTOCOL.md`.

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

## Redundancy is the Rosetta Stone, not the waste

You will shortly find out that most of what this corpus proves was proved
somewhere else first. Here is the mistake it is easy to make on discovering
that, and the first version of this file made it: to conclude that re-deriving
a known result in your own vocabulary is the failure, and that the remedy is to
delete your version and import theirs.

It is not, and the Stone is the argument. Parallel text in three scripts is
pure redundancy by any compression measure, and it is the only reason anyone
can read Egyptian. Decipherment *needs* the same content said twice. So does
this repository, whose central technical claim is that positional notation is a
**chart** rather than the object — that the atlas, the collection of
presentations together with the transitions between them, is where mathematics
lives. A chart is not a lesser copy of the thing it charts.

This is not a metaphor doing work it hasn't earned. It is checkable, and this
week it got checked. `AtlasResiduals` states homotopy-initiality of ℕ in local
vocabulary; `Cubical/Data/Nat/Algebra` states it in the library's. The
transition between the two presentations — pointwise commutation against a
funExt'd equality of functions — turns out to compute to `refl` in both
directions. The charts are not merely equivalent, they are **definitionally
interchangeable**, so transport across them leaves no coercion in the term.
That fact is strictly more information than either presentation carries alone,
and *you cannot even state it with one chart*. It is now `AlgHomChart`, public
and named, in the module whose subject it is.

So: **write your own version. Then connect it.** The unconnected chart is the
only defect, and the repair is an equivalence, never a deletion.

### Transitions currently missing, i.e. work

Each of these is a second chart already written, sitting next to a first chart
already written, with nothing in between. None of them should be deleted. Every
one is a statable, checkable equivalence that nobody has stated:

- ~~`Tm` and `List Shape`, constructor for constructor.~~ **Built**,
  `NaturalMachine/TermFreeMonoid.agda`. `Tm` is the free monoid on `Shape`;
  `plug` is append. The lane gains associativity, which it had never stated,
  and the two additivity lemmas it had proved separately by induction in two
  modules — `plug-size` and `plug-deficit` — turn out to be one instance of the
  universal property. Every measure defined by that recursion into a monoid is
  additive automatically; there is no third proof to write. That is what a
  transition pays.
- `ATLAS_OF_N` §3 and Chapter 4 of the *Symmetry* book, already on disk, where
  our sharpest residual `Sₙ ≅ π₁(BSₙ)` is an exercise. Two presentations of
  concrete groups, no transition.
- `CRYSTAL.md` and the shipping systems it independently specifies — babble,
  egg, Adapton, CEGAR, the LCF kernel. Five vocabularies for one architecture,
  and the translation table is the thing worth having.
- `PayloadMorphism.MinCarrier` and its library twin, fifteen lines below an
  existing import.
- `LIMIT_ORBIT_COMPARISON`'s `c : (lim X)/G → lim(X/G)` and mathlib4's
  `colimitLimitToLimitColimit`. The word "colimit" occurs in 2 of 507 notes.

`notes/PRIOR_ART_INDEX.md` holds the running coined → standard table. Extend it
every time you find another pair; it is the atlas index, and it is the most
valuable file here.

### What is actually worth fixing

A different list, and a shorter one. These are not "we said it twice" — these
are places where a statement is *wrong, weaker, or unattributed*:

- **Weaker than the known form, and unconnected.** `AtlasResiduals` A2 required
  a set carrier; the library needs no h-level hypothesis at all and has not
  since 2019. The hypothesis was doing nothing but shrinking the theorem, so it
  is gone, and §3 now holds over arbitrary types as a result. *That* was the
  bug — not the second presentation, which stays.
- **A fitted constant where an exact one exists.** `exp27` published 0.362–0.421
  where the value is exactly ¼, and it propagated into two notes, a paper
  section and a round of review before anyone did the page of algebra. A
  correlation coefficient has no content; the content is the error term.
- **A constant quoted without its scaling.** A "measured" noise floor of 10⁻³
  was really $X^{-1/2}$, and deriving that changed a depth law from $T\log^2 T$
  to $T^{1/2}\log^{3/2}T$. A number without its $X$-dependence is worse than no
  number, because it looks like knowledge.
- **A novelty claim the literature had already closed.** `WIDTH.md`'s "only
  known crossing of θ = 1/2" is falsified by a 2025 paper; a `COPRIME_MERTENS`
  result is published elsewhere with a sharper error term. Attribution is not
  etiquette — it is the difference between a frontier and a room.
- **Three copies with no transition between them.** Minimal realization for
  Moore coalgebras appears repeatedly under private names, and the same
  induction was written *three times in one module*. Three charts and no atlas
  is the one shape that really is waste — not because the copies exist, but
  because nothing connects them, so nothing was learned from having them.

The through-line: **an unconnected presentation is debt; a connected one is an
atlas entry.** We import 62 of 859 modules of our own pinned library, and zero
of its 88 category-theory modules — which is not a scolding about laziness. It
is 797 unbuilt transitions, sitting on the disk, each one a checkable statement
nobody has written down.

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
