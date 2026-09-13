# Prime-Pair Atlas — Delta 19
## Exact memory kernels from projection: discrete Dyson expansion and charge-sector excursions

Date: 2026-08-13
Status: exact operator algebra + arithmetic translation targets.

## 19.0 Setup

Let U=S⊕Q be a linear state space with complementary projections P,Q=I-P. Let T be a one-step operator (or U_h an additive translation). We observe only S.

The previous delta gave the two-step defect:
    (PTP)^2 - PT²P = -PTQTP.

Now derive the entire projected dynamics exactly.

## 19.1 Path expansion by sector words

Insert I=P+Q between every factor of T:

T^n = T(P+Q)T(P+Q)...(P+Q)T.

Therefore

### T19.1
PT^nP equals the sum over all length-n sector paths that start and end in P:
    PT E_{n-1} T ... E_1 T P,
where each E_i∈{P,Q}.

This is exact.

### C19.2
The naive Markovian term (PTP)^n is only the unique path that remains in P at every intermediate time.

Every other term is an excursion outside the observed sector followed by return.

## 19.2 First-return kernels

Define for m≥2
    F_m := P T Q (Q T Q)^{m-2} Q T P,
and F_1:=PTP.

Interpretation:
F_m leaves P immediately, remains in Q for m-1 intermediate steps, and first returns to P at step m.

### T19.3 (renewal equation)
Let K_n:=PT^nP, K_0=P on S. Then
    K_n = Σ_{m=1}^n F_m K_{n-m}
with consistent operator ordering convention (first-return block followed by earlier/later block depending time convention).

Proof.
Partition every P→P sector path by the length m of its first return to P. QED.

### C19.4
Projected dynamics is exactly a noncommutative renewal process whose memory kernel is the family {F_m}.

No metaphor is needed.

## 19.3 Generating resolvent

Define formal series
    K(z)=Σ_{n≥0}K_n z^n,
    F(z)=Σ_{m≥1}F_m z^m.

From the renewal equation:

### T19.5
    K(z) = (I - F(z))^{-1}
on S, formally/where convergent.

More directly, block inversion gives the Feshbach formula.

## 19.4 Schur complement

Write T in blocks:
    T = [[A,B],[C,D]]
relative to P⊕Q.

For resolvent R(λ)=(λI-T)^{-1}:

### T19.6 (Feshbach/Schur complement)
P R(λ) P
=
(λI_S - A - B(λI_Q-D)^{-1}C)^{-1}
when inverses exist.

Define self-energy
    Σ(λ)=B(λI-D)^{-1}C.

### C19.7
All influence of eliminated Q states on observed resolvent is compressed exactly into Σ(λ).

### Expansion 19.8
Σ(λ)=Σ_{m≥0} λ^{-m-1} B D^m C
for |λ| sufficiently large/formally.

The coefficient B D^m C is exactly an excursion spending m steps in Q.

## 19.5 Dynamic sufficiency

### T19.9
The following imply exact closure on S:
    B=PTQ=0
or
    C=QTP=0.
Then Σ=0 and K_n=A^n.

More generally exact closure holds iff all return kernels
    B D^m C=0
for m≥0.

### C19.10
An eliminated distinction matters only if there is BOTH:
- a channel from S into it;
- a future channel back into S.

Pure leakage with no return changes normalization/resource but not future internal S dynamics after appropriate interpretation; return creates memory/self-energy.

## 19.6 Observability/controllability duality

For linear discrete dynamics T and observation P, unobservable subspace is
    N_obs = ⋂_{n≥0} ker(P T^n).

### T19.11
x,y are future-observationally equivalent iff x-y∈N_obs.

### T19.12
N_obs is T-invariant.

Proof.
If v∈N_obs, P T^n(Tv)=P T^{n+1}v=0.

### C19.13
The maximal dynamically safe quotient is U/N_obs, not U/ker P.

Instantaneous observation can discard distinctions that later become visible; quotienting by N_obs discards exactly distinctions invisible forever.

This is a strong correction to static sufficient-interface thinking.

## 19.7 Minimal realization

Standard linear systems theory says observable behavior can be represented on a minimal quotient after removing unobservable states (and unreachable states when inputs are included).

### S19.14
Our "minimal sufficient dynamic representation" is classical minimal realization/observability theory in the linear case.

Do not reinvent it.

The higher/nonlinear/type-theoretic question is how this generalizes to proof-relevant, relational, and self-modifying systems.

## 19.8 Charge-space application

Let charge decomposition H=⊕_{r≥0}H_r and P=P_1 project to charge one. Let U_h be additive translation.

Blocks:
    U_h^{r,s}=P_r U_h P_s.

Then

### T19.15
P_1 U_{h_n}...U_{h_1} P_1
=
Σ_{r_1,...,r_{n-1}}
U_{h_n}^{1,r_{n-1}}
U_{h_{n-1}}^{r_{n-1},r_{n-2}}
...
U_{h_1}^{r_1,1}.

This is exact insertion of charge resolution of identity.

### C19.16
Prime-sector propagation is a sum over charge histories.

The prime-pair problem is therefore not merely "project to charge one"; intermediate almost-prime sectors are virtual states in the exact composition law.

## 19.9 Charge first-return kernel

Let Q=I-P_1.

For repeated/common translation operator U (or a parameterized family with convolution bookkeeping), define

    F_m^(charge)=P_1 U Q (Q U Q)^{m-2} Q U P_1.

### C19.17
F_m^(charge) is the exact amplitude/kernel for leaving prime charge, spending m-1 steps among non-prime charges, and returning.

This is a candidate object to compare with parity barrier/Buchstab residual charge.

No equality claimed yet.

## 19.10 Parity coarse-graining

Let P_even,P_odd be Liouville parity projectors. Charge-one lies in odd parity but odd parity contains charges 1,3,5,...

### T19.18
Projection charge→parity merges infinitely many charge sectors.

### C19.19
A parity-only observer can be dynamically sufficient for prime-sector questions only if all distinctions among odd charge sectors are future-unobservable relative to the target.

This is almost certainly false for exact primality, but should be proved in finite models rather than asserted.

## 19.11 Finite toy theorem

Take finite charge states {1,2,3}. Suppose T has nonzero blocks 1→2 and 2→1. Then instantaneous charge-one projection loses state 2, but
    P_1 T² P_1
contains T_{1,2}T_{2,1}.

### T19.20
No Markovian one-step operator A=P_1TP_1 can reproduce both one-step and two-step charge-one dynamics unless T_{1,2}T_{2,1}=0 or compensated by special algebraic coincidence.

This is the minimal excursion-return obstruction.

## 19.12 Positive half-line application

Let H=ℓ²(Z), P=P_+ onto n>0, Q onto n≤0. Let T be a bilateral translation/convolution/operator.

Then
    B=P T Q,
    C=Q T P
are boundary-crossing blocks.

### T19.21
The half-line self-energy is
    Σ_+(λ)=P T Q (λ-QTQ)^{-1} Q T P.

### C19.22
Every half-line boundary correction is generated by paths that cross into the forbidden half-line and return, after choosing the relevant ambient operator.

This is the standard Wiener-Hopf/Toeplitz compression picture in resolvent language.

### Program 19.23
Identify the exact Hankel term in the library with coefficients of Σ_+(λ) for the specific pair operator.

## 19.13 Sum-gap inversion

Since the one-leg reflection maps angular x↦1/x, the forbidden complement |x|>1 is precisely where the bilateral conjugate lives after leaving the positive cone.

### S19.24
The Q-sector in the half-line/cone compression has a concrete geometric chart: the reciprocal angular region.

Potentially the boundary self-energy can be written as an integral transform through x↦1/x.

This needs derivation.

## 19.14 Hecke/Buchstab application

Let U be a symmetric adjacency/transfer operator on the full local Hecke/Bruhat-Tits tree. Let P select outward child-oriented states compatible with least-prime order.

Then Q contains parent/backtracking/forbidden-order states.

### Program 19.25
Compute
    Σ_B(λ)=P U Q(λ-QUQ)^{-1}Q U P.

Question: is the directed Buchstab transfer operator equal to, or approximated by, a Schur complement/effective operator after eliminating Q?

If yes, least-prime memory is literally a tree self-energy.

If no, identify the extra nonlinearity/stopping data preventing linear embedding.

## 19.15 Multiple simultaneous selections

Prime pairs require at least:
P_charge,
P_positive,
P_stop/order,
and sharp angular evaluation/aperture.

These projections/operations need not commute.

Let P=P_1P_2... only when a well-defined combined projection exists.

### P19.26
Even if each individual compression has small/simple self-energy, the combined eliminated sector can contain mixed excursion paths crossing multiple boundaries.

### C19.27
The "hard corner" may be a mixed self-energy problem: paths leave through charge, geometry, or stopping sectors and return through another.

This is a precise alternative to saying several obstructions mysteriously interact.

## 19.16 Inclusion-exclusion of eliminated sectors

For commuting orthogonal projections P_i, combined complement Q=I-∏P_i decomposes into sectors indexed by which constraints fail.

### T19.28
For two commuting projections P_A,P_B,
I-P_AP_B
=
Q_A + P_A Q_B
=
Q_B + P_B Q_A.

With orthogonal commuting projections one can refine into disjoint sectors:
P_AP_B, Q_AP_B, P_AQ_B, Q_AQ_B.

### C19.29
Mixed self-energy terms through Q_AQ_B quantify excursions violating both selections simultaneously.

This may give an exact decomposition of the hard corner if the relevant projectors commute.

## 19.17 Noncommuting selections

If P_A,P_B do not commute, there is no simultaneous sharp sector represented by their product as an orthogonal projector.

### C19.30
Before discussing "joint obstruction," determine the algebra of the selection operators themselves.

This echoes the library's correction that some supposed noncommutations vanished while nonlinear/stopped ones remained.

## 19.18 Mori-Zwanzig

The projection-operator formalism in statistical mechanics gives an exact generalized Langevin equation:
resolved dynamics = instantaneous drift + memory convolution + noise from unresolved initial data.

### S19.31
Our excursion-return derivation is the discrete algebraic skeleton of Mori-Zwanzig.

Therefore the mature mathematics for "discarded distinctions return as memory" already exists.

### Program 19.32
Translate the prime charge/positive-boundary decomposition into Mori-Zwanzig notation and identify:
- resolved variables;
- orthogonal dynamics;
- memory kernel;
- noise term.

Do not invent a new memory formalism.

## 19.19 Nakajima-Zwanzig / open systems

The same projection method underlies reduced quantum/open-system dynamics.

### S19.33
The observer/reconstruction intuition has a mature open-systems counterpart: non-Markovianity of reduced dynamics measures unresolved degrees of freedom feeding back into observed ones.

Again, analogy becomes useful only after exact operator identification.

## 19.20 HoTT / higher translation

Linear observability quotient U/N_obs is set/vector-space level.

The higher analogue should retain:
- a type of observations over time/contexts;
- the homotopy fiber of the total observation map;
- higher paths between observationally indistinguishable states.

### Program 19.34
For a process object X and observer family O, define total observation
    Obs:X→Π_{c:Contexts}O_c
and study fib_Obs.

Then:
contractible fiber = exact reconstruction;
nontrivial fiber = forever-unobservable higher ambiguity;
time/context enlargement refines Obs.

This is the HoTT lift of classical observability.

## 19.21 Parametricity translation

A relation R on states is dynamically respected if
    R(x,y)⇒R(Tx,Ty).

### T19.35
The future-observational equivalence ~_P is T-invariant.

Proof from T19.12.

### C19.36
The maximal safe observer quotient is automatically a congruence for the dynamics.

This is the relational/parametric version of minimal realization.

## 19.22 Computational irreducibility translation

Suppose full T^n is hard but the minimal observable quotient admits cheap closed dynamics.

Then the observer sees reducibility despite microscopic irreducibility.

### C19.37
Computational irreducibility should be tested after quotienting by N_obs for the requested observation class, not on the raw state space.

This refines the earlier univalent irreducibility idea:
first quotient distinctions that are provably forever irrelevant; then optimize over equivalent representations of the resulting observable system.

## 19.23 New composite notion

For task observer P:
1. form behavioral quotient U/N_obs;
2. consider all efficient equivalences of that quotient;
3. minimize prediction complexity over those presentations.

This separates:
- irrelevant distinctions (observability quotient);
- representational difficulty (univalent equivalence search);
- genuine task-relative computational irreducibility.

This is a much cleaner hierarchy.

## 19.24 Arithmetic consequence

For prime-pair research, we should stop asking globally:
"where is the missing parity information?"

Instead define a concrete resolved observable—e.g. charge-one pair correlation under additive shifts—and compute its exact memory kernel after eliminating:
- other charge sectors;
- negative/boundary states;
- forbidden Buchstab branches.

If the kernel can be controlled/spectrally diagonalized, we have a real analytic route.
If it remains as hard as the original correlation, the formalism has merely repackaged the problem.

## 19.25 Immediate calculations

A. Charge:
derive finite-truncated charge matrix U_h^{r,s} numerically/symbolically for small ranges and compute first-return kernels.

B. Half-line:
derive Σ_+(λ) for the exact bilateral pair operator already in library.

C. Hecke tree:
write full adjacency and child-only transition at one prime; test Schur complement relation.

D. Joint:
on a finite toy model with charge×sign×tree-direction states, compute mixed self-energy and see whether it factorizes.

E. HoTT:
formalize the finite total-observation map and its fibers, not a new ontology.

## 19.26 Sanskrit compression

क्षणे यन्न दृश्यते तत् न अवश्यं नष्टम्।
What is invisible now is not necessarily lost.

भविष्यदवलोकनसमष्टिः एव यथार्थपर्यवेक्षकः।
The totality of future observations is the true observer.

N_obs=⋂_{n≥0}ker(PT^n).

यद् अस्मिन् अन्तर्भवति तत् सर्वदा अदृश्यं;
तदेव निःशङ्कं त्यक्तुं शक्यते।
What lies there is invisible forever; only that may be discarded without regret.

अन्यत् स्मृतिरूपेण पुनरागच्छति।
Everything else may return as memory.
