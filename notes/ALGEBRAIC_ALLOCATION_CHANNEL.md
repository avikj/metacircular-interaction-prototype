# The algebraic allocation channel

The spectral-factor ambiguity behind a fixed autocorrelation is an exact
finite classical channel. Its fiber is a product of integer chains, not in
general a binary charge group. This note gives the precise state space,
side-information cost, and sharp intersection with the $0$--$1$ prime class.

Fix $X\ge13$, put $F=F_X$, and define

$$
P^*(x)=x^{\deg P}P(1/x),
\qquad q^\dagger=q(0)^{-1}q^*.
$$

Factor over $\mathbb Z[x]$ as

$$
F=\prod_a R_a^{e_a}
\prod_{j=0}^{k}q_j^{u_j}(q_j^\dagger)^{v_j},
\qquad m_j=u_j+v_j,
\tag{1.1}
$$

where the $R_a$ are monic reciprocal irreducibles and one representative is
chosen from each nonreciprocal orbit. Index $j=0$ denotes the unique odd
carrier orbit, for which $m_0=1$.

Define

$$
\mathcal S_{\rm alg}(F)=
\{A\in\mathbb Z[x]: A\text{ monic},\ A(0)=1,\ AA^*=FF^*\}.
\tag{1.2}
$$

## 1. Exact fiber theorem

**Theorem 1 (allocation-chain bijection).** There is an explicit bijection

$$
\Phi:\prod_{j=0}^{k}\{0,1,\ldots,m_j\}
\longrightarrow \mathcal S_{\rm alg}(F)
\tag{1.3}
$$

given by

$$
\Phi(a_0,\ldots,a_k)=
\prod_aR_a^{e_a}
\prod_{j=0}^{k}q_j^{a_j}(q_j^\dagger)^{m_j-a_j}.
\tag{1.4}
$$

Consequently

$$
\boxed{M:=|\mathcal S_{\rm alg}(F)|=\prod_{j=0}^{k}(m_j+1).}
\tag{1.5}
$$

*Proof.* In $FF^*$ every reciprocal factor $R_a$ has exponent $2e_a$, so
unique factorization forces exponent $e_a$ in $A$. For a nonreciprocal pair,
both $q_j$ and $q_j^\dagger$ have exponent $m_j$ in $FF^*$; if $q_j$ has
exponent $a_j$ in $A$, its reciprocal must have exponent $m_j-a_j$. These
choices are independent. Monicity and constant one remove scalar and
translation units, so there are no further allocations. More explicitly,
every monic irreducible factor of the monic integral polynomial $F$ has
constant term $\pm1$. Hence $q^\dagger$ is again monic integral and
$q^\dagger(0)=q(0)$; replacing copies within a reversal orbit preserves the
constant term, so every polynomial in (1.4) has constant one. $\square$

Define the deterministic channel and identity target

$$
Q:\mathcal S_{\rm alg}(F)\to\{FF^*\},\quad Q(A)=AA^*,
\qquad T_{\rm id}(A)=A.
$$

The channel is constant, so the exact finite target-fiber theorem says that
reconstruction of $T_{\rm id}$ requires and admits a side alphabet of size
$M$; a fixed-length side code needs $\lceil\log_2M\rceil$ bits. Under the
declared uniform prior,

$$
H(A\mid AA^*)=\log_2M.
\tag{1.6}
$$

These are finite-channel identities, not computational-complexity or
algorithmic-information lower bounds.

## 2. Quotient by reflection

Global reversal acts on allocation coordinates by

$$
(a_j)_j\longmapsto(m_j-a_j)_j.
\tag{2.1}
$$

Because $m_0=1$, this involution has no fixed point. Hence

$$
\boxed{|\mathcal S_{\rm alg}(F)/\langle *\rangle|=M/2.}
\tag{2.2}
$$

For the target $T_{\rm ref}(A)=[A]$ in the reversal quotient, reconstruction
therefore needs and admits a side alphabet of size $M/2$, or
$\lceil\log_2(M/2)\rceil$ fixed-length bits. The fiber is a hypercube only in
the squarefree case $m_j=1$ for every orbit; after choosing orientations it
may then be identified with $(\mathbb Z/2)^J$. With multiplicity it is the
product of chains (1.3), with reflection as a central involution.

## 3. The prime $0$--$1$ slice

Singleton-parity rigidity gives the exact intersection

$$
\boxed{
\mathcal S_{\rm alg}(F_X)\cap\{0,1\}[x]
=\{F_X,F_X^*\}.
}
\tag{3.1}
$$

Thus exactly $M-2$ algebraic allocations leave the $0$--$1$ cone, and only
one of the $M/2$ reflection classes is a prime-set class. On the actual
$0$--$1$ state class, oriented reconstruction costs one bit and reconstruction
modulo reflection costs zero bits.

If $M>2$, the binary target
$t(A)=\mathbf1_{\{0,1\}[x]}(A)$ does not descend through autocorrelation. Its
exact zero-error side alphabet has size two. Under the uniform prior on the
algebraic fiber its conditional entropy is

$$
H(t(A)\mid AA^*)=h_2(2/M),
\tag{3.2}
$$

distinct from the worst-case one-bit zero-error cost.

If a new nonreciprocal orbit has total multiplicity $m$, (1.5) multiplies by
$m+1$. Since odd-carrier reflection remains free, this creates $m+1$ times as
many algebraic reflection classes. The four allocations in
`FACTOR_ARCHITECTURE.md` are the first $m=1$ case.

## 4. Zero-rate algebraic ambiguity

Since $\log_2(m+1)\le m$,

$$
\log_2M
=\sum_j\log_2(m_j+1)
\le\sum_jm_j
\le\frac{\deg F_X}{\delta_{\rm nr}(F_X)}.
\tag{4.1}
$$

The Smyth-tier factor bound therefore gives

$$
\boxed{
\log M
\ll\frac{X\log_3X}{\log_2X\,\log_4X}
=o(X).
}
\tag{4.2}
$$

So the algebraic allocation channel has asymptotically zero ambiguity rate
per coefficient. The combinatorial prime-set ambiguity is already exactly
two oriented states, not merely subexponential.

## 5. Information-theory boundary

The state set, deterministic channel, target, side code, and prior are
specified explicitly, so Shannon and zero-error quantities are genuine here.
A quantum-channel restatement adds no bound: no quantum encoding,
operator-algebra recovery problem, or nonseparable state is present. Chaitin
incompleteness is likewise irrelevant; the allocation vector is an explicit
finite code and the counting formulas are computable exactly.

The mathematical content is UFD allocation plus singleton-parity rigidity.
The information language separates algebraic fiber size, reflection quotient,
$0$--$1$ target sufficiency, distributional entropy, and fixed-length
zero-error cost.
