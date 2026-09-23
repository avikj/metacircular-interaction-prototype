# DO THE TWO UNIVALENCES AGREE?
#
# This layer has two ways to turn an equivalence into a path in Set:
#
#   ua(A, B, f, g, gf, fg)   a primitive Term constructor, with its own coe
#                            rules and a DEFINITIONAL uaβ
#   uaG(A, B, e)             CCHM's Glue line
#                            <i> Glue(B, [(inot i, A, e), (i, B, idEquiv B)])
#
# REMAINING.md §F said they "agree on the tested cases; nothing forces that".
# This file makes the question precise and records the answer.
#
# They are NOT definitionally equal. Checking `agree_defn` below with a refl
# proof reports, exactly:
#
#   - ua(A,B,f,g,..)
#   - <i> Glue(B,{inot(i)=>(A,(f,...)); i=>(B,(λx. x,...)); })
#
# because `ua` is a constructor of its own, not notation for the Glue.
#
# So agreement is a THEOREM to prove, and the proof needs the η direction of
# univalence -- for every p : Path(Set,A,B), ua(pathToEquiv p) = p -- which
# this layer does not yet have. What it has is the β direction
# (uaequiv.bend/roundtrip.bend: pathToEquiv(ua e) = e) plus definitional
# uaβ on transport. From β alone the two paths are known to induce the same
# equivalence; concluding that they ARE the same path is exactly η.
#
# BUT THE BETTER ANSWER IS TO DELETE ONE OF THEM, NOT TO PROVE η.
#
# The primitive exists for its computation rules. It turns out the Glue line
# already has them, definitionally, in both directions -- both of these check
# with a refl proof against the fork built from cubical-paths.patch:
#
#   coe(<i> uaG(A,B,e) @ i, i0, i1, x)  =  f x        definitional
#   coe(<i> uaG(A,B,e) @ i, i1, i0, y)  =  g y        definitional
#
# So in the CHECKER the primitive earns nothing. Where it is still
# load-bearing is the runtime: Target emitters represent a universe path as a
# Church pair (fwd, bwd), and `lineRep` in Core/WHNF.hs knows how to build
# that pair for a constant line, P @ i, P @ inot(i), a Π line, a Σ line and
# an hcomp composite -- and for `ua`, via pathRep's catch-all. It has NO Glue
# case. Make `ua` sugar for the Glue line today and the strict emitter
# refuses every univalence program.
#
# The bounded piece of work that removes this gap entirely: give `lineRep` a
# Glue case that reads the equivalence off the faces of
# `Glue(B, [(inot i, A, e), (i, B, idEquiv B)])` and emits (fstE e, invEq e).
# Then `ua` becomes surface syntax for the CCHM Glue line, the Ua constructor
# and its bespoke coe rules go, and there is one univalence with nothing to
# prove about agreement.
#
# Until then, this file states the obligation rather than hiding it.
# Uncomment to see the mismatch reproduce.
#
# def agree_defn(A: Set, B: Set, f: A -> B, g: B -> A,
#                gf: all x: A. Path(A, g(f(x)), x),
#                fg: all y: B. Path(B, f(g(y)), y))
#     -> Path(Path(Set, A, B), ua(A, B, f, g, gf, fg), uaG(A, B, isoToEquiv(A, B, f, g, fg, gf))):
#   <_> ua(A, B, f, g, gf, fg)

def main() -> Nat:
  0n
