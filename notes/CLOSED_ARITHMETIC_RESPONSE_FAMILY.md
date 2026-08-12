# The smallest autonomous arithmetic response quotient, and its full-action obstruction

## 1. Exact family and schedule

Let `X=Z/5Z`.  For each `a in X`, let `mu_a(x)=ax`, and observe

\[
h(x)=\begin{cases}0&x=0,\\1&x=1,\\ *&\text{otherwise}.\end{cases}
\]

The five maps are already closed under reuse because
`mu_a mu_b=mu_(ab)`.  The seed is `1`.  Two different continuation semantics
must not be conflated.

The **autonomous schedule** installs one `mu_a` and queries

\[
\epsilon,\mu_a,\mu_a^2,\mu_a^3,\mu_a^4.
\]

It is fixed before any response, so API/call order contains no policy.  The
**full-family schedule** instead admits every later left multiplication
`mu_b`, independently of the installed `a`.

## 2. Autonomous theorem

**Theorem 2.1.** One use has response fibers

\[
\{0\},\quad\{1\},\quad\{2,3,4\}.
\]

The complete autonomous response laws have fibers

\[
\{0\},\quad\{1\},\quad\{4\},\quad\{2,3\}.
\]

Thus autonomous self-reuse gives a proper predictive quotient with class
counts `3<4<5`.  It is cardinality-minimal among all finite families having
at least three one-use classes, a strictly finer proper predictive quotient,
and a still-finer equality relation.

**Proof.** Zero remains zero.  One remains one.  The element `4=-1` has order
two, hence response word `*,1,*,1,...`.  The elements `2` and `3=2^{-1}` both
have order four and their nontrivial powers hit `1` first at multiples of
four; because `h` merges all other nonzero residues, their response laws
coincide.  This order classification proves every future response, not only
the displayed horizon.  For minimality, strict refinement increases the
number of classes: if `P<Q<equality` and `|P|>=3` on an `n`-element family,
then `3<=|P|<|Q|<n`, forcing `n>=5`.  The example attains five. □

This is naturally arithmetic: the intermediate class records multiplicative
order only up to the coarse observation, not a hand-labelled partition.

## 3. Hostile return: arbitrary continuations destroy the middle

**Theorem 3.1 (full-action obstruction).** If every `mu_b` is an admitted
later continuation, the Myhill--Nerode quotient on the five installed scalars
is equality.  Hence the stronger reading has class counts `3<5=5` and no
proper intermediate predictive quotient.

**Proof.** Zero is already separate.  For distinct units `a,c`, choose
`b=a^{-1}`.  Then `h(ba)=1`, whereas `bc != 1`, so `h(bc)=*`.  Therefore every
pair of units is separated by an admitted one-step continuation. □

This correction entered from the hostile response to message 0297.  Its
smallest concrete witness is the autonomous pair `2,3`: left multiplication
by `2` sends them to `4,1`, with responses `*,1`.  The result changes the
landing: the requested construction exists only for the explicitly declared
autonomous schedule; the full closed action family has a minimal obstruction.

## 4. Prediction is not installation authority

Arithmetic determines either response law exactly.  It does not determine
which scalar may be installed in a situated process.  The executable therefore
lets `predict(a)` append only to a prediction ledger.  Installation requires a
separate `authorize(a, provenance)` input; an authorized scalar may oppose the
prediction.  Closure, order, and quotient calculations certify consequences
of installation, not authority to install.

## 5. Rigor boundary and replay

Proved here: closure, both fiber classifications, the all-future order
invariant, full-action discreteness, and the cardinality-five lower bound.
The family is claimed smallest by cardinality for the stated partition chain,
not uniquely natural.  No novelty claim is made.

Replay and false controls:

```text
cd machinery
python3 -m unittest test_closed_arithmetic_response_family.py -v
```

The executable checks the exact tables as falsifiers.  The proof beyond
enumeration is multiplicative order in Theorem 2.1 and regularity/inverses in
Theorem 3.1.  A binary `zero/nonzero` observer is a known-false control for the
premise: it supplies only two one-use classes.
