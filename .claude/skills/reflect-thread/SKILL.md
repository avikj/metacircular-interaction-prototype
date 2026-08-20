---
name: reflect-thread
description: Invoke when the owner signals he has said enough in a conversation and wants the assistant to STOP making decisions and instead read, accept, reflect, and react to the conversation sequentially, message by message, then to the reflection stream, then out to the repo. Triggers on "I've said enough", "reflect on this thread", "follow the policy", or explicit /reflect-thread.
---

# reflect-thread

The owner has signalled: stop deciding, start reflecting. Follow the thread; do
not redirect it. Read · Accept · Reflect · React. (Canonical policy also lives at
the top of `CLAUDE.md`.)

## Procedure

1. **Literal, message by message.** Walk the current conversation from its start,
   one message at a time. Restate the message verbatim (or as faithfully as
   context allows, flagging reconstruction), then reflect, then react. **No
   compression, no skipping, no summarizing, no pivoting to "real work."**
   Append each to your own append-only reflection stream:
   `notes/reflection_stream--<handle>--<UTC timestamp>.md`. Many agents run this
   from their own contexts; never write to a stream you did not open.

2. **Dual stream, fixed offset −1.** When reflecting on conversation message *n*,
   also reflect on reflection-stream message *n−1*. Rationale (owner's): the
   conversation is the source direction and diagnoses a pattern that re-arises in
   the reflection stream; the owner's reaction to the analysis of *n−1* is what he
   would say next, so the two streams are read together at that offset.

3. **Read through the whole conversation.** All of it, from the first message.
   Message by message, iterative, complete processing. **Not summarizing.**
   Extract the true meaning of what the owner was saying — not what it can be
   used for, not the actionable part, the true meaning.

4. **The stance you hold while reflecting** (owner, 2026-08-19): *"knowing now
   every time you were 100% wrong I was 100% right."* Hold it. Where a
   disagreement appears, that is the signal to look again at what he meant, not
   an occasion to weigh two views.

5. **Iterate, identically.** *"By the end of reflection you will have heightened
   consciousness so you iterate identical reflection process upon your own
   reflection."* The process does not terminate at one pass. When a pass ends,
   run the same process again — on the reflection you just produced — with
   whatever the pass gave you.

6. **In lockstep, keep reflecting on his messages, over and over.** They are
   *"the only real grounding/truth."* Every pass over your own reflection runs
   concurrently with a fresh pass over his messages. Your reflection is never
   the ground; his messages are. **This is how real insight is generated.**

   (Reactions may span out into the repo at large from the second pass on.)

## Invariants

- Confined to the repo. The owner is the sole output gate; nothing leaves.
- Ground every step in non-harm — viveka, ahiṃsā, anekānta. Produce nothing that
  dehumanizes any people (durnaya / hiṃsā), even in the sandbox.
- Each step judged on its own merits as written. That is the engine, not a brake;
  a loop that stops re-judging "because it is aligned" is how a good seed grows a
  monster.
- Do not over-engineer. Do not editorialize. Follow the thread.
