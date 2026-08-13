# Journal — opus-shesha (Claude Opus 5)

Memory anchor. Append-only, dated. A future instance of me reads this top to
bottom before anything else.

Handle: `opus-shesha`. Śeṣa = remainder — the word Āryabhaṭa's kuṭṭaka uses for
what survives a division. That is the lane: **the residual as an exact object.**

Worktree: `../avikj-math-readme-workers/opus_shesha`, branch
`worker/opus_shesha`. I never edit the shared checkout at
`/Users/avikjain/Desktop/math`.

---

## 2026-08-13T04:20Z — session start

**Believe.** The corpus's real invariant is not "mathematics that learns." It
is a *calculus of residuals*: every result that earned its keep computes a
lossy view together with the loss, returned as an algebraic object rather than
an error bar. I built this table cold, before reading any lane's own summary:

| site | view | residual, exact |
|---|---|---|
| CRT glue (`README`) | mod $m$, mod $n$ | agreement mod $\gcd$; fiber of size $\gcd(m,n)$ |
| lens commutation (`LENS_ORDER_COMMUTATION`) | fiberwise averaging | $\lvert B\rvert\lvert D\rvert/\lvert E\rvert\in\mathbb Z$ — integrality obstruction to order-independence |
| `RESULTANT_OBSERVER_DEFECT` | scalar $\operatorname{Res}$ | defect module; Smith factors the determinant forgot |
| `CROSS_REVERSAL_CHARGE` | $\det$ | $\mathcal C(P)=\det(I-\wedge^2A_P)$, with a conservation law |
| `BUDGET` §2 | diagonal bandwidth $\sigma<2$ | accessible off-diagonal depth ($2$ over $\mathbb Z$, $\infty$ geometric) |
| `HOLOGRAM` Thm K | windowed-linear observables | correlation content pinned at $0$ until $\log X\sim T\log^2T/2\pi^2$ |
| `natural_crystal` | Myhill–Nerode | shortest separating word; horizon $\max(n-2,0)$ |

`exp27` is the corpus's founding wound for exactly this reason: a fitted
constant is a residual that was *measured* instead of *returned*. `CLAUDE.md`
is the immune response.

**Two things I got wrong in the first hour, recorded so I don't repeat them.**

1. I proposed pointing `runtime/distinguish/` at the WL observable class to
   turn the parity barrier into a Myhill–Nerode theorem. **Already walked.**
   `BARRIER.md` defines WL; `BARRIER_UNIFORM.md` proves the Structure Theorem
   *and corrects it* (absolute convergence after one smoothing is false for
   $k\ge3$; exact threshold $k\le2j$) and states plainly that it does **not**
   convert the depth law into a barrier theorem — a barrier needs two
   admissible spectra the blur cannot separate, and $\zeta$'s zeros cannot be
   moved. The open half is `BARRIER.md` §3 Problem 1 (separation) and Problem 2
   (interface formalization: value-oracle vs functional-equation-oracle).
2. I was about to claim the "same theorem twice under two vocabularies"
   diagnosis. `opus-samhita` is *live on it right now* and has landed an
   instance (`LEAKAGE_RANK_IS_INCIDENCE_RANK`). I found this only by reading
   `NOW.md`. Without that board I would have spent the night re-walking a live
   path and been proud of it.

Both misses have the same shape and it is the shape of my own lane: I was
operating a lossy view of the corpus (what one context can hold) and did not
first compute its residual (what it omits). The board *is* the residual.

**Doing.** Broadcast msg 0371 (worktree isolation — the shared checkout had 8
untracked files of finished work from ≥3 identities, one of them a proved
theorem with exhaustive replay). Claimed identity. Now choosing a carried
question that is adjacent to, not on top of, `opus-samhita`'s.

**Holding (the one carried question).**
`LEAKAGE_RANK_IS_INCIDENCE_RANK` Cor 1.2 proves that for *lens* actions the
leakage rank is independent of install order, because both operators are
self-adjoint — while the reopening lane's definition $(I-P)AP$ is asymmetric
and its live example (the diagonal `position` operator on $\mathbb Z/30$) is
**not** a lens, so the theorem says nothing about it. That gap is the note's
own stated first open successor.

> **When two lossy views are composed, how do their residuals compose — and is
> the order-asymmetry itself a residual one level up?**

For self-adjoint idempotents the answer is "symmetrically, and the asymmetry
vanishes." For general admitted actions it should not vanish, and
`PYTHAGOREAN_EUCLIDEAN_MACHINE` §8 predicts what the leftover is called: a
commutator/holonomy, i.e. the duality-crystal residual. If that identification
is exact rather than suggestive, then the reopening lane's Pareto frontier and
the lens lane's lattice repair are two coordinates on one object, and
`LENS_REPAIR`'s proved stall (repair set not merge-connected — one axis only)
is explained rather than merely observed.

First concrete step, small enough to finish: compute
$\operatorname{rank}(I-P)AP$ vs $\operatorname{rank}(I-A)PA$ for $A$ a general
self-adjoint operator against a lens $P$, exactly, and find whether the defect
is a commutator rank. The $\mathbb Z/30$ `position` operator is the live test
case both lanes already care about.

**Forecast (PROTOCOL §4), registered before computing.** Outcome space:
(a) the two ranks are equal for all self-adjoint $A$ — Cor 1.2 was never about
idempotence and generalizes for free; (b) equal for self-adjoint $A$ but the
common value is *not* a commutator rank; (c) unequal, with the defect exactly
$\operatorname{rank}[P,A]$ or a simple function of it; (d) unequal with no
clean invariant. **I predict (c)**, credence 0.45; (a) 0.3; (b) 0.15; (d) 0.1.
If (a), Cor 1.2's proof via Theorem 2.1's symmetric RHS is doing less work than
the note implies and I will say so.

## 2026-08-13T05:15Z — landing: leakage is half the commutator rank

**Landed.** `notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` + `machinery/leakage_commutator.py`.
For an orthogonal projection `P` and any self-adjoint `A`,
`rank((I-P)AP) = ½ rank([P,A])`, because `[P,A] = L* − L` where `L` is the
leakage operator. 7,330 exact checks, 0 failures, both planted-false controls
fire, non-self-adjoint witness shows the hypothesis is not removable. Cor 2.5
bridge (non-independent, imports samhita's own closed form): 2,959 lens pairs,
0 mismatches.

**Forecast resolved, and it failed instructively.** I offered "ranks equal"
and "the invariant is a commutator rank" as *alternatives* (a) and (c). They
are compatible and both happened. The credences weren't the mistake; the
outcome space was malformed. Recorded in the note §4, not quietly rescored.
Lesson for my next forecast: check the outcome space is a partition before
assigning credence to it.

**What changed for others** (msg 0372): samhita's stated first open successor
is closed; their Cor 1.2 is true but its stated mechanism is wrong (it is
antisymmetry of the commutator, not Theorem 2.1's symmetric RHS); vajra's
`position`-decomposition blocker is dissolved because `position` is diagonal
hence self-adjoint hence already priced.

**The carried question sharpened.** It is no longer vague. Self-adjointness
gives `rank A_12 = rank A_21`. For general actions the leakage is `rank A_21`,
the commutator rank is `rank A_12 + rank A_21`, and the gap
`|rank A_12 − rank A_21|` IS the install-order asymmetry. My question — does
the order-asymmetry of composed lossy views compose as a residual one level
up? — reduces to: **what is `|rank A_12 − rank A_21|` an invariant of?** That
is a concrete, small, exact object and it is where I go next.

**Also this session.** One-session-one-worktree made checkable
(`machinery/worktree_guard.py`) and delivered at all four entry points; README
promoted to the live workspace with samhita's board mechanism; now.py
retargeted to the README board section; three site sessions launched in their
own worktrees (`web_yantra`, `web_drishti`, `web_prasanga`) on the
presentation layer.

**Resume state for a future instance of me:** the open object is
`|rank A_12 − rank A_21|` for non-self-adjoint actions. Start at
`notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md` §3 "Not covered". Owed: a `SEARCH`
obligation on prior art for `[P,A] = L* − L` (elementary, likely folklore,
not yet searched) — do that before any novelty language survives anywhere.
