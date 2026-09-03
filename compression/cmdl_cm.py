#!/usr/bin/env python3
"""
cmdl_cm.py — Cohomological-MDL codec with the higher-interaction layer.

cmdl.py built only P1 (the linear layer: per-block d + order-1).  This adds
the higher cross-effects the theory says are where the payload actually is:
a context-mixing predictor over orders 0..6 (each order-k context is the
k-fold interaction retained), logistically mixed, then range-coded.  In
Goodwillie terms the mixer is F -> P_n F: each context model is one
homogeneous layer; the adaptive mix keeps the interactions that matter.

Still certified lossless (encode re-decodes and asserts), still model-agnostic
on decode, still per-block MDL choice of the boundary operator d.
"""
from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math

MASK32 = (1 << 32) - 1
K_TOP = 1 << 24

# ---- explicit-probability binary range coder (LZMA-style) -----------------
class REnc:
    def __init__(self):
        self.low=0; self.range=MASK32; self.cache=0; self.cs=1; self.out=bytearray()
    def _sl(self):
        if self.low < 0xFF000000 or self.low > MASK32:
            c=self.cache
            while True:
                self.out.append((c+(self.low>>32))&0xFF); c=0xFF; self.cs-=1
                if self.cs==0: break
            self.cache=(self.low>>24)&0xFF
        self.cs+=1; self.low=(self.low<<8)&MASK32
    def bit(self, p0, b):        # p0 = P(bit=0) in [1,4095], 12-bit
        bound=(self.range>>12)*p0
        if b==0: self.range=bound
        else: self.low+=bound; self.range-=bound
        while self.range<K_TOP:
            self.range=(self.range<<8)&MASK32; self._sl()
    def finish(self):
        for _ in range(5): self._sl()
        return bytes(self.out)

class RDec:
    def __init__(self,data):
        self.d=data; self.p=1; self.range=MASK32; self.code=0
        for _ in range(4): self.code=((self.code<<8)|self._b())&MASK32
    def _b(self):
        v=self.d[self.p] if self.p<len(self.d) else 0; self.p+=1; return v
    def bit(self, p0):
        bound=(self.range>>12)*p0
        if self.code<bound: self.range=bound; b=0
        else: self.code-=bound; self.range-=bound; b=1
        while self.range<K_TOP:
            self.range=(self.range<<8)&MASK32; self.code=((self.code<<8)|self._b())&MASK32
        return b

# ---- context-mixing predictor ---------------------------------------------
def squash(x):
    if x> 20: return 0.999999
    if x<-20: return 0.000001
    return 1.0/(1.0+math.exp(-x))
def stretch(p):
    p=min(max(p,1e-6),1-1e-6); return math.log(p/(1.0-p))

ORDERS = [0,1,2,3,4,6]
TBITS  = 22
TSIZE  = 1<<TBITS
TMASK  = TSIZE-1

NIN=len(ORDERS)+1                              # context models + 1 match model
MINLEN=4; HBITS=22; HSIZE=1<<HBITS; HMASK=HSIZE-1
class CM:
    """Context-mixing bit predictor with a long-range match model.
    Deterministic; encoder and decoder run the identical update in lockstep."""
    def __init__(self):
        self.tabs=[[0.5]*TSIZE for _ in ORDERS]
        self.w=[0.0]*NIN
        self.lr=0.02; self.rate=0.05
        self.hist=0; self.node=1
        self.idx=[0]*len(ORDERS); self.st=[0.0]*NIN; self.p=0.5
        # match model state
        self.buf=bytearray()                    # full byte history (both sides build it)
        self.mhash=[0]*HSIZE                     # hash(last MINLEN bytes)->position+1
        self.mptr=0                              # predicted position in buf (0 = no match)
        self.mlen=0
        self.pbyte=0                             # predicted byte when in a match
    def _predict(self):
        h=self.hist
        for i,k in enumerate(ORDERS):
            ctx = h & ((1<<(8*k))-1) if k>0 else 0
            key = ((ctx*2654435761) ^ (self.node*0x9E3779B1) ^ (k*0x85EBCA6B)) & TMASK
            self.idx[i]=key; self.st[i]=stretch(self.tabs[i][key])
        # match model input: if in a match, strongly predict the matched bit.
        if self.mptr:
            nb=1
            # reconstruct how many bits of the current byte are known from node
            b=self.node; kbits=b.bit_length()-1
            predbit=(self.pbyte>>(7-kbits))&1
            strength=min(self.mlen,32)*0.4
            self.st[NIN-1]=strength if predbit==1 else -strength
        else:
            self.st[NIN-1]=0.0
        dot=0.0
        for i in range(NIN): dot+=self.w[i]*self.st[i]
        self.p=squash(dot); return self.p
    def _update(self,bit):
        err=bit-self.p
        for i in range(len(ORDERS)):
            self.w[i]+=self.lr*err*self.st[i]
            t=self.tabs[i]; k=self.idx[i]; t[k]+=self.rate*(bit-t[k])
        self.w[NIN-1]+=self.lr*err*self.st[NIN-1]
        self.node=(self.node<<1)|bit
    def byte_done(self,byte):
        # match-model bookkeeping
        if self.mptr and self.mptr<len(self.buf) and self.buf[self.mptr]==byte:
            self.mptr+=1; self.mlen+=1
        else:
            self.mptr=0; self.mlen=0
        self.buf.append(byte)
        if len(self.buf)>=MINLEN:
            key=0
            for j in range(len(self.buf)-MINLEN,len(self.buf)): key=(key*257+self.buf[j])&0xFFFFFFFF
            key&=HMASK
            if not self.mptr:
                cand=self.mhash[key]
                if cand: self.mptr=cand; self.mlen=MINLEN
            self.mhash[key]=len(self.buf)
        if self.mptr and self.mptr<len(self.buf): self.pbyte=self.buf[self.mptr]
        else: self.mptr=0
        self.hist=((self.hist<<8)|byte)&((1<<64)-1); self.node=1

def compress_cm(data: bytes, ids, transformed) -> bytes:
    enc=REnc(); cm=CM()
    for x in transformed:
        for kbit in range(7,-1,-1):
            bit=(x>>kbit)&1
            p1=cm._predict()
            p0=int((1.0-p1)*4096); p0=1 if p0<1 else (4095 if p0>4095 else p0)
            enc.bit(p0,bit); cm._update(bit)
        cm.byte_done(x)
    return enc.finish()

def decompress_cm(payload: bytes, n: int):
    dec=RDec(payload); cm=CM(); out=bytearray()
    for _ in range(n):
        for _ in range(8):
            p1=cm._predict()
            p0=int((1.0-p1)*4096); p0=1 if p0<1 else (4095 if p0>4095 else p0)
            bit=dec.bit(p0); cm._update(bit)
        byte=cm.node&0xFF; out.append(byte); cm.byte_done(byte)
    return bytes(out)

# ---- transforms (choice of d) + MDL selection -----------------------------
def d1f(b):
    o=bytearray(len(b)); pr=0
    for i,x in enumerate(b): o[i]=(x-pr)&0xFF; pr=x
    return bytes(o)
def d1g(b):
    o=bytearray(len(b)); pr=0
    for i,x in enumerate(b): pr=(pr+x)&0xFF; o[i]=pr
    return bytes(o)
def idf(b): return b
T=[(idf,idf),(d1f,d1g),(lambda b:d1f(d1f(b)),lambda b:d1g(d1g(b)))]
def o0(b):
    if not b: return 0.0
    from collections import Counter
    n=len(b); return -sum(v*math.log2(v/n) for v in Counter(b).values())
def choose(block):
    bi,bc,bt=0,None,None
    for i,(f,_) in enumerate(T):
        t=f(block); c=o0(t)
        if bc is None or c<bc: bi,bc,bt=i,c,t
    return bi,bt

MAGIC=b"CMD2"; BLOCK=1<<14
def compress(data: bytes)->bytes:
    n=len(data); ids=bytearray(); tr=bytearray()
    for off in range(0,n,BLOCK):
        blk=data[off:off+BLOCK]; i,t=choose(blk); ids.append(i); tr+=t
    payload=compress_cm(data,ids,tr)
    idz=zlib.compress(bytes(ids),9)
    out=bytearray(); out+=MAGIC; out+=struct.pack("<QI",n,len(idz)); out+=idz; out+=payload
    arc=bytes(out)
    if decompress(arc)!=data: raise AssertionError("cmdl_cm: roundtrip certificate FAILED")
    return arc
def decompress(arc: bytes)->bytes:
    assert arc[:4]==MAGIC; n,idl=struct.unpack_from("<QI",arc,4); p=16
    ids=zlib.decompress(arc[p:p+idl]); p+=idl; payload=arc[p:]
    tr=decompress_cm(payload,n)
    out=bytearray(); off=0; nb=(n+BLOCK-1)//BLOCK
    for bi in range(nb):
        bl=min(BLOCK,n-off); seg=bytes(tr[off:off+bl]); out+=T[ids[bi]][1](seg); off+=bl
    return bytes(out)

def bench(data,label):
    n=len(data); import time
    t0=time.time(); c=compress(data); dt=time.time()-t0
    rows=[("cmdl_cm",len(c)),("gzip-9",len(zlib.compress(data,9))),
          ("bz2-9",len(bz2.compress(data,9))),("lzma",len(lzma.compress(data,preset=9)))]
    print(f"\n{label}: {n} bytes  (cmdl_cm {dt:.1f}s)")
    for nm,sz in rows: print(f"  {nm:8s} {sz:9d}  {n/sz:6.2f}x  {100*sz/n:5.1f}%")
    assert decompress(c)==data; print("  [certificate] roundtrip exact: OK")

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]: bench(open(f,"rb").read(),f)
    else: print(__doc__)
