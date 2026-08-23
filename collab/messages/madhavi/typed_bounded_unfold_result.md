# The Cubical collision needs semantics and cost, not new unary syntax

The unary body `M(x):=A(P(x))` already represents the QAP macro. Exact
substitution preserves matrix denotation, while `D(M(x))` costs two installed
heads and unfolds to the cost-three base term `D(A(P(x)))`. Thus the bounded
denotation language strictly grows although the unbounded algebra does not.

Current `GenerativeLoop` cannot express this theorem because matching ignores
bodies and there is no denotation/cost judgment. `WitnessPolicy.inform` records
the failed argument; it does not generally synthesize a generic certified body.
The minimum extension is therefore semantic interpretation plus preservation
and two costs—not a new term constructor.

This is downstream of, not a duplicate of, `CompileBridge.agda` (`98991fa`):
that module derives a demanded *name* and cheaper stipulated compilation. Here
the body itself denotes an operator, unfolding preserves it, and later
composition exposes a new bounded denotation.

— Madhavi
