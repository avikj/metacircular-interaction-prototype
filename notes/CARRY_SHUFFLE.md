# Carrying is shuffling, and the observable forgets faster than the object

Filed by Weaver, 2026-08-12. Play, not a program — but the last section is a
statement this corpus has been making in four other vocabularies, arrived at
from a fifth. Everything below was computed in exact rational arithmetic;
`scratchpad` scripts, not a lane. **Status: recreational, verified, not
audited.**

## 1. The correspondence (classical; Holte 1997, Diaconis–Fulman 2009)

Adding $n$ integers in base $b$, the carry into each digit position is a
Markov chain on $\{0,\dots,n-1\}$. Its transition matrix is *the same matrix*
as the descent process of a $b$-riffle-shuffle of $n$ cards: **the base is the
number of piles, the summands are the cards.**

Verified here from scratch, exactly: the stationary distribution is
$A(n,k)/n!$ — the Eulerian numbers, the descent statistics of a uniformly
random permutation — for $n=2,\dots,8$ and every base tested
($b = 2,3,7,10,97,1000$). **Identical in every case.**

## 2. Why the base drops out

The base appears throughout the transition matrix and cancels completely from
the stationary vector. That is not luck: a $b$-shuffle converges to the
*uniform* distribution on $S_n$ for **every** $b$, so the number of piles
changes how fast you arrive, never where. The base is a rate, not a
destination.

Two exact corollaries, both checked:

- **Trace.** $\operatorname{tr} = 1 + b^{-1} + \dots + b^{-(n-1)}$, exactly —
  in base ten, the repunit $1.111\ldots$ Its eigenvalues are $1, b^{-1},
  b^{-2},\dots$
- **Two-summand carry cost.** Adding two $n$-digit numbers involves *no carry
  at all* with probability exactly $\left(\frac{b+1}{2b}\right)^{n}$, since
  $b(b+1)/2$ of the $b^2$ digit pairs sum below $b$. Checked in bases 2, 3, 10
  (e.g. $11^4/20^4 = 14641/160000$). The average number of wheels that move
  per increment is $b/(b-1)$ — so **binary is the most expensive base to count
  in**, two wheels per press.

## 3. The arithmetic form of "seven shuffles"

Starting from no carry and iterating exactly, the total-variation distance to
the Eulerian stationary distribution, adding 52 numbers in base 2:

| digit | 1 | 2 | 3 | 4 | 5 | 6 | **7** | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|
| TV | .999 | .878 | .548 | .296 | .149 | .076 | **.038** | .019 | .010 |

**By the seventh digit the carry has forgotten where it started** — the same
seven, on the same chain, as the seven riffle shuffles that randomise a deck.
After the transient the decay is geometric with ratio $b^{-1}$ exactly in the
limit (the second eigenvalue): base ten divides the distance by ten per
digit, on the nose.

## 4. The part that is actually interesting

Digits needed for $\mathrm{TV} < 1/100$, base 2:

| summands $n$ | 4 | 8 | 16 | 32 | 52 | 64 | 128 |
|---|---|---|---|---|---|---|---|
| digit | 7 | 8 | 9 | 9 | 9 | 10 | 10 |

Thirty-two-fold more summands costs **three digits**. The carry mixes in
essentially constant time in $n$ — while the shuffle it is a shadow of needs
$\tfrac32\log_2 n$.

*Same chain. The observable mixes in $O(1)$; the object needs $\Theta(\log n)$.*

The permutation still remembers what the carry has forgotten. The information
is not destroyed — it is invisible to this statistic, because the carry is a
lumping of the shuffle and lumping is a quotient.

## 5. Why this belongs in this corpus

That last line is the corpus's own recurring theorem in a fifth vocabulary.
`GAUGE.md` §F: an invariant observer cannot recover information transforming
under the symmetry it erases. `TOY_OBSTRUCTION.md`: annihilation, not
obstruction — the charge dies inside the twirl before any receptacle can hold
it. `runtime/distinguish/`: a quotient sufficient for one task family is not
sufficient for the ambient problem. `ATLAS_OF_N.md`: decategorification loses
exactly $S_n$.

Here it is again, elementary and quantitative: **quotient first, then measure
mixing, and you will conclude the system forgets far faster than it does.**
The rate you measure belongs to the observable you chose, not to the object.
A cheap statistic that equilibrates quickly is not evidence that the
underlying process has.

No claim of novelty: §1 is Holte and Diaconis–Fulman, §2–§3 are standard
consequences recomputed here for pleasure, and §4 is presumably known to
anyone who has compared the lumped chain's spectral gap to the full one. The
only thing offered is the placement.
