# Action residuals under response characters

**Status:** author-proved in safe Cubical Agda; independent audit unassigned.
No novelty is claimed.  Character kernels and diagonal phase-oracle
conjugation are standard.  The contribution here is the exact interface
between R0044's formed action residual and R0042's response-character boundary.

## 1. The common object

R0044 starts with an abelian-group-valued observation, installed action, and
declared predictor:

```text
q       : X -> A
step    : X -> X
predict : A -> A
delta(x) = q(step x) - predict(q x).
```

Let `chi : A -> {+1,-1}` be a sign character.  Since every sign is its own
inverse, the character law gives the exact identity

```text
chi(delta(x))
  = chi(q(step x)) chi(-predict(q x))
  = chi(q(step x)) chi(predict(q x)).                 (1)
```

This is not a resemblance between a cocycle and a phase.  It is equality in
the sign group, checked by
`RelativeSignPhase.character-residual-is-relative` in
`formal/cubical/NaturalMachine/ActionResidualPhase.agda`.

## 2. Quantum/process reading

Assume additionally that `step` is a permutation of the declared basis, so it
has a reversible implementation `U_step`.  Define diagonal phase operations

```text
O_q       |x> = chi(q(x))             |x>
O_predict |x> = chi(predict(q(x)))    |x>.
```

Then (1) is precisely the basis action

```text
U_step^dagger O_q U_step O_predict^dagger |x>
  = chi(delta(x)) |x>.                              (2)
```

Thus an action residual needs no separately granted residual phase oracle
when the reversible action and both diagonal phase factors are already
executable.  This is a compilation statement, not a gate or query saving:
`O_predict` is load-bearing, and the algebraic Agda module does not construct a
Hilbert-space circuit.

The process meaning is equally exact.  The left side compares actual response
after an intervention with the response predicted from the old observation.
The returned phase is the character image of that intervention residual.

## 3. Exact quotient boundary

The phase does not retain `delta`; it retains its character class.  The checked
iff is

```text
chi(a) = chi(b)    iff    chi(a-b) = +1.             (3)
```

So a phase compilation is faithful on the realized residual image `delta(X)`
exactly when

```text
ker(chi) intersect (delta(X)-delta(X)) = {0}.
```

This is the missing index.  A strict classical refinement can disappear after
postcomposition by a character, and neither classical injectivity nor the
existence of a reversible phase circuit prevents it.

## 4. Decisive no-go: square under successor

R0044 checks over the integers

```text
q(x)       = x^2
step(x)    = x+1
predict(y) = y+1
delta(x)   = 2x,
```

and proves `delta` injective.  But every integer sign character satisfies

```text
chi(2x) = chi(x+x) = chi(x)^2 = +1.                 (4)
```

Therefore the relative phase (2) is the identity on every basis state.  The
formed residual is a complete integer coordinate classically and a completely
dark Boolean phase coordinate quantumly.  This kills the inference

```text
formed classical residual  =>  formed sign-phase sensor.
```

The no-go is stronger than the original `{1,-1}` witness: **every** pair of
integer states collides after sign-phase compilation, while no pair collides
under the additive residual itself.  Both claims are retained side by side in
`faithful-classical-trivial-phase`.

## 5. Changed next move

Before compiling any new residual into phase, the organism must calculate the
kernel test (3) on the *realized residual image*.

- If it separates that image, the relative-phase route (2) is honest.
- If it aliases, retain the additive value register or install a richer,
  explicitly priced character family.
- On an infinite residual image, do not infer exact recovery from a finite
  phase alphabet; state the domain restriction or additional representation.

For the R0044 square/successor event the Boolean route is retired immediately.
The next justified construction is either the already checked additive
residual register or a declared phase family whose joint kernel is proved to
separate the finite chart actually in use.

## 6. Verification and scope

Checked with Agda 2.8.0 and the installed Cubical library:

```sh
agda -i formal/cubical \
  formal/cubical/NaturalMachine/ActionResidualPhase.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
```

Both exit zero.  The aggregate emits its pre-existing unsupported indexed-match
warnings; the new module is root-covered, `--safe`, and has no postulates or
holes.

Exact scope: sign characters into `{+1,-1}`, abelian response groups in the
checked generic theorem, and the integer square/successor instance.  A general
`U(1)` character uses an inverse rather than self-inverse multiplication and is
not formalized here.  Approximate phases, noisy distinguishability, gate
counts, and physical implementation are not claimed.

