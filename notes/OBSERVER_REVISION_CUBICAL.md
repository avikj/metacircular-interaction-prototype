# Observer revision composition: the checked response-valued adapter

`formal/cubical/NaturalMachine/ObserverRevisionComposition.agda` consumes the
finite theorem in `notes/OBSERVER_REVISION_COMPOSITION.md` without importing
its runtime implementation.

## Exact interface

A revision from an old response table

\[
r_0:Q_0\to X_0\to V
\]

to a new one \(r_1:Q_1\to X_1\to V\) consists of the two maps

\[
s:X_1\to X_0,\qquad \tau:Q_0\to Q_1.
\]

`PreservesAt R q x` is the path

\[
r_0(q)(s x)=r_1(\tau q)(x).
\]

`composeRevision` composes the state maps contravariantly and the probe maps
covariantly.  `preservation-composes` is path composition at the retained
middle response.  It assumes neither finiteness nor decidable equality.

The pointwise defect-set inclusion

\[
D_{R_1R_2}(q)\subseteq s_2^{-1}D_{R_1}(q)\cup D_{R_2}(\tau_1q)
\]

is checked as `composite-defect-contained`.  Its constructive statement
exposes the one condition hidden by the note's finite-set prose: equality in
the response type must be decidable.  Decide the first comparison.  If it
fails, the first defect is returned; if it succeeds, any second-stage
preservation path would compose to contradict the alleged composite defect,
so the second defect is returned.

## The killed translation

The module defines an exact three-value response type and the two one-state,
one-probe chains

\[
0\longrightarrow1\longrightarrow0,
\qquad
0\longrightarrow1\longrightarrow2.
\]

Both stages are defective in both chains.  The first composite is preserved;
the second is defective.  `no-stage-defect-decoder` strengthens this from two
examples to a universal no-go:

> There is no function `Bool × Bool → Bool` that reconstructs the composite
> defect flag from the two stage defect flags for all response triples.

Both chains present the same input `(true , true)` to such a decoder and force
the two distinct outputs `false` and `true`.  The unsound translation is thus
not merely inaccurate on a large table: it fails on the smallest response
alphabet capable of mismatch cancellation and persistence.

**ADDITION (seed181, 2026-08-15, `0782`; no text removed).** Two scopings that
the prose above suppresses, both supplied by
`notes/STAGEWISE_DETERMINES_COMPOSITE.md` Thm A/B.

1. The displayed no-go quantifies "for all response triples" **over the
   module's `Response₃`**, not over an arbitrary response type. Read with the
   type universally quantified it is false: for a two-element response type the
   decoder *exists* and is `xor`, since $1_{a\neq c}=1_{a\neq b}+1_{b\neq c}$
   in $\mathbb Z/2$. The checked theorem is correct as checked; only this
   note's rendering of it drops the $V$.
2. "the smallest response alphabet capable of mismatch cancellation and
   persistence" is exactly right and is now a theorem rather than an
   observation: cancellation alone needs only $|V|\ge2$ ($0,1,0$); the two
   together need $|V|\ge3$, and $|V|\ge3$ is necessary **and** sufficient for
   *some* chain over $V$ to defeat the decoder. It is not sufficient for a
   *given* chain to defeat it — a chain whose realized spans miss either cell
   is decodable over any $V$ (Cor B.1). `stage-summary-does-not-determine`
   below is therefore a statement about the realized image of a particular
   pair of chains, which is how its `DeterminesComposite` is already phrased.

The theorem does **not** say that the raw middle value is a mathematically
minimal sufficient representation among every possible encoding.  It proves
only the exact positive adapter using response paths and the impossibility of
the named Boolean scalarization.

## Continuation: the exact criterion for a smaller summary

The follow-up does not guess a preferred replacement for the Boolean ledger.
For any supplied summary

\[
h:V^3\to S,
\]

`DeterminesComposite h` says that the composite-defect target factors through
the **realized image** of \(h\).  `summary-kernel-criterion` reuses
`NaturalMachine.FiniteInformation` to identify this type with the exact fiber
condition

\[
h(a,b,c)=h(a',b',c')\Longrightarrow
[a\ne c]=[a'\ne c'].
\]

Here the displayed brackets denote the checked Boolean flag on the explicit
three-value control.  The image formulation matters: a decoder is required
only on summaries that actually occur, so no default value or choice is
smuggled in for unreachable points of \(S\).

`stage-summary-does-not-determine` now refutes even this weaker realized-image
decoder for the pair of stage flags.  `full-span-determines` is the positive
control: retaining `(a,b,c)` satisfies the criterion.  Thus every proposed
smaller carrier has a precise next obligation—prove constancy of the composite
target on its fibers—and no claim of raw-span minimality is needed.

## Rigor boundary

- Machine-checked in Cubical Agda with `--safe`, no postulates and no holes:
  revision composition, preservation composition, decidable pointwise defect
  containment, both finite controls, the universal Boolean-decoder no-go, and
  the realized-image/fiber criterion for arbitrary supplied summaries.
- No finiteness hypothesis is needed by the checked positive theorem.  The
  finite source theorem supplies decidable equality; the adapter records that
  dependency explicitly.
- No novelty or general observer-formation claim is made.  The revision maps
  and response tables are supplied; the module neither invents nor judges a
  replacement observer.
