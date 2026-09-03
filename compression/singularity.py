#!/usr/bin/env python3
"""
singularity.py — a no-prior, self-learning, lossless compressor for arbitrary
data that functions like a language model on natural language.

No prior: it ships with no pretrained model and starts from the uniform
distribution.  It LEARNS online — bits-per-character fall as it reads, exactly
as an LM's cross-entropy falls during training — because compression IS
prediction IS language learning (Shannon; Hutter).

The machinery is the corpus's:
  * contexts of many orders + WORD models — characters quotiented into words,
    words into a class that predicts the next (pratyāhāra: name a class,
    predict over it; anuvṛtti: inherited context);
  * a long-range match model — the exact / generated (im d) component;
  * logistic mixing — the higher cross-effects, kept not smeared;
  * an APM/SSE stage — the harmonic refinement of the predicted class (Hodge);
  * arithmetic coding — the entropy floor.
The model is a deterministic function of the causal past, so the decoder
REGROWS the identical model from the bytes it has already decoded: zero model
is transmitted (weights => traces).  Certified lossless by construction.
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

def _stretch_table():
    t=[0]*4096
    for i in range(4096):
        p=(i+0.5)/4096.0
        t[i]=max(-2047,min(2047,int(round(math.log(p/(1-p))*256))))
    return t
STR=_stretch_table()
def stretch(p12):            # p12 in 1..4095  -> stretched int
    return STR[p12] if 0<=p12<4096 else (2047 if p12>=4096 else -2047)
_SQ=[0]*4096
for _x in range(4096):
    v=(_x-2048)
    _SQ[_x]=max(1,min(4095,int(round(4096.0/(1.0+math.exp(-v/256.0))))))
def squash(s):              # stretched int -> p12 in 1..4095
    s=2047 if s>2047 else(-2047 if s<-2047 else s)
    return _SQ[s+2048]

TBITS=22; TSIZE=1<<TBITS; TMASK=TSIZE-1
RATE=5

def probs():
    import array
    return array.array('H', b'\x00\x08'*TSIZE)   # 0x0800 = 2048, little-endian

# ---- APM / SSE : refine a probability given a small context (Hodge step) ---
class APM:
    def __init__(s,n):
        import array
        s.t=array.array('H',bytes(2*n*33))
        for c in range(n):
            for j in range(33):
                s.t[c*33+j]=squash((j-16)*128)
        s.idx=0
    def pp(s,pr,ctx):
        st=stretch(pr)+2048
        j=st>>7; w=st&127
        s.idx=ctx*33+j
        return (s.t[s.idx]*(128-w)+s.t[s.idx+1]*w)>>7
    def update(s,bit):
        g=4095 if bit else 0
        s.t[s.idx]  += (g-s.t[s.idx])>>6
        s.t[s.idx+1]+= (g-s.t[s.idx+1])>>6

class Machine:
    def __init__(s):
        import array
        s.orders=[0,1,2,3,4,6,8]
        s.tabs=[probs() for _ in s.orders]
        s.wtab=probs(); s.pwtab=probs()          # word (partial) and prev-word
        s.mtab=probs()                            # match model (learned reliability)
        NM=len(s.orders)+4                        # +word,+pword,+match-table,+match-direct
        s.NM=NM
        s.w=[[0]*NM for _ in range(256)]          # context-selected mixer weights
        s.apm1=APM(256); s.apm2=APM(0x4000)
        s.hist=0; s.node=1; s.buf=bytearray(); s.pos=0
        s.word=0; s.pword=0                        # rolling hashes
        s.mhash=array.array('I',bytes(4*(1<<20))); s.mptr=0; s.mlen=0; s.pbyte=-1
        s.st=[0]*NM; s.idx=[0]*NM; s.pr=2048; s.mixc=0
        s.bitcount=0.0                             # running code length (bits)
    def _keys(s):
        h=s.hist; node=s.node; NM=s.NM; k=0
        for oi,o in enumerate(s.orders):
            ctx=h&((1<<(8*o))-1) if o>0 else 0
            s.idx[k]=((ctx*2654435761)^(node*0x9E3779B1)^(o*0x85EBCA6B))&TMASK; k+=1
        s.idx[k]=((s.word*2654435761)^(node*0x9E3779B1)^11)&TMASK; k+=1
        s.idx[k]=((s.pword*40503)^(node*0x9E3779B1)^13)&TMASK; k+=1
        predbit=(s.pbyte>>(7-(node.bit_length()-1)))&1 if s.pbyte>=0 else 0
        s.idx[k]=((predbit*0x55555555)^(node*0x33333333)^(min(s.mlen,28)<<3))&TMASK
    def _predict(s):
        s._keys()
        tp=s.tabs; NM=s.NM
        st=s.st
        for i in range(len(s.orders)): st[i]=stretch(tp[i][s.idx[i]])
        b=len(s.orders)
        st[b]  =stretch(s.wtab[s.idx[b]])
        st[b+1]=stretch(s.pwtab[s.idx[b+1]])
        st[b+2]=stretch(s.mtab[s.idx[b+2]])
        if s.pbyte>=0:
            predbit=(s.pbyte>>(7-(s.node.bit_length()-1)))&1
            strg=min(s.mlen,32)*24
            st[b+3]= strg if predbit else -strg
        else:
            st[b+3]=0
        s.mixc=(s.hist&0xFF)
        wv=s.w[s.mixc]
        dot=0
        for i in range(NM): dot+=wv[i]*st[i]
        p=squash(dot>>16)
        # two APM refinements (Hodge / SSE)
        p=(s.apm1.pp(p,(s.hist&0xFF))+p+1)>>1
        p=(s.apm2.pp(p,((s.hist&0x3F))| (min(s.mlen,63)<<6) )*3+p+2)>>2
        s.pr=1 if p<1 else (4095 if p>4095 else p)
        return s.pr
    def _update(s,bit):
        # code length bookkeeping (the learning curve)
        pp=s.pr/4096.0
        s.bitcount+=-math.log2(pp if bit else 1.0-pp)
        err=((bit<<12)-s.pr)*7
        wv=s.w[s.mixc]; st=s.st
        for i in range(s.NM):
            wv[i]+= (st[i]*err)>>16
        tp=s.tabs
        for i in range(len(s.orders)):
            k=s.idx[i]; v=tp[i][k]; tp[i][k]=v+(((bit<<12)-v)>>RATE)
        b=len(s.orders)
        for tab,k in ((s.wtab,s.idx[b]),(s.pwtab,s.idx[b+1]),(s.mtab,s.idx[b+2])):
            v=tab[k]; tab[k]=v+(((bit<<12)-v)>>RATE)
        s.apm1.update(bit); s.apm2.update(bit)
        s.node=(s.node<<1)|bit
    def byte_done(s,byte):
        if s.mptr and s.mptr<len(s.buf) and s.buf[s.mptr]==byte: s.mptr+=1;s.mlen+=1
        else: s.mptr=0;s.mlen=0
        s.buf.append(byte)
        if len(s.buf)>=5:
            key=0
            for j in range(len(s.buf)-5,len(s.buf)): key=(key*257+s.buf[j])&0xFFFFFFFF
            key&=(1<<20)-1
            if not s.mptr:
                c=s.mhash[key]
                if c: s.mptr=c; s.mlen=5
            s.mhash[key]=len(s.buf)
        s.pbyte=s.buf[s.mptr] if (s.mptr and s.mptr<len(s.buf)) else -1
        # word quotient: letters accrete into a word; a boundary finalizes it.
        low=byte|0x20
        if 97<=low<=122:
            s.word=((s.word*131)+low)&0xFFFFFFFF
        else:
            if s.word: s.pword=s.word
            s.word=0
        s.hist=((s.hist<<8)|byte)&((1<<64)-1); s.node=1; s.pos+=1

def compress(data:bytes)->bytes:
    enc=REnc(); M=Machine()
    for x in data:
        for kb in range(7,-1,-1):
            bit=(x>>kb)&1; p1=M._predict(); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,bit); M._update(bit)
        M.byte_done(x)
    payload=enc.finish()
    arc=b"SNGL"+struct.pack("<Q",len(data))+payload
    if decompress(arc)!=data: raise AssertionError("singularity: roundtrip certificate FAILED")
    compress.bits=M.bitcount
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"SNGL"; n,=struct.unpack_from("<Q",arc,4); dec=RDec(arc[12:])
    M=Machine(); out=bytearray()
    for _ in range(n):
        for _ in range(8):
            p1=M._predict(); p0=4096-p1
            p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0); M._update(bit)
        byte=M.node&0xFF; out.append(byte); M.byte_done(byte)
    return bytes(out)

def bench(data,label,curve=False):
    n=len(data); t0=time.time(); c=compress(data); dt=time.time()-t0
    rows=[("singularity",len(c)),("gzip-9",len(zlib.compress(data,9))),
          ("bz2-9",len(bz2.compress(data,9))),("lzma",len(lzma.compress(data,preset=9)))]
    print(f"\n{label}: {n} bytes  ({dt:.1f}s)")
    for nm,sz in rows: print(f"  {nm:12s} {sz:9d}  {n/sz:6.2f}x  {8*sz/n:5.3f} bpc")
    assert decompress(c)==data; print("  [certificate] roundtrip exact; zero model transmitted")

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]: bench(open(f,"rb").read(),f)
    else: print(__doc__)
