# Status — what was asked, what is delivered, where (all verified by running the patched binary)

Build: `cubical-paths.patch` on DKormann/Bend2 @ f026483; GHC 9.12.2, cabal 3.18,
`LC_ALL=C.utf8` (without it the binary aborts on any UTF-8 source and prints
nothing). `bend f.bend` checks and runs; `bend check` is not a subcommand.

| Ask | Delivered | Evidence |
|---|---|---|
| Native execution of cubical transport on the runtime (path as runtime data) | universe path = Church pair `(fwd,bwd)`; `coe` = direction projection; `--to-hvm4-raw` emits without pre-normalisation; HVM3 never pre-normalises | `applypath.bend` on HVM4: `@applyPath(*)(*)(@negPath)(1) ⇒ 0`; `t_fwd_neg/t_bwd_neg/t_fwd_id/t_bwd_id` raw 0/0/1/1, HVM3 same (VERIFICATION.md) |
| Pth transport through non-constant families | `whnfCoe` Pth case builds the `HCm` square | `pth2.bend` 2✓ |
| Sound totality classifier | descending-column analysis; `loop` is `[unchecked]`; **`--total` gate** refuses such files (exit 1) | `loop.bend`, `bend loop.bend --total` |
| Narrow "univalence complete" | raw-Iso level: only the path-side round trip; Iso-side fails as it must | `uaroundtrip.bend` 4✓ 1✗ (deliberate); README/WRITEUP/CORRECTIONS corrected |
| General hcomp (cofibration systems) | one constructor `HCm A [(φ,u)] base`, faces arbitrary interval formulas (DNF), per-cell boundary + adjacency checks; false faces dropped | `hcompfaces.bend` 5✓, `isprop.bend` 3✓ (GENERAL_HCOMP.md) |
| hfill | parser sugar `hfill(A,[(φ,u)…],base) : Path(base, hcompN(…))` | `hfill.bend` 4✓, must-fail `wrong` ✗ |
| Coherent reverse univalence round trip | `Equiv = Σ f. ∀y. isContr(fiber f y)`; `uaE`; `pathToEquiv`; `uaEquivRoundTrip : pathToEquiv(uaE e) = e` | `uaequiv.bend` 17✓; `uaequiv_mustfail.bend` wrong1/wrong2 ✗; `roundtrip.bend` 21✓ (parallel agent) |
| The object itself: `A ≃ Σ B (fiber f)` | `isoToIsEquiv` (library `lemIso`, transcribed), `totalEquiv` for every `f`, `losslessPath = uaE(totalEquiv)`, `present/retrieve` by `coe`, laws by refl | `fibrelaw.bend` 35✓ (FIBRE_LAW.md) |
| …running on the net | `presentNeg`/`retrieveNeg` and the contraction `contrNeg0/1` on the raw HVM4 net and HVM3 | 0/1/1/0 and 0/0, itrs in FIBRE_LAW.md |
| **Transport across chains of equivalences performed by the net** (composite / inverse / Π / Σ lines as runtime paths; raw mode strict) | closed runtime path algebra `pathRep/lineRep/coeRep`; `whnfCoe` gains the same inverse/composite rules | `chain.bend` 19✓; 12 transports × 3 evaluators agree; itrs 12/19/31 for 1/2/3 equivalences (RUNTIME_ALGEBRA.md) |
| **Everything cubical at runtime** (README: the trace IS the path; partial knowledge) | `--to-hvm4-full`: intervals, paths, types, `coe`, `hcomp` are runtime objects; stuck `#HCm` on symbolic faces; DUP-SUP routing native | RUNTIME_FULL.md: chain/fibre/t_*/supline/isprop_run all correct on the full runtime |
| Tighten writeup (Analysis counts syntax) | stated as syntax counts; overclaims removed | WRITEUP.md, CORRECTIONS.md |
| Push/pull main every few minutes; merge parallel agents' work | merged `HCmN`→unified constructor, REF_ENDPOINTS (same hunk), `roundtrip.bend` | git log |

Checker mechanisms that had to exist for the above (all in the patch):
typed endpoint law for var- **and Ref-**headed path spines (`spineTy`),
`epNormCtx` traversing `SigM` and unfolding saturated non-path Ref
applications (`unfoldable`), `(<i> t) @ r` beta in `infer`, false faces
dropped in `whnfHCm`, emitters resolving literal endpoints before erasure.

Erased targets (`--to-hvm4`, `--to-hvm4-raw`, `--to-hvm`) are kept as cost
comparison points; the full runtime is `--to-hvm4-full`. Remaining caveats are
listed in RUNTIME_FULL.md (hcomp in Set beyond the composite shape stays stuck;
no Glue).

Suite on the final binary: 28 `.bend` files, 0 ✗ except the three deliberate
must-fails; stock `examples/` 2/2.
