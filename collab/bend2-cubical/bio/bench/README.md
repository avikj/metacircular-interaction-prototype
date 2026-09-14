# The N-cell benchmark: one shared program, N cell states, four representations

The question (research/BIOLOGY_FRONTIER_20260914.md §5): biology's population
pattern is one generator over many local states. Does representing the population
as `shared generator ⊗ superposed residual states` — the N cells as ONE superposed
value with the program applied once — win on the interaction net against a flat
list of cells?

Program: the word of eight knockdowns `[kdTF, kdTG, kdHD, kdTF, kdTG, kdTF, kdTG, kdHD]`
run on each cell, then observe the reporter. Cells vary in all four coordinates.
Four representations, on the full cubical runtime (`--to-hvm4-full`, HVM4 `-s -C64`):

- **list** — a flat list; the program `prog` is re-entered per cell (each use of the
  ref `@program` builds it afresh);
- **hoist** — the program bound once outside the map, `(λw. mapProgW(w, cells))(program())`,
  i.e. ordinary call-by-need sharing;
- **supin** — `prog(&0{&1{…}, &1{…}})`: the cells superposed (labels by depth), the
  program applied once, the match commuted over the superposition by the net;
- **supout** — `&0{prog(c1), prog(c2), …}`: separate applications, results superposed.

Two regimes: **light**, the program is a literal; **heavy**, the program is gated
behind a forced computation (`natEqb(mul(30,30), 900)`; a head-only gate would be
satisfied lazily in 14 itrs and is not a shared cost). Generated files
`pop_{light,heavy}_{list,hoist,supin,supout}_N.bend`; `run.sh` prints the tables.
Measured 2026-09-14:

**regime: light**

| N | list | hoist | supin | supout | supin/hoist |
|---|---|---|---|---|---|
| 1 | 467 | 504 | 460 | 460 | 0.91 |
| 2 | 1063 | 1135 | 1362 | 1051 | 1.20 |
| 4 | 2157 | 2299 | 3066 | 2135 | 1.33 |
| 8 | 4354 | 4636 | 6514 | 4312 | 1.41 |
| 16 | 8739 | 9301 | 13372 | 8657 | 1.44 |
| 32 | 17518 | 18640 | 27122 | 17356 | 1.46 |

**regime: heavy**

| N | list | hoist | supin | supout | supin/hoist |
|---|---|---|---|---|---|
| 1 | 825177 | 825214 | 825170 | 825170 | 1.00 |
| 2 | 1650483 | 825845 | 826072 | 1650471 | 1.00 |
| 4 | 3300997 | 827009 | 827776 | 3300975 | 1.00 |
| 8 | 6602034 | 829346 | 831224 | 6601992 | 1.00 |
| 16 | 13204099 | 834011 | 838082 | 13204017 | 1.00 |
| 32 | 26408238 | 843350 | 851832 | 26408076 | 1.01 |

## Reading, without overclaiming

1. **Superposing the states shares the program exactly as hoisting does.** In the
   heavy regime `supin` pays the 825k-interaction program once, like `hoist`; the
   naive `list` and `supout` pay it N times. Sharing is real and it is the sharing
   the director's §14–16 describe — but call-by-need hoisting obtains the same
   sharing.
2. **Per cell, superposition costs about 1.45× a plain map, and the ratio
   stabilises with N.** Marginal interactions per additional cell: list ≈ 550,
   hoist ≈ 585, supin ≈ 850 (light); the same increments appear on top of the
   shared 825k in the heavy regime. The overhead is the net commuting every
   `match` on the cell over the superposition (a DUP–SUP interaction per
   constructor per step); it does not amortise, because the per-cell work here
   *is* matching on the cell.
3. **This is the same law SYNTHESIS.md §4 measured**: superposition pays exactly
   when the *dispatch* dominates the per-branch work (one `coe` line over many
   values: 0.37 at N=8) and loses by a constant when the per-branch work
   dominates (`neg` on a superposition: 1.80). A state-transition program is
   the second case. So the honest statement of §16 is: for populations whose
   per-cell work is state-dependent stepping, `shared generator ⊗ superposed
   states` gives the sharing of call-by-need at a ~1.45× per-cell premium; it
   wins only where the shared operation itself is the expensive part and the
   per-state residue is cheap (transport along one proved equivalence of a
   batch of values), which is the fibre-routing case, not the stepping case.
4. **Not measured**: wall clock and memory at scale (HVM4 here is the
   sequential C runtime; itrs are the only stable number), any tensor or GPU
   baseline, and any real single-cell workload. The graph the director asked
   for (interactions per cell vs N) is the table above: flat on the shared
   part, constant premium on the local part.
