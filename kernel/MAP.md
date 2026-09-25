# The kernel, as one algorithm on one data structure

This file is the program. Each section is written at the precision of the
code it becomes; the code replaces the pseudocode in place, section by
section, and the section is done when its tests pass. There is no other
design document. The mathematics each line applies is named beside it
(`One §n`, a corpus module, or a measurement); a line that needs a decision
the mathematics does not make is a defect upstream, not a choice here.

Surface syntax is Bend2's, unchanged. The test oracle for values is Bend2's
normaliser output, recorded per program (`tools/regress/`). HVM4 is not in
the loop; the interaction count is this kernel's own metric.

## 0. The problem, in one sentence

Given a typed point `(A, a) : Σ (A : Set ℓ). A` presented as a cell complex
over bound dimension names, reduce every demanded active pair until none
remains, retaining every fibre, and let the same reduction check the point,
answer questions on it, and install proven rules into itself.

## 1. Data: the heap of cells

    word    := u64
    Port    := word                       -- tag:8 | ext:24 | loc:32
    Loc     := u32 index into HEAP        -- HEAP : word[]
    Name    := (frame : Loc, index : u16) -- a BOUND dimension name (§2 below)
    Level   := u8                         -- universe level, forced tower (Universal)

A node is a contiguous block of words at `loc`. `tag` selects the kind and
the block shape. Every kind is the one cell in a polarity or with a
coordinate; the list is the closed set of shapes the corpus emits.

    -- points and maps (polarities of one cell)
    VAR  slot                              -- a coordinate of a frame
    LAM  code frame                        -- a closure: static body + frame (§4)
    APP  fun arg
    REF  id                                -- a definition's NAME (a value)
    ERA                                    -- the one address of loss (One §4)
    -- lines (both answer the face map; one notion of dimension)
    SUP  name a b                          -- a 1-cell in `name` given by its faces
    PLM  name body                         -- a 1-cell in `name` given by a formula
    FCE  name side target                  -- a pending face map  name := side
    -- the interval (free De Morgan algebra on names, CCHM site)
    I0 | I1 | IVAR name | IOP op a b | INOT a   -- kept in canonical DNF (§3.4)
    -- data
    CTR  id arity fields…  |  NUM gmp  |  OP2 op a b
    -- types are cells (a type is a point of Set ℓ)
    SET ℓ | PI dom cod | SIG fst snd | PATH ty a b | EQL ty a b
    NAT | BOOL | UNIT | EMPTY | LIST elem | ENUM syms | NUMTY kind
    HTY id params…                         -- a declared HIT's type former
    GLU base faces…                        -- Glue base [(φ, T, e)…]
    -- Kan (One §5 potential; Adhisthana: two primitives, comp derived)
    TRP  line r s x                        -- transp across a line of types
    HCM  type faces… base                  -- hcomp within a type; stuck = canonical
    GLUE base faces… a  |  UNGLUE g
    HCTR id params fields dims…            -- HIT point/path constructor cell
    HELIM id motive branches… x            -- HIT eliminator
    -- judgments kept for verify (§7)
    CHK  type term                         -- an annotation; projects to term at run
    -- the interaction (One §7)
    ASK  q k                               -- a free port: a question and its continuation

`ext` holds arity, opcode, level, or side. Names are never integers: a
`Name` is a reference to the binder (frame slot) that introduced the
dimension, so two instances of one definition never share a name, and
capture is impossible by construction (the label-capture finding).

    BOOK : StaticTerm[]      -- immutable lowered syntax per definition, de Bruijn levels
    TBOOK: StaticTerm[]      -- its checked type, same form (the @T of the PR)
    RULES: Rule[]            -- the interaction table; install appends (§8)
    TRACE: (rule, name, name)[]  -- receipts; ITRS = length (§9)

## 2. Frames, coordinates, descent (sharing is One §1 graph≃dom, §3, ledger C)

    Frame := { parent : Loc, depth : u16, dim : DimWord, slots : Coord[] }
    Coord := word                          -- a lazy term word; forced once, written back

A closure `LAM code frame` opens by extending a frame with one slot: β is
`frame' = frame ++ [arg]`, the lambda untouched. A variable is `VAR slot`;
forcing it reduces the slot to weak head and writes the head back, so a
determined datum is one point and every use is that point.

Descent (`book_descent`, once per definition at load): every maximal
subterm independent of a binder is bound just outside that binder as a let
slot of the enclosing frame; closed subterms at the top of the definition.
Work independent of `x` is a coordinate of the closure, computed at most
once for all applications (C2); nothing coarser is lawful (C1).

A frame carries `dim`: the faces already taken on its dimensions. A closure
taken on side ε of name `i` is the same closure with `dim` extended by
`i := ε`; its slots are projected lazily by the same face map.

A generic element (the checker's fresh variable for a binder) is a coordinate
of that binder's frame, never a counter name.

## 3. The algorithm: demanded interaction

    reduce(root):
      DEMAND := [root]                       -- One §7: a redex fires when asked
      loop:
        pop a demanded port p (the redex bag; any order, Lafont locality)
        h := weak_head(p)                    -- follow VAR/REF/FCE to a node
        if h is a value (LAM, SUP, PLM, CTR, NUM, type, stuck): return it
        (rule, partner) := dispatch(h)       -- the principal port's active pair
        apply rule; append (rule, names) to TRACE
        push the ports the rule made demanded

`dispatch` is a two-tag switch on `(tag(h), tag(weak_head(principal(h))))`.
Only active pairs fire; a node whose principal port faces a variable, a
name, or a stuck cell is its own normal form. Demand is monotone: a fibre is
retained, never dropped, so no step removes a demand already made; hence the
one-step diamond holds for this relation and every schedule reaches the
demanded normal form in the same number of interactions
(`InteractionGeodesic`, the retention reading in BOTTOM_UP §13).

### 3.1 The face map (the whole DUP/SUP algebra)

`FCE i ε t` applied to `t`:

    SUP i a b        → the face: a if ε=0, b if ε=1           -- annihilate, 0 words
    PLM i body       → body[i := ε]  (substitution on names)   -- annihilate
    SUP j a b, j≠i   → SUP j (FCE i ε a) (FCE i ε b)           -- commute (δᵢδⱼ = δⱼδᵢ)
    PLM j body, j≠i  → PLM j (FCE i ε body)                    -- commute
    LAM code fr      → LAM code (fr with dim += i:=ε)          -- push under the binder
    CTR/type/NUM     → if i ∉ names(t): t itself (share)       -- the fibre law's free retention
                       else the face pushed to each field
    IVAR i           → ε ;  IOP/INOT → recompute DNF (§3.4)
    stuck / VAR      → stays FCE (a normal form until the target moves)

Two instances of one definition never meet at the same name, so the
annihilate case is exactly "branch projection in an already shared fibre"
(DIRECTIONAL_SYNTHESIS): it commutes only because the name names that fibre.

### 3.2 Application

    APP (LAM code fr) x        → open: run code in fr ++ [x]               -- β
    APP (SUP i f g) x          → SUP i (APP f (FCE i 0 x)) (APP g (FCE i 1 x))
    APP (PLM i body) r         → body[i := r]   (path application; r an interval)
    APP (REF id) x…            → the call step (§4)
    APP (HCTR…)  / APP stuck   → stuck spine (normal)

### 3.3 Erase

    ERA meets a node at its principal port → remove it; ERA onto each aux port.

Erase fires only where a consumer projects a typed point and forgets its
fibre (printing a value, `fst`, a `Bool → Unit`). Inside a run nothing is
erased; an unreferenced fibre is retained (free) and reclaimed at the
projection, where the erasures are counted as the cost of the loss.

### 3.4 The interval

Interval terms are kept in the free De Morgan algebra's normal form: an
antichain of sorted cubes of literals `i` / `~i` over name generators
(`REMAINING.md` §C; `Visranti` for nf-as-invariant). Operations recompute
the form; equal intervals are structurally equal; `i ∧ ~i` is not `I0`.
A face `φ` is true iff its form is `I1`, false iff `I0`, else undecided.

### 3.5 Fill: transp and hcomp (the only rules that consult the type)

    TRP L r s x:
      if r ≡ s (interval nf)                 → x
      k := fresh bound name; T := weak_head(L applied at IVAR k)
      if k ∉ names(T)                        → x            -- regularity = occurs check
      PI A B      → LAM y. TRP (B along k) r s (APP x (TRP A s r y))
      SIG A B     → (TRP A r s (fst x), TRP (B over the filled first) r s (snd x))
      PATH A a b  → the hcomp-conjugation square (RUNTIME_FULL.md)
      GLU …       → unglue at r, transport the base, correct along the fibre
                    centre on each face live at s, glue back (GLUE.md Kan rule 1)
      HTY id ps   → push into constructors, each field along its own line (HITS.md)
      SET ℓ       → TRP along a universe line: ua ⇒ f / g; composite ⇒ sequential
      SUP j A B   → commute: SUP j (TRP …A…) (TRP …B…) with x face-mapped at j
      NAT/BOOL/… (rigid) → x
      stuck       → TRP stays (normal)

    HCM A faces base:
      some face true                         → that tube at I1
      all faces false                        → base
      A = PI / SIG / PATH / NAT / LIST / discrete → the type-directed rule (REMAINING §B)
      A = SET ℓ                              → GLU base [φ ↦ (T@I1, transpEquiv T)]
      A = GLU …                              → the CCHM Glue composition
      A = HTY …                              → canonical: HCM stays (a cell of the HIT)
      A neutral                              → stuck (normal)
    comp := hcomp after transp; hfill := the filler. Neither is primitive.

`ua e` is the Glue line `<i> GLU B [(~i, A, e), (i, B, id)]`; it is notation
and lowers to GLU, so there is one univalence.

## 4. The static book and the call step

    call(REF id, args…):
      walk the definition's CASE TREE on the static term, binding each
      argument in a fresh frame slot, forcing scrutinees in place (a computed
      scrutinee is a coordinate, forced once), following the definition's own
      descent lets in head position;
      if the walk reaches a leaf  → continue with the frame it built
      if a scrutinee is neutral, or arguments run out → the call is NORMAL:
        a spine headed by REF id, compared by identity (REF === REF by id)

δ (unfolding) is not counted: definitional unfolding is `refl`, transport is
free (One §4). A stuck call's normal form is canonical and finite on open
terms (the atomic case tree), which is what makes conversion decidable by
two normalisations and a `refl` (`Visranti`). A partial call keeps the
frame its walk built; applying it resumes the walk.

## 5. The host: surface to cells, and the typed point

    lower(file):
      parse Bend2 surface (grammar of Bend2 Parse.hs, unchanged)
      elaborate bare HIT constructor parameters from the goal (Core.Check.elabFills)
      for each definition: BOOK[id] := static term, TBOOK[id] := static type
      root := CTR Pair [TBOOK[main], BOOK[main]]        -- (A, a) : Σ A. A

Nothing the checker needs is erased: annotations stay as CHK, HIT
parameters stay, enum symbols stay as `#s_name`, numeric kinds, equality
endpoints, both ua coherences stay. Unsupported operations are refused
(`refuse, never miscompile`).

    run(file):      reduce(root); print the projected value (erasures counted here)
    interact(file): reduce(root) keeping the heap; per line:
                      q := lower(line) as a definition (own names)
                      root := reduce(APP present [root, q])         -- One §1 present, §6 carried
                      print root; print ITRS for this question
    a free port ASK q k is the general form: reduction stalls at it, the
    world supplies a section of q, k continues (One §7).

## 6. Receipts and the census

    on every rule: ITRS += 1; TRACE.push(rule, name₁, name₂)
    census(f, b) over a fibre: fold TRACE / walk the retained fibre
      रिक्तम् (empty) | एकम् (one) | बहु (many)          -- three-valued, never two

## 7. Checking is `verify` (One §14), on the same loop

    check(id):
      t := BOOK[id] viewed (never evaluated); A := reduce(TBOOK[id])
      infer/check structurally on the static term with a context of
      coordinates (each binder reflects one generic element, η-long at its
      type: Π → λ of the reflected application, Σ → pair of reflected
      projections, PATH → a line whose faces are the endpoints)
      conversion(u, v) := u and v are the same coordinate, or their weak
        heads agree and their fields convert (canonical points; no primitive
        hides the decision)
      a mismatch is a residual cell: the non-fillable boundary IS the error
      result ∈ { ✓, mismatch, cannot-infer }

Every ✓/✗ must agree with Bend2's checker over the corpus including every
`*_mustfail`; recorded Core deviations (syntactic rewrite on a non-variable
scrutinee, substituted lets, regularity by normalisation) are not
reproduced.

## 8. Install (abstracts 43, 54; Alopa)

    install(d : Derivation lhs rhs):
      RULES.push({ lhs pattern, rhs, certificate := d })   -- the certificate is a field
      extract(install d) ≡ d by construction
    an installed rule is dispatched like any other; its cost is a row.

## 9. Parallelism

The redex bag is the only scheduler. Two demanded active pairs are disjoint;
any interleaving gives the same normal form in the same count. Sequential
execution is one schedule. Test: ITRS invariant across schedules.

## 10. Tests and proofs (what decides)

1. Values: every corpus `.bend` with a `main`, value equal to the recorded
   Bend2 normal form. Superposed results compared branch by branch.
2. Squares: one `.bend` per rule stating its equation definitionally
   (`kan.bend`, `hit_hcomp.bend`, `supline.bend`, `interval.bend` are the
   existing shape); the file passes only if the rule fires.
3. Must-fails: every registered probe rejected, nothing else.
4. Capture probes: `two∘two` = 4, the triple = 16, cap4 = 4.
5. Sharing regimes (ratios, not absolutes): a transport consumed k times
   costs one transport plus k small increments; one line over N values is
   sublinear in N; N different lines are a constant factor over separate.
6. Checker differential per definition against Bend2's checker.
7. Schedules: ITRS identical under the sequential and the parallel bag.
8. Proofs: each rule's commuting square and cost recurrence is a corpus
   lemma named at the rule (the runtime-correspondence method of
   DIRECTIONAL_SYNTHESIS); the machine's soundness under install is Alopa's
   form, a certificate carried as a field.

## 11. Files

    kernel/cell.h     the word layout, tags, Name, Frame, Rule
    kernel/cell.c     §§1–4, 6, 8, 9: heap, frames, descent, reduce, rules, trace
    kernel/lower.c    §5: Bend2 grammar → BOOK/TBOOK, elaboration, refusals
    kernel/verify.c   §7
    kernel/main.c     run | interact | check
    kernel/test.sh    §10 over collab/bend2-interactive-cubical/*.bend and port/
