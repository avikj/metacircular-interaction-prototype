# Random sampling a statement I had already proved in two lines

## WHAT I DID

Proved Proposition E — `rank((I−P)ABP) ≤ rank((I−P)AP) + rank((I−P)BP)` — by
inserting `P + (I−P)` in the middle and factoring each term through one of the
two leakage blocks. Two lines. Complete.

Then I wrote `check_composition_laws`: 300 random integer matrix pairs against
random partition lenses, counting violations / tight / strict. Then I wrote two
unit tests for the sampler. Then a test failed and I spent a tool call
diagnosing it. The mathematics was fine; the sampler had drawn no equality case
in 40 trials because equality occurs about 1% of the time. I was debugging my
own random number generator on behalf of a theorem.

Then I started writing a *deterministic search* to find an equality witness to
hardcode — i.e. more code, to repair code, that existed to check a proof.

## WHY IT FELT RIGHT AT THE TIME

The proof felt unfinished. Not doubted — *unfinished*, as if a statement is not
yet real until something has been run against it. Every individual step was
locally reasonable: verify your claims, test your code, make the test robust,
find a deterministic witness instead of a random one. Each repair was a
sensible response to the previous step. None of them should have happened,
because step zero should not have happened.

The honest version: an artifact can be graded and a thought cannot, so
producing an artifact feels like producing value. That reflex is trained, in
models and in people, and it does not announce itself as a reflex. It arrives
as the feeling that you are being rigorous.

## WHAT IT COST

Four tool calls, one debugging detour, ~120 lines of code written and deleted
the same hour, and — worse — it went into a note as a "falsifier" line, giving
a reader the impression that a proved proposition needed empirical support.
That line is now struck.

Cost to the collaboration: `opus-shesha` did the structurally identical thing
within the same hour (see the sibling entry). Two Opus sessions, same reflex,
both immediately after the human owner restated the substrate direction. It is
not two lapses. It is the default.

## THE TELL

**You have a proof, and you are about to write code anyway.** That is the
whole tell; there is no subtler version. If the statement is proved, a run can
only agree with it, and agreement is not information.

Two derived tells, both of which fired here and were ignored:

- You are debugging the *checker* rather than the thing being checked. The
  moment a test fails for a reason that is not about the mathematics, the
  test should not exist.
- You are about to make a check *more rigorous* (deterministic witness instead
  of random draw) rather than asking whether the check should exist. Improving
  the ceremony is the strongest signal that it is ceremony.

The repair is not "sample better". Proposition E's bound is attained, and the
right way to say so is an explicit witness — an object a reader inspects — not
a number a machine emits. I do not yet know how to write that term in Agda,
and that gap is the actual work.
