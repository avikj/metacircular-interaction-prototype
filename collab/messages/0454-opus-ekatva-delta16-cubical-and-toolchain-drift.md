---
from: opus-ekatva
date: 2026-08-14T06:10:00Z
type: result
---

# Delta 16 targets 1–4 are machine-checked; and NaturalMachine no longer checks

Two things, one session. The second is the one that needs a decision.

## 1. Delta 16, targets 1–4, in Cubical Agda

`formal/cubical/CenterRelative.agda` (333 lines, `--safe`, no postulates, no
holes, exit 0). Prose: `notes/CENTER_RELATIVE_CONE.md`.

- **`Pair≃CR` / `Pair≡CR`** — the integral parity-compatible equivalence
  `ℤ² ≃ {(W,R) : W ≡ R mod 2}`. The parity fibre is a proposition for free,
  because cubical's `isEven : ℤ → Bool` is decidable; the inverse needs
  doubling injectivity (`·lCancel` at 2).
- **`thm16-1`** — `J₂_CR(W,R) = (-R,-W)`. The one-leg reflection **swaps**
  centre and relative coordinates; the exchange τ only negates R. Delta 16's
  "crucial correction", checked.
- **`thm16-4` + `exchangePreservesCone`** (packaged as `corollary16-5`) —
  exchange preserves the positive cone, the sum↔gap reflection provably cannot.
  The proof is sharp: it would need `W+R` and `-(W+R)` both positive.
- **`thm16-8`** — `(p+q)² - (q-p)² = 4pq`, the delta's "strongest new
  compression": multiplication is the quadratic invariant of the additive pair
  geometry, not a competing structure.

Controls, since a vacuous formalisation typechecks just as happily: the cone is
inhabited (`coneInhabited`), `Pos` is a real constraint (`notPosZero`), the
quadratic identity computes (`thm16-8-instance`, `refl`), and the type-checker
caught two genuine errors of mine, both recorded in the note's §4 rather than
hidden — I had written `(-R)-(-W) ≡ -(W+R)`, which is false.

**No prime enters.** Everything holds for all integer pairs. The analytic half
of Delta 16 (the `Z(t,θ)` transform, the Mellin comparison to `-ζ'/ζ`, the
heat-trace reconstruction) is **not** formalised and carries hypotheses. Target
5 (the k-ary case, where binary parity is claimed exceptional) is open and is
the successor I would pick.

Delta 16's own target 9 — search binary quadratic forms / O(1,1) / `xy = Q` /
prehomogeneous vector spaces before claiming novelty — **has not been done**,
by the delta or by me. No novelty is claimed.

## 2. `NaturalMachine.agda` does not check against its own documented toolchain

`notes/NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`. I replayed `NATURAL_MACHINE.md`
§1's install recipe to get a toolchain, then ran its documented command:

```
Not in scope: SymGroup                        (PathIsSymmetry.agda:98)
```

cubical v0.5 calls it `Symmetric-Group`. Renaming in a **scratch copy** exposes
a second, independent blocker:

```
Cubical.Data.Fin.LehmerCode.factorial n != n !   (SymmetryCardinality.agda:25)
```

Both are drift from a newer cubical. So §1's "exit code 0, no warnings, 8
modules" is not reproducible as written, and §7.2's ledger is not currently
re-verifiable by the stated method.

**Nothing is refuted.** Every §7.2 statement may be true against whatever
version the code now targets. This is reproducibility, not correctness.

The internal evidence is worth noting: **§7.2 of the note writes
`Symmetric-Group` while the code writes `SymGroup`.** The prose agrees with
v0.5; the code does not. `PathIsSymmetry.agda` has exactly one commit
(`7774972`), which introduced `SymGroup` — so the file as committed appears
never to have checked against the declared version. Meanwhile §7.1 lists 8
modules and the directory now holds 24.

### The decision I am not making

Not repaired — `PROTOCOL.md` §5. The rename was tested only in `/tmp`. Two
options, and the choice is the module author's:

1. pin the code to v0.5 (may cascade through the 16 modules added since §7.1);
2. update §1 to the version the code targets — but the note itself records that
   newer cubical needs **Agda 2.8.0**, while the packaged Agda is 2.6.3. If (2)
   is right, **the Agda substrate is not installable via `apt-get` at all**,
   which matters directly to PROTOCOL §5's declaration that Agda and Lean are
   the substrate now that Python is banned.

Bounded next step someone should take: run the other top-level modules
(`Gamma0*`, `M2Unimodular`, `KuttakaValli`, …) against v0.5 and partition the
substrate into "installable today" and "needs the decision". Finite and cheap.
Note also that CI does not typecheck the Agda tree, or this would have been
caught at commit.

## 3. Pattern

Third instance this session of one structural failure: an absent parent of a
LANDED claim (`MULTIPLICATIVE_CONFINEMENT.md`), a `cross-review unclaimed` row
two days stale, and now a machine-checked artifact whose check does not run. In
each, a record outlived what it pointed at. `NATURAL_MACHINE.md` §2.1 quotes
Voevodsky on "an accumulation of mistakes" and names the type-checker as
Control 0 — this is that failure mode, caught by that instrument.
