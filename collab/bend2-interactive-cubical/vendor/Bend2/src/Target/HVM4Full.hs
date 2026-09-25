{-./../Core/Type.hs-}

{-# LANGUAGE ViewPatterns #-}

-- Bend2 -> HVM4, FULL RUNTIME: nothing cubical is erased or pre-normalised.
--
-- Intervals are runtime data (#I0, #I1, and symbolic terms built by @inot /
-- @iand / @ior), paths are runtime functions of intervals, TYPES are runtime
-- data (#Bool, #Pi{A,B}, #Sig{A,B}, #Path{A,u,v}, universe paths #UaU/#CompU),
-- `coe` is the runtime function @coe dispatching on the type former the line
-- yields at a symbolic interval, and `hcomp` is the runtime function @hcomp
-- that evaluates its faces and STAYS STUCK DATA (#HCm{...}) when a face is
-- symbolic — partial knowledge, decided later by application.
--
-- The prelude below is Core.WHNF's cubical reduction, written as an HVM4
-- program. Superposed lines need no rule: an HVM4 match commutes over a
-- superposition and same-label dups annihilate, which IS the fibre routing.

module Target.HVM4Full where

import Data.List (intercalate)
import Data.Char (isAlphaNum)
import qualified Data.Set as S
import Target.HVM (freeVars)
import qualified Data.Map as M

import Core.Type
import Core.WHNF (coeMarker, occursMarker, substMarker, depMarker, occursDep, force, hitCtorTypeAt, ctorFieldType)
import Data.IORef
import System.IO.Unsafe (unsafePerformIO)

-- Every binder gets a globally unique name: HVM4 derives the clone label of a
-- `λ&x` from the binder, so two different lambdas sharing a name (e.g. both
-- named by depth) would share a label and their dups would annihilate
-- instead of commuting. Names must be unique per binder occurrence.
{-# NOINLINE binderCounter #-}
binderCounter :: IORef Int
binderCounter = unsafePerformIO (newIORef 0)

{-# NOINLINE freshName #-}
freshName :: Int -> String
freshName d = unsafePerformIO $ do
  n <- atomicModifyIORef' binderCounter (\n -> (n + 1, n))
  return ("b" ++ show d ++ "u" ++ show n)

compileFull :: Book -> String
compileFull book@(Book defs _) =
  prelude ++ hitPrelude book ++ unlines (concatMap def (M.toList defs)) ++ root
  where
    -- A checked definition is a typed point (A, a): both are cells of the one
    -- complex and both are emitted, by the same emitter.
    def (nam, (_, tm, ty)) =
      [ "@" ++ defName nam  ++ " = " ++ emitFull book tm
      , "@" ++ typeName nam ++ " = " ++ emitFull book ty ]

    -- The root is the checked entry as a point of Σ(A : Set). A.
    root = case M.lookup "main" defs of
      Just _  -> "@main = #Pair{@" ++ typeName "main" ++ ", @" ++ defName "main" ++ "}\n"
      Nothing -> ""

prelude :: String
prelude = unlines
  [ "// Bend2 -> HVM4 FULL RUNTIME (no erasure, no pre-normalisation)"
  , "// ---- numbers: pow by repetition; chars ARE numbers in HVM4"
  , "@pow = λ&b. λe. (λ{0: 1; λ&n. (b * @pow(b, (n - 1)))})(e)"
  , "@u64ToChar = λx. x"
  , "// ---- intervals"
  , "@inot = λ{#I0: #I1; #I1: #I0; λx. #INot{x}}"
  , "// (linear: a value is never cloned merely because it is used in several match ARMS —"
  , "//  HVM4 auto-dup labels are static per binder, and a dup of an argument that already"
  , "//  contains an instance of the same definition's dup would annihilate instead of commute)"
  , "@iand = λa. λb. (λ{#I0: λb. #I0; #I1: λb. b; λa. λb. (λ{#I0: λa. #I0; #I1: λa. a; λb2. λa. #IAnd{a, b2}})(b)(a)})(a)(b)"
  , "@ior  = λa. λb. (λ{#I1: λb. #I1; #I0: λb. b; λa. λb. (λ{#I1: λa. #I1; #I0: λa. a; λb2. λa. #IOr{a, b2}})(b)(a)})(a)(b)"
  , "@sameEnd = λ{#I0: λ{#I0: 1; λx. 0}; #I1: λ{#I1: 1; λx. 0}; λx. λy. 0}"
  , "// forward direction test: r=I0,s=I1 -> 1 ; r=I1,s=I0 -> 0"
  , "@fwd = λ{#I0: λs. 1; #I1: λs. 0; λr. λs. 0}"
  , "// ---- paths applied to intervals (universe paths are data; value paths are functions)"
  , "@pathAt = λp. λi. (λ{#I0: λp. @pL(p); #I1: λp. @pR(p); λi. λp. @pAtSym(p, i)})(i)(p)"
  , "@pAtSym = λ{#PLm: λf. λi. f(i); #TSq: λu. λv. λi. #At{#TSq{u, v}, i}; #Loop: λi. #At{#Loop, i}; #QEq: λa. λb. λw. λi. #At{#QEq{a, b, w}, i}; #UaU: λA. λB. λf. λg. λgf. λfg. λi. #At{#UaU{A, B, f, g, gf, fg}, i}; #CompU: λP. λQ. λi. #At{#CompU{P, Q}, i}; λv. λi. #StuckAt{v, i}}"
  , "@pL = λ{#PLm: λf. f(#I0); #TSq: λu. λv. u; #Loop: #Base; #QEq: λa. λb. λw. #QCl{a}; #UaU: λA. λB. λf. λg. λgf. λfg. A; #CompU: λP. λQ. P(#I0); λv. #StuckAt{v, #I0}}"
  , "@pR = λ{#PLm: λf. f(#I1); #TSq: λu. λv. v; #Loop: #Base; #QEq: λa. λb. λw. #QCl{b}; #UaU: λA. λB. λf. λg. λgf. λfg. B; #CompU: λP. λQ. Q(#I1); λv. #StuckAt{v, #I1}}"
  , "// ---- hcomp: faces = #Nil | #Cons{#Face{phi, tube}, rest}; stuck faces are kept"
  , "@hcomp = λA. λfs. λbase. @hcompGo(A, fs, base, #Nil)"
  , "@hcompGo = λ&A. λ{"
  , "  #Nil: λ&base. λ{#Nil: base; λ&stuck. (λ{"
  , "    #Set: #Glue{base, @setFaces(stuck)};"
  , "    #Pi: λ&A1. λ&B1. λ&v. @hcomp(B1(v), @hcTubesApp(stuck, v), base(v));"
  , "    #Path: λ&A1. λ&u1. λ&v1. #PLm{λ&j. @hcomp(A1(j), #Cons{#Face{@inot(j), #PLm{λk. u1}}, #Cons{#Face{j, #PLm{λk. v1}}, @hcTubesAtJ(stuck, j)}}, @pathAt(base, j))};"
  , "    #Sig: λ&A1. λ&B1. ! &{st1, st2} = stuck; ! &{ba1, ba2} = base; ! &{aa1, aa2} = A1;"
  , "          #Pair{@hcomp(aa1, @hcTubesFst(st1), @fstP(ba1)),"
  , "                @compAt(λj. B1(@hfillAt(aa2, @hcTubesFst(st2), @fstP(ba2), j)), @hcTubesSnd(stuck), @sndP(base))};"
  , "    #Glue: λ&aT. λ&gfs. @hcGlue(aT, gfs, stuck, base);"
  , "    #Nat: @hcNat(stuck, base);"
  , "    #List: λ&eT. @hcList(eT, stuck, base);"
  , "    #Unit: @hcNullary(#Unit, stuck, base);"
  , "    #Bool: @hcNullary(#Bool, stuck, base);"
  , "    λA2. #HCm{A2, stuck, base}})(A)};"
  , "  #Cons: λ{#Face: λphi. λ&tube. λ&rest. λ&base. λ&stuck. (λ{"
  , "    #I1: @pathAt(tube, #I1);"
  , "    #I0: @hcompGo(A, rest, base, stuck);"
  , "    λp. @hcompGo(A, rest, base, #Cons{#Face{p, tube}, stuck})})(phi)}}"
  , "// ---- type-directed Kan rules for hcomp (CCHM), mirroring Core.WHNF.whnfHCm"
  , "@fstP = λ{#Pair: λa. λb. a; λv. v}"
  , "@sndP = λ{#Pair: λa. λb. b; λv. v}"
  , "@hcTubesApp = λ{#Nil: λv. #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. λ&v. #Cons{#Face{p, #PLm{λj. @pathAt(tube, j)(v)}}, @hcTubesApp(rest, v)}}}"
  , "@hcTubesAtJ = λ{#Nil: λj. #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. λ&j. #Cons{#Face{p, #PLm{λk. @pathAt(@pathAt(tube, k), j)}}, @hcTubesAtJ(rest, j)}}}"
  , "@hcTubesFst = λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. @fstP(@pathAt(tube, j))}}, @hcTubesFst(rest)}}}"
  , "@hcTubesSnd = λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. @sndP(@pathAt(tube, j))}}, @hcTubesSnd(rest)}}}"
  , "@hcTubesAnd = λ{#Nil: λj. #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. λ&j. #Cons{#Face{p, #PLm{λk. @pathAt(tube, @iand(j, k))}}, @hcTubesAnd(rest, j)}}}"
  , "@hcTubesCoe = λ&P. λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λ&j. @coe(P, j, #I1, @pathAt(tube, j))}}, @hcTubesCoe(P, rest)}}}"
  , "@hcTubesMap = λ&f. λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. f(@pathAt(tube, j))}}, @hcTubesMap(f, rest)}}}"
  , "// hfill: the filler; comp: composition along a type line (coe + hcomp)"
  , "@hfillAt = λ&A. λ&fs. λ&u0. λ&j. @hcomp(A, #Cons{#Face{@inot(j), #PLm{λk. u0}}, @hcTubesAnd(fs, j)}, u0)"
  , "@compAt = λ&P. λ&fs. λ&u0. @hcomp(P(#I1), @hcTubesCoe(P, fs), @coe(P, #I0, #I1, u0))"
  , "// hcomp in a Glue type (CCHM): compose inside each partial type T (there"
  , "// Glue IS T), and in A compose the UNGLUED tube with one extra face per phi"
  , "// forcing f of the T-filler; then glue the phi-parts onto the A-part."
  , "@hcTubesUnglue = λ&gfs. λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. @gUnglue(gfs, @pathAt(tube, j))}}, @hcTubesUnglue(gfs, rest)}}}"
  , "@hcGlueFaces = λ&fs. λ&base. λ{#Nil: #Nil; #Cons: λ{#GFace: λphi. λ&T. λ&e. λ&rest. #Cons{#Face{phi, #PLm{λk. @eFun(e)(@hfillAt(T, fs, base, k))}}, @hcGlueFaces(fs, base, rest)}}}"
  , "@hcGlueT = λ&fs. λ&base. λ{#Nil: #Nil; #Cons: λ{#GFace: λphi. λ&T. λe. λ&rest. #Cons{#Face{phi, @hcomp(T, fs, base)}, @hcGlueT(fs, base, rest)}}}"
  , "@appendF = λ{#Nil: λys. ys; #Cons: λ{#Face: λp. λt. λ&rest. λ&ys. #Cons{#Face{p, t}, @appendF(rest, ys)}}}"
  , "@hcGlue = λ&aT. λ&gfs. λ&fs. λ&base."
  , "  ! &{g1, gx} = gfs; ! &{g2, g3} = gx;"
  , "  ! &{f1, fx} = fs; ! &{f2, f3} = fx;"
  , "  ! &{b1, bx} = base; ! &{b2, b3} = bx;"
  , "  @glue(aT, @hcomp(aT, @appendF(@hcTubesUnglue(g1, f1), @hcGlueFaces(f2, b1, g2)), @gUnglue(g3, b2)), @hcGlueT(f3, b3, gfs))"
  , "// hcomp in an inductive type: push through a common constructor head."
  , "// Headedness of a LINE is decided by applying it at the marker dimension,"
  , "// the same idiom @coe uses for its regularity check."
  , "@allSuc = λ{#Nil: #I1; #Cons: λ{#Face: λp. λ&tube. λ&rest. (λ{#Suc: λn. @allSuc(rest); λv. #I0})(@pathAt(tube, #IMark))}}"
  , "@hcTubesPred = λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. (λ{#Suc: λn. n; λv. v})(@pathAt(tube, j))}}, @hcTubesPred(rest)}}}"
  , "@hcNat = λ&fs. λ&base. (λ{"
  , "  #Suc: λ&n. (λ{#I1: #Suc{@hcomp(#Nat, @hcTubesPred(fs), n)}; λo. #HCm{#Nat, fs, #Suc{n}}})(@allSuc(fs));"
  , "  λv. #HCm{#Nat, fs, v}})(base)"
  , "@allCon = λ{#Nil: #I1; #Cons: λ{#Face: λp. λ&tube. λ&rest. (λ{#Con: λh. λt. @allCon(rest); λv. #I0})(@pathAt(tube, #IMark))}}"
  , "@hcTubesHd = λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. (λ{#Con: λh. λt. h; λv. v})(@pathAt(tube, j))}}, @hcTubesHd(rest)}}}"
  , "@hcTubesTl = λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. (λ{#Con: λh. λt. t; λv. v})(@pathAt(tube, j))}}, @hcTubesTl(rest)}}}"
  , "@hcList = λ&eT. λ&fs. λ&base. (λ{"
  , "  #Con: λ&h. λ&t. (λ{#I1: #Con{@hcomp(eT, @hcTubesHd(fs), h), @hcomp(#List{eT}, @hcTubesTl(fs), t)}; λo. #HCm{#List{eT}, fs, #Con{h, t}}})(@allCon(fs));"
  , "  λv. #HCm{#List{eT}, fs, v}})(base)"
  , "// discrete types: the composite is the cap when every tube agrees with it"
  , "@allEq = λ&x. λ{#Nil: #I1; #Cons: λ{#Face: λp. λ&tube. λ&rest. (λ{#I1: @allEq(x, rest); λo. #I0})(@sameCtr(x, @pathAt(tube, #IMark)))}}"
  , "@sameCtr = λ{0: λ{0: #I1; λw. #I0}; 1: λ{1: #I1; λw. #I0}; #One: λ{#One: #I1; λw. #I0}; #Nil: λ{#Nil: #I1; λw. #I0}; λv. λw. #I0}"
  , "@hcNullary = λ&A. λ&fs. λ&base. ! &{b1, bx} = base; ! &{b2, b3} = bx; (λ{#I1: b2; λo. #HCm{A, fs, b3}})(@allEq(b1, fs))"
  , "// propositional truncation: tsquash is a PATH constructor joining ANY two"
  , "// elements; the recursor sends it to the target's own proof of propness."
  , "@trec = λ&x. λ&pb. λ&f. (λ{#TIn: λa. f(a); #At: λp. λi. (λ{#TSq: λu. λv. @pathAt(pb(@trec(u, pb, f))(@trec(v, pb, f)), i); λq. #TRec{q, pb, f}})(p); λv. #TRec{v, pb, f}})(x)"
  , "// S1: loop is a PATH constructor, so @pathAt knows it; the recursor sends"
  , "// base to b and loop@i to l@i."
  , "@srec = λ&x. λ&b. λ&l. (λ{#Base: b; #At: λp. λi. (λ{#Loop: @pathAt(l, i); λq. #SRec{q, b, l}})(p); λv. #SRec{v, b, l}})(x)"
  , "// pout: a system on a true face is that branch"
  , "@pout = λ{#Sys: λfs. @poutGo(fs); λv. #POut{v}}"
  , "@poutGo = λ{#Nil: #POut{#Nil}; #Cons: λ{#Face: λphi. λ&v. λ&rest. (λ{#I1: v; λq. @poutGo(rest)})(phi)}}"
  , "// transp with a cofibration: identity on phi, ordinary transport off it"
  , "@transp = λ&L. λp. λ&x. (λ{#I1: x; #I0: @coe(L, #I0, #I1, x); λq. #Trp{L, q, x}})(p)"
  , "// outS: projecting a restricted element; outS(inS x) = x"
  , "@outS = λ{#InS: λx. x; λv. #OutS{v}}"
  , "// ---- SetQuotient recursor: on a point it is f; on the path constructor it"
  , "// is the resp witness applied at that interval; superpositions commute."
  , "@qrec = λ&x. λ&t. λ&f. λ&rsp. (λ{"
  , "  #QCl: λa. f(a);"
  , "  #At: λp. λi. (λ{#QEq: λa. λb. λw. @pathAt(rsp(a)(b)(w), i); λq. #QRec{q, t, f, rsp}})(p);"
  , "  λv. #QRec{v, t, f, rsp}})(x)"
  , "// ---- Glue (boundary rules only, as in the checker): a true face selects its partial type / section"
  , "@glueT = λA. λfs. @glueTGo(fs, #Nil, A)"
  , "@glueTGo = λfs. λlive. λA. (λ{"
  , "  #Nil: λlive. λA. (λ{#Nil: λA. A; λlive. λA. #Glue{A, live}})(live)(A);"
  , "  #Cons: λ{#GFace: λphi. λT. λe. λrest. λlive. λA. (λ{"
  , "    #I0: λT. λe. λrest. λlive. λA. @glueTGo(rest, live, A);"
  , "    λp. λT. λe. λrest. λlive. λA. @glueTGo(rest, #Cons{#GFace{p, T, e}, live}, A)})(phi)(T)(e)(rest)(live)(A)}})(fs)(live)(A)"
  , "@glueA = λ{#Glue: λA. λfs. A; λA. A}"
  , "@glueFs = λ{#Glue: λA. λfs. fs; λA. #Nil}"
  , "// coherent equivalence e = #Pair{f, h}: function, inverse (fibre centre), section path"
  , "@eFun = λ{#Pair: λf. λh. f}"
  , "@eInv = λ{#Pair: λf. λh. λy. (λ{#Pair: λcen. λc. (λ{#Pair: λx. λp. x})(cen)})(h(y))}"
  , "@eSec = λ{#Pair: λf. λh. λy. (λ{#Pair: λcen. λc. (λ{#Pair: λx. λp. p})(cen)})(h(y))}"
  , "// transport through Glue: faces at r and s read off L(r), L(s)"
  , "// the faces are read off the line at the MARKER and instantiated at r / s by"
  , "// interval substitution (re-evaluating L at a literal endpoint would let a"
  , "// true face collapse the Glue to its partial type and lose the faces)"
  , "@coeGlue = λ&L. λ&r. λ&s. λ&x. λfs0."
  , "  ! &{fsA, fsB} = fs0;"
  , "  ! &{a1x, a1y} = @coe(λi. @glueA(L(i)), r, s, @gUnglue(@facesAt(fsA, r), x));"
  , "  ! &{a1u, a1v} = a1x;"
  , "  ! &{fsS, fsS2} = @facesAt(fsB, s);"
  , "  ! &{aSu, aSv} = @glueA(L(s));"
  , "  @glue(aSu, @gT1(fsS, a1y), @hcomp(aSv, @gTubes(fsS2, a1u), a1v))"
  , "@substI = λ&s. λ{#IMark: s; #I0: #I0; #I1: #I1; #INot: λa. @inot(@substI(s, a)); #IAnd: λa. λb. @iand(@substI(s, a), @substI(s, b)); #IOr: λa. λb. @ior(@substI(s, a), @substI(s, b)); λv. v}"
  , "@facesAt = λ{#Nil: λs. #Nil; #Cons: λ{#GFace: λphi. λT. λe. λrest. λ&s. (λ{#I0: λT. λe. λrest. λs. @facesAt(rest, s); λp. λT. λe. λrest. λs. #Cons{#GFace{p, T, e}, @facesAt(rest, s)}})(@substI(s, phi))(T)(e)(rest)(s)}}"
  , "// unglue at r: a true face gives fst(e) x; symbolic faces unglue the glue value; no faces: x"
  , "@gUnglue = λ{#Nil: λx. x; #Cons: λ{#GFace: λphi. λT. λe. λrest. λx. (λ{#I1: λe. λrest. λx. @eFun(e)(x); λp. λe. λrest. λx. @gUngS(rest, x)})(phi)(e)(rest)(x)}}"
  , "@gUngS = λ{#Nil: λx. @unglue(x); #Cons: λ{#GFace: λphi. λT. λe. λrest. λx. (λ{#I1: λe. λrest. λx. @eFun(e)(x); λp. λe. λrest. λx. @gUngS(rest, x)})(phi)(e)(rest)(x)}}"
  , "@gT1 = λ{#Nil: λa. #Nil; #Cons: λ{#GFace: λphi. λT. λ&e. λ&rest. λ&a. #Cons{#Face{phi, @eInv(e)(a)}, @gT1(rest, a)}}}"
  , "@gTubes = λ{#Nil: λa. #Nil; #Cons: λ{#GFace: λphi. λT. λ&e. λ&rest. λ&a. #Cons{#Face{phi, #PLm{λj. @pathAt(@eSec(e)(@eInv(e)(a)), @inot(j))}}, @gTubes(rest, a)}}}"
  , "// hcomp in the universe: Glue over the base with the transport equivalences of the tubes"
  , "@isContrT = λ&c. #Sig{c, λ&cen. #Pi{c, λw. #Path{λi. c, cen, w}}}"
  , "@fiberT = λ&T. λ&A. λ&f. λ&y. #Sig{T, λx. #Path{λi. A, f(x), y}}"
  , "@equivT = λ&T. λ&A. #Sig{#Pi{T, λx. A}, λ&f. #Pi{A, λy. @isContrT(@fiberT(T, A, f, y))}}"
  , "@idEquivV = λ&a. #Pair{λx. x, λ&y. #Pair{#Pair{y, #PLm{λi. y}}, λ{#Pair: λx. λ&p. #PLm{λ&i. #Pair{@pathAt(p, @inot(i)), #PLm{λj. @pathAt(p, @ior(@inot(i), j))}}}}}}"
  , "@transpEquiv = λ&u. ! &{top, top2} = @pathAt(u, #I1); @coe(λ&k. @equivT(top, @pathAt(u, @inot(k))), #I0, #I1, @idEquivV(top2))"
  , "@setFaces = λ{#Nil: #Nil; #Cons: λ{#Face: λphi. λ&u. λrest. #Cons{#GFace{phi, @pathAt(u, #I1), @transpEquiv(u)}, @setFaces(rest)}}}"
  , "@glue = λA. λfs. λx. @glueGo(fs, x, #Nil, A)"
  , "@glueGo = λfs. λx. λstuck. λA. (λ{"
  , "  #Nil: λx. λstuck. λA. (λ{#Nil: λx. λA. x; λstuck. λx. λA. #GlB{A, stuck, x}})(stuck)(x)(A);"
  , "  #Cons: λ{#Face: λphi. λt. λrest. λx. λstuck. λA. (λ{"
  , "    #I1: λt. λrest. λx. λstuck. λA. t;"
  , "    #I0: λt. λrest. λx. λstuck. λA. @glueGo(rest, x, stuck, A);"
  , "    λp. λt. λrest. λx. λstuck. λA. @glueGo(rest, x, #Cons{#Face{p, t}, stuck}, A)})(phi)(t)(rest)(x)(stuck)(A)}})(fs)(x)(stuck)(A)"
  , "@unglue = λ{#GlB: λA. λfs. λx. x; λg. g}"
  , "// ---- coe: transport x along the type line L from r to s"
  , "@coe = λ&L. λ&r. λ&s. λ&x. (λ{1: x; λn. @coeT(L, r, s, x, L(#IMark))})(@sameEnd(r, s))"
  , "@piA = λ{#Pi: λA. λB. A; λt. #StuckDom{t}}"
  , "@piB = λ{#Pi: λA. λB. B; λt. λv. #StuckCod{t}}"
  , "@sgA = λ{#Sig: λA. λB. A; λt. #StuckDom{t}}"
  , "@sgB = λ{#Sig: λA. λB. B; λt. λv. #StuckCod{t}}"
  , "@ptA = λ{#Path: λA. λu. λv. A; λt. #StuckPathTy{t}}"
  , "@ptU = λ{#Path: λA. λu. λv. u; λt. #StuckPathTy{t}}"
  , "@ptV = λ{#Path: λA. λu. λv. v; λt. #StuckPathTy{t}}"
  , "// List is parameterized: coerce its heads, not just its container."
  , "// Keep the element type selected by the dispatch at #IMark: resampling"
  , "// a superposed line for each element can reopen an already selected branch."
  , "// Match before binding L/r/s/E, so exclusive arms introduce no dups."
  , "@listA = λ{#List: λlcaElem. lcaElem; λlcaOther. #StuckListElement{lcaOther}}"
  , "@coeList = λlcL. λlcR. λlcS. λlcE. λlcXs. (λ{"
  , "  #Nil: λlcnL. λlcnR. λlcnS. λlcnE. #Nil;"
  , "  #Con: λlccH. λlccT. λ&lccL. λ&lccR. λ&lccS. λ&lccE. #Con{@coeT(λlci. @listA(lccL(lci)), lccR, lccS, lccH, lccE), @coeList(lccL, lccR, lccS, lccE, lccT)};"
  , "  λlcuXs. λlcuL. λlcuR. λlcuS. λlcuE. #StuckListCoe{lcuL, lcuR, lcuS, lcuE, lcuXs}})(lcXs)(lcL)(lcR)(lcS)(lcE)"
  , "@coeT = λ&L. λ&r. λ&s. λ&x. λ{"
  , "  #Bool: x; #Nat: x; #Set: x; #Unit: x; #Empty: x; #Enum: λes. x; #Num: λk. x; #Itv: x;"
  , "  // an Eql value is #Refl (EqlM matches nothing else) and transport keeps it"
  , "  #Eql: λt. λa. λb. x;"
  , "  #List: λe. @coeList(L, r, s, e, x);"
  , "  #Pi: λA0. λB0. λ&y. @coe(λ&i. @piB(L(i), @coe(λj. @piA(L(j)), s, i, y)), r, s, x(@coe(λj. @piA(L(j)), s, r, y)));"
  , "  #Sig: λA0. λB0. (λ{#Pair: λ&a. λb. #Pair{@coe(λj. @sgA(L(j)), r, s, a), @coe(λ&i. @sgB(L(i), @coe(λj. @sgA(L(j)), r, i, a)), r, s, b)}})(x);"
  , "  #Path: λA0. λu0. λv0. @coePath(L, r, s, x);"
  , "  #At: λp. λi. @coeAt(p, i, r, s, x);"
  , "  #Glue: λA0. λfs0. @coeGlue(L, r, s, x, fs0);"
  , "  λt. @hitCoe(L, r, s, x, t)}"
  , "// Path transport fills the j-boundaries; k runs from r to s, including reverse transport."
  , "@coePath = λ&L. λ&r. λ&s. λx. #PLm{λ&j. @hcomp(@ptA(L(s))(j), #Cons{#Face{@inot(j), #PLm{λ&k. @coe(λi. @ptA(L(i))(#I0), @ior(@iand(@inot(k), r), @iand(k, s)), s, @ptU(L(@ior(@iand(@inot(k), r), @iand(k, s)))))}}, #Cons{#Face{j, #PLm{λ&k. @coe(λi. @ptA(L(i))(#I1), @ior(@iand(@inot(k), r), @iand(k, s)), s, @ptV(L(@ior(@iand(@inot(k), r), @iand(k, s)))))}}, #Nil}}, @coe(λi. @ptA(L(i))(j), r, s, @pathAt(x, j)))}"
  , "// tubes of an hcomp cell transported along a line (transport commutes with hcomp in a HIT)"
  , "@hcTubesCoeLine = λ&L. λ&r. λ&s. λ{#Nil: #Nil; #Cons: λ{#Face: λp. λ&tube. λ&rest. #Cons{#Face{p, #PLm{λj. @coe(L, r, s, @pathAt(tube, j))}}, @hcTubesCoeLine(L, r, s, rest)}}}"
  , "// coe along a universe path applied at the symbolic marker (or its negation)"
  , "// direction of literal endpoints: 1 fwd, 0 bwd, 2 symbolic (stuck)"
  , "@dir = λ{#I0: λ{#I1: 1; λs. 2}; #I1: λ{#I0: 0; λs. 2}; λr. λs. 2}"
  , "@coeAt = λ&p. λ{#IMark: λr. λs. λx. @coeU(p, @dir(r, s), x); #INot: λ{#IMark: λr. λs. λx. @coeU(p, (1 - @dir(r, s)), x); λi. λr. λs. λx. #StuckCoe{#At{p, #INot{i}}, x}}; λi. λr. λs. λx. #StuckCoe{#At{p, i}, x}}"
  , "@coeU = λ{"
  , "  #UaU: λ&A. λ&B. λ&f. λ&g. λ&gf. λ&fg. λd. λ&x. (λ{1: f(x); 0: g(x); λn. #StuckCoeU{#UaU{A, B, f, g, gf, fg}, x}})(d);"
  , "  #CompU: λ&P. λ&Q. λ&d. λ&x. (λ{1: @coe(Q, #I0, #I1, @coe(P, #I0, #I1, x)); 0: @coe(P, #I1, #I0, @coe(Q, #I1, #I0, x)); λn. #StuckCoeU{#CompU{P, Q}, x}})(d);"
  , "  λv. λd. λx. #StuckCoeU{v, x}}"
  , "" ]

hvmName :: Name -> String
hvmName = concatMap (\c -> if c == '/' then "__" else [c])

-- Definition cells and their type cells live in injective namespaces (HVM4
-- names are [A-Za-z0-9_]; Bend names add '/'), disjoint from the prelude.
defName, typeName :: Name -> String
defName  nam = "D" ++ escName nam
typeName nam = "T" ++ escName nam

escName :: Name -> String
escName = concatMap (\c -> case c of { '_' -> "_u"; '/' -> "_s"; _ -> [c] })

emitFull :: Book -> Term -> String
emitFull book t0 = go 0 t0 where
  go :: Int -> Term -> String
  go d t = case t of
    Var n i        -> if i < 0 then "#IMark" else n
    Ref k          -> "@" ++ defName k
    Sub x          -> go d x
    Loc _ x        -> go d x
    Chk x _        -> go d x
    Ind x          -> go d x
    Frz x          -> go d x
    Fix k f        -> let n = freshName d in "!" ++ n ++ "&F = " ++ go (d+1) (f (Var n d)) ++ "; " ++ n
    Let v f        -> appFun d f ++ "(" ++ go d v ++ ")"
    Lam k f        -> let n = freshName d in "λ&" ++ n ++ ". " ++ go (d+1) (f (Var n d))
    App f x        -> appFun d f ++ "(" ++ go d x ++ ")"
    -- data
    Zer            -> "#Zer"
    Suc n          -> "#Suc{" ++ go d n ++ "}"
    Bt0            -> "0"
    Bt1            -> "1"
    One            -> "#One"
    Nil            -> "#Nil"
    Con h tl       -> "#Con{" ++ go d h ++ ", " ++ go d tl ++ "}"
    Val (U64_V v)  -> if v <= 4294967295 then show v else error "HVM4 full: integer literal exceeds the 32-bit runtime word; use explicit limbs"
    Val (CHR_V c)  -> show (fromEnum c)
    Val (F64_V _)  -> error "HVM4 full: F64 requires an explicit IEEE representation; refusing to replace a floating-point value with zero"
    Val (I64_V _)  -> error "HVM4 full: signed integers require an explicit signed representation"
    Sym s          -> "#" ++ s
    Tup a b        -> "#Pair{" ++ go d a ++ ", " ++ go d b ++ "}"
    Rfl            -> "#Refl"
    BitM x f tr    -> branchMatch d x [("0", 0, f), ("_", -1, tr)]
    NatM x z s     -> branchMatch d x [("#Zer", 0, z), ("#Suc", 1, s)]
    LstM x n c     -> branchMatch d x [("#Nil", 0, n), ("#Con", 2, c)]
    UniM x f       -> "λ{#One: " ++ go d f ++ "}(" ++ go d x ++ ")"
    SigM x f       -> "λ{#Pair: " ++ go d f ++ "}(" ++ go d x ++ ")"
    EqlM x f       -> "λ{#Refl: " ++ go d f ++ "}(" ++ go d x ++ ")"
    EmpM x         -> "λ{}(" ++ go d x ++ ")"
    EnuM x cs df   -> branchMatch d x ([("#" ++ sy, 0, b) | (sy,b) <- cs] ++ [("_", -1, df)])
    Op2 POW a b    -> "@pow(" ++ go d a ++ ", " ++ go d b ++ ")"
    Op2 o a b      -> "(" ++ go d a ++ " " ++ op2 o ++ " " ++ go d b ++ ")"
    Op1 o _        -> error ("HVM4 full: unary " ++ show o ++ " is type-directed in Core (Bool vs U64) and both share the runtime word; write it as a match or a binary op")
    Log _ x        -> go d x
    Rwt _ _ x      -> go d x
    -- superpositions: native
    Sup l a b      -> "&" ++ label l ++ "{" ++ go d a ++ ", " ++ go d b ++ "}"
    Frk l a b      -> "&" ++ label l ++ "{" ++ go d a ++ ", " ++ go d b ++ "}"
    SupM x l f     -> "!&D&" ++ label l ++ " = " ++ go d x ++ "; " ++ go d f
    Era            -> "&{}"
    -- TYPES ARE DATA
    Set            -> "#Set"; Bit -> "#Bool"; Nat -> "#Nat"; Uni -> "#Unit"; Emp -> "#Empty"
    Lst e          -> "#List{" ++ go d e ++ "}"; Enu ss -> "#Enum{" ++ foldr (\sy acc -> "#Con{#" ++ sy ++ ", " ++ acc ++ "}") "#Nil" ss ++ "}"; Num k -> "#Num{#" ++ numTag k ++ "}"; Itv -> "#Itv"
    Eql a x y      -> "#Eql{" ++ go d a ++ ", " ++ go d x ++ ", " ++ go d y ++ "}"
    -- QUOTIENTS (SetQuotient HIT): the type is data, [a] is a point, eq/ is a
    -- PATH constructor (so @pathAt must know it), squash/ is opaque, and the
    -- recursor is the runtime function @qrec.
    -- Restricted types: the type is data; inS wraps, outS unwraps (@outS).
    Tru a          -> "#Trunc{" ++ go d a ++ "}"
    TIn a          -> "#TIn{" ++ go d a ++ "}"
    TSq x y        -> "#TSq{" ++ go d x ++ ", " ++ go d y ++ "}"
    TRec x p f     -> "@trec(" ++ go d x ++ ", " ++ go d p ++ ", " ++ go d f ++ ")"
    Cir            -> "#S1"
    CBase          -> "#Base"
    CLoop          -> "#Loop"
    CRec x b l     -> "@srec(" ++ go d x ++ ", " ++ go d b ++ ", " ++ go d l ++ ")"
    Prt p a        -> "#Partial{" ++ go d p ++ ", " ++ go d a ++ "}"
    Sys fs         -> "#Sys{" ++ faces d fs ++ "}"
    POut u         -> "@pout(" ++ go d u ++ ")"
    Trp l p x      -> "@transp(" ++ go d l ++ ", " ++ go d p ++ ", " ++ go d x ++ ")"
    Rst a p u      -> "#Sub{" ++ go d a ++ ", " ++ go d p ++ ", " ++ go d u ++ "}"
    InS x          -> "#InS{" ++ go d x ++ "}"
    OutS x         -> "@outS(" ++ go d x ++ ")"
    Quo a r        -> "#Quot{" ++ go d a ++ ", " ++ go d r ++ "}"
    QCl a          -> "#QCl{" ++ go d a ++ "}"
    QEq a b w      -> "#QEq{" ++ go d a ++ ", " ++ go d b ++ ", " ++ go d w ++ "}"
    QSq            -> "#QSq"
    QRec x t f r   -> "@qrec(" ++ go d x ++ ", " ++ go d t ++ ", " ++ go d f ++ ", " ++ go d r ++ ")"
    -- GENERAL HITs: the type and every constructor are data carrying the
    -- parameters; a path constructor is a runtime path (#PLm over the
    -- generated @P_T_c, which reduces at literal endpoints and stays
    -- canonical otherwise); the eliminator is the generated @E_T.
    HTy t ps       -> "#HT_" ++ hvmName t ++ "{" ++ intercalate ", " (map (go d) ps) ++ "}"
    HCon t c ps as ivs -> case derefCtor book c of
      -- parameters the term does not carry are erased at runtime (they are
      -- only consulted by path constructors whose endpoints mention them)
      Just (_, h, k) | ctorDim k == 0 -> "#" ++ hitCtorTag t c ++ "{" ++ intercalate ", " (psOr h ps ++ map (go d) as) ++ "}"
      Just (_, h, k) ->
        let rest = ctorDim k - length ivs
            ns   = [ freshName (d + i) | i <- [0 .. rest - 1] ]
            call = "@" ++ hitPathFn t c ++ "(" ++ intercalate ", " (psOr h ps ++ map (go d) (as ++ ivs) ++ ns) ++ ")"
        in foldr (\n acc -> "#PLm{λ&" ++ n ++ ". " ++ acc ++ "}") call ns
      Nothing -> "&{}"
    HEl p bs x     -> case elimOf bs of
      Just (t, h) -> "@" ++ hitElimFn t ++ "(" ++ intercalate ", " (go d p : [ maybe "&{}" (go d) (lookup c bs) | (c, _) <- hitCtors h ] ++ [go d x]) ++ ")"
      Nothing     -> "#HEl{" ++ go d x ++ "}"
    HRec bs x      -> case elimOf bs of
      Just (t, h) -> "@" ++ hitElimFn t ++ "(" ++ intercalate ", " ("λ&hm. #NoMotive" : [ maybe "&{}" (go d) (lookup c bs) | (c, _) <- hitCtors h ] ++ [go d x]) ++ ")"
      Nothing     -> "#HRec{" ++ go d x ++ "}"
    Sig a b        -> "#Sig{" ++ go d a ++ ", " ++ go d b ++ "}"
    All a b        -> "#Pi{" ++ go d a ++ ", " ++ go d b ++ "}"
    Pth a u v      -> "#Path{" ++ go d a ++ ", " ++ go d u ++ ", " ++ go d v ++ "}"
    -- INTERVALS ARE DATA
    I0             -> "#I0"
    I1             -> "#I1"
    INot a         -> "@inot(" ++ go d a ++ ")"
    IAnd a b       -> "@iand(" ++ go d a ++ ", " ++ go d b ++ ")"
    IOr a b        -> "@ior(" ++ go d a ++ ", " ++ go d b ++ ")"
    -- PATHS: a universe-level composite is data (#CompU of two lines); every
    -- other path lambda is a runtime function of a runtime interval
    PLm k f        -> case compLine (f coeMarker) of
                        Just (p, q) -> "#CompU{" ++ go d (Lam "i" (\i -> substMarker i p)) ++ ", " ++ go d (Lam "i" (\i -> PAp q i)) ++ "}"
                        Nothing     -> let n = freshName d in "#PLm{λ&" ++ n ++ ". " ++ go (d+1) (f (Var n d)) ++ "}"
    PAp p r        -> "@pathAt(" ++ go d p ++ ", " ++ go d r ++ ")"
    Coe pP r s x   -> "@coe(" ++ go d pP ++ ", " ++ go d r ++ ", " ++ go d s ++ ", " ++ go d x ++ ")"
    HCm a fs x     -> "@hcomp(" ++ go d a ++ ", " ++ faces d fs ++ ", " ++ go d x ++ ")"
    Glu a fs       -> "@glueT(" ++ go d a ++ ", " ++ foldr (\(p,t,e) acc -> "#Cons{#GFace{" ++ go d p ++ ", " ++ go d t ++ ", " ++ go d e ++ "}, " ++ acc ++ "}") "#Nil" fs ++ ")"
    GlB a fs x     -> "@glue(" ++ go d a ++ ", " ++ foldr (\(p,t) acc -> "#Cons{#Face{" ++ go d p ++ ", " ++ go d t ++ "}, " ++ acc ++ "}") "#Nil" fs ++ ", " ++ go d x ++ ")"
    UnG g          -> "@unglue(" ++ go d g ++ ")"
    Ua a b f g gf fg -> "#UaU{" ++ intercalate ", " (map (go d) [a, b, f, g, gf, fg]) ++ "}"
    Met _ _ _      -> error "HVM4 full: unsolved metavariable (gen) has no value to emit"
    Pri U64_TO_CHAR -> "@u64ToChar"
    Pat _ _ _      -> error "HVM4 full emission: unflattened pattern match"

  -- Pass branch environments after selection, avoiding duplication of a
  -- recursive accumulator across mutually exclusive branches.
  branchMatch :: Int -> Term -> [(String, Int, Term)] -> String
  branchMatch d x arms =
    let env = S.toList (S.unions [freeVars S.empty b | (_,_,b) <- arms])
        arm (tag, arity, body) = tag ++ ": " ++ armBody d arity env body
    in "(λ{" ++ intercalate "; " (map arm arms) ++ "})(" ++ go d x ++ ")"
       ++ concatMap (\n -> "(" ++ n ++ ")") env

  armBody :: Int -> Int -> [Name] -> Term -> String
  armBody d arity env body
    | arity < 0 = "λ&" ++ freshName d ++ ". " ++ armBody (d+1) 0 env body
    | arity > 0 =
        let n = freshName d
            rest = case cut body of
              Lam _ f -> f (Var n d)
              _       -> App body (Var n d)
        in "λ&" ++ n ++ ". " ++ armBody (d+1) (arity-1) env rest
    | otherwise =
        let names = [freshName (d+i) | i <- [0 .. length env - 1]]
            renames = M.fromList (zip env names)
        in concatMap (\n -> "λ&" ++ n ++ ". ") names
           ++ renameEmitted renames (go (d + length env) body)

  -- All emitted binders are globally fresh. Alpha-rename whole identifier
  -- tokens, excluding definition references, constructor tags and characters.
  renameEmitted names [] = []
  renameEmitted names (c:cs)
    | c == '@' || c == '#' = let (n, rest) = span ident cs in c : n ++ renameEmitted names rest
    | c == '\'' = case cs of
        a:'\'':rest -> c:a:'\'':renameEmitted names rest
        _ -> c : renameEmitted names cs
    | ident c = let (ns, rest) = span ident cs
                    n = c:ns
                in M.findWithDefault n n names ++ renameEmitted names rest
    | otherwise = c : renameEmitted names cs
  ident c = isAlphaNum c || c == '_'

  faces d fs = foldr (\(p, u) acc -> "#Cons{#Face{" ++ go d p ++ ", " ++ go d u ++ "}, " ++ acc ++ "}") "#Nil" fs
  psOr h ps = if null ps then replicate (hitArity h) "&{}" else map (go 0) ps
  -- which HIT an eliminator is for: read off its branch names (constructor
  -- names are unique across the book's HITs)
  elimOf bs = case [ (t, h) | (c, _) <- bs, Just (t, h, _) <- [derefCtor book c] ] of
    (r : _) -> Just r
    []      -> Nothing

  appFun d f = case cut f of
    Var _ _ -> go d f
    Ref _   -> go d f
    App _ _ -> go d f
    _       -> "(" ++ go d f ++ ")"

  -- `hcomp(Set, i, <_> A, <k> Q @ k, P @ i)` in the marker variable: the
  -- base line P (still in the marker) and the tube line Q
  compLine :: Term -> Maybe (Term, Term)
  compLine b = case cut b of
    HCm a fs base | Set <- cut a ->
      case [ u | (p, u) <- fs, isMark p ] of
        [u] | not (occursMarker u), all constTube [ u0 | (p, u0) <- fs, not (isMark p) ] -> Just (base, u)
        _ -> Nothing
    _ -> Nothing
  isMark p = case cut p of { Var "__coe_i__" (-1) -> True; _ -> False }
  constTube u = case cut u of
    PLm _ f -> let b = f depMarker in not (occursDep b) && not (occursMarker b)
    _       -> False

  -- A label is a dimension name.  Source labels are explicit, global names:
  -- they are placed in their own region [2^18, 2^19) (name 'a' + three base-64
  -- digits), disjoint from the runtime's fresh names and from parse-time auto
  -- labels, so δ-unfolding never renames them and they never capture.
  label (Loc _ t)       = label t
  label (Val (U64_V v))
    | v < 262144        = 'a' : [ b64 ((fromIntegral v `div` (64 ^ k)) `mod` 64) | k <- [2, 1, 0 :: Int] ]
    | otherwise         = error "HVM4 full: a SUP label must be below 2^18 (the explicit dimension-name region)"
  label _               = error "HVM4 full: a SUP label must be a numeric literal; a symbolic or computed label has no dimension-name region"
  b64 i = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$" !! i

  op2 o = case o of
    ADD -> "+"; SUB -> "-"; MUL -> "*"; DIV -> "/"; MOD -> "%"
    EQL -> "=="; NEQ -> "!="; LST -> "<"; GRT -> ">"; LEQ -> "<="; GEQ -> ">="
    AND -> "&&"; OR -> "||"; XOR -> "^"; SHL -> "<<"; SHR -> ">>"
    POW -> error "HVM4 full: POW is emitted as @pow"

  numTag k = case k of { U64_T -> "U64"; I64_T -> "I64"; F64_T -> "F64"; CHR_T -> "Chr" }


-- Names of the generated runtime functions of a HIT
hitCtorTag, hitPathFn :: Name -> Name -> String
hitCtorTag t c = "C_" ++ hvmName t ++ "_" ++ c
hitPathFn  t c = "P_" ++ hvmName t ++ "_" ++ c

hitElimFn :: Name -> String
hitElimFn t = "E_" ++ hvmName t

-- Per declared HIT, the runtime functions:
--   @P_T_c  = λps. λas. λi1..in. dispatch on the intervals: a literal endpoint
--             reduces to the declared boundary, a symbolic one is applied
--             and the constructor stays canonical (#P_T_c{ps, as, is});
--   @E_T    = λP. λb_c1 .. λb_cn. λx. the eliminator: branches on the
--             constructors, commutes with composition, stuck otherwise.
hitPrelude :: Book -> String
hitPrelude book = unlines (hitCoeDispatch : concatMap one (M.toList (bookHits book)))
  where
    one (t, h) = [ pathFn t c k | (c, k) <- hitCtors h, ctorDim k > 0 ] ++ [ elimFn t h ] ++ coeFns t h

    -- @hitCoe: transport along a HIT line, dispatching on the HIT (reached
    -- from @coeT's default arm when the line yields a #HT_T at the marker)
    hitCoeDispatch = "@hitCoe = λ&L. λ&r. λ&s. λ&x. λ{"
      ++ concat [ "#HT_" ++ hvmName t ++ ": " ++ concatMap (\i -> "λhcq_" ++ hvmName t ++ "_" ++ show i ++ ". ") [1 .. hitArity h]
                  ++ "@X_" ++ hvmName t ++ "(L, r, s, x); "
                | (t, h) <- M.toList (bookHits book) ]
      ++ "λt. #StuckCoe{t, x}}"

    -- @X_T: a constructor rebuilt at the parameters of L(s) (read off the
    -- type value by @HTp_T_k) with every field transported along its own
    -- dependent type line (earlier fields transported to the running
    -- interval first); a canonical cell likewise, re-applied to its
    -- intervals through @P_T_c; an hcomp cell commutes with the transport;
    -- anything else is stuck.  Mirrors Core.WHNF.whnfCoe's HTy case.
    coeFns t h =
      let tn   = hvmName t
          np   = hitArity h
          param k = "@HTp_" ++ tn ++ "_" ++ show k
          paramFns = [ param k ++ " = λ{#HT_" ++ tn ++ ": " ++ concatMap (\i -> "λhtp_" ++ tn ++ "_" ++ show k ++ "_" ++ show i ++ ". ") [1 .. np]
                       ++ "htp_" ++ tn ++ "_" ++ show k ++ "_" ++ show k ++ "; λv. #StuckParam{v}}"
                     | k <- [1 .. np] ]
          newPs = [ param k ++ "(L(s))" | k <- [1 .. np] ]
          arm (c, k) =
            let os = [ "hco_" ++ tn ++ "_" ++ c ++ "_" ++ show i | i <- [1 .. np] ]
                as = [ "hca_" ++ tn ++ "_" ++ c ++ "_" ++ show i | i <- [1 .. ctorNArgs k] ]
                is = [ "hci_" ++ tn ++ "_" ++ c ++ "_" ++ show i | i <- [1 .. ctorDim k] ]
                coerced = [ coeField k c as j "s" (show j) | j <- [0 .. ctorNArgs k - 1] ]
                binds = concatMap (\n -> "λ" ++ n ++ ". ") os ++ concatMap (\n -> "λ&" ++ n ++ ". ") as ++ concatMap (\n -> "λ" ++ n ++ ". ") is
            in if ctorDim k == 0
                 then "#" ++ hitCtorTag t c ++ ": " ++ binds ++ "#" ++ hitCtorTag t c ++ "{" ++ intercalate ", " (newPs ++ coerced) ++ "}; "
                 else "#" ++ hitPathFn t c ++ ": " ++ binds ++ "@" ++ hitPathFn t c ++ "(" ++ intercalate ", " (newPs ++ coerced ++ is) ++ "); "
          -- field j of constructor c transported from r to `to` along its type
          -- line; earlier fields are transported to the running i first (the
          -- interval binder's name records the nesting path, so it is unique)
          coeField k c as j to path =
            let iv = "hcv_" ++ tn ++ "_" ++ c ++ "_" ++ path
            in "@coe(λ&" ++ iv ++ ". " ++ fieldTypeAt k c as j iv path ++ ", r, " ++ to ++ ", " ++ as !! j ++ ")"
          fieldTypeAt k c as j iv path =
            let psAt    = [ Var (param m ++ "(L(" ++ iv ++ "))") 0 | m <- [1 .. np] ]
                earlier = [ Var (coeField k c as m iv (path ++ "_" ++ show m)) 0 | m <- [0 .. j - 1] ]
            in emitFull book (ctorFieldType book k (psAt ++ earlier))
      in paramFns ++
         [ "@X_" ++ tn ++ " = λ&L. λ&r. λ&s. λ{" ++ concatMap arm (hitCtors h)
           ++ "#HCm: λA. λfs. λbase. @hcomp(L(s), @hcTubesCoeLine(L, r, s, fs), @coe(L, r, s, base)); "
           ++ "λv. #StuckCoe{L(s), v}}" ]

    pathFn t c k =
      let np  = hitArity (maybe h0 id (derefHit book t))
          h0  = HitDecl 0 Set []
          pns = [ freshName (1000 + i) | i <- [1 .. np] ]
          ans = [ freshName (2000 + i) | i <- [1 .. ctorNArgs k] ]
          ins = [ freshName (3000 + i) | i <- [1 .. ctorDim k] ]
          pvs = [ Var n 0 | n <- pns ]
          avs = [ Var n 0 | n <- ans ]
          ivs = [ Var n 0 | n <- ins ]
          ty0 = maybe (ctorType k) id (hitCtorTypeAt book t c pvs avs [])
          stuckWith cur = "#" ++ hitPathFn t c ++ "{" ++ intercalate ", " (pns ++ ans ++ cur) ++ "}"
          -- dispatch on the j-th interval; `ty` is the constructor's type at the
          -- intervals already decided; `cur` the current binder names (an
          -- interval decided symbolic is rebound in the default arm)
          disp ty j cur
            | j >= ctorDim k = stuckWith cur
            | otherwise = case force book ty of
                Pth l a b ->
                  let rest    = [ Var n 0 | n <- drop (j + 1) cur ]
                      endAt e = emitFull book (foldl PAp e rest)
                      iv      = cur !! j
                      iv'     = freshName (3100 + j)
                      cur'    = take j cur ++ [iv'] ++ drop (j + 1) cur
                  in "(λ{#I0: " ++ endAt a ++ "; #I1: " ++ endAt b ++ "; λ&" ++ iv' ++ ". "
                       ++ disp (App l (Var iv' 0)) (j + 1) cur' ++ "})(" ++ iv ++ ")"
                _ -> stuckWith cur
      in "@" ++ hitPathFn t c ++ " = " ++ concatMap (\n -> "λ&" ++ n ++ ". ") (pns ++ ans ++ ins) ++ disp ty0 0 ins

    elimFn t h =
      let ctors = hitCtors h
          bns   = [ (c, freshName (4000 + i)) | ((c, _), i) <- zip ctors [1 ..] ]
          pn    = freshName 5001
          xn    = freshName 5002
          recur v = "@" ++ hitElimFn t ++ "(" ++ intercalate ", " (pn : map snd bns ++ [v]) ++ ")"
          arm (c, k) =
            let b   = maybe "&{}" id (lookup c bns)
                ps  = [ freshName (6000 + i) | i <- [1 .. hitArity h] ]
                as  = [ freshName (7000 + i) | i <- [1 .. ctorNArgs k] ]
                is  = [ freshName (8000 + i) | i <- [1 .. ctorDim k] ]
                tag = if ctorDim k == 0 then hitCtorTag t c else hitPathFn t c
                app = foldl (\acc i -> "@pathAt(" ++ acc ++ ", " ++ i ++ ")") (b ++ concatMap (\a -> "(" ++ a ++ ")") as) is
            in "#" ++ tag ++ ": " ++ concatMap (\n -> "λ" ++ n ++ ". ") (ps ++ as ++ is) ++ app
          an = freshName 9001; fn = freshName 9002; bn = freshName 9003
          hcm = "#HCm: λ&" ++ an ++ ". λ&" ++ fn ++ ". λ&" ++ bn ++ ". @compAt(λ&j. " ++ pn ++ "(@hfillAt(" ++ an ++ ", " ++ fn ++ ", " ++ bn ++ ", j)), @hcTubesMap(λu. " ++ recur "u" ++ ", " ++ fn ++ "), " ++ recur bn ++ ")"
          dflt = "λv. #HEl{v}"
      in "@" ++ hitElimFn t ++ " = λ&" ++ pn ++ ". " ++ concatMap (\(_, b) -> "λ&" ++ b ++ ". ") bns ++ "λ" ++ xn ++ ". (λ{"
           ++ intercalate "; " (map arm ctors ++ [hcm, dflt]) ++ "})(" ++ xn ++ ")"
