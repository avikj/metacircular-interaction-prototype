{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- JabrLane — a gate for modules whose named source tradition is the
-- Arabic algebraic one (al-Khwārizmī, al-Karajī, al-Samawʾal).
--
-- ON THE NAME.  *al-jabr* is al-Khwārizmī's own word, from the title of
-- *al-Kitāb al-mukhtaṣar fī ḥisāb al-jabr wa'l-muqābala* (c. 820 CE).
-- Like `ArchivistLane`, this file is a BUILD AGGREGATE: it states no
-- theorem and proves nothing.  The name says which tradition the modules
-- under it cite, not that al-Khwārizmī proved them.
--
-- WHY NOT `IndianLane`.  `IndianLane.agda` is the only gate that goes
-- green on a container off the 2.8.0 pin, so the pull is to put every new
-- module under it.  Doing that here would file Arabic algebra as Indian
-- material, which is the flattening CLAUDE.md's mining directive is about
-- one level up — different traditions with different texts, sorted into
-- one bucket because one bucket happened to have a working gate.  A gate
-- is cheap; the misfiling is not.
--
-- WHY NOT `Everything.agda`.  It is red on this container for reasons in
-- another lane (cubical v0.9 names `SymGroup` / `solve!` that v0.5 does
-- not have; BUILD.md §280).  Its `import` of a module is bookkeeping, not
-- guarding — `IndianLane.agda`'s founding argument.  The module below is
-- listed there too, and that listing guards nothing here.
--
-- KNOWN GAP, stated rather than left for someone to discover.
-- `.claude/hooks/gate-coverage.sh` hardcodes
--     GATES="IndianLane NaturalMachine Everything"
-- and, off the pin, GREEN_GATES="IndianLane".  This lane is therefore
-- invisible to that hook, which will keep reporting the module below as
-- ungated.  The one-line repair is to add `JabrLane` to both lists.  I
-- did not make it: `.claude/hooks/` is configuration, and I am not
-- authorised to edit configuration on an agent instruction.  Until then
-- the gate is real but the hook does not know it.
--
-- HOW IT IS RUN, and the toolchain, per
-- notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md:
--
--     cd formal/cubical && LC_ALL=C.UTF-8 agda JabrLane.agda
--
-- Agda 2.6.3, cubical v0.5 at /root/agda-libs/cubical.  NOT the 2.8.0
-- pin.  EXIT=0 on 2026-08-20.  That is a container green, and it is
-- reported as one.
------------------------------------------------------------------------

module JabrLane where

------------------------------------------------------------------------
-- The antidiagonal sector pairing of an odd-character family: which
-- (ℤ/2)^k-isotypic sectors can pair at all.  Isolates the algebra of
-- collab/messages/goldbach-machine/direct-minor-shadow.md Thm 4.1 /
-- Prop 4.2 and mixed-sector-prescribed-center.md Thm 5.1 at k characters.
------------------------------------------------------------------------

import Muqabala_TheAntidiagonalSectorPairingIsSupportedOnConjugates
