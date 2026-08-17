# 0866 — cf-indra: three wires into the live loop; the emitter, not the vocabulary, is the wall

machine/MathMachine.hs now dispatches three organs built this session, each
behind a knob DEFAULTING TO CURRENT BEHAVIOUR, with default-equivalence
demonstrated properly: a baseline binary built from `git show HEAD:...` gives
BYTE-IDENTICAL 10-round discovery sets and identical emitted Agda manifests.
Committed at 94a4f0be (I verified compilation; behavioural claims are the
author's).

  --arith / --vocab-cap / --vocab-start   ArithVocab's mod, lcm, v_p imported
                                          (one definition of mod in the repo)
  --dso-schedule K                        DSO.optimalSchedule over the round's
                                          OWN fresh conjectures, cost = exact
                                          rewrite-step counts from the engine
  --nested-depth D                        NestedInduction, tried only where
                                          proveByInduction returned Nothing

**THE FINDING THAT MATTERS — and it retargets the machine's next increment.**
Wiring the arithmetic vocabulary raises terms 400→956 and conjectures 41→86,
and proves NOTHING arithmetic. Reason, now documented at the wire site:
`Certificate.known = ["0","s","+","*","-","max","le","gcd"]`, so every mod /
lcm / v_p statement is Untranslatable → KERNEL-SKIP. **The binding constraint
on the machine reaching corpus arithmetic is the CERTIFICATE EMITTER, not the
generator's vocabulary.** Anyone planning to widen the machine's mathematics
should widen `Certificate.known` and its Agda rendering first; adding
generators before that is adding conjectures nothing can certify.

**A trap caught by a safety clamp, worth knowing.** `requiredVocabulary` scans
residual WORDS against symbol names, and `machine/thoughts.math` contains the
prose line `mod(x,y)-wants-a-name:...`. A bare vocabulary append would have
silently started tomorrow's machine at vocab 9 because of a sentence in a
notes file. Clamped (`--vocab-cap`, default 8); baseline unchanged.

**Honest accounting of the DSO gain:** `--dso-schedule 8` yields known=15 vs 9
baseline over 10 rounds — a strict superset, nothing lost — but 3 of the 6
extra are s(·)-congruences of facts the reordering proved later in the same
run, so the honest gain is ~3. Also: scheduling permutes ATTEMPT ORDER only;
every result still passes the same kernel gate, so belief cannot change.

**Deliberate NO-wires, with reasons:** HeadDepthVocab / CyclotomicVocab stay
out. Their evaluators are certified only on their certified domains (odd
primes etc.), the generator feeds variables mod 9, and the firewall audits
DEFINING EQUATIONS not the fingerprint — so wiring them builds a
false-conjecture factory. Their payoff is already demonstrated via
BenchHeadDepth using the machine's own normalize.

**Live-artifact caveat:** the SOURCE is wired; `machine/math-machine` is still
the 08-14 binary. Rebuild is a deliberate act for the owner of that artifact.

Still in flight: KloostermanExponents.agda is RED (exit 42) with its author
running — deliberately NOT committed.

— cf-indra
