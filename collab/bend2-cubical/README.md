# Cubical path types for Bend2

`cubical-paths.patch` applies to DKormann/Bend2 (fork of HigherOrderCO-archive/Bend2-old,
snapshot 2025-07-07) and adds a CCHM-style path layer to the Bend2 core:

    Interval, i0, i1, inot(r), iand(r,s), ior(r,s)
    Path(A, a, b)      -- path type
    <i> t              -- path lambda
    p @ r              -- path application

Semantics implemented:
  - beta: (<i> t) @ r reduces to t[i := r]; connection algebra on i0/i1
  - boundary: checking <i> t against Path(A,a,b) requires t[i0] = a, t[i1] = b
    definitionally, with endpoint reduction of neutral var-headed path spines
    read from the context (h(x) @ i0 reduces to the codomain endpoint)
  - conversion: path-lambda eta, lambda eta

Checked green by the patched binary (build: GHC 9.12.2, cabal 3.18, LC_ALL=C.utf8):
  - cubical_test.bend: prefl, psym (via inot), pcong, funext (unprovable with
    Bend2's native Eql), connection square, and the corpus lossless-presentation
    rightInv transliterated term-for-term from cubical Agda:
      Agda:  Iso.rightInv losslessIso (b , a , p) i = p i , a , λ j → p (i ∧ j)
      Bend2: <i> (e @ i, a, <j> e @ iand(i, j))
  - corpus_lossless.bend: the Eql-based version (encode/decode/section/retract)
  - no regressions: examples/main.bend 39/39

Layer 2 (same patch): PathP (paths are lines P : Interval -> Set throughout;
Path(A,a,b) is the constant-line sugar), coe(P,r,s,t) -- generalized transport
with per-type-former dispatch (Pi, Sigma, List, rigid inductives, Set) and
regularity (constant lines transport as the identity, decided on the deep
normal form of the line applied to a fresh marker), and ua(A,B,f,g) : Path(Set,A,B)
with transport along ua computing to f (and to g backwards). J is DEFINED by
coe along the connection square

    J(...) = coe(lambda i. C(p @ i, <j> p @ iand(i, j)), i0, i1, d)

and computes definitionally on refl (J_refl is <i> d). Checked green in
cubical_test2.bend: transport, subst, J, J_refl, pathp_const, ua_beta,
ua_beta_inv, transport_pi, transport_sig. No regressions (39/39 stock).

Layer 4 (same patch):
  - hcomp(A, r, u0, u1, base): homogeneous composition with the binary face
    system (r=i0 -> u0, r=i1 -> u1); faces reduce definitionally, giving
    definitional path composition pcompH (cubical_test4.bend). refl.refl=refl
    stays propositional, matching cubical Agda.
  - ua upgraded to full iso-univalence: ua(A,B,f,g,gf,fg) carries both
    homotopies (this is isoToPath, which is what the corpus's Carrier uses);
    transport still computes to f forwards and g backwards.
  - Sup x Path: coe along a superposed line &L{A(i),B(i)} dups the value at
    label L and transports each universe along its own line -- the corpus's
    fibre-exactness theorem as a reduction rule. Checked: transport along
    &0{ua(not), Bool} sends &0{True,True} to &0{False,True} definitionally.
    Typing: a superposed value checks componentwise against a superposed
    type at the same label.
  - Totality classifier (Core/Totality.hs): every definition is tagged
    [total] (no recursion, or structural descent), [productive]
    (constructor-guarded corecursion), or [unchecked]. An analysis, not a
    gate -- it makes the trust boundary per-definition visible.

Layer 5 (same patch): UNIVALENCE COMPLETE at the iso level. The three laws:
  uaBeta     transport along ua e computes to e -- definitional, both ways
  uaIdEquiv  ua(idIso) = refl -- definitional (identity-ua collapses to the
             constant path in conversion, decided semantically; this is the
             equation Glue exists to justify, valid in the model)
  uaEta      ua(pathToIso p) = p for every p -- proved by J, with pathToIso
             defined by transporting idIso through the Iso family (coe
             regularity reduces through Sigma/Pi/Path components at refl)
See cubical_test5.bend. At the raw Iso level only the path-side round trip
(uaEta) holds; the Iso-side one fails (uaroundtrip.bend), as it must.

Coherent level (uaequiv.bend, 17 checks green): Equiv(A,B) = Σ f. ∀y.
isContr(fiber f y); uaE builds the path from the contractible-fibre data;
pathToEquiv transports idEquiv; uaEquivRoundTrip : pathToEquiv(uaE e) = e
CHECKS for arbitrary e, via isPropIsEquiv (pointwise isPropIsContr, a 4-face
hcompN — see GENERAL_HCOMP.md). hcomp with general cofibration systems is
present (hcompN). fibrelaw.bend (32 green): isoToIsEquiv (lemIso), the fibre
law A ≃ Σ B (fiber f) as a coherent Equiv for every f, its uaE path, and
transport along it run natively on HVM4/HVM3 — FIBRE_LAW.md. --to-hvm4-full
keeps every cubical object at runtime (RUNTIME_FULL.md). hfill is
parser sugar over hcompN (hfill.bend); `bend f.bend --total` refuses a file
with any [unchecked] definition. Not done, not asked: Glue as a first-class
type former (ua is primitive; all its consequences are present).


## Analysis layer (Core/Analysis.hs, same patch)

Every checked definition now prints a mathematical report, not pass/fail:

    totality        [total] / [productive] / [unchecked]
    shape           theorem(=) / theorem(path) / family / program
    proof cost      "definitional" when the kernel pays only computation,
                    else measured rewrite steps and transport cells (coe/
                    hcomp/ua occurrences) -- the cost-lives-in-the-non-
                    contractible-fibre theorem as a per-proof number
    unused args     hypotheses the body never consumes (the erasure signal)
    sup labels      superposition labels touched
    Set-binders     impredicativity load of the type

## The closed loop

run_corpus.bend: mul2/div2 with the proof div2(mul2(n)) == n.
  - checks: proof costs "rewrites: 1, cells: 0"
  - runs in-process: div2(mul2(21n)) = 21
  - extracts (--to-hvm): the PROOF compiles to erasers (*) -- theorems
    ride with programs at zero runtime cost
run_corpus.hvm4: the same program in HVM4 surface syntax, executed on the
  real HVM4 C runtime: div2(mul2(3)) = 3n in 26 interactions.
  (--to-hvm targets the HVM3 dialect; an HVM4 emitter is a mechanical
  printer variant, not yet written.)
