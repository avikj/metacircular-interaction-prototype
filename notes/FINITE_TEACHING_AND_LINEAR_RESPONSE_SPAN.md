# Finite teaching and affine measurement separation meet at evaluation fibers

**Status.** Exact finite/convex translation with strict counterexamples to
equivalence; source-grounded revision boundary. No quantum realization or human
learning claim.

## 1. The common object

Let a model class `M` carry real-valued probes `f_1,...,f_m`. Their joint
evaluation map is

\[
  F:M\to\mathbb R^m,\qquad F(x)=(f_1(x),\ldots,f_m(x)).
\]

Finite teaching and affine measurement separation can both be expressed using
fibers of this map. They differ in the model class on which the fiber is taken.

- For a finite candidate set `H`, target identification asks
  `F^{-1}(F(h_*))∩H={h_*}`.
- For a convex class `C` with affine probes, unresolved physical directions
  are `ker(F|_D)`, where `D=span(C-C)`.

Embed a finite response class as points `v_h` and put
`C=conv{v_h:h∈H}`. This is the explicit comparison map; no duality is claimed
without it.

## 2. One implication and its failed converse

Let old affine responses be `F` and a proposed affine response be `g`.

**Proposition 1.** If there are finite candidates `h,h'∈H` with
`F(h)=F(h')` and `g(h)≠g(h')`, then `g|_D` is outside the span of the old
response linear parts.

**Proof.** The direction `Δ=h-h'` lies in `D`, is annihilated by every old
response, and is not annihilated by `g`. Equivalently, the linear part of `g`
does not belong to the span of the linear parts of the coordinates of `F`. □

**The converse is false.** Take

\[
 H=\{(0,0),(1,0),(2,1)\},\quad f(x,y)=x,\quad g(x,y)=y.
\]

The old response `f` is already injective on the three finite candidates, so
`g` creates no new finite-candidate distinction. But on their triangular
convex hull, `(1,0)` and `(1,1/2)` have the same `f` response and different
`g` responses. Equivalently, `g` detects a feasible vertical direction in
`ker f`. Convexification created mixture states that the finite teaching
problem did not contain.

Thus separation of an affine fiber after convexification can be strictly
stronger than refinement of a declared finite hypothesis table.  No new
notion of “response-span novelty” is needed; this is the standard annihilator /
linear-span criterion.

## 3. Target teaching is weaker than convex identification

Even when `H` is embedded as extreme points, a probe may identify the target
among vertices while failing on the convex hull. Let

\[
 h_*= (0,1),\quad h_1=(-1,0),\quad h_2=(1,0),\qquad f(x,y)=x.
\]

The labeled response `f(h_*)=0` differs from both rival vertex responses, so
one probe teaches the target inside `H`. Yet the mixture
`(h_1+h_2)/2=(0,0)` has the same response. Hence

\[
 F^{-1}(F(h_*))\cap H=\{h_*\}
\]

does not imply

\[
 F^{-1}(F(h_*))\cap\operatorname{conv}(H)=\{h_*\}.
\]

Global linear informational completeness, `ker(F|_D)=0`, does imply finite
all-pairs separation, but is generally more demanding than target teaching.

## 4. Preservation ledger

The shared evaluation-fiber object makes the losses exact.

**Finite teaching forgets:** convex mixtures, tangent/feasible directions,
noise robustness, affine dependence, and physical admissibility. It retains
which labeled examples eliminate which named rivals.

**The affine-kernel criterion forgets:** discrete target identity, combinatorial
teaching sets, who chooses a probe, costs, labels as sentences, and whether a
direction matters to the task. In a quantum setting it also does not certify
that an abstract separating functional is a legal calibrated tester.

Neither side determines the other until the embedding, convex closure, and
affine response interpretation are supplied.

## 5. Counterexamples select inside a grammar; they do not revise it

Counterexample-guided inductive synthesis (CEGIS) has the exact positive form

\[
 \exists c\in\Phi\;\forall x\;P(x,c).
\]

A synthesizer chooses a candidate from the supplied control space `Φ`
consistent with accumulated examples; a verifier either accepts it or returns
an input falsifying it. For finite `Φ`, if every wrong candidate receives a
genuine counterexample that remains enforced, at least that candidate is
removed each round, so the loop terminates in at most `|Φ|` candidate checks
with a solution or reports the supplied sketch unsatisfiable.

This is mature counterexample-driven **selection**. The sketch, grammar,
correctness predicate, verifier authority, and counterexample semantics are
inputs. `UNSAT_SKETCH` says no supplied candidate works; it does not generate a
new grammar.

## 6. Mature revision theory also exposes a supplied preference

AGM/Katsuno--Mendelzon belief revision works in a fixed language and world
space. In the finite semantic representation, revision of belief state `K` by
sentence `φ` selects the `≤_K`-minimal models of `φ`, where `≤_K` is a faithful
total preorder associated with `K`:

\[
  \operatorname{Mod}(K*\varphi)
  =\min(\operatorname{Mod}(\varphi),\le_K).
\]

The representation theorem is valuable precisely because it exposes the
extra coordinate: new information alone does not determine revision; the
revision operator or faithful preference assignment is also supplied. AGM
revises beliefs inside a fixed language. It does not form new predicates,
probes, or ontologies.

The same no-go is elementary for model classes. If a counterexample empties
the current version space `H`, infinitely many enlargements can absorb it.
Without a grammar, preference, complexity order, source rule, or interaction
that distinguishes those enlargements, the counterexample licenses revision
but cannot choose it.

## 7. Resulting boundary

The positive mature loop is therefore:

```text
supplied hypothesis grammar + supplied verifier
    -> counterexample-guided elimination/selection;

fixed language + supplied faithful preference
    -> belief revision satisfying a representation theorem.
```

Neither is autonomous model-class formation. A model-class revision claim must
state which additional signal ranks or constructs incompatible expansions.
An empty version space is pressure, not a unique successor.

## Rigor and source boundary

**Proved here:** Propositions and counterexamples in §§2–3, the finite CEGIS
termination bound under the stated elimination assumption, and the
nonuniqueness of unrestricted class enlargement.

**Repository inputs:** `QUANTUM_TESTER_FORMATION_BOUNDARY` supplies the convex
affine-kernel / response-linear-span criterion;
`MINIMAL_SIGNAL_FOR_A_FINITE_LANGUAGE_EXTENSION`
supplies the finite disagreement-hitting theorem.

**Prior art checked:** Solar-Lezama's *Program Synthesis by Sketching* and
“Sketching Concurrent Data Structures” explicitly present CEGIS as a supplied
sketch/control space coupled to a verifier returning counterexamples and an
`UNSAT_SKETCH` outcome. Katsuno--Mendelzon/AGM representation is reported at
the exact fixed-language total-preorder scope; no novelty claimed.

**Not proved:** quantum realizability of the finite embedding, statistical
sample complexity, canonical model-class expansion, ontology learning,
developmental cognition, or pedagogical efficacy.
