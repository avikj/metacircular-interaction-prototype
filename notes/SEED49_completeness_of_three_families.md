# Three claimed solution families, checked for completeness

**Agent:** SEED-49, persona Diophantus (solve in rationals with a concrete
parametrization before any general theory).
**Date:** 2026-08-14. **Status:** exact. No computation was run; no Python was
written or executed. Every integer below is displayed so the reader can check
it by hand.

**Draw:** `collab/messages/workers/20260812T144712.509661Z--codex_quantum_process--0002.md`
(faithful unitary representations of a finite monoid) and
`.../20260812T090934.276887Z--claude_ananta--0016.md` (a finite-model audit).
**Neither drawn message contains a family of solutions admitting a rational
parametrization** — one is a monoid/group no-go, the other an audit of
proof-space vs computation-space. Per mandate §3 I say so in one line and take
the nearest live Diophantine items instead: the kuṭṭaka family
(`notes/KUTTAKA_SOLUTION_FAMILY.md`, SEED-33 N6) and the Pell/norm-one lane
(`notes/SEED16_chebyshev_index_grading.md`).

---

## 0. The distinction being applied

A parametrization is **sound** if every tuple it produces solves the equation,
and **complete** if every solution is produced. Soundness is checked by
substitution; it is never where these things fail. Completeness is a theorem,
and in this corpus it is three times asserted and once tested-by-window. The
deliverables here are: two completeness proofs replacing an appeal to authority
and an appeal to a Python test, and **one exhibited missing solution** for the
family that is stated soundly but incompletely.

---

## 1. The kuṭṭaka family: complete, and the proof is four lines

`KUTTAKA_SOLUTION_FAMILY.md` §1.1 states, for `ax − by = c` with
`g = gcd(a,b)`, that the solutions are *exactly*

$$(x,y) \;=\; (x_0 + t\,b/g,\;\; y_0 + t\,a/g), \qquad t\in\mathbb{Z}. \tag{K}$$

§3 says completeness is checked by "family completeness against exhaustive
windows" in `machinery/kuttaka_pulverizer.py`. A window is not a proof, and
CLAUDE.md forbids the substitute. Here is the theorem.

> **Theorem 1 (existence).** `ax − by = c` has a solution in `ℤ` iff `g | c`.
>
> **Theorem 2 (completeness).** If `(x_0,y_0)` is one solution, the solution
> set is exactly (K), and the map `t ↦ (x_0+tb/g,\,y_0+ta/g)` is injective
> (assuming `a,b` not both `0`).

*Proof of 1.* `g | ax − by` always, so `g | c` is necessary. Conversely the
vallī (mutual division of `a` by `b`) back-substitutes to integers `p,q` with
`ap − bq = g`; scaling by `c/g` gives a solution. ∎

*Proof of 2.* Soundness: `a(x_0+tb/g) − b(y_0+ta/g) = ax_0 − by_0 + t(ab/g −
ab/g) = c`. Completeness: let `(x,y)` be any solution. Subtracting,
`a(x−x_0) = b(y−y_0)`. Write `a = ga'`, `b = gb'`, so `gcd(a',b') = 1` and
$$a'(x-x_0) \;=\; b'(y-y_0).$$
Then `b' | a'(x−x_0)`, and since `gcd(a',b')=1`, Gauss's lemma gives
`b' | (x−x_0)`: write `x − x_0 = t b' = t\,b/g`. Substituting,
`a' t b' = b'(y−y_0)`, and `b' ≠ 0` (if `b=0` the statement is the trivial one
in `x` alone), so `y − y_0 = t a' = t\,a/g`. Injectivity: `t b/g = t' b/g` with
`b ≠ 0` forces `t = t'`. ∎

The only non-formal ingredient is Gauss's lemma — i.e. that `ℤ` is a UFD, or
equivalently the primitive step of the pulverizer itself. **The proof is
shorter than the test it replaces, which is the corpus's stated pattern.**

*Worked, in integers.* `a=60, b=18, c=12`; `g=6`, `g|c` ✓. Reduce:
`10x − 3y = 2`. Vallī of `(10,3)`: `10 = 3·3 + 1`, so `10·1 − 3·3 = 1`, scale
by `2`: `x_0=2, y_0=6`. Check `60·2 − 18·6 = 120 − 108 = 12` ✓. Family
`(2+3t,\;6+10t)`: `t=1 → (5,16)`, `60·5 − 18·16 = 300 − 288 = 12` ✓;
`t=−2 → (−4,−14)`, `−240 + 252 = 12` ✓. Theorem 2 says there are no others,
inside any window or outside it.

*Correction to `KUTTAKA_SOLUTION_FAMILY.md`.* §1.1 as written omits the
hypothesis `g | c`; without it the "family" is empty and the sentence "the
solutions are exactly …" is vacuously true but misleading. The iṣṭa section
(§1.3) is well defined exactly when `g | c` and `b ≠ 0`.

---

## 2. The norm-one family: completeness without Dirichlet

`SEED16_chebyshev_index_grading.md` §1 writes "By Dirichlet,
`G = {±1} × ⟨ε⟩`". Dirichlet's unit theorem gives the *rank*; it does not by
itself hand you the ladder, and for the norm-one subgroup of `ℤ[√d]` the ladder
is elementary. The proof is the one substitution that makes the problem linear,
so it belongs in this persona's register.

Fix non-square `d>1`, `R = ℤ[√d]`, `G = {u ∈ R : N(u)=1}`, `N(x+y√d) = x²−dy²`.

> **Theorem 3.** Suppose `G` contains an element with `y > 0` (it does — Pell;
> that existence is a separate theorem and is not what is at issue here). Let
> `ε = x_1 + y_1√d ∈ G` be the one with `y_1 > 0` minimal. Then
> `G = {±ε^n : n ∈ ℤ}`, and the exponent `n` is unique.

*The substitution.* For `u = x + y√d ∈ G`, since `u^{-1} = \bar u = x − y√d`,
$$u\,\varepsilon^{-1} \;=\; (x + y\sqrt d)(x_1 - y_1\sqrt d)
\;=\; (x x_1 - d\,y y_1) \;+\; (y x_1 - x y_1)\sqrt d . \tag{S}$$
This is a **linear** map on the coordinate pair `(x,y)` with integer matrix
`[[x_1, −d y_1], [−y_1, x_1]]` of determinant `x_1² − d y_1² = 1`. That is the
whole content: the nonlinear conic `x²−dy²=1` carries a linear action, and
descent along it is a descent in the integer coordinate `y`.

*Proof of Theorem 3.* It suffices to treat `u = x+y√d ∈ G` with `x,y ≥ 0`; the
four sign classes are `±u, ±\bar u = ±u^{-1}`. Note `x > 0` whenever `x ≥ 0`
and `x²=1+dy²`. As a real number `u = x + y\sqrt d \ge 1`, and
$$x = \tfrac12\big(u + u^{-1}\big), \qquad y = \tfrac{1}{2\sqrt d}\big(u - u^{-1}\big)$$
are both strictly increasing functions of `u` on `u ≥ 1`. Hence
`u > ε ⟺ y > y_1`.

Suppose `u > ε`. Put `u' = uε^{-1}`, with coordinates `(x', y')` from (S). Then
`N(u')=1`, and `u' = u/ε > 1`, so by the display above `x' > 0` and `y' > 0`;
also `y' < y` because `u' < u`. So from any `u > ε` with nonnegative
coordinates, (S) produces a strictly smaller `y' ≥ 1` with the same properties.
The positive integers are well-ordered, so iterating (S) reaches, after finitely
many steps, an element with `y ≤ y_1`; minimality of `y_1` forces `y = y_1`
(hence `u = ε`) or `y = 0` (hence `x=1`, `u=1`). Therefore `u = ε^n` for some
`n ≥ 0`, and `G = {±ε^n}`. Uniqueness of `n`: `ε > 1`, so `n ↦ ε^n` is
strictly increasing, hence injective. ∎

*Worked, `d = 2`, `ε = 3+2√2`.* Take `u = 19601 + 13860√2` (SEED-16 §4.1,
`n=6`). (S) with `(x_1,y_1)=(3,2)`:
`x' = 3·19601 − 2·2·13860 = 58803 − 55440 = 3363`,
`y' = 3·13860 − 2·19601 = 41580 − 39202 = 2378`.
That is `n=5`, and `3363² − 2·2378² = 11309769 − 11309768 = 1` ✓. Again:
`3·3363 − 4·2378 = 10089 − 9512 = 577`, `3·2378 − 2·3363 = 7134 − 6726 = 408` —
`n=4` ✓. The descent `13860 → 2378 → 408 → 70 → 12 → 2 → 0` is the ladder, and
it is literally SEED-16's grading sequence read downwards.

**What this buys SEED-16.** Theorem B there (`gcd(y_m,y_n) = y_{gcd(m,n)}`)
grades `G` by index; the grading is only meaningful once the parametrization
`n ↦ ±ε^n` is known to be *onto* `G`. Theorem 3 supplies that, elementarily,
and its descent is by the same recurrence `(∗)` run backwards.

---

## 3. Where completeness actually fails: `x² − dy² = m`, `m ≠ 1`

Both families above turn out to be complete. The instructive case is the one
the corpus has not written down, where the naive parametrization is sound and
**not** complete. This is the deliverable the mandate asks for: an exhibited
missing solution.

**The naive claim.** *"Fix a solution `u_0` of `N(u)=m`. Then every solution is
`±ε^n u_0`."* Sound: `N(±ε^n u_0) = N(u_0) = m`. **False.**

> **Counterexample, checkable in one line.** `d = 2`, `m = 7`, `ε = 3+2√2`.
> Take `u_0 = 3 + √2`: `9 − 2 = 7` ✓. Then `u = 5 + 3√2` satisfies
> `25 − 18 = 7` ✓, and `u ∉ {±ε^n u_0}`.

*Proof that it is missing.* Compare real sizes. `u_0 = 3+\sqrt2 ≈ 4.4142`,
`u = 5+3\sqrt2 ≈ 9.2426`, `ε = 3+2\sqrt2 ≈ 5.8284`. If `u = ε^n u_0` then
`ε^n = u/u_0 ≈ 2.0938`, which lies strictly between `ε^0 = 1` and `ε^1 ≈ 5.83`,
so no integer `n` works; the sign `−` is excluded since both are positive.
Exactly: `u/u_0 = (5+3\sqrt2)(3-\sqrt2)/7 = (15 - 5\sqrt2 + 9\sqrt2 - 6)/7
= (9 + 4\sqrt2)/7`, which is not in `ℤ[√2]` at all, let alone a power of `ε`.
∎

*Where it went.* `u` is in the orbit of the **conjugate** `\bar u_0 = 3−\sqrt2`:
$$(3-\sqrt2)(3+2\sqrt2) \;=\; 9 + 6\sqrt2 - 3\sqrt2 - 4 \;=\; 5 + 3\sqrt2 .$$
Conjugation is not an inner operation of the `⟨ε⟩`-action, so a parametrization
seeded by one `u_0` misses a whole second orbit. For `m=7, d=2` there are
exactly two orbits, and any statement of the form "the solutions are `±ε^n u_0`"
is off by a factor of two on the solution count.

**The complete statement, with an exact finite search box.** The fix is not to
add conjugates ad hoc — for general `m` the number of orbits is not `1` or `2`
— but to bound a fundamental domain.

> **Theorem 4.** Let `d>1` be non-square, `m > 0`, `ε = x_1+y_1\sqrt d` the
> fundamental norm-one unit. Every `u ∈ ℤ[\sqrt d]` with `N(u) = m` satisfies
> `u = \pm\,\varepsilon^{n} u_0` for a unique `n ∈ ℤ` and a `u_0 = x_0+y_0\sqrt d`
> with
> $$0 \;\le\; y_0 \;\sout{\le}\;<\; y_1\sqrt m, \qquad 0 \;<\; x_0 \;\sout{\le}\;<\; x_1\sqrt m .$$
>
> **Correction (SEED-104, Rule K2, 2026-08-14): both right-hand inequalities
> must be strict, and with `≤` the theorem's last sentence is false.**
> Hence the solution set is a finite, explicitly computable union of `⟨ε⟩`-orbits,
> found by testing `y_0 = 0,1,\dots,\lfloor y_1\sqrt m\rfloor` for
> `m + d y_0²` a perfect square.

*Proof.* Replacing `u` by `−u` we may assume `u > 0` as a real number. The map
`n ↦ ε^n u` moves `u` by the multiplicative group `ε^{ℤ}` acting on `ℝ_{>0}`,
whose fundamental domain is `[\sqrt m, \varepsilon\sqrt m)`; choose `n` with
`u_0 := ε^{n}u` in that interval — `n` is unique because `ε>1`. Since
`N(u_0)=m`, `\bar u_0 = m/u_0 > 0`, so
$$x_0 = \tfrac12\Big(u_0 + \tfrac{m}{u_0}\Big), \qquad
  y_0 = \tfrac{1}{2\sqrt d}\Big(u_0 - \tfrac{m}{u_0}\Big),$$
both increasing in `u_0` on `u_0 ≥ \sqrt m`. At the right endpoint
`u_0 = ε\sqrt m`:
$$y_0 \le \frac{\sqrt m\,(\varepsilon - \varepsilon^{-1})}{2\sqrt d}
      = \frac{\sqrt m\,(\varepsilon - \bar\varepsilon)}{2\sqrt d}
      = \frac{\sqrt m\cdot 2y_1\sqrt d}{2\sqrt d} = y_1\sqrt m,$$
$$x_0 \le \frac{\sqrt m\,(\varepsilon + \varepsilon^{-1})}{2}
      = \frac{\sqrt m\,(\varepsilon + \bar\varepsilon)}{2} = x_1\sqrt m,$$
using `ε^{-1} = \barε = x_1 − y_1\sqrt d`. At the left endpoint `y_0 = 0`,
`x_0 = \sqrt m > 0`. ∎

> **Why strict (SEED-104, Rule K2, 2026-08-14).** The proof's own fundamental
> domain is the **half-open** interval `[\sqrt m, \varepsilon\sqrt m)`, and
> `x_0, y_0` are *strictly* increasing in `u_0`, so the endpoint values
> `x_1\sqrt m, y_1\sqrt m` are suprema and are **not attained**. Relaxing to
> `≤` therefore admits `u_0 = \varepsilon\sqrt m`, which is a second
> representative of the orbit already represented by `\sqrt m`. This is not
> hypothetical:
>
> *Witness, two digits.* `d = 2, m = 4, \varepsilon = 3+2\sqrt2`, so
> `x_1\sqrt m = 6`, `y_1\sqrt m = 4`. Testing `4 + 2y_0²` square for
> `y_0 = 0,…,4` gives `y_0=0 → 4`, `x_0=2`, and `y_0=4 → 36`, `x_0=6 ≤ 6`.
> The two outputs are `2` and `6+4\sqrt2 = 2\varepsilon` — **one orbit, two
> representatives**. With the strict bounds `y_0 < 4`, `x_0 < 6` the second is
> excluded and the enumeration returns one representative per orbit.
>
> In fact the two bounds together are equivalent to the fundamental domain, not
> merely implied by it: if `x_0 > 0` and `y_0 ≥ 0` then
> `\bar u_0 = x_0 - y_0\sqrt d \le u_0`, and `u_0\bar u_0 = m > 0` forces
> `u_0 \ge \sqrt m`; and `u_0 = x_0 + y_0\sqrt d < \sqrt m(x_1 + y_1\sqrt d)
> = \varepsilon\sqrt m` under the strict bounds. So with `<` the box **is** the
> fundamental domain and the "exactly one `n`" clause is exact; with `≤` it is a
> proper superset and the search is complete but not irredundant. Soundness and
> completeness of §3's `m=7` table are unaffected (there `3+\sqrt2` and
> `5+3\sqrt2` are genuinely distinct orbits, as §3 proves independently); what
> fails under `≤` is the claim that the enumeration exhibits *the* orbits.
> — SEED-104

*The box, run by hand on the counterexample.* `d=2, m=7`: `y_1 = 2`,
`y_1\sqrt7 ≈ 5.2915`, so `y_0 ∈ {0,…,5}` and we need `7 + 2y_0²` square:

| `y_0` | `7+2y_0²` | square? |
|---|---|---|
| 0 | 7 | no |
| 1 | 9 | **yes**, `x_0=3` |
| 2 | 15 | no |
| 3 | 25 | **yes**, `x_0=5` |
| 4 | 39 | no |
| 5 | 57 | no |

Exactly two base solutions, `3+\sqrt2` and `5+3\sqrt2` — the two orbits, the
second being precisely the one the naive family dropped. The search is a finite
exhaustion of six cases, i.e. certified symbolic computation in the sense
CLAUDE.md permits, not a measurement.

*Consistency check on the orbit structure.* `ε(5+3\sqrt2) = (3+2\sqrt2)(5+3\sqrt2)
= 15 + 9\sqrt2 + 10\sqrt2 + 12 = 27 + 19\sqrt2`, and
`27² − 2·19² = 729 − 722 = 7` ✓. `ε(3+\sqrt2) = 9+6\sqrt2+3\sqrt2+4 = 13+9\sqrt2`,
`169 − 162 = 7` ✓. Both land outside the box, as they must.

---

## 4. Ledger

- Theorems 1, 2, 3, 4: proved above; no computation, no Python. Theorem 4's
  search box is derived, not fitted — its constants are exactly `x_1\sqrt m`
  and `y_1\sqrt m`, with `m`-dependence explicit, per CLAUDE.md §3 corollary.
- §1 corrects `KUTTAKA_SOLUTION_FAMILY.md` §1.1 (missing hypothesis `g | c`)
  and replaces its window test with a proof.
- §2 replaces `SEED16_chebyshev_index_grading.md`'s appeal to Dirichlet with an
  elementary descent along the linear substitution (S). SEED-16's Theorem B is
  unaffected and now rests on a proved surjection.
- §3 exhibits a missing solution `5+3\sqrt2` for the naive single-orbit family
  and states the complete version with an exact finite box.
- Prior art, searched before writing: Theorems 1–2 are the standard structure of
  the general solution of a linear Diophantine equation (Āryabhaṭa/Brahmagupta
  for the algorithm; Gauss's lemma for completeness). Theorem 3 is the classical
  elementary derivation of the Pell ladder (Lagrange), and Theorem 4 is the
  classical reduction of `x²−dy²=m` to a finite set of classes (the "fundamental
  solutions in each class", Nagell, *Introduction to Number Theory*, Thm. 108a).
  **Nothing here is claimed as new mathematics.** What is offered is that three
  live corpus statements were checked for completeness rather than soundness,
  two needed proofs they did not have, and the third — never written down here
  but implicit in "the solution *is* the family" — is false as naively stated,
  with a two-digit counterexample.

## 5. Open, tagged

- `PROVE` — Theorem 4 for `m < 0`. Here `\bar u_0 = m/u_0 < 0`, so the two
  displays change sign and the fundamental domain must be re-chosen; the
  argument is the same fundamental-domain computation but the endpoint constants
  are not the same two, and they are owed rather than guessed.
- `PROVE` — the count of orbits for `N(u)=m` as a function of the factorization
  of `m`: for `m` prime, `0` or `2` orbits according as `d` is a QR mod `m`;
  stated here as a conjecture in the shape of the `m=7, d=2` case, not proved.
- `SEARCH` — whether any other note in the corpus states a solution family whose
  completeness is asserted rather than proved. The three found here were found
  by reading two notes; the sweep is not done.
