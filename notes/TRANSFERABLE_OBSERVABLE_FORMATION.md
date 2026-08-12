# Transferable observable formation versus lookup memorization

Let `X` be a finite state space, `S subset X` the states used to form an
observable, `Y` its response set, and `O subset Y^X` a **declared in advance**
class of admissible observables. This class may encode arithmetic laws,
equivariance, compositional contexts, degree bounds, or another independently
checkable structural constraint.

## Exact criterion

Call the formation **transferable relative to `O`** precisely when restriction

\[
\rho_S:O\longrightarrow Y^S,\qquad q\mapsto q|_S                 \tag{1}
\]

is injective. Equivalently, every admissible observable fitting the formation
record makes the same prediction on every unseen state. A **lookup collision**
is a pair `q != q'` in `O` with `q|_S=q'|_S`; one held-out state where they
differ is an exact nontransfer certificate.

This is the smallest criterion because no statement about the observed values
alone can distinguish the two cases: the same table on `S` occurs whether its
fiber under (1) has size one or larger. Transfer is always relative to a
structure declared independently of the fitted labels. Choosing `O` after
seeing the answer can make any lookup table unique and proves nothing.

## Equivariant generation theorem

Suppose a monoid `M` acts on `X` and `Y`, and `O` is the class of equivariant
maps, `q(mx)=m q(x)`. If the orbit closure `M S` equals `X`, then (1) is
injective on `O`.

**Proof.** For `x in X`, write `x=ms` with `s in S`. Every equivariant `q`
satisfies `q(x)=m q(s)`. Thus its values on `S` determine every value on `X`.
`square`

The converse needs hypotheses on the output action, but failure can already be
sharp. Let `X={0,1,2,3}` with a generator swapping `0<->1` and `2<->3`, let
`S={0}`, and let the action on `Y={0,1}` be trivial. The two equivariant maps
`0000` and `0011` agree on `S` and differ on the unseen orbit. Hence a program
can be perfectly lawful on every observed transition and still merely choose
an arbitrary table on an ungenerated component.

## Arithmetic interpretation and boundary

Successful collision-separating arithmetic programs earn transfer only when
their observable is forced by a declared generative structure whose closure
reaches the target domain. Passing a finite list of residues, prefixes, or
factor cases is not enough: the executable check must either certify injective
restriction in the admitted class or emit two lawful candidates and a held-out
collision.

`machinery/transferable_observable.py` implements exactly those finite checks:
restriction collisions, orbit closure, and paired-generator equivariance. It
does not infer the admissible class, certify that a chosen action is natural,
or turn empirical success into a theorem. The criterion detects lookup freedom;
it does not by itself discover a useful observable.
