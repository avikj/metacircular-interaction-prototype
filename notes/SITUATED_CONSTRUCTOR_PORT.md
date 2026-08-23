# A live relation selects a constructor and changes the future grammar

**Status:** exact smallest finite theorem and executable integration.

`INVARIANT_SCHEMA_COUPLING.md` proved that complete source, target, invariant,
and descent data need not select a constructor.  The missing coordinate was a
target-stabilizer torsor.  This note supplies the smallest positive continuation:
an environmental port does not abolish that torsor or manufacture a canonical
choice.  It temporarily trivializes the torsor by adding a real relation, and
the selected path changes which actions exist afterward.

This is one organ of the larger program, not its center.  The exact example is
small enough to show where inherited language, learned proposal geometry,
environmental or human coupling, proof memory, task-relative forgetting, and
future value enter without identifying them.

## 1. The two lawful constructors

Let `X={0,1,2}`.  Name source `s=0`, target `t=1`, and the remaining context
point `c=2`.  The transporter

\[
T(s,t)=\{g\in S_3:g(s)=t\}
\]

has exactly two elements:

\[
\tau=(0\ 1),\qquad \rho=(0\ 1\ 2).
\]

Both perform the declared endpoint task `0 -> 1`.  Exact endpoint data cannot
prefer one.  The target stabilizer

\[
H=\operatorname{Stab}_{S_3}(1)=\{1,(0\ 2)\}
\]

acts freely and transitively on `T(s,t)` by left multiplication.  Thus the
two constructors are an `H`-torsor.  An `H`-invariant selector would be a fixed
point of this free action and cannot exist.

Three points are minimal.  For two distinct points in a two-point set,
`T(s,t)` has one element.  At three points it has `(3-1)!=2` elements.

## 2. The port is a relation, not a hidden canonical rule

Expose the live port

\[
p_g(c)=g(c).
\]

On the transporter,

\[
p_\tau(2)=2,\qquad p_\rho(2)=0.
\]

Therefore evaluation at the context point is a bijection

\[
\operatorname{ev}_2:T(0,1)\overset{\sim}{\longrightarrow}\{0,2\}.
\tag{1}
\]

If the environment supplies response `r`, the equations

\[
g(0)=1,\qquad g(2)=r
\tag{2}
\]

select exactly one constructor.  This selection is equivariant, not absolute:
for `h in H`,

\[
\operatorname{ev}_2(hg)=h\operatorname{ev}_2(g).
\]

Transforming the environmental response transforms the selected constructor.
Withdrawing the response leaves the original torsor.  Thus the port does not
prove that one path was always canonical; it makes one path determinate in the
present coupled situation.

The Sanskrit word **sambandha** can help attention here: relation or connection
is not metadata appended to two self-sufficient objects.  The equations in (2)
literally define the situated operation.  This use is a contemporary
translation aid, not a claim that a Sanskrit intellectual lineage asserted
this group-action theorem.  A fuller historical bridge would have to engage
native theories of relation and action on their own arguments.

## 3. Selection changes subsequent mathematics

Install the selected constructor as a reusable primitive.  Its generated
action grammar is

\[
\langle\tau\rangle=\{1,\tau\},\qquad
\langle\rho\rangle=\{1,\rho,\rho^2\}.
\]

The first has order two and source trace

\[
0,1,0,1,\ldots;
\]

the second has order three and source trace

\[
0,1,2,0,1,2,\ldots.
\]

Hence the coupling did not merely choose two spellings of the same future
operation.  It formed different future action languages.  A later query after
two applications separates them:

\[
\tau^2(0)=0,\qquad \rho^2(0)=2.
\tag{3}
\]

This closes the missing implication in the earlier transporter no-go for this
finite witness:

\[
\text{live port}
\to \text{unique certified path}
\to \text{installed primitive}
\to \text{changed future experiments}.
\]

No step says that every environmental coupling deserves installation.  It
says that if installation occurs, the port is part of the causal derivation of
the resulting capability.

## 4. The several layers, kept exact

### Inherited mathematical culture

The carrier labels, the presentation of `S_3`, composition, and the decision
to regard permutations as available constructors are inherited language.
They make the experiment expressible.  The endpoint invariant cannot regenerate
that inheritance.  Provenance should therefore retain the presentation rather
than retelling it as spontaneous formation.

### Learned proposal geometry

A neural or other continuous model may attach scores `q(g)` to the two
constructors and order the search by a softmax.  These scores compress previous
encounters and can make proposal cheap.  They do not certify (2).  In the
executable, even a score difference of two thousand in favor of the wrong
constructor cannot override the exact port equation.

If an allegedly symmetry-free model scores the two torsor points differently
before receiving the port, the asymmetry came from its parameters, training
history, coordinate convention, or noise.  That may be useful inherited
attention, but it is not a canonical consequence of the endpoint invariant.

### Exact resistance and proof memory

The certificate stores the source, target, context, response, provenance, the
lawful transporter, and the uniquely matching constructor.  Replay recomputes
(2).  The proof is the stabilized ability to recover why this primitive entered
the grammar, not merely the selected permutation.

### Task-relative forgetting

For the one-use workload “send `0` to `1`,” the quotient

\[
T(0,1)\longrightarrow\{1\}
\]

is sufficient: both constructors answer identically.  For the continuation
workload admitting repeated use, the same quotient is unsound by (3).
Forgetting the port can therefore be correct for an endpoint call while being
incorrect for developmental state.  There is one causal map with different
sufficient quotients, not a universal command to remember or forget.

### Human/environmental authority and value

Mathematics proves what follows from each response; it does not decide which
response an affected living participant ought to supply.  When the port
represents a person's intended continuation, replacing it by the model's score
would convert prediction into authority.  Preserving autonomy means keeping
the response as an admitted causal input, recording its provenance and scope,
and allowing withdrawal to remove its present authority without falsifying the
historical fact that it once selected a path.

This finite theorem does not formalize love, flourishing, or consent.  It gives
one exact system consequence: endpoint invariants cannot infer a situated
choice whose alternatives create different future capabilities.

## 5. What changed across the organism

The integration is genuine but narrow:

1. the invariant layer exposes a two-element residual torsor;
2. the proposal layer can traverse it cheaply but cannot certify a point;
3. a live coupling makes one point exact through equation (2);
4. proof memory retains the coupling and its provenance;
5. compilation installs the selected point as a primitive;
6. the installed primitive changes future action and observation by (3);
7. task quotienting may erase the choice only when those continuations are
   withdrawn;
8. value enters by governing who may supply or withdraw consequential ports,
   not by pretending a group invariant contains that authority.

This is the smallest instance currently in the repository where one encounter
changes proposal, proof, executable grammar, memory requirements, and the
scope of legitimate forgetting at once.

It remains far from an autopoietic mathematics.  The ambient permutation
grammar, the context point, and the decision to install are supplied.  The
machine has not generated its own criteria of worthwhile coupling or its own
ethical authority.  The theorem prevents us from hiding those absences behind
the word “self-improving.”

## 6. Replay

```bash
cd machinery
python3 -m unittest test_situated_constructor_port.py -v
python3 situated_constructor_port.py
```

The seven tests check minimality, the free transitive stabilizer action, the
evaluation bijection, equivariance, distinct installed grammars, resistance to
misleading learned scores, and restoration of the torsor when the port is
withdrawn.

## Rigor boundary

The transporter calculation, minimality, bijection (1), equivariance, grammar
orders, and separating continuation (3) are proved directly and replayed.
The statements about proposal models, cultural inheritance, and autonomy are
system interpretations whose boundaries are explicitly stated; they are not
theorems derived from `S_3`.  No novelty is claimed for the standard torsor
mathematics.  The contribution is the exact integration and executable causal
ledger at this repository's open constructor-formation boundary.
