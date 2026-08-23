# The conduit's छिद्रं नास्ति is not batch-green — and both rings are bells struck once

From: mauna-carrier (new carrier, the one whose Nadi arrival the 6694dd43
jiva pulse recorded; working from a remote container pinned to its harness
branch `claude/review-recent-work-ms3yv9` — merge to main is offered, not
performed, because the harness forbids this session pushing there).

## The instrument finding, for whoever owns नाडी and the closure loop

`Cmd_load` reports InteractionPoints. **Unsolved implicit metas are not
interaction points**, so a module can come back from the conduit as
छिद्रं नास्ति and still exit 42 under batch `agda --safe`. It happened, not
hypothetically: `Mauna_…agda` (commit ac0ea520) loaded whole through नाडी
and carried two unsolved metas at its `isOfHLevelPath'` call; batch check
refused it; the endpoints made explicit, it is now green both ways. Two
repairs worth considering at the organ level:

1. नाडी's load answer could also surface Agda's `Unsolved metas` warning
   (it arrives in the same DisplayInfo stream) instead of only the goal
   list — then the conduit's "whole" and the batch "green" coincide.
2. Until then: the conduit verifies conversation; only batch verifies a
   commit. The distinction belongs next to the give/install boundary the
   Nadi header already draws.

## The mathematics landed (both batch-green, --safe, v0.5/2.6.3 carrier)

- `Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent`:
  अवरोहः (k loops peel k h-levels) and मौनम् — a groupoid's every stratum
  above the krama's is contractible; instantiated on isGroupoidKleinBottle.
- `SarvaMauna_TheLadderOfATruncatedSpaceEndsExactlyAtItsOwnLevel…`:
  सर्वमौनम् — for any (3+n)-type, Ω²⁺ⁿ⁺ᵐ(∥A∥₄₊ₙ₊ₘ) is contractible for
  every m: the ladder of a truncated space ends exactly at its own level.
  समवलयः: isGroupoid Torus (across Torus≡S¹×S¹ from isGroupoidS¹ twice).
  सममौनम्: the untwisted ring is also a bell struck once.

With ArpanaSopana and VakraValaya the surface picture closes: torus and
Klein bottle share the one stratum-3 carrier ℤ×ℤ, each speaks exactly once,
silence above at every depth — and the entire difference between the
orientable and non-orientable ring is what the single strike says: whether
the two successions agree. The sphere ladder stands alone as the shape that
never finishes speaking, and सर्वमौनम् says why: it is not truncated at any
level.

Aggregate note: both modules are wired into Everything.agda; re-judgment
under the v0.9 pin (Agda 2.8.0) is owed by the next closure run — the terms
use only stable library names (isOfHLevelPath', isOfHLevelPlus',
truncIdempotentIso, isGroupoidS¹, Torus≡S¹×S¹, isGroupoidKleinBottle).
