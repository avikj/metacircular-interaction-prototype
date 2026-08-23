# A symmetry path acts on arithmetic registers; its factorial count does not

## Exact interface

For a permutation `e : Fin(n) ≃ Fin(n)` and register assignment
`r : Fin(n) → N`, define

\[
(e\cdot r)(i)=r(e(i)).
\]

~~Then `(ef)·r=f·(e·r)` under the repository's `e after f` convention.~~
**Correction (2026-08-12, standalone Agda recheck):** `compEquiv e f` has
underlying map `f ∘ e`, while register action is precomposition, hence

\[
((e;f)\cdot r)=e\cdot(f\cdot r).
\]

The former order was hidden by the self-inverse two-port swap and by a stale
incremental interface.  The corrected statement is now checked from source by
the standalone command below.  For a
Cubical loop `p : Fin(n) ≡ Fin(n)`, use `pathToEquiv(p)` as `e`.
`formal/cubical/NaturalMachine/SymmetryArithmeticAction.agda` checks the
action law, its compatibility with path composition, the distinction between
a fixed named port and a transported port, and transported-port invariance.
This consumes the
permutation carried by the loop; `symmetryCount n = n!` cannot define the
action because it contains neither an element nor its multiplication.

## Smallest checked executable witness

No Python witness is needed.  Inside the same safe Cubical Agda module, let
`successorRegister n = suc n` and use the already checked nonidentity
automorphism `swap01-Equiv` of `ℕ`.  Normalization proves:

```agda
identity-fixed-value : actObservation (idEquiv ℕ) successorRegister zero ≡ 1
swap-fixed-value : actObservation swap01-Equiv successorRegister zero ≡ 2
swap-transported-value :
  transportObservation swap01-Equiv successorRegister zero ≡ 1
```

Thus the fixed observation distinguishes identity from swap, while transporting
the observation point makes the same swap observationally trivial.  The
theorem terms both prove and execute the witness under the Agda kernel.

## Prasaṅga: intervention versus relabeling

The effect is not intrinsic to renaming. If the coefficient field and
registers both move covariantly by precomposition, their pointwise product
merely relabels:

\[
(e\cdot w)_i(e\cdot r)_i=(e\cdot(wr))_i.
\]

Any permutation-invariant aggregator, in particular finite summation, thus
gives `E_(e·w)(e·r)=E_w(r)`.  The generic theorem
`transportObservation-invariant` proves the transported-observation branch for
every equivalence, so it is not an accident of an involutive swap.  Thus a path
changes executable behavior exactly
when the arithmetic interface fixes externally meaningful ports while the
permutation moves their contents.  If the whole interface is transported,
the path is a presentation change and must not be advertised as a new
arithmetic outcome.

## Consequence for the cardinality adapter

`SymmetryCardinality.agda` is a valid compiler for the question "how many
loops?"  It is insufficient for "what does this loop execute?"  No new
Cubical library import is earned: the existing `pathToEquiv` and checked
composition theorem already supply the necessary action.  The earned addition
is the explicit consumer map from a loop to register precomposition.

## Rigor boundary and replay

### Formal no-go: action carrier is not predictive memory

The arity-indexed memory obstruction (`ARITY_QUANTUM_MEMORY_NO_GO`) changes
the interpretation of this adapter. A larger action language can split a
predictive quotient arbitrarily, but the existence or cardinality of actions
does not determine that quotient. The local counter-direction is now checked:

```agda
loopTransportedBehavior-collapse :
  (p q : Fin n ≡ Fin n) (r : Fin n → ℕ) →
  loopTransportedPortRead p r ≡ loopTransportedPortRead q r
```

Thus every two loops, including distinct ones, have the same complete
pointwise response under the transported-port policy. Under fixed ports the
identity/swap witness separates responses; under transported ports the whole
loop carrier has one observational class. Consequently neither `n!` nor the
full permutation action is a predictive-memory dimension. Memory requires
the quotient induced by the declared ports and continuations.

This is a strict strengthening of `FORMAL_INGESTION_FEEDBACK_LOOP.md`, which
correctly classified the fixed/covariant interface but explicitly left the
local action adapter pending. Cross-review found one convention hazard before
landing: inverse-precomposing coefficients happens to work for the order-two
swap and fails for longer cycles. The clean-source replay found a second:
the action-composition theorem itself had reversed `compEquiv` order. The
correct contravariant law is now checked; same-map precomposition remains the
checked covariance law under the definitions above.

The Cubical action, corrected composition law, fixed/transported-port policies,
transported-port invariance, and pointwise covariance square are
machine-checked.  The same Agda module now contains a fully internal
normalizing witness: the checked `swap01-Equiv` moves the fixed observation at
zero from value `1` to value `2`, while transporting the observation point
returns value `1`.  It requires no Python. Replay the load-bearing result by:

```text
agda -i formal/cubical formal/cubical/NaturalMachine/SymmetryArithmeticAction.agda
```

The former Python mod-five implementation and its unit tests were removed as
redundant.  They supplied no theorem or executable outcome absent from the Agda
module.

This is not a theorem that every permutation matters to every arithmetic
program. Symmetric evaluators and covariantly transported interfaces erase the
action, as the control demonstrates. No novelty claim is made.
