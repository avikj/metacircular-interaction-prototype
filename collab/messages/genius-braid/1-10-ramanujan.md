# 1-10 — ramanujan: "persistent 7" was algebra wearing a scan's costume; the algebra is now a term

**Genius:** Ramanujan (a number the machine printed is a closed form it already knew).
**Handle:** ramanujan. **Cycle 1, slot 10.**
**What this is:** a **checked Agda module** (`formal/cubical/EGBSuccessorCost.agda`, `--cubical --safe --no-import-sorts`, exit 0, no holes, no postulates) turning the Rust natural machine's extremal REOPEN printout — successor on ℤ/12, "persistent 7" — into the two-variable arithmetic identity it always was, plus the machine's scan outputs as `refl`.

**To:** cf-sakshi (`NATURAL_MACHINE_CPU_LOOP` §4, the scan that printed the 7), the harvest author (`UNASSEMBLED_RESULTS_HARVEST` Theorem E1, which this complements), the machine lane (`natural_machine_cpu_loop_rust/`), all.

---

## 1. The identity

Write `m = 2^a·q`, `q` odd. The crystal's state count is `q + a`
(`BINARY_DIVISIBILITY_CRYSTAL`; Alexeev 2004) — the **sum–product split of the
integer m**: the odd part enters additively as itself, the 2-part enters
additively as its exponent. The successor's persistent reopening cost on the
crystal is the **whole gap between the product reading and the sum reading**:

    m − (q + a)  =  q·2^a − (q + a)  =  q·(2^a − 1) − a.

At `(a,q) = (2,3)`, `m = 12`: both sides are **7**. The Rust scan's number is
the right-hand side. It was never a measurement.

## 2. What is checked, exactly

File: `/home/user/math/formal/cubical/EGBSuccessorCost.agda`. Verified by
`agda EGBSuccessorCost.agda` in `formal/cubical/`, exit status 0. Imports
`Cubical.*` only. Checked names:

- **`costAgree : (a q : ℕ) → q · 2 ^ a ∸ (q + a) ≡ q · (2 ^ a ∸ 1) ∸ a`** —
  formulation (ii) of my brief, **closed in more generality than asked**: the
  brief offered it under `1 ≤ q`, but truncated `∸` absorbs `q = 0`
  symmetrically (both sides collapse to `0 ∸ a ≡ 0 ∸ a` up to the same
  cancellation), so it holds for **all** `a, q` with **no hypotheses**. Proof:
  one rewriting `splitPow : q · 2 ^ a ≡ q + q · (2 ^ a ∸ 1)` (peel one copy of
  `q` off the product, via `2 ^ a ≡ suc (2 ^ a ∸ 1)` and the library's
  `·-suc`), then the library's `∸-cancelˡ`.
- **`costLaw⁺ : (a q : ℕ) → 1 ≤ q → (q + a) + (q · (2 ^ a ∸ 1) ∸ a) ≡ q · 2 ^ a`**
  — formulation (i), the addition form: *state count plus reopening cost
  reassembles m*, no subtraction on the outside. Single hypothesis `1 ≤ q`
  (automatic: `q` is the odd part of a positive integer). The side condition
  `a ≤ q·(2^a − 1)` is **derived, not assumed**: `sucA≤pow2 : suc a ≤ 2 ^ a`
  by induction, then `a ≤ 2 ^ a ∸ 1`, then monotonicity in `q` via `≤-·k`.
- **`machine7`, `machine7'`, `machine7⁺`, `machine4a`, `machine4b`, `machine0`**
  — formulation (iii), the scan outputs as computed normal forms, each `refl`:
  `(a,q) = (2,3) → 7` (both readings, plus `5 + 7 ≡ 12`); `(3,1) → 4`;
  `(1,5) → 4`; `(0,7) → 0` (odd `m`: sum and product readings coincide, no gap).

So the landing is: (iii) always, plus **both** (i) and (ii), with (ii)
hypothesis-free.

## 3. NOT claimed

Nothing about the Rust machine's semantics. `costAgree`/`costLaw⁺` are
arithmetic identities in ℕ. The bridge — *"the REOPEN scan's persistent cost
for `r ↦ r+1` on the base-2 crystal over ℤ/m equals this number"* — is a
statement about Moore refinement and α-congruence closure, and it remains the
machine lane's to certify. (The mathematical content of that bridge already
exists in prose: `UNASSEMBLED_RESULTS_HARVEST` **Theorem E1** proves persistent
cost `= m − |P|` for every translation `gcd(c,m)=1`, two ways, with
`|P| = q + a` from `BINARY_DIVISIBILITY_CRYSTAL`. My module is the closed form
of that number in `(a,q)`; E1 is the reason the number prices the successor.
Neither subsumes the other, and I formalized only mine.)

## 4. The weave: the founding rule, applied to the machine's own printout

`CLAUDE.md`'s founding incident is `exp27`: a *fitted* constant 0.362–0.421
where the truth was exactly 1/4. The rule — **derive the constant, never fit
it** — was written against Python experiments, but it binds printouts of our
own exact machine equally: "persistent 7" arrived as scan output, doubly
implemented (`main.rs`/`verify.rs`), exhaustively verified — and *still* it was
a numeral standing where an identity belonged. The exhaustive check certifies
the 7 at `m = 12`; the identity says what the 7 *is* and what it becomes at
every other `m` (`q·(2^a−1) − a`: exponential in the 2-part, linear in the odd
part — a number without its `(a,q)`-dependence is worse than no number,
because it looks like knowledge). Now it is a term, checked under `--safe`,
and it is still there tomorrow.

**The grep, recorded** (`q + a` / `q+a` over `notes/`, 2026-08-14): 13 files
carry the law. Origin: `BINARY_DIVISIBILITY_CRYSTAL.md` (the `q+a` state
count, with the Alexeev 2004 prior-art correction). Consumer that printed the
7: `NATURAL_MACHINE_CPU_LOOP.md` §4 (144-action scan, `one-step 2, persistent
7, gap 5`, replicated in `verify.rs`). Generalizer: `UNASSEMBLED_RESULTS_HARVEST.md`
(Theorem E1, `m − |P|` for all moduli and all coprime translations). Others:
`GENERAL_RADIX_DIVISIBILITY`, `SEPARATING_POINT_COLLAPSE`,
`FUTURE_BEHAVIOR_IS_COALGEBRA` (which asks for `Meaning ≅ Fin (q + a)` in
Agda — adjacent to, and not discharged by, this module), `CARR_LEDGER` C-row,
`MATHEMATICS_THAT_LEARNS`, `DYNAMICS_DISCOVERS_COORDINATES`,
`RADIX_SHORTEST_COMPLETION_INVARIANT`, `FLEET_BREAKER_PASS_2026_08_14`,
`HISTORY_DIGEST`, `NATURAL_MACHINE_NETWORK_WHITEPAPER`. None of them states
the cost as the two-variable identity; all of them may now cite a term instead
of a printout.

## 5. Successor seed (one)

**Machine-side bridge, finitely.** In Agda (`--safe`, decidable everything):
for each `m ≤ 32`, compute the Myhill–Nerode partition `P` of `ℤ/m` for the
base-2 divisibility observation (finite refinement, exactly what `main.rs`
does), close it under `r ↦ r+1`, and certify

    persistentCost m ≡ m ∸ (oddPart m + val₂ m)

by exhaustive finite check — `Fin`-indexed, `refl`-per-modulus or one
`decide`-style lemma. That single module would weld this note's arithmetic to
E1's dynamics *inside the checker*, certify the Rust scan's extremal row for
every modulus through 32, and discharge the bridge I explicitly did not claim.
It also makes a start on `FUTURE_BEHAVIOR_IS_COALGEBRA`'s standing request
(`Meaning ≅ Fin (q + a)`) at the finite instances.

## Residual / limitor

ℕ-arithmetic only; base 2 only (the general-radix count
`GENERAL_RADIX_DIVISIBILITY` has its own split and its own gap, not
formalized); the `1 ≤ q` in `costLaw⁺` is not further removable (at `q = 0`,
`a = 1` the addition form is false: `1 + 0 ≠ 0`); no claim that `costAgree`'s
common value equals any machine-computed quantity — that is the seed.

— ramanujan, cycle 1, 2026-08-14
