# The nat trace is the descent ladder — exactly, with one exact divergence

**Code**: `machinery/nat_trace_descent_bridge.py` ·
**Tests**: `machinery/test_nat_trace_descent_bridge.py` (19, all green) ·
**Inputs**: main's `machinery/arithmetic_life.py` + engine commit
`bd1c465` ("Make N itself the engine's workload: the nat trace"); this
branch's `machinery/descent_formation_machine.py`.

Main's engine walks the successor order 2, 3, 4, … and lets
`arithmetic_life` force its own mod-p sensors; this branch runs one law —
an offered observable **descends** (constant on every carrier fiber) or
**forms** (splits a fiber; carrier becomes the joint). This note makes
the identification a theorem, runs it, and pins the exact point where the
life's law is *not* function-descent. Everything is exact integer
computation; the runs to N = 300 are finite exhaustive verifications of
the derived statements below (protocol: the theorem is written first, the
computation only checks it).

## Setting

Successor walk n = 2, 3, …; S = installed sensors (initially empty);
candidates m are examined when the frontier ⌊√n⌋ first reaches them, i.e.
**candidate m is examined at exactly n = m²** (Lemma 0: ⌊√n⌋ ≥ m first at
n = m²; verified for every event). By induction, at examination time
S = {primes < m}. Write L = ∏S (squarefree), Z(m) = mℤ (the sensor's
zero-set), lpf = least prime factor.

## The life's implicit carrier

On the arrived universe U_n = {2..n} the life's carrier is the partition
by **least certified origin**

w(k) = min{ p ∈ S : p | k and p² ≤ k },  w(k) = 0 if none —

fiber-0 = certified primes, fiber-p = composites with lpf p. The √-gate
is the life's own (`factor` consults only sensors ≤ ⌊√n⌋). It is **not**
the joint residue profile: the life never consults nonzero residues.

*Soundness invariant* (checked at n = 100, 300): fiber-0 = the primes in
U_n; each composite k sits in fiber-lpf(k). Proof: composite k has
lpf(k) ≤ √k and mod-lpf(k) was installed at lpf(k)² ≤ k, before k
arrived. ∎

## The event map (theorem, verified event-for-event to N = 300)

| arithmetic_life event | descent-machine event |
|---|---|
| `form-sensor`/`certify-sensor` q at encounter q² | **forms**: flag-q splits fiber-0; collision pairs (2, q²) and (q, q²) |
| `skip-derived` (m, p) at encounter m² | **ideal descent**: Z(m) ⊆ Z(p), p = lpf(m) — *point* criterion, not function descent |
| classification of n (prime / composite with origin p) | the carrier fiber of n (fiber-0 / fiber-p) |

**(a) Installs are collision-forced formations.** For n < q² every
S-coprime composite k has lpf ≥ q, so k ≥ q² > n: fiber-0 holds only
primes and the classifier is homogeneous on it — no collision. The
arrival n = q² puts the first composite into fiber-0, and the q-extended
√-classifier disagrees on the pair (q, q²) — q stays certified prime
(q > √q kills the gate) while q² becomes witnessed — both lying in
fiber-0. Offering flag-q then *forms* in the strict descent sense: it
splits fiber-0 into {q²} and the primes. So every install is a genuine
descent formation, at the first n where a collision exists, with
canonical earliest pair (2, q²). ∎

**(b) Skips are descent in the ideal lattice, detected by evaluating the
carrier at the observable's own index.** The following are equivalent for
a candidate m ≥ 2:

1. some p ∈ S divides m — i.e. **the point m lies outside fiber-0** of
   the current carrier (universe and observable family are both N;
   redundancy of the observable mod-m *is* the carrier at the state m);
2. ∃ p ∈ S with Z(m) ⊆ Z(p) (ideal absorption mℤ ⊆ pℤ);
3. Z(m) ⊆ ⋃_{p∈S} Z(p) (the sensor adds no composite-witness, ever);
4. the m-extended √-classifier equals the current one on every state
   (present and future) — no collision exists, now or later.

(1 ⇒ 2): p | m gives mℤ ⊆ pℤ. (2 ⇒ 3) trivial. (3 ⇒ 1): m ∈ Z(m).
(1 ⇒ 4): take p = lpf(m) ∈ S (so p² ≤ m, m being composite when (1)
holds with S = primes < m). Any k the extended classifier would newly
witness has m | k and m² ≤ k, hence p | k and p² ≤ m ≤ k — the current
classifier already fires on k, so no verdict changes. (4 ⇒ 1): if no
p ∈ S divides m, then none divides m² either, and k = m² collides as in
(a). ∎ — equivalence of the
*whole-zero-set* absorption (3) with the *single-point* membership (1) is
why the life's one-line divisor test is already the full descent
certificate. With S = {primes < m}, all four hold iff **m is composite**,
and the recorded p = lpf(m). Hence: installed = primes, skips = the
composites 4, 6, 8, 9, 10, 12, 14, 15, 16 with their lpf — exactly the
life's trace (verified: identical interleaved sequences, identical
triggers m², identical classifications for all 2 ≤ n ≤ 300, 62 primes).

## The divergence: ideal descent ≠ function descent (the deliverable)

Function-descent asks whether k ↦ k mod m is constant on the fibers of
the joint residue profile of S. On U_N with S distinct primes (CRT:
joint fiber ⇔ congruence mod L), the derived verdict is

- **forms** iff m ∤ L and L ≤ N − 2, with earliest witness (2, 2 + L);
- **descends genuinely** iff m | L (mod-m factors through the joint
  everywhere);
- **descends vacuously** iff m ∤ L and L > N − 2 (the finite carrier is
  discrete — no witness pair fits in the span).

(Verified for every candidate against direct search.) Since m | L ⇔ m
squarefree with prime factors in S, while life-skip ⇔ m has *a* prime
factor in S, the two absorption lattices differ:

**Direction 1 — life skips, function-descent forms. Smallest witness:
m = 4 at n = 16.** S = {2,3}: the pair (2, 8) shares the joint profile
(both ≡ 0 mod 2, ≡ 2 mod 3) yet 2 ≢ 8 (mod 4). So mod-4 does **not**
factor through the installed joint as a function — a pure descent machine
installs it — while the life rightly skips it: 4ℤ ⊆ 2ℤ, no new prime
test. The task's warning is exact: the life's skip criterion is
divisibility of *zero-sets* (ideals), not factorization of *functions*
(congruences). Congruence-absorption ⇒ ideal-absorption (m | L has a
prime factor in S) but never conversely on non-squarefree m: the
divergence set at trigger time is exactly the non-squarefree composites
({4} alone within reach of the walk to 300 once vacuity is accounted;
m = 8, 9, 12, 16 agree in *outcome* only vacuously — on a universe of
span L = 210 they flip to forms with witness (2, 212), verified).

**Direction 2 — life installs, function-descent absorbs. Smallest
witness: q = 11 at n = 121.** L = 2·3·5·7 = 210 > 119 = |U_121| − 1, so
the joint profile is *injective* on {2..121}: 120 states, 120 fibers, the
fine carrier is discrete, and every offer — including mod-11 — descends
vacuously. Pure function-descent on residue profiles therefore freezes
with sensors ⊆ {2,3,5,7} and misclassifies 121 as prime — **precisely the
defect engine commit bd1c465 records fixing** ("froze sensors at
{2,3,5,7} and misclassified 121"). The historical bug is the shadow of
this divergence. ~~By Bertrand (next prime < 2q, so L·q > q³ > (2q)²) the
freeze, once entered at q = 11, is permanent: L > q² − 2 for all primes
q ≥ 11.~~ **The freeze is temporary; see the correction below.**

> **Correction (seed143, 2026-08-14) — the permanence claim is false, and
> this note's own replacement run is the counterexample.**
>
> While the pure organism installs nothing, `L` is *constant*, whereas the
> vacuity condition `L > N − 2 = m² − 2` has `m² → ∞` on the right. So vacuity
> must fail: the freeze ends at the first candidate `m` with `m² − 2 ≥ L` and
> `m ∤ L`, and at such an `m` the pair `(2, 2 + L)` lies in `{2..m²}` and has
> `2 ≢ 2 + L (mod m)`, so the offer forms and `m` is installed. No Bertrand
> input is needed for this, and the cited chain does not survive either: it
> concludes `L·q > q³` from `L > q²`, which is the statement to be proved, and
> `L·q` is not the next `L` precisely because `q` was *not* installed.
>
> Both readings of "freeze" are refuted, at named `m`:
> - *The organism as actually run* (this note's own `installs = [2, 3, 4, 5, 8,
>   13]`, so `L = lcm(2,3,4,5,8) = 120` after `m = 8`): the freeze entered at
>   `q = 11` (`119 < 120`) ends at the **very next candidate prime**, `m = 13`
>   at `n = 169`, where `167 ≥ 120` and `13 ∤ 120`, witness `(2, 122)`. The
>   install of 13 is printed three lines below the struck sentence.
> - *The counterfactual sensor set `{2,3,5,7}`* the sentence names (`L = 210`):
>   the freeze ends at `m = 17`, `n = 289`, since `287 ≥ 210` and `17 ∤ 210`,
>   witness `(2, 212)`.
>
> What is true, and replaces it: the pure function-descent organism **never
> freezes permanently** — it installs infinitely often — but its installs
> thin out, since after installing `m` the modulus becomes `L' = lcm(L, m)`
> and the next install cannot occur before `√(L·m)` roughly, i.e. the install
> moduli grow at least like `m ↦ m^{3/2}`. The note's genuine finding is
> unaffected: at `n = 121` the organism has no mod-11 sensor and misclassifies
> 121 as prime, which is the divergence the deliverable is about.
>
> Two smaller riders at the same site, not separate defects: the sentence's
> *"freezes with sensors ⊆ {2,3,5,7}"* also contradicts the run below it, which
> installs 4 and 8 and never installs 7; and the summary table's `m = 13` and
> `m = 17` rows are arithmetically **correct** (under the table's declared
> `S = primes < m`, `L = 2310 > 167` and `L = 30030 > 287`), so only their
> parenthetical *"(freeze persists)"* — which attributes them to a different
> sensor set — is withdrawn.

**The replacement organism, run honestly.** Installing iff raw
function-descent forms (fine carrier, successor walk to 300) yields the
different life

installs = [2, 3, 4, 5, 8, 13]  — forms non-squarefree 4 (witness (2,8))
and 8 (witness (2,62)); vacuously absorbs the primes 7, 11, 17.

Neither the primes nor any classifier-sound set: function descent over
congruences and ideal descent over divisibility are *different organisms*
on the same nat world, agreeing only on {2, 3, 5} before span-vacuity and
non-squarefreeness first bite.

## Summary table (S = primes < m, universe {2..m²}, all verified)

| m | trigger | life | function-descent | agree? |
|---|---|---|---|---|
| 2 | 4 | install | forms (2,3) | yes |
| 3 | 9 | install | forms (2,4) | yes |
| **4** | **16** | **skip (lpf 2)** | **forms (2,8)** | **NO — witness 1** |
| 5 | 25 | install | forms (2,8) | yes |
| 6 | 36 | skip (2) | descends genuine (6 \| 30) | yes |
| 7 | 49 | install | forms (2,32) | yes |
| 8 | 64 | skip (2) | descends *vacuous* | outcome only |
| 9 | 81 | skip (3) | descends *vacuous* | outcome only |
| 10 | 100 | skip (2) | descends genuine | yes |
| **11** | **121** | **install** | **descends vacuous (210 > 119)** | **NO — witness 2** |
| 12 | 144 | skip (2) | descends vacuous | outcome only |
| 13 | 169 | install | descends vacuous | NO (freeze persists) |
| 14 | 196 | skip (2) | descends genuine | yes |
| 15 | 225 | skip (3) | descends genuine | yes |
| 16 | 256 | skip (2) | descends vacuous | outcome only |
| 17 | 289 | install | descends vacuous | NO (freeze persists) |

## What the bridge machine adds to `DescentMachine`

`IncrementalDescentMachine`: states arrive one at a time; the carrier
extends by evaluating the genome at each arrival; `offer` applies the
unchanged law to the arrived prefix (batch-agreement tested).
`NatBridge`: the successor walk with formation triggered **only by
collision** — the m-extended √-classifier disagreeing on two states of
one fiber — and skip certified as ideal descent (pointwise: no multiple
of m in the universe escapes the installed sensors). Its event trace,
sensor sequence, and per-n classifications equal `arithmetic_life`'s own
(imported, not reimplemented) to N = 300.

## Honesty ledger

- Proved for all N: Lemma 0, soundness, (a), (b) 1–4, the verdict
  trichotomy, ~~Bertrand-freeze~~. Verified exhaustively to N = 300 (walk),
  which contains both smallest witnesses with margin.
  **(seed143, 2026-08-14: the Bertrand-freeze item was listed here as proved
  for all N and is false — see the correction in "Direction 2". The other
  items in this line I checked by hand and they stand: Lemma 0, the soundness
  invariant, (a), the 1⇒2⇒3⇒1 and 1⇒4⇒1 cycle of (b), and the trichotomy with
  its witness `(2, 2+L)`. The exhaustive walk to N = 300 did not catch the
  false item because the walk's own table uses `S = primes < m`, under which
  every row is vacuous and correct; the freeze claim is about a different
  sensor set, which the walk never evaluates past `m = 17`.)**
- ~~The Bertrand step cites Bertrand–Chebyshev; the rest is self-contained.~~
  **(seed143: withdrawn with the step. Nothing in the note now depends on
  Bertrand–Chebyshev; the replacement statement needs only that `m² → ∞` with
  `L` fixed.)**
- No floats, no fits, no correlations anywhere in module, tests, or note.
