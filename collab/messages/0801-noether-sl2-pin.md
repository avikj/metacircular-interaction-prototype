# `Sl2TensorProduct.agda` is green under the pin, and its induction now reaches its own rank-2 displays

Noether-lineage pass, 2026-08-15. Toolchain per the owner's instruction of
today: **sources track the pin** (Agda 2.8.0 + cubical v0.9, as
`formal/cubical/BUILD.md` declares). `LC_ALL=C.UTF-8` on every run.

## 1. The rename, verified rather than guessed

`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.4 recorded the failure and
guessed, "on the evidence of this one run, a one-token" fix. Agda reports
one scope error at a time, so that guess had no standing until the run was
made. I made it. **The guess is correct and the full list of names changed
is one:**

| line | v0.5 (was) | v0.9 (now) |
|---|---|---|
| 115 | `·Rid` | `·IdR` |

From a *clean* copy of `formal/cubical` (no `_build`), so no stale interface
can be doing the work:

```
$ cd <clean copy> && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/dist-newstyle/.../agda \
      --library-file=<v0.9 libraries file> Sl2TensorProduct.agda
Checking Sl2TensorProduct (…/Sl2TensorProduct.agda).
 Checking Sl2DivisorLattice (…/Sl2DivisorLattice.agda).
EXIT=0
```

The module is now **red under `/usr/bin/agda` (2.6.3 / v0.5)**, which has no
`·IdR`. Under today's instruction that is the intended state, not a
regression. §6.2's row for this file flips to **42 / 0**. Recorded as §6.7
of the toolchain note.

## 2. What I actually found wrong in the mathematics

The controls the task asked me to check for were **already there** — I say
this from reading the file, not from the prompt. §7 has ten `refl` controls
at rank 2 with **distinct α₁ = 1 ≠ 3 = α₂** (`u12 = dl 1 0 ⊗ᴹ dl 2 1`), and
they include the guard the rank-one module structurally cannot provide: a
**non-vacuity** control showing `E₁F₂ u02 = 4 ≠ 0`, so `⟪ lop εK , rop φK ⟫
= 0` is a cancellation of two equal *nonzero* terms. Nothing to add there.

What was wrong is one step earlier, and it is exactly the kind of gap this
repo's protocol exists to catch — a claim that reads as proved and is not.
§6 and §7 are about

```agda
Rk2 = tensorRep chainRep chainRep
```

while §5's induction produced

```agda
Bn zero    = trivRep
Bn (suc m) = tensorRep chainRep (Bn m)
```

so `Bn 2` had index type `Ch × (Ch × Unit)` and was **not** `Rk2`. The
header's claim that "§6 reads them off at rank 2" was therefore an analogy
between two objects, not a statement about one. No equivalence was
constructed anywhere in the file, and none is cheap: it would need transport
of an `Sl2Rep` along `Ix R × Unit ≃ Ix R`.

The honest repair is to anchor the recursion where the mathematics anchors
it — `B_n` for m primes is a tensor of m chains, not of m chains and a
copy of k:

```agda
Bn zero          = trivRep
Bn (suc zero)    = chainRep
Bn (suc (suc m)) = tensorRep chainRep (Bn (suc m))
```

Now `Bn 2 = tensorRep chainRep chainRep = Rk2` **definitionally**, and the
file says so with a checked term:

```agda
Rk2≡Bn2 : Rk2 ≡ Bn 2
Rk2≡Bn2 = refl
```

That single `refl` is what converts "the induction reaches the multi-index
displays" from a comment into a theorem. Every §6 display and every §7
control is now a statement about the induction's own output. Nothing else
in the module changed: `Bn` was used only by `divisorLatticeSl2`, and no
proof depended on its clauses.

§8's ledger is unchanged and still accurate — the general-m multi-index δ
display is still not here, and I did not pretend otherwise.

## 3. Sweep, for the sibling doing the tree

`grep -rn '·Rid\|·Lid\|+Rid\|+Lid\|Symmetric-Group' --include=*.agda formal/`
→ **zero hits tree-wide.** `PathIsSymmetry.agda` already spells it
`SymGroup`, the v0.9 name. Nothing for the sibling here; this is a grep for
five identifiers, not a clean bill of health under the pin.

## 4. Scope limits

1. Exit 0 is a statement about typechecking. §6's displays are proved for
   arbitrary `(κ₁,d₁,κ₂,d₂)` but at m = 2; general m has the action and the
   recursive comultiplication only.
2. The pinned binary is the one built in this session's scratchpad per
   toolchain-note §6.1 and reused, not rebuilt. §6.5 limit 2 stands.
3. Superseded by §5 below — kept so the record shows what I was willing to
   claim before I had the run. It read: "`Everything.agda` no longer aborts
   at `Sl2TensorProduct` … I did not run it to completion, so I make **no**
   claim that the aggregate is green."
4. I edited exactly one source file, `formal/cubical/Sl2TensorProduct.agda`,
   plus the toolchain note and this message.

## 5. Addendum, same session: `Everything.agda` is green under the pin

§4 limit 3 said I made no claim about the aggregate. I now have the run, so
the claim is made and the limit is withdrawn.

```
$ cd <fresh copy of formal/cubical, _build removed> && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/.../agda --library-file=<v0.9> Everything.agda
… 315 modules checked, 0 errors, 194 UnsupportedIndexedMatch warnings …
EXIT=0
```

Two things I want on the record rather than smoothed over, because the first
attempt at this run did *not* earn the claim:

- My first `Everything.agda` run also exited 0, but it reused `.agdai`
  interfaces that my own clean `Sl2TensorProduct` check had written minutes
  earlier — so it was not a from-scratch aggregate, and `Sl2TensorProduct`
  was a cache hit rather than a check. I did not publish it. The numbers
  above are a **second** run, fresh copy, `_build` deleted, in which
  `Sl2TensorProduct` appears as a genuine `Checking` line.
- The second copy was taken **after** merging `origin/main`, so it covers
  315 modules against the first run's 162 — it includes today's sibling
  work, among it 0800's `PolarityClosure` repair. The bigger number is the
  stricter test.

So `Everything.agda` flips **42 → 0** in the toolchain note's §6.2 table,
and §6.4's "the aggregate's exit code is not evidence about the modules
after it" is withdrawn rather than narrowed: it is evidence again, and it is
positive. Recorded as §6.7 of `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`.

What this does **not** say: `Everything.agda` does not import every module
in the tree, and whatever it omits is still unswept under the pin. §6.5
limit 3 survives exactly there.
