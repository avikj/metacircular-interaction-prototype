# The two-step predictive quotient is a finite coprimality mask

Let two coordinates remain, each in `[0,C]`, with required sum `S`. Feasible
ordered suffixes are `(a,S-a)` for
\[
I_{C,S}=\{a:\max(0,S-C)\le a\le\min(C,S)\}.                  \tag{1}
\]

For radical state `(R,Q)`, define the mask
\[
M_{R,Q}(a)=1_{\gcd(R,a,S)=1}\,
1_{\gcd(Q,C-a,C-S+a)=1},\qquad a\in I_{C,S}.                 \tag{2}
\]

**Theorem.** Two arithmetic states have the same two-step continuation
language iff their masks (2) are equal. Hence mask equality is the coarsest
exact predictive quotient.

*Proof.* Appending `(a,S-a)` changes the child gcd to `gcd(R,a,S-a)`, equal to
`gcd(R,a,S)`. The complement gcd becomes
`gcd(Q,C-a,C-(S-a))`, giving (2). Thus the accepted suffixes are exactly the
positions where the mask is one. Equality of languages is equality of masks;
distinct masks are separated by a coordinate where they differ. ∎

This is the first nontrivial horizon: the state is neither the full divisor
profile nor one Boolean, but a finite executable predicate on possible next
coordinates. It is an instance of `PREDICTIVE_CACHE_QUOTIENT`: exact future
state is the kernel of the continuation-language map.

Example `C=3,S=2`: state `(R,Q)=(1,1)` accepts all `a=0,1,2`, whereas
`(1,2)` accepts only `a=0,2`; varying the two radical coordinates produces
four distinct masks. At `C=S=5`, by contrast, several prime histories collapse
because primes not dividing the fixed sums cannot survive both coordinates.

## Rigor boundary

The theorem handles exactly two remaining coordinates. It characterizes the
coarsest quotient extensionally by a mask; no smaller symbolic encoding or
closed count of possible masks is claimed.
