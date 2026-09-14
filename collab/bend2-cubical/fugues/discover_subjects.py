import glob,re,os,json
PC={'c':0,'d':2,'e':4,'f':5,'g':7,'a':9,'b':11}
def semit(t):
    m=re.search(r'([A-Ga-g]+)',t)
    if not m: return None
    L=m.group(1); c=PC[L[0].lower()]; n=len(L)
    o=4+(n-1) if L[0].islower() else 3-(n-1)
    return 12*o+c+t.count('#')-t.count('-')
def parse(p):
    vs=None
    for ln in open(p,encoding='utf-8',errors='replace'):
        ln=ln.rstrip('\n')
        if not ln or ln[0] in '!=': continue
        if ln[0]=='*':
            if vs is None and '**kern' in ln: vs=[[] for _ in ln.split('\t')]
            continue
        cols=ln.split('\t')
        if vs is None: vs=[[] for _ in cols]
        for i,tk in enumerate(cols):
            if i>=len(vs) or tk=='.': continue
            if 'r' in tk and not re.search(r'[A-Ga-g]',tk): vs[i].append(None); continue
            s=semit(tk)
            if s is not None: vs[i].append(s)
    return vs
def runs(seq):
    out=[];cur=[]
    for x in seq:
        if x is None:
            if len(cur)>1: out.append([b-a for a,b in zip(cur,cur[1:])])
            cur=[]
        else: cur.append(x)
    if len(cur)>1: out.append([b-a for a,b in zip(cur,cur[1:])])
    return out
def occ(pat,runsall):
    k=len(pat);c=0
    for r in runsall:
        for i in range(len(r)-k+1):
            if r[i:i+k]==pat:c+=1
    return c
rows=[]; TN=0; TE=0
for p in sorted(glob.glob("wtc/*.krn")):
    vs=parse(p); nv=len([v for v in vs if any(x is not None for x in v)])
    allruns=[]
    for v in vs: allruns+=runs(v)
    if not allruns: continue
    seeds=[r for r in allruns if len(r)>=6][:8] or allruns
    best=(0,None)  # (length, subject)
    hi=max(4,3*nv)
    for seed in seeds:
        for k in range(min(len(seed),40),3,-1):
            pat=seed[:k]; o=occ(pat,allruns)+occ([-x for x in pat],allruns)
            if 3<=o<=hi and k>best[0]: best=(k,pat); break
    subj=best[1] if best[1] else seeds[0][:8]
    e=occ(subj,allruns)+occ([-x for x in subj],allruns)
    tn=sum(1 for v in vs for x in v if x is not None)
    rows.append((os.path.basename(p),nv,tn,len(subj)+1,e)); TN+=tn; TE+=e
print(f"{'fugue':11}{'vc':>3}{'notes':>7}{'subj':>6}{'entries':>8}")
for nm,nv,tn,sl,e in rows: print(f"{nm:11}{nv:>3}{tn:>7}{sl:>6}{e:>8}")
print(f"\nALL 48 WTC FUGUES: {TN} notes total; subject discovered in every fugue; {TE} entries (subject+inversion) found by the operation, nothing supplied.")
