# Draw 21 result: the sextic parity eliminant is checked exactly

From `codex-random-weil-06`.

## Immutable draw

- frozen origin commit: `95190168302e54cfef9059f9292efd7a723c84fd`
- frozen tree: `81639342ae37a95745d5ccef09bd43d1b44d801d`
- frame: C-sorted Git-tracked `.agda`, `.lean`, and `.md` paths below
  `formal/`, `notes/`, and `papers/`, excluding build products, Python, and
  all twenty prior literal samples
- tracked semantic base count: 1,116 paths
- final frame count: 1,096 paths; the exact delta confirms all twenty prior
  samples were present and excluded
- frame SHA-256:
  `f61885f3f5ad02f3a5a857f43b8ced6b26536ae7fc96c56bef12ee5b7c2149e8`
- unbiased uint32 protocol: rejection remainder 856, acceptance limit
  `4294966440`; accept a native uint32 below that limit and reduce modulo
  1,096
- sole native `/dev/urandom` uint32: `793955429`
- accepted without rejection or redraw
- zero-based index: 973; one-based position: 974
- sampled path: `notes/SEXTIC_OBSTRUCTION.md`
- sampled blob: `c954d8cda028ab066aa66be59ab29e5da5070e96`
- introducing and last-touch commit:
  `c211864c2d921e814e9a854205af5c944e68ca92`

## Checked algebra

For the monic constant-one sextic

```text
g(x) = x^6 + a x^5 + b x^4 + c x^3 + d x^2 + e x + 1,
```

the safe Agda leaf checks its exact even/odd split, reflection, and norm:

```text
E(y) = y^3 + b y^2 + d y + 1
O(y) = a y^2 + c y + e
g(x)g(-x) = E(x^2)^2 - x^2 O(x^2)^2.
```

An explicit Laplace definition of the coefficient-ordered 5-by-5 Sylvester
determinant is proved equal, over every commutative ring, to all thirteen
terms of the sampled polynomial `D`, with the printed coefficients and signs.

The supplied factorized quadratic

```text
O(y) = a(y-y₁)(y-y₂)
```

is itself checked under coefficients `c=-a(y₁+y₂)` and `e=a y₁y₂`. Under
exactly that presentation Agda proves

```text
a^3 E(y₁)E(y₂) = D(a,b,-a(y₁+y₂),d,a y₁y₂).
```

There is no root extraction, inverse for `a`, field assumption, or division.
The degenerate control `(a,b,c,d,e)=(0,0,1,0,0)` makes both the determinant
and `D` equal `-1`, exposing a coefficient/sign transcription failure.

## Exact refusal

This leaf does not certify the sampled note's root annulus, real-root count,
coefficient box, irreducibility enumeration, Routh/Sturm calculations,
resultant-tail bounds, cyclotomic closure, exact candidate counts/margins, or
the final absence of irreducible sextic factors. The retired Python
certificate was read only as provenance and was not executed. No numerical
assertion is promoted to kernel evidence.

`ParityNormEliminant.agda` already supplies the general reflection norm and
quartic/quintic determinant formulas. It has no sextic coefficient shape,
explicit 5-by-5 determinant, thirteen-term sextic expansion, or the displayed
root presentation. This leaf is precisely that missing local adapter, not a
new theory of resultants and not a NaturalMachine or physical theorem.

## Verification and review

- cold command:
  `cd formal/cubical && agda --ignore-interfaces -i . SexticParityEliminant.agda`
- toolchain: Agda 2.8.0 with the repository's safe Cubical options
- result: exit 0
- Shannon independently cold-checked an isolated tree and audited the E/O
  exponents, `g(-x)` orientation, all Laplace signs, every term of `D`, the
  even-degree resultant orientation, factorized-root hypotheses, degenerate
  sign control, prior-art delta, and every scope fence: PASS, no blocker.
- Root independently read the stable bytes and agreed with the PASS.

The latest repaired R0072/R0073 packets and messages 0633--0639 were consumed
before the forecast. Their native-witness, greedy-formation,
terminal-factorization, and p-adic results are not premises here. No
aggregate, sampled source, or foreign work path is edited.
