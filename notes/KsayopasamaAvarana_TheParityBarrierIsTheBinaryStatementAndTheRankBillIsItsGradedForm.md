# क्षयोपशम-आवरण — the parity barrier is the binary statement; the rank bill is its graded form

**Term and source.** *āvaraṇa* — the obscuration of a faculty — and
*kṣayopaśama* (miśra), the partial destruction-cum-subsidence of an
obscuring karma under which partial knowing arises. Umāsvāti,
*Tattvārthasūtra*, c. 2nd–5th c. CE: 2.1 lists the five bhāvas of the
jīva, of which *miśra* is the kṣāyopaśamika; the eight mūla-prakṛtis,
headed by jñānāvaraṇīya and darśanāvaraṇīya, are at 8.5 in the
Śvetāmbara numbering and 8.4 in the Digambara — the recensions diverge
here and the divergence is recorded rather than resolved.

**Scope, said before anything else.** No Jain text states a tensor-rank
theorem and none is attributed one. What the tradition does state, and
what this note uses, is a *structural distinction*: obscuration is not
one thing. Total obscuration and graded partial lifting are different
categories with different mechanics, and the degree of lifting
determines the degree of what is known. That distinction is present in
the mathematics below, in the same place, and naming it records the
correspondence. The mathematics is Cuntz's, Umāsvāti's tradition's
distinction is Umāsvāti's tradition's, and the identification of the
two objects below is this repository's.

## The two statements

**Binary (Theorem F, `notes/GAUGE.md` F.2).** ω the unique KMS state of
the critical affine arithmetic system; every nontrivial isotypic sector
of the gauge torus has ω-expectation exactly zero. Factorization parity
is charged, so the sieve's equilibrium sees it as zero. Sieves cannot
see parity. This is an āvaraṇa in its total form: the faculty and the
object both exist, and the seeing is nil.

**Graded (`formal/pairfield/Pairfield/PrimeChargeArbitraryRank.lean`,
`PrimeChargeUnboundedLocalRank.lean`, kernel-checked).**
`squarefreeChargeCube n` — the Möbius-signed squarefree charge on n
prime places — has CP rank **exactly n**, for every n, by
`squarefreeChargeCube_rankExactly`. The proof runs through
`localZetaCube_squarefreeChargeCube_eq_wCube`: one invertible local ζ
twist per place carries the charge to the `W` tensor, rank is preserved
by a local change of basis, and `shiftedWCube_not_rankAtMost` bounds
`W`'s rank below by substitution induction uniform in a vacuum shift.

## They are the same statement, and the second prices the first

The gauge group in Theorem F is the torus indexed by primes; parity is
its evaluation at (−1, −1, …). The tensor's index set `Fin n → Bool` is
the ℤ/2 on n of those places, and `signFactor b = if b then -1 else 1`
puts the Möbius sign on every active non-marked place — the charge is
parity-charged in exactly Theorem F's sense.

`VajraNispaksa` §0 (cf-sesa, 2026-08-23) supplies the operation: the
Kuznetsov geometric side **sums over the modulus**, and a sum over the
group is a twirl E_G, whose fixed-point algebra is the neutral sector.
The diamond's reciprocity, by contrast, reparametrises bijectively and
keeps the charge; the two share the coordinate `uv = mn/c²` and are not
the same map.

Put together:

> **A rank-r separable radial family is r channels of charged data
> carried past the modulus-average, and the charge on n prime places
> needs exactly n. Theorem F is the case r = 0.**

The twirl annihilates the charged sector — total āvaraṇa. A separable
family of finite rank is a *graded* lifting of it, and the rank is the
price: one channel per place, no fewer, checked. That is the
kṣayopaśama structure and not a metaphor for it — partial seeing bought
at a stated, graded cost, with the cost determining what is seen.

## What this settles in `ChhayaGarbha`

§6 of `ChhayaGarbha` isolated the dichotomy's separating query as one
bit: is the separable family chosen **before** the modulus (∃family ∀q,
rank ≥ places carried by the whole level, unbounded) or **after** (∀q
∃family, rank = ω(q) ≤ (1+o(1))log q/log log q, normal order log log q
by Hardy and Ramanujan 1917). That section marked the arm-selection a
reading and not a theorem, and named the step it turned on.

The twirl answers it structurally. **Summing over c is what forces the
family to precede the modulus** — a kernel under a c-sum cannot depend
on c, which is the uniform quantifier written out. So the second arm is
the one the checked structure supports, and
`no_fixed_uniform_squarefreeChargeCube_rank` is its skeleton: no finite
channel count serves all finite sets of squarefree places.

The rank bill is unbounded because the places are unbounded, and the
places are unbounded because the primes are. Read back through Theorem
F: **the parity barrier is not an accident of sieve technique; it is
the r = 0 face of a cost that grows with the prime count, and any
method that keeps the c-sum pays it in full.**

## Rigor boundary

- **Kernel-checked**: `squarefreeChargeCube_rankExactly` (all n),
  `localZetaCube_squarefreeChargeCube_eq_wCube`,
  `shiftedWCube_not_rankAtMost`,
  `no_fixed_uniform_squarefreeChargeCube_rank`,
  `squarefreeChargeCube_rank_unbounded` — all inside `Pairfield.lean`'s
  import closure and the lakefile `globs`.
- **Proved in prose, modulo cited theorems**: Theorem F (`GAUGE.md`
  F.2), which is short because Cuntz's KMS uniqueness is deep.
- **Cited, not reproved**: ω(q)'s maximal and normal order (Hardy and
  Ramanujan, 1917); the `W` tensor's rank as it appears in the
  tensor-rank literature (Dür, Vidal and Cirac, 2000, for the class) —
  the Lean module proves it from scratch and depends on no citation.
- **This note's own step, now checked for its algebraic half**: that the
  tensor's charge and Theorem F's graded object are one function of the
  places. `formal/cubical/OjaYugma_TheSquarefreeChargeIsTheActivePlace
  CountTimesTheParityCharacter.agda` (`--cubical --safe`, no holes, no
  postulates, exit 0) proves

      आवेशः bs ≡ - (pos (ओजः bs) · पर्यायः bs)

  — the squarefree charge is the active-place count Ω times the parity
  character λ = (−1)^Ω, negated. So the function whose CP rank the Lean
  lane measures as exactly n is Theorem F's charged object, and r = 0 is
  the statement that its expectation vanishes. **What remains śeṣa** is
  the index shape: the Agda module works on a list of places, the Lean
  tensor on `Fin n → Bool`, and no map between the lanes is exhibited.
  Two lanes agreeing on a formula is not a map.
- **Taken from `VajraNispaksa` §0**: that the Kuznetsov c-sum is a twirl
  and the diamond reciprocity is not. Cited to that note, same day.
