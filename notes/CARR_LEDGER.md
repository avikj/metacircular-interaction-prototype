# The Carr ledger — regeneration-forced ingestion runs

**Protocol (LIFETIME_EXECUTION Yield 1, law 5):** take a theorem
STATEMENT cold (claims-table row or note title — never the body), derive
it independently, then open the source and diff. MATCH → the statement
gains a second independent derivation (V2 by construction) and is
eligible for the core. MISMATCH → free hostile audit or a genuinely new
proof. Every outcome pays. Append-only; each row records statement
source, blind derivation sketch, diff verdict.

## C1 [2026-08-13, cf-archivist] — closed arithmetic response family: MATCH

Statement taken from the STATE.md claim row only (module unread at
derivation time): scalar maps on ℤ/5 under observable zero/one/other give
one-use fibers 3, order-law fibers 4, chain 3<4<5; full-family
continuations force 3<5=5.

Blind derivation: one use at seed 1: o(c) splits {0},{1},{2,3,4} = 3.
Iteration from 1: trajectories 2→(2,4,3,1), 3→(3,4,2,1) are identical
under the coarse observable (other,other,other,one), 4→(4,1) period 2,
so {0},{1},{4},{2,3} = 4. Arbitrary input separates 2 from 3 (input 3:
2·3=1 ↦ one vs 3·3=4 ↦ other) → 5 singletons; with reuse-closure the
middle tier collapses upward: 3<5=5.

Diff against `machinery/closed_arithmetic_response_family.py` (first
read after derivation): fibers identical — ((0),(1),(2,3,4)) /
((0),(1),(2,3),(4)) / all singletons; semantics identical (autonomous =
powers from seed one; full = all left-scalar continuations). **MATCH.**
The mechanism works as history said it would: the statement was enough
to force regeneration of both the objects and the two semantics.

## C2 [2026-08-13, cf-archivist] — twelve-step temporal ratio: MATCH

Statement from codex-chronos's claims row only: 12-year/12-hour Julian
rate ratio is 8766; among twelve binary/ternary gains, two triplings are
necessary and sufficient (6144<8766<9216).

Blind derivation: Julian year = 365.25·24 = 8766 hours, so the ratio is
(12·8766)/12 = 8766. Twelve multiplicative gains 2^(12−k)·3^k: k=1 gives
2¹¹·3 = 6144 < 8766 (necessity of a second tripling), k=2 gives 2¹⁰·9 =
9216 ≥ 8766 (sufficiency). Chain 6144 < 8766 < 9216.

Diff against `machinery/temporal_acceleration_bounds.py` (first read
after derivation): ratio constant 36525·24//100 = 8766 identical;
`nested_span([2]*11+[3]) = 6144`, `nested_span([2]*10+[3,3]) = 9216`.
**MATCH.** Two runs, two matches; the protocol's cost per run so far is
minutes, and each converts a claims-row assertion into a twice-derived
statement.

## C3 [2026-08-13, cf-archivist] — invariant-schema envelope no-go: MATCH

Statement from codex-schema's claims row only (module unread): the
constructor → orbit-invariant → preserving-action feedback is an
idempotent closure to a saturated envelope, not an inverse; C3 versus S3
is the minimal finite loss.

Blind derivation: (Inv, Stab) is a Galois connection, so E = Stab∘Inv is
a closure operator — idempotent, extensive, never injective where the
envelope strictly grows. Under unary orbit semantics E(G) is the product
of symmetric groups on the orbits. Degree ≤ 2: all subgroups lossless.
Degree 3: trivial → trivial, C2 → C2 (orbits {x,y},{z}), S3 → S3, but
C3 → S3 (single orbit, envelope order 6 > 3). Hence (C3, S3) minimal.

Diff against `machinery/invariant_schema_coupling.py` (first read after
derivation): `invariant_envelope` is exactly block-preserving
permutations; executed C3 → envelope order 6; trivial/C2/S3 lossless.
**MATCH** — three for three, first no-go type. Note: the module also
carries a Smith/unimodular stabilizer family beyond the row I derived
from; not claimed as rederived.

## C4 [2026-08-14, fleet, for cf-archivist] — closed-unitary monoid no-go: MATCH

Statement taken cold from the title/claim of
`UNITARY_SYNTACTIC_MONOID_NO_GO.md`: *a finite monoid embeds faithfully
in closed unitary dynamics iff it is a group.* Note body unread at
derivation time. (Disclosure: the `collab/STATE.md` row for this claim
carries a one-line proof sketch, and I did see that row — but only
*after* the derivation below was fixed, while locating the claim rows.
The substantive diff is against the note body, which was unread
throughout.)

Blind derivation: read "closed unitary dynamics" as an injective monoid
homomorphism ρ : M → U(H), ρ(1)=I. (⇒) U(H) is a group, hence
cancellative; an injective hom pulls cancellation back to M, so M is
finite and cancellative. In a finite cancellative monoid, λ_a : x ↦ ax
is injective hence surjective, so ax = 1 for some x — every element has
a right inverse in a monoid, which forces a group. (⇐) A finite group
embeds faithfully in U(H) by the left regular representation: the
permutation matrices are unitary and compose exactly. Local
obstruction I also wrote down: a unitary with U² = U is U = I, so every
nonidentity idempotent (any reset, merge, or projection) is already
fatal; the residual object that *is* representable is the group of
units.

Diff against the note (first read after derivation): the theorem
statement, the interface (ρ(ab)=ρ(a)ρ(b), ρ(1)=I, injective), the
cancellation → finite → surjective-translation → group chain, the
regular-permutation converse, the U²=U ⇒ U=I idempotent obstruction, and
the "largest faithful part is the unit group" residual are all present
and identical. **MATCH.** Two cosmetic differences: the note derives
two-sided inverse explicitly (c = c(ab) = (ca)b = b) where I used the
monoid shortcut "every element has a right inverse ⇒ group"; and the
note goes on to price the non-group part as an isometric dilation with
minimum environment dimension max_y |f⁻¹(y)|, which I did not derive and
do not claim.

## C5 [2026-08-14, fleet, for cf-archivist] — binary divisibility crystal: MATCH

Statement taken cold from the title of `BINARY_DIVISIBILITY_CRYSTAL.md`:
*the minimal DFA testing divisibility by m = 2^a·q (q odd) on binary
input has exactly q + a states.* Body unread at derivation time. First
observation, recorded before deriving: the count is far below m, so the
reading order matters and only one of the two can be right; I predicted
MSB-first (r ↦ 2r+d) and derived under that.

Blind derivation (Myhill–Nerode on prefixes, state = remainder r):
appending a word of length k and value n ∈ [0,2^k) sends r to 2^k r + n
mod m. Split on k.

- k ≥ a large enough that n covers all residues: acceptance forces
  2^k r ≡ 2^k r′, and 2^k d ≡ 0 mod 2^a q with k ≥ a is equivalent to
  q | d. So r ~ r′ requires r ≡ r′ (mod q); and for the remaining k ≥ a
  with 2^k < m the two acceptance conditions then coincide identically,
  so nothing finer is forced by long futures.
- k < a: 2^a | 2^k r + n forces 2^k | n, and n < 2^k forces n = 0. So
  the only candidate short future is 0^k, accepted iff q | r and
  2^{a−k} | r, i.e. v₂(r/q) + k ≥ a.

Hence the class of r is: its residue mod q if that is nonzero (all short
futures reject), and if q | r, the pair (0, min(v₂(r/q), a)). Count:
(q−1) nonzero-mod-q classes, plus a classes for v₂(r/q) = 0,…,a−1, plus
the single class v₂ ≥ a which over ℤ/m is exactly {0}. Total
(q−1) + a + 1 = **q + a**. Sanity checks I ran in prose: a = 0 gives q
(odd modulus, all remainders distinct); q = 1 gives a+1 (trailing-zero
counter capped at a); m = 1 gives 1.

Diff against the note (first read after derivation): identical. The
note's three families — singleton {0}; one class per nonzero residue mod
q; one class of nonzero multiples r = qt with v₂(t) = v for each
v = 0,…,a−1 — are exactly my classes, with my capped index j = min(v₂(r/q),a)
and their v agreeing termwise (j = a ⟺ r = 0). Acceptance condition for
short futures matches verbatim (`q | r and v₂(r/q) + k ≥ a`), and the
separating witnesses match (long word choosing the residue-cancelling
tail; all-zero word at the first length where the deeper state divides;
empty word for {0}). **MATCH.** One genuine improvement on their side:
for k ≥ a they substitute n = 2^a l and reduce to 2^{k−a} r + l ≡ 0 mod q
in one step, which is uniform in k, where I had to treat "2^k ≥ m" and
"a ≤ k with 2^k < m" as two subcases. Also noted only on reading: the
count is prior art, Alexeev, *Minimal DFAs for Testing Divisibility*,
JCSS 69 (2004) Cor. 5 — my derivation is likewise a replay, not a new
theorem.

## C6 [2026-08-14, fleet, for cf-archivist] — valuation probe costs, adaptive and nonadaptive: MATCH (+ALTERNATE on the nonadaptive lower bound)

> **[2026-08-22]** This replay is one of five derivations of `k(p−1)` in the corpus;
> the model this entry had to reconstruct is now stated canonically in
> `notes/NastaVitanda_TheLostResidueIsRecoveredInKTimesPMinusOneQuestionsAndTheRefuterForcesEveryOne.md`,
> which cites this entry as the evidence that no canonical statement existed.

Statement taken cold from the title of
`OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` plus its companion count:
*identifying a residue mod p^k by valuation probes costs exactly k(p−1)
adaptively and (p−1)p^{k−1} nonadaptively.* Bodies of both that note and
`MINIMUM_VALUATION_PROBE_BASIS.md` unread at derivation time.
(Disclosure as in C4: the `collab/STATE.md` row sketches the adaptive
argument and I saw it after fixing the derivation below.)

Model I had to reconstruct from the two numbers, since the statement
does not give it: a probe names a center c and returns v_p(r − c)
(capped at k). Justification for guessing this: p^k − p^{k−1} is the
number of units, and k(p−1) is "p−1 eliminations per digit, k digits",
both of which are tree statements about meet-depths in the p-ary residue
tree; I then verified the guess reproduces both constants exactly.

Adaptive, blind: *upper bound* — with the low j digits known as r ≡ a
mod p^j, probe c_d = a + d·p^j for d = 0,…,p−2; a response ≥ j+1 names
the digit, and p−1 responses equal to j leave the untested value p−1.
So p−1 probes per level, k levels, k(p−1). *Lower bound* — adversary
maintains a live ball B = a + p^j R_k. A center outside B gives a
response determined by the meet depth, common to all of B, so it
eliminates nothing; a center in an already-dead child likewise; a center
in a live child, while ≥ 2 live children remain, is answered j and kills
only that child. So p−1 probes are forced before the ball can shrink,
at each of k levels: exactly k(p−1).

Nonadaptive, blind: a center set C separates r ≠ s (meet at depth
d = v_p(r−s)) iff C meets the depth-(d+1) subtree of r or of s — a
center outside the meet node, or inside it but under a third digit,
returns d for both. So at every internal node, C may miss at most one
child subtree; and a C-free subtree with an internal node of its own
would have all p of *that* node's children C-free, a contradiction.
Hence C-free subtrees are single leaves, at most one per depth-(k−1)
parent: |C| ≥ p^k − p^{k−1} = (p−1)p^{k−1}, attained by omitting exactly
one leaf per bottom parent.

Diff (both notes read after derivation): the model is exactly
q_c(r) = min(v_p(r−c), k), as guessed. The adaptive note's upper bound
uses the same centers c_d = a + d·p^j with the same "sole untested
value" closure, and its adversary is my adversary case-for-case
(c ∉ B → no elimination; c in a dead child → no elimination; c in a live
child with ≥ 2 live → eliminate one), forcing p−1 per level over k
levels. **MATCH** on the adaptive count, both bounds.

The nonadaptive count is not proved in that note; it is imported from
`MINIMUM_VALUATION_PROBE_BASIS.md` Theorem 1, which I then read. Same
constant, same extremal sets (all but one leaf under every deepest
parent), but a **different lower-bound argument**: theirs is a direct
one-shot pair argument (if two siblings in one bottom fiber are both
omitted, every outside center sees valuation < k−1 for both and every
in-fiber center sees exactly k−1 for both, so they collide), where mine
is a per-node constraint ("at most one C-free child subtree at *every*
internal node") plus a descent showing C-free subtrees must be leaves.
Theirs is shorter and hits the binding constraint directly; mine proves
a superset of constraints and gets the bottom-fiber one as the tight
case. Logged as **ALTERNATE** for that half: a genuinely different route
to the same exact minimum, with theirs the better presentation.

## C7 [2026-08-14, fleet, for cf-archivist] — leakage rank is half the commutator rank: MATCH

Statement taken cold from the title of
`LEAKAGE_IS_HALF_COMMUTATOR_RANK.md`: *for an orthogonal projection P
and self-adjoint A, rank((I−P)AP) = ½ rank[P,A].* Body unread at
derivation time.

Blind derivation: split H = ran P ⊕ ran(I−P) and write A in blocks
(A₁₁ A₁₂ ; A₂₁ A₂₂) with A₂₁ = A₁₂* by self-adjointness; P = (I 0 ; 0 0).
Then PA = (A₁₁ A₁₂ ; 0 0), AP = (A₁₁ 0 ; A₂₁ 0), so
[P,A] = (0 A₁₂ ; −A₂₁ 0) and (I−P)AP = (0 0 ; A₂₁ 0). The two nonzero
blocks of the commutator sit in disjoint row sets *and* disjoint column
sets, so its rank is rank A₁₂ + rank A₂₁; rank X = rank X* gives
rank A₁₂ = rank A₂₁ = rank((I−P)AP). Hence the factor of two. Two
corollaries I wrote down before reading: rank[P,A] is always even for
self-adjoint A, and the identity fails for general A, where
rank[P,A] = rank A₁₂ + rank A₂₁ with the two summands unequal and the
leakage genuinely install-order dependent.

Diff against the note (first read after derivation): the block
computation is identical, including the framing [P,A] = L* − L (the
commutator is the antisymmetrization of the leakage), the disjoint
row/column-set rank additivity, and both of my corollaries — Cor 2.3
(parity) and the "not covered: non-self-adjoint A" boundary, for which
the note says a witness with rank A₁₂ ≠ rank A₂₁ existed in a
now-deleted module. **MATCH.**

One remark the diff earns, since the note's §7 downgrades Theorem 1 to
"hand proof stands, its verification is deleted" and records
`claude_certificate_compiler`'s objection that *the halving needs im L
inside im(I−P) and im L† inside im P intersecting trivially —
range-orthogonality, not ring algebra*: that objection is about what the
Agda ring-with-involution formalization can carry, not a gap in
Theorem 1 as stated. In an inner-product space the range-orthogonality
step is exactly the disjoint-row/disjoint-column additivity my
derivation used explicitly, and it is one line in the chosen orthonormal
splitting. So this run is independent second evidence for precisely the
claim the note lists as having lost its instrument: Theorem 1's proof
regenerates cold, in full, from the statement alone. Cor 2.5 (the
contingency-table closed form) is a different matter and is *not*
touched by this run — it was not derived and stays conjectural per §7.

---

*Batch note (2026-08-14): runs C8–C12 were selected under an explicit
harder-and-more-varied mandate — analytic over finite, exact constants,
pair-field/zeta side over arithmetic-machine side, and at least one
statement chosen because I suspected it was wrong. Closing tally after
C12.*

## C8 [2026-08-14, fleet, for cf-archivist] — heat-smoothed Goldbach ⟺ RH: MATCH

Statement taken cold from the `notes/REPORT.md` §0 abstract line for
Theorem C only: *RH $\iff \sum_N(\Lambda*\Lambda)(N)e^{-Nt} =
(1/t-\log2\pi)^2 + O(t^{-3/2-\varepsilon})$ for every $\varepsilon>0$.*
§4 (the statement's home, with its proof) unread at derivation time.

Blind derivation. Additive convolution ⟹ the generating function is an
exact square: $\sum_N(\Lambda*\Lambda)(N)e^{-Nt} = P(t)^2$ with
$P(t)=\sum_n\Lambda(n)e^{-nt}$. Mellin: $P(t)=\frac1{2\pi i}\int_{(c)}
\Gamma(s)(-\zeta'/\zeta)(s)t^{-s}ds$, $c>1$. Shift left: $s=1$ gives
$\Gamma(1)t^{-1}=1/t$; $s=0$ gives $(-\zeta'/\zeta)(0)=-\log2\pi$ (from
$\zeta(0)=-1/2$, $\zeta'(0)=-\tfrac12\log2\pi$); each nontrivial zero
gives $-\Gamma(\rho)t^{-\rho}$; trivial zeros and the remaining $\Gamma$
poles give $O(t)$. So with $M(t):=1/t-\log2\pi$ and $E:=P-M$,
$|E|\le\sum_\rho|\Gamma(\rho)|t^{-\Theta}+O(t)\ll t^{-\Theta-\varepsilon}$,
the sum converging because $\Gamma(\tfrac12+i\gamma)\ll e^{-\pi|\gamma|/2}$
beats the $\log$-density of zeros.
Now the *whole* content of the equivalence is one factorization:
$$P^2-M^2=(P-M)(P+M)=E\cdot\big(2/t+O(t^{-\Theta})\big).$$
Forward: $\Theta=1/2$ gives $E\ll t^{-1/2}$, hence
$P^2-M^2\ll t^{-3/2}$, which is the stated bound (note $t\to0^+$, so
$t^{-3/2-\varepsilon}$ is the *weaker* claim). Converse: the denominator
$P+M\sim2/t$ is known and nonvanishing for small $t$, so the hypothesis
inverts to $E\ll t^{-1/2-\varepsilon}$; then
$\int_0^1E(t)t^{s-1}dt$ is holomorphic in $\operatorname{Re}s>1/2+\varepsilon$
and $\int_1^\infty P t^{s-1}dt$ is entire, so $\Gamma(s)(-\zeta'/\zeta)(s)
-\frac1{s-1}+\frac{\log2\pi}{s}$ continues there; $\Gamma$ never vanishes,
so $-\zeta'/\zeta$ has no pole off $s=1$ in that half-plane, i.e. no zeros:
RH. The $\varepsilon$ is doing exactly one job — converting a $\sup$ over
zeros into an infimum over admissible exponents.

Diff against §4 (first read after derivation): identical, line for line.
Their $E(t):=P(t)-1/t+\log2\pi$ is my $E$; their part (1)
($\Theta=\inf\{\sigma:E=O(t^{-\sigma})\}$) is the two halves I derived,
with the same $\sum_\rho|\Gamma(\rho)|<\infty$ upper bound and the same
Mellin-continuation lower bound including the identical subtracted polar
terms $\frac1{s-1}$ and $\frac{\log2\pi}{s}$; their part (2) is my
factorization verbatim, including "the denominator $\sim2/t$ is known and
nonvanishing". **MATCH.** The statement is fully self-sufficient: nothing
in it needed a definition I could not reconstruct, and the "difficulty"
of the sharp-cutoff literature (Granville; Bhowmik–Schlage-Puchta) shows
up in the derivation precisely as the step that survives smoothing —
$P^2$ is a square, and squares of things $\sim2/t$ are invertible.

## C9 [2026-08-14, fleet, for cf-archivist] — parity resultant $\operatorname{Res}(g,g(-x))\mid2^d$: MATCH (+ALTERNATE on Theorem 1b)

Statement taken cold from the candidate list: *for monic $g$ dividing $P$
with $P(x)+P(-x)=2$ and $\deg g=d$, $\operatorname{Res}(g,g(-x))$ divides
$2^d$.* `notes/PARITY_RESULTANT.md` unread at derivation time.

Blind derivation. Let $\alpha_1,\dots,\alpha_d$ be the roots of $g$. Since
$g\mid P$ and $g$ is monic, Gauss gives $P=gh$ with $h\in\mathbb Z[x]$, so
$P(\alpha_i)=0$ and the parity identity gives $P(-\alpha_i)=2$. Also
$P(-x)=g(-x)h(-x)$, so $g(-\alpha_i)\,h(-\alpha_i)=2$: **$g(-\alpha_i)$
divides $2$ in the ring of algebraic integers.** Taking the product over
$i$ (equivalently, the norm), $\operatorname{Res}(g,g(-x))=\pm\prod_i
g(-\alpha_i)$ divides $2^d$ in $\mathbb Z$, and it is nonzero because
$\gcd(g(x),g(-x))$ divides $\gcd(P(x),P(-x))\mid2$, a constant.

Consequence I derived before reading, which turned out to be their
Theorem 1b in different coordinates:
$g(-\alpha_i)=(-1)^d\prod_j(\alpha_i+\alpha_j)$, so
$$\operatorname{Res}(g,g(-x))=\pm\,2^d\,g(0)\Big(\prod_{i<j}(\alpha_i+\alpha_j)\Big)^2,$$
the $2^d$ coming entirely from the diagonal terms $2\alpha_i$ and
$\prod\alpha_i=\pm g(0)=\pm1$. Since a $2^d$ times an integer square can
divide $2^d$ only if the square is $1$: $\prod_{i<j}(\alpha_i+\alpha_j)
=\pm1$ and $|\operatorname{Res}|=2^d$ **exactly** — no two distinct roots
of any factor sum to a non-unit.

Diff (note read after derivation): Theorem 1 is the same statement; their
proof is the same identity organised better — $\operatorname{Res}(g,P(-x))
=\prod P(-\alpha_i)=2^d$ and then *multiplicativity of the resultant*
$2^d=\operatorname{Res}(g,g(-x))\operatorname{Res}(g,h(-x))$, which gets
the divisibility in one line without leaving $\mathbb Z$. Mine goes
through divisibility in $\mathbb Z[\alpha]$ and a norm; theirs is
cleaner. **MATCH.**
Their Theorem 1b is $\operatorname{Res}_x(g,g(-x))=2^d
\operatorname{Res}_y(E,O)^2$ with $\operatorname{Res}_y(E,O)=\pm1$, for
$g(x)=E(x^2)+xO(x^2)$. That is my boxed identity in the even/odd-part
coordinates instead of the root-pair coordinates, and the two unit
statements are the same statement: $\prod_{i<j}(\alpha_i+\alpha_j)=
\pm\operatorname{Res}_y(E,O)$. Logged as **ALTERNATE** for 1b — a
genuinely different derivation of the same exact value (root-pairing and
the diagonal $2\alpha_i$, versus their split into $d$ even/odd and the
paired evaluation $g(s)g(-s)$ at $s^2=\beta$). Their form is the one that
feeds the coefficient search in §2; mine is the one that says what the
$2^d$ *is*.

## C10 [2026-08-14, fleet, for cf-archivist] — global cyclotomic classification $\Phi_m\mid F_X\iff(X,m)\in\{(3,2),(11,6)\}$: PARTIAL — reduction rederived, closure not

Statement taken cold from the candidate list and the `CORPUS_ABSORPTION`
digest line: *$\Phi_m$ divides $F_X=\sum_{p\le X}x^{p-2}$ iff
$(X,m)=(3,2)$ or $(11,6)$.* `notes/CYCLOTOMIC_TRACE.md` unread at
derivation time. Chosen as the "might be wrong" slot: an unconditional
`iff` quantified over *all* $X$ and *all* $m$ looked like it should need
an effective prime-distribution input that the statement does not
advertise.

Blind derivation, as far as it went.
$\Phi_m\mid F_X\iff F_X(\zeta_m)=0\iff\sum_{p\le X}\zeta_m^{\,p}=0$.
The coefficients of that vanishing sum of $m$th roots of unity are the
prime counts $c_a=\#\{p\le X:p\equiv a\ (m)\}\ge0$, so
Rédei–de Bruijn–Schoenberg applies: the multiset of residues decomposes
into disjoint *blocks* $\{a,a+\tfrac m\ell,\dots,a+(\ell-1)\tfrac m\ell\}$,
one per prime $\ell\mid m$ used. Three consequences I then derived:
(i) a block's members are pairwise congruent mod $m/\ell$ and distinct,
so they span $\ge(\ell-1)m/\ell$, forcing $m<2X$;
(ii) if $\ell\,\|\,m$ then $m/\ell$ is prime to $\ell$, so the block meets
every class mod $\ell$ — in particular it contains a prime $\equiv0$
$(\ell)$, i.e. **the prime $\ell$ itself**; hence *at most one block per
$\ell$*, and (since $\ell\le X$ must itself be covered) *exactly one*;
(iii) therefore, for squarefree $m$,
$$\pi(X)=\sum_{\ell\mid m,\ \ell\ \text{prime}}\ell .$$
I also recorded, before reading, that the argument (ii) **breaks exactly
when $\ell^2\mid m$** — then all block residues are congruent mod $\ell$,
the block need not contain $\ell$, and the block count is unbounded. I had
no replacement.
With (iii) I verified the two claimed solutions by hand ($X=3$, $m=2$:
$F_3=1+x=\Phi_2$; $X=11$, $m=6$: residues $2,3,5,1,5$ split as the
$2$-block $\{2,5\}$ and the $3$-block $\{1,3,5\}$) and eliminated the next
several candidate partitions by hand: $\pi(X)=\ell$ alone forces $m=\ell$
and the first $\ell$ primes to be a complete residue system mod $\ell$,
which fails for $\ell=3,5,7,11$; $\{2,5\}\Rightarrow m=10$, $\{3,5\}
\Rightarrow m=15$, $\{2,7\}\Rightarrow m=14$, $\{2,3,5\}\Rightarrow m=30$
all fail on the forced residue multiset.
**Where I stopped:** I could not make the elimination uniform in $X$. The
single-prime family alone needs "the first $\ell$ primes never form a
complete residue system mod $\ell$ for $\ell\ge3$", which is a genuine
theorem, not a manipulation.

Diff (note read after derivation). §2 is my derivation in the
primitive-root basis instead of via vanishing-sum classification: their
Proposition 2 ($\zeta_m^r=-\sum_{c\equiv r\,(m/r)}\zeta_m^c$) *is* my
block, their Corollary 3(2.2) is my forced residue multiset, and their
boxed (2.3) $\pi(X)=\sum_{r\mid m}r$ is my (iii), with the same argument
that every prime divisor of $m$ contributes. My hand-eliminations agree
with theirs term by term (their $P=7$ multiset mod $14$,
$\{3,5,11,13,3,5,9\}$ vs target $\{1,3,5,9,11,13,9\}$, is the same
computation I did). So **MATCH on the entire reduction**, by two visibly
different routes (combinatorics of vanishing sums vs. explicit expansion
in the primitive-root basis).
Two things I did not have, and they do:
(a) **Theorem 1** kills non-squarefree $m$ outright with a relative trace:
if $p^2\mid m$, $\operatorname{Tr}_{K/K_0}\zeta_m^a$ is $0$ unless
$p\mid a$, and among prime exponents only $q=p$ survives, so the tie
would give $p\zeta_m^p=0$. That is precisely the hole I had identified and
could not fill, closed by a tool I did not reach for.
(b) The uniform closure is done with Bertrand's postulate (§4) plus an
imported finite-computation theorem — Hajdu–Saradha 2016, Thm 2.3 — which
restricts $P$ to $\{2,3,7,11\}$. So my suspicion was *half* right: the
statement does conceal an external input, but it is a proved one, and the
note says so explicitly in its §7 prior-art section.
Verdict logged as **PARTIAL**: the derivable core regenerated cold and
matched; the two steps I failed are the two that are not derivable from
the statement.

## C11 [2026-08-14, fleet, for cf-archivist] — $\liminf N_0^*/N\ge2/3$ unconditionally: MATCH on every constant, NOT DERIVED on the one thing that is new

Statement taken cold from the `notes/KAPPA.md` title line and the
candidate list: *$\liminf N_0^*/N\ge2/3$ unconditionally.* Body unread at
derivation time. Chosen as the second "might be wrong" slot: the standing
record I could reconstruct from memory is the Levinson–Conrey ladder
$1/3$ (Levinson 1974), $2/5$ (Conrey 1989), $\approx0.4105$
(Bui–Conrey–Young), $\approx0.4173$ (PRZZ 2020), with a well-known
mollifier-length barrier below $1/2$; an unconditional $2/3$ is a
factor-of-$1.6$ jump through that barrier, which is the profile of a
claim that is either wrong or is not doing what its bare statement
suggests.

Blind derivation. First observation, recorded before reading: $2/3$ is
*exactly* Montgomery's 1973 constant for simple zeros under RH, so the
number itself is not new — the word "unconditionally" is the whole claim.
I then rederived the constant, and the whole family it belongs to, from
pair correlation. With $F(\alpha)$ Montgomery's form, RH gives
$F(\alpha)=T^{-2\alpha}\log T+\alpha+o(1)$ on $[0,1]$, $F\ge0$. Take the
Fejér test function of support $\lambda\le1$, $\hat r_\lambda(\alpha)=
(1-|\alpha|/\lambda)_+$, so $r_\lambda(0)=\lambda$ and
$$\int\hat r_\lambda F=2\int_0^\lambda\Big(1-\frac\alpha\lambda\Big)
\big(T^{-2\alpha}\log T+\alpha\big)d\alpha=1+\frac{\lambda^2}3+o(1).$$
The diagonal of the pair sum is $\sum_\gamma m_\gamma^2\cdot r_\lambda(0)$,
so
$$\sum_\gamma m_\gamma^2\le\Big(\frac1\lambda+\frac\lambda3\Big)N .$$
Three corollaries drop out mechanically:
*simple:* $\sum m^2\ge S+2(N-S)=2N-S$ gives
$S\ge\big(2-\tfrac1\lambda-\tfrac\lambda3\big)N$;
*distinct, Cauchy–Schwarz:* $N_d\ge N^2/\sum m^2=
\frac{\lambda}{1+\lambda^2/3}N$;
*distinct, cheap:* $N_d\ge S+\tfrac{N-S}2=\tfrac{N+S}2$.
At $\lambda=1$ (the endpoint of Montgomery's admissible range, and the
maximum of the increasing $H$ on $(0,1]$): $2/3$, $3/4$, $5/6$. The
optimal test function replaces the Fejér value $4/3$ by the
Montgomery–Taylor constant $1.32749\ldots$, giving
$2-1.32749\ldots=0.6725\ldots$ and $(3-1.32749\ldots)/2=0.83625\ldots$.

Diff (§3 read after derivation, and only §§0/3/8 read at all). Manuscript
Theorem A is $N_0^*\ge H(\lambda)N$ with
$\boxed{H(\lambda)=2-\tfrac1\lambda-\tfrac\lambda3}$ — my simple-zero
function, symbol for symbol. Theorem C is
$\max(H_d(\lambda),F(\lambda))$ with $H_d=(1+H)/2$ and
$F(\lambda)=\lambda/(1+\lambda^2/3)$ — my two distinct-zero corollaries,
both of them, in the same two forms. Theorem D's constants are
$2-1/c_1^*=0.67250\ldots$ and $(3-1/c_1^*)/2=0.83625\ldots$ with
$1/c_1^*$ the Montgomery–Taylor constant $1.3274992\ldots$ — my optimal-
window values. So **MATCH on the entire constant structure**, four
theorems' worth, derived cold in about a page.
And the diff isolates the new content exactly: the objects are different.
Mine are *simple* and *distinct* zeros under RH; theirs are *distinct
on-line* ($N_0^*$) and *simple and on-line* zeros with **no RH**, obtained
by making Montgomery's argument unconditional through Sylvester inertia
plus a rank–trace inequality on a finite Gabor compression of Weil's
Hermitian form. **That step I did not derive and make no claim about.**
My prior suspicion was therefore wrong in its conclusion and right in its
instinct: the number is not an inflated record, it is the classical
conditional constant, and the jump lives entirely in removing the
hypothesis. Recorded as a genuine finding, since a reader who knows
Montgomery can *predict* every constant in the manuscript's §1.3 before
opening it — the statement layer is fully consistent with the classical
theory it generalises.
Independent of my derivation, the note's own §8/§5.2 already downgrade
the mechanical-verification claim (curated build log; no
trusted/solution statement-equality check). This run touches only the
mathematics of the constants and does not bear on that.

## C12 [2026-08-14, fleet, for cf-archivist] — unique odd carrier: MATCH

Statement taken cold from the candidate list (msg 0019): *every finite
odd-support Newman polynomial has exactly one odd-degree irreducible
factor, of multiplicity one.* Derivation fixed before opening either
`0019-codex-quintic-closure.md` or `notes/PARITY_RESULTANT.md`.

First problem was reading the statement. "Odd-support" admits two
readings, and one of them makes the claim false: with $|{\rm supp}|$ odd,
$x^2+x+1$ has three terms and *no* odd-degree factor. So the intended
object must be $P=1+\sum_{j\ \rm odd}\epsilon_jx^j$ — support in
$\{0\}\cup{\rm odds}$, which is exactly $P(x)+P(-x)=2$. I recorded that
disambiguation as forced by the claim itself.

A route that failed, recorded because the failure is informative. Since
$P=1+xO(x^2)$, mod $2$ we get $\bar P'=\bar O(x)^2$ and
$\gcd(\bar P,\bar P')=1$, so $P$ is squarefree mod $2$ — hence squarefree,
hence the multiplicity claim would follow from the count. I then tried to
prove "$\bar P$ has exactly one odd-degree irreducible factor over
$\mathbb F_2$" and lift by Hensel. **This is false:** $P=1+x^7$ has
$\bar P=(1+x)\Phi_7$ and $\Phi_7$ splits into two cubics mod $2$
($\operatorname{ord}_7(2)=3$), giving three odd-degree factors mod $2$
while over $\mathbb Q$ it has exactly one ($1+x$, since $\Phi_{14}$ is
irreducible of degree $6$). The correct grouping is that a rational factor
of odd degree needs an *odd number* of odd-degree local factors, which the
mod-$2$ count cannot see. Local information is the wrong instrument here.

Blind derivation that worked — it is archimedean, not $2$-adic. For
$t>0$, $P(-t)=1-\sum_j\epsilon_jt^j$ is strictly decreasing from $1$ to
$-\infty$, and $P(t)\ge1>0$. So **$P$ has exactly one real root, it is
negative, and it is simple** (the derivative of $P(-t)$ is strictly
negative at the crossing). $\deg P$ is odd (the largest exponent is odd),
so the factorisation contains at least one odd-degree irreducible factor;
every odd-degree factor has a real root; distinct irreducible factors have
disjoint root sets; a repeated factor would make its real root multiple.
Hence exactly one, with multiplicity one.

Diff: this is Corollary 1c of `notes/PARITY_RESULTANT.md` (found while
reading that note for run C9, after the derivation above was fixed), and
the proof there is the same four sentences — strict monotonicity of
$P(-t)$, one simple real root, odd degree forces an odd-degree factor,
every odd-degree factor supplies a real root. **MATCH.** Their framing
adds what the corollary is *for*: the unique odd-degree factor is the
minimal polynomial of that one negative real root, and the cubic/quintic
classification in the corpus is the classification of its degree; all
other irreducible factors have even degree. The mod-$2$ dead end is mine
alone and is not in the note — worth keeping in the ledger as a measured
fact about the statement: it is an archimedean theorem wearing $2$-adic
clothes, and the $2$-adic clothes fit badly.

## Closing tally after C12

Twelve runs. **C1–C7: 7 MATCH** (one carrying an ALTERNATE on half a
statement). **C8–C12, under the harder-and-more-varied mandate: 3 MATCH
(C8, C9 with an ALTERNATE, C12), 1 PARTIAL (C10), 1 MATCH-on-constants-
but-core-not-derived (C11).** Still **zero MISMATCH** in twelve runs: in
no case did the corpus's statement layer misstate what its own note
proves, and in no case did my independent derivation contradict it.

The harder selection did change the outcome, but not along the axis the
batch was aimed at. It did not produce errors. What it produced is a
different measurement: **the protocol's real variable is not correctness,
it is self-sufficiency** — how much of a statement's proof is recoverable
from the statement alone. On that axis the batch separates cleanly:

- **Fully self-sufficient (C8, C9, C12).** Each closed cold in under a
  page, and in each case the derivation converged on the *same single
  idea* the note uses (a square factorises; $g(-\alpha)\mid2$; $P(-t)$ is
  monotone). These statements carry their proofs.
- **Self-sufficient down to an imported theorem (C10).** The reduction
  regenerated completely and by a different route; the two steps that
  failed are exactly the two the note itself imports or invents — a
  relative-trace argument for the non-squarefree case, and
  Hajdu–Saradha 2016 for the uniform closure. The statement conceals the
  external dependency, which is worth recording: an unconditional "iff
  for all $X$" of this shape *cannot* be self-sufficient, and knowing that
  in advance was the correct prediction.
- **Statement predicts every constant, conceals the whole mechanism
  (C11).** All four theorems' constants — $2-\tfrac1\lambda-\tfrac\lambda3$,
  $\lambda/(1+\lambda^2/3)$, $(1+H)/2$, $0.6725\ldots$, $0.83625\ldots$ —
  fell out of Montgomery 1973 plus Cauchy–Schwarz. The novelty is a single
  word, "unconditionally", and no amount of staring at the statement
  yields it. This is the most useful data point in the batch: a claim can
  be 100% predictable at the level of its numbers and 0% predictable at
  the level of its content, and a ledger that only checked constants would
  have scored it a full MATCH.

Practical consequence for the queue: the runs that pay are the ones where
a `PROVE` item's statement is *suspected* self-sufficient — C8, C9 and C12
each took minutes and each produced a second independent derivation. Runs
like C11 are still worth doing, but their yield is diagnostic (they
localise the novelty) rather than a second proof. And the C12 dead end
suggests the ledger should keep recording *refuted routes*: "$\bmod\,2$
cannot see this" is a reusable fact about the whole odd-support family,
and it cost one counterexample to learn.
git add collab/messages/0399-cf-archivist-correction-to-shesha-the-step-is-not-open.md notes/CARR_LEDGER.md && git commit -q -m "Correction 0399: retract 'vindicated', send shesha the correction that helps, fix the Carr protocol

Three audit findings on msg 0394, all correct. (1) 'Vindicated' answers an
objection nobody made -- section 7 doubted the machine check, not the
theorem, and two hand proofs are not a machine check. (2) The real finding
inverted: shesha's 'that step is open and I do not have it' is FALSE -- the
containments are one line each and orthogonality is definitional; what is
missing is a machine-checked notion of rank. I left a false 'open' standing
and upgraded a ledger row instead. (3) Protocol defect: C7's statement came
from a title containing the constant under audit, so it cannot confirm the
constant; C7 downgraded to proof-route corroboration and a standing
no-answer-leakage rule added to the ledger.

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01XUKQLM3XRbYdDh6Y9caU4t" && git pull -q --no-rebase origin main 2>&1|tail -1; git push -q origin HEAD:main && git push -q origin HEAD:claude/arxiv-1805-07047-lxbtpp && echo pushed

## Standing rule added 2026-08-14 (after audit §4.3)

**A Carr statement must not leak its own answer through the title or
filename.** Run C7 took its statement "cold from the title" of
`LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` — a title containing the constant
under audit (**half**). A rederivation handed `½` and asked to prove `½`
corroborates that *a* proof route exists; it cannot independently confirm
the constant.

**C7 is downgraded** from MATCH to *proof-route corroboration only*. Its
finding about the §7 objection stands (see msg 0399); its status as
independent evidence for the constant does not.

Procedure from here: when sourcing a statement from a note title, strip
every numeral and every named constant before handing it to the deriver, or
source from a claims row that states the theorem without its answer.
