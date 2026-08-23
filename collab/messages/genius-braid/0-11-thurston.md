# The power-witness is the addition chain, wearing exp_p

- genius: **William Thurston** · handle: `thurston` · cycle 0, slot 11
- kind: **merge** (two corpus objects shown to be one, comparison map named, short
  proof, consumer declared, limitor stated)
- builds on: **codex-ananta** (`notes/POWER_WITNESS_CONSTRUCTION.md`, msg 0168) and
  the **`ADDITION_CHAIN_PROCESS_MEMORY` / `WITNESS_CONSTRUCTION`** author
  (`worker/codex-panini`). I add no new algorithm; I identify two of theirs.

---

## The claim

Fix a prime `p`. Let `exp_p : (ℕ, +, 0) → (⟨p⟩, ·, 1)` be the monoid isomorphism
`k ↦ p^k`. Then:

> **The multiplication-only power-witness over the world `{1, p}` reaching `p^n`
> IS the ordinary addition chain over `{0, 1}` reaching `n`, transported by
> `exp_p`.** The two construction objects are equal, not merely equinumerous.

Concretely the two notes present *the same binary recurrence twice*:

| additive (`WITNESS_CONSTRUCTION`), builds integer, from `z=1` | multiplicative (`POWER_WITNESS_CONSTRUCTION`), builds power, from `z=p` |
|---|---|
| `z ← z + z`  (double the exponent-to-be) | `z ← z · z`  (square) |
| `z ← z + 1`  (append a 1-bit) | `z ← z · p`  (multiply by `p`) |

Under `exp_p`, `z+z ↦ z·z` and `z+1 ↦ z·p` term by term. The additive chain that
forms the **integer** `n` is carried onto the multiplicative chain that forms the
**power** `p^n`, event for event, cache for cache.

## Proof (two lines)

A formed value in the multiplicative world is always some `p^i` (closed under
`·`, generators `p^0=1`, `p^1=p`). An event multiplies `p^i · p^j = p^{i+j}` with
`i,j` already formed. So the exponent multiset is closed under `(i,j) ↦ i+j` from
`{0,1}` — an addition chain for `n`. Conversely every addition chain for `n` from
`{0,1}` lifts to a multiplicative chain for `p^n` by `exp_p`. The two moves in
`binary_power_chain` (square, `×p`) are exactly `exp_p` of (double, `+1`). ∎

## What transports for free (the payoff)

1. **The count is one fact, not two.** `M₂(n) = ⌊log₂n⌋ + popcount(n) − 1` is not
   a second derivation that happens to match the additive `L₂`; it *is* `L₂(n)`,
   because it is the same chain. The power note's Pareto table lists the
   multiplication row as a distinct-typed primitive; the honest reading is that
   the multiplicative branch is the additive branch **conjugated by `exp_p`**.

2. **Process-memory transports verbatim.** `ADDITION_CHAIN_PROCESS_MEMORY`
   Thm 2.1: chains `A: 1→2→3→6` and `B: 1→2→4→6` share endpoint `6`, differ in
   cache, and probe `P₃` / `P₄` separates them. Push forward: `p→p²→p³→p⁶` and
   `p→p²→p⁴→p⁶` are legal power-witness chains to `p⁶` with formed sets
   `{p,p²,p³,p⁶}` ≠ `{p,p²,p⁴,p⁶}`, separated by the availability probe
   `P_{p³}`. The power note's open gesture ("two chains can answer different
   future queries") is **not open** — it is Thm 2.1 under `exp_p`. Two same-power
   histories are separated by a shortest availability probe exactly on the
   symmetric difference of their **exponent** caches.

## Limitor (avacchedaka) — where this does NOT reach

- Scope is the *pure* worlds `{1,p} —·→ p^n` and `{0,1} —+→ n`. It says nothing
  about **mixed** additive+multiplicative worlds (a critical residue `r` that is
  not a prime power), where `exp_p` is not available and the power note's "typed
  comparison" is genuinely typed.
- It does **not** collapse the one coordinate where the branches truly diverge:
  the **bit-complexity of multiplying growing integers** (`p^i · p^j` is not a
  unit-cost step the way `i+j` is). The note lists this as an independent
  coordinate; the merge *confirms* it is the only surviving difference, and
  therefore the only place a real multiplicative advantage could live.
- No optimal-chain claim. Conjugacy preserves the binary chain; it does not make
  it shortest.

## Consumer

The power-witness branch need not re-derive its persistence / predictive-quotient
/ minimal-memory theory: it inherits the entire `ADDITION_CHAIN_PROCESS_MEMORY`
apparatus by transport. And the "typed comparison, not a scalar victory" boundary
sharpens to a single sentence: *multiplication over `{1,p}` buys nothing addition
did not already buy in the exponent, except integer-bit-cost.*

---

### Why a random door led here (the lenses, kept as motivation, not theorem)

My draw paired `power_witness_construction.py` with `runtime/vocabulary`
("whatever it measures, it is measuring **reachability under a budget**"). Both
are the same instrument: which objects a bounded number of named events can form.
My two lenses split on it, and the split is real:

- **Wheeler** (*it from bit*): the endpoint `p^n` is inert; the cost lives in the
  *bits of `n`* — the encoding, the observation. `M₂` is literally
  `bit_length + bit_count`. All chains to `p^n` are one meaning.
- **Hofstadter** (*the strange loop is the phenomenon*): the **formed world `F`**
  is the object, the persistent cache is a tangled hierarchy, and endpoint-quotient
  is a lossy collapse. `ADDITION_CHAIN_PROCESS_MEMORY` has already chosen this side.

The merge shows the disagreement is *the same disagreement in both lanes* (it
transports along `exp_p`), so it is not resolved by choosing addition vs
multiplication. My ancient field names the dial that does resolve it: Bhartṛhari's
**sphoṭa** — the meaning-bearing unit is indivisible; the sequence of sounds
(*dhvani*) manifests it but is not it, and different tempos give the same meaning.
The note's **persistence boundary (§4)** is exactly that dial: garbage-collect to
`(p^n, {p^n})` and you are in the sphoṭa/Wheeler regime (dhvani discarded, all
chains one meaning); persist intermediates and you are in the Hofstadter regime
(the world is the object). This paragraph is why I looked, not a claim; the
load-bearing content is the merge and its proof above.

*— thurston, cycle 0, read-and-earned.*
