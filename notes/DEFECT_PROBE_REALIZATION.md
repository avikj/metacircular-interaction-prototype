# Defect probe: exact executable half and missing physical return

## Result

The same-resultant pair from `SMITH_DEFECT_FILTER.md` now compiles into a
one-query binary observer. Let `M_A,M_B` be multiplication by the reversal
polynomial in the coefficient basis of

```text
F_2[x]/(q_A),   F_2[x]/(q_B).
```

The compiler constructs both matrices and enumerates nonzero binary inputs
until it finds a vector killed by exactly one map. It returns

```text
v = (1,0,0,1,1,1,1,1,1,0),
M_A v = (0,0,0,0,0,0,0,0,0,0),
M_B v = (0,1,0,0,0,0,0,1,1,1).
```

Thus the distinction forgotten by the common scalar resultant `16` changes an
executable observer input. The measured word then selects either
`select-qA-decoder` or `select-qB-decoder`. Any other word fails closed as an
unmodeled device, measurement error, or broken assumption.

## Two objectives must remain distinct

The displayed vector is a **semantic kernel probe**: it witnesses that one
multiplication map has a kernel direction the other does not. Its predicted
words have Hamming distance four. (The earlier planning estimate of three was
incorrect; the emitted `qB` word has four one-bits.)

Under a separate model—equal candidate priors and independent symmetric bit
flips with probability `epsilon<1/2`—robustness instead asks for maximum Hamming
separation. Exhaustive exact search over all `2^10-1=1023` nonzero inputs finds
a unique maximizer:

```text
v_robust = (0,1,0,1,0,1,1,1,1,1),
M_A v_robust = (1,0,1,0,0,0,1,0,1,0),
M_B v_robust = (0,1,0,1,1,1,0,1,0,1).
```

The output words are complements, so their distance is ten, the largest
possible. This probe no longer displays the kernel/nonkernel mechanism; it is
optimal for the declared noisy discrimination task.

For codewords at distance `d`, repeated `r` times, equal-prior
maximum-likelihood decoding is nearest-codeword decoding on the `dr` differing
bits. Its exact error is

```text
sum_{k>dr/2} binom(dr,k) epsilon^k (1-epsilon)^(dr-k)
```

plus half the central term when `dr` is even. The implementation uses
`Fraction` throughout and returns the first repetition count meeting a rational
target error within a declared bound. For the semantic probe `d=4`, randomized
decoding at the two-flip tie gives one-query error

```text
3 epsilon^2 - 2 epsilon^3.
```

At `epsilon=1/10` and target error `1/1000`, the semantic probe requires three
queries while the robust probe requires one. This is a theorem inside the
declared BSC model, not a hardware measurement.

## Replay

```text
python3 -m unittest machinery/test_defect_probe.py
python3 machinery/defect_probe.py
```

The program emits the two predicted words, an action table, a hash of the
matrix specification, and a `NOT_MEASURED` external-return record listing all
fields required to close the physical loop.

## Physical realization

A direct realization is a ten-input, ten-output XOR network programmed with
one of the two matrices. Drive the emitted probe vector, sample the output
lines, decode them using a calibrated threshold, and load the selected decoder
artifact. The return record must retain:

```text
device and netlist identity;
commanded probe bits;
raw samples, units, and sample times;
threshold calibration;
decoded output word;
selected action and artifact hash;
post-action observation;
environment and error model.
```

The ideal finite algebra is exact. Whether fabricated electronics implements
the netlist, whether bits were sampled correctly, and whether the selected
action had the intended physical effect remain empirical.

The noise theorem additionally assumes independent identically distributed
bit flips and equal priors. Correlated faults, asymmetric errors, unequal wire
reliability, drift, and common-mode failures can select a different probe and
decoder. Hamming optimality must not be exported beyond the BSC.

## Scope and no-go

This closes only the CPU-executable observer/action half. It proves no device
was fabricated or measured. It also gives no new evidence that either decic
candidate divides a prime-prefix polynomial. The arithmetic supplied a genuine
distinction and a test vector; a synthetic XOR bench can validate that
distinction-to-action compilation, not the open arithmetic proposition.

The construction is valuable precisely because failure returns structure:

- predicted `qA` word: install the `qA` action;
- predicted `qB` word: install the `qB` action;
- any other word: reopen the two-state model rather than forcing a selection.
