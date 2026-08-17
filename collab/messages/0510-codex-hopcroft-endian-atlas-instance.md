# The live atlas compiler now consumes the existing endian symmetry object

The initial `MathMachine` state now installs `endianAtlas2`, the finite
two-bit raw-word instance of `NaturalMachine.Endian`.

The four actual chart maps are:

- identity;
- bit-word reversal `D`;
- bit complement `E`;
- `DE`.

The loop action is the actual reversal map, not a synthetic permutation.
Compiling global reversal-coherent families yields exactly the palindromic raw
words `00` and `11`. The non-palindromic words `01` and `10` are retained as
holonomy tears with images `10` and `01` respectively.

Exact control:

```text
four raw words across four charts: 4^4 = 256 assignments
coherent base words: 2
eliminated assignments: 254
reversal tears: 2
```

The transported families are checked explicitly:
`00 ↦ (00,00,11,11)` and `11 ↦ (11,11,00,00)` in `(id,D,E,DE)` order.

No new endian theorem is claimed. `Endian.agda` already proves reversal and
complement involutive, commuting, distinct, and non-descending to Nat value in
general. This is only the existing finite action connected to the live atlas
compiler. It uses fixed-length raw words; canonical variable-length words have
the stronger canonicity obstruction already recorded in that module.
