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
