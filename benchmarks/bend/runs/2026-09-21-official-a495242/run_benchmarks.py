#!/usr/bin/env python3
"""Run unmodified official Bend workloads sequentially, with auditable logs."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import threading
import time

ROOT = Path(os.environ.get('BEND_BENCH_TASK_DIR', str(Path(__file__).resolve().parent))).resolve()
SRC = ROOT / 'bend-a49524265bdfa5753a4bf38e25f0574a705dd868'
OUT = ROOT / 'results'
SELECT = None
BUN = ROOT / 'bun-darwin-aarch64/bun'
NODE = ROOT / 'node-v24.21.0-darwin-arm64/bin/node'
LEAN = ROOT / 'lean-4.34.0-darwin_aarch64/bin/lean'
LEANC = LEAN.with_name('leanc')
CLI = SRC / 'bend2/main.ts'
GPU_MEMORY = {'tree-bitonic': '768MB', 'gameoflife': '512MB', 'kmeans': '768MB',
              'mandelbrot': '512MB', 'merkle': '768MB', 'nbody': '768MB',
              'queens': '512MB', 'raytrace': '512MB', 'symreg': '512MB', 'terrain': '1GB'}
ENV = dict(os.environ, BEND_NO_TELEMETRY='1', TMPDIR=str(ROOT / 'tmp'),
           CLANG_MODULE_CACHE_PATH=str(ROOT / 'clang-cache'))
ENV['PATH'] = ':'.join([str(BUN.parent), str(NODE.parent), str(LEAN.parent),
                      '/opt/homebrew/bin', '/usr/bin', '/bin', '/usr/sbin', '/sbin'])
ENV['CC'] = '/usr/bin/clang'
ROCQ_RES = ROOT / 'Rocq-Platform-release-2026.07.0-version-9.1-2026.07-MacOS-arm64/Rocq-Platform-9.1-2026.07.app/Contents/Resources'
ENV['ROCQLIB'] = str(ROCQ_RES / 'lib/coq')
ENV['COQLIB'] = ENV['ROCQLIB']
ENV['OCAMLPATH'] = str(ROCQ_RES / 'lib')
ENV['ISABELLE_HOME_USER'] = str(ROOT / 'isabelle-user')
MAX_RSS_KIB = 3 * 1024 * 1024

def capture(cmd):
    r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    return r.stdout.strip()

def record(rec):
    rec['recorded_utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    with (OUT / 'records.jsonl').open('a') as f:
        f.write(json.dumps(rec) + '\n')
    print(json.dumps({k: rec.get(k) for k in ['suite', 'bench', 'lane', 'phase', 'status',
                                           'wall_s', 'max_rss_mib', 'output_match']}), flush=True)
    return rec

def run(suite, bench, lane, phase, cmd, cwd, timeout=600, expected=None, check=True):
    ident = f'{suite}__{bench}__{lane}__{phase}'
    original_ident=ident
    attempt=1
    while (OUT/'logs'/(ident+'.stdout')).exists():
        attempt+=1
        ident=original_ident+'.attempt-'+str(attempt)
    stdout = OUT / 'logs' / (ident + '.stdout')
    stderr = OUT / 'logs' / (ident + '.stderr')
    if not Path(cmd[0]).exists() and shutil.which(str(cmd[0]), path=ENV['PATH']) is None:
        return record(dict(suite=suite, bench=bench, lane=lane, phase=phase,
                           status='unavailable', command=list(map(str,cmd))))
    before_load = os.getloadavg()
    done = threading.Event()
    abort = []
    peak_group = [0]
    wrapped = ['/usr/bin/time', '-l'] + list(map(str, cmd))
    start = time.perf_counter()
    with stdout.open('w') as fo, stderr.open('w') as fe:
        proc = subprocess.Popen(wrapped, cwd=cwd, env=ENV, stdout=fo, stderr=fe,
                                start_new_session=True)
        def watch():
            while not done.wait(2):
                why = None
                owned = set()
                if time.perf_counter() - start > timeout:
                    why = 'timeout'
                try:
                    ps = subprocess.check_output(['/bin/ps', '-axo', 'pid=,ppid=,pgid=,rss='], text=True)
                    procs=[list(map(int,x.split())) for x in ps.splitlines() if len(x.split())==4]
                    owned={proc.pid}
                    while True:
                        expanded=owned | {pid for pid,ppid,pgid,rss in procs if ppid in owned or pgid==proc.pid}
                        if expanded==owned:break
                        owned=expanded
                    rss=sum(rss for pid,ppid,pgid,rss in procs if pid in owned)
                    peak_group[0] = max(peak_group[0], rss)
                    if rss > MAX_RSS_KIB:
                        why = 'memory_limit_3GiB'
                except (OSError, subprocess.SubprocessError):
                    pass
                if why:
                    if proc.poll() is not None:
                        return
                    abort.append(why)
                    for pid in owned-{proc.pid}:
                        try:os.kill(pid,signal.SIGKILL)
                        except ProcessLookupError:pass
                    try:
                        os.killpg(proc.pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    return
        watcher = threading.Thread(target=watch, daemon=True)
        watcher.start()
        rc = proc.wait()
        wall = time.perf_counter() - start
        done.set()
        watcher.join()
    out = stdout.read_text(errors='replace').strip()
    err = stderr.read_text(errors='replace')
    rss = re.search(r'(\d+)\s+maximum resident set size', err)
    times = re.search(r'([\d.]+)\s+real\s+([\d.]+)\s+user\s+([\d.]+)\s+sys', err)
    status = abort[0] if abort else ('ok' if rc == 0 else 'error')
    last = out.splitlines()[-1].strip() if out else ''
    match = None if expected is None else last == str(expected)
    if status == 'ok' and check and match is False:
        status = 'wrong_output'
    return record(dict(suite=suite, bench=bench, lane=lane, phase=phase, status=status,
                       command=list(map(str,cmd)), cwd=str(cwd), wall_s=wall,
                       cc_environment=ENV.get('CC'),
                       time_real_s=float(times[1]) if times else None,
                       user_s=float(times[2]) if times else None,
                       sys_s=float(times[3]) if times else None,
                       max_rss_mib=int(rss[1]) / 1048576 if rss else None,
                       sampled_group_peak_mib=peak_group[0] / 1024,
                       returncode=rc, expected=expected, output_match=match,
                       output_check_enforced=check, output_tail=out[-500:],
                       error_tail=err[-1500:], load_before=before_load, load_after=os.getloadavg(),
                       stdout=str(stdout), stderr=str(stderr)))

def initialize():
    for p in [OUT / 'logs', ROOT / 'tmp', ROOT / 'build', ROOT / 'clang-cache']:
        p.mkdir(parents=True, exist_ok=True)
    if not (OUT / 'metadata.json').exists():
        hashes = {str(p.relative_to(SRC)): hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in (SRC / 'bench').rglob('*') if p.is_file()}
        meta = dict(source_commit='a49524265bdfa5753a4bf38e25f0574a705dd868',
                    source='https://github.com/bendlang/bend',
                    hardware=capture(['/usr/sbin/sysctl', '-n', 'machdep.cpu.brand_string']),
                    hardware_detail=capture(['/usr/sbin/sysctl', 'hw.memsize', 'hw.logicalcpu',
                                              'hw.physicalcpu', 'hw.perflevel0.physicalcpu',
                                              'hw.perflevel1.physicalcpu']),
                    os=capture(['/usr/bin/sw_vers']), cc=capture(['/usr/bin/cc', '--version']),
                    bun=capture([str(BUN), '--version']), node=capture([str(NODE), '--version']),
                    agda=capture(['/opt/homebrew/bin/agda', '--version']),
                    start_load=os.getloadavg(),
                    conditions='Shared personal machine; no CPU affinity/frequency locking; one benchmark process at a time.',
                    methodology='Official unmodified full-size workloads, 1 warmup + 1 timed runtime process; checker fresh source dirs; no telemetry. External monotonic wall timer plus /usr/bin/time -l. RSS process-group watchdog every 2s, limit 3 GiB; runtime 600s, checker 300s.',
                    hashes=hashes)
        (OUT / 'metadata.json').write_text(json.dumps(meta, indent=2)+'\n')
        (OUT / 'processes-before.txt').write_text(capture(['/bin/ps', '-axo', 'pid,pcpu,rss,comm']))
        (OUT / 'power-before.txt').write_text(capture(['/usr/bin/pmset', '-g', 'batt']))
        (OUT / 'memory-before.txt').write_text(capture(['/usr/bin/vm_stat']))

def outputs():
    rows = (SRC / 'bench/runtime/_pin_/apple_m4.txt').read_text().splitlines()
    return {x.split('|')[1].strip(): x.split('|')[-2].strip()
            for x in rows if x.startswith('|') and x.split('|')[-2].strip().isdigit()}

def runtime(lanes):
    nt = 1
    while nt * 2 <= os.cpu_count() and nt < 256:
        nt *= 2
    for home in sorted((SRC / 'bench/runtime').iterdir()):
        if home.name.startswith('_'): continue
        bench = home.name
        work = ROOT / 'build' / bench
        work.mkdir(exist_ok=True)
        want = outputs()[bench]
        if any(x.startswith('bend-') for x in lanes):
            r = run('runtime', bench, 'bend', 'emit-c', [BUN, CLI, home/'main.bend', '-o', work/'main.c'], work)
            if r['status'] != 'ok': continue
        for lane in lanes:
            flags = ['-std=c11', '-O3']
            check = True
            if lane in ('bend-seq', 'bend-par'):
                bin = work/'bend-cpu'
                if not bin.exists():
                    r = run('runtime', bench, 'bend-cpu', 'build', ['/usr/bin/cc', *flags, work/'main.c', '-lpthread', '-o', bin], work)
                    if r['status'] != 'ok': continue
                cmd = [bin, '--threads', '1' if lane=='bend-seq' else str(nt), '--gpu', 'off']
            elif lane == 'bend-gpu':
                bin = work/'bend-gpu'
                r = run('runtime', bench, lane, 'build', ['/usr/bin/cc', *flags, '-DBEND_METAL=1', '-x', 'objective-c', '-fobjc-arc', work/'main.c', '-lpthread', '-framework', 'Metal', '-framework', 'Foundation', '-o', bin], work)
                if r['status'] != 'ok': continue
                cmd = [bin, '--gpu', GPU_MEMORY.get(bench, 'on')]
            elif lane == 'c':
                bin = work/'twin-c'
                r = run('runtime', bench, lane, 'build', ['/usr/bin/cc', *flags, home/'main.c', '-o', bin], work)
                if r['status'] != 'ok': continue
                check = 'F32' not in (home/'main.bend').read_text()
                cmd = [bin]
            elif lane in ('ts-bun', 'ts-node'):
                cmd = [BUN if lane=='ts-bun' else NODE, home/'main.ts']
            elif lane == 'lean':
                shutil.copy2(home/'main.lean', work/'main.lean')
                r = run('runtime', bench, lane, 'emit-c', [LEAN, 'main.lean', '-c', 'lean.c'], work)
                if r['status'] != 'ok': continue
                r = run('runtime', bench, lane, 'build', [LEANC, '-O3', '-DNDEBUG', 'lean.c', '-o', 'twin-lean'], work)
                if r['status'] != 'ok': continue
                cmd = [work/'twin-lean']
            else: raise ValueError(lane)
            warm = run('runtime', bench, lane, 'warmup', cmd, work, expected=want, check=check)
            if warm['status'] in ('timeout', 'memory_limit_3GiB', 'error', 'unavailable'):
                continue
            run('runtime', bench, lane, 'timed', cmd, work, expected=want, check=check)

def checker(lanes):
    for home in sorted((SRC/'bench/checker').iterdir()):
        if home.name.startswith('_'): continue
        if SELECT is not None and home.name not in SELECT:continue
        for lane in lanes:
            ext = {'bend':'bend', 'agda':'agda', 'lean':'lean', 'rocq':'v', 'isabelle':'thy'}[lane]
            src = home/('main.'+ext)
            if not src.exists():
                record(dict(suite='checker', bench=home.name, lane=lane, phase='timed', status='not_supplied'))
                continue
            work = ROOT/'build'/('checker-'+home.name+'-'+lane)
            work.mkdir(exist_ok=True)
            shutil.copy2(src, work/src.name)
            if lane=='bend':cmd=[BUN, CLI, work/'main.bend']
            elif lane=='agda':cmd=['/opt/homebrew/bin/agda', 'main.agda']
            elif lane=='lean':cmd=[LEAN, 'main.lean']
            elif lane=='rocq':cmd=[ROOT/'rocq-bin/rocq', 'compile', 'main.v']
            else:
                (work/'ROOT').write_text('session bench = HOL +\n  theories\n    main\n')
                cmd=[ROOT/'isabelle-bin/isabelle', 'build', '-c', '-D', '.']
            run('checker', home.name, lane, 'timed', cmd, work, timeout=300)

def compiler(lanes):
    for home in sorted((SRC/'bench/runtime').iterdir()):
        if home.name.startswith('_'): continue
        work=ROOT/'build'/home.name
        work.mkdir(exist_ok=True)
        cmd=[BUN, CLI, home/'main.bend', '-o', work/'official-compiled']
        warm=run('compiler', home.name, 'bend', 'warmup', cmd, work)
        if warm['status']=='ok':
            run('compiler', home.name, 'bend', 'timed', cmd, work)
    if 'build-only' in lanes:return
    # Separate correctness diagnostic, never substituted into official timings.
    for name in ['nbody','raytrace']:
        home=SRC/'bench/runtime'/name
        work=ROOT/'build'/name
        binary=work/'c-no-fma'
        built=run('diagnostic', name, 'c-no-fma', 'build',
                  ['/usr/bin/cc','-std=c11','-O3','-ffp-contract=off',home/'main.c','-o',binary],work)
        if built['status']=='ok':
            run('diagnostic',name,'c-no-fma','validate',[binary],work,expected=outputs()[name])
    work=ROOT/'build/bfs'
    for lane,nt in [('bend-seq',1),('bend-par',4)]:
        for k in range(3):
            run('diagnostic','bfs',lane,'repeat-'+str(k+1),
                [work/'bend-cpu','--threads',str(nt),'--gpu','off'],work,expected=outputs()['bfs'])

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('suite', choices=['runtime','checker','compiler'])
    ap.add_argument('--lanes', required=True)
    ap.add_argument('--only', default='')
    args=ap.parse_args()
    SELECT=set(args.only.split(',')) if args.only else None
    initialize()
    {'runtime':runtime,'checker':checker,'compiler':compiler}[args.suite](args.lanes.split(','))
    (OUT/'processes-after.txt').write_text(capture(['/bin/ps', '-axo', 'pid,pcpu,rss,comm']))
    print('SUITE COMPLETE', args.suite, args.lanes, flush=True)
