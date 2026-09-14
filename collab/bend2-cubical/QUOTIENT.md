# SetQuotient — the HIT the minimal machine needs, now in Bend2

The corpus's central self-application (`MyhillNerodeMinimalMachine`: `Meaning =
X / observational-≈`) is a `SetQuotient` HIT. This adds it to Bend2 on top of
the comp/Glue Kan machinery, so the minimal-machine construction can be ported
and its recursor computes on the runtime.

## Added (in `cubical-paths.patch`)

Five primitives (`src/Core/Type.hs`), with the full traversal/parse/check/whnf
integration mirroring Glue:

- `Quot(A, R) : Set` — the quotient type former (`A : Set`, `R : A → A → Set`).
- `qcl(a) : Quot A R` — the point constructor `[a]`.
- `qeq(a, b, w) : Path (Quot A R) [a] [b]` — the generator path `eq/`, with
  `w : R a b`.
- `qsquash : isSet (Quot A R)` — the set-truncation `squash/`.
- `qrec(q, setB, f, resp) : B` — the recursor `SQ.rec`: `f : A → B`,
  `resp : ∀ a b (w : R a b). f a ≡ f b`, `setB : isSet B`.

## Reductions (`whnfPAp`, `whnfQRec`) — computes and is verified

- `qeq(a,b,w) @ i0 ≡ qcl(a)`, `@ i1 ≡ qcl(b)` — the generator's endpoints.
- `qrec(qcl(a), setB, f, resp) ≡ f a` — the point computation rule.
- `qrec(qeq(a,b,w) @ i, …) ≡ resp a b w @ i` — cong along the generator.
- Commutes through `Sup` (DUP-SUP) for the net.

`quotient.bend` (all ✓, GHC 9.12.2): `Quot`/`qcl`/`qeq`/`qsquash` type-check,
`qcl` endpoints in a `Path` (`loopT`), `qeq` as a genuine path (`eqPath`),
`isSet(Quot)` by `qsquash` (`isSetQ`), and the recursor computes —
`recComputes : Path(Nat, qrec(qcl(True),…), 1n)` is **definitional**, and `main`
runs to `1n`. Full pre-existing suite unchanged (269 ✓; only the deliberate
`hfill`/`uaroundtrip` must-fails fail).

## Soundness

`quotient_mustfail.bend`: a `resp` that does not respect `R` (a constant path
`f a ≡ f a` where `f a ≡ f b` is required) is **rejected** — the recursor
enforces that `resp` connects `f a` to `f b`, so `eq/` cannot be used with a
bad `resp` to collapse the target. `qsquash` is accepted only against an
`isSet`-shaped goal whose carrier is a quotient, never an arbitrary type.

## Next (Phase 2+): the minimal machine itself

`SQ.rec` / `SQ.elimProp` / `SQ.effective` (the encode–decode `[x]≡[y] ⟹ x≈y`)
are now expressible in Bend2 source from these primitives plus propositional
univalence (`ua`). Porting `MyhillNerodeMinimalMachine` then makes behavioral
equivalence = path equality compute on the net. Emitter support for the erased
HVM targets is the remaining runtime step.

## Phase 2 status: minimal machine computes; effectivity is library-porting

- `minmachine.bend`: the minimal Moore machine `Meaning = S / Nerode` computes —
  `quotObserve(qcl 0n) ⇒ True`, `(qcl 1n) ⇒ False` (definitional), `sameMeaning`
  collapses Nerode-equivalent states via `eq/`, `behavior` runs. Faithful to the
  corpus's `FutureQuotient` (parameterized by `setO : isSet O`).
- `hprop.bend`: the prop-level foundations for the hard direction
  (`[a]≡[b] ⟹ R a b`) — `isProp→isSet`, `isPropIsProp`, propositional univalence
  `propExt` (from `ua`), and `hProp` with its projections — all definitional.

The encode-decode `effective` proof is now expressible from these plus a code
family `Code : Meaning → hProp` (via `qrec`) and `subst`. It is **not yet
closed** because `toPathP` / `isProp→PathP` (needed to build the `hProp` path's
second component) hit the checker's varying-type `hcomp` endpoint reduction —
the documented **edge-2** frontier (symbolic-endpoint `transp`/`comp`), the same
open item as in GLUE.md, not a gap in the quotient primitive. Pinned precisely:
`coe` over a constant line reduces (`coeprobe.bend` p1/p2 ✓), but the
`hcomp`-endpoint-under-true-face reduction with a substituted interval does not
close definitionally. Closing edge-2 in the checker closes effectivity.
