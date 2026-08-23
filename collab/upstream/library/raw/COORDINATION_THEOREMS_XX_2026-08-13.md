# COORDINATION THEOREMS XX — ARITHMETIC LOCAL/GLOBAL MODELS AS FINITE COORDINATION SYSTEMS
Date: 2026-08-13
Status: exact elementary arithmetic/CRT/information lemmas intended to connect the coordination corpus to the existing Prime-Pair reconstruction program. No claim toward Goldbach/twin primes/RH.

## 543. CRT is exact local-to-global reconstruction for coprime moduli
Let \(m_1,\dots,m_k\) be pairwise coprime and \(M=\prod_i m_i\). The map
\[
\phi:\mathbb Z/M\mathbb Z\to\prod_i\mathbb Z/m_i\mathbb Z,
\qquad
[x]_M\mapsto([x]_{m_i})_i
\]
is a ring isomorphism.

Proof. Ring homomorphism is immediate. Kernel consists of residues divisible by every m_i, hence by M, so injective. Domain and codomain both have M elements, hence bijective. QED.

## 544. CRT local observations have zero reconstruction entropy on the finite product
If X is uniform on \(\mathbb Z/M\mathbb Z\) and Y=(X mod m_i)_i for all pairwise-coprime factors whose product is M, then
\[
H(X|Y)=0.
\]

Proof. CRT map is bijective. QED.

## 545. Omitting one coprime modulus leaves exactly its logarithmic entropy
Let M=AB with gcd(A,B)=1. X uniform mod M, observe Y=X mod A only. Then each Y-fiber has size B and
\[
H(X|Y)=\log B.
\]

Proof. Reduction mod A has B residues mod M over each class. Uniformity gives uniform conditional fiber. QED.

## 546. Added residue modulo the missing coprime factor exactly restores reconstruction
Under Theorem 545, Z=X mod B satisfies
\[
H(X|Y,Z)=0,\qquad
I(X;Z|Y)=\log B.
\]

Proof. CRT reconstructs X from residues mod A,B; then apply exact reconstruction information identity. QED.

## 547. Finite-prime valuation truncation leaves a multiplicative tail
For positive integer n and finite prime set S, define visible valuation vector
\[
V_S(n)=(v_p(n))_{p\in S}
\]
and visible part
\[
n_S=\prod_{p\in S}p^{v_p(n)}.
\]
Then uniquely
\[
n=n_S\,r_S(n)
\]
where r_S(n) has no prime factor in S.

Proof. Fundamental theorem of arithmetic; separate prime factors in S from those outside S. QED.

## 548. Full valuation data reconstructs the integer
The map
\[
n\mapsto (v_p(n))_{p\ \mathrm{prime}}
\]
on positive integers is injective.

Proof. Fundamental theorem of arithmetic. QED.

## 549. Factorization count splits across visible and tail primes
Let
\[
\Omega(n)=\sum_p v_p(n).
\]
Then
\[
\Omega(n)=\sum_{p\in S}v_p(n)+\Omega(r_S(n)).
\]

Proof. Split the prime sum into S and its complement. QED.

## 550. Liouville charge factorizes into visible and tail charge
For \(\lambda(n)=(-1)^{\Omega(n)}\),
\[
\lambda(n)
=
(-1)^{\sum_{p\in S}v_p(n)}
\lambda(r_S(n)).
\]

Proof. Apply Theorem 549 modulo 2. QED.

Thus after finite local valuation observation, the unresolved Liouville bit is exactly the tail factorization parity.

## 551. Visible valuations alone do not determine tail charge on unrestricted integers
For any finite S there exist n,n' with
\[
V_S(n)=V_S(n')
\]
but
\[
\lambda(n)=-\lambda(n').
\]

Proof. Choose a prime q∉S. Let n=1,n'=q. Both have all S-valuations zero, while λ(1)=1 and λ(q)=-1. QED.

## 552. One tail-charge bit suffices to reconstruct total Liouville charge from visible valuations
Given V_S(n) and
\[
C_S(n)=\lambda(r_S(n)),
\]
one recovers
\[
\lambda(n)=(-1)^{\sum_{p\in S}v_p(n)}C_S(n).
\]

Proof. Theorem 550. QED.

## 553. Tail charge is a canonical binary supplement for the Liouville task
For the task family consisting only of total Liouville charge λ(n), after V_S is known, two residual tails are task-equivalent iff their Liouville charges agree. Therefore the canonical task quotient of the tail is exactly \(C_S\in\{\pm1\}\).

Proof. With V_S fixed, Theorem 550 shows λ depends on tail only through C_S, and both C_S values produce different λ. Apply canonical task quotient. QED.

## 554. Tail charge is not sufficient for reconstructing the integer
For finite S, there exist distinct S-rough tails r,r' with equal λ(r)=λ(r').

Proof. Choose distinct primes q_1,q_2 outside S. Both have λ=-1 but are distinct. QED.

Thus task-sufficient information can be dramatically smaller than state-reconstruction information.

## 555. Pairwise divisibility observations are local predicates
For fixed prime p and shifts h_1,...,h_k, the vector
\[
D_p(n)=
(1_{p|n+h_1},...,1_{p|n+h_k})
\]
depends only on n mod p.

Proof. Divisibility by p of n+h_j is determined by residue class n≡-h_j mod p. QED.

## 556. Distinct shift residues make single-divisibility events mutually exclusive at a prime
If \(-h_i\not\equiv-h_j\pmod p\) for i≠j, then for any n at most one event \(p|n+h_j\) occurs.

Proof. If p divides both n+h_i and n+h_j, then p divides h_i-h_j, contradicting distinct residues. QED.

## 557. Uniform residue gives explicit local divisibility law
Under Theorem 556 with k distinct residues and uniform n mod p:
- probability no shifted form is divisible by p is \(1-k/p\);
- probability exactly coordinate j is divisible is \(1/p\).

Proof. There are p residue classes; k distinct bad residues, one for each coordinate. QED.

## 558. Local parity signs have explicit first-order expectation in the valuation-parity model
Let n be Haar-uniform in \(\mathbb Z_p\). For one affine form n+h,
\[
E[(-1)^{v_p(n+h)}]
=
\frac{p-1}{p+1}.
\]

Proof. Translation invariance reduces to h=0. For k≥0,
\[
P(v_p(n)=k)=(1-1/p)p^{-k}.
\]
Hence
\[
E[(-1)^v]
=(1-1/p)\sum_{k\ge0}(-1)^k p^{-k}
=(1-1/p)\frac1{1+1/p}
=\frac{p-1}{p+1}.
\]
QED.

## 559. Distinct-residue two-leg local parity correlation
If h_1≠h_2 mod p and n is Haar-uniform in \(\mathbb Z_p\), then
\[
E[(-1)^{v_p(n+h_1)+v_p(n+h_2)}]
=
1-\frac{4}{p+1}
=
\frac{p-3}{p+1}.
\]

Proof. At most one shifted form has positive p-valuation. Outside the two residue classes (probability 1-2/p), product sign is +1. On one chosen residue class, conditional on divisibility, valuation distribution is 1+Geom with
\[
E[(-1)^v\mid p|n+h_j]
=
-\frac{p-1}{p+1}.
\]
Therefore
\[
E[\text{product}]
=
1-\frac2p
+\frac2p\left(-\frac{p-1}{p+1}\right)
=
\frac{p-3}{p+1}.
\]
QED.

## 560. Exact annihilation at p=3 for distinct-residue two-leg parity
Under Theorem 559 with p=3,
\[
E[(-1)^{v_3(n+h_1)+v_3(n+h_2)}]=0.
\]

Proof. Substitute p=3. QED.

This reproduces, in a self-contained elementary derivation, the local annihilation phenomenon recorded in the Prime-Pair library.

## 561. Any global correlation surviving a locally annihilated p=3 mode must use information beyond that local mode
Let A be the two-leg p=3 parity sign in Theorem 560, so E[A]=0. Let Y be any statistic independent of A, and let B be a bounded target predictor measurable from (Y,Z). Then
\[
|E[AB]|\le\sqrt{2I(A;Z|Y)}
\]
under the conditional-balance hypotheses of the earlier information theorem.

Proof. Apply the conditional-information correlation bound already proved. QED.

## 562. CRT separates finite local residue data from unresolved integer tail
Fix modulus M. Every integer n has unique representation
\[
n=r+Mq,\qquad 0\le r<M.
\]
All residue predicates modulo divisors of M depend only on r, while q remains unresolved.

Proof. Euclidean division and reduction modulo divisors of M. QED.

## 563. Finite congruence information cannot determine primality on an unbounded progression
Fix M and residue r with gcd(r,M)=1. The congruence class n≡r mod M contains infinitely many composite integers.

Proof. Choose any integer k>1 with k≡1 mod M. Then n=rk satisfies n≡r mod M and is composite if r>1; if r=1, choose two integers a,b>1 each ≡1 mod M and n=ab. QED.

This proves only non-determination of primality by a fixed finite modulus; it does not assert infinitude of primes in the class.

## 564. Fixed finite divisibility data cannot determine exact factorization charge on all integers
For any finite prime set S, V_S does not determine Ω(n), λ(n), or primality.

Proof. Ω/λ failure is Theorem 551. Primality: states 1 and q outside S have same V_S but differ in primality status (taking q prime and interpreting 1 as nonprime); alternatively q and q_1q_2 with all primes outside S have same visible vector and differ in λ/Ω and primality. QED.

## 565. Full divisibility tower removes the finite-scale obstruction
If all prime valuations are supplied, Ω, λ, and n are exactly determined.

Proof. Theorems 548–550. QED.

Thus the obstruction is finite-scale information loss, not failure of the complete valuation representation.
