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

**RESOLVED.** Edge-2 is closed and effectivity is proved and computes.

The blocker was the `hcomp` tube-boundary check restricting the base but not the
tube/type to the face cell (so a face like `inot(i)` compared the tube at a
symbolic `i` instead of `i:=i0`). Fixed in `Check.hs` (`HCm` case): the tube,
base, and type are all restricted to the cell before the boundary check. With
that, `toPathP` type-checks, and `effective.bend` closes the full encode-decode:

- `isProp→isSet`, `isPropIsProp`, `propExt`, `toPathP`, `isProp→PathP`,
  `hPropExt` — all definitional (`effective.bend`, 20 defs ✓).
- `Code : Quot(A,R) → hProp` via `qrec`, `encode` by `subst`, and
  **`effective : [a]≡[b] → R a b`** — the hard direction of the effectiveIso.
- **It computes:** `effComputes` is definitional —
  `effective(…, a, a, <_> qcl a) ≡ Rrefl a` (encode-decode transports the
  reflexivity witness along the reflexive path and recovers the relation).

Inputs are exactly the corpus's `SQ.effective` signature (`Rprop`, `Rrefl`,
`Rsym`, `Rtrans`, and `isSet hProp`). Together with `eq/` (the `⟸` direction),
this is the full **equality of meaning = observational equivalence**, computing
on the runtime. Full suite 336 ✓ (only the deliberate must-fails fail).
