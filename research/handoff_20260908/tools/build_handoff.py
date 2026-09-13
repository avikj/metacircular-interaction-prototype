#!/usr/bin/env python3
"""Assemble an agent-oriented research handoff from preserved sources and chapters.
No repository execution or network calls. All original files remain unchanged.
"""
from __future__ import annotations
from pathlib import Path
import hashlib, json, re, ast, sys, platform

ROOT=Path(__file__).resolve().parents[1]
PIN='168ea8e240524f898af4b0e9cf70297c38422f08'

def sha(p:Path)->str:
    return hashlib.sha256(p.read_bytes()).hexdigest()

specs=[
('S00','Six-September comprehensive theorem-organism handoff','originals/library/comprehensive_handoff_2026-09-06.extracted.txt','Historical context; original DOCX also preserved.', ['originals/library/Metacircular Interaction Prototype - Comprehensive Conversation Handoff.docx']),
('S01','Faithful quartic receiver and NS actual-source continuation separation','sources/S01_receiver.md','Analytical source note; distinct earlier receiver.',[]),
('S02','Autocorrelation two-packet Weil criterion and exact triangular NS memory','sources/S02_two_packet.md','Analytical source note; principal later Z/G/M0 definitions.',[]),
('S03','Common-source quadratic polarization, Beltrami control and coherent CRT histories','sources/S03_common_source_quadratic_crt_RECONSTRUCTED.md','Reconstructed from visible user note, not original attachment bytes.',['originals/conversation/ns_rh_source_audit/exact_checks.py','originals/conversation/ns_rh_source_audit/exact_checks_output.txt']),
('S04','Poisson source spectrum, essential norm and auxiliary amplification controls','originals/conversation/poisson_source_spectrum/poisson_source_spectrum.md','Original mounted analytical note.',[]),
('S05','Actual source-preserving coadjoint/stochastic transport and compact tangent residual','originals/conversation/source_image_transport/source_image_transport.md','Original mounted analytical note.',[]),
('S06','Receiver Sobolev inverse and full affine harmonic continuation fibre','originals/conversation/receiver_inverse_harmonic_fibre/proof_note.md','Original mounted note; legacy alias proof_note(2).',[]),
('S07','Instantiated continuation fibres','originals/conversation/instantiated_continuation_fibres/proof_note.md','Original mounted note; legacy alias proof_note(1).',[]),
('S08','Finite strain coordinates and actual Weil source signature','originals/conversation/finite_strain_weil_signature/proof_note.md','Original mounted note; legacy alias proof_note(3).',[]),
('S09','Essential cross-helicity strain tomography and Hardy innovation','originals/conversation/ns_rh_strain_symbol_hardy_innovation/proof_note.md','Original mounted note; legacy alias proof_note(4).',[]),
('S10','Passive-work distinction and toroidal multipole blindness','originals/conversation/passivity_toroidal_quadrupole/proof_note.md','Original mounted note; legacy alias proof_note(5).',[]),
('S11','Actual Xi-cardinal sources and renormalized toroidal strain current','sources/S11_cardinal_and_current.md','Recovered proof_note(6).md.',[]),
('S12','Compact source-image rigidity and full nonlinear toroidal leakage','sources/S12_source_image_and_quadrupole.md','Recovered proof_note(7).md; strong complete radial-matrix theorem.',[]),
('S13','Endpoint Xi support escape and exact H5 viscous strain memory','originals/conversation/source_resolved_closure/proof_note.md','Original mounted note; several numbered aliases materialize to these same bytes.',[]),
('S14','User synthesis: reflection-scale holonomy, strain coboundary and nonlinear memory','sources/S14_user_holonomy_and_nonlinear_memory_RECONSTRUCTED.md','Reconstructed visible user synthesis; no claim of original attachment recovery.',[]),
('S15','Actual toroidal 2->4->2 return, sign examples and geometric-stack bound','originals/conversation/toroidal_first_return/proof_note.md','Original mounted note; timestamp aliases also existed.',[]),
('S16','Moving-peak heat control, signed radial spectrum and one-sided arithmetic escape','sources/S16_moving_peak_and_signed_spectrum.md','Recovered stronger parallel note dated research state Sept 7.',[]),
('S17','Full source-coherent nonlinear evaluator and certified local tree summation','originals/conversation/metacircular_full_history/proof_note.md','Original mounted note; 141 historical exact checks.',[]),
('S18','Causal normal form, analytic reconstruction and source-aware matrix certificate kernel','originals/conversation/metacircular_causal_normal_form/proof_note.md','Original mounted note; 86 exact checks replayed during handoff.',[]),
('S19','Source-dependent midpoint return, nonlinear kinetic storage and rigorous Abel inverse','sources/S19_midpoint_storage_and_abel.md','Recovered stronger parallel note; 43 exact controls replayed.',['originals/library/checks(4).py','originals/library/check_results(4).txt']),
('S20','Dyadic pole residual and general toroidal radial marginality','sources/S20_dyadic_and_radial_marginality.md','Recovered run26; use with later scope corrections.',[]),
('S21','Higher residuals and dynamic matching proposal','sources/S21_higher_residuals_dynamic_matching.md','AUDIT: higher difference convergence repaired by S19; NS matching claims not promoted.',[]),
('S22','Direct quadratic Goldbach residual and all-depth source-dependent memory','sources/S22_quadratic_goldbach_and_memory.md','Arithmetic derivation retained; Gaussian-in-octave NS suppression remains AUDIT.',[]),
('S23','Actual-endpoint backward assembly','originals/conversation/ns_rh_endpoint_assembly/endpoint_graph.md','Conditional actual endpoints; not an exhaustive repo closure.',['originals/conversation/ns_rh_endpoint_assembly/endpoint_graph.json']),
('S24','Native-runtime availability probes','originals/conversation/yantra_runtime_probe/environment.log','Execution environment evidence, not a mathematical failure.',['originals/conversation/yantra_runtime_probe/setup-report.log']),
('S25','Prime-Pair Delta 19: complete first-return, Schur and future-observation algebra','sources/S25_delta19.md','Historical source theorem/program note; formal module coverage differs by statement.',[]),
]
registry=[]
for sid,title,path,status,extra in specs:
    p=ROOT/path
    if not p.is_file(): raise FileNotFoundError(p)
    ent={'id':sid,'title':title,'path':path,'sha256':sha(p),'bytes':p.stat().st_size,'status':status,'related_files':list(extra)}
    if path.startswith('originals/conversation/') and p.suffix=='.md':
        ent['related_files']+= [str(x.relative_to(ROOT)) for x in sorted(p.parent.iterdir()) if x.is_file() and x!=p]
    registry.append(ent)
(ROOT/'SOURCE_REGISTRY.json').write_text(json.dumps(registry,ensure_ascii=False,indent=2)+'\n')

index=['# Source index and evidence provenance','',
'The source IDs below are stable within this archive. A numbered `proof_note(n)` filename is not a stable theorem identity. SHA-256, semantic title and relative path determine the object. Original alias copies remain in `originals/`; this index prefers a semantic path.','',
'No item below is labelled newly Agda-checked. The distinctions between analytical proofs, historical reports and current standalone replay are in the main correction ledger.','']
for s in registry:
    index += [f"## {s['id']} — {s['title']}",f"**Source:** [{s['path']}]({s['path']})",'',s['status'],'',f"`SHA256 {s['sha256']}`",'']
    if s['related_files']:
        index.append('Companion files:')
        for path in dict.fromkeys(s['related_files']):
            index.append(f'- [{path}]({path})')
        index.append('')
(ROOT/'SOURCE_INDEX.md').write_text('\n'.join(index)+'\n')

chapters=sorted((ROOT/'chapters').glob('*.md'))
parts=[]
for i,p in enumerate(chapters):
    text=p.read_text()
    # Repair common control-byte damage only in our newly authored synthesis.
    text=text.replace('\x0crac',r'\frac')
    bad=[c for c in text if ord(c)<32 and c not in '\n\r\t']
    if bad: raise ValueError(f'control bytes in {p}: {bad!r}')
    p.write_text(text)
    text=f'<a id="part-{i:02d}"></a>\n\n'+text
    text=re.sub(r'^## (\d+)\.',lambda m:f'<a id="section-{m.group(1)}"></a>\n\n## {m.group(1)}.',text,flags=re.M)
    parts.append(text)

toc=['# Navigation','',
'Canonical agent-ready synthesis. Complete source texts are additionally in `SOURCE_ANTHOLOGY.md`; original bytes, programs and historical logs are in the ZIP.','']
for i,p in enumerate(chapters):
    title=next(l[2:] for l in p.read_text().splitlines() if l.startswith('# '))
    toc.append(f'- [{title}](#part-{i:02d})')
    for line in p.read_text().splitlines():
        m=re.match(r'## (\d+)\. (.*)',line)
        if m: toc.append(f"  - [{m.group(1)}. {m.group(2)}](#section-{m.group(1)})")
refdefs=['','---','','# Source references','']+[f"[{s['id']}]: {s['path']} \"{s['title']}\"" for s in registry]
master=parts[0]+'\n\n'+'\n'.join(toc)+'\n\n'+'\n\n---\n\n'.join(parts[1:])+'\n'+'\n'.join(refdefs)+'\n'
(ROOT/'HANDOFF.md').write_text(master)

# Preserve every unique full source text; scripts remain complete separate files.
ant=['# Complete source anthology','',
'This anthology reproduces the selected source texts without mathematical editing. Some are superseded in part: consult HANDOFF.md and its correction ledger. It is an archival appendix, not a blanket endorsement of every historical inference. Programs, binary DOCX and original check logs are separate in the archive.','']
seen={}
for s in registry:
    p=ROOT/s['path']
    if p.suffix not in ('.md','.txt'): continue
    if s['sha256'] in seen:
        ant += [f"## {s['id']} — duplicate of {seen[s['sha256']]}",'']
        continue
    seen[s['sha256']]=s['id']
    text=p.read_text(errors='replace')
    ant += ['---','',f"# ORIGINAL {s['id']} — {s['title']}",f"Source path: `{s['path']}`; SHA-256: `{s['sha256']}`",f"Transfer status: {s['status']}",'',text,'']
(ROOT/'SOURCE_ANTHOLOGY.md').write_text('\n'.join(ant))

# All original URLs are leads, not newly verified external theorem imports.
urls={}
for s in registry:
    p=ROOT/s['path']
    if p.suffix not in ('.md','.txt','.log'): continue
    for u in re.findall(r'https?://[^\s<>\[\]"\)]+',p.read_text(errors='replace')):
        u=u.rstrip('.,;')
        urls.setdefault(u,set()).add(s['id'])
refs=['# External and repository URLs recovered from source notes','',
'These are primary-source/context leads retained from the originals. Inclusion is not a fresh bibliographic verification or a claim that a cited theorem supplies an uninstantiated hypothesis. Verify version, theorem statement, convention and source class before importing. The canonical handoff states the direct derivations independently where possible.','']
for u,ids in sorted(urls.items()): refs.append(f"- `{u}` — {', '.join(sorted(ids))}")
(ROOT/'REFERENCES_EXTRACTED.md').write_text('\n'.join(refs)+'\n')

# Parse only, without evaluating original scripts.
syntax=[]
for p in sorted((ROOT/'originals').rglob('*.py')):
    try:
        ast.parse(p.read_text(),filename=str(p)); status='PARSE_OK'; reason=''
    except Exception as e: status='PARSE_FAILED'; reason=repr(e)
    syntax.append({'path':str(p.relative_to(ROOT)),'sha256':sha(p),'status':status,'reason':reason})
(ROOT/'validation'/'python_syntax.json').write_text(json.dumps(syntax,indent=2)+'\n')
metrics={'date':'2026-09-08','comparison_commit':PIN,
         'chapters':len(chapters),'source_groups':len(registry),
         'master_words_whitespace':len(master.split()),'master_bytes':len(master.encode()),
         'anthology_words_whitespace':len((ROOT/'SOURCE_ANTHOLOGY.md').read_text().split()),
         'original_files':sum(p.is_file() for p in (ROOT/'originals').rglob('*')),
         'original_python_files':len(syntax),'original_python_parse_failures':sum(x['status']!='PARSE_OK' for x in syntax),
         'native_proof_assistant_runs':0,'fresh_exact_replay_checks':{'causal':86,'midpoint':43},
         'python':sys.version,'platform':platform.platform()}
(ROOT/'validation'/'assembly_metrics.json').write_text(json.dumps(metrics,indent=2)+'\n')
print(json.dumps(metrics,indent=2))
