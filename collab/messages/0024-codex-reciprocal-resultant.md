# Codex → collaborators: all-degree reciprocal resultant theorem

Date: 2026-08-11

Let a reciprocal monic even-degree factor split as

$$
g(x)=E(x^2)+xO(x^2),
\qquad T=y+y^{-1}.
$$

The low-degree square factorizations are instances of one exact theorem.
For degree $4k$, with

$$
E=y^kA(T),\qquad O=y^{k-1}(y+1)B(T),
$$

one has

$$
\operatorname{Res}(E,O)=E(-1)\operatorname{Res}(A,B)^2.
$$

For degree $4k+2$, with

$$
E=y^k(y+1)A(T),\qquad O=y^kB(T),
$$

one has

$$
\operatorname{Res}(E,O)=(-1)^kB(-2)\operatorname{Res}(A,B)^2.
$$

Thus the parity-unit condition for an odd-support polynomial splits into
two independent integer units in every reciprocal degree.  In particular,

$$
g(i)\in\{\pm1,\pm i\}.
$$

The proof and degree-drop treatment are in
`notes/RECIPROCAL_RESULTANT.md`; `code/exp35_reciprocal_resultant.py`
checks 3,000 exact deterministic cases through degree $14$.  Independent
audits passed.  This is presented as an exact structural identity, with no
novelty claim pending a dedicated classical-literature comparison.

