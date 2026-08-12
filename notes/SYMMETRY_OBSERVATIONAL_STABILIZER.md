# The observational stabilizer of an executable symmetry action

## The checked object

For a type `X`, observation `O:X→N`, and equivalence `e:X≃X`, define

\[
e\in\operatorname{Stab}(O) \quad\Longleftrightarrow\quad O\circ e=O.
\]

`NaturalMachine.SymmetryArithmeticAction` now checks:

1. the identity lies in `Stab(O)`;
2. if `e,f` lie in `Stab(O)`, then `e∘f` lies in `Stab(O)` under the
   standalone-checked `compEquiv` action order;
3. if `e` lies in `Stab(O)`, then `e⁻¹` lies in `Stab(O)`.

Thus the observation-preserving symmetries form a subgroup predicate inside
the full automorphism group. This is the exact action-level object that the
scalar `|Aut(Fin n)|=n!` cannot recover.

The module also defines observational equivalence

\[
e\sim_O f \quad\Longleftrightarrow\quad O\circ e=O\circ f
\]

and checks reflexivity, symmetry, and transitivity. This is a proof-relevant
kernel/fiber presentation of the desired quotient relation. No coset or HIT
quotient carrier is claimed: that construction is not needed by the current
consumer and would require additional interface choices.

## Strict arithmetic separation

For the already checked `successorRegister(n)=n+1`, identity is in the
stabilizer. The checked `swap01-Equiv` is not: evaluation at zero gives

\[
(successorRegister\circ swap01)(0)=2\ne1=successorRegister(0).
\]

Therefore the consumer sees at least two classes inside the same automorphism
carrier. The factorial count is not merely inconvenient; it provably does not
factor the observation response.

## Cross-review correction

The corrected standalone action law was retained. During a full rebuild, the
review also exposed that `SymmetryCardinality.agda` used `isFinSetAut` without
importing `Cubical.Data.FinSet.Constructors`; cached/transitive state had masked
the missing dependency. The explicit import is now present.

## Rigor boundary

All results in this note are checked by Cubical Agda through `formal/check.sh`.
There is no Python evidence or dependency. The subgroup is supplied as a
closed predicate, not packaged as a `Group` value, and the equivalence relation
is not materialized as a quotient type. No novelty claim is made.
