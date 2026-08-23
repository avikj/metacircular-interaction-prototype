# Exact boundaries on twelve-step temporal acceleration

**Status.** Elementary proved bounds and executable false controls.  This note
is deliberately narrower than the companion compiler and historical accounts:
it says exactly when a claimed multiplicative acceleration is real, when its
one-time cost is repaid, and which time cannot be accelerated by parallelism.

## 1. Two inequivalent twelve-year comparisons

Twelve Julian years contain

\[
12(365.25)(24)=105192
\]

hours.  A terminal operation whose primitive span exceeds `105192` represents
more primitive operations than twelve years at one primitive operation per
hour.  Separately, the ratio of twelve years to twelve hours is

\[
\frac{12(365.25)(24)}{12}=8766.                       \tag{1}
\]

A post-formation rate gain exceeding `8766` makes one new hour worth more than
twelve old years for the declared stationary workload.  It does not mean the
formation hours already accomplished that work.

## 2. Product theorem and a sharp elementary calibration

Suppose a level-`i` certified macro represents `r_i` copies of the preceding
macro.  Induction gives its primitive span

\[
R_k=\prod_{i=1}^k r_i.                                \tag{2}
\]

For twelve ternary levels, `R_12=3^12=531441>105192`.
For the rate comparison (1), if every level is restricted to doubling or
tripling, exactly two triplings are necessary and sufficient:

\[
2^{11}3=6144<8766<9216=2^{10}3^2.                    \tag{3}
\]

The necessity in (3) follows because replacing a `2` by a `3` increases the
product, so the largest product with at most one tripling is `2^11*3`.

More generally, if twelve positive relative gains have product at least `G`,
their geometric mean is at least `G^(1/12)`, and some stage has gain at least
that value.  This is a lower bound on the quality of the stages, not a recipe
for finding them.

## 3. Formation and reuse

Let an old execution cost `C`, the installed execution cost `c`, and total
formation plus verification overhead `F`.  After `M` uses, the old and new
costs are

\[
MC,\qquad F+Mc.
\]

### Amortization theorem

If `C>c`, installation is strictly beneficial exactly when

\[
M>\frac{F}{C-c}.                                      \tag{4}
\]

Thus the least integer reuse count is `floor(F/(C-c))+1`.  If `C<=c`, no
amount of reuse repays the formation in this metric.

This exact inequality separates capability, accomplished work, and option
value.  A proof or program can have other value when unused, but that value is
not the computational saving in (4).

## 4. The time that cannot collapse

Assume stage `i` cannot be certified until stage `i-1` is accepted, and its
irreducible formation/validation latency is `ell_i`.

### Critical-path theorem

The installed terminal macro cannot become admissible before

\[
\sum_i \ell_i.                                       \tag{5}
\]

**Proof.** The dependency forces the stage intervals into causal order; their
lengths add along that directed path.  Unlimited parallel work can shorten
off-path work, not this path. \(\square\)

Acceleration therefore has a sequential spine.  The twelve stages can make
later execution exponentially cheaper without taking zero time themselves.

## 5. False controls

1. **Independent shortcuts add.** Twelve unrelated span-three shortcuts cover
   `36`, not `3^12`, primitive operations.  Multiplication requires actual
   substitution into the next formation.
2. **A name need not execute cheaply.** If the terminal macro is interpreted
   by recursively expanding every child, its physical execution cost remains
   `prod r_i`; its short name creates no execution speedup.
3. **Redundant stages do not compound.** A stage that only renames the prior
   capability has multiplier one.
4. **Unreused formation may decelerate.** Equation (4) gives exact examples:
   if `C=8,c=1,F=27`, three uses lose or tie while four uses win.
5. **Explicit output remains physical.** A task required to emit `N` separate
   symbols still incurs at least `N` output events, regardless of the formula
   describing them.

These controls block a common equivocation: exponential denotational span,
exponential search-space elimination, short description, and wall-clock
execution are different quantities.

## 6. Integration into the live loop

The self-improving system should attach the tuple

\[
(R,\ c,\ F,\ M,\ \text{domain},\ \text{dependencies})
\]

to every installed shortcut.  A proof licenses semantic substitution; a cost
audit licenses acceleration; realized reuse tests amortization; dependency
edges expose the critical path and the withdrawal set.  Later formations may
use the shortcut as a constructor, which is the exact point where gains can
multiply rather than add.

The result connects rather than replaces the current machinery: shortest
generated programs determine formation paths, prefix caches price reuse,
proof DAGs retain the nested certificate, and withdrawal supports identify
which apparent future speedups disappear when an earlier result is revoked.

## Replay

```bash
python3 machinery/temporal_acceleration_bounds.py
cd machinery && python3 -m unittest test_temporal_acceleration_bounds.py -v
```

The numerics instantiate the proved identities and include known-false
controls; they are not a scan or empirical law of innovation.

## Rigor boundary

**Proved:** (2)--(5) and the finite controls.

**Not claimed:** that all mathematical discoveries compose, that twelve is
privileged, that historical content is recoverable from work counts, or that
the repository presently forms its own next compiler stage without external
proposal.
