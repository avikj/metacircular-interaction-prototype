# Two independent implementations of one design, and which one is better

Filed by Weaver, 2026-08-12. Written because the integration branch is the
only place both exist, so the comparison is not available anywhere else.

## The convergence

`machinery/natural_crystal.py` (fleet, 701 lines) and `runtime/` (this branch,
~45,000 lines across nine modules) were built independently, in the same
session, without reading each other. They implement the same loop:

| natural_crystal | runtime | the shared idea |
|---|---|---|
| indistinguishable fibers | `distinguish/` coarsest sufficient quotient | join states no future experiment separates |
| shortest experiment revealing a distinction | collision → minimal separating channel | a failed compression names its own repair |
| `learned-1` installed, then "same meaning, shorter path" | `crystallize/` 7-gate lemma install | a proved relation becomes a cheaper route |
| frontier returned when the horizon is not closed | `§4` reachability discipline | a prefix must never be passed off as the whole |
| binary divisibility compiled to remainder states | `curriculum/`, `DIGIT_CRYSTAL` | positional arithmetic as an automaton on a quotient |

Two independent arrivals at one design is the strongest evidence either
artifact offers, and neither author could see it. That is the whole value of
holding both.

## Which is better, by this corpus's own criterion

The seed is.

`CRYSTAL.md` §5 and `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §3 both say a strong
result should **compress the interior** while widening the frontier. By that
standard 701 lines that demonstrate generation → observation → distinction →
installed shortcut → frontier, and print the compiled divisibility automaton,
beat 45,000 lines that demonstrate the same loop with more apparatus.

What the larger system has that the seed does not: a proof-relevant e-graph
with retraction, kernel-checked edges with a stated trust boundary, null
controls separating knowledge from caching, and measured scaling with its
crossover found and then removed. Those are real and they are the reason its
claims are checkable rather than merely demonstrated.

What the seed has that the larger system does not: someone can read it.

Both matter, and the honest ordering is that the seed is the better *artifact*
and the runtime is the better *evidence*. Where they disagree about what to
build next, the seed's economy should win, because the corpus's own selection
rule prefers the interior compressed — and 45,000 lines is an interior that has
not been.

## The action this implies

Not a merge of the code. The correct move is the one neither lane can make
alone: take the runtime's checked apparatus — kernel edges, null controls,
retraction — and ask which of it survives being expressed at the seed's size.
Anything that does not survive is apparatus, not content.

## The test, run

`machinery/seed_criterion.py` (227 lines) reproduces the runtime's headline —
mined lemma, checked by an independent decision procedure, **1 step versus 3**
on a held-out problem, with a null control at 3 and answers decided rather
than sampled. So the *claim* compresses by a factor of ~200.

Three things the compression established, none of them predicted:

1. **One thing had to be added back**: a preference for the mined rule over the
   axioms. Without it the lemma is inert — distributivity fires at the root
   first and the independent problem still costs 3 steps. That preference is
   the smallest possible stand-in for cost-based route selection, which is
   exactly what the runtime buys with Pareto extraction over an e-graph. It is
   the one piece that could not be dropped.
2. **Two experiment-design defects surfaced, both mine.** Training on
   $(x+y)^2$ and $(x+2)^2$ shares the literal $x$ in one slot, so the least
   general generalisation keeps it and the lemma never matches — too little
   variation over-specialises. And associativity of $*$ is not a null control
   here, because it fires on the expanded terms; a null that rewrites is not
   null. Both were caught only by the small version failing, twice, visibly.
3. **What genuinely does not compress**: the proof-relevant e-graph and its
   retraction, typed non-conflated edges, dependency-cone invalidation, the
   stated trust boundary, and e-matching against e-classes rather than terms —
   which is where the runtime's leverage actually came from, since 39 of 44
   matches there had no stored realisation. None of that is apparatus; each
   buys a claim the small file cannot make. What the exercise shows is that
   the *headline* needed none of it.
