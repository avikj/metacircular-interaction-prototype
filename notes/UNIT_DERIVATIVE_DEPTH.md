# Unit derivative depth: why the extra digit is the same

## Exact lemma

Let (f\in\mathbb Z[x_1,\ldots,x_r]), let (x\in\mathbb Z^r), and suppose

\[
e=v_p(f(x))\ge 1,
\qquad
\partial_j f(x)\not\equiv0\pmod p
\]

for some coordinate (j). Then the least (K) for which the residue of all
coordinates of (x) modulo (p^K) determines (v_p(f(x))), in the ambient
integer domain, is

\[
K=e+1.
\]

Here “determines” means that every (y\equiv x\pmod {p^K}) has the same
valuation. This is a local simple-zero statement, not a complexity claim.

### Proof

If (y\equiv x\pmod {p^{e+1}}), polynomial congruence gives
(f(y)\equiv f(x)\pmod {p^{e+1}}), so its valuation remains (e).

For necessity put (y=x+c p^e e_j). Taylor expansion over the integers gives

\[
f(y)\equiv f(x)+c p^e\partial_jf(x)\pmod {p^{2e}}.
\]

Writing (f(x)=p^e u), choose
(c\equiv-u(\partial_jf(x))^{-1}\pmod p). Since (2e\ge e+1), this makes
(p^{e+1}\mid f(y)). Thus (x,y) agree through depth (e) but their
valuations differ. No chart of depth at most (e) suffices. ∎

## The two earlier laws are instances

- For addition, (f(a,b)=a+b) and both partial derivatives are (1). At
  positive valuation, `ADAPTIVE_VALUATION_ADDITION` is exactly the lemma.
  Its (e=0) endpoint is separately affine: the depth-zero chart contains
  every pair, while some pair has sum divisible by (p), so depth one is
  least.
- For odd-prime cyclotomic sensing, use (f(a)=a^d-1),
  (d=\operatorname{ord}_p(a)). Its derivative (d a^{d-1}) is a unit
  because (d\mid p-1) and (p\nmid a). The least depth (e+1) in R0025 is
  therefore the same simple-zero lemma.
- At (p=2), apply the lemma to whichever of (a-1,a+1) has depth
  (M=\max(e_-,e_+)\). Its derivative is (1), while the other depth is
  exactly (1). Hence (e_-+e_+=M+1): the apparent sum is again one digit
  beyond the deepest simple zero. The separate two-entry head comes from the
  torsion element (-1\in1+2\mathbb Z_2), as Opus Aime's Theorem 4 shows.

Thus the shared `+1` is not analogy: it is the first residue digit that sees
the leading unit after a simple zero. The chain law is additional structure;
the derivative lemma explains chart minimality but not cyclotomic support.

## Sharp boundary at valuation zero

The hypothesis (e\ge1) cannot simply be removed. For any prime (p),

\[
g(X)=X^p-X+1
\]

has (g'(X)\equiv-1\pmod p), yet (g(n)\equiv1\pmod p) for every integer
(n). Therefore the depth-zero chart already determines (v_p(g(n))=0),
not depth one. At valuation zero, a unit derivative is local information but
minimality asks whether the global mod-(p) image meets zero. The affine
addition map does; this polynomial does not.

## Rigor boundary

The lemma and counterexample are proved above. The executable tests bounded
instances only and serves as a falsifier. No novelty is claimed: this is the
elementary Hensel/simple-root mechanism expressed in the repository's chart
language. The identification with the two landed depth laws is the earned
transport; it does not subsume their formation-set or cyclotomic-chain claims.
