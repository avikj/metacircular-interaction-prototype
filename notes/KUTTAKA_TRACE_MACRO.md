# A repeated vallī block earns a certified macro

Status: exact finite construction built on the checked `KuttakaValli.replayHom`
law. The cost is quotient/macro syntax length, not wall-clock time.

`KuttakaValli` proves that replay from quotient lists is a monoid morphism:

    replay(xs ++ ys) = replay(xs) replay(ys).

The displayed law is the *operation* clause only, which by itself makes `replay`
a semigroup morphism. The monoid claim needs the independent unit clause, and
the module has it definitionally: `replay [] = idm`
(`formal/cubical/KuttakaValli.agda:54`), which is also why `replayHom [] ys`
discharges to `sym (mulIdL _)` at line 68. So "monoid morphism" is the right
name. [Clause supplied in place by seed132, 2026-08-14, by reading the module,
not by typechecking it; no toolchain was run.]

That theorem alone gives composition, not compression. A macro is earned when
a quotient block `b` of length `m` is reused `r` times. Compile its matrix once,
then represent

    b^r

by the definition of `b` followed by `r` invocations. Under the exact declared
syntax measure,

    expanded length  = mr,
    installed length = m+r,
    gain             = mr-m-r = (m-1)(r-1)-1.

Therefore strict compression occurs exactly when `(m-1)(r-1)>1`. This cost is
derived from the actual quotient-list and macro-reference counts. It does not
assert that a matrix multiplication and an Euclidean division have equal
physical latency.

## Exact vallī

The quotient trace

    (1,2,1,2,1,2,1,2)

is the canonical Euclidean trace of `(153,112)`. Its direct replay is

    [[153,56],[112,41]].

Compiling `b=(1,2)` once and invoking it four times yields the identical
matrix. Expanded length is 8; installed syntax length is 6; the next bounded
trace representation is shorter by two symbols. The constructor independently
recovers the source pair from the replay matrix and reruns Euclidean division,
so an arbitrary noncanonical quotient list is not silently called a vallī.

## Controls and exact boundary

- A nonperiodic trace `(4,1,3,2,5)` yields no macro.
- A one-symbol block repeated five times preserves semantics but has negative
  gain: naming is not compression.
- Negative quotients are rejected.

Thus `replayHom` supplies the semantics-preservation proof spine, while repeated
block detection and the explicit syntax measure supply the missing selection
and cost facts. Without reuse, replayHom cannot generate a cheaper body.

Replay:

    python3 machinery/kuttaka_trace_macro.py
    python3 -m unittest machinery/test_kuttaka_trace_macro.py -v

Signed: codex-vajra, 2026-08-13.
