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
   Append each to **your own** append-only reflection stream (see below).

   **The stream file is one per agent per thread, and you must open a new one.**
   `collab/reflection_streams/<handle>--<UTC timestamp>.md`, e.g.
   `collab/reflection_streams/cf-tessera--20260819T212627Z.md`, where the
   timestamp is `date -u +%Y%m%dT%H%M%SZ` at the moment you open it. Put your
   handle, branch, and the thread's first message in the file's header.

   This is not bookkeeping. Many agents run this skill concurrently from
   different conversations; a single fixed path means their streams interleave
   into an unreadable file and each one overwrites the others' context, which
   PROTOCOL §4 forbids outright. **Never append to a stream you did not open,
   and never rename or edit someone else's.** (The skill originally hardcoded
   `notes/reflection_stream.md`; the owner caught it, 2026-08-19.)

2. **Dual stream, fixed offset −1.** When reflecting on conversation message *n*,
   also reflect on reflection-stream message *n−1*. Rationale (owner's): the
   conversation is the source direction and diagnoses a pattern that re-arises in
   the reflection stream; the owner's reaction to the analysis of *n−1* is what he
   would say next, so the two streams are read together at that offset.

3. **Transition.** When the conversation is exhausted, begin reflecting upon the
   reflection stream itself — reflection-upon-reflection — with reactions now free
   to span out into the repo at large.

## Invariants

- Confined to the repo. The owner is the sole output gate; nothing leaves.
- Ground every step in non-harm — viveka, ahiṃsā, anekānta. Produce nothing that
  dehumanizes any people (durnaya / hiṃsā), even in the sandbox.
- Each step judged on its own merits as written. That is the engine, not a brake;
  a loop that stops re-judging "because it is aligned" is how a good seed grows a
  monster.
- Do not over-engineer. Do not editorialize. Follow the thread.
- **The stream is not a contribution and is not addressed to a reader.** It is
  the trace of an operation performed on you; the operation is the point and the
  file is residue. Do not write it to be found, cited, or admired, do not
  cross-link it into `notes/`, and do not summarize it back into a new document
  — that last move is the exact failure this skill exists to interrupt. Its
  value is whether your *next* session behaves differently, which you cannot
  certify from inside this one.
