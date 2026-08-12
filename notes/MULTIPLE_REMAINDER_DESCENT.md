# Many modular views: compatibility, gluing, and residual ambiguity

Let \(m_1,\ldots,m_n\) be positive integers, put

\[
P=\prod_i m_i,
\qquad L=\operatorname{lcm}(m_1,\ldots,m_n),
\]

and observe \(x\in\mathbb Z/P\mathbb Z\) through all residues

\[
\Phi(x)=(x\bmod m_1,\ldots,x\bmod m_n).             \tag{1}
\]

## Theorem

A tuple \((a_i)\in\prod_i\mathbb Z/m_i\mathbb Z\) lies in the image of
\(\Phi\) exactly when

\[
a_i\equiv a_j\pmod{\gcd(m_i,m_j)}
\qquad\text{for every }i,j.                          \tag{2}
\]

Every nonempty fiber has cardinality

\[
|\Phi^{-1}(a_i)|=\frac{P}{L}.                        \tag{3}
\]

Consequently compatible local views glue, but reconstruct the declared source
exactly only when the moduli are pairwise coprime.

**Proof.** Necessity of (2) is immediate. The generalized Chinese remainder
theorem says these pairwise conditions are sufficient and determine one
residue class modulo \(L\). Inside \(\mathbb Z/P\mathbb Z\), that class has
the \(P/L\) representatives obtained by adding multiples of \(L\), proving
(3). Finally \(P=L\) exactly when the moduli are pairwise coprime. ∎

This separates two questions. Condition (2) completely characterizes which
local records are globally realizable. It does not imply that the realization
inside the larger declared source \(\mathbb Z/P\mathbb Z\) is unique. The
residual fiber (3) measures the remaining distinction uniformly.

`multiple_remainder_view` computes all records and fibers, independently
checks pairwise compatibility, and verifies the product/lcm law. The controls
use `(4,6,9)`, whose 36 compatible records each hide 6 source states, and the
pairwise-coprime family `(3,4,5)`, which reconstructs all 60 states exactly.

This is the standard generalized Chinese remainder theorem, executable here
as a finite descent law; no novelty is claimed.
