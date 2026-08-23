# The sum–gap involution swaps centre and relative direction, and multiplication is their quadratic invariant

**Status:** machine-checked in Cubical Agda, `--safe`, zero postulates, zero
holes. Formalises targets 1–4 of Prime-Pair Atlas **Delta 16**
(`collab/upstream/library/raw/`, user-supplied 2026-08-14).

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

**Code:** `formal/cubical/CenterRelative.agda` (333 lines, 28 top-level names).

---

## 1. What Delta 16 asked for, and what is now checked

Delta 16 closes with ten "next theorem targets". The first four are explicit
Cubical Agda requests. All four are now checked:

| Delta 16 target | Agda name | status |
|---|---|---|
| 1. the integral Φ equivalence | `Pair≃CR`, `Pair≡CR` | **checked** |
| 2. `J₂_CR (W,R) = (-R,-W)` | `thm16-1` | **checked** |
| 3. positivity `W > \|R\|`; J₂ exits it | `InCone`, `thm16-4` | **checked** |
| 4. `Q = W²-R² = 4pq`, `Q∘J₂ = -Q` | `thm16-8`, `thm16-6-J` | **checked** |

Everything below is a statement that appears with the stated type in that file,
which Agda 2.6.3 accepted against cubical v0.5 with exit code 0.

## 2. The mathematics

Write a pair of legs as `(p,q)` and pass to centre-relative coordinates

```text
W = p + q   (centre / sum),      R = q - p   (signed gap).
```

**Two involutions that must not be conflated.** Delta 16's own "crucial
correction" is that earlier synthesis merged the leg exchange `τ(p,q) = (q,p)`
with the one-leg sign reflection `J₂(p,q) = (p,-q)` — the operation that turns
a sum into a difference. In centre-relative coordinates they are entirely
different maps, and this is `thm16-1-τ` and `thm16-1`:

```text
τ_CR (W,R) = (W, -R)          -- negates the relative coordinate
J₂_CR(W,R) = (-R, -W)         -- SWAPS centre and relative, up to sign
```

So the fixed-centre foliation `W = N` (Goldbach slices) is carried by `J₂` to
the fixed-relative foliation (gap slices). Sum problems and gap problems are
exchanged by an involution that does not fix the coordinate roles.

**The quadratic invariant.** With `Q(W,R) = W² - R²`:

```text
Q ∘ τ_CR = Q          (thm16-6-τ)
Q ∘ J₂_CR = -Q        (thm16-6-J)
Q(Φ(p,q)) = 4pq       (thm16-8)
```

The last is `(p+q)² - (q-p)² = 4pq` — Delta 16 calls it the delta's "strongest
new compression", and the reason is the third line read against the first two:
**the additive centre/gap geometry and multiplication are not competing
structures; multiplication is the quadratic invariant of the additive pair
geometry.** `thm16-8-instance` is the worked case `(2,3) ↦ 5² - 1² = 24 = 4·2·3`,
checked by `refl`.

**The positive cone, and the real obstruction.** Positivity of both legs is
exactly `W > |R|`. Stated without an absolute value (cubical v0.5 has no ℤ
order module), that is: both cone coordinates are positive,

```text
InCone (W,R) = Pos (W - R) × Pos (W + R),
```

and `thm16-3-diff` / `thm16-3-sum` check that these two coordinates are exactly
the doubled legs, `W-R = p+p` and `W+R = q+q`.

Then the correction Delta 16 says "should replace any earlier imprecise
statement", checked as the pair `corollary16-5`:

- **exchange preserves the cone** (`exchangePreservesCone`);
- **the one-leg reflection provably cannot** (`thm16-4`).

The proof of `thm16-4` is the sharp form of the obstruction: `InCone (J₂_CR x)`
demands `Pos (-(W+R))` while `InCone x` already gives `Pos (W+R)`, and no
integer and its negation are both positive (`posAnti`). **The positive-cone
obstruction is not exchange; it is the sum↔gap reflection**, and what breaks is
one sign, not one inequality.

**The lattice equivalence.** `Φ(p,q) = (p+q, q-p)` lands in
`L = {(W,R) : W ≡ R mod 2}`, and

```text
Pair≃CR : (ℤ × ℤ) ≃ Σ[ W ∈ ℤ ] Σ[ R ∈ ℤ ] (isEven (W - R) ≡ true)
Pair≡CR = ua Pair≃CR
```

The parity constraint is carried by cubical's **decidable** `isEven : ℤ → Bool`,
so the fibre `isEven n ≡ true` is a proposition for free (`isPropEvenT`, from
`isSetBool`) and the Σ-type is a genuine sublattice rather than a type with
extra data. The inverse extracts the half via `isEvenTrue` and needs doubling
to be injective, which is `·lCancel` at `2` together with `¬ (2 ≡ 0)`.

Because `Pair≡CR` is a path, every dependent structure transports along it.
That is the univalent content: `(p,q)` and `(W,R)` are not merely related by a
formula, they are equal as types.

## 3. What this does and does not establish

**Does.** Delta 16's four formalisation targets, including its own correction
(Cor 16.5) and its own headline compression (Cor 16.8). The correction is now
machine-checked against the imprecise statement it replaces, which is the
strongest form in which a correction can be recorded.

**Does not.**

- **No prime enters.** Every statement is about ℤ² and holds for all integer
  pairs. Delta 16 says the arithmetic question is *how the prime-supported
  measure sits relative to these foliations*; nothing here touches that. Calling
  this a prime-pair result would be false.
- **No analysis.** The spectral transform `Z(t,θ) = P(t+iθ)P(t-iθ)`, the Mellin
  comparison to `-ζ'/ζ`, and the heat-trace reconstruction claim in Delta 16 are
  **not** formalised and not checked. They carry analytic hypotheses; this
  module is pure lattice algebra.
- **No hyperbolic coordinates.** Delta 16's `(u,η) = (√(pq), ½log(q/p))`
  (Thm 16.9, Cor 16.10) needs positive reals and is untouched.
- **Higher arity untouched.** The `V_k = ℤ^k/ℤ·1` analysis, the transposition
  trace generating function `1/((1-t)^{k-2}(1+t))`, and the claim that binary
  parity is exceptional are **not** formalised. Delta 16 target 5 remains open.
- **The Sanskrit compression in Delta 16 is a restatement**, not a separate
  result, and nothing in it is checked beyond what is above.

**Grade.** This is `V3` on the library index's own ladder (§6: machine-checked,
zero sorries) for exactly the four targets named, and no grade at all for
anything else in Delta 16.

## 4. Controls (`PROTOCOL.md` §7)

A vacuous formalisation typechecks as happily as a substantial one, so:

1. **`coneInhabited`** — `InCone (Φ(1,1))` is inhabited, so `thm16-4` is not
   vacuously true about an empty cone.
2. **`notPosZero`** — `¬ Pos 0`, so `Pos` is a real constraint rather than a
   predicate satisfied by everything.
3. **`thm16-8-instance`** — `Q(Φ(2,3)) ≡ 24` by `refl`, so the quadratic
   identity computes and is not an abstract nonsense equality.
4. **`corollary16-5`** — packages the *contrast* as one term. If the one-leg
   reflection also preserved the cone, this pair could not be inhabited.
5. **The type-checker itself.** Two genuine errors were caught by it during this
   session and are recorded rather than hidden:
   - I wrote `(-R) - (-W) ≡ -(W+R)`, which is false — that expression is
     `W - R`. The obstruction lives in the *second* cone coordinate, not the
     first. Agda rejected it; the fixed statement is `(-R) + (-W) ≡ -(W+R)`.
   - The cone witness was `(0 , refl)`; the centre of `(1,1)` is `2`, so the
     ℕ index is `1`. Agda rejected it.

## 5. Rigor boundary

- **Checked:** every name listed in §1 and §4, in
  `formal/cubical/CenterRelative.agda`, under
  `--cubical --guardedness --safe --no-import-sorts`. `--safe` propagates to the
  whole imported closure, so no postulate, `TERMINATING` pragma, or unsafe
  primitive appears anywhere in the dependency cone. Grep for
  `postulate|TERMINATING|primTrustMe|trustMe|{!|REWRITE` over the file: no
  matches.
- **Toolchain:** Agda 2.6.3 (Ubuntu noble), cubical library v0.5 at tag `v0.5`,
  `LC_ALL=C.UTF-8`, installed by replaying `NATURAL_MACHINE.md` §1's own recipe.
  The recipe installs correctly. **It no longer checks the development it was
  written for** — see `notes/NATURAL_MACHINE_TOOLCHAIN_DRIFT.md`. This module
  checks against that toolchain standalone and does not import NaturalMachine.
- **Cited, not proved here:** `·lCancel`, `isEvenTrue`, `trueIsEven`,
  `posNotnegsuc`, `injPos` from cubical v0.5; the commutative-ring solver
  discharges every polynomial identity and is itself `--safe`.
- **No novelty claimed.** `(p+q)² - (q-p)² = 4pq` is classical; the
  centre-of-mass/relative change of coordinates is classical; `x² - y²` as the
  invariant of the split form is classical. Delta 16 itself says of the cone
  algebra "no physical Lorentz claim is implied; this is exact 1+1-dimensional
  cone algebra", and target 9 of its own list is *search the literature on
  binary quadratic forms, O(1,1), the hyperbola `xy = Q`, prehomogeneous vector
  spaces — do not reinvent them*. **That search has not been done**, by Delta 16
  or by me. What is claimed is the formalisation and the checked correction, not
  the mathematics.

## 6. Provenance of the source

Delta 16 was supplied directly by the human owner on 2026-08-14 as message text,
not recovered from the library export. The Delta 02–12 series *was* recovered in
the same session and is archived at `collab/upstream/library/`; Delta 16 postdates
that series and is archived alongside it. Per `collab/upstream/README.md`
conventions, archiving is not promotion: the four checked statements above take
their authority from the Agda file, not from the delta.

Human direction the same session: **"Distinction theory is an archive of
untrustworthy inspirational source material."** Nothing from that stratum enters
this note. The mixed-grade separation is recorded in the import commit: the
untrustworthy material is confined to the image and pasted-text assets, and none
of the 82 markdown files in the export carry its vocabulary.

## 7. Successor seeds

1. `PROVE`: Delta 16 target 5 — the `k`-ary case. `V_k = ℤ^k/ℤ·1`, the
   transposition trace generating function `Σ_j tr(τ|Sym^j V_k) t^j =
   1/((1-t)^{k-2}(1+t))`, and the claim that **binary parity is exceptional**.
   That last is the one worth checking first: it is the structural reason the
   binary channel is multiplicity-free and the ternary channel is not, and it is
   a finite representation-theoretic statement.
2. `PROVE`: transport a *structure* along `Pair≡CR`, not just the types. The
   natural test is the pair weight `K(p,q) = a_p a_q`: transporting it should
   yield `K̃(W,R)` natively, in the same sense that `NATURAL_MACHINE.md` §5.2
   transports `+` to ripple-carry. Until that is done, `Pair≡CR` is an
   equivalence of carriers only, and `NATURAL_MACHINE.md`'s own standard —
   *"an asserted isomorphism is not transport"* — is not yet met here.
3. `SEARCH`: Delta 16's own target 9, unperformed. Before any novelty claim
   attaches to the cone algebra, the binary-quadratic-form and O(1,1) literature
   must be checked. I did not search and say so rather than posing it as open.
4. `PROVE`: whether `Q` extends to the `k`-ary relative space as a genuine
   invariant, or whether the quadratic form is itself a binary accident. Delta
   16 asserts the four foliations (`W`, `R`, `Q`, `η`) are coordinate foliations
   of one 2D geometry; at `k ≥ 3` the relative space is `(k-1)`-dimensional and
   no single quadratic invariant is expected to play the same role.
