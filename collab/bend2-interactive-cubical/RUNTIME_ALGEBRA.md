# Runtime vs compile time â” what the net does, and the closed path algebra

## The distinction, precisely

Intervals are erased at runtime. So a *value*-level path (a proof) has no
runtime content, and its endpoints `p @ i0 / p @ i1` are resolved by the
compiler (`force`) â” for closed terms this is the same answer canonicity
gives, and it costs nothing you care about (proofs ride at zero cost).

A *universe* path (`Path(Set, A, B)`) is different: it is runtime data â” a
Church pair `(fwd, bwd)` â” and `coe` along it is an application performed by
the net. Before this change the net knew exactly ONE such path: a bare `ua`.
Every composite (`hcomp` in `Set`), inverse (`P @ inot(i)`), and transport
through `Î `/`Î` of a `ua`-line was pre-computed by the Haskell normaliser, and
`--to-hvm4-raw` silently emitted the cap / identity for them. For a model of
computing whose only action is transport across equivalences, that is the
whole power missing: the net crossed one equivalence, never a chain.

## The algebra (Core.WHNF: `pathRep`, `lineRep`, `coeRep`)

The runtime representation is now **closed** under the constructions the
checker admits on lines in `Set`:

| line in `Set` | runtime path |
|---|---|
| `ua(A,B,f,g,â¦)` | `Î»k. k(f)(g)` |
| `<i> P @ i` | `P` |
| `<i> P @ inot(i)` | `inv P` = `Î»k. k(bwd P)(fwd P)` |
| `<i> hcomp(Set, i, <_> A, <k> Q @ k, P @ i)` | `comp P Q` = `Î»k. k(fwd Q âˆ˜ fwd P)(bwd P âˆ˜ bwd Q)` |
| `<i> (P@i) -> (Q@i)` (non-dependent) | `pi P Q` = `Î»k. k(Î»h. fwd Q âˆ˜ h âˆ˜ bwd P)(Î»h. bwd Q âˆ˜ h âˆ˜ fwd P)` |
| `<i> Î (P@i) (Q@i)` (non-dependent) | `sig P Q` = componentwise |
| constant line | `idPath` |

`coe(Î»i. L, i0, i1, x)` emits `fwd(rep L)(x)`; `i1â’i0` emits `bwd`. The same
rules were added to the checker's `whnfCoe` (inverse and composite lines), so
the definitional laws and the runtime agree by construction.

**Raw mode is strict**: a line outside this algebra (a `Pth` family, a
dependent `Î `/`Î`, a superposed line) is refused with an error naming the
line â” it is never erased to a cap or identity again. Normalised mode
(`--to-hvm4`) still pre-computes those, as before.

## Evidence (`chain.bend`, 19 â“)

`negNeg = <i> hcomp(Set, i, <_> Bool, <k> negPath @ k, negPath @ i)`,
`neg3 = comp negNeg negPath`, plus inverse, `Î ` and `Î` lines. Twelve closed
transports, three evaluators, identical values; interactions on the raw net
grow with the number of equivalences crossed:

| transport | normaliser | HVM4-raw (itrs) | HVM3 |
|---|---|---|---|
| `viaNegNeg True/False` | True/False | 1/0 (19/19) | 1/0 |
| `viaNeg3 True/False` | False/True | 0/1 (31/30) | 0/1 |
| `viaNeg3Bwd True/False` | False/True | 0/1 (31/30) | 0/1 |
| `viaInv True/False` | False/True | 0/1 (13/12) | 0/1 |
| `viaPi True/False` | False/True | 0/1 (20/19) | 0/1 |
| `viaSig True/False` | False/True | 0/1 (20/19) | 0/1 |

(single `ua`: 10â“11 itrs; two: 19; three: 30â“31.)

Emitted, e.g.:

    @negNeg = Î»&k. k(Î»&x. @cub_pathFwd(@negPath)(@cub_pathFwd(@negPath)(x)))
                   (Î»&y. @cub_pathBwd(@negPath)(@cub_pathBwd(@negPath)(y)))

## What is still compile-time (stated, not hidden)

- Face selection of a value-level `hcomp` (proof content; zero cost by design).
- Transport along a `Path` family, a dependent `Î `/`Î` line, or a superposed
  (`&L{â¦}`) line: normaliser only; raw mode refuses. The superposed case is
  the DUP-SUP routing rule â” making it a runtime path (`Î»x. dup x; &L{fwd A
  x0, fwd B x1}`) is the natural next entry in the table.
