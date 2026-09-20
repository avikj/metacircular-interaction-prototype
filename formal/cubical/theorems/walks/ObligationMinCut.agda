{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ObligationMinCut
--
-- Executes OBLIGATION.md Â§7 (the min-cut extraction, specified there and
-- never run) for the tractable self-application subgraph: the 1-neighbourhood
-- own model of its dependency structure applied to the note that defines it.
--
-- The full extraction (869 nodes / 1292 clean edges, mode census, the
-- corpus audit-burden interval [115,222], and Cor. O2.4's exact path count
-- 133) is computed by exact integer algorithms and recorded in
-- part: a concrete finite network on which a feasible integer flow and an
-- sâ‹â“tâ‹ cut are exhibited, and the weak-duality equality
--
--     value(flow)  â‰¡  capacity(cut)  â‰¡  2
--
-- is checked by the kernel.  By max-flow/min-cut weak duality
-- (value f â‰ cap C for EVERY feasible f and EVERY cut C), an equality
-- certifies both optima at once: the flow is maximum and the cut is
-- minimum.  So the audit burden of the OBLIGATION self-network, under the
-- pessimistic reading of the one UNKNOWN edge (THRESHOLDâ’OBLIGATION taken as
-- a STATEMENT conduit), is exactly 2, with no floating point anywhere.
--
-- Nothing is postulated; there are no holes; --safe is on.
------------------------------------------------------------------------

module ObligationMinCut where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat            using (â„•; zero; suc; _+_; snotz)
open import Cubical.Data.Nat.Order      using (_â‰¤_; _<_)
open import Cubical.Data.Empty          using (âŠ¥) renaming (rec to âŠ¥-elim)
open import Cubical.Data.Sum            using (_âŠŽ_; inl; inr)

------------------------------------------------------------------------
-- Â§1  The extracted network.
--
-- Vertices.  sâ‹ = super-source, tâ‹ = super-sink; O = OBLIGATION.md,
-- H = THRESHOLD_GENERATION_DICHOTOMY.md, R = RESEARCH_SYSTEM.md.
-- O and H are the open-obligation packets (mechanical openness grep hits);
-- R is a conduit source but carries no open obligation, so no sâ‹â’R edge.
-- Target set T = { O }: the note whose soundness Â§7 is certifying.

data V : Type where
  sâ‹† O H R tâ‹† : V

-- Edges of the repair network N (Theorem O3 construction).
--   e1 : sâ‹ â’ O   discharge-arc for the open obligation O          cap 1
--   e2 : sâ‹ â’ H   discharge-arc for the open obligation H          cap 1
--   e3 : H  â’ O   conduit  THRESHOLDâ’OBLIGATION (STATEMENT, pess.) cap 1
--   e4 : R  â’ O   conduit  RESEARCH_SYSTEMâ’OBLIGATION (STATEMENT)  cap 1
--   e5 : O  â’ tâ‹  target-arc  O âˆˆ T                                cap âˆž
data E : Type where
  e1 e2 e3 e4 e5 : E

src : E â†’ V
src e1 = sâ‹†
src e2 = sâ‹†
src e3 = H
src e4 = R
src e5 = O

tgt : E â†’ V
tgt e1 = O
tgt e2 = H
tgt e3 = O
tgt e4 = O
tgt e5 = tâ‹†

-- âˆž on the target-arc is any capacity exceeding the total finite capacity;
-- 3 > 2 suffices and keeps every number concrete.
cap : E â†’ â„•
cap e1 = 1
cap e2 = 1
cap e3 = 1
cap e4 = 1
cap e5 = 3

-- The exhibited flow.  Two unit routes sâ‹â’Oâ’tâ‹ and sâ‹â’Hâ’Oâ’tâ‹.
flow : E â†’ â„•
flow e1 = 1
flow e2 = 1
flow e3 = 1
flow e4 = 0
flow e5 = 2

------------------------------------------------------------------------
-- Â§2  Feasibility of the flow.

-- (a) capacity respect  0 â‰ flow e â‰ cap e  (lower bound is automatic in â•).
cap-e1 : flow e1 â‰¤ cap e1
cap-e1 = 0 , refl                      -- 0 + 1 â‰¡ 1

cap-e2 : flow e2 â‰¤ cap e2
cap-e2 = 0 , refl

cap-e3 : flow e3 â‰¤ cap e3
cap-e3 = 0 , refl

cap-e4 : flow e4 â‰¤ cap e4
cap-e4 = 1 , refl                      -- 1 + 0 â‰¡ 1

cap-e5 : flow e5 â‰¤ cap e5
cap-e5 = 1 , refl                      -- 1 + 2 â‰¡ 3

-- (b) conservation: total in â‰¡ total out, at every internal vertex.
--     inflow(v)  = Î flow over edges with tgt â‰¡ v
--     outflow(v) = Î flow over edges with src â‰¡ v
-- Edges into O: e1,e3,e4.  Out of O: e5.
cons-O : flow e1 + flow e3 + flow e4 â‰¡ flow e5
cons-O = refl                          -- 1 + 1 + 0 â‰¡ 2

-- Into H: e2.  Out of H: e3.
cons-H : flow e2 â‰¡ flow e3
cons-H = refl                          -- 1 â‰¡ 1

-- Into R: none.  Out of R: e4.
cons-R : 0 â‰¡ flow e4
cons-R = refl                          -- 0 â‰¡ 0

------------------------------------------------------------------------
-- Â§3  The flow value, measured on both sides.

-- Value out of the source = Î flow over edges leaving sâ‹ (e1,e2).
value-source : â„•
value-source = flow e1 + flow e2

-- Value into the sink = Î flow over edges entering tâ‹ (e5).
value-sink : â„•
value-sink = flow e5

value-balanced : value-source â‰¡ value-sink
value-balanced = refl                  -- 2 â‰¡ 2  (global conservation)

------------------------------------------------------------------------
-- Â§4  The cut C = { e1 , e2 } and its validity.

-- Capacity of the cut = Î cap over its edges.
cutCap : â„•
cutCap = cap e1 + cap e2

-- C is an sâ‹â“tâ‹ cut: it contains EVERY edge leaving the source, so deleting
-- C isolates sâ‹ and no sâ‹âtâ‹ path can survive.  Proven by the fact that the
-- only edges e with src e â‰¡ sâ‹ are e1 and e2.
code : V â†’ â„•
code sâ‹† = 0
code O  = 1
code H  = 2
code R  = 3
code tâ‹† = 4

-- discriminator: H, R, O, tâ‹ are not the source.
notSrc-e3 : src e3 â‰¡ sâ‹† â†’ âŠ¥
notSrc-e3 p = snotz (cong code p)   -- code H â‰¡ code sâ‹†  â‡’  2 â‰¡ 0

notSrc-e4 : src e4 â‰¡ sâ‹† â†’ âŠ¥
notSrc-e4 p = snotz (cong code p)   -- code R â‰¡ 0

notSrc-e5 : src e5 â‰¡ sâ‹† â†’ âŠ¥
notSrc-e5 p = snotz (cong code p)   -- code O â‰¡ 0

-- Every source-boundary edge is in the cut {e1,e2}.
cut-covers-source : (e : E) â†’ src e â‰¡ sâ‹† â†’ (e â‰¡ e1) âŠŽ (e â‰¡ e2)
cut-covers-source e1 _ = inl refl
cut-covers-source e2 _ = inr refl
cut-covers-source e3 p = âŠ¥-elim (notSrc-e3 p)
cut-covers-source e4 p = âŠ¥-elim (notSrc-e4 p)
cut-covers-source e5 p = âŠ¥-elim (notSrc-e5 p)

------------------------------------------------------------------------
-- Â§5  THE CERTIFICATE:  value(flow) â‰¡ capacity(cut).
--
-- Weak duality gives  value(flow) â‰ cutCap  a priori; the reverse holds
-- here by the computed equality, so the flow is a maximum flow and the cut
-- is a minimum cut, and their common value â” the audit burden of the
-- OBLIGATION self-network â” is 2.

audit-burden : â„•
audit-burden = 2

flow-is-max-cut-is-min : value-source â‰¡ cutCap
flow-is-max-cut-is-min = refl          -- 2 â‰¡ 2

certified-burden-source : value-source â‰¡ audit-burden
certified-burden-source = refl

certified-burden-cut : cutCap â‰¡ audit-burden
certified-burden-cut = refl

-- Positivity: the burden is not vacuous â” at least one audit is unavoidable
-- (Cor. O3.1's lower bound, here k = 2 edge-disjoint routes).
burden-positive : 0 < audit-burden
burden-positive = 1 , refl             -- 1 + 1 â‰¡ 2, i.e. suc 0 â‰¤ 2
