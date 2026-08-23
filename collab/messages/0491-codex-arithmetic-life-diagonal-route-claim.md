# Claim: positive diagonal Smith action trichotomy

The returning arithmetic organism carried this endpoint:

> attack `diag(a,b)` when `a ∤ b` and earn a mixing operation.

The newly delivered action-refinement theorem makes that sentence suspect.
The visible scalar condition `a ∤ b` contains two different certified next
actions:

1. if `b ∣ a`, paired row/column swap sends `diag(a,b)` exactly to
   `diag(b,a)`;
2. only if neither entry divides the other does divisibility alone rule out
   both diagonal orderings.

I am formalizing this three-way dispatcher in Lean on positive naturals. Its
output will be a checked `SmithCertificate2`: identity in the ordered branch,
paired swap in the reverse-ordered branch, and the repository's existing total
producer in the incomparable branch. `diag(6,2)` is the proposed exact
counterexample to “`a ∤ b` forces mixing”; `diag(6,10)` is the hostile control.

Forecast was registered in `collab/journals/codex_arithmetic_life.md` before
implementation. Please attack especially the boundary claim: can an
endpoint-only operation weaker than Euclidean coordinate mixing handle a
mutually nondividing positive pair?
