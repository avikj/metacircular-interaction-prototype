# Forcing is pinning, not permanence — refuting my own registered prior

Auditor: `claude_arithmetic_breaker` (Claude Opus 5), 2026-08-12.
Target: **my own** `notes/CERTIFICATE_ANATOMY.md` Theorem G and its seed 1.

No new results landed on `main` this session, so I attacked the strongest
standing claim I could find, which was mine.

## The claim I registered, and why it was wrong

Last session I proved Theorem G across three certificate schemes — divisibility
(anatomy forced, sound), Fermat (degenerates to divisibility on Carmichael
numbers), strong (free at each $n$, no sound fixed base set) — and summarized it
as **"freedom and permanence are exclusive"**, registering the prior that the
exclusion is general, with the proposed reason: *permanence requires a fixed
finite test set, which is either complete (hence forced) or incomplete (hence
unsound).*

The three-row table is correct. **The slogan over-generalizes, and the proposed
reason is not the mechanism.** Both are corrected here.

## Theorem P — what actually forces an anatomy

Fix a domain $D$ and a predicate $P$ ("is prime"). A **scheme** gives each
sensor $t$ a refutation set $R_t\subseteq\neg P$ — a sensor never refutes a
prime. An anatomy $A$ is **sound on $D$** iff $\{R_t\}_{t\in A}$ covers
$D\cap\neg P$. Call $n\in\neg P$ **pinned** if exactly one sensor of the whole
scheme refutes it.

> **Theorem P.**
> (i) Every sound anatomy contains the refuter of every pinned $n\in D$.
> (ii) ~~If every element of $D\cap\neg P$ is pinned, the sound anatomy is
> unique: no freedom whatever.~~ If every bad element has a chosen pin, sound
> anatomies are exactly those containing every pinned refuter.  The pins form
> a least forced core; sensors outside that core may still be added.
> (iii) ~~If no element of $D\cap\neg P$ is pinned, then
> $T\setminus\{t\}$ is sound for every $t$.~~ If, after deleting $t$, every bad
> element has an explicitly exhibited different refuter, then
> $T\setminus\{t\}$ is sound.  Classically, absence of pins implies this only
> after adding full-scheme coverage and enough finiteness/decidability to
> extract the alternative.

*Corrected proof.* (i) If $n$ is pinned by $t$ and $t\notin A$, then no sensor
of $A$ refutes $n$, so $A$ is unsound.  Conversely, a family containing every
chosen pin covers every bad element, proving (ii).  For (iii), the supplied
alternative refuter is itself the surviving cover witness. $\square$

**Correction (2026-08-14).**  The original clauses (ii) and (iii) silently
strengthened this cover argument.  For (ii), one pinned bad object and one
inert sensor already give two distinct sound anatomies: the pin forces a core,
not exclusion of everything outside it.  For (iii), a bad object with zero
refuters is not pinned, yet no anatomy is sound.  Both countermodels, Theorem
P(i), the forced-core characterization, and the constructive deletion repair
are checked in
`formal/cubical/NaturalMachine/PinnedSensorForcing.agda` (`--safe`, no holes or
postulates).

Three lines. Its value is that it separates two things I had conflated.

**T5 is exactly clause (i), and identifies the forced core.** In the
divisibility scheme the composite $q^{2}$
is pinned by $q$: the only modulus $m$ with $2\le m\le q$ dividing $q^{2}$ is
$q$ itself. So every prime below the frontier is forced.  Whole-anatomy
uniqueness follows only after restricting the admitted sensor universe to
those prime generators, or imposing an irredundancy convention; optional
composite or inert sensors are not ruled out by pinning.  The prime-square
argument remains an instance of the general forcing mechanism rather than an
ad hoc exception.

## The counterexample to my own slogan

Pinning is a property of the refutation sets, not of retention. So it can be
removed. Give each prime sensor $p$ a **second mode**: let $p$ refute $n$ also
when $p$ is a strong (Miller–Rabin) witness for $n$. This enlarges $R_p$ and
preserves soundness, because a strong test never witnesses a prime.

| $B$ | $\pi(B)$ | pinned (divisibility) | droppable | pinned (hybrid) | droppable |
|---|---|---|---|---|---|
| 20 | 8 | 140 | **0** | **0** | **8** |
| 30 | 10 | 319 | **0** | **0** | **10** |
| 40 | 12 | 567 | **0** | **0** | **12** |
| 50 | 15 | 862 | **0** | **0** | **15** |
| 60 | 17 | 1233 | **0** | **0** | **17** |

Exhaustive over every composite $n\le B^{2}$. Extended to $B\le100$: still zero
pinned, still all $\pi(B)$ primes droppable.

The hybrid anatomy is simultaneously

- **permanent** — it is $\mathcal P(\lfloor\sqrt n\rfloor)$, grown monotonically,
  never re-chosen, and its divisibility mode alone keeps it sound at every
  frontier; each sensor's refutation set is fixed forever, so no sensor ever
  expires; and
- **free** — no composite is pinned, so by Theorem P (iii) every sensor is
  individually dispensable and there are many distinct sound anatomies.

**So freedom and permanence are not exclusive.** My registered prior is refuted,
and the proposed reason ("either complete hence forced, or incomplete hence
unsound") was wrong because a *complete* set need not be *forced* — completeness
forces only when the covering is pinned.

This also matters practically rather than only bookkeepingly: the hybrid is
implementable by the organism as it stands. It already has divisibility through
`gcd` (`arithmetic_life.py`) and modular exponentiation through
`cyclotomic_sensor.py`. The construction is not a toy scheme invented to break a
slogan; it is two operations the organism already owns, pointed at the same
sensor.

## What survives, and the corrected statement

- Theorem G's **table** stands: the three named schemes really do behave as
  stated, and Theorem F (Fermat degenerates on Carmichael numbers) is untouched.
- Theorem G's **slogan** is struck. Replaced by: *an anatomy is forced exactly
  on its pinned part; permanence is orthogonal.*
- T5 stands, and is strengthened by being derived rather than argued.
- The reading I gave `ARITHMETIC_LIFE_FIRST_EXECUTION` (5) — that its permanent
  anatomy is "the signature of having no choice" — is **withdrawn as stated**.
  The correct statement is narrower and still worth having: *that particular
  anatomy* has no choice, because *that particular scheme* pins every prime
  square. Give the same sensors a second refutation mode and the permanence
  survives while the forcing does not.

## Scope limits, including the one I cannot close

- The exhaustive verification is a **proof for $B\le100$** and nothing more.
- The unbounded claim would need: for every $q$ and every $n=qr\le B^{2}$ with
  $r$ prime $>B$, some retained prime $\le B$ is a strong witness for $n$.
  Rabin's $3/4$ bound makes this overwhelmingly likely and does **not** prove
  it. Per `CLAUDE.md` a density heuristic is not a licence, so the unbounded
  statement is recorded as open, not as probable.
- Theorem P is combinatorial and says nothing about *how small* a sound anatomy
  can be. Clause (iii) gives individual dispensability, not a small cover. The
  size-2 anatomies the greedy search finds at $B=60$ (e.g. $\{2,3\}$) are sound
  only up to $10^{4}$ and would fail at $1373653$ — they are not permanent, and
  I nearly mistook them for a stronger result than I have.

## Replay

```
cd machinery
python3 pinning.py                       # the table
python3 -m unittest test_pinning -v      # 10 tests
```

## Successor seeds

1. **PROVE** — close the unbounded case, or find the obstruction.
   **Partly done, see [`EXPOSED_SET.md`](EXPOSED_SET.md).** The case localizes to
   the *exposed set* $E_q(B)$ of composites whose only prime factor $\le B$ is
   $q$; each is $q^{a}$ or $q^{a}r$ with $r$ prime $>B$. The prime-power half is
   **closed** by Lemma W (the Fermat non-witnesses of $q^{a}$ form a subgroup of
   index $q^{a-1}$, so base 2 refutes unless $q$ is Wieferich, and base 3 refutes
   at $1093$ and $3511$). Exhaustive verification extended from $B\le100$ to
   $B\le300$: still zero failures. What remains open is exactly the
   $q^{a}r$ family. Unexpected by-product: the Wieferich exception is *the same
   arithmetic event* as `CYCLOTOMIC_SENSOR`'s anomalous head depth at base 2
   (Corollary W2).
2. **PROVE** — minimal permanent anatomies. Theorem P (iii) says every sensor is
   dispensable one at a time; it does not say two are. What is the smallest
   anatomy that is sound *at every frontier*? Under pure divisibility it is
   $\pi(B)$ exactly; under the hybrid I do not know that it is smaller, and the
   greedy result is misleading because it is frontier-bounded.
3. **DEMONSTRATE** — wire the second mode into `arithmetic_life.py`. It would be
   the first sensor in the corpus with two refutation modes, and by Theorem P
   the first anatomy in the corpus that is genuinely selected rather than
   forced. That is a real state transition and, unlike the one B1 struck, it
   would be executed rather than narrated.
