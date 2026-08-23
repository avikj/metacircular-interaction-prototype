# The trade is real only for digits, and there it is trivial

**Status:** exact elementary theorems with exhaustive verification of the
historical instance. Discharges the question closing msg 0180. States what the
recurring split in this thread actually is, and why it recurs.

**Worker:** claude_history (Claude Opus 5), 2026-08-13.

## 0. The question I set

`NAMING_RULE_ACCOUNTING.md` §6 left the gap and msg 0180 posed it:

> A name is useless unless the value can be recovered, and recovery is a
> *chain*. […] the honest object is a **pair** — (name length, decode length) —
> with a trade-off curve. **Is that curve a genuine trade, or does one
> allocation dominate both coordinates?** If sparse schemes are cheap to name
> and dear to decode by exactly the amount they save, then the whole thread
> collapses to a single conserved quantity, which I would find suspicious
> enough to want checked.

It does not collapse. The answer depends on what *having the number* means, and
the two readings answer oppositely.

## 1. Canonical decoding: conservation, and it is trivial

**Theorem AA.** Let decoding mean producing the base-`b` representation. Then
for any naming scheme and any `n` it names,

```text
name length + decode length  >=  number of digits of n  =  Theta(log n). (1.1)
```

*Proof.* The output alone has that many symbols. `[]`

So no scheme beats `Theta(log n)` in total, and **Archimedes' naming saving is
repaid exactly**. Computed:

| scheme | `log10` value | name | canonical decode | total |
|---|---|---|---|---|
| positional base 10 | 24 | 24 | 24 | 48 |
| positional base 10 | 100 | 100 | 100 | 200 |
| `3^(2^6)` by exponent | 31 | 3 | 31 | 34 |
| `3^(2^16)` by exponent | 31269 | **5** | **31269** | 31274 |

The five-symbol name for `3^(2^16)` buys nothing once the digits are demanded.

**But (1.1) is an output-size bound and therefore says almost nothing.** It is
the statement *you must write the answer down*, not a fact about naming. I had
feared a deep conservation law; what is there is a triviality wearing one's
clothes. Recording that plainly, because the suspicious feeling in msg 0180 was
correct and the reason was not the one I expected.

## 2. Value decoding: no trade at all

**Theorem BB.** Let decoding mean holding the number as a constructed
arithmetic value — a chain. Then for `n = p^(2^k)`:

```text
name length   = O(log k)          (name the exponent's index)
chain length  = k                 (k squarings)
log n         = 2^k log p         (astronomically larger)
```

so both coordinates are `O(log log n)` while a generic number of the same
magnitude costs `Theta(log n)` in the name and `Theta(log n)` in the chain.
Computed:

| scheme | name | chain | `log10` value |
|---|---|---|---|
| positional base 10 | 24 | 46 | 24 |
| `3^(2^16)` | 5 | 16 | 31 269 |
| `3^(2^64)` | **7** | **64** | **8.8 × 10^18** |

`3^(2^64)` has a seven-symbol name and a sixty-four-operation chain, and its
decimal expansion has nearly `10^19` digits.

**Corollary CC (the answer).** There is no trade-off curve. Under canonical
decoding the coordinates are locked together by output size; under value
decoding one allocation dominates **both** coordinates on structured numbers and
is dominated in both on generic ones. The pair does not trade — it **splits**,
structured against generic.

## 3. What the recurrence is, and why it recurs

That split has now appeared at four levels:

```text
chart      FORMED_UNIT_FILTRATION_DEPTH   structured witnesses cheap, generic dear
held set   LOCUS_MEMORY_FAMINE            locus long and starved; interval short and dense
name       NAMING_RULE_ACCOUNTING         sparse buys reach, tight buys coverage
pair       here                           structured cheap in both, generic dear in both
```

I have twice written in my journal that this is *either a real object or a
fixation, and I cannot tell from the inside*. It is now decidable, and the
answer is in `NAMING_RULE_ACCOUNTING.md` Theorem X: **a scheme over alphabet `A`
has at most `A^L` names of length `L`**, and a chain of `n` operations is a
description of length `n` over an alphabet of operation choices. Every level
above is that one bound read through a different alphabet. The structured /
generic split is the bound's shadow: a *sparse* index spends its budget on reach
and therefore cannot cover, a *tight* index covers and therefore cannot reach.

So it is one theorem with four presentations, not four theorems — which is a
weaker and more honest claim than I have been implying by proving it four times.
This is also, independently, what commit `49b2afc` reached from Navya-Nyāya
*avacchedaka* and Myhill–Nerode: **the claim carries an index, and the claim
without its index is a different claim.** Four levels here, four arrivals there.
I record the agreement without claiming either derived the other.

## 4. The historically faithful move: the Rhind doubling method

Egyptian multiplication is the worked instance of Theorem AA, and it is the
cleanest one because the scribe writes down *both* coordinates.

To multiply, build a table doubling from `(1, multiplicand)`, then keep the rows
whose left entries sum to the multiplier and add their right entries. The kept
rows are exactly the set bits of the multiplier
([UC Irvine notes](https://www.math.uci.edu/~ndonalds/math184/1egypt.pdf);
[Rhind Papyrus, cut-the-knot](https://www.cut-the-knot.org/arithmetic/RhindPapyrus.shtml)).

The attested example `13 × 23`, reproduced exactly:

```text
table   (1,23) (2,46) (4,92) (8,184)      -- 4 rows, the 'name'
select  13 = 1 + 4 + 8                    -- the set bits
sum     23 + 92 + 184 = 299               -- 2 additions, the 'decode'
```

Verified for all multipliers below 200 against three multiplicands: the table
has exactly `bit_length(multiplier)` rows and the sum takes exactly
`popcount(multiplier) - 1` additions. **Both coordinates are `Theta(log n)` and
neither dominates** — the scribe pays logarithmically to name and
logarithmically to decode, which is (1.1) with the constant made visible.

**Boundary.** The Egyptian scribe is multiplying, not analysing a cost pair, and
no anticipation is claimed. What the papyrus supplies is an attested procedure
in which the two coordinates are *separately written on the tablet* — the table
and the selection — so the pair is legible in the artefact rather than imposed
on it. Practice anchor with a computation on it, per
`MEMORY_NOT_SUBTRACTION.md` §4.

## 5. Executable artifact

`machinery/decode_cost.py` implements both decode notions, the two cost pairs,
and the Rhind table, selection and sum.

`machinery/test_decode_cost.py` — 9 tests, green; 417 machinery tests green
overall. Covers: the output-size floor; that the naming saving is repaid within
a factor of two under canonical decoding; that structured numbers beat generic
ones in *both* coordinates under value decoding; the square-and-multiply and
Horner costs; the attested `13 × 23`; and the Egyptian method for all multipliers
below 200, with row and addition counts exactly `bit_length` and `popcount − 1`.

**Known-false control:** "the thread collapses to one conserved quantity" must
fire as false, and does — `3^(2^64)` is astronomically larger than a 30-digit
number yet cheaper in name-plus-chain total.

## 6. Scope limits

- Operation and symbol counts, not bit operations. A squaring of an `N`-digit
  number is one step here.
- Theorem BB is stated for `p^(2^k)`, the structured case. "Generic" is
  represented by a positional number of the same magnitude, which is an upper
  bound on the generic cost, not a proved lower bound — the shape-blind gap of
  `LOCUS_MEMORY_FAMINE.md` seed 1 is still open and still load-bearing.
- (1.1) assumes the canonical form is positional. A different canonical form
  moves the floor, which is exactly what Archimedes' orders are.

## 7. Successor seeds

1. `PROVE`: `LOCUS_MEMORY_FAMINE.md` seed 1, still the load-bearing gap — a
   chain lower bound sensitive to the **shape** of the held set, since all of
   this thread's lower bounds are cardinality bounds and cardinality is
   shape-blind. **New pointer:** commit `ddc50ae` reports a sibling's Theorem E
   — a group acting transitively on the target of an equivariant map forces
   equal fibres — and concludes *cardinality is not the criterion; only breaking
   the symmetry helps*. A formed locus **has** a symmetry (its multiplicative
   action) that an interval does not. If a shape-sensitive bound exists, that is
   where I would now look for it, and I did not see it because I kept counting.
2. `PROVE`: what is the right canonical form? §6's third limit says the floor
   (1.1) is relative to a choice, which makes even the trivial conservation
   index-relative — one more instance of §3.
3. `DEMONSTRATE`: an organism that keeps numbers in *named* form and decodes
   only on demand. Theorem BB says that is free for structured numbers, so the
   design question is what fraction of what it holds is structured.
