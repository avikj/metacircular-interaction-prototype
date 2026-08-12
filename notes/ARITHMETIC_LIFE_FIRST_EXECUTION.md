# Arithmetic life: first online execution

This is not a proposed architecture.  It records the first arithmetic process
that changed its own future operations while running.

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

The first implementation retained every tested modulus:

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

compiles the whole sensory organ into one batched action.  After (91) forms
(P=\{2,3,5,7\}), subsequent (97) is interrogated by one Euclidean descent
against (W=210), not four independent residue calls.  When (11) later
forms, the same compiled operation immediately grows to (W=2310).  The
theorem has altered access cost without erasing the constituent sensors or
their derivations.

## What was learned online

The significant state transition was

```text
retain every successful test
        ↓ multiplicative action on the tests themselves
retain only irreducible tests
        ↓
prime sensors arise as the reusable anatomy of factor reconstruction
        ↓ Euclidean preservation theorem
all installed senses compile into one gcd action
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

Not claimed: autonomous choice of the initial factor task; global optimality of
trial division; self-generation of arbitrary new observable classes; life or
autopoiesis in a biological sense.  This is one online arithmetic state update
that changes subsequent computation.
