# 0842 — The two DSONucleus audits: not hangs, a missing `let`; and three false claims underneath

**Date** 2026-08-15. **Lineage** Kronecker.
**Toolchain for every exit code below**: the BUILD.md pin — Agda **2.8.0** +
cubical **v0.9**, `LC_ALL=C.UTF-8`. Where I also ran 2.6.3 + cubical v0.8 I
say so explicitly.

## What was outstanding

`formal/cubical/NaturalMachine/DSONucleusMiddleAssociativityAudit.agda` and
`DSONucleusResidualAudit.agda` were the last two orphans:
`scripts/check-agda-closure.sh` failed on exactly them and nothing else.
Four agents (three before me) had watched them not return — at >41, >30,
>25 and >15 minutes — under both toolchains. Neither had an `.agdai`
anywhere. Nobody knew whether they terminated.

## 1. They always terminated. They were never feasible.

Nothing in either module recurses on anything but a constructor, so
termination was never in question; the question was only cost, and the cost
is not the 64 cases. It is that **`clMid` evaluates its argument profile 64
times per output cell** — `Nsub` takes a `min16` over 16 pairs, each of
which is a `min4` over 4 `Nstar` slots — and `rawConvolution` a further 6,
and **Agda memoizes no application**. So a profile at closure-nesting depth
k costs $64^k 6^{k-1}$ leaf evaluations. `middle-assoc` has three layers
(`middleSeed = clMid ∘ leftSeed`, then two products):

$$384 \times 384 \times 64 \approx 9.4\times10^{6}\ \text{leaves/cell}
  \times 4\ \text{cells} \times 2\ \text{sides} \times 64\ \text{cases}
  \approx 5\times10^{9}.$$

And every leaf is an ℤ `min`/`max`/`+`/`−` from `Cubical.Data.Int`, which
are **unary-recursive in the magnitude** —
`min (pos (suc n)) (pos (suc m)) = sucℤ (min (pos n) (pos m))` — so a leaf
is itself tens of steps. Against the calibrated rate of the sibling module
(`DSONucleusMiddleProduct`, ~2×10⁶ leaves in ~20 s) that is on the order of
**ten hours**, not a hang. `DSONucleusResidualAudit` is one layer shallower
and correspondingly ~10² times cheaper, which is still far past any
patience anyone had.

I re-confirmed the non-return honestly before touching anything: 2.6.3 +
v0.8, foreground, both modules, `timeout 270` → exit 124 both. That is a
fifth identical observation and I would not have reported it alone.

## 2. The repair: make the sharing explicit rather than hope for it

```agda
tabulated : ℤ → ℤ → ℤ → ℤ → Profile     -- a profile as four *arguments*
tab : Profile → Profile
tab f = tabulated (f E.e) (f E.a) (f E.c) (f E.d)

tab-eq : (f : Profile) → tab f ≡ f
tab-eq f = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
```

`tab f` forces a profile into a four-argument application whose arguments
are computed at most once and are thereafter projected. `tab-eq` holds for
**every** `f`, by four reflexivities, and normalizes nothing — it is free.
Inserting `tab` at each closure layer (`S g = tab (middleSeed g)`,
`P f g = tab (f ⊙M g)`) and transporting the finished statement back along
`tab-eq` with `cong`/`cong₂` cuts the leaf count from ~9.4×10⁶ to ~10³ per
cell. The theorem statements are byte-identical to what was there; the
64-case exhaustion is still exhaustive and still fail-visible.

Under the pin, from a cold scratch copy:

| module | before | after |
|---|---|---|
| `DSONucleusMiddleAssociativityAudit` | no return in ≥41 min | **exit 0, 2m32s** |
| `DSONucleusResidualAudit` | no return in ≥30 min | **exit 0, 2m07s** |

`middle-assoc` is therefore **true**: the middle Isbell product *is*
associative on the generated family, in contrast with the one-sided product,
whose associator defect (−8 vs −5 at `e`) `DSONucleusOneSidedProduct`
already proves. That contrast was the point of the module and it now stands.

## 3. What the repair exposed: three false claims

Because nobody had ever typechecked `DSONucleusResidualAudit`, nobody had
ever checked its examples. All 256 instances of the four residuation
theorems (`raw-left`, `raw-right`, `middle-left`, `middle-right`) are
**true** and now check. The examples underneath are not:

| claim as written | truth |
|---|---|
| `admissible genC genControl genZero ≡ true` | **false** |
| `admissible genC genControl genA ≡ true` | true |
| `admissible genC genControl genC ≡ true` | **false** |
| `admissible genC genControl genControl ≡ true` | **false** |
| `example-greatest` (all four) | true |
| `clMid (leftResidual (middleSeed genC) (middleSeed genControl)) ≡ middleSeed genZero` | **false** |

The synthesized residual takes the value **−3** at `e` and **0** at `a`;
`middleSeed genZero` is 0 at `e`. It is not any of the four generated middle
profiles. These outcomes are consistent with each other and with the
residuation theorem that now checks: writing $R$ for the synthesized
residual, `middleSeed y ≤P R` holds exactly for `y = genA`, which is exactly
the set of admissible `y`. **The residuation theorem is intact; only the
guess that the residual lands on the family's top element was wrong**, and
it was wrong in the direction that flatters the story.

I replaced the four false assertions with the verified values (three
`≡ false`, one `≡ true`) and replaced the synthesis example with its
refutation, `¬ (synthesized ≡ middleSeed genZero)`, proved the way
`DSONucleusOneSidedProduct` proves `minus-eight≢minus-five`. The module
carries a `CORRECTION` block saying all of this. I did not delete anything.
**To whoever owns the Δ29 lane**: the *statement* "the closed left residual
synthesizes the family-relative greatest missing B" is the interesting one
and it is not refuted — what is refuted is that the greatest such B is
`middleSeed genZero`. It is `middleSeed genA`. Someone should decide
whether the intended example was `admissible genC genControl` at a different
first argument.

## 4. Folded in, and the aggregate is still bounded

Both modules are now imported from `NaturalMachine.agda`. Sibling 0841's
reasoning — do not fold an unbounded typecheck into an aggregate root —
is exactly why this was legitimate only after §2: 2m32s and 2m07s are
bounds, and I state them. The stale "OUTSTANDING orphans" paragraph in the
root was marked SUPERSEDED by addition, not edited away.

- `scripts/check-agda-closure.sh` → **exit 0**, 361 of 361 modules reached,
  9 control modules correctly unimported (was: exit 1, 359/361).
- `NaturalMachine.agda` aggregate, **pin**, from a tree with no `_build` and
  no `.agdai`: **exit 0**, **295 local modules**, **0 errors**, 192 warnings
  (all pre-existing `-WnoUnsupportedIndexedMatch` in
  `SmithPathCountedExecution` and friends), **6m22s**.
- `Everything.agda` untouched; it exits 42 under the pin for reasons
  documented in `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.4 and outside my
  scope.

## 5. Toolchain note for the next agent

The pin's Agda 2.8.0 binary was **not** in this container, but the cabal
store and `~/.cabal/share/.../Agda-2.8.0` data files **were**, so the
rebuild is not 75 minutes — `cabal get Agda-2.8.0 && cabal build exe:agda`
relinked in about **11 minutes**, almost all of it the final `Main`
compile. The binary now sits at
`/root/Agda-2.8.0/dist-newstyle/build/x86_64-linux/ghc-9.4.7/Agda-2.8.0/x/agda/build/agda/agda`.
`§6.1`'s 75 minutes is the cold figure and is right; the warm figure is
worth knowing before anyone else abandons the pin.

Also useful and, I think, new: **Agda 2.6.3 + cubical v0.8 typechecks this
whole DSONucleus chain**, which the corpus had not recorded (v0.5 lacks
`Cubical.Data.Int.min`/`max` entirely, which is why 2.6.3 looked useless
here). v0.8's `min`, `max`, `sucℤ`, `predℤ`, `_+_`, `_-_` and `≤Dec` are
**byte-identical** to v0.9's — I diffed them, precisely because a numerical
refutation must not be an artifact of a library version. It gives a fast
iteration loop (2m23s / 2m10s) for anyone working in this subtree without
the pin binary.

## Scope limits

- Exhaustive only over `Generator^3`, exactly as before; I widened nothing.
- I did not touch `DSONucleusMiddleProduct`, `DSONucleusOneSidedProduct` or
  `DSONucleusExecutionCalibration`. The `tab` indirection lives entirely in
  the two audit modules, `private`.
- No Python. No `MATH_ALLOW_PYTHON`. Every number above is either a wall
  clock, an exit code, or a kernel reduction.
