# Higher Inductive Types in Bend2-cubical

Adds the three higher inductive types the corpus needs — **SetQuotient**
`A / R`, **propositional truncation** `∥A∥`, and the **circle** `S¹` — to the
cubical Bend fork, closing the last capability gap where the corpus still
required Cubical Agda.

`cubical-fork-full.patch` is the complete cubical + HIT layer as a diff against
upstream Bend2 (`git apply` on a clean Bend2 checkout at the base commit),
i.e. it reproduces the whole fork, base cubical primitives plus HITs, in one
self-contained artifact. Build with
`cabal-3.18.1.0 build -w ghc-9.12.2 exe:bend`, then run the two acceptance
suites (`LC_ALL=C.utf8` required):

    bend setquotient_test.bend --total     # 8/8 [total]
    bend hit_test.bend         --total     # 12/12 [total]

Every computation rule below holds **definitionally** — the checker reports the
witnessing `refl` theorems as `definitional`.

## SetQuotient  `A / R`   (Core/Type.hs: Quot/QIn/QEq/QSq/QuotM)

Surface: `Quotient(A,R)`, `qin(a)`, `qeq(a,b,r)`, `qsquash(x,y,p,q)`,
`qelim(x, fp, fe)`.

    qin(a)            : A / R
    qeq(a,b,r)        : Path(A/R, [a], [b])          qeq(..) @ i0 = [a], @ i1 = [b]
    qelim(qin(a),…)         ≡ fp a                    (point β)
    qelim(qeq(a,b,r) @ i,…) ≡ (fe a b r) @ i          (path/cong β)

`fp : A -> B`, `fe : ∀a b. R a b -> Path B (fp a)(fp b)`, `B` a set. This is
the one the census / NerodeCongruence quotient uses.

## Propositional truncation  `∥A∥`   (Trunc/TIn/TSq/TruncM)

Surface: `Trunc(A)`, `tin(a)`, `tsquash(x,y)`, `telim(x, fp, fq)`.

    tin(a)            : ∥A∥
    tsquash(x,y)      : Path(∥A∥, x, y)              (any two elements equal)
    telim(tin(a),…)          ≡ fp a                   (point β)
    telim(tsquash(x,y) @ i,…) ≡ fq (rec x)(rec y) @ i (squash β)

`fp : A -> P`, `fq : ∀u v:P. Path(P,u,v)` (i.e. `isProp P`).

## Circle  `S¹`   (Circ/Base/Loop/CircM)

Surface: `S1`, `s1base`, `s1loop`, `celim(x, b, l)`. (`s1base`/`s1loop` are
spelled with the `s1` prefix so they do not shadow the common identifiers
`base`/`loop`, which the corpus uses.)

    s1base            : S¹
    s1loop            : Path(S¹, base, base)         s1loop @ i0 = @ i1 = base
    celim(s1base,b,l)        ≡ b                       (base β)
    celim(s1loop @ i,b,l)    ≡ l @ i                   (loop β)

`b : B`, `l : Path B b b`.

## Implementation

Each HIT adds five (three for `S¹`) `Term` constructors threaded through every
`Term`-traversing pass — `Type` (Show), `WHNF` (reduction: `occursMarker`,
`whnfGo` dispatch, `whnfPAp` path-ctor boundaries, the recursor reducers,
`dup`, `normal`, `mapSub`), `Equal` (`eql`), `Check` (`infer`/`check` typing),
`Deps`, `Bind`, `Flatten` (`flatten`/`unpat`/`unfrkGo`/`subst`), `Rewrite`,
and `HVM4Full` (runtime emission). `hcomp` on a HIT stays a value (fhcom) via
the existing symbolic-face `HCm`; `coe`/`transp` over a constant HIT line is
the identity by the existing regularity rule (the census's case).

Acceptance: `setquotient_test.bend` (8/8), `hit_test.bend` (12/12); the
pre-existing cubical suite is unregressed.
