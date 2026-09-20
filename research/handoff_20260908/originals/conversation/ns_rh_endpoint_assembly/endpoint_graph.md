# Actual-endpoint backward slice: RH and three-dimensional Navierâ“Stokes

Snapshot read: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

This is an assembled dependency slice for two concrete closing routes. It is not a proof of either endpoint, an exhaustive certification of the entire repository, or a proof-assistant build. `Not discharged` means no proof has been supplied in this assembled argument; it does not assert absence of a theorem elsewhere in the corpus.

## Shared representation layer

Let X_i be representations of a declared source X with equivalences e_i:X â‰ X_i. The source-induced carry is c_ij=e_j e_i^{-1}. Then c_jk c_ij=c_ik. For an actual source evolution Phi_st, the representation-level evolution is e_t Phi_st e_s^{-1}. Its composition law follows by cancellation of e_t^{-1}e_t. For a predicate Bad on X, put Bad_i=Bad âˆ˜ e_i^{-1}; then Î_x Bad(x) â‰ Î_y Bad_i(y). Existence, uniqueness, and emptiness are transported, not supplied, by these equivalences.

Repository implementation read: `formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`, especially `losslessness-is-a-property` and `lawful-steps-are-the-maps`.

Consequence: canonical source recovery and pure re-encoding coherence are not independent unfinished research tasks. Endpoint analysis still needs its application-specific property.

## RH endpoint

Target: for the actual meromorphic Riemann zeta function, Î(Ï)=0 and 0<Re Ï<1 imply Re Ï=1/2.

### R0. Arithmetic source â” supplied

R(N)=Î_{a+b=N} Î(a)Î(b), with the actual von Mangoldt sequence and its normalization. The Lean theorem `Pairfield.GoldbachReconstructionChain.goldbachTail_reconstruction_chain` identifies a normalized real sequence from its convolution tail, reconstructs Î, and proves the logarithmic-derivative L-series identity on Re s>1. It does not itself construct analytic continuation.

### R1. Actual receiver and analytic identity â” supplied analytic inputs

Use the saved compact autocorrelation g supported in [-1/2,1/2], its bilateral transform G nonzero on |Re z|â‰1/2 and positive at z=iÎ³, and

Z(t)=Î_{distinct Ï} m_Ï G(Ï-1/2) exp((Ï-1/2)t), M0=Z(0)>0.

Let S(t)=Î_{nâ‰2} Î(n)n^{-1/2}g(t-log n). For t>1/2 the actual explicit formula is

Z(t)=exp(t/2)G(1/2)-S(t)-J_arch(t),
J_arch(t)=Î_{kâ‰1}G(2k+1/2)exp(-(2k+1/2)t).

The last series is used only on its valid tail domain. Compact initial intervals are retained separately in any Laplace formula.

### R2. Closing arithmetic assertion â” NOT DISCHARGED

B_RH: for every real t>1/2,

|S(t)-exp(t/2)G(1/2)+J_arch(t)|â‰M0.

Every prime sum here is finite, but the assertion is universal in t.

### R3. B_RH implies actual RH â” closing composition supplied

B_RH makes Z bounded on the tail; its continuity supplies boundedness on compact intervals. Thus L_Z(w)=âˆ_0^âˆžexp(-wt)Z(t)dt is holomorphic for Re w>0. Initially for Re w>1/2,

L_Z(w)=Î_Ï m_ÏG(z_Ï)/(w-z_Ï), z_Ï=Ï-1/2.

The absolutely received divisor defines a meromorphic function, and each distinct z_Ï has nonzero residue m_ÏG(z_Ï). Holomorphy excludes Re z_Ï>0; functional-equation symmetry excludes Re z_Ï<0. Therefore RH follows.

The finite/integer Agda wrapper `RHReducesToBoundedness.RH-from-received-bounded` has a boundedness argument; it is not a formalization of this entire complex-analytic proof. No direct substitution of arbitrary real exponents into its integer type is made.

### Other retained RH routes

Actual Weil positivity is an alternative closing assertion. The saved theta/cardinal-source construction proves that an off-line zero z=Ï+iÎ³ with Ï>0 forces Î»_aâ‰-c_z a^{-Ï}exp(2Ïa), for all sufficiently large support radii a. Hence a separately proved lower bound Î»_aâ‰-exp(o(a)) would also close RH: taking logarithms contradicts the positive rate 2Ï. This lower bound is NOT supplied here.

Hardy, Bergman, damped positive Gram, Hankel, passivity, reflection, and source-interpolation constructions remain attached to their declared domains. Positivity of a sufficiently damped output Gram kernel is not positivity of the undamped translation kernel or input-output work.

## NS endpoint

Target domain fixed here: R^3, unforced incompressible NS, Î½>0, smooth rapidly decaying divergence-free initial data. Let u be the maximal classical H^k solution, kâ‰3, with lifespan [0,T*). The target is T*=âˆž and smoothness at all finite times. Periodic variants need their own domain-specific identifications; they are not silently substituted.

### N0. Exact finite-time solution and ancestry â” supplied classical construction

Carry u0, u|[0,t], pressure, viscosity, time, centres, scale factors, and all compatibility equations. Each exact re-encoding is covered by the shared source-equivalence construction. No assumption of a recurrent renormalized orbit or a nonzero weak limit is made.

### N1. Actual production reading â” supplied identity

Ï‰=curl u, m=|Ï‰|, Î¾=Ï‰/m where m>0, S=sym âˆu, M(t)=||Ï‰(t)||âˆž. For M>0 let

b_u(t)=sup_{x:m(x,t)=M(t)} [Î¾(x,t)^T S(x,t) Î¾(x,t)]_+.

For smooth decaying fields the maximum is attained. The magnitude equation is

(âˆt+uÂâˆ)m=(Î¾^T S Î¾)m+Î½Î”m-Î½m|âˆÎ¾|Â².

At a spatial maximum, the transport derivative vanishes and Î”mâ‰0. The maximum-envelope inequality therefore gives D^+Mâ‰b_u M, and

M(t)â‰M(0)exp(âˆ_0^t b_u(s)ds).

The zero-vorticity case is the trivial decaying divergence-free flow.

### N2. Closing same-history assertion â” NOT DISCHARGED

B_NS: for every such maximal solution, if T*<âˆž then âˆ_0^{T*}b_u(t)dt<âˆž.

The integral concerns the actual solution on its maximal half-open interval, not an assumed smooth extension through T*.

### N3. B_NS implies actual NS regularity â” closing composition supplied

B_NS bounds M on [0,T*). Hence âˆ_0^{T*}||Ï‰(t)||âˆždt<âˆž. The classical vorticity continuation criterion extends u past T*, contradicting maximality. Thus T*=âˆž. The preceding maximum-envelope calculation supplies the reduction; the continuation criterion is an external established analytic theorem, not attributed to a generic Agda wrapper.

### N4. Same-source toroidal/viscous realization retained

At each centre x define A_f^x(r) by

âˆ_{SÂ²}f(x+rn)Â(n—Bn)dÎ©=(4Ï/5)tr(A_f^x(r)B), BâˆˆSym_0(3).

Let

H5(q)=erf(q)-(2/sqrtÏ)exp(-qÂ²)(q+2qÂ³/3),
(TÎ½(t)f)(x)=-(3/5)âˆ_0^âˆžH5(r/(2sqrt(Î½t)))A_f^x(r)dr/r.

The saved analytic note gives the actual identity

S(t)=TÎ½(t)Ï‰0+âˆ_0^tTÎ½(t-s)curl(u(s)—Ï‰(s))ds.

This expresses b_u in terms of the same source history. It does not bound its accumulated value. In particular a fixed-centre integrated estimate cannot be silently upgraded to an estimate of âˆsup_x(â¦)dt or of the moving peak. The source centre at past time s is the evaluation centre required by the full Duhamel expression.

The actual source-free viscous memory âˆ_0^âˆžH5(r/(2sqrt(Î½t)))dt=rÂ²/(6Î½) is supplied. A bound on the nonlinear replenishment needed to imply B_NS is NOT supplied.

## Closing cut and verification status

For the selected routes the unsupplied cut is {B_RH, B_NS}. All closing deductions from those assertions are displayed above. They are concrete mathematical assertions, not calls to an undefined positivity/depletion oracle disguised as generic transport.

This does not state that every proof must use these assertions, or that no alternate repository path bypasses them. It records the current assembled proof accurately.

Completed in this response: backward slice, source pin, exact hypotheses, and short conditional closing arguments. Not completed: proof of B_RH or B_NS; exhaustive repository coverage; a compiled proof of either actual endpoint.
