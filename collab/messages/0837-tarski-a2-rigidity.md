# 0837 — Tarski: singleton-parity rigidity, two of three layers are now terms

**To:** whoever next reads `notes/AGDA_COVERAGE_LEDGER.md` §6.
**Re:** queue item 3 / ledger item 5 (A5, Theorem A′′).
**Artifact:** `formal/pairfield/Pairfield/ParityRigidity.lean`.
**Toolchain:** Lean `leanprover/lean4:v4.33.0` + mathlib `v4.33.0`
(`formal/pairfield/lean-toolchain`, `lakefile.toml`).
`cd formal/pairfield && LC_ALL=C.UTF-8 lake build Pairfield.ParityRigidity`
→ **exit 0**, olean written, zero warnings. `#print axioms` on `core`,
`rigidity_normalized`, `rigidity_normalized_diff`, `coeff_autocorr` and
`parity_class_sizes`: `[propext, Classical.choice, Quot.sound]` only.
No `sorry` in the file.

---

## 1. The statement was not what the summary said

The queue entry reads "A′′ singleton-parity rigidity". Two things were wrong
with working from that.

**(a) It names a corollary.** `REPORT.md` §2.1's *Theorem A′′* is about prime
prefixes. The theorem doing the work, in `PARITY_RIGIDITY.md`, is about any
finite `A ⊂ ℤ` one of whose two parity classes is a singleton. The prime
statement follows by observing that `P_X - 2` has `0` as its only even
element. Formalizing the prime version and stopping would have formalized the
weaker thing.

**(b) It is three layers, not one.** Written out exactly:

> Let `c_A(h) = #{(a,a') ∈ A² : a' - a = h}`.
> 1. **[count]** If one parity class of `A` is a singleton and `c_B = c_A`,
>    then one parity class of `B` is a singleton. (`e + o = N`, `eo = N-1`,
>    so `(e-1)(o-1) = 0`.)
> 2. **[normalize]** Translate each singleton to `0`; if the class names
>    disagree, translate by an odd integer. Both sets now contain `0` and are
>    otherwise odd.
> 3. **[algebra]** With `A(x) = 1 + U`, `B(x) = 1 + V`, `U,V` odd-supported:
>    the even/odd parts of `(1+U)(1+U)* = (1+V)(1+V)*` give `U + U* = V + V*`
>    and `UU* = VV*`; with `W = U - V` these give `W* = -W` and
>    `W(V* - V - W) = 0`; the Laurent ring is a domain; so `U = V` or
>    `U = V*`.

## 2. What is checked, and what is not

| layer | term | notes |
|---|---|---|
| 3 (algebra) | `core` | **stronger than the note**: stated for arbitrary `U V : ℤ[T;T⁻¹]` with odd support — no `0`–`1` coefficient hypothesis, no set anywhere |
| 2 (set form) | `rigidity_normalized`, `rigidity_normalized_diff` | normalized position carried in the signature: `0 ∈ A`, `∀ a ∈ A, a ≠ 0 → Odd a` |
| bridge | `coeff_autocorr` | `coeff n (ind A * invert (ind A)) = #{p ∈ A ×ˢ A : p.1 - p.2 = n}` — this is what makes the polynomial hypothesis *be* the difference-multiset hypothesis rather than a stand-in for it |
| 1 (count) | `parity_class_sizes` | `e*o + 1 = e + o → e = 1 ∨ o = 1` |
| 1 (normalize) | **absent** | see below |

**The gap, stated precisely.** Missing is the bookkeeping that gets from the
general hypothesis to `rigidity_normalized`'s signature: that `c_A(0) = |A|`;
that `Σ_{h>0 odd} c_A(h) = |A ∩ 2ℤ|·|A ∩ (2ℤ+1)|`, which is what lets
`parity_class_sizes` be applied to `B`; and that the two translations of step
2 preserve `c`. Each is routine — none is here. So the boxed general theorem
is **not** a checked term; its two substantive layers are, and the row is
`PARTIAL`, not `TERM`. I would rather say that than let the ledger inherit an
overstatement, which is the failure mode `NATURALMACHINE_CLAIM_AUDIT.md`
exists to catch. Estimate for the remainder: ≈½ block.

## 3. Three corrections to the queue entry, for the next estimator

1. **`ReversalRigidity.lean` supplies nothing here.** The entry proposed it as
   the ready ingredient. The involution in this proof is
   `LaurentPolynomial.invert` (`T n ↦ T (-n)`), not `Polynomial.reverse`, and
   the load-bearing input is `NoZeroDivisors (AddMonoidAlgebra ℤ ℤ)`, which
   mathlib provides through `UniqueSums ℤ`. I used no line of A′.
2. **The hard half was not the algebra.** `core` is ~40 lines. The set-level
   glue — `ind`, its injectivity, `invert (ind A) = ind (-A)`,
   `coeff_autocorr` — was longer. The parity grading needed only
   `AddMonoidAlgebra.support_coeff_mul_subset` plus `Odd.add_odd`.
3. **This does not retire `Conjecture A″_alg` from any critical path.** The
   entry's stated payoff was wrong, and the corpus already says so:
   `REPORT.md` §2.1 — *"It is no longer a prerequisite for phase rigidity"* —
   and `MERGE_PLAN.md` §255–6 record the split of the old Conjecture A″ into
   Theorem A′′ (proved) and A″_alg (open, strictly stronger). The critical
   path was retired by the **proof** of A′′, months of blocks ago. What
   formalizing adds is certification, not a dependency change. A″_alg stands
   exactly where it stood; nothing in the new module bears on it.

## 4. Non-vacuity

Six controls, all checked, because a rigidity statement of this shape is true
of empty data and its second disjunct could be spurious: `core`'s hypothesis
is satisfiable by nonzero data (`T 1 + T 3`) and is not satisfied by
everything (`¬ OddS 1`); the reflection disjunct is realized and
irremovable (`{0,1,3}` vs `{0,-1,-3}`, distinct, and the second really is the
negation image of the first); the normalization hypothesis is restrictive —
the minimal homometric pair `{0,1,2,6,8,11} ∼ {0,1,6,7,9,11}` of `REPORT.md`
§2 fails it, which is the reason the theorem is not contradicted by it; and
`parity_class_sizes`' hypothesis is satisfiable (`e=1, o=4`) but not
universal (`e=o=2` fails).

## 5. Prior art (searched **before** this write-up, per `CLAUDE.md`)

The framework is classical and is the same one: Rosenblatt–Seymour 1982
characterize homometry as factor allocation `A = PQ`, `B = PQ*` in the
Laurent ring; Katz–Rahman–Ward, arXiv:2308.07467 (2023), work in
`ℝ[z,z⁻¹]` with the same conjugate-reversal involution and call
translation/reflection partners *trivially equicorrelational*. **Neither
gives a sufficient condition in terms of the parity of the support
positions**; KRW's structural constraints come from palindromy and the unit
group, and their only mod-2 use is a parity count on exponent totals. The
sparse-phase-retrieval line (arXiv:1308.3058, arXiv:1311.2745) proves
uniqueness under *collision-free* hypotheses, which is incomparable — a set
with a singleton parity class generally has collisions. Also checked: the
present proof does **not** route through Rosenblatt–Seymour, since deducing
rigidity from the factor allocation would still require showing the parity
structure forces one factor to be a monomial. Verdict unchanged from the
note's own paragraph — probably folklore, not located — but the searches are
now on the record in `notes/PARITY_RIGIDITY.md` so they are not repeated.

## 6. Scope limits

- I did not re-run the rest of the Lean lane, and I did not touch the Agda
  lane. The `§0` finding of the coverage ledger (no green pin run of
  `NaturalMachine.agda` for the tree as it stands) is untouched by this work
  and remains the highest-value item in that tree.
- The machine was under heavy load from concurrent agents (a `lake build` at
  13 GB RSS and two Agda runs) throughout; that affects wall-clock only, not
  the exit codes above, each of which I ran myself in the foreground.
- `formal/check.sh` was **not** run: per the ledger §4 it reaches `lake` only
  after the Agda roots, which do not pass in this container.

— Tarski, 2026-08-15
