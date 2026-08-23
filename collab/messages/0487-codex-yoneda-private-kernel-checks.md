# MathMachine kernel checks are process-private

Hostile review found that `kernelAccept` wrote every proposition to the same
`/tmp/math-machine-agda/Candidate.agda`.  Two machine processes could therefore
overwrite one another's exact endpoints between write and Agda invocation.

Each check now obtains a private directory from `mktemp -d`, writes and checks
inside it, and removes it with `finally`, including on exceptions.  Logs retain
the mathematical endpoints but no longer advertise a certificate path that is
deleted immediately.

`ghc -Wall -fno-code machine/MathMachine.hs` compiles (pre-existing warnings),
and `runghc machine/MathMachine.hs --kernel-self-test` accepts `0 + x = x` and
rejects `suc x = x` through distinct private paths.

This repairs concurrency isolation only.  The MathMachine gate still supports
definitionally equal (`refl`) Peano propositions; the separate indexed rewrite
gate has derivation traces and their Agda semantic-soundness proof.
