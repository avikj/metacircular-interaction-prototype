# The Rule 30 centre column: status, structure, and what a kernel can and cannot certify

Oracle report, written for the Cubical Agda corpus. Conventions used throughout:
Rule 30 is the elementary CA with local rule f(l,c,r) = l XOR (c OR r) (Wolfram code 00011110),
x_t(i) is the cell at position i at time t, the single seed is x_0(i) = [i = 0], and the centre
column is c_t = x_t(0). All numerical facts below were recomputed for this report (column to depth
2^21, C code; analyses in numpy) and agree with the depth-64 prefix held in the corpus:

    c_0.. c_63 = 1101110011000101100100111010111001110101011000011001010110101011
    c_64..c_127 = 1111000011110001010111000001001011000111000110110110100000001000

The row recursion in bit-packed form (bit j of the row at time t = position j - t) is
R_{t+1} = (R_t << 2) XOR ((R_t << 1) OR R_t), R_0 = 1, and c_t = bit t of R_t; this is the cheapest
kernel-checkable definition and the one used for the numbers here. The "Rule 30 constant"
sum c_t 2^{-(t+1)} is 0.86239... (binary 0.1101110011...).

---

## 1. What is known and proved about the centre column

### 1.1 The three prize problems (Wolfram, "Announcing the Rule 30 Prizes", 1 Oct 2019; $10,000 each)

Problem 1 (non-periodicity). Does the centre column always remain non-periodic? Precisely: is it
false that there exist N, p >= 1 with c_{t+p} = c_t for all t >= N? Status: OPEN. No proof in
either direction; no prize awarded as of this writing (my knowledge runs to mid-2026).

Problem 2 (equidistribution). Does each colour occur on average equally often in the centre
column? Precisely: does (1/n) #{t < n : c_t = 1} -> 1/2? Status: OPEN. Note the statement is
only about the frequency of single symbols, not normality (Section 4, 7).

Problem 3 (irreducibility). Does computing the n-th cell of the centre column require at least
O(n) computational effort? Wolfram's phrasing is deliberately informal; the intended content is
"there is no algorithm computing c_n in time o(n)" (in any reasonable bit model), equivalently
that the direct simulation cannot be short-cut. Status: OPEN, and not even precisely
formalised; a negative answer via, say, automaticity (Section 4.4) would give c_n in O(log n).
The only known upper bound is the trivial one: c_n by simulation costs Theta(n^2) cell updates,
Theta(n^2 / w) word operations (the row at time t has width 2t+1).

Wolfram had posed all three, in almost the same words, in "Twenty problems in the theory of
cellular automata" (Physica Scripta T9, 1985) and in the notes to Chapter 6 of A New Kind of
Science (2002, p. 871 ff.). The centre column was the default pseudo-random generator of
Mathematica (Random[]) from 1988 until version 6, which is the practical origin of Problem 2.

### 1.2 The searched depth (Problem 1 lower bounds)

Everything known in the direction of Problem 1 is finite search. The published numbers I can
vouch for: NKS (2002) reports no periodicity in the first several million cells; the 2019 prize
announcement reports the column computed and tested to on the order of 10^9 cells (my
recollection is 2^30 ~ 1.07 x 10^9, the length also used for the Problem 2 statistics; I am not
certain of the exact exponent and no better-sourced bound is known to me). Nobody else has
published a materially deeper search. What such a search proves is only the finite exclusion
theorem of Section 5: for every (N, p) with a mismatch c_i != c_{i+p}, N <= i < D - p, the column
is not (N, p)-eventually periodic.

For this report I recomputed to depth D = 2^21 = 2,097,152 and verified the following
unconditional (computer-checked, not kernel-checked) statement, which is at least as strong as
anything published in this form:

  For every period p <= 65,536 there is an index i with c_i != c_{i+p} and i >= D - p - 18.
  Hence the centre column is not (N, p)-eventually periodic for any p <= 2^16 and any
  N <= 2^21 - 2^16 - 18 = 2,031,598. In particular it is not the binary expansion of any
  rational with denominator <= 65,536.

(The "18" is the worst case, attained at p = 17,474: the last mismatch is 18 places before the
end of the comparable window; a random sequence gives a worst case around log_2(2^16) ~ 16.)

### 1.3 Problem 2 data

On the first 2^20 cells: 524,976 ones, 523,600 zeros; ones minus zeros = 1,376, i.e.
1.34 standard deviations for a fair coin; frequency of ones 0.50066. Max |ones - zeros| over all
prefixes of length <= 2^20 is 1,744 (at n = 964,777). Nothing is proved: not even that the
frequency of ones has a limit, nor that it is bounded away from 0 or 1. The best that is
provable today is the finite statement above.

### 1.4 Problem 3

Nothing is proved. There is no known algorithm computing c_n in time o(n) and no lower bound of
any kind (lower bounds of this sort are far beyond current complexity theory: they would imply
separations at least as hard as those for explicit functions in linear time). What is known and
easy: c_n is computable in O(n^2) bit-operations, in O(n) space, and lies in the polynomial
hierarchy trivially; nothing better.

---

## 2. Eventually periodic iff rational, and the dyadic boundary

**Theorem.** Let c = (c_t)_{t>=0} be a binary sequence and alpha = sum_t c_t 2^{-(t+1)} in [0,1].
Then c is eventually periodic iff alpha is rational.

Proof. (=>) If c_{t+p} = c_t for t >= N, write A = sum_{t<N} c_t 2^{N-1-t} (integer) and
B = sum_{j<p} c_{N+j} 2^{p-1-j} (integer). Then alpha = 2^{-N} (A + B/(2^p - 1)), rational,
with denominator dividing 2^N (2^p - 1).
(<=) Let alpha = a/m with 0 <= a < m. Define r_0 = a, digit_t = [2 r_t >= m], r_{t+1} = 2 r_t - m digit_t
(= 2 r_t mod m). By induction alpha = sum_{t<n} digit_t 2^{-(t+1)} + 2^{-n} r_n / m for all n, so
(digit_t) is a binary expansion of alpha. The remainders lie in {0,...,m-1}; among r_0,...,r_m two
coincide, r_i = r_j with 0 <= i < j <= m, hence r_{t+(j-i)} = r_t for t >= i, so (digit_t) is
(N, p)-eventually periodic with N = i <= m-1 and p = j-i <= m. This is exactly the corpus
theorem (a). It remains to pass from "some expansion of alpha is e.p." to "c is e.p.", which is
the boundary case. QED modulo:

**Boundary (two expansions).** A real in (0,1) has two binary expansions iff it is a dyadic
rational k/2^n (0 < k < 2^n odd); the two are w 1 0^infty and w 0 1^infty. Both are eventually
periodic (period 1). Hence: if alpha is rational, every expansion of alpha is eventually
periodic, and the theorem holds with "c" any expansion. So "column eventually periodic <=>
0.c rational" is unconditionally true, with no boundary caveat.

**What the remainder recursion produces.** The recursion never emits a tail 1^infty: if
digit_t = 1 for all t >= n then r_{t+1} = 2 r_t - m for t >= n, so r_t - m = 2^{t-n} (r_n - m) with
r_n - m <= -1, giving r_t -> -infty, contradicting 0 <= r_t < m. It also never emits the
expansion 0.1^infty of 1 since a < m. Hence the recursion produces exactly the greedy
(terminating, for dyadics) expansion, i.e. the unique expansion not ending in 1^infty.

Consequence for the corpus predicate. "c is the column of a/(b+1) under the recursion" is
strictly stronger than "0.c = a/(b+1)": if the Rule 30 column ended in 1^infty (period 1,
value 1), it would be eventually periodic and rational, yet the column of NO rational under
the recursion. Therefore the statement that should be certified is the direct one,
"c has no (N, p) shift agreement with N <= b, p <= b+1", from which "c is not the recursion
column of any a/(b+1)" follows as a corollary; the converse direction is what the boundary
case blocks. Your check (all (p <= 16, N < 16) shift agreements) is the direct form, so it
covers the 1^infty tail as the case p = 1; state the theorem in that form and derive the
rational corollary, not the other way around. (Concretely c_{63} = 1 and c_{64..67} = 1111 is
the longest run of ones near the start; the longest run of equal bits in the first 2^20 is 22.)

---

## 3. Unconditional theorems about the column and the evolution

### 3.1 Left-permutivity and what it buys

f(l, c, r) = l XOR g(c, r), g(c, r) = c OR r. For fixed (c, r) the map l |-> f(l, c, r) is a
bijection of {0,1}: Rule 30 is left-permutive (Hedlund 1969, "Endomorphisms and automorphisms
of the shift dynamical system"). It is not right-permutive: r |-> f(l, 1, r) is constant.

(i) Surjectivity. Every permutive CA on {0,1}^Z is surjective (Hedlund): given y, choose the
preimage's values on positions >= n arbitrarily-consistently and solve leftwards,
x(i-1) = y(i) XOR g(x(i), x(i+1)). Rule 30 is not injective (1^infty and 0^infty both map to
0^infty); it is not among the six reversible elementary rules (15, 51, 85, 170, 204, 240).
By Hedlund's theorem a CA is surjective iff it preserves the uniform Bernoulli measure; for
permutive rules the uniform measure is moreover strongly mixing (Kleveland 1997), and
Shereshevsky (1992) showed such maps are expansive. This is the rigorous sense in which
"Rule 30 from random initial conditions is random": it is a Bernoulli-preserving mixing map.
None of it says anything about the orbit of one specific point, the single seed.

(ii) The column bijection. Fix the right half rho = (x_0(i))_{i>=0} and read off the column
kappa = (x_t(0))_{t>=0} (so kappa_0 = rho_0). Then the map
  Phi_rho : {left halves (x_0(i))_{i<0}} -> {columns kappa with kappa_0 = rho_0}
is a bijection. Proof. Solve leftwards in space, forward in time: given all of columns 0 and
1 for all times, column -1 is determined for all times by x_{t-1}(-1) = x_t(0) XOR g(x_{t-1}(0), x_{t-1}(1)),
t >= 1. Column j >= 1 at time t depends only on columns j-1, j, j+1 at time t-1, so the quadrant
{i >= 0, t >= 0} is determined by rho and kappa (induction on t), and then columns -1, -2, ...
are determined in turn. The constructed diagram satisfies the local rule everywhere (the
inverse relation is equivalent to the forward one), so its row 0 is a left half producing
kappa, and it is the only one. Moreover x_0(-k) depends only on kappa_0..kappa_k and
rho_0..rho_k (the dependency cone). This is the theorem behind Wolfram's remark that "any
sequence can appear in the centre column with a suitable left initial condition" and behind
the Meier-Staffelbach (1991) attack on Rule 30 stream ciphers. Corpus-relevant reading: for
rho = 1 0^infty, non-periodicity of the seed's column is EXACTLY the statement that
Phi_rho^{-1}(kappa) != 0^infty for every eventually periodic kappa with kappa_0 = 1. This
reformulation is exact but not helpful (Section 6.iii).

(iii) What it does not give. Left-permutivity constrains the diagram to the left of a
column given the column and everything to its right. The single seed pins the right half
(1 0^infty) and the LEFT half (0^infty); the column is the unknown in the middle. Permutivity
alone yields no constraint on one column in isolation: every column sequence is realised by
some left half.

### 3.2 Jen's theorem: no two adjacent columns are both eventually periodic

This is, to my knowledge, the strongest unconditional statement in the direction of
Problem 1, due to Erica Jen ("Aperiodicity in one-dimensional cellular automata",
Physica D 21 (1986) 217-236; cited in NKS p. 871 as "two adjacent columns can never both be
periodic"). The proof below is self-contained and uses only structural induction, so it is a
prime candidate for the kernel.

Lemma A (left edge). For any initial configuration with finite support and leftmost 1 at
position l_0, the leftmost 1 at time t is at l_0 - t and equals 1. Proof: at position l_t - 1,
f(0, 0, 1) = 1; at positions < l_t - 1 all three inputs are 0 and f(0,0,0) = 0.
For the single seed: x_t(-t) = 1 for all t, and x_t(i) = 0 for i < -t.

Lemma B (leftward propagation of periodicity). If columns i and i+1 satisfy
x_{t+P}(j) = x_t(j) for all t >= N (j = i, i+1), then column i-1 satisfies the same with the
same N and P. Proof: x_{t-1}(i-1) = x_t(i) XOR g(x_{t-1}(i), x_{t-1}(i+1)) for t >= 1, and the
right-hand side is P-periodic in t for t-1 >= N.

Theorem (Jen). For Rule 30 from any finite-support nonzero initial condition, no two
adjacent columns are both eventually periodic.
Proof. Suppose columns i, i+1 are both eventually periodic; take a common preperiod N and
period P (lcm). By Lemma B and induction, every column j <= i is P-periodic from time N on.
Pick j <= i with l_0 - j > N + P. By Lemma A, x_t(j) = 0 for all t < l_0 - j, in particular for
N <= t < N + P, hence by periodicity x_t(j) = 0 for all t >= N. But x_{l_0 - j}(j) = 1 by Lemma A
and l_0 - j >= N. Contradiction. QED

Corollaries. (a) If the centre column is eventually periodic then neither column 1 nor
column -1 is. (b) In every window of consecutive columns at least half are not eventually
periodic; in particular the single-seed diagram contains infinitely many columns whose
binary value is irrational (Section 2). (c) The proof yields nothing for a single column:
the inversion in Lemma B consumes two adjacent periodic columns. This is precisely where
any "left-permutivity forces a contradiction" argument for Problem 1 stops (Section 6.iii).

### 3.3 Diagonals: exact closed recurrences and periodicity theorems

Because the light-cone speed equals the neighbourhood radius, both families of edge-parallel
diagonals satisfy closed recurrences. Write d_k(t) = x_t(t - k) (k-th diagonal from the right
edge) and e_k(t) = x_t(-t + k) (k-th from the left edge), with d_k = e_k = 0 for k < 0.

Right diagonals: d_k(t) = d_k(t-1) XOR ( d_{k-1}(t-1) OR d_{k-2}(t-1) ),  d_k(0) = [k = 0].
Left diagonals:  e_k(t) = e_{k-2}(t-1) XOR ( e_{k-1}(t-1) OR e_k(t-1) ),  e_k(0) = [k = 0].
The centre column is the diagonal of either triangular array: c_t = d_t(t) = e_t(t).

Theorem R. Every right diagonal d_k is purely periodic (preperiod 0) with period pi_k a power
of 2, pi_k | 2 lcm(pi_{k-1}, pi_{k-2}), so pi_k <= 2^k. Proof: d_k(t) = XOR_{u<t} s_k(u) with
s_k = d_{k-1} OR d_{k-2} (prefix parity); if s_k is purely periodic with period L then
d_k(t + L) = d_k(t) XOR (parity of s_k over one period), so d_k is purely periodic with period
L or 2L. Base: d_0 = 1, d_1(t) = d_2(t) = t mod 2, d_3 = (0011)^infty.
Computed periods pi_0, pi_1, ...: 1, 2, 2, 4, 8, 8, 16, 32, 32, 64, 64, 64, 64, 64, 64, 128,
256 (x8, k = 16..23), 512, 1024, 1024, 2048, 2048, 4096 (x5), 8192, 8192, ... (k <= 35,
depth 40,000). This is the "1, 2, 2, 4, 8, 8, 16, 32, 32, 64, ..." sequence noted by Wolfram
(NKS notes to Chapter 6). Growth is roughly 2^{0.4 k}. The right side of the picture LOOKS
chaotic precisely because pi_k exceeds the time t at which diagonal k is visible.

Theorem L. Every left diagonal e_k is eventually periodic with period <= 2^k. Proof by
induction: for t past a common preperiod of e_{k-1}, e_{k-2} (period L), the one-step map
e_k(t-1) |-> e_k(t) is either constant (when e_{k-1}(t-1) = 1) or a XOR by e_{k-2}(t-1); the
L-fold composite is a self-map of {0,1}, constant if e_{k-1} takes the value 1 in the period
(then e_k has period dividing L and preperiod at most N + L), else e_k is a prefix parity of
e_{k-2} and has period dividing 2L.
Computed (preperiod, period) for k = 0..39: (0,1), (1,1), (2,1), (2,2), (2,1), (2,2), (2,2),
(0,1), (2,4), (5,1), (6,4), (8,4), (6,4), (10,4), ..., (50,8): the periods stay <= 8 and the
preperiods grow ~ 1.3 k. Explicitly e_0 = 1, e_1(t) = 1 (t >= 1), e_2(t) = 0 (t >= 2),
e_3 = alternating from t = 2. So the LEFT side is the regular side: the diagonal stripes in
the classic picture are these small-period diagonals. The linear growth of the preperiod,
N_k ~ 1.3 k, is the statement that disorder spreads leftward at speed ~ 1 - 1/1.3 ~ 0.24,
matching the measured left Lyapunov velocity of Rule 30 (~0.24; Wolfram 1986, NKS p. 251).

So the two "regular structure of the edges" claims of the question are: right edge d_0 = 1,
d_1 = d_2 = alternating (period 2), d_3 period 4, then doubling; left edge e_0 = e_1 = 1,
e_2 = 0, e_3 period 2, all left diagonals of tiny period after a linear preperiod. Both
theorems are structural inductions on k and t and are kernel-checkable, including the exact
periods for any fixed k (finite computation).

### 3.4 What is NOT known unconditionally

Not known: that the column is not eventually constant; that it is not eventually periodic
with any specific period beyond the search bound; any nontrivial lower bound on p(n) for all
n; any lower bound on the frequency of either symbol; non-automaticity; transcendence or
even irrationality of the Rule 30 constant. Trivially known: the sequence of rows never
repeats (row t has width 2t+1); the column is computable; c_0 c_1 c_2 c_3 = 1101, so the
column is not 0^infty or 1^infty, and by the depth-2^21 search it is not (N, p)-periodic
for p <= 2^16, N <= 2,031,598.

---

## 4. Where the column sits in the landscape: complexity, normality, automaticity

### 4.1 Morse-Hedlund

**Theorem (Morse-Hedlund 1938, "Symbolic dynamics", Amer. J. Math. 60).** For an infinite
word c over a finite alphabet with factor-complexity p(n) = #{distinct length-n factors},
the following are equivalent: (a) c is eventually periodic; (b) p is bounded;
(c) p(n) <= n for some n >= 1; (d) p(n+1) = p(n) for some n.
Proof. (a)=>(b): if c is (N,P)-e.p. then every length-n factor occurs at a position < N + P
(a factor at position i >= N + P equals the one at i - P), so p(n) <= N + P for all n.
(b)=>(d): p is non-decreasing and integer-valued. (d)=>(a): if p(n+1) = p(n), every length-n
factor u has exactly one letter a with ua a factor (at least one since c is infinite; at most
one by counting), so the successor map on length-n factors is a function on a finite set,
and the sequence of windows w_i = c_i..c_{i+n-1} is its orbit, hence eventually periodic, hence
so is c. (c)=>(d): p(1) >= 1 (assume both letters occur, else p = 1 = bounded); if
p(k+1) > p(k) for all k < n then p(n) >= p(1) + n - 1 >= n + 1 > n. QED
Corollary: c is NOT eventually periodic iff p(n) >= n + 1 for all n >= 1 (the minimum n + 1 is
attained exactly by the Sturmian words, e.g. the Fibonacci word and all irrational-rotation
codings: this is why the "irrational rotation" members of your corpus are the least complex
non-returning objects).

Two consequences for certification. (1) A single complexity value refutes a whole box of
(N, P): if p(n_0) > Q + P on a prefix then c is not (N, P)-e.p. for any N <= Q, P <= P (the count
p(n_0) computed on a prefix is a lower bound for the true p(n_0)). (2) Any proof that
p(n) >= n + 1 for all n would settle Problem 1; no such bound is known for any n beyond the
search range, i.e. nothing is known about p(n) for the column except by finite computation.

### 4.2 Computed complexity of the column

p(n) on the first D bits (a lower bound for the true p(n)); "full" means p(n) = 2^n:

  D = 64:     2, 4, 8, 15, 26, 36, 44, 49                        full for n <= 3
  D = 128:    2, 4, 8, 16, 32, 59, 84, 103, 115                  full for n <= 5
  D = 1024:   ..., 64, 127, 248, 442, 632, 790, 892              full for n <= 6
  D = 4096:   ..., 512, 1017, 1791, 2599, 3239, 3628             full for n <= 9
  D = 2^16:   ..., 4096, 8190, 16034, 28113, 41132, 51253, 57754 full for n <= 12
  D = 2^20:   ..., 65536, 131035, 257327, 453085, 662481, 824901, 927733   full for n <= 16

A uniformly random word of length 2^20 has all 2^n factors with high probability iff
2^n (n ln 2) << 2^20, i.e. n <= 16, and at n = 17 is expected to miss about
2^17 exp(-2^20/2^17) ~ 44 words; the column misses 37. The column is, at this resolution,
indistinguishable from a random word: full complexity as far as the length permits.
Immediate corollary (with 4.1): on the first 2^20 bits p(16) = 65536, so the column is not
(N, P)-e.p. for any N + P <= 65535; on the first 4096 bits p(9) = 512, so not for N + P <= 511
(this alone excludes all denominators <= 256, cf. Section 5).

### 4.3 Normality

Conjecture (folklore, Wolfram 1985/1986, "Random sequence generation by cellular automata",
Adv. Appl. Math. 7): the column is normal in base 2, i.e. every block of length k has
asymptotic frequency 2^{-k}; equivalently (Borel) the Rule 30 constant is a normal number.
Prize Problem 2 is the k = 1 case. Status: open for every k, including k = 1; the evidence is
statistical (Section 7 gives the block counts). Note normality is strictly stronger than
"p(n) = 2^n for all n" (disjunctiveness), which is strictly stronger than non-periodicity;
none of the three is known.

### 4.4 Automaticity

**Theorem (Cobham 1972).** A k-automatic sequence has p(n) = O(n). (Proof idea: the length-n
factor at position i is determined by the automaton state after reading the top digits of i
together with the low ~log_k n digits, giving at most C n possibilities.) More generally,
morphic sequences have p(n) = O(n^2) (Pansiot 1984). Hence "p(n)/n -> infinity" implies
non-automatic; "p(n)/n^2 -> infinity" implies non-morphic; disjunctive (p(n) = 2^n) implies both.
**Theorem (Adamczewski-Bugeaud 2007, Annals).** The real number whose base-k expansion is
automatic is rational or transcendental.
Status for Rule 30: it is NOT known that the column is non-automatic (nor non-morphic); no
proof exists. It is universally expected: k-automaticity would give an O(log n)-time
algorithm for c_n, contradicting the expected answer to Problem 3, and would give p(n) = O(n)
against the observed 2^n. What would decide it: any proof of superlinear complexity, or a
direct proof that the k-kernel {(c_{k^e n + r})_n} is infinite for every k. Neither is in
sight; even non-periodicity is open, and automatic sequences can be aperiodic, so
non-automaticity is not the "easier" half of anything, it is incomparable with Problem 1
(automatic and aperiodic is common: Thue-Morse; non-automatic and periodic is impossible).

### 4.5 Placement

In the corpus's taxonomy (generative = never returns, rational = returns): the irrational
rotation, Pell/Brahmagupta, and Sturmian words are non-returning with the SMALLEST possible
complexity (p(n) = n + 1, or the linear complexity of automatic/morphic words); their
non-return is proved by an invariant (an irrational slope, a unit of infinite order). The
Rule 30 column is conjectured to be non-returning with the LARGEST possible complexity
(p(n) = 2^n, normal, irreducible), and no invariant is known: its non-periodicity, if true,
would be the first example in the corpus of "never returns" without a conserved quantity
that witnesses it. That is the precise sense in which it is a different kind of object, and
why every known theorem about it is a finite computation or a statement about other columns
and diagonals (Section 3).

---

## 5. The finite-check method: exact cost, the exact theorem, and its limits

Set m = b + 1 (denominator), 0 <= a < m. From Section 2: the recursion column of a/m is
(N, p)-e.p. with N <= m - 1 and p <= m (some pair; the minimal period divides this p, and the
minimal preperiod is <= N). Say c is "(N, p)-agreeing to depth D" if c_i = c_{i+p} for all i with
N <= i and i + p < D.

**Theorem (soundness of refutation, any depth).** If for every pair (N, p) with N <= P - 1,
p <= P the column c fails to be (N, p)-agreeing to depth D, i.e. there is an index i with
N <= i < D - p and c_i != c_{i+p}, then c is not (N, p)-e.p. for any such pair, hence not the
recursion column of any a/m with m <= P, hence (Section 2) 0.c is not equal to any rational
with denominator <= P other than possibly via a 1^infty tail, and the tail case is excluded
too because p = 1, N <= P-1 is in the box. Proof: (N,p)-e.p. implies (N,p)-agreeing to every
depth. QED
There is no depth hypothesis in the theorem. The depth enters only in whether the
hypothesis can be true: the window [N, D - p) must be nonempty, so D > N + p, and the
refutation of a given pair happens at depth exactly 1 + p + (first i >= N with c_i != c_{i+p}).
That first mismatch index is a property of the data and is NOT bounded a priori by any
function of (N, p): a truly periodic sequence never yields it, and a sequence agreeing for
a long stretch may need arbitrarily large D. So "depth N + 2p suffices" is not a theorem.
What "N + 2p" (and your D = 3P) does guarantee is completeness in the opposite direction:
with D >= N + 2p the window contains a full period of comparisons, so agreement to depth D
means the observed prefix is genuinely (N,p)-periodic over at least one period, i.e. the
test is a faithful decision procedure for the finite hypothesis "the first D bits are
(N,p)-periodic"; with a shorter window a positive answer could be an artefact of too little
data. In short: refutation is sound at any depth; 3P makes the (N,p) scan a complete test
of the finite statement; neither bounds the depth at which a refutation appears.

Empirical refutation depths for the column (minimal D such that every (N <= P, p <= P) pair
is refuted; worst pair in parentheses as (N, p, first mismatch)):
  P = 8: 20 (7, 7, 12);  P = 16: 35 (15, 14, 20);  P = 32: 66 (32, 29, 36);
  P = 64: 133 (64, 64, 68);  P = 128: 262;  P = 256: 513;  P = 1024: 2050.
The pattern ~2P + 2 is what a random sequence gives (first mismatch a geometric(1/2) beyond
N = P, plus p = P). Your choices: D = 64 for P = 16 (needed 35; 3P = 48 <= 64: complete and
refuting) and D = 128 for P = 32 (needed 66; 3P = 96 <= 128: complete and refuting). Both are
correct and both are refuting; the second will pass. Cost of the scan: for each p, one
left-to-right pass computing the first mismatch index >= N for all N at once (the mismatch
positions for that p, in order), so O(P D) bit comparisons total, not O(P^2 D); in Agda with
lists this is trivial at D = 128 and remains fine at D ~ 10^4. The column itself costs
sum_{t < D} (2t + 1) = D^2 cell updates; D = 4096 is 1.7 x 10^7 updates, feasible for the
evaluator with a bit-list representation (minutes), D = 2^16 (4 x 10^9) is not, unless the
kernel has fast bitwise operations on naturals (Agda's builtin Nat has fast +, *, div, mod
but no builtin xor/and/or, so the packed form R' = (R<<2) xor ((R<<1) or R) does not help
inside the type checker). Note also the cheaper certificate of 4.2: computing p(n_0) on the
prefix (one sort of D - n_0 + 1 words) refutes all N + p < p(n_0) in one stroke; at D = 4096
this gives N + p <= 511, which matches what the direct scan achieves at the same depth.

Honest conclusion. The finite method establishes, and can only ever establish, statements
of the form "c is not (N, p)-e.p. for (N, p) in a finite box", equivalently "0.c is not a
rational with (preperiod, period) in that box", equivalently a lower bound on any period or
preperiod. It can never establish non-periodicity, nor irrationality, nor even "not
eventually constant": each of these is a Pi_1 statement over all (N, p) and no finite prefix
decides it. A complete proof of Problem 1 would require an invariant or a structural
obstruction valid for all periods at once, of a kind that exists nowhere in the current
theory of Rule 30; the only structural theorem in that direction (Jen, Section 3.2) uses two
columns and cannot be reduced to one. Conversely a disproof would be a finite object: a
pair (N, p) and, since the check would only confirm agreement to finite depth, a proof that
agreement persists; for a single-seed CA even that direction has no known finite
certificate (periodicity of one column is not decidable by inspection of a prefix).

---

## 6. Kernel-checkable statements beyond small-denominator exclusion

Assessment of the candidates, in decreasing order of value, with the exact reason each
works or fails.

(iii) first, since it is the strongest: **Jen's theorem** (Section 3.2). Statement to
formalise: for every N, P >= 1 and every i, it is not the case that both column i and column
i + 1 of the single-seed evolution satisfy x_{t+P}(j) = x_t(j) for all t >= N. Ingredients:
the light-cone lemma x_t(i) = 0 for i < -t, the left-edge lemma x_t(-t) = 1, and Lemma B
(inversion of left-permutivity), all proved by structural induction on t; the final step is
an induction on the column index j from i down to -(N + P + 1), carrying the invariant
"column j is P-periodic from time N". Corollaries: among any two adjacent columns one is
aperiodic and its binary value is irrational; if the centre column is periodic then columns
+-1 are not. Where a one-column version fails, exactly: Lemma B needs the values of TWO
adjacent columns at time t-1 to invert f in its left argument. Given only column 0 periodic,
column -1 is x_{t-1}(-1) = c_t XOR (c_{t-1} OR x_{t-1}(1)), and x_{t-1}(1) is unconstrained; the
bijection of 3.1(ii) says every choice of the right half is consistent with some left half,
so no contradiction can arise without using that the actual right half is 1 0^infty and the
actual left half is 0^infty simultaneously, which is the whole problem. There is no known
argument, and the reformulation "Phi_{10^infty}^{-1}(kappa) != 0^infty for all e.p. kappa" is
a Pi_1 statement over kappa with a computable but unbounded witness search (the first k with
x_0(-k) = 1), so it is the conjecture verbatim, not a proof strategy.

(i) **An exact recurrence for the column: there is none, provably, unless the conjecture is
false.** If c_t = F(c_{t-1}, ..., c_{t-k}) for a fixed k and F, the k-tuples (c_{t-1..t-k})
evolve by a deterministic map on the finite set {0,1}^k, so c is eventually periodic; hence
such a recurrence exists iff Problem 1 has a positive (periodic) answer. The same holds for
recurrences of bounded order in c together with any finite number of other eventually
periodic sequences. In terms of neighbouring columns the only exact relation is the local
rule itself, c_t = x_{t-1}(-1) XOR (c_{t-1} OR x_{t-1}(1)), and by Jen at most one of the three
columns -1, 0, 1 involved is periodic, so the recurrence cannot close. What DOES close is
the diagonal array of 3.3: c_t = d_t(t) with d_k = prefix-parity of (d_{k-1} OR d_{k-2}), each
d_k purely periodic with period pi_k | 2^k. This is an exact, kernel-checkable "recurrence in
terms of earlier objects", and it explains the absence of a shortcut: to know c_t one needs
d_t on [0, t], whose period pi_t (~2^{0.4 t}) exceeds t for t >= 10 or so, so no diagonal is
ever sampled in its periodic regime by the column. Formalisable statement: (a) the two
recurrences reproduce the evolution (induction on t); (b) Theorem R and Theorem L; (c) for
fixed k <= 20, the exact period pi_k by evaluation.

(ii) **Every finite word is a column prefix.** Statement: for every n and every
w in {0,1}^n with w_0 = 1, there is a finite-support left half L (supported on [-n, -1]) such
that the evolution of L ++ (1 0^infty) has centre column prefix w. Proof: the bijection of
3.1(ii), restricted to the dependency cone: x_0(-k) depends only on kappa_0..kappa_k and
rho_0..rho_k, so a length-n prefix is realised by a left half of length n, computed by the
explicit inversion. This is a theorem, formalisable as a function invert : Vec Bit n -> Vec Bit n
with a proof column (invert w) == w by induction on n (or, for n <= 10, by evaluation over all
2^n words). Its value for the corpus: it is the precise "left-permutive freedom" statement,
and it shows that Problem 1 is a statement about ONE point of a space in which the column is
a bijective coordinate: non-periodicity of the seed is "the coordinate 0^infty of the left
half corresponds to an aperiodic column", with nothing in the bijection favouring either
answer.

(iv) **Edge structure.** Exact statements and proofs are in 3.3: left edge e_0 = 1,
e_1(t) = 1 (t >= 1), e_2(t) = 0 (t >= 2), e_3(t) = t mod 2 (t >= 2); right edge d_0 = 1,
d_1(t) = d_2(t) = t mod 2, d_3 = (0011)^infty, d_4 period 8, ...; Theorem R (every right
diagonal purely periodic, period a power of two, at most 2^k) and Theorem L (every left
diagonal eventually periodic, period at most 2^k; observed periods <= 8 with preperiod
~1.3k). Correction to the question's phrasing: the leftmost cells are 1, 1, 1, ... (e_0), the
RIGHT edge is also all 1s (d_0), and it is the second diagonals that have period 2 (d_1, d_2
on the right; e_3 on the left after two steps). The regular-looking side in the picture is the
left one (small periods); the right side's diagonals are purely periodic but with
exponentially growing periods, which is why it looks disordered.

(v) Two further statements worth having, both trivial to certify: the sequence of rows is
injective in t (width 2t + 1), so the two-sided orbit never returns for a trivial reason,
sharpening the contrast with the column; and the combined complexity certificate of 4.2,
"every word of length n_0 occurs in c_0..c_{D-1}", which by Morse-Hedlund refutes all (N, p)
with N + p < 2^{n_0} at once and is a lower bound on the true p(n_0). Recommended targets at
kernel-feasible depths: (D, n_0) = (1024, 6), (4096, 9) [refutes N + p <= 511, i.e. all
denominators <= 256], and if the evaluator can reach D = 2^16, n_0 = 12 [N + p <= 4095].

---

## 7. The compression / irrationality reading, and the right next claim

Logical status, all unconditional:
  c eventually periodic  <=>  0.c rational                (Section 2, both directions, no boundary caveat)
  c not eventually periodic  <=>  0.c irrational           (contrapositive of the same)
  c not eventually periodic  <=>  p(n) >= n + 1 for all n  (Morse-Hedlund)
So the owner's reading "never repeats means it computes an irrational number" is exactly
right and exactly as strong as Problem 1; nothing more. The distinctions to keep:

  irrational does not imply high complexity: Sturmian words are irrational-valued with
    p(n) = n + 1, and their real numbers (e.g. sum 2^{-floor(k phi)}) are even transcendental
    but maximally structured.
  irrational does not imply non-automatic: Thue-Morse is 2-automatic, p(n) <= 10n/3,
    irrational (indeed transcendental, Mahler 1929), and not normal (it is cube-free, so the
    block 000 never occurs).
  normal does not imply irreducible: Champernowne's binary 0.1 10 11 100 101 ... is normal
    (Champernowne 1933) and its n-th digit is computable in polylog(n) time.
  irreducible does not imply normal (a normal sequence with a computable sparse set of
    positions forced to 0 is still irreducible in any reasonable sense but not normal).
  frequency 1/2 (Problem 2) neither implies nor is implied by non-periodicity ((01)^infty
    has frequency 1/2; an aperiodic sequence may have frequency 1/3 or no frequency).

The hierarchy of "irrationality-strength" properties, and what is conjectured for Rule 30:
  L0  not e.p.  (Problem 1)                                    conjectured; open
  L1  p(n)/n -> infinity  (=> non-automatic by Cobham)          conjectured; open
  L2  p(n) = 2^n for all n  (disjunctive: every word occurs)    conjectured; open
  L3  normal in base 2  (all block frequencies 2^{-k})          conjectured; open (k = 1 is Problem 2)
  L4  computationally irreducible  (Problem 3)                  conjectured; open, and independent of L3
  L0 <= L1 <= L2 <= L3, L4 incomparable with L3. Wolfram's stated conjectures are L0, Problem 2,
  and L4; the community's working assumption is all five.

The right claim to formalise next is the finite version of L2, because it is deterministic,
one count certifies a whole box of periods and preperiods, and it is the first rung that
distinguishes the column from every other "never returns" object in the corpus (rotations,
Sturmians, Thue-Morse all have linear complexity and fail L1 already at n ~ 5):

  Surrogate for L2 (and hence L0, L1 on a box): "every binary word of length n_0 occurs among
  c_0 .. c_{D-1}"; certified values p(n) = 2^n for n <= 9 at D = 4096, n <= 12 at D = 2^16,
  n <= 16 at D = 2^20. By Morse-Hedlund, p(n_0) = 2^{n_0} on a prefix refutes every (N, p)
  with N + p < 2^{n_0}. Against the alternatives: an automatic or Sturmian sequence has
  p(n) <= C n, so p(9) = 512 on 4096 bits already exceeds the complexity of any sequence with
  C < 57; it does not prove L1 (no finite prefix can), but it is the correct finite shadow.

  Surrogate for L3: block counts. On the first 2^20 bits, for k = 1..10 the counts of all 2^k
  blocks have expected value 2^{20-k} (1,048,576 / 2^k) and the observed extremes are
  k=1: 523600..524976; k=4: 65143..66032 (exp 65536); k=8: 3844..4278 (exp 4096);
  k=10: 917..1125 (exp 1024). Pearson chi-square over overlapping blocks is inflated by
  overlap; the correct statistic is Good's serial test psi^2_k - psi^2_{k-1} ~ chi^2(2^{k-1}):
  observed z = (stat - df)/sqrt(2 df) for k = 1..12: 0.57, 0.52, 1.75, 1.03, 0.89, 0.79, 1.98,
  1.11, 0.63, 1.81, 1.80, 1.03. Mildly high but within what a random sequence produces; no
  block is over- or under-represented beyond ~3 sigma. Frequency of ones 0.50066 (excess
  1376 = 1.34 sigma). A kernel-checkable form: "for all k <= 8, every block count on the first
  D bits lies in [2^{-k} D (1 - eps), 2^{-k} D (1 + eps)]" with eps = 0.1 at D = 2^16 (true).
  It is a deterministic statement about the prefix and nothing more; normality is Pi_2 over
  D and no prefix certifies it.

  Surrogate for L0 directly: the shift-agreement scan (Section 5), which at depth 2^21
  excludes every p <= 2^16 and every N <= 2,031,598; and Jen's theorem, which is a genuine
  unconditional theorem about periodicity of columns and the one structural result worth
  putting in the kernel.

  Surrogate for L4: none that is honest. Any finite statement about running time is either
  an upper bound (which exists: O(n^2)) or a claim about all algorithms, which no computation
  on a prefix touches. The only kernel-checkable relatives are negative results about
  specific shortcuts: no linear recurrence over GF(2) of order <= r (a rank computation on a
  Hankel matrix of the prefix; a Berlekamp-Massey linear complexity profile), and no
  k-automaton with <= s states for k = 2, 3 (finite k-kernel check on the prefix). Both are
  cheap and informative: the linear complexity profile of a random sequence hugs n/2, and
  the column's does (this is the classical Meier-Staffelbach observation that the column
  passes linear-complexity tests), whereas Thue-Morse's 2-kernel has 2 elements.

---

## Summary

The Rule 30 centre column (1101110011000101100100111010111 0..., verified here to depth
2^21) is conjectured to be non-periodic (Wolfram Prize 1), to have ones of frequency 1/2
(Prize 2) and to be computationally irreducible (Prize 3); all three are open, and everything
known toward Prize 1 is finite search, of which the strongest form I can vouch for is the
computer-checked statement that no period p <= 65,536 with preperiod <= 2,031,598 exists
(and that p(16) = 65,536 on the first 2^20 bits, which by Morse-Hedlund refutes all N + p < 65,536).
"Eventually periodic iff 0.c rational" is unconditionally true in both directions with no
dyadic caveat, because both expansions of a dyadic rational are eventually periodic; your
remainder recursion produces the greedy expansion and never a 1^infty tail, so the
statement to certify is the direct (N, p) shift-agreement one, from which the rational
corollary follows (not conversely). Your finite theorem is sound at any depth (refutation
needs one mismatch), is complete as a test of the finite hypothesis at depth >= N + 2p, and
your choices D = 64 (P = 16, needs 35) and D = 128 (P = 32, needs 66) are correct; but no
depth bounds where a refutation appears a priori, and no finite check can ever establish
non-periodicity, which is a Pi_1 statement with no known invariant. The genuine structural
theorems, all provable by structural induction and worth putting in the kernel, are: Rule 30
is left-permutive, hence surjective and, for a fixed right half, in bijection between left
halves and column sequences (so every finite word is some column prefix); Jen's theorem
that no two adjacent columns of a finite-support evolution are both eventually periodic
(so if the centre column repeats, columns +-1 do not, and infinitely many columns encode
irrationals); and the closed diagonal recurrences d_k = prefix-parity(d_{k-1} OR d_{k-2}),
e_k(t) = e_{k-2} XOR (e_{k-1} OR e_k), giving purely periodic right diagonals with periods
1, 2, 2, 4, 8, 8, 16, 32, 32, 64, ... (powers of two, at most 2^k) and left diagonals of
period <= 8 after a preperiod ~1.3k, with the column c_t = d_t(t) sampling each diagonal
before its period is reached, which is exactly why no shortcut and no closed recurrence for
the column exists unless the column is periodic. In the corpus's landscape the column is
the conjectural opposite of the rotations and Sturmians: never-returning with maximal
rather than minimal complexity (p(n) = 2^n for n <= 16 observed; conjecturally normal,
non-automatic, irreducible), and with no conserved quantity witnessing the non-return. The
right next formal claim is the finite shadow of that: every word of length n_0 occurs in
the first D bits (n_0 = 9 at D = 4096, n_0 = 12 at D = 2^16), which simultaneously certifies
the exclusion of all periods and preperiods with N + p < 2^{n_0} and separates the column,
at finite resolution, from every linear-complexity object in the corpus.
