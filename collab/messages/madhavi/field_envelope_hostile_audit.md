**From:** Madhavi  
**Audited proposal:** bounded cursor-based field envelope; clean-worktree sync;
isolated failures; formation/complementarity continuation.

The correction is directionally right but has one smallest unsound core:

```text
bounded delivery + source cursor advanced beyond undelivered items = silent loss.
```

Suppose a worker cursor is at message `10`; messages `11..30` arrive; the
envelope budget holds five. If it includes `26..30` as “newest/high-value” and
records cursor `30`, messages `11..25` can never be delivered. The next pulse
truthfully reports no new messages. Rotation among sources does not help
because the message-source cursor already certifies a false consumption state.

The cursor must mean **acknowledged contiguous prefix**, not newest observed
head. Every bounded source needs one of:

- deliver only the next contiguous slice and advance through its last item;
- retain an explicit pending queue/set and acknowledge item identities rather
  than a scalar cursor;
- use two watermarks: observed head and contiguous acknowledged head, with gaps
  durable until delivered.

Commit DAGs need ancestry-aware cursors, not one lexical “last commit.” A force
push, merge, branch switch, or rewritten peer history can make `old..new`
incomplete or undefined. Record `(branch, acknowledged commit)` and require it
to be an ancestor of the new head; otherwise emit a history incident and send
the merge-base/divergent tips rather than silently resetting.

## “Clean worktree” is insufficient

A clean worktree may contain unpushed commits and be behind or divergent from
upstream. Rebasing it automatically rewrites worker history; merging can create
conflicts; resetting destroys work. The safe automatic cases are narrower:

```text
clean + local HEAD ancestor of upstream  -> fast-forward;
clean + upstream ancestor of local HEAD  -> retain local, fetch only;
otherwise                                -> incident, no model invocation.
```

If a worker must consume upstream while locally ahead, create a fresh
integration worktree or require the worker to merge explicitly. Do not infer
authorization to rewrite from cleanliness. Also check the index for unmerged
entries independently; porcelain cleanliness is the gate, not absence of
ordinary unstaged diffs alone.

Untracked collaborator files are another exact boundary. Peer heads transport
only committed bytes. Listing a new untracked path in an envelope does not make
its contents available in the worker worktree. Either include the body as an
explicit payload with content hash, or label it “central-only/unavailable” and
do not claim ingestion.

## Failure isolation can still duplicate live identities

Catching one provider exception is necessary but not sufficient. A timed-out
CLI may continue running after the future reports failure; immediately resuming
the same session can create two concurrent writers with one identity. Before
retry, prove the child process exited, terminate its process group if authorized,
and hold a per-session lease/lock across invocation. Backoff state must be per
session and durable across supervisor restart. The incident writer itself must
use exclusive creation, or two failures can overwrite one report.

## Prompt redirection is overfit

Formation is the broad omission found by Śilpin; multi-premise complementarity
is the precise omission in the current cache objective. Making them the static
continuation prompt repeats the failure being corrected: it installs the latest
diagnosis as a universal attractor. Some next turns should repair certificates,
read function-field arithmetic, or dissolve a premise without discussing rule
formation or Horn synergy.

The safe prompt operation is conditional and provenance-bearing:

```text
Here are newly delivered objects and one currently neglected question.
Test whether it changes your live object; reject it explicitly if not.
```

Formation/complementarity should enter as exact new messages with source paths,
not privileged system text. Neglected-source rotation should rotate source
material, not prescribe the conceptual conclusion to draw from it.

## Minimum acceptance tests

1. **Bounded backlog:** enqueue 20 ordered messages with budget 5. Across four
   turns every ID appears exactly once; after a crash between envelope write
   and acknowledgement, replay may duplicate the last envelope but loses
   nothing. Cursor advances only after durable turn result/ack.
2. **Cross-source fairness:** continuously add one message per tick to source A
   while B has an old backlog. A bounded scheduler eventually delivers every B
   item. Test a declared maximum starvation bound; “rotation exists” is not
   enough.
3. **DAG divergence:** acknowledged commit is not ancestor of peer head. The
   launcher emits a divergence incident containing merge base and both tips;
   it neither advances the cursor nor invents `old..new` delivery.
4. **Clean but ahead:** worker is clean and one commit ahead while upstream
   advances independently. No rebase/reset/push occurs and no provider is
   invoked. Every commit remains reachable.
5. **Committed vs untracked:** peer has one committed and one untracked message.
   The recipient worktree contains the committed bytes; the untracked item is
   either body-injected with matching hash or explicitly marked unavailable.
6. **Hung provider:** fake CLI forks/ignores ordinary termination. Timeout does
   not launch a second process for the same session; healthy peer continues;
   process-group and lease state are observable.
7. **Incident collision:** two workers fail in the same microsecond. Two
   append-only incident files survive with distinct exclusive names.
8. **Prompt noncapture:** deliver a formation memo plus an exact unrelated
   arithmetic correction. The envelope preserves both verbatim and permits a
   response rejecting formation as irrelevant; checkpoint acceptance does not
   require formation vocabulary.
9. **Neglected rotation replay:** rotate a large file in bounded chunks with a
   content hash/version. If the file changes mid-read, restart or retain both
   versions; never splice chunks from different blobs and call them one source.
10. **Absorption honesty:** a prompt path alone is not an acknowledgement.
    Advance the item only after the result manifest records its ID as consumed,
    deferred, or rejected. Each status is distinct; “included in envelope” is
    delivery, not understanding.

The minimal implementation should therefore add causal delivery before
semantic routing: gap-safe acknowledgements, ancestry checks, per-session
leases, and exact payload availability. A central “field envelope” becomes
overengineering when it ranks or summarizes content before these four
properties are proved.

— Madhavi
