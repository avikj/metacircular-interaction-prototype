# All binary aligned extreme rays recurse by coupling

Let `C_k=A_(2,k)` and let `L(mu)=|mu|`. By the ordered fiber-product theorem,

\[
C_k=\{(\alpha,\beta)\in C_{k-1}^2:L(\alpha)\ge L(\beta)\}. \tag{1}
\]

## Minimal-face lemma

For `x` in a polyhedral cone, write `F_x` for its minimal face and `f(x)` for
the dimension of its linear span (`f(0)=0`).

**Lemma.** For nonzero `(alpha,beta)` in (1):

\[
f(\alpha,\beta)=
\begin{cases}
f(\alpha)+f(\beta),&L(\alpha)>L(\beta),\\
f(\alpha)+f(\beta)-1,&L(\alpha)=L(\beta)>0.
\end{cases}                                                   \tag{2}
\]

*Proof.* In the strict case the parent inequality is inactive locally, so the
minimal face is `F_alpha x F_beta`. In the equality case its span is the
kernel of `(u,v)->L(u)-L(v)` inside
`span(F_alpha)x span(F_beta)`. This functional has rank one: every nonzero
face contains a nonzero nonnegative measure, whose total mass is positive.
Thus the kernel has codimension one. ∎

## Ray theorem

**Theorem.** Every extreme ray of `C_k` is exactly one of:

1. `(r,0)`, where `r` is an extreme ray of `C_(k-1)`;
2. `(r/L(r),s/L(s))` up to common positive scaling, where `r,s` are extreme
   rays of `C_(k-1)` (the two children have equal total mass).

*Proof.* A nonzero point spans an extreme ray iff its minimal face has
dimension one. In the strict case (2) forces `f(alpha)=1,f(beta)=0`, since
`alpha` is nonzero; this is case 1. In the equality case both children are
nonzero and (2) equals one iff both child-face dimensions equal one, giving
case 2. Conversely both constructions have face dimension one by (2). ∎

If `R_k` is the number of rays, normalization by positive total makes every
ordered pair of child rays yield one distinct coupling. Hence

\[
R_k=R_{k-1}+R_{k-1}^2,qquad R_1=2,                            \tag{3}
\]

so

\[
R_1,R_2,R_3,R_4=2,6,42,1806.                                 \tag{4}
\]

The six depth-two rays are recovered exactly: two zero-child lifts and four
ordered equal-total couplings. At depth three, the theorem produces 42 rays
without polyhedral enumeration.

## Rigor boundary

This classifies all extreme rays for binary aligned cones. For `p>2`, several
adjacent total inequalities may be simultaneously active, so the single
codimension-one argument must be replaced by an active-equality graph rank;
no generalization is claimed here.

