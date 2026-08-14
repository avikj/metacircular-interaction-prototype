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
