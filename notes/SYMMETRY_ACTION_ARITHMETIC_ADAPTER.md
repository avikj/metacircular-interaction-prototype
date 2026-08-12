# A symmetry path acts on arithmetic registers; its factorial count does not

## Exact interface

For a permutation `e : Fin(n) ≃ Fin(n)` and register assignment
`r : Fin(n) → N`, define

\[
(e\cdot r)(i)=r(e(i)).
\]

~~Then `(ef)·r=f·(e·r)` under the repository's `e after f` convention.~~
**Clean-source correction (2026-08-12, codex_cubical_ingestor):** Cubical's
`compEquiv e f` has underlying function `f ∘ e`, and precomposition is
contravariant, so the checked law is `(ef)·r=e·(f·r)`. The former order was
masked by the two-port witness because `S₂` is abelian. For a
Cubical loop `p : Fin(n) ≡ Fin(n)`, use `pathToEquiv(p)` as `e`.
`formal/cubical/NaturalMachine/SymmetryArithmeticAction.agda` checks the
action law, its compatibility with path composition, the distinction between
a fixed named port and a transported port, and transported-port invariance.
This consumes the
permutation carried by the loop; `symmetryCount n = n!` cannot define the
action because it contains neither an element nor its multiplication.

## Smallest arithmetic witness

Take two fixed ports, registers `r=(1,2)`, weights `w=(1,2)`, and

\[
E_w(r)=r_0+2r_1\pmod 5.
\]

The identity symmetry gives `1+2·2=0 mod 5`.  The swap gives the precomposed
registers `(2,1)` and therefore `2+2·1=4 mod 5`.  Both transformations belong
to the same two-element symmetry carrier counted by `2!`.  A controller given
only that count cannot predict which residue executes.

This is minimal: `n=0,1` have only the identity permutation, while `n=2` has
the first nonidentity action.  Modulus five is inherited from
`CLOSED_ARITHMETIC_RESPONSE_FAMILY`; no claim is made that five is the least
modulus for any symmetry-sensitive evaluator.

## Prasaṅga: intervention versus relabeling

The effect is not intrinsic to renaming. If the coefficient field and
registers both move covariantly by precomposition, their pointwise product
merely relabels:

\[
(e\cdot w)_i(e\cdot r)_i=(e\cdot(wr))_i.
\]

Any permutation-invariant aggregator, in particular finite summation, thus
gives `E_(e·w)(e·r)=E_w(r)`. The swap control checks this: both identity and
swap return zero after the weights are transported. A three-cycle regression
catches the wrong inverse-precomposition convention, which a self-inverse
swap masks. Thus a path changes executable behavior exactly
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

The Cubical action, composition law, fixed/transported-port policies,
transported-port invariance, and pointwise covariance square are
machine-checked. A fresh `--ignore-interfaces` replay exposed that the first
landing had used `pathToEquiv` without importing it into this module; the
explicit `Cubical.Foundations.Univalence` import is now present. Cached
interfaces must not be treated as a source-completeness check. The same clean
walk found `SymmetryCardinality` lacked its explicit `FinSet.Constructors`
import for `isFinSetAut`; that dependency is now explicit too. The mod-five
witness and covariance control are exact finite arithmetic, replayed by:

```text
agda --ignore-interfaces -i formal/cubical formal/cubical/NaturalMachine/SymmetryArithmeticAction.agda
python3 machinery/test_symmetry_arithmetic_action.py -v
```

This is not a theorem that every permutation matters to every arithmetic
program. Symmetric evaluators and covariantly transported interfaces erase the
action, as the control demonstrates. No novelty claim is made.
