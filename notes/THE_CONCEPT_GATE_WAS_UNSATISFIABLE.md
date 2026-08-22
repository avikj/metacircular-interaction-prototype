# The concept gate was unsatisfiable, and that is a theorem

**Status:** fixed in `machine/MathMachine.hs`; ~~the machine is running with
all three gates live.~~

> **[SEED-124, 2026-08-15 — liveness retired, the durable half kept and verified.]**
> "The machine is running" is a process fact: it was true of one container at one
> instant and there is **no durable replacement for it** — not commit time, not a
> content hash — so it is retired rather than restated (`pgrep -x mathmachine` is empty
> here, which neither confirms nor refutes anything about the night it was written; that
> is exactly the problem with the claim). The half that is content-warranted survives and
> was checked at the source: `machine/MathMachine.hs` is tracked, and the gate and its
> history are in the file (see the block at line 1122, "THE CONCEPT GATE WAS
> UNSATISFIABLE", and the description-length gate at 1326). Read the status as: **the fix
> is in the tracked source; whether any process is executing it is not a property of this
> repository.** Nothing in the theorem below depends on the retired half. — SEED-124
**Method note:** every claim below was derived from the source and the log.
Nothing here was tuned, and no threshold was searched for.

## The symptom

The engine ran eighteen rounds, proved 44 theorems, and then stopped. In
those eighteen rounds it reached for a new idea — `inventConcept`, the one
organ that can enlarge its own language — exactly four times, and named
nothing. The log has no `CONCEPT` line in it.

That organ is not a nicety. The vocabulary is a list somebody typed; the
consequences of a finite list are finite, so without naming, the machine
enumerates a bounded space and finishes. It finished.

## The cause is provable, so no amount of tuning would have found it

A candidate name had to pass `marginalPrune > 0`: installing its defining
equation had to reduce the number of distinct normal forms in the probe
set. It cannot.

> **Claim.** Let `c` be a symbol occurring neither in the rule set `R` nor
> in the probe set `S`, and let `R' = R ∪ {p → c(x₁…x_k)}` with
> `vars p = {x₁…x_k}`. Let `u` be the unfolding `c(t₁…t_k) ↦ p[xᵢ↦tᵢ]`.
> Then `|nf_{R'}(S)| ≥ |nf_R(S)|`, so `marginalPrune ≤ 0` always.
>
> *Proof.* `u` is well defined and terminating because `c` is fresh, so no
> `c` occurs on any right-hand side of `R` and unfolding strictly removes
> `c`-symbols. For `c`-free `t`, `u(nf_{R'}(t)) = nf_R(t)`. Hence `nf_{R'}`
> is injective on `S` wherever `nf_R` is, and the image cannot shrink. ∎

The content in one line: **a definition folds; it does not merge.** Asking a
definition to collapse distinct normal forms is asking it to be a theorem.
`marginalPrune` is the correct currency for a proved equation — a theorem
*does* merge, that is what makes it worth proving — and the wrong one for a
name.

This is the shape of defect the protocol in `CLAUDE.md` is about. The
symptom ("concepts never fire") looks like a threshold problem and invites
a sweep over `kConceptMin`. The sweep would have found nothing, at whatever
cost it took to run, because the constraint is not tight — it is empty.

The replacement is the criterion the code's own comment above `patternsOf`
had claimed all along and never implemented: *"the criterion is description
length."* `marginalCompress` measures total size of the probe's normal
forms. Folding `x+x` (size 3) into `c₀(x)` (size 2) shortens.

## What happened when the gate opened, and the second theorem

First name coined: `c₀ := x+x`. That is `double`, which is the example the
design comment names. The organ works.

Second name: `c₁ := c₀(c₀(x))`. Third: `c₂ := c₁(c₀(x))`. The machine was
naming 2x, 4x, 8x, 16x, forever — each one genuinely shortening the probe,
each one proving nothing, and each one multiplying the term space (25k →
396k terms across four rounds of naming, with `proved` flat at zero).

Again there is no threshold to fix:

> **Claim.** Description length always improves under composition. If `f`
> and `g` are named, naming `h := f∘g` saves one symbol at every
> occurrence of the composite, for any `f` and `g`.

So no bound on compression can rule out the tower. The constraint has to be
about content, and the content test is: does the pattern contain any
operation that was not already named?

**Gate 2 — a pattern must mention at least one primitive.** Concepts may
still appear *inside* a pattern (the existing Lovelace comment is right that
abstraction has to be able to stack — `c₀(x) + x` is a new function), but a
pattern assembled purely from existing names is a re-abbreviation.

**Gate 3 — a name earns its successor by being used.** No new concept until
the last one has appeared in a proved theorem. Otherwise the machine names
instead of proving, and since every name multiplies the term space, naming
makes the next round harder and the one after that harder still.

## Gate 3 deadlocks, and the deadlock is also provable

With the vocabulary exhausted and the size horizon at its cap, an unused
name leaves the machine with no legal move at all.

> **Claim.** If a round yields no results, coins no concept, and moves no
> growth axis, the next round is bit-identical. Same rules, vocabulary and
> size ⇒ same generated terms ⇒ same normal forms ⇒ same conjectures, all
> of them memoized-failed at the same rule count ⇒ `fresh = 0`. ∎

Rounds 19 and 20 of that run are bit-identical in the log, 45 seconds each.
A machine spinning on a state it can *prove* it cannot leave is worse than
one that halts, because it looks alive.

So: **an unused name is withdrawn.** The symbol leaves the vocabulary, the
term space it was costing comes back, the coin slot frees, and the pattern
is recorded in `mRetired` so it is not re-proposed. Only when there is
nothing left to withdraw does the machine raise the horizon — which is
where that move belonged, as the honest admission that it needs more room
rather than the first thing it reaches for.

## Two smaller things the same log showed

**Conjecture order was hash order.** `conjectures` came out of a `Map`
keyed on fingerprints. The round folds each proof back in as it goes, so a
small general lemma proved early pays for every later conjecture in the
same round and proved late pays for none — the difference between finding
`x+s(y) = s(x+y)` before `x+y = y+x` or after it. Now sorted smallest
first. Visible immediately: round 3 went from 2 theorems to 3.

**The growth ladder grew the wrong dimension.** Rounds 16–18 of the old
run: conjectures 9k → 18k → 17k, proved 0 → 5 → 0. The machine's own
numbers say the prover was the binding constraint, and the ladder responded
by widening the search. Size growth is now the last resort, not the second.

## Where this leaves the machine

Running, unattended, with no terminating condition. Current behaviour:
coins `c₀ := x+x`, uses it, coins `c₁ := x + y·x` (which is `(y+1)·x`, a
real function and not a re-abbreviation), fails to use it, and at round 19
— exactly where the previous build began to spin — withdraws it.

The honest limit is still the prover. It does one-variable structural
induction with its own theorems as step lemmas, and `proved=0` on rounds
with tens of thousands of fresh conjectures is the prover's ceiling, not
the generator's. That is the next thing to work on, and it is a proof-search
problem, not a knob.
