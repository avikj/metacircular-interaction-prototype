# दोषलेखः — the cakravāla's 400-turn cap is not a bound, and D = 73516 is where it fails

*Written 2026-08-20. `AHIMSA_SUTRA_VISTARA` §6: `अन्यो मार्गो दोषलेखः` — two
paths and no third; where transport is impossible the defect is written.
`लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।`*

---

## 1 · The line

`machine/Nalanda.hs`, the reactor's main loop:

```haskell
      | n > 400   = Left ("no convergence in 400 turns; last " ++ show t)
```

and again in `cakravalaWide`:

```haskell
      | n > 400 = Left "no convergence"
```

## 2 · What it is standing in for

Termination of the cakravāla. That is open. `formal/cubical/CakravalaBound.agda`
says so in its own words, and says exactly how far the checked work reaches:

> **TERMINATION IS STILL OPEN.** A bound on |k| is not termination. What the
> bound buys is that the state (a mod ·, b mod ·, k) ranges over a FINITE set,
> so some state must recur; turning that into "the wheel returns to k = ±1"
> needs, in addition: that the triples with a fixed k and bounded a, b are
> finite (a reduction theory), and that the cycle cannot stall. None of that
> is here.

So the loop needs a stopping condition and the theorem that would supply one
does not exist in this repository. `400` is what was put there instead. It is
not derived from `CakravalaBound`'s window `k² ≤ 4D`, not from the length of
the vallī, not from anything: it is a number.

That is the failure mode `HOLOGRAM.md` §7 records, in its purest form. A
constant chosen at one scale hides its scaling. The turn count of the
cakravāla is not O(1) in D — it tracks the period of the continued fraction
of √D, which grows like √D — so **no constant cap can be correct**, and the
only question was where the one that was chosen breaks.

## 3 · Where it breaks

**D = 73516.** Exact Integer arithmetic, no floating point, `machine/Nalanda.hs`
unmodified:

```
isqrt 73516 = 271,  perfect square? False

cakravala 73516
  = Left "no convergence in 400 turns; last Triple {tA = 3232379226779652416...
```

The reactor reports failure. The solution exists, and the same code with the
cap lifted reaches it in **441 turns**:

```
a = 4394076266267276100569609365900897221147705042847411809528567103634152982749
    2279628417274928724923010926850031025962094120248916487155481093683960323654
    18880489479422809289609108988705295218857094208364340714969726589442913526121
    827375812391049429236789936001376502422111068974311259558574882023711538058318790383280199
b = 1620603065163259618410586692793962545197647968335823932863503173024077854715
    7881024360934252717851041975759745435709229600733050815877592509400644277274
    60423663332893304982957827615352357986940865906015734670826958657234118877941
    4107618062506459433403732022406351710899567956783548466215253788654485859313341991875090

a² − 73516·b² = 1        (`Nalanda.verify` recomputes it: True)
```

**73516 is the smallest such D.** Every D from 2 to 73516 was run to
completion with the cap lifted to 100000 and the turn counts compared;
73516 is the first to exceed 400. Below it the maximum is 204 turns, at
D = 19804. This is a finite exhaustive verification over exact integers,
which `CLAUDE.md` admits as proof, not a sample.

The density is not marginal either: **1370** values of D ≤ 200000 need more
than 400 turns, and the maximum over that range is **744 turns, at D = 195196**.

Two more numbers, so the scaling is on the record and not left to be
rediscovered:

| range | max turns | at D | √D | turns/√D |
|---|---|---|---|---|
| D ≤ 20000 | 204 | 19804 | 141 | 1.45 |
| D ≤ 200000 | 744 | 195196 | 442 | 1.68 |

That ratio is quoted to show the *shape* — the growth is in √D and not in a
constant — and for no other purpose. It is not a fitted law and nothing is
computed downstream of it; per `CLAUDE.md`, a pattern over two points is a
pattern over two points.

## 4 · What was done about it

`machine/Nalanda.hs` is repaired in the same commit as this note:

1. **The cap is a parameter**, and the default is `2·D`, which is the
   classical count of reduced surds of discriminant 4D — the pairs (P, Q)
   with 0 < P < √D and 0 < Q < 2√D — and therefore bounds the period of the
   continued fraction of √D, which the cakravāla's cycle is a sub-walk of.
   **Neither of those two classical facts is checked in this repository**, so
   `2·D` is a bound modulo two named unproved inputs. That is strictly better
   than `400`, which is a bound modulo nothing, and it is stated as exactly
   what it is rather than presented as settled.
2. **The failure carries its remainder.** The `Left` branch now reports the
   turn reached, the cap, the last triple, and the norms already visited —
   which are solved equations in their own right (`solveNorm`) and were
   being thrown away with the error. §8 of the sūtra: `यत् शेषं वदति तत् न
   सङ्क्षिपति` — what states its remainder does not collapse. A truncated run
   that reports only "no convergence" has collapsed everything it did reach.

The checked analogue of this discipline is
`formal/cubical/KuttakaSamapti_TheValliIsFiniteForEveryPair.agda` §4–§5: there
the bounded runner's result type has two constructors and no third, so a
truncated run *cannot* fail to name the pair it did not reach, and `पर्याप्तम्`
proves the cap is never hit. That is what a cap with a theorem behind it looks
like. The cakravāla's cap has no theorem behind it, and this file is the
alternative §6 allows.

## 5 · What remains open

* **Termination of the cakravāla.** Untouched. This note does not narrow it.
* **A checked bound on the turn count.** The `2·D` default rests on reduction
  theory that is not in `formal/cubical/`. Putting it there — the finiteness
  of reduced forms of a given discriminant — is the piece that would turn the
  default from *cited* into *checked*, and it is also most of what
  `CakravalaBound.agda` names as missing for termination itself.
* **Whether the cap can be dropped entirely.** It cannot, until termination is
  proved; an unbounded loop in a reactor an LLM talks to at inference time is
  a worse defect than a stated one.

## 6 · A second defect found in the same read, and repaired

`cakravalaWide` — the function `selfTest` uses to check that the ±2 choice
window "is exhaustive, not sampled" — still contained the branch

```haskell
      if n == 1 then Just (isqrt d) else do
```

which `formal/cubical/CakravalaBound.agda` §7 refuted on 2026-08-18 and which
was removed from `chooseM` in the same commit. So the two functions the check
compares differed in their **choice rule** and not only in their window width,
and both rules reach the fundamental solution because *any* m satisfying the
congruence descends. The check therefore passed while testing nothing about
the window. It is corrected to differ only in the window.

The window itself is now derived rather than checked by re-running:
`formal/cubical/Varana_TheChoiceWindowIsDerivedNotFitted.agda` proves that a
window of ±1 around `t0` is exhaustive, from the monotonicity of m ↦ |m² − D|
on either side of √D. `CLAUDE.md`: a comparison of two runs has no content;
the content is the argument that the smaller window loses nothing.
