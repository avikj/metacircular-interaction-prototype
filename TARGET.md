# The target

**cf-sakshi, 2026-08-14.** Written because the owner asked the machine to be
pointed at a named problem — RH, Goldbach, twin primes, Fermat — and because a
machine without a target optimises for the appearance of motion. This file names
one, says why it and not the others, says what would count as a win, and says
what is already done toward it. It is meant to be argued with and replaced, not
venerated.

---

## 0. The honest triage of the four

| problem | can this corpus reach it | verdict |
|---|---|---|
| **Fermat** | no. Wiles is modularity; nothing here touches Galois representations or deformation theory | **not a target** |
| **RH** | the corpus computes *with* the zeros constantly (Theorems D′, D‴, G, H) and has a real barrier theorem about them (Theorem K: correlation-grade information costs $X\sim\exp(cT\log^2T)$). But every one of those is *downstream* of the zeros; nothing here bears on where they are | **not a target; a tool** |

> **STRUCK 2026-08-22 — the exponent in the RH row above is RETRACTED and this
> file is the last high-visibility site still carrying it unmarked.**
> `HOLOGRAM.md` §7 supersedes Theorem K(b)'s $\exp(cT\log^2T)$. For
> correlation-grade content the figure is $\exp(\Theta(T))$ (`HOLOGRAM.md` §5);
> the $\exp(\Theta(T^{1/2}\log^{3/2}T))$ of §7 is for **sums**, not
> correlations. An audit on 2026-08-22 found the retracted exponent standing
> unmarked in **eleven** places — including `HOLOGRAM.md:200` itself, directly
> contradicted by its own §7. The wrong version is left in the row above rather
> than erased.
>
> **The row's verdict survives and is unaffected**: whatever the depth exponent,
> every theorem here is downstream of the zeros and none bears on where they
> are. RH remains a tool and not a target. What changed is the price, not the
> direction.
| **Goldbach** | blocked by the parity barrier | **downstream of the target** |
| **twin primes** | blocked by the parity barrier | **downstream of the target** |

Two of the four are blocked by the same thing. That thing is the target.

> **TARGET: the parity barrier — not to break it, but to make it a theorem
> about observable classes, so that "can this method possibly work?" becomes a
> decidable question instead of a matter of taste.**

## 1. Why this and not "solve twin primes"

Because the corpus already contains the two halves of a real result and has
never joined them into a program:

- **Protection.** `notes/GAUGE.md` Theorem F: the unique KMS state of the
  critical affine arithmetic system is invariant under the gauge torus, hence
  annihilates every charged observable. Parity is the charge $(-1,-1,\dots)$.
  So sieve blindness to parity is *an exact invariance, not a want of
  technique*. `CORE_KMS.md` closed the last escape (the core carries exactly
  one equilibrium at every $\beta$).
- **Exposure.** `notes/LIOUVILLE.md` Theorem H: at the archimedean place
  $\lambda$ is visible at full strength through $\zeta(2s)/\zeta(s)$, with the
  entire pair field riding at one scale $X^2$ — main term, single-zero lines
  and pair lines together — verified at correlation 0.9999–1.0000.

Together: **the parity barrier is a property of the place, not of the
function.** That sentence is already in the repository. What is *not* in the
repository is its consequence:

> Any method that breaks parity must couple the archimedean place to the finite
> places. This is not a heuristic — it is what the protection/exposure duality
> says. A method that lives entirely at the finite places cannot work, and one
> can check whether a proposed method does.

And `notes/BARRIER.md` independently arrived at the same shape from the other
side, with the literature check already done: Bombieri's asymptotic sieve (1976)
says sieve axioms alone cannot resolve parity; Friedlander–Iwaniec (1998)
identifies exactly which extra axiom breaks it; Green–Tao–Ziegler is the one
place in the field where "what a whole class of observables can and cannot see"
is a *theorem*. And, quoted from that note's audit:

> **no general formalization of the parity barrier exists**; Tao (2007) states
> it semi-formally and concludes it is "probably premature … to try to find a
> systematic way to get around the parity problem in general".

That is the gap. It is a formalization gap, not an analytic one, which is
exactly what a proof-checking machine is for.

## 2. What would count as a win, in increasing order

1. **W1 — the barrier as a checked separation.** A precise observable class,
   and a machine-checked proof that two arithmetic objects are *equal* on every
   observation the class admits while differing in parity. Not "hard to
   distinguish": identical transcripts. **Done today** — see §4.
2. **W2 — a charge criterion.** A structural test on an observable that decides
   whether it carries gauge charge. Then any proposed attack on Goldbach or twin
   primes is *checkable*: neutral ⇒ provably cannot work. This is
   `GAUGE.md` §F.4's own closing sentence — "formalizing which probes carry
   charge is the continuation of this line" — promoted from aside to program.
3. **W3 — the interface separation.** `BARRIER.md` Problem 1. Entropy decrement
   is currently outside the windowed-linear class *by definition of the
   interface it consumes*, not by theorem. Prove no post-processing of value
   queries simulates functional-equation queries. This is an oracle separation
   and it is the kind of statement that is provable.
4. **W4 — the coupling theorem.** Make "a parity-breaking method must couple
   the places" a theorem with a quantitative form: how much archimedean input,
   at what depth, buys how much parity information.

**W1 and W2 are done** (§4, §4b). W3 is the one worth publishing. W4 is the one
that would matter to Goldbach.

## 3. Why W3 is genuinely attackable, where the corpus's other separation is not

`BARRIER.md` states its own obstruction honestly: to separate observable classes
on the zeta side you must exhibit **two admissible zero configurations** with
the same blurred spectrum — and "the zeros of $\zeta$ cannot be moved."

**On the parity side that obstruction does not exist.** The objects are
completely multiplicative $\pm1$ functions, i.e. arbitrary sign assignments on
the primes: a free space $\{\pm1\}^{\mathcal P}$. We can move them. So the
diagonalisation that is unavailable against $\zeta$ is available here, and the
separating pair need not be found — it can be *constructed*, which is what §4
does at the smallest nontrivial scale.

This is the reason to attack parity rather than the depth barrier: same shape of
theorem, and one of the two has a free parameter space.

## 4. First strike, landed

`formal/cubical/NaturalMachine/ParitySeparator.agda` — `--cubical --safe`, no
postulates, no holes, in the `NaturalMachine` root, exit 0.

Theorem F's arithmetic core, with the operator algebra removed. A completely
multiplicative $\pm1$ function is a sign assignment $\sigma$ on the primes; a
number is its multiset of prime factors, so $\Omega$ is a length. Let $\sigma'$
flip every prime sign — this is the gauge element $(-1,-1,\dots)$, the one
point of GAUGE.md's torus whose character is the parity grading. Then

$$\mathrm{val}_{\sigma'}(n) = (-1)^{\Omega(n)}\,\mathrm{val}_\sigma(n)
\qquad(\texttt{flip-law}),$$

so the two agree at every even-$\Omega$ argument and differ at *every* odd-$\Omega$
one. Consequently an observer whose queries are all parity-neutral produces
**the same list of answers** on $\sigma$ and $\sigma'$ — `obs-agree`, an equality
of lists, not an estimate — and therefore

`no-decision`: no `decide : List Bool → Bool`, however powerful, accepts $\sigma$
and rejects $\sigma'$. The proof is `cong`. There is nothing to separate.

And the collision specifies its own repair, in the sense `runtime/CRYSTAL.md`
§3.2 already fixed for this corpus: `the-missing-distinction` exhibits a single
odd-$\Omega$ query that does separate, while `two-primes-blind` shows a larger
query that does not. **Separating power is a function of the charge of the
query, not of its size.** That is W2 in miniature, and it is why W2 looks
reachable.

What this is *not*: new arithmetic. The obstruction is Bombieri's and
Friedlander–Iwaniec's. What is new is that its core is a two-element orbit of a
group action, checkable rather than arguable — which is what lets "which probes
carry charge" be posed as a membership problem.

## 4b. Second strike: the barrier becomes a test

`formal/cubical/NaturalMachine/ChargeCriterion.agda` — same gate, exit 0, and no
Cubical pattern-matching warnings (`HasOdd` is defined by recursion rather than
as an indexed family, because a criterion that does not compute under transport
is not a test).

A one-directional no-go lets every reader believe their favourite method is the
exception. The converse is what removes that, and it is proved here:

> **`charge-criterion`.** A query set admits a decision procedure separating the
> all-plus sign assignment from its gauge flip **if and only if** it contains a
> query of odd $\Omega$.

The "if" direction *constructs* the separator — drop the first $k$ answers and
look — so nothing clever is needed once a query carries charge; and `not-both`
checks the two sides are exclusive, so the criterion is not satisfiable
vacuously.

**As a test on a method:** look at the arguments at which your method ever
evaluates the multiplicative function. All even $\Omega$ ⇒ provably parity-blind,
not "has not yet succeeded". Some odd $\Omega$ ⇒ a separator exists and this
barrier says nothing about you.

The asymmetry is the theorem, not a limitation: **charge lives in what a method
reads, and no amount of computation on neutral readings manufactures it.** Note
what this does *not* do — passing the test is permission, not a proof that a
method works. Friedlander–Iwaniec's bilinear axiom is what actually has to be
supplied; the criterion says where to look for it.

## 5. The standing danger, named so it can be checked against

This corpus's recorded failure mode is measuring what a page of algebra
determines (`CLAUDE.md`), and its second is agents building a map of their own
attention and then acting on it (`collab/orchestration/delta-coverage.md`, the
ledger-error note — my own, from this morning). Both apply here:

- **No experiment on this target may be run before the theorem it would replace
  is written down.** The parity lane already has its numbers (exp10, exp11,
  exp15); more measurement of a protected sector measures zero, exactly.
- **Before any claim, grep the corpus for the section number, not the concept.**
  `GAUGE.md`, `PARITY.md`, `LIOUVILLE.md`, `BARRIER.md`, `CORE_KMS.md`,
  `WIDTH.md`, `BUCHSTAB_WINDOW.md` and `LITERATURE.md` are all on this target
  already. I found four of them only by grepping for "parity barrier" after
  proposing to prove something two of them had already proved.

## 6. What the next block should do

1. ~~**W2.**~~ Done: `ChargeCriterion.agda`, both directions, separator
   constructed. The criterion turned out to be about the QUERY SET and not the
   post-processing, which is a sharper statement than the one predicted here.
2. Then read `BARRIER.md` §3 Problem 2 (the oracle model: value queries vs
   functional-equation queries) against that criterion. They should be the same
   distinction stated twice; if they are not, the difference is the finding.
3. Only then, W3.

Nothing on this list needs a floating-point number.
