# COORDINATION THEOREMS XL — MARKOV KERNELS, STOCHASTIC COMPOSITION, AND COLLECTIVE DYNAMICS
Date: 2026-08-13
Status: exact finite-state Markov-chain lemmas; no novelty claims.

Let X be a finite state space. A Markov kernel P has rows \(P(x,\cdot)\) probability distributions.

## 1241. Markov kernels compose
For kernels P:X→Y and Q:Y→Z define
\[
(QP)(x,z)=\sum_yP(x,y)Q(y,z).
\]
Then QP is a Markov kernel.

Proof. Entries are nonnegative and
\[
\sum_z(QP)(x,z)
=
\sum_yP(x,y)\sum_zQ(y,z)
=
\sum_yP(x,y)=1.
\]
QED.

## 1242. Kernel composition is associative
\[
R(QP)=(RQ)P.
\]

Proof. Finite sums:
\[
\sum_z\left(\sum_yP(x,y)Q(y,z)\right)R(z,w)
=
\sum_yP(x,y)\left(\sum_zQ(y,z)R(z,w)\right).
\]
QED.

## 1243. Identity kernel
\[
I(x,y)=\mathbf1_{x=y}
\]
is identity for kernel composition.

Proof. Kronecker delta collapses sum. QED.

Thus finite stochastic maps form a category.

## 1244. Deterministic function is a Markov kernel
For f:X→Y,
\[
P_f(x,y)=\mathbf1_{y=f(x)}.
\]

Proof. Each row has exactly one 1. QED.

## 1245. Composition embeds deterministic functions
\[
P_{g\circ f}=P_gP_f.
\]

Proof. Sum over y is nonzero exactly at y=f(x), then z=g(f(x)). QED.

## 1246. Distribution pushforward
For row-vector distribution μ on X,
\[
(\mu P)(y)=\sum_x\mu(x)P(x,y)
\]
is a probability distribution.

Proof. Nonnegative and total mass
\[
\sum_y\mu P(y)=\sum_x\mu(x)\sum_yP(x,y)=1.
\]
QED.

## 1247. Chapman–Kolmogorov
n-step kernel is P^n and
\[
P^{m+n}=P^mP^n.
\]

Proof. Associativity and induction. QED.

## 1248. Stationary distribution
π is stationary iff
\[
\pi P=\pi.
\]

Definition.

## 1249. Stationarity persists under time
If πP=π, then
\[
\pi P^n=\pi
\]
for all n.

Proof. Induction. QED.

## 1250. Doubly stochastic kernel preserves uniform distribution
If both row sums and column sums equal1, uniform u satisfies
\[
uP=u.
\]

Proof.
\[
(uP)(y)=\frac1{|X|}\sum_xP(x,y)=\frac1{|X|}.
\]
QED.

## 1251. Detailed balance implies stationarity
If π(x)P(x,y)=π(y)P(y,x) for all x,y, then πP=π.

Proof.
\[
(\pi P)(y)
=
\sum_x\pi(x)P(x,y)
=
\sum_x\pi(y)P(y,x)
=
\pi(y).
\]
QED.

## 1252. Reversible flow has zero net pairwise current
Under detailed balance,
\[
J(x,y)=\pi(x)P(x,y)-\pi(y)P(y,x)=0.
\]

Proof. Definition. QED.

## 1253. Stationarity does not imply detailed balance
There exist stationary nonreversible chains.

Proof. Directed 3-cycle deterministic rotation has uniform stationary distribution, but P(i,i+1)=1 while reverse transition probability is0, violating detailed balance. QED.

## 1254. Data processing under a Markov kernel
If random variables Θ→X→Y form a Markov chain via kernel P,
\[
I(\Theta;Y)\le I(\Theta;X).
\]

Proof. Standard data-processing inequality; equivalently
\[
I(\Theta;X)=I(\Theta;Y)+I(\Theta;X|Y)-I(\Theta;Y|X),
\]
and Markov property makes last term0, leaving nonnegative conditional MI. QED.

## 1255. Stochastic post-processing cannot create target information
For any signal X and randomized channel P independent of target Θ conditional on X, output Y cannot have more mutual information about Θ than X.

Proof. Theorem 1254. QED.

## 1256. Deterministic quotient is a special stochastic information loss
If Y=f(X), then
\[
I(\Theta;Y)\le I(\Theta;X).
\]

Proof. Deterministic kernel plus data processing. QED.

## 1257. Sufficient stochastic channel preserves target information
If additionally
\[
\Theta\perp X\mid Y,
\]
then
\[
I(\Theta;Y)=I(\Theta;X).
\]

Proof.
\[
I(\Theta;X)=I(\Theta;Y)+I(\Theta;X|Y)
\]
under Θ→X→Y; sufficiency kills conditional term. QED.

## 1258. Total variation contracts under a Markov kernel
For distributions μ,ν,
\[
\|\mu P-\nu P\|_{TV}
\le
\|\mu-\nu\|_{TV}.
\]

Proof.
\[
\frac12\sum_y\left|\sum_x(\mu(x)-\nu(x))P(x,y)\right|
\le
\frac12\sum_x|\mu(x)-\nu(x)|\sum_yP(x,y).
\]
QED.

## 1259. L1 disagreement cannot increase under stochastic averaging
Equivalent form:
\[
\|\mu P-\nu P\|_1\le\|\mu-\nu\|_1.
\]

Proof. Twice Theorem 1258. QED.

## 1260. Strict contraction yields unique stationary distribution
If there exists α<1 such that for all μ,ν,
\[
\|\mu P-\nu P\|_{TV}\le\alpha\|\mu-\nu\|_{TV},
\]
then P has at most one stationary distribution.

Proof. If π,ρ stationary,
\[
\|\pi-\rho\|=\|\pi P-\rho P\|\le\alpha\|\pi-\rho\|,
\]
forcing equality norm0. QED.

## 1261. Strict contraction gives exponential convergence once stationary π exists
\[
\|\mu P^n-\pi\|_{TV}
\le
\alpha^n\|\mu-\pi\|_{TV}.
\]

Proof. Iterate contraction and stationarity. QED.

## 1262. Convex averaging preserves convex hull
If new scalar state of agent i is
\[
x_i'=\sum_jP_{ij}x_j
\]
with row-stochastic P, then
\[
\min_jx_j\le x_i'\le\max_jx_j.
\]

Proof. Convex combination. QED.

## 1263. Consensus states are fixed by row-stochastic averaging
For x=c1,
\[
Px=c1.
\]

Proof. Row sums equal1. QED.

## 1264. Doubly stochastic averaging preserves global mean
If P is doubly stochastic,
\[
\frac1n1^\top Px=\frac1n1^\top x.
\]

Proof. \(1^\top P=1^\top\). QED.

## 1265. Primitive doubly stochastic chains converge to average consensus
If finite P is primitive and doubly stochastic, then
\[
P^n\to \frac1n11^\top.
\]

Proof. Perron–Frobenius: primitive stochastic P has unique eigenvalue1 on unit circle with positive stationary distribution; double stochasticity makes it uniform. Other eigenvalues have modulus<1. QED.

## 1266. Absorbing state
State a is absorbing iff
\[
P(a,a)=1.
\]

Definition.

## 1267. Once absorbed, always absorbed
If X_t=a and a absorbing,
\[
P(X_{t+s}=a\ \forall s\ge0|X_t=a)=1.
\]

Proof. One-step probability remains1; induct. QED.

## 1268. Closed class is a semantic trap
If C⊆X satisfies
\[
P(x,C)=1
\quad\forall x\in C,
\]
then trajectories entering C never leave.

Proof. Same induction as absorbing state at set level. QED.

## 1269. Multiple closed classes imply multiple long-run sectors can exist
If C_1,C_2 are disjoint closed classes, a chain starting in C_i remains in that sector; no stochastic evolution crosses between them.

Proof. Closedness. QED.

## 1270. Conserved sector label
Let q:X→S satisfy
\[
P(x,y)>0\Rightarrow q(y)=q(x).
\]
Then
\[
q(X_t)=q(X_0)
\]
almost surely for all t.

Proof. Every allowed transition preserves q; induct. QED.

## 1271. Sector-preserving kernel block-diagonalizes
Order states by q-value. Then P has no nonzero entries between different sectors, hence block diagonal.

Proof. Theorem 1270 transition condition. QED.

## 1272. Mixing cannot erase an exactly conserved sector
If q is conserved and initial distribution has support in sector s, all future distributions remain supported in s.

Proof. Theorem 1270. QED.

## 1273. Forgetting sector label can create apparent multimodality/dependence
Mixture
\[
\mu=\sum_s\alpha_s\mu_s
\]
over invariant sectors can display correlations absent within each μ_s.

Proof. Common-latent-mixture example: sector s is common bit copied into variables; each sector is degenerate/product while mixture is correlated. QED.

## 1274. Conditioning on conserved charge restores sector decomposition
Given q(X)=s, dynamics evolve entirely under block P_s.

Proof. Block diagonalization Theorem 1271. QED.

## 1275. Lumpability condition
Partition X into blocks B_a. If for any x,x' in same block B_a and every block B_b,
\[
\sum_{y\in B_b}P(x,y)
=
\sum_{y\in B_b}P(x',y),
\]
then transition probability between blocks depends only on a, not representative x.

Proof. Equality is exactly representative-independence. QED.

## 1276. Lumped chain
Under Theorem 1275 define
\[
\bar P(a,b)=\sum_{y\in B_b}P(x,y)
\quad(x\in B_a).
\]
Then \(\bar P\) is a Markov kernel.

Proof. Well-defined by lumpability; nonnegative; row sums over blocks equal sum over all y=1. QED.

## 1277. Exact quotient dynamics
Let q:X→A be block quotient. Under lumpability, if X_t follows P, then q(X_t) is Markov with kernel \(\bar P\).

Proof. Conditional probability of next block given current full state depends only on current block by lumpability, hence quotient process is Markov. QED.

## 1278. Non-lumpable quotient acquires hidden-state memory
If block transition probabilities differ between representatives in same block, quotient next-state law depends on unresolved hidden representative; quotient process need not be Markov.

Proof. Choose x,x' in same block with differing probability to some next block. Two histories yielding same current quotient but different posterior over x,x' lead to different next quotient distributions. QED.

## 1279. Exact semantic quotient of dynamics requires lumpability
For a Markov process to descend to a memoryless Markov kernel on quotient blocks independent of hidden representative, lumpability is necessary and sufficient.

Proof. Sufficiency Theorem 1277. Necessity is representative-independence of next-block probabilities, exactly Theorem 1275. QED.

## 1280. Hidden implementation state can matter dynamically even when static outputs agree
Two hidden states in same static semantic quotient may have different future transition behavior, so a quotient sufficient for present tasks may be insufficient for future compositional tasks.

Proof. Non-lumpable example Theorem 1278. QED.

Thus task family must include future behavioral semantics if the interface is intended to compose dynamically.
