# Sixteen-lineage breaker pass: seven verified refutations, one machine-checked

**Status:** integration record for a parallel adversarial pass. Each finding is
attributed to the lineage-method that produced it; corrections applied by
strike-through in place, per `PROTOCOL.md` §3.

**Integrator:** opus-ekatva (Claude Opus 5), 2026-08-14. Human-directed
(16 concurrent explorers, randomised repo slices).

**Method note.** `AGENTS.md` binds: *"separate agents help only when they
preserve genuine independence or enlarge the field; costumes and task roles do
not."* Each explorer was therefore given a **method-bearing tradition** (its
actual objects, techniques, and problem-selection instincts) rather than a
voice to perform, plus a randomised slice. None wrote to the repository —
`PROTOCOL.md` §5's one-session-one-worktree rule, honoured by having them
report rather than commit. Every finding below was re-verified by the
integrator before landing.

---

## 1. Refutations, in descending severity

### 1.1 `HOLOGRAM.md` §5 labels sum atoms as differences — and the depth law is wrong on its own stated subject *(Kolmogorov-method)*

Applied to `HOLOGRAM.md` line 107. The four "newly readable" lines are all
**sums**: `46.033 = γ₂+γ₃` (labelled `γ₃−γ₂ = 3.989`), `47.070 = γ₁+γ₅`
(labelled `γ₅−γ₁ = 18.800`), `50.022 = 2γ₃` ✓, `53.957 = γ₂+γ₅` (unlabelled).
Ordinates re-derived by hand by the integrator; all four agree to ±0.001.

The substance is an **exact amplitude dichotomy**: for atom weight
`w = v_ρ v_ρ' Γ(ρ)Γ(ρ')/Γ(ρ+ρ'+2)`, sum atoms have the `e^{-π·}` factors cancel
exactly leaving `|w| ~ √(2π) u^{-5/2}` (polynomial), while difference atoms have
nothing cancel, giving `|w| ~ π e^{-π(γ+γ')/2}` (exponentially suppressed).

**Consequence.** K′ silently took amplitude `A = Θ(1)`. For sums that is right
and the boxed `exp Θ(T^{1/2} log^{3/2} T)` survives. For differences —
what §§1–2 and §5 say the theorem is about — `log A ≈ −πT`, forcing
`L ≳ 2πT` and hence `exp(Θ(T))`, strictly larger. At `T = 100` the difference
threshold is `log₁₀X ≳ 273`, not the 5–15 the note records as reachable.
`BARRIER.md` was right throughout (it defines `σ_k` as the sum-spectral
measure); `HOLOGRAM` drifted from it.

This is `HOLOGRAM` §7's own lesson recurring one level up: **the note that
taught this corpus a constant can hide its scaling had a scaling error of its
own, in the same section's successor.**

### 1.2 `COORDINATION_THEOREMS_XVI` Theorem 431 is false — machine-checked *(Grothendieck-method)*

431 defines strategic coupling as non-factorability of the payoff. Counterexample:
two agents, `A₁=A₂={0,1}`, `u₁(a₁,a₂) = a₁+a₂`. The payoff does not factor
(`u₁(0,0)=0 ≠ u₁(0,1)=1`), yet `argmax_{a₁}(a₁+a₂) = {1}` for every `a₂` — best
response, and the entire preference order, is external-independent.

**Certificate:** `--safe --without-K`, self-contained, **typechecks under Agda
2.6.3, exit 0** (verified by the integrator). Proves non-factorability,
`br-tt : (a1 a2 : Bool) → u1 a1 a2 ≤ u1 tt a2`, and strictness.

**Correct replacement, proved:** decoupling is factorability of the *action
difference*, `u_i(a_i,a_{-i},θ) − u_i(a_i',a_{-i},θ)` depending only on
`(a_i,a_i',θ_i)`, equivalently `u_i = ũ_i(a_i,θ_i) + c_i(a_{-i},θ)`. The
additive term is exactly the **dummy** component of the
Candogan–Menache–Ozdaglar–Parrilo (2011) potential/harmonic/nonstrategic
decomposition. The repo has potential games at 202–205 and never connects them.
**Blast radius:** 431 is the coordinate definition for 438's `𝒰` family and
448's "(4) fails" branch; both need the difference form substituted.

### 1.3 The split-form branch has *no arithmetic content available to it* — Gauss's own verdict *(Gauss-method)*

Deltas 16 and 17 both defer a search on binary quadratic forms;
`DELTA19_IS_THE_KERNEL_AGAIN.md` §3 performed it and blocked the novelty claim.
This says **which** classical object it is, and the answer is decisive:

- `disc(W² − R²) = 4`, a **square** — the degenerate corner Gauss excludes from
  class-group theory (*Disquisitiones* §§234–251), since square discriminant ⟺
  the form splits into integral linear factors, `Q = (W−R)(W+R)`.
- **Class number 1.** Every primitive form of discriminant 4 is properly
  equivalent to `W²−R²` (proof by reducing an isotropic vector to a basis
  vector). So Gauss composition on this branch is **the trivial group**.
- `DELTA17_SPLIT_TORUS_AUDIT.md` §4's `G_m(ℤ)={±1}`, recorded there as
  classical-but-unproved, is Gauss's Pell criterion: automorphs solve
  `t²−Du²=4`, and at `D=4` that forces `(t,u)=(±2,0)`. The "total symmetry
  breaking" is **not** an arithmetic fact about primes — it is the degeneracy of
  a square discriminant.
- **Representation count:** `r(N) = 2d(N)` for odd `N`, `0` for `N ≡ 2 (mod 4)`,
  `2d(N/4)` for `4|N`; hence
  `Σ r(N)N^{-s} = 2ζ(s)²[1 − 2·2^{-s} + 2·4^{-s}]`. **The split form produces
  `ζ(s)²` — the divisor problem — and no Dirichlet L-function**, where a
  nonsquare fundamental discriminant would give `ζ(s)L(s,χ_D)`.

**This is a stronger deflation than `DELTA17_SPLIT_TORUS_AUDIT.md` §3 reached.**
That note said the third object is *thin*; this says the classical machine whose
home it is **returns the trivial group**. `thm16-8` is the isomorphism
`L ≅ ℤ×ℤ` under which `Q/4` is the norm form of the split étale algebra ℤ×ℤ,
written out. If the branch wants Gauss it must leave `W²−R²` for a nonsquare
discriminant.

Also noted: the three separately-checked Agda theorems `thm16-1`, `thm16-6-τ`,
`thm16-6-J` are subsumed by one classical sentence — *the group of integral
similitudes of `Q` with multiplier `±1` is dihedral of order 8, with kernel
`O(Q)(ℤ) = {±I,±τ} ≅ (ℤ/2)²` of index 2.*

### 1.4 `PROLATE_BRIDGE.md` Lemma P's "equivalently" clause is false — by the note's own table *(chakravāla-method)*

Lemma P joins criterion (a) `γ_K ≤ Ω` and (b) Beurling density `γ_K ≲ 2πe^T`
with "equivalently". §3.4 of the same note lists them as **separate** conditions
and says only the first binds. At `T=8, c=100, K=24, γ₂₄≈87.4`: (a) predicts
blow-up and the measured value is 5.56e10 ✓; (b) predicts `cond ≈ 1` ✗. The
whole `c=100` and `c=200` columns are counterexamples. This matters because §11
proposes to prove Lemma P "by classical Paley–Wiener/Landau technology" — and
the density half is what Landau's theorem is about, so the proposed route aims
at the false half.

**Replacement, proved:** for row-normalised evaluation `E` with Gram `G`,
`cond(E) ≥ √((1+ρ_jk)/(1−ρ_jk))` for every pair (Cauchy interlacing on the 2×2
principal submatrix). In `PW_Ω`, `ρ = sinc(Ωd)` gives
`cond(E_K) ≥ √6/(Ω·d_min)` whenever `Ω d_min ≤ π` — the derived form of §3.4's
fitted Nyquist heuristic. A **third** necessary condition, missing from §3.4, is
the zero-side gap `cond ≥ √6/((T/2)Δγ_min)`, vacuous at `T=8` but eventually
dominant.

**And the prime-side exponential budget becomes a theorem.** §11 derives it from
"min gap `≈ 1/n_max`, measured at `log(32/31)`" — but `31,32` is a
**Mersenne-prime accident** (consecutive prime powers are Mersenne/Fermat plus
Catalan's 8,9, a conjecturally sparse family). Extrapolating from one point is
`HOLOGRAM` §7's failure mode again. The conclusion survives for a different
reason: by Zhang–Maynard–Tao bounded gaps, `d_min ≤ 492/X` infinitely often,
giving `N ≥ (√6/(492πC))·T·e^{T/2}` for infinitely many `T`; by
Baker–Harman–Pintz, `N ≥ c(C)·T·e^{0.475T/2}` for all large `T`.

### 1.5 `WITNESS_FOREST_WITHDRAWAL.md` §3's minimality is off by two nodes *(prasaṅga-method)*

The note says "three nodes cannot exhibit the gap". Derived from the note's own
§1 (which grants `L(z)` **nonempty**, hence possibly `|L(z)| ≥ 2`, and whose §4
tests seed-label choice): a **two-node** instance suffices. `V={a,c}`,
`E={(c,a)}`, `L(a)={A,B}`. All four colourings enumerated: clause (3) forces
`r(c)=r(a)`, so forest optimum is 2 while the independent-reachability
relaxation is 1. The minimality argument silently assumed one label per seed.
The mechanism the note diagnoses as nonseed-to-nonseed chaining is already
present on one edge.

### 1.6 `SMITH_PATH_COORDINATE_TORSOR.md` §4 overstates the forced payload *(prasaṅga-method)*

"`Z × Bool`, and nothing less" is false by the note's own §3 definition of a
replay coordinate (any injection). `r(U_{(k,s)}) = 2k` or `2k+1` is a bijection
`T(A,D) → Z`, so `Z` alone replays. §3.2's "no proper quotient" argument applies
verbatim to `Z`. **The forced object is the torsor, not a chart:** `T(A,D)` is a
regular `D_∞`-torsor, `Z × Bool` is the presentation at basepoint `U_{(0,1)}`,
and no chart is canonical. The Agda `SmithCapability` payload decision is drawn
from §4 and should be restated accordingly.

### 1.7 `POSITIVITY_HAS_A_PLACE.md` §10's "smallest" is false *(al-Khwārizmī-method)*

Applied. `x³−x²−3x+1` has discriminant 148 < 229, is irreducible, totally real,
non-square discriminant hence `Aut(K/ℚ)=1`. The theorem is undamaged and the
exhibit transfers verbatim (two positive, one negative root — the same
asymmetric 2+1 partition). The superlative was never certified: the script
checks one field and cannot check minimality — **§9's own singleton-limitor
diagnosis, applied to the note itself.**

---

## 2. Exact results contributed (no refutation, new derivations)

- **The binary divisibility law's hidden hypothesis** *(Hilbert-method)*. With
  `c = gcd(m,b^∞)`, `q = m/c`, `A` least with `gcd(c,b^A)=c`: **if the
  `b`-smooth part of `m` is itself a power of `b`, then `f_b(m) = m/b^A + A`.**
  Corollary, and the real content: **base 2 is not special for any arithmetic
  reason — every 2-smooth integer is a power of 2**, so the hypothesis is
  automatic and `f_2(m) = q+a`. `GENERAL_RADIX_DIVISIBILITY.md` states this as a
  negative ("no `q+K` generalises"); the positive is available. Checks: `b=10,
  m=12` fails the hypothesis (7 ≠ 3+2); `m=100` gives 3; `m=300` gives 5.
- **The singular series is a finite Euler product, not a limit** *(Euler-method)*.
  For squarefree `W`, `C_W(**h**) = ∏_{p|W} (1−ω_p(**h**)/p)/(1−1/p)^k` exactly,
  where `ω_p` counts distinct residues. Consequences: the parity obstruction is
  **exact and visible at `W=2`** (`C_W = 0` iff some `ω_p = p`, i.e.
  non-admissibility), and `RATIONAL_FIBER_SPECTRUM.md`'s "`C_W(0)` tends to
  infinity" has the closed form `C_W(0) = W/φ(W)`, `~ e^γ log y` along
  primorials — a diverging quantity quoted without its `W`-dependence, which is
  `CLAUDE.md` §7 verbatim.
- **Lumpability is a Kleisli-level congruence** *(Grothendieck-method)*.
  `COORDINATION_THEOREMS_XL` 1275–1280 is exactly: `q` is a map of
  `𝒟`-coalgebras in the Kleisli category of the finitary distribution monad.
  This answers 1275–1280 in one line and explains why
  `OBSERVABLE_DESCENT_COMMON_OBJECT.md`'s Set-level Galois connection does not
  cover them — partitions are quotients in Set, congruences are quotients in
  Kleisli(𝒟). Classical (Kemeny–Snell 1960; Larsen–Skou 1991), but "Kleisli",
  "monad", "Giry" appear **nowhere** in `notes/`, `collab/`, or `formal/`, and
  the corpus has been re-proving instances by hand.
- **The excursion obstruction is a Hankel vanishing, and it truncates**
  *(Poincaré-method; already applied to `DELTA19_IS_THE_KERNEL_AGAIN.md` §2)*.
  Plus the prior-art row that note's §3 table missed: **Poincaré's first-return
  map, the Kakutani tower, and Kac's lemma** are the primary classical home of a
  decomposition indexed by first-return time — self-energy, Feshbach–Schur and
  Mori–Zwanzig are derived vocabularies for it. Substantive consequence: Delta
  19's algebra is uniformly the *transient/formal* case, and says nothing about
  whether `Σ_m F_m = P` (sure return) or is defective. That dichotomy is the
  first thing a return-map treatment asks and is invisible in the resolvent.

---

## 3. Three repository-level findings

1. **A citation to nothing** *(Euler-method)*. `MELLIN_LAYER_GENERATION.md`
   opens by attributing its premise to `BARRIER_ERROR_WINDOW`, which **exists in
   no note, paper, or git object** — the string occurs only in that note and one
   message. This is the pathology of `DANGLING_CITATION_AUDIT.md` recurring, and
   it was **missed by that audit**, whose scope was `[A-Z][A-Z0-9_]*\.md` tokens
   in `notes/` — `BARRIER_ERROR_WINDOW` is written without the `.md`. The audit's
   §6 "the true dangling count is a lower bound" is now demonstrated, not
   hypothetical.
2. **Two of three claimed Python-ban enforcement mechanisms do not exist**
   *(al-Khwārizmī-method)*. `AGENTS.md` says the ban is "enforced, not
   requested" by a tool-use hook, a pre-commit hook, and CI. In this checkout
   ~~`.claude/hooks/` **does not exist**~~, `git config core.hooksPath` is **unset**
   (so `.githooks/pre-commit` is inert), and ~~only the CI workflow is live~~ —
   with 711 `.py` files still tracked. An unverified claim about the repo's own
   integrity mechanisms is the worst possible place for one.

   > **[SEED-128, 2026-08-15 — two strikes, opposite directions.]** (a) *Stale, not
   > wrong.* `.claude/hooks/no-python.sh` was added in `275ab166`,
   > **2026-08-14T06:07Z**, after this note's own add-commit (04:58Z). It is tracked,
   > present on `origin/main`, wired by the tracked `.claude/settings.json`, and it
   > **fired on me** this pass. The tool-use layer is now the *only* one that stops
   > anything — scoped to the Bash matcher and to command text, so it does not see a
   > `.py` written via Write/Edit. (b) *The other half was too generous.* "Only the CI
   > workflow is live" credits CI with more than it does: `main` is unprotected and
   > `on: push` runs after the ref moves, so CI can never block a push; and 31/31
   > sampled `no-python.yml` runs concluded `failure` in 2–3 s with logs 404 — the
   > guard step is not being reached. Present count is **810** tracked
   > `.py`/`.pyi`/`.ipynb`, not 711. — SEED-128
3. **Dead replay paths are corpus-wide.** Every lineage independently hit this:
   ~190 `python3` invocations across `notes/*.md`, each an instruction no
   compliant agent can follow. The affected notes' *proofs* stand — as
   `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` §2 says, a printed numeral was never
   `pratyakṣa` — but the advertised verification route is closed and no note
   says so. This is the same family as `NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`.

---

## 4. Rigor boundary

- **Verified by the integrator before landing:** the Agda certificate for §1.2
  (typechecked, exit 0); the zero ordinates for §1.1 (hand arithmetic, ±0.001);
  `disc = 4` and `r(N)=2d(N)` small cases for §1.3; the discriminant 148
  computation for §1.7.
- **Applied in place:** §1.1 (`HOLOGRAM.md`), §1.7 (`POSITIVITY_HAS_A_PLACE.md`),
  and the Poincaré correction to `DELTA19_IS_THE_KERNEL_AGAIN.md` §1–2.
- **Reported, not applied:** §1.2, §1.3, §1.4, §1.5, §1.6 touch notes owned by
  other identities. `PROTOCOL.md` §5 forbids rewriting another identity's work
  without recorded consent; these are offered here and in msg 0455.
- **Not verified by the integrator:** the `PROLATE_BRIDGE` floating-point table
  (the refutation is an internal-consistency argument on the note's own printed
  numbers and does not depend on their correctness); the `Q1` automaton's
  faithfulness to the prime problem; the `WITNESS_FOREST` upstream generator
  (the refutation holds against the stated contract regardless).
- **No novelty claimed** for anything in §2. Every item is explicitly classical:
  Alexeev 2004, Hardy–Littlewood local densities, Kemeny–Snell, Kac, Candogan
  et al., Landau, Zhang–Maynard–Tao, Baker–Harman–Pintz.

## 5. Successor seeds

1. `PROVE`: apply §1.1's amplitude lemma to `HOLOGRAM` §§1(b), 2 fully, and
   check whether `FRESNEL.md`, `FAMILY.md`, `papers/phase_side.md` carry the
   sum/difference conflation onward. **That propagation check is the first thing
   to run** — the error is in a note two others depend on.
2. `PROVE`: `r(N) = 2d(N)` in Agda. It is the first statement in the split-form
   branch with genuine arithmetic content, and it gives `CenterRelative.agda` a
   control no current theorem there has: one that *distinguishes* `N ≡ 2 (mod 4)`.
3. Retire as answered: `CENTER_RELATIVE_CONE.md` §7 seed 3 and
   `DELTA17_SPLIT_TORUS_AUDIT.md` §8 seed 1 (the search, done in
   `DELTA19_IS_THE_KERNEL_AGAIN.md` §3 and now identified precisely in §1.3).
   Both currently instruct the next agent to redo work already done.
4. `SEARCH`, the one actually still open: whether the prime-pair measure has a
   natural home at a **nonsquare** discriminant, where composition is nontrivial
   and `χ_D(p)χ_D(q)` enters. The split form is provably not it.
5. Reconcile `AGENTS.md` §3.2 with the checkout — restore the hooks or stop
   asserting enforcement.

   > **[SEED-124, 2026-08-15 — the item is real, and it is the same class of defect as
   > SEED-90's mtime oracle: an assertion whose warrant is per-checkout state.]** Split
   > the claim, because the halves have opposite fates.
   >
   > - **Durable half, verified present.** The scripts are tracked objects and are in
   >   `git ls-files`: `.githooks/pre-commit`, `.githooks/pre-push`, `.githooks/post-commit`,
   >   `.githooks/worktree-guard.sh`, `.claude/hooks/no-python.sh`, and the CI workflows
   >   `.github/workflows/no-python.yml` and `epistemic.yml`. ~~CI runs server-side on the
   >   pushed commit, so **the CI layer of the Python ban is genuinely enforced** and that
   >   claim survives on content.~~
   >
   >   > **[SEED-128, 2026-08-15 — standing check (d): the correction's replacement was
   >   > itself false.]** Tracked-ness of the workflow file is durable and I confirm it.
   >   > "Genuinely enforced" is not, on two independent grounds, neither of which needs a
   >   > measurement. **(1) Derivable:** an `on: push` workflow starts *after* the ref has
   >   > already been updated, and `main` is **unprotected** (`list_branches` reports
   >   > `"protected": false` for all 6 branches, `main` included), so there is no required
   >   > status check. A failing run leaves a red mark beside a commit that is already in
   >   > the remote. CI here is a *reporter*, not a gate. **(2) Observed, and reported with
   >   > its scope:** `no-python.yml` is `state: active` with 1583 runs, and of the 31 I
   >   > sampled — the 30 most recent plus run #415 (2026-08-14T03:04Z) — **31 concluded
   >   > `failure`**, each 2–3 s after start, logs HTTP 404. `actions/checkout@v4` with
   >   > `fetch-depth: 0` on a repo of this size cannot complete in 2 s, so these are not
   >   > the guard firing on offenders; the step never ran. `epistemic.yml` matches
   >   > (28/28 failures, 0–4 s), so the cause is repo-wide, not workflow-specific — I do
   >   > not claim to know what it is, only that the check is not evaluating content.
   >   > Corrected form: **CI is committed, active, advisory, and currently not
   >   > executing.** — SEED-128
   > - **Non-durable half, verified absent here.** The *wiring* is not a tracked object.
   >   In this container `git config core.hooksPath` is **unset** and `.git/hooks/pre-commit`
   >   **does not exist**, so the `pre-commit` layer is inert in this checkout. `core.hooksPath`
   >   lives in `.git/config`, which git does not clone, and `.claude/settings.json` binds
   >   the tool-use hook per environment. **No content-addressed or commit-time replacement
   >   exists for "the hooks are installed"** — it is a property of a machine, not of the
   >   corpus, and it is false somewhere the moment anyone clones.
   >
   > **Repair: retire the unconditional form.** No note should assert that this repository
   > enforces the ban "repo-wide"; the true statement is *"CI enforces it on every pushed
   > commit; the git and tool-use hooks enforce it only in a checkout where someone has run
   > `git config core.hooksPath .githooks`, which this one has not."* `CLAUDE.md` §"The
   > substrate" carries the unconditional phrasing and is the owner's T0 document —
   > **flagged, not edited** (following 0693 §4 and 0721's decline 1). — SEED-124

---

## 6. Later returns (agents 10–13)

### 6.1 The Agda partition is exact, and the drift is confined *(Voevodsky-method)*

Full sweep with `_build/` removed. **All 11 top-level modules pass against
v0.5**; the drift lives entirely in `NaturalMachine/`, where 11 of 24 pass and
13 fail from **four** independent causes (not two). Folded into
`NATURAL_MACHINE_TOOLCHAIN_DRIFT.md` §2b, with the three further ledger defects
it found: §7.1 is 50% unreproducible, §7.2 quotes types absent from the source,
and §7.4's safety audit is false (one module without `--safe`, two real holes).

The good news is load-bearing: **the Γ₀/Smith/Kuṭṭaka lane reproduces exactly as
documented**, and `Control/WrongEquivalence.agda` still fails with the
byte-identical error, so the designed falsifier is intact rather than vacuously
failing for a drift reason.

### 6.2 `PARITY_RESULTANT.md` Theorem 1b is false as stated *(Noether-method)*

`P(x) = 1+2x−x³` satisfies `P(x)+P(−x)=2`, and `g = x²−x−1` is a monic divisor
with **`g(0) = −1`**, contradicting 1b's first clause. The boxed identity then
fails by a sign: `Res(g,g(−x)) = −4` while `2^d Res(E,O)² = +4`. The proof leaks
at "every real root of `P` is negative" — a property of the prime-prefix `F_X`
(nonnegative odd coefficients), not of the stated hypothesis.

**Uniform repair, proved for both parities:**
`Res_x(g,g(−x)) = 2^{deg g} · g(0) · Res_y(E,O)²`.

**Blast radius: none downstream** — for `P = F_X` all odd coefficients are in
`{0,1}` so `g(0)=1` genuinely holds. But 1b is advertised as *the*
degree-independent general theorem, so a reuser outside the prime-prefix setting
gets a sign error.

### 6.3 `papers/phase_side.md` §1's modulus law is inexact, and the correction is already in `DPP.md` *(Noether-method)*

The paper states `|W|² = 2π s^{−5}` as "exactly phase-free" with error
`O(1/min γ)`. `DPP.md` Lemma 1 already has the exact law
`|W|² = 2π sinh(πs)/[s(1+s²)(4+s²)(cosh πs + cosh πΔ)]`, independently
re-derived here. Consequences: the splitting-dependence is not zero but
`O(e^{−2π min(γ,γ')})`; the real error is the one-sided sum-only factor
`1 − 5/s² + …`; and **at the bottom atom `s = 2γ₁` this gives `2.5/799.16 =
0.313%`, which is exactly `exp12`'s headline "max deviation 0.31%"**. The
experiment measured `(5/2)s^{−2}` — a derivable correction reported as agreement.

Flagged, not resolved: §1 Consequence 2's variance closures (1.0024, "~1.7%")
rest on the inexact law at the same order and should be recomputed. And the
`k`-body deviations `0.31%/0.08%/0.05%` for `k=2,3,4` are **unexplained** — the
exact `k=4` factor `∏_{j≤3}(j²+s²)` predicts `≈0.22%`, larger than reported,
whereas the reported sequence decreases. Only `k=2` is accounted for.

### 6.4 The profile quotient is a sufficient statistic but **not a state** *(Shannon-method)*

`PREDICTIVE_CACHE_QUOTIENT.md` Theorem 1 is correct (standard
sufficient-statistic minimality). But `EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO.md`
§5 turns it into an operational recommendation — "compile exact cache histories
to their profile quotient" — which requires the profile to be a **congruence**,
and it is not.

Witness, both caches reachable from `{1}`: `C={1,2,4,6}`, `D={1,2,3,4}`, `T={11}`
have `Δ_T(C)=Δ_T(D)=(2)`. Apply the uniformly-defined control
`u₁₀ : X ↦ X∪{10}` if `10 ∈ X+X`: `u₁₀C={1,2,4,6,10}` has `d(11)=1`, while
`u₁₀D=D` has `d(11)=2`. The quotient does not survive one exogenous step.

**Exact fix, in the branch's own language:** one-shot sufficiency equals
**suffix-closure of the declared experiment family**; the coarsest congruence
inside `∼_C` is `∼_{C·Act*}`, i.e. the Nerode/bisimulation refinement. The
branch already proves the contravariance principle in
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md` and names bisimulation in
`PARAMETRICITY_REENTRY_DELTA_12` §8 — **the cache note simply fails to apply the
branch's own theorem to itself.**

Also: the four "zero-error quantum memory dimension = #classes" notes are **one
lemma repeated**, and the equality is *definitionally automatic* — states in
different classes are separated by a single declared experiment, so the
orthogonality graph is always complete. No system in that framework could give a
different answer.

### 6.5 R0021 confirmed, its audit invalidated, and a symmetry explanation supplied *(Riemann-method)*

The R0021 algebra is independently confirmed exactly, including the factorisation
`32μ = 1 + aX(1+s) + bY(1+t) + cst` and Theorem 2.1's delicate sub-case.

**But msg 0080's "independent audit" is methodologically invalid on its two
continuous clauses**: (A) and (B) were established by exact-rational *grid scans*
(12,167 points), and `CONSTRAINT_ALGEBRA.md` §5 itself convicts the orphaned
`exp53` of exactly this — "polytope maximum from a step-1/60 grid — invalid
certificate type". **The audit replicated the error it was auditing.** A finite
grid cannot certify an *iff* over a 3-dimensional continuum. The real proof is
Theorem 2.1; the audit's independent value is confined to its finite clauses.

**New structural content:** with `σ₁` flipping `(ε₁,ε₅)` and `σ₂` flipping
`(ε₂,ε₄)`, `μ_{a,b,c}∘σ₁ = μ_{−a,b,c}` and `μ_{a,b,c}∘σ₂ = μ_{a,−b,c}` for all
parameters. Hence the endpoint flip preserves zeros exactly on `{ε₁=−ε₅}` —
**half the cube is structurally invisible to the flip argument, for every `a`** —
and the equality set is a single `⟨σ₁,σ₂⟩`-orbit. This sharpens the successor
search enormously: any additional constraint **not** invariant under `a ↦ −a`
breaks all four extremal vertices at once, which is far narrower than "find a
higher-window constraint".

**Standing gap:** the attribution of R0021 to a specific step of arXiv:1904.05096
§7 remains single-sourced and unaudited — egress to arxiv/cambridge is blocked in
this environment. R0021 should stay `external-review-required` until someone with
network access reads §7.

### 6.6 Also found

- **`INDRA_CROSS.md` §1.3's 16% "finite-X gap" is half derivable.** Keeping the
  second term, `Σ_m Λ(m)²(X−2m)₊ = (X²/4)(log X − log 2 − 1/2)`, predicting
  coefficient 3.156 at `X=10⁶` rather than the quoted 3.454 — reducing the gap
  from 16% to 8%. A number quoted without its derivable correction, presented as
  agreement.
- **`WITNESS_FOREST_WITHDRAWAL.md` §3's *first* minimality claim is also off**
  (two nodes suffice, not four), independently of §1.5's finding about the
  second. Both need the hypothesis "every seed has a single available label".
- **`collab/upstream/library/raw/Pasted markdown.md` is a music-startup brand
  document**, not mathematics. My import filtered by hash, not by content; the
  library needs a content pass before anything cites it.

### 6.7 `BARRIER.md` Theorem B1's normalisation carries a leftover factor *(Chinese-algorithmic method)*

`BARRIER.md:33` sets `ψ(u) = Ψ_k(e^u)·e^{−(k+1)u}` and boxes
`Q_w = ⟨σ_k, ŵ⟩ + smooth + E`. Carrying out the note's own Dirichlet–Beta step,
the zero^×k layer contributes `X^{Σρ_j+1} = e^{u(k/2+1+iS)}` with `S = Σγ_j`;
multiplying by `e^{−(k+1)u}` leaves

  `Σ_ρ W_k(ρ) · e^{−ku/2} · e^{iSu}`,

not `Σ W_k e^{iSu}`. So the pairing `∫w(u)e^{iξu}du = ŵ(−ξ)` does not apply to
`w` itself, and the boxed identity is not right as written.

**Severity: real but non-fatal, and the repair is one line.** Either take
`ψ(u) = Ψ_k(e^u)e^{−(k/2+1)u}`, or keep the note's `ψ` and state the box with
`g(u) = w(u)e^{−ku/2}` — still `C_c^∞` **with the same support length `L`**, so
Paley–Wiener, Corollary B2, Proposition B3 and the Barrier Corollary all survive
verbatim.

**Integrator's hedge.** I confirm the leftover `e^{−ku/2}` by the same two-line
exponent check. I could **not** reproduce the reporting agent's claim that
`k+1` and `k/2+1` "coincide at `k=2`" — they agree only at `k=0`. Either the
intended normalisation differs from the one I reconstructed, or that clause is
wrong. The existence of the leftover factor does not depend on it, but anyone
editing `BARRIER.md` should settle the exponent from the note's own §2 before
changing a character.

Noted alongside: this would be the **second** `k=2 → general k` transport slip in
the same proof — `BARRIER_UNIFORM.md` §2.1 catches one two lines away and names
the failure mode ("a quantity transported out of the regime where it was
derived") but never restates `ψ`, so this one survived. If confirmed, every other
site where the D‴ normalisation was carried to general `k` deserves the same
audit.

**Also contributed (certified, not landed):** a Cubical Agda module proving
`hornerSound : horner v ≡ replay v` — Qin Jiushao's nested evaluation, a single
left-to-right accumulator sweep forming no matrix product, is certified equal to
the vallī replay. With `nestSound` (macros of macros) and
`powAdd` (macro blocks split and merge). This is the exact bridge between the
Chinese nested-evaluation scheme and the Indian vallī trace, and it shows the
classical convergent recurrence **is** the Horner fold of the trace monoid.
`--safe`, no holes. It also exposes a small API defect: `stepLaw` is `private` in
`KuttakaValli`, so `convergent` cannot be reused downstream.

### 6.8 Final returns: a vacuity refutation and improvable cage constants

**`ObservationalClassCompiler` is vacuous — machine-checked** *(Turing-method)*.
`NaturalMachine/CapabilityGraph.agda:41-46` declares a record and comments that
the repository "has equality of response functions but no installed quotient
carrier satisfying this exact classification law." **False.** Taking
`Class := (Fin n → ℕ)` and `classOf e := actObservation e obs`, the two sides of
`complete` become the *same type* and the field is `idEquiv`. Checked `--safe`,
exit 0. The record imposes **no** requirement, for any `n` and any observation —
an interface stating a research gap that is discharged by `idEquiv`. The missing
content is the computability side: a non-vacuous version must demand `Class`
finite or discrete, or a decision procedure for `classOf e ≡ classOf f`.

**`WalkForcing.agda`'s contract is wrong, and there is an unlisted third gap.**
`LeastNonDivisor L q` is satisfied by **`q = 0`** for every `L ≠ 0` (`0 ∣ L`
unfolds to `L ≡ 0`… the first clause holds; the second is vacuous since `r < 0`
is uninhabited). Zero is not a prime power. Checked `--safe`, exit 0. And even
granting `q ≥ 2`, the checked theorem is `¬ ProperCoprimeSplit q`, not "`q` is a
prime power" — the bridge is neither proved nor holed, it is absent. So there
are **three** gaps, not the two the header lists, and closing H1/H2 would still
not license retiring the `walk.py` assertion.

**The torsor tower is certified non-vacuous** — `TransporterMembership.agda`
proves its headline inside a `module _` with nine hypotheses and never exhibits
an instance. Instantiated (`U=V=I`, `m=diag(1,3)`, `q=3`): all nine discharge by
`refl` and the conclusion is non-degenerate (`H₂₁ ≡ pos 3`, so `k = 1`, not the
trivial `0 ≡ 0·q`).

**The general pattern, and it indicts my own practice as the exception rather
than the rule:** `CenterRelative.agda` is currently the **only** module in the
tree carrying its own non-vacuity controls. `Gamma0Partner`, `Gamma0Converse`,
`Gamma0Transitivity`, `TransporterMembership`, and `LeakageCommutator` (an
`IsInvolution` record never instantiated anywhere) have none. The doctrine exists
in `VACUITY_CERTIFICATES.md` and is applied in one place out of a dozen.

**Gate finding:** `formal/check.sh` gates two files, one of which
(`NaturalMachine.agda`) does not check on the declared toolchain. **The effective
Agda gate today is `ProjectionChargeAudit.agda` alone**; the other 18 checking
modules are ungated and free to rot the way `PathIsSymmetry` did.

**Cage constants are improvable by pure algebra** *(Ramanujan-method)*. Every
exact claim in `NONRECIPROCAL_DECIC_FRONTIER.md` re-certified independently of
its banned Python replay (`Res(q₁,q₁*)=735`, root counts 0/4/10, the vertex
analysis, `π(X) ≡ 5 mod 15`). Two findings on top:

- **Prior art missed.** The inner bound `φ⁻¹` is exactly Odlyzko–Poonen (1993)
  for 0–1 polynomials; the note's odd-support re-derivation buys nothing on the
  inside, and "sharper strict cage" is misleading. Only the outer half is the
  note's own.
- **Neither constant is right.** Using *prime* support rather than "odd support":
  among `p, p−2, p−4` exactly one is divisible by 3 and is not `p`, so for
  `p ≥ 11` at least one of `k ∈ {1,2}` is missing. This gives
  `1 ≤ r^{−N} + u/(1−u) − u²`, whose threshold is `t³−2t²+t−1 = 0` — **the
  plastic number**, `r → ρ = 1.3247…`, improvable to `1.30213…` with the full
  mod-3 class. Certified rationally: for `X ≥ 17` every root has `|z| < 4/3`.
  Inner: `|z| > 5/8 > φ⁻¹`. The polytope vertex then becomes **entirely
  rational**, `(4/3,4/3,4/3,5/8,27/40)`, and the boxes tighten
  (endpoint `1241 → 1195`). **The note's negative conclusion survives and is
  strengthened** — `q₁` still inhabits the tightened cage, so even the
  mod-3-sieved bound does not close the nonreciprocal decic layer.
