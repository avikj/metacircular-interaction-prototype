# A compiled residual changes the next bounded action language

On `Q^3`, let `P` project to `e0`, let `A` map both `e0,e1` to `e1`, and
let `D` map `e1` to `e2`. Give primitive occurrences unit cost and initially
allow the generators `{P,A,D}`.

The first leakage is `R1=(I-P)AP=AP`. Its rank-one factorization supplies the
certified macro `M1=PAP+R1=AP`, installed at unit invocation cost. At budget
two, `DM1=DAP` is now denotable. Before installation the same operator requires
the primitive word `DAP`, of cost three, and is absent from the budget-two
language. Moreover

`(I-P) D M1 = D A P != 0`,

so this newly reachable action is exactly the next residual; applying the same
QAP compiler installs a second rank-one macro. The chain then stops because
`D^2AP=0`.

This is the requested five-arrow motion in one finite object:

`factor through P -> residual R1 -> im(R1) -> install M1 -> recompute`

and recomputation changes which problem is next reachable. It is deliberately
task-relative: macros do not enlarge the unbounded extensional algebra, since
each unfolds to a primitive word. They strictly enlarge a declared
cost-bounded action language. Therefore any claim that a definitionally
eliminable macro creates a new extensional operator is false; the exact gain is
shortening, and shortening changes future generation under finite resources.
The cost record prices every primitive or installed-head invocation at one;
the certificate retains the unfolded word and exact matrices as provenance.
At budget one the next action remains unreachable, and a zero residual merely
reproduces its input operator, so neither condition spuriously generates.

Replay: `python3 -m unittest machinery.test_residual_language_growth -v`.
