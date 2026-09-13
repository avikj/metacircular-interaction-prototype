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

Still open: general hcomp with boundary systems (needed for HITs and
composition of paths with free endpoints), full Glue (ua here is the
bi-invertible-map special case, computation without the coherence path),
guarded coinduction, and the Sup x Path interaction (transport along a path
of superpositions -- no prior art; the repo's fibre theorems are the
specification).
