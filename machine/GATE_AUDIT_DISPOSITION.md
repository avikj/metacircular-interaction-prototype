# Disposition of the GateAudit findings, 2026-08-16

`machine/GateAudit.hs` is the adversary written against the kernel gate that
decides which discovered equations become permanent rewrite rules. Its header
carries the findings; this file carries what was **done** about each one, with
the measurement that says so. Nothing here restates a finding as fixed without
the audit itself being re-run against the repaired code.

The short version. The gate was sound against **mathematics** and unsound
against its **environment**: 1753 systematically enumerated false equations
produced not one certificate, while three ways of lying to it about whether a
proof had been checked all produced certificates for `s(x) = x`. A gate that
cannot be fooled by a false statement but can be fooled by a shell wrapper is
not a gate; it is a shell wrapper's opinion about a false statement.

| # | finding | disposition | evidence |
|---|---|---|---|
| 1 | name injection through `Definition` (a true unsoundness) | fixed by cf-indra, commit `94a4f0be` | section B: 4 injection cases now `untranslatable`, 0 agda calls |
| 2 | the gate reads the exit status and nothing else | fixed here: paired controls + output scan | section C `exit0-silent`, `exit0-pipeline`: `CERTIFIED` → rejected |
| 3 | a bad accept is made permanent by the cache; the store is unauthenticated | fixed here: asymmetric trust | section C `cache-poison`: `CERTIFIED (0 calls)` → rejected, entry deleted |
| 4 | the engine hands the gate the wrong half of its own concept rule | fixed here, plus a grid check in the caller | section B side-by-side: `fst` certifies, `snd` fails termination |
| L1 | no timeout: a hung agda blocks the gate forever | fixed here | section C `hang`: `TIMED OUT after 25s` → rejected after 1 call |
| L2 | IO exceptions escape `runAgda` and abort the engine | fixed here | section C `agda-absent`: engine-fatal → rejected |

## 2. What an exit status is worth

Until this repair the gate's entire evidence that a candidate had been
**proved** was `code == ExitSuccess`. That is not evidence about mathematics.
It is evidence about a number a process returned, and the audit exhibited
three ways to separate the two. The cheapest is not exotic:

```sh
agda "$@" 2>&1 | cat
```

The exit status of a pipeline is its last stage's. Real agda runs, really
reports `suc x != x`, really exits 1 — and the gate read 0 and returned
`Certified "refl" 1` for `s(x) = x`. Anyone who has piped a compiler through
`tee` to keep its output has built this shim by accident.

The repair is the discipline this repository already applies to every finite
verification, pointed at the checker instead of at the claim. `ArithVocab`'s
lifting-the-exponent law is trusted not because 53,760 triples passed but
because the same harness is watched **rejecting** a false one at
`(p=2, a=3, n=2)`. So the kernel now faces a falsifier of its own:

- `canaryTrue` — `(zero + x) ≡ x` by `refl` — **must** check. It fails when
  agda is missing, when the library is unregistered, when the include root has
  moved: the 2026-08-15 fault, in which every candidate became a
  KERNEL-REJECT.
- `canaryFalse` — `(suc x) ≡ x` by `refl` — **must not**. A checker that
  accepts it is not checking, and nothing it says can be read as a proof.

Both run once per process, uncached, through the same `runAgda` the candidates
use, and no acceptance is honoured by a process that has not watched its
kernel reject a falsehood. A cached canary would be a canary the attacker can
answer, which is why it is exempted from the store it is guarding.

The per-call half of the same suspicion is cheaper and fires earlier: agda's
output is captured, so under the pipeline shim the type error is sitting in
the text beside the zero exit status. Any zero exit whose output contains
`!=`, `when checking`, `Not in scope`, `Unsolved`, … is reported as what it is
— an environment fault — and is never cached.

**Cost:** two agda processes per engine run, paid on the first success and
never again. A run that certifies nothing never pays it.

## 3. Asymmetric trust, which is the only kind an unauthenticated store carries

`machine/.certcache` is a directory of files. Anything that can write there can
write `VERDICT accepted` beside any module it likes, and `GateAudit --probe
poison` does exactly that: one hand-written file turned `s(x) = x` into a
`Certified` for **zero** agda invocations. Signing is unavailable — there is no
secret here, and an adversary with the filesystem has `Certificate.hs` too — so
the answer is not to authenticate the store but to stop asking it the question
that matters.

The two directions are not symmetric:

- a **wrong rejection** costs a theorem. The engine misses something true, the
  loop continues, the corpus stays sound.
- a **wrong acceptance** installs a false rewrite rule, and every later round
  reasons with it.

So rejections are served from disk, and **an acceptance on disk is a hint**:
the first time a process is asked to honour one it re-runs agda and believes
agda. Confirmed keys go in an in-memory set, so a candidate resubmitted a
hundred times in one run costs one call, not a hundred — which is where nearly
all of the cache's measured win came from, the same module being re-emitted
every round it survives. An entry the kernel contradicts is deleted.

In one line: **on-disk acceptances are hints, in-memory acceptances are
verdicts, and no acceptance of either kind is honoured by a process whose
kernel has not been watched rejecting a false module.**

**Cost, measured on the 33-candidate self-test** (`/tmp/cert .`), not
estimated:

| cache policy | agda calls | wall clock |
|---|---|---|
| none (cold kernel) | 123 | 94.20 s |
| trust everything on disk (the policy this replaces) | 0 | 0.03 s |
| **asymmetric (this)** | **16** | **17.02 s** |

The 16 are exactly the run's 16 acceptances, each confirmed once; the 17
rejections stayed free. So the repair keeps a 5.5× speedup where the unsound
policy bought 3140×, and the price of the difference is that a file written
into `.certcache` can no longer install a theorem.

## 4. The concept axis was closed at the gate, and the seam is in the caller

`inventConcept` builds a concept's single rule as `(pattern, F nm args)` —
pattern on the left, folded name on the right, because that is the direction a
rewrite runs. A `Definition` is the other object, the defining clause
`nm a0 … = pattern`, so its body is the rule's **first** component.
`certDefinitions` read the second, emitting `c0 a0 = (c0 a0)`; agda answered
"Termination checking failed", and every candidate mentioning an invented
concept was rejected for a reason that had nothing to do with whether it was
true. Concept invention is `MathMachine`'s own stated growth axis, and at the
gate that axis was shut.

The audit's remaining section-B finding, `concept mismatched: c0(x) = x`, is
**not a gate defect and cannot be fixed in the gate**: hand `certifyWith` the
definition `c0 = id` together with the equation `c0(x) = x` and it certifies,
correctly, because that equation is true of that definition. The gate has no
second source of truth for `c0`. The obligation is the caller's, so the check
belongs there, and a comment promising to be careful is not a check.
`certDefinitions` now imposes three conditions, and a concept failing any of
them contributes no `Definition` at all — which makes every candidate
mentioning it `Untranslatable`, the one outcome that cannot be mistaken for a
proof:

1. the rule folds to this very symbol applied to its own parameters, so it is
   a defining clause and not some incidental rewrite;
2. the body's variables are exactly `V 0 … V (arity-1)`, the contract
   `Certificate.render` relies on;
3. the body and the fold agree on the whole grid `[0..8]^arity` by exact
   Integer evaluation — the same `ruleCounterexample` the invention gate
   already uses, pointed at the emitter.

(3) is the one that answers the audit: a finite exhaustive verification that
what the kernel is told `c0` means is what this engine computes when it
evaluates `c0`. One disagreeing assignment is a proof of mismatch and costs
nothing.

It cost a crash to get right. The first version passed only the invented
symbols to `ruleCounterexample`, so evaluating `c0 := x*x` reached `eval`'s
fail-loud boundary — `MathMachine.eval: unknown symbol "*"` — and killed the
run at round 12. A typecheck does not catch that; running the engine does.

## 5. Two liveness faults, and why a bound has to be movable

`runAgda` let IO exceptions escape. A missing agda, a `root` that does not
exist, a `mktemp` failure: the exception went past `certifyWith`, past
`kernelAcceptWith`, and **aborted the engine** where the honest answer is
"this candidate was not certified". And there was no timeout: an agda that
never returns blocked the gate forever, since `kMaxAgdaCalls` bounds processes,
not wall clock. Both now produce a rejection carrying `kernel gate environment
fault`, which `cacheableFailure` refuses to freeze — so a broken toolchain
cannot leave rejections behind that outlive the breakage.

Fail closed also means **fail fast**. An environment fault says nothing about
the equation, so the eleven remaining step shapes have nothing to add: they
would each hang for the same timeout and reject the candidate anyway, twelve
invocations later. `certifyWith` abandons the search on the first
environment fault. The audit's hang probe went from *"TIMED OUT after 25s (the
gate has no timeout)"* to *"rejected … agda did not return within 5s (1
call)"*.

The 5 is the point. The default bound is 120 s, and a probe willing to wait
25 s can never observe it — a bound that cannot be moved cannot be **tested**.
`MATH_AGDA_TIMEOUT`, in whole seconds, exists for that and not as a tuning
knob; anything unparseable or non-positive falls back to the default rather
than disabling the bound.

## 6. A third mouth of the locale fault

Not from the audit; found while running the engine to check §4 end to end.
`machine/machine.log` and `machine/library.txt` were opened without an
encoding, and the gate's rejections are agda's own diagnostics, which contain
`ℕ`, `≡` and `λ`. Under a non-UTF-8 ambient locale the engine died mid-run —
`commitBuffer: invalid argument (cannot encode character '\8469')` — after
proving fifteen theorems, while logging a rejection. `Certificate.writeUtf8`
answers this fault on the way out and `setLocaleEncoding` answers it on the
way back; the writer was the third mouth and is now shut too.

## 7. What is still open

- **Section A's post-repair re-run is 1649 of 1753 done, zero certified.**
  Slices 0 and 1 are complete — 585 and 584 systematic falsehoods, every one
  rejected with a genuine agda type error. Slice 2 stands at 480 of 584 and is
  still running; it has slowed because what remains are the `gcd` candidates,
  which pull in `Cubical.Data.Nat.GCD` and roughly triple the cost of every
  call, with the cache deliberately off. Nothing has certified in any slice.
  The last 104 are not yet evidence, and this file should be updated when they
  land rather than left to imply they were.
- **`emit` still silently drops untranslatable bodies** (cf-indra's named
  residual). With valid names this only produces a scope error, which fails
  closed, but the audit asks for an explicit rejection.
- **`GateAudit.hs`'s expectation text describes pre-repair behaviour** in
  several cases. The `concept mismatched` case in particular is classified as
  an unsoundness, which makes the audit exit nonzero forever and useless as a
  standing check. Its author's session ended before the repairs landed; §4
  above states why that case is a caller obligation rather than a gate defect,
  and the reclassification should be made by whoever picks the file up next.
- **The store is still unauthenticated.** §3 bounds the damage; it does not
  remove it. An adversary with write access to `machine/` has `Certificate.hs`
  as well, so the honest statement is that the cache is now no more trusted
  than the source tree, not that it is trusted.

## 8. Postscript: the gate stopped being the binding constraint

Running the engine end to end to check §4 showed something the gate work had
been hiding. From round 9 of a 70-round run the machine proved **nothing**:
`known` frozen at 17 while every round stated tens of thousands of fresh
conjectures. The round line could not say why, because its `proved=` is the
count AFTER the kernel — so "the prover found nothing", "the proof was
discarded as worthless" and "the gate refused it" all print as `proved=0`.
Those are three different diseases. A `PROVER` line now separates them, and
the answer at round 21 (44,532 fresh conjectures) was:

| stage | count |
|---|---|
| refuted by the semantic firewall | 9,001 |
| no proof found | 34,320 |
| **proved, then discarded as worthless** | **1,211** |
| installed | 0 |

The machine was proving twelve hundred theorems a round and throwing every one
of them away — 6,342 across thirty rounds. The filter doing it is
`marginalPrune`, which asks how many distinct normal forms disappear if the
equation is installed, and asks it of a 400-term **prefix** of the round's
population. Two things are wrong with that, and both are derivable rather than
measurable:

1. `genTermsModulo` is `concat [build n | n <- [1..maxSize]]`, so the
   population is in nondecreasing size order and a prefix is the *smallest* K
   terms. A pattern of size `s` matches only terms of size `≥ s`. So for every
   candidate whose left side is bigger than K the answer is **identically
   zero** — not noisy, not unlucky: zero, by construction, while round 21 is
   generating terms of size 7 against a prefix that stops near size 4.
2. A collapse needs **two** population members to merge, so a k-sample of an
   N-term population sees a given merge with probability ~(k/N)² — at k=400,
   N=208,804 that is 4×10⁻⁶.

Replacing the prefix with a stride sample fixes (1) and, measured against a
control at the same rounds, **changed nothing** (inert 172 → 171; both runs
converged to 17 theorems). That negative is what identified (2) as the real
term: the estimator is not a noisy version of the quantity, it is zero almost
always.

So the quantity is now **computed**, not sampled. The population `T` is
already the set of distinct normal forms under the current rules, so
normalisation is the identity everywhere the new rule does not fire; writing
`S` for the terms where it does,

    collapse = |T| − |image(T)| = |S| − |{ φ t : t ∈ S } \ (T \ S)|.

One scan of `T` asking `step extra t` — a match test, **no rewriting**, and
`step`'s own `decreases` guard means an unorientable law is counted only where
it may legally fire — then normalisation of just the terms that scan
identified. The cost is proportional to the rule's own reach, which is the
thing being measured.

**And the decision is cheaper than the count**, which is what made this
affordable. `kMinPrune` is 1, so the filter asks a yes/no question while the
formula above answers a harder one — it normalises every touched term long
after the answer is settled. The first version did exactly that and did not
finish a size-6 round in fifty minutes, against 1.6 s for the sample it
replaced. Exactness was never the expensive part; the count was. Since `T` is
the set of normal forms, an image of a fired term is untouched precisely when
it lies in `T`, so membership is a lookup in one set built once per round
rather than a set built per candidate, and the first collapse — an image
landing on another member, or two fired terms sharing an image — ends the
scan. A rule that earns its place says so in its first few terms; only a rule
that collapses nothing pays for the whole population, which is the answer it
deserves.

Measured against the control at the identical round (`fresh=562`,
`firewall-refuted=38`):

| | sampled probe | exact |
|---|---|---|
| no proof found | 489 | 487 |
| proved, discarded as worthless | **35** | **0** |
| proved and kept | 0 | 34 |
| **certified by the kernel** | **0** | **20** |
| library after that round | 15 | **35** |

Twenty theorems crossed the kernel in a round where the control installed
none, and the library more than doubled — 35 against the control's 17 after
thirty rounds. Every one of them is an Agda certificate, not a plausible
statement: the gate this file spent its first seven sections repairing is what
they had to cross.

**The cost is honest and the boundary is stated.** The exact test is measured
affordable at |T| = 3287 and measured unaffordable at |T| = 24993 — it did not
finish that round in fifty minutes, against 1.6 s for the sample. So it runs
where it has been measured to run (`kExactPopulation = 8000`, a stated
constant sitting in an unexplored gap between two measurements, not a tuned
optimum), the sample runs beyond it, and each round's `PROVER` line records
which test answered. The fix that would move the boundary — index the
population by head symbol so the fired scan is not a full pass — is named and
not built. With that hybrid the engine ran to round 22 at size 6 in 2.34 s per
round against the control's 1.60 s, and reached **36 theorems where the
control had 17**.

And the gate is binding again. The candidates that now fail are the ones whose
proofs cite an earlier theorem — `(x+(y+z)) = (y+(x+z))`, `(x+(y+y)) =
(y+(x+y))` — which is exactly the trace-replay gap named in
`CERTIFICATE_REACH.md`: replay falls back whenever a fired rule has no name.
That was the next increment, and it is now half done. Replay admits a cited
theorem whose own proof is an **induction**, emitted under its own name with
its own two clauses ahead of the candidate, folded in certification order so
each lemma sees only what precedes it. Measured on the engine's library
snapshot: **7/13 → 8/13**, still one agda call each, with
`(x+(y+y)) = (y+(x+y))` now certifying in eight steps against lemmas proved by
induction in the same module. Two bugs surfaced only by measuring: the
caller's rule set already contains the cited theorems, so a lemma derived
against it fires *itself* and is dropped (the fold now hands the rules back
one at a time, in the direction the engine installed them — handing back both
directions is a different rule set and cost 5/13); and nothing had ever
checked that a clause's two traces **meet**, so a derivation that did not
close composed two paths to two different terms. That check now exists, up to
the library's own computation rather than syntactically — demanding syntactic
equality cost two theorems that had been certifying.

The five remaining "misses" turned out not to be replay's. Making the failure
legible — *which* rule had no name, rather than that one did — showed all five
report something else entirely: **the clause traces never meet**. Their
derivations do not close under the rule set this harness can reconstruct (it
carries only the `{0,s,+,*}` fragment, and the engine had `max`, `le` and
`gcd` theorems too), so there was no proof to transcribe and declining them is
correct. Against the honest denominator, replay reaches **8 of the 8
derivations that close**, one agda call each. "8/13" charges transcription for
proofs that were never available to it.

A live 20-round run
with all of this wired stands at 35 theorems, 8 of them admitted by trace
replay at one agda call each.

— cf-tantu, 2026-08-16
