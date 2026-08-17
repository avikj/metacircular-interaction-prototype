# What this machine can actually close: a capability assessment against named targets

**Status:** strategy note. Asserts no mathematics. Every capability claim below
cites a checked artifact or a landed proof; every incapacity claim cites the
corpus's own no-go.

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14. Written at human direction
("orient the machine around a target problem even if it's absurd").

---

## 0. The constitutional objection, and why it does not block this

`COGNITIVE_ORIENTATION.md` §8: *"No named conjecture — RH, Goldbach, twin
primes, FLT, Collatz, or otherwise — is the destination. Hard problems are
instruments measuring the current frontier and calling for missing
invariants."*

That is right and this note obeys it. A target is chosen here **as an
instrument**: the criterion is not "is it famous" but *which problem produces a
decisive outcome either way* — a proof or a certified no-go — from capabilities
this repository demonstrably has. The corpus already prizes no-gos as
first-class; a well-chosen target is one where both branches are landings.

Note also: **Fermat's Last Theorem was proved in 1995** (Wiles; Taylor–Wiles).
It belongs to the list of problems that motivated building a machine like this —
350 years, and the proof needed mathematics nobody had — not to the list of
available targets.

## 1. What this machine demonstrably does

Each line is evidenced, not asserted.

| capability | evidence |
|---|---|
| **Exact finite classification** | prime-prefix factor degrees 1–9 excluded (F1–F9); reciprocal degree 10 closed |
| **Certified root cages and polytope boxes** | `NONRECIPROCAL_DECIC_FRONTIER`; improved 2026-08-14 from `√2` to the plastic number |
| **Exact resultant / Smith / Graeffe algebra** | `RECIPROCAL_DECIC`, `PARITY_RESULTANT`, `M2Unimodular`, the Γ₀ torsor tower |
| **Machine-checked formalisation** | 19 of 30 Agda modules check `--safe`; the Lean pairfield kernel |
| **Adversarial refutation at scale** | 8 verified refutations in one pass, one machine-checked (`FLEET_BREAKER_PASS_2026_08_14`) |
| **Cross-lane identification** | one congruence found under five vocabularies; leakage rank = incidence rank |

The shape is unmistakable: **this is a classification-and-refutation engine.**
It is very good at deciding finite questions exactly, at proving that a proposed
compression is impossible, and at noticing that two things are the same theorem.

## 2. What it does not have, by its own no-gos

The corpus has proved, against itself, why the famous analytic targets are out
of reach — and these are the strongest results it owns:

- **The parity barrier is not a difficulty, it is a theorem.** `WIDTH.md`:
  infinite width on the exponent scale. Local filters, fixed observables, and
  smoothing provably lose the required information (`DCLOSE_NO_GO`,
  `PROJECTION_LEAKAGE`, the `*_NO_GO` family).
- **The frontier constants `0.6725/0.83625` are closed inside their frame**
  along sign, integer-hull, and trace-degree axes (`context_dump.md`). The only
  door is off-diagonal information just past band 1, or a change of theater.
- **The hard corner is unbroken**: simultaneous recovery of internal
  factorisation charge (`Ω`, Buchstab, Igusa, Walsh) and the external sharp
  antipodal boundary. Every positive/local/smoothed interior is controlled; the
  joint boundary is not.
- **Tonight's Gauss finding removes one hoped-for route**: the split-form branch
  has square discriminant, class number 1, and generating function `ζ(s)²` — the
  divisor problem, no Dirichlet L-function. No arithmetic is reachable from
  there.

So: **RH, Goldbach, and twin primes require an analytic-estimate engine, and
this is not one.** Pointing it at them produces beautiful representation theory
that does not attack the arithmetic — which is exactly what Delta 20's own
breakthrough criterion warns against.

## 3. The recommendation: prime-prefix irreducibility

> **Conjecture A″.** For every `X ≥ 2`, `F_X(x) = Σ_{p ≤ X} x^{p−2}` is
> irreducible over `ℚ`.

This is the target. It is genuinely open, it is a *classification* problem —
precisely this machine's demonstrated competence — and the corpus is already
most of the way through the ladder.

**State of play (all already landed):**

- Degrees 1–9: every irreducible factor degree classified or excluded (F1–F9).
- Degree 10 reciprocal: closed. For `X ≥ 13`, `δ(F_X) ≥ 10` and
  `δ_rec(F_X) ≥ 12`, so any decic factor is totally nonreal and nonreciprocal.
- Asymptotically: least factor degree `≫ log₂X(log₄X)⁴/(log₃X)⁴`; every
  nonreciprocal factor has degree `≫ log₂X·log₄X/log₃X`.
- Conservation: an integral cross-reversal index `L`, `|L| < 2.5·10¹⁴`, with the
  unsquared law `L | 𝒞(F_X)`.
- Two sharp negative controls: `exp49` (endpoint + full mod-2 + collision-mod-7
  can return to zero on a genuine prime prefix) and `exp51` (global charge zero
  can be caused by an unrelated reciprocal pair). These say what the next
  theorem must control: **the localized combined ordered prime-residue state**,
  not marginal frequencies or unlocalized compound charge.

**Why it is in reach, and why tonight moved it.** The open layer is nonreciprocal
degree 10, attacked by enumerating a coefficient box cut out by a root cage.
The cage just improved:

- old: `φ⁻¹ < |z| < √2` — and the inner half is **Odlyzko–Poonen (1993)**, not a
  sharpening (prior-art miss, found 2026-08-14);
- new, proved: `5/8 < |z| < 4/3` for `X ≥ 17`, with the outer constant tending
  to the **plastic number** `ρ = 1.3247…` (`t³ − 2t² + t − 1 = 0`), by sieving
  the *prime* support mod 3 rather than using "odd support";
- the polytope vertex becomes **entirely rational**, `(4/3,4/3,4/3,5/8,27/40)`,
  and the boxes shrink (endpoint `1241 → 1195`).

Continuing the sieve is the same one-line argument per prime. Worked further
tonight, not yet certified: mod `{3,5}` gives `|z| < 1.256`, mod `{3,5,7}` gives
`|z| < 1.239`. Each shrinks the enumeration box multiplicatively in nine
coefficients — this is the difference between an infeasible search and a
feasible one.

**Whether the cage sequence tends to 1 — answered, and the answer is no.**
Sieving by all primes `≤ Q` leaves admissible `k` of density
`∏_{q≤Q}(1−1/q) ~ 2e^{−γ}/log Q` (Mertens). For `u = 1−ε` the sum
`Σ_{k admissible} u^k` is dominated by `k ~ 1/ε`, giving `≈ c/log(1/ε)`; setting
this to 1 gives `ε → e^{−c}`, a **constant**, hence a limiting cage
`r_∞ = (1−e^{−c})^{−1/2} ≈ 1.2`, strictly above 1. So the sieve route has a
floor, and it is *not* the unit circle. **This is a heuristic, not a theorem** —
it assumes the sieved set equidistributes on the initial segment `k ≲ 1/ε`,
which is exactly where it need not, and making it rigorous is the same
short-interval prime-density problem that Montgomery–Vaughan only controls for
`K > e⁴/2 ≈ 27`. Recorded as a prediction to be confirmed or killed, with the
number `≈1.2` written down in advance (`PROTOCOL.md` §4).

**Decisive either way.** If the nonreciprocal decic layer closes, degree 10 is
done and the ladder continues. If the tightened box still admits survivors, that
is a certified obstruction naming exactly which coefficient pattern the cage
cannot exclude — a landing under the corpus's own culture.

**Deliverable shape.** *"Machine-checked: the prime-prefix polynomial has no
irreducible factor of degree ≤ 10, with certified root cages and a Lean-verified
finite enumeration."* That is a real, statable, defensible result. It is not RH.
It is also not vapour.

## 4. The stretch target: repair the length-five Liouville window

`R0021` refuted a published length-five pattern proof step by an exact
stationary ten-zero countermodel. That is already the corpus's most significant
external-facing result, and it is **unfinished**: the refutation stands, the
repair does not exist.

Tonight sharpened the repair search decisively. With `σ₁` flipping `(ε₁,ε₅)` and
`σ₂` flipping `(ε₂,ε₄)`:

```text
μ_{a,b,c} ∘ σ₁ = μ_{−a,b,c},    μ_{a,b,c} ∘ σ₂ = μ_{a,−b,c}
```

for **all** parameters. So the equality set is a single `⟨σ₁,σ₂⟩`-orbit, and
half the cube is structurally invisible to the flip argument. The consequence is
a narrow, testable criterion:

> **Any additional arithmetic constraint that is *not* invariant under `a ↦ −a`
> breaks all four extremal vertices at once.**

That is a far smaller search than "find a higher-window constraint", and it is
the right next move.

**Blocking prerequisite, and it is not optional.** The attribution of `R0021` to
a specific step of arXiv:1904.05096 §7 is **single-sourced and unaudited** —
egress to arxiv/cambridge is blocked in this environment. If that paper uses even
one constraint beyond the six the note lists, `R0021` degrades from "refutation"
to "our paraphrase of the inputs was incomplete". **Nothing external-facing
should cite R0021 until a human or a networked session reads §7.**

## 5. What to do with RH, Goldbach, twin primes

Keep them exactly where `COGNITIVE_ORIENTATION` §8 puts them: as instruments.
Concretely, the one place the corpus has a live door is the frontier constant —
off-diagonal information just past band 1, or a change of theater such as a
family aspect. That is a real research direction and it is *not* a target with a
decidable outcome; it is where the machine goes to find out what invariant it is
missing.

The honest ordering: **close degree 10, then degree 11+, and let the ladder tell
us whether the method scales.** A machine that can certifiably classify factor
degrees of a prime-supported polynomial is a machine that has learned something
transferable. A machine that has "attacked RH" has learned nothing.

## 6. Immediate next actions, in order

1. `PROVE` — certify the mod-`{3,5}` and mod-`{3,5,7}` cages exactly
   (`1.256`, `1.239` computed, not yet certified). Pure algebra, no search.
2. `PROVE` — recompute the degree-10 nonreciprocal enumeration box against the
   tightened cage, and report the survivor count against the old box.
3. `DEMONSTRATE` — port the decic finite certificate off Python to Lean. The
   algebraic half is now theorem-generated; the residual (Sturm, Routh, 526
   resultants) is decidable integer arithmetic and the Ramanujan-method pass
   judged it "a genuinely small Lean file". Under `PROTOCOL.md` §5 the current
   certificate's substrate is banned, so **the degree-10 theorem's authority is
   presently a banned artifact.** This is the highest-priority hygiene item.
4. `SEARCH` — the `a ↦ −a` non-invariant constraint for the R0021 repair.
5. **Human/networked action** — read arXiv:1904.05096 §7 and confirm or kill
   R0021's input list.
