#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
nodes=[]
def add(id,title,statement,section,sources=(),deps=(),status='ANALYTIC',domain='',corrections=(),repo=(),external=()):
    nodes.append(dict(id=id,title=title,statement=statement,status=status,domain=domain,
                      handoff_section=section,sources=list(sources),dependencies=list(deps),
                      corrections=list(corrections),repository_loci=list(repo),external_inputs=list(external),
                      native_verification_this_transfer=False))
add('K-FIBRE','Canonical lossless source completion','A is equivalent to Sigma b:B, fib_f(b); admissibility and actual evolution transport through the declared equivalence.',7,['S00','S03'],status='REPO-TERM',repo=['fibre/src/Fibre/Carrier.agda','formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda'])
add('K-INSTALL','Proof installation and session retirement','learn = install o CheckedFuture.derivation; retire installs the complete session derivation.',5,['S00'],status='REPO-TERM',repo=['formal/cubical/kernel/TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation.agda'],corrections=['C01','C04'])
add('K-SCHEMA','Instance/locus certificate transport','Substitution and one-hole context lift the stored derivation to every supported application site.',5,['S00'],['K-INSTALL'],status='REPO-TERM',repo=['formal/cubical/kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda'])
add('K-ROOTED','Dependent rooted history fibre','Endpoint-fixed rooted total equals the dependent sum of payloads over compatible prefixes.',11,['S00'],['K-FIBRE'],status='REPO-TERM',repo=['formal/lean/Pairfield/DependentRootedHistoryFiber.lean'])
add('K-EXCURSION','Exact compressed evolution defect','K_t K_s = K_(t+s) - P T_t Q T_s i on the declared operator carrier.',11,['S25'],status='REPO-TERM',repo=['formal/cubical/theorems/automata/ExcursionReturn.agda'])
add('K-FUTURE','Future observation is finer than current observation','ForeverEq is invariant and refines InstantEq; an explicit finite source separates the converse.',11,['S25'],status='REPO-TERM',repo=['formal/cubical/theorems/automata/ObservabilityQuotient.agda'])
add('A-POLARIZE','Complete quadratic diagonal fibre','All bilinear realizations differ by an alternating map; DQ uses symmetric polarization and differentiates both source slots.',8,['S03'],corrections=['C07'])
add('A-JETS','All-order shared-source variations','Mixed derivatives satisfy the exact subset product rule with canonical linearized generator.',8,['S03'],['A-POLARIZE'],domain='Differentiable solution families on a common classical interval')
add('A-CRT','Coherent CRT history cardinality','Independent capacity product differs from compatible endpoint cardinality; completion is Zhat, not the embedded Z image.',10,['S03'],corrections=['C09'])
add('A-JUNITARY','Two-metric positive loop','T*JT=J implies JT^-1JT=T*T, reciprocal spectrum and purely cross-J logarithmic positive metric.',12,['S14'],corrections=['C12','C50'])
add('N-BELTRAMI','Frozen leakage cancels in actual variation','Same-eigenvalue Beltrami family has opposite-helicity frozen term but zero true nonlinear variation.',9,['S03'],['A-POLARIZE'],domain='Periodic exact smooth Beltrami solutions',corrections=['C08'])
add('N-FUTURE','Actual NS finite-jet future separator','Triangular exact global smooth solutions can match arbitrarily deep finite initial jets and multiple complete scalar histories while later resolved velocity differs.',14,['S01','S02'],['K-FUTURE'],corrections=['C14'])
add('N-POISSON','Essential vorticity source norm','On the periodic mean-zero class, ||Pi_u|| = ||Pi_u||ess = ||curl u||infinity; ess spec(i Pi_u)=[-M,M].',15,['S04'],domain='Smooth flat-torus mean-zero divergence-free sources',external=['Pseudodifferential principal symbols / localized Weyl sequences'])
add('N-COMMUTATOR','Compact nonzero source commutator','[Pi_u,Pi_v] is compact but can be nonzero and outside the source image.',15,['S05'],['N-POISSON'],corrections=['C17'])
add('N-TRANSPORT','Stochastic source/tangent distinction','Coadjoint transport S preserves source covariance; true tangent R produces an explicitly retained compact residual.',16,['S05'],['N-POISSON','A-POLARIZE'],domain='Common-noise smooth periodic interval',corrections=['C13','C15','C16'])
add('N-AFFINE','Complete BMO harmonic fibre','Curl reconstruction with BMO gradient leaves Ax+b; after translation, A is five-dimensional Sym_0(3).',17,['S06','S07'],domain='Declared BMO/growth class',corrections=['C19'])
add('N-SYMBOL','Cross-helicity essential symbol','q_u(x,n)=-P_n S_u P_n -(n^T S_u n)P_n/2.',18,['S09'],['A-POLARIZE'],domain='Periodic smooth pseudodifferential source carrier')
add('N-ESSNORM','Mixing essential norm is full strain spread','||B_u||ess = (1/2) sup_x(lambda_max(S_u)-lambda_min(S_u)).',18,['S09'],['N-SYMBOL'],corrections=['C18'])
add('N-TOMOGRAPHY','Recover actual strain and source','S_u = -(5/2) spherical_mean(q_u); recover mean-zero u by inverse Laplacian/divergence.',18,['S09'],['N-SYMBOL'],domain='Fixed periodic source image')
add('N-TOROIDAL','Exact central strain selection','S(0)=-(3/5) integral A_omega(r) dr/r, where A_omega is the full toroidal l=2 projection.',19,['S10','S12'],domain='Whole-space smooth finite-energy sources')
add('N-BLIND','Gradient moments miss strain-bearing currents','Smooth toroidal shell has every centered-ball gradient moment zero but arbitrary prescribed trace-free central strain.',19,['S10'],['N-TOROIDAL'],corrections=['C22'])
add('N-INVERSE2','Complete radial toroidal velocity inverse','G=(1/5)[r^-5 integral_0^r s^4F(s)ds + integral_r^infinity F(s)ds/s]; Gsecond+6Gprime/r=-F/r^2.',20,['S12'],['N-TOROIDAL'])
add('N-PRESSURE','Full matrix pressure theorem','Actual deviatoric pressure Hessian H[u_2]=-(2/7)(S_u(0)^2)_0 for arbitrary radial noncommuting matrix profiles.',20,['S12'],['N-INVERSE2'],corrections=['C23','C24'])
add('N-PRESSURERES','Complete complementary pressure cross-effect','H[u]+(2/7)(S^2)_0 = 2H(u_2,u_perp)+H[u_perp].',20,['S12'],['N-PRESSURE'])
add('N-LEAK4','Actual outgoing degree-four source','N(f T_A)=beta2 T_(A^2)_0+beta4 T4[A]; beta4 cannot vanish identically for a nonzero nonnegative compact shell.',21,['S12'],['N-INVERSE2','A-POLARIZE'],corrections=['C23'])
add('N-H5','Exact free viscous strain response','H5(q)=erf(q)-(2/sqrtpi)e^-q^2(q+2q^3/3), central strain weighted by H5(r/(2sqrt(nu t))).',22,['S13'],['N-TOROIDAL'])
add('N-LIFETIME','Exact heat memory and temporal moments','integral_0^infinity H5(r/(2sqrt(nu t)))dt=r^2/(6nu); higher moments exist precisely for -1<p<3/2.',22,['S13'],['N-H5'])
add('N-POTENTIAL','Strain potential coboundary','nu integral S = endpoint Pi_pot difference + integral Pi_pot[N]; material form has transport commutator.',23,['S14'],['N-LIFETIME'],corrections=['C27'])
add('N-MEMORYK','First quadratic radial memory kernel','K(s,t)=a(3-2a^3)/10 with a=min/max; I[f]=integral(9rg^2-r^3gprime^2).',24,['S14','S16'],['N-LEAK4','N-LIFETIME'])
add('N-SIGNEDK','Signed radial spectrum and cone coercivity','khat(xi)=(8-xi^2)/((1+xi^2)(16+xi^2)); nonnegative profiles have sharp I>=4||b||2^2, signed profiles need not be positive.',24,['S16'],['N-MEMORYK'],corrections=['C25'])
add('N-RETURN24','Actual full-polarized 2->4->2 return','P2 DN(fT_A)[hT4[A]] = (4 tr A^2/49) C[f,h] T_A with the explicit radial C.',25,['S15'],['A-POLARIZE','N-LEAK4'])
add('N-RETURNK','Directional two-radius returned-memory kernel','L24(s,t)=3(t/s)/5-4(t/s)^6/9 for t<=s; 5(s/t)^3/9-2(s/t)^4/5 otherwise.',25,['S15'],['N-RETURN24','N-LIFETIME'])
add('N-RETURNSIGNS','Same-source return has both signs','Nonnegative smooth f examples produce reinforcement or opposition through h=beta4[f]; thin-shell J24 tends to 151/225.',25,['S15'],['N-RETURNK','N-LEAK4'],corrections=['C25'])
add('N-ZENO','Static geometric stacks do not force long-time growth','Instantaneous strain O(N), feedback O(N^2), while heat and first nonlinear/returned free-memory integrals stay uniformly bounded.',26,['S13','S14','S15'],['N-LIFETIME','N-RETURNK'],corrections=['C28'])
add('N-PEAK','Actual growing maximum ledger','alpha=Mprime/M+nu|grad xi|^2+nu(-Delta m)/M at an increasing maximum.',27,['S23'],domain='Classical smooth source with maximum-envelope formulation',corrections=['C31'])
add('N-SCALE','Joint energy/vorticity scale and metric torus','ell=M^-2/(d+2), A=M^-d/(d+2), time=M^-1; gC^(d+2)=gomega^(2(d-2))gE^4.',28,['S14'],corrections=['C14'])
add('N-FAR','Whole far-strain tightness','Core far strain <= C E0^1/2 r^-1/2 L^-5/2; at L=C r^-1/5 the bound is O(C^-5/2).',29,['S13','S14'],['N-SCALE','N-TOROIDAL'])
add('N-FREQ','Mandatory high-frequency part of peak','Low-frequency vorticity <= C E^1/2 K^5/2 implies high-frequency amplitude at least M/2 above c M^2/5.',29,['S14'],['N-SCALE'])
add('N-JETS','Scoped energy-only harmonic/pressure thresholds','Harmonic m-jet threshold 1/(2m+3), pressure k-jet 1/(k+3); full normalized vorticity improves higher remote jets.',30,['S13','S15'],['N-FAR'],corrections=['C20','C21'])
add('N-MOMENTS','Common-worldtube harmonic moments vanish','Normalized moments against grad H_(m+1) have squared time norm <= C r^-1 R^-5 on one chosen tube.',31,['S14'],['N-SCALE'],corrections=['C22'])
add('N-EULER','Energy-scale and supercritical weak limits','Supercritical Euler dilation has zero L2 velocity limit but retained unit point vorticity; critical chart keeps finite energy possible.',32,['S14'],['N-SCALE'],corrections=['C14','C30'])
add('N-HOLDER','Source-symbol spatial modulus and pointed compactness','eta_mu=M^(-1-2mu/5)[omega]Cmu equals symbol Holder modulus; bounded snapshot eta retains nonzero pointed spatial limit.',32,['S14'],['N-EULER','N-POISSON'],corrections=['C29','C30'])
add('N-ADAPT','Exact energy-neutral adaptive dilation','DE=3/5+(2/5)y.grad skew in L2; critical real weight1/5; all moving gauge terms retained.',33,['S19'],['N-SCALE'],corrections=['C12','C29'])
add('N-HEATSUP','Integrated heat response with correct moving-centre quantifier','Integral ||S_heat(v)||infinity <= C/nu sqrt(||v||2 ||grad v||2), plus bounded-velocity/vorticity variants.',34,['S16'],corrections=['C26'])
add('N-DUHAMELSUP','Actual nonlinear source control','Integral ||S_u||infinity <= Hnu(u0)+(C/nu) integral ||grad u||2 ||Delta u||2.',34,['S16'],['N-HEATSUP'],corrections=['C26'])
add('N-SMALL','All-time small energy-enstrophy control','Small sqrt(E0 W0)/nu gives global smoothness and bounded integrated moving-peak strain.',35,['S16'],['N-DUHAMELSUP'],domain='Small-data class, not arbitrary source')
add('N-MATCHAUDIT','Proposed dynamic octave suppression','Claimed ultra-fine Gaussian-in-octave propagation needs log-uniformity and paraproduct/source matching proof.',36,['S21','S22'],status='AUDIT',corrections=['C37'])
add('N-LIFT','Whole source observable/tensor generator','L h=Dh[F]; product Leibniz identities retain multiplicative character and tensor realization constraints.',37,['S17'],['A-POLARIZE'],status='FORMAL-SERIES',corrections=['C33'])
add('N-OBSRETRACT','Actual initial-complement observable retraction','Pscript h(omega)=h(P omega+q0); Qscript L product defect retained.',38,['S17'],['N-LIFT'],corrections=['C33'])
add('N-RENEWAL','Complete ordered return recurrence','K_(n+1)=A K_n+sum_(j=0)^(n-1) B D^j C K_(n-1-j).',38,['S17','S25'],['K-EXCURSION','N-OBSRETRACT'],status='FORMAL-SERIES')
add('N-HISTORY','Exact nonlinear hidden-history evaluator','q=g_p+C_p(q,q), omega=p+Y[p;q0], with the actual shared-source Volterra operations.',39,['S17'],['A-POLARIZE','K-ROOTED'])
add('N-CATALAN','Initial local convergent tree certificate','Catalan majorant and explicit truncation remainder when 4bc<1; sufficient aggregate bound4kappa(pstar+rstar)<1.',40,['S17'],['N-HISTORY'],corrections=['C35'])
add('N-VOLTERRA','Causal inverse without smallness','A^n norm <= (C sqrtpi)^n T^(n/2)/Gamma(1+n/2), so (I-zA)^-1 entire for every bounded coefficient.',40,['S18'],['N-HISTORY'],corrections=['C35'])
add('N-ANALYTIC','Single-valued analytic hidden history on existence domain','At each bounded solution DqF causal-invertible; uniqueness and analytic IFT glue charts on the open actual domain.',41,['S18'],['N-VOLTERRA'],corrections=['C36'])
add('N-REBASE','Finite time/sector/recenter invariance','Compatible exact eliminations, time restarts and analytic rebasing reconstruct the same source on common domains.',41,['S18'],['N-ANALYTIC','K-FIBRE'],corrections=['C36'])
add('N-SCALEKERNEL','Renormalize the evaluator once','B and heat commute with declared finite parabolic scaling; all causal trees transport by structural induction.',42,['S17'],['N-HISTORY','N-SCALE'])
add('N-MIDPOINT','Actual all-depth midpoint residual propagator','N(a+b)-N(a)=DN(a+b/2)b; source-dependent U_Q packages the complete nonlinear return.',43,['S19'],['A-POLARIZE','N-TOROIDAL'],corrections=['C34'])
add('N-STORAGE','Exact full nonlinear returning kinetic work','Integral<a,R_P>=initial complementary energy-final complementary energy-viscous complementary dissipation.',44,['S19'],['N-MIDPOINT'],corrections=['C32'])
add('N-MOVINGP','Moving observer and adaptive gauge storage','Retain Pprime b and skew gauge exchange; exact signed storage survives with changing viscosity.',44,['S19'],['N-STORAGE','N-ADAPT'])
add('K-CERT','Source-aware finite elimination certificates','(M,E,S,T,R,Z) identities certify reduced operator, transformed source and reconstruction; exact composition installs the full session.',45,['S18'],['K-INSTALL'],status='EXACT-CONTROL',corrections=['C01'])
add('R-GOLDBACH','Quantitative convolution source reconstructs Lambda','Actual normalized Goldbach tail reconstructs Lambda and its Dirichlet logarithmic derivative on Re s>1.',46,['S00','S23'],status='REPO-TERM',repo=['formal/lean/Pairfield/GoldbachReconstructionChain.lean'])
add('R-H4','Early faithful fourfold spline packet','Explicit delayed H4 has no strip zeros and a four-derivative Sobolev inverse.',46,['S01','S06'],corrections=['C38'])
add('R-PACKET','Actual fixed autocorrelation receiver','Explicit H/G, support[-1/2,1/2], G nonzero on strip, ReG>0 and G(i gamma)>0.',46,['S02'],corrections=['C38','C39'])
add('R-Z','Actual prime-shell response and prime-free diagonal','Z real/even, M0>0, exact tail prime/pole/arch identity for t>1/2 and finite multiplicative shell.',47,['S02'],['R-PACKET'],corrections=['C45'])
add('R-TWOPACKET','Complete two-packet actual Weil criterion','RH iff |Z(t)|<=M0 for all t iff two translated packet Weil matrices PSD.',47,['S02'],['R-Z'],status='CONDITIONAL',external=['Actual Weil explicit formula','Functional equation','Zero count'])
add('R-ABSCISSA','Exact received growth exponent','limsup log(1+|Z(t)|)/t=delta with no dominating-zero or attained-sup assumption.',48,['S01','S02'],['R-Z'])
add('R-FINITEHEIGHT','Finite-height to finite-scale error','Weighted zero tail O(T^-3 log T), multiplied by e^(|t|/2), retains unverified tail.',48,['S02'],['R-PACKET'],corrections=['C53'])
add('R-WEILSPACE','Completed actual Weil source','QW(v,w)=<Ev,J Ew> in l2(Sigma,m) on the declared form domain; compact source class kept distinct.',49,['S08','S12'],['R-PACKET'],corrections=['C40','C41'])
add('R-CYCLIC','Faithful packet cyclicity and source separation','Translation orbit cyclic in completed space; critical-line zero density makes compact-source evaluation injective.',49,['S08','S12'],['R-WEILSPACE'],external=['Positive proportion of distinct simple critical-line zeros'])
add('R-IMAGE','Original compact reflection fibre','Specified translated packet has a singleton compact source lift of J under RH and empty fibre otherwise.',50,['S12'],['R-CYCLIC','R-PACKET'],status='CONDITIONAL',corrections=['C40'])
add('R-INTERP','Finite compact interpolation and norm escape','All finite interpolation fibres inhabited; imposing more critical constraints forces least norm to infinity for an offending reflected value.',50,['S12'],['R-CYCLIC','R-IMAGE'])
add('R-CARDINAL','Actual Xi-cardinal source','m!/Xi^(m)(z) times Xi(w)/(w-z)^m has evaluations exactly e_z; source inverse in declared noncompact class.',51,['S11','S13'],['R-WEILSPACE'],corrections=['C42'])
add('R-THETA','Two-sided theta-history equality and double-exponential tails','Past/future (D-z)^m inverse difference is the finite Xi-derivative polynomial; zero multiplicity closes it.',51,['S13'],['R-CARDINAL'])
add('R-ESCAPE','Endpoint compact negative-bottom escape','Hypothetical Re z=sigma>0 gives lambda_a<=-c_z a^-sigma exp(2sigma a) at logarithmic support overhead.',52,['S13'],['R-THETA'],status='CONDITIONAL',corrections=['C43'])
add('R-INDEX','Actual Weil inertia and exhaustion','One negative completed direction per nonfixed distinct reflection orbit; compact support exhausts negative index.',52,['S08','S11'],['R-CARDINAL'],corrections=['C41'])
add('R-LANDAU','Off-line receiver grows in both signs','Any exponent below delta is exceeded in both signs; eventual one-sided polynomial bound implies RH.',53,['S16'],['R-ABSCISSA'],status='CONDITIONAL',external=['Landau nonnegative Laplace boundary principle'])
add('R-OUTPUT','Positive-output L2 stability criteria','Subexponential damped square finite iff RH; exponential L2 entry abscissa equals delta.',54,['S02'],['R-ABSCISSA'],status='CONDITIONAL')
add('R-HANKEL','Unbounded-to-nuclear causal phase transition','s>delta gives trace class; 0<s<delta unbounded via actual divided-difference poles.',55,['S09'],['R-ABSCISSA'],status='CONDITIONAL')
add('R-TRACE','Hankel trace and return energy','2Tr H=F_T(s); HS^2=integral t e^-2st |Z(T+t)|2; residues recover actual weighted divisor.',55,['S09'],['R-HANKEL'],corrections=['C45'])
add('R-PAIR','Positive polarized two-zero arithmetic kernel','Two-time Hardy/Bergman kernels retain centre/difference and arithmetic rapidity; full Gram positivity not fixed Goldbach slice positivity.',56,['S09','S25'],['R-Z'],corrections=['C44','C47'])
add('R-INVERSE','Direct two-time source inverse','L_s H_s=Z tensor conjugate Z; L_s K_s=H_s; M0 anchor recovers Z exactly.',57,['S09'],['R-PAIR','R-Z'])
add('R-LADDER','Damping moment Weyl ladder','R=-1/2 partial_s raises; L lowers; [L,R]=I; L^(n+1)G_n=n!Z tensor conjugate Z.',57,['S02'],['R-INVERSE'],status='FORMAL-SERIES',corrections=['C46'])
add('R-GEOMETRY','Hardy/Bergman reflection rank and descent','Hardy orbit determinant=sigma2/s2; Bergman squared reflection difference=2sigma2/s2.',58,['S09','S14'],['R-PAIR'],status='CONDITIONAL')
add('R-HOLONOMY','Actual reflection-scale positive loop','J U_t J U_t^-1=diag exp(2t Re z); zero loop iff RH; logarithmic norm is delta.',59,['S14'],['R-WEILSPACE','A-JUNITARY'],status='CONDITIONAL',corrections=['C50'])
add('R-CURVATURE','One weighted defect under multiple readings','Packet curvature/4 = sum w sigma2 = weighted Hardy minors = half weighted Bergman difference energy.',59,['S14'],['R-GEOMETRY','R-HOLONOMY'],corrections=['C41'])
add('R-MINORS','Cauchy determinant and exact innovation','Finite normalized Hardy determinant product rho2; new atom distance product; each infinite distinct atom remains minimal.',60,['S09'],['R-GEOMETRY'])
add('R-NOUNIFORM','Individual extraction not uniform stability','Known critical simple zero crowding destroys uniform normalized Riesz and Bessel bounds.',60,['S09'],['R-MINORS','R-CYCLIC'],corrections=['C48'])
add('R-PASSIVE','Actual input-output work criterion','RH iff supplied work W(f)>=0 for every compact smooth input; cosh control separates damped output PSD.',61,['S10'],['R-TWOPACKET'],status='CONDITIONAL',corrections=['C44'])
add('R-IMPEDANCE','Corrected positive-real/Stieltjes source','Actual received Y positive-real iff RH; arithmetic formula includes prefix E_T and convergent weighted trivial-zero tail.',61,['S02','S14'],['R-PASSIVE','R-Z'],status='CONDITIONAL',corrections=['C45','C49'])
add('R-DYADIC','Pole-annihilating finite arithmetic residual','A_m=(T_log2-sqrt2)^m S removes actual pole character but none of the nontrivial modes.',62,['S20','S21'],['R-Z'])
add('R-ABEL','Rigorous all-order source-boundary inverse','Strong c0 Abel inverse recovers L-S; bounded A_m gives absolute inverse with norm(sqrt2-1)^-m.',62,['S19'],['R-DYADIC'],corrections=['C51'])
add('R-GSQUARE','Direct quantitative Goldbach source square','G_R(t)=A(t)^2 and normalized Gcal=t2G_R tends to1 by PNT.',63,['S22'],external=['Actual quantitative Goldbach convolution identity','Prime number theorem'])
add('R-GCRITERION','Direct Goldbach dyadic rate iff RH','For every epsilon, Gcal(2t)-Gcal(t)=O(t^(1/2-epsilon)) iff RH; finite prefix tail O(t log4(1/t)).',63,['S22'],['R-GSQUARE'],status='CONDITIONAL',external=['Actual Mellin/logarithmic-derivative continuation bounds under RH'])
add('R-SCHUR','Exact reflection self-energy and pole audit','Sigma_z=lambda-map sigma2/(lambda+i gamma); full denominator has real pair poles, not the intermediate removable pivot.',64,['S17','S18'],['R-HOLONOMY','K-EXCURSION'],corrections=['C50','C52'])
add('O-RBOUND','Unconditional actual received tail bound','Supply a proof for the actual prime-shell response; not an arbitrary positive kernel.',68,['S23'],status='UNSUPPLIED-HERE',domain='Actual fixed packet and prime/arch source')
add('O-RONESIDE','Unconditional one-sided arithmetic control','Supply eventual one-sided polynomial bound for the same Z.',68,['S16'],status='UNSUPPLIED-HERE')
add('O-RLOWER','Actual Weil bottom lower bound','Supply global/subexponential semiboundedness sufficient to contradict negative endpoint escape.',68,['S13'],status='UNSUPPLIED-HERE')
add('O-RLIFT','Actual compact reflected source','Construct the specified original compact source realizing JEp with all interpolation constraints.',68,['S12'],status='UNSUPPLIED-HERE')
add('O-RDYADIC','One actual residual order bounded','Supply a bound for A_m at one fixed m, not its formally inverted surrogate.',68,['S19'],status='UNSUPPLIED-HERE')
add('O-RGOLDBACH','Actual Goldbach residual critical rate','Supply every-epsilon half-order rate for the actual quadratic Goldbach scale residual.',68,['S22'],status='UNSUPPLIED-HERE')
add('O-NPEAK','All-data actual peak-work integrability','For every admissible maximal solution with finite lifetime, integral b_u < infinity.',68,['S23'],status='UNSUPPLIED-HERE',domain='Standard fixed chosen three-dimensional formulation')
add('END-RH','Actual Riemann hypothesis','All actual nontrivial zeta zeros have real part 1/2.',68,['S23'],status='CONDITIONAL',deps=['R-TWOPACKET','O-RBOUND'],corrections=['C03','C06'])
add('END-NS','Actual global smooth NS','Every admissible datum in the chosen fixed formulation has a global smooth solution.',68,['S23'],status='CONDITIONAL',deps=['N-PEAK','O-NPEAK'],external=['Classical vorticity continuation theorem'],corrections=['C03','C06'])

ids={n['id'] for n in nodes}
assert len(ids)==len(nodes)
for n in nodes:
    assert set(n['dependencies'])<=ids,(n['id'],set(n['dependencies'])-ids)
# finite directed proof-dependency slice, verify no accidental circular certification
state={}
def visit(i):
    if state.get(i)==1:raise RuntimeError('Circular proof dependency at '+i)
    if state.get(i)==2:return
    state[i]=1
    for dep in next(n for n in nodes if n['id']==i)['dependencies']:visit(dep)
    state[i]=2
for i in ids:visit(i)
alternatives=[
{'endpoint':'END-RH','requirements':['R-LANDAU','O-RONESIDE']},
{'endpoint':'END-RH','requirements':['R-ESCAPE','O-RLOWER']},
{'endpoint':'END-RH','requirements':['R-IMAGE','O-RLIFT']},
{'endpoint':'END-RH','requirements':['R-ABEL','R-TWOPACKET','O-RDYADIC']},
{'endpoint':'END-RH','requirements':['R-GCRITERION','O-RGOLDBACH']},
{'endpoint':'END-NS','requirements':['N-SMALL'],'restriction':'Small energy-enstrophy data only; not the all-data endpoint.'},
]
obj={'title':'Actual-source NS/RH dependency and correction slice','comparison_commit':'168ea8e240524f898af4b0e9cf70297c38422f08',
     'scope':'Finite explicit handoff dependency slice, not an exhaustive repository graph. UNSUPPLIED-HERE does not mean absent from the repository.',
     'nodes':nodes,'alternative_routes':alternatives}
(ROOT/'CLAIM_GRAPH.json').write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
text=['# Claim graph index','',obj['scope'],'',
'Every statement has its full source-class/verification record in `CLAIM_GRAPH.json`. Link targets below are canonical handoff sections.','',
'| Claim | Status | Section | Content |','|---|---|---|---|']
for n in nodes:
    text.append(f"| `{n['id']}` | {n['status']} | [§{n['handoff_section']}](HANDOFF.md#section-{n['handoff_section']}) | {n['title']} |")
(ROOT/'CLAIM_INDEX.md').write_text('\n'.join(text)+'\n')
print(len(nodes),'claims, acyclic dependency slice verified')
