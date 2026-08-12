# The von Mangoldt function as a cyclotomic intersection module

**Status:** exact elementary module lift; geometric successor open and
non-load-bearing.

## 1. The identity

Let `Phi_n(x)` be the `n`-th cyclotomic polynomial.  For every integer
`n>1`,

\[
 \boxed{\Lambda(n)=\log\Phi_n(1)
 =\log\left|\operatorname{Res}(\Phi_n(x),x-1)\right|.} \tag{1.1}
\]

Here `Phi_n(1)>0`.  Equivalently,

\[
 \Phi_n(1)=
 \begin{cases}
 p,&n=p^k,\\
 1,&n\text{ has at least two distinct prime divisors}.
 \end{cases}                                                   \tag{1.2}
\]

**Proof.**  Möbius inversion of `x^n-1=prod_{d|n} Phi_d(x)` gives

\[
 \Phi_n(x)=\prod_{d\mid n}(x^d-1)^{\mu(n/d)}.
\]

For `n>1`, `sum_{d|n} mu(n/d)=0`, so taking the limit at `x=1` cancels
the powers of `x-1` and yields

\[
 \log\Phi_n(1)=\sum_{d\mid n}\mu(n/d)\log d=\Lambda(n),
\]

the standard Möbius formula for the von Mangoldt function.  Since
`Res(Phi_n,x-1)` is `Phi_n(1)` up to the harmless resultant sign, (1.1)
follows. \(\square\)

The numerical weight in the explicit formula is therefore already a finite
intersection multiplicity; no analogy or limiting argument is required.

## 2. The canonical defect module

Define

\[
 \mathcal D_n:=\operatorname{coker}\left(
 m_{x-1}:\mathbb Z[x]/(\Phi_n)
 \longrightarrow\mathbb Z[x]/(\Phi_n)\right).          \tag{2.1}
\]

The quotient presentation gives canonically

\[
 \boxed{
 \mathcal D_n\cong
 \mathbb Z[x]/(\Phi_n,x-1)
 \cong\mathbb Z/\Phi_n(1)\mathbb Z.}                  \tag{2.2}
\]

Consequently

\[
 \mathcal D_n\cong
 \begin{cases}
 \mathbb F_p,&n=p^k,\\
 0,&n\text{ is not a prime power},
 \end{cases}
 \qquad
 \boxed{\log|\mathcal D_n|=\Lambda(n).}               \tag{2.3}
\]

The zero module is assigned order one.  Formula (2.2) is the specialization
of `RESULTANT_OBSERVER_DEFECT.md` to `(f,g)=(Phi_n,x-1)`.  It upgrades the
scalar resultant to the actual finite intersection/observer-defect module.

Geometrically, `Spec D_n` is the scheme-theoretic intersection of the
cyclotomic root scheme `Phi_n=0` with the identity section `x=1`.  It is
nonempty exactly on prime-power strata, and there it is the residue field at
the unique rational prime below the collision.

## 3. Exact lift of the Weil prime term

With the normalization of `WEIL.md`, the finite arithmetic term in the Weil
explicit formula becomes

\[
 \boxed{
 \operatorname{Prime}(F)
 =\sum_{n\ge2}\frac{\log|\mathcal D_n|}{\sqrt n}
   \bigl(F(\log n)+F(-\log n)\bigr).}                  \tag{3.1}
\]

Thus every atom on the finite side of the Weil arithmetic intersection form
is the logarithmic size of a canonical module.  The remaining terms have the
expected global-intersection roles:

- the gamma integral is the archimedean place;
- the rank-two pole form is the distinguished degree/hyperbolic plane;
- `WEIL_INDEX_ONE.md` proves that an unconditional index-one theorem for the
  resulting form is equivalent to RH.

Equation (3.1) is an exact change of coefficients, not yet a construction of
the global intersection object and not a proof of its index theorem.

## 4. Cyclotomic-tower compatibility

For a fixed prime `p`, the inclusions of cyclotomic integer rings along

\[
 \mathbb Z[\zeta_p]\subset\mathbb Z[\zeta_{p^2}]
 \subset\cdots
\]

send the identity-section ideals to identity-section ideals.  Reduction at
`zeta_{p^k}=1` gives the same residue field `F_p` at every level, agreeing
with `D_{p^k} congruent F_p` and with `Lambda(p^k)=log p`.  The exponent `k`
is retained by the archimedean scale `log n=k log p`, not by enlarging the
finite residue module.

This is the exact local shape expected from total cyclotomic ramification:
one finite atom persists through the tower while its position changes on the
logarithmic/scaling axis.

## 5. Proposed construction and kill criteria

The high-value target is:

> Organize the modules `D_n`, their cyclotomic norm/restriction maps, the
> logarithmic scale, and the archimedean gamma contribution into a genuine
> arithmetic intersection pairing whose numerical realization is the Weil
> form.  Prove its index-one property from the geometry rather than from RH.

This would combine the exact converse `WEIL_INDEX_ONE.md` with a Hodge-index
mechanism and would prove RH.  Nothing here establishes that such a global
object exists.

Advance only if the construction supplies at least one of:

1. a bilinear pairing and degree map satisfying a principal-divisor product
   formula before the explicit formula is invoked;
2. functorial finite/archimedean gluing that reconstructs (3.1) and the gamma
   term from one object;
3. an independently proved Hodge/index inequality on a nontrivial test class
   larger than the already-known prime-free Connes--Consani window.

Kill any proposed realization that defines its pairing to be the explicit
formula by fiat, assumes Weil positivity, or merely renames `Lambda(n)` by
`log Phi_n(1)` without producing new functorial structure.

## 6. Prior-art and rigor boundary

Classical: the identities for `Phi_n(1)`, the Möbius formula for `Lambda`,
cyclotomic ramification, and resultant as determinant/intersection number.
Already proved in the corpus: the general defect-module theorem and the
index-one converse.  Possibly useful synthesis: recognizing the canonical
modules `D_n` as a module-valued lift of every finite atom of the Weil form.
No novelty claim is made for the scalar identity.  A targeted search found it
stated explicitly as `Phi_n(1)=exp(Lambda(n))` in P. Moree,
*Cyclotomic polynomials at roots of unity* (Lemma 20,
[arXiv:1611.06783](https://arxiv.org/abs/1611.06783)), and located the broader
resultant literature through C. C. A. Cheng, J. H. McKay, and S. S. S. Wang,
*Resultants of cyclotomic polynomials*, Proc. AMS 123 (1995), as cited in
[arXiv:2010.02668](https://arxiv.org/abs/2010.02668).  The search did not
locate the exact use of the cokernel family as the finite module-valued side
of the Weil index-one form.  That absence is only a searched-not-found
boundary; the module calculation itself is immediate once the classical
identity and resultant-cokernel theorem are juxtaposed.
