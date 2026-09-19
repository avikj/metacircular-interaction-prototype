# Action, Logic, and Optimal Inference

Pratt's 1980 PDL result is a concrete optimality landmark: semantic tableaux/Hintikka structures give deterministic exponential reasoning about action, matching the Fischerâ“Ladner lower bound up to polynomial factors. PDL treats programs as modalities over a relational state semantics; Pratt's later Action Logic pushes further by erasing the assertion/program divide and evaluating action over intervals.

The dependent completion retains executions rather than their truth-valued existence alone. Replace a proof-irrelevant transition predicate by `R_Î(s,t) : U`. Sequential composition is the dependent sum over the intermediate state; box and diamond become dependent product and sum over execution witnesses. The ordinary PDL semantics is recovered by the corresponding truncation/restriction.

Fischerâ“Ladner closure then becomes a particular observation of the complete semantic object. Its Hintikka state is a finite visible coordinate. By [the Fibre Law](02-fibre-law.md), the complete object decomposes into that visible coordinate plus its forced fibre. By exact descent, a proposed observation is decision-sufficient exactly when satisfaction is constant on every observation fibre. This characterizes sufficiency independently of the particular tableau representation.

Pratt's realizability pruning is naturally compared with the finite shadow of productive interaction: a state survives exactly when its required continuations can continue. The ISC retains that continuation directly rather than terminating at a local truth assignment; see [The Interactive Symbolic Computer](10-interactive-symbolic-computer.md).

Optimality must remain distinct from semantic losslessness. An equivalence can require positive work to execute. The project therefore equips native interaction with its own step metric and proves exact geodesics from locality in concrete carriers. Pratt's near-optimal reasoning supplies the classical patternâ”lower bound plus construction near itâ”while interaction geodesicity asks for the lower bound induced by the dependency geometry itself and an evolution attaining it.

The internal finding/checking result belongs here too. On the lossless universal step, deciding and verifying are opposite projections of one equivalence; this is a theorem internal to that complete machine object, not by itself a claim about external succinct-encoding complexity classes.

## Canonical checked construction

Lossless decision/verification: [`VerifyIsDecide...agda`](../../formal/cubical/theorems/residue/VerifyIsDecide_ThereIsNoGapBetweenFindingAndCheckingBecauseBothAreProjectionsOfOneEquivalence.agda). Observation/descent: [`ObsBridge.agda`](../../formal/cubical/theorems/logic/ObsBridge.agda). Geodesic ledger: [`PNP_GEODESIC_REDUCTION_20260916.md`](../../research/PNP_GEODESIC_REDUCTION_20260916.md).

## External coordinates

[Vaughan Pratt, âA near-optimal method for reasoning about actionâ](https://doi.org/10.1016/0022-0000(80)90061-6), [Propositional Dynamic Logic](https://plato.stanford.edu/entries/logic-dynamic/), [Kleene algebra with tests](https://en.wikipedia.org/wiki/Kleene_algebra#Kleene_algebra_with_tests).
