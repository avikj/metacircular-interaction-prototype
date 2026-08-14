# Conservative sensor repair cannot absorb an absent outcome

**Status:** exact finite no-go. It identifies the first boundary of a
Fussenegger-inspired closed loop; it does not implement autonomous sensor
formation.

## 1. The square

Let an old deterministic observer contain a probe

\[
q:X\to Y.
\]

A state-refining revision consists of a new state set `X'`, a projection
\(\pi:X'\to X\), and a translated old probe \(q':X'\to Y\). Exact preservation
in the current observer-revision ledger is the commuting square

\[
q'=q\circ\pi.                                           \tag{1}
\]

An outcome \(y_*\in Y\) is out of model for this probe when
\(y_*\notin q(X)\).

## 2. No-go theorem

**Theorem 2.1 (conservative absorption no-go).** If (1) holds, then

\[
q'(X')\subseteq q(X).
\]

Consequently no revised state can realize an outcome absent from the old
probe image.

**Proof.** For every \(x'\in X'\), equation (1) gives
\(q'(x')=q(\pi(x'))\in q(X)\). ∎

**Corollary 2.2.** Adding arbitrarily many new probes cannot repair the old
probe square. If a new state realizes \(y_*\notin q(X)\), the revision must do
at least one of the following:

1. change the old probe's codomain or response semantics;
2. drop preservation of that probe;
3. abandon projection of the new state to an old state;
4. retain the anomaly at a meta-level rather than claim it is an old-probe
   outcome inside the revised object model.

This is an exhaustive logical fork for the declared square, not an exhaustive
catalogue of all model-revision formalisms.

## 3. The prosthetic-loop boundary

The desired circuit is

```text
encounter -> formation pressure -> sensor -> response -> changed encounter.
```

Theorem 2.1 says this circuit cannot close through a *fully conservative state
refinement* after an absent outcome. The pressure is evidence that the old
interface itself must change. A new sensor may distinguish newly introduced
states, but it does not retroactively make the contradicted old response square
commute.

This is mathematically analogous to the placement constraint in a prosthetic
network: a response expressed in the host medium changes subsequent inputs.
Here that change has a precise cost—at least one old interface is revised or
relocated to a meta-level. Preservation of every old capability is therefore
too strong if "capability" includes unchanged response semantics for the probe
that produced the pressure.

## 4. Executable certificate

`formal/cubical/NaturalMachine/ProstheticImageAdapter.agda` checks the theorem
constructively against the repository's existing `AtomicSatisfaction`
response-square interface.  For each probe it maps
`Cubical.Functions.Image (r' q)` into `Image (r q)` by mapping the
propositionally truncated fiber witness; no representative is chosen and no
finiteness or decidable equality is used.  `map-restrict` checks the action on
every concrete revised state.

The changed-codomain adapter lands in the image of the declared comparison
`j ∘ r`.  Thus changing the response type alone does not admit a novel
outcome if the comparison square is still required on every new state:
`outside-comparison→no-square` proves that an outcome outside this comparison
image refutes total preservation.  A Bool control distinguishes conservative
state splitting from a new `true` response and derives
`novel-square-impossible`.

`InheritedResponseImage` supplies the exact constructive fork.  It takes an
explicit predicate `Inherited : X' → Type` and requires the comparison square
only on the subtype `Σ x', Inherited x'`; the same checked image transport is
then recovered on precisely that subtype.  In the Bool control only `false` is
inherited.  `localized-false-computes` checks preservation there, while the
full revised `true` state still realizes the novel response and
`true-absent-from-inherited-image` proves it was not silently imported into
the inherited image.  Localization is thus a restriction of the law's
quantifier, not an exception hidden inside a total square.

Once a global state translation `s : X' → X` and comparison `j` are declared,
`MaximalCompatibleResponseImage` removes one remaining arbitrary choice.  It
defines

`Compatible x' = (q : Q) → r' q x' ≡ j q (r q (s x'))`

and checks the localized square and image transport on that subtype.
`inheritance→compatible` proves the universal property: every other inherited
predicate satisfying the same square with the same `s` and `j` maps into
`Compatible`.  Thus this is the maximal lawful inherited domain relative to
the declared translation.  The Bool control proves `false-is-compatible` and
`true-is-incompatible`.  The remaining formation boundary is now precise:
the response law determines the maximal domain only *after* `s` and `j` have
been supplied; it cannot justify those translation choices itself.

The historical finite checker below was the original falsifier.  The Cubical
module is now the load-bearing certificate.

`machinery/prosthetic_sensor_no_go.py` checks response-square defects and
detects outputs outside an old image. Four tests cover conservative state
splitting, forced failure under a new outcome, irrelevance of merely adding a
sensor, and fail-closed incomplete revisions.

The executable is not a proof by enumeration; it instantiates the one-line
image-containment theorem on proposed finite revisions.

## 5. Rigor boundary and successor

Proved: Theorem 2.1 and Corollary 2.2 under the stated deterministic total-map
model.

Not proved: a no-go for partial, stochastic, relational, typed-codomain, or
open-system observers; a canonical way to form the revised interface; or
autopoiesis. Formation remains externally proposed and checked.

The smallest constructive successor is a typed **interface-change square**
where the old and new codomains differ and a declared comparison
\(j:Y\to Y'\) replaces (1) by \(q'=j\circ q\circ\pi\) only on inherited states.
New states then lie outside the inherited-state comparison square, and the
revision ledger must say exactly which old conclusions transport.
