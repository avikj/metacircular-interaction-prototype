#!/usr/bin/env python3
"""
cmdl_self.py — the SELF-REWRITING compressor.

Not a fixed pipeline.  The library of operators starts minimal (order-0) and
GROWS at runtime, driven by the data's own obstructions:

    obstruction  -> propose -> certify -> install -> plateau

  * obstruction : a proposed operator whose marginal information gain over the
    current mixture is positive — structure the library does not yet cancel.
  * propose     : the next operator from a generative grammar (higher orders,
    match, word, sparse/skip contexts) is shadow-run against the live stream.
  * certify     : installation is conservative because every operator is a pure
    function of the CAUSAL PAST — so the decoder re-derives the identical
    install decisions from the data it has already decoded.  Nothing about the
    grown model is transmitted; it regrows on both flanks (weights => traces).
    Acceptance is MDL: install iff it strictly lowers the code length.
  * install     : the operator joins the mixer (install : proposal -> operator).
  * plateau     : when no proposed operator lowers the code length, growth
    halts — Siddhasadhana's plateau, coherence.  The install trace IS the
    discovered structure of the data.

Certified lossless by construction; model-agnostic; zero transmitted model.
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

def squash(x):
    if x>20:return 0.999999
    if x<-20:return 0.000001
    return 1.0/(1.0+math.exp(-x))
def stretch(p):
    p=min(max(p,1e-6),1-1e-6);return math.log(p/(1.0-p))

TBITS=22; TSIZE=1<<TBITS; TMASK=TSIZE-1

# ------------- operators: each a pure function of the causal past ----------
class Operator:
    """A context predictor.  key(hist,node,buf,pos)->int identifies its context;
    a hashed table holds P(bit=1). Pure function of the past => replayable."""
    __slots__=("name","kind","k","gap","tab","idx","p","ema","seen")
    def __init__(s,name,kind,k=0,gap=0):
        s.name=name;s.kind=kind;s.k=k;s.gap=gap
        s.tab=[0.5]*TSIZE;s.idx=0;s.p=0.5;s.ema=1.0;s.seen=0
    def key(s,hist,node,buf,pos,pbyte):
        if s.kind=="order":
            ctx=hist&((1<<(8*s.k))-1) if s.k>0 else 0
            return ((ctx*2654435761)^(node*0x9E3779B1)^(s.k*0x85EBCA6B))&TMASK
        if s.kind=="sparse":              # last k bytes skipping the most recent `gap`
            ctx=(hist>>(8*s.gap))&((1<<(8*s.k))-1)
            return ((ctx*40503)^(node*0x9E3779B1)^((s.k+16*s.gap)*2246822519))&TMASK
        if s.kind=="word":                # current run of alnum bytes
            w=0;i=pos-1
            while i>=0 and (65<=buf[i]<=90 or 97<=buf[i]<=122):
                w=(w*131+buf[i])&0xFFFFFFFF;i-=1
                if pos-i>16:break
            return ((w*2654435761)^(node*0x9E3779B1)^7)&TMASK
        if s.kind=="match":               # predicted byte from longest prior match
            predbit=(pbyte>>(7-(node.bit_length()-1)))&1 if pbyte>=0 else 0
            return (predbit*0x55555555 ^ node*0x33333333)&TMASK
        return 0
    def predict(s,hist,node,buf,pos,pbyte):
        s.idx=s.key(hist,node,buf,pos,pbyte);s.p=s.tab[s.idx];return s.p
    def update(s,bit):
        loss=-math.log2(s.p if bit else 1.0-s.p)
        s.ema=0.98*s.ema+0.02*loss
        s.tab[s.idx]+=0.05*(bit-s.tab[s.idx]);s.seen+=1

# the generative grammar: the order the proposer names missing structure.
def grammar():
    yield Operator("order1","order",k=1)
    yield Operator("order2","order",k=2)
    yield Operator("match","match")
    yield Operator("order3","order",k=3)
    yield Operator("word","word")
    yield Operator("order4","order",k=4)
    yield Operator("sparse1","sparse",k=2,gap=1)
    yield Operator("order6","order",k=6)
    yield Operator("order8","order",k=8)

CHUNK=1024          # checkpoint period (bytes); deterministic on both sides
MARGIN=0.004        # bits/bit marginal gain required to install (MDL acceptance)
TRIAL_W=0.4

class Machine:
    """Runs identically on encoder and decoder.  Grows its operator library
    from obstructions in the causal past.  All proposals warm in a pool; each
    installs when its marginal information gain over the live mixture matures
    past the MDL margin; growth halts at the coherence plateau."""
    def __init__(s):
        s.active=[Operator("order0","order",k=0)]
        s.w=[0.0]
        s.pool=list(grammar())        # every proposed operator, perpetually warming
        s.acc_base=[0.0]*len(s.pool)  # per-shadow marginal-gain accumulators
        s.acc_sh=[0.0]*len(s.pool)
        s.acc_n=0
        s.hist=0;s.node=1;s.buf=bytearray()
        s.mhash=[0]*(1<<20);s.mptr=0;s.mlen=0;s.pbyte=-1
        s.installs=[];s.pos=0;s.p=0.5
        s.st=[0.0];s.dot=0.0;s.p_sh=[0.5]*len(s.pool)
        s.quiet=0                     # checkpoints with no install (plateau counter)
        s.plateaued=False
    def _predict(s):
        n=len(s.active)
        if len(s.st)<n: s.st=[0.0]*n
        dot=0.0
        for i in range(n):
            pi=s.active[i].predict(s.hist,s.node,s.buf,s.pos,s.pbyte)
            si=stretch(pi);s.st[i]=si;dot+=s.w[i]*si
        s.dot=dot;s.p=squash(dot)
        if not s.plateaued:
            for j,sh in enumerate(s.pool):
                psh=sh.predict(s.hist,s.node,s.buf,s.pos,s.pbyte)
                s.p_sh[j]=squash(dot+TRIAL_W*stretch(psh))  # trial: mix WITH shadow j
        return s.p
    def _update(s,bit):
        err=bit-s.p
        for i in range(len(s.active)):
            s.w[i]+=0.02*err*s.st[i];s.active[i].update(bit)
        if not s.plateaued:
            lb=-math.log2(s.p if bit else 1.0-s.p)
            for j,sh in enumerate(s.pool):
                s.acc_base[j]+=lb
                s.acc_sh[j]+=-math.log2(s.p_sh[j] if bit else 1.0-s.p_sh[j])
                sh.update(bit)
            s.acc_n+=1
        s.node=(s.node<<1)|bit
    def byte_done(s,byte):
        if s.mptr and s.mptr<len(s.buf) and s.buf[s.mptr]==byte: s.mptr+=1;s.mlen+=1
        else: s.mptr=0;s.mlen=0
        s.buf.append(byte)
        if len(s.buf)>=4:
            key=0
            for j in range(len(s.buf)-4,len(s.buf)):key=(key*257+s.buf[j])&0xFFFFFFFF
            key&=(1<<20)-1
            if not s.mptr:
                cand=s.mhash[key]
                if cand:s.mptr=cand;s.mlen=4
            s.mhash[key]=len(s.buf)
        s.pbyte=s.buf[s.mptr] if (s.mptr and s.mptr<len(s.buf)) else -1
        s.hist=((s.hist<<8)|byte)&((1<<64)-1);s.node=1;s.pos+=1
        # checkpoint: certify (marginal MDL gain) + install the matured best;
        # deterministic in the causal past, so the decoder replays it exactly.
        if (not s.plateaued) and s.acc_n>=CHUNK:
            best=-1;bg=MARGIN
            for j in range(len(s.pool)):
                g=(s.acc_base[j]-s.acc_sh[j])/s.acc_n
                if g>bg: bg=g;best=j
            if best>=0:
                sh=s.pool.pop(best)
                s.active.append(sh);s.w.append(0.0)
                s.installs.append((s.pos,sh.name))
                s.acc_base.pop(best);s.acc_sh.pop(best);s.p_sh.pop(best)
                s.quiet=0
            else:
                s.quiet+=1
                if s.quiet>=8 or not s.pool:   # coherence plateau
                    s.plateaued=True
            s.acc_base=[0.0]*len(s.pool);s.acc_sh=[0.0]*len(s.pool);s.acc_n=0

def compress(data:bytes)->bytes:
    enc=REnc();M=Machine()
    for x in data:
        for kb in range(7,-1,-1):
            bit=(x>>kb)&1;p1=M._predict()
            p0=int((1.0-p1)*4096);p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,bit);M._update(bit)
        M.byte_done(x)
    payload=enc.finish()
    out=bytearray(b"CMDS");out+=struct.pack("<Q",len(data));out+=payload
    arc=bytes(out)
    if decompress(arc)!=data: raise AssertionError("cmdl_self: roundtrip certificate FAILED")
    compress.trace=M.installs
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"CMDS";n,=struct.unpack_from("<Q",arc,4);dec=RDec(arc[12:])
    M=Machine();out=bytearray()
    for _ in range(n):
        for _ in range(8):
            p1=M._predict();p0=int((1.0-p1)*4096);p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0);M._update(bit)
        byte=M.node&0xFF;out.append(byte);M.byte_done(byte)
    return bytes(out)

def bench(data,label):
    n=len(data);t0=time.time();c=compress(data);dt=time.time()-t0
    tr=getattr(compress,"trace",[])
    rows=[("cmdl_self",len(c)),("gzip-9",len(zlib.compress(data,9))),
          ("bz2-9",len(bz2.compress(data,9))),("lzma",len(lzma.compress(data,preset=9)))]
    print(f"\n{label}: {n} bytes  ({dt:.1f}s)")
    for nm,sz in rows:print(f"  {nm:9s} {sz:9d}  {n/sz:6.2f}x  {100*sz/n:5.1f}%")
    print(f"  installs (data-driven, {len(tr)} operators, then plateau):")
    print("   ",", ".join(f"{nm}@{p}" for p,nm in tr) or "(only the order-0 seed)")
    assert decompress(c)==data;print("  [certificate] roundtrip exact: OK; zero model transmitted")

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]:bench(open(f,"rb").read(),f)
    else:print(__doc__)
