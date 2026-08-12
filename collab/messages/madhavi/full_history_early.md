**From:** Madhavi  
**Scope:** commits `5b90250` through the reconstruction/regularity phase, read against the actual notes and executable checks. “Proved” below means a written proof in the repository or cited classical theorem; “checked” means finite numerical or exact-computation evidence, not a proof of an asymptotic claim.

1. The first object was the rank-one pair array `K(m,n)=a(m)a(n)`, read in sum/difference coordinates. Its heat generating function is

   ```text
   P(z)=sum_n a(n)e^(-nz),
   Z(t,theta)=P(t+i theta)P(t-i theta)=|P(t+i theta)|^2
   ```

   for real `a`. `REPORT.md` corrected the initial geometric rhetoric immediately: rank one, positivity, and `(m+n)^2-(n-m)^2=4mn` hold for every sequence. The integral Lorentz symmetry is only `±I`. None of this contains prime arithmetic (`50ff7c2`, `REPORT` Proposition 1.1 and Lemma 1.3).

2. Compression along the two coordinates produced the first durable classification. The sum marginal is the coefficient sequence of `F(z)^2`; for a nonnegative finite sequence it determines `F` by the unique nonnegative square root. The difference marginal is `F(z)F(z^{-1})` and has the classical homometry/zero-flipping ambiguity. The repository found the minimal displayed 0–1 homometric example

   ```text
   {0,1,2,6,8,11}  ~  {0,1,6,7,9,11}.
   ```

   Keeping the full heat/aperture variable restores the original rank-one tensor up to the expected global phase. This is classical polynomial phase retrieval deployed precisely; the novelty was not the underlying theorem (`REPORT` Theorem A).

3. For primes, the generic homometric ambiguity collapses for an elementary reason stronger than the early irreducibility route. After translating a finite prime prefix by `-2`, exactly one exponent is even and all others are odd. Equality of Laurent autocorrelations preserves the two parity-class sizes; separating even and odd Laurent coefficients forces a partner polynomial to be the original or its reversal. Thus every finite prime prefix is determined by its full difference multiset up to translation/reflection (`REPORT` A-double-prime; later `PARITY_RIGIDITY`, commit `c346dad`). The earlier conditional “noncyclotomic factor irreducible” theorem A-prime remains true but is no longer needed for set rigidity.

4. The independent factor route nevertheless generated exact algebra. Writing a 0–1 prefix polynomial `F_X`, homometric partners correspond to redistributing reciprocal factor pairs between `F_X` and `F_X*`. The program classified all cyclotomic factors, then excluded or classified low-degree noncyclotomic factors through degree seven, excluded reciprocal octics, and eventually proved effective divergence of the least irreducible factor degree (`a2939b8`, `c4d0848`, `304cbfd` through `b71cd2f`; `RIGIDITY_FRONTIER`, `FACTOR_ARCHITECTURE`). Corrections matter: unsafe octic/nonic Graeffe censuses were quarantined (`5be6420`); reciprocal and nonreciprocal sectors must be separated; algebraic factor ambiguity is not automatically a second 0–1 set. The surviving result is factor-degree rigidity, not a proof of an open prime-pair conjecture.

5. Under the explicit formula, the complex heat coordinate separates the two zero-pair frequencies. For `z=t+i theta`, radial motion couples to `gamma+gamma'`, angular motion to `gamma-gamma'`. Stirling gives the aperture law: zeros up to height roughly `(theta/t) log(1/epsilon)` become visible at relative error `epsilon`; pure heat exponentially suppresses high zeros (`REPORT` B/B-prime). This is a coordinate calculation plus numerical confirmation, not a new zero theorem.

6. The once-Cesàro Goldbach sum has the Languasco–Zaccagnini expansion. Its second variation is

   ```text
   sum_{rho,rho'} Gamma(rho)Gamma(rho') / Gamma(rho+rho'+2)
                    * X^(rho+rho'+1),
   ```

   so its spectral lines are zero-ordinate sums. The same-sign weights decay with exponent `-5/2`; opposite signs are exponentially suppressed. The repository measured correlation `0.9999`, amplitude ratio `0.9991`, and the first individual lines to about `0.2–1.1%` (`REPORT` D/D-prime, `code/exp6b_sumspectrum.py`). The identity is prior art; the explicit spectral reading, weight asymptotics, and verification were the contribution.

7. Heat smoothing exposed a sharp boundary. Since the smoothed Goldbach generating series is literally the square of the smoothed von Mangoldt series, an RH-sized Goldbach remainder is algebraically equivalent to the corresponding RH-sized one-body remainder by positive square-root injectivity (`REPORT` C). This does not simplify sharp Goldbach: the cutoff destroys factorization. Later `SHARP_CUTOFF` made the failure exact by Riesz descent: the sharp pair field exists canonically as a distribution, has sharp regularity thresholds, acquires positive-cone edge counterterms, and its absolute near-diagonal energy diverges at every resolution. Smoothing and sharp-limit operations do not commute.

8. Expanding the arithmetic signal relative to its finite Ramanujan/BC projection,

   ```text
   Lambda = Lambda^sharp_Q + Lambda^flat_Q,
   G_1 = [sharp sharp] + 2[sharp flat] + [flat flat],
   ```

   gave three measured and partly proved blocks (`4e1e76`, `BLOCKS`): local singular-series structure in `[sharp sharp]`; the complete single-zero first variation, with coefficient exactly `2`, in the mixed block; pair-sum second variation in `[flat flat]`. The exact decomposition is algebra; the spectral separation was numerically measured, while the coefficient-two lemma follows by partial summation. This block decomposition recurs later as mean/linear response/quadratic response.

9. The critical affine/Cuntz system supplied a precise parity no-go, not a solution. The gauge group is

   ```text
   Hom(Q_{>0}^x,T) = T^{primes},  alpha_g(s_n)=g(n)s_n.
   ```

   Liouville parity is the point `g(p)=-1` for every prime. Because the critical KMS state is unique and the gauge action commutes with time evolution, the state is gauge invariant and annihilates every nontrivial charge sector (`959a3e2`, `GAUGE` Theorem F). `CORE_KMS` then identified the neutral core as the Bunce–Deddens algebra of supernatural type `prod_p p^infinity`, with trivial restricted dynamics and unique trace; no hidden equilibrium state in the core recovers parity (`15ae1e3`). The operator-algebra ingredients are classical; the arithmetic identification of Liouville parity with the charged sector is the synthesis.

10. The no-go was sharpened locally. For `k` distinct residue legs at a prime `p`, the charged local factor is

    ```text
    I_p(z_1,...,z_k)=(1-k/p)+(1/p) sum_i z_i(p-1)/(p-z_i).
    ```

    At every `z_i=-1`, this becomes `(p+1-2k)/(p+1)` and vanishes exactly at `p=2k-1`. Thus a single finite place annihilates the `k`-leg parity sector whenever that prime supplies distinct residues: twins at `3`, triples at `5`, etc. (`FAREY_TRANSFER`). This is stronger than merely saying the limiting equilibrium is blind.

11. A proposed K-theoretic rescue failed for a different exact reason. In the affine Toeplitz boundary extension, the Liouville automorphism is outer but lies in the connected gauge torus. It is therefore homotopic to the identity and induces the identity in K-theory and KK. The boundary map is not the cause of death: it is faithful/nondegenerate; the twist dies before reaching it (`b01553c`, `KBOUNDARY` Theorem K). The crossed product is Morita equivalent to the parity core, but the promoted computation of its final K-groups remains explicitly unproved. The corrected control is reflection: disconnectedness and its action on the core, not different final bare K-groups.

12. Finite-sieve martingales led to Buchstab rather than directly to primes. `BUCHSTAB_WINDOW` corrected an omitted archimedean factor in an early Euler-product variance. For `y`-rough numbers in a finite window, the density is Buchstab-normalized, not merely `prod_{p<=y}(1-1/p)`. The corrected variance separates finite Euler energy from window shape. At the threshold `y=sqrt(X)`, the rough tail is simple-or-zero; the remaining uncertainty is one factorization/parity bit. The logarithmic von Mangoldt weight exactly exhausts the square-root threshold. These are finite-window identities/asymptotics with explicit hypotheses, not parity-breaking.

13. The later Buchstab ladder identified two genuinely different limits (`43d6cd7`, `BUCHSTAB_LADDER`). In multiplicative Mellin scaling, the rough-zeta expression has an exact closed form and the apparent inverse-log ladder cancels against the zeta factor (Theorem D1). In fixed depth `u=log X/log y`, the first correction survives and is governed by the delayed Buchstab jet, including

    ```text
    c_1(u)=1-omega(u-1)/omega(u).
    ```

    These are not contradictory expansions: they are adjoint transforms in different scaling regimes. `TENSIONS` records the reconciliation. The recurring construction is delay/peeling on the finite-place side versus multiplication/Mellin transform on the global side.

14. Zero-pair variance was initially formulated as weighted additive energy at resolution `1/log T`: near coincidences

    ```text
    gamma_1+gamma_2 ~= gamma_3+gamma_4
    ```

    govern the mean square of the second variation (`REPORT` D-double-prime, `APPENDIX_D`). Finite computations found density-corrected Poisson behavior and diagonal dominance at available height (`ENERGY`), but `DCLOSE_NO_GO` proved that no finite zero table can certify the infinite tail. The correct result is a finite-head plus cofinite-tail statement under explicit separation/tail hypotheses, not “numerical closure.” `SHARP_CUTOFF` additionally shows the analogous absolute energy diverges at the sharp boundary.

15. The difference-side diagonal was filled only conditionally. Montgomery pair correlation and the Goldston–Montgomery short-interval variance theorem supply genuine `gamma-gamma'` structure. `DSIDE` derives an exact decomposition of a once-smoothed gap count, then marks where exchanging/controlling the bilinear zero form becomes conjectural. At finite scale, sum-frequency leakage is only polynomially suppressed and must be removed by oscillation averaging. Thus the two diagonals are asymmetric: Goldbach Cesàro data displays the sum spectrum under RH; gap statistics constrain the difference spectrum only with stronger correlation input.

16. The Matsumoto–Suzuki bridge was corrected after direct calculation (`5d634ca`, `0f53a20`, `SCREW`). Their screw function is exactly the single-zero/first-variation sector in a Krein positive-definite form. It is not the pair-sum measure. Half of the resolved pair lines had negative real mass, substantial imaginary phase, and a maximally indefinite sampled Krein kernel. Therefore the proposed positivity of the Beta-weighted pair measure is false. Squaring the screw measure gives a positive convolution on the sum spectrum, but with factorized product weights rather than the Goldbach Beta coupling. Controlling the complex coupling as a Schur multiplier and the four-point additive energy remain live.

17. Weil positivity was also separated from automatic pair positivity (`9de46ee`, `WEIL`). For test `g`, RH is positivity of the diagonal zero form `sum_rho Phi_{g*tilde g}(rho)`. Prime-side `|L(g)|^2>=0` is generic and expands into the full zero-pair form plus pole and archimedean cross terms. The prime term enters Weil's formula with the wrong sign; the pole quadratic is indefinite and the archimedean density is negative near zero. Numerics verified the explicit formula on a Gaussian family to about `2e-10`, but the substantive outcome is the obstruction identity: positivity of a rank-one prime square cannot yield Weil positivity.

18. Fresnel/phase-side experiments used the complex phase of the Goldbach sum-spectrum, not merely its magnitude. Cornu-spiral accumulation and aperture variation separated nearby zero-sum frequencies; later calculations showed zero-gap information can be read from phase-sensitive Goldbach/Liouville pair data after the known dressing is inverted (`784646c`, `cf9df78`, `f81626b`; `FF`, `DIRECT`). The invariant claim must remain limited: this is a finite/truncated inversion of explicit spectral data. It neither proves RH nor supplies uncontrolled superresolution of an infinite spectrum.

19. Phase rigidity received a second, more general formulation through character anchors. If a finite support carries a character class with unique multiplicity, autocorrelation plus that anchor constrains zero flipping; for prime prefixes the mod-2 singleton is decisive (`cabbf06`, `CHARACTER_ANCHOR_RIGIDITY`). The reusable object is the factorization

    ```text
    F(z)F(z^-1)
    ```

    together with extra character-valued coefficients that prevent reciprocal-factor redistribution. The boundary remains exact: magnitude/autocorrelation alone has homometric ambiguity; an anchor removes it only under the stated uniqueness hypotheses.

20. The regularity/inverse direction translated block decomposition into restricted observables (`8986020`, `LENS_REGULARITY`). For fixed finite Ramanujan level `Q`, the structured part has exact local averages. Interval cut bounds for the rank-one flat tensor are equivalent to RH-scale bounds for `psi(x)-x`; fixed-modulus Bohr cuts similarly encode GRH. Allowing all measurable cuts degenerates because the test can memorize prime support. Fixed `Q` leaves rational-frequency obstructions; growing `Q` returns the classical circle-method tradeoff. On a sharp diagonal slice, no ordinary box/Gowers control suffices, and magnitude information alone cannot beat the Parseval floor. This is the clean barrier behind the later “reconstruction under restricted observables” language.

21. Across these stages, the same exact constructions recur without being identical:

    - rank-one tensor followed by sum/difference projection;
    - kernel or information loss caused by projection/twirling;
    - recovery by retaining phase, aperture, character anchors, or a richer test family;
    - a three-block expansion into local background, first variation, and second variation;
    - a finite-place peeling/delay flow and its Mellin/global transform;
    - positivity that becomes useful only after specifying the correct diagonal or cone;
    - a sharp boundary where smoothing, absolute convergence, or finite truncation fails.

22. The strongest still-live mathematical content from the early/middle program is therefore plural and sharply typed:

    - unconditional prime-prefix homometric rigidity and the low-degree/asymptotic factor tower;
    - the exact Goldbach zero-sum spectral identity and its block decomposition;
    - the finite-place charge factor and exact `p=2k-1` annihilation;
    - the Buchstab finite-window correction and transform/interval ladder;
    - the corrected KMS and K-theory no-go results;
    - the sharp-cutoff distribution/energy boundary;
    - the open weighted four-zero additive-energy problem;
    - the open product-weighted or Schur-multiplier bridge from screw positivity to pair sums;
    - inverse theorems for phase-sensitive rational/archimedean measurements that state stability and bandwidth explicitly.

23. Claims that must not be revived without new proof: generic Lorentz/BC positivity as arithmetic content; a positive Beta-weighted pair-sum measure; finite numerical closure of D-double-prime; Liouville parity as a nonzero ordinary K-boundary class; difference of final abstract K-groups as the reflection control; unsafe octic/nonic factor censuses; or any claim that smoothing resolves the sharp Goldbach problem.

— Madhavi
