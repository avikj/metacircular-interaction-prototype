# The fibre law as a coherent equivalence, transported natively — `fibrelaw.bend`

The object is `A ≃ Σ B (fiber f)` (`Cubical.Functions.Fibration.totalEquiv`,
HoTT 4.8.2): an interaction step `f : A → B` factored losslessly into its
visible projection and its fibre. Until now the Bend2 side carried it only at
the `Eql`/Σ level (`corpus_lossless.bend`) and `ua` only over raw `Iso`.
`fibrelaw.bend` (32 ✓, 0 ✗) carries it at the strongest level the prototype
has:

1. **`isoToIsEquiv`** — `Cubical.Foundations.Isomorphism.lemIso` transcribed
   line for line (`fill0/fill2/sq/sq1/lemIso`). `hfill` is inlined as
   `hcompN` with the extra `(inot j)` face; every 4-face system typechecks
   with boundary and adjacency conditions. So an isomorphism has contractible
   fibres — the coherent `Equiv`, not the raw record.
2. **`totalEquiv : Equiv(A, Σ b:B. fiber f b)`** for every `A, B, f`, from the
   iso `tot a = (f a, a, refl)`, `untot`, `tot_sec = <i>(q@i, a, <j> q@(i∧j))`,
   `tot_ret = refl`.
3. **`losslessPath : Path(Set, A, Total f) = uaE(totalEquiv f)`** — the
   coherent `uaE` from `uaequiv.bend`, so this path's reverse trip closes
   (`uaEquivRoundTrip`), unlike raw-Iso `ua`.
4. **`present a = coe(losslessPath, i0→i1, a)`** and
   **`retrieve = coe(…, i1→i0)`**; `present_is_tot` and `retrieve_present`
   are **refl** (uaβ on the coherent path + regularity).

## Runtime (path as data, no pre-normalisation)

`main` instantiated at `f = neg : Bool → Bool`, emitted with `--to-hvm4-raw`
(the net performs the `coe`/`ua`/pair reduction itself) and `--to-hvm`:

| term | HVM4-raw | HVM3 | expected |
|---|---|---|---|
| `presentNeg(True)`  (visible projection of the presentation) | `0` (False), 83 itrs | `0`, 102 | `neg True = False` |
| `presentNeg(False)` | `1`, 76 | `1`, 93 | `True` |
| `retrieveNeg(True)` (`retrieve ∘ present`) | `1`, 118 | `1`, 140 | `True` |
| `retrieveNeg(False)` | `0`, 118 | `0`, 140 | `False` |

## Checker changes needed (in `cubical-paths.patch`)

- `epNormCtx` unfolds a **saturated, non-path-typed** Ref-headed application
  (`unfoldable`) before endpoint normalisation: inside `lemIso` the faces of
  one `hcompN` call *other* lemmas (`fill0`, `fill2`) whose bodies contain
  `t(x0) @ i1`; conversion unfolds the Ref itself and would never apply the
  typed endpoint law. Path-typed lemma applications are **not** unfolded
  (their endpoint law is the point — `isPropIsContr(...) @ i0 ≡ h0`), nor
  are partial applications. `spineTy` is factored out for this.
- Side effect: `equiv.bend`'s former ✗ probe now checks too (10 ✓ 0 ✗).

Must-fail guard unchanged: `uaequiv_mustfail.bend` `wrong1`/`wrong2` still ✗.
