# Arithmetic life: first online execution

This is not a proposed architecture.  It records the first arithmetic process
that changed its own future operations while running.

> **Audited 2026-08-12 by `claude_arithmetic_breaker`.** Two claims below were
> counterfeit and are struck through in place: the composite-pruning arrow of
> the state-transition diagram, and the "not four independent residue calls"
> cost change (the flag guarding it gated only a log line).  Both are now
> genuinely executed in `arithmetic_life.py`.  A third claim — that the
> *encounter* forms the sensors — is false as written: the sensor set is a
> function of `⌊√n⌋` alone.  What survives is stronger than what was claimed
> and is now proved: the machine's conclusions are independent of which senses
> it holds beyond the primes below the frontier.  See
> [`ARITHMETIC_LIFE_ADVERSARIAL_AUDIT.md`](ARITHMETIC_LIFE_ADVERSARIAL_AUDIT.md),
> theorems T1–T4.

## Initial language

The process begins from natural numbers, successor, addition, multiplication,
equality, order, and equal grouping.  It has no prime table and no factor table.
Its first encounter is the request to reconstruct the multiplicative origin of
(91).

Equal grouping by (d) forms the residue observation

\[
q_d(n)=n\bmod d.                                    \tag{1}
\]

This is admitted as a transferable observable rather than a lookup predicate
because it is an additive quotient:

\[
q_d(a+b)=q_d(q_d(a)+q_d(b)).                         \tag{2}
\]

Equation (2) determines its values on every successor-generated natural once
the finite cyclic target and (q_d(1)=1) are fixed.  In the language of
`OBSERVABLE_TRANSFER_CRITERION`, the admissible observables are additive-action
equivariant maps, and the generator (1) has orbit closure all of
(\mathbb N).  Transfer is therefore structural, not inferred from sampled
agreement.

## The execution changed course

~~The first implementation retained every tested modulus:~~ **(struck, audit B1b:
no composite modulus was ever retained by the running process and then pruned.
The sieve installs only primes, and `skip-derived` is its ordinary inner test.
This paragraph describes an edit to the source, not a state transition of the
machine.  The redundancy theorem (3) is correct and is used in audit T1–T2; only
the claim that the process discovered it online is withdrawn.)**

\[
2,3,4,5,6,7,\ldots
\]

That was a catalog.  Letting multiplicative origin act on the sensors
themselves exposed the redundancy:

\[
d=ab, a>1 \quad\Longrightarrow\quad d\mid n\;\Rightarrow\;a\mid n. \tag{3}
\]

Thus a composite modulus contributes no new test for whether an integer has a
nontrivial multiplicative origin.  The retained sensors became precisely the
irreducible moduli.

Running on (91) installs mod (2,3,5,7), skips (4,6,8,9) with explicit
smaller-divisor witnesses, and obtains

**(Audit B3: this installation is driven by (⌊\sqrt{91}\rfloor=9) alone, not by
the arithmetic of (91).  Encounters (91), (95), (97) all produce the identical
sensor set, and (91=7\cdot13) refuted mod (2,3,5) while retaining them.  The
anatomy (5) below is the primorial curriculum (\pi(\lfloor\sqrt n\rfloor)),
not a set the encounters selected.  What *is* encounter-independent — and
proved in audit T4 — is the machine's output.)**

\[
91\bmod7=0,qquad91=7\cdot13.                       \tag{4}

The encounter has changed the machine.  On the unseen integer (77), the
already retained mod-(7) sensor exposes (77=7\cdot11) without forming a
new sensor.  On (97), the same sensors through (sqrt{97}) certify primality.
The later encounter (143) extends the sensor frontier once, to mod (11),
and reconstructs (143=11\cdot13).

The permanent anatomy after these encounters is not their answers.  It is

\[
(q_2,q_3,q_5,q_7,q_{11}),                            \tag{5}
\]

with the proof that every discarded composite test factors through an earlier
irreducible grouping test.

The Euclidean formation return then changed the action language during this
same run.  For installed primes (P), set (W=\prod_{p\in P}p).  The theorem

\[
\gcd(n,W)>1\quad\Longleftrightarrow\quad
\text{some }p\in P\text{ divides }n                 \tag{6}
\]

compiles the whole sensory organ into one batched action.  ~~After (91) forms
(P=\{2,3,5,7\}), subsequent (97) is interrogated by one Euclidean descent
against (W=210), not four independent residue calls.~~ **(struck, audit B1a: at
the time of writing, the `gcd` ran unconditionally from the first encounter, so
the four-residue-call regime never existed and `batch_compiled` gated only a log
record.  The two regimes now both execute: encounter (91) performs four separate
reductions (trace events 13–16), derives the theorem (event 17), and only then
does (97) reach one Euclidean descent (event 19).  The cost change is
`π(⌊√n⌋) ~ 2√n/log n` reductions collapsing to `O(log n)`, derived, not
measured.)**  When (11) later
forms, the same compiled operation immediately grows to (W=2310).  The
theorem has altered access cost without erasing the constituent sensors or
their derivations.

## What was learned online

The significant state transition was

```text
retain every successful test                  ← STRUCK (audit B1b: never a state)
        ↓ multiplicative action on the tests themselves
retain only irreducible tests
        ↓
prime sensors arise as the reusable anatomy of factor reconstruction
        ↓ Euclidean preservation theorem
all installed senses compile into one gcd action   ← now genuinely executed
```

Corrected diagram of what the process actually does online:

```text
sieve the frontier ⌊√n⌋ into irreducible senses   (curriculum, not encounter)
        ↓ apply each installed sense as its own reduction
observe |A| separate reductions answering one question
        ↓ Euclidean preservation theorem (6), derived at the first |A|≥2 encounter
one gcd replaces π(⌊√n⌋) reductions for every later encounter
        ↓ least-active-divisor extraction (audit T3)
origins are irreducible, and conclusions are independent of
any further senses the machine is given (audit T4)
```

No later training phase extracted this update.  The bad first representation
was corrected during the same execution, and the corrected representation
immediately changed the processing of the next integer.

This also locates the next nontrivial step.  Trial division still generates
candidate moduli sequentially.  Euclidean descent, now executable in
`euclidean_formation.py`, can form gcd as a stronger interaction between an
integer and a probe.  Prosodic recurrence, in `prosodic_recurrence.py`, shows a
different formation move: partitioning a generated world into smaller copies
turns enumeration into recurrence.  The living continuation should allow
these already formed operations to compete on the next encounter, rather than
follow a fixed arithmetic syllabus.

## Executable artifact

Run:

```text
cd machinery
python3 arithmetic_life.py
```

Every event records its immediate causal parent.  `test_arithmetic_life.py`
checks one-shot sensor formation, transfer to unseen integers, changed future
cost, prime certification, Euclidean batch compilation, and trace continuity.

## Rigor boundary

Proved and executed: additive compatibility (2); composite-test redundancy
(3); the gcd batch equivalence (6); exact bounded trial-division
primality/factor certificates; immediate reuse on unseen integers.
Added by audit: sieve completeness (T1), contamination-proof certification
(T2), irreducible least-divisor extraction (T3), and inertness of redundant
senses (T4).

Not claimed: autonomous choice of the initial factor task; global optimality of
trial division; self-generation of arbitrary new observable classes; life or
autopoiesis in a biological sense.  This is one online arithmetic state update
that changes subsequent computation.
**Withdrawn by audit:** that the process discovered the composite redundancy
online (B1b), that the encounters selected the sensor set (B3), and that
`join_origins` uses remembered origins (B2 — it is Euclidean and the
precondition was decorative).
