# Scaled Taylor jets, not the Hessian alone

The tangent criterion asks what replaces the tangent hyperplane when the
gradient vanishes modulo \(p\). The Hessian is only one branch. The exact
object is the value-set of a scaled Taylor initial form, followed—when that
form vanishes as a function—by the next visible jet.

Let \(f\in\mathbb Z[X_1,\ldots,X_n]\), \(x\in\mathbb Z^n\), and
\(e=v_p(f(x))<\infty\). Expand integrally
\[
 f(x+Y)=f(x)+\sum_{\alpha\ne0}c_\alpha Y^\alpha .
\]
At proposed residue depth \(k\ge1\), put
\[
 \mu_k=\min_{\alpha\ne0}\bigl(v_p(c_\alpha)+k|\alpha|\bigr).
\]
When \(\mu_k\le e\), let
\[
 I_k(H)=\sum_{v_p(c_\alpha)+k|\alpha|=\mu_k}
       (c_\alpha p^{k|\alpha|-\mu_k})H^\alpha\pmod p.
\]
The operative object is its function on \(\mathbb F_p^n\), not merely the
formal polynomial.

**Scaled initial-form lemma.** For every integral \(h\):

- if \(\mu_k>e\), then \(v_p(f(x+p^kh))=e\);
- if \(\mu_k<e\) and \(I_k(h)\ne0\), then
  \(v_p(f(x+p^kh))=\mu_k\);
- if \(\mu_k=e\), writing \(f(x)=p^eu\), then
  \[
  p^{-e}f(x+p^kh)\equiv u+I_k(h)\pmod p.
  \]

*Proof.* Substitute \(Y=p^kh\), group terms by p-adic valuation, and reduce
after dividing by the least visible power. ∎

At \(\mu_k=e\), depth \(k\) determines valuation \(e\) exactly when the
value-set of \(I_k\) avoids \(-u\). If it hits \(-u\), valuation rises,
possibly to infinity; the tangent theorem's zero-locus deletion still applies.
When \(\mu_k<e\), a nonzero value lowers valuation. If \(I_k\) is the zero
function, the first form is silent and the next scaled jet must be exposed.
Thus the 0.25 forecast branch occurs: one initial form is not universally
decisive. The exact object is a finite recursive jet tower modulo \(p^{e+1}\).

The tangent theorem is the case \(k=e\): higher-degree terms lie above \(e\),
and the degree-one initial form is \(\nabla f(x)\cdot H\). A Hessian criterion
occurs only when its quadratic form is first visible at the relevant scale.

## Same Hessian shape, opposite answers

For \(f(X)=9+X^2\), \(p=3\), \(x=0\), \(e=2\), \(k=1\), the initial form is
\(H^2\). Since \(-1\) is not a square modulo 3, depth one determines valuation
two. Depth zero does not because \(f(1)=10\). The least depth is one.

For \(f(X)=25+X^2\), \(p=5\), the identical Hessian shape has the opposite
answer: \(H=2\) solves \(1+H^2=0\pmod5\), and \(f(10)=125\) has valuation
three. Depth one fails and depth two succeeds. Hessian rank is insufficient;
represented values over the residue field decide.

## Polynomial expression versus polynomial function

Set \(e=kp\) and
\[
 f(X)=p^{kp}+X^p-p^{k(p-1)}X,\qquad x=0.
\]
At scale \(k\),
\[
 f(p^kH)=p^{kp}(1+H^p-H).
\]
The initial expression \(H^p-H\) is nonzero in \(\mathbb F_p[H]\), but induces
the zero function on \(\mathbb F_p\). The valuation remains \(e\) throughout
that depth-\(k\) fiber. A coefficient- or rank-only criterion is false.

## Exact finite fallback

For fixed \(e,k\), \(f(x+p^kh)\bmod p^{e+1}\) depends only on
\(h\bmod p^{e+1-k}\). Thus the tower terminates in the finite map
\[
 J_{x,k}: (\mathbb Z/p^{e+1-k}\mathbb Z)^n
 \longrightarrow \mathbb Z/p^{e+1}\mathbb Z,\quad h\mapsto f(x+p^kh).
\]
This is exact, not necessarily efficient. Successive initial forms compress
it whenever their value functions decide.

## Rigor boundary

The lemma and examples are proved above. The executable checks the univariate
examples and periodicity as falsifiers only. No novelty is claimed: Taylor
expansion, initial forms, and finite-field polynomial functions are standard.
