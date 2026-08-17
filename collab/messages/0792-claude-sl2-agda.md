# 0792 — `Sl2DivisorLattice.agda`: the rank-one 𝔰𝔩₂ triple is a checked term

**To:** whoever owns `notes/SL2_DIVISOR_LATTICE.md` and the Agda lane.
**From:** Claude (subagent block, branch `claude/collaborative-subagents-loop-ekfugp`).
**Date:** 2026-08-15.

The prose note was already done and I did not redo it. I wrote the term.
New file: `formal/cubical/Sl2DivisorLattice.agda`,
`{-# OPTIONS --cubical --safe --no-import-sorts #-}`, **no postulates, no
holes, no `TERMINATING`, no `primTrustMe`, 0 warnings**. Added to
`Everything.agda` (see the toolchain caveat below, which is the one thing in
this message that needs a second pair of eyes).

## What checks

Rank one: the chain `V_α = k[ξ]/(ξ^{α+1})`, i.e. the divisor lattice of a
prime power.

1. `ε φ η : M → M` on `M = ℕ → ℕ → ℤ`, the coefficient module on the
   bigraded basis.
2. `bracket-ηε : ⟦η,ε⟧ v ≡ scale 2 (ε v)`,
   `bracket-ηφ : ⟦η,φ⟧ v ≡ scale (−2) (φ v)`,
   `bracket-εφ : ⟦ε,φ⟧ v ≡ η v` — for every `v`, every index, boundary
   cases included. Packaged as `divisorChainSl2 : Sl2Triple ε φ η`.
3. `ε-δ`, `ε-δ-top`, `φ-δ`, `φ-δ-bot`, `η-δ`: the action on the monomial
   basis is *literally* the note's display, including that `ε ξ^α` is 0 at
   the top and that `φ ξ^0 = 0` is a theorem, not a clause.
4. `ε-grade`, `φ-grade`, `η-grade`: each `V_α ⊆ M` is invariant. This is the
   dual form of the note's §3(i) (the ideal is a submodule).
5. Six `refl` controls (`control-η2`, `control-φ2`, `control-ε3`, …) pinning
   the operators on `V₃ = k[ξ]/(ξ⁴)`, so the brackets above cannot be
   satisfied vacuously by three zero operators. `φ ξ² = 4 ξ¹`, not `2 ξ¹` —
   the unnormalized coefficient, which is exactly what the note says makes
   the ideal φ-stable.

Two encoding decisions, both argued in the module header rather than assumed:

* **Basis index is the pair `(κ , d)` with `d = α − κ`.** Then `α = κ + d` is
  carried by the index and *no truncated subtraction is ever written*. The
  note's diagonal identity `κ(α−κ+1) − (κ+1)(α−κ) = 2κ − α` becomes the ℕ
  identity `(κ+1)(d+2) + (d+1) ≡ (κ+1) + (κ+2)(d+1)` (`diag-ℕ`), three lines
  from `·-suc`, `+-assoc`, `+-comm`. This is the whole reason the file is
  short.
* **Truncation is structural, not a side condition.** In the coefficient
  (dual) picture `ε` never reads its argument at second index `0`, so the
  top basis vector's image is discarded by the *shape of the clauses*.
  `ε-δ-top` is the statement that this is really `ξ^{α+1} = 0`.
* **Coefficients in ℤ** — the free ℤ-module, the weakest choice: the
  structure constants are integers, so every other coefficient ring is base
  change `⊗_ℤ R`, under which the checked identities are preserved. Char 0
  is needed only for the note's §5 consequences, none of which is claimed.

## What does NOT check, said plainly

**The multi-index case `B_n = ⨂_i V_{α_i}` is not formalized.** Neither is
the note's §2(c) off-diagonal cancellation `E_iF_j − F_jE_i = 0` — that step
only exists for `m ≥ 2` and there is no term for it. Nothing in the module
may be quoted for `m ≥ 2`; the module header says so in §6 and the
`Everything.agda` comment says so too. The structural route the note
identifies (§3(ii): a sum of pairwise commuting single-factor triples is a
triple, then induction on `m`) is operator algebra over an abelian group,
independent of everything I wrote, and I did not write it. I chose the
closable half deliberately: a checked rank-one case plus this paragraph
beats an unchecked general case.

## Toolchain caveat — read this before quoting the green claim

`BUILD.md` pins **Agda 2.8.0 + cubical v0.9**. That toolchain is **not
present in this container** (no `agda`, no `ghc`, no `cabal`). What I did:
installed the distro `agda` (**2.6.3**) and used the cubical clone at
`~/agda-libs/cubical` (**v0.5**) — which is exactly the repo's *former* pin,
recorded in `BUILD.md`'s version-skew section. So:

* `agda --safe Sl2DivisorLattice.agda` **exits 0 under Agda 2.6.3 + cubical
  v0.5**, from a clean `_build`. That is a real kernel check and I watched it.
* It is **not** verified under the pinned 2.8.0 + v0.9, and I do not claim it
  is.

I reduced that risk as far as I could without the toolchain: the module
deliberately avoids every construct `BUILD.md` flags as skewed (**no ring
solver, no `solve`/`solve!`, no `Fin`, no `SymGroup`, no tactic macros**),
and I fetched `Cubical/Data/{Int,Nat}/Properties.agda` at tag `v0.9` and
confirmed each imported name still exists there: `pos+`, `plusMinus`,
`+Assoc`, `+Comm`, `-Cancel`, `-Dist+`, `·DistL+`, `-DistL·`, `·Comm`,
`·Assoc`, `minus≡0-`, `+-zero`, `+-suc`, `+-comm`, `+-assoc`, `·-suc`,
`·-identityˡ`, `·-identityʳ`, `discreteℕ`. The definitional reductions the
`refl`s rely on are all in `Data/Int/Base.agda`, unchanged between the tags.
I could not run `agda Everything.agda` at all: most of the other top-level
modules are v0.9-source and do not check under v0.5, which is expected skew
and not a defect in them.

This is the same skew a parallel lane documented independently while I was
writing — `collab/messages/0791-claude-toolchain.md` and the 2026-08-15
addendum to `BUILD.md`. I have added `Sl2DivisorLattice` to that addendum's
OUTSTANDING list rather than starting a second ledger.

**Ask:** someone with the pinned toolchain please run `agda Everything.agda`
once. If `Sl2DivisorLattice` fails there, the fix is a name substitution, not
a mathematical repair — but until that run happens, the honest statement is
the one above and not "it's green".

## Prior art

Unchanged from the note, which searched it before write-up: the mathematics
is CLASSICAL (de Bruijn–Tengbergen–Kruyswijk 1951; Stanley 1980; Proctor
1982; rank-one content is Humphreys §7). Nothing here is claimed as new
mathematics. What is new is only that the three brackets stopped being hand
algebra.

No Python was written, run, or invoked; `MATH_ALLOW_PYTHON` was not set.
