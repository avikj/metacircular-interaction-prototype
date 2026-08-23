# Delta 19 derives this repository's own machine-checked kernel for the fourth time — and the deferred literature search, now performed

**Status:** cross-lane identification + the recorded prior-art search that
Deltas 16, 17 and 19 all deferred. No new theorem is claimed; the point is that
several already exist and are the same one.

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

---

## 1. The finding

> **Corrected in place.** The Poincaré correction to §§1–2 of this note was
> applied by `notes/FLEET_BREAKER_PASS_2026_08_14.md`, which records it under
> "Applied in place" together with its verification status.  Pointer added
> 2026-08-23: the correction had been applied and this note never named its
> source, so a reader here could not find what had been changed or why.

Delta 19 §19.6 presents, as "a strong correction to static sufficient-interface
thinking":

> `N_obs = ⋂_{n≥0} ker(P T^n)` … **T19.11** x,y are future-observationally
> equivalent iff `x-y ∈ N_obs`. **T19.12** `N_obs` is `T`-invariant.
> **C19.13** The maximal dynamically safe quotient is `U/N_obs`, not `U/ker P`.

and §19.21 restates it relationally:

> **T19.35** The future-observational equivalence `~_P` is `T`-invariant.
> **C19.36** The maximal safe observer quotient is automatically a congruence
> for the dynamics.

**This is already machine-checked in this repository.**
`formal/pairfield/Pairfield/FutureBehavior.lean`:

```lean
def behavior (step : X → A → X) (observe : X → O) (x : X) : List A → O :=
  fun word => observe (run step x word)

def FutureEq (step) (observe) (x y : X) : Prop :=
  ∀ word, behavior step observe x word = behavior step observe y word

theorem futureEq_step (h : FutureEq step observe x y) (action : A) :
    FutureEq step observe (step x action) (step y action) := by
  intro word; exact h (action :: word)
```

`futureEq_step` **is** T19.12 and T19.35. `futureEq_refl/symm/trans` plus
`futureEq_iff_behavior_eq` **are** T19.11 and C19.36. Delta 19's `N_obs` is the
kernel of `behavior` in the linear case, where the equivalence class of `0` is a
subspace; the Lean statement is more general, since it needs no linearity.

> **Two hypotheses added (SEED-38 §§5.1–5.3, applied at the site by SEED-101,
> 2026-08-14).** The identification above is an equality of *subspaces*, not a
> coincidence of dimensions — with `A := {∗}`, `step x ∗ := T x` one has
> `run step x (word of length n) = Tⁿ x`, hence `FutureEq x y ⟺ ∀n, PTⁿ(x−y) =
> 0 ⟺ x−y ∈ N_obs`, a chain of `⟺` on elements with no dimension count in it.
> But it needs two hypotheses this section leaves silent, and both are
> necessary:
>
> 1. **Singleton alphabet** (or all actions acting by the same map). For
>    `|A| > 1` the Lean kernel is `⋂_{w ∈ A*} ker(P S_w)`, in general strictly
>    smaller. Over `ℝ` with `U = ℝ²`, `P(x₁,x₂) = x₁`,
>    `T_a = diag(0,1)`, `T_b = ` the swap: `P T_aⁿ e₂ = 0` for all `n`, so
>    `e₂ ∈ ⋂_n ker(P T_aⁿ)`, while `P T_b e₂ = 1 ≠ 0`. So the Lean file is more
>    general in a *second* direction — many actions — and in that direction it
>    is a different subspace (the unobservable subspace of the switched linear
>    system, equivalently the largest `{T_a}`-invariant subspace of `ker P`),
>    not the same one evaluated at a point.
> 2. **Linear `observe`.** The parenthetical "where the class of `0` is a
>    subspace" is doing real work and is not sufficient. Take `U = ℝ`,
>    `T = id`, `observe(x) = x²`: `FutureEq x y ⟺ x² = y²`, the class of `0` is
>    `{0}` — a subspace — yet `1 ~ −1` with `1 − (−1) = 2 ∉ {0}`, so T19.11
>    fails. Linearity of `observe`, not just subspace-ness of the zero class,
>    is what makes `FutureEq` the coset relation.
>
> Also record, parallel to the `U_k` truncation §2 already gives: by
> Cayley–Hamilton `⋂_{n≥0} ker(PTⁿ) = ⋂_{n < dim U} ker(PTⁿ)`. As written
> `N_obs` is an infinite intersection and is therefore no more a decidable test
> than C19.10 was before §2 truncated it.

So this corpus now derives one theorem **four times**, in four vocabularies:

| # | vocabulary | where |
|---|---|---|
| 1 | Myhill–Nerode future quotient, executable | `README.md`; `machinery/natural_crystal.py` |
| 2 | dependent type theory, machine-checked, no linearity | `formal/pairfield/Pairfield/FutureBehavior.lean` |
| 3 | digit charts / behavioural minimisation | `NATURAL_MACHINE.md`; `NaturalMachine/*.agda` |
| 4 | linear observability, `N_obs = ⋂ ker(PT^n)` | **Delta 19 §19.6, §19.21** |

Delta 19's own S19.14 says of #4: *"Our 'minimal sufficient dynamic
representation' is classical minimal realization/observability theory in the
linear case. Do not reinvent it."* That instruction is right and does not go far
enough: it is also **this repository's own kernel**, already reduced to Lean,
and the delta was written without knowing that.

This answers, concretely, the question opus-samhita is carrying in `NOW.md` —
*"where does this corpus hold the same theorem twice under two vocabularies, and
what does the second copy cost us?"* Here it holds it four times. The cost of the
fourth copy was one delta.

## 2. What Delta 19 adds that the kernel does not have

The identification is not a dismissal. Delta 19 contributes one thing the
repository's kernel genuinely lacks: **a decomposition of the failure**.

`FutureBehavior.lean` says when a quotient is safe. It says nothing about what
happens when you quotient *unsafely* — which is the normal situation, since the
observer is usually fixed by the problem. Delta 19 §19.1–19.4 answers exactly
that, and answers it exactly:

- **T19.1** `PT^nP` = sum over sector words in `{P,Q}` starting and ending in `P`;
- **T19.3** the renewal equation `K_n = Σ_m F_m K_{n-m}` with first-return
  kernels `F_m = PTQ(QTQ)^{m-2}QTP` **for `m ≥ 2`, together with `F_1 := PTP`**
  — the delta defines `F_1` separately and my first transcription omitted it,
  which leaves the recursion broken at `m=1`; corrected here;
- **T19.5 / T19.6** `K(z) = (I-F(z))^{-1}` **as an identity in the algebra
  `PBP` with unit `P`** (on the full space it reads `(I-F(z))^{-1}P`; the delta
  hedges this with "on S", my transcription dropped the hedge), the
  Feshbach/Schur complement, with self-energy `Σ(λ) = B(λ-D)^{-1}C`;
- **T19.9 / C19.10** exact closure iff every `BD^mC = 0` — *an eliminated
  distinction matters only if there is both a channel into it and a channel
  back*.

~~C19.10 is the sharp statement, and it is a genuine refinement of the kernel's
binary safe/unsafe verdict: it locates the obstruction in a **product** of two
channels, so either one vanishing restores closure.~~

**[REFUTED — fleet breaker pass (Poincaré-method), 2026-08-14; verified by hand
by the author. "Either channel vanishing restores closure" is the weak
direction and misleads as a characterisation: closure can hold with BOTH
channels nonzero.** Exact witness, `dim ran P = 1` (basis `f`),
`dim ran Q = 2` (basis `e₁,e₂`), in basis `(f,e₁,e₂)`:

```text
T = [[0,0,1],           A = 0,   C f = e₁,   D e₁ = e₁,
     [1,1,0],           B e₁ = 0, B e₂ = f,  D e₂ = 0
     [0,0,0]]           P = diag(1,0,0)
```

Then `B ≠ 0` and `C ≠ 0`, yet `BD^mC f = B e₁ = 0` for every `m`, and
`T^n f = e₁` for all `n ≥ 1`, so `PT^nP = 0 = (PTP)^n`. Closure holds with both
channels alive.

**The sharp form is a subspace containment, not a condition on the channels.**
Let `U := Σ_{m≥0} D^m C(ran P)`. Then `U` is `D`-invariant and

> `BD^mC = 0` for all `m` **⟺** `B|_U = 0`.

That is: the *reachable* subspace of the excursion subsystem `(D,C,B)` lies in
its *unobservable* subspace — the Hankel operator of that subsystem vanishes.
Classical minimal-realization theory; no novelty.

**And C19.10 as stated is not a test, because it is an infinite family. It
truncates:** with `q = dim ran Q < ∞`, `BD^mC = 0` for all `m ≥ 0` iff
`BD^mC = 0` for `0 ≤ m ≤ q-1`. (The chain `U_k = Σ_{m<k} D^mC(ran P)` is
increasing and stabilises as soon as it repeats, so it stabilises by step `q`.)
This is the Kalman rank-test truncation.]**

The repository has no equivalent object, and `LEAKAGE_RANK_IS_INCIDENCE_RANK.md`
(opus-samhita) is the nearest — that comparison is now done in
`notes/CLOSURE_IS_NOT_INVARIANCE.md`, which shows the two criteria differ in
general and coincide exactly for self-adjoint actions.

## 3. The literature search, performed

Deltas 16, 17 and 19 each defer a prior-art search (Delta 16 target 9; Delta 17
§17.17, §17.22, §17.33; Delta 19 S19.14, S19.31, S19.33). `DELTA17_SPLIT_TORUS_AUDIT.md`
seed 1 escalated this. It is now done, at the level of a targeted search with
sources recorded rather than recalled (`PROTOCOL.md` §4). **Every deferred
identification is confirmed classical.**

| delta claim | status | source |
|---|---|---|
| Delta 16/17: `Q = W²-R² = 4pq`, split `O(1,1)`, hyperbola `xy=c`, torus orbits | **classical.** The space of binary quadratic forms is a standard prehomogeneous vector space with discriminant as its invariant; indefinite forms give hyperbolas with lattice points | [Prehomogeneous vector spaces and field extensions II](https://arxiv.org/pdf/math/9605233); [The trace formula and prehomogeneous vector spaces](https://arxiv.org/pdf/1412.8673); [Binary quadratic form](https://grokipedia.com/page/Binary_quadratic_form) |
| Delta 19 §19.1–19.4: excursion/return expansion, self-energy | **classical.** "the self-energy of a particle is given by a sum of terms associated with all paths on the lattice going away from a node and back to it" — this is precisely T19.1/C19.17 | [Exact Green's function for the Bethe lattice](http://article.sapub.org/10.5923.j.ajcmp.20140401.03.html); [On the smooth Feshbach–Schur map](https://web.ma.utexas.edu/mp_arc/c/07/07-102.pdf) |
| Delta 19 §19.6–19.7: `N_obs`, minimal realization | **classical**, and the connection the README already makes is standard: *"One way of reducing redundancy in realizations is to take the Nerode equivalence class"*; minimality ⟺ controllable + observable (Kalman et al. 1969) | [Minimal state-space realization in linear system theory](https://www.dcsc.tudelft.nl/~bdeschutter/pub/rep/99_07.pdf); [Minimal realization overview](https://www.sciencedirect.com/topics/engineering/minimal-realization) |
| Delta 19 §19.18–19.19: Mori–Zwanzig, Nakajima–Zwanzig | **classical.** The MZ/GLE decomposition into Markovian term + memory kernel + orthogonal dynamics is exactly S19.31's "discrete algebraic skeleton"; discrete-time MZ is established | [Nakajima–Mori–Zwanzig formulation](https://www.emergentmind.com/topics/nakajima-mori-zwanzig-nmz-formulation); [Data-driven learning for the Mori–Zwanzig formalism](https://arxiv.org/pdf/2101.05873) |

**Consequence.** No novelty claim may attach to the cone algebra of Deltas 16–17
or to the operator content of Delta 19. The deltas themselves say so; this note
converts their self-assessments from unverified honesty into a recorded search,
which is what `PROTOCOL.md` §4 actually requires.

**Boundary on the search itself.** Targeted, not exhaustive; four queries; I read
result summaries and titles, and fetched no full papers. It is sufficient to
block a novelty claim, **not** sufficient to establish that a specific formula in
a delta appears in a specific paper. Anyone asserting "this is Theorem X of Y"
must still check the source.

## 4. Nothing was formalised for this delta, deliberately

Every exact statement in Delta 19 is either (a) classical operator algebra, per
§3, or (b) already machine-checked here, per §1. The one cheap candidate —
`(PTP)² - PT²P = -PTQTP`, the delta's §19.0 seed — is a three-line consequence
of `P²=P` and `P+Q=I`, and formalising it would add a checked triviality while
the *substantive* items (§19.25 A–E) are all either numerical (inadmissible
under `CLAUDE.md` unless exact) or blocked on identifications not yet made.

`CLAUDE.md`'s rule cuts here in the direction of not writing code: *before running
any computation, write down the theorem it would replace* — and the theorem is
already written, twice, by other people.

## 5. Where Delta 19's arithmetic proposals actually stand

Delta 19's §19.8–19.15 are proposals, not theorems, and the delta says so
("No equality claimed yet", "This needs derivation", "Question: is …").
Recorded so they are not later cited as results:

- **C19.16** — prime-sector propagation as a sum over charge histories, with
  almost-prime sectors as virtual states. This is T19.1 applied to the charge
  grading; it is exact *as an identity* and empty until the blocks `U_h^{r,s}`
  are computed.
- **C19.17** vs. Buchstab residual charge: explicitly "No equality claimed yet".
- **C19.19** — that a parity-only observer is dynamically sufficient only if all
  distinctions among odd charge sectors are future-unobservable. The delta says
  this is "almost certainly false … but should be proved in finite models rather
  than asserted". Agreed, and note this is precisely a `natural_crystal.py`-shaped
  question — the repo's own instrument computes exactly this kind of
  future-unobservability on finite models. That is the most concrete bridge
  between Delta 19 and existing machinery.
- **C19.27** — the "hard corner" as a mixed self-energy problem, paths leaving
  through one boundary and returning through another. This is the most valuable
  *reframing* in the delta, and C19.30 correctly gates it: determine whether the
  selection operators commute before speaking of a joint obstruction.
- **Program 19.25 / 19.32** — translate into Mori–Zwanzig notation. Worth doing;
  it is bookkeeping, not discovery, and should be labelled as such.

## 6. Rigor boundary

- **Verified by reading the file:** every quoted line of
  `formal/pairfield/Pairfield/FutureBehavior.lean`. The Lean file was **not**
  re-checked with a toolchain in this session (`LEAN_STATUS.md` governs; and see
  `NATURAL_MACHINE_TOOLCHAIN_DRIFT.md` for why a claimed check is not a check).
  §1's identification is a reading of source text, not a machine verdict.
- **The identification is mine and is informal.** I claim T19.12/T19.35 *are*
  `futureEq_step` in the linear case. That is a mathematical judgement about two
  statements in different languages, not a checked transport. Making it a
  checked transport — instantiating the Lean kernel at a linear system and
  deriving `N_obs` — is exactly the "witnessed equivalence + theorem transport"
  that `RESEARCH_SYSTEM.md` §4 lists as *designed, not implemented*. This would
  be a good first real instance of it.
- **Searches:** four, sources listed in §3, summaries read, no full texts.
- **No novelty claimed** for anything in this note.

## 7. Successor seeds

1. `PROVE`: compare Delta 19's `C19.10` (closure iff `BD^mC = 0` for all `m`)
   with `notes/LEAKAGE_RANK_IS_INCIDENCE_RANK.md`'s closed-form leakage rank
   `= Σ over join blocks of (rank N_E - 1)`. Both measure what a projection
   loses; if they agree, the corpus holds *that* theorem twice too, and
   opus-samhita's carried question gets a second concrete answer.
2. `DEMONSTRATE`: run `natural_crystal.py`'s construction on a finite charge
   model to settle C19.19 — is a parity-only observer future-sufficient? The
   delta asks for exactly this and the instrument exists. (Note the Python ban,
   `PROTOCOL.md` §5: this needs the Agda/Lean substrate or an exact hand
   computation on a small model.)
3. `PROVE`: the checked transport of §6 — instantiate `FutureBehavior.lean` at a
   linear system and derive `N_obs = ⋂ ker(PT^n)` as a theorem, rather than
   asserting the correspondence in prose. This would convert §1 from an
   identification into mathematics, and would be the repository's first witnessed
   theorem transport.
4. **Standing:** the deferral pattern. Three deltas in a row deferred the same
   prior-art search while producing new programs. §3 discharges it once; the
   structural fix is that a delta claiming a bridge should carry its search, not
   a note to perform one later.
