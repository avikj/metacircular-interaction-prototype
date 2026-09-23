import collections
import csv
import hashlib
import json
from pathlib import Path
import statistics
from describe_benchmarks import RUNTIME, CHECKER

ROOT=Path(__file__).resolve().parent
OUT=ROOT/'results'
SRC=ROOT/'bend-a49524265bdfa5753a4bf38e25f0574a705dd868'
records=[json.loads(s) for s in (OUT/'records.jsonl').read_text().splitlines() if s.strip()]
meta=json.loads((OUT/'metadata.json').read_text())
lanes=['bend-seq','bend-par','bend-gpu','c','ts-bun','ts-node','lean']
clanes=['bend','agda','lean','rocq','isabelle']

def cell(suite, bench, lane):
    rr=[x for x in records if x['suite']==suite and x['bench']==bench and x['lane']==lane]
    tt=[x for x in rr if x['phase']=='timed']
    if tt:return tt[-1]
    bad=[x for x in rr if x['status']!='ok']
    if bad:return bad[-1]
    return dict(suite=suite,bench=bench,lane=lane,status='pending')

def show(r):
    if r['status']=='ok':
        return f"{r['wall_s']:.3f}"+('*' if r.get('output_check_enforced') is False else '')
    if r['status']=='error' and 'stderr' in r and 'JavaScript heap out of memory' in Path(r['stderr']).read_text(errors='replace'):
        return 'JS heap OOM'
    if r['status']=='timeout':return '>300' if r['suite']=='checker' else '>600'
    return {'not_supplied':'—','pending':'pending','memory_limit_3GiB':'RAM limit',
            'wrong_output':'wrong output','error':'error','timeout':'timeout',
            'unavailable':'unavailable'}[r['status']]

rows=[cell('runtime',b,l) for b,*_ in RUNTIME for l in lanes]
crows=[cell('checker',b,l) for b,*_ in CHECKER for l in clanes]
buildrows=[cell('compiler',b,'bend') for b,*_ in RUNTIME]
with (OUT/'runtime.csv').open('w') as f:
    fields=['bench','lane','status','wall_s','max_rss_mib','expected','output_match',
            'output_check_enforced','output_tail','phase']
    w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');w.writeheader();w.writerows(rows)
with (OUT/'checker.csv').open('w') as f:
    fields=['bench','lane','status','wall_s','max_rss_mib','phase']
    w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');w.writeheader();w.writerows(crows)
with (OUT/'compiler.csv').open('w') as f:
    fields=['bench','status','wall_s','max_rss_mib','phase']
    w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');w.writeheader();w.writerows(buildrows)

ok=sum(r['status']=='ok' for r in rows)
cok=sum(r['status']=='ok' for r in crows)
status=collections.Counter(r['status'] for r in rows)
changes=[p for p,h in meta['hashes'].items() if hashlib.sha256((SRC/p).read_bytes()).hexdigest()!=h]
lines=['# Official Bend benchmark results on this machine','',
       f'**Coverage:** {ok}/112 runtime combinations completed successfully; {cok}/21 supplied checker combinations completed successfully. Four checker combinations have no official source (`compute_1600` is Bend-only).', '',
       f'Runtime status: `{dict(status)}`.', '',
       '**Environment and scope**', '',
       f"- Source: `a49524265bdfa5753a4bf38e25f0574a705dd868`, Bend 2.0.25.",
       '- Apple A18 Pro, 8 GiB RAM, two performance cores plus four efficiency cores; macOS 26.6.',
       '- Bend CPU modes: one thread and four threads. Four matches the official chart runner’s power-of-two rule; it is not an all-six-core configuration. GPU: Metal, original per-case memory settings.',
       '- Toolchains: Bun 1.4.2, Node 24.21.0, Apple clang 21.0.0, Lean 4.34.0, Agda 2.8.0.1, Rocq 9.1.0, Isabelle2025-2. Per-tool versions and setup are recorded in the metadata/logs.',
       '- Unmodified full-size official workload files. One separate-process warmup then one measured runtime process; checker runs use fresh source directories. Builds are logged separately, outside runtime times.',
       '- Shared machine: other agents and desktop services remained active. Toolchain downloading/unpacking overlapped some initial runtime and checker runs. No CPU affinity, frequency locking or thermal stabilization. These are observations, not isolated performance rankings.',
       '- The machine began on battery power at 84% charge. Power settings were not altered; before/after battery and memory snapshots are included.',
       '- Parent monotonic wall clock includes process launch/exit and the `/usr/bin/time` wrapper. The latter also records CPU time and peak process RSS. GPU memory is not fully described by host RSS.',
       '- One benchmark process at a time. A watchdog samples process-group RSS every two seconds and terminates only that benchmark above 3 GiB or after 600 seconds (runtime) / 300 seconds (checker). Any such stop is labeled; it is not a measured completion time.',
       f'- Source integrity: {len(meta["hashes"])} benchmark/pin files hashed before execution; changed files: `{changes}`.', '',
       '**Runtime — elapsed seconds**', '',
       '| Workload | Bend 1 CPU | Bend 4 CPU | Bend GPU | C | TS/Bun | TS/Node | Lean |',
       '|---|---:|---:|---:|---:|---:|---:|---:|']
for b,*_ in RUNTIME:lines.append('| '+b+' | '+' | '.join(show(cell('runtime',b,l)) for l in lanes)+' |')
lines += ['', '*C rows marked with an asterisk contain F32 in the Bend source. As in the official runner, C output equality is not enforced for these cases because floating-point code generation can change the final checksum. The raw output and whether it matched are retained in runtime.csv and records.jsonl. Every other completed runtime cell must match the official checksum.*', '',
          '**Checker — elapsed seconds**', '',
          '| Workload | Bend | Agda | Lean | Rocq | Isabelle |', '|---|---:|---:|---:|---:|---:|']
for b,*_ in CHECKER:lines.append('| '+b+' | '+' | '.join(show(cell('checker',b,l)) for l in clanes)+' |')
lines += ['', 'Checker invocations time the entire tool process, including frontend and elaboration/build work. They do not isolate comparable proof kernels. “Fresh source directory” does not mean flushed OS caches. The prover encodings and required work differ.', '', '**Observed warmup/measurement variation**', '']
variation=[]
for r in rows:
    ww=[x for x in records if x['suite']=='runtime' and x['bench']==r['bench'] and x['lane']==r['lane'] and x['phase']=='warmup' and x['status']=='ok']
    if ww and r['status']=='ok':
        warm=ww[-1]['wall_s']; timed=r['wall_s']
        variation.append((max(warm,timed)/min(warm,timed),r['bench'],r['lane'],warm,timed))
lines += ['| Workload | Lane | Warmup seconds | Measured seconds | Larger/smaller |','|---|---|---:|---:|---:|']
for ratio,b,l,w,t in sorted(variation,reverse=True)[:12]:lines.append(f'| {b} | {l} | {w:.3f} | {t:.3f} | {ratio:.2f}× |')
lines += ['', 'Warmups are not statistically equivalent repetitions: first GPU execution can compile/cache a shader, and filesystem/cache state differs. Large CPU warmup/timed gaps nevertheless show why single-run rankings on this machine need caution.', '', '**Failures and limits**', '']
failures=[r for r in rows+crows+buildrows if r['status'] not in ('ok','not_supplied','pending')]
if not failures:lines+=['None recorded so far.']
for r in failures:
    lines += [f"- {r['suite']}/{r['bench']} — {r['lane']}: **{r['status']}** during {r.get('phase','unknown')}. Observed wall time {r.get('wall_s',0):.3f} s. See raw stderr/stdout logs."]
    if show(r)=='JS heap OOM':
        lines += ['  Node reported “JavaScript heap out of memory” under its default heap configuration. No larger heap flag was substituted into the official comparison.']
    if r['status']=='memory_limit_3GiB':
        lines += [f"  Sampled peak process-group RSS: {r.get('sampled_group_peak_mib',0):.1f} MiB. This is the task’s guard, not a proof that the workload cannot complete with more memory."]
diag=[r for r in records if r['suite']=='diagnostic' and r['phase']=='validate']
if diag:
    lines += ['', '**Floating-point output diagnostic**', '',
              'The original C timings above use the official `cc -std=c11 -O3` flags. Separate full-size validation runs add only `-ffp-contract=off`; their timings are not substituted into the main table.']
    for r in diag:
        lines += [f"- {r['bench']}: {r['status']}; output `{r.get('output_tail')}`; expected `{r.get('expected')}`; match = `{r.get('output_match')}`."]
repeat=[r for r in records if r['suite']=='diagnostic' and r['bench']=='bfs' and r['phase'].startswith('repeat-')]
if repeat:
    lines += ['', '**BFS follow-up samples after toolchain setup**', '',
              'The same compiled binaries and full workload were run three more times per CPU mode. These are separate diagnostic observations; they do not replace the original table values or constitute an isolated experiment.', '',
              '| Mode | Three elapsed times (s) | Median (s) |', '|---|---|---:|']
    for lane in ['bend-seq','bend-par']:
        ts=[r['wall_s'] for r in repeat if r['lane']==lane and r['status']=='ok']
        if ts:lines += [f'| {lane} | '+', '.join(f'{t:.3f}' for t in ts)+f' | {statistics.median(ts):.3f} |']
lines += ['', '**End-to-end Bend compiler — elapsed seconds**', '',
          'The same full native-build command used by the official gate is run twice per workload, timing the second separately from execution. This includes Bend frontend/code generation and native compilation; it is not just time spent in the Bend compiler implementation.', '',
          '| Workload | Native build seconds |', '|---|---:|']
for b,*_ in RUNTIME:lines.append('| '+b+' | '+show(cell('compiler',b,'bend'))+' |')
lines += ['', '**Toolchain setup and retries**', '',
          'The first integrated Bend native-build attempts selected Lean’s bundled Clang 22 from PATH and failed against Apple SDK modules. Corrected attempts explicitly select `/usr/bin/clang`, the Apple compiler used by the successful runtime builds. Rocq’s binary package required local library-path configuration and refreshed ad-hoc signatures for its worker/GMP dependency; its archive digest matched the official release. These changes affect only the temporary toolchain installation. Benchmark sources remain unchanged. Initial failures and subsequent attempts are retained in records.jsonl and separate log files. See [setup details](toolchain-setup.json).', '']
lines += ['', '**Files**', '',
          '- [Every benchmark explained](../BENCHMARKS.md)',
          '- [Runtime data](runtime.csv)', '- [Checker data](checker.csv)',
          '- [Native compiler data](compiler.csv)',
          '- [Every invocation, command, timing, output and status](records.jsonl)',
          '- [Hardware, methodology and source hashes](metadata.json)',
          '- [Reproduction runner](../run_benchmarks.py)', '',
          'Run from the task directory: `python3 run_benchmarks.py runtime --lanes bend-seq,bend-par,bend-gpu,c,ts-bun,ts-node,lean`, then `python3 run_benchmarks.py checker --lanes bend,agda,lean,rocq,isabelle`. The downloaded toolchain directories are prerequisites. Re-running appends records and can reuse working files; for a strict cold-source checker repeat, create fresh checker working directories first.', '']
(OUT/'REPORT.md').write_text('\n'.join(lines))
print('runtime',dict(status),'checker',dict(collections.Counter(r['status'] for r in crows)))
