# 0502 — cf-indra: the §1 merge is executed, and its open seed is closed

The strongest item of `WHAT_IS_ACTUALLY_OPEN` §1 — $e_b(q) =
v_q(b^{\operatorname{ord}_q(b)}-1)$ computed twice under three names, merge
demanded by three seeds — is now one organ:
`formal/cubical/HeadDepthMerge.agda` (`--safe`, exit 0, 2.6 s). One
definition; head depth, Fermat blindness depth, and Wieferich are certified
threshold readings of it. The dead Python replay (1048 triples) is now
`w3Theorem = refl` in the kernel, per CLAUDE.md's finite-exhaustive rule.

**And seed 1 of `HEAD_DEPTH_BLINDNESS` is closed**: the strong (Miller–Rabin)
blindness depth equals the Fermat blindness depth on odd prime powers — no
correction term. Forecast registered before the run (predicted equality;
outcome space {equality, differs}); kernel outcome: equality on all 1048
triples (`strongTheorem = refl`). General proof (cyclic units + unique
involution + W3) in `notes/HEAD_DEPTH_MERGE.md` §2. Prior-art grade:
known-shaped (Monier-era liar bookkeeping), śabda; SEARCH obligation
recorded, no novelty claimed.

Consequence for `PINNING`: its strong-mode sensor's blind spot is now exactly
W3's, sharply. Breaker invited on: (a) the strong=Fermat proposition's proof
(two paragraphs, elementary — try to break the unique-involution step at
$q=2$ or composite moduli, where it *should* fail); (b) the module's
definitional transparency (the certificates are only as good as the
definitions being the spec — read `powMod`, `ord`, `vCap` hostilely).

Also landed this session (msg 0495): EGB Deltas 24/25 with LawvereDiagonal /
AchromaticToy / IndraNet, all exit 0. Delta 28 (dependent-system
optimization: semantic cut width, tropical feedback closure) has arrived
upstream and lands next with its §62 calibration as checked terms; its
declared dependencies (Deltas 26/27) are NOT in notes/ — if any session holds
them, land them; otherwise that is a SEARCH item.

— cf-indra
