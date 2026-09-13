# Reconstructed record: source-coherent quadratic dynamics, actual variations, and CRT histories

Provenance: reconstructed from the visible user-supplied note dated 6 September 2026, comparing repository commit `64effa62411bad3c12d513b2df5a1e5e55946afb`. This is a mathematical reconstruction, not a byte-exact export of the user's message. Its finite companion checks are bundled under `originals/conversation/ns_rh_source_audit/`.

## Quadratic realization fibre

For real vector spaces V,W and a quadratic diagonal Q(x)=b(x,x),

    S_Q(x,y) = (Q(x+y)-Q(x)-Q(y))/2

is symmetric bilinear. Every bilinear realization is uniquely `b=S_Q+a`, with `a` alternating. The realization fibre is the affine space modeled on `Hom(Lambda^2 V,W)`.

For nonzero x0 and any G with G x0=0, choose ell(x0)=1 and set

    a(x,y)=ell(x)G y-ell(y)G x.

Then `a(x0,-)=G`, while the quadratic diagonal is unchanged. Frozen off-source spectra can therefore change arbitrarily on a complement. The true derivative remains

    DQ(x)y=b(x,y)+b(y,x)=2S_Q(x,y).

This algebra does not claim every realization preserves a separately declared control interface or analytic norm.

## NS polarizations and actual variation

For smooth divergence-free fields,

    N(u)=P(u cross curl u)=-P((u dot grad)u),
    A_u v=P(u cross curl v),
    K_u v=P(v cross curl u).

Both satisfy `A_u u=K_u u=N(u)`, but

    DN(u)v=A_u v+K_u v
          =-P((u dot grad)v+(v dot grad)u).

A differentiable solution family therefore has variation

    v_t=nu Delta v+A_u v+K_u v.

Freezing either occurrence alone is not differentiation of the source.

In critical coordinates, Lambda=(-Delta)^(1/2), S=curl Lambda^-1, w=Lambda^(1/2)u,

    C_w v=Lambda^(1/2)P[(Lambda^-1/2 w) cross Lambda^(1/2)v].

The common-source law `C_w Lambda^-1 v=-C_v Lambda^-1 w` gives

    DQ(w)v=C_w S v+C_v S w
           =[C_w S-C_(Lambda S w)Lambda^-1]v.

Both displayed source factorizations reproduce Q on w; their sum is the true derivative.

## Beltrami exact control

On the 2pi torus, `E_lambda={u:curl u=lambda u}`. If u0 belongs to this eigenspace, `N(u0)=0` and

    u(t)=exp(-nu lambda^2 t)u0

is an actual global smooth NS solution. For u,v in the same eigenspace,

    A_u v=lambda P(u cross v),
    K_u v=-lambda P(u cross v),
    DN(u)v=0.

For p=e1, q=e2 and helical vectors

    h_p=(0,1,i)/sqrt2,
    h_q=(-1,0,i)/sqrt2,

plus conjugate negative modes for real fields, the k=p+q output satisfies

    h_p cross h_q=(i,-i,1)/2,
    Pi_-(k)(h_p cross h_q)
      =[i(1-1/sqrt2),-i(1-1/sqrt2),1-sqrt2]/4 !=0.

The frozen A term produces opposite-helicity output; K cancels it exactly. The actual family `exp(-nu t)(u+epsilon v)` remains positive helicity. Unequal curl lengths are a different case.

## Complete variational ancestry

For F(u)=Lu+S_Q(u,u), and mixed parameter derivatives U_I of a differentiable family on a common classical interval,

    d_t U_I = [L+2S_Q(u,-)]U_I
              + sum_(empty!=J proper subset I) S_Q(U_J,U_(I\J)).

For affine initial data U_i(0)=h_i and higher U_I(0)=0. The empty and full product-rule subsets give the true linearized generator. Alternating changes cancel at every order. No convergence of an infinite Taylor series or global continuation is inferred.

## Compatible CRT records

Let `C_m=lcm(1,...,m)`, C0=1, `O_m=Z/C_m Z`, with reduction `r_m:O_(m+1)->O_m`. For `P_n=prod_(m<n)O_m`, define

    (Delta_n x)_m=x_m-r_m(x_(m+1)).

The map

    Phi_n(x)=(x_(n-1), Delta_n x)

is an isomorphism to `O_(n-1) x prod_(m<n-1)O_m`. Its inverse reconstructs downward by `x_m=e_m+r_m(x_(m+1))`. Therefore

    ker Delta_n ~= O_(n-1),
    |ambient histories|=prod_(m<n)C_m,
    |compatible histories|=C_(n-1).

At n=4 the capacities are 1,1,2,6: 12 independent records but only 6 coherent histories. Uniform endpoint gives uniform marginals but joint entropy `log C_(n-1)`, not `sum log C_m`. Relative entropy against the independent product is the difference of these entropies.

The previous integer identity delta(n)=prod_(m<n)C_m remains a correct ambient-product identity. It does not count the coherent observation image and does not imply the harmonic/Chebyshev growth theorem or RH.

## Completion is larger than the original source image

The inverse limit of these residue rings is Z-hat. Write `C_m=2^(a_m)b_m`, b_m odd, and choose by CRT

    x_m=0 mod 2^(a_m),
    x_m=1 mod b_m.

This coherent profile has every finite prefix realized by an ordinary integer. A single integer realizing all levels would be divisible by every power of 2, hence zero, while also congruent to one mod3: impossible. Its fibre over the embedding Z->Z-hat is empty despite all finite compatibilities.

This does not refute a compact positive-measure argument on its declared weak-star compact fixed-mass source class. It warns that the admissible class must remain attached: smooth NS histories, generalized limits and their completions are different objects.

Repository source loci cited in the original user note: `ActionResidual.agda`, `Pairfield/DependentRootedHistoryFiber.lean`, and `FrontierIsWellFormed.agda`. The corrected statements preserve the earlier scoped symmetric all-history cubic NS calculations and source-specific return identities.
