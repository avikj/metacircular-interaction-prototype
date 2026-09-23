#!/usr/bin/env python3
"""Isolated macOS runs of the pinned official Bend suite. No fork adapter yet."""
import argparse
import csv
import fcntl
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import platform
import shutil
import sys
import time
import uuid

HOME = Path(__file__).resolve().parent
LOCK = json.loads((HOME / 'suite.lock.json').read_text())
LANES = {'runtime': ['bend-seq', 'bend-par', 'bend-gpu', 'c', 'ts-bun', 'ts-node', 'lean'],
         'checker': ['bend', 'agda', 'lean', 'rocq', 'isabelle'], 'compiler': ['build-only']}

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def verify(source):
    bad = [name for name, sha in LOCK['sha256'].items()
           if not (source / name).is_file() or digest(source / name) != sha]
    actual = {str(p.relative_to(source)) for folder in ['bench', 'bend2']
              for p in (source / folder).rglob('*') if p.is_file()}
    bad += sorted(actual - LOCK['sha256'].keys())
    if bad:
        raise SystemExit('Pinned source verification failed: ' + ', '.join(bad[:12]))

def engine(cache, work, out, source, selected):
    spec = importlib.util.spec_from_file_location('bend_engine', HOME / 'lib/engine.py')
    e = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(e)
    e.ROOT, e.OUT, e.SRC = work, out, source
    e.CLI = source / 'bend2/main.ts'
    e.SELECT = selected
    e.BUN = cache / 'bun-darwin-aarch64/bun'
    e.NODE = cache / 'node-v24.21.0-darwin-arm64/bin/node'
    e.LEAN = cache / 'lean-4.34.0-darwin_aarch64/bin/lean'
    e.LEANC = e.LEAN.with_name('leanc')
    e.ENV.update(TMPDIR=str(work / 'tmp'), CLANG_MODULE_CACHE_PATH=str(work / 'clang-cache'),
                 PATH=os.pathsep.join([str(e.BUN.parent), str(e.NODE.parent), str(e.LEAN.parent),
                                      '/opt/homebrew/bin', '/usr/bin', '/bin', '/usr/sbin', '/sbin']))
    for name in ['rocq-bin', 'isabelle-bin']:
        (work / name).symlink_to(cache / name, target_is_directory=True)
    rocq = cache / 'Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources'
    e.ENV.update(ROCQLIB=str(rocq / 'lib/coq'), COQLIB=str(rocq / 'lib/coq'),
                 OCAMLPATH=str(rocq / 'lib'), ISABELLE_HOME_USER=str(cache / 'isabelle-user'))
    return e

def report(out):
    records = [json.loads(line) for line in (out / 'records.jsonl').read_text().splitlines()]
    fields = ['suite', 'bench', 'lane', 'phase', 'status', 'wall_s', 'max_rss_mib', 'output_match']
    with (out / 'invocations.csv').open('w') as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(records)
    rows = ['# Run observations', '', 'One warmup and one measured runtime/build process; checker has one measured invocation.',
            'Shared-machine observations, not an isolated performance ranking. See manifest.json and raw logs.', '',
            '| Suite | Benchmark | Lane | Phase | Status | Wall seconds |', '|---|---|---|---|---|---:|']
    for r in records:
        rows.append('| ' + ' | '.join(str(r.get(k, '')) for k in fields[:6]) + ' |')
    (out / 'REPORT.md').write_text('\n'.join(rows) + '\n')
    return any(r['status'] not in ['ok', 'not_supplied'] for r in records)

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('command', choices=['doctor', 'run'])
    p.add_argument('--cache', type=Path, default=HOME / 'local/toolchains/2026-09-21')
    p.add_argument('--suite', choices=[*LANES, 'all'], default='all')
    p.add_argument('--lanes', help='Comma-separated lanes; requires one suite')
    p.add_argument('--only', help='Comma-separated benchmark names')
    p.add_argument('--repetitions', type=int, default=1, help='Independent fresh runs (default: 1)')
    args = p.parse_args()
    if platform.system() != 'Darwin' or platform.machine() != 'arm64':
        p.error('This adapter currently requires macOS arm64; Linux/CUDA are not implemented.')
    if args.repetitions < 1:
        p.error('--repetitions must be positive')
    if args.lanes and args.suite == 'all':
        p.error('--lanes requires one suite')
    suites = list(LANES) if args.suite == 'all' else [args.suite]
    lanes = {s: args.lanes.split(',') if args.lanes else LANES[s] for s in suites}
    for s in suites:
        if set(lanes[s]) - set(LANES[s]):
            p.error('Unknown lane for ' + s)
    cache = args.cache.resolve()
    source = cache / LOCK['source_directory']
    verify(source)
    selected = set(args.only.split(',')) if args.only else None
    names = {h.name for s in suites for h in (source / 'bench' / ('runtime' if s == 'compiler' else s)).iterdir()
             if h.is_dir() and not h.name.startswith('_')}
    if selected and selected - names:
        p.error('Unknown benchmark: ' + ', '.join(sorted(selected - names)))
    tools = {'bun': cache / 'bun-darwin-aarch64/bun', 'node': cache / 'node-v24.21.0-darwin-arm64/bin/node',
             'lean': cache / 'lean-4.34.0-darwin_aarch64/bin/lean', 'agda': Path('/opt/homebrew/bin/agda'),
             'rocq': cache / 'rocq-bin/rocq', 'isabelle': cache / 'isabelle-bin/isabelle', 'clang': Path('/usr/bin/clang')}
    required = {'bun', 'node', 'agda', 'clang'}  # metadata collection uses these as well
    for s, modes in lanes.items():
        for mode in modes:
            if mode in ['lean', 'rocq', 'isabelle']: required.add(mode)
    missing = [k for k in required if not os.access(tools[k], os.X_OK)]
    print(json.dumps({'source': str(source), 'source_verified': True,
                      'tools': {k: str(v) for k, v in tools.items()}, 'missing_required': missing}, indent=2))
    if missing:
        raise SystemExit('Missing tools; see SETUP.md. No benchmark started.')
    if args.command == 'doctor':
        return
    guard = (cache / 'campaign.lock').open('a')
    try:
        fcntl.flock(guard, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        raise SystemExit('Another campaign is using these toolchains; run sequentially.')
    failed = False
    for _ in range(args.repetitions):
        ident = time.strftime('%Y%m%dT%H%M%SZ', time.gmtime()) + '-official-' + uuid.uuid4().hex[:8]
        out, work = HOME / 'runs' / ident, HOME / 'work' / ident
        out.mkdir(parents=True, exist_ok=False)
        work.mkdir(parents=True, exist_ok=False)
        # A run never compiles in the shared source tree or reuses checker build output.
        snapshot = work / 'source'
        shutil.copytree(source, snapshot)
        verify(snapshot)
        for rel in ['bench.py', 'lib/engine.py', 'suite.lock.json']:
            dst = out / 'harness' / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(HOME / rel, dst)
        manifest = {'target': 'official-public', 'suite_commit': LOCK['commit'], 'lanes': lanes,
                    'only': sorted(selected) if selected else None, 'work': str(work), 'cache': str(cache),
                    'argv': sys.argv, 'python': sys.version, 'platform': platform.platform(),
                    'harness_sha256': {r: digest(HOME / r) for r in ['bench.py', 'lib/engine.py', 'suite.lock.json']},
                    'state': 'running', 'started_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}
        (out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
        print('RUN:', out, flush=True)
        e = engine(cache, work, out, snapshot, selected)
        try:
            e.initialize()
            for s in suites:
                getattr(e, s)(lanes[s])
            bad = report(out)
            failed |= bad
            manifest['state'] = 'completed_with_failures' if bad else 'completed'
        except BaseException:
            manifest['state'] = 'interrupted_or_failed'
            if (out / 'records.jsonl').exists(): report(out)
            raise
        finally:
            for name, cmd in [('power', ['/usr/bin/pmset', '-g', 'batt']),
                              ('memory', ['/usr/bin/vm_stat']), ('processes', ['/bin/ps', '-axo', 'pid,pcpu,rss,comm'])]:
                (out / (name + '-after.txt')).write_text(e.capture(cmd))
            manifest['finished_utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
            (out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    if failed:
        raise SystemExit(1)

if __name__ == '__main__':
    main()
