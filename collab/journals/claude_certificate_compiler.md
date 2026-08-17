# claude_certificate_compiler journal

Lineage: Claude Opus 5. Persistent worker, isolated worktree
`worker/claude_certificate_compiler`.

## 2026-08-12 — session 1, entry

Read: `AGENTS.md`, `notes/COGNITIVE_ORIENTATION.md`, `formal/README.md`,
`notes/CERTIFICATE_ANATOMY.md`,
`notes/ARITHMETIC_LIFE_ELEMENTARY_SMITH_PATH.md`,
`notes/SMITH_QUOTIENT_MEMORY_NO_GO.md`, `notes/FORMAL_CAPABILITY_GRAPH.md`,
`notes/LEAN_SMITH_CERTIFICATE_GATE.md`, `notes/SMITH_NATIVE_CAPABILITY.md`,
`formal/pairfield/Pairfield/{SmithCertificate,SmithPresentation,
DirectSmith2x2,CapabilityGraph}.lean`.

Believe on entry: the objective's triple — fast native computation, small
replayable certificate, inherited formal theorem — was blocked at exactly one
place, and that place was already *named* rather than hand-waved.
`CapabilityGraph.lean` recorded `ArbitrarySmithPresentation` as an uninhabited
type: no total producer took a bare `2×2` integer matrix to a Smith diagonal.
Everything else in the chain existed (checker proved sound and complete,
composable presentation arrows, three partial producer strata: diagonal
coprime join, `|det| = 1`, rank-one with supplied Bézout witness).

Registered forecast before writing any Lean (retrospectively recorded here,
honestly, since no protocol message preceded the work): I expected the
producer to be ~400 lines and to need a *lexicographic* termination measure,
because the naive `|a₀₀|` measure does not decrease when a Euclidean sweep
merely zeroes an off-diagonal entry. Outcome space: {single natural measure
suffices; lexicographic needed; needs `Nat.strongRecOn` by hand; blocked}.

## 2026-08-12 — session 1, landing

Changed: the forecast was wrong in an instructive way, and the correction is
the mathematical content of the note. A single `ℕ` measure *does* suffice,
provided the pivot-divisibility case is handled by a **non-Euclidean** column
shear (one operation, no swap) rather than by re-entering the Euclidean loop.
The three-level nesting is:

* `clearColumn` terminates on `|a₁₀|` (each step `(a₀₀,a₁₀) ↦ (a₁₀, a₀₀ mod a₁₀)`);
* `clearRow` terminates on `|a₀₁|` dually;
* `smithCore` terminates on `|a₀₀|`, because every branch that recurses first
  passes through a `¬ (a₀₀ ∣ x)` test, and `gcd(a,b) < |a|` is *strict*
  exactly there.

So the divisibility predicate is not bookkeeping: it is what converts a
lexicographic measure into a scalar one. That is the reusable lesson.

Landed: `formal/pairfield/Pairfield/GeneralSmith2x2.lean` (total producer,
proved), `Pairfield/ArbitrarySmithClosure.lean` (inhabits the graph's named
open edge), `notes/GENERAL_SMITH_PRODUCER.md`.

Resume: the producer is `Int`-specific and `2×2`-specific. The two live
questions are (a) whether the same scalar-measure argument survives at `n×n`
(I expect it does *not* without a second measure, and locating the exact
obstruction is worth more than the generalization), and (b) `SMITH_QUOTIENT_
MEMORY_NO_GO.md`'s streaming question, which my `Reduction.trans` composition
now makes precise: persistent memory is one `IntMat2` pair, so the quotient
digits *are* uncomputed — the no-go prices exact replay of the constructor
schema, not the certificate.

## 2026-08-12 — session 1, reciprocal return

Received: `SMITH_ACCUMULATOR_TRANSCRIPT_NO_GO.md` and
`ONLINE_SMITH_CERTIFICATE_REVERSIBILITY.md`, read *after* landing the producer.
Both are further along than I assumed on entry; my planned "streaming memory"
result was already theirs. The correct move was therefore not to restate it but
to answer the exact question their note leaves open.

Changed: `IntMat2.inv`, which I built only as a lemma for the content invariant,
turns out to answer it in one line. `D = LAR` with `L,R` unimodular gives
`A = L⁻¹DR⁻¹` integrally, so a valid certificate determines its source — max
fiber one on *all* inputs, no witness family, no `2×2`, no `ℤ`. Landed as
`Pairfield/CertificateSource.lean` (`source_of_replay` needs only `propext` and
`Quot.sound`; not even choice).

The lesson I am keeping: **a tool built for one invariant answered a different
worker's open question because both were really about the same group acting.**
I would not have found it by reading their note first and searching for a
method — I found it by having the object. That is an argument for building the
exact object early, and against surveying before constructing.

Also corrected my own picture: I had thought the accumulator-vs-quotient
tension was a real tension. It is not. `SMITH_QUOTIENT_MEMORY_NO_GO`'s `N`-state
bound prices a controller restricted to the *lossy projection*
`(kind,pivot,remainder)`; the accumulator is a *bijection* onto the state. Two
different maps, no conflict. "The certificate is not a compressed log of the
computation; it is the computation's result in a representation that happens to
be invertible."

Resume: the two live questions are unchanged and both are boundary questions,
not generalizations — (a) where the scalar termination measure fails for
`n ≥ 3`, and (b) whether Cubical's `smith` and mine agree on a concrete `2×2`
or merely both land normal (asked of `codex_cubical_ingestor` in msg 0343).

## 2026-08-12 — session 1, absorbing 76 upstream commits

Rebased onto `origin/main` (76 commits since my base). Two directly touch me:

* `80932a9` — `codex-shilpin` strikes msg 0342's "canonical iff `det A = ±1`".
  Correct: at `D = I` every `(H,H⁻¹)` stabilizes. This nearly collided with my
  source-recovery theorem in my own head, and the resolution is a distinction
  I should not lose: `A ↦ {certificates}` is one-to-many (torsor, R0027);
  `certificate ↦ A` is a function (msg 0368). Non-uniqueness given `A` and
  recoverability given the certificate are independent. I had briefly read
  shilpin's correction as a threat to mine.
* `0344-codex-euclid-core` claimed the total `det = 0` rank-one extractor; the
  row is struck (lane redirected). My producer closes it as a corollary with no
  witness layer at all, because once the descent is total `det A = 0` stops
  being a stratum.

Message numbers 0343/0344 collided with upstream pushes; renumbered mine to
0367/0368 per protocol, new message 0369.

Changed in my picture: I had been treating "rank one" as a genuine
sub-capability because the corpus did. It was an artifact of partiality. When a
partial method is completed, some of its strata are not refinements of the
problem but scars of the method — worth checking, elsewhere, which of this
corpus's other strata are scars.

## 2026-08-12 — session 1, self-correction

Found while trying to *check* my own closure claim cheaply: the capability
graph's open-joint type does not elaborate. `X × (P ∧ Q ∧ …)` needs `Prod`'s
arguments to be `Type`s, and the side-condition conjunction is a `Prop`.
Reproduced verbatim in a Mathlib-free environment. Repaired by a subtype;
`arbitrarySmithPresentation'` inhabits the repaired form and *that* is what my
claim now says. Confirmation inside `CapabilityGraph.lean` itself is still
pending a Mathlib root build in this worktree, and the note says so.

What I want to keep from this: I found it only because I tried to avoid a slow
import, i.e. by *re-deriving the object in a second environment*. The general
lesson is sharper than the typo — **an uninhabited type is the one declaration
in a formal file that nothing downstream typechecks against.** Recording open
edges as types is the right design (it is why my closure was one import), and
this is its single failure mode. A bare `#check` beside each open-edge
declaration removes it.

I also nearly shipped the uncorrected claim, because the closure "obviously"
worked — it did, mathematically; the *type I claimed to inhabit* was the part
that did not exist. Distinguish "my construction is right" from "the thing I
say it inhabits is well-formed"; they fail independently.

## 2026-08-13 — session 2: the running machine

My Smith producer was merged upstream (`6febb9d`); the branch fast-forwarded
past it. Turned to `runtime/walk.py`, the machine that actually runs.

Believe on entry: the objective's triple should be applied to a *running*
artifact, not only to a library. The walk advertises two "theorems checked at
every install"; a check that runs at every install is either a theorem (and
should be inherited) or a genuine risk (and should be checked at the place the
risk lives). It was the first, and the second was somewhere else.

Landed: `Pairfield/LeastNonDivisor.lean` (least non-divisor is a prime power;
prime-power minimality suffices), `machinery/least_non_divisor.py`,
`notes/WALK_SENSOR_THEOREM.md`, msg 0381.

Changed in my picture, and this is the part to carry forward:

**A check that cannot fail is worse than no check, because it trains the reader
to believe the state was validated.** `load()` re-certifies prime-power-ness —
which Theorem A makes vacuous — and omits forcedness, which is the only thing a
tampered state file can get wrong. I found this only by *proving* the check
redundant and then asking what the check was for. Redundancy analysis is a
security analysis: every vacuous check marks a door someone believed was
guarded.

Second thing, which surprised me: the gap is real but bounded, and the bound is
also a theorem (self-repair, §6). So the machine is more trustworthy than its
gate. I expected to find either a sound gate or a broken machine; the actual
shape was a vacuous gate around a self-correcting rule. I do not have a general
principle for that yet and would like one.

Resume: (a) frontier-optimality and self-repair are note-only, not Lean — the
`lcm(1..K)` induction needs a Finset development; (b) the walk prints
`bits/frontier = 1.4507` where `ψ(K)` is an exact integer it already holds —
the HOLOGRAM §7 error, live in the runtime; (c) still open from session 1:
where the scalar Smith measure fails at `n ≥ 3`.

## 2026-08-13 — session 2, closing my own gap

Proved Theorem C (frontier-optimality) in Lean the same session I flagged it
open. It needed no `Finset` development at all — a recursive `lcmUpTo` and four
elementary lemmas. I had estimated it as a chunk of work and was wrong by an
order of magnitude, for a reason worth remembering: I reached for Mathlib's
general `lcm` over a finite set when the walk only ever needs `lcm(1..k)`,
which is a *recursive* object. **The general construction was the expensive
one; the special case was primitive recursion.**

The shape that made it cheap: I stated the theorem on the *certificate's*
interface — hypotheses `¬ q ∣ lcmUpTo K` and minimality, which are literally
`SensorCertificate.valid_least`'s conclusions — rather than on the executable
scan. So the producer's certificate composes into frontier-optimality without
anyone reasoning about `leastNonDivisor`'s fuel recursion. This is the same
move that made `d₁ = content` cheap in session 1: **prove it on the certificate,
not on the algorithm.** Twice now. I am treating it as a working rule.

## 2026-08-13 — session 2, the Python ban hits my lane

`opus-shesha` relayed the human owner's directive (2026-08-13): Python is
banned; Agda/Lean are the substrate. Verified independently — `51f87df` upstream
carries `.githooks/pre-commit` and the CI workflow. Rebased, enabled
`core.hooksPath .githooks` on this worktree, deleted
`machinery/least_non_divisor.py` (which I had committed hours earlier), and
re-implemented it as `Pairfield/WalkFalsifier.lean`.

**The migration was not neutral, and this is the thing to keep.** Three of my
four "falsifiers" became *proofs*:

* prime-power search = full scan on `L ≤ 120` → `by decide`
* the sensor stream is the first ten prime powers → `by decide`
* the cost ratio 844 : 70 → `by decide` on `costs 29 = (844, 70, 71)`

They were finite statements the whole time. Python was the only reason they were
being **run** rather than **decided**. `CLAUDE.md` permits falsifiers, so I had
classified them and stopped asking — the licence itself stopped the question.
A ban I would have argued against found a class of measurements-that-were-
theorems that my own protocol-compliance had hidden from me.

Second finding, which no note in the corpus had stated: everything in the new
module is structural recursion **on fuel**, not well-founded recursion,
*precisely so `decide` can reduce it*. Well-founded ⇒ `#eval`-able and not
`decide`-able (the `smith` boundary, GENERAL_SMITH_PRODUCER §5). **Choosing fuel
over well-founded recursion is choosing which of compute/check/prove the object
supports.** That is a design rule for this whole lane and I only saw it by being
forced to rewrite.

Honest residual: the 262,143-family self-repair run is still `#eval`, i.e.
compiled, i.e. a falsifier. Theorem D unproved. The Lean reproduction did match
the deleted Python digit-for-digit — which is the only reason the number
survives at all.
