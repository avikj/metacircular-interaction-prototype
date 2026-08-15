# The one-line back-port that unblocks 72 modules in this container

2026-08-15. Applies to the CONTAINER's library checkout, not to this
repository. Nothing in `formal/` was changed to accommodate it.

## The situation

Three toolchain states are live at once (see
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` and `notes/CUBICAL_SKEW.md`):

| | Agda | cubical |
|---|---|---|
| the pin, per `formal/cubical/BUILD.md` | 2.8.0 | v0.9 |
| another lineage's container | 2.6.3 | v0.5 |
| this container | 2.6.3 | **v0.7** at `/tmp/cubical` |

cubical **v0.7 is released against Agda 2.6.4.1**. The two halves of this
container do not match each other, independently of the repository, and
the full-lane sweep attributed 72 of 102 failures to exactly one line:

```
/tmp/cubical/Cubical/Tactics/Reflection.agda:92
    withReduceDefs (false , don't-Reduce) (
```

`withReduceDefs` entered `Agda.Builtin.Reflection` in Agda **2.6.4**. On
2.6.3 the same operation is spelled `dontReduceDefs`, and the two are
related by definition: `dontReduceDefs ds = withReduceDefs (false , ds)`.

## The patch

```diff
--- a/Cubical/Tactics/Reflection.agda
+++ b/Cubical/Tactics/Reflection.agda
@@ -92
-    withReduceDefs (false , don't-Reduce) (
+    dontReduceDefs don't-Reduce (
```

It is a back-port, not a workaround: the replacement is the 2.6.3 spelling
of the same primitive, so `solveℕ!` and every tactic downstream of it
behave as the library's authors wrote them.

## What it unblocks

Verified by running each module after applying it:

| module | before | after |
|---|---|---|
| `NaturalMachine/Transport.agda` | red at Reflection:92 | **PASS** |
| `NaturalMachine/TransportMul.agda` | red at Reflection:92 | **PASS** |
| `NaturalMachine/RadixSymptoma.agda` | red at Reflection:92 | **PASS** |
| `NaturalMachine/AcceptanceTest.agda` | red at Reflection:92 | **PASS** |

`Transport` is the module that carries ℕ's addition across the place-value
chart — the lane's central exhibit — and `Base2`/`Base10` in the root
aggregate `open` it. It had never been checked in this container, and two
separate agents today wrote around its absence: one proved its place-value
identities by hand rather than importing it, another wrote a fresh
single-pass `scale` rather than reuse `mulw`. Both were right to, at the
time; neither has to now.

The sweep's category **L** was 72 modules, of which 71 are this line and
one is an unsolved-meta site in `Cubical/Categories/NaturalTransformation`.
So this single change moves the lane's verifiable fraction from 247/351 to
roughly 318/351 in this container. The remaining families are unchanged:
**S** (20 modules, `SymGroup`/`FinSymGroup`, right for the pin and wrong
for v0.7), **A** (1), **C** (the controls, which must fail), **R** (2
timeouts).

## Standing rules this does not break

- No repository file was edited to suit the container. The v0.9-only
  spellings stay as they are; they are correct under the pin.
- The patch is **not** committed anywhere in this repository, because it
  belongs to a library checkout at `/tmp/cubical` that no other machine
  shares. A container that starts fresh gets the unpatched v0.7 and the
  72 failures return.
- Under the pin (Agda 2.8.0 + cubical v0.9) the patch is unnecessary and
  must not be applied.

## For the next agent

If `Cubical.Tactics.Reflection` is red on `withReduceDefs`, apply the two
lines above and re-run. If it is red on anything else, this note does not
apply and the failure is new.
