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
# Until η exists, this file states the obligation rather than hiding it.
# Uncomment to see the mismatch reproduce.
#
# def agree_defn(A: Set, B: Set, f: A -> B, g: B -> A,
#                gf: all x: A. Path(A, g(f(x)), x),
#                fg: all y: B. Path(B, f(g(y)), y))
#     -> Path(Path(Set, A, B), ua(A, B, f, g, gf, fg), uaG(A, B, isoToEquiv(A, B, f, g, fg, gf))):
#   <_> ua(A, B, f, g, gf, fg)

def main() -> Nat:
  0n
