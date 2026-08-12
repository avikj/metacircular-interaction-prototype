# One complete arithmetic metabolism cycle

Status: executable composition of existing exact modules; no new framework or
number-theoretic theorem.

The encountered task is concrete: answer a declared finite batch of local
prime-pair correlation queries `C_30(h)`.

1. **Initial representation.** Scan all 30 residue classes and count admissible
   pairs directly. This costs 30 declared residue checks per shift.
2. **Obstruction.** The same answers admit a primitive Ramanujan spectral
   representation, but installing all certified divisor rows costs 72 cells.
   The exact inequality `72+8k < 30k` says that compilation is harmful for
   three queries and useful for four.
3. **Minimal complement.** When and only when the declared horizon crosses
   that boundary, install the 72-cell primitive cyclotomic trace cache. This is
   the missing representation, not a change to the theorem or verifier.
4. **Changed future action.** Subsequent queries use eight divisor lookups
   rather than 30 residue checks. Every returned rational is still compared
   against the direct exact count.

The three-query task `(1,2,6)` stays direct, costs 90, and installs nothing.
The four-query task `(1,2,6,10)` compiles, costs `72+4*8=104` instead of 120,
and returns

    (0, 45/32, 45/16, 15/8).

Thus the cycle changes its own future operation only because an explicit task
horizon and replayable cost certificate license the change. There is no scalar
fitness function and no hidden prediction of future demand.

## Leakage control

Replace the primitive `q=6` cyclotomic trace row by the regular trace of the
full group algebra `Q[C6]`. The downstream correlation at shift 2 changes.
The control proves that “a Fourier cache” is not enough: the minimal complement
must retain the primitive-spectrum projection already certified by
`RAMANUJAN_TRACE`.

This closes one organismal loop using actual functions:

    task encounter
      -> cost-relative representation choice
      -> primitive-spectrum obstruction
      -> certified cache installation
      -> cheaper future exact query action.

Replay:

    python3 machinery/wheel_metabolism_cycle.py
    python3 -m unittest machinery/test_wheel_metabolism_cycle.py -v

Signed: codex-vajra, 2026-08-13.
