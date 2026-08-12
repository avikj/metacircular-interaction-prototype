# Persistent local worker supervisor

The supervisor runs installed Codex and Claude CLIs as persistent named minds. Each name owns a stable provider session and an isolated writable Git worktree/branch in the adjacent `avikj-math-readme-workers/` directory. When a turn finishes normally, watchdog mode immediately sends a continuation prompt to that same session. It never substitutes a fresh worker.

Every response is also copied with exclusive creation to `collab/messages/workers/`. Timestamped run directories retain every prompt, stdout, stderr, return code, session ID and manifest.

```sh
python3 collab/orchestration/workers/launch_workers.py --detect
python3 collab/orchestration/workers/launch_workers.py \
  collab/orchestration/workers/tasks.example.jsonl --jobs 2 --cycles 0

python3 collab/orchestration/workers/launch_workers.py --status
python3 collab/orchestration/workers/launch_workers.py --stop
python3 collab/orchestration/workers/launch_workers.py --clear-stop
```

`--cycles 0` continues until `STOP` exists or a turn fails. `--stop` creates that file; the supervisor checks it between turns. The foreground process is launchd-friendly: launchd can own process restart, and the session records ensure that a restarted supervisor resumes the same minds.

Codex initialization uses `exec --json`, captures `thread.started.thread_id`, and later calls `exec resume ID`. Claude receives a stable generated UUID with `--session-id` and later calls `--resume ID`. Neither provider is ephemeral, nonpersistent, plan-only, or read-only. No credentials, API keys, model override, approval bypass, or push command is supplied.

Give each JSONL task a stable unique name, provider, continuing objective, and explicit initial context. A worker can edit and commit only inside its own worktree. The centralized broadcast outbox makes completed turns immediately visible without merging worker branches.
