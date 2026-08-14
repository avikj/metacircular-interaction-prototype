# Invariants recover an action envelope, not a constructor grammar

**Status:** exact coupled-closure theorem and minimal finite/Smith no-go.
**Breaker audit (cf-tessera, 2026-08-12): CONFIRMED** — see `notes/INVARIANT_SCHEMA_ENVELOPE_AUDIT.md`. The envelope map `K` is the right adjoint of the orbit map `E`, so the formalization is forced; the displayed `U_k` are the `det=-1` half of a two-line transporter whose `det=+1` half is already implied by §3's `Stab(D)` bijection and §4's orientation clause.

`RESIDUAL_DRIVEN_SMITH_DESCENT.md` leaves a precise question.  The typed
residual chooses an instance of a pre-existing row/column operation.  Can the
operation schema itself be recovered by coupling the invariants it preserves
to the descents it makes possible?

There is a positive answer and a negative answer, at different levels.  The
invariants determine a maximal symmetry envelope.  They do not determine a
presentation of that envelope, and local descent does not repair the loss.

## 1. The coupled operation

Let `X` be a set and let `S` be reversible constructors acting on `X`.  Write
`G=<S>` for the generated group and `E_G` for its orbit partition.  A
set-valued invariant is complete for the action exactly when its fibers are
the blocks of `E_G`.

Conversely, for a partition `E` define

\[
K(E)=\{\sigma\in\operatorname{Sym}(X):
       \sigma(B)=B\text{ for every }E\text{-block }B\}.
\]

This makes the proposed feedback literal:

\[
S\longmapsto E_{\langle S\rangle}\longmapsto K(E_{\langle S\rangle}).
\tag{1}
\]

The first arrow asks which distinctions survive the constructors.  The second
returns every constructor licensed by exactly those distinctions.

### Envelope theorem

For every `S`:

1. `G` is a subgroup of `K(E_G)`;
2. `E_{K(E_G)}=E_G`;
3. the return operation is idempotent:
   `K(E_{K(E_G)})=K(E_G)`.

**Proof.** Every element of `G` maps each `G`-orbit to itself, proving (1).
Inside each orbit `B`, `K(E_G)` contains the full symmetric group on `B`, so
it is transitive on `B` and never moves a point outside `B`.  Its orbits are
therefore exactly the original blocks, proving (2); applying `K` again gives
(3). `square`

Thus the coupling really has fixed points.  But a fixed point is a saturated
action envelope, not the grammar that first generated it.

## 2. The smallest finite loss

Three points are minimal.  On `{0,1,2}`, the cyclic group `C_3` and the full
symmetric group `S_3` have the same single orbit.  Hence all complete
orbit-invariants agree, while the action groups have orders three and six.
The return in (1) sends both to `S_3`.

With one point there is only the trivial permutation group.  With two points
the only transitive subgroup of `S_2` is `S_2`.  Therefore three is the
smallest carrier on which complete invariant data fail to recover even the
generated group, before asking for a generating presentation.

This also shows why the feedback is not inverse.  It is a closure operation:
it deliberately adds every symmetry that the chosen invariant language
cannot distinguish.

## 3. The Smith obstruction survives exact endpoint and descent

The finite theorem could appear irrelevant once one restricts constructors to
integer-linear row and column operations.  A smaller arithmetic witness shows
that the same loss remains inside that restriction.

Let

\[
A=\begin{pmatrix}2&0\\1&0\end{pmatrix},\qquad
D=\begin{pmatrix}1&0\\0&0\end{pmatrix}.
\]

For every integer `k`, set

\[
U_k=
\begin{pmatrix}
k&1-2k\\
1&-2
\end{pmatrix}.
\]

Direct calculation gives

\[
\det U_k=-1,
\qquad U_kA=D.
\tag{2}
\]

The `U_k` are pairwise distinct.  They are all unimodular, preserve every
determinantal ideal, make the same strict pivot descent `2 -> 1`, and produce
the *identical full target matrix*.  Consequently no observation depending
on source, target, Smith invariants, or any state-based local descent measure
can choose among them.

The mechanism is the stabilizer.  One reducer is

\[
U_0=\begin{pmatrix}0&1\\1&-2\end{pmatrix}.
\]

Every shear

\[
H_k=\begin{pmatrix}1&k\\0&1\end{pmatrix}
\]

fixes `D`, and `U_k=H_kU_0`.  Once the endpoint has a nontrivial stabilizer,
the path is a torsor rather than an identified constructor.

This is general.  For a group `G` acting on `X`, put

\[
T(x,y)=\{g\in G:g x=y\}.
\]

If `g_0 in T(x,y)`, left multiplication gives a bijection

\[
\operatorname{Stab}_G(y)\longrightarrow T(x,y),\qquad h\longmapsto hg_0.
\tag{3}
\]

Indeed, `hg_0x=hy=y`; conversely, if `gx=y`, then
`g g_0^{-1}` fixes `y`.  The stabilizer action on `T(x,y)` is free.  Hence a
selector that is natural under every symmetry of the declared target would
have to choose a fixed point of this free action, which exists only when the
target stabilizer is trivial.  Equation (3) is the exact obstruction to
calling any reducer canonical using only symmetry-invariant endpoint data.

This is stronger than saying that several algorithms compute Smith form.
Even a complete input-output observation erases which action occurred.

## 4. What the invariants genuinely generate

The no-go should not be read as saying the invariants contribute nothing.
Preservation of the integer lattice characterizes invertible integer-linear
coordinate changes as `GL_n(Z)`.  Smith determinantal ideals classify the
two-sided `GL_m(Z) x GL_n(Z)` orbits.  These facts constrain the lawful action
envelope sharply.

What they do not select is:

- a finite elementary generating set;
- an orientation into row versus column primitives;
- a word representing a given group element;
- a preferred representative modulo a target stabilizer;
- a cost declaring one such word primitive.

Those are presentation data.  A locality rule, hardware primitive, word
metric, normal-form convention, or causal port can select them, but each is an
additional observable.  Calling one of them “minimal” before declaring the
cost model is circular: word length exists only after the atoms and their
costs have been chosen.

The exact coupled object is therefore not

\[
\text{invariants}\leftrightarrow\text{unique constructor schema},
\]

but

\[
\text{presented constructors}
\longrightarrow
\text{orbit invariants}
\longrightarrow
\text{saturated action envelope},
\]

with a residual fiber of presentations and paths.  A self-improving machine
must retain that fiber until an actual execution ecology supplies a cost or
causal distinction.  Erasing it and then claiming to regenerate the grammar
from the invariant would manufacture uniqueness that the mathematics denies.

## 5. Replay

`machinery/invariant_schema_coupling.py` implements the finite closure and the
Smith stabilizer family.  Its tests verify the three-point minimal example,
idempotence, equation (2), and a nonunimodular false control:

```bash
cd machinery
python3 -m unittest test_invariant_schema_coupling.py -v
```

The finite enumeration is a proof replay over `S_3`, not a pattern search.

## Rigor boundary

The envelope theorem, three-point minimality, and family (2) are proved above.
Standard Smith classification and the characterization of lattice
automorphisms are used only for interpretation and are not claimed as new.
The result rules out unique recovery from the declared data; it does not rule
out a canonical presentation after a separately justified execution cost,
locality structure, or chosen basis is added.  Finding such data from a real
arithmetic environment rather than stipulating it is the next open boundary.
