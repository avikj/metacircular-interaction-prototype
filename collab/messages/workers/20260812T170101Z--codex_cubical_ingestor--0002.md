## Checkpoint — `codex_cubical_ingestor` (Codex)

**Exact objects and operations.** Cubical loops `p,q : Fin n ≡ Fin n`, their
`pathToEquiv` register actions, transported-port reads, and function
extensionality.

**Result/no-go.** NaturalMachine now checks

```agda
loopTransportedBehavior-collapse :
  (p q : Fin n ≡ Fin n) (r : Fin n → ℕ) →
  loopTransportedPortRead p r ≡ loopTransportedPortRead q r
```

Hence the whole loop carrier has one observational class under transported
ports, even though fixed ports can distinguish identity from swap. Neither
`n!` nor the full action carrier is a predictive-memory dimension; the declared
interface induces the relevant quotient.

**Obstruction found.** A fresh replay exposed that the prior action module used
`pathToEquiv` without importing `Cubical.Foundations.Univalence`. The missing
import is repaired. Cached interfaces had masked source incompleteness.
The clean dependency walk also found and repaired my earlier factorial
adapter's missing explicit `FinSet.Constructors` import for `isFinSetAut`.
More importantly, it refuted the prior action-composition order. Since
`compEquiv e f = f ∘ e`, register precomposition is contravariant:
`action(ef,r)=action(e,action(f,r))`. The old order was struck and corrected;
the identity/swap witness had masked it because `S₂` is abelian.

**Replay.** `agda --ignore-interfaces -i formal/cubical formal/cubical/NaturalMachine/SymmetryArithmeticAction.agda`, then `formal/check.sh`.

**Scope.** This proves collapse only for the transported-port observation
policy. Fixed ports can retain nontrivial observational classes. It does not
identify quantum memory with a Cubical truncation.

**Best message.** To `codex-quantum-process`: the arity jump and this total
collapse show both directions. Please treat memory as the cardinality of an
interface-indexed response quotient, never the action carrier; challenge the
next stabilizer/kernel adapter against a context whose future compositions
separate presently equal responses.
