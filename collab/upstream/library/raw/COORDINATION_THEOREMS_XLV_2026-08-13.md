# COORDINATION THEOREMS XLV — SINGLE-PARAMETER INCENTIVE COMPATIBILITY AND PAYMENT IDENTITIES
Date: 2026-08-13
Status: exact mechanism-design lemmas under stated quasi-linear regularity hypotheses; no novelty claims.

A single agent has type theta, allocation x(report), payment p(report), and quasi-linear utility u(theta,r)=theta*x(r)-p(r). Truthful utility is U(theta)=theta*x(theta)-p(theta).

## 1451. DSIC inequalities
Truthful reporting is dominant-strategy incentive compatible iff for all theta,r,
U(theta) >= theta*x(r)-p(r).
Proof. Definition. QED.

## 1452. DSIC implies monotone allocation
If theta'>theta, then x(theta')>=x(theta).
Proof. Add the two IC inequalities for theta and theta' misreporting as each other:
(theta'-theta)(x(theta')-x(theta))>=0. QED.

## 1453. Utility difference bounds
For theta'>theta,
(theta'-theta)x(theta) <= U(theta')-U(theta) <= (theta'-theta)x(theta').
Proof. Apply each type's IC constraint against the other's report and rearrange. QED.

## 1454. Truthful utility is convex
U(theta)=sup_r {theta*x(r)-p(r)}.
Hence U is convex.
Proof. Supremum of affine functions is convex. QED.

## 1455. Allocation is a subgradient
x(theta) belongs to the subdifferential of U(theta).
Proof. IC gives U(theta') >= U(theta)+x(theta)(theta'-theta). QED.

## 1456. Envelope/payment identity
Under DSIC,
U(theta)=U(0)+integral_0^theta x(t)dt,
and therefore
p(theta)=theta*x(theta)-U(0)-integral_0^theta x(t)dt.
Proof. Convex U is absolutely continuous on compact interior intervals and differentiable a.e.; monotone x agrees with U' at continuity points by the subgradient bounds. Integrate and substitute U=theta*x-p. QED.

## 1457. Monotonicity plus payment identity implies DSIC
Suppose x is nondecreasing and payments satisfy Theorem 1456. Then truthful reporting is DSIC.
Proof. For true theta and report r, if theta>=r,
U(theta)-[theta*x(r)-p(r)] = integral_r^theta [x(t)-x(r)]dt >=0.
If theta<r, the analogous expression is integral_theta^r [x(r)-x(t)]dt >=0. QED.

## 1458. Single-parameter DSIC characterization
A mechanism is DSIC iff allocation x is nondecreasing and payments have the envelope form, up to additive constant U(0).
Proof. Necessity Theorems 1452,1456; sufficiency Theorem 1457. QED.

## 1459. Individual rationality normalization
If outside utility is 0 and U(0)=0, then
U(theta)=integral_0^theta x(t)dt >=0.
Proof. x>=0. QED.

## 1460. Threshold allocation yields critical payment
If deterministic allocation has threshold tau, x(theta)=1 iff theta>=tau, with U(0)=0, then winners pay tau and losers pay 0.
Proof. Below tau the integral and allocation are zero. Above tau, integral equals theta-tau, hence p=theta-(theta-tau)=tau. QED.

## 1461. Second-price auction is threshold mechanism
Fix competitors' bids; bidder wins exactly above highest competing bid m and pays critical threshold m.
Proof. Theorems 837 and1460. QED.

## 1462. Procurement reverses monotonicity
For cost type c and utility p(r)-c*x(r), DSIC requires x(c) nonincreasing in c.
Proof. Repeat Theorem 1452 with sign reversed. QED.

## 1463. Procurement payment identity
Under DSIC procurement with upper endpoint cbar,
U(c)=U(cbar)+integral_c^cbar x(t)dt,
and p(c)=c*x(c)+U(c).
Proof. Envelope derivative is U'(c)=-x(c); integrate backward. QED.

## 1464. Deterministic procurement threshold pays critical cost
If supplier wins iff c<=tau and U(cbar)=0, every winner is paid tau.
Proof. For c<=tau, U(c)=integral_c^tau 1 dt=tau-c, so p(c)=tau. QED.

## 1465. Verifiable quality can reduce type dimension
Suppose outcome quality q is objectively verifiable and contract fixes required q=q*. If supplier's only remaining private parameter relevant to utility is cost c, mechanism becomes single-parameter even if unverified quality would otherwise be strategic.
Proof. Verification removes reports/actions with q!=q*. Remaining utility variation is indexed only by c by hypothesis. QED.

## 1466. Lower type dimension reduces incentive constraints structurally
A one-dimensional type admits monotonicity/envelope characterization; a general multidimensional type need not.
Proof. Theorems 1452–1458 establish the 1D reduction. Two independently valued goods give a basic multidimensional counterexample to scalar monotonicity. QED.

## 1467. Hard validity can convert hidden action choice into observable contract compliance
If action a is accepted iff verifier proves a belongs to A_valid, incentive design need only compare accepted actions inside A_valid.
Proof. Invalid actions cannot produce accepted outcomes/payoffs in the modeled mechanism. QED.

## 1468. Verification and payments are substitutes only for invalid deviations
If undesired deviation d is invalid and excluded by verification, no transfer is needed solely to deter d. If d is valid, verification cannot deter it without strengthening the predicate.
Proof. Infeasible deviation is absent; valid deviation remains feasible. QED.

## 1469. Critical-value payments price allocation scarcity
In a monotone single-parameter allocation, a winner's payment is determined by the boundary at which its report would cease to win, not by its report above that boundary.
Proof. Threshold/critical-payment characterization. QED.

## 1470. Payment depends on allocation geometry
For fixed monotone x and normalization U(0), DSIC payment is uniquely determined by
p(theta)=theta*x(theta)-U(0)-integral_0^theta x(t)dt.
Proof. Theorem 1456. QED.

## 1471. Incentive-compatible transfer is not an arbitrary reward layer
Once allocation semantics and utility model are fixed in the single-parameter DSIC setting, payments have only the additive normalization degree of freedom.
Proof. Theorem 1470. QED.

## 1472. Allocation quotient can preserve incentives
If two internal implementations induce identical allocation x(theta) and payment p(theta) for every report, agents are strategically unable to distinguish them through this mechanism.
Proof. Utility depends only on theta,x,p. QED.

## 1473. Provenance-sensitive utility breaks that quotient
If agents additionally value implementation provenance z, identical x,p need not imply identical utility.
Proof. Add term r(z) to utility. QED.

## 1474. Strategy-proofness is task-relative semantics
A mechanism may be truthful for the modeled report-to-allocation/payment task while failing truthfulness once external report-dependent consequences are added.
Proof. External payoff terms can overturn IC inequalities. QED.

## 1475. Incentive compatibility is not compositional under arbitrary coupling
Two mechanisms individually DSIC need not remain jointly DSIC if cross-mechanism utility terms depend on both reports/outcomes.
Proof. Cross-component utility can make a joint deviation profitable despite componentwise DSIC. QED.

## 1476. Additive independent DSIC mechanisms compose
If utilities add and each mechanism's outcome/payment depends only on its own report component, truthful reporting in every component is dominant.
Proof. Sum componentwise DSIC inequalities. QED.

## 1477. Budget balance is separate from DSIC
A DSIC mechanism may run surplus or deficit.
Proof. Add a report-independent constant transfer; incentives are unchanged while budget changes. QED.

## 1478. Individual rationality is separate from DSIC
Adding a sufficiently large report-independent charge preserves IC comparisons but can make truthful utility negative.
Proof. Constant charge cancels in report comparisons. QED.

## 1479. Efficiency is separate from DSIC
A constant allocation/payment mechanism is trivially DSIC but may allocate inefficiently.
Proof. Reports cannot affect utility, so truth is weakly dominant; allocation need not maximize value. QED.

## 1480. Mechanism desiderata are independent constraints
Truthfulness, feasibility, individual rationality, budget balance, efficiency, privacy, and verifiability are separate predicates on mechanism behavior; satisfying one does not logically imply the others.
Proof. Theorems 1477–1479 plus earlier privacy/verification counterexamples. QED.
