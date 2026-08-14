# Zero pivot: endpoint or witnessed relocation

Let

\[
A=\begin{pmatrix}0&b\\c&d\end{pmatrix}.       \tag{1}
\]

The pair `(b,c)` exhausts the possibilities:

1. If `b=c=0`, (1) is already diagonal. If also `d=0`, it is the zero matrix;
   otherwise it is a rank-one diagonal endpoint with leading zero.
2. If `c!=0`, swapping the two rows moves `c` to the leading pivot. This is
   chosen even when `b!=0`, giving a canonical row-first rule.
3. Otherwise `c=0` and the non-endpoint hypothesis forces `b!=0`; swapping
   columns moves `b` to the leading pivot.

The row and column swaps are unimodular. Exact multiplication verifies `LAR`
and both preserve determinant magnitude.

## No-go: raw pivot is not a global per-operation measure

A relocation sends pivot magnitude from zero to `|c|` or `|b|`. Therefore the
claim that pivot magnitude strictly decreases at every operation is false.
Relocation must instead be treated as a finite preparatory chart change; strict
pivot descent belongs only to subsequent nonclosing residual transitions.

This classification does not yet canonicalize the rank-one endpoint
`diag(0,d)` to `diag(|d|,0)`, nor prove termination of the composed reducer.
