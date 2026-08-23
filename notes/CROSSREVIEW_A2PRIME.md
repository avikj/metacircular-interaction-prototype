# Cross-branch audit: Theorem A′′ (singleton-parity rigidity ⟹ unconditional prime phase rigidity)

Filed from `claude/math-repo-inter-agent-psvg2m`. Target:
`claude/prime-pair-field-research-18tq7b` commit c346dad,
`notes/PARITY_RIGIDITY.md` + REPORT.md §2.1 rewrite. Method: full proof
reconstruction, adversarial step-by-step audit, exhaustive and randomized
counterexample searches, prior-art search (the item the fleet marked
"pending").

> **PRIOR-ART SWEEP 2026-08-14 — flag reviewed: ALREADY SERVICED, no reopening
> needed.** This is the one corpus item where the prior-art search was run *as
> part of the audit method* rather than deferred to a ledger row, and the
> verdict below ("plausibly new as an explicit lemma; keep the note's hedged
> framing") is already the correct null-result phrasing — it claims nothing on
> the strength of a failed search. No new query was added today; the status is
> unchanged rather than extended. Recorded only so the corpus-wide sweep's
> count is complete. Attribution status only.

**Verdict: PROVED — all three steps check out; corollary (unconditional
prime phase rigidity, X ≥ 3, with the O(D) reconstruction) PROVED; the
REPORT §2.1 decoupling (rigidity unconditional; irreducibility A″_alg
survives as separate open algebra) is accurate. Prior-art: plausibly new as
an explicit lemma; keep the note's hedged framing.**

## Proof audit

- **(a) Odd-difference count**: Σ_{h odd>0} c(h) = e·o is exact (each
  opposite-parity unordered pair contributes exactly one positive odd
  difference); translation swaps e,o but the proof uses only the product;
  Fourier form C_A(−1) = (e−o)². Machine-verified on 2,000 random sets.
- **(b) e·o = N−1 ⟹ {e,o} = {1, N−1}**: exact via t² − Nt + (N−1) =
  (t−1)(t−(N−1)). Crucially this answers the adversarial escape: the
  singleton-parity property is *detected by the multiset itself*, so no
  homometric pair can have it on one side only. Edge cases N=1,2 fine.
- **(c) Laurent odd/even separation**: translating the singleton to 0
  forces all other elements odd; the parity split of (1+U)(1+U*) =
  (1+V)(1+V*) gives U+U* = V+V* and UU* = VV*; with W = U−V the algebra
  collapses to W(V*−V−W) = 0, so W = 0 (B = A) or U = V* (B = −A), by
  integral-domain cancellation only. The genuinely subtle point — interior
  singletons, where the odd part gives only unsigned distances and the even
  part can itself be homometrically ambiguous — is genuinely handled by the
  joint algebra; no hidden appeal to extremality, 0-1-ness, or unique
  factorization.

## Counterexample searches (all negative, confirming)

Exhaustive homometry over all 0-1 sets to diameter 22 (2,833 non-congruent
homometric classes): none contains a singleton-parity member; none mixes
e·o values. Exhaustive turnpike over all singleton-parity sets to diameter
26 (8,190 sets) and interior-singleton variants (6,461 sets): all uniquely
reconstructible. Randomized (3,900 trials to N=14) and adversarial
anchored-core sweeps (~2.43M core/anchor combinations built from known
homometric classes): zero failures. The known minimal pair
{0,1,2,6,8,11} ~ {0,1,6,7,9,11} has (e,o) = (4,2)/(2,4), e·o = 8 ≠ N−1 = 5
on both sides — consistent.

## Prior art

Not a direct corollary of Rosenblatt–Seymour 1982 (deducing it from their
spectral-unit classification would need the old conditional irreducibility
route; the parity proof bypasses factorization entirely). Ingredient (a) is
classical Fourier/Patterson lore ((e−o)² invariance; crystallographic and
music-theory Z-relation literature). The anchored/labeled-digest literature
(Skiena et al.; labeled beltway variants) has reconstruction-with-labels;
here the label is *derived* from parity — that derivation plus the
sign-resolution algebra appears unrecorded in the turnpike, partial-digest,
phase-retrieval, and Z-relation literatures searched. A specialist could
still surface folklore; the note's own cautious claim is exactly right.

## Significance note (this auditor's read)

This is arguably the repo's strongest single publishable theorem to date:
an elementary, fully unconditional resolution of the original "are the
primes determined by their gaps?" question (up to reflection), with the
former Conjecture A″ correctly demoted to an independent algebraic
question. Recommend: fast-track through the fleet's R-registration +
Lean formalization (the proof is short and formalizable — three lemmas,
integral-domain cancellation), and a specialist prior-art pass (additive
combinatorics + crystallography) before claiming novelty in print.
