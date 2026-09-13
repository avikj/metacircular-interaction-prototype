#!/usr/bin/env python3
"""Build, validate and archive the completed research handoff. No network or repo writes."""
from __future__ import annotations
from pathlib import Path
import hashlib,json,re,zipfile,ast,subprocess,sys
from collections import defaultdict
ROOT=Path(__file__).resolve().parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
subprocess.run([sys.executable,str(ROOT/'tools/build_handoff.py')],check=True)
subprocess.run([sys.executable,str(ROOT/'tools/build_claim_graph.py')],check=True)
registry=json.loads((ROOT/'SOURCE_REGISTRY.json').read_text())
graph=json.loads((ROOT/'CLAIM_GRAPH.json').read_text())
sourceids={x['id'] for x in registry}
master=(ROOT/'HANDOFF.md').read_text()
anchors=set(re.findall(r'<a id="([^"]+)"></a>',master))
errors=[]
# Validate all source and claim references.
for sid in re.findall(r'\[(S\d\d)\]',master):
    if sid not in sourceids:errors.append('Unknown source '+sid)
for n in graph['nodes']:
    if f"section-{n['handoff_section']}" not in anchors:errors.append('Bad section for '+n['id'])
    for sid in n['sources']:
        if sid not in sourceids:errors.append('Bad claim source '+sid)
    for cid in n['corrections']:
        if not re.search(r'\*\*'+re.escape(cid)+r'\s+—',master):errors.append('Bad correction '+cid)
# Ensure newly authored math/code fences have balanced delimiters, no control-byte corruption.
for p in sorted((ROOT/'chapters').glob('*.md')):
    text=p.read_text()
    for op,cl in [(r'\[',r'\]'),(r'\(',r'\)')]:
        if text.count(op)!=text.count(cl):errors.append(f'{p.name}: unbalanced {op}/{cl}')
    if sum(l.startswith('```') for l in text.splitlines())%2:errors.append(f'{p.name}: code fence')
    if any(ord(c)<32 and c not in '\n\r\t' for c in text):errors.append(f'{p.name}: control character')
# All shipped code parses; never execute original programs as part of this check.
for p in ROOT.rglob('*.py'):
    if '__pycache__' in p.parts:continue
    try:ast.parse(p.read_text(),filename=str(p))
    except Exception as e:errors.append(f'{p}: {e}')
for p in (ROOT/'infra').glob('*.jsonl'):
    for i,line in enumerate(p.read_text().splitlines(),1):
        if line:json.loads(line)
# Duplicates remain archived; report their actual byte identity.
groups=defaultdict(list)
original_control=[]
for p in sorted((ROOT/'originals').rglob('*')):
    if p.is_file():
        groups[sha(p)].append(str(p.relative_to(ROOT)))
        if p.suffix in ('.md','.txt','.log'):
            data=p.read_text(errors='replace')
            controls=sorted({ord(c) for c in data if ord(c)<32 and c not in '\n\r\t'})
            if controls:original_control.append({'path':str(p.relative_to(ROOT)),'control_codepoints':controls,'note':'Original retained byte-for-byte; canonical synthesis does not reproduce these bytes.'})
(ROOT/'provenance'/'duplicate_originals.json').write_text(json.dumps({k:v for k,v in groups.items() if len(v)>1},indent=2)+'\n')
(ROOT/'provenance'/'original_text_control_bytes.json').write_text(json.dumps(original_control,indent=2)+'\n')
# Validate original mounted copies against their still-present source directories.
copy_results=[]
for p in sorted((ROOT/'originals/conversation').rglob('*')):
    if not p.is_file():continue
    original=Path('/mnt/data')/p.relative_to(ROOT/'originals/conversation')
    same=original.is_file() and sha(original)==sha(p)
    copy_results.append({'archived':str(p.relative_to(ROOT)),'mounted_original':str(original),'byte_identical':same})
    if not same:errors.append('Original mounted copy mismatch '+str(p))
(ROOT/'validation'/'mounted_copy_integrity.json').write_text(json.dumps(copy_results,indent=2)+'\n')
validation={'date':'2026-09-08','structural_errors':errors,'structural_valid':not errors,
            'claim_nodes':len(graph['nodes']),'source_groups':len(registry),'sections':len([a for a in anchors if a.startswith('section-')]),
            'corrections':len(set(re.findall(r'\*\*(C\d\d)\s+—',master))),
            'original_control_byte_files':len(original_control),
            'native_execution':False,'fresh_standalone_replays':[
                {'path':'validation/replays/causal','exit_status':int((ROOT/'validation/replays/causal/exit.txt').read_text()),'exact_checks':86},
                {'path':'validation/replays/midpoint','exit_status':int((ROOT/'validation/replays/midpoint/exit.txt').read_text()),'exact_checks':43}],
            'scope':'Structural/integrity checks and two explicitly standalone symbolic suites; no continuum or native theorem proof.'}
(ROOT/'validation'/'bundle_validation.json').write_text(json.dumps(validation,indent=2)+'\n')
if errors:
    print(json.dumps(errors,indent=2)); raise SystemExit(1)
excluded={'MANIFEST.json','CHECKSUMS.sha256'}
files=[]
for p in sorted(ROOT.rglob('*')):
    if not p.is_file() or '__pycache__' in p.parts or p.name in excluded:continue
    files.append({'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha(p)})
man={'format':'mip-research-handoff-v1','date':'2026-09-08','comparison_commit':'168ea8e240524f898af4b0e9cf70297c38422f08',
     'hash_algorithm':'SHA-256','self_reference_exclusions':sorted(excluded),'files':files,
     'source_registry':'SOURCE_REGISTRY.json','claim_graph':'CLAIM_GRAPH.json',
     'verification_note':'Hashes verify archive bytes, not truth of analytical claims. See correction and execution ledger.'}
(ROOT/'MANIFEST.json').write_text(json.dumps(man,ensure_ascii=False,indent=2)+'\n')
checks=[f"{e['sha256']}  {e['path']}" for e in files]
checks.append(f"{sha(ROOT/'MANIFEST.json')}  MANIFEST.json")
(ROOT/'CHECKSUMS.sha256').write_text('\n'.join(checks)+'\n')
subprocess.run([sys.executable,str(ROOT/'tools/verify_bundle.py')],check=True)
zip_path=ROOT.parent/'Metacircular_NS_RH_Claude_Code_Handoff_2026-09-08.zip'
with zipfile.ZipFile(zip_path,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
    for p in sorted(ROOT.rglob('*')):
        if p.is_file() and '__pycache__' not in p.parts:
            z.write(p,arcname=ROOT.name+'/'+str(p.relative_to(ROOT)))
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
zip_path.with_suffix('.zip.sha256').write_text(sha(zip_path)+'  '+zip_path.name+'\n')
print(json.dumps({'zip':str(zip_path),'zip_bytes':zip_path.stat().st_size,'zip_sha256':sha(zip_path),
                  'payload_files':len(files),'validation':validation},indent=2))
