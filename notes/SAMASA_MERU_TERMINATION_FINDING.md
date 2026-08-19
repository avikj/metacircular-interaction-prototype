# The general samāsa-meru: a termination obstruction, and the two honest routes

**Status — RESOLVED.** The obstruction below is now closed: `SamasaMeru.agda`
carries the full general {1,L}-meru — generator, recurrence a(m)=a(m−1)+a(m−L),
soundness, and completeness — kernel-checked `--cubical --safe`, no holes, in
the Jiva closure. The resolution is route (2) below (Nārāyaṇa's table method,
here as a fuel-threaded `go` recursing structurally on fuel), with a
fuel-invariance lemma (`canon`) supplying what the strip could not. The
obstruction and the two routes are kept as the record of how it was closed.
Only the arbitrary-part-set meru (three or more part sizes) remains open.

## The object

`Narayana.agda` leaves *avaktavya* in its header the general **samāsa-meru** —
Nārāyaṇa Paṇḍita's *samāsa-bhāvanā* (Gaṇitakaumudī, 1356) as a family: the
{1,L}-compositions for L = 2+j, of which Virahāṅka's {1,2} (`Matramerus`, j=0)
and Nārāyaṇa's {1,3} (`Narayana`, j=1) are two members, with recurrence
a(m) = a(m−1) + a(m−L). Retiring that avaktavya means a *checked, generative*
construction — one that still reduces by `refl`, because definitional
computation is the philosophical content (generation over decision), not an
implementation detail.

## The obstruction (found by construction)

The natural checkless enumeration threads a **structural strip** — peel L
successors off the total, then emanate the rest:

```
सर्गः (suc m) = map (short ∷_) (सर्गः m) ++ दीर्घ-भाग (suc m)
दीर्घ-भाग t   = अपाकरणम् t (suc (suc j))            -- strip L = 2+j
अपाकरणम् t       zero    = map (long ∷_) (सर्गः t)   -- base: emanate the remainder
अपाकरणम् zero    (suc r) = []
अपाकरणम् (suc t) (suc r) = अपाकरणम् t r              -- peel one, decreasing
```

Agda's **size-change termination** checker rejects this. The strip *does*
decrease at runtime — entering `अपाकरणम्` with peel-count `suc (suc j)` forces
at least one `(suc t)(suc r)` step before the base clause can fire, so `सर्गः`
is always re-entered on a strictly smaller total. But SCT reasons over the
abstract call graph, where the path

```
सर्गः → दीर्घ-भाग → अपाकरणम्(base) → सर्गः
```

composes three size-preserving (`=`) edges with **no** strict decrease, because
the base edge `अपाकरणम् t zero → सर्गः t` is analysed for arbitrary `t`,
disconnected from the peels that made `t` small. SCT is sound but incomplete;
this family sits in its incompleteness gap. Reordering the strip's arguments
and inlining `L` (both tried) do not close it — the abstract no-decrease path
survives either way.

Note this is *not* a defect of the {1,3} case: `Narayana.agda` checks, because
there L = 3 is fully concrete, so `त्रि-सर्गः` pattern-matches `suc (suc n)`
and every `सर्गः` re-entry is on a syntactic subterm. The obstruction is
exactly the step from a *fixed* L to a *symbolic* one.

## Two honest routes (neither taken yet)

1. **Well-founded recursion** on the total. Terminates trivially — and is
   **rejected on philosophical grounds**: WF recursors do not reduce
   definitionally, so `length (सर्गः 0 5) ≡ 8` would no longer hold by `refl`.
   That discards the generation-reduces content the whole corpus is built on.
   A checked theorem that does not *compute* is the wrong shape here.

2. **The window (परम्परा) construction** — and this is Nārāyaṇa's *actual*
   method: he kept a running table. Build, by structural recursion on m, the
   history `परम्परा m` holding `सर्गः 0 … सर्गः m`; the long branch reads
   `सर्गः (suc m ∸ L)` as a **lookup into the already-built history**, which is
   structural and reduces by `refl`. Cost: `Vec`/`Fin` lookups with `∸` and a
   bounds argument, and the recurrence/soundness/completeness proofs carry a
   window-indexing invariant. This is the route that keeps both the kernel and
   the computation, and it is the historically faithful one. It is the next
   increment.

## What stands

`Narayana.agda` (the {1,3} case, kernel-checked) and `Matramerus.agda` (the
{1,2} case) both stand. The *unification* of them into one checked generative
family is deferred to the window construction, with the obstruction above
recorded so the next attempt does not re-discover it. The general
arbitrary-part-set meru (three or more sizes) remains a broader avaktavya
beyond even this.
