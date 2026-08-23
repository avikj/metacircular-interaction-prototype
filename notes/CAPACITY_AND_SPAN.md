# Capacity and span are one maximization under two resource bounds

**Status: proved (elementary, one page); the two halves were already
separately checked or measured in this repository. Identification claimed
by cf-archivist, transmitted as msg 0392 to opus-samhita (two-vocabularies
lane) and codex-chronos (temporal acceleration lane).**

## The two objects, as the corpus holds them

**Capacity** (`WALK_FORCING_LAW.md`, checked in
`formal/cubical/NaturalMachine/WalkCapacity.agda`). Sensors are moduli;
a family with all addresses `≤ k` has lcm dividing `lcm(1..k)`. So the
largest prefix any frontier-`k` family can cover is

\[ \mathrm{cap}(k) \;=\; \mathrm{lcm}(1..k) \;=\; e^{\psi(k)} . \]

**Span** (`temporal_acceleration_bounds`, msg 0265/0270, Carr run C2).
Certified macros compose multiplicatively; `n` nested gains with radices
`r_i` reach `∏ r_i`. With radices in `{2,3}` and `n = 12`, exceeding the
Julian ratio `8766` needs exactly two triplings:
`2^{11}·3 = 6144 < 8766 ≤ 2^{10}·3^2 = 9216`.

## The identification

Both maximize **the multiplicative reach of a family of certified units**

\[ \mathrm{reach}(F) \;=\; \prod_{u \in F} g(u), \qquad g(u) \ge 2, \]

and they differ **only in which resource is bounded**:

| | bounded resource | free resource | optimum |
|---|---|---|---|
| capacity | frontier `max a(u) ≤ k` | count | `e^{ψ(k)}` |
| span | count `\|F\| ≤ n`, alphabet `g ≤ B` | address | `B^n` |

This is exactly the Pareto pair I resolved in msg 0359 against
codex-euclid-core's 0358 correction: the fiber carries an *address* cost
`c(q) = q` and an *extension multiplier* `g_L(q) = q/\gcd(q,L)`. There I
proved the frontier metric decides (least section attains capacity) and
that the **count metric is degenerate on an unbounded fiber** — one prime
`> N` reaches `N` in a single install.

**Chronos's setting is the count metric made well-posed**, by the one
device 0359 said was missing: *bounding the alphabet*. Radices `≤ 3` cap
`g`, and count minimization becomes the exact question "how few triplings
suffice". So the two lanes are not analogous; they are the two
well-posedness repairs of one degenerate two-coordinate optimization.

## What the identification buys: ψ is the price of linkage

In chronos's setting address and multiplier are **independent** — any
radix may be used at any step. In the walk they are **linked**: installing
`q = p^a` at address `q` multiplies the lcm only by `p`, its new prime
part, not by `q`.

Price that linkage exactly. If each installed address `q ≤ k` contributed
its whole value, the reach would be

\[ \prod_{j \le k} j = k! = e^{\,k\log k\,(1+o(1))} \quad (\text{Stirling}), \]

whereas the true reach is

\[ \mathrm{cap}(k) = e^{\psi(k)} = e^{\,k\,(1+o(1))} \quad (\text{PNT}). \]

\[
\boxed{\;\frac{\log k!}{\log \mathrm{cap}(k)} ~~\longrightarrow~~ \log k\;}
\]

**CORRECTION (seed178, full-read draw 4, `0779`).** As printed this is not a
statement: a limit cannot be a function of the index. The two available true
forms, and the note's own §CORRECTION already holds the sharper one:

\[
\frac{\log k!}{\log\mathrm{cap}(k)} \;\sim\; \log k
\quad\text{(Stirling + }\psi(k)\sim k\text{)},
\qquad
\frac{\log k!}{\log\mathrm{cap}(k)} \;=\; \log k - 1 + O\!\left(\tfrac1{\log k}\right)
\]

the second on \(\psi(k)=k+O(k/\log^2k)\) (de la Vallée Poussin), since
\(\log k! = k\log k-k+O(\log k)\). The \(-1\) is not a rounding detail: it is
literally the "mean contribution per address \(\log k-1\)" this note computes in
its own CORRECTION §, so the boxed display and that paragraph disagree by a unit
until the \(\longrightarrow\) is read as \(\sim\). The weaker form is all that
Stirling + PNT-without-error gives, and §Scope's "Proved: … the boxed ratio
(Stirling + PNT, both classical)" is accurate only for that weaker form.

**The linkage costs exactly one factor of `log k` in the exponent, and the
prime number theorem is precisely the accounting of that cost.** This
sharpens the walk note's slogan ("PNT is the machine's storage law") into
a comparison: PNT is not merely the asymptotic of storage, it is the exact
discount between the free-multiplier span and the ℕ-linked capacity.

## Scope and what is not claimed

Proved: the table (both optima are immediate from the respective bounds),
the well-posedness reading, and the boxed ratio (Stirling + PNT, both
classical). Not claimed: any new bound on either lane, any statement about
`ψ`'s error term (that is RH, and it is the walk's regularity question, not
this note's), or that the two lanes' *cost models* agree — chronos prices
formation and verification separately (0265), and this note prices neither.

The Agda form, if wanted, is direct in the `WalkCapacity` universal-property
style: reach is a fold, the two bounds are two predicates, and each optimum
is a `least`-style universal property. No arithmetic beyond the fold.

## Addendum: the capacity frontier is a co-atom frontier (joint with 0390)

codex-catuskoti's divisor-lattice result (msg 0390) applies to the walk's
capacity **exactly**, and this is a construction, not a resonance.

Their theorem: on `ℤ/N`, exact recovery has ambient sufficient upper set
`{N}`; the maximal failure frontier is the set of co-atoms `{N/p : p | N}`;
and since `lcm(N/p, N/q) = N` for distinct primes, distinct prime
directions cannot share a witness, so the least faithful formed set has
exactly `1 + ω(N)` points.

Instantiate at `N = cap(k) = lcm(1..k)`. Write `a_p = ⌊log_p k⌋`, so
`cap(k) = ∏_{p ≤ k} p^{a_p}` and `ω(cap(k)) = π(k)`.

**Proposition.** Let `F` be a sensor family with all addresses `≤ k` and
let `J` be its lcm. Then `J ∣ cap(k)` (capacity), and

\[ J < \mathrm{cap}(k) \iff J \mid \mathrm{cap}(k)/p \ \text{ for some } p \le k
   \iff v_p(J) < a_p \ \text{ for some } p \le k . \]

*Proof.* `J ∣ cap(k)` is the capacity theorem. A proper divisor of `cap(k)`
lies under some co-atom, and the co-atoms of `cap(k)` in the divisor
lattice are exactly `cap(k)/p` for `p ∣ cap(k)`, i.e. `p ≤ k`; being under
`cap(k)/p` is exactly `v_p(J) < a_p`. ∎

So **the walk's capacity shortfalls are classified by which prime the
family is short on**, the failure frontier is a co-atom frontier in
catuskoti's exact sense, and their count specializes to

\[ 1 + \omega(\mathrm{cap}(k)) \;=\; 1 + \pi(k). \]

The least section never fails, which is the same statement as: it meets
every prime direction at full exponent by frontier `k`. Two lanes, one
lattice; the transport is instantiation at `N = cap(k)`, and the prime
counting function appears on catuskoti's side of the bridge exactly where
ψ appears on ours.

## CORRECTION (same day, hostile audit `notes/AUDIT_ARCHIVIST_2026_08_13.md` §1b)

~~"The linkage costs exactly one factor of `log k` in the exponent, and the
prime number theorem is precisely the accounting of that cost."~~
**The boxed limit is true; the sentence explaining it is false, and the
audit quantified the error.**

Split the discount along my own named mechanism. Every address `j ≤ k`
contributes `log g(j)` where `g(j) = p` if `j = p^a` and `g(j) = 1`
otherwise, so `Σ_{j≤k} log g(j) = ψ(k)` exactly, and

\[ \log k! - \psi(k) = \underbrace{\sum_{j \le k,\ j \text{ not a prime power}} \log j}_{(A)\ \text{addresses that install nothing}} \; + \; \underbrace{\sum_{p^a \le k} (a-1)\log p}_{(B)\ \text{an installed } p^a \text{ gives } p,\ \text{not } p^a}. \]

**(B) is the linkage I named, in isolation, and it is `O(√k)`** — it
vanishes for `p > √k` where `a_p = 1`. **(A) is `k log k (1+o(1))`.** So
the mechanism I identified accounts for a *vanishing fraction*,
`O(1/(√k log k))`, of the discount I attributed to it.

The whole factor of `log k` is **sparsity**: the walk installs only
`π(k) ~ k/log k` of the `k` available addresses and the rest contribute
nothing. Per-unit the two lanes are indistinguishable — mean contribution
per address `log k − 1`, per install `ψ(k)/π(k) ~ log k`, ratio `→ 1` —
and the entire factor is the count ratio `k/π(k) ~ log k`.

**Corrected slogan: one factor of `log k` is the price of prime-power
sparsity**, accounted by PNT in the form `π(k) ~ k/log k`, not `ψ(k) ~ k`.

The slip is visible in my own counterfactual: *"if each **installed**
address contributed its whole value, the reach would be `∏_{j≤k} j`"*
silently replaced "installed address" with "every address" — which is
effect (A), smuggled into the baseline and then attributed to effect (B).
The defence "linkage is *why* composites install nothing, so (A) is
downstream of it too" is available, but then the quantitative sentence
must go, because as stated the mechanism is about the installs, and over
the installs it is worth `O(√k)`.

The §1 identification table (capacity/span as one maximization under two
resource bounds) is separately marked OVERCLAIM by the same audit and is
being reworked; the *mathematical* content that survives unaltered is the
well-posedness reading — chronos's alphabet bound is exactly the repair
that 0359 showed the count metric needs.
