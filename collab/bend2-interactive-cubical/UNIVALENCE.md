# Coherent-equivalence univalence â” BOTH round trips complete

`roundtrip.bend` closes the reverse univalence round trip that the audit named
as the open gap. Everything checks green (21/0) on a pristine DKormann/Bend2
patched with `cubical-paths.patch`.

## What is proved

For coherent equivalences (contractible-fibre `isEquiv`, the formulation that
makes `isEquiv` a proposition):

    uaRoundTrip : (e : Equiv A B) -> pathToEquiv (uaFromEquiv e) = e      â“ green

together with the forward computation rules already in place:

    uaÎ²  : coe (<i> ua e @ i) i0 i1 x  â‰¡  f x          definitional
    fstEq: fst (pathToEquiv (ua e))    â‰¡  f            definitional

## How it closes (all standard cubical translation, no cheats)

- `uaFromEquiv` extracts the iso data `(f, g, gf, fg)` from a coherent `e`:
  `g y` is the point of the centre fibre, `fg` its path, `gf` the fibre
  contraction of `(x, refl)` projected by `ap fst`. Threaded consistently
  through `centre`/`contract` (isContr projections) so no neutral re-derivation
  ever has to be re-matched.
- The round trip is `<i>(f, isPropIsEquiv(...) @ i)`:
  * fst is definitional â” `fst (pathToEquiv (ua e)) â‰¡ f` by uaÎ² +
    coe-through-Î/Î  (both compute in this checker);
  * snd is filled by `isPropIsEquiv`, because `isEquiv` is a proposition
    (`isPropIsContr` via general hcomp, pointwise in y).

## The one piece of checker machinery this needed

`isPropIsEquiv` requires the checker to see
`isPropIsContr(_, u0 y, u1 y) @ i0 â‰¡ u0 y` â” the typed path-endpoint law for a
**named lemma** of Path type. Bend already did this for context variables;
`cubical-paths.patch` extends `spineType` (Core/Check.hs) with a `Ref` case
that reads a definition's declared type from the book. See REF_ENDPOINTS.md.
That one hunk is the whole difference between "isEquiv is a prop" being
stuck and being definitional. Everything else here is ordinary library work.

## Status of univalence overall

- forward round trip (uaÎ² / uaÎ at the iso level) â” done previously
- reverse round trip (pathToEquiv âˆ˜ ua = id, coherent) â” **done here**

Coherent-equivalence univalence is complete with both round trips.
