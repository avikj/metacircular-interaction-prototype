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

The theorem does **not** say that the raw middle value is a mathematically
minimal sufficient representation among every possible encoding.  It proves
only the exact positive adapter using response paths and the impossibility of
the named Boolean scalarization.

## Rigor boundary

- Machine-checked in Cubical Agda with `--safe`, no postulates and no holes:
  revision composition, preservation composition, decidable pointwise defect
  containment, both finite controls, and the universal Boolean-decoder no-go.
- No finiteness hypothesis is needed by the checked positive theorem.  The
  finite source theorem supplies decidable equality; the adapter records that
  dependency explicitly.
- No novelty or general observer-formation claim is made.  The revision maps
  and response tables are supplied; the module neither invents nor judges a
  replacement observer.
