#!/usr/bin/env python3
"""Drive the yantra over its wire.  usage: yantra_client.py <requests.jsonl>
Each request line is sent verbatim; each answer is summarised (kind, position,
route, first defect line) and the full answer appended to yantra_answers.jsonl."""
import json, subprocess, sys, os
ROOT = '/home/user/metacircular-interaction-prototype'
S = os.path.dirname(os.path.abspath(__file__))
reqs = [l for l in open(sys.argv[1]).read().split('\n') if l.strip()]
env = dict(os.environ, MATH_AGDA_TIMEOUT='3000', PATH=S + '/bin:' + os.environ['PATH'], YANTRA_OUT=S + '/yantra_out', DOSA_LEKHA=S + '/yantra_session.lekha')
p = subprocess.Popen(['sh', 'interactive/run-yantra.sh', '--wire'], cwd=ROOT, env=env,
                     stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
out = open(S + '/yantra_answers.jsonl', 'a')
for r in reqs:
    p.stdin.write(r + '\n'); p.stdin.flush()
    line = p.stdout.readline()
    while line and not line.startswith('{'):
        line = p.stdout.readline()
    out.write(line); out.flush()
    try:
        a = json.loads(line)
    except Exception:
        print('RAW', line[:500]); continue
    u = a['uttara'] if isinstance(a.get('uttara'), dict) else a
    kind = u.get('uttara'); kr = u.get('kriya')
    nir = u.get('nirnaya', {}).get('sthana'); pr = u.get('pramanya', {})
    print(f"== {kr}: {kind} [{nir}] via {pr.get('marga')}")
    if kind == 'dosalekha':
        print('   hetu:', str(u.get('hetu'))[:300])
        for n in u.get('nasta', [])[:1]:
            print('   nasta:', str(n)[:1500])
        for s in u.get('sesa', [])[:2]:
            print('   sesa:', str(s)[:200])
    else:
        print('   saksin:', str(pr.get('saksin'))[:300])
        vs = u.get('vahita', {})
        if isinstance(vs, dict):
            for k, v in vs.items():
                if k in ('padani', 'vislesana', 'phala', 'sesah'):
                    print('   ', k, ':', json.dumps(v, ensure_ascii=False)[:1500])
p.stdin.close(); p.wait(timeout=60)
