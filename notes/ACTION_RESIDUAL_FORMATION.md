# Action residual formation: the obstruction becomes the sensor

**Status.** Exact standard theorem plus a checked Cubical Agda formation
event.  No novelty is claimed.  The general coordinate theorem needs a
declared predictor; the translation cross-effect removes that external choice
once a pointed additive action language is part of the data.

## 1. Exact objects

Let `X` be a state type, `A` an abelian group, and let

\[
q:X\to A,\qquad s:X\to X,\qquad p:A\to A
\]

be respectively the current observation, one executable state action, and the
declared prediction of that action on the old observation.  Define

\[
a(x)=q(sx),\qquad
\delta_p(x)=a(x)-p(q(x)).                                      \tag{1}
\]

There are two carriers for the same encounter:

\[
B(x)=(q(x),a(x)),\qquad D_p(x)=(q(x),\delta_p(x)).              \tag{2}
\]

The first stores before/after behavior.  The second stores the old reading and
the exact prediction defect.

## 2. Reversible residual-coordinate theorem

**Theorem 2.1.** The carriers `B` and `D_p` mutually determine one another:

\[
(y,z)\longmapsto (y,z-p(y)),\qquad
(y,d)\longmapsto (y,d+p(y)).                                  \tag{3}
\]

Both maps replay exactly on the image of `X`.  Moreover

\[
\delta_p(x)=0\quad\Longleftrightarrow\quad q(sx)=p(q(x)).       \tag{4}
\]

If `q(x)=q(x')` but `q(sx)\ne q(sx')`, then
`delta_p(x) != delta_p(x')`.  Hence `(q,delta_p)` strictly refines `q`, and by
the product universal property it is the coarsest carrier determining both the
old reading and the one-step observed behavior.

**Proof.** Equations (3) are inverse on produced values because
`(z-p(y))+p(y)=z`.  Equation (4) is cancellation.  In the last assertion,
equality of the two residuals plus equality of the old readings would recover
equality of the two after-readings by the second decoder, contradicting the
hypothesis.  The minimality statement is exactly the checked product theorem
in `NaturalMachine.ActionRefinement`. `square`

This joins four previously separate descriptions without identifying them:

- **obstruction:** nonzero `delta_p` is failed equivariance/descent;
- **equivariance:** zero defect is precisely the commuting square;
- **compression:** an old fiber is split exactly when its after-action readings
  differ;
- **observable formation:** the split coordinate is calculated by the same
  encounter, not supplied as an independent oracle.

Changing `p` changes the displayed residual by an old-observable function, but
does not change the induced joint quotient: every `D_p` is reversibly
interdecodable with the same behavior carrier `B`.  Thus the predictor is a
coordinate gauge for the refinement.  Calling a particular residual canonical
still requires a reason to choose that gauge.

## 3. The action language chooses the cross-effect

Suppose now that states form an abelian group `G` and the installed actions are
translations `s_u(x)=x+u`.  The point `0`, the current sensor `q`, and the
chosen action parameter `u` determine the predictor

\[
p_u(y)=y+q(u)-q(0).                                            \tag{5}
\]

No further model is fitted.  Its residual is the reduced translation
cross-effect

\[
\operatorname{cr}_q(x,u)
=q(x+u)-q(x)-q(u)+q(0).                                       \tag{6}
\]

This is the standard Eilenberg--Mac Lane cross-effect, written as an
observable-formation event.  It is the mixed term left after removing the two
one-body readings and the base point.  It vanishes for every `(x,u)` when
`q-q(0)` is additive; nonvanishing is therefore an exact obstruction to
transporting the translation language through `q`.

The cross-effect is the required extra coordinate only relative to the
declared translation action.  Without the action, (6) is merely a formula;
without the base point, its normalization is not fixed; without retaining the
old reading through the encounter, the reconstruction in (3) is unavailable.

## 4. Executable arithmetic formation event

Take the integer state line and

\[
q(x)=x^2,\qquad s_u(x)=x+u,qquad p_u(y)=y+u^2.
\]

The cross-effect compiles by a ring identity valid in every commutative ring:

\[
\delta_u(x)=(x+u)^2-(x^2+u^2)=xu+xu.                          \tag{7}
\]

For the already available successor action `u=1`,

\[
\delta_1(x)=2x.                                                \tag{8}
\]

The old sensor identifies `1` and `-1`, while the formed residual returns `2`
and `-2`.  The checked collision therefore gives

\[
(x^2,2x)\ \text{strictly refines}\ x^2.                       \tag{9}
\]

In fact the frontier changes more sharply: multiplication by `2` is injective
on the integers, so the residual alone recovers the entire state.  After one
successor encounter, every future integer observable can in principle factor
through the newly formed coordinate.  This is not true in an arbitrary ring:
`2` may be a zero divisor or the ring may have characteristic `2`.  The Agda
term uses integer torsion-freeness exactly at this final cancellation step.

Equation (7) is also the transfer certificate against lookup memorization.  It
is proved over an arbitrary commutative ring and then instantiated at the
integers; no finite training set or fitted admissible class supplies the law.
The proof compiler replaces repeated evaluation of three squares and a
subtraction by the mixed bilinear term `xu+xu`.  That compiled identity makes
sign/orientation visible and changes the next cheap question from “which point
of this square fiber?” to ordinary integer evaluation.

## 5. Relation to the conservative sensor no-go

`PROSTHETIC_SENSOR_NO_GO` forbids realizing an absent old-probe outcome while
preserving the old response square.  Nothing here evades that theorem.  The old
square sensor remains unchanged and retains the same image.  The new residual
is a new response coordinate formed from an action encounter; the relevant
interface is `(old reading, defect)`, not a claim that the defect was already
an outcome of `q`.

Likewise, the valuation representation linearizes multiplication but not
addition.  Its cancellation residuals and (6) have the same exact shape:
transport the current operation through the current observation, subtract the
declared one-body prediction, and retain the untranslated interaction.  The
valuation case needs residue information; the square case produces the
polarized bilinear term.  The common operation is not “add a sensor” but
**expose the defect of transporting an earned action through the installed
carrier**.

## 6. Checked artifact and replay

The formal artifact is
`formal/cubical/NaturalMachine/ActionResidual.agda`.  It contains:

1. both behavior/defect decoders and replay equations;
2. both directions of the zero-defect criterion;
3. collision transport and strict-refinement formation;
4. the predictor-free translation cross-effect construction;
5. the arbitrary-commutative-ring identity (7);
6. the exact integer `1,-1` collision; and
7. injectivity of the formed integer residual;
8. the necessary-and-sufficient two-step cocycle boundary;
9. the finite compiled residual fold; and
10. equality of that fold with the exact endpoint defect at every depth.

Replay from `formal/cubical/`:

```text
agda -i . NaturalMachine/ActionResidual.agda
```

The file is `--cubical --safe`, with no holes or postulates, and is imported by
the root aggregate.  Both the leaf command above and
`agda -i . NaturalMachine.agda` exit zero.  The aggregate emits its existing
unsupported-indexed-match warnings; none arise from this module.

## 7. Composition boundary and proof compilation

Write

\[
\delta(x)=q(sx)-p(qx),\qquad
\delta^{(2)}(x)=q(s^2x)-p^2(qx).                              \tag{10}
\]

Global additivity of `p` is sufficient for a cocycle law, but it is not the
exact hypothesis.  At a fixed state `x`, define the realized preservation law

\[
p(\delta(x))=p(q(sx))-p^2(qx).                                \tag{11}
\]

**Theorem 7.1 (exact two-step boundary).** At every `x`, (11) holds if and
only if

\[
\delta^{(2)}(x)=\delta(sx)+p(\delta(x)).                       \tag{12}
\]

**Proof.** Abelian-group cancellation gives the unconditional expansion

\[
\delta^{(2)}(x)
=\delta(sx)+\bigl(p(q(sx))-p^2(qx)\bigr).                     \tag{13}
\]

Substituting (11) proves (12).  Conversely compare (12) with (13) and cancel
the common first summand. `square`

Thus the precise obstruction is not “nonlinearity somewhere.”  It is failure
to preserve the one subtraction that actually produced the current residual.
For a sharp control, take `A=Z`, `q(x)=x`, `s(x)=x+1`, and `p(y)=y^2`.  At
`x=1`, `delta(x)=1`, so the two sides of (11) are `1` and `4-1=3`.  Correspondingly
`delta^(2)(1)=3-1=2`, while `delta(2)+p(delta(1))=-1+1=0`.  The cocycle fails by
exactly the realized preservation defect.

When `p` preserves subtraction globally, the one-shot sensor compiles for all
finite action depths.  Define an executable fold

\[
D_0(x)=0,\qquad
D_{n+1}(x)=\delta(s^n x)+p(D_n(x)).                            \tag{14}
\]

**Theorem 7.2 (compiled residual fold).** For every natural number `n`,

\[
D_n(x)=q(s^n x)-p^n(qx).                                      \tag{15}
\]

**Proof.** The base case is `q(x)-q(x)=0`.  At the successor step, apply
(13) with `s^n x` in place of `x`, use preservation of subtraction to identify
the transported accumulated defect, and invoke the induction hypothesis.
This is the checked recursion `compiledResidual-sound`. `square`

Equation (15) is the proof-compilation event the one-step theorem left open.
The action loop no longer needs to reopen the original hidden state or
reconstruct the endpoint defect from scratch: each encounter emits one local
residual, and (14) updates the exact global obstruction inside the observable
codomain.  The theorem also says precisely when this compilation is unlawful.

## 8. Scope and next obstruction

Proved: the reversible coordinate theorem, the exact cross-effect formation,
the ring identity, the strict integer collision, integer faithfulness, the
two-step iff boundary, and the all-finite-depth compiled fold under subtraction
preservation.

Not proved: that every useful action language has an additive codomain in
which a difference can be taken; that a predictor is canonical without the
pointed translation structure; that the residual is cheap under a specified
physical cost model; or that a useful predictor preserves the realized
residuals produced by an arbitrary action language.

The next exact question has changed.  Composition is now compiled; the live
boundary is **predictor formation**.  In the square/translation example the
grading chooses `p_u(y)=y+u^2`.  For a general current action language, what
universal property forms the predictor itself, and what collision certifies
that no predictor on the old carrier can close the residual fold?  This is an
existence/selection obstruction, not another cocycle calculation.

## Prior-art/search ledger

The cross-effect, polarization, equivariance-defect, and product-universal-
property ingredients are standard; no novelty search is being used to promote
them.  Repository search located the related checked developments
`NaturalMachine/CompressionDefect.agda`, `GroupCohomologyH2.agda`,
`Gamma0PartnerRigidity.agda`, and `NaturalMachine/ActionRefinement.agda`.
`notes/PRIOR_ART_INDEX.md` names an external `~/agda-libs` tree, but that path
was absent in this checkout, so no claim about coverage of that library is
made.
