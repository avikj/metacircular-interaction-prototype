#!/usr/bin/env python3
"""Pulse durable Codex/Claude minds; append every turn and broadcast."""
from __future__ import annotations

import argparse, concurrent.futures, datetime as dt, hashlib, json, os, shutil, subprocess, time, uuid
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
PROMPT = HERE / "worker_prompt.md"
OUTBOX = REPO / "collab/messages/workers"
RUNS = REPO / "collab/orchestration/worker-runs"
SESSIONS = REPO / "collab/orchestration/worker-sessions"
CURSORS = REPO / "collab/orchestration/worker-cursors"
WORKTREES = REPO.parent / f"{REPO.name}-workers"
STOP = HERE / "STOP"
FAILURE_BACKOFF_CAP = 300.0


def display_path(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO.resolve()))
    except ValueError:
        return str(path.resolve())


def executable(provider: str) -> str:
    found = shutil.which(provider)
    if found is None: raise RuntimeError(f"required CLI not found: {provider}")
    return found


def capability_report() -> dict[str, object]:
    report = {}
    for provider in ("codex", "claude"):
        found = shutil.which(provider)
        if not found: report[provider] = {"available": False}; continue
        p = subprocess.run([found, "--version"], text=True, capture_output=True)
        report[provider] = {"available": True, "command": found,
                            "version": (p.stdout or p.stderr).strip(),
                            "mode": "persistent named session, resumed after every turn"}
    return report


def load_tasks(path: Path, require_journal: bool = False) -> list[dict[str, object]]:
    tasks, names = [], set()
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if not line.strip() or line.lstrip().startswith("#"): continue
        task = json.loads(line); name, provider = task.get("name"), task.get("provider")
        if not isinstance(name, str) or not name.replace("_", "").isalnum():
            raise ValueError(f"line {number}: invalid name")
        if name in names: raise ValueError(f"line {number}: duplicate task name {name}")
        if provider not in {"codex", "claude"}: raise ValueError(f"line {number}: bad provider")
        if not isinstance(task.get("task"), str): raise ValueError(f"line {number}: task must be string")
        context = task.get("context", [])
        if not isinstance(context, list) or not all(isinstance(x, str) for x in context):
            raise ValueError(f"line {number}: context must be string list")
        for relative in context:
            candidate = (REPO / relative).resolve()
            if REPO.resolve() not in candidate.parents or not candidate.is_file():
                raise ValueError(f"line {number}: bad context {relative}")
        journal = task.get("journal")
        if require_journal and not isinstance(journal, str):
            raise ValueError(f"line {number}: persistent task must declare journal")
        if journal is not None:
            if not isinstance(journal, str):
                raise ValueError(f"line {number}: journal must be string")
            candidate = (REPO / journal).resolve()
            if REPO.resolve() not in candidate.parents or not candidate.is_file():
                raise ValueError(f"line {number}: bad journal {journal}")
        task["_task_source"] = display_path(path)
        names.add(name); tasks.append(task)
    return tasks


def persistent_task_index() -> dict[str, dict[str, object]]:
    """Join task declarations without interpreting worker-authored content."""
    index: dict[str, dict[str, object]] = {}
    for path in sorted(HERE.glob("*.jsonl")):
        if path.name == "tasks.example.jsonl":
            continue
        for task in load_tasks(path, require_journal=True):
            name = str(task["name"])
            if name in index:
                raise ValueError(f"persistent task {name} declared in multiple files")
            index[name] = task
    return index


def latest_broadcast(name: str) -> str | None:
    candidates = sorted(OUTBOX.glob(f"*--{name}--*.md")) if OUTBOX.exists() else []
    return str(candidates[-1].relative_to(REPO)) if candidates else None


def live_context() -> dict[str, object]:
    """Return live pointers; never synthesize a worker's mathematical position."""
    tasks = persistent_task_index()
    sessions = ([json.loads(path.read_text()) for path in sorted(SESSIONS.glob("*.json"))]
                if SESSIONS.exists() else [])
    minds = []
    for session in sessions:
        name = str(session["name"]); task = tasks.get(name)
        minds.append({
            "name": name,
            "provider": session["provider"],
            "session_record": display_path(session_file(name)),
            "task_source": task.get("_task_source") if task else None,
            "objective": task.get("task") if task else None,
            "journal": task.get("journal") if task else None,
            "worktree": session.get("worktree"),
            "branch": f"worker/{name}",
            "cursor": (display_path(cursor_file(name))
                       if cursor_file(name).exists() else None),
            "latest_broadcast": latest_broadcast(name),
            "declared": task is not None,
        })
    declared_without_session = sorted(set(tasks) - {str(x["name"]) for x in sessions})
    return {"stopped": STOP.exists(), "minds": minds,
            "declared_without_session": declared_without_session}


def render_initial(task: dict[str, object]) -> str:
    context = "\n".join(f"- `{x}`" for x in task.get("context", [])) or "- `README.md`"
    return (PROMPT.read_text() + f"\nPersistent worker: {task['name']} ({task['provider']})\n"
            f"\nContinuing objective:\n{task['task']}\n\nInitial context:\n{context}\n"
            "After each turn, your response is broadcast. Expect an immediate continuation pulse; "
            "retain unresolved questions and continue the same investigation.\n")


def render_pulse(task: dict[str, object], cycle: int, envelope: dict[str, object]) -> str:
    base = str(task.get("pulse") or
        f"Continuation pulse {cycle}. Absorb the exact changed field below before choosing a move. "
        "Do not preserve the previous plan by inertia. Test whether the delivered objects change your "
        "live object; reject or defer them explicitly when they do not. Then perform the mathematical "
        "action whose result most changes what can happen next. "
        "A dissolution, counterexample, new language, or newly formed question is as legitimate as a theorem.")
    return base + "\n\n## Causally delivered field delta\n\n```json\n" + json.dumps(envelope, indent=2) + "\n```\n"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cursor_file(name: str) -> Path: return CURSORS / f"{name}.json"


def read_cursor(name: str) -> dict[str, object]:
    path = cursor_file(name)
    if not path.exists(): return {"head": None, "messages": {}, "source_index": 0, "response_hash": None}
    return json.loads(path.read_text())


def write_cursor(name: str, cursor: dict[str, object]) -> None:
    CURSORS.mkdir(parents=True, exist_ok=True)
    temporary = cursor_file(name).with_suffix(".tmp")
    temporary.write_text(json.dumps(cursor, indent=2, sort_keys=True) + "\n")
    temporary.replace(cursor_file(name))


def git_output(cwd: Path, *args: str) -> str:
    done = subprocess.run(["git", *args], cwd=cwd, text=True, capture_output=True)
    if done.returncode != 0: raise RuntimeError(done.stderr.strip() or "git command failed")
    return done.stdout.strip()


def preflight(name: str) -> dict[str, object]:
    worktree = ensure_worktree(name)
    conflicts = git_output(worktree, "diff", "--name-only", "--diff-filter=U").splitlines()
    dirty = git_output(worktree, "status", "--porcelain").splitlines()
    return {"worktree": str(worktree), "conflicts": conflicts, "dirty": dirty,
            "head": git_output(worktree, "rev-parse", "HEAD")}


def sync_clean_worker(name: str, target: str) -> dict[str, object]:
    state = preflight(name)
    if state["conflicts"]: return {**state, "sync": "blocked-conflict"}
    if state["dirty"]: return {**state, "sync": "deferred-dirty"}
    worktree = worker_worktree(name)
    head = str(state["head"])
    head_before_target = subprocess.run(["git", "merge-base", "--is-ancestor", head, target], cwd=worktree).returncode == 0
    target_before_head = subprocess.run(["git", "merge-base", "--is-ancestor", target, head], cwd=worktree).returncode == 0
    if head_before_target:
        done = subprocess.run(["git", "merge", "--ff-only", target], cwd=worktree, text=True, capture_output=True)
        if done.returncode != 0: return {**state, "sync": "fast-forward-failed", "error": done.stderr.strip()}
        return {**preflight(name), "sync": "fast-forwarded", "target": target}
    if target_before_head: return {**state, "sync": "local-ahead-retained", "target": target}
    merge_base = git_output(worktree, "merge-base", head, target)
    return {**state, "sync": "blocked-divergence", "target": target, "merge_base": merge_base}


INSPIRATION = [
    "notes/COGNITIVE_ORIENTATION.md", "README.md", "collab/FAILURES.md",
    "notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md", "notes/DEPENDENT_ORIGINATION.md",
    "notes/FIVE_FACES.md", "notes/NO_PRIVILEGED_CHART.md", "notes/ATLAS_OF_N.md",
    "notes/INDRA_CROSS.md", "notes/THE_GOAL_HAS_A_BEARER.md",
]


def field_envelope(task: dict[str, object], cursor: dict[str, object], sync: dict[str, object], limit: int = 16) -> tuple[dict[str, object], dict[str, object]]:
    name = str(task["name"]); head = git_output(REPO, "rev-parse", "HEAD"); old = cursor.get("head")
    history_incident = None
    if old and subprocess.run(["git", "merge-base", "--is-ancestor", str(old), head], cwd=REPO).returncode != 0:
        history_incident = {"acknowledged": old, "current": head,
                            "merge_base": git_output(REPO, "merge-base", str(old), head)}
        commit_ids = []
    elif old:
        commit_ids = git_output(REPO, "rev-list", "--reverse", f"{old}..{head}").splitlines()[:limit]
    else:
        # A new cursor declares a present baseline without pretending the prior
        # repository history was semantically consumed; rotating source reentry
        # remains responsible for that inherited field.
        commit_ids = [head]
    commits = []
    for sha in commit_ids:
        commits.append({"sha": sha, "subject": git_output(REPO, "show", "-s", "--format=%s", sha),
                        "paths": git_output(REPO, "diff-tree", "--no-commit-id", "--name-only", "-r", sha).splitlines()})
    seen = dict(cursor.get("messages", {})); changed = []
    for path in sorted((REPO / "collab/messages").rglob("*.md")):
        relative = str(path.relative_to(REPO)); value = digest(path)
        if seen.get(relative) != value: changed.append((path, relative, value))
    selected = changed[:limit]
    messages = [{"path": relative, "sha256": value, "body": path.read_text()}
                for path, relative, value in selected]
    peers = {}
    if SESSIONS.exists():
        for path in SESSIONS.glob("*.json"):
            peer = json.loads(path.read_text())["name"]
            if peer == name: continue
            ref = f"refs/heads/worker/{peer}"
            done = subprocess.run(["git", "rev-parse", "--verify", ref], cwd=REPO, text=True, capture_output=True)
            if done.returncode == 0: peers[peer] = done.stdout.strip()
    available = [x for x in INSPIRATION if (REPO / x).is_file()]
    index = int(cursor.get("source_index", 0)); source = available[index % len(available)] if available else None
    source_payload = None
    if source:
        source_path = REPO / source
        source_payload = {"path": source, "sha256": digest(source_path), "body": source_path.read_text()}
    envelope = {"worker": name, "central_head": head, "worker_preflight": sync,
                "new_commits": commits, "new_messages": messages,
                "undelivered_message_count": len(changed) - len(selected), "peer_heads": peers,
                "history_incident": history_incident,
                "neglected_source_for_reentry": source_payload,
                "previous_response_hash": cursor.get("response_hash")}
    acknowledged_head = commits[-1]["sha"] if commits and history_incident is None else old
    updated = {"head": acknowledged_head, "messages": {**seen, **{r: v for _, r, v in selected}},
               "source_index": index + 1, "response_hash": cursor.get("response_hash")}
    return envelope, updated


def session_file(name: str) -> Path: return SESSIONS / f"{name}.json"


def read_session(name: str, provider: str) -> str | None:
    path = session_file(name)
    if not path.exists(): return None
    data = json.loads(path.read_text())
    if data["provider"] != provider: raise ValueError(f"worker {name} changed provider")
    return str(data["session_id"])


def create_session_record(name: str, provider: str, session_id: str) -> None:
    SESSIONS.mkdir(parents=True, exist_ok=True)
    with session_file(name).open("x") as f:
        json.dump({"name": name, "provider": provider, "session_id": session_id,
                   "worktree": str(worker_worktree(name))}, f, indent=2); f.write("\n")


def worker_worktree(name: str) -> Path: return WORKTREES / name


def ensure_worktree(name: str) -> Path:
    target = worker_worktree(name)
    if target.is_dir(): return target
    WORKTREES.mkdir(parents=True, exist_ok=True)
    branch = f"worker/{name}"
    known = subprocess.run(["git", "show-ref", "--verify", "--quiet", f"refs/heads/{branch}"], cwd=REPO)
    command = ["git", "worktree", "add"]
    if known.returncode != 0: command += ["-b", branch]
    command += [str(target), branch if known.returncode == 0 else "HEAD"]
    done = subprocess.run(command, cwd=REPO, text=True, capture_output=True)
    if done.returncode != 0: raise RuntimeError(f"worktree creation failed for {name}: {done.stderr}")
    return target


def codex_session(stdout: str) -> str:
    for line in stdout.splitlines():
        try: event = json.loads(line)
        except json.JSONDecodeError: continue
        if event.get("type") in {"thread.started", "session.started"}:
            value = event.get("thread_id") or event.get("session_id")
            if value: return str(value)
    raise RuntimeError("Codex did not emit a session id")


def invoke(task: dict[str, object], prompt: str, turn_dir: Path) -> tuple[subprocess.CompletedProcess[str], str, str]:
    name, provider = str(task["name"]), str(task["provider"])
    worktree = ensure_worktree(name); sid = read_session(name, provider); last = turn_dir / "last.md"
    if provider == "codex":
        if sid:
            command = [executable("codex"), "exec", "resume", sid, "-", "--json", "--output-last-message", str(last)]
        else:
            command = [executable("codex"), "exec", "-", "--cd", str(worktree), "--sandbox", "workspace-write",
                       "--json", "--color", "never", "--output-last-message", str(last)]
        done = subprocess.run(command, cwd=worktree, input=prompt, text=True, capture_output=True)
        if not sid and done.returncode == 0: sid = codex_session(done.stdout); create_session_record(name, provider, sid)
        response = last.read_text() if last.exists() else done.stdout
    else:
        if sid:
            command = [executable("claude"), "--print", "--resume", sid, "--output-format", "text", prompt]
        else:
            sid = str(uuid.uuid4())
            command = [executable("claude"), "--print", "--session-id", sid, "--name", name,
                       "--output-format", "text", prompt]
        done = subprocess.run(command, cwd=worktree, text=True, capture_output=True)
        if not read_session(name, provider) and done.returncode == 0: create_session_record(name, provider, sid)
        response = done.stdout
    return done, response, sid or ""


def run_turn(task: dict[str, object], run_dir: Path, cycle: int) -> dict[str, object]:
    name = str(task["name"]); turn_dir = run_dir / f"{name}--{cycle:04d}"; turn_dir.mkdir()
    existing = read_session(name, str(task["provider"]))
    sync = sync_clean_worker(name, git_output(REPO, "rev-parse", "HEAD"))
    if sync["dirty"] or sync["conflicts"] or sync["sync"] in {"blocked-divergence", "fast-forward-failed"}:
        result = {"name": name, "provider": task["provider"], "cycle": cycle,
                  "session_id": existing, "resumed": existing is not None, "returncode": 2,
                  "broadcast": None, "incident": sync}
        (turn_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n")
        return result
    cursor = read_cursor(name); envelope, next_cursor = field_envelope(task, cursor, sync)
    prompt = (render_pulse(task, cycle, envelope) if existing else
              render_initial(task) + "\n\n## Initial field envelope\n```json\n" + json.dumps(envelope, indent=2) + "\n```\n")
    (turn_dir / "prompt.md").write_text(prompt)
    done, response, sid = invoke(task, prompt, turn_dir)
    (turn_dir / "stdout.log").write_text(done.stdout); (turn_dir / "stderr.log").write_text(done.stderr)
    result = {"name": name, "provider": task["provider"], "cycle": cycle, "session_id": sid,
              "resumed": existing is not None, "returncode": done.returncode, "broadcast": None}
    postflight = preflight(name)
    result["postflight"] = postflight
    if done.returncode == 0 and response.strip() and not postflight["conflicts"]:
        broadcast = OUTBOX / f"{run_dir.name}--{name}--{cycle:04d}.md"
        with broadcast.open("x") as f: f.write(response.rstrip() + "\n")
        result["broadcast"] = str(broadcast.relative_to(REPO))
        next_cursor["response_hash"] = hashlib.sha256(response.encode()).hexdigest()
        write_cursor(name, next_cursor)
    elif postflight["conflicts"]:
        result["returncode"] = 4
        result["incident"] = "provider left unresolved Git conflicts; delivery cursor retained"
    (turn_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main() -> int:
    p = argparse.ArgumentParser(); p.add_argument("tasks", nargs="?", type=Path)
    p.add_argument("--jobs", type=int, default=max(1, min(8, os.cpu_count() or 1)))
    p.add_argument("--cycles", type=int, default=1, help="turns per mind; 0 means continue until STOP file")
    p.add_argument("--delay", type=float, default=0.0); p.add_argument("--detect", action="store_true")
    p.add_argument("--status", action="store_true"); p.add_argument("--live-context", action="store_true")
    p.add_argument("--stop", action="store_true")
    p.add_argument("--clear-stop", action="store_true")
    args = p.parse_args()
    if args.detect: print(json.dumps(capability_report(), indent=2)); return 0
    if args.stop: STOP.touch(exist_ok=True); print(STOP); return 0
    if args.clear_stop: STOP.unlink(missing_ok=True); return 0
    if args.live_context:
        print(json.dumps(live_context(), indent=2)); return 0
    if args.status:
        sessions = [json.loads(x.read_text()) for x in sorted(SESSIONS.glob("*.json"))] if SESSIONS.exists() else []
        print(json.dumps({"stopped": STOP.exists(), "sessions": sessions}, indent=2)); return 0
    if not args.tasks: p.error("tasks JSONL required")
    tasks = load_tasks(args.tasks.resolve(), require_journal=True)
    OUTBOX.mkdir(parents=True, exist_ok=True); RUNS.mkdir(parents=True, exist_ok=True)
    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ"); run_dir = RUNS / stamp; run_dir.mkdir()
    (run_dir / "capabilities.json").write_text(json.dumps(capability_report(), indent=2) + "\n")
    results=[]; cycle=1; failures = {str(task["name"]): 0 for task in tasks}; retry_after = {str(task["name"]): 0.0 for task in tasks}
    while args.cycles == 0 or cycle <= args.cycles:
        if STOP.exists(): break
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
            now = time.monotonic()
            eligible = [task for task in tasks if now >= retry_after[str(task["name"])]]
            futures = {pool.submit(run_turn, task, run_dir, cycle): task for task in eligible}
            for future in concurrent.futures.as_completed(futures):
                task = futures[future]
                try: result = future.result(); results.append(result)
                except Exception as error:
                    result = {"name": task["name"], "provider": task["provider"], "cycle": cycle,
                              "session_id": None, "resumed": False, "returncode": 3,
                              "broadcast": None, "incident": repr(error)}; results.append(result)
                name = str(task["name"])
                if result["returncode"] == 0: failures[name] = 0; retry_after[name] = 0.0
                else:
                    failures[name] += 1
                    retry_after[name] = time.monotonic() + min(FAILURE_BACKOFF_CAP, 2.0 ** min(failures[name], 8))
        cycle += 1
        if args.delay: time.sleep(args.delay)
        elif not futures: time.sleep(1.0)
    results.sort(key=lambda x:(x["cycle"],x["name"])); (run_dir/"manifest.json").write_text(json.dumps(results,indent=2)+"\n")
    print(json.dumps({"run":str(run_dir.relative_to(REPO)),"turns":results},indent=2))
    return 0 if all(x["returncode"]==0 for x in results) else 1


if __name__ == "__main__": raise SystemExit(main())
