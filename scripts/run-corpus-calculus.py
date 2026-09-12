#!/usr/bin/env python3
from __future__ import annotations
import argparse, os, re, shutil, subprocess, sys, tempfile
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]

def parse_include_dirs(lib: Path) -> list[Path]:
    out=[]
    if not lib.exists(): return out
    for raw in lib.read_text(encoding='utf-8').splitlines():
        line=raw.strip()
        if line.startswith('include:'):
            for item in line[len('include:'):].split():
                p=(lib.parent/item).resolve()
                if p.is_dir() and p not in out: out.append(p)
    return out

def module_name(src: str):
    m=re.search(r'(?m)^module\s+([^\s({]+)',src); return m.group(1) if m else None

def public_names(src: str) -> list[str]:
    out=[]; seen=set()
    keywords={'module','open','import','private','public','mutual','abstract','instance','macro','variable','postulate','field','constructor','infix','infixl','infixr','syntax','pattern'}
    def add(x):
        x=x.strip()
        if not x or x=='_' or x in keywords or x.startswith('--') or x.startswith('{-#') or any(c in x for c in '(){}[],'): return
        if x not in seen: seen.add(x); out.append(x)
    for line in src.splitlines():
        if not line or line[0].isspace() or line.startswith('--') or line.startswith('{-#'): continue
        dm=re.match(r'(?:data|record)\s+([^\s:{]+)',line)
        if dm: add(dm.group(1)); continue
        if ':' not in line: continue
        left=line.split(':',1)[0].strip()
        if not left or left.split()[0] in keywords: continue
        if {'=','with','rewrite','|','...','where','let','in'} & set(left.split()): continue
        for token in left.split(): add(token)
    return out

def discover():
    libs=[ROOT/'formal/cubical/natural-machine.agda-lib',ROOT/'rescued-lanes.agda-lib']
    includes=[]
    for lib in libs:
        for p in parse_include_dirs(lib):
            if p not in includes: includes.append(p)
    by={}
    for inc in includes:
        for path in inc.glob('*.agda'):
            if 'must_fail' in path.resolve().parts or path.name.startswith('CorpusProbe'): continue
            try: src=path.read_text(encoding='utf-8')
            except UnicodeDecodeError: continue
            mod=module_name(src)
            if mod: by.setdefault(mod,[]).append((path,public_names(src)))
    rank={p:i for i,p in enumerate(includes)}
    def key(item):
        p=item[0].resolve(); best=len(includes)
        for inc,i in rank.items():
            try: p.relative_to(inc); best=min(best,i)
            except ValueError: pass
        return best,str(p)
    chosen=[]; dups=[]
    for mod,xs in sorted(by.items()):
        xs=sorted(xs,key=key); chosen.append((mod,xs[0][0],xs[0][1]))
        uniq=[]
        for p,_ in xs:
            if p not in uniq: uniq.append(p)
        if len(uniq)>1: dups.append((mod,uniq))
    return chosen,dups

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--keep-probe',action='store_true'); ap.add_argument('--output',default=str(ROOT/'corpus-presentation.txt')); args=ap.parse_args()
    prefix=Path(os.environ.get('MATH_PREFIX',str(Path.home()))); agda=prefix/'.local/bin/agda'
    if not agda.exists():
        found=shutil.which('agda')
        if not found: print('no agda; run: sh setup',file=sys.stderr); return 1
        agda=Path(found)
    libfile=prefix/'.agda-pin/libraries'
    if not libfile.exists(): print(f'no {libfile}; run: sh setup',file=sys.stderr); return 1
    ver=subprocess.run([str(agda),'--version'],text=True,capture_output=True).stdout.strip()
    if not ver.startswith('Agda version 2.8.0'): print(f'wrong toolchain: {ver!r}; run: sh setup',file=sys.stderr); return 1
    modules,dups=discover(); qnames=[]; imports=[]
    for mod,_,names in modules: imports.append(f'import {mod}'); qnames.extend(f'{mod}.{n}' for n in names)
    print(f'corpus modules: {len(modules)}',file=sys.stderr); print(f'checked realizations: {len(qnames)}',file=sys.stderr)
    print('semantic object: one infinite guarded nucleus + exact fibre at every demanded question',file=sys.stderr)
    body=['{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}','module CorpusProbe where','','open import Agda.Builtin.Reflection using (Name)','open import Agda.Builtin.List using (List ; [] ; _∷_)','open import CorpusExecute using (runCorpus)','',*imports,'','names : List Name','names =']
    body += [f'  quote {q} ∷' for q in qnames] + ['  []','','unquoteDecl = runCorpus names','']
    tmp=tempfile.TemporaryDirectory(prefix='corpus-calculus-'); tdir=Path(tmp.name); probe=tdir/'CorpusProbe.agda'; probe.write_text('\n'.join(body),encoding='utf-8')
    if args.keep_probe:
        kept=ROOT/'CorpusProbe.generated.agda'; kept.write_text(probe.read_text(encoding='utf-8'),encoding='utf-8'); print(f'probe: {kept}',file=sys.stderr)
    cmd=[str(agda),f'--library-file={libfile}','-l','natural-machine','-l','rescued-lanes','-l','fibre','-i',str(tdir),'-v','corpus.presentation:1',str(probe)]
    out=Path(args.output).expanduser().resolve(); out.parent.mkdir(parents=True,exist_ok=True); print(f'presentation output: {out}',file=sys.stderr)
    with out.open('w',encoding='utf-8') as f:
        p=subprocess.Popen(cmd,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1); assert p.stdout
        for line in p.stdout: sys.stdout.write(line); f.write(line)
        rc=p.wait()
    if rc==0: print(f'CORPUS PRESENTATION COMPLETE: {out}',file=sys.stderr)
    return rc
if __name__=='__main__': raise SystemExit(main())
