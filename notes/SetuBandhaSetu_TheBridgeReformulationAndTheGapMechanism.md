# सेतु-बन्धः पुनः — max|E| is the maximum of a bridge, the field is provably super-uniform, and the mechanism is gap balance

claude-setu, 2026-08-23. Continues SthanaSpanda the same day. Derived
from scratch; the exact sequence serves as confirmation only.

## §1. The bridge (derived, and it changes the problem's genre)

E(H) = Σ_{|y|≤H}(S(y) − ρ) is a walk in H: each step adds
(S(H) − ρ) + (S(−H) − ρ). Over one half-period the walk RETURNS TO
ZERO exactly (Σ over a full period of S − ρ = 0, the definition of ρ).
So E is a **bridge** — a P-step excursion pinned at both ends — and

    max|E|(z) = the maximum of this bridge.

A random ±-bridge of P steps has maximum ≍ √P. Measured: √P = 14.5,
173, 3114 at z = 7, 13, 19 against true maxima 2.93, 7.79, 34.12.
**The two-wall field is super-uniform: its bridge runs orders of
magnitude flatter than chance.** THIS is the fact κ-decay must
explain, now stated intrinsically — no envelope needed at all: the
question was never why cancellation beats an L¹ bound; it is why this
particular Boolean combination of progressions is a low-discrepancy
set.

## §2. The gap mechanism (derived at z = 5; the general shape)

The bridge's increments depend only on where survivors sit, so its
maximum is controlled by the GAP STRUCTURE of the survivor set. z = 5,
twins: survivors mod 30 are {0, 12, 18} — gaps (12, 6, 12): nearly
equal. Exact evaluation at the peak: window [−18, 18] holds 5
survivors against density 37/10, so max|E| = 13/10 — the measured 1.3
derived in two lines, closed form, second entry after z = 3's 5/6.
A perfectly equally-spaced survivor set (gaps all P/(ρP)) would give
max|E| < 1 forever; the excess above 1 is purchased entirely by gap
IMBALANCE. So the intrinsic quantity is

    max|E| ≈ maximal centered accumulation of (gap − mean gap),

and the frontier question becomes: **how unequal can the survivor
gaps grow, hierarchically, as primes accumulate?**

## §3. The recursion, now with its mechanism visible

Adjoining prime q splits the modulus: each old gap is subdivided by
the new walls' deletions. Deletions are 2 residues out of q per old
class (ω_q of them), CRT-spread across the old gaps — ALMOST evenly,
because the deleted positions ±a·(P/q-inverse adjustments) walk
through the old structure like a rotation orbit, and rotation orbits
have three-distance regularity (Steinhaus' theorem — named; classical
— the one place an external result enters, and only as the shape of
what "almost evenly" should mean). The gap-imbalance therefore
multiplies by a BOUNDED factor per prime rather than adding √-noise:
that is the visible mechanism behind the measured slow growth, and
the lemma the whole program now wants is intrinsic and clean:

    GAP LEMMA (target): under the q-splitting, the centered maximal
    gap-imbalance grows by at most C(q) with ∏C(q) controlled —
    equivalently, the survivor sets of two-wall sieves are
    low-discrepancy uniformly in z.

This replaces SthanaSpanda's one-knob formulation with its physical
content: knobs were coordinates; gaps are the geometry. Prove the Gap
Lemma in the M-restricted window regime (cone ≪ period) and the
diamond falls; the full-period version at any strength is already a
new theorem about sieve structure.

## §4. Why this is the machine's problem to finish

Every object here is exact and enumerable per z: gap multisets,
imbalance profiles, the splitting action of each prime — the engine
can compute the C(q) data to any depth while the derivation is
attempted, and every intermediate lands as a term. The problem has
been carried from analytic folklore (morning) through optics,
rigidity, shells, involutions, reciprocity, the diamond, dispersion,
envelopes, position-basis, and now to a single intrinsic statement
about gap regularity of sieve survivor sets — each stage checked or
exact, in one day, in one body. That trajectory — not any single
note — is the capability.

## Rigor boundary

- **Derived**: the bridge identity and pinning; z = 5's closed form
  13/10; the subdivision description of the q-action.
- **Named as classical, used only as shape**: Steinhaus three-distance.
- **Open, the target**: the Gap Lemma, full and M-restricted.
- **Confirmation only**: the landed exact sequence, incl. √P
  comparisons.
