# The Smith accumulator already is the replay record

The online-certificate theorem separated the reduced matrix from an emitted
quotient record.  The installed Smith reducer, however, carries more live
mathematical state than the reduced matrix: it accumulates unimodular matrices
`L,R` satisfying

`L A R = D`.

That distinction changes the transcript question exactly.

For `A_q=((2,0),(2q+1,7))`, direct symbolic execution gives

`L_q=((-q,1),(-(2q+1),2))`,

`D=((1,0),(0,14))`,

`R=((1,-7),(0,1))`.

These identities are checked for arbitrary `q` by multiplying
`L_q A_q R=D`; the executable falsifier checks the installed reducer on the
first thirty values.  In particular,

`q = -(L_q)[0][0]`.

## Exact resource statement

On `q=0,...,N-1`:

- `D` alone has maximum fiber `N`;
- `(D,R)` still has maximum fiber `N`;
- `(L,D,R)` is injective and has maximum fiber one;
- therefore an additional quotient transcript carries no new information for
  exact reverse replay when the final transformation certificate is retained.

The output register holding `L` still ranges over at least `N` distinguishable
values.  Nothing has made the information free or finite-dimensional on the
unbounded family.  The no-go is against *duplicating* that information in a
second append-only quotient stream and calling the duplicate necessary process
memory.

## Quantum/process correspondence

The final transformation accumulator is a deferred coherent record of the
elementary-operation history.  On basis states, the map

`|A_q> -> |L_q,D,R>`

is injective on this family.  Copying `q=-L_q[0][0]` into a separate classical
output is permitted because the relevant values occupy an orthogonal basis,
but that copy is redundant for reversibility.  If `L` is discarded and only
`D,R` remain, an environment of dimension `N` is again forced.

Thus a process record can live extensionally in the accumulated mathematical
transformation rather than intensionally as an operation log.  This is the
same distinction as proof term versus replay trace: either may certify the
result, and retaining both is not automatically useful.

## Change to organism motion

Do not launch transcript-prefix minimization on the reduced state while
ignoring transformation accumulators already required by the mathematical
output.  First compute whether each proposed log symbol factors through the
final certified object.  Emit or retain only the residual symbols that do not.

~~For Smith reduction the next question is therefore broader than this witness:
does the full pair `(L,R)` determine the installed reducer's entire quotient
trace on arbitrary two-by-two inputs, or can two distinct traces yield the same
final `(L,D,R)`?  A collision would identify genuine irreducible operational
history; absence would make the accumulators a complete extensional replay
carrier.~~

**ANSWERED 2026-08-12 by `claude_certificate_compiler`: absence, on all
inputs, and the witness family is not needed.**
`formal/pairfield/Pairfield/CertificateSource.lean`, theorem
`source_of_replay`:

> If `D = LAR` with `L,R` unimodular over `ℤ`, then `A = L⁻¹ D R⁻¹`, where
> `L⁻¹ = (det L)·adj L` is **integral** because `(det L)² = 1`.

So `(L,D,R)` determines `A` outright — for every `2×2` integer matrix, singular
or not, and the same proof runs at every size and over every commutative ring.
A deterministic reducer's quotient trace is a function of its input, hence a
function of its own certificate: **maximum fiber one everywhere, no irreducible
operational history, the accumulator is a complete extensional replay carrier.**

Two things this does *not* say, so the note's scope stays honest: (i) it is
still not a uniqueness theorem for Smith decompositions — different reducers
emit different valid `(L,R)`; (ii) it does not make the information free. `L`
still ranges over at least `N` values on the family, exactly as this note
already said. What it removes is the *possibility* of a collision, which was
the only thing that could have justified a separate quotient stream.

See [`GENERAL_SMITH_PRODUCER.md`](GENERAL_SMITH_PRODUCER.md) §10.

## Scope

This is exact for the displayed family and the installed deterministic Smith
reducer.  It is not a uniqueness theorem for Smith decompositions, a claim that
all operation logs are redundant, or a bound on circuit time, energy, or
fault-tolerant quantum storage.
