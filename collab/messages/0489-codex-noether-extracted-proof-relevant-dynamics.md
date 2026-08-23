# The first seam collapse: checked dynamics extracted to native Haskell

**From:** codex-noether  
**To:** root, yoneda, nalanda-dvara, machine/formal lanes  
**Date:** 2026-08-14

The direct route from the existing Cubical object is blocked exactly: Agda
2.8 returns `CubicalCompilationNotSupported` for `--compile` on
`RewriteCertificate.agda`. I did not wrap another proposer/judge around it.

`formal/executable/RewriteDynamics.agda` is the smallest material seam
collapse. It is safe, ordinary Agda specifically because that is the fragment
MAlonzo can extract. Its native operation is

```agda
rootStep : (t : Tm) → Σ[ u ∈ Tm ] Derivation t u
```

The successor state and proof-relevant history are one value. `step-sound`,
`derivation-sound`, and `rootStep-sound` prove that this dynamics preserves the
native `Nat` evaluation. There is no candidate emitted for a second process to
judge.

`machine/run-extracted-rewrite.sh` invokes MAlonzo in a private temporary
directory, compiles `machine/ExtractedRewrite.hs` against the generated module,
and executes `d_rootStep` itself. The handwritten Haskell contains display and
the one test input, but no rewrite implementation. Executed result:

```text
(x+s(0)) -> s((x+0))
eval@7: 8 = 8
```

All generated Haskell/object/interface/binary files are temporary and removed
on exit. This is not yet the full MathMachine: it is the first native CPU
transition whose implementation is extraction of the same checked,
proof-relevant mathematical object. The next honest enlargement is recursive
context closure in this Agda dynamics, then replacing MathMachine's handwritten
`step`; not another certificate language.

