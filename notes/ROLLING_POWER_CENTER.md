# A rolling power register trades memory for multiplication

The explicit valuation compiler retains the entire ladder
`p,p^2,...,p^k`. That makes its arithmetic formation count optimal under its
operand contract, but the ladder is not forced as persistent memory.

## Rolling representation

First construct and retain the modulus `M=p^k` by any multiplication chain for
the exponent `k`. Let its length after formed `p` be `L(k)`. For binary
exponentiation,

\[
L_2(k)=\lfloor\log_2 k\rfloor+\operatorname{popcount}(k)-1.
\]

Initialize a rolling scale `s=1`. At level `ell`, `s=p^ell`. With recovered
prefix `a`, form the candidate centers

\[
C_d=M-a-ds,qquad d=0,\ldots,p-2,
\]

by the same subtractive chain as before. After determining the digit, update

\[
s\leftarrow p s
\]

unless the terminal level has been reached.

**Theorem.** This program produces exactly the same centers, responses, and
recovered residue as the ladder program. It retains only `M` and the current
scale `s` as derived power values, but uses

\[
L(k)+(k-1)                                             \tag{1}

\]

power multiplications: `L(k)` to form `M`, then `k-1` rolling updates. With
binary exponentiation this is

\[
\lfloor\log_2 k\rfloor+\operatorname{popcount}(k)+k-2. \tag{2}

\]

*Proof.* Inductively `s=p^ell`; substituting it into the center formula gives
the original protocol verbatim. The update establishes the next induction
step. The multiplication and live-value counts are immediate. ∎

For `k>1`, (1) exceeds the retained sequential ladder's `k-1` multiplications
by `L(k)`: the ladder computed `M` while creating every later displacement,
whereas rolling computation creates `M` and then recreates those scales. The
rolling program buys bounded live power memory by paying recomputation.

## Consequence for the lower bound

`EXPLICIT_COMPILER_LOWER_BOUND` remains correct: this program declines its
operand contract by not materializing the whole ladder simultaneously. It
therefore refutes only an illicit extension of that theorem to a universal
memory bound. Formation cost, live memory, and semantic query count are three
different coordinates.

The center lift and trace remain proof-relevant, consistent with
`PROBE_COST_DESCENT_NO_GO`: the same residue-valued probe could have other
lifts and costs. This construction chooses canonical positive centers and
supplies their dependencies.

## Rigor boundary

The trace identity and exact counts are proved. Tests compare every bounded
residue against the retained-ladder compiler. “Two live power values” excludes
the initially held generator `p` and arithmetic scratch inside the chosen
exponentiation routine; no reversible pebbling or gate-optimality claim is
made.

