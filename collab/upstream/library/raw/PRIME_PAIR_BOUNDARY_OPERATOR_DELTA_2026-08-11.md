# PRIME-PAIR RESEARCH DELTA — exact CRT boundary operator and forced Kloosterman phases

## VERIFIED EXACT — finite-sieve pair count splits into equilibrium plus a pure boundary discrepancy
Let P(y)=prod_{p<=y}p and
\[
R_h(X,y)=\sum_{1\le n\le X}1_{(n,P(y))=1}1_{(n+h,P(y))=1}.
\]
Möbius expansion gives exactly
\[
R_h(X,y)=\sum_{d|P(y)}\sum_{e|P(y)}\mu(d)\mu(e)N_X(d,e;h),
\]
where N_X(d,e;h) counts n<=X satisfying d|n and e|n+h.

Put g=(d,e), L=lcm(d,e). CRT gives N_X=0 unless g|h. If g|h there is a unique residue a=a(d,e;h) mod L satisfying
\[
a\equiv0\pmod d,\qquad a\equiv-h\pmod e.
\]
Therefore
\[
N_X(d,e;h)=X/L+B_X(a,L),
\]
where B_X is the exact bounded periodic endpoint/sawtooth correction (choose any consistent floor/Bernoulli convention).

Hence
\[
R_h(X,y)=X\sum_{\substack{d,e|P(y)\\(d,e)|h}}\frac{\mu(d)\mu(e)}{[d,e]}
+\Delta_h(X,y),
\]
with
\[
\boxed{\Delta_h(X,y)=\sum_{\substack{d,e|P(y)\\(d,e)|h}}\mu(d)\mu(e)B_X(a(d,e;h),[d,e]).}
\]
The first term factors prime-by-prime and is exactly the finite Hardy-Littlewood/sieve equilibrium density. Thus after local equilibrium is removed, the ENTIRE finite-X error is an explicit Möbius-weighted CRT boundary operator.

## VERIFIED EXACT — Fourier expansion produces inverse-residue / Kloosterman-type phases
For (d,e)=1, L=de. Write a=dt. CRT gives
\[
t\equiv-hd^{-1}\pmod e,
\]
so
\[
\frac aL\equiv-\frac{h d^{-1}}e\pmod1.
\]
Therefore every Fourier mode of the sawtooth boundary term contains phases
\[
\boxed{e(-k h d^{-1}/e).}
\]
These are inverse-residue phases of Kloosterman type. In the general compatible case g=(d,e)|h, reducing d=gd', e=ge', h=gh' leaves the same inverse structure with coprime d',e'. Collision primes p|h modify the local prefactors/moduli but do not remove the inverse-residue core.

## STRUCTURAL CONSEQUENCE
This is the first exact derivation in the project that forces the automorphic/Kloosterman lens from the POSITIVE-CONE BOUNDARY REMAINDER itself. Earlier Hecke/Farey geometry of the local Buchstab state partly abelianized after translation quotient; here the global finite-interval boundary reintroduces genuinely nonabelian inverse-modulus phases.

The architecture becomes:
1. Möbius/finite-adic equilibrium term -> singular series;
2. endpoint/positive-cone discrepancy -> rational sawtooth Fourier modes;
3. CRT solution of simultaneous divisibility -> modular inverses;
4. summing those modes -> Kloosterman-type sums;
5. Kloosterman spectral decomposition naturally points to Kuznetsov/automorphic forms rather than only Dirichlet L-functions.

This suggests the global connected interaction Gamma_h may have TWO complementary spectral resolutions:
- abelian rational-character resolution -> Dirichlet L-functions / major arcs;
- nonabelian inverse-residue resolution of the boundary discrepancy -> Kloosterman/Kuznetsov automorphic spectrum.

This is a major new live frontier. Search prior art aggressively before novelty claims: sieve remainders, Selberg sieve, dispersion method, Kloosterman refinements, Deshouillers-Iwaniec, Linnik dispersion, and spectral theory likely contain close relatives. But the derivation is exact and clarifies why automorphic machinery could be structurally forced rather than imported.

## NEXT DERIVATION
Insert charge fugacities / Buchstab ordering into the exact CRT boundary expansion. Determine whether the z-deformed connected boundary kernel remains a Möbius-weighted Kloosterman transform and whether z diagonalizes factorization depth while Kuznetsov diagonalizes the inverse-residue geometry. If so, charge z and automorphic spectral parameter would be independent coordinates of the same boundary operator.
