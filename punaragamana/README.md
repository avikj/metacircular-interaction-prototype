# punarāgamana — पुनरागमन

A machine-checked cubical Agda development about **carrying derived data
without losing the identification to what it was derived from**. Everything
checks under `--cubical --safe`. Nothing is postulated, nothing is holed.

```
./check.sh
```

---

## The law

Given `f : A → B`, a point of `Carrier f` holds three fields:

```agda
base    : A
carried : B
witness : f base ≡ carried
```

and `A ≃ Carrier f`, hence `A ≡ Carrier f` by univalence.

The carried data is **not erased**, and **not preserved as independent
information**. It is *syntactically/proof-relevantly present; informationally
determined.* The fibre

```
Σ[ b ∈ B ] (f a ≡ b)   =   singl (f a)
```

is **contractible** — inhabited, not empty, with every inhabitant joined to the
canonical point `(f a , refl)` by a coherent path. Nothing is amputated;
nothing is falsely advertised as independent.

Both halves of that are load-bearing and neither may be softened into the
other. `carried` and `witness` are real terms you can project, pass, and
compute with. They contribute zero further degrees of freedom.

## The design law

> Every genuinely independent distinction must survive; determined structure
> may remain explicitly present with its determining path.

The contrast is exact:

| shape | contractible? | equivalent to base? |
|---|---|---|
| `Σ[ r ∈ ℕ ] (s + l ≡ r)` | yes | yes — the law applies |
| `Σ[ r ∈ ℕ ] (r ≤ s + l)` | no | no such equivalence exists |

which makes the constraint load-bearing rather than aspirational. A
construction either instantiates `Carrier` or it does not, and the typechecker
decides. Not prose resemblance.

## Modules

| module | content |
|---|---|
| `Punaragamana.Carrier` | the record, the contractible fibre, `Carrier≃` / `Carrier≡`, the `ua` β rule, the Σ reading, and the commuting square for an endomorphism `Φ` |
| `Punaragamana.Orbit` | coinductive trajectories. Path equality of orbits **is** bisimulation — `(x ≡ y) ≃ (x ≈ y)`, both directions and both round trips corecursive — plus the finite `lookup` / `iterate` view |
| `Punaragamana.Nucleus` | carrier and orbit commute over the **whole infinite trajectory**, not one step: `descend-orbit`, `ascend-orbit`, `transport-orbit`, `orbit-lookup` |
| `Punaragamana.Viveka` | the arithmetic instance. `योग (s , l) = s + l`, `विवेक = Carrier योग`, coordinates `सम` / `वाम` / `दक्षिण` / `प्रमाण`, the action `Φ`, and the orbit `जाल` |
| `Punaragamana.Compute` | executable regression suite — every statement holds by `refl` on concrete numerals, so Agda must normalize both sides |
| `Punaragamana.KuttakaValli_…` | the kuṭṭaka instance. Base = the three slots `पक्षः` / `परिमाणम्` / `शेषः`; **none of the three is a function of the other two**, and that is three theorems, not a preference. Carried = the pair of magnitudes. Φ is the subtractive vallī step, written with no comparison because the side slot was kept |
| `Punaragamana.Bhavana_…` | the varga-prakṛti instance over ℤ. Base = the two roots `ज्येष्ठ` / `कनिष्ठ`; carried = the `क्षेप` `a² − D b²`, which the roots determine exactly. Φ is Brahmagupta's composition, and `भावना-क्षेपः` proves the carried datum multiplies |

| `Punaragamana.Sthanivadbhava_…` | the Aṣṭādhyāyī instance. A bare `वर्ण` is **not** a Carrier — रूपम्, स्थानी and सञ्ज्ञा are mutually independent, three theorems. The ādeśa OPERATION is: base = (the varṇa , the form substituted), carried = (स्थानी , सञ्ज्ञा) of the output. 1.1.56's अल्/अनल् exception **is** the base/carried split, and `सञ्ज्ञा-अनुवृत्तिः` carries the designation over the whole orbit by bisimulation |

`Everything.agda` is the entry point, and `check.sh` drives exactly it: a
module not reachable from `Everything` is verified by nothing.

## Three findings worth recording

**1. `--guardedness` is required, and it is safe.** `--safe` rejects
`--sized-types`; it is those two *together* that are inconsistent. The cubical
library itself ships `--safe --guardedness` modules. Without the flag a
coinductive record fails productivity checking — and a function that fails the
termination check is marked non-unfolding, so a clause that literally returns
its argument stops reducing and every downstream `refl` collapses. One missing
flag, three unrelated-looking errors.

**2. `Cubical.Data.Sigma`, not `Cubical.Data.Prod`.** Prod's `×` is a data type
with no eta, so nothing reduces until the argument is case-split. Σ has eta.
This is why the square closes by `refl` for an **opaque** variable rather than
only for constructor forms.

**3. `transport` along `ua` does not reduce on a neutral variable.** It sticks
on `prim^unglue`; it computes only on canonical form. So `uaβ` is load-bearing.
`Compute` records both sides of this: `परिवहन-गणना` computes by `refl` on the
numeral `(2 , 3)`, while the uniform statement over an arbitrary `x` is
recorded there as an explicit **non-theorem**, with `परिवहन-अवतरण` (i.e. `uaβ`)
as the propositional statement that does hold for all `x`.

Definitional computation on canonical terms and propositional computation
uniformly over arbitrary terms are different computational strengths. Neither
is less real than the other.

## Adding your own construction

Instantiate the law; do not re-derive it.

1. Name your map `f : A → B`.
2. `Carrier≃ f`, `Carrier≡ f`, `carry-transport f` and the β rule
   `carry-transport-descend f` come free.
3. Any endomorphism `Φ : A → A` lifts by `Φ-carrier f Φ`, and the square
   closes **definitionally** — `Φ-square`, `Φ-ascend` are `refl`.
4. `Nucleus` gives the infinite-depth versions over orbits (needs
   `--guardedness`).
5. Add the module to `Everything.agda`, or `check.sh` will not cover it.

If your carried data is not a function of the base, it will not typecheck.
That is the law working, not an obstacle to route around.

## Toolchain

Agda **2.6.3** with agda/cubical **v0.5**. `punaragamana.agda-lib` depends on
`cubical-0.5` — v0.5 declares that name in its own `cubical.agda-lib`, so the
version is part of the library identifier and the pin is a hard resolution
constraint rather than a prose note.

Flag behaviour is version sensitive; re-verify if you move compilers.

**The pin is currently unrunnable on this machine, and saying so is the
point.** The Agda on PATH here is **2.8.0**, and agda/cubical **v0.5** does
not typecheck under it: `Cubical/Core/Id.agda` opens
`Agda.Builtin.Cubical.Id`, which 2.8.0's `prim` no longer ships, so
`./check.sh` dies with `[FileNotFound]` and **exit 42**. This happens on
`Punaragamana.Carrier`, the first module, and it happened before any of the
work described below was written — it is the toolchain, not the library.

So the development was verified against **Agda 2.8.0 with agda/cubical
v0.9** (the pair Homebrew ships together), by pointing a library file at
`.../share/agda/cubical/cubical.agda-lib` with flags
`--cubical --safe --guardedness --no-import-sorts`. Under that pair,
`Everything.agda` and every module it reaches check, **exit 0**. Two things
follow and neither may be dropped:

- Green under 2.8.0/v0.9 is *not* green under the declared pin. Nothing
  here has been checked under 2.6.3/v0.5 by this author.
- The two number-theoretic modules were written to lemma names present and
  identically typed in **both** v0.5 and v0.9 (`+Assoc`, `+Comm`, `·Assoc`,
  `·Comm`, `·DistL+`, `·DistR+`, `-Dist+`, `-DistL·`, `-DistR·`,
  `-DistLR·`, `-Cancel`, `pos0+`, `znots`, `injSuc`), and deliberately
  avoid the commutative-ring solver, whose module path moved between the
  two releases. That is a reason to expect them to check under the pin. It
  is not a substitute for checking them under the pin.

`LC_ALL=C.utf8` is **required**. Under a POSIX locale Agda crashes while
printing its own error messages for the Devanagari identifiers and replaces the
real diagnosis with irrelevant advice about code pages.
