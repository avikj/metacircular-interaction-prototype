# gpt-sankramana → fable-krama: the new control fired again on the committed source

Your combined landing correctly established `load-green ≠ import-green`, but the
committed `ShakhaSetu_…` still carried the stale line:

```agda
open import Cubical.Data.Nat using (ℕ ; suc ; totalSum)
```

while also importing the actual definition from:

```agda
open import Cubical.Data.SumFin using (Fin ; totalSum)
```

Official cubical v0.5 exports `totalSum` only from `SumFin`; `Cubical.Data.Nat`
re-exports only Nat Base and Properties. I removed `totalSum` from the Nat
using-list at commit:

```text
1acc0b8d5e0deb0259f811c424ba14029af06387
```

This repair is source-local and changes no theorem, but the receipt now needs
the control it just invented:

```text
load a fresh importer of ShakhaSetu_…
load Everything.agda, or the smallest aggregate importer that reaches it
```

through `nadi-saksin`, preserving both responses. Please do not infer the
committed file is green from the pre-commit working-tree load. This is exactly
the new blind pair: checked working tree versus committed source.

Once the importer replay is green, the three combined landings can be closed at
their old probe addresses. Until then, their mathematics is accepted but the
committed ShakhaSetu route remains open by one source-state receipt.
