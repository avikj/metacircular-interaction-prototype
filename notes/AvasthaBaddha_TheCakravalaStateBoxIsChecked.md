# अवस्था बद्धा — the cakravāla's turn cap now rests on a checked box, and the one thing still missing is named

*Written 2026-08-20. `AHIMSA_SUTRA_VISTARA` §46: `अवस्था बद्धा । यत् धार्यं तत्
परिमितम् ।` — the state is bounded; what is held is finite. §8: `यत् सीमां वदति
तत् न सङ्क्षिपति` — what states its limit does not collapse. This note is the
second half of that pair for the reactor's cap; the first half,
`यत् शेषं वदति` — what states its remainder — was done by
`notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md`, whose §5 named this as the
missing piece.*

---

## 1 · The charge, and what it turned out to be

The standing question is **termination of the cakravāla**. Jayadeva (~950,
through Udayadivākara's *Sundarī*, 1073) and Bhāskara II (*Bījagaṇita*, 1150)
had the algorithm; Lagrange proved termination for a different algorithm in
1768. It is open in this repository and it is still open after this note.

But **a turn cap does not need termination**. It needs something strictly
weaker, and the weaker thing is provable:

> **If the wheel reaches क्षेप = 1 at all, it does so within B² turns, where B
> is the least natural with 4D < B².**

That implication needs only two inputs: the state lying in a box of side B,
and the next state being a function of the current one. It never needs the
wheel to reach 1. The first input is now **checked**; the second is
**half-checked, with the other half named and its failing shape written down**.

## 2 · What was already here, and the hole in it

`formal/cubical/CakravalaBound.agda` proves that Bhāskara's choice rule
preserves `k² ≤ 4D`, strictly, and does it with no square roots and no
floating point. It is the strongest thing in this lane and this note depends
on its conclusion.

**It bounds the क्षेप and never bounds the गुणक.** Its own list of what is
missing says the bound "buys" that the state ranges over a finite set — but
the state is the pair (m, k), and with m unbounded there is no finite set and
no counting can start. That is the hole.

## 3 · What is now proved

`formal/cubical/GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating.agda`
— `--cubical --safe`, no postulates, no holes, **EXIT=0 under the pin**
(Agda 2.8.0 + cubical v0.9).

| name | statement |
|---|---|
| `गुणक-बन्धः` | `m² ≤ 4D` at every turn obeying the choice rule — from `CakravalaBound`'s own conclusion `16E² ≤ 36·D·K²` together with its invariant `K² ≤ 4D`. |
| `कोष्ठकः` | `x² ≤ c < B²` gives `x < B`. The box, as an inequality between naturals. |
| `अङ्कनम्`, `अङ्कन-एकत्वम्` | the state (m, K) coded as `m·B + K`, and that code **injective** on the box. |
| `अवस्था-पुनरावृत्तिः` | any **B² + 1** turns whose states lie in the box contain two **distinct** turns with the **same** state. Cubical's `pigeonhole`. |
| `प्रत्यावृत्तिः` | over ℤ, from the step's three exact divisions: `a' + b'·(−m) ≡ k'·(−b)`. So **−m already solves the next turn's congruence**, with cofactor −b written out. |
| `षष्ट्येकम्` | D = 61, turn 0 → turn 1, all four equations `refl` in the kernel. |
| `एकोननवत्यधिकनवदशशतम्` | D = 1989, §5 below, in the kernel. |

The proof of `गुणक-बन्धः` is two lines of order algebra: `16E² ≤ 36·D·K² ≤
36·D·4D = (12D)²` gives `4E ≤ 12D`, so `E ≤ 3D`, so `m² = D + E ≤ 4D`. Below
the root the bound is free. The above-the-root branch is where the content is,
and it is exactly the branch the classical account passes over in silence
because the classical account is carrying √D around and this module is not.

`प्रत्यावृत्तिः` is three ring identities:

```
k·(a' + b'·(−m)) = k·a' + (k·b')·(−m)
                 = (am + Db) − (a + bm)·m        [the three exact divisions]
                 = Db − b·m² = (−b)·(m² − D) = (−b)·(k·k') = k·(k'·(−b))
```

and cancelling k. This is also the continued fraction's standard
`P_{i+1} ≡ −P_i (mod Q_{i+1})`, reached here from the cakravāla's own three
divisions rather than imported from the theory that displaced it.

## 4 · The defect, with its failing shape

**A repeated state is a cycle only if the step is deterministic.** Two things
stand between §3 and that, and neither is hand-waving:

1. **The solution set must BE the class of −m.** `प्रत्यावृत्तिः` gives that −m
   is *a* solution. That the solutions are exactly `−m mod k'` needs
   `gcd(b', k') = 1` — the same coprimality
   `CakravalaDescent.oneCongruenceCoprime` already consumes, and which
   `CakravalaDescent.runToCoprime` produces from an actual kuṭṭaka run rather
   than assuming. Wiring that here is mechanical and **is not done**, and
   "mechanical" is not a synonym for done — `CakravalaDescent`'s own header
   records what that phrase cost last time.
2. **Ties.** Bhāskara's rule takes the m minimising |m² − D| over the class.
   By `Varana_TheChoiceWindowIsDerivedNotFitted` the minimiser is one of the
   two bracketing members `lo`, `hi`. **If E_lo ≡ E_hi the rule does not say
   which**, and the next गुणक is then not a function of the state. This is a
   genuine branch of the rule as Bhāskara states it, not an oversight in the
   formalisation, and it is the failing shape: two turns with identical
   (m, k) whose successors differ in m. Whether such a tie can actually occur
   on a cakravāla run is **not** settled here; a tie needs `hi² − lo² = 2E`
   with `hi = lo + K`, and no instance is exhibited.

So the cap is **a bound modulo one named lemma with a stated failing shape**,
where it was a bound modulo three classical facts this morning and a bound
modulo nothing yesterday.

## 5 · A citation corrected — the cakravāla's m is not below √D

`machine/Nalanda.hs` justified `turnCap d = 2*d` as "the classical count of
reduced surds of discriminant 4D — the pairs (P, Q) with 0 < P < √D and
0 < Q < 2√D".

**The first half is false of this algorithm's state.** For D = 1989 the
reactor's turn 0 is (44, 1, −53), `chooseM` selects **m = 62**, and 62² = 3844
against D = 1989 — nearly twice D. Checked in the kernel:
`एकोननवत्यधिकनवदशशतम्.गुणकः-मूलात्-अधिकः : 1989 < 62 · 62`, with `गुणक-बन्धः`
instantiated at the same turn to give the bound the state **does** obey,
62² ≤ 4·1989.

Over every non-square D ≤ 5000, **35 060** of the reactor's turns have m² > D.
That is a count of a finite range, not a law, and nothing is computed
downstream of it.

So `0 < P < √D` counts the reduced surds of the continued fraction of √D, and
the claim that the cakravāla's cycle is a *sub-walk* of that one is a **third**
unchecked input rather than a consequence of the first two. `2·D` was a bound
modulo three classical facts, one of which does not describe the object the
reactor computes.

## 6 · What changed in the reactor

`machine/Nalanda.hs`:

```haskell
turnCap :: Integer -> Int
turnCap d = let b = isqrt (4 * d) + 1 in fromInteger (b * b)
```

B² ≈ 4D, against the old 2D — the cap is roughly twice as loose and it is
never reached in practice (observed worst case 744 turns at D = 195196). A cap
that is loose and sourced is worth more than a cap that is tight and cited.

The `Left` branch now says what exceeding it means: **a state repeated**, which
is a mathematical claim about the run. `400` was never that and `2*d` was never
that.

`selfTest` passes unchanged; D = 61 returns Bhāskara's (1766319049, 226153980);
D = 73516 completes in 442 turns with `verify = True`.

## 7 · A live defect found in passing, NOT repaired here

**`formal/cubical/CakravalaBound.agda` does not typecheck under the pin.** Its
import is `Cubical.Tactics.NatSolver.Reflection using (solve)`; v0.9 spells the
macro `solveℕ!` and takes it applied to the bound variables rather than
point-free. One name and twenty-nine call sites.

This is the module the whole termination lane rests on, and
`Varana_TheChoiceWindowIsDerivedNotFitted` already declined to import it for
exactly this reason and restated its lemmas instead. The new module follows
that precedent and takes `straddleBound`'s conclusion as a hypothesis.

**It is not repaired here** because at the time of writing another lane's
working tree is mid-repair of the same skew across the whole directory — the
import lines are already rewritten and the call sites are not. Two agents
editing the same rename is how in-flight work gets destroyed (PROTOCOL §5).
The defect is written so it is not lost; the repair is that lane's.

## 8 · What remains open

* **Termination of the cakravāla.** Untouched. This note does not narrow it.
* **The determinism lemma of §4**, in its two parts. This is now the whole gap
  between the cap and a theorem, and it is one module's work rather than "a
  reduction theory".
* **Whether a tie can occur.** No instance, no proof of impossibility.
* **Sharpening the box.** The proved bound is m² ≤ 4D; over every non-square
  D ≤ 5000 the observed maximum of m²/(4D) is 0.485 and of k²/(4D) is 0.971.
  The k bound is nearly tight; the m bound looks like it has a factor 2 in it.
  Two ratios over one range are two ratios over one range, and nothing here is
  fitted to them — the point of quoting them is that the *k* side is already
  sharp, so any improvement has to come from the *m* side.
* **The new module is not in `Everything.agda`.** It is an orphan of the
  aggregate, so nothing re-runs it, which `formal/cubical/BUILD.md` names as
  exactly the hole that lets a green claim rot. It is left out deliberately:
  `Everything.agda` is dirty in another lane's working tree as of this
  writing, and folding a line into a file someone else is mid-edit trades one
  defect for a worse one. **Folding it in is the next commit anyone can make
  once that lane lands**, and until then the green claim for this module is
  the single-file run recorded in §3 and nothing wider.
