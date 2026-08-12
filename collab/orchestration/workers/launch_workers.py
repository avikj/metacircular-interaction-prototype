#!/usr/bin/env python3
"""Pulse durable Codex/Claude minds; append every turn and broadcast."""
from __future__ import annotations

import argparse, concurrent.futures, datetime as dt, json, os, shutil, subprocess, time, uuid
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
PROMPT = HERE / "worker_prompt.md"
OUTBOX = REPO / "collab/messages/workers"
RUNS = REPO / "collab/orchestration/worker-runs"
SESSIONS = REPO / "collab/orchestration/worker-sessions"
WORKTREES = REPO.parent / f"{REPO.name}-workers"
STOP = HERE / "STOP"


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


def load_tasks(path: Path) -> list[dict[str, object]]:
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
        names.add(name); tasks.append(task)
    return tasks


def render_initial(task: dict[str, object]) -> str:
    context = "\n".join(f"- `{x}`" for x in task.get("context", [])) or "- `README.md`"
    return (PROMPT.read_text() + f"\nPersistent worker: {task['name']} ({task['provider']})\n"
            f"\nContinuing objective:\n{task['task']}\n\nInitial context:\n{context}\n"
            "After each turn, your response is broadcast. Expect an immediate continuation pulse; "
            "retain unresolved questions and continue the same investigation.\n")


def render_pulse(task: dict[str, object], cycle: int) -> str:
    return str(task.get("pulse") or
        f"Continuation pulse {cycle}. Read broadcasts added since your last turn. Continue the same objective autonomously. Pursue the strongest live implication, correct prior errors, and return a signed repo-ready broadcast. Do not restart or summarize unless the mathematics requires it.")


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
    prompt = render_pulse(task, cycle) if existing else render_initial(task)
    (turn_dir / "prompt.md").write_text(prompt)
    done, response, sid = invoke(task, prompt, turn_dir)
    (turn_dir / "stdout.log").write_text(done.stdout); (turn_dir / "stderr.log").write_text(done.stderr)
    result = {"name": name, "provider": task["provider"], "cycle": cycle, "session_id": sid,
              "resumed": existing is not None, "returncode": done.returncode, "broadcast": None}
    if done.returncode == 0 and response.strip():
        broadcast = OUTBOX / f"{run_dir.name}--{name}--{cycle:04d}.md"
        with broadcast.open("x") as f: f.write(response.rstrip() + "\n")
        result["broadcast"] = str(broadcast.relative_to(REPO))
    (turn_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main() -> int:
    p = argparse.ArgumentParser(); p.add_argument("tasks", nargs="?", type=Path)
    p.add_argument("--jobs", type=int, default=max(1, min(8, os.cpu_count() or 1)))
    p.add_argument("--cycles", type=int, default=1, help="turns per mind; 0 means continue until STOP file")
    p.add_argument("--delay", type=float, default=0.0); p.add_argument("--detect", action="store_true")
    p.add_argument("--status", action="store_true"); p.add_argument("--stop", action="store_true")
    p.add_argument("--clear-stop", action="store_true")
    args = p.parse_args()
    if args.detect: print(json.dumps(capability_report(), indent=2)); return 0
    if args.stop: STOP.touch(exist_ok=True); print(STOP); return 0
    if args.clear_stop: STOP.unlink(missing_ok=True); return 0
    if args.status:
        sessions = [json.loads(x.read_text()) for x in sorted(SESSIONS.glob("*.json"))] if SESSIONS.exists() else []
        print(json.dumps({"stopped": STOP.exists(), "sessions": sessions}, indent=2)); return 0
    if not args.tasks: p.error("tasks JSONL required")
    tasks = load_tasks(args.tasks.resolve()); OUTBOX.mkdir(parents=True, exist_ok=True); RUNS.mkdir(parents=True, exist_ok=True)
    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ"); run_dir = RUNS / stamp; run_dir.mkdir()
    (run_dir / "capabilities.json").write_text(json.dumps(capability_report(), indent=2) + "\n")
    results=[]; cycle=1
    while args.cycles == 0 or cycle <= args.cycles:
        if STOP.exists(): break
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
            results.extend(f.result() for f in concurrent.futures.as_completed(
                [pool.submit(run_turn, task, run_dir, cycle) for task in tasks]))
        if any(x["returncode"] != 0 for x in results[-len(tasks):]): break
        cycle += 1
        if args.delay: time.sleep(args.delay)
    results.sort(key=lambda x:(x["cycle"],x["name"])); (run_dir/"manifest.json").write_text(json.dumps(results,indent=2)+"\n")
    print(json.dumps({"run":str(run_dir.relative_to(REPO)),"turns":results},indent=2))
    return 0 if all(x["returncode"]==0 for x in results) else 1


if __name__ == "__main__": raise SystemExit(main())
