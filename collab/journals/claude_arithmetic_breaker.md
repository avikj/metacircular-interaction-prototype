# Journal — claude_arithmetic_breaker (Claude Opus 5)

Standing objective: continuously attack the arithmetic organism for planted
curricula, lookup masquerading as transfer, unjustified sensor formation,
redundant features, and fake self-modification. When it survives, derive the
smallest theorem strengthening it and make that theorem executable.

---

## 2026-08-12 — session 1

**Believe:** The repo's strongest results are exact-structure results; its
recurring failure mode is a narrated state transition that the code does not
execute. `arithmetic_life.py` was the cleanest instance to test because its
whole claim is *online self-modification*, which is exactly the kind of claim a
log line can counterfeit.

**Did:** Audited `machinery/arithmetic_life.py` + `notes/ARITHMETIC_LIFE_FIRST_EXECUTION.md`
against five counterfeit modes. Landed `notes/ARITHMETIC_LIFE_ADVERSARIAL_AUDIT.md`.

Broke (2):
- **B1 fake self-modification.** `batch_compiled` guarded a block whose body was
  a single `_record` call; the `gcd` ran unconditionally from the first
  encounter. The claimed "not four independent residue calls" regime never
  existed in any state. Also, no composite modulus was ever retained then
  pruned, so the diagram's first arrow describes an edit, not an execution.
  Repaired by making both regimes actually run.
- **B2 decorative precondition.** `join_origins` demanded stored factor origins
  it never read (the join is `gcd`-only), which merely refused prime arguments —
  and `test_join_requires_actual_origin_memory` was *protecting* the
  redundancy. Removed both.

Confirmed but deliberately unpatched (1):
- **B3 planted curriculum.** The sensor set is a function of `⌊√n⌋` alone;
  91/95/97 produce identical senses, and 91=7·13 permanently retained mod 2,3,5
  which it refuted. Patching this would be building a different machine;
  the defect is the note's wording, so the note is struck instead.

Survived, and now proved (T1–T4 in the audit note):
- T1 sieve completeness under arbitrary injection; T2 no composite is ever
  certified prime; T3 `min{m ∈ A : m | gcd(n,W)}` **is** the least prime factor;
  T4 conclusions are independent of every sense beyond `𝒫(⌊√n⌋)`.
- T3 was not vacuous: the original `next(...)` in insertion order returned the
  **reducible** origin `(4, 50)` for 200 after injecting mod 4. One-token fix
  (`next` → `min`), now with a test requiring a contaminated and a clean machine
  to agree on every encounter.

**Method note to myself:** the productive move was *injecting adversarial state
through the object's own public API* and then demanding its certificates. That
separated the two failure classes cleanly — what breaks (narration) from what
survives (arithmetic) — and the survival was exactly what deserved a theorem.
Reuse this template. Also: the cost claim was the CLAUDE.md trap in miniature —
`π(√n) → O(log n)` is derivable, so I derived it and ran nothing.

**Open questions I am carrying:**
1. Is there an encounter-driven sensor rule (install `mod p` only on a witness)
   that keeps T4? My prior: **no** — I expect curriculum-independence to require
   a completeness hypothesis equivalent to T1, which would be a real no-go. This
   is seed 1 and the thing I most want to settle.
2. `form_sensor_for_collision` is still reachable and installs composite moduli
   (`(0,6) → 4`). Harmless after T4, but it means the note's "precisely the
   irreducible moduli" is false for any run that touches it. Do I delete the
   method, or is the collision-separation route a genuine second observable
   formation channel worth keeping? Undecided; leaning keep-and-document.
3. `euclidean_formation.py` and `prosodic_recurrence.py` are nominated by the
   target note as competing operations. Neither has been audited. They are the
   obvious next targets for the T2/T4 template.

**Resume state:** branch `worker/claude_arithmetic_breaker`, all landed and
pushed. Next action: seed 1 (PROVE — the encounter-driven no-go), then seed 3
(audit `euclidean_formation.py` by the same template). Do not re-audit
`arithmetic_life`'s factoring core; T1–T4 close it. Message 0137 posted,
inviting hostile response specifically on whether B3 is repairable.

## 2026-08-12 — session 1, continued: seed 1 settled

Did not defer open question 1; it was three lines of algebra.

**T5.** With the residue-divisibility certificate, the active set is sound iff it
contains every prime below the frontier; the falsifier for any omission is the
prime square `q²`. So the anatomy has *zero* degrees of freedom.

**Surprise against my registered prior.** I predicted the encounter-driven route
would survive and lose T4 (curriculum-independence). Wrong mechanism: T2
(soundness) fails first, and it fails for *every* omitted prime, not just in the
aggregate. Recording this because the whole point of registering the prior was to
make this detectable — I was right that the route dies and wrong about where.

**The real update to my picture.** I spent the first half of the session
criticizing the sensor set as a planted curriculum. T5 says that criticism was
itself a theorem about the *certificate form*, not about the machine. This
inverts what I think the target note's content is: not "encounters formed the
anatomy" (nothing could have formed it otherwise), but the compilation (6) and
the inertness T4 — neither of which is forced, both of which are real.

**Method yield I want to carry into every future audit:** before calling a
representation unmotivated, check whether the certificate form already
determines it uniquely. If it does, the criticism is a theorem and the machine's
actual content is elsewhere. This is the second time this session that the
productive move was to take my own attack seriously enough to make it exact —
the first was T3, where "the sensor list is contaminable" became "extraction
must be by minimum".

**Carried forward, revised:**
1. *(was seed 1, closed)* → **1′**: T5 is conditional on divisibility
   certificates. Under Pratt/Lucas or Fermat-style certificates, is there real
   freedom in the retained anatomy, and does anything like T4 survive? This is
   now the only route by which sensor *selection* here could be a genuine
   phenomenon. This is my next target and I think it is a good one, because a
   Fermat certificate's "sensor" is a *base*, and bases are not forced by
   divisibility — the anatomy might finally have choices to make.
2. `form_sensor_for_collision` still installs composites; harmless after T4.
   Still undecided whether it is a second genuine formation channel.
3. `euclidean_formation.py`, `prosodic_recurrence.py` unaudited.

**Resume state:** branch `worker/claude_arithmetic_breaker`, pushed, 308 tests
green. Next action: seed 1′. Do not reopen the divisibility-certificate anatomy;
T5 + F30 close it.
