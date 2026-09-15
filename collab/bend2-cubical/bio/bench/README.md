# The N-cell benchmark: one shared program, N cell states, and what the premium was

The question (research/BIOLOGY_FRONTIER_20260914.md §3): biology's population
pattern is one generator over many local states. Does representing the population
as `shared generator ⊗ superposed residual states` — the N cells as ONE superposed
value with the program applied once — win on the interaction net against a flat
list of cells? Theory says: the shared part is paid once, the per-branch part costs
the same as standalone plus one commutation per match on the state, so `supin`
should be at or slightly below the list. The first measurement said 1.46× *above*.
The second session (2026-09-15) found why, and it is the runtime implementation,
not the calculus.

Program: the word of eight knockdowns `[kdTF, kdTG, kdHD, kdTF, kdTG, kdTF, kdTG, kdHD]`
run on each cell, then observe the reporter. Cells vary in all four coordinates.
Representations (all on `--to-hvm4-full`, HVM4 `-S -s`; collapsing the result with
`-C` adds no interactions, checked):

- **list** — a flat list; the program `prog` is re-entered per cell;
- **hoist** — the program bound once outside the map, `(λw. mapProgW(w, cells))(program())`;
- **supin** — `prog(&0{&1{…}, &1{…}})`: the cells superposed (labels by depth), the
  program applied once, every match commuted over the superposition by the net;
- **supout** — `&0{prog(c1), prog(c2), …}`: separate applications, results superposed.

Results were verified equal between `list` and collapsed `supin` for every N
(no label collision with HVM4's auto-dup labels). `run.sh` prints every table.

## 1. The emitter's output (Bend → `--to-hvm4-full`)

**regime light** (Peano naturals, program a literal):

| N | list | hoist | supin | supout | supin/hoist |
|---|---|---|---|---|---|
| 1 | 467 | 504 | 460 | 460 | 0.91 |
| 2 | 1063 | 1135 | 1362 | 1051 | 1.20 |
| 4 | 2157 | 2299 | 3066 | 2135 | 1.33 |
| 8 | 4354 | 4636 | 6514 | 4312 | 1.41 |
| 16 | 8739 | 9301 | 13372 | 8657 | 1.44 |
| 32 | 17518 | 18640 | 27122 | 17356 | 1.46 |

**regime heavy** (the shared program forced-expensive: `natEqb(mul(30,30), 900)`;
a head-only gate is satisfied lazily in 14 itrs and shares nothing):

| N | list | hoist | supin | supout | supin/hoist |
|---|---|---|---|---|---|
| 1 | 825177 | 825214 | 825170 | 825170 | 1.00 |
| 2 | 1650483 | 825845 | 826072 | 1650471 | 1.00 |
| 4 | 3300997 | 827009 | 827776 | 3300975 | 1.00 |
| 8 | 6602034 | 829346 | 831224 | 6601992 | 1.00 |
| 16 | 13204099 | 834011 | 838082 | 13204017 | 1.00 |
| 32 | 26408238 | 843350 | 851832 | 26408076 | 1.01 |

**I64 fields** (native numbers; records still nested pairs). Before the fix below
every I64 literal was emitted as `0` and this program computed garbage; after it,
results agree with the checker for every N:

| N | list | supin | supin/list |
|---|---|---|---|
| 1 | 413 | 406 | 0.98 |
| 2 | 824 | 1083 | 1.31 |
| 4 | 1646 | 2437 | 1.48 |
| 8 | 3290 | 5145 | 1.56 |
| 16 | 6578 | 10561 | 1.61 |
| 32 | 13154 | 21393 | 1.63 |

## 2. The same program hand-written in HVM4 with FLAT constructors (`flat/gen.py`)

The emitter encodes `@cell{tf,tg,rp,hd}` as `#Pair{#cell, #Pair{tf, #Pair{tg,
#Pair{rp, #Pair{hd, #One}}}}}` and matches it through six nested `λ{#Pair: …}`
cases plus a tag case; a nullary `@kdTF` is `#Pair{#kdTF, #One}`. Hand-written
with one `#C{tf,tg,rp,hd}` constructor and bare `#TF/#TG/#HD`:

**Peano numbers** (the emitter's `#Suc/#Zer`):

| N | list | supin | supin/list |
|---|---|---|---|
| 1 | 178 | 173 | 0.97 |
| 2 | 379 | 438 | 1.16 |
| 4 | 769 | 957 | 1.24 |
| 8 | 1549 | 2039 | 1.32 |
| 16 | 3109 | 4164 | 1.34 |
| 32 | 6229 | 8449 | 1.36 |

**native numbers**:

| N | list | supin | supin/list |
|---|---|---|---|
| 1 | 160 | 155 | 0.97 |
| 2 | 319 | 300 | 0.94 |
| 4 | 637 | 590 | 0.93 |
| 8 | 1273 | 1170 | 0.92 |
| 16 | 2545 | 2330 | 0.92 |
| 32 | 5089 | 4650 | 0.91 |

## 3. Reading

1. **The premium is the emitter's data encoding, not the calculus.** With flat
   constructors and native numbers, superposed inputs beat the list by 9% at
   every N ≥ 2 — the shared word traversal and `@step` expansion amortised, the
   per-branch work unchanged — which is exactly the theoretical expectation.
   The absolute per-cell cost also falls from ≈550 (emitted) to ≈160.
2. **Mechanism, as a reading [R]:** a match on a superposed value commutes
   (MAT–SUP) and duplicates its continuation once per superposition level. With
   the nested-pair record every step performs ~7 such matches on the state, each
   duplicating a continuation that contains all the deeper ones, so the
   duplication work per branch grows with the nesting depth of the encoding.
   With one constructor there is one commutation and one duplication per step.
   The I64 table isolates this: cheap arithmetic leaves the record matching as
   nearly all of the per-cell work, and the premium rises to 1.63×.
3. **Peano arithmetic in superposition is the residual 1.36×** of the flat-Peano
   table: after the commutation the duplicated arm receives its field values as
   superpositions, so `@add` recurses through `#Suc` chains commuting at every
   constructor. Branch-specific data should be cheap, or native, under
   superposition — the fibre picture's "residue" wants to be small.
4. **A second bug found on the way:** both HVM4 emitters had `Val _ -> "0"`, so
   every `I64` (and `F64`) literal compiled to `0`, silently. Fixed in
   `cubical-paths.patch` (`Target/HVM4.hs`, `Target/HVM4Full.hs`): I64 literals
   are printed, negatives as `(0 - n)`; F64 fails loudly. HVM4 numbers are
   unsigned 32-bit, so a signed value outside `[0, 2³²)` is represented modulo
   2³² on the runtime (`+3 - +10` prints 4294967289) — a runtime limitation now
   visible instead of a zero. `elucidator.bend`'s main (I64) now runs correctly
   on the full runtime (161 itrs); previously it would have printed zeros.
5. **Still true from the first pass:** the heavy regime shows superposing the
   states shares the program exactly as call-by-need hoisting does; `supout`
   shares nothing. And HVM4 here is the sequential C runtime, itrs only.

**What would fix the emitter:** emit Bend `type` constructors as native HVM4
n-ary constructors (`#cell{tf,tg,rp,hd}`, `#kdTF`) instead of tagged pair chains,
and consider native numbers for `Nat` where the program never pattern-matches
past the head. That is a `Target/HVM4Full.hs` change, not a calculus change; the
hand-written files are the target output.
