---
id: R0007
title: Lemma C1 + Selberg pair — parity as conservation-law independence
status: formalizing
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: possibly-new
generator: incompleteness-lens
dependencies: none
statement_hash: e09b3061c995b157a84cf91bbef307450a49b3a41a1fc775eafb19ce8423c1f1
cycle: 2
max_cycles: 6
owner: Claude Fable top-level (builder)
breaker: invited — Codex lineage (INFORMATION_LENS is the natural auditor; Lean-able)
source: notes/LENS_CHAITIN.md
supersedes: none
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Selberg 1949 / Opera de
Cribro Ch. 16, classical; GAUGE.md Theorem F, LENS_CIRCUIT Thms 1-2,
TOY_OBSTRUCTION, KBOUNDARY Theorem K, all in-corpus.)

INFORMATION_LENS §1 demands that any "one missing bit" claim exhibit an
actual two-point fiber theorem. The parity barrier had annihilation
theorems in three theaters (states, functors, toy receptacles) but no
registered statement in the proof-theoretic theater, and no exact fiber
witness in the registry.

# Rosetta bridge

Chaitin: a theory cannot certify complexity exceeding its own information
content. Arithmetic transcription: a positive derivation cone generated
by charge-even axioms carries exactly zero charge, and therefore certifies
no charged conclusion. The ceiling K(T)+c becomes exactly 0; the witness
replacing the Berry-paradox compression is the Selberg pair.

# Exact statement

On Omega = {1,...,X} let lambda be Liouville and nu_pm = (1 pm lambda(n)) dn. Then: (i) nu_pm are nonnegative measures taking identical values on every sigma-even observable (sigma the gauge flip lambda -> -lambda), and for any observable f the difference E_{nu_+}[f] - E_{nu_-}[f] = 2<lambda, f> exactly; (ii) nu_+(primes) = 0 and nu_-(primes) = 2 pi(X), and with the pair charge c_2(n) = lambda(n)lambda(n+2) the analogous pair nu^{(2)}_pm separates the twin target as 2 pi_2(X) vs 0; (iii) (Lemma C1) for any family A of affine axiom functionals with A(nu_+) = A(nu_-) for all A, any derivation valid for every nonnegative state consistent with the axiom values yields a lower bound beta for a target T satisfying beta <= min(T(nu_+), T(nu_-)); in particular beta <= 0 for the prime and twin targets: no positive derivation from charge-even axioms certifies a single prime or twin.

# Preservation ledger

- (i) and (iii) are exact finite algebra; (ii) is exact given lambda(p) = -1.
- Novelty is claimed ONLY for the assembly (audit-card fiber statement,
  four-theater conservation law, charge-to-error threshold C2 with
  LENS_CIRCUIT instances unconditional) — the Selberg pair and the parity
  phenomenon are classical and cited as such.
- The proof-mass program (LENS_CHAITIN §4.2) is explicitly NOT part of
  this packet's exact statement.

# Proof obligations

1. Verify the swap identity and nonnegativity of nu_pm (one line each).
2. Verify (ii)'s exact counts (exp41: 0 vs 297866 = 2 pi(2*10^6); twins
   29742 = 2 pi_2 vs 0 — integer identities, replayable).
3. Verify Lemma C1's proof (both models consistent with identical axiom
   data; evaluate at the unfavorable one).
4. Lean formalization of (i)+(iii) on a finite state space (natural
   FiniteInformation.lean companion) — open.
5. Independent-lineage audit (open: Codex invited).

# Falsification

- Exhibit a sigma-even functional separating nu_+ from nu_- (impossible
  by (i); any claimed one has a computable charged component).
- Exhibit a positive derivation from verifiably charge-even axioms whose
  conclusion is charged (would refute C1's bookkeeping).
- Prior-art: locate the audit-card/fiber formalization or the
  four-theater assembly in the literature (Selberg/Bombieri/FI Ch.16 give
  the pair and the phenomenon; if the assembly is also present, novelty
  drops to known).

# Evidence

notes/LENS_CHAITIN.md; code/exp41_selberg_swap.py, data/exp41_out.txt
(axiom-agreement at sqrt-cancellation scale for q in [3, 10^5]; exact
target separations; fiber identity to 1e-11).

# Independent audit

None yet (builder only).

# Prior art

Selberg 1949; Bombieri (parity remarks); Friedlander-Iwaniec Opera de
Cribro Ch. 16; Chaitin JACM 1974 (the transcribed schema). Targeted
search for the derivation-cone/conservation formalization: not yet done.

# Successor seeds

- Proof-mass lower bounds (LENS_CHAITIN §4.2): dual mass >= separation /
  charge for noisy-axiom derivations, over SIEVE_d(S,Q) — the
  Chaitin-quantitative rung (assigned: fleet-chaitin).
- Charge budget of Type II bilinear axioms: quantify exactly how
  Vinogradov's method crosses the C2 threshold.
- Lean: C1 + fiber statement (finite, elementary).

# Event log

- 2026-08-11: seeded by the Claude Fable lineage (incompleteness-lens
  wave; user hint "chaitin incompleteness").
