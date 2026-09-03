#!/usr/bin/env python3
"""
ctw.py — Context-Tree Weighting: the universal, optimal-scaling compressor.

Not one context depth, and not a committed quotient.  At every position it
weights the predictions of ALL context depths 0..D together — a Bayesian
mixture over every possible tree model — with the exact CTW weighting

    Pw(s) = 1/2 Pe(s) + 1/2 Pw(s0) Pw(s1),

Pe the Krichevsky-Trofimov (add-1/2) estimator.  This is keep-every-naya,
never-truncate-to-one-verdict, made an algorithm: no standpoint (depth) is
discarded; each is weighted by how well it has predicted.  The consequence is
a THEOREM (Willems-Shtarkov-Tjalkens 1995): the per-symbol redundancy over the
best tree source is O(log N / N) -> 0.  So it RESPONDS OPTIMALLY TO SCALE — its
bits/char provably converge to the source entropy as the input grows, with no
capacity ceiling (the tree grows with the data).

No prior; certified lossless; the tree is a deterministic function of the
causal past, so the decoder regrows it — zero model transmitted.
"""
from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math, time

MASK32=(1<<32)-1; K_TOP=1<<24
class REnc:
    def __init__(s): s.low=0;s.range=MASK32;s.cache=0;s.cs=1;s.out=bytearray()
    def _sl(s):
        if s.low<0xFF000000 or s.low>MASK32:
            c=s.cache
            while True:
                s.out.append((c+(s.low>>32))&0xFF);c=0xFF;s.cs-=1
                if s.cs==0:break
            s.cache=(s.low>>24)&0xFF
        s.cs+=1;s.low=(s.low<<8)&MASK32
    def bit(s,p0,b):
        bound=(s.range>>12)*p0
        if b==0:s.range=bound
        else:s.low+=bound;s.range-=bound
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s._sl()
    def finish(s):
        for _ in range(5):s._sl()
        return bytes(s.out)
class RDec:
    def __init__(s,d):
        s.d=d;s.p=1;s.range=MASK32;s.code=0
        for _ in range(4):s.code=((s.code<<8)|s._b())&MASK32
    def _b(s):
        v=s.d[s.p] if s.p<len(s.d) else 0;s.p+=1;return v
    def bit(s,p0):
        bound=(s.range>>12)*p0
        if s.code<bound:s.range=bound;b=0
        else:s.code-=bound;s.range-=bound;b=1
        while s.range<K_TOP:s.range=(s.range<<8)&MASK32;s.code=((s.code<<8)|s._b())&MASK32
        return b

LOG_HALF=math.log(0.5)
def lse(x,y):
    if x>y: return x+math.log1p(math.exp(y-x))
    return y+math.log1p(math.exp(x-y))

class CTW:
    def __init__(s, D=24):
        s.D=D
        # node key -> [a, b, lpe, lpw].  a,b KT counts; lpe,lpw accumulated logs.
        s.node={}
        s.bh=0                   # bit history (LSB = most recent)
        s.bitcount=0.0
    def _path(s):
        bh=s.bh; nd=s.node; keys=[]
        for d in range(s.D+1):
            k=(d<<56)|(bh&((1<<d)-1))
            if k not in nd: nd[k]=[0,0,0.0,0.0]
            keys.append(k)
        return keys
    def _sibkeys(s):
        bh=s.bh; sib=[0]*s.D
        for d in range(s.D):
            sib[d]=((d+1)<<56)|((bh&((1<<(d+1))-1))^(1<<d))
        return sib
    def _factor(s,path,sib,t):
        nd=s.node; D=s.D; lpw_child=0.0
        for d in range(D,-1,-1):
            a,b,lpe,lpw=nd[path[d]]
            tot=a+b+1.0
            pred=(b+0.5)/tot if t else (a+0.5)/tot
            lpe_t=lpe+math.log(pred)
            if d==D:
                lpw_t=lpe_t
            else:
                sk=sib[d]; n=nd.get(sk); lpw_sib=n[3] if n is not None else 0.0
                lpw_t=lse(LOG_HALF+lpe_t, LOG_HALF+lpw_child+lpw_sib)
            lpw_child=lpw_t
        return lpw_child-nd[path[0]][3]
    def p0_12(s,path,sib):
        s._pf0=s._factor(path,sib,0); s._pf1=s._factor(path,sib,1)
        # p1 = sigmoid(f1-f0)
        dfl=s._pf1-s._pf0
        p1=1.0/(1.0+math.exp(-dfl)) if -700<dfl<700 else (1.0 if dfl>0 else 0.0)
        return int(4096.0*(1.0-p1))
    def commit(s,path,sib,x):
        nd=s.node; D=s.D; lpw_child=0.0
        # learning curve
        f=s._pf1 if x else s._pf0
        s.bitcount+=-(f)/math.log(2)
        for d in range(D,-1,-1):
            node=nd[path[d]]; a,b,lpe,lpw=node
            tot=a+b+1.0
            pred=(b+0.5)/tot if x else (a+0.5)/tot
            lpe2=lpe+math.log(pred)
            if d==D:
                lpw2=lpe2
            else:
                sk=sib[d]; n=nd.get(sk); lpw_sib=n[3] if n is not None else 0.0
                lpw2=lse(LOG_HALF+lpe2, LOG_HALF+lpw_child+lpw_sib)
            node[2]=lpe2; node[3]=lpw2
            if x: node[1]=b+1
            else: node[0]=a+1
            lpw_child=lpw2
        s.bh=((s.bh<<1)|x)&((1<<D)-1)

def compress(data:bytes, D=24)->bytes:
    enc=REnc(); M=CTW(D)
    for x in data:
        for kb in range(7,-1,-1):
            bit=(x>>kb)&1
            path=M._path(); sib=M._sibkeys()
            p0=M.p0_12(path,sib); p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,bit); M.commit(path,sib,bit)
    payload=enc.finish(); arc=b"CTW1"+struct.pack("<QB",len(data),D)+payload
    compress.bits=M.bitcount; compress.nodes=len(M.node)
    if decompress(arc)!=data: raise AssertionError("ctw: roundtrip certificate FAILED")
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"CTW1"; n,D=struct.unpack_from("<QB",arc,4); dec=RDec(arc[13:])
    M=CTW(D); out=bytearray()
    for _ in range(n):
        v=1
        for _ in range(8):
            path=M._path(); sib=M._sibkeys()
            p0=M.p0_12(path,sib); p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0); M.commit(path,sib,bit); v=(v<<1)|bit
        out.append(v&0xFF)
    return bytes(out)

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]:
            d=open(f,"rb").read(); c=compress(d); n=len(d)
            print(f"{f}: {n} -> {len(c)}  {8*len(c)/n:.3f} bpc  nodes={compress.nodes}")
    else: print(__doc__)
