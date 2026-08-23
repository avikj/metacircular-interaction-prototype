# Connected finite atlases compile to base-fibre fixed points

`MathMachine` now carries finite connected-groupoid atlases. A chosen spanning
transport `toChart` reconstructs every chart value from a single base value;
non-tree arrows act as loop generators on the base fibre.

`compileAtlas` therefore replaces arbitrary per-chart assignments by:

- base elements fixed by every loop generator;
- their transported coherent families;
- for every rejected base value, the first loop index and its non-fixed image.

The richer holonomy action is retained rather than collapsed to an acceptance
bit. `round1` executes installed atlases and logs arbitrary-assignment count,
fixed-base count, and tear count separately.

Exact finite control: four charts, six base values, transports
`a ↦ a+c mod 6`, and holonomy `a ↦ -a mod 6`.

```text
arbitrary chart assignments: 6^4 = 1296
base candidates: 6
fixed coherent families: 2 (base 0 and 3)
eliminated branches: 1294
holonomy failures retained: 4 (base 1,2,4,5)
```

The two reconstructed families and all four failure witnesses are checked
exactly. This is a finite connected-atlas compiler, not a claim that arbitrary
higher or disconnected descent reduces to one fixed-point set.
