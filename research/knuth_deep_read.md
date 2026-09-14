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
