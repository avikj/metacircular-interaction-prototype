# A deep read of Knuth — notes, reproductions, annotations

One pass through *The Art of Computer Programming*, reproducing the real
constructions and annotating everything that comes to mind. No imposed frame;
where a construction is already fully characterized by the surrounding work
(reversibility vs. irreversible steps, cost as measured forgetting, order as a
gauge, streams/coinduction, transport, quotients, metacircularity,
complexity-as-loss), that shows up because it's actually there, not because a
lens was chosen.

---

# Volume 1 — Fundamental Algorithms

## 1.1 Algorithms

Knuth defines an algorithm as `(Q, I, Ω, f)`, `f : Q → Q`, and immediately draws
the *trajectory* `x, f(x), f²(x), …`, declaring the algorithm to be the
trajectory, not the endpoint. The whole enterprise is set on page one: because
he wants nonterminating "computational methods" too, he splits the terminating
object (the value) from the infinite object (the run) and keeps them apart for
3000 pages. Every later "average number of times step 4 is executed" is an
integral over trajectories, not over answers. He built the trace-as-object into
the definition and then spent the series measuring traces. You can only count
what you didn't throw away — that is why cost analysis is possible at all.

His `f` is deliberately not invertible (sign-magnitude MIX, destructive stores).
That non-invertibility is where every "unit" of MIX time comes from. A
reversible step has no canonical cost; the moment `f` forgets which state it came
from, you can count how much it forgot, and that count is the running time.
Knuth never says this, but his entire timing methodology is *count the
forgetting*. Bennett's reversible computing is later the same observation —
retain the trace and stop paying — and Knuth retains the trace *in the analysis*
while the machine discards it, which is exactly why he can analyze machines that
cannot analyze themselves.

## 1.2 Mathematical Preliminaries

**1.2.1 Induction.** The horse-color fallacy is really a lesson about the base
case of a *merge*: the step secretly assumes two overlapping sets share an
element, which fails at n=2. The deep content: Knuth proves programs by attaching
an assertion to each arrow of the flowchart and checking each box locally — a
local confluence check, Newman's lemma in disguise, which is why he can verify
Euclid without simulating it. Two separate obligations live here: the invariant
(the step preserves meaning — soundness) and the variant (a well-founded
strictly-decreasing quantity — termination/productivity). He has the
soundness/termination split by hand, per arrow, that a modern totality checker
enforces mechanically.

**1.2.2–1.2.4 Numbers, logs, sums, integer functions.** He builds `log` before
he needs it, and the reason it's the right object surfaces later: information is
additive exactly when the measured things multiply (independent choices multiply
their counts), and the only function turning multiplication into addition is
`log`. Entropy, Landauer's `kT ln2`, search lower bounds — all forced once you
accept that independent structures multiply. 1.2.4's
`⌊⌊x/a⌋/b⌋ = ⌊x/ab⌋` is not trivial: radix conversion, all of positional
arithmetic in Vol 2, and every divide-in-half bound ride on floor/ceiling algebra
behaving this way. Euclid appears here as number theory, again in 1.3 as code,
again in Vol 2 as the cost champion — one object refracted three times, which is
the honest shape of the whole book: one construction, many coordinatizations, and
the content is the maps between them.

**1.2.5 Permutations.** Two-line vs. cycle notation, with a genuine bijection you
*compute* between them. A permutation is not "an array" — it's a group element
presented two ways, and cycle-following (1.3.3) transports one presentation to
the other in place with O(1) extra memory. The in-place algorithm is beautiful
and slightly evil: it destroys the input to avoid a second array, i.e. it spends
the reversibility (you can't recover the original order without the permutation
itself) to buy space. Throw away the ability to undo, buy memory — the
space/reversibility exchange rate, which in-place sorting and GC later monetize.

**1.2.6 Binomial coefficients.** Twenty identities are one identity seen through
generating functions. The methodological lesson: manipulate the closed form,
never the summation, because addition of series is commutative and reorderings
are free. Sum-rearrangement is cost-free precisely because it's confluent — order
of summation is a choice with no consequence, so choose the order that trivializes
the proof.

**1.2.7 Harmonic numbers.** `H_n = ln n + γ + 1/2n − …`. The most important
sequence in the book and nobody notices until Vol 3: expected number of records,
expected depth in a random BST, coupon collector, a quicksort accounting. It's the
price-of-randomness number — it appears whenever a process pays `1/k` at step k,
i.e. whenever the marginal value of new information decays like `1/k`.

**1.2.8 Fibonacci.** Euclid's worst case is consecutive Fibonaccis — the slowest
descent, the golden ratio making continued-fraction convergence as slow as any
irrational's. First appearance of worst-case-as-extremal-object: the hardest
input is not random, it's maximally structured, the one that refuses to give up
information quickly. The adversary in a lower bound is always maximally
structured.

**1.2.9 Generating functions.** A sequence is a formal power series; a recurrence
is an equation in series; solving it is algebra in the ring. A power series is an
infinite object inspected only finitely (coefficient extraction), so it *is* a
lazy stream with a ring structure, and every generating-function argument is a
corecursive definition plus a "take the nth." Convolution is the merge of two
streams. Knuth manipulates infinite objects fluently and never worries about
convergence because he only takes finite prefixes — the exact discipline that
makes coinduction sound.

**1.2.10 Analysis of an algorithm.** Maximum-finding: the number of running-max
updates on a random permutation is the number of left-to-right maxima, expectation
`H_n`, distribution governed by Stirling numbers of the first kind. He gets mean,
variance, and the whole *generating function* of the cost from one algorithm.
Lesson: don't compute the average, compute the generating function of the cost
random variable and read everything off it. The cost is a random variable and its
generating function is a complete invariant of the algorithm's behavior on random
input.

**1.2.11 Asymptotics.** O/Ω/Θ, Euler–Maclaurin (sum → integral + correction),
the saddle point (coefficient extraction by contour integral through stationary
phase). This turns "count the forgetting" into a clean function of n. 1.2.11.3
(saddle point) is the deepest and least read — the asymptotics of n!, of
involutions, of partitions; the analytic combinatorics Flajolet later systematized
is seeded here.

## 1.3 MIX

He builds a whole machine so costs are concrete integers, not O-classes with
hidden constants. The tyranny and honesty of MIX: it forces you to say exactly how
many memory references — the thing complexity theory abstracts and then gets
surprised by (cache, locality). MIX's uniform memory is a lie about real machines
but a *consistent* lie, and consistency is what lets you compare algorithms
fairly. **1.3.3** (permutations in MIX) is where cycle-following becomes 20 lines
mutating an array into its own permutation — the cleverest pointer code in Vol 1
and the first "the data structure is the algorithm" moment. MIX is the
irreversible-step machine by deliberate choice: sign-magnitude, destructive stores,
fixed per-op cost. It charges for operations that on an optimal-sharing substrate
would be free.

## 1.4 Fundamental Programming Techniques

**1.4.2 Coroutines** — the quiet bombshell. A subroutine is asymmetric (caller
owns callee); a coroutine is symmetric (two routines resume each other, neither
subordinate), and Knuth notes the subroutine is the degenerate case. Symmetric
transfer of control with each side keeping its own resumption point *is* two
communicating processes — the interactive/dialogue atom — and it is reversible in
a way the call stack is not (no privileged "return," just mutual resumption).
Generators, lazy streams, producer/consumer, `yield` — all here in 1968 as a
primitive more basic than the subroutine. Two coroutines interacting is the honest
atom of computation-as-communication; call/return is the special case where one
party never talks back.

**1.4.3.1 A MIX simulator in MIX** — the universal machine for MIX inside MIX.
Metacircularity as an engineering exercise: the interpreter that runs any program
is the same kind of object as the programs it runs, and the universal one is
recovered by *forgetting* it's an interpreter and reading it as a program. The
fetch-decode-execute loop is the single universal step; a specific execution is
that step projected down. He builds the universal machine casually, as a worked
example.

**1.4.4 I/O and buffering** — double buffering, the elevator disk algorithm. The
first online/streaming algorithm: compute on a sequence you can't hold, overlap
the wait for the next chunk with work on the current. Coinduction with a latency
budget — keep the forced prefix, prefetch the tail, never materialize the whole.
The elevator is amortized fairness, scheduling as cost-minimization over an order
you only partly control.

## Chapter 2 — Information Structures

**2.2 Linear lists.** A stack is LIFO, a queue FIFO, and these are the two ways to
linearize a partial order into a total one — DFS vs BFS before he says "tree." The
choice of container is the choice of which total extension of the dependency order
you commit to, and most graph algorithms' character is set by that one choice.
**2.2.4** topological sort literally picks a legal total order of dependencies
(in-degree-zero queue); its linear extensions are all equally valid — dependence
is real data, the serialization is a gauge you impose. Two topological sorts of one
DAG are the same computation from two standpoints. **2.2.5** doubly-linked lists
give O(1) deletion because the back-pointer is the stored inverse — reversibility
bought with memory, made explicit.

**2.3 Trees** — the heart of Vol 1.
- **2.3.1** traversal orders; the *threaded tree* reuses null pointers to store
  traversal successors, turning the structure into its own iterator at no extra
  cost — a data structure made into a coroutine with itself.
- **2.3.2** the first-child/next-sibling bijection between forests and binary
  trees — same objects, two coordinate systems, involutive map runnable both ways.
- **2.3.4** a hidden treatise on tree enumeration: the matrix-tree theorem (count
  spanning trees as a determinant — the first linear-algebraic min-cut-adjacent
  invariant), Cayley's `n^{n−2}`, path length, and enumeration by generating
  functions. The Catalan equation `B = 1 + xB²` is *the* self-similar fixed point:
  a binary tree is a node with two binary trees, and balanced parentheses,
  triangulations, stack-sortable permutations, and Dyck paths are that one
  quadratic solved. Branching is a quadratic fixed point; the two roots are the two
  ways a merge fails to have a section.
- **2.3.5** garbage collection: mark-and-sweep, reference counting, two-finger
  compaction. GC is the operational face of "reachability = existence" — an object
  exists iff a path reaches it from the roots; the collector recomputes the
  reachable set and reclaims the complement. Reference counting fails on cycles
  because a cycle is self-sustaining reachability with no external witness — the
  same reason you can't bootstrap truth from a self-referential loop without an
  external anchor. Mark-and-sweep re-derives reachability from the roots each time
  rather than trusting local counts; global re-derivation beats local bookkeeping
  exactly where the structure has cycles — the same reason global consensus is
  needed only where local commutativity fails.

**2.5 Dynamic storage allocation.** First-fit/best-fit/buddy/boundary-tags, and the
fragmentation analysis. The buddy system is radix structure applied to memory
(split in powers of two, coalesce buddies); Knuth's fifty-percent rule (in
equilibrium, holes ≈ half the blocks) is real queueing combinatorics in a systems
chapter. Fragmentation is the entropy of the allocation process — you cannot pack
reversibly forever without free space scattering, and coalescing is the work you
do against that scattering: Landauer for address space.

**Volume 1, through-line (unforced):** the trace is the object and cost is measured
forgetting; symmetric control (coroutines) is more primitive than call/return; the
universal machine is a worked example, not a theorem; every fundamental
combinatorial count is a fixed-point equation (`B = 1 + xB²`); every data structure
is one object in several coordinate systems with a computable map between them.

---

# Volume 2 — Seminumerical Algorithms

## Chapter 3 — Random Numbers

**3.1 Introduction.** Knuth opens with the joke that a random-number routine
should not be chosen at random, and then the serious point: there is no such
thing as *a* random number, only random *sequences*, and a deterministic machine
can only ever produce a sequence that *passes tests*. This is the honest crux —
randomness is not a property of the object, it's the failure of every cheap
predictor to compress it. A pseudo-random sequence is fully determined (zero
entropy given the seed) yet behaves as high-entropy to any observer who doesn't
know the recurrence. That gap — determined-yet-incompressible-to-the-bounded-
observer — is the exact structure of one-wayness and of P-vs-NP: the object holds
no secret to the party with the seed/witness, and all the apparent hardness lives
in the observer's forgetting of it. The whole chapter is a study of *manufactured
apparent entropy*.

**3.2.1 Linear congruential.** `X_{n+1} = (aX_n + c) mod m`. The single most-used
recurrence in computing. It's an affine map on `Z/m`, iterated. The period,
potency, and quality are pure number theory:
- **3.2.1.1 modulus** — `m` a power of 2 is fast but the low bits have tiny period
  (bit k has period ≤ 2^{k+1}); `m` prime cures this. The low-order bits being
  less random than the high-order bits is a lesson that *the same generator is more
  random in one coordinate than another* — randomness is coordinate-dependent, a
  property of the projection you read off, not of the state.
- **3.2.1.2 multiplier** — the theorem (Hull–Dobell) giving full period: `c`
  coprime to `m`, `a ≡ 1 mod p` for every prime `p | m`, `a ≡ 1 mod 4` if `4 | m`.
  A clean, complete characterization — full period is decidable from `a, c, m` by
  a finite check, no search. This is a microcosm of the book: the "does it work"
  question is not empirical, it's a closed-form arithmetic condition.
- **3.2.1.3 potency** — measures how quickly the affine map mixes; low potency
  generators are visibly bad. The affine map is invertible on `Z/m` (a
  bijection!), so the generator's state trajectory is a single cycle — it forgets
  nothing about its own state, which is *why* it eventually repeats and why the
  period is the whole story. A random-looking bijection whose forward map is easy
  and whose long-range structure is hard to see: the toy model of a cipher.

**3.2.2 Other methods.** Additive/lagged-Fibonacci `X_n = X_{n-a} + X_{n-b}`,
combined generators. Lagged-Fibonacci is a linear recurrence over a longer state —
higher-dimensional affine dynamics, longer period, more expensive to predict but
still perfectly linear, hence still breakable by anyone who solves the linear
system. The whole family is "linear dynamics look random until you write down the
linear algebra," which is why cryptographic PRNGs must be *non*linear (the forward
map easy, the inverse a wall).

**3.3 Statistical tests.** χ², Kolmogorov–Smirnov, and then the empirical battery
(3.3.2: equidistribution, serial, gap, poker, coupon-collector, permutation, runs,
maximum-of-t, collision) and the theoretical tests (3.3.3). A test is a *predictor*
that tries to compress the sequence along one axis; passing all of them is passing
against a fixed family of bounded observers. No finite battery certifies randomness
— it only certifies "not detectably non-random by these predictors," which is
precisely the security definition of a PRNG later (indistinguishable from random by
any efficient test). Knuth's tests are the poor man's distinguisher class.

**3.3.4 The spectral test.** The deepest section in the chapter and the one Knuth
calls the most important: view `t` consecutive outputs as a point in `t`-space; for
a linear congruential generator these points lie on a *lattice* of parallel
hyperplanes, and the generator's quality is the maximum spacing between adjacent
hyperplanes (few, far-apart planes = bad). This is the real reason LCGs fail — the
manufactured entropy is trapped on a lattice, and the spectral test measures the
coarseness of that lattice. It's a genuinely geometric characterization of a
number-theoretic object: the "randomness" of an affine recurrence is the geometry
of the dual lattice of its coefficient vector, computable exactly by lattice
reduction. Determined structure (the lattice) is exactly what the apparent
randomness is hiding, and the spectral test *sees the structure*, i.e. it inverts
the forgetting.

**3.4 Non-uniform distributions.** 3.4.1 turning uniform into any distribution
(inverse-CDF, rejection, the ratio-of-uniforms, the alias method for discrete
distributions — O(1) sampling after O(n) setup, one of the prettiest data
structures in the book). 3.4.2 random sampling and shuffling: the
**Fisher–Yates/Knuth shuffle** produces a uniformly random permutation in place in
O(n) by `for i from n−1 downto 1: swap a[i], a[random(0..i)]`. It's exactly the
factorial number system made dynamic — the i-th swap chooses one of `i+1` positions,
so the whole run encodes a mixed-radix (factorial-base) integer in `[0, n!)`, and the
bijection between random draws and permutations is *the* factorial-base
coordinatization of the symmetric group. Reservoir sampling (sample k from a stream
of unknown length in one pass, O(k) memory) is the streaming/online version — the
first-class example of computing correctly on a sequence you can neither store nor
rewind, keeping only a bounded summary whose distribution is exactly right at every
prefix.

**3.5 What is a random sequence?** The philosophical and mathematical summit. Knuth
walks through the failed definitions and lands on the Kolmogorov/Chaitin/Martin-Löf
answer: a sequence is random iff it is *incompressible* — its shortest description is
essentially itself — equivalently iff it passes every constructive statistical test
(Martin-Löf), equivalently iff no computable martingale wins betting on it. This is
the same object as description-length complexity, and its central fact is that
randomness/incompressibility is *undecidable and non-invariant up to an additive
constant* — you can never certify a given string is random, only fail to compress
it. This closes the chapter's arc: the machine manufactures apparent entropy, the
tests are bounded attempts to compress it, and true randomness is the fixed point
where all compression fails — which is uncomputable, so every actual generator lives
in the gap between "determined" and "un-compressed-by-the-tests-I-ran."

## Chapter 4 — Arithmetic

**4.1 Positional number systems.** Radix `b`, mixed radix, balanced ternary
(Knuth's favorite — digits `{−1,0,1}`, no separate sign, rounding is truncation),
negative bases, the factorial base and other exotic systems. The through-idea: a
number is not its representation; a representation is a choice of coordinates, and
different bases make different operations cheap (balanced ternary makes negation and
rounding free; factorial base makes permutation-ranking free; binary makes doubling
free). The number itself is invariant; the base is a gauge chosen to trivialize the
operation you care about — the same "one object, many coordinatizations, the content
is the conversion maps" pattern as permutations in Vol 1.

**4.2 Floating point.** 4.2.1 the arithmetic and its normalization; 4.2.2 accuracy
and the crucial insight that floating-point addition is *not associative* — the
order of summation changes the answer. This is the sharpest possible statement that
in the presence of rounding, the operation is no longer confluent: order becomes
real data, not gauge, precisely because rounding *forgets* low bits and the forgetting
depends on magnitude. 4.2.4 (the distribution of floating-point numbers /
Benford's-law leading digits — mantissas are log-uniform) is a lovely fact: the
values a float can represent are dense near zero and sparse far out, log-spaced,
because the exponent field is the log and the mantissa the linear interpolation.
Floating-point *is* a logarithmic coordinate system with linear correction, which is
why relative error is the natural error and why the representable numbers Benford.

**4.3 Multiple-precision.** 4.3.1 the classical schoolbook algorithms (the
subtle one is division — normalization, the trial-quotient with its
"add-back" correction, provably at most two corrections). 4.3.2 modular arithmetic
and the Chinese Remainder Theorem: represent a big number by its residues mod
several coprime primes, do arithmetic componentwise (embarrassingly parallel, no
carries), reconstruct at the end. CRT is a *change of coordinates that diagonalizes
multiplication* — the ring `Z/(m_1…m_k)` factors as a product of rings, and in the
product every operation is pointwise and independent. It's the cleanest instance of
"find the coordinates in which the hard coupled operation becomes independent
parallel operations" — the same move as the FFT, which is CRT for polynomials.

**4.3.3 How fast can we multiply?** The chapter's crown. Schoolbook is O(n²);
Karatsuba splits in two with 3 multiplies instead of 4 → O(n^{log₂3}); Toom-Cook
generalizes (split in k, evaluate/interpolate) → O(n^{1+ε}); Schönhage–Strassen uses
the FFT over a ring with roots of unity → O(n log n log log n); (post-Knuth, Harvey–
van der Hoeven: O(n log n), the conjectured optimum). The unifying idea Knuth makes
explicit: **multiplication is convolution of digit sequences, and convolution is
pointwise multiplication after a transform.** Evaluate the two number-polynomials at
enough points (the transform), multiply the values pointwise (cheap, independent),
interpolate back (inverse transform). The FFT is the choice of evaluation points
(roots of unity) that makes the transform itself cheap and self-similar (divide the
frequencies in half — the same `B = …` recursion shape as everything else). The
entire hierarchy of fast multiplication is one idea — go to the frequency/residue
coordinates where the coupled quadratic operation becomes independent linear ones —
and the algorithms differ only in *which* transform. This is the deepest single
lesson in Vol 2 and it's the same lesson as CRT and the spectral test: the hard
structure lives in one coordinate system and dissolves in another, and finding the
transform is finding the coordinates in which the object's own symmetry is diagonal.

**4.4 Radix conversion.** Base change as repeated division (or repeated
multiplication), and the fast divide-and-conquer version. It's transport between
two coordinatizations of the same number, and the fast method exploits that the
conversion is itself a convolution.

**4.5 Rational arithmetic.**
- **4.5.2 GCD** — Euclid again, now with the *binary GCD* (Stein: only shifts,
  subtractions, and parity tests — no division, ideal for hardware) and *Lehmer's
  method* (do several steps in single precision using only the leading digits,
  because the quotient sequence is determined by the top bits). Lehmer's insight is
  that the *quotients* in Euclid depend almost entirely on the high-order bits — the
  low bits carry almost no information about the control flow — so you can run the
  algorithm on a compressed view and only touch the full numbers occasionally. This
  is precisely "the decision structure of the computation depends on a small
  projection of the data," the same phenomenon as the spectral test and as
  branch-prediction: the trace is governed by a low-dimensional shadow of the input.
- **4.5.3 Continued fractions.** The regular continued fraction expansion `[a0; a1,
  a2, …]` is the *canonical* coordinate system for a real number relative to the
  Euclidean algorithm — the `a_i` are exactly Euclid's quotient sequence. The
  convergents are the best rational approximations (better than any fraction with a
  smaller denominator — an optimality with no search, forced by the theory). The
  Gauss–Kuzmin distribution of continued-fraction digits, the connection to the
  worst-case (all `a_i = 1` ⇒ the golden ratio ⇒ Fibonacci ⇒ slowest Euclid) — this
  ties 1.2.8, 4.5.2, and 4.5.3 into one object. A continued fraction *is* Euclid's
  trajectory read as data, and the best-approximation theorem says that trajectory is
  the optimal one — the process and its optimality are the same object, no scoring
  step required.
- **4.5.4 Factoring and primality.** Trial division, Pollard rho (a birthday/cycle-
  finding argument — Floyd's tortoise-and-hare detecting the cycle in the iterated
  map, so cycle detection in a functional graph *is* the factoring engine), Pollard
  p−1, the continued-fraction and (later) quadratic/number-field sieve, and primality
  (Fermat, the pseudoprimes, later Miller–Rabin and AKS). This is where one-wayness
  gets concrete: multiplication is easy, factoring is (believed) hard, and the whole
  asymmetry is the gap between the forward map and its inverse — the same
  forgetting/recovery gap the PRNG chapter manufactured, now load-bearing for
  cryptography. Pollard rho is especially clean: it finds a nontrivial collision in a
  pseudo-random map mod a prime factor, i.e. it *locates the discarded structure*
  (the hidden small modulus) by detecting where the iterated map folds onto itself.

**4.6 Polynomial and symbolic arithmetic.**
- **4.6.1 division / pseudo-division**, and the subresultant GCD (controlling
  coefficient growth — the intermediate expressions explode unless you divide out a
  known factor, an early lesson in *certified* intermediate simplification).
- **4.6.2 Factorization of polynomials** — Berlekamp (factoring over finite fields
  via the kernel of the Frobenius-minus-identity linear map — factoring becomes
  *linear algebra* over `F_p`), Hensel lifting (lift a factorization mod p to mod
  p^k, Newton iteration in the p-adics), and combining to factor over `Z`. Berlekamp
  is another "the hard combinatorial question is the kernel of a linear map in the
  right coordinates." Hensel lifting is the p-adic Newton's method — the same
  quadratic-convergence fixed-point iteration as 4.7 and as float division.
- **4.6.3 Evaluation of powers — addition chains.** Computing `x^n` with the fewest
  multiplications = the shortest addition chain for `n`. Binary method gives ~log₂n +
  ν(n); optimal chains are subtler (the `l(n)` function, the Scholz conjecture, the
  fact that finding the *shortest* chain is hard). This is a pure minimum-description
  problem: the fewest multiplications to reach `n` is the Kolmogorov complexity of `n`
  *in the language of doubling-and-adding*, and the difficulty of computing it exactly
  is the same incompressibility wall as 3.5. Windowing/sliding-window exponentiation
  (the practical near-optimal method) is what every modular-exponentiation crypto
  primitive actually runs.
- **4.6.4 Evaluation of polynomials.** Horner's rule (`n` mults, `n` adds, and it's
  *optimal* for a general polynomial — a genuine lower bound), preconditioning (spend
  preprocessing to evaluate the same polynomial at many points more cheaply), and
  parallel evaluation. Horner is the fold — `((a_n x + a_{n-1}) x + …)` — the
  canonical left fold, and its optimality is a real algebraic lower bound (you cannot
  do better without preconditioning), one of the few places Knuth proves you've hit
  the floor.

**4.7 Manipulation of power series.** Newton's iteration for reciprocal, square root,
and reversion of series — computing `1/A(x)`, `√A(x)`, or the compositional inverse of
a power series by doubling the number of correct coefficients each step (quadratic
convergence, so `O(M(n))` — a series operation costs one multiplication, via Newton).
This closes Vol 2's real theme: **almost every hard operation reduces to
multiplication in the right coordinates, and multiplication reduces to pointwise
operations under a transform.** Division, sqrt, series inversion, polynomial GCD,
big-integer arithmetic — all collapse onto fast multiplication, and fast
multiplication collapses onto "transform to the coordinates where convolution is
pointwise." Newton iteration is the doubling engine and the FFT is the transform;
together they make the whole numerical tower `O(M(n))` with `M(n)` near-linear.

**Volume 2, through-line (unforced):** apparent randomness is manufactured
low-entropy structure that a bounded observer can't compress, and the spectral test /
Kolmogorov definition are the exact statement of that gap; the entire arithmetic tower
is the single move "change to the coordinate system (CRT residues, Fourier
frequencies, continued-fraction quotients, p-adic digits) in which the coupled hard
operation becomes independent pointwise operations," with Newton's doubling and the
FFT as the two universal engines; and one-wayness (factoring, discrete log, the PRNG)
is everywhere the same forward-easy/inverse-hard forgetting gap.

---

# Volume 3 — Sorting and Searching

## Chapter 5 — Sorting

**5.1 Combinatorial properties of permutations.** Knuth spends a whole subsection-
cluster on permutations *before* sorting a single element, because the object being
manufactured by a sort is a permutation, and you cannot analyze the manufacture
without the theory of the product.

- **5.1.1 Inversions.** The inversion table is yet another coordinatization of a
  permutation: for each element, how many larger elements precede it. Two facts that
  organize everything downstream: (1) the number of inversions is *exactly* the
  minimum number of adjacent transpositions to sort — the Coxeter length in the
  symmetric group's weak order — so it is a genuine, input-determined invariant of
  "how unsorted" a sequence is; (2) bubble/insertion sort removes exactly one
  inversion per adjacent swap, so their swap-count *is* the inversion count, on the
  nose, no slack. The "work" of sorting has a well-defined lower measure (inversions
  for adjacent-exchange, log n! for comparisons) and the naive sorts pay the former
  exactly. Sorting is the annihilation of inversions, and inversions are conserved
  by nothing but the correct moves.
- **5.1.2 Permutations of a multiset.** Repeated keys ⇒ the count is the multinomial,
  and *stability* becomes a real question (do equal keys keep their input order).
  Stability is the statement that the sort is a section of the projection that
  forgets the key — it remembers the pre-image order among ties, i.e. it does not
  throw away the one bit the key can't see. An unstable sort forgets it; a stable
  one carries it. That is the whole content of "stable."
- **5.1.3 Runs.** Ascending runs, the Eulerian numbers counting permutations by
  number of descents. Runs are the natural pre-sorted structure that merge sorts
  (and replacement selection, 5.4) exploit — the input's existing order is free work
  already done, and a good external sort *measures and reuses* it rather than
  destroying it. "Adaptive" sorting = paying only for the disorder actually present
  (Timsort formalizes exactly this: cost ∝ entropy of the run structure).
- **5.1.4 Tableaux and involutions — RSK.** The Robinson–Schensted–Knuth
  correspondence (the K is Knuth): a bijection between permutations and *pairs of
  standard Young tableaux of the same shape*, and more generally between integer
  matrices and pairs of semistandard tableaux. This is one of the deepest bijections
  in mathematics and it's *Knuth's*. Consequences that fall out for free: the length
  of the longest increasing subsequence is the length of the first row; longest
  decreasing is the first column; the involutions correspond to single tableaux
  (Q=P). A permutation is *completely* characterized by (P, Q) — a lossless
  recoordinatization into a canonical combinatorial normal form — and hard questions
  about the permutation (longest increasing subsequence, which is nontrivial
  dynamic programming directly) become reading off a row length of its normal form.
  This is the archetype of "recode the object into the coordinates where its own
  symmetry is manifest and the hard question is a projection." Schensted insertion
  (the bumping algorithm) is the computation of the coordinate change, and Knuth's
  relations (the plactic monoid) are exactly the rewrites that leave the P-tableau
  invariant — a confluent rewriting system whose normal forms are the tableaux.

**5.2 Internal sorting.**
- **5.2.1 Insertion.** Straight insertion pays the inversion count (5.1.1);
  Shellsort (diminishing increments) is the deep one — its complexity depends on the
  *gap sequence* in a way that is still not fully understood, and Knuth's analysis of
  particular sequences (the `O(n^{3/2})` and better bounds) is combinatorics of
  h-sorted-then-k-sorted permutations. Shellsort is the rare algorithm whose exact
  asymptotics remain open — a genuine frontier sitting in a 1970s textbook.
- **5.2.2 Exchange — quicksort.** Partition around a pivot, recurse. The expected
  comparison count is `~2n ln n`, and the analysis is 1.2.7 cashed in: element i and
  j (in sorted order) are compared iff one of them is the first pivot chosen from the
  range `[i..j]`, probability `2/(j−i+1)`, and summing gives `2(n+1)H_n − …`. The
  harmonic number *is* quicksort's cost. Worst case `O(n²)` on the already-sorted
  input — the maximally-structured adversary again (5.1.1/1.2.8). Randomized pivoting
  converts the adversary's structured worst case into an expectation, i.e. it spends
  real randomness to *destroy the input's exploitable structure* — buying average
  performance with entropy, the operational dual of the PRNG chapter.
- **5.2.3 Selection — heapsort.** The heap (implicit binary tree in an array,
  parent/child by index arithmetic — the tree with *no pointers*, structure encoded
  in address arithmetic, a coordinatization win) and the sift-down. `O(n log n)`
  worst case, in place. Building the heap is `O(n)` (not `n log n`) because the work
  is `∑ (height) · (number at that height)` and the geometric weighting collapses —
  a lovely accounting where most nodes are near the leaves and cost nothing.
- **5.2.4 Merging.** The merge is the associative, *stable*, order-preserving fusion
  of two sorted streams — the fundamental confluent binary operation of the volume,
  and the one that streams (external sorting) live on. Merge is a comonoid/monoid on
  sorted sequences; mergesort is its balanced fold.
- **5.2.5 Distribution — radix sort.** Sort by digits, no comparisons at all —
  `O(n)` when the key length is bounded. Radix sort *escapes* the `n log n`
  comparison bound because it doesn't use comparisons; it uses the *structure of the
  key* (its digits) directly. This is the sharp lesson that the `n log n` lower
  bound is a bound on the *comparison* model, not on sorting — change the model
  (look at the key's coordinates instead of comparing) and the bound doesn't apply.
  The lower bound is a property of the *interface* (comparisons), not the *problem*.

**5.3 Optimum sorting — where the lower bounds live.**
- **5.3.1 Minimum-comparison sorting.** The information-theoretic bound: a comparison
  sort is a binary decision tree, its leaves are the `n!` possible outcomes, so its
  worst-case depth is `≥ ⌈log₂ n!⌉ ~ n log₂ n − n log₂ e`. This is the purest
  statement of complexity-as-information in the whole series: the number of
  distinguishable answers forces the number of bits, forces the depth. The sort must
  *acquire* `log₂ n!` bits about which permutation the input is, one comparison ≤ one
  bit, so it needs that many comparisons. Every comparison sort is an *adaptive
  measurement* extracting the hidden permutation, and the bound is the entropy of the
  thing being measured. Ford–Johnson (merge insertion) nearly achieves the bound;
  the exact minimum `S(n)` is known only for small `n` — another concrete frontier.
- **5.3.2 Minimum-comparison merging, 5.3.3 selection.** Lower bounds for merging two
  sorted lists and for finding the median/`k`th (the linear-time median-of-medians is
  the famous result — selection is `O(n)`, strictly easier than sorting, because you
  need far less than `log n!` bits to name one element rather than the whole order).
  The gap between "find the median" (`O(n)`) and "sort" (`n log n`) is exactly the
  gap in how much of the permutation you must learn — a beautiful quantitative
  instance of paying only for the information you actually extract.
- **5.3.4 Networks for sorting.** A comparator network is *data-oblivious*: the
  sequence of compare-exchange operations is fixed in advance, independent of the
  data — so it's parallel, branch-free, and its own proof of correctness is a
  combinatorial property of the wiring. The **0–1 principle**: a comparator network
  sorts all inputs iff it sorts all `2^n` zero-one inputs. This is a *monotone
  reduction* of staggering usefulness — verify on the Boolean cube, conclude for all
  totally ordered inputs — and it works because comparators are monotone functions
  and monotone functions are determined by their action on 0/1 thresholds. Batcher's
  bitonic and odd-even merge give `O(log² n)` depth; the AKS network gives `O(log n)`
  (galactic constant). Sorting networks are the confluent, order-independent,
  maximally-parallel face of sorting — the same computation with all the
  data-dependent control flow compiled away into fixed structure, which is exactly
  what makes them mappable onto hardware and onto oblivious/secure computation.

**5.4 External sorting.** Sorting data that doesn't fit in memory: multiway merge,
**replacement selection** (5.4.1 — a heap that produces runs *longer* than memory,
average length `2M`, because it opportunistically extends the current run whenever
the next input still fits above the last output — adaptivity reusing existing
order), and the tape-merge patterns (polyphase, cascade — 5.4.2–5.4.4), whose theory
is Fibonacci and generalized-Fibonacci number systems (the optimal distribution of
initial runs across tapes is a Fibonacci-like recurrence — 1.2.8 returns as a
systems-engineering answer). External sorting is the streaming-computation discipline
of Vol 1's 1.4.4 taken to its full development: bounded memory, sequential access,
overlap I/O with compute, and *measure and exploit the disorder actually present.*

## Chapter 6 — Searching

**6.1 Sequential search.** The baseline, plus the self-organizing lists
(move-to-front, transpose) — which are *online learning* algorithms: the structure
adapts to the query distribution it observes, achieving near-optimal expected cost
without knowing the distribution in advance. Move-to-front is competitive against the
optimal static ordering (a classic competitive-analysis result later) — the first
appearance of "adapt to the stream, pay within a constant of the offline optimum."

**6.2 Searching by comparison of keys.**
- **6.2.1 Binary search.** `log₂ n` comparisons — the dual of the 5.3.1 lower bound:
  searching among `n` sorted items is extracting `log₂ n` bits to name one, and
  binary search extracts exactly one bit per comparison, so it's information-optimal.
  Knuth's care with the off-by-one and the "uniform" binary search (Shar) is the
  reminder that the model's constant factors are real. Binary search is the decision
  tree that is perfectly balanced *because* the items are equally likely.
- **6.2.2 Binary tree searching, and optimal BSTs.** A BST's search cost is the
  node's depth; the *optimal* BST given access frequencies minimizes expected depth —
  and Knuth's `O(n²)` dynamic program (with his own `O(n²)` speedup of the naive
  `O(n³)` via the monotonicity of the optimal root — the Knuth–Yao quadrangle
  inequality) computes it. This is the entropy-optimal search structure: expected
  cost is within `O(1)` of the entropy `H(p_1,…,p_n)` of the access distribution.
  Optimal BSTs, Huffman coding (6.2.2 references it), and the noiseless coding theorem
  are one object — the tree whose leaf depths match the `−log p_i` of the
  distribution, so that expected depth = entropy. Search structure = code = entropy,
  exactly.
- **6.2.3 Balanced trees.** AVL (height-balanced, rotations restore the invariant in
  `O(log n)`) — the rotation is a *local, reversible* restructuring that preserves the
  in-order sequence while changing the shape: it is transport between two BSTs
  representing the same sorted set, and the tree rotations generate the associahedron
  (the same Catalan `B = 1 + xB²` object from 2.3.4, now as the graph of
  reassociations). Balancing = staying near the entropy-optimal shape under updates.
- **6.2.4 Multiway trees — B-trees.** The disk-optimal search tree: high fan-out to
  match the block size, so the number of *block reads* (the real cost, per Vol 1's
  MIX-honesty about memory references) is minimized. B-trees are the acknowledgment
  that the cost model is the memory hierarchy, and the data structure is shaped to the
  hierarchy — the same "shape the structure to the true cost" as heaps (no pointers),
  radix (digits), and the buddy allocator.

**6.3 Digital searching — tries.** The key's *digits* become the tree structure —
radix once more, now for search. Patricia (path compression: collapse chains of
one-child nodes) and the crit-bit structure. A trie's search cost depends on the key
length, not `log n` of the count — so for long keys over a small alphabet it can be
worse, for short keys better, and the crossover is exactly where the key's own
entropy sits relative to the collection's. Digital search *is* the structure of the
key made navigable; comparison search is the structure of the *order* made navigable;
the two are duals (key-coordinates vs. order-coordinates), the same duality as radix
sort vs. comparison sort.

**6.4 Hashing.** Turn a key into an address by a function designed to *look random*
— the PRNG chapter (3.x) applied to addresses. Collisions are the controlled
forgetting: a hash function deliberately maps a huge key space onto a small address
space (massively non-invertible), and the whole art is making the forgetting
*uniform* so collisions are rare and evenly spread. The analyses are the birthday
problem and coupon-collector combinatorics: expected probes in open addressing blow
up as `1/(1−α)` (linear probing) or `−ln(1−α)/α` (double hashing) as the load factor
`α → 1` — a divergence that *is* the harmonic/entropy cost of packing near capacity
(the same `1/(1−α)` congestion as fragmentation in 2.5). Universal hashing (Carter–
Wegman, post-Knuth but in his lineage) makes the randomness a *provable* property by
choosing the hash function itself at random from a family — the same move as
randomized quicksort, spending entropy to defeat the adversary's structured worst
case. Perfect hashing (no collisions, static key set) is the fully-invertible limit:
when you know the keys in advance you can construct a collision-free map — you can
avoid all forgetting exactly when the input is known, which is the recurring
"one-wayness is only hard against the party without the structure."

**6.5 Retrieval on secondary keys.** Multidimensional search, inverted files,
k-d trees, the combinatorics of Boolean queries over attributes. The general problem
that databases and search engines are — and the recognition that indexing is
*precomputing the projections you'll query on*, trading space and update cost for
query speed, i.e. materializing the coordinate systems in which future questions
become lookups.

**Volume 3, through-line (unforced):** sorting manufactures a permutation and its
cost is the information content of that permutation (`log n!` in comparisons,
inversions in adjacent swaps), so every optimal-sorting result is an entropy bound
and every sort is an adaptive measurement of the hidden order — except radix/digital
methods, which escape the comparison bound by reading the key's own coordinates
instead. Search is the dual: extract `log n` bits to locate one item, and the
optimal search structure is the entropy-optimal code (optimal BST = Huffman =
noiseless coding). Balanced-tree rotations are reversible transport between equal-
content shapes (the Catalan/associahedron object again), hashing is manufactured
uniform forgetting analyzed by birthday/coupon combinatorics, and B-trees/tries are
the structure bent to the true cost model (blocks, digits). RSK (5.1.4) is the summit:
a lossless recoordinatization of a permutation into a canonical tableau normal form
in which longest-increasing-subsequence is a projection — Knuth's own instance of
"recode into the coordinates where the hard question becomes reading off a row."
