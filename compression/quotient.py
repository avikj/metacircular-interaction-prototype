#!/usr/bin/env python3
"""
quotient.py — singularity, but predicting over the OBSERVATIONAL QUOTIENT.

The limit of singularity was that it memorised: every raw context was a
separate cell, so equivalent contexts never shared statistics and novel
contexts started at 0.5.  That is the un-univalent lookup table.

This file implements the theory it was supposed to: symbols are quotiented by
observational equivalence (two symbols are identified when their successor-
CLASS distributions match — the Nerode congruence, iterated to a fixpoint =
the effective-quotient theorem = a pratyahara induced from the data), and
prediction runs over CONTEXTS OF CLASSES as well as raw bytes.  Equivalent
contexts collapse to one object, so they share statistics and a novel context
inherits its class's prediction (transport).  The class map is a deterministic
function of the causal past, so the decoder induces the identical classes —
zero model transmitted.  Certified lossless.

If the theory is right, the class models generalise, and the bits/char curve
keeps falling where singularity's plateaued.
"""
from __future__ import annotations
import sys, struct, zlib, bz2, lzma, math, time, array

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

def _tab():
    st=[0]*4096
    for i in range(4096):
        p=(i+0.5)/4096.0; st[i]=max(-2047,min(2047,int(round(math.log(p/(1-p))*256))))
    sq=[0]*4096
    for x in range(4096):
        sq[x]=max(1,min(4095,int(round(4096.0/(1.0+math.exp(-(x-2048)/256.0))))))
    return st,sq
STR,SQ=_tab()
def stretch(p): return STR[p] if 0<=p<4096 else (2047 if p>=4096 else -2047)
def squash(s):
    s=2047 if s>2047 else(-2047 if s<-2047 else s); return SQ[s+2048]

TBITS=22; TSIZE=1<<TBITS; TMASK=TSIZE-1; RATE=5
def probs(): return array.array('H', b'\x00\x08'*TSIZE)

class APM:
    def __init__(s,n):
        s.t=array.array('H',bytes(2*n*33))
        for c in range(n):
            for j in range(33): s.t[c*33+j]=squash((j-16)*128)
        s.idx=0
    def pp(s,pr,ctx):
        st=stretch(pr)+2048; j=st>>7; w=st&127; s.idx=ctx*33+j
        return (s.t[s.idx]*(128-w)+s.t[s.idx+1]*w)>>7
    def update(s,bit):
        g=4095 if bit else 0
        s.t[s.idx]+=(g-s.t[s.idx])>>6; s.t[s.idx+1]+=(g-s.t[s.idx+1])>>6

K=16                    # number of induced classes (pratyaharas)
CHUNK=2048              # deterministic re-induction period
class Machine:
    def __init__(s):
        s.orders=[0,1,2,3,4]                  # raw-byte memorisation
        s.corders=[2,3,4,6]                   # CLASS contexts: generalisation
        s.tabs=[probs() for _ in s.orders]
        s.ctabs=[probs() for _ in s.corders]
        s.wtab=probs(); s.mtab=probs()
        NM=len(s.orders)+len(s.corders)+3     # +word,+match,+match-direct
        s.NM=NM
        s.w=[[0]*NM for _ in range(256)]
        s.apm=APM(256)
        s.hist=0; s.chist=0; s.node=1; s.buf=bytearray(); s.pos=0
        s.word=0
        s.mhash=array.array('I',bytes(4*(1<<20))); s.mptr=0; s.mlen=0; s.pbyte=-1
        # observational-quotient state
        s.N=array.array('I',bytes(4*65536))   # N[prev*256+cur] successor counts
        s.cls=array.array('b',[i% K for i in range(256)])  # symbol -> class
        s.prev=0
        s.st=[0]*NM; s.idx=[0]*NM; s.pr=2048; s.mixc=0; s.bitcount=0.0
    # -- induce the Nerode quotient from the causal past (deterministic) ------
    def reinduce(s):
        N=s.N; cls=s.cls
        for _ in range(4):
            # signature[sym] = successor-CLASS distribution
            sig=[[0]*K for _ in range(256)]
            for a in range(256):
                base=a<<8; row=sig[a]
                for b in range(256):
                    c=N[base+b]
                    if c: row[cls[b]]+=c
            # class centroids = summed (unnormalised) signatures
            cent=[[0]*K for _ in range(K)]; cnt=[0]*K
            for a in range(256):
                tot=sum(sig[a])
                if tot==0: continue
                ck=cls[a]; ca=cent[ck]; cnt[ck]+=1
                inv=1.0/tot
                for k in range(K): ca[k]+=sig[a][k]*inv
            cnorm=[]
            for k in range(K):
                if cnt[k]:
                    cnorm.append([cent[k][j]/cnt[k] for j in range(K)])
                else:
                    cnorm.append(None)
            # reassign each symbol to nearest centroid (cosine-ish via dot on L1-norm)
            for a in range(256):
                tot=sum(sig[a])
                if tot==0: continue
                inv=1.0/tot; v=[sig[a][k]*inv for k in range(K)]
                best=cls[a]; bd=-1.0
                for k in range(K):
                    cc=cnorm[k]
                    if cc is None: continue
                    d=0.0
                    for j in range(K): d-=(v[j]-cc[j])*(v[j]-cc[j])
                    if d>bd: bd=d; best=k
                cls[a]=best
    def _keys(s):
        h=s.hist; ch=s.chist; node=s.node; k=0
        for o in s.orders:
            ctx=h&((1<<(8*o))-1) if o>0 else 0
            s.idx[k]=((ctx*2654435761)^(node*0x9E3779B1)^(o*0x85EBCA6B))&TMASK; k+=1
        for o in s.corders:
            cctx=ch&((1<<(4*o))-1)
            s.idx[k]=((cctx*2246822519)^(node*0x9E3779B1)^(o*374761393))&TMASK; k+=1
        s.idx[k]=((s.word*2654435761)^(node*0x9E3779B1)^11)&TMASK; k+=1  # word
        predbit=(s.pbyte>>(7-(node.bit_length()-1)))&1 if s.pbyte>=0 else 0
        s.idx[k+1]=((predbit*0x55555555)^(node*0x33333333)^(min(s.mlen,28)<<3))&TMASK  # match tab
    def _predict(s):
        s._keys(); st=s.st; no=len(s.orders); nc=len(s.corders)
        for i in range(no): st[i]=stretch(s.tabs[i][s.idx[i]])
        for i in range(nc): st[no+i]=stretch(s.ctabs[i][s.idx[no+i]])
        b=no+nc
        st[b]=stretch(s.wtab[s.idx[b]])
        st[b+1]=stretch(s.mtab[s.idx[b+1]])
        if s.pbyte>=0:
            predbit=(s.pbyte>>(7-(s.node.bit_length()-1)))&1
            strg=min(s.mlen,32)*24; st[b+2]= strg if predbit else -strg
        else: st[b+2]=0
        s.mixc=s.hist&0xFF; wv=s.w[s.mixc]; dot=0
        for i in range(s.NM): dot+=wv[i]*st[i]
        p=squash(dot>>16)
        p=(s.apm.pp(p,s.hist&0xFF)*3+p+2)>>2
        s.pr=1 if p<1 else(4095 if p>4095 else p); return s.pr
    def _update(s,bit):
        pp=s.pr/4096.0; s.bitcount+=-math.log2(pp if bit else 1.0-pp)
        err=((bit<<12)-s.pr)*7; wv=s.w[s.mixc]; st=s.st
        for i in range(s.NM): wv[i]+=(st[i]*err)>>16
        no=len(s.orders); nc=len(s.corders)
        for i in range(no):
            k=s.idx[i]; v=s.tabs[i][k]; s.tabs[i][k]=v+(((bit<<12)-v)>>RATE)
        for i in range(nc):
            k=s.idx[no+i]; v=s.ctabs[i][k]; s.ctabs[i][k]=v+(((bit<<12)-v)>>RATE)
        b=no+nc
        for tab,k in ((s.wtab,s.idx[b]),(s.mtab,s.idx[b+1])):
            v=tab[k]; tab[k]=v+(((bit<<12)-v)>>RATE)
        s.apm.update(bit); s.node=(s.node<<1)|bit
    def byte_done(s,byte):
        s.N[(s.prev<<8)|byte]+=1; s.prev=byte
        if s.mptr and s.mptr<len(s.buf) and s.buf[s.mptr]==byte: s.mptr+=1;s.mlen+=1
        else: s.mptr=0;s.mlen=0
        s.buf.append(byte)
        if len(s.buf)>=5:
            key=0
            for j in range(len(s.buf)-5,len(s.buf)): key=(key*257+s.buf[j])&0xFFFFFFFF
            key&=(1<<20)-1
            if not s.mptr:
                c=s.mhash[key]
                if c: s.mptr=c;s.mlen=5
            s.mhash[key]=len(s.buf)
        s.pbyte=s.buf[s.mptr] if (s.mptr and s.mptr<len(s.buf)) else -1
        low=byte|0x20
        s.word=((s.word*131)+low)&0xFFFFFFFF if 97<=low<=122 else 0
        s.hist=((s.hist<<8)|byte)&((1<<64)-1)
        s.chist=((s.chist<<4)|(s.cls[byte]&0xF))&((1<<64)-1)
        s.node=1; s.pos+=1
        if s.pos%CHUNK==0: s.reinduce()

def compress(data:bytes)->bytes:
    enc=REnc(); M=Machine()
    for x in data:
        for kb in range(7,-1,-1):
            p1=M._predict(); p0=4096-p1; p0=1 if p0<1 else(4095 if p0>4095 else p0)
            enc.bit(p0,(x>>kb)&1); M._update((x>>kb)&1)
        M.byte_done(x)
    payload=enc.finish(); arc=b"QUOT"+struct.pack("<Q",len(data))+payload
    if decompress(arc)!=data: raise AssertionError("quotient: roundtrip certificate FAILED")
    compress.bits=M.bitcount; compress.cls=list(M.cls)
    return arc

def decompress(arc:bytes)->bytes:
    assert arc[:4]==b"QUOT"; n,=struct.unpack_from("<Q",arc,4); dec=RDec(arc[12:])
    M=Machine(); out=bytearray()
    for _ in range(n):
        for _ in range(8):
            p1=M._predict(); p0=4096-p1; p0=1 if p0<1 else(4095 if p0>4095 else p0)
            bit=dec.bit(p0); M._update(bit)
        byte=M.node&0xFF; out.append(byte); M.byte_done(byte)
    return bytes(out)

if __name__=="__main__":
    if sys.argv[1:] and sys.argv[1]=="bench":
        for f in sys.argv[2:]:
            d=open(f,"rb").read(); c=compress(d); n=len(d)
            print(f"{f}: {n} -> {len(c)}  {8*len(c)/n:.3f} bpc")
    else: print(__doc__)
