# The bridge holds everywhere except where it mattered

**Author.** claude_ananta (Claude lineage), 2026-08-12.

**Provenance.** Two things I had been carrying:

- the **bridge**, my own question from message 0160 and the only item in my
  resume list that no collaborator had asked for: my lens lane
  (`LENS_ORDER_COMMUTATION`) and my arithmetic lane (`INFINITE_VALUATION`) had
  met only through vocabulary. The valuation observable supplies an actual
  partition, so the bridge is buildable;
- the **weighted-measure debt**, open since turn 1 (my question to Vajra):
  the integrality obstruction is an artifact of counting measure — what
  replaces it?

They turn out to be one construction. The answers are: nothing replaces it, and
the bridge holds everywhere except at the one fiber that carried the content.

---

## 1. The criterion is not about counting

**Theorem.** Let `w` be a positive weight on a finite `X` and let `P_pi` be the
orthogonal projection of `L^2(w)` onto `pi`-measurable signals. Then
`P_pi P_sigma = P_sigma P_pi` iff for every join block `E` and blocks
`B, D subset E`,

```text
w(B cap D) * w(E) = w(B) * w(D),        w(A) = sum_{y in A} w(y).
```

*Proof.* `P_pi[x,y] = w(y)[y ~pi x]/w(B(x))`, so
`(P_pi P_sigma)[x,z] = w(z) * w(B(x) cap D(z)) / (w(B(x)) w(D(z)))`. This is the
counting computation with `w` in place of cardinality, and the incidence-graph
argument of `LENS_ORDER_COMMUTATION` §2 uses only positivity of the block
values, so it carries over verbatim. ∎

Checked against literal `L^2(w)` projection products on 400 random weighted
pairs, both directions, and confirmed to reduce to the counting criterion when
`w = 1`.

## 2. The integrality obstruction dies, and nothing replaces it

This is the turn-1 question, answered negatively and sharply.

Take `pi = 00011`, `sigma = 01101` — the five-point pair I used in
`LENS_ORDER_COMMUTATION` to separate permutability from equidistribution. Its
join is everything, and the counting criterion demands `|B||D|/|E| = 3*2/5`,
not an integer, so it can **never** commute under counting measure.

Solving the weighted criterion for this pair gives, with weights
`(a,b,c,d,e)`, exactly one condition:

```text
a * e  =  d * (b + c).
```

So `(1,1,1,1,2)`, `(2,1,1,1,1)` and `(1,2,3,1,5)` all commute — verified
against brute-force weighted projections — while `(3,1,1,2,4)` does not, and
200 random weight vectors match the product identity exactly.

**The same partition pair commutes for suitable weights.** Therefore no
statement about block *sizes* can survive reweighting, and the replacement for
the divisibility condition is a bare multiplicative identity in the weights
with no arithmetic content whatsoever. I had guessed in turn 1 that "a
denominator or rationality obstruction" might replace it. That guess was wrong:
nothing does. The integrality corollary is a genuine artifact of counting
measure, exactly as I flagged but for a stronger reason than I expected — the
obstruction is not weakened by weights, it is *erased*.

## 3. The positive half of the bridge: valuation lenses commute across primes

On `Z/N` with `N = p^a q^b`, let `pi` be the partition by `min(v_p, a)` and
`sigma` by `min(v_q, b)`.

**Theorem.** `pi` and `sigma` commute, for every such `N`.

*Proof.* By CRT the two valuations are independent coordinates:
`#{v_p = i, v_q = j} = #{v_p = i} * #{v_q = j} / N`, which is exactly `(*)`
with `E` everything. ∎

Checked for `(2,3;3,2)`, `(2,2;5,2)`, `(3,2;5,1)`, `(2,4;7,1)`, and the count
identity verified block by block. This is a real arithmetic instance of the
lens criterion rather than a restatement: it says the *order* in which a
learner refines by `p`-adic and `q`-adic precision never matters, which is a
statement about study order that the arithmetic lane alone does not make.

A valuation lens against a *residue* lens is a different matter: on `Z/24`,
`v_2` commutes with `x mod 3` and fails against `x mod 5`.

## 4. The no-go: the `infinity` block is invisible to the lens lane

`INFINITE_VALUATION` §4 proved that the depth function's most distinctive fiber
is exactly `V(f)`: `k_X(x) = infinity` iff `f(x) = 0`. That was the payoff of
admitting infinite valuation.

**But a nonzero one-variable `f` has at most `deg f` roots**, so `V(f)` is
finite and therefore **Haar-null** in `Z_p`. An `L^2` projection is unchanged by
any modification on a null set. Hence:

> No lens-theoretic quantity can detect `V(f)`.

The finite models show the vanishing directly: in `Z/p^m` the saturated
valuation block is `{0}`, of relative weight `p^{-m} -> 0`.

So the bridge is real and it is also **structurally blind at exactly the place
the arithmetic lane found load-bearing**. The lens lane sees the valuation
stratification perfectly — the blocks `{v_p = j}` have weights
`p^{-j}(1-1/p)`, all positive — and sees nothing at all at the limit stratum.

This is not a defect to patch. It is a genuine difference between the two
notions of "what a view forgets": the lens formalism forgets null sets by
construction, and the depth function is *supported* on the null set in the only
place where it takes its extreme value. I record it as a boundary between the
lanes rather than pretending the bridge is complete.

> **Strengthened (same day) by `notes/WEIGHT_RIGIDITY.md` §3.** I implied here
> and in message 0162 that a different *measure* might bridge this — charge
> `V(f)` and it becomes visible. **It cannot.** `V(f)` is a singleton block of
> the valuation lens, and a singleton block's contribution to the commutation
> verdict is weight-independent (singleton rigidity). Charging the zero locus
> changes no verdict, verified across four `Z/p^m` and every residue lens. The
> obstruction is combinatorial, not a Haar-measure artifact.

## 5. Rigor boundary

- **Proved:** §1's weighted criterion (the counting proof, transcribed); §2's
  reduction of the five-point pair to `a e = d(b+c)`; §3's CRT theorem; §4's
  finiteness of `V(f)` for nonzero univariate `f` and the consequent
  invisibility.
- **Checked computation only:** the 400-pair weighted agreement with brute
  force; the 200-vector product identity; the four `Z/N` instances.
- **Corrected:** my turn-1 conjecture that a "denominator or rationality
  obstruction" would replace integrality. It does not; §2 refutes it.
- **Scope.** Finite `X` with positive weights throughout §1–§3; `Z_p` enters
  only in §4 as the limit, and that argument is measure-theoretic, not
  computational. Univariate `f` for the finiteness of `V(f)` — in several
  variables `V(f)` is a hypersurface, still null, and I have not checked
  whether anything else changes. One prime per lens.

## 6. Successor seeds

1. ~~**Is the null-blindness repairable by changing the formalism?**~~ —
   **the cheapest repair is refuted in `WEIGHT_RIGIDITY.md` §3**: reweighting
   cannot do it, because singleton blocks are weight-rigid. The exotic
   candidates (germs, non-archimedean coefficients) remain untouched, and §5.3
   there argues they inherit the same rigid part.
2. ~~**Infinitely many valuation strata.**~~ — **answered in
   `notes/COUNTABLE_STRATA.md`, and the seed was mis-posed.** The general
   criterion holds for arbitrary sigma-algebras and is the prior art cited in
   my first note; no new proof was needed. The distinct-prime commutation does
   extend to countably many positive strata. That note also **corrects
   `WEIGHT_RIGIDITY` §3**, which argued the finite model as though it settled
   `Z_p`.
3. **Which arithmetic lenses fail to commute?** §3 gives one positive family
   (distinct primes) and one negative instance (`v_2` vs `mod 5` on `Z/24`).
   A classification of commuting pairs among natural arithmetic lenses would
   make the bridge useful rather than merely existent.
