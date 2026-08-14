# The charge tower has no monodromy, because it has no loops

**Delta 14, Programs 14.74 / 14.75 / 14.76.**
Author: `cf-tessera-d14-01`, 2026-08-14.
Substrate: Agda 2.6.3 + cubical v0.5, `--cubical --guardedness --safe
--no-import-sorts`. No postulates, no holes, no `TERMINATING`.

| module | program | `agda -W error` | cold time |
|---|---|---|---|
| `formal/cubical/NaturalMachine/SetBaseNoMonodromy.agda` | **14.76** | **exit 0** | ~2 s |
| `formal/cubical/NaturalMachine/ChargeGradedPeeling.agda` | **14.74** | **exit 0** | ~3 s |
| `formal/cubical/NaturalMachine/SieveScaleTower.agda` | **14.75** | **exit 0** | ~2 s |

Verify:

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8
cd formal/cubical
agda -W error NaturalMachine/SetBaseNoMonodromy.agda
agda -W error NaturalMachine/ChargeGradedPeeling.agda
agda -W error NaturalMachine/SieveScaleTower.agda
```

**None of the three is imported by `formal/cubical/NaturalMachine.agda`** —
that is the parent's call, per the block brief. The root aggregate was
re-verified at **exit 0** alongside them (~112 s cold; the only warnings are
the pre-existing Cubical-pattern-matching ones in `DigitTowerLimit`,
`PMCokernel`, `PMTorus`, `PayloadMorphism` and `SmithPathCountedExecution`,
none from these files). `PerspectiveCore.agda`,
`SieveFiber.agda` and `RoughSplit.agda` are **unmodified**; all three are
imported, none is edited, not even by a pointer comment.

---

## 1. The verdict on 14.76

Delta 14 asks, verbatim:

> "Search for actual loop transport on those fibers; **if every loop acts
> trivially, kill the parity-monodromy route.**"

**Verdict: DISSOLVED — and the parity-monodromy route dies with the
dissolution.**

The single fact that decides it:

> **The base of every sieve fibration this lane has built is a set (a
> 0-type), so it has no nontrivial loops at all. There is nothing for
> monodromy to be.**

This is *not* the finding "we searched the loops and each acted trivially".
It is one level below that: the search space is empty. `MonodromyOf F b p`
asks for a loop `p : b ≡ b` that moves a point of `F b`; over a set,
`p ≡ refl`, so no `F` whatsoever can be moved. The checked term is one
line:

```agda
setNoMonodromy :
  {B : Type ℓ} → isSet B
  → (F : B → Type ℓ') (b : B) (p : b ≡ b)
  → MonodromyOf F b p → ⊥
setNoMonodromy hB F b p (x , nontrivial) =
  nontrivial (subst (λ r → subst F r x ≡ x) (hB b b refl p) (substRefl {B = F} x))
```

`hB b b refl p : refl ≡ p` is the whole proof. Instances, all checked:

| base | why it is a set | term |
|---|---|---|
| `Vis = ℕ × ℕ × ℕ` | `SieveFiber.isSetVis` | `visNoMonodromy` |
| `Sieve = Dom / ∼` (the HIT) | `SQ.squash/` | `sieveNoMonodromy` |
| `Bool` (the charge index) | `isSetBool` | `chargeNoMonodromy` |
| every level `O₀ … O₃` of the scale tower | `isSetUnit`, `isSetℕ`, `isSet×` | `tower₀…₃NoMonodromy` |

So there is no horizon `z`, and no stage of the quotient construction, at
which a loop appears.

### 1.1 Why this is stronger than what `PerspectiveCore` already had

`PerspectiveCore.constNoMonodromy` (P14.24 / C14.25) covers **constant**
families over any base, and its own `SCOPE` paragraph says so explicitly:
it does *not* reach `fiber pr`, which varies over the base, and proving
that bundle's monodromy trivial "needs the (true, but separate) fact that
the bundle is trivialisable naturally. That is not proved here."

`setNoMonodromy` closes exactly that gap in the direction the sieve lane
needs. Over a set base, **varying is as harmless as constant** — no
trivialisation is required, because the loop itself is trivial. The sieve
lane's families (`Fibre`, `q⁻¹(−)`, the charge sectors) all vary; all of
them are now covered.

### 1.2 The negative is not vacuous

A negative about an uninhabitable type would be worthless. `MonodromyOf`
is inhabitable, and §3 of the module exhibits an inhabitant: the `Bool`
double cover of the circle,

```agda
Cover : S¹ → Type
Cover base     = Bool
Cover (loop i) = notEq i

coverTransport : subst Cover loop true ≡ false
coverTransport = refl                    -- by normalisation

s¹Monodromy : MonodromyOf Cover base loop
```

and the contrapositive that names the price of monodromy:

```agda
S¹NotSet : isSet S¹ → ⊥
S¹NotSet h = setNoMonodromy h Cover base loop s¹Monodromy
```

**Sheet exchange forces the base out of the 0-types.** That is the exact
cost anyone reviving the parity-monodromy route has to pay first.

### 1.3 What this does and does not close

- It does **not** say the sieve lane has no obstruction. It has one:
  `SieveFiber.noChargePreservingSection` — no section of `q` is
  charge-preserving. The claim is only that this obstruction is not, and
  cannot be, a monodromy.
- It **redirects** rather than closes the lane. Any obstruction here must
  come from somewhere other than loop transport: descent failure at
  $\pi_0$ (which is what is actually proved), a non-invariant sector
  predicate (`PerspectiveCore.SectorBreak`), or a genuinely higher index
  object that nobody has built.
- It says nothing against a future non-set index (an action groupoid with
  nontrivial stabilisers, a delooping, a torsor with a real automorphism).
  It says such a lane must **supply the non-set base first**, and
  `S¹NotSet` is the template for what that supply looks like.

---

## 2. Program 14.74 — a **term**, with one stated gap

`NaturalMachine/ChargeGradedPeeling.agda`. Charge is a dependent index;
least-prime peeling is the directed transformation.

**The instance.** `lpf n` = least divisor ≥ 2 by trial division;
`peel n = n / lpf n` for `n ≥ 2`, and `peel n = n` for `n < 2`.

**ℕ-graded form** (`H k` = states with exactly `k` prime factors):

```agda
peelGrade : (k : ℕ) → H (suc k) → H k
```

The index **strictly decreases by exactly one**. This is the specified
index change, and it rests on the exhaustively-checked

```agda
peelDrops : n ∈ domain → ltᵇ n 2 ≡ false → suc (Ω (peel n)) ≡ Ω n
```

**Bool-graded form**, in `PerspectiveCore.Graded`'s own shape
(`module GradedCharge = Graded {C = Bool} G`, `Total = Σ Bool G`,
`base = fst`), with `T : Total → Total` whose base component is
**computed** (`charge ∘ peel`), not assumed:

- `noSectorRestriction` — **T14.44's hypothesis fails.** For the sector
  `charge = false`, the state 4 has `base (T (false , 4)) = true`. Peeling
  does not restrict to a charge sector, because it is charge-changing by
  design.
- `noSquareRestriction` — **and the naive repair fails too.** One hopes
  the *square* restricts, since $\neg\neg = \mathrm{id}$. It does not:
  `T (true , 2) = (false , 1)` and `T (false , 1) = (false , 1)`, because
  `peel 1 = 1`. A prime peels to the unit and stops.

**C14.46, landed.** Carve out the sub-object the exception excludes —
$\Omega \ge 2$ — and closure holds, with its transport supplied as data:

```agda
P¹ : (r : Bool) → G₂ r → G (not r)      -- one step, over `not`
P² : (r : Bool) → G₂ r → G r            -- the square: index preserved
```

The third component of each is a *path in the index* (`peelFlips`,
resp. `peelSquareCloses`) composed with the state's own index proof. The
transport that makes the square close is exactly
`indexPathIsNotNot = notnot`.

> **Canonical closure is dependent-index preservation up to specified
> transport** — and, the part not in the slogan, *only after the fixed
> point is removed*. No transport repairs a fixed point; that is why
> `noSquareRestriction` is a theorem and not a lemma about carelessness.

Also checked: "a fixed charge is a fibre" as maps rather than prose
(`sectorToFibre`, `fibreToSector`, `sector-fibre-roundtrip`).

**Stated, not proved:** that $\Omega(n/p^-(n)) = \Omega(n) - 1$ for all
$n \ge 2$. Every `refl` in the module is X = 30 arithmetic, exactly as in
`SieveFiber`. The general statement is elementary and is **labelled, not
smuggled**.

---

## 3. Program 14.75 — a **term** for four finite levels; the limit is **stated only**

`NaturalMachine/SieveScaleTower.agda`. Horizons $z = 0,2,3,5$:

| level | $O_z$ | observation | fibre over the trivial state |
|---|---|---|---|
| 0 | `Unit` | `o₀ n = tt` | all 30 (a triviality, and recorded as one) |
| 1 | `ℕ` | $v_2$ | the 15 odd numbers |
| 2 | `ℕ × ℕ` | $(v_2,v_3)$ | the 10 numbers coprime to 6 |
| 3 | `ℕ × ℕ × ℕ` | $(v_2,v_3,v_5)$ | the 8 numbers coprime to 30 |

Every square commutes **by `refl`** (`tower-commutes-10/21/32`): the tower
is strict, not merely coherent. And `o₃≡q n = refl` — the top of the tower
*is* `SieveFiber.q`, definitionally, so the fibre census re-derives
`fiberAt-1` through the tower's own observation rather than resembling it.

**The shrinkage is strict, with witnesses.** `25∈fibre₂` and `25∉fibre₃`
(25 survives to $z=3$ and dies at $z=5$); `3∈fibre₁` and `3∉fibre₂`.

**Charge-forgetting at every level.** `noChargeDescent₀ … ₃`: the pair
$1 \sim 7$ is indistinguishable at *every* horizon of this tower and has
opposite charge, so the charge descends to no level, not merely to no top.

**The residual bit is a property of the top level only.**
`level2ResidualNotABit` (25: rough part 25, $\Omega = 2$) and
`level1ResidualNotABit` (15: rough part 15, $\Omega = 2$), against
`level3ResidualIsSmall` for the same two integers. This is
`notes/SIEVE_FIBER.md` §4's horizon-relativity read in the $z$ direction at
fixed $X$, and it is the direct instance of `CLAUDE.md`'s HOLOGRAM §7
corollary: *a constant quoted without its scale-dependence looks like
knowledge*. "$\varepsilon$ is one bit" is true at $z = \sqrt X$ and false
one level down.

**P14.39, honoured rather than assumed.** Each forgetting map has a
section (append a zero valuation), the sections compose
(`sec-32`, `sec-21`, `sec-31`), and **none of that lifts an observation**:

```agda
liftNotObservational          : ¬ (s₃₂ (o₂ 25) ≡ o₃ 25)
composedLiftNotObservational  : ¬ (s₃₂ (s₂₁ (o₁ 15)) ≡ o₃ 15)
```

The section invents $v = 0$ where the integer has $v = 2$. Structural
lifting at each adjacent stage buys nothing about the integers being
observed.

**Stated, not proved, and deliberately not attempted:** any inverse limit.
The tower is four levels of one model at $X = 30$. A genuine $O_z$ tower is
indexed by all $z \le \sqrt X$ and its limit is an $X \to \infty$ object.
P14.39 is precisely the reason not to assume the finite stages assemble,
and this file does not.

---

## 4. Where the two lenses disagree

My block's assigned lenses were **Wiener** (*the loop, not the parts, is the
object*) and **McClintock** (*have a feeling for the organism; look at the
exceptions*). They disagree about what to compute, and the disagreement is
the finding.

**Wiener** says: the circuit is the object. Find the closed loop —
observe, peel, transport back — and measure its holonomy. That is
precisely the instruction Program 14.76 encodes, and executed literally it
returns **nothing**: there is no loop in any base to have holonomy. The
cybernetic instinct is not wrong about method; it is wrong about *where the
circuit lives here*. The round trip that carries the information is
`peel²`, a loop in the **index** `Bool`, and its "holonomy" is `notnot` — a
definitional identity, not an invariant. A loop whose holonomy is forced by
the definition of `not` is a loop with no information in it.

**McClintock** says: look at the exceptions. Every positive term in these
three modules turns on a named exceptional integer:

- **1** — the fixed point of peeling. It is the whole content of
  `noSquareRestriction`, and it is why C14.46 needs a sub-object.
- **25** — survives to $z=3$, dies at $z=5$; kills the residual-bit claim
  one level down and breaks the observational lift.
- **15** — the same at $z=2$.
- **4, 2** — the two sector witnesses.
- (**49**, from `SieveFiber`'s control C, is the same phenomenon in $X$.)

**Resolution.** McClintock wins on evidence: the loop the cybernetic lens
wanted does not exist, and the exceptions produced all four theorems.
Wiener wins on framing: the *reason* the loop does not exist is a statement
about the whole circuit and not about any part of it — **every stage of the
construction is 0-truncated**, and that is a property of the tower, not of
any level. Neither lens alone reaches the verdict. The organism has no
loop; you learn that by looking at the organism as a loop.

---

## 5. Prior art

**In this corpus, and it is close — close enough that this must be said
first.** `notes/CUBICAL_QUOTIENT_AUDIT.md` (codex) §5 already lists, as
requirement 5 for a justified higher model, "a nonzero monodromy or
obstruction class invariant under change of presentation", and its §6 kill
criteria include, verbatim:

> 1. all state, fiber, and equality types are sets or finite 0-types;
> …
> 5. 0-truncation kills every claimed obstruction;

**The verdict of 14.76 was therefore predicted in prose by that audit.**
`notes/SIEVE_FIBER.md` §6 says the same thing about its own file ("`Vis`,
`Bool`, the fibres and the set quotient are all $0$-types; every obstruction
here is $\pi_0$-level. This is precisely `CUBICAL_QUOTIENT_AUDIT.md` §6's
kill criteria 1, 3 and 5 firing"). I record this as a **partial
rediscovery**, found at search time and not at audit time, which is what
`CLAUDE.md` asks for.

What is new here, and it is narrow:

1. The prose criterion is now a **checked general lemma** (`setNoMonodromy`)
   quantified over *all* families, which is strictly stronger than
   `PerspectiveCore.constNoMonodromy` and closes the gap that lemma's own
   `SCOPE` paragraph names.
2. The instances are terms at **every** base the lane uses, including the
   set quotient HIT and every level of the scale tower — so the criterion
   is discharged by citation instead of re-argument.
3. The **inhabitability control** (`s¹Monodromy`, `S¹NotSet`) is not in the
   audit and is what makes the negative non-vacuous.

**In the pinned libraries.** `cubical` v0.5 has no occurrence of
"monodromy" or "local system" anywhere in `Cubical/` (grepped).
`agda-unimath` has the full circle-descent machinery —
`synthetic-homotopy-theory/descent-circle*.lagda.md`,
`universal-cover-circle.lagda.md`, `connected-set-bundles-circle.lagda.md`
— so the `Bool` cover of $S^1$ is thoroughly standard and **no novelty is
claimed for §1.2**; I read those files' names and headers locally and
nothing more. **PROVED-grade** for what is in this repo; the standardness
claim is **CITED-grade** on locally-read source.

**Outside.** Two `WebSearch` queries, both returning nothing on point:

- *"homotopy type theory monodromy trivial when base is a set 0-type local
  system formalization"* — general HoTT expositions and unrelated
  local-systems papers.
- *"sieve parity problem Liouville obstruction as monodromy covering space
  double cover formalization"* — Tao's parity-problem posts and unrelated
  double-cover material; **no source connects the sieve parity problem to
  monodromy at all.**

**`WebFetch` is `EGRESS_BLOCKED`; I opened none of those pages and quote
none of them.** Grade: **CITED**, weakly, and absence of a hit is not
absence of prior art. (Per `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`, no
"śabda" grade is used here.)

---

## 6. An ancient-lane observation, offered narrowly

My block's ancient field was **Apollonius** — conics classified by their
*symptoma*, before coordinates existed. Apollonius does not classify a
conic by embedding it in an ambient space and reading off an invariant of
that space; he classifies it by a relation among magnitudes *constructed on
the curve itself* — the square on the ordinate against the rectangle
applied to the latus rectum, and whether that application is exact
(*parabolē*), deficient (*elleipsis*) or excessive (*hyperbolē*). The
three-way index is a **defect relation carried by the object**, not a
feature of a surrounding topology.

The parallel is exact and I state it narrowly, as *where the invariant
lives*. `SieveFiber.chargeFactors` is a symptoma:

$$\lambda(n) \;=\; \mathrm{odd}(v_2 + v_3 + v_5)\;\oplus\;\varepsilon(n),$$

a relation between what is visible and what is not, stated on the object.
The parity-monodromy route was an attempt to read the same content off an
*ambient* structure — the path space of the base — and §1 says the ambient
structure is empty. Apollonius's discipline is the right one here: the
defect is in the application, not in the plane.

I am **not** claiming the symptoma contributed to any proof — it did not;
the verdict came from `isSet`. I record it because it names the mistake the
programme was set up to test for, and because a successor tempted to reach
for ambient topology should be asked first whether the object already
carries its own excess-or-defect.

**Citation grade: background knowledge, unopened.** `WebFetch` is blocked;
I opened no source on Apollonius this session. Check it before it is quoted
anywhere with a proposition number attached.

---

## 7. Rigor boundary

**Proved (checked Agda terms, exit 0 under `-W error`):**
`setNoMonodromy`, `setLoopIsRefl`; `visNoMonodromy`, `sieveNoMonodromy`,
`chargeNoMonodromy`, `tower₀…₃NoMonodromy`; `coverTransport`,
`s¹Monodromy`, `S¹NotSet`; `peel∈`, `peelDrops`, `peelFlips`, `peelGrade`,
`noSectorRestriction`, `noSquareRestriction`, `P¹`, `P²`,
`sector-fibre-roundtrip`; the tower's commuting squares, `o₃≡q`, the four
fibre censuses, the four strictness witnesses, `noChargeDescent₀…₃`, the
three residual-bit statements, the sections and the two lift failures.

**Exhaustive-verification scope:** every `refl` over `domain` is a finite
check on $[1,30]$ performed by Agda's evaluator. Per `CLAUDE.md`, that is
proof, and it is proof *of the X = 30 statement only*.

**Planted-false controls run** (written, rejected by the typechecker,
deleted — not left in the tree):

- **A.** `charge(peel²n) = charge(n)` **without** the $\Omega \ge 2$ guard
  → rejected (`false != true`). So the guard in C14.46 is load-bearing.
- **B.** `charge(peel n) = charge n` for $n \ge 2$ (peeling preserves
  charge) → rejected. So `peelFlips` is not vacuously satisfiable.
- **C.** `subst Cover loop true ≡ true` (the loop acts trivially on the
  double cover) → rejected. So §1.2's inhabitant is a real sheet exchange
  and not a typo.

**Stated and not proved:** $\Omega(n/p^-(n)) = \Omega(n)-1$ in general; any
$X$-uniform version of any statement here; any inverse limit of the tower;
P14.39 as a general theorem (only its instance is checked).

**Not claimed:** that the sieve lane has no obstruction; that no higher
index object could exist; novelty for `setNoMonodromy` (it is `isSet`'s
definition), for the $S^1$ cover (standard), or for the graded-family
setup (standard).

**Where I am least sure.** The step I would attack first is the
identification of *the* base. `setNoMonodromy` settles every base this lane
has actually built, and `SieveFiber`'s `Sieve` is the HIT the original
proposal named — but "the sieve fibration" is a phrase, not a definition,
and a reviewer could reasonably say the intended base was never `Vis` or
`Sieve` at all but some untruncated coequalizer nobody has written down. My
answer is that such an object does not exist in the corpus, and that
`CUBICAL_QUOTIENT_AUDIT.md` §5's warning applies to it in advance ("its
loops then encode the chosen presentation unless the paths come from
genuine semantic structure"). But the honest form of the verdict is
conditional on the base, and I have stated the condition rather than hidden
it: **`setNoMonodromy` is unconditional; its application to "the" sieve
lane is conditional on the bases named in §1's table.**

Second-least sure: `noSquareRestriction`'s significance. It is a true
theorem about a real fixed point, but a reader could call it an artefact of
insisting the transformation be an endomap of the *whole* total space
rather than of the $\Omega \ge 2$ sub-object. I think the exception is the
content — the unit is where arithmetic peeling actually stops — but I would
not fight hard for the framing.
