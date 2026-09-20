# SetQuotient â” the HIT the minimal machine needs, now in Bend2

The corpus's central self-application (`MyhillNerodeMinimalMachine`: `Meaning =
X / observational-â‰ˆ`) is a `SetQuotient` HIT. This adds it to Bend2 on top of
the comp/Glue Kan machinery, so the minimal-machine construction can be ported
and its recursor computes on the runtime.

## Added (in `cubical-paths.patch`)

Five primitives (`src/Core/Type.hs`), with the full traversal/parse/check/whnf
integration mirroring Glue:

- `Quot(A, R) : Set` â” the quotient type former (`A : Set`, `R : A â’ A â’ Set`).
- `qcl(a) : Quot A R` â” the point constructor `[a]`.
- `qeq(a, b, w) : Path (Quot A R) [a] [b]` â” the generator path `eq/`, with
  `w : R a b`.
- `qsquash : isSet (Quot A R)` â” the set-truncation `squash/`.
- `qrec(q, setB, f, resp) : B` â” the recursor `SQ.rec`: `f : A â’ B`,
  `resp : âˆ a b (w : R a b). f a â‰¡ f b`, `setB : isSet B`.

## Reductions (`whnfPAp`, `whnfQRec`) â” computes and is verified

- `qeq(a,b,w) @ i0 â‰¡ qcl(a)`, `@ i1 â‰¡ qcl(b)` â” the generator's endpoints.
- `qrec(qcl(a), setB, f, resp) â‰¡ f a` â” the point computation rule.
- `qrec(qeq(a,b,w) @ i, â¦) â‰¡ resp a b w @ i` â” cong along the generator.
- Commutes through `Sup` (DUP-SUP) for the net.

`quotient.bend` (all â“, GHC 9.12.2): `Quot`/`qcl`/`qeq`/`qsquash` type-check,
`qcl` endpoints in a `Path` (`loopT`), `qeq` as a genuine path (`eqPath`),
`isSet(Quot)` by `qsquash` (`isSetQ`), and the recursor computes â”
`recComputes : Path(Nat, qrec(qcl(True),â¦), 1n)` is **definitional**, and `main`
runs to `1n`. Full pre-existing suite unchanged (269 â“; only the deliberate
`hfill`/`uaroundtrip` must-fails fail).

## Soundness

`quotient_mustfail.bend`: a `resp` that does not respect `R` (a constant path
`f a â‰¡ f a` where `f a â‰¡ f b` is required) is **rejected** â” the recursor
enforces that `resp` connects `f a` to `f b`, so `eq/` cannot be used with a
bad `resp` to collapse the target. `qsquash` is accepted only against an
`isSet`-shaped goal whose carrier is a quotient, never an arbitrary type.

## Next (Phase 2+): the minimal machine itself

`SQ.rec` / `SQ.elimProp` / `SQ.effective` (the encodeâ“decode `[x]â‰¡[y] âŸ xâ‰ˆy`)
are now expressible in Bend2 source from these primitives plus propositional
univalence (`ua`). Porting `MyhillNerodeMinimalMachine` then makes behavioral
equivalence = path equality compute on the net.

## The recursor runs on the FULL runtime (`--to-hvm4-full`)

The quotient constructors are now emitted to the full cubical runtime (not just
the checker): `Quo`/`QCl`/`QEq`/`QSq`/`QRec` lower to `#Quo`/`#QCl`/`#QEq`/`#QSq`/
`@qrec`, with `@qrec` mirroring the checker's rules exactly â” `qrec([a]) â’ f a`,
`qrec(eq/ a b w @ i) â’ resp a b w @ i` (via `@pathAt` giving `eq/ @ i0 = [a]`,
`@ i1 = [b]`), and commuting over `Sup` natively (DUP-SUP). Verified on HVM4:
`qrec(qcl 3n, dbl, â¦) â’ 6`, `qrec(qeq(2n,2n,refl) @ i0, dbl, â¦) â’ 4`;
`quotient.bend` main `â’ 1n`, `minmachine.bend` runs, `nerode_effective_closed`
emits and runs. The whole suite emits to `--to-hvm4-full` with no crashes; the
checker stays at 856 â“ (only the deliberate must-fails fail).

## Phase 2 status: minimal machine computes; effectivity is library-porting

- `minmachine.bend`: the minimal Moore machine `Meaning = S / Nerode` computes â”
  `quotObserve(qcl 0n) â’ True`, `(qcl 1n) â’ False` (definitional), `sameMeaning`
  collapses Nerode-equivalent states via `eq/`, `behavior` runs. Faithful to the
  corpus's `FutureQuotient` (parameterized by `setO : isSet O`).
- `hprop.bend`: the prop-level foundations for the hard direction
  (`[a]â‰¡[b] âŸ R a b`) â” `isPropâ’isSet`, `isPropIsProp`, propositional univalence
  `propExt` (from `ua`), and `hProp` with its projections â” all definitional.

**RESOLVED.** Edge-2 is closed and effectivity is proved and computes.

The blocker was the `hcomp` tube-boundary check restricting the base but not the
tube/type to the face cell (so a face like `inot(i)` compared the tube at a
symbolic `i` instead of `i:=i0`). Fixed in `Check.hs` (`HCm` case): the tube,
base, and type are all restricted to the cell before the boundary check. With
that, `toPathP` type-checks, and `effective.bend` closes the full encode-decode:

- `isPropâ’isSet`, `isPropIsProp`, `propExt`, `toPathP`, `isPropâ’PathP`,
  `hPropExt` â” all definitional (`effective.bend`, 20 defs â“).
- `Code : Quot(A,R) â’ hProp` via `qrec`, `encode` by `subst`, and
  **`effective : [a]â‰¡[b] â’ R a b`** â” the hard direction of the effectiveIso.
- **It computes:** `effComputes` is definitional â”
  `effective(â¦, a, a, <_> qcl a) â‰¡ Rrefl a` (encode-decode transports the
  reflexivity witness along the reflexive path and recovers the relation).

Inputs are exactly the corpus's `SQ.effective` signature (`Rprop`, `Rrefl`,
`Rsym`, `Rtrans`, and `isSet hProp`). Together with `eq/` (the `âŸ` direction),
this is the full **equality of meaning = observational equivalence**, computing
on the runtime. Full suite 336 â“ (only the deliberate must-fails fail).

## Instantiated at the machine (`nerode_effective.bend`, 33 â“)

The generic `effective` above still carries an abstract relation `R`. Wiring it
to the concrete Nerode congruence closes the converse for the minimal machine
itself: `Nerode` is shown a prop-valued equivalence relation on the net
(`reflN`/`symN`/`transN` by path-refl/reversal/`hcomp`; `isPropNerode` from
`setO : isSet Bool`), and

- **`nerodeEffective : Path(Meaning, [x], [y]) â’ Nerode(x, y)`** â” the `âŸ`
  direction for the machine, `effective` instantiated at `(S, Nerode, â¦)`.
- `nerodeEffComputes` is definitional: on the reflexive path it returns `reflN x`.

With `sameMeaning` (the `âŸ`, `eq/`) this is **behavioral equivalence = path
equality for the Myhillâ“Nerode minimal machine, both directions, on the
runtime**.

## `isSet hProp` proved from scratch â” the last hypothesis discharged (`hset.bend`, 25 â“)

The generic `effective` takes `sh : isSet hProp`. This is now **proved**, not
assumed:

- `isPropIso5` â” an iso between two propositions is itself a proposition
  (`f`/`g` by funext into a prop; the `section`/`retraction` PathPs by
  `isPropâ’PathP` over a prop-family, from `isPropâ’isSet`).
- `isPropPathSet` â” for propositions `A`, `B`, the type `Path(Set, A, B)` is a
  proposition: it is a retract of `Iso5 A B` via **`uaEta`** (`ua(pathToIso p) â‰¡
  p`, the univalence round trip, `cubical_test5.bend`), and a retract of a prop
  is a prop.
- `isPropSigPath` â” for a proposition-fibred Î, the path space retracts onto the
  base path space; **`isSetHProp = isPropSigPath`** at `Î A:Set. isProp A`, with
  the base-path prop supplied by `isPropPathSet`.

`nerode_effective_closed.bend` (46 â“) then feeds `isSetHProp()` into `effective`,
so **`nerodeEffective` carries no `sh` at all** â” only `setO : isSet Bool`
remains, which is a genuine parameter of the construction (the corpus's
`FutureQuotient` likewise takes `isSet O` for an arbitrary output alphabet, never
discharging it). The one earlier-named "open" edge is closed.
