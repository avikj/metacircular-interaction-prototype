# Typed path-endpoints for Ref-headed spines â” the enabler for isPropIsEquiv

## What was missing

`isEquiv A B f` is a proposition, so the reverse univalence round trip
`pathToEquiv (ua e) = e` reduces to (i) the underlying functions agreeing
(uaÎ², already *definitional* here) and (ii) a prop-filler on the isEquiv
component: `isPropIsEquiv`.

`isPropIsEquiv` is one line:

    <i> lambda y. isPropIsContr(fiber(A,B,f,y), u0(y), u1(y)) @ i

To accept it, the checker must verify the path's endpoints:
`isPropIsContr(_, u0 y, u1 y) @ i0  â‰¡  u0 y`. This is a *typed* path-endpoint
law: `isPropIsContr(_, c0, c1)` has type `Path(_, c0, c1)`, so applying `@ i0`
yields its left endpoint `c0 = u0 y`.

Bend already read endpoints this way for **context variables** of Path type
(`spineEndpoints`/`spineType` in `Core/Check.hs`). It did *not* do so for a
**global definition** (a `Ref`) of Path type â” so `isPropIsContr(...) @ i0`
stayed neutral and the endpoint check failed. This is the same wall that
Î-Î would clear, but the Ref-endpoint law is the more principled fix: it is
just the definitional boundary equation of the Path type, extended from
context vars to named lemmas.

## The change (in cubical-paths.patch)

`spineType` in `Core/Check.hs` gains a `Ref` base case that reads the
definition's declared type from the book:

    Ref nm -> case deref book nm of
      Just (_, _, ty) -> Just ty
      _               -> Nothing

The existing `App`/`PAp` cases then peel the Î /Path spine as before, so
`isPropIsContr(A, c0, c1) @ i0` endpoint-normalizes to `c0`.

## Result

With this one hunk:

- `isPropIsEquiv`  â” green, **definitional**  (equiv.bend)
- `pathToEquiv`    â” typechecks               (equiv.bend)
- `uaÎ²`            â” already definitional      (transport along `ua` = f)
- `isPropIsContr`  â” green via general hcomp   (unchanged)

No regression: cubical suites, stock examples, and `isPropIsContr` unchanged.
The remaining reverse-round-trip assembly (`equivEq` / `isPropâ’PathP`) is
ordinary cubical-library translation on top of these.
