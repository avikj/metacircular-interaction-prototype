# T25.D — `--guardedness` is not the requested later modality

**Result:** current-toolchain no-go. The existing checked T25.D module is an
honest coinductive/productivity approximation, but it does not express
UP-D0025's explicit `▷` equation. No identity modality, musical delay, or
suggestively named ordinary field should be substituted for the missing
clocked structure.

## The two Agda options are different

The project file `formal/cubical/natural-machine.agda-lib:4` enables

```text
--cubical --guardedness --safe --no-import-sorts
```

Agda 2.8's own help describes `--guardedness` as **constructor-based guarded
corecursion**. It permits coinductive records and productive definitions by
copatterns. This is exactly what
`formal/cubical/IndraNet.agda:143--202` uses:

```agda
record Net (x : J) where
  coinductive
  field
    local : L x
    image : (y : J) → Net y

netUnfold : (x : J) → Net x ≃ (L x × ((y : J) → Net y))
```

The checked right-hand side contains `Net y` directly. There is no later type
former and no tick context. Thus `--guardedness` certifies productivity of
this ordinary coinductive record; it does not turn the displayed equation
into

```text
J_x ≃ L_x × ▷ ∏_y Image_xy(J_y).
```

Agda also has a distinct option, `--guarded`, which its official Guarded Type
Theory documentation says enables Nakano later syntax through `@tick`/`@lock`
function domains. That option is not present in the repository flags. A full
search of current repo and `origin/main` found no `primLockUniv`, `@tick`,
`@lock`, `dfix`, or `pfix` interface.

Primary references:

- <https://agda.readthedocs.io/en/v2.8.0/tools/command-line-options.html>
  (`--guardedness`: constructor-based guarded corecursion);
- <https://agda.readthedocs.io/en/v2.8.0/language/guarded.html>
  (`--guarded`: ticked/Nakano later interface);
- the official example
  <https://github.com/agda/agda/blob/172366db528b28fb2eda03c5fc9804f2cdb1be18/test/Succeed/LaterPrims.agda>.

## The safe boundary

The official `LaterPrims.agda` example forms

```agda
▹ A = (@tick α : Tick) → A
```

but declares `Tick : primLockUniv`, `dfix`, and its fixed-point path `pfix` by
`postulate`. That example is not `--safe`. The present repository requires
`--safe`, and a safe module cannot import an unsafe postulate-bearing
interface. Merely adding `--guarded` to the option line therefore does not
supply the missing safe fixed-point/clock library.

The primitive file

```text
/opt/homebrew/Cellar/agda/2.8.0/share/agda/prim/lib/prim/
  Agda/Builtin/Coinduction.agda
```

does expose musical coinduction `∞`, delay `♯_`, and immediate force
`♭ : ∞ A → A`. Agda's documentation classifies this as the old coinduction
interface. It is a productivity device, not a clock-indexed Nakano later
modality: the universal immediate `♭` does not impose the tick-context
elimination restriction. Renaming `∞` to `▷` would conceal rather than close
the gap.

## Library and pin inventory

There is a live toolchain skew that does not change the result:

- `formal/cubical/BUILD.md:114--120` documents the pin Agda 2.6.3 + Cubical
  v0.5;
- the current machine runs Agda 2.8.0 and registers
  `/opt/homebrew/Cellar/agda/2.8.0/share/agda/cubical/cubical.agda-lib`, whose
  name is `cubical-0.9` and whose flags include `--guardedness`;
- the checked landing already states at `IndraNet.agda:31--43` and
  `notes/ETERNAL_GOLDEN_BRAID_DELTA25.md:65--68` that v0.5 has no `▷` and that
  the clock-quantified refinement remains open;
- a complete source-name search of installed Cubical 0.9 also found no clock,
  tick, later, `dfix`, or `pfix` module. Its relevant files, such as
  `Cubical/Codata/Conat/Base.agda:21--34`, use the same coinductive-record
  `--guardedness` interface.

So neither the documented v0.5 substrate nor the installed v0.9 substrate
supplies the requested safe later modality. The mismatch should be repaired
independently, but switching between those two versions does not close T25.D.

## A second missing term in the equation

UP-D0025 does not merely place the recursive occurrence under `▷`; it writes

```text
Image_xy(J_y).
```

The current `image : (y : J) → Net y` chooses the whole `Net y` and has no
thread-dependent `Image_xy` operation. A later-enabled successor must specify
the type and laws of `Image_xy` rather than silently identifying it with the
identity family.

## Exact status

Checked now:

- the existing coinductive `Net`, productive `weave`, unfolding equivalence,
  and bisimulation-to-path result under `--guardedness`;
- absence of a later/clock interface in current repo, `origin/main`, and the
  installed Cubical library;
- availability of the distinct experimental `--guarded` syntax in Agda 2.8,
  but only a postulate-bearing official fixed-point example.

Still required for the literal target: a vetted clocked Cubical
library/toolchain supplying a safe later/fixed-point interface, clock
quantification and force laws appropriate to the intended coinductive whole,
plus a typed `Image_xy`. Until then T25.D must remain labelled
**coinductive guardedness approximation**, not proof of the `▷` equation.

This is a bounded environment/provenance no-go, not a claim that guarded
Cubical type theory cannot express the target in a suitable implementation.

